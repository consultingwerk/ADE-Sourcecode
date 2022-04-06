&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wiWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" wiWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" wiWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wiWin 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File:         afmenumaintw.w

  Description:  Toolbar and Menu Maintenance Window

  Purpose:      Used to build toolbar and menu structures together as one control.  Creates
                items to be used as buttons on toolbars, or menu items in menus. Allows for
                the creations of bands, which is a grouping of items, which can be resued to
                build both toolbars and menus

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:
                Date:   22/08/2001  Author:     Don Bulua

  Update Notes: Created from Template rysttbconw.w

  (v:010001)    Task:           0   UserRef:
                Date:   04/23/2002  Author:     Sunil Belgaonkar

  Update Notes: Changed the Image paths from af/bmp to ry/img
                Also Changed the images from .bmp to .gif formats.

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

&scop object-name       afmenumaintw.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* WIndow Min WIddth and Height */
&SCOPED-DEFINE WINDOW_HEIGHT_MIN 23.8
&SCOPED-DEFINE WINDOW_WIDTH_MIN 75
/* Fixed node keys */
&SCOPED-DEFINE ROOT_NODE root
&SCOPED-DEFINE CATEGORY_NODE x1catg
&SCOPED-DEFINE BAND_NODE x2band
&SCOPED-DEFINE MENUBAR_NODE x2band1
&SCOPED-DEFINE SUBMENU_NODE x2band2
&SCOPED-DEFINE TOOLBAR_NODE x2band3
&SCOPED-DEFINE MENUTOOLBAR_NODE x2band4
&SCOPED-DEFINE SMARTTOOLBAR_NODE x3tbarobj

DEFINE VARIABLE giNodePage           AS INTEGER    NO-UNDO.
DEFINE VARIABLE giLastNodePage       AS INTEGER    NO-UNDO.
DEFINE VARIABLE ghTableIOTarget      AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcLastNodeKey        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcModuleObj          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcModuleCode         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcModuleCodeClause   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcModuleDesc         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcPhysicalModuleObj  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcPhysicalModuleCode AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcPhysicalModuleDesc AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcObjectTypeObj      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE giLastTabPage        AS INTEGER    NO-UNDO.
DEFINE VARIABLE giLockWindow         AS INTEGER    NO-UNDO.
DEFINE VARIABLE giPageTab            AS INTEGER    NO-UNDO INIT 1.
DEFINE VARIABLE glExcludeCancel      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glPageInitialized    AS LOGICAL    NO-UNDO EXTENT 11.

/* Property sheet window handle and property sheet library handle */
DEFINE VARIABLE ghPropSheetLib       AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcRegisteredToolbars AS CHARACTER  NO-UNDO.

DEFINE VARIABLE ghRepositoryDesignManager  AS HANDLE     NO-UNDO.
 /* Popup Menu Handles */
  DEFINE VARIABLE ghCategoryLabel AS HANDLE     NO-UNDO.
  DEFINE VARIABLE ghCategory      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE ghItem          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE ghBandLabel     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE ghBand          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE ghBandItem      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE ghTbarLabel     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE ghTbarObj       AS HANDLE     NO-UNDO.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
/* Temp table definition for  attributes */
 {ry/inc/ryrepatset.i}

 {ry/app/rydefrescd.i}
 
 /** Contains definitions for dynamics design-time temp-tables. **/
 {destdefi.i}

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartWindow yes

{af/sup2/afglobals.i}

DEFINE VARIABLE gcToolbarClasses AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gdDifference     AS DECIMAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coModule coObjType btnSplitBar 
&Scoped-Define DISPLAYED-OBJECTS coModule coObjType 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBandImage wiWin 
FUNCTION getBandImage RETURNS CHARACTER
  ( pcBandType AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCatgInfo wiWin 
FUNCTION getCatgInfo RETURNS LOGICAL
  ( OUTPUT pcObjectID AS CHARACTER,
    OUTPUT pcLabel AS CHARACTER,
    OUTPUT pcDesc  AS CHARACTER,
    OUTPUT pcLink AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getItemImage wiWin 
FUNCTION getItemImage RETURNS CHARACTER
  ( pcItemType AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getItemLabel wiWin 
FUNCTION getItemLabel RETURNS CHARACTER
  ( pcLabel       AS CHAR,
    pcReference   AS CHAR,
    pcDescription AS CHAR,
    pcType        AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getModuleCode wiWin 
FUNCTION getModuleCode RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getModuleDesc wiWin 
FUNCTION getModuleDesc RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getModuleObj wiWin 
FUNCTION getModuleObj RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectTypeObj wiWin 
FUNCTION getObjectTypeObj RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPhysicalModuleCode wiWin 
FUNCTION getPhysicalModuleCode RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPhysicalModuleDesc wiWin 
FUNCTION getPhysicalModuleDesc RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPhysicalModuleObj wiWin 
FUNCTION getPhysicalModuleObj RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPopupMenu wiWin 
FUNCTION getPopupMenu RETURNS HANDLE
  ( pcType AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getProductModuleCode wiWin 
FUNCTION getProductModuleCode RETURNS CHARACTER
  ( pcObjectID AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSelectedItem wiWin 
FUNCTION getSelectedItem RETURNS CHARACTER
  ( pcKey   AS CHAR,
    pcTag   AS CHAR,
    piPos   AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSequence wiWin 
FUNCTION getSequence RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD lockWindow wiWin 
FUNCTION lockWindow RETURNS LOGICAL
  (plLockWindow AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setObjectType wiWin 
FUNCTION setObjectType RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wiWin AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_New 
       MENU-ITEM m_Category     LABEL "&Category"     
       MENU-ITEM m_Item         LABEL "&Item"         
       MENU-ITEM m_Band         LABEL "&Band"         
       RULE
       MENU-ITEM m_ToolbarMenubar LABEL "&SmartToolbar" .

DEFINE SUB-MENU m_File 
       SUB-MENU  m_New          LABEL "&New"          
       RULE
       MENU-ITEM m_Exit         LABEL "E&xit"         .

DEFINE SUB-MENU m_Edit 
       MENU-ITEM m_Cut          LABEL "Cu&t"           ACCELERATOR "CTRL-X"
       MENU-ITEM m_Copy         LABEL "&Copy"          ACCELERATOR "CTRL-C"
       MENU-ITEM m_Paste        LABEL "&Paste"         ACCELERATOR "CTRL-V".

DEFINE SUB-MENU m_Search 
       MENU-ITEM m_Lookup_Items LABEL "Lookup Items && Bands...".

DEFINE MENU MENU-BAR-wiWin MENUBAR
       SUB-MENU  m_File         LABEL "&File"         
       SUB-MENU  m_Edit         LABEL "&Edit"         
       SUB-MENU  m_Search       LABEL "&Search"       .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_dyntreeview AS HANDLE NO-UNDO.
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gscicfullo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gscicview AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gscobviewt AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gscotfullo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gscpm2fullo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gsmitfullo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gsmitview AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gsmmifullo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gsmmiview AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gsmmsfullo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gsmmsview AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gsmombrow AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gsmomfullo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gsmomviewt AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gsmtmfullo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gsmtmview AS HANDLE NO-UNDO.
DEFINE VARIABLE h_pupdsav AS HANDLE NO-UNDO.
DEFINE VARIABLE h_rycsoful2o AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnSplitBar  NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 1 BY 22.05.

DEFINE VARIABLE coModule AS CHARACTER FORMAT "X(256)":U 
     LABEL "Module" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 8
     DROP-DOWN-LIST
     SIZE 26.6 BY 1 NO-UNDO.

DEFINE VARIABLE coObjType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Toolbar type" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 26.6 BY 1 TOOLTIP "Please specify the toolbar class to filter on for toolbars" NO-UNDO.

DEFINE BUTTON btnRefresh 
     IMAGE-UP FILE "ry/img/menurefresh.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "Refresh" 
     SIZE 4.8 BY 1.05 TOOLTIP "Refresh tree"
     BGCOLOR 8 .

DEFINE BUTTON buProperty 
     IMAGE-UP FILE "ry/img/properties.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 4.8 BY 1.05 TOOLTIP "Properties"
     BGCOLOR 8 .

DEFINE BUTTON buSearch 
     IMAGE-UP FILE "ry/img/afbinos.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 4.8 BY 1.05 TOOLTIP "Search for items"
     BGCOLOR 8 .

DEFINE BUTTON buTranslate 
     IMAGE-UP FILE "ry/img/gs_lang.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 4.8 BY 1.05 TOOLTIP "Translate Menu Item"
     BGCOLOR 8 .

DEFINE RECTANGLE rctTbar
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 156 BY .1.

DEFINE RECTANGLE rctTbar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 156 BY .1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     coModule AT ROW 1.14 COL 13.6 COLON-ALIGNED
     coObjType AT ROW 2.19 COL 13.6 COLON-ALIGNED
     btnSplitBar AT ROW 1 COL 44.4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2.48
         SIZE 158.4 BY 23.86.

DEFINE FRAME frmToolbar
     btnRefresh AT ROW 1.14 COL 1
     buSearch AT ROW 1.14 COL 6.6
     buTranslate AT ROW 1.14 COL 12.2
     buProperty AT ROW 1.14 COL 17.8
     rctTbar AT ROW 1 COL 1
     rctTbar-2 AT ROW 2.19 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 158.43 BY 1.35.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Design Page: 9
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wiWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Toolbar and Menu Designer"
         HEIGHT             = 24.14
         WIDTH              = 158.4
         MAX-HEIGHT         = 32.38
         MAX-WIDTH          = 204.8
         VIRTUAL-HEIGHT     = 32.38
         VIRTUAL-WIDTH      = 204.8
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MENU-BAR-wiWin:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wiWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wiWin
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME frMain
                                                                        */
ASSIGN 
       btnSplitBar:MOVABLE IN FRAME frMain          = TRUE.

/* SETTINGS FOR FRAME frmToolbar
                                                                        */
/* SETTINGS FOR BUTTON buProperty IN FRAME frmToolbar
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buTranslate IN FRAME frmToolbar
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wiWin)
THEN wiWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wiWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON END-ERROR OF wiWin /* Toolbar and Menu Designer */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON WINDOW-CLOSE OF wiWin /* Toolbar and Menu Designer */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON WINDOW-RESIZED OF wiWin /* Toolbar and Menu Designer */
DO:
  /* Assign the frame width and heights equal the last highest values */
  ASSIGN SELF:HEIGHT                = MAX({&WINDOW_HEIGHT_MIN},SELF:HEIGHT)
         SELF:WIDTH                 = MAX({&WINDOW_WIDTH_MIN},SELF:WIDTH)
         FRAME {&FRAME-NAME}:WIDTH  = MAX(SELF:WIDTH,FRAME {&FRAME-NAME}:WIDTH)
         FRAME {&FRAME-NAME}:HEIGHT = MAX(SELF:HEIGHT - FRAME {&FRAME-NAME}:ROW + 1 ,FRAME {&FRAME-NAME}:HEIGHT)
         FRAME frmToolbar:WIDTH     = FRAME {&FRAME-NAME}:WIDTH
         rcttbar:WIDTH              = FRAME frmToolbar:WIDTH
         rctTbar-2:WIDTH            = FRAME frmToolbar:WIDTH
      NO-ERROR.
  RUN repositionSplitBar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frmToolbar
&Scoped-define SELF-NAME btnRefresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnRefresh wiWin
ON CHOOSE OF btnRefresh IN FRAME frmToolbar /* Refresh */
DO:
  /* Refresh Treeview for new product module */
  RUN refreshTree.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frMain
&Scoped-define SELF-NAME btnSplitBar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSplitBar wiWin
ON END-MOVE OF btnSplitBar IN FRAME frMain
DO:
  RUN repositionSplitBar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frmToolbar
&Scoped-define SELF-NAME buProperty
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buProperty wiWin
ON CHOOSE OF buProperty IN FRAME frmToolbar
DO:
  RUN launchPropertySheet IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSearch wiWin
ON CHOOSE OF buSearch IN FRAME frmToolbar
DO:
  /* Run Search dialog to search for items */
  RUN af/cod2/afmenusearchd.w (THIS-PROCEDURE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buTranslate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buTranslate wiWin
ON CHOOSE OF buTranslate IN FRAME frmToolbar
DO:
  DEFINE VARIABLE hMenuItemViewer AS HANDLE     NO-UNDO.

  SESSION:SET-WAIT-STATE("GENERAL":U).
  /* Launch the Menu Item Translation Control Window */
  hMenuItemViewer = WIDGET-HANDLE(ENTRY(1,DYNAMIC-FUNCTION("linkHandles":U,"MenuItem-Target":U))).
  IF VALID-HANDLE(hMenuItemViewer) AND
     LOOKUP("launchTranslator":U,hMenuItemViewer:INTERNAL-ENTRIES) > 0 THEN
    RUN launchTranslator IN hMenuItemViewer.
  SESSION:SET-WAIT-STATE("":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frMain
&Scoped-define SELF-NAME coModule
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coModule wiWin
ON VALUE-CHANGED OF coModule IN FRAME frMain /* Module */
DO:
/*------------------------------------------------------------------------------
  Purpose:    Send the selected module Code to the changeModule procedure
              which refreshes the treeview.
 ------------------------------------------------------------------------------*/
   DEFINE VARIABLE iPos        AS INTEGER    NO-UNDO.
   DEFINE VARIABLE cModuleCode AS CHARACTER  NO-UNDO.

   ASSIGN iPos        = LOOKUP(SELF:SCREEN-VALUE,SELF:LIST-ITEM-PAIRS,SELF:DELIMITER)
          cModuleCode = ENTRY(iPos - 1,SELF:LIST-ITEM-PAIRS,SELF:DELIMITER)
          NO-ERROR.

   RUN changeModule (SELF:SCREEN-VALUE,cModuleCode) NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coObjType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coObjType wiWin
ON VALUE-CHANGED OF coObjType IN FRAME frMain /* Toolbar type */
DO:
  setObjectType().
  APPLY "CHOOSE":U TO btnRefresh IN FRAME frmToolbar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Band
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Band wiWin
ON CHOOSE OF MENU-ITEM m_Band /* Band */
DO:
  RUN menuAddNode ("Band":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Category
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Category wiWin
ON CHOOSE OF MENU-ITEM m_Category /* Category */
DO:
  RUN menuAddNode ("CATG":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Copy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Copy wiWin
ON CHOOSE OF MENU-ITEM m_Copy /* Copy */
DO:
 DEFINE VARIABLE lOK AS LOGICAL    NO-UNDO.

 IF FOCUS:TEXT-SELECTED THEN
    lok = FOCUS:EDIT-COPY() NO-ERROR.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Cut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Cut wiWin
ON CHOOSE OF MENU-ITEM m_Cut /* Cut */
DO:
 DEFINE VARIABLE lOK           AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lTextSelected AS LOGICAL    NO-UNDO.

 lTextSelected = FOCUS:TEXT-SELECTED NO-ERROR.
 IF lTextSelected THEN DO:
    lok = FOCUS:EDIT-CUT() NO-ERROR.
    IF lok THEN DO:
       APPLY "VALUE-CHANGED":U TO FOCUS.
    END.
 END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Exit wiWin
ON CHOOSE OF MENU-ITEM m_Exit /* Exit */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Item wiWin
ON CHOOSE OF MENU-ITEM m_Item /* Item */
DO:
  RUN menuAddNode ("Item":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Lookup_Items
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Lookup_Items wiWin
ON CHOOSE OF MENU-ITEM m_Lookup_Items /* Lookup Items  Bands... */
DO:
  APPLY "CHOOSE":U TO buSearch IN FRAME frmToolbar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Paste
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Paste wiWin
ON CHOOSE OF MENU-ITEM m_Paste /* Paste */
DO:
  DEFINE VARIABLE lOK AS LOGICAL    NO-UNDO.

  IF FOCUS:EDIT-CAN-PASTE THEN DO:
     lok = FOCUS:EDIT-PASTE() NO-ERROR.
     IF lok  THEN
        APPLY 'VALUE-CHANGED':U TO FOCUS.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_ToolbarMenubar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_ToolbarMenubar wiWin
ON CHOOSE OF MENU-ITEM m_ToolbarMenubar /* SmartToolbar */
DO:
  RUN menuAddNode ("TBAROBJ":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wiWin 


/* ***************************  Main Block  *************************** */



/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addNode wiWin 
PROCEDURE addNode :
/*------------------------------------------------------------------------------
  Purpose:     Adds an individual node to the treeview
  Parameters:  pcNodeType   This specifies the viewer type that was added
               pcNodeValue  This specifies the label and other info, different for each
                            nodeType.
               pcNodeTag    The tag info to add to the node
  Notes:       This is called from the updateRecord procedure from
               all of the the viewers when a record is added or updated.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcNodeType  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcNodeValue AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcNodeTag   AS CHARACTER  NO-UNDO.

DEFINE VARIABLE hTable          AS HANDLE     NO-UNDO.
DEFINE VARIABLE cKey            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTag            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cParentKey      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cParentTag      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cParentText     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cToolbarObjKey  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNodeKey        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iChildren       AS INTEGER    NO-UNDO.
DEFINE VARIABLE cInsertKey      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cInsertTag      AS CHARACTER  NO-UNDO.

  /* BUFFER FIELD handles */
DEFINE VARIABLE hBuf            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hLabel          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hKey            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hParentKey      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTag            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hImage          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSelectedImage  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hExpanded       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSort           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hInsert         AS HANDLE     NO-UNDO.

{get TreeDataTable hTable h_dyntreeview}.
IF NOT VALID-HANDLE(hTable) THEN DO:
    MESSAGE "Invalid Handle found for TreeData temp-table"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN.
END.
/* Assign Buffer Handles */
ASSIGN hBuf            = hTable:DEFAULT-BUFFER-HANDLE
       hKey            = hBuf:BUFFER-FIELD('node_key':U)
       hlabel          = hBuf:BUFFER-FIELD('node_label':U)
       hParentKey      = hBuf:BUFFER-FIELD('parent_node_key':U)
       hTag            = hBuf:BUFFER-FIELD('private_data':U)
       hImage          = hBuf:BUFFER-FIELD('image':U)
       hSelectedImage  = hBuf:BUFFER-FIELD('selected_image':U)
       hExpanded       = hBuf:BUFFER-FIELD('node_expanded':U)
       hSort           = hBuf:BUFFER-FIELD('node_sort':U)
       hInsert         = hBuf:BUFFER-FIELD('node_insert':U).

/* Clear the data from the TreeView */
hBuf:EMPTY-TEMP-TABLE().

CASE pcNodeType:
  WHEN "CATEGORY":U THEN
  DO:
     hbuf:BUFFER-CREATE().
     ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
            cKey                          = hKey:BUFFER-VALUE
            hParentKey:BUFFER-VALUE       =  "{&CATEGORY_NODE}":U
            hInsert:BUFFER-VALUE          = 4
            hLabel:BUFFER-VALUE           = pcNodeValue
            hImage:BUFFER-VALUE           = "ry/img/menucategory.bmp":U
            hSelectedImage:BUFFER-VALUE   = "ry/img/menucategory.bmp":U
            hSort:BUFFER-VALUE            = TRUE
            hTag:BUFFER-VALUE             = "CATG|":U + pcNodeTag
            NO-ERROR.

     RUN populatetree IN h_dyntreeview (hTable,"{&CATEGORY_NODE}":U).
     DYNAMIC-FUNCTION("setProperty":U IN h_dyntreeview,"SELECTEDITEM":U,ckey,"").
  END. /* END WHEN Category */


  WHEN "ITEM":U THEN
      RUN addNodeItem(pcNodeValue,pcNodeTag) .


  WHEN "BAND":U THEN
  DO:
    CASE ENTRY(2,pcNodeValue,CHR(1)):
        WHEN "MenuBar":U THEN
            cParentKey = "{&MENUBAR_NODE}":U.
        WHEN "SubMenu":U THEN
            cParentKey = "{&SUBMENU_NODE}":U.
        WHEN "ToolBar":U THEN
            cParentKey = "{&TOOLBAR_NODE}":U.
        WHEN "Menu&Toolbar":U THEN
            cParentKey = "{&MENUTOOLBAR_NODE}":U.
    END CASE.

    ASSIGN cTag      = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"TAG":U,cParentKey)
           iChildren = INT(DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"CHILDREN":U,cParentKey))
           NO-ERROR.

        /* IF node hasn't yet been expanded, expand it now before adding node */
    IF ENTRY(1,cTag,"|") = "@BANDLABEL":U AND iChildren > 0 THEN
    DO:
      DYNAMIC-FUNCTION("setProperty":U IN h_dyntreeview,"EXPANDED":U,cParentKey,"yes":U).
         /* Find the key of the newly added node */
      cKey = getSelectedItem(cParentKey, ENTRY(1,pcNodeTag,"|"), 2 ).
      IF cKey > "" THEN DO:
        DYNAMIC-FUNCTION("setProperty":U IN h_dyntreeview,"SELECTEDITEM":U,ckey,"").
        cTag = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"TAG":U,ckey).
        /* Since expanding node causes refresh of query, reposition row by running treeclick*/
        RUN treeclick(cKey,cTag).
      END.
      RETURN.
    END.

    hbuf:BUFFER-CREATE().
    ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
           cKey                          = hKey:BUFFER-VALUE
           hParentKey:BUFFER-VALUE       = cParentKey
           hInsert:BUFFER-VALUE          = 4
           hLabel:BUFFER-VALUE           = ENTRY(1,pcNodeValue,CHR(1))
           hImage:BUFFER-VALUE           = getBandImage(ENTRY(2,pcNodeValue,CHR(1)))
           hSelectedImage:BUFFER-VALUE   = hImage:BUFFER-VALUE
           hSort:BUFFER-VALUE            = TRUE
           hTag:BUFFER-VALUE             = "BAND|":u + pcNodeTag + "|" + ENTRY(2,pcNodeValue,CHR(1))
           NO-ERROR.
    RUN populatetree IN h_dyntreeview (hTable,cParentKey).
    DYNAMIC-FUNCTION("setProperty":U IN h_dyntreeview,"SELECTEDITEM":U,ckey,"").
    
  END. /* END WHEN Band */


  WHEN "BANDITEM":U THEN
    RUN addNodeBanditem (pcNodeValue,pcNodeTag) .


  WHEN "TBAROBJ":U THEN
  DO:
     ASSIGN cKey       = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"KEY":U,"")
            cTag       = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"TAG":U,"")
            iChildren  =  INT(DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"CHILDREN":U,ckey))
            NO-ERROR.
     IF ENTRY(1,cTag,"|") =  "TBARLABEL":U OR ENTRY(1,cTag,"|") = "@TBARLABEL":U THEN
        cParentKey = cKey.
     ELSE
        cParentKey = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"PARENT":U,cKey).

              /* IF node hasn't yet been expanded, expand it now before adding node */
    IF ENTRY(1,cTag,"|") = "@TBARLABEL":U AND iChildren > 0 THEN DO:
      DYNAMIC-FUNCTION("setProperty":U IN h_dyntreeview,"EXPANDED":U,cParentKey,"yes":U).
      cKey = getSelectedItem(cParentKey, ENTRY(1,pcNodeTag,"|"), 2 ).
      IF cKey > "" THEN
      DO:
        DYNAMIC-FUNCTION("setProperty":U IN h_dyntreeview,"SELECTEDITEM":U,ckey,"").
        cTag = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"TAG":U,ckey).
        /* Since expanding node causes refresh of query, reposition row by running treeclick*/
        RUN treeclick(cKey,cTag).
      END.
      RETURN.
    END.
    hbuf:BUFFER-CREATE().
    ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
           cKey                          = hKey:BUFFER-VALUE
           hParentKey:BUFFER-VALUE       = cParentKey
           hInsert:BUFFER-VALUE          = 4
           hLabel:BUFFER-VALUE           = Entry(1,pcNodeValue,CHR(1))
           hImage:BUFFER-VALUE           = "ry/img/menuobject.bmp":U
           hSelectedImage:BUFFER-VALUE   = hImage:BUFFER-VALUE
           hSort:BUFFER-VALUE            = TRUE
           hTag:BUFFER-VALUE             = "TBAROBJ|":U + pcNodeTag
           NO-ERROR.

     IF NUM-ENTRIES(pcNodeTag,"|") = 4 AND TRIM(ENTRY(4,pcNodeTag,"|")) = "Copy":U THEN
     DO:
         hTag:BUFFER-VALUE                    = "@TBAROBJ|":U + pcNodeTag.
         hbuf:BUFFER-CREATE().
         ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
                hParentKey:BUFFER-VALUE       = cKey
                hInsert:BUFFER-VALUE          = 4
                hLabel:BUFFER-VALUE           = "@DummyRecord":U
                hImage:BUFFER-VALUE           = ""
                hSelectedImage:BUFFER-VALUE   = ""
                hTag:BUFFER-VALUE             = "@Dummy":U
                NO-ERROR.
     END.

     RUN populatetree IN h_dyntreeview (hTable,cParentKey).
     DYNAMIC-FUNCTION("setProperty":U IN h_dyntreeview,"SELECTEDITEM":U,ckey,"").
     RUN treeClick (ckey,"@TBAROBJ|":U + pcNodeTag).
  END. /* END WHEN TBAROBJ */


  WHEN "TBARBAND":U THEN
  DO:
      ASSIGN cKey        = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"KEY":U,"")
             cTag        = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"TAG":U,"")
             NO-ERROR.
     IF ENTRY(1,cTag,"|") = "TBAROBJ":U OR ENTRY(1,ctag,"|") = "@TBAROBJ":U THEN
        cParentKey = cKey.
     ELSE
        cParentKey = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"PARENT":U,cKey).

    ASSIGN cParentTag     = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"TAG":U,cParentkey)
           cParentText    = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"TEXT":U,cParentkey)
           cToolbarObjKey = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"PARENT":U,cParentkey) .

    /* Delete parent node */
   RUN deleteNode IN h_dyntreeview(cparentKey).

   hbuf:BUFFER-CREATE().
   ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
          cNodeKey                      = hKey:BUFFER-VALUE
          hParentKey:BUFFER-VALUE       = cToolbarObjKey
          hInsert:BUFFER-VALUE          = 4
          hLabel:BUFFER-VALUE           = cParentText
          hImage:BUFFER-VALUE           = "ry/img/menuobject.bmp":U
          hSelectedImage:BUFFER-VALUE   = hImage:BUFFER-VALUE
          hSort:BUFFER-VALUE            = TRUE
          hTag:BUFFER-VALUE             = IF cParentTag BEGINS "@"
                                          THEN cParentTag
                                          ELSE "@" + cParentTag
          NO-ERROR.

        /* Add dummy node*/
   hbuf:BUFFER-CREATE().
   ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
          hParentKey:BUFFER-VALUE       = cNodeKey
          hInsert:BUFFER-VALUE          = 4
          hLabel:BUFFER-VALUE           = "@DummyRecord":U
          hImage:BUFFER-VALUE           = ""
          hSelectedImage:BUFFER-VALUE   = ""
          hTag:BUFFER-VALUE             = "@Dummy":U
          NO-ERROR.
   RUN populateTree IN h_dyntreeview (hTable,cToolbarObjKey).

   RUN treeExpand (cNodeKey, IF cParentTag BEGINS "@" THEN cParentTag ELSE "@" + cParentTag).
   DYNAMIC-FUNCTION("setProperty":U IN h_dyntreeview,"EXPANDED":U,cNodeKey,"YES":U).
   /* Find the updated node and select it */
   ASSIGN
       cInsertKey = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"CHILD":U,cNodeKey).
   Child-Loop:
   DO WHILE cInsertKey <> "" AND cInsertKey <> ?:
      cInsertTag  = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"TAG":U,cInsertKey).
      IF decimal(ENTRY(2,cInsertTag,"|")) = decimal(pcNodeTag) THEN
      DO:
         DYNAMIC-FUNCTION("setProperty":U IN h_dyntreeview,"SELECTEDITEM":U,cInsertKey,"").
         RETURN.
      END.
      cInsertKey  = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"NEXT":U,cInsertKey).
   END.
  END.  /* END WHEN TBARBAND */

END CASE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addNodeBandItem wiWin 
PROCEDURE addNodeBandItem :
/*------------------------------------------------------------------------------
  Purpose:     Adds item nodes to a specific band. Inserts band into specified
               sequence and renumbers the tags with the new sequences.
  Parameters:  pcNodeValue   Text to insert in Node
               pcNodeTag     Tag of Node
  Notes:      Called from addNode
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcNodeValue AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcNodeTag   AS CHARACTER  NO-UNDO.

DEFINE VARIABLE hTable          AS HANDLE     NO-UNDO.
DEFINE VARIABLE cKey            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTag            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cParentKey      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iChildren       AS INTEGER    NO-UNDO.
DEFINE VARIABLE cFirstKey       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cInsertKey      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNextKey        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iNewSeq         AS INTEGER    NO-UNDO.
DEFINE VARIABLE iSeq            AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
DEFINE VARIABLE iCurrentPage    AS INTEGER    NO-UNDO.

  /* BUFFER FIELD handles */
DEFINE VARIABLE hBuf            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hLabel          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hKey            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hParentKey      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTag            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hImage          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSelectedImage  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hExpanded       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSort           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hInsert         AS HANDLE     NO-UNDO.

{get TreeDataTable      hTable    h_dyntreeview}.

ASSIGN hBuf            = hTable:DEFAULT-BUFFER-HANDLE
       hKey            = hBuf:BUFFER-FIELD('node_key':U)
       hlabel          = hBuf:BUFFER-FIELD('node_label':U)
       hParentKey      = hBuf:BUFFER-FIELD('parent_node_key':U)
       hTag            = hBuf:BUFFER-FIELD('private_data':U)
       hImage          = hBuf:BUFFER-FIELD('image':U)
       hSelectedImage  = hBuf:BUFFER-FIELD('selected_image':U)
       hExpanded       = hBuf:BUFFER-FIELD('node_expanded':U)
       hSort           = hBuf:BUFFER-FIELD('node_sort':U)
       hInsert         = hBuf:BUFFER-FIELD('node_insert':U).

/* Clear the data from the TreeView */
hBuf:EMPTY-TEMP-TABLE().

 ASSIGN cKey       = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"KEY":U,"")
        cTag       = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"TAG":U,"")
        iChildren  =  INT(DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"CHILDREN":U,ckey))
        NO-ERROR.
 IF ENTRY(1,cTag,"|") =  "BAND":U OR ENTRY(1,cTag,"|") = "@BAND":U THEN
    cParentKey = cKey.
 ELSE
    cParentKey = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"PARENT":U,cKey).

     /* IF node hasn't yet been expanded, expand it now before adding node */
 IF ENTRY(1,cTag,"|") = "@BAND":U AND iChildren > 0 THEN
 DO:
    DYNAMIC-FUNCTION("setProperty":U IN h_dyntreeview,"EXPANDED":U,cParentKey,"yes":U).
    cKey = getSelectedItem(cParentKey, ENTRY(1,pcNodeTag,"|"), 2 ).
      IF cKey > "" THEN
        DYNAMIC-FUNCTION("setProperty":U IN h_dyntreeview,"SELECTEDITEM":U,ckey,"").
    RETURN.
 END.

 /* Find where to insert key based on menu sequence field */
 ASSIGN
  cFirstKey  = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"CHILD":U,cParentKey)
  cNextKey = cFirstKey
  iNewSeq    = INT(ENTRY(3,pcNodeTag,"|"))
  .
/* Loop through all items of the band to determine the insert location */
ASSIGN iLoop      = 1
       cInsertKey = "".
Child-Loop:
DO WHILE cNextKey <> "" AND cNextKey <> ?:
   ASSIGN cTag = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"TAG":U,cNextKey)
          iSeq = INTEGER(ENTRY(4,cTag,"|")) NO-ERROR.

   IF iNewSeq <= iSeq AND cInsertKey = "" THEN
     ASSIGN cInsertKey = cNextKey
            iLoop      = iLoop + 1.
   /* Resequence all sequence values */
   ENTRY(4,cTag,"|") = STRING(iLoop).
   DYNAMIC-FUNC("setProperty":U IN h_dyntreeview,"TAG":U,cNextKey,cTag)     .
   ASSIGN cNextKey  = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"NEXT":U,cNextKey)
          iLoop       = iLoop + 1.
END.

hbuf:BUFFER-CREATE().
ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
       hParentKey:BUFFER-VALUE       = IF cInsertKey = "" OR cInsertKey = ?
                                       THEN cParentKey
                                       ELSE cInsertKey
       hInsert:BUFFER-VALUE          = IF cInsertKey = "" OR cInsertKey = ?
                                       THEN 4  /* Insert as child */
                                       ELSE 3  /* Insert previous */
       hLabel:BUFFER-VALUE           = pcNodeValue
       hImage:BUFFER-VALUE           = getItemImage(ENTRY(4,pcNodeTag,"|"))
       hSelectedImage:BUFFER-VALUE   = hImage:BUFFER-VALUE
       hSort:BUFFER-VALUE            = FALSE
       hTag:BUFFER-VALUE             = "BANDITEM|":U + pcNodeTag
       cNextKey                      = hKey:BUFFER-VALUE
       NO-ERROR.
IF ENTRY(5,pcNodeTag,"|") > "" THEN
   hTag:BUFFER-VALUE             = "@":U + hTag:BUFFER-VALUE.
RUN addNode IN h_dyntreeview (hBuf).

IF ENTRY(5,pcNodeTag,"|") > "0" THEN
DO:
  /* Add dummy record */
  hBuf:EMPTY-TEMP-TABLE().
  hbuf:BUFFER-CREATE().
  ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
         hParentKey:BUFFER-VALUE       = cNextKey
         hInsert:BUFFER-VALUE          = 4
         hLabel:BUFFER-VALUE           = "@DummyRecord":U
         hImage:BUFFER-VALUE           = ""
         hSelectedImage:BUFFER-VALUE   = ""
         hTag:BUFFER-VALUE             = "@Dummy":U
         NO-ERROR.
  RUN addNode IN h_dyntreeview (hBuf).

END.

RUN refreshBand ( cParentKey, ENTRY(2,pcNodeTag,"|")).

DYNAMIC-FUNCTION("setProperty":U IN h_dyntreeview,"SELECTEDITEM":U,cNextKey,"").
{get CurrentPage iCurrentPage}.
IF iCurrentPage = 7 AND giNodePage = 8  THEN
    DYNAMIC-FUNC("disableActions":U IN h_pupdsav,"Delete":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addNodeItem wiWin 
PROCEDURE addNodeItem :
/*------------------------------------------------------------------------------
  Purpose:     Adds item nodes. If Item viewer is on 2nd tab folder when
               a band is clicked, it inserts item into band
  Parameters:  pcNodeValue   Text to insert in Node
               pcNodeTag     Tag of Node
  Notes:      Called from addNode
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcNodeValue AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcNodeTag   AS CHARACTER  NO-UNDO.

DEFINE VARIABLE hTable          AS HANDLE     NO-UNDO.
DEFINE VARIABLE cKey            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTag            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cParentKey      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFirstKey       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cInsertKey      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cInsertTag      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lAddItemBand    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cEntry          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lOK             AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cCols           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBandObj        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSequence       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iSequence       AS INTEGER    NO-UNDO.
DEFINE VARIABLE cItemObj        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMenuItemObj    AS CHARACTER  NO-UNDO.


  /* BUFFER FIELD handles */
DEFINE VARIABLE hBuf            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hLabel          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hKey            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hParentKey      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTag            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hImage          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSelectedImage  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hExpanded       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSort           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hInsert         AS HANDLE     NO-UNDO.


{get TreeDataTable      hTable    h_dyntreeview}.
ASSIGN hBuf            = hTable:DEFAULT-BUFFER-HANDLE
       hKey            = hBuf:BUFFER-FIELD('node_key':U)
       hlabel          = hBuf:BUFFER-FIELD('node_label':U)
       hParentKey      = hBuf:BUFFER-FIELD('parent_node_key':U)
       hTag            = hBuf:BUFFER-FIELD('private_data':U)
       hImage          = hBuf:BUFFER-FIELD('image':U)
       hSelectedImage  = hBuf:BUFFER-FIELD('selected_image':U)
       hExpanded       = hBuf:BUFFER-FIELD('node_expanded':U)
       hSort           = hBuf:BUFFER-FIELD('node_sort':U)
       hInsert         = hBuf:BUFFER-FIELD('node_insert':U).

/* Clear the data from the TreeView */
hBuf:EMPTY-TEMP-TABLE().

ASSIGN cKey         = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"KEY":U,"")
       cTag         = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"TAG":U,"")
       cEntry       = ENTRY(1,cTag,"|")
       lAddItemBand = IF cEntry = "CATG":U OR cEntry = "@CATG":U OR cEntry = "ITEM":U THEN NO ELSE YES
       NO-ERROR .
IF NOT lAddItemBand THEN
  ASSIGN cParentKey = IF ENTRY(1,cTag,"|") = "CATG":U OR ENTRY(1,cTag,"|") = "@CATG":U
                      THEN cKey
                      ELSE DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"PARENT":U,cKey)
         cTag       = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"TAG":U,cParentkey)
         cInsertKey = cParentKey
         cFirstKey  = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"CHILD":U,cInsertKey)
         cInsertTag = IF cFirstKey <> "" AND cFirstKey <> ?
                     THEN DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"TAG":U,cFirstKey)
                     ELSE ""
         NO-ERROR.

/* If adding item when band node is clicked or when adding item, add item node under category.
   Check whether category entered is different from current selected category. If so,
   get key of category and enter it under the proper node */
IF lAdditemBand OR DECIMAL(ENTRY(2,cTag,"|")) <> DECIMAL(ENTRY(2,pcNodeTag,"|")) THEN
DO:
  /* Find the category node and add item to it if it's already expanded */
  /* get Categories label node, and then the first child */
  ASSIGN
    cInsertKey = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"CHILD":U,"{&CATEGORY_NODE}":U).

  Child-Loop:
  DO WHILE cInsertKey <> "" AND cInsertKey <> ?:
    cInsertTag  = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"TAG":U,cInsertKey).
    IF decimal(ENTRY(2,cInsertTag,"|")) = decimal(ENTRY(2,pcNodeTag,"|")) THEN
      LEAVE CHILD-LOOP.

    cInsertKey  = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"NEXT":U,cInsertKey).
  END. /* End Loop through Category nodes */

  ASSIGN cFirstKey  = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"CHILD":U,cInsertKey)
         cInsertTag = IF cFirstKey <> "" AND cFirstKey <> ?
                      THEN DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"TAG":U,cFirstKey)
                      ELSE "".
END.
/* If already expanded, add it to category, else it will be displayed when user expands it */
IF cInsertTag <> "@Dummy":U THEN
DO:
    /* Insert deleted node at new position */
  hbuf:BUFFER-CREATE().
  ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
         cKey                          = hKey:BUFFER-VALUE
         hParentKey:BUFFER-VALUE       = cInsertKey
         hInsert:BUFFER-VALUE          = 4
         hLabel:BUFFER-VALUE           = pcNodeValue
         hImage:BUFFER-VALUE           = getItemImage(ENTRY(3,pcNodeTag,"|"))
         hSelectedImage:BUFFER-VALUE   = hImage:BUFFER-VALUE
         hSort:BUFFER-VALUE            = TRUE
         hTag:BUFFER-VALUE             = "ITEM|":U + pcNodeTag
         hExpanded:BUFFER-VALUE        = YES
         NO-ERROR.

  RUN addNode IN h_dyntreeview (hbuf).
  /* Expand node and select newly added item */
  IF NOT lAdditemBand THEN
  DO:
    cKey = getSelectedItem(cInsertKey, ENTRY(1,pcNodeTag,"|"), 2 ).
    IF cKey > "" THEN
      DYNAMIC-FUNCTION("setProperty":U IN h_dyntreeview,"SELECTEDITEM":U,cKey,"").
  END.
END.
ELSE IF NOT lAdditemBand THEN DO:
  /* Expand Node and find newly added item */
  DYNAMIC-FUNCTION("setProperty":U IN h_dyntreeview,"EXPANDED":U,cInsertKey,"yes":U).
  cKey = getSelectedItem(cInsertKey, ENTRY(1,pcNodeTag,"|"), 2 ).
  IF cKey > "" THEN
    DYNAMIC-FUNCTION("setProperty":U IN h_dyntreeview,"SELECTEDITEM":U,cKey,"").
END.

/* If adding an item and adding it to the band at the same time, add band item now */
IF lAddItemBand THEN
DO:
 ASSIGN
   cCols = DYNAMIC-FUNC("AddRow":U IN h_gsmitfullo,
                        "menu_structure_obj,menu_item_sequence,menu_item_obj":U)
   cCols = ENTRY(1,cCols,CHR(1))
   cCols = ENTRY(1,cCols)
   NO-ERROR.
       /* Submit the row to be added */
 IF cCols > "" AND cCols <> ? THEN
 DO:
   ASSIGN cItemObj = ENTRY(1,pcNodeTag,"|")
          cKey     = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"KEY":U,"")
          cTag     = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"TAG":U,"")
          cEntry   = ENTRY(1,cTag,"|").

   IF cEntry = "BAND":U OR cEntry = "@BAND":U THEN
     ASSIGN cBandObj  = ENTRY(2,cTag,"|")
            cSequence = "9999".
   ELSE IF cEntry = "BANDITEM":U OR cEntry = "@BANDITEM":U
          OR cEntry = "SUBBANDITEM":U  OR cEntry = "@SUBBANDITEM":U THEN
     ASSIGN cBandObj  = ENTRY(3,cTag,"|")
            cSequence = ENTRY(4,cTag,"|")
            iSequence = INT(cSequence) + 1
            cSequence = STRING(iSequence)
            NO-ERROR.
   ELSE IF cEntry = "TBARBAND":U OR cEntry = "@TBARBAND":U THEN
     ASSIGN cBandObj  = ENTRY(3,cTag,"|")
            cSequence = "9999".
   lOK = DYNAMIC-FUNC("SubmitRow":U IN h_gsmitfullo,
                      cCols, /* pcRowIdent */
                      "menu_structure_obj":U + CHR(1) + cBandObj + CHR(1) +
                      "menu_item_sequence":U + CHR(1) + cSequence + CHR(1) +
                      "menu_item_obj":U + CHR(1) + cItemObj             ).
   IF lOK THEN
   DO:
     RUN refreshRow IN h_gsmitfullo.
     cMenuItemObj = DYNAMIC-FUNC("columnStringValue":U IN h_gsmitfullo,"menu_structure_item_obj":U).
     cSequence    = DYNAMIC-FUNC("columnStringValue":U IN h_gsmitfullo,"menu_item_sequence":U).

     RUN addNode ("BANDITEM":U,
                  pcNodeValue,
                  cMenuItemObj       + "|" + cBandObj + "|" + cSequence + "|" +
                  ENTRY(3,pcNodeTag,"|") + "|" + "0"      + "|" + cItemObj).


   END.
 END.


END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wiWin  _ADM-CREATE-OBJECTS
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
             INPUT  'af/obj2/gsmmsfullo.wDB-AWARE':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'AppServiceAstraASUsePromptnoASInfoForeignFieldsRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNamegsmmsfulloUpdateFromSourcenoToggleDataTargetsyesOpenOnInitnoPromptOnDeleteyesPromptColumns(NONE)':U ,
             OUTPUT h_gsmmsfullo ).
       RUN repositionObject IN h_gsmmsfullo ( 18.86 , 130.00 ) NO-ERROR.
       /* Size in AB:  ( 1.91 , 13.00 ) */

       RUN constructObject (
             INPUT  'af/obj2/gsmitfullo.wDB-AWARE':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'AppServiceAstraASUsePromptASInfoForeignFieldsgsm_menu_structure_item.menu_structure_obj,menu_structure_objRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNamegsmitfulloUpdateFromSourcenoToggleDataTargetsyesOpenOnInitnoPromptOnDeleteyesPromptColumns(NONE)':U ,
             OUTPUT h_gsmitfullo ).
       RUN repositionObject IN h_gsmitfullo ( 19.14 , 77.00 ) NO-ERROR.
       /* Size in AB:  ( 1.86 , 14.00 ) */

       RUN constructObject (
             INPUT  'af/obj2/gsmomfullo.wDB-AWARE':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'AppServiceAstraASUsePromptnoASInfoForeignFieldsgsm_object_menu_structure.menu_structure_obj,menu_structure_objRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNamegsmomfulloUpdateFromSourcenoToggleDataTargetsyesOpenOnInitnoPromptOnDeleteyesPromptColumns(NONE)':U ,
             OUTPUT h_gsmomfullo ).
       RUN repositionObject IN h_gsmomfullo ( 19.14 , 48.00 ) NO-ERROR.
       /* Size in AB:  ( 1.86 , 13.00 ) */

       RUN constructObject (
             INPUT  'ry/obj/rycsoful2o.wDB-AWARE':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'AppServiceAstraASUsePromptnoASInfoForeignFieldsRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNamerycsoful2oUpdateFromSourcenoToggleDataTargetsyesOpenOnInitnoPromptOnDeleteyesPromptColumns(NONE)':U ,
             OUTPUT h_rycsoful2o ).
       RUN repositionObject IN h_rycsoful2o ( 19.14 , 90.00 ) NO-ERROR.
       /* Size in AB:  ( 1.86 , 14.00 ) */

       RUN constructObject (
             INPUT  'af/obj2/gsmtmfullo.wDB-AWARE':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'AppServiceAstraASUsePromptASInfoForeignFieldsgsm_toolbar_menu_structure.object_obj,smartobject_objRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNamegsmtmfulloUpdateFromSourcenoToggleDataTargetsyesOpenOnInitnoPromptOnDeleteyesPromptColumns(NONE)':U ,
             OUTPUT h_gsmtmfullo ).
       RUN repositionObject IN h_gsmtmfullo ( 19.14 , 62.00 ) NO-ERROR.
       /* Size in AB:  ( 1.86 , 14.00 ) */

       RUN constructObject (
             INPUT  'af/obj2/gscicfullo.wDB-AWARE':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'AppServiceAstraASUsePromptASInfoForeignFieldsRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNamegscicfulloUpdateFromSourcenoToggleDataTargetsyesOpenOnInityesPromptOnDeleteyesPromptColumns(NONE)':U ,
             OUTPUT h_gscicfullo ).
       RUN repositionObject IN h_gscicfullo ( 19.14 , 117.00 ) NO-ERROR.
       /* Size in AB:  ( 1.86 , 13.00 ) */

       RUN constructObject (
             INPUT  'af/obj2/gsmmifullo.wDB-AWARE':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'AppServiceAstraASUsePromptnoASInfoForeignFieldsRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNamegsmmifulloUpdateFromSourcenoToggleDataTargetsyesOpenOnInitnoPromptOnDeleteyesPromptColumns(NONE)':U ,
             OUTPUT h_gsmmifullo ).
       RUN repositionObject IN h_gsmmifullo ( 19.14 , 105.00 ) NO-ERROR.
       /* Size in AB:  ( 1.86 , 12.00 ) */

       RUN constructObject (
             INPUT  'af/obj2/gscpm2fullo.wDB-AWARE':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'AppServiceAstraASUsePromptASInfoForeignFieldsRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNamegscpm2fulloUpdateFromSourcenoToggleDataTargetsyesOpenOnInityesPromptOnDeleteyesPromptColumns(NONE)':U ,
             OUTPUT h_gscpm2fullo ).
       RUN repositionObject IN h_gscpm2fullo ( 19.14 , 144.00 ) NO-ERROR.
       /* Size in AB:  ( 1.86 , 15.00 ) */

       RUN constructObject (
             INPUT  'af/obj2/gscotfullo.wDB-AWARE':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'AppServiceAstraASUsePromptnoASInfoForeignFieldsRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNamegscotfulloUpdateFromSourcenoToggleDataTargetsyesOpenOnInitnoPromptOnDeleteyesPromptColumns(NONE)':U ,
             OUTPUT h_gscotfullo ).
       RUN repositionObject IN h_gscotfullo ( 21.24 , 144.00 ) NO-ERROR.
       /* Size in AB:  ( 1.86 , 15.00 ) */

       RUN constructObject (
             INPUT  'af/sup2/afspfoldrw.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FolderLabels':U + 'Toolbar && Menu Designer' + 'TabFGcolor':U + 'Default' + 'TabBGcolor':U + 'Default' + 'TabINColor':U + 'GrayText' + 'ImageEnabled':U + '' + 'ImageDisabled':U + '' + 'Hotkey':U + '' + 'Tooltip':U + '' + 'TabHidden':U + 'no' + 'EnableStates':U + 'All' + 'DisableStates':U + 'All' + 'VisibleRows':U + '10' + 'PanelOffset':U + '20' + 'FolderMenu':U + '' + 'TabsPerRow':U + '2' + 'TabHeight':U + '3' + 'TabFont':U + '4' + 'LabelOffset':U + '0' + 'ImageWidth':U + '0' + 'ImageHeight':U + '0' + 'ImageXOffset':U + '0' + 'ImageYOffset':U + '2' + 'TabSize':U + 'Proportional' + 'SelectorFGcolor':U + 'Default' + 'SelectorBGcolor':U + 'Default' + 'SelectorFont':U + '4' + 'SelectorWidth':U + '3' + 'TabPosition':U + 'Upper' + 'MouseCursor':U + '' + 'InheritColor':U + 'no' + 'TabVisualization':U + 'Tabs' + 'PopupSelectionEnabled':U + 'yes' + 'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_folder ).
       RUN repositionObject IN h_folder ( 1.05 , 47.80 ) NO-ERROR.
       RUN resizeObject IN h_folder ( 17.57 , 107.20 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyntreeview.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'AutoSortnoHideSelectionnoImageHeight16ImageWidth16ShowCheckBoxesnoShowRootLinesnoTreeStyle7ExpandOnAddnoFullRowSelectnoOLEDragnoOLEDropnoScrollyesSingleSelnoIndentation20LabelEdit1LineStyle1HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dyntreeview ).
       RUN repositionObject IN h_dyntreeview ( 3.38 , 1.00 ) NO-ERROR.
       RUN resizeObject IN h_dyntreeview ( 19.48 , 44.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/pupdsav.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'AddFunctionOne-RecordEdgePixels0PanelTypeSaveDeactivateTargetOnHidenoDisabledActionsHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_pupdsav ).
       RUN repositionObject IN h_pupdsav ( 21.71 , 71.00 ) NO-ERROR.
       RUN resizeObject IN h_pupdsav ( 1.76 , 60.00 ) NO-ERROR.

       /* Links to SmartDataObject h_gsmitfullo. */
       RUN addLink ( h_gsmmsfullo , 'Data':U , h_gsmitfullo ).

       /* Links to SmartDataObject h_gsmomfullo. */
       RUN addLink ( h_gsmmsfullo , 'Data':U , h_gsmomfullo ).

       /* Links to SmartDataObject h_gsmtmfullo. */
       RUN addLink ( h_rycsoful2o , 'Data':U , h_gsmtmfullo ).

       /* Links to SmartFolder h_folder. */
       RUN addLink ( h_folder , 'Page':U , THIS-PROCEDURE ).

       /* Links to SmartTreeView h_dyntreeview. */
       RUN addLink ( h_dyntreeview , 'TreeView':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_folder ,
             coModule:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( h_pupdsav ,
             h_dyntreeview , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 2 THEN DO:
       RUN constructObject (
             INPUT  'af/obj2/gsmombrow.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'ScrollRemotenoNumDown0CalcWidthnoMaxWidth80FetchOnReposToEndyesDataSourceNamesUpdateTargetNamesLogicalObjectNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gsmombrow ).
       RUN repositionObject IN h_gsmombrow ( 2.67 , 51.00 ) NO-ERROR.
       RUN resizeObject IN h_gsmombrow ( 6.91 , 99.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'af/obj2/gsmomviewt.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'EnabledObjFldsToDisable(None)ModifyFields(All)DataSourceNamesUpdateTargetNamesLogicalObjectNameLogicalObjectNamePhysicalObjectNamegsmomviewt.wDynamicObjectnoRunAttributeHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gsmomviewt ).
       RUN repositionObject IN h_gsmomviewt ( 10.05 , 50.00 ) NO-ERROR.
       /* Size in AB:  ( 8.81 , 106.00 ) */

       /* Links to SmartDataBrowser h_gsmombrow. */
       RUN addLink ( h_gsmomfullo , 'Data':U , h_gsmombrow ).

       /* Links to SmartDataViewer h_gsmomviewt. */
       RUN addLink ( h_gsmomfullo , 'Data':U , h_gsmomviewt ).
       RUN addLink ( h_gsmomviewt , 'Update':U , h_gsmomfullo ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_folder ,
             coModule:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( h_dyntreeview ,
             h_gsmombrow , 'AFTER':U ).
       RUN adjustTabOrder ( h_gsmomviewt ,
             h_dyntreeview , 'AFTER':U ).
       RUN adjustTabOrder ( h_pupdsav ,
             h_gsmomviewt , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 5 THEN DO:
       RUN constructObject (
             INPUT  'af/obj2/gscicview.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'EnabledObjFldsToDisable(None)ModifyFields(All)DataSourceNamesUpdateTargetNamesLogicalObjectNameLogicalObjectNamePhysicalObjectNamerysttviewv.wDynamicObjectnoRunAttributeHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gscicview ).
       RUN repositionObject IN h_gscicview ( 4.57 , 48.00 ) NO-ERROR.
       /* Size in AB:  ( 6.48 , 104.00 ) */

       /* Links to SmartDataViewer h_gscicview. */
       RUN addLink ( h_gscicfullo , 'Data':U , h_gscicview ).
       RUN addLink ( h_gscicview , 'Update':U , h_gscicfullo ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_folder ,
             coModule:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( h_gscicview ,
             h_dyntreeview , 'AFTER':U ).
       RUN adjustTabOrder ( h_pupdsav ,
             h_gscicview , 'AFTER':U ).
    END. /* Page 5 */
    WHEN 6 THEN DO:
       RUN constructObject (
             INPUT  'af/obj2/gsmmsview.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'EnabledObjFldsToDisable(None)ModifyFields(All)DataSourceNamesUpdateTargetNamesLogicalObjectNameLogicalObjectNamePhysicalObjectNamegsmmsview.wDynamicObjectnoRunAttributeHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gsmmsview ).
       RUN repositionObject IN h_gsmmsview ( 4.81 , 47.00 ) NO-ERROR.
       /* Size in AB:  ( 12.29 , 111.00 ) */

       /* Links to SmartDataViewer h_gsmmsview. */
       RUN addLink ( h_gsmmsfullo , 'Data':U , h_gsmmsview ).
       RUN addLink ( h_gsmmsview , 'Update':U , h_gsmmsfullo ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_folder ,
             coModule:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( h_gsmmsview ,
             h_dyntreeview , 'AFTER':U ).
       RUN adjustTabOrder ( h_pupdsav ,
             h_gsmmsview , 'AFTER':U ).
    END. /* Page 6 */
    WHEN 7 THEN DO:
       RUN constructObject (
             INPUT  'af/obj2/gsmmiview.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'EnabledObjFldsToDisable(None)ModifyFields(All)DataSourceNamesUpdateTargetNamesLogicalObjectNameLogicalObjectNamePhysicalObjectNamegsmmiview.wDynamicObjectnoRunAttributeHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gsmmiview ).
       RUN repositionObject IN h_gsmmiview ( 2.67 , 47.00 ) NO-ERROR.
       /* Size in AB:  ( 19.05 , 109.00 ) */

       /* Links to SmartDataViewer h_gsmmiview. */
       RUN addLink ( h_gsmmifullo , 'Data':U , h_gsmmiview ).
       RUN addLink ( h_gsmmiview , 'Update':U , h_gsmmifullo ).
       RUN addLink ( THIS-PROCEDURE , 'MenuItem':U , h_gsmmiview ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_folder ,
             coModule:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( h_gsmmiview ,
             coObjType:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_pupdsav ,
             h_dyntreeview , 'AFTER':U ).
    END. /* Page 7 */
    WHEN 8 THEN DO:
       RUN constructObject (
             INPUT  'af/obj2/gsmitview.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'EnabledObjFldsToDisable(None)ModifyFields(All)DataSourceNamesUpdateTargetNamesLogicalObjectNameLogicalObjectNamePhysicalObjectNamerysttviewv.wDynamicObjectnoRunAttributeHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gsmitview ).
       RUN repositionObject IN h_gsmitview ( 5.05 , 48.00 ) NO-ERROR.
       /* Size in AB:  ( 8.00 , 104.60 ) */

       /* Links to SmartDataViewer h_gsmitview. */
       RUN addLink ( h_gsmitfullo , 'Data':U , h_gsmitview ).
       RUN addLink ( h_gsmitview , 'Update':U , h_gsmitfullo ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_folder ,
             coModule:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( h_gsmitview ,
             h_dyntreeview , 'AFTER':U ).
       RUN adjustTabOrder ( h_pupdsav ,
             h_gsmitview , 'AFTER':U ).
    END. /* Page 8 */
    WHEN 9 THEN DO:
       RUN constructObject (
             INPUT  'af/obj2/gscobviewt.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'EnabledObjFldsToDisable(None)ModifyFields(All)DataSourceNamesUpdateTargetNamesLogicalObjectNameLogicalObjectNamePhysicalObjectNamerysttviewv.wDynamicObjectnoRunAttributeHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gscobviewt ).
       RUN repositionObject IN h_gscobviewt ( 4.81 , 49.00 ) NO-ERROR.
       /* Size in AB:  ( 10.43 , 104.00 ) */

       /* Links to SmartDataViewer h_gscobviewt. */
       RUN addLink ( h_rycsoful2o , 'Data':U , h_gscobviewt ).
       RUN addLink ( h_gscobviewt , 'Update':U , h_rycsoful2o ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_folder ,
             coModule:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( h_gscobviewt ,
             h_dyntreeview , 'AFTER':U ).
       RUN adjustTabOrder ( h_pupdsav ,
             h_gscobviewt , 'AFTER':U ).
    END. /* Page 9 */
    WHEN 10 THEN DO:
       RUN constructObject (
             INPUT  'af/obj2/gsmtmview.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'EnabledObjFldsToDisable(None)ModifyFields(All)DataSourceNamesUpdateTargetNamesLogicalObjectNameLogicalObjectNamePhysicalObjectNamegsmtmview.wDynamicObjectnoRunAttributeHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gsmtmview ).
       RUN repositionObject IN h_gsmtmview ( 4.81 , 48.00 ) NO-ERROR.
       /* Size in AB:  ( 7.62 , 101.00 ) */

       /* Links to SmartDataViewer h_gsmtmview. */
       RUN addLink ( h_gsmtmfullo , 'Data':U , h_gsmtmview ).
       RUN addLink ( h_gsmtmview , 'Update':U , h_gsmtmfullo ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_folder ,
             coModule:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( h_gsmtmview ,
             h_dyntreeview , 'AFTER':U ).
       RUN adjustTabOrder ( h_pupdsav ,
             h_gsmtmview , 'AFTER':U ).
    END. /* Page 10 */

  END CASE.
  /* Select a Startup page. */
  IF currentPage eq 0
  THEN RUN selectPage IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildMenus wiWin 
PROCEDURE buildMenus :
/*------------------------------------------------------------------------------
  Purpose:     Used to build the treeview popUp menus as weel as the
               Window and Help subMenus in the menuBar.
  Parameters:  <none>
  Notes:       Called from initializeObject.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hMenu       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hMenuWindow AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hMenuHelp   AS HANDLE     NO-UNDO.


  /* ****** PopUp Menus ****************** */

  /* Build category Label menu */
  CREATE MENU ghCategoryLabel
  ASSIGN POPUP-ONLY = TRUE
  TITLE = "Button State".

  CREATE MENU-ITEM hMenu
  ASSIGN PARENT = ghCategoryLabel
         LABEL = "Add Category"
         TRIGGERS:
           ON CHOOSE
               PERSISTENT RUN DisplayAddMode IN THIS-PROCEDURE ("CATG":U).
         END TRIGGERS.

   /* Build Category  menu */
  CREATE MENU ghCategory
  ASSIGN POPUP-ONLY = TRUE
  TITLE = "Button State".

  CREATE MENU-ITEM hMenu
  ASSIGN PARENT = ghCategory
         LABEL = "Add Item"
         TRIGGERS:
           ON CHOOSE
               PERSISTENT RUN DisplayAddMode IN THIS-PROCEDURE ("Item":U).
         END TRIGGERS.

  CREATE MENU-ITEM hMenu
  ASSIGN PARENT = ghCategory
         SUBTYPE = "RULE".

  CREATE MENU-ITEM hMenu
  ASSIGN PARENT = ghCategory
         LABEL = "Delete"
         TRIGGERS:
           ON CHOOSE
               PERSISTENT RUN DeleteNode IN THIS-PROCEDURE ("Category":U,YES).
         END TRIGGERS.

   /* Build Item  menu */
  CREATE MENU ghItem
  ASSIGN POPUP-ONLY = TRUE
  TITLE = "Button State".

  CREATE MENU-ITEM hMenu
  ASSIGN PARENT = ghItem
         LABEL = "Add Item"
         TRIGGERS:
           ON CHOOSE
               PERSISTENT RUN DisplayAddMode IN THIS-PROCEDURE ("Item":U).
         END TRIGGERS.

  CREATE MENU-ITEM hMenu
  ASSIGN PARENT = ghItem
         SUBTYPE = "RULE".

  CREATE MENU-ITEM hMenu
  ASSIGN PARENT = ghItem
         LABEL = "Delete"
         TRIGGERS:
           ON CHOOSE
               PERSISTENT RUN DeleteNode IN THIS-PROCEDURE ("Item":U,YES).
         END TRIGGERS.

/* Build Band Label menu */
  CREATE MENU ghBandLabel
  ASSIGN POPUP-ONLY = TRUE
  TITLE = "Button State".

  CREATE MENU-ITEM hMenu
  ASSIGN PARENT = ghBandLabel
         LABEL = "Add Band"
         TRIGGERS:
           ON CHOOSE
               PERSISTENT RUN DisplayAddMode IN THIS-PROCEDURE ("Band":U).
        END TRIGGERS.

   /* Build Band  menu */
  CREATE MENU ghBand
  ASSIGN POPUP-ONLY = TRUE
  TITLE = "Button State".

  CREATE MENU-ITEM hMenu
  ASSIGN PARENT = ghBand
         LABEL = "Add Item to Band"
         TRIGGERS:
           ON CHOOSE
               PERSISTENT RUN DisplayAddMode IN THIS-PROCEDURE ("BandItem":U).
         END TRIGGERS.

  CREATE MENU-ITEM hMenu
  ASSIGN PARENT = ghBand
         SUBTYPE = "RULE".

  CREATE MENU-ITEM hMenu
  ASSIGN PARENT = ghBand
         LABEL = "Delete"
         TRIGGERS:
           ON CHOOSE
               PERSISTENT RUN DeleteNode IN THIS-PROCEDURE ("BandItem":U,YES).
         END TRIGGERS.

  /* Build Band item menu */
  CREATE MENU ghBandItem
  ASSIGN POPUP-ONLY = TRUE
  TITLE = "Button State".

  CREATE MENU-ITEM hMenu
  ASSIGN PARENT = ghBandItem
         LABEL = "Add Item to Band"
         TRIGGERS:
           ON CHOOSE
               PERSISTENT RUN DisplayAddMode IN THIS-PROCEDURE ("BandItem":U).
         END TRIGGERS.

  CREATE MENU-ITEM hMenu
  ASSIGN PARENT = ghBandItem
         SUBTYPE = "RULE".

  CREATE MENU-ITEM hMenu
  ASSIGN PARENT = ghBandItem
         LABEL = "Move Up"
         TRIGGERS:
           ON CHOOSE
               PERSISTENT RUN MoveNode IN THIS-PROCEDURE ("Up":U).
         END TRIGGERS.

   CREATE MENU-ITEM hMenu
   ASSIGN PARENT = ghBandItem
         LABEL = "Move Down"
         TRIGGERS:
           ON CHOOSE
               PERSISTENT RUN MoveNode IN THIS-PROCEDURE ("Down":U).
         END TRIGGERS.

  CREATE MENU-ITEM hMenu
  ASSIGN PARENT = ghBandItem
         SUBTYPE = "RULE".

  CREATE MENU-ITEM hMenu
  ASSIGN PARENT = ghBandItem
         LABEL = "Delete"
         TRIGGERS:
           ON CHOOSE
               PERSISTENT RUN DeleteNode IN THIS-PROCEDURE ("BandItem":U,YES).
         END TRIGGERS.


 /* Build Toolbar Label menu */
  CREATE MENU ghTbarLabel
  ASSIGN POPUP-ONLY = TRUE
  TITLE = "Button State".

  CREATE MENU-ITEM hMenu
  ASSIGN PARENT = ghTbarLabel
         LABEL = "Add Toolbar Object"
         TRIGGERS:
           ON CHOOSE
               PERSISTENT RUN DisplayAddMode IN THIS-PROCEDURE ("TBarObj":U).
         END TRIGGERS.


/* Build Toolbar Object menu */
  CREATE MENU ghTbarObj
  ASSIGN POPUP-ONLY = TRUE
  TITLE = "Button State".

  CREATE MENU-ITEM hMenu
  ASSIGN PARENT = ghTbarObj
         LABEL = "Add Toolbar Band"
         TRIGGERS:
           ON CHOOSE
               PERSISTENT RUN DisplayAddMode IN THIS-PROCEDURE ("TbarBand":U).
         END TRIGGERS.

  CREATE MENU-ITEM hMenu
  ASSIGN PARENT = ghTbarObj
         SUBTYPE = "RULE".

  CREATE MENU-ITEM hMenu
  ASSIGN PARENT = ghTbarObj
         LABEL = "Delete"
         TRIGGERS:
           ON CHOOSE
               PERSISTENT RUN DeleteNode IN THIS-PROCEDURE ("TbarBand":U,YES).
         END TRIGGERS.


/* ****** WIndow and Help SubMenus ****************** */

 /* Create dynamic Window and Help menu items off the main menubar. */
  CREATE SUB-MENU hMenuWindow
    ASSIGN
      LABEL = "Window"
      PARENT = MENU MENU-BAR-wiWin:HANDLE
      SENSITIVE = TRUE
      TRIGGERS:
         ON "MENU-DROP":U PERSISTENT RUN af/sup/afbldwindp2.p (THIS-PROCEDURE,
                                                              hMenuWindow,
                                                              {&WINDOW-NAME}).
      END TRIGGERS.

  CREATE SUB-MENU hMenuHelp
    ASSIGN
      LABEL = "Help"
      PARENT = MENU MENU-BAR-wiWin:HANDLE
      SENSITIVE = TRUE.

  CREATE MENU-ITEM hMenuWindow
     ASSIGN
       LABEL = "Help Topics"
       PARENT = hMenuHelp
       SENSITIVE = TRUE
       TRIGGERS:
           ON "CHOOSE":U PERSISTENT RUN helpTopics IN gshSessionManager  (THIS-PROCEDURE).
      END TRIGGERS.

  CREATE MENU-ITEM hMenuWindow
     ASSIGN
       LABEL = "Help Contents"
       PARENT = hMenuHelp
       SENSITIVE = TRUE
       TRIGGERS:
           ON "CHOOSE":U PERSISTENT RUN helpContents IN gshSessionManager  (THIS-PROCEDURE).
      END TRIGGERS.

  CREATE MENU-ITEM hMenuWindow
     ASSIGN
       SUBTYPE = "RULE"
       PARENT = hMenuHelp
       SENSITIVE = TRUE.

  CREATE MENU-ITEM hMenuWindow
      ASSIGN
        LABEL = "Help About"
        PARENT = hMenuHelp
        SENSITIVE = TRUE
       TRIGGERS:
           ON "CHOOSE":U PERSISTENT RUN helpAbout IN gshSessionManager  (THIS-PROCEDURE).
      END TRIGGERS.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE centerObject wiWin 
PROCEDURE centerObject :
/*------------------------------------------------------------------------------
  Purpose:     Centers a smartViewer within the folder. Resizes smartViewer accordingly.
  Parameters:  phObject    andle of SmartViewer
               piWay       1  Folder area width is being reduced. Do a resize then reposition
                           2  Folder area width is being increased. Do a reposition then resize
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phObject  AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER piway     AS INTEGER    NO-UNDO.

DEFINE VARIABLE hFrame AS HANDLE     NO-UNDO.
DEFINE VARIABLE dRow   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dWidth AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dCol   AS DECIMAL    NO-UNDO.

{get ContainerHandle hFrame phObject}.
ASSIGN dRow   = MAX(1,hFrame:ROW)
       dWidth = {&WINDOW-NAME}:WIDTH - btnSplitBar:COL in FRAME {&frame-name} - 3
       dCol   = btnSplitBar:COL + 2.

IF piWay = 1 THEN DO:  /* When increasing the splitbar, this decreases the available size in the folder */
  IF dWidth < hFrame:VIRTUAL-WIDTH  THEN
  DO:
    ASSIGN  hFrame:SCROLLABLE    = TRUE
            hFrame:WIDTH = dWidth
            NO-ERROR.
  END.
  ELSE
    ASSIGN hFrame:WIDTH = hFrame:VIRTUAL-WIDTH
           dCol = dCol + (dWidth - hFrame:WIDTH)  / 2.

    RUN repositionObject IN phObject (INPUT dRow, dcol).
END.
ELSE DO:  /* When decreasing the splitbar, this increases the available size in the folder */
  IF dWidth <= hFrame:VIRTUAL-WIDTH  THEN
  DO:
    RUN repositionObject IN phObject (INPUT dRow, dcol).
    ASSIGN hFrame:SCROLLABLE  = TRUE
           hFrame:WIDTH       = dWidth  NO-ERROR.
  END.
  ELSE DO:
    RUN repositionObject IN phObject (INPUT dRow, dcol).
    ASSIGN  hFrame:WIDTH = hFrame:VIRTUAL-WIDTH
            dCol             = dCol + (dWidth - 2 - hFrame:WIDTH) / 2 + 1.
    RUN repositionObject IN phObject (INPUT dRow, dcol).
    ASSIGN hFrame:SCROLLABLE = FALSE.
  END.
END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeModule wiWin 
PROCEDURE changeModule :
/*------------------------------------------------------------------------------
  Purpose:     Resets module global variable and refreshes tree
  Parameters:  pcModuleObj       ObjectID of selected module
               pcModuleCodeDesc  Module code of selected module
  Notes:       Called from value-change trigger of combo-box
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcModuleObj         AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcModuleCodeDesc    AS CHARACTER  NO-UNDO.

ASSIGN gcModuleObj = pcModuleObj.
IF pcModuleCodeDesc <> "<All>":U THEN
   ASSIGN gcModuleCode = trim(ENTRY(1,pcModuleCodeDesc,"/"))
          gcModuleDesc = trim(ENTRY(3,pcModuleCodeDesc,"/")).
ELSE
   ASSIGN gcModuleCode = ""
          gcModuleDesc = "".

RUN refreshTree.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjects wiWin 
PROCEDURE createObjects :
/*------------------------------------------------------------------------------
  Purpose:     Set the hideOnInit for all new objects that are created.
               This will ensure that the viewers won;t be visualized in their
               original design positions, in case the splitbar is moved before
               the object is initialized.
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObject      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCurrentPage AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hObject      AS HANDLE     NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  {get CurrentPage iCurrentPage}.
  /* Code placed here will execute AFTER standard behavior.    */
  cObject = pageNTargets(TARGET-PROCEDURE, iCurrentPage) NO-ERROR.
  DO i = 1 TO NUM-ENTRIES(cObject):
    hObject = WIDGET-HANDLE(ENTRY(i,cObject)) NO-ERROR.
    IF VALID-HANDLE(hObject) THEN
    DO:
       {set HideOnInit YES hObject}.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteNode wiWin 
PROCEDURE deleteNode :
/*------------------------------------------------------------------------------
  Purpose:     Used to delete nodes. Called from persistent triggers on frame menus
               created in afmenumaintf.w
  Parameters:  pcNodeType   The type of node to delete
               plDeleteRow  Flag to specify whether to delete the current
                            in the viewer

  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcNodeType  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plDeleteRow AS LOGICAL    NO-UNDO.

DEFINE VARIABLE cKey       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTag       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTagNext   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNext      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cClickNext AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cParentKey AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFirstKey  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRowIdent  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop      AS INTEGER    NO-UNDO.


IF plDeleteRow AND Valid-handle(ghTableIOTarget) THEN DO:
    IF pcNodeType = "BandItem":U THEN
       RUN deleteRecord IN h_gsmitview.
    ELSE
       RUN deleteRecord IN ghTableIOTarget.
    {get RowIDent cRowIdent ghTableIOTarget}.
    IF cRowIdent <> ? THEN
         RETURN.

END.

ASSIGN cKey   = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"KEY":U,"")
       cNext  = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"NEXT":U,"")
       cNext  = IF cNext = "" OR cNext = ?
                THEN  DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"PREVIOUS":U,"")
                ELSE  cNext
       cNext  = IF cNext = "" OR cNext = ?
                THEN  DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"PARENT":U,"")
                ELSE cNext
       cClickNext = cNext
       cTag   = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"TAG":U,cNext)
       cTagNext = cTag
       NO-ERROR .

RUN deleteNode IN h_dyntreeview(cKey).

DYNAMIC-FUNCTION("setProperty":U IN h_dyntreeview,"SELECTEDITEM":U,cNext,"").


IF pcNodeType = "Banditem":U THEN
DO:
   /* Find where to insert key based on menu sequence field */
 ASSIGN
  cParentKey = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"PARENT":U,"")
  cNext      = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"CHILD":U,cParentKey)
  cTag       = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"TAG":U,cNext)
 .
 IF NOT cTag BEGINS "BANDITEM":U THEN DO:
   RUN treeClick (cClickNext,cTagNext).
   RETURN.
 END.
  /* Loop through all items of the band to determine the insert location */
  ASSIGN iLoop      = 1.
  Child-Loop:
  DO WHILE cNext <> "" AND cNext <> ?:
     ASSIGN cTag = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"TAG":U,cNext)

        /* Resequence all sequence values */
     ENTRY(4,cTag,"|") = STRING(iLoop).
     DYNAMIC-FUNC("setProperty":U IN h_dyntreeview,"TAG":U,cNext,cTag)     .
     ASSIGN cNext  = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"NEXT":U,cNext)
            iLoop  = iLoop + 1.
  END.
  RUN refreshBand ( cParentKey , ENTRY(3,cTagNext,"|")).

END.

RUN treeClick (cClickNext,cTagNext).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject wiWin 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Unregisters all toolbars that have been registered with the
               property sheet library.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cToolbarName            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                   AS INTEGER    NO-UNDO.

IF VALID-HANDLE(ghPropSheetLib) THEN
DO:
  DO iLoop = 1 TO NUM-ENTRIES(gcRegisteredToolbars,CHR(3)) BY 2:
    cToolbarName = ENTRY(iLoop,gcRegisteredToolbars,CHR(3)).
   
    RUN unregisterObject IN ghPropSheetLib
       (THIS-PROCEDURE,    /* Calling procedure handle */
        cToolbarName,      /* Name of container object */
        cToolbarName).      /* Name of object.. same as container */
  END.
  RUN destroyObject IN ghPropSheetLib.
END.


RUN SUPER.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wiWin  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wiWin)
  THEN DELETE WIDGET wiWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayAddMode wiWin 
PROCEDURE displayAddMode :
/*------------------------------------------------------------------------------
  Purpose:    Go into add mode for the selected node
              Display the category viewer, and go immediately into add mode
  Parameters: pcType   Node type selected to add
  Notes:      Called from persistent triggers in popup menus,
              created in procedure buildmenus
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcType AS CHARACTER  NO-UNDO.

DEFINE VARIABLE lCancel      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cTabFolder   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCurrentPage AS INTEGER    NO-UNDO.
DEFINE VARIABLE cTag         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ctagType     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNewTag      AS CHARACTER  NO-UNDO.


ASSIGN cTag                 = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"TAG":U,"")
       cTagType             = ENTRY(1,cTag,"|")
       cNewTag              = FILL("|",7)
       ENTRY(1,cNewTag,"|") = pcType.

IF pcType = "BANDITEM":U AND (cTagType = "BAND":U OR cTagType = "@BAND":U) THEN
  ASSIGN ENTRY(3,cNewTag,"|") = ENTRY(2,cTag,"|").
ELSE IF pcType = "BANDITEM":U AND (cTagType = "BANDITEM":U OR cTagType = "@BANDITEM":U) THEN
  ASSIGN ENTRY(3,cNewTag,"|") = ENTRY(3,cTag,"|").
ELSE IF pcType = "TBARBAND":U THEN
  ENTRY(5,cNewTag,"|") = ENTRY(2,cTag,"|").

RUN treeclick ("",cNewTag).
IF VALID-HANDLE(ghTableIOTarget) THEN
  RUN addRecord IN ghTableIOTarget.

IF pcType = "BAND":U AND NUM-ENTRIES(cTag,"|") = 2 THEN
      DYNAMIC-FUNC("setToolbarType":U IN h_gsmmsview,ENTRY(2,cTag,"|")).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayPropertySheet wiWin 
PROCEDURE displayPropertySheet :
/*------------------------------------------------------------------------------
  Purpose:     Called when the property sheet has been launched and the user 
               clicks on a smartToolbar node
  Parameters:  pcTag   Tag of SmartToolbar node
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcTag AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cToolbarName         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cToolbarObjectID     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttributeList       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cResultCode          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hPropSheet           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDesignManager       AS HANDLE     NO-UNDO.

ASSIGN cToolbarName       = ENTRY(3,pcTag,"|")
       cToolbarObjectID   = ENTRY(2,pcTag,"|")
       cResultCode        = ENTRY(4,pcTag,"|") 
       NO-ERROR.

/* If persisitant library hasn't yet been run, return. */
IF NOT VALID-HANDLE(ghPropSheetLib) THEN RETURN.

/* If property sheet is closed, return */
hPropSheet = DYNAMIC-FUNC("getPropSheet":U IN ghPropSheetLib).
IF NOT VALID-HANDLE(hPropSheet) THEN RETURN.

/* Ensure the smartToolbar is only registered once */
IF LOOKUP(cToolbarName,gcRegisteredToolbars,CHR(3)) = 0  THEN
DO:
  ASSIGN 
    gcRegisteredToolbars = gcRegisteredToolbars 
                           + (IF gcRegisteredToolbars = "" THEN "" ELSE CHR(3))
                           + cToolbarName + CHR(3) + cToolbarObjectID.
  
  ASSIGN hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U) NO-ERROR.
  /* Retrieve the objects and instances for the current existing object opened in the appBuilder */
  RUN retrieveDesignObject IN hDesignManager ( INPUT  cToolbarName,
                                               INPUT  cresultCode,  /* Result Code */
                                               OUTPUT TABLE ttObject,
                                               OUTPUT TABLE ttPage,
                                               OUTPUT TABLE ttLink,
                                               OUTPUT TABLE ttUiEvent,
                                               OUTPUT TABLE ttObjectAttribute ) NO-ERROR.

  
  /* get the master Object */
  FIND FIRST ttObject WHERE ttObject.tContainerSmartObjectObj = 0 NO-ERROR.
  IF AVAIL ttObject THEN 
  DO:
     /* Now get attribute values */       
     FOR EACH ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                  AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj:
          cAttributeList = cAttributeList + (IF cAttributeList = "" THEN "" ELSE CHR(3))
                                          + ttObjectAttribute.tAttributeLabel + CHR(3) 
                                          + (IF cResultCode = "{&DEFAULT-RESULT-CODE}":U THEN "" ELSE cResultCode) + CHR(3) 
                                          + ttObjectAttribute.tAttributeValue.
     END. 
  END.
    
  RUN registerObject IN ghPropSheetLib
      (THIS-PROCEDURE,    /* Calling procedure handle */
       cToolbarName,      /* Name of container object */
       cToolbarName,      /*  Label of container */
       cToolbarName,      /* Name of object.. same as container */
       cToolbarName,      /* Label of object */
       coObjType:SCREEN-VALUE IN FRAME {&FRAME-NAME},  /* Class name */
       "":U,              /* Other supported classes */
       "MASTER":U,        /* Object level */
       cAttributeList,    /* List of attributes to set */
       "",                /* List of events to set */
       "",               /* Default attribute list */
       "",               /* Default event list */
       cResultCode     ).
END. /* END of Do once per Object */

IF VALID-HANDLE(ghPropSheetLib) THEN
   RUN displayProperties IN ghPropSheetLib 
              (THIS-PROCEDURE,
               cToolbarName,
               cToolbarName,
               cResultCode ,
               YES ,    /* make the result code disabled */
               1 ).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wiWin  _DEFAULT-ENABLE
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
  ENABLE btnRefresh buSearch rctTbar rctTbar-2 
      WITH FRAME frmToolbar IN WINDOW wiWin.
  {&OPEN-BROWSERS-IN-QUERY-frmToolbar}
  DISPLAY coModule coObjType 
      WITH FRAME frMain IN WINDOW wiWin.
  ENABLE coModule coObjType btnSplitBar 
      WITH FRAME frMain IN WINDOW wiWin.
  {&OPEN-BROWSERS-IN-QUERY-frMain}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wiWin 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE give-window-focus wiWin 
PROCEDURE give-window-focus :
/*------------------------------------------------------------------------------
  Purpose:     Called when a menu item from the Window sub menu off the menubar is
               selected
  Parameters: phHandle  handle of Window corresponding to selected menu item
       Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phHandle AS HANDLE     NO-UNDO.

IF VALID-HANDLE(phHandle) AND phHandle:TYPE = "WINDOW":U THEN
DO:
  APPLY "ENTRY":U TO phHandle.
  phHandle:MOVE-TO-TOP().
  IF phHandle:WINDOW-STATE = WINDOW-MINIMIZED
    THEN phHandle:WINDOW-STATE = WINDOW-NORMAL.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wiWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Load splitbar image, reposition folders and treeviews. Subscribe
               required events, populate Combo, call LoadTree.
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFilterSetClause    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterSetCode      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lmethodOK           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAvailable          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cCols               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cString             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop               AS INTEGER    NO-UNDO.

  IF 1 = 2 THEN VIEW FRAME {&FRAME-NAME}. /* Lazy frame scoping */

  ASSIGN gcToolbarClasses       = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "SmartToolbar":u)
         coObjType:LIST-ITEMS   = gcToolbarClasses
         coObjType:SCREEN-VALUE = coObjType:ENTRY(1)
         NO-ERROR.

  /* Set the OpenOnInit property to NO, so that SDO's do not initialize on
     opening of window */
  {set OpenOninit NO h_gsmmifullo}.
  {set OpenOninit NO h_gsmmsfullo}.
  {set OpenOninit NO h_gsmitfullo}.
  {set OpenOninit NO h_rycsoful2o}.
  {set OpenOninit NO h_gsmtmfullo}.
  {set OpenOninit NO h_gsmomfullo}.
  {set OpenOninit NO h_gscotfullo}.
  {set OpenOninit NO h_gscpm2fullo}.

  /* Set Minimum Height and Width */
  ASSIGN {&WINDOW-NAME}:MIN-HEIGHT-CHARS = {&WINDOW_HEIGHT_MIN} + 0.36
         {&WINDOW-NAME}:MIN-WIDTH-CHARS  = {&WINDOW_WIDTH_MIN}.

   /* set width of SplitBar button and load splitBar image */
  DO WITH  FRAME {&FRAME-NAME}:
     ASSIGN btnSplitBar:WIDTH =  1.2
            lmethodOK         = btnSplitBar:LOAD-MOUSE-POINTER("ry/img/splitbar.cur":U)
            lmethodOK         = btnSplitBar:MOVE-TO-TOP().
  END.
  {set HideOninit TRUE}.

  RUN SUPER.

  /* Set the filter set clause on the product module SDO after it is initialized, otherwise the information will be overwritten */
  RUN getFilterSetClause IN gshGenManager (INPUT-OUTPUT cFilterSetCode,           /* FilterSetCode        */
                                           INPUT        "GSCPM":U,                /* EntityList           */
                                           INPUT        "gsc_product_module,":U,  /* BufferList           */
                                           INPUT        "":U,                     /* AdditionalArguments  */
                                           OUTPUT       cFilterSetClause).        /* FilterSetClause      */

  {fnarg addQueryWhere      "cFilterSetClause, 'gsc_product_module':U, 'AND':U" h_gscpm2fullo}.
  {set   manualAddQueryWhere cFilterSetClause                                   h_gscpm2fullo}.

  {fn OpenQuery h_gscpm2fullo}.

  /* Load correct application icon */
  {aficonload.i}

  /* Create nodes in the SmartTreeview */
  RUN LoadTreeData.

  /* Ensure treeview and folder are in correct position and re sized properly  */
  RUN repositionObject IN h_folder   ( 1.00 , btnSplitBar:COL + btnSplitBar:WIDTH + 2.5 ) NO-ERROR.

  RUN resizeObject IN h_dyntreeview ({&WINDOW-NAME}:HEIGHT - FRAME {&FRAME-NAME}:ROW + 1.43,
                                       btnSplitBar:COL ).
  RUN resizeObject IN h_folder ({&WINDOW-NAME}:HEIGHT - FRAME {&FRAME-NAME}:ROW + 1,
                                    {&WINDOW-NAME}:WIDTH - btnSplitBar:COL - btnSplitBar:WIDTH - 2.5 ).

  /* Subscribe Treeview events */
  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "tvNodeEvent":U IN h_dyntreeview.


  /* populate Module combo-box */
  ASSIGN coModule:DELIMITER = CHR(2)
         coModule:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = "<All>" + CHR(2) + "0".
  
  lAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_gscpm2fullo,"CURRENT":U).

  MODULE-LOOP:
  DO WHILE lAvailable:
      cCols = DYNAMIC-FUNC("colValues":U IN h_gscpm2fullo,"product_module_obj,product_module_code,product_module_description":U).
      cString = TRIM(DYNAMIC-FUNC("columnStringValue":U IN h_gscpm2fullo,"product_module_obj":U)).

      IF {fn getSessionFilterSet gshGenManager} <> "":U THEN
         gcModuleCodeClause = gcModuleCodeClause
                            + (IF gcModuleCodeClause = "" THEN "" ELSE " OR ")
                            + "product_module_obj = " + QUOTER(ENTRY(2,cCols,CHR(1))).

      coModule:ADD-LAST(ENTRY(3,cCols,CHR(1)) + " // " + ENTRY(4,cCols,CHR(1)), cString).

      lAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_gscpm2fullo,"NEXT":U).

      IF lAvailable THEN
        RUN fetchNext IN h_gscpm2fullo.
  END.
  ASSIGN coModule:SCREEN-VALUE = "0".

  IF gcModuleCodeClause > "" THEN
     gcModuleCodeClause = "product_module_obj = " + QUOTER(0) + " OR " + gcModuleCodeClause.

  /* Build popup menus for treeview and Window and Help menu items for menuBar */
  RUN buildMenus.

  APPLY "WINDOW-RESIZED":U TO {&WINDOW-NAME}.
  
  RUN viewObject.

  RUN hideObject IN h_pupdsav.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE launchPropertySheet wiWin 
PROCEDURE launchPropertySheet :
/*------------------------------------------------------------------------------
  Purpose:    Launches the property sheet 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cTag       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hProcedure AS HANDLE     NO-UNDO.

/* Load the property sheet library procedure */
IF NOT VALID-HANDLE(ghPropSheetLib) THEN
DO:
   hProcedure = SESSION:FIRST-PROCEDURE.
   DO WHILE VALID-HANDLE(hProcedure) AND hProcedure:FILE-NAME NE "ry/prc/ryvobplipp.p":U:
     hProcedure = hProcedure:NEXT-SIBLING.
   END.
   IF NOT VALID-HANDLE(hProcedure) THEN
     RUN ry/prc/ryvobplipp.p PERSISTENT SET ghPropSheetLib NO-ERROR.
   ELSE 
     ASSIGN ghPropSheetLib = hProcedure.
   /* Subscribe to events */
   SUBSCRIBE TO 'PropertyChangedObject':U    IN ghPropSheetLib.
   SUBSCRIBE TO 'PropertyChangedResult':U    IN ghPropSheetLib.
   SUBSCRIBE TO 'PropertyChangedAttribute':U IN ghPropSheetLib.
   SUBSCRIBE TO 'PropertyChangedClass':U     IN ghPropSheetLib.

END.

IF VALID-HANDLE(ghPropSheetLib) THEN
DO:
  RUN launchPropertyWindow IN ghPropSheetLib. 
  
  ASSIGN cTag  = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"TAG":U,"").
  RUN DisplayPropertySheet IN THIS-PROCEDURE (cTag).
  
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadTreeData wiWin 
PROCEDURE loadTreeData :
/*------------------------------------------------------------------------------
  Purpose:     Initial loading of nodes
  Parameters:  <none>
  Notes:       This is called from the intializeObject procedure.
------------------------------------------------------------------------------*/
DEFINE VARIABLE hTable          AS HANDLE     NO-UNDO.

  /* BUFFER FIELD handles */
DEFINE VARIABLE hBuf            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hLabel          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hKey            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hParentKey      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTag            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hImage          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSelectedImage  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hExpanded       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSort           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hInsert         AS HANDLE     NO-UNDO.

DEFINE VARIABLE cParentKey      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCatgLabelKey   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBandLabelKey   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTbarLabelKey   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCatgKey        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRootKey        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lCatgAvailable  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lItemAvailable  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cCols           AS CHARACTER  NO-UNDO.

{get TreeDataTable hTable h_dyntreeview}.
IF NOT VALID-HANDLE(hTable) THEN DO:
    MESSAGE "Invalid Handle found for TreeData temp-table"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN.
END.

ASSIGN hBuf            = hTable:DEFAULT-BUFFER-HANDLE
       hKey            = hBuf:BUFFER-FIELD('node_key':U)
       hlabel          = hBuf:BUFFER-FIELD('node_label':U)
       hParentKey      = hBuf:BUFFER-FIELD('parent_node_key':U)
       hTag            = hBuf:BUFFER-FIELD('private_data':U)
       hImage          = hBuf:BUFFER-FIELD('image':U)
       hSelectedImage  = hBuf:BUFFER-FIELD('selected_image':U)
       hExpanded       = hBuf:BUFFER-FIELD('node_expanded':U)
       hSort           = hBuf:BUFFER-FIELD('node_sort':U)
       hInsert         = hBuf:BUFFER-FIELD('node_insert':U).

/* Clear the data from the TreeView */
hBuf:EMPTY-TEMP-TABLE().
RUN emptyTree IN h_dyntreeview.

  /* Add root node */
hbuf:BUFFER-CREATE().
ASSIGN hKey:BUFFER-VALUE             = "root":U
       hLabel:BUFFER-VALUE           = "Toolbar & Menu Designer"
       hImage:BUFFER-VALUE           = "ry/img/folderclosed.bmp":U
       hSelectedImage:BUFFER-VALUE   = "ry/img/folderopen.bmp":U
       hTag:BUFFER-VALUE             = "root":U
       cRootKey                      = hKey:BUFFER-VALUE.

/* Add Categories label node */
hbuf:BUFFER-CREATE().
ASSIGN hKey:BUFFER-VALUE             = "{&CATEGORY_NODE}":U
       hParentKey:BUFFER-VALUE       = cRootKey
       cCatgLabelKey                 = hKey:BUFFER-VALUE
       hInsert:BUFFER-VALUE          = 4
       hLabel:BUFFER-VALUE           = "Item Categories"
       hImage:BUFFER-VALUE           = "ry/img/folderclosed.bmp":U
       hSelectedImage:BUFFER-VALUE   = "ry/img/folderopen.bmp":U
       hExpanded:BUFFER-VALUE        = YES
       hTag:BUFFER-VALUE             = "CATGLABEL":U
       NO-ERROR.

/* Add Bands label Node */
hbuf:BUFFER-CREATE().
ASSIGN hKey:BUFFER-VALUE             = "{&BAND_NODE}":U
       hParentKey:BUFFER-VALUE       = cRootKey
       cBandLabelKey                 = hKey:BUFFER-VALUE
       hInsert:BUFFER-VALUE          = 4
       hLabel:BUFFER-VALUE           = "Bands"
       hImage:BUFFER-VALUE           = "ry/img/folderclosed.bmp":U
       hSelectedImage:BUFFER-VALUE   = "ry/img/folderopen.bmp":U
       hExpanded:BUFFER-VALUE        = YES
       hTag:BUFFER-VALUE             = "BANDLABEL|":U
       NO-ERROR.

/* Add MenuBar Bands label Node */
hbuf:BUFFER-CREATE().
ASSIGN hKey:BUFFER-VALUE             = "{&MENUBAR_NODE}":U
       hParentKey:BUFFER-VALUE       = cBandLabelKey
       cParentKey                    = hKey:BUFFER-VALUE
       hInsert:BUFFER-VALUE          = 4
       hLabel:BUFFER-VALUE           = "MenuBar Bands"
       hImage:BUFFER-VALUE           = "ry/img/folderclosed.bmp":U
       hSelectedImage:BUFFER-VALUE   = "ry/img/folderopen.bmp":U
       hExpanded:BUFFER-VALUE        = NO
       hTag:BUFFER-VALUE             = "@BANDLABEL|MenuBar":U
       NO-ERROR.

/* Add dummy record for MenuBar bands */
 hbuf:BUFFER-CREATE().
 ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
        hParentKey:BUFFER-VALUE       = cParentKey
        hInsert:BUFFER-VALUE          = 4
        hLabel:BUFFER-VALUE           = "@DummyRecord":U
        hImage:BUFFER-VALUE           = ""
        hSelectedImage:BUFFER-VALUE   = ""
        hTag:BUFFER-VALUE             = "@Dummy":U
        NO-ERROR.

/* Add SubMenu Bands label Node */
hbuf:BUFFER-CREATE().
ASSIGN hKey:BUFFER-VALUE             = "{&SUBMENU_NODE}":U
       hParentKey:BUFFER-VALUE       = cBandLabelKey
       cParentKey                    = hKey:BUFFER-VALUE
       hInsert:BUFFER-VALUE          = 4
       hLabel:BUFFER-VALUE           = "Submenu Bands"
       hImage:BUFFER-VALUE           = "ry/img/folderclosed.bmp":U
       hSelectedImage:BUFFER-VALUE   = "ry/img/folderopen.bmp":U
       hExpanded:BUFFER-VALUE        = NO
       hTag:BUFFER-VALUE             = "@BANDLABEL|SubMenu":U
       NO-ERROR.

/* Add dummy record for SubMenu bands */
 hbuf:BUFFER-CREATE().
 ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
        hParentKey:BUFFER-VALUE       = cParentKey
        hInsert:BUFFER-VALUE          = 4
        hLabel:BUFFER-VALUE           = "@DummyRecord":U
        hImage:BUFFER-VALUE           = ""
        hSelectedImage:BUFFER-VALUE   = ""
        hTag:BUFFER-VALUE             = "@Dummy":U
        NO-ERROR.

/* Add Toolbar Bands label Node */
hbuf:BUFFER-CREATE().
ASSIGN hKey:BUFFER-VALUE             = "{&TOOLBAR_NODE}":U
       hParentKey:BUFFER-VALUE       = cBandLabelKey
       cParentKey                    = hKey:BUFFER-VALUE
       hInsert:BUFFER-VALUE          = 4
       hLabel:BUFFER-VALUE           = "Toolbar Bands"
       hImage:BUFFER-VALUE           = "ry/img/folderclosed.bmp":U
       hSelectedImage:BUFFER-VALUE   = "ry/img/folderopen.bmp":U
       hExpanded:BUFFER-VALUE        = NO
       hTag:BUFFER-VALUE             = "@BANDLABEL|Toolbar":U
       NO-ERROR.

/* Add dummy record for Toolbar bands */
 hbuf:BUFFER-CREATE().
 ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
        hParentKey:BUFFER-VALUE       = cParentKey
        hInsert:BUFFER-VALUE          = 4
        hLabel:BUFFER-VALUE           = "@DummyRecord":U
        hImage:BUFFER-VALUE           = ""
        hSelectedImage:BUFFER-VALUE   = ""
        hTag:BUFFER-VALUE             = "@Dummy":U
        NO-ERROR.


/* Add Menu&Toolbar Bands label Node */
hbuf:BUFFER-CREATE().
ASSIGN hKey:BUFFER-VALUE             = "{&MENUTOOLBAR_NODE}":U
       hParentKey:BUFFER-VALUE       = cBandLabelKey
       cParentKey                    = hKey:BUFFER-VALUE
       hInsert:BUFFER-VALUE          = 4
       hLabel:BUFFER-VALUE           = "Menu & Toolbar Bands"
       hImage:BUFFER-VALUE           = "ry/img/folderclosed.bmp":U
       hSelectedImage:BUFFER-VALUE   = "ry/img/folderopen.bmp":U
       hExpanded:BUFFER-VALUE        = NO
       hTag:BUFFER-VALUE             = "@BANDLABEL|Menu&Toolbar":U
       NO-ERROR.


/* Add dummy record for Menu&Toolbar bands */
 hbuf:BUFFER-CREATE().
 ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
        hParentKey:BUFFER-VALUE       = cParentKey
        hInsert:BUFFER-VALUE          = 4
        hLabel:BUFFER-VALUE           = "@DummyRecord"
        hImage:BUFFER-VALUE           = ""
        hSelectedImage:BUFFER-VALUE   = ""
        hTag:BUFFER-VALUE             = "@Dummy"
        NO-ERROR.

/* Add SmartToolbar label Node */
hbuf:BUFFER-CREATE().
ASSIGN hKey:BUFFER-VALUE             = "{&SMARTTOOLBAR_NODE}":U
       hParentKey:BUFFER-VALUE       = cRootKey
       cTbarLabelKey                 = hKey:BUFFER-VALUE
       hInsert:BUFFER-VALUE          = 4
       hLabel:BUFFER-VALUE           = coObjType:SCREEN-VALUE IN FRAME {&FRAME-NAME}
       hImage:BUFFER-VALUE           = "ry/img/folderclosed.bmp":U
       hSelectedImage:BUFFER-VALUE   = "ry/img/folderopen.bmp":U
       hExpanded:BUFFER-VALUE        = YES
       hTag:BUFFER-VALUE             = "@TBARLABEL":U
       NO-ERROR.

/* Add dummy record for SmartToolbar */
hbuf:BUFFER-CREATE().
ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
       hParentKey:BUFFER-VALUE       = cTbarLabelKey
       hInsert:BUFFER-VALUE          = 4
       hLabel:BUFFER-VALUE           = "@DummyRecord":U
       hImage:BUFFER-VALUE           = ""
       hSelectedImage:BUFFER-VALUE   = ""
       hTag:BUFFER-VALUE             = "@Dummy":U
       NO-ERROR.


/* Add all of the category nodes (loop through gsc_item_category) */
lCatgAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_gscicfullo,"CURRENT":U).
DO WHILE lCatgAvailable:
    cCols = DYNAMIC-FUNC("colValues":U IN h_gscicfullo,"item_category_label,item_category_obj,item_category_description":U).

    hbuf:BUFFER-CREATE().
    ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
           hParentKey:BUFFER-VALUE       = cCatgLabelKey
           cCatgKey                      = hKey:BUFFER-VALUE
           hInsert:BUFFER-VALUE          = 4
           hLabel:BUFFER-VALUE           = ENTRY(2,cCols,CHR(1)) + (IF trim(ENTRY(2,cCols,CHR(1))) = trim(ENTRY(4,cCols,CHR(1))) 
                                                                            OR trim(ENTRY(4,cCols,CHR(1))) = ""
                                                                    THEN ""
                                                                    ELSE "  (" + ENTRY(4,cCols,CHR(1)) + ")")
           hImage:BUFFER-VALUE           = "ry/img/menucategory.bmp":U
           hSelectedImage:BUFFER-VALUE   = "ry/img/menucategory.bmp":U
           hSort:BUFFER-VALUE            = TRUE
           hTag:BUFFER-VALUE             = "@CATG|":U + ENTRY(3,cCols,CHR(1))
           NO-ERROR.

    /* Determine whether any items exist per category. If yes, add dummy node*/
    IF gcModuleObj > '0':U  THEN
      DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmmifullo,'product_module_obj':U,gcModuleObj,'EQ':U).
    DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmmifullo,'item_category_obj':U,ENTRY(3,cCols,CHR(1)),'EQ':U).
    {fn OpenQuery h_gsmmifullo}.
    DYNAMIC-FUNC('removeQuerySelection':U IN h_gsmmifullo,'item_category_obj':U,'EQ':U).
    DYNAMIC-FUNC('removeQuerySelection':U IN h_gsmmifullo,'product_module_obj':U,'EQ':U).

    lItemAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_gsmmifullo,"CURRENT":U).
    IF lItemAvailable  THEN
    DO:
      hbuf:BUFFER-CREATE().
      ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
             hParentKey:BUFFER-VALUE       = cCatgKey
             hInsert:BUFFER-VALUE          = 4
             hLabel:BUFFER-VALUE           = "@DummyRecord":U
             hImage:BUFFER-VALUE           = "ry/img/folderclosed.bmp":U
             hSelectedImage:BUFFER-VALUE   = "ry/img/folderopen.bmp":U
             hTag:BUFFER-VALUE             = "@Dummy":U
             NO-ERROR.
    END.

    lCatgAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_gscicfullo,"NEXT":U).
    IF lCatgAvailable THEN
      RUN fetchNext IN h_gscicfullo.

END. /* End loop through gsc_item_category */


/* Add (None) Categories for all items not having a category*/
hbuf:BUFFER-CREATE().
ASSIGN hKey:BUFFER-VALUE             = "x1Catg1":U
       hParentKey:BUFFER-VALUE       = cCatgLabelKey
       cCatgKey                      = hKey:BUFFER-VALUE
       hInsert:BUFFER-VALUE          = 4
       hLabel:BUFFER-VALUE           = "(None)"
       hImage:BUFFER-VALUE           = "ry/img/menucategory.bmp":U
       hSelectedImage:BUFFER-VALUE   = "ry/img/menucategory.bmp":U
       hSort:BUFFER-VALUE            = TRUE
       hTag:BUFFER-VALUE             = "@CATG|0":U
       NO-ERROR.

/* Determine whether there are any items not having an item assigned */
IF gcModuleObj > '0':U  THEN
  DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmmifullo,'product_module_obj':U,gcModuleObj,'EQ':U).
DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmmifullo,'item_category_obj':U,'0':U,'EQ':U).
{fn OpenQuery h_gsmmifullo}.
DYNAMIC-FUNC('removeQuerySelection':U IN h_gsmmifullo,'item_category_obj':U,'EQ':U).

lItemAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_gsmmifullo,"CURRENT":U).
IF lItemAvailable THEN DO:
   hbuf:BUFFER-CREATE().
   ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
          hParentKey:BUFFER-VALUE       = cCatgKey
          hInsert:BUFFER-VALUE          = 4
          hLabel:BUFFER-VALUE           = "@DummyRecord":U
          hImage:BUFFER-VALUE           = ""
          hSelectedImage:BUFFER-VALUE   = ""
          hTag:BUFFER-VALUE             = "@Dummy":U
          NO-ERROR.

END.

RUN populateTree IN h_dyntreeview (hTable,"").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE menuAddNode wiWin 
PROCEDURE menuAddNode :
/*------------------------------------------------------------------------------
  Purpose:    Called from menu items to select appropriate node and add the item
  Parameters:  pcNodetype   Node to add.
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcNodeType AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cTag      AS CHARACTER  NO-UNDO.

RUN applyEntry IN h_dyntreeview (?).

CASE pcNodeType:
  WHEN "CATG":U THEN
  DO:
     cTag =  DYNAMIC-FUNCTION("getProperty":U IN h_dyntreeview,"TAG":U,"":U).
     IF NOT ENTRY(1,cTag,"|") BEGINS "CATG":U AND  NOT ENTRY(1,cTag,"|") BEGINS "@CATG":U THEN
       DYNAMIC-FUNCTION("setProperty":U IN h_dyntreeview,"SELECTEDITEM":U,"x1catg":U,"").
     RUN displayAddMode ("CATG":U).
  END.

  WHEN "Band":U THEN
  DO:
     cTag =  DYNAMIC-FUNCTION("getProperty":U IN h_dyntreeview,"TAG":U,"":U).
     IF NOT ENTRY(1,cTag,"|") BEGINS "BAND":U AND  NOT ENTRY(1,cTag,"|") BEGINS "@BAND":U THEN
       DYNAMIC-FUNCTION("setProperty":U IN h_dyntreeview,"SELECTEDITEM":U,"x2band":U,"").
     RUN displayAddMode ("Band":U).
  END.

  WHEN "Item":U THEN
  DO:
     cTag =  DYNAMIC-FUNCTION("getProperty":U IN h_dyntreeview,"TAG":U,"":U).
     IF NOT ENTRY(1,cTag,"|") BEGINS "Item":U AND  NOT ENTRY(1,cTag,"|") BEGINS "@BAND":U THEN
       DYNAMIC-FUNCTION("setProperty":U IN h_dyntreeview,"SELECTEDITEM":U,"x4item":U,"").
     RUN displayAddMode ("Item":U).
  END.




  WHEN "TBarObj":U THEN
  DO:
     cTag =  DYNAMIC-FUNCTION("getProperty":U IN h_dyntreeview,"TAG":U,"":U).
     IF NOT ENTRY(1,cTag,"|") BEGINS "TBAROBJ":U AND  NOT ENTRY(1,cTag,"|") BEGINS "@TBAROBJ":U THEN
       DYNAMIC-FUNCTION("setProperty":U IN h_dyntreeview,"SELECTEDITEM":U,"x3tbarobj":U,"").
     RUN displayAddMode ("TBAROBJ":U).
  END.


END CASE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MoveNode wiWin 
PROCEDURE MoveNode :
/*------------------------------------------------------------------------------
  Purpose:     Moves the band item node up or down
  Parameters:  pcWhichWay    Up    Current node is being moved up
                             Down  Current node is being moved down
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcWhichWay AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cCurrentKey     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentTag     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentText    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMovedkey       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMovedTag       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentSeq     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMovedSeq       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCols           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lOK             AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cParentKey      AS CHARACTER  NO-UNDO.

/* BUFFER FIELD handles */
DEFINE VARIABLE hTable          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hBuf            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hLabel          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hKey            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hParentKey      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTag            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hImage          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSelectedImage  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hExpanded       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSort           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hInsert         AS HANDLE     NO-UNDO.
DEFINE VARIABLE iChildren       AS INTEGER    NO-UNDO.


{get TreeDataTable hTable h_dyntreeview}.
 IF NOT VALID-HANDLE(hTable) THEN DO:
     MESSAGE "Invalid Handle found for TreeData temp-table"
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
     RETURN.
 END.

ASSIGN hBuf            = hTable:DEFAULT-BUFFER-HANDLE
       hKey            = hBuf:BUFFER-FIELD('node_key':U)
       hlabel          = hBuf:BUFFER-FIELD('node_label':U)
       hParentKey      = hBuf:BUFFER-FIELD('parent_node_key':U)
       hTag            = hBuf:BUFFER-FIELD('private_data':U)
       hImage          = hBuf:BUFFER-FIELD('image':U)
       hSelectedImage  = hBuf:BUFFER-FIELD('selected_image':U)
       hExpanded       = hBuf:BUFFER-FIELD('node_expanded':U)
       hSort           = hBuf:BUFFER-FIELD('node_sort':U)
       hInsert         = hBuf:BUFFER-FIELD('node_insert':U).

ASSIGN cCurrentKey  = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"KEY":U,"")
       cCurrentTag  = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"TAG":U,"")
       cCurrentText = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"TEXT":U,"")
       cCurrentSeq  = ENTRY(4,cCurrentTag,"|")
       cMovedKey    = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview, IF pcWhichWay = "Up":U THEN "PREVIOUS":U ELSE "NEXT":U,"")
       iChildren    = int(DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"CHILDREN":U,""))
       NO-ERROR.

/* IF node being moved is already at top or bottom, do nothing */
IF cMovedKey = "" OR cMovedKey = ? THEN
  RETURN.

ASSIGN cMovedTag  = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"TAG":U,cMovedKey)
       cMovedSeq  = ENTRY(4,cMovedTag,"|").

  /* Make changes to SDO's */
cCols = DYNAMIC-FUNCTION("ColValues":U IN h_gsmitfullo,"").
lok = DYNAMIC-FUNCTION("SubmitRow":U IN h_gsmitfullo,
                       ENTRY(1,cCols),
                       "Menu_item_sequence":U + CHR(1) + cMovedSeq ).
IF NOT lOK THEN
     RETURN.

RUN deleteNode IN h_dyntreeview(cCurrentKey).

hBuf:EMPTY-TEMP-TABLE().
hBuf:BUFFER-CREATE().
ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
       hParentKey:BUFFER-VALUE       = cMovedKey
       hInsert:BUFFER-VALUE          = IF pcWhichWay = "UP":U
                                       THEN 3  /* Insert previous */
                                       ELSE 2  /* Insert next */
       hLabel:BUFFER-VALUE           = cCurrentText
       hImage:BUFFER-VALUE           = getItemImage(ENTRY(5,cCurrentTag,"|"))
       hSelectedImage:BUFFER-VALUE   = hImage:BUFFER-VALUE
       hSort:BUFFER-VALUE            = TRUE
       hTag:BUFFER-VALUE             = cCurrentTag
       cCurrentKey                   = hKey:BUFFER-VALUE
       NO-ERROR.

IF iChildren > 0 AND NOT cCurrentTag BEGINS "@":U THEN
  ASSIGN cCurrentTag       = "@":U + cCurrentTag
         hTag:BUFFER-VALUE = cCurrentTag.

RUN addNode IN h_dyntreeview (hbuf).
DYNAMIC-FUNCTION("setProperty":U IN h_dyntreeview,"SELECTEDITEM":U,cCurrentKey,"").


/* Reaasign sequences in tag */
ASSIGN ENTRY(4,cCurrentTag,"|") = cMovedSeq
       ENTRY(4,cMovedTag,"|")   = cCurrentSeq.

DYNAMIC-FUNC('setProperty':U IN h_dyntreeview,"TAG":U,cCurrentKey,cCurrentTag).
DYNAMIC-FUNC('setProperty':U IN h_dyntreeview,"TAG":U,cMovedKey,  cMovedTag).

/* if there were children for this add, add the dummy node
  IF it's expanded the node will become collapsed */
IF iChildren > 0 THEN
DO:
  hBuf:EMPTY-TEMP-TABLE().
  hbuf:BUFFER-CREATE().
      ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
             hParentKey:BUFFER-VALUE       = cCurrentKey
             hInsert:BUFFER-VALUE          = 4
             hLabel:BUFFER-VALUE           = "@DummyRecord":U
             hImage:BUFFER-VALUE           = ""
             hSelectedImage:BUFFER-VALUE   = ""
             hTag:BUFFER-VALUE             = "@Dummy":U
             NO-ERROR.
  RUN addNode IN h_dyntreeview (hbuf).
END.
cParentkey =  DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"PARENT":U,cMovedKey).
RUN refreshBand (cParentKey,ENTRY(3,cCurrentTag,"|")).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE postCreateObjects wiWin 
PROCEDURE postCreateObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hAttributeBuffer  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hClassBuffer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCurrentPage      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE pcInheritClasses  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lPopupEnabled     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cTabVisualization AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTabPosition      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDesignManager    AS HANDLE     NO-UNDO.
  
  ASSIGN hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U) NO-ERROR.

  /* Fetch the repository class*/
  IF gdDifference = 0 THEN
  DO:
     RUN retrieveDesignClass IN hDesignManager
                                 ( INPUT  "SmartFolder":U,
                                   OUTPUT pcInheritClasses,
                                   OUTPUT TABLE ttClassAttribute,
                                   OUTPUT TABLE ttUiEvent,
                                   output table ttSupportedLink         ) NO-ERROR.
     FIND ttClassAttribute WHERE ttClassAttribute.tClassname      = "SmartFolder":U 
                             AND ttClassAttribute.tAttributeLabel = "PopupSelectionEnabled":U NO-ERROR.
     IF AVAIL ttClassAttribute THEN
        lPopupEnabled = LOGICAL(ttClassAttribute.tAttributeValue).
     
     FIND ttClassAttribute WHERE ttClassAttribute.tClassname      = "SmartFolder":U 
                             AND ttClassAttribute.tAttributeLabel = "TabVisualization":U NO-ERROR.
     IF AVAIL ttClassAttribute THEN
        cTabVisualization = ttClassAttribute.tAttributeValue.

     FIND ttClassAttribute WHERE ttClassAttribute.tClassname      = "SmartFolder":U 
                             AND ttClassAttribute.tAttributeLabel = "TabPosition":U NO-ERROR.
     IF AVAIL ttClassAttribute THEN
        cTabPosition = ttClassAttribute.tAttributeValue.

     ASSIGN gdDifference  = {fn getInnerRow h_folder}.
     
     {fnarg setPopupSelectionEnabled lPopupEnabled      h_folder}.
     {fnarg setTabVisualization      cTabVisualization  h_folder}.
     {fnarg setTabPosition           cTabPosition       h_folder}.

     IF {fn getTabPosition h_folder} = "Lower":U THEN
     DO:
       RUN initializeObject IN h_folder.
      
       gdDifference = gdDifference - {fn getInnerRow h_folder} + 0.58.
     END.
  END.
  
  /* Reposition the objects because of the tab being at the bottom. Do this once only as they are moved by the difference of their current
     position and the tab's row height. */
  IF {fn getTabPosition h_folder} = "Lower":U THEN
  DO:
    iCurrentPage = {fn getCurrentPage}.
    
    IF NOT glPageInitialized[iCurrentPage + 1] THEN
    DO:
      CASE iCurrentPage:
        WHEN 0  THEN RUN repositionObject IN h_pupdsav    ({fn getRow h_pupdsav}    - gdDifference, {fn getCol h_pupdsav})    NO-ERROR.
        WHEN 5  THEN RUN repositionObject IN h_gscicview  ({fn getRow h_gscicview}  - gdDifference, {fn getCol h_gscicview})  NO-ERROR.
        WHEN 6  THEN RUN repositionObject IN h_gsmmsview  ({fn getRow h_gsmmsview}  - gdDifference, {fn getCol h_gsmmsview})  NO-ERROR.
        WHEN 7  THEN RUN repositionObject IN h_gsmmiview  ({fn getRow h_gsmmiview}  - gdDifference, {fn getCol h_gsmmiview})  NO-ERROR.
        WHEN 8  THEN RUN repositionObject IN h_gsmitview  ({fn getRow h_gsmitview}  - gdDifference, {fn getCol h_gsmitview})  NO-ERROR.
        WHEN 9  THEN RUN repositionObject IN h_gscobviewt ({fn getRow h_gscobviewt} - gdDifference, {fn getCol h_gscobviewt}) NO-ERROR.
        WHEN 10 THEN RUN repositionObject IN h_gsmtmview  ({fn getRow h_gsmtmview}  - gdDifference, {fn getCol h_gsmtmview})  NO-ERROR.
      END CASE.
    
      glPageInitialized[iCurrentPage + 1] = TRUE.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE propertyChangedAttribute wiWin 
PROCEDURE propertyChangedAttribute :
/*------------------------------------------------------------------------------
  Purpose:     Published from proeprty sheet when attribute value is changed
  Parameters:  phHandle     Handle of procedure that object belongs to
               pcContainer  
               pcObject     
               pcResultCode 
               pcAttribute  
               pcValue      
               pcDataType   
               plOverride   
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phHandle      AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER pcContainer   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcObject      AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcResultCode  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcAttribute   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcValue       AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcDataType    AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plOverride    AS LOGICAL    NO-UNDO.

DEFINE VARIABLE cObjectFilename AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iPos            AS INTEGER    NO-UNDO.
DEFINE VARIABLE dObjectID       AS DECIMAL    NO-UNDO.
DEFINE VARIABLE hBufferHandle   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTableHandle    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hUnknown        AS HANDLE     NO-UNDO.

/* MESSAGE "Handle:" phHandle THIS-PROCEDURE SKIP */
/*         "Container:" pcContainer SKIP          */
/*         "object:" pcObject SKIP                */
/*         "attribute:" pcAttribute SKIP          */
/*         "Value:" pcvalue      SKIP             */
/*         "dataType:"  pcDataType skip           */
/*         "override:" plOverride                 */
/*    VIEW-AS ALERT-BOX INFO BUTTONS OK.          */

IF phHandle <> THIS-PROCEDURE THEN
  RETURN.

ASSIGN ipos      = LOOKUP(pcObject,gcRegisteredToolbars,CHR(3))
       dObjectID = IF iPos > 0 THEN DECIMAL(ENTRY(iPos + 1, gcRegisteredToolbars,CHR(3)) ) ELSE 0
       NO-ERROR.

IF dObjectID > 0 THEN
DO:
  EMPTY TEMP-TABLE ttStoreAttribute NO-ERROR.

  CREATE ttStoreAttribute.
  ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
         ttStoreAttribute.tAttributeParentObj = dObjectID
         ttStoreAttribute.tAttributeLabel     = pcAttribute
         ttStoreAttribute.tConstantValue      = NO.
END.

IF dObjectID > 0 AND plOverride THEN
DO:
  IF pcDataType BEGINS "CHAR":U THEN
     ASSIGN ttStoreAttribute.tCharacterValue = pcValue NO-ERROR.
  ELSE IF pcDataType BEGINS "LOG":U THEN 
     ASSIGN ttStoreAttribute.tLogicalValue = IF pcValue = "Yes":U OR pcValue = "True":U THEN TRUE ELSE FALSE NO-ERROR.
  ELSE IF pcDataType BEGINS "INT":U THEN 
     ASSIGN ttStoreAttribute.tIntegerValue = INT(pcValue) NO-ERROR.
  ELSE IF pcDataType BEGINS "DEC":U THEN 
     ASSIGN ttStoreAttribute.tDecimalValue = DEC(pcValue) NO-ERROR.
  ELSE IF pcDataType BEGINS "DATE":U THEN 
     ASSIGN ttStoreAttribute.tDateValue    = DATE(pcValue) NO-ERROR.
  ELSE
    ASSIGN ttStoreAttribute.tCharacterValue = pcValue NO-ERROR.
 
  ASSIGN hBufferHandle = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE.  
  
  RUN StoreAttributeValues IN gshRepositoryManager
            (INPUT  hBufferHandle,
             INPUT TABLE-HANDLE hUnknown).  /* Compiler requires a variable with unknown */
 END.
 ELSE IF dObjectID > 0 AND NOT plOverride THEN 
 DO:  /* IF Override is turned off, remove attribute */
    IF NOT VALID-HANDLE(ghRepositoryDesignManager) THEN
       ASSIGN ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE,
                                                          INPUT "RepositoryDesignManager":U).
    ASSIGN hBufferHandle = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE.  
    RUN removeAttributeValues IN ghRepositoryDesignManager
             (INPUT hBufferHandle, INPUT TABLE-HANDLE hTableHandle).
 END.

ASSIGN cObjectFilename = {fnarg columnStringValue 'object_filename':U h_rycsoful2o}
       cObjectFilename = (IF cObjectFilename = ? THEN "":U ELSE cObjectFilename).

/* IZ 6618. When saving, force tools to refresh its instances of the saved smartobject */
PUBLISH "MasterObjectModified":U FROM gshRepositoryManager (INPUT dObjectID, cObjectFilename).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshBand wiWin 
PROCEDURE refreshBand :
/*------------------------------------------------------------------------------
  Purpose:     Searches all band nodes and refreshes specified band
  Parameters:  pcKey    Parent key of modified band
  Notes:      pcBandObj Menu_structure_obj of band
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcKey     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcBandObj AS CHARACTER NO-UNDO.

DEFINE VARIABLE hTable     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hBuf       AS HANDLE     NO-UNDO.
DEFINE VARIABLE cKey       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNewKey    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNextKey   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDeleteKey AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cChildkey  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cParentKey AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTag       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cText      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iChildren  AS INTEGER    NO-UNDO.
DEFINE VARIABLE lExpanded  AS LOGICAL    NO-UNDO.
   /* BUFFER FIELD handles */
DEFINE VARIABLE hLabel          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hKey            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hParentKey      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTag            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hImage          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSelectedImage  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hExpanded       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSort           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hInsert         AS HANDLE     NO-UNDO.

ASSIGN cParentKey = "{&BAND_NODE}":U
       cKey = DYNAMIC-FUNC("getProperty":U IN h_dyntreeview,"CHILD":U,cParentKey).
Node-Loop:
DO WHILE ckey <> ? AND cKey <> "":
  iChildren = INT(DYNAMIC-FUNC("getProperty":U IN h_dyntreeview,"CHILDREN":U,cKey)) NO-ERROR.
  cTag =  DYNAMIC-FUNC("getProperty":U IN h_dyntreeview,"TAG":U,cKey).
  cText =  DYNAMIC-FUNC("getProperty":U IN h_dyntreeview,"Text":U,cKey).

  IF cKey = pcKey THEN DO:
     cKey = DYNAMIC-FUNC("getProperty":U IN h_dyntreeview,"NEXT":U,cKey).
     NEXT Node-Loop.
  END.
  IF (ENTRY(1,cTag,"|") = "BAND":U AND ENTRY(2,cTag,"|") = pcBandObj)
     OR (ENTRY(1,cTag,"|") = "BANDITEM":U AND ENTRY(6,cTag,"|") = pcBandObj)
      OR (ENTRY(1,cTag,"|") = "TBARBAND":U AND ENTRY(3,cTag,"|") = pcBandObj)
  THEN DO:
    {get TreeDataTable hTable h_dyntreeview}.
     ASSIGN hBuf            = hTable:DEFAULT-BUFFER-HANDLE
            hKey            = hBuf:BUFFER-FIELD('node_key':U)
            hlabel          = hBuf:BUFFER-FIELD('node_label':U)
            hParentKey      = hBuf:BUFFER-FIELD('parent_node_key':U)
            hTag            = hBuf:BUFFER-FIELD('private_data':U)
            hImage          = hBuf:BUFFER-FIELD('image':U)
            hSelectedImage  = hBuf:BUFFER-FIELD('selected_image':U)
            hExpanded       = hBuf:BUFFER-FIELD('node_expanded':U)
            hSort           = hBuf:BUFFER-FIELD('node_sort':U)
            hInsert         = hBuf:BUFFER-FIELD('node_insert':U).
    /* Clear the data from the temp table */
    hBuf:EMPTY-TEMP-TABLE().
    lExpanded =  ("Yes":U = DYNAMIC-FUNC("getProperty":U IN h_dyntreeview,"EXPANDED":U,cKey)).
    /* Delete all children nodes */
    cDeleteKey =  DYNAMIC-FUNC("getProperty":U IN h_dyntreeview,"CHILD":U,cKey).
    DO WHILE cDeleteKey <> ?:
        cNextKey = DYNAMIC-FUNC("getProperty":U IN h_dyntreeview,"NEXT":U,cDeleteKey).
        RUN deleteNode IN h_dyntreeview(cDeleteKey).
        cDeleteKey = cNextKey.
    END.
    hbuf:BUFFER-CREATE().
    /* Add dummy node*/
    hbuf:BUFFER-CREATE().
    ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
           hParentKey:BUFFER-VALUE       = cKey
           hInsert:BUFFER-VALUE          = 4
           hLabel:BUFFER-VALUE           = "@DummyRecord":U
           hImage:BUFFER-VALUE           = ""
           hSelectedImage:BUFFER-VALUE   = ""
           hTag:BUFFER-VALUE             = "@Dummy":U
           NO-ERROR.
    RUN addNode IN h_dyntreeview (hBuf).

    DYNAMIC-FUNC("setProperty":U IN h_dyntreeview,"TAG":U,cKey,"@" + cTag).
    IF lExpanded THEN
      RUN treeExpand (cKey, "@" + cTag).
  END. /* END Delete band node and re-insert */

  IF cTag BEGINS "@":U THEN
    cKey = DYNAMIC-FUNC("getProperty":U IN h_dyntreeview,"NEXT":U,cKey).
  ELSE IF iChildren > 0 THEN
  DO:
    cParentKey = cKey.
    cKey = DYNAMIC-FUNC("getProperty":U IN h_dyntreeview,"CHILD":U,cKey).
  END.
  ELSE
    cKey = DYNAMIC-FUNC("getProperty":U IN h_dyntreeview,"NEXT":U,cKey).

  IF (ckey = "" OR cKey = ?)  AND cParentKey <> "" AND cParentKey <> ? THEN
  DO:
     cKey       = DYNAMIC-FUNC("getProperty":U IN h_dyntreeview,"NEXT":U,cParentKey).
     IF cKey = "" OR cKey = ? THEN
     DO WHILE TRUE:
       cParentKey = DYNAMIC-FUNC("getProperty":U IN h_dyntreeview,"PARENT":U,cParentKey).
       cKey       = DYNAMIC-FUNC("getProperty":U IN h_dyntreeview,"NEXT":U,cParentKey).
       IF (cKey <> ? AND ckey <> "") OR cparentKey = "{&ROOT_NODE}":U THEN
         LEAVE.
     END.
     ELSE
       cParentkey = DYNAMIC-FUNC("getProperty":U IN h_dyntreeview,"PARENT":U,cKey).
  END.
  IF cParentkey = "{&ROOT_NODE}":U THEN
    LEAVE.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshTree wiWin 
PROCEDURE refreshTree :
/*------------------------------------------------------------------------------
  Purpose:     Rebuilds the tree
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTable    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lCancel   AS LOGICAL    NO-UNDO.


  IF VALID-HANDLE(ghTableIOTarget) THEN
  DO:
    RUN confirmContinue IN ghTableIOTarget (INPUT-OUTPUT lCancel).
    IF lCancel THEN
       RUN cancelRecord IN ghTableIOTarget.
  END.
  DYNAMIC-FUNC('setQueryWhere':U IN h_gscicfullo, '').
  DYNAMIC-FUNC('setQueryWhere':U IN h_gsmmifullo, '').
  DYNAMIC-FUNC('setQueryWhere':U IN h_gsmmsfullo, '').
  DYNAMIC-FUNC('setQueryWhere':U IN h_gsmitfullo, '').
  DYNAMIC-FUNC('setQueryWhere':U IN h_rycsoful2o, '').
  DYNAMIC-FUNC('setQueryWhere':U IN h_gsmtmfullo, '').
  DYNAMIC-FUNC('setQueryWhere':U IN h_gsmomfullo, '').


  IF VALID-HANDLE(h_gscicview) THEN RUN removeLink (h_gscicfullo, 'Data':U, h_gscicview).
  IF VALID-HANDLE(h_gsmmiview) THEN RUN removeLink (h_gsmmifullo, 'Data':U, h_gsmmiview).
  IF VALID-HANDLE(h_gsmmsview) THEN RUN removeLink (h_gsmmsfullo, 'Data':U, h_gsmmsview).
  IF VALID-HANDLE(h_gsmitview) THEN RUN removeLink (h_gsmitfullo, 'Data':U, h_gsmitview).
  IF VALID-HANDLE(h_gscobviewt)THEN RUN removeLink (h_rycsoful2o, 'Data':U, h_gscobviewt).
  IF VALID-HANDLE( h_gsmtmview)THEN RUN removeLink (h_gsmtmfullo, 'Data':U, h_gsmtmview).

 {fn OpenQuery h_gscicfullo}.

  RUN LoadTreeData.


  RUN treeclick ("","").
  IF VALID-HANDLE(h_gscicview) THEN RUN addLink (h_gscicfullo, 'Data':U, h_gscicview).
  IF VALID-HANDLE(h_gsmmiview) THEN RUN addLink (h_gsmmifullo, 'Data':U, h_gsmmiview).
  IF VALID-HANDLE(h_gsmmsview) THEN RUN addLink (h_gsmmsfullo, 'Data':U, h_gsmmsview).
  IF VALID-HANDLE(h_gsmitview) THEN RUN addLink (h_gsmitfullo, 'Data':U, h_gsmitview).
  IF VALID-HANDLE(h_gscobviewt)THEN RUN addLink (h_rycsoful2o, 'Data':U, h_gscobviewt).
  IF VALID-HANDLE(h_gsmtmview) THEN RUN addLink (h_gsmtmfullo, 'Data':U, h_gsmtmview).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionSplitBar wiWin 
PROCEDURE repositionSplitBar :
/*------------------------------------------------------------------------------
  Purpose:    Called when the splitbar button is moved (END-MOVE) or when the window
              is resized. It resizes the treeview equal to the position of the splitbar
              and also resizes the height.  It resizes the smartfolder, smartViewers and
              SmartPanel
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEFINE VARIABLE dMinWidth  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dMinHeight AS DECIMAL    NO-UNDO.
DEFINE VARIABLE hFolder    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hPanel     AS HANDLE     NO-UNDO.
DEFINE VARIABLE iPage      AS INTEGER    NO-UNDO.

&SCOPED-DEFINE PANEL_WIDTH 58

{fnarg lockWindow TRUE}.

{get MinWidth  dMinWidth h_dyntreeview} .

ASSIGN btnSplitBar:COL IN FRAME {&FRAME-NAME} = MAX(btnSplitBar:COL  ,dMinWidth)
       btnSplitBar:COL    = MIN(btnSplitBar:COL, {&WINDOW-NAME}:WIDTH * 4 / 5)
       btnSplitBar:ROW    = 1
       btnSplitBar:HEIGHT = FRAME {&FRAME-NAME}:HEIGHT
       coModule:WIDTH     = MAX(1,btnSplitBar:COL - coModule:COL + .3)
       coObjType:WIDTH    = coModule:WIDTH
       NO-ERROR.
RUN resizeObject IN h_dyntreeview (INPUT {&WINDOW-NAME}:HEIGHT - FRAME {&FRAME-NAME}:ROW - 1.25,
                                    INPUT btnSplitBar:COL).

/* Check whether the folder width needs to be increased or decreased */
{get ContainerHandle hFolder h_folder}.
{get ContainerHandle hpanel h_pupdsav}.

IF hFolder:column <= btnSplitBar:COL + btnSplitBar:WIDTH THEN  /* SplitBar is being moved to the right */
DO:
     RUN resizeObject IN h_folder (INPUT {&WINDOW-NAME}:HEIGHT - FRAME {&FRAME-NAME}:ROW + .9,
                                       INPUT {&WINDOW-NAME}:WIDTH - btnSplitBar:COL - btnSplitBar:WIDTH ).
     RUN repositionObject IN h_folder (INPUT 1.00, btnSplitBar:COL + btnSplitBar:WIDTH).

     RUN resizeObject  IN  h_pupdsav (hPanel:HEIGHT,
                                      IF {&WINDOW-NAME}:WIDTH - btnSplitBar:COL - 1 < {&PANEL_WIDTH}
                                      THEN {&WINDOW-NAME}:WIDTH - btnSplitBar:COL - 2
                                      ELSE {&PANEL_WIDTH}).

     RUN repositionObject IN h_pupdsav (hPanel:ROW,
                                        btnSplitBar:COL + 1 + ({&WINDOW-NAME}:WIDTH - btnSplitBar:COL - hPanel:WIDTH - 1) / 2 ).

     IF VALID-HANDLE(h_gscicview) THEN
       RUN centerObject(INPUT h_gscicview, INPUT 1).
     IF VALID-HANDLE(h_gsmmsview) THEN
       RUN centerObject(INPUT h_gsmmsview, INPUT 1).
     IF VALID-HANDLE(h_gsmmiview) THEN
       RUN centerObject(INPUT h_gsmmiview, INPUT 1).
     IF VALID-HANDLE(h_gsmitview) THEN
       RUN centerObject(INPUT h_gsmitview, INPUT 1).
     IF VALID-HANDLE(h_gscobviewt) THEN
       RUN centerObject(INPUT h_gscobviewt, INPUT 1).
     IF VALID-HANDLE(h_gsmomviewt) THEN
       RUN centerObject(INPUT h_gsmomviewt, INPUT 1).
      IF VALID-HANDLE(h_gsmtmview) THEN
       RUN centerObject(INPUT h_gsmtmview, INPUT 1).

    IF VALID-HANDLE(h_gsmombrow) THEN DO:
       RUN resizeObject IN h_gsmombrow(6.91,{&WINDOW-NAME}:WIDTH - btnSplitBar:COL - 7).
       RUN repositionObject IN h_gsmombrow(2.67, btnSplitBar:COL + 4).
    END.

END. /* End splitbar being moved to right */
ELSE DO: /* Splitbar being moved to left */
   RUN repositionObject IN h_folder (INPUT 1.00, btnSplitBar:COL + btnSplitBar:WIDTH  ).
   RUN resizeObject IN h_folder (INPUT {&WINDOW-NAME}:HEIGHT - FRAME {&FRAME-NAME}:ROW + .9,
                                       INPUT {&WINDOW-NAME}:WIDTH - btnSplitBar:COL - btnSplitBar:WIDTH ).
   RUN repositionObject IN h_pupdsav (hPanel:ROW,
                                      IF {&WINDOW-NAME}:WIDTH - btnSplitBar:COL - 1  > {&PANEL_WIDTH}
                                      THEN  btnSplitBar:COL + 1 + ({&WINDOW-NAME}:WIDTH - btnSplitBar:COL - {&PANEL_WIDTH} - 1) / 2
                                      ELSE  btnSplitBar:COL + 2).
   RUN resizeObject  IN  h_pupdsav (hPanel:HEIGHT,
                                   IF {&WINDOW-NAME}:WIDTH - btnSplitBar:COL - 1 < {&PANEL_WIDTH}
                                   THEN {&WINDOW-NAME}:WIDTH - btnSplitBar:COL - 3
                                   ELSE {&PANEL_WIDTH}).
   IF VALID-HANDLE(h_gscicview) THEN
      RUN centerObject(INPUT h_gscicview, INPUT 2).

   IF VALID-HANDLE(h_gsmmsview) THEN
       RUN centerObject(INPUT h_gsmmsview, INPUT 2).
   IF VALID-HANDLE(h_gsmmiview) THEN
       RUN centerObject(INPUT h_gsmmiview, INPUT 2).
   IF VALID-HANDLE(h_gsmitview) THEN
       RUN centerObject(INPUT h_gsmitview, INPUT 2).
   IF VALID-HANDLE(h_gscobviewt) THEN
       RUN centerObject(INPUT h_gscobviewt, INPUT 2).
    IF VALID-HANDLE(h_gsmomviewt) THEN
       RUN centerObject(INPUT h_gsmomviewt, INPUT 2).
    IF VALID-HANDLE(h_gsmombrow) THEN DO:
       RUN repositionObject IN h_gsmombrow(2.67, btnSplitBar:COL + 4).
       RUN resizeObject IN h_gsmombrow(6.91,{&WINDOW-NAME}:WIDTH - btnSplitBar:COL - 7).
    END.
    IF VALID-HANDLE(h_gsmtmview) THEN
       RUN centerObject(INPUT h_gsmtmview, INPUT 2).

END.  /* End splitbar being moved to left */

 /* the calls to the folder is untabbing the tab folders. Reset tabs */
{get CurrentPage iPage}.
IF iPage > 2 THEN DO:
    {set CurrentPage 1}.
END.

RUN ShowCurrentPage IN h_folder (IF giLastTabPage = 2 THEN 2 ELSE 1). /* Select the first tab folder */
{set CurrentPage iPage}.

{fnarg lockWindow FALSE}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectPage wiWin 
PROCEDURE selectPage :
/*------------------------------------------------------------------------------
  Purpose:     Override standard behavior. Based on the current selected node,
               display the appropriate viewer.
  Parameters:  piPageNum   Page number to display

  Notes:       Variable giNodePage contains the page of the corresponding viewer.
               This is set in the Treeclick proc based on the selected node.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER piPageNum AS INTEGER NO-UNDO.

  DEFINE VARIABLE iPage       AS INTEGER  NO-UNDO.
  DEFINE VARIABLE cObjects    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObject     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hObject     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE i           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTabFolder  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lCancel     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cTag        AS CHARACTER  NO-UNDO.

  IF piPageNum = giPageTab THEN
    RETURN.

    /* Confirm if user is in middle of update */
  cTag       = DYNAMIC-FUNC("getProperty":U IN h_dyntreeview,"TAG":U,"").
  IF VALID-HANDLE(ghTableIOTarget) THEN
  DO:  /* Do not confirm for Item (add to band) */
    IF giNodePage = 8 AND (piPageNum = 1 OR piPageNum = 2) AND
        (ENTRY(1,ctag,"|") = "BAND":U OR ENTRY(1,ctag,"|") = "@BAND":U)  THEN
      .
    ELSE
    DO:
      glExcludeCancel = YES.
      RUN confirmContinue IN ghTableIOTarget (INPUT-OUTPUT lCancel).
      IF lCancel THEN
          RUN cancelRecord IN ghTableIOTarget.
      glExcludeCancel = NO.
    END.
  END.
   /* If tabbing between page 1 and 2 when adding an item to a band, and
      the node selected is a band node, allow the user to change pages
      while remaining in add mode. This requires both viewers to do a
      cancelRecord prior to changing pages. */
  IF giNodePage = 8 AND (ENTRY(1,ctag,"|") = "BAND":U OR ENTRY(1,ctag,"|") = "@BAND":U)  THEN
  DO:
    IF piPageNum = 1  THEN
    DO:
        glExcludeCancel = YES.
        IF VALID-HANDLE(h_gsmmiview) THEN DO:
          {set ObjectHidden NO h_gsmmiview}.
           RUN cancelRecord IN h_gsmmiview.
        END.
        glExcludeCancel = NO.
    END.
    ELSE IF piPageNum = 2 THEN
    DO:
        glExcludeCancel = YES.
        IF VALID-HANDLE(h_gsmitview) THEN
        DO:
          {set ObjectHidden NO h_gsmitview}.
           RUN cancelRecord IN h_gsmitview.
        END.
        glExcludeCancel = NO.
        
    END.
  END.

 {get FolderLabels cTabFolder h_folder}.
 IF piPageNum = 2  AND giNodePage = 6 THEN /* IF Band Objects is selected */
 DO:
   iPage = 2.
 END.
 ELSE IF piPageNum = 2 AND giNodePage = 8 THEN /* If 2nd Item tab (besides Band Item) is selected */
 DO:
   iPage = 7.
 END.
 ELSE
    iPage = giNodePage.

 IF piPageNum = 1 AND giNodePage > 2 THEN
   RUN viewObject IN h_pupdsav.

 cObjects = pageNTargets(TARGET-PROCEDURE, iPage).

    /* If Object Type has not yet been determined and the SmartToolbar node is selected, set the objectType
         which is used for the SmartToolbar viewer */
 IF cObjects = "" AND piPageNum = 9 AND gcObjectTypeObj = "" THEN
     setObjectType().

 RUN SUPER( INPUT iPage).

    /* If viewer is being initialized for the first time,
       reposition it, then view it. */
  IF cObjects = "" AND iPage >= 1  THEN
  DO:
    cObject = pageNTargets(TARGET-PROCEDURE, iPage) NO-ERROR.
    IF cObject > "" THEN
      RUN repositionSplitBar.
    DO i = 1 TO NUM-ENTRIES(cObject):
      hObject = WIDGET-HANDLE(ENTRY(i,cObject)) NO-ERROR.
      IF VALID-HANDLE(hObject) THEN DO:
        RUN viewObject IN hObject.
        RUN enableFields IN hObject.
        {set SaveSource YES  hObject}.
      END.
    END.
  END.

  /* If first tab folder "Band' is selected when a Band node is clicked, set tableIO links */
  IF piPageNum = 1 AND  giNodePage = 6 THEN
  DO:
    IF VALID-HANDLE(ghTableIOTarget) THEN
       RUN removeLink ( h_pupdsav , 'TableIO':U , ghTableIOTarget ).
    RUN addLink    ( h_pupdsav , 'TableIO':U , h_gsmmsview ).
    ASSIGN ghTableIOTarget = h_gsmmsview.
    RUN enableFields IN h_gsmmsview.
    {set SaveSource YES  h_gsmmsview}.
  END.
  /* If 2nd Tab folder 'Band Objects' is selected when a Band node is clicked, set the tableIO link */
  ELSE IF piPageNum = 2 AND giNodePage = 6 THEN
  DO:
    IF VALID-HANDLE(ghTableIOTarget) AND ghTableIOTarget <> h_gsmomviewt THEN
    DO:
       RUN removeLink ( h_pupdsav , 'TableIO':U , ghTableIOTarget ).
       RUN addLink    ( h_pupdsav , 'TableIO':U , h_gsmomviewt ).
       ASSIGN ghTableIOTarget = h_gsmomviewt.
    END.
    RUN enableFields IN h_gsmomviewt.
    RUN resetTableIO IN h_pupdsav.
    {set SaveSource YES h_gsmomviewt}.
    {set SaveSource YES h_gsmombrow}.
  END.
  /* IF 1st Tab folder 'Band Item' is selected when a band item node is clicked, reposition query*/
  ELSE IF piPageNum = 1  AND giNodePage = 8  THEN
  DO:
    IF VALID-HANDLE(ghTableIOTarget) THEN
      RUN removeLink ( h_pupdsav , 'TableIO':U , ghTableIOTarget ).
    RUN addLink    ( h_pupdsav , 'TableIO':U , h_gsmitview ).
    ASSIGN ghTableIOTarget = h_gsmitview.
    RUN enableFields IN h_gsmitview.
    {set SaveSource YES h_gsmitview}.
    DYNAMIC-FUNC("enableActions":U IN h_pupdsav,"Delete":U).
    IF ENTRY(1,cTag,"|") = "BAND":U OR  ENTRY(1,cTag,"|") ="@BAND":U THEN
    DO:
      RUN addRecord IN h_gsmitview.
     /* RUN enableFields IN h_gsmitview.*/
    END.
    RUN adjustTabOrder (h_gsmmiview, h_pupdsav, 'BEFORE':U).
    RUN adjustTabOrder (h_dyntreeview, h_gsmmiview, 'BEFORE':U).
  END.
  /* IF 2nd Tab folder 'Item' when a band item node is clicked, reposition query*/
  ELSE IF piPageNum = 2 AND giNodePage = 8  THEN
  DO:
    IF VALID-HANDLE(ghTableIOTarget) AND ghTableIOTarget <> h_gsmmiview THEN
    DO:
      RUN removeLink ( h_pupdsav , 'TableIO':U , ghTableIOTarget ).
      RUN addLink    ( h_pupdsav , 'TableIO':U , h_gsmmiview ).
      ASSIGN ghTableIOTarget = h_gsmmiview.
    END.
    IF ENTRY(1,cTag,"|") = "BANDITEM":U OR  ENTRY(1,cTag,"|") ="@BANDITEM":U THEN
    DO:
      /* In case it's filtered for a specific product module */
      DYNAMIC-FUNC('removeQuerySelection':U IN h_gsmmifullo, 'product_module_obj':U, "EQ":U).
      DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmmifullo, 'menu_item_obj':U,  ENTRY(7,cTag,"|"), "EQ":U).
      {fn OpenQuery h_gsmmifullo} .
      DYNAMIC-FUNC('removeQuerySelection':U IN h_gsmmifullo, 'menu_item_obj':U, "EQ":U).
      RUN enableFields IN h_gsmmiview.
      RUN resetTableIO IN h_pupdsav.
      {set SaveSource YES h_gsmmiview}.
    END.
    ELSE DO:
      RUN addRecord IN h_gsmmiview.
    END.
    /* Make Delete field insensitive */
    DYNAMIC-FUNC("disableActions":U IN h_pupdsav,"Delete":U).
    RUN adjustTabOrder (h_gsmmiview, h_pupdsav, 'BEFORE':U).
    RUN adjustTabOrder (h_dyntreeview, h_gsmmiview, 'BEFORE':U).
  END.


  /* Since the number of tab folders is less than the page number being set,
     this code ensures that the proper tab folder is selected, otherwise the
     tab folder does not appear selected when you click on it. */
IF (piPageNum = 1 OR piPageNum = 0) AND  giLastTabPage <> 1 THEN
  DO:
    {set CurrentPage 1}.
    RUN changeFolderPage IN h_folder. /* Select the first tab folder */
  END.
  ELSE IF piPageNum = 2 AND  giLastTabPage <> 2 THEN
  DO:
    {set CurrentPage 2}.
    RUN changeFolderPage IN h_folder. /* Select the first tab folder */
  END.
  {set CurrentPage iPage}.

  ASSIGN giLastNodePage = iPage
         giLastTabPage  = piPageNum .

  IF piPageNum <= 2 THEN
      giPageTab = piPageNum.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectToolbarNode wiWin 
PROCEDURE selectToolbarNode :
/*------------------------------------------------------------------------------
  Purpose:    This procedure will expand the parents of the specified node
              and select the node. 
  Parameters: pcToolbarNode    Name of Smart Toolbar object
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcToolbarNode AS CHARACTER  NO-UNDO.

 DEFINE VARIABLE cChildKey AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cTag      AS CHARACTER  NO-UNDO.

/* Expand the SmartToolbar node */
 DYNAMIC-FUNCTION("setProperty":U in h_dynTreeview, "Expanded":U,"{&SMARTTOOLBAR_NODE}":U,"YES").
 /* get the key of the first child */
 cChildKey = DYNAMIC-FUNCTION("getProperty":U in h_dynTreeview, "CHILD":U,"{&SMARTTOOLBAR_NODE}":U).
 DO WHILE cChildKey <> "" AND cChildKey <> ?:
   cTag = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"TAG":U,cChildKey) .
   /* Test whether the object filename equals the specified name parameter */
   IF NUM-ENTRIES(cTag,"|") >=3 AND trim(ENTRY(3,cTag,"|")) = pcToolbarNode THEN
   DO:
     DYNAMIC-FUNCTION("setProperty":U in h_dynTreeview, "SELECTEDITEM":U,cChildKey,"YES":U).
     RUN treeclick IN THIS-PROCEDURE (cChildKey, cTag).
     RETURN.
   END.
   cChildKey = DYNAMIC-FUNC("getProperty":U IN h_dyntreeview,"NEXT":U,cChildKey).
 END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sensitizeTranslation wiWin 
PROCEDURE sensitizeTranslation :
/*------------------------------------------------------------------------------
  Purpose:     This procedur will enable or disable the translation button on
               the toolbar.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER plEnable AS LOGICAL    NO-UNDO.

  DO WITH FRAME frmToolbar:
    IF plEnable THEN
      buTranslate:SENSITIVE = TRUE.
    ELSE
      buTranslate:SENSITIVE = FALSE.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE treeClick wiWin 
PROCEDURE treeClick :
/*------------------------------------------------------------------------------
  Purpose:     View/Hide SmartViewers by selecting pages based on the node selected.
               This also re-establishes the TableIO Link and recretaes the required
               folder labels.

  Parameters:  pcKey    Key of node clicked
               pcTag    Private Data value of node clicked
  Notes:       Called from TVNodeEvent when a node is clicked.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcKey AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcTag AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cKey          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNodeType     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lCancel       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iCurrentPage  AS INTEGER    NO-UNDO.
DEFINE VARIABLE cTabFolder    AS CHARACTER  NO-UNDO.

ASSIGN cNodeType = ENTRY(1,pcTag,"|").

/* Is there any unsaved or uncommitted data? */
IF VALID-HANDLE(ghTableIOTarget) THEN
DO:
  glExcludeCancel = YES.
  RUN confirmContinue IN ghTableIOTarget (INPUT-OUTPUT lCancel).
  IF lCancel THEN
    RUN cancelRecord IN ghTableIOTarget.
  glExcludeCancel = NO.
END.

{get FolderLabels cTabFolder h_folder}.
{get CurrentPage  iCurrentPage}.

{fnarg lockWindow TRUE}.
CASE cNodeType:
    /* When a category node is selected */
  WHEN "@CATG":U OR WHEN "CATG":U THEN
  DO:
    {fnarg constructFolderLabels 'Category' h_folder}.
    ASSIGN giPageTab  = 1.
    IF iCurrentPage <> 5 THEN
    DO:
      ASSIGN giNodePage = 5.
      RUN selectPage(5).
    END.
    RUN ShowCurrentPage IN h_folder(1).

    IF VALID-HANDLE(ghTableIOTarget) THEN
       RUN removeLink ( h_pupdsav , 'TableIO':U , ghTableIOTarget ).
    RUN addLink    ( h_pupdsav , 'TableIO':U , h_gscicview ).
    ASSIGN ghTableIOTarget = h_gscicview.

    DYNAMIC-FUNC('assignQuerySelection':U IN h_gscicfullo, 'item_category_obj':U, ENTRY(2,pcTag,"|"),"EQ":U ).
    {fn OpenQuery h_gscicfullo}.
    DYNAMIC-FUNC('removeQuerySelection':U IN h_gscicfullo, 'item_category_obj':U,"EQ":U ).
    RUN enableFields IN h_gscicview.
    RUN resetTableIO IN h_pupdsav.
    RUN viewObject IN h_pupdsav.
    {set SaveSource YES  h_gscicview}.
  END. /* END WHEN "CATG" */

  /* When a specific band node is selected */
  WHEN "@BAND":U OR WHEN "BAND":U THEN
  DO:
    IF /*iCurrentPage <> 2 OR*/ ENTRY(1,cTabFolder,"|") <> "Band":U THEN
    DO:
      {fnarg constructFolderLabels "'Band|Band Object'" h_folder}.
      ASSIGN giPageTab  = 1.
      IF iCurrentPage <> 6 THEN
      DO:
        ASSIGN giNodePage = 6.
        RUN selectPage(6).
      END.
      RUN ShowCurrentPage IN h_folder(1).
      IF VALID-HANDLE(ghTableIOTarget) THEN
         RUN removeLink ( h_pupdsav , 'TableIO':U , ghTableIOTarget ).
      RUN addLink    ( h_pupdsav , 'TableIO':U , h_gsmmsview ).
      ASSIGN ghTableIOTarget = h_gsmmsview.
    END.

    DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmmsfullo, 'menu_structure_obj':U,ENTRY(2,pcTag,"|"),"EQ":U).
    {fn OpenQuery h_gsmmsfullo}.
    DYNAMIC-FUNC('removeQuerySelection':U IN h_gsmmsfullo, 'menu_structure_obj':U,"EQ":U).
    RUN enableFields IN h_gsmmsview.
    IF VALID-HANDLE(h_gsmomviewt) THEN
    DO:
      RUN enableFields IN h_gsmomviewt.
      {set SaveSource YES h_gsmomviewt}.
    END.
    RUN resetTableIO IN h_pupdsav.
    RUN viewObject IN h_pupdsav.
    {set SaveSource YES h_gsmmsview}.
  END. /* END WHEN "BAND" */

  /* When a specific item node is selcted */
  WHEN "ITEM":U THEN
  DO:
    {fnarg constructFolderLabels "'Item'" h_folder}.
    ASSIGN giPageTab  = 1.
    IF iCurrentPage <> 7 THEN
    DO:
      ASSIGN giNodePage = 7.
      RUN selectPage(7).
    END.
    RUN ShowCurrentPage IN h_folder(1).
    IF VALID-HANDLE(ghTableIOTarget) THEN
       RUN removeLink ( h_pupdsav , 'TableIO':U , ghTableIOTarget ).
    RUN addLink    ( h_pupdsav , 'TableIO':U , h_gsmmiview ).
    ASSIGN ghTableIOTarget = h_gsmmiview.
    DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmmifullo, 'menu_item_obj':U,  ENTRY(2,pcTag,"|"), "EQ":U).
          {fn OpenQuery h_gsmmifullo} .
    DYNAMIC-FUNC('removeQuerySelection':U IN h_gsmmifullo, 'menu_item_obj':U, "EQ":U).
    RUN setSensitive IN h_gsmmiview  (YES) .
    RUN enableFields IN h_gsmmiview.
    RUN viewObject IN h_pupdsav.
    {set SaveSource YES h_gsmmiview}.
    RUN adjustTabOrder (h_gsmmiview, h_pupdsav, 'BEFORE':U).
    RUN adjustTabOrder (h_dyntreeview, h_gsmmiview, 'BEFORE':U).
  END. /* END WHEN "ITEM" */

  WHEN "BANDITEM":U  OR WHEN "@BANDITEM":U THEN
  DO:
    {fnarg constructFolderLabels "'Band Item| Item (add to Band) '" h_folder}.
    IF iCurrentPage <> 8 AND ENTRY(1,cTabFolder,"|") <> "Band Item" THEN
    DO:
      ASSIGN giNodePage = 8.
      RUN selectPage(8).
      RUN ShowCurrentPage IN h_folder(1).
    END.
    ELSE
      RUN ShowCurrentPage IN h_folder(giPageTab).
    IF VALID-HANDLE(ghTableIOTarget) THEN
       RUN removeLink ( h_pupdsav , 'TableIO':U , ghTableIOTarget ).
    RUN addLink    ( h_pupdsav , 'TableIO':U , h_gsmitview ).
    ASSIGN ghTableIOTarget = h_gsmitview.

    IF TRIM(ENTRY(1,cTabFolder,"|")) = "Band Item" THEN
    DO:
      IF giPageTab = 2  THEN
      DO:
        giPageTab = 1.
        RUN selectPage(2).
        giPageTab = 2.
      END.
    END.
    ELSE
      ASSIGN giPageTab  = 1.
    RUN viewObject IN h_pupdsav.
    IF VALID-HANDLE(h_gsmitview) THEN
      RUN removeLink (h_gsmitfullo, 'Data':U, h_gsmitview).
    DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmmsfullo, 'menu_structure_obj':U, ENTRY(3,pcTag,"|"),"EQ":U).
    {fn OpenQuery h_gsmmsfullo} .
    DYNAMIC-FUNC('removeQuerySelection':U IN h_gsmmsfullo, 'menu_structure_obj':U, "EQ":U).

    IF VALID-HANDLE(h_gsmitview) THEN
      RUN addLink (h_gsmitfullo, 'Data':U, h_gsmitview).

    DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmitfullo, 'menu_structure_item_obj':U, ENTRY(2,pcTag,"|"),"EQ":U).
    {fn OpenQuery h_gsmitfullo} .
    DYNAMIC-FUNC('removeQuerySelection':U IN h_gsmitfullo, 'menu_structure_item_obj':U, "EQ":U).
    RUN enableFields IN h_gsmitview.
    {set SaveSource YES h_gsmitview}.
  END. /* END WHEN "BANDITEM" */


  WHEN "TBAROBJ":U  OR WHEN "@TBAROBJ":U THEN
  DO:
    DO WITH FRAME {&FRAME-NAME}:
    ASSIGN coObjType .
    {fnarg constructFolderLabels coObjType h_folder}.
    END.
    ASSIGN giPageTab  = 1.
    IF iCurrentPage <> 9 THEN
    DO:
      ASSIGN giNodePage = 9.
      RUN selectPage(9).
    END.

    RUN ShowCurrentPage IN h_folder(1).
    IF VALID-HANDLE(ghTableIOTarget) THEN
       RUN removeLink ( h_pupdsav , 'TableIO':U , ghTableIOTarget ).
    RUN addLink    ( h_pupdsav , 'TableIO':U , h_gscobviewt ).
    ASSIGN ghTableIOTarget = h_gscobviewt.
    RUN enableFields IN h_gscobviewt.
    DYNAMIC-FUNC('assignQuerySelection':U IN h_rycsoful2o, 'smartobject_obj':U, ENTRY(2,pcTag,"|"),"EQ":U).
    {fn OpenQuery h_rycsoful2o} .
    DYNAMIC-FUNC('removeQuerySelection':U IN h_rycsoful2o, 'smartobject_obj':U,"EQ":U).
    RUN viewObject IN h_pupdsav.
    {set SaveSource YES h_gscobviewt}.

  END. /* END WHEN "TBAROBJ" */

  WHEN "TBARBAND":U  OR WHEN "@TBARBAND":U THEN
  DO:
    {fnarg constructFolderLabels "coObjType:SCREEN-VALUE IN FRAME {&FRAME-NAME} + 'Bands'" h_folder}.
    ASSIGN giPageTab  = 1.
    IF iCurrentPage <> 10 THEN
    DO:
      ASSIGN giNodePage = 10.
      RUN selectPage(10).
    END.
    RUN ShowCurrentPage IN h_folder(1).
    IF VALID-HANDLE(ghTableIOTarget) THEN
       RUN removeLink ( h_pupdsav , 'TableIO':U , ghTableIOTarget ).
    RUN addLink    ( h_pupdsav , 'TableIO':U , h_gsmtmview ).
    ASSIGN ghTableIOTarget = h_gsmtmview.

    /* Reposition Parent SDO */
    IF VALID-HANDLE(h_gsmtmview) THEN
      RUN removeLink (h_gsmtmfullo, 'Data':U, h_gsmtmview).

    RUN enableFields IN h_gsmtmview.
    DYNAMIC-FUNC('assignQuerySelection':U IN h_rycsoful2o, 'smartobject_obj':U, ENTRY(5,pcTag,"|"),"EQ":U).
    {fn OpenQuery h_rycsoful2o} .
    DYNAMIC-FUNC('removeQuerySelection':U IN h_rycsoful2o, 'smartobject_obj':U, "EQ":U).

    IF VALID-HANDLE(h_gsmtmview) THEN
      RUN addLink (h_gsmtmfullo, 'Data':U, h_gsmtmview).

    DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmtmfullo, 'toolbar_menu_structure_obj':U, ENTRY(2,pcTag,"|"),"EQ":U).
    {fn OpenQuery h_gsmtmfullo} .
    DYNAMIC-FUNC('removeQuerySelection':U IN h_gsmtmfullo, 'toolbar_menu_structure_obj':U, "EQ":U).
    RUN viewObject IN h_pupdsav.
    {set SaveSource YES h_gsmtmview}.
  END.  /* END WHEN "TBARBAND" */

  OTHERWISE
  DO:
    ASSIGN giNodePage = 0.
    RUN selectPage(0).
    cKey = DYNAMIC-FUNC("getProperty":U IN h_dyntreeview,"TEXT":U,pcKey).
    ckey = REPLACE(ckey,"&","&&").
    IF cKey = "" THEN
      cKey = REPLACE({&WINDOW-NAME}:TITLE,"&","&&").
    {fnarg constructFolderLabels cKey h_folder}.
    RUN ShowCurrentPage IN h_folder(1).
    IF VALID-HANDLE(ghTableIOTarget) THEN
       RUN hideObject IN ghTableIOTarget.
    RUN hideObject IN h_pupdsav.
  END. /* END OTHERWISE  */
END CASE.

{fnarg lockWindow FALSE}.

/* Set the property attributes for the toolbar master objects */
IF (cNodeType = "TBAROBJ":U OR cNodeType = "@TBAROBJ":U) AND TRIM(ENTRY(4,pcTag,"|")) = "" THEN 
DO:
  ASSIGN buProperty:SENSITIVE IN FRAME frmToolbar = TRUE.
  RUN displayPropertySheet (pcTag).
END.
ELSE
  buProperty:SENSITIVE IN FRAME frmToolbar = FALSE.

gcLastNodeKey = pckey.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE treeExpand wiWin 
PROCEDURE treeExpand :
/*------------------------------------------------------------------------------
  Purpose:     Called from TVNodeEvent when a node is expanded.
  Parameters:  pcKey    Key of node expanded
               pcTag    Private Data value of node expanded
  Notes:       Based on the type of node created, the tag will contain the
               following:
      Item      : ITEM|menu_item_obj|item_category_obj|item_control_type
      Band      : BAND|menu_structure_obj|menu_Structure_type
      Band Item : BANDITEM|menu_Structure_item_obj|menu_structure_obj|
                  menu_item_sequence|item_control_type|child_menu_structure_obj|
                  menu_item_obj
      ToolBar   : TBAROBJ|object_obj
    Toolbar Band: TBARBAND|toolbar_menu_structure_obj|menu_Structure_obj|
                  menu_structure_sequence|object_obj

    If the node has not yet been expanded, the tag will contain a @ suffix.

------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcKey AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcTag AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cChildKey       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNodeType       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lCancel         AS LOGICAL    NO-UNDO.

/* Only process expand logic if there is a temporary dummy record */
IF NOT pcTag begins "@":U  THEN
  RETURN.

/* Is there any unsaved or uncommitted data? */
IF VALID-HANDLE(ghTableIOTarget) THEN
DO:
  glExcludeCancel = YES.
  RUN confirmContinue IN ghTableIOTarget (INPUT-OUTPUT lCancel).
  IF lCancel THEN
    RUN cancelRecord IN ghTableIOTarget.
  glExcludeCancel = NO.
END.

SESSION:SET-WAIT-STATE('general':U).

/* delete dummy child node, and strip out the @ character in the tag */
cChildKey = DYNAMIC-FUNCTION("GetProperty":U IN h_dyntreeview,"Child":U,pckey).
RUN deletenode IN h_dyntreeview (cChildKey).
pcTag = SUBSTRING(pcTag,2).
DYNAMIC-FUNCTION("SetProperty":U IN h_dyntreeview,"TAG":U,pckey,pcTag).


ASSIGN cNodeType = ENTRY(1,pcTag,"|") NO-ERROR.
CASE cNodeType:
    /* When the Category node is expanded, retrieve all categories from gsc_item_category */
  WHEN "CATG":U THEN
    RUN treeExpandCatg(pcKey,pcTag).

  /* When the Bands Label node is expanded, retrieve all bands from gsm_menu_structure */
  WHEN "BANDLABEL":U THEN
    RUN treeExpandBandLabel(pcKey,pcTag).

  /* When a specific band under the Bands node is expanded, add all items for that band from gsm_menu_structure_item */
  WHEN "BAND":U  THEN
    RUN treeExpandBandNode(pcKey,pcTag,"BANDITEM":U,2).

 /* When an item within a band that has a subband is expanded, add all items for that band from gsm_menu_structure_item */
  WHEN "BANDITEM":U  THEN
    RUN treeExpandBandNode(pcKey,pcTag,"BANDITEM":U,6).

  /* When the SmartToolbar main node is expanded, retrieve all toolbar objects from gsc_object. */
  WHEN "TBARLABEL":U THEN
    RUN treeExpandTBARLabel(pcKey,pcTag).

  /* When a specific toolbar object node is expanded */
  WHEN "TBAROBJ":U THEN
    RUN treeExpandTBARObj(pcKey,pcTag).

   /* When a toolbar band is expanded or when a sub band is expanded */
  WHEN "TBARBAND":U THEN
    RUN treeExpandBandNode(pcKey,pcTag,"BANDITEM":U,3).


END CASE.

SESSION:SET-WAIT-STATE('':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE treeExpandBandLabel wiWin 
PROCEDURE treeExpandBandLabel :
/*------------------------------------------------------------------------------
  Purpose:    Called from treeExpand when node expanded is band type
              (MenuBars, Toolbars, Submenus, Menu&Toolbars)
  Parameters: pcKey   Key of node expanded
              pcTag   Tag of node exxpanded
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcKey AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcTag AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cNodeKey        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCols           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lBandAvailable  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hTable          AS HANDLE     NO-UNDO.

  /* BUFFER FIELD handles */
DEFINE VARIABLE hBuf            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hLabel          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hKey            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hParentKey      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTag            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hImage          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSelectedImage  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hExpanded       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSort           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hInsert         AS HANDLE     NO-UNDO.

{get TreeDataTable hTable h_dyntreeview}.

/* Get buffer handles */
ASSIGN hBuf            = hTable:DEFAULT-BUFFER-HANDLE
       hKey            = hBuf:BUFFER-FIELD('node_key':U)
       hlabel          = hBuf:BUFFER-FIELD('node_label':U)
       hParentKey      = hBuf:BUFFER-FIELD('parent_node_key':U)
       hTag            = hBuf:BUFFER-FIELD('private_data':U)
       hImage          = hBuf:BUFFER-FIELD('image':U)
       hSelectedImage  = hBuf:BUFFER-FIELD('selected_image':U)
       hExpanded       = hBuf:BUFFER-FIELD('node_expanded':U)
       hSort           = hBuf:BUFFER-FIELD('node_sort':U)
       hInsert         = hBuf:BUFFER-FIELD('node_insert':U).

hBuf:EMPTY-TEMP-TABLE().

  /* Remove data link before building nodes for greater performance */
IF VALID-HANDLE(h_gsmmsview) THEN
  RUN removeLink (h_gsmmsfullo, 'Data':U, h_gsmmsview).

IF VALID-HANDLE(h_gsmitfullo) THEN
  RUN removeLink (h_gsmmsfullo, 'Data':U, h_gsmitfullo).

IF VALID-HANDLE(h_gsmomfullo) THEN
  RUN removeLink (h_gsmmsfullo, 'Data':U, h_gsmomfullo).

  /* If specific module is selected in combo-box, refine query */
IF gcModuleObj > "0":U THEN
    DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmmsfullo,'product_module_obj':U,gcModuleObj,'EQ':U).
ELSE IF gcModuleCodeClause > "" THEN
     DYNAMIC-FUNCTION('addQueryWhere':U IN  h_gsmmsfullo, INPUT gcModuleCodeClause,?,?).
 /* Query all menu bands for the specific menu structure type (Menubars, Toolbars, Submenus, Menu&Toolbars) */
DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmmsfullo,'menu_structure_type':U,ENTRY(2,pcTag,"|"),'EQ':U).
{fn OpenQuery h_gsmmsfullo}.
DYNAMIC-FUNC("removeQuerySelection":U IN h_gsmmsfullo, 'menu_structure_type':U,"EQ":U).

lBandAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_gsmmsfullo,"CURRENT":U).
  /* Add all items for specific band that was expanded */
DO WHILE lBandAvailable:
  cCols = DYNAMIC-FUNC("colValues":U IN h_gsmmsfullo,"menu_structure_description,menu_structure_type,menu_structure_obj,menu_structure_code":U).
  hbuf:BUFFER-CREATE().
  ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
         cNodeKey                      = hKey:BUFFER-VALUE
         hParentKey:BUFFER-VALUE       = pcKey
         hInsert:BUFFER-VALUE          = 4
         hLabel:BUFFER-VALUE           = ENTRY(5,cCols,CHR(1)) + (IF ENTRY(2,cCols,CHR(1)) > "" AND trim(ENTRY(5,cCols,CHR(1))) <> trim(ENTRY(2,cCols,CHR(1))) 
                                                                  THEN "  (":U + ENTRY(2,cCols,CHR(1)) + ")"
                                                                  ELSE "")
         hImage:BUFFER-VALUE           = getBandImage(ENTRY(3,cCols,CHR(1)))
         hSelectedImage:BUFFER-VALUE   = hImage:BUFFER-VALUE
         hSort:BUFFER-VALUE            = TRUE
         hTag:BUFFER-VALUE             = "@BAND|":U + ENTRY(4,cCols,CHR(1)) + "|" + ENTRY(3,cCols,CHR(1))
         NO-ERROR.
   /* Ensure the Text is never blank */
   IF hLabel:BUFFER-VALUE = "" OR hLabel:BUFFER-VALUE = ? THEN
       hLabel:BUFFER-VALUE = "(None)".


/*    *** Removed check for child nodes for performance improvements                                               */

/*    /* Determine whether any items exist per band. If yes, add dummy node*/                                      */
/*    DYNAMIC-FUNC("assignQuerySelection":U IN h_gsmitfullo, 'menu_structure_obj':U,ENTRY(4,cCols,CHR(1)),"EQ":U). */
/*   {fn OpenQuery h_gsmitfullo}.                                                                                  */
/*    DYNAMIC-FUNC("removeQuerySelection":U IN h_gsmitfullo, 'menu_structure_obj':U,"EQ":U).                       */
/*                                                                                                                 */
/*   lItemAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_gsmitfullo,"CURRENT":U).                              */
/*                                                                                                                 */
/*   IF lItemAvailable THEN                                                                                        */

/*  DO:                                                                                                            */
  hbuf:BUFFER-CREATE().
  ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
         hParentKey:BUFFER-VALUE       = cNodeKey
         hInsert:BUFFER-VALUE          = 4
         hLabel:BUFFER-VALUE           = "@DummyRecord":U
         hImage:BUFFER-VALUE           = ""
         hSelectedImage:BUFFER-VALUE   = ""
         hTag:BUFFER-VALUE             = "@Dummy":U
         NO-ERROR.
 /* END.                                                                                                         */

  lBandAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_gsmmsfullo,"NEXT":U).
  IF lbandAvailable THEN
    RUN fetchNext IN h_gsmmsfullo.
END.

RUN populateTree IN h_dyntreeview (hTable,pcKey).

/* Add back data links */
IF VALID-HANDLE(h_gsmmsview) THEN
  RUN addLink (h_gsmmsfullo, 'Data':U, h_gsmmsview).

IF VALID-HANDLE(h_gsmitfullo) THEN
  RUN addLink (h_gsmmsfullo, 'Data':U, h_gsmitfullo).

IF VALID-HANDLE(h_gsmomfullo) THEN
  RUN addLink (h_gsmmsfullo, 'Data':U, h_gsmomfullo).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE treeExpandBandNode wiWin 
PROCEDURE treeExpandBandNode PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:    Called from treeExpand when band node expanded is a specific band
  Parameters:  pcKey        Key of expanded node
               pcTag        Tag of expanded node
               pcTagType    BANDITEM     When a band node is expanded
                            SUBBANDITEM  When a sub band of a band node, or a band of a toolbar band is expanded
               piEntryPos   Entry position of the pcTag field to use for retrieving the menu_structure_obj
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcKey      AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcTag      AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcTagType  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER piEntryPos AS INTEGER    NO-UNDO.

DEFINE VARIABLE cCols           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lRowAvailable   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cNodeKey        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hTable          AS HANDLE     NO-UNDO.
DEFINE VARIABLE cLabel          AS CHARACTER  NO-UNDO.

  /* BUFFER FIELD handles */
DEFINE VARIABLE hBuf            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hLabel          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hKey            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hParentKey      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTag            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hImage          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSelectedImage  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hExpanded       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSort           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hInsert         AS HANDLE     NO-UNDO.

{get TreeDataTable hTable h_dyntreeview}.

/* Get buffer handles */
ASSIGN hBuf            = hTable:DEFAULT-BUFFER-HANDLE
       hKey            = hBuf:BUFFER-FIELD('node_key':U)
       hlabel          = hBuf:BUFFER-FIELD('node_label':U)
       hParentKey      = hBuf:BUFFER-FIELD('parent_node_key':U)
       hTag            = hBuf:BUFFER-FIELD('private_data':U)
       hImage          = hBuf:BUFFER-FIELD('image':U)
       hSelectedImage  = hBuf:BUFFER-FIELD('selected_image':U)
       hExpanded       = hBuf:BUFFER-FIELD('node_expanded':U)
       hSort           = hBuf:BUFFER-FIELD('node_sort':U)
       hInsert         = hBuf:BUFFER-FIELD('node_insert':U).
hBuf:EMPTY-TEMP-TABLE().

 /* Remove data link before building nodes for greater performance */
IF VALID-HANDLE(h_gsmitview) THEN
  RUN removeLink (h_gsmitfullo, 'Data':U, h_gsmitview).

IF VALID-HANDLE(h_gsmmsfullo) THEN
  RUN removeLink (h_gsmmsfullo, 'Data':U, h_gsmitfullo).

IF VALID-HANDLE(h_gsmmsview) THEN
  RUN removeLink (h_gsmmsfullo, 'Data':U, h_gsmmsview).

IF VALID-HANDLE(h_gsmomfullo) THEN
  RUN removeLink (h_gsmmsfullo, 'Data':U, h_gsmomfullo).

 /* Query all band items for the specified band  */
DYNAMIC-FUNC("assignQuerySelection":U IN h_gsmitfullo, 'menu_structure_obj':U,ENTRY(piEntryPos,pcTag,"|"),"EQ":U).
DYNAMIC-FUNC("setQuerySort":U IN h_gsmitfullo,"BY menu_structure_obj BY menu_item_sequence":U).
{fn OpenQuery h_gsmitfullo}.
DYNAMIC-FUNC("removeQuerySelection":U IN h_gsmitfullo, 'menu_structure_obj':U,"EQ":U).

lRowAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_gsmitfullo,"CURRENT":U).
/* Add all items for specific category that was expanded */
DO WHILE lRowAvailable:
                                              /* Entries:    2                    3                    4                 5                  6                  7                    8                       9                 10         */
  cCols = DYNAMIC-FUNC("colValues":U IN h_gsmitfullo,"menu_item_label,menu_item_reference,menu_item_description,menu_item_sequence,item_control_type,menu_structure_item_obj,menu_structure_obj,child_menu_structure_obj,menu_item_obj":U).
  cLabel = getItemLabel(ENTRY(2,cCols,CHR(1)),ENTRY(3,cCols,CHR(1)),ENTRY(4,cCols,CHR(1)),ENTRY(6,cCols,CHR(1))).
  hbuf:BUFFER-CREATE().
  ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
         cNodeKey                      = hkey:BUFFER-VALUE
         hParentKey:BUFFER-VALUE       = pcKey
         hInsert:BUFFER-VALUE          = 4
         hLabel:BUFFER-VALUE           = cLabel
         hImage:BUFFER-VALUE           = getItemImage(ENTRY(6,cCols,CHR(1)))
         hSelectedImage:BUFFER-VALUE   = hImage:BUFFER-VALUE
         hSort:BUFFER-VALUE            = FALSE
         hTag:BUFFER-VALUE             = pcTagType + "|" +  ENTRY(7,cCols,CHR(1)) + "|" + ENTRY(8,cCols,CHR(1)) + "|"
                                          + ENTRY(5,cCols,CHR(1)) + "|" + ENTRY(6,cCols,CHR(1)) + "|"
                                          + ENTRY(9,cCols,CHR(1)) + "|" + ENTRY(10,cCols,CHR(1))
         NO-ERROR.

  /* Ensure the Text is never blank */
   IF hLabel:BUFFER-VALUE = "" OR hLabel:BUFFER-VALUE = ? THEN
       hLabel:BUFFER-VALUE = "(None)".

  /* Check whether item has a subband. If yes, add the key to the string  and append an arrow */
  IF ENTRY(9,cCols,CHR(1)) > '0':U  AND ENTRY(9,cCols,CHR(1))  <> '?'  AND ENTRY(9,cCols,CHR(1))  <> ?  THEN
  DO:
    DYNAMIC-FUNC('removeQuerySelection':U IN h_gsmmsfullo,'product_module_obj':U,'EQ':U).
    DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmmsfullo,'menu_structure_obj':U,ENTRY(9,cCols,CHR(1)),'EQ':U).
    {fn OpenQuery h_gsmmsfullo}.
    DYNAMIC-FUNC('removeQuerySelection':U IN h_gsmmsfullo,'menu_structure_obj':U,'EQ':U).
    ASSIGN cCols               = DYNAMIC-FUNC("colValues":U IN h_gsmmsfullo,"menu_structure_code":U)
           hLabel:BUFFER-VALUE = hLabel:BUFFER-VALUE + "  >> "
               + (IF ENTRY(2,cCols,CHR(1)) > "" AND ENTRY(2,cCols,CHR(1))  <> ?
                          THEN "(" + ENTRY(2,cCols,CHR(1)) + ")"
                          ELSE "")
           hTag:BUFFER-VALUE   = "@" + hTag:BUFFER-VALUE.
     hbuf:BUFFER-CREATE().
     ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
            hParentKey:BUFFER-VALUE       = cNodeKey
            hInsert:BUFFER-VALUE          = 4
            hLabel:BUFFER-VALUE           = "@DummyRecord":U
            hImage:BUFFER-VALUE           = ""
            hSelectedImage:BUFFER-VALUE   = ""
            hTag:BUFFER-VALUE             = "@Dummy":U
            NO-ERROR.
  END.
  lRowAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_gsmitfullo,"NEXT":U).
  IF lRowAvailable THEN
     RUN fetchNext IN h_gsmitfullo.
END.

RUN populateTree IN h_dyntreeview (hTable,pcKey).

IF VALID-HANDLE(h_gsmitview) THEN
  RUN addLink (h_gsmitfullo, 'Data':U, h_gsmitview).

IF VALID-HANDLE(h_gsmmsfullo) THEN
  RUN addLink (h_gsmmsfullo, 'Data':U, h_gsmitfullo).

IF VALID-HANDLE(h_gsmmsview) THEN
  RUN addLink (h_gsmmsfullo, 'Data':U, h_gsmmsview).

IF VALID-HANDLE(h_gsmomfullo) THEN
  RUN addLink (h_gsmmsfullo, 'Data':U, h_gsmomfullo).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE treeExpandCatg wiWin 
PROCEDURE treeExpandCatg :
/*------------------------------------------------------------------------------
  Purpose:     Called from treeExpand procedure when a category node is expanded
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcKey AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcTag AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cCols           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lRowAvailable   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE LReplaceLink    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hTable          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE clabel          AS CHARACTER  NO-UNDO.


    /* BUFFER FIELD handles */
  DEFINE VARIABLE hBuf            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hLabel          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hKey            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hParentKey      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTag            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hImage          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSelectedImage  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hExpanded       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSort           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hInsert         AS HANDLE     NO-UNDO.

  {get TreeDataTable hTable h_dyntreeview}.

  /* Get buffer handles */
  ASSIGN hBuf            = hTable:DEFAULT-BUFFER-HANDLE
         hKey            = hBuf:BUFFER-FIELD('node_key':U)
         hlabel          = hBuf:BUFFER-FIELD('node_label':U)
         hParentKey      = hBuf:BUFFER-FIELD('parent_node_key':U)
         hTag            = hBuf:BUFFER-FIELD('private_data':U)
         hImage          = hBuf:BUFFER-FIELD('image':U)
         hSelectedImage  = hBuf:BUFFER-FIELD('selected_image':U)
         hExpanded       = hBuf:BUFFER-FIELD('node_expanded':U)
         hSort           = hBuf:BUFFER-FIELD('node_sort':U)
         hInsert         = hBuf:BUFFER-FIELD('node_insert':U).

  /* Clear the data from the Treeview Temp Table */
  hBuf:EMPTY-TEMP-TABLE().

/* Remove data link before building nodes for greater performance */
  IF VALID-HANDLE(h_gsmmiview) THEN DO:
    RUN removeLink (h_gsmmifullo, 'Data':U, h_gsmmiview).
    lReplaceLink = TRUE.
  END.

  DYNAMIC-FUNC("assignQuerySelection":U IN h_gsmmifullo, 'item_category_obj':U,ENTRY(2,pcTag,"|"),"EQ":U).
  IF gcModuleObj > "0":U THEN
    DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmmifullo,'product_module_obj':U,gcModuleObj,'EQ':U).
  ELSE IF gcModuleCodeClause > "" THEN
     DYNAMIC-FUNCTION('addQueryWhere':U IN  h_gsmmifullo, INPUT gcModuleCodeClause,?,?).

  {fn OpenQuery h_gsmmifullo}.
  lRowAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_gsmmifullo,"CURRENT":U).
  /* Add all items for specific category that was expanded */
  DO WHILE lRowAvailable:
                                            /* Entries:    2                    3                    4                      5            6              7*/
    cCols = DYNAMIC-FUNC("colValues" IN h_gsmmifullo,"menu_item_label,menu_item_reference,menu_item_description,item_control_type,menu_item_obj,item_category_obj").
    ASSIGN cLabel = getItemLabel(ENTRY(2,cCols,CHR(1)),ENTRY(3,cCols,CHR(1)),ENTRY(4,cCols,CHR(1)),ENTRY(5,cCols,CHR(1))).
    hbuf:BUFFER-CREATE().
    ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
           hParentKey:BUFFER-VALUE       = pcKey
           hInsert:BUFFER-VALUE          = 4
           hLabel:BUFFER-VALUE           = cLabel
           hImage:BUFFER-VALUE           = getItemImage(ENTRY(5,cCols,CHR(1)))
           hSelectedImage:BUFFER-VALUE   = hImage:BUFFER-VALUE
           hSort:BUFFER-VALUE            = TRUE
           hTag:BUFFER-VALUE             = "ITEM|":U + ENTRY(6,cCols,CHR(1)) + "|" +  ENTRY(7,cCols,CHR(1)) + "|" + ENTRY(5,cCols,CHR(1))
           NO-ERROR.
     /* Ensure the Text is never blank */
   IF hLabel:BUFFER-VALUE = "" OR hLabel:BUFFER-VALUE = ? THEN
       hLabel:BUFFER-VALUE = "(None)".

    lRowAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_gsmmifullo,"NEXT":U).
    IF lRowAvailable THEN
      RUN fetchNext IN h_gsmmifullo.
  END. /* END DO WHILE lRowAvailable */

  DYNAMIC-FUNC("removeQuerySelection":U IN h_gsmmifullo, 'item_category_obj':U,"EQ":U).
  RUN populateTree IN h_dyntreeview (hTable,pcKey).
  /* Reapply Data link */
  IF lReplaceLink AND VALID-HANDLE(h_gsmmiview) THEN
    RUN addLink (h_gsmmifullo, 'Data':U, h_gsmmiview).



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE treeExpandTBARLabel wiWin 
PROCEDURE treeExpandTBARLabel :
/*------------------------------------------------------------------------------
  Purpose:   Called from treeExpand procedure when the SmartToolbar label node is expanded
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcKey AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcTag AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cNodeKey        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCols           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lRowAvailable   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hTable          AS HANDLE     NO-UNDO.

  /* BUFFER FIELD handles */
DEFINE VARIABLE hBuf            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hLabel          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hKey            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hParentKey      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTag            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hImage          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSelectedImage  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hExpanded       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSort           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hInsert         AS HANDLE     NO-UNDO.
DEFINE VARIABLE cCustomCode     AS CHARACTER  NO-UNDO.

{get TreeDataTable hTable h_dyntreeview}.

/* Get buffer handles */
ASSIGN hBuf            = hTable:DEFAULT-BUFFER-HANDLE
       hKey            = hBuf:BUFFER-FIELD('node_key':U)
       hlabel          = hBuf:BUFFER-FIELD('node_label':U)
       hParentKey      = hBuf:BUFFER-FIELD('parent_node_key':U)
       hTag            = hBuf:BUFFER-FIELD('private_data':U)
       hImage          = hBuf:BUFFER-FIELD('image':U)
       hSelectedImage  = hBuf:BUFFER-FIELD('selected_image':U)
       hExpanded       = hBuf:BUFFER-FIELD('node_expanded':U)
       hSort           = hBuf:BUFFER-FIELD('node_sort':U)
       hInsert         = hBuf:BUFFER-FIELD('node_insert':U).

/* Clear the data from the TreeView */
hBuf:EMPTY-TEMP-TABLE().

IF VALID-HANDLE(h_gscobviewt) THEN
  RUN removeLink (h_rycsoful2o, 'Data':U, h_gscobviewt).

IF VALID-HANDLE(h_gsmtmfullo) THEN
  RUN removeLink (h_rycsoful2o, 'Data':U, h_gsmtmfullo).

IF gcModuleObj > "0":U THEN
   DYNAMIC-FUNC('assignQuerySelection':U IN h_rycsoful2o,'product_module_obj':U,gcModuleObj,'EQ':U).
ELSE IF gcModuleCodeClause > "" THEN
     DYNAMIC-FUNCTION('addQueryWhere':U IN  h_rycsoful2o, INPUT gcModuleCodeClause,?,?).

/* Get logical objects */

IF gcObjectTypeObj = "" THEN
    setObjectType().

DYNAMIC-FUNC('assignQuerySelection':U IN h_rycsoful2o,
              'object_type_obj,static_object':U,gcObjectTypeObj + CHR(1) + "No":U,'EQ':U).
DYNAMIC-FUNC('assignQuerySelection':U IN h_rycsoful2o, 'template_smartobject':U,'No','EQ':U).
{fn OpenQuery h_rycsoful2o}.
DYNAMIC-FUNC('removeQuerySelection':U IN h_rycsoful2o, 'object_type_obj,static_object':U,'EQ':U).

lRowAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_rycsoful2o,"CURRENT":U).

/* Add all items for specific category that was expanded */
DO WHILE lRowAvailable:

  cCols = DYNAMIC-FUNC("colValues":U IN h_rycsoful2o,"object_description,smartobject_obj,object_filename,customizedResultCode":U).
  hbuf:BUFFER-CREATE().
  ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
         cNodeKey                      = hkey:BUFFER-VALUE
         hParentKey:BUFFER-VALUE       = pcKey
         hInsert:BUFFER-VALUE          = 4
         cCustomCode                   = REPLACE(ENTRY(5,cCols,CHR(1)),")":U,"]":U)
         cCustomCode                   = REPLACE(ENTRY(5,cCols,CHR(1)),"(":U,"[":U)
         hLabel:BUFFER-VALUE           = ENTRY(4,cCols,CHR(1)) 
                                                + (IF cCustomCode > "" 
                                                   THEN cCustomCode  ELSE "" )
                                                + (IF ENTRY(2,cCols,CHR(1)) > "" AND trim(ENTRY(2,cCols,CHR(1))) <> trim(ENTRY(4,cCols,CHR(1)))
                                                   THEN "  (" + ENTRY(2,cCols,CHR(1)) + ")"
                                                   ELSE "")
         hImage:BUFFER-VALUE           = "ry/img/menuobject.bmp":U
         hSelectedImage:BUFFER-VALUE   = hImage:BUFFER-VALUE
         hSort:BUFFER-VALUE            = TRUE
         hTag:BUFFER-VALUE             = "@TBAROBJ|":U +  ENTRY(3,cCols,CHR(1)) + "|" +  ENTRY(4,cCols,CHR(1)) + "|" + ENTRY(5,cCols,CHR(1))
         NO-ERROR.
   /* Ensure the Text is never blank */
   IF hLabel:BUFFER-VALUE = "" OR hLabel:BUFFER-VALUE = ? THEN
       hLabel:BUFFER-VALUE = "(None)".

  /* Determine whether any items exist per band. If yes, add dummy node*/

   /*   Removed check for child nodes for performance improvements
  lRowAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_gsmtmfullo,"CURRENT":U).
  IF lRowAvailable THEN  */
  DO:
      hbuf:BUFFER-CREATE().
      ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
             hParentKey:BUFFER-VALUE       = cNodeKey
             hInsert:BUFFER-VALUE          = 4
             hLabel:BUFFER-VALUE           = "@DummyRecord":U
             hImage:BUFFER-VALUE           = ""
             hSelectedImage:BUFFER-VALUE   = ""
             hTag:BUFFER-VALUE             = "@Dummy":U
             NO-ERROR.
  END.
  lRowAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_rycsoful2o,"NEXT":U).
  IF lRowAvailable THEN
     RUN fetchNext IN h_rycsoful2o.
END.

RUN populateTree IN h_dyntreeview (hTable,pcKey).

IF VALID-HANDLE(h_gscobviewt) THEN
  RUN addLink (h_rycsoful2o, 'Data':U, h_gscobviewt).

IF VALID-HANDLE(h_gsmtmfullo) THEN
  RUN addLink (h_rycsoful2o, 'Data':U, h_gsmtmfullo).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE treeExpandTBARObj wiWin 
PROCEDURE treeExpandTBARObj :
/*------------------------------------------------------------------------------
  Purpose:   Called from treeExpand procedure when a toolbar object node is expanded
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcKey AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcTag AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cNodeKey        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCols           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lRowAvailable   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hTable          AS HANDLE     NO-UNDO.

  /* BUFFER FIELD handles */
DEFINE VARIABLE hBuf            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hLabel          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hKey            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hParentKey      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTag            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hImage          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSelectedImage  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hExpanded       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSort           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hInsert         AS HANDLE     NO-UNDO.

{get TreeDataTable hTable h_dyntreeview}.
/* Get buffer handles */
ASSIGN hBuf            = hTable:DEFAULT-BUFFER-HANDLE
       hKey            = hBuf:BUFFER-FIELD('node_key':U)
       hlabel          = hBuf:BUFFER-FIELD('node_label':U)
       hParentKey      = hBuf:BUFFER-FIELD('parent_node_key':U)
       hTag            = hBuf:BUFFER-FIELD('private_data':U)
       hImage          = hBuf:BUFFER-FIELD('image':U)
       hSelectedImage  = hBuf:BUFFER-FIELD('selected_image':U)
       hExpanded       = hBuf:BUFFER-FIELD('node_expanded':U)
       hSort           = hBuf:BUFFER-FIELD('node_sort':U)
       hInsert         = hBuf:BUFFER-FIELD('node_insert':U).

/* Clear the data from the TreeView */
hBuf:EMPTY-TEMP-TABLE().

IF VALID-HANDLE(h_gsmtmview) THEN
  RUN removeLink (h_gsmtmfullo, 'Data':U, h_gsmtmview).

DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmtmfullo,'object_obj':U,ENTRY(2,pcTag,"|"),'EQ':U).
{fn OpenQuery h_gsmtmfullo}.
DYNAMIC-FUNC('removeQuerySelection':U IN h_gsmtmfullo,'object_obj':U,'EQ':U).
lRowAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_gsmtmfullo,"CURRENT":U).
/* Add all items for specific category that was expanded */
DO WHILE lRowAvailable:
                                               /* Entries:      2                       3                      4                      5                     6                 7 */
  cCols = DYNAMIC-FUNC("colValues":U IN h_gsmtmfullo,"menu_structure_description,menu_structure_type,toolbar_menu_structure_obj,menu_structure_obj,menu_structure_sequence,object_obj":U).
  hbuf:BUFFER-CREATE().
  ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
         cNodeKey                      = hkey:BUFFER-VALUE
         hParentKey:BUFFER-VALUE       = pcKey
         hInsert:BUFFER-VALUE          = 4
         hLabel:BUFFER-VALUE           = ENTRY(2,cCols,CHR(1))
         hImage:BUFFER-VALUE           = getBandImage(ENTRY(3,cCols,CHR(1)))
         hSelectedImage:BUFFER-VALUE   = hImage:BUFFER-VALUE
         hSort:BUFFER-VALUE            = FALSE
         hTag:BUFFER-VALUE             = "@TBARBAND|":U + ENTRY(4,cCols,CHR(1)) + "|" + ENTRY(5,cCols,CHR(1)) + "|" + ENTRY(6,cCols,CHR(1)) + "|" + ENTRY(7,cCols,CHR(1))
         NO-ERROR.

   /* Ensure the Text is never blank */
   IF hLabel:BUFFER-VALUE = "" OR hLabel:BUFFER-VALUE = ? THEN
       hLabel:BUFFER-VALUE = "(None)".

/*   /* Determine whether any items exist per band. If yes, add dummy node*/                                    */
/*   DYNAMIC-FUNC('assignQuerySelection':U IN  h_gsmitfullo,'menu_structure_obj':U,ENTRY(5,cCols,CHR(1)),'EQ'). */
/*   {fn OpenQuery h_gsmitfullo}.                                                                               */
/*   DYNAMIC-FUNC('removeQuerySelection':U IN  h_gsmitfullo,'menu_structure_obj':U,'EQ').                       */
/*                                                                                                              */
/*   lRowAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_gsmitfullo,"CURRENT":U).                            */
/*   IF lRowAvailable THEN DO:                                                                                  */
      hbuf:BUFFER-CREATE().
      ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
             hParentKey:BUFFER-VALUE       = cNodeKey
             hInsert:BUFFER-VALUE          = 4
             hLabel:BUFFER-VALUE           = "@DummyRecord":U
             hImage:BUFFER-VALUE           = ""
             hSelectedImage:BUFFER-VALUE   = ""
             hTag:BUFFER-VALUE             = "@Dummy":U
             NO-ERROR.
/*   END. */

  lRowAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_gsmtmfullo,"NEXT":U).
  IF lRowAvailable THEN
     RUN fetchNext IN h_gsmtmfullo.
END.
RUN populateTree IN h_dyntreeview (hTable,pcKey).

IF  VALID-HANDLE(h_gsmtmview) THEN
  RUN addLink (h_gsmtmfullo, 'Data':U, h_gsmtmview).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE treeMenu wiWin 
PROCEDURE treeMenu :
/*------------------------------------------------------------------------------
  Purpose:     Called when right click is performed on a node. (Called from
               tvNodeEvent procedure).
  Parameters:  pcKey     Key of node selected
               pcTag     Tag of node selected
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcKey AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcTag AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cNodeType       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hPopupMenu      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hFrame          AS HANDLE     NO-UNDO.

ASSIGN cNodeType = ENTRY(1,pcTag,"|")
       cNodeType = IF cNodeType BEGINS "@":U
                   THEN SUBSTRING(cNodeType,2)
                   ELSE cNodeType.
{get ContainerHandle hFrame h_dyntreeview}.

/* Retrieve the handle to the popup menu, based on the tag of the node selected */
hPopupMenu = getPopupMenu(cNodeType).

IF VALID-HANDLE(hPopupMenu) THEN
    ASSIGN hFrame:POPUP-MENU = ?
           hFrame:POPUP-MENU = hPopupMenu.
ELSE
    ASSIGN hFrame:POPUP-MENU = ?.

ASSIGN gcLastNodeKey = pcKey.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE treeSynch wiWin 
PROCEDURE treeSynch :
/*------------------------------------------------------------------------------
  Purpose:     Called upon cancelling an Add/Copy operation. If the popupmenu option
               to Add a record is selected from the treeview, it is possible for the
               selected node in the treeview to become out of synch with the viewer
               if the add operation is cancelled. This procedure refreshes the viewers
               based on the current selected node in the treeview.
  Parameters:  pcNode  Tag type referring to node that was active when cancel was performed
                       (CATG, ITEM, BAND, BANDITEM, TBAROBJ, TBARBAND)
  Notes:       Called from cancelRecord proc in viewers
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcNode AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cTag      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTagEntry AS CHARACTER  NO-UNDO.

/* Only refresh viewers if cancel button is presses in the update panel.  */
IF glExcludeCancel THEN
   RETURN.

ASSIGN cTag      = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"TAG":U,"")
       cTagEntry = ENTRY(1,cTag,"|")
       cTagEntry = IF cTagEntry BEGINS "@"
                   THEN SUBSTRING(cTagEntry,2)
                   ELSE cTagEntry.

 RUN treeclick (DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"KEY":U,""),cTag).

 /* If updating node from the band item (Item(add to band) then disable delete */
 IF giNodePage = 8 THEN
    DYNAMIC-FUNC("disableActions":U IN h_pupdsav,"Delete":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tvNodeEvent wiWin 
PROCEDURE tvNodeEvent :
/*------------------------------------------------------------------------------
  Purpose:     Called from treeview when OCX event occurs
  Parameters:  pcEvent   Name of event that is sent from the treeview
               phTable    Handle of the tempTable containing node information
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcEvent  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcKey    AS CHARACTER     NO-UNDO.

DEFINE VARIABLE cKey      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTag      AS CHARACTER  NO-UNDO.

ASSIGN cTag  = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"TAG":U,pcKey).
CASE pcEvent:
    WHEN "Expand":U THEN
        RUN treeExpand (pcKey, cTag).
    WHEN "Collapse":U THEN
        IF pcKey <> gcLastNodeKey THEN
        DO:
          cKey = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"KEY":U,"").
          IF cKey = pcKey THEN
            RUN treeClick(pcKey, cTag).
        END.
    WHEN "CLICK":U THEN
        RUN treeClick(pcKey, cTag).
    WHEN "RIGHTCLICK":U THEN
        RUN treeMenu(pcKey,cTag).

END CASE.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateNode wiWin 
PROCEDURE updateNode :
/*------------------------------------------------------------------------------
  Purpose:    Updates the text in the node. Caled from the updaterecord proc
              in the viewer
  Parameters: pcNodeType   Specified the node type that is being updated
              pcOldtext    Old Tag value
              pcNewtext    New tag/text value
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcNodeType AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcOldText AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcNewText AS CHARACTER  NO-UNDO.

DEFINE VARIABLE hTable           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hBuf             AS HANDLE     NO-UNDO.
DEFINE VARIABLE cKey             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cInsertKey       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cInsertTag       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cKeyText         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cKeyTag          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFirstKey        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTag             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cParentKey       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cParentText      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBandLabelKey    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cParentTag       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNodeKey         AS CHARACTER  NO-UNDO.

/* BUFFER FIELD handles */
DEFINE VARIABLE hLabel          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hKey            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hParentKey      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTag            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hImage          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSelectedImage  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hExpanded       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSort           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hInsert         AS HANDLE     NO-UNDO.


/* If updating a Band Item or Item or SmartToolbar Band */
IF pcNodeType = "BandItem":U OR pcNodeType = "Item":U or pcNodeType = "TbarBand":U THEN
DO:
 {get TreeDataTable hTable h_dyntreeview}.
  IF NOT VALID-HANDLE(hTable) THEN DO:
      MESSAGE "Invalid Handle found for TreeData temp-table"
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN.
  END.
  ASSIGN hBuf            = hTable:DEFAULT-BUFFER-HANDLE
         hKey            = hBuf:BUFFER-FIELD('node_key':U)
         hlabel          = hBuf:BUFFER-FIELD('node_label':U)
         hParentKey      = hBuf:BUFFER-FIELD('parent_node_key':U)
         hTag            = hBuf:BUFFER-FIELD('private_data':U)
         hImage          = hBuf:BUFFER-FIELD('image':U)
         hSelectedImage  = hBuf:BUFFER-FIELD('selected_image':U)
         hExpanded       = hBuf:BUFFER-FIELD('node_expanded':U)
         hSort           = hBuf:BUFFER-FIELD('node_sort':U)
         hInsert         = hBuf:BUFFER-FIELD('node_insert':U).
   /* Clear the data from the temp table */
  hBuf:EMPTY-TEMP-TABLE().
  ASSIGN cKey      = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"KEY":U,"")
         cKeyTag   = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"TAG":U,"")
         cKeyText  = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"TEXT":U,"")
         NO-ERROR.
END.


CASE pcNodeType:
    /* If the Sequence has been modified, resequence the nodes by deleting the parent
       node, and then re-expanding the parent node */
 WHEN "BandItem":U OR WHEN "TbarBand":U THEN
 DO:
   ASSIGN cParentKey    = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"PARENT":U,"")
          cParentTag    = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"TAG":U,cParentkey)
          cParentText   = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"TEXT":U,cParentkey)
          cBandLabelKey = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"PARENT":U,cParentkey) .

    /* Delete parent band node */
   RUN deleteNode IN h_dyntreeview(cparentKey).
   hbuf:BUFFER-CREATE().
   ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
          cNodeKey                      = hKey:BUFFER-VALUE
          hParentKey:BUFFER-VALUE       = cBandLabelKey
          hInsert:BUFFER-VALUE          = 4
          hLabel:BUFFER-VALUE           = cParentText
          hImage:BUFFER-VALUE           = IF pcNodeType = "BandItem":U
                                          THEN getBandImage(ENTRY(3,cParentTag,"|"))
                                          ELSE "ry/img/menuobject.bmp":U
          hSelectedImage:BUFFER-VALUE   = hImage:BUFFER-VALUE
          hSort:BUFFER-VALUE            = TRUE
          hTag:BUFFER-VALUE             = "@" + cParentTag
          NO-ERROR.

        /* Add dummy node*/
   hbuf:BUFFER-CREATE().
   ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
          hParentKey:BUFFER-VALUE       = cNodeKey
          hInsert:BUFFER-VALUE          = 4
          hLabel:BUFFER-VALUE           = "@DummyRecord":U
          hImage:BUFFER-VALUE           = ""
          hSelectedImage:BUFFER-VALUE   = ""
          hTag:BUFFER-VALUE             = "@Dummy":U
          NO-ERROR.
   RUN populateTree IN h_dyntreeview (hTable,cBandLabelKey).
  /* RUN treeExpand (cNodeKey, "@" + cParentTag).*/
   DYNAMIC-FUNCTION("setProperty":U IN h_dyntreeview,"EXPANDED":U,cNodeKey,"YES":U).
   cKey = getSelectedItem(cNodeKey, ENTRY(2,cKeytag,"|"), 2 ).
   IF cKey > "" THEN
        DYNAMIC-FUNCTION("setProperty":U IN h_dyntreeview,"SELECTEDITEM":U,ckey,"").

   IF pcNodeType = "BANDITEM":U THEN
    RUN refreshBand (cNodeKey , ENTRY(2,cParentTag,"|")).
 END.

 WHEN "ITEM":U THEN
 DO:
   /* Verify that the category hasn't changed */
   ASSIGN cParentKey = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"PARENT":U,"")
          cTag = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"TAG":U,cParentkey)
          NO-ERROR.

   IF giNodePage = 7 AND DECIMAL(ENTRY(2,cTag,"|")) <> DECIMAL(pcOldText) THEN
   DO:
     RUN deleteNode IN h_dyntreeview(ckey).
     /* Find the category node and add item to it */
     /* get Categories node, and then the first child */
     ASSIGN
       cParentkey = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"PARENT":U,cparentKey)
       cInsertKey = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"CHILD":U,cparentKey).
     Child-Loop:
     DO WHILE cInsertKey <> "" AND cInsertKey <> ?:
       cInsertTag  = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"TAG":U,cInsertKey).

       IF DECIMAL(ENTRY(2,cInsertTag,"|")) = DECIMAL(pcOldText) THEN
       DO:

         ASSIGN cFirstKey =  DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"CHILD":U,cInsertKey)
                cInsertTag      =  IF cFirstKey <> "" AND cFirstKey <> ?
                             THEN DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"TAG":U,cFirstKey)
                             ELSE "".
         IF cInsertTag <> "@Dummy":U THEN
         DO:
             /* Insert deleted node at new position */
           hbuf:BUFFER-CREATE().
           ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
                  hParentKey:BUFFER-VALUE       = cInsertKey
                  hInsert:BUFFER-VALUE          = 4
                  hLabel:BUFFER-VALUE           = cKeyText
                  hImage:BUFFER-VALUE           = getItemImage(ENTRY(5,cKeyTag,CHR(1)))
                  hSelectedImage:BUFFER-VALUE   = hImage:BUFFER-VALUE
                  hSort:BUFFER-VALUE            = TRUE
                  hTag:BUFFER-VALUE             = cKeyTag
                  cInsertKey                    = hKey:BUFFER-VALUE
                  NO-ERROR.

           IF CAN-QUERY(hTable,"DEFAULT-BUFFER-HANDLE":U) THEN
              ASSIGN hBuf = hTable:DEFAULT-BUFFER-HANDLE.
           ELSE
              hBuf = hTable.

           RUN addNode IN h_dyntreeview (hbuf).
           DYNAMIC-FUNCTION("setProperty":U IN h_dyntreeview,"SELECTEDITEM":U,cInsertKey,"").

         END.
         LEAVE child-loop.

       END.
       cInsertKey  = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"NEXT":U,cInsertKey).
    END.    /* End DO WHILE cInsertKey <> "" */
   END.
   ELSE  DO:
     DYNAMIC-FUNCTION("SetProperty":U IN h_dyntreeview,"TEXT":U,"",pcNewText).
   END.
   /* If updating node from the band item (Item(add to band) then disable delete */
   IF giNodePage = 8 THEN
     DYNAMIC-FUNC("disableActions":U IN h_pupdsav,"Delete":U).

 END.

 OTHERWISE
   DYNAMIC-FUNCTION("SetProperty":U IN h_dyntreeview,"TEXT":U,"",pcNewText).
 END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBandImage wiWin 
FUNCTION getBandImage RETURNS CHARACTER
  ( pcBandType AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the appropriate image of band, based on the band type
    Notes:
------------------------------------------------------------------------------*/
CASE pcBandType:
    WHEN "MenuBar":U THEN
        RETURN "ry/img/menumenubar.bmp":U.
    WHEN "Toolbar":U THEN
        RETURN "ry/img/menutoolbar.bmp":U.
    WHEN "Submenu":U THEN
        RETURN "ry/img/menusubmenu.bmp":U.
    WHEN "menu&Toolbar":U THEN
        RETURN "ry/img/menumenutoolbar.bmp":U.
    OTHERWISE
        RETURN "ry/img/menusubmenu.bmp":U.
END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCatgInfo wiWin 
FUNCTION getCatgInfo RETURNS LOGICAL
  ( OUTPUT pcObjectID AS CHARACTER,
    OUTPUT pcLabel AS CHARACTER,
    OUTPUT pcDesc  AS CHARACTER,
    OUTPUT pcLink AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Returns information from the current selected category
    Notes:
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cTag      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cKey      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCols     AS CHARACTER  NO-UNDO.

 ASSIGN cTag  = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"TAG":U,"").
 IF ENTRY(1,cTag,"|") = "@CATG":U OR ENTRY(1,cTag,"|") ="CATG":U THEN
     ASSIGN pcObjectID = ENTRY(2,cTag,"|").
 ELSE IF ENTRY(1,cTag,"|") = "ITEM":U THEN
     ASSIGN cKey       = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"PARENT":U,"")
            cTag       = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"TAG":U,cKey)
            pcObjectID = ENTRY(2,cTag,"|").

 IF pcObjectID > "" THEN
 DO:
    DYNAMIC-FUNC('assignQuerySelection':U IN h_gscicfullo, 'item_category_obj':U, pcObjectID,"EQ":U ).
    {fn OpenQuery h_gscicfullo}.
    DYNAMIC-FUNC('removeQuerySelection':U IN h_gscicfullo, 'item_category_obj':U,"EQ":U ).
    cCols = DYNAMIC-FUNC("colValues":U IN h_gscicfullo,"item_category_label,item_category_description,item_link":U).
    IF cCols > "" THEN
       ASSIGN pcLabel = ENTRY(2,cCols,CHR(1))
              pcDesc  = ENTRY(3,cCols,CHR(1))
              pcLink  = ENTRY(4,cCols,CHR(1))
              NO-ERROR.
 END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getItemImage wiWin 
FUNCTION getItemImage RETURNS CHARACTER
  ( pcItemType AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Returns the required item image based on the item type
    Notes:
------------------------------------------------------------------------------*/

CASE pcItemType:
    WHEN "Action":U THEN
        RETURN "ry/img/itemaction.bmp":U.
    WHEN "Label":U THEN
        RETURN "ry/img/itemtext.bmp":U.
    WHEN "Separator":U THEN
        RETURN "ry/img/itemseparator.bmp":U.
    WHEN "EditField":U THEN
        RETURN "ry/img/itemedit.bmp":U.
    WHEN "ComboBox":U THEN
        RETURN "ry/img/itemcombo.bmp":U.
    WHEN "placeholder":U THEN
        RETURN "ry/img/itemdynamic.bmp":U.
    OTHERWISE
        RETURN "ry/img/itemaction.bmp":U.
END CASE.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getItemLabel wiWin 
FUNCTION getItemLabel RETURNS CHARACTER
  ( pcLabel       AS CHAR,
    pcReference   AS CHAR,
    pcDescription AS CHAR,
    pcType        AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Build the Item label string in the format Menu Label (Reference)
    Notes: Strips the ampersands out of the menu label
------------------------------------------------------------------------------*/
   DEFINE VARIABLE lAddRef      AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE cReturnLabel AS CHARACTER  NO-UNDO.

   ASSIGN pcLabel       = IF pcLabel = "" OR pcLabel = ? OR pcLabel = "?" THEN "" ELSE pcLabel
          pcDescription = IF pcDescription = "" OR pcDescription = ? OR pcDescription = "?" THEN "" ELSE pcLabel
          cReturnLabel  = pcLabel
          cReturnLabel  = IF cReturnLabel = "" OR cReturnLabel = ? THEN pcDescription ELSE pcLabel
          lAddRef       = IF pcReference = cReturnLabel OR pcReference = "" OR pcreference = ? THEN NO ELSE YES
          cReturnLabel  = REPLACE(cReturnLabel,"&&":U,"~~")
          cReturnLabel  = REPLACE(cReturnLabel,"&","")
          cReturnLabel  = REPLACE(cReturnLabel,"~~","&")
          cReturnLabel  = IF  (pcType = "Separator":U AND (cReturnLabel = "" OR cReturnLabel = ?))   THEN "Separator" ELSE cReturnLabel
          lAddRef       = IF pcReference = cReturnLabel OR  pcReference = ""  OR pcReference = ? THEN NO ELSE lAddref
          cReturnLabel  = IF lAddref THEN cReturnLabel
                                       + (IF cReturnLabel = "" OR cReturnLabel = ? THEN "" ELSE "  (" )
                                       + LC(pcReference)
                                       + IF cReturnLabel = "" THEN "" ELSE ")" ELSE cReturnLabel
           NO-ERROR.

  RETURN cReturnLabel.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getModuleCode wiWin 
FUNCTION getModuleCode RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

  RETURN gcModuleCode.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getModuleDesc wiWin 
FUNCTION getModuleDesc RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

  RETURN gcModuleDesc.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getModuleObj wiWin 
FUNCTION getModuleObj RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

  RETURN gcModuleObj.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectTypeObj wiWin 
FUNCTION getObjectTypeObj RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

  RETURN gcObjectTypeObj.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPhysicalModuleCode wiWin 
FUNCTION getPhysicalModuleCode RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

  RETURN gcPhysicalModuleCode.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPhysicalModuleDesc wiWin 
FUNCTION getPhysicalModuleDesc RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

  RETURN gcPhysicalModuleDesc.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPhysicalModuleObj wiWin 
FUNCTION getPhysicalModuleObj RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

  RETURN gcPhysicalModuleObj.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPopupMenu wiWin 
FUNCTION getPopupMenu RETURNS HANDLE
  ( pcType AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
CASE pcType:
    WHEN "CATGLABEL":U THEN
        RETURN ghCategoryLabel.
    WHEN "BANDLABEL":U THEN
        RETURN ghBandLabel.
    WHEN "CATG":U THEN
        RETURN ghCategory.
    WHEN "BAND":U  THEN
        RETURN ghBand.
    WHEN "ITEM":U  THEN
        RETURN ghItem.
    WHEN "BANDITEM":U THEN
        RETURN ghBandItem.
    WHEN "TBARLABEL":U THEN
        RETURN ghTbarLabel.
    WHEN "TBAROBJ":U THEN
        RETURN ghTbarObj.


END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getProductModuleCode wiWin 
FUNCTION getProductModuleCode RETURNS CHARACTER
  ( pcObjectID AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
DEFINE VARIABLE iPos      AS INTEGER    NO-UNDO.
DEFINE VARIABLE cLabel    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cModule   AS CHARACTER  NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
ASSIGN iPos    = LOOKUP(pcObjectID,coModule:LIST-ITEM-PAIRS,coModule:DELIMITER)
       cLabel  = ENTRY(iPos - 1, coModule:LIST-ITEM-PAIRS,coModule:DELIMITER)
       cModule = ENTRY(1,cLabel,"/")
       NO-ERROR.
END.

RETURN cModule.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSelectedItem wiWin 
FUNCTION getSelectedItem RETURNS CHARACTER
  ( pcKey   AS CHAR,
    pcTag   AS CHAR,
    piPos   AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  Loops through nodes until it finds the matching ID in the specified
            location.
            Returns the key of the node having the specified input ObjectID in Tag.
    Notes:
------------------------------------------------------------------------------*/
DEFINE VARIABLE cTag       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dTag       AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dObjectID  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cKey       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cReturnKey AS CHARACTER  NO-UNDO.

dTag = DECIMAL(pcTag) NO-ERROR.
IF ERROR-STATUS:ERROR THEN
   RETURN "".

cKey = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"CHILD":U,pcKey).
Child-Loop:
DO WHILE cKey <> "" AND cKey <> ?:
   cTag  = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"TAG":U,cKey).
   dObjectID = DECIMAL(ENTRY(piPos,cTag,"|")) NO-ERROR.

   IF dObjectID > 0 AND dTag = dObjectID THEN DO:
      cReturnKey = cKey.
      LEAVE.
   END.
   cKey  = DYNAMIC-FUNC("getproperty":U IN h_dyntreeview,"NEXT":U,cKey).
 END. /* End Loop through Category nodes */


 RETURN cReturnKey.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSequence wiWin 
FUNCTION getSequence RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
DEFINE VARIABLE cTag      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSeq      AS CHARACTER  NO-UNDO.

ASSIGN cTag  = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"TAG":U,"").

IF ENTRY(1,cTag,"|") = "BANDITEM":U
      OR ENTRY(1,cTag,"|") = "@BANDITEM":U
      OR ENTRY(1,cTag,"|") = "TBARBAND":U
       OR ENTRY(1,cTag,"|") = "@TBARBAND":U  THEN DO:
         cSeq  = ENTRY(4,cTag,"|").
  RETURN cSeq.
END.



RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION lockWindow wiWin 
FUNCTION lockWindow RETURNS LOGICAL
  (plLockWindow AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iReturnCode       AS INTEGER    NO-UNDO.
  
  giLockWindow = giLockWindow + (IF plLockWindow THEN 1 ELSE -1).

  IF plLockWindow AND giLockWindow < 1 THEN
    giLockWindow = 1.

  IF plLockWindow AND giLockWindow > 1 THEN
    RETURN FALSE.

  IF NOT plLockWindow AND giLockWindow <> 0 THEN
    RETURN FALSE.

  IF plLockWindow AND {&WINDOW-NAME}:HWND EQ ? THEN
       RETURN FALSE.

  IF plLockWindow THEN
    RUN lockWindowUpdate IN gshSessionManager (INPUT {&WINDOW-NAME}:HWND, OUTPUT iReturnCode).
  ELSE
    RUN lockWindowUpdate IN gshSessionManager (INPUT 0, OUTPUT iReturnCode).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setObjectType wiWin 
FUNCTION setObjectType RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the ObjectType ID for the SmartToolbar object type and
            also gets the physical object
    Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lRowAvailable AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cCols         AS CHARACTER  NO-UNDO.

  /* Get the Object_type ObjectID for type 'SmartToolbar ' */
  DYNAMIC-FUNC('assignQuerySelection':U IN h_gscotfullo,'object_type_code':U,coObjType:SCREEN-VALUE IN FRAME {&FRAME-NAME},'EQ':U).
  {fn OpenQuery h_gscotfullo}.
  gcObjectTypeObj = DYNAMIC-FUNCTION("ColumnStringValue":U IN h_gscotfullo,"object_type_obj":U).

  /* Get the physical object for SmartToolbar and the object_type_obj, set it to variables. */
  DYNAMIC-FUNC('assignQuerySelection':U IN h_rycsoful2o,'object_type_obj,static_object':U,gcObjectTypeObj + CHR(1) + "Yes":U,'EQ':U).
  {fn OpenQuery h_rycsoful2o}.
  DYNAMIC-FUNC('removeQuerySelection':U IN h_rycsoful2o,'object_type_obj,static_object':U,'EQ':U).
  lRowAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_rycsoful2o,"CURRENT":U).
  IF lRowAvailable THEN
     ASSIGN cCols                = DYNAMIC-FUNC("colValues":U IN h_rycsoful2o,"product_module_obj,product_module_code,product_module_description":U)
            gcPhysicalModuleObj  = ENTRY(2,cCols,CHR(1))
            gcPhysicalModuleCode = ENTRY(3,cCols,CHR(1))
            gcPhysicalModuleDesc = ENTRY(4,cCols,CHR(1))
            NO-ERROR.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

