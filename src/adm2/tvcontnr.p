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
    File        : tvcontnr.p
    Purpose     : Super procedure for tvcontnr class.

    Syntax      : adm2/tvcontnr.p

    Modified    : Rewrite - July 2003 - Mark Davies (MIP)
    
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


&SCOP ADMSuper tvcontnr.p

/* Custom exclude file */
{src/adm2/custom/tvcontnrexclcustom.i}

{src/adm2/globals.i}

&SCOPED-DEFINE NUM-STRUC-COPIES 30

DEFINE VARIABLE ghLayoutManager AS HANDLE     NO-UNDO.
DEFINE VARIABLE gdTempObjNumber AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdTempObjDecNo  AS INTEGER    NO-UNDO.

/* We want to create some temp node records and we need some sort of 
   temp object number to use */
ASSIGN gdTempObjNumber = 1
       gdTempObjDecNo  = RANDOM(1,999999999).

/* The following temp-table will contain information required for the Dynamic
   TreeView, like settings and modes etc */
DEFINE TEMP-TABLE ttProp NO-UNDO
  FIELD hTargetProcedure        AS HANDLE
  FIELD cTreeLogicalObjectName  AS CHARACTER
  FIELD cTreeRunAttribute       AS CHARACTER
  FIELD lAutoSort               AS LOGICAL
  FIELD lExpand                 AS LOGICAL
  FIELD cPrimarySDOName         AS CHARACTER
  FIELD lNoMessage              AS LOGICAL
  FIELD iLockWindow             AS INTEGER
  FIELD lMenuTreeObject         AS LOGICAL
  FIELD cDataLinks              AS CHARACTER
  FIELD lInitialized            AS LOGICAL
  FIELD iRowsToBatch            AS INTEGER
  FIELD lHideOnClose            AS LOGICAL
  FIELD iMaxHiddenContainers    AS INTEGER
  /* TreeView Dimensions */
  FIELD dTreeMinWidth           AS DECIMAL
  FIELD dTreeMinHeight          AS DECIMAL
  FIELD dResizeBarCol           AS DECIMAL
  /* Node information */        
  FIELD cRootNodeCode           AS CHARACTER
  FIELD cCurrentNodeCode        AS CHARACTER
  FIELD cParentNode             AS CHARACTER
  FIELD dNewNodeObj             AS DECIMAL
  /* Mode information Add/Copy etc */
  FIELD lCancelRecord           AS LOGICAL
  FIELD lResetRecord            AS LOGICAL
  FIELD lAddCopy                AS LOGICAL
  FIELD lNewChildNode           AS LOGICAL
  FIELD lRecordDeleted          AS LOGICAL
  /* Current Frame Information */
  FIELD hCurrentFrame           AS HANDLE
  FIELD dFolderMinWidth         AS DECIMAL /* Largest frame in session's width */
  FIELD dFolderMinHeight        AS DECIMAL /* Largest frame in session's height */
  FIELD lResizeFrameNow         AS LOGICAL /* Required to indicate that we are resizing the Frame */
  FIELD cLaunchedFolderName     AS CHARACTER
  FIELD cLaunchedRunInstance    AS CHARACTER
  FIELD cLaunchedSDOName        AS CHARACTER
  FIELD iStructLevel            AS INTEGER
  /* Filter Viewer Information */
  FIELD hFilterViewer           AS HANDLE
  FIELD lFilterApplied          AS LOGICAL
  FIELD cFilterData             AS CHARACTER
  INDEX idx1                    AS PRIMARY UNIQUE hTargetProcedure.

/* This temp-table is used to store relevant information regarding the 
   SmartFrame object launched */
DEFINE TEMP-TABLE ttFrame NO-UNDO
  FIELD hTargetProcedure  AS HANDLE
  FIELD cFrameName        AS CHARACTER
  FIELD cRunAttribute     AS CHARACTER
  FIELD cSDOName          AS CHARACTER
  FIELD hFrameHandle      AS HANDLE
  FIELD dFrameMinWidth    AS DECIMAL
  FIELD dFrameMinHeight   AS DECIMAL
  FIELD cFrameTitle       AS CHARACTER
  FIELD hDataSource       AS HANDLE
  FIELD hFrameToolbar     AS HANDLE
  FIELD iStructLevel      AS INTEGER
  FIELD hSuperProcedure   AS HANDLE
  FIELD iTimeAccessed     AS INTEGER
  FIELD dNodeObj          AS DECIMAL
  INDEX idx1              AS PRIMARY UNIQUE hTargetProcedure hFrameHandle
  INDEX idx2              hTargetProcedure cFrameName cRunAttribute iStructLevel cSDOName dNodeObj
  INDEX idxTimeAccessed   hTargetProcedure iTimeAccessed.

/* This temp-table is used to reposition parent SDOs when a child node
   in a lower level is selected */
DEFINE TEMP-TABLE ttParentStructure NO-UNDO
  FIELD hTargetProcedure  AS HANDLE
  FIELD hParentSDO        AS HANDLE
  FIELD cParentNodeKey    AS CHARACTER
  FIELD cKeyFields        AS CHARACTER
  FIELD cKeyFieldValues   AS CHARACTER
  FIELD rRowid            AS ROWID
  FIELD iLevel            AS INTEGER
  INDEX idx1              AS PRIMARY UNIQUE hTargetProcedure iLevel.

DEFINE TEMP-TABLE ttDataLinks NO-UNDO
  FIELD hTargetProcedure  AS HANDLE
  FIELD hSourceHandle     AS HANDLE
  FIELD hTargetHandle     AS HANDLE
  INDEX idx1              AS PRIMARY hTargetProcedure.


/* Define temp-tables required for TreeView */
{src/adm2/treettdef.i}

{dynlaunch.i &DEFINE-ONLY=YES}

{src/adm2/tttranslate.i}

&SCOPED-DEFINE FRAME_WIDTH_SPACE 4
&SCOPED-DEFINE FRAME_HEIGHT_SPACE 4

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-assignRefValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignRefValue Procedure 
FUNCTION assignRefValue RETURNS CHARACTER
  ( pcRefFields AS CHARACTER,
    phDataObject AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignTempObjNumber) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignTempObjNumber Procedure 
FUNCTION assignTempObjNumber RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentTreeFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentTreeFrame Procedure 
FUNCTION getCurrentTreeFrame RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEntityName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEntityName Procedure 
FUNCTION getEntityName RETURNS CHARACTER
  ( phDataSource AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLogicalObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLogicalObjectName Procedure 
FUNCTION getLogicalObjectName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNodeDetails) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNodeDetails Procedure 
FUNCTION getNodeDetails RETURNS CHARACTER
  ( INPUT phTable   AS HANDLE,
    INPUT pcNodeKey AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjKeyField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjKeyField Procedure 
FUNCTION getObjKeyField RETURNS CHARACTER
  ( pcValueList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRunTimeAttributeTree) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRunTimeAttributeTree Procedure 
FUNCTION getRunTimeAttributeTree RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTranslatableNodes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTranslatableNodes Procedure 
FUNCTION getTranslatableNodes RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTreeLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTreeLogicalName Procedure 
FUNCTION getTreeLogicalName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTreeRunAttributeTree) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTreeRunAttributeTree Procedure 
FUNCTION getTreeRunAttributeTree RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-lockWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD lockWindow Procedure 
FUNCTION lockWindow RETURNS LOGICAL
  (plLockWindow AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAutoSort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAutoSort Procedure 
FUNCTION setAutoSort RETURNS LOGICAL
  ( plAutoSort AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHideSelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setHideSelection Procedure 
FUNCTION setHideSelection RETURNS LOGICAL
  ( plHideSelection AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setImageHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setImageHeight Procedure 
FUNCTION setImageHeight RETURNS LOGICAL
  ( piImageHeight AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setImageWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setImageWidth Procedure 
FUNCTION setImageWidth RETURNS LOGICAL
  ( piImageWidth AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLastLaunchedNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLastLaunchedNode Procedure 
FUNCTION setLastLaunchedNode RETURNS LOGICAL
  ( pcNodeKey AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRootNodeCode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRootNodeCode Procedure 
FUNCTION setRootNodeCode RETURNS LOGICAL
  ( pcRootNodeCode AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setShowCheckBoxes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setShowCheckBoxes Procedure 
FUNCTION setShowCheckBoxes RETURNS LOGICAL
  ( plShowCheckBoxes AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setShowRootLines) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setShowRootLines Procedure 
FUNCTION setShowRootLines RETURNS LOGICAL
  ( plShowRootLines AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTreeStyle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTreeStyle Procedure 
FUNCTION setTreeStyle RETURNS LOGICAL
  ( piTreeStyle AS INTEGER )  FORWARD.

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
         HEIGHT             = 28.43
         WIDTH              = 54.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/tvcoprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addStrucNodeChildren) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addStrucNodeChildren Procedure 
PROCEDURE addStrucNodeChildren :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is used for to make 30 copies of a structured node
               and it's children.
  Parameters:  pdOrigStrucNodeObj - The Object number of the original structured
                                    node that this node is created from.
               pdParentNodeObj    - The preceding copy (if any) of the recursive
                                    copied node.
               piStrucLevel       - This is the level number of the structured
                                    node being created. Ranges from 0 to 30.
  Notes:       The max number of structured node copies to be created is stored
               in a pre-processor variable called 'NUM-STRUC-COPIES'.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdOrigStrucNodeObj AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdParentNodeObj    AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER piStrucLevel       AS INTEGER    NO-UNDO.

  DEFINE BUFFER bttNode  FOR ttNode.
  DEFINE BUFFER bcttNode FOR ttNode.

  FOR EACH  bttNode
      WHERE bttNode.hTargetProcedure = TARGET-PROCEDURE
      AND   bttNode.parent_node_obj  = pdOrigStrucNodeObj
      AND   bttNode.iStrucLevel      = 0
      NO-LOCK:
    CREATE bcttNode.
    BUFFER-COPY bttNode EXCEPT bttNode.node_obj bttNode.node_code
             TO bcttNode.
    ASSIGN bcttNode.dOrigStrucNodeObj = bttNode.node_obj
           bcttNode.parent_node_obj   = pdParentNodeObj
           bcttNode.iStrucLevel       = piStrucLevel
           bcttNode.node_code         = bttNode.node_code + "_":U + STRING(piStrucLevel).
           bcttNode.node_obj          = DYNAMIC-FUNCTION("assignTempObjNumber":U IN TARGET-PROCEDURE).
    RUN addStrucNodeChildren IN TARGET-PROCEDURE (INPUT bttNode.node_obj,
                                                  INPUT bcttNode.node_obj,
                                                  INPUT piStrucLevel + 1).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignInitialProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignInitialProperties Procedure 
PROCEDURE assignInitialProperties :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will set the initial properties for the Dynamic
               TreeView in the properties temp-table.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRootNodeCode   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hWindow         AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE lShowCheckBoxes AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lShowRootLines  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lHideSelection  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAutoSort       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iImageHeight    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iImageWidth     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iTreeStyle      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLineStyle      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFilterViewer   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iRowsToBatch    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lHideOnClose    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iMaxHiddenCont  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cRunAttribute   AS CHARACTER  NO-UNDO.
  
  {get ContainerHandle hWindow}.
  {get TreeViewOCX hTreeViewOCX}.
  
  /* Get the TreeView Properties */
  &SCOPED-DEFINE xpShowCheckBoxes
  {get ShowCheckBoxes lShowCheckBoxes}.
  &UNDEFINE xpShowCheckBoxes
  
  &SCOPED-DEFINE xpShowRootLines
  {get ShowRootLines lShowRootLines}.
  &UNDEFINE xpShowRootLines
  
  &SCOPED-DEFINE xpHideSelection
  {get HideSelection lHideSelection}.
  &UNDEFINE xpHideSelection
  
  &SCOPED-DEFINE xpImageHeight
  {get ImageHeight iImageHeight}.
  &UNDEFINE xpImageHeight
  
  &SCOPED-DEFINE xpImageWidth
  {get ImageWidth iImageWidth}.
  &UNDEFINE xpImageWidth
  
  &SCOPED-DEFINE xpTreeStyle
  {get TreeStyle iTreeStyle}.
  &UNDEFINE xpTreeStyle
  
  &SCOPED-DEFINE xpAutoSort
  {get AutoSort lAutoSort}.
  &UNDEFINE xpAutoSort
  
  &SCOPED-DEFINE xpRowsToBatch
  {get RowsToBatch iRowsToBatch}.
  &UNDEFINE xpRowsToBatch
  
  /* Check for a valid RowsToBatch setting */
  IF iRowsToBatch = ? THEN
    iRowsToBatch = 50.

  /* If we are not going to batch records then we won't be
     needing the More... option then don't worry about 
     setting the AutoSort option to ? to indicate manual sorting */
  IF iRowsToBatch > 0 AND lAutoSort = TRUE THEN
    lAutoSort = ?.

  &SCOPED-DEFINE xpHideChildContainersOnClose
  {get HideChildContainersOnClose lHideOnClose}.
  &UNDEFINE xpHideChildContainersOnClose
  
  cRunAttribute = DYNAMIC-FUNCTION("getRunAttribute":U IN TARGET-PROCEDURE) NO-ERROR.
  
  ASSIGN 
    iMaxHiddenCont = DYNAMIC-FUNCTION('getSessionParam':U IN THIS-PROCEDURE, 'MaxHiddenContainers':U) NO-ERROR.

  /* If the value is UNKNOWN then the property might not be set, or it was set to
     be infinite and we are setting a max of 100 for now */
  IF iMaxHiddenCont = ? THEN
    iMaxHiddenCont = 100. /* Max for now */

  IF iMaxHiddenCont = 0 THEN
    lHideOnClose = FALSE.

  /* Set the properties in the TreeView OCX */
  IF VALID-HANDLE(hTreeViewOCX) THEN 
  DO:
    iLineStyle = IF lShowRootLines THEN 1 ELSE 0.
    
    {set ShowCheckBoxes lShowCheckBoxes hTreeViewOCX}.
    {set ShowRootLines  lShowRootLines  hTreeViewOCX}.
    {set HideSelection  lHideSelection  hTreeViewOCX}.
    /* This will always be ? since we will be doing a manual sort */
    {set AutoSort       lAutoSort       hTreeViewOCX}.
    {set ImageHeight    iImageHeight    hTreeViewOCX}.
    {set ImageWidth     iImageWidth     hTreeViewOCX}.
    {set TreeStyle      iTreeStyle      hTreeViewOCX}.
    {set LineStyle      iLineStyle      hTreeViewOCX}.
  END.

  &SCOPED-DEFINE xpRootNodeCode
  {get RootNodeCode cRootNodeCode}.
  &UNDEFINE xpRootNodeCode
  
  /* Check for a Filter Viewer */
  hFilterViewer = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U IN TARGET-PROCEDURE, "TreeFilter-Source":U)) NO-ERROR.

  cObjectName = DYNAMIC-FUNCTION("getLogicalObjectName":U IN TARGET-PROCEDURE).

  /* Insure we have a Property temp-table record as soon as we initialize the
     Dynamic TreeView */
  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE ttProp THEN
    CREATE ttProp.

  ASSIGN ttProp.hTargetProcedure       = TARGET-PROCEDURE
         ttProp.cTreeLogicalObjectName = cObjectName
         ttProp.cTreeRunAttribute      = cRunAttribute
         ttProp.dTreeMinWidth          = hWindow:MIN-WIDTH-CHARS 
         ttProp.dTreeMinHeight         = hWindow:MIN-HEIGHT-CHARS
         ttProp.cParentNode            = ?
         ttProp.lAutoSort              = lAutoSort
         ttProp.cRootNodeCode          = cRootNodeCode
         ttProp.hFilterViewer          = hFilterViewer
         ttProp.lFilterApplied         = NOT VALID-HANDLE(hFilterViewer)
         ttProp.iRowsToBatch           = iRowsToBatch
         ttProp.lHideOnClose           = lHideOnClose
         ttProp.iMaxHiddenContainers   = iMaxHiddenCont.

  IF VALID-HANDLE(hFilterViewer) THEN
    /* A filter viewer will publish this event when applying a filter */
    SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "filterDataAvailable":U IN hFilterViewer.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildPopupMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildPopupMenu Procedure 
PROCEDURE buildPopupMenu :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will build a Popup Menu for the node that was 
               right-clicked on.
  Parameters:  pdNodeObj - The node_obj of the parent node that was selected
                           and that should indicate what the child nodes are 
                           that should be available to be created as children.
               pcNodeKey - The node key of the selected node that initiated this
                           event.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdNodeObj AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcNodeKey AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hPopupMenu    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hPopupItem    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRootNodeCode AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTreeFrame    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cMenuLabel    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWindow       AS HANDLE     NO-UNDO.
  
  {get ContainerHandle hWindow}.
  {get TreeViewOCX hTreeViewOCX}.
  
  /* Always delete the widget pool for this TreeView - we only ever add the
     menu and it's items in here */
  DELETE WIDGET-POOL ("WidgetPool" + STRING(TARGET-PROCEDURE)) NO-ERROR.
   
  CREATE WIDGET-POOL ("WidgetPool" + STRING(TARGET-PROCEDURE)) PERSISTENT NO-ERROR.
  ASSIGN hPopupMenu = hWindow:POPUP-MENU.
  
  IF VALID-HANDLE( hPopupMenu ) THEN
    DELETE WIDGET hPopupMenu.
  
  hWindow:POPUP-MENU = ?.

  CREATE MENU hPopupMenu IN WIDGET-POOL ("WidgetPool" + STRING(TARGET-PROCEDURE))
      ASSIGN
          POPUP-ONLY  = YES.
  
  /* Add option to add the different child node records */
  
  /* If Child Nodes are allowed, but none were Found, 
     Prompt user if if they want to add a new record */
  FIND FIRST ttNode
       WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
       AND   ttNode.node_obj         = pdNodeObj
       NO-LOCK NO-ERROR.
  IF AVAILABLE ttNode THEN 
  DO:
    FOR EACH   ttNode 
         WHERE ttNode.hTargetProcedure  = TARGET-PROCEDURE
         AND   ttNode.parent_node_obj   = pdNodeObj
         AND   ttNode.data_source_type <> "TXT":U
         AND   ttNode.logical_object   <> "":U /* Do not create option if we don't */
         NO-LOCK:                              /* have a folder window to launch   */
      cMenuLabel = "&Add " + ttNode.node_label.
      IF CAN-FIND(FIRST ttTranslate
                  WHERE ttTranslate.cWidgetType = "TREE_POPUP":U
                  AND   ttTranslate.cTranslatedLabel <> "":U) THEN DO:
        FIND FIRST ttTranslate 
             WHERE ttTranslate.cWidgetName = "POPUP_":U + "&Add " + ttNode.node_label
             AND   ttTranslate.cTranslatedLabel <> "":U
             NO-LOCK NO-ERROR.
        IF AVAILABLE ttTranslate THEN
          cMenuLabel = ttTranslate.cTranslatedLabel.
      END.
      CREATE MENU-ITEM hPopupItem IN WIDGET-POOL ("WidgetPool" + STRING(TARGET-PROCEDURE))
          ASSIGN
              LABEL       = cMenuLabel
              PARENT      = hPopupMenu
              SENSITIVE   = TRUE
          TRIGGERS:
              ON CHOOSE PERSISTENT RUN nodeAddRecord IN TARGET-PROCEDURE ( INPUT ttNode.node_obj,
                                                                           INPUT pcNodeKey).
          END TRIGGERS.
    END.
  END.

  /* Assign the new popup menu to the window */
  hTreeFrame = DYNAMIC-FUNCTION("getContainerHandle":U IN hTreeViewOCX).
  IF VALID-HANDLE(hTreeFrame) THEN
    ASSIGN hTreeFrame:POPUP-MENU = hPopupMenu.
  ELSE
    ASSIGN
        hWindow:POPUP-MENU = hPopupMenu.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-calcNewTreeSize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcNewTreeSize Procedure 
PROCEDURE calcNewTreeSize :
/*------------------------------------------------------------------------------
  Purpose:    Calculates the Min sizes of the TreeView to see if the object will fit
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hResizeBar           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTitleBar            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWindow              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dFrameMinWidth       AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dFrameMinHeight      AS DECIMAL    NO-UNDO.
  

  DEFINE BUFFER ttPropNewSize FOR ttProp.
  
  {get ResizeBar hResizeBar}.
  {get TitleBar hTitleBar}.
  {get ContainerHandle hWindow}.

  /* Get the Min Sizes of all launched frames */
  FOR EACH ttFrame
      WHERE ttFrame.hTargetProcedure = TARGET-PROCEDURE
      NO-LOCK:
    ASSIGN dFrameMinWidth  = MAX(ttFrame.dFrameMinWidth,dFrameMinWidth)
           dFrameMinHeight = MAX(ttFrame.dFrameMinHeight,dFrameMinHeight).
  END.
  
  /* Check if we will be able to fit the SmartFrame in the available space and if
     we cannot do that then we will need to adjust the size of the TreeView Container */
  IF hWindow:MIN-WIDTH-CHARS < (hResizeBar:COL + dFrameMinWidth + {&FRAME_WIDTH_SPACE}) THEN
    hWindow:MIN-WIDTH-CHARS = hResizeBar:COL + dFrameMinWidth + {&FRAME_WIDTH_SPACE} NO-ERROR.
  IF hWindow:MIN-HEIGHT-CHARS < (hTitleBar:ROW + dFrameMinHeight + {&FRAME_HEIGHT_SPACE}) THEN
    hWindow:MIN-HEIGHT-CHARS = hTitleBar:ROW + dFrameMinHeight + {&FRAME_HEIGHT_SPACE} NO-ERROR.
      
  /* If the TreeView container's min sizes were adjusted then we need to resize it */
  FIND FIRST ttPropNewSize WHERE ttPropNewSize.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK.
  IF hWindow:MIN-WIDTH-CHARS  > ttPropNewSize.dTreeMinWidth  OR
     hWindow:MIN-HEIGHT-CHARS > ttPropNewSize.dTreeMinHeight THEN
  DO:
    IF hWindow:WIDTH-CHARS < hWindow:MIN-WIDTH-CHARS THEN
      ASSIGN hWindow:VIRTUAL-WIDTH-CHARS  = hWindow:MIN-WIDTH-CHARS 
             hWindow:WIDTH-CHARS          = hWindow:MIN-WIDTH-CHARS
             NO-ERROR.

    IF hWindow:HEIGHT-CHARS < hWindow:MIN-HEIGHT-CHARS THEN
      ASSIGN hWindow:VIRTUAL-HEIGHT-CHARS = hWindow:MIN-HEIGHT-CHARS
             hWindow:HEIGHT-CHARS         = hWindow:MIN-HEIGHT-CHARS
             NO-ERROR.
    ASSIGN ttPropNewSize.lResizeFrameNow = FALSE.
    RUN resizeWindow IN TARGET-PROCEDURE. 
    ASSIGN ttPropNewSize.lResizeFrameNow = TRUE.
  END.
  
  /* Set the new properties */
  ASSIGN ttPropNewSize.dTreeMinWidth    = MAX(ttPropNewSize.dTreeMinWidth,hWindow:MIN-WIDTH-CHARS)
         ttPropNewSize.dTreeMinHeight   = MAX(ttPropNewSize.dTreeMinHeight,hWindow:MIN-HEIGHT-CHARS)
         ttPropNewSize.dFolderMinWidth  = MAX(ttPropNewSize.dFolderMinWidth,dFrameMinWidth)
         ttPropNewSize.dFolderMinHeight = MAX(ttPropNewSize.dFolderMinHeight,dFrameMinHeight).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelNew) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelNew Procedure 
PROCEDURE cancelNew :
/*------------------------------------------------------------------------------
  Purpose:     The SDO that is currently being maintained or added to will 
               publish this event when the Cancel button is pressed.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK.
  ttProp.lCancelRecord = TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-changeFolderPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeFolderPage Procedure 
PROCEDURE changeFolderPage :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is called when a new page has been selected on 
               the SmartFrame launched in the TreeView's application section.
               This allows us to set a property to indicate that we need to 
               resize the SmartFrame and not the TreeView.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK.
  ASSIGN ttProp.lResizeFrameNow = TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createDummyChild) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createDummyChild Procedure 
PROCEDURE createDummyChild :
/*------------------------------------------------------------------------------
  Purpose:     This procedure creates a dummy child node to indicate that the
               parent node can be expanded.
  Parameters:  phBuf - The handle of the current buffer we are using to add
                       new records to the tree table
               pcParentNodeKey - The parent node key that should be used to
                                 as the parent node for the node we want to
                                 create here.
               pcType - The type of dummy node we want to create. Valid types
                        are DUMMY and DUMMYADD
  Notes:       If the type passed is 'DUMMY' we will only create the record
               in the passed buffer handle. If the type passed is 'DUMMYADD'
               we will add the dummy record in the buffer handle as well as 
               add the node to the TreeView.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phBuf           AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcParentNodeKey AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcType          AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE hTreeViewOCX            AS HANDLE     NO-UNDO.

  {get TreeViewOCX hTreeViewOCX}.

  phBuf:BUFFER-CREATE().
  ASSIGN phBuf:BUFFER-FIELD('parent_node_key':U):BUFFER-VALUE = pcParentNodeKey
         phBuf:BUFFER-FIELD('node_key':U):BUFFER-VALUE        = DYNAMIC-FUNCTION('getNextNodeKey':U IN hTreeViewOCX)
         phBuf:BUFFER-FIELD('node_label':U):BUFFER-VALUE      = "+":U
         phBuf:BUFFER-FIELD('record_ref':U):BUFFER-VALUE      = 99
         phBuf:BUFFER-FIELD('node_insert':U):BUFFER-VALUE     = 4.

  IF pcType = "DUMMYADD":U THEN
    RUN addNode IN hTreeViewOCX (INPUT phBuf).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createRepositoryObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createRepositoryObjects Procedure 
PROCEDURE createRepositoryObjects :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is called when we need to launch an Application
               object for the selected node.
  Parameters:  pcLogicalObjectName - The logical object name of the folder 
                                     window we want to launch in the application
                                     area.
               pcSDOName           - The name of the primary SDO of the folder
                                     window we are launching
               pcInstanceAttributes- The instance attributes that should 
                                     acompany the folder window we are launching
               piStructLevel       - The structure level of a structured node. 
                                     This is used to differenciate between folder
                                     windows in a structured treeview and only
                                     applies to structred nodes.
               pdNodeObj           - The node obj value of the node record 
                                     that we are trying to launch. This will 
                                     help us make each node level's SDO and frame
                                     unique.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcLogicalObjectName    AS CHARACTER            NO-UNDO.
  DEFINE INPUT PARAMETER pcSDOName              AS CHARACTER            NO-UNDO.
  DEFINE INPUT PARAMETER pcInstanceAttributes   AS CHARACTER            NO-UNDO.
  DEFINE INPUT PARAMETER piStructLevel          AS INTEGER              NO-UNDO.
  DEFINE INPUT PARAMETER pdNodeObj              AS DECIMAL              NO-UNDO.
  
  DEFINE VARIABLE hObjectHandle   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWindow         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFrameToolbar   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDOHandle      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cWindowTitle    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTitleBar       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSuperProcedure AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iFrameCnt       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iMaxHiddenCont  AS INTEGER    NO-UNDO.
  /* Used to check container security */
  DEFINE VARIABLE pdDummyObjectObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lSecured         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDummyButton     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dParentNodeObj   AS DECIMAL    NO-UNDO.

  DEFINE BUFFER bttFrame FOR ttFrame.
  DEFINE BUFFER bttNode  FOR ttNode.

  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK.
  /* The Objects are already running, do not instantiate them again */
  IF ttProp.cLaunchedFolderName  = pcLogicalObjectName  AND 
     ttProp.cLaunchedRunInstance = pcInstanceAttributes AND
     ttProp.cLaunchedSDOName     = pcSDOName            AND 
     ttProp.iStructLevel         = piStructLevel       THEN
      RETURN.

  ASSIGN ttProp.cLaunchedFolderName  = pcLogicalObjectName 
         ttProp.cLaunchedRunInstance = pcInstanceAttributes
         ttProp.cLaunchedSDOName     = pcSDOName
         ttProp.iStructLevel         = piStructLevel
         iMaxHiddenCont              = ttProp.iMaxHiddenCont.
  
  /* Get the frame handle */
  {get ContainerHandle hWindow}.
  
  IF VALID-HANDLE(ttProp.hCurrentFrame) THEN
  DO:
    IF ttProp.lHideOnClose = TRUE THEN
      RUN hideObject IN ttProp.hCurrentFrame.
    ELSE 
      RUN destroyFrame IN TARGET-PROCEDURE (INPUT ttProp.hCurrentFrame).
    ASSIGN ttProp.hCurrentFrame = ?.
  END.
    
  /* Unsubscribe all SDO Events */
  IF ttProp.lMenuTreeObject = FALSE THEN
  DO:
    FOR EACH  ttRunningSDOs
        WHERE ttRunningSDOs.hTargetProcedure = TARGET-PROCEDURE
         NO-LOCK:
      IF VALID-HANDLE(ttRunningSDOs.hSDOHandle) THEN
      DO:
        UNSUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "cancelNew":U     IN ttRunningSDOs.hSDOHandle.
        UNSUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "updateState":U   IN ttRunningSDOs.hSDOHandle.
        UNSUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "dataAvailable":U IN ttRunningSDOs.hSDOHandle.
      END.
    END.
  END.

  FIND FIRST ttFrame
       WHERE ttFrame.hTargetProcedure = TARGET-PROCEDURE
       AND   ttFrame.cFrameName       = pcLogicalObjectName
       AND   ttFrame.cRunAttribute    = pcInstanceAttributes
       AND   ttFrame.cSDOName         = pcSDOName
       AND   ttFrame.iStructLevel     = piStructLevel
       AND   ttFrame.dNodeObj         = pdNodeObj
       EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE ttFrame THEN
  DO:
    ASSIGN ttProp.hCurrentFrame = ttFrame.hFrameHandle.
    ASSIGN ttFrame.iTimeAccessed = TIME.
    IF ttProp.lMenuTreeObject = FALSE AND 
       VALID-HANDLE(ttFrame.hDataSource) THEN
    DO:
      SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "cancelNew":U     IN ttFrame.hDataSource.
      SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "updateState":U   IN ttFrame.hDataSource.
      SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "dataAvailable":U IN ttFrame.hDataSource.
    END.
    hObjectHandle = ttFrame.hFrameHandle.
    
    RUN calcNewTreeSize IN TARGET-PROCEDURE.    
    RUN resizeWindow IN TARGET-PROCEDURE.    
    
    RUN updateFrameTitle IN TARGET-PROCEDURE (INPUT hObjectHandle).
    RUN viewObject IN hObjectHandle.
  END.
  ELSE /* We need to launch the new frame */
  DO:
    /* For Nodes that should not launch an Object */
    IF pcLogicalObjectName = "":U THEN
    DO:
      {get TitleBar hTitleBar}.
      hTitleBar:SCREEN-VALUE = "":U.
      RETURN.
    END.

    /* First check if we should destroy any running frames if we have reached
       the Max number of hidden containers for the session */
    IF iMaxHiddenCont <> ? AND 
       iMaxHiddenCont > 0 THEN
    DO:
      FOR EACH  bttFrame
          WHERE bttFrame.hTargetProcedure = TARGET-PROCEDURE
          NO-LOCK:
        iFrameCnt = iFrameCnt + 1.
      END.
      IF (iFrameCnt + 1) > iMaxHiddenCont THEN
      DO:
        /* Find the a frame that has the lowes accessed time */
        FIND FIRST bttFrame
             WHERE bttFrame.hTargetProcedure = TARGET-PROCEDURE
             USE-INDEX idxTimeAccessed
             NO-LOCK NO-ERROR.
        IF AVAILABLE bttFrame THEN
          RUN destroyFrame IN TARGET-PROCEDURE (bttFrame.hFrameHandle).
      END.
    END.
    
    /* Before we launch the frame, check if it has been secured */
    RUN objectSecurityCheck IN gshSecurityManager (INPUT-OUTPUT pcLogicalObjectName,
                                                   INPUT-OUTPUT pdDummyObjectObj,
                                                   OUTPUT lSecured).
    IF lSecured 
    THEN DO:        
        RUN showMessages IN gshSessionManager (INPUT "You do not have the necessary security permission to launch this object",
                                               INPUT "ERR",
                                               INPUT "&OK",
                                               INPUT "&OK",
                                               INPUT "&OK",
                                               INPUT "Error",
                                               INPUT NO,
                                               INPUT ?,
                                               OUTPUT cDummyButton).
        {get TitleBar hTitleBar}.
        hTitleBar:SCREEN-VALUE = "":U.
        RETURN ERROR "secured":U.
    END.

    {set CurrentLogicalName pcLogicalObjectName}.
    RUN constructObject IN TARGET-PROCEDURE
      ( INPUT 'ry/uib/rydynframw.w',
        INPUT hWindow,
        INPUT '',
        OUTPUT hObjectHandle ).
    {set CurrentLogicalName ''}.
    
    CREATE ttFrame.
    ASSIGN ttFrame.hTargetProcedure = TARGET-PROCEDURE
           ttFrame.hFrameHandle     = hObjectHandle
           ttFrame.cFrameName       = pcLogicalObjectName 
           ttFrame.cRunAttribute    = pcInstanceAttributes
           ttFrame.cSDOName         = pcSDOName
           ttFrame.iStructLevel     = piStructLevel
           ttFrame.dNodeObj         = pdNodeObj
           ttFrame.iTimeAccessed    = TIME.
  
    /* Assign Window Title */
    {get TitleBar hTitleBar}.
    cWindowTitle = hTitleBar:SCREEN-VALUE.
    RUN updateFrameTitle IN TARGET-PROCEDURE (INPUT ttFrame.hFrameHandle).
    ASSIGN ttFrame.cFrameTitle = cWindowTitle.
    
    /* Start Super Procedure */
    RUN getObjectSuperProcedure IN gshRepositoryManager (INPUT pcLogicalObjectName,
                                                         INPUT pcInstanceAttributes,
                                                         OUTPUT cSuperProcedure).
    IF cSuperProcedure NE "":U THEN
    DO:
      {launch.i
          &PLIP        = cSuperProcedure
          &OnApp       = 'NO' 
          &Iproc       = ''
          &NewInstance = YES
      }
      IF VALID-HANDLE(hPlip) THEN
      DO:
        DYNAMIC-FUNCTION("addAsSuperProcedure":U IN gshSessionManager,
                         INPUT hPlip, INPUT hObjectHandle).
        ASSIGN ttFrame.hSuperProcedure = hPlip.
      END.
    END.    /* object created ok, and super exists. */       

    /* Set the current frame */
    FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK.
    ASSIGN ttProp.hCurrentFrame   = hObjectHandle
           ttProp.lResizeFrameNow = TRUE.
    
    /* If we are launching a Folder window linked to an SDO, we need to add
       our data and other related links to the launched SDO */
    FIND FIRST ttRunningSDOs 
         WHERE ttRunningSDOs.hTargetProcedure = TARGET-PROCEDURE
         AND   ttRunningSDOs.cSDOName         = pcSDOName
         AND   ttRunningSDOs.iStrucLevel      = piStructLevel
         AND   ttRunningSDOs.dNodeObj         = pdNodeObj
         NO-LOCK NO-ERROR.
    /* In some instances - TXT nodes - the SDO is the Primary Data Object that points
       to the parent node's SDO and in such a case the pdNodeObj needs to be that of
       it's parent node */
    IF NOT AVAILABLE ttRunningSDOs THEN
    DO:
      FIND FIRST bttNode
           WHERE bttNode.hTargetProcedure = TARGET-PROCEDURE
           AND   bttNode.node_obj         = pdNodeObj
           NO-LOCK NO-ERROR.
      IF AVAILABLE bttNode THEN
        dParentNodeObj = bttNode.parent_node_obj.
      
      FIND FIRST ttRunningSDOs 
           WHERE ttRunningSDOs.hTargetProcedure = TARGET-PROCEDURE
           AND   ttRunningSDOs.cSDOName         = pcSDOName
           AND   ttRunningSDOs.iStrucLevel      = piStructLevel
           AND   ttRunningSDOs.dNodeObj         = dParentNodeObj
           NO-LOCK NO-ERROR.
    END.

    IF AVAILABLE ttRunningSDOs AND VALID-HANDLE(ttRunningSDOs.hSDOHandle) THEN
      hSDOHandle = ttRunningSDOs.hSDOHandle.
    IF VALID-HANDLE(hSDOHandle) THEN
    DO:
      FIND FIRST ttFrame
           WHERE ttFrame.hTargetProcedure = TARGET-PROCEDURE
           AND   ttFrame.hFrameHandle     = hObjectHandle
           EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE ttFrame THEN
        ASSIGN ttFrame.hDataSource = hSDOHandle.
      RUN addLink IN TARGET-PROCEDURE (INPUT TARGET-PROCEDURE, INPUT "PrimarySDO":U, INPUT ttRunningSDOs.hSDOHandle).
    END.
    
    /* Take care of Pass-Through links */
    RUN createLinks IN gshSessionManager ( INPUT hObjectHandle:FILE-NAME,
                                           INPUT hObjectHandle,
                                           INPUT TARGET-PROCEDURE,
                                           INPUT NO) NO-ERROR.

    /* After the links have been established, removed the PrimarySDO link */
    IF VALID-HANDLE(hSDOHandle) THEN DO:
      RUN removeLink IN TARGET-PROCEDURE (INPUT TARGET-PROCEDURE, INPUT "PrimarySDO":U, INPUT ttRunningSDOs.hSDOHandle).
      SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "cancelNew":U     IN hSDOHandle.
      SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "updateState":U   IN hSDOHandle.
      SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "dataAvailable":U IN hSDOHandle.
    END.
    
    /* We need to exclude some bands and buttons on the frame's toolbar to be 
       able to use it correctly with the Dynamic TreeView */
    {get ToolbarHandles cFrameToolbar hObjectHandle}.
    RUN modifyFrameToolbar IN TARGET-PROCEDURE (INPUT cFrameToolbar, INPUT hSDOHandle).

    /* This procedure will be used to notify us when a new page is selected to
       ensure we run the correct sizing procedure */
    SUBSCRIBE PROCEDURE TARGET-PROCEDURE "changeFolderPage":U IN hObjectHandle.
    
    /* The initializeObject call will take care of packing, resizing and viewing the 
       window.
     */
    RUN initializeObject IN hObjectHandle.
    
    /* This will ensure that any SDF not displaying it's value on the initialization
       of it's object does get assigned the correct screen-value - Issue #????? */
    IF VALID-HANDLE(hSDOHandle) THEN
      PUBLISH "DataAvailable":U FROM hSDOHandle (INPUT "?":U).
  
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable Procedure 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will ensure the selected Tree node and selected
               record in the Tree are always the same after a delete.
  Parameters:  pcState - A flag to indicate something about the "new" or "changed"
                         current record.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcState AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cSelectedNodeKey AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTreeDataTable   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lRowAvailable    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cValueList       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjField        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRecordRef       AS CHARACTER  NO-UNDO.

  IF pcState = "DIFFERENT":U OR
     pcState = "NEXT" THEN
  DO:
    FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK.
    IF ttProp.lRecordDeleted = TRUE THEN
    DO:
      ttProp.lRecordDeleted = FALSE.
  
      FIND FIRST ttFrame
           WHERE ttFrame.hTargetProcedure = TARGET-PROCEDURE
           AND   ttFrame.hFrameHandle     = ttProp.hCurrentFrame
           NO-LOCK NO-ERROR.
      IF AVAILABLE ttFrame AND VALID-HANDLE(ttFrame.hDataSource) THEN
        lRowAvailable = DYNAMIC-FUNCTION("rowAvailable":U IN ttFrame.hDataSource, "CURRENT":U).
      
      {get TreeViewOCX hTreeViewOCX}.
      
      IF NOT lRowAvailable OR
         NOT VALID-HANDLE(ttFrame.hDataSource) OR 
         NOT AVAILABLE ttFrame THEN 
      DO:
        cSelectedNodeKey = ttProp.cParentNode.
        DYNAMIC-FUNCTION("setProperty":U IN hTreeViewOCX, INPUT "SELECTEDITEM":U, INPUT cSelectedNodeKey, INPUT "":U).
        RUN tvNodeSelected IN TARGET-PROCEDURE (INPUT cSelectedNodeKey).
        RETURN.
      END.
      
      ASSIGN cValueList = DYNAMIC-FUNCTION("getEntityName":U IN TARGET-PROCEDURE,ttFrame.hDataSource).
      IF LENGTH(TRIM(cValueList)) > 0 THEN 
        ASSIGN cObjField = DYNAMIC-FUNCTION("getObjKeyField":U IN TARGET-PROCEDURE,cValueList).
      
      cRecordRef = DYNAMIC-FUNCTION("assignRefValue":U IN TARGET-PROCEDURE, INPUT cObjField, INPUT ttFrame.hDataSource).
      
      {get TreeDataTable hTreeDataTable hTreeViewOCX}.
      
      ASSIGN hBuffer = hTreeDataTable:DEFAULT-BUFFER-HANDLE.
  
      hBuffer:FIND-FIRST("WHERE record_ref = '" + cRecordRef + "'":U) NO-ERROR.
      
      IF NOT hBuffer:AVAILABLE THEN
        cSelectedNodeKey = ttProp.cParentNode.
      ELSE
      DO:
        cSelectedNodeKey = hBuffer:BUFFER-FIELD("node_key":U):BUFFER-VALUE.
        RUN tvNodeSelected IN TARGET-PROCEDURE (INPUT cSelectedNodeKey).
      END.
      DYNAMIC-FUNCTION("setProperty":U IN hTreeViewOCX, INPUT "SELECTEDITEM":U, INPUT cSelectedNodeKey, INPUT "":U).
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteComplete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteComplete Procedure 
PROCEDURE deleteComplete :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is published from the SDO when a Successful delete
               as occured and we now need to delete the specified node.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTreeViewOCX      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTreeBuffer       AS HANDLE     NO-UNDO.

  {get TreeViewOCX hTreeViewOCX}.

  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK.
  ASSIGN ttProp.lRecordDeleted = TRUE.

  RUN deleteNode IN hTreeViewOCX (INPUT ttProp.cCurrentNodeCode).
  RUN returnTreeBuffer IN TARGET-PROCEDURE (INPUT ttProp.cCurrentNodeCode, OUTPUT hTreeBuffer).
  IF hTreeBuffer:AVAILABLE THEN
    hTreeBuffer:BUFFER-DELETE().
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyFrame Procedure 
PROCEDURE destroyFrame :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will destroy a frame and remove the temp-table
               record.
  Parameters:  phFrameHandle - The handle of the frame to be destroyed.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phFrameHandle AS HANDLE     NO-UNDO.
  
  DEFINE BUFFER ttFrame FOR ttFrame.

  FIND FIRST ttFrame
       WHERE ttFrame.hTargetProcedure = TARGET-PROCEDURE
       AND   ttFrame.hFrameHandle = phFrameHandle
       EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE ttFrame THEN
  DO:
    IF VALID-HANDLE(ttFrame.hFrameHandle) THEN
      RUN destroyObject IN ttFrame.hFrameHandle.
    IF VALID-HANDLE(ttFrame.hSuperProcedure) THEN
      DELETE OBJECT ttFrame.hSuperProcedure NO-ERROR.
    DELETE ttFrame.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyNonTreeObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyNonTreeObjects Procedure 
PROCEDURE destroyNonTreeObjects :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will destroy all running SDOs and Frames to allow
               us to get a fresh Dynamic TreeView.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Destroy all running Frames */
  FOR EACH  ttFrame
      WHERE ttFrame.hTargetProcedure = TARGET-PROCEDURE
      EXCLUSIVE-LOCK:
    IF VALID-HANDLE(ttFrame.hFrameHandle) THEN
      RUN destroyObject IN ttFrame.hFrameHandle.
    IF VALID-HANDLE(ttFrame.hSuperProcedure) THEN
      DELETE OBJECT ttFrame.hSuperProcedure NO-ERROR.
    DELETE ttFrame.
  END.

  /* Destroy all running SDOs */
  FOR EACH  ttRunningSDOs
      WHERE ttRunningSDOs.hTargetProcedure = TARGET-PROCEDURE
      EXCLUSIVE-LOCK:
    IF VALID-HANDLE(ttRunningSDOs.hSDOHandle) THEN
      RUN destroyObject IN ttRunningSDOs.hSDOHandle.
    DELETE ttRunningSDOs.
  END.

  /* Destroy all node records in temp-table */
  FOR EACH  ttNode
      WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
      EXCLUSIVE-LOCK:
    DELETE ttNode.
  END.
  
  /* Delete any Parent Structure records - shouldn't be any, just in case */
  FOR EACH  ttParentStructure 
      WHERE ttParentStructure.hTargetProcedure = TARGET-PROCEDURE
      EXCLUSIVE-LOCK:
    DELETE ttParentStructure.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Override procedure to ensure we destroy all the temp-table records
               associated with this TreeView object
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lCancel AS LOGICAL  NO-UNDO.

  /* Before we destroy everything we need to check if the current folder is 
     in modify mode and then we need to prompt to user for save instructions */
  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE NO-LOCK.
  IF VALID-HANDLE(ttProp.hCurrentFrame) THEN
  DO:
    RUN confirmExit IN ttProp.hCurrentFrame (INPUT-OUTPUT lCancel).
    IF lCancel THEN
      RETURN ERROR "ADM-ERROR":U. /* This should halt any further processing */
  END.

  RUN saveTreeViewWidth IN TARGET-PROCEDURE.

  DELETE WIDGET-POOL ("WidgetPool" + STRING(TARGET-PROCEDURE)) NO-ERROR.

  RUN saveWindowDimensions IN TARGET-PROCEDURE.
  
  RUN SUPER.
  /* Destroy all Temp-table records for this TreeView */
  
  /* Delete Frame Records */
  FOR EACH  ttFrame
      WHERE ttFrame.hTargetProcedure = TARGET-PROCEDURE
      EXCLUSIVE-LOCK:
    IF VALID-HANDLE(ttFrame.hSuperProcedure) THEN
      DELETE OBJECT ttFrame.hSuperProcedure NO-ERROR.
    IF VALID-HANDLE(ttFrame.hFrameHandle) THEN
      RUN destroyObject IN ttFrame.hFrameHandle.
    DELETE ttFrame.
  END.

  /* Destroy all running SDOs */
  FOR EACH  ttRunningSDOs
      WHERE ttRunningSDOs.hTargetProcedure = TARGET-PROCEDURE
      EXCLUSIVE-LOCK:
    IF VALID-HANDLE(ttRunningSDOs.hSDOHandle) THEN
      RUN destroyObject IN ttRunningSDOs.hSDOHandle.
    DELETE ttRunningSDOs.
  END.

  /* Destroy all node records in temp-table */
  FOR EACH  ttNode
      WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
      EXCLUSIVE-LOCK:
    DELETE ttNode.
  END.
  
  /* Delete any Parent Structure records - shouldn't be any, just in case */
  FOR EACH  ttParentStructure 
      WHERE ttParentStructure.hTargetProcedure = TARGET-PROCEDURE
      EXCLUSIVE-LOCK:
    DELETE ttParentStructure.
  END.
  
  /* Delete Property Record */
  FIND FIRST ttProp 
       WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE 
       EXCLUSIVE-LOCK.
  DELETE ttProp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-filterDataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE filterDataAvailable Procedure 
PROCEDURE filterDataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be published from a FilterViewer and it will
               filter the root node data.
  Parameters:  pcFilterData - This is string containing filter data that should
                              be applied to SDOs for filtering data when expanding
                              a dynamic treeview.
  Notes:       The filter string is in the following form:
               field,value,operator CHR(1) field,value,operator CHR(1) ...
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFilterData  AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cNodeKey      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX  AS HANDLE     NO-UNDO.

  IF pcFilterData = ? OR
     pcFilterData = "?":U THEN
    pcFilterData = "":U.
  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK.
  ASSIGN ttProp.cFilterData    = pcFilterData
         ttProp.lFilterApplied = TRUE.
  IF ttProp.cFilterData = "":U AND 
    ttProp.lInitialized = FALSE  THEN
    RETURN.

  /* We want to destroy all the current running SDO's and other running objects*/
  RUN destroyNonTreeObjects IN TARGET-PROCEDURE.

  /* Set the data back to it's initial values for this TreeView Container */
  ASSIGN ttProp.cPrimarySDOName      = "":U
         ttProp.cDataLinks           = "":U
         ttProp.cCurrentNodeCode     = "":U
         ttProp.cParentNode          = "":U
         ttProp.dNewNodeObj          = 0
         ttProp.lCancelRecord        = FALSE
         ttProp.lResetRecord         = FALSE
         ttProp.lAddCopy             = FALSE
         ttProp.lNewChildNode        = FALSE
         ttProp.lRecordDeleted       = FALSE
         ttProp.hCurrentFrame        = ?
         ttProp.dFolderMinWidth      = 0
         ttProp.dFolderMinHeight     = 0
         ttProp.lResizeFrameNow      = FALSE
         ttProp.cLaunchedFolderName  = "":U
         ttProp.cLaunchedRunInstance = "":U
         ttProp.cLaunchedSDOName     = "":U
         ttProp.iStructLevel         = 1.
  
  {get TreeViewOCX hTreeViewOCX}.
  IF {fn getObjectInitialized hTreeViewOCX} THEN
  DO:
    SESSION:SET-WAIT-STATE("GENERAL":U).
    DYNAMIC-FUNCTION("lockWindow":U IN TARGET-PROCEDURE, INPUT TRUE).

    RUN loadTreeData IN TARGET-PROCEDURE.
    RUN selectFirstNode IN hTreeViewOCX.
    cNodeKey = DYNAMIC-FUNCTION("getSelectedNode":U IN hTreeViewOCX).
    RUN tvNodeSelected IN TARGET-PROCEDURE (INPUT cNodeKey).

    DYNAMIC-FUNCTION("lockWindow":U IN TARGET-PROCEDURE, INPUT FALSE).
    SESSION:SET-WAIT-STATE("":U).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNodeTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNodeTable Procedure 
PROCEDURE getNodeTable :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will return the entire ttNode temp-table created 
               for the Dynamic TreeView object.
  Parameters:  <none>
  Notes:       This API is not used by any of the Dynamic TreeView objects, but
               needs to stay since customers have made reference to this api
               in their applications.
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER TABLE FOR ttNode.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRunningSDOs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRunningSDOs Procedure 
PROCEDURE getRunningSDOs :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will return the entire ttRunningSDOs temp-table created 
               for the Dynamic TreeView's running SDOs
  Parameters:  <none>
  Notes:       This API is not used by any of the Dynamic TreeView objects, but
               needs to stay since customers have made reference to this api
               in their applications.
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER TABLE FOR ttRunningSDOs.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will initialize the Dynamic TreeView and set 
               all the default settings. This is the starting point of a 
               Dynamic TreeView
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hTreeViewOCX             AS HANDLE                 NO-UNDO.
    DEFINE VARIABLE hResizeBar               AS HANDLE                 NO-UNDO.
    DEFINE VARIABLE lObjectInitted           AS LOGICAL                NO-UNDO.  

    
    /* Protect against running initObj more than once.
     */
    {get ObjectInitialized lObjectInitted}.
    IF lObjectInitted THEN
        RETURN.
        
  /* This event is published when the Resize Fill-in is moved */
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "treeResized":U IN TARGET-PROCEDURE.
  
  RUN assignInitialProperties IN TARGET-PROCEDURE.  
  
  RUN SUPER.
  
  {get TreeViewOCX hTreeViewOCX}.  
  IF VALID-HANDLE(hTreeViewOCX) THEN
  DO:
     SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "tvNodeSelected" IN hTreeViewOCX.
     SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "tvNodeEvent"    IN hTreeViewOCX.          
  END.    /* valid treeview component */
  
  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK.
  ttProp.lInitialized = TRUE.
  
  /* Set the mouse pointer for the Resize Bar */
  {get ResizeBar hResizeBar}.
  IF VALID-HANDLE(hResizeBar) THEN
    hResizeBar:LOAD-MOUSE-POINTER("SIZE-E":U).    

  RUN loadTreeData IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadMNUData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadMNUData Procedure 
PROCEDURE loadMNUData :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will step through menu items in the gsm_menu_item
               table for the structure code specified. This is only done once, since
               you can't add new menu items from withing the treeview
  Parameters:  pcParentNodeKey   - The parent node key - "" for Root
               pdChildNodeObj - The Obj number of the child node found on gsm_node
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcParentNodeKey AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pdChildNodeObj  AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE cDetailList             AS CHARACTER  NO-UNDO.

  IF pdChildNodeObj = 0 THEN
    RETURN.
  
  FIND FIRST ttNode
       WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
       AND   ttNode.node_obj         = pdChildNodeObj
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ttNode THEN
    RETURN.
  
  RUN ry/app/rytreemenp.p ON gshAstraAppServer (INPUT ttNode.data_source,
                                                INPUT 0,
                                                OUTPUT cDetailList).

  RUN stripMNUDetails IN TARGET-PROCEDURE 
                       (INPUT pcParentNodeKey,
                        INPUT cDetailList,
                        INPUT pdChildNodeObj,
                        INPUT ttNode.image_file_name,
                        INPUT ttNode.selected_image_file_name).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadNodeData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadNodeData Procedure 
PROCEDURE loadNodeData :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will deternine what type of Node data would be loaded
               and run the appropriate procedure
  Parameters:  pcParentNodeKey   - The parent node key - "" for Root
               pdChildNodeObj - The Obj number of the child node found on gsm_node
  Notes:       The following procedures are used to load Node Data
               SDO/SBO (SDO)        - loadSDOSBOData
               Program (PRG)        - loadPRGData
               Text (TXT)           - loadTXTData
               Menu Structure (MNU) - loadMNUData
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcParentNodeKey AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pdChildNodeObj  AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE cDataSourceType         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataset                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton                 AS CHARACTER  NO-UNDO.
  
  IF pdChildNodeObj = 0 THEN
    RETURN.

  FIND FIRST ttNode
       WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
       AND   ttNode.node_obj         = pdChildNodeObj
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ttNode THEN
    RETURN.
  ELSE
    ASSIGN cDataSourceType = ttNode.data_source_type NO-ERROR.

  CASE cDataSourceType:
    WHEN "SDO":U THEN DO:
      RUN setDataLinks IN TARGET-PROCEDURE (INPUT "INACTIVE":U).
      RUN loadSDOSBOData IN TARGET-PROCEDURE (INPUT pcParentNodeKey, INPUT pdChildNodeObj).
      RUN setDataLinks IN TARGET-PROCEDURE (INPUT "ACTIVE":U).
    END.
    WHEN "PRG":U THEN DO:
      RUN loadPRGData IN TARGET-PROCEDURE (INPUT pcParentNodeKey, INPUT pdChildNodeObj).
    END.
    WHEN "TXT":U THEN DO:
      RUN loadTXTData IN TARGET-PROCEDURE (INPUT pcParentNodeKey, INPUT pdChildNodeObj).
    END.
    WHEN "MNU":U THEN DO:
      RUN loadMNUData IN TARGET-PROCEDURE (INPUT pcParentNodeKey, INPUT pdChildNodeObj).
    END.
    OTHERWISE DO:
      RUN showMessages IN gshSessionManager (INPUT  SUBSTITUTE({fnarg messageNumber 86}, cDataSourceType),    /* message to display */
                                             INPUT  "ERR":U,          /* error type */
                                             INPUT  "&OK,&Cancel":U,    /* button list */
                                             INPUT  "&OK":U,           /* default button */ 
                                             INPUT  "&Cancel":U,       /* cancel button */
                                             INPUT  "Populate Tree Data":U,             /* error window title */
                                             INPUT  NO,              /* display if empty */ 
                                             INPUT  ?,                /* container handle */ 
                                             OUTPUT cButton           /* button pressed */
                                            ).
    END.
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadPRGData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadPRGData Procedure 
PROCEDURE loadPRGData :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will launch an external procedure on the AppServer
               to build the TreeView temp-table and returns the data to be used
               to populate the TreeView.
               with the data
  Parameters:  pcParentNodeKey - The parent node key - "" for Root
               pdChildNodeObj  - The Obj number of the child node found on gsm_node
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcParentNodeKey AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pdChildNodeObj  AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE cButton                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrorMessage           AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hBuf                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQry                    AS HANDLE     NO-UNDO.
                                         
  DEFINE VARIABLE lNodeChecked            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDataSource             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabelSubsFields        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cImageFileName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSelectedImageFileName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentNodeSDO          AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE hSDOHandle              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lHasChildren            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cPrimarySDO             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFilterValue            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSort                   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iStructLevel            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cValueList              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjField               AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bttNode FOR ttNode.
  
  
  IF pdChildNodeObj = 0 THEN
    RETURN.
  
  {get TreeViewOCX hTreeViewOCX}.
  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE NO-LOCK.
  ASSIGN lSort        = ttProp.lAutoSort
         cFilterValue = ttProp.cFilterData.

  FIND FIRST ttNode
       WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
       AND   ttNode.node_obj         = pdChildNodeObj
       EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE ttNode THEN
    RETURN.
  
  FIND FIRST bttNode
       WHERE bttNode.hTargetProcedure = TARGET-PROCEDURE
       AND   bttNode.parent_node_obj  = pdChildNodeObj
       NO-LOCK NO-ERROR.
  IF AVAILABLE bttNode THEN
    lHasChildren = TRUE.
  
  ASSIGN lNodeChecked            = ttNode.node_checked
         cDataSource             = ttNode.data_source
         cForeignFields          = ttNode.foreign_fields
         cImageFileName          = ttNode.image_file_name
         cSelectedImageFileName  = ttNode.selected_image_file_name
         cParentNodeSDO          = ttNode.primary_sdo
         cLabelSubsFields        = ttNode.label_text_substitution_fields
         cPrimarySDO             = ttNode.primary_sdo
         iStructLevel            = ttNode.iStrucLevel
         ttNode.data_source      = ttNode.primary_sdo
         ttNode.data_source_type = "SDO":U
         NO-ERROR.
  /* Start the associated SDO */
  SESSION:SET-WAIT-STATE("GENERAL":U).
  RUN manageSDOs IN TARGET-PROCEDURE 
                 (INPUT  cPrimarySDO,
                  INPUT  cForeignFields,
                  INPUT  "":U,
                  INPUT  cLabelSubsFields,
                  INPUT  FALSE,
                  INPUT  pdChildNodeObj,
                  INPUT  iStructLevel,
                  OUTPUT hSDOHandle).
    
  IF NOT VALID-HANDLE(hSDOHandle) THEN DO:
    SESSION:SET-WAIT-STATE("":U).
    RETURN.
  END.
  
  {get TreeDataTable hTable hTreeViewOCX}.  
  
  SESSION:SET-WAIT-STATE("GENERAL":U).
   
  /* Run the program to populate the data */
  {launch.i &PLIP  = cDataSource 
            &IPROC = 'loadData' 
            &ONAPP = 'YES'
            &PLIST = "(INPUT pcParentNodeKey, INPUT cParentNodeSDO, INPUT cFilterValue, INPUT-OUTPUT TABLE-HANDLE hTable)"
            &AUTOKILL = YES}
  IF ERROR-STATUS:ERROR THEN DO:
    SESSION:SET-WAIT-STATE("":U).
    cErrorMessage = SUBSTITUTE({fnarg MessageNumber 87}, cDataSource, ERROR-STATUS:GET-MESSAGE(1)) .
    RUN showMessages IN gshSessionManager (INPUT  cErrorMessage,            /* message to display */
                                           INPUT  "ERR":U,                  /* error type */
                                           INPUT  "&OK":U,                  /* button list */
                                           INPUT  "&OK":U,                  /* default button */ 
                                           INPUT  "&OK":U,                  /* cancel button */
                                           INPUT  "Error":U,                /* error window title */
                                           INPUT  YES,                      /* display if empty */ 
                                           INPUT  TARGET-PROCEDURE,           /* container handle */ 
                                           OUTPUT cButton                   /* button pressed */
                                          ).
    
    
    RETURN.
  END.

  ASSIGN cValueList = DYNAMIC-FUNCTION("getEntityName":U IN TARGET-PROCEDURE,hSDOHandle).
  IF LENGTH(TRIM(cValueList)) > 0 THEN 
    ASSIGN cObjField = DYNAMIC-FUNCTION("getObjKeyField":U IN TARGET-PROCEDURE,cValueList).

  ASSIGN hBuf = hTable:DEFAULT-BUFFER-HANDLE.
  CREATE QUERY hQry.
  hQry:ADD-BUFFER(hBuf).
  hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.parent_node_key = "&2":U AND &1.node_obj = 0 BY &1.node_key':U, hTable:NAME,pcParentNodeKey)).
  hQry:QUERY-OPEN().
  hQry:GET-FIRST().

  /* Now we'll just add the other data from the gsm_node record */
  DO WHILE hBuf:AVAILABLE:
    ASSIGN hBuf:BUFFER-FIELD('node_key':U):BUFFER-VALUE       = DYNAMIC-FUNCTION('getNextNodeKey':U IN hTreeViewOCX)
           hBuf:BUFFER-FIELD('node_obj':U):BUFFER-VALUE       = pdChildNodeObj
           hBuf:BUFFER-FIELD('node_checked':U):BUFFER-VALUE   = lNodeChecked
           hBuf:BUFFER-FIELD('image':U):BUFFER-VALUE          = IF hBuf:BUFFER-FIELD('image':U):BUFFER-VALUE = "":U OR hBuf:BUFFER-FIELD('image':U):BUFFER-VALUE = ? THEN cImageFileName ELSE hBuf:BUFFER-FIELD('image':U):BUFFER-VALUE
           hBuf:BUFFER-FIELD('selected_image':U):BUFFER-VALUE = IF hBuf:BUFFER-FIELD('selected_image':U):BUFFER-VALUE = "":U OR hBuf:BUFFER-FIELD('selected_image':U):BUFFER-VALUE = ? THEN cSelectedImageFileName ELSE hBuf:BUFFER-FIELD('selected_image':U):BUFFER-VALUE
           hBuf:BUFFER-FIELD('node_sort':U):BUFFER-VALUE      = lSort
           hBuf:BUFFER-FIELD('key_fields':U):BUFFER-VALUE     = cObjField
           hBuf:BUFFER-FIELD('node_type':U):BUFFER-VALUE      = "SDO":U
           hBuf:BUFFER-FIELD('sdo_handle':U):BUFFER-VALUE     = hSDOHandle
           hBuf:BUFFER-FIELD('node_insert':U):BUFFER-VALUE    = IF pcParentNodeKey = "":U THEN 1 ELSE 4.

    /* Create a Dummy Child node record */
    IF lHasChildren THEN
      RUN createDummyChild IN TARGET-PROCEDURE
                          (INPUT hBuf,
                           INPUT hBuf:BUFFER-FIELD('node_key':U):BUFFER-VALUE,
                           INPUT "DUMMY":U).
    hQry:GET-NEXT().
  END.
  SESSION:SET-WAIT-STATE("":U).

  IF VALID-HANDLE(hQry) THEN
    DELETE OBJECT hQry.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadSDOSBOData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadSDOSBOData Procedure 
PROCEDURE loadSDOSBOData :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will step through a SDO/SBO and populate the temp-table
               with the data
  Parameters:  pcParentNodeKey - The parent node key - "" for Root
               pdChildNodeObj  - The Obj number of the child node found on gsm_node
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcParentNodeKey AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pdChildNodeObj  AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE cDataset                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton                 AS CHARACTER  NO-UNDO.
  
  /* Define Temp-Table Variables */
  DEFINE VARIABLE hBuf                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQry                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRootParentNodeKey      AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cNodeLabel              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNodeChecked            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDataSource             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldToStore           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeLabelExpression    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabelSubsFields        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cImageFileName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSelectedImageFileName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dParentNodeObj          AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cParentNodeSDO          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iStructLevel            AS INTEGER    NO-UNDO.
  
  DEFINE VARIABLE cErrorMessage           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDOHandle              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cValueList              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTable                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjField               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cWhere                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lRowAvailable           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSubstitute             AS CHARACTER  NO-UNDO EXTENT 9.
  DEFINE VARIABLE lHasChildren            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cParentNodeKey          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeDetail             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dNodeObj                AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE rRecordRowid            AS ROWID      NO-UNDO.
  DEFINE VARIABLE cRecordRef              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cInstanceAttributes     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lStructuredNode         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSort                   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hFrame                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iRowsToBatch            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRecordsRead            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cHighChar               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLastSelectedNode       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTreeBuffer             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lMoreNode               AS LOGICAL    NO-UNDO.

  IF pdChildNodeObj = 0 AND 
     pcParentNodeKey <> "MORE":U THEN
    RETURN.

  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE NO-LOCK.
  ASSIGN lSort             = ttProp.lAutoSort
         hFrame            = ttProp.hCurrentFrame
         iRowsToBatch      = ttProp.iRowsToBatch
         cLastSelectedNode = ttProp.cCurrentNodeCode.
  
  {get TreeViewOCX hTreeViewOCX}.
  
  IF pcParentNodeKey = "MORE":U THEN
  DO:
    RUN returnTreeBuffer IN TARGET-PROCEDURE (INPUT cLastSelectedNode, OUTPUT hTreeBuffer).
    IF NOT VALID-HANDLE(hTreeBuffer) THEN
      RETURN.
    ASSIGN hSDOHandle      = hTreeBuffer:BUFFER-FIELD("sdo_handle":U):BUFFER-VALUE
           pcParentNodeKey = hTreeBuffer:BUFFER-FIELD("parent_node_key":U):BUFFER-VALUE
           pdChildNodeObj  = DECIMAL(hTreeBuffer:BUFFER-FIELD("node_obj":U):BUFFER-VALUE).
    DYNAMIC-FUNCTION("findRowWhere":U IN hSDOHandle, INPUT hTreeBuffer:BUFFER-FIELD("key_fields":U):BUFFER-VALUE, INPUT hTreeBuffer:BUFFER-FIELD("record_ref":U):BUFFER-VALUE, INPUT "":U).
    RUN deleteNode IN hTreeViewOCX (INPUT cLastSelectedNode).
    IF hTreeBuffer:AVAILABLE THEN
      hTreeBuffer:BUFFER-DELETE().
    ASSIGN lMoreNode         = TRUE
           cLastSelectedNode = "":U.
  END.

  FIND FIRST ttNode
       WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
       AND   ttNode.node_obj         = pdChildNodeObj
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ttNode THEN
    RETURN.
  
  IF CAN-FIND(FIRST ttNode
              WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
              AND   ttNode.parent_node_obj  = pdChildNodeObj NO-LOCK) THEN
    lHasChildren = TRUE.

  ASSIGN cNodeLabel             = ttNode.node_label
         lNodeChecked           = ttNode.node_checked
         cDataSource            = ttNode.data_source
         cFieldToStore          = ttNode.parent_node_filter + "^":U + ttNode.parent_field + "^":U + ttNode.child_field + "^":U + ttNode.data_type
         cNodeLabelExpression   = ttNode.node_text_label_expression
         cLabelSubsFields       = ttNode.label_text_substitution_fields
         cForeignFields         = ttNode.foreign_fields
         cImageFileName         = ttNode.image_file_name
         cSelectedImageFileName = ttNode.selected_image_file_name
         dParentNodeObj         = ttNode.parent_node_obj
         cInstanceAttributes    = ttNode.run_attribute
         lStructuredNode        = ttNode.structured_node
         iStructLevel           = ttNode.iStrucLevel
         NO-ERROR.

  /* Always assume children for structured Tree Nodes */
  IF lStructuredNode = TRUE THEN
    lHasChildren = TRUE.
  /* Get Parent Node Info */
  cDataset = "":U.
  FIND FIRST ttNode
       WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
       AND   ttNode.node_obj         = dParentNodeObj
       NO-LOCK NO-ERROR.
  ASSIGN cParentNodeSDO = "":U.
  IF AVAILABLE ttNode THEN
    ASSIGN cParentNodeSDO = IF ttNode.data_source_type <> "TXT":U AND ttNode.data_source_type <> "PRG":U THEN ttNode.data_source ELSE ttNode.primary_sdo.
           
  IF cDataSource = "":U OR 
     cDataSource = ? THEN
   RETURN.
  IF NOT VALID-HANDLE(hSDOHandle) THEN
    RUN manageSDOs IN TARGET-PROCEDURE 
                   (INPUT  cDataSource,
                    INPUT  cForeignFields,
                    INPUT  cParentNodeSDO,
                    INPUT  cLabelSubsFields,
                    INPUT  lStructuredNode,
                    INPUT  pdChildNodeObj,
                    INPUT  iStructLevel,
                    OUTPUT hSDOHandle).
  IF NOT VALID-HANDLE(hSDOHandle) THEN
    RETURN.
    
  IF NOT lMoreNode THEN
  DO:
    DYNAMIC-FUNCTION("CloseQuery":U IN hSDOHandle).
    /* Just get one more than the limit in order for us to see if we should add 
       a 'more...' node to expand the rest of the data */
    IF iRowsToBatch <> 0 THEN
      DYNAMIC-FUNCTION("setRowsToBatch":U IN hSDOHandle, iRowsToBatch + 1).
    ELSE
      DYNAMIC-FUNCTION("setRowsToBatch":U IN hSDOHandle, 0).
    DYNAMIC-FUNCTION("OpenQuery":U IN hSDOHandle).
  
    RUN fetchFirst IN hSDOHandle.
  END.

  {get TreeDataTable hTable hTreeViewOCX}.  
  /* Grab the handles to the individual fields in the tree data table. */
  ASSIGN hBuf = hTable:DEFAULT-BUFFER-HANDLE.

  cRootParentNodeKey = DYNAMIC-FUNCTION('getRootNodeParentKey':u IN hTreeViewOCX).

  ASSIGN cValueList = DYNAMIC-FUNCTION("getEntityName":U IN TARGET-PROCEDURE,hSDOHandle).

  IF cValueList = ? THEN DO:
    cErrorMessage = "No Entity Mnemonic detail for the table(s) in " + 
                    hSDOHandle:FILE-NAME + " could be found.~n" +
                    "Do an Entity Mnemonic Import of the appropriate table(s).~n~n" +
                    "NOTE:~n" +
                    "After doing an import you MUST trim the servers on your AppServer in order for the details to be cached.".

    RUN showMessages IN gshSessionManager (INPUT  cErrorMessage ,    /* message to display */
                                           INPUT  "ERR":U,          /* error type */
                                           INPUT  "&OK,&Cancel":U,    /* button list */
                                           INPUT  "&OK":U,           /* default button */ 
                                           INPUT  "&Cancel":U,       /* cancel button */
                                           INPUT  "Entity Mnemonic Detail Not Found":U,             /* error window title */
                                           INPUT  YES,              /* display if empty */ 
                                           INPUT  ?,                /* container handle */ 
                                           OUTPUT cButton           /* button pressed */
                                          ).
    RETURN.
  END.

  IF LENGTH(TRIM(cValueList)) > 0 THEN 
    ASSIGN cTable    = cValueList
           cObjField = DYNAMIC-FUNCTION("getObjKeyField":U IN TARGET-PROCEDURE,cValueList).


  lRowAvailable = DYNAMIC-FUNCTION("rowAvailable":U IN hSDOHandle, "CURRENT":U).
  IF NOT lRowAvailable THEN 
  DO:
    FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK.
    ttProp.lExpand = FALSE.
    RETURN.
  END.

  iRecordsRead = 1.
  RECORD_AVAILABLE:
  DO WHILE lRowAvailable = TRUE:
    DO iLoop = 1 TO NUM-ENTRIES(cLabelSubsFields):
      cSubstitute[iLoop] = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hSDOHandle, ENTRY(iLoop,cLabelSubsFields))).
      IF cSubstitute[iLoop] = ? THEN
        cSubstitute[iLoop] = "":U.
    END.
    
    cRecordRef = DYNAMIC-FUNCTION("assignRefValue":U IN TARGET-PROCEDURE, INPUT cObjField, INPUT hSDOHandle).
    /* check if the record exist */
    IF pcParentNodeKey = ? OR
       pcParentNodeKey = "?":U THEN
      pcParentNodeKey = cRootParentNodeKey.

    hBuf:FIND-FIRST("WHERE record_ref = '" + cRecordRef + "' AND parent_node_key = '" + pcParentNodeKey + "'":U) NO-ERROR.
    IF NOT hBuf:AVAILABLE THEN
    DO:
    hBuf:BUFFER-CREATE().
    ASSIGN hBuf:BUFFER-FIELD('parent_node_key':U):BUFFER-VALUE = pcParentNodeKey
           hBuf:BUFFER-FIELD('node_key':U):BUFFER-VALUE        = DYNAMIC-FUNCTION('getNextNodeKey':U IN hTreeViewOCX)
           hBuf:BUFFER-FIELD('node_obj':U):BUFFER-VALUE        = pdChildNodeObj
           hBuf:BUFFER-FIELD('node_label':U):BUFFER-VALUE      = TRIM(SUBSTITUTE(cNodeLabelExpression,cSubstitute[1],cSubstitute[2],cSubstitute[3],cSubstitute[4],cSubstitute[5],cSubstitute[6],cSubstitute[7],cSubstitute[8],cSubstitute[9]))
           hBuf:BUFFER-FIELD('key_fields':U):BUFFER-VALUE      = cObjField
           hBuf:BUFFER-FIELD('record_ref':U):BUFFER-VALUE      = cRecordRef
           hBuf:BUFFER-FIELD('record_rowid':U):BUFFER-VALUE    = TO-ROWID(ENTRY(1,DYNAMIC-FUNCTION("getRowIdent":U IN hSDOHandle)))
           hBuf:BUFFER-FIELD('node_checked':U):BUFFER-VALUE    = lNodeChecked
           hBuf:BUFFER-FIELD('image':U):BUFFER-VALUE           = TRIM(cImageFileName)
           hBuf:BUFFER-FIELD('selected_image':U):BUFFER-VALUE  = TRIM(cSelectedImageFileName)
           hBuf:BUFFER-FIELD('node_sort':U):BUFFER-VALUE       = lSort
           hBuf:BUFFER-FIELD('node_type':U):BUFFER-VALUE       = "SDO":U
           hBuf:BUFFER-FIELD('sdo_handle':U):BUFFER-VALUE      = hSDOHandle
           hBuf:BUFFER-FIELD('foreign_fields':U):BUFFER-VALUE  = DYNAMIC-FUNCTION("getForeignFields":U IN hSDOHandle)
           hBuf:BUFFER-FIELD('foreign_values':U):BUFFER-VALUE  = DYNAMIC-FUNCTION("getForeignValues":U IN hSDOHandle)
           hBuf:BUFFER-FIELD('node_insert':U):BUFFER-VALUE     = IF pcParentNodeKey = "":U THEN 1 ELSE 4.

      IF lMoreNode THEN
        cLastSelectedNode = hBuf:BUFFER-FIELD('node_key':U):BUFFER-VALUE.
      IF lMoreNode THEN
        RUN addNode IN hTreeViewOCX (INPUT hBuf).
      /* Create a Dummy Child node record */
      IF lHasChildren THEN
        RUN createDummyChild IN TARGET-PROCEDURE
                             (INPUT hBuf,
                              INPUT hBuf:BUFFER-FIELD('node_key':U):BUFFER-VALUE,
                              INPUT IF lMoreNode THEN "DUMMYADD":U ELSE "DUMMY":U).
    END.

    lRowAvailable = DYNAMIC-FUNCTION("rowAvailable":U IN hSDOHandle, "NEXT":U). 
    IF lRowAvailable THEN 
      RUN fetchNext IN hSDOHandle.
    ELSE 
      LEAVE RECORD_AVAILABLE.
    iRecordsRead = iRecordsRead + 1.
    IF iRowsToBatch > 0 AND iRecordsRead > iRowsToBatch THEN
    DO:
      cRecordRef = DYNAMIC-FUNCTION("assignRefValue":U IN TARGET-PROCEDURE, INPUT cObjField, INPUT hSDOHandle).
      hBuf:BUFFER-CREATE().
      ASSIGN hBuf:BUFFER-FIELD('parent_node_key':U):BUFFER-VALUE = pcParentNodeKey
             hBuf:BUFFER-FIELD('node_key':U):BUFFER-VALUE        = DYNAMIC-FUNCTION('getNextNodeKey':U IN hTreeViewOCX)
             hBuf:BUFFER-FIELD('node_obj':U):BUFFER-VALUE        = pdChildNodeObj
             hBuf:BUFFER-FIELD('node_label':U):BUFFER-VALUE      = "...More":U
             hBuf:BUFFER-FIELD('key_fields':U):BUFFER-VALUE      = cObjField
             hBuf:BUFFER-FIELD('record_ref':U):BUFFER-VALUE      = cRecordRef
             hBuf:BUFFER-FIELD('record_rowid':U):BUFFER-VALUE    = TO-ROWID(ENTRY(1,DYNAMIC-FUNCTION("getRowIdent":U IN hSDOHandle)))
             hBuf:BUFFER-FIELD('node_checked':U):BUFFER-VALUE    = lNodeChecked
             hBuf:BUFFER-FIELD('image':U):BUFFER-VALUE           = "ry/img/treemore.bmp"
             hBuf:BUFFER-FIELD('selected_image':U):BUFFER-VALUE  = "":U
             hBuf:BUFFER-FIELD('node_sort':U):BUFFER-VALUE       = FALSE
             hBuf:BUFFER-FIELD('node_type':U):BUFFER-VALUE       = "SDO":U
             hBuf:BUFFER-FIELD('sdo_handle':U):BUFFER-VALUE      = hSDOHandle
             hBuf:BUFFER-FIELD('foreign_fields':U):BUFFER-VALUE  = DYNAMIC-FUNCTION("getForeignFields":U IN hSDOHandle)
             hBuf:BUFFER-FIELD('foreign_values':U):BUFFER-VALUE  = DYNAMIC-FUNCTION("getForeignValues":U IN hSDOHandle)
             hBuf:BUFFER-FIELD('node_insert':U):BUFFER-VALUE     = IF pcParentNodeKey = "":U OR pcParentNodeKey = ? THEN 1 ELSE 4
             hBuf:BUFFER-FIELD('private_data':U):BUFFER-VALUE    = "@MORE":U.
      IF lMoreNode THEN
        RUN addNode IN hTreeViewOCX (INPUT hBuf).
      LEAVE RECORD_AVAILABLE.
    END.
  END. /* WHILE */

  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK.
  ttProp.lExpand = FALSE.
  
  IF lMoreNode THEN
    RETURN cLastSelectedNode.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadTreeData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadTreeData Procedure 
PROCEDURE loadTreeData :
/*------------------------------------------------------------------------------
  Purpose:     This procedure fetches the node detail from the server and returns
               it in a temp-table format.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRootNodeCode         AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE hTable                AS HANDLE     NO-UNDO. 
  DEFINE VARIABLE hBuf                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRootParentNodeKey    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataset              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dRootNodeObj          AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE cMode                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeKey              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dParentObj            AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX          AS HANDLE     NO-UNDO.

  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE NO-LOCK.
  cRootNodeCode = ttProp.cRootNodeCode.

  {get TreeViewOCX hTreeViewOCX}.

  IF ttProp.lFilterApplied = FALSE AND
     VALID-HANDLE(ttProp.hFilterViewer) THEN
    RETURN.
  
  cMode = DYNAMIC-FUNCTION("getUIBMode":U IN TARGET-PROCEDURE).
  
  IF cMode BEGINS 'design':u THEN
    RETURN.
  
/* Make sure that we have valid handles to the SmartTreeView and
  get the handle to the node temp-table */
  {get TreeDataTable hTable hTreeViewOCX}.

  IF NOT VALID-HANDLE(hTable) THEN DO:
    RUN showMessages IN gshSessionManager (INPUT  "Invalide Handle found for TreeData temp-table.",    /* message to display */
                                           INPUT  "ERR":U,          /* error type */
                                           INPUT  "&OK,&Cancel":U,  /* button list */
                                           INPUT  "&OK":U,          /* default button */ 
                                           INPUT  "&Cancel":U,      /* cancel button */
                                           INPUT  "Loading Data":U, /* error window title */
                                           INPUT  YES,              /* display if empty */ 
                                           INPUT  ?,                /* container handle */ 
                                           OUTPUT cButton           /* button pressed */
                                          ).
    
    RETURN.
  END.

  ASSIGN hBuf = hTable:DEFAULT-BUFFER-HANDLE.
  
  /* Clear the data from the TreeView */
  hBuf:EMPTY-TEMP-TABLE().
  RUN emptyTree IN hTreeViewOCX.
  
  IF NOT CAN-FIND(FIRST ttNode 
                  WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE NO-LOCK) THEN
    RUN ry/app/rytrenodep.p ON gshAstraAppServer (INPUT cRootNodeCode,
                                                  INPUT TARGET-PROCEDURE,
                                                  OUTPUT TABLE ttNode APPEND).
  IF CAN-FIND(FIRST ttNode
              WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
              AND   ttNode.structured_node  = TRUE) THEN
    RUN recurseStructuredNodes IN TARGET-PROCEDURE.
    
  FIND FIRST ttNode
       WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
       AND   ttNode.node_code        = cRootNodeCode 
       NO-LOCK NO-ERROR.

  IF NOT AVAILABLE ttNode THEN 
  DO:
    RUN showMessages IN gshSessionManager (INPUT  "The Root Node code specified could not be found! - " + cRootNodeCode,    /* message to display */
                                           INPUT  "ERR":U,          /* error type */
                                           INPUT  "&OK,&Cancel":U,  /* button list */
                                           INPUT  "&OK":U,          /* default button */ 
                                           INPUT  "&Cancel":U,      /* cancel button */
                                           INPUT  "Loading Data":U, /* error window title */
                                           INPUT  YES,              /* display if empty */ 
                                           INPUT  ?,                /* container handle */ 
                                           OUTPUT cButton           /* button pressed */
                                          ).
    RETURN.
  END.
  ELSE 
  DO:
    /* Check if the TreeView is used as a Menu Controller */
    IF ttNode.data_source_type = "MNU":U THEN
    DO:
      FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK.
      ASSIGN ttProp.lMenuTreeObject = TRUE.
    END.
  END.
  ASSIGN dRootNodeObj = ttNode.node_obj.
  
  RUN prepareNodeTranslation IN TARGET-PROCEDURE.
  RUN loadNodeData IN TARGET-PROCEDURE (INPUT "":U,INPUT dRootNodeObj).
  
  ASSIGN hBuf = hTable:DEFAULT-BUFFER-HANDLE.
  hBuf:FIND-FIRST() NO-ERROR.

  /* If we have records in the Tree - select the first */
  IF hBuf:AVAILABLE THEN
  DO:
    RUN populateTree IN hTreeViewOCX (INPUT hTable, INPUT "":U).
    RUN selectFirstNode IN hTreeViewOCX.
  
    cNodeKey = DYNAMIC-FUNCTION("getSelectedNode":U IN hTreeViewOCX).
    
    RUN tvNodeSelected IN TARGET-PROCEDURE (INPUT cNodeKey).
    
  END.
  /* If the Root Node doesn't have any records, launch the root node's 
     folder window in Add mode */
  ELSE DO:
    FIND FIRST ttNode
         WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
         AND   ttNode.node_obj         = dRootNodeObj
         NO-LOCK NO-ERROR.
    
    IF ttNode.data_source_type <> "MNU":U THEN
    DO:
      DYNAMIC-FUNCTION("lockWindow":U IN TARGET-PROCEDURE, INPUT TRUE).
      RUN createRepositoryObjects IN TARGET-PROCEDURE (INPUT ttNode.logical_object,
                                                       INPUT ttNode.primary_sdo,
                                                       INPUT ttNode.run_attribute,
                                                       INPUT ttNode.iStrucLevel,
                                                       INPUT ttNode.node_obj) NO-ERROR.  

      /* Set the last selected node */
      FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK.
      ttProp.dNewNodeObj = dRootNodeObj.
      /* Check if the title changed */
      IF VALID-HANDLE(ttProp.hCurrentFrame) THEN
        RUN updateFrameTitle IN TARGET-PROCEDURE (INPUT ttProp.hCurrentFrame).
      
      /* Put the object in ADD mode */
      FIND FIRST ttFrame
           WHERE ttFrame.hTargetProcedure = TARGET-PROCEDURE
           AND   ttFrame.hFrameHandle     = ttProp.hCurrentFrame
           EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE ttFrame THEN
        PUBLISH "addRecord":U FROM ttFrame.hFrameToolbar.
      DYNAMIC-FUNCTION("lockWindow":U IN TARGET-PROCEDURE, INPUT FALSE).
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadTXTData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadTXTData Procedure 
PROCEDURE loadTXTData :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will create a node with the specified text for that node
  Parameters:  pcParentNodeKey - The parent node key - "" for Root
               pdChildNodeObj  - The Obj number of the child node found on gsm_node
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcParentNodeKey AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pdChildNodeObj  AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE cDataset                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton                 AS CHARACTER  NO-UNDO.
  
  /* Define Temp-Table Variables */
  DEFINE VARIABLE hBuf                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable                  AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE cNodeLabel              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNodeChecked            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDataSource             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldToStore           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeLabelExpression    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabelSubsFields        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cImageFileName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSelectedImageFileName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dParentNodeObj          AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cParentNodeSDO          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lHasChildren            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lSort                   AS LOGICAL    NO-UNDO.

  DEFINE BUFFER bttNode FOR ttNode.

  IF pdChildNodeObj = 0 THEN
    RETURN.
  
  FIND FIRST ttNode
       WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
       AND   ttNode.node_obj         = pdChildNodeObj
       NO-LOCK NO-ERROR.

  FIND FIRST bttNode
       WHERE bttNode.hTargetProcedure = TARGET-PROCEDURE
       AND   bttNode.parent_node_obj  = pdChildNodeObj
       NO-LOCK NO-ERROR.
  IF AVAILABLE bttNode THEN
    lHasChildren = TRUE.
  
  IF NOT AVAILABLE ttNode THEN
    RETURN.
  
  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE NO-LOCK.
  lSort = ttProp.lAutoSort.
  
  ASSIGN cNodeLabel             = ttNode.node_label
         lNodeChecked           = ttNode.node_checked
         cDataSource            = ttNode.data_source
         cFieldToStore          = ttNode.parent_node_filter + "^":U + ttNode.parent_field + "^":U + ttNode.child_field + "^":U + ttNode.data_type
         cNodeLabelExpression   = ttNode.node_text_label_expression
         cLabelSubsFields       = ttNode.label_text_substitution_fields
         cForeignFields         = ttNode.foreign_fields
         cImageFileName         = ttNode.image_file_name
         cSelectedImageFileName = ttNode.selected_image_file_name
         dParentNodeObj         = ttNode.parent_node_obj
         NO-ERROR.
  
  /* Get Parent Node Info */
  cDataset = "":U.
  FIND FIRST ttNode
       WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
       AND   ttNode.node_obj         = dParentNodeObj
       NO-LOCK NO-ERROR.
  cParentNodeSDO = "":U.
  IF AVAILABLE ttNode THEN /* Check for Parent Node */
    ASSIGN cParentNodeSDO = ttNode.data_source.
  
  {get TreeViewOCX hTreeViewOCX}.

  {get TreeDataTable hTable hTreeViewOCX}.  
  /* Grab the handles to the individual fields in the tree data table. */
  ASSIGN hBuf = hTable:DEFAULT-BUFFER-HANDLE.
         
  hBuf:FIND-FIRST(SUBSTITUTE('WHERE &1.node_label = "&2" AND &1.parent_node_key = "&3":U':U, hTable:NAME,cDataSource,pcParentNodeKey)) NO-ERROR.

  IF NOT hBuf:AVAILABLE THEN DO:
      IF CAN-FIND(FIRST ttTranslate) THEN DO:
        FIND FIRST ttTranslate 
             WHERE ttTranslate.cWidgetName = "Node_":U + cDataSource
             AND   ttTranslate.cTranslatedLabel <> "":U
             NO-LOCK NO-ERROR.
        IF AVAILABLE ttTranslate THEN
          cDataSource = ttTranslate.cTranslatedLabel.
      END.
    hBuf:BUFFER-CREATE().
    ASSIGN hBuf:BUFFER-FIELD('parent_node_key':U):BUFFER-VALUE = pcParentNodeKey
           hBuf:BUFFER-FIELD('node_key':U):BUFFER-VALUE        = DYNAMIC-FUNCTION('getNextNodeKey':U IN hTreeViewOCX)
           hBuf:BUFFER-FIELD('node_obj':U):BUFFER-VALUE        = pdChildNodeObj
           hBuf:BUFFER-FIELD('node_label':U):BUFFER-VALUE      = cDataSource
           hBuf:BUFFER-FIELD('record_ref':U):BUFFER-VALUE      = "":U
           hBuf:BUFFER-FIELD('record_rowid':U):BUFFER-VALUE    = ?
           hBuf:BUFFER-FIELD('node_checked':U):BUFFER-VALUE    = lNodeChecked
           hBuf:BUFFER-FIELD('image':U):BUFFER-VALUE           = cImageFileName
           hBuf:BUFFER-FIELD('selected_image':U):BUFFER-VALUE  = cSelectedImageFileName
           hBuf:BUFFER-FIELD('node_sort':U):BUFFER-VALUE       = lSort
           hBuf:BUFFER-FIELD('node_type':U):BUFFER-VALUE       = "TXT":U
           hBuf:BUFFER-FIELD('node_insert':U):BUFFER-VALUE     = IF pcParentNodeKey = "":U THEN 1 ELSE 4.
   /* Create a Dummy Child node record */
   IF lHasChildren THEN
     RUN createDummyChild IN TARGET-PROCEDURE
                          (INPUT hBuf,
                           INPUT hBuf:BUFFER-FIELD('node_key':U):BUFFER-VALUE,
                           INPUT "DUMMY":U).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-manageSDOs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE manageSDOs Procedure 
PROCEDURE manageSDOs :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will initialize and SDO/SBO
  Parameters:  
  Notes:     I pcSDOSBOName      - The name of the SDO/SBO to be initialized
             I pcForeignFields   - The Foreign Fields to be used when initializing 
             I pcParentSDOSBO    - The name of the SDO/SBO (if any) of the parent node
             I pcLabelSubsFields - These fields will be used to SORT the SDO/SBO
             I plStructuredSDO   - When YES, indicates that the SDO being launched
                                   is an SDO of a structured nodes
             I pdNodeObj         - The node_obj of the SDO being launched's node
             I piStructLevel     - If this is an SDO of a structured node this
                                   would be the node level.
             O phSDOHandle       - The handle to the initialized SDO/SBO
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcSDOSBOName      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcForeignFields   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcParentSDOSBO    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcLabelSubsFields AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plStructuredSDO   AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdNodeObj         AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER piStructLevel     AS INTEGER    NO-UNDO.
  DEFINE OUTPUT PARAMETER phSDOHandle       AS HANDLE     NO-UNDO.

  DEFINE VARIABLE hParentSDO           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectPath          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFieldValues  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop                AS INTEGER    NO-UNDO.

  DEFINE VARIABLE cFilterString        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterFieldName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterFieldNameOnly AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterTableNameOnly AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterFieldValue    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterOperator      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryString         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAlreadyInQuery      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDoNotSetFilter      AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE cPrimarySDOName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterValue         AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cFirstFilter         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentField         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChildField          AS CHARACTER  NO-UNDO.
 
  DEFINE BUFFER buRunningSDOs      FOR ttRunningSDOs.
  
  IF pcSDOSBOName = "":U THEN
    RETURN.
  
  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE NO-LOCK.
  ASSIGN cPrimarySDOName = ttProp.cPrimarySDOName
         cFilterValue    = ttProp.cFilterData.
  
  /** First check that the SDO/SBO is relatively pathed **/
  IF INDEX(pcSDOSBOName,"/":U) = 0 AND
     INDEX(pcSDOSBOName,"~\":U) = 0 THEN DO:
      ASSIGN pcSDOSBOName = cPrimarySDOName.
  END.
  
  /* First Find the Parent SDO/SBO */
  hParentSDO = ?.
  FIND FIRST buRunningSDOs
       WHERE buRunningSDOs.hTargetProcedure = TARGET-PROCEDURE
       AND   buRunningSDOs.cSDOName         = pcParentSDOSBO
       AND   buRunningSDOs.iStrucLevel      = (IF piStructLevel >= 1 THEN piStructLevel - 1 ELSE 0)
       NO-LOCK NO-ERROR.
  IF AVAILABLE buRunningSDOs AND 
     VALID-HANDLE(buRunningSDOs.hSDOHandle) THEN
    ASSIGN hParentSDO = buRunningSDOs.hSDOHandle.
  /* See if the SDO is already running */
  FIND FIRST buRunningSDOs
       WHERE buRunningSDOs.hTargetProcedure = TARGET-PROCEDURE
       AND   buRunningSDOs.cSDOName         = pcSDOSBOName 
       AND   buRunningSDOs.iStrucLevel      = piStructLevel
       AND   buRunningSDOs.dNodeObj         = pdNodeObj
       EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE(buRunningSDOs) THEN 
  DO:
    ASSIGN
        cObjectName = pcSDOSBOName
        cObjectName = IF INDEX(cObjectName, "~\":U) <> 0 THEN REPLACE(cObjectName, "~\":U, "/":U) ELSE cObjectName
        cObjectName = SUBSTRING(cObjectName, R-INDEX(cObjectName, "/":U) + 1) NO-ERROR.
  
    RUN startDataObject IN gshRepositoryManager (INPUT cObjectName, OUTPUT phSDOHandle).
    
    /* Add a Container link so that the SDOs can take full advantage of the Data Container.
     */
    RUN addLink IN TARGET-PROCEDURE (INPUT TARGET-PROCEDURE, INPUT "Container":U , INPUT phSDOHandle).
    
    DYNAMIC-FUNCTION("setOpenOnInit":U IN phSDOHandle, FALSE).
    
    IF VALID-HANDLE(hParentSDO) THEN
      RUN addLink IN TARGET-PROCEDURE (INPUT hParentSDO, INPUT "Data":U , INPUT phSDOHandle).

    RUN initializeObject IN phSDOHandle.

    SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "cancelNew":U   IN phSDOHandle.
    SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "updateState":U IN phSDOHandle.
    
    CREATE buRunningSDOs.
    ASSIGN buRunningSDOs.hTargetProcedure = TARGET-PROCEDURE
           buRunningSDOs.cSDOName         = pcSDOSBOName
           buRunningSDOs.hSDOHandle       = phSDOHandle
           buRunningSDOs.iStrucLevel      = piStructLevel
           buRunningSDOs.dNodeObj         = pdNodeObj.
    SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "deleteComplete":U IN phSDOHandle.
  END.
  ELSE
    phSDOHandle = buRunningSDOs.hSDOHandle.

  /* Set the handle of the current SDO */
  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK.
  ASSIGN ttProp.cPrimarySDOName = pcSDOSBOName.
  
/* for fields */  
  IF cFilterValue <> "":U AND
     cFilterValue <> ?    AND
     VALID-HANDLE(phSDOHandle) THEN DO:
    ASSIGN cQueryString    = "":U.
           cQueryString    = DYNAMIC-FUNCTION("getQueryString":U IN phSDOHandle).
    DO iLoop = 1 TO NUM-ENTRIES(cFilterValue,CHR(1)):
      cFilterString = ENTRY(iLoop,cFilterValue,CHR(1)).
      /* This might look like a complicated way to retrieve the values specified     
        for the filter, but when this was initially designed I didn't take the      
        European numeric format into account and I used a ',' comma as the separator
        and the ENTRY function wouldn't work with our Obj fields.                   
        I had one of two choices:                                                   
        1. Update the document and change the way the filter viewer works and 
           we have compatibility issues; or 
        2. Change the TreeView (here) to accommodate with the -E format and no compatibility
           issues.
                                                                                    
        The later made more sense since it would only confuse all the users that    
        already started to use the filter viewer.                                   */
      IF NUM-ENTRIES(cFilterString) >= 3 THEN DO:
        ASSIGN cFilterFieldName  = ENTRY(1,cFilterString)
               cFilterFieldValue = SUBSTRING(cFilterString,INDEX(cFilterString,",":U,1) + 1,LENGTH(cFilterString))
               cFilterFieldValue = SUBSTRING(cFilterFieldValue,1,R-INDEX(cFilterFieldValue,",":U) - 1)
               cFilterOperator   = TRIM(SUBSTRING(cFilterString,R-INDEX(cFilterString,",":U) + 1,LENGTH(cFilterString)))
               NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          NEXT.
        
        IF cFilterOperator = "":U THEN
          cFilterOperator = "=":U.
      END.
      ELSE
        NEXT.
      cWhere = "":U.
      /* Make sure that the filter we are setting is not already in 
         the query string. We do not want to duplicate the filter */
      ASSIGN lAlreadyInQuery = FALSE
             lDoNotSetFilter = FALSE.

      IF INDEX(cQueryString,cFilterFieldName + " ":U + TRIM(cFilterOperator)) > 0 THEN
        lAlreadyInQuery = TRUE.
      /* Check the SDO if we can set the tree filter for this query */
      IF LOOKUP("noTreeFilter",phSDOHandle:INTERNAL-ENTRIES) > 0 THEN
        lDoNotSetFilter = TRUE.
      /* Strip field name ONLY from filter field name - tables or db names should
         not be included when checking if the field is available in the query */
      IF NUM-ENTRIES(cFilterFieldName,".":U) >= 2 THEN
        ASSIGN cFilterTableNameOnly = ENTRY(NUM-ENTRIES(cFilterFieldName,".":U) - 1,cFilterFieldName,".":U)
               cFilterFieldNameOnly = ENTRY(NUM-ENTRIES(cFilterFieldName,".":U),cFilterFieldName,".":U).
      ELSE
        ASSIGN cFilterTableNameOnly = "":U
               cFilterFieldNameOnly = cFilterFieldName.
      
      IF cFilterFieldNameOnly = "":U THEN
        cFilterFieldNameOnly = cFilterFieldName.
      IF (NUM-ENTRIES(cFilterFieldName,".":U) = 2 AND 
          DYNAMIC-FUNCTION("ColumnTable":U IN phSDOHandle, cFilterFieldNameOnly) = ENTRY(1,cFilterFieldName,".":U)) OR
         NUM-ENTRIES(cFilterFieldName,".":U) = 1 THEN DO:
        IF LOOKUP(cFilterFieldNameOnly,DYNAMIC-FUNCTION("getDataColumns":U IN phSDOHandle)) > 0 AND 
           NOT lAlreadyInQuery AND
           NOT lDoNotSetFilter THEN DO:
          DYNAMIC-FUNCTION("addQueryWhere":U IN phSDOHandle,INPUT cFilterFieldName + " ":U + TRIM(cFilterOperator) + " '" + cFilterFieldValue + "'", "":U, "AND":U).
          ASSIGN cWhere = cFilterFieldName + " ":U + cFilterTableNameOnly + TRIM(cFilterOperator) + " '" + cFilterFieldValue + "'" + CHR(3) + CHR(3) + "AND":U.
          cWhere = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, cWhere).
          {set manualAddQueryWhere cWhere phSDOHandle}.
        END.
      END.
    END.
  END.
    
  IF plStructuredSDO THEN 
  DO:
    FIND FIRST ttNode 
         WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
         AND   ttNode.node_obj         = pdNodeObj
         NO-LOCK NO-ERROR.
    ASSIGN cFirstFilter = ttNode.parent_node_filter
           cParentField = ttNode.parent_field
           cChildField  = ttNode.child_field.
    /* Check for first level in Structured Node */
    IF ttNode.iStrucLevel = 0 THEN
    DO:
      IF cFirstFilter <> "":U THEN DO:
      DYNAMIC-FUNCTION("addQueryWhere":U IN phSDOHandle,INPUT cFirstFilter,"":U, "AND":U).
        ASSIGN cWhere = cFirstFilter + CHR(3) + CHR(3) + "AND":U.
        cWhere = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, cWhere).
        {set manualAddQueryWhere cWhere phSDOHandle}.
      END.
    END. /* First Level Structured Node */
    ELSE
    DO:
      /* We'll add filtering on child Structure Nodes as foreign fields */
      IF VALID-HANDLE(hParentSDO) THEN
      DO:
        {get ForeignFields cForeignFields phSDOHandle}.
        IF LOOKUP(cChildField,cForeignFields) = 0 THEN
          ASSIGN cForeignFields = IF cForeignFields = "":U THEN cParentField + ",":U + cChildField
                                                           ELSE cForeignFields + ",":U + cParentField + ",":U + cChildField.
        {set ForeignFields cForeignFields phSDOHandle}.
        RUN dataAvailable IN phSDOHandle (INPUT "?":U).
      END.
    END. /* Not First Level in Structured Node */
  END. /* END STRUCTURED NODES */
  
  IF pcForeignFields <> "":U AND DYNAMIC-FUNCTION("getForeignFields":U IN phSDOHandle) = "":U THEN
    {set ForeignFields pcForeignFields phSDOHandle}.

  /* Set new foreign field values */
  IF pcForeignFields <> "":U THEN DO:
    cForeignFields = "":U.
    DO iLoop = 1 TO NUM-ENTRIES(pcForeignFields):
      cForeignFields = IF cForeignFields = "":U THEN ENTRY(iLoop + 1,pcForeignFields) ELSE cForeignFields + ",":U + ENTRY(iLoop + 1,pcForeignFields).
      iLoop = iLoop + 1.
    END.
    IF VALID-HANDLE(hParentSDO) THEN
      cForeignFieldValues = DYNAMIC-FUNCTION("columnStringValue":U IN hParentSDO, cForeignFields).
    DYNAMIC-FUNCTION("setForeignValues":U IN phSDOHandle, cForeignFieldValues).

    DYNAMIC-FUNCTION("setDataIsFetched":U IN phSDOHandle, FALSE).
    RUN dataAvailable IN phSDOHandle ("DIFFERENT":U).
  END.
  
  IF VALID-HANDLE(hParentSDO) THEN
    ASSIGN buRunningSDOs.hParentSDO = hParentSDO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-modifyFrameToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE modifyFrameToolbar Procedure 
PROCEDURE modifyFrameToolbar :
/*------------------------------------------------------------------------------
  Purpose:     Since we are trying to launch most existing objects we need to
               ensure we don't have any unsupported options available on the
               toolbar. When running a Dynamic TreeView we cannot support the
               Navigation of the SDO since this would require us to have to 
               reposition the nodes and since nodes can be sorted different
               to that of the data in the SDO that could cause some unwanted
               bahavior. We also don't want that extra Exit button on the frame's
               toolbar since that would just confuse the user.
               Also, when changes are made to the data in the viewer the 
               OK and Cancel text buttons also appears in the toolbar and we 
               need to disable these buttons too.
  Parameters:  pcToolbarHandle - A list of all handles on a frame launched in
                                 the createRepositoryObjects api.
               phSDOHandle     - The handle of the SDO that is the primary SDO
                                 of a frame launched in the createRepositoryObjects 
                                 api. 
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcToolbarHandles AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phSDOHandle      AS HANDLE     NO-UNDO.

  DEFINE VARIABLE iLoop               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hToolbar            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNavSource          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHiddenBands        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHiddenMenuBands    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHiddenActions      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNavigationExists   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hSDOHandle          AS HANDLE     NO-UNDO.

  /* Remove Navigation Toolbar/Menu bands and related actions 
     This is only done when the Toolbar has a Navigation link 
     to the primary SDO */
  DO iLoop = 1 TO NUM-ENTRIES(pcToolbarHandles):
    hToolbar = WIDGET-HANDLE(ENTRY(iLoop,pcToolbarHandles)) NO-ERROR.
    IF NOT VALID-HANDLE(hToolbar) THEN
      NEXT.
    /* We need to check for navigation links to our running SDOs and if 
       these links exist, we need to ensure that we remove the Nav buttons
       on the toolbar */
    ASSIGN cNavSource = DYNAMIC-FUNCTION("linkHandles" IN hToolbar, "Navigation-Target":U)
           hSDOHandle = WIDGET-HANDLE(ENTRY(1,cNavSource)) NO-ERROR.
    IF cNavSource <> "":U AND
       phSDOHandle = hSDOHandle AND
       LOOKUP("Navigation":U,cHiddenBands) = 0 THEN DO:
      {get HiddenToolbarBands cHiddenBands hToolbar}.
      cHiddenBands = IF cHiddenBands = "":U THEN "Navigation" ELSE cHiddenBands + ",Navigation".
      {set HiddenToolbarBands cHiddenBands hToolbar}.
      RUN viewHideActions IN hToolbar (INPUT "":U, INPUT "First,Prev,Next,Last").
      {get HiddenMenuBands cHiddenMenuBands hToolbar}.
      IF LOOKUP("Navigation":U,cHiddenMenuBands) = 0 THEN
        cHiddenMenuBands = IF cHiddenMenuBands = "":U THEN "Navigation":U ELSE cHiddenMenuBands + ",Navigation".
      {set HiddenMenuBands cHiddenMenuBands hToolbar}.
    END.
  END.

  hToolbar = WIDGET-HANDLE(ENTRY(1,pcToolbarHandles)) NO-ERROR.
  IF NOT VALID-HANDLE(hToolbar) THEN
    RETURN.
  
  {get HiddenToolbarBands cHiddenBands hToolbar}.
  /* If we didn't have a Navigation link then that doesn't mean we don't have
     navigation buttons and to avoid confusion and new issues we will get rid
     of these options right away */
  IF NOT lNavigationExists AND 
     LOOKUP("Navigation":U,cHiddenBands) = 0 THEN DO:
    cHiddenBands = IF cHiddenBands = "":U THEN "Navigation" ELSE cHiddenBands + ",Navigation".
  END.
  
  /* Also remove the TXTClose band */
  IF LOOKUP("TxtClose":U,cHiddenBands) = 0 THEN
    cHiddenBands = IF cHiddenBands = "":U THEN "TxtClose" ELSE cHiddenBands + ",TxtClose".
  
  {set HiddenToolbarBands cHiddenBands hToolbar}.
  
  /* Unhide the Delete option - we need it for TreeViews */
  {get HiddenActions cHiddenActions hToolbar}.
  IF LOOKUP("Delete":U, cHiddenActions) > 0 THEN
  DO:
    ASSIGN cHiddenActions = TRIM(REPLACE(cHiddenActions,"Delete":U,"":U)).
           cHiddenActions = TRIM(REPLACE(cHiddenActions,",,":U,",":U)).
    IF cHiddenActions = ",":U THEN
      cHiddenActions = "":U.
  END.
  {set HiddenActions cHiddenActions hToolbar}.

  /* Now hide all other actions we do not want on the toolbar of a frame
     in a TreeView Object */
  RUN viewHideActions IN hToolbar (INPUT "":U, INPUT "First,Prev,Next,Last,txtok,txtcancel,txtExit,txtHelp").
  
  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE NO-LOCK.
  FIND FIRST ttFrame
       WHERE ttFrame.hTargetProcedure = TARGET-PROCEDURE
       AND   ttFrame.hFrameHandle     = ttProp.hCurrentFrame
       EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE ttFrame THEN
    ASSIGN ttFrame.hFrameToolbar = hToolbar.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newRecordAdded) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE newRecordAdded Procedure 
PROCEDURE newRecordAdded :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is called from updateState when a new record was
               added. We now need to add a new node to the TreeView and do all
               the other stuff.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cParentNode           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDOHandle            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTreeTable            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTreeBuffer           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLabelSubsFields      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeLabelExpression  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSubstitute           AS CHARACTER  NO-UNDO EXTENT 9.
  DEFINE VARIABLE iLoop                 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cValueList            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjField             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRecordRef            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lHasChildren          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cNewNodeKey           AS CHARACTER  NO-UNDO.
  
  DEFINE BUFFER bttNode FOR ttNode.

  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE NO-LOCK.
  cParentNode = ttProp.cParentNode.

  FIND FIRST ttFrame
       WHERE ttFrame.hTargetProcedure = TARGET-PROCEDURE
       AND   ttFrame.hFrameHandle     = ttProp.hCurrentFrame
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ttFrame THEN
    RETURN.

  ASSIGN hSDOHandle = ttFrame.hDataSource.

  {get TreeViewOCX hTreeViewOCX}.
  {get TreeDataTable hTreeTable hTreeViewOCX}.
  ASSIGN hTreeBuffer = hTreeTable:DEFAULT-BUFFER-HANDLE.

  FIND FIRST ttNode
       WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
       AND   ttNode.node_obj         = ttProp.dNewNodeObj
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ttNode THEN
    FIND FIRST ttNode
         WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
         AND   ttNode.node_code        = ttProp.cRootNodeCode 
         NO-LOCK NO-ERROR.
  
  IF AVAILABLE ttNode THEN
    ASSIGN cLabelSubsFields     = ttNode.label_text_substitution_fields
           cNodeLabelExpression = ttNode.node_text_label_expression.
           
  IF CAN-FIND(FIRST bttNode
              WHERE bttNode.hTargetProcedure = TARGET-PROCEDURE
              AND   bttNode.parent_node_obj  = ttProp.dNewNodeObj NO-LOCK) OR
     ttNode.structured_node THEN
    lHasChildren = TRUE.
  
  ASSIGN cValueList = DYNAMIC-FUNCTION("getEntityName":U IN TARGET-PROCEDURE, INPUT hSDOHandle).
  
  IF LENGTH(TRIM(cValueList)) > 0 THEN 
    ASSIGN cObjField = DYNAMIC-FUNCTION("getObjKeyField":U IN TARGET-PROCEDURE, INPUT cValueList).
  
  /* This step is required since we might have caluclated fields that will only be refreshed
     on the 'DB Required' side and if this not done the correct value will not be displayed */
  RUN refreshRow IN hSDOHandle.
  LABEL_LOOP:
  DO iLoop = 1 TO NUM-ENTRIES(cLabelSubsFields):
    IF ENTRY(iLoop,cLabelSubsFields) = "":U THEN
      LEAVE LABEL_LOOP.
    cSubstitute[iLoop] = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hSDOHandle, ENTRY(iLoop,cLabelSubsFields))).
    IF cSubstitute[iLoop] = ? OR 
       cSubstitute[iLoop] = "":U THEN
      ASSIGN cSubstitute[iLoop] = "":U.
  END.

  cRecordRef = DYNAMIC-FUNCTION("assignRefValue":U IN TARGET-PROCEDURE, INPUT cObjField, INPUT hSDOHandle).
  /* Check if parent is Root Node */
  IF cParentNode = "":U THEN
    cParentNode = ?.

  hTreeBuffer:BUFFER-CREATE().
  ASSIGN hTreeBuffer:BUFFER-FIELD('parent_node_key':U):BUFFER-VALUE = cParentNode
         hTreeBuffer:BUFFER-FIELD('node_key':U):BUFFER-VALUE        = DYNAMIC-FUNCTION('getNextNodeKey':U IN hTreeViewOCX)
         hTreeBuffer:BUFFER-FIELD('node_obj':U):BUFFER-VALUE        = ttNode.node_obj
         hTreeBuffer:BUFFER-FIELD('node_label':U):BUFFER-VALUE      = TRIM(SUBSTITUTE(cNodeLabelExpression,cSubstitute[1],cSubstitute[2],cSubstitute[3],cSubstitute[4],cSubstitute[5],cSubstitute[6],cSubstitute[7],cSubstitute[8],cSubstitute[9]))
         hTreeBuffer:BUFFER-FIELD('key_fields':U):BUFFER-VALUE      = cObjField
         hTreeBuffer:BUFFER-FIELD('record_ref':U):BUFFER-VALUE      = cRecordRef
         hTreeBuffer:BUFFER-FIELD('record_rowid':U):BUFFER-VALUE    = TO-ROWID(ENTRY(1,DYNAMIC-FUNCTION("getRowIdent":U IN hSDOHandle)))
         hTreeBuffer:BUFFER-FIELD('node_checked':U):BUFFER-VALUE    = ttNode.node_checked
         hTreeBuffer:BUFFER-FIELD('image':U):BUFFER-VALUE           = ttNode.image_file_name
         hTreeBuffer:BUFFER-FIELD('selected_image':U):BUFFER-VALUE  = ttNode.selected_image_file_name
         hTreeBuffer:BUFFER-FIELD('node_sort':U):BUFFER-VALUE       = ttProp.lAutoSort
         hTreeBuffer:BUFFER-FIELD('node_type':U):BUFFER-VALUE       = ttNode.data_source_type
         hTreeBuffer:BUFFER-FIELD('sdo_handle':U):BUFFER-VALUE      = hSDOHandle
         hTreeBuffer:BUFFER-FIELD('foreign_fields':U):BUFFER-VALUE  = DYNAMIC-FUNCTION("getForeignFields":U IN hSDOHandle)
         hTreeBuffer:BUFFER-FIELD('foreign_values':U):BUFFER-VALUE  = DYNAMIC-FUNCTION("getForeignValues":U IN hSDOHandle)
         hTreeBuffer:BUFFER-FIELD('node_insert':U):BUFFER-VALUE     = IF cParentNode = "":U THEN 1 ELSE 4.

  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK.
  ASSIGN cNewNodeKey        = hTreeBuffer:BUFFER-FIELD('node_key':U):BUFFER-VALUE
         ttProp.cParentNode = cParentNode.

  hTreeBuffer:FIND-FIRST("WHERE node_key = '" + cNewNodeKey + "'":U).
  RUN addNode IN hTreeViewOCX (INPUT hTreeBuffer).


  /* Create a Dummy Child node record if the added node could have childreb*/
  IF lHasChildren THEN
    RUN createDummyChild IN TARGET-PROCEDURE
                         (INPUT hTreeBuffer,
                          INPUT cNewNodeKey,
                          INPUT "DUMMYADD":U).
  
  DYNAMIC-FUNCTION("setProperty":U IN hTreeViewOCX, INPUT "SELECTEDITEM":U, INPUT cNewNodeKey, INPUT "":U).
  RUN tvNodeSelected IN TARGET-PROCEDURE (INPUT cNewNodeKey).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-nodeAddRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nodeAddRecord Procedure 
PROCEDURE nodeAddRecord :
/*------------------------------------------------------------------------------
  Purpose:     When no child nodes are available, we want to launch the appropriate
               logical object in 'ADD' mode to allow the user to add the first 
               child node.
  Parameters:  pdNodObj - The node_obj of the node we want to add.
               pcParentNode - The parent key that should be assigned to the new
                              node being added.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdNodeObj     AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcParentNode  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lNoChildren             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cFirstChildNodeKey      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTreeTable              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuf                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNodeKey                AS CHARACTER  NO-UNDO.

  {get TreeViewOCX hTreeViewOCX}.

  /* If the node has children other than the first dummy record, first expand
     the node, select the first object so that the objects is instansiated and
     then publish the ADD event - this is a shortcut for expanding the node, 
     selecting the first one and then pressing the ADD icon from a users point of view */
  cFirstChildNodeKey = DYNAMIC-FUNCTION("getProperty" IN hTreeViewOCX, INPUT "CHILD":U, INPUT pcParentNode).
  IF DYNAMIC-FUNCTION("getProperty" IN hTreeViewOCX, INPUT "TEXT":U, INPUT cFirstChildNodeKey) = "+":U THEN
    RUN tvNodeEvent IN TARGET-PROCEDURE (INPUT "EXPAND", INPUT pcParentNode).

  lNoChildren = TRUE.
  /* Now check if the expanded node still has children, if not, we will have to do
     some other stuff to get the folder viewed and add a new record */
  IF INTEGER(DYNAMIC-FUNCTION("getProperty" IN hTreeViewOCX, "CHILDREN":U,pcParentNode)) > 0 THEN 
  DO:
    /* Now that we know we might have some child nodes we need to find if we at least
       have one of the child nodes that we are trying to add */
    {get TreeDataTable hTreeTable hTreeViewOCX}.
    IF VALID-HANDLE(hTreeTable) THEN
      hBuf = hTreeTable:DEFAULT-BUFFER-HANDLE.
    hBuf:FIND-FIRST("WHERE parent_node_key = '" + pcParentNode + "' AND node_obj = " + QUOTER(pdNodeObj)) NO-ERROR.
    IF NOT hBuf:AVAILABLE THEN
      lNoChildren = TRUE.
    ELSE 
    DO:
      lNoChildren = FALSE.
      /* Since we could find one of the nodes we wanted to add, we will select that
         node and then publish an Add event */
      cNodeKey = hBuf:BUFFER-FIELD("node_key":U):BUFFER-VALUE.
      DYNAMIC-FUNCTION("setProperty":U IN hTreeViewOCX, INPUT "SELECTEDITEM":U, INPUT cNodeKey, INPUT "":U).
      RUN tvNodeSelected IN TARGET-PROCEDURE (INPUT cNodeKey).
      
      FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK.
      ASSIGN ttProp.lNewChildNode = TRUE
             ttProp.cParentNode   = pcParentNode
             ttProp.dNewNodeObj   = pdNodeObj.
      FIND FIRST ttFrame
           WHERE ttFrame.hTargetProcedure = TARGET-PROCEDURE
           AND   ttFrame.hFrameHandle     = ttProp.hCurrentFrame
           EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE ttFrame THEN
        PUBLISH 'addRecord' FROM ttFrame.hFrameToolbar.
      RETURN.
    END.
  END.
  
  /* No children could be found - need to do some manual stuff */
  IF lNoChildren THEN
  DO:
    FIND FIRST ttNode
         WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
         AND   ttNode.node_obj         = pdNodeObj
         NO-LOCK NO-ERROR.
    /* This should never be true, just in case, we don't do anything */
    IF NOT AVAILABLE ttNode THEN
      RETURN.
    DYNAMIC-FUNCTION("lockWindow":U IN TARGET-PROCEDURE, INPUT TRUE).

    RUN createRepositoryObjects IN TARGET-PROCEDURE (INPUT ttNode.logical_object,
                                                     INPUT ttNode.primary_sdo,
                                                     INPUT ttNode.run_attribute,
                                                     INPUT ttNode.iStrucLevel,
                                                     INPUT ttNode.node_obj).


    FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK.
    ASSIGN ttProp.lNewChildNode = TRUE
           ttProp.cParentNode   = pcParentNode
           ttProp.dNewNodeObj   = pdNodeObj.
    FIND FIRST ttFrame
         WHERE ttFrame.hTargetProcedure = TARGET-PROCEDURE
         AND   ttFrame.hFrameHandle     = ttProp.hCurrentFrame
         EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE ttFrame THEN
      PUBLISH 'addRecord' FROM ttFrame.hFrameToolbar.
    DYNAMIC-FUNCTION("lockWindow":U IN TARGET-PROCEDURE, INPUT FALSE).
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-postCreateObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE postCreateObjects Procedure 
PROCEDURE postCreateObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       * This procedure runs after createObjects() and before initializeObject().
------------------------------------------------------------------------------*/    
    DEFINE VARIABLE hTreeviewComponent   AS HANDLE                     NO-UNDO.
            
    ASSIGN hTreeviewComponent = {fn getTreeviewOCX}.
    
    /* Only once the treeview component has been created can the initial sizes be 
       calculated. This is because the resize bar needs to be placed exactly next to 
       the treeview component - it is the one thing that is only moved by user interaction,
       not resizeWindow(). So we need to make sure that it is in the right place when the window
       is started, so that the packWindow and resizeWindow calls made by initializeObject
       in containr.p work properly.       
     */
    IF VALID-HANDLE(hTreeviewComponent) THEN
    do:
       /* Set minimum values for TreeView OCX */
       {set MinWidth 30 hTreeviewComponent}.
       {set MinHeight 6 hTreeviewComponent}.
       
       /* Set the minimum size of the treeview window, based
          on the user profile settings (if any) or hard-coded
          defaults, if there are no user profile settings.
        */
       RUN setTreeViewWidth IN TARGET-PROCEDURE.
    END.    /* valid TV */
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareNodeTranslation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prepareNodeTranslation Procedure 
PROCEDURE prepareNodeTranslation PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will step through all the Plain Text nodes and
               create a record in the translate temp-table to get the translated
               values back to be translated when creating these text nodes.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dCurrentLanguageObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cObjectName         AS CHARACTER  NO-UNDO.

  EMPTY TEMP-TABLE ttTranslate.

  dCurrentLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                INPUT "currentLanguageObj":U,
                                INPUT NO)).
  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE NO-LOCK.
  
  cObjectName = ttProp.cTreeLogicalObjectName.

  FOR EACH ttNode
      WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
      NO-LOCK:
    IF ttNode.data_source_type = "TXT":U THEN DO:
      CREATE ttTranslate.
      ASSIGN
        ttTranslate.dLanguageObj = dCurrentLanguageObj
        ttTranslate.cObjectName = cObjectName
        ttTranslate.lGlobal = NO
        ttTranslate.lDelete = NO
        ttTranslate.cWidgetType = "Node":U
        ttTranslate.cWidgetName = "Node_":U + ttNode.data_source
        ttTranslate.hWidgetHandle = ?
        ttTranslate.iWidgetEntry = 0
        ttTranslate.cOriginalLabel = ttNode.data_source
        ttTranslate.cTranslatedLabel = "":U
        ttTranslate.cOriginalTooltip = "":U
        ttTranslate.cTranslatedTooltip = "":U
        .
    END.
    CREATE ttTranslate.
    ASSIGN
      ttTranslate.dLanguageObj = dCurrentLanguageObj
      ttTranslate.cObjectName = cObjectName
      ttTranslate.lGlobal = NO
      ttTranslate.lDelete = NO
      ttTranslate.cWidgetType = "TREE_POPUP":U
      ttTranslate.cWidgetName = "POPUP_":U + "&Add ":U + ttNode.node_label
      ttTranslate.hWidgetHandle = ?
      ttTranslate.iWidgetEntry = 0
      ttTranslate.cOriginalLabel = "&Add ":U + ttNode.node_label
      ttTranslate.cTranslatedLabel = "":U
      ttTranslate.cOriginalTooltip = "":U
      ttTranslate.cTranslatedTooltip = "":U
      .

  END.
  
  RUN multiTranslation IN gshTranslationManager (INPUT NO,
                                                 INPUT-OUTPUT TABLE ttTranslate).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-recordUpdated) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recordUpdated Procedure 
PROCEDURE recordUpdated :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is called from updateState when a record was
               modified. We now need to update the node in the TreeView and do 
               all the other stuff.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCurrentNode          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDOHandle            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTreeBuffer           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLabelSubsFields      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeLabelExpression  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSubstitute           AS CHARACTER  NO-UNDO EXTENT 9.
  DEFINE VARIABLE iLoop                 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX          AS HANDLE     NO-UNDO.

  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE NO-LOCK.
  cCurrentNode = ttProp.cCurrentNodeCode.

  FIND FIRST ttFrame
       WHERE ttFrame.hTargetProcedure = TARGET-PROCEDURE
       AND   ttFrame.hFrameHandle     = ttProp.hCurrentFrame
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ttFrame THEN
    RETURN.

  ASSIGN hSDOHandle = ttFrame.hDataSource.

  RUN returnTreeBuffer IN TARGET-PROCEDURE (INPUT cCurrentNode, OUTPUT hTreeBuffer).
  IF NOT hTreeBuffer:AVAILABLE THEN
    RETURN.

  {get TreeViewOCX hTreeViewOCX}.

  FIND FIRST ttNode
       WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
       AND   ttNode.node_obj         = DECIMAL(hTreeBuffer:BUFFER-FIELD("node_obj":U):BUFFER-VALUE)
       NO-LOCK NO-ERROR.
  IF AVAILABLE ttNode THEN
    ASSIGN cLabelSubsFields     = ttNode.label_text_substitution_fields
           cNodeLabelExpression = ttNode.node_text_label_expression.
           
  /* This step is required since we might have caluclated fields that will only be refreshed
     on the 'DB Required' side and if this not done the correct value will not be displayed */
  RUN refreshRow IN hSDOHandle.
  LABEL_LOOP:
  DO iLoop = 1 TO NUM-ENTRIES(cLabelSubsFields):
    IF ENTRY(iLoop,cLabelSubsFields) = "":U THEN
      LEAVE LABEL_LOOP.
    cSubstitute[iLoop] = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hSDOHandle, ENTRY(iLoop,cLabelSubsFields))).
    IF cSubstitute[iLoop] = ? OR 
       cSubstitute[iLoop] = "":U THEN
      ASSIGN cSubstitute[iLoop] = "":U.
  END.

  /* Change the data in the Tree table */
  hTreeBuffer:BUFFER-FIELD('node_label':U):BUFFER-VALUE = TRIM(SUBSTITUTE(cNodeLabelExpression,cSubstitute[1],cSubstitute[2],cSubstitute[3],cSubstitute[4],cSubstitute[5],cSubstitute[6],cSubstitute[7],cSubstitute[8],cSubstitute[9])).
  /* Now update the actual node text in the Tree */
  DYNAMIC-FUNCTION("setProperty":U IN hTreeViewOCX, INPUT "TEXT":U, INPUT cCurrentNode, INPUT hTreeBuffer:BUFFER-FIELD('node_label':U):BUFFER-VALUE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-recurseStructuredNodes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recurseStructuredNodes Procedure 
PROCEDURE recurseStructuredNodes :
/*------------------------------------------------------------------------------
  Purpose:     Thus procedure will recurse through structured nodes and create
               30 copies of them. This removes code complication for checking 
               for structured nodes and allows the TreeView to see a structured
               node as just another SDO node.
  Parameters:  <none>
  Notes:       A pre-processor variable is used to identify the number of levels
               to create. This variable is called 'NUM-STRUC-COPIES' and is set
               to 30.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iLoop AS INTEGER    NO-UNDO.

  DEFINE BUFFER bttNode FOR ttNode.

  FOR EACH  ttNode
      WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
      AND   ttNode.structured_node  = TRUE
      AND   ttNode.iStrucLevel      = 0
      NO-LOCK:
    DO iLoop = 1 TO {&NUM-STRUC-COPIES}:
      CREATE bttNode.
      BUFFER-COPY ttNode EXCEPT ttNode.node_obj ttNode.node_code
               TO bttNode.
      ASSIGN bttNode.dOrigStrucNodeObj = ttNode.node_obj
             bttNode.parent_node_obj   = ttNode.node_obj
             bttNode.iStrucLevel       = iLoop
             bttNode.node_code         = ttNode.node_code + "_":U + STRING(iLoop).
             bttNode.node_obj          = DYNAMIC-FUNCTION("assignTempObjNumber":U IN TARGET-PROCEDURE).
    END.
  END.

  /* Now add the structured nodes as children to themself */
  FOR EACH  ttNode
      WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
      AND   ttNode.structured_node  = TRUE
      AND   ttNode.iStrucLevel      > 0
      EXCLUSIVE-LOCK:
    IF ttNode.iStrucLevel = 1 THEN
      NEXT.
    FIND FIRST bttNode
         WHERE bttNode.hTargetProcedure  = TARGET-PROCEDURE
         AND   bttNode.dOrigStrucNodeObj = ttNode.dOrigStrucNodeObj
         AND   bttNode.structured_node   = TRUE
         AND   bttNode.iStrucLevel       = ttNode.iStrucLevel - 1
         NO-LOCK NO-ERROR.
    IF AVAILABLE bttNode THEN
      ASSIGN ttNode.parent_node_obj = bttNode.node_obj.
  END.

  /* Now add the child nodes of structuted nodes */
  FOR EACH  ttNode
      WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
      AND   ttNode.structured_node  = TRUE
      AND   ttNode.iStrucLevel      > 0
      NO-LOCK:
    RUN addStrucNodeChildren IN TARGET-PROCEDURE (INPUT ttNode.dOrigStrucNodeObj,
                                                  INPUT ttNode.node_obj,
                                                  INPUT ttNode.iStrucLevel).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionSDO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionSDO Procedure 
PROCEDURE repositionSDO :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will reposition an SDO to a selected record
  Parameters:  pcNodeKey - The node key of the node to be repositioned to.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcNodeKey AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hDataTableBuf   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hParentSDO      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iNodeLevel      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cParentNode     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryPosition  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hNodeSDO        AS HANDLE     NO-UNDO.

  RUN returnTreeBuffer IN TARGET-PROCEDURE (INPUT pcNodeKey, OUTPUT hDataTableBuf).

  IF NOT hDataTableBuf:AVAILABLE THEN
    RETURN.
  
  {get TreeViewOCX hTreeViewOCX}.
  
  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE NO-LOCK.
  /* If we the TreeView is used as a Menu Controller then we don't need to 
     reposition any SDO */
  IF ttProp.lMenuTreeObject = TRUE THEN
    RETURN.
  hNodeSDO = hDataTableBuf:BUFFER-FIELD("sdo_handle":U):BUFFER-VALUE.

  /* If they are on the same level or the node is in the root level, just reposition */
  IF (ttProp.cParentNode = hDataTableBuf:BUFFER-FIELD("parent_node_key":U):BUFFER-VALUE OR 
      hDataTableBuf:BUFFER-FIELD("parent_node_key":U):BUFFER-VALUE = ?) AND /* Root Node Level */
      VALID-HANDLE(hNodeSDO) THEN 
    DYNAMIC-FUNCTION("findRowWhere":U IN hNodeSDO, INPUT hDataTableBuf:BUFFER-FIELD("key_fields":U):BUFFER-VALUE, INPUT hDataTableBuf:BUFFER-FIELD("record_ref":U):BUFFER-VALUE, INPUT "":U).
  ELSE /* If not, then we need to step up the Tree and reposition all parent nodes */
  DO:
    /* All SDOs in the hierarchy is linked by a Data link and we can get all 
       parent SDOs by getting their DataSource object. The first step will
       be to build a hierarchy level in order for us to move from the top
       level down */
   
    /* We need to check that the node we are trying to reposition to is not a TXT Node,
       if this is the case, we need to find the first parent node where we have an SDO */
    IF NOT VALID-HANDLE(hNodeSDO) THEN
    DO:
      cParentNode = DYNAMIC-FUNCTION("getProperty":U IN hTreeViewOCX, INPUT "PARENT":U, pcNodeKey).
      LOOK_FOR_NON_TXT_NODE:
      REPEAT:
        RUN returnTreeBuffer IN TARGET-PROCEDURE (INPUT cParentNode, OUTPUT hDataTableBuf).
        IF NOT hDataTableBuf:AVAILABLE THEN
          LEAVE LOOK_FOR_NON_TXT_NODE.
        IF hDataTableBuf:AVAILABLE AND 
           hDataTableBuf:BUFFER-FIELD("node_type":U):BUFFER-VALUE <> "TXT":U THEN
          LEAVE LOOK_FOR_NON_TXT_NODE.
        cParentNode = DYNAMIC-FUNCTION("getProperty":U IN hTreeViewOCX, INPUT "PARENT":U, cParentNode).
      END.
      IF hDataTableBuf:AVAILABLE THEN
        hParentSDO = hDataTableBuf:BUFFER-FIELD("sdo_handle":U):BUFFER-VALUE.
    END.
    ELSE 
    DO:
      cParentNode = DYNAMIC-FUNCTION("getProperty":U IN hTreeViewOCX, INPUT "PARENT":U, pcNodeKey).
      {get DataSource hParentSDO hNodeSDO}.
    END.

    RUN setDataLinks IN TARGET-PROCEDURE ("INACTIVE":U).
    iNodeLevel = 0.
    DO WHILE VALID-HANDLE(hParentSDO):
      iNodeLevel = iNodeLevel + 1.
      RUN returnTreeBuffer IN TARGET-PROCEDURE (INPUT cParentNode, OUTPUT hDataTableBuf).
      IF hDataTableBuf:AVAILABLE THEN 
      DO:
        /* Check if the Parent Node Key is not that of a TXT node */
        IF hDataTableBuf:BUFFER-FIELD("node_type":U):BUFFER-VALUE = "TXT":U THEN
        DO:
          LOOK_FOR_NON_TXT_NODE:
          REPEAT:
            cParentNode = DYNAMIC-FUNCTION("getProperty":U IN hTreeViewOCX, INPUT "PARENT":U, cParentNode).
            RUN returnTreeBuffer IN TARGET-PROCEDURE (INPUT cParentNode, OUTPUT hDataTableBuf).
            IF NOT hDataTableBuf:AVAILABLE THEN
              LEAVE LOOK_FOR_NON_TXT_NODE.
            IF hDataTableBuf:AVAILABLE AND 
               hDataTableBuf:BUFFER-FIELD("node_type":U):BUFFER-VALUE <> "TXT":U THEN
              LEAVE LOOK_FOR_NON_TXT_NODE.
          END.
          /* Check if we could find any non TXT Nodes */
          IF NOT hDataTableBuf:AVAILABLE THEN 
            RETURN.
        END.
        CREATE ttParentStructure.
        ASSIGN ttParentStructure.hTargetProcedure = TARGET-PROCEDURE
               ttParentStructure.hParentSDO       = hParentSDO
               ttParentStructure.cParentNodeKey   = cParentNode
               ttParentStructure.cKeyFields       = hDataTableBuf:BUFFER-FIELD("key_fields":U):BUFFER-VALUE
               ttParentStructure.cKeyFieldValues  = hDataTableBuf:BUFFER-FIELD("record_ref":U):BUFFER-VALUE
               ttParentStructure.rRowid           = hDataTableBuf:BUFFER-FIELD("record_rowid":U):BUFFER-VALUE
               ttParentStructure.iLevel           = iNodeLevel.
      END.
      {get DataSource hParentSDO hParentSDO}.
      cParentNode = DYNAMIC-FUNCTION("getProperty":U IN hTreeViewOCX, INPUT "PARENT":U, cParentNode).
    END.
    
    /* Now that we have a parent node structure, start repositioning */
    FOR EACH ttParentStructure
        BY   ttParentStructure.iLevel DESCENDING:
      RUN dataAvailable IN ttParentStructure.hParentSDO (INPUT "RESET":U).
      DYNAMIC-FUNCTION("findRowWhere":U IN ttParentStructure.hParentSDO, INPUT ttParentStructure.cKeyFields, INPUT ttParentStructure.cKeyFieldValues, INPUT "":U).
      DELETE ttParentStructure.
    END.
    
    /* Now ensure we set the correct foreign fields for the current SDO */
    RUN returnTreeBuffer IN TARGET-PROCEDURE (INPUT pcNodeKey, OUTPUT hDataTableBuf).
    
    /* Lastly, reposition to the node selected */
    IF VALID-HANDLE(hNodeSDO) THEN 
    DO:
      RUN dataAvailable IN hNodeSDO (INPUT "RESET":U).
      DYNAMIC-FUNCTION("findRowWhere":U IN hNodeSDO, INPUT hDataTableBuf:BUFFER-FIELD("key_fields":U):BUFFER-VALUE, INPUT hDataTableBuf:BUFFER-FIELD("record_ref":U):BUFFER-VALUE, INPUT "":U).
    END.
    
    RUN setDataLinks IN TARGET-PROCEDURE ("ACTIVE":U).
    
    /* Refresh visual objects */
    IF VALID-HANDLE(hNodeSDO) THEN 
    DO:
      {get QueryPosition cQueryPosition hNodeSDO}.
      PUBLISH "queryPosition":U FROM hNodeSDO (INPUT cQueryPosition).
      PUBLISH "dataAvailable":U FROM hNodeSDO (INPUT "SAME":U).
    END.
  END.
  
  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK.
  ASSIGN ttProp.cParentNode = DYNAMIC-FUNCTION("getProperty":U IN hTreeViewOCX, INPUT "PARENT":U, INPUT pcNodeKey).
  IF ttProp.cParentNode = "":U THEN
    ttProp.cParentNode = ?.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetRecord Procedure 
PROCEDURE resetRecord :
/*------------------------------------------------------------------------------
  Purpose:     The toolbar that is responsible for maintaining data in the 
               launched SDO will publish this event and this allows us to 
               know if an Add or Copy is being cancelled.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK.
  ttProp.lResetRecord = TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-returnTreeBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnTreeBuffer Procedure 
PROCEDURE returnTreeBuffer :
/*------------------------------------------------------------------------------
  Purpose:     This procedure receives a nodekey and will attempt to find the
               record in the TreeDataTable and return the buffer handle.
  Parameters:  pcNodeKey - The node key for which the buffer record should be 
                           found.
               phBuffer - The singe buffer record (if available) that could be
                          found for the pcNodeKey specified.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcNodeKey AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER phBuffer  AS HANDLE     NO-UNDO.

  DEFINE VARIABLE hTreeViewOCX      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTreeDataTable    AS HANDLE     NO-UNDO.

  {get TreeViewOCX hTreeViewOCX}.
  {get TreeDataTable hTreeDataTable hTreeViewOCX}.

  ASSIGN phBuffer = hTreeDataTable:DEFAULT-BUFFER-HANDLE.
  
  phBuffer:FIND-FIRST("WHERE node_key = '" + pcNodeKey + "'":U) NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-saveTreeViewWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveTreeViewWidth Procedure 
PROCEDURE saveTreeViewWidth :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is called when the TreeView container is close. 
               This procedure will save the column position of the resize bar
               for this TreeView object to be positioned back to the last time
               it was closed.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lSaveWindowPos      AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE cProfileData        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE rProfileRid         AS ROWID        NO-UNDO.
  DEFINE VARIABLE hResizeBar          AS HANDLE       NO-UNDO.
  DEFINE VARIABLE cObjectName         AS CHARACTER    NO-UNDO.
  
  ASSIGN lSaveWindowPos = NO.

  /* We have to check if this handle is valid since it might 
    have been killed if a developer was running something
    and closed the AppBuilder and it then attempts to close
    down any running containers. */
  IF VALID-HANDLE(gshProfileManager) THEN
   RUN getProfileData IN gshProfileManager (INPUT "Window":U,
                                            INPUT "SaveSizPos":U,
                                            INPUT "SaveSizPos":U,
                                            INPUT NO,
                                            INPUT-OUTPUT rProfileRid,
                                            OUTPUT cProfileData).
  ASSIGN
    lSaveWindowPos = cProfileData <> "NO":U.

  /* Only position and size if asked to */
  IF lSaveWindowPos THEN 
  DO:
    {get ResizeBar hResizeBar}.
    FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE NO-LOCK.
    cObjectName = ttProp.cTreeLogicalObjectName.
    ASSIGN
      cProfileData = REPLACE(STRING(hResizeBar:COL), SESSION:NUMERIC-DECIMAL-POINT, ".":U).
  
    IF cProfileData <> "":U AND LENGTH(cObjectName) > 0 THEN DO:
     /* We have to check if this handle is valid since it might 
        have been killed if a developer was running something
        and closed the AppBuilder and it then attempts to close
        down any running containers. */
     IF VALID-HANDLE(gshProfileManager) THEN
       RUN setProfileData IN gshProfileManager (INPUT "Window":U,          /* Profile type code */
                                                INPUT "DynTVSize":U,         /* Profile code */
                                                INPUT cObjectName,         /* Profile data key */
                                                INPUT ?,                   /* Rowid of profile data */
                                                INPUT cProfileData,        /* Profile data value */
                                                INPUT NO,                  /* Delete flag */
                                                INPUT "PER":u).            /* Save flag (permanent) */
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-saveWindowDimensions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveWindowDimensions Procedure 
PROCEDURE saveWindowDimensions :
/*------------------------------------------------------------------------------
  Purpose:     Eventhough this is done in the destroyObject we are doing it here
               since destroyObject is getting the incorrect window handle
               when saving the window dimensions for the TreeView Object. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjectname    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lSaveWindowPos AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE cProfileData   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE rProfileRid    AS ROWID        NO-UNDO.
  DEFINE VARIABLE hWindow        AS HANDLE       NO-UNDO.

 ASSIGN lSaveWindowPos = NO.

 {get ContainerHandle hWindow}.

 IF VALID-HANDLE(hWindow) AND CAN-QUERY(hWindow, "window-state":U) AND 
    (hWindow:WINDOW-STATE EQ WINDOW-NORMAL OR hWindow:WINDOW-STATE EQ WINDOW-MAXIMIZED) THEN
     /* THis property is set by the container window super procedure rydyncontp.p in updateWindowSizes */
     ASSIGN lSaveWindowPos = LOGICAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, INPUT "SaveWindowPos":U))
            NO-ERROR.

 /* Only position and size if asked to */
 IF lSaveWindowPos THEN
 DO:
     IF hWindow:WINDOW-STATE EQ WINDOW-MAXIMIZED THEN
         ASSIGN cProfileData = "WINDOW-MAXIMIZED":U.
     ELSE
         /* Always store decimal values as if they were in American numeric format.
          * When retrieving decimal values, we need to convert to the current
          * SESSION:NUMERIC-DECIMAL-POINT.                                         */
         ASSIGN cProfileData = REPLACE(STRING(hWindow:COLUMN),       SESSION:NUMERIC-DECIMAL-POINT, ".":U) + CHR(3)
                             + REPLACE(STRING(hWindow:ROW),          SESSION:NUMERIC-DECIMAL-POINT, ".":U) + CHR(3)
                             + REPLACE(STRING(hWindow:WIDTH-CHARS),  SESSION:NUMERIC-DECIMAL-POINT, ".":U) + CHR(3)
                             + REPLACE(STRING(hWindow:HEIGHT-CHARS), SESSION:NUMERIC-DECIMAL-POINT, ".":U)
                .
     FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE NO-LOCK.
     cObjectName = ttProp.cTreeLogicalObjectName.
    
   IF LENGTH(cObjectName) > 0 THEN
   DO:
     /* We have to check if this handle is valid since it might 
        have been killed if a developer was running something
        and closed the AppBuilder and it then attempts to close
        down any running containers. */
     IF VALID-HANDLE(gshProfileManager) THEN
       RUN setProfileData IN gshProfileManager (INPUT "Window":U,          /* Profile type code */
                                                INPUT "SizePos":U,         /* Profile code */
                                                INPUT cObjectName,         /* Profile data key */
                                                INPUT ?,                   /* Rowid of profile data */
                                                INPUT cProfileData,        /* Profile data value */
                                                INPUT NO,                  /* Delete flag */
                                                INPUT "PER":u).            /* Save flag (permanent) */
   END.     /* have an object name */
 END.   /* save window positions/size */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDataLinks Procedure 
PROCEDURE setDataLinks :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will active or deactivate all data links from 
               all SDOs running in the TreeView
  Parameters:  pcState - The state to set the Data Links to. Valid values for
                         this parameter is 'INACTIVE' - This will remove all data
                         links from all visualization object such as viewers.
                         'ACTIVE' - This will recreate data links to all visual
                         objects where these links were removed when they were
                         made inactive.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcState AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE iLoop         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTargetHandle AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataLinks    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectType   AS CHARACTER  NO-UNDO.

  DEFINE BUFFER sdlSDO FOR ttRunningSDOs.

  /* First check if the state has already been set */
  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE NO-LOCK.
  IF ttProp.cDataLinks = pcState THEN
    RETURN.

  IF pcState = "INACTIVE":U THEN
  DO:
    FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK.
    ASSIGN ttProp.cDataLinks = pcState.
    FOR EACH  sdlSDO
        WHERE sdlSDO.hTargetProcedure = TARGET-PROCEDURE
        AND   VALID-HANDLE(sdlSDO.hSDOHandle)
        NO-LOCK:
      cDataLinks = DYNAMIC-FUNCTION("linkHandles":U IN sdlSDO.hSDOHandle, "Data-Target":U).
      DO iLoop = 1 TO NUM-ENTRIES(cDataLinks):
        hTargetHandle = WIDGET-HANDLE(ENTRY(iLoop,cDataLinks)).
       cObjectType = DYNAMIC-FUNCTION("getObjectType":U IN hTargetHandle).
       /* Do not disable Data links to SDOs */
       IF cObjectType <> "SmartDataObject":U THEN
       DO:
         CREATE ttDataLinks.
         ASSIGN ttDataLinks.hTargetProcedure = TARGET-PROCEDURE
                ttDataLinks.hSourceHandle    = sdlSDO.hSDOHandle
                ttDataLinks.hTargetHandle    = hTargetHandle.
         RUN removeLink IN TARGET-PROCEDURE (INPUT sdlSDO.hSDOHandle, 
                                             INPUT "Data":U,
                                             INPUT hTargetHandle).
       END. /* Not an SDO */
      END. /* DO iLoop */
    END. /* EACH sdlSDO */
  END.
  ELSE /* Activate Links */
  DO:
    FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK.
    ASSIGN ttProp.cDataLinks = pcState.
    FOR EACH  ttDataLinks
        WHERE ttDataLinks.hTargetProcedure = TARGET-PROCEDURE
        EXCLUSIVE-LOCK:

      IF VALID-HANDLE(ttDataLinks.hSourceHandle) AND
         VALID-HANDLE(ttDataLinks.hTargetHandle) THEN
        RUN addLink IN TARGET-PROCEDURE (INPUT ttDataLinks.hSourceHandle,
                                         INPUT "Data":U,
                                         INPUT ttDataLinks.hTargetHandle).
      DELETE ttDataLinks.
    END.
  END. /* End Activate Links */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNodeTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setNodeTable Procedure 
PROCEDURE setNodeTable :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will recieve the entire ttNode temp-table created 
               for the Dynamic TreeView object.
  Parameters:  <none>
  Notes:       This API is not used by any of the Dynamic TreeView objects, but
               needs to stay since customers have made reference to this api
               in their applications.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER TABLE FOR ttNode.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTreeViewWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTreeViewWidth Procedure 
PROCEDURE setTreeViewWidth :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will set the last saved position of the Resize Bar
               in the TreeView.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cProfileData    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE rProfileRid     AS ROWID      NO-UNDO.
  DEFINE VARIABLE lSaveWindowPos  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE dTVCol          AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dHeight         AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dWidth          AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cObjectName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hResizeBar      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWindow         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX    AS HANDLE     NO-UNDO.
  
  /* determine if window positions and sizes are saved */
  IF VALID-HANDLE(gshProfileManager) THEN
    RUN getProfileData IN gshProfileManager (INPUT "Window":U,
                                             INPUT "SaveSizPos":U,
                                             INPUT "SaveSizPos":U,
                                             INPUT NO,
                                             INPUT-OUTPUT rProfileRid,
                                             OUTPUT cProfileData).
                                           
  ASSIGN lSaveWindowPos = cProfileData <> "NO":U.

  /* Position was saved */
  IF lSaveWindowPos THEN DO:
    ASSIGN
      cProfileData = "":U
      rProfileRid  = ?.
    
    {get LogicalObjectName cObjectName}.

    IF VALID-HANDLE(gshProfileManager) THEN
      RUN getProfileData IN gshProfileManager (INPUT "Window":U,          /* Profile type code     */
                                               INPUT "DynTVSize":U,       /* Profile code          */
                                               INPUT cObjectName,         /* Profile data key      */
                                               INPUT "NO":U,              /* Get next record flag  */
                                               INPUT-OUTPUT rProfileRid,  /* Rowid of profile data */
                                               OUTPUT cProfileData).      /* Found profile data. */
  END. /* save window position and sizes */
  ELSE ASSIGN cProfileData = "":U.
  
  IF SESSION:NUMERIC-DECIMAL-POINT = ",":U AND INDEX(cProfileData,".") <> 0 THEN
    cProfileData = REPLACE(cProfileData,".":U,",":U).
  IF SESSION:NUMERIC-DECIMAL-POINT = ".":U AND INDEX(cProfileData,",") <> 0 THEN
    cProfileData = REPLACE(cProfileData,",":U,".":U).
  
  dTVCol = 0 NO-ERROR.
  IF cProfileData <> "":U THEN
    dTVCol = DECIMAL(cProfileData) NO-ERROR.
  
  &SCOPED-DEFINE xp-assign
  {get ContainerHandle hWindow}
  {get ResizeBar hResizeBar}
  {get TreeViewOCX hTreeViewOCX}.
  &UNDEFINE xp-assign
  
  IF dTVCol >= hWindow:WIDTH-CHARS THEN
    dTVCol = hWindow:WIDTH-CHARS / 3 NO-ERROR. /* Make it one third of the window's width */
    
  /* If there are no saved settings, then based the initial position of the resize
     bar on the min width of the treeview component.
   */
  IF dTVCol <= 0 THEN
      {get MinWidth dTvCol hTreeViewOCX}.
  
  /* Make sure that the treeview is sized to its minimums. */
  {get Height dHeight hTreeViewOCX}.
  IF NOT ERROR-STATUS:ERROR AND dTVCol > 0 THEN
    hResizeBar:COL = dTVCol.

  /* Make sure that the treeview component is the right size: it
     should fill up to the resize bar.
   */
  RUN resizeObject IN hTreeViewOCX (INPUT dHeight, INPUT dTvCol - 0.5) NO-ERROR.
  
  /* Don't resize the window now - it is WAY too early for that. */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-stripMNUDetails) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE stripMNUDetails Procedure 
PROCEDURE stripMNUDetails :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will strip the details passed to it to create
               nodes for a menu structure
  Parameters:  I pcParentNodeKey - The Node Key of the parent node
               I pcDetailList    - The list of menu details to be created
               I pdNodeObj       - The node_obj of the gsm_node record that
                                   created this list
               I pcImage         - The File name of the image to be displayed
               I pcSelectedImage - The File name of the image to be displayed 
                                   when selected
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcParentNodeKey AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcDetailList    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pdNodeObj       AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcImage         AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcSelectedImage AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE hTable                AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hBuf                  AS HANDLE       NO-UNDO.
  DEFINE VARIABLE iLoop                 AS INTEGER      NO-UNDO.
  DEFINE VARIABLE cNodeLabel            AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cPrivateData          AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX          AS HANDLE       NO-UNDO.
  DEFINE VARIABLE lSort                 AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE cSubMenu              AS CHARACTER    NO-UNDO.

  {get TreeViewOCX hTreeViewOCX}.
  
  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE NO-LOCK.
  lSort = ttProp.lAutoSort.

  {get TreeDataTable hTable hTreeViewOCX}.  

  /* Grab the handles to the individual fields in the tree data table. */
  ASSIGN hBuf = hTable:DEFAULT-BUFFER-HANDLE.
      
  DO iLoop = 1 TO NUM-ENTRIES(pcDetailList,CHR(3)):
    ASSIGN cNodeLabel   = ENTRY(1,ENTRY(iLoop,pcDetailList,CHR(3)),CHR(4))
           cPrivateData = ENTRY(2,ENTRY(iLoop,pcDetailList,CHR(3)),CHR(4))
           cSubMenu     = ENTRY(5,cPrivateData,CHR(7))
           cSubMenu     = ENTRY(2,cSubMenu,CHR(6))
           NO-ERROR.
    
    IF cNodeLabel = "":U THEN
      NEXT.
    hBuf:BUFFER-CREATE().
    ASSIGN hBuf:BUFFER-FIELD('parent_node_key':U):BUFFER-VALUE = pcParentNodeKey
           hBuf:BUFFER-FIELD('node_obj':U):BUFFER-VALUE        = pdNodeObj
           hBuf:BUFFER-FIELD('node_key':U):BUFFER-VALUE        = DYNAMIC-FUNCTION('getNextNodeKey':U IN hTreeViewOCX)
           hBuf:BUFFER-FIELD('node_label':U):BUFFER-VALUE      = cNodeLabel
           hBuf:BUFFER-FIELD('private_data':U):BUFFER-VALUE    = cPrivateData
           hBuf:BUFFER-FIELD('image':U):BUFFER-VALUE           = pcImage
           hBuf:BUFFER-FIELD('selected_image':U):BUFFER-VALUE  = pcSelectedImage
           hBuf:BUFFER-FIELD('node_sort':U):BUFFER-VALUE       = lSort
           hBuf:BUFFER-FIELD('node_type':U):BUFFER-VALUE       = "MNU":U
           hBuf:BUFFER-FIELD('node_insert':U):BUFFER-VALUE     = IF pcParentNodeKey = "":U THEN 1 ELSE 4.
    IF cSubMenu <> "":U THEN
    DO:
      ASSIGN cSubMenu = REPLACE(cSubMenu,CHR(1),CHR(3))
             cSubMenu = REPLACE(cSubMenu,"^":U,CHR(4))
             cSubMenu = REPLACE(cSubMenu,"@":U,CHR(7))
             cSubMenu = REPLACE(cSubMenu,"#":U,CHR(6)).
      
      RUN stripMNUDetails IN TARGET-PROCEDURE (INPUT hBuf:BUFFER-FIELD('node_key':U):BUFFER-VALUE,
                                               INPUT cSubMenu,   
                                               INPUT pdNodeObj,
                                               INPUT pcImage,
                                               INPUT pcSelectedImage).


    END.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-treePackDone) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE treePackDone Procedure 
PROCEDURE treePackDone :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is called from the TreeView rendering procedure
               to notify us that the TreeView Packing is done. This will allow
               us to save the min sizes of the Dynamic TreeView container
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hWindow AS HANDLE     NO-UNDO.

  {get ContainerHandle hWindow}.
  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE ttProp THEN
  DO:
    CREATE ttProp.
    ASSIGN ttProp.hTargetProcedure = TARGET-PROCEDURE.
  END.

  ASSIGN ttProp.dTreeMinWidth  = hWindow:MIN-WIDTH-CHARS
         ttProp.dTreeMinHeight = hWindow:MIN-HEIGHT-CHARS.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-treeResized) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE treeResized Procedure 
PROCEDURE treeResized :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is published from from the TreeView rendering
               procedure on the END-MOVE trigger. It will then resize the 
               TreeView OCX and run packWindow and ResizeWindow to ensure 
               the window is resized correctly.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTreeViewOCX  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hResizeBar    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWindow       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dTreeHeight   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dTreeMinWidth AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dTreeWidth    AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dAdjustment   AS DECIMAL    NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get TreeViewOCX hTreeViewOCX}
  {get ResizeBar hResizeBar}.
  &UNDEFINE xp-assign
       
  /* This should never happen, just in case... */
  IF NOT VALID-HANDLE(hResizeBar) THEN
    RETURN.
  
  {fnarg lockWindow TRUE}.
  
  IF VALID-HANDLE(hTreeViewOCX) THEN
  DO:
    dTreeMinWidth = DYNAMIC-FUNCTION("getMinWidth":U IN hTreeViewOCX) + 1.
    /* Since the TreeView OCX can never be narrower than it's min width we need 
       to leave some space for the Resize Bar and we'd rather check that the COL
       being moved to is at least the min width plus 1 */
    IF hResizeBar:COL < dTreeMinWidth THEN
      hResizeBar:COL = dTreeMinWidth.
    
    /* We will not be adjusting the height, this would be done by the resize
       procedures */
    &SCOPED-DEFINE xp-assign
    {get Height dTreeHeight hTreeViewOCX}
    {get Width  dTreeWidth  hTreeViewOCX}.
    &UNDEFINE xp-assign
    
    RUN resizeObject IN hTreeViewOCX (INPUT dTreeHeight, INPUT hResizeBar:COL - 0.5).
            
    /* Adjust the size of the window by the amount that the resize bar moves. Be careful
       though, not to make the window smaller that it's minimum size.
       
       Also make sure that this shift of the resize bar leaves enough 'untouchable' space
       on the right so that we are not able to resize the treeview smaller than the 
       folder window.
    */
    {get ContainerHandle hWindow}.
    ASSIGN dAdjustment   = (hResizeBar:COL - 0.5 - dTreeWidth)
           hWindow:WIDTH = MAX(hWindow:WIDTH + dAdjustment, hWindow:MIN-WIDTH) 
           NO-ERROR.           
  END.    /* valid treeview */
  
  /* First adjust the size of the treeview component, since this is used for packing. */
  RUN calcNewTreeSize IN TARGET-PROCEDURE.
  
  /* Repack, since the minimum window size may have changed. If the resize bar was moved to 
     the left (ie smaller tree) then the min size may need to be made smaller. However, the 
     layout manager doesn't cater for making the min-width of a window smaller, so we need 
     to set it to a small value. It will be reset to the correct minimum size by the call
     to packWindow().
   */
  ASSIGN hWindow:MIN-WIDTH = 10.
  RUN packWindow IN TARGET-PROCEDURE (INPUT ?, INPUT NO) NO-ERROR.  
  RUN resizeWindow IN TARGET-PROCEDURE.
 
  ASSIGN ttProp.dResizeBarCol = hResizeBar:COL.
  
  {fnarg lockWindow FALSE}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tvNodeEvent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tvNodeEvent Procedure 
PROCEDURE tvNodeEvent :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is called when an event occurs on a selected node.
  Parameters:  pcEvent - The event code passed from the TreeView when an event
                         has occurred.
               pcNodeKey - The node key where the event occurred.
  Notes:       Valid events:
               EXPAND
               COLLAPSE
               RIGHTCLICK
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcEvent       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcNodeKey     AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cLastSelectedNode AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFirstChild       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataTableBuf     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTreeTable        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cParentNode       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lReposToNewNode   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE dNodeObj          AS DECIMAL    NO-UNDO.

  DEFINE BUFFER bttNode  FOR ttNode.

  /* Don't waste time, if it isn't one of the supported events then get out of here */
  IF pcEvent <> "EXPAND":U     AND
     pcEvent <> "RIGHTCLICK":U AND 
     pcEvent <> "COLLAPSE":U THEN
    RETURN.
  
  IF pcNodeKey  = ?            AND 
     pcEvent   <> "RIGHTCLICK" THEN
    RETURN.

  {get TreeViewOCX hTreeViewOCX}.

  /* Get the last selected node */
  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE NO-LOCK.
  ASSIGN cLastSelectedNode = ttProp.cCurrentNodeCode.

  CASE pcEvent:
    WHEN "EXPAND":U THEN
    DO:
      SESSION:SET-WAIT-STATE("GENERAL":U).
      /* First check if we need to expand this node's child level - if any */
      cFirstChild = DYNAMIC-FUNCTION("getProperty":U IN hTreeViewOCX, "CHILD":U, pcNodeKey).
      IF cFirstChild <> ? THEN DO:
        /* A '+' PLUS in the child node's TEXT attribute indicates that we 
          should still expand this node's children */
        IF NOT DYNAMIC-FUNCTION("getProperty":U IN hTreeViewOCX, "TEXT":U, cFirstChild) BEGINS "+":U THEN
        DO:
          SESSION:SET-WAIT-STATE("":U).
          RETURN.
        END.
        /* If we got here then we still have a dummy node record in the Tree 
           and we can now get rid of that since we will be expanding into more
           detail */
        RUN returnTreeBuffer IN TARGET-PROCEDURE (INPUT cFirstChild, OUTPUT hDataTableBuf).
        IF hDataTableBuf:AVAILABLE THEN DO:
          /* First delete the record in the Tree Table */
          hDataTableBuf:BUFFER-DELETE().
          /* Now remove the actual node in the Tree */
          RUN deleteNode IN hTreeViewOCX (INPUT cFirstChild).
        END.
      END.

      /* We need to expand a node, but this doesn't mean that the node we want
         to expand is the selected node. To ensure the correct details are 
         expanded, we need to ensure that the parent SDOs are correctly repositioned
         before we set the foreign fields. This is all taken care of in repositionSDO */
      RUN setDataLinks IN TARGET-PROCEDURE (INPUT "INACTIVE":U).
      RUN repositionSDO IN TARGET-PROCEDURE (INPUT pcNodeKey).
      RUN returnTreeBuffer IN TARGET-PROCEDURE (INPUT pcNodeKey, OUTPUT hDataTableBuf).
      IF hDataTableBuf:AVAILABLE THEN
        dNodeObj = DECIMAL(hDataTableBuf:BUFFER-FIELD("node_obj":U):BUFFER-VALUE).

      DYNAMIC-FUNCTION("lockWindow":U IN TARGET-PROCEDURE, INPUT TRUE).
      /* load the TEXT nodes first... */
      FOR EACH  bttNode
          WHERE bttNode.hTargetProcedure = TARGET-PROCEDURE
          AND   bttNode.parent_node_obj  = dNodeObj
          AND   bttNode.data_source_type = "TXT":U
        NO-LOCK
          BY    bttNode.node_obj:
        RUN loadNodeData IN TARGET-PROCEDURE (INPUT pcNodeKey, INPUT bttNode.node_obj).
      END.
      /* ...then all other node types */
      FOR EACH  bttNode
          WHERE bttNode.hTargetProcedure = TARGET-PROCEDURE
          AND   bttNode.parent_node_obj  = dNodeObj
          AND   bttNode.data_source_type <> "TXT":U
          NO-LOCK
          BY    bttNode.node_obj:
        RUN loadNodeData IN TARGET-PROCEDURE (INPUT pcNodeKey, INPUT bttNode.node_obj).
      END.
      DYNAMIC-FUNCTION("lockWindow":U IN TARGET-PROCEDURE, INPUT FALSE).

      {get TreeDataTable hTreeTable hTreeViewOCX}.
      /* After creating the child node records, add the actual nodes to the Tree */
      RUN populateTree IN hTreeViewOCX (INPUT hTreeTable, INPUT pcNodeKey).
      SESSION:SET-WAIT-STATE("":U).
      RUN setDataLinks IN TARGET-PROCEDURE (INPUT "ACTIVE":U).

      /* If the last selected node was not the same as the one being expand to, 
         then reposition to that node again after expaning the other node */
      IF cLastSelectedNode <> pcNodeKey THEN
        RUN repositionSDO IN TARGET-PROCEDURE (INPUT cLastSelectedNode).

      SESSION:SET-WAIT-STATE("":U).
    END. /* EXPAND */
    WHEN "COLLAPSE":U THEN
    DO:
      SESSION:SET-WAIT-STATE("GENERAL":U).
      /* If the node being collapsed is somehow a parent of a currently selected
         and displayed node we need to reposition to the node being collapsed */
      IF pcNodeKey <> cLastSelectedNode THEN
      DO:
        /* Check if the last selected node is a child node of the node
           being collapsed, if so, we will need to select the node
           being collapsed */
        cParentNode = DYNAMIC-FUNCTION("getProperty":U IN hTreeViewOCX, INPUT "PARENT":U, INPUT cLastSelectedNode).
        
        LOOK_FOR_PARENT_NODE:
        REPEAT:
          IF cParentNode = pcNodeKey THEN
          DO:
            lReposToNewNode = TRUE.
            LEAVE LOOK_FOR_PARENT_NODE.
          END.
          cParentNode = DYNAMIC-FUNCTION("getProperty":U IN hTreeViewOCX, INPUT "PARENT":U, INPUT cParentNode).
          /* Check for Root Node */
          IF cParentNode = ? OR
             cParentNode = "":U THEN
            LEAVE LOOK_FOR_PARENT_NODE.
        END. /* REPEAT */

        IF lReposToNewNode THEN
        DO:
          DYNAMIC-FUNCTION("setProperty":U IN hTreeViewOCX, INPUT "SELECTEDITEM":U, INPUT pcNodeKey, INPUT "":U).
          RUN tvNodeSelected IN TARGET-PROCEDURE (INPUT pcNodeKey).
        END.
      END.
      SESSION:SET-WAIT-STATE("":U).
    END. /* COLLAPSE */
    WHEN "RIGHTCLICK":U THEN
    DO: 
      SESSION:SET-WAIT-STATE("GENERAL":U).
      /* Since you need to be on a certain node to ensure you get the correct selected 
         node we will be repositioning to the selected node according to the input
         parameter we are getting */
      RUN tvNodeSelected IN TARGET-PROCEDURE (INPUT pcNodeKey).

      RUN returnTreeBuffer IN TARGET-PROCEDURE (INPUT pcNodeKey, OUTPUT hDataTableBuf).
      IF hDataTableBuf:AVAILABLE THEN
        dNodeObj = DECIMAL(hDataTableBuf:BUFFER-FIELD("node_obj":U):BUFFER-VALUE).
      
      IF dNodeObj <> 0 THEN
        RUN buildPopupMenu IN TARGET-PROCEDURE
                           (INPUT dNodeObj,
                            INPUT pcNodeKey).
      ELSE
        RUN buildPopupMenu IN TARGET-PROCEDURE
                           (INPUT 0,
                            INPUT "":U).
      SESSION:SET-WAIT-STATE("":U).
    END. /* RIGHTCLICK */
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tvNodeSelected) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tvNodeSelected Procedure 
PROCEDURE tvNodeSelected :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is called when a node is selected in the TreeView
               object.
  Parameters:  pcNodeKey - The node key of the selected node.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcNodeKey AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hTreeViewOCX   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataTableBuf  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLogicalObject AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRunAttribute  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPrivateData   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTreeBuffer    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cOldNodeKey    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMoreNode      AS CHARACTER  NO-UNDO.

  /* First check that this is not already the current selected node */
  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE NO-LOCK.
  IF ttProp.cCurrentNodeCode = pcNodeKey THEN
    RETURN.

  {get TreeViewOCX hTreeViewOCX}.
  
  /* Check if the Node selected isn't one of those 'More...' nodes */
  IF DYNAMIC-FUNCTION("getProperty":U IN hTreeViewOCX, "TAG":U, pcNodeKey) = "@MORE":U THEN
  DO:
    cOldNodeKey = DYNAMIC-FUNCTION("getSelectedNode":U IN hTreeViewOCX).
    FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK.
    ASSIGN cOldNodeKey             = ttProp.cCurrentNodeCode
           ttProp.cCurrentNodeCode = pcNodeKey.
    RUN setDataLinks IN TARGET-PROCEDURE (INPUT "INACTIVE":U).
    /* Reposition SDO */
    RUN repositionSDO IN TARGET-PROCEDURE (INPUT pcNodeKey).
    DYNAMIC-FUNCTION("lockWindow":U IN TARGET-PROCEDURE, INPUT TRUE).
    RUN loadSDOSBOData IN TARGET-PROCEDURE (INPUT "MORE":U, INPUT 0).
    cMoreNode = RETURN-VALUE.
    pcNodeKey = cOldNodeKey.
    RUN setDataLinks IN TARGET-PROCEDURE (INPUT "ACTIVE":U).
    DYNAMIC-FUNCTION("lockWindow":U IN TARGET-PROCEDURE, INPUT FALSE).
    DYNAMIC-FUNCTION("selectNode" IN hTreeViewOCX, pcNodeKey).
    /* Make sure the new nodes are visible */
    PROCESS EVENTS. /* Added this line since it seems that if we don't have some
                       kind of screen refreshment or time consuming event, like
                       displaying a message that the OCX doesn't reposition to the
                       newly added nodes. It seems to always work if there is a 
                       message before the 'ENSUREVISIBLE' property is set, but
                       doesn't always reposition correctly if there isn't. Since
                       we can't just add a message here the PROCESS EVENTS will
                       have to do. */
    IF cMoreNode <> "":U AND
       cMoreNode <> ? THEN
      DYNAMIC-FUNCTION("setProperty":U IN hTreeViewOCX, "ENSUREVISIBLE":U, cMoreNode,"":U) NO-ERROR.
  END.

  RUN returnTreeBuffer IN TARGET-PROCEDURE (INPUT pcNodeKey, OUTPUT hDataTableBuf).
  
  IF NOT hDataTableBuf:AVAILABLE THEN
    RETURN.
  
  /* Find the node detail we just selected. This will tell us what object
     we need to launch */
  FIND FIRST ttNode
       WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
       AND   ttNode.node_obj         = DECIMAL(hDataTableBuf:BUFFER-FIELD("node_obj":U):BUFFER-VALUE)
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ttNode THEN
    RETURN.

  SESSION:SET-WAIT-STATE("GENERAL":U).
  
  DYNAMIC-FUNCTION("lockWindow":U IN TARGET-PROCEDURE, INPUT TRUE).

  /* Reposition SDO */
  RUN repositionSDO IN TARGET-PROCEDURE (INPUT pcNodeKey).
  
  /* Create the Application Object */
  
  /* For Menu Tree Objects the object to be launched sits in the node's 
     private_data field */
  IF ttNode.data_source_type = "MNU":U THEN
  DO:
    RUN returnTreeBuffer IN TARGET-PROCEDURE (INPUT pcNodeKey, OUTPUT hTreeBuffer).
    IF hTreeBuffer:AVAILABLE THEN
    DO:
      ASSIGN cPrivateData    = hTreeBuffer:BUFFER-FIELD("private_data":U):BUFFER-VALUE
             cLogicalObject  = IF NUM-ENTRIES(cPrivateData,CHR(6)) >= 1 THEN ENTRY(2,ENTRY(1,cPrivateData,CHR(7)),CHR(6)) ELSE "":U
             cRunAttribute   = IF NUM-ENTRIES(cPrivateData,CHR(6)) >= 2 THEN ENTRY(2,ENTRY(2,cPrivateData,CHR(7)),CHR(6)) ELSE "":U
             NO-ERROR.
      RUN createRepositoryObjects IN TARGET-PROCEDURE (INPUT cLogicalObject,
                                                       INPUT "":U,
                                                       INPUT cRunAttribute, 
                                                       INPUT 0,
                                                       INPUT ttNode.node_obj) NO-ERROR.
    END.
  END.
  ELSE
    RUN createRepositoryObjects IN TARGET-PROCEDURE (INPUT ttNode.logical_object,
                                                     INPUT ttNode.primary_sdo,
                                                     INPUT ttNode.run_attribute,
                                                     INPUT ttNode.iStrucLevel,
                                                     INPUT ttNode.node_obj) NO-ERROR.  

  /* Set the last selected node */
  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK.
  ASSIGN ttProp.cCurrentNodeCode = pcNodeKey
         ttProp.cParentNode      = DYNAMIC-FUNCTION("getProperty":U IN hTreeViewOCX, INPUT "PARENT":U, INPUT pcNodeKey).
  DYNAMIC-FUNCTION("lockWindow":U IN TARGET-PROCEDURE, INPUT FALSE).
  PUBLISH "tvNodeSelectedNotification" FROM TARGET-PROCEDURE (INPUT pcNodeKey).
  
  /* Check if the title changed */
  IF VALID-HANDLE(ttProp.hCurrentFrame) THEN
    RUN updateFrameTitle IN TARGET-PROCEDURE (INPUT ttProp.hCurrentFrame).
  
  SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateFrameTitle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateFrameTitle Procedure 
PROCEDURE updateFrameTitle :
/*------------------------------------------------------------------------------
  Purpose:   Update the frame title from the childs WindowName attribute  
  Parameters:  phChild - The handle of the child window who's title is being
                         changed.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phChild AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE cTitle    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTitleBar AS HANDLE     NO-UNDO.

  IF phChild <> ? THEN
    {get WindowName cTitle phChild}.

  {get TitleBar hTitleBar}.
  ASSIGN hTitleBar:SCREEN-VALUE = cTitle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateState Procedure 
PROCEDURE updateState :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is published from the SDO when changes are made
               to a record new or existing. 
  Parameters:  pcState - The state of the current visual container.
  Notes:       When 'Update' is passed to this procedure we know something is 
               being done to a record. We can now check if a record is being
               added or just modified by checking the 'NewRecord' property in
               the SDO's primary Data Target.
               When 'UpdateComplete' is passed we know that the opperation has
               completed and we should update the Tree with the new information.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcState AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE hTreeViewOCX    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataTargets    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataTarget     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNewRecord      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTreeBuffer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cParentRef      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hParentSDO      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNodeToSelect   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dParentNodeObj  AS DECIMAL    NO-UNDO.

  {get TreeViewOCX hTreeViewOCX}.

  CASE pcState:
    WHEN "UPDATE":U THEN 
    DO:
      /* TreeView is going into update mode */
      RUN disableObject IN hTreeViewOCX.
      FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK.
      IF VALID-HANDLE(ttProp.hFilterViewer) THEN
        RUN disableObject IN ttProp.hFilterViewer.
      /* When adding a record this event is published twice with a state of 'Update'
         The first after you pressed the Add or Copy button and the second time
         when you enter some values. To avoid us resetting values we will not
         execute the code below a second time when adding a new record */
      IF ttProp.lAddCopy THEN
      DO:
        ASSIGN ttProp.lResetRecord = FALSE.
        RETURN.
      END.

      ASSIGN ttProp.lCancelRecord = FALSE
             ttProp.lResetRecord  = FALSE.

      FIND FIRST ttFrame
           WHERE ttFrame.hTargetProcedure = TARGET-PROCEDURE
           AND   ttFrame.hFrameHandle     = ttProp.hCurrentFrame
           EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE ttFrame AND 
         VALID-HANDLE(ttFrame.hDataSource) THEN
      DO:
        cDataTargets = DYNAMIC-FUNCTION("linkHandles":U IN ttFrame.hDataSource,"Update-Source":U).
        hDataTarget = WIDGET-HANDLE(ENTRY(1,cDataTargets)).
        IF VALID-HANDLE(hDataTarget) THEN DO:
          SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "resetRecord":U  IN hDataTarget.
          cNewRecord = DYNAMIC-FUNCTION("getNewRecord":U IN hDataTarget).
          IF cNewRecord = "Add" OR
             cNewRecord = "Copy":U THEN 
          DO:
            /* If we are adding a new node on the same level then we would not
               have set the dNewNodeObj field and we need to set the field to
               indicate where this node should be added */
            IF ttProp.dNewNodeObj = 0 THEN
            DO:
              RUN returnTreeBuffer IN TARGET-PROCEDURE (INPUT ttProp.cCurrentNodeCode, OUTPUT hTreeBuffer).
              IF hTreeBuffer:AVAILABLE THEN
                ASSIGN ttProp.dNewNodeObj = DECIMAL(hTreeBuffer:BUFFER-FIELD("node_obj":U):BUFFER-VALUE).
            END.
            /* Check for Structured Nodes - We need to set some properties
               when adding a new structered node */
            cParentRef = "":U.
            FIND FIRST ttNode
                 WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
                 AND   ttNode.node_obj         = ttProp.dNewNodeObj
                 NO-LOCK NO-ERROR.
            IF AVAILABLE ttNode AND
               ttNode.structured_node THEN
            DO:
              IF VALID-HANDLE(ttFrame.hDataSource) THEN
                {get DataSource hParentSDO ttFrame.hDataSource}.
              IF VALID-HANDLE(hParentSDO) THEN
              DO:
                RUN returnTreeBuffer IN TARGET-PROCEDURE (INPUT ttProp.cParentNode, OUTPUT hTreeBuffer).
                IF hTreeBuffer:AVAILABLE THEN
                DO:
                  cParentRef = DYNAMIC-FUNCTION("assignRefValue":U IN TARGET-PROCEDURE, INPUT ttNode.child_field, INPUT hParentSDO).
                  /* We need to check if the parent node is part of the structure and
                    if it isn't we should not assign a Parent Ref value */
                  dParentNodeObj = hTreeBuffer:BUFFER-FIELD("node_obj":U):BUFFER-VALUE.
                  IF NOT CAN-FIND(FIRST ttNode
                                  WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
                                  AND   ttNode.node_obj         = dParentNodeObj 
                                  AND   ttNode.structured_node  = TRUE) THEN
                    cParentRef = "":U.
                END.
              END.
              /* Set the property in the frame - this is new for V2.1 since we now
                 use frames */
              /* Replace all quotes - old style */
              cParentRef = REPLACE(cParentRef,'"':U,"":U).
              IF VALID-HANDLE(hFrameHandle) THEN
                DYNAMIC-FUNCTION("setUserProperty":U IN ttFrame.hFrameHandle, "ParentKeyValue":U, cParentRef).
              /* Set the property in the TreeView - this is for backward compatibility since
                 developers might be finding the container of the frame before getting the 
                 property */
              DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ParentKeyValue":U, cParentRef).
            END.
            /* End of Structured nodes */

            ASSIGN ttProp.lAddCopy = TRUE.
          END.
        END.
      END.
    END.
    WHEN "UpdateComplete":U THEN
    DO:
      FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE NO-LOCK.
      /* There is a bug in the toolbar where if you add or copy a record and
         you update the first field the Reset button is enabled. To avoid some
         odd behavior we will just ignore that event and wait for a cancel */
      IF ttProp.lAddCopy AND 
         NOT ttProp.lCancelRecord AND
         ttProp.lResetRecord THEN
      DO:
        ASSIGN ttProp.lResetRecord = FALSE.
        RETURN.
      END.
      
      IF ttProp.lCancelRecord AND
         ttProp.lNewChildNode THEN DO:
        ASSIGN ttProp.cParentNode      = DYNAMIC-FUNCTION("getProperty":U IN hTreeViewOCX, INPUT "PARENT":U, INPUT ttProp.cParentNode)
               ttProp.lNewChildNode    = FALSE
               cNodeToSelect           = ttProp.cCurrentNodeCode
               ttProp.cCurrentNodeCode = "ForeceNewNodeSelect":U.
        RUN tvNodeSelected IN TARGET-PROCEDURE (INPUT cNodeToSelect).
      END.

      IF NOT ttProp.lCancelRecord THEN
      DO:
        /* Update the TreeView */
        IF ttProp.lAddCopy THEN
          RUN newRecordAdded IN TARGET-PROCEDURE.
        ELSE
          RUN recordUpdated IN TARGET-PROCEDURE.
      END.
      FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK.
      ASSIGN ttProp.lCancelRecord = FALSE
             ttProp.lAddCopy      = FALSE
             ttProp.dNewNodeObj   = 0.
      /* Re-enable the TreeView */
      RUN enableObject IN hTreeViewOCX.
      IF VALID-HANDLE(ttProp.hFilterViewer) THEN
        RUN enableObject IN ttProp.hFilterViewer.

    END.
  END CASE.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-assignRefValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignRefValue Procedure 
FUNCTION assignRefValue RETURNS CHARACTER
  ( pcRefFields AS CHARACTER,
    phDataObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will take in a list of key fields that makes the 
            unique key for a node
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRecordRef AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop      AS INTEGER    NO-UNDO.

  IF NUM-ENTRIES(pcRefFields) > 1 THEN DO:
    ASSIGN cRecordRef = "":U
           cRecordRef = FILL(CHR(1),NUM-ENTRIES(pcRefFields) - 1).
    DO iLoop = 1 TO NUM-ENTRIES(pcRefFields):
      ENTRY(iLoop,cRecordRef,CHR(1)) = TRIM(DYNAMIC-FUNCTION("columnValue":U IN phDataObject, ENTRY(iLoop,pcRefFields))).
    END.
  END.
  ELSE 
    cRecordRef = TRIM(DYNAMIC-FUNCTION("columnValue":U IN phDataObject, pcRefFields)).
  RETURN cRecordRef.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignTempObjNumber) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignTempObjNumber Procedure 
FUNCTION assignTempObjNumber RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dNewObjNumber AS DECIMAL    NO-UNDO DECIMALS 9.
  
  ASSIGN dNewObjNumber   = gdTempObjNumber + (gdTempObjDecNo / 100000000)
         gdTempObjNumber = gdTempObjNumber + 1.

  RETURN dNewObjNumber.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentTreeFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentTreeFrame Procedure 
FUNCTION getCurrentTreeFrame RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  This function is called from the TreeView rendering procedure to 
            establish which resize and packing procedure to run. If the handle 
            is valid, we will run the pack and resize for the launched frame if
            it is not valid we run the standard pack and resize procedures for
            the Dynamic TreeView
    Notes:  
------------------------------------------------------------------------------*/
  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE NO-LOCK NO-ERROR.
  
  IF AVAILABLE ttProp AND ttProp.lResizeFrameNow THEN
    RETURN ttProp.hCurrentFrame.
  ELSE 
    RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEntityName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEntityName Procedure 
FUNCTION getEntityName RETURNS CHARACTER
  ( phDataSource AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  This function was added to take over the functionality of the function
            in the Gen Manager called getUpdateableTableInfo since this function
            was doing an AppServer hit.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cUpdatableColumns AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUpdatableTable   AS CHARACTER  NO-UNDO.

  IF VALID-HANDLE(phDataSource) THEN
    ASSIGN cUpdatableColumns = DYNAMIC-FUNCTION("getUpdatableColumns":U IN phDataSource)
           cUpdatableTable   = DYNAMIC-FUNCTION("columnTable":U         IN phDataSource, INPUT ENTRY(1, cUpdatableColumns)).
  
  RETURN cUpdatableTable.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLogicalObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLogicalObjectName Procedure 
FUNCTION getLogicalObjectName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Added override of this function to ensure the translation screen
            gets the correct name of the current visible window when doing
            translations.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLogicalObjectName AS CHARACTER  NO-UNDO.
  
  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE NO-LOCK NO-ERROR.
  IF AVAILABLE ttProp AND 
     VALID-HANDLE(ttProp.hCurrentFrame) THEN
  DO:
    FIND FIRST ttFrame
         WHERE ttFrame.hTargetProcedure = TARGET-PROCEDURE
         AND   ttFrame.hFrameHandle     = ttProp.hCurrentFrame
         NO-LOCK NO-ERROR.
    IF AVAILABLE ttFrame THEN
      cLogicalObjectName = ttFrame.cFrameName.
  END. 
  
  IF cLogicalObjectName = "":U THEN
  DO:
    &SCOPED-DEFINE xpLogicalObjectName
    {get LogicalObjectName cLogicalObjectName}.
    &UNDEFINE xpLogicalObjectName
  END.
  
  RETURN cLogicalObjectName.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNodeDetails) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNodeDetails Procedure 
FUNCTION getNodeDetails RETURNS CHARACTER
  ( INPUT phTable   AS HANDLE,
    INPUT pcNodeKey AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will return most common requred information for a 
            selected node.
    Notes:  The string returned is CHR(2) delimited and contains the following
            information:
            nodeObj       - The object number of the gsm_node record
            rRecordRowid  - The rowid of the selected node record
            cPrivateData  - The privateData of the selected node.
            lNodExpanded  - Was the node expanded TRUE/FALSE
            cRecordRef    - The unique record reference 
            
            This function is not called from anywhere in the Dynamic TreeView
            or any of it's other components, but was added back since a lot
            of customers were relying on this function being here.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataTableBuf   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dNodeObj        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE rRecordRowid    AS ROWID      NO-UNDO.
  DEFINE VARIABLE cPrivateData    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeDetails    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNodeExpanded   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cRecordRef      AS CHARACTER  NO-UNDO.
  
  RUN returnTreeBuffer IN TARGET-PROCEDURE (INPUT pcNodeKey, OUTPUT hDataTableBuf).
  
  IF hDataTableBuf:AVAILABLE THEN
  DO:
    ASSIGN dNodeObj        = hDataTableBuf:BUFFER-FIELD('node_obj':U):BUFFER-VALUE 
           rRecordRowid    = hDataTableBuf:BUFFER-FIELD('record_rowid':U):BUFFER-VALUE 
           cPrivateData    = hDataTableBuf:BUFFER-FIELD('private_data':U):BUFFER-VALUE
           lNodeExpanded   = hDataTableBuf:BUFFER-FIELD('node_expanded':U):BUFFER-VALUE
           cRecordRef      = hDataTableBuf:BUFFER-FIELD('record_ref':U):BUFFER-VALUE
           NO-ERROR.
  END.

  cNodeDetails = IF dNodeObj <> ? THEN STRING(dNodeObj,"->>>>>>>>>>>>>>>>>9.999999999":U) ELSE "0.0":U.
  cNodeDetails = cNodeDetails + CHR(2) + IF rRecordRowid <> ? THEN STRING(rRecordRowid) ELSE "?":U.
  cNodeDetails = cNodeDetails + CHR(2) + IF cPrivateData <> ? THEN cPrivateData ELSE "":U.
  cNodeDetails = cNodeDetails + CHR(2) + IF lNodeExpanded <> ? THEN STRING(lNodeExpanded) ELSE "":U.
  cNodeDetails = cNodeDetails + CHR(2) + IF cRecordRef <> ? THEN STRING(cRecordRef) ELSE "":U.
  
  RETURN cNodeDetails.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjKeyField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjKeyField Procedure 
FUNCTION getObjKeyField RETURNS CHARACTER
  ( pcValueList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjField AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntity   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBuffer   AS HANDLE     NO-UNDO.

  IF pcValueList = "":U AND 
     pcValueList = ? THEN
    RETURN "":U.
  
  cEntity = ENTRY(1,pcValueList,CHR(4)).
  
  IF cEntity = "":U OR
     cEntity = ? THEN
    RETURN "":U.
  /* Now find the DUMP name */
  hBuffer = DYNAMIC-FUNCTION("getEntityCacheBuffer" IN gshGenManager, INPUT "":U, INPUT cEntity).
  IF VALID-HANDLE(hBuffer) THEN DO:
    hBuffer:FIND-FIRST(" WHERE " + hBuffer:NAME + ".entity_mnemonic_description = '" + cEntity + "'") NO-ERROR.
    IF hBuffer:AVAILABLE THEN
      cEntity = hBuffer:BUFFER-FIELD("entity_mnemonic"):BUFFER-VALUE.
  END.
  
  cObjField = DYNAMIC-FUNCTION("getObjField":U IN gshGenManager,cEntity).
  IF cObjField = "":U OR cObjField = ? THEN
    cObjField = DYNAMIC-FUNCTION("getKeyField":U IN gshGenManager,cEntity).
  
  RETURN cObjField.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRunTimeAttributeTree) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRunTimeAttributeTree Procedure 
FUNCTION getRunTimeAttributeTree RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  This procedure returns the RunAttribute set for a folder window
            that was launched.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRunAttribute AS CHARACTER  NO-UNDO.

  DEFINE BUFFER ttProp FOR ttProp.
  DEFINE BUFFER ttFrame FOR ttFrame.

  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE NO-LOCK NO-ERROR.
  IF AVAILABLE ttProp AND
     VALID-HANDLE(ttProp.hCurrentFrame) THEN
  DO:
    FIND FIRST ttFrame
         WHERE ttFrame.hTargetProcedure = TARGET-PROCEDURE
         AND   ttframe.hFrameHandle     = ttProp.hCurrentFrame
         NO-LOCK NO-ERROR.
    IF AVAILABLE ttFrame THEN
      cRunAttribute = ttFrame.cRunAttribute.
  END.
  

  RETURN cRunAttribute.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTranslatableNodes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTranslatableNodes Procedure 
FUNCTION getTranslatableNodes RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will return a CHR(1) seperated list with plain text 
            nodes that could be translated.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTextNodes  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeLables AS CHARACTER  NO-UNDO.
  
  FOR EACH  ttNode
      WHERE ttNode.hTargetProcedure = TARGET-PROCEDURE
      NO-LOCK:
    IF ttNode.data_source_type = "TXT":U AND
       LOOKUP(ttNode.data_source,cTextNodes,CHR(1)) = 0 THEN
      cTextNodes = IF cTextNodes = "":U 
                  THEN ttNode.data_source
                  ELSE cTextNodes + CHR(1) + ttNode.data_source.
    IF LOOKUP("&Add " + ttNode.node_label,cNodeLables,CHR(1)) = 0 THEN
      cNodeLables = IF cNodeLables = "":U 
                 THEN "&Add " + ttNode.node_label
                 ELSE cNodeLables + CHR(1) + "&Add " + ttNode.node_label.
    
  END.
  
  RETURN (cTextNodes + CHR(2) + cNodeLables). /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTreeLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTreeLogicalName Procedure 
FUNCTION getTreeLogicalName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  This function was added to allow the Translation tool to get the 
            correct name of a DynTree object if the translation tool was called
            from an object on a Dynamic TreeView.
    Notes:  
------------------------------------------------------------------------------*/
  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE NO-LOCK NO-ERROR.

  IF AVAILABLE ttProp THEN
    RETURN ttProp.cTreeLogicalObjectName.
  ELSE
    RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTreeRunAttributeTree) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTreeRunAttributeTree Procedure 
FUNCTION getTreeRunAttributeTree RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will return the RunAttribute passed in for the Tree
            Container
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRunAttribute AS CHARACTER  NO-UNDO.

  DEFINE BUFFER ttProp FOR ttProp.
  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE NO-LOCK NO-ERROR.
  IF AVAILABLE ttProp THEN
    cRunAttribute = ttProp.cTreeRunAttribute.

  RETURN cRunAttribute.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-lockWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION lockWindow Procedure 
FUNCTION lockWindow RETURNS LOGICAL
  (plLockWindow AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  Will lock any screen activity for the session. Reduces flashing of
            screen while rendering objects.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iReturnCode       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hWindow           AS HANDLE     NO-UNDO.

  DEFINE BUFFER bl_ttProp FOR ttProp.

  {get containerHandle hWindow}.
  FIND FIRST bl_ttProp WHERE bl_ttProp.hTargetProcedure = TARGET-PROCEDURE NO-LOCK.

  bl_ttProp.iLockWindow = bl_ttProp.iLockWindow + (IF plLockWindow THEN 1 ELSE -1).

  IF plLockWindow AND bl_ttProp.iLockWindow > 1 THEN
    RETURN FALSE.

  IF NOT plLockWindow AND bl_ttProp.iLockWindow > 0 THEN
    RETURN FALSE.

  IF plLockWindow THEN
    RUN lockWindowUpdate IN gshSessionManager (INPUT hWindow:HWND, OUTPUT iReturnCode).
  ELSE
    RUN lockWindowUpdate IN gshSessionManager (INPUT 0, OUTPUT iReturnCode).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAutoSort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAutoSort Procedure 
FUNCTION setAutoSort RETURNS LOGICAL
  ( plAutoSort AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  This property is used to indicate if the Nodes should be sorted.
    Notes:  
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpAutoSort
  {set AutoSort plAutoSort}.
  &UNDEFINE xpAutoSort
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHideSelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setHideSelection Procedure 
FUNCTION setHideSelection RETURNS LOGICAL
  ( plHideSelection AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  This property determines whether the selected item will display as 
            selected when the TreeView loses focus
    Notes:  
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpHideSelection
  {set HideSelection plHideSelection}.
  &UNDEFINE xpHideSelection

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setImageHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setImageHeight Procedure 
FUNCTION setImageHeight RETURNS LOGICAL
  ( piImageHeight AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  This property sets the image height of the node's image
    Notes:  
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpImageHeight
  {set ImageHeight piImageHeight}.
  &UNDEFINE xpImageHeight

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setImageWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setImageWidth Procedure 
FUNCTION setImageWidth RETURNS LOGICAL
  ( piImageWidth AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  This property sets the image Width of the node's image
    Notes:  
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpImageWidth
  {set ImageWidth piImageWidth}.
  &UNDEFINE xpImageWidth

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLastLaunchedNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLastLaunchedNode Procedure 
FUNCTION setLastLaunchedNode RETURNS LOGICAL
  ( pcNodeKey AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will allow the value of the current selected node in
            the ttProp table to be reassigned to the passed value.
    Notes:  
------------------------------------------------------------------------------*/

  FIND FIRST ttProp WHERE ttProp.hTargetProcedure = TARGET-PROCEDURE EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE ttProp THEN
    ttProp.cCurrentNode = pcNodeKey.
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRootNodeCode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRootNodeCode Procedure 
FUNCTION setRootNodeCode RETURNS LOGICAL
  ( pcRootNodeCode AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This property indicates what the root node code is for the selected
            TreeView. This is then used to build the nodes from the gsm_node 
            table.
    Notes:  
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpRootNodeCode
  {set RootNodeCode pcRootNodeCode}.
  &UNDEFINE xpRootNodeCode

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setShowCheckBoxes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setShowCheckBoxes Procedure 
FUNCTION setShowCheckBoxes RETURNS LOGICAL
  ( plShowCheckBoxes AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  This property indicates whether each node should have a check-box
            next to it.
    Notes:  
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpShowCheckBoxes
  {set ShowCheckBoxes plShowCheckBoxes}.
  &UNDEFINE xpShowCheckBoxes

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setShowRootLines) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setShowRootLines Procedure 
FUNCTION setShowRootLines RETURNS LOGICAL
  ( plShowRootLines AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  This property indicates whether there should be lines displayed 
            between nodes.
    Notes:  
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpShowRootLines
  {set ShowRootLines plShowRootLines}.
  &UNDEFINE xpShowRootLines

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTreeStyle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTreeStyle Procedure 
FUNCTION setTreeStyle RETURNS LOGICAL
  ( piTreeStyle AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  This property sets the display style of the TreeView object.
    Notes:  
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpTreeStyle
  {set TreeStyle piTreeStyle}.
  &UNDEFINE xpTreeStyle

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

