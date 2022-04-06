&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" vTableWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" vTableWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject
       {"ry/obj/ryemptysdo.i"}.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*************************************************************/  
/* Copyright (c) 1984-2006 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: rygridobjv1.w

  Description:  Object Instance Grid Viewer

  Purpose:      Object Instance Grid Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   03/25/2002  Author:     Chris Koster

  Update Notes: Created from Template rysttviewv.w

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

/* Creating named widget pool as this procedure opens objects in the appBuilder
   which creates widgets that would otherwise be deleted when this procedure 
   closes if the unnamed pool is used */
CREATE WIDGET-POOL STRING(THIS-PROCEDURE).

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ryobjgridv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}
/*{af/app/afdatatypi.i}*/

&GLOBAL-DEFINE define-only YES
{ry/inc/rycntnerbi.i}

/* {&List-1}: All buttons
   {&List-2}: 'Add'    mode buttons
   {&List-3}: 'Modify' mode buttons
   {&List-4}: 'Update' mode buttons 
   {&List-5}: 'View'   mode buttons */
   

DEFINE VARIABLE gcClassesToRetrieve AS CHARACTER  NO-UNDO EXTENT 3
    INITIAL ["" /* use getDataSourceClasses for this */ ,
             "Toolbar,Viewer,Browser,StaticSO,DynFrame,SmartFrame" /*{&VALID-VISIBLE-OBJECT-TYPES}"*/ ,
             "SmartFolder":U].

/* This extent holds fields in the same order as above. */
DEFINE VARIABLE gcRetrievedClasses  AS CHARACTER  NO-UNDO EXTENT 3.

DEFINE VARIABLE gcBaseQueryString   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE giColumnWidth       AS INTEGER    NO-UNDO.
DEFINE VARIABLE giRowHeight         AS INTEGER    NO-UNDO.
DEFINE VARIABLE glCreateAlignment   AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE glHasDataObjects    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glStretchToFit      AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE glLockWindow        AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE glComplete          AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE gdCoCInstanceObj    AS DECIMAL    NO-UNDO. /* Cut or Copy Instance Obj */
DEFINE VARIABLE gdRefreshPending    AS DECIMAL    NO-UNDO INITIAL -1. 
DEFINE VARIABLE glPrefsPending      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glCoCVisible        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE ghInLookup          AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghWidgetSwapped     AS HANDLE     NO-UNDO.

DEFINE VARIABLE ghDesignManager     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghContainerSource   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTBMDesigner       AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghPreviousWidget    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghSourceSelector    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghObjectInstance    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTargetObject      AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTextWidgets       AS HANDLE     NO-UNDO EXTENT 18.
DEFINE VARIABLE ghGridColumns       AS HANDLE     NO-UNDO EXTENT 5.
DEFINE VARIABLE ghGridRows          AS HANDLE     NO-UNDO EXTENT 5.
DEFINE VARIABLE ghProcLib           AS HANDLE     NO-UNDO.

/* The popup menu's handles are define globally for control purposes - see MOUSE-MENU-DOWN of window */
DEFINE VARIABLE ghPopupMenuItems    AS HANDLE     NO-UNDO EXTENT 30.
DEFINE VARIABLE ghEditPopupMenu     AS HANDLE     NO-UNDO EXTENT 9.
DEFINE VARIABLE ghPopupMenu         AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghSelf              AS HANDLE     NO-UNDO.

/* This table will keep track of all the information needed for the grid objects */
DEFINE TEMP-TABLE ttWidget NO-UNDO
  FIELD X                   AS INTEGER
  FIELD Y                   AS INTEGER
  FIELD iRow                AS INTEGER
  FIELD iCol                AS INTEGER
  FIELD hHandle             AS HANDLE
  FIELD hAlignment          AS HANDLE
  FIELD cObject             AS CHARACTER
  FIELD cObjectType         AS CHARACTER
  FIELD dObjectInstanceObj  AS DECIMAL
  FIELD cLCR                AS CHARACTER
  FIELD lAvailable          AS LOGICAL

  INDEX idxCoords    X
                     Y
  INDEX idxRow       iRow
                     iCol 
  INDEX idxObject    hHandle
  INDEX idxAlignment hAlignment.

/* This table will keep track of which widget is selected on which page in which view-mode */
DEFINE TEMP-TABLE ttSelectedWidget NO-UNDO
  FIELD iPage   AS INTEGER
  FIELD cView   AS CHARACTER
  FIELD hWidget AS HANDLE.

/* Variables taken from the definition section of the Quick-Link Viewer */
DEFINE VARIABLE gdSourceObjectInstanceObj AS DECIMAL    NO-UNDO INITIAL ?.
DEFINE VARIABLE gdTargetObjectInstanceObj AS DECIMAL    NO-UNDO INITIAL ?.
DEFINE VARIABLE gcSourceInstanceName      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcTargetInstanceName      AS CHARACTER  NO-UNDO.

/* Preferences variables */
DEFINE VARIABLE gcDefaultValues     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcAlignCenter       AS CHARACTER  NO-UNDO INITIAL "aligncenter":U.
DEFINE VARIABLE gcAlignRight        AS CHARACTER  NO-UNDO INITIAL "alignright":U.
DEFINE VARIABLE gcAlignLeft         AS CHARACTER  NO-UNDO INITIAL "alignleft":U.
DEFINE VARIABLE gcImgNotAvail       AS CHARACTER  NO-UNDO INITIAL "notavail":U.
DEFINE VARIABLE gcImgUnknown        AS CHARACTER  NO-UNDO INITIAL "unknown":U.
DEFINE VARIABLE gcImgAvail          AS CHARACTER  NO-UNDO INITIAL "avail":U.
DEFINE VARIABLE gcCustSuffix        AS CHARACTER  NO-UNDO INITIAL "main":U.
DEFINE VARIABLE gcImageType         AS CHARACTER  NO-UNDO INITIAL ".gif / .bmp":U.
DEFINE VARIABLE gcPath              AS CHARACTER  NO-UNDO INITIAL "ry/img/":U.
DEFINE VARIABLE gcGPos              AS CHARACTER  NO-UNDO INITIAL "Right":U.  /* Is the grid on the 'Right' or 'Left' side of the viewer */
DEFINE VARIABLE glImageTransparent  AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE glConfirmDeletion   AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE glTBTopOrLeft       AS LOGICAL    NO-UNDO INITIAL FALSE.      /* Is Toolbar Top (when horizontal) or Left (when vertical)? */
DEFINE VARIABLE glTBVertical        AS LOGICAL    NO-UNDO INITIAL FALSE.      /* Is the Toolbar vertical          */
DEFINE VARIABLE glTBToGrid          AS LOGICAL    NO-UNDO INITIAL FALSE.      /* Is Toolbar attached to grid? If not, it is attached to the info section */
DEFINE VARIABLE glReposPS           AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE glReposCB           AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE giAlignmentHeight   AS INTEGER    NO-UNDO INITIAL 8.
DEFINE VARIABLE giSelectorColor     AS INTEGER    NO-UNDO INITIAL 10.
DEFINE VARIABLE giNumColumns        AS INTEGER    NO-UNDO INITIAL 9.
DEFINE VARIABLE giNumRows           AS INTEGER    NO-UNDO INITIAL 9.
DEFINE VARIABLE giBGColor           AS INTEGER    NO-UNDO INITIAL 8.
DEFINE VARIABLE giGLColor           AS INTEGER    NO-UNDO INITIAL 0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/ryemptysdo.i"

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rctBackground buNonLayoutObjects edSource ~
edTarget buLayoutPreview fiObjectInstances fiQuickLink 
&Scoped-Define DISPLAYED-OBJECTS fiInstanceName fiObjectDescription ~
edForeignFields coDataSources coUpdateTargets coNavTarget ~
toResizeHorizontal toResizeVertical raLCR coLink edSource edTarget ~
fiObjectInstances fiForeignFieldLabel fiJustification fiQuickLink 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */
&Scoped-define ADM-ASSIGN-FIELDS buProperties buLayoutObjects coDataSources ~
coUpdateTargets coNavTarget buNonLayoutObjects coLink buOldProperties ~
buSwap buSource buTarget buAdd buCancel buCancelCoC buCopy buCut buDelete ~
buPaste buSaveLink 
&Scoped-define List-2 fiInstanceName fiObjectDescription buCancel 
&Scoped-define List-3 buProperties buSource buTarget buAdd 
&Scoped-define List-5 buAdd buCancelCoC buDelete buPaste 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD areSameAlignment vTableWin 
FUNCTION areSameAlignment RETURNS LOGICAL
  (phSourceObject AS HANDLE,
   phTargetObject AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD areWidgetsOnSameRow vTableWin 
FUNCTION areWidgetsOnSameRow RETURNS LOGICAL
  (phSourceObject AS HANDLE,
   phTargetObject AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD checkInstanceName vTableWin 
FUNCTION checkInstanceName RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD clearFields vTableWin 
FUNCTION clearFields RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD clearGrid vTableWin 
FUNCTION clearGrid RETURNS LOGICAL
  (pdObjectInstanceObj AS DECIMAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD clearLinkObject vTableWin 
FUNCTION clearLinkObject RETURNS LOGICAL
  (cSourceTarget      AS CHARACTER,
   dObjectInstanceObj AS DECIMAL) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cropWidgets vTableWin 
FUNCTION cropWidgets RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD evaluateActions vTableWin 
FUNCTION evaluateActions RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD evaluateFFButton vTableWin 
FUNCTION evaluateFFButton RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD evaluateJustification vTableWin 
FUNCTION evaluateJustification RETURNS LOGICAL
  (phWidget         AS HANDLE,
   piRow            AS INTEGER,
   pcJustification  AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD evaluateLookupQuery vTableWin 
FUNCTION evaluateLookupQuery RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD evaluateRadioSet vTableWin 
FUNCTION evaluateRadioSet RETURNS LOGICAL
  (BUFFER ttWidget FOR ttWidget)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD formatFFieldValue vTableWin 
FUNCTION formatFFieldValue RETURNS CHARACTER
  (pcForeignFieldValue  AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentPrefs vTableWin 
FUNCTION getCurrentPrefs RETURNS CHARACTER
  (plCurrentValues  AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInstanceComplete vTableWin 
FUNCTION getInstanceComplete RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLayoutCode vTableWin 
FUNCTION getLayoutCode RETURNS CHARACTER
  (plGetSwappedObject AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNumObjsOnRow vTableWin 
FUNCTION getNumObjsOnRow RETURNS INTEGER
  (piRow  AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPageString vTableWin 
FUNCTION getPageString RETURNS CHARACTER
  (plInclude  AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRecordComplete vTableWin 
FUNCTION getRecordComplete RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSelectedWidget vTableWin 
FUNCTION getSelectedWidget RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWidgetHandle vTableWin 
FUNCTION getWidgetHandle RETURNS HANDLE
  (phObject AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD positionButton vTableWin 
FUNCTION positionButton RETURNS LOGICAL
  (phButton AS HANDLE,
   phSource AS HANDLE,
   plBelow  AS LOGICAL) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD quickLinkSensitivity vTableWin 
FUNCTION quickLinkSensitivity RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD removePopupMenu vTableWin 
FUNCTION removePopupMenu RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD removeTargets vTableWin 
FUNCTION removeTargets RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD repositionToObject vTableWin 
FUNCTION repositionToObject RETURNS LOGICAL
  (pcObjectString AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAttribute vTableWin 
FUNCTION setAttribute RETURNS LOGICAL
  (pcAttribute AS CHARACTER,
   pcValue     AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLinkObject vTableWin 
FUNCTION setLinkObject RETURNS LOGICAL
  (pcSourceTarget      AS CHARACTER,
   pcObjectName        AS CHARACTER,
   pcObjectType        AS CHARACTER,
   pdObjectInstanceObj AS DECIMAL,
   piPage              AS INTEGER,
   piColumn            AS INTEGER,
   piRow               AS INTEGER,
   plVisibleObject     AS LOGICAL) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSelectedWidget vTableWin 
FUNCTION setSelectedWidget RETURNS LOGICAL
  (phWidget AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setWidgetProperties vTableWin 
FUNCTION setWidgetProperties RETURNS LOGICAL
  (phWidget AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setWidgetSensitivity vTableWin 
FUNCTION setWidgetSensitivity RETURNS LOGICAL
  (plWidgetAvailable  AS LOGICAL,
   plDisableExcluded  AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD showHighlights vTableWin 
FUNCTION showHighlights RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD showObjectDetails vTableWin 
FUNCTION showObjectDetails RETURNS LOGICAL
  (phSelectedWidget AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD showTargets vTableWin 
FUNCTION showTargets RETURNS LOGICAL
  (phSourceObject AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD swapSourceTarget vTableWin 
FUNCTION swapSourceTarget RETURNS LOGICAL
  (phSourceObject AS HANDLE,
   phTargetObject AS HANDLE,
   plPerformCrop  AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD updatePropertyValue vTableWin 
FUNCTION updatePropertyValue RETURNS LOGICAL
  (pcObject         AS CHARACTER,
   pcAttributeLabel AS CHARACTER,
   pcAttributeValue AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hObjectFilename AS HANDLE NO-UNDO.
DEFINE VARIABLE hObjectType AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buAdd 
     IMAGE-UP FILE "adeicon/new.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "New" 
     SIZE 4.8 BY 1.14 TOOLTIP "New"
     BGCOLOR 8 .

DEFINE BUTTON buCancel 
     IMAGE-UP FILE "ry/img/objectcancel.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "Cancel" 
     SIZE 4.8 BY 1.14 TOOLTIP "Cancel"
     BGCOLOR 8 .

DEFINE BUTTON buCancelCoC 
     IMAGE-UP FILE "ry/img/objectcancelcut.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "Cancel Cut/Copy" 
     SIZE 4.8 BY 1.14 TOOLTIP "Cancel Cut/Copy"
     BGCOLOR 8 .

DEFINE BUTTON buCopy 
     IMAGE-UP FILE "ry/img/objectcopy.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "Copy" 
     SIZE 4.8 BY 1.14 TOOLTIP "Copy"
     BGCOLOR 8 .

DEFINE BUTTON buCut 
     IMAGE-UP FILE "ry/img/objectcut.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "Cut" 
     SIZE 4.8 BY 1.14 TOOLTIP "Cut"
     BGCOLOR 8 .

DEFINE BUTTON buDelete 
     IMAGE-UP FILE "ry/img/objectdelete.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "Delete" 
     SIZE 4.8 BY 1.14 TOOLTIP "Delete"
     BGCOLOR 8 .

DEFINE BUTTON buLayoutObjects 
     IMAGE-UP FILE "ry/img/objects.gif":U
     IMAGE-INSENSITIVE FILE "ry/img/objectsselected.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 6.8 BY 1.62 TOOLTIP "Select to show all visual objects"
     BGCOLOR 8 .

DEFINE BUTTON buLayoutPreview  NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 6.4 BY 1.52
     BGCOLOR 8 .

DEFINE BUTTON buMapFields 
     LABEL "..." 
     SIZE 3.6 BY 1 TOOLTIP "Launch foreign field mapping window"
     BGCOLOR 8 .

DEFINE BUTTON buNonLayoutObjects 
     IMAGE-UP FILE "ry\img\bucket.gif":U
     IMAGE-INSENSITIVE FILE "ry/img/bucketselected.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 6.8 BY 1.62 TOOLTIP "Select to show all non-visual objects"
     BGCOLOR 8 .

DEFINE BUTTON buOldProperties 
     IMAGE-UP FILE "adeicon\props.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "Properties" 
     SIZE 4.8 BY 1.14 TOOLTIP "Object Properties"
     BGCOLOR 8 .

DEFINE BUTTON buPaste 
     IMAGE-UP FILE "ry\img\objectpaste.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "Paste" 
     SIZE 4.8 BY 1.14 TOOLTIP "Paste"
     BGCOLOR 8 .

DEFINE BUTTON buProperties 
     IMAGE-UP FILE "ry/img/properties.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "Properties" 
     SIZE 4.8 BY 1.14 TOOLTIP "Dynamic Properties"
     BGCOLOR 8 .

DEFINE BUTTON buReset 
     IMAGE-UP FILE "ry/img/objectundo.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "Cancel" 
     SIZE 4.8 BY 1.14 TOOLTIP "Reset (Object only)"
     BGCOLOR 8 .

DEFINE BUTTON buSaveLink 
     IMAGE-UP FILE "adeicon/save.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "Save" 
     SIZE 4.8 BY 1.14 TOOLTIP "Save the link"
     BGCOLOR 8 .

DEFINE BUTTON buSource  NO-FOCUS
     LABEL "Source:" 
     SIZE 8.4 BY .76 TOOLTIP "Set Source to 'THIS-OBJECT'"
     BGCOLOR 8 .

DEFINE BUTTON buSwap 
     IMAGE-UP FILE "ry/img/swap.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "Swap" 
     SIZE 33.2 BY .57 TOOLTIP "Swap the Source and the Target"
     BGCOLOR 8 .

DEFINE BUTTON buTarget  NO-FOCUS
     LABEL "Target:" 
     SIZE 8.4 BY .76 TOOLTIP "Set Target to 'THIS-OBJECT'"
     BGCOLOR 8 .

DEFINE VARIABLE coDataSources AS CHARACTER 
     LABEL "Data sources" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN
     SIZE 39.8 BY 1 TOOLTIP "Data Source Names" NO-UNDO.

DEFINE VARIABLE coLink AS CHARACTER 
     LABEL "Link" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN
     SIZE 33.6 BY 1 NO-UNDO.

DEFINE VARIABLE coNavTarget AS CHARACTER FORMAT "X(256)" 
     LABEL "Nav target" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 39.8 BY 1 TOOLTIP "Navigation Target Name" NO-UNDO.

DEFINE VARIABLE coUpdateTargets AS CHARACTER 
     LABEL "Update targets" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN
     SIZE 39.8 BY 1 TOOLTIP "Update Target Names" NO-UNDO.

DEFINE VARIABLE edForeignFields AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 39.8 BY 4.19 NO-UNDO.

DEFINE VARIABLE edSource AS CHARACTER 
     VIEW-AS EDITOR NO-BOX
     SIZE 35 BY 1.29
     FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE edTarget AS CHARACTER 
     VIEW-AS EDITOR NO-BOX
     SIZE 35 BY 1.29
     FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE fiForeignFieldLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Foreign fields:" 
      VIEW-AS TEXT 
     SIZE 13.2 BY .62 NO-UNDO.

DEFINE VARIABLE fiInstanceName AS CHARACTER FORMAT "X(35)":U 
     LABEL "Name" 
     VIEW-AS FILL-IN 
     SIZE 39.8 BY 1 TOOLTIP "Name for this instance of the object (cannot contain '.')" NO-UNDO.

DEFINE VARIABLE fiJustification AS CHARACTER FORMAT "X(256)":U INITIAL " Justification" 
      VIEW-AS TEXT 
     SIZE 12.8 BY .62 NO-UNDO.

DEFINE VARIABLE fiObjectDescription AS CHARACTER FORMAT "X(35)":U 
     LABEL "Description" 
     VIEW-AS FILL-IN 
     SIZE 39.8 BY 1 NO-UNDO.

DEFINE VARIABLE fiObjectInstances AS CHARACTER FORMAT "X(256)":U INITIAL "  Instance information:" 
      VIEW-AS TEXT 
     SIZE 61 BY .76
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiQuickLink AS CHARACTER FORMAT "X(256)":U INITIAL " Add quick-link" 
      VIEW-AS TEXT 
     SIZE 14.4 BY .62 NO-UNDO.

DEFINE VARIABLE raLCR AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Left", "L",
"Center", "C",
"Right", "R"
     SIZE 36.4 BY .71 NO-UNDO.

DEFINE RECTANGLE rctBackground
     EDGE-PIXELS 0    
     SIZE 60.8 BY 10.19
     BGCOLOR 7 .

DEFINE RECTANGLE rctGrid
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63.2 BY 10.76.

DEFINE RECTANGLE rctJustification
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39.8 BY 1.38.

DEFINE RECTANGLE rctProperties
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63.2 BY 11.33.

DEFINE RECTANGLE rctQuickLink
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 137.6 BY 1.81.

DEFINE RECTANGLE rctSeperator1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE .4 BY 1.14.

DEFINE RECTANGLE rctSeperator2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE .4 BY 1.14.

DEFINE RECTANGLE rctToolbar
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 5.6 BY 1.33.

DEFINE VARIABLE toResizeHorizontal AS LOGICAL INITIAL no 
     LABEL "Resize horizontal" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.8 BY .81 NO-UNDO.

DEFINE VARIABLE toResizeVertical AS LOGICAL INITIAL no 
     LABEL "Resize vertical" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.8 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buProperties AT ROW 12.33 COL 46.8
     buLayoutObjects AT ROW 1.29 COL 131.2
     fiInstanceName AT ROW 3.14 COL 16 COLON-ALIGNED
     fiObjectDescription AT ROW 4.19 COL 16 COLON-ALIGNED
     edForeignFields AT ROW 6.33 COL 18 NO-LABEL
     coDataSources AT ROW 6.33 COL 16 COLON-ALIGNED
     buMapFields AT ROW 6.38 COL 58.8
     coUpdateTargets AT ROW 7.38 COL 16 COLON-ALIGNED
     coNavTarget AT ROW 8.43 COL 16 COLON-ALIGNED
     toResizeHorizontal AT ROW 9.62 COL 18
     toResizeVertical AT ROW 9.62 COL 39.8
     buNonLayoutObjects AT ROW 3 COL 131.2
     raLCR AT ROW 11.19 COL 20.2 NO-LABEL
     coLink AT ROW 14 COL 51 COLON-ALIGNED
     buOldProperties AT ROW 12.33 COL 42
     edSource AT ROW 14.19 COL 12 NO-LABEL NO-TAB-STOP 
     edTarget AT ROW 14.19 COL 95.6 NO-LABEL NO-TAB-STOP 
     buSwap AT ROW 14.95 COL 53.4
     buSource AT ROW 14.14 COL 3.4
     buTarget AT ROW 14.14 COL 87
     buReset AT ROW 12.33 COL 11.4
     buAdd AT ROW 12.33 COL 1.8
     buCancel AT ROW 12.33 COL 16.2
     buCancelCoC AT ROW 12.33 COL 31.6
     buCopy AT ROW 12.33 COL 26.6
     buCut AT ROW 12.33 COL 21.6
     buDelete AT ROW 12.33 COL 6.6
     buPaste AT ROW 12.33 COL 36.4
     buSaveLink AT ROW 14.19 COL 132.6
     buLayoutPreview AT ROW 4.67 COL 131.2
     fiObjectInstances AT ROW 1.19 COL 2 NO-LABEL
     fiForeignFieldLabel AT ROW 6.52 COL 4.4 NO-LABEL
     fiJustification AT ROW 10.48 COL 17.2 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fiQuickLink AT ROW 13.52 COL 2.2 NO-LABEL
     rctSeperator2 AT ROW 12.24 COL 41.2
     rctToolbar AT ROW 1.1 COL 63
     rctJustification AT ROW 10.81 COL 17.8
     rctQuickLink AT ROW 13.86 COL 1
     rctProperties AT ROW 1 COL 1
     rctSeperator1 AT ROW 12.24 COL 21
     rctGrid AT ROW 1 COL 67
     rctBackground AT ROW 1.24 COL 68.2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS TOP-ONLY NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Compile into: ry/obj
   Data Source: "ry/obj/ryemptysdo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/ryemptysdo.i}
      END-FIELDS.
   END-TABLES.
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
  CREATE WINDOW vTableWin ASSIGN
         HEIGHT             = 14.67
         WIDTH              = 137.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB vTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW vTableWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:RESIZABLE        = TRUE.

/* SETTINGS FOR BUTTON buAdd IN FRAME frMain
   NO-ENABLE 1 3 5                                                      */
/* SETTINGS FOR BUTTON buCancel IN FRAME frMain
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR BUTTON buCancelCoC IN FRAME frMain
   NO-ENABLE 1 5                                                        */
/* SETTINGS FOR BUTTON buCopy IN FRAME frMain
   NO-ENABLE 1                                                          */
/* SETTINGS FOR BUTTON buCut IN FRAME frMain
   NO-ENABLE 1                                                          */
/* SETTINGS FOR BUTTON buDelete IN FRAME frMain
   NO-ENABLE 1 5                                                        */
/* SETTINGS FOR BUTTON buLayoutObjects IN FRAME frMain
   NO-ENABLE 1                                                          */
ASSIGN 
       buLayoutPreview:HIDDEN IN FRAME frMain           = TRUE
       buLayoutPreview:PRIVATE-DATA IN FRAME frMain     = 
                "ADM-ASSIGN & 3".

/* SETTINGS FOR BUTTON buMapFields IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buNonLayoutObjects IN FRAME frMain
   1                                                                    */
/* SETTINGS FOR BUTTON buOldProperties IN FRAME frMain
   NO-ENABLE 1                                                          */
/* SETTINGS FOR BUTTON buPaste IN FRAME frMain
   NO-ENABLE 1 5                                                        */
/* SETTINGS FOR BUTTON buProperties IN FRAME frMain
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR BUTTON buReset IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buSaveLink IN FRAME frMain
   NO-ENABLE 1                                                          */
/* SETTINGS FOR BUTTON buSource IN FRAME frMain
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR BUTTON buSwap IN FRAME frMain
   NO-ENABLE 1                                                          */
/* SETTINGS FOR BUTTON buTarget IN FRAME frMain
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR COMBO-BOX coDataSources IN FRAME frMain
   NO-ENABLE 1                                                          */
/* SETTINGS FOR COMBO-BOX coLink IN FRAME frMain
   NO-ENABLE 1                                                          */
/* SETTINGS FOR COMBO-BOX coNavTarget IN FRAME frMain
   NO-ENABLE 1                                                          */
/* SETTINGS FOR COMBO-BOX coUpdateTargets IN FRAME frMain
   NO-ENABLE 1                                                          */
/* SETTINGS FOR EDITOR edForeignFields IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       edForeignFields:RETURN-INSERTED IN FRAME frMain  = TRUE.

ASSIGN 
       edSource:RETURN-INSERTED IN FRAME frMain  = TRUE
       edSource:READ-ONLY IN FRAME frMain        = TRUE.

ASSIGN 
       edTarget:RETURN-INSERTED IN FRAME frMain  = TRUE
       edTarget:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN fiForeignFieldLabel IN FRAME frMain
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       fiForeignFieldLabel:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN fiInstanceName IN FRAME frMain
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fiJustification IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiObjectDescription IN FRAME frMain
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fiObjectInstances IN FRAME frMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiQuickLink IN FRAME frMain
   ALIGN-L                                                              */
/* SETTINGS FOR RADIO-SET raLCR IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctGrid IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctJustification IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctProperties IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctQuickLink IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctSeperator1 IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctSeperator2 IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctToolbar IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX toResizeHorizontal IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX toResizeVertical IN FRAME frMain
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

&Scoped-define SELF-NAME frMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frMain vTableWin
ON LEAVE OF FRAME frMain
DO:
  DYNAMIC-FUNCTION("checkInstanceName":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAdd vTableWin
ON CHOOSE OF buAdd IN FRAME frMain /* New */
DO:
  RUN addRecord.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCancel vTableWin
ON CHOOSE OF buCancel IN FRAME frMain /* Cancel */
DO:
  RUN cancelRecord.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCancelCoC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCancelCoC vTableWin
ON CHOOSE OF buCancelCoC IN FRAME frMain /* Cancel Cut/Copy */
DO:
  RUN trgMenuChoose (INPUT ?, "ClearCut":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCopy vTableWin
ON CHOOSE OF buCopy IN FRAME frMain /* Copy */
DO:
  RUN trgMenuChoose (INPUT DYNAMIC-FUNCTION("getSelectedWidget":U),
                     INPUT "Copy":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCut vTableWin
ON CHOOSE OF buCut IN FRAME frMain /* Cut */
DO:
  DEFINE VARIABLE hSelectedWidget AS HANDLE   NO-UNDO.
  
  hSelectedWidget = DYNAMIC-FUNCTION("getSelectedWidget":U).

  IF VALID-HANDLE(hSelectedWidget) THEN
    RUN trgMenuChoose (INPUT hSelectedWidget, "Cut":U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDelete vTableWin
ON CHOOSE OF buDelete IN FRAME frMain /* Delete */
DO:
  RUN deleteRecord.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buLayoutObjects
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buLayoutObjects vTableWin
ON CHOOSE OF buLayoutObjects IN FRAME frMain
DO:
  IF {fnarg getUserProperty 'ObjectView'} = "LayoutObjects":U THEN
    RETURN NO-APPLY.
  
  {fnarg lockWindow TRUE ghContainerSource}.
  {fnarg setUserProperty "'ObjectView', 'LayoutObjects'"}.
  {fn    evaluateLookupQuery}.

  RUN setupPageObjects (INPUT 0.00).

  ASSIGN
      coUpdateTargets:HIDDEN       = FALSE
      coDataSources:HIDDEN         = FALSE
      coNavTarget:HIDDEN           = FALSE
      toResizeHorizontal:HIDDEN    = FALSE
      toResizeVertical:HIDDEN      = FALSE
      rctJustification:HIDDEN      = FALSE
      fiJustification:HIDDEN       = FALSE
      edForeignFields:HIDDEN       = TRUE
      fiForeignFieldLabel:HIDDEN   = TRUE
      raLCR:HIDDEN                 = FALSE
      buLayoutObjects:SENSITIVE    = FALSE
      buNonLayoutObjects:SENSITIVE = TRUE
      .
  DYNAMIC-FUNCTION("evaluateFFButton":U).

  {fnarg lockWindow FALSE ghContainerSource}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buLayoutPreview
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buLayoutPreview vTableWin
ON CHOOSE OF buLayoutPreview IN FRAME frMain
DO:
  IF DYNAMIC-FUNCTION("getUserProperty":U, "ObjectView":U) = "LayoutPreview":U THEN
    RETURN.
  
  DYNAMIC-FUNCTION("setUserProperty":U, "ObjectView":U, "LayoutPreview":U).
  
  buLayoutObjects:LOAD-IMAGE("ry/img/objects.gif":U).
  buNonLayoutObjects:LOAD-IMAGE("ry/img/bucket.gif":U).
  /*buLayoutPreview:LOAD-IMAGE("ry/img/layoutpreviewselected.bmp":U).*/
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buMapFields
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buMapFields vTableWin
ON CHOOSE OF buMapFields IN FRAME frMain /* ... */
DO:
  RUN launchFFMapper IN ghContainerSource.
  
  PUBLISH "instanceSelected":U FROM ghContainerSource (INPUT ghObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buNonLayoutObjects
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buNonLayoutObjects vTableWin
ON CHOOSE OF buNonLayoutObjects IN FRAME frMain
DO:
  IF {fnarg getUserProperty 'ObjectView'} = "NonLayoutObjects":U THEN
    RETURN NO-APPLY.

  {fnarg lockWindow TRUE ghContainerSource}.
  {fnarg setUserProperty "'ObjectView', 'NonLayoutObjects'"}.
  {fn    evaluateLookupQuery}.

  RUN setupPageObjects (INPUT 0.00).

  ASSIGN
      coUpdateTargets:HIDDEN       = TRUE
      coDataSources:HIDDEN         = TRUE
      coNavTarget:HIDDEN           = TRUE
      toResizeHorizontal:HIDDEN    = TRUE
      toResizeVertical:HIDDEN      = TRUE
      rctJustification:HIDDEN      = TRUE
      fiJustification:HIDDEN       = TRUE
      edForeignFields:HIDDEN       = FALSE
      fiForeignFieldLabel:HIDDEN   = FALSE
      raLCR:HIDDEN                 = TRUE
      buLayoutObjects:SENSITIVE    = (IF {fnarg getUserProperty 'DataContainer' ghContainerSource} = "yes":U THEN FALSE ELSE TRUE)
      buNonLayoutObjects:SENSITIVE = FALSE
      .
  DYNAMIC-FUNCTION("evaluateFFButton":U).

  {fnarg lockWindow FALSE ghContainerSource}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOldProperties
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOldProperties vTableWin
ON CHOOSE OF buOldProperties IN FRAME frMain /* Properties */
DO:
  RUN oldPropertySheets IN ghContainerSource (INPUT ghObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buPaste
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buPaste vTableWin
ON CHOOSE OF buPaste IN FRAME frMain /* Paste */
DO:
  RUN pasteObject (INPUT DYNAMIC-FUNCTION("getSelectedWidget":U)).
/*  RUN newSave.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buProperties
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buProperties vTableWin
ON CHOOSE OF buProperties IN FRAME frMain /* Properties */
DO:
  RUN setProperties.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buReset
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buReset vTableWin
ON CHOOSE OF buReset IN FRAME frMain /* Cancel */
DO:
  DEFINE VARIABLE hLookupFillIn AS HANDLE     NO-UNDO.
  
  ASSIGN
      hLookupFillIn = {fn getLookupHandle hObjectFilename}
      hLookupFillIn:SCREEN-VALUE = ghObjectInstance:BUFFER-FIELD("c_smartobject_filename":U):BUFFER-VALUE.
      
  {set SavedScreenValue "ghObjectInstance:BUFFER-FIELD('c_smartobject_filename':U):BUFFER-VALUE" hObjectFilename}.
  {set DataValue        "ghObjectInstance:BUFFER-FIELD('d_smartobject_obj':U):BUFFER-VALUE"      hObjectFilename}.

  {fn evaluateActions ghContainerSource}.

  RUN newSave.

  buReset:SENSITIVE = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSaveLink
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSaveLink vTableWin
ON CHOOSE OF buSaveLink IN FRAME frMain /* Save */
DO:
  RUN addSpecifiedLink.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSource vTableWin
ON CHOOSE OF buSource IN FRAME frMain /* Source: */
DO:
  RUN setSourceTarget (INPUT ?,
                       INPUT "LSTO":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSwap
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSwap vTableWin
ON CHOOSE OF buSwap IN FRAME frMain /* Swap */
DO:
  RUN swapLinkObjects.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buTarget vTableWin
ON CHOOSE OF buTarget IN FRAME frMain /* Target: */
DO:
  RUN setSourceTarget (INPUT ?,
                       INPUT "LTTO":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coDataSources
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coDataSources vTableWin
ON VALUE-CHANGED OF coDataSources IN FRAME frMain /* Data sources */
DO:
  DYNAMIC-FUNCTION("setUserProperty":U, "DontDisplay":U, "No":U).

  DYNAMIC-FUNCTION("setAttribute":U, INPUT "DataSourceNames":U, coDataSources:SCREEN-VALUE).

  DYNAMIC-FUNCTION("setUserProperty":U, "DontDisplay":U, "Yes":U).

  ghInLookup = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coLink
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coLink vTableWin
ON VALUE-CHANGED OF coLink IN FRAME frMain /* Link */
DO:
  DYNAMIC-FUNCTION("quickLinkSensitivity":U).
  
  ghInLookup = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coNavTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coNavTarget vTableWin
ON VALUE-CHANGED OF coNavTarget IN FRAME frMain /* Nav target */
DO:
  DYNAMIC-FUNCTION("setUserProperty":U, "DontDisplay":U, "No":U).

  DYNAMIC-FUNCTION("setAttribute":U, INPUT "NavigationTargetName":U, coNavTarget:SCREEN-VALUE).

  DYNAMIC-FUNCTION("setUserProperty":U, "DontDisplay":U, "Yes":U).

  ghInLookup = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coUpdateTargets
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coUpdateTargets vTableWin
ON VALUE-CHANGED OF coUpdateTargets IN FRAME frMain /* Update targets */
DO:
  DYNAMIC-FUNCTION("setUserProperty":U, "DontDisplay":U, "No":U).

  DYNAMIC-FUNCTION("setAttribute":U, INPUT "UpdateTargetNames":U, coUpdateTargets:SCREEN-VALUE).

  DYNAMIC-FUNCTION("setUserProperty":U, "DontDisplay":U, "Yes":U).

  ghInLookup = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME edForeignFields
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL edForeignFields vTableWin
ON MOUSE-SELECT-CLICK OF edForeignFields IN FRAME frMain
DO:
  ghInLookup = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL edForeignFields vTableWin
ON VALUE-CHANGED OF edForeignFields IN FRAME frMain
DO:
  DYNAMIC-FUNCTION("setUserProperty":U, "DontDisplay":U, "No":U).

  ASSIGN
      edForeignFields
      ghObjectInstance:BUFFER-FIELD("c_foreign_fields":U):BUFFER-VALUE = REPLACE(edForeignFields:SCREEN-VALUE, "~n":U, ",":U).

  DYNAMIC-FUNCTION("setAttribute":U, INPUT "ForeignFields":U, REPLACE(TRIM(edForeignFields:SCREEN-VALUE, "~n":U), "~n":U, ",":U)).

  PUBLISH "instanceUpdated":U FROM ghContainerSource (INPUT ghObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE).

  DYNAMIC-FUNCTION("setUserProperty":U, "DontDisplay":U, "Yes":U).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiInstanceName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiInstanceName vTableWin
ON LEAVE OF fiInstanceName IN FRAME frMain /* Name */
DO:
  DYNAMIC-FUNCTION("checkInstanceName":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiInstanceName vTableWin
ON MOUSE-SELECT-CLICK OF fiInstanceName IN FRAME frMain /* Name */
DO:
  ghInLookup = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiInstanceName vTableWin
ON VALUE-CHANGED OF fiInstanceName IN FRAME frMain /* Name */
DO:
  DEFINE VARIABLE cCustomizationCode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCursorOffset       AS INTEGER    NO-UNDO.
  
  DYNAMIC-FUNCTION("setUserProperty":U, "DontDisplay":U, "No":U).

  ASSIGN
      fiInstanceName
      iCursorOffset      = fiInstanceName:CURSOR-OFFSET
      cCustomizationCode = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "CustomizationResultCode":U)

      ghObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE = fiInstanceName:SCREEN-VALUE.

  RUN newSave.

  DYNAMIC-FUNCTION("setUserProperty":U, "DontDisplay":U, "Yes":U).

  RUN changeObjectLabel IN ghProcLib (INPUT ghContainerSource,
                                      INPUT STRING(ghObjectInstance:BUFFER-FIELD("d_container_smartobject_obj":U):BUFFER-VALUE),
                                      INPUT STRING(ghObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE),
                                      INPUT fiInstanceName:SCREEN-VALUE).

  fiInstanceName:CURSOR-OFFSET = iCursorOffset.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiObjectDescription
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiObjectDescription vTableWin
ON MOUSE-SELECT-CLICK OF fiObjectDescription IN FRAME frMain /* Description */
DO:
  ghInLookup = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiObjectDescription vTableWin
ON VALUE-CHANGED OF fiObjectDescription IN FRAME frMain /* Description */
DO:
  ASSIGN fiObjectDescription.

  ghObjectInstance:BUFFER-FIELD("c_instance_description":U):BUFFER-VALUE = fiObjectDescription:SCREEN-VALUE.

  DYNAMIC-FUNCTION("setUserProperty":U, "DontDisplay":U, "No":U).
  
  RUN newSave.

  DYNAMIC-FUNCTION("setUserProperty":U, "DontDisplay":U, "Yes":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME raLCR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL raLCR vTableWin
ON VALUE-CHANGED OF raLCR IN FRAME frMain
DO:
  DEFINE VARIABLE hSelectedWidget AS HANDLE     NO-UNDO.

  ASSIGN
      raLCR

      hSelectedWidget = DYNAMIC-FUNCTION("getSelectedWidget":U).

  RUN trgMenuChoose (INPUT hSelectedWidget,
                     INPUT raLCR).

  ghInLookup = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toResizeHorizontal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toResizeHorizontal vTableWin
ON VALUE-CHANGED OF toResizeHorizontal IN FRAME frMain /* Resize horizontal */
DO:
  ASSIGN toResizeHorizontal.

  ghObjectInstance:BUFFER-FIELD("l_resize_horizontal":U):BUFFER-VALUE = toResizeHorizontal:CHECKED.

  DYNAMIC-FUNCTION("setAttribute":U, INPUT "ResizeHorizontal":U, STRING(toResizeHorizontal:CHECKED)).

  ghInLookup = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toResizeVertical
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toResizeVertical vTableWin
ON VALUE-CHANGED OF toResizeVertical IN FRAME frMain /* Resize vertical */
DO:
  ASSIGN toResizeVertical.
  
  ghObjectInstance:BUFFER-FIELD("l_resize_vertical":U):BUFFER-VALUE = toResizeVertical:CHECKED.

  DYNAMIC-FUNCTION("setAttribute":U, INPUT "ResizeVertical":U, STRING(toResizeVertical:CHECKED)).

  ghInLookup = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/
  ON "MOUSE-MENU-DOWN":U OF FRAME {&FRAME-NAME} ANYWHERE 
  DO:
    DO WITH FRAME {&FRAME-NAME}:
      IF NOT (LAST-EVENT:Y <= rctBackGround:Y + rctBackground:HEIGHT-PIXELS AND
              LAST-EVENT:Y >= rctBackground:Y                              AND
              LAST-EVENT:X <= rctBackGround:X + rctBackground:WIDTH-PIXELS  AND
              LAST-EVENT:X >= rctBackground:X)                             THEN
        IF LOOKUP(SELF:TYPE, "FILL-IN,COMBO-BOX,EDITOR":U) <> 0 THEN
          ASSIGN
              ghSelf                         = SELF:HANDLE
              FRAME {&FRAME-NAME}:POPUP-MENU = ghEditPopupMenu[1].
        ELSE
          FRAME {&FRAME-NAME}:POPUP-MENU = ?.
    END.
  END.

  /* Refresh the entire container */
  ON "SHIFT-F5":U OF FRAME {&FRAME-NAME} ANYWHERE
  DO:
    PUBLISH "masterObjectModified":U FROM gshRepositoryManager (INPUT ?, "":U).
  END.

  /* Refresh the selected instance */
  ON "F5":U OF FRAME {&FRAME-NAME} ANYWHERE
  DO:
    PUBLISH "masterObjectModified":U FROM gshRepositoryManager (INPUT 0.00, "":U).
  END.

  /* Get the handle of the RepositoryDesignManager */
  ghDesignManager = {fnarg getManagerHandle 'RepositoryDesignManager'}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord vTableWin 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE httSmartObject          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hLookupFillIn           AS HANDLE     NO-UNDO.

  RUN trgMenuChoose (INPUT ?, "ClearCut":U).

  ghPreviousWidget = DYNAMIC-FUNCTION("getSelectedWidget":U).

  DYNAMIC-FUNCTION("setSelectedWidget":U, ?).
  DYNAMIC-FUNCTION("setUserProperty":U, "ContainerMode":U, "ADD":U).
  DYNAMIC-FUNCTION("showHighlights":U).
  DYNAMIC-FUNCTION("showTargets":U, ?).

  ASSIGN
      dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "CustomizationResultObj":U))
      httSmartObject          = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttSmartObject":U)).

  httSmartObject:FIND-FIRST("WHERE d_smartobject_obj <> 0 AND d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj)).

  ghObjectInstance:BUFFER-CREATE().

  DO WITH FRAME {&FRAME-NAME}:
    DYNAMIC-FUNCTION("clearFields":U).

    ASSIGN
        raLCR

        hLookupFillIn = DYNAMIC-FUNCTION("getLookupHandle":U IN hObjectFilename)

        ghObjectInstance:BUFFER-FIELD("d_container_smartobject_obj":U):BUFFER-VALUE = httSmartObject:BUFFER-FIELD("d_smartobject_obj":U):BUFFER-VALUE
        ghObjectInstance:BUFFER-FIELD("d_customization_result_obj":U):BUFFER-VALUE  = dCustomizationResultObj
        ghObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE       = DYNAMIC-FUNCTION("getTemporaryObj":U IN ghContainerSource)
        ghObjectInstance:BUFFER-FIELD("c_action":U):BUFFER-VALUE                    = "A":U
        ghObjectInstance:BUFFER-FIELD("c_lcr":U):BUFFER-VALUE                       = raLCR:SCREEN-VALUE.
  END.

  RUN newSave.

  APPLY "ENTRY":U TO hLookupFillIn.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addSpecifiedLink vTableWin 
PROCEDURE addSpecifiedLink :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLinkName         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReason           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dSmartLinkTypeObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lAllowAdd         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSuccess          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE httSmartLinkType  AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        coLink

        httSmartLinkType = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttSmartLinkType":U)).

        httSmartLinkType:FIND-FIRST("WHERE c_link_name = ":U + QUOTER(coLink:SCREEN-VALUE)) NO-ERROR.

        IF NOT httSmartLinkType:AVAILABLE THEN
          httSmartLinkType:FIND-FIRST("WHERE l_user_defined_link = TRUE":U) NO-ERROR.


    RUN addSmartLink IN ghContainerSource (INPUT  gdSourceObjectInstanceObj,
                                           INPUT  gdTargetObjectInstanceObj,
                                           INPUT  httSmartlinkType:BUFFER-FIELD("d_smartlink_type_obj":U):BUFFER-VALUE,
                                           INPUT  coLink:SCREEN-VALUE,
                                           INPUT  FALSE,
                                           OUTPUT lSuccess,
                                           OUTPUT cReason).

    IF lSuccess = FALSE THEN
    DO:
      ASSIGN
          cMessage = "The '" + TRIM(coLink:SCREEN-VALUE) + "' link "
                   + (IF lSuccess = TRUE THEN "was successfully " ELSE "could not be ")
                   + "added."
                   + (IF lSuccess = TRUE THEN "":U ELSE " ":U + cReason).
  
      RUN showMessages IN gshSessionManager (INPUT  cMessage,              /* message to display */
                                             INPUT  "INF":U,               /* error type         */
                                             INPUT  "&OK":U,               /* button list        */
                                             INPUT  "&OK":U,               /* default button     */ 
                                             INPUT  "&OK":U,               /* cancel button      */
                                             INPUT  "Quick-Link status":U, /* error window title */
                                             INPUT  YES,                   /* display if empty   */ 
                                             INPUT  THIS-PROCEDURE,        /* container handle   */ 
                                             OUTPUT cButton).              /* button pressed     */
    END.
    ELSE
      APPLY "VALUE-CHANGED":U TO coLink.
  END.
  
  {fn evaluateFFButton}.

  RUN evaluateSBOProperties IN TARGET-PROCEDURE (INPUT TRUE).
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects vTableWin  _ADM-CREATE-OBJECTS
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
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.smartobject_objFieldLabelObjectFieldTooltipPress F4 For LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK
                     WHERE LOOKUP(gsc_object_type.object_type_code, gsc_object_type.object_type_code) <> 0,
                     EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.object_type_obj      = gsc_object_type.object_type_obj
                     AND ryc_smartobject.customization_result_obj = 0
                     AND ryc_smartobject.generic_object = FALSE,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     AND [&FilterSet=|&EntityList=GSCPM,RYCSO]
                     BY ryc_smartobject.object_filename INDEXED-REPOSITIONQueryTablesgsc_object_type,ryc_smartobject,gsc_product_moduleBrowseFieldsryc_smartobject.object_filename,gsc_object_type.object_type_code,gsc_product_module.product_module_code,ryc_smartobject.object_description,ryc_smartobject.static_object,ryc_smartobject.template_smartobject,ryc_smartobject.container_objectBrowseFieldDataTypescharacter,character,character,character,logical,logical,logicalBrowseFieldFormatsX(70)|X(35)|X(35)|X(35)|YES/NO|YES/NO|YES/NORowsToBatch200BrowseTitleObject LookupViewerLinkedFieldsryc_smartobject.object_type_obj,ryc_smartobject.object_filename,ryc_smartobject.object_descriptionLinkedFieldDataTypesdecimal,character,characterLinkedFieldFormats->>>>>>>>>>>>>>>>>9.999999999,X(70),X(35)ViewerLinkedWidgetsdObjectTypeObj,?,?ColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldName<Local>DisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hObjectFilename ).
       RUN repositionObject IN hObjectFilename ( 2.10 , 18.00 ) NO-ERROR.
       RUN resizeObject IN hObjectFilename ( 1.00 , 44.60 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_object_type.object_type_codeKeyFieldgsc_object_type.object_type_objFieldLabelTypeFieldTooltipSelect option from listKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(15)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCKQueryTablesgsc_object_typeSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1ComboDelimiterListItemPairsInnerLines5SortnoComboFlagNFlagValue0BuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesUseCacheyesSuperProcedureDataSourceNameFieldNamedObjectTypeObjDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hObjectType ).
       RUN repositionObject IN hObjectType ( 5.24 , 18.00 ) NO-ERROR.
       RUN resizeObject IN hObjectType ( 1.05 , 39.80 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( hObjectType ,
             fiObjectDescription:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildLinkCombo vTableWin 
PROCEDURE buildLinkCombo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cScreenValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cListItems        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE httSmartLinkType  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery            AS HANDLE     NO-UNDO.

  httSmartLinkType = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttSmartLinkType":U)).

  CREATE QUERY hQuery.
  
  hQuery:SET-BUFFERS(httSmartLinkType).
  hQuery:QUERY-PREPARE("FOR EACH ttSmartLinkType BY ttSmartLinkType.c_link_name":U).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().
  
  DO WHILE NOT hQuery:QUERY-OFF-END:
    IF ({fnarg getUserProperty 'DataContainer' ghContainerSource}    = "yes":U    AND
        (httSmartLinkType:BUFFER-FIELD("c_link_name":U):BUFFER-VALUE = "Data":U)) OR
        {fnarg getUserProperty 'DataContainer' ghContainerSource}   <> "yes":U    THEN
      ASSIGN
          cListItems = cListItems + (IF cListItems = "":U THEN "":U ELSE CHR(3))
                     + httSmartLinkType:BUFFER-FIELD("c_link_name":U):BUFFER-VALUE
                     + (IF httSmartLinkType:BUFFER-FIELD("l_user_defined_link":U):BUFFER-VALUE THEN " *":U ELSE "":U).

    hQuery:GET-NEXT().
  END.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        cScreenValue      = coLink:SCREEN-VALUE
        cListItems        = "":U + CHR(3) + cListItems
        coLink:DELIMITER  = CHR(3)
        coLink:LIST-ITEMS = cListItems.

    IF {fnarg getUserProperty 'ContainerMode' ghContainerSource} = "FIND":U THEN
      cScreenValue = "":U.

    IF cScreenValue <> ? THEN
      IF LOOKUP(cScreenValue, cListItems, CHR(3)) <> 0 THEN
        coLink:SCREEN-VALUE = cScreenValue.
  END.

  DELETE OBJECT hQuery.
  hQuery = ?.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRecord vTableWin 
PROCEDURE cancelRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cParentContainerMode  AS CHARACTER  NO-UNDO.

  ghObjectInstance:BUFFER-DELETE().

  glComplete = TRUE.
  
  DYNAMIC-FUNCTION("setSelectedWidget":U, DYNAMIC-FUNCTION("getWidgetHandle":U, INPUT ghPreviousWidget)).
  DYNAMIC-FUNCTION("setUserProperty":U, "ContainerMode":U, "MODIFY":U).
/*  DYNAMIC-FUNCTION("showObjectDetails":U, ghPreviousWidget).*/
  DYNAMIC-FUNCTION("evaluateActions":U).
  DYNAMIC-FUNCTION("showHighlights":U).
  DYNAMIC-FUNCTION("removeTargets":U).
  DYNAMIC-FUNCTION("restoreToolbarContext":U IN ghContainerSource).    
  DYNAMIC-FUNCTION("setWidgetSensitivity":U, FALSE, TRUE).
  DYNAMIC-FUNCTION("enablePagesInFolder":U IN ghContainerSource, DYNAMIC-FUNCTION("getPageString":U, TRUE)).

  APPLY "VALUE-CHANGED":U TO coLink IN FRAME {&FRAME-NAME}.

  cParentContainerMode = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U).
/*
  IF cParentContainerMode <> "UPDATE":U AND
     cParentContainerMode <> "ADD":U    THEN
  DO:
    DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "UPDATE":U).
    DYNAMIC-FUNCTION("evaluateActions":U IN ghContainerSource).
  END.
*/
  PUBLISH "enableViewerObjects":U FROM ghContainerSource (INPUT TRUE).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE containerTypeChange vTableWin 
PROCEDURE containerTypeChange :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER plDataContainer  AS LOGICAL    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    IF plDataContainer THEN
    DO:
      IF {fnarg getUserProperty 'ObjectView'} <> "NonLayoutObjects":U THEN
      DO:
        APPLY "CHOOSE":U TO buNonLayoutObjects.
      END.

      buLayoutObjects:SENSITIVE = FALSE.
    END.
    ELSE
      IF {fnarg getUserProperty 'ObjectView'} = "NonLayoutObjects":U THEN
        buLayoutObjects:SENSITIVE = TRUE.

    RUN buildLinkCombo.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createEditPopup vTableWin 
PROCEDURE createEditPopup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Create the popup menu and associated sub-menu items */
  CREATE MENU ghEditPopupMenu[1] IN WIDGET-POOL STRING(THIS-PROCEDURE)
    ASSIGN
        POPUP-ONLY = TRUE
    TRIGGERS:
      ON "MENU-DROP":U PERSISTENT RUN trgEditMenu  IN THIS-PROCEDURE (INPUT "MENU-DROP":U).
    END TRIGGERS.

  /* Menu Items */
  /* Undo */
  CREATE MENU-ITEM ghEditPopupMenu[2] IN WIDGET-POOL STRING(THIS-PROCEDURE)
    ASSIGN
        TOGGLE-BOX = FALSE
        PARENT     = ghEditPopupMenu[1]
        LABEL      = "&Undo":U
    TRIGGERS:
      ON "CHOOSE":U PERSISTENT RUN trgEditMenu  IN THIS-PROCEDURE (INPUT "UNDO":U).
    END TRIGGERS.

  /* ---------- */
  CREATE MENU-ITEM ghEditPopupMenu[3] IN WIDGET-POOL STRING(THIS-PROCEDURE)
    ASSIGN
        PARENT  = ghEditPopupMenu[1]
        SUBTYPE = "RULE":U.
  
  /* Cut */
  CREATE MENU-ITEM ghEditPopupMenu[4] IN WIDGET-POOL STRING(THIS-PROCEDURE)
    ASSIGN
        TOGGLE-BOX = FALSE
        PARENT     = ghEditPopupMenu[1]
        LABEL      = "Cu&t":U
    TRIGGERS:
      ON "CHOOSE":U PERSISTENT RUN trgEditMenu  IN THIS-PROCEDURE (INPUT "CUT":U).
    END TRIGGERS.

  /* Copy */
  CREATE MENU-ITEM ghEditPopupMenu[5] IN WIDGET-POOL STRING(THIS-PROCEDURE)
    ASSIGN
        TOGGLE-BOX = FALSE
        PARENT     = ghEditPopupMenu[1]
        LABEL      = "Copy":U
    TRIGGERS:
      ON "CHOOSE":U PERSISTENT RUN trgEditMenu  IN THIS-PROCEDURE (INPUT "COPY":U).
    END TRIGGERS.

  /* Paste */
  CREATE MENU-ITEM ghEditPopupMenu[6] IN WIDGET-POOL STRING(THIS-PROCEDURE)
    ASSIGN
        TOGGLE-BOX = FALSE
        PARENT     = ghEditPopupMenu[1]
        LABEL      = "&Paste":U
    TRIGGERS:
      ON "CHOOSE":U PERSISTENT RUN trgEditMenu  IN THIS-PROCEDURE (INPUT "PASTE":U).
    END TRIGGERS.

  /* Delete */
  CREATE MENU-ITEM ghEditPopupMenu[7] IN WIDGET-POOL STRING(THIS-PROCEDURE)
    ASSIGN
        TOGGLE-BOX = FALSE
        PARENT     = ghEditPopupMenu[1]
        LABEL      = "&Delete":U
    TRIGGERS:
      ON "CHOOSE":U PERSISTENT RUN trgEditMenu  IN THIS-PROCEDURE (INPUT "DELETE":U).
    END TRIGGERS.

  /* ---------- */
  CREATE MENU-ITEM ghEditPopupMenu[8] IN WIDGET-POOL STRING(THIS-PROCEDURE)
    ASSIGN
        PARENT  = ghEditPopupMenu[1]
        SUBTYPE = "RULE":U.

  /* Select All */
  CREATE MENU-ITEM ghEditPopupMenu[9] IN WIDGET-POOL STRING(THIS-PROCEDURE)
    ASSIGN
        TOGGLE-BOX = FALSE
        PARENT     = ghEditPopupMenu[1]
        LABEL      = "Select &All":U
    TRIGGERS:
      ON "CHOOSE":U PERSISTENT RUN trgEditMenu  IN THIS-PROCEDURE (INPUT "SELECT ALL":U).
    END TRIGGERS.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createGrid vTableWin 
PROCEDURE createGrid :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will create the rectangle widgets which appears
               on screen to aid users with layout code generation
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Define all local variables needed */
  DEFINE VARIABLE iPosition       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCounter        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRow            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCol            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hGridObject     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRectangle      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hAlignment      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hText           AS HANDLE     NO-UNDO.

  DEFINE BUFFER ttWidget FOR ttWidget.

  /* Create the grid lines */
  DO iCounter = 1 TO TRUNCATE(giNumRows / 2, 0) + 1:
    /* Rows */
    CREATE RECTANGLE ghGridRows[iCounter] IN WIDGET-POOL STRING(THIS-PROCEDURE)
    ASSIGN FRAME         = FRAME {&FRAME-NAME}:HANDLE
           GRAPHIC-EDGE  = FALSE
           EDGE-PIXELS   = 1
           SENSITIVE     = FALSE
           FGCOLOR       = giGLColor
         /*VISIBLE       = TRUE*/
           FILLED        = FALSE.
  END.
  
  DO iCounter = 1 TO TRUNCATE(giNumColumns / 2, 0) + 1:
    /* Columns */
    CREATE RECTANGLE ghGridColumns[iCounter] IN WIDGET-POOL STRING(THIS-PROCEDURE)
    ASSIGN FRAME         = FRAME {&FRAME-NAME}:HANDLE
           GRAPHIC-EDGE  = FALSE
           EDGE-PIXELS   = 1
           SENSITIVE     = FALSE
           FGCOLOR       = giGLColor
         /*VISIBLE       = TRUE*/
           FILLED        = FALSE.
  END.
  
  /* Create the recatangle widgets row by row */
  DO iRow = 1 TO giNumRows:
    DO iCol = 1 TO giNumColumns:
      /* Generate the text widgets used as headers for the rows and the columns */
      IF iRow = 1 OR iCol = 1 THEN
      /* If row and column are both 1 then we want to create 2 widgets - one for the row header and one for the column header */
      DO iCounter = 1 TO (IF iCol = iRow THEN 2 ELSE 1):
        CREATE TEXT hText IN WIDGET-POOL STRING(THIS-PROCEDURE)
        ASSIGN HEIGHT-PIXELS = 10
               WIDTH-PIXELS  = 33
             /*VISIBLE       = TRUE*/
               FGCOLOR       = 7
               FORMAT        = "x(10)":U
               FRAME         = FRAME {&FRAME-NAME}:HANDLE.
        
        ASSIGN
            iPosition                = iPosition + 1
            ghTextWidgets[iPosition] = hText.
      END.
      
      /* Create the grid objects */
      DO iCounter = 2 TO 1 BY -1:
        /* iCounter with value of 1 creates image for object type
           iCounter with value of 2 creates image for alignment */
        IF iCounter = 2 AND glCreateAlignment = FALSE THEN
          NEXT.

        CREATE IMAGE hGridObject IN WIDGET-POOL STRING(THIS-PROCEDURE)
        ASSIGN CONVERT-3D-COLORS = FALSE
               STRETCH-TO-FIT    = FALSE
               TRANSPARENT       = TRUE
               MOVABLE           = (IF iCounter = 1 THEN TRUE ELSE FALSE)
             /*VISIBLE           = (IF iRow <= giNumRows AND iCol <= giNumColumns THEN TRUE ELSE FALSE)*/
               HIDDEN            = (IF iRow <= giNumRows AND iCol <= giNumColumns THEN FALSE ELSE TRUE)
               TOOLTIP           = "":U
               FRAME             = FRAME {&FRAME-NAME}:HANDLE
               SENSITIVE         = FALSE
               NAME              = (IF iCounter = 1 THEN "Grid-R":U ELSE "Align-R":U) + STRING(iRow) + "-C":U + STRING(iCol)
        TRIGGERS:
          ON "MOUSE-SELECT-CLICK":U PERSISTENT RUN trgMouseSelectClick IN THIS-PROCEDURE (INPUT hGridObject).
          ON "MOUSE-MENU-DOWN":U    PERSISTENT RUN trgMouseMenuDown    IN THIS-PROCEDURE (INPUT hGridObject).
          ON "START-MOVE":U         PERSISTENT RUN trgStartMove        IN THIS-PROCEDURE (INPUT hGridObject).
          ON "END-MOVE":U           PERSISTENT RUN trgEndMove          IN THIS-PROCEDURE (INPUT hGridObject).
        END TRIGGERS.
        
        /*hGridObject:MOVE-TO-TOP().*/
        
        IF iCounter = 1 THEN
        DO:
          CREATE ttWidget.
          ASSIGN ttWidget.lAvailable = ?
                 ttWidget.hHandle    = hGridObject
                 ttWidget.iRow       = iRow
                 ttWidget.iCol       = iCol
                 ttWidget.hAlignment = hAlignment
                 hAlignment          = ?.
        END.
        ELSE
          hAlignment = hGridObject.
      END.
    END.
  END.

  /* Create the Selector Widget */
  CREATE RECTANGLE ghSourceSelector IN WIDGET-POOL STRING(THIS-PROCEDURE)
  ASSIGN FRAME         = FRAME {&FRAME-NAME}:HANDLE
         GRAPHIC-EDGE  = FALSE
         EDGE-PIXELS   = 1
         SENSITIVE     = TRUE
         FGCOLOR       = giSelectorColor
         HIDDEN        = TRUE
         FILLED        = FALSE.

  rctBackground:BGCOLOR IN FRAME {&FRAME-NAME} = giBGColor.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRecord vTableWin 
PROCEDURE deleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCustomizationResultCode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iNumPages                 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE httObjectInstance         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSelectedWidget           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httSmartObject            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httPage                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery                    AS HANDLE     NO-UNDO.

  DEFINE BUFFER ttWidget FOR ttWidget.

  ASSIGN
      cCustomizationResultCode = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "CustomizationResultCode":U)
      dCustomizationResultObj  = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "CustomizationResultObj":U))
      hSelectedWidget          = DYNAMIC-FUNCTION("getSelectedWidget":U)
      httObjectInstance        = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttObjectInstance":U))
      httSmartObject           = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttSmartObject":U))
      httPage                  = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttPage":U)).

  FIND FIRST ttWidget
       WHERE ttWidget.hHandle = hSelectedWidget.

  IF LOOKUP(ttWidget.cObjectType, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "SmartFolder":U)) > 0 THEN
  DO:
    CREATE QUERY hQuery.

    hQuery:SET-BUFFERS(httPage).
    hQuery:QUERY-PREPARE("FOR EACH ttPage":U
                         + " WHERE ttPage.d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj)
                         + "   AND ttPage.i_page_sequence           <> 0":U
                         + "   AND ttPage.c_action                  <> 'D'":U).
    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST().
    
    iNumPages = 0.

    DO WHILE NOT hQuery:QUERY-OFF-END:
      iNumPages = iNumPages + 1.
      
      hQuery:GET-NEXT().
    END.

    DELETE OBJECT hQuery.
    hQuery = ?.
    
    IF iNumPages > 0 THEN
    DO:
      cMessage = {aferrortxt.i 'AF' '101' '?' '?' "'the SmartFolder'" 'pages'}.

      RUN showMessages IN gshSessionManager (INPUT  cMessage,                        /* message to display */
                                             INPUT  "ERR",                           /* error type         */
                                             INPUT  "&OK",                           /* button list        */
                                             INPUT  "&OK",                           /* default button     */ 
                                             INPUT  "&OK",                           /* cancel button      */
                                             INPUT  "Cannot delete object instance", /* error window title */
                                             INPUT  YES,                             /* display if empty   */ 
                                             INPUT  ghContainerSource,               /* container handle   */ 
                                             OUTPUT cButton).
      RETURN.
    END.
  END.

  IF glConfirmDeletion = TRUE THEN
  DO:
    cMessage = "Are you sure you want to delete '":U + ghObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE + "'?":U.

    RUN askQuestion IN gshSessionManager ( INPUT cMessage,                    /* messages       */
                                           INPUT "&Yes,&No":U,                /* button list    */
                                           INPUT "&No":U,                     /* default        */
                                           INPUT "&No":U,                     /* cancel         */
                                           INPUT "Delete object instance":U,  /* title          */
                                           INPUT "":U,                        /* datatype       */
                                           INPUT "":U,                        /* format         */
                                           INPUT-OUTPUT cButton,              /* answer         */
                                           OUTPUT cButton).                   /* button pressed */
    
    IF cButton = "&No":U THEN
      RETURN.
  END.

  httObjectInstance:FIND-FIRST("WHERE ttObjectInstance.d_object_instance_obj = ":U + QUOTER(ttWidget.dObjectInstanceObj)
                              + " AND ttObjectInstance.c_action             <> 'D'":U).

  httObjectInstance:FIND-FIRST("WHERE ttObjectInstance.d_object_instance_obj = ":U + QUOTER(ttWidget.dObjectInstanceObj)
                              + " AND ttObjectInstance.c_action             <> 'D'":U).

  httObjectInstance:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "D":U.

  RUN unregisterPSObjects IN ghContainerSource (INPUT STRING(httObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE)).

  PUBLISH "refreshData":U FROM ghContainerSource (INPUT "NewData":U, INPUT 0.00).

  DYNAMIC-FUNCTION("clearLinkObject":U, "SOURCE":U, httObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE).
  DYNAMIC-FUNCTION("clearLinkObject":U, "TARGET":U, httObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE).

  RUN setupPageObjects (INPUT httObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE) /*(INPUT 0.00)*/ .
  
  IF DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U) <> "UPDATE":U AND
     DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U) <> "ADD":U    THEN
  DO:
    DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "UPDATE":U).
    DYNAMIC-FUNCTION("evaluateActions":U IN ghContainerSource).
  END.

  httSmartObject:FIND-FIRST("WHERE d_smartobject_obj <> 0 AND d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj)).

  FIND FIRST ttWidget
       WHERE ttWidget.lAvailable = FALSE NO-ERROR.

  IF AVAILABLE ttWidget THEN
  DO:
    httObjectInstance:FIND-FIRST("WHERE ttObjectInstance.d_object_instance_obj = ":U + QUOTER(ttWidget.dObjectInstanceObj)
                                + " AND ttObjectInstance.c_action             <> 'D'":U).

    DYNAMIC-FUNCTION("setSelectedWidget":U, ttWidget.hHandle).

    /* Reposition the property sheet */
    IF VALID-HANDLE(ghProcLib) THEN
      RUN displayProperties IN ghProcLib (INPUT ghContainerSource,
                                          INPUT httSmartObject:BUFFER-FIELD("d_smartobject_obj":U):BUFFER-VALUE,
                                          INPUT httObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE,
                                          INPUT cCustomizationResultCode,
                                          INPUT TRUE,
                                          INPUT 0).
  END.
  ELSE
  DO:
    DYNAMIC-FUNCTION("setSelectedWidget":U, ?).

    /* Reposition the property sheet */
    IF VALID-HANDLE(ghProcLib) THEN
      RUN displayProperties IN ghProcLib (INPUT ghContainerSource,
                                          INPUT httSmartObject:BUFFER-FIELD("c_object_filename":U):BUFFER-VALUE,
                                          INPUT "":U,
                                          INPUT cCustomizationResultCode,
                                          INPUT TRUE,
                                          INPUT 0).
  END.

  DYNAMIC-FUNCTION("cropWidgets":U).
  DYNAMIC-FUNCTION("showHighlights":U).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject vTableWin 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE iCounter  AS INTEGER    NO-UNDO.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  /* Delete the grid lines */
  DO iCounter = 1 TO EXTENT(ghGridColumns):
    IF VALID-HANDLE(ghGridColumns[iCounter]) THEN
      DELETE OBJECT ghGridColumns[iCounter].
  END.

  DO iCounter = 1 TO EXTENT(ghGridRows):
    IF VALID-HANDLE(ghGridRows[iCounter]) THEN
      DELETE OBJECT ghGridRows[iCounter].
  END.

  /* Delete the Edit PopupMenu */
  DO iCounter = 1 TO EXTENT(ghEditPopupMenu):
    IF VALID-HANDLE(ghEditPopupMenu[iCounter]) THEN
      DELETE OBJECT ghEditPopupMenu[iCounter].
  END.

  /* Delete the image widgets */
  FOR EACH ttWidget:
    IF VALID-HANDLE(ttWidget.hHandle) THEN
      DELETE OBJECT ttWidget.hHandle.

    IF VALID-HANDLE(ttWidget.hAlignment) THEN
      DELETE OBJECT ttWidget.hAlignment.
  END.
  
  /* Delete the Selector Widgets */
  IF VALID-HANDLE(ghSourceSelector) THEN
    DELETE OBJECT ghSourceSelector.

  /* Delete the local buffer for the object instance record */
  IF VALID-HANDLE(ghObjectInstance) THEN
    DELETE OBJECT ghObjectInstance.

  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI vTableWin  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE editInAppBuilder vTableWin 
PROCEDURE editInAppBuilder :
/*------------------------------------------------------------------------------
  Purpose:   Opens an object in the AppBuilder
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcWhatToOpen AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cObjectFilename AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dSmartObjectObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hDataObject     AS HANDLE     NO-UNDO.

  DEFINE BUFFER ttWidget FOR ttWidget.

  CASE pcWhatToOpen:
    WHEN "DataLogicProcedure":U THEN
      cObjectFilename = {fnarg getAttributeValue "ghObjectInstance:BUFFER-FIELD('d_object_instance_obj':U):BUFFER-VALUE, 'DataLogicProcedure':U" ghContainerSource}.

    WHEN "SuperProcedure":U THEN
      cObjectFilename = {fnarg getAttributeValue "ghObjectInstance:BUFFER-FIELD('d_object_instance_obj':U):BUFFER-VALUE, 'SuperProcedure':U" ghContainerSource}.

    WHEN "Master":U THEN
      cObjectFilename = ghObjectInstance:BUFFER-FIELD("c_smartobject_filename":U):BUFFER-VALUE.
  END CASE.

  IF cObjectFilename = "":U AND NOT ghObjectInstance:BUFFER-FIELD('l_visible_object':U):BUFFER-VALUE THEN
  DO:
    RUN clearClientCache IN gshRepositoryManager NO-ERROR.
    RUN startDataObject  IN gshRepositoryManager (INPUT  ghObjectInstance:BUFFER-FIELD('c_smartobject_filename':U):BUFFER-VALUE,
                                                  OUTPUT hDataObject) NO-ERROR.

    IF VALID-HANDLE(hDataObject) THEN
    DO:
      IF pcWhatToOpen = "DataLogicProcedure":U THEN
        {get DataLogicProcedure cObjectFilename hDataObject}.
      ELSE
        {get SuperProcedure     cObjectFilename hDataObject}.

      RUN destroyObject IN hDataObject.
    END.
  END.

  IF cObjectFilename <> "":U OR dSmartObjectObj <> 0 THEN
    RUN editRyObjectInAB IN ghDesignManager (INPUT cObjectFilename,
                                             INPUT dSmartObjectObj).
  ELSE
    MESSAGE "Unable to open the ":U + pcWhatToOpen + "... This might be due to the instance being replaced with another instance. Please save the current container to ":U
            + "refresh the information and try again.":U VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE evaluateSBOProperties vTableWin 
PROCEDURE evaluateSBOProperties :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER plDoSBOCheck   AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cContainedInstances   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSBOClassChildren     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOClassChildren     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUpdateTargetSBO      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSourceSBO        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNavTargetSBO         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSBOsToStart          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttributes           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabels               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dGASourceInstanceObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dObjectInstanceObj    AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iCounter              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lSDONavigationTarget  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSDOUpdateTarget      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSDODataSource        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSuccess              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lButton               AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE httObjectInstance     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httObjectType         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httSmartLink          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSBO                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lValidDataSource      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lValidUpdateTarget    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lValidNavTarget       AS LOGICAL    NO-UNDO.

  dObjectInstanceObj = ghObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE.
   
 /* An instance Obj less than zero implies a customization was added and has not yet been saved. The links
    should be ignored in this situation  */
  IF dObjectInstanceObj < 0 THEN
  DO:
     RUN getInstanceFromCustom IN ghContainerSource (INPUT-OUTPUT  dObjectInstanceObj).
     
  END.     

  ASSIGN
      cSBOClassChildren  = {fnarg getClassChildrenFromDB 'SBO'  gshRepositoryManager}
      cSDOClassChildren  = {fnarg getClassChildrenFromDB 'Data' gshRepositoryManager}
      cSDOClassChildren  = REPLACE(cSDOClassChildren, CHR(3), ",":U)
      httObjectType      = WIDGET-HANDLE({fnarg getUserProperty 'ttObjectType' ghContainerSource})
      httSmartLink       = WIDGET-HANDLE({fnarg getUserProperty 'ttSmartLink'  ghContainerSource}).

  CREATE BUFFER httObjectInstance FOR TABLE ghObjectInstance.
  CREATE BUFFER httObjectType     FOR TABLE httObjectType.
  CREATE BUFFER httSmartLink      FOR TABLE httSmartLink.
  CREATE QUERY  hQuery.

  hQuery:SET-BUFFERS(httSmartLink, httObjectInstance, httObjectType).

  /* Check the if there is a DataSource and if it is an SBO */
  hQuery:QUERY-PREPARE("FOR EACH ttSmartLink":U
                       + " WHERE ttSmartLink.d_target_object_instance_obj = ":U + QUOTER(dObjectInstanceObj)
                       + "   AND ttSmartLink.c_link_name                  = 'Data'":U
                       + "   AND ttSmartLink.c_action                    <> 'D',":U
                       + " FIRST ttObjectInstance":U
                       + " WHERE ttObjectInstance.d_object_instance_obj = ttSmartLink.d_source_object_instance_obj,":U
                       + " FIRST ttObjectType":U
                       + " WHERE ttObjectType.d_object_type_obj = ttObjectInstance.d_object_type_obj":U).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().

  DO WHILE NOT hQuery:QUERY-OFF-END:
    IF LOOKUP(httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE, cSBOClassChildren) <> 0 THEN
      cDataSourceSBO = httObjectInstance:BUFFER-FIELD("c_smartobject_filename":U):BUFFER-VALUE.
    ELSE
      lSDODataSource = (LOOKUP(httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE, cSDOClassChildren) <> 0).
    
    ASSIGN lValidDataSource = true.
    hQuery:GET-NEXT().
  END.

  /* Check the if there is a UpdateTarget and if it is an SBO */
  hQuery:QUERY-CLOSE().
  hQuery:QUERY-PREPARE("FOR EACH ttSmartLink":U
                       + " WHERE ttSmartLink.d_source_object_instance_obj = ":U + QUOTER(dObjectInstanceObj)
                       + "   AND ttSmartLink.c_link_name                  = 'Update'":U
                       + "   AND ttSmartLink.c_action                    <> 'D',":U
                       + " FIRST ttObjectInstance":U
                       + " WHERE ttObjectInstance.d_object_instance_obj = ttSmartLink.d_target_object_instance_obj,":U
                       + " FIRST ttObjectType":U
                       + " WHERE ttObjectType.d_object_type_obj = ttObjectInstance.d_object_type_obj":U).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().

  DO WHILE NOT hQuery:QUERY-OFF-END:
    IF LOOKUP(httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE, cSBOClassChildren) <> 0 THEN
      cUpdateTargetSBO = httObjectInstance:BUFFER-FIELD("c_smartobject_filename":U):BUFFER-VALUE.
    ELSE
      lSDOUpdateTarget = (LOOKUP(httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE, cSDOClassChildren) <> 0).

    ASSIGN lValidUpdateTarget = true.
    hQuery:GET-NEXT().
  END.

  /* ------------------------------------------------- GroupAssign ------------------------------------------------- */
  /* If the current object instance has no update targets, just check if it is not part of a group-assign */
  IF cUpdateTargetSBO = "":U THEN
  DO:
    httSmartLink:FIND-FIRST(" WHERE d_target_object_instance_obj = ":U + QUOTER(dObjectInstanceObj)
                            + " AND c_link_name                  = 'GroupAssign'":U
                            + " AND c_action                    <> 'D'":U) NO-ERROR.
    
    IF httSmartLink:AVAILABLE THEN
    DO:
      dGASourceInstanceObj = httSmartLink:BUFFER-FIELD("d_source_object_instance_obj":U):BUFFER-VALUE.

      /* Check the if there is a UpdateTarget and if it is an SBO */
      hQuery:QUERY-CLOSE().
      hQuery:QUERY-PREPARE("FOR EACH ttSmartLink":U
                           + " WHERE ttSmartLink.d_source_object_instance_obj = ":U + QUOTER(dGASourceInstanceObj)
                           + "   AND ttSmartLink.c_link_name                  = 'Update'":U
                           + "   AND ttSmartLink.c_action                    <> 'D',":U
                           + " FIRST ttObjectInstance":U
                           + " WHERE ttObjectInstance.d_object_instance_obj = ttSmartLink.d_target_object_instance_obj,":U
                           + " FIRST ttObjectType":U
                           + " WHERE ttObjectType.d_object_type_obj = ttObjectInstance.d_object_type_obj":U).
      hQuery:QUERY-OPEN().
      hQuery:GET-FIRST().

      DO WHILE NOT hQuery:QUERY-OFF-END:
        IF LOOKUP(httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE, cSBOClassChildren) <> 0 THEN
          cUpdateTargetSBO = httObjectInstance:BUFFER-FIELD("c_smartobject_filename":U):BUFFER-VALUE.
        
        ASSIGN lValidUpdateTarget = TRUE.  
        hQuery:GET-NEXT().
      END.
    END.
  END.
  /* ----------------------------------------------- End GroupAssign ----------------------------------------------- */

  /* Check the if there is a NavigationTarget and if it is an SBO */
  hQuery:QUERY-CLOSE().
  hQuery:QUERY-PREPARE("FOR EACH ttSmartLink":U
                       + " WHERE ttSmartLink.d_source_object_instance_obj = ":U + QUOTER(dObjectInstanceObj)
                       + "   AND ttSmartLink.c_link_name                  = 'Navigation'":U
                       + "   AND ttSmartLink.c_action                    <> 'D',":U
                       + " FIRST ttObjectInstance":U
                       + " WHERE ttObjectInstance.d_object_instance_obj = ttSmartLink.d_target_object_instance_obj,":U
                       + " FIRST ttObjectType":U
                       + " WHERE ttObjectType.d_object_type_obj = ttObjectInstance.d_object_type_obj":U).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().

  DO WHILE NOT hQuery:QUERY-OFF-END:
    IF LOOKUP(httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE, cSBOClassChildren) <> 0 THEN
      cNavTargetSBO = httObjectInstance:BUFFER-FIELD("c_smartobject_filename":U):BUFFER-VALUE.
    ELSE
      lSDONavigationTarget = (LOOKUP(httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE, cSDOClassChildren) <> 0).
    
    ASSIGN lValidNavTarget = TRUE. 
    hQuery:GET-NEXT().
  END.

  IF plDoSBOCheck THEN
  DO:
    /* Now get a unique list of SBOs to start. This way, we will not start the same SBO twice if it is the DataSource, the UpdateTarget or the NavTarget */
    cSBOsToStart = cDataSourceSBO.

    IF cUpdateTargetSBO <> "":U AND LOOKUP(cUpdateTargetSBO, cSBOsToStart) = 0 THEN
      cSBOsToStart = cSBOsToStart + (IF cSBOsToStart = "":U THEN "":U ELSE ",":U)
                   + cUpdateTargetSBO.

    IF cNavTargetSBO <> "":U AND LOOKUP(cNavTargetSBO, cSBOsToStart) = 0 THEN
      cSBOsToStart = cSBOsToStart + (IF cSBOsToStart = "":U THEN "":U ELSE ",":U)
                   + cNavTargetSBO.

    /* Now start the SBOs and get the contained instances */
    DO iCounter = 1 TO NUM-ENTRIES(cSBOsToStart):
      RUN startDataObject IN gshRepositoryManager (INPUT ENTRY(iCounter, cSBOsToStart), OUTPUT hSBO).

      IF VALID-HANDLE(hSBO) THEN
      DO:
        cContainedInstances = cContainedInstances + (IF iCounter = 1 THEN "":U ELSE CHR(1))
                            + REPLACE({fn getDataObjectNames hSBO}, ",":U, CHR(3)).

        RUN destroyObject IN hSBO.
      END.
      ELSE
        cContainedInstances = cContainedInstances + (IF iCounter = 1 THEN "":U ELSE CHR(1))
                            + "< Could not Start SBO >":U.
    END.

    DELETE OBJECT httObjectInstance.
    DELETE OBJECT httSmartLink.
    DELETE OBJECT hQuery.
  END.

  DO WITH FRAME {&FRAME-NAME}:
    IF plDoSBOCheck THEN
    DO:
      /* Setup the DataSource combo */
      IF cDataSourceSBO <> "":U THEN
        ASSIGN
            coDataSources:LIST-ITEMS = ENTRY(LOOKUP(cDataSourceSBO, cSBOsToStart), cContainedInstances, CHR(1))
            coDataSources:SENSITIVE  = TRUE.
      ELSE
        ASSIGN
            coDataSources:LIST-ITEMS = "":U
            coDataSources:SENSITIVE  = FALSE.

      /* Setup the UpdateTarget combo */
      IF cUpdateTargetSBO <> "":U THEN
        ASSIGN
            coUpdateTargets:LIST-ITEMS = ENTRY(LOOKUP(cUpdateTargetSBO, cSBOsToStart), cContainedInstances, CHR(1))
            coUpdateTargets:SENSITIVE  = TRUE.
      ELSE 
        ASSIGN
            coUpdateTargets:LIST-ITEMS = "":U
            coUpdateTargets:SENSITIVE  = FALSE.

      /* Setup the NavigationTarget combo */
      IF cNavTargetSBO <> "":U THEN
        ASSIGN
            coNavTarget:LIST-ITEMS = coNavTarget:DELIMITER + ENTRY(LOOKUP(cNavTargetSBO, cSBOsToStart), cContainedInstances, CHR(1))
            coNavTarget:SENSITIVE  = TRUE.
      ELSE 
        ASSIGN
            coNavTarget:LIST-ITEMS = "":U
            coNavTarget:SENSITIVE  = FALSE.
    END.

    /* Display the values after we possibly cleared the list-item pairs */
    ASSIGN
        lSuccess = {fnarg displayAttribute "dObjectInstanceObj, 'NavigationTargetName':U, coNavTarget:HANDLE"     ghContainerSource}
        lSuccess = {fnarg displayAttribute "dObjectInstanceObj, 'UpdateTargetNames':U,    coUpdateTargets:HANDLE" ghContainerSource}
        lSuccess = {fnarg displayAttribute "dObjectInstanceObj, 'DataSourceNames':U,      coDataSources:HANDLE"   ghContainerSource}.

    ASSIGN
        cAttributes = "":U
        cLabels     = "":U.

    /* Check if the properties should not be assigned anymore */
    IF coDataSources:SCREEN-VALUE <> "":U  AND
       coDataSources:SCREEN-VALUE <> ?     AND
       coDataSources:SENSITIVE     = FALSE AND
       lSDODataSource              = FALSE AND 
       lValidDataSource                   THEN
      ASSIGN
          cAttributes = cAttributes + (IF cLabels = "":U THEN "":U ELSE ",":U)  + "DataSourceNames":U
          cLabels    = cLabels      + (IF cLabels = "":U THEN "":U ELSE ", ":U) + coDataSources:SIDE-LABEL-HANDLE:SCREEN-VALUE.

    IF coUpdateTargets:SCREEN-VALUE <> "":U  AND
       coUpdateTargets:SCREEN-VALUE <> ?     AND
       coUpdateTargets:SENSITIVE     = FALSE AND
       lSDOUpdateTarget              = FALSE AND 
       lValidUpdateTarget                   THEN
      ASSIGN
          cAttributes = cAttributes + (IF cLabels = "":U THEN "":U ELSE ",":U)  + "UpdateTargetNames":U
          cLabels     = cLabels     + (IF cLabels = "":U THEN "":U ELSE ", ":U) + coUpdateTargets:SIDE-LABEL-HANDLE:SCREEN-VALUE.

    IF coNavTarget:SCREEN-VALUE <> "":U  AND
       coNavTarget:SCREEN-VALUE <> ?     AND
       coNavTarget:SENSITIVE     = FALSE AND
       lSDONavigationTarget      = FALSE AND 
       lValidNavTarget                  THEN
      ASSIGN
          cAttributes = cAttributes + (IF cLabels = "":U THEN "":U ELSE ",":U)  + "NavigationTargetName":U
          cLabels     = cLabels     + (IF cLabels = "":U THEN "":U ELSE ", ":U) + coNavTarget:SIDE-LABEL-HANDLE:SCREEN-VALUE.

    IF cLabels <> "":U THEN
    DO:
      /* I had to use MESSAGE because of an input blocking statment */
      MESSAGE SUBSTITUTE ("The attribute value(s) ('&1') have become invalid.~n~n"
                        + "Select 'Yes' to clear the value(s) or 'No' to leave the value(s) as they are and fix the cause of the problem.", cLabels)
              VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE lButton.

      IF lButton THEN
      DO:
        DO iCounter = 1 TO NUM-ENTRIES(cAttributes):
          /* Reuse the cLabels variable */

          cLabels = ENTRY(iCounter, cAttributes).

          /* Clear the attribute */
          {fnarg setUserProperty "'DontDisplay':U, 'No':U"}.
          {fnarg setAttribute    "cLabels,         '':U"}.
          {fnarg setUserProperty "'DontDisplay':U, 'Yes':U"}.

          /* This is the only way to clear the displayed value */
          CASE cLabels:
            WHEN "DataSourceNames":U      THEN coDataSources:LIST-ITEMS   = coDataSources:LIST-ITEMS.
            WHEN "UpdateTargetNames":U    THEN coUpdateTargets:LIST-ITEMS = coUpdateTargets:LIST-ITEMS.
            WHEN "NavigationTargetName":U THEN coNavTarget:LIST-ITEMS     = coNavTarget:LIST-ITEMS.
          END CASE.
        END.
      END.
    END.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject vTableWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DYNAMIC-FUNCTION("removePopupMenu":U).

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getObjectDetails vTableWin 
PROCEDURE getObjectDetails :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE httObjectInstance AS HANDLE     NO-UNDO.

  httObjectInstance = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttObjectInstance":U)).

  httObjectInstance:FIND-FIRST("WHERE ttObjectInstance.c_action <> 'D'":U).

  IF NOT httObjectInstance:AVAILABLE THEN
  DO:
    EMPTY TEMP-TABLE ttSelectedWidget.

    DYNAMIC-FUNCTION("clearGrid":U, 0.00).
    DYNAMIC-FUNCTION("showObjectDetails":U, ?).
  END.
  
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE hideObject vTableWin 
PROCEDURE hideObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /*RUN SUPER.*/

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {get ContainerSource ghContainerSource}.

  SUBSCRIBE TO "masterObjectModified":U IN gshRepositoryManager.
  SUBSCRIBE TO "containerTypeChange":U  IN ghContainerSource.
  SUBSCRIBE TO "lookupComplete":U       IN THIS-PROCEDURE.
  SUBSCRIBE TO "lookupEntry":U          IN THIS-PROCEDURE.
  SUBSCRIBE TO "objectLocated":U        IN ghContainerSource.

  DYNAMIC-FUNCTION("setUserProperty":U, "ContainerMode":U, "":U).    /* Set this property - it is needed, even if it is blank */
  DYNAMIC-FUNCTION("setUserProperty":U, "CoCMode":U,       "Off":U). /* Set this property - it needs to be 'Off' by default / startup */

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        fiForeignFieldLabel:SCREEN-VALUE = "Foreign fields:"
        fiJustification:SCREEN-VALUE     = " Justification"
        gcDefaultValues                  = DYNAMIC-FUNCTION("getCurrentPrefs":U, INPUT TRUE)
        coDataSources:DELIMITER          = CHR(3)
        coUpdateTargets:DELIMITER        = CHR(3)
        coNavTarget:DELIMITER            = CHR(3).
  END.
      
  RUN processProfileData (INPUT FALSE).
  RUN createGrid.

  RUN SUPER.

  RUN displayFields (INPUT ?).
  RUN disableField IN hObjectFilename. 
  
  /* Code placed here will execute AFTER standard behavior.    */
  RUN adjustTabOrder (hObjectFileName, fiInstanceName:HANDLE IN FRAME {&FRAME-NAME} , 'BEFORE':U).
  RUN createEditPopup.

  APPLY "CHOOSE":U TO buLayoutObjects IN FRAME {&FRAME-NAME}.

  RUN resizeObject (FRAME {&FRAME-NAME}:HEIGHT-CHARS, FRAME {&FRAME-NAME}:WIDTH-CHARS).
  
  /* Launch the PropertySheet procedure library */  
  IF NOT VALID-HANDLE(ghProcLib) THEN
  DO:
    /* See if the Property Sheet procedure library is already running */
    ghProcLib = SESSION:FIRST-PROCEDURE.
    DO WHILE VALID-HANDLE(ghProcLib) AND ghProcLib:FILE-NAME NE "ry/prc/ryvobplipp.p":U:
      ghProcLib = ghProcLib:NEXT-SIBLING.
    END.

    /* If the procedure library is not running, start it persistantly */
    IF NOT VALID-HANDLE(ghProcLib) THEN
      RUN ry/prc/ryvobplipp.p PERSISTENT SET ghProcLib NO-ERROR.    
  END.

  DEFINE VARIABLE hHandle AS HANDLE     NO-UNDO.
  {get lookupHandle hHandle hObjectFilename}. ON "VALUE-CHANGED":U                OF hHandle PERSISTENT RUN trgLookupValueChanged IN THIS-PROCEDURE (INPUT hObjectFilename).
                                              ON "RETURN":U OF hHandle OR "TAB":U OF hHandle PERSISTENT RUN leaveLookup           IN hObjectFilename.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lookupComplete vTableWin 
PROCEDURE lookupComplete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcColumnNames   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcColumnValues  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcKeyFieldValue AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcNewValue      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcOldValue      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plWhere         AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER phLookup        AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cObjectDescription  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectFilename     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContainerMode      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lRepointAttributes  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lObjectTypeDiff     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE dOldSmartObjectObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dSmartObjectObj     AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dObjectTypeObj      AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hSelectedWidget     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httObjectType       AS HANDLE     NO-UNDO.

  DEFINE BUFFER ttWidget FOR ttWidget.

  IF NUM-ENTRIES(pcColumnValues, CHR(1)) >= LOOKUP("ryc_smartobject.object_type_obj":U, pcColumnNames) THEN
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        cObjectDescription = ENTRY(LOOKUP("ryc_smartobject.object_description":U, pcColumnNames), pcColumnValues, CHR(1))
        cObjectFilename    = ENTRY(LOOKUP("ryc_smartobject.object_filename":U, pcColumnNames), pcColumnValues, CHR(1))
        cContainerMode     = DYNAMIC-FUNCTION("getUserProperty":U, "ContainerMode":U)
        dSmartObjectObj    = DYNAMIC-FUNCTION("getDataValue":U IN hObjectFilename)
        httObjectType      = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttObjectType":U))
        lRepointAttributes = FALSE
        dObjectTypeObj     = DECIMAL(ENTRY(LOOKUP("ryc_smartobject.object_type_obj":U, pcColumnNames), pcColumnValues, CHR(1))).

    DYNAMIC-FUNCTION("setDataValue":U IN hObjectType, STRING(dObjectTypeObj)).

    httObjectType:FIND-FIRST("WHERE d_object_type_obj = ":U + QUOTER(dObjectTypeObj)).

    /* Check if it is necessary to move the attributes accross to the new SmartObject - if the SmartObject was changed */
    IF dSmartObjectObj <> ghObjectInstance:BUFFER-FIELD("d_smartobject_obj":U):BUFFER-VALUE THEN
      ASSIGN
          dOldSmartObjectObj = ghObjectInstance:BUFFER-FIELD("d_smartobject_obj":U):BUFFER-VALUE
          lRepointAttributes = TRUE
          lObjectTypeDiff    = NOT (dObjectTypeObj = ghObjectInstance:BUFFER-FIELD("d_object_type_obj":U):BUFFER-VALUE).
    
    ASSIGN
        ghObjectInstance:BUFFER-FIELD("c_smartobject_filename":U):BUFFER-VALUE   = cObjectFilename
        ghObjectInstance:BUFFER-FIELD("c_instance_description":U):BUFFER-VALUE   = cObjectDescription
        ghObjectInstance:BUFFER-FIELD("d_smartobject_obj":U):BUFFER-VALUE        = dSmartObjectObj
        ghObjectInstance:BUFFER-FIELD("d_object_type_obj":U):BUFFER-VALUE        = dObjectTypeObj
        ghObjectInstance:BUFFER-FIELD("l_visible_object":U):BUFFER-VALUE         = {fnarg isVisibleObjectType "httObjectType:BUFFER-FIELD('c_object_type_code'):BUFFER-VALUE" ghContainerSource}
        ghObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE          = cObjectFilename
        fiObjectDescription:SCREEN-VALUE                                         = cObjectDescription
        fiInstanceName:SCREEN-VALUE                                              = cObjectFilename.

    APPLY "LEAVE":U TO fiInstanceName.
    
    buReset:SENSITIVE = FALSE.
  END.

  RUN newSave.

  IF cContainerMode <> "ADD":U THEN
    IF lRepointAttributes = TRUE THEN
    DO:
      RUN repointAttributes IN ghContainerSource (INPUT ghObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE,
                                                  INPUT dOldSmartObjectObj,
                                                  INPUT dSmartObjectObj,
                                                  INPUT dObjectTypeObj).

      IF lObjectTypeDiff = TRUE THEN
      DO:
        /* Find the selected widget so that the image could be updated because the object type changed */
        hSelectedWidget = DYNAMIC-FUNCTION("getSelectedWidget":U).

        FIND FIRST ttWidget
             WHERE ttWidget.hHandle = hSelectedWidget.

        ASSIGN
            ttWidget.cObject     = ghObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE
            ttWidget.cObjectType = httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE.

        DYNAMIC-FUNCTION("setWidgetProperties":U, hSelectedWidget).

        /* Finally inform the user that attributes might be lost because of the resultant change in object type */
        cMessage = "You replaced the object with an object of a different type. This may cause a potential loss of attribute ":U
                 + "values if the attributes of the old object are not supported by the new object." + CHR(10) + CHR(10)
                 + "Possible invalid attributes will only be deleted when the container is saved.":U.

        RUN showMessages IN gshSessionManager (INPUT  cMessage,                                 /* message to display */
                                               INPUT  "INF":U,                                  /* error type         */
                                               INPUT  "&OK":U,                                  /* button list        */
                                               INPUT  "&OK":U,                                  /* default button     */ 
                                               INPUT  "&OK":U,                                  /* cancel button      */
                                               INPUT  "Replacing objects of different type":U,  /* error window title */
                                               INPUT  YES,                                      /* display if empty   */ 
                                               INPUT  THIS-PROCEDURE,                           /* container handle   */ 
                                               OUTPUT cButton).                                 /* button pressed     */
      END.
    END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lookupEntry vTableWin 
PROCEDURE lookupEntry :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcScreenValue  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phField        AS HANDLE     NO-UNDO.

  ghInLookup = {fn getLookupHandle phField}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE masterObjectModified vTableWin 
PROCEDURE masterObjectModified :
/*------------------------------------------------------------------------------
  Purpose:  To force tools to refresh their instances of a smartobject if its master has changed
  
  Parameters:  INPUT pdSmartObjectObj      - SmartObject to refresh.
                                             If null (?) is passed in, refresh all SmartObjects on the container.
                                             If zero (0) is passed in, refresh the currently selected instance
               INPUT pcSmartObjectFilename - Name of the smartObject to refresh
  
  Notes:  Both SmartObjectObj and SmartObjectFilename are supplied because certain
          tools might require one or the other - here we will just use the SmartobjectObj
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdSmartObjectObj       AS  DECIMAL   NO-UNDO.
  DEFINE INPUT PARAMETER pcSmartObjectFilename  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cQuery            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dSmartObjectObj   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lForceReFetch     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hObjectInstance   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery            AS HANDLE     NO-UNDO.

  /* If a zero is passed in, then we would like to force a refresh of the selected instance. If none is selected, return */
  IF pdSmartObjectObj = 0.00 THEN
    IF ghObjectInstance:AVAILABLE THEN
      pdSmartObjectObj = ghObjectInstance:BUFFER-FIELD("d_smartobject_obj":U):BUFFER-VALUE.
    ELSE
      RETURN.

  /* If we are in the middle of editing, we cannot refresh until we are done */
  IF NOT glComplete THEN
  DO:
    gdRefreshPending = pdSmartObjectObj.
    
    RETURN.
  END.

  /* Now we need to unregister all instances of the same smartobject and reregister them to reflect the values of the new master */
  CREATE BUFFER hObjectInstance FOR TABLE ghObjectInstance.
  CREATE QUERY  hQuery.

  /* Setup the query string */
  ASSIGN
      dCustomizationObj = DECIMAL({fnarg getUserProperty 'CustomizationResultObj':U ghContainerSource})
      dCustomizationObj = (IF dCustomizationObj = ? THEN 0.00 ELSE dCustomizationObj)

      cQuery = "FOR EACH &1 ":U
             + (IF pdSmartObjectObj  = ?    THEN "":U ELSE "WHERE &1.d_smartobject_obj = ":U + QUOTER(pdSmartObjectObj))
             + (IF dCustomizationObj = 0.00 THEN "":U ELSE "  AND &1.d_customization_result_obj = ":U + QUOTER(dCustomizationObj))
             + " BY &1.d_smartobject_obj INDEXED-REPOSITION":U
      cQuery = SUBSTITUTE(cQuery, hObjectInstance:NAME).

  /* Prepare the query */
  hQuery:SET-BUFFERS(hObjectInstance).
  hQuery:QUERY-PREPARE(cQuery).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().
  
  /* Clear the variable */
  dSmartObjectObj = 0.00.

  DO WHILE NOT hQuery:QUERY-OFF-END:
    /* Determine if we need to force a refetch of the master values for a specific smartobject */
    IF dSmartObjectObj <> hObjectInstance:BUFFER-FIELD("d_smartobject_obj":U):BUFFER-VALUE THEN
      ASSIGN
          dSmartObjectObj = hObjectInstance:BUFFER-FIELD("d_smartobject_obj":U):BUFFER-VALUE
          lForceRefetch   = TRUE.
    ELSE
      lForceRefetch = FALSE.

    /* Fetch the master values (if required) and update the denormalized attributes on the instances */
    RUN getMasterValues IN ghContainerSource (INPUT hObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE,
                                              INPUT lForceRefetch).

    /* If pdSmartObjectObj was specified, then we would only need to reregister the instances of the
       specified smartobject, so make the call */
    IF pdSmartObjectObj <> ? THEN
    DO:
      /* Unregister the object instance */
      RUN unregisterPSObjects IN ghContainerSource (hObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE).

      /* Register the object instance again to take cognisance of the new master values */
      RUN registerPSObjects   IN ghContainerSource (hObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE).
    END.

    hQuery:GET-NEXT().
  END.

  /* If pdSmartObjectObj was not specified, then we would need to reregister ALL the instances on the container.
     Doing it this way might be slightly more efficient */
  IF pdSmartObjectObj = ? THEN
  DO:
    /* Unregister ALL the object instances */
    RUN unregisterPSObjects IN ghContainerSource (INPUT "":U).

    /* Register ALL the object instances again to take cognisance of the new master values */
    RUN registerPSObjects   IN ghContainerSource (INPUT "":U).
  END.

  /* Force a redisplay of the selected object instance. We will not be able to get here if we were not
     allowed to force a refresh, so raise the flag that prevents displaying */
  {fnarg setUserProperty "'DontDisplay':U, 'Yes':U}.
  {fn    showHighlights}.

  /* Clean up the objects we used */
  DELETE OBJECT hObjectInstance.
  DELETE OBJECT hQuery.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE newSave vTableWin 
PROCEDURE newSave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cParentContainerMode      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContainerMode            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectView               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dSmartObjectObj           AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iCurrentPage              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSelectedWidget           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httObjectType             AS HANDLE     NO-UNDO.

  DEFINE BUFFER ttWidget FOR ttWidget.
  
  IF NOT {fn getObjectInitialized ghContainerSource} THEN
    RETURN.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "CustomizationResultObj":U))
        cParentContainerMode    = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U)
        cContainerMode          = DYNAMIC-FUNCTION("getUserProperty":U, "ContainerMode":U)
        httObjectType           = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttObjectType":U))
        hSelectedWidget         = DYNAMIC-FUNCTION("getSelectedWidget":U)
        dSmartObjectObj         = DYNAMIC-FUNCTION("getDataValue":U    IN hObjectFileName)
        iCurrentPage            = DYNAMIC-FUNCTION("getPageSequence":U IN ghContainerSource, ?).

    /* Determine the validity of the object */
    IF ghObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE   = "":U OR
       ghObjectInstance:BUFFER-FIELD("d_smartobject_obj":U):BUFFER-VALUE = 0.00 OR
       ghObjectInstance:BUFFER-FIELD("d_smartobject_obj":U):BUFFER-VALUE = ?    OR
       hSelectedWidget                                                   = ?    OR
       DYNAMIC-FUNCTION("getDataValue":U IN hObjectFilename)             = 0.00 THEN
    DO:
      glComplete = FALSE.

      /* If we reach this point, all details required for the object instance has not been specified. Disable all objects */
      DYNAMIC-FUNCTION("setWidgetSensitivity":U, TRUE, TRUE).
      DYNAMIC-FUNCTION("disablePagesInFolder":U IN ghContainerSource, DYNAMIC-FUNCTION("getPageString":U, FALSE)).

      PUBLISH "enableViewerObjects":U FROM ghContainerSource (INPUT FALSE).
      DYNAMIC-FUNCTION("disableEnabledActions":U IN ghContainerSource).

      DYNAMIC-FUNCTION("setUserProperty":U, "ContainerMode":U, (IF cContainerMode = "ADD":U THEN "ADD":U ELSE "UPDATE":U)).
      DYNAMIC-FUNCTION("evaluateActions":U).

      DYNAMIC-FUNCTION("setStatusDefault":U IN ghContainerSource, "Ensure a valid object, name and grid reference is specified...").
      
      RETURN.
    END.
    ELSE
      IF glComplete = FALSE THEN
      DO:
        IF cContainerMode = "ADD":U THEN
        DO:
          FIND FIRST ttWidget
               WHERE ttWidget.iRow = INTEGER(ghObjectInstance:BUFFER-FIELD("i_row":U):BUFFER-VALUE)
                 AND ttWidget.iCol = INTEGER(ghObjectInstance:BUFFER-FIELD("i_column":U):BUFFER-VALUE) NO-ERROR.

          IF AVAILABLE ttWidget THEN
          DO:
            httObjectType:FIND-FIRST("WHERE d_object_type_obj = ":U + QUOTER(ghObjectInstance:BUFFER-FIELD("d_object_type_obj":U):BUFFER-VALUE)).

            ASSIGN
                cObjectView = DYNAMIC-FUNCTION("getUserProperty":U, "ObjectView":U)

                ttWidget.dObjectInstanceObj = ghObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE
                ttWidget.cLCR               = (IF cObjectView = "NonLayoutObjects":U THEN "L":U ELSE ghObjectInstance:BUFFER-FIELD("c_lcr":U):BUFFER-VALUE)
                ttWidget.cObject            = ghObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE
                ttWidget.cObjectType        = httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE
                ttWidget.lAvailable         = FALSE

                ghObjectInstance:BUFFER-FIELD("i_row":U):BUFFER-VALUE             = ttWidget.iRow
                ghObjectInstance:BUFFER-FIELD("i_column":U):BUFFER-VALUE          = ttWidget.iCol
                ghObjectInstance:BUFFER-FIELD("i_page":U):BUFFER-VALUE            = iCurrentPage
                ghObjectInstance:BUFFER-FIELD("c_layout_position":U):BUFFER-VALUE = DYNAMIC-FUNCTION("getLayoutCode":U, FALSE).

            DYNAMIC-FUNCTION("setWidgetProperties":U, ttWidget.hHandle).
            DYNAMIC-FUNCTION("removeTargets":U).
          END.

          RUN autoLinkInstance  IN ghContainerSource (INPUT ghObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE).
          RUN getMasterValues   IN ghContainerSource (INPUT ghObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE, INPUT FALSE).
          RUN registerPSObjects IN ghContainerSource (INPUT STRING(ghObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE)).

          PUBLISH "refreshData":U FROM ghContainerSource (INPUT "NewData":U, INPUT 0.00).

        END.

        ASSIGN
            cContainerMode = "MODIFY":U
            glComplete     = TRUE.

        /* If we reach this point, all details required for the object instance has been specified. Enable the objects again */
        DYNAMIC-FUNCTION("setWidgetSensitivity":U, FALSE, TRUE).
        DYNAMIC-FUNCTION("enablePagesInFolder":U IN ghContainerSource, DYNAMIC-FUNCTION("getPageString":U, TRUE)).

        PUBLISH "enableViewerObjects":U FROM ghContainerSource (INPUT TRUE).
        DYNAMIC-FUNCTION("restoreToolbarContext":U IN ghContainerSource).    

        DYNAMIC-FUNCTION("setUserProperty":U, "ContainerMode":U, "MODIFY":U).
        DYNAMIC-FUNCTION("evaluateActions":U).

        DYNAMIC-FUNCTION("setStatusDefault":U IN ghContainerSource, "":U).

        APPLY "VALUE-CHANGED":U TO coLink.
      END.

    IF ghObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE = gdSourceObjectInstanceObj THEN 
      RUN setSourceTarget (INPUT hSelectedWidget, INPUT "LS":U).

    IF ghObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE = gdTargetObjectInstanceObj THEN
      RUN setSourceTarget (INPUT hSelectedWidget, INPUT "LT":U).

    IF cParentContainerMode <> "UPDATE":U AND
       cParentContainerMode <> "ADD":U    AND
       cContainerMode       <> "ADD":U    THEN
    DO:
      DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "UPDATE":U).
      DYNAMIC-FUNCTION("evaluateActions":U IN ghContainerSource).
    END.

    IF ghObjectInstance:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "":U THEN
      ghObjectInstance:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "M":U.

    DYNAMIC-FUNCTION("showHighlights":U).

    PUBLISH "refreshData":U FROM ghContainerSource (INPUT "Updated":U, INPUT 0.00).

    /* If we need to apply preferences and we are in a state to do so, proceed */
    IF glPrefsPending AND glComplete THEN
    DO:
      RUN processProfileData (INPUT TRUE).

      glPrefsPending = FALSE.
    END.

    /* If we need to refresh smartobjects and we are in a state to do so, proceed */
    IF gdRefreshPending <> -1 AND glComplete THEN
    DO:
      RUN masterObjectModified (INPUT gdRefreshPending, "":U).

      /* We assign it a value of -1 as 0.00 and null have specific meaning */
      gdRefreshPending = -1.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectLocated vTableWin 
PROCEDURE objectLocated :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdObjectInstanceObj  AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE cObjectLocation   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE httObjectInstance AS HANDLE     NO-UNDO.

  httObjectInstance = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttObjectInstance":U)).

  CREATE BUFFER httObjectInstance FOR TABLE httObjectInstance.

  httObjectInstance:FIND-FIRST("WHERE d_object_instance_obj = ":U + QUOTER(pdObjectInstanceObj)).

  cObjectLocation = STRING(httObjectInstance:BUFFER-FIELD("i_page":U):BUFFER-VALUE + 1) + "|":U
                  + STRING(httObjectInstance:BUFFER-FIELD("i_row":U):BUFFER-VALUE) + "|":U
                  + STRING(httObjectInstance:BUFFER-FIELD("i_column":U):BUFFER-VALUE) + "|":U
                  + IF httObjectInstance:BUFFER-FIELD("l_visible_object":U):BUFFER-VALUE THEN "Y":U ELSE "N":U.

  DYNAMIC-FUNCTION("repositionToObject":U, cObjectLocation).

  DELETE OBJECT httObjectInstance.
  httObjectInstance = ?.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pasteObject vTableWin 
PROCEDURE pasteObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phWidget AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cCutOrCopyMode          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iCurrentPage            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE httObjectInstance       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httSmartObject          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httObjectType           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httPage                 AS HANDLE     NO-UNDO.

  DEFINE BUFFER bttWidget FOR ttWidget.
  DEFINE BUFFER ttWidget  FOR ttWidget.

  ASSIGN
      dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "CustomizationResultObj":U))
      cCutOrCopyMode          = DYNAMIC-FUNCTION("getUserProperty":U, "CoCMode":U)
      httObjectInstance       = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttObjectInstance":U))
      httSmartObject          = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttSmartObject":U))
      httObjectType           = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttObjectType":U))
      iCurrentPage            = DYNAMIC-FUNCTION("getPageSequence":U IN ghContainerSource, ?).

  ghObjectInstance:FIND-FIRST("WHERE d_object_instance_obj = ":U + QUOTER(gdCoCInstanceObj)) NO-ERROR.
  httSmartObject:FIND-FIRST("WHERE d_smartobject_obj <> 0 AND d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj)).
  
  IF ghObjectInstance:AVAILABLE THEN
    httObjectType:FIND-FIRST("WHERE d_object_type_obj = ":U + QUOTER(ghObjectInstance:BUFFER-FIELD("d_object_type_obj":U):BUFFER-VALUE)) NO-ERROR.

  FIND FIRST ttWidget
       WHERE ttWidget.hHandle = phWidget NO-ERROR.

  IF NOT (AVAILABLE ttWidget       AND
          httObjectType:AVAILABLE) THEN /* If the object type is available, that means the object instance was available */
    RETURN.

  DYNAMIC-FUNCTION("setSelectedWidget":U, phWidget).

  CASE cCutOrCopyMode:
    WHEN "Cut":U THEN
    DO:
      IF AVAILABLE ttWidget      AND
         httObjectType:AVAILABLE THEN /* If the object type is available, that means the object instance was available */
      DO:
        IF iCurrentPage = ghObjectInstance:BUFFER-FIELD("i_page":U):BUFFER-VALUE THEN
        DO:
          FIND FIRST bttWidget
               WHERE bttWidget.dObjectInstanceObj = gdCoCInstanceObj.

          DYNAMIC-FUNCTION("swapSourceTarget", bttWidget.hHandle, phWidget, TRUE).
        END.
        ELSE
        DO:
          ASSIGN
              raLCR:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ghObjectInstance:BUFFER-FIELD("c_lcr":U):BUFFER-VALUE

              ttWidget.dObjectInstanceObj = ghObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE
              ttWidget.cLCR               = ghObjectInstance:BUFFER-FIELD("c_lcr":U):BUFFER-VALUE
              ttWidget.cObject            = ghObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE
              ttWidget.cObjectType        = httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE
              ttWidget.lAvailable         = FALSE

              ghObjectInstance:BUFFER-FIELD("i_row":U):BUFFER-VALUE                       = ttWidget.iRow
              ghObjectInstance:BUFFER-FIELD("i_column":U):BUFFER-VALUE                    = ttWidget.iCol
              ghObjectInstance:BUFFER-FIELD("i_page":U):BUFFER-VALUE                      = iCurrentPage
              ghObjectInstance:BUFFER-FIELD("c_layout_position":U):BUFFER-VALUE           = DYNAMIC-FUNCTION("getLayoutCode":U, FALSE).

          RUN updatePageObject.
        END.
      END.
    END.

    WHEN "Copy":U THEN
    DO:
      CREATE BUFFER httObjectInstance FOR TABLE httObjectInstance.

      httObjectInstance:FIND-FIRST("WHERE d_object_instance_obj = ":U + QUOTER(gdCoCInstanceObj)).

      ghObjectInstance:BUFFER-CREATE().
      ghObjectInstance:BUFFER-COPY(httObjectInstance).

      ASSIGN
          raLCR:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ghObjectInstance:BUFFER-FIELD("c_lcr":U):BUFFER-VALUE

          ghObjectInstance:BUFFER-FIELD("d_container_smartobject_obj":U):BUFFER-VALUE = httSmartObject:BUFFER-FIELD("d_smartobject_obj":U):BUFFER-VALUE
          ghObjectInstance:BUFFER-FIELD("d_customization_result_obj":U):BUFFER-VALUE  = dCustomizationResultObj
          ghObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE       = DYNAMIC-FUNCTION("getTemporaryObj":U IN ghContainerSource)
          ghObjectInstance:BUFFER-FIELD("c_layout_position":U):BUFFER-VALUE           = DYNAMIC-FUNCTION("getLayoutCode":U, FALSE)
          ghObjectInstance:BUFFER-FIELD("c_action":U):BUFFER-VALUE                    = "A":U
          ghObjectInstance:BUFFER-FIELD("i_row":U):BUFFER-VALUE                       = ttWidget.iRow
          ghObjectInstance:BUFFER-FIELD("i_column":U):BUFFER-VALUE                    = ttWidget.iCol
          ghObjectInstance:BUFFER-FIELD("i_page":U):BUFFER-VALUE                      = iCurrentPage

          ttWidget.dObjectInstanceObj = ghObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE
          ttWidget.cLCR               = ghObjectInstance:BUFFER-FIELD("c_lcr":U):BUFFER-VALUE
          ttWidget.cObject            = ghObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE
          ttWidget.cObjectType        = httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE
          ttWidget.lAvailable         = FALSE.

      RUN updatePageObject.
      RUN copyInstanceAttributes IN ghContainerSource (INPUT gdCoCInstanceObj,
                                                       INPUT ghObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE).

      DELETE OBJECT httObjectInstance.
    END.
  END CASE.

  ghTargetObject = ?.

  DYNAMIC-FUNCTION("evaluateActions":U).
  DYNAMIC-FUNCTION("showHighlights":U).

  /* If we were copying, we need to ensure that we have a unique instance name */
  IF cCutOrCopyMode = "Copy":U THEN
  DO:
    DYNAMIC-FUNCTION("checkInstanceName":U).

    /* Register the object in the Property Sheet and notify subtools of the new object after we have received the new unique instance name */
    RUN registerPSObjects IN ghContainerSource (INPUT ghObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE).

    PUBLISH "refreshData":U FROM ghContainerSource (INPUT "NewData":U, INPUT 0.00).
  END.

  DYNAMIC-FUNCTION("setWidgetProperties":U, ttWidget.hHandle).

  DYNAMIC-FUNCTION("setUserProperty":U, "CoCMode":U, "Off":U).
  DYNAMIC-FUNCTION("removeTargets":U).

  ASSIGN
      gdCoCInstanceObj = 0.00
      glCoCVisible     = ?.

  RUN newSave.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE postCreateObjects vTableWin 
PROCEDURE postCreateObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  gcBaseQueryString = DYNAMIC-FUNCTION("getBaseQueryString":U IN hObjectFilename).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processProfileData vTableWin 
PROCEDURE processProfileData :
/*------------------------------------------------------------------------------
  Purpose:  Get the preference information for the grid and set the global variables
            to ensure preferences are taken into account. Refresh the grid if
            required.

  Parameters:  INPUT plRefresh - Should the grid be refreshed using the latest
                                 preferences

  Notes:  At initialization, this procedure will be called before any construction of
          widgets, etc., so refreshing would be pointless as certain objects would not
          exist yet. However, once running and changes are made to the preferences,
          we would want to refresh the grid.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER plRefresh  AS LOGICAL  NO-UNDO.

  DEFINE VARIABLE cStatusDefault  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPrefs          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEntry          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hGridObject     AS HANDLE     NO-UNDO.

  IF NOT glComplete THEN
  DO:
    glPrefsPending = TRUE.
    
    RETURN.
  END.
  
  DEFINE BUFFER ttWidget FOR ttWidget.

  /* Get the preference / profile data */
  cPrefs = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ProfileData":U).

  /* Process the preference data */
  /* --- Preference lookup ------------------------- */ /* --- Preference value assignment ------------------------------------------------------- */
  iEntry = LOOKUP("ConfirmDeletion":U,  cPrefs, "|":U). IF iEntry <> 0 THEN glConfirmDeletion  = (ENTRY(iEntry + 1, cPrefs, "|":U) = "yes":U).
  iEntry = LOOKUP("CreateAlignment":U,  cPrefs, "|":U). IF iEntry <> 0 THEN glCreateAlignment  = (ENTRY(iEntry + 1, cPrefs, "|":U) = "yes":U).
  iEntry = LOOKUP("ImageTransparent":U, cPrefs, "|":U). IF iEntry <> 0 THEN glImageTransparent = (ENTRY(iEntry + 1, cPrefs, "|":U) = "yes":U).
  iEntry = LOOKUP("CreateAlignment":U,  cPrefs, "|":U). IF iEntry <> 0 THEN glCreateAlignment  = (ENTRY(iEntry + 1, cPrefs, "|":U) = "yes":U).
  iEntry = LOOKUP("StretchToFit":U,     cPrefs, "|":U). IF iEntry <> 0 THEN glStretchToFit     = (ENTRY(iEntry + 1, cPrefs, "|":U) = "yes":U).
  iEntry = LOOKUP("TBTopOrLeft":U,      cPrefs, "|":U). IF iEntry <> 0 THEN glTBTopOrLeft      = (ENTRY(iEntry + 1, cPrefs, "|":U) = "yes":U).
  iEntry = LOOKUP("TBVertical":U,       cPrefs, "|":U). IF iEntry <> 0 THEN glTBVertical       = (ENTRY(iEntry + 1, cPrefs, "|":U) = "yes":U).
  iEntry = LOOKUP("TBToGrid":U,         cPrefs, "|":U). IF iEntry <> 0 THEN glTBToGrid         = (ENTRY(iEntry + 1, cPrefs, "|":U) = "yes":U).
  iEntry = LOOKUP("ReposCB":U,          cPrefs, "|":U). IF iEntry <> 0 THEN glReposCB          = (ENTRY(iEntry + 1, cPrefs, "|":U) = "yes":U).
  iEntry = LOOKUP("ReposPS":U,          cPrefs, "|":U). IF iEntry <> 0 THEN glReposPS          = (ENTRY(iEntry + 1, cPrefs, "|":U) = "yes":U).

  iEntry = LOOKUP("AlignmentHeight":U,  cPrefs, "|":U). IF iEntry <> 0 THEN giAlignmentHeight  = INTEGER(ENTRY(iEntry + 1, cPrefs, "|":U)).
  iEntry = LOOKUP("SelectorColor":U,    cPrefs, "|":U). IF iEntry <> 0 THEN giSelectorColor    = INTEGER(ENTRY(iEntry + 1, cPrefs, "|":U)).
  iEntry = LOOKUP("BGColor":U,          cPrefs, "|":U). IF iEntry <> 0 THEN giBGColor          = INTEGER(ENTRY(iEntry + 1, cPrefs, "|":U)).
  iEntry = LOOKUP("GLColor":U,          cPrefs, "|":U). IF iEntry <> 0 THEN giGLColor          = INTEGER(ENTRY(iEntry + 1, cPrefs, "|":U)).
  iEntry = LOOKUP("Columns":U,          cPrefs, "|":U). IF iEntry <> 0 THEN giNumColumns       = INTEGER(ENTRY(iEntry + 1, cPrefs, "|":U)).
  iEntry = LOOKUP("Rows":U,             cPrefs, "|":U). IF iEntry <> 0 THEN giNumRows          = INTEGER(ENTRY(iEntry + 1, cPrefs, "|":U)).

  iEntry = LOOKUP("ImageNotAvail":U,    cPrefs, "|":U). IF iEntry <> 0 THEN gcImgNotAvail      = (ENTRY(iEntry + 1, cPrefs, "|":U)).
  iEntry = LOOKUP("ImageUnknown":U,     cPrefs, "|":U). IF iEntry <> 0 THEN gcImgUnknown       = (ENTRY(iEntry + 1, cPrefs, "|":U)).
  iEntry = LOOKUP("GridPosition":U,     cPrefs, "|":U). IF iEntry <> 0 THEN gcGPos             = (ENTRY(iEntry + 1, cPrefs, "|":U)).
  iEntry = LOOKUP("CustomSuffix":U,     cPrefs, "|":U). IF iEntry <> 0 THEN gcCustSuffix       = (ENTRY(iEntry + 1, cPrefs, "|":U)).
  iEntry = LOOKUP("AlignCenter":U,      cPrefs, "|":U). IF iEntry <> 0 THEN gcAlignCenter      = (ENTRY(iEntry + 1, cPrefs, "|":U)).
  iEntry = LOOKUP("AlignRight":U,       cPrefs, "|":U). IF iEntry <> 0 THEN gcAlignRight       = (ENTRY(iEntry + 1, cPrefs, "|":U)).
  iEntry = LOOKUP("ImageAvail":U,       cPrefs, "|":U). IF iEntry <> 0 THEN gcImgAvail         = (ENTRY(iEntry + 1, cPrefs, "|":U)).
  iEntry = LOOKUP("AlignLeft":U,        cPrefs, "|":U). IF iEntry <> 0 THEN gcAlignLeft        = (ENTRY(iEntry + 1, cPrefs, "|":U)).
  iEntry = LOOKUP("Path":U,             cPrefs, "|":U). IF iEntry <> 0 THEN gcPath             = (ENTRY(iEntry + 1, cPrefs, "|":U)).
  iEntry = LOOKUP("Type":U,             cPrefs, "|":U). IF iEntry <> 0 THEN gcImageType        = (ENTRY(iEntry + 1, cPrefs, "|":U)).

  /* Refresh the grid if so desired */
  IF plRefresh = TRUE THEN
  DO WITH FRAME {&FRAME-NAME}:
    {fnarg lockWindow TRUE ghContainerSource}.

    /* Setup the grid line color */
    DO iEntry = 1 TO TRUNCATE(giNumColumns / 2, 0) + 1:
      
      IF VALID-HANDLE(ghGridColumns[iEntry]) THEN
        ghGridColumns[iEntry]:FGCOLOR = giGLColor.
    END.

    DO iEntry = 1 TO TRUNCATE(giNumRows / 2, 0) + 1:

      IF VALID-HANDLE(ghGridRows[iEntry]) THEN
        ghGridRows[iEntry]:FGCOLOR = giGLColor.
    END.

    /* Setup the grid's background color and the selector's foreground color */
    ASSIGN
        rctBackground:BGCOLOR    = giBGColor
        ghSourceSelector:FGCOLOR = giSelectorColor.

    /* Step through the widgets and determine if the alignment widgets should be there (Depends on glCreateAlignment) */
    FOR EACH ttWidget:
      /* Check if the alignment widgets should be created */
      IF glCreateAlignment = TRUE THEN
      DO:
        /* If the widgets should be created, but do not exist, create them */
        IF NOT VALID-HANDLE(ttWidget.hAlignment) THEN
        DO:
          CREATE IMAGE hGridObject IN WIDGET-POOL STRING(THIS-PROCEDURE)
          ASSIGN CONVERT-3D-COLORS = FALSE
                 STRETCH-TO-FIT    = FALSE
                 TRANSPARENT       = TRUE
                 MOVABLE           = FALSE
               /*VISIBLE           = TRUE*/
                 TOOLTIP           = "":U
                 FRAME             = FRAME {&FRAME-NAME}:HANDLE
                 SENSITIVE         = FALSE
          TRIGGERS:
            ON "MOUSE-SELECT-CLICK":U PERSISTENT RUN trgMouseSelectClick IN THIS-PROCEDURE (INPUT hGridObject).
            ON "MOUSE-MENU-DOWN":U    PERSISTENT RUN trgMouseMenuDown    IN THIS-PROCEDURE (INPUT hGridObject).
            ON "START-MOVE":U         PERSISTENT RUN trgStartMove        IN THIS-PROCEDURE (INPUT hGridObject).
            ON "END-MOVE":U           PERSISTENT RUN trgEndMove          IN THIS-PROCEDURE (INPUT hGridObject).
          END TRIGGERS.

          ttWidget.hAlignment = hGridObject.
        END.
      END.
      ELSE
        /* The widgets should not be created so delete them if they exist */
        IF VALID-HANDLE(ttWidget.hAlignment) THEN
        DO:
          DELETE OBJECT ttWidget.hAlignment.

          /* Ensure the stored handle is cleared as the widget is now invalid */
          ttWidget.hAlignment = ?.
        END.
    END.

    /* Force a redisplay of the page so that all objects are redrawn according to preferences */
    RUN setupPageObjects (0.00).

    /* Ensure that the grid is properly sized, also depending on all the selected preferences options */
    RUN resizeObject (FRAME {&FRAME-NAME}:HEIGHT-CHARS, FRAME {&FRAME-NAME}:WIDTH-CHARS).
  
    {fnarg lockWindow FALSE ghContainerSource}.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE propertyChangedObject vTableWin 
PROCEDURE propertyChangedObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phProc      AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcContainer AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcObject    AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cObjectString           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lReposPS                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE httObjectInstance       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httObjectType           AS HANDLE     NO-UNDO.

  IF glReposCB  = FALSE OR
     glComplete = FALSE THEN
    RETURN.

  ASSIGN
      lReposPS                = glReposPS
      glReposPS               = FALSE
      dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "CustomizationResultObj":U))
      httObjectInstance       = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttObjectInstance":U))
      httObjectType           = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttObjectType":U)).

  IF httObjectType:AVAILABLE THEN
    httObjectType:BUFFER-RELEASE().

  CREATE BUFFER httObjectInstance FOR TABLE httObjectInstance.

  httObjectInstance:FIND-FIRST("WHERE ttObjectInstance.d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj)
                              + " AND ttObjectInstance.d_object_instance_obj      = '":U + pcObject + "'":U) NO-ERROR.

  IF httObjectInstance:AVAILABLE THEN
    httObjectType:FIND-FIRST("WHERE d_object_type_obj = ":U + QUOTER(httObjectInstance:BUFFER-FIELD("d_object_type_obj":U):BUFFER-VALUE)) NO-ERROR.

  IF httObjectType:AVAILABLE THEN /* If the object type is available, the object instance was available */
  DO:
    cObjectString  = STRING(httObjectInstance:BUFFER-FIELD("i_page":U):BUFFER-VALUE + 1) + "|":U
                   + STRING(httObjectInstance:BUFFER-FIELD("i_row":U):BUFFER-VALUE)      + "|":U
                   + STRING(httObjectInstance:BUFFER-FIELD("i_column":U):BUFFER-VALUE)   + "|":U
                   + (IF DYNAMIC-FUNCTION("isVisibleObjectType":U IN ghContainerSource, httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE) THEN "Y":U ELSE "N":U).

    DYNAMIC-FUNCTION("repositionToObject":U, cObjectString).
  END.

  DELETE OBJECT httObjectInstance.

  glReposPS = lReposPS.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject vTableWin 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdHeight AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth  AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE iHeightPixels         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iWidthPixels          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lResizedViewerObjects AS LOGICAL    NO-UNDO INITIAL FALSE.

  IF DYNAMIC-FUNCTION("getObjectInitialized":U) = FALSE THEN
  DO:
    ASSIGN    
        FRAME {&FRAME-NAME}:SCROLLABLE           = TRUE
        FRAME {&FRAME-NAME}:HEIGHT-CHARS         = pdHeight
        FRAME {&FRAME-NAME}:WIDTH-CHARS          = pdWidth
        FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-CHARS = pdHeight
        FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-CHARS  = pdWidth
        FRAME {&FRAME-NAME}:SCROLLABLE           = FALSE.

    RETURN.
  END.

  HIDE FRAME {&FRAME-NAME}.

  IF VALID-HANDLE(ghSourceSelector) THEN
    ASSIGN  
        ghSourceSelector:X = 0
        ghSourceSelector:Y = 0.

  ASSIGN    
      iHeightPixels                            = pdHeight * (SESSION:HEIGHT-PIXELS / SESSION:HEIGHT-CHARS)
      iWidthPixels                             = pdWidth  * (SESSION:WIDTH-PIXELS  / SESSION:WIDTH-CHARS)
      FRAME {&FRAME-NAME}:SCROLLABLE           = TRUE
      FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-CHARS = SESSION:HEIGHT-CHARS
      FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-CHARS  = SESSION:WIDTH-CHARS
      FRAME {&FRAME-NAME}:TOP-ONLY             = TRUE.

  /* If the height OR width of the frame was made smaller */
  IF pdHeight < FRAME {&FRAME-NAME}:HEIGHT-CHARS OR
     pdWidth  < FRAME {&FRAME-NAME}:WIDTH-CHARS  THEN
  DO:
    /* Just in case the window was made longer or wider, allow for the new length or width */
    IF pdHeight > FRAME {&FRAME-NAME}:HEIGHT THEN FRAME {&FRAME-NAME}:HEIGHT-CHARS = pdHeight.
    IF pdWidth  > FRAME {&FRAME-NAME}:WIDTH  THEN FRAME {&FRAME-NAME}:WIDTH-CHARS  = pdWidth.

    lResizedViewerObjects = TRUE.

    RUN resizeViewerObjects (INPUT iHeightPixels, INPUT iWidthPixels).
  END.

  IF lResizedViewerObjects = FALSE THEN
    RUN resizeViewerObjects (INPUT iHeightPixels, INPUT iWidthPixels).

  ASSIGN    
      FRAME {&FRAME-NAME}:HEIGHT-CHARS         = pdHeight
      FRAME {&FRAME-NAME}:WIDTH-CHARS          = pdWidth
      FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-CHARS = pdHeight
      FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-CHARS  = pdWidth
      FRAME {&FRAME-NAME}:SCROLLABLE           = FALSE.

  DYNAMIC-FUNCTION("showHighlights":U).

  VIEW FRAME {&FRAME-NAME}.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeViewerObjects vTableWin 
PROCEDURE resizeViewerObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER piHeightPixels AS INTEGER    NO-UNDO.
  DEFINE INPUT PARAMETER piWidthPixels  AS INTEGER    NO-UNDO.

  DEFINE VARIABLE iAlignmentHeight  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCounter          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iStartY           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE dAvailableWidth   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iHeightChange     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iWidthChange      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE dDifference       AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hHandle           AS HANDLE     NO-UNDO.

  DEFINE VARIABLE iColumnWidth      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRowHeight        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iTBSize           AS INTEGER    NO-UNDO. /* Toolbar Size     */
  DEFINE VARIABLE iTextWidth        AS INTEGER    NO-UNDO.

  DEFINE BUFFER ttWidget FOR ttWidget.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        /* Setup the Quick-Link section */
        iTextWidth                = 10
        iTBSize                   = 28
        iHeightChange             = (piHeightPixels  - rctQuickLink:HEIGHT-PIXELS) - rctQuickLink:Y
        rctQuickLink:WIDTH-PIXELS = piWidthPixels
        rctQuickLink:Y            = piHeightPixels - rctQuickLink:HEIGHT-PIXELS
        fiQuickLink:X             = rctQuickLink:X   + 5
        fiQuickLink:Y             = rctQuickLink:Y   - 7
        buSaveLink:X              = rctQuickLink:WIDTH-PIXELS - 5 - buSaveLink:WIDTH-PIXELS
        hHandle                   = coLink:SIDE-LABEL-HANDLE
        dAvailableWidth           = buSaveLink:COLUMN - edSource:COLUMN - (coLink:WIDTH-CHARS + 15.60)
        dAvailableWidth           = dAvailableWidth  / 2
        dDifference               = dAvailableWidth  - edSource:WIDTH-CHARS
        edSource:WIDTH-CHARS      = dAvailableWidth
        edTarget:WIDTH-CHARS      = dAvailableWidth
        buSwap:WIDTH-CHARS        = coLink:WIDTH-CHARS
        hHandle:COLUMN            = hHandle:COLUMN  + dDifference
        buTarget:COLUMN           = buTarget:COLUMN + dDifference
        edTarget:COLUMN           = edTarget:COLUMN + dDifference
        coLink:COLUMN             = coLink:COLUMN   + dDifference
        buSwap:COLUMN             = coLink:COLUMN
        buSaveLink:Y              = buSaveLink:Y    + iHeightChange
        edSource:Y                = edSource:Y      + iHeightChange
        buSource:Y                = buSource:Y      + iHeightChange
        edTarget:Y                = edTarget:Y      + iHeightChange
        buTarget:Y                = buTarget:Y      + iHeightChange
        hHandle:Y                 = hHandle:Y       + iHeightChange
        coLink:Y                  = coLink:Y        + iHeightChange
        buSwap:Y                  = coLink:Y        + coLink:HEIGHT-PIXELS

        iHeightChange = (IF NOT glTBToGrid AND NOT glTBVertical AND glTBTopOrLeft THEN (iTBSize - 2) - rctProperties:Y ELSE -(rctProperties:Y))
        iWidthChange  = (IF gcGPos = "Right":U THEN (IF NOT glTBToGrid AND glTBVertical AND glTBTopOrLeft THEN (iTBSize - 2) - rctProperties:X
                                                                                                          ELSE -(rctProperties:X))
                                               ELSE piWidthPixels - rctProperties:WIDTH-PIXELS - (buLayoutObjects:WIDTH-PIXELS + 6)
                                                                  - rctProperties:X - (IF NOT glTBToGrid AND glTBVertical AND NOT glTBTopOrLeft THEN iTBSize - 2
                                                                                                                                                ELSE 0))
        rctProperties:X = (IF gcGPos = "Right":U THEN (IF NOT glTBToGrid AND glTBVertical AND glTBTopOrLeft THEN iTBSize - 2 ELSE 0)
                                                 ELSE rctProperties:X + iWidthChange)

        rctGrid:X       = (IF gcGPos = "Left":U THEN (IF glTBToGrid AND glTBVertical AND glTBTopOrLeft THEN iTBSize - 2 ELSE 0)
                                                ELSE rctProperties:WIDTH-PIXELS + (IF NOT glTBToGrid AND glTBVertical THEN iTBSize - 2
                                                                                                                      ELSE (IF glTBToGrid AND glTBTopOrLeft AND glTBVertical THEN iTBSize - 2
                                                                                                                                                                             ELSE 0)))
                        + (IF gcGPos = "Left":U THEN 0 ELSE 5)

        rctGrid:WIDTH-PIXELS  = piWidthPixels - rctProperties:WIDTH-PIXELS - (buLayoutObjects:WIDTH-PIXELS + 6) - 5
                              - (IF glTBVertical THEN iTBSize - 2 ELSE 0)

        rctGrid:HEIGHT-PIXELS = piHeightPixels - rctQuickLink:HEIGHT-PIXELS - rctGrid:Y - 8
                              - (IF glTBToGrid AND NOT glTBVertical THEN (iTBSize - 2) - rctGrid:Y
                                                                    ELSE (IF glTBToGrid AND glTBVertical THEN 0 ELSE 0))
        rctGrid:Y             = (IF glTBToGrid AND NOT glTBVertical THEN (IF glTBTopOrLeft THEN iTBSize - 2 ELSE 0) ELSE 0)

        rctProperties:HEIGHT-PIXELS = piHeightPixels - rctQuickLink:HEIGHT-PIXELS - rctProperties:Y - 8
                                    - (IF NOT glTBToGrid AND NOT glTBVertical THEN (iTBSize - 2) - rctProperties:Y
                                                                              ELSE (IF NOT glTBToGrid AND glTBVertical THEN 0 ELSE 0))
        rctProperties:Y             = (IF NOT glTBToGrid AND NOT glTBVertical THEN (IF glTBTopOrLeft THEN iTBSize - 2 ELSE 0) ELSE 0)

        /* Setup the Toolbar */
        rctToolbar:HEIGHT-PIXELS = (IF NOT glTBVertical THEN iTBSize ELSE (IF glTBToGrid THEN rctGrid:HEIGHT-PIXELS ELSE rctProperties:HEIGHT-PIXELS))
        rctToolbar:WIDTH-PIXELS  = (IF     glTBVertical THEN iTBSize ELSE (IF glTBToGrid THEN rctGrid:WIDTH-PIXELS  ELSE rctProperties:WIDTH-PIXELS))
        rctToolbar:X             = (IF glTBToGrid THEN (IF NOT glTBVertical THEN rctGrid:X
                                                                            ELSE (IF glTBTopOrLeft THEN rctGrid:X - iTBSize + 2
                                                                                                   ELSE rctGrid:X + rctGrid:WIDTH-PIXELS - 2))
                                                  ELSE (IF NOT glTBVertical THEN rctProperties:X
                                                                            ELSE (IF glTBTopOrLeft THEN rctProperties:X - iTBSize + 2
                                                                                                   ELSE rctProperties:X + rctProperties:WIDTH-PIXELS - 2)))
        rctToolbar:Y             = (IF glTBToGrid THEN (IF     glTBVertical THEN rctGrid:Y
                                                                            ELSE (IF glTBTopOrLeft THEN rctGrid:Y - iTBSize + 2
                                                                                                   ELSE rctGrid:Y + rctGrid:HEIGHT-PIXELS - 2))
                                                  ELSE (IF     glTBVertical THEN rctProperties:Y
                                                                            ELSE (IF glTBTopOrLeft THEN rctProperties:Y - iTBSize + 2
                                                                                                   ELSE rctProperties:Y + rctProperties:HEIGHT-PIXELS - 2)))

        iColumnWidth                  = TRUNCATE((rctGrid:WIDTH-PIXELS - iTextWidth)  / giNumColumns, 0) - 2
        iRowHeight                    = TRUNCATE((rctGrid:HEIGHT-PIXELS - 10) / giNumRows,    0) - 2
        rctBackground:X               = rctGrid:X + TRUNCATE((rctGrid:WIDTH-PIXELS  - (giNumColumns * (iColumnWidth + 1) + 1)) / 2, 0) + (iTextWidth / 2)
        rctBackground:Y               = rctGrid:Y + TRUNCATE((rctGrid:HEIGHT-PIXELS - (giNumRows    * (iRowHeight   + 1) + 1)) / 2, 0) + 7
        rctBackground:WIDTH-PIXELS    = giNumColumns * (iColumnWidth + 1) + 1
        rctBackground:HEIGHT-PIXELS   = giNumRows    * (iRowHeight   + 1) + 1
        buAdd:X                       = rctToolbar:X + 2 + (IF glTBVertical THEN 0 ELSE 5)
        buAdd:Y                       = rctToolbar:Y + 2
/*edForeignFields:HEIGHT-PIXELS = rctProperties:HEIGHT-PIXELS - edForeignFields:Y - 8*/
        giColumnWidth                 = (rctBackground:WIDTH-PIXELS)  / giNumColumns
        giRowHeight                   = (rctBackground:HEIGHT-PIXELS) / giNumRows
        iAlignmentHeight              = (IF glCreateAlignment = TRUE THEN giAlignmentHeight ELSE 0)
        buLayoutObjects:Y             = 10
        buLayoutObjects:X             = piWidthPixels - buLayoutObjects:WIDTH-PIXELS

        /* --- Adjust the X Coordinates ------------------------- */      /* --- Adjust the Y Coordinates -------------------------- */
        fiObjectDescription:X = fiObjectDescription:X + iWidthChange      fiObjectDescription:Y = fiObjectDescription:Y + iHeightChange
        fiForeignFieldLabel:X = fiForeignFieldLabel:X + iWidthChange      fiForeignFieldLabel:Y = fiForeignFieldLabel:Y + iHeightChange
        toResizeHorizontal:X  = toResizeHorizontal:X  + iWidthChange      toResizeHorizontal:Y  = toResizeHorizontal:Y  + iHeightChange
        fiObjectInstances:X   = fiObjectInstances:X   + iWidthChange      fiObjectInstances:Y   = fiObjectInstances:Y   + iHeightChange
        toResizeVertical:X    = toResizeVertical:X    + iWidthChange      toResizeVertical:Y    = toResizeVertical:Y    + iHeightChange
        rctJustification:X    = rctJustification:X    + iWidthChange      rctJustification:Y    = rctJustification:Y    + iHeightChange
        fiJustification:X     = fiJustification:X     + iWidthChange      fiJustification:Y     = fiJustification:Y     + iHeightChange
        edForeignFields:X     = edForeignFields:X     + iWidthChange      edForeignFields:Y     = edForeignFields:Y     + iHeightChange
        coUpdateTargets:X     = coUpdateTargets:X     + iWidthChange      coUpdateTargets:Y     = coUpdateTargets:Y     + iHeightChange
        fiInstanceName:X      = fiInstanceName:X      + iWidthChange      fiInstanceName:Y      = fiInstanceName:Y      + iHeightChange
        coDataSources:X       = coDataSources:X       + iWidthChange      coDataSources:Y       = coDataSources:Y       + iHeightChange
        coNavTarget:X         = coNavTarget:X         + iWidthChange      coNavTarget:Y         = coNavTarget:Y         + iHeightChange
        buMapFields:X         = buMapFields:X         + iWidthChange      buMapFields:Y         = buMapFields:Y         + iHeightChange
        raLCR:X               = raLCR:X               + iWidthChange      raLCR:Y               = raLCR:Y               + iHeightChange

        fiObjectDescription:SIDE-LABEL-HANDLE:X = fiObjectDescription:SIDE-LABEL-HANDLE:X + iWidthChange
        coUpdateTargets:SIDE-LABEL-HANDLE:X     = coUpdateTargets:SIDE-LABEL-HANDLE:X     + iWidthChange
        fiInstanceName:SIDE-LABEL-HANDLE:X      = fiInstanceName:SIDE-LABEL-HANDLE:X      + iWidthChange
        coDataSources:SIDE-LABEL-HANDLE:X       = coDataSources:SIDE-LABEL-HANDLE:X       + iWidthChange
        coNavTarget:SIDE-LABEL-HANDLE:X         = coNavTarget:SIDE-LABEL-HANDLE:X         + iWidthChange
        fiObjectDescription:SIDE-LABEL-HANDLE:Y = fiObjectDescription:SIDE-LABEL-HANDLE:Y + iHeightChange
        coUpdateTargets:SIDE-LABEL-HANDLE:Y     = coUpdateTargets:SIDE-LABEL-HANDLE:Y     + iHeightChange
        fiInstanceName:SIDE-LABEL-HANDLE:Y      = fiInstanceName:SIDE-LABEL-HANDLE:Y      + iHeightChange
        coDataSources:SIDE-LABEL-HANDLE:Y       = coDataSources:SIDE-LABEL-HANDLE:Y       + iHeightChange
        coNavTarget:SIDE-LABEL-HANDLE:Y         = coNavTarget:SIDE-LABEL-HANDLE:Y         + iHeightChange.

    RUN repositionObject IN hObjectFileName (INPUT {fn getRow hObjectFilename} + (iHeightChange / SESSION:PIXELS-PER-ROW),
                                             INPUT {fn getCol hObjectFilename} + (iWidthChange  / SESSION:PIXELS-PER-COL)).
    RUN repositionObject IN hObjectType     (INPUT {fn getRow hObjectType}     + (iHeightChange / SESSION:PIXELS-PER-ROW),
                                             INPUT {fn getCol hObjectType}     + (iWidthChange  / SESSION:PIXELS-PER-COL)).

    DYNAMIC-FUNCTION("positionButton":U, buDelete:HANDLE,           buAdd:HANDLE,           (IF glTBVertical THEN TRUE ELSE FALSE)).
    DYNAMIC-FUNCTION("positionButton":U, buReset:HANDLE,            buDelete:HANDLE,        (IF glTBVertical THEN TRUE ELSE FALSE)).
    DYNAMIC-FUNCTION("positionButton":U, buCancel:HANDLE,           buReset:HANDLE,         (IF glTBVertical THEN TRUE ELSE FALSE)).
    DYNAMIC-FUNCTION("positionButton":U, buCut:HANDLE,              buCancel:HANDLE,        (IF glTBVertical THEN TRUE ELSE FALSE)).
    DYNAMIC-FUNCTION("positionButton":U, buCopy:HANDLE,             buCut:HANDLE,           (IF glTBVertical THEN TRUE ELSE FALSE)).
    DYNAMIC-FUNCTION("positionButton":U, buCancelCoC:HANDLE,        buCopy:HANDLE,          (IF glTBVertical THEN TRUE ELSE FALSE)).
    DYNAMIC-FUNCTION("positionButton":U, buPaste:HANDLE,            buCancelCoC:HANDLE,     (IF glTBVertical THEN TRUE ELSE FALSE)).
    DYNAMIC-FUNCTION("positionButton":U, buOldProperties:HANDLE,    buPaste:HANDLE,         (IF glTBVertical THEN TRUE ELSE FALSE)).
    DYNAMIC-FUNCTION("positionButton":U, buProperties:HANDLE,       buOldProperties:HANDLE, (IF glTBVertical THEN TRUE ELSE FALSE)).
    DYNAMIC-FUNCTION("positionButton":U, buNonLayoutObjects:HANDLE, buLayoutObjects:HANDLE,    TRUE).
    DYNAMIC-FUNCTION("positionButton":U, buLayoutPreview:HANDLE,    buNonLayoutObjects:HANDLE, TRUE).

    ASSIGN
        rctSeperator1:Y             = (IF glTBVertical THEN buCut:Y           - 2       ELSE rctToolbar:Y      + 2)
        rctSeperator1:X             = (IF glTBVertical THEN rctToolbar:X      + 2       ELSE buCut:X           - 2)
        rctSeperator2:Y             = (IF glTBVertical THEN buOldProperties:Y - 2       ELSE rctToolbar:Y      + 2)
        rctSeperator2:X             = (IF glTBVertical THEN rctToolbar:X      + 2       ELSE buOldProperties:X - 2)
        rctSeperator1:HEIGHT-PIXELS = (IF glTBVertical THEN 2                           ELSE rctToolbar:HEIGHT-PIXELS - 4)
        rctSeperator1:WIDTH-PIXELS  = (IF glTBVertical THEN rctToolbar:WIDTH-PIXELS - 4 ELSE 2)
        rctSeperator2:HEIGHT-PIXELS = (IF glTBVertical THEN 2                           ELSE rctToolbar:HEIGHT-PIXELS - 4)
        rctSeperator2:WIDTH-PIXELS  = (IF glTBVertical THEN rctToolbar:WIDTH-PIXELS - 4 ELSE 2).

    /* Position the rows */
    DO iCounter = 1 TO TRUNCATE(giNumRows / 2, 0) + 1:
      ASSIGN
          ghGridRows[iCounter]:X             = rctBackground:X
          ghGridRows[iCounter]:Y             = rctBackground:Y + ((iCounter - 1) * giRowHeight * 2)
          ghGridRows[iCounter]:HEIGHT-PIXELS = giRowHeight + 1
          ghGridRows[iCounter]:WIDTH-PIXELS  = rctBackground:WIDTH-PIXELS.

      ghGridRows[iCounter]:MOVE-TO-BOTTOM().
    END.

    /* Position the columns */
    DO iCounter = 1 TO TRUNCATE(giNumColumns / 2, 0) + 1:
      ASSIGN
          ghGridColumns[iCounter]:X             = rctBackground:X + ((iCounter - 1) * giColumnWidth * 2)
          ghGridColumns[iCounter]:Y             = rctBackGround:Y
          ghGridColumns[iCounter]:HEIGHT-PIXELS = rctBackground:HEIGHT-PIXELS
          ghGridColumns[iCounter]:WIDTH-PIXELS  = giColumnWidth + 1.

      ghGridColumns[iCounter]:MOVE-TO-BOTTOM().
    END.

    FOR EACH ttWidget
          BY ttWidget.iRow DESCENDING
          BY ttWidget.iCol DESCENDING:

      IF ttWidget.iRow <= giNumRows    AND
         ttWidget.iCol <= giNumColumns THEN
      DO:
        ASSIGN
            ttWidget.hHandle:HEIGHT-PIXELS    = giRowHeight   - iAlignmentHeight - 1
            ttWidget.hHandle:WIDTH-PIXELS     = giColumnWidth - 1
            ttWidget.hHandle:X                = rctBackground:X + ((ttWidget.iCol - 1) * giColumnWidth + 1)
            ttWidget.hHandle:Y                = rctBackground:Y + ((ttWidget.iRow - 1) * giRowHeight   + 1)
            ttWidget.X                        = ttWidget.hHandle:X
            ttWidget.Y                        = ttWidget.hHandle:Y.

        IF VALID-HANDLE(ttWidget.hAlignment) AND
           glCreateAlignment                 THEN
            ASSIGN
                ttWidget.hAlignment:HEIGHT-PIXELS = iAlignmentHeight
                ttWidget.hAlignment:WIDTH-PIXELS  = ttWidget.hHandle:WIDTH-PIXELS
                ttWidget.hAlignment:X             = ttWidget.hHandle:X
                ttWidget.hAlignment:Y             = ttWidget.hHandle:Y + ttWidget.hHandle:HEIGHT-PIXELS.
      END.
      ELSE
      DO:
        ttWidget.hHandle:SENSITIVE = FALSE.

        IF VALID-HANDLE(ttWidget.hAlignment) THEN
          ttWidget.hAlignment:SENSITIVE = FALSE.
      END.

      ttWidget.hHandle:MOVE-TO-TOP().

      IF VALID-HANDLE(ttWidget.hAlignment) THEN
        ttWidget.hAlignment:MOVE-TO-TOP().
    END.

    DO iCounter = 1 TO giNumRows:
      ASSIGN
          iStartY                              = rctBackground:Y + ((iCounter - 1) * giRowHeight)
          ghTextWidgets[iCounter]:WIDTH-PIXELS = iTextWidth
          ghTextWidgets[iCounter]:X            = rctBackground:X - iTextWidth - 1
          ghTextWidgets[iCounter]:Y            = iStartY + ((giRowHeight - 10) / 2)
          ghTextWidgets[iCounter]:SCREEN-VALUE = STRING(iCounter).
    END.

    DO iCounter = 1 TO giNumColumns:
      ASSIGN
          ghTextWidgets[iCounter + giNumRows]:WIDTH-PIXELS = iTextWidth
          ghTextWidgets[iCounter + giNumRows]:X            = rctBackground:X + ((iCounter - 1) * giColumnWidth) + ((giColumnWidth - 10) / 2)
          ghTextWidgets[iCounter + giNumRows]:Y            = rctBackGround:Y - 14
          ghTextWidgets[iCounter + giNumRows]:SCREEN-VALUE = KEYLABEL(KEYCODE("A":U) + iCounter - 1).
    END.

    rctGrid:MOVE-TO-BOTTOM().
    rctBackground:MOVE-TO-BOTTOM().
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setProperties vTableWin 
PROCEDURE setProperties :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE httObjectInstance       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSelectedWidget         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httSmartObject          AS HANDLE     NO-UNDO.

  DEFINE BUFFER ttWidget  FOR ttWidget.

  dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "CustomizationResultObj":U)).

  /* If we get to this point, the procedure library will have been launched already by the container
     builder. Therefor, just populate the handle with that of the Property Sheet procedure library. */
  IF NOT VALID-HANDLE(ghProcLib) THEN
  DO:
    ghProcLib = SESSION:FIRST-PROCEDURE.
    DO WHILE VALID-HANDLE(ghProcLib) AND ghProcLib:FILE-NAME NE "ry/prc/ryvobplipp.p":U:
      ghProcLib = ghProcLib:NEXT-SIBLING.
    END.
  END.
  
  SUBSCRIBE PROCEDURE ghContainerSource TO "PropertyChangedAttribute":U IN ghProcLib.
  SUBSCRIBE PROCEDURE ghContainerSource TO "PropertyChangedEvent":U     IN ghProcLib.

  SUBSCRIBE TO "PropertyChangedObject":U  IN ghProcLib.
  SUBSCRIBE TO "PropertyChangeResult":U   IN ghProcLib.
  SUBSCRIBE TO "PropertyChangeClass":U    IN ghProcLib.
  
  ASSIGN
      httObjectInstance = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttObjectInstance":U))
      hSelectedWidget   = DYNAMIC-FUNCTION("getSelectedWidget":U)
      httSmartObject    = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttSmartObject":U)).

  IF NOT VALID-HANDLE(hSelectedWidget) AND
     NOT VALID-HANDLE(ghProcLib)       THEN
    RETURN.

  FIND FIRST ttWidget
       WHERE ttWidget.hHandle = hSelectedWidget.

  httSmartObject:FIND-FIRST("WHERE d_smartobject_obj <> 0 AND d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj)).
  httObjectInstance:FIND-FIRST("WHERE d_object_instance_obj = ":U + QUOTER(ttWidget.dObjectInstanceObj)).
/*
  RUN adeuib/_open-w.p ("ry/obj/ryobjgridv.w":U, "":U, "WINDOW":U).
          
  RETURN.
*/
  {fnarg lockWindow TRUE ghContainerSource}.

  /* Launch the Property Sheet */
  RUN launchPropertyWindow IN ghProcLib.

  RUN displayProperties IN ghProcLib (INPUT ghContainerSource,
                                      INPUT httSmartObject:BUFFER-FIELD("d_smartobject_obj":U):BUFFER-VALUE,
                                      INPUT httObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE,
                                      INPUT DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "CustomizationResultCode":U),
                                      INPUT TRUE,
                                      INPUT 0).
  
  {fnarg lockWindow FALSE ghContainerSource}.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSourceTarget vTableWin 
PROCEDURE setSourceTarget :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phWidget       AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER pcSourceTarget AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cObjectTypeCode     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSourceTarget       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cInstanceName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dObjectInstanceObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iColumn             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPage               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRow                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lVisibleObject      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hbttObjectInstance  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httObjectInstance   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httObjectType       AS HANDLE     NO-UNDO.

  DEFINE BUFFER ttWidget FOR ttWidget.

  ASSIGN
      httObjectInstance = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttObjectInstance":U))
      httObjectType     = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttObjectType":U))
      cSourceTarget     = (IF pcSourceTarget BEGINS "LS":U THEN "SOURCE":U ELSE "TARGET":U).

  CREATE BUFFER hbttObjectInstance  FOR TABLE httObjectInstance.
  CREATE BUFFER httObjectInstance   FOR TABLE httObjectInstance.

  IF LENGTH(pcSourceTarget) = 4 THEN
    ASSIGN
        dObjectInstanceObj = 0.00
        cObjectTypeCode    = "":U
        phWidget           = ?
        lVisibleObject     = FALSE
        cInstanceName      = "THIS-OBJECT":U
        iColumn            = 0
        iPage              = 0
        iRow               = 0
        .
  ELSE
  DO:
    FOR FIRST ttWidget
        WHERE ttWidget.hHandle = phWidget:

      hbttObjectInstance:FIND-FIRST("WHERE d_object_instance_obj = ":U + QUOTER(ttWidget.dObjectInstanceObj)).
      httObjectInstance:FIND-FIRST("WHERE d_customization_result_obj = 0 AND c_instance_name = ":U + QUOTER(hbttObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE)) NO-ERROR.
      httObjectType:FIND-FIRST("WHERE d_object_type_obj = ":U + QUOTER(hbttObjectInstance:BUFFER-FIELD("d_object_type_obj":U):BUFFER-VALUE)).

      IF httObjectInstance:AVAILABLE THEN
        dObjectInstanceObj = httObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE.
      ELSE
        dObjectInstanceObj = hbttObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE.

      ASSIGN
          cObjectTypeCode    = httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE
          lVisibleObject     = DYNAMIC-FUNCTION("isVisibleObjectType":U IN ghContainerSource, httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE)
          cInstanceName      = hbttObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE
          iPage              = hbttObjectInstance:BUFFER-FIELD("i_page":U):BUFFER-VALUE
          iColumn            = ttWidget.iCol            /* ttObjectInstance.i_column */
          iRow               = ttWidget.iRow.           /* ttObjectInstance.i_row    */
    END.
  END.

  DELETE OBJECT httObjectInstance.

  DYNAMIC-FUNCTION("setLinkObject":U, cSourceTarget,      /* cSourceTarget      */
                                      cInstanceName,      /* cObjectName        */
                                      cObjectTypeCode,    /* cObjectType        */
                                      dObjectInstanceObj, /* dObjectInstanceObj */
                                      iPage,              /* iPage              */
                                      iColumn,            /* iColumn            */
                                      iRow,               /* iRow               */
                                      lVisibleObject).    /* lVisibleObject     */

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setupPageObjects vTableWin 
PROCEDURE setupPageObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdObjectInstanceObj  AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE cParentContainerMode    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectTypeCode         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectView             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewLayout              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCoCMode                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLCR                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iCurrentPage            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iColumn                 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRow                    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lSuccess                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE httObjectInstance       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httObjectType           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSelected               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery                  AS HANDLE     NO-UNDO.

  DEFINE BUFFER ttWidget FOR ttWidget.

  ASSIGN
      dCustomizationResultObj  = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "CustomizationResultObj":U))
      cParentContainerMode     = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U)
      httObjectInstance        = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttObjectInstance":U))
      httObjectType            = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttObjectType":U))
      iCurrentPage             = DYNAMIC-FUNCTION("getPageSequence":U IN ghContainerSource, ?)
      cObjectView              = DYNAMIC-FUNCTION("getUserProperty":U, "ObjectView":U)
      cCoCMode                 = DYNAMIC-FUNCTION("getUserProperty":U, "CoCMode":U)
      hSelected                = DYNAMIC-FUNCTION("getSelectedWidget":U).

  IF NOT VALID-HANDLE(httObjectInstance) OR
     NOT VALID-HANDLE(httObjectType)     THEN
    RETURN.

  IF NOT VALID-HANDLE(ghObjectInstance) THEN
    CREATE BUFFER ghObjectInstance FOR TABLE httObjectInstance IN WIDGET-POOL STRING(THIS-PROCEDURE).

  /* Clearing the temp-table and the grid */
  DYNAMIC-FUNCTION("clearGrid":U, pdObjectInstanceObj).

  CREATE BUFFER httObjectInstance FOR TABLE httObjectInstance.
  CREATE BUFFER httObjectType     FOR TABLE httObjectType.
  
  CREATE QUERY hQuery.

  hQuery:SET-BUFFERS(httObjectInstance, httObjectType).
  /* Check the object instances to find only the ones required for the currently selected page */
  hQuery:QUERY-PREPARE("FOR EACH ttObjectInstance":U
                       + " WHERE ttObjectInstance.i_page                     = ":U + STRING(iCurrentPage)
                       + "   AND ttObjectInstance.c_action                  <> 'D'":U
                       + "   AND ttObjectInstance.d_smartobject_obj         <> 0":U
                       + "   AND ttObjectInstance.d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj) + ",":U
                       + " FIRST ttObjectType":U
                       + " WHERE ttObjectType.d_object_type_obj = ttObjectInstance.d_object_type_obj":U).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().

  glHasDataObjects = FALSE.

  DO WHILE NOT hQuery:QUERY-OFF-END:
    cObjectTypeCode = httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE.

    /* If we are viewing objects that have layouts then skip non-layout objects and vice-versa */
    IF (cObjectView = "NonLayoutObjects":U AND httObjectInstance:BUFFER-FIELD("l_visible_object":U):BUFFER-VALUE = TRUE)  OR
       (cObjectView = "LayoutObjects":U    AND httObjectInstance:BUFFER-FIELD("l_visible_object":U):BUFFER-VALUE = FALSE) OR

       /* Check if we are only interested in viewing a particular object */
       (pdObjectInstanceObj <> 0           AND httObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE <> pdObjectInstanceObj) THEN
    DO:
      IF cObjectView = "LayoutObjects":U AND httObjectInstance:BUFFER-FIELD("l_visible_object":U):BUFFER-VALUE = FALSE THEN
        glHasDataObjects = TRUE.
    END.
    ELSE
    DO:
      FIND FIRST ttWidget
           WHERE ttWidget.iRow = INTEGER(httObjectInstance:BUFFER-FIELD("i_row":U):BUFFER-VALUE)
             AND ttWidget.iCol = INTEGER(httObjectInstance:BUFFER-FIELD("i_column":U):BUFFER-VALUE).

      ASSIGN
          ttWidget.dObjectInstanceObj = httObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE
          ttWidget.cLCR               = (IF cObjectView = "NonLayoutObjects":U THEN "L":U ELSE httObjectInstance:BUFFER-FIELD("c_lcr":U):BUFFER-VALUE)
          ttWidget.cObject            = httObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE
          ttWidget.cObjectType        = cObjectTypeCode
          ttWidget.lAvailable         = FALSE.
    END.

    hQuery:GET-NEXT().
  END.

  DELETE OBJECT httObjectInstance.
  DELETE OBJECT httObjectType.
  DELETE OBJECT hQuery.

  ASSIGN
      httObjectInstance = ?
      httObjectType     = ?
      hQuery            = ?.

  /* Show the objects */
  FOR EACH ttWidget
     WHERE ttWidget.lAvailable = FALSE:

    IF pdObjectInstanceObj <> ttWidget.dObjectInstanceObj AND
       pdObjectInstanceObj <> 0                           THEN
      NEXT.

    DYNAMIC-FUNCTION("setWidgetProperties":U, ttWidget.hHandle).
  END.

  /* If no widget is selected, select the first occupied widget that could be found */
  FIND FIRST ttWidget
       WHERE ttWidget.hHandle    = hSelected
         AND ttWidget.lAvailable = FALSE NO-ERROR.
  
  IF NOT AVAILABLE ttWidget THEN
    FOR FIRST ttWidget
        WHERE ttWidget.lAvailable = FALSE:

      DYNAMIC-FUNCTION("setSelectedWidget":U, ttWidget.hHandle).
    END.

  DYNAMIC-FUNCTION("setUserProperty":U, "ContainerMode":U, "MODIFY":U).
  DYNAMIC-FUNCTION("evaluateActions":U).
  DYNAMIC-FUNCTION("showHighlights":U).

  APPLY "VALUE-CHANGED":U TO coLink IN FRAME {&FRAME-NAME}.

  IF cCoCMode <> "Off":U THEN
    IF (cObjectView = "NonLayoutObjects":U AND glCoCVisible = FALSE) OR 
       (cObjectView = "LayoutObjects":U    AND glCoCVisible = TRUE) THEN
      DYNAMIC-FUNCTION("showTargets":U, ?).

  glComplete = TRUE.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE swapLinkObjects vTableWin 
PROCEDURE swapLinkObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dSourceObjectInstanceObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dTargetObjectInstanceObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lVisibleObject            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE httObjectInstance         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httObjectType             AS HANDLE     NO-UNDO.
  
  CREATE BUFFER httObjectInstance FOR TABLE ghObjectInstance.

  ASSIGN
      dSourceObjectInstanceObj = gdSourceObjectInstanceObj
      dTargetObjectInstanceObj = gdTargetObjectInstanceObj

      httObjectType = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttObjectType":U)).

  httObjectInstance:FIND-FIRST("WHERE d_object_instance_obj = ":U + QUOTER(dSourceObjectInstanceObj)).
  httObjectType:FIND-FIRST("WHERE d_object_type_obj = ":U + QUOTER(httObjectInstance:BUFFER-FIELD("d_object_type_obj":U):BUFFER-VALUE)).
  
  lVisibleObject = DYNAMIC-FUNCTION("isVisibleObjectType":U IN ghContainerSource, httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE).
  
  DYNAMIC-FUNCTION("setLinkObject":U, "TARGET":U,                                                       /* cSourceTarget      */
                                      httObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE, /* cObjectName        */
                                      httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE,  /* cObjectType        */
                                      dSourceObjectInstanceObj,                                         /* dObjectInstanceObj */
                                      httObjectInstance:BUFFER-FIELD("i_page":U):BUFFER-VALUE,          /* iPage              */
                                      httObjectInstance:BUFFER-FIELD("i_column":U):BUFFER-VALUE,        /* iColumn            */
                                      httObjectInstance:BUFFER-FIELD("i_row":U):BUFFER-VALUE,           /* iRow               */
                                      lVisibleObject).                                                  /* lVisibleObject     */

  httObjectInstance:FIND-FIRST("WHERE d_object_instance_obj = ":U + QUOTER(dTargetObjectInstanceObj)).
  httObjectType:FIND-FIRST("WHERE d_object_type_obj = ":U + QUOTER(httObjectInstance:BUFFER-FIELD("d_object_type_obj":U):BUFFER-VALUE)).
  
  lVisibleObject = DYNAMIC-FUNCTION("isVisibleObjectType":U IN ghContainerSource, httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE).
  
  DYNAMIC-FUNCTION("setLinkObject":U, "SOURCE":U,                                                       /* cSourceTarget      */
                                      httObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE, /* cObjectName        */
                                      httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE,  /* cObjectType        */
                                      dTargetObjectInstanceObj,                                         /* dObjectInstanceObj */
                                      httObjectInstance:BUFFER-FIELD("i_page":U):BUFFER-VALUE,          /* iPage              */
                                      httObjectInstance:BUFFER-FIELD("i_column":U):BUFFER-VALUE,        /* iColumn            */
                                      httObjectInstance:BUFFER-FIELD("i_row":U):BUFFER-VALUE,           /* iRow               */
                                      lVisibleObject).                                                  /* lVisibleObject     */

  DO WITH FRAME {&FRAME-NAME}:
    buSwap:LOAD-IMAGE(IF INDEX(buSwap:IMAGE, "swap.gif":U) <> 0 THEN "ry/img/swapalt.gif":U ELSE "ry/img/swap.gif":U).
  END.

  DELETE OBJECT httObjectInstance.
  httObjectInstance = ?.
  
  APPLY "VALUE-CHANGED":U TO coLink IN FRAME {&FRAME-NAME}.
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgEditMenu vTableWin 
PROCEDURE trgEditMenu :
/*------------------------------------------------------------------------------
  Purpose:  Emulate the standard popup-menu functionality of fill-ins

  Parameters:  INPUT pcAction - Action to be processed for the edit popup-menu,
                                including MENU-DROP...

  Notes:  This is done because there is no way to pickup if a popup-menu has been
          dismissed / closed without using so that I can revert the popup-menu
          used in the grid back to the popup-menus needed for fill-ins.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcAction AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cParentContainerMode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContainerMode        AS CHARACTER  NO-UNDO.

  CASE pcAction:
    /* Here follows the initialization of the popup-menu (Menu drop) */
    WHEN "MENU-DROP":U THEN
    DO:
      ghEditPopupMenu[2]:SENSITIVE = FALSE.       /* Undo */

      IF ghSelf:SELECTION-TEXT <> "":U AND
         ghSelf:SELECTION-TEXT <> ?    THEN
        ASSIGN
            ghEditPopupMenu[4]:SENSITIVE = TRUE   /* Copy   */
            ghEditPopupMenu[5]:SENSITIVE = TRUE   /* Cut    */
            ghEditPopupMenu[7]:SENSITIVE = TRUE.  /* Delete */
      ELSE
        ASSIGN
            ghEditPopupMenu[4]:SENSITIVE = FALSE  /* Copy   */
            ghEditPopupMenu[5]:SENSITIVE = FALSE  /* Cut    */
            ghEditPopupMenu[7]:SENSITIVE = FALSE. /* Delete */

      /* Paste */
      IF CLIPBOARD:NUM-FORMATS > 0 THEN
        ghEditPopupMenu[6]:SENSITIVE = TRUE.
      ELSE
        ghEditPopupMenu[6]:SENSITIVE = FALSE.

      /* Select All */
      IF ghSelf:SCREEN-VALUE = "":U OR
         ghSelf:SCREEN-VALUE = ?    THEN
        ghEditPopupMenu[9]:SENSITIVE = FALSE.
      ELSE
        ghEditPopupMenu[9]:SENSITIVE = TRUE.
    END.

    /* Here follows the action processing of the popup-menu */
    WHEN "COPY":U   THEN ghSelf:EDIT-COPY().  /* Copy   */
    WHEN "CUT":U    THEN ghSelf:EDIT-CUT().   /* Cut    */
    WHEN "PASTE":U  THEN ghSelf:EDIT-PASTE(). /* Paste  */
    WHEN "DELETE":U THEN ghSelf:EDIT-CLEAR(). /* Delete */

    /* Select All */
    WHEN "SELECT ALL":U THEN
    DO:
      APPLY "ENTRY":U TO ghSelf.
      ghSelf:SET-SELECTION(1, LENGTH(ghSelf:SCREEN-VALUE) + 1).
    END.
  END CASE.
  
  IF LOOKUP(pcAction, "CUT,PASTE,DELETE":U) <> 0 THEN
  DO:
    ASSIGN
        cParentContainerMode = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U).
        cContainerMode       = DYNAMIC-FUNCTION("getUserProperty":U, "ContainerMode":U).

    IF cParentContainerMode <> "UPDATE":U AND
       cParentContainerMode <> "ADD":U    AND
       cContainerMode       <> "ADD":U    THEN
    DO:
      DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "UPDATE":U).
      DYNAMIC-FUNCTION("evaluateActions":U IN ghContainerSource).
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgEndMove vTableWin 
PROCEDURE trgEndMove :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phMovedGridObject  AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE cMessageType            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectView             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lDone                   AS LOGICAL    NO-UNDO.

  DEFINE BUFFER ttSourceObject   FOR ttWidget.
  DEFINE BUFFER ttTargetObject   FOR ttWidget.
  DEFINE BUFFER ttWidget         FOR ttWidget.

  /* Find the source object */
  FIND ttSourceObject WHERE
       ttSourceObject.hHandle = phMovedGridObject.
  
  /* Put the image widget that was moved back to its original place */
  ASSIGN
      phMovedGridObject:X = ttSourceObject.X
      phMovedGridObject:Y = ttSourceObject.Y.

  DO WITH FRAME {&FRAME-NAME}:
    /* See if the object instance was dragged over the source area in the Quick-Link section */
    IF LAST-EVENT:X <  rctQuickLink:WIDTH-PIXELS / 2 AND
       LAST-EVENT:Y >= rctQuickLink:Y                THEN
    DO:
      RUN setSourceTarget (INPUT phMovedGridObject, INPUT "LS":U).

      DYNAMIC-FUNCTION("removeTargets":U).

      RETURN.
    END.

    /* See if the object instance was dragged over the target area in the Quick-Link section */
    IF LAST-EVENT:X >  rctQuickLink:WIDTH-PIXELS / 2 AND
       LAST-EVENT:Y >= rctQuickLink:Y                THEN
    DO:
      RUN setSourceTarget (INPUT phMovedGridObject, INPUT "LT":U).

      DYNAMIC-FUNCTION("removeTargets":U).

      RETURN.
    END.
  END.

  /* Try and find the target widget */
  FIND FIRST ttTargetObject
       WHERE ttTargetObject.X > LAST-EVENT:X - giColumnWidth
         AND ttTargetObject.Y > LAST-EVENT:Y - giRowHeight NO-ERROR.

  IF NOT AVAILABLE ttTargetObject THEN
    RETURN.

  DYNAMIC-FUNCTION("setSelectedWidget":U, ttSourceObject.hHandle).

  ghTargetObject = ttTargetObject.hHandle.

  IF ghTargetObject = ttSourceObject.hHandle THEN
  DO:
    ghTargetObject = ?.
    DYNAMIC-FUNCTION("showHighlights":U).

    RETURN.
  END.

  IF ttTargetObject.lAvailable = FALSE THEN
  DO:
    /*DYNAMIC-FUNCTION("showHighlights":U).*/

    IF ttSourceObject.hHandle <> ghTargetObject THEN
    DO:
      IF DYNAMIC-FUNCTION("evaluateJustification":U, ?, ttTargetObject.iRow, ttSourceObject.cLCR) = FALSE AND
         DYNAMIC-FUNCTION("areSameAlignment":U, ttSourceObject.hHandle, ghTargetObject)           = FALSE AND
         DYNAMIC-FUNCTION("areWidgetsOnSameRow":U,       ttSourceObject.hHandle, ghTargetObject)  = FALSE THEN
        ASSIGN
            cMessageType = "INF":U
            cMessage     = "Because of the layout of the source object ('" + TRIM(ttSourceObject.cObject)
                         + "'), you are not allowed to swap these objects.".
      ELSE
        IF (DYNAMIC-FUNCTION("evaluateJustification":U, ?, ttTargetObject.iRow, ttTargetObject.cLCR) = FALSE  OR
            DYNAMIC-FUNCTION("evaluateJustification":U, ?, ttSourceObject.iRow, ttTargetObject.cLCR) = FALSE) AND
            DYNAMIC-FUNCTION("areSameAlignment":U, ttSourceObject.hHandle, ghTargetObject)           = FALSE  AND
            DYNAMIC-FUNCTION("areWidgetsOnSameRow":U,       ttSourceObject.hHandle, ghTargetObject)  = FALSE  THEN
          ASSIGN
              cMessageType = "INF":U
              cMessage     = "Because of the layout of the target object ('" + TRIM(ttTargetObject.cObject)
                           + "'), you are not allowed to swap these objects.".
        ELSE
        DO:
          DYNAMIC-FUNCTION("swapSourceTarget", ttSourceObject.hHandle, ghTargetObject, TRUE).

          RUN newSave.
        END.
        
        IF cMessage <> "":U THEN 
          RUN showMessages IN gshSessionManager (INPUT  cMessage,                             /* message to display */
                                                 INPUT  cMessageType,                         /* error type         */
                                                 INPUT  "&OK":U,                              /* button list        */
                                                 INPUT  "&OK":U,                              /* default button     */ 
                                                 INPUT  "&OK":U,                              /* cancel button      */
                                                 INPUT  "Swapping of objects not possible":U, /* error window title */
                                                 INPUT  YES,                                  /* display if empty   */ 
                                                 INPUT  THIS-PROCEDURE,                       /* container handle   */ 
                                                 OUTPUT cButton).                             /* button pressed     */
    END.

    ASSIGN
        ghTargetObject = ?.

    DYNAMIC-FUNCTION("showHighlights":U).
    DYNAMIC-FUNCTION("removeTargets":U).
  END.
  ELSE
    IF ttTargetObject.lAvailable = ? THEN
    DO:
      MESSAGE "That is not an available layout position...".

      ghTargetObject = ?.
      DYNAMIC-FUNCTION("showHighlights":U).
      DYNAMIC-FUNCTION("removeTargets":U).
    END.
    ELSE
    DO:
      DYNAMIC-FUNCTION("swapSourceTarget", ttSourceObject.hHandle, ghTargetObject, TRUE).
      DYNAMIC-FUNCTION("showHighlights":U).
      DYNAMIC-FUNCTION("removeTargets":U).

      ASSIGN
          ghTargetObject   = ?
          ghPreviousWidget = ttTargetObject.hHandle

          ghObjectInstance:BUFFER-FIELD("i_row":U):BUFFER-VALUE             = ttTargetObject.iRow
          ghObjectInstance:BUFFER-FIELD("i_column":U):BUFFER-VALUE          = ttTargetObject.iCol
          ghObjectInstance:BUFFER-FIELD("i_page":U):BUFFER-VALUE            = DYNAMIC-FUNCTION("getPageSequence":U IN ghContainerSource, ?)
          ghObjectInstance:BUFFER-FIELD("c_layout_position":U):BUFFER-VALUE = DYNAMIC-FUNCTION("getLayoutCode":U, FALSE).

      RUN newSave.
      
      IF {fnarg getUserProperty 'CoCMode':U} <> "Off":U THEN
        DYNAMIC-FUNCTION("showTargets":U, ?).
    END.

  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgLookupValueChanged vTableWin 
PROCEDURE trgLookupValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phLookup AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cScreenValue  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSuccess      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iOffset       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hLookupFillIn AS HANDLE     NO-UNDO.


  RUN valueChanged in phLookup NO-ERROR.

  IF {fnarg getUserProperty 'ContainerMode':U} <> "ADD":U THEN
  DO:
    ASSIGN
        hLookupFillIn = {fn getLookupHandle phLookup}
        cScreenValue  = hLookupFillIn:SCREEN-VALUE
        iOffset       = hLookupFillIn:CURSOR-OFFSET
        lSuccess      = {fnarg setDataValue 0.00 phLookup}
        lSuccess      = {fnarg setDataModified YES phLookup}.

    /* This is the worst workaround I have ever had to implement - simply because you
       cannot assign the SCREEN-VALUE of a widget to 'Object  ' - where you have trailing
       spaces. The trailing spaces are trimmed of - by default and there is NOTHING you
       can do about it. CHR(160) is a character that looks like a space, but is not - and
       this is used to fill up the places there should be spaces */
    IF LENGTH(cScreenValue) < iOffset - 1 THEN
    DO:
      DO WHILE LENGTH(cScreenValue) < iOffset - 1:
        cScreenValue = cScreenValue + CHR(160).
      END.
    END.
    ELSE
      cScreenValue = REPLACE(cScreenValue, CHR(160), " ":U).

    ASSIGN
        hLookupFillIn:SCREEN-VALUE  = cScreenValue
        hLookupFillIn:CURSOR-OFFSET = iOffset.
  END.

  {fnarg setUserProperty "'DontDisplay':U, 'No':U"}.

  IF {fnarg getUserProperty 'ContainerMode':U} <> "ADD":U THEN
    RUN newSave.

  {fnarg setUserProperty "'DontDisplay':U, 'Yes':U"}.

  IF {fnarg getUserProperty 'ContainerMode':U} <> "ADD":U THEN
    buReset:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgMenuChoose vTableWin 
PROCEDURE trgMenuChoose :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phWidget   AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER pcAction   AS CHARACTER  NO-UNDO.

  DEFINE BUFFER ttWidget FOR ttWidget.

  CASE pcAction:
    /* Requesting the Property Sheet */
    WHEN "PROPERTIES":U THEN
      RUN setProperties.

    WHEN "OLDPROPERTIES":U THEN
      APPLY "CHOOSE":U TO buOldProperties IN FRAME {&FRAME-NAME}.
    
    /* Setting of the Source and Target link objects */
    WHEN "LSTO":U OR
    WHEN "LS":U   OR
    WHEN "LTTO":U OR
    WHEN "LT":U   THEN
      RUN setSourceTarget (INPUT phWidget,
                           INPUT pcAction).

    /* Pasting the cut object */
    WHEN "Paste":U THEN
      RUN pasteObject (INPUT phWidget).

    /* Flagging the selected object to be cut */
    WHEN "Cut":U THEN
    DO:
      FIND ttWidget WHERE
           ttWidget.hHandle = phWidget.

      DYNAMIC-FUNCTION("setUserProperty":U, "CoCMode", "Off":U).
      DYNAMIC-FUNCTION("removeTargets":U).

      ASSIGN
          gdCoCInstanceObj = ttWidget.dObjectInstanceObj
          glCoCVisible     = ghObjectInstance:BUFFER-FIELD("l_visible_object":U):BUFFER-VALUE.

      DYNAMIC-FUNCTION("setUserProperty":U, "CoCMode", "Cut":U).
      DYNAMIC-FUNCTION("showTargets":U, ?).
    END.

    /* Flagging the selected object to be copied */
    WHEN "Copy":U THEN
    DO:
      FIND ttWidget WHERE
           ttWidget.hHandle = phWidget.

      DYNAMIC-FUNCTION("setUserProperty":U, "CoCMode", "Off":U).
      DYNAMIC-FUNCTION("removeTargets":U).

      ASSIGN
          gdCoCInstanceObj = ttWidget.dObjectInstanceObj
          glCoCVisible     = ghObjectInstance:BUFFER-FIELD("l_visible_object":U):BUFFER-VALUE.

      DYNAMIC-FUNCTION("setUserProperty":U, "CoCMode", "Copy":U).
      DYNAMIC-FUNCTION("showTargets":U, ?).
    END.

    /* Clearing the object flagged as the one to be cut */
    WHEN "ClearCut":U THEN
    DO:
      DYNAMIC-FUNCTION("setUserProperty":U, "CoCMode", "Off":U).

      IF NOT VALID-HANDLE(ghPreviousWidget) THEN
      DO:
        FIND FIRST ttWidget
             WHERE ttWidget.lAvailable = FALSE NO-ERROR.

        IF AVAILABLE ttWidget THEN
          DYNAMIC-FUNCTION("setSelectedWidget":U, ttWidget.hHandle).
      END.
      ELSE
        DYNAMIC-FUNCTION("setSelectedWidget":U, ghPreviousWidget).

      DYNAMIC-FUNCTION("showHighlights":U).
      DYNAMIC-FUNCTION("removeTargets":U).

      ASSIGN
          gdCoCInstanceObj = 0.00
          glCoCVisible     = ?.
    END.

    /* Setting of the justification */
    OTHERWISE
    DO:
      FIND ttWidget WHERE
           ttWidget.hHandle = phWidget NO-ERROR.

      IF AVAILABLE ttWidget THEN
      DO:
        ASSIGN
            ttWidget.cLCR                             = pcAction
            raLCR:SCREEN-VALUE IN FRAME {&FRAME-NAME} = pcAction
            ghObjectInstance:BUFFER-FIELD("c_layout_position":U):BUFFER-VALUE = DYNAMIC-FUNCTION("getLayoutCode":U, FALSE).

        DYNAMIC-FUNCTION("setWidgetProperties":U, INPUT phWidget).
        DYNAMIC-FUNCTION("evaluateRadioSet":U, BUFFER ttWidget).
      END.

      ghObjectInstance:BUFFER-FIELD("c_lcr":U):BUFFER-VALUE = pcAction.

      RUN newSave.

      IF {fnarg getUserProperty 'CoCMode':U} <> "Off":U THEN
      DO:
        DYNAMIC-FUNCTION("removeTargets":U).
        DYNAMIC-FUNCTION("showTargets":U, ?).
      END.
    END.
  END CASE.

  DYNAMIC-FUNCTION("removePopupMenu":U).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgMenuDrop vTableWin 
PROCEDURE trgMenuDrop :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phWidget   AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cDataLogicProcedure AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSuperProcedure     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContainerMode      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSelectedWidget     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataObject         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lDbAware            AS LOGICAL    NO-UNDO.
  DEFINE BUFFER ttWidget FOR ttWidget.

  ASSIGN
      hSelectedWidget = DYNAMIC-FUNCTION("getSelectedWidget":U)
      cContainerMode  = DYNAMIC-FUNCTION("getUserProperty":U, "ContainerMode":U).
  
  FIND ttWidget WHERE
       ttWidget.hHandle = phWidget.

  IF ghObjectInstance:AVAILABLE THEN
  DO:
    ASSIGN
        cDataLogicProcedure = {fnarg getAttributeValue "ghObjectInstance:BUFFER-FIELD('d_object_instance_obj':U):BUFFER-VALUE, 'DataLogicProcedure'" ghContainerSource}
        cSuperProcedure     = {fnarg getAttributeValue "ghObjectInstance:BUFFER-FIELD('d_object_instance_obj':U):BUFFER-VALUE, 'SuperProcedure':U"   ghContainerSource}.

    IF cDataLogicProcedure = "?":U OR cDataLogicProcedure = ? THEN
      cDataLogicProcedure = "":U.

    IF cSuperProcedure = "?":U OR cSuperProcedure = ? THEN
      cSuperProcedure = "":U.

    IF NOT DYNAMIC-FUNCTION("isVisibleObjectType":U IN ghContainerSource, ttWidget.cObjectType) THEN
    DO:
      RUN clearClientCache IN gshRepositoryManager NO-ERROR.
      RUN startDataObject  IN gshRepositoryManager (INPUT  ghObjectInstance:BUFFER-FIELD('c_smartobject_filename':U):BUFFER-VALUE,
                                                    OUTPUT hDataObject) NO-ERROR.

      /* Attempt to find the DataLogicProcedure and SuperProcedure from the DataObject 
         if it could not be found in the Attributes */
      IF VALID-HANDLE(hDataObject) THEN
      DO:
        /* only dbaware data objects uses DLPs (the DataView does not */
        {get DBAware lDbAware hDataObject}.
        IF lDbAware AND cDataLogicProcedure = "":U THEN
          {get DataLogicProcedure cDataLogicProcedure hDataObject}.
        
        IF cSuperProcedure = "":U THEN
          {get SuperProcedure cSuperProcedure hDataObject}.

        RUN destroyObject IN hDataObject.
      END.
    END.
  END.

  IF VALID-HANDLE(ghPopupMenuItems[8]) THEN ghPopupMenuItems[8]:LABEL = ttWidget.cObject + " (":U + ttWidget.cObjectType + ")":U.
  IF VALID-HANDLE(ghPopupMenuItems[9]) THEN ghPopupMenuItems[9]:LABEL = ghPopupMenuItems[8]:LABEL.

  IF phWidget = hSelectedWidget THEN
  DO:
    /* Don't enable the alignment menu item for the object's current alignment state,
       i.e. if an object is left aligned, set the check mark on the menu item and
       disable this menu item so the user cannot select it again */
    IF DYNAMIC-FUNCTION("isVisibleObjectType":U IN ghContainerSource, ttWidget.cObjectType) THEN
    DO:
      CASE ttWidget.cLCR:
        WHEN "L":U THEN IF VALID-HANDLE(ghPopupMenuItems[1]) THEN ghPopupMenuItems[1]:CHECKED = TRUE.
        WHEN "C":U THEN IF VALID-HANDLE(ghPopupMenuItems[2]) THEN ghPopupMenuItems[2]:CHECKED = TRUE.
        WHEN "R":U THEN IF VALID-HANDLE(ghPopupMenuItems[3]) THEN ghPopupMenuItems[3]:CHECKED = TRUE.
      END CASE.
  
      /* Evaluate what popup menu items are allowed to be enabled */
      IF VALID-HANDLE(ghPopupMenuItems[1]) THEN ghPopupMenuItems[1]:SENSITIVE = DYNAMIC-FUNCTION("evaluateJustification":U, phWidget, ttWidget.iRow, "L":U).
      IF VALID-HANDLE(ghPopupMenuItems[2]) THEN ghPopupMenuItems[2]:SENSITIVE = DYNAMIC-FUNCTION("evaluateJustification":U, phWidget, ttWidget.iRow, "C":U).
      IF VALID-HANDLE(ghPopupMenuItems[3]) THEN ghPopupMenuItems[3]:SENSITIVE = DYNAMIC-FUNCTION("evaluateJustification":U, phWidget, ttWidget.iRow, "R":U).
    END.

    /* Cut */
    IF ttWidget.dObjectInstanceObj <> 0.00       AND
       cContainerMode              <> "UPDATE":U THEN
    DO:
      IF VALID-HANDLE(ghPopupMenuItems[13]) THEN ghPopupMenuItems[13]:SENSITIVE = TRUE.
      IF VALID-HANDLE(ghPopupMenuItems[18]) THEN ghPopupMenuItems[18]:SENSITIVE = (IF LOOKUP(ttWidget.cObjectType, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "SmartFolder":U)) > 0 THEN FALSE ELSE TRUE).
    END.
    ELSE
    DO:
      IF VALID-HANDLE(ghPopupMenuItems[13]) THEN ghPopupMenuItems[13]:SENSITIVE = FALSE.
      IF VALID-HANDLE(ghPopupMenuItems[18]) THEN ghPopupMenuItems[18]:SENSITIVE = FALSE.
    END.

    /* Paste */
    IF ttWidget.dObjectInstanceObj = 0.00       AND
       gdCoCInstanceObj           <> 0.00       AND
       cContainerMode             <> "UPDATE":U THEN
    DO:
       IF VALID-HANDLE(ghPopupMenuItems[14]) THEN ghPopupMenuItems[14]:SENSITIVE = TRUE.
    END.
    ELSE
       IF VALID-HANDLE(ghPopupMenuItems[14]) THEN ghPopupMenuItems[14]:SENSITIVE = FALSE.
  END.
  ELSE
  DO:
    IF DYNAMIC-FUNCTION("isVisibleObjectType":U IN ghContainerSource, ttWidget.cObjectType) THEN
    DO:
      IF VALID-HANDLE(ghPopupMenuItems[1]) THEN ghPopupMenuItems[1]:SENSITIVE  = FALSE.
      IF VALID-HANDLE(ghPopupMenuItems[2]) THEN ghPopupMenuItems[2]:SENSITIVE  = FALSE.
      IF VALID-HANDLE(ghPopupMenuItems[3]) THEN ghPopupMenuItems[3]:SENSITIVE  = FALSE.
    END.

    IF VALID-HANDLE(ghPopupMenuItems[13]) THEN ghPopupMenuItems[13]:SENSITIVE = FALSE.
    IF VALID-HANDLE(ghPopupMenuItems[18]) THEN ghPopupMenuItems[18]:SENSITIVE = FALSE.
    IF VALID-HANDLE(ghPopupMenuItems[16]) THEN ghPopupMenuItems[16]:SENSITIVE = FALSE.
    IF VALID-HANDLE(ghPopupMenuItems[23]) THEN ghPopupMenuItems[23]:SENSITIVE = FALSE.
    
    IF ttWidget.lAvailable = FALSE THEN
      IF VALID-HANDLE(ghPopupMenuItems[14]) THEN ghPopupMenuItems[14]:SENSITIVE = FALSE.
  END.

  IF ttWidget.cObject = "":U THEN
  DO:
    IF VALID-HANDLE(ghPopupMenuItems[5]) THEN ghPopupMenuItems[5]:SENSITIVE  = FALSE.
    IF VALID-HANDLE(ghPopupMenuItems[6]) THEN ghPopupMenuItems[6]:SENSITIVE  = FALSE.
  END.
  ELSE
  DO:
    IF VALID-HANDLE(ghPopupMenuItems[5]) THEN ghPopupMenuItems[5]:SENSITIVE  = TRUE.
    IF VALID-HANDLE(ghPopupMenuItems[6]) THEN ghPopupMenuItems[6]:SENSITIVE  = TRUE.
  END.

  IF gdCoCInstanceObj = 0.00 THEN
    IF VALID-HANDLE(ghPopupMenuItems[17]) THEN ghPopupMenuItems[17]:SENSITIVE = FALSE.

  /* Set the state of the delete item */
  IF VALID-HANDLE(ghPopupMenuItems[20]) THEN ghPopupMenuItems[20]:SENSITIVE = buDelete:SENSITIVE IN FRAME {&FRAME-NAME}.
  IF VALID-HANDLE(ghPopupMenuItems[23]) THEN ghPopupMenuItems[23]:SENSITIVE = buOldProperties:SENSITIVE IN FRAME {&FRAME-NAME}.

  IF VALID-HANDLE(ghPopupMenuItems[24]) THEN ghPopupMenuItems[24]:SENSITIVE = NOT (cSuperProcedure     = "?":U OR cSuperProcedure     = "":U OR cSuperProcedure     = ?).
  IF VALID-HANDLE(ghPopupMenuItems[25]) THEN ghPopupMenuItems[25]:SENSITIVE = NOT (cDataLogicProcedure = "?":U OR cDataLogicProcedure = "":U OR cDataLogicProcedure = ?).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgMouseMenuDown vTableWin 
PROCEDURE trgMouseMenuDown :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phWidget   AS HANDLE     NO-UNDO.

  DEFINE BUFFER ttWidget FOR ttWidget.

  /* Remove the existing popup menu. This is done to ensure the correct handle will be passed to the trigger procedure */
  DYNAMIC-FUNCTION("removePopupMenu":U).

  DEFINE VARIABLE cContainerMode  AS CHARACTER  NO-UNDO.
  
  cContainerMode = DYNAMIC-FUNCTION("getUserProperty":U, "ContainerMode":U).

  ASSIGN
      /* Ensure we point to the actual object widget. (An alignment widget could have been selected */
      phWidget       = DYNAMIC-FUNCTION("getWidgetHandle":U, INPUT phWidget)
      ghTargetObject = ?.

  IF cContainerMode <> "UPDATE":U THEN
  DO:
    DYNAMIC-FUNCTION("setSelectedWidget":U, phWidget).
    DYNAMIC-FUNCTION("showHighlights":U).
  END.

  FRAME {&FRAME-NAME}:POPUP-MENU = ?.

  FIND FIRST ttWidget
       WHERE ttWidget.hHandle = phWidget.

  IF glComplete = FALSE THEN
  DO:
    RUN trgMouseSelectClick (INPUT phWidget).

    RETURN.
  END.
  ELSE
    IF (ttWidget.lAvailable = TRUE AND glComplete = TRUE) THEN
      RUN trgMouseSelectClick (INPUT phWidget).

  FIND FIRST ttWidget
       WHERE ttWidget.hHandle = phWidget.

  /* We are not interested in showing the popup menu for grid objects that do not have an associated object */
  IF ttWidget.lAvailable = ? THEN
    RETURN.

  /* Create the popup menu and associated sub-menu items */
  CREATE MENU ghPopupMenu IN WIDGET-POOL STRING(THIS-PROCEDURE)
    ASSIGN
        POPUP-ONLY = TRUE
    TRIGGERS:
      ON "MENU-DROP":U      PERSISTENT RUN trgMenuDrop IN THIS-PROCEDURE (INPUT phWidget).
      /*ON "":U PERSISTENT RUN trgMenuGo   IN THIS-PROCEDURE.*/
    END TRIGGERS.

  /* If ttWidget.lAvailable is true, it means we are right-clicking on a target location */
  IF DYNAMIC-FUNCTION("isVisibleObjectType":U IN ghContainerSource, ttWidget.cObjectType) AND ttWidget.lAvailable = FALSE THEN
  DO:
    /* Menu Items */
    /* Align Left, Center, Right */
    CREATE MENU-ITEM ghPopupMenuItems[1] IN WIDGET-POOL STRING(THIS-PROCEDURE)
      ASSIGN
          TOGGLE-BOX = TRUE
          PARENT     = ghPopupMenu
          LABEL      = "Left aligned":U
      TRIGGERS:
        ON "VALUE-CHANGED":U PERSISTENT RUN trgMenuChoose IN THIS-PROCEDURE (INPUT phWidget, INPUT "L":U).
      END TRIGGERS.
    
    CREATE MENU-ITEM ghPopupMenuItems[2] IN WIDGET-POOL STRING(THIS-PROCEDURE)
      ASSIGN
          TOGGLE-BOX = TRUE
          PARENT     = ghPopupMenu
          LABEL      = "Center aligned":U
      TRIGGERS:
        ON "VALUE-CHANGED":U PERSISTENT RUN trgMenuChoose IN THIS-PROCEDURE (INPUT phWidget, INPUT "C":U).
      END TRIGGERS.
    
    CREATE MENU-ITEM ghPopupMenuItems[3] IN WIDGET-POOL STRING(THIS-PROCEDURE)
      ASSIGN
          TOGGLE-BOX = TRUE
          PARENT     = ghPopupMenu
          LABEL      = "Right aligned":U
      TRIGGERS:
        ON "VALUE-CHANGED":U PERSISTENT RUN trgMenuChoose IN THIS-PROCEDURE (INPUT phWidget, INPUT "R":U).
      END TRIGGERS.

    /* Rule2 */
    CREATE MENU-ITEM ghPopupMenuItems[4] IN WIDGET-POOL STRING(THIS-PROCEDURE)
      ASSIGN
          PARENT  = ghPopupMenu
          SUBTYPE = "RULE":U.
  END.

  /* If ttWidget.lAvailable is true, it means we are right-clicking on a target location */
  IF ttWidget.lAvailable = FALSE THEN
  DO:
    /* Quick-Link SubMenu */
    CREATE SUB-MENU ghPopupMenuItems[5] IN WIDGET-POOL STRING(THIS-PROCEDURE)
      ASSIGN
          PARENT  = ghPopupMenu
          LABEL   = "Quick-Link Source" .

    /* Source SubMenu */
    CREATE SUB-MENU ghPopupMenuItems[6] IN WIDGET-POOL STRING(THIS-PROCEDURE)
      ASSIGN
          PARENT  = ghPopupMenu
          LABEL   = "Quick-Link Target" .

    /* Link Source and Target */
    CREATE MENU-ITEM ghPopupMenuItems[8] IN WIDGET-POOL STRING(THIS-PROCEDURE)
      ASSIGN
          TOGGLE-BOX = TRUE
          PARENT     = ghPopupMenuItems[5]
          LABEL      = "":U
      TRIGGERS:
        ON "VALUE-CHANGED":U PERSISTENT RUN trgMenuChoose IN THIS-PROCEDURE (INPUT phWidget, INPUT "LS":U).
      END TRIGGERS.

    CREATE MENU-ITEM ghPopupMenuItems[9] IN WIDGET-POOL STRING(THIS-PROCEDURE)
      ASSIGN
          TOGGLE-BOX = TRUE
          PARENT     = ghPopupMenuItems[6]
          LABEL      = "":U
      TRIGGERS:
        ON "VALUE-CHANGED":U PERSISTENT RUN trgMenuChoose IN THIS-PROCEDURE (INPUT phWidget, INPUT "LT":U).
      END TRIGGERS.

    /* Link Source and Target */
    CREATE MENU-ITEM ghPopupMenuItems[10] IN WIDGET-POOL STRING(THIS-PROCEDURE)
      ASSIGN
          TOGGLE-BOX = TRUE
          PARENT     = ghPopupMenuItems[5]
          LABEL      = "THIS-OBJECT":U
      TRIGGERS:
        ON "VALUE-CHANGED":U PERSISTENT RUN trgMenuChoose IN THIS-PROCEDURE (INPUT phWidget, INPUT "LSTO":U).
      END TRIGGERS.

    CREATE MENU-ITEM ghPopupMenuItems[11] IN WIDGET-POOL STRING(THIS-PROCEDURE)
      ASSIGN
          TOGGLE-BOX = TRUE
          PARENT     = ghPopupMenuItems[6]
          LABEL      = "THIS-OBJECT":U
      TRIGGERS:
        ON "VALUE-CHANGED":U PERSISTENT RUN trgMenuChoose IN THIS-PROCEDURE (INPUT phWidget, INPUT "LTTO":U).
      END TRIGGERS.

    /* Rule3 */
    CREATE MENU-ITEM ghPopupMenuItems[12] IN WIDGET-POOL STRING(THIS-PROCEDURE)
      ASSIGN
          PARENT  = ghPopupMenu
          SUBTYPE = "RULE":U.
  END.

  /* Cut, Copy and Paste */
  CREATE MENU-ITEM ghPopupMenuItems[13] IN WIDGET-POOL STRING(THIS-PROCEDURE)
    ASSIGN
        TOGGLE-BOX = TRUE
        PARENT     = ghPopupMenu
        LABEL      = "Cut":U
    TRIGGERS:
      ON "VALUE-CHANGED":U PERSISTENT RUN trgMenuChoose IN THIS-PROCEDURE (INPUT phWidget, INPUT "Cut":U).
    END TRIGGERS.

  CREATE MENU-ITEM ghPopupMenuItems[18] IN WIDGET-POOL STRING(THIS-PROCEDURE)
    ASSIGN
        TOGGLE-BOX = TRUE
        PARENT     = ghPopupMenu
        LABEL      = "Copy":U
    TRIGGERS:
      ON "VALUE-CHANGED":U PERSISTENT RUN trgMenuChoose IN THIS-PROCEDURE (INPUT phWidget, INPUT "Copy":U).
    END TRIGGERS.

  CREATE MENU-ITEM ghPopupMenuItems[17] IN WIDGET-POOL STRING(THIS-PROCEDURE)
    ASSIGN
        TOGGLE-BOX = TRUE
        PARENT     = ghPopupMenu
        LABEL      = "Cancel Cut/Copy":U
    TRIGGERS:
      ON "VALUE-CHANGED":U PERSISTENT RUN trgMenuChoose IN THIS-PROCEDURE (INPUT phWidget, INPUT "ClearCut":U).
    END TRIGGERS.
    
  CREATE MENU-ITEM ghPopupMenuItems[14] IN WIDGET-POOL STRING(THIS-PROCEDURE)
    ASSIGN
        TOGGLE-BOX = TRUE
        PARENT     = ghPopupMenu
        LABEL      = "Paste":U
    TRIGGERS:
      ON "VALUE-CHANGED":U PERSISTENT RUN trgMenuChoose IN THIS-PROCEDURE (INPUT phWidget, INPUT "Paste":U).
    END TRIGGERS.
    
  /* If ttWidget.lAvailable is true, it means we are right-clicking on a target location */
  IF ttWidget.lAvailable = FALSE THEN
  DO:
    /* Rule1 */
    CREATE MENU-ITEM ghPopupMenuItems[15] IN WIDGET-POOL STRING(THIS-PROCEDURE)
      ASSIGN
          PARENT  = ghPopupMenu
          SUBTYPE = "RULE":U.

    /* Edit in AppBuilder */
    CREATE MENU-ITEM ghPopupMenuItems[21] IN WIDGET-POOL STRING(THIS-PROCEDURE)
      ASSIGN
          TOGGLE-BOX = TRUE
          PARENT     = ghPopupMenu
          LABEL      = "Edit Master...":U
      TRIGGERS:
        ON "VALUE-CHANGED":U PERSISTENT RUN editInAppBuilder IN THIS-PROCEDURE (INPUT "Master":U).
      END TRIGGERS.

    CREATE MENU-ITEM ghPopupMenuItems[24] IN WIDGET-POOL STRING(THIS-PROCEDURE)
      ASSIGN
          TOGGLE-BOX = TRUE
          PARENT     = ghPopupMenu
          LABEL      = "Edit SuperProcedure...":U
      TRIGGERS:
        ON "VALUE-CHANGED":U PERSISTENT RUN editInAppBuilder IN THIS-PROCEDURE (INPUT "SuperProcedure":U).
      END TRIGGERS.

    CREATE MENU-ITEM ghPopupMenuItems[25] IN WIDGET-POOL STRING(THIS-PROCEDURE)
      ASSIGN
          TOGGLE-BOX = TRUE
          PARENT     = ghPopupMenu
          LABEL      = "Edit DataLogicProcedure...":U
      TRIGGERS:
        ON "VALUE-CHANGED":U PERSISTENT RUN editInAppBuilder IN THIS-PROCEDURE (INPUT "DataLogicProcedure":U).
      END TRIGGERS.

    /* Rule */
    CREATE MENU-ITEM ghPopupMenuItems[22] IN WIDGET-POOL STRING(THIS-PROCEDURE)
      ASSIGN
          PARENT  = ghPopupMenu
          SUBTYPE = "RULE":U.

    CREATE MENU-ITEM ghPopupMenuItems[20] IN WIDGET-POOL STRING(THIS-PROCEDURE)
      ASSIGN
          TOGGLE-BOX = TRUE
          PARENT     = ghPopupMenu
          LABEL      = "Delete":U
      TRIGGERS:
        ON "VALUE-CHANGED":U PERSISTENT RUN deleteRecord IN THIS-PROCEDURE.
      END TRIGGERS.

    /* Rule1 */
    CREATE MENU-ITEM ghPopupMenuItems[19] IN WIDGET-POOL STRING(THIS-PROCEDURE)
      ASSIGN
          PARENT  = ghPopupMenu
          SUBTYPE = "RULE":U.

    /* Properties */
    CREATE MENU-ITEM ghPopupMenuItems[23] IN WIDGET-POOL STRING(THIS-PROCEDURE)
      ASSIGN
          PARENT = ghPopupMenu
          LABEL  = "Object Properties...":U
      TRIGGERS:
        ON "CHOOSE":U PERSISTENT RUN trgMenuChoose IN THIS-PROCEDURE (INPUT phWidget, INPUT "OLDPROPERTIES":U).
      END TRIGGERS.  

    /* Properties */
    CREATE MENU-ITEM ghPopupMenuItems[16] IN WIDGET-POOL STRING(THIS-PROCEDURE)
      ASSIGN
          PARENT = ghPopupMenu
          LABEL  = "Dynamic Properties...":U
      TRIGGERS:
        ON "CHOOSE":U PERSISTENT RUN trgMenuChoose IN THIS-PROCEDURE (INPUT phWidget, INPUT "PROPERTIES":U).
      END TRIGGERS.  
  END.
  
  FRAME {&FRAME-NAME}:POPUP-MENU = ghPopupMenu.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgMouseSelectClick vTableWin 
PROCEDURE trgMouseSelectClick :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phWidget  AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cCutOrCopyMode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContainerMode  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iCursorOffset             AS INTEGER    NO-UNDO INITIAL ?.
  DEFINE VARIABLE hFocusWidget              AS HANDLE     NO-UNDO.

  IF VALID-HANDLE(ghInLookup) THEN
    hFocusWidget = ghInLookup.
  ELSE
  DO:
    /* Set hFocusWidget to focused widget if it is in active window
       otherwise is left as unknown */
    IF VALID-HANDLE(FOCUS)
       AND CAN-QUERY(FOCUS, "WINDOW")
       AND (FOCUS:WINDOW = ACTIVE-WINDOW) THEN
          hFocusWidget = FOCUS:HANDLE.
  END.

  IF VALID-HANDLE(hFocusWidget) AND CAN-QUERY(hFocusWidget, "CURSOR-OFFSET":U) THEN
    iCursorOffset = hFocusWidget:CURSOR-OFFSET.

  DEFINE BUFFER ttWidget  FOR ttWidget.

  ASSIGN
      cContainerMode   = DYNAMIC-FUNCTION("getUserProperty":U, "ContainerMode":U)
      cCutOrCopyMode   = DYNAMIC-FUNCTION("getUserProperty":U, "CoCMode":U).

  {fnarg lockWindow TRUE ghContainerSource}.

  IF cContainerMode <> "UPDATE":U THEN
  DO WITH FRAME {&FRAME-NAME}:
    phWidget = DYNAMIC-FUNCTION("getWidgetHandle":U, INPUT phWidget).

    FIND FIRST ttWidget
         WHERE ttWidget.hHandle = phWidget.

    IF ttWidget.lAvailable = FALSE THEN
      ghPreviousWidget = phWidget.

    DYNAMIC-FUNCTION("setSelectedWidget":U, phWidget).

    ghTargetObject = ?.

    IF cContainerMode <> "ADD":U AND {fnarg getUserProperty 'CoCMode':U} = "Off":U THEN
      DYNAMIC-FUNCTION("removeTargets":U).

    DYNAMIC-FUNCTION("evaluateActions":U).
    DYNAMIC-FUNCTION("showHighlights":U).

    IF cContainerMode = "ADD":U THEN
    DO:
      ASSIGN
          ghObjectInstance:BUFFER-FIELD("i_column":U):BUFFER-VALUE = ttWidget.iCol
          ghObjectInstance:BUFFER-FIELD("i_row":U):BUFFER-VALUE = ttWidget.iRow.

      RUN updatePageObject.
      RUN newSave.
    END.
  END.

  IF VALID-HANDLE(hFocusWidget) THEN
  DO:
    APPLY "ENTRY":U TO hFocusWidget.

    IF CAN-QUERY(hFocusWidget, "CURSOR-OFFSET":U) THEN
      hFocusWidget:CURSOR-OFFSET = (IF iCursorOffSet = ? THEN 1 ELSE iCursorOffset).
  END.

  {fnarg lockWindow FALSE ghContainerSource}.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgStartMove vTableWin 
PROCEDURE trgStartMove :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phMovedGridObject  AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cContainerMode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSelectedWidget AS HANDLE     NO-UNDO.

  IF glComplete = FALSE THEN
  DO:
    RUN trgMouseSelectClick (INPUT phMovedGridObject).

    RETURN NO-APPLY.
  END.

  ASSIGN
      cContainerMode  = DYNAMIC-FUNCTION("getUserProperty":U, "ContainerMode":U)
      hSelectedWidget = DYNAMIC-FUNCTION("getSelectedWidget":U).

  IF (phMovedGridObject = hSelectedWidget OR
      cContainerMode   <> "UPDATE":U)     /*AND
      gcSwappedWidgets  = "":U */           THEN
  DO:
    ghTargetObject = ?.
  
    DYNAMIC-FUNCTION("setSelectedWidget":U, phMovedGridObject).
    DYNAMIC-FUNCTION("removeTargets":U).
    DYNAMIC-FUNCTION("showHighlights":U).
    DYNAMIC-FUNCTION("showTargets":U, phMovedGridObject).
  END.
  ELSE
    RETURN NO-APPLY.

  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updatePageObject vTableWin 
PROCEDURE updatePageObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iPageSequence           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCurrentPage            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lFinished               AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE httObjectInstance       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httPage                 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery                  AS HANDLE     NO-UNDO.

  ASSIGN
      dCustomizationResultObj = ghObjectInstance:BUFFER-FIELD("d_customization_result_obj":U):BUFFER-VALUE
      iCurrentPage            = DYNAMIC-FUNCTION("getPageSequence":U IN ghContainerSource, ?)
      httPage                 = WIDGET-HANDLE({fnarg getUserProperty 'ttPage':U ghContainerSource})
      
      ghObjectInstance:BUFFER-FIELD("i_page":U):BUFFER-VALUE = iCurrentPage.

  httPage:FIND-FIRST(" WHERE i_page_sequence = ":U + STRING(iCurrentPage)
                     + " AND d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj)
                     + " AND c_action <> 'D'":U).

  /* Update page object sequence */
  CREATE QUERY  hQuery.
  CREATE BUFFER httObjectInstance FOR TABLE ghObjectInstance.

  hQuery:SET-BUFFERS(httObjectInstance).
  hQuery:QUERY-PREPARE("FOR EACH ttObjectInstance":U
                       + " WHERE ttObjectInstance.d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj)
                       + "   AND ttObjectInstance.d_object_instance_obj     <> ":U + QUOTER(ghObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE)
                       + "   AND ttObjectInstance.i_page                     = ":U + QUOTER(ghObjectInstance:BUFFER-FIELD("i_page":U):BUFFER-VALUE)
                       + "    BY ttObjectInstance.i_object_sequence":U).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().

  ASSIGN
      iPageSequence = 0
      lFinished     = FALSE.

  /* Find the first empty object sequence number */
  IF hQuery:QUERY-OFF-END THEN
    lFinished = TRUE.

  DO WHILE lFinished = FALSE:
    IF httObjectInstance:BUFFER-FIELD("i_object_sequence":U):BUFFER-VALUE <> iPageSequence THEN
      lFinished = TRUE.
    ELSE
      iPageSequence = iPageSequence + 1.

    hQuery:GET-NEXT().

    IF hQuery:QUERY-OFF-END THEN
      lFinished = TRUE.
  END.

  DELETE OBJECT hQuery.
  DELETE OBJECT httObjectInstance.

  ASSIGN
      httObjectInstance = ?
      hQuery            = ?

      ghObjectInstance:BUFFER-FIELD("i_object_sequence":U):BUFFER-VALUE = iPageSequence
      ghObjectInstance:BUFFER-FIELD("d_page_obj":U):BUFFER-VALUE        = httPage:BUFFER-FIELD("d_page_obj":U):BUFFER-VALUE.

  /* Ensure the page record has the correct status */
  IF httPage:AVAILABLE AND httPage:BUFFER-FIELD("i_page_sequence":U):BUFFER-VALUE <> 0
                       AND httPage:BUFFER-FIELD("c_action":U):BUFFER-VALUE         = "":U THEN
    ASSIGN
        httPage:BUFFER-FIELD("c_action":U):BUFFER-VALUE = (IF httPage:BUFFER-FIELD("d_page_obj":U):BUFFER-VALUE < 0.00 THEN "A":U ELSE "M":U).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION areSameAlignment vTableWin 
FUNCTION areSameAlignment RETURNS LOGICAL
  (phSourceObject AS HANDLE,
   phTargetObject AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER ttSourceObject FOR ttWidget.
  DEFINE BUFFER ttTargetObject FOR ttWidget.
  
  FIND ttSourceObject WHERE
       ttSourceObject.hHandle = phSourceObject.
  
  FIND ttTargetObject WHERE
       ttTargetObject.hHandle = phTargetObject.
  
  RETURN ttSourceObject.cLCR = ttTargetObject.cLCR. /* Function return value. */
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION areWidgetsOnSameRow vTableWin 
FUNCTION areWidgetsOnSameRow RETURNS LOGICAL
  (phSourceObject AS HANDLE,
   phTargetObject AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER ttSourceObject FOR ttWidget.
  DEFINE BUFFER ttTargetObject FOR ttWidget.
  
  FIND ttSourceObject WHERE
       ttSourceObject.hHandle = phSourceObject.
  
  FIND ttTargetObject WHERE
       ttTargetObject.hHandle = phTargetObject.
  
  RETURN ttSourceObject.iRow = ttTargetObject.iRow. /* Function return value. */
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION checkInstanceName vTableWin 
FUNCTION checkInstanceName RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cNewInstanceName        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cInstanceName           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dObjectInstanceObj      AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE httObjectInstance       AS HANDLE     NO-UNDO.

  IF (NOT VALID-HANDLE(ghObjectInstance)) OR
         (VALID-HANDLE(ghObjectInstance)  AND
          NOT ghObjectInstance:AVAILABLE) THEN
    RETURN FALSE.

  CREATE BUFFER httObjectInstance FOR TABLE ghObjectInstance.

  ASSIGN
      cInstanceName           = ghObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE
      dCustomizationResultObj = ghObjectInstance:BUFFER-FIELD("d_customization_result_obj":U):BUFFER-VALUE
      dObjectInstanceObj      = ghObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE

      cInstanceName = REPLACE(cInstanceName, ".":U, "":U)
      cWhere        = "WHERE c_instance_name = ":U            + QUOTER(cInstanceName)
                    + "  AND d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj)
                    + "  AND d_object_instance_obj     <> ":U + QUOTER(dObjectInstanceObj).
  
  httObjectInstance:FIND-FIRST(cWhere) NO-ERROR.
  
  IF httObjectInstance:AVAILABLE OR INDEX(ghObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE, ".":U) <> 0 THEN
  DO:
    IF httObjectInstance:AVAILABLE THEN
      cNewInstanceName = DYNAMIC-FUNCTION("getUniqueInstanceName":U IN ghContainerSource, cInstanceName).
    ELSE
      cNewInstanceName = cInstanceName.

    cNewInstanceName = REPLACE(cNewInstanceName, ".":U, "":U).

    ASSIGN
        ghObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE = cNewInstanceName
        fiInstanceName:SCREEN-VALUE IN FRAME {&FRAME-NAME}              = cNewInstanceName.

    RUN newSave.
  END.
  
  DELETE OBJECT httObjectInstance.
  httObjectInstance = ?.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION clearFields vTableWin 
FUNCTION clearFields RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hLookupFillIn AS HANDLE     NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        fiObjectDescription:SCREEN-VALUE = "":U
        fiInstanceName:SCREEN-VALUE      = "":U
        raLCR:SCREEN-VALUE               = "L":U
        toResizeHorizontal:CHECKED       = FALSE
        toResizeVertical:CHECKED         = FALSE
        hLookupFillIn                    = DYNAMIC-FUNCTION("getLookupHandle":U IN hObjectFilename)
        hLookupFillIn:SCREEN-VALUE       = "":U
        edForeignFields:SCREEN-VALUE     = "":U
        edForeignFields:SENSITIVE        = FALSE
        edForeignFields:READ-ONLY        = TRUE
        buMapFields:HIDDEN               = TRUE
        coUpdateTargets:SCREEN-VALUE     = "":U
        coUpdateTargets:LIST-ITEMS       = "":U
        coDataSources:SCREEN-VALUE       = "":U        
        coDataSources:LIST-ITEMS         = "":U
        coNavTarget:SCREEN-VALUE         = "":U        
        coNavTarget:LIST-ITEMS           = "":U.

    DYNAMIC-FUNCTION("evaluateLookupQuery":U).
    DYNAMIC-FUNCTION("setDataValue":U IN hObjectType, 0).
    DYNAMIC-FUNCTION("setDataValue":U IN hObjectFilename, 0.00).
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION clearGrid vTableWin 
FUNCTION clearGrid RETURNS LOGICAL
  (pdObjectInstanceObj AS DECIMAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER ttWidget FOR ttWidget.

  IF pdObjectInstanceObj <> 0.00 THEN
    {fnarg lockWindow TRUE ghContainerSource}.

  FOR EACH ttWidget
     WHERE ttWidget.lAvailable <> ?:
    
    IF pdObjectInstanceObj <> 0.00                        AND
       pdObjectInstanceObj <> ttWidget.dObjectInstanceObj THEN
      NEXT.

    ASSIGN
        ttWidget.dObjectInstanceObj = 0
        ttWidget.cLCR               = "":U
        ttWidget.cObject            = "":U
        ttWidget.cObjectType        = "":U
        ttWidget.lAvailable         = ?.
        
        /* Remember to set widget sensitivity */
    
    DYNAMIC-FUNCTION("setWidgetProperties":U, ttWidget.hHandle).
  END.

  IF pdObjectInstanceObj <> 0.00 THEN
    {fnarg lockWindow FALSE ghContainerSource}.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION clearLinkObject vTableWin 
FUNCTION clearLinkObject RETURNS LOGICAL
  (cSourceTarget      AS CHARACTER,
   dObjectInstanceObj AS DECIMAL):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    IF cSourceTarget = "SOURCE":U THEN
    DO:
      IF dObjectInstanceObj  = ?                          OR
        (dObjectInstanceObj <> ?                          AND
         dObjectInstanceObj  = gdSourceObjectInstanceObj) THEN
        ASSIGN
            gdSourceObjectInstanceObj = ?
            edSource:SCREEN-VALUE     = "":U.
    END.
    ELSE
    DO:
      IF dObjectInstanceObj  = ?                          OR
        (dObjectInstanceObj <> ?                          AND
         dObjectInstanceObj  = gdTargetObjectInstanceObj) THEN
        ASSIGN
            gdTargetObjectInstanceObj = ?
            edTarget:SCREEN-VALUE     = "":U.
    END.

    IF gdSourceObjectInstanceObj = ? OR
       gdTargetObjectInstanceObj = ? THEN
      ASSIGN
          buSaveLink:SENSITIVE = FALSE
          coLink:SENSITIVE     = FALSE
          buSwap:SENSITIVE     = FALSE.
  END.
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cropWidgets vTableWin 
FUNCTION cropWidgets RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER ttCurrentObject FOR ttWidget.
  DEFINE BUFFER ttProblemObject FOR ttWidget.
  
  FOR EACH ttCurrentObject
     BREAK
        BY ttCurrentObject.iRow
        BY ttCurrentObject.iCol:
     
    IF (ttCurrentObject.lAvailable = TRUE                             OR
        ttCurrentObject.lAvailable = ?)                               AND
        CAN-FIND(FIRST ttProblemObject
                 WHERE ttProblemObject.iRow       = ttCurrentObject.iRow
                   AND ttProblemObject.iCol       = ttCurrentObject.iCol + 1
                   AND ttProblemObject.lAvailable = FALSE)               THEN
    DO:
      FIND FIRST ttProblemObject
           WHERE ttProblemObject.iRow       = ttCurrentObject.iRow
             AND ttProblemObject.iCol       = ttCurrentObject.iCol + 1
             AND ttProblemObject.lAvailable = FALSE.
       
      DYNAMIC-FUNCTION("swapSourceTarget":U, ttCurrentObject.hHandle, ttProblemObject.hHandle, FALSE) .
    END.
  END.
  
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION evaluateActions vTableWin 
FUNCTION evaluateActions RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContainerMode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentMode     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectView     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPageString     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSelectedWidget AS HANDLE     NO-UNDO.

  DEFINE BUFFER ttWidget FOR ttWidget.

  ASSIGN
      hSelectedWidget = DYNAMIC-FUNCTION("getSelectedWidget":U)
      cContainerMode  = DYNAMIC-FUNCTION("getUserProperty":U, "ContainerMode":U)
      cParentMode     = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U)
      cObjectView     = DYNAMIC-FUNCTION("getUserProperty":U, "ObjectView":U).
      cPageString     = DYNAMIC-FUNCTION("getPageString":U, TRUE).

  DO WITH FRAME {&FRAME-NAME}:
    DISABLE {&ADM-ASSIGN-FIELDS}.
    
    CASE cContainerMode:
      WHEN "ADD":U THEN
      DO:
        RUN enableField IN hObjectFilename.
        
        ENABLE {&List-2}.
        
        IF cObjectView = "NonLayoutObjects":U THEN
          edForeignFields:SENSITIVE = TRUE.
        ELSE
          ASSIGN
              toResizeHorizontal:SENSITIVE = TRUE
              toResizeVertical:SENSITIVE   = TRUE
              raLCR:SENSITIVE              = TRUE.
      END.
      
      WHEN "MODIFY":U THEN
      DO:
        IF cParentMode = "MODIFY":U OR
           cParentMode = "UPDATE":U OR
           cParentMode = "ADD":U    THEN
        DO:
          FIND FIRST ttWidget
               WHERE ttWidget.hHandle = hSelectedWidget NO-ERROR.

          ENABLE {&List-3}.

          IF AVAILABLE ttWidget THEN
          DO:
            IF ttWidget.lAvailable <> FALSE THEN
              ASSIGN
                  buOldProperties:SENSITIVE = FALSE
                  buProperties:SENSITIVE    = FALSE.

            IF DYNAMIC-FUNCTION("viewStaticPropsheet":U IN ghContainerSource, ttWidget.cObjectType) AND ttWidget.lAvailable = FALSE THEN
              buOldProperties:SENSITIVE = TRUE.
          END.

          IF NOT {fnarg getUserProperty 'DataContainer' ghContainerSource} = "yes":U THEN
          DO:
            IF {fnarg getUserProperty 'ObjectView'} = "NonLayoutObjects":U THEN
              buLayoutObjects:SENSITIVE = TRUE.
            ELSE
              buNonLayoutObjects:SENSITIVE = TRUE.
          END.
        END.
      END.
      
      WHEN "UPDATE":U THEN
        ENABLE {&List-4}.
    END CASE.

    /* This means there are no objects on the page */
    IF CAN-FIND(FIRST ttWidget
                WHERE ttWidget.lAvailable <> ?) = FALSE   AND
       cContainerMode                          <> "ADD":U THEN
      ASSIGN
          buOldProperties:SENSITIVE = FALSE
          buProperties:SENSITIVE    = FALSE.

    IF gdCoCInstanceObj <> 0.00 AND cContainerMode <> "ADD":U THEN
      ASSIGN
          buCancelCoC:SENSITIVE = TRUE
          buPaste:SENSITIVE     = TRUE.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION evaluateFFButton vTableWin 
FUNCTION evaluateFFButton RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lObjectView AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hSmartLink  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lSourceisZero  AS LOGICAL NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    
    /* Hide the button. If the */
    ASSIGN
        hSmartLink          = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttSmartLink":U))
        lObjectView         = (DYNAMIC-FUNCTION("getUserProperty":U, "ObjectView":U) = "NonLayoutObjects":U)
        buMapFields:HIDDEN  = TRUE
        edForeignFields:SENSITIVE = FALSE
        edForeignFields:READ-ONLY = TRUE.


    IF VALID-HANDLE(hSmartLink)   AND
       ghObjectInstance:AVAILABLE AND
       lObjectView                THEN
    DO:
      /* Determine if we have a proper data source to see if the button should be visible or not */
      hSmartLink:FIND-FIRST("WHERE d_target_object_instance_obj  = ":U + QUOTER(ghObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE)
                       /*    + " AND d_source_object_instance_obj <> 0":U  Issue 20040826-002  If source is THIS-OBJECT */
                           + " AND c_action                     <> 'D'":U
                           + " AND c_link_name                   = 'Data'":U) NO-ERROR.


      IF hSmartLink:AVAILABLE THEN
      DO:
        ASSIGN
            lSourceIsZero             = (hSmartLink:BUFFER-FIELD("d_source_object_instance_obj":U):BUFFER-VALUE = 0)
            buMapFields:SENSITIVE     = IF lSourceIsZero THEN FALSE ELSE TRUE
            buMapFields:HIDDEN        = IF lSourceIsZero THEN TRUE ELSE FALSE
            edForeignFields:SENSITIVE = TRUE
            edForeignFields:READ-ONLY = FALSE.
            .

        buMapFields:MOVE-TO-TOP().
      END.
    END.
  END.
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION evaluateJustification vTableWin 
FUNCTION evaluateJustification RETURNS LOGICAL
  (phWidget         AS HANDLE,
   piRow            AS INTEGER,
   pcJustification  AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lPossible   AS LOGICAL    NO-UNDO.

  DEFINE BUFFER ttWidget FOR ttWidget.

  lPossible = TRUE.
  
  DO WITH FRAME {&FRAME-NAME}:
    
    CASE pcJustification:
      WHEN "C":U THEN
        /* If an object is to be center justified, then it must be the only object in the row */
        IF DYNAMIC-FUNCTION("getNumObjsOnRow":U, piRow) > 1 THEN
          lPossible = NOT CAN-FIND(FIRST ttWidget
                                   WHERE ttWidget.hHandle   <> phWidget
                                     AND ttWidget.iRow       = piRow
                                     AND ttWidget.lAvailable = FALSE).
      
      WHEN "R":U THEN
        /* We are only allowing one object in a row to be right justified, so if an object can be found in the row of the currently
           selected object that is already right justified, then we don't allow the justification of the current object to be changed */
        IF DYNAMIC-FUNCTION("getNumObjsOnRow":U, piRow) > 1 THEN
          lPossible = NOT CAN-FIND(FIRST ttWidget
                                   WHERE ttWidget.hHandle <> phWidget
                                     AND ttWidget.iRow     = piRow
                                     AND ttWidget.cLCR     = "R":U).
    END CASE.
  END.
  
  RETURN lPossible.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION evaluateLookupQuery vTableWin 
FUNCTION evaluateLookupQuery RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValidObjectTypes   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrentEntry       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryString        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectView         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCounter            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iExtent             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iIndex              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSelectedWidget     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDesignManager      AS HANDLE     NO-UNDO.

  DEFINE BUFFER ttWidget FOR ttWidget.

  /* Check if the class information has already been retrieved */
  IF gcRetrievedClasses[1] = "":U THEN
  DO:
    ASSIGN hDesignManager = DYNAMIC-FUNCTION('getManagerHandle':U IN TARGET-PROCEDURE, INPUT "RepositoryDesignManager":U)
           gcRetrievedClasses[1] = DYNAMIC-FUNCTION('getDataSourceClasses':U IN hDesignManager).
   
    DO iExtent = 2 TO EXTENT(gcRetrievedClasses):
      gcRetrievedClasses[iExtent] = {fnarg getClassChildrenFromDB gcClassesToRetrieve[iExtent] gshRepositoryManager}.

      /* Step through the entries and remove the base classes which should not be in the list */
      DO iCounter = 1 TO NUM-ENTRIES(gcRetrievedClasses[iExtent], CHR(3)).
        cValidObjectTypes = ENTRY(iCounter, gcRetrievedClasses[iExtent], CHR(3)).

        /* Get rid of the ADM classes themselves. */
        DO iIndex = 1 TO NUM-ENTRIES(cValidObjectTypes):
          CASE ENTRY(iIndex, cValidObjectTypes):
            WHEN "Toolbar":U  OR
            WHEN "Panel":U    OR
            WHEN "Viewer"     OR
            WHEN "Browser":U THEN 
              ENTRY(iIndex, cValidObjectTypes) = "":U.
          END CASE.   /* obejct type */
        END.    /* loop through valid object types */

        /* Clear off double commas left because of the replace */
        DO WHILE INDEX(cValidObjectTypes, ",,":U) <> 0:
          cValidObjectTypes = REPLACE(cValidObjectTypes, ",,":U, ",":U).
        END.

        /* Clear off any extra commas */
        ASSIGN
            cValidObjectTypes                                    = TRIM(cValidObjectTypes, ",":U)
            ENTRY(iCounter, gcRetrievedClasses[iExtent], CHR(3)) = cValidObjectTypes.
      END.    /* retrieved classes [1]*/
    END.    /* extent loop */
  END.  /* retrieved classes not blank. */

  ASSIGN
      hSelectedWidget = {fn getSelectedWidget}
      cQueryString    = gcBaseQueryString
      cObjectView     = {fnarg getUserProperty 'ObjectView':U}.

  /* Get the valid object types for non layout objects. This will include all objects under the class Data and SBO,
     so get the first two sets of retrieved classes */
  IF cObjectView = "NonLayoutObjects":U THEN
    cValidObjectTypes = gcRetrievedClasses[1].

  /* Get the valid object types for layout objects. This will include all object types except the Data and SBO classes,
     so get the all sets of retrieved classes except the first two */
  IF cObjectView = "LayoutObjects":U THEN
  DO:
    cValidObjectTypes = gcRetrievedClasses[2].

    /* Only allow them to add one folder window per container */
    IF NOT {fn hasFolder ghContainerSource} THEN
      cValidObjectTypes = cValidObjectTypes + CHR(3) + gcRetrievedClasses[3].
  END.  /* visual */

  cValidObjectTypes = REPLACE(cValidObjectTypes, CHR(3), ",":U).

  FIND FIRST ttWidget
       WHERE ttWidget.hHandle = hSelectedWidget NO-ERROR.

  /* Find the specified class group which the object type falls in. All object types in the group will be allowable substitutions */
  IF AVAILABLE ttWidget THEN
  DO:
    /* SmartFolder stuff is on the 3rd extent */
    IF CAN-DO(gcRetrievedClasses[3], ttWidget.cObjectType) THEN
      cValidObjectTypes = gcRetrievedClasses[3].
    ELSE
    DO:
      CASE cObjectView:
        WHEN "NonLayoutObjects":U THEN iExtent = 1.
        WHEN "LayoutObjects":U    THEN iExtent = 2.
        OTHERWISE                      iExtent = 0.
      END CASE.   /* object view */

      IF iExtent > 0 THEN
      DO iCounter = 1 TO NUM-ENTRIES(gcRetrievedClasses[iExtent], CHR(3)):
        cCurrentEntry = ENTRY(iCounter, gcRetrievedClasses[iExtent], CHR(3)).

        IF LOOKUP(ttWidget.cObjectType, cCurrentEntry) <> 0 THEN
          cValidObjectTypes = cCurrentEntry.
      END.    /* loop */
    END.    /* not a SmartFolder */
  END.  /* avialable widget. */

  cQueryString = REPLACE(cQueryString, ", gsc_object_type.object_type_code":U, ", '":U + cValidObjectTypes + "'":U).
 
  {set BaseQueryString cQueryString hObjectFilename}.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION evaluateRadioSet vTableWin 
FUNCTION evaluateRadioSet RETURNS LOGICAL
  (BUFFER ttWidget FOR ttWidget) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  /* Determine the sensitivity of the radio-set buttons */
  DO WITH FRAME {&FRAME-NAME}:
    /* Left */
    IF NOT DYNAMIC-FUNCTION("evaluateJustification":U, ttWidget.hHandle, ttWidget.iRow, "L":U) THEN
      raLCR:DISABLE(ENTRY(1, raLCR:RADIO-BUTTONS)).
    ELSE
      raLCR:ENABLE(ENTRY(1, raLCR:RADIO-BUTTONS)).

    /* Center */
    IF NOT DYNAMIC-FUNCTION("evaluateJustification":U, ttWidget.hHandle, ttWidget.iRow, "C":U) THEN
      raLCR:DISABLE(ENTRY(3, raLCR:RADIO-BUTTONS)).
    ELSE
      raLCR:ENABLE(ENTRY(3, raLCR:RADIO-BUTTONS)).

    /* Right */
    IF NOT DYNAMIC-FUNCTION("evaluateJustification":U, ttWidget.hHandle, ttWidget.iRow, "R":U) THEN
      raLCR:DISABLE(ENTRY(5, raLCR:RADIO-BUTTONS)).
    ELSE
      raLCR:ENABLE(ENTRY(5, raLCR:RADIO-BUTTONS)).
  END.

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION formatFFieldValue vTableWin 
FUNCTION formatFFieldValue RETURNS CHARACTER
  (pcForeignFieldValue  AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFormattedFFieldValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEntry                AS INTEGER    NO-UNDO.

  IF NUM-ENTRIES(pcForeignFieldValue) MOD 2 <> 0 THEN
    cFormattedFFieldValue = pcForeignFieldValue.
  ELSE
    DO iEntry = 1 TO NUM-ENTRIES(pcForeignFieldValue) BY 2:
      cFormattedFFieldValue = cFormattedFFieldValue + (IF cFormattedFFieldValue = "":U THEN "":U ELSE "~n":U)
                            + ENTRY(iEntry,     pcForeignFieldValue) + ",":U
                            + ENTRY(iEntry + 1, pcForeignFieldValue).
    END.
  
  RETURN cFormattedFFieldValue.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentPrefs vTableWin 
FUNCTION getCurrentPrefs RETURNS CHARACTER
  (plCurrentValues  AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPreferences      AS CHARACTER  NO-UNDO.

  IF plCurrentValues = TRUE THEN
    cPreferences = "ConfirmDeletion":U  + "|":U  + STRING(glConfirmDeletion)  + "|":U
                 + "CreateAlignment":U  + "|":U  + STRING(glCreateAlignment)  + "|":U
                 + "StretchToFit":U     + "|":U  + STRING(glStretchToFit)     + "|":U
                 + "ImageTransparent":U + "|":U  + STRING(glImageTransparent) + "|":U
                 + "ReposPS":U          + "|":U  + STRING(glReposPS)          + "|":U
                 + "ReposCB":U          + "|":U  + STRING(glReposCB)          + "|":U

                 + "Columns":U          + "|":U  + STRING(giNumColumns)       + "|":U
                 + "Rows":U             + "|":U  + STRING(giNumRows)          + "|":U

                 + "BGColor":U          + "|":U  + STRING(giBGColor)          + "|":U
                 + "SelectorColor":U    + "|":U  + STRING(giSelectorColor)    + "|":U
                 + "GLColor":U          + "|":U  + STRING(giGLColor)          + "|":U

                 + "Path":U             + "|":U  + STRING(gcPath)             + "|":U
                 + "Type":U             + "|":U  + STRING(gcImageType)        + "|":U
                 + "ImageNotAvail":U    + "|":U  + gcImgNotAvail              + "|":U
                 + "ImageUnknown":U     + "|":U  + gcImgUnknown               + "|":U
                 + "ImageAvail":U       + "|":U  + gcImgAvail                 + "|":U

                 + "CustomSuffix":U     + "|":U  + STRING(gcCustSuffix)       + "|":U
                 + "AlignLeft":U        + "|":U  + STRING(gcAlignLeft)        + "|":U
                 + "AlignCenter":U      + "|":U  + STRING(gcAlignCenter)      + "|":U
                 + "AlignRight":U       + "|":U  + STRING(gcAlignRight)       + "|":U
                 + "AlignmentHeight":U  + "|":U  + STRING(giAlignmentHeight)  + "|":U

                 + "GridPosition":U     + "|":U  + gcGPos                     + "|":U
                 + "TBTopOrLeft":U      + "|":U  + STRING(glTBTopOrLeft)      + "|":U
                 + "TBVertical":U       + "|":U  + STRING(glTBVertical)       + "|":U
                 + "TBToGrid":U         + "|":U  + STRING(glTBToGrid)         + "|":U.
  ELSE
    cPreferences = gcDefaultValues.

  RETURN cPreferences.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInstanceComplete vTableWin 
FUNCTION getInstanceComplete RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN glComplete.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLayoutCode vTableWin 
FUNCTION getLayoutCode RETURNS CHARACTER
  (plGetSwappedObject AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjectView     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLayoutCode     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lVisibleObject  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hSelectedWidget AS HANDLE     NO-UNDO.

  DEFINE BUFFER ttWidget FOR ttWidget.

  DO WITH FRAME {&FRAME-NAME}:
    IF plGetSwappedObject = FALSE THEN
      hSelectedWidget = DYNAMIC-FUNCTION("getSelectedWidget":U).
    ELSE
      hSelectedWidget = ghWidgetSwapped.

    FIND FIRST ttWidget
         WHERE ttWidget.hHandle = hSelectedWidget.

    ASSIGN
        raLCR

        cObjectView = DYNAMIC-FUNCTION("getUserProperty":U, "ObjectView":U)
        cLayoutCode = (IF cObjectView = "LayoutObjects":U THEN (IF ttWidget.iRow <= 8 THEN "M":U ELSE "B":U) ELSE " ":U)
                    + STRING(ttWidget.iRow)
                    + (IF raLCR:SCREEN-VALUE = "L":U THEN STRING(ttWidget.iCol) ELSE raLCR:SCREEN-VALUE).
  END.

  RETURN cLayoutCode.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNumObjsOnRow vTableWin 
FUNCTION getNumObjsOnRow RETURNS INTEGER
  (piRow  AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iNumObjsOnRow AS INTEGER    NO-UNDO.
  
  DEFINE BUFFER ttWidget FOR ttWidget.
  
  iNumObjsOnRow = 0.
  
  FOR EACH ttWidget
     WHERE ttWidget.lAvailable = FALSE
       AND ttWidget.iRow       = piRow:
    
    iNumObjsOnRow = iNumObjsOnRow + 1.
  END.
  
  RETURN iNumObjsOnRow.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPageString vTableWin 
FUNCTION getPageString RETURNS CHARACTER
  (plInclude  AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFolderLabels AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPageString   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCurrentPage  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCounter      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hPageSource   AS HANDLE     NO-UNDO.
  
  ASSIGN
      iCurrentPage  = DYNAMIC-FUNCTION("getCurrentPage":U  IN ghContainerSource)
      hPageSource   = DYNAMIC-FUNCTION("getPageSource":U   IN ghContainerSource)
      cFolderLabels = DYNAMIC-FUNCTION("getFolderLabels":U IN hPageSource)
      cPageString   = "":U.
  
  DO iCounter = 1 TO NUM-ENTRIES(cFolderLabels, "|":U):
    
    IF iCounter <> iCurrentPage OR
      (iCounter  = iCurrentPage AND
       plInclude = TRUE)        THEN
      ASSIGN
          cPageString = cPageString
                      + (IF cPageString = "":U THEN "":U ELSE ",":U)
                      + TRIM(STRING(iCounter)).
  END.
  
  RETURN cPageString.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRecordComplete vTableWin 
FUNCTION getRecordComplete RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN glComplete.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSelectedWidget vTableWin 
FUNCTION getSelectedWidget RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  The selected widget depends on the current page and the type of view
            that is selected. This function determines the selected widget using
            the mentioned criteria.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjectView   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCurrentPage  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hWidget       AS HANDLE     NO-UNDO.
  
  DEFINE BUFFER ttSelectedWidget FOR ttSelectedWidget.
  
  ASSIGN
      iCurrentPage = DYNAMIC-FUNCTION("getCurrentPage":U IN ghContainerSource)
      cObjectView  = DYNAMIC-FUNCTION("getUserProperty":U, "ObjectView":U)
      hWidget      = ?.
  
  FIND FIRST ttSelectedWidget
       WHERE ttSelectedWidget.iPage = iCurrentPage
         AND ttSelectedWidget.cView = cObjectView NO-ERROR.
  
  IF AVAILABLE ttSelectedWidget THEN
    hWidget = ttSelectedWidget.hWidget.
  
  RETURN hWidget.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWidgetHandle vTableWin 
FUNCTION getWidgetHandle RETURNS HANDLE
  (phObject AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hGridObject AS HANDLE     NO-UNDO.
  
  DEFINE BUFFER ttWidget FOR ttWidget.
  
  /* If an alignment widget was selected, select the actual grid object */
  hGridObject = ?.
  
  /* Check if the actual object widget was selected */
  IF CAN-FIND(ttWidget WHERE
              ttWidget.hHandle = phObject) THEN
    hGridObject = phObject.
  ELSE
  DO:
    /* Alignment widget was selected, find the object widget */
    FIND ttWidget WHERE
         ttWidget.hAlignment = phObject NO-ERROR.
    
    IF AVAILABLE ttWidget THEN
      hGridObject = ttWidget.hHandle.
  END.
  
  RETURN hGridObject.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION positionButton vTableWin 
FUNCTION positionButton RETURNS LOGICAL
  (phButton AS HANDLE,
   phSource AS HANDLE,
   plBelow  AS LOGICAL):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN      
      phButton:X       = (IF plBelow = FALSE THEN phSource:X + 2 + phSource:WIDTH-PIXELS  ELSE phSource:X)
      phButton:Y       = (IF plBelow = TRUE  THEN phSource:Y + 2 + phSource:HEIGHT-PIXELS ELSE phSource:Y).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION quickLinkSensitivity vTableWin 
FUNCTION quickLinkSensitivity RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE httObjectInstance       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httSmartLink            AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN coLink.

    IF coLink:SCREEN-VALUE = "":U OR
       coLink:SCREEN-VALUE = ?    THEN
      ASSIGN
          buSaveLink:SENSITIVE = FALSE.
    ELSE
    DO:
      ASSIGN
          dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "CustomizationResultObj":U))
          httObjectInstance       = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttObjectInstance":U))
          httSmartLink            = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttSmartLink":U)).

      CREATE BUFFER httObjectInstance FOR TABLE httObjectInstance.

      /* Check if the source object instance obj changed (typical when a new instance was added and then saved) */
      httObjectInstance:FIND-FIRST("WHERE d_customization_result_obj = 0 AND c_instance_name = ":U + QUOTER(gcSourceInstanceName)) NO-ERROR.
      
      IF NOT httObjectInstance:AVAILABLE THEN
        httObjectInstance:FIND-FIRST("WHERE d_customization_result_obj = " + QUOTER(dCustomizationResultObj)
                                    + " AND c_instance_name = ":U + QUOTER(gcSourceInstanceName)) NO-ERROR.

      IF httObjectInstance:AVAILABLE                                                                         AND
         gdSourceObjectInstanceObj <> httObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE THEN
        gdSourceObjectInstanceObj = httObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE.

      /* Check if the target object instance obj changed (typical when a new instance was added and then saved) */
      httObjectInstance:FIND-FIRST("WHERE d_customization_result_obj = 0 AND c_instance_name = ":U + QUOTER(gcTargetInstanceName)) NO-ERROR.
      
      IF NOT httObjectInstance:AVAILABLE THEN
        httObjectInstance:FIND-FIRST("WHERE d_customization_result_obj = " + QUOTER(dCustomizationResultObj)
                                    + " AND c_instance_name = ":U + QUOTER(gcTargetInstanceName)) NO-ERROR.

      IF httObjectInstance:AVAILABLE                                                                         AND
         gdTargetObjectInstanceObj <> httObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE THEN
        gdTargetObjectInstanceObj = httObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE.

      DELETE OBJECT httObjectInstance.
      httObjectInstance = ?.

      httSmartLink:FIND-FIRST("WHERE d_source_object_instance_obj = ":U + QUOTER(gdSourceObjectInstanceObj)
                             + " AND d_target_object_instance_obj = ":U + QUOTER(gdTargetObjectInstanceObj)
                             + " AND c_link_name                  = '":U + coLink:SCREEN-VALUE + "'":U
                             + " AND c_action                    <> 'D'":U)NO-ERROR.

      IF NOT httSmartLink:AVAILABLE THEN
        ASSIGN
            edSource:FGCOLOR     = 0
            edTarget:FGCOLOR     = 0
            buSaveLink:SENSITIVE = TRUE.
      ELSE
        ASSIGN
            edSource:FGCOLOR     = 7
            edTarget:FGCOLOR     = 7
            buSaveLink:SENSITIVE = FALSE.
    END.

    IF gdSourceObjectInstanceObj <> ? AND
       gdTargetObjectInstanceObj <> ? THEN
      ASSIGN
          buSwap:SENSITIVE = TRUE
          coLink:SENSITIVE = TRUE.

    IF gdSourceObjectInstanceObj = gdTargetObjectInstanceObj THEN
      ASSIGN
          buSaveLink:SENSITIVE = FALSE
          buSwap:SENSITIVE     = FALSE
          coLink:SENSITIVE     = FALSE.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION removePopupMenu vTableWin 
FUNCTION removePopupMenu RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCounter  AS INTEGER  NO-UNDO.
  
  DO iCounter = 1 TO EXTENT(ghPopupMenuItems):
    IF VALID-HANDLE(ghPopupMenuItems[iCounter]) THEN DELETE OBJECT ghPopupMenuItems[iCounter].
  END.

  IF VALID-HANDLE(ghPopupMenu) THEN DELETE OBJECT ghPopupMenu.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION removeTargets vTableWin 
FUNCTION removeTargets RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cImageName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCoCMode    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFImg       AS CHARACTER  NO-UNDO. /* First  Image Type */
  DEFINE VARIABLE cSImg       AS CHARACTER  NO-UNDO. /* Second Image Type */

  DEFINE BUFFER ttWidget FOR ttWidget.

  ASSIGN
      cCoCMode = DYNAMIC-FUNCTION("getUserProperty":U, "CoCMode":U)
      cFImg    = TRIM(ENTRY(1, gcImageType, "/":U))
      cSImg    = TRIM(ENTRY(2, gcImageType, "/":U)).

  IF cCoCMode = "Off":U THEN
    ASSIGN
        buCancelCoC:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE 
        buPaste:SENSITIVE     IN FRAME {&FRAME-NAME} = FALSE.

  FOR EACH ttWidget
     WHERE ttWidget.lAvailable = TRUE:

    ASSIGN
        cImageName = gcPath + gcImgNotAvail + cFImg
        cImageName = (IF SEARCH(cImageName) = ? THEN REPLACE(cImageName, cFImg, cSImg) ELSE cImageName)

        ttWidget.hHandle:STRETCH-TO-FIT    = glStretchToFit
        ttWidget.hHandle:TRANSPARENT       = TRUE
        ttWidget.hHandle:SENSITIVE         = FALSE
        ttWidget.lAvailable                = ?.

    ttWidget.hHandle:LOAD-IMAGE(cImageName).

    IF VALID-HANDLE(ttWidget.hAlignment) THEN
    DO:
      ASSIGN  
          ttWidget.hAlignment:STRETCH-TO-FIT = glStretchToFit
          ttWidget.hAlignment:TRANSPARENT    = TRUE
          ttWidget.hAlignment:SENSITIVE      = FALSE.

      ttWidget.hAlignment:LOAD-IMAGE(cImageName).
    END.
  END.
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION repositionToObject vTableWin 
FUNCTION repositionToObject RETURNS LOGICAL
  (pcObjectString AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lVisibleObject  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iPageNumber     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRow            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iColumn         AS INTEGER    NO-UNDO.

  DEFINE BUFFER ttWidget  FOR ttWidget.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN    
        iPageNumber              = INTEGER(ENTRY(1, pcObjectString, "|":U))
        iRow                     = INTEGER(ENTRY(2, pcObjectString, "|":U))
        iColumn                  = INTEGER(ENTRY(3, pcObjectString, "|":U))
        lVisibleObject           = IF ENTRY(4, pcObjectString, "|":U) = "Y":U THEN TRUE ELSE FALSE.

    RUN selectPage IN ghContainerSource (INPUT iPageNumber).

    FOR FIRST ttWidget
        WHERE ttWidget.iRow = iRow
          AND ttWidget.iCol = iColumn:

      IF lVisibleObject = TRUE THEN
        APPLY "CHOOSE":U TO buLayoutObjects.
      ELSE
        APPLY "CHOOSE":U TO buNonLayoutObjects.

      DYNAMIC-FUNCTION("setSelectedWidget":U, ttWidget.hHandle).
      DYNAMIC-FUNCTION("showHighlights":U).
    END.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAttribute vTableWin 
FUNCTION setAttribute RETURNS LOGICAL
  (pcAttribute AS CHARACTER,
   pcValue     AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCustomizationCode  AS CHARACTER  NO-UNDO.
  
  cCustomizationCode = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "CustomizationResultCode":U).

  IF cCustomizationCode = "?":U OR
     cCustomizationCode = ?     THEN
    cCustomizationCode = "":U.

  RUN propertyChangedAttribute IN ghContainerSource (INPUT ghContainerSource,
                                                     INPUT STRING(ghObjectInstance:BUFFER-FIELD("d_container_smartobject_obj":U):BUFFER-VALUE),
                                                     INPUT STRING(ghObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE),
                                                     INPUT cCustomizationCode,
                                                     INPUT pcAttribute,
                                                     INPUT pcValue,
                                                     INPUT "":U,
                                                     INPUT TRUE).

  RUN assignPropertyValues IN ghProcLib (INPUT ghContainerSource,
                                         INPUT STRING(ghObjectInstance:BUFFER-FIELD("d_container_smartobject_obj":U):BUFFER-VALUE),
                                         INPUT STRING(ghObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE),
                                         INPUT pcAttribute + CHR(3) + cCustomizationCode + CHR(3) + pcValue,
                                         INPUT "":U,
                                         INPUT TRUE).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLinkObject vTableWin 
FUNCTION setLinkObject RETURNS LOGICAL
  (pcSourceTarget      AS CHARACTER,
   pcObjectName        AS CHARACTER,
   pcObjectType        AS CHARACTER,
   pdObjectInstanceObj AS DECIMAL,
   piPage              AS INTEGER,
   piColumn            AS INTEGER,
   piRow               AS INTEGER,
   plVisibleObject     AS LOGICAL):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cNarration  AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    IF pcObjectName <> "":U THEN
      cNarration = TRIM(pcObjectName)
                 + " is of type '" + TRIM(pcObjectType)
                 + "' on page "    + TRIM(STRING(piPage))
                 + (IF NOT plVisibleObject THEN "":U ELSE ", at " + KEYLABEL(KEYCODE("A":U) + piColumn - 1) + TRIM(STRING(piRow))).

    IF pcObjectName = "THIS-OBJECT":U THEN
      cNarration = pcObjectName.

    IF pcSourceTarget = "SOURCE":U THEN
      ASSIGN
          gdSourceObjectInstanceObj = pdObjectInstanceObj
          gcSourceInstanceName      = pcObjectName
          edSource:SCREEN-VALUE     = cNarration
          edSource:FGCOLOR          = 0.
    ELSE
      ASSIGN
          gdTargetObjectInstanceObj = pdObjectInstanceObj
          gcTargetInstanceName      = pcObjectName
          edTarget:SCREEN-VALUE     = cNarration
          edTarget:FGCOLOR          = 0.

    APPLY "VALUE-CHANGED":U TO coLink.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSelectedWidget vTableWin 
FUNCTION setSelectedWidget RETURNS LOGICAL
  (phWidget AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjectView     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCurrentPage    AS INTEGER    NO-UNDO.

  DEFINE BUFFER ttSelectedWidget FOR ttSelectedWidget.

  ASSIGN
      iCurrentPage = DYNAMIC-FUNCTION("getCurrentPage":U IN ghContainerSource)
      cObjectView  = DYNAMIC-FUNCTION("getUserProperty":U, "ObjectView":U).
  
  FIND FIRST ttSelectedWidget
       WHERE ttSelectedWidget.iPage = iCurrentPage
         AND ttSelectedWidget.cView = cObjectView NO-ERROR.
  
  IF NOT AVAILABLE ttSelectedWidget THEN
  DO:
    CREATE ttSelectedWidget.
    ASSIGN ttSelectedWidget.iPage = iCurrentPage
           ttSelectedWidget.cView = cObjectView.
  END.
  
  ttSelectedWidget.hWidget = phWidget.
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setWidgetProperties vTableWin 
FUNCTION setWidgetProperties RETURNS LOGICAL
  (phWidget AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAlignmentImageName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectView             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cImageName              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFImg                   AS CHARACTER  NO-UNDO.  /* First Image  */
  DEFINE VARIABLE cSImg                   AS CHARACTER  NO-UNDO.  /* Second Image */
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE bhttObjectInstance      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httObjectInstance       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cClassParents           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCnt                    AS INTEGER    NO-UNDO.

  DEFINE BUFFER ttWidget          FOR ttWidget.

  IF phWidget = ? THEN
    RETURN FALSE.

  ASSIGN
      dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "CustomizationResultObj":U))
      httObjectInstance       = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttObjectInstance":U))
      cObjectView             = DYNAMIC-FUNCTION("getUserProperty":U, "ObjectView":U)
      cFImg                   = TRIM(ENTRY(1, gcImageType, "/":U))
      cSImg                   = TRIM(ENTRY(2, gcImageType, "/":U)).

  FIND ttWidget WHERE
       ttWidget.hHandle = phWidget.

  IF ttWidget.lAvailable = FALSE THEN
  DO:
    ASSIGN
        cImageName                      = gcPath + ttWidget.cObjectType + cFImg
        ttWidget.hHandle:STRETCH-TO-FIT = glStretchToFit
        ttWidget.hHandle:TRANSPARENT    = glImageTransparent
        ttWidget.hHandle:SENSITIVE      = TRUE.
    
    IF VALID-HANDLE(ttWidget.hAlignment) THEN
      ASSIGN
          ttWidget.hAlignment:STRETCH-TO-FIT = glStretchToFit
          ttWidget.hAlignment:TRANSPARENT    = glImageTransparent
          ttWidget.hAlignment:SENSITIVE      = TRUE.

    IF SEARCH(cImageName) = ? THEN
    DO:
      cImageName = gcPath + ttWidget.cObjectType + cSImg.
      IF SEARCH(cImageName) = ? THEN 
      then-blk: 
      DO:
          /* We may be dealing with an extended class, go through it's parents, and see if we can find an image for them */
          ASSIGN cClassParents = DYNAMIC-FUNCTION("getClassParentsFromDB":U IN gshRepositoryManager, INPUT ttWidget.cObjectType).
          DO iCnt = 1 TO NUM-ENTRIES(cClassParents):
              ASSIGN cImageName = gcPath + ENTRY(iCnt, cClassParents) + cFImg.
              IF SEARCH(cImageName) = ? THEN
                  ASSIGN cImageName = gcPath + ENTRY(iCnt, cClassParents) + cSImg.
              IF SEARCH(cImageName) <> ? THEN
                  LEAVE then-blk.
          END.

          /* Couldn't find the image for the parent classes, display unknown image */

          IF SEARCH(cImageName) = ? THEN
              ASSIGN cImageName = gcPath + gcImgUnknown + cSImg.
      END.
    END.
  END.
  ELSE
  DO:
    ASSIGN
        cImageName = (IF ttWidget.lAvailable = TRUE THEN (gcPath + gcImgAvail)             ELSE (gcPath + gcImgNotAvail)) + cFImg
        cImageName = (IF SEARCH(cImageName)  = ?    THEN REPLACE(cImageName, cFImg, cSImg) ELSE cImageName)
        
        ttWidget.hHandle:STRETCH-TO-FIT = FALSE
        ttWidget.hHandle:TRANSPARENT    = TRUE
        ttWidget.hHandle:SENSITIVE      = FALSE.
  
    IF VALID-HANDLE(ttWidget.hAlignment) THEN
      ASSIGN  
          ttWidget.hAlignment:STRETCH-TO-FIT = FALSE
          ttWidget.hAlignment:TRANSPARENT    = TRUE
          ttWidget.hAlignment:SENSITIVE      = FALSE.
  END.

  ttWidget.hHandle:LOAD-IMAGE(cImageName).
  IF VALID-HANDLE(ttWidget.hAlignment) THEN
  DO:
    CASE ttWidget.cLCR:
      WHEN "L":U THEN cAlignmentImageName = gcPath + gcAlignLeft.
      WHEN "C":U THEN cAlignmentImageName = gcPath + gcAlignCenter.
      WHEN "R":U THEN cAlignmentImageName = gcPath + gcAlignRight.
      
      OTHERWISE cAlignmentImageName = (IF ttWidget.lAvailable = TRUE THEN (gcPath + gcImgAvail) ELSE gcPath + (gcImgNotAvail)).
    END CASE.

    IF cObjectView          = "NonLayoutObjects":U     AND
       cAlignmentImageName <> (gcPath + gcImgNotAvail) AND
       cAlignmentImageName <> (gcPath + gcImgAvail)    THEN
      ASSIGN
          cAlignmentImageName = gcPath + gcAlignCenter.

    httObjectInstance:FIND-FIRST("WHERE ttObjectInstance.d_object_instance_obj = ":U + QUOTER(ttWidget.dObjectInstanceObj)) NO-ERROR.

    IF dCustomizationResultObj       <> 0.00 AND
       httObjectInstance:AVAILABLE    = TRUE AND
       INDEX("LCR":U, ttWidget.cLCR) <> 0    THEN
    DO:
      CREATE BUFFER bhttObjectInstance FOR TABLE httObjectInstance.

      bhttObjectInstance:FIND-FIRST("WHERE ttObjectInstance.c_instance_name = '":U + httObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE + "' ":U
                                    + "AND ttObjectInstance.d_customization_result_obj = 0":U) NO-ERROR.

      IF bhttObjectInstance:AVAILABLE THEN
        ASSIGN
            cAlignmentImageName = cAlignmentImageName + gcCustSuffix.

      DELETE OBJECT bhttObjectInstance.
      bhttObjectInstance = ?.
    END.

    ASSIGN
        cAlignmentImageName         = cAlignmentImageName + cFImg
        cAlignmentImageName         = (IF SEARCH(cAlignmentImageName) = ? THEN REPLACE(cAlignmentImageName, cFImg, cSImg) ELSE cAlignmentImageName)
        ttWidget.hAlignment:TOOLTIP = TRIM(ttWidget.cObject) + (IF TRIM(ttWidget.cObject) <> "":U THEN " (":U + TRIM(ttWidget.cObjectType) + ")":U ELSE "":U).

    ttWidget.hAlignment:LOAD-IMAGE(cAlignmentImageName).
  END.

  ASSIGN        
      ttWidget.hHandle:HEIGHT-PIXELS = ttWidget.hHandle:HEIGHT-PIXELS - 1
      ttWidget.hHandle:HEIGHT-PIXELS = ttWidget.hHandle:HEIGHT-PIXELS + 1
      ttWidget.hHandle:WIDTH-PIXELS  = ttWidget.hHandle:WIDTH-PIXELS  - 1
      ttWidget.hHandle:WIDTH-PIXELS  = ttWidget.hHandle:WIDTH-PIXELS  + 1
      ttWidget.hHandle:TOOLTIP       = TRIM(ttWidget.cObject) + (IF TRIM(ttWidget.cObject) <> "":U THEN " (":U + TRIM(ttWidget.cObjectType) + ")":U ELSE "":U).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setWidgetSensitivity vTableWin 
FUNCTION setWidgetSensitivity RETURNS LOGICAL
  (plWidgetAvailable  AS LOGICAL,
   plDisableExcluded  AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  plWidgetAvailable can have 3 values
            1) FALSE - These are widgets that have objects on them
            2) TRUE  - These are widgets that objects can be dragged to
            3) ?     - These are empty widgets with no objects on them
------------------------------------------------------------------------------*/
  DEFINE BUFFER ttWidget FOR ttWidget.
  
  IF plDisableExcluded = ? THEN
    plDisableExcluded = TRUE.

  FOR EACH ttWidget:
    /* Enable the specified objects */
    IF ttWidget.lAvailable = plWidgetAvailable THEN
    DO:
      ttWidget.hHandle:SENSITIVE    = TRUE.

      IF VALID-HANDLE(ttWidget.hAlignment) THEN
        ttWidget.hAlignment:SENSITIVE = TRUE.
    END.
    ELSE
      IF plDisableExcluded THEN
      DO:
        /* Disable the excluded objects */
        ttWidget.hHandle:SENSITIVE    = FALSE.

        IF VALID-HANDLE(ttWidget.hAlignment) THEN
          ttWidget.hAlignment:SENSITIVE = FALSE.
      END.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION showHighlights vTableWin 
FUNCTION showHighlights RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContainerMode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSelectedWidget AS HANDLE     NO-UNDO.

  DEFINE BUFFER ttWidget FOR ttWidget.

  /* Hide the objects first - attempt to avoid flickering */
  hSelectedWidget = DYNAMIC-FUNCTION("getSelectedWidget":U).

  IF hSelectedWidget <> ? THEN
    FIND FIRST ttWidget
         WHERE ttWidget.hHandle = hSelectedWidget.

  /* If we have a source selected, reposition and show it */
  IF hSelectedWidget <> ? THEN
  DO:
    IF ttWidget.lAvailable <> ? THEN
    DO:
      IF ghSourceSelector:X <> hSelectedWidget:X - 1 OR
         ghSourceSelector:Y <> hSelectedWidget:Y - 1 THEN
        ASSIGN
            ghSourceSelector:HIDDEN        = TRUE
            ghSourceSelector:HEIGHT-PIXELS = hSelectedWidget:HEIGHT-PIXELS + 2 + (IF glCreateAlignment THEN giAlignmentHeight ELSE 0)
            ghSourceSelector:WIDTH-PIXELS  = hSelectedWidget:WIDTH-PIXELS  + 2
            ghSourceSelector:X             = hSelectedWidget:X - 1
            ghSourceSelector:Y             = hSelectedWidget:Y - 1
            ghSourceSelector:HIDDEN        = FALSE.
    END.
    ELSE
      ghSourceSelector:HIDDEN = TRUE.
  END.
  ELSE
    ghSourceSelector:HIDDEN = TRUE.

  cContainerMode = DYNAMIC-FUNCTION("getUserProperty":U, "ContainerMode":U).

  IF cContainerMode <> "UPDATE":U AND
     cContainerMode <> "ADD":U    THEN
    DYNAMIC-FUNCTION("showObjectDetails":U, hSelectedWidget).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION showObjectDetails vTableWin 
FUNCTION showObjectDetails RETURNS LOGICAL
  (phSelectedWidget AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCustomizationResultCode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cInstanceName             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectView               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lSuccess                  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE httObjectInstance         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httSmartObject            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hLookupFillIn             AS HANDLE     NO-UNDO.

  DEFINE BUFFER ttWidget FOR ttWidget.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        cCustomizationResultCode =               {fnarg getUserProperty 'CustomizationResultCode' ghContainerSource}
        dCustomizationResultObj  =       DECIMAL({fnarg getUserProperty 'CustomizationResultObj'  ghContainerSource})
        httObjectInstance        = WIDGET-HANDLE({fnarg getUserProperty 'ttObjectInstance'        ghContainerSource})
        httSmartObject           = WIDGET-HANDLE({fnarg getUserProperty 'ttSmartObject'           ghContainerSource})
        cObjectView              =               {fnarg getUserProperty 'ObjectView'}.

    {fn evaluateLookupQuery}.

    IF NOT VALID-HANDLE(httObjectInstance) THEN
      RETURN FALSE.

    httSmartObject:FIND-FIRST("WHERE d_smartobject_obj <> 0 AND d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj)) NO-ERROR.

    CREATE BUFFER httObjectInstance FOR TABLE httobjectInstance.

    FIND FIRST ttWidget
         WHERE ttWidget.hHandle = phSelectedWidget NO-ERROR.

    IF AVAILABLE ttWidget THEN
      httObjectInstance:FIND-FIRST("WHERE d_object_instance_obj = ":U + QUOTER(ttWidget.dObjectInstanceObj)
                                  + " AND d_smartobject_obj    <> 0":U
                                  + " AND d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj)) NO-ERROR.
    ELSE
      IF httObjectInstance:AVAILABLE THEN httObjectInstance:BUFFER-RELEASE().

    IF NOT httObjectInstance:AVAILABLE THEN
    DO:
      {fn clearFields}.

      IF (AVAILABLE ttWidget       AND
          ttWidget.lAvailable = ?) OR
          NOT AVAILABLE ttWidget   THEN
        ghSourceSelector:HIDDEN  = TRUE.

      IF fiObjectDescription:SENSITIVE = TRUE THEN
      DO:
        ASSIGN
            fiObjectDescription:SENSITIVE = FALSE
            buOldProperties:SENSITIVE     = FALSE
            fiInstanceName:SENSITIVE      = FALSE
            buProperties:SENSITIVE        = FALSE.

        IF cObjectView = "LayoutObjects":U THEN
          ASSIGN
              toResizeHorizontal:SENSITIVE = FALSE
              toResizeVertical:SENSITIVE   = FALSE
              buCopy:SENSITIVE             = FALSE
              buCut:SENSITIVE              = FALSE
              raLCR:SENSITIVE              = FALSE.
        ELSE
          edForeignFields:SENSITIVE = FALSE.

        RUN disableField IN hObjectFilename.
      END.

      IF VALID-HANDLE(ghObjectInstance) THEN
        ghObjectInstance:BUFFER-RELEASE().
    END.
    ELSE
    DO:
      IF VALID-HANDLE(ghObjectInstance) THEN
        ghObjectInstance:FIND-BY-ROWID(httObjectInstance:ROWID).
      ELSE
        ghObjectInstance = httObjectInstance.

      IF ghSourceSelector:HIDDEN = TRUE THEN
        ghSourceSelector:HIDDEN = FALSE.

      /* Only re-display if required... The reason for this is if something is displayed while somebody types a space at
         the end of a fill-in, it will be ignored... */
      IF {fnarg getUserProperty 'DontDisplay':U} <> "No":U THEN
        ASSIGN
            fiObjectDescription:SCREEN-VALUE = httObjectInstance:BUFFER-FIELD("c_instance_description":U):BUFFER-VALUE
            fiInstanceName:SCREEN-VALUE      = httObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE
            raLCR:SCREEN-VALUE               = ttWidget.cLCR
            toResizeHorizontal:CHECKED       = httObjectInstance:BUFFER-FIELD("l_resize_horizontal":U):BUFFER-VALUE
            toResizeVertical:CHECKED         = httObjectInstance:BUFFER-FIELD("l_resize_vertical":U):BUFFER-VALUE
            lSuccess                         = DYNAMIC-FUNCTION("setDataValue":U IN hObjectType, httObjectInstance:BUFFER-FIELD("d_object_type_obj":U):BUFFER-VALUE)
            hLookupFillIn                    = {fn getLookupHandle hObjectFilename}
            hLookupFillIn:SCREEN-VALUE       = httObjectInstance:BUFFER-FIELD("c_smartobject_filename":U):BUFFER-VALUE
            lSuccess                         = DYNAMIC-FUNCTION("setDataValue":U IN hObjectFilename, httObjectInstance:BUFFER-FIELD("d_smartobject_obj":U):BUFFER-VALUE)
            edForeignFields:SCREEN-VALUE     = DYNAMIC-FUNCTION("formatFFieldValue":U, httObjectInstance:BUFFER-FIELD("c_foreign_fields":U):BUFFER-VALUE).

      {fnarg evaluateRadioSet "BUFFER ttWidget"}.

      IF fiObjectDescription:SENSITIVE = FALSE THEN
      DO:
        ASSIGN
            fiObjectDescription:SENSITIVE = TRUE
            fiInstanceName:SENSITIVE      = TRUE.

        IF cObjectView = "LayoutObjects":U THEN
          ASSIGN
              toResizeHorizontal:SENSITIVE = TRUE
              toResizeVertical:SENSITIVE   = TRUE
              raLCR:SENSITIVE              = TRUE.
        ELSE
          edForeignFields:SENSITIVE = TRUE.

        RUN enableField IN hObjectFilename.
      END.

      IF cObjectView = "NonLayoutObjects":U THEN
        edForeignFields:SENSITIVE = TRUE.
      ELSE
        RUN evaluateSBOProperties IN TARGET-PROCEDURE (INPUT TRUE).

      /* Evaluate the cut, copy and paste options */
      ASSIGN
          buCopy:SENSITIVE = TRUE
          buCut:SENSITIVE  = TRUE.

      buPaste:SENSITIVE = FALSE.

      IF gdCoCInstanceObj <> 0.00 THEN
        buCancelCoC:SENSITIVE = TRUE.
      ELSE
        buCancelCoC:SENSITIVE = FALSE.

      IF LOOKUP(ttWidget.cObjectType, {fnarg getClassChildrenFromDB 'SmartFolder' gshRepositoryManager}) > 0 THEN
        ASSIGN
            toResizeHorizontal:SENSITIVE = FALSE
            toResizeVertical:SENSITIVE   = FALSE
            buCopy:SENSITIVE             = FALSE.
      ELSE
        ASSIGN
            toResizeHorizontal:SENSITIVE = TRUE
            toResizeVertical:SENSITIVE   = TRUE.

      /* Check to see if we are working with customizations. Depending on this, certain fields are not allowed to be updated and should be disabled. */
      IF httObjectInstance:BUFFER-FIELD("d_customization_result_obj":U):BUFFER-VALUE <> 0.00 THEN
      DO:
        cInstanceName = httObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE.

        /* It is ok to do a find on the same buffer as the original buffer is no longer required. Reusing the buffer will save resources as a
           buffer does not need to be created */

        httObjectInstance:FIND-FIRST("WHERE c_instance_name = '":U + cInstanceName + "' ":U
                                     + "AND d_customization_result_obj = 0":U) NO-ERROR.

        IF httObjectInstance:AVAILABLE THEN
        DO:
          RUN disableField IN hObjectFilename.

          ASSIGN
              fiInstanceName:SENSITIVE = FALSE
              buDelete:SENSITIVE       = FALSE.
        END.
        ELSE
        DO:
          RUN enableField IN hObjectFileName.

          ASSIGN
              fiInstanceName:SENSITIVE = TRUE
              buDelete:SENSITIVE       = TRUE.
        END.
      END.
      ELSE
      DO:
        RUN enableField IN hObjectFileName.

        /* This causes the field to redisplay its data and change the cursor offset?!?!!! */
        IF NOT fiInstanceName:SENSITIVE THEN fiInstanceName:SENSITIVE = TRUE.
        
        buDelete:SENSITIVE = TRUE.
      END.

      /* Finally reposition the PropertySheet to the current object if so desired */
      IF glReposPS THEN
        RUN displayProperties IN ghProcLib (INPUT ghContainerSource,
                                            INPUT httSmartObject:BUFFER-FIELD("d_smartobject_obj":U):BUFFER-VALUE,
                                            INPUT ghObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE,
                                            INPUT cCustomizationResultCode,
                                            INPUT TRUE,
                                            INPUT 0).

      {fn evaluateFFButton}.

      PUBLISH "instanceSelected":U FROM ghContainerSource (INPUT ghObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE).
    END.
  END.

  DELETE OBJECT httObjectInstance.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION showTargets vTableWin 
FUNCTION showTargets RETURNS LOGICAL
  (phSourceObject AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCurrentObjectLCR AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCutOrCopyMode    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cImageName        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFImg             AS CHARACTER  NO-UNDO.  /* First  Image Type */
  DEFINE VARIABLE cSImg             AS CHARACTER  NO-UNDO.  /* Second Image Type */
  DEFINE VARIABLE cCoCLCR           AS CHARACTER  NO-UNDO.   /* Alignment of instance that is cut or copied */
  DEFINE VARIABLE iCurrentObjectRow AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCurrentPage      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLastOccCol       AS INTEGER    NO-UNDO.  /* Last occupied column - in row */
  DEFINE VARIABLE iCurrentRow       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE httObjectInstance AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httObjectType     AS HANDLE     NO-UNDO.
  
  DEFINE BUFFER ttNextGridObject  FOR ttWidget.
  DEFINE BUFFER ttWidget          FOR ttWidget.

  /* Check to see if the cut object is on this page */
  ASSIGN
      cCutOrCopyMode = DYNAMIC-FUNCTION("getUserProperty":U, "CoCMode":U)
      cFImg          = TRIM(ENTRY(1, gcImageType, "/":U))
      cSImg          = TRIM(ENTRY(2, gcImageType, "/":U))
      cCoCLCR        = "":U.

  IF cCutOrCopyMode <> "Off":U THEN
  DO:
    ASSIGN
        httObjectInstance = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttObjectInstance":U)
        httObjectType     = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttObjectType":U)
        iCurrentPage      = DYNAMIC-FUNCTION("getCurrentPage":U IN ghContainerSource) - 1.

    CREATE BUFFER httObjectInstance FOR TABLE httObjectInstance.
    CREATE BUFFER httObjectType     FOR TABLE httObjectType.

    httObjectInstance:FIND-FIRST("WHERE d_object_instance_obj = ":U + QUOTER(gdCoCInstanceObj)) NO-ERROR.

    IF httObjectInstance:AVAILABLE THEN
    DO:
      cCoCLCR = httObjectInstance:BUFFER-FIELD("c_lcr":U):BUFFER-VALUE.

      httObjectType:FIND-FIRST("WHERE d_object_type_obj = ":U + QUOTER(httObjectInstance:BUFFER-FIELD("d_object_type_obj":U):BUFFER-VALUE)) NO-ERROR.
    END.

    IF  httObjectType:AVAILABLE                                         = TRUE            
    AND LOOKUP(httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE, {fnarg getClassChildrenFromDB 'SmartFolder':U gshRepositoryManager}) > 0 
    AND iCurrentPage                                                   <> 0 THEN
      RETURN FALSE.
    
    FIND FIRST ttNextGridObject
         WHERE ttNextGridObject.dObjectInstanceObj = gdCoCInstanceObj NO-ERROR.

    IF AVAILABLE ttNextGridObject THEN
      phSourceObject = ttNextGridObject.hHandle.

    buCancelCoC:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.

    DELETE OBJECT httObjectInstance.
    DELETE OBJECT httObjectType.

    ASSIGN
        httObjectInstance = ?
        httObjectType     = ?.
  END.
  ELSE
    ASSIGN
        buCancelCoC:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE
        buPaste:SENSITIVE     IN FRAME {&FRAME-NAME} = FALSE.
  
  IF VALID-HANDLE(phSourceObject) THEN
  DO:
    FIND ttWidget WHERE
         ttWidget.hHandle = phSourceObject.
    
    ASSIGN
        cCurrentObjectLCR = ttWidget.cLCR
        iCurrentObjectRow = ttWidget.iRow.
  END.
  ELSE  
    ASSIGN
        cCurrentObjectLCR = cCoCLCR  /* If we are not in CutOrCopyMode, this would be blank anyway */
        iCurrentObjectRow = 0.

  FOR EACH ttWidget
     WHERE ttWidget.iRow <= giNumRows
       AND ttWidget.iCol <= giNumColumns
     BREAK
        BY ttWidget.iRow
        BY ttWidget.iCol:
    
    IF FIRST-OF(ttWidget.iRow) THEN
      ASSIGN
          iLastOccCol = 0
          iCurrentRow = ttWidget.iRow.
    
    IF ttWidget.cObject <> "":U THEN
      iLastOccCol = ttWidget.iCol.
    
    IF LAST-OF(ttWidget.iRow) THEN
    DO:
      FIND ttNextGridObject WHERE
           ttNextGridObject.iRow = ttWidget.iRow
       AND ttNextGridObject.iCol = iLastOccCol + 1 NO-ERROR.
      
      /* The record will not be available if iLastOccCol would be 9 */
      IF NOT AVAILABLE ttNextGridObject THEN
        NEXT.
      
      /* Insert validation for center and right justification:
         CENTER */
      IF CAN-FIND(FIRST ttWidget
                  WHERE ttWidget.iRow = ttNextGridObject.iRow
                    AND ttWidget.cLCR = "C":U)                OR
        (CAN-FIND(FIRST ttWidget
                  WHERE ttWidget.iRow = iCurrentRow
                    AND lAvailable    = FALSE)            AND  /* If any object is in the row */
         cCurrentObjectLCR            = "C":U)            THEN
        NEXT.
      
      /* RIGHT */
      IF CAN-FIND(FIRST ttWidget
                  WHERE ttWidget.iRow = iCurrentRow
                    AND lAvailable    = FALSE
                    AND ttWidget.cLCR = "R":U)      AND  /* If any object in a row is right justified */
         cCurrentObjectLCR            = "R":U       THEN
        NEXT.

      /* LEFT */
      IF cCurrentObjectLCR            = "L":U       AND
         iCurrentObjectRow            = iCurrentRow AND
        (VALID-HANDLE(phSourceObject) = TRUE        AND cCutOrCopyMode <> "Copy":U) THEN
        NEXT.
      
      ASSIGN
          cImageName = gcPath + gcImgAvail + cFImg
          cImageName = (IF SEARCH(cImageName) = ? THEN REPLACE(cImageName, cFImg, cSImg) ELSE cImageName)

          ttNextGridObject.hHandle:STRETCH-TO-FIT = TRUE /*glStretchToFit*/
          ttNextGridObject.hHandle:TRANSPARENT    = FALSE
          ttNextGridObject.hHandle:SENSITIVE      = TRUE
          ttNextGridObject.lAvailable             = TRUE.

      ttNextGridObject.hHandle:LOAD-IMAGE(cImageName).

      IF VALID-HANDLE(ttNextGridObject.hAlignment) THEN
      DO:
        ASSIGN    
            ttNextGridObject.hAlignment:STRETCH-TO-FIT = TRUE /*glStretchToFit*/
            ttNextGridObject.hAlignment:TRANSPARENT    = FALSE
            ttNextGridObject.hAlignment:SENSITIVE      = TRUE.

        ttNextGridObject.hAlignment:LOAD-IMAGE(cImageName).
      END.
    END.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION swapSourceTarget vTableWin 
FUNCTION swapSourceTarget RETURNS LOGICAL
  (phSourceObject AS HANDLE,
   phTargetObject AS HANDLE,
   plPerformCrop  AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjectType         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObject             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLCR                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dObjectInstanceObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lAvailable          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE httObjectInstance   AS HANDLE     NO-UNDO.

  DEFINE BUFFER ttSourceObject FOR ttWidget.
  DEFINE BUFFER ttTargetObject FOR ttWidget.

  CREATE BUFFER httObjectInstance FOR TABLE ghObjectInstance.

  FIND ttSourceObject WHERE
       ttSourceObject.hHandle = phSourceObject.
  
  FIND ttTargetObject WHERE
       ttTargetObject.hHandle = phTargetObject.
       
  /* Update the SOURCE object instance */
  httObjectInstance:FIND-FIRST("WHERE d_object_instance_obj = ":U + QUOTER(ttSourceObject.dObjectInstanceObj)
                              + " AND d_smartobject_obj    <> 0":U) NO-ERROR.
  DYNAMIC-FUNCTION("setSelectedWidget":U, ttTargetObject.hHandle).

  IF httObjectInstance:AVAILABLE THEN
    ASSIGN
        raLCR:SCREEN-VALUE IN FRAME {&FRAME-NAME}                          = httObjectInstance:BUFFER-FIELD("c_lcr":U):BUFFER-VALUE
        httObjectInstance:BUFFER-FIELD("i_row":U):BUFFER-VALUE             = ttTargetObject.iRow
        httObjectInstance:BUFFER-FIELD("i_column":U):BUFFER-VALUE          = ttTargetObject.iCol
      /*httObjectInstance:BUFFER-FIELD("i_page":U):BUFFER-VALUE            = iCurrentPage*/
        httObjectInstance:BUFFER-FIELD("c_layout_position":U):BUFFER-VALUE = DYNAMIC-FUNCTION("getLayoutCode":U, FALSE)
        httObjectInstance:BUFFER-FIELD("c_action":U):BUFFER-VALUE          = (IF httObjectInstance:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "":U THEN "M":U ELSE httObjectInstance:BUFFER-FIELD("c_action":U):BUFFER-VALUE).

  /* Update the TARGET object instance */
  httObjectInstance:FIND-FIRST("WHERE d_object_instance_obj = ":U + QUOTER(ttTargetObject.dObjectInstanceObj)
                              + " AND d_smartobject_obj    <> 0":U) NO-ERROR.
  DYNAMIC-FUNCTION("setSelectedWidget":U, ttSourceObject.hHandle).

  IF httObjectInstance:AVAILABLE THEN
    ASSIGN
        httObjectInstance:BUFFER-FIELD("i_row":U):BUFFER-VALUE             = ttSourceObject.iRow
        httObjectInstance:BUFFER-FIELD("i_column":U):BUFFER-VALUE          = ttSourceObject.iCol
      /*httObjectInstance:BUFFER-FIELD("i_page":U):BUFFER-VALUE            = iCurrentPage*/
        httObjectInstance:BUFFER-FIELD("c_layout_position":U):BUFFER-VALUE = DYNAMIC-FUNCTION("getLayoutCode":U, FALSE)
        httObjectInstance:BUFFER-FIELD("c_action":U):BUFFER-VALUE          = (IF httObjectInstance:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "":U THEN "M":U ELSE httObjectInstance:BUFFER-FIELD("c_action":U):BUFFER-VALUE).

  ASSIGN
      dObjectInstanceObj                = ttSourceObject.dObjectInstanceObj
      cObjectType                       = ttSourceObject.cObjectType
      cObject                           = ttSourceObject.cObject
      cLCR                              = ttSourceObject.cLCR
      lAvailable                        = ttSourceObject.lAvailable
      ttSourceObject.dObjectInstanceObj = ttTargetObject.dObjectInstanceObj
      ttSourceObject.cObjectType        = ttTargetObject.cObjectType
      ttSourceObject.cObject            = ttTargetObject.cObject
      ttSourceObject.cLCR               = ttTargetObject.cLCR
      ttSourceObject.lAvailable         = ttTargetObject.lAvailable
      ttTargetObject.dObjectInstanceObj = dObjectInstanceObj
      ttTargetObject.cObjectType        = cObjectType
      ttTargetObject.cObject            = cObject
      ttTargetObject.cLCR               = cLCR
      ttTargetObject.lAvailable         = lAvailable.

  {fnarg lockWindow TRUE ghContainerSource}.

  /* Refresh the display of the target and source widget */
  DYNAMIC-FUNCTION("setWidgetProperties":U, INPUT phTargetObject).
  DYNAMIC-FUNCTION("setWidgetProperties":U, INPUT phSourceObject).

  {fnarg lockWindow FALSE ghContainerSource}.

  IF plPerformCrop = TRUE THEN
  DO:
    DYNAMIC-FUNCTION("setSelectedWidget":U, phTargetObject).
    
    ASSIGN
        ghTargetObject = phSourceObject
        lAvailable     = DYNAMIC-FUNCTION("cropWidgets":U) /* Just re-using lAvailable */.
  END.

  DELETE OBJECT httObjectInstance.
  httObjectInstance = ?.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION updatePropertyValue vTableWin 
FUNCTION updatePropertyValue RETURNS LOGICAL
  (pcObject         AS CHARACTER,
   pcAttributeLabel AS CHARACTER,
   pcAttributeValue AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:

    IF NOT VALID-HANDLE(ghObjectInstance) OR
       NOT ghObjectInstance:AVAILABLE     THEN
      RETURN FALSE.  /* Function return value. */

    IF DECIMAL(pcObject) = ghObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE THEN
    DO:
      CASE pcAttributeLabel:
        WHEN "ResizeHorizontal":U THEN toResizeHorizontal:CHECKED = pcAttributeValue = "yes":U.
        WHEN "ResizeVertical":U   THEN toResizeVertical:CHECKED   = pcAttributeValue = "yes":U.
        
        WHEN "ForeignFields":U THEN
          IF DYNAMIC-FUNCTION("getUserProperty":U, "DontDisplay":U) <> "No":U THEN
            edForeignFields:SCREEN-VALUE = DYNAMIC-FUNCTION("formatFFieldValue":U, pcAttributeValue).

        WHEN "NavigationTargetName":U OR
        WHEN "UpdateTargetNames":U    OR
        WHEN "DataSourceNames":U      THEN
          IF {fnarg getUserProperty 'DontDisplay':U} <> "No":U THEN
            RUN evaluateSBOProperties IN TARGET-PROCEDURE (INPUT FALSE).
      END CASE.
    END.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

