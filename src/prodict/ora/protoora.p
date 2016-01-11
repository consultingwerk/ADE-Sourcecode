/*********************************************************************
* Copyright (C) 2007 by Progress Software Corporation. All rights    *
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
             fernando 06/11/07 Unicode and clob support   
             fernando 08/30/07 More Unicode support stuff       
             fernando 09/14/07 Allow ORACLE version 11
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
DEFINE VARIABLE wrg-ver       AS LOGICAL INITIAL FALSE    NO-UNDO.
DEFINE VARIABLE disp_msg1      AS LOGICAL INITIAL TRUE     NO-UNDO.
DEFINE VARIABLE disp_msg2      AS LOGICAL INITIAL TRUE     NO-UNDO.

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
               INPUT ora_version = 10 OR
               INPUT ora_version = 11,
               "Oracle Version must be 8, 9, 10 or 11") 
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
  ora_varlen FORMAT ">>>9" 
    VALIDATE (INPUT ora_varlen > 0 AND
              INPUT ora_varlen <= 4000,
              "Maximum length must not be greater than 4000") 
         LABEL "Maximum char length"  COLON 38
  space(1) lExpandClob view-as toggle-box label "Expand to CLOB" SKIP({&VM_WID})
  " ORACLE tablespace name for:" view-as text SKIP({&VM_WID})   
  ora_tspace FORMAT "x(30)" view-as fill-in size 30 by 1
     LABEL "Tables" colon 8
  ora_ispace FORMAT "x(30)" view-as fill-in size 30 by 1
     LABEL "Indexes" colon 47 
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN SKIP({&VM_WID}) &ELSE SKIP({&VM_WIDG}) &ENDIF
  SPACE(2) pcompatible view-as toggle-box LABEL "Create RECID Field "  
  loadsql view-as toggle-box     label "Load SQL  "  AT 32
  movedata view-as toggle-box label "Move Data" AT 53 SKIP({&VM_WID})
  SPACE(2) shadowcol VIEW-AS TOGGLE-BOX LABEL "Create Shadow Columns " 
  crtdefault VIEW-AS TOGGLE-BOX LABEL "Include Default" AT 32
  lCharSemantics VIEW-AS TOGGLE-BOX LABEL "Char semantics" AT 53
  SKIP({&VM_WID})
  SPACE(2)  unicodeTypes view-as toggle-box label "Use Unicode Types "
  SKIP({&VM_WID}) 
  cFormat VIEW-AS TEXT NO-LABEL AT 10
  iFmtOption VIEW-AS RADIO-SET RADIO-BUTTONS "Width", 1,
                                             "ABL Format", 2
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

ON VALUE-CHANGED OF ora_version IN FRAME x DO:
    
    /* when ora_version is 9 and up, we support Unicode data types */
    IF INTEGER(ora_version:SCREEN-VALUE IN FRAME X) >= 9 THEN DO:
        ASSIGN unicodeTypes:SENSITIVE = YES
                     lCharSemantics:SENSITIVE = YES.

        /* keep tab order right */
        lCharSemantics:move-after-tab-item(crtdefault:HANDLE) in frame X.
        unicodeTypes:move-after-tab-item(lCharSemantics:HANDLE) in frame X.
    END.
    ELSE DO:
        ASSIGN unicodeTypes:SENSITIVE = NO
               unicodeTypes:SCREEN-VALUE = "no"
               lCharSemantics:SENSITIVE = NO
               lCharSemantics:SCREEN-VALUE = "no"
               ora_codepage = session:cpinternal
               ora_codepage:SCREEN-VALUE = session:CPINTERNAL
               ora_varlen = 4000
               ora_varlen:SCREEN-VALUE = "4000".
    END.

   ora_version = INTEGER(ora_version:SCREEN-VALUE).
END.
    
ON VALUE-CHANGED OF unicodeTypes IN FRAME x DO:

    IF SELF:screen-value = "yes" THEN DO:
        ASSIGN lCharSemantics:SENSITIVE = NO
               lCharSemantics:SCREEN-VALUE = "NO"
               ora_codepage = 'UTF-8'
               ora_codepage:SCREEN-VALUE = 'UTF-8'.

        ASSIGN ora_varlen = 2000
               ora_varlen:SCREEN-VALUE = "2000".
        IF disp_msg1 = TRUE THEN DO:

            ASSIGN disp_msg1 = FALSE.

            MESSAGE "The maximum char length default value is assuming AL16UTF16 encoding for the national" SKIP
                    "character set on the ORACLE database. For UTF8 encoding, you may have to set it to a" SKIP
                    "lower value depending on the data."
                VIEW-AS ALERT-BOX WARNING BUTTONS OK.
        END.
    END.
    ELSE DO:
        ASSIGN lCharSemantics:SENSITIVE = YES
               ora_codepage = session:cpinternal
               ora_codepage:SCREEN-VALUE = session:cpinternal.

        ASSIGN ora_varlen = 4000
               ora_varlen:SCREEN-VALUE = "4000".

        lCharSemantics:move-after-tab-item(crtdefault:HANDLE) in frame X.
    END.
END.

ON VALUE-CHANGED OF ora_codepage IN FRAME x DO:

 /* if not 9 or above, nothing to be done */
 IF INTEGER(ora_version:SCREEN-VALUE IN FRAME X) >= 9 THEN DO:

    /* if utf-8, we make character semantics the default */
    IF TRIM(SELF:SCREEN-VALUE) = "UTF-8" 
       AND unicodeTypes:SCREEN-VALUE = "NO" THEN DO:

        ASSIGN lCharSemantics:SCREEN-VALUE = "YES"
               ora_varlen = 1000
               ora_varlen:SCREEN-VALUE = "1000".

        IF disp_msg2 = TRUE THEN DO:
           disp_msg2 = FALSE.
           MESSAGE "To accommodate for data expansion depending on the database character set, the " SKIP
                   "maximum char length default was automatically modified. Character semantics" SKIP
                   "was also selected. You may have to change them if they do not apply for your" SKIP
                   "configuration or data."
               VIEW-AS ALERT-BOX WARNING BUTTONS OK.
        END.

    END.
 END.

END.

ON LEAVE OF ora_codepage IN FRAME X DO:

    IF unicodeTypes:SCREEN-VALUE = "yes" THEN DO:
        IF ora_codepage:SCREEN-VALUE NE "UTF-8" THEN
            MESSAGE "It is recommended that you set the schema codepage to UTF-8 when selecting" SKIP
                    "Unicode Types."
                VIEW-AS ALERT-BOX WARNING BUTTONS OK.

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

IF OS-GETENV("CHARSEMANTICS")  <> ? AND ora_version >= 9 THEN DO:
  tmp_str      = OS-GETENV("CHARSEMANTICS").

  IF tmp_str BEGINS "Y" THEN
      ASSIGN lCharSemantics = TRUE.
END.
ELSE IF ora_version >= 9 AND ora_codepage = "utf-8" THEN
     ASSIGN lCharSemantics = TRUE.

IF OS-GETENV("EXPANDCLOB") <> ? THEN DO:
    ASSIGN tmp_str  = OS-GETENV("EXPANDCLOB").
    IF tmp_str BEGINS "Y" THEN.
END.

/* Unicode Types only support for ORACLE 9 and up */

IF OS-GETENV("UNICODETYPES")  <> ? AND ora_version >= 9 THEN DO:
  tmp_str      = OS-GETENV("UNICODETYPES").

  IF tmp_str BEGINS "Y" THEN DO:
      ASSIGN unicodeTypes = TRUE
             lCharSemantics = NO.  /* irrelevant */

      IF OS-GETENV("ORACODEPAGE") = ? THEN
         ASSIGN ora_codepage = 'UTF-8'.
  END.
END.

IF OS-GETENV("VARLENGTH") <> ? THEN DO:
   ASSIGN ora_varlen = integer(OS-GETENV("VARLENGTH")).
   IF ora_varlen < 1000 OR ora_varlen > 4000 THEN
      ora_varlen = 4000.
END.
ELSE DO:

   IF unicodeTypes THEN
      ASSIGN ora_varlen = 2000.
   ELSE IF ora_codepage = "utf-8" THEN
      ASSIGN ora_varlen = 1000.
   ELSE
      ASSIGN ora_varlen = 4000.
END.

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

  IF logfile_open THEN DO:
     OUTPUT STREAM logfile CLOSE.
     logfile_open = FALSE.
  END.

  IF wrg-ver THEN DO:
     MESSAGE "Unicode support for the DataServer for ORACLE was designed to work" SKIP
             "with ORACLE 9 and above. You have tried to connect to a prior" SKIP
             "version of ORACLE. " SKIP
        &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
              VIEW-AS ALERT-BOX ERROR BUTTONS OK
       &ENDIF
        . /* end of message statement */
     RETURN.
  END.

  run_time = TIME.

  IF ora_version >= 9 THEN
     ASSIGN unicodeTypes:SENSITIVE = YES
            lCharSemantics:SENSITIVE = YES.
  ELSE
     ASSIGN unicodeTypes:SENSITIVE = NO
            unicodeTypes:SCREEN-VALUE = "no"
            lCharSemantics:SENSITIVE = NO
            lCharSemantics:SCREEN-VALUE = "no".
            
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
      ora_varlen
      ora_tspace
      ora_ispace
      pcompatible
      loadsql
      movedata WHEN mvdta 
      shadowcol
      crtdefault
      lCharSemantics WHEN ora_version >= 9
      unicodeTypes WHEN ora_version >= 9
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

    IF ora_version >= 9 THEN DO: 
        /* these start disabled in the above update stmt, so we have to manually update them now*/
        IF unicodeTypes:SCREEN-VALUE = "yes" THEN
           ASSIGN unicodeTypes = YES.
        IF lCharSemantics:SCREEN-VALUE = "yes" THEN
           ASSIGN lCharSemantics = YES.
    END.
    ELSE
        ASSIGN unicodeTypes = NO
               lCharSemantics = NO.

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
  ELSE IF RETURN-VALUE = "wrg-ver" THEN DO:
     ASSIGN wrg-ver = TRUE.

     IF batch_mode THEN DO:
        PUT STREAM logfile UNFORMATTED 
               "Unicode support for the DataServer for ORACLE was designed to work" SKIP
               "with ORACLE 9 and above. You have tried to connect to a prior" SKIP
               "version of ORACLE. " SKIP.
        OUTPUT STREAM logfile CLOSE.
        logfile_open = FALSE.
        RUN cleanup.
     END.

     UNDO main-blk, RETRY main-blk.
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

