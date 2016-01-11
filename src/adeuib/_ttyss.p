/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/********************************************************************/
/* Encrypted code which is part of this file is subject to the      */
/* Possenet End User Software License Agreement Version 1.0         */
/* (the "License"); you may not use this file except in             */
/* compliance with the License. You may obtain a copy of the        */
/* License at http://www.possenet.org/license.html                  */
/********************************************************************/

/*--------------------------------------------------------------------
File: _ttyss.p

Description:
    This routine is part of the AB Character Run Window capability,
    which consists of the following procedures, scripts/batch files:

    * adeuib/_ttyss.p  PROGRESS
          Establishes the PROGRESS Winchar client session by calling
          _progres directly (Windows) or running script ttysx (Motif).
          Writes the RUN messages via the character message/command
          file (e.g., p12345m.tty) to the PROGRESS Character session.

    * adecomm/_ttysr.p  PROGRESS
          Startup procedure of the PROGRESS Character session which
          executes the AB temp file in the Character Run Window
          (xterm under Motif; DOS Shell under Windows).

    * adeuib/_ttysx.p  PROGRESS
          Closes the Character Run Window by deleting the command .tty file.

    * $DLC/bin/ttysx     /dev/sh
          Executes the AB Character Run Window as a UNIX character client
          in an xterm window.

    * <run_tty_name>  UNIX/DOS-file
          Used as message/command channel between AB and its Character Run
          Window. Has the form "p12345m.tty".

Input-Parameters:
    p_command CHAR Command written to AB Character Message file (*m.tty).
                   RUN       - Runs specified character window.
                   RUN-DEBUG - Debugs specified character window.
                   
    p_param   CHAR Tempfile name to be run by AB Character Run window.

Shared Var
    s_tmp-file CHAR
          UNIX/DOS-file
          Used as message/command channel between AB and its Character Run
          Window. Has the form "p12345m.tty".

Output-Parameters: None

Author:  John Palazzo, adapted from 7.3A (Tom Hutegger).

History:
    jep         20 Oct 00   Code and comment updates for POSSE release.
    jep         29 Oct 96   Updated for running 32-bit WinChar console client.
    jep         24 Oct 94   Updated for running under Unix and DOS.
    hutegger    04 Oct 94   Created.
--------------------------------------------------------------------*/


/*----------------------------  PREPROCESSOR ---------------------------*/

DEFINE INPUT PARAMETER /* VARIABLE */ p_command  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER /* VARIABLE */ p_param    AS CHARACTER NO-UNDO.

DEFINE SHARED VARIABLE s_tmp-file AS CHARACTER.

DEFINE VARIABLE dlc_dir      AS CHARACTER                NO-UNDO.
DEFINE VARIABLE dlcbin_dir   AS CHARACTER                NO-UNDO.
DEFINE VARIABLE db_connects  AS CHARACTER                NO-UNDO.
DEFINE VARIABLE tty_command  AS CHARACTER                NO-UNDO.
DEFINE VARIABLE tty_params   AS CHARACTER                NO-UNDO.
DEFINE VARIABLE tty_proexe   AS CHARACTER                NO-UNDO INIT "_progres.exe":U.
DEFINE VARIABLE ini_proexe   AS CHARACTER                NO-UNDO.
DEFINE VARIABLE db_i         AS INTEGER                  NO-UNDO.
DEFINE VARIABLE os_slash     AS CHARACTER                NO-UNDO.
DEFINE VARIABLE cmd_line     AS CHARACTER FORMAT "x(75)" NO-UNDO.
DEFINE VARIABLE os_command   AS CHARACTER                NO-UNDO.
DEFINE VARIABLE code_page    AS CHARACTER                NO-UNDO.
DEFINE VARIABLE file_ext     AS CHARACTER                NO-UNDO.

DEFINE VARIABLE errmsg       AS CHARACTER EXTENT 2
    INITIAL
        [
        /*  1 */ "Received unknown command:",
        /*  2 */ "Character Terminal - RETURN-MESSAGE:"
        ].

/* Check that we have a valid command. */
IF p_command = "" THEN
DO ON STOP UNDO, RETURN ERROR:
    MESSAGE errmsg[1] VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

/* Initialize command line. Sample command lines:
    "RUN|p12345.ab"   :
        where p_command = "RUN" and p_param = "p12345.ab"
*/
ASSIGN cmd_line = ( IF p_param = "" THEN p_command
                                    ELSE p_command + "|" + p_param)
. /* END ASSIGN */

/* Add the stream code page to the front of the command line. This
   ensures that the Character Run Window client can properly read
   the command file.  Its possible for the AB client to have
   started its session with a -cpstream (Stream Code Page) setting
   different than the Character client.
   
   The character client will read the command line string and
   check the code page and re-open the file with the correct code
   page as needed.  The Character client can read and check the
   stream code page because the first 128 (0-127) characters of all
   code pages are the US-ASCII characters, and code page names are
   made up of US-ASCII (0-127) characters.
*/
ASSIGN  code_page  = SESSION:STREAM
        cmd_line   = code_page + "|" + cmd_line .

/* Get a unique name for the AB-Character message file, if we don't already
   have one.
*/
IF ( s_tmp-file = "" ) THEN
    RUN adecomm/_tmpfile.p (s_tmp-file, "m.tty" , OUTPUT s_tmp-file). 

/* Find where character Progress is installed so later we can locate
   the character executable. */
GET-KEY-VALUE SECTION "WinChar Startup" KEY "DLC" VALUE dlc_dir.
IF (dlc_dir = ?) OR (dlc_dir = "") THEN
DO:
  ASSIGN dlc_dir = OS-GETENV ("DLC").
END.
IF (dlc_dir = ?) THEN
DO:
  /* Search for default Progress installation directory on Windows. */
  ASSIGN dlc_dir             = "C:~\Program Files~\Progress"
         FILE-INFO:FILE-NAME = dlc_dir
         dlc_dir             = FILE-INFO:FULL-PATHNAME.
  IF (dlc_dir = ?) THEN /* Last ditch effort. */
    ASSIGN dlc_dir = "C:~\DLC".
END.
  
ASSIGN tty_command  = s_tmp-file
       os_slash     = ( IF LOOKUP(OPSYS, "MSDOS,WIN32":u) > 0
                        THEN "~\" ELSE "/" )
       dlcbin_dir   = dlc_dir + os_slash + "bin" + os_slash.

/* If we can't find the character client executable, tell the user & return.
   For Unix, we let the ttysx script find the character client.
*/
IF OPSYS = "WIN32":U THEN
DO ON STOP UNDO, RETURN ERROR:
  GET-KEY-VALUE SECTION "WinChar Startup" KEY "PROEXE" VALUE ini_proexe.
  IF (ini_proexe = ?) THEN
    ASSIGN tty_proexe = dlcbin_dir + tty_proexe.
  ELSE
    ASSIGN tty_proexe = ini_proexe.
  /* Add ".exe" if its not there. */
  RUN adecomm/_osfext.p
     (INPUT  tty_proexe  /* OS File Name.   */ ,
      OUTPUT file_ext    /* File Extension. */ ).
  IF (file_ext <> ".exe") THEN
    ASSIGN tty_proexe = tty_proexe + ".exe".
  ASSIGN tty_proexe = CAPS(tty_proexe).
  IF (SEARCH(tty_proexe) = ?) THEN
  DO:
    CASE ini_proexe:
      WHEN ? THEN /* PROEXE was not set in registry/ini file. */
        MESSAGE tty_proexe SKIP
            "Unable to find Character Client executable." SKIP(1)
            "The Progress Character Client product must be installed to run character files."
            VIEW-AS ALERT-BOX ERROR.
      OTHERWISE   /* PROEXE was set in registry/ini file. */
        MESSAGE tty_proexe SKIP
            "Unable to find Character Client executable based on PROEXE setting." SKIP(1)
            "Check that the WinChar Startup PROEXE registry or .ini setting is correct and that"
            "the Progress Character Client product is installed."
            VIEW-AS ALERT-BOX ERROR.
    END CASE.
    RETURN ERROR.
  END.
END.


/* Build list of connected PROGRESS databases to pass onto tty session. 
   If the Character Run Window is already open, it will only connect
   to those databases not already connected.
*/
ASSIGN db_connects = "".
IF NUM-DBS > 0 THEN
DO:
    DO db_i = 1 TO NUM-DBS:
        IF DBTYPE( LDBNAME(db_i) ) <> "PROGRESS":U THEN NEXT.
        ASSIGN db_connects = db_connects + " -db " + PDBNAME(db_i)
               + " -ld " + LDBNAME(db_i) + " ".
    END.
END.
/* Now append the database connection list to the message line command. */
IF ( db_connects <> "" ) THEN
    ASSIGN cmd_line = cmd_line + "|DB=" + db_connects.

/* Check for a AB tty message file. If it exists, then no need to create
   another tty session. If it's not there, create it and then shell to
   opsys and start a multi-user Progress tty client session.
*/ 
IF SEARCH( tty_command ) = ? THEN
DO:
    /* Write the command message in the tty command file. The -p startup
     procedure to the tty session will be looking for this file.
     When found, it will read its contents and run the AB temporary file
     in the tty session.
    */
    OUTPUT TO VALUE( tty_command ) UNBUFFERED NO-ECHO.
    PUT UNFORMATTED cmd_line SKIP.
    OUTPUT CLOSE.
    
    /* Shell to opsys and start multi-user tty client session. */
    /* Character client parameter notes:
         -param : Specifies name of the AB TTY message file. This comes
                  from s_tmp-file.

             -T : Specifies that character client temporary directory
                  be the same as the AB GUI session. This enables
                  character client to find the message file. This comes
                  from SESSION:TEMP-DIR.
    */ 
    ASSIGN tty_params = SUBSTITUTE("-p adecomm/_ttysr.p -param &1 -T &2", s_tmp-file, SESSION:TEMP-DIR).
    IF LOOKUP(OPSYS, "MSDOS,WIN32":u) > 0 THEN
    DO:
        /* Enclose executable path in double quotes to handle when path contains
           spaces. For example: C:\Program Files\Progress\Bin\_progres.exe. */
        ASSIGN os_command = '"' + tty_proexe + '" ' + tty_params.
        /* Start the Window character run client. */
        RUN StartWinCharClient (os_command).  /* OS-COMMAND NO-WAIT VALUE(os_command). */
    END.
    ELSE /* OPSYS = "UNIX" */
    DO:
        /* For UNIX, execute ttysx script, passing first the UIB's TTY
           message file name and then all the UNIX character client
           startup parameters. The ttysx script will remove the TTY
           message file for normal client exit and abnormal terminations.

           We must surround the remaining startup parameters with single
           quotes so ttysx will recognize the whole string as one argument.
        */
        ASSIGN os_command = "ttysx " + s_tmp-file + " '" + tty_params + " '" + " &".
        /* Start the UNIX character run client. */
        RUN StartUnixCharClient (os_command).  /* OS-COMMAND SILENT VALUE(os_command). */
    END.     
END.  /* IF SEARCH( tty_command ) = ? */
ELSE
DO: /* Message file already exists. */
    /* Overwrite the command message in the tty command file. The -p
       startup procedure to the tty session will be looking for this
       file. When found, it will read its contents and run the UIB
       temporary file in the tty session.
    */
    OUTPUT TO VALUE( tty_command ) UNBUFFERED NO-ECHO.
    PUT UNFORMATTED cmd_line SKIP.
    OUTPUT CLOSE.
END.

/* Now loop and wait until the tty session writes a return message
   and take the needed action.
   
   The check if the message file exists allows the user to manually
   remove the tty message file as a "hard-kill" of the AB tty run.
*/

READ_COMMAND:
DO WHILE TRUE:
    /* Pause a second to allow time for tty session to write its command
       message into the message file.
    */
    PAUSE 1 NO-MESSAGE.
    /* If the tty message file has been deleted, that indicates its
       time to terminate the tty client session.
    */
    IF ( SEARCH( tty_command ) = ? ) THEN RETURN.
    /* Read the contents of the message file and take action. */ 
    INPUT FROM VALUE( tty_command ) NO-ECHO.
    SET cmd_line.
    INPUT CLOSE.

    /* Remove the stream code page information and its delimiter
       from the cmd_line.
    */
    ASSIGN cmd_line = REPLACE( cmd_line , code_page + "|" , "" ).

    /* If we received a message back from the tty session, then we exit
       the loop and process the command.
    */
    IF NOT cmd_line BEGINS "RUN" THEN LEAVE READ_COMMAND.
END. 

IF NOT ( cmd_line BEGINS "OK" ) THEN
DO ON STOP UNDO, RETURN ERROR:
    MESSAGE errmsg[2] cmd_line VIEW-AS ALERT-BOX ERROR BUTTONS OK.
END.

/* If the tty client session is terminated, cleanup the tty_command file.
*/
IF ( cmd_line = "OK-EXIT" ) THEN
    OS-DELETE VALUE( tty_command ).

{adeuib/_ttyss.i} /* Character run support procedures. */
