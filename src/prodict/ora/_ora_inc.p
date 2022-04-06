/*********************************************************************
* Copyright (C) 2008 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* Procedure _ora_inc.p
   Donna L. McMann
   
   Created 08/19/98 Initial procedure for the Oracle Incremental Df Utility
   History:  12/14/99 D. McMann Changed label for extended objects
             04/13/00 D. McMann Added support for long path names
             06/20/01 D. McMann Added Foreign Owner
             06/25/02 D. McMann Added logic for function based indexes
             11/26/02 D. McMann Removed Oracle V7 support
             06/11/07 fernando  Unicode support   
             08/30/07 fernando  More Unicode support stuff
             01/22/08 fernando  Unicode support for ORACLE
*/   

{ prodict/user/uservar.i NEW }
{ prodict/ora/oravar.i NEW }
{ prodict/misc/filesbtn.i }

DEFINE VARIABLE create_df     AS LOGICAL INITIAL TRUE   NO-UNDO.
DEFINE VARIABLE batch_mode    AS LOGICAL INITIAL FALSE  NO-UNDO. 
DEFINE VARIABLE output_file   AS CHARACTER              NO-UNDO.
DEFINE VARIABLE df-file       AS CHARACTER              NO-UNDO.
DEFINE VARIABLE i             AS INTEGER                NO-UNDO.
DEFINE VARIABLE schdbcon      AS LOGICAL INITIAL FALSE  NO-UNDO.
DEFINE VARIABLE conparms      AS CHARACTER              NO-UNDO.
DEFINE VARIABLE l_curr-db     AS INTEGER INITIAL 1      NO-UNDO.
DEFINE VARIABLE l_dbnr        AS INTEGER                NO-UNDO.
DEFINE VARIABLE disp_msg1     AS LOGICAL INITIAL TRUE   NO-UNDO.
DEFINE VARIABLE disp_msg2     AS LOGICAL INITIAL TRUE   NO-UNDO.
DEFINE VARIABLE hasUniSupport AS LOGICAL                NO-UNDO.

DEFINE VARIABLE cFormat       AS CHARACTER 
                              INITIAL "For field widths use:"
                              FORMAT "x(20)" NO-UNDO.

FORM
  " "   SKIP 
    df-file {&STDPH_FILL} FORMAT "x({&PATH_WIDG})"  VIEW-AS FILL-IN SIZE 40 BY 1
         LABEL "Delta DF File" colon  15
  btn_File SKIP SKIP({&VM_WIDG})
  osh_dbname   FORMAT "x(256)"  view-as fill-in size 32 by 1 
    LABEL "Schema Holder Database" colon 35 SKIP({&VM_WID}) 
  ora_conparms FORMAT "x(256)" view-as fill-in size 32 by 1 
    LABEL "Connect parameters for Schema" colon 35 SKIP({&VM_WID})
  ora_dbname   FORMAT "x(32)"  view-as fill-in size 32 by 1 
    LABEL "Logical name for ORACLE Database" colon 35 SKIP({&VM_WID})   
  ora_owner    FORMAT "x(32)"  VIEW-AS FILL-IN SIZE 32 BY 1
    LABEL "ORACLE Object Owner Name" COLON 35 SKIP({&VM_WID}) 
  ora_tspace FORMAT "x(30)" view-as fill-in size 32 by 1
     LABEL "ORACLE tablespace for Tables" colon 35 SKIP({&VM_WID})
  ora_ispace FORMAT "x(30)" view-as fill-in size 32  by 1
     LABEL "ORACLE tablespace for Indexes" colon 35 SKIP({&VM_WID})
  ora_varlen FORMAT ">>>9" 
      VALIDATE (INPUT ora_varlen > 0 AND
                INPUT ora_varlen <= 4000,
                "Maximum length must not be greater than 4000") 
           LABEL "Maximum char length"  COLON 35
  /*space(2) lExpandClob view-as toggle-box label "Expand to CLOB"*/ SKIP({&VM_WIDG})
  SPACE(3) pcompatible view-as toggle-box LABEL "Create RECID Field"  
  crtdefault VIEW-AS TOGGLE-BOX LABEL "Include Default" AT 40  SKIP({&VM_WID})
  SPACE(3) create_df view-as toggle-box LABEL "Create schema holder delta df"
  shadowcol VIEW-AS TOGGLE-BOX LABEL "Create Shadow Columns" AT 40
  SKIP({&VM_WID})
  SPACE(3) lCharSemantics view-as toggle-box LABEL "Char Semantics"
  unicodeTypes view-as toggle-box LABEL "Use Unicode Types"   AT 40
  SKIP({&VM_WID})
  space(3) cFormat VIEW-AS TEXT NO-LABEL COLON 2
  iFmtOption VIEW-AS RADIO-SET RADIO-BUTTONS "Width", 1,
                                             "ABL Format", 2
                               HORIZONTAL NO-LABEL SKIP({&VM_WID})
  lFormat VIEW-AS TOGGLE-BOX LABEL "Expand x(8) to 30" AT 39
             {prodict/user/userbtns.i}
  WITH FRAME read-df ROW 2 CENTERED SIDE-labels 
    DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
    &IF "{&WINDOW-SYSTEM}" <> "TTY"
  &THEN VIEW-AS DIALOG-BOX &ENDIF
  TITLE "Delta df to ORACLE Conversion".

/*=============================Triggers===============================*/

/*----- ON GO or OK -----*/
ON GO OF FRAME read-df
DO:
  IF (df-file:SCREEN-VALUE IN FRAME read-df = ? OR
      df-file:SCREEN-VALUE IN FRAME read-df = "") THEN DO:
    MESSAGE "Delta DF File is required. " VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO df-file IN FRAME read-df.
    RETURN NO-APPLY.
  END.

  IF SEARCH(df-file:SCREEN-VALUE IN FRAME read-df) = ? THEN DO:
    MESSAGE "Can not find a file of this name.  Try again." 
       VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO df-file IN FRAME read-df.
    RETURN NO-APPLY.
  END.
  ELSE
    ASSIGN df-file = df-file:SCREEN-VALUE IN FRAME read-df.

  IF osh_dbname:SCREEN-VALUE IN FRAME read-df = "" OR 
              osh_dbname:SCREEN-VALUE IN FRAME read-df = ? THEN DO:
    MESSAGE "Schema Holder Name is required."  VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO osh_dbname IN FRAME read-df.
    RETURN NO-APPLY. 
  END.
  
  REPEAT l_dbnr = 1 to NUM-DBS:
    IF LDBNAME("DICTDB") = LDBNAME(l_dbnr)
     THEN ASSIGN l_curr-db = l_dbnr.
  END.
  
  DO i = 1 TO NUM-DBS:
    IF PDBNAME(i) = osh_dbname:SCREEN-VALUE IN FRAME read-df OR 
       LDBNAME(i) = osh_dbname:SCREEN-VALUE IN FRAME read-df THEN DO:
      ASSIGN schdbcon = TRUE.
      CREATE ALIAS DICTDB FOR DATABASE 
         VALUE(LDBNAME(osh_dbname:SCREEN-VALUE IN FRAME read-df)).
    END.
  END.
  IF NOT schdbcon THEN DO:
    ASSIGN conparms = ora_conparms:SCREEN-VALUE IN FRAME read-df +  
                            " -ld schdb".
    CONNECT VALUE(osh_dbname:SCREEN-VALUE IN FRAME read-df) 
            VALUE(conparms) NO-ERROR.
    IF NOT CONNECTED(LDBNAME(osh_dbname:SCREEN-VALUE IN FRAME read-df)) THEN DO:
      MESSAGE osh_dbname:SCREEN-VALUE IN FRAME read-df
         " can not be connected using entered connect parameters."
        VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" to osh_dbname IN FRAME read-df.
      RETURN NO-APPLY.
     END.
  END.
END.

/*----- HELP in Oracle Incremental Utility FRAME read-df -----*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
on HELP of frame read-df or CHOOSE of btn_Help in frame read-df
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                             INPUT {&Incremental_Schema_Migration_Dlg_Box},
                             INPUT ?).
&ENDIF

on WINDOW-CLOSE of frame read-df
   apply "END-ERROR" to frame read-df.

ON LEAVE OF df-file in frame read-df
   df-file:screen-value in frame read-df = 
        TRIM(df-file:screen-value in frame read-df).

ON CHOOSE OF btn_File in frame read-df DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT df-file:handle in frame read-df /*Fillin*/,
        INPUT "Find Input File"  /*Title*/,
        INPUT "*.df"                 /*Filter*/,
        INPUT yes                /*Must exist*/).
END.

ON VALUE-CHANGED OF ora_dbname IN FRAME read-df  DO:
   /* if user changes the name of the logical db name, check the oracle version */
   IF LDBNAME("DICTDB") <> ? THEN DO:
      FOR EACH DICTDB._DB NO-LOCK:
           IF DICTDB._Db._Db-type = "ORACLE" AND 
               DICTDB._Db._Db-name = self:SCREEN-VALUE THEN DO:
              ASSIGN ora_version = DICTDB._Db._Db-misc1[3].
               IF ora_version >= 9 AND DICTDB._Db._Db-xl-name = "utf-8" THEN DO:
                   ASSIGN unicodeTypes:SENSITIVE IN FRAME read-df = YES
                       lCharSemantics:SENSITIVE = YES.
                   unicodeTypes:move-after-tab-item(lCharSemantics:HANDLE) in frame read-df.
                   lCharSemantics:move-after-tab-item(shadowcol:HANDLE) in frame read-df.
                   RETURN.
               END.
           END.
      END.
   END.
   ASSIGN unicodeTypes:SENSITIVE IN FRAME read-df = NO
          unicodeTypes:SCREEN-VALUE IN FRAME read-df = "NO"
          lCharSemantics:SENSITIVE = NO
          lCharSemantics:SCREEN-VALUE = "NO"        .
END.

ON VALUE-CHANGED OF iFmtOption IN FRAME read-df DO:
  IF SELF:SCREEN-VALUE = "1" THEN
    ASSIGN lFormat:CHECKED   = FALSE
           lFormat:SENSITIVE = FALSE.
  ELSE
    ASSIGN lFormat:CHECKED   = TRUE
           lFormat:SENSITIVE = TRUE.
END. 

ON VALUE-CHANGED OF unicodeTypes IN FRAME read-df DO:
    IF SELF:screen-value = "yes" THEN DO:
       ASSIGN lCharSemantics:SENSITIVE = NO
              lCharSemantics:SCREEN-VALUE = "NO"
               /*lExpandClob:SENSITIVE = NO*/
               /*lExpandClob:SCREEN-VALUE = "no"*/
               ora_varlen = 2000
               ora_varlen:SCREEN-VALUE = "2000".

       IF disp_msg1 = TRUE THEN DO:

           ASSIGN disp_msg1 = FALSE.

           MESSAGE "The maximum char length default value is assuming AL16UTF16 encoding for the national" SKIP
                   "character set on the ORACLE database. For UTF8 encoding, you may have to set it to a" SKIP
                   "lower value depending on the data."
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
       END.

    END.
    ELSE DO:
       ASSIGN lCharSemantics:SENSITIVE = YES
              /*lExpandClob:SENSITIVE = YES*/
              ora_varlen = 4000
              ora_varlen:SCREEN-VALUE = "4000".

       /*lExpandClob:move-after-tab-item(ora_varlen:HANDLE) in frame read-df.*/
       lCharSemantics:move-after-tab-item(shadowcol:HANDLE) in frame read-df.
    END.

END.

ON VALUE-CHANGED OF lCharSemantics IN FRAME read-df DO:

    IF SELF:SCREEN-VALUE = "YES" THEN DO:
        IF disp_msg2 = TRUE THEN DO:
            disp_msg2 = FALSE.
    
            MESSAGE "If you select character semantics, you will have to run the update schema" SKIP
                    "utility after you load the .df file into the schema holder for the schema" SKIP
                    "to be valid. Otherwise, you will get a schema mismatch error at runtime for" SKIP
                    "new fields or new tables."
                    VIEW-AS ALERT-BOX WARNING BUTTONS OK.
        END.
    END.
END.

/*==========================Mainline code=============================*/        

{adecomm/okrun.i  
    &FRAME  = "FRAME read-df" 
    &BOX    = "rect_Btns"
    &OK     = "btn_OK" 
    {&CAN_BTN}
}
 
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
   btn_Help:visible IN FRAME read-df = yes.
&ENDIF

IF LDBNAME("DICTDB") <> ? THEN DO:
  FOR EACH DICTDB._DB NO-LOCK:
    IF DICTDB._Db._Db-type = "PROGRESS" THEN
      ASSIGN osh_dbname = LDBNAME ("DICTDB")
             ora_conparms = "<current working database>".
    ELSE IF DICTDB._Db._Db-type = "ORACLE" THEN
      ASSIGN ora_dbname = DICTDB._Db._Db-name
             ora_version = DICTDB._Db._Db-misc1[3]
             hasUniSupport = (DICTDB._Db._Db-xl-name = "utf-8").
  END.
END.

ASSIGN pcompatible = TRUE
       shadowcol = FALSE.
       
ASSIGN shadowcol:TOOLTIP = "Use shadow columns for case insensitive index support".

DISPLAY cFormat lFormat WITH FRAME read-df.

UPDATE df-file 
       btn_file
       osh_dbname
       ora_conparms
       ora_dbname
       ora_owner
       ora_tspace
       ora_ispace
       ora_varlen
       /*lExpandClob*/
       pcompatible
       crtdefault        
       create_df
       shadowcol
       lCharSemantics WHEN ora_version >= 9
       unicodeTypes WHEN ora_version >= 9 AND hasUniSupport
       iFmtOption
       lFormat WHEN iFmtOption = 2
       btn_OK btn_Cancel
       &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
            btn_Help
       &ENDIF
  WITH FRAME read-df.
       
/* make sure these are assigned */
IF unicodeTypes:SCREEN-VALUE ="yes" THEN
   ASSIGN unicodeTypes = YES.
IF lCharSemantics:SCREEN-VALUE = "yes" THEN
   ASSIGN lCharSemantics = YES.

ASSIGN user_env[1]  = df-file
       user_env[3]  = ""
       user_env[4]  = "n"
       user_env[5]  = ";"
       user_env[6]  = "y"
       user_env[7]  = "y"
       user_env[8]  = "y"
       user_env[9]  = "ALL"
       user_env[10] = string(ora_varlen) /* maximum char column length */
                             + "," + "NO" /*STRING(lExpandClob)*/  /* expand to clob */
                             + "," + STRING(lCharSemantics) /* use char semantics */
       user_env[11] = (IF unicodeTypes THEN "nvarchar2" ELSE "varchar2") 
       user_env[12] = "date"
       user_env[13] = "number"
       user_env[14] = "number"
       user_env[15] = "number"
       user_env[16] = "number"
       user_env[17] = "number"
       user_env[19] = "number"
       user_env[20] = "##"
       user_env[22] = "ORACLE"
       user_env[23] = "30"
       user_env[24] = "15"
       user_env[25] = "y"
       user_env[28] = "30"
       user_env[29] = "26"
       user_env[31] = "-- ** "
       user_env[32] = ?
       user_env[34] = ora_tspace
       user_env[35] = ora_ispace.

IF iFmtOption = 1 THEN 
  ASSIGN sqlwidth = TRUE. /* Use _Width field for size */
ELSE IF (lFormat = FALSE) THEN
  ASSIGN sqlwidth = ?. /* Use _Format field for size */
ELSE
  ASSIGN sqlwidth = FALSE. /* Calculate size */
 
/* create df for schema holder */
IF create_df THEN
  ASSIGN user_env[2] = "yes".
ELSE
  ASSIGN user_env[2] = "no".

RUN prodict/ora/_gendsql.p.
 
IF lCharSemantics = TRUE THEN DO:
   MESSAGE "Remember that you may have to run the update schema utility after you load" SKIP
           "the .df file into the schema holder for it to be valid."
           VIEW-AS ALERT-BOX WARNING BUTTONS OK.
END.

IF NOT schdbcon THEN 
   DISCONNECT DICTDB. 
ELSE DO:
  IF LDBNAME(l_curr-db) = ? THEN
    DELETE ALIAS DICTDB.
  ELSE
    RUN adecomm/_setalia.p
        ( INPUT l_curr-db
        ).
END.

    



