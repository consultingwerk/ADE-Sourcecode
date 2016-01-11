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
/* Created:  D. McMann 03/28/00 PROTOMSSQL Utiity to migrate a Progress
                                database via ODBC to  MS SQL Server 7 
             D. McMann 04/12/00 Added long path name for Progress Database
             D. McMann 06/07/00 Changed frame layout for UNIX
             D. McMann 07/19/00 Added specific help topic for MSS
             D. McMann 06/18/01 Added case and collation options
                  
                                
*/            


{ prodict/user/uservar.i NEW }
{ prodict/mss/mssvar.i NEW }

DEFINE VARIABLE cmd           AS CHARACTER                NO-UNDO.
DEFINE VARIABLE wait          AS CHARACTER                NO-UNDO.
DEFINE VARIABLE create_h      AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE db_exist      AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE batch_mode    AS LOGICAL INITIAL NO       NO-UNDO.
DEFINE VARIABLE old-dictdb    AS CHARACTER                NO-UNDO.  
DEFINE VARIABLE output_file   AS CHARACTER                NO-UNDO.
DEFINE VARIABLE tmp_str       AS CHARACTER                NO-UNDO.
DEFINE VARIABLE run_time      AS INTEGER                  NO-UNDO.
DEFINE VARIABLE i             AS INTEGER                  NO-UNDO.
DEFINE VARIABLE err-rtn       AS LOGICAL INITIAL FALSE    NO-UNDO.
DEFINE VARIABLE redo          AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE wrg-ver       AS LOGICAL INITIAL FALSE    NO-UNDO.
DEFINE VARIABLE s_res         AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE redoblk       AS LOGICAL INITIAL FALSE    NO-UNDO.
DEFINE VARIABLE mvdta         AS LOGICAL                  NO-UNDO.

DEFINE STREAM   strm.

batch_mode = SESSION:BATCH-MODE.

FORM
  pro_dbname   FORMAT "x({&PATH_WIDG})"  view-as fill-in size 32 by 1 
    LABEL "Original PROGRESS Database" colon 36 SKIP({&VM_WID}) 
  pro_conparms FORMAT "x(256)" view-as fill-in size 32 by 1 
    LABEL "Connect parameters for PROGRESS" colon 36 SKIP({&VM_WID})
  osh_dbname   FORMAT "x(32)"  view-as fill-in size 32 by 1 
    LABEL "Name of Schema holder Database" colon 36 SKIP({&VM_WID})
  mss_pdbname  FORMAT "x(32)" VIEW-AS FILL-IN SIZE 32 BY 1
    LABEL "Logical Database Name" COLON 36 SKIP({&VM_WID}) 
  mss_dbname   FORMAT "x(32)"  view-as fill-in size 32 by 1 
    LABEL "ODBC Data Source Name" colon 36 SKIP({&VM_WID})
  mss_username FORMAT "x(32)"  view-as fill-in size 32 by 1 
    LABEL "Username" colon 36 SKIP({&VM_WID})
  mss_password FORMAT "x(32)"  BLANK
        view-as fill-in size 32 by 1 
        LABEL "User's Password" colon 36 SKIP({&VM_WID})
  mss_conparms FORMAT "x(256)" view-as fill-in size 32 by 1 
     LABEL "Connect parameters" colon 36 SKIP({&VM_WID})
      long-length LABEL " Maximum Varchar Length"  COLON 36 SKIP({&VM_WIDG})
  SPACE (2) mss_codepage FORMAT "x(32)"  view-as fill-in size 15 by 1
     LABEL "Codepage" SPACE(2)  SPACE(2)
  mss_collname FORMAT "x(32)"  view-as fill-in size 15 by 1
     LABEL "Collation"   SPACE(2) mss_incasesen  LABEL "Insensitive"  SKIP({&VM_WIDG}) 
  SPACE(2) pcompatible view-as toggle-box LABEL "Create RECID Field"   
  loadsql   view-as toggle-box label "Load SQL" AT 32
  movedata  view-as toggle-box label "Move Data" AT 55 SKIP({&VM_WID}) SPACE(2)
  shadowcol VIEW-AS TOGGLE-BOX LABEL "Create Shadow Columns" 
  descidx   VIEW-AS TOGGLE-BOX LABEL "Create Desc Index" AT 32 
  dflt      VIEW-AS TOGGLE-BOX LABEL "Include DEFAULTS"  AT 55 SKIP({&VM_WID}) SPACE(2)
  sqlwidth   VIEW-AS TOGGLE-BOX LABEL "Use SQL Width Column"  SPACE(2)
  
    SKIP({&VM_WID})
             {prodict/user/userbtns.i}
  WITH FRAME x ROW 1 CENTERED SIDE-labels OVERLAY
    DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
    &IF "{&WINDOW-SYSTEM}" <> "TTY"
  &THEN VIEW-AS DIALOG-BOX &ENDIF
  TITLE "PROGRESS DB to MS SQL Server Conversion".

FORM
  wait FORMAT "x" LABEL
  "Creating tables - Please wait"
  WITH FRAME table-wait ROW SCREEN-LINES - 2 COLUMN 1 NO-BOX OVERLAY
  &IF "{&WINDOW-SYSTEM}" <> "TTY"
  &THEN VIEW-AS DIALOG-BOX &ENDIF.

    /* PROCEDURES */
PROCEDURE cleanup:  
  IF NUM-DBS > 1 THEN DO:   
    IF rmvobj THEN DO:
        DISCONNECT VALUE(osh_dbname).
        RUN prodict/misc/_clproto.p (INPUT osh_dbname, INPUT pro_dbname).
    END.
    ELSE DO:       
      CREATE ALIAS DICTDB FOR DATABASE VALUE(osh_dbname).
      RUN prodict/misc/_del-db.p (INPUT mss_dbname, INPUT osh_dbname, 
                                  INPUT pro_dbname).       
    END.
  END.
END PROCEDURE.

ON WINDOW-CLOSE of FRAME x
   APPLY "END-ERROR" to FRAME x.
   
ON VALUE-CHANGED of loadsql IN FRAME x DO:
  IF SELF:screen-value = "yes" THEN 
     movedata:sensitive in frame x = YES.
  ELSE DO:
     movedata:screen-value in frame x = "no".
     movedata = false.
     movedata:sensitive in frame x = NO.
  END.   
END. 

ON VALUE-CHANGED of mss_incasesen IN FRAME x DO:
  IF SELF:screen-value = "no" THEN
    ASSIGN  
           shadowcol:sensitive in frame x = YES
           s_res = shadowcol:MOVE-BEFORE-TAB-ITEM(descidx:HANDLE).
  ELSE 
     ASSIGN shadowcol:screen-value in frame x = "no"
            shadowcol:SENSITIVE IN FRAME X = NO.  
END. 

ON LEAVE OF long-length IN FRAME X DO:
  IF INTEGER(long-length:SCREEN-VALUE) > 8000 THEN DO:  
    MESSAGE "The maximun length for a varchar is 8000" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
END.

&IF "{&WINDOW-SYSTEM}"<> "TTY" &THEN   
/*----- HELP in Progress DB to MS SQL Server 7 Database -----*/
on CHOOSE of btn_Help in frame x
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                             INPUT {&PROGRESS_DB_to_SQL_Dlg_Box},
                             INPUT ?).
&ENDIF

IF LDBNAME ("DICTDB") <> ? THEN
  ASSIGN pro_dbname = LDBNAME ("DICTDB").

IF NOT batch_mode THEN DO:
   {adecomm/okrun.i  
       &FRAME  = "FRAME x" 
       &BOX    = "rect_Btns"
       &OK     = "btn_OK" 
       {&CAN_BTN}
   }
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
   btn_Help:visible IN FRAME x = yes.
   &ENDIF
END.

/* initialize variables */
ASSIGN pcompatible = YES
         run_time = TIME.
IF OS-GETENV("PRODBNAME")   <> ? THEN
  pro_dbname   = OS-GETENV("PRODBNAME").
IF OS-GETENV("PROCONPARMS")   <> ? THEN
  pro_conparms = OS-GETENV("PROCONPARMS").
IF OS-GETENV("SHDBNAME")    <> ? THEN
  osh_dbname   = OS-GETENV("SHDBNAME").
IF OS-GETENV("MSSDBNAME")   <> ? THEN
  mss_dbname   = OS-GETENV("MSSDBNAME"). 
IF OS-GETENV("MSSPDBNAME")   <> ? THEN
  mss_pdbname   = OS-GETENV("MSSPDBNAME").  
IF OS-GETENV("MSSUSERNAME") <> ? THEN
  mss_username = OS-GETENV("MSSUSERNAME").
IF OS-GETENV("MSSPASSWORD") <> ? THEN
  mss_password = OS-GETENV("MSSPASSWORD").
IF OS-GETENV("MSSCONPARMS") <> ? THEN
  mss_conparms = OS-GETENV("MSSCONPARMS").

IF OS-GETENV("MSSCODEPAGE") <> ? THEN
  mss_codepage = OS-GETENV("MSSCODEPAGE").
ELSE
  ASSIGN mss_codepage = session:cpinternal.

IF OS-GETENV("MSSCOLLNAME") <> ? THEN
  mss_collname = OS-GETENV("MSSCOLLNAME").
ELSE
  ASSIGN mss_collname = session:CPCOLL.

IF OS-GETENV("MSSCASESEN") <> ? THEN DO:
   ASSIGN tmp_str = OS-GETENV("MSSCASESEN").
  IF  tmp_str BEGINS "Y" THEN
    ASSIGN mss_incasesen = FALSE.
  ELSE
    ASSIGN mss_incasesen = TRUE.
           
END.
ELSE
    ASSIGN mss_incasesen = TRUE.

IF OS-GETENV("VARLENGTH") <> ? THEN
  long-length = integer(OS-GETENV("VARLENGTH")).
ELSE
  long-length = 8000.

IF OS-GETENV("MOVEDATA")    <> ? THEN
  tmp_str      = OS-GETENV("MOVEDATA").
IF tmp_str BEGINS "Y" THEN movedata = TRUE.

IF OS-GETENV("COMPATIBLE") <> ?  THEN DO:
   tmp_str      = OS-GETENV("COMPATIBLE").
   IF tmp_str BEGINS "Y" then pcompatible = TRUE.
   ELSE pcompatible = FALSE.
END. 

IF OS-GETENV("LOADSQL") <> ? THEN DO:
  tmp_str      = OS-GETENV("LOADSQL").
  IF tmp_str BEGINS "Y" then loadsql = TRUE.
  ELSE loadsql = FALSE.
END. 
ELSE 
  loadsql = TRUE.

IF OS-GETENV("SQLWIDTH") <> ? THEN DO:
  tmp_str      = OS-GETENV("SQLWIDTH").
  IF tmp_str BEGINS "Y" then sqlwidth = TRUE.
  ELSE sqlwidth = FALSE.
END. 
ELSE 
  sqlwidth = FALSE.
 
IF OS-GETENV("DESCIDX") <> ? THEN DO:
  tmp_str      = OS-GETENV("DESCIDX").
  IF tmp_str BEGINS "Y" then descidx = TRUE.
  ELSE descidx = FALSE.
END. 
ELSE
  descidx = FALSE.

if   pro_dbname   = ldbname("DICTDB") and pro_conparms = "" THEN
  assign pro_conparms = "<current working database>".

IF PROGRESS EQ "COMPILE-ENCRYPT" THEN
    ASSIGN mvdta = FALSE.
ELSE
    ASSIGN mvdta = TRUE.

main-blk:
DO ON ERROR UNDO main-blk, RETRY main-blk:
  IF redo THEN
     RUN cleanup.
  
  IF wrg-ver THEN DO:
    MESSAGE "The DataServer for MS SQL Server was designed to work with Versions 7 " SKIP
            "and above.  You have tried to connect to a prior version of MS SQL Server. " SKIP
            "The DataServer for ODBC supports that version and must be used to perform " SKIP
            "this function. " SKIP(1)
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
  END.
    
  IF redoblk THEN DO:
      MESSAGE "You have received error messages from the client stating why" SKIP
              "the process was stopped.  Correct the errors and try again." SKIP
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  END.
  
  /*
   * if this is not batch mode, allow override of environment variables.
   */
  
IF NOT batch_mode THEN 
  _updtvar: 
  DO WHILE TRUE:
     UPDATE pro_dbname
        pro_conparms
        osh_dbname
        mss_pdbname
        mss_dbname
        mss_username
        mss_password
        mss_conparms
        long-length
        mss_codepage
        mss_collname
        mss_incasesen
        pcompatible
        loadsql
        movedata WHEN mvdta = TRUE
        shadowcol WHEN mss_incasesen = FALSE
        descidx
        dflt
        sqlwidth
        btn_OK btn_Cancel 
        &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
            btn_Help
        &ENDIF
        WITH FRAME x.     
        

    IF pro_conparms = "<current working database>" THEN
      ASSIGN pro_conparms = "".

    IF shadowcol:SCREEN-VALUE = "yes" THEN
      ASSIGN shadowcol = TRUE.

    IF LDBNAME ("DICTDB") <> pro_dbname THEN DO:
      ASSIGN old-dictdb = LDBNAME("DICTDB").
      IF NOT CONNECTED(pro_dbname) THEN
        CONNECT VALUE (pro_dbname) VALUE (pro_conparms) -1 NO-ERROR.              
      
      IF ERROR-STATUS:ERROR OR NOT CONNECTED (pro_dbname) THEN DO:
        DO i = 1 TO  ERROR-STATUS:NUM-MESSAGES:
          IF batch_mode THEN
            PUT STREAM logfile UNFORMATTED ERROR-STATUS:GET-MESSAGE(i) skip.
          ELSE
            MESSAGE ERROR-STATUS:GET-MESSAGE(i).
        END.
        IF batch_mode THEN
           PUT STREAM logfile UNFORMATTED "Unable to connect to Progress database"
           skip.
        ELSE DO:
          &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
              MESSAGE "Unable to connect to Progress database".
          &ELSE
             MESSAGE "Unable to connect to Progress database" 
             VIEW-AS ALERT-BOX ERROR.
          &ENDIF
        END.            
        UNDO, RETURN error.
      END.
      ELSE DO:
    
        CREATE ALIAS DICTDB FOR DATABASE VALUE(pro_dbname).
      end.  
    END.
    ELSE
      ASSIGN old-dictdb = LDBNAME("DICTDB").
        
    IF loadsql THEN DO:
      IF Osh_dbname = "" OR osh_dbname = ? THEN DO:
        MESSAGE "Schema holder database Name is required." 
             VIEW-AS ALERT-BOX ERROR.    
        NEXT _updtvar.
      END.
       IF mss_pdbname = "" OR mss_pdbname = ? THEN DO:
        MESSAGE "Logical Database Name is required."  
            VIEW-AS ALERT-BOX ERROR.  
        NEXT _updtvar.
      END.
      IF mss_dbname = "" OR mss_dbname = ? THEN DO:
        MESSAGE "ODBC Data Source Name is required."  
            VIEW-AS ALERT-BOX ERROR.  
        NEXT _updtvar.
      END.
    END.      
    LEAVE _updtvar.
  END.
 
  IF osh_dbname <> "" AND osh_dbname <> ? THEN
      output_file = osh_dbname + ".log".
  ELSE
      output_file = "protomss.log". 
             
  OUTPUT STREAM logfile TO VALUE(output_file) NO-ECHO NO-MAP UNBUFFERED. 
  logfile_open = true. 
  IF pro_dbname = "" OR pro_dbname = ? THEN DO:
    PUT STREAM logfile UNFORMATTED "Progress Database name is required." SKIP.
    ASSIGN err-rtn = TRUE.
  END.

  IF loadsql THEN DO:
    IF Osh_dbname = "" OR osh_dbname = ? THEN DO:
       PUT STREAM logfile UNFORMATTED  "Schema holder Database Name is required." SKIP.   
       ASSIGN err-rtn = TRUE.        
    END.
    IF mss_dbname = "" OR mss_dbname = ? THEN DO:
       PUT STREAM logfile UNFORMATTED "ODBC data source name is required." SKIP.   
       ASSIGN err-rtn = TRUE.
    END.
  END.      
  IF err-rtn THEN RETURN.
  ASSIGN redo = TRUE.
         
  RUN prodict/mss/protoms1.p.
  IF RETURN-VALUE = "indb" THEN DO:
    ASSIGN redo = FALSE.
    UNDO, RETRY.
  END.
  ELSE IF RETURN-VALUE = "wrg-ver" THEN DO:
    ASSIGN wrg-ver = TRUE.
    UNDO, RETRY.
  END.
  ELSE IF RETURN-VALUE = "undo" THEN DO:
    ASSIGN redoblk = TRUE.
    UNDO, RETRY.
  END.
  /*
   * If this is batch mode, make sure we close the output file we
   * opened above.
  */
  IF logfile_open
    THEN OUTPUT STREAM logfile CLOSE.
 
  IF CONNECTED (osh_dbname) THEN 
     DISCONNECT VALUE (osh_dbname).

  IF pro_dbname <> old-dictdb THEN DO:
    DISCONNECT VALUE(pro_dbname).
    CREATE ALIAS DICTDB FOR DATABASE VALUE(old-dictdb).   
  END.
END.


 
 











