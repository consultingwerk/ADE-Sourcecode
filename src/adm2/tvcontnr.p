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

    Modified    : 03/18/2002
    
    Moified     : 07/12/2002    Mark Davies (MIP)
                  Fixed issue #4932 - Object Type shows attributes of child 
                  if child attributes is accessed firsteeis opened fiorst
    Moified     : 08/07/2002    Mark Davies (MIP)
                  Fixed issue #5592 - Modifying a newly added record in a 
                  Dynamic TreeView creates a new nodet
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


&SCOP ADMSuper tvcontnr.p

  /* Custom exclude file */

  {src/adm2/custom/tvcontnrexclcustom.i}

/* include temp-table definitions */

{launch.i &DEFINE-ONLY=YES}
{checkerr.i &DEFINE-ONLY=YES}
{src/adm2/globals.i}

/* Define temp-tables required */
{src/adm2/treettdef.i}

DEFINE TEMP-TABLE ttNonTreeObjects NO-UNDO
  FIELDS hObjectHandle AS HANDLE.

DEFINE NEW GLOBAL SHARED VARIABLE gshLayoutManager AS HANDLE.
DEFINE NEW GLOBAL SHARED VARIABLE gshLayoutManagerID AS INTEGER.

IF NOT VALID-HANDLE(gshLayoutManager) 
OR gshLayoutManager:UNIQUE-ID <> gshLayoutManagerID THEN 
DO: 
    RUN ry/prc/rylayoutsp.p PERSISTENT SET gshLayoutManager.
    IF VALID-HANDLE(gshLayoutManager) THEN ASSIGN gshLayoutManagerID = gshLayoutManager:UNIQUE-ID.
END.

{src/adm2/tttranslate.i}
 
PROCEDURE GetSysColor EXTERNAL "user32":
  define input parameter nIn as LONG.
  define return parameter nCol as LONG.
END.

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

&IF DEFINED(EXCLUDE-checkQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD checkQueryString Procedure 
FUNCTION checkQueryString RETURNS LOGICAL
  ( pcObjField  AS CHARACTER,
    phSDOHandle AS HANDLE,
    pcNodeKey   AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-childWindowsOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD childWindowsOpen Procedure 
FUNCTION childWindowsOpen RETURNS LOGICAL
  ( )  FORWARD.

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

&IF DEFINED(EXCLUDE-getFieldList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldList Procedure 
FUNCTION getFieldList RETURNS CHARACTER
  (pcForeignFields AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMainTableObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMainTableObj Procedure 
FUNCTION getMainTableObj RETURNS DECIMAL
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

&IF DEFINED(EXCLUDE-getObjectVersionNumber) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectVersionNumber Procedure 
FUNCTION getObjectVersionNumber RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

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

&IF DEFINED(EXCLUDE-setContainerMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setContainerMode Procedure 
FUNCTION setContainerMode RETURNS LOGICAL
  ( INPUT cContainerMode AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setForeignFieldsForStructure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setForeignFieldsForStructure Procedure 
FUNCTION setForeignFieldsForStructure RETURNS LOGICAL
  ( pcForeignFields AS CHARACTER,
    phSDOHandle     AS HANDLE,
    phParentSDO     AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNodeExpanded) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNodeExpanded Procedure 
FUNCTION setNodeExpanded RETURNS LOGICAL
  ( INPUT pcNode         AS CHARACTER,
    INPUT plNodeExpanded AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTemplateObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTemplateObjectName Procedure 
FUNCTION setTemplateObjectName RETURNS LOGICAL
  ( INPUT pcTemplateObjectName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showMessages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD showMessages Procedure 
FUNCTION showMessages RETURNS LOGICAL
  ( INPUT pcMessage AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-toLogical) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD toLogical Procedure 
FUNCTION toLogical RETURNS LOGICAL
  ( INPUT pcText AS CHARACTER )  FORWARD.

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
         HEIGHT             = 28.29
         WIDTH              = 57.
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

&IF DEFINED(EXCLUDE-addRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord Procedure 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     We need to override this procedure to reposition the parent SDO
               to the correct record before we add. This needs to be done due
               to foreign fields.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTable          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNodeDetail     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dNodeObj        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cParentNodeSDO  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentNodeRef  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cParentNode     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRootNode       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRootNodeCode   AS CHARACTER  NO-UNDO.

  hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN TARGET-PROCEDURE).
  cParentNode  = DYNAMIC-FUNCTION("getParentNode":U IN TARGET-PROCEDURE).
  
  {get TreeDataTable hTable hTreeViewOCX}.  
  cRootNode = DYNAMIC-FUNCTION('getRootNodeParentKey':u IN hTreeViewOCX).

  ASSIGN cNodeDetail = getNodeDetails(hTable, cParentNode).

  ASSIGN dNodeObj = DECIMAL(ENTRY(1,cNodeDetail,CHR(2))).
  
  DYNAMIC-FUNCTION("setTreeContainerMode":U IN TARGET-PROCEDURE, "Add":U).
  DYNAMIC-FUNCTION("setNewContainerMode":U IN TARGET-PROCEDURE, "Add":U).

  EMPTY TEMP-TABLE ttNode.
  RUN getNodeTable IN TARGET-PROCEDURE (OUTPUT TABLE ttNode).
  
  IF cParentNode = cRootNode AND
     dNodeObj  = 0 THEN DO:
    cRootNodeCode = DYNAMIC-FUNCTION("getRootNodeCode":U IN TARGET-PROCEDURE).
    FIND FIRST ttNode
         WHERE ttNode.node_code = cRootNodeCode
         NO-LOCK NO-ERROR.
    IF AVAILABLE ttNode THEN
      dNodeObj = ttNode.node_obj.
    DYNAMIC-FUNCTION("setNodeObj":U IN TARGET-PROCEDURE,dNodeObj).
  END.
  ELSE
    /* Get Parent Node Info */
    FIND FIRST ttNode
         WHERE ttNode.node_obj = dNodeObj
         NO-LOCK NO-ERROR.
    IF DYNAMIC-FUNCTION("getNodeObj":U IN TARGET-PROCEDURE) = 0 AND dNodeObj <> 0 THEN
      DYNAMIC-FUNCTION("setNodeObj":U IN TARGET-PROCEDURE,dNodeObj).

  DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ParentKeyValue":U, "":U).
  
  cParentNodeSDO = "":U.
  IF AVAILABLE ttNode THEN DO:
    IF ttNode.run_attribute = "STRUCTURED":U THEN DO:
      ASSIGN cParentNodeRef = ENTRY(3,cNodeDetail,CHR(2)).
      DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ParentKeyValue":U, cParentNodeRef).
    END.
    ASSIGN cParentNodeSDO = IF ttNode.data_source_type <> "TXT":U THEN ttNode.data_source ELSE ttNode.primary_sdo.
  END.
  /* We need to reposition the Parent SDO for the foreign Fields */
  RUN repositionParentSDO IN TARGET-PROCEDURE (INPUT cParentNodeSDO,
                                               INPUT cParentNode).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRecord Procedure 
PROCEDURE cancelRecord :
/*------------------------------------------------------------------------------
  Purpose:     Captures the event when an Add/Copy/Modify was cancelled.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTable          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBuf            AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hQry            AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lNewChildNode   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cCurrentNodeKey AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cParentNode     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cNewParentNode  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSDOHandle      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cDataSource     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hDataSource     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iLoop           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cCurrentNode    AS CHARACTER NO-UNDO.
  
  lNewChildNode = DYNAMIC-FUNCTION("getNewChildNode":U IN TARGET-PROCEDURE).
  hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN TARGET-PROCEDURE).
  cCurrentNodeKey = DYNAMIC-FUNCTION("getCurrentNodeKey":U IN TARGET-PROCEDURE).
  cParentNode = DYNAMIC-FUNCTION("getParentNode":U IN TARGET-PROCEDURE).
  IF lNewChildNode THEN DO:
    {get TreeDataTable hTable hTreeViewOCX}.
    ASSIGN hBuf = hTable:DEFAULT-BUFFER-HANDLE.
    IF cCurrentNodeKey <> ? THEN DO:
      CREATE QUERY hQry.  
      hQry:ADD-BUFFER(hBuf).
      hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.node_key = "&2"':U, hTable:NAME,cCurrentNodeKey)).
      hQry:QUERY-OPEN().
      hQry:GET-FIRST().
      IF hBuf:AVAILABLE THEN
        hBuf:BUFFER-DELETE().
      IF VALID-HANDLE(hQry) THEN
        DELETE OBJECT hQry.
    END.
    
    RUN deleteNode IN hTreeViewOCX (cCurrentNodeKey).
    DYNAMIC-FUNCTION("setNewChildNode":U IN TARGET-PROCEDURE,FALSE).
    DYNAMIC-FUNCTION("setCurrentMode":U IN TARGET-PROCEDURE,"Cancel":U).
    hSDOHandle = DYNAMIC-FUNCTION("getSDOHandle":U IN TARGET-PROCEDURE).
    cDataSource = DYNAMIC-FUNCTION("LinkHandles":U IN hSDOHandle,"data-target":U).
    DO iLoop = 1 TO NUM-ENTRIES(cDataSource):
      hDataSource = WIDGET-HANDLE(ENTRY(iLoop,cDataSource)).
      IF VALID-HANDLE(hDataSource) AND 
         LOOKUP("cancelRecord":U,hDataSource:INTERNAL-ENTRIES) > 0 THEN
      RUN cancelRecord IN hDataSource.
    END.
    DYNAMIC-FUNCTION("selectNode" IN hTreeViewOCX, cParentNode).
    cNewParentNode = DYNAMIC-FUNCTION("getProperty" IN hTreeViewOCX, "PARENT":U, cParentNode).
    DYNAMIC-FUNCTION("setParentNode":U IN TARGET-PROCEDURE,cNewParentNode).
    RUN tvNodeSelected IN TARGET-PROCEDURE (cParentNode).
  END.
  ELSE DO:
    ASSIGN cCurrentNode = DYNAMIC-FUNCTION("getSelectedNode" IN hTreeViewOCX).
    IF cCurrentNode = ? THEN
      ASSIGN cCurrentNode = DYNAMIC-FUNCTION("getProperty" IN hTreeViewOCX, "CHILD", cParentNode).
    IF cCurrentNode <> ? THEN
      DYNAMIC-FUNCTION("setCurrentNodeKey":U IN TARGET-PROCEDURE,cCurrentNode).
  END.
    
  DYNAMIC-FUNCTION("setCurrentMode":U IN TARGET-PROCEDURE,"Cancel":U).
  DYNAMIC-FUNCTION("setNewChildNode":U IN TARGET-PROCEDURE,FALSE).
  DYNAMIC-FUNCTION("setNewContainerMode":U IN TARGET-PROCEDURE,"View":U).
    
  RUN setContainerViewMode IN TARGET-PROCEDURE.
  IF VALID-HANDLE(hTreeViewOCX) THEN
    RUN enableObject IN hTreeViewOCX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyRecord Procedure 
PROCEDURE copyRecord :
/*------------------------------------------------------------------------------
  Purpose:     We need to override this procedure to reposition the parent SDO
               to the correct record before we add. This needs to be done due
               to foreign fields.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTable          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNodeDetail     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dNodeObj        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cParentNodeSDO  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cParentNode      AS CHARACTER NO-UNDO.

  hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN TARGET-PROCEDURE).
  cParentNode = DYNAMIC-FUNCTION("getParentNode":U IN TARGET-PROCEDURE).

  {get TreeDataTable hTable hTreeViewOCX}.  
  EMPTY TEMP-TABLE ttNode.
  RUN getNodeTable IN TARGET-PROCEDURE (OUTPUT TABLE ttNode).
            
  ASSIGN cNodeDetail = DYNAMIC-FUNCTION("getNodeDetails":U IN TARGET-PROCEDURE, hTable, cParentNode).

  ASSIGN dNodeObj = DECIMAL(ENTRY(1,cNodeDetail,CHR(2))).
  
  DYNAMIC-FUNCTION("setTreeContainerMode":U IN TARGET-PROCEDURE,"Copy":U).
  DYNAMIC-FUNCTION("setNewContainerMode":U IN TARGET-PROCEDURE, "Copy":U).
  
  /* Get Parent Node Info */
  FIND FIRST ttNode
       WHERE ttNode.node_obj = dNodeObj
       NO-LOCK NO-ERROR.
  
  cParentNodeSDO = "":U.
  IF AVAILABLE ttNode THEN
    ASSIGN cParentNodeSDO = IF ttNode.data_source_type <> "TXT":U THEN ttNode.data_source ELSE ttNode.primary_sdo.
  /* We need to reposition the Parent SDO for the foreign Fields */
  RUN repositionParentSDO IN TARGET-PROCEDURE (INPUT cParentNodeSDO,
                                               INPUT cParentNode).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createDummyChild) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createDummyChild Procedure 
PROCEDURE createDummyChild :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phBuf           AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcParentNodeKey AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcType          AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE hParentNodeKey          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeKey                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeLabel              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRecordRef              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeInsert             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX            AS HANDLE     NO-UNDO.

  hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN TARGET-PROCEDURE).

  ASSIGN hParentNodeKey = phBuf:BUFFER-FIELD('parent_node_key':U)
         hNodeKey       = phBuf:BUFFER-FIELD('node_key':U)
         hNodeLabel     = phBuf:BUFFER-FIELD('node_label':U)
         hRecordRef     = phBuf:BUFFER-FIELD('record_ref':U)
         hNodeInsert    = phBuf:BUFFER-FIELD('node_insert':U).
         
  phBuf:BUFFER-CREATE().
  ASSIGN hParentNodeKey:BUFFER-VALUE = pcParentNodeKey
         hNodeKey:BUFFER-VALUE       = DYNAMIC-FUNCTION('getNextNodeKey':U IN hTreeViewOCX)
         hNodeLabel:BUFFER-VALUE     = IF pcType = "New":U THEN "<New>":U ELSE "+":U
         hRecordRef:BUFFER-VALUE     = IF pcType = "New":U THEN 0 ELSE 99
         hNodeInsert:BUFFER-VALUE    = 4.

  IF pcType = "NEW":U THEN DO:
    DYNAMIC-FUNCTION("setParentNode":U IN TARGET-PROCEDURE,pcParentNodeKey).
    DYNAMIC-FUNCTION("setCurrentNodeKey":U IN TARGET-PROCEDURE,hNodeKey:BUFFER-VALUE).
  END.
  
  IF pcType = "DUMMYADD":U THEN
    RUN AddNode IN hTreeViewOCX (INPUT phBuf).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteComplete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteComplete Procedure 
PROCEDURE deleteComplete :
/*------------------------------------------------------------------------------
  Purpose:    When the SDO has successfully deleted a record is publishes a 
              'deleteComplete'. We catch this and route it to updateState to  
              synchronise the TreeView.
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  RUN updateState IN TARGET-PROCEDURE ("deleteComplete":U).
  
  DYNAMIC-FUNCTION("setDelete":U IN TARGET-PROCEDURE,TRUE).
  DYNAMIC-FUNCTION("setCurrentMode":U IN TARGET-PROCEDURE,"delete":U).
  DYNAMIC-FUNCTION("setNewContainerMode":U IN TARGET-PROCEDURE,"View":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteNodeRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteNodeRecord Procedure 
PROCEDURE deleteNodeRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcCurrentNodeKey AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hTable        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQry          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuf          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX  AS HANDLE     NO-UNDO.

  hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN TARGET-PROCEDURE).
  
  IF pcCurrentNodeKey <> ? THEN DO:
    {get TreeDataTable hTable hTreeViewOCX}.  

    ASSIGN hBuf = hTable:DEFAULT-BUFFER-HANDLE.
    CREATE QUERY hQry.  
    hQry:ADD-BUFFER(hBuf).
    hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.node_key = "&2"':U, hTable:NAME,pcCurrentNodeKey)).
    hQry:QUERY-OPEN().
    hQry:GET-FIRST().
    IF hBuf:AVAILABLE THEN
      hBuf:BUFFER-DELETE().
    IF VALID-HANDLE(hQry) THEN
      DELETE OBJECT hQry.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchFirst) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchFirst Procedure 
PROCEDURE fetchFirst :
/*------------------------------------------------------------------------------
  Purpose:     Move to first node in heirarachy
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  RUN fetchRequest IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchLast) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchLast Procedure 
PROCEDURE fetchLast :
/*------------------------------------------------------------------------------
  Purpose:     Move to last node in heirarachy
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  RUN fetchRequest IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchNext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchNext Procedure 
PROCEDURE fetchNext :
/*------------------------------------------------------------------------------
  Purpose:     Move to next node in heirarachy
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  RUN fetchRequest IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchPrev) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchPrev Procedure 
PROCEDURE fetchPrev :
/*------------------------------------------------------------------------------
  Purpose:     Move to previous node in heirarachy
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  RUN fetchRequest IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchRequest) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchRequest Procedure 
PROCEDURE fetchRequest :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will fire after a fetch.... request from the SDO.
               It is usually run from fetchNext/Prev/Firs/Last in this procedure.
               This procedure will read the RowId from the Node Temp Table and
               reposition to that record on the SDO.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cCurrentNode            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentNode             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTable                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuf                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQry                    AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE hNode                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNodeKey                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hNodeObj                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dNodeObj                AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hPrivateData            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cPrivateData            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataset                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSourceType         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSource             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDOHandle              AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE cValueList              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjField               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRecordRef              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cPrimarySDOName         AS CHARACTER  NO-UNDO.

  EMPTY TEMP-TABLE ttRunningSDOs.
  RUN getRunningSDOs IN TARGET-PROCEDURE (OUTPUT TABLE ttRunningSDOs).

  hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN TARGET-PROCEDURE).
  cPrimarySDOName = DYNAMIC-FUNCTION("getPrimarySDOName":U IN TARGET-PROCEDURE).
  
  IF VALID-HANDLE(hTreeViewOCX) THEN
    cCurrentNode = DYNAMIC-FUNCTION("getSelectedNode" IN hTreeViewOCX).
  
  IF cCurrentNode = ? THEN
    RETURN.
  
  ASSIGN cParentNode = DYNAMIC-FUNCTION("getProperty" IN hTreeViewOCX ,INPUT "PARENT":U, INPUT cCurrentNode) NO-ERROR.
  IF ERROR-STATUS:ERROR OR 
     cParentNode = ? OR
     cParentNode = "":U THEN
    cParentNode = ?.
    
  {get TreeDataTable hTable hTreeViewOCX}.
  
  FIND FIRST ttRunningSDOs
       WHERE ttRunningSDOs.cSDOName = cPrimarySDOName
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ttRunningSDOs THEN
    RETURN.
  ELSE
    hSDOHandle = ttRunningSDOs.hSDOHandle.
  
  IF NOT VALID-HANDLE(hSDOHandle) THEN
    RETURN.
  
  ASSIGN cValueList = DYNAMIC-FUNCTION("getEntityName":U IN TARGET-PROCEDURE,hSDOHandle)
         cObjField = DYNAMIC-FUNCTION("getObjKeyField":U IN TARGET-PROCEDURE,cValueList).
  
  ASSIGN cRecordRef = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hSDOHandle, cObjField)).
  
  /* Grab the handles to the individual fields in the tree data table. */
  ASSIGN hBuf  = hTable:DEFAULT-BUFFER-HANDLE
         hNode = hBuf:BUFFER-FIELD('node_key':U).
  
  CREATE QUERY hQry.  
  hQry:ADD-BUFFER(hBuf).
  IF cParentNode = ? THEN
    hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.record_ref = "&2" AND &1.parent_node_key = ?':U, hTable:NAME,cRecordRef)).
  ELSE
    hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.record_ref = "&2" AND &1.parent_node_key = "&3"':U, hTable:NAME,cRecordRef,cParentNode)).
  
  hQry:QUERY-OPEN().
  hQry:GET-FIRST().
  
  DO WHILE hBuf:AVAILABLE:
    ASSIGN cNodeKey = hNode:BUFFER-VALUE
           NO-ERROR.
    hQry:GET-NEXT().
  END.

  IF VALID-HANDLE(hQry) THEN
    DELETE OBJECT hQry.

  DYNAMIC-FUNCTION("setCurrentNodeKey":U IN TARGET-PROCEDURE, cNodeKey).
    
  IF cNodeKey <> ? AND 
     VALID-HANDLE(hTreeViewOCX) THEN
    DYNAMIC-FUNCTION("selectNode":U IN hTreeViewOCX, cNodeKey).  
 
  RUN setDataLinkActive IN TARGET-PROCEDURE.
  RUN nodeSelected IN TARGET-PROCEDURE (INPUT cNodeKey).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFolder                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFolderToolbar            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainerToolbar         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTitleFillIn              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hResizeFillIn             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRectangle                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lStatusBarVisible         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hFilterViewer             AS HANDLE     NO-UNDO.
  
  DYNAMIC-FUNCTION('obtainContextForServer':U IN TARGET-PROCEDURE).

  RUN SUPER.

  RUN getTreeObjects IN TARGET-PROCEDURE (OUTPUT hFolder,
                                          OUTPUT hFolderToolbar,
                                          OUTPUT hContainerToolbar,
                                          OUTPUT hTitleFillIn,
                                          OUTPUT hResizeFillIn,
                                          OUTPUT hTreeViewOCX,
                                          OUTPUT hRectangle,
                                          OUTPUT lStatusBarVisible,
                                          OUTPUT hFilterViewer).
  IF VALID-HANDLE(hFolderToolbar) THEN
    RUN removeLink IN TARGET-PROCEDURE (hFolderToolbar,"TableIO",TARGET-PROCEDURE).

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
  
  DEFINE VARIABLE cDataset                AS CHARACTER  NO-UNDO.
  
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
  DEFINE VARIABLE hTable                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDetailList             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX            AS HANDLE     NO-UNDO.

  hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN TARGET-PROCEDURE).

  IF pdChildNodeObj = 0 THEN
    RETURN.
  EMPTY TEMP-TABLE ttNode.
  RUN getNodeTable IN TARGET-PROCEDURE (OUTPUT TABLE ttNode).
  
  FIND FIRST ttNode
       WHERE ttNode.node_obj = pdChildNodeObj
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ttNode THEN
    RETURN.
  
  ASSIGN cDataSource            = ttNode.data_source
         cImageFileName         = ttNode.image_file_name
         cSelectedImageFileName = ttNode.selected_image_file_name
         NO-ERROR.
  
  {get TreeDataTable hTable hTreeViewOCX}.  
  
  {launch.i &PLIP  = 'ry/app/rytrenodep.p' 
              &IPROC = 'readMenuStructure' 
              &ONAPP = 'YES'
              &PLIST = "(INPUT cDataSource, INPUT 0, OUTPUT cDetailList)"
              &AUTOKILL = YES}

   RUN stripMNUDetails IN TARGET-PROCEDURE 
                       (INPUT pcParentNodeKey,
                        INPUT cDetailList,
                        INPUT pdChildNodeObj,
                        INPUT cImageFileName,
                        INPUT cSelectedImageFileName).
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
  EMPTY TEMP-TABLE ttNode.
  RUN getNodeTable IN TARGET-PROCEDURE (OUTPUT TABLE ttNode).
    
  cDataSourceType = "":U.
  FIND FIRST ttNode
       WHERE ttNode.node_obj = pdChildNodeObj
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ttNode THEN
    RETURN.
  ELSE
    ASSIGN cDataSourceType = ttNode.data_source_type NO-ERROR.

  {fnarg lockWindow TRUE} NO-ERROR.

  CASE cDataSourceType:
    WHEN "SDO":U THEN DO:
      RUN loadSDOSBOData IN TARGET-PROCEDURE (INPUT pcParentNodeKey, INPUT pdChildNodeObj).
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
      RUN showMessages IN gshSessionManager (INPUT  "Unknown Data Source Specified (" + cDataSourceType + ")",    /* message to display */
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

  {fnarg lockWindow FALSE} NO-ERROR.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadPRGData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadPRGData Procedure 
PROCEDURE loadPRGData :
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
  DEFINE VARIABLE cErrorMessage           AS CHARACTER  NO-UNDO.
  /* Define Temp-Table Variables */
  DEFINE VARIABLE hBuf                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQry                    AS HANDLE     NO-UNDO.
                                         
  DEFINE VARIABLE hParentNodeKey          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeKey                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeObj                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeLabel              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRecordRef              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRecordRowId            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeChecked            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hImage                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSelectedImage          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeInsert             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSort                   AS HANDLE     NO-UNDO.

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
  
  DEFINE VARIABLE hSDOHandle              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cValueList              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTable                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjField               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterFieldName        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterFieldValue       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cWhere                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lRowAvailable           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSubstitute             AS CHARACTER  NO-UNDO EXTENT 9.
  DEFINE VARIABLE lHasChildren            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSDOSBOName             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPrimarySDO             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFilterValue            AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bttNode FOR ttNode.
  
  
  IF pdChildNodeObj = 0 THEN
    RETURN.
  EMPTY TEMP-TABLE ttNode.
  RUN getNodeTable IN TARGET-PROCEDURE (OUTPUT TABLE ttNode).
  
  hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN TARGET-PROCEDURE).

  FIND FIRST ttNode
       WHERE ttNode.node_obj = pdChildNodeObj
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ttNode THEN
    RETURN.
  
  FIND FIRST bttNode
       WHERE bttNode.parent_node_obj = pdChildNodeObj
       NO-LOCK NO-ERROR.
  IF AVAILABLE bttNode THEN
    lHasChildren = TRUE.
  
  ASSIGN lNodeChecked           = ttNode.node_checked
         cDataSource            = ttNode.data_source
         cFieldToStore          = ttNode.fields_to_store
         cForeignFields         = ttNode.foreign_fields
         cImageFileName         = ttNode.image_file_name
         cSelectedImageFileName = ttNode.selected_image_file_name
         dParentNodeObj         = ttNode.parent_node_obj
         cParentNodeSDO         = ttNode.primary_sdo
         cLabelSubsFields       = ttNode.label_text_substitution_fields
         cPrimarySDO            = ttNode.primary_sdo
         NO-ERROR.
  
  DO TRANSACTION:
    FIND CURRENT ttNode EXCLUSIVE-LOCK.
    ASSIGN ttNode.data_source = ttNode.primary_sdo
           ttNode.data_source_type = "SDO":U.
    FIND CURRENT ttNode NO-LOCK.
    SESSION:SET-WAIT-STATE("GENERAL":U).
    cSDOSBOName = cPrimarySDO.
    RUN manageSDOs IN TARGET-PROCEDURE
                   (INPUT  cSDOSBOName,
                    INPUT  cForeignFields,
                    INPUT  "":U,
                    INPUT cLabelSubsFields,
                    INPUT FALSE,
                    INPUT "":U,
                    OUTPUT hSDOHandle).
     IF NOT VALID-HANDLE(hSDOHandle) THEN DO:
       SESSION:SET-WAIT-STATE("":U).
       RETURN.
     END.
  END.
  
  {get TreeDataTable hTable hTreeViewOCX}.  
  /* Grab the handles to the individual fields in the tree data table. */
  ASSIGN hBuf           = hTable:DEFAULT-BUFFER-HANDLE
         hParentNodeKey = hBuf:BUFFER-FIELD('parent_node_key':U)
         hNodeKey       = hBuf:BUFFER-FIELD('node_key':U)
         hNodeObj       = hBuf:BUFFER-FIELD('node_obj':U)
         hNodeChecked   = hBuf:BUFFER-FIELD('node_checked':U)
         hImage         = hBuf:BUFFER-FIELD('image':U)
         hSelectedImage = hBuf:BUFFER-FIELD('selected_image':U)
         hSort          = hBuf:BUFFER-FIELD('node_sort':U)
         hNodeInsert    = hBuf:BUFFER-FIELD('node_insert':U).

  /* See if the SDO is already running */
  
  SESSION:SET-WAIT-STATE("GENERAL":U).
  cFilterValue = DYNAMIC-FUNCTION("getFilterValue":U IN TARGET-PROCEDURE).
  /* Run the program to populate the data */
  {launch.i &PLIP  = cDataSource 
              &IPROC = 'loadData' 
              &ONAPP = 'YES'
              &PLIST = "(INPUT pcParentNodeKey, INPUT cParentNodeSDO, INPUT cFilterValue, INPUT-OUTPUT TABLE-HANDLE hTable)"
              &AUTOKILL = YES}
  IF ERROR-STATUS:ERROR THEN DO:
    SESSION:SET-WAIT-STATE("":U).
    cErrorMessage = "Could not launch extract program '" + cDataSource + "' on AppServer.~nError returned from launch program: " + ERROR-STATUS:GET-MESSAGE(1).
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

  CREATE QUERY hQry.
  hQry:ADD-BUFFER(hBuf).
  hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.parent_node_key = "&2":U AND &1.node_obj = 0 BY &1.node_key':U, hTable:NAME,pcParentNodeKey)).
  hQry:QUERY-OPEN().
  hQry:GET-FIRST().

  /* Now we'll just add the other data from the gsm_node record */
  DO WHILE hBuf:AVAILABLE:
    ASSIGN hNodeKey:BUFFER-VALUE       = DYNAMIC-FUNCTION('getNextNodeKey':U IN hTreeViewOCX)
           hNodeObj:BUFFER-VALUE       = pdChildNodeObj
           hNodeChecked:BUFFER-VALUE   = lNodeChecked
           hImage:BUFFER-VALUE         = IF hImage:BUFFER-VALUE = "":U OR hImage:BUFFER-VALUE = ? THEN cImageFileName ELSE hImage:BUFFER-VALUE
           hSelectedImage:BUFFER-VALUE = IF hSelectedImage:BUFFER-VALUE = "":U OR hSelectedImage:BUFFER-VALUE = ? THEN cSelectedImageFileName ELSE hSelectedImage:BUFFER-VALUE
           hSort:BUFFER-VALUE          = TRUE
           hNodeInsert:BUFFER-VALUE    = IF pcParentNodeKey = "":U THEN 1 ELSE 4.
    
    /* Create a Dummy Child node record */
    IF lHasChildren THEN
      RUN createDummyChild IN TARGET-PROCEDURE
                          (INPUT hBuf,
                           INPUT hNodeKey:BUFFER-VALUE,
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
  DEFINE VARIABLE hParentNodeKey          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeKey                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeObj                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeLabel              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRecordRef              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRecordRowId            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeChecked            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hImage                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSelectedImage          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeInsert             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSort                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hPrivateData            AS HANDLE     NO-UNDO.
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

  DEFINE BUFFER bttNode FOR ttNode.

  IF pdChildNodeObj = 0 THEN
    RETURN.
  EMPTY TEMP-TABLE ttRunningSDOs.
  RUN getRunningSDOs IN TARGET-PROCEDURE (OUTPUT TABLE ttRunningSDOs).
  
  EMPTY TEMP-TABLE ttNode.
  RUN getNodeTable IN TARGET-PROCEDURE (OUTPUT TABLE ttNode).
    
  FIND FIRST ttNode
       WHERE ttNode.node_obj = pdChildNodeObj
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ttNode THEN
    RETURN.
  
  FIND FIRST bttNode
       WHERE bttNode.parent_node_obj = pdChildNodeObj
       NO-LOCK NO-ERROR.
  IF AVAILABLE bttNode THEN
    lHasChildren = TRUE.

  ASSIGN cNodeLabel             = ttNode.node_label
         lNodeChecked           = ttNode.node_checked
         cDataSource            = ttNode.data_source
         cFieldToStore          = ttNode.fields_to_store
         cNodeLabelExpression   = ttNode.node_text_label_expression
         cLabelSubsFields       = ttNode.label_text_substitution_fields
         cForeignFields         = ttNode.foreign_fields
         cImageFileName         = ttNode.image_file_name
         cSelectedImageFileName = ttNode.selected_image_file_name
         dParentNodeObj         = ttNode.parent_node_obj
         cInstanceAttributes    = ttNode.run_attribute
         NO-ERROR.
  IF (cInstanceAttributes <> "STRUCTURED":U) THEN
    DYNAMIC-FUNCTION("setInstanceAttributes":U IN TARGET-PROCEDURE,cInstanceAttributes).

  /* Always assume children for structured Tree Nodes */
  IF (cInstanceAttributes = "STRUCTURED":U) THEN
    lHasChildren = TRUE.
  /* Get Parent Node Info */
  cDataset = "":U.
  FIND FIRST ttNode
       WHERE ttNode.node_obj = dParentNodeObj
       NO-LOCK NO-ERROR.
  cParentNodeSDO = "":U.
  IF AVAILABLE ttNode THEN
    ASSIGN cParentNodeSDO  = IF ttNode.data_source_type <> "TXT":U AND ttNode.data_source_type <> "PRG":U THEN ttNode.data_source ELSE ttNode.primary_sdo.
  /* We need to reposition the Parent SDO for the foreign Fields */
  IF cParentNodeSDO <> "":U AND 
     DYNAMIC-FUNCTION("getReposParentNode":U IN TARGET-PROCEDURE) THEN DO:
    RUN repositionParentSDO IN TARGET-PROCEDURE
                            (INPUT cParentNodeSDO,
                             INPUT pcParentNodeKey).
  END.
  DYNAMIC-FUNCTION("setReposParentNode":U IN TARGET-PROCEDURE, TRUE).
  
  IF cDataSource = "":U OR 
     cDataSource = ? THEN
   RETURN.
  
  RUN manageSDOs IN TARGET-PROCEDURE 
                 (INPUT  cDataSource,
                  INPUT  cForeignFields,
                  INPUT  cParentNodeSDO,
                  INPUT  cLabelSubsFields,
                  INPUT  (cInstanceAttributes = "STRUCTURED":U),
                  INPUT  cFieldToStore,
                  OUTPUT hSDOHandle).
  IF NOT VALID-HANDLE(hSDOHandle) THEN
    RETURN.
  
  hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN TARGET-PROCEDURE).

  {get TreeDataTable hTable hTreeViewOCX}.  
  /* Grab the handles to the individual fields in the tree data table. */
  ASSIGN hBuf           = hTable:DEFAULT-BUFFER-HANDLE
         hParentNodeKey = hBuf:BUFFER-FIELD('parent_node_key':U)
         hNodeKey       = hBuf:BUFFER-FIELD('node_key':U)
         hNodeObj       = hBuf:BUFFER-FIELD('node_obj':U)
         hNodeLabel     = hBuf:BUFFER-FIELD('node_label':U)
         hRecordRef     = hBuf:BUFFER-FIELD('record_ref':U)
         hRecordRowId   = hBuf:BUFFER-FIELD('record_rowid':U)
         hNodeChecked   = hBuf:BUFFER-FIELD('node_checked':U)
         hImage         = hBuf:BUFFER-FIELD('image':U)
         hSelectedImage = hBuf:BUFFER-FIELD('selected_image':U)
         hSort          = hBuf:BUFFER-FIELD('node_sort':U)
         hNodeInsert    = hBuf:BUFFER-FIELD('node_insert':U)
         hPrivateData   = hBuf:BUFFER-FIELD('private_data':U).
         
         cRootParentNodeKey = DYNAMIC-FUNCTION('getRootNodeParentKey':u IN hTreeViewOCX).
  
  /* See if the SDO is already running */
  
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
  
  RUN setDataLinkInActive IN TARGET-PROCEDURE.
  FIND FIRST ttRunningSDOs
       WHERE ttRunningSDOs.hSDOHandle = hSDOHandle
       NO-LOCK NO-ERROR.
  IF AVAILABLE ttRunningSDOs AND
     DYNAMIC-FUNCTION("getServerOperatingMode" IN hSDOHandle) = ? AND
     ttRunningSDOs.cServerMode <> "":U THEN
    DYNAMIC-FUNCTION("setServerOperatingMode" IN hSDOHandle, ttRunningSDOs.cServerMode).

  DYNAMIC-FUNCTION("CloseQuery":U IN hSDOHandle).
  DYNAMIC-FUNCTION("setRowsToBatch":U IN hSDOHandle, 200).
  
  DYNAMIC-FUNCTION("OpenQuery":U IN hSDOHandle).
  
  RUN fetchFirst IN hSDOHandle.
  lRowAvailable = DYNAMIC-FUNCTION("rowAvailable":U IN hSDOHandle, "CURRENT":U).
  IF NOT lRowAvailable THEN DO:
    DYNAMIC-FUNCTION("setExpand":U IN TARGET-PROCEDURE,FALSE).
    RETURN.
  END.
           
  RECORD_AVAILABLE:
  DO WHILE lRowAvailable = TRUE:
    DO iLoop = 1 TO NUM-ENTRIES(cLabelSubsFields):
      cSubstitute[iLoop] = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hSDOHandle, ENTRY(iLoop,cLabelSubsFields))).
      IF cSubstitute[iLoop] = ? THEN
        cSubstitute[iLoop] = "":U.
    END.
    
    cRecordRef = assignRefValue(cObjField,hSDOHandle).
    
    hBuf:BUFFER-CREATE().
    ASSIGN hParentNodeKey:BUFFER-VALUE = pcParentNodeKey
           hNodeKey:BUFFER-VALUE       = DYNAMIC-FUNCTION('getNextNodeKey':U IN hTreeViewOCX)
           hNodeObj:BUFFER-VALUE       = pdChildNodeObj
           hNodeLabel:BUFFER-VALUE     = TRIM(SUBSTITUTE(cNodeLabelExpression,cSubstitute[1],cSubstitute[2],cSubstitute[3],cSubstitute[4],cSubstitute[5],cSubstitute[6],cSubstitute[7],cSubstitute[8],cSubstitute[9]))
           hRecordRef:BUFFER-VALUE     = cRecordRef
           hRecordRowId:BUFFER-VALUE   = TO-ROWID(ENTRY(1,DYNAMIC-FUNCTION("getRowIdent":U IN hSDOHandle)))
           hNodeChecked:BUFFER-VALUE   = lNodeChecked
           hImage:BUFFER-VALUE         = TRIM(cImageFileName)
           hSelectedImage:BUFFER-VALUE = TRIM(cSelectedImageFileName)
           hSort:BUFFER-VALUE          = TRUE
           hNodeInsert:BUFFER-VALUE    = IF pcParentNodeKey = "":U THEN 1 ELSE 4.
    IF (cInstanceAttributes = "STRUCTURED":U) THEN DO:
      DEFINE VARIABLE cChildKey AS CHARACTER  NO-UNDO.
      IF NUM-ENTRIES(cFieldToStore,"^":U) >= 3 THEN DO:
        cChildKey = ENTRY(3,cFieldToStore,"^":U).
        hPrivateData:BUFFER-VALUE = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hSDOHandle, cChildKey)).
      END.
    END.
    /* Create a Dummy Child node record */
    IF lHasChildren THEN
      RUN createDummyChild IN TARGET-PROCEDURE
                           (INPUT hBuf,
                            INPUT hNodeKey:BUFFER-VALUE,
                            INPUT "DUMMY":U).

    lRowAvailable = DYNAMIC-FUNCTION("rowAvailable":U IN hSDOHandle, "NEXT":U). 
    IF lRowAvailable THEN 
      RUN fetchNext IN hSDOHandle.
    ELSE 
      LEAVE RECORD_AVAILABLE.
  END. /* WHILE */
  
  RUN setDataLinkActive IN TARGET-PROCEDURE.

  DYNAMIC-FUNCTION("setExpand":U IN TARGET-PROCEDURE,FALSE).
  
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
  DEFINE VARIABLE hQry                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hParentNodeKey          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeKey                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeObj                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeLabel              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRecordRef              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRecordRowId            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeChecked            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hImage                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSelectedImage          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeInsert             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSort                   AS HANDLE     NO-UNDO.
  
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

  DEFINE BUFFER bttNode FOR ttNode.

  IF pdChildNodeObj = 0 THEN
    RETURN.
  EMPTY TEMP-TABLE ttNode.
  RUN getNodeTable IN TARGET-PROCEDURE (OUTPUT TABLE ttNode).
  
  FIND FIRST ttNode
       WHERE ttNode.node_obj = pdChildNodeObj
       NO-LOCK NO-ERROR.

  FIND FIRST bttNode
       WHERE bttNode.parent_node_obj = pdChildNodeObj
       NO-LOCK NO-ERROR.
  IF AVAILABLE bttNode THEN
    lHasChildren = TRUE.
  
  IF NOT AVAILABLE ttNode THEN
    RETURN.
  
  ASSIGN cNodeLabel             = ttNode.node_label
         lNodeChecked           = ttNode.node_checked
         cDataSource            = ttNode.data_source
         cFieldToStore          = ttNode.fields_to_store
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
       WHERE ttNode.node_obj = dParentNodeObj
       NO-LOCK NO-ERROR.
  cParentNodeSDO = "":U.
  IF AVAILABLE ttNode THEN /* Check for Parent Node */
    ASSIGN cParentNodeSDO = ttNode.data_source.
  
  hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN TARGET-PROCEDURE).

  {get TreeDataTable hTable hTreeViewOCX}.  
  /* Grab the handles to the individual fields in the tree data table. */
  ASSIGN hBuf           = hTable:DEFAULT-BUFFER-HANDLE
         hParentNodeKey = hBuf:BUFFER-FIELD('parent_node_key':U)
         hNodeKey       = hBuf:BUFFER-FIELD('node_key':U)
         hNodeObj       = hBuf:BUFFER-FIELD('node_obj':U)
         hNodeLabel     = hBuf:BUFFER-FIELD('node_label':U)
         hRecordRef     = hBuf:BUFFER-FIELD('record_ref':U)
         hRecordRowId   = hBuf:BUFFER-FIELD('record_rowid':U)
         hNodeChecked   = hBuf:BUFFER-FIELD('node_checked':U)
         hImage         = hBuf:BUFFER-FIELD('image':U)
         hSelectedImage = hBuf:BUFFER-FIELD('selected_image':U)
         hSort          = hBuf:BUFFER-FIELD('node_sort':U)
         hNodeInsert    = hBuf:BUFFER-FIELD('node_insert':U).
         
  CREATE QUERY hQry.  
  hQry:ADD-BUFFER(hBuf).
  hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.node_label = "&2" AND &1.parent_node_key = "&3":U':U, hTable:NAME,cDataSource,pcParentNodeKey)).
  hQry:QUERY-OPEN().
  hQry:GET-FIRST().

  IF NOT hBuf:AVAILABLE THEN DO:
      IF CAN-FIND(FIRST ttTranslate) THEN DO:
        FIND FIRST ttTranslate 
             WHERE ttTranslate.cOriginalLabel    = cDataSource
             AND   ttTranslate.cTranslatedLabel <> "":U
             NO-LOCK NO-ERROR.
        IF AVAILABLE ttTranslate THEN
          cDataSource = ttTranslate.cTranslatedLabel.
      END.
    hBuf:BUFFER-CREATE().
    ASSIGN hParentNodeKey:BUFFER-VALUE = pcParentNodeKey
           hNodeKey:BUFFER-VALUE       = DYNAMIC-FUNCTION('getNextNodeKey':U IN hTreeViewOCX)
           hNodeObj:BUFFER-VALUE       = pdChildNodeObj
           hNodeLabel:BUFFER-VALUE     = cDataSource
           hRecordRef:BUFFER-VALUE     = "":U
           hRecordRowId:BUFFER-VALUE   = ?
           hNodeChecked:BUFFER-VALUE   = lNodeChecked
           hImage:BUFFER-VALUE         = cImageFileName
           hSelectedImage:BUFFER-VALUE = cSelectedImageFileName
           hSort:BUFFER-VALUE          = TRUE
           hNodeInsert:BUFFER-VALUE    = IF pcParentNodeKey = "":U THEN 1 ELSE 4.
   /* Create a Dummy Child node record */
   IF lHasChildren THEN
     RUN createDummyChild IN TARGET-PROCEDURE
                          (INPUT hBuf,
                           INPUT hNodeKey:BUFFER-VALUE,
                           INPUT "DUMMY":U).
  END.
  IF VALID-HANDLE(hQry) THEN
    DELETE OBJECT hQry.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-manualInitializeObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE manualInitializeObjects Procedure 
PROCEDURE manualInitializeObjects :
/*------------------------------------------------------------------------------
  Purpose:     To instantiate objects on container in controlled order.
  Parameters:  <none>
  Notes:       Called from initializeObject of containr.p via Astra2
               customisation.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hHandle                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectHandles            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lMenuMaintenance          AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE hFolder                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFolderToolbar            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainerToolbar         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTitleFillIn              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hResizeFillIn             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRectangle                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lStatusBarVisible         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hFilterViewer             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWindow                   AS HANDLE     NO-UNDO.

  EMPTY TEMP-TABLE ttNonTreeObjects.
  RUN getNonTreeObjects IN TARGET-PROCEDURE (OUTPUT TABLE ttNonTreeObjects).

  cObjectHandles = DYNAMIC-FUNCTION("getObjectHandles":U IN TARGET-PROCEDURE).
  lMenuMaintenance = DYNAMIC-FUNCTION("getMenuMaintenance":U IN TARGET-PROCEDURE).
  hWindow = DYNAMIC-FUNCTION("getWindowHandle":U IN TARGET-PROCEDURE).

  RUN getTreeObjects IN TARGET-PROCEDURE (OUTPUT hFolder,
                                          OUTPUT hFolderToolbar,
                                          OUTPUT hContainerToolbar,
                                          OUTPUT hTitleFillIn,
                                          OUTPUT hResizeFillIn,
                                          OUTPUT hTreeViewOCX,
                                          OUTPUT hRectangle,
                                          OUTPUT lStatusBarVisible,
                                          OUTPUT hFilterViewer).

  IF NUM-ENTRIES(cObjectHandles) > 0 THEN
  DO iLoop = 1 TO NUM-ENTRIES(cObjectHandles):
    ASSIGN hHandle = WIDGET-HANDLE(ENTRY(iLoop, cObjectHandles)).
    /* We do not want the folder toolbar visualized when the node selected 
       is a menu object */
    IF lMenuMaintenance AND 
       hHandle = hFolderToolbar THEN
      NEXT.
    
    /* Do not re-initialize Folder Window */
    IF VALID-HANDLE(hFolder) AND
       hFolder = hHandle AND 
       INDEX(hHandle:FILE-NAME,"afspfoldr":U) <> 0 THEN
      NEXT.
    
    IF hHandle <> hContainerToolbar AND
       hHandle <> hTreeViewOCX      AND 
       hHandle <> hFolderToolbar    AND 
       hHandle <> hFilterViewer     AND
       hHandle <> hFolder           /*AND
       lMenuMaintenance = FALSE*/ THEN
      DYNAMIC-FUNCTION("setHideOnInit" IN hHandle,TRUE).
    
    RUN initializeObject IN hHandle.
    
    IF hHandle = hContainerToolbar OR
       hHandle = hTreeViewOCX      OR 
       hHandle = hFolderToolbar    OR 
       hHandle = hFilterViewer     OR
       hHandle = hFolder           THEN
      NEXT.
    ELSE DO:
      CREATE ttNonTreeObjects.
      ASSIGN ttNonTreeObjects.hObjectHandle = hHandle.
    END.
  END.
  
  DYNAMIC-FUNCTION("setDefaultMenuBar":U IN TARGET-PROCEDURE,hWindow:MENU-BAR).
  RUN setNonTreeObjects IN TARGET-PROCEDURE (INPUT TABLE ttNonTreeObjects).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-menuOverride) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE menuOverride Procedure 
PROCEDURE menuOverride :
/*------------------------------------------------------------------------------
  Purpose:     This procedure creates a new sub-menu to create menu-items usually
               found under the File menu option, but due to the Folder ToolBar
               added onto this container, the File menu item was duplicated 
               each time a new object was instansiated.
  Parameters:  IO Handle - The handle of the parent menu for menu items being
                           created for the Folder ToolBar.
  Notes:       This sub-menu is destroyed whenever a new logical object is 
               launched.
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER phParentMenu  AS HANDLE   NO-UNDO.
  /***** I don't think this code is used anymore,
         but I will leave it in for a while - 03/22/2002 
  DEFINE VARIABLE hNewSubMenu AS HANDLE   NO-UNDO.
  
  IF VALID-HANDLE(ghOverridenSubMenu) THEN DO:
    phParentMenu = ghOverridenSubMenu.
    RETURN.
  END.
    
  /* Supply a default menu-item */
  IF ghCurrentLabel = "":U THEN
    ghCurrentLabel = "Folder".
    
  CREATE SUB-MENU hNewSubMenu
  ASSIGN
      NAME = STRING(RANDOM(0,TIME))
      SENSITIVE = TRUE
      LABEL = ghCurrentLabel
      PARENT = phParentMenu 
      PRIVATE-DATA = "dynamictoolbar":U
      .
  ASSIGN phParentMenu       = hNewSubMenu
         ghOverridenSubMenu = phParentMenu.
  *****/
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
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdNodeObj     AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER piChildren    AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcParentNode  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cButton                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataset                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogicalObject          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRunAttribute           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeLabel              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPrimarySDO             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOSBOName             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBuf                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQry                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cCurrentNode            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNodeChecked            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cNodeLabelExpression    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabelSubsFields        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cImageFileName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSelectedImageFileName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hNodeObj                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeKey                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hImage                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSelectedImage          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeChecked            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSort                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFirstChildNodeKey      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX            AS HANDLE     NO-UNDO.

  DEFINE VARIABLE hFolder                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFolderToolbar            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainerToolbar         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTitleFillIn              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hResizeFillIn             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRectangle                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lStatusBarVisible         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hFilterViewer             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWindow                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cCurrentNodeKey           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dExistingChildNode        AS DECIMAL    NO-UNDO.
  
  RUN getTreeObjects IN TARGET-PROCEDURE (OUTPUT hFolder,
                                          OUTPUT hFolderToolbar,
                                          OUTPUT hContainerToolbar,
                                          OUTPUT hTitleFillIn,
                                          OUTPUT hResizeFillIn,
                                          OUTPUT hTreeViewOCX,
                                          OUTPUT hRectangle,
                                          OUTPUT lStatusBarVisible,
                                          OUTPUT hFilterViewer).
  
  {get TreeDataTable hTable hTreeViewOCX}.  
  /* Grab the handles to the individual fields in the tree data table. */
  ASSIGN hBuf = hTable:DEFAULT-BUFFER-HANDLE.
  
  ASSIGN hNodeObj       = hBuf:BUFFER-FIELD('node_obj':U)
         hNodeKey       = hBuf:BUFFER-FIELD('node_key':U)
         hImage         = hBuf:BUFFER-FIELD('image':U)
         hSelectedImage = hBuf:BUFFER-FIELD('selected_image':U)
         hNodeChecked   = hBuf:BUFFER-FIELD('node_checked':U)
         hSort          = hBuf:BUFFER-FIELD('node_sort':U).
  /* If the node has children other than the first dummy record, first expand
     the node, select the first object so that the objects is instansiated and
     then publish the ADD event - this is a shortcut for expanding the node, 
     selecting the first one and then pressing the ADD icon from a users point of view */
  cFirstChildNodeKey = DYNAMIC-FUNCTION("getProperty" IN hTreeViewOCX, "CHILD":U,pcParentNode).
  
  IF DYNAMIC-FUNCTION("getProperty" IN hTreeViewOCX, "TEXT":U,cFirstChildNodeKey) = "+":U THEN
    RUN tvNodeEvent IN TARGET-PROCEDURE ("EXPAND", pcParentNode).
  
  
  IF INTEGER(DYNAMIC-FUNCTION("getProperty" IN hTreeViewOCX, "CHILDREN":U,pcParentNode)) > 0  THEN DO:
    DYNAMIC-FUNCTION("setProperty" IN hTreeViewOCX, "EXPANDED":U,pcParentNode, "YES").
    ASSIGN cFirstChildNodeKey = DYNAMIC-FUNCTION("getProperty" IN hTreeViewOCX, "CHILD", pcParentNode).
    /* We might have normal text nodes when we expand, but we want to add a new node that is not text.
       Make sure that if there are such nodes that the node we want to add is not one of those */
    CREATE QUERY hQry.  
    hQry:ADD-BUFFER(hBuf).
    hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.node_key = "&2"':U, hTable:NAME,cFirstChildNodeKey)).
    hQry:QUERY-OPEN().
    hQry:GET-FIRST().
    IF hBuf:AVAILABLE THEN
      ASSIGN dExistingChildNode = hNodeObj:BUFFER-VALUE.

    IF dExistingChildNode = pdNodeObj THEN DO:
      DYNAMIC-FUNCTION("selectNode" IN hTreeViewOCX, cFirstChildNodeKey).
      RUN tvNodeSelected IN TARGET-PROCEDURE (cFirstChildNodeKey).
      PUBLISH 'addRecord' FROM hFolderToolbar.
      RETURN.
    END.

    /* In some cases there might be text nodes first in the list and the previous
       check will not cover those - we then have to check if we can find any other
       nodes for the parent that might be the same as the node we want to add - if 
       so we will select that node and just publish 'AddRecord' to initiate the 
       addition of a new record in the normal fasion */
    CREATE QUERY hQry.  
    hQry:ADD-BUFFER(hBuf).
    hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.parent_node_key = "&2"':U, hTable:NAME,pcParentNode)).
    hQry:QUERY-OPEN().
    hQry:GET-FIRST().
    
    DO WHILE hBuf:AVAILABLE:
      IF hNodeObj:BUFFER-VALUE = pdNodeObj THEN DO:
        DYNAMIC-FUNCTION("selectNode" IN hTreeViewOCX, hNodeKey:BUFFER-VALUE).
        RUN tvNodeSelected IN TARGET-PROCEDURE (hNodeKey:BUFFER-VALUE).
        PUBLISH 'addRecord' FROM hFolderToolbar.
        IF VALID-HANDLE(hQry) THEN
          DELETE OBJECT hQry.
        RETURN.
      END.
      hQry:GET-NEXT().
    END.

  END.
  
  EMPTY TEMP-TABLE ttNode.
  RUN getNodeTable IN TARGET-PROCEDURE (OUTPUT TABLE ttNode).
  /* Only if there are no child nodes (except the dummy) we will continue with 
    this process */
  FIND FIRST ttNode
       WHERE ttNode.node_obj = pdNodeObj
       NO-LOCK NO-ERROR.

  IF NOT AVAILABLE ttNode THEN 
    RETURN.
  ASSIGN cLogicalObject         = ttNode.logical_object
         cRunAttribute          = ttNode.run_attribute
         cNodeLabel             = ttNode.node_label
         cPrimarySDO            = ttNode.data_source
         lNodeChecked           = ttNode.node_checked
         cImageFileName         = ttNode.image_file_name
         cSelectedImageFileName = ttNode.selected_image_file_name
         NO-ERROR.
  DYNAMIC-FUNCTION("setNodeObj":U IN TARGET-PROCEDURE, pdNodeObj).
  
  cSDOSBOName = cPrimarySDO.
  
  /* Create A dummy Node that will become the new child node */
  cCurrentNodeKey = DYNAMIC-FUNCTION("getCurrentNodeKey":U IN TARGET-PROCEDURE).
  
  RUN createDummyChild IN TARGET-PROCEDURE
                       (INPUT hBuf,
                        INPUT cCurrentNodeKey,
                        INPUT "NEW":U).
  
  cCurrentNodeKey = DYNAMIC-FUNCTION("getCurrentNodeKey":U IN TARGET-PROCEDURE).
  
  CREATE QUERY hQry.  
  hQry:ADD-BUFFER(hBuf).
  hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.node_key = "&2"':U, hTable:NAME,cCurrentNodeKey)).
  hQry:QUERY-OPEN().
  hQry:GET-FIRST().
  IF hBuf:AVAILABLE THEN
    ASSIGN hNodeObj:BUFFER-VALUE       = pdNodeObj
           hNodeChecked:BUFFER-VALUE   = lNodeChecked
           hImage:BUFFER-VALUE         = cImageFileName
           hSelectedImage:BUFFER-VALUE = cSelectedImageFileName
           hSort:BUFFER-VALUE          = TRUE.
  
  IF VALID-HANDLE(hQry) THEN
    DELETE OBJECT hQry.
  IF INTEGER(DYNAMIC-FUNCTION("getProperty" IN hTreeViewOCX, "CHILDREN":U,pcParentNode)) > 0  THEN DO:
    RUN AddNode IN hTreeViewOCX (INPUT hBuf).
    DYNAMIC-FUNCTION("selectNode" IN hTreeViewOCX, cCurrentNodeKey).
    DYNAMIC-FUNCTION("setNewChildNode":U IN TARGET-PROCEDURE,TRUE).
    /*RUN tvNodeSelected IN TARGET-PROCEDURE (cCurrentNode).*/
  END.
  ELSE DO:
  cCurrentNode = DYNAMIC-FUNCTION("getSelectedNode" IN hTreeViewOCX).
    IF cCurrentNode <> ? THEN DO:
      DYNAMIC-FUNCTION("selectNode" IN hTreeViewOCX, cCurrentNode).
      DYNAMIC-FUNCTION("SetNodeExpanded":U IN TARGET-PROCEDURE,cCurrentNode,FALSE).
      DYNAMIC-FUNCTION("setExpand":U IN TARGET-PROCEDURE, TRUE).
      RUN tvNodeSelected IN TARGET-PROCEDURE (cCurrentNode).
      DYNAMIC-FUNCTION("setNewChildNode":U IN TARGET-PROCEDURE,TRUE).
      RUN tvNodeEvent    IN TARGET-PROCEDURE ("EXPANDNOW", cCurrentNode).
      ASSIGN cCurrentNode = DYNAMIC-FUNCTION("getProperty" IN hTreeViewOCX, "CHILD", cCurrentNode).
             cCurrentNode = DYNAMIC-FUNCTION("getProperty" IN hTreeViewOCX, "FIRSTSIBLING", cCurrentNode).
      IF cCurrentNode <> ? THEN DO:
        DYNAMIC-FUNCTION("selectNode" IN hTreeViewOCX, cCurrentNode).
        RUN tvNodeSelected IN TARGET-PROCEDURE (cCurrentNode).
      END.
    END.
  END.
  
  /* Launch the appropriate object in 'Add' mode */
  RUN createRepositoryObjects IN TARGET-PROCEDURE
            (INPUT cLogicalObject, 
             INPUT cSDOSBOName,
             INPUT TARGET-PROCEDURE,
             INPUT cRunAttribute).
  DYNAMIC-FUNCTION("setNewContainerMode":U IN TARGET-PROCEDURE,"Add":U).

  PUBLISH 'addRecord' FROM hFolderToolbar.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-nodeSelected) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nodeSelected Procedure 
PROCEDURE nodeSelected :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcNodeKey       AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE dNodeObj                AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cLogicalObject          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lMenuObject             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSDOSBOName             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPrimarySDO             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSource             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRunAttribute           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNodeExpanded           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hTable                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDetailList             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cImageFileName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSelectedImageFileName  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cPrivateData            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeDetail             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeLabel              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrentNodeKey         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentNode             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNewChildNode           AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE hFolder                 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFolderToolbar          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainerToolbar       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTitleFillIn            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hResizeFillIn           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRectangle              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lStatusBarVisible       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hFilterViewer           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWindow                 AS HANDLE     NO-UNDO.

  RUN getTreeObjects IN TARGET-PROCEDURE (OUTPUT hFolder,
                                          OUTPUT hFolderToolbar,
                                          OUTPUT hContainerToolbar,
                                          OUTPUT hTitleFillIn,
                                          OUTPUT hResizeFillIn,
                                          OUTPUT hTreeViewOCX,
                                          OUTPUT hRectangle,
                                          OUTPUT lStatusBarVisible,
                                          OUTPUT hFilterViewer).
  
  DYNAMIC-FUNCTION("setDelete":U IN TARGET-PROCEDURE, FALSE).

  {get TreeDataTable hTable hTreeViewOCX}.  
  
  IF NOT VALID-HANDLE(hTable) THEN
    RETURN.
  EMPTY TEMP-TABLE ttNode.
  RUN getNodeTable IN TARGET-PROCEDURE (OUTPUT TABLE ttNode).
  
  RUN setDataLinkActive IN TARGET-PROCEDURE.
  /* Force container to VIEW mode when a new node is selected */
  DYNAMIC-FUNCTION("setNewContainerMode":U IN TARGET-PROCEDURE,"View":U).

  ASSIGN cNodeDetail = DYNAMIC-FUNCTION("getNodeDetails":U IN TARGET-PROCEDURE,hTable, pcNodeKey).
  
  ASSIGN dNodeObj      = DECIMAL(ENTRY(1,cNodeDetail,CHR(2)))
         cPrivateData  = ENTRY(3,cNodeDetail,CHR(2)) 
         lNodeExpanded = ENTRY(4,cNodeDetail,CHR(2)) = "TRUE":U.
  
  /* Check if the node is a MENU structure - we need to read the submenus */
  IF INDEX(cPrivateData,"LogicalObject":U) > 0  THEN DO:
    lMenuObject = TRUE.
            
    ASSIGN cLogicalObject  = IF NUM-ENTRIES(cPrivateData,CHR(6)) >= 1 THEN ENTRY(2,ENTRY(1,cPrivateData,CHR(7)),CHR(6)) ELSE "":U
           cRunAttribute   = IF NUM-ENTRIES(cPrivateData,CHR(6)) >= 2 THEN ENTRY(2,ENTRY(2,cPrivateData,CHR(7)),CHR(6)) ELSE "":U
           cDataSource     = IF NUM-ENTRIES(cPrivateData,CHR(6)) >= 3 THEN ENTRY(2,ENTRY(3,cPrivateData,CHR(7)),CHR(6)) ELSE "":U
           NO-ERROR.
  END.
  ELSE
    lMenuObject = FALSE.

  FIND FIRST ttNode
       WHERE ttNode.node_obj = dNodeObj
       NO-LOCK NO-ERROR.

  IF NOT AVAILABLE ttNode THEN 
    RETURN.
  ELSE IF lMenuObject = FALSE THEN
    ASSIGN cLogicalObject   = ttNode.logical_object
           cRunAttribute    = ttNode.run_attribute
           cDataSource      = ttNode.data_source
           cNodeLabel       = ttNode.node_label
           cPrimarySDO      = ttNode.primary_sdo
           NO-ERROR.
  
  ASSIGN cImageFileName         = ttNode.image_file_name
         cSelectedImageFileName = ttNode.selected_image_file_name
         NO-ERROR.
  
  cSDOSBOName = cPrimarySDO.
  DYNAMIC-FUNCTION("setStatusBarText":U IN TARGET-PROCEDURE, pcNodeKey, cNodeLabel).

  ASSIGN cCurrentNodeKey = pcNodeKey
         cParentNode     = DYNAMIC-FUNCTION("getProperty":U IN hTreeViewOCX, INPUT "PARENT":U, INPUT pcNodeKey) 
         NO-ERROR.
  DYNAMIC-FUNCTION("setCurrentNodeKey":U IN TARGET-PROCEDURE,cCurrentNodeKey).
  DYNAMIC-FUNCTION("setParentNode":U IN TARGET-PROCEDURE,cParentNode).

  DYNAMIC-FUNCTION("setMenuMaintenance":U IN TARGET-PROCEDURE,FALSE).
  lNewChildNode = DYNAMIC-FUNCTION("getNewChildNode":U IN TARGET-PROCEDURE).
  IF cLogicalObject <> "":U AND 
     lNewChildNode = FALSE THEN DO:
    DYNAMIC-FUNCTION("setMenuMaintenance":U IN TARGET-PROCEDURE,lMenuObject).
    DYNAMIC-FUNCTION("setLastLaunchedNode":U IN TARGET-PROCEDURE,cCurrentNodeKey).
    RUN createRepositoryObjects IN TARGET-PROCEDURE
              (INPUT cLogicalObject, 
               INPUT cSDOSBOName,
               INPUT TARGET-PROCEDURE,
               INPUT cRunAttribute).
  END.
  ELSE IF cLogicalObject = "":U THEN DO:
    RUN destroyNonTreeObjects IN TARGET-PROCEDURE. /* Clear the application side */
  END.
  
  IF lMenuObject = TRUE AND 
     INTEGER(DYNAMIC-FUNCTION("getProperty" IN hTreeViewOCX, "CHILDREN":U,pcNodeKey)) = 0 THEN DO:
    {launch.i &PLIP  = 'ry/app/rytrenodep.p' 
                &IPROC = 'readMenuStructure' 
                &ONAPP = 'YES'
                &PLIST = "(INPUT '':U, INPUT DECIMAL(cDataSource), OUTPUT cDetailList)"
                &AUTOKILL = YES}

    RUN stripMNUDetails IN TARGET-PROCEDURE
                        (INPUT pcNodeKey,
                         INPUT cDetailList,
                         INPUT dNodeObj,
                         INPUT cImageFileName,
                         INPUT cSelectedImageFileName).
    RUN populateTree IN hTreeViewOCX (hTable, pcNodeKey).
    IF VALID-HANDLE(hFolderToolbar) THEN
      RUN hideObject IN hFolderToolbar.
  END.
  DYNAMIC-FUNCTION("setExpand":U IN TARGET-PROCEDURE,FALSE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-passSDOForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE passSDOForeignFields Procedure 
PROCEDURE passSDOForeignFields :
/*------------------------------------------------------------------------------
  Purpose:  pass SdoForeignFields to any SDO's with a data link from TARGET-PROCEDURE

  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcSDOName AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cDataTargets      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSdoForeignFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataTarget       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iEntry            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSDOHandle        AS HANDLE   NO-UNDO.
  
  EMPTY TEMP-TABLE ttRunningSDOs.
  RUN getRunningSDOs IN TARGET-PROCEDURE (OUTPUT TABLE ttRunningSDOs).
  
  FIND FIRST ttRunningSDOs NO-LOCK
       WHERE ttRunningSDOs.cSDOName = pcSDOName NO-ERROR.
  IF AVAILABLE ttRunningSDOs THEN DO:
    {get ForeignFields cSdoForeignFields ttRunningSDOs.hSDOHandle}.
  END.
  ELSE DO:
    {get SdoForeignFields cSdoForeignFields}.
  END.
    
  {get DataTarget cDataTargets}.
  
  IF cSdoForeignFields <> "":U THEN DO:   
    DO iEntry = 1 TO NUM-ENTRIES(cDataTargets):
      hDataTarget = WIDGET-HANDLE(ENTRY(iEntry,cDataTargets)).
          
      IF LOOKUP("setForeignFields":U, hDataTarget:INTERNAL-ENTRIES) <> 0 THEN DO: 
        DYNAMIC-FUNCTION('setForeignFields':U IN hDataTarget, cSdoForeignFields).                                             
      END.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareNodeTranslation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prepareNodeTranslation Procedure 
PROCEDURE prepareNodeTranslation :
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
  cObjectName = DYNAMIC-FUNCTION("getLogicalObjectName":U IN TARGET-PROCEDURE).
  
  EMPTY TEMP-TABLE ttNode.
  RUN getNodeTable IN TARGET-PROCEDURE (OUTPUT TABLE ttNode).

  FOR EACH  ttNode
      WHERE ttNode.data_source_type = "TXT":U
      NO-LOCK:
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
  
  RUN multiTranslation IN gshTranslationManager (INPUT NO,
                                                 INPUT-OUTPUT TABLE ttTranslate).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshPRGNodes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshPRGNodes Procedure 
PROCEDURE refreshPRGNodes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcPrimarySDO AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phBuf        AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER phTable      AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pdNodeObj    AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcParentNode AS CHARACTER  NO-UNDO.
  
  /** First we will delete the current structure **/
  DEFINE VARIABLE hDelTree      AS HANDLE NO-UNDO.
  DEFINE VARIABLE hDelNodeKey   AS HANDLE NO-UNDO.
  DEFINE VARIABLE hTBuf         AS HANDLE NO-UNDO.
  DEFINE VARIABLE hBuf          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRowId        AS ROWID  NO-UNDO.
  DEFINE VARIABLE hSDOHandle    AS HANDLE NO-UNDO.
  DEFINE VARIABLE hQry          AS HANDLE NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX  AS HANDLE NO-UNDO.
  DEFINE VARIABLE cCurrentNode  AS CHARACTER  NO-UNDO.

  hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN TARGET-PROCEDURE).

  FIND FIRST ttRunningSDOs
       WHERE ttRunningSDOs.cSDOName = pcPrimarySDO
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ttRunningSDOs THEN
    RETURN.
  ELSE
    ASSIGN hSDOHandle = ttRunningSDOs.hSDOHandle.
  IF NOT VALID-HANDLE(hSDOHandle) THEN
    RETURN.
  
  CREATE TEMP-TABLE hDelTree.
  hDelTree:ADD-NEW-FIELD("NodeKey","Character").
  hDelTree:TEMP-TABLE-PREPARE("ttDelTree").
  
  /* Save the current selected record's ROWID in the SDO */
  rRowId = TO-ROWID(ENTRY(1,DYNAMIC-FUNCTION("getRowIdent":U IN hSDOHandle))).

  ASSIGN hTBuf = hDelTree:DEFAULT-BUFFER-HANDLE.
  CREATE QUERY hQry.  
  hQry:ADD-BUFFER(phBuf).
  hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.node_obj = &2':U, phTable:NAME,QUOTER(pdNodeObj))).
  hQry:QUERY-OPEN().
  hQry:GET-FIRST().
  
  ASSIGN hDelNodeKey = hTBuf:BUFFER-FIELD("NodeKey").
  DO WHILE phBuf:AVAILABLE:
    hTBuf:BUFFER-CREATE().
    ASSIGN hDelNodeKey:BUFFER-VALUE = phBuf:BUFFER-FIELD("node_key"):BUFFER-VALUE.
    RUN deleteNode IN hTreeViewOCX (INPUT phBuf:BUFFER-FIELD("node_key"):BUFFER-VALUE).
    hQry:GET-NEXT().
  END.

  IF VALID-HANDLE(hQry) THEN
    DELETE OBJECT hQry.
  RUN loadPRGData IN TARGET-PROCEDURE (INPUT pcParentNode, pdNodeObj).
  RUN populateTree IN hTreeViewOCX (phTable, pcParentNode).
  
  ASSIGN hBuf = phTable:DEFAULT-BUFFER-HANDLE.

  IF rRowId <> ? THEN DO:
    hBuf:FIND-FIRST("WHERE " + phTable:NAME + ".record_rowid = TO-ROWID('" + STRING(rRowID) + "')":U).
    IF hBuf:AVAILABLE THEN
      cCurrentNode = hBuf:BUFFER-FIELD("node_key"):BUFFER-VALUE.
    ELSE
      cCurrentNode = "":U.
  END.
  ELSE DO:
    hBuf:FIND-FIRST(SUBSTITUTE('WHERE &1.node_obj = &2':U, phTable:NAME,QUOTER(pdNodeObj))).
    IF hBuf:AVAILABLE THEN
      cCurrentNode = hBuf:BUFFER-FIELD("node_key"):BUFFER-VALUE.
  END.

  DYNAMIC-FUNCTION("selectNode" IN hTreeViewOCX, cCurrentNode).
  RUN tvNodeSelected IN TARGET-PROCEDURE (cCurrentNode).
  
  IF VALID-HANDLE(hTreeViewOCX) THEN
    RUN enableObject IN hTreeViewOCX.
  IF VALID-HANDLE(hDelTree) THEN
    DELETE OBJECT hDelTree.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionParentSDO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionParentSDO Procedure 
PROCEDURE repositionParentSDO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcParentNodeSDO AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcParentNodeKey AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cParentNodeKey AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeDetail    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE rRecordRowid   AS ROWID      NO-UNDO.
  DEFINE VARIABLE dNodeObj       AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hTable         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAlwaysRepos   AS LOGICAL    NO-UNDO.

  IF NUM-ENTRIES(pcParentNodeSDO,CHR(1)) > 1 THEN
    ASSIGN lAlwaysRepos = ENTRY(2,pcParentNodeSDO,CHR(1)) = "REPOS":U.
  ASSIGN pcParentNodeSDO = ENTRY(1,pcParentNodeSDO,CHR(1)).

  DEFINE BUFFER bttRunningSDOs FOR ttRunningSDOs.
  DEFINE BUFFER bttNode FOR ttNode.
  
  IF NOT CAN-FIND(FIRST bttRunningSDOs) THEN DO:
    EMPTY TEMP-TABLE bttRunningSDOs.
    RUN getRunningSDOs IN TARGET-PROCEDURE (OUTPUT TABLE bttRunningSDOs).
  END.
  IF NOT CAN-FIND(FIRST bttNode) THEN DO:
    EMPTY TEMP-TABLE bttNode.
    RUN getNodeTable IN TARGET-PROCEDURE (OUTPUT TABLE bttNode).
  END.

  hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN TARGET-PROCEDURE).

  /* Now we need to loop through the parent nodes to find the 
     parent node that is an SDO - then we need to reposition that
     SDO to the current selected record to get the correct foreign
     fields */
  FIND FIRST bttRunningSDOs
       WHERE bttRunningSDOs.cSDOName = pcParentNodeSDO
       NO-LOCK NO-ERROR.
  IF AVAILABLE bttRunningSDOs THEN DO:
    cParentNodeKey = "":U.
    {get TreeDataTable hTable hTreeViewOCX}.
    cParentNodeKey = pcParentNodeKey.
    SEARCH_FOR_PARENT:
    DO WHILE TRUE:
      IF cParentNodeKey = ? OR
         cParentNodeKey = "":U THEN
        LEAVE SEARCH_FOR_PARENT.
      ELSE DO:
        IF VALID-HANDLE(hTable) THEN DO:
          ASSIGN cNodeDetail = DYNAMIC-FUNCTION("getNodeDetails":U IN TARGET-PROCEDURE, hTable, cParentNodeKey).

          ASSIGN dNodeObj     = DECIMAL(ENTRY(1,cNodeDetail,CHR(2)))
                 rRecordRowid = TO-ROWID(ENTRY(2,cNodeDetail,CHR(2))).
          FIND FIRST bttNode
               WHERE bttNode.node_obj = dNodeObj
               NO-LOCK NO-ERROR.
          IF bttNode.data_source_type = "SDO":U AND 
             (bttNode.run_attribute <> "STRUCTURED":U OR lAlwaysRepos) THEN
            LEAVE SEARCH_FOR_PARENT.
        END.
      END.
      cParentNodeKey = DYNAMIC-FUNCTION("getProperty":U IN hTreeViewOCX, "PARENT":U, cParentNodeKey).
    END. /* WHILE TRUE */
    IF cParentNodeKey <> ? AND
       cParentNodeKey <> "":U THEN DO:
      RUN setDataLinkInActive IN TARGET-PROCEDURE.
      RUN repositionSDO IN TARGET-PROCEDURE
                        (INPUT "":U,
                         INPUT bttRunningSDOs.hSDOHandle,
                         INPUT ?,
                         INPUT rRecordRowid,
                         INPUT cParentNodeKey + CHR(1) + bttRunningSDOs.cServerMode).
      RUN setDataLinkActive IN TARGET-PROCEDURE.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionSDO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionSDO Procedure 
PROCEDURE repositionSDO :
/*------------------------------------------------------------------------------
  Purpose:     Repositions an SDO to a selected Record Rowid
  Parameters:  I - pcForeignFields - Foreign Field pairs
               I - phSDOHandle     - The handle to the SDO to be repositioned
               I - prRecordRowid   - The RowID of the record to reposition to
               I - phParentSDO     - The handle to the parent node's SDO
               I - pcNodeKey       - The key to the selected node
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcForeignFields AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phSDOHandle     AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER phParentSDO     AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER prRecordRowid   AS ROWID      NO-UNDO.
  DEFINE INPUT  PARAMETER pcNodeKey       AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cServerMode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cGetSMode    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeDetail  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRecordRef   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValueList   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjField    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTable       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cParentNode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryString AS CHARACTER  NO-UNDO.
  
  IF NUM-ENTRIES(pcNodeKey,CHR(1)) > 1 THEN
    cServerMode = ENTRY(2,pcNodeKey,CHR(1)).

  pcNodeKey = ENTRY(1,pcNodeKey,CHR(1)).

  hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN TARGET-PROCEDURE).
  {get TreeDataTable hTable hTreeViewOCX}.

  IF NOT VALID-HANDLE(hTable) THEN
    RETURN.
  
  cValueList = DYNAMIC-FUNCTION("getEntityName":U IN TARGET-PROCEDURE,phSDOHandle).

  IF LENGTH(TRIM(cValueList)) > 0 THEN 
    cObjField = DYNAMIC-FUNCTION("getObjKeyField":U IN TARGET-PROCEDURE,cValueList).


  ASSIGN cNodeDetail = DYNAMIC-FUNCTION("getNodeDetails":U IN TARGET-PROCEDURE, hTable, pcNodeKey).
  ASSIGN cRecordRef  = IF NUM-ENTRIES(cNodeDetail,CHR(2)) >= 5 THEN ENTRY(5,cNodeDetail,CHR(2)) ELSE "":U.
  IF prRecordRowid <> ? THEN DO:
    /* Clear any previous queries */
    {set QueryWhere   ?            phSDOHandle}.
    {set QueryString  ''           phSDOHandle}.   
    {get OpenQuery    cQueryString phSDOHandle}.
    {set QueryWhere   cQueryString phSDOHandle}.
    {set QueryString  cQueryString phSDOHandle}.
    {set QueryColumns ''           phSDOHandle}.

    /* Re-initialze the SDO to get the query back to a normal state */
    DYNAMIC-FUNCTION('assignQuerySelection':U IN phSDOHandle, cObjField , cRecordRef, '':U).
    
    /* This fixes issue #5814 - MAD - 10/04/2002 */
    cGetSMode = DYNAMIC-FUNCTION('getServerOperatingMode':U IN phSDOHandle).
    IF (cGetSMode = ? OR cGetSMode = "?":U) AND
       cServerMode <> "":U THEN
      DYNAMIC-FUNCTION('setServerOperatingMode':U IN phSDOHandle,cServerMode).
    /*********************************************/
    DYNAMIC-FUNCTION('openQuery':U IN phSDOHandle). 
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-reposPRGParentNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reposPRGParentNode Procedure 
PROCEDURE reposPRGParentNode :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will attempt to reposition a parent data node of
               a selected or expanded text node
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcNodeKey AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE hNodeKey              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNodeKey              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dNodeObj              AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cDataset              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogicalObject        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSourceType       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSource           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPrimarySDO           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOSBOName           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabelSubsFields      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE rRecordRowid          AS ROWID      NO-UNDO.
  DEFINE VARIABLE cPrivateData          AS CHARACTER  NO-UNDO.
                                        
  DEFINE VARIABLE lMenuObject           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hTable                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSDOHandle            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNodeDetail           AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE hTreeViewOCX          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cGlobalCurrentNodeKey AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLastLaunchedNode     AS CHARACTER  NO-UNDO.
  
  IF pcNodeKey = ? THEN
    RETURN.
  
  EMPTY TEMP-TABLE ttRunningSDOs.
  RUN getRunningSDOs IN TARGET-PROCEDURE (OUTPUT TABLE ttRunningSDOs).
  EMPTY TEMP-TABLE ttNode.
  RUN getNodeTable IN TARGET-PROCEDURE (OUTPUT TABLE ttNode).
  
  hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN TARGET-PROCEDURE).
  cGlobalCurrentNodeKey = DYNAMIC-FUNCTION("getCurrentNodeKey":U IN TARGET-PROCEDURE).
  cLastLaunchedNode = DYNAMIC-FUNCTION("getLastLaunchedNode":U IN TARGET-PROCEDURE).
  DYNAMIC-FUNCTION("setDelete":U IN TARGET-PROCEDURE,FALSE).

  {get TreeDataTable hTable hTreeViewOCX}.  
  
  IF NOT VALID-HANDLE(hTable) THEN
    RETURN.
  
  DYNAMIC-FUNCTION("setCurrentNodeKey":U IN TARGET-PROCEDURE,pcNodeKey).
  
  ASSIGN cNodeKey = pcNodeKey.
/*
  /* If the user re-selected the same node - we don't want to do anything again */
  IF cNodeKey = cGlobalCurrentNodeKey THEN
    RETURN.
  */
  SESSION:SET-WAIT-STATE("GENERAL":U).
  
  ASSIGN cNodeDetail = DYNAMIC-FUNCTION("getNodeDetails":U IN TARGET-PROCEDURE,hTable, pcNodeKey).
  
  ASSIGN dNodeObj      = DECIMAL(ENTRY(1,cNodeDetail,CHR(2)))
         rRecordRowid  = TO-ROWID(ENTRY(2,cNodeDetail,CHR(2))).
         cPrivateData  = ENTRY(3,cNodeDetail,CHR(2)).
  
  /* Check if the node is a MENU structure - we need to get out of here */
  IF INDEX(cPrivateData,"LogicalObject":U) > 0 THEN DO:
    SESSION:SET-WAIT-STATE("":U).
    RETURN.
  END.

  FIND FIRST ttNode
       WHERE ttNode.node_obj = dNodeObj
       NO-LOCK NO-ERROR.

  IF NOT AVAILABLE ttNode THEN DO:
    SESSION:SET-WAIT-STATE("":U).
    RETURN.
  END.
  
  ASSIGN cLogicalObject   = ttNode.logical_object
         cForeignFields   = ttNode.foreign_fields
         cLabelSubsFields = ttNode.label_text_substitution_fields
         cDataSourceType  = ttNode.data_source_type
         cDataSource      = ttNode.data_source
         cPrimarySDO      = ttNode.primary_sdo
         NO-ERROR.
  
  RUN setDataLinkInActive IN TARGET-PROCEDURE.
  IF cDataSourceType = "SDO":U OR
    (cDataSourceType = "TXT":U AND
     cPrimarySDO <> "":U) THEN DO:
    cSDOSBOName = cPrimarySDO.
    FIND FIRST ttRunningSDOs
         WHERE ttRunningSDOs.cSDOName = cSDOSBOName
         NO-LOCK NO-ERROR.
    IF AVAILABLE ttRunningSDOs AND
       VALID-HANDLE(ttRunningSDOs.hSDOHandle) THEN DO:
      RUN repositionSDO IN TARGET-PROCEDURE
                        (INPUT cForeignFields,
                         INPUT ttRunningSDOs.hSDOHandle,
                         INPUT ttRunningSDOs.hParentSDO,
                         INPUT rRecordRowid,
                         INPUT cNodeKey + CHR(1) + ttRunningSDOs.cServerMode).
      DYNAMIC-FUNCTION("setReposParentNode":U IN TARGET-PROCEDURE, FALSE).
    END.
  END.

  /* When an extract program was used to create a node we 
     need to launch the SDO/SBO that is required by the 
     logical object being launched. */
  IF cDataSourceType = "PRG":U AND 
     cLogicalObject <> "":U THEN DO:
    cSDOSBOName = cPrimarySDO.
    RUN manageSDOs IN TARGET-PROCEDURE
                   (INPUT  cSDOSBOName,
                    INPUT  cForeignFields,
                    INPUT  "":U,
                    INPUT cLabelSubsFields,
                    INPUT (ttNode.run_attribute = "STRUCTURED":U),
                    INPUT ttNode.fields_to_store,
                    OUTPUT hSDOHandle).
    IF NOT VALID-HANDLE(hSDOHandle) THEN DO:
      SESSION:SET-WAIT-STATE("":U).
      RETURN.
    END.
    FIND FIRST ttRunningSDOs
         WHERE ttRunningSDOs.cSDOName = cSDOSBOName
         NO-LOCK NO-ERROR.
    IF AVAILABLE ttRunningSDOs AND
       VALID-HANDLE(ttRunningSDOs.hSDOHandle) THEN DO:
      RUN repositionSDO IN TARGET-PROCEDURE
                        (INPUT cForeignFields,
                         INPUT ttRunningSDOs.hSDOHandle,
                         INPUT ttRunningSDOs.hParentSDO,
                         INPUT rRecordRowid,
                         INPUT cNodeKey + CHR(1) + ttRunningSDOs.cServerMode).
      DYNAMIC-FUNCTION("setReposParentNode":U IN TARGET-PROCEDURE, FALSE).
    END.
  END.
  RUN setDataLinkActive IN TARGET-PROCEDURE.
  
  SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-reposTXTParentNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reposTXTParentNode Procedure 
PROCEDURE reposTXTParentNode :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will attempt to reposition a parent data node of
               a selected or expanded text node
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcNodeKey AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE hNodeKey              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNodeKey              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dNodeObj              AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cDataset              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogicalObject        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSourceType       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSource           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPrimarySDO           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOSBOName           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabelSubsFields      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE rRecordRowid          AS ROWID      NO-UNDO.
  DEFINE VARIABLE cPrivateData          AS CHARACTER  NO-UNDO.
                                        
  DEFINE VARIABLE lMenuObject           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hTable                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSDOHandle            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNodeDetail           AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE hTreeViewOCX          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cGlobalCurrentNodeKey AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLastLaunchedNode     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentNode           AS CHARACTER  NO-UNDO.
  
  IF pcNodeKey = ? THEN
    RETURN.
  
  EMPTY TEMP-TABLE ttRunningSDOs.
  RUN getRunningSDOs IN TARGET-PROCEDURE (OUTPUT TABLE ttRunningSDOs).
  EMPTY TEMP-TABLE ttNode.
  RUN getNodeTable IN TARGET-PROCEDURE (OUTPUT TABLE ttNode).
  
  hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN TARGET-PROCEDURE).
  cGlobalCurrentNodeKey = DYNAMIC-FUNCTION("getCurrentNodeKey":U IN TARGET-PROCEDURE).
  cLastLaunchedNode = DYNAMIC-FUNCTION("getLastLaunchedNode":U IN TARGET-PROCEDURE).
  cParentNode = DYNAMIC-FUNCTION("getProperty":U IN hTreeViewOCX, "PARENT":U, pcNodeKey).
  DYNAMIC-FUNCTION("setDelete":U IN TARGET-PROCEDURE,FALSE).

  IF cParentNode = ? OR
     cParentNode = "":U THEN
    RETURN.
  
  {get TreeDataTable hTable hTreeViewOCX}.  
  
  IF NOT VALID-HANDLE(hTable) THEN
    RETURN.
  
  DYNAMIC-FUNCTION("setCurrentNodeKey":U IN TARGET-PROCEDURE,cParentNode).
  
  ASSIGN cNodeKey = cParentNode.
/*
  /* If the user re-selected the same node - we don't want to do anything again */
  IF cNodeKey = cGlobalCurrentNodeKey THEN
    RETURN.
  */
  SESSION:SET-WAIT-STATE("GENERAL":U).
  
  ASSIGN cNodeDetail = DYNAMIC-FUNCTION("getNodeDetails":U IN TARGET-PROCEDURE,hTable, cParentNode).
  
  ASSIGN dNodeObj      = DECIMAL(ENTRY(1,cNodeDetail,CHR(2)))
         rRecordRowid  = TO-ROWID(ENTRY(2,cNodeDetail,CHR(2))).
         cPrivateData  = ENTRY(3,cNodeDetail,CHR(2)).
  
  /* Check if the node is a MENU structure - we need to get out of here */
  IF INDEX(cPrivateData,"LogicalObject":U) > 0 THEN DO:
    SESSION:SET-WAIT-STATE("":U).
    RETURN.
  END.

  FIND FIRST ttNode
       WHERE ttNode.node_obj = dNodeObj
       NO-LOCK NO-ERROR.

  IF NOT AVAILABLE ttNode THEN DO:
    SESSION:SET-WAIT-STATE("":U).
    RETURN.
  END.
  
  ASSIGN cLogicalObject   = ttNode.logical_object
         cForeignFields   = ttNode.foreign_fields
         cLabelSubsFields = ttNode.label_text_substitution_fields
         cDataSourceType  = ttNode.data_source_type
         cDataSource      = ttNode.data_source
         cPrimarySDO      = ttNode.primary_sdo
         NO-ERROR.
  
  RUN setDataLinkInActive IN TARGET-PROCEDURE.
  IF cDataSourceType = "SDO":U OR
    (cDataSourceType = "TXT":U AND
     cPrimarySDO <> "":U) THEN DO:
    cSDOSBOName = cPrimarySDO.
    FIND FIRST ttRunningSDOs
         WHERE ttRunningSDOs.cSDOName = cSDOSBOName
         NO-LOCK NO-ERROR.
    IF AVAILABLE ttRunningSDOs AND
       VALID-HANDLE(ttRunningSDOs.hSDOHandle) THEN DO:
      RUN repositionSDO IN TARGET-PROCEDURE
                        (INPUT cForeignFields,
                         INPUT ttRunningSDOs.hSDOHandle,
                         INPUT ttRunningSDOs.hParentSDO,
                         INPUT rRecordRowid,
                         INPUT cNodeKey + CHR(1) + ttRunningSDOs.cServerMode).
      DYNAMIC-FUNCTION("setReposParentNode":U IN TARGET-PROCEDURE, FALSE).
    END.
  END.

  /* When an extract program was used to create a node we 
     need to launch the SDO/SBO that is required by the 
     logical object being launched. */
  IF cDataSourceType = "PRG":U AND 
     cLogicalObject <> "":U THEN DO:
    cSDOSBOName = cPrimarySDO.
    RUN manageSDOs IN TARGET-PROCEDURE
                   (INPUT  cSDOSBOName,
                    INPUT  cForeignFields,
                    INPUT  "":U,
                    INPUT cLabelSubsFields,
                    INPUT (ttNode.run_attribute = "STRUCTURED":U),
                    INPUT ttNode.fields_to_store,
                    OUTPUT hSDOHandle).
    IF NOT VALID-HANDLE(hSDOHandle) THEN DO:
      SESSION:SET-WAIT-STATE("":U).
      RETURN.
    END.
    FIND FIRST ttRunningSDOs
         WHERE ttRunningSDOs.cSDOName = cSDOSBOName
         NO-LOCK NO-ERROR.
    IF AVAILABLE ttRunningSDOs AND
       VALID-HANDLE(ttRunningSDOs.hSDOHandle) THEN DO:
      RUN repositionSDO IN TARGET-PROCEDURE
                        (INPUT cForeignFields,
                         INPUT ttRunningSDOs.hSDOHandle,
                         INPUT ttRunningSDOs.hParentSDO,
                         INPUT rRecordRowid,
                         INPUT cNodeKey + CHR(1) + ttRunningSDOs.cServerMode).
      DYNAMIC-FUNCTION("setReposParentNode":U IN TARGET-PROCEDURE, FALSE).
    END.
  END.
  RUN setDataLinkActive IN TARGET-PROCEDURE.
  
  SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetRecord Procedure 
PROCEDURE resetRecord :
/*------------------------------------------------------------------------------
  Purpose:     Captures the event when a record being Modify was reset.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTreeViewOCX AS HANDLE     NO-UNDO.

  hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN TARGET-PROCEDURE).
  DYNAMIC-FUNCTION("setCurrentMode":U IN TARGET-PROCEDURE, "Cancel":U).
  DYNAMIC-FUNCTION("setNewContainerMode":U IN TARGET-PROCEDURE, "View":U).
  
  
  RUN setContainerViewMode IN TARGET-PROCEDURE.
  IF VALID-HANDLE(hTreeViewOCX) THEN
    RUN enableObject IN hTreeViewOCX.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainerModifyMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setContainerModifyMode Procedure 
PROCEDURE setContainerModifyMode :
/*------------------------------------------------------------------------------
  Purpose:     Force whole container intio modify mode - including header/detail
               windows where they have many toolbars.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hHandle                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cToolbarHandles           AS CHARACTER  NO-UNDO.
  cToolbarHandles = DYNAMIC-FUNCTION("getToolbarHandles":U IN TARGET-PROCEDURE).

  IF NUM-ENTRIES(cToolbarHandles) > 0 THEN
  DO iLoop = 1 TO NUM-ENTRIES(cToolbarHandles):
    ASSIGN hHandle = WIDGET-HANDLE(ENTRY(iLoop, cToolbarHandles)).
    PUBLISH "updateMode" FROM hHandle ("enable").
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainerViewMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setContainerViewMode Procedure 
PROCEDURE setContainerViewMode :
/*------------------------------------------------------------------------------
  Purpose:     Force whole container intio view mode - including header/detail
               windows where they have many toolbars.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hHandle                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cToolbarHandles           AS CHARACTER  NO-UNDO.
  
  cToolbarHandles = DYNAMIC-FUNCTION("getToolbarHandles":U IN TARGET-PROCEDURE).
  IF NUM-ENTRIES(cToolbarHandles) > 0 THEN
  DO iLoop = 1 TO NUM-ENTRIES(cToolbarHandles):
    ASSIGN hHandle = WIDGET-HANDLE(ENTRY(iLoop, cToolbarHandles)).
    PUBLISH "updateMode" FROM hHandle ("view").
  END.

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
  DEFINE VARIABLE hParentNodeKey        AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hNodeKey              AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hNodeObj              AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hNodeLabel            AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hPrivateData          AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hImage                AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hSelectedImage        AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hNodeInsert           AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hSort                 AS HANDLE       NO-UNDO.
  DEFINE VARIABLE iLoop                 AS INTEGER      NO-UNDO.
  DEFINE VARIABLE cNodeLabel            AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cPrivateData          AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX          AS HANDLE     NO-UNDO.

  hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN TARGET-PROCEDURE).

  {get TreeDataTable hTable hTreeViewOCX}.  

  /* Grab the handles to the individual fields in the tree data table. */
  ASSIGN hBuf           = hTable:DEFAULT-BUFFER-HANDLE
         hParentNodeKey = hBuf:BUFFER-FIELD('parent_node_key':U)
         hNodeObj       = hBuf:BUFFER-FIELD('node_obj':U)
         hNodeKey       = hBuf:BUFFER-FIELD('node_key':U)
         hNodeLabel     = hBuf:BUFFER-FIELD('node_label':U)
         hPrivateData   = hBuf:BUFFER-FIELD('private_data':U)
         hImage         = hBuf:BUFFER-FIELD('image':U)
         hSelectedImage = hBuf:BUFFER-FIELD('selected_image':U)
         hSort          = hBuf:BUFFER-FIELD('node_sort':U)
         hNodeInsert    = hBuf:BUFFER-FIELD('node_insert':U).
      
  DO iLoop = 1 TO NUM-ENTRIES(pcDetailList,CHR(3)):
    ASSIGN cNodeLabel   = ENTRY(1,ENTRY(iLoop,pcDetailList,CHR(3)),CHR(4))
           cPrivateData = ENTRY(2,ENTRY(iLoop,pcDetailList,CHR(3)),CHR(4))
           NO-ERROR.
    IF cNodeLabel = "":U THEN
      NEXT.
    hBuf:BUFFER-CREATE().
    ASSIGN hParentNodeKey:BUFFER-VALUE = pcParentNodeKey
           hNodeObj:BUFFER-VALUE       = pdNodeObj
           hNodeKey:BUFFER-VALUE       = DYNAMIC-FUNCTION('getNextNodeKey':U IN hTreeViewOCX)
           hNodeLabel:BUFFER-VALUE     = cNodeLabel
           hPrivateData:BUFFER-VALUE   = cPrivateData
           hImage:BUFFER-VALUE         = pcImage
           hSelectedImage:BUFFER-VALUE = pcSelectedImage
           hSort:BUFFER-VALUE          = TRUE
           hNodeInsert:BUFFER-VALUE    = IF pcParentNodeKey = "":U THEN 1 ELSE 4.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-toolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toolbar Procedure 
PROCEDURE toolbar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcAction  AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cCurrentNode    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrentMode    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cState          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrentNodeKey AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cParentNode     AS CHARACTER  NO-UNDO.

  hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN TARGET-PROCEDURE).
  cCurrentMode = DYNAMIC-FUNCTION("getCurrentMode":U IN TARGET-PROCEDURE).
  cState = DYNAMIC-FUNCTION("getState":U IN TARGET-PROCEDURE).
  cCurrentNodeKey = DYNAMIC-FUNCTION("getCurrentNodeKey":U IN TARGET-PROCEDURE).
  cParentNode = DYNAMIC-FUNCTION("getParentNode":U IN TARGET-PROCEDURE).

  CASE pcAction:
    WHEN "disableData":U THEN DO: 
      /* If an error occurred of validation vailed - don't continue */
      IF RETURN-VALUE = "ADM-ERROR":U THEN
        RETURN.
      IF cState = "updateComplete":U AND 
         (cCurrentMode = 'add':U   OR 
          cCurrentMode = 'copy':U) THEN DO:
        ASSIGN cCurrentNode     = cCurrentNodeKey
               cCurrentNodeKey = ?.
        DYNAMIC-FUNCTION("selectNode" IN hTreeViewOCX, cCurrentNode).
        RUN tvNodeSelected IN TARGET-PROCEDURE (cCurrentNode).
        cState = "":U.
      END.
      IF cCurrentMode = "delete":U  AND 
         VALID-HANDLE(hTreeViewOCX) THEN DO:
        /* This solves the problem when deleting a child node that is
           the last node of a parent. It used to jump to the parent node */
        DYNAMIC-FUNCTION("setCurrentNodeKey":U IN TARGET-PROCEDURE,?).
        cCurrentNode = DYNAMIC-FUNCTION("getSelectedNode" IN hTreeViewOCX).
        IF cCurrentNode = cParentNode THEN DO:
          ASSIGN cCurrentNode = DYNAMIC-FUNCTION("getProperty" IN hTreeViewOCX, "CHILD":U, cParentNode).
                 cCurrentNode = DYNAMIC-FUNCTION("getProperty" IN hTreeViewOCX, "LASTSIBLING", cCurrentNode).
          DYNAMIC-FUNCTION("setCurrentNodeKey":U IN TARGET-PROCEDURE,?).
          IF cCurrentNode <> ? THEN DO:
            DYNAMIC-FUNCTION("selectNode" IN hTreeViewOCX, cCurrentNode).
            RUN tvNodeSelected IN TARGET-PROCEDURE (cCurrentNode).
          END.
          ELSE DO: /* The last child node was deleted - select parent and apply selection to refresh screen */
            IF cParentNode <> ? THEN DO:
              DYNAMIC-FUNCTION("selectNode" IN hTreeViewOCX, cParentNode).
              RUN tvNodeSelected IN TARGET-PROCEDURE (cParentNode).
            END. /* VALID-HANDLE(cParentNode) */
          END. /* ELSE */
        END. /* cCurrentNode = cParentNode */
        ELSE DO:
          DYNAMIC-FUNCTION("selectNode" IN hTreeViewOCX, cCurrentNode).
          RUN tvNodeSelected IN TARGET-PROCEDURE (cCurrentNode).
        END.
        DYNAMIC-FUNCTION("setCurrentMode":U IN TARGET-PROCEDURE,"":U).
        DYNAMIC-FUNCTION("setState":U IN TARGET-PROCEDURE,"":U).
      END. /* cCurrentMode = "delete":U */
      
      IF cCurrentMode = "Cancel":U THEN DO:
        DYNAMIC-FUNCTION("setCurrentMode":U IN TARGET-PROCEDURE,"":U).
        DYNAMIC-FUNCTION("setState":U IN TARGET-PROCEDURE,"":U).
        DYNAMIC-FUNCTION("setNewChildNode":U IN TARGET-PROCEDURE,FALSE).
      END.
    END. /* "disableData":U */
    OTHERWISE
      RUN SUPER (pcAction).
  END CASE.
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tvNodeEvent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tvNodeEvent Procedure 
PROCEDURE tvNodeEvent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcEvent       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcNodeKey     AS CHARACTER  NO-UNDO.
                                        
  DEFINE VARIABLE hTable                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNodeDetail           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hNodeExpanded         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuf                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQry                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dNodeObj              AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE rRecordRowid          AS ROWID      NO-UNDO.
  DEFINE VARIABLE cCurrentNodeKey       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFirstChild           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cGlobalCurrentNodeKey AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lReposSDO             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cNodes                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop                 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lNewChildNode         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lStructuredNode       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cNodeType             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lReposTXTParent       AS LOGICAL    NO-UNDO.

  DEFINE BUFFER bttNode FOR ttNode.
  IF pcNodeKey = ? AND pcEvent <> "RIGHTCLICK" THEN
    RETURN.
  
  EMPTY TEMP-TABLE ttNode.
  RUN getNodeTable IN TARGET-PROCEDURE (OUTPUT TABLE ttNode).
  
  hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN TARGET-PROCEDURE).
  cGlobalCurrentNodeKey = DYNAMIC-FUNCTION("getCurrentNodeKey":U IN TARGET-PROCEDURE).
  /*
  lReposSDO = DYNAMIC-FUNCTION("getReposSDO":U IN TARGET-PROCEDURE).
  */
  lReposSDO = TRUE.
  lNewChildNode = DYNAMIC-FUNCTION("getNewChildNode":U IN TARGET-PROCEDURE).

  IF pcNodeKey <> ? THEN 
    {get TreeDataTable hTable hTreeViewOCX}.  
  
  IF VALID-HANDLE(hTable) THEN DO:
    cNodeDetail = DYNAMIC-FUNCTION("getNodeDetails":U IN TARGET-PROCEDURE,hTable, pcNodeKey).
    ASSIGN dNodeObj     = DECIMAL(ENTRY(1,cNodeDetail,CHR(2)))
           rRecordRowid = TO-ROWID(ENTRY(2,cNodeDetail,CHR(2))).
  END.
  
  DYNAMIC-FUNCTION("setReposSDO":U IN TARGET-PROCEDURE,FALSE).

  CASE pcEvent:
    WHEN "EXPAND":U OR WHEN "EXPANDNOW":U THEN DO:
      DYNAMIC-FUNCTION("setCurrExpandNodeKey":U IN TARGET-PROCEDURE,pcNodeKey).
      IF NOT VALID-HANDLE(hTable) OR
         pcNodeKey = ? THEN
        RETURN.
      IF pcEvent = "EXPAND":U THEN DO:
        cFirstChild = DYNAMIC-FUNCTION("getProperty":U IN hTreeViewOCX, "CHILD":U, pcNodeKey).
        IF cFirstChild <> ? THEN DO:
          IF NOT DYNAMIC-FUNCTION("getProperty":U IN hTreeViewOCX, "TEXT":U, cFirstChild) BEGINS "+":U THEN
            LEAVE.
          SESSION:SET-WAIT-STATE("GENERAL":U).
          /* First delete the dummy node */
          ASSIGN hBuf = hTable:DEFAULT-BUFFER-HANDLE.
          CREATE QUERY hQry.  
          hQry:ADD-BUFFER(hBuf).
          hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.node_key = "&2"':U, hTable:NAME,cFirstChild)).
          hQry:QUERY-OPEN().
          hQry:GET-FIRST().
          
          IF hBuf:AVAILABLE THEN
            hBuf:BUFFER-DELETE().
          IF VALID-HANDLE(hQry) THEN
            DELETE OBJECT hQry.
          
          RUN deleteNode IN hTreeViewOCX (cFirstChild).
        END.
      END.
      SESSION:SET-WAIT-STATE("GENERAL":U).
      /* Now scan for new nodes */
      FIND FIRST ttNode
           WHERE ttNode.node_obj = dNodeObj
           NO-LOCK NO-ERROR.
      IF AVAILABLE ttNode THEN
        cNodeType = ttNode.data_source_type.
      /* First check if the current node is a structured node */
      IF NOT lNewChildNode THEN DO:
        IF CAN-FIND(FIRST bttNode
                    WHERE bttNode.node_obj      = ttNode.parent_node_obj
                    AND   bttNode.run_attribute = "STRUCTURED":U) AND
           cNodeType = "TXT" THEN DO:
          lReposTXTParent = TRUE.
          RUN reposTXTParentNode IN TARGET-PROCEDURE (INPUT pcNodeKey).
        END.
        IF cNodeType = "PRG":U THEN DO:
          lReposTXTParent = TRUE.
          RUN reposPRGParentNode IN TARGET-PROCEDURE (INPUT pcNodeKey).
        END.

        FIND FIRST ttNode
             WHERE ttNode.node_obj = dNodeObj
             NO-LOCK NO-ERROR.
        IF AVAILABLE ttNode AND 
           ttNode.run_attribute = "STRUCTURED":U THEN DO:
          RUN loadNodeData IN TARGET-PROCEDURE (pcNodeKey, ttNode.node_obj).
          ASSIGN lReposSDO       = TRUE
                 lStructuredNode = TRUE.
        END.
        DO:
          cNodes = "":U.
          FOR EACH ttNode 
              WHERE ttNode.parent_node_obj = dNodeObj
              NO-LOCK
              BREAK BY ttNode.node_label:
            cNodes = IF cNodes = "":U THEN STRING(ttNode.node_obj) ELSE cNodes + CHR(1) + STRING(ttNode.node_obj).
          END.
          DO iLoop = 1 TO NUM-ENTRIES(cNodes,CHR(1)):
            RUN loadNodeData IN TARGET-PROCEDURE (pcNodeKey, DECIMAL(ENTRY(iLoop,cNodes,CHR(1)))).
          END.
        END.
      END.
      RUN populateTree IN hTreeViewOCX (hTable, pcNodeKey).
      /* In some instances we might be viewing data on a SDV on a level, and
         decide to expand nodes on the same level, but for another parent. 
         In such a case the SDO will be refreshed thus losing our data in the
         SDV and we have to refresh the SDO again after the new nodes have
         been build to have the corresponding data on the SDV be the same as
         the current record in the SDO */
      IF lReposSDO THEN DO:
        IF lStructuredNode THEN
          ASSIGN cCurrentNodeKey = pcNodeKey.
        ELSE 
          ASSIGN cCurrentNodeKey = cGlobalCurrentNodeKey.
        
        DYNAMIC-FUNCTION("setCurrentNodeKey":U IN TARGET-PROCEDURE,?).
        RUN tvNodeSelected IN TARGET-PROCEDURE (INPUT cCurrentNodeKey).
        DYNAMIC-FUNCTION("selectNode" IN hTreeViewOCX, cCurrentNodeKey).
      END.
      IF lReposTXTParent THEN DO:
        DYNAMIC-FUNCTION("setCurrentNodeKey":U IN TARGET-PROCEDURE,?).
        RUN tvNodeSelected IN TARGET-PROCEDURE (INPUT cGlobalCurrentNodeKey).
        DYNAMIC-FUNCTION("selectNode" IN hTreeViewOCX, cGlobalCurrentNodeKey).
      END.
      SESSION:SET-WAIT-STATE("":U).
    END. /* EXPAND */
    WHEN "RIGHTCLICK":U THEN DO:
      IF dNodeObj <> 0 THEN
        RUN buildPopupMenu IN TARGET-PROCEDURE
                           (INPUT dNodeObj,
                            INPUT pcNodeKey).
      ELSE
        RUN buildPopupMenu IN TARGET-PROCEDURE
                           (INPUT 0,
                            INPUT "":U).
    END.
    WHEN "COLLAPSE" THEN DO:
      IF DYNAMIC-FUNCTION("getSelectedNode" IN hTreeViewOCX) = pcNodeKey THEN DO:
        RUN tvNodeSelected IN TARGET-PROCEDURE (INPUT pcNodeKey).
        DYNAMIC-FUNCTION("selectNode" IN hTreeViewOCX, cCurrentNodeKey).
      END.
    END.
  END. /* CASE */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tvNodeSelected) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tvNodeSelected Procedure 
PROCEDURE tvNodeSelected :
/*------------------------------------------------------------------------------
  Purpose:     Occurs when a user selected a node
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcNodeKey AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hNodeKey              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNodeKey              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dNodeObj              AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cDataset              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogicalObject        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSourceType       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSource           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPrimarySDO           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOSBOName           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabelSubsFields      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE rRecordRowid          AS ROWID      NO-UNDO.
  DEFINE VARIABLE cPrivateData          AS CHARACTER  NO-UNDO.
                                        
  DEFINE VARIABLE lMenuObject           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hTable                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSDOHandle            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNodeDetail           AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE hTreeViewOCX          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cGlobalCurrentNodeKey AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLastLaunchedNode     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentNode           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dParentNodeObj        AS DECIMAL    NO-UNDO.

  IF pcNodeKey = ? THEN
    RETURN.

  EMPTY TEMP-TABLE ttRunningSDOs.
  RUN getRunningSDOs IN TARGET-PROCEDURE (OUTPUT TABLE ttRunningSDOs).
  EMPTY TEMP-TABLE ttNode.
  RUN getNodeTable IN TARGET-PROCEDURE (OUTPUT TABLE ttNode).
  
  DEFINE BUFFER bttNode FOR ttNode.

  hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN TARGET-PROCEDURE).
  cGlobalCurrentNodeKey = DYNAMIC-FUNCTION("getCurrentNodeKey":U IN TARGET-PROCEDURE).
  cLastLaunchedNode = DYNAMIC-FUNCTION("getLastLaunchedNode":U IN TARGET-PROCEDURE).
  cParentNode = DYNAMIC-FUNCTION("getParentNode":U IN TARGET-PROCEDURE).
  DYNAMIC-FUNCTION("setDelete":U IN TARGET-PROCEDURE,FALSE).

  {get TreeDataTable hTable hTreeViewOCX}.  
  
  IF NOT VALID-HANDLE(hTable) THEN
    RETURN.
  
  RUN setDataLinkActive IN TARGET-PROCEDURE.
  
  ASSIGN cNodeKey = pcNodeKey.

  /* If the user re-selected the same node - we don't want to do anything again */
  IF cNodeKey = cGlobalCurrentNodeKey THEN
    RETURN.
  
  SESSION:SET-WAIT-STATE("GENERAL":U).
  
  ASSIGN cNodeDetail           = DYNAMIC-FUNCTION("getNodeDetails":U IN TARGET-PROCEDURE,hTable, cNodeKey)
         cGlobalCurrentNodeKey = cNodeKey
         cLastLaunchedNode    = IF cLastLaunchedNode = "":U OR cLastLaunchedNode = ? THEN cNodeKey ELSE cLastLaunchedNode.
  
  DYNAMIC-FUNCTION("setCurrentNodeKey":U IN TARGET-PROCEDURE,cGlobalCurrentNodeKey).
  DYNAMIC-FUNCTION("setLastLaunchedNode":U IN TARGET-PROCEDURE,cLastLaunchedNode).

  ASSIGN dNodeObj      = DECIMAL(ENTRY(1,cNodeDetail,CHR(2)))
         rRecordRowid  = TO-ROWID(ENTRY(2,cNodeDetail,CHR(2))).
         cPrivateData  = ENTRY(3,cNodeDetail,CHR(2)).
  
  ASSIGN cParentNode = DYNAMIC-FUNCTION("getProperty":U IN hTreeViewOCX, INPUT "PARENT":U, INPUT cGlobalCurrentNodeKey) 
         NO-ERROR.
  DYNAMIC-FUNCTION("setParentNode":U IN TARGET-PROCEDURE, cParentNode).

  /* Check if the node is a MENU structure - we need to read the submenus */
  IF INDEX(cPrivateData,"LogicalObject":U) > 0  THEN DO:
    lMenuObject = TRUE.
            
    ASSIGN cLogicalObject  = IF NUM-ENTRIES(cPrivateData,CHR(6)) >= 1 THEN ENTRY(2,ENTRY(1,cPrivateData,CHR(7)),CHR(6)) ELSE "":U
           cForeignFields  = "":U
           cDataSourceType = "MNU":U
           cDataSource     = IF NUM-ENTRIES(cPrivateData,CHR(6)) >= 3 THEN ENTRY(2,ENTRY(3,cPrivateData,CHR(7)),CHR(6)) ELSE "":U
           NO-ERROR.
  END.
  ELSE
    lMenuObject = FALSE.

  FIND FIRST ttNode
       WHERE ttNode.node_obj = dNodeObj
       NO-LOCK NO-ERROR.

  IF NOT AVAILABLE ttNode THEN DO:
    SESSION:SET-WAIT-STATE("":U).
    RETURN.
  END.
  
  IF lMenuObject = FALSE THEN
    ASSIGN cLogicalObject   = ttNode.logical_object
           cForeignFields   = ttNode.foreign_fields
           cLabelSubsFields = ttNode.label_text_substitution_fields
           cDataSourceType  = ttNode.data_source_type
           cDataSource      = ttNode.data_source
           cPrimarySDO      = ttNode.primary_sdo
           NO-ERROR.
  
  IF cDataSourceType = "SDO":U OR
    (cDataSourceType = "TXT":U AND
     cPrimarySDO <> "":U) THEN DO:
    cSDOSBOName = cPrimarySDO.
    FIND FIRST ttRunningSDOs
         WHERE ttRunningSDOs.cSDOName = cSDOSBOName
         NO-LOCK NO-ERROR.
    IF AVAILABLE ttRunningSDOs AND
       VALID-HANDLE(ttRunningSDOs.hSDOHandle) THEN DO:
      RUN repositionSDO IN TARGET-PROCEDURE
                        (INPUT cForeignFields,
                         INPUT ttRunningSDOs.hSDOHandle,
                         INPUT ttRunningSDOs.hParentSDO,
                         INPUT rRecordRowid,
                         INPUT cNodeKey + CHR(1) + ttRunningSDOs.cServerMode).
                         
      /** If the parent node is a structured node and this one is 
      
          not, the we need to reposition the parent sdo **/
      IF ttNode.parent_node_obj <> 0 AND
         ttNode.run_attribute <> "STRUCTURED":U THEN DO:
        FIND FIRST bttNode
             WHERE bttNode.node_obj = ttNode.parent_node_obj
             NO-LOCK NO-ERROR.
        IF AVAILABLE bttNode THEN DO:
          IF bttNode.data_source_type = "TXT":U THEN DO:
            dParentNodeObj = bttNode.parent_node_obj.
            FIND FIRST bttNode
                 WHERE bttNode.node_obj = dParentNodeObj
                 NO-LOCK NO-ERROR.
          END.
        END.
        IF AVAILABLE bttNode AND
           bttNode.run_attribute = "STRUCTURED":U THEN
          RUN repositionParentSDO IN TARGET-PROCEDURE (INPUT bttNode.primary_sdo + CHR(1) + "REPOS":U,
                                                       INPUT cParentNode).
      END.
    END.
  END.

  /* When an extract program was used to create a node we 
     need to launch the SDO/SBO that is required by the 
     logical object being launched. */
  IF cDataSourceType = "PRG":U AND 
     cLogicalObject <> "":U THEN DO:
    cSDOSBOName = cPrimarySDO.
    RUN manageSDOs IN TARGET-PROCEDURE
                   (INPUT  cSDOSBOName,
                    INPUT  cForeignFields,
                    INPUT  "":U,
                    INPUT cLabelSubsFields,
                    INPUT (ttNode.run_attribute = "STRUCTURED":U),
                    INPUT ttNode.fields_to_store,
                    OUTPUT hSDOHandle).
    IF NOT VALID-HANDLE(hSDOHandle) THEN DO:
      SESSION:SET-WAIT-STATE("":U).
      RETURN.
    END.
    FIND FIRST ttRunningSDOs
         WHERE ttRunningSDOs.cSDOName = cSDOSBOName
         NO-LOCK NO-ERROR.
    IF AVAILABLE ttRunningSDOs AND
       VALID-HANDLE(ttRunningSDOs.hSDOHandle) THEN DO:
      RUN repositionSDO IN TARGET-PROCEDURE
                        (INPUT cForeignFields,
                         INPUT ttRunningSDOs.hSDOHandle,
                         INPUT ttRunningSDOs.hParentSDO,
                         INPUT rRecordRowid,
                         INPUT cNodeKey + CHR(1) + ttRunningSDOs.cServerMode).
    END.
  END.
  
  DYNAMIC-FUNCTION("setReposSDO":U IN TARGET-PROCEDURE, FALSE).
  RUN nodeSelected IN TARGET-PROCEDURE (INPUT cNodeKey).
  IF DYNAMIC-FUNCTION("getReposSDO":U IN TARGET-PROCEDURE) = TRUE THEN DO:
    FIND FIRST ttRunningSDOs
         WHERE ttRunningSDOs.cSDOName = cSDOSBOName
         NO-LOCK NO-ERROR.
    IF AVAILABLE ttRunningSDOs AND
       VALID-HANDLE(ttRunningSDOs.hSDOHandle) THEN DO:
      RUN repositionSDO IN TARGET-PROCEDURE
                        (INPUT cForeignFields,
                         INPUT ttRunningSDOs.hSDOHandle,
                         INPUT ttRunningSDOs.hParentSDO,
                         INPUT rRecordRowid,
                         INPUT cNodeKey + CHR(1) + ttRunningSDOs.cServerMode).
    END.
  END.
  PUBLISH "tvNodeSelectedNotification" FROM TARGET-PROCEDURE (INPUT pcNodeKey).

  SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord Procedure 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateState Procedure 
PROCEDURE updateState :
/*
  Purpose:     This procedure will capture any events like Add, Modify or Copy
  Parameters:  I pcState - Indicates the new state of the Container
*/
DEFINE INPUT PARAMETER pcState AS CHAR NO-UNDO.

DEF VAR cLastLaunchedNode AS CHAR NO-UNDO.
DEF VAR cNewContainerMode AS CHAR NO-UNDO.
DEF VAR cLabelSubsFields AS CHAR NO-UNDO.
DEF VAR cCurrentNodeKey AS CHAR NO-UNDO.
DEF VAR hCurrentNodeKey AS HANDLE NO-UNDO.
DEF VAR cDataSourceType AS CHAR NO-UNDO.
DEF VAR cSelImgFileName AS CHAR NO-UNDO.
DEF VAR cImageFileName AS CHAR NO-UNDO.
DEF VAR hSelectedImage AS HANDLE NO-UNDO.
DEF VAR cNodeLabelExpr AS CHAR NO-UNDO.
DEF VAR cFieldsToStore AS CHAR NO-UNDO.
DEF VAR cRunAttribute AS CHAR NO-UNDO.
DEF VAR lNewChildNode AS LOG NO-UNDO.
DEF VAR lNodeChecked AS LOG NO-UNDO.
DEF VAR hPrivateData AS HANDLE NO-UNDO.
DEF VAR cCurrentNode AS CHAR NO-UNDO.
DEF VAR hRecordRowId AS HANDLE NO-UNDO.
DEF VAR hNodeChecked AS HANDLE NO-UNDO.
DEF VAR hTreeViewOCX AS HANDLE NO-UNDO.
DEF VAR cCurrentMode AS CHAR NO-UNDO.
DEF VAR gcParentNode AS CHAR NO-UNDO.
DEF VAR cDataSource AS CHAR NO-UNDO.
DEF VAR cSubstitute AS CHAR NO-UNDO EXTENT 10.
DEF VAR lLabelBlank AS LOG NO-UNDO.
DEF VAR cParentNode AS CHAR NO-UNDO.
DEF VAR hNodeInsert AS HANDLE NO-UNDO.
DEF VAR ghSDOHandle AS HANDLE NO-UNDO.
DEF VAR hRecordRef AS HANDLE NO-UNDO.
DEF VAR cNodeLabel AS CHAR NO-UNDO.
DEF VAR hParentKey AS HANDLE NO-UNDO.
DEF VAR hSDOHandle AS HANDLE NO-UNDO.
DEF VAR hParentSDO AS HANDLE NO-UNDO.
DEF VAR cValueList AS CHAR NO-UNDO.
DEF VAR cChildKey AS CHAR NO-UNDO.
DEF VAR hNewTable AS HANDLE NO-UNDO.
DEF VAR cObjField AS CHAR NO-UNDO.
DEF VAR gdNodeObj AS DEC NO-UNDO.
DEF VAR dNodeObj AS DEC NO-UNDO.
DEF VAR cDataset AS CHAR NO-UNDO.
DEF VAR hNodeObj AS HANDLE NO-UNDO.
DEF VAR hNodeBuf AS HANDLE NO-UNDO.
DEF VAR hNodeKey AS HANDLE NO-UNDO.
DEF VAR hLabel AS HANDLE NO-UNDO.
DEF VAR hTable AS HANDLE NO-UNDO.
DEF VAR hImage AS HANDLE NO-UNDO.
DEF VAR cSMode AS CHAR NO-UNDO.
DEF VAR hSort AS HANDLE NO-UNDO.
DEF VAR iLoop AS INT NO-UNDO.
DEF VAR hBuf AS HANDLE NO-UNDO.
DEF VAR hQry AS HANDLE NO-UNDO.

EMPTY TEMP-TABLE ttRunningSDOs.
RUN getRunningSDOs IN TARGET-PROCEDURE (OUTPUT TABLE ttRunningSDOs).
EMPTY TEMP-TABLE ttNode.
RUN getNodeTable IN TARGET-PROCEDURE (OUTPUT TABLE ttNode).

cLastLaunchedNode = DYNAMIC-FUNCTION("getLastLaunchedNode":U IN TARGET-PROCEDURE).
hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN TARGET-PROCEDURE).
cCurrentMode = DYNAMIC-FUNCTION("getCurrentMode":U IN TARGET-PROCEDURE).
cNewContainerMode = DYNAMIC-FUNCTION("getNewContainerMode":U IN TARGET-PROCEDURE).
lNewChildNode = DYNAMIC-FUNCTION("getNewChildNode":U IN TARGET-PROCEDURE).
gdNodeObj = DYNAMIC-FUNCTION("getNodeObj":U IN TARGET-PROCEDURE).
cCurrentNodeKey = DYNAMIC-FUNCTION("getCurrentNodeKey":U IN TARGET-PROCEDURE).
gcParentNode = DYNAMIC-FUNCTION("getParentNode":U IN TARGET-PROCEDURE).
ghSDOHandle = DYNAMIC-FUNCTION("getSDOHandle":U IN TARGET-PROCEDURE).

RUN setDataLinkActive IN TARGET-PROCEDURE.
IF pcState = "VIEW":U THEN
  NEXT.
IF cLastLaunchedNode = ? OR 
   cLastLaunchedNode = "":U THEN DO:
  IF VALID-HANDLE(hTreeViewOCX) THEN
    cCurrentNode = DYNAMIC-FUNCTION("getSelectedNode" IN hTreeViewOCX).
END.
ELSE
  cCurrentNode = cLastLaunchedNode.
IF pcState = "Update" THEN DO:
  IF VALID-HANDLE(hTreeViewOCX) THEN
    RUN disableObject IN hTreeViewOCX.
  cCurrentMode = cNewContainerMode.
  DYNAMIC-FUNCTION("setCurrentMode":U IN TARGET-PROCEDURE,cCurrentMode).
END.

{get TreeDataTable hTable hTreeViewOCX}.

IF cCurrentNode = ? THEN DO:
  IF pcState = 'updateComplete':U AND
    (cCurrentMode = "Add":U OR 
     cCurrentMode = "Copy":U) THEN DO:
    RUN loadTreeData IN TARGET-PROCEDURE.
    RUN populateTree IN hTreeViewOCX (hTable, "":U).
    IF VALID-HANDLE(hTreeViewOCX) THEN
      RUN enableObject IN hTreeViewOCX.
    RUN selectFirstNode IN hTreeViewOCX.    
  END.
  RETURN.
END.

cParentNode = DYNAMIC-FUNCTION("getProperty" IN hTreeViewOCX, INPUT "PARENT":U, INPUT cCurrentNode) NO-ERROR.

IF cParentNode = ? OR
   ERROR-STATUS:ERROR THEN
  ASSIGN cParentNode = DYNAMIC-FUNCTION("getRootNodeParentKey" IN hTreeViewOCX) NO-ERROR.

/* Grab the handles to the individual fields in the tree data table. */
ASSIGN hBuf = hTable:DEFAULT-BUFFER-HANDLE
       hNodeObj = hBuf:BUFFER-FIELD('node_obj':U)
       hCurrentNodeKey = hBuf:BUFFER-FIELD('node_key':U).

CREATE QUERY hQry.  
hQry:ADD-BUFFER(hBuf).
hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.node_key = "&2"':U, hTable:NAME,cCurrentNode)).
hQry:QUERY-OPEN().
hQry:GET-FIRST().

DO WHILE hBuf:AVAILABLE:
  ASSIGN dNodeObj = hNodeObj:BUFFER-VALUE
         cCurrentNode = hCurrentNodeKey:BUFFER-VALUE
         NO-ERROR.
  LEAVE.
END.

IF lNewChildNode THEN
  dNodeObj = gdNodeObj.

IF VALID-HANDLE(hQry) THEN
  DELETE OBJECT hQry.

FIND FIRST ttNode
     WHERE ttNode.node_obj = dNodeObj
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE ttNode THEN
  RETURN.

ASSIGN cNodeLabel = ttNode.node_label
       lNodeChecked = ttNode.node_checked
       cDataSourceType = ttNode.data_source_type
       cDataSource = ttNode.data_source
       cNodeLabelExpr = ttNode.node_text_label_expression
       cLabelSubsFields = ttNode.label_text_substitution_fields
       cImageFileName = ttNode.image_file_name
       cSelImgFileName = ttNode.selected_image_file_name
       cRunAttribute = ttNode.run_attribute
       cFieldsToStore = ttNode.fields_to_store
       NO-ERROR.

/* Since we can only add nodes from a DataSource of SDO's in this procedure, */
/* we will not execute this code for any other Data Sources                  */
IF cDataSourceType = "PRG":U THEN DO:
  /* If nodes were created from an extraction program, we will delete all child nodes for that node tree */
  /* and rebuild from scratch */
  
  IF pcState <> "updateComplete":U AND
     pcState <> "deleteComplete":U OR 
     cCurrentMode = "Cancel" THEN 
    RETURN.
  
  RUN refreshPRGNodes IN TARGET-PROCEDURE (INPUT ttNode.primary_sdo,
                                           INPUT hBuf,
                                           INPUT hTable,
                                           INPUT dNodeObj,
                                           INPUT cParentNode).
END.
ELSE
IF cDataSourceType <> "SDO":U THEN
  RETURN.

IF cDataSource = "":U THEN
  RETURN.

FIND FIRST ttRunningSDOs
     WHERE ttRunningSDOs.cSDOName = cDataSource
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE ttRunningSDOs THEN
  RETURN.
ELSE
  ASSIGN hSDOHandle = ttRunningSDOs.hSDOHandle
         hParentSDO = ttRunningSDOs.hParentSDO
         cSMode = ttRunningSDOs.cServerMode.
IF NOT VALID-HANDLE(hSDOHandle) THEN
  RETURN.

cValueList = DYNAMIC-FUNCTION("getEntityName":U IN TARGET-PROCEDURE,hSDOHandle).
cObjField = DYNAMIC-FUNCTION("getObjKeyField":U IN TARGET-PROCEDURE,cValueList).

DYNAMIC-FUNCTION("setState":U IN TARGET-PROCEDURE,pcState).
IF pcState = 'updateComplete':U AND 
  cCurrentMode <> "Cancel" THEN DO:
 IF VALID-HANDLE(hTreeViewOCX) AND 
    VALID-HANDLE(hTable) THEN DO:
   IF cCurrentMode = 'add':U OR 
       cCurrentMode = 'copy':U THEN DO:
     IF NOT lNewChildNode THEN DO:
       cCurrentNodeKey = ?.
       DYNAMIC-FUNCTION("setCurrentNodeKey":U IN TARGET-PROCEDURE,cCurrentNodeKey).
       ASSIGN hNodeBuf = hTable:DEFAULT-BUFFER-HANDLE.
       CREATE TEMP-TABLE hNewTable.
       hNewTable:CREATE-LIKE(hNodeBuf).
       hNewTable:TEMP-TABLE-PREPARE('tTreeData').
       hBuf = hNewTable:DEFAULT-BUFFER-HANDLE.
       
       lLabelBlank = FALSE.
       LABEL_LOOP:
       DO iLoop = 1 TO NUM-ENTRIES(cLabelSubsFields):
         IF ENTRY(iLoop,cLabelSubsFields) = "":U THEN
           LEAVE LABEL_LOOP.
         cSubstitute[iLoop] = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hSDOHandle, ENTRY(iLoop,cLabelSubsFields))).
         IF cSubstitute[iLoop] = ? OR 
            cSubstitute[iLoop] = "":U THEN
           ASSIGN cSubstitute[iLoop] = "":U
                  lLabelBlank        = TRUE.
       END.
       ASSIGN hNodeKey = hBuf:BUFFER-FIELD('node_key':U)
              hParentKey = hBuf:BUFFER-FIELD('parent_node_key':U)
              hNodeObj = hBuf:BUFFER-FIELD('node_obj':U)
              hPrivateData = hBuf:BUFFER-FIELD('private_data':U)
              hLabel = hBuf:BUFFER-FIELD('node_label':U)
              hImage = hBuf:BUFFER-FIELD('image':U)
              hSelectedImage = hBuf:BUFFER-FIELD('selected_image':U)
              hRecordRef = hBuf:BUFFER-FIELD('record_ref':U)
              hRecordRowId = hBuf:BUFFER-FIELD('record_rowid':U)
              hNodeChecked = hBuf:BUFFER-FIELD('node_checked':U)
              hSort = hBuf:BUFFER-FIELD('node_sort':U)
              hNodeInsert = hBuf:BUFFER-FIELD('node_insert':U).
       hBuf:BUFFER-CREATE().
       IF (cRunAttribute = "STRUCTURED":U) THEN
         dNodeObj = gdNodeObj.
       ASSIGN hParentKey:BUFFER-VALUE = gcParentNode
              hNodeKey:BUFFER-VALUE = DYNAMIC-FUNCTION('getNextNodeKey':U IN hTreeViewOCX)
              hNodeObj:BUFFER-VALUE = dNodeObj
              hLabel:BUFFER-VALUE = TRIM(SUBSTITUTE(cNodeLabelExpr,cSubstitute[1],cSubstitute[2],cSubstitute[3],cSubstitute[4],cSubstitute[5],cSubstitute[6],cSubstitute[7],cSubstitute[8],cSubstitute[9]))
              hRecordRef:BUFFER-VALUE = assignRefValue(cObjField,hSDOHandle)
              hRecordRowId:BUFFER-VALUE = TO-ROWID(ENTRY(1,DYNAMIC-FUNCTION("getRowIdent":U IN hSDOHandle)))
              hNodeChecked:BUFFER-VALUE = lNodeChecked
              hImage:BUFFER-VALUE = cImageFileName
              hSelectedImage:BUFFER-VALUE = cSelImgFileName
              hSort:BUFFER-VALUE = TRUE
              hNodeInsert:BUFFER-VALUE = IF gcParentNode = "":U THEN 1 ELSE 4.
      IF (cRunAttribute = "STRUCTURED":U) THEN DO:
         IF NUM-ENTRIES(cFieldsToStore,"^":U) >= 3 THEN DO:
           cChildKey = ENTRY(3,cFieldsToStore,"^":U).
           hPrivateData:BUFFER-VALUE = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hSDOHandle, cChildKey)).
         END.
       END.
       hNodeBuf:BUFFER-CREATE().
       hNodeBuf:BUFFER-COPY(hBuf).
       cCurrentNodeKey = hNodeKey:BUFFER-VALUE.
       DYNAMIC-FUNCTION("setCurrentNodeKey":U IN TARGET-PROCEDURE,"":U).
       DYNAMIC-FUNCTION("setLastLaunchedNode":U IN TARGET-PROCEDURE,cCurrentNodeKey).
       /* To ensure we always get a label */
       IF lLabelBlank THEN DO:
         RUN repositionSDO IN TARGET-PROCEDURE
                           (INPUT "":U,
                            INPUT hSDOHandle,
                            INPUT ?,
                            INPUT hRecordRowId:BUFFER-VALUE,
                            INPUT cCurrentNodeKey + CHR(1) + cSMode).
         IF cRunAttribute <> "STRUCTURED":U THEN DO:
           DYNAMIC-FUNCTION("openQuery":U IN hSDOHandle).
           RUN fetchFirst IN hSDOHandle.
         END.
         lLabelBlank = FALSE.
         LABEL_LOOP:
         DO iLoop = 1 TO NUM-ENTRIES(cLabelSubsFields):
           IF ENTRY(iLoop,cLabelSubsFields) = "":U THEN
             LEAVE LABEL_LOOP.
           cSubstitute[iLoop] = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hSDOHandle, ENTRY(iLoop,cLabelSubsFields))).
           IF cSubstitute[iLoop] = ? THEN
             ASSIGN cSubstitute[iLoop] = "":U
                    lLabelBlank        = TRUE.
         END.
         hLabel:BUFFER-VALUE = TRIM(SUBSTITUTE(cNodeLabelExpr,cSubstitute[1],cSubstitute[2],cSubstitute[3],cSubstitute[4],cSubstitute[5],cSubstitute[6],cSubstitute[7],cSubstitute[8],cSubstitute[9])).
         DYNAMIC-FUNCTION("setProperty":U IN hTreeViewOCX, "TEXT":U, cCurrentNodeKey,hLabel:BUFFER-VALUE).
       END.
       /* Now we need to check if the new node might have child nodes */
       IF CAN-FIND(FIRST ttNode
                   WHERE ttNode.parent_node_obj = dNodeObj
                   NO-LOCK) THEN DO:
         RUN createDummyChild IN TARGET-PROCEDURE (hBuf,hNodeKey:BUFFER-VALUE,"DUMMY":U).
       END.
       RUN populateTree IN hTreeViewOCX (hBuf, gcParentNode).
     END.
     ELSE DO: /* New Child Node */
       ASSIGN hBuf = hTable:DEFAULT-BUFFER-HANDLE.
       hSDOHandle = ghSDOHandle.
       
       ASSIGN cCurrentNode = cCurrentNodeKey
              cParentNode  = gcParentNode.
       
       ASSIGN hNodeKey = hBuf:BUFFER-FIELD('node_key':U)
              hParentKey = hBuf:BUFFER-FIELD('parent_node_key':U)
              hNodeObj = hBuf:BUFFER-FIELD('node_obj':U)
              hPrivateData = hBuf:BUFFER-FIELD('private_data':U)
              hLabel = hBuf:BUFFER-FIELD('node_label':U)
              hImage = hBuf:BUFFER-FIELD('image':U)
              hSelectedImage = hBuf:BUFFER-FIELD('selected_image':U)
              hRecordRef = hBuf:BUFFER-FIELD('record_ref':U)
              hRecordRowId = hBuf:BUFFER-FIELD('record_rowid':U)
              hNodeChecked = hBuf:BUFFER-FIELD('node_checked':U)
              hSort = hBuf:BUFFER-FIELD('node_sort':U)
              hNodeInsert = hBuf:BUFFER-FIELD('node_insert':U).
       IF INDEX(DYNAMIC-FUNCTION("getQueryString":U IN hSDOHandle),cObjField) > 0 THEN
         RUN manageSDOs IN TARGET-PROCEDURE
            (INPUT  IF VALID-HANDLE(hSDOHandle) THEN DYNAMIC-FUNCTION("getLogicalObjectName":U IN hSDOHandle) ELSE "":U,
             INPUT  DYNAMIC-FUNCTION("getForeignFields":U IN hSDOHandle),
             INPUT  IF VALID-HANDLE(hParentSDO) THEN DYNAMIC-FUNCTION("getLogicalObjectName":U IN hParentSDO) ELSE "":U,
             INPUT  cLabelSubsFields,
             INPUT  (cRunAttribute = "STRUCTURED":U),
             INPUT  cFieldsToStore,
             OUTPUT  hSDOHandle).
       DYNAMIC-FUNCTION("openQuery":U IN hSDOHandle).
       RUN refreshRow IN hSDOHandle.
       CREATE QUERY hQry.  
       hQry:ADD-BUFFER(hBuf).
       hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.node_key = "&2"':U, hTable:NAME,cCurrentNodeKey)).
       hQry:QUERY-OPEN().
       hQry:GET-FIRST().
       
       ASSIGN cValueList = DYNAMIC-FUNCTION("getEntityName":U IN TARGET-PROCEDURE,hSDOHandle).
              cObjField = DYNAMIC-FUNCTION("getObjKeyField":U IN TARGET-PROCEDURE,cValueList).
       
       DO iLoop = 1 TO NUM-ENTRIES(cLabelSubsFields):
         cSubstitute[iLoop] = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hSDOHandle, ENTRY(iLoop,cLabelSubsFields))).
         IF cSubstitute[iLoop] = ? THEN
           cSubstitute[iLoop] = "":U.
       END.
       ASSIGN hNodeObj:BUFFER-VALUE = gdNodeObj
              hLabel:BUFFER-VALUE = TRIM(SUBSTITUTE(cNodeLabelExpr,cSubstitute[1],cSubstitute[2],cSubstitute[3],cSubstitute[4],cSubstitute[5],cSubstitute[6],cSubstitute[7],cSubstitute[8],cSubstitute[9]))
              hRecordRef:BUFFER-VALUE = assignRefValue(cObjField,hSDOHandle)
              hRecordRowId:BUFFER-VALUE = TO-ROWID(ENTRY(1,DYNAMIC-FUNCTION("getRowIdent":U IN hSDOHandle)))
              hNodeChecked:BUFFER-VALUE = lNodeChecked
              hImage:BUFFER-VALUE = cImageFileName
              hSelectedImage:BUFFER-VALUE = cSelImgFileName
              hSort:BUFFER-VALUE = TRUE
              hNodeInsert:BUFFER-VALUE = IF cParentNode = "":U THEN 1 ELSE 4.
       IF (cRunAttribute = "STRUCTURED":U) THEN DO:
         IF NUM-ENTRIES(cFieldsToStore,"^":U) >= 3 THEN DO:
           cChildKey = ENTRY(3,cFieldsToStore,"^":U).
           hPrivateData:BUFFER-VALUE = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hSDOHandle, cChildKey)).
         END.
       END.
       DYNAMIC-FUNCTION("setProperty":U IN hTreeViewOCX, "TEXT":U, cCurrentNodeKey, hLabel:BUFFER-VALUE).
       cCurrentNodeKey = hNodeKey:BUFFER-VALUE.
       /* Now we need to check if the new node might have child nodes */
       IF CAN-FIND(FIRST ttNode WHERE ttNode.parent_node_obj = gdNodeObj NO-LOCK) THEN DO:
         RUN createDummyChild IN TARGET-PROCEDURE (hBuf,cCurrentNode,"DUMMYADD":U).
       END.
       DYNAMIC-FUNCTION("setCurrentNodeKey":U IN TARGET-PROCEDURE,"":U).
       DYNAMIC-FUNCTION("setLastLaunchedNode":U IN TARGET-PROCEDURE,cCurrentNodeKey).
       lNewChildNode = FALSE.
       DYNAMIC-FUNCTION("setNewChildNode":U IN TARGET-PROCEDURE,lNewChildNode).
       IF VALID-HANDLE(hQry) THEN
         DELETE OBJECT hQry.
     END. /* New Child Node */
     RUN tvNodeSelected IN TARGET-PROCEDURE (INPUT cCurrentNodeKey).
   END.
   ELSE DO:
     DYNAMIC-FUNCTION("checkQueryString":U IN TARGET-PROCEDURE,cObjField,hSDOHandle,cCurrentNode).
     DYNAMIC-FUNCTION("openQuery":U IN hSDOHandle).
     DO iLoop = 1 TO NUM-ENTRIES(cLabelSubsFields):
       cSubstitute[iLoop] = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hSDOHandle, ENTRY(iLoop,cLabelSubsFields))).
       IF cSubstitute[iLoop] = ? THEN
         cSubstitute[iLoop] = "":U.
     END.
     DYNAMIC-FUNCTION("setProperty":U IN hTreeViewOCX, "TEXT":U, cCurrentNode, TRIM(SUBSTITUTE(cNodeLabelExpr,cSubstitute[1],cSubstitute[2],cSubstitute[3],cSubstitute[4],cSubstitute[5],cSubstitute[6],cSubstitute[7],cSubstitute[8],cSubstitute[9]))).
     DYNAMIC-FUNCTION("setCurrentNodeKey":U IN TARGET-PROCEDURE,"":U).
     RUN tvNodeSelected IN TARGET-PROCEDURE (INPUT cCurrentNode).
   END.
 END.
 IF VALID-HANDLE(hTreeViewOCX) THEN
   RUN enableObject IN hTreeViewOCX.
END.
IF pcState = 'deleteComplete':u THEN DO:
  {get TreeDataTable hTable hTreeViewOCX}.
  IF VALID-HANDLE(hTreeViewOCX) AND 
     VALID-HANDLE(hTable) THEN DO:
    RUN deleteNode IN hTreeViewOCX (cCurrentNodeKey).
    RUN deleteNodeRecord IN TARGET-PROCEDURE (cCurrentNodeKey).
    DYNAMIC-FUNCTION("setLastLaunchedNode":U IN TARGET-PROCEDURE,"":U).
    cLastLaunchedNode = "":U.
  END.
END.
RUN setDataLinkActive IN TARGET-PROCEDURE.
IF pcState = "updateComplete" OR
   pcState = "deleteComplete" THEN DO:
  cCurrentMode = IF pcState = "deleteComplete" THEN "delete" ELSE cCurrentMode.
  DYNAMIC-FUNCTION("setCurrentMode":U IN TARGET-PROCEDURE,cCurrentMode).
  RUN toolbar IN TARGET-PROCEDURE (INPUT "disableData").
END.
{set ContainerMode 'VIEW':U}.
IF pcState = 'updateComplete':U AND 
   (cCurrentMode = 'add':U OR 
    cCurrentMode = 'copy':U) THEN DO:
  ghSDOHandle = hSDOHandle.
  DYNAMIC-FUNCTION("setSDOHandle":U IN TARGET-PROCEDURE,ghSDOHandle).
END.
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
      ENTRY(iLoop,cRecordRef,CHR(1)) = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN phDataObject, ENTRY(iLoop,pcRefFields))).
    END.
  END.
  ELSE 
    cRecordRef = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN phDataObject, pcRefFields)).
  RETURN cRecordRef.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION checkQueryString Procedure 
FUNCTION checkQueryString RETURNS LOGICAL
  ( pcObjField  AS CHARACTER,
    phSDOHandle AS HANDLE,
    pcNodeKey   AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This function checks to see if the fields that make up the unique key
            of a record has changed and if it did it will fix the query to find
            the changed record with the correct values.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTable        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNodeDetail   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cOldRecordRef AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewRecordRef AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop         AS INTEGER    NO-UNDO.

  /* This only applies to tables where the key field is not an _obj field */
  IF NUM-ENTRIES(pcObjField) = 1 AND
     INDEX(pcObjField,"_obj") <> 0 THEN
    RETURN FALSE.
  
  hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN TARGET-PROCEDURE).

  {get TreeDataTable hTable hTreeViewOCX}.  
  
  IF NOT VALID-HANDLE(hTable) THEN
    RETURN FALSE.
  
  ASSIGN cNodeDetail = DYNAMIC-FUNCTION("getNodeDetails":U IN TARGET-PROCEDURE,hTable, pcNodeKey).
  
  ASSIGN cOldRecordRef = ENTRY(5,cNodeDetail,CHR(2)).
  cNewRecordRef = "":U.
  cNewRecordRef = DYNAMIC-FUNCTION("assignRefValue":U IN TARGET-PROCEDURE,pcObjField,phSDOHandle).
  
  IF cOldRecordRef <> cNewRecordRef THEN DO:
    DYNAMIC-FUNCTION("setQueryWhere":U IN phSDOHandle, "":U).
    /* Re-initialze the SDO to get the query back to a normal state */
    DYNAMIC-FUNCTION('assignQuerySelection':U IN phSDOHandle, pcObjField , cNewRecordRef, '':U).

    /* Now that we've changed the query we need to ensure that the Node table is changed 
       to use the new record reference key values */
    hTable = hTable:DEFAULT-BUFFER-HANDLE.
    hTable:FIND-FIRST("WHERE " + hTable:NAME + ".node_key = '" + pcNodeKey + "'":U).

    IF hTable:AVAILABLE THEN
      ASSIGN hTable:BUFFER-FIELD("record_ref":U):BUFFER-VALUE = cNewRecordRef.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-childWindowsOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION childWindowsOpen Procedure 
FUNCTION childWindowsOpen RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: to check if child windows open from this window - use to give warning
           when closing window with X or ESC 
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iLoop             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTargets          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hHandle           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lChildren         AS LOGICAL    NO-UNDO.

  {get containertarget cTargets}.

  ASSIGN lChildren  = NO.
  
  target-loop:
  DO iLoop = 1 TO NUM-ENTRIES(cTargets):
    ASSIGN hHandle = WIDGET-HANDLE(ENTRY(iLoop, cTargets)) NO-ERROR.
    IF VALID-HANDLE(hHandle) AND
       INDEX(hHandle:FILE-NAME, "rydyncontw":U) <> 0 THEN
    DO:
      ASSIGN lChildren  = YES.
      LEAVE target-loop.    
    END.
  END.
  
  RETURN lChildren.

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

&IF DEFINED(EXCLUDE-getFieldList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldList Procedure 
FUNCTION getFieldList RETURNS CHARACTER
  (pcForeignFields AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Return a comma delimited list of just the field names in the foreign
            fields list. (Removes table prefixes, and list the fields just once)
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFieldList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEntry      AS INTEGER    NO-UNDO.
  
  /* Initialize the output value */
  cFieldList = "":U.
  
  /* Check if valid Foreign Fields were specified */
  IF pcForeignFields <> "":U                AND
     pcForeignFields <> ?                   AND
     NUM-ENTRIES(pcForeignFields) MOD 2 = 0 THEN
  
  DO iEntry = 2 TO NUM-ENTRIES(pcForeignFields) BY 2:
    cFieldList = cFieldList + (IF TRIM(cFieldList) = "":U THEN "":U ELSE ",":U)
               + ENTRY(iEntry, pcForeignFields).
  END.
  
  RETURN cFieldList.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMainTableObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMainTableObj Procedure 
FUNCTION getMainTableObj RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dMainTableObj AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE hTreeViewOCX  AS HANDLE     NO-UNDO.
  hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN TARGET-PROCEDURE).

  IF VALID-HANDLE(hTreeViewOCX) THEN
    dMainTableObj = DYNAMIC-FUNCTION("getMainTableObj" IN hTreeViewOCX).
  RETURN dMainTableObj.   /* Function return value. */

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
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuf            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQry            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeObj        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRecordRowId    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hPrivateData    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeExpanded   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRecordRef      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dNodeObj        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE rRecordRowid    AS ROWID      NO-UNDO.
  DEFINE VARIABLE cPrivateData    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeDetails    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNodeExpanded   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cRecordRef      AS CHARACTER  NO-UNDO.
  
  /* Grab the handles to the individual fields in the tree data table. */
  ASSIGN hBuf           = phTable:DEFAULT-BUFFER-HANDLE
         hNodeObj       = hBuf:BUFFER-FIELD('node_obj':U)
         hRecordRowId   = hBuf:BUFFER-FIELD('record_rowid':U)
         hPrivateData   = hBuf:BUFFER-FIELD('private_data':U)
         hNodeExpanded  = hBuf:BUFFER-FIELD('node_expanded':U)
         hRecordRef     = hBuf:BUFFER-FIELD('record_ref':U).
  
  CREATE QUERY hQry.  
  hQry:ADD-BUFFER(hBuf).
  hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.node_key = "&2":U':U, phTable:NAME,pcNodeKey)).
  hQry:QUERY-OPEN().
  hQry:GET-FIRST().
  
  DO WHILE hBuf:AVAILABLE:
    ASSIGN dNodeObj        = hNodeObj:BUFFER-VALUE 
           rRecordRowid    = hRecordRowId:BUFFER-VALUE 
           cPrivateData    = hPrivateData:BUFFER-VALUE
           lNodeExpanded   = hNodeExpanded:BUFFER-VALUE
           cRecordRef      = hRecordRef:BUFFER-VALUE
           NO-ERROR.
    LEAVE.
  END.

  IF VALID-HANDLE(hQry) THEN
    DELETE OBJECT hQry.
  
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

&IF DEFINED(EXCLUDE-getObjectVersionNumber) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectVersionNumber Procedure 
FUNCTION getObjectVersionNumber RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN "".   /* Function return value. */

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

&IF DEFINED(EXCLUDE-setContainerMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setContainerMode Procedure 
FUNCTION setContainerMode RETURNS LOGICAL
  ( INPUT cContainerMode AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  /*
  gcNewContainerMode = cContainerMode.
  */
  RETURN SUPER( INPUT cContainerMode ).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setForeignFieldsForStructure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setForeignFieldsForStructure Procedure 
FUNCTION setForeignFieldsForStructure RETURNS LOGICAL
  ( pcForeignFields AS CHARACTER,
    phSDOHandle     AS HANDLE,
    phParentSDO     AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFieldName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cFieldValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cListValue  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCnt        AS INTEGER    NO-UNDO.

  IF NOT VALID-HANDLE(phParentSDO) THEN
    RETURN FALSE.
  IF NOT VALID-HANDLE(phSDOHandle) THEN
    RETURN FALSE.
  IF pcForeignFields = "":U THEN
    RETURN FALSE.
  cListValue = FILL(CHR(1),INT(NUM-ENTRIES(pcForeignFields) / 2)).

  DO iLoop = 2 TO NUM-ENTRIES(pcForeignFields) BY 2:
    iCnt = iCnt + 1.
    cFieldName = ENTRY(iLoop,pcForeignFields).
    IF cFieldName <> "":U THEN
      cFieldValue = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN phParentSDO, cFieldName)).
    ENTRY(iCnt,cListValue,CHR(1)) = cFieldValue.
  END.
  DYNAMIC-FUNCTION("setForeignValues":u IN phSDOhandle,cListValue).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNodeExpanded) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNodeExpanded Procedure 
FUNCTION setNodeExpanded RETURNS LOGICAL
  ( INPUT pcNode         AS CHARACTER,
    INPUT plNodeExpanded AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  This function will set the value of the node expanded flag.
    Notes:  lNodeExpanded will contain a value of TRUE or FALSE.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTable        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuf          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQry          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeExpanded AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lNodeExpanded AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX  AS HANDLE     NO-UNDO.

  hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN TARGET-PROCEDURE).

  {get TreeDataTable hTable hTreeViewOCX}.  
  
  IF NOT VALID-HANDLE(hTable) THEN
    RETURN FALSE.
  
  /* Grab the handles to the individual fields in the tree data table. */
  ASSIGN hBuf          = hTable:DEFAULT-BUFFER-HANDLE
         hNodeExpanded = hBuf:BUFFER-FIELD('node_expanded':U).
  
  CREATE QUERY hQry.  
  hQry:ADD-BUFFER(hBuf).
  hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.node_key = "&2"':U, hTable:NAME,pcNode)).
  hQry:QUERY-OPEN().
  hQry:GET-FIRST().
  
  DO WHILE hBuf:AVAILABLE:
    ASSIGN hNodeExpanded:BUFFER-VALUE = plNodeExpanded
           NO-ERROR.
    LEAVE.
  END.

  IF VALID-HANDLE(hQry) THEN
    DELETE OBJECT hQry.
  
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTemplateObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTemplateObjectName Procedure 
FUNCTION setTemplateObjectName RETURNS LOGICAL
  ( INPUT pcTemplateObjectName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Added as placeholder - this was a new property added and am not to 
            sure what the purpose of the attribute is.
    Notes:  
------------------------------------------------------------------------------*/

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showMessages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION showMessages Procedure 
FUNCTION showMessages RETURNS LOGICAL
  ( INPUT pcMessage AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cButton    AS CHARACTER  NO-UNDO.

  RUN showMessages IN gshSessionManager (INPUT  pcMessage,                      /* message to display */
                                         INPUT  "ERR":U,                        /* error type         */
                                         INPUT  "&OK":U,                        /* button list        */
                                         INPUT  "&OK":U,                        /* default button     */ 
                                         INPUT  "&OK":U,                        /* cancel button      */
                                         INPUT  "'TreeViewController Error'":U, /* error window title */
                                         INPUT  YES,                            /* display if empty   */ 
                                         INPUT  TARGET-PROCEDURE,                 /* container handle   */ 
                                         OUTPUT cButton).                       /* button pressed     */

  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-toLogical) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION toLogical Procedure 
FUNCTION toLogical RETURNS LOGICAL
  ( INPUT pcText AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will return TRUE/FALSE for any logical text 
            YES/NO 1/0 TRUE/FALSE
    Notes:  
------------------------------------------------------------------------------*/

  CASE pcText:
    WHEN "YES" THEN
      RETURN TRUE.
    WHEN "TRUE" THEN
      RETURN TRUE.
    WHEN "1" THEN
      RETURN TRUE.
    WHEN "NO" THEN
      RETURN FALSE.
    WHEN "FALSE" THEN
      RETURN FALSE.
    WHEN "0" THEN
      RETURN FALSE.
    OTHERWISE 
      RETURN FALSE.
  END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

