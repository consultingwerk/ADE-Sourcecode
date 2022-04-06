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

&Scoped-define PROCEDURE-TYPE Static
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buRevert 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getClassDefaults sObject 
FUNCTION getClassDefaults RETURNS CHARACTER
  (pcClass      AS CHARACTER,
   pcAttributes AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD sensitizeTabsPerRow sObject 
FUNCTION sensitizeTabsPerRow RETURNS LOGICAL
  (pcTabVisualization AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAlignSensitivity sObject 
FUNCTION setAlignSensitivity RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_afspfoldrw AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buTPRDown 
     IMAGE-UP FILE "ry/img/afarrwdn.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 3.2 BY .52 TOOLTIP "Decrease image height with 1 pixel"
     BGCOLOR 8 .

DEFINE BUTTON buTPRUp 
     IMAGE-UP FILE "ry/img/afarrwup.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 3.2 BY .52 TOOLTIP "Increase image height with 1 pixel"
     BGCOLOR 8 .

DEFINE VARIABLE coDefaultMode AS CHARACTER FORMAT "X(256)":U 
     LABEL "Default startup mode" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Open","New" 
     DROP-DOWN-LIST
     SIZE 11 BY 1 TOOLTIP "Default startup mode (if launched from the 'Build' menu)" NO-UNDO.

DEFINE VARIABLE coTabVisualization AS CHARACTER FORMAT "X(256)":U INITIAL "Framework" 
     LABEL "Tab visualization" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Framework Setting","Framework",
                     "Tabs","TABS",
                     "Combo-Box","COMBO-BOX",
                     "Radio-Set","RADIO-SET"
     DROP-DOWN-LIST
     SIZE 22.8 BY 1 NO-UNDO.

DEFINE VARIABLE fiGeneralBehaviour AS CHARACTER FORMAT "X(256)":U INITIAL " Behaviour" 
      VIEW-AS TEXT 
     SIZE 81.6 BY .76
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiPropertySheet AS CHARACTER FORMAT "X(256)":U INITIAL " Property Sheet Interaction" 
      VIEW-AS TEXT 
     SIZE 81.6 BY .76
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiSmartFolder AS CHARACTER FORMAT "X(256)":U INITIAL " SmartFolder Options" 
      VIEW-AS TEXT 
     SIZE 81.6 BY .76
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiTabsPerRow AS INTEGER FORMAT ">9":U INITIAL 7 
     LABEL "Tabs per row" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE fiTabsPerRowNote AS CHARACTER FORMAT "X(256)":U INITIAL "(* Effective after restarting Container Builder)" 
      VIEW-AS TEXT 
     SIZE 45.2 BY .62 NO-UNDO.

DEFINE VARIABLE toAddPageNumber AS LOGICAL INITIAL no 
     LABEL "Append page numbers to page labels" 
     VIEW-AS TOGGLE-BOX
     SIZE 49 BY .81 TOOLTIP "When selecting objects in the Grid, reposition the Property Sheet to the object" NO-UNDO.

DEFINE VARIABLE toConfirmSave AS LOGICAL INITIAL no 
     LABEL "Confirm successful save of container" 
     VIEW-AS TOGGLE-BOX
     SIZE 49 BY .81 TOOLTIP "Set to receive confirmation on successful saving. Errors display regardless..." NO-UNDO.

DEFINE VARIABLE toDeleteFolder AS LOGICAL INITIAL no 
     LABEL "Delete SmartFolder if no more pages left" 
     VIEW-AS TOGGLE-BOX
     SIZE 43 BY .81 TOOLTIP "Set to delete the SmartFolder if all pages have been deleted" NO-UNDO.

DEFINE VARIABLE toHideSubtools AS LOGICAL INITIAL no 
     LABEL "Hide subtools instead of closing (faster)" 
     VIEW-AS TOGGLE-BOX
     SIZE 49 BY .81 TOOLTIP "Set to hide subtools instead of closing them" NO-UNDO.

DEFINE VARIABLE toIncludeTitle AS LOGICAL INITIAL no 
     LABEL "Include container title when exporting to Excel" 
     VIEW-AS TOGGLE-BOX
     SIZE 49 BY .81 TOOLTIP "Include the container's title in the export when exporting to Excel" NO-UNDO.

DEFINE VARIABLE toReposCB AS LOGICAL INITIAL no 
     LABEL "Reposition instance on property sheet select" 
     VIEW-AS TOGGLE-BOX
     SIZE 49 BY .81 TOOLTIP "When selecting objects in the Property Sheet, reposition the Grid to the object" NO-UNDO.

DEFINE VARIABLE toRepositionPT AS LOGICAL INITIAL no 
     LABEL "Select page after page template used" 
     VIEW-AS TOGGLE-BOX
     SIZE 49 BY .81 TOOLTIP "When inserting Page Instances, select page after insertion is complete" NO-UNDO.

DEFINE VARIABLE toReposPS AS LOGICAL INITIAL no 
     LABEL "Reposition property sheet on instance select" 
     VIEW-AS TOGGLE-BOX
     SIZE 49 BY .81 TOOLTIP "When selecting objects in the Grid, reposition the Property Sheet to the object" NO-UNDO.

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

DEFINE VARIABLE coGridPosition AS CHARACTER FORMAT "X(5)":U 
     LABEL "Grid position" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Left","Right" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE coRows AS CHARACTER FORMAT "9":U 
     LABEL "Rows" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "5","7","9" 
     DROP-DOWN-LIST
     SIZE 6.8 BY 1 TOOLTIP "Number of rows the grid will have" NO-UNDO.

DEFINE VARIABLE coToolbarPosition AS CHARACTER FORMAT "X(6)":U 
     LABEL "Toolbar position" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Top","Bottom","Left","Right" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE coType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Search preference" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS ".bmp / .gif",".gif / .bmp" 
     DROP-DOWN-LIST
     SIZE 18.6 BY 1 TOOLTIP "Seacrh for first image type, if not available then search for other image type" NO-UNDO.

DEFINE VARIABLE fiAlignmentGroup AS CHARACTER FORMAT "X(256)":U INITIAL " Alignment images" 
      VIEW-AS TEXT 
     SIZE 41.6 BY .76
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiAppearance AS CHARACTER FORMAT "X(256)":U INITIAL " Appearance" 
      VIEW-AS TEXT 
     SIZE 81.6 BY .76
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiAvailable AS CHARACTER FORMAT "X(256)":U 
     LABEL "Available" 
     VIEW-AS FILL-IN 
     SIZE 18.6 BY 1 TOOLTIP "Name of image to be used to indicate available grid spaces" NO-UNDO.

DEFINE VARIABLE fiBehaviour AS CHARACTER FORMAT "X(256)":U INITIAL " Behaviour" 
      VIEW-AS TEXT 
     SIZE 81.6 BY .76
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiBGColorLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Background color:" 
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

DEFINE VARIABLE fiGLColorLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Gridline color:" 
      VIEW-AS TEXT 
     SIZE 13.2 BY .62 NO-UNDO.

DEFINE VARIABLE fiGridPosition AS CHARACTER FORMAT "X(256)":U INITIAL " Grid and Toolbar layout" 
      VIEW-AS TEXT 
     SIZE 81.6 BY .76
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiImageGroup AS CHARACTER FORMAT "X(256)":U INITIAL " Image details" 
      VIEW-AS TEXT 
     SIZE 39.2 BY .76
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiImageHeight AS CHARACTER FORMAT "x(2)":U INITIAL "1" 
     LABEL "Image height" 
     VIEW-AS FILL-IN 
     SIZE 6.4 BY 1 TOOLTIP "Alignment image height (in pixels)" NO-UNDO.

DEFINE VARIABLE fiLAligned AS CHARACTER FORMAT "X(256)":U 
     LABEL "Left (Name prefix)" 
     VIEW-AS FILL-IN 
     SIZE 18.6 BY 1 TOOLTIP "Name prefix to use for left alignment image" NO-UNDO.

DEFINE VARIABLE fiNotAvailable AS CHARACTER FORMAT "X(256)":U 
     LABEL "Not available" 
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

DEFINE VARIABLE fiSelectorLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Selector color:" 
      VIEW-AS TEXT 
     SIZE 14 BY .62 NO-UNDO.

DEFINE VARIABLE fiUnknown AS CHARACTER FORMAT "X(256)":U 
     LABEL "Unknown" 
     VIEW-AS FILL-IN 
     SIZE 18.6 BY 1 TOOLTIP "Name of image to be used to indicate unknown classes" NO-UNDO.

DEFINE VARIABLE raToGrid AS LOGICAL 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Attach toolbar to grid", yes,
"Attach toolbar to instance information viewer", no
     SIZE 50 BY 1.62 NO-UNDO.

DEFINE RECTANGLE rctBGColor
     EDGE-PIXELS 0  
     SIZE 4 BY .95 TOOLTIP "Backround color of the object instance grid".

DEFINE RECTANGLE rctGLColor
     EDGE-PIXELS 0  
     SIZE 4 BY .95 TOOLTIP "Gridline color of the object instance grid".

DEFINE RECTANGLE rctSelector
     EDGE-PIXELS 0  
     SIZE 4 BY .95 TOOLTIP "Selector color in the object instance grid".

DEFINE VARIABLE toConfirmDeletion AS LOGICAL INITIAL no 
     LABEL "Confirm instance deletion" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .81 TOOLTIP "Set to prompt for confirmation when deleting instances" NO-UNDO.

DEFINE VARIABLE toCreateAlignment AS LOGICAL INITIAL no 
     LABEL "Create alignment widgets" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .81 TOOLTIP "If set, widgets indicating alignment will be created in the grid" NO-UNDO.

DEFINE VARIABLE toImageTransparent AS LOGICAL INITIAL no 
     LABEL "Transparent image background" 
     VIEW-AS TOGGLE-BOX
     SIZE 34.6 BY .81 TOOLTIP "Set to allow images to have a transparent background" NO-UNDO.

DEFINE VARIABLE toStretchToFit AS LOGICAL INITIAL no 
     LABEL "Stretch images to fit" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .81 TOOLTIP "Set to allow images to be stretched to the cell size" NO-UNDO.

DEFINE BUTTON buRevert DEFAULT 
     LABEL "&Reset to Default" 
     SIZE 20 BY 1.14 TOOLTIP "Selecting this button will restore default settings"
     BGCOLOR 8 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buRevert AT ROW 20.95 COL 67.4
    WITH 1 DOWN NO-BOX OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 88 BY 21.24.

DEFINE FRAME frGrid
     buBGUp AT ROW 9.05 COL 80.4
     toConfirmDeletion AT ROW 2.14 COL 4
     coGridPosition AT ROW 4.1 COL 19.8 COLON-ALIGNED
     raToGrid AT ROW 5.14 COL 22.2 NO-LABEL
     coToolbarPosition AT ROW 6.81 COL 19.8 COLON-ALIGNED
     coRows AT ROW 9.05 COL 46.4 COLON-ALIGNED
     toCreateAlignment AT ROW 9.19 COL 4
     coCols AT ROW 10.1 COL 46.4 COLON-ALIGNED
     toStretchToFit AT ROW 10.14 COL 4
     toImageTransparent AT ROW 11.1 COL 4
     fiPath AT ROW 13.48 COL 19.8 COLON-ALIGNED
     fiLAligned AT ROW 13.48 COL 62.6 COLON-ALIGNED
     coType AT ROW 14.52 COL 19.8 COLON-ALIGNED
     fiCAligned AT ROW 14.52 COL 62.6 COLON-ALIGNED
     fiAvailable AT ROW 15.57 COL 19.8 COLON-ALIGNED
     fiRAligned AT ROW 15.57 COL 62.6 COLON-ALIGNED
     fiNotAvailable AT ROW 16.62 COL 19.8 COLON-ALIGNED
     fiCustomSuffix AT ROW 16.62 COL 62.6 COLON-ALIGNED
     fiUnknown AT ROW 17.67 COL 19.8 COLON-ALIGNED
     fiImageHeight AT ROW 17.67 COL 62.6 COLON-ALIGNED
     buBGDown AT ROW 9.57 COL 80.4
     buDown AT ROW 18.19 COL 71.4
     buGLDown AT ROW 11.76 COL 80.4
     buGLUp AT ROW 11.24 COL 80.4
     buSelDown AT ROW 10.67 COL 80.4
     buSelUp AT ROW 10.14 COL 80.4
     buUp AT ROW 17.67 COL 71.4
     fiBehaviour AT ROW 1.24 COL 1 COLON-ALIGNED NO-LABEL
     fiGridPosition AT ROW 3.19 COL 1 COLON-ALIGNED NO-LABEL
     fiAppearance AT ROW 8.14 COL 1 COLON-ALIGNED NO-LABEL
     fiBGColorLabel AT ROW 9.24 COL 55.6 COLON-ALIGNED NO-LABEL
     fiSelectorLabel AT ROW 10.33 COL 59.4 COLON-ALIGNED NO-LABEL
     fiGLColorLabel AT ROW 11.43 COL 74.2 RIGHT-ALIGNED NO-LABEL
     fiImageGroup AT ROW 12.52 COL 1 COLON-ALIGNED NO-LABEL
     fiAlignmentGroup AT ROW 12.52 COL 41 COLON-ALIGNED NO-LABEL
     rctSelector AT ROW 10.14 COL 75.8
     rctGLColor AT ROW 11.24 COL 75.8
     rctBGColor AT ROW 9.05 COL 75.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.4 ROW 2.52 SCROLLABLE .

DEFINE FRAME frGeneral
     buTPRDown AT ROW 12.43 COL 27.8
     coDefaultMode AT ROW 2.1 COL 70.8 COLON-ALIGNED
     toDeleteFolder AT ROW 2.14 COL 4
     toConfirmSave AT ROW 3.1 COL 4
     toHideSubtools AT ROW 4.05 COL 4
     toRepositionPT AT ROW 5 COL 4
     toIncludeTitle AT ROW 5.91 COL 4
     toReposPS AT ROW 7.91 COL 4
     toReposCB AT ROW 8.86 COL 4
     coTabVisualization AT ROW 10.81 COL 19.4 COLON-ALIGNED
     fiTabsPerRow AT ROW 11.91 COL 19.4 COLON-ALIGNED
     toAddPageNumber AT ROW 13.05 COL 21.4
     buTPRUp AT ROW 11.91 COL 27.8
     fiGeneralBehaviour AT ROW 1.24 COL 1 COLON-ALIGNED NO-LABEL
     fiPropertySheet AT ROW 7 COL 1 COLON-ALIGNED NO-LABEL
     fiSmartFolder AT ROW 9.95 COL 1 COLON-ALIGNED NO-LABEL
     fiTabsPerRowNote AT ROW 12.1 COL 30.4 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.4 ROW 2.52
         SIZE 85.2 BY 17.67.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Static
   Allow: Basic,Smart
   Container Links: 
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
         HEIGHT             = 21.24
         WIDTH              = 88.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
ASSIGN FRAME frGeneral:FRAME = FRAME frMain:HANDLE
       FRAME frGrid:FRAME = FRAME frMain:HANDLE.

/* SETTINGS FOR FRAME frGeneral
                                                                        */
/* SETTINGS FOR BUTTON buTPRDown IN FRAME frGeneral
   NO-ENABLE                                                            */
ASSIGN 
       fiTabsPerRow:READ-ONLY IN FRAME frGeneral        = TRUE.

/* SETTINGS FOR FRAME frGrid
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frGrid:SCROLLABLE       = FALSE
       FRAME frGrid:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON buBGDown IN FRAME frGrid
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buDown IN FRAME frGrid
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buGLDown IN FRAME frGrid
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buSelDown IN FRAME frGrid
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX coCols IN FRAME frGrid
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX coRows IN FRAME frGrid
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiGLColorLabel IN FRAME frGrid
   ALIGN-R                                                              */
ASSIGN 
       fiImageHeight:READ-ONLY IN FRAME frGrid        = TRUE.

/* SETTINGS FOR RECTANGLE rctBGColor IN FRAME frGrid
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctGLColor IN FRAME frGrid
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctSelector IN FRAME frGrid
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME frMain
   FRAME-NAME L-To-R,COLUMNS                                            */
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

&Scoped-define SELF-NAME frMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frMain sObject
ON GO OF FRAME frMain
DO:
  RUN setProfileData.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frMain sObject
ON MIDDLE-MOUSE-DBLCLICK OF FRAME frMain
DO:
  RUN setProfileData.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frMain sObject
ON RIGHT-MOUSE-DBLCLICK OF FRAME frMain
DO:
  RUN setProfileData.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frGrid
&Scoped-define SELF-NAME buBGDown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buBGDown sObject
ON CHOOSE OF buBGDown IN FRAME frGrid
DO:
  rctBGColor:BGCOLOR = rctBGColor:BGCOLOR - 1.

  DYNAMIC-FUNCTION("evaluateIncrements":U, rctBGColor:BGCOLOR, buBGUp:HANDLE, buBGDown:HANDLE, 15, 0).
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buBGUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buBGUp sObject
ON CHOOSE OF buBGUp IN FRAME frGrid
DO:
  rctBGColor:BGCOLOR = rctBGColor:BGCOLOR + 1.

  DYNAMIC-FUNCTION("evaluateIncrements":U, rctBGColor:BGCOLOR, buBGUp:HANDLE, buBGDown:HANDLE, 15, 0).
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDown sObject
ON CHOOSE OF buDown IN FRAME frGrid
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
ON CHOOSE OF buGLDown IN FRAME frGrid
DO:
  rctGLColor:BGCOLOR = rctGLColor:BGCOLOR - 1.

  DYNAMIC-FUNCTION("evaluateIncrements":U, rctGLColor:BGCOLOR, buGLUp:HANDLE, buGLDown:HANDLE, 15, 0).
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buGLUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buGLUp sObject
ON CHOOSE OF buGLUp IN FRAME frGrid
DO:
  rctGLColor:BGCOLOR = rctGLColor:BGCOLOR + 1.

  DYNAMIC-FUNCTION("evaluateIncrements":U, rctGLColor:BGCOLOR, buGLUp:HANDLE, buGLDown:HANDLE, 15, 0).
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frMain
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


&Scoped-define FRAME-NAME frGrid
&Scoped-define SELF-NAME buSelDown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSelDown sObject
ON CHOOSE OF buSelDown IN FRAME frGrid
DO:
  rctSelector:BGCOLOR = rctSelector:BGCOLOR - 1.

  DYNAMIC-FUNCTION("evaluateIncrements":U, rctSelector:BGCOLOR, buSelUp:HANDLE, buSelDown:HANDLE, 15, 0).
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSelUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSelUp sObject
ON CHOOSE OF buSelUp IN FRAME frGrid
DO:
  rctSelector:BGCOLOR = rctSelector:BGCOLOR + 1.

  DYNAMIC-FUNCTION("evaluateIncrements":U, rctSelector:BGCOLOR, buSelUp:HANDLE, buSelDown:HANDLE, 15, 0).
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frGeneral
&Scoped-define SELF-NAME buTPRDown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buTPRDown sObject
ON CHOOSE OF buTPRDown IN FRAME frGeneral
DO:
  ASSIGN
      fiTabsPerRow
      fiTabsPerRow:SCREEN-VALUE = STRING(INTEGER(fiTabsPerRow:SCREEN-VALUE) - 1).

  DYNAMIC-FUNCTION("evaluateIncrements":U, INTEGER(fiTabsPerRow:SCREEN-VALUE), buTPRUp:HANDLE, buTPRDown:HANDLE, 10, 1).
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buTPRUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buTPRUp sObject
ON CHOOSE OF buTPRUp IN FRAME frGeneral
DO:
  ASSIGN
      fiTabsPerRow
      fiTabsPerRow:SCREEN-VALUE = STRING(INTEGER(fiTabsPerRow:SCREEN-VALUE) + 1).

  DYNAMIC-FUNCTION("evaluateIncrements":U, INTEGER(fiTabsPerRow:SCREEN-VALUE), buTPRUp:HANDLE, buTPRDown:HANDLE, 10, 1).
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frGrid
&Scoped-define SELF-NAME buUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buUp sObject
ON CHOOSE OF buUp IN FRAME frGrid
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
ON VALUE-CHANGED OF coCols IN FRAME frGrid /* Columns */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frGeneral
&Scoped-define SELF-NAME coDefaultMode
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coDefaultMode sObject
ON VALUE-CHANGED OF coDefaultMode IN FRAME frGeneral /* Default startup mode */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frGrid
&Scoped-define SELF-NAME coGridPosition
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coGridPosition sObject
ON VALUE-CHANGED OF coGridPosition IN FRAME frGrid /* Grid position */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coRows
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coRows sObject
ON VALUE-CHANGED OF coRows IN FRAME frGrid /* Rows */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frGeneral
&Scoped-define SELF-NAME coTabVisualization
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coTabVisualization sObject
ON VALUE-CHANGED OF coTabVisualization IN FRAME frGeneral /* Tab visualization */
DO:
  ASSIGN
      coTabVisualization.

  {fn    evaluateActions}.
  {fnarg sensitizeTabsPerRow coTabVisualization:SCREEN-VALUE}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frGrid
&Scoped-define SELF-NAME coToolbarPosition
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coToolbarPosition sObject
ON VALUE-CHANGED OF coToolbarPosition IN FRAME frGrid /* Toolbar position */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coType sObject
ON VALUE-CHANGED OF coType IN FRAME frGrid /* Search preference */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiAvailable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiAvailable sObject
ON VALUE-CHANGED OF fiAvailable IN FRAME frGrid /* Available */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiCAligned
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCAligned sObject
ON VALUE-CHANGED OF fiCAligned IN FRAME frGrid /* Center (Name prefix) */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiCustomSuffix
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCustomSuffix sObject
ON VALUE-CHANGED OF fiCustomSuffix IN FRAME frGrid /* Customization Suffix */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiLAligned
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiLAligned sObject
ON VALUE-CHANGED OF fiLAligned IN FRAME frGrid /* Left (Name prefix) */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiNotAvailable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiNotAvailable sObject
ON VALUE-CHANGED OF fiNotAvailable IN FRAME frGrid /* Not available */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiPath
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiPath sObject
ON VALUE-CHANGED OF fiPath IN FRAME frGrid /* Path */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiRAligned
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiRAligned sObject
ON VALUE-CHANGED OF fiRAligned IN FRAME frGrid /* Right (Name prefix) */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiUnknown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiUnknown sObject
ON VALUE-CHANGED OF fiUnknown IN FRAME frGrid /* Unknown */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME raToGrid
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL raToGrid sObject
ON VALUE-CHANGED OF raToGrid IN FRAME frGrid
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frGeneral
&Scoped-define SELF-NAME toAddPageNumber
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toAddPageNumber sObject
ON VALUE-CHANGED OF toAddPageNumber IN FRAME frGeneral /* Append page numbers to page labels */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frGrid
&Scoped-define SELF-NAME toConfirmDeletion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toConfirmDeletion sObject
ON VALUE-CHANGED OF toConfirmDeletion IN FRAME frGrid /* Confirm instance deletion */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frGeneral
&Scoped-define SELF-NAME toConfirmSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toConfirmSave sObject
ON VALUE-CHANGED OF toConfirmSave IN FRAME frGeneral /* Confirm successful save of container */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frGrid
&Scoped-define SELF-NAME toCreateAlignment
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toCreateAlignment sObject
ON VALUE-CHANGED OF toCreateAlignment IN FRAME frGrid /* Create alignment widgets */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
  DYNAMIC-FUNCTION("setAlignSensitivity":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frGeneral
&Scoped-define SELF-NAME toDeleteFolder
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toDeleteFolder sObject
ON VALUE-CHANGED OF toDeleteFolder IN FRAME frGeneral /* Delete SmartFolder if no more pages left */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toHideSubtools
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toHideSubtools sObject
ON VALUE-CHANGED OF toHideSubtools IN FRAME frGeneral /* Hide subtools instead of closing (faster) */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frGrid
&Scoped-define SELF-NAME toImageTransparent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toImageTransparent sObject
ON VALUE-CHANGED OF toImageTransparent IN FRAME frGrid /* Transparent image background */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frGeneral
&Scoped-define SELF-NAME toIncludeTitle
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toIncludeTitle sObject
ON VALUE-CHANGED OF toIncludeTitle IN FRAME frGeneral /* Include container title when exporting to Excel */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toReposCB
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toReposCB sObject
ON VALUE-CHANGED OF toReposCB IN FRAME frGeneral /* Reposition instance on property sheet select */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toRepositionPT
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toRepositionPT sObject
ON VALUE-CHANGED OF toRepositionPT IN FRAME frGeneral /* Select page after page template used */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toReposPS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toReposPS sObject
ON VALUE-CHANGED OF toReposPS IN FRAME frGeneral /* Reposition property sheet on instance select */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frGrid
&Scoped-define SELF-NAME toStretchToFit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toStretchToFit sObject
ON VALUE-CHANGED OF toStretchToFit IN FRAME frGrid /* Stretch images to fit */
DO:
  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frMain
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects sObject  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage: 

    WHEN 0 THEN DO:
       RUN constructObject (
             INPUT  'af/sup2/afspfoldrw.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FolderLabels':U + '&General|G&rid' + 'TabFGcolor':U + 'Default|Default' + 'TabBGcolor':U + 'Default|Default' + 'TabINColor':U + 'GrayText|GrayText' + 'ImageEnabled':U + '' + 'ImageDisabled':U + '' + 'Hotkey':U + '' + 'Tooltip':U + 'General Container Builder preferences|Grid preferences' + 'TabHidden':U + 'no|no' + 'EnableStates':U + 'All|All' + 'DisableStates':U + 'All|All' + 'VisibleRows':U + '10' + 'PanelOffset':U + '20' + 'FolderMenu':U + '' + 'TabsPerRow':U + '8' + 'TabHeight':U + '3' + 'TabFont':U + '4' + 'LabelOffset':U + '0' + 'ImageWidth':U + '0' + 'ImageHeight':U + '0' + 'ImageXOffset':U + '0' + 'ImageYOffset':U + '2' + 'TabSize':U + 'Justified' + 'SelectorFGcolor':U + 'Default' + 'SelectorBGcolor':U + 'Default' + 'SelectorFont':U + '4' + 'SelectorWidth':U + '3' + 'TabPosition':U + 'Upper' + 'MouseCursor':U + '' + 'InheritColor':U + 'no' + 'TabVisualization':U + 'TABS' + 'PopupSelectionEnabled':U + 'yes' + 'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_afspfoldrw ).
       RUN repositionObject IN h_afspfoldrw ( 1.00 , 1.00 ) NO-ERROR.
       RUN resizeObject IN h_afspfoldrw ( 19.62 , 88.00 ) NO-ERROR.

       /* Links to SmartFolder h_afspfoldrw. */
       RUN addLink ( h_afspfoldrw , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_afspfoldrw ,
             FRAME frGeneral:HANDLE , 'BEFORE':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  HIDE FRAME frGeneral.
  HIDE FRAME frGrid.
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
  DEFINE VARIABLE lTBTopOrLeft  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lTBVertical   AS LOGICAL    NO-UNDO.

  cPreferences = DYNAMIC-FUNCTION("getCurrentPrefs":U IN ghParentContainer, INPUT plGetCurrentValues).

  DO WITH FRAME frGeneral:
    ASSIGN
        toDeleteFolder:CHECKED          = ENTRY(LOOKUP("DeleteFolder":U,     cPreferences, "|":U) + 1, cPreferences, "|":U) = "yes":U /* DeleteFolder     */
        toConfirmSave:CHECKED           = ENTRY(LOOKUP("ConfirmSave":U,      cPreferences, "|":U) + 1, cPreferences, "|":U) = "yes":U /* ConfirmSave      */
        toHideSubtools:CHECKED          = ENTRY(LOOKUP("HideSubtools":U,     cPreferences, "|":U) + 1, cPreferences, "|":U) = "yes":U /* HideSubtools     */
        toIncludeTitle:CHECKED          = ENTRY(LOOKUP("IncludeTitle":U,     cPreferences, "|":U) + 1, cPreferences, "|":U) = "yes":U /* IncludeTitle     */
        toReposPS:CHECKED               = ENTRY(LOOKUP("ReposPS":U,          cPreferences, "|":U) + 1, cPreferences, "|":U) = "yes":U /* ReposPS          */
        toReposCB:CHECKED               = ENTRY(LOOKUP("ReposCB":U,          cPreferences, "|":U) + 1, cPreferences, "|":U) = "yes":U /* ReposCB          */
        toRepositionPT:CHECKED          = ENTRY(LOOKUP("RepositionPT":U,     cPreferences, "|":U) + 1, cPreferences, "|":U) = "yes":U /* RepositionPT     */
        toAddPageNumber:CHECKED         = ENTRY(LOOKUP("AddPageNumber":U,    cPreferences, "|":U) + 1, cPreferences, "|":U) = "yes":U /* RepositionPT     */
        fiTabsPerRow:SCREEN-VALUE       = ENTRY(LOOKUP("TabsPerRow":U,       cPreferences, "|":U) + 1, cPreferences, "|":U)           /* TabsPerRow       */
        coTabVisualization:SCREEN-VALUE = ENTRY(LOOKUP("TabVisualization":U, cPreferences, "|":U) + 1, cPreferences, "|":U)           /* TabVisualization */
        coDefaultMode:SCREEN-VALUE      = ENTRY(LOOKUP("DefaultMode":U,      cPreferences, "|":U) + 1, cPreferences, "|":U).          /* DefaultMode      */

    {fnarg sensitizeTabsPerRow coTabVisualization:SCREEN-VALUE}.
  END.
  
  DO WITH FRAME frGrid:
    ASSIGN
        toConfirmDeletion:CHECKED   = ENTRY(LOOKUP("ConfirmDeletion":U,  cPreferences, "|":U) + 1, cPreferences, "|":U) = "yes":U /* ConfirmDeletion     */
        toCreateAlignment:CHECKED   = ENTRY(LOOKUP("CreateAlignment":U,  cPreferences, "|":U) + 1, cPreferences, "|":U) = "yes":U /* CreateAlignment     */
        toStretchToFit:CHECKED      = ENTRY(LOOKUP("StretchToFit":U,     cPreferences, "|":U) + 1, cPreferences, "|":U) = "yes":U /* StretchToFit        */
        toImageTransparent:CHECKED  = ENTRY(LOOKUP("ImageTransparent":U, cPreferences, "|":U) + 1, cPreferences, "|":U) = "yes":U /* ImageTransparent    */
        toImageTransparent:CHECKED  = ENTRY(LOOKUP("ImageTransparent":U, cPreferences, "|":U) + 1, cPreferences, "|":U) = "yes":U /* ImageTransparent    */

        coCols:SCREEN-VALUE         = ENTRY(LOOKUP("Columns":U,          cPreferences, "|":U) + 1, cPreferences, "|":U)           /* Columns             */
        coRows:SCREEN-VALUE         = ENTRY(LOOKUP("Rows":U,             cPreferences, "|":U) + 1, cPreferences, "|":U)           /* Rows                */

        rctBGColor:BGCOLOR          = INTEGER(ENTRY(LOOKUP("BGColor":U,       cPreferences, "|":U) + 1, cPreferences, "|":U))     /* BGColor             */
        rctGLColor:BGCOLOR          = INTEGER(ENTRY(LOOKUP("GLColor":U,       cPreferences, "|":U) + 1, cPreferences, "|":U))     /* GLColor             */
        rctSelector:BGCOLOR         = INTEGER(ENTRY(LOOKUP("SelectorColor":U, cPreferences, "|":U) + 1, cPreferences, "|":U))     /* SelectorColor       */

        raToGrid:SCREEN-VALUE       = ENTRY(LOOKUP("TBToGrid":U,         cPreferences, "|":U) + 1, cPreferences, "|":U)           /* TBToGrid            */
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
        coGridPosition:SCREEN-VALUE = ENTRY(LOOKUP("GridPosition":U,     cPreferences, "|":U) + 1, cPreferences, "|":U)           /* Grid Position       */
        lTBTopOrLeft                = ENTRY(LOOKUP("TBTopOrLeft":U,      cPreferences, "|":U) + 1, cPreferences, "|":U) = "yes":U /* TBTopOrLeft         */
        lTBVertical                 = ENTRY(LOOKUP("TBVertical":U,       cPreferences, "|":U) + 1, cPreferences, "|":U) = "yes":U /* TBVertical          */
        .

    DYNAMIC-FUNCTION("evaluateIncrements":U, INTEGER(fiImageHeight:SCREEN-VALUE), buUp:HANDLE,    buDown:HANDLE,    15, 1).
    DYNAMIC-FUNCTION("evaluateIncrements":U, rctSelector:BGCOLOR,                 buSelUp:HANDLE, buSelDown:HANDLE, 15, 0).
    DYNAMIC-FUNCTION("evaluateIncrements":U, rctBGColor:BGCOLOR,                  buBGUp:HANDLE,  buBGDown:HANDLE,  15, 0).
    DYNAMIC-FUNCTION("evaluateIncrements":U, rctGLColor:BGCOLOR,                  buGLUp:HANDLE,  buGLDown:HANDLE,  15, 0).
    DYNAMIC-FUNCTION("setAlignSensitivity":U).

    DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "MODIFY":U).
    
    IF lTBVertical THEN coToolbarPosition:SCREEN-VALUE = (IF lTBTopOrLeft THEN "Left":U ELSE "Right":U).
                   ELSE coToolbarPosition:SCREEN-VALUE = (IF lTBTopOrLeft THEN "Top":U  ELSE "Bottom":U).
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
  {get ContainerToolbarSource   ghToolbarSource   ghContainerSource}.

  DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "promptAddition":U, "your preferences":U).

  SUBSCRIBE TO "takeAction":U IN ghContainerSource.

  DO WITH FRAME frGeneral:
    ASSIGN
        fiGeneralBehaviour:SCREEN-VALUE = " Behaviour"
        fiPropertySheet:SCREEN-VALUE    = " Property Sheet Interaction"
        fiSmartFolder:SCREEN-VALUE      = " SmartFolder Options".
  END.

  DO WITH FRAME frGrid:
    ASSIGN
        fiAlignmentGroup:SCREEN-VALUE   = " Alignment images"
        fiSelectorLabel:SCREEN-VALUE    = "Selector color:"
        fiGridPosition:SCREEN-VALUE     = " Grid and Toolbar layout"
        fiBGColorLabel:SCREEN-VALUE     = "Background color:"
        fiGLColorLabel:SCREEN-VALUE     = "Gridline color:"
        fiImageGroup:SCREEN-VALUE       = " Image details"
        fiAppearance:SCREEN-VALUE       = " Appearance"
        fiBehaviour:SCREEN-VALUE        = " Behaviour"
        .
  END.

  RUN postCreateObjects.
  RUN initializeObject IN h_afspfoldrw.

  ASSIGN
      FRAME frGeneral:ROW = {fn getInnerRow h_afspfoldrw}
      FRAME frGrid:ROW    = FRAME frGeneral:ROW.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN selectPage (INPUT 1).

  SUBSCRIBE TO "confirmCancel":U IN ghContainerSource.
  SUBSCRIBE TO "confirmOK":U     IN ghContainerSource.

  ENABLE ALL WITH FRAME frGeneral.
  ENABLE ALL WITH FRAME frGrid.

  ASSIGN        
      coRows:SENSITIVE IN FRAME frGrid = FALSE
      coCols:SENSITIVE IN FRAME frGrid = FALSE.

  RUN getPreferenceData (INPUT TRUE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE postCreateObjects sObject 
PROCEDURE postCreateObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hAttributeBuffer  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hClassBuffer      AS HANDLE     NO-UNDO.

  /* Fetch the repository class*/
  hClassBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN gshRepositoryManager, "SmartFolder":U).

  IF VALID-HANDLE(hClassBuffer) THEN
    hAttributeBuffer = hClassBuffer:BUFFER-FIELD("classBufferHandle":U):BUFFER-VALUE.   

  IF VALID-HANDLE(hAttributeBuffer) THEN
  DO:
    hAttributeBuffer:BUFFER-CREATE().

    {fnarg setPopupSelectionEnabled "hAttributeBuffer:BUFFER-FIELD('PopupSelectionEnabled'):BUFFER-VALUE" h_afspfoldrw}.
    {fnarg setTabVisualization      "hAttributeBuffer:BUFFER-FIELD('TabVisualization'):BUFFER-VALUE"      h_afspfoldrw}.
    {fnarg setTabPosition           "hAttributeBuffer:BUFFER-FIELD('TabPosition'):BUFFER-VALUE"           h_afspfoldrw}.

    hAttributeBuffer:BUFFER-DELETE().
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectPage sObject 
PROCEDURE selectPage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER piPageNum AS INTEGER NO-UNDO.

  RUN showCurrentPage IN h_afspfoldrw (INPUT piPageNum).

  CASE piPageNum:
    WHEN 1 THEN
    DO:
      HIDE FRAME frGrid.
      VIEW FRAME frGeneral.
    END.
    
    WHEN 2 THEN
    DO:
      HIDE FRAME frGeneral.
      VIEW FRAME frGrid.
    END.
  END CASE.

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

  DO WITH FRAME frGeneral:
    cPreferences = "DeleteFolder":U     + "|":U + TRIM(STRING(toDeleteFolder:CHECKED))          + "|":U
                 + "ConfirmSave":U      + "|":U + TRIM(STRING(toConfirmSave:CHECKED))           + "|":U
                 + "HideSubtools":U     + "|":U + TRIM(STRING(toHideSubTools:CHECKED))          + "|":U
                 + "IncludeTitle":U     + "|":U + TRIM(STRING(toIncludeTitle:CHECKED))          + "|":U
                 + "ReposPS":U          + "|":U + TRIM(STRING(toReposPS:CHECKED))               + "|":U
                 + "ReposCB":U          + "|":U + TRIM(STRING(toReposCB:CHECKED))               + "|":U
                 + "RepositionPT":U     + "|":U + TRIM(STRING(toRepositionPT:CHECKED))          + "|":U
                 + "DefaultMode":U      + "|":U + TRIM(STRING(coDefaultMode:SCREEN-VALUE))      + "|":U
                 + "AddPageNumber":U    + "|":U + TRIM(STRING(toAddPageNumber:CHECKED))         + "|":U
                 + "TabsPerRow":U       + "|":U + TRIM(STRING(fiTabsPerRow:SCREEN-VALUE))       + "|":U
                 + "TabVisualization":U + "|":U + TRIM(STRING(coTabVisualization:SCREEN-VALUE)) + "|":U.
  END.
  
  DO WITH FRAME frGrid:
    ASSIGN
        cPreferences = cPreferences
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
                     + "AlignmentHeight":U  + "|":U + TRIM(STRING(fiImageHeight:SCREEN-VALUE)) + "|":U
    
                     + "GridPosition":U     + "|":U + TRIM(coGridPosition:SCREEN-VALUE)        + "|":U
                     + "TBToGrid":U         + "|":U + TRIM(raToGrid:SCREEN-VALUE)              + "|":U
                     + "TBVertical":U       + "|":U + (IF coToolbarPosition:SCREEN-VALUE = "Left":U  OR
                                                          coToolbarPosition:SCREEN-VALUE = "Right":U THEN STRING(TRUE) ELSE STRING(FALSE)) + "|":U
                     + "TBTopOrLeft":U      + "|":U + (IF coToolbarPosition:SCREEN-VALUE = "Top":U  OR
                                                          coToolbarPosition:SCREEN-VALUE = "Left":U THEN STRING(TRUE) ELSE STRING(FALSE)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getClassDefaults sObject 
FUNCTION getClassDefaults RETURNS CHARACTER
  (pcClass      AS CHARACTER,
   pcAttributes AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAttributeValue   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDefaultValues    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCounter          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hAttributeBuffer  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hClassBuffer      AS HANDLE     NO-UNDO.

  /* Fetch the repository class*/
  hClassBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN gshRepositoryManager, pcClass).

  IF VALID-HANDLE(hClassBuffer) THEN
    hAttributeBuffer = hClassBuffer:BUFFER-FIELD("classBufferHandle":U):BUFFER-VALUE.   

  IF VALID-HANDLE(hAttributeBuffer) THEN
  DO:
    hAttributeBuffer:FIND-FIRST() NO-ERROR.

    CASE pcAttributes:
      WHEN "*":U THEN
      DO:
        DO iCounter = 1 TO hAttributeBuffer:NUM-FIELDS:
          ASSIGN
              cAttributeValue = TRIM(STRING(hAttributeBuffer:BUFFER-FIELD(iCounter):BUFFER-VALUE))
              cDefaultValues  = cDefaultValues
                              + (IF cDefaultValues = "":U THEN "":U ELSE CHR(3))
                              + hAttributeBuffer:BUFFER-FIELD(iCounter):NAME + CHR(3)
                              + (IF cAttributeValue = ? THEN "?":U ELSE cAttributeValue).
        END.
      END.
      
      OTHERWISE
      DO:
        DO iCounter = 1 TO NUM-ENTRIES(pcAttributes):
          ASSIGN
              cAttributeValue = TRIM(STRING(hAttributeBuffer:BUFFER-FIELD(ENTRY(iCounter, pcAttributes)):BUFFER-VALUE))
              cDefaultValues  = cDefaultValues
                              + (IF cDefaultValues = "":U THEN "":U ELSE CHR(3))
                              + hAttributeBuffer:BUFFER-FIELD(iCounter):NAME + CHR(3)
                              + (IF cAttributeValue = ? THEN "?":U ELSE cAttributeValue).
        END.
      END.
    END CASE.
  END.
  
  RETURN cDefaultValues.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION sensitizeTabsPerRow sObject 
FUNCTION sensitizeTabsPerRow RETURNS LOGICAL
  (pcTabVisualization AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DO WITH FRAME frGeneral:
    IF LOOKUP(pcTabVisualization, "RADIO-SET,COMBO-BOX":U) <> 0 THEN
      ASSIGN
          buTPRUp:SENSITIVE   = FALSE
          buTPRDown:SENSITIVE = FALSE.
    ELSE
      DYNAMIC-FUNCTION("evaluateIncrements":U, INTEGER(fiTabsPerRow:SCREEN-VALUE), buTPRUp:HANDLE, buTPRDown:HANDLE, 10, 1).
  END.
  
  RETURN TRUE.   /* Function return value. */

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
  DO WITH FRAME frGrid:
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

