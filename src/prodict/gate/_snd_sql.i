/************************************************************************
* Copyright (C) 2000,2008,2009 by Progress Software Corporation. All    *
* rights reserved. Prior versions of this work may contain portions     *
* contributed by participants of Possenet.                              *
*                                                                       *
************************************************************************/

/*--------------------------------------------------------------------

file: _snd_sql.i - Send.SQL to foreign DB to create db-objects
 
Author:     Rob Adams

Component:  Protoxxx   (progress to foreign datamanager)

Purpose:    Read in SQL from a file created by _wrktgen.p
            and use SEND-SQL-STATEMENT stored procedure
            to perform each command inside foreign data manager. 

            NOTE: The output of this file can be adjusted 
                 by using the local environment variables 
                 and the dataserver dependent section at 
                 begining of the code.

Text Parameters:
    &DEBUG          "DEBUG" or ""  for  want debugging output or not 

Input Parameters:
    p_cmmnt-chr     character-string to indicate a comment line
    p_debug         debugging output wanted or not
    p_db-name       name of 
    p_eosttmnt      end of statement ("go" or ";")
    p_owner         only used for oracle
    p_sql-file      name of sql-file to apply
    
Output Parameters:
    none

Used/Changed Shared Objects:
    logfile         Logfile for errors and/or debugging-messages
                    if we're in batchmode, need to output something but
                    it's not yet open (i.e. logfile_open = false),
                    we open it to the file p_sql-file (with ".sql"
                    replaced by ".log")
    logfile_open    gets set to true:
                    if there is an error and we're in batchmode and 
                    logfile_open = false.
                    
History:    
    31 March 2000 D. McMann Added MSS DataServer

    21 Sep 1995  Hutegger Made program batch-runnable by allowing output
                          being sent to file; in the process moved all 
                          output to internal routine (error_handling) and
                          added a couple of comments to end statments to 
                          make program easier to read...
                          replaced &DEBUG preprocessor variable with
                          parameter p_debug
     2 Aug 1995  Hutegger Moved code from _snd_sql.i to _snd_sql.p and
                          generalized this routine to be useable standalone
                          too (UI: prodict/send_sql.p)
    22 Jun 1995  DAN      Debugging. code get debug output just set 
                          debuggin var to yes.
    19 Jul 1995  RLA      Add rejection of object type = 10 to oracle drop 
                          logic.
     6 Sep 1994  RLA      Add Oracle drop logic. 
                          Add batch mode output functions
                          Add switching from chained to unchained mode.
                          Add object failure notification. 
     6 Jul 1994  RLA      add some output to let user know we're working
     7 Jun 1994  davidn   Added informix specific dependencies.

                          Added comit1_per_stmt  to the local
                          environment.  With the idea that some
                          dataserver do not like to have a comit
                          after every statement.(like informix) 
                        
                          NOTE: The clear_buffers flage is part 
                          of a work around for a bug in running 
                          stored procs.  If there is no output to 
                          retrieve from the dataserver after the 
                          sql statement has been sent, some data
                          servers send back an error message that 
                          progress does not yet no how to handle.
                          Udi is currently working on this, and it
                          should be fixed soon. When the fix goes in,
                          we should be able to get rid of the clear_
                          buffers flag
                          -----davidn 7 Jun 1994 
     2 Jun 1994  RLA      Make generic for all datamanagers. 
    19 May 1994  RLA      Creation.
    3  Mar 1996  aluk     Added support for ODBC in general.
    11/24/97     DLM      Added view-as dialog-box in non TTY clients
    03/08/99     DLM      Added check for statement terminator of go
    03/23/99     DLM      Added check for ; for oracle is really end of statement
    04/22/99     DLM      Changed check for dropping to see if 1 or more objects
                          exists with name.
    03/13/00     DLM      Added change for Oracle to determine what version so the
                          proper field name is used type or type# 20000320022
    11/19/01     DLM      Changed check for sqlnet connection string parsing
    08/11/08     ashukla  LDAP support (CR#OE00172458)
    10/13/09     rkumar   Sybase DataServer OE00164101- Set comit1_per_stmtm to TRUE

/* 
 * TODO: Add error handling to deal w/ errors returned 
 * from the various dataservers. For now we will only 
 * print them to the screen if debugging is turned on 
 */ 
--------------------------------------------------------------------*/
/*h-*/

define input parameter p_cmmnt-chr  as character.
define input parameter p_db-name    as character.
define input parameter p_debug      as logical.
define input parameter p_eosttmnt   as character.
define input parameter p_owner      as character.
define input parameter p_sql-file   as character.

define shared variable logfile_open as logical no-undo.
define shared stream   logfile.

define variable add_cr          as logical initial TRUE.
define variable batch_mode      as logical.
define variable change_chained_mode    as logical initial FALSE. 
define variable check_for_drop  as logical.
define variable clear_buffers   as logical   initial true. 
define variable closeall        as logical   initial TRUE.
define variable create_line     as character.
define variable creating        as character extent 2 no-undo.
define variable comit1_per_stmt AS logical   initial TRUE. 
define variable drop_indicator  as character. 
define variable drop_line       as character.
define variable drop_terminator as logical   initial FALSE.
define variable dropit          as logical.
define variable function_performed     as logical.
define variable h               as integer   no-undo init ?. 
define variable i               as integer. 
define variable j               as integer.
define variable l_edbtyp        as character format "x(10)".
define variable l_i             as integer.
define variable l_logfile       as character.
define variable line            as character format "x(320)".
define variable oracle_drop     as logical   initial false.
define variable owner_name      as character. 
define variable ret_ok          as logical   no-undo init yes. 
define variable separate_drop   as logical   initial false.
define variable separate_term   as logical   initial false.
define variable skip_use_clause as logical   initial false. 
define variable sql_stream      as character.
define variable title_string    as character no-undo format "x(60)".
define variable tmp_line        as character format "x(320)".
define variable word            as character extent 4 no-undo.
DEFINE VARIABLE ldaph1          AS INTEGER   NO-UNDO. /*ldap cn#OE00172458 */


define stream sql_lines.


FORM 
                                                    skip(1)
    creating[1] FORMAT "x(30)" LABEL "Name" colon 8 
    creating[2] FORMAT "x(20)" LABEL "Type" colon 8
    WITH row 4 centered &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN view-as dialog-box 
    three-d &ENDIF ATTR-SPACE overlay side-labels
    TITLE title_string USE-TEXT
    width 58 /* to produce enough room for DBE */
    frame sql_frame.


      
/*---------------------  Internal Procedures  ----------------------*/

procedure error_handling:

  define INPUT PARAMETER p_error-nr         as INTEGER.
  define INPUT PARAMETER p_param1           as CHARACTER.
  define INPUT PARAMETER p_param2           as CHARACTER.
  define INPUT PARAMETER p_type             as CHARACTER.

  define variable err-msg     as character format "x(70)" extent 19
      initial [
  /*  1 */ "Cannot find database &1.",
  /*  2 */ "Database &1 is not connected.",
  /*  3 */ "Comment-String was """"; It got set to ?",
  /*  4 */ "SEND-SQL FAILED SENDING: &1",
  /*  5 */ "Creating objects - Name: &1     Type: &2",
  /*  6 */ "  : &1",
  /*  7 */ "***** WARNING Object Name: &1 - Type: &2 not created!",
  /*  8 */ "Proc-Text-Buffer: &1",
  /*  9 */ "",
  /* 10 */ "commit1_per_stmt: &1",
  /* 11 */ "dropit: &1",
  /* 12 */ "SENDING SQL: &1",
  /* 13 */ "Return OK: &1",
  /* 14 */ "ERROR-STATUS: &1",
  /* 15 */ "-- Creating objects in &1 database.",
  /* 16 */ "",
  /* 19 */ ""
              ].     


  if p_param1 = ? then assign p_param1 = "".
  if p_param2 = ? then assign p_param2 = "".
    
  if logfile_open
   then case p_type:
    when "debug" then do:
            if p_debug
             then put stream logfile unformatted
                "DEBUGGING _snd_sql.i: "
                SUBSTITUTE(err-msg[p_error-nr],p_param1,p_param2) skip.
            end. /* debug */
            
    when "error"     then put stream logfile unformatted
                SUBSTITUTE(err-msg[p_error-nr],p_param1,p_param2) skip.

    when "paragraph" then put stream logfile unformatted
                "-- ++"                                           skip
                SUBSTITUTE(err-msg[p_error-nr],p_param1,p_param2) skip
                "-- --"                                           skip(1).

    otherwise             put stream logfile unformatted
                SUBSTITUTE(err-msg[p_error-nr],p_param1,p_param2) skip.
    end case.

   else case p_type:

    when "debug"     then do:
            if p_debug
             then message
                "DEBUGGING _snd_sql.i: "
                SUBSTITUTE(err-msg[p_error-nr],p_param1,p_param2)
                view-as alert-box.
            end. /* debug */

    when "error"     then message
                SUBSTITUTE(err-msg[p_error-nr],p_param1,p_param2)
                view-as alert-box error.

    when "paragraph" then /* no paragraph info needed on screen */.

    otherwise             message
                SUBSTITUTE(err-msg[p_error-nr],p_param1,p_param2)
                view-as alert-box.
    end case.

  end PROCEDURE.  /* error_handling */

/*---------------------------  TRIGGERS  ---------------------------*/

/*------------------------------------------------------------------*/
/*---------------------------  MAIN-CODE  --------------------------*/
/*------------------------------------------------------------------*/

  

assign
  batch_mode     = SESSION:BATCH-MODE.

if batch_mode and not logfile_open then do: /* we need to open the output to the log-file */
  assign
    l_i          = length(p_sql-file,"character") - 3
    l_logfile    = ( if substring(p_sql-file
                                 ,l_i
                                 ,-1
                                 ,"character"
                                 )             =    ".sql"
                      then substring(p_sql-file,1,l_i - 1, "character")
                      else p_sql-file
                   ) + ".log"
    logfile_open = true.
  output stream logfile to value(l_logfile).
  end. /* we need to open the output to the log-file */

find first DICTDB._Db
  where DICTDB._Db._Db-name = p_db-name
  no-lock no-error.
if not available DICTDB._Db
 then do:
  run error_handling(1,p_db-name,"","error").
  leave.
  end.
  

if LDBNAME("DICTDBG") = ?
 or not connected("DICTDBG")
 then do:
  run error_handling(2,p_db-name,"","error").
  leave.
  end.

assign
  l_edbtyp       = {adecomm/ds_type.i
                     &direction = "itoe"
                     &from-type = "DICTDB._Db._Db-type"
                   }
  title_string   = "Creating " + l_edbtyp + " Objects".



if NOT logfile_open
 then assign SESSION:IMMEDIATE-DISPLAY = yes.

if p_cmmnt-chr = ""
 then do:
  assign p_cmmnt-chr = ?.
  run error_handling(3,"","","info").
  end.

/*-----begin data server dependent settings */ 

/* Not completly generic, but at least all  */
/* of the dependencies are in one place.    */
 
case l_edbtyp: 
  when "ODBC" then assign
    separate_term   = (IF p_eosttmnt = "go" THEN TRUE ELSE FALSE) 
    separate_drop   = false
    change_chained_mode = false
    skip_use_clause = true
    add_cr          = false
    comit1_per_stmt = (IF (INDEX(DICTDB._Db._Db-misc2[5], "SQL Server") <> 0) THEN TRUE ELSE FALSE )
    drop_terminator = (IF p_eosttmnt = "go" THEN FALSE ELSE true)
    clear_buffers   = false . 

  when "MSS" then assign
    separate_term   = (IF p_eosttmnt = "go" THEN TRUE ELSE FALSE) 
    separate_drop   = false
    change_chained_mode = false
    skip_use_clause = true
    add_cr          = false
    comit1_per_stmt = false
    drop_terminator = (IF p_eosttmnt = "go" THEN FALSE ELSE true)
    clear_buffers   = false .

  when "ORACLE"    then assign
    clear_buffers   = TRUE
    closeall        = FALSE 
    comit1_per_stmt = FALSE
    oracle_drop     = true
    add_cr          = false
    drop_indicator  = "1"          /* this is a 1 because if the       */
                                   /* table exists there can be only 1 */
    drop_terminator = TRUE. 
  end case.
   
/*-----End data server dependent settings */

run error_handling(15,l_edbtyp,"","paragraph").
run error_handling(10,string(comit1_per_stmt),"","debug").
run error_handling(11,string(dropit),"","debug").


/*
** If this is Oracle we may have to strip the user name of excess jazz 
** like the sql*net connect parameters etc. 
** 
** The name could be in three formats:
**
**      user (i = 0 j = 0)
**      user@connection_string (i = 0 j = #)
**      user/password@connection_string (i = # j = # i < j)
**
*/
if l_edbtyp = "ORACLE" then do:
  ASSIGN owner_name = CAPS(p_owner)
         i = index(owner_name,'/')
         j = index(owner_name,'@').

  if i <> 0 THEN
    ASSIGN owner_name = substr(owner_name, 1, i - 1, "character"). 
      
  ELSE IF j <> 0 THEN
    ASSIGN owner_name = substr(owner_name, 1, j - 1, "character"). 

/* In case l_owner is null, we are using external authentication 
 * Get user name from database 
   CR#OE00172458.Begin 
 */
IF  owner_name EQ "" OR owner_name EQ ? THEN
DO:
   RUN STORED-PROC DICTDBG.send-sql-statement 
       ldaph1 = PROC-HANDLE NO-ERROR 
       ("SELECT USER FROM DUAL").

   IF NOT ERROR-STATUS:ERROR AND ldaph1 <> ? THEN DO: 
     FOR EACH DICTDBG.proc-text-buffer WHERE PROC-HANDLE = ldaph1:
           owner_name = TRIM(proc-text).
     END.
     CLOSE STORED-PROC DICTDBG.send-sql-statement WHERE PROC-HANDLE = ldaph1.
   END.
END.
/*   CR#OE00172458.End */ 
end.

if change_chained_mode then do:
  
    RUN STORED-PROC DICTDBG.send-sql-statement
      h = PROC-HANDLE NO-ERROR ("set chained off").

    /* grab return status from send sql */      
    ret_ok  = NOT ERROR-STATUS:ERROR.

    if ret_ok then do:          

      if clear_buffers
       then for each DICTDBG.proc-text-buffer 
        where PROC-HANDLE = h:
        run error_handling(8,DICTDBG.proc-text-buffer.proc-text,"","debug").
        end.     /* clear_buffers */

      CLOSE STORED-PROC DICTDBG.send-sql-statement 
        where PROC-HANDLE = h . 

      end.  /* ret_ok = TRUE */

     else run error_handling(4,"set chanied off","","error").

    assign h = ? .            /* set handle to null */

  end.  /* if changed_chained_mode */



/* 
 * get all the sql statements from 
 * the file created by _wrktgen.p
 */
input stream sql_lines FROM VALUE(p_sql-file).

REPEAT ON STOP UNDO, LEAVE:  /* repeat reading lines from sql-file */
    
    assign
      line           = ""
      check_for_drop = false.

    /*
     * get each line from file to form commands to send.
     */
    REPEAT:  /* get an entire sql statement */
      
      IMPORT STREAM sql_lines UNFORMATTED tmp_line.
   
      /* 
       * Skip empty lines
       */
      if tmp_line = "" then next. 
   
      /* 
       * Skip empty sql-commands
       */
      if tmp_line = p_eosttmnt and line = "" then next.

      /* 
       * If the line begins with a comment, skip it.
       */
      if   p_cmmnt-chr <>   ?
       and tmp_line  begins p_cmmnt-chr
       then next. 

      /* 
       * leave this loop at end of statements (go) or end of 
       * file (exit).
       */
      tmp_line = trim(tmp_line).
      if tmp_line = "exit" then leave.
      
      if separate_term and tmp_line = p_eosttmnt then leave.

      /*
       * If we are to drop a table or procedure which had some
       * set of statements proceding us, then tag the 
       * line with a note to ourselves so we'll know to commit 
       * a drop after the inquiry. 
       */
      if (tmp_line begins "drop ")
       and (line <> "") 
       and (separate_drop = TRUE)
       then do:
        assign
          check_for_drop = true
          drop_line      = tmp_line
          line           = line           + "select '"
                         + drop_indicator + ": " 
                         + drop_line      + "'"
                         + CHR(12).
      end. 
      else if (oracle_drop = TRUE) AND (tmp_line begins "drop ") then do:
        assign
          i              = index(tmp_line," ") + 1
          word[1]        = substr(tmp_line, i, -1, "character")
          i              = index(word[1], " ") + 1
          word[1]        = substr(word[1], i, -1, "character")
          j              = index(word[1], p_eosttmnt) - 1
          word[1]        = CAPS(substr(word[1], 1, j, "character"))
          check_for_drop = true
          j              = index(tmp_line, p_eosttmnt) - 1
          drop_line      = substr(tmp_line, 1, j, "character").

        /* 
         * Filtering objects with the same name that we own 
         * and that are not "pending delete" ojects (type = 10) 
         * to see if we can safely drop the object. 
        */ 
        IF _Db._Db-misc1[3] = 7 THEN
          assign line = "select count(*) from sys.obj$ "
                    + "where name = '" + word[1] + "'"
                    + " and type != 10 "               
                    + " and owner# = (select user# from sys.user$ "
                    + " where name = '" + owner_name + "')".
        ELSE
          assign line = "select count(*) from sys.obj$ "
                    + "where name = '" + word[1] + "'"
                    + " and type# != 10 "               
                    + " and owner# = (select user# from sys.user$ "
                    + " where name = '" + owner_name + "')".

      end.
      else do:
        assign line = line + " "
                    + ( if add_cr
                          then tmp_line + chr(12)
                          else tmp_line
                      ).
        if  tmp_line begins "CREATE "
         or tmp_line begins "sp_primarykey"
         then assign
           create_line = tmp_line.
        end. 
      /* 
       * If the this is the end of a statement (p_eosttmnt is the 
       * terminator of a sql statement) then leave the loop and 
       * process the statement. 
       */
       
      IF l_edbtyp = "ORACLE" AND INDEX(tmp_line,p_eosttmnt) = LENGTH(tmp_line) THEN
        LEAVE.
     
      if   (not separate_term)
       and (INDEX(tmp_line,p_eosttmnt) <> 0)
       then leave. 

      end.   /* get an entire sql statement */

    /* 
     * Skip empty lines
     */
    if line = "" then leave.


    /* 
     * Don't bother with a use, the dataserver does that for us.
     */
    if line begins "use" and skip_use_clause then next. 


    /* 
     * The END of the file is marked by an "exit" statement.
     */
    if tmp_line = "exit" then leave. 
    
    if drop_terminator
      then assign
       i    = LENGTH(line) - 1 
       j    = INDEX(line,p_eosttmnt) - 1.
    /* Oracle allows semi-colons in quoted strings */
    if ( (l_edbtyp = "ORACLE") and  (j > 0) and (i > j)) then j = i.
    if drop_terminator
      then assign
       line = ( if ( l_edbtyp <> "ORACLE"
                 or  index(CAPS(line),"BEGIN") = 0
                 or  index(CAPS(line),"END;") = 0 )
                 then SUBSTR(line, 1, j, "character")
                 else line
              ). 

    
    /* 
     * Display the SQL that we are going to send to the foreign datamanager.
     */
    if create_line <> ""
     then do:  /* create_line <> "" */
      DO i = 1 to 4:
        assign
          j = INDEX(create_line," ") - 1.
          word[i] = TRIM(substr(create_line, 1, j, "character")).
          j = j + 2. 
          create_line = TRIM(substr(create_line, j, -1, "character")).
        end.  

      case word[2]:
        when "unique"    then assign
                         word[2] = "Unique Index"
                         word[3] = word[4].
        when "table"     then assign
                         word[2] = "Table". 
        when "SEQUENCE"  then assign
                         word[2] = "Sequence".
        when "trigger"   then  assign
                         word[2] = "Trigger".
        when "procedure" then  assign
                         word[2] = "Procedure".
        when "index"     then  assign
                         word[2] = "Index".
        end case.

      if not batch_mode
       then display
         word[3] @ creating[1]
         word[2] @ creating[2]
         WITH FRAME sql_frame. 
       else run error_handling(5,word[3],word[2],"info").      

      end.     /* create_line <> "" */
     
     
  /*   
   * Send the SQL off and check the return value.
   * If "Note to Myself" comes back, we know we have a pending
   * drop to perform.   "Note to Myself" won't come back unless 
   * the object is "droppable".
   */
  function_performed = false. 

  do on stop undo, leave:

    /* if debugging then output sqlline to the screen
     * before  we send it
     */

    run error_handling(10,string(comit1_per_stmt),"","debug").
    run error_handling(11,string(dropit),"","debug").
    run error_handling(12,line,"","debug").

    RUN STORED-PROC DICTDBG.send-sql-statement 
          h = PROC-HANDLE NO-ERROR (line).

    ret_ok  = ( NOT ERROR-STATUS:ERROR
                or line = ""
              ).
    if ret_ok
     then do:  /* outer ret_ok */

      if clear_buffers then for each DICTDBG.proc-text-buffer where PROC-HANDLE = h:
        if check_for_drop then 
          assign check_for_drop = false
                 dropit         = (IF INTEGER(DICTDBG.proc-text-buffer.proc-text) > 0 THEN TRUE
                                      ELSE FALSE).                                                      
        else run error_handling
                        (8,DICTDBG.proc-text-buffer.proc-text,"","debug").
      end.     /* clear_buffers */
   
      if h <> ?
       then CLOSE STORED-PROC DICTDBG.send-sql-statement
          where PROC-HANDLE = h. 
      assign h = ?.


      /* 
       * Only commit if the previous send-sql  
       * was succesful
       */
      if comit1_per_stmt
       then do:  /* comit1_per_stmt */

        RUN STORED-PROC  DICTDBG.send-sql-statement
              h = PROC-HANDLE NO-ERROR ("commit").

        assign ret_ok  = NOT ERROR-STATUS:ERROR.
        
        if ret_ok
         then do: /* inner ret_ok */

          if clear_buffers
           then for each DICTDBG.proc-text-buffer
            where PROC-HANDLE = h:
            run error_handling
                        (8,DICTDBG.proc-text-buffer.proc-text,"","debug").
            end.     /* clear_buffers */

          CLOSE STORED-PROC DICTDBG.send-sql-statement
                  where PROC-HANDLE = h. 
          assign h = ?.

          end.

         else do:  /* inner ret_ok = FALSE */
          run error_handling(4,"commit","","error").
          DO l_i = 1 TO ERROR-STATUS:NUM-MESSAGES:
            run error_handling(6,ERROR-STATUS:GET-MESSAGE(l_i),"","error").
            run error_handling(6,string(ERROR-STATUS:GET-NUMBER(l_i)),"","error").
            end. 
          end.     /* inner ret_ok = FALSE */

        end.     /* comit1_per_stmt */

      end.     /* outer ret_ok */

     else do:  /* outer ret_ok = FALSE */
      run error_handling(4,line,"","error").
      DO l_i = 1 TO ERROR-STATUS:NUM-MESSAGES:
        run error_handling(6,ERROR-STATUS:GET-MESSAGE(l_i),"","error").
        run error_handling(6,string(ERROR-STATUS:GET-NUMBER(l_i)),"","error").
        end. 
      end.     /* outer ret_ok = FALSE */



    /* 
     * If we have a pending drop, use the original drop line
     * and then commit the transaction.
     */

    if dropit
     then do:  /* dropit */

      RUN STORED-PROC DICTDBG.send-sql-statement
          h = PROC-HANDLE NO-ERROR (drop_line).

      assign ret_ok  = NOT ERROR-STATUS:ERROR.

      run error_handling(12,drop_line,"","debug").
      run error_handling(13,string(ret_ok),"","debug").
      run error_handling(14,string(ERROR-STATUS:ERROR),"","debug").

      if ret_ok
       then do:   /* outer ret_ok */

        if clear_buffers
         then for each DICTDBG.proc-text-buffer
            where PROC-HANDLE = h :
            run error_handling
                        (8,DICTDBG.proc-text-buffer.proc-text,"","debug").
          end.     /* clear_buffers */

        CLOSE STORED-PROC DICTDBG.send-sql-statement
          where PROC-HANDLE = h. 
        assign h = ? .

        if comit1_per_stmt
         then do:  /* comit1_per_stmt */

          RUN STORED-PROC  DICTDBG.send-sql-statement
              h = PROC-HANDLE NO-ERROR ("commit").

          assign ret_ok  = NOT ERROR-STATUS:ERROR.
        
          if ret_ok
           then do: /* inner ret_ok */

            if clear_buffers
             then for each DICTDBG.proc-text-buffer
              where PROC-HANDLE = h:
              run error_handling
                        (8,DICTDBG.proc-text-buffer.proc-text,"","debug").
              end.     /* clear_buffers */

            CLOSE STORED-PROC DICTDBG.send-sql-statement
                  where PROC-HANDLE = h. 
            assign h = ? .

            end.

           else do:  /* inner ret_ok = FALSE */
            run error_handling(4,"commit","","error").
            DO l_i = 1 TO ERROR-STATUS:NUM-MESSAGES:
              run error_handling(6,ERROR-STATUS:GET-MESSAGE(l_i),"","error").
              run error_handling(6,string(ERROR-STATUS:GET-NUMBER(l_i)),"","error").
              end. 
            end.     /* inner ret_ok = FALSE */

          end.     /* comit1_per_stmt */

        end.     /* outer ret_ok */

       else do:  /* outer ret_ok = FALSE */
        run error_handling(4,line,"","error").
        DO l_i = 1 TO ERROR-STATUS:NUM-MESSAGES:
          run error_handling(6,ERROR-STATUS:GET-MESSAGE(l_i),"","error").
          run error_handling(6,string(ERROR-STATUS:GET-NUMBER(l_i)),"","error").
          end. 
        end.     /* outer ret_ok = FALSE */

      assign dropit = false. 

      end.     /* dropit */

    assign function_performed = true. 

    end.  /* do on stop undo, leave */

  if not function_performed
   and create_line <> ""
   then run error_handling(7,word[3],word[2],"error").

  assign create_line = "". /* clear out create line for next create. */

  end.   /* repeat reading lines from sql-file */

input stream sql_lines CLOSE.


if change_chained_mode
 then do:  /* change_chained_mode */
  
  RUN STORED-PROC DICTDBG.send-sql-statement
      h = PROC-HANDLE NO-ERROR ("set chained on").

  /* grab return status from send sql */      
  assign ret_ok  = NOT ERROR-STATUS:ERROR.

  if ret_ok
   then do:  /* ret_ok */

    if clear_buffers
     then for each DICTDBG.proc-text-buffer 
      where PROC-HANDLE = h:
      run error_handling(8,DICTDBG.proc-text-buffer.proc-text,"","debug").
      end.

    CLOSE STORED-PROC DICTDBG.send-sql-statement 
      where PROC-HANDLE = h . 

    end.  /* ret_ok */
    
   else run error_handling(4,"set chanied off","","error").

  assign h = ? .            /* set handle to null */

  end.  /* changed_chained_mode */


if not logfile_open
 then do:
  SESSION:IMMEDIATE-DISPLAY = no.
  HIDE FRAME sql_frame NO-PAUSE.
  end.
 
/*------------------------------------------------------------------*/


