&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
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
/*------------------------------------------------------------------------
      File      : webrep.p 
    Purpose     : Super procedure that either uses dynamic query and buffers 
                  or a SmartDataObject to query data.                    
                  
    Syntax      : web2/webrep.p 

    Description : The query and buffers used in this procedure is 100% dynamic.                   
    Created     : June 98
    Notes       : initializeObject is NOT called from web Detail and Web Report 
                  because they are stateless and all attributes etc is set 
                  on each request.   
   Modified:      July 22 , 2000 3.1B           
 ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE TEMP-TABLE htm 
 FIELD Name    AS CHAR
 FIELD HtmName AS CHAR
 INDEX Name    AS UNIQUE Name
 INDEX HtmName AS UNIQUE HtmName.

DEFINE VARIABLE gcFile  AS CHAR   NO-UNDO. /* Used to check if temp-table HTM 
                                              should be deleted */

DEFINE VARIABLE ghQuery AS HANDLE NO-UNDO. /* Avoid recreating a new handle 
                                              each time setBuffers is called */ 
 
&SCOPED-DEFINE admsuper webrep.p

/* Maximum number of records in a join (used in fetchRow)*/
&SCOPED-DEFINE MaxJoin 18

{src/web2/custom/webrepexclcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-addContextFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addContextFields Procedure 
FUNCTION addContextFields RETURNS LOGICAL
  (pcNewContextFields AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addSearchCriteria) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addSearchCriteria Procedure 
FUNCTION addSearchCriteria RETURNS LOGICAL
  (pcColumn AS CHAR,  
   pcValue  AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-anyMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD anyMessage Procedure 
FUNCTION anyMessage RETURNS LOGICAL
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnFormat Procedure 
FUNCTION assignColumnFormat RETURNS LOGICAL
  (pcColumn AS CHAR,   
   pcFormat AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnHelp Procedure 
FUNCTION assignColumnHelp RETURNS LOGICAL
  (pcColumn AS CHAR,  
   pcHelp   AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnLabel Procedure 
FUNCTION assignColumnLabel RETURNS LOGICAL
  (pcColumn AS CHAR,  
   pcLabel  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnWidth Procedure 
FUNCTION assignColumnWidth RETURNS LOGICAL
  (pColumn AS CHAR,
   pWidth  AS DEC)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignExtentAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignExtentAttribute Procedure 
FUNCTION assignExtentAttribute RETURNS CHARACTER PRIVATE
  (phHandle    AS HANDLE,  /* */
   piExtent    AS INT,     /*  */
   pcList      AS CHAR,    /* current attribute */
   pcValue     AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD bufferHandle Procedure 
FUNCTION bufferHandle RETURNS HANDLE
  (pcTableName AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnDataType Procedure 
FUNCTION columnDataType RETURNS CHARACTER
  (pColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnFormat Procedure 
FUNCTION columnFormat RETURNS CHARACTER
  (pColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnHandle Procedure 
FUNCTION columnHandle RETURNS HANDLE
  ( pcColumn AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnHelp Procedure 
FUNCTION columnHelp RETURNS CHARACTER
  (pcColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHTMLName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnHTMLName Procedure 
FUNCTION columnHTMLName RETURNS CHARACTER
  (pColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnLabel Procedure 
FUNCTION columnLabel RETURNS CHARACTER
  (pcColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnReadOnly) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnReadOnly Procedure 
FUNCTION columnReadOnly RETURNS LOGICAL
(pColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnStringValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnStringValue Procedure 
FUNCTION columnStringValue RETURNS CHARACTER
  (pcColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyDataObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD destroyDataObject Procedure 
FUNCTION destroyDataObject RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-extentAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD extentAttribute Procedure 
FUNCTION extentAttribute RETURNS CHARACTER PRIVATE
  (piExtent    AS INT,     
   pcList      As CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-extentValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD extentValue Procedure 
FUNCTION extentValue RETURNS INTEGER
  (pcColumn AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAppService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAppService Procedure 
FUNCTION getAppService RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASDivision) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getASDivision Procedure 
FUNCTION getASDivision RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContextFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContextFields Procedure 
FUNCTION getContextFields RETURNS CHARACTER
() FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentRowids) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentRowids Procedure 
FUNCTION getCurrentRowids RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getForeignFieldList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getForeignFieldList Procedure 
FUNCTION getForeignFieldList RETURNS CHARACTER
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNavigationMode Procedure 
FUNCTION getNavigationMode RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryEmpty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryEmpty Procedure 
FUNCTION getQueryEmpty RETURNS LOGICAL
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryWhere Procedure 
FUNCTION getQueryWhere RETURNS CHARACTER
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowids) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowids Procedure 
FUNCTION getRowids RETURNS CHARACTER
() FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSearchColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSearchColumns Procedure 
FUNCTION getSearchColumns RETURNS CHARACTER
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServerConnection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getServerConnection Procedure 
FUNCTION getServerConnection RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableRowids) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTableRowids Procedure 
FUNCTION getTableRowids RETURNS CHARACTER
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTables Procedure 
FUNCTION getTables RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdateMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdateMode Procedure 
FUNCTION getUpdateMode RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HTMLAlert) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD HTMLAlert Procedure 
FUNCTION HTMLAlert RETURNS LOGICAL
  (pMessage AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HTMLSetFocus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD HTMLSetFocus Procedure 
FUNCTION HTMLSetFocus RETURNS LOGICAL
  (pcForm   AS CHAR,
   pcColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-joinExternalTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD joinExternalTables Procedure 
FUNCTION joinExternalTables RETURNS LOGICAL
  (pcTables AS CHAR,
   pcRowids AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-joinForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD joinForeignFields Procedure 
FUNCTION joinForeignFields RETURNS LOGICAL
  (pcObject AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD openQuery Procedure 
FUNCTION openQuery RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeEntry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD removeEntry Procedure 
FUNCTION removeEntry RETURNS CHARACTER PRIVATE
  (pNum       AS INT,
   pList      AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-reopenQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD reopenQuery Procedure 
FUNCTION reopenQuery RETURNS LOGICAL
  () FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowidExpression) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD rowidExpression Procedure 
FUNCTION rowidExpression RETURNS CHARACTER PRIVATE
  (pcBuffer AS CHAR,
   pcRowid  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sessionEnd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD sessionEnd Procedure 
FUNCTION sessionEnd RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAppService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAppService Procedure 
FUNCTION setAppService RETURNS LOGICAL
  (pAppService AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBuffers) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBuffers Procedure 
FUNCTION setBuffers RETURNS LOGICAL
  (pcTables AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setColumns Procedure 
FUNCTION setColumns RETURNS LOGICAL
  ( pColumns AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContextFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setContextFields Procedure 
FUNCTION setContextFields RETURNS LOGICAL
  (pcContextFields AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrentRowids) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCurrentRowids Procedure 
FUNCTION setCurrentRowids RETURNS LOGICAL
  (pcRowids AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setExternalJoinList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setExternalJoinList Procedure 
FUNCTION setExternalJoinList RETURNS LOGICAL
  (pcExternalJoinList AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setExternalTableList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setExternalTableList Procedure 
FUNCTION setExternalTableList RETURNS LOGICAL
  (pcExternalTableList AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setExternalTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setExternalTables Procedure 
FUNCTION setExternalTables RETURNS LOGICAL
  (pExternalTables AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setExternalWhereList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setExternalWhereList Procedure 
FUNCTION setExternalWhereList RETURNS LOGICAL
  (pExternalWhereList AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setForeignFieldList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setForeignFieldList Procedure 
FUNCTION setForeignFieldList RETURNS LOGICAL
  (pcForeignFieldList AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLinkColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLinkColumns Procedure 
FUNCTION setLinkColumns RETURNS LOGICAL
  (pcLinkColumns AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNavigationMode Procedure 
FUNCTION setNavigationMode RETURNS LOGICAL
  (pcMode AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryWhere Procedure 
FUNCTION setQueryWhere RETURNS LOGICAL
  (pWhere AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSearchColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSearchColumns Procedure 
FUNCTION setSearchColumns RETURNS LOGICAL
  (pcSearchColumns AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setServerConnection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setServerConnection Procedure 
FUNCTION setServerConnection RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdateMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUpdateMode Procedure 
FUNCTION setUpdateMode RETURNS LOGICAL
(pcMode AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showDataMessages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD showDataMessages Procedure 
FUNCTION showDataMessages RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startDataObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD startDataObject Procedure 
FUNCTION startDataObject RETURNS LOGICAL
  (pcDataSource AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-urlJoinParams) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD urlJoinParams Procedure 
FUNCTION urlJoinParams RETURNS CHARACTER
  (pcJoin AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-urlLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD urlLink Procedure 
FUNCTION urlLink RETURNS CHARACTER
  (pcWebObject AS CHAR,
   pcJoin      AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateColumnValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD validateColumnValue Procedure 
FUNCTION validateColumnValue RETURNS LOGICAL
  (pcColumn AS CHAR,
   pcValue  AS CHAR) FORWARD.

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
         HEIGHT             = 15.71
         WIDTH              = 59.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/web/method/cgidefs.i}
{src/web2/webrprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:  destroy the object and the datasource if its destroystateless 
            property is true else disconnect if its DisconnectAppserver is true      
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hDataSource AS HANDLE    NO-UNDO.
   DEFINE VARIABLE lDestroy    AS LOGICAL   NO-UNDO.
   DEFINE VARIABLE lDisConnect AS LOGICAL   NO-UNDO.
   DEFINE VARIABLE cAppService AS CHARACTER NO-UNDO.

   {get DataSource hDataSource}.
    
   IF VALID-HANDLE(hDataSource) THEN 
   DO:
     {get DestroyStateless lDestroy hDataSource}.
     IF lDestroy THEN 
       {fn destroyDataObject}.   
       
     ELSE DO: 
       {get AppService cAppservice}. 
       IF cAppservice <> "":U THEN
       DO: 
         {get DisconnectAppServer lDisConnect hDataSource}.
         IF lDisConnect THEN 
         DO:
           RUN disconnectObject IN hDataSource.
           /* Set appservice blank to make sure that startDataObject understands
              that it must initializeObject on the next request */
           cAppService = "":U. 
           {set AppService cAppService hDataSource}.
         END. /* disconnect from Appserver */                
       END. /* Appservice <> '' */ 
     END. /* else - don't destroy SDO */   
   END. /* if valid hdatasource */
   
   DELETE PROCEDURE TARGET-PROCEDURE.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchCurrent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchCurrent Procedure 
PROCEDURE fetchCurrent :
/*------------------------------------------------------------------------------
  Purpose:    Reposition query to the list of rowids stored in the CurrentRowids 
              attribute.    
  Parameters: None  
  Note:       The attribute CurrentRowids is set from the Web Browser in 
              ProcessWebRequest        
------------------------------------------------------------------------------*/
  DEFINE VARIABLE rRowId      AS ROWID EXTENT {&MaxJoin} NO-UNDO.
  DEFINE VARIABLE cRowIdents  AS CHAR                    NO-UNDO.
  DEFINE VARIABLE i           AS INTEGER                 NO-UNDO.
  DEFINE VARIABLE hQuery      AS HANDLE                  NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE                  NO-UNDO.
  
  {get CurrentRowids cRowIdents}.  
  {get DataSource hDataSource}.  
  
  IF cRowidents = "" THEN RETURN. 
      
  IF VALID-HANDLE(hDataSource) THEN 
     DYNAMIC-FUNCTION("fetchRowident":U IN hDataSource,cRowIdents,"":U).
  
  /* If there's no datasource handle we use the internal query */ 
  ELSE 
  DO:
    {get QueryHandle hQuery}.  
    DO i = 1 to NUM-ENTRIES(cRowIdents):  
      ASSIGN 
        rRowid[i] = TO-ROWID(ENTRY(i,cRowIdents)).    
    END.  
    IF rRowid[1] <> ? THEN
    DO:               
      hQuery:REPOSITION-TO-ROWID(rRowid) NO-ERROR. 
      hQuery:GET-NEXT.
    END. 
  END. 
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchFirst) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchFirst Procedure 
PROCEDURE fetchFirst :
/*------------------------------------------------------------------------------
  Purpose: Reposition the database query or DataSource to the first row
  Parameters: None
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery      AS HANDLE NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.
  
  /* If the datasource is a dataobject run fetchFirst in it */             
  {get DataSource hDataSource}.   
  IF VALID-HANDLE(hDataSource) THEN 
    RUN fetchFirst IN hDataSource.
   
  /* else we have a query */             
  ELSE 
  DO:
    {get QueryHandle hQuery}.  
     hQuery:GET-FIRST.      
  END. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchLast) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchLast Procedure 
PROCEDURE fetchLast :
/*------------------------------------------------------------------------------
  Purpose: Reposition the database query or dataobject to the last row.
  Parameters: None
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery      AS HANDLE NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.
  
  /* If the datasource is a dataobject run fetchLast in it */             
  {get DataSource hDataSource}.   
  IF VALID-HANDLE(hDataSource) THEN 
    RUN fetchLast IN hDataSource.
   
  /* else we have a query */             
  ELSE 
  DO:
    {get QueryHandle hQuery}.  
     hQuery:GET-LAST.      
  END. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchNext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchNext Procedure 
PROCEDURE fetchNext :
/*------------------------------------------------------------------------------
  Purpose: Reposition the database query or dataobject to the next row.
  Parameters: None
  Notes:   The context is reset with a call to fetchCurrent    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery      AS HANDLE NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.
  
  /* Fetch the current record received from the Web Browser */ 
  RUN fetchCurrent IN TARGET-PROCEDURE.
  
  /* If the datasource is a dataobject run fetchnext in it */             
  {get DataSource hDataSource}.   
  IF VALID-HANDLE(hDataSource) THEN 
    RUN fetchNext IN hDataSource.
   
  /* else we have a query */             
  ELSE 
  DO:
    {get QueryHandle hQuery}.       
    hQuery:GET-NEXT.           
    IF hQuery:QUERY-OFF-END THEN 
      hQuery:GET-LAST.                    
  END. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchPrev) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchPrev Procedure 
PROCEDURE fetchPrev :
/*------------------------------------------------------------------------------
  Purpose: Reposition the database query or dataobject to the prev row.
  Parameters: None
  Notes:   The context is reset with a call to fetchCurrent          
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery      AS HANDLE NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.
  
  /* Fetch the current record received from the Web Browser */ 
  RUN fetchCurrent IN TARGET-PROCEDURE.
  
  /* If the datasource is a dataobject run fetchprev in it */             
  {get DataSource hDataSource}.   
  IF VALID-HANDLE(hDataSource) THEN 
    RUN fetchPrev IN hDataSource.
   
  /* else we have a query */             
  ELSE 
  DO:
    {get QueryHandle hQuery}.  
     hQuery:GET-PREV.  
     IF hQuery:QUERY-OFF-END THEN 
       hQuery:GET-FIRST.                        
  END. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ProcessWebRequest) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ProcessWebRequest Procedure 
PROCEDURE ProcessWebRequest :
/*------------------------------------------------------------------------------
  Purpose: Process the submitted request from the browser.
           Store values from the Web in Progress attributes       
  Parameters:
  Web data retrieved with get-field:
    - CurrentRowids  - List of the rowids that are currently in use for this 
                       object on the Web. Keeps context in state less mode.   
    - Navigate       - Next,Prev,First,Last,Search 
    - Maintoption    - Add,Delete,Submit 
    - SearchValue    - Use when Navigate = 'Search' 
                       Contains the value of entry 1 of the SearchColumns 
                       attribute (Only one searchfield currently supported)                 
    - ExternalTables - List of table that we will to join to (comma separated) 
    - ExternalRowids - ExternalTables corresponding rowids (comma separated) 
  Notes:        
------------------------------------------------------------------------------*/  
  /* Variables set from get-field */   
  DEFINE VARIABLE Navigate         AS CHAR   NO-UNDO.
  DEFINE VARIABLE MaintOption      AS CHAR   NO-UNDO.
  DEFINE VARIABLE CurrentRowids    AS CHAR   NO-UNDO.
  DEFINE VARIABLE ExternalTables   AS CHAR   NO-UNDO.
  DEFINE VARIABLE ExternalObject   AS CHAR   NO-UNDO.
  DEFINE VARIABLE ExternalRowids   AS CHAR   NO-UNDO.  
  DEFINE VARIABLE SearchValue    AS CHAR   NO-UNDO.
  
  /* Local variables */
  DEFINE VARIABLE hDataSource       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hQuery            AS HANDLE NO-UNDO.  
  DEFINE VARIABLE cSearchColumns    AS CHAR   NO-UNDO.
  DEFINE VARIABLE cSearchColumn     AS CHAR   NO-UNDO.
  DEFINE VARIABLE lQueryOk          AS LOG    NO-UNDO.
  DEFINE VARIABLE lQueryEmpty       AS LOG    NO-UNDO.
  DEFINE VARIABLE lExternalJoin     AS LOG    NO-UNDO.
  DEFINE VARIABLE lSearchError      AS LOG    NO-UNDO.
  DEFINE VARIABLE cPrepareString    AS CHAR   NO-UNDO.
  DEFINE VARIABLE cForeignFieldList AS CHAR   NO-UNDO.
  DEFINE VARIABLE i                 AS INT    NO-UNDO.
 
  ASSIGN
    ExternalTables  = get-field('ExternalTables':U)
    ExternalObject  = get-field('ExternalObject':U)
    Navigate        = get-field('Navigate':U) 
    MaintOption     = get-field('MaintOption':U). 
    SearchValue     = get-Field('SearchValue':U).     
  
  {set UpdateMode Maintoption}.
  {get ForeignFieldList cForeignFieldList}.
  {get DataSource hDataSource}.    
  
  IF ExternalTables <> "" THEN 
    DYNAMIC-FUNCTION("addContextFields":U IN TARGET-PROCEDURE,
                     "BackRowids":U).
                 
  IF cForeignFieldList <> "":U THEN
  DO:
    /* First check if ForeignFields is defined for the ExternalObject */
    IF ExternalObject <> "":U THEN 
    DO:
      lExternalJoin = DYNAMIC-FUNCTION("joinForeignFields":U IN TARGET-PROCEDURE,
                                        ExternalObject).
                                        
      /* If Externalobject was used to join add to the URL as a context keeper */ 
      IF lExternalJoin THEN 
        DYNAMIC-FUNCTION("addContextFields":U IN TARGET-PROCEDURE,
                         "ExternalObject":U).
    END. 
    /* If not joined above, check if Foreignfields exists for ExternalTables */
    IF NOT lExternalJoin
    AND ExternalTables <> "":U THEN
    DO:
      lExternalJoin = DYNAMIC-FUNCTION("joinForeignFields":U IN TARGET-PROCEDURE,
                                        ExternalTables).
      /* If ExternalTables was used to join add to the URL as a context keeper */ 
      IF lExternalJoin THEN 
        DYNAMIC-FUNCTION("addContextFields":U IN TARGET-PROCEDURE,
                         "ExternalTables":U).    
    END.
  END. /* cforeignfieldList <> '' */
     
  /* Join external tables if ExternalRowids is part of the request */  
  IF NOT lExternalJoin AND NOT VALID-HANDLE(hDataSource) THEN 
  DO: 
   {get QueryHandle hQuery}.            
   
    ExternalRowids = get-field("ExternalRowids":U).    
    IF ExternalRowids <> "" THEN
    DO:
       DYNAMIC-FUNCTION("joinExternalTables":U IN TARGET-PROCEDURE,
                         ExternalTables,ExternalRowids).       
       
       DYNAMIC-FUNCTION("addContextFields":U IN TARGET-PROCEDURE,
                        "ExternalObject,ExternalRowids,ExternalTables":U).
    END. /* if externalRowids <> '' */  
  END. /* if not lexternalJoin and not valid-handle(hDataSource) */
  
 
  /* Search for a field value */ 
  IF Navigate = 'Search':U THEN
  DO:     
    IF VALID-HANDLE(hQuery) THEN 
    DO:
      ASSIGN cPrepareString = hQuery:PREPARE-STRING.     
      {set OpenQuery cPrepareString}. 
    END. 
     
    {get SearchColumns cSearchColumns}.              
    
    cSearchColumn = ENTRY(1,cSearchColumns).                                
    
    /* Check if the searchcolumn and value is matching data-types,
       set Navigate to '' if not */    
    IF NOT DYNAMIC-FUNCTION('ValidateColumnValue' IN TARGET-PROCEDURE, 
                            cSearchColumn,SearchValue) THEN
      Navigate = "":U.                        .
    
    /* If the previous check was ok we add the searchcolumn to the 
       selection criteria in the query */  
    IF Navigate = 'Search':U THEN
       DYNAMIC-FUNCTION('addSearchCriteria' IN TARGET-PROCEDURE, 
                         cSearchColumn,SearchValue).
  END. /* if Navigate = 'Search' */   

  lQueryOk = {fn openQuery}.
  
  IF NOT lQueryOk THEN RETURN.  /* --------------------> */
  
  {get QueryEmpty lQueryEmpty}.  
  
  /* Empty query on search is reopened further down */
  IF lQueryEmpty AND Navigate <> "Search":U THEN 
    RETURN.   /* --------------------> */
  
  /* Store the context received from the web */  
  CurrentRowids = get-field("CurrentRowids":U).   
  {set CurrentRowids CurrentRowids}.
  
  CASE Navigate:    
    WHEN "First":U THEN
      RUN fetchFirst IN TARGET-PROCEDURE.
    WHEN "Next":U THEN
      RUN fetchNext IN TARGET-PROCEDURE.
    WHEN "Prev":U THEN
      RUN fetchPrev IN TARGET-PROCEDURE.
    WHEN "Last":U THEN
      RUN fetchLast IN TARGET-PROCEDURE.
      
    /* Note that navigate is set to blank above if searchfields and searchvalues 
       are incompatible */
    WHEN "Search":U THEN
    DO:    
      /* If no records was found by the search, reset the query and
         refind the current record */  
      IF DYNAMIC-FUNCTION('getQueryEmpty' IN TARGET-PROCEDURE) THEN
      DO:
        RUN AddMessage IN TARGET-PROCEDURE 
               ('No records found meeting search criteria.',?,?).        
        
        IF NOT {fn reopenQuery} THEN RETURN.
        
        RUN fetchCurrent IN TARGET-PROCEDURE.                       
      END. /* if query is empty */ 
    END. /* When 'search' */ 
    OTHERWISE
      RUN fetchCurrent IN TARGET-PROCEDURE.           
    
  END CASE. /* Navigate */
               
  CurrentRowids = DYNAMIC-FUNCTION("getRowids":U IN TARGET-PROCEDURE).
    
  IF CurrentRowids <> ? THEN
    {set CurrentRowids CurrentRowids}.
                     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-addContextFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addContextFields Procedure 
FUNCTION addContextFields RETURNS LOGICAL
  (pcNewContextFields AS CHAR):
/*------------------------------------------------------------------------------
   Purpose: Add fields to the list of fields that are used to keep context for 
            the next request.  
Parameters: 
  INPUT pcNewContextFields - List of new URL parameters to add to the list.
             
     Notes: The Property should be used whenever the HTML page need to store the 
            context. 
            The Embedded SpeedScript templates already does this on all the URLs
            that is generated.           
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cContextFields AS CHAR NO-UNDO.
 DEFINE VARIABLE cField         AS CHAR NO-UNDO.
 DEFINE VARIABLE i              AS INT  NO-UNDO.
 
 {get ContextFields cContextFields}.
 
 /* Add the new fields one by one to ensure that a field not is added twice */  
 DO i = 1 TO NUM-ENTRIES(pcNewContextFields):
   cField = ENTRY(i,pcNewContextFields).
   IF LOOKUP(cField,cContextFields) = 0 THEN
      ASSIGN cContextFields = cContextFields
                              + (IF cContextFields = "":U THEN "":U ELSE ",":U)
                              + cField.  
 END. /* do i = 1 to */
 
 {set ContextFields cContextFields}. 
 RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addSearchCriteria) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addSearchCriteria Procedure 
FUNCTION addSearchCriteria RETURNS LOGICAL
  (pcColumn AS CHAR,  
   pcValue  AS CHAR): 
/*--------------------------------------------------------------------------------
   Purpose: Add SearchName and SearchValue to the data-source query.   
Parameters:
 INPUT pcColumn - The Column's name in hte data-source 
 INPUT pcValue  - Search value    
     Notes:    
------------------------------------------------------------------------------*/ 
  DEFINE VARIABLE hDataSource    AS HANDLE NO-UNDO.
  DEFINE VARIABLE hBuff          AS HANDLE NO-UNDO.
  DEFINE VARIABLE hField         AS HANDLE NO-UNDO.
  DEFINE VARIABLE cWhere         AS CHAR   NO-UNDO.
  DEFINE VARIABLE cTableWhere    AS CHAR   NO-UNDO.
  DEFINE VARIABLE cSort          AS CHAR   NO-UNDO.
  DEFINE VARIABLE cCheckSort     AS CHAR   NO-UNDO.
  DEFINE VARIABLE iByPos         AS INT    NO-UNDO. 
  DEFINE VARIABLE iFldSortPos    AS INT    NO-UNDO. 
  DEFINE VARIABLE i              AS INT    NO-UNDO.
  DEFINE VARIABLE j              AS INT    NO-UNDO.
  DEFINE VARIABLE cTableName     AS CHAR   NO-UNDO.
  DEFINE VARIABLE cFieldName     AS CHAR   NO-UNDO.
  DEFINE VARIABLE lDescending    AS LOG    NO-UNDO.
  DEFINE VARIABLE cOperator      AS CHAR   NO-UNDO.
  DEFINE VARIABLE cDataType      AS CHAR   NO-UNDO.
  DEFINE VARIABLE hProc          AS HANDLE NO-UNDO.
     
  DEFINE VARIABLE cAddExpression  AS CHAR NO-UNDO. 
  DEFINE VARIABLE cNewWhereCLause AS CHAR NO-UNDO.
    
  {get DataSource hDataSource}. 
  
  {get QueryString cWhere}. 
    
  ASSIGN
    iByPos      = INDEX(cWhere," BY ":U)
    cSort       = (IF iByPos > 0 THEN SUBSTR(cWhere,iByPos + 1) ELSE "":U)  
    iFldSortPos = INDEX(cSort,pcColumn)
    lDescending = (IF iFldSortPos > 0 THEN 
                   TRIM(SUBSTR(cSort,iFldSortPos + LENGTH(pcColumn))) 
                                                 BEGINS "DESCENDING ":U
                   ELSE FALSE)             
     
     pcColumn   = (IF VALID-HANDLE(hDataSource) 
                   THEN "RowObject." + pcColumn
                   ELSE pcColumn)
                   
     hProc      = (IF VALID-HANDLE(hDataSource) 
                   THEN hDataSource
                   ELSE TARGET-PROCEDURE).
              
  RETURN DYNAMIC-FUNCTION("assignQuerySelection":U IN hProc, 
                           pcColumn,
                           pcValue, 
                           IF lDescending THEN "LE":U ELSE "GE":U).
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-anyMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION anyMessage Procedure 
FUNCTION anyMessage RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose: Check if there are any messages in the message queue.
    Notes: If it returns TRUE something has generated an error and a corresponding 
           message.
           If we the data-source we check BOTH there and internally, because 
           WEbSpeed specific errors are always stored internally.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.
  DEFINE VARIABLE lAny        AS LOG    NO-UNDO.
    
  {get DataSource hDataSource}.
  
  IF VALID-HANDLE(hDataSource) THEN
  DO:
    lAny = DYNAMIC-FUNCTION('anyMessage':U IN hDataSource).
    IF NOT lAny THEN SUPER(). 
  END. /* if valid data-source */
  ELSE lAny = SUPER().       

  RETURN lAny.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnFormat Procedure 
FUNCTION assignColumnFormat RETURNS LOGICAL
  (pcColumn AS CHAR,   
   pcFormat AS CHAR) : 
/*------------------------------------------------------------------------------
   Purpose: Set a columns format. 
Parameters:
  INPUT pcColumn - The Column's name in the data-source 
  INPUT pcFormat - The new format.
     Notes: Currently this is NOT a local override when a SmartDataObject is used, 
            unless of course the SmartDataObject is destroyed on each request.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE ColumnHdl   AS HANDLE NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.
  
  {get DataSource hDataSource}.
  
  IF VALID-HANDLE(hDataSource) THEN 
    DYNAMIC-FUNCTION('assignColumnFormat' IN hDataSource, pcColumn, pcFormat).
  
  ELSE DO:
    ASSIGN 
      ColumnHdl        = DYNAMIC-FUNCTION('ColumnHandle' IN TARGET-PROCEDURE,
                                           pcColumn)
      ColumnHdl:FORMAT = pcFormat.
  END.  
  
  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnHelp Procedure 
FUNCTION assignColumnHelp RETURNS LOGICAL
  (pcColumn AS CHAR,  
   pcHelp   AS CHAR) :  
/*------------------------------------------------------------------------------
   Purpose: Override default HELP   
Parameters: 
        INPUT pcColumn - The Column's name in the data-source 
        INPUT pcHelp   - The new help text.
     Notes: Currently this is NOT a local override when a SmartDataObject is used, 
            unless of course the SmartDataObject is destroyed on each request.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hColumn     AS HANDLE NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.
  DEFINE VARIABLE iExt        AS INT    NO-UNDO.
  
  {get DataSource hDataSource}.
  
  IF VALID-HANDLE(hDataSource) THEN 
    DYNAMIC-FUNCTION('assignColumnHelp' IN hDataSource, pcColumn, pcHelp).
  
  ELSE DO:
    ASSIGN 
      hColumn       = DYNAMIC-FUNCTION('ColumnHandle':U IN TARGET-PROCEDURE,
                      pcColumn)
      hColumn:HELP = assignExtentAttribute(hColumn,
                                           extentValue(pcColumn),
                                           hColumn:HELP,
                                           pcHelp).


  END. /* not a valid DataSource */ 
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnLabel Procedure 
FUNCTION assignColumnLabel RETURNS LOGICAL
  (pcColumn AS CHAR,  
   pcLabel  AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Override the default label.   
Parameters: INPUT pcColumn - The Column's name in the data-source 
            INPUT pcLabel  - The new label.
     Notes: Currently this is NOT a local override when a SmartDataObject is used, 
            unless of course the SmartDataObject is destroyed on each request.              
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hColumn     AS HANDLE NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.
  
  {get DataSource hDataSource}.
  
  IF VALID-HANDLE(hDataSource) THEN 
    DYNAMIC-FUNCTION('assignColumnLabel' IN hDataSource, pcColumn, pcLabel).
  
  ELSE 
    ASSIGN 
      hColumn       = DYNAMIC-FUNCTION('ColumnHandle' IN TARGET-PROCEDURE,
                      pcColumn)     
      hColumn:LABEL = assignExtentAttribute(hColumn,
                                      extentValue(pcColumn),
                                      hColumn:LABEL,
                                      pcLabel).

  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnWidth Procedure 
FUNCTION assignColumnWidth RETURNS LOGICAL
  (pColumn AS CHAR,
   pWidth  AS DEC) :
/*------------------------------------------------------------------------------
  Purpose: Not in use 
    Notes:  
------------------------------------------------------------------------------*/

  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignExtentAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignExtentAttribute Procedure 
FUNCTION assignExtentAttribute RETURNS CHARACTER PRIVATE
  (phHandle    AS HANDLE,  /* */
   piExtent    AS INT,     /*  */
   pcList      AS CHAR,    /* current attribute */
   pcValue     AS CHAR):   /* Attribute for the extent */
/*------------------------------------------------------------------------------
   Purpose: Enable the user to override field attributes for columns with extents.  
Parameters: INPUT pcHandle - Buffer-field handle   
            INPUT piExtent - Extent
            INPUT pcList   - The columns attribute,which is used to store ALL 
                             entries if there are differences.
            INPUT pcValue  - The new value     
     Notes: The buffer handle stores one value for help, label and width, this is 
            used to be able to have different attributes for each extent.   
            Curently used for HELP and LABEL. 
            The function is currently private. 
            This must change if we need it for valexp in wbdata.p  
------------------------------------------------------------------------------*/
  IF piExtent = 0 THEN 
    RETURN pcValue.
  
  /* Add separators and current value as default if this is the first */ 
  IF NUM-ENTRIES(pcList,CHR(3)) < 2 THEN
    ASSIGN
      pcList = FILL(pcList + CHR(3), phHandle:EXTENT)
      pcList = RIGHT-TRIM(pcList,CHR(3)).
  
  ENTRY(piExtent,pcList,CHR(3)) = pcValue.
  
  RETURN pcList.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION bufferHandle Procedure 
FUNCTION bufferHandle RETURNS HANDLE
  (pcTableName AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose: Get the handle of a buffer by name.
Parameters: INPUT pcTableName - The name of a table in the query.   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBufferHandles AS CHAR NO-UNDO.
  DEFINE VARIABLE cDbName        AS CHAR    NO-UNDO.
  DEFINE VARIABLE hBuffer        AS HANDLE  NO-UNDO.
  DEFINE VARIABLE i              AS INTEGER NO-UNDO.
  
  {get BufferHandles cBufferHandles}.
  
  IF NUM-ENTRIES(pcTableName,".":U) = 2 THEN
    ASSIGN 
      cDBName     = ENTRY(1,pcTableName,".":U)
      pcTableName = ENTRY(2,pcTableName,".":U).
         
  DO i = 1 TO NUM-ENTRIES(cBufferHandles):
    hBuffer = WIDGET-HANDLE(ENTRY(i,cBufferHandles)).   
        
    IF VALID-HANDLE(hBuffer) /* 9.0B 99-02-02-009 */
    AND (cDbName = "":U OR hBuffer:DBNAME = cDBName)  
    AND hBuffer:TABLE = pcTableName THEN       
      RETURN hBuffer. 
  END.
  
  RETURN ?.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnDataType Procedure 
FUNCTION columnDataType RETURNS CHARACTER
  (pColumn AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Return a columns datatype from the data-source.  
Parameters: INPUT pcColumn - The Column's name in the data-source 
     Notes:  
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE ColumnHdl   AS HANDLE NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.
  
  {get DataSource hDataSource}.
  
  IF VALID-HANDLE(hDataSource) THEN 
    RETURN DYNAMIC-FUNCTION('columnDataType' IN hDataSource, pColumn).
  
  ELSE DO:
    ASSIGN 
      ColumnHdl = DYNAMIC-FUNCTION('ColumnHandle' IN TARGET-PROCEDURE,pColumn).
  
    RETURN ColumnHdl:DATA-TYPE.
  END.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnFormat Procedure 
FUNCTION columnFormat RETURNS CHARACTER
  (pColumn AS CHAR) :  
/*------------------------------------------------------------------------------
   Purpose: Return a columns format from the data-source  
Parameters: INPUT pcColumn - The Column's name in the data-source 
     Notes:  
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE ColumnHdl   AS HANDLE NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.
  
  {get DataSource hDataSource}.
  
  IF VALID-HANDLE(hDataSource) THEN 
    RETURN DYNAMIC-FUNCTION('ColumnFormat' IN hDataSource, pColumn).
  
  ELSE DO:
    ASSIGN 
      ColumnHdl = DYNAMIC-FUNCTION('ColumnHandle' IN TARGET-PROCEDURE,pColumn).
  
    RETURN ColumnHdl:FORMAT.
  END.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnHandle Procedure 
FUNCTION columnHandle RETURNS HANDLE
  ( pcColumn AS CHAR ) :
/*------------------------------------------------------------------------------
   Purpose: Return the column handle   
Parameters: INPUT pcColumn - The column's name in the data-source.  
     Notes: Returns the SDO's columnHandle or the query's dbColumnHandle.  
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.
  
  {get DataSource hDataSource}.
  
  IF VALID-HANDLE(hDataSource) THEN 
    RETURN DYNAMIC-FUNCTION('columnHandle':U IN hDataSource, pcColumn).
  
  ELSE 
    RETURN DYNAMIC-FUNCTION('dbColumnHandle':U IN TARGET-PROCEDURE, pcColumn).
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnHelp Procedure 
FUNCTION columnHelp RETURNS CHARACTER
  (pcColumn AS CHAR) : 
/*------------------------------------------------------------------------------
   Purpose: Return a columns help text from the data-source.   
Parameters: INPUT pcColumn - The Column's name in the data-source.
     Notes:  
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE hColumn     AS HANDLE NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.
  
  {get DataSource hDataSource}.
  
  IF VALID-HANDLE(hDataSource) THEN 
    RETURN DYNAMIC-FUNCTION('columnHelp' IN hDataSource, pcColumn).
  
  ELSE DO:
    ASSIGN 
     hColumn = DYNAMIC-FUNCTION('columnHandle':U IN TARGET-PROCEDURE,pcColumn).
  
    RETURN extentAttribute(extentValue(pcColumn),hColumn:HELP).
  END.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHTMLName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnHTMLName Procedure 
FUNCTION columnHTMLName RETURNS CHARACTER
  (pColumn AS CHAR) : 
/*------------------------------------------------------------------------------
   Purpose: Returs a unique valid HTML identifier / name for the column   
Parameters: INPUT pcColumn - The Column's name in the data-source.           
     Notes: Replaces . and - in field name so it can be used as valid HTML 
           objects. JavaScript cannot operate on objects with dashes or periods 
           in the name. 
------------------------------------------------------------------------------*/
  DEFINE BUFFER Htm2 FOR HTM. 
  
  DEFINE VARIABLE cField AS CHAR        NO-UNDO.
  DEFINE VARIABLE iNum   AS INT  INIT 1 NO-UNDO.
 
  /* Clean up the htm file if a different object is target-procedure */
  IF gcFile <> TARGET-PROCEDURE:FILE-NAME THEN
  DO:
    FOR EACH HTM:
      DELETE HTM.
    END.
  END.
  
  gcFile = TARGET-PROCEDURE:FILE-NAME.

  FIND Htm WHERE Htm.Name = pColumn NO-ERROR.
  
  IF AVAIL Htm THEN
    cField = Htm.HtmName.
  
  ELSE 
  DO:
    ASSIGN
      cField = REPLACE(pColumn,".":U,"_":U)
      cField = REPLACE(cField,"-":U,"":U).     
    
    /* The replace of periods and removal of dashes may cause a name conflict.
       Add numbers until its solved */
       
    DO WHILE TRUE:
      
      IF NOT CAN-FIND(FIRST htm2 WHERE htm2.HtmName = cField) THEN LEAVE.
        
      ASSIGN
        iNum   = iNum + 1
        cField = cField + STRING(iNum). 
    END.
    
    CREATE Htm.
    ASSIGN 
      Htm.Name    = pColumn
      htm.HtmName = cField.   
  END.  
  
  RETURN cField.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnLabel Procedure 
FUNCTION columnLabel RETURNS CHARACTER
  (pcColumn AS CHAR) : 
/*------------------------------------------------------------------------------
   Purpose: Return the Columns Label 
Parameters: INPUT pcColumn - The Column's name in the data-source.  
     Notes:  
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE hColumn     AS HANDLE NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.
  
  {get DataSource hDataSource}.
  
  IF VALID-HANDLE(hDataSource) THEN 
    RETURN DYNAMIC-FUNCTION('ColumnLabel':U IN hDataSource, pcColumn).
  
  ELSE DO:
    ASSIGN 
      hColumn = DYNAMIC-FUNCTION('ColumnHandle':U IN TARGET-PROCEDURE,pcColumn).
  
    RETURN extentAttribute(extentValue(pcColumn),hColumn:LABEL).
  END.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnReadOnly) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnReadOnly Procedure 
FUNCTION columnReadOnly RETURNS LOGICAL
(pColumn AS CHAR) : 
/*------------------------------------------------------------------------------
   Purpose: Return true if the column is non updatable.
Parameters: INPUT pcColumn - The Column's name in the data-source.   
     Notes:  
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE ColumnHdl   AS HANDLE NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.
  
  {get DataSource hDataSource}.
  
  IF VALID-HANDLE(hDataSource) THEN 
    RETURN DYNAMIC-FUNCTION('ColumnReadOnly' IN hDataSource, pColumn).  
  ELSE 
    RETURN FALSE.
   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnStringValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnStringValue Procedure 
FUNCTION columnStringValue RETURNS CHARACTER
  (pcColumn AS CHAR) : /* Column name */ 
/*------------------------------------------------------------------------------
   Purpose: Return the character value of the column.  
Parameters: INPUT pcColumn - The Column's name in the data-source.  
     Notes: The attribute Updatemode is used to distinguish between existing 
            data or default data for a NEW record.   
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE hColumn     AS HANDLE NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.  
  DEFINE VARIABLE cUpdateMode AS CHAR   NO-UNDO.
  DEFINE VARIABLE cValue      AS CHAR   NO-UNDO.  
  DEFINE VARIABLE iExtent     AS INT    NO-UNDO.  
    
  {get UpdateMode cUpdateMode}.
  
  {get DataSource hDataSource}.
  
  IF VALID-HANDLE(hDataSource) THEN 
  DO:
   IF cUpdateMode = 'ADD':U THEN
     cValue = DYNAMIC-FUNCTION('columnInitial':U IN hDataSource,pcColumn).
   ELSE 
     cValue = DYNAMIC-FUNCTION('columnStringValue':U IN hDataSource,pcColumn).
  END. /* if valid-handle(hDataSource) */
  ELSE DO:
    ASSIGN 
      hColumn = DYNAMIC-FUNCTION('columnHandle':U IN TARGET-PROCEDURE, pcColumn).
   
    IF cUpdateMode = 'ADD':U THEN
      cValue  = hColumn:INITIAL.
    ELSE 
      cValue  = hColumn:STRING-VALUE(extentValue(pcColumn)) NO-ERROR.
  END. /* else (not valid-handle(hdatasource)) */
  
  RETURN TRIM(cValue). /* 99-01-12-019 */  
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyDataObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION destroyDataObject Procedure 
FUNCTION destroyDataObject RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Shut down the current dataobject.  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.
  {get DataSource hDataSource}.
  IF VALID-HANDLE(hDataSource) THEN
    RUN destroyObject in hDataSource.
  RETURN NOT VALID-HANDLE(hDataSource).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-extentAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION extentAttribute Procedure 
FUNCTION extentAttribute RETURNS CHARACTER PRIVATE
  (piExtent    AS INT,     
   pcList      As CHAR):    
/*------------------------------------------------------------------------------
  Purpose: Return attribute for a variable with extent.  
Parameters: INPUT piExtent - Extent
            INPUT  pcList  - The columns attribute, which is used to store ALL 
                            entries if anyone is different.
            
    Notes: The buffer handle stores one value for help, label etc..
           To be able to have different attributes for each extent we store them 
           with delimiter CHR(3). 
           Used for LABEL and HELP.
           Currently private. This must change if it's needed for ValExp
------------------------------------------------------------------------------*/ 
        
  IF piExtent = 0 OR NUM-ENTRIES(pcList,CHR(3)) < 2 THEN
    RETURN pcList.  
  ELSE 
    RETURN ENTRY(piExtent,pcList,CHR(3)).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-extentValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION extentValue Procedure 
FUNCTION extentValue RETURNS INTEGER
  (pcColumn AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Return the extent number if a fieldname has brackets.   
Parameter: INPUT pcColumn - The Column's name in the data-source.   
    Notes: Returns 0 if no brackets in the name.  
------------------------------------------------------------------------------*/
  RETURN  IF R-INDEX(pcColumn,'[':U) = 0 
          THEN 0  
          ELSE INT(SUBSTR
                   (RIGHT-TRIM(pcColumn,']':U),
                    R-INDEX(pcColumn,'[':U) + 1                    
                   )
                  ).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAppService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAppService Procedure 
FUNCTION getAppService RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return the stored AppService   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAppService AS CHAR NO-UNDO.
   
  {get AppService cAppService}.
  RETURN cAppService.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASDivision) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getASDivision Procedure 
FUNCTION getASDivision RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Override in order to return blank if the webreport does not inherit 
           from the appserver class.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAsDivision AS CHARACTER  NO-UNDO.
  
  /* Call super with no-error since the appserver class is added conditionally*/
  cAsDivision = SUPER() NO-ERROR.

  IF NOT ERROR-STATUS:ERROR THEN
    RETURN cAsDivision. 
  ELSE 
    RETURN "":U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContextFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContextFields Procedure 
FUNCTION getContextFields RETURNS CHARACTER
():
/*------------------------------------------------------------------------------
  Purpose: Return the list of fields that are needed to keep context for the
           next request.   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContextFields AS CHAR NO-UNDO.
  {get ContextFields cContextFields}.
  RETURN cContextFields.   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentRowids) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentRowids Procedure 
FUNCTION getCurrentRowids RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the String of rowids   
           The rowids are stored in this attribute from the Web Browser and 
           requested in fetchCurrent. 
           We also set this attribute after we have navigated, so it can be 
           requested and stored in the Web Page to keep context for the next 
           request. 
    Notes: Note that rowids for the external tables also are stored. 
           getTableRowids will return the rowids for the queries original tables.           
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCurrentRowids AS CHAR NO-UNDO.
  {get CurrentRowids cCurrentRowids}.
  RETURN cCurrentRowids. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getForeignFieldList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getForeignFieldList Procedure 
FUNCTION getForeignFieldList RETURNS CHARACTER
  () :
/*------------------------------------------------------------------------------
  Purpose: Retrieve the alternative list of foreign fields corresponding to the 
           ExternalTableList.   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cForeignFieldList AS CHAR NO-UNDO.
  {get ForeignFieldList cForeignFieldList}.
  RETURN cForeignFieldList.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNavigationMode Procedure 
FUNCTION getNavigationMode RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return the current navigation mode. 
    Notes: NOT USED
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMode AS CHAR NO-UNDO.
  
  {get NavigationMode cMode}.    
  RETURN cMode. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryEmpty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryEmpty Procedure 
FUNCTION getQueryEmpty RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose: Check if the datasource or query is empty  
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hDataSource    AS HANDLE NO-UNDO.
   DEFINE VARIABLE hQuery         AS HANDLE NO-UNDO.
   DEFINE VARIABLE cQueryPosition AS CHAR   NO-UNDO.
   DEFINE VARIABLE lEmpty         AS LOG    NO-UNDO.

   {get DataSource hDataSource}.
   
   IF VALID-HANDLE(hDataSource) THEN
   DO:
     {get QueryPosition cQueryPosition hDataSource}. 
     lEmpty = (cQueryPosition EQ "NoRecordAvailable":U).  
   END. /* valid-handle(hDataSource) */
   ELSE DO:
     {get QueryHandle hQuery}.
     lEmpty = hQuery:QUERY-OFF-END.
   END. /* else ie: not valid-handle(hDataSource) */
   
   RETURN lEmpty.
   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryWhere Procedure 
FUNCTION getQueryWhere RETURNS CHARACTER
  () :
/*------------------------------------------------------------------------------
  Purpose: Get the current where clause for the query. 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource AS HANDLE.
  {get DataSource hDataSource}.
  
  IF VALID-HANDLE(hDataSource) THEN 
    RETURN DYNAMIC-FUNCTION('getQueryWhere':U in hDataSource).
  ELSE      
    RETURN SUPER().  
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowids) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowids Procedure 
FUNCTION getRowids RETURNS CHARACTER
():
/*------------------------------------------------------------------------------
  Purpose: Get the rowids of the current row.   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i           AS INTEGER NO-UNDO.
  DEFINE VARIABLE hBuf        AS HANDLE  NO-UNDO.
  DEFINE VARIABLE cList       AS CHAR    NO-UNDO.
  DEFINE VARIABLE hQuery      AS HANDLE NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.
 
  {get DataSource hDataSource}.
  
  IF VALID-HANDLE(hDataSource) THEN 
  DO:
   ASSIGN 
     cList = ENTRY(1,DYNAMIC-FUNCTION("colValues":U IN hDataSource,"":U),chr(1))
     /* Remove RowObject ROWID */
     ENTRY(1,cList) = "":U
     cList = LEFT-TRIM(cList,",":U). 
  END.
  ELSE 
  DO:
    {get QueryHandle hQuery}.
    DO i = 1 TO hQuery:NUM-BUFFERS:    
      ASSIGN
        hBuf  = hQuery:GET-BUFFER-HANDLE(i)
        cList = cList 
                + (IF cList = "":U THEN "":U ELSE  ",":U)
                + IF hBuf:AVAIL THEN STRING(hBuf:ROWID) ELSE "?":U.
    END. /* do i = 1 to num queries */    
  END.
  
  RETURN cList.   /* Function return value. */
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSearchColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSearchColumns Procedure 
FUNCTION getSearchColumns RETURNS CHARACTER
  () :
/*------------------------------------------------------------------------------
  Purpose: Return searchcolumns (Currently one)  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSearchColumns AS CHAR NO-UNDO.
  
  {get searchColumns cSearchColumns}.
  
  RETURN cSearchColumns.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServerConnection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getServerConnection Procedure 
FUNCTION getServerConnection RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns SESSION:SERVER-CONNECTION-ID via ServerConnection property
  Returns:    (CHAR) 
  Parameters: <none>
  Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cServerConnection AS CHARACTER NO-UNDO.
  
  {get ServerConnection cServerConnection}.
  
  RETURN cServerConnection.
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableRowids) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTableRowids Procedure 
FUNCTION getTableRowids RETURNS CHARACTER
  () :
/*------------------------------------------------------------------------------
  Purpose: Return the rowid of the the defined tables and remove the external 
           ones. 
    Notes: Used to pass as externalrowids to a called object. 
-------------------------------------------------------------------------*/     
  DEFINE VARIABLE cTableRowids    AS CHAR NO-UNDO. 
  DEFINE VARIABLE cExternaltables AS CHAR NO-UNDO.
  DEFINE VARIABLE i               AS INT  NO-UNDO.
    
  ASSIGN cTableRowids = DYNAMIC-FUNCTION('getRowids' IN TARGET-PROCEDURE).
  {get ExternalTables cExternalTables}.  
    
  /* Remove external table rowids */     
  DO i = 1 TO NUM-ENTRIES(cExternalTables):    
    ASSIGN
     cTableRowids = removeEntry(1,cTableRowids).
  END.
    
  RETURN cTableRowids. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTables Procedure 
FUNCTION getTables RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return the tables of the object  
    Notes: If datasource  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource     AS HANDLE NO-UNDO.
  DEFINE VARIABLE cTables         AS CHAR   NO-UNDO.
  DEFINE VARIABLE cExternalTables AS CHAR   NO-UNDO.
  DEFINE VARIABLE i               AS INT    NO-UNDO.

  {get DataSource hDataSource}.
  IF VALID-HANDLE(hDataSource) THEN 
  DO:
    {get Tables cTables hDataSource}.
  END.
  ELSE
  DO: 
    cTables = SUPER().    
    
    /* Remove external tables */     
    {get ExternalTables cExternalTables}.  
    DO i = 1 TO NUM-ENTRIES(cExternalTables):    
      ASSIGN
        ENTRY(1,cTables) = "":U
        cTables = LEFT-TRIM(cTables,",":U).               
    END.    
  END.
    
  RETURN cTables. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdateMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdateMode Procedure 
FUNCTION getUpdateMode RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMode AS CHAR NO-UNDO.
  
  {get UpdateMode cMode}.    
  RETURN cMode. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HTMLAlert) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION HTMLAlert Procedure 
FUNCTION HTMLAlert RETURNS LOGICAL
  (pMessage AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Generate an alert-box in the HTML.  
Parameters: INPUT pcMessage - The message to display  
    Notes: The message is gnerated with JavaScript 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iQuotePos AS INT NO-UNDO. 
  DEFINE VARIABLE cDblQuote AS CHAR INIT "~"" NO-UNDO.   
  DEFINE VARIABLE cSglQuote AS CHAR INIT "'" NO-UNDO.   
  
  iQuotePos = INDEX(pMessage,cDblQuote). 
  /* someomne said replace is to slow on large strings ??*/ 
  DO WHILE iQuotePos > 0:
    SUBSTR(pMessage,iQuotePos,1) = cSglQuote. 
    iQuotePos = INDEX(pMessage,cDblQuote). 
  END.
  
  {&OUT}
    '~<script language="JavaScript"~>~n'
    'window.alert("~\n' + 
    (IF pMessage = ? THEN '' 
     ELSE pMessage) 
     + '");~n'
    '~</script~>~n'.
   
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HTMLSetFocus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION HTMLSetFocus Procedure 
FUNCTION HTMLSetFocus RETURNS LOGICAL
  (pcForm   AS CHAR,
   pcColumn AS CHAR) :
/*------------------------------------------------------------------------------
    Purpose: Set focus to a field in a WebPage.
 Parameters: INPUT pcForm   - The NAME of the HTML form of the field.
             INPUT pcColumn - Progress column name 
      Notes: The generated code is JavaScript. 
             The columnHTMLName function returns a valid HTML fieldname for 
             the passed Column. 
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cHTMLName AS CHAR NO-UNDO.
   
   IF pcColumn = '':U OR pcColumn = ? THEN
     RETURN FALSE.
   
   ASSIGN 
     cHTMLName = DYNAMIC-FUNCTION('columnHTMLName':U IN TARGET-PROCEDURE, 
                                   pcColumn).

   IF cHTMLName = "" THEN
     RETURN FALSE.
           
   {&OUT} '<script language="JavaScript">~n':U.
   {&OUT} '    ':U 
       pcForm + '.':U + cHTMLName + '.focus()~;~n'      
          '    ':U 
       pcForm + '.':U + cHTMLName + '.select()~;~n'.
       
  {&OUT} '</script>~n'.

  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-joinExternalTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION joinExternalTables Procedure 
FUNCTION joinExternalTables RETURNS LOGICAL
  (pcTables AS CHAR,
   pcRowids AS CHAR):
/*------------------------------------------------------------------------------
  Purpose: Add external tables to the buffers in the database query    
Parameters: 
    INPUT pcTables - Comma-separated list of tables to join
    INPUT pcRowids - The corresponding list of ROWIDS.
    
    Notes: There are two ways to treat a list of external tables where one or 
           more of the tables already are in the query.
           1: As a default we use the corresponding ExternalRowid in the 
              whereclause in the query. All other tables are disregarded.               
           2: If the external table list is defined in the ExternalTables 
              attribute, we disregard the tables that are in the query and
              join to the OTHER tables. (ExternalJoinList and ExternalWhereList 
              already have the right number of entries)                 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTables            AS CHAR NO-UNDO.
  DEFINE VARIABLE cOldQuery          AS CHAR NO-UNDO.
  DEFINE VARIABLE cNewQuery          AS CHAR NO-UNDO.
  DEFINE VARIABLE cExternalTableList AS CHAR NO-UNDO.
  DEFINE VARIABLE cExternalJoinList  AS CHAR NO-UNDO.
  DEFINE VARIABLE cExternalWhereList AS CHAR NO-UNDO.
  DEFINE VARIABLE cExternalObject    AS CHAR NO-UNDO.
  DEFINE VARIABLE cJoinList          AS CHAR NO-UNDO.
  DEFINE VARIABLE cTable             AS CHAR NO-UNDO.
  DEFINE VARIABLE cWhereList         AS CHAR NO-UNDO.
  DEFINE VARIABLE cJoin              AS CHAR NO-UNDO.
  DEFINE VARIABLE cWhere             AS CHAR NO-UNDO.
  DEFINE VARIABLE iExt               AS INT  NO-UNDO.
  DEFINE VARIABLE iInt               AS INT  NO-UNDO.
  DEFINE VARIABLE iTblPos            AS INT  NO-UNDO.
  DEFINE VARIABLE iWherePos          AS INT  NO-UNDO.
  DEFINE VARIABLE iExtNum            AS INT  NO-UNDO.
  DEFINE VARIABLE iExtSkip           AS INT  NO-UNDO.
  DEFINE VARIABLE lJoinToSelf        AS LOG  NO-UNDO.

  {get Tables cTables}.
  {get ExternalTableList cExternalTableList}.
  {get ExternalJoinList cExternalJoinList}.
  {get ExternalWhereList cExternalWhereList}.  

  ASSIGN 
    iExtNum     = LOOKUP(pcTables,cExternalTableList,"|":U)        
    cNewQuery   = "FOR ":U   
    cJoinList   = (IF iExtNum > 0 THEN  
                  ENTRY(iExtNum,cExternalJoinList,"|":U)
                  ELSE FILL(",", NUM-ENTRIES(cTables)))
    cWhereList  = (IF iExtNum > 0 THEN  
                  ENTRY(iExtNum,cExternalWhereList,"|":U)
                  ELSE FILL(",", NUM-ENTRIES(cTables))).
  
  /* Identify any external table that also are in the query. 
     If the external table entry is defined we remove them, 
     because the joinlist and wherelist only have entries for the OTHER tables.
     If the external table entry is NOT defined we only add where clauses to 
     tables in the query. */
  DO iInt = 1 TO NUM-ENTRIES(cTables):
    ASSIGN
      cTable   = ENTRY(iInt,cTables)
      iExtSkip = LOOKUP(cTable,pcTables).
                 
    IF iExtSkip > 0 THEN
    DO:       
      /* If external table(s) are NOT defined we join using ROWIDS */ 
      IF iExtNum = 0 THEN
        ASSIGN
          ENTRY(iInt,cJoinList) = rowidExpression(cTable,ENTRY(iExtSkip,pcRowids)) 
          lJoinToSelf           = TRUE.     
      ELSE
        /* The join and where are already adjusted to this if they are defined */    
        ASSIGN
          pcTables = removeEntry(iExtSkip,pcTables)
          pcRowids = removeEntry(iExtSkip,pcRowids).                 
    END. /* if iExtSkip > 0 */
  END. /* do iInt = 1 TO num-entries(cTables) */
  
  /* Disregard the other external tables if this external tables entry 
     was not defined and the tables that were passed also are in the query */
        
  IF lJoinToSelf THEN
    ASSIGN
      pcTables = "":U
      pcRowids = "":U. 
  
  /* Log which tables are external in order not to delete them in deleteRow */ 
  {set ExternalTables pcTables}.
     
  /* Add for each where ROWID.. for all external tables */ 
  DO iExt = 1 TO NUM-ENTRIES(pcTables):    
    ASSIGN 
      cTable    = ENTRY(iExt,pcTables)
      cNewQuery = cNewQuery 
                  + " EACH ":U + cTable 
                  + " WHERE ":U
                  + rowidExpression(cTable,ENTRY(iExt,pcRowids))
                  + " NO-LOCK,":U.
    
    /* If no external join is defined we put 'OF last external table'
       as the first entry in the joinlist in order to join it 
       to the first table in the query */        
    IF iExtNum = 0 AND iExt = NUM-ENTRIES(pcTables) THEN                     
      ENTRY(1,cJoinList) = "OF " + cTable.
  END. /* do iExt = 1 to num-entries(pcTables) */
   
  /* Loop through each join of the old query and add join and where */
  DO iInt = 1 TO NUM-ENTRIES(cTables):
    ASSIGN
      cJoin       = ENTRY(iInt,cJoinList)
      cWhere      = IF NUM-ENTRIES(cWhereList) >= iInt 
                    THEN ENTRY(iInt,cWhereList)
                    ELSE "":U.
    IF cJoin <> "":U THEN
      DYNAMIC-FUNCTION("addQueryWhere" IN TARGET-PROCEDURE, /* 9.0B 98-11-04-042 */
                       cJoin,
                       ENTRY(iInt,cTables),
                       "":U).            
    IF cWhere <> '':U THEN 
      DYNAMIC-FUNCTION("addQueryWhere" IN TARGET-PROCEDURE,
                        cWhere,
                        ENTRY(iInt,cTables),
                        "":U).    
  END. /* do iInt = 1 TO num-entries(cTables) */
  
  {get QueryString cOldQuery}.   /* 9.0B 98-11-04-042 */ 
  
  IF cOldQuery = "":U THEN
    {get QueryWhere cOldQuery}. 
  
  cNewQuery = cNewQuery + SUBSTR(cOldQuery,4).
  
  {set QueryString cNewQuery}.
     
   /* pcTables may have been blanked out as a result of join to self */
  IF pcTables <> "":U THEN 
    ASSIGN
      cTables = pcTables + ",":U + cTables.
   
  /* Add the external tables as the first buffers in the query */  
  {set Buffers cTables}. 
  
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-joinForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION joinForeignFields Procedure 
FUNCTION joinForeignFields RETURNS LOGICAL
  (pcObject AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Find the foreignfields to use for the passed external table(s) or
           object and create the new query statement in the data-source. 
           get the values from the Web and add the columns and values 
           to the query.    
Parameters INPUT pcObject - A Table or SDO name that has an entry in the  
                            ForeignFieldsList       
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cForeignFieldList  AS CHAR    NO-UNDO.
  DEFINE VARIABLE cForeignFields     AS CHAR    NO-UNDO.
  DEFINE VARIABLE cTables            AS CHAR    NO-UNDO.
  DEFINE VARIABLE cExternalTableList AS CHAR    NO-UNDO.
  DEFINE VARIABLE cColumn            AS CHAR    NO-UNDO.
  DEFINE VARIABLE cColumnList        AS CHAR    NO-UNDO.
  DEFINE VARIABLE cValueList         AS CHAR    NO-UNDO.
  DEFINE VARIABLE cForeignName       AS CHAR    NO-UNDO.
  DEFINE VARIABLE cValue             AS CHAR    NO-UNDO.
  DEFINE VARIABLE cTable             AS CHAR    NO-UNDO.
  DEFINE VARIABLE iFld               AS INT     NO-UNDO.
  DEFINE VARIABLE iInt               AS INT     NO-UNDO.
  DEFINE VARIABLE iExtNum            AS INT     NO-UNDO.
  DEFINE VARIABLE hDataSource        AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hProc              AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lUsePeriod         AS LOGICAL NO-UNDO.
  
  {get ExternalTableList cExternalTableList}.
  {get ForeignFieldList cForeignFieldList}.
  
   /* From 3.1B we use the ObjectName property (support *_cl and dyndata etc.), 
      Remove old style extension (setExternalTableList does the same thing)
     */ 
  pcObject = ENTRY(1,pcObject,".":U). 
     
  /* We try to use the ForeignFields even if no externaltablelist
     is defined */ 


  iExtNum  = IF cExternalTableList = "":U THEN 1 
             ELSE LOOKUP(pcObject,cExternalTableList,"|":U).
  
  IF iExtNum = 0 THEN 
    RETURN FALSE.
  
  cForeignFields = ENTRY(iExtNum,cForeignFieldList,"|":U).
 
  IF cForeignFields = "":U THEN 
    RETURN FALSE.
  
  /* Build a list of columns and values */
  DO iFld = 1 TO NUM-ENTRIES(cForeignFields): /* 9.0B */
    ASSIGN 
      cColumn      = ENTRY(iFld,cForeignFields)
      
      /* The next entry may be an optional foreignfield name */                
      cForeignName = (IF iFld < NUM-ENTRIES(cForeignFields)       
                      THEN ENTRY(iFld + 1,cForeignFields)
                      ELSE ".") /* Add a period in order NOT to use this below */    
                 
      /* skip next iteration if its an optional foreignname */ 
      iFld         = iFld + (IF INDEX(cForeignName,".") <> 0 
                             THEN 0
                             ELSE 1)                       
    
     /* If the next entry is unqualified, use it as foreign name
        otherwise use the fieldname without db and table */                             
      cForeignName = IF INDEX(cForeignName,".") <> 0  
                     THEN ENTRY(NUM-ENTRIES(cColumn,".":U),cColumn,".":U)
                     ELSE cForeignName
      
      cValue       = get-field(cForeignName)
      cValueList   = cValueList 
                     + (IF cValueList = "":U THEN "":U ELSE CHR(1))
                     + cValue
      cColumnList   = cColumnList 
                     + (IF cColumnList = "":U THEN "":U ELSE ",":U)
                     + cColumn.
                       
      /* add the foreignfield to the list of URL parameters needed to keep 
         context */
      DYNAMIC-FUNCTION('addContextFields' IN TARGET-PROCEDURE,cForeignName).                            

  END. /* do ifld = 1 to num-entries(cForeignfields) */
    
  {get DataSource hDataSource}.
  
  hProc = IF VALID-HANDLE(hDataSource) 
          THEN hDataSource
          ELSE TARGET-PROCEDURE.
              
  RETURN DYNAMIC-FUNCTION("assignQuerySelection" IN hProc,  /* 9.0B 98-11-04-042 */
                          cColumnList,
                          cValueList,
                          "":U).
                          
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION openQuery Procedure 
FUNCTION openQuery RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Open the database query in the data-source
   Params:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.
  DEFINE VARIABLE hQuery   AS HANDLE NO-UNDO.
  
  {get DataSource hDataSource}.

  IF VALID-HANDLE(hDataSource) THEN 
    RETURN {fn OpenQuery hDataSource}.
  
  ELSE  
    RETURN SUPER().
     
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeEntry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION removeEntry Procedure 
FUNCTION removeEntry RETURNS CHARACTER PRIVATE
  (pNum       AS INT,
   pList      AS CHAR):
/*------------------------------------------------------------------------------
  Purpose: Remove an entry from a list.   
    Notes: PRIVATE, used in joinexternaltables
           Delimiter is always comma   
------------------------------------------------------------------------------*/
  ASSIGN
    ENTRY(pNum,PList) = "":U
    pList = RIGHT-TRIM(pList,",":U)
    pList = REPLACE(pList,",,":U,",":U)
    pList = LEFT-TRIM(pList,",":U).
      
  RETURN pList. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-reopenQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION reopenQuery Procedure 
FUNCTION reopenQuery RETURNS LOGICAL
  ():
/*------------------------------------------------------------------------------
  Purpose: Reset the data-source query to the state its original state. 
    Notes: This is the state after context has been reset, but before a search 
           or query has been perfoirmed.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.
  DEFINE VARIABLE hProc       AS HANDLE NO-UNDO.
  DEFINE VARIABLE cPrepare    AS CHAR   NO-UNDO.
  
  {get DataSource hDataSource}.  

  ASSIGN  
    hProc = (IF VALID-HANDLE(hDataSource) 
             THEN hDataSource 
             ELSE TARGET-PROCEDURE)
    cPrepare = "":U. 
  
  {set QueryWhere cPrepare hProc}.    
  RETURN {fn openQuery}. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowidExpression) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION rowidExpression Procedure 
FUNCTION rowidExpression RETURNS CHARACTER PRIVATE
  (pcBuffer AS CHAR,
   pcRowid  AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: create rowid expression for dynamic query 
           Rowid(table) = to-rowid(rowidchar) 
Parameters: INPUT pcBuffer - Buffername in the query.
            INPUT pcRowid  - STRING of the Rowid. 
               
    Notes:  
------------------------------------------------------------------------------*/  
  RETURN "ROWID(":U 
         + pcBuffer 
         + ") = TO-ROWID(~'":U
         + pcRowid
         + "~')":U.          
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sessionEnd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION sessionEnd Procedure 
FUNCTION sessionEnd RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:    End the logical session by deleting the SERVER_CONNECTION_ID cookie.
  Returns:    (LOGICAL) - TRUE
  Parameters: <none>
  Notes:    
------------------------------------------------------------------------------*/
  
  /* Delete the SERVER_CONNECTION_ID cookie and local variables. */
  setServerConnection('').
  
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAppService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAppService Procedure 
FUNCTION setAppService RETURNS LOGICAL
  (pAppService AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Store the AppService to start the SmartDataObject in. 
           This should be called BEFORE startDataObject. If the datasource is valid 
           we must disconnect it if it is connected to a different partition. 
    Notes: Will be passed to the SDO before initialize. 
------------------------------------------------------------------------------*/
 {set AppService pAppService}.
  RETURN TRUE. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBuffers) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBuffers Procedure 
FUNCTION setBuffers RETURNS LOGICAL
  (pcTables AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Set the buffers for the query. 
parameters: INPUT pcTables - Tables to use in the data-base query.  
    Notes: This will clear all previously defined buffers 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuf           AS HANDLE           NO-UNDO.
  DEFINE VARIABLE i              AS INT              NO-UNDO.
  DEFINE VARIABLE cTableName     AS CHAR             NO-UNDO.   
  DEFINE VARIABLE cBufferHandles AS CHAR             NO-UNDO.   
  
  {get Bufferhandles cBufferhandles}.
    
  /* If no bufferhandles but the handle is valid we clean up       
     the buffer handles that has been used for another targert */
  IF cBufferHandles = "":U AND VALID-HANDLE(ghQuery) THEN 
  DO i = 1 TO ghQuery:NUM-BUFFERS:
    hBuf = ghQuery:GET-BUFFER-HANDLE(i).
    DELETE WIDGET hBuf.
  END. /* if cBufferHandles = "" do i = 1 to */
  
  IF VALID-HANDLE(ghQuery) THEN 
    DELETE WIDGET ghQuery.  /* 9.0B 99-01-12-005 */    
 
  CREATE QUERY ghQuery.   

  DO i = 1 TO NUM-ENTRIES(pcTables):
    ASSIGN 
      cTableName = ENTRY(i,pcTables)
      hBuf       = {fnarg bufferHandle cTableName}.  
    
    IF hBuf = ? THEN
      CREATE BUFFER hBuf FOR TABLE cTableName no-error.
    
    /* Clear any previous buffers */ 
    IF i = 1 THEN
      ghQuery:SET-BUFFERS(hBuf) .
    ELSE 
      ghQuery:ADD-BUFFER(hBuf) .
    
    ASSIGN cBufferHandles = cBufferHandles 
                           + (IF cBufferHandles = "":U THEN "":U ELSE ",":U) 
                           + STRING(hBuf).        
  END.  
  
  {set BufferHandles cBufferHandles}.
  {set QueryHandle ghQuery}.
  {set Tables pcTables}.  
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setColumns Procedure 
FUNCTION setColumns RETURNS LOGICAL
  ( pColumns AS CHAR ) :
/*------------------------------------------------------------------------------
   Purpose: Defines which columns of the data-source to use. 
Parameters: INPUT pcColumns - Comma separated list of columns.
     Notes: The property that is used is DataColumns, but this is kept for 
           backward compatibility
           Defines the order the columns are displayed in the Web browser.    
------------------------------------------------------------------------------*/
  {set DataColumns pColumns}.

  RETURN TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContextFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setContextFields Procedure 
FUNCTION setContextFields RETURNS LOGICAL
  (pcContextFields AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Set the list of fields that are needed to keep context for the
           next request.   
Parameters: INPUT pcContextfield - The new property.
    Notes: Use addContextFields to add to the list.  
------------------------------------------------------------------------------*/
  {set ContextFields pcContextFields}.
  RETURN TRUE.   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrentRowids) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCurrentRowids Procedure 
FUNCTION setCurrentRowids RETURNS LOGICAL
  (pcRowids AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Set the list of rowids that's going to be used by fetchCurrent  
Parameters: INPUT pcRowids - List of ROWIDS  
    Notes: The purpose of this attribute is to store the context of the current 
           record received from the web once, so that we only need to 
           RUN fetchCurrent whenever it's needed.        
------------------------------------------------------------------------------*/
  {set CurrentRowids pcRowids}.
  
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setExternalJoinList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setExternalJoinList Procedure 
FUNCTION setExternalJoinList RETURNS LOGICAL
  (pcExternalJoinList AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Store the list of Join options that corresponds to ExtrnalTableList 
Parameters: INPUT pcExternalJoinList   - a | separated list of OF phrases            
     Notes: The Joins are defined in QueryBuilder   
------------------------------------------------------------------------------*/
  {set ExternalJoinList pcExternalJoinList}.
  RETURN TRUE.    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setExternalTableList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setExternalTableList Procedure 
FUNCTION setExternalTableList RETURNS LOGICAL
  (pcExternalTableList AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Store a comma-separeted list of potential external tables and objects 
Parameters: 
  INPUT pcExternalTableList - A | separated list of comma-separated tables   
    Notes: The ExternalJoinList and ExternalWhereList and/or ForeignFieldList
           has corresponding entries.
------------------------------------------------------------------------------*/
  /* From 3.1B when using ExternalObject the ObjectName is used instead of 
     file-name, in order to support _cl and dyndata, so in case this is 
     old style we remove the extensions.*/
  
  IF INDEX(pcExternalTableList,".":U) > 0 THEN   
    ASSIGN
      pcExternalTableList = REPLACE(pcExternalTableList,".w":U,"":U)
      pcExternalTableList = REPLACE(pcExternalTableList,".r":U,"":U).

  {set ExternalTableList pcExternalTableList}.
  
  RETURN TRUE.    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setExternalTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setExternalTables Procedure 
FUNCTION setExternalTables RETURNS LOGICAL
  (pExternalTables AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Store a commaseparated list of the current external tables.
Parameters:
   INPUT pcExternalTables - A comma-separated list of tables    
    Notes:    
------------------------------------------------------------------------------*/
  {set ExternalTables pExternalTables}.
  RETURN TRUE.    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setExternalWhereList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setExternalWhereList Procedure 
FUNCTION setExternalWhereList RETURNS LOGICAL
  (pExternalWhereList AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Store a list of where clauses corresponding to ExternalTables.  
Parameters: INPUT pcExternalWhereList - a | separated lsit of field expressions            
     Notes: The Where clauses are usually defined in the QueryBuilder.    
------------------------------------------------------------------------------*/
  {set ExternalWhereList pExternalWhereList}.
  RETURN TRUE.    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setForeignFieldList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setForeignFieldList Procedure 
FUNCTION setForeignFieldList RETURNS LOGICAL
  (pcForeignFieldList AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Store the list of Foreign Fields corresponding to the 
           ExternalTableList.   
    Notes:  
------------------------------------------------------------------------------*/
  {set ForeignFieldList pcForeignFieldList}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLinkColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLinkColumns Procedure 
FUNCTION setLinkColumns RETURNS LOGICAL
  (pcLinkColumns AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Store a comma separated list of columns that has hyperlinks.
Parameters 
     INPUT pcLinkColumns -  a Comma-separated list of column names.    
    Notes:  
------------------------------------------------------------------------------*/
  {set LinkColumns pcLinkColumns}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNavigationMode Procedure 
FUNCTION setNavigationMode RETURNS LOGICAL
  (pcMode AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Store the navigationmode received form the Web.   
Parameters
  INPUT pcMode - Next,Prev,First,Last or Search      
    Notes:  NOT USED
------------------------------------------------------------------------------*/
  {set NavigationMode pcMode}.
  RETURN TRUE. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryWhere Procedure 
FUNCTION setQueryWhere RETURNS LOGICAL
  (pWhere AS CHAR):
/*------------------------------------------------------------------------------
  Purpose: Prepare the query with a new open query statement or a 
           new expression.
Parameters: INPUT pcMode - The new where clause or expression.      
    Notes: SEE setQueryWhere in query.p  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery      AS HANDLE NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.
  DEFINE VARIABLE ok          AS LOG    NO-UNDO.
  DEFINE VARIABLE i           AS INT    NO-UNDO.
  
  {get DataSource hDataSource}.  
  
  IF VALID-HANDLE(hDataSource) THEN
    ASSIGN ok = DYNAMIC-FUNCTION('setQueryWhere' IN hDataSource, pWhere) NO-ERROR.        
  ELSE
    ASSIGN ok = SUPER(pWhere) NO-ERROR. 
  
  IF error-status:get-message(1) <> "" THEN 
  DO:    
    {&out} "The following expression could not compile:" '<br>' 
           pWhere '<BR>' .
    
    DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:              
      {&out} error-status:get-message(1) '<br>'. 
    END.
  END.
  RETURN ok.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSearchColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSearchColumns Procedure 
FUNCTION setSearchColumns RETURNS LOGICAL
  (pcSearchColumns AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Store the searchcolumns (Currently one)  
Parameters: INPUT pcSearchColumns - A column name in the data-source.   
    Notes:  
------------------------------------------------------------------------------*/
  {set searchColumns pcSearchColumns}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setServerConnection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setServerConnection Procedure 
FUNCTION setServerConnection RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:    Sets SERVER_CONNECTION_ID property from SESSION:SERVER-CONNECTION-ID
  Returns:    (LOGICAL) - TRUE
  Parameters: <none>
  Notes:    
------------------------------------------------------------------------------*/
  
  /* Set the attribute */
  {set serverConnection pcValue}.
  
  /* Create SERVER_CONNECTION_ID cookie */
  RUN set-server-connection IN web-utilities-hdl ( pcValue ).
    
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdateMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUpdateMode Procedure 
FUNCTION setUpdateMode RETURNS LOGICAL
(pcMode AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Store the updatemode received from the Web.  
Parameters: INPUT pcMode - "ADD" or blank.   
    Notes: Stored in ProcessWebRequest. 
------------------------------------------------------------------------------*/
  {set UpdateMode pcMode}.    
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showDataMessages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION showDataMessages Procedure 
FUNCTION showDataMessages RETURNS CHARACTER
  ( ) : 
/*------------------------------------------------------------------------------
  Purpose:     Does a fetchMessages to retrieve all Data-related messages
               (normally database update-related error messages), and
               calls the HTMLalert function to show them in an alertbox on the 
               Web.
  Parameters:  <none>. Returns the name of the field (if any) from the first
               error message, to allow the caller to use it to position the 
               cursor.
  Notes:       This procedure expects to receive back a single string 
               from fetchMessages with one or more messages delimited by CHR(3),
               and within each message the message text, Fieldname (or blank) +
               a Tablename (or blank), delimited by CHR(4) if present.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cMessages   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iMsg        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iMsgCnt     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cMessage    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFirstField AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cField      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTable      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cText       AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cMsgText    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hMsgSource  AS HANDLE    NO-UNDO.
  
  {get DataSource hDataSource}.
  ASSIGN
    hMsgSource = IF VALID-HANDLE(hDataSource) 
                 THEN hDataSource
                 ELSE TARGET-PROCEDURE
    cMessages  = DYNAMIC-FUNCTION('fetchMessages':U IN hMsgSource)
    iMsgCnt    = NUM-ENTRIES(cMessages, CHR(3)).
  
  DO iMsg = 1 TO iMsgCnt:
    /* Format a string of messages */        
    ASSIGN 
      cMessage = ENTRY(iMsg, cMessages, CHR(3))
      cMsgText = ENTRY(1, cMessage, CHR(4)).
   
    /* Skip buffer-value message (3131) */
    IF Index(cMsgText,"(3131)") = LENGTH(cMsgText) - 5 THEN NEXT.
    
    /* Remove RowObject from unable to update msg (142) */
    IF Index(cMsgText,"(142)")  = LENGTH(cMsgText) - 4 THEN 
      cMsgText = REPLACE(cMsgText,"RowObject","").
    
    ASSIGN cField = IF NUM-ENTRIES(cMessage, CHR(4)) > 1 THEN
             ENTRY(2, cMessage, CHR(4)) ELSE "":U
           cTable = IF NUM-ENTRIES(cMessage, CHR(4)) > 2 THEN
             ENTRY(3, cMessage, CHR(4)) ELSE "":U
           cText = cText + cMsgText + "~\n":U.
          
    /* Return the field name from the first error message so the caller can
       use it to position the cursor. */
    IF iMsg = 1 THEN cFirstField = cField.
  END.   /* END DO iMsg */
 
  IF cText NE "":U THEN
    HTMLAlert(cText).

  RETURN cFirstField.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startDataObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION startDataObject Procedure 
FUNCTION startDataObject RETURNS LOGICAL
  (pcDataSource AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Start or connect to the dataobject procedure. If the AppService 
           attribute is set in this object we must set in the SDO before it
           is initialized.  
Parameters: INPUT pcDataSource - A procedure name              
    Notes: The properties "OpenOnInit","CheckLastOnOpen" and "RebuildOnRepos"
           is always set to TRUE.          
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource    AS HANDLE NO-UNDO.
  DEFINE VARIABLE cAppService    AS CHAR   NO-UNDO.
  DEFINE VARIABLE cAppServiceSrc AS CHAR   NO-UNDO.
  DEFINE VARIABLE cBaseFileName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNeedInit      AS LOG    NO-UNDO.
  DEFINE VARIABLE lCriticalERROR AS LOG    NO-UNDO.
      
  {get DataSource hDataSource}.
  {get AppService cAppService}.                                 
  
  /* Set in object after to use to start this on server side if this ended
     up starting a client object */
  cBaseFileName = pcDataSource. 

  /* We don't need to start two objects if they really are the same, so 
     remove any 'current' ./ reference so that the :file-name logic further down
     doesn't think this is a different object than one without the period slash*/   
  IF pcDataSource BEGINS "./":U   
  OR pcDataSource BEGINS ".~\":U THEN
     pcDataSource = SUBSTR(pcDataSource,3). 
 
  IF cAppservice <> "":U THEN  /* The procedure may be .\xxx.w  */ 
    ASSIGN pcDataSource = (IF NUM-ENTRIES(pcDataSource,".":U) = 3 
                           THEN ".":U 
                           ELSE "":U)
                           + 
                           ENTRY(NUM-ENTRIES(pcDataSource,".":U) - 1, 
                           pcDataSource, ".":U) + "_cl.":U 
                           +
                           ENTRY(NUM-ENTRIES(pcDataSource,".":U), 
                           pcDataSource, ".":U).            
  
  IF NOT VALID-HANDLE(hDataSource) 
  OR hDataSource:FILE-NAME <> pcDataSource THEN 
  DO:       
    hDataSource = SESSION:FIRST-PROCEDURE.
    DO WHILE VALID-HANDLE(hDataSource):
      IF hDataSource:FILE-NAME EQ pcDataSource THEN 
        LEAVE.
      ASSIGN hDataSource = hDataSource:NEXT-SIBLING.
    END. /* do while valid-handle(hDataSource) */          
    
    IF VALID-HANDLE (hDataSource) THEN   
    DO:
      {get AppService cAppServiceSrc hDataSource}.             
      IF cAppServiceSrc <> "":U AND cAppServiceSrc <> cAppService THEN
      DO:
        IF cAppService <> "":U THEN 
          RUN disconnectObject IN hDataSource.
        lNeedInit = TRUE. 
      END. /* if cAppServiceSrc <> "":U and cAppServiceSrc <> cAppService */
      /* Make sure we initialize if disconnect on each request */
      ELSE IF cAppservice <> "":U THEN
        lNeedInit = TRUE. 
    END. /* if valid-handle(hDataSource) */ 
    ELSE DO ON STOP UNDO, LEAVE :    
      RUN VALUE(pcDataSource) PERSISTENT SET hDataSource NO-ERROR.                
      
      IF VALID-HANDLE(hDataSource) THEN
      DO:
        {set ServerFileName cBaseFileName hDataSource}. 
        {set OpenOnInit FALSE hDataSource}.     
        {set CheckLastOnOpen TRUE hDataSource}.         
        {set RebuildOnRepos TRUE hDataSource}.         
      END.
      lNeedInit = TRUE.            
    END. /* do on stop undo, leave */
    
    IF VALID-HANDLE(hDataSource) THEN
    DO:
      IF lNeedInit THEN 
      DO:      
        {set AppService cAppService hDataSource}.            
        RUN initializeObject IN hDataSource NO-ERROR.
        lCriticalERROR = ERROR-STATUS:ERROR. 
      END. /* if lNeedInit then */         
      {set DataSource hDataSource}.         
    END. /* if valid-handle(hDataSource) */      
  END. /* if not valid or :file-name <> pcDatasource */  
  
  IF lCriticalError OR NOT VALID-HANDLE(hDataSource) THEN /* 9.0B 98-12-29-002 */
  DO:
    IF VALID-HANDLE(hDataSource) THEN
      {fn destroyDataObject}.    
    STOP.  
  END.       
  
  /* The DataObject may be running persistently from another request so we 
     must always reset the query  */       
  IF VALID-HANDLE(hDataSource) THEN
    DYNAMIC-FUNCTION("setQueryWhere":U IN hDataSource,"":U).  
       
  RETURN VALID-HANDLE(hDataSource). 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-urlJoinParams) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION urlJoinParams Procedure 
FUNCTION urlJoinParams RETURNS CHARACTER
  (pcJoin AS CHAR) :                                             
/*------------------------------------------------------------------------------
   Purpose: Generate the URL parameter to use as join information for a linked 
            object. 
Parameters: 
    INPUT pcJoin      - ROWID - Pass ExternalRowids 
                      - Comma separated list of column names
                      - blank - No link information needed   
    
    Notes: This is called from urlLink with the correct entry from the CHR(3) 
           delimited JoinLinks attribute.
           Add "?" as the last entry to the parameter to specifiy that the first
           parameter should be separated with "?". (the FIRST url parameter)                
------------------------------------------------------------------------------*/ 
  DEFINE VARIABLE cTables         AS CHAR NO-UNDO.
  DEFINE VARIABLE cTableRowids    AS CHAR NO-UNDO.
  DEFINE VARIABLE cParams         AS CHAR NO-UNDO.
  DEFINE VARIABLE iFld            AS INT  NO-UNDO.
  DEFINE VARIABLE cAttrName       AS CHAR NO-UNDO.
  DEFINE VARIABLE cColumn         AS CHAR NO-UNDO.
  DEFINE VARIABLE cValue          AS CHAR NO-UNDO.
  DEFINE VARIABLE hDataSource     AS HANDLE NO-UNDO.
  DEFINE VARIABLE cBackRowids     AS CHAR NO-UNDO.
  DEFINE VARIABLE cFirstDelimiter AS CHAR INIT ? NO-UNDO. 
  DEFINE VARIABLE iNumEntries     AS INT  NO-UNDO. 
  DEFINE VARIABLE cObjectName     AS CHARACTER NO-UNDO.
  
  ASSIGN 
    iNumEntries      = NUM-ENTRIES(pcJoin)
    cFirstDelimiter  = IF iNumEntries <> 0 AND ENTRY(iNumEntries,pcJoin) = "?":U 
                       THEN "?":U
                       ELSE ?. /* use WebSpeed default */
  
  /* If this link does not pass join parameters we check if there is a BackRowids
     received from the caller and use that as currentrowids in an attemp to set 
     context */       
  IF pcJoin = "":U OR ENTRY(1,pcJoin) = "":U THEN
  DO: 
    cBackRowids = get-field("BackRowids":U).
    IF cBackRowids <> "" THEN
      cParams   = url-field("CurrentRowids":U,cBackRowids,cFirstDelimiter).             
  END. /* if pJpoin = '' or entry(1,pcJoin = '') */
  ELSE DO:       
    
    {get DataSource hdataSource}.
    
    IF VALID-HANDLE(hdataSource) THEN
    DO:
      {get ObjectName cObjectName hDataSource}.
      
      IF cObjectName = "":U THEN
        cObjectName = hDataSource:FILE-NAME.

      cParams = cParams + url-field('ExternalObject':U,
                          cObjectName,
                          IF CAN-DO(cParams,"?":U) 
                          THEN ? 
                          ELSE cFirstDelimiter).
    END.
    {get Tables cTables}.           
    cParams = cParams +
              url-field('ExternalTables':U,
                         cTables,
                         IF CAN-DO(cParams,"?":U) 
                         THEN ? 
                         ELSE cFirstDelimiter).     
    
    IF ENTRY(1,pcJoin) = "ROWID":U THEN
    DO:
      {get TableRowids cTableRowids}.
    
      cParams = cParams 
                + url-field('ExternalRowids':U,
                             cTableRowids,
                             IF CAN-DO(cParams,"?":U) 
                             THEN ? 
                             ELSE cFirstDelimiter). 
                        
    END. /* if entry(1,pcJoin) = "ROWID" */
                             
                                    /* Check the firstdelimiter to se if the last 
                                       entry was "?" and need to vbe skipped */
    ELSE DO iFld = 1 TO iNumEntries - (IF cFirstDelimiter = "?" 
                                       THEN 1 
                                       ELSE 0):
      ASSIGN   
        cColumn   = ENTRY(iFld,pcJoin)         
        cAttrName = ENTRY(NUM-ENTRIES(cColumn,".":U),cColumn,".":U)
        cValue    = DYNAMIC-FUNCTION('columnStringValue' IN TARGET-PROCEDURE,
                                      cColumn) NO-ERROR.
                                      
      IF cAttrName <> "":U AND NOT ERROR-STATUS:ERROR THEN 
        cParams = cParams                                  
                   + url-field(cAttrName,
                               cValue,
                               IF CAN-DO(cParams,"?":U) 
                               THEN ? 
                               ELSE cFirstDelimiter). 
    END. /* do iFld = 1 to num-entries(pcJoin) */
  END. /* else (first entry in pcJoin <> '' ) */
  
  RETURN cParams.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-urlLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION urlLink Procedure 
FUNCTION urlLink RETURNS CHARACTER
  (pcWebObject AS CHAR,
   pcJoin      AS CHAR):
/*------------------------------------------------------------------------------
  Purpose: Returns the necessary URL parameters in order to pass record 
           information to a linked object.  
  Parameters: 
    INPUT pcWebObject - The object to call  (may have URL parameters) 
    INPUT pcJoin      - ROWID 
                      - Comma separated list of column names
                      - blank  
   Notes:                            
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cDelimiter     AS CHAR NO-UNDO.
   DEFINE VARIABLE cCurrentRowids AS CHAR NO-UNDO.

   /* the passed webobject may have a parameter already */
   ASSIGN
     cDelimiter = (IF INDEX(pcWebObject,"?":U) > 0 
                   THEN "":U
                   ELSE "?":U).
    {get CurrentRowids cCurrentRowids}.
    
   RETURN url-encode(pcWebObject,'DEFAULT':U)
          + url-field('BackRowids':U,cCurrentRowids,cDelimiter)                          
          + DYNAMIC-FUNCTION('urlJoinParams' IN TARGET-PROCEDURE,
                              pcJoin).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateColumnValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION validateColumnValue Procedure 
FUNCTION validateColumnValue RETURNS LOGICAL
  (pcColumn AS CHAR,
   pcValue  AS CHAR):   
/*------------------------------------------------------------------------------
   Purpose: Check if a value is correct datatype  
Parameters:  
  INPUT pcColumn - The column's name in hte data-source.
  INPUT pcValue  - Value to validate.
     Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE ch AS CHAR NO-UNDO.
  DEFINE VARIABLE da AS DATE NO-UNDO.
  DEFINE VARIABLE de AS DEC  NO-UNDO.
  DEFINE VARIABLE i  AS INT  NO-UNDO.
  DEFINE VARIABLE lo AS LOG  NO-UNDO. 
  
  DEFINE VARIABLE cDataType AS CHAR NO-UNDO.
  DEFINE VARIABLE cFormat   AS CHAR NO-UNDO.

  ASSIGN
    cDataType = DYNAMIC-FUNCTION('columnDataType' IN TARGET-PROCEDURE,pcColumn).
    cFormat   = DYNAMIC-FUNCTION('columnFormat' IN TARGET-PROCEDURE,pcColumn).
  
  CASE cDataType:
    WHEN "CHARACTER":U THEN 
      ASSIGN ch = pcValue NO-ERROR. 
    WHEN "DATE":U THEN 
      ASSIGN 
        da = DATE(pcValue) NO-ERROR. 
    WHEN "DATETIME":U THEN 
      ASSIGN 
        da = DATETIME(pcValue) NO-ERROR. 
    WHEN "DATETIME-TZ":U THEN 
      ASSIGN 
        da = DATETIME-TZ(pcValue) NO-ERROR. 
    WHEN "DECIMAL":U THEN 
      ASSIGN de = DEC(pcValue) NO-ERROR. 
    WHEN "INTEGER":U THEN 
      ASSIGN i = INT(pcValue) NO-ERROR. 
    WHEN "LOGICAL":U THEN 
    DO:
      lo =  CAN-DO('TRUE,YES,NO,FALSE':U 
                     + ENTRY(1,cFormat,"/":U)
                     + ENTRY(2,cFormat,"/":U),pcValue). 
      
      IF NOT lo THEN 
        RUN AddMessage IN TARGET-PROCEDURE ('Invalid searchvalue',?,?).
    END.   
  END. 
  IF ERROR-STATUS:ERROR THEN DO:  
     RUN AddMessage IN TARGET-PROCEDURE (?,?,?). 
  END. 
  
  RETURN NOT DYNAMIC-FUNCTION('anyMessage':U IN TARGET-PROCEDURE).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

