/*********************************************************************
* Copyright (C) 2006-2013 by Progress Software Corporation.          *
* All rights reserved.Prior versions of this work may contain        *
* portions contributed by participants of Possenet.                  *
*                                                                    *
*********************************************************************/

/* Procedure deltasql.p - sdash
   Created 03/13/13 Initial procedure for the MSS Incremental Df Utility
*/

{ prodict/user/uservar.i new }
{ prodict/mss/mssvar.i new }
{ prodict/misc/filesbtn.i new }

DEFINE NEW SHARED VARIABLE select_dbname  AS CHARACTER    NO-UNDO.
DEFINE NEW SHARED VARIABLE dflt_dbname    AS CHARACTER    NO-UNDO.
DEFINE NEW SHARED VARIABLE envshadowcol   AS CHARACTER    NO-UNDO.
DEFINE NEW SHARED VARIABLE scol      AS LOGICAL           NO-UNDO.
DEFINE VARIABLE old_oshdbname   AS CHARACTER           NO-UNDO.
DEFINE VARIABLE old_connparms   AS CHARACTER           NO-UNDO.
DEFINE VARIABLE ientry           AS INTEGER             NO-UNDO.
DEFINE VARIABLE cEntry           AS CHARACTER           NO-UNDO.
DEFINE VARIABLE connParam        AS CHARACTER           NO-UNDO.
DEFINE VARIABLE found-ldb        AS LOGICAL             NO-UNDO.
DEFINE VARIABLE l                AS LOGICAL             NO-UNDO.

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
DEFINE VARIABLE err-rtn       AS LOGICAL INITIAL FALSE    NO-UNDO.
DEFINE VARIABLE crtdltadf     AS CHARACTER              NO-UNDO.
DEFINE VARIABLE mssdttime     AS CHARACTER              NO-UNDO.
DEFINE VARIABLE seqgen        AS CHARACTER              NO-UNDO.
DEFINE VARIABLE sqlwdth       AS CHARACTER              NO-UNDO.
DEFINE VARIABLE expnd8        AS CHARACTER              NO-UNDO.
DEFINE VARIABLE crtdflt       AS CHARACTER              NO-UNDO.
DEFINE VARIABLE cmptble       AS CHARACTER              NO-UNDO.
DEFINE VARIABLE ucodetypes    AS CHARACTER              NO-UNDO.
DEFINE VARIABLE ucodeexpnd    AS CHARACTER              NO-UNDO.
DEFINE VARIABLE cmptble1      AS LOGICAL                NO-UNDO.
DEFINE VARIABLE cmptble2      AS LOGICAL                NO-UNDO.
DEFINE VARIABLE wdth          AS LOGICAL                NO-UNDO.
DEFINE VARIABLE ablfmt        AS LOGICAL                NO-UNDO.

batch_mode = SESSION:BATCH-MODE.
SESSION:SUPPRESS-WARNINGS = TRUE.

output_file= "deltasqlutil.log".
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
   ASSIGN osh_dbname = osh_dbname:SCREEN-VALUE IN FRAME read-df
          mss_dbname = mss_dbname:SCREEN-VALUE IN FRAME read-df.
      CONNECT VALUE(osh_dbname) VALUE(mss_conparms) NO-ERROR.
      RUN prodict/mss/deltaconnect.p.
      IF NOT CONNECTED(LDBNAME(osh_dbname:SCREEN-VALUE IN FRAME read-df)) THEN DO:
        MESSAGE osh_dbname:SCREEN-VALUE IN FRAME read-df
         " can not be connected using entered connect parameters."
        VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" to osh_dbname IN FRAME read-df.
      RETURN NO-APPLY.
     END.
  END.

 IF mss_dbname <> ? THEN DO:
   ASSIGN mss_dbname:SCREEN-VALUE = mss_dbname.
   APPLY "ENTRY" TO mss_dbname IN FRAME read-df.
 END.

  IF mss_dbname:screen-value IN FRAME read-df = ? OR 
     mss_dbname:screen-value IN FRAME read-df = "" THEN DO:
     ASSIGN mss_dbname:SCREEN-VALUE = mss_dbname.
     APPLY "ENTRY" TO mss_dbname IN FRAME read-df.
  END.

END.  /*End of ON GO trigger */

ON CHOOSE OF btn_File in frame read-df DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT df-file:handle in frame read-df /*Fillin*/,
        INPUT "Find Input File"  /*Title*/,
        INPUT "*.df"                 /*Filter*/,
        INPUT yes                /*Must exist*/).
END.

     IF shadowcol = TRUE THEN DO:
        ASSIGN shadowcol:CHECKED   = TRUE
               shadowcol:SENSITIVE = TRUE.
         RETURN NO-APPLY.
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
  IF (unicodeTypes:SCREEN-VALUE = "no") AND 
        INTEGER(long-length:SCREEN-VALUE) > 8000 THEN DO:  
    MESSAGE "The maximum length for a varchar is 8000" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  ELSE IF unicodeTypes:SCREEN-VALUE = "yes" AND 
       INTEGER(long-length:SCREEN-VALUE) > 4000 THEN DO:  
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

ON WINDOW-CLOSE of frame read-df
   apply "END-ERROR" to frame read-df.

ON LEAVE OF df-file in frame read-df
   df-file:screen-value in frame read-df = 
        TRIM(df-file:screen-value in frame read-df).

/*----- HELP in MSS Incremental Utility FRAME read-df -----*/
IF NOT batch_mode THEN DO:
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
   on HELP of frame read-df or CHOOSE of btn_Help in frame read-df
      RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                             INPUT {&Incremental_Schema_Migration_Dlg_Box},
                             INPUT ?).
  &ENDIF
END.

IF NOT batch_mode THEN DO:
   {adecomm/okrun.i  
       &FRAME  = "FRAME read-df" 
       &BOX    = "rect_Btns"
       &OK     = "btn_OK" 
       {&CAN_BTN}
   }
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
   btn_Help:visible IN FRAME read-df = yes.
   &ENDIF
END.

/*==========================Mainline code=============================*/

ASSIGN iRecidOption = 0.

IF OS-GETENV("DELTADFNAME") <> ? THEN
  df-file   = OS-GETENV("DELTADFNAME").

IF OS-GETENV("SHDBNAME") <> ? THEN
  osh_dbname   = OS-GETENV("SHDBNAME").

 IF OS-GETENV("MSSCONPARMS") <> ? THEN
  mss_conparms   = OS-GETENV("MSSCONPARMS").

 IF OS-GETENV("MSSDBNAME") <> ? THEN
  mss_dbname   = OS-GETENV("MSSDBNAME").

IF OS-GETENV("MSSUSERNAME") <> ? THEN
  mss_username  = OS-GETENV("MSSUSERNAME").

IF OS-GETENV("CRTDELTADF") <> ? THEN DO:
crtdltadf = OS-GETENV("CRTDELTADF").
  IF crtdltadf BEGINS "Y" THEN 
    create_df = TRUE.
  ELSE 
   create_df = FALSE.
END.
ELSE
  create_df = TRUE.

IF OS-GETENV("MSSREVSEQGEN") <> ? THEN DO:
seqgen = OS-GETENV("MSSREVSEQGEN").
  IF (seqgen <> ?) AND (seqgen BEGINS "N") THEN
   newseq = FALSE.
  ELSE
   newseq = TRUE.
END.
ELSE
   newseq = TRUE.

IF OS-GETENV("SQLWIDTH") <> ? THEN DO:
  sqlwdth = OS-GETENV("SQLWIDTH").
  IF ((sqlwdth BEGINS "Y") OR (sqlwdth = "1")) THEN 
    iFmtOption = 1.
  ELSE 
    iFmtOption = 2.
END. 
ELSE 
   iFmtOption = 2.

IF OS-GETENV("EXPANDX8") <> ? THEN DO:
  ASSIGN expnd8  = OS-GETENV("EXPANDX8").
  IF expnd8 BEGINS "Y" THEN 
    ASSIGN lExpand = FALSE
           lFormat = TRUE.
  ELSE 
    ASSIGN lExpand = TRUE
           lFormat = FALSE.
END. 
ELSE
   ASSIGN lExpand = FALSE
         lFormat = TRUE.

IF OS-GETENV("CRTDEFAULT") <> ? THEN DO:
  ASSIGN crtdflt = OS-GETENV("CRTDEFAULT").
  IF crtdflt BEGINS "Y" THEN 
    ASSIGN dflt = TRUE.
    ELSE
     dflt = FALSE.
    END. 
  ELSE 
  ASSIGN dflt = FALSE.

IF OS-GETENV("VARLENGTH") <> ? THEN
  long-length = integer(OS-GETENV("VARLENGTH")).
ELSE
  long-length = 8000.

IF OS-GETENV("UNICODETYPES")  <> ? THEN DO:
  ucodetypes = OS-GETENV("UNICODETYPES").
  IF ucodetypes BEGINS "Y" THEN DO:
      ASSIGN unicodeTypes = TRUE
             long-length = 4000.
        ucodeexpnd = OS-GETENV("UNICODE_EXPAND").
        IF ucodeexpnd BEGINS "Y" THEN
        lUniExpand = YES.
  END.
  ELSE IF ucodetypes BEGINS "N" THEN
       ASSIGN long-length = 8000
              lUniExpand = FALSE
	       unicodeTypes = NO.
END.
ELSE 
     ASSIGN long-length = 8000
            lUniExpand = FALSE
	    unicodeTypes = NO.

IF OS-GETENV("COMPATIBLE") <> ?  THEN DO:
   cmptble  = OS-GETENV("COMPATIBLE").
     IF ((cmptble = "1") OR (cmptble BEGINS "Y")) THEN
       ASSIGN pcompatible=TRUE
              iRecidOption = 1. 
     ELSE IF (cmptble = "2")  THEN
          ASSIGN pcompatible=TRUE
          iRecidOption = 2.
     ELSE IF (cmptble BEGINS "N") THEN DO:
       ASSIGN  pcompatible=FALSE
               pcompatible:SCREEN-VALUE = "NO"
               iRecidOption:SCREEN-VALUE = "1". 
     END.
 END.
 ELSE
    ASSIGN
     pcompatible=TRUE
     iRecidOption = 1.

IF ((unicodeTypes = TRUE ) AND (INTEGER(long-length) > 4000)) THEN DO:  
    PUT STREAM logfile UNFORMATTED  "The maximum length for a nvarchar is 4000" skip(1).
    RETURN NO-APPLY.
END.
ELSE IF (unicodeTypes = FALSE ) AND (INTEGER(long-length) > 8000) THEN DO:  
    PUT STREAM logfile UNFORMATTED  "The maximum length for a varchar is 8000" skip(1).
    RETURN NO-APPLY.
 END.

IF batch_mode THEN DO:
 IF df-file  = ? OR df-file  = "" THEN DO:
  PUT STREAM logfile UNFORMATTED "Delta DF File is required." skip(1).
   RETURN NO-APPLY.
   END.

 IF SEARCH(df-file) = ? THEN DO:
  PUT STREAM logfile UNFORMATTED "Can not find a file of this name. Try again." skip(1).
   RETURN NO-APPLY.
     END.

 IF (osh_dbname = ?)  OR (osh_dbname  ="") THEN DO:
  PUT STREAM logfile UNFORMATTED "Schema Holder name is required." skip(1).
  RETURN NO-APPLY.
  END.

 IF (mss_conparms = ?)  OR (mss_conparms  ="") THEN DO:
 PUT STREAM logfile UNFORMATTED " Can not be connected using entered connect parameters." skip(1).
  RETURN NO-APPLY.
 END.

 IF mss_username  = ? OR mss_username  = "" THEN DO: 
  PUT STREAM logfile UNFORMATTED "MSS Object Owner Name is required." skip(1).
  RETURN NO-APPLY.
  END.
END.

IF batch_mode THEN DO:
 IF NOT CONNECTED(osh_dbname) THEN
  CONNECT VALUE (osh_dbname) VALUE (mss_conparms) NO-ERROR.
  CREATE ALIAS "DICTDB" FOR DATABASE VALUE(osh_dbname) NO-ERROR.
  RUN prodict/mss/deltaconnect.p.
END.

IF OS-GETENV("SHADOWCOL") <> ? THEN 
  ASSIGN envshadowcol  = OS-GETENV("SHADOWCOL").

IF OS-GETENV("MAPMSSDATETIME") <> ? THEN DO:
mssdttime = OS-GETENV("MAPMSSDATETIME").
 IF (mssdttime <> ?) AND (mssdttime BEGINS "N") THEN
   mapMSSDatetime = FALSE.
END.
ELSE
   mapMSSDatetime = TRUE.

 IF NOT batch_mode THEN DO:
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
       cFormat
       cRecid
       unicodeTypes WHEN hasUniSupport
       lUniExpand WHEN unicodeTypes
       mapMSSDatetime WHEN has2008Support
       newseq
       iFmtOption
       lFormat WHEN iFmtOption = 2
       iRecidOption WHEN (pcompatible AND hasCompColSupport)
       btn_OK btn_Cancel
       &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
            btn_Help
       &ENDIF
     WITH FRAME read-df.
END.

IF unicodeTypes:SCREEN-VALUE ="yes" THEN
   ASSIGN unicodeTypes = YES.
IF lUniExpand:SCREEN-VALUE ="yes" THEN
   ASSIGN lUniExpand = YES. 

IF (iRecidOption= 1) then
  ASSIGN cmptble1 = TRUE
        cmptble2 = FALSE.
ELSE 
  ASSIGN cmptble2 = TRUE
	cmptble1 = FALSE.

IF (iFmtOption= 1) then
  ASSIGN wdth = TRUE
      ablfmt = FALSE.
ELSE
  ASSIGN wdth = FALSE
        ablfmt = TRUE.

   PUT STREAM logfile UNFORMATTED
       " " skip
       "Delta df to MS SQL Server Conversion" skip(2)
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
       "Expand Width (utf-8):                   " lExpand SKIP
       "Map to MSS 'Datetime' Type:             " mapMSSDatetime SKIP
       "Use Revised Sequence Generator:         " newseq SKIP
       "For Field width use                     "  skip
       "                         Width:         " wdth SKIP
       "                    ABL Format:         " ablfmt SKIP
       "             Expand x(8) to 30:         " lFormat SKIP 
       "For Create RECID use                    " SKIP
       "                       Trigger:         " cmptble1 SKIP
       "               Computed Column:         " cmptble2 SKIP(3).

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