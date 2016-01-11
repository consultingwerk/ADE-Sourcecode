/*********************************************************************
* Copyright (C) 2006 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
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
            D. McMann 10/23/02 Changed BLANK to PASSWORD-FIELD
            D. McMann 11/26/02 Removed Oracle V7 as an option
          K. McIntosh 09/08/05 Added support for Oracle 10 20050318-015
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
DEFINE VARIABLE cFormat       AS CHARACTER 
                           INITIAL "For field widths use:"
                           FORMAT "x(20)" NO-UNDO.
DEFINE VARIABLE lExpand       AS LOGICAL NO-UNDO.

DEFINE STREAM   strm.

ASSIGN redo = FALSE
       batch_mode = SESSION:BATCH-MODE.


FORM
  pro_dbname   FORMAT "x({&PATH_WIDG})"  view-as fill-in size 32 by 1 
    LABEL "Original {&PRO_DISPLAY_NAME} Database" colon 38 SKIP({&VM_WID}) 
  pro_conparms FORMAT "x(256)" view-as fill-in size 32 by 1 
    LABEL "Connect parameters for {&PRO_DISPLAY_NAME}" colon 38 SKIP({&VM_WID})
  osh_dbname   FORMAT "x(32)"  view-as fill-in size 32 by 1 
    LABEL "Name of Schema holder Database" colon 38 SKIP({&VM_WID})
  ora_dbname   FORMAT "x(32)"  view-as fill-in size 32 by 1 
    LABEL "Logical name for ORACLE Database" colon 38 SKIP({&VM_WID})
  ora_version  FORMAT ">9" 
      validate(INPUT ora_version = 8 OR 
               INPUT ora_version = 9 OR
               INPUT ora_version = 10,
               "Oracle Version must be 8, 9 or 10") 
      view-as fill-in size 23 by 1
    LABEL "What version of ORACLE" colon 38 SKIP ({&VM_WID})  
  ora_username FORMAT "x(32)"  view-as fill-in size 32 by 1 
    LABEL "ORACLE Owner's Username" colon 38 SKIP({&VM_WID})
  ora_password FORMAT "x(32)"  PASSWORD-FIELD
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
  SPACE(9) pcompatible view-as toggle-box LABEL "Create RECID Field "  
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN SPACE(16) &ELSE SPACE(15) &ENDIF
    crtdefault VIEW-AS TOGGLE-BOX LABEL "Include Default" SKIP({&VM_WID})  
  SPACE(9) loadsql view-as toggle-box     label "Load SQL  "  
  &IF "{&WINDOW-SYSTEM}" = "TTY"
  &THEN SPACE(25) &ELSE SPACE(23) &ENDIF
  movedata view-as toggle-box label "Move Data" 
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN SPACE(26) &ELSE SPACE(23) &ENDIF 
  SKIP({&VM_WID})
  SPACE(9) shadowcol VIEW-AS TOGGLE-BOX LABEL "Create Shadow Columns " 
  SKIP({&VM_WID})
  /*SPACE(9) unicodeTypes view-as toggle-box label "Unicode Types "
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN SPACE(21) &ELSE SPACE(19) &ENDIF 
  nvchar_utf view-as toggle-box LABEL "Allow NVARCHAR2(4000)"
  SKIP({&VM_WID}) */
  cFormat VIEW-AS TEXT NO-LABEL AT 10
  iFmtOption VIEW-AS RADIO-SET RADIO-BUTTONS "Width", 1,
                                             "4GL Format", 2
                               HORIZONTAL NO-LABEL SKIP({&VM_WID})
  lExpand VIEW-AS TOGGLE-BOX LABEL "Expand x(8) to 30" AT 46
     {prodict/user/userbtns.i}
  WITH FRAME x ROW 
    &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 1 &ELSE 2 &ENDIF 
    CENTERED SIDE-labels 
    DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
    &IF "{&WINDOW-SYSTEM}" <> "TTY"
  &THEN VIEW-AS DIALOG-BOX &ENDIF
  TITLE "{&PRO_DISPLAY_NAME} DB to ORACLE Conversion".

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


/*----- HELP in OpenEdge DB to Oracle Database -----*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
on HELP of frame x or CHOOSE of btn_Help in frame x
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                             INPUT {&PROGRESS_DB_to_ORACLE_Dlg_Box},
                             INPUT ?).
&ENDIF  
   
ON VALUE-CHANGED OF iFmtOption IN FRAME x DO:
  IF SELF:SCREEN-VALUE = "1" THEN
    ASSIGN lExpand:CHECKED   = FALSE
           lExpand:SENSITIVE = FALSE
           lFormat           = ?.
  ELSE
    ASSIGN lExpand:CHECKED   = TRUE
           lExpand:SENSITIVE = TRUE
           lFormat           = FALSE.
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

/*
ON VALUE-CHANGED OF ora_version IN FRAME x DO:

    /* when ora_version is 10 and up, we support Unicode data types */
    IF INTEGER(ora_version:SCREEN-VALUE IN FRAME X) >= 10 THEN DO:
        ASSIGN unicodeTypes:SENSITIVE = YES.
        /* keep tab order right */
        unicodeTypes:move-after-tab-item(shadowcol:HANDLE) in frame X.
    END.
    ELSE
        ASSIGN unicodeTypes:SENSITIVE = NO
               unicodeTypes:SCREEN-VALUE = "no".

   ora_version = INTEGER(ora_version:SCREEN-VALUE).
END.
    
ON VALUE-CHANGED OF unicodeTypes IN FRAME x DO:
    /* when unicode types is used, user can choose whether to use nvarchar(4000) */
    IF SELF:CHECKED THEN DO:
        nvchar_utf:SENSITIVE = YES.
        /* keep tab order right */
        nvchar_utf:move-after-tab-item(unicodeTypes:HANDLE) in frame X.
    END.
    ELSE DO:
        ASSIGN nvchar_utf:SENSITIVE = NO
               nvchar_utf:SCREEN-VALUE = "NO".
    END.
END.
*/

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
   ASSIGN shadowcol:TOOLTIP = "Use shadow columns for case insensitive index support".
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
     
/* Initialize field width choice */
IF OS-GETENV("SQLWIDTH") <> ? THEN DO:
  tmp_str      = OS-GETENV("SQLWIDTH").
  IF tmp_str BEGINS "Y" THEN iFmtOption = 1.
  ELSE iFmtOption = 2.
END. 
ELSE
  iFmtOption = 2.

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
ELSE
  ASSIGN shadowcol = FALSE.

IF OS-GETENV("EXPANDX8") <> ? THEN DO:
    ASSIGN tmp_str  = OS-GETENV("EXPANDX8").
    IF tmp_str BEGINS "Y" THEN 
      ASSIGN lExpand = TRUE
             lFormat = FALSE.
    ELSE 
      ASSIGN lExpand = FALSE
             lFormat = TRUE.
END. 
ELSE
    ASSIGN lExpand = TRUE
           lFormat = FALSE.

/* Unicode Types only support for ORACLE 10 and up */
/*
IF OS-GETENV("UNICODETYPES")  <> ? AND ora_version >= 10 THEN DO:

  tmp_str      = OS-GETENV("UNICODETYPES").

  IF tmp_str BEGINS "Y" THEN DO:
      ASSIGN unicodeTypes = TRUE.

      tmp_str = OS-GETENV("NVARCHAR2_4K").
      IF tmp_str BEGINS "Y" THEN
          nvchar_utf = YES.
  END.
END.
*/

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

  /*IF ora_version >= 10 THEN
     unicodeTypes:SENSITIVE = YES.
  ELSE
     ASSIGN unicodeTypes:SENSITIVE = NO
            unicodeTypes:SCREEN-VALUE = "no".
            */
  /*
   * if this is not batch mode, allow override of environment variables.
   */
  PAUSE 0 BEFORE-HIDE.
  IF NOT batch_mode THEN 
  _updtvar: 
   DO WHILE TRUE:
    DISPLAY cFormat lExpand WITH FRAME x.
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
      crtdefault
      loadsql
      movedata WHEN mvdta 
      shadowcol
     /* unicodeTypes WHEN ora_version >= 10
      nvchar_utf WHEN unicodeTypes */
      iFmtOption
      lExpand WHEN iFmtOption = 2
      btn_OK btn_Cancel 
      &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
            btn_Help
      &ENDIF      
      WITH FRAME x.
    
    IF iFmtOption = 1 THEN
      lFormat = ?.
    ELSE
      lFormat = (NOT lExpand).

   /* IF ora_version >= 10 AND unicodeTypes:SCREEN-VALUE = "yes" THEN DO:
        ASSIGN unicodeTypes = YES.
        IF nvchar_utf:SCREEN-VALUE = "yes" THEN
            ASSIGN nvchar_utf = YES.
        ELSE
            ASSIGN nvchar_utf = NO. 
    END.
    ELSE
        ASSIGN unicodeTypes = NO. */

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
          PUT STREAM logfile UNFORMATTED "Unable to connect to {&PRO_DISPLAY_NAME} database"
            skip.
        ELSE DO:
          &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
            MESSAGE "Unable to connect to {&PRO_DISPLAY_NAME} database".
          &ELSE
            MESSAGE "Unable to connect to {&PRO_DISPLAY_NAME} database" 
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
      PUT STREAM logfile UNFORMATTED "{&PRO_DISPLAY_NAME} Database name is required." SKIP.
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
         PUT STREAM logfile UNFORMATTED "Oracle connect parameters are required or ORACLE_SID must be set." SKIP.   
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

