&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r4 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS s-object 
/***********************************************************************
* Copyright (C) 2005-2010 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/************************************************************************
  File: afspfoldrw.w

  Description: Tab Folder (Page Control) SmartObject
               From SmartPak src/adm2/folder.w

  Modified: 11/27/2001      Mark Davies (MIP)
            Force only 1 row tab - for version 2 of Dynamics 
            This change was as a result of a fix required for 
            issue #2773 - irregular tabs arrangement in a multi-page DynFold (>4)
            Changed made in _initializeObject
  Modified: 03/12/2002      Mark Davies (MIP)
            Fix for issue #4060 - tab folder + browser causes layout problems
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

&GLOBAL-DEFINE ADMClass Folder

/* Create an unnamed pool to store all the widgets created 
   by this procedure. This is a good default which assures
   that this procedure's triggers and internal procedures 
   will execute in this procedure's storage, and that proper
   cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

{af/app/aftttranslate.i}

DEFINE VARIABLE WIDGET-POOL-NAME AS CHARACTER NO-UNDO.

ASSIGN WIDGET-POOL-NAME = STRING(THIS-PROCEDURE:UNIQUE-ID) + "-POOL".

&SCOPED-DEFINE IN-WIDGET-POOL IN WIDGET-POOL WIDGET-POOL-NAME

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

&SCOPED-DEFINE ARRAY-SIZE 30

&SCOPED-DEFINE ADM-PROPERTY-DLG af/sup2/afspfoldrd.w

&SCOPED-DEFINE PROPERTY-ARRAY-LIST TabFGcolor,TabBGcolor,TabINColor,ImageEnabled,~
ImageDisabled,Hotkey,Tooltip,TabHidden,EnableStates,DisableStates

&SCOPED-DEFINE PROPERTY-BASIC-LIST VisibleRows,PanelOffset,FolderMenu,~
TabsPerRow,TabHeight,TabFont,LabelOffset,ImageWidth,ImageHeight,ImageXOffset,ImageYOffset,TabSize,~
SelectorFGcolor,SelectorBGcolor,SelectorFont,SelectorWidth,TabPosition,MouseCursor,InheritColor,TabVisualization,PopupSelectionEnabled

&SCOPED-DEFINE ADM-PROPERTY-LIST {&PROPERTY-ARRAY-LIST},{&PROPERTY-BASIC-LIST}

&GLOBAL-DEFINE xcInstanceProperties FolderLabels,{&ADM-PROPERTY-LIST}

&GLOBAL-DEFINE xcTranslatableProperties FolderLabels,{&ADM-PROPERTY-LIST}

&SCOPED-DEFINE MAX-TABS {&ARRAY-SIZE}

&SCOPED-DEFINE MAX-ROWS 10 

DEFINE VARIABLE iCurrentTab AS INTEGER NO-UNDO INITIAL ?.

DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
DEFINE VARIABLE hParent    AS HANDLE NO-UNDO.

DEFINE VARIABLE lResult as LOGICAL NO-UNDO.

DEFINE VARIABLE gdYDifference AS DECIMAL  NO-UNDO INITIAL ?.
DEFINE VARIABLE glResize      AS LOGICAL  NO-UNDO.

DEFINE VARIABLE x         AS INTEGER    NO-UNDO.
DEFINE VARIABLE y         AS INTEGER    NO-UNDO.
DEFINE VARIABLE z         AS INTEGER    NO-UNDO.
DEFINE VARIABLE sx        AS INTEGER    NO-UNDO.
DEFINE VARIABLE sy        AS INTEGER    NO-UNDO.

DEFINE VARIABLE iCurrentXPos AS INTEGER NO-UNDO.

DEFINE VARIABLE iSelectedRow   AS INTEGER NO-UNDO.
DEFINE VARIABLE iSelectedPanel AS INTEGER NO-UNDO.

DEFINE VARIABLE iNextTabPos     AS INTEGER NO-UNDO.
DEFINE VARIABLE iThisTabSize    AS INTEGER NO-UNDO.
DEFINE VARIABLE iCurrentRow     AS INTEGER NO-UNDO INITIAL 1.
DEFINE VARIABLE iPageNo         AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE iTabImageTotal  AS INTEGER NO-UNDO.
DEFINE VARIABLE iTabLabelHeight AS INTEGER NO-UNDO.
DEFINE VARIABLE iTabImageYPos   AS INTEGER NO-UNDO.

DEFINE VARIABLE lUpperTabs AS LOGICAL NO-UNDO INITIAL TRUE.

DEFINE VARIABLE iPanelCount AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE iMenuCount  AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE iRowCOunt   AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE iPanelTotal AS INTEGER NO-UNDO INITIAL 0.

DEFINE VARIABLE iPanelFrameHeight AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE iPanelFrameWidth  AS INTEGER NO-UNDO INITIAL 0.

DEFINE VARIABLE AutoSized  AS LOGICAL NO-UNDO INITIAL TRUE.
DEFINE VARIABLE Justified  AS LOGICAL NO-UNDO INITIAL FALSE.
DEFINE VARIABLE NoWarnings AS LOGICAL NO-UNDO INITIAL FALSE.

DEFINE VARIABLE iaTabsOnPanel AS INTEGER NO-UNDO EXTENT {&MAX-ROWS} INITIAL [0].

DEFINE VARIABLE iTabTotal        AS INTEGER NO-UNDO INITIAL 1.
DEFINE VARIABLE iTabCount        AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE iTabFrameHeight  AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE iTabHeightPixels AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE iTabAutoWidth    AS INTEGER NO-UNDO INITIAL 0.

/* Widgets that constitute each tab */
DEFINE VARIABLE hTabLabel AS WIDGET-HANDLE NO-UNDO EXTENT {&MAX-TABS}.
DEFINE VARIABLE hTabMain  AS WIDGET-HANDLE NO-UNDO EXTENT {&MAX-TABS}.
DEFINE VARIABLE hTabLDot  AS WIDGET-HANDLE NO-UNDO EXTENT {&MAX-TABS}.
DEFINE VARIABLE hTabRDot  AS WIDGET-HANDLE NO-UNDO EXTENT {&MAX-TABS}.
DEFINE VARIABLE hTabLWht  AS WIDGET-HANDLE NO-UNDO EXTENT {&MAX-TABS}.
DEFINE VARIABLE hTabLGry  AS WIDGET-HANDLE NO-UNDO EXTENT {&MAX-TABS}.
DEFINE VARIABLE hTabRBla  AS WIDGET-HANDLE NO-UNDO EXTENT {&MAX-TABS}.
DEFINE VARIABLE hTabRGry  AS WIDGET-HANDLE NO-UNDO EXTENT {&MAX-TABS}.
DEFINE VARIABLE hTabBGry  AS WIDGET-HANDLE NO-UNDO EXTENT {&MAX-TABS}.
DEFINE VARIABLE hTabIcon  AS WIDGET-HANDLE NO-UNDO EXTENT {&MAX-TABS}.

/* Panel Widgets */
DEFINE VARIABLE hTabFrame     AS WIDGET-HANDLE NO-UNDO EXTENT {&MAX-ROWS}.
DEFINE VARIABLE hPanelFrame   AS WIDGET-HANDLE NO-UNDO EXTENT {&MAX-ROWS}.
DEFINE VARIABLE hPanelOverlay AS WIDGET-HANDLE NO-UNDO EXTENT {&MAX-ROWS}.

/* Visual Selector Tab Stuff */
DEFINE VARIABLE hSelFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE hSelLabel AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE hSelMain  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE hSelLDot  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE hSelRDot  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE hSelLWht  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE hSelLGry  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE hSelRBla  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE hSelRGry  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE hSelIcon  AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE iSelectorFGColor AS INTEGER NO-UNDO INITIAL ?.
DEFINE VARIABLE iSelectorBGColor AS INTEGER NO-UNDO INITIAL ?.

/* Menu handles */
DEFINE VARIABLE hFolderMenu AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE hSubMenu    AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE hMenuItem   AS WIDGET-HANDLE NO-UNDO EXTENT {&MAX-TABS}.

DEFINE VARIABLE lAddFolderMenu   AS LOGICAL   NO-UNDO INITIAL TRUE.
DEFINE VARIABLE cFolderMenuLabel AS CHARACTER NO-UNDO.

DEFINE VARIABLE iaTabFGColor  AS INTEGER NO-UNDO EXTENT {&MAX-TABS} INITIAL [?].
DEFINE VARIABLE iaTabBGColor  AS INTEGER NO-UNDO EXTENT {&MAX-TABS} INITIAL [?].
DEFINE VARIABLE iaTabINColor  AS INTEGER NO-UNDO EXTENT {&MAX-TABS} INITIAL [?].
DEFINE VARIABLE iaTabXOffset  AS INTEGER NO-UNDO EXTENT {&MAX-TABS} INITIAL [0].
DEFINE VARIABLE iaTabYOffset  AS INTEGER NO-UNDO EXTENT {&MAX-TABS} INITIAL [0].
DEFINE VARIABLE iaTabXiOffset AS INTEGER NO-UNDO EXTENT {&MAX-TABS} INITIAL [0].
DEFINE VARIABLE iaTabYiOffset AS INTEGER NO-UNDO EXTENT {&MAX-TABS} INITIAL [0].

DEFINE VARIABLE laTabEnabled AS LOGICAL NO-UNDO EXTENT {&MAX-TABS} INITIAL [TRUE].
DEFINE VARIABLE laTabHidden  AS LOGICAL NO-UNDO EXTENT {&MAX-TABS} INITIAL [FALSE].

DEFINE VARIABLE caTabImage  AS CHARACTER NO-UNDO EXTENT {&MAX-TABS}.
DEFINE VARIABLE caTabiImage AS CHARACTER NO-UNDO EXTENT {&MAX-TABS}.

DEFINE VARIABLE caSavedLabel   AS CHARACTER NO-UNDO EXTENT {&MAX-TABS}.
DEFINE VARIABLE caFolderLabel  AS CHARACTER NO-UNDO EXTENT {&MAX-TABS}.
DEFINE VARIABLE caHotkey       AS CHARACTER NO-UNDO EXTENT {&MAX-TABS}.
DEFINE VARIABLE caEnableGroup  AS CHARACTER NO-UNDO EXTENT {&MAX-TABS}.
DEFINE VARIABLE caDisableGroup AS CHARACTER NO-UNDO EXTENT {&MAX-TABS}.

DEFINE VARIABLE caTooltipEnabled AS CHARACTER NO-UNDO EXTENT {&MAX-TABS}.

/* Vars to hold colour table numbers */
DEFINE VARIABLE COLOR-ButtonHilight AS INTEGER NO-UNDO INITIAL 15.
DEFINE VARIABLE COLOR-ButtonFace    AS INTEGER NO-UNDO INITIAL 8.
DEFINE VARIABLE COLOR-ButtonShadow  AS INTEGER NO-UNDO INITIAL 7.
DEFINE VARIABLE COLOR-GrayText      AS INTEGER NO-UNDO INITIAL 7.
DEFINE VARIABLE COLOR-ButtonText    AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE COLOR-XPButtonShadowDark  as INTEGER NO-UNDO.

/* Non-Array Constants/Properties */
DEFINE VARIABLE iVisibleRows   AS INTEGER NO-UNDO.
DEFINE VARIABLE iPanelOffset   AS INTEGER NO-UNDO.
DEFINE VARIABLE iTabsPerRow    AS INTEGER NO-UNDO.
DEFINE VARIABLE iTabHeight     AS INTEGER NO-UNDO.
DEFINE VARIABLE iTabFont       AS INTEGER NO-UNDO.
DEFINE VARIABLE iLabelOffset   AS INTEGER NO-UNDO.
DEFINE VARIABLE iImageWidth    AS INTEGER NO-UNDO.
DEFINE VARIABLE iImageHeight   AS INTEGER NO-UNDO.
DEFINE VARIABLE iImageXOffset  AS INTEGER NO-UNDO.
DEFINE VARIABLE iImageYOffset  AS INTEGER NO-UNDO.
DEFINE VARIABLE iSelectorFont  AS INTEGER NO-UNDO.
DEFINE VARIABLE iSelectorWidth AS INTEGER NO-UNDO.

/* Variables to hold Label / TabNumber and ObjectInitialized - Astra2 */
DEFINE VARIABLE gcPageInformation   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glHasPendingValues  AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE glTabsEnabled       AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE gcSecuredPages      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glDoNotShow         AS LOGICAL    NO-UNDO.

/* Popup menu */
DEFINE VARIABLE ghPopupMenu         AS WIDGET-HANDLE  NO-UNDO.
DEFINE VARIABLE ghMenuItems         AS WIDGET-HANDLE  NO-UNDO EXTENT {&MAX-TABS}.

/* Alternate visualization variables */
DEFINE VARIABLE ghDisplayWidget         AS WIDGET-HANDLE  NO-UNDO.
DEFINE VARIABLE gcVisualization         AS CHARACTER      NO-UNDO.
DEFINE VARIABLE glDontUpdateCurrentTab  AS LOGICAL        NO-UNDO.

&SCOPED-DEFINE TAB-PIXEL-OFFSET 3
&SCOPED-DEFINE OBJECT-SPACING 1
&SCOPED-DEFINE SELECTED-EXT-PIXEL-HEIGHT 3
&SCOPED-DEFINE TABS-ARE-AUTOSIZED Autosized
&SCOPED-DEFINE TABS-ARE-JUSTIFIED Justified
&SCOPED-DEFINE WARNINGS-ARE-SUPPRESSED NoWarnings
&SCOPED-DEFINE CONTAINER hContainer
&SCOPED-DEFINE MIN-HEIGHT-CHARS 4.0
&SCOPED-DEFINE MIN-WIDTH-CHARS 20.0

&SCOPED-DEFINE DELIMITER |

&GLOBAL-DEFINE EXCLUDE-repositionObject

DEFINE VARIABLE glPropertyValuesFetched AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glInitializing          AS LOGICAL    NO-UNDO INITIAL YES.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartFolder
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Page-Source

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME FolderFrame

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-setFolderWidgetIDs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFolderWidgetIDs Procedure
FUNCTION setFolderWidgetIDs RETURNS LOGICAL 
	(INPUT pcWidgetIDs AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFolderWidgetIDs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFolderWidgetIDs Procedure
FUNCTION getFolderWidgetIDs RETURNS CHARACTER 
	(  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD calcTabHeightPixels s-object 
FUNCTION calcTabHeightPixels RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD calcWidestLabel s-object 
FUNCTION calcWidestLabel RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD constructFolderLabels s-object 
FUNCTION constructFolderLabels RETURNS LOGICAL
  (pcFolderLabels AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDisplayWidget s-object 
FUNCTION getDisplayWidget RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInnerCol s-object 
FUNCTION getInnerCol RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInnerHeight s-object 
FUNCTION getInnerHeight RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInnerRow s-object 
FUNCTION getInnerRow RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInnerWidth s-object 
FUNCTION getInnerWidth RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNoWarnings s-object 
FUNCTION getNoWarnings RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPanelsMinWidth s-object 
FUNCTION getPanelsMinWidth RETURNS DECIMAL
    ( /**/ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTabRowHeight s-object 
FUNCTION getTabRowHeight RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTabsEnabled s-object 
FUNCTION getTabsEnabled RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNoWarnings s-object 
FUNCTION setNoWarnings RETURNS LOGICAL
  ( INPUT pNoWarnings AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME FolderFrame
    WITH 1 DOWN NO-BOX OVERLAY NO-HELP
         NO-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT X 0 Y 0
         SIZE-PIXELS 260 BY 152.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartFolder
   Compile into: af/sup2
   Allow: Basic
   Frames: 1
   Add Fields to: NEITHER
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
  CREATE WINDOW s-object ASSIGN
         HEIGHT             = 7.24
         WIDTH              = 52.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB s-object 
/* ************************* Included-Libraries *********************** */

{af/sup2/afspventil.i}
{af/sup2/afspcolour.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW s-object
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME FolderFrame
   NOT-VISIBLE                                                          */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME FolderFrame
/* Query rebuild information for FRAME FolderFrame
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME FolderFrame */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME FolderFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FolderFrame s-object
ON ENTRY OF FRAME FolderFrame
/* ANYWHERE  */
DO:
/*   IF VALID-HANDLE(FOCUS) THEN APPLY "ENTRY":U TO FOCUS. */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FolderFrame s-object
ON START-RESIZE OF FRAME FolderFrame
DO:
  ASSIGN SELF:HIDDEN = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK s-object 


/* ***************************  Main Block  *************************** */
RUN _getColours.

/* Folder-specific properties which are in the property temp-table. */
&GLOBAL-DEFINE xpFolderLabels
&GLOBAL-DEFINE xpFolderTabType
&GLOBAL-DEFINE xpTabFGcolor
&GLOBAL-DEFINE xpTabBGcolor
&GLOBAL-DEFINE xpTabINcolor
&GLOBAL-DEFINE xpImageEnabled
&GLOBAL-DEFINE xpImageDisabled
&GLOBAL-DEFINE xpFolderMenu
&GLOBAL-DEFINE xpTabSize
&GLOBAL-DEFINE xpHotkey
&GLOBAL-DEFINE xpTooltip
&GLOBAL-DEFINE xpTabHidden
&GLOBAL-DEFINE xpVisibleRows
&GLOBAL-DEFINE xpPanelOffset
&GLOBAL-DEFINE xpTabsPerRow
&GLOBAL-DEFINE xpTabHeight
&GLOBAL-DEFINE xpTabFont
&GLOBAL-DEFINE xpLabelOffset
&GLOBAL-DEFINE xpImageWidth
&GLOBAL-DEFINE xpImageHeight
&GLOBAL-DEFINE xpImageXOffset
&GLOBAL-DEFINE xpImageYOffset
&GLOBAL-DEFINE xpInheritColor
&GLOBAL-DEFINE xpSelectorFGcolor
&GLOBAL-DEFINE xpSelectorBGcolor
&GLOBAL-DEFINE xpSelectorFont
&GLOBAL-DEFINE xpSelectorHeight
&GLOBAL-DEFINE xpSelectorWidth
&GLOBAL-DEFINE xpTabPosition
&GLOBAL-DEFINE xpMouseCursor
&GLOBAL-DEFINE xpEnableStates
&GLOBAL-DEFINE xpDisableStates
&GLOBAL-DEFINE xpPageTarget         
&GLOBAL-DEFINE xpPageTargetEvents
&GLOBAL-DEFINE xpTabEnabled
&GLOBAL-DEFINE xpTabVisualization
&GLOBAL-DEFINE xpPopupSelectionEnabled
&GLOBAL-DEFINE xpFolderWidgetIDs

/* Now include the other props files which will start the ADMProps def. */
{src/adm2/visprop.i}

/* and then we add our folder property defs to that... */
&IF "{&ADM-VERSION}" = "ADM2.0"
&THEN
    FIELD FolderLabels          AS CHARACTER INIT "Label &1"
    FIELD FolderTabType         AS INTEGER INITIAL 0
    FIELD TabFGcolor            AS CHARACTER INIT "Default"
    FIELD TabBGcolor            AS CHARACTER INIT "Default" 
    FIELD TabINcolor            AS CHARACTER INIT "GrayText"
    FIELD ImageEnabled          AS CHARACTER 
    FIELD ImageDisabled         AS CHARACTER
    FIELD FolderMenu            AS CHARACTER 
    FIELD TabSize               AS CHARACTER INIT "AutoSized"
    FIELD Hotkey                AS CHARACTER
    FIELD Tooltip               AS CHARACTER
    FIELD TabHidden             AS CHARACTER INIT "No"
    FIELD VisibleRows           AS INTEGER INIT {&MAX-ROWS}
    FIELD PanelOffset           AS INTEGER INIT 20
    FIELD TabsPerRow            AS INTEGER INIT 8
    FIELD TabHeight             AS INTEGER INIT 3
    FIELD TabFont               AS INTEGER INIT 4
    FIELD LabelOffset           AS INTEGER INIT 0
    FIELD ImageWidth            AS INTEGER
    FIELD ImageHeight           AS INTEGER
    FIELD ImageXOffset          AS INTEGER
    FIELD ImageYOffset          AS INTEGER INIT 2
    FIELD InheritColor          AS LOGICAL INIT FALSE
    FIELD SelectorFGcolor       AS CHARACTER INIT "Default"
    FIELD SelectorBGcolor       AS CHARACTER INIT "Default"
    FIELD SelectorFont          AS INTEGER INIT 4
    FIELD SelectorHeight        AS INTEGER INIT 2
    FIELD SelectorWidth         AS INTEGER INIT 3
    FIELD TabPosition           AS CHARACTER INIT "Upper"
    FIELD PageTarget            AS CHARACTER 
    FIELD PageTargetEvents      AS CHARACTER INIT 'changeFolderPage,deleteFolderPage':U
    FIELD TabEnabled            AS CHARACTER INIT "Yes"
    FIELD TabVisualization      AS CHARACTER INIT "TABS":U
    FIELD FolderWidgetIDs       AS CHARACTER
    FIELD PopupSelectionEnabled AS LOGICAL   INIT TRUE
    
    {af/sup2/afspcommdf.i}

/* ... and the final period to end the definition... */
.
&ELSE
 IF NOT {&adm-props-defined} THEN
 DO:
    ghADMProps:ADD-NEW-FIELD('FolderLabels':U,          'CHAR':U,    0, ?, "Label &1":U).
    ghADMProps:ADD-NEW-FIELD('FolderTabType':U,         'INTEGER':U, 0, ?, 0).
    ghADMProps:ADD-NEW-FIELD('TabFGcolor':U,            'CHAR':U,    0, ?, "Default":U).
    ghADMProps:ADD-NEW-FIELD('TabBGcolor':U,            'CHAR':U,    0, ?, "Default":U).
    ghADMProps:ADD-NEW-FIELD('TabINcolor':U,            'CHAR':U,    0, ?, "GrayText":U).
    ghADMProps:ADD-NEW-FIELD('ImageEnabled':U,          'CHAR':U,    0, ?).
    ghADMProps:ADD-NEW-FIELD('ImageDisabled':U,         'CHAR':U,    0, ?).
    ghADMProps:ADD-NEW-FIELD('FolderMenu':U,            'CHAR':U,    0, ?).
    ghADMProps:ADD-NEW-FIELD('TabSize':U,               'CHAR':U,    0, ?, "AutoSized":U).
    ghADMProps:ADD-NEW-FIELD('Hotkey':U,                'CHAR':U,    0, ?).
    ghADMProps:ADD-NEW-FIELD('Tooltip':U,               'CHAR':U,    0, ?).
    ghADMProps:ADD-NEW-FIELD('TabHidden':U,             'CHAR':U,    0, ?, "No":U).
    ghADMProps:ADD-NEW-FIELD('VisibleRows':U,           'INTEGER':U, 0, ?, {&MAX-ROWS}).
    ghADMProps:ADD-NEW-FIELD('PanelOffset':U,           'INTEGER':U, 0, ?, 20).
    ghADMProps:ADD-NEW-FIELD('TabsPerRow':U,            'INTEGER':U, 0, ?, 8).
    ghADMProps:ADD-NEW-FIELD('TabHeight':U,             'INTEGER':U, 0, ?, 3).
    ghADMProps:ADD-NEW-FIELD('TabFont':U,               'INTEGER':U, 0, ?, 4).
    ghADMProps:ADD-NEW-FIELD('LabelOffset':U,           'INTEGER':U, 0, ?, 0).
    ghADMProps:ADD-NEW-FIELD('ImageWidth':U,            'INTEGER':U, 0, ?).
    ghADMProps:ADD-NEW-FIELD('ImageHeight':U,           'INTEGER':U, 0, ?).
    ghADMProps:ADD-NEW-FIELD('ImageXOffset':U,          'INTEGER':U, 0, ?).
    ghADMProps:ADD-NEW-FIELD('ImageYOffset':U,          'INTEGER':U, 0, ?, 2).
    ghADMProps:ADD-NEW-FIELD('InheritColor':U,          'LOGICAL':U, 0, ?, FALSE).
    ghADMProps:ADD-NEW-FIELD('SelectorFGcolor':U,       'CHAR':U,    0, ?, "Default":U).
    ghADMProps:ADD-NEW-FIELD('SelectorBGcolor':U,       'CHAR':U,    0, ?, "Default":U).
    ghADMProps:ADD-NEW-FIELD('SelectorFont':U,          'INTEGER':U, 0, ?, 4).
    ghADMProps:ADD-NEW-FIELD('SelectorHeight':U,        'INTEGER':U, 0, ?, 2).
    ghADMProps:ADD-NEW-FIELD('SelectorWidth':U,         'INTEGER':U, 0, ?, 3).
    ghADMProps:ADD-NEW-FIELD('TabPosition':U,           'CHAR':U,    0, ?, "Upper":U).
    ghADMProps:ADD-NEW-FIELD('PageTarget':U,            'CHAR':U,    0, ?).
    ghADMProps:ADD-NEW-FIELD('PageTargetEvents':U,      'CHAR':U,    0, ?, 'changeFolderPage,deleteFolderPage':U).
    ghADMProps:ADD-NEW-FIELD('TabEnabled':U,            'CHAR':U,    0, ?, "Yes":U).
    ghADMProps:ADD-NEW-FIELD('TabVisualization':U,      'CHAR':U,    0, ?, "TABS":U).
    ghADMProps:ADD-NEW-FIELD('FolderWidgetIDs':U,       'CHAR':U,    0, ?, '':U).
    ghADMProps:ADD-NEW-FIELD('PopupSelectionEnabled':U, 'LOGICAL':U, 0, ?, "yes":U).
    {af/sup2/afspcommdf.i}
  END.
&ENDIF

/* Now include out parent class file for visual objects. */
{src/adm2/visual.i}

/* Include get/set functions for properties */
{af/sup2/affoldprop.i}

/* Include user-defined folder functions */
{af/sup2/afspfoldrw.i}

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
   RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */ 
&IF DEFINED(EXCLUDE-assignPanelWidgetIDs) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignPanelWidgetIDs Procedure
PROCEDURE assignPanelWidgetIDs:
/*------------------------------------------------------------------------------
    Purpose:
    Parameters: <none>
    Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER piFrameWidgetID  AS INTEGER    NO-UNDO.
DEFINE INPUT  PARAMETER phPanelFrame     AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER phFrameTabs      AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER phPanelText      AS HANDLE     NO-UNDO.

DEFINE VARIABLE iWidgetID   AS INTEGER    NO-UNDO.

ASSIGN iWidgetID = iPanelCount * 2 + 30.
IF iWidgetID LE 65534 AND VALID-HANDLE(phPanelFrame) THEN
   ASSIGN phPanelFrame:WIDGET-ID = iWidgetID NO-ERROR.

ASSIGN iWidgetID = piFrameWidgetID + iPanelCount * 100.
IF iWidgetID LE 65534 AND VALID-HANDLE(phFrameTabs) THEN
   ASSIGN phFrameTabs:WIDGET-ID = iWidgetID NO-ERROR.

IF gcVisualization NE "TABS":U THEN
   ASSIGN ghDisplayWidget:WIDGET-ID = 70 NO-ERROR.

ASSIGN phPanelText:WIDGET-ID = 8 NO-ERROR.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF 
&IF DEFINED(EXCLUDE-assignFolderWidgetIDs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignFolderWidgetIDs Procedure
PROCEDURE assignWidgetIDs:
/*---------------------------------------------------------------------------------
    Purpose: Assigns widget-ids for the fill-ins and text widgets created
             dynamically for each page.

    Parameters: piPage: Page number in which the widgets are being created.

    Notes: In order to avoid performance loses at runtime, we run this procedure
           only if the -usewidgetid session parameter is being used. For that
           reason we do not assign the widget-ids for the widgets in
           create-folder-page, in which they are created; instead create-folder-page
           calls this procedure only if -usewidgetid is being used.
---------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER piPage AS INTEGER    NO-UNDO.
DEFINE INPUT PARAMETER phText AS HANDLE     NO-UNDO.

DEFINE VARIABLE cPages        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iPageWidgetID AS INTEGER    NO-UNDO.

{get FolderWidgetIDs cPages}.

IF cPages = "":U OR cPages = ? THEN RETURN.

ASSIGN iPageWidgetID = INT(ENTRY(piPage, cPages)) NO-ERROR.

IF ERROR-STATUS:ERROR THEN RETURN.

IF gcVisualization NE "TABS":U THEN
ASSIGN iPageWidgetID = iPageWidgetID + hTabMain[piPage]:FRAME:WIDGET-ID.

ASSIGN hTabMain[piPage]:WIDGET-ID = iPageWidgetID + 2
       hTabLWht[piPage]:WIDGET-ID = iPageWidgetID + 4
       hTabLGry[piPage]:WIDGET-ID = iPageWidgetID + 6
       hTabLDot[piPage]:WIDGET-ID = iPageWidgetID + 8
       hTabRDot[piPage]:WIDGET-ID = iPageWidgetID + 10
       hTabRGry[piPage]:WIDGET-ID = iPageWidgetID + 12
       hTabRBla[piPage]:WIDGET-ID = iPageWidgetID + 14
       phText:WIDGET-ID           = iPageWidgetID + 16.
RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeFolderLabel s-object 
PROCEDURE changeFolderLabel :
/*------------------------------------------------------------------------------
  Purpose:     Change the label on a tab
  Parameters:  Tab number (ordinal), new label
  Notes:       This does not affect the tab size
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER TAB-NUMBER AS INTEGER    NO-UNDO.
  DEFINE INPUT PARAMETER TAB-LABEL  AS CHARACTER  NO-UNDO.

  IF TAB-NUMBER <= iTabCount THEN
  DO:
    ASSIGN
        TAB-LABEL                          = TRIM(TAB-LABEL)
        caFolderLabel[TAB-NUMBER]          = " ":U + TAB-LABEL
        hTabLabel[TAB-NUMBER]:SCREEN-VALUE = caFolderLabel[TAB-NUMBER].

    IF hMenuItem[TAB-NUMBER]:TYPE = "MENU-ITEM":U THEN
      hMenuItem[TAB-NUMBER]:LABEL = TAB-LABEL.

    IF iCurrentTab = TAB-NUMBER THEN 
      hSelLabel:SCREEN-VALUE = caFolderLabel[TAB-NUMBER].
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeFolderPage s-object 
PROCEDURE changeFolderPage :
/*------------------------------------------------------------------------------
  Purpose:     AppBuilder support procedure to select a page.
  Parameters:  <none>
  Notes:       When the page of the container changes, this ensures the tabs
               is also changed.
------------------------------------------------------------------------------*/
  IF VALID-HANDLE(hSelFrame) THEN 
    hSelFrame:HIDDEN = IF gcVisualization = "TABS":U THEN TRUE ELSE FALSE NO-ERROR.
  
  IF VALID-HANDLE({&CONTAINER}) THEN 
    {get CurrentPage iPageNo {&CONTAINER}}.
  
  iPageNo = IF UIBMode() THEN MAXIMUM(1,iPageNo) ELSE iPageNo.

  IF iPageNo > 0 AND iPageNo <= iTabTotal AND VALID-HANDLE(hTabLabel[iPageNo]) THEN
    RUN _SelectTab(iPageNo).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE create-folder-page s-object 
PROCEDURE create-folder-page :
/*------------------------------------------------------------------------------
  Purpose:     Create a new tab after initialization or modify an existing label
  Parameters:  Page No, Label Text
  Notes:       Provided for backward compatibility only. Not recommended for 
               multiple rows tab folders.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pPageNo AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER pLabel  AS CHARACTER NO-UNDO.

DEFINE VARIABLE cFolderLabels AS CHARACTER NO-UNDO.

IF pPageNo > {&MAX-TABS} 
THEN DO:
    MESSAGE "Too many tabs. Current maximum is {&MAX-TABS}."
        VIEW-AS ALERT-BOX WARNING TITLE "Tab Folder".
    RETURN.
END.

ASSIGN cFolderLabels = getFolderLabels().

/* If adding a tab beyond the current set, adds as many place holders as required.
   These will appears as tabs with no-labels.
*/   
IF pPageNo > iTabTotal
THEN DO:
    ASSIGN cFolderLabels = cFolderLabels + FILL("{&DELIMITER}":U,pPageNo - iTabTotal)
           ENTRY(pPageno,cFolderLabels,"{&DELIMITER}":U) = pLabel
           NO-ERROR.
    setFolderLabels(cFolderLabels).

    IF NOT ERROR-STATUS:ERROR
    THEN DO:
        iTabTotal = iTabTotal + 1.
        RUN _initializeObject.
        hTabLabel[pPageno]:SCREEN-VALUE = pLabel.
    END.
END.
ELSE IF VALID-HANDLE(hTabLabel[pPageNo])
THEN DO:
    ASSIGN hTabLabel[pPageno]:SCREEN-VALUE = pLabel
           ENTRY(pPageno,cFolderLabels,"{&DELIMITER}":U) = pLabel
           NO-ERROR.

    setFolderLabels(cFolderLabels).

    IF pPageNo = iCurrentTab 
    THEN
        ASSIGN hSelLabel:SCREEN-VALUE = pLabel.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteFolderPage s-object 
PROCEDURE deleteFolderPage :
/*------------------------------------------------------------------------------
  Purpose:     Deletes a Tab for a page
  Parameters:  Tab/Page Number
  Notes:       Deleting a page means that all tabs that appear AFTER this tab
               will select page numbers 1 less than they previously selected. 
               Provided for backward compatibility only. Not supported when
               FolderTabType = 0. Use disableFolderPage instead.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pPageNo AS INTEGER NO-UNDO.

DEFINE VARIABLE cFolderLabels AS CHARACTER NO-UNDO.

DEFINE VARIABLE iCount AS INTEGER NO-UNDO.

IF getFolderTabType() = 0
THEN DO:
    MESSAGE "Method 'deleteFolderPage' is not supported in this version of"
            "Astra Tab Folder control."
        VIEW-AS ALERT-BOX INFORMATION TITLE "Tab Folder".
    RETURN.
END.

IF pPageNo <= iTabTotal
THEN DO:
    /* Remove the specified tab */
    DO iCount = 1 TO iTabTotal:

        IF iCount = pPageNo THEN NEXT.

        ASSIGN cFolderLabels = IF cFolderLabels = "" 
                               THEN ENTRY(iCount,getFolderLabels(),"{&DELIMITER}":U)
                               ELSE cFolderLabels + "{&DELIMITER}":U + ENTRY(iCount,getFolderLabels(),"{&DELIMITER}":U).
    END.

    /* Re-initialize */
    setFolderLabels(cFolderLabels).

    RUN _initializeObject.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject s-object 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:   Override to delete the named widget-pool created in 
             _initializeObject  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DELETE WIDGET-POOL WIDGET-POOL-NAME NO-ERROR.
  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableFolderGroup s-object 
PROCEDURE disableFolderGroup :
/*------------------------------------------------------------------------------
  Purpose:     Enables Tabs with matching Disable states
  Parameters:  State Value
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER ip-group AS CHARACTER NO-UNDO.

DO z = 1 TO iTabCount:
    IF CAN-DO(caDisableGroup[z],ip-group) THEN RUN disableFolderPage(z).    
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableFolderPage s-object 
PROCEDURE disableFolderPage :
/*------------------------------------------------------------------------------
  Purpose:     Disable a Tab - make it non-selectable
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER iTabCount AS INTEGER NO-UNDO.

  IF VALID-HANDLE(hTabLabel[iTabCount]) THEN
  DO:
    ASSIGN
        hTabLabel[iTabCount]:SENSITIVE = FALSE
        hTabLabel[iTabCount]:FGCOLOR   = IF iaTabINColor[iTabCount] = ? THEN COLOR-ButtonShadow ELSE iaTabINColor[iTabCount]
        hMenuItem[iTabCount]:SENSITIVE = FALSE
        laTabEnabled[iTabCount]        = FALSE
        hTabLabel[iTabCount]:TOOLTIP   = "":U.

    IF VALID-HANDLE(hTabIcon[iTabCount]) THEN
      ASSIGN
          lResult = hTabIcon[iTabCount]:LOAD-IMAGE(caTabiImage[iTabCount],iaTabXiOffset[iTabCount],iaTabYiOffset[iTabCount],iImageWidth,iImageHeight) 
          hTabIcon[iTabCount]:SENSITIVE = FALSE NO-ERROR.

    hSelFrame:HIDDEN = iTabCount = iCurrentTab OR hSelFrame:HIDDEN.
  END.
  ELSE
    laTabEnabled[iTabCount] = FALSE.

  CASE gcVisualization:
    WHEN "COMBO-BOX":U THEN
      IF VALID-HANDLE(ghDisplayWidget) THEN
        RUN _createAlternateSelectors.
    
    WHEN "RADIO-SET":U THEN
      IF VALID-HANDLE(ghDisplayWidget) THEN
        ghDisplayWidget:DISABLE(ENTRY(LOOKUP(STRING(iTabCount), ghDisplayWidget:RADIO-BUTTONS, "{&DELIMITER}":U) - 1, ghDisplayWidget:RADIO-BUTTONS, "{&DELIMITER}":U)).
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disablePages s-object 
PROCEDURE disablePages :

/*------------------------------------------------------------------------------
  Purpose:     Astra2 procedure to disable specified tab(s)

  Parameters:  INPUT pcPageInformation - Comma delimited list of page numbers or
                                         page labels (can be mixed) of pages / tabs
                                         to disable

               OUTPUT plPending - Logical parameter to indicate if disabling the
                                  tabs are still pending
  Notes:       if first entry in page information is security, then the pages
               must be disabled permanently. This is setup in containrcustom.p
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcPageInformation AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER plPending         AS LOGICAL   NO-UNDO.

  DEFINE VARIABLE cCurrentEntry     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lCurrentDisabled  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iTabNumber        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCounter          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEntry            AS INTEGER    NO-UNDO.

  IF pcPageInformation <> "":U AND ENTRY(1,pcPageInformation) = "security":U THEN
    ASSIGN
      pcPageInformation = REPLACE(pcPageInformation,"Security,":U,"":U)
      gcSecuredPages = pcPageInformation.

  /* Check to see if folder has been initialized */
  IF VALID-HANDLE(hTabLabel[1]) THEN
  DO:
    ASSIGN lCurrentDisabled = FALSE.

    DO iEntry = 1 TO NUM-ENTRIES(pcPageInformation):
      ASSIGN
          cCurrentEntry = ENTRY(iEntry, pcPageInformation).

      /* Check if tab number has been specified */
      ASSIGN
          iTabNumber = INTEGER(cCurrentEntry) NO-ERROR.

      /* Tab label was specified */
      IF ERROR-STATUS:ERROR = TRUE THEN
      DO:
        ERROR-STATUS:ERROR = FALSE.

        ASSIGN
            cCurrentEntry = TRIM(TRIM(cCurrentEntry, "&":U))  /* Remove '&', leading and trailing spaces. */
            iTabNumber    = 0.

        DO iCounter = 1 TO {&MAX-TABS}:

          IF cCurrentEntry = TRIM(TRIM(caFolderLabel[iCounter], "&":U)) THEN
            ASSIGN
                iTabNumber = iCounter.

          IF iTabNumber <> 0 THEN LEAVE.
        END.

        IF iTabNumber = 0 THEN
        DO iCounter = 1 TO {&MAX-TABS}:

          IF cCurrentEntry = TRIM(TRIM(caSavedLabel[iCounter], "&":U)) THEN
            ASSIGN
                iTabNumber = iCounter.

          IF iTabNumber <> 0 THEN LEAVE.
        END.


      END.

      /* There is a valid tab to disable */
      IF iTabNumber <> 0 AND
         iTabNumber <> ? THEN DO:

        /* If the current tab gets disabled, set the variable */
        IF iCurrentTab = iTabNumber THEN
          ASSIGN
              lCurrentDisabled = TRUE.

        RUN disableFolderPage(INPUT iTabNumber). /* Disable the tab */

      END.
    END.

    ASSIGN plPending = FALSE.

    /* Now check to see if the current page is disabled. If it is, then move to
       the first enabled tab, else put in view mode. */
    IF lCurrentDisabled = TRUE THEN
    DO:
      ASSIGN
          iTabNumber = 0.

      /* Find the first enabled tab */
      DO iCounter = 1 TO {&MAX-TABS}:
        IF VALID-HANDLE(hTabLabel[iCounter])    AND
           hTabLabel[iCounter]:SENSITIVE = TRUE THEN
          ASSIGN
              iTabNumber = iCounter.

        IF iTabNumber <> 0 THEN LEAVE.
      END.

      IF iTabNumber <> 0 THEN
      DO:
        /* Select the tab */
        ASSIGN
            iCurrentTab = iTabNumber
            glTabsEnabled = YES.

        RUN selectPage IN hContainer (iTabNumber).
      END.
      ELSE
      DO:
        /* Put folder in view mode as no enabled tabs. Also set button sensitivity 
           to prevent changing mode.
        */
        DYNAMIC-FUNCTION("setContainerMode":U IN hContainer, "View":U).
        ASSIGN glTabsEnabled = NO.
      END.
    END.

  END.
  ELSE  /* Folder not yet initialized */
    ASSIGN glHasPendingValues = TRUE
           plPending          = TRUE
           gcPageInformation  = pcPageInformation.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI s-object  _DEFAULT-DISABLE
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
  HIDE FRAME FolderFrame.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFolderGroup s-object 
PROCEDURE enableFolderGroup :
/*------------------------------------------------------------------------------
  Purpose:     Enables Tabs with matching Enable states
  Parameters:  State Value
  Notes:         
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER ip-group AS CHARACTER NO-UNDO.

DO z = 1 TO iTabCount:
    IF CAN-DO(caEnableGroup[z],ip-group) THEN RUN enableFolderPage(z).    
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFolderPage s-object 
PROCEDURE enableFolderPage :
/*------------------------------------------------------------------------------
  Purpose:     Enables a TAB for selection
  Parameters:  Tab Number
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER iTabCount AS INTEGER NO-UNDO.

  IF gcSecuredPages <> "":U AND LOOKUP(STRING(iTabCount), gcSecuredPages) <> 0 THEN RETURN.

  IF VALID-HANDLE(hTabLabel[iTabCount]) THEN
  DO:
    ASSIGN
        hTabLabel[iTabCount]:SENSITIVE = NOT UIBMode()
        hTabLabel[iTabCount]:FGCOLOR   = iaTabFGColor[iTabCount]
        hMenuItem[iTabCount]:SENSITIVE = hTabLabel[iTabCount]:SENSITIVE
        laTabEnabled[iTabCount]        = TRUE
        hTabLabel[iTabCount]:TOOLTIP   = caTooltipEnabled[iTabCount].

    IF VALID-HANDLE(hTabIcon[iTabCount]) THEN 
      ASSIGN
          hTabIcon[iTabCount]:SENSITIVE = hTabLabel[iTabCount]:SENSITIVE
          lResult = hTabIcon[iTabCount]:LOAD-IMAGE(caTabImage[iTabCount],iaTabXOffset[iTabCount],iaTabYOffset[iTabCount],iImageWidth,iImageHeight) NO-ERROR.

    /*IF iTabCount = iCurrentTab THEN RUN _selectTab(iTabCount).*/
  END.
  ELSE
    laTabEnabled[iTabCount] = TRUE.

  CASE gcVisualization:
    WHEN "COMBO-BOX":U THEN
      IF VALID-HANDLE(ghDisplayWidget) THEN
        RUN _createAlternateSelectors.
    
    WHEN "RADIO-SET":U THEN
      IF VALID-HANDLE(ghDisplayWidget) THEN
        ghDisplayWidget:ENABLE(ENTRY(LOOKUP(STRING(iTabCount), ghDisplayWidget:RADIO-BUTTONS, "{&DELIMITER}":U) - 1, ghDisplayWidget:RADIO-BUTTONS, "{&DELIMITER}":U)).
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enablePages s-object 
PROCEDURE enablePages :
/*------------------------------------------------------------------------------
  Purpose:     Astra2 procedure to enable specified tab(s)

  Parameters:  INPUT pcPageInformation - Comma delimited list of page numbers or
                                         page labels (can be mixed) of pages / tabs
                                         to enable. Can be in any order...

               OUTPUT plPending - Logical parameter to indicate if enabling the
                                  tabs are still pending
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcPageInformation AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER plPending         AS LOGICAL   NO-UNDO.

  DEFINE VARIABLE cCurrentEntry AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTabNumber    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCounter      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEntry        AS INTEGER    NO-UNDO.

  /* Check to see if folder has been initialized */
  IF VALID-HANDLE(hTabLabel[1]) THEN
  DO:
    DO iEntry = 1 TO NUM-ENTRIES(pcPageInformation):
      ASSIGN
          cCurrentEntry = ENTRY(iEntry, pcPageInformation).

      /* Check if tab number has been specified */
      ASSIGN
          iTabNumber = INTEGER(cCurrentEntry) NO-ERROR.

      /* Tab label was specified */
      IF ERROR-STATUS:ERROR = TRUE THEN
      DO:
        ERROR-STATUS:ERROR = FALSE.

        ASSIGN
            cCurrentEntry = TRIM(TRIM(cCurrentEntry, "&":U))  /* Remove '&', leading and trailing spaces. */
            iTabNumber    = 0.

        DO iCounter = 1 TO {&MAX-TABS}:

          IF cCurrentEntry = TRIM(TRIM(caFolderLabel[iCounter], "&":U)) THEN
            ASSIGN
                iTabNumber = iCounter.

          IF iTabNumber <> 0 THEN LEAVE.
        END.

        IF iTabNumber = 0 THEN
        DO iCounter = 1 TO {&MAX-TABS}:

          IF cCurrentEntry = TRIM(TRIM(caSavedLabel[iCounter], "&":U)) THEN
            ASSIGN
                iTabNumber = iCounter.

          IF iTabNumber <> 0 THEN LEAVE.
        END.

      END.

      /* There is a valid tab to enable */
      IF iTabNumber <> 0 AND
         iTabNumber <> ? THEN DO:

        RUN enableFolderPage(INPUT iTabNumber).

        ASSIGN glTabsEnabled = YES.
      END.
    END.

    ASSIGN plPending = FALSE.
  END.
  ELSE  /* Folder not yet initialized */
    ASSIGN glHasPendingValues = TRUE
           plPending          = TRUE
           gcPageInformation  = pcPageInformation.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getClientRectangle s-object 
PROCEDURE getClientRectangle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       If hContainer is a valid-handle, it means the object has been
               initialized
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pdColumn  AS DECIMAL NO-UNDO.
  DEFINE OUTPUT PARAMETER pdRow     AS DECIMAL NO-UNDO.
  DEFINE OUTPUT PARAMETER pdWidth   AS DECIMAL NO-UNDO.
  DEFINE OUTPUT PARAMETER pdHeight  AS DECIMAL NO-UNDO.

  /* Calculate the Row, Column, Height and Width */
  ASSIGN 
      pdRow    = getInnerRow()                    + 0.12 /* The row is important in determining where the objects under the tabs need to be positioned */
      pdColumn = FRAME {&FRAME-NAME}:COLUMN       + 0.9.
      pdWidth  = FRAME {&FRAME-NAME}:WIDTH-CHARS  - 1.8.
      pdHeight = FRAME {&FRAME-NAME}:HEIGHT-CHARS - getTabRowHeight() - 0.24.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject s-object 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCurrentPage  AS INTEGER    NO-UNDO INITIAL ?.

  RUN SUPER.
     
  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN hContainer  = WIDGET-HANDLE(DYNAMIC-FUNCTION('linkHandles':U, 'Container-Source':U))

         hParent     = IF VALID-HANDLE(FRAME {&FRAME-NAME}:FRAME) THEN FRAME {&FRAME-NAME}:FRAME
                                                                  ELSE FRAME {&FRAME-NAME}:PARENT

         /* In cases with the message dialog (like Information or Question messages), the TabFolder should not be shown.
            So to avoid the visualization of the TabFolder, a userProperty is set which is retrieved and stored in this
            variable. This value is used in _initializeObject to determine if the frame should be visualized or not */
         glDoNotShow = DYNAMIC-FUNCTION("getUserProperty":U, "DoNotShow":U) = "yes":U.

  /*When the instance property for the Smart Folder is called from the Container Builder using the
    'Object Properties' pop-up menu option, this procedure is initialized twice, the first time it is initialized
    from initializeSMO in _realizesmart.p, this initialization is wrong and the container source has an invalid
    handle, so we return if hContainer is not a valid handle.*/
  IF NOT VALID-HANDLE(hContainer) THEN
      RETURN.

  RUN _getProperties. 

  RUN _initializeObject.

  /* Astra2 code follows */
  IF glHasPendingValues = TRUE THEN
  DO:
    /* Because of a timing issue the pages weren't disabled. Disable them now */
    RUN disablePages(INPUT  gcPageInformation,
                     OUTPUT glHasPendingValues). /* If this is true, there is a problem */
  END.

  /* glPropertyValuesFetched prevents property values from unnecessarily *
   * being refetched while the folder initializes.                       *
   * Once the folder has initialized, we want to refetch property values *
   * as they might be updated by external procedures.                    */
  ASSIGN glPropertyValuesFetched = NO
         glInitializing          = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionObject s-object 
PROCEDURE repositionObject :
/*------------------------------------------------------------------------------
  Purpose:     Sets the size of the rectangles which make up the folder
               "image" whenever it is resized.
  Parameters:  INPUT height and width 
  Notes:       Run automatically when the folder is initialized or resized.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdRow     AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pdColumn  AS DECIMAL NO-UNDO.
  
  ASSIGN
      FRAME {&FRAME-NAME}:ROW    = pdRow
      FRAME {&FRAME-NAME}:COLUMN = pdColumn NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject s-object 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     Sets the size of the rectangles which make up the folder
               "image" whenever it is resized.
  Parameters:  INPUT height and width 
  Notes:       Run automatically when the folder is initialized or resized.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-height AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER p-width  AS DECIMAL NO-UNDO.
  
  DEFINE VARIABLE FRAME-PARENT AS WIDGET-HANDLE NO-UNDO.
  DEFINE VARIABLE iCount       AS INTEGER       NO-UNDO.
  
  ASSIGN
      gdYDifference = (IF gdYDifference = ? THEN 0
                                            ELSE ( IF {fn getTabPosition} = "Upper":U THEN 0
                                                                                      ELSE p-height - FRAME {&FRAME-NAME}:HEIGHT-CHARS))
      glResize      = TRUE
      .

    /* If this is a tabbed folder object, and all of the tabs are not yet created,
       then force the re-creation of all the tabs. This situation may occur when
       this folder object is initialised before its parent is resized and so the
       frame on which the tabs are created is too small.
     */ 
     
    IF gcVisualization EQ "TABS":U THEN 
    DO iCount = 1 TO itabtotal:
       IF NOT VALID-HANDLE(hTabMain[iCount]) THEN
       DO:
         ASSIGN glResize = FALSE.     
         LEAVE.
       END.
    END.
   

  SESSION:SET-WAIT-STATE("GENERAL":U).
  
  FRAME {&FRAME-NAME}:HIDDEN     = TRUE                               NO-ERROR.
  FRAME {&FRAME-NAME}:SCROLLABLE = TRUE                               NO-ERROR.
  FRAME-PARENT                   = FRAME {&FRAME-NAME}:PARENT         NO-ERROR.
  p-width                        = MAX({&MIN-WIDTH-CHARS},  p-width)  NO-ERROR.
  p-height                       = MAX({&MIN-HEIGHT-CHARS}, p-height) NO-ERROR.

  /* This seems to cause another GPF - Progress 9.1D0100 03/10/2002 (Mark Davies)
     Removing this line does not cause the folder not to resize correctly
     since that is still taken care of later in this procedure.
     I don't know why it was added here, but we would much rather live without the GPF!
  FRAME {&FRAME-NAME}:WIDTH = p-width NO-ERROR. */

  /* We have had to set the frame scrollable before setting the height, as if
     we do not, then it gpfs sometimes on the help about window which is a 
     dialog using this folder window. Wierd.
     With this scrollable = false line it just resizes the folder window
     wrong - but better than a GPF !!!! */
  FRAME {&FRAME-NAME}:SCROLLABLE   = FALSE    NO-ERROR. /* remove at your peril */
  /*FRAME {&FRAME-NAME}:HEIGHT-CHARS = p-height NO-ERROR.*/

  /* Check the lResult of the resize from the previous assign. If the container 
     is resized very small, or a left-to-right/top-to-bottom resize (which is
     really a MOVE) encounters the virtual size boundary, then Progress will 
     override the resize and set a minimum value. So we check and reset the 
     positions and sizes. */
  IF FRAME {&FRAME-NAME}:WIDTH  <> p-width  OR
     FRAME {&FRAME-NAME}:HEIGHT <> p-height THEN
    ASSIGN 
      /*FRAME {&FRAME-NAME}:ROW    = 1*/
      /*FRAME {&FRAME-NAME}:COLUMN = 1*/
        FRAME {&FRAME-NAME}:WIDTH  = p-width
        FRAME {&FRAME-NAME}:HEIGHT = p-height NO-ERROR. 

  /* The ADM calls Set-Size before "Initialize" so we need to disable the
     re-initialize during UIB resizing until the object has been properly
     instantiated. */
       
  IF getObjectInitialized() THEN RUN _initializeObject.  

  IF UIBMode() THEN
  DO:
    IF NOT VALID-HANDLE(hVentilator) THEN
    DO:
      RUN _getVentilator      (INPUT FRAME {&FRAME-NAME}:HANDLE) NO-ERROR.
      RUN _addVentilatorPopup (INPUT FRAME {&FRAME-NAME}:POPUP-MENU).
    END.
    ELSE
      hVentilator:MOVE-TO-TOP().
  END.

  ASSIGN
      gdYDifference = 0
      glResize      = FALSE.

  SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectNextTab s-object 
PROCEDURE selectNextTab :
/*------------------------------------------------------------------------------
  Purpose:     Select the previous or next enabled tab
  Parameters:  None
  Notes:       Used generally to provide easy keyboard control from PAGE-DOWN
               trigger of the container frame.
------------------------------------------------------------------------------*/
DEFINE VARIABLE iPage AS INTEGER NO-UNDO.

DO iPage = iCurrentTab + 1 TO iTabCount:
    IF laTabEnabled[iPage] 
    THEN DO:        
        RUN selectPage IN hContainer (iPage).
        RETURN.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectNextTabCycle s-object 
PROCEDURE selectNextTabCycle :
/*------------------------------------------------------------------------------
  Purpose:     Select the previous or next enabled tab
  Parameters:  None
  Notes:       Used generally to provide easy keyboard control from PAGE-DOWN
               trigger of the container frame.
------------------------------------------------------------------------------*/
DEFINE VARIABLE iPage AS INTEGER NO-UNDO.



DO iPage = iCurrentTab + 1 TO iTabCount:
    IF laTabEnabled[iPage] 
    THEN DO:        
        RUN selectPage IN hContainer (iPage).
        RETURN.
    END.
END.
DO iPage = 1 TO iCurrentTab - 1:
    IF laTabEnabled[iPage] 
    THEN DO:        
        RUN selectPage IN hContainer (iPage).
        RETURN.
    END.
END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectPrevTab s-object 
PROCEDURE selectPrevTab :
/*------------------------------------------------------------------------------
  Purpose:     Select the previous or next enabled tab
  Parameters:  None
  Notes:       Used generally to provide easy keyboard control from PAGE-UP
               trigger of the container frame.
------------------------------------------------------------------------------*/
DEFINE VARIABLE iPage AS INTEGER NO-UNDO.

DO iPage = iCurrentTab - 1 TO 1 BY -1:
    IF laTabEnabled[iPage] 
    THEN DO:
        RUN selectPage IN hContainer (iPage).
        RETURN.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showCurrentPage s-object 
PROCEDURE showCurrentPage :
/*------------------------------------------------------------------------------
  Purpose:     Called by the UIB to change the visualization
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER page# AS INTEGER NO-UNDO.

  IF VALID-HANDLE(hSelFrame) AND gcVisualization = "TABS":U THEN
    hSelFrame:HIDDEN = TRUE.

  iPageNo = page#.

  IF iPageNo > 0 AND iPageNo <= iTabTotal THEN
  DO:
    iCurrentTab = ?.

    RUN _selectTab(iPageNo).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _createAlternateSelectors s-object 
PROCEDURE _createAlternateSelectors PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:  This procedure will create the alternate visualizations for the
            TabFolder, i.e. a Radio-Set or a Combo-Box
  
  Parameters:  <none>
  
  Notes:  If the visualization is Combo-Box, this procedure will be called
          whenever pages are disabled / enabled to rebuild the list-item-pairs.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cListItemPairs  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFolderLabels   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iScreenValue    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCounter        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSideLabel      AS HANDLE     NO-UNDO.

  ASSIGN
      cFolderLabels = {fn getFolderLabels}
      cFolderLabels = IF gcVisualization = "COMBO-BOX":U THEN REPLACE(cFolderLabels, "&":U, "":U) ELSE cFolderLabels.

  /* Build up a pair of list items containing the folder label and the page number */
  DO iCounter = 1 TO NUM-ENTRIES(cFolderLabels, "{&DELIMITER}":U):

    IF laTabEnabled[iCounter] OR gcVisualization = "RADIO-SET":U THEN
      cListItemPairs = cListItemPairs
                     + (IF cListItemPairs = "":U THEN "":U ELSE "{&DELIMITER}":U)
                     + ENTRY(iCounter, cFolderLabels, "{&DELIMITER}":U) + "{&DELIMITER}":U
                     + STRING(iCounter).
  END.

  CASE gcVisualization:
    /* Create the Radio-Set widget */
    WHEN "RADIO-SET":U THEN
      IF NOT VALID-HANDLE(ghDisplayWidget) THEN
        CREATE RADIO-SET ghDisplayWidget {&IN-WIDGET-POOL}
        ASSIGN HORIZONTAL    = TRUE
               DELIMITER     = "{&DELIMITER}":U
               ROW           = 1.12
               COLUMN        = 2
               NAME          = "RadioSet-Labels":U
               RADIO-BUTTONS = cListItemPairs
        TRIGGERS:
          ON VALUE-CHANGED   PERSISTENT RUN _widgetTrigger IN THIS-PROCEDURE.
          ON MOUSE-MENU-DOWN PERSISTENT RUN _trgPopupMenu  IN THIS-PROCEDURE (ghDisplayWidget).
        END TRIGGERS.

    /* Create the Combo-Box widget and its side-label */
    WHEN "COMBO-BOX":U THEN
    DO:
      IF NOT VALID-HANDLE(ghDisplayWidget) THEN
      DO:
        CREATE TEXT hSideLabel {&IN-WIDGET-POOL}
        ASSIGN
            SCREEN-VALUE = "Page"
            FORMAT       = "x(256)":U
        TRIGGERS:
          ON MOUSE-MENU-DOWN PERSISTENT RUN _trgPopupMenu IN THIS-PROCEDURE (hSideLabel).
        END TRIGGERS.

        CREATE COMBO-BOX ghDisplayWidget {&IN-WIDGET-POOL}
        ASSIGN SIDE-LABEL-HANDLE = hSideLabel
               INNER-LINES       = 5
               DELIMITER         = "{&DELIMITER}":U
               TOOLTIP           = "Select desired page"
               DATA-TYPE         = "INTEGER":U
               VISIBLE           = FALSE
               FONT              = 0
               WIDTH-CHARS       = 1
               NAME              = "coTabPages":U
        TRIGGERS:
          ON VALUE-CHANGED PERSISTENT   RUN _widgetTrigger IN THIS-PROCEDURE.
          ON MOUSE-MENU-DOWN PERSISTENT RUN _trgPopupMenu  IN THIS-PROCEDURE (ghDisplayWidget).
        END TRIGGERS.

        /* ----- Translate the Combo-Box's label ---------------------------------------------------------------------------------------------------------- */
        EMPTY TEMP-TABLE ttTranslate.

        CREATE ttTranslate.
        ASSIGN
          ttTranslate.cObjectName        = {fn getLogicalObjectName hContainer}
          ttTranslate.lGlobal            = NO
          ttTranslate.lDelete            = NO
          ttTranslate.cWidgetType        = "COMBO-BOX":U
          ttTranslate.cWidgetName        = ghDisplayWidget:NAME
          ttTranslate.hWidgetHandle      = ghDisplayWidget
          ttTranslate.iWidgetEntry       = 0
          ttTranslate.cOriginalLabel     = ghDisplayWidget:SIDE-LABEL-HANDLE:SCREEN-VALUE
          ttTranslate.cTranslatedLabel   = "":U
          ttTranslate.cOriginalTooltip   = ghDisplayWidget:TOOLTIP
          ttTranslate.cTranslatedTooltip = "":U.

        ttTranslate.dLanguageObj       = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, "CurrentLanguageObj":U, FALSE)).
        ttTranslate.dSourceLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, "CurrentLanguageObj":U, FALSE)).
    
        RUN multiTranslation IN gshTranslationManager (INPUT NO,
                                                       INPUT-OUTPUT TABLE ttTranslate).
        
        FIND FIRST ttTranslate NO-LOCK NO-ERROR.
        
        IF AVAILABLE ttTranslate THEN
          ASSIGN
              ghDisplayWidget:SIDE-LABEL-HANDLE:SCREEN-VALUE = (IF ttTranslate.cTranslatedLabel   = "":U THEN ghDisplayWidget:SIDE-LABEL-HANDLE:SCREEN-VALUE
                                                                                                         ELSE ttTranslate.cTranslatedLabel) + ":":U
              ghDisplayWidget:TOOLTIP                        = (IF ttTranslate.cTranslatedTooltip = "":U THEN ghDisplayWidget:TOOLTIP
                                                                                                         ELSE ttTranslate.cTranslatedTooltip).
        /* ----- End of Translate ------------------------------------------------------------------------------------------------------------------------- */
      END.

      ASSIGN
          ghDisplayWidget:SIDE-LABEL-HANDLE:COLUMN      = 3.00
          ghDisplayWidget:SIDE-LABEL-HANDLE:ROW         = 1.18 + 0.15
          ghDisplayWidget:SIDE-LABEL-HANDLE:FONT        = iTabFont
          ghDisplayWidget:SIDE-LABEL-HANDLE:WIDTH-CHARS = FONT-TABLE:GET-TEXT-WIDTH-CHARS(ghDisplayWidget:SIDE-LABEL-HANDLE:SCREEN-VALUE, iTabFont)
          ghDisplayWidget:ROW                           = 1.18
          ghDisplayWidget:COLUMN                        = ghDisplayWidget:SIDE-LABEL-HANDLE:COLUMN
                                                        + ghDisplayWidget:SIDE-LABEL-HANDLE:WIDTH-CHARS + 0.50 NO-ERROR.
    END.
  END CASE.

  /* Store the current screen-value so that if the list-item-pairs were rebuilt, we can redisplay the correct item after property assignment */
  IF VALID-HANDLE(ghDisplayWidget:FRAME) THEN
    iScreenValue = INTEGER(ghDisplayWidget:SCREEN-VALUE).
  ELSE
    iScreenValue = ?.

  /* Assign the correct property */
  IF cListItemPairs <> "":U THEN
    IF gcVisualization = "COMBO-BOX":U THEN
      ghDisplayWidget:LIST-ITEM-PAIRS = cListItemPairs.

  /* Redisplay the correct item */
  IF iScreenValue <> ? THEN
    ghDisplayWidget:SCREEN-VALUE = STRING(iScreenValue) NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _createFolderLabel s-object 
PROCEDURE _createFolderLabel PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Create a new Dynamic Tab
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTempHandle AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cMnemonic   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iMnemonic   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSource     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainer  AS HANDLE     NO-UNDO.
  
  IF iPanelCount < 1 OR gcVisualization = "TABS":U THEN
    IF iPanelCount = 0 OR iaTabsOnPanel[iPanelCount] >= iTabsPerRow THEN
      RUN _createFolderPage.

  ASSIGN
      iTabCount                  = iTabCount + 1 
      iCurrentXPos               = iNextTabPos
      iaTabsOnPanel[iPanelCount] = iaTabsOnPanel[iPanelCount] + 1

      /* Tab width is either the auto width or the minimum width required to display the defined label. */
      iThisTabSize = IF {&TABS-ARE-AUTOSIZED} THEN iTabAutoWidth ELSE
                     FONT-TABLE:GET-TEXT-WIDTH-PIXELS(caFolderLabel[iTabCount],iTabFont) + 3 + iTabImageTotal + {&TAB-PIXEL-OFFSET}.

  /* If we're auto-sizing and we are placing the last tab on the row, then we resize
     it so that it meets up exactly with the end of the panel. If we're not auto-sizing
     and the last tab on the row fits okay and {&TABS-ARE-JUSTIFIED} is true, we do the
     same and extend its width so that it meets up exactly with the end of the panel. */       

  IF ({&TABS-ARE-AUTOSIZED} OR {&TABS-ARE-JUSTIFIED}) AND iaTabsOnPanel[iPanelCount] = iTabsPerRow THEN 
    iThisTabSize = iPanelFrameWidth - iNextTabPos - 1.

  IF iCurrentXPos + iThisTabSize + {&OBJECT-SPACING} > iPanelFrameWidth THEN
  DO:
    IF NOT {&WARNINGS-ARE-SUPPRESSED} THEN
      MESSAGE "Tab" iTabCount '(labelled "' + caFolderLabel[iTabCount] + '") does not fit on the row.' SKIP(1)
              "You should either reduce label size(s) or increase container width to make space for"
              "the Tab." SKIP(1)
              "You can disable this message by checking the ""Disable Resize Warning"" property." 
        VIEW-AS ALERT-BOX WARNING TITLE "Insufficient Space".

      RETURN ERROR.
  END.
  
  CASE gcVisualization:
    WHEN "COMBO-BOX":U THEN
    DO:
      IF VALID-HANDLE(ghDisplayWidget) THEN
        ASSIGN
            iThisTabSize = (3.00 * SESSION:PIXELS-PER-COLUMN)
                         + ghDisplayWidget:SIDE-LABEL-HANDLE:X
                         + ghDisplayWidget:SIDE-LABEL-HANDLE:WIDTH-PIXELS + 5 + 12.
      ELSE
        iThisTabSize = 14 * SESSION:PIXELS-PER-COLUMN.

      iThisTabSize = iThisTabSize + calcWidestLabel() - 5.
    END.

    WHEN "RADIO-SET":U THEN
      ASSIGN
          ghDisplayWidget:WIDTH-PIXELS = IF ghDisplayWidget:WIDTH-PIXELS > iPanelFrameWidth - 12 THEN iPanelFrameWidth - 12 ELSE ghDisplayWidget:WIDTH-PIXELS
          iThisTabSize                 = MIN(iPanelFrameWidth - 12, ghDisplayWidget:WIDTH-PIXELS) NO-ERROR.
   END CASE.

  /* Create the widgets that make up the tab.
     There are 6 rectangles that make up the tab border:
      2 left edges (|)
      1 'dot', top left (+)
      1 top edge (_______)
      1 'dot', top right (+)
      2 right edges (|)
     The text is a text widget. There's an optional
     image which overlays the text.
     
     The rectangles are 1 pixel wide or 1 pixel high,
     depending on where they're used.
     
      ____________
     +            +
    ||  T E X T   ||
    ||            ||
  
   */
  IF NOT glResize THEN
  DO:
    /* Top Edge */
    CREATE RECTANGLE hTabMain[iTabCount] {&IN-WIDGET-POOL}
    ASSIGN HIDDEN         = laTabHidden[iTabCount]
           HEIGHT-PIXELS  = 1
           EDGE-PIXELS    = 1
           GRAPHIC-EDGE   = FALSE
           FILLED         = true
           FGCOLOR        = IF lUpperTabs THEN 
                            (if session:window-system eq 'MS-WINXP' THEN COLOR-XPButtonShadowDark ELSE COLOR-ButtonHilight)
                            ELSE COLOR-ButtonText
           Y              = IF lUpperTabs THEN 0 ELSE hTabFrame[iPanelCount]:HEIGHT-PIXELS - 1
           FRAME          = hTabFrame[iPanelCount]
           SENSITIVE      = FALSE.
    /* Leftmost edge */
    CREATE RECTANGLE hTabLWht[iTabCount] {&IN-WIDGET-POOL}
    ASSIGN HIDDEN         = laTabHidden[iTabCount]
           WIDTH-PIXELS   = 1
           EDGE-PIXELS    = 1
           GRAPHIC-EDGE   = FALSE
           FILLED         = TRUE
           Y              = IF lUpperTabs THEN 2 ELSE 0
           FGCOLOR        = (if session:window-system eq 'MS-WINXP' THEN COLOR-XPButtonShadowDark ELSE COLOR-ButtonHilight)
           FRAME          = hTabFrame[iPanelCount]
           SENSITIVE      = FALSE.

    /* Second left edge */
    CREATE RECTANGLE hTabLGry[iTabCount] {&IN-WIDGET-POOL}
    ASSIGN HIDDEN         = laTabHidden[iTabCount]
           WIDTH-PIXELS   = 1
           EDGE-PIXELS    = 1
           GRAPHIC-EDGE   = FALSE
           FILLED         = TRUE
           FGCOLOR        = COLOR-ButtonFace
           Y              = IF lUpperTabs THEN 2 ELSE 0
           FRAME          = hTabFrame[iPanelCount]
           SENSITIVE      = FALSE.

    /* Single pixel, top left for corner */
    CREATE TEXT hTabLDot[iTabCount] {&IN-WIDGET-POOL}
    ASSIGN HIDDEN         = laTabHidden[iTabCount]
           HEIGHT-PIXELS  = 1
           BGCOLOR        = IF lUpperTabs THEN 
                            ((if session:window-system eq 'MS-WINXP' THEN COLOR-XPButtonShadowDark ELSE COLOR-ButtonHilight))
                            ELSE COLOR-ButtonShadow
           Y              = IF lUpperTabs THEN 1 ELSE hTabFrame[iPanelCount]:HEIGHT-PIXELS - 2
           FRAME          = hTabFrame[iPanelCount]
           SENSITIVE      = FALSE.

    /* Single pixel, top right for corner */
    CREATE TEXT hTabRDot[iTabCount] {&IN-WIDGET-POOL}
    ASSIGN HIDDEN         = laTabHidden[iTabCount]
           HEIGHT-PIXELS  = 1
           WIDTH-PIXELS   = 1
           BGCOLOR        = (if session:window-system eq 'MS-WINXP' THEN COLOR-XPButtonShadowDark ELSE COLOR-ButtonText)
           Y              = IF lUpperTabs THEN 1 ELSE hTabLDot[iTabCount]:Y
           FRAME          = hTabFrame[iPanelCount]
           SENSITIVE      = FALSE.

    /* First right edge */
    CREATE RECTANGLE hTabRGry[iTabCount] {&IN-WIDGET-POOL}
    ASSIGN HIDDEN         = laTabHidden[iTabCount]
           WIDTH-PIXELS   = 1
           EDGE-PIXELS    = 1
           GRAPHIC-EDGE   = FALSE
           FILLED         = TRUE
           FGCOLOR        = (if session:window-system eq 'MS-WINXP' THEN COLOR-XPButtonShadowDark ELSE COLOR-ButtonShadow)
           Y              = IF lUpperTabs THEN 2 ELSE 0
           FRAME          = hTabFrame[iPanelCount]
           SENSITIVE      = FALSE.

    /* Second right edge (rightmost) */
    CREATE RECTANGLE hTabRBla[iTabCount] {&IN-WIDGET-POOL}
    ASSIGN HIDDEN         = laTabHidden[iTabCount]
           WIDTH-PIXELS   = 1
           EDGE-PIXELS    = 1
           GRAPHIC-EDGE   = FALSE
           FILLED         = TRUE
           FGCOLOR        = (if session:window-system eq 'MS-WINXP' THEN COLOR-XPButtonShadowDark ELSE COLOR-ButtonText)
           Y              = IF lUpperTabs THEN 2 ELSE 0
           FRAME          = hTabFrame[iPanelCount]
           SENSITIVE      = FALSE.

    IF iImageHeight > 0 AND iImageWidth > 0 AND caTabImage[iTabCount] <> "":U THEN 
    DO:
      IF NOT glResize THEN
        CREATE IMAGE hTabIcon[iTabCount] {&IN-WIDGET-POOL}
        ASSIGN HIDDEN             = laTabHidden[iTabCount]
               Y                  = iTabImageYPos
               FRAME              = hTabFrame[iPanelCount]
               SENSITIVE          = laTabEnabled[iTabCount]
               CONVERT-3D-COLORS  = TRUE
        TRIGGERS:
          ON LEFT-MOUSE-DOWN PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount). 
        END TRIGGERS.

      ASSIGN
          hTabIcon[iTabCount]:HEIGHT-PIXELS = iImageHeight
          hTabIcon[iTabCount]:WIDTH-PIXELS  = iImageWidth
          hTabIcon[iTabCount]:X             = iCurrentXPos + 2 + iImageXOffset.
    END.

    /* Tab text */
    CREATE TEXT hTempHandle {&IN-WIDGET-POOL}
    ASSIGN HIDDEN         = laTabHidden[iTabCount]
           FONT           = iTabFont
           FORMAT         = "x(256)":U
           TOOLTIP        = caTooltipEnabled[iTabCount]
           SCREEN-VALUE   = " ":U + caFolderLabel[iTabCount]
           PRIVATE-DATA   = STRING(iPanelCount)
           FGCOLOR        = IF iaTabFGColor[iTabCount] = ? THEN COLOR-ButtonText ELSE iaTabFGColor[iTabCount]
           BGCOLOR        = IF iaTabBGColor[iTabCount] = ? THEN COLOR-ButtonFace ELSE iaTabBGColor[iTabCount]
           Y              = iLabelOffset + IF lUpperTabs THEN 1 ELSE 0
           FRAME          = hTabFrame[iPanelCount]
           SENSITIVE      = laTabEnabled[iTabCount]
    TRIGGERS:
      ON LEFT-MOUSE-DOWN PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
      ON MOUSE-MENU-DOWN PERSISTENT RUN _trgPopupMenu IN THIS-PROCEDURE (hTempHandle).
    END TRIGGERS.

    ASSIGN hTabLabel[iTabCount] = hTempHandle
           iMnemonic            = INDEX(hTabLabel[iTabCount]:SCREEN-VALUE,'&':U)
           cMnemonic            = (IF iMnemonic > 0 THEN 
                                         SUBSTRING(hTabLabel[iTabCount]:SCREEN-VALUE,iMnemonic + 1,1)
                                   ELSE '':U).

    /*Assigns widget-ids only if the -usewidgetid session parameter is being used*/
    IF DYNAMIC-FUNCTION('getUseWidgetID':U IN TARGET-PROCEDURE) THEN
    RUN assignWidgetIDs IN TARGET-PROCEDURE (INPUT iTabCount, INPUT hTempHandle).

   /* If the user specified a mnemonic, using an ampersand in the label define
       an ALT-x trigger for it. */
   {get ContainerSource hSource}.
   IF VALID-HANDLE(hSource) THEN 
      {get ContainerHandle hContainer hsource}.

   IF cMnemonic NE '':U AND VALID-HANDLE(hContainer) THEN DO:
      CASE cMnemonic:
          WHEN 'A':U THEN
            ON ALT-A OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN 'B':U THEN
            ON ALT-B OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN 'C':U THEN
            ON ALT-C OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN 'D':U THEN
            ON ALT-D OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN 'E':U THEN
            ON ALT-E OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN 'F':U THEN
            ON ALT-F OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN 'G':U THEN
            ON ALT-G OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN 'H':U THEN
            ON ALT-H OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN 'I':U THEN
            ON ALT-I OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN 'J':U THEN
            ON ALT-J OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN 'K':U THEN
            ON ALT-K OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN 'L':U THEN
            ON ALT-L OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN 'M':U THEN
            ON ALT-M OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN 'N':U THEN
            ON ALT-N OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN 'O':U THEN
            ON ALT-O OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN 'P':U THEN
            ON ALT-P OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN 'Q':U THEN
            ON ALT-Q OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN 'R':U THEN
            ON ALT-R OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN 'S':U THEN
            ON ALT-S OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN 'T':U THEN
            ON ALT-T OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN 'U':U THEN
            ON ALT-U OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN 'V':U THEN
            ON ALT-V OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN 'W':U THEN
            ON ALT-W OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN 'X':U THEN
            ON ALT-X OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN 'Y':U THEN
            ON ALT-Y OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN 'Z':U THEN
            ON ALT-Z OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN '0':U THEN
            ON ALT-0 OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).    
          WHEN '1':U THEN
            ON ALT-1 OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN '2':U THEN
            ON ALT-2 OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN '3':U THEN
            ON ALT-3 OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN '4':U THEN
            ON ALT-4 OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN '5':U THEN
            ON ALT-5 OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN '6':U THEN
            ON ALT-6 OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).    
          WHEN '7':U THEN
            ON ALT-7 OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN '8':U THEN
            ON ALT-8 OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
          WHEN '9':U THEN
            ON ALT-9 OF hContainer ANYWHERE
              PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount).
              
      END CASE.
    END.     
  END.

  IF gcVisualization <> "TABS":U THEN
    ASSIGN
        hTabMain[iTabCount]:WIDTH-PIXELS = MAX(4,iThisTabSize - 3)
        hTabMain[iTabCount]:VISIBLE      = FALSE
        hTabMain[iTabCount]:X            = iCurrentXPos + 2
        hTabLWht[iTabCount]:VISIBLE      = FALSE
        hTabLWht[iTabCount]:X            = iCurrentXPos + 2
        hTabLGry[iTabCount]:VISIBLE      = FALSE
        hTabLDot[iTabCount]:VISIBLE      = FALSE
        hTabRDot[iTabCount]:VISIBLE      = FALSE
        hTabRGry[iTabCount]:VISIBLE      = FALSE
        hTabRBla[iTabCount]:VISIBLE      = FALSE
        hTabLabel[iTabCount]:VISIBLE     = FALSE NO-ERROR.

  IF gcVisualization = "TABS":U THEN
    ASSIGN
        hTabMain[iTabCount]:WIDTH-PIXELS   = MAX(4,iThisTabSize - 3)
        hTabMain[iTabCount]:X              = iCurrentXPos + 2
        hTabLWht[iTabCount]:HEIGHT-PIXELS  = iTabHeightPixels - 2
        hTabLWht[iTabCount]:X              = iCurrentXPos
        hTabLGry[iTabCount]:HEIGHT-PIXELS  = iTabHeightPixels - 2
        hTabLGry[iTabCount]:X              = iCurrentXPos + 1
        hTabLDot[iTabCount]:WIDTH-PIXELS   = IF lUpperTabs THEN 1 ELSE hTabMain[iTabCount]:WIDTH-PIXELS + 1
        hTabLDot[iTabCount]:X              = iCurrentXPos + 1
        hTabRDot[iTabCount]:X              = iCurrentXPos + iThisTabSize - 1
        hTabRGry[iTabCount]:HEIGHT-PIXELS  = hTabLWht[iTabCount]:HEIGHT-PIXELS
        hTabRGry[iTabCount]:X              = iCurrentXPos + iThisTabSize - 1
        hTabRBla[iTabCount]:HEIGHT-PIXELS  = iTabHeightPixels - 2
        hTabRBla[iTabCount]:X              = iCurrentXPos + iThisTabSize
        hTabLabel[iTabCount]:HEIGHT-PIXELS = iTabHeightPixels - (IF lUpperTabs THEN 1 ELSE 2) - iLabelOffset
        hTabLabel[iTabCount]:WIDTH-PIXELS  = hTabMain[iTabCount]:WIDTH-PIXELS - iImageWidth - iImageXOffset 
        hTabLabel[iTabCount]:X             = iCurrentXPos + 2 + iTabImageTotal NO-ERROR.

  ASSIGN
      /* Resize the tab container frame so that it is only as wide as the displayed tabs. */
      hTabFrame[iPanelCount]:WIDTH-PIXELS         = hTabRBla[iTabCount]:X + 1
      hMenuItem[iTabCount]                        = hTabLabel[iTabCount]
      hTabFrame[iPanelCount]:VIRTUAL-WIDTH-PIXELS = hTabFrame[iPanelCount]:WIDTH-PIXELS
      iNextTabPos                                 = hTabRBla[iTabCount]:X + {&OBJECT-SPACING} NO-ERROR.

  IF iTabCount = 1 THEN RUN _createSelectorTab.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _createFolderPage s-object 
PROCEDURE _createFolderPage PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Creates a new raised graphic panel
  Parameters:  <none>
  Notes:       * When runnig MS-WINXP, buttons have a 2 pixel border. Overwrite
                 one of these pixesl in both dimensions so as to show only a single 
                 pixel border.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hTempHandle AS HANDLE     NO-UNDO.

  /* The panel is the three-d panel that appears beneath each row. All panels are 
     the same size and are actually disabled button widgets. Panels do not move 
     when a tab is selected. */
  ASSIGN
      iPanelCount                = iPanelCount + 1
      iRowCOunt                  = iRowCOunt + IF iPanelCount > iVisibleRows THEN 0 ELSE 1
      iaTabsOnPanel[iPanelCount] = 0
      iNextTabPos                = {&TAB-PIXEL-OFFSET}.

  /* Button to serve as row panels */
  IF iRowCount > 0 THEN
  DO:
    IF NOT glResize THEN
      CREATE BUTTON hPanelFrame[iPanelCount] {&IN-WIDGET-POOL}
      ASSIGN HEIGHT-PIXELS  = iPanelFrameHeight
             Y              = IF lUpperTabs THEN iTabHeightPixels * ((iPanelTotal + 1) - iRowCOunt) + {&TAB-PIXEL-OFFSET}
                                            ELSE iTabFrameHeight * (iRowCount - 1)
             PRIVATE-DATA   = STRING(iPanelCount)
             FRAME          = FRAME {&FRAME-NAME}:HANDLE
             SENSITIVE      = FALSE.

    ASSIGN
        hPanelFrame[iPanelCount]:HEIGHT-PIXELS = iPanelFrameHeight
        hPanelFrame[iPanelCount]:WIDTH-PIXELS  = iPanelFrameWidth
        hPanelFrame[iPanelCount]:X             = iPanelOffset * (iRowCount - 1)
        hPanelFrame[iPanelCount]:SCROLLABLE    = FALSE NO-ERROR.     
  END.
  ELSE 
    hPanelFrame[iPanelCount] = hPanelFrame[iPanelCount - 1].

  /* Frame to hold the tabs. Tabs on a row are held in their own container so that
     row can be moved when a tab on it is selected. As panels don't move, attribute 
     RULE-ROW is used to record the current panel to which the row is currently 
     "attached". */
  IF NOT glResize THEN
  DO:
    CREATE FRAME hTempHandle {&IN-WIDGET-POOL}
    ASSIGN BOX            = FALSE
           THREE-D        = TRUE
           RULE-ROW       = iPanelCount
           Y              = IF lUpperTabs THEN hPanelFrame[iPanelCount]:Y - iTabHeightPixels 
                                          ELSE hPanelFrame[iPanelCount]:Y + hPanelFrame[iPanelCount]:HEIGHT-PIXELS 
           BGCOLOR        = FRAME {&FRAME-NAME}:BGCOLOR
           FGCOLOR        = FRAME {&FRAME-NAME}:FGCOLOR
           FRAME          = FRAME {&FRAME-NAME}:HANDLE
           SCROLLABLE     = TRUE
           SENSITIVE      = TRUE
           NAME           = "TabFrame-":U + STRING(iPanelCount, "99":U)
    TRIGGERS:
      ON MOUSE-MENU-DOWN PERSISTENT RUN _trgPopupMenu IN THIS-PROCEDURE (hTempHandle).
    END TRIGGERS.

    hTabFrame[iPanelCount] = hTempHandle.

    IF gcVisualization <> "TABS":U THEN
      hTabFrame[iPanelCount]:VISIBLE = FALSE.
  END.

  ASSIGN
      hTabFrame[iPanelCount]:HEIGHT-PIXELS = iTabFrameHeight
      hTabFrame[iPanelCount]:ROW           = hTabFrame[iPanelCount]:ROW + gdYDifference
      hTabFrame[iPanelCount]:WIDTH-PIXELS  = iPanelFrameWidth
      hTabFrame[iPanelCount]:X             = iPanelOffset * (iRowCOunt - 1)
      hTabFrame[iPanelCount]:SCROLLABLE    = FALSE NO-ERROR.

  IF iPanelCount = 1 THEN
  DO:
    IF NOT glResize THEN
    DO:
      CREATE TEXT hPanelOverlay[iPanelCount] {&IN-WIDGET-POOL} 
      ASSIGN Y              = hPanelFrame[iPanelCount]:Y + (if session:window-system eq 'MS-WINXP' then 2 else 1)
             BGCOLOR        = COLOR-ButtonFace
             FGCOLOR        = COLOR-ButtonFace
             FRAME          = FRAME {&FRAME-NAME}:HANDLE
             SENSITIVE      = FALSE.
    END.

    ASSIGN
        hPanelOverlay[iPanelCount]:HEIGHT-PIXELS = iPanelFrameHeight - 4
        hPanelOverlay[iPanelCount]:WIDTH-PIXELS  = iPanelFrameWidth - 4
        hPanelOverlay[iPanelCount]:X             = hPanelFrame[iPanelCount]:X + (if session:window-system eq 'MS-WINXP' then 2 else 1)
        hPanelOverlay[iPanelCount]:SCROLLABLE    = FALSE NO-ERROR.                
  END.

  /*Assigns widget-ids only if the -usewidgetid session parameter is being used*/
  IF DYNAMIC-FUNCTION('getUseWidgetID':U IN TARGET-PROCEDURE) THEN
  RUN assignPanelWidgetIDs IN TARGET-PROCEDURE (INPUT FRAME {&FRAME-NAME}:WIDGET-ID,
                            INPUT hPanelFrame[iPanelCount],
                            INPUT hTempHandle,
                            INPUT hPanelOverlay[iPanelCount]).

  IF iPanelCount > iVisibleRows THEN
    hTabFrame[iPanelCount]:HIDDEN = TRUE.

  ASSIGN
      lResult = hTabFrame[iPanelCount]:MOVE-TO-BOTTOM()
      lResult = hPanelFrame[iPanelCount]:MOVE-TO-BOTTOM().
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _createMenuShortcut s-object 
PROCEDURE _createMenuShortcut PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Create a sub-menu The menu reflects the tab options available.
  Parameters:  Tab Number
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER iTabCount AS INTEGER NO-UNDO.

IF NOT VALID-HANDLE(hFolderMenu)
THEN DO:
    ASSIGN hFolderMenu = THIS-PROCEDURE:CURRENT-WINDOW
           hFolderMenu = hFolderMenu:MENU-BAR
           NO-ERROR.

    IF NOT VALID-HANDLE(hFolderMenu) 
    THEN DO:
        ASSIGN lAddFolderMenu = FALSE.
        RETURN.
    END.

    CREATE SUB-MENU hSubMenu {&IN-WIDGET-POOL}
        ASSIGN PARENT = hFolderMenu
               LABEL = cFolderMenuLabel.

    ASSIGN iMenuCount = 1.
END.

CREATE MENU-ITEM hMenuItem[iTabCount] {&IN-WIDGET-POOL}
    ASSIGN PARENT = hSubMenu
           ACCELERATOR = caHotkey[iTabCount]
           LABEL  = TRIM(caFolderLabel[iTabCount])
           SENSITIVE = laTabEnabled[iTabCount]
    TRIGGERS:
        ON CHOOSE PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (iTabCount). 
    END TRIGGERS.

ASSIGN iMenuCount = iMenuCount + 1.

IF iTabCount MODULO iTabsPerRow = 0 AND iTabCount < iTabTotal
THEN 
    CREATE MENU-ITEM hMenuItem[{&MAX-TABS}] {&IN-WIDGET-POOL}
        ASSIGN PARENT  = hSubMenu
               SUBTYPE = "RULE":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _createSelectorTab s-object 
PROCEDURE _createSelectorTab PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Creates the visual selector TAB

  Parameters:  <none>

  Notes:       
   When you click on a tab, it appears to "raise" and overlay the tabs either
   side of it. This frame holds a single tab used for visual selection. It is
   created and resized to match the selected tab except it is made slightly 
   higher and wider to give the appearance of selection. Procedure _selectTab 
   performs the resizing.

------------------------------------------------------------------------------*/
  /* Create the widgets that make up the tab.
     There are 7 rectangles that make up the tab border:
      1 left edges (|)
      1 'dot', top left (+)
      1 top edge (_______)
      1 'dot', top right (+)
      2 right edges (|)
      1 bottom rectangle, overlays button border
     The text is a text widget. There's an optional
     image which overlays the text.

     The rectangles are 1 pixel wide or 1 pixel high,
     depending on where they're used.

      ____________
     +            +
     |  T E X T   ||
     |            ||
      _____________
        
   */

  IF NOT glResize THEN
  DO:
    /* This is the frame on which the selected tab will be painted */
    CREATE FRAME hSelFrame {&IN-WIDGET-POOL}
    ASSIGN HIDDEN         = TRUE
           BOX            = FALSE
           SCROLLABLE     = TRUE
           THREE-D        = TRUE
           OVERLAY        = TRUE
           PRIVATE-DATA   = "Selector":U
           HEIGHT-PIXELS  = iTabFrameHeight + {&SELECTED-EXT-PIXEL-HEIGHT}
                          + (IF lUpperTabs THEN 
                             (1 + (if session:window-system eq 'MS-WINXP' then 1 else 0))
                             ELSE 2 )
           X              = 0
           Y              = IF lUpperTabs THEN hTabFrame[1]:Y - {&SELECTED-EXT-PIXEL-HEIGHT}
                            ELSE hTabFrame[1]:Y - 2
           BGCOLOR        = FRAME {&FRAME-NAME}:BGCOLOR
           FGCOLOR        = FRAME {&FRAME-NAME}:FGCOLOR
           FRAME          = FRAME {&FRAME-NAME}:HANDLE
           SENSITIVE      = FALSE
           NAME           = "SelectorFrame":U
    TRIGGERS:
      ON MOUSE-MENU-DOWN PERSISTENT RUN _trgPopupMenu IN THIS-PROCEDURE (hSelFrame).
    END TRIGGERS.

    ASSIGN hSelFrame:WIDGET-ID = FRAME {&FRAME-NAME}:WIDGET-ID + 10 NO-ERROR.

    /* leftmost border */
    CREATE RECTANGLE hSelLWht {&IN-WIDGET-POOL}
    ASSIGN WIDTH-PIXELS   = 1
           HEIGHT-PIXELS  = MAX(1,hSelFrame:HEIGHT-PIXELS - 2)
           EDGE-PIXELS    = 1
           GRAPHIC-EDGE   = FALSE
           FILLED         = TRUE
           FGCOLOR        = hTabLWht[1]:fgcolor
           X              = 0
           Y              = hTabLWht[1]:Y
           FRAME          = hSelFrame
           NAME           = "SelLWht"
           SENSITIVE      = FALSE
           WIDGET-ID      = 2.

    /* rectangle at the bottom, below text, overlaying panel button border */
    CREATE RECTANGLE hSelLGry {&IN-WIDGET-POOL}
    ASSIGN WIDTH-PIXELS   = 1
           HEIGHT-PIXELS  = MAX(1,hSelFrame:HEIGHT-PIXELS - 2)
           EDGE-PIXELS    = 1
           GRAPHIC-EDGE   = FALSE
           FILLED         = TRUE
           FGCOLOR        = COLOR-ButtonFace
           BGCOLOR        = COLOR-ButtonFace
           X              = 1
           Y              = hTabLWht[1]:Y
           FRAME          = hSelFrame
           NAME           = "SelLGry"
           SENSITIVE      = FALSE
           WIDGET-ID      = 4.

    /* single pixel in top left, to form corner */
    CREATE TEXT hSelLDot {&IN-WIDGET-POOL}
    ASSIGN WIDTH-PIXELS   = 1
           HEIGHT-PIXELS  = 1
           BGCOLOR        = hTabLDot[1]:BGCOLOR
           Y              = IF lUpperTabs THEN 1 ELSE hSelFrame:HEIGHT-PIXELS - 2
           FRAME          = hSelFrame
           NAME           = "SelLDot"
           SENSITIVE      = FALSE
           WIDGET-ID      = 6.

    /* Top edge of selected tab */
    CREATE RECTANGLE hSelMain {&IN-WIDGET-POOL}
    ASSIGN HEIGHT-PIXELS  = 1
           WIDTH-PIXELS   = 1
           EDGE-PIXELS    = 1
           GRAPHIC-EDGE   = FALSE
           FILLED         = TRUE
           FGCOLOR        = hTabMain[1]:FGCOLOR
           Y              = IF lUpperTabs THEN 0 ELSE hSelFrame:HEIGHT-PIXELS - 1
           FRAME          = hSelFrame
           name           = "SelMain"
           SENSITIVE      = FALSE
           WIDGET-ID      = 8.

    /* Single pixel on top right, to form corner */
    CREATE TEXT hSelRDot {&IN-WIDGET-POOL}
    ASSIGN WIDTH-PIXELS   = 1
           HEIGHT-PIXELS  = 1
           BGCOLOR        = hTabRDot[1]:bgcolor
           Y              = IF lUpperTabs THEN 1 ELSE hSelFrame:HEIGHT-PIXELS - 2
           FRAME          = hSelFrame
           NAME           = "SelRDot"
           SENSITIVE      = FALSE
           WIDGET-ID      = 10.

    /* First of 2 right edges */
    CREATE RECTANGLE hSelRGry {&IN-WIDGET-POOL}
    ASSIGN WIDTH-PIXELS   = IF lUpperTabs THEN 1 ELSE 2
           HEIGHT-PIXELS  = hSelLWht:HEIGHT-PIXELS
           EDGE-PIXELS    = 1
           GRAPHIC-EDGE   = FALSE
           FILLED         = TRUE
           FGCOLOR        = ( if session:window-system eq 'MS-WINXP' THEN COLOR-ButtonShadow ELSE hTabRGry[1]:fgcolor)
           Y              = IF lUpperTabs THEN 2 ELSE 0
           FRAME          = hSelFrame
           name           = "SelRGry"
           SENSITIVE      = FALSE
           WIDGET-ID      = 12.

    /* Second of 2 right edges */
    CREATE RECTANGLE hSelRBla {&IN-WIDGET-POOL}
    ASSIGN WIDTH-PIXELS   = 1
           HEIGHT-PIXELS  = hSelLWht:HEIGHT-PIXELS
           EDGE-PIXELS    = 1
           GRAPHIC-EDGE   = FALSE
           FILLED         = TRUE
           FGCOLOR        = hTabRBla[1]:fgcolor    
           Y              = IF lUpperTabs THEN 2 ELSE 0
           FRAME          = hSelFrame
           NAME           = "SelRBla"
           SENSITIVE      = FALSE
           WIDGET-ID      = 14.

    /* Selected tab label text */
    CREATE TEXT hSelLabel {&IN-WIDGET-POOL}
    ASSIGN WIDTH-PIXELS   = 1
           HEIGHT-PIXELS  = iTabLabelHeight + 1
           FORMAT         = "x(256)":U
           FONT           = iSelectorFont
           FGCOLOR        = IF iSelectorFGColor = ? THEN COLOR-ButtonText ELSE iSelectorFGColor
           BGCOLOR        = IF iSelectorBGColor = ? THEN COLOR-ButtonFace ELSE iSelectorBGColor
           Y              = IF lUpperTabs THEN 1
                            ELSE hSelFrame:HEIGHT-PIXELS - 2 - iTabLabelHeight - iLabelOffset - {&SELECTED-EXT-PIXEL-HEIGHT}
           FRAME          = hSelFrame
           name           = "SelLabel"
           SENSITIVE      = FALSE
           WIDGET-ID      = 16.

    CREATE IMAGE hSelIcon {&IN-WIDGET-POOL}
    ASSIGN WIDTH-PIXELS       = MAX(1,iImageWidth)
           HEIGHT-PIXELS      = MAX(1,iImageHeight)
           Y                  = iTabImageYPos + IF lUpperTabs THEN 0 ELSE {&SELECTED-EXT-PIXEL-HEIGHT} 
           FRAME              = hSelFrame
           CONVERT-3D-COLORS  = TRUE
           SENSITIVE          = FALSE.

    ASSIGN hSelIcon:WIDGET-ID = FRAME {&FRAME-NAME}:WIDGET-ID + 28 NO-ERROR.

    IF gcVisualization <> "TABS":U THEN
    DO:
      IF VALID-HANDLE(ghDisplayWidget:SIDE-LABEL-HANDLE) THEN
        ghDisplayWidget:SIDE-LABEL-HANDLE:FRAME = hSelFrame.

      ASSIGN
          ghDisplayWidget:FRAME     = hSelFrame
          ghDisplayWidget:SENSITIVE = NOT UIBMode()
          hSelFrame:SENSITIVE       = TRUE.
    END.
  END.

  ASSIGN
      hSelFrame:WIDTH-PIXELS  = iPanelFrameWidth
      hSelFrame:SCROLLABLE    = FALSE
      hSelFrame:ROW           = hSelFrame:ROW + (if gdYDifference eq ? THEN 0 ELSE gdYDifference)
      hSelLDot:X              = hSelLWht:X + 1
      hSelMain:X              = hSelLWht:X + 2
      hSelRDot:X              = hSelMain:WIDTH-PIXELS + 2 
      hSelRGry:X              = hSelMain:WIDTH-PIXELS + 2
      hSelRBla:X              = hSelMain:WIDTH-PIXELS + 3
      hSelLabel:X             = 2 + iTabImageTotal
      hSelIcon:X              = 2 + iImageXOffset NO-ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _getColours s-object 
PROCEDURE _getColours PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Calls the support procedure to get colour table mappings
  Parameters:  <none>
  Notes:       Colour variables in this procedure are:

 COLOR-ButtonHilight
 COLOR-ButtonFace 
 COLOR-ButtonShadow
 COLOR-GrayText
 COLOR-ButtonText 

------------------------------------------------------------------------------*/
IF VALID-HANDLE({&SUPER-HDL})
THEN
do:
    ASSIGN 
           COLOR-ButtonHilight = COLOR-OF("ButtonHilight")
           COLOR-ButtonFace    = COLOR-OF("ButtonFace")
           COLOR-ButtonShadow  = COLOR-OF("ButtonShadow")
           COLOR-GrayText      = COLOR-OF("GrayText")
           COLOR-ButtonText    = COLOR-OF("ButtonText")           
           NO-ERROR.
    if session:window-system eq 'MS-WINXP' THEN
    do:
        COLOR-XPButtonShadowDark = COLOR-OF("XPButtonShadowDark") NO-ERROR.
        
        /* make sure the color's are available */
        if COLOR-XPButtonShadowDark eq ? THEN
            RUN addColour in {&SUPER-HDL} (INPUT  'XPButtonShadowDark',
                                           INPUT  '198 195 189',
                                           OUTPUT COLOR-XPButtonShadowDark).
    END.    /* windows XP */
END.    /* valid handle */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _getProperties s-object 
PROCEDURE _getProperties PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Parse basic properties and arrays
  Parameters:  <none>
  Notes:       Transfer basic properties and property arrays into variables for 
               easy processing. 
------------------------------------------------------------------------------*/
    IF NOT glInitializing 
    OR NOT glPropertyValuesFetched THEN
    
    .
    
    
        RUN _getPropertyValues IN TARGET-PROCEDURE.

    IF NOT UIBMode() 
    THEN DO:
        ASSIGN lAddFolderMenu = NOT CAN-DO("No,?,":U,getFolderMenu())
               cFolderMenuLabel = IF getFolderMenu() = "Yes" 
                                  THEN "&Options" 
                                  ELSE getFolderMenu().
    
        RUN _resolveStateLinks IN THIS-PROCEDURE.
    END.
    
    IF NOT UIBMode()
    THEN
        ASSIGN NoWarnings = TRUE.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _getPropertyValues s-object 
PROCEDURE _getPropertyValues PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cFolderLabels       AS CHARACTER                      NO-UNDO.
    DEFINE VARIABLE cTabFGColor         AS CHARACTER                      NO-UNDO.
    DEFINE VARIABLE cTabBGColor         AS CHARACTER                      NO-UNDO.
    DEFINE VARIABLE cTabINColor         AS CHARACTER                      NO-UNDO.
    DEFINE VARIABLE cImageEnabled       AS CHARACTER                      NO-UNDO.
    DEFINE VARIABLE cImageDisabled      AS CHARACTER                      NO-UNDO.
    DEFINE VARIABLE cHotkey             AS CHARACTER                      NO-UNDO.
    DEFINE VARIABLE cTooltip            AS CHARACTER                      NO-UNDO.
    DEFINE VARIABLE cTabHidden          AS CHARACTER                      NO-UNDO.
    DEFINE VARIABLE cTabEnabled         AS CHARACTER                      NO-UNDO.
    DEFINE VARIABLE cEnableStates       AS CHARACTER                      NO-UNDO.
    DEFINE VARIABLE cDisableStates      AS CHARACTER                      NO-UNDO.
    DEFINE VARIABLE cSelectorFGColor    AS CHARACTER                      NO-UNDO.
    DEFINE VARIABLE cSelectorBGColor    AS CHARACTER                      NO-UNDO.
    DEFINE VARIABLE cTabImageEnabled    AS CHARACTER                      NO-UNDO.
    DEFINE VARIABLE cTabImageDisabled   AS CHARACTER                      NO-UNDO.

    ASSIGN glPropertyValuesFetched = YES
           cFolderLabels    = getFolderLabels()
           cTabFGColor      = getTabFGColor()
           cTabBGColor      = getTabBGColor()
           cTabINColor      = getTabINColor()
           cImageEnabled    = getImageEnabled()
           cImageDisabled   = getImageDisabled()
           cHotkey          = getHotkey()
           cTooltip         = getTooltip()
           cTabHidden       = getTabHidden()
           cTabEnabled      = getTabEnabled()
           cEnableStates    = getEnableStates()
           cDisableStates   = getDisableStates()
           cSelectorFGColor = getSelectorFGColor()
           cSelectorBGColor = getSelectorBGColor()
           gcVisualization  = getTabVisualization()
           
           iVisibleRows   = getVisibleRows()
           iPanelOffset   = getPanelOffset()
           iTabsPerRow    = getTabsPerRow()
           iTabHeight     = getTabHeight()
           iTabFont       = getTabFont()
           iLabelOffset   = getLabelOffset()
           iImageWidth    = getImageWidth()
           iImageHeight   = getImageHeight()
           iImageXOffset  = getImageXoffset()
           iImageYOffset  = getImageYoffset()
           iSelectorFont  = getSelectorFont()
           iSelectorWidth = getSelectorWidth()
    
           iTabTotal = NUM-ENTRIES(cFolderLabels,"{&DELIMITER}":U).
           
    IF NUM-ENTRIES(cTabEnabled, "{&DELIMITER}":U) NE iTabTotal THEN
        ASSIGN cTabEnabled = FILL("yes":U + "{&DELIMITER}":U, iTabTotal)
               cTabEnabled = RIGHT-TRIM(cTabEnabled, "{&DELIMITER}":U)
               .

    DO x = 1 TO iTabTotal:
        ASSIGN caFolderLabel[x] = IF NUM-ENTRIES(cFolderLabels,"{&DELIMITER}":U) >= X
                                  THEN ENTRY(x,cFolderLabels,"{&DELIMITER}":U)
                                  ELSE "":U
               caSavedLabel[X]  = (IF caSavedLabel[X] <> "":U THEN caSavedLabel[X] ELSE caFolderLabel[x])

               iaTabFGColor[x]  = COLOR-OF(IF NUM-ENTRIES(cTabFGColor,"{&DELIMITER}":U) >= X
                                           THEN ENTRY(x,cTabFGColor,"{&DELIMITER}":U)
                                           ELSE "":U)
               iaTabBGColor[x]  = COLOR-OF(IF NUM-ENTRIES(cTabBGColor,"{&DELIMITER}":U) >= X
                                           THEN ENTRY(x,cTabBGColor,"{&DELIMITER}":U)
                                           ELSE "":U)
               iaTabINColor[x]  = COLOR-OF(IF NUM-ENTRIES(cTabINColor,"{&DELIMITER}":U) >= X
                                           THEN ENTRY(x,cTabINColor,"{&DELIMITER}":U)
                                           ELSE "":U)
               
               caHotkey[x]      = IF NUM-ENTRIES(cHotKey,"{&DELIMITER}":U) >= X
                                  THEN ENTRY(x,cHotKey,"{&DELIMITER}":U)
                                  ELSE "":U
               caTooltipEnabled[x] = IF NUM-ENTRIES(cTooltip,"{&DELIMITER}":U) >= X
                                     THEN ENTRY(x,cTooltip,"{&DELIMITER}":U)
                                     ELSE "":U

               laTabHidden[x]    = CAN-DO("Yes,True",IF NUM-ENTRIES(cTabHidden,"{&DELIMITER}":U) >= X
                                                     THEN ENTRY(x,cTabHidden,"{&DELIMITER}":U)
                                                     ELSE "":U)
               laTabEnabled[x]   = laTabEnabled[x] 
                                   AND CAN-DO("Yes,True", IF NUM-ENTRIES(cTabEnabled,"{&DELIMITER}":U) >= X
                                                          THEN ENTRY(x,cTabEnabled,"{&DELIMITER}":U)
                                                          ELSE "":U)
    
               caEnableGroup[x]  = IF NUM-ENTRIES(cEnableStates,"{&DELIMITER}":U) >= X
                                   THEN ENTRY(x,cEnableStates,"{&DELIMITER}":U)
                                   ELSE "":U
    
               caDisableGroup[x] = IF (IF NUM-ENTRIES(cDisableStates,"{&DELIMITER}":U) >= X
                                       THEN ENTRY(x,cDisableStates,"{&DELIMITER}":U)
                                       ELSE "":U) = "":U
                                   THEN caEnableGroup[x]
                                   ELSE ENTRY(x,cDisableStates,"{&DELIMITER}":U)

               cTabImageEnabled  = IF NUM-ENTRIES(cImageEnabled,"{&DELIMITER}":U) >= X
                                   THEN ENTRY(x,cImageEnabled,"{&DELIMITER}":U)
                                   ELSE "":U
               iaTabXOffset[x]  = INTEGER(IF NUM-ENTRIES(cTabImageEnabled, " ":U) >= 2
                                          THEN ENTRY(2,cTabImageEnabled," ":U)
                                          ELSE "":U)
               iaTabYOffset[x]  = INTEGER(IF NUM-ENTRIES(cTabImageEnabled, " ":U) >= 3
                                          THEN ENTRY(3,cTabImageEnabled," ":U)
                                          ELSE "":U)

               cTabImageDisabled = IF NUM-ENTRIES(cImageDisabled,"{&DELIMITER}":U) >= X
                                   THEN ENTRY(x,cImageDisabled,"{&DELIMITER}":U)
                                   ELSE "":U
               iaTabXiOffset[x] = INTEGER(IF NUM-ENTRIES(cTabImageDisabled, " ":U) >= 2
                                          THEN ENTRY(2,cTabImageDisabled," ":U)
                                          ELSE "":U)
               iaTabYiOffset[x] = INTEGER(IF NUM-ENTRIES(cTabImageDisabled, " ":U) >= 3
                                          THEN ENTRY(3,cTabImageDisabled," ":U)
                                          ELSE "":U)

               /* We store full paths for maximum performance when doing the LOAD-IMAGE. */
               caTabImage[x]  = IF NUM-ENTRIES(cTabImageEnabled," ":U) >= 1
                                THEN ENTRY(1,cTabImageEnabled," ":U)
                                ELSE "":U
               caTabiImage[x] = IF NUM-ENTRIES(cTabImageDisabled," ":U) >= 1
                                THEN ENTRY(1,cTabImageDisabled," ":U)
                                ELSE "":U.

        IF caTabImage[x] <> "":U
        THEN DO:
            FILE-INFO:FILE-NAME = caTabImage[x].
            ASSIGN caTabImage[x] = IF FILE-INFO:FULL-PATHNAME = ?
                                   THEN caTabImage[x]
                                   ELSE FILE-INFO:FULL-PATHNAME.
        END.

        IF caTabiImage[x] <> "":U 
        THEN DO:
            FILE-INFO:FILE-NAME = caTabiImage[x].
            ASSIGN caTabiImage[x] = IF FILE-INFO:FULL-PATHNAME = ?
                                    THEN caTabiImage[x]
                                    ELSE FILE-INFO:FULL-PATHNAME.
        END.
    END.

    ASSIGN iSelectorFGColor = COLOR-OF(cSelectorFGcolor)
           iSelectorBGColor = COLOR-OF(cSelectorBGcolor)
           
           {&TABS-ARE-AUTOSIZED} = getTabSize() = "AutoSized"
           {&TABS-ARE-JUSTIFIED} = getTabSize() = "Justified" OR iTabTotal > iTabsPerRow
           
           lAddFolderMenu = FALSE.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _initializeObject s-object 
PROCEDURE _initializeObject PRIVATE :
/*----------------------------------------------------------------------------
  Purpose:     Perform Initialisation
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iVirtualHeightPixels  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iVirtualWidthPixels   AS INTEGER    NO-UNDO.

  FRAME {&FRAME-NAME}:HIDDEN = TRUE.

  IF NOT glResize THEN
    DELETE WIDGET-POOL WIDGET-POOL-NAME NO-ERROR.

  ASSIGN
      FRAME {&FRAME-NAME}:SCROLLABLE            = TRUE
      iVirtualHeightPixels                        = FRAME {&FRAME-NAME}:HEIGHT-PIXELS
      iVirtualWidthPixels                         = FRAME {&FRAME-NAME}:WIDTH-PIXELS
      FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-PIXELS = 2 * SESSION:HEIGHT-PIXELS
      FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-PIXELS  = 2 * SESSION:WIDTH-PIXELS      
      FRAME {&FRAME-NAME}:SCROLLABLE            = FALSE 
      NO-ERROR. 

  IF NOT glResize THEN
    CREATE WIDGET-POOL WIDGET-POOL-NAME PERSISTENT NO-ERROR.

  /* Set some defaults. Tab height is based on the selected font or the tab icon,
     whichever is larger. The width is based on the length of the label or if 
     {&TABS-ARE-AUTOSIZED} is true, a width which is dependant on the width of the frame 
     and the number of tabs per row. The width is extended when the tabs are created
     by the width of the tab icon (if any) plus the pixel space between the tab 
     and the icon.
  */

  ASSIGN
      iTabHeightPixels  = calcTabHeightPixels()
      iTabFrameHeight   = iTabHeightPixels                                                              /* The height of the frame for each row */
      iPanelTotal       = IF iTabsPerRow > 0 THEN MIN(iVisibleRows,INT(iTabTotal / iTabsPerRow + 0.49)) 
                                             ELSE 1
      iPanelTotal       = IF gcVisualization = "TABS":U THEN iPanelTotal ELSE 1
      iPanelFrameHeight = FRAME {&FRAME-NAME}:HEIGHT-PIXELS
                        - {&TAB-PIXEL-OFFSET}
                        - (iTabFrameHeight * iPanelTotal)                                               /* The height of each hPanelFrame so they all fit in the main frame */
      iPanelFrameWidth  = FRAME {&FRAME-NAME}:WIDTH-PIXELS - (iPanelOffset * (iPanelTotal - 1))             /* The width  of each hPanelFrame so they all fit in the main frame */
      iTabImageTotal    = iImageWidth + iImageXOffset                                                   /* Total space occupied by a tab icon */
      iTabAutoWidth     = MAXIMUM(((iPanelFrameWidth - ({&TAB-PIXEL-OFFSET} * 2)                     /* Tab width and label width for auto sizing */
                        - ({&OBJECT-SPACING} * (iTabsPerRow - 1))) / iTabsPerRow),6 + iTabImageTotal)
      iTabLabelHeight   = MAX(1,iTabFrameHeight - 2 - IF lUpperTabs THEN iLabelOffset ELSE 0)           /* Height of each label widget and the Y co-ordinate based on the height */
      iRowCOunt         = 0
      iMenuCount        = 0
      iPanelCount       = 0
      iaTabsOnPanel[1]  = 0
      iTabCount         = 0
      lUpperTabs        = getTabPosition() = "Upper"
      iTabImageYPos     = 1 + iImageYOffset.

  FRAME {&FRAME-NAME}:BGCOLOR = IF getInheritColor()
                               THEN hParent:BGCOLOR
                               ELSE ?.

  IF iPanelFrameHeight < 1 THEN 
    MESSAGE "Insufficient space in frame to display all tab rows."
        VIEW-AS ALERT-BOX ERROR TITLE "Insufficient Space".
  ELSE
  DO:
    IF gcVisualization <> "TABS":U THEN
      RUN _createAlternateSelectors.

    /* Create all the tabs */    
    glTabsEnabled = FALSE.
    DO y = 1 TO iTabTotal ON ERROR UNDO, RETRY: 

      RUN _createFolderLabel NO-ERROR.

      IF laTabEnabled[Y] = FALSE THEN
        RUN disableFolderPage(y).
      ELSE
        RUN enableFolderPage(y).

      glTabsEnabled = glTabsEnabled OR laTabEnabled[Y].

      IF lAddFolderMenu THEN RUN _createMenuShortcut(y).
    END.

    /* Now size the tab where the display widget sits on */
    IF gcVisualization <> "TABS":U THEN
    DO:
      glDontUpdateCurrentTab = TRUE.
    
      RUN _selectTab (INPUT 1).
    END.
  END.

  ASSIGN
      FRAME {&FRAME-NAME}:SCROLLABLE            = TRUE
      FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-PIXELS = iVirtualHeightPixels
      FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-PIXELS  = iVirtualWidthPixels
      FRAME {&FRAME-NAME}:SCROLLABLE            = FALSE
      
      FRAME {&FRAME-NAME}:HEIGHT-PIXELS = iVirtualHeightPixels
      FRAME {&FRAME-NAME}:WIDTH-PIXELS  = iVirtualWidthPixels

      FRAME {&FRAME-NAME}:HIDDEN = IF glDoNotShow THEN TRUE ELSE FALSE
      lResult                    = IF gcVisualization = "TABS":U THEN hSelFrame:MOVE-TO-TOP() ELSE hSelFrame:MOVE-TO-BOTTOM()
      lResult                    = FRAME {&FRAME-NAME}:MOVE-TO-BOTTOM() NO-ERROR.

  IF NOT UIBMode() OR gcVisualization <> "TABS":U THEN
  DO:
    IF NOT glDoNotShow THEN
      RUN ChangeFolderPage.

    IF VALID-HANDLE(hSelFrame) AND gcVisualization <> "TABS":U THEN
      hSelFrame:MOVE-TO-BOTTOM().
  END.
    
  IF getMouseCursor() <> "":U AND NOT UIBMode() THEN
  DO z = 1 TO iPanelCount:
    hTabFrame[z]:LOAD-MOUSE-POINTER(getMouseCursor()).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _labelTrigger s-object 
PROCEDURE _labelTrigger PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Trigger to fire tab selection on mouse lick
  Parameters:  Tab array index of tab clicked
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER TAB-NUMBER AS INTEGER NO-UNDO.

  IF laTabEnabled[TAB-NUMBER] AND iCurrentTab <> TAB-NUMBER AND VALID-HANDLE({&CONTAINER}) THEN
    RUN selectPage IN {&CONTAINER} (INPUT TAB-NUMBER).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _ResolveStateLinks s-object 
PROCEDURE _ResolveStateLinks PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Set enabling/disabling subscriptions

  Parameters:  <none>

  Notes:       Sets the subscriptions that enable or disable buttons, for all
               Page Targets. Usually, this is just the container.

------------------------------------------------------------------------------*/
DEFINE VARIABLE cList AS CHARACTER NO-UNDO.

DEFINE VARIABLE pHandle AS HANDLE NO-UNDO.

DEFINE VARIABLE iCountX AS INTEGER NO-UNDO.
DEFINE VARIABLE iCountY AS INTEGER NO-UNDO.
DEFINE VARIABLE iCountZ AS INTEGER NO-UNDO.

DEFINE VARIABLE cEvent AS CHARACTER NO-UNDO.

&SCOPED-DEFINE PUBLISH-EVENTS enableFolderPage,enableFolderGroup,disableFolderPage,disableFolderGroup

ASSIGN cList = DYNAMIC-FUNCTION('linkHandles':U, 'Page-Target':U).

DO iCountX = 1 TO NUM-ENTRIES(cList):

    ASSIGN pHandle = WIDGET-HANDLE(ENTRY(iCountX,cList)).

    IF VALID-HANDLE(pHandle) 
    THEN 
    DO iCountY = 1 TO NUM-ENTRIES("{&PUBLISH-EVENTS}":U):

        ASSIGN cEvent = ENTRY(iCountY,"{&PUBLISH-EVENTS}":U).

        SUBSCRIBE TO cEvent IN pHandle.
    END.
END.

SUBSCRIBE TO "SelectPrevTab" IN hContainer.
SUBSCRIBE TO "SelectNextTab" IN hContainer.
SUBSCRIBE TO "SelectNextTabCycle" IN hContainer.

/* establish keyboard triggers in the container itself */

    DEFINE VARIABLE hContainerHandle AS HANDLE NO-UNDO.
    DEFINE VARIABLE hFrame AS HANDLE NO-UNDO.



    {get ContainerHandle hContainerHandle hContainer}.

    CASE hContainerHandle:TYPE:
        WHEN "FRAME"  THEN ASSIGN hFrame = hContainerHandle.
        WHEN "WINDOW" THEN ASSIGN hFrame = hContainerHandle:FIRST-CHILD.                             
    END CASE.

    IF VALID-HANDLE (hFrame) THEN ON "CTRL-TAB" OF hFrame PERSISTENT RUN SelectNextTabCycle IN THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _selectTab s-object 
PROCEDURE _selectTab PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Visualize Tab selection
  Parameters:  Tab array index
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER ipTabNo AS INTEGER NO-UNDO.

  /* Sometimes there is an error - think it's a timing issue
     where a page is sent that is not valid yet - we then
     get an error of an invalid handle and PRIVATE-DATA etc.
     Added this line to get rid of this error.
     Mark Davies (MIP) 09/11/2002 */
  DEFINE VARIABLE lSessionImmediateDisplay  AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE iCounter                  AS INTEGER  NO-UNDO.
  
  IF NOT VALID-HANDLE(hTabLabel[ipTabNo]) THEN
    RETURN.

  IF gcVisualization = "TABS":U THEN
  DO:
    ASSIGN
        iSelectedRow     = INT(hTabLabel[ipTabNo]:PRIVATE-DATA)
        iSelectedPanel   = hTabFrame[iSelectedRow]:RULE-ROW
        hSelFrame:HIDDEN = TRUE.

    /* When a tab is selected from an upper row, the row is first swapped with the
       current row. Although the frames containing tabs do not overlay each other 
       Progress insists on refreshing adjacent frames. The sequence of assignments 
       in this block is designed to minimise any flickering effect. The assigment
       order of X and Y co-ordinates is deliberate. */
 
    IF iSelectedRow <> iCurrentRow AND VALID-HANDLE(hTabFrame[iSelectedRow]) THEN
      ASSIGN
          sx = hTabFrame[iSelectedRow]:X
          sy = hTabFrame[iSelectedRow]:Y
    
          /* Move the rows - quickly and with minimal flicker */
          lResult                                   = hTabFrame[iSelectedRow]:MOVE-TO-BOTTOM()
          hTabFrame[iSelectedRow]:Y                 = hTabFrame[iCurrentRow]:Y
          hTabFrame[iSelectedRow]:X                 = hTabFrame[iCurrentRow]:X
          lResult                                   = hTabFrame[iSelectedRow]:MOVE-TO-TOP()
          lResult                                   = hTabFrame[iCurrentRow]:MOVE-TO-BOTTOM()
          hTabFrame[iCurrentRow]:X                  = sx
          hTabFrame[iCurrentRow]:Y                  = sy
          hTabFrame[iCurrentRow]:HIDDEN             = hTabFrame[iSelectedRow]:HIDDEN
          lResult                                   = hTabFrame[iCurrentRow]:MOVE-TO-TOP()
          hTabFrame[iCurrentRow]:RULE-ROW           = iSelectedPanel
          hTabFrame[iSelectedRow]:RULE-ROW          = 1
          hPanelFrame[1]:PRIVATE-DATA               = STRING(iSelectedRow)
          hPanelFrame[iSelectedPanel]:PRIVATE-DATA  = STRING(iCurrentRow)
          hTabFrame[iSelectedRow]:HIDDEN            = FALSE
          iCurrentRow                               = iSelectedRow.
  END.
  
  /* Hide and then resize the selector tab to provide visualisation of the selection. 
     The frame width of the selector frame is the width of the selected tab plus the
     value of {&TAB-PIXEL-OFFSET}. Also, If the tab isn't the last tab on a full row 
     (when the remainder of ipTabNo/iTabsPerRow <> 0) then we add a couple of
     pixels so that it appears to overlay on both the left and right sides. The amount
     of overlay is held in iSelectorWidth. */
  ASSIGN
      hSelFrame:SCROLLABLE            = TRUE
      /* not sure the following actually does anything */
      hSelFrame:X                     = IF gcVisualization = "TABS":U THEN 0 ELSE 2
      lResult                         = ipTabNo MODULO iTabsPerRow = 0 
      x                               = hTabMain[ipTabNo]:WIDTH-PIXELS + {&TAB-PIXEL-OFFSET} + (IF lResult THEN 1 ELSE iSelectorWidth)
      x                               = IF gcVisualization = "TABS":U THEN x ELSE iThisTabSize + 5
      hSelFrame:WIDTH-PIXELS          = x + 3
      hSelMain:WIDTH-PIXELS           = MAX(1,x - 1)
      hSelLDot:WIDTH-PIXELS           = IF lUpperTabs THEN 1 ELSE hSelMain:WIDTH-PIXELS + 1
      hSelLabel:WIDTH-PIXELS          = hSelFrame:WIDTH-PIXELS - hSelLabel:X - 2
      hSelLGry:WIDTH-PIXELS           = hSelLabel:WIDTH-PIXELS + 1
      hSelRDot:X                      = hSelFrame:WIDTH-PIXELS - 2 
      hSelRBla:X                      = hSelFrame:WIDTH-PIXELS - 1
      hSelRGry:X                      = hSelFrame:WIDTH-PIXELS - 2
      /*     
      hSelRGry:FGCOLOR = if session:window-system eq 'MS-WINXP' and not lresult 
                         then COLOR-ButtonShadow
                         else hTabRGry[1]:FGCOLOR
       */
      hSelFrame:X                     = IF gcVisualization = "TABS":U THEN 
                                        (hTabLWht[ipTabNo]:X - {&TAB-PIXEL-OFFSET}  
                                        + (if session:window-system eq 'MS-WINXP'
                                           and not lresult 
                                           then 1 
                                           else 0))
                                        ELSE 2
      hSelRBla:Y                      = IF lUpperTabs THEN hSelRBla:Y
                                                      ELSE IF NOT lResult THEN 1
                                                                          ELSE 0

      hSelRBla:HEIGHT-PIXELS          = IF lUpperTabs THEN hSelRBla:HEIGHT-PIXELS
                                                      ELSE IF NOT lResult THEN hSelLWht:HEIGHT-PIXELS - 1
                                                                          ELSE hSelLWht:HEIGHT-PIXELS

      hSelLabel:SCREEN-VALUE          = IF gcVisualization = "TABS":U THEN hTabLabel[ipTabNo]:SCREEN-VALUE ELSE "":U

      hSelFrame:VIRTUAL-WIDTH-PIXELS  = hSelFrame:WIDTH-PIXELS
      hSelLabel:FGCOLOR               = IF iaTabFGColor[ipTabNo] = ? THEN (IF iSelectorFGColor = ? THEN COLOR-ButtonText
                                                                                                   ELSE iSelectorFGColor)
                                                                     ELSE IF hTabLabel[ipTabNo]:SENSITIVE THEN iaTabFGColor[ipTabNo]
                                                                                                          ELSE iaTabINColor[ipTabNo]

      hSelLabel:BGCOLOR               = IF iaTabBGColor[ipTabNo] = ? THEN (IF iSelectorBGColor = ? THEN COLOR-ButtonFace
                                                                                                   ELSE iSelectorBGColor)
                                                                     ELSE iaTabBGColor[ipTabNo]
      lResult                          = IF VALID-HANDLE(hTabIcon[ipTabNo]) THEN hSelIcon:LOAD-IMAGE(caTabImage[ipTabNo],iaTabXOffset[ipTabNo],iaTabYOffset[ipTabNo],iImageWidth,iImageHeight)
                                                                            ELSE FALSE
      hSelIcon:HIDDEN                  = NOT lResult
      hSelFrame:SCROLLABLE             = FALSE
      hSelFrame:HIDDEN                 = FALSE NO-ERROR.
  
  CASE gcVisualization:
    WHEN "COMBO-BOX":U THEN
      IF VALID-HANDLE(ghDisplayWidget) THEN
        ASSIGN
            ghDisplayWidget:WIDTH-CHARS = hSelLabel:WIDTH-CHARS - ghDisplayWidget:COLUMN + 0.25
            ghDisplayWidget:VISIBLE     = TRUE NO-ERROR.
    
    WHEN "RADIO-SET":U THEN
      IF VALID-HANDLE(ghDisplayWidget) THEN
        ghDisplayWidget:VISIBLE = TRUE NO-ERROR.
  END CASE.

  IF gcVisualization <> "TABS":U THEN
  DO:
    hPanelFrame[1]:MOVE-TO-TOP().
    FRAME {&FRAME-NAME}:MOVE-TO-BOTTOM().
    
    IF NOT glDontUpdateCurrentTab THEN
      ghDisplayWidget:SCREEN-VALUE = STRING(ipTabNo) NO-ERROR.
  END.
  
  IF NOT glDontUpdateCurrentTab THEN
    iCurrentTab = ipTabNo.

  glDontUpdateCurrentTab = FALSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _trgPopupMenu s-object 
PROCEDURE _trgPopupMenu PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phWidget AS HANDLE     NO-UNDO.

  DEFINE VARIABLE iCounter  AS INTEGER    NO-UNDO.

  IF UIBMode()                                             OR
     NUM-ENTRIES(getFolderLabels(), "{&DELIMITER}":U) <= 1 OR
     NOT getPopupSelectionEnabled()                        THEN
    RETURN.

  /* Delete the popup-menu items so they can be recreated. Particularly if pages have been enabled / disabled
     for security, or if page labels changed - because of design tools, etc. */
  DO iCounter = 1 TO {&MAX-TABS}:
    IF VALID-HANDLE(ghMenuItems[iCounter]) THEN
      DELETE OBJECT ghMenuItems[iCounter].
  END.

  /* Clear the frame's popup menu */
  IF phWidget:TYPE = "TEXT":U THEN
    phWidget = hTabFrame[1].

  phWidget:POPUP-MENU = ?.

  /* Delete the popup-menu */
  IF VALID-HANDLE(ghPopupMenu) THEN
    DELETE OBJECT ghPopupMenu.

  /* Construct the new menu */
  CREATE MENU ghPopupMenu {&IN-WIDGET-POOL}
  ASSIGN
      POPUP-ONLY = TRUE.

  DO iCounter = 1 TO iTabCount:
    IF VALID-HANDLE(hTabLabel[iCounter]) THEN
    DO:
      /* Popup Menu Items */
      CREATE MENU-ITEM ghMenuItems[iCounter] {&IN-WIDGET-POOL}
      ASSIGN
	  TOGGLE-BOX = TRUE
	  PARENT     = ghPopupMenu
	  LABEL      = STRING(iCounter - (IF {fn getLogicalObjectName hContainer} = "rycntpshtw":U THEN 1 ELSE 0))
		     + " - ":U + hTabLabel[iCounter]:SCREEN-VALUE
	  SENSITIVE  = hTabLabel[iCounter]:SENSITIVE
	  CHECKED    = FALSE
      TRIGGERS:
	ON VALUE-CHANGED PERSISTENT RUN _labelTrigger IN THIS-PROCEDURE (INTEGER(iCounter)).
      END TRIGGERS.
    END.
  END.

  IF VALID-HANDLE(ghMenuItems[iCurrentTab]) THEN
    ghMenuItems[iCurrentTab]:CHECKED = TRUE.
  
  phWidget:POPUP-MENU = ghPopupMenu.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _widgetTrigger s-object 
PROCEDURE _widgetTrigger PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN _labelTrigger (INPUT INTEGER(ghDisplayWidget:SCREEN-VALUE)).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */
&IF DEFINED(EXCLUDE-setFolderWidgetIDs) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFolderWidgetIDs Procedure
FUNCTION setFolderWidgetIDs RETURNS LOGICAL 
  (INPUT pcWidgetIDs AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set FolderWidgetIDs pcWidgetIDs}.
  RETURN TRUE.   /* Function return value. */
END FUNCTION.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
&IF DEFINED(EXCLUDE-getFolderWidgetIDs) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFolderWidgetIDs Procedure
FUNCTION getFolderWidgetIDs RETURNS CHARACTER 
	(  ):
/*------------------------------------------------------------------------------
    Purpose:
    Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cWidgetIDs AS CHARACTER NO-UNDO.
  {get FolderWidgetIDs cWidgetIDs}.
  RETURN cWidgetIDs.
END FUNCTION.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION calcTabHeightPixels s-object 
FUNCTION calcTabHeightPixels RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Depending on the visualization, calculate the height needed for a tab
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iTabHeightPixels  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iTabRows          AS INTEGER    NO-UNDO.

  ASSIGN    
      iTabHeightPixels = iImageHeight + iImageYOffset                                                  /* Tab height is larger of text height or image height (image height is zero when not used) */
      iTabHeightPixels = MAX(iTabHeightPixels + 2, FONT-TABLE:GET-TEXT-HEIGHT-PIXELS(iTabFont) + iTabHeight + iLabelOffset).

  CASE gcVisualization:
    WHEN "COMBO-BOX":U THEN
      iTabHeightPixels = MAX(iTabHeightPixels, 1.24 * SESSION:PIXELS-PER-ROW).
    
    WHEN "RADIO-SET":U THEN
      ASSIGN
          iTabRows         = TRUNCATE(NUM-ENTRIES(getFolderLabels(), "|":U) / getTabsPerRow(), 0) + 1
          iTabHeightPixels = MAX(iTabHeightPixels, 0.85 * SESSION:PIXELS-PER-ROW).
  END CASE.

  RETURN iTabHeightPixels.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION calcWidestLabel s-object 
FUNCTION calcWidestLabel RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Step through the labels of the folder and calculate the width of the
            widest label. This is needed (and called) when the size is determined
            for the combo-box (when visualization is Combo-Box)
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFolderLabels AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iFontWidth    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCounter      AS INTEGER    NO-UNDO.
  
  ASSIGN
      cFolderLabels = {fn getFolderLabels}
      cFolderLabels = REPLACE(cFolderLabels, "&":U, "":U).
  
  DO iCounter = 1 TO NUM-ENTRIES(cFolderLabels, "{&DELIMITER}":U):
    
    iFontWidth = MAX(iFontWidth, FONT-TABLE:GET-TEXT-WIDTH-PIXELS(ENTRY(iCounter, cFolderLabels, "{&DELIMITER}":U), 0)).
  END.

  RETURN iFontWidth.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION constructFolderLabels s-object 
FUNCTION constructFolderLabels RETURNS LOGICAL
  (pcFolderLabels AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  This function re-contstructs the folder labels (if they changed)
            and ensures the objects sizes correctly. This is mainly a requirement
            for the Container Builder
    Notes:  
------------------------------------------------------------------------------*/
  {fnarg setFolderLabels pcFolderLabels}.

  iCurrentRow = 1.

  RUN _getProperties.

  RUN _initializeObject.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDisplayWidget s-object 
FUNCTION getDisplayWidget RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  To return the handle of the alternate display widget. (Called from
            the translation window for translation purposes
    Notes:  
------------------------------------------------------------------------------*/

  RETURN ghDisplayWidget.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInnerCol s-object 
FUNCTION getInnerCol RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return inner Col relative to container  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN (2 / SESSION:PIXELS-PER-COL)
         + FRAME {&FRAME-NAME}:COL.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInnerHeight s-object 
FUNCTION getInnerHeight RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return inner width   
    Notes:  
------------------------------------------------------------------------------*/
  RETURN (iPanelFrameHeight - 4) / SESSION:PIXELS-PER-ROW. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInnerRow s-object 
FUNCTION getInnerRow RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return inner Row relative to container 
    Notes:  
------------------------------------------------------------------------------*/

  RETURN (IF getTabPosition() = "Upper":U THEN getTabRowHeight() ELSE 0) + (2 / SESSION:PIXELS-PER-ROW) + FRAME {&FRAME-NAME}:ROW.
           
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInnerWidth s-object 
FUNCTION getInnerWidth RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return inner width   
    Notes:  
------------------------------------------------------------------------------*/
  RETURN (iPanelFrameWidth - 4) / SESSION:PIXELS-PER-COL.    
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNoWarnings s-object 
FUNCTION getNoWarnings RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

RETURN NoWarnings.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPanelsMinWidth s-object 
FUNCTION getPanelsMinWidth RETURNS DECIMAL
    ( /**/ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the minimum width the tabs take up.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dMinWidth           AS DECIMAL                      NO-UNDO.
    DEFINE VARIABLE dPanelWidth         AS DECIMAL                      NO-UNDO.
    DEFINE VARIABLE iTabCount           AS INTEGER                      NO-UNDO.

    /* Ensure that the property values are set. */
    IF NOT glInitializing 
    OR NOT glPropertyValuesFetched THEN
        RUN _getPropertyValues IN TARGET-PROCEDURE.

    DO iTabCount = 1 TO iTabTotal:        
        IF iTabCount MOD iTabsPerRow EQ 1 THEN
            ASSIGN dPanelWidth = 0.

        ASSIGN iThisTabSize = IF {&TABS-ARE-AUTOSIZED} THEN 
                                iTabAutoWidth 
                            ELSE
                                FONT-TABLE:GET-TEXT-WIDTH-PIXELS(caFolderLabel[iTabCount],iTabFont) + 3 + iTabImageTotal + {&TAB-PIXEL-OFFSET}
                        .
        ASSIGN dPanelWidth = dPanelWidth + iThisTabSize
               dMinWidth = MAX(dPanelWidth, dMinWidth)
               .
    END.    /* loop through tabs */

    /* We add a little bit to ensure that the last tab is seen. */
    RETURN (dMinWidth / SESSION:PIXELS-PER-COLUMN) + 2.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTabRowHeight s-object 
FUNCTION getTabRowHeight RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  This function calculates the display area height of the tabs. The total
            height the tabs will take up is calculated here, i.e. even if multi-rowed
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iTabRows  AS INTEGER    NO-UNDO.

  /* If iTabHeightPixels is zero, the folder has not been initialized yet. This calculation was copied from _initializeObject */
  IF iTabHeightPixels = 0 THEN
    ASSIGN 
        iTabHeightPixels = calcTabHeightPixels().

  IF iPanelTotal = 0 THEN
    iTabRows = TRUNCATE(NUM-ENTRIES(getFolderLabels(), "|":U) / getTabsPerRow(), 0) + 1.
  ELSE
    iTabRows = iPanelTotal.

  IF gcVisualization <> "TABS":U THEN
    iTabRows = 1.

  RETURN ((iTabHeightPixels * iTabRows) + {&TAB-PIXEL-OFFSET}) / SESSION:PIXELS-PER-ROW.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTabsEnabled s-object 
FUNCTION getTabsEnabled RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Pass back flag indicating whether there are any tabs enabled at all.
           Used by container to set a panel state no-tabs-enabled in the toolbar
           to prevent user from changing mode. 
    Notes:  
------------------------------------------------------------------------------*/

  RETURN glTabsEnabled.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNoWarnings s-object 
FUNCTION setNoWarnings RETURNS LOGICAL
  ( INPUT pNoWarnings AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

ASSIGN NoWarnings = pNoWarnings NO-ERROR. 

RETURN ERROR-STATUS:ERROR.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

