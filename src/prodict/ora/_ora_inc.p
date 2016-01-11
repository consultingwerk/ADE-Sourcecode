/*********************************************************************
* Copyright (C) 2006 by Progress Software Corporation. All rights    *
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
    LABEL "Oracle Object Owner Name" COLON 35 SKIP({&VM_WID}) 
  ora_tspace FORMAT "x(30)" view-as fill-in size 32 by 1
     LABEL "ORACLE tablespace for Tables" colon 35 SKIP({&VM_WID})
  ora_ispace FORMAT "x(30)" view-as fill-in size 32  by 1
     LABEL "ORACLE tablespace for Indexes" colon 35 SKIP({&VM_WIDG})      
  SPACE(3) pcompatible view-as toggle-box LABEL "Create RECID Field"  
  SPACE(12) crtdefault VIEW-AS TOGGLE-BOX LABEL "Include Default" 
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN SPACE(13) &ELSE SPACE (14) &ENDIF
  SPACE(3) create_df view-as toggle-box LABEL "Create schema holder delta df" COLON 2
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN SPACE(1) &ELSE SPACE (2) &ENDIF
  shadowcol VIEW-AS TOGGLE-BOX LABEL "Create Shadow Columns" 
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN SPACE(13) &ELSE SPACE (14) &ENDIF
  space(3) cFormat VIEW-AS TEXT NO-LABEL COLON 2
  iFmtOption VIEW-AS RADIO-SET RADIO-BUTTONS "Width", 1,
                                             "4GL Format", 2
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

ON VALUE-CHANGED OF iFmtOption IN FRAME read-df DO:
  IF SELF:SCREEN-VALUE = "1" THEN
    ASSIGN lFormat:CHECKED   = FALSE
           lFormat:SENSITIVE = FALSE.
  ELSE
    ASSIGN lFormat:CHECKED   = TRUE
           lFormat:SENSITIVE = TRUE.
END. 
/*
ON VALUE-CHANGED OF unicodeTypes IN FRAME read-df DO:
    /* when unicode types is set, user can choose whether to allow nvarchar(4000),
       otherwise the max size is 2000 for nvarchar2
    */
    IF SELF:CHECKED THEN DO:
        nvchar_utf:SENSITIVE = YES.
        /* keep tab order right */
        nvchar_utf:move-after-tab-item(unicodeTypes:HANDLE) in frame read-df.
    END.
    ELSE DO:
        ASSIGN nvchar_utf:SENSITIVE = NO
               nvchar_utf:SCREEN-VALUE = "NO".
    END.
END.
*/
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
             ora_version = DICTDB._Db._Db-misc1[3].
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
       pcompatible
       crtdefault        
       create_df
       shadowcol
    /*   unicodeTypes WHEN ora_version >= 10
       nvchar_utf WHEN unicodeTypes */
       iFmtOption
       lFormat WHEN iFmtOption = 2
       btn_OK btn_Cancel
       &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
            btn_Help
       &ENDIF
  WITH FRAME read-df.
       
/*
IF unicodeTypes:SCREEN-VALUE ="yes" THEN
   ASSIGN unicodeTypes = YES.

IF nvchar_utf:SCREEN-VALUE ="yes" THEN
   ASSIGN nvchar_utf = YES.
ELSE
   ASSIGN nvchar_utf = NO.
*/

ASSIGN user_env[1]  = df-file
       user_env[3]  = ""
       user_env[4]  = "n"
       user_env[5]  = ";"
       user_env[6]  = "y"
       user_env[7]  = "y"
       user_env[8]  = "y"
       user_env[9]  = "ALL"
       /*user_env[10] = (IF nvchar_utf THEN "4000" ELSE "2000")*/
       user_env[11] = /*(IF unicodeTypes THEN "nvarchar2" ELSE */ "varchar2" /*) */
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

    



