/*********************************************************************
* Copyright (C) 2006-2011 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* Procedure _mss_inc.p
   Donna L. McMann
   
   Created 12/03/02 Initial procedure for the MSS Incremental Df Utility
   
   fernando   04/17/06 Unicode support
   fernando   07/19/06 Unicode support - restrict UI   
   fernando   08/10/07 Removed UI restriction for Unicode support  
   fernando   01/22/08 Check if codepage is utf-8 before allowing unicode types 
   fernando   04/21/08 Support for new sequence generator
   fernando   03/28/09 Support for datetime-tz
   Nagaraju   09/23/09 Implementation for Computed columns
   Nagaraju   11/12/09 Remove numbers for radio-set options in MSSDS
      sdash   05/07/13 Added Logical DB validation in a Schema Holder.
                       Added logging mechanism.
*/   

{ prodict/user/uservar.i NEW }
{ prodict/mss/mssvar.i NEW }
{ prodict/misc/filesbtn.i }

DEFINE SHARED VARIABLE select_dbname   AS CHARACTER     NO-UNDO.
DEFINE VARIABLE dflt_dbname    AS CHARACTER             NO-UNDO.
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
                              FORMAT "x(21)" NO-UNDO.
DEFINE VARIABLE cRecid        AS CHARACTER 
                              INITIAL "For Create RECID use:"
                              FORMAT "x(22)" NO-UNDO.
DEFINE VARIABLE tmp_str       AS CHARACTER              NO-UNDO.
DEFINE VARIABLE s_res         AS LOGICAL                NO-UNDO.
DEFINE VARIABLE hasUniSupport AS LOGICAL                NO-UNDO.
DEFINE VARIABLE has2008Support AS LOGICAL               NO-UNDO.
DEFINE VARIABLE hasCompColSupport AS LOGICAL            NO-UNDO.
DEFINE VARIABLE l             AS LOGICAL                NO-UNDO.
DEFINE VARIABLE trgr          AS LOGICAL                NO-UNDO.
DEFINE VARIABLE cmptdcol      AS LOGICAL                NO-UNDO.
DEFINE VARIABLE wdth          AS LOGICAL                NO-UNDO.
DEFINE VARIABLE ablfmt        AS LOGICAL                NO-UNDO.

batch_mode = SESSION:BATCH-MODE.

output_file= "deltsql.log".
OUTPUT STREAM logfile TO VALUE(output_file) NO-ECHO NO-MAP UNBUFFERED.
logfile_open = true. 

FORM
  " "   SKIP 
    df-file {&STDPH_FILL} FORMAT "x({&PATH_WIDG})"  VIEW-AS FILL-IN SIZE 40 BY 1
         LABEL "Delta DF File" colon  15
  btn_File SKIP SKIP({&VM_WIDG})
  osh_dbname   FORMAT "x(256)"  view-as fill-in size 32 by 1 
    LABEL "Schema Holder Database" colon 35 SKIP({&VM_WID}) 
  mss_conparms FORMAT "x(256)" view-as fill-in size 32 by 1 
    LABEL "Connect Parameters for Schema" colon 35 SKIP({&VM_WID})
  mss_dbname   FORMAT "x(32)"  view-as fill-in size 32 by 1 
    LABEL "Logical Name for MSS Database" colon 35 SKIP({&VM_WID})   
  mss_username    FORMAT "x(32)"  VIEW-AS FILL-IN SIZE 32 BY 1
    LABEL "MSS Object Owner Name" COLON 35 SKIP({&VM_WID})    
  long-length LABEL " Maximum Varchar Length"  COLON 35 SKIP({&VM_WIDG})
  SPACE(3) pcompatible view-as toggle-box LABEL "Create RECID Field"  
  SPACE(10) shadowcol VIEW-AS TOGGLE-BOX LABEL "Create Shadow Columns" SKIP({&VM_WID})
  SPACE (3) dflt VIEW-AS TOGGLE-BOX LABEL "Include Default" 
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN SPACE(13) &ELSE SPACE (14) &ENDIF
  create_df view-as toggle-box LABEL "Create Schema Holder Delta DF" SKIP({&VM_WID})
  SPACE(3) unicodeTypes view-as toggle-box LABEL "Use Unicode Types " 
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN SPACE(10) &ELSE SPACE (9) &ENDIF
  lUniExpand VIEW-AS TOGGLE-BOX LABEL "Expand Width (utf-8)" SKIP({&VM_WID})
  SPACE (3) mapMSSDatetime VIEW-AS TOGGLE-BOX LABEL "Map to MSS 'Datetime' Type"
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN SPACE(2) &ELSE SPACE (1) &ENDIF
  newseq   view-as toggle-box label "Use Revised Sequence Generator"
  SKIP({&VM_WID}) SPACE(2) cFormat VIEW-AS TEXT NO-LABEL  
  iFmtOption VIEW-AS RADIO-SET RADIO-BUTTONS "Width", 1,
                                             "ABL Format", 2
                                 HORIZONTAL NO-LABEL 
  lFormat VIEW-AS TOGGLE-BOX LABEL "Expand x(8) to 30" AT 54 SKIP({&VM_WID})
  SPACE(2) cRecid VIEW-AS TEXT NO-LABEL  
  iRecidOption VIEW-AS RADIO-SET RADIO-BUTTONS "Trigger", 1,
                                             "Computed Column", 2
                                 HORIZONTAL NO-LABEL SKIP({&VM_WID})

	     {prodict/user/userbtns.i}
  WITH FRAME read-df ROW 2 CENTERED SIDE-labels 
    DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
    &IF "{&WINDOW-SYSTEM}" <> "TTY"
  &THEN VIEW-AS DIALOG-BOX &ENDIF
  TITLE "Delta df to MS SQL Server Conversion".

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
  
  IF mss_username:SCREEN-VALUE IN FRAME read-df = "" OR 
              mss_username:SCREEN-VALUE IN FRAME read-df = ? THEN DO:
    MESSAGE "MSS Object Owner Name is required."  VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO mss_username IN FRAME read-df.
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
    ASSIGN conparms = mss_conparms:SCREEN-VALUE IN FRAME read-df +  
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
  l = no.
  IF mss_dbname:screen-value IN FRAME read-df = ? OR 
     mss_dbname:screen-value IN FRAME read-df = "" THEN DO:

     MESSAGE "Logical database cannot be left blank.  Default will be restored." 
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
     ASSIGN mss_dbname:SCREEN-VALUE = dflt_dbname. 
     RETURN NO-APPLY.
  END.
  FIND FIRST DICTDB._Db WHERE _Db._Db-name = mss_dbname:screen-value NO-ERROR.
  IF AVAILABLE(_Db) THEN DO:
     APPLY "ENTRY" to mss_dbname IN FRAME read-df.
     l = yes.
  END.
  FIND FIRST DICTDB._File where DICTDB._File._Db-recid = RECID(DICTDB._Db) NO-LOCK NO-ERROR. 
  IF NOT AVAILABLE DICTDB._File THEN DO:
     MESSAGE "Logical database cannot is empty.  Do you want to continue?" 
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
     ASSIGN mss_dbname:SCREEN-VALUE = dflt_dbname. 
     RETURN NO-APPLY.
  END.
  IF l THEN DO:
     ASSIGN mss_dbname = DICTDB._Db._Db-name
            shadowcol = (IF _Db-misc1[1] = 0 THEN TRUE ELSE FALSE)
            hasUniSupport = (DICTDB._Db._Db-xl-name = "utf-8")
            has2008Support = NO.

     /* To support computed columns, check for MSS 2005 or higher */
     IF INTEGER(SUBSTRING(ENTRY(NUM-ENTRIES(DICTDB._Db._Db-misc2[5], " ":U),_Db._Db-misc2[5], " ":U),1,2)) >= 9 THEN 
         hasCompColSupport = YES.

     /* if SQL 2008 and above and native Driver 10, let user select 2008 types */
     IF INTEGER(SUBSTRING(ENTRY(NUM-ENTRIES(DICTDB._Db._Db-misc2[5], " ":U),_Db._Db-misc2[5], " ":U),1,2)) >= 10 THEN DO:
       IF (DICTDB._Db._db-misc2[1] BEGINS "SQLNCLI") AND INTEGER(ENTRY(1,DICTDB._Db._db-misc2[2],".")) >= 10 THEN
            has2008Support = YES.
     END.
  END. 
  ELSE DO: 
     MESSAGE "Logical database " mss_dbname:screen-value " does not exist in schema holder " osh_dbname VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
END.

/*----- HELP in MSS Incremental Utility FRAME read-df -----*/
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

ON LEAVE OF long-length IN FRAME read-df DO:
  IF (unicodeTypes:SCREEN-VALUE = "no") AND INTEGER(long-length:SCREEN-VALUE) > 8000 THEN DO:  
    MESSAGE "The maximum length for a varchar is 8000" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  ELSE IF unicodeTypes:SCREEN-VALUE = "yes" AND INTEGER(long-length:SCREEN-VALUE) > 4000 THEN DO:  
    MESSAGE "The maximum length for a nvarchar is 4000" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.

END.

ON VALUE-CHANGED OF pcompatible IN FRAME read-df DO:
  IF SELF:SCREEN-VALUE = "no" THEN
     ASSIGN iRecidOption:SCREEN-VALUE = "1"
            iRecidOption:SENSITIVE = FALSE.
  ELSE
     ASSIGN iRecidOption:SCREEN-VALUE = "1"
            iRecidOption:SENSITIVE = TRUE.
END. 

ON VALUE-CHANGED OF unicodeTypes IN FRAME read-df DO:
 IF SELF:screen-value = "no" THEN
     ASSIGN long-length:SCREEN-VALUE = "8000"
            lUniExpand:SCREEN-VALUE = "no"
            lUniExpand:SENSITIVE = NO.
 ELSE
     ASSIGN long-length:SCREEN-VALUE = "4000"
            lUniExpand:SENSITIVE = YES
            s_res = lUniExpand:MOVE-AFTER-TAB-ITEM(unicodeTypes:HANDLE).
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
             mss_conparms = "<current working database>".
    /* If no select_dbname, select the last logical DB of schema holder with type = MSS */
    ELSE IF DICTDB._Db._Db-type = "MSS" THEN DO:
     IF select_dbname = "" OR select_dbname = DICTDB._Db._Db-name THEN DO:
      ASSIGN mss_dbname = DICTDB._Db._Db-name
             shadowcol = (IF _Db-misc1[1] = 0 THEN TRUE ELSE FALSE)
             hasUniSupport = (DICTDB._Db._Db-xl-name = "utf-8")
             has2008Support = NO.

      /* To support computed columns, check for MSS 2005 or higher */
      IF INTEGER(SUBSTRING(ENTRY(NUM-ENTRIES(DICTDB._Db._Db-misc2[5], " ":U),_Db._Db-misc2[5], " ":U),1,2)) >= 9 THEN 
          hasCompColSupport = YES.

      /* if SQL 2008 and above and native Driver 10, let user select 2008 types */
      IF INTEGER(SUBSTRING(ENTRY(NUM-ENTRIES(DICTDB._Db._Db-misc2[5], " ":U),_Db._Db-misc2[5], " ":U),1,2)) >= 10 THEN DO:
         IF (DICTDB._Db._db-misc2[1] BEGINS "SQLNCLI") AND INTEGER(ENTRY(1,DICTDB._Db._db-misc2[2],".")) >= 10 THEN
             has2008Support = YES.
      END.
    END.
    ASSIGN dflt_dbname = mss_dbname.
   END.
  END.
END.

ASSIGN pcompatible = TRUE
       long-length = 8000
       iRecidOption = 1.       

DISPLAY cFormat lFormat mapMSSDatetime cRecid WITH FRAME read-df.

UPDATE df-file 
       btn_file
       osh_dbname
       mss_conparms
       mss_dbname
       mss_username
       long-length
       pcompatible
       shadowcol WHEN shadowcol = TRUE
       dflt
       create_df
       unicodeTypes WHEN hasUniSupport 
       lUniExpand WHEN unicodeTypes
       mapMSSDatetime WHEN has2008Support
       newseq
       iFmtOption
       lFormat WHEN iFmtOption = 2
       iRecidOption WHEN hasCompColSupport
       btn_OK btn_Cancel
       &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
            btn_Help
       &ENDIF
  WITH FRAME read-df.
       
IF unicodeTypes:SCREEN-VALUE ="yes" THEN
   ASSIGN unicodeTypes = YES.
IF lUniExpand:SCREEN-VALUE ="yes" THEN
   ASSIGN lUniExpand = YES.

IF (iRecidOption= 1) then
  ASSIGN trgr = TRUE
        cmptdcol = FALSE.
ELSE 
  ASSIGN cmptdcol = TRUE
	trgr = FALSE.

IF (iFmtOption= 1) then
  ASSIGN wdth = TRUE
      ablfmt = FALSE.
ELSE
  ASSIGN wdth = FALSE
        ablfmt = TRUE.

   PUT STREAM logfile UNFORMATTED
       " " skip
       "Delta df to MS SQL Server Conversion Parameters" skip(2)
       "Delta DF File:                          " df-file skip
       "Schema Holder Database:                 " osh_dbname skip
       "Connect Parameters fo Schema:           " mss_conparms skip
       "Logical Name for MSS Database:          " mss_dbname SKIP
       "MSS Object Owner Name:                  " mss_username SKIP
       "Maximum Varchar Length:                 " long-length skip
       "Create RECID Field:                     " pcompatible SKIP
       "Create Shadow Columns:                  " shadowcol SKIP
       "Include Default:                        " dflt SKIP
       "Create Schema Holder Delta DF:          " create_df SKIP
       "Use Unicode Types:                      " unicodeTypes SKIP
       "Expand Width (utf-8):                   " lUniExpand SKIP
       "Map to MSS 'Datetime' Type:             " mapMSSDatetime SKIP
       "Use Revised Sequence Generator:         " newseq SKIP
       "For Field width use                     "  skip
       "                         Width:         " wdth SKIP
       "                    ABL Format:         " ablfmt SKIP
       "             Expand x(8) to 30:         " lFormat SKIP 
       "For Create RECID use                    " SKIP
       "                       Trigger:         " trgr SKIP
       "               Computed Column:         " cmptdcol SKIP(3).

ASSIGN user_env[1]  = df-file
       user_env[3]  = ""
       user_env[4]  = "n"
       user_env[5]  = "go"
       user_env[6]  = "y"
       user_env[7]  = (IF dflt THEN "y" ELSE "n")
       user_env[8]  = "y"
       user_env[9]  = "ALL"
       user_env[10] = string(long-length)
       user_env[11] = (IF unicodeTypes THEN "NVARCHAR" ELSE "VARCHAR" ) 
       user_env[12] = "datetime"
       user_env[13] = "tinyint"
       user_env[14] = "integer"
       user_env[15] = "decimal(18,5)"
       user_env[16] = "decimal"
       user_env[17] = "integer"
       user_env[18] = (IF unicodeTypes THEN "NVARCHAR(MAX)" ELSE "TEXT")
       user_env[19] = "tinyint"
       user_env[20] = "##"  
       user_env[21] = (IF shadowcol THEN "y" ELSE "n")
       user_env[22] = "MSS"
       user_env[23] = "30"
       user_env[24] = "15"
       /* first y is for sequence support.
          second entry is for new sequence generator */
       user_env[25] = "y" + (IF newseq THEN ",y" ELSE ",n")
       user_env[28] = "128"
       user_env[29] = "128"            
       user_env[30] = "y"
       user_env[31] = "-- ** "
       user_env[32] = "MSSQLSRV7".
    
IF lUniExpand THEN 
   ASSIGN user_env[35] = "y".
ELSE
   ASSIGN user_env[35] = "n".

IF pcompatible THEN 
   ASSIGN user_env[27] = "y" + "," + STRING(iRecidOption).
ELSE
   ASSIGN user_env[27] = "no".

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

RUN prodict/mss/_gendsql.p.
 
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
