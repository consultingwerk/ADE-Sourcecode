&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" fFrameWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" fFrameWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS fFrameWin 
/*********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All      *
* rights reserved. Prior versions of this work may contain portions  *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: gscdddsxprtf.w

  Description:  Dataset Export Frame

  Purpose:      Dataset Export Frame

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   09/26/2001  Author:     Bruce Gruenbaum

  Update Notes: Created from Template rysttbfrmw.w

  (v:010001)    Task:           9   UserRef:    
                Date:   02/14/2003  Author:     Thomas Hansen

  Update Notes: Issue 3533:
                Changed the default output directory at startup to be the root workspace
                directory + "src/icf" when RTB is connected.

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

&scop object-name       gscdddsxprtf.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartFrame yes

{af/sup2/afglobals.i}

DEFINE TEMP-TABLE ttDSAvailable NO-UNDO RCODE-INFORMATION
  FIELD dataset_code LIKE gsc_deploy_dataset.dataset_code
  FIELD dataset_description LIKE gsc_deploy_dataset.dataset_description
  FIELD disable_ri LIKE gsc_deploy_dataset.disable_ri 
  FIELD source_code_data LIKE gsc_deploy_dataset.source_code_data
  FIELD deploy_full_data LIKE gsc_deploy_dataset.deploy_full_data
  INDEX pudx IS UNIQUE PRIMARY
    dataset_code
  .

DEFINE TEMP-TABLE ttDSSelected NO-UNDO RCODE-INFORMATION
  FIELD dataset_code LIKE gsc_deploy_dataset.dataset_code
  FIELD dataset_description LIKE gsc_deploy_dataset.dataset_description
  FIELD lFilePerRecord AS LOGICAL FORMAT "YES/NO" COLUMN-LABEL "File Per!Record"
  FIELD cFileName      AS CHARACTER FORMAT "X(30)":U COLUMN-LABEL "File name/!Field name"
  FIELD disable_ri LIKE gsc_deploy_dataset.disable_ri 
  FIELD source_code_data LIKE gsc_deploy_dataset.source_code_data
  FIELD deploy_full_data LIKE gsc_deploy_dataset.deploy_full_data
  INDEX pudx IS UNIQUE PRIMARY
    dataset_code
  .

DEFINE VARIABLE hQryAvailable AS HANDLE     NO-UNDO.
DEFINE VARIABLE hQrySelected  AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartFrame
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain
&Scoped-define BROWSE-NAME brAvailable

/* Definitions for FRAME fMain                                          */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiRootDirectory buRootDirectory RECT-2 ~
RECT-3 RECT-4 fiBlankDirectory buBlankDir lResetModified lAllModified ~
lRemoveDeletion lIncludeDeletions brAvailable brSelected buAddAll buAdd ~
buRemove buRemoveAll buSelAllAvail buDeselAllAvail buSelAllSelect ~
buDeselAllSelect buProperties 
&Scoped-Define DISPLAYED-OBJECTS fiRootDirectory fiBlankDirectory ~
lResetModified lAllModified lFullDS lRemoveDeletion dtStart dtEnd toByDate ~
lIncludeDeletions 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD enableDateButtons fFrameWin 
FUNCTION enableDateButtons RETURNS LOGICAL
  ( plEnable AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD openQuery fFrameWin 
FUNCTION openQuery RETURNS LOGICAL
  ( INPUT phBuffer AS HANDLE,
    INPUT-OUTPUT phQuery AS HANDLE )  FORWARD.

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

DEFINE BUTTON buBlankDir 
     LABEL "..." 
     SIZE 3.4 BY 1 TOOLTIP "Directory lookup"
     BGCOLOR 8 .

DEFINE BUTTON buDeselAllAvail 
     LABEL "Deselect All" 
     SIZE 20.4 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buDeselAllSelect 
     LABEL "Deselect All" 
     SIZE 20.4 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buProperties 
     LABEL "Properties..." 
     SIZE 20.4 BY 1.14
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

DEFINE VARIABLE dtEnd AS DATE FORMAT "99/99/9999":U 
     LABEL "and" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 15.6 BY 1 NO-UNDO.

DEFINE VARIABLE dtStart AS DATE FORMAT "99/99/9999":U 
     LABEL "Between" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 15.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiBlankDirectory AS CHARACTER FORMAT "X(256)":U 
     LABEL "Unspecified directory" 
     VIEW-AS FILL-IN 
     SIZE 97.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiRootDirectory AS CHARACTER FORMAT "X(256)":U 
     LABEL "Output directory" 
     VIEW-AS FILL-IN 
     SIZE 97.6 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 57.2 BY 16.81.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 66.8 BY 16.81.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68.8 BY 2.48.

DEFINE VARIABLE lAllModified AS LOGICAL INITIAL no 
     LABEL "Deploy all modified data" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.6 BY .81 NO-UNDO.

DEFINE VARIABLE lFullDS AS LOGICAL INITIAL yes 
     LABEL "Full datasets for non-SCM data" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.8 BY .81 NO-UNDO.

DEFINE VARIABLE lIncludeDeletions AS LOGICAL INITIAL no 
     LABEL "Include deletions" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .81 NO-UNDO.

DEFINE VARIABLE lRemoveDeletion AS LOGICAL INITIAL no 
     LABEL "Remove deletions" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .81 NO-UNDO.

DEFINE VARIABLE lResetModified AS LOGICAL INITIAL no 
     LABEL "Reset data modified status" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.8 BY .81 NO-UNDO.

DEFINE VARIABLE toByDate AS LOGICAL INITIAL no 
     LABEL "By date" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.4 BY .81 NO-UNDO.


/* Browse definitions                                                   */
DEFINE BROWSE brAvailable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brAvailable fFrameWin _STRUCTURED
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 55.2 BY 14.29.

DEFINE BROWSE brSelected
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSelected fFrameWin _STRUCTURED
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 64.4 BY 14.81 ROW-HEIGHT-CHARS .62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     fiRootDirectory AT ROW 1 COL 23 COLON-ALIGNED
     buRootDirectory AT ROW 1 COL 119
     fiBlankDirectory AT ROW 2.19 COL 23 COLON-ALIGNED
     buBlankDir AT ROW 2.19 COL 119
     lResetModified AT ROW 3.29 COL 25
     lAllModified AT ROW 3.38 COL 80.4
     lFullDS AT ROW 4.19 COL 77.4
     lRemoveDeletion AT ROW 4.29 COL 30
     dtStart AT ROW 5 COL 100 COLON-ALIGNED
     dtEnd AT ROW 5 COL 123.8 COLON-ALIGNED
     toByDate AT ROW 5.14 COL 77.4
     lIncludeDeletions AT ROW 5.38 COL 25
     brAvailable AT ROW 7.48 COL 2
     brSelected AT ROW 7.48 COL 78.8
     buAddAll AT ROW 11.14 COL 58.8
     buAdd AT ROW 12.76 COL 58.8
     buRemove AT ROW 14.29 COL 58.8
     buRemoveAll AT ROW 15.81 COL 58.8
     buSelAllAvail AT ROW 22.38 COL 5.6
     buDeselAllAvail AT ROW 22.38 COL 32.8
     buSelAllSelect AT ROW 22.48 COL 79.2
     buDeselAllSelect AT ROW 22.48 COL 100.8
     buProperties AT ROW 22.48 COL 122.6
     "Available datasets:" VIEW-AS TEXT
          SIZE 19.6 BY .62 AT ROW 6.71 COL 3.2
     "Selected datasets:" VIEW-AS TEXT
          SIZE 18.8 BY .62 AT ROW 6.71 COL 80
     RECT-2 AT ROW 7.1 COL 1
     RECT-3 AT ROW 7.1 COL 77.6
     RECT-4 AT ROW 3.76 COL 76
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144 BY 23.57.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartFrame
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: PERSISTENT-ONLY
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
  CREATE WINDOW fFrameWin ASSIGN
         HEIGHT             = 23.57
         WIDTH              = 144.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB fFrameWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW fFrameWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   NOT-VISIBLE FRAME-NAME                                               */
/* BROWSE-TAB brAvailable lIncludeDeletions fMain */
/* BROWSE-TAB brSelected brAvailable fMain */
ASSIGN 
       FRAME fMain:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN dtEnd IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dtStart IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX lFullDS IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX toByDate IN FRAME fMain
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fMain
/* Query rebuild information for FRAME fMain
     _Options          = ""
     _Query            is NOT OPENED
*/  /* FRAME fMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME brAvailable
&Scoped-define SELF-NAME brAvailable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brAvailable fFrameWin
ON DEFAULT-ACTION OF brAvailable IN FRAME fMain
DO:
  APPLY "CHOOSE":U TO buAdd.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSelected
&Scoped-define SELF-NAME brSelected
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSelected fFrameWin
ON DEFAULT-ACTION OF brSelected IN FRAME fMain
DO:
  APPLY "CHOOSE":U TO buRemove.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSelected fFrameWin
ON VALUE-CHANGED OF brSelected IN FRAME fMain
DO:
  run enableControls.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAdd fFrameWin
ON CHOOSE OF buAdd IN FRAME fMain /* Add > */
DO:
  RUN moveRecs (brAvailable:HANDLE, brSelected:HANDLE, NO, "defaultTo":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buAddAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAddAll fFrameWin
ON CHOOSE OF buAddAll IN FRAME fMain /* Add All >> */
DO:
  RUN moveRecs (brAvailable:HANDLE, brSelected:HANDLE, YES, "defaultTo":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buBlankDir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buBlankDir fFrameWin
ON CHOOSE OF buBlankDir IN FRAME fMain /* ... */
DO:
    RUN getFolder("Directory", OUTPUT fiBlankDirectory).
    IF fiBlankDirectory <> "":U THEN
      ASSIGN
          fiBlankDirectory:SCREEN-VALUE = fiBlankDirectory.
    APPLY "entry":U TO fiBlankDirectory.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDeselAllAvail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDeselAllAvail fFrameWin
ON CHOOSE OF buDeselAllAvail IN FRAME fMain /* Deselect All */
DO:
  RUN selectRecs(BROWSE brAvailable:HANDLE, NO).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDeselAllSelect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDeselAllSelect fFrameWin
ON CHOOSE OF buDeselAllSelect IN FRAME fMain /* Deselect All */
DO:
  RUN selectRecs(BROWSE brSelected:HANDLE, NO).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buProperties
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buProperties fFrameWin
ON CHOOSE OF buProperties IN FRAME fMain /* Properties... */
DO:
  RUN updateDefaults.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRemove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRemove fFrameWin
ON CHOOSE OF buRemove IN FRAME fMain /* < Remove */
DO:
  RUN moveRecs ( brSelected:HANDLE, brAvailable:HANDLE, NO, "":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRemoveAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRemoveAll fFrameWin
ON CHOOSE OF buRemoveAll IN FRAME fMain /* << Remove All */
DO:
  RUN moveRecs ( brSelected:HANDLE, brAvailable:HANDLE, YES, "":U).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRootDirectory
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRootDirectory fFrameWin
ON CHOOSE OF buRootDirectory IN FRAME fMain /* ... */
DO:
  DEFINE VARIABLE lSame  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cExtra AS CHARACTER  NO-UNDO.

  IF SUBSTRING(fiBlankDirectory:SCREEN-VALUE,1,LENGTH(fiRootDirectory:SCREEN-VALUE)) = fiRootDirectory:SCREEN-VALUE THEN
  DO:
    lSame = YES.
    cExtra = SUBSTRING(fiBlankDirectory:SCREEN-VALUE,LENGTH(fiRootDirectory:SCREEN-VALUE) + 1).
  END.
  RUN getFolder("Directory", OUTPUT fiRootDirectory).
  IF fiRootDirectory <> "":U THEN
  DO:
    ASSIGN
        fiRootDirectory:SCREEN-VALUE = fiRootDirectory.
    IF lSame THEN
      ASSIGN
        fiBlankDirectory:SCREEN-VALUE = fiRootDirectory + cExtra
        fiBlankDirectory
      .
  END.
  APPLY "entry":U TO fiRootDirectory.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSelAllAvail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSelAllAvail fFrameWin
ON CHOOSE OF buSelAllAvail IN FRAME fMain /* Select All */
DO:
  RUN selectRecs(BROWSE brAvailable:HANDLE, YES).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSelAllSelect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSelAllSelect fFrameWin
ON CHOOSE OF buSelAllSelect IN FRAME fMain /* Select All */
DO:
  RUN selectRecs(BROWSE brSelected:HANDLE, YES).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiRootDirectory
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiRootDirectory fFrameWin
ON LEAVE OF fiRootDirectory IN FRAME fMain /* Output directory */
DO:
  DEFINE VARIABLE lSame  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cExtra AS CHARACTER  NO-UNDO.

  IF SUBSTRING(fiBlankDirectory:SCREEN-VALUE,1,LENGTH(fiRootDirectory)) = fiRootDirectory THEN
    ASSIGN
      lSame = YES
      cExtra = SUBSTRING(fiBlankDirectory:SCREEN-VALUE,LENGTH(fiRootDirectory) + 1)
      .

  ASSIGN
    fiRootDirectory
    .

  IF lSame THEN
    ASSIGN
      fiBlankDirectory:SCREEN-VALUE = fiRootDirectory + cExtra
      fiBlankDirectory
    .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lAllModified
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lAllModified fFrameWin
ON VALUE-CHANGED OF lAllModified IN FRAME fMain /* Deploy all modified data */
DO:
  RUN enableControls.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lResetModified
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lResetModified fFrameWin
ON VALUE-CHANGED OF lResetModified IN FRAME fMain /* Reset data modified status */
DO:
    run enableControls.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toByDate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toByDate fFrameWin
ON VALUE-CHANGED OF toByDate IN FRAME fMain /* By date */
DO:
    RUN enableControls.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brAvailable
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK fFrameWin 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
   /* Now enable the interface  if in test mode - otherwise this happens when
      the object is explicitly initialized from its container. */
   RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects fFrameWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE defaultTo fFrameWin 
PROCEDURE defaultTo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phBuffer AS HANDLE     NO-UNDO.

  DEFINE VARIABLE hFile       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFilePerRow AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDSCode     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSCMManaged AS HANDLE     NO-UNDO.
  DEFINE BUFFER bgsc_deploy_dataset  FOR gsc_deploy_dataset.
  DEFINE BUFFER bgsc_dataset_entity  FOR gsc_dataset_entity.

  hFile       = phBuffer:BUFFER-FIELD("cFileName":U).
  hFilePerRow = phBuffer:BUFFER-FIELD("lFilePerRecord":U).
  hDSCode     = phBuffer:BUFFER-FIELD("dataset_code":U).
  hSCMManaged = phBuffer:BUFFER-FIELD("source_code_data":U).

  IF hSCMManaged:BUFFER-VALUE THEN
    hFilePerRow:BUFFER-VALUE = YES.
  ELSE
    hFilePerRow:BUFFER-VALUE = NO.

  IF hFilePerRow:BUFFER-VALUE THEN
  DO:
    FIND FIRST bgsc_deploy_dataset NO-LOCK
      WHERE bgsc_deploy_dataset.dataset_code = hDSCode:BUFFER-VALUE.

    FIND FIRST bgsc_dataset_entity NO-LOCK
      WHERE bgsc_dataset_entity.deploy_dataset_obj = bgsc_deploy_dataset.deploy_dataset_obj
        AND bgsc_dataset_entity.primary_entity.

    hFile:BUFFER-VALUE = bgsc_dataset_entity.join_field_list.
  END.
  ELSE
    hFile:BUFFER-VALUE = LC(hDSCode:BUFFER-VALUE + ".ado":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI fFrameWin  _DEFAULT-DISABLE
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
  HIDE FRAME fMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI fFrameWin  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY fiRootDirectory fiBlankDirectory lResetModified lAllModified lFullDS 
          lRemoveDeletion dtStart dtEnd toByDate lIncludeDeletions 
      WITH FRAME fMain.
  ENABLE fiRootDirectory buRootDirectory RECT-2 RECT-3 RECT-4 fiBlankDirectory 
         buBlankDir lResetModified lAllModified lRemoveDeletion 
         lIncludeDeletions buAddAll buAdd buRemove buRemoveAll buSelAllAvail 
         buDeselAllAvail buSelAllSelect buDeselAllSelect buProperties 
      WITH FRAME fMain.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableControls fFrameWin 
PROCEDURE enableControls :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var hQry as handle no-undo.
    
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      lAllModified
      toByDate
      brAvailable:SENSITIVE = NOT lAllModified 
      brSelected:SENSITIVE = NOT lAllModified 
      buAdd:SENSITIVE = NOT lAllModified 
      buAddAll:SENSITIVE = NOT lAllModified 
      buDeselAllAvail:SENSITIVE = NOT lAllModified 
      buDeselAllSelect:SENSITIVE = NOT lAllModified  and brSelected:num-selected-rows gt 0

      buRemove:SENSITIVE = NOT lAllModified 
      buRemoveAll:SENSITIVE = NOT lAllModified 
      
      buSelAllAvail:SENSITIVE = NOT lAllModified
      buSelAllSelect:SENSITIVE = NOT lAllModified and brSelected:num-iterations gt 0
      
      lFullDS:SENSITIVE = lAllModified 
      lIncludeDeletions:SENSITIVE = NOT lAllModified 
      lResetModified:SENSITIVE = NOT lAllModified
      lRemoveDeletion:SENSITIVE = lResetModified:SENSITIVE and lResetModified:checked
      toByDate:SENSITIVE = lAllModified
      dtStart:SENSITIVE = toByDate
      dtEnd:SENSITIVE = toByDate
    .
    IF toByDate THEN
        DISPLAY TODAY @ dtStart TODAY @ dtEnd.
    ELSE
        ASSIGN
          dtStart:SCREEN-VALUE = ?
          dtEnd:SCREEN-VALUE = ?.
    enableDateButtons(toByDate).
    
    buProperties:SENSITIVE = NOT lAllModified and brSelected:sensitive and brSelected:num-selected-rows gt 0 .
      
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDatasetBuffer fFrameWin 
PROCEDURE getDatasetBuffer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER phBuffer AS HANDLE     NO-UNDO.

  phBuffer = BUFFER ttDSSelected:HANDLE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDirectory fFrameWin 
PROCEDURE getDirectory :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcOutDir   AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcBlankDir AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER plDataMod  AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER plInclDel  AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER plRemDel   AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER plDumpMod  AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER plFullDS   AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER plByDate   AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pdtStart   AS DATE       NO-UNDO.
  DEFINE OUTPUT PARAMETER pdtEnd     AS DATE       NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
        pcOutDir   = fiRootDirectory:SCREEN-VALUE
        pcBlankDir = fiBlankDirectory:SCREEN-VALUE
        plDataMod  = lResetModified:INPUT-VALUE
        plInclDel  = lIncludeDeletions:INPUT-VALUE
        plRemDel   = lRemoveDeletion:INPUT-VALUE
        plDumpMod  = lAllModified:INPUT-VALUE
        plFullDS   = lFullDS:INPUT-VALUE
        plByDate   = toByDate:INPUT-VALUE
        pdtStart   = dtStart:INPUT-VALUE
        pdtEnd     = dtEnd:INPUT-VALUE.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFolder fFrameWin 
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
  
  ASSIGN opPath = TRIM(REPLACE(LC(opPath),"~\":U,"/":U),"/":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject fFrameWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRootDir AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRelativeSourceDir  AS CHARACTER  NO-UNDO.
  
  RUN SUPER.
  
  cRootDir = DYNAMIC-FUNCTION("getSessionRootDirectory":U IN THIS-PROCEDURE) NO-ERROR.
    
  /* Get the relative source directory if one is set */
  cRelativeSourceDir = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                              "_scm_relative_source_directory":U) NO-ERROR.                            

  ERROR-STATUS:ERROR = NO.
                              
  /* If we managed to get a root path from the scm session parameter */
  IF cRootDir <> ? AND 
     cRelativeSourceDir <> ? THEN
  ASSIGN 
    cRootDir = TRIM(cRootDir + "/":U + TRIM(cRelativeSourceDir, "/":U), "/":U)
    . 
  ELSE 
  IF cRootDir <> ? THEN
    ASSIGN 
      FILE-INFO:FILE-NAME = cRootdir
      cRootDir = FILE-INFO:FULL-PATHNAME. 

  IF cRootDir = ? THEN
  DO:
    FILE-INFO:FILE-NAME = ".":U.
    cRootDir = FILE-INFO:FULL-PATHNAME.
  END.
  
  cRootDir = REPLACE(cRootDir,"~\":U,"/":U).

  IF cRootDir <> ? THEN
  DO WITH FRAME {&FRAME-NAME}:
    fiRootDirectory:SCREEN-VALUE = cRootDir.
    fiBlankDirectory:SCREEN-VALUE = cRootDir + "/db/icf/dump":U.
    ASSIGN
      fiRootDirectory
      fiBlankDirectory
      .
  END.

  RUN populateAvailable.
  run enableControls.

  RUN openQueries.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE moveRecs fFrameWin 
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
  def var iCurrentRow as integer no-undo.

  hFromQry = phFrom:QUERY.
  hToQry   = phTo:QUERY.
  iCurrentRow = ?.

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
      hToBuff:BUFFER-CREATE().
      hToBuff:BUFFER-COPY(hFromBuff).
      IF pcDefault <> "":U AND
         pcDefault <> ? THEN
        RUN VALUE(pcDefault) IN THIS-PROCEDURE (INPUT hToBuff).
      hFromBuff:BUFFER-DELETE().
      hToBuff:BUFFER-RELEASE().
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
      if iCurrentRow eq ? then
          iCurrentRow = hFromQry:current-result-row - 1.
          
      hToBuff:BUFFER-CREATE().
      hToBuff:BUFFER-COPY(hFromBuff).
      IF pcDefault <> "":U AND
         pcDefault <> ? THEN
        RUN VALUE(pcDefault) IN THIS-PROCEDURE (INPUT hToBuff).
      hFromBuff:BUFFER-DELETE().
      hToBuff:BUFFER-RELEASE().
    END.    
  END.

  DELETE OBJECT hToBuff.
  hToBuff = ?.

  openQuery(INPUT BUFFER ttDSAvailable:HANDLE, INPUT-OUTPUT hQryAvailable).
  openQuery(INPUT BUFFER ttDSSelected:HANDLE, INPUT-OUTPUT hQrySelected).
  
    /* Reposition to previous location, if there are any records in the browser. */
    if iCurrentRow ne ? and hFromQry:num-results gt 0 then
    do:
        hFromQry:reposition-to-row(iCurrentRow).
        phFrom:select-focused-row().
    end.
    
  run enableControls.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueries fFrameWin 
PROCEDURE openQueries :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:

    BROWSE brAvailable:QUERY = ?.
    
    BROWSE brSelected:QUERY = ?.

    openQuery(INPUT BUFFER ttDSAvailable:HANDLE, INPUT-OUTPUT hQryAvailable).
  
    openQuery(INPUT BUFFER ttDSSelected:HANDLE, INPUT-OUTPUT hQrySelected).

    BROWSE brAvailable:QUERY = hQryAvailable.
    BROWSE brAvailable:ADD-COLUMNS-FROM(BUFFER ttDSAvailable:HANDLE).
    BROWSE brAvailable:SENSITIVE = YES.

    BROWSE brSelected:QUERY = hQrySelected.
    BROWSE brSelected:ADD-COLUMNS-FROM(BUFFER ttDSSelected:HANDLE).
    BROWSE brSelected:SENSITIVE = YES.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateAvailable fFrameWin 
PROCEDURE populateAvailable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE BUFFER bgsc_deploy_dataset FOR gsc_deploy_dataset.
  DEFINE BUFFER bttDSAvailable FOR ttDSAvailable.
  DEFINE BUFFER bttDSSelected  FOR ttDSSelected.

  FOR EACH bgsc_deploy_dataset NO-LOCK:
    IF CAN-FIND(bttDSSelected WHERE bttDSSelected.dataset_code = bgsc_deploy_dataset.dataset_code) THEN
      NEXT.

    FIND bttDSAvailable 
      WHERE bttDSAvailable.dataset_code = bgsc_deploy_dataset.dataset_code 
      NO-ERROR.

    IF NOT AVAILABLE(bttDSAvailable) THEN
      CREATE bttDSAvailable.

    BUFFER-COPY bgsc_deploy_dataset TO bttDSAvailable.

  END.
  
  /* Tell the recordset view to update itself. */
  publish 'updateRecordSet'.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recordSet fFrameWin 
PROCEDURE recordSet :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phSource AS HANDLE     NO-UNDO.

  RUN setDatasetSource IN phSource (THIS-PROCEDURE:HANDLE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshData fFrameWin 
PROCEDURE refreshData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  EMPTY TEMP-TABLE ttDSAvailable.
  
  /* Strictly, unnecessary, since gscddxmlp.p deletes the records in writeADOSet */
  EMPTY TEMP-TABLE ttDSSelected.

  RUN populateAvailable.

  RUN openQueries.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectRecs fFrameWin 
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
    phBrowse:SELECT-ALL() no-error.
  ELSE
    phBrowse:DESELECT-ROWS() no-error.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateDefaults fFrameWin 
PROCEDURE updateDefaults :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFileName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lFilePerRow AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.


  DEFINE VARIABLE hBrowse AS HANDLE     NO-UNDO.

  hBrowse = BROWSE brSelected:HANDLE.

  IF hBrowse:NUM-SELECTED-ROWS <= 0 THEN
    RETURN.

  IF AVAILABLE(ttDSSelected) THEN
  DO:
    ASSIGN
      cFileName   = ttDSSelected.cFileName
      lFilePerRow = ttDSSelected.lFilePerRecord
    .
  END.
  
  RUN af/obj2/gscdddsprop.w (INPUT-OUTPUT cFileName, INPUT-OUTPUT lFilePerRow). 

  IF lFilePerRow = ? THEN
    RETURN.

  REPEAT iCount = 1 TO hBrowse:NUM-SELECTED-ROWS:
    hBrowse:FETCH-SELECTED-ROW(iCount).
    ASSIGN
      ttDSSelected.cFileName = cFileName
      ttDSSelected.lFilePerRecord = lFilePerRow
    .
  END.

  hBrowse:REFRESH().
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION enableDateButtons fFrameWin 
FUNCTION enableDateButtons RETURNS LOGICAL
  ( plEnable AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE h AS HANDLE     NO-UNDO.
  h = toByDate:HANDLE IN FRAME {&FRAME-NAME}.
  DO WHILE VALID-HANDLE(h):
     IF h:NAME = ? AND h:TYPE = "BUTTON" THEN
         h:SENSITIVE = plEnable.
     h = h:NEXT-SIBLING.
  END.
  RETURN TRUE.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION openQuery fFrameWin 
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

  phQuery:QUERY-PREPARE("FOR EACH ":U + phBuffer:NAME).

  phQuery:QUERY-OPEN().

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

