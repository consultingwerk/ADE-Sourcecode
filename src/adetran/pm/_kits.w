&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          xlatedb          PROGRESS
*/
&Scoped-define WINDOW-NAME WINDOW-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS WINDOW-1 
/*********************************************************************
* Copyright (C) 2000,2013 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/pm/_kits.w
Author:       R. Ryan/G. Seidl
Created:      1/95 
Updated:      9/95
                11/96 SLK OPSYS MS-DOS
                Long filename
Purpose:      Translation Manager Kit Tab folder
Background:   This is a persistent procedure that is run from
              pm/_pmmain.p *only* after a database is connected.
              Once connected, this procedure has the browser
              associated with creating and maintaining kits.                                              
Includes:     none 
Called by:    pm/_pmmain.p
Calls to:     SetSensitivity in _hMain
              pm/_getcnt.p    (for setting button sensitivity)
              pm/_k-alias.p   (resetting the kit connectivity/alias)
              pm/_kschema.p   (determining whether the connected db is a kit)
              pm/_consol.w    (consolidates kits into the project)
              pm/_newkit.w    (builds new kit db)
              pm/_instzip.w   (installs zip file - GFS)
              pm/_crzip.w     (creates zip file - GFS)
              common/zipmgr.w (zip functions - GFS)
              common/_dbfiles.w (database files- SLK)
*/


{ adetran/pm/tranhelp.i } /* definitions for help context strings */  

define shared variable _hMain      as handle  no-undo.  
define shared variable _hTrans     as handle  no-undo.
define shared variable _MainWindow as handle  no-undo. 
define shared variable _Kit        as char    no-undo. 
define shared variable KitDB       as char    no-undo.   
define shared variable _ZipPresent as logical no-undo.
define shared variable _ZipName    as char    no-undo.
define shared variable _ZipCommand as char    no-undo.   
DEFINE SHARED VARIABLE _BKUPExt    AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE ProjectDB   AS CHARACTER NO-UNDO. 
{adetran/pm/vsubset.i &NEW=" " &SHARED="SHARED"}

define variable tInsert     as logical no-undo.
define variable ThisMessage as char    no-undo.
define variable ErrorStatus as logical no-undo.
define variable i           as integer no-undo. 
define variable Result      as logical no-undo.
define variable OKPressed   as logical no-undo.

DEFINE VARIABLE bkupStatus  AS LOGICAL                NO-UNDO.
DEFINE VARIABLE restStatus  AS LOGICAL                NO-UNDO.
DEFINE VARIABLE cFileName   AS CHARACTER              NO-UNDO.

&IF LOOKUP("{&OPSYS}","MSDOS,WIN32":U) > 0 &THEN
    &SCOPED-DEFINE SLASH ~~~\
&ELSE
    &SCOPED-DEFINE SLASH /
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME KitsFrame
&Scoped-define BROWSE-NAME Glossaries

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES xlatedb.XL_Kit xlatedb.XL_Project

/* Definitions for BROWSE Glossaries                                    */
&Scoped-define FIELDS-IN-QUERY-Glossaries xlatedb.XL_Kit.KitName ~
xlatedb.XL_Kit.LanguageName xlatedb.XL_Kit.GlossaryName ~
xlatedb.XL_Kit.CreateDate xlatedb.XL_Kit.KitZipped ~
xlatedb.XL_Kit.KitConsolidated xlatedb.XL_Kit.TranslationCount ~
xlatedb.XL_Kit.TranslationCount / xlatedb.XL_Project.NumberOfPhrases * 100 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Glossaries 
&Scoped-define FIELD-PAIRS-IN-QUERY-Glossaries
&Scoped-define OPEN-QUERY-Glossaries OPEN QUERY Glossaries FOR EACH xlatedb.XL_Kit NO-LOCK, ~
      EACH xlatedb.XL_Project WHERE TRUE /* Join to xlatedb.XL_Kit incomplete */ NO-LOCK.
&Scoped-define TABLES-IN-QUERY-Glossaries xlatedb.XL_Kit xlatedb.XL_Project
&Scoped-define FIRST-TABLE-IN-QUERY-Glossaries xlatedb.XL_Kit


/* Definitions for FRAME KitsFrame                                      */
&Scoped-define OPEN-BROWSERS-IN-QUERY-KitsFrame ~
    ~{&OPEN-QUERY-Glossaries}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 BtnAdd Glossaries BtnRemove ~
BtnConsolidate btnCreateZip btnInstallZip 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR WINDOW-1 AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnAdd 
     LABEL "&Add..." 
     SIZE-PIXELS 133 BY 23.

DEFINE BUTTON BtnConsolidate 
     LABEL "&Consolidate..." 
     SIZE-PIXELS 133 BY 23.

DEFINE BUTTON btnCreateZip 
     LABEL "Create &Zip file" 
     SIZE-PIXELS 133 BY 23.

DEFINE BUTTON btnInstallZip 
     LABEL "&Install Zip file" 
     SIZE-PIXELS 133 BY 23.

DEFINE BUTTON BtnRemove 
     LABEL "&Remove" 
     SIZE-PIXELS 133 BY 23.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE-PIXELS 450 BY 275.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Glossaries FOR 
      xlatedb.XL_Kit, 
      xlatedb.XL_Project SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE Glossaries
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS Glossaries WINDOW-1 _STRUCTURED
  QUERY Glossaries NO-LOCK DISPLAY
      xlatedb.XL_Kit.KitName FORMAT "x(20)"
      xlatedb.XL_Kit.LanguageName COLUMN-LABEL "Language!Name" FORMAT "X(20)"
      xlatedb.XL_Kit.GlossaryName FORMAT "x(20)"
      xlatedb.XL_Kit.CreateDate
      xlatedb.XL_Kit.KitZipped COLUMN-LABEL "Zip-!ped?"
      xlatedb.XL_Kit.KitConsolidated
      xlatedb.XL_Kit.TranslationCount COLUMN-LABEL "Phrases!Translated" FORMAT ">,>>>,>>9"
      xlatedb.XL_Kit.TranslationCount / xlatedb.XL_Project.NumberOfPhrases * 100 COLUMN-LABEL "Percent!Translated" FORMAT ">>9.9%"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 61 BY 9
          &ELSE SIZE-PIXELS 428 BY 246 &ENDIF
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME KitsFrame
     BtnAdd AT Y 9 X 469
     Glossaries AT Y 23 X 27
     BtnRemove AT Y 36 X 469
     BtnConsolidate AT Y 63 X 469
     btnCreateZip AT Y 108 X 469
     btnInstallZip AT Y 135 X 469
     RECT-1 AT Y 8 X 12
    WITH 1 DOWN NO-BOX OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT X 14 Y 52
         SIZE-PIXELS 610 BY 299
         FONT 4.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* SUPPRESS Window definition (used by the UIB) 
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW WINDOW-1 ASSIGN
         HIDDEN             = YES
         TITLE              = "Window 1"
         COLUMN             = 26
         ROW                = 12.42
         HEIGHT             = 13.77
         WIDTH              = 90
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 95.72
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 95.72
         RESIZE             = yes
         SCROLL-BARS        = yes
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
                                                                        */
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME
ASSIGN WINDOW-1 = CURRENT-WINDOW.



/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW WINDOW-1
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME KitsFrame
  VISIBLE,,RUN-PERSISTENT                                               */
/* BROWSE-TAB Glossaries BtnAdd KitsFrame */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE Glossaries
/* Query rebuild information for BROWSE Glossaries
     _TblList          = "xlatedb.XL_Kit,xlatedb.XL_Project WHERE xlatedb.XL_Kit ... ..."
     _Options          = "NO-LOCK"
     _FldNameList[1]   > xlatedb.XL_Kit.KitName
"XL_Kit.KitName" ? "x(20)" "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   > xlatedb.XL_Kit.LanguageName
"XL_Kit.LanguageName" "Language!Name" "X(20)" "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   > xlatedb.XL_Kit.GlossaryName
"XL_Kit.GlossaryName" ? "x(20)" "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   = xlatedb.XL_Kit.CreateDate
     _FldNameList[5]   > xlatedb.XL_Kit.KitZipped
"XL_Kit.KitZipped" "Zip-!ped?" ? "logical" ? ? ? ? ? ? no ?
     _FldNameList[6]   = xlatedb.XL_Kit.KitConsolidated
     _FldNameList[7]   > xlatedb.XL_Kit.TranslationCount
"XL_Kit.TranslationCount" "Phrases!Translated" ">,>>>,>>9" "" ? ? ? ? ? ? no ?
     _FldNameList[8]   > "_<CALC>"
"xlatedb.XL_Kit.TranslationCount / xlatedb.XL_Project.NumberOfPhrases * 100" "Percent!Translated" ">>9.9%" "Decimal" ? ? ? ? ? ? no ?
     _Query            is OPENED
*/  /* BROWSE Glossaries */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME KitsFrame
/* Query rebuild information for FRAME KitsFrame
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME KitsFrame */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME KitsFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL KitsFrame WINDOW-1
ON HELP OF FRAME KitsFrame
DO:
  run adecomm/_adehelp.p ("tran":u,"context":u,{&kits_tab_folder}, ?). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnAdd WINDOW-1
ON CHOOSE OF BtnAdd IN FRAME KitsFrame /* Add... */
DO:
  DEFINE VAR _KIT        AS CHARACTER              NO-UNDO.
  DEFINE VAR lError      AS LOGICAL                NO-UNDO.
  
  run adecomm/_setcurs.p ("wait":u).
  run adetran/pm/_newkit.w.

  IF RETURN-VALUE NE "" THEN DO:
    ASSIGN
       _KIT = RETURN-VALUE
       FILE-INFO:FILENAME = xlatedb.XL_Project.RootDirectory + "{&SLASH}" 
                      + ENTRY(1,xlatedb.XL_Kit.KitName,".") + ".db":U
       cFileName = IF FILE-INFO:FULL-PATHNAME <> ? THEN 
                      FILE-INFO:FULL-PATHNAME
                  ELSE
                    xlatedb.XL_Project.RootDirectory + "~\":U 
                    + xlatedb.XL_Kit.KitName
     KitDB = cFileName.
    RUN adetran/common/_dbmgmt.p 
      (INPUT "DELETE":U,
       INPUT cFileName,
       INPUT "kit":U,
       INPUT ?,
       INPUT ?,
       OUTPUT lError).
    RUN OpenQuery.
  END.  /* User bailed out*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnConsolidate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnConsolidate WINDOW-1
ON CHOOSE OF BtnConsolidate IN FRAME KitsFrame /* Consolidate... */
DO:                
  define var KitFile as char no-undo.
  define var InputLine as char no-undo.
  define var TestName as char no-undo.
  define var SchemaPresent as logical no-undo.
  
  run adecomm/_setcurs.p ("wait":u).  

  if Glossaries:num-selected-rows = 0 then do:
    ThisMessage = "You must select a kit first.".
    run adecomm/_s-alert.p (input-output ErrorStatus, "w*":u, "ok":u, ThisMessage).    
    return.
  end.

  FIND FIRST xlatedb.XL_Project NO-LOCK.
  file-info:filename = search(xlatedb.XL_Kit.KitName).
  KitFile = FILE-INFO:FULL-PATHNAME.
  IF kitFile = ? THEN
    ASSIGN KitFile = xlatedb.XL_Project.RootDirectory + "~\":U + xlatedb.XL_Kit.KitName.
  if KitFile = ? then do:    
    system-dialog get-file KitFile
         title     "Open Kit Database"
        filters   "Kit files (*.db)" "*.db":u,
                  "All files (*.*)"  "*.*":u
        must-exist
        use-filename
        update OKPressed. 
      

    if OKPressed or KitFile <> ? then do: 
      run adecomm/_setcurs.p ("wait":u).  
      ASSIGN KitDB = KitFile
             _Kit  = KitFile.
    END.                     
    ELSE RETURN.
  END.

  IF KitFIle = ? THEN RETURN.
  ASSIGN KitDB = KitFile
         _Kit  = KitFIle.
  run adetran/common/_k-alias.p (output ErrorStatus).  
  if ErrorStatus then do: 
    run adecomm/_setcurs.p ("").
    return.
  end.  

  /* Insure that this open database has the correct schema  */ 
  run adetran/common/_kschema.p (output SchemaPresent).  
  if not SchemaPresent then do:
    disconnect kit.
    delete alias kit. 
    ThisMessage = KitFile + "^This file is not a kit database.".
    run adecomm/_s-alert.p (input-output ErrorStatus, "w*":u, "ok":u, ThisMessage).    
    return.
  end.

  run adetran/pm/_consol.w (output OKPressed, output ErrorStatus).
  disconnect kit.
  delete alias kit. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnCreateZip
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnCreateZip WINDOW-1
ON CHOOSE OF btnCreateZip IN FRAME KitsFrame /* Create Zip file */
DO:
  DEFINE VARIABLE ZipFileName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE BkupFile    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ItemList    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ProjPath    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ZipStatus   AS LOGICAL   NO-UNDO.   
  DEFINE VARIABLE inp         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ZipComp     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE ZipComment  AS CHARACTER NO-UNDO.
            
  DEFINE BUFFER tXL_Kit FOR XL_Kit. 

  IF NOT AVAILABLE XL_Kit THEN DO:
    MESSAGE "Please select a kit to include in the zip file."
      VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  FIND FIRST xlatedb.XL_Project NO-LOCK.
  ASSIGN
     FILE-INFO:FILENAME = xlatedb.XL_Project.RootDirectory + "{&SLASH}" 
                         + ENTRY(1,xlatedb.XL_Kit.KitName,".") + ".db":U
     cFileName = IF FILE-INFO:FULL-PATHNAME <> ? THEN 
                    FILE-INFO:FULL-PATHNAME
                 ELSE 
                    xlatedb.XL_Project.RootDirectory + "~\":U 
                    + xlatedb.XL_Kit.KitName
     KitDB = cFileName.
  RUN adetran/common/_dbmgmt.p 
      (INPUT "BACKUP":U,
       INPUT cFileName,
       INPUT "kit":U,
       INPUT ?,
       INPUT ?,
       OUTPUT bkupStatus).

  IF bkupStatus THEN
      MESSAGE "Database was not backed up correctly." SKIP
              "Zip file was not created successfully."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.  
  ELSE
  DO:
  
     GET-KEY-VALUE SECTION "Translation Manager":U key "ZipCompFactor":U value inp.
     IF inp = ? OR inp = "" OR INT(inp) < 1 OR INT(inp) > 10 THEN
       ASSIGN ZipComp = 5.
     ELSE
       ASSIGN ZipComp = INT(inp).
       
     ASSIGN ZipComment = "TranMan2 Kit Zipfile. " +
                         "Created on " + STRING(TODAY) +
                         " at " + STRING(TIME,"HH:MM AM") +
                         " KitDB: " + REPLACE(_Kit,".db":U,"").
     RUN adetran/pm/_crzip.w (OUTPUT ZipFileName, OUTPUT BkupFile, OUTPUT ItemList, OUTPUT ProjPath).
     IF ZipFileName NE "" AND ItemList NE "" THEN 
     DO:
       RUN adetran/common/_zipmgr.w (INPUT         "ZIP",       /* Mode */
                                     INPUT         ZipFileName, /* ZipFileName */
                                     INPUT         ProjPath,    /* ZipDir */
									 INPUT         BkupFile,    /* BkupFile */
                                     INPUT         ItemList,    /* ItemList */
                                     INPUT         ZipComp,     /* ZCompFactor */
                                     INPUT         YES,         /* Recursive */
                                     INPUT-OUTPUT  ZipComment,  /* ZipComment */
                                     OUTPUT        ZipStatus).  /* ZipStatus */
       IF ZipStatus THEN 
       DO:
         MESSAGE "Zip file was created successfully." 
           VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
         IF AVAILABLE XL_Kit THEN 
         DO:
           DO FOR tXL_Kit:
             FIND tXL_Kit EXCLUSIVE-LOCK WHERE RECID(tXL_Kit) = RECID(XL_Kit).
             ASSIGN tXL_Kit.Kitzipped = yes.
           END. /* DO FOR tXL_Kit */
           RUN OpenQuery.
         END. /* AVAIL XL_Kit */
       END. /* ZipStatus */
       ELSE
         MESSAGE "Zip file was not created successfully."
           VIEW-AS ALERT-BOX ERROR BUTTONS OK.  
     END. /* ZipFileName NE "" AND ItemList NE "" */
  END. /* ResSTATUS = OK */
END.  /* ON CHOOSE OF btnCreateZip */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnInstallZip
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnInstallZip WINDOW-1
ON CHOOSE OF btnInstallZip IN FRAME KitsFrame /* Install Zip file */
DO:
  DEFINE VARIABLE ZipFileName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ZipDir      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ZipStatus   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE ZipComment  AS CHARACTER NO-UNDO.
  
  RUN adetran/pm/_instzip.w (OUTPUT ZipFileName, OUTPUT ZipDir).
  IF ZipFileName NE "" AND ZipDir NE "" THEN DO:
    RUN adetran/common/_zipmgr.w (INPUT "GETCOMMENT",      /* Mode */
                                  INPUT ZipFileName,       /* ZipFileName */
                                  INPUT "",                /* ZipDir */
								  INPUT "",                /* BkupFile */
                                  INPUT "",                /* ItemList */
								  INPUT 0,                 /* ZCompFactor */
								  INPUT YES,               /* Recursive */
                                  INPUT-OUTPUT ZipComment, /* ZipComment */
                                  OUTPUT ZipStatus).       /* ZipStatus */
    IF NOT ZipStatus THEN DO:
      MESSAGE "Error extracting zipfile comment. This zipfile may not have been created by TranMan." skip 
              "Please check to make sure that you've selected the correct zipfile." skip
              "Unzip operation aborted." 
        VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.    
    END.
    IF ZipComment = "" OR 
        ENTRY(2,ZipComment," ") NE "Return" THEN DO:
      MESSAGE "This zip file does not appear to be a kit returned by the Visual Translator." skip 
              "Please check to make sure that you've selected the correct zipfile." skip
              "Unzip operation aborted." 
        VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
    END.    
  
    RUN adetran/common/_zipmgr.w (INPUT "UNZIP",           /* Mode */
                                  INPUT ZipFileName,       /* ZipFileName */
                                  INPUT ZipDir,            /* ZipDir */
                                  INPUT "",                /* BkupFile */
                                  INPUT "",                /* ItemList */
								  INPUT 0,                 /* ZCompFactor */
								  INPUT YES,               /* Recursive */
                                  INPUT-OUTPUT ZipComment, /* ZipComment */
                                  OUTPUT ZipStatus).       /* ZipStatus */
    IF ZipStatus THEN 
    DO:
      FIND FIRST xlatedb.XL_Project NO-LOCK.
      ASSIGN
         FILE-INFO:FILE-NAME = xlatedb.XL_Project.RootDirectory + "{&SLASH}" 
                           + ENTRY(1,xlatedb.XL_Kit.KitName,".") + ".db":U
         cFileName = IF FILE-INFO:FULL-PATHNAME <> ? THEN 
                          FILE-INFO:FULL-PATHNAME
                    ELSE
                    xlatedb.XL_Project.RootDirectory + "~\":U 
                    + xlatedb.XL_Kit.KitName
     KitDB = cFileName.
      RUN adetran/common/_dbmgmt.p 
      (INPUT "RESTORE":U,
       INPUT cFileName,
       INPUT "kit":U,
       INPUT ?,
       INPUT ?,
       OUTPUT restStatus).
    IF NOT restStatus THEN
      MESSAGE "Zip file was unzipped successfully." 
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    ELSE
      MESSAGE "Zip file was not unzipped successfully."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.  
  END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnRemove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnRemove WINDOW-1
ON CHOOSE OF BtnRemove IN FRAME KitsFrame /* Remove */
DO:  
  define var Choice1   as logical no-undo init true.
  define var Choice2   as logical no-undo init false.
  define var logdbname as char    no-undo.
  
  ThisMessage = "Do you want to remove the kit " + 
                  REPLACE(_Kit,".db":U,"":U) + " from this project?":U.
  run adecomm/_s-alert.p (input-output Choice1, "q*":u, "yes-no":u, ThisMessage).    
  
  if Choice1 then
  DO: 
    ThisMessage = "Delete corresponding kit database?".
    run adecomm/_s-alert.p (input-output Choice2, "q*":u, "yes-no-cancel":u, ThisMessage).    
    if Choice2 = ? then return.  
    
    if Choice2 then
    DO:  
      ASSIGN logdbname = entry(1,xlatedb.XL_Kit.KitName,".").   
      if connected(logdbname) then        
      DO:
        disconnect value(logdbname). 
        if error-status:error then return no-apply. 
      end.
      IF NOT AVAILABLE (xlatedb.XL_Project) THEN FIND FIRST xlatedb.XL_Project NO-LOCK NO-ERROR.

      ASSIGN
         FILE-INFO:FILENAME = xlatedb.XL_Project.RootDirectory + "{&SLASH}" 
                            + ENTRY(1,xlatedb.XL_Kit.KitName,".") + ".db":U
         cFileName = IF FILE-INFO:FULL-PATHNAME <> ? THEN 
                        FILE-INFO:FULL-PATHNAME 
                     ELSE 
                    xlatedb.XL_Project.RootDirectory + "~\":U 
                    + xlatedb.XL_Kit.KitName
     KitDB = cFileName.
      IF SEARCH(file-info:FULL-PATHNAME) <> ? THEN
      DO:
         RUN adetran/common/_dbmgmt.p
            (INPUT  "DELETE":U,
             INPUT  cFileName,
             INPUT  "kit":U,
             INPUT  ?,
             INPUT  ?,
             OUTPUT Result).
         IF Result THEN RETURN NO-APPLY.
      END. /* Found the database struc file */
    end. /* choice 2 */
    
    /*
    ** Now, if we're here then no errors occured, and the various databases
    ** were deleted (if selected).
    */          
    find xlatedb.XL_Kit where
      xlatedb.XL_Kit.KitName = _Kit exclusive-lock no-error.
    if available xlatedb.XL_Kit THEN
    DO:
      /* First delete associated kit-proc cross-reference records */
      FOR EACH xlatedb.XL_Kit-Proc OF xlatedb.XL_Kit EXCLUSIVE-LOCK:
        DELETE xlatedb.XL_Kit-Proc.
      END.
      DELETE xlatedb.XL_Kit.
    END. /* If kit is available */
    run Realize.
  end.  /* choice 1 */
END. /* trigger */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME Glossaries
&Scoped-define SELF-NAME Glossaries
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Glossaries WINDOW-1
ON VALUE-CHANGED OF Glossaries IN FRAME KitsFrame
DO:
  _Kit = xlatedb.XL_Kit.KitName.
END.

ON ANY-KEY OF xlatedb.XL_Kit.GlossaryName IN BROWSE Glossaries
DO:
   IF NOT CAN-DO("CURSOR-*,HOME,END,TAB",KEYLABEL(LASTKEY)) THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK WINDOW-1 


/********************************** Main Block *********************************/
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{adetran/common/noscroll.i}

PAUSE 0 BEFORE-HIDE.

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:    
   
   assign
     frame {&frame-name}:parent      = _MainWindow  
     Glossaries:num-locked-columns   = 1.  
END.
{adecomm/_adetool.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EnableFrame WINDOW-1 
PROCEDURE EnableFrame :
define input parameter pMode as logical no-undo.
  frame {&frame-name}:sensitive = pMode.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HideMe WINDOW-1 
PROCEDURE HideMe :
frame {&frame-name}:hidden = true.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQuery WINDOW-1 
PROCEDURE OpenQuery :
do with frame {&frame-name}: 
  run adecomm/_setcurs.p ("wait":u).
    open query Glossaries for each xlatedb.XL_Kit,
    each xlatedb.XL_Project where true NO-LOCK. 
    find first xlatedb.XL_Kit no-lock no-error.
    if available xlatedb.XL_Kit then
      _Kit = xlatedb.XL_Kit.KitName.
  run adecomm/_setcurs.p ("").
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize WINDOW-1 
PROCEDURE Realize :
do with frame {&frame-name}:   
  define var PhraseFlag as logical.
  define var GlossaryFlag as logical.
  define var TransFlag as logical.  
  define var NumProcs as integer.
  
  run adetran/pm/_getcnt.p 
      (output PhraseFlag, output GlossaryFlag,
       output TransFlag, output NumProcs).
  
  enable 
    Glossaries
    BtnAdd 
    BtnRemove
    BtnConsolidate
    BtnCreateZip
    BtnInstallZip
  with frame {&frame-name} in window _MainWindow. 
      
  find first xlatedb.XL_Glossary no-lock no-error.
  
  if PhraseFlag and available xlatedb.XL_Glossary then
    BtnAdd:sensitive = true.
  else 
    BtnAdd:sensitive = false.
    
  find first xlatedb.XL_Kit no-lock no-error.
  if available xlatedb.XL_Kit then assign 
    BtnRemove:sensitive      = true
    BtnConsolidate:sensitive = true
    BtnCreateZip:sensitive   = true
    BtnInstallZip:sensitive  = true.
  else assign
    BtnRemove:sensitive      = false
    BtnConsolidate:sensitive = false
    BtnCreateZip:sensitive   = false
    BtnInstallZip:sensitive  = false.

  run OpenQuery.
  frame {&frame-name}:hidden = false.  
end.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


