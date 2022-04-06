&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" sObject _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" sObject _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/* Copyright (c) 2000-2008 by Progress Software Corporation.  All rights 
   reserved.  Prior versions of this work may contain portions 
   contributed by participants of Possenet.  */
/*---------------------------------------------------------------------------------
  File: gscddimprv.w

  Description:  Dataset Import SmartObject (Viewer)

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   06/27/2002  Author:     Mark Davies (MIP)

  Update Notes: Created from Template rysttsimpv.w

  (v:010001)    Task:           9   UserRef:    
                Date:   02/14/2003  Author:     Thomas Hansen

  Update Notes: Issue 3533:
                Changed the defult Input directory to be the workspace root directory for
                the currently selected workspace if RTB is connected.

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gscddimprv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartObject yes

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE ghDSAPI AS HANDLE     NO-UNDO.

{src/adm2/globals.i}

DEFINE TEMP-TABLE ttAvailable NO-UNDO RCODE-INFORMATION
  FIELD cDisplayFileName AS CHARACTER FORMAT "X(60)":U    LABEL "File name":U
  FIELD cFileName        AS CHARACTER
  FIELD cPath            AS CHARACTER
  FIELD cRootDir         AS CHARACTER
  FIELD daModDate        AS DATE      FORMAT "99/99/99":U LABEL "Mod Date":U
  FIELD cStrTime         AS CHARACTER FORMAT "X(8)":U     LABEL "Mod Time":U
  FIELD iModTime         AS INTEGER
  INDEX pudx IS UNIQUE PRIMARY
    cFileName
  .

DEFINE TEMP-TABLE ttSelected NO-UNDO RCODE-INFORMATION
  FIELD cDisplayFileName AS CHARACTER FORMAT "X(60)" LABEL "File name":U
  FIELD cFileName        AS CHARACTER
  FIELD cPath            AS CHARACTER
  FIELD cRootDir         AS CHARACTER
  FIELD daModDate        AS DATE      FORMAT "99/99/99":U LABEL "Mod Date":U
  FIELD cStrTime         AS CHARACTER FORMAT "X(8)":U     LABEL "Mod Time":U
  FIELD iModTime         AS INTEGER
  INDEX pudx IS UNIQUE PRIMARY
    cFileName
  INDEX dx
    daModDate
    iModTime
  .


DEFINE TEMP-TABLE ttDirectory NO-UNDO
  FIELD cDirPath         AS CHARACTER
  FIELD iStackLevel      AS INTEGER
  INDEX pudx IS UNIQUE PRIMARY
    cDirPath
  INDEX udx IS UNIQUE
    iStackLevel
    cDirPath
  .

/* This temp-table is used to pass parameters into import deployment dataset */
DEFINE TEMP-TABLE ttImportParam NO-UNDO
  FIELD cParam             AS CHARACTER
  FIELD cValue             AS CHARACTER
  INDEX dx IS PRIMARY
    cParam
  .

DEFINE VARIABLE hQryAvailable AS HANDLE     NO-UNDO.
DEFINE VARIABLE hQrySelected  AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain
&Scoped-define BROWSE-NAME brAvailable

/* Definitions for FRAME frMain                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 fiInputDirectory ~
buRootDirectory lRecurse fiModDate fiModTime lMod lOverwrite lSetModified ~
lRemoveDeletes brAvailable brSelected buAddAll buAdd buRemove buRemoveAll ~
buSelAllAvail buDeselAllAvail buSelAllSelect buDeselAllSelect buImport ~
fiProcessing 
&Scoped-Define DISPLAYED-OBJECTS fiInputDirectory lRecurse fiModDate ~
fiModTime lMod lOverwrite lSetModified lRemoveDeletes fiProcessing 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getGlobalControlObj sObject 
FUNCTION getGlobalControlObj RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLastUpdate sObject 
FUNCTION getLastUpdate RETURNS LOGICAL
  ( OUTPUT pdaDate AS DATE,
    OUTPUT piTime  AS INTEGER ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD openQuery sObject 
FUNCTION openQuery RETURNS LOGICAL
  ( INPUT phBuffer AS HANDLE,
    INPUT-OUTPUT phQuery AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD parseTime sObject 
FUNCTION parseTime RETURNS INTEGER
  ( INPUT pcTime AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLastupdate sObject 
FUNCTION setLastupdate RETURNS LOGICAL
  ( INPUT pdaDate AS DATE,
    INPUT piTime  AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buAdd 
     LABEL "Add >" 
     SIZE 18 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buAddAll 
     LABEL "Add All >>" 
     SIZE 18 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buDeselAllAvail 
     LABEL "Deselect All" 
     SIZE 20.4 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buDeselAllSelect 
     LABEL "Deselect All" 
     SIZE 20.4 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buFetch 
     LABEL "&Fetch File List" 
     SIZE 18 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buImport 
     LABEL "&Import" 
     SIZE 18.8 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buRemove 
     LABEL "< Remove" 
     SIZE 18 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buRemoveAll 
     LABEL "<< Remove All" 
     SIZE 18 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buRootDirectory 
     LABEL "..." 
     SIZE 3.4 BY 1 TOOLTIP "Directory lookup"
     BGCOLOR 8 .

DEFINE BUTTON buSelAllAvail 
     LABEL "Select All" 
     SIZE 20.4 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buSelAllSelect 
     LABEL "Select All" 
     SIZE 20.4 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE fiInputDirectory AS CHARACTER FORMAT "X(256)":U 
     LABEL "Input directory" 
     VIEW-AS FILL-IN 
     SIZE 78 BY 1 NO-UNDO.

DEFINE VARIABLE fiModDate AS DATE FORMAT "99/99/9999":U 
     LABEL "Date" 
     VIEW-AS FILL-IN 
     SIZE 22.4 BY 1 NO-UNDO.

DEFINE VARIABLE fiModTime AS CHARACTER FORMAT "X(8)":U INITIAL "00:00:00" 
     LABEL "Time" 
     VIEW-AS FILL-IN 
     SIZE 12.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiProcessing AS CHARACTER FORMAT "X(256)":U 
     LABEL "Processing" 
      VIEW-AS TEXT 
     SIZE 112.8 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 147.2 BY 1.71.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 63.6 BY 14.1.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 63.4 BY 14.1.

DEFINE VARIABLE lMod AS LOGICAL INITIAL no 
     LABEL "Select files modified since" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.4 BY .81 NO-UNDO.

DEFINE VARIABLE lOverwrite AS LOGICAL INITIAL no 
     LABEL "Overwrite existing data" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.2 BY .81 NO-UNDO.

DEFINE VARIABLE lRecurse AS LOGICAL INITIAL no 
     LABEL "Recurse subdirectories" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.8 BY .81 NO-UNDO.

DEFINE VARIABLE lRemoveDeletes AS LOGICAL INITIAL no 
     LABEL "Remove delete notes" 
     VIEW-AS TOGGLE-BOX
     SIZE 32.4 BY .81 NO-UNDO.

DEFINE VARIABLE lSetModified AS LOGICAL INITIAL no 
     LABEL "Set modified status" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.8 BY .81 NO-UNDO.


/* Browse definitions                                                   */
DEFINE BROWSE brAvailable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brAvailable sObject _STRUCTURED
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 61.4 BY 12.

DEFINE BROWSE brSelected
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSelected sObject _STRUCTURED
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 61.4 BY 12 ROW-HEIGHT-CHARS .62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiInputDirectory AT ROW 1.38 COL 17.4 COLON-ALIGNED
     buRootDirectory AT ROW 1.38 COL 96.6
     buFetch AT ROW 1.38 COL 130.2
     lRecurse AT ROW 1.57 COL 102.2
     fiModDate AT ROW 2.57 COL 53.8 COLON-ALIGNED
     fiModTime AT ROW 2.57 COL 85.8 COLON-ALIGNED
     lMod AT ROW 2.71 COL 19.4
     lOverwrite AT ROW 3.67 COL 19.4
     lSetModified AT ROW 4.57 COL 19.4
     lRemoveDeletes AT ROW 5.43 COL 19.4
     brAvailable AT ROW 6.91 COL 3.6
     brSelected AT ROW 6.91 COL 86.6
     buAddAll AT ROW 9.05 COL 67
     buAdd AT ROW 10.67 COL 67
     buRemove AT ROW 12.19 COL 67
     buRemoveAll AT ROW 13.71 COL 67
     buSelAllAvail AT ROW 19.19 COL 9.8
     buDeselAllAvail AT ROW 19.19 COL 37
     buSelAllSelect AT ROW 19.19 COL 93
     buDeselAllSelect AT ROW 19.19 COL 122.4
     buImport AT ROW 21.48 COL 3.8
     fiProcessing AT ROW 21.76 COL 33.8 COLON-ALIGNED
     "File list:" VIEW-AS TEXT
          SIZE 7.4 BY .62 AT ROW 6.24 COL 4.6
     "Selected files:" VIEW-AS TEXT
          SIZE 14.2 BY .62 AT ROW 6.24 COL 87.8
     RECT-1 AT ROW 21.19 COL 2.2
     RECT-2 AT ROW 6.62 COL 2.6
     RECT-3 AT ROW 6.62 COL 85.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
   Allow: Basic
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW sObject ASSIGN
         HEIGHT             = 22.05
         WIDTH              = 148.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/visual.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB brAvailable lRemoveDeletes frMain */
/* BROWSE-TAB brSelected brAvailable frMain */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON buFetch IN FRAME frMain
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME brAvailable
&Scoped-define SELF-NAME brAvailable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brAvailable sObject
ON DEFAULT-ACTION OF brAvailable IN FRAME frMain
DO:
  APPLY "CHOOSE":U TO buAdd.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brAvailable sObject
ON VALUE-CHANGED OF brAvailable IN FRAME frMain
DO:
  RUN setSensitive.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSelected
&Scoped-define SELF-NAME brSelected
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSelected sObject
ON DEFAULT-ACTION OF brSelected IN FRAME frMain
DO:
  APPLY "CHOOSE":U TO buRemove.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSelected sObject
ON VALUE-CHANGED OF brSelected IN FRAME frMain
DO:
  RUN setSensitive.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAdd sObject
ON CHOOSE OF buAdd IN FRAME frMain /* Add > */
DO:
  RUN moveRecs (brAvailable:HANDLE, brSelected:HANDLE, NO, "":U).
  apply 'entry' to brAvailable.
  
  if brAvailable:focused-row ne ? then
      browse brAvailable:select-focused-row().
  run setSensitive.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buAddAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAddAll sObject
ON CHOOSE OF buAddAll IN FRAME frMain /* Add All >> */
DO:
  RUN moveRecs (brAvailable:HANDLE, brSelected:HANDLE, YES, "":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDeselAllAvail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDeselAllAvail sObject
ON CHOOSE OF buDeselAllAvail IN FRAME frMain /* Deselect All */
DO:
  RUN selectRecs(BROWSE brAvailable:HANDLE, NO).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDeselAllSelect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDeselAllSelect sObject
ON CHOOSE OF buDeselAllSelect IN FRAME frMain /* Deselect All */
DO:
  RUN selectRecs(BROWSE brSelected:HANDLE, NO).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buFetch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buFetch sObject
ON CHOOSE OF buFetch IN FRAME frMain /* Fetch File List */
DO:
  RUN fetchFiles.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buImport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buImport sObject
ON CHOOSE OF buImport IN FRAME frMain /* Import */
DO:
  RUN importADOs NO-ERROR. 
  IF ERROR-STATUS:ERROR THEN
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRemove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRemove sObject
ON CHOOSE OF buRemove IN FRAME frMain /* < Remove */
DO:
  RUN moveRecs ( brSelected:HANDLE, brAvailable:HANDLE, NO, "":U).
  apply 'entry' to brSelected.
  
  if brSelected:focused-row ne ? then
      browse brSelected:select-focused-row().
  run setSensitive.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRemoveAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRemoveAll sObject
ON CHOOSE OF buRemoveAll IN FRAME frMain /* << Remove All */
DO:
  RUN moveRecs ( brSelected:HANDLE, brAvailable:HANDLE, YES, "":U).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRootDirectory
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRootDirectory sObject
ON CHOOSE OF buRootDirectory IN FRAME frMain /* ... */
DO:
    RUN getFolder("Directory", OUTPUT fiInputDirectory).
    IF fiInputDirectory <> "":U THEN
      ASSIGN
          fiInputDirectory:SCREEN-VALUE = fiInputDirectory.
    APPLY "VALUE-CHANGED":U TO fiInputDirectory.
    APPLY "entry":U TO fiInputDirectory.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSelAllAvail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSelAllAvail sObject
ON CHOOSE OF buSelAllAvail IN FRAME frMain /* Select All */
DO:
  RUN selectRecs(BROWSE brAvailable:HANDLE, YES).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSelAllSelect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSelAllSelect sObject
ON CHOOSE OF buSelAllSelect IN FRAME frMain /* Select All */
DO:
  RUN selectRecs(BROWSE brSelected:HANDLE, YES).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiInputDirectory
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiInputDirectory sObject
ON LEAVE OF fiInputDirectory IN FRAME frMain /* Input directory */
DO:
  IF {&SELF-NAME}:SCREEN-VALUE = "":U OR
     {&SELF-NAME}:SCREEN-VALUE = ? THEN
    buFetch:SENSITIVE = NO.
  ELSE
    buFetch:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiInputDirectory sObject
ON VALUE-CHANGED OF fiInputDirectory IN FRAME frMain /* Input directory */
DO:
  IF {&SELF-NAME}:SCREEN-VALUE = "":U OR
     {&SELF-NAME}:SCREEN-VALUE = ? THEN
    buFetch:SENSITIVE = NO.
  ELSE
    buFetch:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiModTime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiModTime sObject
ON LEAVE OF fiModTime IN FRAME frMain /* Time */
DO:
  DEFINE VARIABLE iTime AS INTEGER    NO-UNDO.
  ASSIGN {&SELF-NAME}.
  iTime = parseTime({&SELF-NAME}).
  IF iTime = ? THEN
  DO:
    BELL.
    RETURN NO-APPLY.
  END.
  ELSE
  DO:
    {&SELF-NAME} = STRING(iTime,"HH:MM:SS":U).
    DISPLAY {&SELF-NAME} WITH FRAME {&FRAME-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lMod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lMod sObject
ON VALUE-CHANGED OF lMod IN FRAME frMain /* Select files modified since */
DO:
  RUN setSensitive.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lRecurse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lRecurse sObject
ON VALUE-CHANGED OF lRecurse IN FRAME frMain /* Recurse subdirectories */
DO:
  ASSIGN {&SELF-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brAvailable
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI sObject  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME frMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject sObject 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchFiles sObject 
PROCEDURE fetchFiles :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
    SESSION:SET-WAIT-STATE("GENERAL":U).
    ASSIGN 
      fiInputDirectory
      lMod
      fiModDate
      fiModTime
    .

    IF fiInputDirectory = "":U OR
       fiInputDirectory = ? THEN 
      RETURN.

    EMPTY TEMP-TABLE ttAvailable.

    RUN recurseDirectory(fiInputDirectory, lRecurse, 0).

    openQuery(INPUT BUFFER ttAvailable:HANDLE, INPUT-OUTPUT hQryAvailable).
    SESSION:SET-WAIT-STATE("":U).


  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFolder sObject 
PROCEDURE getFolder :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER ipTitle AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER opPath  AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE lhServer AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE lhFolder AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE lhParent AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE lvFolder AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lvCount  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hFrame   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWin     AS HANDLE     NO-UNDO.

  hFrame = FRAME {&FRAME-NAME}:HANDLE.
  hWin   = hFrame:WINDOW.
  
  CREATE 'Shell.Application' lhServer.
  
  ASSIGN
      lhFolder = lhServer:BrowseForFolder(hWin:HWND,ipTitle,0).
  
  IF VALID-HANDLE(lhFolder) = True 
  THEN DO:
      ASSIGN 
          lvFolder = lhFolder:Title
          lhParent = lhFolder:ParentFolder
          lvCount  = 0.
      REPEAT:
          IF lvCount >= lhParent:Items:Count THEN
              DO:
                  ASSIGN
                      opPath = "":U.
                  LEAVE.
              END.
          ELSE
              IF lhParent:Items:Item(lvCount):Name = lvFolder THEN
                  DO:
                      ASSIGN
                          opPath = lhParent:Items:Item(lvCount):Path.
                      LEAVE.
                  END.
          ASSIGN lvCount = lvCount + 1.
      END.
  END.
  ELSE
      ASSIGN
          opPath = "":U.
  
  RELEASE OBJECT lhParent NO-ERROR.
  RELEASE OBJECT lhFolder NO-ERROR.
  RELEASE OBJECT lhServer NO-ERROR.
  
  ASSIGN
    lhParent = ?
    lhFolder = ?
    lhServer = ?
    .
  
  IF SUBSTRING(opPath,1,2) <> "~\~\":U THEN
    ASSIGN opPath = TRIM(REPLACE(LC(opPath),"~\":U,"/":U),"/":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importADOs sObject 
PROCEDURE importADOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRetVal         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE daDate          AS DATE       NO-UNDO.
  DEFINE VARIABLE iTime           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iResults        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCount          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTT             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dStart AS DATE       NO-UNDO.
  DEFINE VARIABLE tStart AS INTEGER    NO-UNDO.
  DEFINE VARIABLE dEnd   AS DATE       NO-UNDO.
  DEFINE VARIABLE tEnd   AS INTEGER    NO-UNDO.
  def var cEDOFile as character no-undo.
  def var lError as logical no-undo.

  DEFINE BUFFER bttSelected FOR ttSelected.
  DEFINE BUFFER bttImportParam FOR ttImportParam.

  DEFINE QUERY qSelected FOR bttSelected.

  DO WITH FRAME {&FRAME-NAME}:
    daDate = ?.
    iTime  = 0.
    ASSIGN
      lOverwrite
      lSetModified
      lRemoveDeletes
    .

    DO FOR bttImportParam:
      CREATE bttImportParam.
      ASSIGN
        bttImportParam.cParam = "SetModified":U
        bttImportParam.cValue = STRING(lSetModified,"YES/NO":U)
      .
      CREATE bttImportParam.
      ASSIGN
        bttImportParam.cParam = "RemoveDeletions":U
        bttImportParam.cValue = STRING(lRemoveDeletes,"YES/NO":U)
      .
    END.
                       
    OPEN QUERY qSelected
      PRESELECT EACH bttSelected.
    GET FIRST qSelected.
    iResults = NUM-RESULTS("qSelected").

    dStart = TODAY.
    tStart = TIME.
    lError = No.
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    REPEAT WHILE NOT QUERY-OFF-END("qSelected"):
      iCount = iCount + 1.
  
      ERROR-STATUS:ERROR = NO.
  
      fiProcessing:SCREEN-VALUE = "(":U + STRING(iCount) + " of " + STRING(iResults) + ") ":U
                                + bttSelected.cFileName.

      hTT = ?.
      buImport:sensitive = no.
      
      RUN importDeploymentDataset IN ghDSAPI
        (bttSelected.cPath,
         bttSelected.cRootDir,
         '',
         lOverwrite,
         YES,
         NO,
         INPUT TABLE ttImportParam,
         INPUT TABLE-HANDLE hTT,
         OUTPUT cRetVal) no-error.
            
      {afcheckerr.i &display-error = YES}.
      
      IF daDate = ? THEN
        ASSIGN 
          daDate = bttSelected.daModDate
          iTime  = bttSelected.iModTime
        .
      ELSE
      DO:
        IF daDate < bttSelected.daModDate THEN
          ASSIGN 
            daDate = bttSelected.daModDate
            iTime  = bttSelected.iModTime
          .
        ELSE IF daDate = bttSelected.daModDate AND
             iTime < bttSelected.iModTime THEN
          ASSIGN 
            daDate = bttSelected.daModDate
            iTime  = bttSelected.iModTime
          .
      END.

      /* Look for the existence of an EDO file. If one exists,
         flag the import as having errors. */
      cEDOFile = dynamic-function('buildFileName' in ghDSAPI, 
                                  bttSelected.cRootDir, bttSelected.cPath).
      if num-entries(cEDOFile, '.':U) gt 1 then
          entry(num-entries(cEDOFile, '.':u), cEDOFile, '.':u) = 'edo':u.
      else
          cEDOFile = cEDOFile + '.edo':u.
      
      /* Keep any ADOs which have load errors in the 'selected' browser. */
      if search(cEDOFile) ne ? then
          lError = yes.
       else
           delete bttSelected.
      
      GET NEXT qSelected.
    END.
    SESSION:SET-WAIT-STATE("":U).

    dEnd = TODAY.
    tEnd = TIME.
    
    IF LOGICAL(DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                "_debug_tools_on":U)) = YES THEN
    DO:
      OUTPUT TO gscddxmlpstat.txt APPEND.
      EXPORT "Dataset Import":U STRING(dStart,"99/99/9999") STRING(tStart,"HH:MM:SS") STRING(dEnd,"99/99/9999") STRING(tEnd,"HH:MM:SS").
      OUTPUT CLOSE.
    END.
    
    if lError then
        fiProcessing:Screen-Value = 'Completed with errors'.
    else
        fiProcessing:SCREEN-VALUE = "Complete".
    
    EMPTY TEMP-TABLE ttAvailable.

    RUN deletePool IN ghDSAPI.

    IF daDate <> ? THEN
      setLastUpdate(daDate,iTime).

    getLastUpdate(OUTPUT fiModDate, OUTPUT iTime).
    fiModTime = STRING(iTime,"HH:MM:SS":U).

    DISPLAY
      fiModDate
      fiModTime
    .

  END.
  
  
  RUN openQueries.  


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iTime             AS INTEGER    NO-UNDO.
  
  getLastUpdate(OUTPUT fiModDate, OUTPUT iTime).
  fiModTime = STRING(iTime,"HH:MM:SS":U).
  lMod = YES.
  DO WITH FRAME {&FRAME-NAME}:
    DISPLAY fiModDate fiModTime.
    ASSIGN lMod:CHECKED = lMod.
  END.

  ASSIGN 
     fiInputDirectory = DYNAMIC-FUNCTION('getSessionRootDirectory':U IN THIS-PROCEDURE) NO-ERROR.
  IF fiInputDirectory <> ? AND 
     fiInputDirectory <> "?":U AND 
     fiInputDirectory <> "":U THEN
  ASSIGN 
     fiInputDirectory:SCREEN-VALUE = fiInputDirectory.                                    
  
  /* Start the Dataset API procedure */
  RUN startProcedure IN THIS-PROCEDURE ("ONCE|af/app/gscddxmlp.p":U, 
                                        OUTPUT ghDSAPI).
  
  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  RUN openQueries.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE moveRecs sObject 
PROCEDURE moveRecs :
/*------------------------------------------------------------------------------
  Purpose:     Moves records from one temp-table to another and reopens the
               queries on both.
  Parameters:  
    phFrom: Handle to the from browse
    phTo  : Handle to the to browse
    plAll : If yes, all the records in the from browse are moved
            to the to browse, otherwise only the selected records are moved.
    pcDefault: If a value is set, this procedure that creates the record will
               attempt to call the default procedure named in this variable to
               allow the program to set values that need to be defaulted.

  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phFrom    AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER phTo      AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER plAll     AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcDefault AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hFromQry  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFromBuff AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWrkBuff  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hToQry    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hToBuff   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount    AS INTEGER    NO-UNDO.

  hFromQry = phFrom:QUERY.
  hToQry   = phTo:QUERY.

  hWrkBuff = hToQry:GET-BUFFER-HANDLE(1).
  CREATE BUFFER hToBuff FOR TABLE hWrkBuff.

  IF plAll THEN
  DO:
    hWrkBuff = hFromQry:GET-BUFFER-HANDLE(1).
    CREATE BUFFER hFromBuff FOR TABLE hWrkBuff.
    CREATE QUERY hQuery.
    hQuery:ADD-BUFFER(hFromBuff).
    hQuery:QUERY-PREPARE("FOR EACH ":U + hFromBuff:NAME).
    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST().
    REPEAT WHILE NOT hQuery:QUERY-OFF-END:
      /* Check if the source record is in the target buffer already. 
         If so, just remove the record from the source buffer 
         and leave the target buffer as-is. */
      hToBuff:find-first('where ' + hToBuff:name + '.cFileName = ':u + quoter(hFromBuff::cFileName)) no-error.
      if not hToBuff:available then
      do:
          hToBuff:BUFFER-CREATE().
          hToBuff:BUFFER-COPY(hFromBuff).
          IF pcDefault <> "":U AND
             pcDefault <> ? THEN
            RUN VALUE(pcDefault) IN THIS-PROCEDURE (INPUT hToBuff).
          hToBuff:BUFFER-RELEASE().            
      end.
                  
      hFromBuff:BUFFER-DELETE().      
      hQuery:GET-NEXT().
    END.
    hQuery:QUERY-CLOSE().
    DELETE OBJECT hQuery.
    hQuery = ?.
    DELETE OBJECT hFromBuff.
    hFromBuff = ?.
  END.
  ELSE
  DO:
    hFromBuff = hFromQry:GET-BUFFER-HANDLE(1).
    REPEAT iCount = 1 TO phFrom:NUM-SELECTED-ROWS:
      phFrom:FETCH-SELECTED-ROW(iCount).
      /* Check if the source record is in the target buffer already. 
         If so, just remove the record from the source buffer 
         and leave the target buffer as-is. */
      hToBuff:find-first('where ' + hToBuff:name + '.cFileName = ':u + quoter(hFromBuff::cFileName)) no-error.
      if not hToBuff:available then
      do:
          hToBuff:BUFFER-CREATE().
          hToBuff:BUFFER-COPY(hFromBuff).
          IF pcDefault <> "":U AND
             pcDefault <> ? THEN
            RUN VALUE(pcDefault) IN THIS-PROCEDURE (INPUT hToBuff).          
          hToBuff:BUFFER-RELEASE().
      end.
      hFromBuff:BUFFER-DELETE().          
    END.
  END.

  DELETE OBJECT hToBuff.
  hToBuff = ?.

  openQuery(INPUT BUFFER ttAvailable:HANDLE, INPUT-OUTPUT hQryAvailable).

  openQuery(INPUT BUFFER ttSelected:HANDLE, INPUT-OUTPUT hQrySelected).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueries sObject 
PROCEDURE openQueries :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hField   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSelBuff AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hAvBuff  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFields  AS CHARACTER 
    INITIAL "cDisplayFileName,daModDate,cStrTime":U NO-UNDO.

  DEFINE VARIABLE iCount   AS INTEGER    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:

    BROWSE brAvailable:QUERY = ?.
    
    BROWSE brSelected:QUERY = ?.

    hAvBuff  = BUFFER ttAvailable:HANDLE.
    hSelBuff = BUFFER ttSelected:HANDLE.

    openQuery(INPUT hAvBuff, INPUT-OUTPUT hQryAvailable).
  
    openQuery(INPUT hSelBuff, INPUT-OUTPUT hQrySelected).
   
    BROWSE brAvailable:QUERY = hQryAvailable.
    DO iCount = 1 TO NUM-ENTRIES(cFields):
      hField = hAvBuff:BUFFER-FIELD(ENTRY(iCount,cFields)).
      BROWSE brAvailable:ADD-LIKE-COLUMN(hField).
    END.
    BROWSE brAvailable:SENSITIVE = YES.

    BROWSE brSelected:QUERY = hQrySelected.
    DO iCount = 1 TO NUM-ENTRIES(cFields):
      hField = hSelBuff:BUFFER-FIELD(ENTRY(iCount,cFields)).
      BROWSE brSelected:ADD-LIKE-COLUMN(hField).
    END.
    BROWSE brSelected:SENSITIVE = YES.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recurseDirectory sObject 
PROCEDURE recurseDirectory :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcDirectory  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plRecurse    AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER piStackLevel AS INTEGER    NO-UNDO.

  DEFINE VARIABLE cRootFile   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullPath   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFlags      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWrkDir     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE daModDate   AS DATE       NO-UNDO.
  DEFINE VARIABLE iModTime    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iInpModTime AS INTEGER    NO-UNDO.

  DEFINE BUFFER bttAvailable FOR ttAvailable.
  DEFINE BUFFER bttDirectory FOR ttDirectory.

  ERROR-STATUS:ERROR = NO.

  iInpModTime = parseTime(fiModTime).

  INPUT FROM OS-DIR(pcDirectory).
  IF ERROR-STATUS:ERROR THEN
  DO:
    ERROR-STATUS:ERROR = NO.
    RETURN.
  END.

  REPEAT:
    IMPORT
      cRootFile
      cFullPath
      cFlags
    .
    IF cRootFile = ".":U OR
       cRootFile = "..":U THEN
      NEXT.

    IF INDEX(cFlags,"D":U) <> 0 AND
       plRecurse THEN
    DO:
      DO FOR bttDirectory:
        FIND FIRST bttDirectory 
          WHERE bttDirectory.cDirPath = cFullPath
          NO-ERROR.
        IF NOT AVAILABLE(bttDirectory) THEN
        DO:
          CREATE bttDirectory.
          ASSIGN
            bttDirectory.cDirPath = cFullPath
            bttDirectory.iStackLevel = piStackLevel
          .
        END.
      END.
    END.
    IF INDEX(cFlags,"F":U) <> 0 THEN
    DO:
      IF NUM-ENTRIES(cRootFile,".":U) > 1 AND
         (ENTRY(NUM-ENTRIES(cRootFile,".":U), cRootFile, ".":U) = "ado":U OR 
          ENTRY(NUM-ENTRIES(cRootFile,".":U), cRootFile, ".":U) = "edo":U) THEN
      DO:
        IF CAN-FIND(FIRST ttSelected WHERE ttSelected.cFileName = cFullPath) THEN
          NEXT.
        FILE-INFO:FILE-NAME = cFullPath.
        daModDate = FILE-INFO:FILE-MOD-DATE.
        iModTime  = FILE-INFO:FILE-MOD-TIME.
        
        IF lMod AND
           (daModDate < fiModDate OR
            (daModDate = fiModDate AND
             iModTime  <= iInpModTime)) THEN
          NEXT.
        DO FOR bttAvailable:
          FIND FIRST bttAvailable 
            WHERE bttAvailable.cFileName = cFullPath
            NO-ERROR.
          IF NOT AVAILABLE(bttAvailable) THEN
          DO:
            CREATE bttAvailable.
            ASSIGN
              cFullPath = REPLACE(cFullPath,"~\":U,"/":U)
              bttAvailable.cFileName = cFullPath
              bttAvailable.cPath     = RIGHT-TRIM(SUBSTRING(cFullPath,LENGTH(fiInputDirectory) + 1),"/":U)
              bttAvailable.cRootDir  = RIGHT-TRIM(SUBSTRING(cFullPath,1,LENGTH(fiInputDirectory)),"/":U)
              bttAvailable.daModDate = daModDate
              bttAvailable.iModTime  = iModTime
              bttAvailable.cStrTime  = STRING(iModTime,"HH:MM:SS":U)
            .
            IF LENGTH(cPath) > 55 THEN
            DO:
              bttAvailable.cDisplayFileName = SUBSTRING(cPath,1,20) + "...":U + SUBSTRING(cPath,LENGTH(cPath) - 32).
            END.
            ELSE
              bttAvailable.cDisplayFileName = cPath.
          END.
        END.
      END.
    END.

  END.
  INPUT CLOSE.

  IF plRecurse THEN
  FOR EACH bttDirectory
    WHERE bttDirectory.iStackLevel = piStackLevel:
    RUN recurseDirectory(bttDirectory.cDirPath, YES, piStackLevel + 1).
    DELETE bttDirectory.
  END.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectRecs sObject 
PROCEDURE selectRecs :
/*------------------------------------------------------------------------------
  Purpose:     Selects records in the browse.
  Parameters:  
    phBrowse:  Browse to select records in
    plSelect:  If set to yes, all records will be selected, otherwise all
               records will be deselected.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phBrowse AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER plSelect AS LOGICAL    NO-UNDO.

  IF plSelect THEN
    phBrowse:SELECT-ALL().
  ELSE
    phBrowse:DESELECT-ROWS().

  RUN setSensitive.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSensitive sObject 
PROCEDURE setSensitive :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lRecsInSelected  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lRecsInAvailable AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSelInSelected   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSelInAvailable  AS LOGICAL    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN 
      lMod
      lRecsInSelected  = VALID-HANDLE(hQrySelected) AND 
                         hQrySelected:IS-OPEN AND 
                         hQrySelected:NUM-RESULTS > 0
      lRecsInAvailable = VALID-HANDLE(hQryAvailable) AND 
                         hQryAvailable:IS-OPEN AND 
                         hQryAvailable:NUM-RESULTS > 0
      lSelInSelected   = BROWSE brSelected:NUM-SELECTED-ROWS > 0
      lSelInAvailable  = BROWSE brAvailable:NUM-SELECTED-ROWS > 0
    .

    ASSIGN
      fiModDate:SENSITIVE        = lMod
      fiModTime:SENSITIVE        = lMod
      buImport:SENSITIVE         = lRecsInSelected
      buAdd:SENSITIVE            = lSelInAvailable 
      buAddAll:SENSITIVE         = lRecsInAvailable 
      buDeselAllAvail:SENSITIVE  = lSelInAvailable
      buDeselAllSelect:SENSITIVE = lSelInSelected
      buRemove:SENSITIVE         = lSelInSelected
      buRemoveAll:SENSITIVE      = lRecsInSelected
      buSelAllAvail:SENSITIVE    = lRecsInAvailable
      buSelAllSelect:SENSITIVE   = lRecsInSelected
    .

  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getGlobalControlObj sObject 
FUNCTION getGlobalControlObj RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hGlobalControl  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuff           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQry            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hObj            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE deValue         AS DECIMAL    NO-UNDO.

  RUN getGlobalControl IN gshSessionManager ( OUTPUT TABLE-HANDLE hGlobalControl ).

  IF NOT VALID-HANDLE(hGlobalControl) THEN
    RETURN ?.

  hBuff = hGlobalControl:DEFAULT-BUFFER-HANDLE.

  CREATE QUERY hQry.
  hQry:ADD-BUFFER(hBuff).
  hQry:QUERY-PREPARE("FOR EACH ":U + hBuff:NAME + " NO-LOCK":U).
  hQry:QUERY-OPEN().
  hQry:GET-FIRST().

  hObj = hBuff:BUFFER-FIELD("global_control_obj":U).

  deValue = hObj:BUFFER-VALUE.

  hQry:QUERY-CLOSE().
  DELETE OBJECT hQry.
  DELETE OBJECT hGlobalControl.

  RETURN deValue.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLastUpdate sObject 
FUNCTION getLastUpdate RETURNS LOGICAL
  ( OUTPUT pdaDate AS DATE,
    OUTPUT piTime  AS INTEGER ):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bgsc_global_default FOR gsc_global_default.
  DEFINE VARIABLE deGlobObj AS DECIMAL    NO-UNDO.

  deGlobObj = getGlobalControlObj().

  pdaDate = ?.
  piTime = 0.

  FOR EACH bgsc_global_default NO-LOCK
    WHERE bgsc_global_default.owning_entity_mnemonic = "GSCGC":U
      AND bgsc_global_default.owning_obj             = deGlobObj
      AND bgsc_global_default.default_type           = "DDU":U
    BY bgsc_global_default.effective_date DESCENDING:

    pdaDate = bgsc_global_default.effective_date.
    piTime  = INTEGER(bgsc_global_default.default_value).
    LEAVE.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION openQuery sObject 
FUNCTION openQuery RETURNS LOGICAL
  ( INPUT phBuffer AS HANDLE,
    INPUT-OUTPUT phQuery AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF NOT VALID-HANDLE(phQuery) THEN
    CREATE QUERY phQuery.

  IF phQuery:IS-OPEN THEN
    phQuery:QUERY-CLOSE().
  ELSE
    phQuery:ADD-BUFFER(phBuffer).

  phQuery:QUERY-PREPARE("PRESELECT EACH ":U + phBuffer:NAME).

  phQuery:QUERY-OPEN().

  RUN setSensitive.

  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION parseTime sObject 
FUNCTION parseTime RETURNS INTEGER
  ( INPUT pcTime AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cElem   AS CHARACTER EXTENT 3  NO-UNDO.
  DEFINE VARIABLE iMax    AS INTEGER   EXTENT 3 INITIAL [59,59,23] NO-UNDO.
  DEFINE VARIABLE iCount  AS INTEGER             NO-UNDO.
  DEFINE VARIABLE iCount2 AS INTEGER             NO-UNDO.
  DEFINE VARIABLE iSec    AS INTEGER             NO-UNDO.
  DEFINE VARIABLE iVal    AS INTEGER             NO-UNDO.


  IF NUM-ENTRIES(pcTime,":":U) < 2 OR
     NUM-ENTRIES(pcTime,":":U) > 3 THEN
    RETURN ?.

  IF NUM-ENTRIES(pcTime,":":U) = 2 THEN
    pcTime = pcTime + ":00":U.

  DO iCount = 1 TO NUM-ENTRIES(pcTime,":":U):
    cElem[iCount] = ENTRY(4 - iCount,pcTime,":":U).
  END.

  iSec = 0.
  DO iCount = 1 TO 3:
    DO iCount2 = 1 TO LENGTH(cElem[iCount]):
      IF ASC(SUBSTRING(cElem[iCount],iCount2,1))  < 48 OR
         ASC(SUBSTRING(cElem[iCount],iCount2,1))  > 57 THEN
        RETURN ?.
    END.

    iVal = INTEGER(cElem[iCount]).
    IF iVal > iMax[iCount] THEN
      RETURN ?.
     
    iSec = iSec + ( iVal * MAX(EXP(60, (iCount - 1 )), 1)).
  END.

  RETURN iSec.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLastupdate sObject 
FUNCTION setLastupdate RETURNS LOGICAL
  ( INPUT pdaDate AS DATE,
    INPUT piTime  AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bgsc_global_default FOR gsc_global_default.
  DEFINE VARIABLE deGlobObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lSet      AS LOGICAL    NO-UNDO.

  deGlobObj = getGlobalControlObj().

  FOR EACH bgsc_global_default 
    WHERE bgsc_global_default.owning_entity_mnemonic = "GSCGC":U
      AND bgsc_global_default.owning_obj             = deGlobObj
      AND bgsc_global_default.default_type           = "DDU":U
      AND bgsc_global_default.effective_date         >= pdaDate
    BY bgsc_global_default.effective_date DESCENDING:

    IF bgsc_global_default.effective_date = pdaDate AND
       INTEGER(bgsc_global_default.default_value) < piTime THEN
      bgsc_global_default.default_value = STRING(piTime).
    
    lSet = YES.

    LEAVE.
  END.

  IF NOT lSet THEN
  DO TRANSACTION:
    CREATE bgsc_global_default.
    ASSIGN
      bgsc_global_default.owning_entity_mnemonic = "GSCGC":U
      bgsc_global_default.owning_obj             = deGlobObj
      bgsc_global_default.default_type           = "DDU":U
      bgsc_global_default.effective_date         = pdaDate
      bgsc_global_default.default_value          = STRING(piTime)
    .
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

