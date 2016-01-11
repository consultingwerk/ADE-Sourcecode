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
/* Modified D. McMann 12/19/97 Changed labels added toggle boxes
                               for loading sql and moving data.
            D. McMann 01/13/98 Added new env var ora_version.
            D. McMann 04/02/98 Changed load sql default to true
                               98-02-12-011
            D. McMann 12/02/99 Changed compatible label 19990305027
            D. McMann 12/07/99 Added clean up routine when error occurs
            D. McMann 02/07/00 Added sqlwidth support
            D. McMann 04/10/00 Moved environmental variables outside of
                               main so values would not be lost if error
                               occurred 20000121012
            D. McMann 04/12/00 Added long Progress Database path name.
            D. McMann 10/12/01 Added logic to dump defaults if user wants
            D. McMann 06/25/02 Added logic for function based indexes
*/            


{ prodict/user/uservar.i NEW }
{ prodict/ora/oravar.i NEW }

DEFINE VARIABLE cmd           AS CHARACTER.
DEFINE VARIABLE wait          AS CHARACTER.
DEFINE VARIABLE create_h      AS LOGICAL.
DEFINE VARIABLE db_exist      AS LOGICAL.
DEFINE VARIABLE batch_mode    AS LOGICAL INITIAL no. 
DEFINE VARIABLE output_file   AS CHARACTER.
DEFINE VARIABLE tmp_str       AS CHARACTER.
DEFINE VARIABLE run_time      AS INTEGER.
DEFINE VARIABLE err-rtn       AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE old-dictdb    AS CHARACTER NO-UNDO.
DEFINE VARIABLE i             AS INTEGER NO-UNDO.
DEFINE VARIABLE redo          AS LOGICAL NO-UNDO.
DEFINE VARIABLE mvdta         AS LOGICAL NO-UNDO.


DEFINE STREAM   strm.

ASSIGN redo = FALSE
       batch_mode = SESSION:BATCH-MODE.


FORM
  pro_dbname   FORMAT "x({&PATH_WIDG})"  view-as fill-in size 32 by 1 
    LABEL "Original PROGRESS Database" colon 38 SKIP({&VM_WID}) 
  pro_conparms FORMAT "x(256)" view-as fill-in size 32 by 1 
    LABEL "Connect parameters for PROGRESS" colon 38 SKIP({&VM_WID})
  osh_dbname   FORMAT "x(32)"  view-as fill-in size 32 by 1 
    LABEL "Name of Schema holder Database" colon 38 SKIP({&VM_WID})
  ora_dbname   FORMAT "x(32)"  view-as fill-in size 32 by 1 
    LABEL "Logical name for ORACLE Database" colon 38 SKIP({&VM_WID})
  ora_version  FORMAT ">9" validate(input ora_version = 7 or ora_version = 8 OR ora_version = 9,
    "Oracle Version must be 7, 8 or 9") view-as fill-in size 23 by 1
    LABEL "What version of ORACLE" colon 38 SKIP ({&VM_WID})  
  ora_username FORMAT "x(32)"  view-as fill-in size 32 by 1 
    LABEL "ORACLE Owner's Username" colon 38 SKIP({&VM_WID})
  ora_password FORMAT "x(32)"  BLANK
        view-as fill-in size 32 by 1 
        LABEL "ORACLE User's Password" colon 38 SKIP({&VM_WID})
  ora_conparms FORMAT "x(256)" view-as fill-in size 32 by 1 
     LABEL "ORACLE connect parameters" colon 38 SKIP({&VM_WID})
  ora_codepage FORMAT "x(32)"  view-as fill-in size 32 by 1
     LABEL "Codepage for Schema Image" colon 38 SKIP({&VM_WID}) 
  ora_collname FORMAT "x(32)" VIEW-AS FILL-IN SIZE 32 BY 1
     LABEL "Collation Name" COLON 38 SKIP({&VM_WID})  
  " ORACLE tablespace name for:" view-as text SKIP({&VM_WID})   
  ora_tspace FORMAT "x(30)" view-as fill-in size 30 by 1
     LABEL "Tables" colon 8
  ora_ispace FORMAT "x(30)" view-as fill-in size 30 by 1
     LABEL "Indexes" colon 47 SKIP({&VM_WIDG})      
  SPACE(9) pcompatible view-as toggle-box LABEL "Create Progress Recid Field "  SPACE(7)
    crtdefault VIEW-AS TOGGLE-BOX LABEL "Include Default" SKIP({&VM_WID})  
  SPACE(9) loadsql view-as toggle-box     label "Load SQL  "  &IF "{&WINDOW-SYSTEM}" = "TTY"
  &THEN SPACE(25) &ELSE SPACE(23) &ENDIF
   shadowcol VIEW-AS TOGGLE-BOX LABEL "Create Shadow Columns"  SKIP({&VM_WID}) 
  SPACE(9) movedata view-as toggle-box label "Move Data" &IF "{&WINDOW-SYSTEM}" = "TTY"
  &THEN SPACE(26) &ELSE SPACE(23) &ENDIF 
  sqlwidth VIEW-AS TOGGLE-BOX LABEL "Use Width Field" SKIP({&VM_WID})
 
             {prodict/user/userbtns.i}
  WITH FRAME x ROW &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 1 &ELSE 2 &ENDIF CENTERED SIDE-labels 
    DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
    &IF "{&WINDOW-SYSTEM}" <> "TTY"
  &THEN VIEW-AS DIALOG-BOX &ENDIF
  TITLE "PROGRESS DB to ORACLE Conversion".

FORM
  wait FORMAT "x" LABEL
  "Creating tables - Please wait"
  WITH FRAME table-wait ROW SCREEN-LINES - 2 COLUMN 1 NO-BOX
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
      RUN prodict/misc/_del-db.p (INPUT ora_dbname, INPUT osh_dbname, 
                                  INPUT pro_dbname).       
    END.
  END.
END PROCEDURE.


/*   TRIGGERS   */
ON WINDOW-CLOSE of FRAME x
   APPLY "END-ERROR" to FRAME x.


/*----- HELP in Progress DB to Oracle Database -----*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
on HELP of frame x or CHOOSE of btn_Help in frame x
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                             INPUT {&PROGRESS_DB_to_ORACLE_Dlg_Box},
                             INPUT ?).
&ENDIF  
   
ON VALUE-CHANGED of ora_version IN FRAME x DO:
  IF SELF:SCREEN-VALUE = "7" THEN 
     shadowcol:SCREEN-VALUE in frame x = "YES".
  ELSE 
     shadowcol:SCREEN-VALUE in frame x = "NO".    
END.

ON VALUE-CHANGED of loadsql IN FRAME x DO:
  IF SELF:screen-value = "yes" THEN 
     movedata:sensitive in frame x = YES.
  ELSE DO:
     movedata:screen-value in frame x = "no".
     movedata = false.
     movedata:sensitive in frame x = NO.
  END.   
END.  

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

IF OS-GETENV("PRODBNAME")   <> ? THEN
  pro_dbname   = OS-GETENV("PRODBNAME").
IF OS-GETENV("PROCONPARMS")   <> ? THEN
  pro_conparms = OS-GETENV("PROCONPARMS").
IF OS-GETENV("SHDBNAME")    <> ? THEN
  osh_dbname   = OS-GETENV("SHDBNAME").
IF OS-GETENV("ORADBNAME")   <> ? THEN
  ora_dbname   = OS-GETENV("ORADBNAME").
IF OS-GETENV("ORAVERSION")   <> ? THEN
  ora_version   = INTEGER(OS-GETENV("ORAVERSION")). 
ELSE
  ora_version = 8.       
IF OS-GETENV("ORAUSERNAME") <> ? THEN
  ora_username = OS-GETENV("ORAUSERNAME").
IF OS-GETENV("ORAPASSWORD") <> ? THEN
  ora_password = OS-GETENV("ORAPASSWORD").
IF OS-GETENV("ORACONPARMS") <> ? THEN
  ora_conparms = OS-GETENV("ORACONPARMS").
IF OS-GETENV("ORACLE_SID") <> ? THEN
  ora_sid = OS-GETENV("ORACLE_SID").
IF OS-GETENV("ORACODEPAGE") <> ? THEN
  ora_codepage = OS-GETENV("ORACODEPAGE").
IF OS-GETENV("ORACOLLNAME") <> ? THEN
  ora_collname = OS-GETENV("ORACOLLNAME").
IF OS-GETENV("TABLEAREA") <> ? THEN
  ora_tspace = OS-GETENV("TABLEAREA").
IF OS-GETENV("INDEXAREA") <> ? THEN
  ora_ispace = OS-GETENV("INDEXAREA").            
 
IF OS-GETENV("MOVEDATA")    <> ? THEN
  tmp_str      = OS-GETENV("MOVEDATA").
IF tmp_str BEGINS "Y" THEN movedata = TRUE.

IF OS-GETENV("COMPATIBLE") <> ? THEN DO:
  tmp_str      = OS-GETENV("COMPATIBLE").
  IF tmp_str BEGINS "Y" then pcompatible = TRUE.
  ELSE pcompatible = FALSE.
END. 
ELSE
  pcompatible = TRUE.
     
IF OS-GETENV("SQLWIDTH") <> ? THEN DO:
  tmp_str      = OS-GETENV("SQLWIDTH").
  IF tmp_str BEGINS "Y" then sqlwidth = TRUE.
  ELSE sqlwidth = FALSE.
END. 
ELSE
  sqlwidth = FALSE.

IF OS-GETENV("LOADSQL") <> ? THEN DO:
  tmp_str      = OS-GETENV("LOADSQL").
  IF tmp_str BEGINS "Y" then loadsql = TRUE.
  ELSE loadsql = FALSE.
END. 
ELSE
 loadsql = TRUE.

 IF OS-GETENV("ORACODEPAGE") <> ? THEN
   ora_codepage = OS-GETENV("ORACODEPAGE").
 ELSE
   ASSIGN ora_codepage = session:cpinternal.

 IF OS-GETENV("ORACOLLNAME") <> ? THEN
   ora_collname = OS-GETENV("ORACOLLNAME").
 ELSE
   ASSIGN ora_collname = session:CPCOLL.

IF OS-GETENV("CRTDEFAULT") <> ? THEN DO:
  ASSIGN tmp_str  = OS-GETENV("CRTDEFAULT").
  IF tmp_str BEGINS "Y" then crtdefault = TRUE.
  ELSE crtdefault = FALSE.
END. 
ELSE 
  ASSIGN crtdefault = FALSE.

IF OS-GETENV("SHADOWCOL") <> ? THEN DO:
  ASSIGN tmp_str  = OS-GETENV("SHADOWCOL").
  IF tmp_str BEGINS "Y" then shadowcol = TRUE.
  ELSE shadowcol = FALSE.
END. 
ELSE IF ora_version = 7 THEN
    ASSIGN shadowcol = TRUE.
ELSE
  ASSIGN shadowcol = FALSE.

IF PROGRESS EQ "COMPILE-ENCRYPT" THEN
  ASSIGN mvdta = FALSE.
ELSE
  ASSIGN mvdta = TRUE.


if   pro_dbname   = ldbname("DICTDB") and pro_conparms = "" then 
  assign pro_conparms = "<current working database>".

main-blk:
DO ON ERROR UNDO main-blk, RETRY main-blk:
  IF redo THEN
      RUN cleanup.

  run_time = TIME.

  /*
   * if this is not batch mode, allow override of environment variables.
   */
  PAUSE 0 BEFORE-HIDE.
  IF NOT batch_mode THEN 
  _updtvar: 
   DO WHILE TRUE:
    UPDATE pro_dbname
      pro_conparms
      osh_dbname
      ora_dbname
      ora_version
      ora_username
      ora_password
      ora_conparms
      ora_codepage
      ora_collname
      ora_tspace
      ora_ispace
      pcompatible
      loadsql
      movedata WHEN mvdta 
      crtdefault
      shadowcol
      sqlwidth
      btn_OK btn_Cancel 
      &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
            btn_Help
      &ENDIF      
      WITH FRAME x.
    
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
        NEXT _updtvar.
      END.
      ELSE 
        CREATE ALIAS DICTDB FOR DATABASE VALUE(pro_dbname).  
    END.
    ELSE
      ASSIGN old-dictdb = LDBNAME("DICTDB").
  
    IF loadsql THEN DO:
      IF Osh_dbname = "" OR osh_dbname = ? THEN DO:
        IF "{&WINDOW-SYSTEM}" <> "TTY" THEN
           MESSAGE "Schema holder database Name is required."  VIEW-AS ALERT-BOX ERROR.
        ELSE
           MESSAGE "Schema holder Database Name is required." .   
        NEXT _updtvar.
      END.

      IF ora_dbname = "" OR ora_dbname = ? THEN DO:
        IF "{&WINDOW-SYSTEM}" <> "TTY" THEN
           MESSAGE "Oracle Database Name is required."  VIEW-AS ALERT-BOX ERROR.
        ELSE
           MESSAGE "Oracle Database Name is required." .   
        NEXT _updtvar.
      END.

      IF ora_username = "" OR ora_username = ? THEN DO:
        IF "{&WINDOW-SYSTEM}" <> "TTY" THEN
           MESSAGE "Oracle User Name is required."  VIEW-AS ALERT-BOX ERROR.
        ELSE
           MESSAGE "Oracle User Name is required." .   
        NEXT _updtvar.
      END.

      IF (ora_password = "" OR ora_password = ?) and
        (INDEX(ora_username, "/") = 0) THEN DO:       
        IF "{&WINDOW-SYSTEM}" <> "TTY" THEN
           MESSAGE "Oracle User Password is required."  VIEW-AS ALERT-BOX ERROR.
        ELSE
           MESSAGE "Oracle User Password is required." .   
        NEXT _updtvar.
      END.

      IF (ora_conparms = "" OR ora_conparms = ?) AND
         (ora_sid = "" OR ora_sid = ?) AND
         (INDEX(ora_username, "@") = 0 AND INDEX(ora_password, "@") = 0) THEN DO:
        IF "{&WINDOW-SYSTEM}" <> "TTY" THEN
           MESSAGE "Oracle connect parameters are required."  VIEW-AS ALERT-BOX ERROR.
        ELSE
           MESSAGE "Oracle connect parameters are required or ORACLE_SID must be set." .   
        NEXT _updtvar.
      END.   
    END.      
    LEAVE _updtvar.
  END.
  ELSE DO:
    IF osh_dbname <> "" AND osh_dbname <> ? THEN
        output_file = osh_dbname + ".log".
    ELSE
        output_file = "protoora.log". 
             
    OUTPUT STREAM logfile TO VALUE(output_file) NO-ECHO NO-MAP UNBUFFERED. 
    logfile_open = true. 
 
    IF pro_dbname = "" OR pro_dbname = ? THEN DO:
      PUT STREAM logfile UNFORMATTED "Progress Database name is required." SKIP.
      ASSIGN err-rtn = TRUE.
    END.
    ELSE
      ASSIGN old-dictdb = pro_dbname.
      
    IF loadsql THEN DO:
      IF Osh_dbname = "" OR osh_dbname = ? THEN DO:
         PUT STREAM logfile UNFORMATTED  "Schema holder Database Name is required." SKIP.   
         ASSIGN err-rtn = TRUE.        
      END.
      IF ora_dbname = "" OR ora_dbname = ? THEN DO:
         PUT STREAM logfile UNFORMATTED "Oracle Database Name is required." SKIP.   
         ASSIGN err-rtn = TRUE.
      END.
      IF ora_username = "" OR ora_username = ? THEN DO:
         PUT STREAM logfile UNFORMATTED "Oracle User Name is required." SKIP.   
         ASSIGN err-rtn = TRUE.
      END.
      IF ora_password = "" OR ora_password = ? THEN DO:
         PUT STREAM logfile UNFORMATTED "Oracle User Password is required." SKIP.   
         ASSIGN err-rtn = TRUE.
      END.
      IF (ora_conparms = "" OR ora_conparms = ?) AND
         (ora_sid = "" OR ora_sid = ? ) AND
         ((INDEX(ora_username, "@") = 0) OR (INDEX(ora_password, "@") = 0)) THEN DO:
         PUT STREAM logfile UNFORMATTED "Oracle connect parameters are required or ORACLE_SID must be set29." SKIP.   
         ASSIGN err-rtn = TRUE.
      END.
    END.  
    IF err-rtn THEN RETURN.    
  END. 
  ASSIGN redo = TRUE.
  RUN prodict/ora/protoor1.p.
  IF RETURN-VALUE = "indb" THEN DO:
    ASSIGN redo = FALSE.
    UNDO, RETRY.
  END.

 
  /*
   * If this is batch mode, make sure we close the output file we
   * opened above and clean up.
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
 
 





