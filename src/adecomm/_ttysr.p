/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------
File: _ttysr.p

Description:
    This routine is part of the UIB Character Run Window capability,
    which consists of the following procedures, scripts/batch files:

    * adeuib/_ttyss.p  PROGRESS
          Establishes the PROGRESS Winchar client session by calling
          _progres directly (Windows).
          Writes the RUN messages via the character message/command
          file (e.g., p12345m.tty) to the PROGRESS Character session.

    * adecomm/_ttysr.p  PROGRESS
          Startup procedure of the PROGRESS Character session which
          executes the UIB temp file in the Character Run Window
          (xterm under Motif; DOS Shell under Windows).

    * adeuib/_ttysx.p  PROGRESS
          Closes the Character Run Window by deleting the command .tty file.

    * $DLC/bin/ttysx     /dev/sh
          Executes the UIB Character Run Window as a UNIX character client
          in an xterm window.

    * <run_tty_name>  UNIX/DOS-file
          Used as message/command channel between UIB and its Character Run
          Window. Has the form "p12345m.tty".
                                                     
Input-Parameters:

Output-Parameters:
    
Author:  John Palazzo, adapted from 7.3A (Tom Hutegger).
    
History:
    jep         94/10/24    Updated for running under Unix and DOS.
    hutegger    94/02/04    Created.
--------------------------------------------------------------------*/        

/*----------------------------  PREPROCESSOR ---------------------------*/

DEFINE VARIABLE dlc_dir      AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE dlcbin_dir   AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE tty_command  AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE db_connects  AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE cmd_i        AS INTEGER                   NO-UNDO.
DEFINE VARIABLE os_slash     AS CHARACTER                 NO-UNDO.

DEFINE VARIABLE command      AS CHARACTER FORMAT "x(72)"  NO-UNDO.
DEFINE VARIABLE cmd_line     AS CHARACTER FORMAT "x(256)" NO-UNDO.
DEFINE VARIABLE run_tty_name AS CHARACTER FORMAT "x(40)"  NO-UNDO.
DEFINE VARIABLE debug_set    AS LOGICAL                   NO-UNDO.
DEFINE VARIABLE tty_init     AS LOGICAL                   NO-UNDO.
DEFINE VARIABLE code_page    AS CHARACTER                 NO-UNDO.

/*--------------------  LANGUAGE-DEPENDENCIES  ---------------------*/

DEFINE VARIABLE errmsg       AS CHARACTER FORMAT "x(72)" EXTENT 5
   INITIAL [
   /*  1 */ "Received no procedure.  Exiting...      ",                 
   /*  2 */ "Initializing Character Run Window...    ",
   /*  3 */ "           Cannot find file:            ",                 
   /*  4 */ "       Received unknown command:        ",
   /*  5 */ "Procedure complete. Waiting for next run."
           ].
   /*       "....+....1....+....22....+....1....+...."        */

DEFINE VARIABLE errstat       AS CHARACTER FORMAT "x(10)" EXTENT 2
    INITIAL [
   /*  1 */ "unknown-command",
   /*  2 */ "unknown-file"                      ].


/*-----------------------------  FORMS  ----------------------------*/

FORM
  command skip
  cmd_line  format "x(76)"
  with centered row 12
  overlay no-labels
  title "  ERROR  "
  frame fehler.
  
FORM
  command skip
  cmd_line  format "x(76)"
  with centered row 2
  overlay no-labels
  title "  Status  "
  frame protocol.

MAIN:
DO:

/* Initialize some variables. */
/* For run_tty_name, on UNIX we could query OS-GETENV("RUN_TTY_NAME")
   as well. For consistency, we'll read the SESSION:PARAM like we do
   for DOS.
*/
ASSIGN run_tty_name = SESSION:PARAM
       tty_init     = TRUE
. /* END ASSIGN */

/* If we didn't get the base name of the UIB's TTY message file, report
   an error and QUIT.
*/
IF run_tty_name = "" OR run_tty_name = ? THEN
DO:
    DISPLAY
        errmsg[1] @ command WITH FRAME fehler.
    QUIT.
END.

/* Initialize some more variables. */

GET-KEY-VALUE SECTION "WinChar Startup" KEY "DLC" VALUE dlc_dir.
IF dlc_dir = ? OR dlc_dir = "" THEN
  ASSIGN dlc_dir = OS-GETENV ("DLC").
IF dlc_dir = ? THEN
  ASSIGN dlc_dir = "c:/dlc".


ASSIGN tty_command  = run_tty_name
       os_slash     = ( IF LOOKUP(OPSYS , "MSDOS,WIN32":u) > 0
                        THEN "~\" ELSE "/" )
       dlcbin_dir   = dlc_dir + os_slash + "bin" + os_slash
       code_page    = SESSION:STREAM
. /* END ASSIGN */

TTY_RUN:
REPEAT WHILE cmd_line <> "OK-EXIT"
       ON QUIT,       LEAVE TTY_RUN
       ON STOP  UNDO, LEAVE TTY_RUN
       ON ERROR UNDO, LEAVE TTY_RUN:

    HIDE ALL NO-PAUSE.
    DISPLAY
        errmsg[IF tty_init then 2 else 5] @ command
        WITH FRAME protocol.
    IF tty_init = TRUE THEN
        ASSIGN tty_init = FALSE.
        
    /* Now loop and wait until the UIB session sends a message. */
    READ_COMMAND:
    DO WHILE TRUE:
        /* Pause a second to allow time for UIB session to write its command
           message into the message file.
        */
        PAUSE 1 NO-MESSAGE. 
        /* If the tty message file has been deleted, that indicates its
           time to terminate the tty client session.
        */
        IF ( SEARCH( tty_command ) = ? ) THEN LEAVE TTY_RUN.
        
        /* Read the contents of the command file and take action. */ 
        INPUT FROM VALUE( tty_command ) NO-ECHO.
        IMPORT UNFORMATTED cmd_line.
        
        /* Check the command file's stream code page. If its not the
           same as this session's, we must reopen the file with the
           correct stream code page. 
           
           The stream code page for the command file is the first
           item in the command string.
           
           For example:  "ibm850|RUN|p12345|DB=-db demo -ld demo"
        */
        ASSIGN code_page = ENTRY( 1 , cmd_line , "|") .
        IF code_page <> SESSION:STREAM THEN
        DO:
            INPUT CLOSE.
            INPUT FROM VALUE( tty_command ) NO-ECHO CONVERT SOURCE code_page.
            IMPORT UNFORMATTED cmd_line.
        END.
        INPUT CLOSE.

        /* Remove the stream code page information and its delimiter
           from the cmd_line.
        */
        ASSIGN cmd_line = REPLACE( cmd_line , code_page + "|" , "" ).
        
        /* If we received a message back from the UIB session, then we exit
           the loop and process the command.
        */
        IF cmd_line BEGINS "RUN" THEN LEAVE READ_COMMAND.
    END. 

    /* If there are databases to connect, cmd_line has the form:
          RUN|p12345|DB=-db demo -ld demo -db sports -ld sports

       We strip out database connection information into db_connects and use it
       in a CONNECT statement. If there are no databases to connect, the "|DB="
       will not be in the command string.
    */
    ASSIGN cmd_i = INDEX( cmd_line , "|DB=" )
    . /* END ASSIGN */
    IF ( cmd_i <> 0 ) THEN DO:
        db_connects = SUBSTRING(cmd_line,cmd_i + LENGTH("|DB=":u,"CHARACTER":u),
                                -1,"CHARACTER":u).

        /* CheckConnected removes from the db connection list any db's that
           are already connected. This can happen if the user specifies
           databases in the PROGRESS default parameter file startup.pf.
        */
        IF NUM-DBS > 0 THEN
            RUN CheckConnected ( INPUT-OUTPUT db_connects ).

        /* Connect the databases. */
        IF ( db_connects <> "" ) THEN
        DO ON STOP  UNDO TTY_RUN, LEAVE TTY_RUN
           ON ERROR UNDO TTY_RUN, LEAVE TTY_RUN:
            CONNECT VALUE( db_connects ).
        END.
        /* Strip off the database connect info from cmd_line, leaving
           RUN|p12345.
        */
        ASSIGN cmd_line = SUBSTRING(cmd_line,1,cmd_i - 1,"CHARACTER":u).
    END.

    /* Parse the UIB TTY command. */    
    ASSIGN
        cmd_i   = INDEX(cmd_line,"|":u)
        command = (IF cmd_i = 0 THEN cmd_line
                   ELSE SUBSTRING(cmd_line,1,cmd_i - 1,"CHARACTER":u))
        cmd_line = SUBSTRING(cmd_line,cmd_i + 1,-1,"CHARACTER":u)
    . /* END ASSIGN */

    /* Process and execute the command, such as run the UIB temp file. */
    CASE command:
    
        WHEN "RUN" OR WHEN "RUN-DEBUG" THEN DO:
            IF SEARCH( cmd_line ) <> ? THEN DO:
                HIDE ALL NO-PAUSE.
                DO ON STOP UNDO, LEAVE:
                    /* Without this set to true, Progress messages can flash
                       by and be unreadble.
                    */
                    ASSIGN SESSION:SYSTEM-ALERT-BOXES = TRUE.
                    IF command = "RUN-DEBUG" THEN
                        ASSIGN debug_set = DEBUGGER:INITIATE()
                               debug_set = DEBUGGER:SET-BREAK( cmd_line , -1).

                    RUN VALUE( cmd_line ).
                END.
                ASSIGN cmd_line = "OK".
      
                /* Clean up after a Debugger Run */
                IF command = "RUN-DEBUG" THEN
                     ASSIGN DEBUGGER:VISIBLE = FALSE
                            debug_set        = DEBUGGER:CLEAR().
            END.
            ELSE DO:
              PAUSE 0 NO-MESSAGE.
              DISPLAY
                errmsg[3] @ command 
                SUBSTRING(cmd_line,
                  MAXIMUM(LENGTH(cmd_line,"CHARACTER":u) - 26,1),-1,
                  "CHARACTER":u) @ cmd_line
              WITH FRAME fehler.
              ASSIGN cmd_line = errstat[2].
            END.
        END.
        
        WHEN "OK-EXIT" THEN ASSIGN cmd_line = "OK-EXIT".
        
        OTHERWISE DO:
            PAUSE 0 NO-MESSAGE.
            DISPLAY errmsg[4] @ command cmd_line with frame fehler.
            ASSIGN cmd_line = errstat[1].
        END.
    END. /* CASE */
   
   IF SEARCH( tty_command ) <> ? THEN DO:
       /* Add the stream code page to command string. */
       ASSIGN cmd_line = code_page + "|" + cmd_line .
       OUTPUT TO VALUE( tty_command ) UNBUFFERED NO-ECHO
                 CONVERT TARGET code_page .
       PUT UNFORMATTED cmd_line SKIP.
       OUTPUT CLOSE.
   END.

END.    /* TTY_RUN: REPEAT */

/* Clean up UIB tty session and quit Progress DOS client. */
HIDE ALL NO-PAUSE.
OS-DELETE VALUE( tty_command ).
QUIT.

END. /* MAIN */


PROCEDURE CheckConnected .
  /* Given a db connection list, return a db connection list without
     the databases that are already connected.
  */
  DEFINE INPUT-OUTPUT PARAMETER p_db_connects AS CHARACTER NO-UNDO.

  DEFINE VARIABLE ldb_name AS CHARACTER NO-UNDO.
  DEFINE VARIABLE db_entry AS CHARACTER NO-UNDO.
  DEFINE VARIABLE db_i     AS INTEGER   NO-UNDO.

  DO db_i = 1 TO NUM-DBS:
      IF p_db_connects = "" THEN LEAVE.
      ASSIGN ldb_name = LDBNAME( db_i ).
      IF DBTYPE( ldb_name ) <> "PROGRESS":U THEN NEXT.
      /* If the connected database is also on our list, remove it. */
      IF INDEX( p_db_connects , "-ld " + ldb_name ) > 0 THEN
      DO:
          ASSIGN db_entry = "-db " + PDBNAME( db_i ) + " " +
                            "-ld " + ldb_name .
          /* Remove this db from the connect list passed. */
          ASSIGN p_db_connects = TRIM(REPLACE(p_db_connects , db_entry , "")) .
      END.
  END.

END PROCEDURE.
