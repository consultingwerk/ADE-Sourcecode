/*********************************************************************
* Copyright (C) 2005,2007-2011 by Progress Software Corporation. All rights    *
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
             fernando 08/28/08 Commented out references to lExpandClob - not supported yet.
             kmayur   06/21/11 screen split for constraint migration
             sbehera  02/03/14 Support for oracle 12 version and changed default version to 11
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
DEFINE VARIABLE prelCharSem AS LOGICAL NO-UNDO.
DEFINE VARIABLE preuniTypes AS LOGICAL NO-UNDO.
DEFINE VARIABLE cFormat       AS CHARACTER 
                           INITIAL "For field widths use:"
                           FORMAT "x(20)" NO-UNDO.
DEFINE VARIABLE wrg-ver       AS LOGICAL INITIAL FALSE    NO-UNDO.
DEFINE VARIABLE wrng-collat   AS LOGICAL INITIAL FALSE    NO-UNDO.
DEFINE VARIABLE disp_msg1      AS LOGICAL INITIAL TRUE     NO-UNDO.
DEFINE VARIABLE disp_msg2      AS LOGICAL INITIAL TRUE     NO-UNDO.
DEFINE button s_btn_Advanced SIZE 24 by 1.125.
DEFINE STREAM   strm.
DEFINE VARIABLE varlen      AS INTEGER NO-UNDO.

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
               INPUT ora_version = 11 OR
               INPUT ora_version = 12,
               "Oracle Version must be 10, 11 or 12") 
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
    VALIDATE (INPUT ora_varlen > 0,
              "Maximum char length must be a positive value.") 
         LABEL "Maximum char length"  COLON 38
 /* space(1) lExpandClob view-as toggle-box label "Expand to CLOB"*/ SKIP({&VM_WID})
  " ORACLE tablespace name for:" view-as text SKIP({&VM_WID})   
  ora_tspace FORMAT "x(30)" view-as fill-in size 30 by 1
     LABEL "Tables" colon 8
  ora_ispace FORMAT "x(30)" view-as fill-in size 30 by 1
     LABEL "Indexes" colon 47 
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN SKIP({&VM_WID}) &ELSE SKIP({&VM_WIDG}) &ENDIF
  loadsql view-as toggle-box     label "Load SQL  "  AT 3 SKIP({&VM_WID})
  movedata view-as toggle-box label "Move Data" AT 3 
  s_btn_Advanced label "Advanced..." AT 53 SKIP({&VM_WID})   SPACE(2)
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

ON VALUE-CHANGED of loadsql IN FRAME x DO:
  IF SELF:screen-value = "yes" THEN 
     movedata:sensitive in frame x = YES.
  ELSE DO:
     movedata:screen-value in frame x = "no".
     movedata = false.
     movedata:sensitive in frame x = NO.
  END.   
END.  

PROCEDURE fill_utf:

 IF unicodeTypes = YES THEN DO:
   IF SUBSTR(trim(ora_codepage:SCREEN-VALUE in frame x),1,4) = "UTF-" THEN DO:
      IF INTEGER(ora_varlen:SCREEN-VALUE in frame x) <> 2000  THEN 
         ASSIGN ora_varlen:SCREEN-VALUE in frame x = "2000".
   END.
 END.  
 ELSE  IF lCharSemantics = YES THEN DO: 
   IF SUBSTR(Trim(ora_codepage:SCREEN-VALUE in frame x),1,4) = "UTF-" THEN DO:
      IF INTEGER(ora_varlen:SCREEN-VALUE in frame x) > 1000  THEN 
         ASSIGN ora_varlen:SCREEN-VALUE in frame x = "1000".
   END.
 END.
 ELSE DO:
     IF prelCharSem <> lCharSemantics OR preuniTypes <> unicodeTypes THEN DO:  /* PSC00321497 */
     /*  UTF- codepage without UseUnicode or CharSemantics is a valid scenario */
       IF ora_varlen:SCREEN-VALUE in frame x <> "4000" THEN DO:
          ASSIGN ora_varlen:SCREEN-VALUE in frame x= "4000".
          MESSAGE "Without Char Semantics OR Use Unicode Types, the Maximum char length has been reset to 4000 with Codepage: " ora_codepage:SCREEN-VALUE in frame x SKIP
                VIEW-AS ALERT-BOX WARNING BUTTONS OK.
       END.
     END. 
 END.
END PROCEDURE.

ON VALUE-CHANGED OF ora_version IN FRAME x DO:
    
    /* when ora_version is 9 and up, we support Unicode data types */
    IF INTEGER(ora_version:SCREEN-VALUE IN FRAME X) >= 9 THEN DO:
        ASSIGN uctype = TRUE
               lcsemantic = TRUE.
        
    END.
    ELSE DO:
        ASSIGN uctype = FALSE
               lcsemantic = FALSE
               ora_codepage = session:cpinternal
               ora_codepage:SCREEN-VALUE = session:CPINTERNAL
               ora_varlen = 4000
               ora_varlen:SCREEN-VALUE = "4000".
    END.

   ora_version = INTEGER(ora_version:SCREEN-VALUE).
END.
    
ON VALUE-CHANGED OF ora_codepage IN FRAME x DO:

 /* if not 9 or above, nothing to be done */
 IF INTEGER(ora_version:SCREEN-VALUE IN FRAME X) >= 9 THEN DO:

    /* if utf-8, we make character semantics the default */
    IF ( TRIM(SELF:SCREEN-VALUE) = "UTF-8" OR  TRIM(SELF:SCREEN-VALUE) = "UTF-16")
    THEN DO:
      IF unicodeTypes = FALSE THEN DO:
        ASSIGN lCharSemantics = TRUE
               lcsemantic = TRUE
               ora_varlen = 1000
               ora_varlen:SCREEN-VALUE = "1000".

        IF disp_msg2 = TRUE THEN DO:
        /*   disp_msg2 = FALSE. */
           MESSAGE "To accommodate for data expansion depending on the database character set, the 
maximum char length default was automatically modified. Character semantics was also selected." SKIP(1)
		   "You may have to change them if they do not apply for your configuration or data." SKIP
               VIEW-AS ALERT-BOX WARNING BUTTONS OK.
        END.
      END.
      ELSE DO:
        ASSIGN lCharSemantics = FALSE
               lcsemantic = FALSE
               ora_varlen = 2000
               ora_varlen:SCREEN-VALUE = "2000".
        IF disp_msg2 = TRUE THEN DO:
           MESSAGE "To accommodate for data expansion depending on the database character set, the 
maximum char length default was automatically modified." SKIP(1)
           "You may have to change them if they do not apply for your configuration or data." SKIP
               VIEW-AS ALERT-BOX WARNING BUTTONS OK.
        END.
      END. 
    END.
 END.

END.

ON LEAVE OF ora_codepage IN FRAME X DO:
    IF unicodeTypes = TRUE THEN DO:
        IF SUBSTR(trim(ora_codepage:SCREEN-VALUE),1,4) NE "UTF-" THEN 
            MESSAGE "It is recommended that you set the schema codepage to UTF when selecting Unicode Types." SKIP
                VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    END.
END.


ON LEAVE OF ora_varlen IN FRAME X DO:

 IF unicodeTypes = YES THEN DO:
   IF SUBSTR(trim(ora_codepage:SCREEN-VALUE in frame x),1,4) = "UTF-" THEN DO:
      IF INTEGER(ora_varlen:SCREEN-VALUE in frame x) > 2000  THEN DO:
         MESSAGE "Max Char Length cannot exceed 2000 for UTF when selecting" SKIP
                    "Unicode Types."
                VIEW-AS ALERT-BOX WARNING BUTTONS OK.
         RETURN NO-APPLY.
      END.
   END.
 END.  
 ELSE  IF lCharSemantics = YES THEN DO: 
   IF SUBSTR(Trim(ora_codepage:SCREEN-VALUE in frame x),1,4) = "UTF-" THEN DO:
      IF INTEGER(ora_varlen:SCREEN-VALUE in frame x) > 1000  THEN  DO:
         MESSAGE "Max Char Length cannot exceed 1000 for UTF when selecting" SKIP
                    "Char Semantics."
                VIEW-AS ALERT-BOX WARNING BUTTONS OK.
         RETURN NO-APPLY.
      END.
   END.
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
  ora_version = 11.       
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
  IF tmp_str BEGINS "Y" 
           THEN iShadow = 2.           
           ELSE iShadow = 1.
END. 
ELSE
  ASSIGN iShadow = 1.

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
ELSE IF ora_version >= 9 AND substr(ora_codepage,1,4) = "utf-" THEN
     ASSIGN lCharSemantics = TRUE.

/*
IF OS-GETENV("EXPANDCLOB") <> ? THEN DO:
    ASSIGN tmp_str  = OS-GETENV("EXPANDCLOB").
    IF tmp_str BEGINS "Y" THEN 
        ASSIGN lExpandClob = TRUE.
END.
*/

/* Unicode Types only support for ORACLE 9 and up */

IF OS-GETENV("UNICODETYPES")  <> ? AND ora_version >= 9 THEN DO:
  tmp_str      = OS-GETENV("UNICODETYPES").

  IF tmp_str BEGINS "Y" THEN DO:
      ASSIGN unicodeTypes = TRUE
             lCharSemantics = NO  /* irrelevant */
             /*lExpandClob = NO*/ . /* irrelevant */

      IF OS-GETENV("ORACODEPAGE") = ? THEN
         ASSIGN ora_codepage = 'UTF-8'.
  END.
END.

IF OS-GETENV("VARLENGTH") <> ? THEN DO:
   ASSIGN varlen = integer(OS-GETENV("VARLENGTH")).
   IF varlen < 0 OR varlen > 4000 THEN
    ASSIGN ora_varlen = 4000.
END.
ELSE DO:
   IF unicodeTypes THEN
      ASSIGN ora_varlen = 2000.
   ELSE IF SUBSTR(ora_codepage,1,4) = "utf-" THEN
      ASSIGN ora_varlen = 1000.
   ELSE
      ASSIGN ora_varlen = 4000.
END.

IF OS-GETENV("MIGRATECONSTR")   <> ? 
  THEN DO:
   tmp_str = OS-GETENV("MIGRATECONSTR").
   IF tmp_str BEGINS "y" 
     THEN migConstraint = yes.
     ELSE migConstraint = no.
  END.
  ELSE migConstraint = yes.
  
IF OS-GETENV("UNIQUECONSTR")   <> ?
 THEN DO:
  tmp_str  = OS-GETENV("UNIQUECONSTR").
  IF tmp_str BEGINS "y" 
    THEN choiceUniquness = "2".
    ELSE choiceUniquness = "1".
 END.   
    ELSE choiceUniquness = "1".

IF OS-GETENV("NLSUPPER") <> ? AND iShadow = 1
 THEN DO:
   tmp_str  = OS-GETENV("NLSUPPER").
   IF tmp_str BEGINS "Y" 
     THEN DO:
        nls_up = YES.
        IF OS-GETENV("SORTNAME") <> ?
            THEN oralang = OS-GETENV("SORTNAME").
            ELSE 
                 ASSIGN nls_up = NO
                        oralang = "BINARY".
     END.       
     ELSE 
     ASSIGN nls_up = NO
            oralang = "BINARY".
  END.
  ELSE 
  ASSIGN nls_up = NO
         oralang = "BINARY".
        
IF PROGRESS EQ "COMPILE-ENCRYPT" THEN
  ASSIGN mvdta = FALSE.
ELSE
  ASSIGN mvdta = TRUE.


if   pro_dbname   = ldbname("DICTDB") and pro_conparms = "" then 
  assign pro_conparms = "<current working database>".

 ASSIGN var_len = INTEGER(ora_varlen:screen-value).
ON CHOOSE OF s_btn_Advanced in frame X
DO:
     ASSIGN var_len = INTEGER(ora_varlen:screen-value)
            ora_codepage = ora_codepage:SCREEN-VALUE
            prelCharSem = lCharSemantics
            preuniTypes = unicodeTypes.
     run prodict/ora/_protoora.p.
     run fill_utf.
END.
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
          ASSIGN uctype = TRUE
                 lcsemantic = TRUE.
  ELSE
          ASSIGN uctype = FALSE
                 lcsemantic = FALSE.
  IF wrng-collat THEN DO:
     MESSAGE "Missing or invalid Oracle Language . " SKIP
              &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
              VIEW-AS ALERT-BOX ERROR BUTTONS OK
       &ENDIF
        . /* end of message statement */
     RETURN.
  END.

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
      ora_varlen
      /*lExpandClob*/
      ora_tspace
      ora_ispace
      loadsql
      movedata WHEN mvdta 
      s_btn_Advanced
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
            MESSAGE ERROR-STATUS:GET-MESSAGE(i).
        END.

        &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
            MESSAGE "Unable to connect to {&PRO_DISPLAY_NAME} database".
        &ELSE
            MESSAGE "Unable to connect to {&PRO_DISPLAY_NAME} database" 
             VIEW-AS ALERT-BOX ERROR.
        &ENDIF

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
    ELSE DO:

        IF LDBNAME ("DICTDB") <> pro_dbname THEN DO:
          ASSIGN old-dictdb = LDBNAME("DICTDB").
          IF NOT CONNECTED(pro_dbname) THEN
            CONNECT VALUE (pro_dbname) VALUE (pro_conparms) -1 NO-ERROR.              
          
          IF ERROR-STATUS:ERROR OR NOT CONNECTED (pro_dbname) THEN DO:
            DO i = 1 TO  ERROR-STATUS:NUM-MESSAGES:
               PUT STREAM logfile UNFORMATTED ERROR-STATUS:GET-MESSAGE(i) skip.
            END.

            PUT STREAM logfile UNFORMATTED "Unable to connect to {&PRO_DISPLAY_NAME} database"
                skip.
            ASSIGN err-rtn = TRUE.
          END.
          ELSE 
            CREATE ALIAS DICTDB FOR DATABASE VALUE(pro_dbname).  
        END.
        ELSE
          ASSIGN old-dictdb = LDBNAME("DICTDB").
    END.
      
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
      IF ( ora_password = "" OR ora_password = ? ) AND 
         NOT ora_username BEGINS "/" THEN DO:
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

 IF varlen < 0 OR varlen > 4000 THEN DO:
      IF batch_mode THEN  
         PUT STREAM logfile UNFORMATTED "Maximum length must not be smaller then 0 or bigger than 4000,Default set to 4000." skip.
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
  
  ELSE IF RETURN-VALUE = "wrng-collat" THEN DO:
   ASSIGN wrng-collat = TRUE.

   IF batch_mode THEN DO:
      PUT STREAM logfile UNFORMATTED
             "Missing or invalid Oracle Language" SKIP.
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
    IF old-dictdb NE ? THEN
       CREATE ALIAS DICTDB FOR DATABASE VALUE(old-dictdb).   
  END.

END.

