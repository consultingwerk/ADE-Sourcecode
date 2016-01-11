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

DEFINE TEMP-TABLE tMenu 
FIELD hTarget AS HANDLE
FIELD Name    AS CHAR
FIELD Hdl     AS HANDLE
FIELD Parent  AS CHAR
FIELD Seq     AS INT 
FIELD Refresh AS LOG 
FIELD Enabled AS LOG 
INDEX Name    Name hTarget
INDEX Refresh Refresh hTarget Parent 
INDEX Parent  AS PRIMARY hTarget Parent Seq.

DEFINE TEMP-TABLE tButton 
FIELD hTarget AS HANDLE
FIELD Name    AS CHAR
FIELD Hdl     AS HANDLE
FIELD Enabled AS LOG 
INDEX Target hTarget Name .

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

&IF DEFINED(EXCLUDE-actionChecked) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionChecked Procedure 
FUNCTION actionChecked RETURNS LOGICAL
  (pcAction AS CHAR)  FORWARD.

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

&IF DEFINED(EXCLUDE-buildMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildMenu Procedure 
FUNCTION buildMenu RETURNS LOGICAL
  (pcParent AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-create3DRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD create3DRule Procedure 
FUNCTION create3DRule RETURNS HANDLE
  (              phParent     AS HANDLE,     /* handle to the parent frame */
    INPUT-OUTPUT piX          AS INTEGER    /* the x - posistion */                 
  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createButton Procedure 
FUNCTION createButton RETURNS HANDLE
  (              phParent     AS HANDLE,
    INPUT-OUTPUT piX          AS INTEGER, 
                 pcName       AS CHARACTER,
                 pcLabel      AS CHARACTER,
                 pcCaption    AS CHARACTER,
                 pcBitmap     AS CHARACTER,  
                 plSensitive  AS LOGICAL  )  FORWARD.

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

&IF DEFINED(EXCLUDE-createMenuTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createMenuTable Procedure 
FUNCTION createMenuTable RETURNS LOGICAL PRIVATE
  (pcParent    AS CHAR,
   pcName      AS CHAR,
   phTarget    AS HANDLE,   
   pcBefore    AS CHAR)  FORWARD.

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

&IF DEFINED(EXCLUDE-createToolBar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createToolBar Procedure 
FUNCTION createToolBar RETURNS LOGICAL
  (pcActions AS CHARACTER)  FORWARD.

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

&IF DEFINED(EXCLUDE-disableActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD disableActions Procedure 
FUNCTION disableActions RETURNS LOGICAL
  (pcActions AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD enableActions Procedure 
FUNCTION enableActions RETURNS LOGICAL
  (pcActions AS CHAR)  FORWARD.

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

&IF DEFINED(EXCLUDE-getFlatButtons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFlatButtons Procedure 
FUNCTION getFlatButtons RETURNS LOGICAL
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

&IF DEFINED(EXCLUDE-getToolbarHeightPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarHeightPxl Procedure 
FUNCTION getToolbarHeightPxl RETURNS INTEGER
  ( )  FORWARD.

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

&IF DEFINED(EXCLUDE-sensitizeActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD sensitizeActions Procedure 
FUNCTION sensitizeActions RETURNS LOGICAL PRIVATE
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

&IF DEFINED(EXCLUDE-setFlatButtons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFlatButtons Procedure 
FUNCTION setFlatButtons RETURNS LOGICAL
  ( plFlatButtons AS LOGICAL  )  FORWARD.

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

&IF DEFINED(EXCLUDE-setMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMenu Procedure 
FUNCTION setMenu RETURNS LOGICAL
  ( plMenu AS LOGICAL  )  FORWARD.

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
         HEIGHT             = 13.1
         WIDTH              = 49.8.
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
  Purpose:     Builds all branches of submenus before the persistent trigger On MENU-DROP 
               creates them on mouse click. This will enables shortcuts (accelerators) from
               the very beginning.                                                                         
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lOK AS LOGICAL    NO-UNDO.

FOR EACH tMenu WHERE tMenu.PARENT = '':
lOK = DYNAMIC-FUNCTION('BuildMenu' IN TARGET-PROCEDURE, tMenu.NAME).
END.

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
           from the window.  
Parameters: <none> 
     Notes:
-----------------------------------------------------------------------------*/
  DEFINE VARIABLE hWindow  AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hMenu    AS HANDLE  NO-UNDO.
  
  {get Window hWindow}.
  {get menubarHandle hMenu}.

  IF VALID-HANDLE(hWindow) THEN 
  DO:
    /* Only remove if it is our own menubar */
    IF hWindow:MENUBAR = hMenu THEN 
      hWindow:MENUBAR = ?.
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
  DEFINE VARIABLE lToolBar AS LOG        NO-UNDO.
  DEFINE VARIABLE lMenu    AS LOG        NO-UNDO.
  DEFINE VARIABLE cBlank   AS CHAR       NO-UNDO.
  DEFINE VARIABLE hFrame   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWindow  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hPopupFrame  AS HANDLE NO-UNDO.
  DEFINE VARIABLE cUIBMode AS CHAR       NO-UNDO.
  DEFINE VARIABLE lInit    AS LOG        NO-UNDO.
  DEFINE VARIABLE cInfo    AS CHAR       NO-UNDO.
  DEFINE VARIABLE lHideOnInit AS LOGICAL NO-UNDO.

  {get UIBMode cUIBmode}.
  {get Menu lMenu}.

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

    /* Find the ventilator frame */
    hPopupFrame = hFrame:FIRST-CHILD.
    hPopupFrame = hPopupframe:FIRST-CHILD.
    
    {set AvailMenuActions cBlank}.
    {set AvailToolbarActions cBlank}.
  END.      

  {fn initializeMenu}.
  {fn initializeToolBar}.
  {fnarg enableActions 'Exit':U}.
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

RUN buildAllMenus IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkState Procedure 
PROCEDURE linkState :
/*------------------------------------------------------------------------------
  Purpose:     Receives messages when an object linked to this one becomes
               "active" (normally when it's viewed) or "inactive" (Hidden).
               resets panel buttons accordingly.
  Parameters:  pcState AS CHARACTER -- 'active'/'inactive'
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cQueryPos       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowObjectState AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lModified       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cNewRecord      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hCommitTarget   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hNavTarget      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hIOtarget       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lUpdate         AS LOG       NO-UNDO.
  DEFINE VARIABLE lCanNavigate    AS LOGICAL   NO-UNDO.

  CASE pcState:
    WHEN 'active':U THEN
    DO:
      RUN resetTableio IN TARGET-PROCEDURE. 
      RUN resetNavigation IN TARGET-PROCEDURE.
      
      hCommitTarget = {fnarg activeTarget 'Commit':U}. 
      IF VALID-HANDLE(hCommitTarget) THEN
      DO:
        /* Set commit buttons */
        {get RowObjectState cRowObjectState hCommitTarget}. 
        RUN rowObjectState IN TARGET-PROCEDURE (cRowObjectState). 
      END.
    END. /* when "active" */

  END CASE. /* pcState */
  
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
  
  DEFINE VARIABLE cType      AS CHAR   NO-UNDO.
  DEFINE VARIABLE cOnChoose  AS CHAR   NO-UNDO.
  DEFINE VARIABLE cCall      AS CHAR   NO-UNDO.
  DEFINE VARIABLE cObject    AS CHAR   NO-UNDO.
  DEFINE VARIABLE hObject    AS HANDLE NO-UNDO.
  DEFINE VARIABLE cParam     AS CHAR   NO-UNDO.
  DEFINE VARIABLE cParent    AS CHAR   NO-UNDO.
  DEFINE VARIABLE cSignature AS CHAR   NO-UNDO.
  DEFINE VARIABLE cDataType  AS CHAR   NO-UNDO.
  DEFINE VARIABLE i          AS INT    NO-UNDO.
  
  IF {fnarg canFindAction pcAction} THEN
  DO:
    RUN runInfo IN TARGET-PROCEDURE
       (INPUT  pcAction,
        OUTPUT cOnChoose,
        OUTPUT cParam).
    
    cType     = {fnarg actionType pcAction}.
    
    IF cType = "RUN":U THEN
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
 
  /* The logic for parameters expects only ONE entry here, but ...  */
  DO i = 1 TO NUM-ENTRIES(cOnChoose):
    cCall = ENTRY(1,cOnChoose).
    CASE cType:
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
  END. /* do i = 1 to num-entries() */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-onMenuDrop) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE onMenuDrop Procedure 
PROCEDURE onMenuDrop :
/*------------------------------------------------------------------------------
  Purpose:  Logic to execute when a mesub-mewnu is "dropped"    
  Parameters: INPUT pcAction  - The action's unique identifier.  
  Notes:    added as a persistent trigger when the sub-menu is created     
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcAction AS CHAR NO-UNDO.
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

 DEFINE VARIABLE hFrame   AS HANDLE    NO-UNDO.
 DEFINE VARIABLE cUIBMode AS CHARACTER NO-UNDO.

 {get ContainerHandle hFrame}.
 {get UIBMode cUIBMode}.
 
 /***
 IF cUIBMode = "DESIGN":U THEN
 DO:

   /* The frame has been moved */
   IF hFrame:ROW <> 1 
   OR hFrame:COL <> 1 THEN
     MESSAGE 
     "Confirm that the toolbar is to be positioned at row" hFrame:ROW 
     "and column" hFrame:COL "."
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lAnswer AS LOG.
   
   IF NOT lanswer THEN 
     ASSIGN
       hFrame:ROW = 1 
       hFrame:COL = 1.
 END. /* if DESIGN */
 ELSE    
 **/
 
 /* Keep the default 1 1  position when dropped from Appbuilder's Palette */
 IF cUIBMode <> "DESIGN":U OR LAST-EVENT:FUNCTION <> "MOUSE-SELECT-CLICK":U THEN
   ASSIGN hFrame:ROW = pdRow 
          hFrame:COL = pdCol. 
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject Procedure 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose: Overrides the size after a resizes
           The only allowed sizing is shrinking to the last button.  
  Parameters: 
           pd_height AS DECIMAL - the desired height (in rows)
           pd_width  AS DECIMAL - the desired width (in columns)
    Notes: Used internally. Calls to resizeObject are generated by the
           AppBuilder in adm-create-objects for objects which implement it.
           Having a resizeObject procedure is also the signal to the AppBuilder
           to allow the object to be resized at design time.
------------------------------------------------------------------------------*/  
 DEFINE INPUT PARAMETER pdHeight AS DECIMAL NO-UNDO.
 DEFINE INPUT PARAMETER pdWidth  AS DECIMAL NO-UNDO.
                                   
 DEFINE VARIABLE hFrame            AS HANDLE  NO-UNDO.
 DEFINE VARIABLE dToolbarMinWidth  AS DECIMAL NO-UNDO.
 DEFINE VARIABLE hRectangle        AS HANDLE  NO-UNDO.
 DEFINE VARIABLE lShowBorder       AS LOGICAL NO-UNDO.
 
 {get ContainerHandle hFrame}.
 {get BoxRectangle hRectangle}.
 {get ToolbarMinWidth dToolbarMinWidth}.

  IF VALID-HANDLE(hRectangle) THEN
    hRectangle:WIDTH = MAX(pdWidth,dToolbarMinWidth) NO-ERROR.

  hFrame:WIDTH    = MAX(pdWidth,dToolbarMinWidth) NO-ERROR.
 
  hFrame:HEIGHT-P = {fn getToolBarHeightPxl} NO-ERROR. 
 

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
 
  IF pcState = 'NoUpdates':U THEN
      RUN setButtons IN TARGET-PROCEDURE ('disable-commit':U).
  ELSE IF pcState = 'RowUpdated':U THEN
      RUN setButtons IN TARGET-PROCEDURE ('enable-commit':U).
  
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

   DEFINE VARIABLE cParent   AS CHAR   NO-UNDO.
   DEFINE VARIABLE cOnChoose AS CHAR   NO-UNDO.
 
   cOnChoose = {fnarg actionOnChoose pcAction}.
   
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
  DEFINE VARIABLE lToolBar AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hFrame   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cUIBmode AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hPopupFrame  AS HANDLE NO-UNDO.
  DEFINE VARIABLE hWindow  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hMenu    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lNoMenu  AS LOGICAL    NO-UNDO.

  {get Window hWindow}.
  {get MenubarHandle hMenu}.
  {get ContainerHandle hFrame}.
  {get Toolbar lToolbar}.
  
  /* If the toolbar is not used, just move the frame to bottom
   (keeping it hidden, caused overlapping frames to remain hidden??) */
  hFrame:HIDDEN = FALSE NO-ERROR.

  IF NOT lToolbar THEN
    hFrame:MOVE-TO-BOTTOM().
  
  {get UIBMode cUIBMode}.
  
  IF cUIBMode ='Design':U THEN
  DO:
     /* check this special designtime property in design.p that is set from 
        Appbuilder to avoid 'viewing' menus on hidden pages, because this
        will override the visible ones and hideObject will remove it.*/
    lNoMenu = DYNAMIC-FUNCTION('getDesignTimeHideMenu':U IN TARGET-PROCEDURE)
              NO-ERROR. 
    /* Find the ventilator frame */
    hPopupFrame = hFrame:FIRST-CHILD.
    hPopupFrame = hPopupframe:FIRST-CHILD.
    IF VALID-HANDLE(hPopupFrame) THEN 
      hPopupframe:MOVE-TO-TOP().

  END.
  
  IF VALID-HANDLE(hMenu) AND NOT (lNoMenu = TRUE) THEN  
    hWindow:MENUBAR = hMenu.

  {set ObjectHidden NO}.

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
    Notes: This function is called from buildMenu and createToolbar 
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
  DEFINE VARIABLE hObject AS HANDLE NO-UNDO.
  DEFINE VARIABLE cParent AS CHAR   NO-UNDO.
  DEFINE VARIABLE cLink   AS CHAR   NO-UNDO.
  
  cLink = {fnarg actionLink pcAction}.   
  
  IF clink = "":U THEN
    ASSIGN
      cParent = {fnarg actionParent pcAction}
      cLink   = {fnarg actionLink cParent}. 

  IF cLink <> "":U THEN
  DO:
    IF ENTRY(2,cLink,"-":U) = "target":U THEN
      ASSIGN
        cLink = ENTRY(1,cLink,"-":U)
        hObject = {fnarg activeTarget cLink}.
    ELSE 
      hObject = DYNAMIC-FUNCTION("get":U + REPLACE(cLink,"-":U,"":U) ).          
  END. /* if link <> "" */
  ELSE
    {get ContainerSource hObject}.
              
  RETURN hObject.

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
    FIND tMenu WHERE tMenu.Name = pcParent
                 AND   tMenu.hTarget = TARGET-PROCEDURE NO-ERROR.
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
      
      IF tMenu.Name = "RULE":U THEN
      DO:
         /* No double or First RULE */
         IF lCanAddRule THEN
           ASSIGN
             tMenu.Hdl   = DYNAMIC-FUNCTION("createRule" IN TARGET-PROCEDURE,
                                             hMenu ) 
             lCanAddRule = FALSE.
      END. /* if rule */
      ELSE
      DO:
        ASSIGN 
          cType          = {fnarg actionType tMenu.Name}
          lCanAddRule    = TRUE
          tMenu.Refresh  = CAN-DO("run,property":U,cType).
        IF CAN-DO("RUN,PUBLISH":U, cType) 
          /* if it don't exist it has just been added wih insertMenu,
             in that case we make it a menu-item if it has a parent.
             (the user must override onChoose to react on it) */
        OR (pcParent <> "":U AND NOT {fnarg canFindAction tMenu.name} ) THEN
        DO:
          /* We don't set enabled for PUBLISH actions, as they default to false
             but are enabled by other adm2 state changes and may already be 
             enabled at this point. */
          IF cType = "RUN":U THEN  /* CanRun checks disabled actions */
            tMenu.Enabled = {fnarg actionCanRun tMenu.Name}.
          ELSE IF cType <> "PUBLISH":U THEN
            tMenu.Enabled = TRUE.


          tMenu.Hdl = DYNAMIC-FUNCTION
                    ("createMenuItem":U IN TARGET-PROCEDURE,
                     hMenu,
                     tMenu.Name,
                     DYNAMIC-FUNCTION ("actionCaption":U IN TARGET-PROCEDURE,
                                        tMenu.Name),
                     DYNAMIC-FUNCTION ("actionAccelerator":U IN TARGET-PROCEDURE,
                                        tMenu.Name),
                     tMenu.Enabled
                    ). 
        END. /* run publish or just inserted with insertMenu() */
        ELSE IF cType = "PROPERTY":U THEN
          ASSIGN
            lChecked = {fnarg actionChecked tMenu.Name}  
            tMenu.Enabled = (lChecked <> ?) 
                            AND NOT CAN-DO(cDisabledActions,tMenu.Name) 
            tMenu.Hdl = DYNAMIC-FUNCTION
                    ("createMenuToggle":U IN TARGET-PROCEDURE,
                     hMenu,
                     tMenu.Name,
                     DYNAMIC-FUNCTION ("actionCaption":U IN TARGET-PROCEDURE,
                                        tMenu.Name),
                     DYNAMIC-FUNCTION ("actionAccelerator":U IN TARGET-PROCEDURE,
                                        tMenu.Name),
                     tMenu.Enabled)
            tMenu.Hdl:CHECKED = lChecked  = TRUE.
        ELSE    
          tMenu.Hdl = DYNAMIC-FUNCTION
                     ("createSubMenu":U IN TARGET-PROCEDURE,
                       hMenu,
                       tMenu.Name,
                       DYNAMIC-FUNCTION ("actionCaption":U IN TARGET-PROCEDURE,
                                          tMenu.Name),
                      (CAN-FIND(FIRST tChild WHERE tChild.PARENT  = tMenu.NAME
                                             AND   Tchild.hTarget = TARGET-PROCEDURE)
                       OR {fnarg actionInitCode tMenu.Name} <> "":U)
                     ). 
      END. /* else (ie: tMeny <> rule) */
    END. /* for each tMenu */
  END. /* if not valid handle first tmenu */
  ELSE DO:
   /* Properties and RUN are marked as refresh when created  
      in order to make them show CHECKED and or sensitive correctly 
      if changed from elsewhere or paging made them non-active/active */ 
    FOR EACH tMenu WHERE tMenu.Refresh = TRUE
                   AND   tMenu.Parent  = pcParent 
                   AND   tMenu.hTarget = TARGET-PROCEDURE:
      
      cType    = {fnarg actionType tMenu.Name}.
      IF cType = "RUN":U THEN
      DO:
        tMenu.Enabled = {fnarg actionCanRun tMenu.Name}. 
        IF VALID-HANDLE(tMenu.Hdl) THEN 
           tMenu.Hdl:SENSITIVE = tMenu.Enabled.
      END.

      ELSE IF cType = "PROPERTY":U THEN
      DO:  
        ASSIGN
         lChecked      = {fnarg actionChecked tMenu.Name}  
         tMenu.Enabled = (lChecked <> ?) 
                          AND NOT CAN-DO(cDisabledActions,tMenu.Name) .
        IF VALID-HANDLE(tMenu.Hdl) THEN 
          ASSIGN
            tMenu.Hdl:SENSITIVE = tMenu.Enabled
            tMenu.Hdl:CHECKED   = lChecked = TRUE.
      END.
    END. /* for each menu where refresh */  
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
        createMenuTable(pcParent,
                        /* add parent in order to make it identifiable */ 
                        pcParent + ":" + ENTRY(i,cMenuItems,CHR(1)),
                        TARGET-PROCEDURE,
                        ?).
        tMenu.ENABLED = TRUE.
        tMenu.Hdl = DYNAMIC-FUNCTION("createMenuItem":U IN TARGET-PROCEDURE,
                        hMenu,
                        tMenu.Name,
                        ENTRY(i + 1,cMenuItems,CHR(1)),
                        "":U,
                        tMenu.Enabled
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

&IF DEFINED(EXCLUDE-create3DRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION create3DRule Procedure 
FUNCTION create3DRule RETURNS HANDLE
  (              phParent     AS HANDLE,     /* handle to the parent frame */
    INPUT-OUTPUT piX          AS INTEGER    /* the x - posistion */                 
  ) :
/*------------------------------------------------------------------------------
  Purpose: Create a separator between toolbasr actions in the forma of a rectangle
Parameters: INPUT        phParent - Frame handle.
            INPUT-OUTPUT piX      - in X position - out used X and + height-p 
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE hTmp              AS HANDLE NO-UNDO.

DEFINE VARIABLE iToolSeparatorPxl AS INTEGER NO-UNDO.
DEFINE VARIABLE iToolWidthPxl     AS INTEGER NO-UNDO.

{get ToolSeparatorPxl iToolSeparatorPxl}. 
{get ToolWidthPxl     iToolWidthPxl}.
 
 CREATE RECTANGLE  hTmp 
    ASSIGN FRAME         = phParent
           GRAPHIC-EDGE  = TRUE
           Y             = 0
           FILLED        = FALSE
           EDGE-PIXELS   = 2
           WIDTH-PIXELS  = 2
           HEIGHT-PIXELS = phParent:HEIGHT-P
           HIDDEN        = FALSE. 
      /* piX + iToolWidthPxl > phParent:WIDTH-PIXELS */
 ASSIGN  hTmp:X  = piX + iToolSeparatorPxl NO-ERROR. 
  
  piX = hTmp:X + hTmp:WIDTH-P + iToolSeparatorPxl.
  
  RETURN hTmp.     

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createButton Procedure 
FUNCTION createButton RETURNS HANDLE
  (              phParent     AS HANDLE,
    INPUT-OUTPUT piX          AS INTEGER, 
                 pcName       AS CHARACTER,
                 pcLabel      AS CHARACTER,
                 pcCaption    AS CHARACTER,
                 pcBitmap     AS CHARACTER,  
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

DEFINE VARIABLE iToolSpacingPxl   AS INTEGER NO-UNDO.
DEFINE VARIABLE iToolSeparatorPxl AS INTEGER NO-UNDO.
DEFINE VARIABLE iToolWidthPxl     AS INTEGER NO-UNDO.
DEFINE VARIABLE iToolHeightPxl    AS INTEGER NO-UNDO.
DEFINE VARIABLE iToolMarginPxl    AS INTEGER NO-UNDO.
DEFINE VARIABLE lShowBorder       AS LOGICAL NO-UNDO.
DEFINE VARIABLE cUIBmode          AS CHAR    NO-UNDO.

{get ToolSpacingPxl   iToolSpacingPxl}.
{get ToolSeparatorPxl iToolSeparatorPxl}. 
{get ToolWidthPxl     iToolWidthPxl}.
{get ToolHeightPxl    iToolHeightPxl}.
{get ToolMarginPxl    iToolMarginPxl}.
{get ShowBorder       lShowBorder}.
   
 CREATE BUTTON hTmp 
    ASSIGN NO-FOCUS = TRUE
           FRAME    = phParent
           NAME     = pcName
           LABEL    = pcLabel
           Y        = IF iToolMarginPxl < 2 AND lShowBorder 
                      THEN 2 
                      ELSE iToolMarginPxl
           FLAT-BUTTON   = TRUE /*GetFlatButtons()*/
           HEIGHT-PIXELS = iToolHeightPxl
           TOOLTIP       = pcCaption
           HIDDEN        = FALSE.
  
 ASSIGN hTmp:X             = piX
        hTmp:WIDTH-PIXELS  = iToolWidthPxl
        hTmp:SENSITIVE     = plSensitive 
        piX                = piX + iToolWidthPxl + iToolSpacingPxl
        NO-ERROR.  /* Error will be checked when frame:hidden = false in
                      initializeobject */ 
 /* pcBitmap = SEARCH( pcBitmap ). */
 pcBitmap = SEARCH( pcBitmap ). 
  
  /*
  IF pcBitmap = ? THEN
    pcBitmap = {&xcEmptyBitmap_q}.
    */
  
 IF pcBitMap <> ? THEN
   hTmp:LOAD-IMAGE( pcBitmap ) NO-ERROR.
  
 /* No triggers or sensitive acitons at design time */
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

&IF DEFINED(EXCLUDE-createMenuBar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createMenuBar Procedure 
FUNCTION createMenuBar RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Create a menubar object on the window and return the handle. 
    Notes:  The menu will be added to the window in viewObject. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hMenu   AS HANDLE NO-UNDO.
  DEFINE VARIABLE hWindow AS HANDLE NO-UNDO.
  
  {get Window hWindow}.
  
  CREATE MENU hMenu
    ASSIGN NAME  = "MainMenu" .
  
  {set menubarHandle hMenu}.
  
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

&IF DEFINED(EXCLUDE-createMenuTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createMenuTable Procedure 
FUNCTION createMenuTable RETURNS LOGICAL PRIVATE
  (pcParent    AS CHAR,
   pcName      AS CHAR,
   phTarget    AS HANDLE,   
   pcBefore    AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Create the temp-table for the menu.
Parameters:
         INPUT pcParent - The unique action name of an already created parent
                        - Blank means that this is the top level (menu-bar)
         INPUT pcName   - A unique name
         INPUT phTarget - TARGET-PROCEDURE 
         INPUT pcBefore - The unique action name of an already created sibling
                                 
    Notes: PRIVATE 
           This is done before it is built in order to be able to insert 
           actions.
           Because some disable and enable actions may take place BEFORE
           initialize some tmenu record may exist with "*" as parent.  
------------------------------------------------------------------------------*/
  DEFINE BUFFER btMenu FOR tMenu.
  DEFINE VARIABLE iSeq         AS INT  NO-UNDO.

  FIND LAST btMenu WHERE btMenu.Parent  = pcParent 
                   AND   btMenu.hTarget = phTarget NO-ERROR.
                   
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
                     AND   btMenu.hTarget = phTarget NO-ERROR. 
    
  END. /* do while avail btMenu */ 

  /* Only ONE entry of each action, except for RULE. 
     The last entry will potentially change the parent.
     The menu may also exist with "*" as parent because it was enabled/disabled
     before insert */
  IF pcName <> "RULE":U THEN
    FIND tMenu WHERE tMenu.hTarget = phTarget 
               AND   tMenu.NAME    = pcName NO-ERROR. 
  
  IF NOT AVAIL tMenu OR pcName = "RULE":U THEN 
  DO:
    CREATE tMenu.  
    ASSIGN 
      tMenu.hTarget = phTarget
      tMenu.Name    = pcName
      tMenu.Enabled = FALSE.
  END.
  ASSIGN
    tMenu.Parent  = pcParent
    tMenu.Seq     = iSeq.    
  
  RETURN TRUE.

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

&IF DEFINED(EXCLUDE-createToolBar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createToolBar Procedure 
FUNCTION createToolBar RETURNS LOGICAL
  (pcActions AS CHARACTER) :
/*------------------------------------------------------------------------------
   Purpose: Create a toolbar  
Parameters: INPUT pcActions - A comma seaparted list of actions or actionGroups
                            - RULE specifies a delimiter.     
     Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i                    AS INT    NO-UNDO. 
  DEFINE VARIABLE cAction              AS CHAR   NO-UNDO.
  DEFINE VARIABLE hFrame               AS HANDLE NO-UNDO.
  DEFINE VARIABLE hWindow              AS HANDLE NO-UNDO.
  DEFINE VARIABLE cChildren            AS CHAR   NO-UNDO.  
  DEFINE VARIABLE cTableIOType         AS CHAR   NO-UNDO.  
  DEFINE VARIABLE cName                AS CHAR   NO-UNDO.  
  DEFINE VARIABLE iBtn                 AS INT    NO-UNDO. 
  DEFINE VARIABLE iBegin               AS INT    NO-UNDO. 
  DEFINE VARIABLE iToolSeparatorPxl    AS INTEGER NO-UNDO.
  DEFINE VARIABLE cParent              AS CHAR    NO-UNDO .  
  DEFINE VARIABLE cImagePath           AS CHAR    NO-UNDO .  
  DEFINE VARIABLE cActionGroups        AS CHAR   NO-UNDO.  
  DEFINE VARIABLE cAvailToolbarActions AS CHAR   NO-UNDO.  
  DEFINE VARIABLE lToolbar             AS LOG NO-UNDO.
  DEFINE VARIABLE lRule                AS LOG NO-UNDO.
  DEFINE VARIABLE lShowBorder          AS LOG    NO-UNDO. 
  DEFINE VARIABLE dToolbarMinWidth     AS DEC    NO-UNDO. 

  {get ShowBorder lShowBorder}.
  {get ActionGroups cActionGroups}.  
  {get AvailToolbarActions cAvailToolbarActions}.  
  {get ImagePath cImagePath}.
  {get ContainerHandle hFrame}.
  {get TableIOType cTableIoType}.
  {get Window hWindow}.
  {get Toolbar lToolbar}.
  {get ToolSeparatorPxl iToolSeparatorPxl}.   
  {get ToolbarMinWidth dToolbarMinWidth}.   

  FIND LAST tButton WHERE tButton.hTarget = TARGET-PROCEDURE NO-ERROR.
  
  ASSIGN 
    hFrame:HEIGHT-P = {fn getToolBarHeightPxl}

    cImagePath = (IF cImagePath <> "":U 
                  THEN cImagePath + "/":U
                  ELSE "":U)
                 
    iBegin     =  INT((dToolbarMinWidth * SESSION:PIXELS-PER-COLUMN))
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
        
        FIND tButton WHERE tButton.Name    = cName
                     AND   tButton.hTarget = TARGET-PROCEDURE NO-ERROR.
        
        IF NOT AVAIL tButton OR cName = "RULE":U THEN
        DO:
          CREATE tButton.
          ASSIGN
            tButton.Name    = cName
            tButton.hTarget = TARGET-PROCEDURE.
        END.
        IF cName = "RULE":U THEN
          ASSIGN
            tButton.Hdl = DYNAMIC-FUNCTION ("create3DRule":U IN TARGET-PROCEDURE,
                             hFrame,
                             INPUT-OUTPUT iBegin)
            lRule       = TRUE.                                 
        ELSE DO:             
            IF {fnarg actionType tButton.Name} = "RUN":U THEN
              tButton.Enabled = {fnarg actionCanRun tButton.Name}.

            tButton.Hdl = DYNAMIC-FUNCTION ("createButton":U IN TARGET-PROCEDURE,
                          hFrame,
                          INPUT-OUTPUT iBegin,
                          tButton.Name,
                          {fnarg actionName tButton.Name},
                          {fnarg actionCaption tButton.Name},
                          cImagePath + {fnarg actionImage tButton.Name},
                          tButton.Enabled).
       
          lRule = FALSE.                        
        END. /* else do (ie: cname <> "RULE")*/ 
        IF VALID-HANDLE(tButton.Hdl) THEN
          dToolbarMinWidth = tButton.Hdl:COL + tButton.Hdl:WIDTH - 1.
      END. /* else (border or button) */
    END. /* do iBtn = 1 to num-entries(cAction) */  
  END. /* do i = 1 to num-entries(pcActions) */
  
  /* used in resize to make sure the size fits all buttons */ 
  {set ToolbarMinWidth dToolbarMinWidth}.
  IF lToolbar AND VALID-HANDLE(hWindow) THEN 
  DO:
  
    IF {fn getUIBmode} = "DESIGN":U THEN
    DO:
      IF hFrame:WIDTH < dToolbarMinWidth THEN
      hFrame:WIDTH = hWindow:WIDTH NO-ERROR. 
    END.
    
    IF lShowBorder THEN
    DO:
      /* Create the button to delete it */
      CREATE tButton.
        ASSIGN
          tButton.Name    = "RECT"
          tButton.hTarget = TARGET-PROCEDURE.
      
      CREATE RECTANGLE tButton.hdl 
        ASSIGN 
           GRAPHIC-EDGE  = TRUE
           Y             = 0
           X             = 0
           FILLED        = FALSE
           EDGE-PIXELS   = 2
           VISIBLE       = TRUE.

       {set BoxRectangle tButton.hdl}.
       /* override errors. initializeObject will give an error message 
          if frame hidden =  false gives error. */

       ASSIGN 
         tButton.Hdl:HEIGHT-P      = hFrame:HEIGHT-P
         tButton.Hdl:WIDTH-P       = hFrame:WIDTH-P
         tButton.Hdl:FRAME         = hFrame NO-ERROR.

    END. /* iEdgePixels > 0 */
    ELSE 
      {set BoxRectangle ?}.
  END. /* lToolbar and valid-handle(hWindow) */
  
  /* Set the available actionsgroups for the Instance Property dialog */      
  {set AvailToolbarActions cAvailToolbarActions}.  
    
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
  
  IF VALID-HANDLE(hMenubar) THEN
    DELETE WIDGET hMenubar.

  FOR EACH tMenu WHERE tMenu.hTarget = TARGET-PROCEDURE:     
     IF VALID-HANDLE(tMenu.hdl) THEN
        DELETE WIDGET tmenu.hdl.
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
  FOR EACH tButton WHERE tButton.hTarget = TARGET-PROCEDURE:     
     IF VALID-HANDLE(tButton.Hdl) THEN
        DELETE WIDGET tButton.Hdl.
     DELETE tButton.
  END. 
  {set ToolbarMinWidth 0}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION disableActions Procedure 
FUNCTION disableActions RETURNS LOGICAL
  (pcActions AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Disable a list of actions 
Parameters: INPUT pcActions - A comma separated list of actions to disable
                              "*" - means disable all     
    Notes:  This function is used internally to turn actions on/off depending
            of the state.  
            Use modifyDisabledActions or setDisabledActions to override 
            enabling.             
------------------------------------------------------------------------------*/
  RETURN DYNAMIC-FUNC("sensitizeActions":U IN TARGET-PROCEDURE,pcActions,FALSE).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION enableActions Procedure 
FUNCTION enableActions RETURNS LOGICAL
  (pcActions AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Enable a list of actions 
Parameters: INPUT pcActions - A comma separated list of actions to enable
                              "*" - means enable all     
    Notes:  This function is used internally to turn actions on/off depending
            of the state.  
            Use modifyDisabledActions or setDisabledActions to override 
            enabling.             
------------------------------------------------------------------------------*/
  RETURN DYNAMIC-FUNC("sensitizeActions" IN TARGET-PROCEDURE,pcActions,TRUE).
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
    Notes:  
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
           The actions that are slected will be saved as ActionGroups.  
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
           The actions that are slected will be saved as ActionGroups.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAvailToolbarActions AS CHARACTER NO-UNDO.
  {get AvailToolbarActions cAvailToolbarActions}.
  RETURN cAvailToolbarActions.
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
      DYNAMIC-FUNCTION("createMenuTable":U IN TARGET-PROCEDURE, 
                        pcParent,cAction,TARGET-PROCEDURE,pcBefore).        
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

&IF DEFINED(EXCLUDE-sensitizeActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION sensitizeActions Procedure 
FUNCTION sensitizeActions RETURNS LOGICAL PRIVATE
  (pcActions AS CHAR,
   plSensitive AS LOG) :
/*------------------------------------------------------------------------------
  Purpose: Set actions sensitive attibute 
           (The main ourpose ia to have the same logic for disableActions and
            enableActions) 
Parameters: INPUT pcActions - A comma separated list of actions to disable
                              "*" - means disable all 
            INPUT plSensitive - Logical value that specifies sensitive.                                                       
    Notes: PRIVATE -  
           Actions may be created in other procedures, but this is the only place
           that they are enabled. except that submenues are currently set to true
           when created. 
           This procedure will probably need to be public in order to call the 
           canDo function.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAction   AS CHAR    NO-UNDO.
  DEFINE VARIABLE i         AS INTEGER NO-UNDO.
  DEFINE VARIABLE cDisabled AS CHAR   NO-UNDO.

  IF plSensitive THEN 
    {get DisabledActions cDisabled}.

  IF pcActions = "*":U THEN 
  DO:
    FOR EACH tMenu WHERE tMenu.hTarget = TARGET-PROCEDURE
                   AND   NOT CAN-DO(cDisabled,tMenu.Name):
      IF VALID-HANDLE(tMenu.Hdl) THEN 
         tMenu.Hdl:SENSITIVE = plSensitive.         
      tMenu.Enabled = plSensitive.    
    END.
    FOR EACH tButton WHERE tButton.hTarget = TARGET-PROCEDURE
                     AND   NOT CAN-DO(cDisabled,tButton.Name):
      IF VALID-HANDLE(tButton.Hdl) THEN 
          tButton.Hdl:SENSITIVE = plSensitive.         
    END.
  END.
  ELSE DO i = 1 TO NUM-ENTRIES(pcActions):
    cAction = ENTRY(i,pcActions).  
    IF plSensitive AND CAN-DO(cDisabled,cAction) THEN NEXT.

    FIND tMenu WHERE tMenu.Name    = cAction
               AND   tMenu.hTarget = TARGET-PROCEDURE NO-ERROR.
    
    IF NOT AVAIL tMenu THEN 
    DO: 
       /* '*' means that the parent may be changed by this function later */ 
      createMenuTable("*",cAction,TARGET-PROCEDURE,?).
    END.
    
    IF VALID-HANDLE(tMenu.Hdl) THEN
       tMenu.Hdl:SENSITIVE = plSensitive.
    tMenu.Enabled = plSensitive.            
    
    FIND tButton WHERE tButton.Name    = cAction
                 AND   tButton.hTarget = TARGET-PROCEDURE NO-ERROR.
        
    IF NOT AVAIL tButton THEN 
    DO: 
      CREATE tButton.
      ASSIGN
        tButton.Name    = cAction
        tButton.hTarget = TARGET-PROCEDURE.
    END. /* if not avail */
    tButton.ENABLED = plSensitive.
    
    IF VALID-HANDLE(tButton.Hdl) THEN
       tButton.Hdl:SENSITIVE = plSensitive.          
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
   Notes:     
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
   Params:  pcSubModules AS CHARACTER -- CHARACTER string form of the procedure
               handle(s) which should be made Navigation-Target(s)
    Notes:  Because the value can be a list, it should be changed using
              modifyListProperty
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
    Notes: Only called from refreshTableio  
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

