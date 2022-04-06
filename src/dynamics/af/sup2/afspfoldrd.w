&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/***********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*------------------------------------------------------------------------

  File: folderd.p

  Description: SmartFolder Property Dialog

  Input Parameters:
      Calling object handle

  Output Parameters:
      <none>

  (v:010002)    Task:           0   UserRef:
                Date:   04/23/2002  Author:     Sunil Belgaonkar

  Update Notes: Changed the image from .bmp to .gif format.

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

&IF DEFINED(UIB_is_Running) NE 0
&THEN
    DEFINE VARIABLE ip-caller AS HANDLE NO-UNDO.
&ELSE
    DEFINE INPUT PARAMETER ip-caller AS HANDLE NO-UNDO.
&ENDIF

DEFINE VARIABLE ImageLoaded  AS LOGICAL NO-UNDO.
DEFINE VARIABLE IconsLoaded  AS LOGICAL NO-UNDO.

DEFINE VARIABLE wh AS HANDLE NO-UNDO.

DEFINE VARIABLE iCount AS INTEGER NO-UNDO.

DEFINE VARIABLE vText AS CHARACTER NO-UNDO.

DEFINE VARIABLE vResult AS LOGICAL NO-UNDO.

DEFINE VARIABLE hSelect AS HANDLE NO-UNDO.

&SCOPED-DEFINE DELIMITER |

&GLOBAL-DEFINE OTYPE tabs

&GLOBAL-DEFINE PRIMARY-PROPERTY FolderLabels

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME gDialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK Btn_Cancel 

/* Custom List Definitions                                              */
/* Initial,Index,List-Items,Color-List,Font-List,Icon-List              */
&Scoped-define Initial fiTabFGColor fiTabBGColor fiTabINColor 
&Scoped-define Index fiTabLabel 
&Scoped-define List-Items fiEnableStates fiDisableStates 
&Scoped-define Color-List fiSelectorFGColor fiTabFGColor fiSelectorBGColor ~
fiTabBGColor fiTabINColor 
&Scoped-define Font-List fiTabFont fiSelectorFont 
&Scoped-define Icon-List fiImageDisabled fiImageEnabled 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-btn_About 
       MENU-ITEM m_Verify_Mode  LABEL "Verify Mode"   
              TOGGLE-BOX.


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn_Apply 
     LABEL "&Apply" 
     SIZE 14 BY 1.14 TOOLTIP "Apply Changes without Closing".

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 14 BY 1.14 TOOLTIP "Undo & Close".

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 14 BY 1.14 TOOLTIP "Apply & Close".

DEFINE BUTTON btn-lookup  NO-FOCUS
     LABEL "..." 
     SIZE 2.8 BY .81.

DEFINE BUTTON btn_About 
     IMAGE-UP FILE "ry/img/smartpak.gif":U
     IMAGE-DOWN FILE "ry/img/smartpak.gif":U
     IMAGE-INSENSITIVE FILE "ry/img/smartpak.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "A&bout..." 
     SIZE 6.4 BY 1.52 TOOLTIP "About...".

DEFINE VARIABLE cbposition AS CHARACTER FORMAT "X(256)":U INITIAL "Upper" 
     LABEL "&Orientation" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Upper","Lower" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cbSizing AS CHARACTER FORMAT "X(256)":U INITIAL "AutoSized" 
     LABEL "&Sizing Method" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Autosized","Proportional","Justified" 
     DROP-DOWN-LIST
     SIZE 21.4 BY 1 NO-UNDO.

DEFINE VARIABLE cbVisualization AS CHARACTER FORMAT "X(256)":U INITIAL "Tabs" 
     LABEL "&Visualization" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Combo-Box","Radio-Set","Tabs" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE fiFolderMenu AS CHARACTER FORMAT "X(256)":U 
     LABEL "Folder Menu" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 53.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiImageHeight AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "&Image H&eight" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE fiImageWidth AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "&Image Width" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE fiImageXOffset AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Image &X Offset" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE fiImageYOffset AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Image &Y Offset" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE fiLabelOffset AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "&Label Offset" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE fiPanelOffset AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Panel &Offset" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE fiSelectorBGColor AS CHARACTER FORMAT "X(256)":U INITIAL "Default" 
     LABEL "Sel. &Background" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 21.4 BY 1 NO-UNDO.

DEFINE VARIABLE fiSelectorFGColor AS CHARACTER FORMAT "X(256)":U INITIAL "Default" 
     LABEL "Sel. &Foreground" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 21.4 BY 1 NO-UNDO.

DEFINE VARIABLE fiSelectorFont AS INTEGER FORMAT ">>>9":U INITIAL 4 
     LABEL "Selecto&r Font" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE fiSelectorWidth AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Selector &Width" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE fiTabFont AS INTEGER FORMAT ">>>9":U INITIAL 4 
     LABEL "Tab Fo&nt" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE fiTabHeight AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Tab &Height" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE fiTabsPerRow AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "&Tabs Per Row" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE fiTitle AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 61.8 BY .86
     FGCOLOR 1 FONT 6 NO-UNDO.

DEFINE VARIABLE fiVisibleRows AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "&Visible Rows" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 10 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73 BY .1.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73 BY .1.

DEFINE VARIABLE tbInherit AS LOGICAL INITIAL no 
     LABEL "Inherit &Parent Color" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .81 NO-UNDO.

DEFINE VARIABLE tbPopupSelection AS LOGICAL INITIAL yes 
     LABEL "Popup Selection Enabled" 
     VIEW-AS TOGGLE-BOX
     SIZE 28.4 BY .81 NO-UNDO.

DEFINE VARIABLE tbResize AS LOGICAL INITIAL no 
     LABEL "&Disable Resize Warnings" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .81 NO-UNDO.

DEFINE BUTTON Btn-Add  NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 4.8 BY 1.14 TOOLTIP "Add/Modify List Item (Ins)".

DEFINE BUTTON Btn-Delete  NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 4.8 BY 1.14 TOOLTIP "Delete (Alt-Del)".

DEFINE BUTTON Btn-Insert  NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 4.8 BY 1.14 TOOLTIP "Insert (Alt-Ins)".

DEFINE BUTTON Btn-Left  NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 4.8 BY 1.14 TOOLTIP "Move Left (Alt-Left)".

DEFINE BUTTON btn-lookup-2  NO-FOCUS
     LABEL "..." 
     SIZE 2.8 BY .81.

DEFINE BUTTON Btn-Next  NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 4.8 BY 1.14 TOOLTIP "Select Next (Alt-Down)".

DEFINE BUTTON Btn-Previous  NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 4.8 BY 1.14 TOOLTIP "Select Previous (Alt-Up)".

DEFINE BUTTON Btn-Remove  NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 4.8 BY 1.14 TOOLTIP "Delete List Item (Del)".

DEFINE BUTTON Btn-Right  NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 4.8 BY 1.14 TOOLTIP "Move Right (Alt-Right)".

DEFINE VARIABLE fiDisableStates AS CHARACTER FORMAT "X(256)":U INITIAL "All" 
     LABEL "Di&sable Grp(s)" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     DROP-DOWN-LIST
     SIZE 55.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiEnableStates AS CHARACTER FORMAT "X(256)":U INITIAL "All" 
     LABEL "E&nable Grp(s)" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "All" 
     DROP-DOWN-LIST
     SIZE 55.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiIndex AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Inde&x" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 8
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 9 BY 1
     FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE fiHotkey AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Shortcut" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 55.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiImageDisabled AS CHARACTER FORMAT "X(256)":U 
     LABEL "Image &Enabled" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 55.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiImageEnabled AS CHARACTER FORMAT "X(256)":U 
     LABEL "Image &Disabled" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 55.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiTabBGColor AS CHARACTER FORMAT "X(256)":U INITIAL "Default" 
     LABEL "&Background" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 55.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiTabFGColor AS CHARACTER FORMAT "X(256)":U INITIAL "Default" 
     LABEL "&Foreground" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 55.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiTabINColor AS CHARACTER FORMAT "X(256)":U INITIAL "GrayText" 
     LABEL "&Insensitive" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 55.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiTabLabel AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Label" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 55.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiTooltip AS CHARACTER FORMAT "X(256)":U 
     LABEL "T&ooltip" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 55.6 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73 BY .1.

DEFINE VARIABLE tbTabHidden AS LOGICAL INITIAL no 
     LABEL "&Hidden" 
     VIEW-AS TOGGLE-BOX
     SIZE 11 BY .81 NO-UNDO.

DEFINE BUTTON btn-browse 
     LABEL "&Browse..." 
     SIZE 26 BY 1.14.

DEFINE BUTTON mouse-test  NO-FOCUS
     LABEL "" 
     SIZE 25 BY 11.81.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 999  NO-FILL   
     SIZE 26.4 BY 12.05.

DEFINE VARIABLE slMousePointer AS CHARACTER INITIAL "Arrow" 
     VIEW-AS SELECTION-LIST SINGLE NO-DRAG SCROLLBAR-VERTICAL 
     LIST-ITEMS "AppStarting","Arrow","Cross","Help","IBeam","No","Size","Size-E","Size-N","Size-NE","Size-NW","Size-S","Size-SE","Size-SW","Size-W","UpArrow","Wait","Glove","Compiler-Wait" 
     SIZE 41.4 BY 12.1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     Btn_OK AT ROW 19.71 COL 36
     Btn_Cancel AT ROW 19.71 COL 50.8
     btn_Apply AT ROW 19.71 COL 65.6
     SPACE(0.59) SKIP(0.00)
    WITH VIEW-AS DIALOG-BOX NO-HELP 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D  SCROLLABLE 
         TITLE "Edit Properties"
         DEFAULT-BUTTON Btn_OK.

DEFINE FRAME FRAME-C
     mouse-test AT ROW 3.05 COL 47.6
     slMousePointer AT ROW 2.91 COL 4.6 NO-LABEL
     btn-browse AT ROW 15.52 COL 47
     "Mouse Cursor:" VIEW-AS TEXT
          SIZE 14 BY .57 AT ROW 2 COL 4.8
     RECT-2 AT ROW 2.95 COL 47
    WITH 1 DOWN NO-BOX NO-HIDE KEEP-TAB-ORDER OVERLAY NO-HELP 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 3.4 ROW 2.48
         SIZE 75.2 BY 16.29.

DEFINE FRAME FRAME-B
     btn-lookup-2 AT ROW 1.91 COL 24
     fiIndex AT ROW 1.81 COL 16.2 COLON-ALIGNED
     fiTabLabel AT ROW 3.19 COL 16.2 COLON-ALIGNED HELP
          "FolderLabels"
     fiTooltip AT ROW 4.33 COL 16.2 COLON-ALIGNED HELP
          "Tooltip"
     fiHotkey AT ROW 5.48 COL 16.2 COLON-ALIGNED HELP
          "Hotkey"
     fiTabFGColor AT ROW 6.86 COL 16.2 COLON-ALIGNED HELP
          "TabFGColor"
     fiTabBGColor AT ROW 8 COL 16.2 COLON-ALIGNED HELP
          "TabBGColor"
     fiTabINColor AT ROW 9.14 COL 16.2 COLON-ALIGNED HELP
          "TabINColor"
     fiImageDisabled AT ROW 10.52 COL 16.2 COLON-ALIGNED HELP
          "ImageEnabled"
     fiImageEnabled AT ROW 11.67 COL 16.2 COLON-ALIGNED HELP
          "ImageDisabled"
     fiEnableStates AT ROW 13.14 COL 16.2 COLON-ALIGNED HELP
          "EnableStates"
     Btn-Add AT ROW 1.71 COL 57.2
     fiDisableStates AT ROW 14.29 COL 16.2 COLON-ALIGNED HELP
          "DisableStates"
     tbTabHidden AT ROW 16.29 COL 18 HELP
          "TabHidden"
     Btn-Delete AT ROW 1.71 COL 52.4
     Btn-Insert AT ROW 1.71 COL 47.6
     Btn-Left AT ROW 1.71 COL 38
     Btn-Next AT ROW 1.71 COL 33.2
     Btn-Previous AT ROW 1.71 COL 28.4
     Btn-Remove AT ROW 1.71 COL 62
     Btn-Right AT ROW 1.71 COL 42.8
     "Attributes:" VIEW-AS TEXT
          SIZE 11.2 BY .95 AT ROW 16.19 COL 5
     RECT-12 AT ROW 15.86 COL 2.4
    WITH 1 DOWN NO-BOX NO-HIDE KEEP-TAB-ORDER OVERLAY NO-HELP 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 2.8 ROW 2.19
         SIZE 76.4 BY 16.33.

DEFINE FRAME FRAME-A
     btn_About AT ROW 1.33 COL 4.4
     cbSizing AT ROW 3.76 COL 17.6 COLON-ALIGNED HELP
          "TabSize"
     cbposition AT ROW 3.81 COL 54.8 COLON-ALIGNED HELP
          "TabPosition"
     fiSelectorFGColor AT ROW 4.91 COL 17.6 COLON-ALIGNED HELP
          "SelectorFGColor"
     cbVisualization AT ROW 4.91 COL 54.8 COLON-ALIGNED HELP
          "TabVisualization"
     fiSelectorBGColor AT ROW 6.05 COL 17.6 COLON-ALIGNED HELP
          "SelectorBGColor"
     fiFolderMenu AT ROW 7.24 COL 17.6 COLON-ALIGNED HELP
          "FolderMenu"
     fiTabFont AT ROW 8.38 COL 17.6 COLON-ALIGNED HELP
          "TabFont"
     fiSelectorFont AT ROW 8.43 COL 60.8 COLON-ALIGNED HELP
          "SelectorFont"
     fiTabHeight AT ROW 9.52 COL 17.6 COLON-ALIGNED HELP
          "TabHeight"
     fiPanelOffset AT ROW 9.57 COL 60.8 COLON-ALIGNED HELP
          "PanelOffset"
     fiSelectorWidth AT ROW 10.71 COL 17.6 COLON-ALIGNED HELP
          "SelectorWidth"
     fiLabelOffset AT ROW 10.71 COL 60.8 COLON-ALIGNED HELP
          "LabelOffset"
     fiVisibleRows AT ROW 11.86 COL 17.6 COLON-ALIGNED HELP
          "VisibleRows"
     fiTabsPerRow AT ROW 11.91 COL 60.8 COLON-ALIGNED HELP
          "TabsPerRow"
     fiImageWidth AT ROW 13 COL 17.6 COLON-ALIGNED HELP
          "ImageWidth"
     fiImageHeight AT ROW 13.05 COL 60.8 COLON-ALIGNED HELP
          "ImageHeight"
     fiImageXOffset AT ROW 14.14 COL 17.6 COLON-ALIGNED HELP
          "ImageXOffset"
     fiImageYOffset AT ROW 14.19 COL 60.8 COLON-ALIGNED HELP
          "ImageYOffset"
     btn-lookup AT ROW 5 COL 37.8
     tbResize AT ROW 15.91 COL 19.8
     tbInherit AT ROW 15.91 COL 50.8 HELP
          "InheritColor"
     tbPopupSelection AT ROW 16.76 COL 19.8 HELP
          "PopupSelectionEnabled"
     fiTitle AT ROW 1.95 COL 11 COLON-ALIGNED NO-LABEL
     "Options:" VIEW-AS TEXT
          SIZE 8.2 BY .81 AT ROW 15.91 COL 8.2
     RECT-10 AT ROW 3.24 COL 1.8
     RECT-11 AT ROW 15.67 COL 1.8
    WITH 1 DOWN NO-BOX NO-HIDE KEEP-TAB-ORDER OVERLAY NO-HELP 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 3.4 ROW 2.48
         SIZE 74.8 BY 16.67.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Compile into: gui/adm2/support
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}
{af/sup2/afpropdlg.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* REPARENT FRAME */
ASSIGN FRAME FRAME-A:FRAME = FRAME gDialog:HANDLE
       FRAME FRAME-B:FRAME = FRAME gDialog:HANDLE
       FRAME FRAME-C:FRAME = FRAME gDialog:HANDLE.

/* SETTINGS FOR FRAME FRAME-A
   NOT-VISIBLE L-To-R                                                   */
ASSIGN 
       FRAME FRAME-A:HIDDEN           = TRUE.

ASSIGN 
       btn_About:POPUP-MENU IN FRAME FRAME-A       = MENU POPUP-MENU-btn_About:HANDLE.

/* SETTINGS FOR COMBO-BOX cbposition IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cbSizing IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiFolderMenu IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiImageHeight IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiImageWidth IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiImageXOffset IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiImageYOffset IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiLabelOffset IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiPanelOffset IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiSelectorBGColor IN FRAME FRAME-A
   NO-ENABLE 4                                                          */
/* SETTINGS FOR FILL-IN fiSelectorFGColor IN FRAME FRAME-A
   NO-ENABLE 4                                                          */
/* SETTINGS FOR FILL-IN fiSelectorFont IN FRAME FRAME-A
   NO-ENABLE 5                                                          */
/* SETTINGS FOR FILL-IN fiSelectorWidth IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiTabFont IN FRAME FRAME-A
   NO-ENABLE 5                                                          */
/* SETTINGS FOR FILL-IN fiTabHeight IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiTabsPerRow IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiVisibleRows IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tbInherit IN FRAME FRAME-A
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME FRAME-B
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME FRAME-B:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX fiDisableStates IN FRAME FRAME-B
   NO-ENABLE 3                                                          */
ASSIGN 
       fiDisableStates:PRIVATE-DATA IN FRAME FRAME-B     = 
                "All".

/* SETTINGS FOR COMBO-BOX fiEnableStates IN FRAME FRAME-B
   NO-ENABLE 3                                                          */
ASSIGN 
       fiEnableStates:PRIVATE-DATA IN FRAME FRAME-B     = 
                "All".

/* SETTINGS FOR FILL-IN fiHotkey IN FRAME FRAME-B
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiImageDisabled IN FRAME FRAME-B
   NO-ENABLE 6                                                          */
/* SETTINGS FOR FILL-IN fiImageEnabled IN FRAME FRAME-B
   NO-ENABLE 6                                                          */
/* SETTINGS FOR COMBO-BOX fiIndex IN FRAME FRAME-B
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN fiTabBGColor IN FRAME FRAME-B
   NO-ENABLE 1 4                                                        */
/* SETTINGS FOR FILL-IN fiTabFGColor IN FRAME FRAME-B
   NO-ENABLE 1 4                                                        */
/* SETTINGS FOR FILL-IN fiTabINColor IN FRAME FRAME-B
   NO-ENABLE 1 4                                                        */
/* SETTINGS FOR FILL-IN fiTabLabel IN FRAME FRAME-B
   NO-ENABLE 2                                                          */
ASSIGN 
       fiTabLabel:PRIVATE-DATA IN FRAME FRAME-B     = 
                "Label &1".

/* SETTINGS FOR FILL-IN fiTooltip IN FRAME FRAME-B
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tbTabHidden IN FRAME FRAME-B
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME FRAME-C
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME FRAME-C:HIDDEN           = TRUE.

/* SETTINGS FOR DIALOG-BOX gDialog
   NOT-VISIBLE EXP-POSITION FRAME-NAME                                  */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:ROW              = 5
       FRAME gDialog:COLUMN           = 13
       FRAME gDialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON btn_Apply IN FRAME gDialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME FRAME-A
/* Query rebuild information for FRAME FRAME-A
     _Query            is NOT OPENED
*/  /* FRAME FRAME-A */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME FRAME-B
/* Query rebuild information for FRAME FRAME-B
     _Query            is NOT OPENED
*/  /* FRAME FRAME-B */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME FRAME-C
/* Query rebuild information for FRAME FRAME-C
     _Query            is NOT OPENED
*/  /* FRAME FRAME-C */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON ALT-C OF FRAME gDialog /* Edit Properties */
ANYWHERE
DO:
    RUN selectPage(3).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON ALT-G OF FRAME gDialog /* Edit Properties */
ANYWHERE
DO:
    RUN selectPage(1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON ALT-T OF FRAME gDialog /* Edit Properties */
ANYWHERE
DO:
    RUN selectPage(2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON CTRL-PAGE-DOWN OF FRAME gDialog /* Edit Properties */
ANYWHERE
DO:
  IF getCurrentPage() < 2 THEN RUN selectPage(2).
  ELSE
  IF getCurrentPage() < 3 THEN RUN selectPage(3).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON CTRL-PAGE-UP OF FRAME gDialog /* Edit Properties */
ANYWHERE
DO:
   IF getCurrentPage() > 2 THEN RUN selectPage(2).
   ELSE
   IF getCurrentPage() > 1 THEN RUN selectPage(1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* Edit Properties */
DO:
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FRAME-A
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FRAME-A gDialog
ON ENTRY OF FRAME FRAME-A
ANYWHERE
DO:
    IF SELF:TYPE = "FILL-IN"
    AND LOOKUP(SELF:NAME,"{&COLOR-LIST} {&FONT-LIST} {&ICON-LIST}"," ") > 0
    THEN
        ASSIGN Btn-Lookup:X = SELF:X + SELF:WIDTH-PIXELS - Btn-Lookup:WIDTH-PIXELS - 2
               Btn-Lookup:Y = SELF:Y + 2
               Btn-Lookup:HIDDEN = FALSE
               vResult = Btn-Lookup:MOVE-TO-TOP().

    ASSIGN FRAME FRAME-A:PRIVATE-DATA = STRING(SELF:HANDLE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FRAME-A gDialog
ON LEAVE OF FRAME FRAME-A
ANYWHERE
DO:
    ASSIGN Btn-Lookup:HIDDEN = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FRAME-A gDialog
ON VALUE-CHANGED OF FRAME FRAME-A
ANYWHERE
DO:
    ASSIGN Btn_Apply:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FRAME-B
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FRAME-B gDialog
ON ALT-CURSOR-DOWN OF FRAME FRAME-B
ANYWHERE
DO:
    APPLY "CHOOSE" TO Btn-Next.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FRAME-B gDialog
ON ALT-CURSOR-LEFT OF FRAME FRAME-B
ANYWHERE
DO:
    APPLY "CHOOSE" TO Btn-Left.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FRAME-B gDialog
ON ALT-CURSOR-RIGHT OF FRAME FRAME-B
ANYWHERE
DO:
    APPLY "CHOOSE" TO Btn-Right.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FRAME-B gDialog
ON ALT-CURSOR-UP OF FRAME FRAME-B
ANYWHERE
DO:
    APPLY "CHOOSE" TO Btn-Previous.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FRAME-B gDialog
ON ALT-DEL OF FRAME FRAME-B
ANYWHERE
DO:
    APPLY "CHOOSE" TO Btn-Delete.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FRAME-B gDialog
ON ALT-END OF FRAME FRAME-B
ANYWHERE
DO:
   RUN formLast.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FRAME-B gDialog
ON ALT-HOME OF FRAME FRAME-B
ANYWHERE
DO:
    RUN formFirst.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FRAME-B gDialog
ON ALT-INS OF FRAME FRAME-B
ANYWHERE
DO:
    APPLY "CHOOSE" TO Btn-Insert.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FRAME-B gDialog
ON DELETE-CHARACTER OF FRAME FRAME-B
ANYWHERE
DO:
    IF LOOKUP(SELF:NAME,"{&LIST-ITEMS}"," ") > 0
    THEN DO:
        APPLY "CHOOSE" TO Btn-Remove.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FRAME-B gDialog
ON ENTRY OF FRAME FRAME-B
ANYWHERE
DO:
    IF SELF:TYPE = "FILL-IN":U
    AND LOOKUP(SELF:NAME,"{&COLOR-LIST} {&FONT-LIST} {&ICON-LIST}"," ") > 0
    THEN
        ASSIGN Btn-Lookup-2:X = SELF:X + SELF:WIDTH-PIXELS - Btn-Lookup-2:WIDTH-PIXELS - 2
               Btn-Lookup-2:Y = SELF:Y + 2
               Btn-lookup-2:HIDDEN = FALSE
               vResult = Btn-Lookup-2:MOVE-TO-TOP().

    ASSIGN FRAME FRAME-B:PRIVATE-DATA = STRING(SELF:HANDLE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FRAME-B gDialog
ON INSERT-MODE OF FRAME FRAME-B
ANYWHERE
DO:
    IF LOOKUP(SELF:NAME,"{&LIST-ITEMS}"," ") > 0
    THEN DO:
        APPLY "CHOOSE" TO Btn-Add.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FRAME-B gDialog
ON LEAVE OF FRAME FRAME-B
ANYWHERE
DO:
  ASSIGN btn-lookup-2:HIDDEN = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FRAME-B gDialog
ON VALUE-CHANGED OF FRAME FRAME-B
ANYWHERE
DO:
    ASSIGN Btn_Apply:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE FrameChanged = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME FRAME-B
&Scoped-define SELF-NAME Btn-Add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Add gDialog
ON CHOOSE OF Btn-Add IN FRAME FRAME-B
DO:
    RUN listAdd.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME FRAME-C
&Scoped-define SELF-NAME btn-browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-browse gDialog
ON CHOOSE OF btn-browse IN FRAME FRAME-C /* Browse... */
DO:
    DEFINE VARIABLE iFilter AS INTEGER NO-UNDO INITIAL 1.

    IF slMousePointer:SCREEN-VALUE MATCHES "*.ani"
    THEN
        ASSIGN iFilter = 2.

    SYSTEM-DIALOG GET-FILE vText
        TITLE      "Choose Cursor..."
        FILTERS    "Cursor Files (*.cur)"   "*.cur",
                   "Animated Cursors (*.ani)" "*.ani",
                   "All Cursor Files (*.cur,*.ani)"   "*.cur,*.ani"
        INITIAL-FILTER iFilter
        MUST-EXIST
        UPDATE vResult.

    IF NOT vResult THEN RETURN NO-APPLY.

    ASSIGN vtext = FOLDER-OF(vtext).

    IF slMousePointer:LOOKUP(vText) = 0
    THEN
        ASSIGN vResult = IF slMousePointer:ENTRY(1) <> "AppStarting"
                         THEN slMousePointer:REPLACE(vText,1)
                         ELSE slMousePointer:ADD-FIRST(vText)
               slMousePointer:SCREEN-VALUE = vText.

    APPLY "VALUE-CHANGED" TO slMousePointer.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME FRAME-B
&Scoped-define SELF-NAME Btn-Delete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Delete gDialog
ON CHOOSE OF Btn-Delete IN FRAME FRAME-B
DO:
    RUN FormDelete.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Insert
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Insert gDialog
ON CHOOSE OF Btn-Insert IN FRAME FRAME-B
DO:
    RUN FormInsert.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Left
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Left gDialog
ON CHOOSE OF Btn-Left IN FRAME FRAME-B
DO:
    RUN FormLeft.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME FRAME-A
&Scoped-define SELF-NAME btn-lookup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-lookup gDialog
ON CHOOSE OF btn-lookup IN FRAME FRAME-A /* ... */
DO:
   ASSIGN wh = WIDGET-HANDLE(FRAME FRAME-A:PRIVATE-DATA).

   IF VALID-HANDLE(wh)
   THEN DO:

       IF LOOKUP(wh:NAME,"{&FONT-LIST}"," ") > 0 THEN RUN getFontDialog IN THIS-PROCEDURE.
       ELSE
       IF LOOKUP(wh:NAME,"{&COLOR-LIST}"," ") > 0 THEN RUN getColorDialog IN THIS-PROCEDURE.
       ELSE
       IF LOOKUP(wh:NAME,"{&ICON-LIST}"," ") > 0 THEN RUN getImageDialog IN THIS-PROCEDURE.

       APPLY "ENTRY":U TO wh.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME FRAME-B
&Scoped-define SELF-NAME btn-lookup-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-lookup-2 gDialog
ON CHOOSE OF btn-lookup-2 IN FRAME FRAME-B /* ... */
DO:
   ASSIGN wh = WIDGET-HANDLE(FRAME FRAME-B:PRIVATE-DATA).

   IF VALID-HANDLE(wh)
   THEN DO:
       IF LOOKUP(wh:NAME,"{&FONT-LIST}"," ") > 0 THEN RUN getFontDialog IN THIS-PROCEDURE.
       ELSE
       IF LOOKUP(wh:NAME,"{&COLOR-LIST}"," ") > 0 THEN RUN getColorDialog IN THIS-PROCEDURE.
       ELSE
       IF LOOKUP(wh:NAME,"{&ICON-LIST}"," ") > 0 THEN RUN getImageDialog IN THIS-PROCEDURE.

       APPLY "ENTRY":U TO wh.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Next
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Next gDialog
ON CHOOSE OF Btn-Next IN FRAME FRAME-B
DO:
    RUN FormNext.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Previous
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Previous gDialog
ON CHOOSE OF Btn-Previous IN FRAME FRAME-B
DO:
    RUN FormPrevious.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Remove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Remove gDialog
ON CHOOSE OF Btn-Remove IN FRAME FRAME-B
DO:
    RUN listRemove.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Right
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Right gDialog
ON CHOOSE OF Btn-Right IN FRAME FRAME-B
DO:
    RUN FormRight.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME FRAME-A
&Scoped-define SELF-NAME btn_About
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_About gDialog
ON CHOOSE OF btn_About IN FRAME FRAME-A /* About... */
DO:
   RUN AboutBox IN THIS-PROCEDURE NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME gDialog
&Scoped-define SELF-NAME btn_Apply
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_Apply gDialog
ON CHOOSE OF btn_Apply IN FRAME gDialog /* Apply */
DO:
    RUN setProperties.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME FRAME-B
&Scoped-define SELF-NAME fiDisableStates
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiDisableStates gDialog
ON VALUE-CHANGED OF fiDisableStates IN FRAME FRAME-B /* Disable Grp(s) */
DO:
    ASSIGN Btn_Apply:SENSITIVE IN FRAME gDialog = TRUE
           FrameChanged = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiEnableStates
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiEnableStates gDialog
ON VALUE-CHANGED OF fiEnableStates IN FRAME FRAME-B /* Enable Grp(s) */
DO:
    ASSIGN Btn_Apply:SENSITIVE IN FRAME gDialog = TRUE
           FrameChanged = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiIndex
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiIndex gDialog
ON VALUE-CHANGED OF fiIndex IN FRAME FRAME-B /* Index */
DO:
  RUN formAssign.

  ASSIGN fiIndex fiIndex = MINIMUM(fiIndex,iCount).

  RUN formDisplay IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Verify_Mode
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Verify_Mode gDialog
ON VALUE-CHANGED OF MENU-ITEM m_Verify_Mode /* Verify Mode */
DO:
    ASSIGN vVerify = SELF:CHECKED.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME FRAME-C
&Scoped-define SELF-NAME slMousePointer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL slMousePointer gDialog
ON VALUE-CHANGED OF slMousePointer IN FRAME FRAME-C
DO:
    ASSIGN vResult = mouse-test:LOAD-MOUSE-POINTER(SELF:SCREEN-VALUE)
           Btn_Apply:SENSITIVE IN FRAME gDialog = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME FRAME-A
&Scoped-define SELF-NAME tbResize
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tbResize gDialog
ON VALUE-CHANGED OF tbResize IN FRAME FRAME-A /* Disable Resize Warnings */
DO:
  {set NoWarnings SELF:CHECKED ip-caller}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME gDialog
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */

{af/sup2/afpropdlgm.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adjustTabOrder gDialog 
PROCEDURE adjustTabOrder :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER phObject   AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER phAnchor   AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER pcPosition AS CHARACTER NO-UNDO.

  RETURN NO-APPLY.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
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
             INPUT  'af/sup2/afspfoldrw.r':U ,
             INPUT  FRAME gDialog:HANDLE ,
             INPUT  'FolderLabels':U + '&General|&Tabs|&Cursor' + 'TabFGcolor':U + 'Default|Default|Default' + 'TabBGcolor':U + 'Default|Default|Default' + 'TabINColor':U + 'Default|GrayText|GrayText' + 'ImageEnabled':U + '||' + 'ImageDisabled':U + '||' + 'Hotkey':U + '||' + 'Tooltip':U + '||' + 'TabHidden':U + 'no|no|no' + 'EnableStates':U + 'ALL|All|All' + 'DisableStates':U + 'ALL|All|All' + 'VisibleRows':U + '10' + 'PanelOffset':U + '0' + 'FolderMenu':U + '' + 'TabsPerRow':U + '5' + 'TabHeight':U + '3' + 'TabFont':U + '4' + 'LabelOffset':U + '0' + 'ImageWidth':U + '0' + 'ImageHeight':U + '0' + 'ImageXOffset':U + '0' + 'ImageYOffset':U + '2' + 'TabSize':U + 'Autosized' + 'SelectorFGcolor':U + 'Default' + 'SelectorBGcolor':U + 'Default' + 'SelectorFont':U + '4' + 'SelectorWidth':U + '3' + 'TabPosition':U + 'Upper' + 'MouseCursor':U + '' + 'InheritColor':U + 'no' + 'TabVisualization':U + 'TABS' + 'PopupSelectionEnabled':U + 'yes' + 'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_folder ).
       RUN repositionObject IN h_folder ( 1.14 , 2.00 ) NO-ERROR.
       RUN resizeObject IN h_folder ( 18.33 , 78.20 ) NO-ERROR.

       /* Links to SmartFolder h_folder. */
       RUN addLink ( h_folder , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_folder ,
             FRAME FRAME-B:HANDLE , 'BEFORE':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME FRAME-A.
  HIDE FRAME FRAME-B.
  HIDE FRAME FRAME-C.
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
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
  ENABLE Btn_OK Btn_Cancel 
      WITH FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
  DISPLAY fiTabLabel fiTooltip fiHotkey fiTabFGColor fiTabBGColor fiTabINColor 
          fiImageDisabled fiImageEnabled fiEnableStates fiDisableStates 
          tbTabHidden 
      WITH FRAME FRAME-B.
  ENABLE btn-lookup-2 RECT-12 fiIndex Btn-Add Btn-Delete Btn-Insert Btn-Left 
         Btn-Next Btn-Previous Btn-Remove Btn-Right 
      WITH FRAME FRAME-B.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-B}
  DISPLAY cbSizing cbposition fiSelectorFGColor cbVisualization 
          fiSelectorBGColor fiFolderMenu fiTabFont fiSelectorFont fiTabHeight 
          fiPanelOffset fiSelectorWidth fiLabelOffset fiVisibleRows fiTabsPerRow 
          fiImageWidth fiImageHeight fiImageXOffset fiImageYOffset tbResize 
          tbInherit tbPopupSelection fiTitle 
      WITH FRAME FRAME-A.
  ENABLE btn_About RECT-10 RECT-11 cbVisualization btn-lookup tbResize 
         tbPopupSelection fiTitle 
      WITH FRAME FRAME-A.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-A}
  DISPLAY slMousePointer 
      WITH FRAME FRAME-C.
  ENABLE mouse-test RECT-2 slMousePointer btn-browse 
      WITH FRAME FRAME-C.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-C}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getProperties gDialog 
PROCEDURE getProperties :
/*------------------------------------------------------------------------------
  Purpose:     Extract the Property values from the calling program
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

{get NoWarnings tbResize ip-caller}.

{get ObjectType fiTitle ip-caller}.

RUN getBasicProperties.

RUN getArrayProperties.

{get MouseCursor slMousePointer ip-caller}.

ASSIGN fiIndex = 1
       fiTitle:SCREEN-VALUE IN FRAME FRAME-A = fiTitle + " " + ip-caller:FILE-NAME
       tbResize:CHECKED = tbResize
       slMousePointer = IF slMousePointer = ""
                        THEN "Arrow"
                        ELSE slMousePointer.

IF slMousePointer:LOOKUP(slMousePointer) IN FRAME FRAME-C = 0
THEN
    slMousePointer:ADD-FIRST(slMousePointer).

FIND FIRST wProperty WHERE wProperty.wIndex = 1 NO-ERROR.

IF AVAILABLE wProperty THEN RUN FormDisplay.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE postCreateObjects gDialog 
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

    {fnarg setPopupSelectionEnabled "hAttributeBuffer:BUFFER-FIELD('PopupSelectionEnabled'):BUFFER-VALUE" h_folder}.
    {fnarg setTabVisualization      "hAttributeBuffer:BUFFER-FIELD('TabVisualization'):BUFFER-VALUE"      h_folder}.
    {fnarg setTabPosition           "hAttributeBuffer:BUFFER-FIELD('TabPosition'):BUFFER-VALUE"           h_folder}.

    hAttributeBuffer:BUFFER-DELETE().
  END.
  
  ASSIGN
      FRAME FRAME-A:ROW = {fn getInnerRow h_folder}
      FRAME FRAME-B:ROW = FRAME FRAME-A:ROW
      FRAME FRAME-C:ROW = FRAME FRAME-A:ROW NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectPage gDialog 
PROCEDURE selectPage :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER piPageNum AS INTEGER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER(piPageNum).

  /* Code placed here will execute AFTER standard behavior.    */

  HIDE FRAME FRAME-A.
  HIDE FRAME FRAME-B.
  HIDE FRAME FRAME-C.

  CASE piPageNum:

      WHEN 1
      THEN DO WITH FRAME FRAME-A:

          VIEW FRAME FRAME-A.

          ASSIGN wh = WIDGET-HANDLE(FRAME FRAME-A:PRIVATE-DATA).

          IF VALID-HANDLE(wh) THEN APPLY "ENTRY":U TO wh.
      END.

      WHEN 2
      THEN DO WITH FRAME FRAME-B:

           IF NOT IconsLoaded
           THEN DO:

               ASSIGN IconsLoaded = Btn-Previous:LOAD-IMAGE("ry/img/bitlib.bmp",34,0,16,16)
                      IconsLoaded = Btn-Next:LOAD-IMAGE("ry/img/bitlib.bmp",51,0,16,16)
                      IconsLoaded = Btn-Left:LOAD-IMAGE("ry/img/bitlib.bmp",204,0,16,16)
                      IconsLoaded = Btn-Right:LOAD-IMAGE("ry/img/bitlib.bmp",221,0,16,16)
                      IconsLoaded = Btn-Insert:LOAD-IMAGE("ry/img/bitlib.bmp",187,34,16,16)
                      IconsLoaded = Btn-Delete:LOAD-IMAGE("ry/img/bitlib.bmp",34,34,16,16)
                      IconsLoaded = Btn-Add:LOAD-IMAGE("ry/img/bitlib.bmp",153,34,16,16)
                      IconsLoaded = Btn-Remove:LOAD-IMAGE("ry/img/bitlib.bmp",170,34,16,16)
                      IconsLoaded = Btn-Previous:LOAD-IMAGE-INSENSITIVE("ry/img/bitlib.bmp",34,17,16,16)
                      IconsLoaded = Btn-Next:LOAD-IMAGE-INSENSITIVE("ry/img/bitlib.bmp",51,17,16,16)
                      IconsLoaded = Btn-Left:LOAD-IMAGE-INSENSITIVE("ry/img/bitlib.bmp",204,17,16,16)
                      IconsLoaded = Btn-Right:LOAD-IMAGE-INSENSITIVE("ry/img/bitlib.bmp",221,17,16,16)
                      IconsLoaded = Btn-Insert:LOAD-IMAGE-INSENSITIVE("ry/img/bitlib.bmp",187,51,16,16)
                      IconsLoaded = Btn-Delete:LOAD-IMAGE-INSENSITIVE("ry/img/bitlib.bmp",34,51,16,16)
                      IconsLoaded = Btn-Add:LOAD-IMAGE-INSENSITIVE("ry/img/bitlib.bmp",153,51,16,16)
                      IconsLoaded = Btn-Remove:LOAD-IMAGE-INSENSITIVE("ry/img/bitlib.bmp",170,51,16,16).
          END.

          VIEW FRAME FRAME-B.

          ASSIGN wh = WIDGET-HANDLE(FRAME FRAME-B:PRIVATE-DATA).

          IF VALID-HANDLE(wh) THEN APPLY "ENTRY":U TO wh.
      END.

      WHEN 3
      THEN DO WITH FRAME FRAME-C:

          IF NOT ImageLoaded
          THEN
              ASSIGN ImageLoaded = mouse-test:LOAD-IMAGE-UP({&TEST-BITMAP})
                     ImageLoaded = mouse-test:LOAD-IMAGE-DOWN({&TEST-BITMAP})
                     ImageLoaded = mouse-test:LOAD-IMAGE-INSENSITIVE({&TEST-BITMAP})
                     slMousePointer:SCREEN-VALUE = slMousePointer
                     vResult = mouse-test:LOAD-MOUSE-POINTER(slMousePointer).

          VIEW FRAME FRAME-C.

          APPLY "ENTRY":U TO slMousePointer IN FRAME FRAME-C.
      END.

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setProperties gDialog 
PROCEDURE setProperties :
/*------------------------------------------------------------------------------
  Purpose:     Save Properties back into SmartObject
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

RUN FormAssign.

RUN setBasicProperties.

RUN setArrayProperties.

IF ImageLoaded
THEN
    ASSIGN FRAME FRAME-C slMousePointer.

ASSIGN slMousePointer = IF slMousePointer = "Arrow"
                        THEN ""
                        ELSE slMousePointer.

{set MouseCursor slMousePointer ip-caller}.

{set FolderTabType 0 ip-caller}.

IF FRAME {&FRAME-NAME}:VISIBLE
THEN
    ASSIGN Btn_Apply:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.

RUN InitializeObject IN ip-caller.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject gDialog 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN selectPage IN THIS-PROCEDURE (1).

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

