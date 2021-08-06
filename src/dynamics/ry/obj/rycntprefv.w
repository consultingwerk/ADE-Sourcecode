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
/*---------------------------------------------------------------------------------
  File: rycntprefv.w

  Description:  Container Builder Preferences Viewer

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   09/13/2002  Author:     

  Update Notes: Created from Template rysttsimpv.w

---------------------------------------------------------------------------------*/
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

&scop object-name       rycntprefv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartObject yes

{src/adm2/globals.i}

DEFINE VARIABLE ghContainerSource AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghParentContainer AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghToolbarSource   AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buBGUp toDeleteFolder toConfirmSave ~
toHideSubtools toIncludeTitle toReposPS toReposCB toConfirmDeletion ~
toCreateAlignment toStretchToFit toImageTransparent fiPath coType ~
fiAvailable fiNotAvailable fiUnknown fiLAligned fiCAligned fiRAligned ~
fiCustomSuffix fiImageHeight buGLUp buRevert coDefaultMode buSelUp buUp ~
fiGridGroup fiImageGroup fiAlignmentGroup fiBGColorLabel fiSelectorLabel ~
fiGLColorLabel 
&Scoped-Define DISPLAYED-OBJECTS toDeleteFolder toConfirmSave ~
toHideSubtools toIncludeTitle toReposPS toReposCB toConfirmDeletion ~
toCreateAlignment toStretchToFit toImageTransparent fiPath coType ~
fiAvailable fiNotAvailable fiUnknown coRows coCols fiLAligned fiCAligned ~
fiRAligned fiCustomSuffix fiImageHeight coDefaultMode fiGridGroup ~
fiImageGroup fiAlignmentGroup fiBGColorLabel fiSelectorLabel fiGLColorLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD evaluateActions sObject 
FUNCTION evaluateActions RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD evaluateIncrements sObject 
FUNCTION evaluateIncrements RETURNS LOGICAL
  (piValue    AS INTEGER,
   phUp       AS HANDLE,
   phDown     AS HANDLE,
   piMax      AS INTEGER,
   piMin      AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAlignSensitivity sObject 
FUNCTION setAlignSensitivity RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buBGDown 
     IMAGE-UP FILE "ry/img/afarrwdn.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 3.2 BY .52 TOOLTIP "Select to get the previous color"
     BGCOLOR 8 .

DEFINE BUTTON buBGUp 
     IMAGE-UP FILE "ry/img/afarrwup.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 3.2 BY .52 TOOLTIP "Select to get the next color"
     BGCOLOR 8 .

DEFINE BUTTON buDown 
     IMAGE-UP FILE "ry/img/afarrwdn.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 3.2 BY .52 TOOLTIP "Decrease image height with 1 pixel"
     BGCOLOR 8 .

DEFINE BUTTON buGLDown 
     IMAGE-UP FILE "ry/img/afarrwdn.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 3.2 BY .52 TOOLTIP "Select to get the previous color"
     BGCOLOR 8 .

DEFINE BUTTON buGLUp 
     IMAGE-UP FILE "ry/img/afarrwup.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 3.2 BY .52 TOOLTIP "Select to get the next color"
     BGCOLOR 8 .

DEFINE BUTTON buRevert DEFAULT 
     LABEL "&Reset to Default" 
     SIZE 20 BY 1.14 TOOLTIP "Selecting this button will restore default settings"
     BGCOLOR 8 .

DEFINE BUTTON buSelDown 
     IMAGE-UP FILE "ry/img/afarrwdn.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 3.2 BY .52 TOOLTIP "Select to get the previous color"
     BGCOLOR 8 .

DEFINE BUTTON buSelUp 
     IMAGE-UP FILE "ry/img/afarrwup.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 3.2 BY .52 TOOLTIP "Select to get the next color"
     BGCOLOR 8 .

DEFINE BUTTON buUp 
     IMAGE-UP FILE "ry/img/afarrwup.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 3.2 BY .52 TOOLTIP "Increase image height with 1 pixel"
     BGCOLOR 8 .

DEFINE VARIABLE coCols AS CHARACTER FORMAT "9":U 
     LABEL "Columns" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "1","3","5","7","9" 
     DROP-DOWN-LIST
     SIZE 6.8 BY 1 TOOLTIP "Number of columns the grid will have" NO-UNDO.

DEFINE VARIABLE coDefaultMode AS CHARACTER FORMAT "X(256)":U 
     LABEL "Default startup mode" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Open","New" 
     DROP-DOWN-LIST
     SIZE 11 BY 1 TOOLTIP "Default startup mode (if launched from the 'Build' menu)" NO-UNDO.

DEFINE VARIABLE coRows AS CHARACTER FORMAT "9":U 
     LABEL "Rows" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "5","7","9" 
     DROP-DOWN-LIST
     SIZE 6.8 BY 1 TOOLTIP "Number of rows the grid will have" NO-UNDO.

DEFINE VARIABLE coType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Search Preference" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS ".bmp / .gif",".gif / .bmp" 
     DROP-DOWN-LIST
     SIZE 18.6 BY 1 TOOLTIP "Seacrh for first image type, if not available then search for other image type" NO-UNDO.

DEFINE VARIABLE fiAlignmentGroup AS CHARACTER FORMAT "X(256)":U INITIAL " Alignment images" 
      VIEW-AS TEXT 
     SIZE 18 BY .62 NO-UNDO.

DEFINE VARIABLE fiAvailable AS CHARACTER FORMAT "X(256)":U 
     LABEL "Available" 
     VIEW-AS FILL-IN 
     SIZE 18.6 BY 1 TOOLTIP "Name of image to be used to indicate available grid spaces" NO-UNDO.

DEFINE VARIABLE fiBGColorLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Background Color:" 
      VIEW-AS TEXT 
     SIZE 17.6 BY .62 NO-UNDO.

DEFINE VARIABLE fiCAligned AS CHARACTER FORMAT "X(256)":U 
     LABEL "Center (Name prefix)" 
     VIEW-AS FILL-IN 
     SIZE 18.6 BY 1 TOOLTIP "Name prefix to use for center alignment image" NO-UNDO.

DEFINE VARIABLE fiCustomSuffix AS CHARACTER FORMAT "X(256)":U 
     LABEL "Customization Suffix" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 TOOLTIP "Image name suffix - added to prefix: Indicates master container's instances" NO-UNDO.

DEFINE VARIABLE fiGLColorLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Gridline Color:" 
      VIEW-AS TEXT 
     SIZE 13.2 BY .62 NO-UNDO.

DEFINE VARIABLE fiGridGroup AS CHARACTER FORMAT "X(256)":U INITIAL " Grid properties" 
      VIEW-AS TEXT 
     SIZE 15 BY .62 NO-UNDO.

DEFINE VARIABLE fiImageGroup AS CHARACTER FORMAT "X(256)":U INITIAL " Image details" 
      VIEW-AS TEXT 
     SIZE 13.8 BY .62 NO-UNDO.

DEFINE VARIABLE fiImageHeight AS CHARACTER FORMAT "x(2)":U INITIAL "1" 
     LABEL "Image Height" 
     VIEW-AS FILL-IN 
     SIZE 6.4 BY 1 TOOLTIP "Alignment image height (in pixels)" NO-UNDO.

DEFINE VARIABLE fiLAligned AS CHARACTER FORMAT "X(256)":U 
     LABEL "Left (Name prefix)" 
     VIEW-AS FILL-IN 
     SIZE 18.6 BY 1 TOOLTIP "Name prefix to use for left alignment image" NO-UNDO.

DEFINE VARIABLE fiNotAvailable AS CHARACTER FORMAT "X(256)":U 
     LABEL "Not Available" 
     VIEW-AS FILL-IN 
     SIZE 18.6 BY 1 TOOLTIP "Name of image to be used to indicate unavailable grid spaces" NO-UNDO.

DEFINE VARIABLE fiPath AS CHARACTER FORMAT "X(256)":U 
     LABEL "Path" 
     VIEW-AS FILL-IN 
     SIZE 18.6 BY 1 TOOLTIP "Relative path where all images for the container builder's grid can be found" NO-UNDO.

DEFINE VARIABLE fiRAligned AS CHARACTER FORMAT "X(256)":U 
     LABEL "Right (Name prefix)" 
     VIEW-AS FILL-IN 
     SIZE 18.6 BY 1 TOOLTIP "Name prefix to use for right alignment image" NO-UNDO.

DEFINE VARIABLE fiSelectorLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Selector Color:" 
      VIEW-AS TEXT 
     SIZE 14 BY .62 NO-UNDO.

DEFINE VARIABLE fiUnknown AS CHARACTER FORMAT "X(256)":U 
     LABEL "Unknown" 
     VIEW-AS FILL-IN 
     SIZE 18.6 BY 1 TOOLTIP "Name of image to be used to indicate unknown classes" NO-UNDO.

DEFINE RECTANGLE rctAlignmentImage
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 42 BY 6.05.

DEFINE RECTANGLE rctBGColor
     EDGE-PIXELS 0  
     SIZE 4 BY .95 TOOLTIP "Backround color of the object instance grid".

DEFINE RECTANGLE rctGLColor
     EDGE-PIXELS 0  
     SIZE 4 BY .95 TOOLTIP "Gridline color of the object instance grid".

DEFINE RECTANGLE rctGrid
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.2 BY 11.33.

DEFINE RECTANGLE rctImage
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 82.8 BY 6.76.

DEFINE RECTANGLE rctSelector
     EDGE-PIXELS 0  
     SIZE 4 BY .95 TOOLTIP "Selector color in the object instance grid".

DEFINE VARIABLE toConfirmDeletion AS LOGICAL INITIAL no 
     LABEL "Confirm instance deletion" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .81 TOOLTIP "Set to prompt for confirmation when deleting instances" NO-UNDO.

DEFINE VARIABLE toConfirmSave AS LOGICAL INITIAL no 
     LABEL "Confirm successful save of container" 
     VIEW-AS TOGGLE-BOX
     SIZE 49 BY .81 TOOLTIP "Set to receive confirmation on successful saving. Errors display regardless..." NO-UNDO.

DEFINE VARIABLE toCreateAlignment AS LOGICAL INITIAL no 
     LABEL "Create alignment widgets" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .81 TOOLTIP "If set, widgets indicating alignment will be created in the grid" NO-UNDO.

DEFINE VARIABLE toDeleteFolder AS LOGICAL INITIAL no 
     LABEL "Delete SmartFolder if no more pages left" 
     VIEW-AS TOGGLE-BOX
     SIZE 49 BY .81 TOOLTIP "Set to delete the SmartFolder if all pages have been deleted" NO-UNDO.

DEFINE VARIABLE toHideSubtools AS LOGICAL INITIAL no 
     LABEL "Hide subtools instead of closing (faster)" 
     VIEW-AS TOGGLE-BOX
     SIZE 49 BY .81 TOOLTIP "Set to hide subtools instead of closing them" NO-UNDO.

DEFINE VARIABLE toImageTransparent AS LOGICAL INITIAL no 
     LABEL "Transparent Image Background" 
     VIEW-AS TOGGLE-BOX
     SIZE 34.6 BY .81 TOOLTIP "Set to allow images to have a transparent background" NO-UNDO.

DEFINE VARIABLE toIncludeTitle AS LOGICAL INITIAL no 
     LABEL "Include container title when exporting to Excel" 
     VIEW-AS TOGGLE-BOX
     SIZE 49 BY .81 TOOLTIP "Set to hide subtools instead of closing them" NO-UNDO.

DEFINE VARIABLE toReposCB AS LOGICAL INITIAL no 
     LABEL "Reposition Instance on Property Sheet select" 
     VIEW-AS TOGGLE-BOX
     SIZE 49 BY .81 TOOLTIP "When selecting objects in the Property Sheet, reposition the Grid to the object" NO-UNDO.

DEFINE VARIABLE toReposPS AS LOGICAL INITIAL no 
     LABEL "Reposition Property Sheet on Instance select" 
     VIEW-AS TOGGLE-BOX
     SIZE 49 BY .81 TOOLTIP "When selecting objects in the Grid, reposition the Property Sheet to the object" NO-UNDO.

DEFINE VARIABLE toStretchToFit AS LOGICAL INITIAL no 
     LABEL "Stretch images to fit" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .81 TOOLTIP "Set to allow images to be stretched to the cell size" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buBGUp AT ROW 6.67 COL 80.8
     buBGDown AT ROW 7.19 COL 80.8
     toDeleteFolder AT ROW 1.19 COL 4
     toConfirmSave AT ROW 2.14 COL 4
     toHideSubtools AT ROW 3.1 COL 4
     toIncludeTitle AT ROW 3.95 COL 4
     toReposPS AT ROW 4.05 COL 4
     toReposCB AT ROW 5 COL 4
     toConfirmDeletion AT ROW 6.81 COL 4
     toCreateAlignment AT ROW 7.67 COL 4
     toStretchToFit AT ROW 8.52 COL 4
     toImageTransparent AT ROW 9.38 COL 4
     fiPath AT ROW 11.24 COL 20.2 COLON-ALIGNED
     coType AT ROW 12.29 COL 20.2 COLON-ALIGNED
     fiAvailable AT ROW 13.71 COL 20.2 COLON-ALIGNED
     fiNotAvailable AT ROW 14.76 COL 20.2 COLON-ALIGNED
     fiUnknown AT ROW 15.81 COL 20.2 COLON-ALIGNED
     coRows AT ROW 6.67 COL 44.6 COLON-ALIGNED
     coCols AT ROW 7.71 COL 44.6 COLON-ALIGNED
     fiLAligned AT ROW 11.52 COL 61.6 COLON-ALIGNED
     fiCAligned AT ROW 12.57 COL 61.6 COLON-ALIGNED
     fiRAligned AT ROW 13.62 COL 61.6 COLON-ALIGNED
     buDown AT ROW 16.24 COL 70.4
     fiCustomSuffix AT ROW 14.67 COL 61.6 COLON-ALIGNED
     buGLDown AT ROW 9.38 COL 80.8
     fiImageHeight AT ROW 15.71 COL 61.6 COLON-ALIGNED
     buGLUp AT ROW 8.86 COL 80.8
     buRevert AT ROW 18 COL 65
     coDefaultMode AT ROW 1.05 COL 72 COLON-ALIGNED
     buSelDown AT ROW 8.29 COL 80.8
     buSelUp AT ROW 7.76 COL 80.8
     buUp AT ROW 15.71 COL 70.4
     fiGridGroup AT ROW 6.05 COL 2.2 NO-LABEL
     fiImageGroup AT ROW 10.33 COL 1.4 COLON-ALIGNED NO-LABEL
     fiAlignmentGroup AT ROW 10.76 COL 41 COLON-ALIGNED NO-LABEL
     fiBGColorLabel AT ROW 6.86 COL 56 COLON-ALIGNED NO-LABEL
     fiSelectorLabel AT ROW 7.95 COL 59.8 COLON-ALIGNED NO-LABEL
     fiGLColorLabel AT ROW 9.05 COL 74.6 RIGHT-ALIGNED NO-LABEL
     rctGLColor AT ROW 8.86 COL 76.2
     rctSelector AT ROW 7.76 COL 76.2
     rctBGColor AT ROW 6.67 COL 76.2
     rctAlignmentImage AT ROW 11.1 COL 41.8
     rctImage AT ROW 10.67 COL 2.2
     rctGrid AT ROW 6.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
   Allow: Basic
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
         HEIGHT             = 18.14
         WIDTH              = 85.2.
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
   NOT-VISIBLE Size-to-Fit L-To-R,COLUMNS                               */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON buBGDown IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buDown IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buGLDown IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buSelDown IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX coCols IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX coRows IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiGLColorLabel IN FRAME frMain
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fiGridGroup IN FRAME frMain
   ALIGN-L                                                              */
ASSIGN 
       fiImageHeight:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR RECTANGLE rctAlignmentImage IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctBGColor IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctGLColor IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctGrid IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctImage IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctSelector IN FRAME frMain
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

&Scoped-define SELF-NAME buBGDown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buBGDown sObject
ON CHOOSE OF buBGDown IN FRAME frMain
DO:
  rctBGColor:BGCOLOR = rctBGColor:BGCOLOR - 1.

  DYNAMIC-FUNCTION("evaluateIncrements":U, rctBGColor:BGCOLOR, buBGUp:HANDLE, buBGDown:HANDLE, 15, 0).
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buBGUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buBGUp sObject
ON CHOOSE OF buBGUp IN FRAME frMain
DO:
  rctBGColor:BGCOLOR = rctBGColor:BGCOLOR + 1.

  DYNAMIC-FUNCTION("evaluateIncrements":U, rctBGColor:BGCOLOR, buBGUp:HANDLE, buBGDown:HANDLE, 15, 0).
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDown sObject
ON CHOOSE OF buDown IN FRAME frMain
DO:
  ASSIGN
      fiImageHeight
      fiImageHeight:SCREEN-VALUE = STRING(INTEGER(fiImageHeight:SCREEN-VALUE) - 1).

  DYNAMIC-FUNCTION("evaluateIncrements":U, INTEGER(fiImageHeight:SCREEN-VALUE), buUp:HANDLE, buDown:HANDLE, 15, 1).
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buGLDown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buGLDown sObject
ON CHOOSE OF buGLDown IN FRAME frMain
DO:
  rctGLColor:BGCOLOR = rctGLColor:BGCOLOR - 1.

  DYNAMIC-FUNCTION("evaluateIncrements":U, rctGLColor:BGCOLOR, buGLUp:HANDLE, buGLDown:HANDLE, 15, 0).
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buGLUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buGLUp sObject
ON CHOOSE OF buGLUp IN FRAME frMain
DO:
  rctGLColor:BGCOLOR = rctGLColor:BGCOLOR + 1.

  DYNAMIC-FUNCTION("evaluateIncrements":U, rctGLColor:BGCOLOR, buGLUp:HANDLE, buGLDown:HANDLE, 15, 0).
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRevert
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRevert sObject
ON CHOOSE OF buRevert IN FRAME frMain /* Reset to Default */
DO:
  DEFINE VARIABLE cMessage  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton   AS CHARACTER  NO-UNDO.

  cMessage = "Do you want to revert back to the default settings?":U.

  RUN askQuestion IN gshSessionManager ( INPUT cMessage,                /* messages       */
                                         INPUT "&Yes,&No":U,            /* button list    */
                                         INPUT "&No":U,                 /* default        */
                                         INPUT "&No":U,                 /* cancel         */
                                         INPUT "Revert to defaults":U,  /* title          */
                                         INPUT "":U,                    /* datatype       */
                                         INPUT "":U,                    /* format         */
                                         INPUT-OUTPUT cButton,          /* answer         */
                                         OUTPUT cButton).               /* button pressed */

  IF cButton = "&Yes":U THEN
  DO:
    RUN getPreferenceData (INPUT FALSE).
  
    DYNAMIC-FUNCTION("evaluateActions":U).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSelDown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSelDown sObject
ON CHOOSE OF buSelDown IN FRAME frMain
DO:
  rctSelector:BGCOLOR = rctSelector:BGCOLOR - 1.

  DYNAMIC-FUNCTION("evaluateIncrements":U, rctSelector:BGCOLOR, buSelUp:HANDLE, buSelDown:HANDLE, 15, 0).
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSelUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSelUp sObject
ON CHOOSE OF buSelUp IN FRAME frMain
DO:
  rctSelector:BGCOLOR = rctSelector:BGCOLOR + 1.

  DYNAMIC-FUNCTION("evaluateIncrements":U, rctSelector:BGCOLOR, buSelUp:HANDLE, buSelDown:HANDLE, 15, 0).
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buUp sObject
ON CHOOSE OF buUp IN FRAME frMain
DO:
  ASSIGN
      fiImageHeight
      fiImageHeight:SCREEN-VALUE = STRING(INTEGER(fiImageHeight:SCREEN-VALUE) + 1).

  DYNAMIC-FUNCTION("evaluateIncrements":U, INTEGER(fiImageHeight:SCREEN-VALUE), buUp:HANDLE, buDown:HANDLE, 15, 1).
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coCols
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coCols sObject
ON VALUE-CHANGED OF coCols IN FRAME frMain /* Columns */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coDefaultMode
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coDefaultMode sObject
ON VALUE-CHANGED OF coDefaultMode IN FRAME frMain /* Default startup mode */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coRows
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coRows sObject
ON VALUE-CHANGED OF coRows IN FRAME frMain /* Rows */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coType sObject
ON VALUE-CHANGED OF coType IN FRAME frMain /* Search Preference */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiAvailable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiAvailable sObject
ON VALUE-CHANGED OF fiAvailable IN FRAME frMain /* Available */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiCAligned
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCAligned sObject
ON VALUE-CHANGED OF fiCAligned IN FRAME frMain /* Center (Name prefix) */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiCustomSuffix
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCustomSuffix sObject
ON VALUE-CHANGED OF fiCustomSuffix IN FRAME frMain /* Customization Suffix */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiLAligned
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiLAligned sObject
ON VALUE-CHANGED OF fiLAligned IN FRAME frMain /* Left (Name prefix) */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiNotAvailable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiNotAvailable sObject
ON VALUE-CHANGED OF fiNotAvailable IN FRAME frMain /* Not Available */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiPath
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiPath sObject
ON VALUE-CHANGED OF fiPath IN FRAME frMain /* Path */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiRAligned
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiRAligned sObject
ON VALUE-CHANGED OF fiRAligned IN FRAME frMain /* Right (Name prefix) */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiUnknown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiUnknown sObject
ON VALUE-CHANGED OF fiUnknown IN FRAME frMain /* Unknown */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toConfirmDeletion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toConfirmDeletion sObject
ON VALUE-CHANGED OF toConfirmDeletion IN FRAME frMain /* Confirm instance deletion */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toConfirmSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toConfirmSave sObject
ON VALUE-CHANGED OF toConfirmSave IN FRAME frMain /* Confirm successful save of container */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toCreateAlignment
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toCreateAlignment sObject
ON VALUE-CHANGED OF toCreateAlignment IN FRAME frMain /* Create alignment widgets */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
  DYNAMIC-FUNCTION("setAlignSensitivity":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toDeleteFolder
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toDeleteFolder sObject
ON VALUE-CHANGED OF toDeleteFolder IN FRAME frMain /* Delete SmartFolder if no more pages left */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toHideSubtools
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toHideSubtools sObject
ON VALUE-CHANGED OF toHideSubtools IN FRAME frMain /* Hide subtools instead of closing (faster) */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toImageTransparent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toImageTransparent sObject
ON VALUE-CHANGED OF toImageTransparent IN FRAME frMain /* Transparent Image Background */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toIncludeTitle
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toIncludeTitle sObject
ON VALUE-CHANGED OF toIncludeTitle IN FRAME frMain /* Include container title when exporting to Excel */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toReposCB
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toReposCB sObject
ON VALUE-CHANGED OF toReposCB IN FRAME frMain /* Reposition Instance on Property Sheet select */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toReposPS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toReposPS sObject
ON VALUE-CHANGED OF toReposPS IN FRAME frMain /* Reposition Property Sheet on Instance select */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toStretchToFit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toStretchToFit sObject
ON VALUE-CHANGED OF toStretchToFit IN FRAME frMain /* Stretch images to fit */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE confirmCancel sObject 
PROCEDURE confirmCancel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER plError AS LOGICAL    NO-UNDO.

  RUN getPreferenceData (INPUT TRUE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE confirmOK sObject 
PROCEDURE confirmOK :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER plError AS LOGICAL    NO-UNDO.

  RUN setProfileData.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPreferenceData sObject 
PROCEDURE getPreferenceData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER plGetCurrentValues AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cPreferences  AS CHARACTER  NO-UNDO.

  cPreferences = DYNAMIC-FUNCTION("getCurrentPrefs":U IN ghParentContainer, INPUT plGetCurrentValues).

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        toDeleteFolder:CHECKED      = ENTRY(LOOKUP("DeleteFolder":U,     cPreferences, "|":U) + 1, cPreferences, "|":U) = "yes":U /* DeleteFolder        */
        toConfirmSave:CHECKED       = ENTRY(LOOKUP("ConfirmSave":U,      cPreferences, "|":U) + 1, cPreferences, "|":U) = "yes":U /* ConfirmSave         */
        toHideSubtools:CHECKED      = ENTRY(LOOKUP("HideSubtools":U,     cPreferences, "|":U) + 1, cPreferences, "|":U) = "yes":U /* HideSubtools        */
        toIncludeTitle:CHECKED      = ENTRY(LOOKUP("IncludeTitle":U,     cPreferences, "|":U) + 1, cPreferences, "|":U) = "yes":U /* IncludeTitle        */
        toReposPS:CHECKED           = ENTRY(LOOKUP("ReposPS":U,          cPreferences, "|":U) + 1, cPreferences, "|":U) = "yes":U /* ReposPS             */
        toReposCB:CHECKED           = ENTRY(LOOKUP("ReposCB":U,          cPreferences, "|":U) + 1, cPreferences, "|":U) = "yes":U /* ReposCB             */
        coDefaultMode:SCREEN-VALUE  = ENTRY(LOOKUP("DefaultMode":U,      cPreferences, "|":U) + 1, cPreferences, "|":U)           /* DefaultMode         */

        toConfirmDeletion:CHECKED   = ENTRY(LOOKUP("ConfirmDeletion":U,  cPreferences, "|":U) + 1, cPreferences, "|":U) = "yes":U /* ConfirmDeletion     */
        toCreateAlignment:CHECKED   = ENTRY(LOOKUP("CreateAlignment":U,  cPreferences, "|":U) + 1, cPreferences, "|":U) = "yes":U /* CreateAlignment     */
        toStretchToFit:CHECKED      = ENTRY(LOOKUP("StretchToFit":U,     cPreferences, "|":U) + 1, cPreferences, "|":U) = "yes":U /* StretchToFit        */
        toImageTransparent:CHECKED  = ENTRY(LOOKUP("ImageTransparent":U, cPreferences, "|":U) + 1, cPreferences, "|":U) = "yes":U /* ImageTransparent    */

        coCols:SCREEN-VALUE         = ENTRY(LOOKUP("Columns":U,          cPreferences, "|":U) + 1, cPreferences, "|":U)           /* Columns             */
        coRows:SCREEN-VALUE         = ENTRY(LOOKUP("Rows":U,             cPreferences, "|":U) + 1, cPreferences, "|":U)           /* Rows                */

        rctBGColor:BGCOLOR          = INTEGER(ENTRY(LOOKUP("BGColor":U,       cPreferences, "|":U) + 1, cPreferences, "|":U))     /* BGColor             */
        rctGLColor:BGCOLOR          = INTEGER(ENTRY(LOOKUP("GLColor":U,       cPreferences, "|":U) + 1, cPreferences, "|":U))     /* GLColor             */
        rctSelector:BGCOLOR         = INTEGER(ENTRY(LOOKUP("SelectorColor":U, cPreferences, "|":U) + 1, cPreferences, "|":U))     /* SelectorColor       */

        fiPath:SCREEN-VALUE         = ENTRY(LOOKUP("Path":U,             cPreferences, "|":U) + 1, cPreferences, "|":U)           /* Path                */
        coType:SCREEN-VALUE         = ENTRY(LOOKUP("Type":U,             cPreferences, "|":U) + 1, cPreferences, "|":U)           /* Type                */
        fiNotAvailable:SCREEN-VALUE = ENTRY(LOOKUP("ImageNotAvail":U,    cPreferences, "|":U) + 1, cPreferences, "|":U)           /* ImageNotAvail       */
        fiAvailable:SCREEN-VALUE    = ENTRY(LOOKUP("ImageAvail":U,       cPreferences, "|":U) + 1, cPreferences, "|":U)           /* ImageAvail          */
        fiUnknown:SCREEN-VALUE      = ENTRY(LOOKUP("ImageUnknown":U,     cPreferences, "|":U) + 1, cPreferences, "|":U)           /* ImageUnknown        */

        fiCustomSuffix:SCREEN-VALUE = ENTRY(LOOKUP("CustomSuffix":U,     cPreferences, "|":U) + 1, cPreferences, "|":U)           /* CustomizationSuffix */
        fiLAligned:SCREEN-VALUE     = ENTRY(LOOKUP("AlignLeft":U,        cPreferences, "|":U) + 1, cPreferences, "|":U)           /* AlignLeft           */
        fiCAligned:SCREEN-VALUE     = ENTRY(LOOKUP("AlignCenter":U,      cPreferences, "|":U) + 1, cPreferences, "|":U)           /* AlignCenter         */
        fiRAligned:SCREEN-VALUE     = ENTRY(LOOKUP("AlignRight":U,       cPreferences, "|":U) + 1, cPreferences, "|":U)           /* AlignRight          */
        fiImageHeight:SCREEN-VALUE  = ENTRY(LOOKUP("AlignmentHeight":U,  cPreferences, "|":U) + 1, cPreferences, "|":U)           /* AlignmentHeight     */
        .
    
    DYNAMIC-FUNCTION("evaluateIncrements":U, INTEGER(fiImageHeight:SCREEN-VALUE), buUp:HANDLE,    buDown:HANDLE,    15, 1).
    DYNAMIC-FUNCTION("evaluateIncrements":U, rctSelector:BGCOLOR,                 buSelUp:HANDLE, buSelDown:HANDLE, 15, 0).
    DYNAMIC-FUNCTION("evaluateIncrements":U, rctBGColor:BGCOLOR,                  buBGUp:HANDLE,  buBGDown:HANDLE,  15, 0).
    DYNAMIC-FUNCTION("evaluateIncrements":U, rctGLColor:BGCOLOR,                  buGLUp:HANDLE,  buGLDown:HANDLE,  15, 0).
    DYNAMIC-FUNCTION("setAlignSensitivity":U).

    DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "MODIFY":U).
  END.
  
  RETURN.

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

  /* Code placed here will execute PRIOR to standard behavior. */
  {get ContainerSource ghContainerSource}.
  {get ContainerSource ghParentContainer ghContainerSource}.
  {get ToolbarSource   ghToolbarSource   ghContainerSource}.

  DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "promptAddition":U, "your preferences":U).

  SUBSCRIBE TO "takeAction":U IN ghContainerSource.

  RUN SUPER.

  SUBSCRIBE TO "confirmCancel":U IN ghContainerSource.
  SUBSCRIBE TO "confirmOK":U     IN ghContainerSource.

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        fiAlignmentGroup:SCREEN-VALUE = " Alignment images"
        fiSelectorLabel:SCREEN-VALUE  = "Selector Color:":U
        fiBGColorLabel:SCREEN-VALUE   = "Background Color:":U
        fiGLColorLabel:SCREEN-VALUE   = "Gridline Color:":U
        fiImageGroup:SCREEN-VALUE     = " Image details"
        fiGridGroup:SCREEN-VALUE      = " Grid properties"
        .
  END.

  RUN getPreferenceData (INPUT TRUE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setProfileData sObject 
PROCEDURE setProfileData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPreferences  AS CHARACTER  NO-UNDO.

  DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "MODIFY":U).

  DO WITH FRAME {&FRAME-NAME}:
    cPreferences = "DeleteFolder":U     + "|":U + TRIM(STRING(toDeleteFolder:CHECKED))     + "|":U
                 + "ConfirmSave":U      + "|":U + TRIM(STRING(toConfirmSave:CHECKED))      + "|":U
                 + "HideSubtools":U     + "|":U + TRIM(STRING(toHideSubTools:CHECKED))     + "|":U
                 + "IncludeTitle":U     + "|":U + TRIM(STRING(toIncludeTitle:CHECKED))     + "|":U
                 + "ReposPS":U          + "|":U + TRIM(STRING(toReposPS:CHECKED))          + "|":U
                 + "ReposCB":U          + "|":U + TRIM(STRING(toReposCB:CHECKED))          + "|":U
                 + "DefaultMode":U      + "|":U + TRIM(STRING(coDefaultMode:SCREEN-VALUE)) + "|":U

                 + "ConfirmDeletion":U  + "|":U + TRIM(STRING(toConfirmDeletion:CHECKED))  + "|":U
                 + "CreateAlignment":U  + "|":U + TRIM(STRING(toCreateAlignment:CHECKED))  + "|":U
                 + "StretchToFit":U     + "|":U + TRIM(STRING(toStretchToFit:CHECKED))     + "|":U
                 + "ImageTransparent":U + "|":U + TRIM(STRING(toImageTransparent:CHECKED)) + "|":U

                 + "Columns":U          + "|":U + TRIM(coCols:SCREEN-VALUE)                + "|":U
                 + "Rows":U             + "|":U + TRIM(coRows:SCREEN-VALUE)                + "|":U

                 + "BGColor":U          + "|":U + TRIM(STRING(rctBGColor:BGCOLOR))         + "|":U
                 + "GLColor":U          + "|":U + TRIM(STRING(rctGLColor:BGCOLOR))         + "|":U
                 + "SelectorColor":U    + "|":U + TRIM(STRING(rctSelector:BGCOLOR))        + "|":U

                 + "Path":U             + "|":U + TRIM(fiPath:SCREEN-VALUE)                + "|":U
                 + "Type":U             + "|":U + TRIM(coType:SCREEN-VALUE)                + "|":U
                 + "ImageNotAvail":U    + "|":U + TRIM(fiNotAvailable:SCREEN-VALUE)        + "|":U
                 + "ImageAvail":U       + "|":U + TRIM(fiAvailable:SCREEN-VALUE)           + "|":U
                 + "ImageUnknown":U     + "|":U + TRIM(fiUnknown:SCREEN-VALUE)             + "|":U

                 + "CustomSuffix":U     + "|":U + TRIM(fiCustomSuffix:SCREEN-VALUE)        + "|":U
                 + "AlignLeft":U        + "|":U + TRIM(fiLAligned:SCREEN-VALUE)            + "|":U
                 + "AlignCenter":U      + "|":U + TRIM(fiCAligned:SCREEN-VALUE)            + "|":U
                 + "AlignRight":U       + "|":U + TRIM(fiRAligned:SCREEN-VALUE)            + "|":U
                 + "AlignmentHeight":U  + "|":U + TRIM(STRING(fiImageHeight:SCREEN-VALUE)).
  END.

  RUN viewHideActions IN ghToolbarSource ("txtOk,txtCancel":U, "txtExit":U).

  IF VALID-HANDLE(gshProfileManager) THEN
    RUN setProfileData IN gshProfileManager (INPUT "Window":U,        /* Profile type code      */
                                             INPUT "CBuilder":U,      /* Profile code           */
                                             INPUT "MainPreferences", /* Profile data key       */
                                             INPUT ?,                 /* Rowid of profile data  */
                                             INPUT cPreferences,      /* Profile data value     */
                                             INPUT NO,                /* Delete flag            */
                                             INPUT "PER":U).          /* Save flag (permanent)  */

  RUN processProfileData IN ghParentContainer (INPUT TRUE).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE takeAction sObject 
PROCEDURE takeAction :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcAction      AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER plErrorStatus AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcReturnValue AS CHARACTER  NO-UNDO.

  CASE pcAction:
    WHEN "cancel":U OR
    WHEN "reset":U  THEN
    DO:
      RUN confirmCancel (INPUT-OUTPUT plErrorStatus) NO-ERROR.

      ASSIGN
          plErrorStatus = ERROR-STATUS:ERROR
          pcReturnValue = (IF RETURN-VALUE = "":U AND ERROR-STATUS:GET-MESSAGE(1) = "":U THEN "":U ELSE "ERROR":U).
    END.

    WHEN "save":U THEN
    DO:
      RUN confirmOK (INPUT-OUTPUT plErrorStatus) NO-ERROR.
      
      ASSIGN
          plErrorStatus = ERROR-STATUS:ERROR
          pcReturnValue = (IF RETURN-VALUE = "":U AND ERROR-STATUS:GET-MESSAGE(1) = "":U THEN "":U ELSE "ERROR":U).
    END.
  END CASE.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION evaluateActions sObject 
FUNCTION evaluateActions RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RUN viewHideActions IN ghToolbarSource ("txtOk,txtCancel":U, "txtExit":U).

  DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "UPDATE":U).
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION evaluateIncrements sObject 
FUNCTION evaluateIncrements RETURNS LOGICAL
  (piValue    AS INTEGER,
   phUp       AS HANDLE,
   phDown     AS HANDLE,
   piMax      AS INTEGER,
   piMin      AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN  
      phUp:SENSITIVE   = NOT (piValue >= piMax)
      phDown:SENSITIVE = NOT (piValue <= piMin).

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAlignSensitivity sObject 
FUNCTION setAlignSensitivity RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        toCreateAlignment.
    
    IF NOT toCreateAlignment:CHECKED THEN
      ASSIGN
          fiCustomSuffix:SENSITIVE = FALSE
          fiLAligned:SENSITIVE     = FALSE
          fiCAligned:SENSITIVE     = FALSE
          fiRAligned:SENSITIVE     = FALSE
          buDown:SENSITIVE         = FALSE
          buUp:SENSITIVE           = FALSE.
    ELSE
    DO:
      ASSIGN
          fiCustomSuffix:SENSITIVE = TRUE
          fiLAligned:SENSITIVE     = TRUE
          fiCAligned:SENSITIVE     = TRUE
          fiRAligned:SENSITIVE     = TRUE.
  
      DYNAMIC-FUNCTION("evaluateIncrements":U, INTEGER(fiImageHeight:SCREEN-VALUE), buUp:HANDLE, buDown:HANDLE, 15, 1).
    END.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

