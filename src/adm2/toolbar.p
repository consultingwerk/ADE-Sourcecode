&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : toolbar.p
    Purpose     : Super procedure for toolbar class.

    Syntax      : RUN start-super-proc("adm2/toolbar.p":U).

    Modified    : 1/12/2000
    Modified    : 03/25/2002      Mark Davies (MIP)
                  Added getMinHeight override procedure.
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&SCOP ADMSuper toolbar.p
&SCOP adm-panel-type toolbar
  /* Custom exclude file */

  {src/adm2/custom/toolbarexclcustom.i}

/* This variable is needed at least temporarily in 9.1B so that a called
   fn can tell who the actual source was.  */
DEFINE VARIABLE ghTargetProcedure AS HANDLE     NO-UNDO.
DEFINE VARIABLE xcNoCategory      AS CHARACTER  NO-UNDO  INIT '<none>':U.
DEFINE VARIABLE xcWindowBand      AS CHARACTER  NO-UNDO  INIT 'Window':U.

{src/adm2/tttoolbar.i}

DEFINE TEMP-TABLE tBandInstance 
 FIELD hTarget     AS HANDLE
 FIELD Band        AS CHAR
 FIELD Hdl         AS HANDLE
 FIELD RefreshBand AS LOG 
INDEX Hdl hdl hTarget
INDEX hTarget hTarget Band.

DEFINE TEMP-TABLE tMenu 
 FIELD hTarget      AS HANDLE
 FIELD Name         AS CHAR
 FIELD ParentHdl    AS HANDLE
 FIELD Caption      AS CHAR
 FIELD Link         AS CHAR 
 FIELD Hdl          AS HANDLE
 FIELD MergeOrder   AS INT
 FIELD Parent       AS CHAR
 FIELD Seq          AS INT 
 FIELD Refresh      AS LOG 
 FIELD Sensitive    AS LOG 
 FIELD Disabled     AS LOG 
INDEX MenuId  ParentHdl Caption Link 
INDEX Name    Name Parent hTarget Seq
INDEX Refresh Refresh hTarget Parent 
INDEX Link    hTarget Link Seq
INDEX Hdl     Hdl hTarget
INDEX Parent  AS PRIMARY hTarget Parent Seq.

DEFINE TEMP-TABLE tButton 
 FIELD hTarget      AS HANDLE
 FIELD Name         AS CHAR
 FIELD Band         AS CHAR
 FIELD Link         AS CHAR
 FIELD ImageAlt     AS LOG INIT ?
 FIELD Position     AS INT    /* initial position, used for sorting */  
 FIELD Hdl          AS HANDLE
 FIELD Disabled     AS LOG
 FIELD Sensitive    AS LOG 
INDEX Target AS PRIMARY hTarget Position
INDEX Band   Band hTarget Position
INDEX Link   hTarget Link Position
INDEX Name   Name Band hTarget.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-actionCanRun) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionCanRun Procedure 
FUNCTION actionCanRun RETURNS LOGICAL
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionCaption) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionCaption Procedure 
FUNCTION actionCaption RETURNS CHARACTER
  ( pcAction AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionCategoryIsHidden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionCategoryIsHidden Procedure 
FUNCTION actionCategoryIsHidden RETURNS LOGICAL
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionChecked) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionChecked Procedure 
FUNCTION actionChecked RETURNS LOGICAL
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionLabel Procedure 
FUNCTION actionLabel RETURNS CHARACTER
  ( pcAction AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionPublishCreate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionPublishCreate Procedure 
FUNCTION actionPublishCreate RETURNS LOGICAL
  ( pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionTarget Procedure 
FUNCTION actionTarget RETURNS HANDLE
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionTooltip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionTooltip Procedure 
FUNCTION actionTooltip RETURNS CHARACTER
  ( pcAction AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adjustActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD adjustActions Procedure 
FUNCTION adjustActions RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bandActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD bandActions Procedure 
FUNCTION bandActions RETURNS CHARACTER
  ( pcParentBand AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bandSubmenuLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD bandSubmenuLabel Procedure 
FUNCTION bandSubmenuLabel RETURNS CHARACTER
  ( pcBand      AS CHARACTER,
    pcChildBand AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bandSubmenus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD bandSubmenus Procedure 
FUNCTION bandSubmenus RETURNS CHARACTER
  ( pcParentBand AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildMenu Procedure 
FUNCTION buildMenu RETURNS LOGICAL
  (pcParent AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-categoryActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD categoryActions Procedure 
FUNCTION categoryActions RETURNS CHARACTER
  ( pcCategory AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-constructMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD constructMenu Procedure 
FUNCTION constructMenu RETURNS LOGICAL
    ( ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-constructMenuBand) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD constructMenuBand Procedure 
FUNCTION constructMenuBand RETURNS LOGICAL
  (pcBand AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-constructObjectMenus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD constructObjectMenus Procedure 
FUNCTION constructObjectMenus RETURNS LOGICAL
  ( pcBand  AS CHAR,
    pcPlaceholder AS CHAR, 
    plBlank AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-constructToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD constructToolbar Procedure 
FUNCTION constructToolbar RETURNS LOGICAL
    ( ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-create3DRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD create3DRule Procedure 
FUNCTION create3DRule RETURNS HANDLE
  (              phParent     AS HANDLE,     /* handle to the parent frame */
    INPUT-OUTPUT piXY         AS INTEGER    /* the x - posistion */                 
  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createButton Procedure 
FUNCTION createButton RETURNS HANDLE
  (              phFrame      AS HANDLE,
    INPUT-OUTPUT piXY         AS INTEGER, 
                 pcName       AS CHARACTER,
                 pcLabel      AS CHARACTER,
                 pcTooltip    AS CHARACTER,
                 pcImage      AS CHARACTER,  
                 plSensitive  AS LOGICAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createMenuAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createMenuAction Procedure 
FUNCTION createMenuAction RETURNS HANDLE
  ( pcParent AS CHAR,
    pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createMenuBar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createMenuBar Procedure 
FUNCTION createMenuBar RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createMenuItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createMenuItem Procedure 
FUNCTION createMenuItem /**
*   @desc  Creates a menuitem 
*   @param <code>input pihParent handle</code> handle to (sub)menu
*   @param <code>input picName character</code> Name of menuitem
*   @param <code>input picCaption character</code>  Caption 
*   @param <code>input pilSensitive logical</code>  Item sensitive or not
*   @returns handle to menuitem
*/
RETURNS HANDLE
  ( phParent     AS HANDLE,     
    pcName       AS CHARACTER, 
    pcCaption    AS CHARACTER,  
    pcAccelerator AS CHARACTER,
    plSensitive  AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createMenuTempTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createMenuTempTable Procedure 
FUNCTION createMenuTempTable RETURNS LOGICAL PRIVATE
  (pcParent    AS CHAR,
   pcName      AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createMenuToggle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createMenuToggle Procedure 
FUNCTION createMenuToggle /**
*   @desc  Creates a menuitem 
*   @param <code>input pihParent handle</code> handle to (sub)menu
*   @param <code>input picName character</code> Name of menuitem
*   @param <code>input picCaption character</code>  Caption 
*   @param <code>input pilSensitive logical</code>  Item sensitive or not
*   @returns handle to menuitem
*/
RETURNS HANDLE
  ( phParent      AS HANDLE,
    pcName        AS CHARACTER,
    pcCaption     AS CHARACTER,
    pcAccelerator AS CHARACTER,
    plSensitive   AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createRule Procedure 
FUNCTION createRule /**
*   @desc  Creates a rule
*   @param <code>input pihParent handle</code> handle to (sub)menu
*   @returns handle to rule
*/
RETURNS HANDLE
  ( phParent AS HANDLE /* Handle of the Parent */
  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createSubMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createSubMenu Procedure 
FUNCTION createSubMenu /**
*   @desc  Creates a menuitem 
*   @param <code>input pihParent handle</code> handle to (sub)menu
*   @param <code>input picName character</code> Name of menuitem
*   @param <code>input picCaption character</code>  Caption 
*   @param <code>input pilSensitive logical</code>  Item sensitive or not
*   @returns handle to menuitem
*/
RETURNS HANDLE
  ( phParent     AS HANDLE,    /* Handle of the parent */
    pcName       AS CHARACTER, /* Name of the to be created submenu */
    pcCaption    AS CHARACTER, /* Caption of the be created submenu */
    plSensitive  AS LOGICAL    /* If the submenu has to be sensitive */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createToolbar Procedure 
FUNCTION createToolbar RETURNS LOGICAL
  (pcActions AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createToolbarAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createToolbarAction Procedure 
FUNCTION createToolbarAction RETURNS HANDLE
  (pcBand            AS CHAR, 
   pcName            AS CHAR,
   INPUT-OUTPUT piXY AS INT) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createToolbarBorder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createToolbarBorder Procedure 
FUNCTION createToolbarBorder RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteMenu Procedure 
FUNCTION deleteMenu RETURNS LOGICAL
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteToolbar Procedure 
FUNCTION deleteToolbar RETURNS LOGICAL
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getActionGroups) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getActionGroups Procedure 
FUNCTION getActionGroups RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAvailMenuActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAvailMenuActions Procedure 
FUNCTION getAvailMenuActions RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAvailToolbarActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAvailToolbarActions Procedure 
FUNCTION getAvailToolbarActions RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAvailToolbarBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAvailToolbarBands Procedure 
FUNCTION getAvailToolbarBands RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBoxRectangle2) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBoxRectangle2 Procedure 
FUNCTION getBoxRectangle2 RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCommitTarget Procedure 
FUNCTION getCommitTarget RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCommitTargetEvents Procedure 
FUNCTION getCommitTargetEvents RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisabledActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDisabledActions Procedure 
FUNCTION getDisabledActions RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEdgePixels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEdgePixels Procedure 
FUNCTION getEdgePixels RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFlatButtons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFlatButtons Procedure 
FUNCTION getFlatButtons RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHiddenActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHiddenActions Procedure 
FUNCTION getHiddenActions RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHiddenMenuBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHiddenMenuBands Procedure 
FUNCTION getHiddenMenuBands RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHiddenToolbarBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHiddenToolbarBands Procedure 
FUNCTION getHiddenToolbarBands RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getImagePath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getImagePath Procedure 
FUNCTION getImagePath RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLinkTargetNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLinkTargetNames Procedure 
FUNCTION getLinkTargetNames RETURNS CHARACTER
 (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMenu Procedure 
FUNCTION getMenu /**
*   @desc  Get attribute
*   @return attribute value true/false
*/
RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMenuMergeOrder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMenuMergeOrder Procedure 
FUNCTION getMenuMergeOrder RETURNS INTEGER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMinHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMinHeight Procedure 
FUNCTION getMinHeight RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMinWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMinWidth Procedure 
FUNCTION getMinWidth RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNavigationTarget Procedure 
FUNCTION getNavigationTarget RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNavigationTargetEvents Procedure 
FUNCTION getNavigationTargetEvents RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSecuredTokens) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSecuredTokens Procedure 
FUNCTION getSecuredTokens RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getShowBorder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getShowBorder Procedure 
FUNCTION getShowBorder RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSubModules) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSubModules Procedure 
FUNCTION getSubModules RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableioTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTableioTarget Procedure 
FUNCTION getTableioTarget RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableioTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTableioTargetEvents Procedure 
FUNCTION getTableioTargetEvents RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableIOType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTableIOType Procedure 
FUNCTION getTableIOType RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTargetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTargetProcedure Procedure 
FUNCTION getTargetProcedure RETURNS HANDLE
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbar Procedure 
FUNCTION getToolbar /**
*   @desc  Get attribute
*   @return attribute value true/false
*/
RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarAutoSize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarAutoSize Procedure 
FUNCTION getToolbarAutoSize RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarBands Procedure 
FUNCTION getToolbarBands RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarDrawDirection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarDrawDirection Procedure 
FUNCTION getToolbarDrawDirection RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarHeightPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarHeightPxl Procedure 
FUNCTION getToolbarHeightPxl RETURNS INTEGER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarMinWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarMinWidth Procedure 
FUNCTION getToolbarMinWidth RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarParentMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarParentMenu Procedure 
FUNCTION getToolbarParentMenu RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarTarget Procedure 
FUNCTION getToolbarTarget RETURNS CHARACTER
    ( ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarTargetEvents Procedure 
FUNCTION getToolbarTargetEvents RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarWidthPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarWidthPxl Procedure 
FUNCTION getToolbarWidthPxl RETURNS INTEGER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolHeightPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolHeightPxl Procedure 
FUNCTION getToolHeightPxl RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolMarginPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolMarginPxl Procedure 
FUNCTION getToolMarginPxl RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolMaxWidthPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolMaxWidthPxl Procedure 
FUNCTION getToolMaxWidthPxl RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolSeparatorPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolSeparatorPxl Procedure 
FUNCTION getToolSeparatorPxl RETURNS INTEGER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolSpacingPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolSpacingPxl Procedure 
FUNCTION getToolSpacingPxl RETURNS INTEGER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolWidthPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolWidthPxl Procedure 
FUNCTION getToolWidthPxl RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWindow Procedure 
FUNCTION getWindow RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-imageName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD imageName Procedure 
FUNCTION imageName RETURNS CHARACTER
  ( pcAction AS CHAR,
    piNumber AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-insertMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD insertMenu Procedure 
FUNCTION insertMenu RETURNS LOGICAL
  (pcParent  AS CHARACTER,
   pcActions AS CHARACTER,
   plExpand  AS LOGICAL,
   pcBefore  AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-insertMenuTempTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD insertMenuTempTable Procedure 
FUNCTION insertMenuTempTable RETURNS LOGICAL PRIVATE
  (pcParent    AS CHAR,
   pcName      AS CHAR,
   pcBefore    AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-menuHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD menuHandle Procedure 
FUNCTION menuHandle RETURNS HANDLE PRIVATE
  (pcName AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-modifyDisabledActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD modifyDisabledActions Procedure 
FUNCTION modifyDisabledActions RETURNS LOGICAL
  ( pcMode    AS CHAR,
    pcActions AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-moveMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD moveMenu Procedure 
FUNCTION moveMenu RETURNS HANDLE
  ( phMenu      AS HANDLE,
    phNewParent AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-moveMenuChildren) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD moveMenuChildren Procedure 
FUNCTION moveMenuChildren RETURNS LOGICAL
  ( phOldParent AS HANDLE,
    phNewParent AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sensitizeActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD sensitizeActions Procedure 
FUNCTION sensitizeActions RETURNS LOGICAL
  (pcActions AS CHAR,
   plSensitive AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setActionGroups) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setActionGroups Procedure 
FUNCTION setActionGroups RETURNS LOGICAL
  (pcActionGroups AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAvailMenuActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAvailMenuActions Procedure 
FUNCTION setAvailMenuActions RETURNS LOGICAL
  (pcAvailMenuActions AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAvailToolbarActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAvailToolbarActions Procedure 
FUNCTION setAvailToolbarActions RETURNS LOGICAL
  (pcAvailToolbarActions AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBoxRectangle2) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBoxRectangle2 Procedure 
FUNCTION setBoxRectangle2 RETURNS LOGICAL
  ( hValue AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCommitTarget Procedure 
FUNCTION setCommitTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCommitTargetEvents Procedure 
FUNCTION setCommitTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisabledActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDisabledActions Procedure 
FUNCTION setDisabledActions RETURNS LOGICAL
  ( pcActions AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEdgePxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setEdgePxl Procedure 
FUNCTION setEdgePxl RETURNS LOGICAL
( iValue AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFlatButtons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFlatButtons Procedure 
FUNCTION setFlatButtons RETURNS LOGICAL
  ( plFlatButtons AS LOGICAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHiddenActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setHiddenActions Procedure 
FUNCTION setHiddenActions RETURNS LOGICAL
  ( pcActions AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHiddenMenuBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setHiddenMenuBands Procedure 
FUNCTION setHiddenMenuBands RETURNS LOGICAL
  (pcHiddenBands AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHiddenToolbarBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setHiddenToolbarBands Procedure 
FUNCTION setHiddenToolbarBands RETURNS LOGICAL
  (pcHiddenBands AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setImagePath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setImagePath Procedure 
FUNCTION setImagePath RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLinkTargetNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLinkTargetNames Procedure 
FUNCTION setLinkTargetNames RETURNS LOGICAL
  ( pcLinkList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMenu Procedure 
FUNCTION setMenu RETURNS LOGICAL
  ( plMenu AS LOGICAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMenuMergeOrder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMenuMergeOrder Procedure 
FUNCTION setMenuMergeOrder RETURNS LOGICAL
  ( piOrder AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNavigationTarget Procedure 
FUNCTION setNavigationTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNavigationTargetEvents Procedure 
FUNCTION setNavigationTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSecuredTokens) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSecuredTokens Procedure 
FUNCTION setSecuredTokens RETURNS LOGICAL
  ( pcSecuredTokens AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setShowBorder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setShowBorder Procedure 
FUNCTION setShowBorder RETURNS LOGICAL
  ( plShowBorder AS LOGICAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSubModules) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSubModules Procedure 
FUNCTION setSubModules RETURNS LOGICAL
  ( pcSubModules AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTableIOButtons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTableIOButtons Procedure 
FUNCTION setTableIOButtons RETURNS LOGICAL
  ( pcState AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTableIOTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTableIOTarget Procedure 
FUNCTION setTableIOTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTableIOTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTableIOTargetEvents Procedure 
FUNCTION setTableIOTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTableioType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTableioType Procedure 
FUNCTION setTableioType RETURNS LOGICAL
  ( pcType AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolbar Procedure 
FUNCTION setToolbar RETURNS LOGICAL
  ( plToolbar AS LOGICAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarAutosize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolbarAutosize Procedure 
FUNCTION setToolbarAutosize RETURNS LOGICAL
  ( plToolbarAutoSize AS LOGICAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolbarBands Procedure 
FUNCTION setToolbarBands RETURNS LOGICAL
  (pcToolbarBands AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarDrawDirection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolbarDrawDirection Procedure 
FUNCTION setToolbarDrawDirection RETURNS LOGICAL
  (pcToolbarDrawDirection AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarMinWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolbarMinWidth Procedure 
FUNCTION setToolbarMinWidth RETURNS LOGICAL
  ( pdMinWidth AS DEC )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarParentMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolbarParentMenu Procedure 
FUNCTION setToolbarParentMenu RETURNS LOGICAL
  (pcToolbarParentMenu AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolbarTarget Procedure 
FUNCTION setToolbarTarget RETURNS LOGICAL
    ( pcTarget AS CHARACTER  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolbarTargetEvents Procedure 
FUNCTION setToolbarTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolHeightPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolHeightPxl Procedure 
FUNCTION setToolHeightPxl RETURNS LOGICAL
  ( iValue AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolMarginPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolMarginPxl Procedure 
FUNCTION setToolMarginPxl RETURNS LOGICAL
  ( iValue AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolMaxWidthPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolMaxWidthPxl Procedure 
FUNCTION setToolMaxWidthPxl RETURNS LOGICAL
    ( iValue AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolSeparatorPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolSeparatorPxl Procedure 
FUNCTION setToolSeparatorPxl RETURNS LOGICAL
    ( iValue AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolSpacingPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolSpacingPxl Procedure 
FUNCTION setToolSpacingPxl RETURNS LOGICAL
    ( iValue AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolWidthPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolWidthPxl Procedure 
FUNCTION setToolWidthPxl RETURNS LOGICAL
  ( iValue AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-substituteActionText) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD substituteActionText Procedure 
FUNCTION substituteActionText RETURNS CHARACTER
  ( pcAction AS CHAR,
    pcText   AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-supportedObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD supportedObjects Procedure 
FUNCTION supportedObjects RETURNS CHARACTER
  (plLoaded AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-targetActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD targetActions Procedure 
FUNCTION targetActions RETURNS CHARACTER
  ( pcLinkType AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-windowDropDownList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD windowDropDownList Procedure 
FUNCTION windowDropDownList RETURNS LOGICAL
  ( pcBand AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 20.71
         WIDTH              = 52.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/toolprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-buildAllMenus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildAllMenus Procedure 
PROCEDURE buildAllMenus :
/*------------------------------------------------------------------------------
  Purpose:     Builds all branches of submenus before the persistent trigger 
               On MENU-DROP creates them on mouse click. 
               This will enables shortcuts (accelerators) from the very beginning.                                                                         
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lOK      AS LOGICAL    NO-UNDO.

DEFINE BUFFER btMenu FOR tMenu.

FOR EACH btMenu WHERE btMenu.PARENT = '':
  lOK = DYNAMIC-FUNCTION('BuildMenu' IN TARGET-PROCEDURE, btMenu.NAME).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearCache Procedure 
PROCEDURE clearCache :
/*------------------------------------------------------------------------------
 Purpose:  Clear cached data by Emptying temp-tables       
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN clearToolbarCache IN TARGET-PROCEDURE.
  RUN SUPER.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearToolbarCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearToolbarCache Procedure 
PROCEDURE clearToolbarCache :
/*------------------------------------------------------------------------------
  Purpose:  Clear cached data by Empty temp-tables     
  Parameters: 
   Notes:   Called from instance clearCache but also directly from 
             session manager         
------------------------------------------------------------------------------*/
  EMPTY TEMP-TABLE ttToolbarBand.
  EMPTY TEMP-TABLE ttObjectBand. 
  EMPTY TEMP-TABLE ttBand.
  EMPTY TEMP-TABLE ttBandAction.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:  Destroy dynamic widgets when the object is destroyed.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
  {fn deleteToolbar}.
  {fn deleteMenu}.
  
  RUN SUPER.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-filterState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE filterState Procedure 
PROCEDURE filterState :
/*------------------------------------------------------------------------------
  Purpose:     published from Navigation-Target to tell the panel when to enable
               filter action (when its linked).
  Parameters:  INPUT pcState AS CHARACTER - 'FilterAvailable'
  Notes:      
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.

  IF pcState = 'FilterAvailable':U THEN
      RUN setButtons IN TARGET-PROCEDURE ('enable-filter':U).
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hideObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE hideObject Procedure 
PROCEDURE hideObject :
/*----------------------------------------------------------------------------
  Purpose: Hide the object 
           The purpose for the override is to remove the menu bar handle 
           from the window for non-repository objects.  
Parameters: <none> 
     Notes: This somewhat strange removal of the menu bar on hide was 
            implemented mostly because we did not support   
     
            Repository objects allows different toolbars to share the menubar
            and does not need to hide it when the object is hidden. 
            
-----------------------------------------------------------------------------*/
  DEFINE VARIABLE hWindow        AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hMenu          AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lUseRepository AS LOGICAL    NO-UNDO.
  
  {get UseRepository lUseRepository}.
  IF NOT lUseRepository THEN
  DO:
    {get Window hWindow}.
    {get MenubarHandle hMenu}.

    IF VALID-HANDLE(hWindow) THEN 
    DO:
      /* Only remove if it is our own menubar */
      IF hWindow:MENUBAR = hMenu THEN 
        hWindow:MENUBAR = ?.
    END.
  END.

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose: initialize the toolbar by creating all dynmaic buttons and menues.     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lToolBar       AS LOG        NO-UNDO.
  DEFINE VARIABLE lMenu          AS LOG        NO-UNDO.
  DEFINE VARIABLE cBlank         AS CHAR       NO-UNDO.
  DEFINE VARIABLE hFrame         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWindow        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hPopupFrame    AS HANDLE NO-UNDO.
  DEFINE VARIABLE cUIBMode       AS CHAR       NO-UNDO.
  DEFINE VARIABLE lInit          AS LOG        NO-UNDO.
  DEFINE VARIABLE cInfo          AS CHAR       NO-UNDO.
  DEFINE VARIABLE lHideOnInit    AS LOGICAL NO-UNDO.
  DEFINE VARIABLE lUseRepository AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cTableioType AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cHidden      AS CHARACTER  NO-UNDO.
  
  /* Tableiotype 'save' is managed by HiddenActions from 9.1D */ 
  {get TableioType cTableioType}.
  {get HiddenActions cHidden}.
  IF cTableioType = 'Save':U AND LOOKUP('update':U,cHidden) = 0 THEN
  DO:
    cHidden  = cHidden 
             + (IF cHidden = '':U THEN '':U ELSE ',':U) 
             + 'Update':U.
    {set HiddenActions cHidden}.
  END.

  {get UIBMode cUIBmode}.
  {get Menu lMenu}.
  {get UseRepository lUseRepository}.

  IF NOT cUIBMode BEGINS "DESIGN":U THEN 
  DO:
    /* The sbo subscribes to this event in order to update ObjectMapping */
    PUBLISH 'registerObject':U FROM TARGET-PROCEDURE.

    {get ObjectInitialized lInit}.
    IF lInit THEN RETURN "ADM-ERROR":U.
  END.
 
  RUN SUPER.
  
  {get ContainerHandle hFrame}.
  
  ASSIGN
    hFrame:SCROLLABLE = FALSE
    hFrame:HIDDEN     = TRUE.
  
  IF cUIBMode BEGINS "DESIGN":U THEN
  DO:
    {get Window hWindow}.
    RUN adeuib/_uibinfo.p
         (?,"PROCEDURE ?","CONTEXT",OUTPUT cInfo). 
    
    RUN adeuib/_uibinfo.p
         (INT(cInfo),?,"TYPE",OUTPUT cInfo). 
    
    IF cinfo = "DIALOG-BOX":U AND lMenu THEN 
    DO:
      MESSAGE 
         "A dialog-box cannot have a menu interface."
         "The menu option will be turned off."
        VIEW-AS ALERT-BOX.
      {set Menu FALSE}.
    END. /* cInfo = dialog */
    
    {fn deleteMenu}.  
    {fn deleteToolbar}.
    {get Toolbar lToolbar}.
    IF NOT lToolbar THEN
      {set ToolbarAutoSize FALSE}.

    /* Find the ventilator frame */
    hPopupFrame = hFrame:FIRST-CHILD.
    hPopupFrame = hPopupframe:FIRST-CHILD.    
    {set AvailMenuActions cBlank}.
    {set AvailToolbarActions cBlank}.
  END.  
  
  IF lUseRepository THEN
  DO:
    RUN loadToolbar IN TARGET-PROCEDURE. 
    {fn constructToolbar}.
    {fn constructMenu}.
  END.
  ELSE DO:
    {fn initializeMenu}.
    {fn initializeToolBar}.
    {fnarg enableActions 'Exit':U}.
  END.

  {get HideOnInit lHideOnInit}.
  
  IF NOT lHideOnInit THEN 
  DO:
    RUN viewObject IN TARGET-PROCEDURE.
    IF cUIBmode = "DESIGN":U AND ERROR-STATUS:GET-NUMBER(1) = 6491 THEN
    DO:      
      MESSAGE 
     "The toolbar is to small to show all buttons. " 
     "This will typically occur when the container is to small. "  SKIP
     "The container must be resized manually before the toolbar can be resized." SKIP
     "The toolbar may be resized manually or by applying the Instance Properties."  SKIP
     VIEW-AS ALERT-BOX INFORMATION.
  
    END. /* if error */

    IF VALID-HANDLE(hPopupFrame) THEN 
      hPopupframe:MOVE-TO-TOP().
  END.
    
  RUN resetTableio    IN TARGET-PROCEDURE.
  RUN resetNavigation IN TARGET-PROCEDURE.
  RUN resetCommit     IN TARGET-PROCEDURE.
  RUN resetToolbar    IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkState Procedure 
PROCEDURE linkState :
/*------------------------------------------------------------------------------
  Purpose:     Receives messages when an object linked to this one becomes
               "active" or "activeTarget" (normally when it's viewed) or 
               "inactive" or "inactiveTarget" (Hidden).
               resets panel buttons accordingly.
  Parameters:  pcState AS CHARACTER -- 'active*'/'inactive*'
               The activeTarget function is very important in the event 
               procedures called by this to identify which object to reset. 
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState  AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE iLink                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLink                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkType               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargets                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hActiveTarget           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lDeactivateTargetOnHide AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iTarget                 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTarget                 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLinkTargetNames        AS CHARACTER  NO-UNDO.
  
  {get LinkTargetNames cLinkTargetNames}. 
  {get DeactivateTargetOnHide lDeactivateTargetOnHide}.
  
  DO iLink = 1 TO NUM-ENTRIES(cLinkTargetNames):
    ASSIGN 
      cLink         = ENTRY(iLink,cLinkTargetNames)
      cLinkType     = ENTRY(1,cLink,'-':U)
      cLink         = REPLACE(cLink,'-':U,'':U)
      cTargets      = DYNAMIC-FUNCTION('get':U + cLink IN TARGET-PROCEDURE) 
      cLink         = REPLACE(cLink,"Target":U,"Source":U)
      NO-ERROR.
    
    IF CAN-DO(cTargets,STRING(SOURCE-PROCEDURE)) THEN
    DO:
      IF pcState BEGINS 'active':U 
      AND NOT lDeactivateTargetOnHide
      AND NUM-ENTRIES(cTargets) > 1  THEN
      DO:
        DO iTarget = 1 TO NUM-ENTRIES(cTargets):
          hTarget = WIDGET-HANDLE(ENTRY(iTarget,cTargets)). 
          IF hTarget <> SOURCE-PROCEDURE THEN
          DO:
            RUN linkStateHandler IN hTarget ('inactive':U,
                                              TARGET-PROCEDURE,
                                              cLink) NO-ERROR. 
          END.
        END.
      END.

      IF (pcState BEGINS 'active':U OR lDeactivateTargetOnHide) THEN
      DO:  
        RUN linkStateHandler IN SOURCE-PROCEDURE (REPLACE(pcState,'Target':U,'':U),
                                                  TARGET-PROCEDURE,
                                                  cLink) NO-ERROR. 

        RUN VALUE('reset':U + cLinkType) IN TARGET-PROCEDURE. 
      END.
    END.
  END.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadToolbar Procedure 
PROCEDURE loadToolbar :
/*------------------------------------------------------------------------------
  Purpose:     Load toolbar, bands and actions for the toolbar object
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLogicalObject AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bttBand       FOR ttBand.
  DEFINE BUFFER bttBandAction FOR ttBandAction.
  
  DEFINE VARIABLE cAvailableMenuActions    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAvailableToolbarActions AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectList              AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cUIBmode                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDelete                  AS LOGICAL    NO-UNDO.

  {get LogicalObjectName cLogicalObject}.
  
  IF cLogicalObject = '':U THEN 
  DO:    
    cLogicalObject = {fn getObjectName}.
    {set LogicalObjectName cLogicalObject}.
  END.
  
  cObjectList = {fnarg supportedObjects NO}. /* no=Only return unloaded bands */
  
  IF NOT CAN-FIND(FIRST ttToolbarBand 
                        WHERE ttToolbarBand.Toolbar = cLogicalObject) THEN
  DO:   
    RUN loadToolbarBands IN TARGET-PROCEDURE (cLogicalObject,
                                              cObjectList,
                                              OUTPUT TABLE ttToolbarBand APPEND,
                                              OUTPUT TABLE ttObjectBand APPEND, 
                                              OUTPUT TABLE ttBand APPEND,
                                              OUTPUT TABLE ttBandAction APPEND).

  END.
  ELSE IF cObjectList <> '':U THEN
  DO:
    RUN loadObjectBands IN TARGET-PROCEDURE (cObjectList,
                                             OUTPUT TABLE ttObjectBand APPEND, 
                                             OUTPUT TABLE ttBand APPEND,
                                             OUTPUT TABLE ttBandAction APPEND).
  END.

  /* Remove duplicates */
  FOR EACH ttBand WHERE ttBand.ProcedureHandle = ?:
    lDelete =  CAN-FIND(FIRST bttBand 
                        WHERE bttBand.Band            = ttBand.Band
                        AND   bttBand.ProcedureHandle <> ?).
    FOR EACH ttBandAction WHERE ttBandAction.ProcedureHandle = ? 
                          AND  ttBandAction.Band            = ttBand.Band:
      IF lDelete THEN
        DELETE ttBandAction.
      ELSE
        ASSIGN ttBandAction.ProcedureHandle = THIS-PROCEDURE.
    END.
    IF lDelete THEN 
      DELETE ttBand.
    ELSE 
      ASSIGN ttBand.ProcedureHandle = THIS-PROCEDURE.
  END.
 
  {get UIBmode cUIBmode}.
  IF cUIBmode = 'Design':U THEN
  DO:
    FOR EACH ttToolbarBand 
             WHERE ttToolbarBand.Toolbar = cLogicalObject,
        EACH ttBand
             WHERE ttBand.Band = ttToolbarBand.Band:
      RUN updateCategoryLists IN TARGET-PROCEDURE 
                             (ttBand.Band,
                              ttBand.BandType,
                              INPUT-OUTPUT cAvailableMenuActions,
                              INPUT-OUTPUT cAvailableToolbarActions).
    END.
    {set AvailMenuActions cAvailableMenuActions}.
    {set AvailToolbarActions cAvailableToolbarActions}.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-movebuttons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE movebuttons Procedure 
PROCEDURE movebuttons :
/*------------------------------------------------------------------------------
  Purpose:     Calculate start positions for left, right, and centre aligned
               bands in the toolbar according to the current width of the toolbar
               frame, then move the existing buttons into their new positions.
               This is called from resizeObject so it is always current for the
               actual size of the toolbar frame.
  Parameters:  input plForceMove to force buttons to be moved if set to YES.
  Notes:       We only work on already built buttons.
               The first thing we must do is see if there are any right and centre
               aligned bands and if not, we can just exist as there is nothing to do.
               Also if all buttons are left aligned there is nothing to do.
               We must ignore hidden buttons.
               When called from viewHideActions procedure after buttons have been
               viewed/hidden, then we must force this procedure to run in order to
               correctly position buttons and not leave any gaps.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcForceMove    AS LOGICAL NO-UNDO.

  DEFINE VARIABLE hFrame                AS HANDLE NO-UNDO.
  DEFINE VARIABLE hWindow               AS HANDLE NO-UNDO.
  DEFINE VARIABLE cLogicalObjectName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iBeginXpxl            AS INT    NO-UNDO. 
  DEFINE VARIABLE iBeginYpxl            AS INT    NO-UNDO. 
  DEFINE VARIABLE iToolSeparatorPxl     AS INTEGER NO-UNDO.
  DEFINE VARIABLE iToolSpacingPxl       AS INTEGER NO-UNDO.
  DEFINE VARIABLE lShowBorder           AS LOG    NO-UNDO. 
  DEFINE VARIABLE dMinWidth      AS DEC    NO-UNDO. 
  DEFINE VARIABLE dMinHeight     AS DEC    NO-UNDO. 
  DEFINE VARIABLE lToolbarAutoSize      AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cToolbarDrawDirection AS CHAR    NO-UNDO.
  DEFINE VARIABLE iLeftBeginXpxl        AS INT    NO-UNDO. 
  DEFINE VARIABLE iLeftBeginYpxl        AS INT    NO-UNDO. 
  DEFINE VARIABLE iRightBeginXpxl       AS INT    NO-UNDO. 
  DEFINE VARIABLE iRightBeginYpxl       AS INT    NO-UNDO. 
  DEFINE VARIABLE iCentreBeginXpxl      AS INT    NO-UNDO. 
  DEFINE VARIABLE iCentreBeginYpxl      AS INT    NO-UNDO. 

  DEFINE VARIABLE iLeftHeightPxl        AS DEC    NO-UNDO.
  DEFINE VARIABLE iLeftWidthPxl         AS DEC    NO-UNDO.
  DEFINE VARIABLE iRightHeightPxl       AS DEC    NO-UNDO.
  DEFINE VARIABLE iRightWidthPxl        AS DEC    NO-UNDO.
  DEFINE VARIABLE iCentreHeightPxl      AS DEC    NO-UNDO.
  DEFINE VARIABLE iCentreWidthPxl       AS DEC    NO-UNDO.


  DEFINE BUFFER btButton FOR tButton.
  {get LogicalObjectName cLogicalObjectName}.
   /* 1st see if any right or centre alignment options selected and if not, exit */
  IF NOT pcForceMove AND 
     NOT CAN-FIND(FIRST ttToolbarBand
                  WHERE ttToolbarBand.ToolbarName = cLogicalObjectName
                  AND   ttToolbarBand.Alignment   <> "left":U) THEN RETURN. 

  {get ContainerHandle hFrame}.
  {get Window hWindow}.
  {get ShowBorder lShowBorder}.
  {get ToolSpacingPxl iToolSpacingPxl}.   
  {get ToolSeparatorPxl iToolSeparatorPxl}.   
  {get MinWidth dMinWidth}.   
  {get MinHeight dMinHeight}.   
  {get ToolbarAutoSize lToolbarAutoSize}.
  {get ToolbarDrawDirection cToolbarDrawDirection}.

  /* 1st check if any room to move */
  IF NOT pcForceMove AND cToolbarDrawDirection BEGINS "v":U 
  AND hFrame:HEIGHT < dMinHeight THEN 
    RETURN.
  
  IF NOT pcForceMove AND cToolbarDrawDirection BEGINS "h":U 
  AND hFrame:WIDTH < dMinWidth THEN 
    RETURN.

  /* Work out where to start putting buttons */
  ASSIGN
    iBeginXpxl =  iToolSeparatorPxl + (If lShowBorder THEN 2 ELSE 0)
    iBeginYpxl =  iToolSeparatorPxl + (If lShowBorder THEN 2 ELSE 0)
    .

  /* room to move or being forced to, so work out width/height of each alignment option */
  ASSIGN
    iLeftHeightPxl = 0
    iLeftWidthPxl = 0
    iCentreHeightPxl = 0
    iCentreWidthPxl = 0
    iRightHeightPxl = 0
    iRightWidthPxl = 0
    .
  
  FOR EACH ttToolbarBand 
       WHERE ttToolbarBand.ToolbarName = cLogicalObjectName
       AND   ttToolbarBand.Alignment   = "Left":U, 
      EACH btButton
        WHERE btButton.Band       = ttToolbarBand.Band
        AND   btButton.hTarget    = TARGET-PROCEDURE
      BY btButton.Position:
    /* hidden in where clause does not return any records...  */   
    IF btButton.hdl:HIDDEN = FALSE THEN 
     ASSIGN
      iLeftHeightPxl = iLeftHeightPxl + (iToolSpacingPxl + btButton.Hdl:HEIGHT-PIXELS)   
      iLeftWidthPxl  = iLeftWidthPxl + (iToolSpacingPxl + btButton.Hdl:WIDTH-PIXELS)  
      .
    
  END.
  
  FOR EACH ttToolbarBand 
       WHERE ttToolbarBand.ToolbarName = cLogicalObjectName
       AND   ttToolbarBand.Alignment = "Center":U,
      EACH btButton 
       WHERE btButton.Band       = ttToolbarBand.Band
       AND   btButton.hTarget    = TARGET-PROCEDURE
      BY btButton.Position:
        /* hidden in where clause does not return any records...  */   
    IF btButton.hdl:HIDDEN = FALSE THEN 

     ASSIGN
      iCentreHeightPxl = iCentreHeightPxl + (iToolSpacingPxl + btButton.Hdl:HEIGHT-PIXELS)   
      iCentreWidthPxl  = iCentreWidthPxl  + (iToolSpacingPxl + btButton.Hdl:WIDTH-PIXELS)  
      .
  END.

  FOR EACH ttToolbarBand 
       WHERE ttToolbarBand.ToolbarName = cLogicalObjectName
       AND   ttToolbarBand.Alignment = "Right":U,
      EACH btButton 
       WHERE btButton.Band       = ttToolbarBand.Band
       AND   btButton.hTarget    = TARGET-PROCEDURE
      BY btButton.Position:
    /* hidden in where clause does not return any records...  */   
    IF btButton.hdl:HIDDEN = FALSE THEN     
     ASSIGN
      iRightHeightPxl = iRightHeightPxl + (iToolSpacingPxl + btButton.Hdl:HEIGHT-PIXELS)   
      iRightWidthPxl  = iRightWidthPxl  + (iToolSpacingPxl + btButton.Hdl:WIDTH-PIXELS)  
      .
  END.

  /* Now work out the start column position in pixels for each section */
  ASSIGN
    iLeftBeginXpxl = iBeginXpxl
    iLeftBeginYpxl = iBeginYpxl
    .    
  ASSIGN
    iCentreBeginXpxl = ((hFrame:WIDTH-PIXELS - (iLeftWidthPxl + iCentreWidthPxl + iRightWidthPxl)) / 2) + iLeftWidthpxl - (iToolSpacingPxl + (If lShowBorder THEN 2 ELSE 0))
    iCentreBeginYpxl = ((hFrame:HEIGHT-PIXELS - (iLeftHeightPxl + iCentreHeightPxl + iRightHeightPxl)) / 2) + iLeftHeightpxl - (iToolSpacingPxl + (If lShowBorder THEN 2 ELSE 0))
    .
  ASSIGN
    iRightBeginXpxl = (hFrame:WIDTH-PIXELS - iRightWidthPxl) - (iToolSpacingPxl + (If lShowBorder THEN 2 ELSE 0))
    iRightBeginYpxl = (hFrame:HEIGHT-PIXELS - iRightHeightPxl) - (iToolSpacingPxl  + (If lShowBorder THEN 2 ELSE 0))
    .

  /* Now read each section of buttons and put in new positions, starting with new start position in each case */  
  /* left alignment */
  ASSIGN
    iBeginXpxl = iLeftBeginXpxl
    iBeginYpxl = iLeftBeginYpxl
    .
  FOR EACH ttToolbarBand 
       WHERE ttToolbarBand.ToolbarName = cLogicalObjectName
       AND   ttToolbarBand.Alignment = "Left":U,
      EACH btButton 
       WHERE btButton.Band       = ttToolbarBand.Band
       AND   btButton.hTarget    = TARGET-PROCEDURE
      BY btButton.Position:
    /* hidden in where clause does not return any records...  */   
    IF btButton.hdl:HIDDEN = FALSE THEN
    DO:
      IF cToolbarDrawDirection BEGINS "v":U THEN
        /* vertical reposition */
        ASSIGN
          btButton.hdl:Y = iBeginYpxl
          iBeginYpxl = iBeginYpxl + iToolSpacingPxl + btButton.hdl:HEIGHT-PIXELS
        NO-ERROR.           
      ELSE
        /* horizontal reposition */
        ASSIGN
          btButton.hdl:X = iBeginXpxl
          iBeginXpxl = iBeginXpxl + iToolSpacingPxl + btButton.hdl:WIDTH-PIXELS
        NO-ERROR.
    END.
  END.
  
  /* centre alignment */
  ASSIGN
    iBeginXpxl = iCentreBeginXpxl
    iBeginYpxl = iCentreBeginYpxl
    .
  FOR EACH ttToolbarBand 
       WHERE ttToolbarBand.ToolbarName = cLogicalObjectName
       AND   ttToolbarBand.Alignment = "Center":U,
      EACH btButton 
       WHERE btButton.Band       = ttToolbarBand.Band
       AND   btButton.hTarget    = TARGET-PROCEDURE
      BY btButton.Position:
   
    /* hidden in where clause does not return any records...  */   
    IF btButton.hdl:HIDDEN = FALSE THEN
    DO:
      IF cToolbarDrawDirection BEGINS "v":U THEN
        /* vertical reposition */
        ASSIGN
          btButton.hdl:Y = iBeginYpxl
          iBeginYpxl = iBeginYpxl + iToolSpacingPxl + btButton.hdl:HEIGHT-PIXELS
        NO-ERROR.     
      ELSE
       /* horizontal reposition */
        ASSIGN
          btButton.hdl:X = iBeginXpxl
          iBeginXpxl = iBeginXpxl + iToolSpacingPxl + btButton.hdl:WIDTH-PIXELS
        NO-ERROR.
      
    END.
  END.

  /* right alignment */
  ASSIGN
    iBeginXpxl = iRightBeginXpxl
    iBeginYpxl = iRightBeginYpxl
    .
  FOR EACH ttToolbarBand 
       WHERE ttToolbarBand.ToolbarName = cLogicalObjectName
       AND   ttToolbarBand.Alignment = "Right":U,
      EACH btButton 
       WHERE btButton.Band       = ttToolbarBand.Band
       AND   btButton.hTarget    = TARGET-PROCEDURE
      BY btButton.Position:
      
    /* hidden in where clause does not return any records...  */   
    IF btButton.hdl:HIDDEN = FALSE THEN
    DO:
      IF cToolbarDrawDirection BEGINS "v":U THEN
       /* vertical reposition */
        ASSIGN
          btButton.hdl:Y = iBeginYpxl
          iBeginYpxl = iBeginYpxl + iToolSpacingPxl + btButton.hdl:HEIGHT-PIXELS
        NO-ERROR.     
      
      ELSE
        /* horizontal reposition */
        ASSIGN
          btButton.hdl:X = iBeginXpxl
          iBeginXpxl = iBeginXpxl + iToolSpacingPxl + btButton.hdl:WIDTH-PIXELS
        NO-ERROR.
    END.
  END.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-onChoose) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE onChoose Procedure 
PROCEDURE onChoose :
/*------------------------------------------------------------------------------
  Purpose: Persistent trigger code for dynamic menu and toolbar objects.     
  Parameters: INPUT pcName - The Action identifier 
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcAction AS CHAR NO-UNDO.
  DEFINE VARIABLE itime AS INTEGER    NO-UNDO.
  
  DEFINE VARIABLE cType                   AS CHAR       NO-UNDO.
  DEFINE VARIABLE cOnChoose               AS CHAR       NO-UNDO.
  DEFINE VARIABLE cCall                   AS CHAR       NO-UNDO.
  DEFINE VARIABLE cObject                 AS CHAR       NO-UNDO.
  DEFINE VARIABLE hObject                 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cParam                  AS CHAR       NO-UNDO.
  DEFINE VARIABLE cParent                 AS CHAR       NO-UNDO.
  DEFINE VARIABLE cSignature              AS CHAR       NO-UNDO.
  DEFINE VARIABLE cDataType               AS CHAR       NO-UNDO.
  DEFINE VARIABLE hContainerSource        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainerWindow        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lMultiInstanceActivated AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cChildDataKey           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRunContainer           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRunContainerType       AS CHARACTER  NO-UNDO.

  IF {fnarg canFindAction pcAction} THEN
  DO:
    RUN runInfo IN TARGET-PROCEDURE
       (INPUT  pcAction,
        OUTPUT cOnChoose,
        OUTPUT cParam).
    cType     = {fnarg actionType pcAction}.
    
    IF CAN-DO("RUN,LAUNCH":U,cType) THEN
      hObject   = {fnarg actionTarget pcAction}.

  END. /* if findAction */

  ELSE /* added by initCode so there's no defined action only two 
          key and text in the menu. The key is : separated and stores
          the parent <action id>:<parameter> */  
    ASSIGN
      cParent   = ENTRY(1,pcAction,":")
      cParam    = (IF NUM-ENTRIES(pcAction,":":U) > 1 
                   THEN ENTRY(2,pcAction,":")
                   ELSE "":U)
      cOnChoose = {fnarg actionOnChoose cParent}  
      hObject   = {fnarg actionTarget cParent}
      cType     = "RUN":U.  
 
  cCall = ENTRY(1,cOnChoose).

  CASE cType:
      WHEN "LAUNCH":U THEN
      DO:
        {get ContainerSource hContainerSource}.
        IF VALID-HANDLE(hContainerSource) 
        AND LOOKUP ("getMultiInstanceActivated", hContainerSource:INTERNAL-ENTRIES) <> 0 THEN
          lMultiInstanceActivated = DYNAMIC-FUNCTION("getMultiInstanceActivated" IN hContainerSource).
        ELSE
          lMultiInstanceActivated = NO.
      
        {get Window hContainerWindow}.
      
        IF VALID-HANDLE(hObject) 
        AND LOOKUP ("getChildDataKey", hObject:INTERNAL-ENTRIES) <> 0 THEN
          cChildDataKey = DYNAMIC-FUNCTION('getChildDataKey' IN hObject).
        ELSE
          cChildDataKey = "":U.

        IF VALID-HANDLE(gshSessionManager) THEN
          RUN launchContainer IN gshSessionManager 
                   ("":U,
                    {fnarg actionPhysicalObjectName pcAction},
                    {fnarg actionLogicalObjectName pcAction},
                    NOT lMultiInstanceActivated,
                    INPUT "":U,
                    INPUT cChildDataKey,
                    {fnarg actionRunAttribute pcAction},
                    INPUT "":U, /* container mode */
                    INPUT hContainerWindow,
                    INPUT hContainerSource,
                    INPUT hObject,
                    OUTPUT hRunContainer,
                    OUTPUT cRunContainerType).
        
      END.

      WHEN "PUBLISH":U THEN
      DO:
        IF cParam = "":U THEN
          PUBLISH cCall FROM TARGET-PROCEDURE.  
        ELSE
          PUBLISH cCall FROM TARGET-PROCEDURE (cParam).  
      END.
      WHEN "RUN":U THEN
      DO:    
        /* Currently we just give default errors for invalid handles  */
        IF cParam = "":U THEN
          RUN VALUE(cCall) IN hObject.   
        
        ELSE DO:
          cSignature = {fnarg Signature cCall hObject}.
          
          IF cSignature <> "":U THEN
          DO:
            ASSIGN
              cDataType = ENTRY(3,cSignature)
              cDataType = ENTRY(NUM-ENTRIES(cDataType," ":U),cDataType," ":U).      
            CASE cDataType:
              WHEN "CHARACTER":U THEN
                RUN VALUE(cCall) IN hObject (cParam).   
              WHEN "INTEGER":U THEN
                RUN VALUE(cCall) IN hObject (INT(cParam)).   
              WHEN "DECIMAL":U THEN
                RUN VALUE(cCall) IN hObject (DEC(cParam)).   
              WHEN "LOGICAL":U THEN
                RUN VALUE(cCall) IN hObject(CAN-DO("YES,TRUE":U,cParam)).   
              WHEN "HANDLE":U THEN
                RUN VALUE(cCall) IN hObject(WIDGET-HANDLE(cParam)).
            END CASE. /* datatype */
          END. /* signature  <> '' */
        END. /* else (param) */
      END. /* when RUN */
  END CASE.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-onMenuDrop) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE onMenuDrop Procedure 
PROCEDURE onMenuDrop :
/*------------------------------------------------------------------------------
  Purpose:  Logic to execute when a sub-menu is "dropped"    
  Parameters: INPUT pcAction  - The action's unique identifier.  
  Notes:    added as a persistent trigger when the sub-menu is created     
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcAction AS CHAR NO-UNDO.
  DEFINE BUFFER btBandInstance FOR tBandInstance. 

  DEFINE VARIABLE lUseRepository  AS LOGICAL    NO-UNDO.
  
  {get UseRepository lUseRepository}.

  IF lUseRepository THEN
  DO:
    
    IF pcAction = xcWindowBand THEN
       {fnarg windowDropdownList pcAction}.
    /*
    FOR EACH tBandinstance WHERE tBandInstance.Band  = pcAction:          
      {fnarg constructMenuBand pcAction tBandInstance.hTarget}.
    END.
    */
  END.
  ELSE
    {fnarg buildMenu pcAction}.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-onValueChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE onValueChanged Procedure 
PROCEDURE onValueChanged :
/*------------------------------------------------------------------------------
  Purpose :   Persistent trigger for toggle menu-items     
  Parameters: PcAction - Name of action  
  Notes       Added as a persistent trigger when the sub-menu is created.
              Currently we support only logical properties.  
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcAction AS CHAR NO-UNDO.
  
  DEFINE VARIABLE cOnChoose  AS CHAR   NO-UNDO.
  DEFINE VARIABLE hObject    AS HANDLE NO-UNDO.
  
  ASSIGN
    cOnChoose = "set":U + {fnarg actionOnChoose pcAction}.
    hObject = {fnarg actionTarget pcAction}. 
  
  IF VALID-HANDLE(hObject) THEN
     DYNAMIC-FUNCTION(cOnChoose IN hObject, SELF:CHECKED).         

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-queryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE queryPosition Procedure 
PROCEDURE queryPosition :
/*------------------------------------------------------------------------------
  Purpose:     Captures "state" events for the associated Query in the Panel's
               NavigationTarget. Invokes the setPanelState function which stores
               the new state in the object's PanelState property and then 
               invokes the setButtons procedure to change the Panel.
  Parameters:  pcState AS CHARACTER -- Panel State
  Notes:       Because some states may be published from different links
               the source-procedure is always checked.
               This means that this only will work when run/published from 
               the appropriate target !!!
         NB!   We do check the special getTargetProcedure in order to identify 
               the real NavigationTarget since SBO's uses a RUN. 
               This MUST NOT be used to identify TableioTargets. 
               As a TableioSource may set this before a call that may end up 
               here. So a parent may do addRow and set this global property, 
               which then will point to that parent also when children calls 
               this as part of that add.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cPanelState    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hNavTarget     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hIOTarget      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lModified      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cNewRecord     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSource        AS HANDLE    NO-UNDO.

  /* Is this an active Tableio state? */
  hIOTarget = {fnarg activeTarget 'TableIO':U}.    
  IF hIOTarget = SOURCE-PROCEDURE THEN
    RUN resetTableio IN TARGET-PROCEDURE.
  
  ELSE DO:
    hSource = SOURCE-PROCEDURE.
    /* Is this a NavigationTarget state? */
    hNavTarget = {fnarg activeTarget 'Navigation':U}.
    /* Check if this is a RUN from an SBO where the super is source, so we 
       need to get the target from a special function. */  
    IF hNavTarget <> hSource THEN
      {get TargetProcedure hSource SOURCE-PROCEDURE} NO-ERROR.
    
    IF hNavTarget = hSource THEN
      RUN resetNavigation IN TARGET-PROCEDURE.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionObject Procedure 
PROCEDURE repositionObject :
/*------------------------------------------------------------------------------
  Purpose: Override default reposition.
           Because the coordinates is NOT assigned in DESIGN.
           The position only changes through direct manipulation and not 
           when dropped in the contaner. 
  Parameters:  pdRow 
               pdCol 
  Notes:    toolbar.i defines EXCLUDE-repositionObject (for smart.i)     
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER pdRow AS DECIMAL NO-UNDO.
 DEFINE INPUT PARAMETER pdCol AS DECIMAL NO-UNDO.

 DEFINE VARIABLE cUIBMode              AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cToolbarDrawDirection AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lToolbarAutosize      AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hFrame                AS HANDLE     NO-UNDO.

 {get UIBMode cUIBMode}.
 /* Keep the default 1 1  position when dropped from Appbuilder's Palette */
 IF cUIBMode <> "DESIGN":U OR LAST-EVENT:FUNCTION <> "MOUSE-SELECT-CLICK":U THEN
 DO:
   {get ContainerHandle hFrame}.
   {get ToolbarAutoSize      lToolbarAutoSize}.
   {get ToolbarDrawDirection cToolbarDrawDirection}. 

   /* ignore col if autosize horizontal and row id autosize vertical 
      repositionObject handles this */
   ASSIGN 
     hFrame:ROW = pdRow WHEN NOT lToolbarAutoSize 
                          OR NOT cToolbarDrawDirection BEGINS 'v':U  
     hFrame:COL = pdCol WHEN NOT lToolbarAutoSize 
                          OR cToolbarDrawDirection BEGINS 'v':U NO-ERROR. 
 END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetTargetActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetTargetActions Procedure 
PROCEDURE resetTargetActions :
/*------------------------------------------------------------------------------
  Purpose:  reset the actions of a specific link (disable, hide, image, checked)      
  Parameters: pcLink - Link type 
  Notes:    Called from all reset<Link> methods.   
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER pcLink  AS CHARACTER  NO-UNDO.
 
 DEFINE VARIABLE cEnableActions    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDisableActions   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cHideActions      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cViewActions      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cImage1Actions    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cImage2Actions    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCheckedActions   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cUncheckedActions AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lInitialized      AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cLinkActions      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hTarget           AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cLinkName         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cAction           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iAction           AS INTEGER    NO-UNDO.

 DEFINE BUFFER btButton FOR tButton.
 DEFINE BUFFER btMenu FOR tMenu.
     
 {get ObjectInitialized lInitialized}.
 IF NOT lInitialized THEN 
   RETURN.
 
 IF pcLink <> '':U THEN
   hTarget = {fnarg activeTarget pcLink}.
 ELSE 
   {get ContainerSource hTarget}.

 IF NOT VALID-HANDLE(hTarget) THEN
 DO:
   cLinkActions =  {fnarg targetActions pcLink}.
   {fnarg disableActions cLinkActions}.  
   RETURN.
 END.
 
 cLinkName = pcLink + '-target':U. 
  
 FOR EACH btButton WHERE btButton.hTarget = TARGET-PROCEDURE
                    AND   btButton.Link    = cLinkName:
   IF VALID-HANDLE(btButton.hdl) THEN
   DO:
     ASSIGN
       cEnableActions = cEnableActions 
                        + (IF btButton.hdl:SENSITIVE 
                           THEN ',':U + btButton.Name
                           ELSE '':U)
       cDisableActions = cDisableActions 
                        + (IF NOT btButton.hdl:SENSITIVE 
                           THEN ',':U + btButton.Name
                           ELSE '':U)
       cViewActions = cViewActions 
                         + (IF NOT btButton.hdl:HIDDEN 
                            THEN ',':U + btButton.Name
                            ELSE '':U)
       cHideActions = cHideActions 
                         + (IF btButton.hdl:HIDDEN 
                            THEN ',':U + btButton.Name
                            ELSE '':U)
       cImage1Actions = cImage1Actions 
                         + (IF btButton.imageAlt = FALSE
                            THEN ',':U + btButton.Name
                            ELSE '':U)
       cImage2Actions = cImage2Actions 
                           + (IF btButton.imageAlt = TRUE
                              THEN ',':U + btButton.Name
                              ELSE '':U).
   END.
 END.
 FOR EACH btMenu WHERE btMenu.hTarget = TARGET-PROCEDURE
                 AND   btMenu.Link     = cLinkName:
   IF VALID-HANDLE(btMenu.hdl) THEN
   DO:
     IF NOT CAN-DO(cEnableActions + cDisableActions,btMenu.Name) THEN
       ASSIGN
         cEnableActions = cEnableActions 
                        + (IF btMenu.hdl:SENSITIVE 
                           THEN ',':U + btMenu.Name
                           ELSE '':U)
         cDisableActions = cDisableActions 
                         + (IF NOT btMenu.hdl:SENSITIVE 
                            THEN ',':U + btMenu.Name
                            ELSE '':U).
     IF CAN-QUERY(btMenu.Hdl,'TOGGLE-BOX':U) AND btMenu.hdl:TOGGLE-BOX THEN
       ASSIGN
         cCheckedActions = cCheckedActions 
                           + (IF btMenu.hdl:CHECKED 
                              THEN ',':U + btMenu.Name
                              ELSE '':U)
         cUncheckedActions = cUnCheckedActions 
                           + (IF NOT btMenu.hdl:CHECKED 
                              THEN ',':U + btMenu.Name
                              ELSE '':U).
   END.
   IF NOT CAN-DO(cViewActions + cHideActions,btMenu.Name) THEN
     ASSIGN
       cViewActions = cViewActions 
                         + (IF VALID-HANDLE(btMenu.hdl) 
                            THEN ',':U + btMenu.Name
                            ELSE '':U)
       cHideActions = cHideActions 
                         + (IF NOT VALID-HANDLE(btMenu.hdl) 
                            THEN ',':U + btMenu.Name
                            ELSE '':U).

 END.
 
 ASSIGN 
   cEnableActions    = TRIM(cEnableActions,',':U)
   cDisableActions   = TRIM(cDisableActions,',':U)
   cViewActions      = TRIM(cViewActions,',':U)
   cHideActions      = TRIM(cHideActions,',':U)
   cImage1Actions    = TRIM(cImage1Actions,',':U)
   cImage2Actions    = TRIM(cImage2Actions,',':U)
   cUncheckedActions = TRIM(cUncheckedActions,',':U)
   cCheckedActions   = TRIM(cCheckedActions,',':U).
 
 RUN ruleStatechanges IN TARGET-PROCEDURE
       (cLinkName,
        hTarget,
        INPUT-OUTPUT cEnableActions,
        INPUT-OUTPUT cDisableActions,
        INPUT-OUTPUT cViewActions,
        INPUT-OUTPUT cHideActions,
        INPUT-OUTPUT cImage1Actions,
        INPUT-OUTPUT cImage2Actions,
        INPUT-OUTPUT cUncheckedActions,
        INPUT-OUTPUT cCheckedActions).
 
 DO iAction = 1 TO NUM-ENTRIES(cUncheckedactions):
   cAction = ENTRY(iAction,cUncheckedactions).
   FIND btMenu WHERE btMenu.Name    = cAction
                AND  btMenu.hTarget = TARGET-PROCEDURE NO-ERROR.
   IF AVAIL btMenu THEN
      btMenu.hdl:CHECKED = FALSE.

 END.
 DO iAction = 1 TO NUM-ENTRIES(cCheckedactions):
   cAction = ENTRY(iAction,cCheckedactions).
   FIND btMenu WHERE btMenu.Name    = cAction
                AND  btMenu.hTarget = TARGET-PROCEDURE NO-ERROR.
   IF AVAIL btMenu THEN
      btMenu.hdl:CHECKED = TRUE.

 END.
 
 DO iAction = 1 TO NUM-ENTRIES(cImage1actions):
   cAction = ENTRY(iAction,cImage1actions).
   FIND btButton WHERE btButton.Name    = cAction
                 AND   btButton.hTarget = TARGET-PROCEDURE NO-ERROR.

   IF AVAIL btButton THEN
   DO:
     btButton.hdl:LOAD-IMAGE(SEARCH(DYNAMIC-FUNCTION('imageName':U IN TARGET-PROCEDURE,
                                     cAction,
                                     1))
                             ).
     btButton.imageALt = FALSE.
   END.
 END.
 DO iAction = 1 TO NUM-ENTRIES(cImage2actions):
   cAction = ENTRY(iAction,cImage2actions).
   
   FIND btButton WHERE btButton.Name    = cAction
                 AND   btButton.hTarget = TARGET-PROCEDURE NO-ERROR.
   
   IF AVAIL btButton THEN
   DO:
     btButton.hdl:LOAD-IMAGE(SEARCH(DYNAMIC-FUNCTION('imageName':U IN TARGET-PROCEDURE,
                                     cAction,
                                     2))
                             ).
     btButton.imageALt = TRUE.
   END.
 END.
 
 IF cEnableActions <> '':U THEN
   {fnarg EnableActions cEnableActions}.
 
 IF cDisableActions <> '':U THEN
    {fnarg disableActions cDisableActions}.

 IF cViewActions <> '':U OR cHideActions <> '':U THEN
   RUN viewHideActions IN TARGET-PROCEDURE (cViewActions,cHideactions).

 RETURN.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetToolbar Procedure 
PROCEDURE resetToolbar :
/*------------------------------------------------------------------------------
  Purpose: reset toolbar actions    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   RUN resetTargetActions IN TARGET-PROCEDURE ('Toolbar':U).
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject Procedure 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose: Overrides the size after a resize to ensure width is big enough to
           fit all buttons on, and that the height is not accidentally changed.
           This is a design time event that sorts out things when the object is
           manually sized in the Appbuilder.
  Parameters: 
           pd_height AS DECIMAL - the desired height (in rows)
           pd_width  AS DECIMAL - the desired width (in columns)
    Notes: Used internally. Calls to resizeObject are generated by the
           AppBuilder in adm-create-objects for objects which implement it.
           Having a resizeObject procedure is also the signal to the AppBuilder
           to allow the object to be resized at design time.
------------------------------------------------------------------------------*/  
  DEFINE INPUT PARAMETER pdHeight       AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth        AS DECIMAL NO-UNDO.
  DEFINE VARIABLE hFrame                AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hWindow               AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hContainerSource      AS HANDLE  NO-UNDO.
  DEFINE VARIABLE dMinWidth      AS DECIMAL NO-UNDO.
  DEFINE VARIABLE dMinHeight     AS DECIMAL NO-UNDO.
  DEFINE VARIABLE hRectangle            AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRectangle2           AS HANDLE  NO-UNDO.  
  DEFINE VARIABLE lShowBorder           AS LOGICAL NO-UNDO.
  DEFINE VARIABLE iDummy                AS INTEGER NO-UNDO.
  DEFINE VARIABLE lToolbarAutoSize      AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cToolbarDrawDirection AS CHAR    NO-UNDO.
  DEFINE VARIABLE hPopupFrame           AS HANDLE  NO-UNDO.
  DEFINE VARIABLE cUIBMode              AS CHAR    NO-UNDO.
  DEFINE VARIABLE iEdgePixels           AS INTEGER NO-UNDO.
  DEFINE VARIABLE lPreviouslyHidden     AS LOGICAL NO-UNDO.
  DEFINE VARIABLE lWindowResize         AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cFrame                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hWindowFrame          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hParent               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFolder               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iPage                 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE dRow                  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dCol                  AS DECIMAL    NO-UNDO.

  {get UIBMode              cUIBmode}.
  {get Window               hWindow}.
  {get ContainerHandle      hFrame}.
  {get ContainerSource      hContainerSource}.
  {get BoxRectangle         hRectangle}.
  {get BoxRectangle2        hRectangle2}.
  {get MinWidth      dMinWidth}.
  {get MinHeight     dMinHeight}.
  {get ShowBorder           lShowBorder}.
  {get ToolbarAutoSize      lToolbarAutoSize}.
  {get ToolbarDrawDirection cToolbarDrawDirection}.

  hFrame:SCROLLABLE = FALSE.                                               
  lPreviouslyHidden = hFrame:HIDDEN.                                                           
  hFrame:HIDDEN = TRUE.
 
  /* If autosize turned on - always resize according to the window or folder size */  
  IF lToolbarAutoSize THEN    
  DO: 
    IF VALID-HANDLE(hContainerSource) THEN
    DO:
      /* Set height or width from container. 
         we check pageSource for inner values later, but the page device 
         may not exist or have these functions so we must always set values
         here first */
      IF cToolbarDrawDirection BEGINS "v":U THEN
      DO:
        dRow  = 1.
        {get Height pdHeight hContainerSource}.
      END.
      ELSE
      DO:
        dCol = 1.
        {get Width pdWidth hContainerSource}.
      END.
      iPage = {fnarg targetPage TARGET-PROCEDURE hContainerSource}.
      IF iPage > 0 THEN 
      DO:
        {get PageSource hFolder hContainerSource}.
        IF VALID-HANDLE(hFolder) THEN
        DO:
          IF cToolbarDrawDirection BEGINS "v":U THEN
            ASSIGN
              dRow      = {fn getInnerRow hFolder} 
              pdHeight  = {fn getInnerHeight hFolder} NO-ERROR.
          ELSE
            ASSIGN
              dCol      = {fn getInnerCol hFolder} 
              pdWidth   = {fn getInnerWidth hFolder} NO-ERROR.
        END.
      END.
    END. 
    ELSE DO:
      IF cToolbarDrawDirection BEGINS "v":U THEN
        ASSIGN
          dRow     = 1
          pdHeight = hWindow:HEIGHT.
      ELSE
        ASSIGN
          dCol    = 1
          pdWidth = hWindow:WIDTH.
    END.

    IF cToolbarDrawDirection BEGINS "v":U THEN
      ASSIGN
          hFrame:ROW         = dRow
          hFrame:HEIGHT      = pdHeight
        NO-ERROR.
    ELSE
      ASSIGN
          hframe:COL        = dCol
          hFrame:WIDTH      = pdWidth 
        NO-ERROR.          
    
  END.
  ELSE /* Ensure that the frame is sized to stored values on open 
          otherwise the max logic further down would use the frame's initial        
          size */          
          
    ASSIGN 
      hFrame:HEIGHT      = pdHeight WHEN dMinHeight < pdHeight
      hFrame:WIDTH       = pdWidth WHEN dMinWidth < pdWidth. 
  
  IF dMinHeight > 0 AND dMinHeight < (SESSION:HEIGHT - 1) AND
     dMinWidth > 0 AND dMinWidth < (SESSION:WIDTH - 1) AND
     (hWindow:WIDTH < dMinWidth OR hWindow:HEIGHT < dMinHeight) THEN
  DO:
    IF hWindow:HEIGHT < dMinHeight THEN
      ASSIGN
        hWindow:HEIGHT     = dMinHeight
        hWindow:MIN-HEIGHT = dMinHeight NO-ERROR.
    
    IF hWindow:WIDTH < dMinWidth THEN
      ASSIGN
        hWindow:WIDTH     = dMinWidth
        hWindow:MIN-WIDTH = dMinWidth NO-ERROR.
    RUN resizeWindow IN hContainerSource NO-ERROR.
    lWindowResize = TRUE. /* flag for design mode further down  */
  END.
    
  /* Ensure frame height / width is not smaller than minimum allowed to fit buttons, plus reset to 1 column/row
     depending on horizontal / vertical alignment
     Also ensure that height/width is not changed on horizontal/vertical */
  IF cToolbarDrawDirection BEGINS "v":U THEN
    ASSIGN
      hFrame:WIDTH       = dMinWidth
      hFrame:HEIGHT      = MAX(hFrame:HEIGHT,dMinHeight) 
      hRectangle:HEIGHT  = hFrame:HEIGHT WHEN VALID-HANDLE(hRectangle)
      hRectangle2:HEIGHT = hFrame:HEIGHT WHEN VALID-HANDLE(hRectangle2)
    NO-ERROR.
  ELSE 
    ASSIGN
      hFrame:HEIGHT      = dMinHeight
      hFrame:WIDTH       = MAX(hFrame:WIDTH,dMinWidth) 
      hRectangle:WIDTH   = hFrame:WIDTH WHEN VALID-HANDLE(hRectangle)
      hRectangle2:WIDTH  = hFrame:WIDTH WHEN VALID-HANDLE(hRectangle2)
    NO-ERROR.
  /* reposition buttons according to new size of frame */
  RUN moveButtons IN TARGET-PROCEDURE (INPUT NO).

  /* bring ventilator back onto top */
  IF cUIBMode BEGINS "DESIGN":U THEN 
  DO:
    /* If the window was resized the frame is not resized accordingly 
       in Design mode as there is no persistent ContainerSource */
    IF lWindowResize THEN
    DO:
      /*
      hWindowframe = hFrame:PARENT.  /* fieldgroup*/
      hWindowframe = hWindowFrame:PARENT.
      
      MESSAGE hWindowFrame:NAME 
              hWindowFrame:type
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      */  
      RUN adeuib/_uibinfo.p (?,'frame ?':U,'handle':U, OUTPUT cFrame).
     
      hWindowFrame = WIDGET-HANDLE(cFrame).  

      hWindowFrame:WIDTH  = MAX(hWindow:WIDTH,hWindowFrame:WIDTH).
      hWindowFrame:HEIGHT = MAX(hWindow:HEIGHT,hWindowFrame:HEIGHT).
    END.

    /* Find the ventilator frame */
    hPopupFrame = hFrame:FIRST-CHILD.
    hPopupFrame = hPopupframe:FIRST-CHILD.
    IF VALID-HANDLE(hPopupFrame) THEN 
      hPopupframe:MOVE-TO-TOP().
    
    IF program-name(2) <> 'adeuib/_setsize.p':u THEN
    DO:
      APPLY "end-resize":U TO hFrame.
      APPLY "end-resize":U TO hWindow. 
    END.
    
  END.

  hFrame:HIDDEN = lPreviouslyHidden NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowObjectState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowObjectState Procedure 
PROCEDURE rowObjectState :
/*------------------------------------------------------------------------------
  Purpose:     published from Commit-Target to tell the panel when to enable
               itself (when there are uncommitted changes) and disable itself
               (when those changes are committed or undone).
  Parameters:  INPUT pcState AS CHARACTER - 'NoUpdates' or 'RowUpdated'
  Notes:       This could be a property, but for now we just check the state
               of the Commit button to see if we're already enabled/disabled. 
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
  
  RUN resetCommit IN TARGET-PROCEDURE.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-runInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runInfo Procedure 
PROCEDURE runInfo :
/*------------------------------------------------------------------------------
  Purpose: Return the necessary information for RUN or PROERTY     
  Parameters: INPUT  pcAction    - Action Id where type = RUN.
              OUTPUT pohTarget    - Target handle
              OUTPUT pocProcedure - Target Procedure
  
  Notes: This encapsulates the logic to look for this info in the parent if 
         it's not defined in the action itself.        
-----------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER  pcAction AS CHAR   NO-UNDO.
   
   DEFINE OUTPUT PARAMETER pocProcedure AS CHAR   NO-UNDO.
   DEFINE OUTPUT PARAMETER pocParam     AS CHAR   NO-UNDO.

   DEFINE VARIABLE cParent        AS CHAR    NO-UNDO.
   DEFINE VARIABLE cOnChoose      AS CHAR    NO-UNDO.
   DEFINE VARIABLE lUseRepository AS LOGICAL NO-UNDO.

   cOnChoose = {fnarg actionOnChoose pcAction}.
   {get UseRepository lUseRepository}.
   
   IF lUseRepository THEN
   DO:
     ASSIGN  
       pocProcedure = cOnChoose
       pocParam = {fnarg actionParameter pcAction}. 
   END.
   ELSE
   DO:
     /* Find the procedure on the parent and use the action as input. */
     IF cOnChoose = "":U THEN
       ASSIGN
         cParent      = {fnarg actionParent pcAction}  
         pocProcedure = {fnarg actionOnChoose cParent}
         pocParam     = pcAction.
     ELSE  /* we allow harcoded parameter on the action  */ 
       ASSIGN
         pocProcedure = TRIM(ENTRY(1,cOnChoose,"(":U))
         pocParam     = IF NUM-ENTRIES(cOnChoose,"(":U) > 1 
                        THEN TRIM(ENTRY(2,cOnChoose,"(":U),"')":U)
                        ELSE "":U.
   END.

   RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setButtons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setButtons Procedure 
PROCEDURE setButtons :
/**
*   @desc  This procedure is called from tableio/nav targets to 
*          set the buttons according to the state
*   @param <code>input picPanelState character</code> current state
*/
/*----------------------------------------------------------------------- 
  Purpose: Called from *state proceudures to enable/disable actions according
           to state.  
Parameters: INPUT pcPanelState - State
            - onlyRecord
            - disable-nav
            - first
            - last 
            - initial-tableio 
            - update
            - add-only
            - disable-commit 
            - enable-commit
            - enable-filter
            
     Notes: Called directly or indirectly from procedures that subscribes to 
            linked objects;
            queryPosition, updateState, rowObjectState or LinkState.
---------------------------------------------------------------------------*/     
 DEFINE INPUT PARAMETER pcPanelState AS CHARACTER NO-UNDO.                     
  
 DEF VAR cParam       AS CHAR NO-UNDO.
 DEF VAR cTableIoType AS CHAR NO-UNDO.
  
 {get TableIoType cTableIoType}.
  DO WITH FRAME Panel-Frame:
    CASE pcPanelState:
      WHEN 'OnlyRecord':U  THEN 
      DO:
        cParam = "Next,Prev,First,Last":U.
        {fnarg disableActions cparam}.
      END.      
      WHEN 'Disable-Nav':U  THEN 
      DO:
        cParam = "Next,Prev,First,Last":U.
        {fnarg disableActions cParam}.
      END.    
      WHEN 'first':U THEN 
      DO:
        cParam = "First,Prev":U.
        {fnarg disableActions cParam}.
        cParam = "Last,Next":U.
        {fnarg enableActions cParam}.
      END. /* first */
      WHEN 'last':U THEN 
      DO:
        cParam = "Last,Next":U.
        {fnarg disableActions cParam}.
        cParam = "First,Prev":U.
        {fnarg enableActions cParam}.
      END.
      WHEN 'NotFirstOrLast':U  THEN 
      DO:
        cParam = "Next,Prev,First,Last":U.
        {fnarg enableActions cparam}.
      END.
      WHEN 'Enable-Nav':U  THEN 
      DO:
        cParam = "Next,Prev,First,Last":U.
        {fnarg enableActions cparam}.
      END.
      WHEN 'Initial-TableIo':U  THEN 
      DO:
        cParam =  "Save,Cancel,Reset":U.
        {fnarg disableActions cParam}.
        cParam = "add,update,delete,copy":U.
        {fnarg enableActions cparam}.
      END.      
      WHEN 'Update':U  THEN 
      DO:
        cParam = "Add,Update,Delete,Copy,Cancel":U.
        {fnarg disableActions cParam}.       
        cParam = "Save,Reset".
        {fnarg enableActions cparam}.
      END.
      WHEN 'Modal-Update':U  THEN 
      DO:
        cParam = "Add,Update,Delete,Copy,Reset":U.
        {fnarg disableActions cParam}.       
        cParam = "Save,Cancel".
        {fnarg enableActions cparam}.
      END.
      WHEN 'Modal-Update-Modified':U  THEN 
      DO:
        cParam = "Add,Update,Delete,Copy":U.
        {fnarg disableActions cParam}.       
        cParam = "Save,Reset,Cancel".
        {fnarg enableActions cparam}.
      END.
      WHEN 'Delete-Only':U  THEN 
      DO:
        cParam = "Add,Copy,Update,Save,Cancel,Reset":U.
        {fnarg disableActions cParam}.
        cParam = "Delete".
        {fnarg enableActions cparam}.     
      END.  
      WHEN 'Add-Only':U  THEN 
      DO:
        cParam = "Copy,Update,Delete,Save,Cancel,Reset":U.
        {fnarg disableActions cParam}.
        cParam = "Add".
        {fnarg enableActions cparam}.     
      END. 
      WHEN 'Update-Only':U  THEN 
      DO:
        cParam = "Add,Copy,Delete,Save,Cancel,Reset":U.
        {fnarg disableActions cParam}.
        cParam = "Update".
        {fnarg enableActions cparam}.     
      END. 
      WHEN 'Disable-tableio':U  THEN 
      DO:
        cParam = "Add,Copy,Edit,Update,Delete,Save,Cancel,Reset".
        {fnarg disableActions cParam}.
      END.      
      WHEN 'Disable-commit':U  THEN 
      DO:
          cParam = "commit,undo".
          {fnarg disableActions cParam}.
      END.
      WHEN 'Enable-commit':U  THEN 
      DO:
          cParam = "commit,undo".
         {fnarg enableActions cParam}.
      END.
      WHEN 'Enable-filter':U  THEN 
      DO:
          cParam = "filter".
         {fnarg enableActions cParam}.
      END.
      OTHERWISE RETURN "ADM-ERROR":U.          

    END.         /* END CASE */

  END.           /* END DO WITH FRAME */  

  RETURN.               

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateActive Procedure 
PROCEDURE updateActive :
/*------------------------------------------------------------------------------
  Purpose:   published from toolbar-target (container) to signal that 
             some of its objects have changed state  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER plActive AS LOGICAL NO-UNDO.

  RUN resetToolbar IN TARGET-PROCEDURE. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateCategoryLists) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateCategoryLists Procedure 
PROCEDURE updateCategoryLists :
/*------------------------------------------------------------------------------
  Purpose:    Update the lists of available categories for the toolbar.                                                          
  Parameters: pcBand         - Band name  
              pcTopLevelBand - The Type of the band that are directly connected 
                               to the toolbar. (Used to figure out which lists 
                               to update)
  Notes:      This is called from loadBands at design time only and the result
              are currently stored in AvailMenuActions and AvailToolbarActions, 
              which has their names from pre-repository when the actions groups
              also were actions.     
------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAMETER pcBand         AS CHARACTER  NO-UNDO.
   DEFINE INPUT  PARAMETER pcTopLevelType AS CHARACTER  NO-UNDO.
   DEFINE INPUT-OUTPUT PARAMETER pcMenuCategories    AS CHARACTER  NO-UNDO.
   DEFINE INPUT-OUTPUT PARAMETER pcToolbarCategories AS CHARACTER  NO-UNDO.
   
   DEFINE BUFFER bttBandAction FOR ttBandAction.

   DEFINE VARIABLE cCategory AS CHARACTER  NO-UNDO.
   
   FOR EACH bttBandAction
        WHERE bttBandAction.Band = pcBand:

     IF bttBandAction.Action <> '':U THEN
     DO:
       cCategory = {fnarg ActionCategory bttBandAction.Action}.
       IF cCategory = '':U THEN 
          cCategory = xcNocategory.

       /* include blank for uncategorized */
       IF cCategory = xcNocategory OR {fnarg CategoryLink cCategory} <> '':U THEN 
       DO:
         IF  pcTopLevelType = 'Menubar':U 
         AND NOT CAN-DO(pcMenuCategories,cCategory) THEN 
           ASSIGN pcMenuCategories = pcMenuCategories 
                                   + (IF pcMenuCategories <> '':U THEN ',':U ELSE '':U)
                                   + cCategory.
         ELSE 
         IF NOT CAN-DO(pcToolbarCategories,cCategory) THEN 
           ASSIGN pcToolbarCategories = pcToolbarCategories 
                                   + (IF pcToolbarCategories <> '':U THEN ',':U ELSE '':U)
                                   + cCategory .
       END.
     END.
     IF bttBandAction.ChildBand <> '':U THEN
        RUN updateCategoryLists IN TARGET-PROCEDURE
                              (bttBandAction.ChildBand,
                               pcTopLevelType,
                               INPUT-OUTPUT pcMenuCategories,
                               INPUT-OUTPUT pcToolbarCategories). 
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateState Procedure 
PROCEDURE updateState :
/*------------------------------------------------------------------------------
  Purpose:     Receives state message events related to record updates.
  Parameters:  pcState AS CHARACTER -- upstate state
   Notes:      Because some states may be published from different links
               the source-procedure is always checked.
               This means that this only will work when run/published from 
               the appropriate target !!!
         NB!   We do check the special getTargetProcedure in order to identify 
               the real NavigationTarget since SBO's uses a RUN. 
               This MUST NOT be used to identify TableioTargets. 
               As a TableioSource may set this before a call that may end up 
               here for a child. (This is not so very likely for updatestate) 
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cTableIOType AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hIOTarget    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hNavTarget   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hSource      AS HANDLE    NO-UNDO.

  hSource = SOURCE-PROCEDURE.

  /* Is this from the tableio-target? */
  hIoTarget  = {fnarg activeTarget 'Tableio':U}. 
  IF hSource = hIOTarget THEN
  DO:
    /* If 'updateComplete' and update 'mode' ensure that fields are disabled */
    IF pcState = 'updateComplete':U THEN
    DO:
      {get TableIOType cTableIOType}.
      /* disable */ 
      IF cTableIOType BEGINS 'Update':U THEN
         PUBLISH 'updateMode':U FROM TARGET-PROCEDURE ('updateEnd':U).
    END.
    /* From 9.1C we don't care what state, but check the linked object's state 
       instead */ 
    RUN resetTableio IN TARGET-PROCEDURE.     
  END.
  ELSE DO: 
    /* is this from a navtarget ?*/
    hNavTarget = {fnarg activeTarget 'Navigation':U}. 
    IF hSource <> hNavTarget THEN
    /* The SBO does not publish, so we need to do this trick to find the actual
        source-procedure. This is only an issue for navigationTarget */
       {get TargetProcedure hSource SOURCE-PROCEDURE} NO-ERROR.
    /* From 9.1C we don't care what state, but check the linked object's state 
       instead */ 
    IF hSource = hNavTarget THEN
      RUN resetNavigation IN TARGET-PROCEDURE.     
  END.
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewHideActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewHideActions Procedure 
PROCEDURE viewHideActions :
/*------------------------------------------------------------------------------
  Purpose: To view and hide actions according to state (called from setbuttons)
Parameter: input comma seperated list of actions to view
           input comma seperated list of actions to hide
    Notes: For buttons we simply hide/view existing buttons and then remove them
           into new positions.
           For menu items we must reconstruct any submenus that have been
           modified as menu items do not have a hidden attribute.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcViewActions  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcHideActions  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cAction         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRebuildBands   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lButtonsChanged AS LOGICAL    NO-UNDO.

  DEFINE BUFFER btMenu FOR tMenu.
  DEFINE BUFFER btButton FOR tButton.

  DO iLoop = 1 TO NUM-ENTRIES(pcViewActions):
    cAction = ENTRY(iLoop,pcViewActions).  
    /*
    FIND btMenu WHERE btMenu.Name    = cAction
                  AND btMenu.hTarget = TARGET-PROCEDURE NO-ERROR.
    
    IF AVAILABLE btMenu AND btMenu.hdl:HIDDEN = TRUE THEN 
    DO:
      IF LOOKUP(btMenu.PARENT,cRebuildBands) = 0 THEN
        ASSIGN cRebuildBands = cRebuildBands + (IF cRebuildBands = "":U THEN "":U ELSE ",":U) + btMenu.PARENT.
    END.
    */
    FIND btButton WHERE btButton.Name    = cAction
                    AND btButton.hTarget = TARGET-PROCEDURE NO-ERROR.
    IF AVAILABLE btButton AND btButton.hdl:HIDDEN = TRUE THEN 
    DO:
      IF VALID-HANDLE(btButton.Hdl) THEN
         btButton.Hdl:HIDDEN = FALSE.          
      IF NOT lButtonsChanged THEN ASSIGN lButtonsChanged = TRUE.
    END.
  END. /* do iLoop = 1 to num-entries(pcViewActions) */

  DO iLoop = 1 TO NUM-ENTRIES(pcHideActions):
    cAction = ENTRY(iLoop,pcHideActions).  

    /*
    FIND btMenu WHERE btMenu.Name    = cAction
                  AND btMenu.hTarget = TARGET-PROCEDURE NO-ERROR.
    
    IF AVAILABLE btMenu AND btMenu.hdl.HIDDEN = FALSE THEN 
    DO:
      btMenu.HIDDEN = TRUE.
      IF LOOKUP(btMenu.PARENT,cRebuildBands) = 0 THEN
      ASSIGN cRebuildBands = cRebuildBands + (IF cRebuildBands = "":U THEN "":U ELSE ",":U) + btMenu.PARENT.
    END.
    */
    FIND btButton WHERE btButton.Name    = cAction
                    AND btButton.hTarget = TARGET-PROCEDURE NO-ERROR.
    IF AVAILABLE btButton AND btButton.Hdl:HIDDEN = FALSE THEN 
    DO:
      IF VALID-HANDLE(btButton.Hdl) THEN
         btButton.Hdl:HIDDEN = TRUE.          
      IF NOT lButtonsChanged THEN ASSIGN lButtonsChanged = TRUE.
    END.
  END. /* do iLoop = 1 to num-entries(pcViewActions) */

  /* If any buttons have changed, fix button positions */
  IF lButtonsChanged THEN
    RUN moveButtons IN TARGET-PROCEDURE (INPUT YES).
    
  /* 
  /* If any menu items have changed, rebuild appropriate band submenus */
  IF cRebuildBands <> "":U THEN
  DO iLoop = 1 TO NUM-ENTRIES(cRebuildBands):
    /* 1st zap existing items on toolbar band */
    FOR EACH btMenu
       WHERE btMenu.hTarget = TARGET-PROCEDURE
         AND btMenu.PARENT = ENTRY(iLoop,cRebuildBands): 
      IF VALID-HANDLE(btMenu.hdl) THEN
        DELETE WIDGET btMenu.hdl.
      ASSIGN btMenu.hdl = ?.
    END.

    /* then reconstruct toolbar band */        
    DYNAMIC-FUNCTION("constructMenuItems":U IN TARGET-PROCEDURE,
                     ENTRY(iLoop,cRebuildBands),
                     "":U).
  END.
  */
RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject Procedure 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose: View the object 
           The purpose for the override is to add the menu bar handle 
           to the window.  
Parameters: <none> 
     Notes: we do not call super, but make sure objecthidden is managed here    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lToolBar    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hFrame      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cUIBmode    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hPopupFrame AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWindow     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hMenu       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lNoMenu     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lUseRepos   AS LOGICAL    NO-UNDO.

  {get Window hWindow}.
  {get ContainerHandle hFrame}.
  {get Toolbar lToolbar}.
  
  /* If the toolbar is not used, just move the frame to bottom
   (keeping it hidden, caused overlapping frames to remain hidden??) */
  hFrame:HIDDEN = FALSE NO-ERROR.

  IF NOT lToolbar THEN
    hFrame:MOVE-TO-BOTTOM().
  
  {get UIBMode cUIBMode}.
  {get UseRepository lUseRepos}.

  IF cUIBMode ='Design':U THEN
  DO:
    /* check this special designtime property in design.p that is set from 
        Appbuilder to avoid 'viewing' menus on hidden pages, because this
        will override the visible ones and hideObject will remove it.*/
    IF NOT lUseRepos THEN
        lNoMenu = DYNAMIC-FUNCTION('getDesignTimeHideMenu':U IN TARGET-PROCEDURE)
                  NO-ERROR. 

      /* Find the ventilator frame */
      hPopupFrame = hFrame:FIRST-CHILD.
      hPopupFrame = hPopupframe:FIRST-CHILD.
      IF VALID-HANDLE(hPopupFrame) THEN 
        hPopupframe:MOVE-TO-TOP().
  END.
  
  IF NOT lUseRepos THEN
  DO:  
    {get MenubarHandle hMenu}.
    IF VALID-HANDLE(hMenu) AND VALID-HANDLE(hMenu:FIRST-CHILD) AND NOT (lNoMenu = TRUE) THEN  
      hWindow:MENUBAR = hMenu.
    /* This is only done to enable accellerators, before the menus are dropped */
    IF cUIBMode = '':U THEN 
      RUN buildAllMenus IN TARGET-PROCEDURE.
  END.
       
  {set ObjectHidden NO}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-windowEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE windowEnabled Procedure 
PROCEDURE windowEnabled :
/*------------------------------------------------------------------------------
  Purpose:     To check if window enabled (for window drop down list)
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phHandle     AS HANDLE   NO-UNDO.
  DEFINE OUTPUT PARAMETER plEnabled   AS LOGICAL  NO-UNDO.

  DEFINE VARIABLE lEnabled AS LOGICAL.

  IF phHandle  = ? THEN
  DO:
    lEnabled = NO.
    RETURN.
  END.

  IF NOT phHandle:SENSITIVE THEN
  DO:
    ASSIGN
      lEnabled = NO.
    RETURN.
  END.

  phHandle = phHandle:FIRST-CHILD.

  DO WHILE phHandle <> ?:
    IF phHandle:SENSITIVE THEN 
    DO:
      plEnabled = YES.
      RETURN.
    END. 

    RUN WindowEnabled IN TARGET-PROCEDURE (INPUT phHandle, OUTPUT lEnabled).
    IF lEnabled THEN
    DO:
      plEnabled = YES.
      RETURN.
    END.
    phHandle = phHandle:NEXT-SIBLING.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-windowFocus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE windowFocus Procedure 
PROCEDURE windowFocus :
/*------------------------------------------------------------------------------
  Purpose:     Focus window
  Parameters:  input window handle
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  phHandle                  AS HANDLE   NO-UNDO.

IF VALID-HANDLE(phHandle) THEN
DO:
  APPLY "ENTRY":U TO phHandle.
  phHandle:MOVE-TO-TOP().  
  IF phHandle:WINDOW-STATE = WINDOW-MINIMIZED
    THEN phHandle:WINDOW-STATE = WINDOW-NORMAL.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-windowListMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE windowListMenu Procedure 
PROCEDURE windowListMenu :
/*------------------------------------------------------------------------------
  Purpose:     Build drop down list of session windows menu
  Parameters:  input submenu handle to build list in
               input toolbar container procedure handle
               input start handle (first time = session).
               input window count
  Notes:       Recursive procedure !
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcBand                   AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER phContainer              AS HANDLE   NO-UNDO.
DEFINE INPUT PARAMETER phStart                  AS HANDLE   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER piCount                  AS INTEGER  NO-UNDO.

DEFINE BUFFER btMenu FOR tMenu.
DEFINE BUFFER btParentInstance FOR tBandInstance.

FIND btParentInstance WHERE btParentInstance.Band    = pcBand 
                      AND   btParentInstance.hTarget = TARGET-PROCEDURE NO-ERROR. 

DEFINE VARIABLE hHandle                         AS HANDLE     NO-UNDO.
DEFINE VARIABLE lEnabled                        AS LOGICAL INITIAL YES NO-UNDO.    
DEFINE VARIABLE istartAlpha                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE cLabel                          AS CHARACTER  NO-UNDO.

ASSIGN
  hHandle = phStart:FIRST-CHILD.
  
DO WHILE VALID-HANDLE(hHandle):
  IF hHandle:TYPE = "WINDOW" AND
     hHandle:VISIBLE AND
     LENGTH(TRIM(hHandle:TITLE)) > 1 AND
     hHandle <> phContainer:CURRENT-WINDOW THEN
  DO:
    ASSIGN piCount = piCount + 1.
    RUN WindowEnabled IN TARGET-PROCEDURE (INPUT hHandle, OUTPUT lEnabled).
    
    IF piCount > 9 THEN
      ASSIGN
        iStartAlpha =  ASC("a":U)
        iStartAlpha = iStartAlpha + piCount - 10
        cLabel = "&":U + CHR(iStartAlpha) + " ":U + hHandle:TITLE
        .
    ELSE cLabel = "&":U + TRIM(STRING(piCount)) + " ":U + hHandle:TITLE.
          
    CREATE btMenu.
    ASSIGN
      btMenu.hTarget = TARGET-PROCEDURE
      btMenu.NAME    = pcBand + ":":U + STRING(hHandle)
      btMenu.PARENT  = pcBand
      btMenu.seq     = piCount
      btMenu.REFRESH = NO
      btMenu.Sensitive = lEnabled.         
    CREATE MENU-ITEM btMenu.hdl
    ASSIGN  
      LABEL = cLabel
      PARENT = btParentInstance.hdl
      SENSITIVE = lEnabled
    TRIGGERS:
      ON "CHOOSE":U PERSISTENT RUN WindowFocus IN TARGET-PROCEDURE (INPUT hHandle).
    END.                
  END.
  IF hHandle:TYPE = "WINDOW":U THEN 
  DO:
    RUN WindowListMenu IN TARGET-PROCEDURE 
                      (INPUT pcBand,
                       INPUT phContainer,
                       INPUT hHandle,
                       INPUT-OUTPUT piCount).
  END.

  ASSIGN hHandle = hHandle:NEXT-SIBLING.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-actionCanRun) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionCanRun Procedure 
FUNCTION actionCanRun RETURNS LOGICAL
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if the target is valid and the procedure exists in it.
Parameter: pcAction - Action id of an action of type 'RUN'    
    Notes: Use to enable/disable 'run' and 'property' actions   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cProcedure       AS CHAR   NO-UNDO.
  DEFINE VARIABLE cParam           AS CHAR   NO-UNDO.
  DEFINE VARIABLE hobject          AS HANDLE NO-UNDO.
  DEFINE VARIABLE cDisabledActions AS CHAR   NO-UNDO.
  
  {get DisabledActions cDisabledActions}.
  
  IF CAN-DO(cDisabledActions,pcAction) THEN
    RETURN FALSE.

  RUN runInfo IN TARGET-PROCEDURE
       (INPUT  pcAction,
        OUTPUT cProcedure,
        OUTPUT cParam).
  
  hObject = {fnarg actionTarget pcAction}.

  IF VALID-HANDLE(hObject) THEN 
     RETURN {fnarg Signature cProcedure hObject} <> "":U.
  ELSE RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionCaption) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionCaption Procedure 
FUNCTION actionCaption RETURNS CHARACTER
  ( pcAction AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Override action class and caption  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCaption AS CHARACTER  NO-UNDO.
  cCaption = SUPER(pcAction).
  
  IF cCaption <> '':U THEN
     cCaption = DYNAMIC-FUNCTION('substituteActionText':U IN TARGET-PROCEDURE,
                       pcAction,
                       cCaption).
  RETURN cCaption.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionCategoryIsHidden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionCategoryIsHidden Procedure 
FUNCTION actionCategoryIsHidden RETURNS LOGICAL
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Check if the action's category is hidden  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cGroups   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCategory AS CHARACTER  NO-UNDO.
  
  cCategory = {fnarg actionCategory pcAction}.
  IF cCategory <> '':U THEN 
  DO:
    /* Currently only link categories are manageable  */
    IF {fnarg categoryLink cCategory} <> '':U THEN
    DO:
      {get ActionGroups cGroups}.
      RETURN NOT CAN-DO(cGroups,cCategory). 
    END.  
  END.
  
  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionChecked) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionChecked Procedure 
FUNCTION actionChecked RETURNS LOGICAL
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if the get<Property> returns a value that matches
           the actions checked.
Parameter: pcAction - Action id of an action of type 'RUN'    
    Notes: Currently we only support logical values.
           returns unknown when the function does not exist or the object is 
           not valid. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cProperty  AS CHAR   NO-UNDO.
  DEFINE VARIABLE hObject    AS HANDLE NO-UNDO.
  DEFINE VARIABLE cChecked   AS LOG    NO-UNDO INIT ?.
  ASSIGN
    cProperty = "get":U + {fnarg actionOnChoose pcAction}.
    hObject = {fnarg actionTarget pcAction}. 
  
  IF VALID-HANDLE(hObject) THEN
    cChecked = DYNAMIC-FUNCTION(cProperty IN hObject) NO-ERROR.         
          
  RETURN cChecked.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionLabel Procedure 
FUNCTION actionLabel RETURNS CHARACTER
  ( pcAction AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLabel AS CHARACTER  NO-UNDO.
  cLabel = SUPER(pcAction).
  
  IF cLabel <> '':U THEN
     cLabel = DYNAMIC-FUNCTION('substituteActionText':U IN TARGET-PROCEDURE,
                       pcAction,
                       cLabel).
  RETURN cLabel.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionPublishCreate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionPublishCreate Procedure 
FUNCTION actionPublishCreate RETURNS LOGICAL
  ( pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Subscribe create events to objects 
    Notes: Subscribes both active and inactive (hidden) objects
           -target links are considered as multiple.
           -source as single. 
           The reason why subscribe and publish is used is mostly to be able
           to reference source-procedure in the events, but it also makes it
           possible to just subscribe without linking.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLink        AS CHAR   NO-UNDO.
  DEFINE VARIABLE cEvent       AS CHAR   NO-UNDO.
  DEFINE VARIABLE cLinkHandles AS CHAR   NO-UNDO.
  DEFINE VARIABLE hObject      AS HANDLE NO-UNDO.
  DEFINE VARIABLE i            AS INT    NO-UNDO.

  cEvent = {fnarg actionCreateEvent pcAction}.
  
  IF cEvent = "":U  THEN 
     RETURN FALSE.
  
  cLink = {fnarg actionLink pcAction}.
  IF cLink <> "":U THEN
  DO:
    IF ENTRY(2,cLink,"-":U) = "target":U THEN
      cLinkHandles = DYNAMIC-FUNCTION("get":U + REPLACE(cLink,"-":U,"":U)
                                       IN TARGET-PROCEDURE).
    
    ELSE
      hObject = DYNAMIC-FUNCTION("get":U + REPLACE(cLink,"-":U,"":U)
                                  IN TARGET-PROCEDURE).

  END. /* clink <> '' */
  ELSE  /* container is default  */
    {get ContainerSource hObject}.

  DO i = 1 TO IF cLinkHandles <> "":U THEN NUM-ENTRIES(clinkHandles)
              ELSE 1:
    IF cLinkHandles <> "":U THEN 
       hObject = WIDGET-HANDLE(ENTRY(i,cLinkHandles)).
    
    SUBSCRIBE PROCEDURE hObject TO cEvent IN  TARGET-PROCEDURE NO-ERROR.
  END.
  PUBLISH cEvent FROM TARGET-PROCEDURE (pcAction).

  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionTarget Procedure 
FUNCTION actionTarget RETURNS HANDLE
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Returns the handle of the target.
           Used by actions of Type RUN or PROPERTY. 
Parameter: pcAction - Action id     
    Notes: The container-Source is the default target.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hObject        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cParent        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCategory      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLink          AS CHARACTER  NO-UNDO.
  
  cLink = {fnarg actionLink pcAction}.   
  
  IF cLink <> "":U THEN
  DO:
    IF ENTRY(2,cLink,"-":U) = "target":U THEN
      ASSIGN
        cLink = ENTRY(1,cLink,"-":U)
        hObject = {fnarg activeTarget cLink}.
    ELSE 
      hObject = DYNAMIC-FUNCTION("get":U + REPLACE(cLink,"-":U,"":U) ) NO-ERROR.          
  END. /* if link <> "" */
  ELSE
    {get ContainerSource hObject} NO-ERROR.
              
  RETURN hObject.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionTooltip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionTooltip Procedure 
FUNCTION actionTooltip RETURNS CHARACTER
  ( pcAction AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTooltip AS CHARACTER  NO-UNDO.
  cTooltip = SUPER(pcAction).
  
  IF cTooltip <> '':U THEN
     cTooltip = DYNAMIC-FUNCTION('substituteActionText':U IN TARGET-PROCEDURE,
                       pcAction,
                       cTooltip).
  RETURN cTooltip.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adjustActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION adjustActions Procedure 
FUNCTION adjustActions RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Called after realization of toolbar to adjust sizes  
    Notes: Returns true if changes happened 
           Currently changes width of all actions in a horizontal toolbar
           to maxwidth encountered during realization
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cToolbarDrawDirection AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iToolMaxWidthPxl      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iToolWidthPxl         AS INTEGER    NO-UNDO.
  
  DEFINE BUFFER btButton FOR tButton.

  {get ToolbarDrawDirection cToolbarDrawDirection}.

  IF cToolbarDrawDirection BEGINS 'v':U THEN
  DO:
    {get ToolMaxWidthPxl iToolMaxWidthPxl}.
    {get ToolWidthPxl iToolWidthPxl}.
    IF iToolMaxWidthPxl > iToolWidthPxl THEN
    DO:
      FOR EACH btButton WHERE btbutton.hTarget = TARGET-PROCEDURE:
        btButton.hdl:WIDTH-P = iToolMaxWidthPxl.
      END.
    END.
  END.

  RETURN iToolMaxWidthPxl > iToolWidthPxl. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bandActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION bandActions Procedure 
FUNCTION bandActions RETURNS CHARACTER
  ( pcParentBand AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the available menu band for this toolbar master 
    Notes:  Used in the Instance Property dialog to select MenuBands
------------------------------------------------------------------------------*/
 DEFINE BUFFER bttBand       FOR ttBand.
 DEFINE BUFFER bttBandAction FOR ttBandAction.
 
 DEFINE VARIABLE cLogicalObject AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cActionList    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cType          AS CHARACTER  NO-UNDO.

 {get LogicalObjectName cLogicalObject}.
 
 FOR EACH bttBandAction 
      WHERE bttBandAction.Band = pcParentBand 
 BY bttBandAction.Sequence:    
   IF bttBandAction.ChildBand = '':U THEN
   DO:
     cType = {fnarg actionType bttBandAction.Action}.
     IF NOT CAN-DO('Separator,Placeholder':U,bttBandAction.Action) THEN
     DO:
       cActionList = cActionList 
                   + (IF cActionList <> '':U THEN ',':U ELSE '':U) 
                   +  bttBandAction.Action.
     END.
   END.
 END.
 RETURN cActionList.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bandSubmenuLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION bandSubmenuLabel Procedure 
FUNCTION bandSubmenuLabel RETURNS CHARACTER
  ( pcBand      AS CHARACTER,
    pcChildBand AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Return the label for a specific childband 
    Notes:  Currently used for instance property dialog
------------------------------------------------------------------------------*/
 DEFINE BUFFER bttChildBand   FOR ttBand.
 DEFINE BUFFER bttBandAction  FOR ttBandAction.       
 DEFINE BUFFER bttToolbarBand FOR ttToolbarBand. 
 DEFINE BUFFER bttBand        FOR ttBand.

 DEFINE VARIABLE cLogicalObject AS CHARACTER  NO-UNDO. 

 IF pcBand = '':U THEN
 DO:
   {get LogicalObjectName cLogicalObject}.
   FOR EACH bttToolbarBand 
       WHERE bttToolbarBand.Toolbar  = cLogicalObject,
       EACH bttBand 
       WHERE bttBand.Band     = bttToolbarBand.Band  
       AND   bttBand.BandType = 'Menubar':U :

     pcBand = bttBand.Band.
     LEAVE. /* there should be only one, but let's leave and use the first
                no matter what */
   END.
 END.

 FIND bttBandAction 
      WHERE bttBandAction.Band      = pcBand 
      AND   bttBandAction.ChildBand = pcChildBand NO-ERROR.
 IF AVAIL bttBandAction THEN
 DO:
 IF bttBandAction.Action <> '':U THEN
    RETURN {fnarg actionLabel bttBandAction.Action}.

 /* Find the default label of the band */
 FIND bttChildBand WHERE bttChildBand.Band = bttBandAction.ChildBand.
 IF bttChildBand.BandLabelAction <> '':U THEN
   RETURN {fnarg actionLabel bttChildBand.BandLabelAction}.

 ELSE RETURN bttBandAction.ChildBand.
 END.

 /* If there's more than one child band (??) just return the band name */  
 ELSE IF AMBIGUOUS bttBandAction THEN
   RETURN pcBand.
    
 RETURN "":U.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bandSubmenus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION bandSubmenus Procedure 
FUNCTION bandSubmenus RETURNS CHARACTER
  ( pcParentBand AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose:  Returns the available child bands on a specific band             
 Parameter: pcParentBand - Band name 
                         - Blank - The menubar of the Toolbar master
            plLabels     - Return the action labels if defined               
     Notes:  Used in the Instance Property dialog to select MenuBands
------------------------------------------------------------------------------*/
 DEFINE BUFFER bttBand        FOR ttBand.
 DEFINE BUFFER bttBandAction  FOR ttBandAction.
 DEFINE BUFFER bttToolbarBand FOR ttToolbarBand.

 DEFINE VARIABLE cLogicalObject AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cBandList      AS CHARACTER  NO-UNDO.
  
 /* if no parent specified find and use the menubar */
 IF pcParentBand = '':U THEN
 DO:
   {get LogicalObjectName cLogicalObject}.
   FOR EACH bttToolbarBand 
       WHERE bttToolbarBand.Toolbar  = cLogicalObject,
       EACH bttBand 
       WHERE bttBand.Band     = bttToolbarBand.Band  
       AND   bttBand.BandType = 'Menubar':U :

     pcParentBand = bttBand.Band.
     LEAVE. /* there should be only one, but let's leave and use the first
                no matter what */
   END.
 END.

 FOR EACH bttBandAction 
      WHERE bttBandAction.Band = pcParentBand 
 BY bttBandAction.Sequence:    
   IF bttBandAction.ChildBand <> '':U THEN
   DO:
     cBandList = cBandList 
               + (IF cBandList <> '':U THEN ',':U ELSE '':U) 
               + bttBandAction.ChildBand.
   END.
 END.
 RETURN cBandList.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildMenu Procedure 
FUNCTION buildMenu RETURNS LOGICAL
  (pcParent AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Build one branch of a menu.  
Parameters: INPUT pcParent - The  name of the sub-menu that this menu will use 
                             as its parent
                             Blank - means that we are creating a menu-bar. 
     Notes: Called from onMenuDrop  
------------------------------------------------------------------------------*/
  DEFINE BUFFER tChild  FOR TMenu.
  
  DEFINE VARIABLE hMenu            AS HANDLE NO-UNDO. 
  DEFINE VARIABLE cType            AS CHAR   NO-UNDO. 
  DEFINE VARIABLE cBuildInitCode   AS CHAR   NO-UNDO. 
  DEFINE VARIABLE cMenuItems       AS CHAR   NO-UNDO. 
  DEFINE VARIABLE lRefresh         AS LOG    NO-UNDO. 
  DEFINE VARIABLE lMenu            AS LOG    NO-UNDO. 
  DEFINE VARIABLE lDefined         AS LOG    NO-UNDO. 
  DEFINE VARIABLE i                AS INT    NO-UNDO. 
  DEFINE VARIABLE lCanAddRule      AS LOG    NO-UNDO.
  DEFINE VARIABLE hActionTarget    AS HANDLE NO-UNDO.
  DEFINE VARIABLE lChecked         AS LOG    NO-UNDO.
  DEFINE VARIABLE cDisabledActions AS CHAR   NO-UNDO.
  
  {get Menu lMenu}.
  {get DisabledActions cDisabledActions}.

  IF NOT lMenu THEN 
    RETURN FALSE.

  If pcParent = "":U THEN 
    hMenu = {fn createMenuBar}.
  ELSE    
  DO:
    FIND tMenu WHERE tMenu.Name    = pcParent
                 AND tMenu.hTarget = TARGET-PROCEDURE NO-ERROR.
    IF NOT AVAIL tMenu THEN 
       RETURN FALSE.
    hMenu = tMenu.Hdl.   
  END.
  
  /* Initcode menues area always recreated  */
  cBuildInitCode  = {fnarg ActionInitCode pcParent}.    
  
  IF cBuildInitCode <> "":U THEN 
  FOR EACH tMenu WHERE tMenu.Parent  = pcParent 
                 AND   tMenu.hTarget = TARGET-PROCEDURE
                 AND   tMenu.NAME BEGINS pcParent + ":":U:
    IF VALID-HANDLE(tMenu.Hdl) THEN 
      DELETE WIDGET tMenu.Hdl.
    DELETE tMenu.   
  END.
  
  /* If refresh then delete all */ 
  lRefresh   = {fnarg ActionRefresh pcParent}.
  
  IF lRefresh THEN 
  FOR EACH tMenu WHERE tMenu.Parent  = pcParent 
                 AND   tMenu.hTarget = TARGET-PROCEDURE:
    
    IF VALID-HANDLE(tMenu.Hdl) THEN 
        DELETE WIDGET tMenu.Hdl.
    DELETE tMenu.   
  END.
  
  IF NOT VALID-HANDLE(hMenu:FIRST-CHILD) THEN 
  DO:
    FOR EACH tMenu WHERE tMenu.Parent  = pcParent 
                   AND   tMenu.hTarget = TARGET-PROCEDURE:
      IF tMenu.Name <> "RULE":U OR lCanAddRule THEN
      DO:
        DYNAMIC-FUNCTION('createMenuAction':U IN TARGET-PROCEDURE,
                          pcParent,
                          tMenu.Name).
        lCanAddRule = tMenu.Name <> "RULE":U.
      END. /* if rule */
    END. /* for each tMenu */
  END. /* if not valid handle first tmenu */
  ELSE DO:
    /* Properties and RUN are marked as refresh when created  
       in order to make them show CHECKED and or sensitive correctly 
       if changed from elsewhere or paging made them non-active/active */ 
     
    /*** DEPRECATED LOGIC: 
         All action states are evaluated in rulestatechanges on all possible
         events that may change the states 
            
     FOR EACH tMenu WHERE tMenu.Refresh = TRUE
                   AND   tMenu.Parent  = pcParent 
                   AND   tMenu.hTarget = TARGET-PROCEDURE:
      
      cType    = {fnarg actionType tMenu.Name}.
      IF cType = "RUN":U THEN
      DO:
        tMenu.Sensitive = {fnarg actionCanRun tMenu.Name}. 
        IF VALID-HANDLE(tMenu.Hdl) THEN 
           tMenu.Hdl:SENSITIVE = tMenu.Sensitive.
      END.

      ELSE IF cType = "PROPERTY":U THEN
      DO:  
        ASSIGN
         lChecked      = {fnarg actionChecked tMenu.Name}  
         tMenu.Sensitive = (lChecked <> ?) 
                          AND NOT CAN-DO(cDisabledActions,tMenu.Name) .
        IF VALID-HANDLE(tMenu.Hdl) THEN 
          ASSIGN
            tMenu.Hdl:SENSITIVE = tMenu.Sensitive
            tMenu.Hdl:CHECKED   = lChecked = TRUE.
      END.
    END. /* for each menu where refresh */     
    **/
  END. /* else (ie menus are already creatred */
   
    /* initCode procedures can create a poor-mans menu 
       that just creates key and text based on the CHR(1) separated list
       returned from the function. The key will be passed as input parameter 
       to the parents onChoose */

  IF cBuildInitCode <> "":U THEN 
  DO:
    ASSIGN 
      hActionTarget = {fnarg actionTarget pcParent}. 
      
    IF VALID-HANDLE(hActionTarget) THEN      
        cMenuItems = DYNAMIC-FUNCTION(cBuildInitCode IN hActionTarget).
      
    DO i = 1 TO NUM-ENTRIES(cMenuItems,CHR(1)) BY 2:  
        DYNAMIC-FUNCTION('createMenuTempTable':U IN TARGET-PROCEDURE,
                         pcParent,
                         /* add parent in order to make it identifiable */ 
                         pcParent + ":" + ENTRY(i,cMenuItems,CHR(1)),
                         ?).
        tMenu.Sensitive = TRUE.
        tMenu.Hdl = DYNAMIC-FUNCTION("createMenuItem":U IN TARGET-PROCEDURE,
                        hMenu,
                        tMenu.Name,
                        ENTRY(i + 1,cMenuItems,CHR(1)),
                        "":U,
                        tMenu.Sensitive
                  ).  
   
    END. /* do i = 1 to num-entries(cMenuItems,CHR(1)) */
  END. /* cInitCode <> "":U */
  
  FIND LAST tMenu WHERE tMenu.Parent  = pcParent 
                  AND   tMenu.hTarget = TARGET-PROCEDURE NO-ERROR.
    
  /* make sure that we don't have a RULE as the last entry */
  IF AVAIL tMenu AND tMenu.Name = "RULE":U AND VALID-HANDLE(tMenu.Hdl) THEN
     DELETE WIDGET tMenu.Hdl.  


  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-categoryActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION categoryActions Procedure 
FUNCTION categoryActions RETURNS CHARACTER
  ( pcCategory AS CHAR ) :
/*------------------------------------------------------------------------------
   Purpose:  Returns the available actions for a specific category on this 
            toolbar master. 
Parameters: pcCategory - category name 
                       - blank is valid as it is used to find uncategorized 
                         actions  
                       - '*' All actions.              
     Notes: Used in the Instance Property dialog to select MenuBands
------------------------------------------------------------------------------*/
 DEFINE BUFFER bttBand        FOR ttBand.
 DEFINE BUFFER bttBandAction  FOR ttBandAction.
 DEFINE BUFFER bttToolbarBand FOR ttToolbarBand. 
 DEFINE VARIABLE cLogicalObject AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cActionList    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cType          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCategory      AS CHARACTER  NO-UNDO.

 IF pcCategory = xcNoCategory THEN
    pcCategory = '':U.

 {get LogicalObjectName cLogicalObject}.
 
 FOR 
 EACH bttToolbarband WHERE bttToolbarBand.toolbar = cLogicalObject,
 EACH bttBand WHERE bttBand.band = bttToolbarband.Band,
 EACH bttBandAction WHERE bttBandAction.Band = bttBand.band 
     BY (IF bttBand.Bandtype = 'Toolbar' OR bttBand.Bandtype = 'Menu&Toolbar' 
         THEN IF bttToolbarBand.alignment = 'Left' 
              THEN 1
              ELSE IF bttToolbarBand.alignment = 'Center' 
              THEN 2
              ELSE 3
          ELSE 4)
     BY bttBandAction.Sequence:  
   IF bttBandAction.ChildBand = '':U THEN
   DO:
     IF cCategory <> '*':U THEN
     DO:
       cCategory = {fnarg actionCategory bttBandAction.Action}.
     END.
     cType = {fnarg actionType bttBandAction.Action}.
     IF  (cCategory = '*':U OR cCategory = pcCategory)
     AND NOT CAN-DO('Separator,Placeholder':U,cType) 
     AND NOT CAN-DO(cActionList,bttBandAction.Action)  THEN
       cActionList = cActionList 
                   + (IF cActionList <> '':U THEN ',':U ELSE '':U) 
                   +  bttBandAction.Action.
   END.
 END.
 RETURN cActionList.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-constructMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION constructMenu Procedure 
FUNCTION constructMenu RETURNS LOGICAL
    ( ):         
/*------------------------------------------------------------------------------
  Purpose: Construct the toolbar from loaded data. 
    Notes: This will realize bands read from the repository 
           Non-repository toolbars are created with createToolbar. 
           Both uses createToolbarAction to realize the actions/widgets. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cActions          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogicalObject    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lMenu             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cHiddenMenuBands  AS CHARACTER  NO-UNDO.

  {get Menu lMenu}.
  {get LogicalObjectName cLogicalObject}.
  {get HiddenMenuBands cHiddenMenuBands}.

  /* The toolbar bands stores data for a toolbar object (master) and 
     are loaded for the first instance */
  IF lMenu THEN
  DO:
    FOR 
    EACH ttToolbarBand 
     WHERE ttToolbarBand.Toolbar  = cLogicalObject
     AND  (LOOKUP (ttToolbarBand.Band,cHiddenMenuBands) = 0),
    EACH ttBand 
     WHERE ttBand.Band  = ttToolbarBand.Band  
     AND (ttBand.BandType = 'Menubar':U):

      CREATE tBandInstance.
      ASSIGN 
        tBandInstance.hdl     = {fn createMenuBar}
        tBandInstance.Band    = ttBand.Band
        tBandInstance.hTarget = TARGET-PROCEDURE.
      {fnarg constructMenuBand ttBand.Band}.
    END.
  END.
  
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-constructMenuBand) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION constructMenuBand Procedure 
FUNCTION constructMenuBand RETURNS LOGICAL
  (pcBand AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Create all items/subbandd for a band   
    Notes: Bands are only supported for Repository toolbars
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttBand FOR ttBand. 
  DEFINE BUFFER btParentInstance FOR tBandInstance.
  DEFINE BUFFER bttBandAction FOR ttBandAction.
  DEFINE BUFFER btMenu FOR tMenu.

  DEFINE VARIABLE cAction          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHiddenMenuBands AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hMenu            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWindowRule      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLastControlType AS CHAR       NO-UNDO.
  DEFINE VARIABLE cControlType     AS CHAR       NO-UNDO.
  DEFINE VARIABLE cSecuredTokens   AS CHARACTER  NO-UNDO.

  {get HiddenMenuBands cHiddenMenuBands}.
  {get SecuredTokens cSecuredTokens}.

  FIND bttBand WHERE bttBand.Band = pcBand NO-ERROR. 
  
  IF NOT AVAIL bttBand THEN
    RETURN FALSE.

  FIND btParentInstance WHERE btParentInstance.Band = pcBand 
                        AND   btParentInstance.hTarget = TARGET-PROCEDURE NO-ERROR.  
  IF NOT AVAIL btParentInstance THEN
    RETURN FALSE.

  cLastControlType  = 'Separator':U.

  FOR EACH bttBandAction 
      WHERE bttBandAction.Band = bttBand.Band 
  BY bttBandAction.Sequence:
    
    IF bttBandAction.Childband <> '':U
    AND CAN-DO(cHiddenMenuBands,bttBandAction.ChildBand)  THEN
      NEXT.
    
    cAction       = IF bttBandAction.Action <> '':U 
                    THEN bttBandAction.Action
                    ELSE bttBand.BandLabelAction.
    
    IF cSecuredTokens <> '':U 
    AND CAN-DO(cSecuredTokens,{fnarg actionSecuredToken cAction}) 
    OR  CAN-DO(cSecuredTokens,cAction) THEN 
       NEXT.

    cControlType = {fnarg actionControlType cAction}.
    
    /* We log LastControlType during the loop to avoid double rules */
    IF cControlType = 'separator':U AND cLastControlType = cControlType  THEN
       NEXT.

    hMenu = DYNAMIC-FUNCTION('createMenuAction':U IN TARGET-PROCEDURE,
                              bttBand.Band,
                              cAction). 

    IF bttBandAction.Childband <> '':U THEN
    DO:
      IF VALID-HANDLE(hMenu) THEN
      DO:
        CREATE tBandInstance.
        ASSIGN 
          tBandInstance.Band    = bttBandAction.Childband
          tBandInstance.hdl     = hMenu
          tBandInstance.hTarget = TARGET-PROCEDURE.
      
        DYNAMIC-FUNCTION('constructMenuBand':U IN TARGET-PROCEDURE,       
                        bttBandAction.ChildBand).
        
        cLastControlType = cControlType. 
                
        IF bttBandAction.Childband = xcWindowBand THEN
        DO:
          /* add a rule if other children was added */
          IF VALID-HANDLE(hMenu:FIRST-CHILD) THEN
          DO:
            DYNAMIC-FUNCTION ('createMenuTempTable':U IN TARGET-PROCEDURE,
                               bttBandAction.ChildBand,
                              'RULE':U).
            hWindowRule  = DYNAMIC-FUNCTION("createRule":U IN TARGET-PROCEDURE,
                                             hMenu). 
          END.

          IF NOT {fnarg windowDropDownList bttBandAction.Childband} THEN
          DO:
            FIND btMenu WHERE btMenu.hTarget = TARGET-PROCEDURE 
                        AND   btMenu.hdl     = hWindowRule NO-ERROR.
            IF AVAIL btMenu THEN 
              DELETE btMenu.
          
            DELETE OBJECT hWindowRule.
          END.
        END.
      END.
    END.
    ELSE DO:
      IF cControlType = 'placeholder':U THEN
      DO:
        DYNAMIC-FUNCTION('constructObjectMenus':U IN TARGET-PROCEDURE,
                          pcBand,
                          bttBandAction.Action,
                         TRUE).
        cLastControlType = cControlType. 
      END.
      ELSE IF VALID-HANDLE(hMenu) THEN
        cLastControlType = cControlType. 
    END.
  END.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-constructObjectMenus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION constructObjectMenus Procedure 
FUNCTION constructObjectMenus RETURNS LOGICAL
  ( pcBand  AS CHAR,
    pcPlaceholder AS CHAR, 
    plBlank AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttObjectBand        FOR ttObjectBand. 
  DEFINE BUFFER bttBand              FOR ttBand. 
  DEFINE BUFFER btParentBandInstance FOR tBandInstance.
  DEFINE BUFFER btBandInstance       FOR tBandInstance.
  
  DEFINE VARIABLE cObjectList   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRunAttribute AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPlaceholder  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hMenu         AS HANDLE     NO-UNDO.
  
  FIND bttBand WHERE bttBand.Band = pcBand NO-ERROR. 

  IF NOT AVAIL bttBand THEN
    RETURN FALSE.

  FIND btParentBandInstance WHERE btParentBandInstance.Band = pcBand 
                             AND  btParentBandInstance.hTarget = TARGET-PROCEDURE NO-ERROR.  

  cObjectList = {fnarg supportedObjects YES}.
  
  DO i = 1 TO NUM-ENTRIES(cObjectList):
    ASSIGN
      cObjectName   = ENTRY(i,cObjectList)
      cRunAttribute = (IF NUM-ENTRIES(cObjectName,';':U) > 1 
                       THEN ENTRY(2,cObjectName,';':U)
                       ELSE '':U)
      cObjectName   = ENTRY(1,cObjectName,';':U).

    DO iPlaceHolder = 1 TO IF plBLank THEN 2 ELSE 1:
      FOR EACH bttObjectBand 
          WHERE bttObjectBand.Action       = (IF iPlaceHolder = 1
                                              THEN pcPlaceholder
                                              ELSE '':U)
          AND   bttObjectBand.ObjectName   = cObjectName
          AND   bttObjectBand.RunAttribute = (IF cRunAttribute = '':U 
                                              THEN bttObjectBand.RunAttribute
                                              ELSE cRunAttribute),

         EACH bttBand WHERE bttBand.Band = bttObjectBand.Band
          BY bttObjectBand.ObjectName
          BY bttObjectBand.RunAttribute 
          BY bttObjectBand.Sequence:
        
        IF btParentBandInstance.Hdl:TYPE <> 'menu':U THEN           
            DYNAMIC-FUNCTION('createMenuAction':U IN TARGET-PROCEDURE,
                              bttBand.Band,
                             'RULE':U).
        IF bttObjectBand.InsertSubmenu THEN
          hMenu = DYNAMIC-FUNCTION('createMenuAction':U IN TARGET-PROCEDURE,
                                    pcBand,
                                    bttBand.BandLabelAction). 
        ELSE 
          hMenu = btParentBandInstance.hdl.

        CREATE btBandInstance.
          ASSIGN 
            btBandInstance.Band    = bttBand.Band
            btBandInstance.hdl     = hMenu
            btBandInstance.hTarget = TARGET-PROCEDURE.
        
        DYNAMIC-FUNCTION('constructMenuBand':U IN TARGET-PROCEDURE,       
                          bttBand.Band).        
      END.
    END.
  END.

  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-constructToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION constructToolbar Procedure 
FUNCTION constructToolbar RETURNS LOGICAL
    ( ):         
/*------------------------------------------------------------------------------
  Purpose: Construct the toolbar from loaded repository data. 
    Notes: This will realize bands read from the repository 
           Non-repository toolbars are created with createToolbar. 
           Both uses createToolbarAction to realize the actions/widgets. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cActions            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogicalObject      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lShowBorder         AS LOG        NO-UNDO. 
  DEFINE VARIABLE iPosition           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iToolbarHeightPxl   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iToolSeparatorPxl   AS INTEGER    NO-UNDO.  
  DEFINE VARIABLE lToolbar            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lActions            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAnyActions         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE dMinWidth           AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dMinHeight          AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cHiddenToolbarBands AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hButton             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSecuredTokens      AS CHARACTER     NO-UNDO.
  
  {get Toolbar lToolbar}.
  {get ToolSeparatorPxl iToolSeparatorPxl}.   
  {get LogicalObjectName cLogicalObject}.
  {get ToolBarHeightPxl iToolBarHeightPxl}.
  {get ShowBorder lShowBorder}.
  {get HiddenToolbarBands cHiddenToolbarBands}.
  {get SecuredTokens cSecuredTokens}.
  
  {set MinWidth  0}. 
  {set MinHeight 0}. 
  {set ToolMaxWidthPxl  0}.

  ASSIGN 
    iPosition       = iToolSeparatorPxl
                      + (If lShowBorder THEN 2 ELSE 0).  
  
  /* The toolbar bands stores data for a toolbar object (master) and are loaded 
     for the first instance */
 
  IF lToolbar THEN
  DO:
    FOR 
    EACH ttToolbarBand 
       WHERE ttToolbarBand.toolbar  = cLogicalObject
       AND  (LOOKUP (ttToolbarBand.Band,cHiddenToolbarBands) = 0),
    EACH ttBand 
       WHERE ttBand.Band  = ttToolbarBand.Band  
       AND (ttBand.BandType = 'Toolbar':U 
            OR
            ttBand.BandType = 'Menu&Toolbar':U)
    BY (IF ttToolbarBand.Alignment = 'Left':U         THEN 1
        ELSE IF ttToolbarBand.Alignment = 'Center':U  THEN 2
        ELSE                                               3)
    BY ttToolbarBand.Sequence:
      
      IF lActions AND ttToolbarBand.InsertRule THEN 
      DO:
        IF lShowborder THEN
           DYNAMIC-FUNCTION('createToolbarAction':U IN TARGET-PROCEDURE,
                            ttToolbarBand.Band,
                            'RULE':U,
                            INPUT-OUTPUT iPosition). 
        ELSE
           iPosition = iPosition + iToolSeparatorPxl.  
         lActions = FALSE.
      END.

      FOR EACH ttBandAction 
        WHERE ttBandAction.Band = ttBand.Band 
      BY ttBandAction.Sequence:  
      
        IF cSecuredTokens <> '':U 
            AND CAN-DO(cSecuredTokens,{fnarg actionSecuredToken ttBandAction.Action}) 
            OR  CAN-DO(cSecuredTokens,ttBandAction.Action) THEN 
        NEXT.
       
        hButton = DYNAMIC-FUNCTION('createToolbarAction':U IN TARGET-PROCEDURE,
                                    ttToolbarBand.Band,
                                    ttBandAction.Action,
                                    INPUT-OUTPUT iPosition). 
        
        IF NOT lActions THEN
          lActions = VALID-HANDLE(hButton).
        IF NOT lAnyActions THEN
          lAnyActions = VALID-HANDLE(hButton).
      END.
    END.
    IF lAnyActions THEN
    DO:
      {fn createToolbarBorder}.
    
      {get MinWidth  dMinWidth}. 
      {get MinHeight dMinHeight}. 

      RUN resizeObject IN TARGET-PROCEDURE(dMinHeight,dMinWidth).
      {fn adjustActions}.
    END.
  END.
  
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-create3DRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION create3DRule Procedure 
FUNCTION create3DRule RETURNS HANDLE
  (              phParent     AS HANDLE,     /* handle to the parent frame */
    INPUT-OUTPUT piXY         AS INTEGER    /* the x - posistion */                 
  ) :
/*------------------------------------------------------------------------------
  Purpose: Create a separator between toolbasr actions in the forma of a rectangle
Parameters: INPUT        phParent - Frame handle.
            INPUT-OUTPUT piX      - in X position - out used X and + height-p 
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE hTmp              AS HANDLE NO-UNDO.

DEFINE VARIABLE iToolSeparatorPxl     AS INTEGER NO-UNDO.
DEFINE VARIABLE iToolWidthPxl         AS INTEGER NO-UNDO.
DEFINE VARIABLE iToolHeightPxl        AS INTEGER NO-UNDO.
DEFINE VARIABLE iToolSpacingPxl       AS INTEGER NO-UNDO.
DEFINE VARIABLE iToolMarginPxl        AS INTEGER    NO-UNDO.
DEFINE VARIABLE cToolbarDrawDirection AS CHARACTER  NO-UNDO.  
DEFINE VARIABLE iEdgePixels           AS INTEGER    NO-UNDO.
DEFINE VARIABLE lShowBorder           AS LOGICAL    NO-UNDO.

{get ToolbarDrawDirection cToolbarDrawDirection}.
{get ToolSeparatorPxl     iToolSeparatorPxl}. 
{get ToolWidthPxl         iToolWidthPxl}.
{get ToolHeightPxl        iToolHeightPxl}.
{get ToolMarginPxl        iToolMarginPxl}.
{get EdgePixels           iEdgePixels}. 
{get ShowBorder           lShowBorder}.

 CREATE RECTANGLE  hTmp 
    ASSIGN FRAME         = phParent
           GRAPHIC-EDGE  = TRUE
           FILLED        = FALSE
           X             = 0
           Y             = 0
           EDGE-PIXELS   = 2
           WIDTH-PIXELS  = (IF cToolbarDrawDirection BEGINS "v":U 
                            THEN iToolWidthPxl  
                            ELSE (IF iEdgePixels = 1 THEN 1 ELSE 2))
           HEIGHT-PIXELS = (IF cToolbarDrawDirection BEGINS "v":U 
                            THEN (IF iEdgePixels = 1 THEN 1 ELSE 2)
                            ELSE iToolHeightPxl) 
           HIDDEN        = TRUE. 
      /* piX + iToolWidthPxl > phParent:WIDTH-PIXELS */
 IF cToolbarDrawDirection BEGINS "v":U THEN
 DO:
   ASSIGN 
     hTmp:X  = (IF iToolMarginPxl < 2 AND lShowBorder 
                THEN 2 
                ELSE iToolMarginPxl)
     hTmp:Y  = piXY + iToolSeparatorPxl 
     hTmp:HIDDEN = FALSE  NO-ERROR. 
   piXY = hTmp:Y + hTmp:HEIGHT-P + iToolSeparatorPxl.
 END.
 ELSE
 DO:
   ASSIGN
     hTmp:Y  = (IF iToolMarginPxl < 2 AND lShowBorder 
                THEN 2 
                ELSE iToolMarginPxl) 
     hTmp:X  = piXY + iToolSeparatorPxl 
     hTmp:HIDDEN = FALSE  NO-ERROR. 
   piXY = hTmp:X + hTmp:WIDTH-P + iToolSeparatorPxl.
 END. 
 
 RETURN hTmp.     

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createButton Procedure 
FUNCTION createButton RETURNS HANDLE
  (              phFrame      AS HANDLE,
    INPUT-OUTPUT piXY         AS INTEGER, 
                 pcName       AS CHARACTER,
                 pcLabel      AS CHARACTER,
                 pcTooltip    AS CHARACTER,
                 pcImage      AS CHARACTER,  
                 plSensitive  AS LOGICAL  ) :
/*------------------------------------------------------------------------------
  Purpose: Create a button 
Parameters: 
  INPUT          phParent    - handle    - parent frame
  INPUT-OUTPUT   piX         - integer   - in X position - out X + height-p 
  INPUT          pcName      - character - the name of the button
  INPUT          pcLabel     - character - the label
  INPUT          pcCaption   - character - the tooltip of the button  
  INPUT          pcBitmap    - character - the bitmap of the button  
  INPUT          plSensitive - logical   - Yes if the button should be sensitive 
    Notes:  Creates a persistent trigger ON CHOOSE that runs onChoose(pcName).  
------------------------------------------------------------------------------*/

DEFINE VARIABLE hTmp              AS HANDLE NO-UNDO.

DEFINE VARIABLE iTextWidthPxl         AS INTEGER    NO-UNDO.
DEFINE VARIABLE iToolSpacingPxl       AS INTEGER    NO-UNDO.
DEFINE VARIABLE iToolSeparatorPxl     AS INTEGER    NO-UNDO.
DEFINE VARIABLE iToolWidthPxl         AS INTEGER    NO-UNDO.
DEFINE VARIABLE iToolHeightPxl        AS INTEGER    NO-UNDO.
DEFINE VARIABLE iToolMaxWidthPxl      AS INTEGER    NO-UNDO.
DEFINE VARIABLE iToolMarginPxl        AS INTEGER    NO-UNDO.
DEFINE VARIABLE lShowBorder           AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cUIBmode              AS CHAR       NO-UNDO.
DEFINE VARIABLE cToolbarDrawDirection AS CHARACTER  NO-UNDO.  

{get ToolSpacingPxl       iToolSpacingPxl}.
{get ToolSeparatorPxl     iToolSeparatorPxl}. 
{get ToolWidthPxl         iToolWidthPxl}.
{get ToolHeightPxl        iToolHeightPxl}.
{get ToolMarginPxl        iToolMarginPxl}.
{get ShowBorder           lShowBorder}.
{get ToolbarDrawDirection cToolbarDrawDirection}.
 
 pcImage = SEARCH( pcImage ). 
  
 /* If this is a text button, reset the width to be the width of text and if
    necessary, reset toolbar max width to width of this label */ 
 IF pcImage = ? THEN
 DO:
   /* Work out width of text  */
   iTextWidthPxl = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(pcLabel) + 6. 
   
   /* Ensure not smaller than normal button */
   IF iTextWidthPxl < iToolWidthPxl THEN 
      iTextWidthPxl = iToolWidthPxl. 
   /* set this width equal to text width */
   iToolWidthPxl = iTextWidthPxl.   
   /* get current max tool width */
   {get ToolMaxWidthPxl iToolMaxWidthPxl}.                                   
   /* and reset to this width if this width is greater */
   IF iTextWidthPxl > iToolMaxWidthPxl THEN                                   
   DO:
     iToolMaxWidthPxl = iTextWidthPxl.
     {set ToolMaxWidthPxl iToolMaxWidthPxl}.
   END.
 END. 
 
 CREATE BUTTON hTmp 
    ASSIGN NO-FOCUS = TRUE
           FRAME    = phFrame
           NAME     = pcName
           LABEL    = pcLabel
           FLAT-BUTTON   = TRUE /*GetFlatButtons()*/
           HEIGHT-PIXELS = iToolHeightPxl
           TOOLTIP       = pcTooltip
           WIDTH-PIXELS  = iToolWidthPxl
           SENSITIVE     = plSensitive
           HIDDEN        = FALSE.
  
 IF cToolbarDrawDirection BEGINS "v":U THEN
 DO:
   ASSIGN hTmp:Y         = piXY
          hTmp:X         = IF iToolMarginPxl < 2 AND lShowBorder 
                           THEN 2 
                           ELSE iToolMarginPxl
          hTmp:SENSITIVE = plSensitive 
          piXY           = piXY + iToolHeightPxl + iToolSpacingPxl
          NO-ERROR.  /* Error will be checked when frame:hidden = false in
                        initializeobject */ 
 END.
 ELSE
 DO:
   ASSIGN hTmp:X         = piXY
          hTmp:Y         = IF iToolMarginPxl < 2 AND lShowBorder 
                           THEN 2 
                           ELSE iToolMarginPxl
          hTmp:SENSITIVE = plSensitive 
          piXY           = piXY + iToolWidthPxl + iToolSpacingPxl
          NO-ERROR.  /* Error will be checked when frame:hidden = false in
                        initializeobject */ 
 END. /* horizontal */

 IF pcImage <> ? THEN
    hTmp:LOAD-IMAGE( pcImage ) NO-ERROR.

 /* No triggers or sensitive actions at design time */
 {get UIBMode cUIBMode}.
 IF cUIBMode <> "Design":U THEN
   ON CHOOSE OF hTmp 
     PERSISTENT RUN OnChoose IN TARGET-PROCEDURE (pcName).
 ELSE /* disable at design time */ 
   hTmp:SENSITIVE = FALSE.

 RETURN hTmp.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createMenuAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createMenuAction Procedure 
FUNCTION createMenuAction RETURNS HANDLE
  ( pcParent AS CHAR,
    pcAction AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Create a menu action widget
Parameters: pcParent 
              Repository     - The name of the created parent band
              Non repository - The unique action name of an already created 
                               parent
                             - Blank means that this is the top level(menu-bar)
            pcAction - action name                                        
     Notes: For non-repository objects this is called from buildMenu inside 
            a for each tMenu.  
            Repository objects calls this from constructMenuBand before the
            TT is created and createFindMenuTT finds or creates the tMenu record                           
------------------------------------------------------------------------------*/
  DEFINE BUFFER btMenu FOR tMenu.
  DEFINE BUFFER btParent FOR tMenu.
  DEFINE BUFFER btChild  FOR tMenu.
  DEFINE BUFFER btParentInstance FOR tBandInstance. 

  DEFINE VARIABLE hParent          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cType            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lChecked         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lUseRepository   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDisabledActions AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHiddenActions   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cControlType     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentMenu      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkTargetNames AS CHARACTER  NO-UNDO.

  {get HiddenActions cHiddenActions}.
  IF CAN-DO(cHiddenActions,pcAction) THEN
     RETURN ?.
   
  {get UseRepository lUseRepository}.

  IF lUseRepository THEN
  DO:
    IF {fnarg actionCategoryIsHidden pcAction} THEN
      RETURN ?.


    FIND btParentInstance WHERE btParentInstance.Band = pcParent 
                           AND   btParentInstance.hTarget = TARGET-PROCEDURE 
    NO-ERROR.  
    IF NOT AVAIL btParentInstance THEN
      RETURN ?.
     
    hParent = btParentInstance.Hdl. 

    DYNAMIC-FUNCTION ('createMenuTempTable':U IN TARGET-PROCEDURE,
                                    pcParent,
                                    pcAction).
     /* 'Rule' is not unique so find last that has been created
        (index has sequence as last component) */ 
     FIND LAST btMenu WHERE btMenu.Parent  = pcParent 
                      AND   btMenu.Name    = pcAction 
                      AND   btMenu.hTarget = TARGET-PROCEDURE NO-ERROR.

  END.
  ELSE DO:
     IF pcParent = '':U THEN
       {get menubarHandle hParent}.
     ELSE
     DO:
       FIND btParent WHERE btParent.Name    = pcParent
                     AND   btParent.hTarget = TARGET-PROCEDURE NO-ERROR.
       IF NOT AVAIL btParent THEN
         RETURN ?.
       hParent = btParent.Hdl. 
     END.
     /* 'Rule' is not unique so find last that has not been created as a 
        widget  (index has sequence as last component) */ 
     FIND LAST btMenu WHERE btMenu.Parent  = pcParent 
                      AND   btMenu.Name    = pcAction 
                      AND   btMenu.hTarget = TARGET-PROCEDURE
                      AND   btMenu.hdl     = ? NO-ERROR.
  END.

  
  /* Just sanity check, should not happen */
  IF NOT AVAIL btMenu THEN
    RETURN ?.

  IF btMenu.Link > "":U THEN
  DO:
     {get LinkTargetNames cLinkTargetNames}.
     IF NUM-ENTRIES(btMenu.Link,"-":U) > 1 
       AND ENTRY(2,btMenu.Link,"-":U) = "target":U
        AND NOT CAN-DO(cLinkTargetNames,btMenu.Link) THEN 
     DO:
       cLinkTargetNames = cLinkTargetNames
                          + (IF cLinkTargetNames = "":U THEN "":U ELSE ",":U) 
                          + btMenu.Link.
      {set LinkTargetNames cLinkTargetNames}.
     END.
  END.

   /* If UseRepository we may have find and merged with an existing handle
      in createMenuTT */  
  IF VALID-HANDLE(btMenu.Hdl) THEN
    RETURN btMenu.Hdl.
   
  {get DisabledActions cDisabledActions}.
  
  IF btMenu.Name = "RULE":U THEN
    ASSIGN
      btMenu.Hdl   = DYNAMIC-FUNCTION("createRule":U IN TARGET-PROCEDURE,
                                      hParent). 
   
  ELSE
  DO:
    cType            = {fnarg actionType btMenu.Name}.
    btMenu.Refresh   = CAN-DO("run,property":U,cType).
    btMenu.Disabled  = {fnarg actionDisabled btMenu.Name}.
    IF CAN-DO("RUN,PUBLISH,LAUNCH":U, cType) 
        /* if it don't exist it has just been added wih insertMenu,
           in that case we make it a menu-item if it has a parent.
           (the user must override onChoose to react on it) */
    OR (pcParent <> "":U AND NOT {fnarg canFindAction btMenu.name} ) THEN
    DO:
        /* We don't set enabled for PUBLISH actions, as they default to false
           but are enabled by other adm2 state changes and may already be 
           enabled at this point. */
        IF NOT btMenu.Disabled AND NOT CAN-DO(cDisabledActions,btMenu.Name) THEN
        DO:
          IF cType = "RUN":U THEN  /* CanRun checks disabled actions */
            btMenu.Sensitive = {fnarg actionCanRun btMenu.Name}.
          ELSE IF cType = "LAUNCH":U THEN
            btMenu.Sensitive = {fnarg actionCanLaunch btMenu.Name}.
          ELSE 
           /* This has really nothing to do with repository, it's just that we use a
             different default since non-repository need strict backwards compatibility
             while the use of repository makes it so easy to override this with no code
             that it makes sense to have a more sensible default. 
             NOTE: the default must match the craatetoolbarAction setting of tbutton as 
                   resetTargetActions just checks tButton to see if this is a change */
            btMenu.Sensitive = lUseRepository. 
        END.
        btMenu.Hdl = DYNAMIC-FUNCTION
                  ("createMenuItem":U IN TARGET-PROCEDURE,
                   hParent,
                   btMenu.Name,
                   DYNAMIC-FUNCTION ("actionCaption":U IN TARGET-PROCEDURE,
                                      btMenu.Name),
                   DYNAMIC-FUNCTION ("actionAccelerator":U IN TARGET-PROCEDURE,
                                      btMenu.Name),
                   btMenu.Sensitive
                  ). 
    END. /* run publish or just inserted with insertMenu() */
    ELSE IF cType = "PROPERTY":U THEN
        ASSIGN
          lChecked = {fnarg actionChecked btMenu.Name}  
          btMenu.Sensitive = (lChecked <> ?) AND NOT btMenu.Disabled                             
          btMenu.Hdl = DYNAMIC-FUNCTION
                  ("createMenuToggle":U IN TARGET-PROCEDURE,
                   hParent,
                   btMenu.Name,
                   DYNAMIC-FUNCTION ("actionCaption":U IN TARGET-PROCEDURE,
                                      btMenu.Name),
                   DYNAMIC-FUNCTION ("actionAccelerator":U IN TARGET-PROCEDURE,
                                      btMenu.Name),
                   btMenu.Sensitive)
         btMenu.Hdl:CHECKED = lChecked  = TRUE.
    ELSE IF {fnarg actionControlType pcAction} = 'Label':U THEN
    DO:
       ASSIGN
         btMenu.Sensitive = IF lUseRepository THEN TRUE
                            ELSE 
                              (CAN-FIND 
                               (FIRST btChild WHERE btChild.PARENT = btMenu.NAME
                                             AND   btChild.hTarget = TARGET-PROCEDURE)
                                OR {fnarg actionInitCode btMenu.Name} <> "":U
                               )
         btMenu.Hdl = DYNAMIC-FUNCTION
                    ("createSubMenu":U IN TARGET-PROCEDURE,
                      hParent,
                      btMenu.Name,
                      DYNAMIC-FUNCTION ("actionCaption":U IN TARGET-PROCEDURE,
                                        btMenu.Name),
                      btMenu.Sensitive). 

    END.
  END. /* else (ie: tMeny <> rule) */
 
  RETURN IF AVAIL btMenu THEN btMenu.Hdl ELSE ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createMenuBar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createMenuBar Procedure 
FUNCTION createMenuBar RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Create a menubar object on the window if it does not already exist
            and return the handle of the menu bar. 
    Notes:  No data is added 
            Repository toolbars calls this all the time because the window's 
            menu-bar is reused.
            non-repository objects does not have this capability, so they 
            only call this once from buildMenu when the parameter is blank 
            to create the menubar and uses getMenubarHandle to get the 
            existing handle.    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hMenu          AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hWindow        AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lUseRepository AS LOGICAL NO-UNDO.

  {get UseRepository lUseRepository}.
  
  {get Window hWindow}.
  IF NOT lUseRepository OR NOT VALID-HANDLE(hWindow:MENU-BAR) THEN
  DO:
    CREATE MENU hMenu
      ASSIGN
        NAME      = "MainMenu":U.     
    hWindow:MENU-BAR = hMenu.
    {set menubarHandle hMenu}. 
  END.
  ELSE hMenu = hWindow:MENU-BAR.

  RETURN hMenu.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createMenuItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createMenuItem Procedure 
FUNCTION createMenuItem /**
*   @desc  Creates a menuitem 
*   @param <code>input pihParent handle</code> handle to (sub)menu
*   @param <code>input picName character</code> Name of menuitem
*   @param <code>input picCaption character</code>  Caption 
*   @param <code>input pilSensitive logical</code>  Item sensitive or not
*   @returns handle to menuitem
*/
RETURNS HANDLE
  ( phParent     AS HANDLE,     
    pcName       AS CHARACTER, 
    pcCaption    AS CHARACTER,  
    pcAccelerator AS CHARACTER,
    plSensitive  AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Create and return a new menu-item with an on choose trigger.
Parameters: 
  INPUT          phParent    - handle    - parent frame
  INPUT          pcName      - character - the name of the button
  INPUT          pcCaption   - character - the tooltip of the button  
  INPUT          pcAccelerator - character - the action accelerator  
  INPUT          plSensitive - logical   - Yes if the item should be sensitive
 
    Notes:  Creates a persistent trigger ON CHOOSE that runs onChoose(pcName).  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTmp       AS HANDLE NO-UNDO.
  DEFINE VARIABLE cUIBMode   AS CHAR   NO-UNDO.
  
  CREATE MENU-ITEM hTmp
      ASSIGN
        LABEL       = IF pcCaption <> "":U THEN pcCaption ELSE pcName
        NAME        = pcName
        PARENT      = phParent
        SENSITIVE   = plSensitive
        ACCELERATOR = pcAccelerator.

  {get UIBMode cUIBMode}.
  IF cUIBMode <> "Design":U THEN
    ON CHOOSE OF hTmp 
      PERSISTENT RUN OnChoose IN TARGET-PROCEDURE (pcName).
  ELSE /* disable at design time */ 
    hTmp:SENSITIVE = FALSE.
  
  RETURN hTmp. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createMenuTempTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createMenuTempTable Procedure 
FUNCTION createMenuTempTable RETURNS LOGICAL PRIVATE
  (pcParent    AS CHAR,
   pcName      AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Create the temp-table for the menu.
Parameters:
         INPUT pcParent - The unique Band name of an already created parent
         INPUT pcName   - A unique name
                                 
    Notes: PRIVATE (we do not want to support this as an API, but rather 
                    create a combination of insertMenuTempTable and this one)  
------------------------------------------------------------------------------*/
  DEFINE BUFFER btMenu FOR tMenu.
  DEFINE BUFFER btBandInstance FOR tBandInstance.

  DEFINE VARIABLE iSeq             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hActionTarget    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cCaption         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE clink            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hMenu            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iMergeOrder      AS INTEGER    NO-UNDO.
  
  {get menuMergeOrder iMergeOrder}.

  FIND btBandInstance WHERE btBandInstance.Band    = pcParent 
                      AND   btBandInstance.hTarget = TARGET-PROCEDURE NO-ERROR.
  
  cCaption      = {fnarg actionCaption pcName}.
 /* hActionTarget = {fnarg actionTarget pcName}.  */
  cLink         = {fnarg actionLink pcName}.
  
  IF AVAIL btBandInstance AND cLink = '':U 
  AND pcName <> "RULE":U THEN
  DO:
    FIND FIRST btMenu WHERE btMenu.ParentHdl   = btBandInstance.hdl
                      AND   btMenu.Caption     = cCaption
                      AND   btMenu.Link        = '':U NO-ERROR.
     
    IF AVAIL btmenu THEN
    DO:
      hMenu = btMenu.hdl.
    END.
  END.
  
  FIND LAST btMenu WHERE btMenu.Parent  = pcParent 
                   AND   btMenu.hTarget = TARGET-PROCEDURE NO-ERROR.
  
  iSeq = IF AVAIL btMenu THEN btMenu.Seq + 1 ELSE 1. 
  
  IF iSeq > 1 AND VALID-HANDLE(hMenu) THEN
    hMenu = DYNAMIC-FUNCTION('moveMenu':U IN TARGET-PROCEDURE,
                                hMenu,
                                hMenu:PARENT).
    
  /* If this is this object's first menu on this Band and another object 
     already has menus here create a rule first */ 
  IF iSeq = 1 AND pcName <> 'RULE':U AND btBandInstance.hdl:TYPE <> 'MENU':U 
  AND NOT VALID-HANDLE(hMenu) THEN
  DO:
    IF CAN-FIND(FIRST btMenu WHERE btMenu.ParentHdl  = btBandInstance.hdl) THEN
    DO:
      DYNAMIC-FUNCTION ('createMenuTempTable':U IN TARGET-PROCEDURE,
                                  pcParent,
                                  'RULE':U).
      FIND LAST btMenu WHERE btMenu.Parent = pcParent 
                       AND   btMenu.Name   = 'RULE':U 
                       AND   btMenu.hTarget = TARGET-PROCEDURE.
      
      btMenu.hdl = DYNAMIC-FUNCTION("createRule":U IN TARGET-PROCEDURE,
                                    btBandInstance.hdl).       
    END.
  END.

  /* Only ONE entry of each action, except for RULE. 
     The last entry will potentially change the parent.
     The menu may also exist with "*" as parent because it was enabled/disabled
     before insert */
  IF pcName <> "RULE":U THEN
    FIND btMenu WHERE btMenu.hTarget = TARGET-PROCEDURE  
                AND   btMenu.NAME    = pcName NO-ERROR. 
  ELSE RELEASE btMenu.

  IF NOT AVAIL btMenu OR pcName = "RULE":U THEN 
  DO:
    CREATE btMenu.  
    ASSIGN 
      btMenu.hTarget   = TARGET-PROCEDURE 
      /* Caption is stored because its used to identify the Menu when merging */
      btMenu.Caption   = cCaption 
      btMenu.ParentHdl = btBandInstance.hdl
      btMenu.Name      = pcName
      btMenu.Sensitive = FALSE.
  END.
  
  ASSIGN
    btMenu.Parent     = pcParent
    btMenu.Seq        = iSeq
    btMenu.Link       = cLink
    btMenu.MergeOrder = iMergeOrder
    btMenu.hdl        = hMenu.
  
  /* return true if a btMenu was created with*/
  RETURN NOT VALID-HANDLE(hMenu).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createMenuToggle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createMenuToggle Procedure 
FUNCTION createMenuToggle /**
*   @desc  Creates a menuitem 
*   @param <code>input pihParent handle</code> handle to (sub)menu
*   @param <code>input picName character</code> Name of menuitem
*   @param <code>input picCaption character</code>  Caption 
*   @param <code>input pilSensitive logical</code>  Item sensitive or not
*   @returns handle to menuitem
*/
RETURNS HANDLE
  ( phParent      AS HANDLE,
    pcName        AS CHARACTER,
    pcCaption     AS CHARACTER,
    pcAccelerator AS CHARACTER,
    plSensitive   AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  Creates and return a new toggle menu-item with an on choose trigger.
Parameters: 
  INPUT          phParent      - handle    - parent frame
  INPUT          pcName        - character - the name of the button
  INPUT          pcCaption     - character - the tooltip of the button  
  INPUT          pcAccelerator - character - the action accelerator  
  INPUT          plSensitive   - logical   - Yes sensitive, no disabled
 
    Notes:  Creates a persistent trigger 
               ON VALUE-CHANGED that runs onValueChanged(pcName).  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTmp      AS HANDLE NO-UNDO.
  DEFINE VARIABLE cUIBmode  AS CHAR   NO-UNDO.

  CREATE MENU-ITEM hTmp
      ASSIGN
        TOGGLE-BOX  = TRUE
        LABEL       = IF pcCaption <> "":U THEN pcCaption ELSE pcName
        NAME        = pcName
        PARENT      = phParent
        SENSITIVE   = plSensitive 
        ACCELERATOR = pcAccelerator.
                                                                  
  {get UIBMode cUIBMode}.
  IF cUIBMode <> "Design":U THEN
    ON VALUE-CHANGED OF hTmp 
        PERSISTENT RUN OnValueChanged IN TARGET-PROCEDURE (pcName).
 
  ELSE /* Always disable at design time */ 
    hTmp:SENSITIVE = FALSE.

  RETURN hTmp. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createRule Procedure 
FUNCTION createRule /**
*   @desc  Creates a rule
*   @param <code>input pihParent handle</code> handle to (sub)menu
*   @returns handle to rule
*/
RETURNS HANDLE
  ( phParent AS HANDLE /* Handle of the Parent */
  ) :
/*------------------------------------------------------------------------------
  Purpose: Create and return the handle of a RULE menu-item.
Parameters:   INPUT phParent - handle - parent frame
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTmp AS HANDLE NO-UNDO.

  CREATE MENU-ITEM hTmp
    ASSIGN
      SUBTYPE = 'RULE':U
      PARENT  = phParent.

  RETURN hTmp.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createSubMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createSubMenu Procedure 
FUNCTION createSubMenu /**
*   @desc  Creates a menuitem 
*   @param <code>input pihParent handle</code> handle to (sub)menu
*   @param <code>input picName character</code> Name of menuitem
*   @param <code>input picCaption character</code>  Caption 
*   @param <code>input pilSensitive logical</code>  Item sensitive or not
*   @returns handle to menuitem
*/
RETURNS HANDLE
  ( phParent     AS HANDLE,    /* Handle of the parent */
    pcName       AS CHARACTER, /* Name of the to be created submenu */
    pcCaption    AS CHARACTER, /* Caption of the be created submenu */
    plSensitive  AS LOGICAL    /* If the submenu has to be sensitive */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Create and return a new sub-menu-item with an on menu-drop trigger.
Parameters: 
  INPUT          phParent    - handle    - parent frame
  INPUT          pcName      - character - the name of the button
  INPUT          pcCaption   - character - the tooltip of the button  
  INPUT          plSensitive - logical   - Yes if the item should be sensitive
 
    Notes:  Creates a persistent trigger ON MENU-DROP that runs 
             onMenuDrop(pcName).  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hTmp AS HANDLE NO-UNDO.

  CREATE SUB-MENU hTmp
    ASSIGN
      NAME      = pcName
      LABEL     = IF pcCaption <> "":U THEN pcCaption ELSE pcName
      PARENT    = phParent
      SENSITIVE = plSensitive
    TRIGGERS:
      ON MENU-DROP PERSISTENT RUN onMenuDrop IN TARGET-PROCEDURE (pcName).
    END TRIGGERS.
    
  RETURN hTmp.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createToolbar Procedure 
FUNCTION createToolbar RETURNS LOGICAL
  (pcActions AS CHARACTER) :
/*------------------------------------------------------------------------------
   Purpose: Create a toolbar  
Parameters: INPUT pcActions - A comma seaparted list of actions or actionGroups
                            - RULE specifies a delimiter.     
     Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i                    AS INT     NO-UNDO. 
  DEFINE VARIABLE cAction              AS CHAR    NO-UNDO.
  DEFINE VARIABLE hFrame               AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hWindow              AS HANDLE  NO-UNDO.
  DEFINE VARIABLE cChildren            AS CHAR    NO-UNDO.  
  DEFINE VARIABLE cTableIOType         AS CHAR    NO-UNDO.  
  DEFINE VARIABLE cName                AS CHAR    NO-UNDO.  
  DEFINE VARIABLE iBtn                 AS INT     NO-UNDO. 
  DEFINE VARIABLE iBegin               AS INT     NO-UNDO. 
  DEFINE VARIABLE iToolSeparatorPxl    AS INTEGER NO-UNDO.
  DEFINE VARIABLE cParent              AS CHAR    NO-UNDO .  
  DEFINE VARIABLE cActionGroups        AS CHAR    NO-UNDO.  
  DEFINE VARIABLE cAvailToolbarActions AS CHAR    NO-UNDO.  
  DEFINE VARIABLE lToolbar             AS LOG     NO-UNDO.
  DEFINE VARIABLE lRule                AS LOG     NO-UNDO.
  DEFINE VARIABLE lShowBorder          AS LOG     NO-UNDO. 
  DEFINE VARIABLE hBtn                 AS HANDLE  NO-UNDO.
  DEFINE VARIABLE dMinWidth            AS DEC     NO-UNDO. 
  DEFINE VARIABLE dMinHeight           AS DEC     NO-UNDO. 
  
  {get ShowBorder lShowBorder}.
  {get ActionGroups cActionGroups}.  
  {get AvailToolbarActions cAvailToolbarActions}.  
  {get ContainerHandle hFrame}.
  {get TableIOType cTableIoType}.
  {get Window hWindow}.
  {get Toolbar lToolbar}.
  {get ToolSeparatorPxl iToolSeparatorPxl}.   
  {get MinWidth dMinWidth}.   
 
  ASSIGN 
    iBegin     =  INT((dMinWidth * SESSION:PIXELS-PER-COLUMN))
                  + iToolSeparatorPxl
                  + (If lShowBorder THEN 2 ELSE 0)  
    lRule = TRUE.
  
  DO i = 1 TO NUM-ENTRIES(pcActions):
    cAction   = ENTRY(i,pcActions).
    
    /* Logic to avoid double RULEs if some of the groups are skipped */
    IF cAction = "RULE":U AND lRule THEN    
      NEXT.   
       
    /* We might give birth to children so do this before checking isParent */
    IF (CAN-DO(cActionGroups,cAction) OR {fnarg actionIsMenu cAction}) THEN
       {fnarg actionPublishCreate cAction}.

    /* If this is a parent we logg and check it as a group and find children */  
    IF {fnarg actionIsParent cAction} THEN 
    DO:
      IF NOT {fnarg actionIsMenu cAction} THEN
      DO:
        /* logg this as available for the Instance Property dialog */
        IF NOT CAN-DO(cAvailToolbarActions,cAction) THEN
          ASSIGN cAvailToolbarActions = 
                   cAvailToolbarActions
                   + (IF cAvailToolbarActions = "":U THEN "":U ELSE ",":U)
                   + cAction. 

         /* Skip it if not amongst the selected actionGroups */
        IF NOT lToolbar OR NOT CAN-DO(cActionGroups,cAction) THEN
          NEXT.   
      END.
      ELSE
        IF NOT lToolbar THEN NEXT.

      ASSIGN                                
        cChildren = {fnarg actionChildren cAction}
        cAction   = cChildren.
            
    END. /* if actionIsParent */                                                                      
    DO iBtn = 1 TO NUM-ENTRIES(cAction):
      cName = ENTRY(iBtn,cAction). 
   
      /* if this is not children found above logg and check the parent */
      IF cChildren = "":U THEN
      DO:
        cParent = {fnarg actionParent cAction}.
        
        IF cParent <> "":U THEN
        DO:         
          IF NOT {fnarg actionIsMenu cAction} THEN
          DO:
            /* logg the parent as available for the Instance Property dialog */      
           IF NOT CAN-DO(cAvailToolbarActions,cParent) THEN
             ASSIGN cAvailToolbarActions = 
                      cAvailToolbarActions
                      + (IF cAvailToolbarActions = "":U THEN "":U ELSE ",":U)
                      + cAction. 

           /* Skip it if the parent is not amongst the selected actionGroups */
           IF NOT CAN-DO(cActionGroups,cParent) THEN
            NEXT.   
          END.
        END. /* if cParent <> "" */  
      END.
      
      IF NOT lToolbar
      OR (cName = "UPDATE":U AND cTableIoType <> "UPDATE":U) THEN
        NEXT.
            
      IF cName = "RULE":U AND NOT lShowBorder THEN  
        ASSIGN iBegin = iBegin + iToolSeparatorPxl
               lRule  = TRUE.                                 
      
      ELSE DO: 
        hBtn = DYNAMIC-FUNCTION ("createToolbarAction":U IN TARGET-PROCEDURE,
                                 '':U, 
                                 cName,
                                 INPUT-OUTPUT iBegin).

        IF VALID-HANDLE(hBtn) THEN 
           lRule = (cName = 'RULE':U).

      END. /* else (border or button) */
    END. /* do iBtn = 1 to num-entries(cAction) */  
  END. /* do i = 1 to num-entries(pcActions) */ 
  
  /* Set the available actionsgroups for the Instance Property dialog */      
  {set AvailToolbarActions cAvailToolbarActions}.  
  
  IF lToolbar AND VALID-HANDLE(hWindow) THEN 
  DO:  
    {fn createToolbarBorder}.
      
    {get MinWidth  dMinWidth}. 
    {get MinHeight dMinHeight}. 

    RUN resizeObject IN TARGET-PROCEDURE(dMinHeight,dMinWidth).
    {fn adjustActions}.
  END. /* lToolbar and valid-handle(hWindow) */

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createToolbarAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createToolbarAction Procedure 
FUNCTION createToolbarAction RETURNS HANDLE
  (pcBand            AS CHAR, 
   pcName            AS CHAR,
   INPUT-OUTPUT piXY AS INT):
/*------------------------------------------------------------------------------
   Purpose: Create a toolbar button.  
Parameters: pcName  - Action name 
                     (the button will be created also if no Action is available
                      in the action class)
            pcBand  - Optional Band 
                      Used when created from Repository.
            io-piXY - X or Y Position depending on toolbarDrawDirection           
     Notes: Create the local temp-table record and call  
            createButton or create3dRule to create the actual widget.       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFrame                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cType                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cImagePath            AS CHAR       NO-UNDO.
  DEFINE VARIABLE cImage                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dMinWidth             AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dMinHeight            AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cToolbarDrawDirection AS CHARACTER  NO-UNDO.  
  DEFINE VARIABLE cDisabledActions      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHiddenActions        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cGroups               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cControlType          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCategory             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUseRepository        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cLinkTargetNames      AS CHARACTER  NO-UNDO.
 
  {get HiddenActions cHiddenActions}.
  
  IF CAN-DO(cHiddenActions,pcName) THEN
    RETURN ?.
  
  IF {fnarg actionCategoryIsHidden pcName} THEN
    RETURN ?.
  
  {get DisabledActions cDisabledActions}.
  {get UseRepository lUseRepository}.

  ASSIGN
   cType        = {fnarg actionType pcName}
   cControlType = {fnarg actionControlType pcName}.

  /* If no repository the 'RULE' is not found in action, and if repository is 
     used it should only have one separator and its name is 'rule', but just in 
     case someone messed up let's name it here */ 
  IF cControlType = 'Separator':U THEN 
    pcName = 'RULE':U.

  IF pcName <> 'RULE':U THEN
  DO:
    FIND FIRST tButton WHERE tButton.Name    = pcName
                       AND   tButton.hTarget = TARGET-PROCEDURE NO-ERROR.
    /* non repository object still may create buttons 
       when a message is received before initialization so check handle */
    IF AVAIL tButton AND VALID-HANDLE(tButton.hdl) THEN
      RETURN ?.
  END.

  {get ContainerHandle hFrame}.
        
  IF NOT AVAIL tButton OR pcName = "RULE":U THEN
    CREATE tButton.
  
  ASSIGN
      tButton.imageAlt = (IF {fnarg actionImageAlternateRule pcName} <> '':U
                          THEN FALSE
                          ELSE ?)
      tButton.Link     = {fnarg actionLink pcName} 
      tButton.Name     = pcName
      tbutton.Band     = pcBand
      tButton.hTarget  = TARGET-PROCEDURE
      tButton.Position = piXY.
  
  IF pcName = "RULE":U THEN
    ASSIGN
      tButton.Hdl = DYNAMIC-FUNCTION("create3DRule":U IN TARGET-PROCEDURE,
                                      hFrame,
                                      INPUT-OUTPUT piXY).
                                      
  ELSE DO:
    tButton.Disabled = {fnarg actionDisabled tButton.Name}.
                        
    IF NOT tButton.Disabled AND NOT CAN-DO(cDisabledActions,pcName) THEN
    DO:
      IF cType = "RUN":U THEN
      DO:
        tButton.Sensitive = {fnarg actionCanRun tButton.Name}.
      END.
      ELSE
      IF cType = "LAUNCH":U THEN
        tButton.Sensitive = {fnarg actionCanLaunch tButton.Name}.
      ELSE 
          /* This has really nothing to do with repository, it's just that we use a
             different default since non-repository need strict backwards compatibility
             while the use of repository makes it so easy to override this with no code
             that it makes sense to have a more sensible default. */
        tButton.Sensitive = lUseRepository.
    END.
    
    tButton.Hdl = DYNAMIC-FUNCTION ("createButton":U IN TARGET-PROCEDURE,
                        hFrame,
                        INPUT-OUTPUT piXY,
                        tButton.Name,
                        {fnarg actionName tButton.Name},
                        {fnarg actionTooltip tButton.Name},
                        DYNAMIC-FUNCTION('imageName':U IN TARGET-PROCEDURE,
                                          tButton.Name,1),
                       tButton.Sensitive).
       
  END. /* else do (ie: pcNname <> "RULE")*/ 
  
  IF VALID-HANDLE(tButton.Hdl) THEN 
  DO:
    {get MinWidth  dMinWidth}. 
    {get MinHeight dMinHeight}. 
    ASSIGN 
      dMinWidth  = MAX(dMinWidth,
                              tButton.Hdl:COL + tButton.Hdl:WIDTH - 1)
      dMinHeight = MAX(dMinHeight,
                              tButton.Hdl:ROW + tButton.Hdl:HEIGHT - 1).
    {set MinWidth  dMinWidth}. 
    {set MinHeight dMinHeight}. 
  END.

    /* Add Target link to LinkTargetNames property */
  IF tButton.Link > "":U THEN
  DO:
     {get LinkTargetNames cLinkTargetNames}.
     IF NUM-ENTRIES(tButton.Link,"-":U) > 1 
       AND ENTRY(2,tButton.Link,"-":U) = "target":U
        AND NOT CAN-DO(cLinkTargetNames,tButton.Link) THEN 
     DO:
       cLinkTargetNames = cLinkTargetNames + (IF cLinkTargetNames = "" THEN "" ELSE ",") + tButton.Link.
      {set LinkTargetNames cLinkTargetNames}.
     END.
  END.


  RETURN tButton.Hdl. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createToolbarBorder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createToolbarBorder Procedure 
FUNCTION createToolbarBorder RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Add the border on the toolbar  
    Notes:  
------------------------------------------------------------------------------*/   
 DEFINE VARIABLE hFrame                AS HANDLE     NO-UNDO. 
 DEFINE VARIABLE lShowBorder           AS LOG        NO-UNDO. 
 DEFINE VARIABLE lToolbarAutoSize      AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hRect                 AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hRect2                AS HANDLE     NO-UNDO.
 DEFINE VARIABLE iEdgePixels           AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iToolMarginPxl        AS INTEGER    NO-UNDO.
 DEFINE VARIABLE dMinWidth      AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE dMinHeight     AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE iToolSeparatorPxl     AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cDrawDirection        AS CHARACTER  NO-UNDO. 

 {get ContainerHandle hframe}.
 {get ShowBorder lShowBorder}.
 {get ToolbarAutosize lToolbarAutosize}.
 {get EdgePixels iEdgePixels}.
 {get ToolMarginPxl iToolMarginPxl}.
 {get ToolbarDrawDirection cDrawDirection}.
 {get MinWidth  dMinWidth}. 
 {get MinHeight dMinHeight}. 

 iEdgePixels = IF iEdgePixels = 1 THEN 1 ELSE 2.

 IF lShowBorder THEN 
 DO:
   CREATE RECTANGLE hRect
      ASSIGN
        GRAPHIC-EDGE = TRUE
        Y            = 0
        X            = 0
        FILLED       = FALSE
        EDGE-PIXELS  = iEdgePixels
        VISIBLE      = TRUE
        FRAME        = hFrame.
              
   {set BoxRectangle hRect}.
   /* If not autosize draw a border around the toolbar */
   IF NOT lToolbarAutoSize THEN
   DO:
     ASSIGN
       hRect:HEIGHT   = dMinHeight
       hRect:WIDTH    = dMinWidth
     NO-ERROR.
     /* Add Margin, but include border size in margin size */
     IF cDrawDirection BEGINS 'v':U THEN
       hRect:WIDTH-P  = hRect:WIDTH-P
                      + iToolMarginPxl NO-ERROR.
     ELSE 
       hRect:HEIGHT-P = hRect:HEIGHT-P                          
                      + iToolMarginPxl NO-ERROR.
    /* If a 'rule' is the last 'button' we keep the current size and just
       hide it with this rectangle, but otherwise we add the separator so 
       both sides are equal  */             
     FIND LAST tButton WHERE tButton.hTarget = TARGET-PROCEDURE NO-ERROR.
     IF tButton.NAME <> 'RULE' THEN 
     DO:
      {get ToolSeparatorPxl iToolSeparatorPxl}.
       IF cDrawDirection BEGINS 'v':U THEN
         hRect:HEIGHT-P = hRect:HEIGHT-P + iToolSeparatorPxl + iEdgePixels
         NO-ERROR.
       ELSE 
         hRect:WIDTH-P = hRect:WIDTH-P + iToolSeparatorPxl + iEdgePixels
         NO-ERROR.
     END.
     ASSIGN
       dMinHeight = hRect:HEIGHT
       dMinWidth  = hRect:WIDTH. 
     {set MinWidth dMinWidth}.
     {set MinHeight dMinHeight}.
   END.

   /* otherwise we draw one rectangle over and one under (or left right ) */
   ELSE 
   IF cDrawDirection BEGINS 'v':U THEN
     ASSIGN
       hRect:HEIGHT   = dMinHeight
       hRect:WIDTH-P  = 2
     NO-ERROR.
   ELSE
     ASSIGN
       hRect:HEIGHT-P = 2
       hRect:WIDTH    = dMinWidth
     NO-ERROR.

   IF lToolbarAutoSize THEN 
   DO:            
     CREATE RECTANGLE hRect2
       ASSIGN
         GRAPHIC-EDGE  = TRUE
         FILLED        = FALSE
         EDGE-PIXELS   = IF iEdgePixels = 1 THEN 1 ELSE 2
         VISIBLE       = TRUE  
         FRAME         = hFrame.

     {set BoxRectangle2 hRect2}.
     
     /*  override errors. initializeObject will give an error message
         if frame hidden =  false gives error. */
     IF cDrawDirection BEGINS 'v':U THEN
       ASSIGN
         hRect2:ROW      = 1
         hRect2:HEIGHT   = dMinHeight
         hRect2:COL      = dMinWidth + 1
         hRect2:WIDTH-P  = iEdgePixels 
         /* Add Margin, but include border size in margin size */
         hRect2:X        = hRect2:X 
                          + MAX(iToolMarginPxl,hRect2:WIDTH-P)
                          - hRect2:WIDTH-P
       NO-ERROR.
      ELSE 
        ASSIGN
          hRect2:ROW      = dMinHeight + 1
          hRect2:HEIGHT-P = iEdgePixels
          hRect2:COL      = 1
          hRect2:WIDTH    = dMinWidth
          /* Add Margin, but include border size in margin size */
          hRect2:Y        = hRect2:Y 
                            + MAX(iToolMarginPxl,hRect2:HEIGHT-P)
                            - hRect2:HEIGHT-P 

        NO-ERROR.

     ASSIGN
       dMinHeight = hRect2:ROW + hRect2:HEIGHT - 1
       dMinWidth  = hRect2:COL + hRect2:WIDTH - 1. 

     {set MinWidth dMinWidth}.
     {set MinHeight dMinHeight}.
   END.
   ELSE
     {set BoxRectangle2 ?}.
 END. /* showBorder */
 ELSE DO:
   {set BoxRectangle ?}.
   {set BoxRectangle2 ?}.
 END.
 
 RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteMenu Procedure 
FUNCTION deleteMenu RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose: Delete the dynamic menu included all menu-items and sub-menues. 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER btMenu FOR tMenu.
  DEFINE BUFFER btBandInstance FOR tBandInstance.

  DEFINE VARIABLE hMenu    AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hWindow  AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hMenuBar AS HANDLE   NO-UNDO.
  DEFINE VARIABLE cUIBMode AS CHAR     NO-UNDO.
  DEFINE VARIABLE cInfo    AS CHAR     NO-UNDO.
  DEFINE VARIABLE lOk      AS LOG      NO-UNDO.
  DEFINE VARIABLE lmenu    AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
  DEFINE VARIABLE cType      AS CHAR   NO-UNDO.

  /* Don't attempt to delete menu if toolbar is in a dialog box,
     as it may delete the menu from the parent window. */
  {get ContainerSource hContainer}.
  
  IF VALID-HANDLE(hContainer) THEN  /* not valid when selecting from palette */
    cType = DYNAMIC-FUNCTION("getContainerType":U IN hContainer).
  
  IF cType = "DIALOG-BOX":U THEN
    RETURN FALSE.
  
  {get Window hWindow}.

  IF VALID-HANDLE(hWindow) THEN
    hMenu = hWindow:MENU-BAR.  

  IF VALID-HANDLE(hMenu) THEN   
  DO:
    {get Menu lMenu}.
    {get UIBMode cUIBMode}.
    
    IF cUIBmode = "DESIGN":U THEN
    DO:
      /* Find the windows context (we could have used WINDOW ? in the next call,
         but this makes it safe if this should be called when not current) */
      RUN adeuib/_uibinfo.p
            (?,"HANDLE " + STRING(hWindow),"CONTEXT",OUTPUT cInfo). 

      RUN adeuib/_uibinfo.p
           (INT(cInfo),?,"CONTAINS MENU RETURN CONTEXT", OUTPUT cInfo).

      IF cInfo <> "":U THEN 
      DO:
        IF lMenu THEN
          MESSAGE
        "This window already has a menu that has been created with the AppBuilder." 
          SKIP
        "That menu must be deleted before the SmartToolbar menu can be created."
          SKIP
        "The SmartToolbar menu option will be turned off." 
          SKIP
          VIEW-AS ALERT-BOX INFORMATION.
        
        {set Menu FALSE}.
        RETURN FALSE.
      END. /* cInfo <> '' */
    END. /* design mode */    
  END. /* if valid-handle(hMenu) */
  
  {get MenuBarHandle hMenubar}. 
 
  FOR EACH tBandInstance WHERE tBandInstance.hTarget = TARGET-PROCEDURE:     
    IF VALID-HANDLE(tBandInstance.hdl) THEN
    DO:

      IF NOT CAN-FIND(FIRST btBandInstance
                            WHERE btBandInstance.hdl = tBandInstance.hdl
                            AND   btBandInstance.hTarget <> tBandInstance.hTarget) THEN
      DO:
        DELETE WIDGET tBandInstance.hdl.
        IF tBandInstance.Hdl = hMenubar THEN {set MenuBarHandle ?}. 
      END.
    END.

    DELETE tBandInstance.
  END. 
 
  FOR EACH tMenu WHERE tMenu.hTarget = TARGET-PROCEDURE:     
     IF VALID-HANDLE(tMenu.hdl) THEN
     DO:
       IF NOT CAN-FIND(FIRST btMenu WHERE btMenu.Hdl     = tMenu.hdl
                                     AND   btMenu.hTarget <> tMenu.hTarget) THEN
         DELETE WIDGET tmenu.hdl.
     END.
     DELETE tMenu.
  END. 


  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteToolbar Procedure 
FUNCTION deleteToolbar RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose:  Delete the dynamic toolbar and its buttons
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRect  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRect2 AS HANDLE     NO-UNDO.

  FOR EACH tButton WHERE tButton.hTarget = TARGET-PROCEDURE:     
     IF VALID-HANDLE(tButton.Hdl) THEN
        DELETE WIDGET tButton.Hdl.
     DELETE tButton.
  END. 
  {set MinWidth 0}.
  {set MinHeight 0}.

  {get BoxRectangle hRect}.
  {get BoxRectangle2 hRect2}.
  
  DELETE OBJECT hRect  NO-ERROR.
  DELETE OBJECT hRect2 NO-ERROR.

  {set BoxRectangle ?}.
  {set BoxRectangle2 ?}.
  
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getActionGroups) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getActionGroups Procedure 
FUNCTION getActionGroups RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the action groups selected in the Instance Properties.    
    Notes: Repository toolbar uses categories while non-repository objects
           uses parent actions  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cActionGroups AS CHARACTER NO-UNDO.
  {get ActionGroups cActionGroups}.
  RETURN cActionGroups.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAvailMenuActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAvailMenuActions Procedure 
FUNCTION getAvailMenuActions RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the actions that are available in this toolbar   
    Notes: The Instance Property dialog shows these and AvailToolbarActions. 
           The actions/categories that are selected will be saved as 
           ActionGroups.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAvailMenuActions AS CHARACTER NO-UNDO.
  {get AvailMenuActions cAvailMenuActions}.
  RETURN cAvailMenuActions.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAvailToolbarActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAvailToolbarActions Procedure 
FUNCTION getAvailToolbarActions RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the actions that are available in the menu of this toolbar   
    Notes: The Instance Property dialog shows these and AvailMenuActions. 
           The actions/categories that are selected will be saved as 
           ActionGroups.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAvailToolbarActions AS CHARACTER NO-UNDO.
  {get AvailToolbarActions cAvailToolbarActions}.
  RETURN cAvailToolbarActions.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAvailToolbarBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAvailToolbarBands Procedure 
FUNCTION getAvailToolbarBands RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the available toolbar bands for this toolbar master 
    Notes:  Used in the Instance Property dialog to select ToolbarBands
------------------------------------------------------------------------------*/
 DEFINE BUFFER bttToolbarBand FOR ttToolbarBand.
 DEFINE BUFFER bttBand    FOR ttBand.
 
 DEFINE VARIABLE cLogicalObject AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cBandList AS CHARACTER  NO-UNDO.

 {get LogicalObjectName cLogicalObject}.

 FOR EACH bttToolbarBand 
      WHERE bttToolbarBand.toolbar  = cLogicalObject,
      EACH bttBand 
      WHERE bttBand.Band  = bttToolbarBand.Band  
      AND  (bttBand.BandType = 'Toolbar':U 
            OR
           bttBand.BandType = 'Menu&Toolbar':U)
     BY (IF bttToolbarBand.Alignment = 'Left':U         THEN 1
         ELSE IF bttToolbarBand.Alignment = 'Center':U  THEN 2
         ELSE                                                3)
    BY bttToolbarBand.Sequence:
    IF NOT CAN-DO(cBandList,bttBand.Band) THEN
       cBandList = cBandList 
               + (IF cBandList <> '':U THEN ',':U ELSE '':U) 
               + bttBand.Band.

 END.
 RETURN cBandList.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBoxRectangle2) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBoxRectangle2 Procedure 
FUNCTION getBoxRectangle2 RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Used for bottom rectangle on toolbars with toolbarautosize true  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hValue AS HANDLE NO-UNDO.
    {get BoxRectangle2 hValue}.
    RETURN hValue.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCommitTarget Procedure 
FUNCTION getCommitTarget RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns in character format the handle(s) of this object's
            Commit-Target(s)
   Params:  none
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTarget AS CHARACTER NO-UNDO.
  {get CommitTarget cTarget}.
  RETURN cTarget.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCommitTargetEvents Procedure 
FUNCTION getCommitTargetEvents RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a comma-separated list of the events this object wants 
            to subscribe to in its CommitTarget
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get CommitTargetEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisabledActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDisabledActions Procedure 
FUNCTION getDisabledActions RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  RETURNS a comma separated list of disabled actions.
   Params:  <NONE>
    Notes: - The actions will be immediately disabled and subsequent calls 
             to enableActions will not enable them again. This makes it 
             possible to permanently disable actions independent of state 
             changes.
           - If you remove actions from the list they will be enabled the next
             time enableActions is used on them.
           - Use the modifyDisabledActions to add or remove actions. 
-----------------------------------------------------------------------------*/
 ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
        ghProp = ghProp:BUFFER-FIELD('DisabledActions':U).

 RETURN ghProp:BUFFER-VALUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEdgePixels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEdgePixels Procedure 
FUNCTION getEdgePixels RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iValue AS INTEGER NO-UNDO.
  {get EdgePixels iValue}.
  RETURN iValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFlatButtons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFlatButtons Procedure 
FUNCTION getFlatButtons RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/**
*   @desc  Get attribute
*   @return attribute value true/false
*/
/*------------------------------------------------------------------------------
  Purpose: Use flat buttons 
    Notes: NOT IN USE 
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lValue AS LOGICAL NO-UNDO.
  {get FlatButtons lValue}.
  RETURN lValue.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHiddenActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHiddenActions Procedure 
FUNCTION getHiddenActions RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  RETURNS a comma separated list of hidden actions.
   Params:  <NONE>
    Notes: - The actions will be immediately hidden or viewed.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cActions AS CHARACTER  NO-UNDO.
  &SCOPED-DEFINE xpHiddenActions
  {get HiddenActions cActions}.
  &UNDEFINE xpHiddenActions
  RETURN cActions.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHiddenMenuBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHiddenMenuBands Procedure 
FUNCTION getHiddenMenuBands RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cHiddenBands AS CHARACTER  NO-UNDO.
  {get HiddenMenuBands cHiddenBands}. 
 
  RETURN cHiddenBands.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHiddenToolbarBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHiddenToolbarBands Procedure 
FUNCTION getHiddenToolbarBands RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cHiddenBands AS CHARACTER  NO-UNDO.
  {get HiddenToolbarBands cHiddenBands}. 
 
  RETURN cHiddenBands.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getImagePath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getImagePath Procedure 
FUNCTION getImagePath RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the opsys path of the images   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cImagePath AS CHARACTER NO-UNDO.  
  {get ImagePath cImagePath}.
  RETURN cImagePath.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLinkTargetNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLinkTargetNames Procedure 
FUNCTION getLinkTargetNames RETURNS CHARACTER
 (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of the supported toolbar links. This is based on 
            either the tool's specified item-Link, or the Category the tools
            belong to.
   Params:  <none>
  Returns: CHARACTER
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cLinks AS CHARACTER NO-UNDO.
  {get LinkTargetNames cLinks}.
  RETURN cLinks.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMenu Procedure 
FUNCTION getMenu /**
*   @desc  Get attribute
*   @return attribute value true/false
*/
RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns TRUE if a menu is to be generated
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lValue AS LOGICAL NO-UNDO.
  {get Menu lValue}.
  RETURN lValue.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMenuMergeOrder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMenuMergeOrder Procedure 
FUNCTION getMenuMergeOrder RETURNS INTEGER
  (   ) :
/*------------------------------------------------------------------------------
 Purpose: Decides the order of which the menus will be merged with other 
          toolbar instances. 
 Parameters: INPUT piOrder 
     Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iOrder AS INTEGER  NO-UNDO.
  {get MenuMergeOrder iOrder}.
  RETURN iOrder.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMinHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMinHeight Procedure 
FUNCTION getMinHeight RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dHeight AS DECIMAL    NO-UNDO.
  
  &SCOPED-DEFINE xpMinHeight
  {get MinHeight dHeight}.
  &UNDEFINE xpMinHeight
  RETURN dHeight.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMinWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMinWidth Procedure 
FUNCTION getMinWidth RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dWidth AS DECIMAL    NO-UNDO.
  
  &SCOPED-DEFINE xpMinWidth
  {get MinWidth dWidth}.
  &UNDEFINE xpMinWidth
  RETURN dWidth.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNavigationTarget Procedure 
FUNCTION getNavigationTarget RETURNS CHARACTER
  (  ) :
/**
*   @desc  Get attribute
*   @return attribute value true/false
*/
/*------------------------------------------------------------------------------
  Purpose:  Returns in character format the handle(s) of this object's
            Navigation-Target(s)
   Params:  none
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTarget AS CHARACTER NO-UNDO.
  {get NavigationTarget cTarget}.
  RETURN cTarget.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNavigationTargetEvents Procedure 
FUNCTION getNavigationTargetEvents RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a comma-separated list of the events this object wants 
            to subscribe to in its NavigationTarget
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get NavigationTargetEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSecuredTokens) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSecuredTokens Procedure 
FUNCTION getSecuredTokens RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Return the list of securedtokens for the container 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRunAttribute    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSecuredTokens   AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xpSecuredTokens
  {get SecuredTokens cSecuredTokens}.
  &UNDEFINE xpSecuredTokens
  
  IF cSecuredtokens = ? THEN
  DO:
    {get ContainerSource hContainerSource}.

    IF VALID-HANDLE(hContainerSource) THEN
    DO:
      {get LogicalObjectName cObjectName hContainerSource}.
      {get RunAttribute cRunAttribute hContainerSource}.
    END.
    ELSE
      ASSIGN
        cObjectName = "":U
        cRunAttribute = "":U.

    IF VALID-HANDLE(gshSecurityManager) THEN
      /* get list of secured tokens for the container instance */
      RUN tokenSecurityCheck IN gshSecurityManager (INPUT  cObjectName,
                                                    INPUT  cRunAttribute,
                                                    OUTPUT cSecuredTokens).
    
    {set SecuredTokens cSecuredTokens}.
  END.

  RETURN cSecuredTokens.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getShowBorder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getShowBorder Procedure 
FUNCTION getShowBorder RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  True if a three-d border is to be used around the buttons 
            and as a delimiter when "RULE" is specified in createToolbar 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lShowBorder AS LOGICAL NO-UNDO.
  {get ShowBorder lShowBorder}.
  RETURN lShowBorder.
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSubModules) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSubModules Procedure 
FUNCTION getSubModules RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  NOT USED
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSubModules AS CHAR NO-UNDO.
  {get SubModules cSubModules}.
  RETURN cSubModules.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableioTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTableioTarget Procedure 
FUNCTION getTableioTarget RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns in CHARACTER form a list of the handles of the object's 
            TableIO Targets
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTarget AS CHARACTER NO-UNDO.
  {get TableIOTarget cTarget}.
  RETURN cTarget.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableioTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTableioTargetEvents Procedure 
FUNCTION getTableioTargetEvents RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a comma-separated list of the events this object wants 
            to subscribe to in its TableIO Target
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get TableIOTargetEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableIOType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTableIOType Procedure 
FUNCTION getTableIOType RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns in CHARACTER form a list of the handles of the object's 
            TableIO Targets
   Params:  <none>
    Notes: This is the same as PanelType in the update panel
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cType AS CHARACTER NO-UNDO.
  {get TableIOType cType}.
  RETURN cType.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTargetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTargetProcedure Procedure 
FUNCTION getTargetProcedure RETURNS HANDLE
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Temporary fn to return the source-procedure's target-procedure
            to a function such as colValues in an SBO who needs to know who
            the *real* caller object is.
    Notes:  
------------------------------------------------------------------------------*/

  RETURN ghTargetProcedure.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbar Procedure 
FUNCTION getToolbar /**
*   @desc  Get attribute
*   @return attribute value true/false
*/
RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return TRUE if the toolbar is to be created 
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lValue AS LOGICAL NO-UNDO.
  {get Toolbar lValue}.
  RETURN lValue.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarAutoSize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbarAutoSize Procedure 
FUNCTION getToolbarAutoSize RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns whether the toolbar should be auto-sized to the width of
            the window at run-time. 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lToolbarAutoSize AS LOGICAL NO-UNDO.
  {get ToolbarAutoSize lToolbarAutoSize}.
  RETURN lToolbarAutoSize.
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbarBands Procedure 
FUNCTION getToolbarBands RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the toolbar bands selected in the Instance Properties.    
    Notes:  NOt in use
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cToolbarBands AS CHARACTER NO-UNDO.
  {get ToolbarBands cToolbarBands}.
  RETURN cToolbarBands.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarDrawDirection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbarDrawDirection Procedure 
FUNCTION getToolbarDrawDirection RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the draw direction of the toolbar (horizontal or vertical).    
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cToolbarDrawDirection AS CHARACTER NO-UNDO.
  {get ToolbarDrawDirection cToolbarDrawDirection}.
  RETURN cToolbarDrawDirection.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarHeightPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbarHeightPxl Procedure 
FUNCTION getToolbarHeightPxl RETURNS INTEGER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Calculate the toolbar height from the three Properties
           ToolHeightPXL, ToolbarMarginPxl and ShowBorder.      
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE lShowBorder          AS LOG    NO-UNDO. 
 DEFINE VARIABLE iToolHeightPxl       AS INTEGER NO-UNDO.
 DEFINE VARIABLE iToolMarginPxl       AS INTEGER NO-UNDO.
 
 {get ToolMarginPxl iToolMarginPxl}.
 {get ToolHeightPxl iToolHeightPxl}.
 
 /* If margin is less than 2, we must make space for the border */
 IF iToolMarginPxl < 2 THEN 
 DO:
   {get ShowBorder lShowBorder}.
   IF lShowBorder THEN
      iToolMarginPxl = 2.
 END. /* if ToolMargin < 2 */

 RETURN (iToolMarginPxl * 2) + iToolHeightPxl.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarMinWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbarMinWidth Procedure 
FUNCTION getToolbarMinWidth RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose: Min width  
    Notes: Use getMinWidth - Kept for backwards compatibility  
------------------------------------------------------------------------------*/
  RETURN {fn getMinWidth}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarParentMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbarParentMenu Procedure 
FUNCTION getToolbarParentMenu RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the toolbar parent menu selected in the Instance Properties.    
   Notes: Only required if any toolbar menus need to be added under a specific
          submenu, which will also be created if it does not exist.    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cToolbarParentMenu AS CHARACTER NO-UNDO.
  {get ToolbarParentMenu cToolbarParentMenu}.
  RETURN cToolbarParentMenu.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbarTarget Procedure 
FUNCTION getToolbarTarget RETURNS CHARACTER
    ( ):
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the object's toolbar-target.
   Params:  <none>
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTarget   AS CHARACTER NO-UNDO.
  
  {get ToolbarTarget cTarget}.
  RETURN cTarget.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbarTargetEvents Procedure 
FUNCTION getToolbarTargetEvents RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the list of events to be subscribed to in the
            Toolbar-Target.  
   Params:  <none>
    Notes:             
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get ToolbarTargetEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarWidthPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbarWidthPxl Procedure 
FUNCTION getToolbarWidthPxl RETURNS INTEGER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Calculate the toolbar width from the three Properties
           ToolMaxWidthPXL, ToolbarMarginPxl and ShowBorder.      
    Notes: Used if toolbar is vertical aligned and assumes a single column.
------------------------------------------------------------------------------*/
 DEFINE VARIABLE lShowBorder          AS LOG    NO-UNDO. 
 DEFINE VARIABLE iToolWidthPxl        AS INTEGER NO-UNDO.
 DEFINE VARIABLE iToolMarginPxl       AS INTEGER NO-UNDO.
 DEFINE VARIABLE iToolMaxWidthPxl     AS INTEGER NO-UNDO.
 
 {get ToolMarginPxl   iToolMarginPxl}.
 {get ToolWidthPxl    iToolWidthPxl}.
 {get ToolMaxWidthPxl iToolMaxWidthPxl}.
 
 /* If margin is less than 2, we must make space for the border */
 IF iToolMarginPxl < 2 THEN 
 DO:
   {get ShowBorder lShowBorder}.
   IF lShowBorder THEN
      iToolMarginPxl = 2.
 END. /* if ToolMargin < 2 */

 RETURN (iToolMarginPxl * 2) + (IF iToolMaxWidthPxl > iToolWidthPxl THEN iToolMaxWidthPxl ELSE iToolWidthPxl).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolHeightPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolHeightPxl Procedure 
FUNCTION getToolHeightPxl RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iVar AS INTEGER    NO-UNDO.

  {get ToolHeightPxl iVar}. 

  RETURN iVar.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolMarginPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolMarginPxl Procedure 
FUNCTION getToolMarginPxl RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iMargin AS INTEGER    NO-UNDO.
  &SCOPED-DEFINE xpToolMarginPxl  
  {get ToolMarginPxl iMargin}. 
  &UNDEFINE xpToolMarginPxl

  RETURN iMargin.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolMaxWidthPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolMaxWidthPxl Procedure 
FUNCTION getToolMaxWidthPxl RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iVar AS INTEGER    NO-UNDO.

  {get ToolMaxWidthPxl iVar}. 

  RETURN iVar.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolSeparatorPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolSeparatorPxl Procedure 
FUNCTION getToolSeparatorPxl RETURNS INTEGER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
Purpose:  
  Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iVar AS INTEGER    NO-UNDO.

    {get ToolSeparatorPxl iVar}. 

    RETURN iVar.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolSpacingPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolSpacingPxl Procedure 
FUNCTION getToolSpacingPxl RETURNS INTEGER
    ( /* parameter-definitions */ ) :
  /*------------------------------------------------------------------------------
    Purpose:  
      Notes:  
  ------------------------------------------------------------------------------*/
    DEFINE VARIABLE iVar AS INTEGER    NO-UNDO.

    {get ToolSpacingPxl iVar}. 

    RETURN iVar.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolWidthPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolWidthPxl Procedure 
FUNCTION getToolWidthPxl RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iVar AS INTEGER    NO-UNDO.

  {get ToolWidthPxl iVar}. 

  RETURN iVar.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWindow Procedure 
FUNCTION getWindow RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return the Window handle where the toolbar is  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hContainerSource AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cUIBMode         AS CHARACTER NO-UNDO.
  
  {get ContainerHandle hContainer}.
  {get UIBMode cUIBMode}.
  
  IF cUIBmode = "":U THEN
  DO: 
    {get ContainerSource hContainerSource}.
    IF VALID-HANDLE(hContainerSource) THEN
    DO:
      {get ContainerHandle hContainer hContainerSource}.
       /* If this is not a window loop thru the parents until a window is found */
      DO WHILE VALID-HANDLE(hContainer) AND hContainer:TYPE <> "WINDOW":U:
        hContainer = hContainer:PARENT.
      END.      
      IF VALID-HANDLE(hContainer) THEN
         CURRENT-WINDOW = hContainer.
      RETURN hContainer.
    END.  
  END. 
  ELSE
  DO WHILE VALID-HANDLE(hContainer):
    
    IF hContainer:TYPE = "WINDOW":U THEN
      RETURN hContainer. 
    
    hContainer = hContainer:PARENT.
  END.  
  
  RETURN ?.     

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-imageName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION imageName Procedure 
FUNCTION imageName RETURNS CHARACTER
  ( pcAction AS CHAR,
    piNumber AS INT) :
/*------------------------------------------------------------------------------
   Purpose: Return the image name 
Parameters: pcaction - action name
            piNumber - Image number 1 or 2  
     Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cImagePath     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUseRepository AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cImage        AS CHARACTER  NO-UNDO.
  
  {get UseRepository lUseRepository}.
  
  IF NOT lUseRepository THEN
  DO:
    {get ImagePath cImagePath}.
    cImagePath = (IF cImagePath <> "":U 
                  THEN cImagePath + "/":U
                  ELSE "":U).  
  END.

  RETURN cImagePath 
         + IF piNumber = 1 
           THEN {fnarg actionImage pcAction}
           ELSE {fnarg actionImageAlternate pcAction}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-insertMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION insertMenu Procedure 
FUNCTION insertMenu RETURNS LOGICAL
  (pcParent  AS CHARACTER,
   pcActions AS CHARACTER,
   plExpand  AS LOGICAL,
   pcBefore  AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Create a set of menu-items or sub-menues under a parent menu  
            RETURNS true if ANY of the passed actions or its children
            where added to the menu.
Parameters:
  INPUT pcParent char  - The unique action name of an already inserted action.
                         Blank means that this is the top level (menu-bar)                     
  INPUT pcActions char - A comma separated list of actions or actionGroups
                         RULE specifies a delimiter.   
  INPUT plExpand log   - TRUE - actions that are parents is expanded. 
                         i.e that all the actions of the action group is added
                         as entries directly under this parent. 
                         FALSE actions that are parents is created as 
                         sub-menues and all their children is added as items
                         under it.   
  INPUT pcBefore       - The unique action name of an already inserted sibling
                         of the same parent.
                           
    Notes:  Menus are allowed based on whether their parent is allowed.
            Parent is allowed if they are in the ActionGroups or actionIsMenu
            if not actionIsMenu the action is added to the availmenuActions
            At design time this procedure needs to run even if 
            getMenu() is false add the parent to the the AvailMenuActions
            so they can be selected in the Instance Property dialog.
            We always look up the parent (Note: the actionParent is the defined
            parent not necessary the pcParent) and check if it's allowed and 
            add it to the AvailMenuActions if not actionIsMenu. 
            The function is called recursively for each action in the list 
            that isParent.
            The function prevents double RULEs from being entered. This is to 
            avoid double RULEs where menus did not have any children, this will
            will prevent double RULEs also when opassed in as parameters.    
            RULEs will be added first or last in case we are appending or 
            other calls are appending to the list. buildMenu() does the final 
            filtering to ensure that no RULE is first,last or double.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i                  AS INT    NO-UNDO. 
  DEFINE VARIABLE cAction            AS CHAR   NO-UNDO.
  DEFINE VARIABLE hMenu              AS HANDLE NO-UNDO.
  DEFINE VARIABLE hWindow            AS HANDLE NO-UNDO.
  DEFINE VARIABLE cChild             AS CHAR   NO-UNDO.
  DEFINE VARIABLE cChildren          AS CHAR   NO-UNDO.
  DEFINE VARIABLE cParent            AS CHAR   NO-UNDO.  
  DEFINE VARIABLE lParentIsMenu      AS LOG    NO-UNDO.  
  DEFINE VARIABLE cActionGroups      AS CHAR   NO-UNDO.  
  DEFINE VARIABLE cAvailMenuActions  AS CHAR   NO-UNDO.  
  DEFINE VARIABLE lRule              AS LOG    NO-UNDO. 
  DEFINE VARIABLE lMenu              AS LOG    NO-UNDO. 
  DEFINE VARIABLE lIsParent          AS LOG    NO-UNDO. 
  DEFINE VARIABLE cTableIOType       AS CHAR   NO-UNDO.
  DEFINE VARIABLE cUIBMode           AS CHAR   NO-UNDO.
  DEFINE VARIABLE lParentOK          AS LOG    NO-UNDO. 
  DEFINE VARIABLE lReturnOK          AS LOG    NO-UNDO. 
  
  {get TableIOType cTableIoType}.
  {get Menu lMenu}.  
  {get UIBMode cUIBMode}.
  
  /* No need to do this at run-time if menues is not used */
  IF NOT lMenu AND cUIBMode <> "Design":U THEN
    RETURN FALSE.
  
  {get ActionGroups cActionGroups}.

  DO i = 1 TO NUM-ENTRIES(pcActions):    
    cAction   = ENTRY(i,pcActions).
    /* Avoid double RULEs if some of the groups are skipped */
    IF cAction = "RULE":U AND lRule THEN    
      NEXT.   
    
    cParent  = {fnarg actionParent cAction}.
    
    /* If the parent is a defined action we add it to the availableGroups
       and check if it is allowed */
    IF {fnarg canFindAction cParent} THEN
    DO:
      IF {fnarg actionIsMenu cParent} THEN 
        lParentOk = TRUE.      
      ELSE 
      DO:
        lParentOk = CAN-DO(cActionGroups,cParent). 
        {get AvailMenuActions cAvailMenuActions}. 
    
        IF NOT CAN-DO(cAvailMenuActions,cParent) THEN
        DO:
          ASSIGN cAvailMenuActions = 
                  cAvailMenuActions 
                  + (IF cAvailMenuActions = "":U THEN "":U ELSE ",":U)
                  + cParent.      
          /* Set the available actionsgroups for the Instance Property dialog */      
          {set AvailMenuActions cAvailMenuActions}.  
        END. /* not in availMenu actions */
      END.
    END. /* if findAction(parent)  */
    ELSE /* Undefined parents are always inserted. */
      lParentOk = TRUE.
    
    /* Don't bother if this menu is not going to be added */
    IF (CAN-DO(cActionGroups,cAction) OR {fnarg actionIsMenu cAction}) THEN
      {fnarg actionPublishCreate cAction}.

    lIsParent = {fnarg actionIsParent cAction}.    
    
    IF lMenu AND lParentOK
    AND (cAction <> "UPDATE":U OR cTableIoType = "UPDATE":U)
    AND ((NOT lIsParent)
        OR
        (lIsParent AND 
         (CAN-DO(cActionGroups,cAction) OR {fnarg actionIsMenu cAction})  AND
         NOT plExpand)) THEN
    DO:
      DYNAMIC-FUNCTION("insertMenuTempTable":U IN TARGET-PROCEDURE, 
                        pcParent,cAction,pcBefore).        
      ASSIGN
       lReturnOK = TRUE
       lRule = (cAction = "RULE":U).
    END. /* if lmenu and parentok ...*/
    
    /* If this is a parent we need to add the children */ 
    IF lIsParent THEN
    DO:
      IF DYNAMIC-FUNCTION("insertMenu":U IN TARGET-PROCEDURE,
                           IF plExpand THEN pcParent ELSE cAction,
                           {fnarg actionChildren cAction}, 
                            NO,
                           ?)                                THEN
      DO: 
        ASSIGN
          lRule     = FALSE
          lReturnOK = TRUE.
      END. /* if insertMenu */
      
      /* This is the rare situation where the action is parent, but don't 
        have children at design-time so it did not get added in the recursive 
        call */
      IF NOT {fnarg actionIsMenu cAction} THEN
      DO:
        {get AvailMenuActions cAvailMenuActions}. 
        IF NOT CAN-DO(cAvailMenuActions,cAction) THEN
        DO:
          ASSIGN cAvailMenuActions = 
                    cAvailMenuActions 
                    + (IF cAvailMenuActions = "":U THEN "":U ELSE ",":U)
                    + cAction.      
          /* Set the available actionsgroups for the Instance Property dialog */      
          {set AvailMenuActions cAvailMenuActions}.  
        END. /* not in availMenu actions */
      END.
    END. /* if lIsParent */
  END. /* i = 1 to num-entries */
  
  RETURN lReturnOk.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-insertMenuTempTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION insertMenuTempTable Procedure 
FUNCTION insertMenuTempTable RETURNS LOGICAL PRIVATE
  (pcParent    AS CHAR,
   pcName      AS CHAR,
   pcBefore    AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Create the temp-table for the menu.
Parameters:
         INPUT pcParent - The unique action name of an already created parent
                        - Blank means that this is the top level (menu-bar)
         INPUT pcName   - A unique name
         INPUT pcBefore - The unique action name of an already created sibling
                                 
  Notes: PRIVATE (we do not want to support this as an API, but rather 
                 create a combination of createMenuTempTable and this one)  

         This is called before the menu is built in order to be able to insert 
         actions.
         Because some disable and enable actions may take place BEFORE
         initialize some tmenu record may exist with "*" as parent.  
------------------------------------------------------------------------------*/
  DEFINE BUFFER btMenu FOR tMenu.
  DEFINE VARIABLE iSeq         AS INT  NO-UNDO.
  
  FIND LAST btMenu WHERE btMenu.Parent  = pcParent 
                   AND   btMenu.hTarget = TARGET-PROCEDURE NO-ERROR.
                   
  iSeq = IF AVAIL btMenu THEN btMenu.Seq + 1 ELSE 1. 
            
  /* loop from the end to increase the sequence of everyone 
     we are supposed to be before. 
     (If before is not found we will add the entry first ) */
  DO WHILE AVAIL btMenu AND pcBefore <> ? :    
    ASSIGN
      iSeq       = btMenu.Seq
      btMenu.Seq = btMenu.Seq + 1.  
    
    IF btMenu.Name = pcBefore THEN LEAVE.
    
    FIND PREV btMenu WHERE btMenu.Parent  = pcParent 
                     AND   btMenu.hTarget = TARGET-PROCEDURE NO-ERROR. 
    
  END. /* do while avail btMenu */ 

  /* Only ONE entry of each action, except for RULE. 
     The last entry will potentially change the parent.
     The menu may also exist with "*" as parent because it was enabled/disabled
     before insert */
  IF pcName <> "RULE":U THEN
    FIND tMenu WHERE tMenu.hTarget = TARGET-PROCEDURE 
               AND   tMenu.NAME    = pcName NO-ERROR. 
  
  IF NOT AVAIL tMenu OR pcName = "RULE":U THEN 
  DO:
    CREATE tMenu.  
    ASSIGN 
      tMenu.Link      = {fnarg actionLink pcName}
      tMenu.hTarget   = TARGET-PROCEDURE
      tMenu.Name      = pcName
      tMenu.Sensitive = FALSE.
  END.
  ASSIGN
    tMenu.Parent  = pcParent
    tMenu.Seq     = iSeq.    
  
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-menuHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION menuHandle Procedure 
FUNCTION menuHandle RETURNS HANDLE PRIVATE
  (pcName AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return the handle of a menu.
PArameters: INPUT pcName - The action name of a menu.    
    Notes: PRIVATE     
------------------------------------------------------------------------------*/
  FIND tMenu WHERE tMenu.hTarget = TARGET-PROCEDURE
             AND   tMenu.Name = pcName NO-ERROR.

  IF AVAIL tMenu THEN RETURN tMenu.Hdl.
  
  RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-modifyDisabledActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION modifyDisabledActions Procedure 
FUNCTION modifyDisabledActions RETURNS LOGICAL
  ( pcMode    AS CHAR,
    pcActions AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Modify the DisabledActions property and make it possible to 
           permanently disable actions independent of state changes. 
Parameters: pcMode  
               - "ADD"    - Adds the actions to the DisabledActions.
               - "REMOVE" - Removes the actions from the DisabledActions.
            pcActions - Comma separated list of actions          
   Notes:  - ADD: The actions will be immediately disabled and subsequent calls 
             to enableActions will not enable them again.
             REMOVE: Actions that are removed from the list will be enabled 
             the next time they are called with enableActions.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDisabledActions AS CHAR NO-UNDO.
  DEFINE VARIABLE cAction          AS CHAR NO-UNDO.
  DEFINE VARIABLE iLoop            AS INT  NO-UNDO.
  DEFINE VARIABLE iNum             AS INT  NO-UNDO.
  DEFINE VARIABLE iAction          AS INT  NO-UNDO.

  {get DisabledActions cDisabledActions}.  
  DO iLoop = 1 TO NUM-ENTRIES(pcActions):
    ASSIGN
      cAction = ENTRY(iLoop,pcActions)
      iNum    = LOOKUP(cAction,cDisabledActions).
    
    IF iNum = 0 AND pcMode = 'ADD':U THEN
      cDisabledActions = cDisabledActions
                         + (IF cDisabledActions = "":U THEN "":U ELSE ",":U)
                         + cAction.

    ELSE IF iNum <> 0 AND pcMode = 'REMOVE':U THEN
                /* Add comma before and after entry to make sure we replace 
                   a complete action.
                   Add comma before and after the list to replace first,last.
                   Trim any leading or trailing commas away  */
                      
      cDisabledActions = TRIM(REPLACE(",":U + cDisabledActions + ",":U,
                                      ",":U + cAction + ",":U,","),
                              ",":U). 
  END. /* do iloop = 1 to num-entries */

  RETURN {set DisabledActions cDisabledActions}.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-moveMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION moveMenu Procedure 
FUNCTION moveMenu RETURNS HANDLE
  ( phMenu      AS HANDLE,
    phNewParent AS HANDLE) :
/*------------------------------------------------------------------------------
   Purpose: Move a menu 
 Parameter: phMenu      - menu to move.
            phNewParent - new parent
     Notes: creates a new tree and deletes the existing so make sure 
            the next-sibling is available before this is called if this is
            done in a widget-tree loop. (or use moveMenuChildren)
------------------------------------------------------------------------------*/
  DEFINE BUFFER btMenu FOR tMenu.
  DEFINE BUFFER btBandInstance FOR tBandInstance. 

  DEFINE VARIABLE hNewMenu AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRule    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cUIBmode AS CHARACTER  NO-UNDO.
  {get UIBMode cUIBMode}.

  CASE phMenu:TYPE:
    WHEN 'menu-item':U THEN
    DO:
      CREATE MENU-ITEM hNewMenu
        ASSIGN 
          SUBTYPE   = phMenu:SUBTYPE
          SENSITIVE = phMenu:SENSITIVE.
      ASSIGN 
        hNewMenu:LABEL       = phMenu:LABEL WHEN CAN-SET(hNewMenu,'LABEL':U)
        hNewMenu:ACCELERATOR = phMenu:ACCELERATOR WHEN CAN-SET(hNewMenu,'ACCELERATOR':U)
        hNewMenu:TOGGLE-BOX  = phMenu:TOGGLE-BOX WHEN CAN-QUERY(hNewMenu,'TOGGLE-BOX':U)
        hNewMenu:NAME        = phMenu:NAME WHEN phMenu:NAME <> ?
      .
      IF cUIBMode <> "Design":U AND CAN-QUERY(hNewMenu,'TOGGLE-BOX':U)  THEN
      DO:
        IF hNewMenu:TOGGLE-BOX THEN
          ON VALUE-CHANGED OF hNewMenu 
           PERSISTENT RUN OnValueChanged IN TARGET-PROCEDURE(phMenu:NAME).
        ELSE
          ON CHOOSE OF hNewMenu 
            PERSISTENT RUN OnChoose IN TARGET-PROCEDURE(phMenu:NAME).
      END.
    END.
    WHEN 'sub-menu':U THEN
    DO:
      CREATE SUB-MENU hNewMenu
       ASSIGN 
          LABEL       = phMenu:LABEL
          SENSITIVE   = phMenu:SENSITIVE 
       TRIGGERS :
         ON MENU-DROP PERSISTENT RUN onMenuDrop IN TARGET-PROCEDURE (phMenu:Name).
       END.
       ASSIGN hNewMenu:NAME  = phMenu:NAME WHEN phMenu:NAME <> ?.

       DYNAMIC-FUNCTION('moveMenuChildren':U IN TARGET-PROCEDURE,
                         phMenu,
                         hNewMenu).
    END.
  END CASE.
  

  hNewMenu:PARENT = phNewParent.
  
  FOR EACH btMenu WHERE btMenu.Hdl = phMenu:
     ASSIGN btMenu.Hdl = hNewMenu.
  END.
  FOR EACH btMenu WHERE btMenu.parentHdl = phMenu:
     ASSIGN btMenu.parentHdl  = hNewMenu.
  END.
  FOR EACH btBandInstance WHERE btBandInstance.Hdl = phMenu:
     ASSIGN btBandInstance.Hdl = hNewMenu.
  END.

  /* remove duplicate rules */
  IF phNewParent = phMenu:PARENT THEN
  DO:
    hRule = phMenu:PREV-SIBLING.
    IF VALID-HANDLE(hRule) AND hRule:TYPE = 'menu-item':U AND hRule:SUBTYPE = 'RULE' THEN
    DO:
      hRule = phMenu:NEXT-SIBLING. 
      IF VALID-HANDLE(hRule) AND hRule:TYPE = 'menu-item':U AND hRule:SUBTYPE = 'RULE' THEN
      DO:
        FOR EACH btMenu WHERE btMenu.Hdl = hRule:
          ASSIGN btMenu.Hdl = ?.
        END.
        DELETE OBJECT hRule.
      END. /* next.. if valid-handle(hRule) AND hRule:SUBTYPE = */
    END. /* prev.. if valid-handle(hRule) AND hRule:SUBTYPE = 'RULE' */
  END. /*phNewParent = phMenu:parent */

  DELETE OBJECT phMenu.
  
  RETURN hNewMenu.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-moveMenuChildren) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION moveMenuChildren Procedure 
FUNCTION moveMenuChildren RETURNS LOGICAL
  ( phOldParent AS HANDLE,
    phNewParent AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hMoveMenu AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hMenu     AS HANDLE     NO-UNDO.
  
  hMenu = phOldParent:FIRST-CHILD.
  DO WHILE VALID-HANDLE(hMenu):
    ASSIGN
      hMoveMenu = hMenu /* we must get next before we call moveMenu because 
                          it will be deleted */
      hMenu = hMenu:NEXT-SIBLING.
    DYNAMIC-FUNCTION('moveMenu':U IN TARGET-PROCEDURE,
                      hMoveMenu,
                      phNewParent).
  END.

  RETURN TRUE.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sensitizeActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION sensitizeActions Procedure 
FUNCTION sensitizeActions RETURNS LOGICAL
  (pcActions AS CHAR,
   plSensitive AS LOG) :
/*------------------------------------------------------------------------------
  Purpose: Set actions sensitive attibute 
           (The main ourpose ia to have the same logic for disableActions and
            enableActions) 
Parameters: INPUT pcActions - A comma separated list of actions to disable
                              "*" - means disable all 
            INPUT plSensitive - Logical value that specifies sensitive.                                                       
    Notes:
           Actions may be created in other procedures, but this is the only place
           that they are enabled. except that submenues are currently set to true
           when created. 
           This procedure will probably need to be public in order to call the 
           canDo function.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAction        AS CHAR    NO-UNDO.
  DEFINE VARIABLE i              AS INTEGER NO-UNDO.
  DEFINE VARIABLE cDisabled      AS CHAR   NO-UNDO.
  DEFINE VARIABLE lUseRepository AS LOGICAL    NO-UNDO.

  IF plSensitive THEN 
    {get DisabledActions cDisabled}.

  {get UseRepository lUseRepository}.

  IF pcActions = "*":U THEN 
  DO:
    FOR EACH tMenu WHERE tMenu.hTarget = TARGET-PROCEDURE
                   AND   tMenu.Disabled = FALSE
                   AND   NOT CAN-DO(cDisabled,tMenu.Name):
      IF plSensitive 
      AND {fnarg ActionType tMenu.Name} = 'RUN':U 
      AND {fnarg actionCanRun tMenu.Name} = FALSE THEN 
         NEXT.

      IF VALID-HANDLE(tMenu.Hdl) THEN 
         tMenu.Hdl:SENSITIVE = plSensitive.         
      tMenu.Sensitive = plSensitive.    
    END.
    FOR EACH tButton WHERE tButton.hTarget = TARGET-PROCEDURE
                     AND  tbutton.Disabled = FALSE
                     AND  NOT CAN-DO(cDisabled,tButton.Name):
      IF plSensitive 
      AND {fnarg ActionType tButton.Name} = 'RUN':U 
      AND {fnarg actionCanRun tButton.Name} = FALSE THEN 
         NEXT.

      IF VALID-HANDLE(tButton.Hdl) THEN 
          tButton.Hdl:SENSITIVE = plSensitive.         
    END.
  END.
  ELSE DO i = 1 TO NUM-ENTRIES(pcActions):
    cAction = ENTRY(i,pcActions).  
    
    IF plSensitive THEN 
    DO:
      IF CAN-DO(cDisabled,cAction) THEN 
        NEXT. /* -----> */
    
      IF  {fnarg actionType cAction} = 'RUN':U 
      AND {fnarg actionCanRun cAction} = FALSE THEN 
        NEXT.  /* -----> */
    END.

    FIND tMenu WHERE tMenu.Name    = cAction
               AND   tMenu.hTarget = TARGET-PROCEDURE NO-ERROR.
    IF NOT AVAIL tMenu AND NOT lUseRepository THEN 
    DO: 
      /* '*' means that the parent may be changed by this function later */ 
      DYNAMIC-FUNCTION('insertMenuTempTable':U IN TARGET-PROCEDURE,
                       "*":U,cAction,?).

    END.
    
    IF AVAIL tMenu AND tMenu.Disabled = FALSE THEN
    DO:
      IF VALID-HANDLE(tMenu.Hdl)THEN
         tMenu.Hdl:SENSITIVE = plSensitive.
      tMenu.Sensitive = plSensitive.            
    END.

    FIND tButton WHERE tButton.Name    = cAction
                 AND   tButton.hTarget = TARGET-PROCEDURE NO-ERROR.
        
    IF NOT AVAIL tButton AND NOT lUseRepository THEN 
    DO: 
      CREATE tButton.
      ASSIGN
        tButton.Name    = cAction
        tButton.hTarget = TARGET-PROCEDURE.
    END. /* if not avail */
    IF AVAIL tButton AND tButton.Disabled = FALSE THEN
    DO:
      tButton.Sensitive = plSensitive.    
      IF VALID-HANDLE(tButton.Hdl) THEN
         tButton.Hdl:SENSITIVE = plSensitive.          
    END.
  END. /* do i = 1 to num-entries(cAction) */
  
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setActionGroups) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setActionGroups Procedure 
FUNCTION setActionGroups RETURNS LOGICAL
  (pcActionGroups AS CHARACTER) :
/*------------------------------------------------------------------------------
 Purpose: Sets the action groups selected in the Instance Properties.    
Parameters: INPUT pcActionGroups - Comma separated list of actionGroups    
    Notes: Repository toolbar uses categories while non-repository objects
           uses parent actions      
----------------------------------------------------------------------------*/
  {set ActionGroups pcActionGroups}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAvailMenuActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAvailMenuActions Procedure 
FUNCTION setAvailMenuActions RETURNS LOGICAL
  (pcAvailMenuActions AS CHARACTER) :
/*------------------------------------------------------------------------------
 Purpose: Sets the actions that are available in the menu of the toolbar object   
Parameters: INPUT pcAvailMenuActions - Comma separated list of actionGroups    
    Notes:  Updated internally from insertMenu 
           The Instance Property dialog shows these and AvailToolbarActions. 
           The actions that are selected will be saved as ActionGroups. 
------------------------------------------------------------------------------*/
  {set AvailMenuActions pcAvailMenuActions}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAvailToolbarActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAvailToolbarActions Procedure 
FUNCTION setAvailToolbarActions RETURNS LOGICAL
  (pcAvailToolbarActions AS CHARACTER) :
/*------------------------------------------------------------------------------
 Purpose: Sets the actions that are available in the toolbar.   
Parameters: INPUT pcAvailToolbarActions - Comma separated list of actionGroups    
    Notes:  Updated internally from createToolbar 
           The Instance Property dialog shows these and AvailMenuActions. 
           The actions that are selected will be saved as ActionGroups. 
------------------------------------------------------------------------------*/
  {set AvailToolbarActions pcAvailToolbarActions}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBoxRectangle2) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBoxRectangle2 Procedure 
FUNCTION setBoxRectangle2 RETURNS LOGICAL
  ( hValue AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  bottom rectangle if toolbarautosize
    Notes:  
------------------------------------------------------------------------------*/

  {set BoxRectangle2 hValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCommitTarget Procedure 
FUNCTION setCommitTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the CommitTarget link value.
   Params:  pcObject AS CHARACTER -- CHARACTER string form of the procedure
               handle(s) which should be made Commit-Target(s)
    Notes:  Because the value can be a list, it should be changed using
              modifyListProperty
------------------------------------------------------------------------------*/

  {set CommitTarget pcObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCommitTargetEvents Procedure 
FUNCTION setCommitTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the list of events to subscribe to in the CommitTarget.
   Params:  pcEvents AS CHARACTER -- CHARACTER string form of the event names.
    Notes:  Because the value can be a list, it should be changed using
              modifyListProperty
------------------------------------------------------------------------------*/

  {set CommitTargetEvents pcEvents}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisabledActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDisabledActions Procedure 
FUNCTION setDisabledActions RETURNS LOGICAL
  ( pcActions AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Stores a comma separated list of disabled actions.
   Params:  pcActions AS CHARACTER -- Comma separated list of actions
    Notes: - The actions will be immediately disabled and subsequent calls 
             to enableActions will not enable them again. This makes it 
             possible to permanently disable actions independent of state 
             changes.
           - If you remove actions from the list they will be enabled the next
             time enableActions is used on them.
           - Use the modifyDisabledActions to add or remove actions. 
------------------------------------------------------------------------------*/
  /* Immediately disable the actions. */
  {fnarg disableActions pcActions}.

  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('DisabledActions':U)
         ghProp:BUFFER-VALUE = pcActions.

  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEdgePxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setEdgePxl Procedure 
FUNCTION setEdgePxl RETURNS LOGICAL
( iValue AS INTEGER ) :
/*------------------------------------------------------------------------------
Purpose:  
  Notes:  
------------------------------------------------------------------------------*/
{set EdgePxl iValue}. 
RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFlatButtons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFlatButtons Procedure 
FUNCTION setFlatButtons RETURNS LOGICAL
  ( plFlatButtons AS LOGICAL  ) :
/*------------------------------------------------------------------------------
  Purpose:  
   Params: NOT IN USE 
------------------------------------------------------------------------------*/
  {set FlatButtons plFlatButtons}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHiddenActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setHiddenActions Procedure 
FUNCTION setHiddenActions RETURNS LOGICAL
  ( pcActions AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpHiddenActions
  {set HiddenActions pcActions}.
  &UNDEFINE xpHiddenActions
  RETURN TRUE. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHiddenMenuBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setHiddenMenuBands Procedure 
FUNCTION setHiddenMenuBands RETURNS LOGICAL
  (pcHiddenBands AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: This must be set before initialization 
    Notes:  
------------------------------------------------------------------------------*/
  {set HiddenMenuBands pcHiddenBands}. 
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHiddenToolbarBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setHiddenToolbarBands Procedure 
FUNCTION setHiddenToolbarBands RETURNS LOGICAL
  (pcHiddenBands AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: This must be set before initialization 
    Notes:  
------------------------------------------------------------------------------*/
  {set HiddenToolbarBands pcHiddenBands}. 
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setImagePath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setImagePath Procedure 
FUNCTION setImagePath RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the logical value  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLinkTargetNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLinkTargetNames Procedure 
FUNCTION setLinkTargetNames RETURNS LOGICAL
  ( pcLinkList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Modifies the list of the supported toolbar links. This is based on 
            either the tool's specified item-Link, or the Category the tools
            belong to.
   Params:  pcLinkList AS CHARACTER -- comma-separated list of links.
  Returns:  LOGICAL (true)
    Notes:  Because this is a comma-separated list, it should normally be
            invoked indirectly, through modifyListProperty.
------------------------------------------------------------------------------*/

   {set LinkTargetNames pcLinkList}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setMenu Procedure 
FUNCTION setMenu RETURNS LOGICAL
  ( plMenu AS LOGICAL  ) :
/*------------------------------------------------------------------------------
   Purpose:  set to TRUE if a menu is to be generated
Parameters: INPUT plMenu - log     
     Notes:
------------------------------------------------------------------------------*/
  {set Menu plMenu}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMenuMergeOrder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setMenuMergeOrder Procedure 
FUNCTION setMenuMergeOrder RETURNS LOGICAL
  ( piOrder AS INT ) :
/*------------------------------------------------------------------------------
 Purpose: Decides the order of which the menus will be merged with other 
          toolbar instances. 
 Parameters: INPUT piOrder 
     Notes:
------------------------------------------------------------------------------*/
  {set MenuMergeOrder piOrder}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNavigationTarget Procedure 
FUNCTION setNavigationTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the NavigationTarget link value.
   Params:  pcObject AS CHARACTER -- CHARACTER string form of the procedure
               handle(s) which should be made Navigation-Target(s)
    Notes:  Because the value can be a list, it should be changed using
              modifyListProperty
------------------------------------------------------------------------------*/

  {set NavigationTarget pcObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNavigationTargetEvents Procedure 
FUNCTION setNavigationTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the list of events to subscribe to in the NavigationTarget.
   Params:  pcEvents AS CHARACTER -- CHARACTER string form of the event names.
    Notes:  Because the value can be a list, it should be changed using
              modifyListProperty
------------------------------------------------------------------------------*/

  {set NavigationTargetEvents pcEvents}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSecuredTokens) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSecuredTokens Procedure 
FUNCTION setSecuredTokens RETURNS LOGICAL
  ( pcSecuredTokens AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Set the list of securedtokens (from the container really) 
    Notes:  SET from getSecuredTokens the first time (when the value is ?)
------------------------------------------------------------------------------*/   
  &SCOPED-DEFINE xpSecuredTokens
  {set SecuredTokens pcSecuredTokens}.
  &UNDEFINE xpSecuredTokens
  
  RETURN TRUE. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setShowBorder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setShowBorder Procedure 
FUNCTION setShowBorder RETURNS LOGICAL
  ( plShowBorder AS LOGICAL  ) :
/*------------------------------------------------------------------------------
 Purpose: set to True if a three-d border is to be used around the buttons 
          and as a delimiter when "RULE" is specified in createToolbar
 Parameters: INPUT plShowBorder - logical  
     Notes:
------------------------------------------------------------------------------*/
  {set ShowBorder plShowBorder}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSubModules) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSubModules Procedure 
FUNCTION setSubModules RETURNS LOGICAL
  ( pcSubModules AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the SubModules.
   Params:   
    Notes:  NOT IN USE ()  
------------------------------------------------------------------------------*/

  {set SubModules pcSubModules}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTableIOButtons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTableIOButtons Procedure 
FUNCTION setTableIOButtons RETURNS LOGICAL
  ( pcState AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Convert a tableio recordState to setButton parameter   
  pcState: State received from QueryPosition or tableioTarget's RecordState
    Notes: Not actively used anymore  
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE cPanelState AS CHARACTER  NO-UNDO.

  CASE pcState:        
     WHEN 'FirstRecord':U OR /* All these amount to RecordAvailable update*/
     WHEN 'LastRecord':U OR
     WHEN 'NotFirstOrLast':U OR
     WHEN 'OnlyRecord':U OR
     WHEN 'RecordAvailable':U THEN
           cPanelState = 'initial-tableio':U.
     WHEN 'NoRecordAvailable':U THEN
          cPanelState = 'add-only':U.
     WHEN 'NoRecordAvailableExt':U THEN
          cPanelState = 'disable-tableio':U.
  END CASE.  /* pcState */
  
  /* If we found a case for the state, reset it. */
  IF cPanelState NE "":U THEN 
    RUN setButtons IN TARGET-PROCEDURE(cPanelState). 
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTableIOTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTableIOTarget Procedure 
FUNCTION setTableIOTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the TableIOTarget link value.
   Params:  pcObject AS CHARACTER -- handle or handles of object(s) which
              should be made TableIOTargets of the current object.1
    Notes:  Because this value can be a list, it should be changed using
              modifyListProperty
------------------------------------------------------------------------------*/

  {set TableIOTarget pcObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTableIOTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTableIOTargetEvents Procedure 
FUNCTION setTableIOTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the list of events to subscribe to in the TableIOTarget.
   Params:  pcEvents AS CHARACTER -- CHARACTER string form of the event names.
    Notes:  Because the value can be a list, it should be changed using
              modifyListProperty
------------------------------------------------------------------------------*/

  {set TableIOTargetEvents pcEvents}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTableioType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTableioType Procedure 
FUNCTION setTableioType RETURNS LOGICAL
  ( pcType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the TableIOType link value.
   Params:  pcObject AS CHARACTER --  "Save" or "Update" 
    Notes: This is the same as PanelType in the update panel
------------------------------------------------------------------------------*/
  {set TableIOType pcType}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolbar Procedure 
FUNCTION setToolbar RETURNS LOGICAL
  ( plToolbar AS LOGICAL  ) :
/*------------------------------------------------------------------------------
   Purpose: set to TRUE if the toolbar is to be created  
Parameters: INPUT plToolbar - logical  
     Notes:
------------------------------------------------------------------------------*/
  {set Toolbar plToolbar}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarAutosize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolbarAutosize Procedure 
FUNCTION setToolbarAutosize RETURNS LOGICAL
  ( plToolbarAutoSize AS LOGICAL  ) :
/*------------------------------------------------------------------------------
 Purpose: Set to True if the toolbar should be automatically sized to the full
          width of the window at run-time.
 Parameters: INPUT plToolbarAutoSize - logical  
     Notes:
------------------------------------------------------------------------------*/
  {set ToolbarAutoSize plToolbarAutoSize}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolbarBands Procedure 
FUNCTION setToolbarBands RETURNS LOGICAL
  (pcToolbarBands AS CHARACTER) :
/*------------------------------------------------------------------------------
 Purpose: Sets the toolbar bands selected in the Instance Properties.    
Parameters: INPUT pcToolbarBands - Comma separated list of Toolbar Bands    
   Notes: NOT USED    
----------------------------------------------------------------------------*/
  {set ToolbarBands pcToolbarBands}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarDrawDirection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolbarDrawDirection Procedure 
FUNCTION setToolbarDrawDirection RETURNS LOGICAL
  (pcToolbarDrawDirection AS CHARACTER) :
/*------------------------------------------------------------------------------
 Purpose: Sets the toolbar draw direction.    
Parameters: INPUT pcToolbarDrawDirection - horizontal or vertical    
   Notes:     
----------------------------------------------------------------------------*/
  {set ToolbarDrawDirection pcToolbarDrawDirection}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarMinWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolbarMinWidth Procedure 
FUNCTION setToolbarMinWidth RETURNS LOGICAL
  ( pdMinWidth AS DEC ) :
/*------------------------------------------------------------------------------
  Purpose: set min width 
    Notes: Use setMinWidth -- Kept for backwards compatibility  
------------------------------------------------------------------------------*/
  RETURN {fnarg setMinWidth pdMinWidth}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarParentMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolbarParentMenu Procedure 
FUNCTION setToolbarParentMenu RETURNS LOGICAL
  (pcToolbarParentMenu AS CHARACTER) :
/*------------------------------------------------------------------------------
 Purpose: Sets the toolbar parent menu selected in the Instance Properties.    
Parameters: INPUT pcToolbarParentMenu     
   Notes: Only required if any toolbar menus need to be added under a specific
          submenu, which will also be created if it does not exist.    
----------------------------------------------------------------------------*/
  {set ToolbarParentMenu pcToolbarParentMenu}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolbarTarget Procedure 
FUNCTION setToolbarTarget RETURNS LOGICAL
    ( pcTarget AS CHARACTER  ):
/*------------------------------------------------------------------------------
  Purpose:  Sets the handle of the object's toolbar-target. This may be a
            delimited list of handles.
   Params:   
    Notes:   
------------------------------------------------------------------------------*/
  {set ToolbarTarget pcTarget}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolbarTargetEvents Procedure 
FUNCTION setToolbarTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER  ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the list of events to be subscribed to in the
            Toolbar-target.  
   Params:  <none>
    Notes:             
------------------------------------------------------------------------------*/
  {set ToolbarTargetEvents pcEvents}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolHeightPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolHeightPxl Procedure 
FUNCTION setToolHeightPxl RETURNS LOGICAL
  ( iValue AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  {set ToolHeightPxl iValue}. 
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolMarginPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolMarginPxl Procedure 
FUNCTION setToolMarginPxl RETURNS LOGICAL
  ( iValue AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  &SCOPED-DEFINE xpToolMarginPxl  
  {set ToolMarginPxl iValue}. 
  &UNDEFINE xpToolMarginPxl
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolMaxWidthPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolMaxWidthPxl Procedure 
FUNCTION setToolMaxWidthPxl RETURNS LOGICAL
    ( iValue AS INTEGER ) :
/*------------------------------------------------------------------------------
Purpose:  
  Notes:  
------------------------------------------------------------------------------*/

    {set ToolMaxWidthPxl iValue}. 
    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolSeparatorPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolSeparatorPxl Procedure 
FUNCTION setToolSeparatorPxl RETURNS LOGICAL
    ( iValue AS INTEGER ) :
/*------------------------------------------------------------------------------
Purpose:  
  Notes:  
------------------------------------------------------------------------------*/

    {set ToolSeparatorPxl iValue}. 
    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolSpacingPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolSpacingPxl Procedure 
FUNCTION setToolSpacingPxl RETURNS LOGICAL
    ( iValue AS INTEGER ) :
/*------------------------------------------------------------------------------
Purpose:  
  Notes:  
------------------------------------------------------------------------------*/

    {set ToolSpacingPxl iValue}. 
    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolWidthPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolWidthPxl Procedure 
FUNCTION setToolWidthPxl RETURNS LOGICAL
  ( iValue AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set ToolWidthPxl iValue}. 
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-substituteActionText) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION substituteActionText Procedure 
FUNCTION substituteActionText RETURNS CHARACTER
  ( pcAction AS CHAR,
    pcText   AS CHAR ) :
/*------------------------------------------------------------------------------
    Purpose: Substitute &1 in the passed text with the substitute property.
 Parameters: pcAction - action name 
             pcText   - Text to substitute  
      Notes: Used by actionLabel, actionCaption and actionTooltip overrrides 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cProperty   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSubstitute AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hLink       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hObject     AS HANDLE     NO-UNDO.
  
  IF INDEX(pcText,'&1':U) > 0 THEN
  DO:
    ASSIGN
      cProperty = "get":U + {fnarg actionSubstituteProperty pcAction}.
      hObject = {fnarg actionTarget pcAction}. 

    IF VALID-HANDLE(hObject) THEN
      cSubstitute = DYNAMIC-FUNCTION(cProperty IN hObject) NO-ERROR.         

    /* Cannot use the substitute statement because label text typically has & */
    pcText = REPLACE(pcText,'&1':U,cSubstitute).
  END.
  RETURN pctext. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-supportedObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION supportedObjects Procedure 
FUNCTION supportedObjects RETURNS CHARACTER
  (plLoaded AS LOG) :
/*------------------------------------------------------------------------------
   Purpose: Returns a comma separated list of object names for object linked with
            supported links. Semi-colon is used to separate a potential 
            RunAtttribute  
 Parameter: plLoaded - Yes - include all objects
                       No  - only include unloaded objects                          
     Notes: The Container's runattribute   
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cObjectName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRunAttribute    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hObject          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectList      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkTargetNames AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLink            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLink            AS CHARACTER  NO-UNDO.

  {get ContainerSource hContainerSource}.

  IF VALID-HANDLE(hContainerSource) THEN
  DO:
    {get LogicalObjectName cObjectName hContainerSource}.
    {get RunAttribute cRunAttribute hContainerSource}.

    IF plLoaded OR NOT CAN-FIND(FIRST ttObjectBand 
                                WHERE ttObjectBand.ObjectName   = cObjectName 
                                AND   ttObjectBand.Runattribute = cRunAttribute) THEN

      cObjectList = cObjectName + 
                    (IF cRunattribute = '':U THEN '':U ELSE ';':U + cRunattribute).

  END.
  {get LinkTargetNames cLinkTargetNames}.
  
  DO iLink = 1 TO NUM-ENTRIES(cLinkTargetNames):
    ASSIGN 
     cLink       = ENTRY(iLink,cLinkTargetNames)
     hObject     = DYNAMIC-FUNCTION('get':U + cLink) NO-ERROR.
    IF VALID-HANDLE(hObject)
    AND (plLoaded 
         OR NOT CAN-FIND(FIRST ttObjectBand 
                                 WHERE ttObjectBand.ObjectName = cObjectName)
         ) THEN
    DO:
      {get LogicalObjectName cObjectName hContainerSource}.
      cObjectList = cObjectList 
                    + (IF cObjectList <> '':U THEN ',':U ELSE '':U)
                    + cObjectName.
    END.
  END.

  RETURN cObjectList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-targetActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION targetActions Procedure 
FUNCTION targetActions RETURNS CHARACTER
  ( pcLinkType AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the actions that applies to a specific target 
Parameter: LinkType 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER btMenu   FOR tMenu.
  DEFINE BUFFER btButton FOR tButton.
  
  DEFINE VARIABLE cLink        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cActions     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cControlType AS CHARACTER  NO-UNDO.

  IF pcLinkType <> '':U THEN  
    cLink = pcLinkType + '-target':U. 
  
  FOR EACH btButton WHERE btButton.hTarget = TARGET-PROCEDURE
                    AND   btButton.Link    = cLink:
    IF VALID-HANDLE(btButton.hdl) THEN
    DO:
      cControlType = {fnarg actionControlType btButton.Name}.
      IF cControlType = 'Action':U THEN
        cActions = cActions 
                   + (IF cActions <> '':U THEN ',':U ELSE '':U)
                   + btButton.Name.
    END.
  END.
  FOR EACH btMenu WHERE btMenu.hTarget = TARGET-PROCEDURE
                 AND   btMenu.Link     = cLink:
    
    IF NOT CAN-DO(cActions,btMenu.Name) AND VALID-HANDLE(btMenu.hdl) THEN
    DO: 
      cControlType = {fnarg actionControlType btMenu.Name}.
      IF cControlType = 'Action':U THEN
        cActions = cActions 
                 + (IF cActions <> '':U THEN ',':U ELSE '':U)
                 + btMenu.Name.     
    END.
  END.
  
  RETURN cActions. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-windowDropDownList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION windowDropDownList Procedure 
FUNCTION windowDropDownList RETURNS LOGICAL
  ( pcBand AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     (re)build drop down list of session windows
  Parameters:  input submenu to build list in
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cUIBMode AS CHARACTER NO-UNDO.  
DEFINE VARIABLE iCount   AS INTEGER   NO-UNDO.

{get UIBMode cUIBMode}.

IF cUIBMode = "Design":U THEN RETURN FALSE.

DEFINE BUFFER btMenu FOR tMenu.

DEFINE VARIABLE hContainerSource                AS HANDLE   NO-UNDO.

/* 1st zap existing window drop down list entries */
FOR EACH btMenu
   WHERE btMenu.hTarget = TARGET-PROCEDURE
     AND btMenu.PARENT = pcBand 
     AND btMenu.NAME   BEGINS pcBand + ':':U.
   IF VALID-HANDLE(btMenu.hdl) THEN
     DELETE WIDGET btMenu.hdl.
   DELETE btMenu.
END. 


{get ContainerSource hContainerSource}.

/* And build new list */
RUN WindowListMenu IN TARGET-PROCEDURE (INPUT pcBand,
                                        INPUT hContainerSource,
                                        INPUT SESSION,
                                        INPUT-OUTPUT iCount).


RETURN iCount > 0.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

