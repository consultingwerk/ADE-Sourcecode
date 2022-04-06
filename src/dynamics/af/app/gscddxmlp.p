&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/* Copyright (c) 2000-2008 by Progress Software Corporation.  All rights 
   reserved.  Prior versions of this work may contain portions 
   contributed by participants of Possenet.  */
/*---------------------------------------------------------------------------------
  File: gscddxmlp.p

  Description:  Deployment Dataset XML procedure
  
  Purpose:      This procedure exports deployment datasets to an XML file and reads them
                in from an XML file.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000083   UserRef:    
                Date:   27/04/2001  Author:     Bruce Gruenbaum

  Update Notes: Created from Template rytemprocp.p

  (v:010001)    Task:    90000141   UserRef:    
                Date:   24/05/2001  Author:     Bruce Gruenbaum

  Update Notes: Updates

  (v:010005)    Task:           0   UserRef:    
                Date:   11/21/2001  Author:     Bruce S Gruenbaum

  Update Notes: Deployment Packaging updates

-------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gscddxmlp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

&SCOPED-DEFINE DateFormats "mdy,dmy,ymd,ydm,myd,dym":U 
&SCOPED-DEFINE FormatMasks "99/99/9999,99/99/9999,9999/99/99,9999/99/99,99/9999/99,99/9999/99":U
&SCOPED-DEFINE RCODEINFO RCODE-INFORMATION

/* DEFINE STREAM str_xmlin. */
DEFINE STREAM str_xmlout.

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.
DEFINE VARIABLE ghXMLHlpr           AS HANDLE    NO-UNDO.
/* DEFINE VARIABLE ghObjectPool        AS HANDLE     NO-UNDO. */
/* DEFINE VARIABLE ghDDO               AS HANDLE    NO-UNDO.  */
DEFINE VARIABLE gcMessageList       AS CHARACTER NO-UNDO.
DEFINE VARIABLE giRequestNo         AS INTEGER   NO-UNDO.
DEFINE VARIABLE giSiteNo            AS INTEGER   NO-UNDO.
DEFINE VARIABLE giSiteRev           AS INTEGER   NO-UNDO.
DEFINE VARIABLE giSiteDiv           AS INTEGER   NO-UNDO.
DEFINE VARIABLE giDeleteRec         AS INTEGER   NO-UNDO.
DEFINE VARIABLE ghTargetProc        AS HANDLE     NO-UNDO.

{checkerr.i &define-only = YES}
  
ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{adm2/globals.i}


/* The following include contains the replaceCtrlChar function */
{af/sup2/afxmlreplctrl.i}

/* ttRequiredRecord contains the list of parameters that decide how the 
   XML file is written out. */
DEFINE TEMP-TABLE ttRequiredRecord NO-UNDO {&RCodeInfo}
  FIELD iSequence       AS INTEGER   
  FIELD cJoinFieldValue AS CHARACTER FORMAT "X(50)":U
  INDEX pudx IS UNIQUE PRIMARY
    iSequence
  .

/* ttTable contains the data from the gsc_dataset_entity table
   for the particular dataset being processed. */
DEFINE TEMP-TABLE ttTable NO-UNDO  {&RCodeInfo}
  FIELD iEntitySeq      AS INTEGER    FORMAT ">,>>9":U COLUMN-LABEL  "Seq"
  FIELD cEntityMnemonic AS CHARACTER  FORMAT "X(15)":U  COLUMN-LABEL "Entity!Mnemonic"
  FIELD cDatabase       AS CHARACTER  FORMAT "X(30)":U  COLUMN-LABEL "DB Name"
  FIELD cTableName      AS CHARACTER  FORMAT "X(30)":U  COLUMN-LABEL "Table"
  FIELD lPrimary        AS LOGICAL    FORMAT "Yes/No":U COLUMN-LABEL "Primary"
  FIELD cJoinMnemonic   AS CHARACTER  FORMAT "X(15)":U  COLUMN-LABEL "Join!Mnemonic"
  FIELD cJoinFieldList  AS CHARACTER  FORMAT "X(50)":U  COLUMN-LABEL "Join Fields"
  FIELD cWhereClause    AS CHARACTER  FORMAT "X(50)":U  COLUMN-LABEL "Where Clause"
  FIELD cExcludeFields  AS CHARACTER  FORMAT "X(50)":U  COLUMN-LABEL "Exclude Fields"
  FIELD hBuffer         AS HANDLE
  INDEX pudx IS UNIQUE PRIMARY
    iEntitySeq
    cEntityMnemonic
  INDEX dx1 
    lPrimary
  INDEX dx2
    cJoinMnemonic
    iEntitySeq
  INDEX dx3
    cEntityMnemonic
    lPrimary
  .

/* The ttEntityList table is a working table used to make sure that the 
   temp-table is only written to the XML header section once. */ 
DEFINE TEMP-TABLE ttEntityList NO-UNDO {&RCodeInfo}
  FIELD cEntityMnemonic AS CHARACTER  FORMAT "X(50)":U
  FIELD cDatabase       AS CHARACTER  FORMAT "X(50)":U
  FIELD cTableName      AS CHARACTER  FORMAT "X(50)":U
  FIELD cJoinMnemonic   AS CHARACTER  FORMAT "X(50)":U
  FIELD cJoinFieldList  AS CHARACTER  FORMAT "X(50)":U
  FIELD cObjField       AS CHARACTER  FORMAT "X(50)":U
  FIELD cKeyField       AS CHARACTER  FORMAT "X(50)":U
  FIELD lHasObj         AS LOGICAL    FORMAT "YES/NO":U
  FIELD lVersionData    AS LOGICAL
  FIELD hBuffer         AS HANDLE
  FIELD iTableNo     AS INTEGER 
  INDEX pudx IS UNIQUE PRIMARY
    cEntityMnemonic
  INDEX dxJoinMnemonic
    cJoinMnemonic
  .


/* This table is a working table that is used to manipulate the data that 
   is contained in the XML file. */
DEFINE TEMP-TABLE ttNode NO-UNDO   {&RCodeInfo}
  FIELD iRequestNo    AS INTEGER
  FIELD iLevelNo      AS INTEGER
  FIELD iTableNo      AS INTEGER
  FIELD cNode         AS CHARACTER FORMAT "X(25)"
  FIELD iExtentIndex  AS INTEGER
  FIELD cValue        AS CHARACTER FORMAT "X(50)"
  FIELD lDelete       AS LOGICAL   FORMAT "YES/NO"
  INDEX pudx IS UNIQUE PRIMARY
    iRequestNo
    iLevelNo 
    iTableNo
    cNode
    iExtentIndex
  INDEX dxDelete 
    lDelete
  .

/* This table contains a list of all the tables that have been defined
   by buildTableStruct that have not yet been returned to the client */
DEFINE TEMP-TABLE ttTableList NO-UNDO {&RCodeInfo}
  FIELD iRequestNo      AS INTEGER 
  FIELD iTableNo        AS INTEGER 
  FIELD cEntityMnemonic AS CHARACTER
  FIELD cDBName         AS CHARACTER FORMAT "X(30)"  COLUMN-LABEL "Database":U
  FIELD cTableName      AS CHARACTER FORMAT "X(30)"  COLUMN-LABEL "Table Name":U
  FIELD hTable          AS HANDLE
  INDEX pudx IS UNIQUE PRIMARY
    iRequestNo
    iTableNo
  INDEX udx IS UNIQUE
    iRequestNo
    cDBName
    cTableName
  .

/* This table is used to work out if an index already exists on field combinations */
DEFINE TEMP-TABLE ttIndexList NO-UNDO {&RCodeInfo}
  FIELD iIndexNo   AS INTEGER
  FIELD cFieldList AS CHARACTER FORMAT "X(50)":U
  FIELD lUnique    AS LOGICAL   FORMAT "YES/NO":U
  INDEX pudx IS UNIQUE PRIMARY
    cFieldList
  INDEX udx1 IS UNIQUE
    iIndexNo
  .

/* This table stores the dataset attributes applicable to each
   request */
DEFINE TEMP-TABLE ttDSAttribute NO-UNDO {&RCodeInfo}
  FIELD iRequestNo   AS INTEGER
  FIELD cAttribute   AS CHARACTER  FORMAT "X(50)":U
  FIELD cValue       AS CHARACTER  FORMAT "X(50)":U
  INDEX pudx IS UNIQUE PRIMARY
    iRequestNo
    cAttribute
  .

/* This table contains a list of handles to objects used in requests */
DEFINE TEMP-TABLE ttReqHandle NO-UNDO {&RCodeInfo}
  FIELD iRequestNo      AS INTEGER
  FIELD iDelOrder       AS INTEGER
  FIELD cHandleName     AS CHARACTER  FORMAT "X(50)":U
  FIELD cHandleType     AS CHARACTER  FORMAT "X(50)":U
  FIELD hHandle         AS HANDLE
  INDEX pudx IS UNIQUE PRIMARY
    iRequestNo 
    cHandleName
  INDEX udx IS UNIQUE 
    iRequestNo 
    iDelOrder
    cHandleName
  .

/* This table contains a record per dataset transaction */
DEFINE TEMP-TABLE ttTransaction NO-UNDO {&RCodeInfo}
  FIELD iRequestNo       AS INTEGER   
  FIELD iTransNo         AS INTEGER    FORMAT ">>>,>>9":U COLUMN-LABEL "Trans No":U
  FIELD cObjFieldVal     AS CHARACTER  FORMAT "X(30)":U   COLUMN-LABEL "Object Field":U
  FIELD cKeyFieldVal     AS CHARACTER  FORMAT "X(30)":U   COLUMN-LABEL "Key Field":U
  FIELD rRowid           AS ROWID
  INDEX pudx IS UNIQUE PRIMARY
    iRequestNo
    iTransNo
  .

/* This table stores the list of version records for the data that is currently
   being written to the XML file. When we have finished exporting the XML file and
   the file has been successfully saved, this table is used to determine which records
   need to have their version status re-set. */
DEFINE TEMP-TABLE ttVersionReset NO-UNDO
  FIELD record_version_obj LIKE gst_record_version.record_version_obj
  FIELD delete_record      AS LOGICAL
  INDEX pudx IS UNIQUE PRIMARY
    record_version_obj
  .

/* This table is used to contain the loaded version information for the duration of
   an import. For the duration of the load this means we have a list of records and 
   the current version that their data is at */
DEFINE TEMP-TABLE ttImportVersion NO-UNDO
  LIKE gst_record_version
  FIELD oObjOnDB LIKE gst_record_version.record_version_obj
  INDEX pudx IS UNIQUE PRIMARY
    record_version_obj
  .

/* This table is just a temporary working table that can be used to manipulate the 
   data that will be stored in ttImportVersion */
DEFINE TEMP-TABLE ttImport NO-UNDO LIKE ttImportVersion.

/* This table is used to receive the parameters for an import from the caller. */
DEFINE TEMP-TABLE ttTableProps NO-UNDO
  FIELD cEntityMnemonic     AS CHARACTER
  FIELD lOverWrite          AS LOGICAL
  FIELD lDeleteRelated      AS LOGICAL
  FIELD lKeepOwnSiteData    AS LOGICAL
  INDEX pudx IS UNIQUE PRIMARY
    cEntityMnemonic
  .

/* This table contains a list of records that may need to be deleted at the end
   of dataset import process. */
DEFINE TEMP-TABLE ttDeleteList NO-UNDO
  FIELD cEntityMnemonic     AS CHARACTER
  FIELD iKey                AS INTEGER
  FIELD lHasObj             AS LOGICAL
  FIELD cObjFieldList       AS CHARACTER
  FIELD cObjFieldValue      AS CHARACTER
  FIELD cKeyFieldList       AS CHARACTER
  FIELD cKeyFieldValue      AS CHARACTER
  FIELD hTTBuffer           AS HANDLE
  FIELD cDBTable            AS CHARACTER
  INDEX pudx IS UNIQUE PRIMARY
    cEntityMnemonic
    iKey
  .

/* This temp-table is used to pass parameters into import deployment dataset */
DEFINE TEMP-TABLE ttImportParam NO-UNDO
  FIELD cParam             AS CHARACTER
  FIELD cValue             AS CHARACTER
  INDEX dx IS PRIMARY
    cParam
  .

/* This temp-table is used to pass parameters into import deployment dataset */
DEFINE TEMP-TABLE ttExportParam NO-UNDO
  FIELD cParam             AS CHARACTER
  FIELD cValue             AS CHARACTER
  INDEX dx IS PRIMARY
    cParam
  .

DEFINE TEMP-TABLE ttADOParam NO-UNDO
  FIELD cParam             AS CHARACTER
  FIELD cValue             AS CHARACTER
  INDEX dx IS PRIMARY
    cParam
  .


/* The following two temp-table are used for release versioning to build up the
   list of data that needs to be exported. */
DEFINE TEMP-TABLE ttExportRecordSet  NO-UNDO 
  FIELD dataset_code        LIKE gsc_deploy_dataset.dataset_code
  FIELD cKey                AS CHARACTER 
  FIELD cFileName           AS CHARACTER 
  INDEX udx IS UNIQUE PRIMARY
    dataset_code
    cKey
  .

DEFINE TEMP-TABLE ttExportDataset NO-UNDO 
  FIELD dataset_code        LIKE gsc_deploy_dataset.dataset_code
  FIELD cFileName           AS CHARACTER 
  FIELD source_code_data    LIKE gsc_deploy_dataset.source_code_data
  INDEX pudx IS UNIQUE PRIMARY
    dataset_code
  .

DEFINE TEMP-TABLE ttPatchList NO-UNDO
  FIELD iSeq             AS INTEGER
  FIELD cDatasetCode     AS CHARACTER
  FIELD cPatchLevel      AS CHARACTER
  FIELD cStage           AS CHARACTER
  FIELD cFileType        AS CHARACTER
  FIELD cFileName        AS CHARACTER
  FIELD cDescription     AS CHARACTER
  FIELD lRerunnable      AS LOGICAL
  FIELD lNewDB           AS LOGICAL
  FIELD lExistingDB      AS LOGICAL
  FIELD lUpdateMandatory AS LOGICAL
  INDEX pudx IS PRIMARY UNIQUE
    cFileName
  INDEX dxSeq
    iSeq
    cFileName
  INDEX dxDSCode
    cDatasetCode
  .

DEFINE TEMP-TABLE ttObjectList NO-UNDO
  FIELD cObjectName     AS CHARACTER
  FIELD cObjectType     AS CHARACTER
  FIELD lObjectInUse    AS LOGICAL
  FIELD hObjectHandle   AS HANDLE
  INDEX pudx IS UNIQUE PRIMARY
    hObjectHandle
  INDEX dxSearch
    cObjectName
    cObjectType
    lObjectInUse
  .

DEFINE TEMP-TABLE ttDummy NO-UNDO
  FIELD cTest AS INTEGER
  INDEX pudx IS UNIQUE PRIMARY
    cTest
  .

/* Contains the definition for ttReleaseChangeset, used for 
   the deployment automation. */
{af/app/afdplchgst.i}

/* Defines SetupInclude dataset  and contained temp-tables */
{af/app/afstpincds.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-applyRules) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD applyRules Procedure 
FUNCTION applyRules RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignNode Procedure 
FUNCTION assignNode RETURNS CHARACTER
  ( INPUT piRequestNo AS INTEGER, 
    INPUT piNodeLevel AS INTEGER, 
    INPUT piTableNo   AS INTEGER, 
    INPUT phParent    AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildErrList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildErrList Procedure 
FUNCTION buildErrList RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildFileName Procedure 
FUNCTION buildFileName RETURNS CHARACTER
  ( INPUT pcRootDir AS CHARACTER,
    INPUT pcFileName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildForEach) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildForEach Procedure 
FUNCTION buildForEach RETURNS CHARACTER
  ( INPUT phBuffer         AS HANDLE,
    INPUT pcFieldList      AS CHARACTER,
    INPUT phParent         AS HANDLE,
    INPUT pcJoinFieldValue AS CHARACTER,
    INPUT pcWhereClause    AS CHARACTER,
    INPUT plLock           AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildKeyVal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildKeyVal Procedure 
FUNCTION buildKeyVal RETURNS CHARACTER
  (INPUT phTable        AS HANDLE, 
   INPUT pcFieldList    AS CHARACTER, 
   INPUT pcDelimiter    AS CHARACTER,
   INPUT plStandardForm AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildWhereFromKeyList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildWhereFromKeyList Procedure 
FUNCTION buildWhereFromKeyList RETURNS CHARACTER
  ( INPUT phBuffer    AS HANDLE,
    INPUT pcFieldList AS CHARACTER,
    INPUT pcFieldVal  AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildWhereFromKeyVal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildWhereFromKeyVal Procedure 

FUNCTION buildWhereFromKeyVal RETURNS CHARACTER
  ( INPUT pcDelimiter  AS CHARACTER,
    INPUT pcFieldList  AS CHARACTER,
    INPUT pcFieldValue AS CHARACTER,
    INPUT phTableBuff  AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-calcFieldListWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD calcFieldListWhere Procedure 
FUNCTION calcFieldListWhere RETURNS CHARACTER
  ( INPUT phBuffer         AS HANDLE,
    INPUT pcFieldList      AS CHARACTER,
    INPUT phParent         AS HANDLE,
    INPUT pcJoinFieldValue AS CHARACTER,
    INPUT pcDataFormat     AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-calculateVersionKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD calculateVersionKey Procedure 
FUNCTION calculateVersionKey RETURNS CHARACTER
  (INPUT pcEntityMnemonic AS CHARACTER,
   INPUT phBuff AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-compareKeys) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD compareKeys Procedure 
FUNCTION compareKeys RETURNS LOGICAL
  (INPUT pcKeyField  AS CHARACTER, 
   INPUT phBuff1     AS HANDLE, 
   INPUT phBuff2     AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-convDTForWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD convDTForWhere Procedure 
FUNCTION convDTForWhere RETURNS CHARACTER
  ( INPUT pcDataType    AS CHARACTER,
    INPUT pcValue       AS CHARACTER,
    INPUT piRequestNo   AS INTEGER,
    INPUT pcDataFormat  AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createPath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createPath Procedure 
FUNCTION createPath RETURNS INTEGER
  ( INPUT pcPath AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createTable Procedure 
FUNCTION createTable RETURNS LOGICAL
  ( INPUT piRequest AS INTEGER,
    INPUT pcTable AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-datasetQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD datasetQuery Procedure 
FUNCTION datasetQuery RETURNS INTEGER
  ( INPUT phBuffer AS HANDLE,
    INPUT pcQueryString AS CHARACTER,
    INPUT phRecordNode AS HANDLE,
    INPUT pcEntityMnemonic AS CHARACTER,
    INPUT piTransNo AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteAttributes Procedure 
FUNCTION deleteAttributes RETURNS LOGICAL
  ( INPUT piRequestNo AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteReqHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteReqHandles Procedure 
FUNCTION deleteReqHandles RETURNS LOGICAL
  ( INPUT piRequestNo AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteTempTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteTempTables Procedure 
FUNCTION deleteTempTables RETURNS LOGICAL
  ( INPUT piRequestNo AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteTransactions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteTransactions Procedure 
FUNCTION deleteTransactions RETURNS LOGICAL
  ( INPUT piRequestNo AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAttribute Procedure 
FUNCTION getAttribute RETURNS CHARACTER
  ( INPUT piRequestNo AS INTEGER,
    INPUT pcAttribute AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEntityData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEntityData Procedure 
FUNCTION getEntityData RETURNS LOGICAL
  ( INPUT  pcSource         AS CHARACTER,
    INPUT  pcEntityMnemonic AS CHARACTER,
    INPUT  phTable          AS HANDLE,
    INPUT  pcDelimiter      AS CHARACTER,
    OUTPUT pcKeyField       AS CHARACTER,
    OUTPUT pcKey            AS CHARACTER,
    OUTPUT pcObjField       AS CHARACTER,
    OUTPUT pcObj            AS CHARACTER,
    OUTPUT plHasObj         AS LOGICAL,
    OUTPUT plVersionData    AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFileNameFromField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFileNameFromField Procedure 
FUNCTION getFileNameFromField RETURNS CHARACTER
  ( INPUT pcFieldForFile AS CHARACTER,
    INPUT phBuffer       AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectHandle Procedure 
FUNCTION getObjectHandle RETURNS HANDLE
  ( INPUT piRequestNo AS INTEGER,
    INPUT pcHandleName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isDataModified Procedure 
FUNCTION isDataModified RETURNS LOGICAL
  ( INPUT pcEntityMnemonic AS CHARACTER,
    INPUT phBuffer         AS HANDLE,
    INPUT plIgnoreMinus    AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-matchKeys) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD matchKeys Procedure 
FUNCTION matchKeys RETURNS LOGICAL
  ( INPUT pcFieldList  AS CHARACTER,
    INPUT pcFieldValue AS CHARACTER,
    INPUT phBuffer     AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainDatabaseRec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD obtainDatabaseRec Procedure 
FUNCTION obtainDatabaseRec RETURNS LOGICAL
  (INPUT pcEntityMnemonic AS CHARACTER,
   INPUT phCopyRec AS HANDLE,
   INPUT phDBRec   AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainDataVersionRec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD obtainDataVersionRec Procedure 
FUNCTION obtainDataVersionRec RETURNS LOGICAL
  (INPUT pcEntityMnemonic AS CHARACTER,
   INPUT phDBRecord       AS HANDLE,
   INPUT pcDBKey          AS CHARACTER,
   INPUT phDVRecord       AS HANDLE,
   INPUT pcLock           AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainTableRec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD obtainTableRec Procedure 
FUNCTION obtainTableRec RETURNS LOGICAL
  ( INPUT pcDelimiter  AS CHARACTER,
    INPUT pcFieldList  AS CHARACTER,
    INPUT pcFieldValue AS CHARACTER,
    INPUT phTableBuff  AS HANDLE,
    INPUT pcLockType   AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainTempTableRec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD obtainTempTableRec Procedure 
FUNCTION obtainTempTableRec RETURNS LOGICAL
  ( INPUT piRequestNo AS INTEGER,
    INPUT piNodeLevel AS INTEGER,
    INPUT piTableNo   AS INTEGER,
    INPUT phWriteBuff AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-readRecordVersionAttr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD readRecordVersionAttr Procedure 
FUNCTION readRecordVersionAttr RETURNS DECIMAL
  (INPUT piRequestNo AS INTEGER,
   INPUT phNode      AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-registerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD registerObject Procedure 
FUNCTION registerObject RETURNS LOGICAL
  ( INPUT piRequestNo AS INTEGER,
    INPUT pcHandle    AS CHARACTER,
    INPUT phHandle    AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-replaceExt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD replaceExt Procedure 
FUNCTION replaceExt RETURNS LOGICAL
  ( INPUT pcFileName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAttribute Procedure 
FUNCTION setAttribute RETURNS LOGICAL
  ( INPUT piRequestNo   AS INTEGER,
    INPUT pcAttribute   AS CHARACTER,
    INPUT pcValue       AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldLiteral) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldLiteral Procedure 
FUNCTION setFieldLiteral RETURNS LOGICAL
  ( INPUT phHandle AS HANDLE,
    INPUT plSet    AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldValue Procedure 
FUNCTION setFieldValue RETURNS LOGICAL
  ( INPUT piRequestNo    AS INTEGER,
    INPUT phField        AS HANDLE,
    INPUT pcFieldValue   AS CHARACTER,
    INPUT piExtentIndex  AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFileDetails) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFileDetails Procedure 
FUNCTION setFileDetails RETURNS CHARACTER
  ( INPUT pcFileName     AS CHARACTER,
    INPUT pcPath         AS CHARACTER,
    INPUT pcDefaultPath  AS CHARACTER,
    OUTPUT pcRetPath     AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNodeValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNodeValue Procedure 
FUNCTION setNodeValue RETURNS LOGICAL
  ( INPUT piRequestNo   AS INTEGER,
    INPUT piNodeLevel   AS INTEGER,
    INPUT piTableNo     AS INTEGER,
    INPUT pcNodeName    AS CHARACTER,
    INPUT piExtentIndex AS INTEGER,
    INPUT pcValue       AS CHARACTER,
    INPUT plDelete      AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setupQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setupQuery Procedure 
FUNCTION setupQuery RETURNS HANDLE
  ( INPUT phBuffer AS HANDLE,
    INPUT pcQueryString AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateChangesetRycsoFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD updateChangesetRycsoFields Procedure 
FUNCTION updateChangesetRycsoFields RETURNS LOGICAL PRIVATE
        ( input phRycso              as handle,
          input phChangeset          as handle         ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeContainedRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD writeContainedRecord Procedure 
FUNCTION writeContainedRecord RETURNS LOGICAL
  ( INPUT phNode           AS HANDLE,
    INPUT phBuff           AS HANDLE,
    INPUT pcEntityMnemonic AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeDataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD writeDataset Procedure 
FUNCTION writeDataset RETURNS INTEGER
  ( INPUT phNode          AS HANDLE,
    INPUT plDeletions     AS LOGICAL,
    INPUT plDeletionsOnly AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeDatasetDeletions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD writeDatasetDeletions Procedure 
FUNCTION writeDatasetDeletions RETURNS INTEGER
  ( INPUT phRecordNode AS HANDLE,
    INPUT pcEntityMnemonic AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeDatasetHeader) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD writeDatasetHeader Procedure 
FUNCTION writeDatasetHeader RETURNS LOGICAL
  ( INPUT phNode       AS HANDLE,
    INPUT phBuff       AS HANDLE,
    INPUT plAbbrHeader AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeEntityNodes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD writeEntityNodes Procedure 
FUNCTION writeEntityNodes RETURNS LOGICAL
  (INPUT pdObj        AS DECIMAL,  
   INPUT phNode       AS HANDLE,
   INPUT plAbbrHeader AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeRecordVersionAttr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD writeRecordVersionAttr Procedure 
FUNCTION writeRecordVersionAttr RETURNS LOGICAL
  ( INPUT pcEntityMnemonic AS CHARACTER, 
    INPUT phBuff           AS HANDLE,
    INPUT pcKey            AS CHARACTER,
    INPUT phRecordNode     AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeVersionAttr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD writeVersionAttr Procedure 
FUNCTION writeVersionAttr RETURNS LOGICAL
  ( INPUT phRecordNode AS HANDLE,
    INPUT phRVBuffer   AS HANDLE )  FORWARD.

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 37.43
         WIDTH              = 102.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-applyDeleteList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyDeleteList Procedure 
PROCEDURE applyDeleteList :
/*------------------------------------------------------------------------------
  Purpose:     This procedure goes through all the data in the ttDeleteList
               table, tries to find the appropriate record in the temp-tables,
               and if it does not succeed, it deletes the record off the 
               database. It also deletes the related gst_record_version.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER piRequestNo AS INTEGER    NO-UNDO.

  DEFINE BUFFER bttDeleteList       FOR ttDeleteList.
  DEFINE BUFFER bgst_record_version FOR gst_record_version.
  DEFINE BUFFER bttTable            FOR ttTable.
  DEFINE VARIABLE hTTBuffer         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDBBuffer         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cKey              AS CHARACTER  NO-UNDO.
  DISABLE TRIGGERS FOR DUMP OF bgst_record_version.
  DISABLE TRIGGERS FOR LOAD OF bgst_record_version.
  DEFINE VARIABLE cExcludeFields    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTempFields       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrField        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hFromField        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hToField          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount            AS INTEGER    NO-UNDO.


  /* Loop through all the records in the delete list */
  FOR EACH bttDeleteList
    BREAK BY bttDeleteList.cEntityMnemonic:

    IF FIRST-OF(bttDeleteList.cEntityMnemonic) THEN
    DO:
      IF VALID-HANDLE(hTTBuffer) THEN
      DO:
        RUN releasePoolObject /* IN ghObjectPool */
          (hTTBuffer).
        hTTBuffer = ?.
      END.
      IF VALID-HANDLE(hDBBuffer) THEN
      DO:
        RUN releasePoolObject /* IN ghObjectPool */
          (hDBBuffer).
        hDBBuffer = ?.
      END.
      /* Create a buffer for the temp-table and database */
      RUN obtainPoolObject /* IN ghObjectPool */
        ("BUFFER":U, 
         STRING(bttDeleteList.hTTBuffer), 
         OUTPUT hTTBuffer).
      RUN obtainPoolObject /* IN ghObjectPool */
        ("BUFFER":U, 
         bttDeleteList.cDBTable, 
         OUTPUT hDBBuffer).

      /* Disable all the schema triggers on the database table */
      hDBBuffer:DISABLE-LOAD-TRIGGERS(NO).
      hDBBuffer:DISABLE-DUMP-TRIGGERS().

      cExcludeFields = "":U.
      FOR EACH bttTable 
        WHERE bttTable.cEntityMnemonic = bttDeleteList.cEntityMnemonic
          AND bttTable.cExcludeFields  <> "":U:
        cExcludeFields = cExcludeFields + MIN(cExcludeFields,",":U) + bttTable.cExcludeFields.
      END.

      /* Now lets make sure that the fields actually exist in this table */
      cTempFields = "":U.
      DO iCount = 1 TO hTTBuffer:NUM-FIELDS:
        IF CAN-DO(cExcludeFields, hTTBuffer:BUFFER-FIELD(iCount):NAME) THEN
          cTempFields = cTempFields + MIN(cTempFields, ",":U) + hTTBuffer:BUFFER-FIELD(iCount):NAME.
      END.

      cExcludeFields = cTempFields.

    END.

    /* Try and find the database record for this delete list entry. */
    IF bttDeleteList.lHasObj AND
       bttDeleteList.cObjFieldList <> "":U AND
       bttDeleteList.cObjFieldList <> ? AND 
       bttDeleteList.cObjFieldValue <> "":U THEN
    DO:
      obtainTableRec(CHR(1), 
                     bttDeleteList.cObjFieldList,
                     bttDeleteList.cObjFieldValue,
                     hDBBuffer,
                     "EXCLUSIVE-LOCK":U).
      cKey = bttDeleteList.cObjFieldValue.
    END.
    
    /* If we don't have a database record available at this point, try and 
       find it on the key value */
    IF NOT hDBBuffer:AVAILABLE AND
       bttDeleteList.cKeyFieldList <> "":U AND
       bttDeleteList.cKeyFieldList <> ? THEN
    DO:
      obtainTableRec(CHR(1), 
                     bttDeleteList.cKeyFieldList, 
                     bttDeleteList.cKeyFieldValue, 
                     hDBBuffer,
                     "EXCLUSIVE-LOCK":U).
      cKey = bttDeleteList.cKeyFieldValue.
    END.
    
    /* If the record is available in the database, we need to do a few things. */
    IF hDBBuffer:AVAILABLE THEN
    DO:

      /* If the list of exclude fields is not blank, we need to copy the data from the
         exclude field list fields in the database back to the temp-table so that the
         data in the database is not overwritten */
      IF cExcludeFields <> "":U THEN
      DO:
        /* Try and find the temp-table record for this delete list entry. */
        IF bttDeleteList.lHasObj AND
           bttDeleteList.cObjFieldList <> "":U AND
           bttDeleteList.cObjFieldList <> ? AND 
           bttDeleteList.cObjFieldValue <> "":U THEN
          obtainTableRec(CHR(1), 
                         bttDeleteList.cObjFieldList,
                         bttDeleteList.cObjFieldValue,
                         hTTBuffer,
                         "EXCLUSIVE-LOCK":U).
  
        /* If we don't have a temp-table record available at this point, try and 
           find it on the key value */
        IF NOT hTTBuffer:AVAILABLE AND
           bttDeleteList.cKeyFieldList <> "":U AND
           bttDeleteList.cKeyFieldList <> ? THEN
          obtainTableRec(CHR(1), 
                         bttDeleteList.cKeyFieldList, 
                         bttDeleteList.cKeyFieldValue, 
                         hTTBuffer,
                         "EXCLUSIVE-LOCK":U).
  
        /* If we have a temp-table record available, we need to copy the value of the
           fields from the database to the temp-table.  */
        IF hTTBuffer:AVAILABLE THEN
        DO:
          DO iCount = 1 TO NUM-ENTRIES(cExcludeFields):
            cCurrField = ENTRY(iCount,cExcludeFields).
            hTTBuffer:BUFFER-FIELD(cCurrField):BUFFER-VALUE = hDBBuffer:BUFFER-FIELD(cCurrField):BUFFER-VALUE.
          END.
          hTTBuffer:BUFFER-RELEASE().
        END.
      END.
  
      FIND FIRST bgst_record_version 
        WHERE bgst_record_version.entity_mnemonic  = bttDeleteList.cEntityMnemonic
          AND bgst_record_version.key_field_value  = cKey
        NO-ERROR.
      IF AVAILABLE(bgst_record_version) THEN
        DELETE bgst_record_version.
      hDBBuffer:BUFFER-DELETE().
      hDBBuffer:BUFFER-RELEASE().
    END.

    DELETE bttDeleteList.

  END. /* FOR EACH bttDeleteList */

  /* Just making sure that I have cleaned up behind me. */
  IF VALID-HANDLE(hTTBuffer) THEN
  DO:
    RUN releasePoolObject /* IN ghObjectPool */
      (hTTBuffer).
    hTTBuffer = ?.
  END.
  IF VALID-HANDLE(hDBBuffer) THEN
  DO:
    RUN releasePoolObject /* IN ghObjectPool */
      (hDBBuffer).
    hDBBuffer = ?.
  END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildDeleteList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildDeleteList Procedure 
PROCEDURE buildDeleteList :
/*------------------------------------------------------------------------------
  Purpose:     Scans the databasefor all data in the dataset that may need to be
               deleted before the import.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER piRequestNo      AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcParentEM       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plTop            AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER phParentBuffer   AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER plDelete         AS LOGICAL    NO-UNDO.

  DEFINE BUFFER bttTable      FOR ttTable.
  DEFINE BUFFER bttTableProps FOR ttTableProps.
  DEFINE BUFFER bttDeleteList FOR ttDeleteList.
  DEFINE BUFFER bttTableList  FOR ttTableList.
  DEFINE BUFFER bttEntityList FOR ttEntityList.

  DEFINE VARIABLE hQuery            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cForEach          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lChildDelete      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lKeepOwnSiteData  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cKeyVal           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKey              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjField         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObj              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lHasObj           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAns              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lVersion          AS LOGICAL    NO-UNDO.

  ERROR-STATUS:ERROR = NO.


  /* Iterate through all the dependent tables in the dataset and
     remove the data in them from the list */
  FOR EACH bttTable 
    WHERE bttTable.cJoinMnemonic = pcParentEM:

    FIND FIRST bttTableProps NO-LOCK
      WHERE bttTableProps.cEntityMnemonic = bttTable.cEntityMnemonic
      NO-ERROR.
    IF AVAILABLE(bttTableProps) THEN
    DO:
      lChildDelete     = bttTableProps.lDeleteRelated.
      lKeepOwnSiteData = bttTableProps.lKeepOwnSiteData.
    END.
    ELSE
    DO:
      lChildDelete     = plDelete.
      lKeepOwnSiteData = NO.
    END.
    ERROR-STATUS:ERROR = NO.

    /* Build a for each statement for this buffer */
    RUN obtainPoolObject /* IN ghObjectPool */
      ("BUFFER":U, 
       bttTable.cDatabase + ".":U + bttTable.cTableName, 
       OUTPUT hBuffer).
  
    IF VALID-HANDLE(hBuffer) THEN
      cForEach = buildForEach(hBuffer, 
                              bttTable.cJoinFieldList, 
                              phParentBuffer, 
                              "":U, 
                              bttTable.cWhereClause,
                              YES).
  
    /* Now open a query based on the FOR EACH and the buffer */
    RUN obtainPoolObject /* IN ghObjectPool */
      ("QUERY":U, 
       "":U, 
       OUTPUT hQuery).
    hQuery:SET-BUFFERS(hBuffer).
    hQuery:QUERY-PREPARE(cForEach).
    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST(NO-LOCK).
  
    repeat-blk:
    REPEAT WHILE NOT hQuery:QUERY-OFF-END:

      /* Add the record to the list if it has to be deleted.*/
      IF plDelete THEN
      DO:
        lAns = getEntityData("TT":U,
                             bttTable.cEntityMnemonic,
                             hBuffer,
                             CHR(1),
                             OUTPUT cKeyField,
                             OUTPUT cKey,
                             OUTPUT cObjField,
                             OUTPUT cObj,
                             OUTPUT lHasObj,
                             OUTPUT lVersion).
        /* One more check: Are they keeping their own site data? 
           If they have an obj on the key, and they have elected to keep their
           own site data, let's see if we need to save this data */
        IF lAns AND
           lKeepOwnSiteData AND
           lHasObj AND
           TRIM(ENTRY(2,cObj,".":U)) = STRING(giSiteRev,"999999999":U) THEN
          lAns = NO.

        IF lAns = YES THEN
        DO TRANSACTION:
          /* Find the entity that is related to this table */
          FIND FIRST bttEntityList NO-LOCK
            WHERE bttEntityList.cEntityMnemonic = bttTable.cEntityMnemonic.

          /* Now find the temp-table that contains the data for this table */
          FIND FIRST bttTableList NO-LOCK
            WHERE bttTableList.iRequestNo = piRequestNo
              AND bttTableList.iTableNo   = bttEntityList.iTableNo.

          CREATE bttDeleteList.
          ASSIGN
            giDeleteRec                   = giDeleteRec + 1
            bttDeleteList.cEntityMnemonic = bttTable.cEntityMnemonic
            bttDeleteList.iKey            = giDeleteRec
            bttDeleteList.lHasObj         = lHasObj
            bttDeleteList.cObjFieldList   = cObjField
            bttDeleteList.cObjFieldValue  = cObj
            bttDeleteList.cKeyFieldValue  = cKey
            bttDeleteList.cKeyFieldList   = cKeyField
            bttDeleteList.hTTBuffer       = bttTableList.hTable:DEFAULT-BUFFER-HANDLE
            bttDeleteList.cDBTable        = bttTable.cDatabase + ".":U + bttTable.cTableName
          .

        END.
      END.
      
      ERROR-STATUS:ERROR = NO.
      /* Delete the associated entity records */
      RUN buildDeleteList (piRequestNo,
                           bttTable.cEntityMnemonic,
                           NO,
                           hBuffer,
                           lChildDelete) NO-ERROR.
      IF ERROR-STATUS:ERROR OR 
         (RETURN-VALUE <> "":U AND
          RETURN-VALUE <> ?) THEN
         UNDO repeat-blk, LEAVE repeat-blk.

      /* Get the next record in the query */
      hQuery:GET-NEXT(NO-LOCK).

  
    END. /* REPEAT WHILE NOT hQuery:QUERY-OFF-END */

    /* Close the query and delete the query object */
    hQuery:QUERY-CLOSE().
    RUN releasePoolObject /* IN ghObjectPool */
      (hQuery).
    hQuery = ?.
    RUN releasePoolObject /* IN ghObjectPool */
      (hBuffer).
    hBuffer = ?.

    IF ERROR-STATUS:ERROR OR 
       (RETURN-VALUE <> "":U AND
        RETURN-VALUE <> ?) THEN
       UNDO, LEAVE.
  END. /* FOR EACH bttTable */


  IF ERROR-STATUS:ERROR OR
     (RETURN-VALUE <> "":U AND
      RETURN-VALUE <> ?) THEN
    RETURN ERROR RETURN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildReleaseChangeset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildReleaseChangeset Procedure 
PROCEDURE buildReleaseChangeset :
/*------------------------------------------------------------------------------
  Purpose:     Returns a set of data changes in a particular release.
  Parameters:  (I) pcReleaseVersion
               (I) pcPreviousRelease
               (O) ttReleaseChangeset
  Notes:       - Typically used by the Deployment Automation process
------------------------------------------------------------------------------*/
    define input  parameter pcToReleaseVersion     as character            no-undo.
    define input  parameter pcFromReleaseVersion   as character            no-undo.
    define input  parameter plCreateReleaseVersion as logical              no-undo.
    define input  parameter plResetDataModified    as logical              no-undo.
    define output parameter table for ttReleaseChangeset.
    
    define variable dFromObj                as decimal                    no-undo.
    define variable dToObj                  as decimal                    no-undo.
    define variable hBuffer                 as handle                     no-undo.
    define variable hField                  as handle                     no-undo.
    define variable cWhere                  as character                  no-undo.
    define variable iCount                  as integer                    no-undo.
    
    define buffer gstrl for gst_release_version.
    define buffer gstrl_from for gst_release_version.
    define buffer gstrv for gst_record_version.
    define buffer gsmrl for gsm_release.
    define buffer gscem for gsc_entity_mnemonic.
    define buffer gscde for gsc_dataset_entity.
    define buffer gscdd for gsc_deploy_dataset.
    define buffer lbChangeset for ttReleaseChangeset.
    
    /* Gotta have a 'to' release */
    if pcToReleaseVersion eq ? or pcToReleaseVersion eq '':u then
        return error {aferrortxt.i 'AF' '1' '?' '?' '"release version"'}.
        
    find first gsmrl where gsmrl.release_number = pcToReleaseVersion no-lock no-error.
    if not available gsmrl then
        return error {aferrortxt.i 'AF' '5' '?' '?' '"release version"' "'Release version=' + pcToReleaseVersion"}.
    
    dToObj = gsmrl.release_obj.
    
    /* If no from release specified, or if the from and to releases are the same,
       get everything that's changed. */
    if pcToReleaseVersion eq ? or 
       pcFromReleaseVersion eq pcToReleaseVersion then
        pcToReleaseVersion = '':u.
    
    find first gsmrl where gsmrl.release_number = pcFromReleaseVersion no-lock no-error.
    if available gsmrl then
        dFromObj = gsmrl.release_obj.
    else
        dFromObj = 0.
    
    empty temp-table lbChangeset.
    
    /* Lets make sure that the version numbers are all properly set */
    if plCreateReleaseVersion then
        run createReleaseVersion in target-procedure (plResetDataModified).
    
    for each gstrl where
             gstrl.release_obj = dToObj
             no-lock,
       first gstrv where
             gstrv.record_version_obj = gstrl.record_version_obj
             no-lock,
       first gscem where
             gscem.entity_mnemonic = gstrv.entity_mnemonic and
             gscem.version_data = Yes
             no-lock,
       first gscde where
             gscde.entity_mnemonic = gscem.entity_mnemonic and
             gscde.primary_entity = Yes
             no-lock,
       first gscdd where
             gscdd.deploy_dataset_obj = gscde.deploy_dataset_obj
             no-lock
       break by gscem.entity_mnemonic:
        
        if first-of(gscem.entity_mnemonic) then
        do:
            if valid-handle(hBuffer) then
                run releasePoolObject in target-procedure (hBuffer).
            
            run obtainPoolObject in target-procedure ('Buffer':u,
                                                      gscem.entity_dbname + '.':u + gscem.entity_mnemonic_description,
                                                      output hBuffer).
        end.    /* first of */
        
        /* if there is a previous release, get it and compare against 
           the current version. */
        if dFromObj ne 0 then
        do:
            find gstrl_from where
                 gstrl_from.release_obj = dFromObj and
                 gstrl_from.record_version_obj = gstrl.record_version_obj
                 no-lock no-error.
            if available gstrl_from and
               gstrl_from.version_number_seq eq gstrl.version_number_seq then
                next.
        end.    /* there's a from release */
        
        create lbChangeset.
        assign lbChangeset.DatasetCode = gscdd.dataset_code
               lbChangeset.EntityMnemonic = gscem.entity_mnemonic
               lbChangeset.KeyField = gscem.entity_object_field
               lbChangeset.KeyFieldValue = gstrv.key_field_value
               lbChangeset.SecondaryFieldName =  gscem.entity_key_field
               lbChangeset.SecondaryFieldValue = gstrv.secondary_key_value
               lbChangeset.Deletion = gstrv.deletion_flag
               /* This is used to build Datasets when dumping. The
                   Key and Secondary fields above are taken from the
                   actual record version. */
               lbChangeset.DSKeyField = gscde.join_field_list.
               
        /* no path */
        lbChangeset.DatasetADOFilename = lc(if gscdd.default_ado_filename eq '':u then
                                                gscdd.dataset_code
                                            else gscdd.default_ado_filename)
                                       + '.ado':u.
        
        if not lbChangeset.Deletion then
        do:
            /* Find the relevant record so as to derive the ADO name as well as the value
                   of the dataset's join field list. */
            cWhere = 'Where ':u
                   + dynamic-function('buildWhereFromKeyVal':u in target-procedure,
                                       chr(1),
                                       (if gscem.table_has_object_field then gscem.entity_object_field else gscem.entity_key_field),
                                       gstrv.key_field_value,
                                       hBuffer).
            if cWhere eq ? or cWhere eq '':u then
                next.
            
            hBuffer:find-first( cWhere, no-lock) no-error.
            error-status:error = no.
            if hBuffer:available then
            do:
                /* Now we need to build up the record key on the format of the primary 
                          entity in the dataset */
                do iCount = 1 to num-entries(gscde.join_field_list):
                    hField = hBuffer:buffer-field(entry(iCount, gscde.join_field_list)) no-error.
                    lbChangeset.DSKeyFieldValue = lbChangeset.DSKeyFieldValue + chr(3)
                                                + (if valid-handle(hField) then string(hField:Buffer-Value) else '?':u).
                end.    /* loop through fields */
                lbChangeset.DSKeyFieldValue = left-trim(lbChangeset.DSKeyFieldValue, chr(3)).
                
                /* Determine the name of the ADO file that w will dump into. */
                if gscdd.source_code_data and not gstrv.deletion_flag then
                do:
                    /* Path may be included, depends on the object */
                    lbChangeset.RecordADOFilename = dynamic-function('getFilenameFromField':u in target-procedure,
                                                                      gscde.join_field_list, hBuffer).
                    
                    if lbChangeset.RecordADOFilename eq ? then
                        lbChangeset.RecordADOFilename = '':u.
                end.    /* source code data */     
                
                /* There are certain fields that we need on the RYCSO object to avoid having to
                   do an other call to the DB/AppS later. Add them now. */
                if lbChangeset.DatasetCode eq 'Rycso':u then
                    dynamic-function('updateChangesetRycsoFields':u in target-procedure,
                                     hBuffer, buffer lbChangeset:handle).        
            end.    /* avialable buffer record */
        end.    /* not a deletion */
    end.    /* each release version, record version */
    
    error-status:error = no.
    return.
END PROCEDURE.    /* buildReleaseChangeset  */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildStructFromDB) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildStructFromDB Procedure 
PROCEDURE buildStructFromDB :
/*------------------------------------------------------------------------------
  Purpose:     This procedure constructs a temp-table for each dataset entity 
               in the dataset from the database definitions of the table. 
  Parameters:  
    pcDatasetCode  - the dataset code to build temp-table structures for.
    
    piNoTables     - the number of tables constructed.
    
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT        PARAMETER pcDatasetCode AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER piRequestNo   AS INTEGER    NO-UNDO.
  DEFINE OUTPUT       PARAMETER piNoTables    AS INTEGER    NO-UNDO.
  
  DEFINE VARIABLE cDBName               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTableName            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTempTableName        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQualTable            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectField          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRetVal               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldList            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cIndexName            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTable                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iIndexNo              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNoTables             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRequestNo            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lPrimaryIndex         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAns                  AS LOGICAL    NO-UNDO.
  
  DEFINE BUFFER bgsc_deploy_dataset     FOR gsc_deploy_dataset.
  DEFINE BUFFER bgsc_dataset_entity     FOR gsc_dataset_entity.
  DEFINE BUFFER bgsc_entity_mnemonic    FOR gsc_entity_mnemonic.
  DEFINE BUFFER bttIndexList            FOR ttIndexList.
  DEFINE BUFFER bttTable                FOR ttTable.
  DEFINE BUFFER bttTableList            FOR ttTableList.
  DEFINE BUFFER bttEntityList           FOR ttEntityList.
  DEFINE BUFFER bttRelatedEntity        FOR ttEntityList.

  iNoTables = 0.

  /* If a request no was supplied, use that request, otherwise
     get a new request no. */
  IF piRequestNo = 0 THEN
  DO:  
    giRequestNo = giRequestNo + 1.
    iRequestNo = giRequestNo.
  END.
  ELSE
  DO:
    iRequestNo = piRequestNo.
  END.

  /* delete the existing temp table stuff for the request */
  deleteTempTables(iRequestNo).
  
  /* Check if the deployment set exists */
  FIND FIRST bgsc_deploy_dataset NO-LOCK
    WHERE bgsc_deploy_dataset.dataset_code = pcDatasetCode
    NO-ERROR.
  IF NOT AVAILABLE(bgsc_deploy_dataset) THEN
  DO:
    cMessage = "dataset_code = ":U + pcDatasetCode.
    cRetVal = {af/sup2/aferrortxt.i 'AF' '11' 'gsc_deploy_dataset' 'dataset_code' '"gsc_deploy_dataset"' cMessage}.
    RETURN cRetVal.
  END.
  
  /* Empty the entity list table */
  EMPTY TEMP-TABLE bttEntityList.
  EMPTY TEMP-TABLE bttTable.
  /* Loop through the dataset entity table */
  FOR EACH bgsc_dataset_entity NO-LOCK
      WHERE bgsc_dataset_entity.deploy_dataset_obj = bgsc_deploy_dataset.deploy_dataset_obj
    BY bgsc_dataset_entity.deploy_dataset_obj
    BY bgsc_dataset_entity.entity_sequence:

    /* Find the entity mnemonic for the dataset entity */
    FIND FIRST bgsc_entity_mnemonic NO-LOCK
      WHERE bgsc_entity_mnemonic.entity_mnemonic = bgsc_dataset_entity.entity_mnemonic
      NO-ERROR.
    IF NOT AVAILABLE(bgsc_entity_mnemonic) THEN
       NEXT.

    CREATE bttTable.
    ASSIGN
      bttTable.iEntitySeq      = bgsc_dataset_entity.entity_sequence
      bttTable.cEntityMnemonic = bgsc_entity_mnemonic.entity_mnemonic
      bttTable.cDatabase       = bgsc_entity_mnemonic.entity_dbname
      bttTable.cTableName      = bgsc_entity_mnemonic.entity_mnemonic_description
      bttTable.lPrimary        = bgsc_dataset_entity.primary_entity
      bttTable.cJoinMnemonic   = bgsc_dataset_entity.join_entity_mnemonic
      bttTable.cJoinFieldList  = bgsc_dataset_entity.join_field_list
      bttTable.cWhereClause    = bgsc_dataset_entity.filter_where_clause
      bttTable.cExcludeFields  = bgsc_dataset_entity.exclude_field_list
      bttTable.hBuffer         = ?.

    /* Make sure there's an entry for this table in the temp-table */
    FIND bttEntityList 
      WHERE bttEntityList.cEntityMnemonic = bgsc_dataset_entity.entity_mnemonic
      NO-ERROR.
    IF NOT AVAILABLE(bttEntityList) THEN
    DO:
      CREATE bttEntityList.
      ASSIGN
        bttEntityList.cEntityMnemonic = bgsc_dataset_entity.entity_mnemonic
        bttEntityList.cDatabase       = bgsc_entity_mnemonic.entity_dbname
        bttEntityList.cTableName      = bgsc_entity_mnemonic.entity_mnemonic_description
        bttEntityList.cJoinMnemonic   = bgsc_dataset_entity.join_entity_mnemonic
        bttEntityList.cJoinFieldList  = bgsc_dataset_entity.join_field_list
        bttEntityList.cObjField       = bgsc_entity_mnemonic.entity_object_field
        bttEntityList.cKeyField       = bgsc_entity_mnemonic.entity_key_field
        bttEntityList.lHasObj         = bgsc_entity_mnemonic.table_has_object_field
        bttEntityList.lVersionData    = bgsc_entity_mnemonic.version_data
        bttEntityList.hBuffer         = ?
      .
    END.
  END. /* FOR EACH bgsc_dataset_entity */

  FOR EACH bttEntityList:
    
    /* Create the temp-table */
    RUN obtainPoolObject /* IN ghObjectPool */
      ("TEMP-TABLE":U, 
       pcDatasetCode + "." + bttEntityList.cEntityMnemonic, 
       OUTPUT hTable).

    IF NOT hTable:PREPARED THEN
    DO:

      /* Get the database and table name */
      ASSIGN
        cDBName    = bttEntityList.cDatabase
        cTableName = bttEntityList.cTableName
        .
      /* Qualify the table name with the database name if
         we know what database the table lives in */
      IF cDBName <> ? AND
         cDBName <> "":U THEN
        cQualTable = cDBName + ".":U.

      /* Tag on the table name. */
      cQualTable = cQualTable + cTableName.
      
      cObjectField = "":U.
      
      RUN obtainPoolObject /* IN ghObjectPool */
        ("BUFFER":U, 
         cQualTable, 
         OUTPUT hBuffer).


      /* Loop through the fields in the buffer */
      DO iCount = 1 TO hBuffer:NUM-FIELDS:
  
        /* Get the handle to the field. */
        hField = hBuffer:BUFFER-FIELD(iCount).
  
        /* Add the field to the temp-table */
        hTable:ADD-LIKE-FIELD(hField:NAME, hField).
  
        /* If this is the object field, set the object field variable */
        IF hField:NAME = bttEntityList.cObjField THEN
          cObjectField = hField:NAME.
        
      END.
    
      /* Now we need to add a field that can contain the record_version_obj
         of the incoming record version */
      hTable:ADD-NEW-FIELD("oRVObj":U, 
                           "DECIMAL":U, 
                           0, 
                           "->>>>>>>>>>>>>>>>>9.999999999":U, 
                           0.0,
                           "Record Version Obj").
                          
      /* Make sure the index list is empty */
      EMPTY TEMP-TABLE bttIndexList.
      iIndexNo = 0.
  
      /* Create on Object Field index if there is one defined */
      IF cObjectField <> "":U AND
         bttEntityList.lHasObj THEN
      DO:
        iIndexNo = iIndexNo + 1.
        CREATE bttIndexList.
        ASSIGN
          bttIndexList.iIndexNo   = iIndexNo
          bttIndexList.cFieldList = cObjectField
          bttIndexList.lUnique    = YES
          .
      END.
      
      /* If the key field is not blank, we need to construct a 
         key record for it */
      IF bttEntityList.cKeyField <> "":U AND
         bttEntityList.cKeyField <> cObjectField THEN
      DO:
        iIndexNo = iIndexNo + 1.
        CREATE bttIndexList.
        ASSIGN
          bttIndexList.iIndexNo   = iIndexNo
          bttIndexList.cFieldList = bttEntityList.cKeyField
          bttIndexList.lUnique    = YES
          .
      END.
       
      /* Now create indexes on all the fields that are used by the joins in the
         datasets.  */
      FOR EACH bttRelatedEntity NO-LOCK
        WHERE bttRelatedEntity.cJoinMnemonic = bttEntityList.cEntityMnemonic:
  
        
        cFieldList = "":U.
        /* Walk through the join_field_list and add an index composed of every second
           field in the list. */
        DO iCount = 2 TO NUM-ENTRIES(bttRelatedEntity.cJoinFieldList) BY 2:
          cFieldList = cFieldList + (IF cFieldList <> "":U THEN ",":U ELSE "":U)
                     + ENTRY(iCount,bttRelatedEntity.cJoinFieldList).
        END.
  
        /* Now try and find a record for this index */
        FIND FIRST bttIndexList NO-LOCK
          WHERE bttIndexList.cFieldList = cFieldList
          NO-ERROR.
        /* If we didn't find a record, create it */
        IF NOT AVAILABLE(bttIndexList) THEN
        DO:
          iIndexNo = iIndexNo + 1.
          CREATE bttIndexList.
          ASSIGN
            bttIndexList.iIndexNo   = iIndexNo
            bttIndexList.cFieldList = cFieldList
            bttIndexList.lUnique    = NO /* We don't want this index created UNIQUE */
            .
        END.
      END. /* FOR EACH bttRelatedEntity */
  
      /* Set the primary index flag so that the first index created
         is set to primary */
      lPrimaryIndex = YES.
  
      /* Now we need to actually add the indexes to the temp-table */
      for-each-blk:
      FOR EACH bttIndexList 
        BY bttIndexList.iIndexNo:
           
          /*cFieldList now stores a list of handles */
          cFieldList = "":U.
  
          /* Try and get a handle to each field in the string so that we know 
             that it exists on the buffer. This validates that the fields exist
             before we add them to the index. */
          DO iCount = 1 TO NUM-ENTRIES(bttIndexList.cFieldList):
            /* Get the field's handle */
            hField = hBuffer:BUFFER-FIELD(ENTRY(iCount,bttIndexList.cFieldList)) NO-ERROR.
            /* If we did not successfully get the field handle, skip the field. This is
               an error in the dataset definition, but we're not going to worry about this
               here. It will be handled later */
            IF ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 0 THEN
            DO:
              ERROR-STATUS:ERROR = NO.
              NEXT for-each-blk.
            END.
  
            /* We have success. Add the field handle to the field list */
            cFieldList = cFieldList + (IF cFieldList = "":U THEN "":U ELSE ",":U)
                       + STRING(hField).
          END.
  
          /* If we make it this far we have a string of handles that we
             can add to the index */
          cIndexName = (IF lPrimaryIndex THEN "p":U ELSE "":U) 
                     + (IF bttIndexList.lUnique THEN "u":U ELSE "":U)
                     + "dx":U
                     + STRING(bttIndexList.iIndexNo,"999":U).
          hTable:ADD-NEW-INDEX(cIndexName,
                               bttIndexList.lUnique, /* Is index unique */
                               lPrimaryIndex).       /* Is index primary */
          lPrimaryIndex = NO.
          DO iCount = 1 TO NUM-ENTRIES(cFieldList):
            /* Get the handle to the field again. */
            hField = WIDGET-HANDLE(ENTRY(iCount,cFieldList)).
            IF VALID-HANDLE(hField) THEN
              hTable:ADD-INDEX-FIELD(cIndexName, hField:NAME).
          END.
      END. /* FOR EACH bttIndexList */
  
      /* Make sure the index list is empty */
      EMPTY TEMP-TABLE bttIndexList.
      
      /* Set up the table name */
      cTempTableName =  "tt_":U + hBuffer:NAME.


      /* We won't use the table buffer again, so lets delete it. 
         NOTE that if you do this any later you will cause memory leaks. */
      RUN releasePoolObject /* IN ghObjectPool */
        (hBuffer).
      hBuffer = ?.
  
      /* We've added all fields and indexes to the table, so now
         we can prepare it */
      lAns = hTable:TEMP-TABLE-PREPARE(cTempTableName) NO-ERROR.
      {af/sup2/afcheckerr.i
        &errors-not-zero = YES
        &no-return = YES}
      IF NOT lAns OR
         cMessageList <> "":U THEN
      DO:
        cRetVal = {af/sup2/aferrortxt.i 'AF' '119' '?' '?' cTempTableName cMessageList}.
        RUN releasePoolObject /* IN ghObjectPool */
          (hTable).
        hTable = ?.
        deleteTempTables(iRequestNo).
        RETURN cRetVal.
      END.
    END. /* IF hTable:PREPARED */
    
    /* Now we have a temp-table */
    IF VALID-HANDLE(hTable) THEN
    DO:
      iNoTables = iNoTables + 1.
      CREATE bttTableList.
      ASSIGN
        bttTableList.iRequestNo = iRequestNo
        bttTableList.iTableNo   = iNoTables
        bttTableList.cEntityMnemonic = bttEntityList.cEntityMnemonic
        bttTableList.cTableName = bttEntityList.cTableName
        bttTableList.cDBName    = bttEntityList.cDatabase
        bttTableList.hTable     = hTable
        .
    END.

    /* Store the table number of this entity. */
    ASSIGN
     bttEntityList.iTableNo = bttTableList.iTableNo
     .

  END. /* FOR EACH bttEntityList */

  piRequestNo = iRequestNo.
  piNoTables = iNoTables.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-changeRVCriteria) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeRVCriteria Procedure 
PROCEDURE changeRVCriteria :
/*------------------------------------------------------------------------------
  ACCESS_LEVEL = PUBLIC
  
  Purpose:     This procedure allows the user to change the fields on the entity
               mnemonic that affect record versioning. This is a VERY dangerous
               API to call as it affects large amounts of data and is not 
               reversible.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcEntity            AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcTable             AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plPreVersionData    AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plPostVersionData   AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plPreTableHasObj    AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plPostTableHasObj   AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcPreObjField       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcPostObjField      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcPreKeyField       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcPostKeyField      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plPreReuseDelKey    AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plPostReuseDelKey   AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE hBuffer                         AS HANDLE       NO-UNDO.
  DEFINE VARIABLE cTable                          AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cWhereClause                    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cKeyFieldValue                  AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cSecondaryKeyValue              AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cUserLogin                      AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE iCount                          AS INTEGER    NO-UNDO.

  DEFINE BUFFER bgst_record_version  FOR gst_record_version.
  DEFINE BUFFER bgst_release_version FOR gst_release_version.

  /* Get the current user's login - we'll need this later and it's cheaper
    to do it once here than on every iteration of record that we need to update */
  cUserLogin = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                INPUT "currentUserLogin":U,
                                INPUT NO).

/*
  IF NOT VALID-HANDLE(ghObjectPool) THEN
    /* Start the Object Pool */
    RUN startProcedure IN THIS-PROCEDURE ("PERSIST|ry/prc/ryobjectpoolp.p":U, 
                                          OUTPUT ghObjectPool).
  */
  
  RUN obtainPoolObject /* IN ghObjectPool */
    ("BUFFER":U, 
     pcTable, 
     OUTPUT hBuffer).

  for-blk:
  FOR EACH bgst_record_version EXCLUSIVE-LOCK
    WHERE bgst_record_version.entity_mnemonic = pcEntity
    TRANSACTION ON ERROR UNDO for-blk, LEAVE for-blk:

    /* If they are no longer reusing deleted keys, we need to get rid of the 
       deletion records.
       If they have just switched on reuse of deleted keys we need to make sure
       that we clear out any deletions that are in the record_version table.
       If they have changed the version data flag from on to off, we should
       get rid of all record_version records. 
       If they have changed the version data flag from off to on, there should
       be no record_version records anyway, but we need to makes sure because
       they may have come in through a deployment. */
    IF (NOT plPostReuseDelKey AND bgst_record_version.deletion_flag) OR
       (plPreReuseDelKey = NO AND plPostReuseDelKey = YES AND bgst_record_version.deletion_flag) OR
        plPreVersionData <> plPostVersionData THEN
    DO:
      FOR EACH bgst_release_version
        WHERE bgst_release_version.record_version_obj = bgst_record_version.record_version_obj:
        DELETE bgst_release_version.
      END.
      DELETE bgst_record_version.
      NEXT for-blk.
    END.

    IF bgst_record_version.deletion_flag THEN
      NEXT for-blk.

    /* Now we need to find the record with the old key criteria on the record version table. 
       To do this we need to buil up the where clause to use to find the record. */
    IF plPreTableHasObj THEN
      cWhereClause = "WHERE ":U + buildWhereFromKeyVal(CHR(1),
                                          pcPreObjField,
                                          bgst_record_version.key_field_value,
                                          hBuffer).
    ELSE
      cWhereClause = "WHERE ":U + buildWhereFromKeyVal(CHR(1),
                                         pcPreKeyField,
                                         bgst_record_version.key_field_value,
                                         hBuffer).

    IF cWhereClause = "":U OR
       cWhereClause = ? THEN
      NEXT.

    /* Now we actually try the find. */
    hBuffer:FIND-FIRST(cWhereClause, NO-LOCK) NO-ERROR.
    ERROR-STATUS:ERROR = NO.

    /* If we can't find a parent record, delete the release and record version data for this
       record. */
    IF NOT hBuffer:AVAILABLE THEN
    DO:
      FOR EACH bgst_release_version
        WHERE bgst_release_version.record_version_obj = bgst_record_version.record_version_obj:
        DELETE bgst_release_version.
      END.
      DELETE bgst_record_version.
      NEXT for-blk.
    END.

    /* Now figure out what the key values are based on the new key criteria */
    RUN calcRVKey IN gshRIManager
      (plPostTableHasObj,
       pcPostObjField,
       pcPostKeyField,
       INPUT hBuffer,
       OUTPUT cKeyFieldValue,
       OUTPUT cSecondaryKeyValue).

    /* If any of the key criteria doesn't match, we need to change this record. */
    IF cKeyFieldValue     <> bgst_record_version.key_field_value OR
       cSecondaryKeyValue <> bgst_record_version.secondary_key_value THEN
    DO:

      RUN calcLastVersionNo IN gshRIManager
        (INPUT        bgst_record_version.version_number_seq,
         INPUT        bgst_record_version.import_version_number_seq,
         INPUT-OUTPUT bgst_record_version.last_version_number_seq).

      ASSIGN
        bgst_record_version.key_field_value         = cKeyFieldValue
        bgst_record_version.secondary_key_value     = cSecondaryKeyValue
        bgst_record_version.last_version_number_seq = bgst_record_version.last_version_number_seq + 1
        bgst_record_version.version_number_seq      = bgst_record_version.last_version_number_seq
        bgst_record_version.version_date            = TODAY
        bgst_record_version.version_time            = TIME
        bgst_record_version.version_user            = cUserLogin
      .
    END.

  END.
  
  RUN releasePoolObject /* IN ghObjectPool */
    (hBuffer).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cleanupRequest) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cleanupRequest Procedure 
PROCEDURE cleanupRequest :
/*------------------------------------------------------------------------------
  Purpose:     Empties all the temp-tables for a request.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER piRequest AS INTEGER    NO-UNDO.

  
  /* Make sure we delete all the temp-tables we created in this persistent
     procedure */
  deleteTempTables(piRequest).

  /* Make sure we delete all the objects that we created */
  deleteReqHandles(piRequest).

  /* Make sure we delete all the attributes */
  deleteAttributes(piRequest).

  deleteTransactions(piRequest).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearRetVal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearRetVal Procedure 
PROCEDURE clearRetVal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  ERROR-STATUS:ERROR = NO.
  RETURN "":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createReleaseVersion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createReleaseVersion Procedure 
PROCEDURE createReleaseVersion :
/*------------------------------------------------------------------------------
  Purpose:     This procedure ensures that there is a gst_record_version record
               for every object in the repository that has record versioning 
               switched on. It then writes every gst_record_version record to
               the gst_release_version table to effectively cut a release.
  Parameters: 
    <none>
    
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER plResetMod  AS LOGICAL    NO-UNDO.

    DEFINE BUFFER bgsm_release          FOR gsm_release.
    DEFINE BUFFER bgst_record_version   FOR gst_record_version.
    DEFINE BUFFER bgst_release_version  FOR gst_release_version.


    DEFINE VARIABLE cLatestRelease      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dLatestRelease      AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE cErrMess            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iCount              AS INTEGER    NO-UNDO.

    DEFINE VARIABLE cUserLogin                      AS CHARACTER    NO-UNDO.

    RUN currentRelease (OUTPUT dLatestRelease, OUTPUT cLatestRelease).

    /* First make sure that the release record actually exists */
    FIND FIRST bgsm_release NO-LOCK
      WHERE bgsm_release.release_number = cLatestRelease
      NO-ERROR.

    IF NOT AVAILABLE(bgsm_release) THEN
    DO:
      cErrMess = "Release record|Release number " + cLatestRelease + " is not on file.".
      RETURN  {af/sup2/aferrortxt.i 'AF' '39' 'gsm_release' 'release_number' "cErrmess"}.
    END.

    /* Get the current user's login - we'll need this later and it's cheaper
      to do it once here than on every iteration of record that we need to update */
    cUserLogin = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                  INPUT "currentUserLogin":U,
                                  INPUT NO).
    
    /* Now we need to verify that the gst_record_version records are all correct */
    PUBLISH "DSAPI_StatusUpdate":U
      ("Verifying record version data...").

    RUN verifyRecordVersions 
      ("*":U) 
      NO-ERROR. 
    IF ERROR-STATUS:ERROR OR
       (RETURN-VALUE <> "":U AND
        RETURN-VALUE <> ?) THEN
      RETURN RETURN-VALUE.
     
    /* Now loop through every gst_record_version that exists and make sure that
       there is a record for it created in the gst_release_version table */
    PUBLISH "DSAPI_StatusUpdate":U
      ("Updating release version data...").
    FOR EACH bgst_record_version EXCLUSIVE-LOCK
      ON ERROR UNDO, RETURN ERROR RETURN-VALUE:
      
      IF plResetMod THEN
      DO:
        ASSIGN
          bgst_record_version.version_number_seq        = ABS(bgst_record_version.version_number_seq)
          bgst_record_version.import_version_number_seq = bgst_record_version.version_number_seq
        .
      END.

      FIND FIRST bgst_release_version EXCLUSIVE-LOCK
        WHERE bgst_release_version.release_obj        = bgsm_release.release_obj
          AND bgst_release_version.record_version_obj = bgst_record_version.record_version_obj
        NO-ERROR.
      IF NOT AVAILABLE(bgst_release_version) THEN
      DO:
        CREATE bgst_release_version.
        ASSIGN
          bgst_release_version.release_obj                = bgsm_release.release_obj
          bgst_release_version.record_version_obj         = bgst_record_version.record_version_obj
          .
      END.
      ASSIGN
        bgst_release_version.version_number_seq         = ABS(bgst_record_version.version_number_seq)
        bgst_release_version.import_version_number_seq  = ABS(bgst_record_version.import_version_number_seq)
        bgst_release_version.deletion_flag              = bgst_record_version.deletion_flag
      .
    END.
      
    DO TRANSACTION ON ERROR UNDO, RETURN ERROR RETURN-VALUE:
      FIND CURRENT bgsm_release EXCLUSIVE-LOCK 
        NO-ERROR.

      ASSIGN
        bgsm_release.release_date = TODAY
        bgsm_release.release_time = TIME
        bgsm_release.release_user = cUserLogin
        .
    END.

    RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createSetupIncludeFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createSetupIncludeFile Procedure 
PROCEDURE createSetupIncludeFile :
/*------------------------------------------------------------------------------
  Purpose:    Generates an XML file based on the SetupInclude dataset
  Parameters: (I) pcPatchFilename
              (I) pcEncoding
              (I) DS SetupInclude
  Notes:     - The SetupInclude dataset is defined in {af/app/afstpincds.i}
             - This API can be used to create patch.xml and adolist.xml files
             - Typically called from Deployment Automation (af/app/afdeplymtp.p)
------------------------------------------------------------------------------*/
    define input parameter pcPatchFile         as character            no-undo.
    define input parameter pcEncoding          as character            no-undo.
    define input parameter dataset for SetupInclude.
    
    define variable lOok            as logical                        no-undo.
    
    if pcPatchFile eq ? or pcPatchFile eq '':u then
        return error {aferrortxt.i 'AF' '1' '?' '?' '"patchfile"'}.
    
    /* UTF-8 makes a good default for XML */
    if pcEncoding eq ? or pcEncoding eq '':u then
        pcEncoding = 'utf-8':u.
    
    lOok = dataset SetupInclude:write-xml('File':u,
                                          pcPatchFile,
                                          Yes,    /* Formatted */
                                          pcEncoding,
                                          ?,    /* schema location */
                                          No    /* Write schema  */ ) no-error.
    if not lOok then
        return error {aferrortxt.i 'AF' '117' '?' '?' '"write"' "pcPatchfile" "error-status:get-message(1)"}.
    
    error-status:error = no.
    return.    
END PROCEDURE.    /* createSetupIncludeFile */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createTopLevelNodes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createTopLevelNodes Procedure 
PROCEDURE createTopLevelNodes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER  phXMLDoc   AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER  phRootNode AS HANDLE     NO-UNDO.

  CREATE X-DOCUMENT phXMLDoc.

  phXMLDoc:ENCODING = "utf-8":U.

  /* Create a table_def node */
  phRootNode = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr,
                               phXMLDoc, 
                               "dataset":U).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-currentRelease) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE currentRelease Procedure 
PROCEDURE currentRelease :
/*------------------------------------------------------------------------------
  ACCESS_LEVEL = PUBLIC
  Purpose:     Returns the object id and release reference of the current release
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pdCurrRelObj    AS DECIMAL    NO-UNDO. 
  DEFINE OUTPUT PARAMETER pcCurrRelRef    AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bgsm_release FOR gsm_release.
  
  pdCurrRelObj = 0.0.
  pcCurrRelRef = "":U.

  /* Find the latest release in the list - this is all we can upgrade to. */
  FOR EACH bgsm_release NO-LOCK
    BY bgsm_release.release_date DESCENDING
    BY bgsm_release.release_time DESCENDING:
    ASSIGN
      pdCurrRelObj  = bgsm_release.release_obj
      pcCurrRelRef  = bgsm_release.release_number
      .
    LEAVE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dbg_writePoolFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dbg_writePoolFile Procedure 
PROCEDURE dbg_writePoolFile :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

OUTPUT TO objectpool.txt.
  FOR EACH ttObjectList 
    BY ttObjectList.cObjectType
    BY ttObjectList.cObjectName
    BY ttObjectList.hObjectHandle:
    EXPORT ttObjectList.cObjectType ttObjectList.cObjectName ttObjectList.lObjectInUse STRING(ttObjectList.hObjectHandle).
  END.
OUTPUT CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteOldData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteOldData Procedure 
PROCEDURE deleteOldData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER piRequestNo    AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER plDeleteFirst  AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plOverwrite    AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER phParentBuffer AS HANDLE     NO-UNDO.
  DEFINE PARAMETER BUFFER pbttTable      FOR ttTable.

  DEFINE VARIABLE lChildDelete           AS LOGICAL    NO-UNDO.

  DEFINE BUFFER bttTableProps FOR ttTableProps.
      
  EMPTY TEMP-TABLE ttDeleteList.  /* There shouldn't be any records in here */

  FIND FIRST bttTableProps NO-LOCK
    WHERE bttTableProps.cEntityMnemonic = pbttTable.cEntityMnemonic
    NO-ERROR.
  IF AVAILABLE(bttTableProps) THEN
    lChildDelete     = bttTableProps.lDeleteRelated.
  ELSE
    lChildDelete     = plDeleteFirst.
  ERROR-STATUS:ERROR = NO.


  /* Lets add the stuff to the delete list that we think may need to be deleted - 
     essentially, all the records in the dataset on the database. */
  RUN buildDeleteList (piRequestNo,
                       pbttTable.cEntityMnemonic,
                       YES,
                       phParentBuffer,
                       lChildDelete) NO-ERROR.
  IF ERROR-STATUS:ERROR OR
     (RETURN-VALUE <> "":U AND
      RETURN-VALUE <> ?) THEN
    RETURN ERROR RETURN-VALUE.

  /* Now we run through the delete list and check whether there is a corresponding
     record in the incoming data. Any that don't have are deleted from the database.
     When this routine is finished, the delete list should be empty and we should only
     have records left that are going to be replaced. */

  RUN applyDeleteList (piRequestNo) NO-ERROR.
  IF ERROR-STATUS:ERROR OR
     (RETURN-VALUE <> "":U AND
      RETURN-VALUE <> ?) THEN
    RETURN ERROR RETURN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deletePool) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deletePool Procedure 
PROCEDURE deletePool :
/*------------------------------------------------------------------------------
  Purpose:     This procedure loops through all the objects in the pool and 
               deletes them.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FOR EACH ttObjectList:
    IF VALID-HANDLE(ttObjectList.hObjectHandle) THEN
    DO:
      IF ttObjectList.hObjectHandle:TYPE = "BUFFER":U THEN
      DO:
        IF ttObjectList.hObjectHandle:AVAILABLE THEN
          ttObjectList.hObjectHandle:BUFFER-RELEASE().
      END.
      IF ttObjectList.hObjectHandle:TYPE = "QUERY":U THEN
      DO:
        IF ttObjectList.hObjectHandle:IS-OPEN THEN
          ttObjectList.hObjectHandle:QUERY-CLOSE().
      END.
      DELETE OBJECT ttObjectList.hObjectHandle.
    END.
    DELETE ttObjectList.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-determineKeyFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE determineKeyFields Procedure 
PROCEDURE determineKeyFields :
/*------------------------------------------------------------------------------
  Purpose:     Takes the values on the entity_mnemonic table and a buffer passed
               as a parameter and determines the correct values for the
               primary and secondary key values.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE PARAMETER BUFFER bgsc_entity_mnemonic FOR gsc_entity_mnemonic.
  DEFINE INPUT  PARAMETER phBuffer                 AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER pcFieldValue             AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcSecondaryValue         AS CHARACTER  NO-UNDO.

  RUN calcRVKey IN gshRIManager
    (bgsc_entity_mnemonic.table_has_object_field,
     bgsc_entity_mnemonic.entity_object_field,
     bgsc_entity_mnemonic.entity_key_field,
     phBuffer,
     OUTPUT pcFieldValue,
     OUTPUT pcSecondaryValue).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-exportReleaseVersion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exportReleaseVersion Procedure 
PROCEDURE exportReleaseVersion :
/*------------------------------------------------------------------------------
  ACCESS_LEVEL=PUBLIC
  Purpose:     Creates all the ADOs and dumps the patch XML file needed for a
               specific release.
  Parameters:
    pcFromRelease   - The release that we are upgrading from.
    pcDirectory     - The directory to dump the ADO and patch files to.
    plADOs          - Should ADOs be dumped?
    plPatchFile     - Should we dump the patch file?
    pcPatchFileName - The name of the patch file to be dumped.
    pcPatchLevel    - The patch level to write to the patch file.
    
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFromRelease     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plGenVer          AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plResetMod        AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plPatchFile       AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plADOs            AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plFullDS          AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcPath            AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcBlankPath       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcPatchFileName   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER piPatchLevel      AS INTEGER    NO-UNDO.

  DEFINE BUFFER bgst_from_release     FOR gst_release_version.
  DEFINE BUFFER bgst_release_version  FOR gst_release_version.
  DEFINE BUFFER bgst_record_version   FOR gst_record_version.
  DEFINE BUFFER bgsm_release          FOR gsm_release.
  DEFINE BUFFER bgsc_entity_mnemonic  FOR gsc_entity_mnemonic.
  DEFINE BUFFER bgsc_dataset_entity   FOR gsc_dataset_entity.
  DEFINE BUFFER bgsc_deploy_dataset   FOR gsc_deploy_dataset.
  DEFINE BUFFER bttPatchList          FOR ttPatchList.
  DEFINE BUFFER bttExportRecordSet    FOR ttExportRecordSet.
  DEFINE BUFFER bttExportDataset      FOR ttExportDataset.
  DEFINE BUFFER bttADOParam           FOR ttADOParam.
  DEFINE BUFFER bttRequiredRecord     FOR ttRequiredRecord.
  DEFINE QUERY  qDSQuery              FOR bttExportDataset.
  DEFINE QUERY  qRSQuery              FOR bttExportRecordset.
  
  DEFINE VARIABLE dFromObj            AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dToObj              AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cRelease            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrMess            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBuffer             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cWhereClause        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRecFileName        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRecKey             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hField              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSeq                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cDSFileName         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRelative           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPatchPath          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOutFile            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOutPath            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTotRec             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRecCount           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRecsProc           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cProc               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRetVal             AS CHARACTER  NO-UNDO.

  /* 
  IF NOT VALID-HANDLE(ghObjectPool) THEN
    /* Start the Object Pool */
    RUN startProcedure IN THIS-PROCEDURE ("PERSIST|ry/prc/ryobjectpoolp.p":U, 
                                          OUTPUT ghObjectPool).
     */
     
  /* Lets make sure that the version numbers are all properly set */
  IF plGenVer THEN
  DO:
    PUBLISH "DSAPI_StatusUpdate":U
      ("Updating release version data...") .
    RUN createReleaseVersion (plResetMod). 
  END.
  
  IF NOT plPatchFile AND
     NOT plADOs      THEN
    RETURN.
  
  EMPTY TEMP-TABLE ttPatchList.
  EMPTY TEMP-TABLE ttExportRecordSet.
  EMPTY TEMP-TABLE ttExportDataset.
  

  pcPath          = RIGHT-TRIM(REPLACE(pcPath,"~\":U,"/":U),"/").
  pcBlankPath     = RIGHT-TRIM(REPLACE(pcBlankPath,"~\":U,"/":U),"/").
  pcPatchFileName = RIGHT-TRIM(REPLACE(pcPatchFileName,"~\":U,"/":U),"/").

  /* If the two paths are the same for the first section, then set the 
     blank path to be just the extra relative piece */
  IF SUBSTRING(pcBlankPath,1,LENGTH(pcPath)) = pcPath THEN
    cRelative = RIGHT-TRIM(REPLACE(SUBSTRING(pcBlankPath,LENGTH(pcPath) + 1),"~\":U,"/":U),"/":U).

  RUN currentRelease (OUTPUT dToObj, OUTPUT cRelease).
  
  /* Now we need to find the releases if they and store the from
     obj and to obj. If pcFromRelease is blank, or the same as the
     TO release, we export everything in the TO release.  */
  IF pcFromRelease = "":U OR
     pcFromRelease = ?    OR
     pcFromRelease = cRelease THEN
    dFromObj = 0.00.
  ELSE
  DO:
    FIND FIRST bgsm_release NO-LOCK
      WHERE bgsm_release.release_number = pcFromRelease
      NO-ERROR.
    IF NOT AVAILABLE(bgsm_release) THEN
    DO:
      cErrMess = "Release record|Release number " + pcFromRelease + " is not on file.".
      RETURN  {af/sup2/aferrortxt.i 'AF' '39' 'gsm_release' 'release_number' "cErrmess"}.
    END.
    ELSE
      dFromObj = bgsm_release.release_obj.
  END.


  /* Loop through all the release version records for the TO obj and build up a
     list of all the objects that we are going to dump out. */ 
  PUBLISH "DSAPI_StatusUpdate":U
    ("Preparing data list for deployment...") .
  for-blk:
  FOR EACH bgst_release_version NO-LOCK
      WHERE bgst_release_version.release_obj = dToObj,
    FIRST bgst_record_version NO-LOCK
      WHERE bgst_record_version.record_version_obj = bgst_release_version.record_version_obj,
    FIRST bgsc_entity_mnemonic NO-LOCK
      WHERE bgsc_entity_mnemonic.entity_mnemonic = bgst_record_version.entity_mnemonic
        AND bgsc_entity_mnemonic.version_data
        AND CAN-FIND(FIRST bgsc_dataset_entity 
                       WHERE bgsc_dataset_entity.entity_mnemonic = bgsc_entity_mnemonic.entity_mnemonic
                         AND bgsc_dataset_entity.primary_entity)
    BREAK
      BY bgsc_entity_mnemonic.entity_mnemonic:

    IF FIRST-OF(bgsc_entity_mnemonic.entity_mnemonic) THEN
    DO:
      IF VALID-HANDLE(hBuffer) THEN
        RUN releasePoolObject /* IN ghObjectPool */
          (hBuffer).
      
      RUN obtainPoolObject /* IN ghObjectPool */
        ("BUFFER":U, 
         bgsc_entity_mnemonic.entity_dbname + ".":U + bgsc_entity_mnemonic.entity_mnemonic_description, 
         OUTPUT hBuffer).
    END.

    /* Find the corresponding release in the FROM release */
    IF dFromObj <> 0.00 THEN
    DO:
      FIND FIRST bgst_from_release NO-LOCK
        WHERE bgst_from_release.release_obj        = dFromObj
          AND bgst_from_release.record_version_obj = bgst_release_version.record_version_obj
        NO-ERROR.
    END.

    /* If the from_release has the same version_number_seq as the to_release, the
       data hasn't changes. Move on to the next record */
    IF AVAILABLE(bgst_from_release) AND
       bgst_from_release.version_number_seq = bgst_release_version.version_number_seq THEN
      NEXT for-blk.

    IF NOT bgst_record_version.deletion_flag THEN
    DO:
      /* At this point we need to figure out what data we are going to dump. First we need to find the
         record in the main table for this record version record */
      IF bgsc_entity_mnemonic.table_has_object_field THEN
        cWhereClause = "WHERE ":U + buildWhereFromKeyVal(CHR(1),
                                            bgsc_entity_mnemonic.entity_object_field,
                                            bgst_record_version.key_field_value,
                                            hBuffer).
      ELSE
        cWhereClause = "WHERE ":U + buildWhereFromKeyVal(CHR(1),
                                           bgsc_entity_mnemonic.entity_key_field,
                                           bgst_record_version.key_field_value,
                                           hBuffer).

      IF cWhereClause = "":U OR
         cWhereClause = ? THEN
        NEXT.
      
      /* Now we actually try the find. */
      hBuffer:FIND-FIRST(cWhereClause, NO-LOCK) NO-ERROR.
      ERROR-STATUS:ERROR = NO.
    END.

    IF hBuffer:AVAILABLE OR
       bgst_record_version.deletion_flag THEN
    DO:
      FOR EACH bgsc_dataset_entity NO-LOCK
          WHERE bgsc_dataset_entity.entity_mnemonic = bgsc_entity_mnemonic.entity_mnemonic
            AND bgsc_dataset_entity.primary_entity,
        FIRST bgsc_deploy_dataset NO-LOCK
          WHERE bgsc_deploy_dataset.deploy_dataset_obj = bgsc_dataset_entity.deploy_dataset_obj:

         /* If this is a source_code_data dataset, we need to build up the name of the file
           that will be dumped. */
        IF bgsc_deploy_dataset.source_code_data AND
           NOT bgst_record_version.deletion_flag THEN
        DO:
          cRecFileName = getFileNameFromField(bgsc_dataset_entity.join_field_list,
                                              hBuffer).
          IF cRecFileName = ? THEN
            cRecFileName = "":U.
        END.
        ELSE
          cRecFileName = "":U.

        IF cRelative <> "":U THEN
          cDSFileName = cRelative.
        ELSE
          cDSFileName = pcBlankPath.

        IF LENGTH(cDSFilename) > 0 AND
           SUBSTRING(cDSFilename,LENGTH(cDSFilename)) <> "/":U THEN
          cDSFilename = cDSFilename + "/":U.

        cDSFileName = cDSFilename + LC(IF bgsc_deploy_dataset.default_ado_filename <> "":U THEN bgsc_deploy_dataset.default_ado_filename ELSE bgsc_deploy_dataset.dataset_code + ".ado":U).
        
        IF cRecFileName = "":U OR 
           cRecFileName = ? THEN
          PUBLISH "DSAPI_StatusUpdate":U
            ("Preparing data list for deployment..." + cDSFilename).
        ELSE
          PUBLISH "DSAPI_StatusUpdate":U
            ("Preparing data list for deployment..." + cRecFilename).
        /* Add the data to the table that we need for the XML file export */
        IF plPatchFile THEN
        DO:
          CASE bgsc_deploy_dataset.dataset_code:
            WHEN "GSCDD":U THEN
              iSeq = 1.
            WHEN "GSCEM":U THEN
              iSeq = 2.
            WHEN "RYCRI":U THEN
              iSeq = 3.
            WHEN "RYCRE":U THEN
              iSeq = 4.
            OTHERWISE
              iSeq = 1000.
          END CASE.
          
          /* Setup the filename */
          FIND FIRST bttPatchList 
            WHERE bttPatchList.cDatasetCode = bgsc_deploy_dataset.dataset_code
            NO-ERROR.
          IF NOT AVAILABLE(bttPatchList) THEN
          DO:
            CREATE bttPatchList.
            ASSIGN
              bttPatchList.iSeq                 = iSeq
              bttPatchList.cDatasetCode         = bgsc_deploy_dataset.dataset_code
              bttPatchList.cPatchLevel          = STRING(piPatchLevel,"999999":U)
              bttPatchList.cStage               = "ADOLoad":U
              bttPatchList.cFileType            = "ADO":U
              bttPatchList.cFileName            = cDSFileName
              bttPatchList.cDescription         = "Loading ADO for " + bttPatchList.cFileName
              bttPatchList.lRerunnable          = YES
              bttPatchList.lNewDB               = NO
              bttPatchList.lExistingDB          = YES
              bttPatchList.lUpdateMandatory     = YES
            .
          END.
          IF cRecFilename <> "":U AND
             cRecFilename <> ? THEN
          DO:
            FIND FIRST bttPatchList 
              WHERE bttPatchList.cFilename = cRecFilename
              NO-ERROR.
            IF NOT AVAILABLE(bttPatchList) THEN
            DO:
              CREATE bttPatchList.
              ASSIGN
                bttPatchList.iSeq                 = 9999
                bttPatchList.cDatasetCode         = "":U
                bttPatchList.cPatchLevel          = STRING(piPatchLevel,"999999":U)
                bttPatchList.cStage               = "ADOLoad":U
                bttPatchList.cFileType            = "ADO":U
                bttPatchList.cFileName            = cRecFileName
                bttPatchList.cDescription         = "Loading ADO for " + bttPatchList.cFileName
                bttPatchList.lRerunnable          = YES
                bttPatchList.lNewDB               = NO
                bttPatchList.lExistingDB          = YES
                bttPatchList.lUpdateMandatory     = YES
              .
            END.
          END.
        END.
        
        /* Add the data to the tables that we need for the ADO export */
        IF plADOs      THEN
        DO:
          FIND FIRST bttExportDataset NO-LOCK
            WHERE bttExportDataset.dataset_code = bgsc_deploy_dataset.dataset_code
            NO-ERROR.
          IF NOT AVAILABLE(bttExportDataset) THEN
          DO:
            CREATE bttExportDataset.
            ASSIGN
              bttExportDataset.dataset_code     = bgsc_deploy_dataset.dataset_code
              bttExportDataset.cFileName        = cDSFileName
              bttExportDataset.source_code_data = bgsc_deploy_dataset.source_code_data
            .
          END.
          IF NOT bgst_record_version.deletion_flag THEN
          DO:
            /* Now we need to build up the record key on the format of the primary entity in the
               dataset */
            cRecKey = "":U. 
            DO iCount = 1 TO NUM-ENTRIES(bgsc_dataset_entity.join_field_list):
              hField = hBuffer:BUFFER-FIELD(ENTRY(iCount,bgsc_dataset_entity.join_field_list)) NO-ERROR.
              IF VALID-HANDLE(hField) THEN
                cRecKey = cRecKey + (IF cRecKey <> "":U THEN CHR(3) ELSE "":U)
                     + STRING(hField:BUFFER-VALUE).
              ELSE
                cRecKey = cRecKey + (IF cRecKey <> "":U THEN CHR(3) ELSE "":U)
                     + "?":U.
            END.
            FIND FIRST bttExportRecordset NO-LOCK
              WHERE bttExportRecordset.dataset_code = bgsc_deploy_dataset.dataset_code
                AND bttExportRecordset.cKey         = cRecKey
              NO-ERROR.
            IF NOT AVAILABLE(bttExportRecordset) THEN
            DO:
              CREATE bttExportRecordset.
              ASSIGN
                bttExportRecordset.dataset_code = bgsc_deploy_dataset.dataset_code
                bttExportRecordset.cKey         = cRecKey
                bttExportRecordset.cFileName    = cRecFilename
              .
            END.
          END.
        END.
      END. /* FOR EACH bgsc_dataset_entity  */
    END. /* IF hBuffer:AVAILABLE  */
  END. /* for-blk: */
  IF VALID-HANDLE(hBuffer) THEN
    RUN releasePoolObject /* IN ghObjectPool */
      (hBuffer).

  /* Now we need to make sure that the directories actually exist. */
  createPath(pcPath).

  IF cRelative <> "":U THEN
    createPath(pcPath + "/":U + cRelative).
  ELSE
    createPath(pcBlankPath).

  iCount = R-INDEX(pcPatchFileName,"/":U).
  IF iCount > 0  THEN
  DO:
    cPatchPath = SUBSTRING(pcPatchFileName,1,iCount - 1).
    createPath(cPatchPath).
  END.


  /* Now we need to generate the XML file */
  IF plPatchFile THEN
  DO:
    PUBLISH "DSAPI_StatusUpdate":U
      ("Writing ADO Setup File (" + pcPatchFileName + ")...").
    RUN writeXMLPatchFile (pcPatchFileName).
  END.
  /* Finally, generate the ADOs if applicable */
  IF plADOs THEN
  DO:
    PUBLISH "DSAPI_StatusUpdate":U
      ("Generating ADOs...").
    OPEN QUERY qDSQuery
      PRESELECT EACH bttExportDataset.
    iTotRec = NUM-RESULTS("qDSQuery":U).
    GET FIRST qDSQuery.


    REPEAT WHILE NOT QUERY-OFF-END("qDSQuery":U):
      iRecsProc = iRecsProc + 1.
      cProc = STRING(iRecsProc) + " of ":U + STRING(iTotRec) + " - ":U + bttExportDataset.dataset_code. 
      IF bttExportDataset.source_code_data THEN
       RUN writeContainedADOs(cProc, 
                              bttExportDataset.dataset_code,
                              pcPath,
                              pcBlankPath,
                              bttExportDataset.cFileName,
                              NO,
                              YES,
                              NO,
                              NO,
                              NO,
                              INPUT BUFFER bttExportRecordset:HANDLE).
      ELSE
      DO:
  
        EMPTY TEMP-TABLE ttADOParam.
  
        /* Set the ADO Parameters that need to be passed in as
           additionals. */
        DO FOR bttADOParam:
          CREATE bttADOParam.
          ASSIGN                                       
            bttADOParam.cParam = "WriteDeletionsDataset":U
            bttADOParam.cValue = "YES":U
          .
          CREATE bttADOParam.
          ASSIGN                                       
            bttADOParam.cParam = "RemoveDeletions":U
            bttADOParam.cValue = "NO":U
          .
        END.
  
        EMPTY TEMP-TABLE ttRequiredRecord.
        IF NOT plFullDS THEN
        DO:
          OPEN QUERY qRSQuery
            FOR EACH bttExportRecordset WHERE bttExportRecordset.dataset_code = bttExportDataset.dataset_code.
          GET FIRST qRSQuery.
          iRecCount = 0.
          REPEAT WHILE NOT QUERY-OFF-END("qRSQuery":U):
            CREATE bttRequiredRecord.
            ASSIGN
              iRecCount = iRecCount + 1
              bttRequiredRecord.iSequence       = iRecCount
              bttRequiredRecord.cJoinFieldValue = bttExportRecordset.cKey
            .
            DELETE bttExportRecordset.
            GET NEXT qRSQuery.
          END.
          CLOSE QUERY qRSQuery.
        END.
  
        cOutFile = setFileDetails(bttExportDataset.cFileName,
                                  pcPath,
                                  pcBlankPath,
                                  cOutPath). 
  
        PUBLISH "DSAPI_StatusUpdate":U 
          (cProc + " - ":U + 
           (IF LENGTH(cOutFile) > 45 THEN SUBSTRING(cOutFile,1,10) + "..." + SUBSTRING(cOutFile,LENGTH(cOutFile) - 32)
            ELSE cOutFile)).
  
  
        RUN writeDeploymentDataset
            (bttExportDataset.dataset_code,
             "":U,
             cOutFile,
             cOutPath,
             YES,
             NO,
             INPUT TABLE ttADOParam,
             INPUT TABLE ttRequiredRecord,
             OUTPUT cRetVal).      
  
      END.
      DELETE bttExportDataset.
      GET NEXT qDSQuery.
    END.
    PUBLISH "DSAPI_StatusUpdate":U ("":U).
  
    CLOSE QUERY qDSQuery.
  
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSiteDetails) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSiteDetails Procedure 
PROCEDURE getSiteDetails :
/*------------------------------------------------------------------------------
  Purpose:     Determines the site number information. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iSeqSiteDiv                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSeqSiteRev                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cSite                           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iNumChar                        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cConvSite                       AS CHARACTER  NO-UNDO.
  /* Get the current site number */
  RUN getSiteNumber IN gshGenManager
    (OUTPUT giSiteNo).

  iSeqSiteRev = giSiteNo.

  /* Switch it round so we can put the right stuff
     in the mantissa of the version number seq */
  cSite = STRING(iSeqSiteRev).
  iSeqSiteDiv = 1.
  DO iNumChar = LENGTH(cSite) TO 1 BY -1:
    cConvSite = cConvSite + SUBSTRING(cSite,iNumChar,1).
    iSeqSiteDiv = iSeqSiteDiv * 10.
  END.

  iSeqSiteRev = INTEGER(cConvSite).

  giSiteRev = iSeqSiteRev.
  giSiteDiv = iSeqSiteDiv.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-importDeploymentDataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importDeploymentDataset Procedure 
PROCEDURE importDeploymentDataset :
/*------------------------------------------------------------------------------
  Purpose:     Loads data from the an XML file into the appropriate tables in 
               the database. This procedure assumes that the XML file was 
               created by writeDeploymentDataset.
  Parameters:  
    pcFileName         - The relative path of XML file to load. 
    pcRootDir          - The root directory to write the XML file to.
    pcExceptionLog     - The name of an exception log file to contain all 
                         datasets that did not load. 
    pcReturnValue      - A variable to contain a list of errors generated by 
                         the load.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER  pcFileName           AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER  pcRootDir            AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER  pcExceptionLog       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER  plOverWrite          AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER  plDeleteRelated      AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER  plKeepOwnSiteData    AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER  TABLE  FOR ttImportParam.
  DEFINE INPUT  PARAMETER  TABLE  FOR ttTableProps.
  DEFINE OUTPUT PARAMETER  pcReturnValue        AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE iRequest                      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hXMLDoc                       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRootNode                     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFileName                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cExt                          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iErrors                       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE mXMLDoc                       AS MEMPTR.
  DEFINE VARIABLE cEmpty                        AS CHARACTER  NO-UNDO.

  /*
  IF NOT VALID-HANDLE(ghObjectPool) THEN
    /* Start the Object Pool */
    RUN startProcedure IN THIS-PROCEDURE ("PERSIST|ry/prc/ryobjectpoolp.p":U, 
                                          OUTPUT ghObjectPool).
                                          */

  SET-SIZE(mXMLDoc) = 0.
  
  ERROR-STATUS:ERROR = NO.

  pcFileName = REPLACE(pcFileName,"~\":U, "/":U).
  pcFileName = RIGHT-TRIM(pcFileName, "/":U).

  cFileName = buildFileName(pcRootDir, pcFileName).


  EMPTY TEMP-TABLE ttImportVersion.


  /* Parse the XML file for the header. This also established the temp-tables */
  RUN parseXMLHeader (cFileName, mXMLDoc, YES, YES, OUTPUT iRequest).
  
  IF RETURN-VALUE <> "":U AND 
     RETURN-VALUE <> ? THEN
    pcReturnValue = RETURN-VALUE.



  /* Nothing has been done. There's no error. This should only happen if the
     XML file is empty (zero length) */
  IF iRequest = 0 AND
     pcReturnValue = "":U THEN
    RETURN.
  IF ENTRY(NUM-ENTRIES(pcFileName,"/":U),pcFileName,"/":U) = "rymcz.ado" THEN
    setAttribute(iRequest, 
                 "DebugStop":U, 
                 "YES":U).

  FOR EACH ttImportParam:
    setAttribute(iRequest, 
                 ttImportParam.cParam, 
                 ttImportParam.cValue).
  END.

  /* Check and see if we have an empty dataset. If we do, just return. */
  cEmpty = getAttribute(iRequest, "EmptyDataset":U).
  
  IF pcReturnValue = "":U AND
     cEmpty <> "YES":U THEN
  DO:
    IF NUM-ENTRIES(cFileName,".":U) > 1 THEN
      cFileName = SUBSTRING(cFileName,1,R-INDEX(cFileName,".":U)) + "edo":U.
    ELSE
      cFileName = cFileName + ".edo":U.
    pcExceptionLog = cFileName.
    setAttribute(iRequest, "ExceptionLog":U, pcExceptionLog).

    /* Load the XML into the datasets and save it away. */
    RUN loadDataSet (iRequest, YES).

    iErrors   = INTEGER(getAttribute(iRequest,"NoErrors":U)).
    IF iErrors > 0 THEN
    DO:
      hXMLDoc   = getObjectHandle(iRequest,"hErrDoc":U).
      hRootNode = getObjectHandle(iRequest,"hErrNode":U).
      /* Set the number of transactions contained in this dataset. */
      hRootNode:SET-ATTRIBUTE("Transactions":U,STRING(iErrors)).
      hXMLDoc:SAVE("FILE":U,pcExceptionLog).
    END.

    IF RETURN-VALUE <> "":U AND
       RETURN-VALUE <> ? AND
       RETURN-VALUE <> "EDO":U THEN
        pcReturnValue = RETURN-VALUE.
  END.

  EMPTY TEMP-TABLE ttTableProps.
  EMPTY TEMP-TABLE ttImportParam.

  deleteAttributes(iRequest).
  deleteReqHandles(iRequest).
  deleteTempTables(iRequest).

  IF pcReturnValue <> "":U THEN
    RETURN pcReturnValue.
  ELSE
    RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killPlip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip Procedure 
PROCEDURE killPlip :
/*------------------------------------------------------------------------------
  Purpose:     entry point to instantly kill the plip if it should get lost in memory
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipkill.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadDataSet) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadDataSet Procedure 
PROCEDURE loadDataSet :
/*------------------------------------------------------------------------------
  Purpose:     This procedure reads through the dataset nodes and loads them 
               into the temp tables. If the lImport flag is set, it will take 
               the contents of the temp-tables and write them to the databases.
  Parameters:
    piRequestNo   - The request no to load datasets for.
    plImportData  - A flag to indicate whether the data should physically
                    be written to the database. If set to yes, the dataset
                    will be written to the database and an XML exception log 
                    file produced if need be.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER piRequestNo   AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER plImportData  AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE hXDoc         AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hRootNode     AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hChildNode    AS HANDLE   NO-UNDO.
  DEFINE VARIABLE lFailed       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSuccess      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cRetVal       AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE iCount        AS INTEGER    NO-UNDO.

  hXDoc     = getObjectHandle(piRequestNo, "hXDoc":U).
  /* Sanity check. We should not get the unknown value here, but if we do
     we need to drop out */
  IF NOT VALID-HANDLE(hXDoc) THEN
  DO:
     cRetVal = {af/sup2/aferrortxt.i 'AF' '123' '?' '?' "''" "'Document Handle'"}.
     RETURN cRetVal.
  END.
   
     
  hRootNode = getObjectHandle(piRequestNo, "hRootNode":U).
  /* Sanity check. We should not get the unknown value here, but if we do
     we need to drop out */
  IF NOT VALID-HANDLE(hRootNode) THEN
  DO:
     cRetVal = {af/sup2/aferrortxt.i 'AF' '123' '?' '?' "''" "'Root Node Handle'"}.
     RETURN cRetVal.
  END.
   
  /* Create a Child Node ref */
  CREATE X-NODEREF hChildNode.
  
  /* Iterate through the root node's children */
  REPEAT iCount = 1 TO hRootNode:NUM-CHILDREN:
    
    /* Set the current Child Node */
    hRootNode:GET-CHILD(hChildNode,iCount).
    
    /* If the child node is not the dataset records child node, skip it */
    IF hChildNode:SUBTYPE = "TEXT":U OR
       hChildNode:NAME <> "dataset_records":U THEN
      NEXT.
    
    /* Now we need to pass this node on to the transaction processor */
    RUN loadTransactionNodes (piRequestNo, hChildNode, plImportData).

    IF RETURN-VALUE <> "":U THEN
      RETURN RETURN-VALUE.
  
  END. /* REPEAT iCount = 1  */
  
  DELETE OBJECT hChildNode.
  hChildNode = ?.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadForReview) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadForReview Procedure 
PROCEDURE loadForReview :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFileName    AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER piRequest     AS INTEGER    NO-UNDO.
  DEFINE OUTPUT PARAMETER phTables      AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER phTableList   AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER phTrans       AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER phEntity      AS HANDLE     NO-UNDO.

  DEFINE VARIABLE iRequest  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE mXMLDoc   AS MEMPTR     NO-UNDO.
  DEFINE VARIABLE hXMLDoc   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRootNode AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount    AS INTEGER    NO-UNDO.

  /*  This is here for debugging purposes to add the 
      internal temp tables so that they can be browsed too. 
  DEFINE VARIABLE cTableList AS CHARACTER  INITIAL
    "ttTable,ttRequiredRecord,ttEntityList,ttNode,ttIndexList,ttDSAttribute,ttReqHandle,ttImportVersion":U
    NO-UNDO.
                                                            */
  SET-SIZE(mXMLDoc) = 0.

  RUN parseXMLHeader (pcFileName, mXMLDoc, NO, NO, OUTPUT iRequest).
  piRequest = iRequest.

  SET-SIZE(mXMLDoc) = 0.

  /*
  DO iCount = 1 TO NUM-ENTRIES(cTableList):
    createTable(iRequest, ENTRY(iCount,cTableList)).
  END.
    */
  phTables    = BUFFER ttTable:HANDLE.
  phTableList = BUFFER ttTableList:HANDLE. 
  phTrans     = BUFFER ttTransaction:HANDLE.
  phEntity    = BUFFER ttEntityList:HANDLE.

  IF RETURN-VALUE <> "":U THEN
    RETURN RETURN-VALUE.

  /* Load the XML into the datasets */
  RUN loadDataSet (iRequest, NO).
  IF RETURN-VALUE <> "":U THEN
    RETURN RETURN-VALUE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRecordNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRecordNode Procedure 
PROCEDURE loadRecordNode :
/*------------------------------------------------------------------------------
  Purpose:     This procedure loads a record node into the temp-table that
               it belongs to.
  Parameters:  
    
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER piRequestNo   AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER phNode        AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER piTransNo     AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piNodeLevel   AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER plDeleteTran  AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE hChildNode            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lSuccess              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDBName               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTableName            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTableNo              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cCurrNumSep         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDatasetNumSep      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrNumDec         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDatasetNumDec      AS CHARACTER  NO-UNDO.

  /* With a decimal, we need to swap the numeric format so that it
     is the same as it was in the incoming dataset */
  cCurrNumSep = SESSION:NUMERIC-SEPARATOR.
  cDatasetNumSep = getAttribute(piRequestNo,"NumericSeparator":U).
  cCurrNumDec = SESSION:NUMERIC-DECIMAL-POINT.
  cDatasetNumDec = getAttribute(piRequestNo,"NumericDecimal":U).
  
  DEFINE BUFFER bttTableList FOR ttTableList.
  
  IF phNode:NAME = "contained_record":U THEN
  DO:
    IF CAN-DO(phNode:ATTRIBUTE-NAMES,"Table":U) THEN
    DO:
      cDBName    = phNode:GET-ATTRIBUTE("DB":U).
      cTableName = phNode:GET-ATTRIBUTE("Table":U).
      FIND FIRST bttTableList NO-LOCK
        WHERE bttTableList.iRequestNo = piRequestNo
          AND bttTableList.cDBName    = cDBName
          AND bttTableList.cTableName = cTableName NO-ERROR.
      IF NOT AVAILABLE(bttTableList) THEN
      DO:
        cMessage = {af/sup2/aferrortxt.i 'AF' '1999' '?' '?' cDBName cTableName}.
        RETURN cMessage.
      END.
      iTableNo   = bttTableList.iTableNo.
      IF cDatasetNumSep <> ? AND
         cDatasetNumSep <> "":U AND
         cDatasetNumDec <> ? AND
         cDatasetNumDec <> "":U THEN
        SESSION:SET-NUMERIC-FORMAT(cDatasetNumSep, cDatasetNumDec).
      setNodeValue
        (piRequestNo,
         piNodeLevel,
         iTableNo,
         "oRVObj":U,
         0,
         STRING(readRecordVersionAttr(piRequestNo, phNode)),
         YES).
      SESSION:SET-NUMERIC-FORMAT(cCurrNumSep, cCurrNumDec).
    END.
    ELSE IF plDeleteTran THEN
      readRecordVersionAttr(piRequestNo, phNode).

  END.
  
  /* Create a Child Node ref */
  CREATE X-NODEREF hChildNode.

  /* Iterate through the node's children */
  REPEAT iCount = 1 TO phNode:NUM-CHILDREN:
    
    
    /* Set the current Child Node */
    phNode:GET-CHILD(hChildNode,iCount).

    /* If the child node is not a node, skip it */
    IF hChildNode:SUBTYPE <> "ELEMENT":U THEN
      NEXT.

    /* If the child node is a contained record, recurse this call into this procedure again */
    IF hChildNode:NAME = "contained_record":U THEN
      RUN loadRecordNode (piRequestNo, hChildNode, piTransNo, piNodeLevel + 1, plDeleteTran).

    /* Otherwise assume that this is a field on this record */
    ELSE
    DO:
      assignNode(piRequestNo, piNodeLevel, iTableNo, hChildNode).
    END.

    IF RETURN-VALUE <> "":U AND
       RETURN-VALUE <> ?    THEN
    DO:
      DELETE OBJECT hChildNode.
      hChildNode = ?.
      RETURN RETURN-VALUE.
    END.
  
  END. /* REPEAT iCount = 1  */
  
  /* Delete the child node */
  DELETE OBJECT hChildNode.
  hChildNode = ?.
  
  IF piNodeLevel > 0 AND
     iTableNo > 0 THEN
  DO:
    RUN writeTempTableData (piRequestNo, piNodeLevel, iTableNo, piTransNo).
  END.

  RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadTransactionNodes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadTransactionNodes Procedure 
PROCEDURE loadTransactionNodes :
/*------------------------------------------------------------------------------
  Purpose:     Loads the transaction nodes and processes them.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER piRequestNo   AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER phNode        AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER plImportData  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iTransNo    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hChildNode  AS HANDLE   NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lSuccess    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDelete     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lOverwrite  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cVal        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lError      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cTranType   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDeleteTran AS LOGICAL    NO-UNDO.

  DEFINE BUFFER bttTransaction FOR ttTransaction.

  lError = NO.
  
  /* Create a Child Node ref */
  CREATE X-NODEREF hChildNode.

  /* Iterate through the root node's children */
  REPEAT iCount = 1 TO phNode:NUM-CHILDREN:
    RUN clearRetVal.
    ERROR-STATUS:ERROR = NO.
    
    /* Set the current Child Node */
    phNode:GET-CHILD(hChildNode,iCount).
    
    /* If the child node is not the dataset records child node, skip it */
    IF hChildNode:SUBTYPE = "TEXT":U OR
       hChildNode:NAME <> "dataset_transaction":U THEN
      NEXT.

    iTransNo    = INTEGER(hChildNode:GET-ATTRIBUTE("TransactionNo":U)).

    lDeleteTran = NO.

    IF CAN-DO(hChildNode:ATTRIBUTE-NAMES,"TransactionType":U) THEN
    DO:
      cTranType    = hChildNode:GET-ATTRIBUTE("TransactionType":U).
      IF cTranType = "DELETION":U THEN
        lDeleteTran = YES.
    END.
    

    /* Now we need to pass this node on to the record processor that
       will load the contents of the node into temp-tables */
    PUBLISH "DSAPI_StatusUpdate":U 
        ("Loading Dataset Transaction: " + STRING(iTransNo)).

    EMPTY TEMP-TABLE ttNode.

    ERROR-STATUS:ERROR = NO.
    RUN clearRetVal.
    
    RUN loadRecordNode (piRequestNo, hChildNode, iTransNo, 0, lDeleteTran) NO-ERROR.

    IF ERROR-STATUS:ERROR OR 
       (RETURN-VALUE <> "":U AND
        RETURN-VALUE <> ?) THEN
    DO:
      RUN writeNodeToErrorLog (piRequestNo, hChildNode, "999|" + RETURN-VALUE).
      lError = YES.
      ERROR-STATUS:ERROR = NO.
    END.

    EMPTY TEMP-TABLE ttNode.
    
    IF plImportData AND
       (RETURN-VALUE = "":U OR
        RETURN-VALUE = ?) THEN 
    DO:

      cVal = getAttribute(piRequestNo,"OverwriteNodes":U).
      IF cVal = ? THEN
        lOverwrite = YES.
      ELSE
        lOverwrite = cVal = "YES":U.

      cVal = getAttribute(piRequestNo,"DeleteExisting":U).
      IF cVal = ? THEN
        lDelete = YES.
      ELSE
        lDelete = cVal = "YES":U.
      
      PUBLISH "DSAPI_StatusUpdate":U 
        ("Writing Dataset to Database: " + STRING(iTransNo)).

      ERROR-STATUS:ERROR = NO.
      RUN clearRetVal.
      /* If this is a deletion then apply the deletion */
      IF lDeleteTran THEN 
        RUN removeDeletions (piRequestNo).
      ELSE
        /* This code has to deal with writing the stuff to the database */
        RUN writeDataToDB (piRequestNo, hChildNode, YES, lDelete, lOverwrite).

      IF RETURN-VALUE = "EDO":U THEN
      DO:
        ASSIGN
          lError = YES
        .
        ERROR-STATUS:ERROR = NO.
      END.
    END.
    
  END. /* REPEAT iCount = 1  */
  
  DELETE OBJECT hChildNode.
  hChildNode = ?.

  /* This is just to notify the caller that an EDO file needs to be written. */
  IF (RETURN-VALUE <> "":U AND
      RETURN-VALUE <> ?) OR
     lError THEN
    RETURN "EDO":U.
  ELSE
    RETURN "":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-objectDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription Procedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.

ASSIGN cDescription = "Deployment Dataset XML procedure".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainPoolObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtainPoolObject Procedure 
PROCEDURE obtainPoolObject :
/*------------------------------------------------------------------------------
  Purpose:     This procedure returns an object handle to the caller of the type
               and name (if provided) provided as inpt parameters.
               If there are no available objects of the specified type and
               name, a new one is created.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectType    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcObjectName    AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER phObjectHandle  AS HANDLE     NO-UNDO.

  DEFINE VARIABLE hObjectHandle           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWorkHandle             AS HANDLE     NO-UNDO.

  /* If the object type provided is not supported, return ? in the handle */
  IF NOT CAN-DO("BUFFER,TEMP-TABLE,QUERY,X-NODEREF":U,pcObjectType) THEN
  DO:
    phObjectHandle = ?.
    RETURN.
  END.
  
  /* See if there is an object in the object pool with this name and type. */
  FIND FIRST ttObjectList 
    WHERE ttObjectList.cObjectName = pcObjectName
      AND ttObjectList.cObjectType = pcObjectType
      AND NOT ttObjectList.lObjectInUse
    NO-ERROR.

  /* If we don't have an object in the pool, or the handle is invalid,
     we need to create it at this point */
  IF NOT AVAILABLE(ttObjectList) OR
     NOT VALID-HANDLE(ttObjectList.hObjectHandle) THEN
  DO:
    CASE pcObjectType:
      
      WHEN "TEMP-TABLE":U THEN
        CREATE TEMP-TABLE hObjectHandle.

      WHEN "BUFFER":U THEN
      DO:
        /* When a buffer is being created, we could get a handle that we have to base
           the new buffer on. */
        ASSIGN
          hWorkHandle = WIDGET-HANDLE(pcObjectName)
          NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          ERROR-STATUS:ERROR = NO.
        IF VALID-HANDLE(hWorkHandle) THEN
        DO:
          hObjectHandle = ?.
          CASE hWorkHandle:TYPE:
            WHEN "BUFFER":U THEN
              /* If the handle is a BUFFER handle, create it based on that. */
              CREATE BUFFER hObjectHandle FOR TABLE hWorkHandle NO-ERROR.
            WHEN "TEMP-TABLE":U THEN
              /* If the handle is a TEMP-TABLE handle, create it based on its buffer handle */
              CREATE BUFFER hObjectHandle FOR TABLE hWorkHandle:DEFAULT-BUFFER-HANDLE NO-ERROR.
            OTHERWISE
              hObjectHandle = ?.
          END CASE.
        END.
        ELSE
          CREATE BUFFER hObjectHandle FOR TABLE pcObjectName NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          ERROR-STATUS:ERROR = NO.
      END.
      
      WHEN "QUERY":U THEN
        CREATE QUERY hObjectHandle.
      
      WHEN "X-NODEREF":U THEN
        CREATE X-NODEREF hObjectHandle.
    END CASE.
    IF hObjectHandle <> ? THEN
    DO:
      IF NOT AVAILABLE(ttObjectList) THEN
      DO:
        CREATE ttObjectList.
        ASSIGN
          ttObjectList.cObjectName   = pcObjectName
          ttObjectList.cObjectType   = pcObjectType
        .
      END.
      ASSIGN
        ttObjectList.hObjectHandle = hObjectHandle
      .
    END.
  END.
  ELSE
    hObjectHandle = ttObjectList.hObjectHandle.

  IF hObjectHandle <> ? THEN
    ASSIGN
      ttObjectList.lObjectInUse  = TRUE
    .
  ASSIGN
    phObjectHandle              = hObjectHandle
  .


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-parseXMLHeader) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE parseXMLHeader Procedure 
PROCEDURE parseXMLHeader :
/*------------------------------------------------------------------------------
  Purpose:     This procedure loads the XML header and sets up the attributes
               about the header.
  Parameters:  
    pcFileName        - The name of the XML file to be loaded. If set to "<MEMPTR>",
                        the document is loaded from pmXMLDoc.
    pmXMLDoc          - A memptr containing the XML doc to be loaded. It is only
                        used if pcFileName = "<MEMPTR>". Both are passed to the
                        loadXMLDoc function which takes care of loading the 
                        physical XML doc.
    plWriteHeaderData - Indicates whether or not the header information should
                        be written to the local database. This only applies if 
                        the XML file contains the relevant header information.
                        Code that simply wants to examine the contents of the
                        XML file will probably not want to load the header.  
                        
    plCreateErrHeader - Indicates whether an error file header should be created.
                        If set to yes, the routine will parse the XML file and 
                        create a new XML document. This document will contain (at 
                        the end of this procedure) the header information, the dataset 
                        node and the dataset_header node which will be copied from 
                        the incoming document. This facilitates the creation
                        of the error XML document that will contain all the
                        dataset transactions that fail to load during an 
                        import.
                        If set to no, the error file is not created.                                   
    OUTPUT 
    piRequestNo       - The request number associated with all the attributes
                        of this request. All temp-tables, attributes and
                        handles are related via this request number.           
  Notes:  
    5/5/2001  - As this code stands right now, there is no support for the 
                header information being stored in the XML file. All the 
                header information needs to be in the database.     
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER  pcFileName           AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER  pmXMLDoc             AS MEMPTR     NO-UNDO.
  DEFINE INPUT  PARAMETER  plWriteHeaderData    AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER  plCreateErrHeader    AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER  piRequestNo          AS INTEGER    NO-UNDO.
  
  DEFINE VARIABLE hXDoc         AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hRootNode     AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hChildNode    AS HANDLE   NO-UNDO.
  DEFINE VARIABLE lSuccess      AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE lFullHeader   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lValidHeader  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCount        AS INTEGER  NO-UNDO.
  DEFINE VARIABLE cRetVal       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAtt          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttVal       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iRequestNo    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNoTables     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cDataSetCode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hErrDoc       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hErrRoot      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hErrDSH       AS HANDLE     NO-UNDO.
  
  /* Load the XML document */
  hXDoc = DYNAMIC-FUNCTION("loadXMLDoc":U IN ghXMLHlpr,
                           pcFileName,
                           pmXMLDoc,
                           OUTPUT cRetVal).

  /* The return value is already set. Just return if the handle is invalid */
  IF NOT VALID-HANDLE(hXDoc) THEN
  DO:
    IF cRetVal = "EMPTY FILE":U THEN
      RETURN.
    ELSE
      RETURN cRetVal.
  END.
  cRetVal = "":U.

  /* Get a new request no */
  giRequestNo = giRequestNo + 1.
  iRequestNo = giRequestNo.
  
  /* Make sure that all previous calls for this request number are gone */
  deleteTempTables(iRequestNo).
  deleteAttributes(iRequestNo).
  deleteReqHandles(iRequestNo).

  /* Create two node references */
  CREATE X-NODEREF hRootNode.

  /* Set the root node */
  lSuccess = hXDoc:GET-DOCUMENT-ELEMENT(hRootNode).

  /* If we're not successful we have an invalid XML file */
  IF NOT lSuccess THEN
  DO:
    cRetVal = {af/sup2/aferrortxt.i 'AF' '122' '?' '?' 'root' pcFileName}.
    DELETE OBJECT hRootNode.
    hRootNode = ?.
    DELETE OBJECT hXDoc.
    hXDoc = ?.
    RETURN cRetVal.
  END.

  /* Get the elements for the root node */
  do-blk:
  DO iCount = 1 TO NUM-ENTRIES(hRootNode:ATTRIBUTE-NAMES):
    cAtt = ENTRY(iCount, hRootNode:ATTRIBUTE-NAMES).
    IF NUM-ENTRIES(cAtt,"_":U) > 1 THEN
      NEXT do-blk.
    cAttVal = hRootNode:GET-ATTRIBUTE(cAtt).
    setAttribute(iRequestNo, cAtt, cAttVal). 
    IF cAtt = "EmptyDataset":U AND
       cAttVal = "YES":U THEN
      RETURN.
  END.

  /* Create a Child Node ref */
  CREATE X-NODEREF hChildNode.

  /* Iterate through the root node's children */
  REPEAT iCount = 1 TO hRootNode:NUM-CHILDREN:
    
    /* Set the current Child Node */
    lSuccess = hRootNode:GET-CHILD(hChildNode,iCount).

    IF NOT lSuccess THEN
      NEXT.

    /* If the child node is blank, skip it */
    IF hChildNode:SUBTYPE = "TEXT":U AND
       hChildNode:NODE-VALUE = CHR(10) THEN
      NEXT.

    /* If the name of this node is "dataset_header" , we'll process this node */  
    IF hChildNode:NAME = "dataset_header":U THEN
    DO:
      IF plCreateErrHeader THEN
      DO:
        RUN createTopLevelNodes(OUTPUT hErrDoc, OUTPUT hErrRoot).
        CREATE X-NODEREF hErrDSH.
        hErrDoc:IMPORT-NODE(hErrDSH, hChildNode, TRUE).
        hErrRoot:APPEND-CHILD(hErrDSH).
        DELETE OBJECT hErrDSH.
        hErrDSH = ?.
      END.
      
      /* Get all the attribute values for this node */
      DO iCount = 1 TO NUM-ENTRIES(hChildNode:ATTRIBUTE-NAMES):
        cAtt = ENTRY(iCount, hChildNode:ATTRIBUTE-NAMES).
        cAttVal = hChildNode:GET-ATTRIBUTE(cAtt).
        setAttribute(iRequestNo, cAtt, cAttVal). 
      END.

      /* Set the full header and data set code attributes */
      lFullHeader  = getAttribute(iRequestNo, "FullHeader":U) = "YES":U.
      cDataSetCode = getAttribute(iRequestNo, "DatasetCode":U).

      /* If the header or dataset have not been specified, there's a problem */
      IF lFullHeader = ? OR 
         cDatasetCode = ? THEN
      DO:
        cRetVal = {af/sup2/aferrortxt.i 'AF' '123' '?' '?' pcFileName 'header'}.
        lSuccess = NO.
      END.
      ELSE
        lSuccess = YES.
        
      IF NOT lSuccess THEN
        LEAVE.

      /* Let's see if the root node has any data versioning info. This has to happen
         here because we needed to set the date format before we tried this. 
         This is a fix for Issue 3350 */
      setAttribute(iRequestNo,"DatasetVersionInfo":U, STRING(readRecordVersionAttr(iRequestNo, hRootNode))). 

      IF lFullHeader THEN
      DO:
        /* At this stage, I'm ignoring the header definitions section. I'll
           put this in later. At this point, we always build the temp-tables
           from the database schema */
        RUN buildStructFromDB(cDatasetCode, INPUT-OUTPUT iRequestNo, OUTPUT iNoTables).
      END.
      ELSE
      DO:
        RUN buildStructFromDB(cDatasetCode, INPUT-OUTPUT iRequestNo, OUTPUT iNoTables).
      END.
      {af/sup2/afcheckerr.i 
         &no-return = YES}
      ELSE
      DO:
        lValidHeader = YES.
        setAttribute(iRequestNo, "NoTables":U, STRING(iNoTables)).
      END.

      LEAVE.
    END.
  
  END.

  IF lValidHeader THEN
  DO:
    registerObject(iRequestNo, "hRootNode":U, hRootNode).
    registerObject(iRequestNo, "hXDoc":U, hXDoc).
    IF VALID-HANDLE(hErrRoot) THEN
      registerObject(iRequestNo, "hErrNode":U, hErrRoot).
    IF VALID-HANDLE(hErrDoc) THEN
      registerObject(iRequestNo, "hErrDoc":U, hErrDoc).
    setAttribute(iRequestNo, "NoErrors":U, "0":U).
    piRequestNo = iRequestNo.
  END.
  ELSE
  DO:
    deleteTempTables(iRequestNo).
    deleteAttributes(iRequestNo).
    deleteReqHandles(iRequestNo).
    IF VALID-HANDLE(hErrRoot) THEN
      DELETE OBJECT hErrRoot.
    IF VALID-HANDLE(hErrDoc) THEN
      DELETE OBJECT hErrDoc.
    DELETE OBJECT hRootNode.
    hRootNode = ?.
    DELETE OBJECT hXDoc.
    hXDoc = ?.
  END.

  /* Delete the objects */
  DELETE OBJECT hChildNode.
  hChildNode = ?.

  IF cRetVal <> "":U THEN
    RETURN cRetVal.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-patchFileClose) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE patchFileClose Procedure 
PROCEDURE patchFileClose :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFileName    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcPatchLevel  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phDoc         AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER phRootNode    AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER phPatchNode   AS HANDLE     NO-UNDO.

  DEFINE VARIABLE hText                 AS HANDLE     NO-UNDO.

  /* Add the text element into the new node */
  hText = DYNAMIC-FUNCTION("createTextNode":U IN ghXMLHlpr,
                           phPatchNode).
  
  /* Set the node value */
  hText:NODE-VALUE = CHR(9).

  DELETE OBJECT hText.
  hText = ?.

  DELETE OBJECT phPatchNode.
  DELETE OBJECT phRootNode.

  phDoc:SAVE("FILE",pcFileName).

  DELETE OBJECT phDoc.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-patchFileCreate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE patchFileCreate Procedure 
PROCEDURE patchFileCreate :
/*------------------------------------------------------------------------------
  Purpose:     Creates the top level nodes in a patch file.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcPatchLevel  AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER phDoc         AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER phRootNode    AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER phPatchNode   AS HANDLE     NO-UNDO.

  DEFINE VARIABLE hText                 AS HANDLE     NO-UNDO.

  CREATE X-DOCUMENT phDoc.

  phDoc:ENCODING = "utf-8":U.

  /* Create a setup node */
  phRootNode = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr,
                               phDoc, 
                               "SetupInclude":U).

  /* Add the text element into the new node */
  hText = DYNAMIC-FUNCTION("createTextNode":U IN ghXMLHlpr,
                           phRootNode).
  
  /* Set the node value */
  hText:NODE-VALUE = CHR(10) + CHR(9).

  DELETE OBJECT hText.
  hText = ?.
  
  /* Create a setup node */
  phPatchNode = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr,
                                 phRootNode, 
                                 "Patch":U).

  /* Add the text element into the new node */
  hText = DYNAMIC-FUNCTION("createTextNode":U IN ghXMLHlpr,
                           phPatchNode).

  /* Set the node value */
  hText:NODE-VALUE = CHR(10) + CHR(9) + CHR(9).
  
  
  phPatchNode:SET-ATTRIBUTE("PatchLevel":U, 
                            pcPatchLevel).
  
  DELETE OBJECT hText.
  hText = ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-patchProcNodeCreate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE patchProcNodeCreate Procedure 
PROCEDURE patchProcNodeCreate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER phBuff      AS HANDLE     NO-UNDO.
    DEFINE INPUT  PARAMETER phStageNode AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hText          AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hProcNode      AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hLastFieldNode AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hFieldNode     AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hField         AS HANDLE     NO-UNDO.
    DEFINE VARIABLE iCount         AS INTEGER    NO-UNDO.

/*    DEFINE TEMP-TABLE ttPatchList NO-UNDO
  FIELD iSeq             AS INTEGER
  FIELD cDatasetCode     AS CHARACTER
  FIELD cPatchLevel      AS CHARACTER
  FIELD cStage           AS CHARACTER
  FIELD cFileType        AS CHARACTER
  FIELD cFileName        AS CHARACTER
  FIELD cDescription     AS CHARACTER
  FIELD lRerunnable      AS LOGICAL
  FIELD lNewDB           AS LOGICAL
  FIELD lExistingDB      AS LOGICAL
  FIELD lUpdateMandatory AS LOGICAL
  INDEX pudx IS PRIMARY UNIQUE
    cFileName
  INDEX dxSeq
    iSeq
    cFileName
  INDEX dxDSCode
    cDatasetCode
  .
  */
    /* Create a setup node */
    hProcNode = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr,
                                 phStageNode, 
                                 "Program":U).
    
    /* Add the text element into the new node */
    hText = DYNAMIC-FUNCTION("createTextNode":U IN ghXMLHlpr,
                             hProcNode).
    /* Set the node value */
    hText:NODE-VALUE = CHR(10).

    DELETE OBJECT hText.
    hText = ?.

    DO iCount = 5 TO phBuff:NUM-FIELDS:

      /* Add the text element into the new node */
      hText = DYNAMIC-FUNCTION("createTextNode":U IN ghXMLHlpr,
                               hProcNode).
      /* Set the node value */
      hText:NODE-VALUE = CHR(9) + CHR(9) + CHR(9) + CHR(9).
      
      DELETE OBJECT hText.
      hText = ?.

      hField = phBuff:BUFFER-FIELD(iCount).

      /* Create a setup node */
      hFieldNode = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr,
                                     hProcNode, 
                                     SUBSTRING(hField:NAME,2)).

      hText = DYNAMIC-FUNCTION("createTextNode":U IN ghXMLHlpr,
                               hFieldNode).
      /* Set the node value */
      hText:NODE-VALUE = hField:BUFFER-VALUE.
      
      DELETE OBJECT hText.
      hText = ?.

    END.

    hText = DYNAMIC-FUNCTION("createTextNode":U IN ghXMLHlpr,
                             hProcNode).
    /* Set the node value */
    hText:NODE-VALUE = CHR(9) + CHR(9) + CHR(9).

    DELETE OBJECT hText.
    hText = ?.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-patchStageEnd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE patchStageEnd Procedure 
PROCEDURE patchStageEnd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phStageNode   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hText   AS HANDLE     NO-UNDO.

  /* Add the text element into the new node */
  hText = DYNAMIC-FUNCTION("createTextNode":U IN ghXMLHlpr,
                           phStageNode).
  /* Set the node value */
  hText:NODE-VALUE = CHR(9) + CHR(9).

  DELETE OBJECT hText.
  hText = ?.

  DELETE OBJECT phStageNode.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-patchStageStart) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE patchStageStart Procedure 
PROCEDURE patchStageStart :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcStage       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phPatchNode   AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER phStageNode   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hText AS HANDLE     NO-UNDO.

  /* Create a setup node */
  phStageNode = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr,
                                 phPatchNode, 
                                 "PatchStage":U).

  /* Add the text element into the new node */
  hText = DYNAMIC-FUNCTION("createTextNode":U IN ghXMLHlpr,
                           phStageNode).
  
  /* Set the node value */
  hText:NODE-VALUE = CHR(10) + CHR(9) + CHR(9) + CHR(9).

  phStageNode:SET-ATTRIBUTE("Stage":U, 
                             pcStage).
  
  DELETE OBJECT hText.
  hText = ?.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipSetup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup Procedure 
PROCEDURE plipSetup :
/*------------------------------------------------------------------------------
  Purpose:    Run by main-block of PLIP at startup of PLIP
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hProc AS HANDLE     NO-UNDO.

/*
  /* Start the Dataset API procedure */
  RUN startProcedure IN THIS-PROCEDURE ("ONCE|af/app/afddo.p":U, 
                                        OUTPUT ghDDO).
  */
  /* Start the XML helper API */
  RUN startProcedure IN THIS-PROCEDURE ("ONCE|af/app/afxmlhlprp.p":U, 
                                        OUTPUT ghXMLHlpr).

  RUN getSiteDetails.

  {ry/app/ryplipsetu.i}
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run just before the calling program 
               terminates
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Make sure we delete all the temp-tables we created in this persistent
     procedure */
  deleteTempTables(?).

  /* Make sure we delete all the objects that we created */
  deleteReqHandles(?).

  /* Make sure we delete all the attributes */
  deleteAttributes(?).

  deleteTransactions(?).
  

  {ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-releasePoolObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE releasePoolObject Procedure 
PROCEDURE releasePoolObject :
/*------------------------------------------------------------------------------
  Purpose:     Frees up an object handle when it is no longer in use.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phObjectHandle   AS HANDLE     NO-UNDO.

  /* See if there is an object in the object pool with this name and type. */
  FIND FIRST ttObjectList 
    WHERE ttObjectList.hObjectHandle = phObjectHandle
    NO-ERROR.

  /* If we don't have an object in the pool, or the handle is invalid,
     we need to create it at this point */
  IF AVAILABLE(ttObjectList) THEN
  DO:
    IF NOT VALID-HANDLE(phObjectHandle) THEN
      DELETE ttObjectList.
    ELSE
    DO:
      CASE ttObjectList.cObjectType:

        WHEN "TEMP-TABLE":U THEN
          phObjectHandle:DEFAULT-BUFFER-HANDLE:EMPTY-TEMP-TABLE().

        WHEN "QUERY":U THEN
        DO:
          IF phObjectHandle:IS-OPEN THEN
            phObjectHandle:QUERY-CLOSE().
          phObjectHandle:SET-BUFFERS(BUFFER ttDummy:HANDLE).
        END.

        WHEN "X-NODEREF":U THEN
          phObjectHandle = ?.

        WHEN "BUFFER":U THEN
        DO:
          IF phObjectHandle:AVAILABLE THEN
            phObjectHandle:BUFFER-RELEASE().
        END.

      END CASE.
      ASSIGN
        ttObjectList.lObjectInUse  = FALSE
      .
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeDeletions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeDeletions Procedure 
PROCEDURE removeDeletions :
/*------------------------------------------------------------------------------
  Purpose:     This procedure loops through the imported record version records
               that are marked for deletion and removes the record from the
               database if applicable and clears the ttImportData record for it.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER piRequestNo AS INTEGER    NO-UNDO.

  DEFINE BUFFER bttImportVersion    FOR ttImportVersion.
  DEFINE BUFFER bgst_record_version FOR gst_record_version.
  DEFINE BUFFER bttEntityList       FOR ttEntityList.
  DEFINE BUFFER bttTable            FOR ttTable.
  DEFINE BUFFER bgst_release_version FOR gst_release_version.

  DEFINE VARIABLE oObj        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cAttributes AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hField      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cVal        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lRemDels    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cWhere      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere2     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAns        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lKeyMatch   AS LOGICAL    NO-UNDO.

  cVal = getAttribute(piRequestNo,"RemoveDeletions":U).
  IF cVal = ? THEN
    lRemDels = YES.
  ELSE
    lRemDels = cVal = "YES":U.

  DISABLE TRIGGERS FOR LOAD OF bgst_record_version.
  DISABLE TRIGGERS FOR DUMP OF bgst_record_version.

  FOR EACH bttImportVersion
    WHERE bttImportVersion.deletion_flag = YES TRANSACTION:

    /* Now we need to see if this record exists on the database.
       First try it on the obj... */
    FIND FIRST bgst_record_version
      WHERE bgst_record_version.record_version_obj = bttImportVersion.record_version_obj
      NO-ERROR.
    IF NOT AVAILABLE(bgst_record_version) THEN
    DO:
      /* And if the obj version is not found, look for the entity_mnemonic and 
         key field value */
      FIND FIRST bgst_record_version
        WHERE bgst_record_version.entity_mnemonic = bttImportVersion.entity_mnemonic
          AND bgst_record_version.key_field_value = bttImportVersion.key_field_value
        NO-ERROR.
    END.
    ERROR-STATUS:ERROR = NO.

    /* Now we need to find the record in the database that actually applies */
    FIND bttEntityList 
      WHERE bttEntityList.cEntityMnemonic = bttImportVersion.entity_mnemonic
      NO-ERROR.
    IF NOT AVAILABLE(bttEntityList) THEN
      NEXT.
    ERROR-STATUS:ERROR = NO.

    /* Get the handle to the buffer that we need to use to read the data */
    FIND FIRST bttTable
      WHERE bttTable.cEntityMnemonic = bttImportVersion.entity_mnemonic
        AND lPrimary = YES NO-ERROR.
    IF NOT AVAILABLE(bttTable) THEN
      NEXT.
    ERROR-STATUS:ERROR = NO.

    /* Build a for each statement for this buffer */
    RUN obtainPoolObject /* IN ghObjectPool */
      ("BUFFER":U, 
       bttTable.cDatabase + ".":U + bttTable.cTableName, 
       OUTPUT hBuffer).
    ERROR-STATUS:ERROR = NO.

    /* If this is not a valid buffer then next. */
    IF NOT VALID-HANDLE(hBuffer) THEN
      NEXT.
    /* Build up the where clause for the deletion. */
    cWhere  = "":U.
    cWhere2 = "":U.
    IF bttEntityList.lHasObj THEN
      ASSIGN
        cWhere  = buildWhereFromKeyList(hBuffer,
                                        bttEntityList.cObjField,
                                        bttImportVersion.key_field_value)
        cWhere2 = buildWhereFromKeyList(hBuffer,
                                        bttEntityList.cKeyField,
                                        bttImportVersion.secondary_key_value)
      .
    ELSE
      cWhere = buildWhereFromKeyList(hBuffer,
                                     bttEntityList.cKeyField,
                                     bttImportVersion.key_field_value).

    hBuffer:DISABLE-LOAD-TRIGGERS(NO).
    hBuffer:DISABLE-DUMP-TRIGGERS().

    IF cWhere <> "":U THEN
      lAns = hBuffer:FIND-FIRST(cWhere,EXCLUSIVE-LOCK) NO-ERROR.
    ERROR-STATUS:ERROR = NO.
    
    IF NOT hBuffer:AVAILABLE AND
       cWhere2 <> "":U THEN
      lAns = hBuffer:FIND-FIRST(cWhere2,EXCLUSIVE-LOCK) NO-ERROR.
    ERROR-STATUS:ERROR = NO.

    IF hBuffer:AVAILABLE THEN
    DO:
      lKeyMatch = YES.
      IF bttEntityList.lHasObj AND
         bttEntityList.cKeyField <> "":U AND
         bttImportVersion.secondary_key_value <> "":U THEN
        lKeyMatch = matchKeys(bttEntityList.cKeyField, bttImportVersion.secondary_key_value, hBuffer).

      IF lKeyMatch THEN
        /* Go and build a list of the tables that have data that may need to be
           deleted and delete the appropriate records. These records have to be
           deleted before we start writing in the new dataset, otherwise
           we could land up with key field clashes. */

        RUN deleteOldData (piRequestNo,
                           Yes,
                           Yes,
                           hBuffer,
                           BUFFER bttTable) NO-ERROR.
      IF hBuffer:AVAILABLE THEN
      DO:
        hBuffer:BUFFER-DELETE().
        hBuffer:BUFFER-RELEASE().
      END.
      
      RUN releasePoolObject /* IN ghObjectPool */
        (hBuffer).
      hBuffer = ?.
      IF ERROR-STATUS:ERROR THEN 
      DO:
        UNDO, NEXT.
      END.

    END.

    RUN releasePoolObject /* IN ghObjectPool */
      (hBuffer).
    hBuffer = ?.

    IF AVAILABLE(bgst_record_version) AND 
       lRemDels THEN
    DO:
      FOR EACH bgst_release_version 
        WHERE bgst_release_version.record_version_obj = bgst_record_version.record_version_obj:
        DELETE bgst_release_version.
      END.
      DELETE bgst_record_version.
    END.
    ELSE
    DO:
      IF NOT AVAILABLE(bgst_record_version) THEN
      DO:
        CREATE bgst_record_version.
        ASSIGN
          bgst_record_version.last_version_number_seq = DECIMAL(giSiteRev / giSiteDiv)
        .
      END.
      BUFFER-COPY bttImportVersion 
        EXCEPT last_version_number_seq
        TO bgst_record_version.
    END.
    
    /* Whack the bttImport record that we created temporarily */
    DELETE bttImportVersion.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetAllModifiedStatus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetAllModifiedStatus Procedure 
PROCEDURE resetAllModifiedStatus :
/*------------------------------------------------------------------------------
  Purpose:     Reset the modified status on the gst_record_version records so 
               that no data is signalled as having been changed.
  Parameters:  <none>
  Notes:       This procedure loops through the gst_record_version table and
               sets the value of the import_version_number_seq to the value
               of the version_number_seq, thereby indicating that nothing has 
               changed since the last update. This means that when the user
               chooses to deploy all modified data, nothing will be deployed.
------------------------------------------------------------------------------*/

  DEFINE BUFFER bgst_record_version FOR gst_record_version.

  FOR EACH bgst_record_version EXCLUSIVE-LOCK:
    ASSIGN
      bgst_record_version.version_number_seq = ABS(bgst_record_version.version_number_seq)
      bgst_record_version.import_version_number_seq = bgst_record_version.version_number_seq
    .
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetModifiedStatus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetModifiedStatus Procedure 
PROCEDURE resetModifiedStatus :
/*------------------------------------------------------------------------------
  Purpose:     Find all the gst_record_versions that are currently in the 
               ttVersionReset table and reset the modified status.
               
  Parameters:  
    plDelete - Indicates that deletion gst_record_versions should be removed
               from the target repository.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER plDelete AS LOGICAL    NO-UNDO.

  DEFINE BUFFER bttVersionReset FOR ttVersionReset.
  DEFINE BUFFER bgst_record_version FOR gst_record_version.
  

  DO FOR bgst_record_version, bttVersionReset:
    /* Loop through all the ttVersionReset records and find the
       corresponding gst_record_version */
    FOR EACH bttVersionReset TRANSACTION:

      FIND bgst_record_version EXCLUSIVE-LOCK
        WHERE bgst_record_version.record_version_obj = bttVersionReset.record_version_obj
        NO-ERROR.

      /* Make sure the version_number_seq is positive and then assign the 
         version_number_seq to the import_version_number_seq */
      IF AVAILABLE(bgst_record_version) THEN
      DO:
        IF bttVersionReset.delete_record = YES AND
           plDelete THEN
          DELETE bgst_record_version.
        ELSE
          ASSIGN
            bgst_record_version.version_number_seq = ABS(bgst_record_version.version_number_seq)
            bgst_record_version.import_version_number_seq = bgst_record_version.version_number_seq
          .
      END.
    END.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-selectDSRecords) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectDSRecords Procedure 
PROCEDURE selectDSRecords :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcDatasetCode AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phRecordSet   AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcFileField   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcRecs        AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cDSKey         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hEntityBuff    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cEntityForEach AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hQuery         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cKey           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lAns           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hFileName      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDSCode        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hKey           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFileField     AS HANDLE     NO-UNDO.

  DEFINE BUFFER bgsc_deploy_dataset FOR gsc_deploy_dataset.
  DEFINE BUFFER bgsc_dataset_entity FOR gsc_dataset_entity.
  DEFINE BUFFER bgsc_entity_mnemonic FOR gsc_entity_mnemonic.

  FIND FIRST bgsc_deploy_dataset NO-LOCK
    WHERE bgsc_deploy_dataset.dataset_code = pcDatasetCode.

  FIND FIRST bgsc_dataset_entity NO-LOCK
    WHERE bgsc_dataset_entity.deploy_dataset_obj = bgsc_deploy_dataset.deploy_dataset_obj
      AND bgsc_dataset_entity.primary_entity.

  FIND FIRST bgsc_entity_mnemonic NO-LOCK
    WHERE bgsc_entity_mnemonic.entity_mnemonic = bgsc_dataset_entity.entity_mnemonic.

  cDSKey = bgsc_dataset_entity.join_field_list.
  
  RUN obtainPoolObject /* IN ghObjectPool */
    ("BUFFER":U, 
     bgsc_entity_mnemonic.entity_dbname + ".":U + bgsc_entity_mnemonic.entity_mnemonic_description, 
     OUTPUT hEntityBuff).

  cEntityForEach = "FOR EACH ":U + hEntityBuff:NAME + " NO-LOCK":U.

  hFileName  = phRecordSet:BUFFER-FIELD("cFileName":U).
  hDSCode    = phRecordSet:BUFFER-FIELD("dataset_code":U).
  hKey       = phRecordSet:BUFFER-FIELD("cKey":U).

  RUN obtainPoolObject /* IN ghObjectPool */
    ("QUERY":U, 
     "":U, 
     OUTPUT hQuery).
  hQuery:SET-BUFFERS(hEntityBuff).
  hQuery:QUERY-PREPARE(cEntityForEach).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().
  REPEAT WHILE NOT hQuery:QUERY-OFF-END TRANSACTION:
    cKey = "":U.
    DO iCount = 1 TO NUM-ENTRIES(cDSKey):
      hField = hEntityBuff:BUFFER-FIELD(ENTRY(iCount,cDSKey)).
      cKey = cKey + (IF cKey = "":U THEN "":U ELSE CHR(3)) + STRING(hField:BUFFER-VALUE).
    END.
    cWhere = "WHERE ":U + phRecordSet:NAME + ".dataset_code = ":U + TRIM(QUOTER(pcDatasetCode))
           + " AND ":U + phRecordSet:NAME + ".cKey = ":U + TRIM(QUOTER(cKey)).
    lAns = phRecordSet:FIND-FIRST(cWhere, EXCLUSIVE-LOCK) NO-ERROR.
    /*  
    lAns = DYNAMIC-FUNCTION("findFirst":U IN ghDDO,
                            phRecordSet,
                            cWhere,
                            "EXCLUSIVE-LOCK":U,
                            NO). */
    ERROR-STATUS:ERROR = NO.
    IF NOT lAns OR
       NOT phRecordSet:AVAILABLE THEN
    DO:
      phRecordSet:BUFFER-CREATE().
      hDSCode:BUFFER-VALUE   = pcDatasetCode.
      hKey:BUFFER-VALUE      = cKey.
      hFileName:BUFFER-VALUE = getFileNameFromField(pcFileField, hEntityBuff).
    END.
    phRecordSet:BUFFER-RELEASE().
    hQuery:GET-NEXT().
  END.
  hQuery:QUERY-CLOSE().
  RUN releasePoolObject /* IN ghObjectPool */
    (hQuery).
  hQuery = ?.
  RUN releasePoolObject /* IN ghObjectPool */
    (hEntityBuff).
  hEntityBuff = ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateDatasetQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDatasetQuery Procedure 
PROCEDURE validateDatasetQuery :
/*------------------------------------------------------------------------------
    Purpose:   This function determines whether a dataset query is valid. 
  
 Parameters:
   pcEntityMnemonic   - The entity mnemonic of the current table.
   pcJoinEntity       - The entity mnemonic of the table being joined to.
   pcJoinFieldList    - The list of fields to join with.
   pcFilterWhere      - The where clause to be used.
   plPrimary          - A logical value indicating if this is the primary
                        table.
      Notes:  
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcEntityMnemonic AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pcJoinEntity     AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pcJoinFieldList  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pcFilterWhere    AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER plPrimary        AS LOGICAL   NO-UNDO.

  DEFINE BUFFER bgsc_entity_mnemonic FOR gsc_entity_mnemonic.

  DEFINE VARIABLE hChild        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hParent       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cQualTable    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryString  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRetVal       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessString   AS CHARACTER  NO-UNDO.
  

  /*
  IF NOT VALID-HANDLE(ghObjectPool) THEN
    /* Start the Object Pool */
    RUN startProcedure IN THIS-PROCEDURE ("PERSIST|ry/prc/ryobjectpoolp.p":U, 
                                          OUTPUT ghObjectPool).
    */

  gcMessageList = "":U.
  /* Find the entity */
  FIND FIRST bgsc_entity_mnemonic NO-LOCK
    WHERE bgsc_entity_mnemonic.entity_mnemonic = pcEntityMnemonic
    NO-ERROR.
  IF NOT AVAILABLE(bgsc_entity_mnemonic) THEN
  DO:
    cMessString = "entity_mnemonic = ":U + pcEntityMnemonic.
    cRetVal = {af/sup2/aferrortxt.i 'AF' '11' 'gsc_entity_mnemonic' 'entity_mnemonic' 'gsc_entity_mnemonic' cMessString}.
    RETURN cRetVal.
  END.

  /* Determine what the qualified database name is for this
     table. If database is not blank, try and qualify the table with
     the database name */
  IF bgsc_entity_mnemonic.entity_dbname <> ? AND
     bgsc_entity_mnemonic.entity_dbname <> "":U THEN
    cQualTable = bgsc_entity_mnemonic.entity_dbname + ".":U.

  /* Tag on the table name. */
  cQualTable = cQualTable + bgsc_entity_mnemonic.entity_mnemonic_description.

  /* Create a buffer for the table */
  RUN obtainPoolObject /* IN ghObjectPool */
    ("BUFFER":U, 
     cQualTable, 
     OUTPUT hChild).
  
  /* If the join entity is not blank, find it too */
  IF pcJoinEntity <> "":U THEN
  DO:
    FIND FIRST bgsc_entity_mnemonic NO-LOCK
      WHERE bgsc_entity_mnemonic.entity_mnemonic = pcJoinEntity
      NO-ERROR.
    IF NOT AVAILABLE(bgsc_entity_mnemonic) THEN
    DO:
      cMessString = "entity_mnemonic = ":U + pcJoinEntity.
      cRetVal = {af/sup2/aferrortxt.i 'AF' '11' 'gsc_entity_mnemonic' 'entity_mnemonic' 'gsc_entity_mnemonic' cMessString}.
      RETURN cRetVal.
    END.
  
    cQualTable = "":U.
  
    /* Determine what the qualified database name is for this
       table. If database is not blank, try and qualify the table with
       the database name */
    IF bgsc_entity_mnemonic.entity_dbname <> ? AND
       bgsc_entity_mnemonic.entity_dbname <> "":U THEN
      cQualTable = bgsc_entity_mnemonic.entity_dbname + ".":U.
  
    /* Tag on the table name. */
    cQualTable = cQualTable + bgsc_entity_mnemonic.entity_mnemonic_description.
  
    /* Create a buffer for the table */
    RUN obtainPoolObject /* IN ghObjectPool */
      ("BUFFER":U, 
       cQualTable, 
       OUTPUT hParent).
  END.

  IF plPrimary THEN
  DO:
    /* Create the query string. */
    cQueryString = buildForEach(hChild, 
                                pcJoinFieldList, 
                                ?, 
                                "<default>":U,
                                pcFilterWhere,
                                NO).
  END.
  ELSE
  DO:
    /* Create the query string. */
    cQueryString = buildForEach(hChild, 
                                pcJoinFieldList, 
                                hParent, 
                                "<default>":U,
                                pcFilterWhere,
                                NO).
  END.
  
  IF cQueryString = ? THEN
    cRetVal = gcMessageList.
  
  IF cQueryString <> ? AND
     cQueryString <> "":U THEN
    hQuery = setupQuery(hChild, cQueryString).

  IF cRetVal <> "":U OR
     NOT VALID-HANDLE(hQuery) THEN
    cRetVal = gcMessageList.

  IF VALID-HANDLE(hQuery) THEN
  DO:
    hQuery:QUERY-CLOSE().
    RUN releasePoolObject /* IN ghObjectPool */
      (hQuery).
    hQuery = ?.
  END.

  IF VALID-HANDLE(hParent) THEN
  DO:
    RUN releasePoolObject /* IN ghObjectPool */
      (hParent).
    hParent = ?.
  END.

  IF VALID-HANDLE(hChild) THEN
  DO:
    RUN releasePoolObject /* IN ghObjectPool */
      (hChild).
    hChild = ?.
  END.

  RETURN cRetVal.   /* Function return value. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-verifyRecordVersions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verifyRecordVersions Procedure 
PROCEDURE verifyRecordVersions :
/*------------------------------------------------------------------------------
  Purpose:     This procedure verifies that 
               a) There are no record version records that are not marked as 
                  deletions for records that no longer exist in the database.
               b) There is a record version record for every record in the
                  database that needs one.
               c) Verifies that the data in the gst_record_version key field
                  is correct.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcEMList                AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hBuffer                         AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hQuery                          AS HANDLE       NO-UNDO.
  DEFINE VARIABLE cTable                          AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cWhereClause                    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cKeyFieldValue                  AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cSecondaryKeyValue              AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cUserLogin                      AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE dSiteNo                         AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dLastVer                        AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dImpVer                         AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dVerNo                          AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dMaxVer                         AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dLastSeq                        AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE iCount                          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lWhackIt                        AS LOGICAL      NO-UNDO.
  

  DEFINE BUFFER bgsc_dataset_entity   FOR gsc_dataset_entity.
  DEFINE BUFFER bgsc_entity_mnemonic  FOR gsc_entity_mnemonic.
  DEFINE BUFFER bgst_record_version   FOR gst_record_version.
  DEFINE BUFFER bgst_release_version  FOR gst_release_version.

  /*
  IF NOT VALID-HANDLE(ghObjectPool) THEN
    /* Start the Object Pool */
    RUN startProcedure IN THIS-PROCEDURE ("PERSIST|ry/prc/ryobjectpoolp.p":U, 
                                          OUTPUT ghObjectPool).
                                          */

  /* Get the current user's login - we'll need this later and it's cheaper
    to do it once here than on every iteration of record that we need to update */
  cUserLogin = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                INPUT "currentUserLogin":U,
                                INPUT NO).

  dSiteNo    = DYNAMIC-FUNCTION("getSiteMantissa":U IN gshRIManager).

  RUN obtainPoolObject /* IN ghObjectPool */
    ("QUERY":U, 
     "":U, 
     OUTPUT hQuery).
  FOR EACH bgsc_dataset_entity NO-LOCK
    WHERE bgsc_dataset_entity.primary_entity
      AND CAN-DO(pcEMList, bgsc_dataset_entity.entity_mnemonic):

    /* Find the entity_mnemonic */
    FIND FIRST bgsc_entity_mnemonic NO-LOCK
      WHERE bgsc_entity_mnemonic.entity_mnemonic = bgsc_dataset_entity.entity_mnemonic
      NO-ERROR.
    ERROR-STATUS:ERROR = NO.
    IF NOT AVAILABLE(bgsc_entity_mnemonic) OR
       NOT bgsc_entity_mnemonic.version_data THEN
      NEXT.

    /* Create the buffer for this table */
    cTable = (IF bgsc_entity_mnemonic.entity_db <> "":U THEN bgsc_entity_mnemonic.entity_db + ".":U ELSE "":U)
           + bgsc_entity_mnemonic.entity_mnemonic_description.
    RUN obtainPoolObject /* IN ghObjectPool */
      ("BUFFER":U, 
       cTable, 
       OUTPUT hBuffer).
    
    for-blk:
    FOR EACH bgst_record_version EXCLUSIVE-LOCK
      WHERE bgst_record_version.entity_mnemonic = bgsc_entity_mnemonic.entity_mnemonic
      TRANSACTION ON ERROR UNDO for-blk, LEAVE for-blk:
      
      /* At this point we need to figure out what data we are going to dump. First we need to find the
         record in the main table for this record version record */
        IF bgsc_entity_mnemonic.table_has_object_field THEN
          cWhereClause = "WHERE ":U + buildWhereFromKeyVal(CHR(1),
                                              bgsc_entity_mnemonic.entity_object_field,
                                              bgst_record_version.key_field_value,
                                              hBuffer).
        ELSE
          cWhereClause = "WHERE ":U + buildWhereFromKeyVal(CHR(1),
                                             bgsc_entity_mnemonic.entity_key_field,
                                             bgst_record_version.key_field_value,
                                             hBuffer).

      /* Now we actually try the find. */
      IF cWhereClause <> "":U AND 
         cWhereClause <> ? THEN
      DO:
        hBuffer:FIND-FIRST(cWhereClause, NO-LOCK) NO-ERROR.
        ERROR-STATUS:ERROR = NO.
      END.
      ELSE IF hBuffer:AVAILABLE THEN
          hBuffer:BUFFER-RELEASE().

      IF NOT hBuffer:AVAILABLE THEN
      DO:
        /* Skip the deletions. */
        IF bgst_record_version.deletion_flag THEN
          NEXT for-blk.

        FOR EACH bgst_release_version
          WHERE bgst_release_version.record_version_obj = bgst_record_version.record_version_obj:
          DELETE bgst_release_version.
        END.
        DELETE bgst_record_version.
        NEXT for-blk.
      END.

      RUN determineKeyFields
        (BUFFER bgsc_entity_mnemonic,
         INPUT hBuffer,
         OUTPUT cKeyFieldValue,
         OUTPUT cSecondaryKeyValue)
        .

      IF cKeyFieldValue     <> bgst_record_version.key_field_value OR
         cSecondaryKeyValue <> bgst_record_version.secondary_key_value OR
         bgst_record_version.deletion_flag = YES THEN
      DO:
        RUN calcLastVersionNo IN gshRIManager
          (INPUT        bgst_record_version.version_number_seq,
           INPUT        bgst_record_version.import_version_number_seq,
           INPUT-OUTPUT bgst_record_version.last_version_number_seq).
        
        ASSIGN
          bgst_record_version.key_field_value         = cKeyFieldValue
          bgst_record_version.secondary_key_value     = cSecondaryKeyValue
          bgst_record_version.last_version_number_seq = bgst_record_version.last_version_number_seq + 1
          bgst_record_version.version_number_seq      = bgst_record_version.last_version_number_seq
          bgst_record_version.version_date            = TODAY
          bgst_record_version.version_time            = TIME
          bgst_record_version.version_user            = cUserLogin
          bgst_record_version.deletion_flag           = NO
        .
      END.
    END.

    IF ERROR-STATUS:ERROR THEN
      LEAVE.

    /* Now we need to open a query on this buffer, loop through all the
       records in the buffer, and make sure there is a corresponding 
       gst_record_version */
    hQuery:SET-BUFFERS(hBuffer).
    hQuery:QUERY-PREPARE("FOR EACH " + hBuffer:NAME + " NO-LOCK":U).
    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST().

    rpt-blk:
    REPEAT WHILE NOT hQuery:QUERY-OFF-END:
      cKeyFieldValue     = buildKeyVal(hBuffer, bgsc_entity_mnemonic.entity_object_field, CHR(1), YES).
      cSecondaryKeyValue = buildKeyVal(hBuffer, bgsc_entity_mnemonic.entity_key_field, CHR(1), YES).
      FIND FIRST bgst_record_version NO-LOCK
        WHERE bgst_record_version.entity_mnemonic = bgsc_entity_mnemonic.entity_mnemonic
          AND bgst_record_version.key_field_value = cKeyFieldValue
        NO-ERROR.
      ERROR-STATUS:ERROR = NO.
      IF NOT AVAILABLE(bgst_record_version) THEN
      trn-blk:
      DO TRANSACTION ON ERROR UNDO trn-blk, LEAVE trn-blk:
        CREATE bgst_record_version.
        ASSIGN
          bgst_record_version.entity_mnemonic = bgsc_entity_mnemonic.entity_mnemonic
          bgst_record_version.key_field_value = cKeyFieldValue 
          bgst_record_version.secondary_key_value = cSecondaryKeyValue
          bgst_record_version.last_version_number_seq = dSiteNo + 1
          bgst_record_version.version_number_seq = bgst_record_version.last_version_number_seq
          bgst_record_version.version_date = TODAY
          bgst_record_version.version_time = TIME
          bgst_record_version.version_user = cUserLogin
          bgst_record_version.deletion_flag = NO
          .
      END.
      ERROR-STATUS:ERROR = NO.
      hQuery:GET-NEXT().
    END.
    hQuery:QUERY-CLOSE().

    RUN releasePoolObject /* IN ghObjectPool */
      (hBuffer).
    
    IF ERROR-STATUS:ERROR THEN
      LEAVE.
  END.
  
  RUN releasePoolObject /* IN ghObjectPool */
      (hQuery).

  IF ERROR-STATUS:ERROR THEN 
    RETURN ERROR RETURN-VALUE.
  ELSE
    RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeADOSet) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeADOSet Procedure 
PROCEDURE writeADOSet :
/*------------------------------------------------------------------------------
  Purpose:     Accepts a handle to temp-table with all the Datasets to be 
               written and their selected records, and calls 
               writeDeploymentDataset to actually write out the ADOs.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcPath          AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcBlankPath     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plResetModified AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plDeployDeletes AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plRemoveDeletes AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plAllModified   AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plFullDS        AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER phDataset       AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER phRecordSet     AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER plByDate        AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdtStart        AS DATE       NO-UNDO.
  DEFINE INPUT  PARAMETER pdtEnd          AS DATE       NO-UNDO.

  DEFINE VARIABLE hDatasetQry     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRecordsetQry   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataset        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRecordset      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDSCode         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hKey            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFilePerRec     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFileName       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iRecCount       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hMainTable      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cWhereClause    AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cRetVal         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOutFile        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOutPath        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTotRec         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRecsProc       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cProc           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lResetModified  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cExtra          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRecKey         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRecFileName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hField          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount          AS INTEGER    NO-UNDO.

  DEFINE BUFFER bttADOParam          FOR ttADOParam.
  DEFINE BUFFER bgst_record_version  FOR gst_record_version.
  DEFINE BUFFER bgsc_entity_mnemonic FOR gsc_entity_mnemonic.
  DEFINE BUFFER bgsc_dataset_entity  FOR gsc_dataset_entity.
  DEFINE BUFFER bgsc_deploy_dataset  FOR gsc_deploy_dataset.

  /* 
  IF NOT VALID-HANDLE(ghObjectPool) THEN
    /* Start the Object Pool */
    RUN startProcedure IN THIS-PROCEDURE ("PERSIST|ry/prc/ryobjectpoolp.p":U, 
                                          OUTPUT ghObjectPool).
                                          */

  /* Open a query on the dataset buffer */

  RUN obtainPoolObject /* IN ghObjectPool */
    ("BUFFER":U, 
     STRING(phDataset), 
     OUTPUT hDataset).

  RUN obtainPoolObject /* IN ghObjectPool */
    ("BUFFER":U, 
     STRING(phRecordset), 
     OUTPUT hRecordset).

  IF plAllModified THEN
  DO:
    /* We ALWAYS deploy deletions with all modified data */
    plDeployDeletes = YES.
    hDataset:EMPTY-TEMP-TABLE().
    hRecordSet:EMPTY-TEMP-TABLE().
    /* We need to loop through each deployment dataset.*/
    FOR EACH bgsc_deploy_dataset NO-LOCK:

      /* Find the PRIMARY dataset entity in the deployment dataset */
      FIND FIRST  bgsc_dataset_entity NO-LOCK
        WHERE bgsc_dataset_entity.deploy_dataset_obj = bgsc_deploy_dataset.deploy_dataset_obj
          AND bgsc_dataset_entity.primary_entity
        NO-ERROR.

      IF NOT AVAILABLE(bgsc_dataset_entity) THEN
        NEXT.

      /* If we have the entity and either the source code data flag is set (RYCSO dataset) or
         FULLDS is off, we need a buffer for the entity to be able derive key values. */
      IF bgsc_deploy_dataset.source_code_data OR
         plFullDS = NO THEN
      DO:
        FIND FIRST bgsc_entity_mnemonic NO-LOCK
          WHERE bgsc_entity_mnemonic.entity_mnemonic = bgsc_dataset_entity.entity_mnemonic.
        RUN obtainPoolObject /* IN ghObjectPool */
          ("BUFFER":U, 
           bgsc_entity_mnemonic.entity_dbname + ".":U + bgsc_entity_mnemonic.entity_mnemonic_description, 
           OUTPUT hMainTable).
      END.

      /* Loop through all the gst_record_versions for this dataset entity that have changed */
      FOR EACH bgst_record_version NO-LOCK
        WHERE bgst_record_version.entity_mnemonic = bgsc_dataset_entity.entity_mnemonic
          AND bgst_record_version.version_number_seq <> bgst_record_version.import_version_number_seq
          AND (NOT plByDate OR
              (bgst_record_version.version_date >=  pdtStart AND
               bgst_record_version.version_date <=  pdtEnd))
          AND NOT bgst_record_version.deletion_flag
          BREAK BY bgst_record_version.entity_mnemonic:

        /* If this is the first record version for this dataset entity, make sure we have a
           record in the dataset table for it so that we will dump datasets for it */
        IF FIRST-OF(bgst_record_version.entity_mnemonic) THEN
        DO:
          phDataset:FIND-FIRST("WHERE dataset_code = ":U + QUOTER(bgsc_deploy_dataset.dataset_code)) NO-ERROR.
          ERROR-STATUS:ERROR = NO.

          IF NOT phDataset:AVAILABLE THEN /* Add a record to the dataset list so that we update them all */
          DO:
            hDataset:BUFFER-CREATE().
            hDataset:BUFFER-FIELD("dataset_code":U):BUFFER-VALUE   = bgsc_deploy_dataset.dataset_code.
            hDataset:BUFFER-FIELD("lFilePerRecord":U):BUFFER-VALUE = bgsc_deploy_dataset.source_code_data.
            hDataset:BUFFER-FIELD("cFileName":U):BUFFER-VALUE      = LC((IF bgsc_deploy_dataset.default_ado_filename <> "":U 
                                                                         THEN bgsc_deploy_dataset.default_ado_filename
                                                                         ELSE bgsc_deploy_dataset.dataset_code + ".ado":U)).
            hDataset:BUFFER-RELEASE().
          END.
        END.

        /* If we're deploying a full dataset and this is not source code data, then we're done for this
           record version record because everything will be put in the ADO.*/
        IF plFullDS AND
           NOT bgsc_deploy_dataset.source_code_data THEN 
          LEAVE.

        /* Deletions get dumped anyway */
        IF bgst_record_version.deletion_flag THEN
          NEXT.

        /* At this point we need to figure out what data we are going to dump. First we need to find the
           record in the main table for this record version record */
        IF bgsc_entity_mnemonic.table_has_object_field THEN
          cWhereClause = "WHERE ":U + buildWhereFromKeyVal(CHR(1),
                                              bgsc_entity_mnemonic.entity_object_field,
                                              bgst_record_version.key_field_value,
                                              hMainTable).
        ELSE
          cWhereClause = "WHERE ":U + buildWhereFromKeyVal(CHR(1),
                                             bgsc_entity_mnemonic.entity_key_field,
                                             bgst_record_version.key_field_value,
                                             hMainTable).

        IF cWhereClause = "":U OR
           cWhereClause = ? THEN
          NEXT.

        /* Now we actually try the find. */
        hMainTable:FIND-FIRST(cWhereClause, NO-LOCK) NO-ERROR.
        ERROR-STATUS:ERROR = NO.

        
        IF hMainTable:AVAILABLE THEN
        DO:

          /* If this is a source_code_data dataset, we need to build up the name of the file
             that will be dumped. */
          IF bgsc_deploy_dataset.source_code_data THEN
          DO:
            cRecFileName = getFileNameFromField(bgsc_dataset_entity.join_field_list,
                                                hMainTable).
            IF cRecFileName = ? THEN
              cRecFileName = "":U.
          END.
          ELSE
            cRecFileName = "":U.

          /* Now we need to build up the record key on the format of the primary entity in the
             dataset */
          cRecKey = "":U.
          DO iCount = 1 TO NUM-ENTRIES(bgsc_dataset_entity.join_field_list):
            hField = hMainTable:BUFFER-FIELD(ENTRY(iCount,bgsc_dataset_entity.join_field_list)) NO-ERROR.
            IF VALID-HANDLE(hField) THEN
              cRecKey = cRecKey + (IF cRecKey <> "":U THEN CHR(3) ELSE "":U)
                   + STRING(hField:BUFFER-VALUE).
            ELSE
              cRecKey = cRecKey + (IF cRecKey <> "":U THEN CHR(3) ELSE "":U)
                   + "?":U.
          END.
            

          /* Now we need to try and find a record in the record list that we will dump */
          hRecordSet:FIND-FIRST("WHERE dataset_code = ":U + QUOTER(bgsc_deploy_dataset.dataset_code) 
                                 + " AND cKey = ":U + QUOTER(cRecKey)) NO-ERROR.
          ERROR-STATUS:ERROR = NO.

          /* If we don't have one, create it */
          IF NOT hRecordSet:AVAILABLE THEN
          DO:
            hRecordSet:BUFFER-CREATE().
            hRecordSet:BUFFER-FIELD("dataset_code":U):BUFFER-VALUE = bgsc_deploy_dataset.dataset_code.
            hRecordSet:BUFFER-FIELD("cKey":U):BUFFER-VALUE         = cRecKey.
            hRecordSet:BUFFER-FIELD("cFileName":U):BUFFER-VALUE    = cRecFileName.
            hRecordSet:BUFFER-RELEASE().
          END.
        END.
      END. /* FOR EACH bgst_record_version NO-LOCK */

      IF VALID-HANDLE(hMainTable) THEN
      DO: 
        RUN releasePoolObject /* IN ghObjectPool */
          (hMainTable).
        hMainTable = ?.
      END.

    END. /* FOR EACH bgsc_deploy_dataset NO-LOCK */
  END. /* IF plAllModified THEN */
    
  RUN obtainPoolObject /* IN ghObjectPool */
    ("QUERY":U, 
     "":U, 
     OUTPUT hDatasetQry).
  hDatasetQry:SET-BUFFERS(hDataset).
  hDatasetQry:QUERY-PREPARE("PRESELECT EACH ":U + hDataset:NAME).
  hDatasetQry:QUERY-OPEN().
  iTotRec = hDatasetQry:NUM-RESULTS.
  hDatasetQry:GET-FIRST().

  hDSCode     = hDataset:BUFFER-FIELD("dataset_code":U).
  hFilePerRec = hDataset:BUFFER-FIELD("lFilePerRecord":U).
  hFileName   = hDataset:BUFFER-FIELD("cFilename":U).

  REPEAT WHILE NOT hDatasetQry:QUERY-OFF-END:
    iRecsProc = iRecsProc + 1.
    cProc = STRING(iRecsProc) + " of ":U + STRING(iTotRec) + " - ":U + hDSCode:BUFFER-VALUE. 
    IF hFilePerRec:BUFFER-VALUE THEN
     RUN writeContainedADOs(cProc, 
                            hDSCode:BUFFER-VALUE,
                            pcPath,
                            pcBlankPath,
                            hFileName:BUFFER-VALUE,
                            plResetModified,
                            plDeployDeletes,
                            plRemoveDeletes,
                            plAllModified,
                            plFullDS,
                            phRecordSet).
    ELSE
    DO:

      EMPTY TEMP-TABLE ttADOParam.

      /* Set the ADO Parameters that need to be passed in as
         additionals. */
      DO FOR bttADOParam:
        CREATE bttADOParam.
        ASSIGN                                       
          bttADOParam.cParam = "WriteDeletionsDataset":U
          bttADOParam.cValue = STRING(plDeployDeletes,"YES/NO":U)
        .
        CREATE bttADOParam.
        ASSIGN                                       
          bttADOParam.cParam = "RemoveDeletions":U
          bttADOParam.cValue = STRING(plRemoveDeletes,"YES/NO":U)
        .
      END.

      RUN obtainPoolObject /* IN ghObjectPool */
        ("QUERY":U, 
         "":U, 
         OUTPUT hRecordsetQry).
      hRecordsetQry:SET-BUFFERS(hRecordset).
      hRecordsetQry:QUERY-PREPARE("FOR EACH ":U + hRecordset:NAME + " WHERE ":U + hRecordSet:NAME + ".dataset_code = '" + hDSCode:BUFFER-VALUE + "'":U).
      hRecordsetQry:QUERY-OPEN().
      hRecordsetQry:GET-FIRST().
      iRecCount = 0.
      hKey = hRecordset:BUFFER-FIELD("cKey":U).
      EMPTY TEMP-TABLE ttRequiredRecord.
      REPEAT WHILE NOT hRecordsetQry:QUERY-OFF-END:
        CREATE ttRequiredRecord.
        ASSIGN
          iRecCount = iRecCount + 1
          ttRequiredRecord.iSequence = iRecCount
          ttRequiredRecord.cJoinFieldValue = hKey:BUFFER-VALUE
        .
        hRecordset:BUFFER-DELETE().
        hRecordsetQry:GET-NEXT().
      END.
      hRecordsetQry:QUERY-CLOSE().
      RUN releasePoolObject /* IN ghObjectPool */
        (hRecordsetQry).
      hRecordsetQry = ?.

      /* Among other things, create any missing folders. */
      cOutFile = setFileDetails(hFileName:BUFFER-VALUE,
                                pcPath,
                                pcBlankPath,
                                cOutPath). 

      PUBLISH "DSAPI_StatusUpdate":U 
        (cProc + " - ":U + 
         (IF LENGTH(cOutFile) > 45 THEN SUBSTRING(cOutFile,1,10) + "..." + SUBSTRING(cOutFile,LENGTH(cOutFile) - 32)
          ELSE cOutFile)).

      RUN writeDeploymentDataset
          (hDSCode:BUFFER-VALUE,
           "":U,
           cOutFile,
           cOutPath,
           YES,
           plResetModified,
           INPUT TABLE ttADOParam,
           INPUT TABLE ttRequiredRecord,
           OUTPUT cRetVal).      
    END.
    hDataset:BUFFER-DELETE().
    hDatasetQry:GET-NEXT().
  END.
  PUBLISH "DSAPI_StatusUpdate":U ("Complete":U).

  hDatasetQry:QUERY-CLOSE().

  RUN releasePoolObject /* IN ghObjectPool */
    (hDatasetQry).
  hDatasetQry = ?.
  
  RUN releasePoolObject /* IN ghObjectPool */
    (hRecordSet).
  hRecordSet = ?.

  RUN releasePoolObject /* IN ghObjectPool */
    (hRecordSet).
  hRecordSet = ?.

  /* IF VALID-HANDLE(ghObjectPool) THEN */
    RUN deletePool /* IN ghObjectPool */.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeContainedADOs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeContainedADOs Procedure 
PROCEDURE writeContainedADOs :
/*------------------------------------------------------------------------------
  Purpose:     Writes a dataset for each record inside the record set.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcProc          AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcDSCode        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcPath          AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcBlankPath     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcFileField     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plResetModified AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plDeployDeletes AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plRemoveDeletes AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plAllModified   AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plFullDS        AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER phRecordSet     AS HANDLE     NO-UNDO.

  
  DEFINE VARIABLE hRecordSet      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRecordSetQry   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFileName       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hKey            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTT             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRetVal         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOutFile        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOutPath        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTotRec         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRecsProc       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cProc           AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bttADOParam       FOR ttADOParam.

  EMPTY TEMP-TABLE ttADOParam.
  /* If we are going to deploy the deletions, the first thing to do is write
     the deletions dataset out */
  IF plDeployDeletes THEN 
  DO:
    /* Set the ADO Parameters that need to be passed in as
       additionals. */
    DO FOR bttADOParam:
      CREATE bttADOParam.
      ASSIGN                                       
        bttADOParam.cParam = "WriteDeletionsDataset":U
        bttADOParam.cValue = STRING(plDeployDeletes,"YES/NO":U)
      .
      CREATE bttADOParam.
      ASSIGN                                       
        bttADOParam.cParam = "WriteDeletionsOnly":U
        bttADOParam.cValue = "YES":U
      .
      CREATE bttADOParam.
      ASSIGN                                       
        bttADOParam.cParam = "RemoveDeletions":U
        bttADOParam.cValue = STRING(plRemoveDeletes,"YES/NO":U)
      .
    END.

    /* Now write an ADO for the deletions */

    cOutFile = setFileDetails(LC(pcDSCode + ".ado":U),
                              pcPath,
                              pcBlankPath,
                              cOutPath). 

    hTT = ?.

    RUN writeDeploymentDataset
        (pcDSCode,
         "":U,
         cOutFile,
         cOutPath,
         YES,
         plResetModified,
         INPUT TABLE ttADOParam, 
         INPUT TABLE-HANDLE hTT, /* Unknown */
         OUTPUT cRetVal).      

    EMPTY TEMP-TABLE ttADOParam.
  END.

  RUN obtainPoolObject /* IN ghObjectPool */
    ("BUFFER":U, 
     STRING(phRecordset), 
     OUTPUT hRecordset).

  RUN obtainPoolObject /* IN ghObjectPool */
    ("QUERY":U, 
     "":U, 
     OUTPUT hRecordsetQry).
  
  hRecordsetQry:SET-BUFFERS(hRecordset).
  hRecordsetQry:QUERY-PREPARE("PRESELECT EACH ":U + hRecordset:NAME + " WHERE ":U + hRecordSet:NAME + ".dataset_code = '" + pcDSCode + "'":U).
  hRecordsetQry:QUERY-OPEN().
  iTotRec = hRecordsetQry:NUM-RESULTS.

  /* If there are no records in this dataset, we need to build up a list of all of 
     the ones that should be dumped. */
  IF iTotRec = 0 THEN
  DO:
    hRecordsetQry:QUERY-CLOSE().
    /* Go fetch the list of records that we need */
    RUN selectDSRecords(pcDSCode, 
                        phRecordSet,
                        pcFileField,
                        "ALL":U).
    hRecordsetQry:QUERY-OPEN().
    iTotRec = hRecordsetQry:NUM-RESULTS.
  END.
  hRecordsetQry:GET-FIRST().
  hKey = hRecordset:BUFFER-FIELD("cKey":U).
  hFileName = hRecordset:BUFFER-FIELD("cFileName":U).
  REPEAT WHILE NOT hRecordsetQry:QUERY-OFF-END:
    cOutFile = setFileDetails(hFileName:BUFFER-VALUE,
                              pcPath,
                              pcBlankPath,
                              cOutPath). 
    iRecsProc = iRecsProc + 1.
    cProc = pcProc + " (Subset " + STRING(iRecsProc) + " of ":U + STRING(iTotRec) + " - ":U + cOutFile + ")". 
    PUBLISH "DSAPI_StatusUpdate" (cProc).

    hTT = ?.
   
    RUN writeDeploymentDataset
        (pcDSCode,
         hKey:BUFFER-VALUE,
         cOutFile,
         cOutPath,
         YES,
         plResetModified,
         INPUT TABLE ttADOParam, 
         INPUT TABLE-HANDLE hTT, /* Unknown */
         OUTPUT cRetVal).      
                
    hRecordset:BUFFER-DELETE().
    hRecordsetQry:GET-NEXT().
  END.
  hRecordsetQry:QUERY-CLOSE().
  RUN releasePoolObject /* IN ghObjectPool */
    (hRecordsetQry).
  hRecordsetQry = ?.
  RUN releasePoolObject /* IN ghObjectPool */
    (hRecordset).
  hRecordset = ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeDatasetFileRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeDatasetFileRecord Procedure 
PROCEDURE writeDatasetFileRecord :
/*------------------------------------------------------------------------------
  Purpose:     This procedure writes the dataset file record to the 
               gst_dataset_file table.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdeDatasetObj    AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdeDeploymentObj AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcFileName       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phNode           AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cCurrTimeSource AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lReset AS LOGICAL    NO-UNDO.

  DEFINE BUFFER bgst_dataset_file FOR gst_dataset_file.

  lReset = getAttribute(0, "ResetModifiedStatus":U) = "YES":U.
  IF lReset = ? THEN
    lReset = NO.

  
  trans-block:
  DO TRANSACTION:
    FIND FIRST bgst_dataset_file EXCLUSIVE-LOCK
      WHERE bgst_dataset_file.deployment_obj     = pdeDeploymentObj
        AND bgst_dataset_file.deploy_dataset_obj = pdeDatasetObj
        AND bgst_dataset_file.ado_filename       = pcFileName
      NO-ERROR.
    IF NOT AVAILABLE(bgst_dataset_file) THEN
    DO:
      IF NOT lReset THEN
        RETURN.
      CREATE bgst_dataset_file.
      ASSIGN
        bgst_dataset_file.deployment_obj     = pdeDeploymentObj
        bgst_dataset_file.deploy_dataset_obj = pdeDatasetObj   
        bgst_dataset_file.ado_filename       = pcFileName      
      .
    END.
    IF lReset THEN
    DO:
      /*
      cCurrTimeSource = SESSION:TIME-SOURCE.
      SESSION:TIME-SOURCE = BUFFER bgst_dataset_file:DBNAME.
      */
      ASSIGN
        bgst_dataset_file.loaded_date = TODAY
        bgst_dataset_file.loaded_time = TIME
      .
      /*
      SESSION:TIME-SOURCE = cCurrTimeSource.
      */
      VALIDATE bgst_dataset_file.
      RUN writeFileRecordVer (bgst_dataset_file.dataset_file_obj).
    END.
    /* Write out the record version attributes of this record,
       if applicable. */
    writeRecordVersionAttr("GSTDF":U, /* Entity mnemonic */
                           ?,           /* Buffer          */
                           STRING(bgst_dataset_file.dataset_file_obj),
                           phNode).     /* XML record node */

  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeDatasetToDB) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeDatasetToDB Procedure 
PROCEDURE writeDatasetToDB :
/*------------------------------------------------------------------------------
  Purpose:     Writes (recursively) all the data in the temp-table for a dataset
               into the corresponding database tables.
  Parameters:  <none>
  Notes:       This code makes use of several named do blocks. I hate this type 
               of programming, but it needs to happen here. We're using dynamic
               objects and if we need to return the error, we need to make
               sure the objects get properly cleaned up otherwise we'll have
               a memory leak. So if the code leaves a block, the intention is
               that nothing further in that block gets executed.
------------------------------------------------------------------------------
  DEFINE INPUT  PARAMETER piRequestNo    AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER phTTBuff       AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER plOverwrite    AS LOGICAL    NO-UNDO.
  DEFINE PARAMETER BUFFER pbttTable      FOR ttTable.                         */

/* This code has been moved to an include file because it is too big to fit in
   the AppBuilder's section editor */
  {af/app/gscddwritedstodb.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeDataToDB) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeDataToDB Procedure 
PROCEDURE writeDataToDB :
/*------------------------------------------------------------------------------
  Purpose:     Takes the data from the temp-tables, whacks what's in the 
               database and replaces it with the new stuff.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER piRequestNo   AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER phNode        AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER plEmptyTables AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plDeleteFirst AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plOverwrite   AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE lError        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hBuffer       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQryBuff      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDBBuff       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cCurrField    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hFromField    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hToField      AS HANDLE     NO-UNDO.

  DEFINE BUFFER bttTable      FOR ttTable.
  DEFINE BUFFER bttEntityList FOR ttEntityList.
  DEFINE BUFFER bttTableList  FOR ttTableList.
  /*
  DEFINE VARIABLE cDebugStop     AS CHARACTER  NO-UNDO.
  cDebugStop = getAttribute(piRequestNo, "DebugStop":U).
  IF cDebugStop = "YES":U THEN
  DO:
    debugger:initiate().
    debugger:set-break().
  END.
    */
  lError = NO.
  /* Loop through the top level tables */
  FOR EACH bttTable
    WHERE bttTable.cJoinMnemonic = "":U:

    /* Find the entity that is related to this table */
    FIND FIRST bttEntityList NO-LOCK
      WHERE bttEntityList.cEntityMnemonic = bttTable.cEntityMnemonic.

    /* Now find the temp-table that contains the data for this table */
    FIND FIRST bttTableList NO-LOCK
      WHERE bttTableList.iRequestNo = piRequestNo
        AND bttTableList.iTableNo   = bttEntityList.iTableNo.

    /* Get the handle to the buffer for the temp-table */
    RUN obtainPoolObject /* IN ghObjectPool */
      ("BUFFER":U, 
       STRING(bttTableList.hTable:DEFAULT-BUFFER-HANDLE), 
       OUTPUT hQryBuff).
      
    /* Open a query on the temp-table */
    RUN obtainPoolObject /* IN ghObjectPool */
      ("QUERY":U, 
       "":U, 
       OUTPUT hQuery).
    
    hQuery:SET-BUFFERS(hQryBuff).
    hQuery:QUERY-PREPARE("FOR EACH ":U + hQryBuff:NAME + " NO-LOCK":U).
    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST(NO-LOCK).

    REPEAT WHILE NOT hQuery:QUERY-OFF-END:
      /* Start a transaction */
      trans-block:
      DO TRANSACTION:
        /* Go and build a list of the tables that have data that may need to be
           deleted and delete the appropriate records. These records have to be
           deleted before we start building writing in the new dataset, otherwise
           we could land up with key field clashes. */
  
        RUN deleteOldData (piRequestNo,
                           plDeleteFirst,
                           plOverwrite,
                           hQryBuff,
                           BUFFER bttTable) NO-ERROR.
  
        IF ERROR-STATUS:ERROR THEN 
          UNDO trans-block, LEAVE trans-block.

        /* If the list of exclude fields is not blank, we need to copy the data from the
         exclude field list fields in the database back to the temp-table so that the
         data in the database is not overwritten */
        IF bttTable.cExcludeFields <> "":U THEN
        DO:
          /* Build a for each statement for this buffer */
          /* Get the handle to the buffer for the temp-table */
          RUN obtainPoolObject /* IN ghObjectPool */
            ("BUFFER":U, 
             bttTable.cDatabase + ".":U + bttTable.cTableName, 
             OUTPUT hDBBuff).
          IF obtainDatabaseRec(bttEntityList.cEntityMnemonic, 
                               hQryBuff,
                               hDBBuff) THEN
          DO:
            DO iCount = 1 TO NUM-ENTRIES(cExcludeFields):
              cCurrField = ENTRY(iCount,cExcludeFields).
              hFromField = hDBBuff:BUFFER-FIELD(cCurrField) NO-ERROR.
              hToField   = hQryBuff:BUFFER-FIELD(cCurrField) NO-ERROR.
              IF VALID-HANDLE(hFromField) AND
                 VALID-HANDLE(hToField) THEN
                hToField:BUFFER-VALUE = hFromField:BUFFER-VALUE.
            END.
          END.
          RUN releasePoolObject /* IN ghObjectPool */
            (hDBBuff).
        END.

        
        /* Write the temp-table contents to the database */
        RUN writeDatasetToDB (piRequestNo,
                              hQryBuff,
                              plOverwrite,
                              BUFFER bttTable) NO-ERROR.
        
        IF ERROR-STATUS:ERROR OR 
           (RETURN-VALUE <> "":U AND
            RETURN-VALUE <> ?) THEN
        DO:
          RUN writeNodeToErrorLog (piRequestNo, phNode, RETURN-VALUE).
          ERROR-STATUS:ERROR = NO.
          lError = YES.
          UNDO trans-block, LEAVE trans-block.
        END.

      END. /* trans-block: DO TRANSACTION:*/
      /* Get the next record */
      hQuery:GET-NEXT(NO-LOCK).
    
    END. /* REPEAT  */

    hQuery:QUERY-CLOSE().
    RUN releasePoolObject /* IN ghObjectPool */
      (hQuery).
    hQuery = ?.
    
    RUN releasePoolObject /* IN ghObjectPool */
      (hQryBuff).
    hQryBuff = ?.
    
  END. /* FOR EACH bttTable */

  IF plEmptyTables OR 
     NOT ERROR-STATUS:ERROR THEN
  /* Empty the temp-tables */
  FOR EACH bttTableList 
    WHERE bttTableList.iRequestNo = piRequestNo:
    hTable = bttTableList.hTable.

    hBuffer = hTable:DEFAULT-BUFFER-HANDLE.

    hBuffer:EMPTY-TEMP-TABLE().
  END.

  IF lError THEN
    RETURN "EDO":U.
  ELSE
    RETURN "":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeDeploymentDataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeDeploymentDataset Procedure 
PROCEDURE writeDeploymentDataset :
/*------------------------------------------------------------------------------
  Purpose:     Creates an XML file from the Dataset Deployment table and either 
               writes the document created to an XML file locally.
               
  Parameters:  
    pcDatasetCode     - The Deployment Dataset code as specified on 
                        gsc_deployment_dataset.dataset_code.
    pcInputFields     - The list of field values to be used as the foreign key
                        on the primary entity.
                        The field values are delimited by CHR(4) and if more than one
                        field makes up the join field list, the CHR(4) separated
                        entries are CHR(3) delimited. See notes below.
    pcFileName        - Name of XML file to be created. This is the relative path to 
                        the file.
    pcRootDir         - The name of the root directory to contain the file.
    plAbbrHeader      - If set to yes, this field will result in minimal information
                        being written to the dataset header.
                        If set to no, this field will result in full definitional
                        header information being written to the XML file.                 
    plResetModified   - If set to yes, the Data Modified Status is reset on all records.
                        If set to no, it is left alone.
    ttExportParam     - Used to contain any parameters someone may want to specify that
                        we do support that are not in the call signature. Saves
                        us having to change the call signature in future -- FutureProof.                    
    ttRequiredRecord  - An optional temp-table containing the list of records that has
                        the values for the fields specified in the field list
                        in gsc_dataset_entity.join_field_list.
    OUTPUT pcRetVal   - This field contains the return value if there is any.
                        The messages contained in this string stick to the 
                        ICF standard.                    
                     
  Notes:
    pcFileName is the standard relative path to the file. The value of this field 
    is used to update gst_dataset_file. pcRootDir contains the directory that the
    data is written to. This procedure concatenates the two together to produce
    the full path to the .ADO file. 
  
    pcInputFields and ttRequired records are mutually exclusive. If you specify
    a ttRequiredRecords table, pcInputFields is ignored. If you pass a 
    TABLE-HANDLE with ? in it to this procedure for ttRequiredRecord, the
    procedure tries to create entries in the local copy of the temp-table.
    If nothing is specified in either, the program dumps all records.
    
    The field cJoinFieldValue on ttRequiredRecord is a CHR(3) delimited list 
    of field values for each of the field names specified in the 
    join_field_list on gsc_dataset_entity.
    
    If the input field values are derived from pcInputFields, and more than
    one set is to be specified, the sets are delimited by CHR(4).
           
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcDatasetCode AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcInputFields AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcFileName    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcRootDir     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plAbbrHeader  AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plModified    AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER TABLE         FOR ttExportParam.
  DEFINE INPUT  PARAMETER TABLE         FOR ttRequiredRecord.
  DEFINE OUTPUT PARAMETER pcRetVal      AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hXMLDoc               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRootNode             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cMessage              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAns                  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCount                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lReset                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cFileName             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSlash                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iNoRecs               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lWriteEmpty           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cWriteEmpty           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lWriteDeletions       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cWriteDeletions       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWriteDeletionsOnly   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lWriteDeletionsOnly   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lRemoveDeletionRV     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cRemoveDeletionRV     AS CHARACTER  NO-UNDO.
  
  DEFINE BUFFER bgsc_deploy_dataset FOR gsc_deploy_dataset.
  DEFINE BUFFER bttTable            FOR ttTable.
  DEFINE BUFFER bttRequiredRecord   FOR ttRequiredRecord.
  DEFINE BUFFER bttEntityList       FOR ttEntityList.
  DEFINE BUFFER bttVersionReset     FOR ttVersionReset.

  /* 
  IF NOT VALID-HANDLE(ghObjectPool) THEN
    /* Start the Object Pool */
    RUN startProcedure IN THIS-PROCEDURE ("PERSIST|ry/prc/ryobjectpoolp.p":U, 
                                          OUTPUT ghObjectPool).
                                          */

  /* Make sure there are no errors in the message list. */
  gcMessageList = "":U.

  FOR EACH ttDSAttribute 
    WHERE ttDSAttribute.iRequestNo = 0:
    DELETE ttDSAttribute.
  END.

  /* Set an attribute for ResetModifiedStatus so that other procedures can get
     at this value. */
  setAttribute(0, 
               "ResetModifiedStatus":U, 
               (IF plModified THEN "YES":U ELSE "NO":U)).

  pcFileName = REPLACE(pcFileName,"~\":U, "/":U).
  pcFileName = RIGHT-TRIM(pcFileName, "/":U).
  
  /* Set an attribute for each of the parameters in ttExportParams */
  FOR EACH ttExportParam:
    setAttribute(0, 
                 ttExportParam.cParam, 
                 ttExportParam.cValue).
  END.
  
  cFileName = buildFileName(pcRootDir, pcFileName).

  /* Figure out if we have to write out an empty dataset */
  cWriteDeletions = getAttribute(0, "WriteDeletionsDataset":U).
  IF cWriteDeletions = "YES":U THEN
    lWriteDeletions = YES.
  ELSE
    lWriteDeletions = NO.

  /* Figure out if we have to write out an empty dataset */
  cWriteDeletionsOnly = getAttribute(0, "WriteDeletionsOnly":U).
  IF cWriteDeletionsOnly = "YES":U THEN
    lWriteDeletionsOnly = YES.
  ELSE
    lWriteDeletionsOnly = NO.

  /* Empty the ttVersionReset temp-table */
  EMPTY TEMP-TABLE ttVersionReset.

  /* If bttRequiredRecord is empty, try and populate it from
     pcInputFields. */
  FIND FIRST bttRequiredRecord
    NO-ERROR.
  IF NOT AVAILABLE(bttRequiredRecord) THEN
  DO:
    IF pcInputFields <> "":U THEN
    REPEAT iCount = 1 TO NUM-ENTRIES(pcInputFields,CHR(4)):
      CREATE bttRequiredRecord.
      ASSIGN
        bttRequiredRecord.iSequence = iCount
        bttRequiredRecord.cJoinFieldValue = ENTRY(iCount,pcInputFields,CHR(4))
      .
    END.
    /* Otherwise put a token record in bttRequiredRecord that dumps all
       data */
    ELSE
    DO TRANSACTION:
      CREATE bttRequiredRecord.
      ASSIGN
        bttRequiredRecord.iSequence = iCount
        bttRequiredRecord.cJoinFieldValue = "*":U
      .
    END.
  END.
  /* Empty the bttTable temp-table */
  EMPTY TEMP-TABLE bttTable.
  EMPTY TEMP-TABLE ttEntityList.

  /* Check if the deployment set exists */
  FIND FIRST bgsc_deploy_dataset NO-LOCK
    WHERE bgsc_deploy_dataset.dataset_code = pcDatasetCode
    NO-ERROR.
  IF NOT AVAILABLE(bgsc_deploy_dataset) THEN
  DO:
    cMessage = "dataset_code = ":U + pcDatasetCode.
    pcRetVal = {af/sup2/aferrortxt.i 'AF' '11' 'gsc_deploy_dataset' 'dataset_code' '"gsc_deploy_dataset"' cMessage}.
    RETURN.
  END.

  /* If this is not a deletions dataset, we need to skip deletions */
  IF NOT bgsc_deploy_dataset.deletion_dataset THEN
    ASSIGN
      lWriteDeletions = NO
      lWriteDeletionsOnly = NO
    .

  RUN createTopLevelNodes(OUTPUT hXMLDoc, OUTPUT hRootNode).
    /* Create the header portion of the XML file */
  lAns = writeDatasetHeader(hRootNode,
                            INPUT BUFFER bgsc_deploy_dataset:HANDLE, 
                            plAbbrHeader).
   
  IF lAns THEN
  DO:
    /* Now we need to create the deployment dataset data */
    iNoRecs = writeDataset(hRootNode, lWriteDeletions, lWriteDeletionsOnly).

    IF iNoRecs = ? THEN
      lAns = NO.
    ELSE
      lAns = YES.
  END.

  IF NOT lAns THEN
  DO:
    pcRetVal = {af/sup2/aferrortxt.i 'AF' '116' '?' '?' bgsc_deploy_dataset.dataset_code ''}
             + CHR(3) + gcMessageList.
    /* We can't return yet as we have to make sure that all the 
       dynamic objects get deleted */
  END.


  /* Delete all the buffer handles that were created and all the
     bttTable records. */
  FOR EACH bttTable:
    hBuffer = bttTable.hBuffer.
    IF VALID-HANDLE(hBuffer) THEN
    DO:
      RUN releasePoolObject /* IN THIS-PROCEDURE */
        (hBuffer).
      hBuffer = ?.
    END.
    DELETE bttTable.
  END.


  lReset = getAttribute(0, "ResetModifiedStatus":U) = "YES":U.
  IF lReset = ? THEN
    lReset = NO.
  
  /* We need to deal with whether there was any data in the dataset at this point. */
  IF lAns = YES THEN
  DO:
    /* If there was data in the dataset, write the dataset file record */
    IF iNoRecs > 0 THEN
      RUN writeDatasetFileRecord
        (bgsc_deploy_dataset.deploy_dataset_obj,
         0.0,
         pcFileName,
         hRootNode).
    ELSE
    DO:
      /* Figure out if we have to write out an empty dataset */
      cWriteEmpty = getAttribute(0, "WriteEmptyDataset":U).
      IF cWriteEmpty = "NO":U THEN
        lWriteEmpty = NO.
      ELSE
        lWriteEmpty = YES.
      
      IF lWriteEmpty THEN
      DO:
        /* If there was no data in the dataset, write out an empty dataset. */
        /* First, delete the existing root node and XML doc. They contain a lot
           of extra stuff that we don't need now. */
        DELETE OBJECT hXMLDoc.
        hXMLDoc = ?.
        DELETE OBJECT hRootNode.
        hRootNode = ?.
  
        /* Now create a new header */
        RUN createTopLevelNodes(OUTPUT hXMLDoc, OUTPUT hRootNode).
  
        /* Set the attribute to indicate the dataset is empty */
        hRootNode:SET-ATTRIBUTE("EmptyDataset":U,"YES":U).
      END.
      ELSE
        lAns = NO.
    END.
  END.
  
  /* Now save away the XML document.*/
  ERROR-STATUS:ERROR = NO.
  IF lAns THEN
  DO:
    lAns = hXMLDoc:SAVE("FILE",cFileName) NO-ERROR.
    cMessage = cFileName.
    
    /* Remove code from checkerr.i since there's a SET-WAIT-STATE that we don't want. */
    cMessageList = '':u.    
    DO iErrorLoop = 1 TO ERROR-STATUS:NUM-MESSAGES:
        cMessageList = cMessageList + (IF cMessageList = "":U THEN "":U ELSE CHR(3)) +
                     ERROR-STATUS:GET-MESSAGE(iErrorLoop) + CHR(4) + CHR(4).
    END.
    /* get rid of error messages in get-message list */
    cMessageList = cMessageList NO-ERROR.
    
    IF cMessageList <> "":U OR 
       NOT lAns THEN
      gcMessageList = gcMessageList + CHR(3) + 
                      {af/sup2/aferrortxt.i 'AF' '117' '?' '?' 'save' cMessage cMessageList}.
    ELSE
    DO:
      /* Check the ResetModifiedStatus flag. */
      lRemoveDeletionRV = getAttribute(0, "RemoveDeletions":U) = "YES":U.
      IF lRemoveDeletionRV = ? THEN
        lRemoveDeletionRV = NO.
      IF plModified THEN
        RUN resetModifiedStatus (lRemoveDeletionRV).
    END.
  END.
  EMPTY TEMP-TABLE bttTable.
  EMPTY TEMP-TABLE bttEntityList.
  EMPTY TEMP-TABLE bttVersionReset.
  EMPTY TEMP-TABLE ttExportParam.
  EMPTY TEMP-TABLE bttRequiredRecord.

  IF gcMessageList <> "":U THEN
    pcRetVal = gcMessageList.

  /* Delete the XML document handle */
  DELETE OBJECT hXMLDoc.
  hXMLDoc = ?.
  DELETE OBJECT hRootNode.
  hRootNode = ?.

  RETURN pcRetVal.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeFileRecordVer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeFileRecordVer Procedure 
PROCEDURE writeFileRecordVer :
/*------------------------------------------------------------------------------
  Purpose:     This procedure writes the record version data information about a
               file version record.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER deFileVerObj AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE cErrorText                      AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cUserLogin                      AS CHARACTER    NO-UNDO.
  
  DEFINE VARIABLE cCurrTimeSource                 AS CHARACTER    NO-UNDO.


  DEFINE BUFFER bgst_record_version FOR gst_record_version.

  trn-block:
  DO TRANSACTION:
    cUserLogin = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                              INPUT "currentUserLogin":U,
                              INPUT NO).

    FIND FIRST bgst_record_version EXCLUSIVE-LOCK
     WHERE bgst_record_version.entity_mnemonic = "GSTDF":U
       AND bgst_record_version.key_field_value = STRING(deFileVerObj)
     NO-ERROR.
    IF NOT AVAILABLE bgst_record_version THEN
    DO:

      CREATE bgst_record_version NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}    
      cErrorText = cMessageList.
      IF cErrorText <> "":U THEN UNDO trn-block, LEAVE trn-block.
      /* Seed the last version number with the site number */
      ASSIGN
        bgst_record_version.last_version_number_seq = giSiteRev / giSiteDiv
        .
    END.
    /*
    cCurrTimeSource = SESSION:TIME-SOURCE.
    SESSION:TIME-SOURCE = BUFFER bgst_record_version:DBNAME.
    */
    ASSIGN
      bgst_record_version.entity_mnemonic = "GSTDF":U
      bgst_record_version.KEY_field_value = STRING(deFileVerObj)
      bgst_record_version.last_version_number_seq = bgst_record_version.last_version_number_seq + 1
      bgst_record_version.version_number_seq = bgst_record_version.last_version_number_seq
      bgst_record_version.version_date = TODAY
      bgst_record_version.version_time = TIME
      bgst_record_version.version_user = cUserLogin
      bgst_record_version.deletion_flag = NO
      .          
/*
    SESSION:TIME-SOURCE = cCurrTimeSource.
    */
    VALIDATE bgst_record_version NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}    
    cErrorText = cMessageList.
    IF cErrorText <> "":U THEN UNDO trn-block, LEAVE trn-block.

  END. /* trn-block */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeNodeToErrorLog) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeNodeToErrorLog Procedure 
PROCEDURE writeNodeToErrorLog :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER piRequestNo AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER phNode      AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcErrorText AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hXDoc     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRootNode AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNewNode  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSubNode  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iErrors   AS INTEGER    NO-UNDO.

  hXDoc     = getObjectHandle(piRequestNo,"hErrDoc":U).
  iErrors   = INTEGER(getAttribute(piRequestNo,"NoErrors":U)).
  IF iErrors = ? THEN
    iErrors = 0.

  IF NOT VALID-HANDLE(hXDoc) THEN
    RETURN.
  
  IF iErrors = 0 THEN
  DO:
    hRootNode = getObjectHandle(piRequestNo,"hErrNode":U).
    IF NOT VALID-HANDLE(hRootNode) THEN
      RETURN.
    /* Put in a dataset records node */
    hSubNode = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr,
                                hRootNode, 
                                "dataset_records":U).
    registerObject(piRequestNo, "hErrDT":U, hSubNode).
  END.
  ELSE
    hSubNode = getObjectHandle(piRequestNo,"hErrDT":U).

  IF NOT VALID-HANDLE(hSubNode) THEN
    RETURN.
  
  CREATE X-NODEREF hNewNode.
  hXDoc:IMPORT-NODE(hNewNode, phNode, TRUE).
  hSubNode:APPEND-CHILD(hNewNode).
  hNewNode:SET-ATTRIBUTE("ErrorString":U, pcErrorText).
  DELETE OBJECT hNewNode.
  hNewNode = ?.
  iErrors = iErrors + 1.
  setAttribute(piRequestNo, "NoErrors":U, STRING(iErrors)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeTempTableData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeTempTableData Procedure 
PROCEDURE writeTempTableData :
/*------------------------------------------------------------------------------
  Purpose:     Takes the date from the ttNode table and writes it to the
               appropriate TEMP-TABLE.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER piRequestNo AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piNodeLevel AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piTableNo   AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piTransNo   AS INTEGER    NO-UNDO.

  DEFINE VARIABLE cMessage            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTempTable          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTTBuff             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWriteBuff          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount              AS INTEGER    NO-UNDO.

  DEFINE BUFFER bttNode        FOR ttNode.
  DEFINE BUFFER bttTableList   FOR ttTableList.
  DEFINE BUFFER bttTransaction FOR ttTransaction.

  /* First we have to find the buffer to for the temp-table that this record 
     belongs to. */

  FIND FIRST bttTableList NO-LOCK
    WHERE bttTableList.iRequestNo = piRequestNo
      AND bttTableList.iTableNo    = piTableNo NO-ERROR.
  IF NOT AVAILABLE(bttTableList) THEN
  DO:
    cMessage = {aferrortxt.i 'AF' '1999' '?' '?' piTableNo}.
    RETURN cMessage.
  END.

  /* Obtain the handle to the temp-table. */
  hTempTable = bttTableList.hTable.
  IF VALID-HANDLE(hTable) AND 
     hTable:TYPE = "TEMP-TABLE":U THEN
    hTTBuff = hTable:DEFAULT-BUFFER-HANDLE. /* Get a handle to the TT Buffer */

  /* If we don't have a handle to a valid buffer at this point, there is a problem */
  IF NOT VALID-HANDLE(hTTBuff) THEN
  DO:
    cMessage = {aferrortxt.i 'AF' '1999' '?' '?' bttTableList.cDBName cTableName}.
    RETURN cMessage.
  END.

  /* Now we need to create an alternate buffer for this temp-table */
  RUN obtainPoolObject /* IN ghObjectPool */
    ("BUFFER":U, 
     STRING(hTTBuff), 
     OUTPUT hWriteBuff).

  /* Write the data into the temp-table */
  DO TRANSACTION:
    /* Before we can write the data, we need to have available
       in the buffer, the appropriate record that will be updated.
       The following call will try and find a record which will be
       returned in hWriteBuff. */
    
    obtainTempTableRec(piRequestNo,
                       piNodeLevel,
                       piTableNo,
                       hWriteBuff).
    
    /* If we didn't find a record for the temp-table, create one */
    IF NOT hWriteBuff:AVAILABLE THEN
      hWriteBuff:BUFFER-CREATE().

    /* Now iterate through each of the nodes and assign the field 
       value to the temp-table record. */
    FOR EACH bttNode NO-LOCK
      WHERE bttNode.iRequestNo   = piRequestNo
        AND bttNode.iLevelNo     = piNodeLevel:
      /* Obtain the handle to the buffer field. */
      hField = hWriteBuff:BUFFER-FIELD(bttNode.cNode) NO-ERROR.

      /* If the field handle is valid, convert the data to the 
         appropriate data type and assign it to the correct node. */


      IF VALID-HANDLE(hField) THEN
      DO:
        IF hField:DATA-TYPE <> "CHARACTER":U AND
           bttNode.cValue = "?":U OR
           bttNode.cValue = ? THEN
        DO:
          IF hField:EXTENT > 0 THEN
          DO iCount = 1 TO hField:EXTENT:
            hField:BUFFER-VALUE[iCount] = ?.
          END.
          ELSE
            hField:BUFFER-VALUE = ?.
        END.
        ELSE
          setFieldValue(piRequestNo, hField, bttNode.cValue, bttNode.iExtentIndex).
      END.
    END.

    IF piNodeLevel = 1 THEN 
    DO:
      CREATE bttTransaction.
      ASSIGN
        bttTransaction.iRequestNo = piRequestNo
        bttTransaction.iTransNo   = piTransNo
        bttTransaction.rRowid     = hWriteBuff:ROWID
      .
    END.

    /* Release the record so it gets written to the table */
    hWriteBuff:BUFFER-RELEASE().

  END.

  /* Delete the buffer */
  RUN releasePoolObject /* IN ghObjectPool */
    (hWriteBuff).
  hWriteBuff = ?.

  /* Delete the node records at this level from the
     temp-table. */
  FOR EACH bttNode    
    WHERE bttNode.iRequestNo   = piRequestNo
      AND bttNode.iLevelNo     = piNodeLevel:
    DELETE bttNode.
  END.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeXMLPatchFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeXMLPatchFile Procedure 
PROCEDURE writeXMLPatchFile :
/*------------------------------------------------------------------------------
  Purpose:     Writes out the contents of ttPatch to a set of patch files.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcPatchFileName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDoc        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRootNode   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hPatchNode  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hStageNode  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hText       AS HANDLE     NO-UNDO.
  
  DEFINE BUFFER bttPatchList FOR ttPatchList.

  FOR EACH bttPatchList
    BREAK BY cPatchLevel
          BY cStage
          BY iSeq
          BY cFileName:

    IF FIRST(bttPatchList.cPatchLevel) THEN
    DO:
      RUN patchFileCreate
        (bttPatchList.cPatchLevel,
         OUTPUT hDoc,
         OUTPUT hRootNode,
         OUTPUT hPatchNode).
    END.

    IF VALID-HANDLE(hStageNode) THEN
    DO:
      hText = DYNAMIC-FUNCTION("createTextNode":U IN ghXMLHlpr,
                           hStageNode).
      /* Set the node value */
      hText:NODE-VALUE = CHR(9) + CHR(9) + CHR(9).

      DELETE OBJECT hText.
      hText = ?.
    END.

    IF FIRST-OF(bttPatchList.cStage) THEN
    DO:
      /* New patch stage */
      RUN patchStageStart(bttPatchList.cStage, hPatchNode, OUTPUT hStageNode).
    END.

    RUN patchProcNodeCreate(INPUT BUFFER bttPatchList:HANDLE, hStageNode). 

    IF LAST-OF(bttPatchList.cStage) THEN
    DO:
      /* End of patch level */
      RUN patchStageEnd(hStageNode).
      hStageNode = ?.

      IF NOT LAST-OF(bttPatchList.cPatchLevel) THEN
      DO:
        /* Add the text element into the new node */
        hText = DYNAMIC-FUNCTION("createTextNode":U IN ghXMLHlpr,
                                 hPatchNode).
        
        /* Set the node value */
        hText:NODE-VALUE = CHR(9) + CHR(9).
      
        DELETE OBJECT hText.
        hText = ?.
      END.
  

    END.
    
    IF LAST-OF(bttPatchList.cPatchLevel) THEN
    DO:
      /* Close the document and write it away */
      RUN patchFileClose
        (pcPatchFileName,
         bttPatchList.cPatchLevel,
         hDoc,
         hRootNode,
         hPatchNode).
      hDoc = ?.
      hRootNode = ?.
      hPatchNode = ?.
    END.

  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-applyRules) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION applyRules Procedure 
FUNCTION applyRules RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN 0.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignNode Procedure 
FUNCTION assignNode RETURNS CHARACTER
  ( INPUT piRequestNo AS INTEGER, 
    INPUT piNodeLevel AS INTEGER, 
    INPUT piTableNo   AS INTEGER, 
    INPUT phParent    AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  This procedure is responsible for pulling data from the lower level
            of an field node into a database record.
    Notes:  
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE hNode        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lSuccess     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCount       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cValue       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iExtentIndex AS INTEGER    NO-UNDO.

  /* Set the node to look at the next child */
  CREATE X-NODEREF hNode.

  /* Iterate through the children */
  REPEAT iCount = 1 TO phParent:NUM-CHILDREN:
    /* Set the node to the child node */
    lSuccess = phParent:GET-CHILD(hNode,iCount).
    IF NOT lSuccess THEN
      NEXT.

    /* If this is not a text node, skip it */
    IF hNode:SUBTYPE <> "TEXT":U THEN
      NEXT.

    cValue = REPLACE(hNode:NODE-VALUE, CHR(10), "":U).
    cValue = REPLACE(cValue, CHR(13), "":U).
    cValue = TRIM(cValue).

    /* Skip any blank values in the contained_record node that
       we may have put there for SCM */
    IF cValue = "":U AND
       phParent:NAME = "contained_record":U THEN
      NEXT.
    ELSE 
      cValue = hNode:NODE-VALUE.

    IF CAN-DO(phParent:ATTRIBUTE-NAMES,"ExtentIndex":U) THEN
      iExtentIndex = INTEGER(phParent:GET-ATTRIBUTE("ExtentIndex":U)).
    ELSE
      iExtentIndex = 0.

    setNodeValue
      (piRequestNo,
       piNodeLevel,
       piTableNo,
       phParent:NAME,
       iExtentIndex,
       cValue,
       YES).

  END.

  DELETE OBJECT hNode.
  hNode = ?.


  RETURN "":U.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildErrList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildErrList Procedure 
FUNCTION buildErrList RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRetVal AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount  AS INTEGER    NO-UNDO.
  
  DO iCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
    cRetVal = cRetVal + (IF cRetVal = "":U THEN "":U ELSE CHR(10))
            + ERROR-STATUS:GET-MESSAGE(iCount).
  END.

  RETURN cRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildFileName Procedure 
FUNCTION buildFileName RETURNS CHARACTER
  ( INPUT pcRootDir AS CHARACTER,
    INPUT pcFileName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Concatenate the directory and filename and produce a proper file.   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFileName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSlash    AS CHARACTER  NO-UNDO.

  ASSIGN
    pcRootDir = REPLACE(pcRootDir,"~\":U, "/":U)
    pcFileName = REPLACE(pcFileName,"~\":U, "/":U)
    pcRootDir = RIGHT-TRIM(pcRootDir, "/":U)
    pcFileName = TRIM(pcFileName, "/":U)    /* trim off both ends since we're about to append again */
    cFileName = pcRootDir + "/":U + pcFileName
  .
  
  RETURN cFileName.   /* Function return value. */
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildForEach) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildForEach Procedure 
FUNCTION buildForEach RETURNS CHARACTER
  ( INPUT phBuffer         AS HANDLE,
    INPUT pcFieldList      AS CHARACTER,
    INPUT phParent         AS HANDLE,
    INPUT pcJoinFieldValue AS CHARACTER,
    INPUT pcWhereClause    AS CHARACTER,
    INPUT plLock           AS LOGICAL) :
/*------------------------------------------------------------------------------
     Purpose:  Builds up a FOR EACH statement against phBuffer based on the buffer
               name. 
  
  Parameters: 
    phBuffer         - The buffer to build the FOR EACH statement for.
    pcFieldList      - A field list whose values must be derived from either phParent
                       or pcJoinFieldValue.
                       If this field is blank, the where clause does not use the 
                       pcFieldList parameter at all.
                       If the values are to be derived from phParent, pcFieldList 
                       consists of a set of paired field names. The first field
                       in each pair is found in hBuffer, and the second is found
                       in phParent.
                       If the values are to be derived from pcJoinFieldValue, each
                       field has it's value specified by a CHR(3) delimited entry
                       in pcJoinFieldValue.
    phParent         - The handle to the parent buffer. If ? the FieldList derives
                       its values from pcJoinFieldValue.
    pcJoinFieldValue - The CHR(3) delimited list of values for the fields in 
                       pcFieldList. If blank, these values are derived from
                       phParent.
    pcWhereClause    - The extra criteria to be appended to the end of the 
                       where clause. If specified, the where clause is
                       appended in parenthesis if something else has been
                       specified earlier.
    plLock           - Indicates the lock type to be acquired on the query.
                       If set to YES, the FOR EACH has an EXCLUSIVE-LOCK appended.
                       If set to NO, the FOR EACH has a NO-LOCK appended.                        
                   
       Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cRetVal           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryBaseString  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCalcWhere        AS CHARACTER  NO-UNDO.
  
  /* Set up the query base string */
  cQueryBaseString = "FOR EACH ":U + phBuffer:NAME + (IF plLock THEN " EXCLUSIVE-LOCK ":U ELSE " NO-LOCK ").

  /* If the field list is not blank, figure out what the field
     values should be. */
  IF pcFieldList <> "":U THEN
    cCalcWhere = calcFieldListWhere(phBuffer, pcFieldList, phParent, pcJoinFieldValue, "":U).

  /* Now put the pieces together */
  IF (cCalcWhere <> ? AND
      cCalcWhere <> "":U) OR 
     pcWhereClause <> "":U THEN
    cWhere = "WHERE ":U.

  IF cCalcWhere <> ? AND
     cCalcWhere <> "":U THEN
    cWhere = cWhere + cCalcWhere.

  IF cCalcWhere <> ? AND
     pcWhereClause <> "":U THEN
  DO:
    IF cCalcWhere <> "":U THEN
      cWhere = cWhere + " AND (":U + pcWhereClause + ")":U.
    ELSE
      cWhere = cWhere + pcWhereClause.
  END.

  IF cCalcWhere <> ? THEN
    cRetVal = cQueryBaseString + cWhere.
  ELSE
    cRetVal = ?.

  RETURN cRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildKeyVal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildKeyVal Procedure 
FUNCTION buildKeyVal RETURNS CHARACTER
  (INPUT phTable        AS HANDLE, 
   INPUT pcFieldList    AS CHARACTER, 
   INPUT pcDelimiter    AS CHARACTER,
   INPUT plStandardForm AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  Loops through a list of field names and builds up a string 
            containing their values delimited by delimiter.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCount   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cKey     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hField   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cValue   AS CHARACTER  NO-UNDO.

  /* Iterate through all the elements of the key field and make them
     part of the key. */
  DO iCount = 1 TO NUM-ENTRIES(pcFieldList):
    hField = phTable:BUFFER-FIELD(ENTRY(iCount,pcFieldList)) NO-ERROR.
    ERROR-STATUS:ERROR = NO.
    IF VALID-HANDLE(hField) THEN
    DO:
      IF plStandardForm THEN
        cValue = DYNAMIC-FUNCTION("getFieldStringValue":U IN gshRIManager,
                                  hField).
      ELSE
        cValue = (IF hField:BUFFER-VALUE <> ? THEN STRING(hField:BUFFER-VALUE) 
                  ELSE "?":U).

      cKey = cKey 
           + (IF cKey <> "":U THEN pcDelimiter ELSE "":U) 
           + cValue.
    END.
    ELSE
      cKey = cKey + pcDelimiter.
  END.

  RETURN cKey.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildWhereFromKeyList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildWhereFromKeyList Procedure 
FUNCTION buildWhereFromKeyList RETURNS CHARACTER
  ( INPUT phBuffer    AS HANDLE,
    INPUT pcFieldList AS CHARACTER,
    INPUT pcFieldVal  AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Build a where clause up from the delimited values in the string that
            is in the key for the 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cWhere      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE dDec        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE tDate       AS DATE       NO-UNDO.
  DEFINE VARIABLE hField      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cCurrDF     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrNumSep AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrNumDec AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cVal        AS CHARACTER  NO-UNDO.

  IF NUM-ENTRIES(pcFieldList) = NUM-ENTRIES(pcFieldVal,CHR(1)) THEN
  DO iCount = 1 TO NUM-ENTRIES(pcFieldList):
    hField = phBuffer:BUFFER-FIELD(ENTRY(iCount,pcFieldList)) NO-ERROR.
    IF ERROR-STATUS:ERROR OR
       NOT VALID-HANDLE(hField) THEN
    DO:
      ERROR-STATUS:ERROR = NO.
      RETURN "":U.
    END.

    CASE hField:DATA-TYPE:
      WHEN "DATE":U THEN
      DO:
        cCurrDF = SESSION:DATE-FORMAT.
        SESSION:DATE-FORMAT = "mdy":U.
        tDate = DATE(ENTRY(iCount,pcFieldVal,CHR(1))).
        SESSION:DATE-FORMAT = cCurrDF.
        cVal = STRING(tDate).
      END.
      WHEN "DECIMAL":U THEN
      DO:
        cCurrNumSep = SESSION:NUMERIC-SEPARATOR.
        cCurrNumDec = SESSION:NUMERIC-DECIMAL-POINT.
        SESSION:SET-NUMERIC-FORMAT(",":U,".":U).
        dDec = DECIMAL(ENTRY(iCount,pcFieldVal,CHR(1))).
        SESSION:SET-NUMERIC-FORMAT(cCurrNumSep,cCurrNumDec).
        cVal = STRING(dDec).
      END.
      OTHERWISE
        cVal = ENTRY(iCount,pcFieldVal,CHR(1)).
    END CASE.
    cWhere = cWhere + (IF cWhere = "":U THEN "":U ELSE " AND ":U)
           + ENTRY(iCount,pcFieldList) + " = ":U 
           + TRIM(QUOTER(cVal)).
  END.
  ELSE
    cWhere = "":U.

  IF cWhere <> "":U THEN
    cWhere = "WHERE ":U + cWhere.
  
  RETURN cWhere.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildWhereFromKeyVal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildWhereFromKeyVal Procedure 
FUNCTION buildWhereFromKeyVal RETURNS CHARACTER
  ( INPUT pcDelimiter  AS CHARACTER,
    INPUT pcFieldList  AS CHARACTER,
    INPUT pcFieldValue AS CHARACTER,
    INPUT phTableBuff  AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will build a where clause to find the record version
            record that belongs to a certain database record. 
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cWhereClause AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldValue  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hField       AS HANDLE     NO-UNDO.

  IF NUM-ENTRIES(pcFieldList) <> NUM-ENTRIES(pcFieldValue, pcDelimiter) THEN
    RETURN "":U.

  /* Loop through the fields in the list */
  DO iCount = 1 TO NUM-ENTRIES(pcFieldList):

    /* Get the field name */
    cField       = ENTRY(iCount, pcFieldList).

    /* Get a handle to the field on the buffer so we can get the data type */
    hField       = phTableBuff:BUFFER-FIELD(cField).

    /* Get the value of the field */
    cFieldValue  = ENTRY(iCount, pcFieldValue, pcDelimiter).

    /* Build up the where clause */
    cWhereClause = cWhereClause + (IF cWhereClause = "":U THEN "":U ELSE " AND ":U)
                 + phTableBuff:NAME + ".":U + cField + " = ":U 
                 + convDTForWhere(hField:DATA-TYPE, cFieldValue, 0, "S":U).
  END.

  RETURN cWhereClause.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-calcFieldListWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION calcFieldListWhere Procedure 
FUNCTION calcFieldListWhere RETURNS CHARACTER
  ( INPUT phBuffer         AS HANDLE,
    INPUT pcFieldList      AS CHARACTER,
    INPUT phParent         AS HANDLE,
    INPUT pcJoinFieldValue AS CHARACTER,
    INPUT pcDataFormat     AS CHARACTER) :
/*------------------------------------------------------------------------------
     Purpose:  Builds up a snippet of a where clause. 
  
  Parameters: 
    phBuffer         - The buffer to build the where clause for.
    pcFieldList      - A field list whose values must be derived from either phParent
                       or pcJoinFieldValue.
                       If this field is blank, the where clause does not use the 
                       pcFieldList parameter at all.
                       If the values are to be derived from phParent, pcFieldList 
                       consists of a set of paired field names. The first field
                       in each pair is found in hBuffer, and the second is found
                       in phParent.
                       If the values are to be derived from pcJoinFieldValue, each
                       field has it's value specified by a CHR(3) delimited entry
                       in pcJoinFieldValue.
    phParent         - The handle to the parent buffer. If ? the FieldList derives
                       its values from pcJoinFieldValue.
    pcJoinFieldValue - The CHR(3) delimited list of values for the fields in 
                       pcFieldList. If blank, these values are derived from
                       phParent.
       Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRetVal            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lParent            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cChildField        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hChildField        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cParentField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hParentField       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lDefault           AS LOGICAL    NO-UNDO.

   
  lParent = pcFieldList <> "":U AND VALID-HANDLE(phParent).

  IF lParent THEN
  DO:
    /* If the user default values, return the default values */
    IF pcJoinFieldValue = "<default>":U THEN
      lDefault = YES.
    
    IF NUM-ENTRIES(pcFieldList) MOD 2 <> 0 THEN
    DO:
      gcMessageList = gcMessageList + CHR(3) +
                      {af/sup2/aferrortxt.i 'AF' '115' '?' '?' 'calcFieldListWhere' 'pcFieldList' pcFieldList}.
        
      RETURN ?. /* This string has to contain an even number of arguments */
    END.

    /* Loop through the field list two at a time. */
    DO iCount = 1 TO NUM-ENTRIES(pcFieldList) BY 2:
      /* Get the child field's name and handle */
      cChildField = ENTRY(iCount, pcFieldList).
      hChildField = phBuffer:BUFFER-FIELD(cChildField) NO-ERROR.
      cMessageList = buildErrList().
      IF cMessageList <> "":U THEN
      DO:
        gcMessageList = gcMessageList + CHR(3) + 
                        {af/sup2/aferrortxt.i 'AF' '114' '?' '?' phBuffer:NAME cChildField cMessageList}.
      END.

      /* Get the parent field's name and handle. */
      cParentField = ENTRY(iCount + 1, pcFieldList).
      hParentField = phParent:BUFFER-FIELD(cParentField) NO-ERROR.
      cMessageList = buildErrList().
      IF cMessageList <> "":U THEN
      DO:
        gcMessageList = gcMessageList + CHR(3) + 
                        {af/sup2/aferrortxt.i 'AF' '114' '?' '?' phParent:NAME cParentField cMessageList}.
      END.

      IF VALID-HANDLE(hChildField) AND
         VALID-HANDLE(hParentField) THEN
        /* Add the value to the string */
        cRetVal = cRetVal + (IF cRetVal = "":U THEN "":U ELSE " AND ":U)
                + phBuffer:NAME + ".":U
                + cChildField + " = ":U  
                + convDTForWhere(hChildField:DATA-TYPE,
                                 (IF lDefault THEN STRING(hParentField:INITIAL) ELSE STRING(hParentField:BUFFER-VALUE)),
                                 0,
                                 pcDataFormat).
    END.
  END.
  ELSE
  DO:
    /* If the pcJoinFieldValue contains an *, return "" - we want all records */
    IF pcJoinFieldValue = "*":U THEN
      RETURN "":U.

    /* If the user default values, return the default values */
    IF pcJoinFieldValue = "<default>":U THEN
      lDefault = YES.
    ELSE
      /* If the number of entries in each don't match, there's a problem */
      IF NUM-ENTRIES(pcFieldList) <> NUM-ENTRIES(pcJoinFieldValue,CHR(3)) THEN
        RETURN ?.
    /* Loop through the field list two at a time. */
    DO iCount = 1 TO NUM-ENTRIES(pcFieldList):
      /* Get the child field's name and handle */
      cChildField = ENTRY(iCount, pcFieldList).
      hChildField = phBuffer:BUFFER-FIELD(cChildField) NO-ERROR.
      cMessageList = buildErrList().
      IF cMessageList <> "":U THEN
        gcMessageList = gcMessageList + CHR(3) + 
                        {af/sup2/aferrortxt.i 'AF' '114' '?' '?' phBuffer:NAME cChildField cMessageList}.
  
      IF VALID-HANDLE(hChildField) THEN
      /* Add the value to the string */
      cRetVal = cRetVal + (IF cRetVal = "":U THEN "":U ELSE " AND ":U)
              + phBuffer:NAME + ".":U
              + cChildField + " = ":U  
              + convDTForWhere(hChildField:DATA-TYPE,
                               (IF lDefault THEN STRING(hChildField:INITIAL) ELSE ENTRY(iCount,pcJoinFieldValue,CHR(3))),
                               0,
                               pcDataFormat).
    END.
  END.
  
  IF gcMessageList <> "":U THEN
    cRetVal = ?.
  RETURN cRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-calculateVersionKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION calculateVersionKey Procedure 
FUNCTION calculateVersionKey RETURNS CHARACTER
  (INPUT pcEntityMnemonic AS CHARACTER,
   INPUT phBuff AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Calculates the key value to be used to find a gst_record_version
            record that is related to an object in the database.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFieldValue   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKey          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjField     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObj          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lHasObj       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAns          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lVersion      AS LOGICAL    NO-UNDO.

  lAns = getEntityData("TT":U,
                       pcEntityMnemonic,
                       phBuff,
                       CHR(1),
                       OUTPUT cKeyField,
                       OUTPUT cKey,
                       OUTPUT cObjField,
                       OUTPUT cObj,
                       OUTPUT lHasObj,
                       OUTPUT lVersion).
  IF NOT lAns THEN
  DO:
    lAns = getEntityData("DB":U,
                         pcEntityMnemonic,
                         phBuff,
                         CHR(1),
                         OUTPUT cKeyField,
                         OUTPUT cKey,
                         OUTPUT cObjField,
                         OUTPUT cObj,
                         OUTPUT lHasObj,
                         OUTPUT lVersion).
  END.

  cFieldValue = ?.

  IF lAns     AND
     lVersion THEN
  DO:
    IF lHasObj THEN
      cFieldValue = cObj.
    ELSE
      cFieldValue = cKey.
  END.
  
  RETURN cFieldValue. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-compareKeys) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION compareKeys Procedure 
FUNCTION compareKeys RETURNS LOGICAL
  (INPUT pcKeyField  AS CHARACTER, 
   INPUT phBuff1     AS HANDLE, 
   INPUT phBuff2     AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Compares a list of fields in pcKeyField in two buffers. If they 
            match, the function returns true. If the don't, the function returns
            false.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iCount  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hField1 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField2 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cField  AS CHARACTER  NO-UNDO.

  DO iCount = 1 TO NUM-ENTRIES(pcKeyField):
    cField = ENTRY(iCount,pcKeyField).
    ERROR-STATUS:ERROR = NO.
    hField1 = phBuff1:BUFFER-FIELD(cField) NO-ERROR.
    ERROR-STATUS:ERROR = NO.
    IF ERROR-STATUS:ERROR THEN
      RETURN ?.
    hField2 = phBuff2:BUFFER-FIELD(cField) NO-ERROR.
    ERROR-STATUS:ERROR = NO.
    IF ERROR-STATUS:ERROR THEN
      RETURN ?.

    IF hField1:BUFFER-VALUE <> hField2:BUFFER-VALUE THEN
      RETURN FALSE.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-convDTForWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION convDTForWhere Procedure 
FUNCTION convDTForWhere RETURNS CHARACTER
  ( INPUT pcDataType    AS CHARACTER,
    INPUT pcValue       AS CHARACTER,
    INPUT piRequestNo   AS INTEGER,
    INPUT pcDataFormat  AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:   Converts the a string value to the appropriate expression in 
             a where clause for a dynamic query based on the datatype passed 
             in.
             
             pcDataFormat is a code that can be one of:
             D - Dataset format  (Whatever is in the dataset)
             S - Standard format (MDY and ,.)
             Anything else will result in standard date format being used.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCurrDateFormat     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUseDateFormat  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrNumSep         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUseNumSep      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrNumDec         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUseNumDec      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRetVal             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE deValue             AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE daValue             AS DATE       NO-UNDO.

  CASE pcDataFormat:
    WHEN "D":U THEN
    DO:
      cUseNumDec     = getAttribute(piRequestNo,"NumericDecimal":U).
      cUseNumSep     = getAttribute(piRequestNo,"NumericSeparator":U).
      cUseDateFormat = getAttribute(piRequestNo,"DateFormat":U).
    END.
    WHEN "S":U THEN
    DO:
      cUseNumDec     = ".":U.
      cUseNumSep     = ",":U.
      cUseDateFormat = "mdy":U.
    END.
  END CASE.

  CASE pcDataType:
    WHEN "CHARACTER":U THEN
      cRetVal = "'":U + pcValue + "'":U.
    WHEN "DECIMAL":U THEN
    DO:
      /* With a decimal, we may need to change the numeric format */
      cCurrNumSep = SESSION:NUMERIC-SEPARATOR.
      cCurrNumDec = SESSION:NUMERIC-DECIMAL-POINT.
      IF cUseNumSep <> ? AND
         cUseNumSep <> "":U AND
         cUseNumDec <> ? AND
         cUseNumDec <> "":U THEN
        SESSION:SET-NUMERIC-FORMAT(cUseNumSep, cUseNumDec).
      deValue = DECIMAL(pcValue) NO-ERROR.
      SESSION:SET-NUMERIC-FORMAT(cCurrNumSep, cCurrNumDec).
      IF ERROR-STATUS:ERROR THEN
      DO:
        ERROR-STATUS:ERROR = NO.
        cRetVal = ?.
      END.
      cRetVal = QUOTER(deValue).
    END.
    WHEN "DATE":U THEN
    DO:
      /* With a date, we need to swap the date format so that it
         is the same as it was in the incoming dataset */
      cCurrDateFormat = SESSION:DATE-FORMAT.
      cUseDateFormat = getAttribute(piRequestNo,"DateFormat":U).
      IF cUseDateFormat <> ? AND
         cUseDateFormat <> "":U THEN
        SESSION:DATE-FORMAT = cUseDateFormat.
      daValue = DATE(pcValue) NO-ERROR.
      SESSION:DATE-FORMAT = cCurrDateFormat.
      IF ERROR-STATUS:ERROR THEN
      DO:
        ERROR-STATUS:ERROR = NO.
        cRetVal = ?.
      END.
      cRetVal = QUOTER(daValue).
    END.

    WHEN "INTEGER":U OR
    WHEN "LOGICAL":U THEN
    DO:
      cRetVal = TRIM(pcValue) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN  
      DO:
        ERROR-STATUS:ERROR = NO.
        cRetVal = ?.
      END.
    END.
  END.

  RETURN cRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createPath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createPath Procedure 
FUNCTION createPath RETURNS INTEGER
  ( INPUT pcPath AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:   Verifies that all the directories in a path actually exist on disk.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDirectory AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPath      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOutDir    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount     AS INTEGER    NO-UNDO.
  
  pcPath        = RIGHT-TRIM(REPLACE(pcPath,"~\":U,"/":U),"/").

  cPath = pcPath.

  FILE-INFO:FILE-NAME = cPath.
  IF FILE-INFO:FULL-PATHNAME = ? THEN
  DO:
    do-blk:
    DO iCount = 1 TO NUM-ENTRIES(cPath,"/":U):
      cDirectory = ENTRY(iCount,cPath,"/":U).
      IF iCount = 1 AND
         NUM-ENTRIES(cDirectory,":":U) > 1 THEN
      DO:
        cOutDir = cDirectory.
        NEXT do-blk.
      END.

      cOutDir = cOutDir + (IF cOutDir = "":U THEN "":U ELSE "/":U) + cDirectory. 
      FILE-INFO:FILE-NAME = cOutDir.
      IF FILE-INFO:FULL-PATHNAME = ? THEN
      DO:
        OS-CREATE-DIR VALUE(cOutDir).
        IF OS-ERROR <> 0 THEN
          RETURN OS-ERROR.
      END.
    END.
  END.

  RETURN 0.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createTable Procedure 
FUNCTION createTable RETURNS LOGICAL
  ( INPUT piRequest AS INTEGER,
    INPUT pcTable AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Adds the table handles for all the system tables to the bttTableList
            tables.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE BUFFER bttTableList FOR ttTableList.

  DO TRANSACTION:
    CREATE bttTableList.
    ASSIGN
      bttTableList.iRequestNo = piRequest
      bttTableList.iTableNo   = ? 
      bttTableList.cDBName    = "TEMP-TABLE" 
      bttTableList.cTableName = pcTable
    .
    CASE pcTable:
      WHEN "ttTable":U THEN
        bttTableList.hTable     = TEMP-TABLE ttTable:HANDLE.
      WHEN "ttRequiredRecord":U THEN
        bttTableList.hTable     = TEMP-TABLE ttRequiredRecord:HANDLE.
      WHEN "ttEntityList":U THEN
        bttTableList.hTable     = TEMP-TABLE ttEntityList:HANDLE.
      WHEN "ttNode":U THEN
        bttTableList.hTable     = TEMP-TABLE ttNode:HANDLE.
      WHEN "ttIndexList":U THEN
        bttTableList.hTable     = TEMP-TABLE ttIndexList:HANDLE.
      WHEN "ttDSAttribute":U THEN
        bttTableList.hTable     = TEMP-TABLE ttDSAttribute:HANDLE.
      WHEN "ttReqHandle":U THEN
        bttTableList.hTable     = TEMP-TABLE ttReqHandle:HANDLE.
      WHEN "ttImportVersion":U THEN
        bttTableList.hTable     = TEMP-TABLE ttImportVersion:HANDLE.
    END.
    RELEASE bttTableList.
  END.
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-datasetQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION datasetQuery Procedure 
FUNCTION datasetQuery RETURNS INTEGER
  ( INPUT phBuffer AS HANDLE,
    INPUT pcQueryString AS CHARACTER,
    INPUT phRecordNode AS HANDLE,
    INPUT pcEntityMnemonic AS CHARACTER,
    INPUT piTransNo AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iTransNo              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hQuery                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTransGroup           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hXDoc                 AS HANDLE   NO-UNDO.

  iTransNo = piTransNo.
  
  /* Set up the query */ 
  hQuery = setupQuery(phBuffer, pcQueryString).
  hQuery:GET-FIRST().

  /* Loop through all the query records */
  DO WHILE NOT hQuery:QUERY-OFF-END:
    /* Add a transaction level entry */
    hTransGroup = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr,
                                   phRecordNode, 
                                   "dataset_transaction":U).

    /* Increment Transaction Number */
    iTransNo = iTransNo + 1.

    hTransGroup:SET-ATTRIBUTE("TransactionNo":U, STRING(iTransNo)).
    hTransGroup:SET-ATTRIBUTE("TransactionType":U, "DATA":U).

    /* Write out this record and anything it contains */
    writeContainedRecord(hTransGroup, 
                         phBuffer,
                         pcEntityMnemonic).

    /* Delete the transaction group node */
    DELETE OBJECT hTransGroup.
    hTransGroup = ?.

    /* Get the next query result */
    hQuery:GET-NEXT().

  END.

  /* Close the query and delete it */
  hQuery:QUERY-CLOSE().
  RUN releasePoolObject /* IN ghObjectPool */
    (hQuery).
  hQuery = ?.
  RETURN iTransNo.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteAttributes Procedure 
FUNCTION deleteAttributes RETURNS LOGICAL
  ( INPUT piRequestNo AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Loops through the table list and deletes all the attributes in the
           table for a particular request. 
    Notes: If piRequestNo is unknown, all the attributes in the table are 
           deleted, otherwise only the requested request's attributes are 
           deleted. 
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttDSAttribute FOR ttDSAttribute.
  DEFINE QUERY qAttList FOR bttDSAttribute.

  /* Open the appropriate version of the query */
  IF piRequestNo = ? THEN
    OPEN QUERY qAttList
      FOR EACH bttDSAttribute.
  ELSE
    OPEN QUERY qAttList
      FOR EACH bttDSAttribute
         WHERE bttDSAttribute.iRequestNo = piRequestNo.

  GET FIRST qAttList.

  /* Loop through the records in the query */
  REPEAT WHILE AVAILABLE(bttDSAttribute):
      
    /* Delete the table record. */
    DELETE bttDSAttribute.
 
    /* Get the next record */
    GET NEXT qAttList.
  END.

  /* Close the query */
  CLOSE QUERY qAttList.
    
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteReqHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteReqHandles Procedure 
FUNCTION deleteReqHandles RETURNS LOGICAL
  ( INPUT piRequestNo AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Loops through the table list and deletes all the attributes in the
           table for a particular request. 
    Notes: If piRequestNo is unknown, all the attributes in the table are 
           deleted, otherwise only the requested request's attributes are 
           deleted. 
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttReqHandle FOR ttReqHandle.
  DEFINE QUERY qReqHandle FOR bttReqHandle.

  /* Open the appropriate version of the query */
  IF piRequestNo = ? THEN
    OPEN QUERY qReqHandle
      FOR EACH bttReqHandle 
        BY bttReqHandle.iRequestNo
        BY bttReqHandle.iDelOrder.
  ELSE
    OPEN QUERY qReqHandle
      FOR EACH bttReqHandle
         WHERE bttReqHandle.iRequestNo = piRequestNo
         BY bttReqHandle.iRequestNo
         BY bttReqHandle.iDelOrder
         BY bttReqHandle.cHandleName.

  GET FIRST qReqHandle.

  /* Loop through the records in the query */
  REPEAT WHILE AVAILABLE(bttReqHandle):
      
    IF VALID-HANDLE(bttReqHandle.hHandle) THEN
      DELETE OBJECT bttReqHandle.hHandle.

    /* Delete the table record. */
    DELETE bttReqHandle.
 
    /* Get the next record */
    GET NEXT qReqHandle.
  END.

  /* Close the query */
  CLOSE QUERY qReqHandle.
    
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteTempTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteTempTables Procedure 
FUNCTION deleteTempTables RETURNS LOGICAL
  ( INPUT piRequestNo AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Loops through the table list and deletes all the temp-tables in the
           table list. 
    Notes: If piRequestNo is unknown, all the temp-tables in the TT List are 
           deleted, otherwise only the requested temp-table is deleted. 
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttTableList FOR ttTableList.
  DEFINE QUERY qTTList FOR bttTableList.

  /* Open the appropriate version of the query */
  IF piRequestNo = ? THEN
    OPEN QUERY qTTList
      FOR EACH bttTableList.
  ELSE
    OPEN QUERY qTTList
      FOR EACH bttTableList
         WHERE bttTableList.iRequestNo = piRequestNo.

  GET FIRST qTTList.

  /* Loop through the records in the query */
  REPEAT WHILE AVAILABLE(bttTableList):
      
    /* If the handle is valid, trash the object */
    IF VALID-HANDLE(bttTableList.hTable) THEN
      RUN releasePoolObject /* IN ghObjectPool */
        (bttTableList.hTable).

    /* Delete the table record. */
    DELETE bttTableList.
 
    /* Get the next record */
    GET NEXT qTTList.
  END.

  /* Close the query */
  CLOSE QUERY qTTList.
    
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteTransactions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteTransactions Procedure 
FUNCTION deleteTransactions RETURNS LOGICAL
  ( INPUT piRequestNo AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Loops through the table list and deletes all the temp-tables in the
           table list. 
    Notes: If piRequestNo is unknown, all the temp-tables in the TT List are 
           deleted, otherwise only the requested temp-table is deleted. 
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttTransaction FOR ttTransaction.
  DEFINE QUERY qTTList FOR bttTransaction.

  /* Open the appropriate version of the query */
  IF piRequestNo = ? THEN
    OPEN QUERY qTTList
      FOR EACH bttTransaction.
  ELSE
    OPEN QUERY qTTList
      FOR EACH bttTransaction
         WHERE bttTransaction.iRequestNo = piRequestNo.

  GET FIRST qTTList.

  /* Loop through the records in the query */
  REPEAT WHILE AVAILABLE(bttTransaction):
      
    /* Delete the table record. */
    DELETE bttTransaction.
 
    /* Get the next record */
    GET NEXT qTTList.
  END.

  /* Close the query */
  CLOSE QUERY qTTList.
    
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAttribute Procedure 
FUNCTION getAttribute RETURNS CHARACTER
  ( INPUT piRequestNo AS INTEGER,
    INPUT pcAttribute AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the value associated with a dataset attribute.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttDSAttribute FOR ttDSAttribute.
  DEFINE VARIABLE cRetVal AS CHARACTER  NO-UNDO.

  /* Find the ttDSAttribute record and set the return value 
     to the value of the property */
  DO FOR bttDSAttribute:
    FIND bttDSAttribute
      WHERE bttDSAttribute.iRequestNo = piRequestNo
        AND bttDSAttribute.cAttribute = pcAttribute
      NO-ERROR.
    IF NOT AVAILABLE(bttDSAttribute) THEN
      cRetVal = ?.
    ELSE
      cRetVal = bttDSAttribute.cValue.
  END.
  RETURN cRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEntityData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEntityData Procedure 
FUNCTION getEntityData RETURNS LOGICAL
  ( INPUT  pcSource         AS CHARACTER,
    INPUT  pcEntityMnemonic AS CHARACTER,
    INPUT  phTable          AS HANDLE,
    INPUT  pcDelimiter      AS CHARACTER,
    OUTPUT pcKeyField       AS CHARACTER,
    OUTPUT pcKey            AS CHARACTER,
    OUTPUT pcObjField       AS CHARACTER,
    OUTPUT pcObj            AS CHARACTER,
    OUTPUT plHasObj         AS LOGICAL,
    OUTPUT plVersionData    AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  Derives critical data about a record and its behavior. Returns
            true if the entity mnemonic was found and false if it wasn't.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hField      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cKeyField   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldValue AS CHARACTER  NO-UNDO.
  
  DEFINE BUFFER bttEntityList        FOR ttEntityList.
  DEFINE BUFFER bgsc_entity_mnemonic FOR gsc_entity_mnemonic.

  DEFINE VARIABLE hBuffer         AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hEMKeyField     AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hEMObjField     AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hEMHasObj       AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hEMVersionData  AS HANDLE  NO-UNDO.


  /* Find the appropriate table record to use to derive this value. */
  IF pcSource = "TT":U THEN
  DO:
    FIND FIRST bttEntityList NO-LOCK
      WHERE bttEntityList.cEntityMnemonic = pcEntityMnemonic
      NO-ERROR.
    hBuffer        = BUFFER bttEntityList:HANDLE.
    hEMKeyField    = hBuffer:BUFFER-FIELD("cKeyField":U).
    hEMObjField    = hBuffer:BUFFER-FIELD("cObjField":U).
    hEMHasObj      = hBuffer:BUFFER-FIELD("lHasObj":U).
    hEMVersionData = hBuffer:BUFFER-FIELD("lVersionData":U).
  END.
  ELSE
  DO:
    FIND FIRST bgsc_entity_mnemonic NO-LOCK
      WHERE bgsc_entity_mnemonic.entity_mnemonic = pcEntityMnemonic
      NO-ERROR.
    hBuffer        = BUFFER bgsc_entity_mnemonic:HANDLE.
    hEMKeyField    = hBuffer:BUFFER-FIELD("entity_key_field":U).
    hEMObjField    = hBuffer:BUFFER-FIELD("entity_object_field":U).
    hEMHasObj      = hBuffer:BUFFER-FIELD("table_has_object_field":U).
    hEMVersionData = hBuffer:BUFFER-FIELD("version_data":U).
  END.

  /* If the entity mnemonic record is not available, return false */
  IF NOT hBuffer:AVAILABLE THEN
    RETURN FALSE.

  plHasObj      = hEMHasObj:BUFFER-VALUE.
  plVersionData = hEMVersionData:BUFFER-VALUE.
  pcKeyField    = hEMKeyField:BUFFER-VALUE.
  pcObjField    = hEMObjField:BUFFER-VALUE.

  pcObj         = buildKeyVal(phTable, pcObjField, pcDelimiter, YES).
  pcKey         = buildKeyVal(phTable, pcKeyField, pcDelimiter, YES).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFileNameFromField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFileNameFromField Procedure 
FUNCTION getFileNameFromField RETURNS CHARACTER
  ( INPUT pcFieldForFile AS CHARACTER,
    INPUT phBuffer       AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Evaluates the field name to be used to derive the file name for an
            ado and then tries to relate it to a product module for its path.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hField      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cProduct    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProductMod AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFileName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPath       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE oProductMod AS DECIMAL    NO-UNDO.

  DEFINE BUFFER bryc_smartobject         FOR ryc_smartobject.
  DEFINE BUFFER bgsc_product_module FOR gsc_product_module.

  hField = phBuffer:BUFFER-FIELD(pcFieldForFile) NO-ERROR.
  ERROR-STATUS:ERROR = NO.
  IF VALID-HANDLE(hField) THEN
  DO:
    cFileName = hField:BUFFER-VALUE.

    FIND FIRST bryc_smartobject NO-LOCK
      WHERE bryc_smartobject.object_filename = cFileName
      NO-ERROR.
    IF AVAILABLE(bryc_smartobject) AND
       bryc_smartobject.object_path <> "":U THEN
      cPath = bryc_smartobject.object_path.
    ELSE
    DO:
      hField = phBuffer:BUFFER-FIELD("product_module_obj") NO-ERROR.
      ERROR-STATUS:ERROR = NO.
      IF VALID-HANDLE(hField) THEN
      DO:
        oProductMod = hField:BUFFER-VALUE.
        FIND FIRST bgsc_product_module NO-LOCK
          WHERE bgsc_product_module.product_module_obj = oProductMod
          NO-ERROR.
        IF AVAILABLE(bgsc_product_module) AND
           bgsc_product_module.relative_path <> "":U THEN
          cPath = bgsc_product_module.relative_path.
      END.
    END.
    IF cPath = "":U OR
       SUBSTRING(cPath,2,1) = ":":U OR
       cPath = "src/adm2":U THEN
      cPath = "":U.

    cPath = REPLACE(cPath, "~\":U, "/":U).
    IF cPath <> "":U AND 
       SUBSTRING(cPath,LENGTH(cPath)) <> "/":U THEN
      cPath = cPath + "/":U.

    IF replaceExt(cFileName) THEN
      cFileName = SUBSTRING(cFileName,1,R-INDEX(cFileName,".":U)) + "ado":U.
    ELSE
      cFileName = cFileName + ".ado":U.


    cFileName = LC(cPath + cFileName).
  END.

  RETURN cFileName.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectHandle Procedure 
FUNCTION getObjectHandle RETURNS HANDLE
  ( INPUT piRequestNo AS INTEGER,
    INPUT pcHandleName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the value associated with a request handle.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttReqHandle FOR ttReqHandle.
  DEFINE VARIABLE hRetVal    AS Handle  NO-UNDO.

  /* Find the ttReqHandle record and set the return value 
     to the value of the property */
  DO FOR bttReqHandle:
    FIND bttReqHandle
      WHERE bttReqHandle.iRequestNo = piRequestNo
        AND bttReqHandle.cHandleName = pcHandleName
      NO-ERROR.
    IF NOT AVAILABLE(bttReqHandle) OR 
       NOT VALID-HANDLE(bttReqHandle.hHandle) THEN
      hRetVal = ?.
    ELSE
    DO:
      hRetVal = bttReqHandle.hHandle.
      /* Sanity check. If the handle is not the same type of handle as
         we originally created, there's a problem. This will trigger
         a cleanup of the whole request */ 
      IF hRetVal:TYPE <> bttReqHandle.cHandleType THEN
      DO:
        DELETE OBJECT hRetVal.
        hRetVal = ?.
        DELETE bttReqHandle.
      END.
    END.
  END.
  RETURN hRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isDataModified Procedure 
FUNCTION isDataModified RETURNS LOGICAL
  ( INPUT pcEntityMnemonic AS CHARACTER,
    INPUT phBuffer         AS HANDLE,
    INPUT plIgnoreMinus    AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns true if the record versioning data in the database indicates
            that this data has been modified since the last import.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lAns              AS LOGICAL    NO-UNDO.
  DEFINE BUFFER bgst_record_version FOR gst_record_version.
  def buffer gscdd for gsc_deploy_dataset.
  def buffer gscde for gsc_dataset_entity.

  DO FOR bgst_record_version:
    /* While the dataset code typically matches the primary entity's
       entity mnemonic, this isn't always the case. We need to check th
       primary entity's data modified status. */
    find gscdd where
         gscdd.dataset_code = pcEntityMnemonic
         no-lock no-error.
    if available gscdd then
        find first gscde where
                   gscde.deploy_dataset_obj = gscdd.deploy_dataset_obj and
                   gscde.primary_entity 
                   no-lock no-error.
    
    /* First find the gst_record_version */
    lAns = obtainDataVersionRec( (if available gscde then gscde.entity_mnemonic else pcEntityMnemonic),
                                phBuffer,
                                "":U,
                                INPUT BUFFER bgst_record_version:HANDLE,
                                "NO-LOCK":U).
    IF lAns AND
       AVAILABLE(bgst_record_version) THEN
    DO:
      lAns =  NOT (bgst_record_version.import_version_number_seq = 
              (IF plIgnoreMinus THEN ABS(bgst_record_version.version_number_seq) 
               ELSE bgst_record_version.version_number_seq)).

    END.
    ELSE
      lAns = NO.   /* Function return value. */
  END.

  RETURN lAns.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-matchKeys) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION matchKeys Procedure 
FUNCTION matchKeys RETURNS LOGICAL
  ( INPUT pcFieldList  AS CHARACTER,
    INPUT pcFieldValue AS CHARACTER,
    INPUT phBuffer     AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  Loop through the fields in the field list and check that the 
            value in the pcFieldValue = value in phBuffer.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCount   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hField   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cCurr    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBuffVal AS CHARACTER  NO-UNDO.

  /* If the field value is empty the possibility exists that this is old data that
     existed *before* secondary key values were available. We whack these records
     as we need to get rid of the deployment */
  IF pcFieldValue = "":U OR 
     pcFieldValue = ?    THEN
    RETURN TRUE.

  /* If someone has changed the way that the field list is made up on the entity
     mnemonic, we have to deal with this the same way as a blank field value */
  IF NUM-ENTRIES(pcFieldList) <> NUM-ENTRIES(pcFieldValue,CHR(1)) THEN
    RETURN TRUE.

  DO iCount = 1 TO NUM-ENTRIES(pcFieldList):
    hField = phBuffer:BUFFER-FIELD(ENTRY(iCount,pcFieldList)) NO-ERROR.
    ERROR-STATUS:ERROR = NO.
    /* If the field list is invalid, return true */
    IF NOT VALID-HANDLE(hField) THEN
      RETURN TRUE.

    /* Now see if we are happy with the buffer value */
    cCurr = ENTRY(iCount,pcFieldValue,CHR(1)).
    cBuffVal = STRING(hField:BUFFER-VALUE).

    IF cCurr <> cBuffVal THEN
      RETURN FALSE.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainDatabaseRec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION obtainDatabaseRec Procedure 
FUNCTION obtainDatabaseRec RETURNS LOGICAL
  (INPUT pcEntityMnemonic AS CHARACTER,
   INPUT phCopyRec AS HANDLE,
   INPUT phDBRec   AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Reads a database record that corresponds with the contents of 
            another buffer that is intended to replace the database record
            from the database.
            
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lAns        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cKeyField   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKey        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjField   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObj        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lHasObj     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lVersion    AS LOGICAL    NO-UNDO.

  /* This code is here for testing. Sometimes we'll call this routine with
     no buffer. */
  IF NOT VALID-HANDLE(phDBRec) THEN 
    RETURN FALSE.

  /* Obtain the key field and obj field values for this record */
  lAns = getEntityData("DB":U,
                       pcEntityMnemonic,
                       phCopyRec,
                       CHR(1),
                       OUTPUT cKeyField,
                       OUTPUT cKey,
                       OUTPUT cObjField,
                       OUTPUT cObj,
                       OUTPUT lHasObj,
                       OUTPUT lVersion).
  
  /* Try and find the record using the object key if it has one. */
  IF lAns AND
     lHasObj THEN
    obtainTableRec(CHR(1), 
                   cObjField, 
                   cObj, 
                   phDBRec,
                   "NO-LOCK":U).
  
  /* If we don't have a record available at this point, try and 
     find it on the key value */
  IF NOT phDBRec:AVAILABLE THEN
  DO:
     IF cKeyField <> "":U AND
        cKeyField <> ? THEN
       obtainTableRec(CHR(1), 
                      cKeyField, 
                      cKey, 
                      phDBRec,
                      "NO-LOCK":U).
  END.

  RETURN phDBRec:AVAILABLE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainDataVersionRec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION obtainDataVersionRec Procedure 
FUNCTION obtainDataVersionRec RETURNS LOGICAL
  (INPUT pcEntityMnemonic AS CHARACTER,
   INPUT phDBRecord       AS HANDLE,
   INPUT pcDBKey          AS CHARACTER,
   INPUT phDVRecord       AS HANDLE,
   INPUT pcLock           AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Obtains the record version record for a particular
            database record.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFieldValue  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAns         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cWhereClause AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLock        AS INTEGER    NO-UNDO.

  IF VALID-HANDLE(phDBRecord) THEN
    /* Calculate the version key for this record */
    cFieldValue = calculateVersionKey(pcEntityMnemonic, phDBRecord).
  ELSE
    cFieldValue = pcDBKey.

  /* If cFieldValue is unknown, this record cannot have a version key */
  IF cFieldValue <> ? THEN 
  DO:

    /* This where clause needs to read something like this:
       gst_record_version.entity_mnemonic = pcEntityMnemonic
       AND gst_record_version.key_field_value = cFieldValue */
    cWhereClause = "WHERE ":U + phDVRecord:NAME + ".entity_mnemonic = ":U 
                 + TRIM(QUOTER(pcEntityMnemonic))
                 + " AND ":U + phDVRecord:NAME + ".key_field_value = ":U 
                 + TRIM(QUOTER(cFieldValue)).

    CASE pcLock:
      WHEN "EXCLUSIVE-LOCK":U THEN
        iLock = EXCLUSIVE-LOCK.
      WHEN "NO-LOCK":U THEN
        iLock = NO-LOCK.
      WHEN "SHARE-LOCK":U THEN
        iLock = SHARE-LOCK.
    END CASE.
    
    lAns = phDVRecord:FIND-FIRST(cWhereClause, iLock) NO-ERROR.
    
    ERROR-STATUS:ERROR = NO.

    RETURN lAns.
  END.
  ELSE 
    RETURN FALSE.
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainTableRec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION obtainTableRec Procedure 
FUNCTION obtainTableRec RETURNS LOGICAL
  ( INPUT pcDelimiter  AS CHARACTER,
    INPUT pcFieldList  AS CHARACTER,
    INPUT pcFieldValue AS CHARACTER,
    INPUT phTableBuff  AS HANDLE,
    INPUT pcLockType   AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Obtains a record in a table that matches the field criteria.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cWhereClause AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLock        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lAns         AS LOGICAL    NO-UNDO.

  cWhereClause = buildWhereFromKeyVal(pcDelimiter,
                                      pcFieldList,
                                      pcFieldValue,
                                      phTableBuff).

  IF cWhereClause = "":U OR
     cWhereClause = ? THEN
  DO:
    IF phTableBuff:AVAILABLE THEN
      phTableBuff:BUFFER-RELEASE().
    lAns = NO.
  END.
  ELSE
  DO:
    IF SUBSTRING(cWhereClause, 1, 5) <> "WHERE":U THEN
      cWhereClause = "WHERE ":U + cWhereClause. 

    CASE pcLockType:
      WHEN "EXCLUSIVE-LOCK":U THEN
        iLock = EXCLUSIVE-LOCK.
      WHEN "NO-LOCK":U THEN
        iLock = NO-LOCK.
      WHEN "SHARE-LOCK":U THEN
        iLock = SHARE-LOCK.
    END CASE.

    lAns = phTableBuff:FIND-FIRST(cWhereClause, iLock) NO-ERROR.
    ERROR-STATUS:ERROR = NO.
  END.
                                      
  RETURN lAns.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainTempTableRec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION obtainTempTableRec Procedure 
FUNCTION obtainTempTableRec RETURNS LOGICAL
  ( INPUT piRequestNo AS INTEGER,
    INPUT piNodeLevel AS INTEGER,
    INPUT piTableNo   AS INTEGER,
    INPUT phWriteBuff AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Attempts to find a record in phWriteBuff that has key values that 
            are set in the node table.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCount        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cIndexInfo    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cIndexField   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhereClause  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hField        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cPhrase       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hQuery        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAns          AS LOGICAL    NO-UNDO.

  DEFINE BUFFER bttNode FOR ttNode.

  /* Find the primary index on this buffer */
  REPEAT:
    iCount = iCount + 1.
    cIndexInfo = phWriteBuff:INDEX-INFORMATION(iCount).
    IF cIndexInfo = ? OR
       cIndexInfo = "":U THEN 
      LEAVE.

    IF ENTRY(3,cIndexInfo) = "1":U THEN
      LEAVE.
  
  END.

  IF cIndexInfo = ? OR 
     cIndexInfo = "":U THEN
    RETURN FALSE.

  /* Loop through all the fields in the index, and build up a where clause
     with their values from the ttNode table */
  REPEAT iCount = 5 TO NUM-ENTRIES(cIndexInfo) BY 2:
    cIndexField = ENTRY(iCount,cIndexInfo).

    /* Get a handle to the buffer field */
    hField = phWriteBuff:BUFFER-FIELD(cIndexField) NO-ERROR.

    IF NOT VALID-HANDLE(hField) THEN
    DO:
      MESSAGE "Invalid field handle - " cIndexField
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
      cWhereClause = ?.
      LEAVE.
    END.

    /* Find the node record that has the value of this field */
    FIND FIRST bttNode NO-LOCK
      WHERE bttNode.iRequestNo = piRequestNo
        AND bttNode.iLevelNo   = piNodeLevel
        AND bttNode.iTableNo   = piTableNo
        AND bttNode.cNode      = cIndexField NO-ERROR.
    IF NOT AVAILABLE(bttNode) THEN
    DO:
      cWhereClause = ?.
      LEAVE.
    END.

    /* Build up a phrase for this field. */
    cPhrase = cIndexField + " = ":U + convDTForWhere(hField:DATA-TYPE,
                                                     bttNode.cValue,
                                                     piRequestNo,
                                                     "D":U).
    
    IF cWhereClause = "":U THEN
      cWhereClause = "WHERE " + cPhrase.
    ELSE
      cWhereClause = " AND " + cPhrase.
      
  END.

  IF cWhereClause = ? THEN
    RETURN FALSE.

  phWriteBuff:FIND-FIRST(cWhereClause) NO-ERROR.
  ERROR-STATUS:ERROR = NO.

  RETURN phWriteBuff:AVAILABLE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-readRecordVersionAttr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION readRecordVersionAttr Procedure 
FUNCTION readRecordVersionAttr RETURNS DECIMAL
  (INPUT piRequestNo AS INTEGER,
   INPUT phNode      AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Reads the gst_record_version data that is stored into the
            xml file into the ttImportVersion temp-table.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttImportVersion    FOR ttImportVersion.
  DEFINE BUFFER bttImport           FOR ttImport.
  DEFINE BUFFER bgst_record_version FOR gst_record_version.

  DEFINE VARIABLE oObj        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cAttributes AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hField      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.

  /* Get a list of the attributes on this node */
  cAttributes = phNode:ATTRIBUTE-NAMES.

  /* If record_version_obj is not one of the attributes we're not interested in 
     this node */
  IF NOT CAN-DO(cAttributes,"record_version_obj":U) THEN
    RETURN 0.0.

  /* Just make sure there's *nothing* in bttImport */
  EMPTY TEMP-TABLE bttImport.

  /* Now we need to get the value of the record_version_obj to find the appropriate
     record. */
  DO TRANSACTION:
    /* Create a bttImport record */
    CREATE bttImport.
    /* It's easier to work with the buffer object here */
    hBuffer = BUFFER bttImport:HANDLE.
    /* Copy each field that we can find in the header into the corresponding 
       field on the bttImport table */
    DO iCount = 1 TO hBuffer:NUM-FIELDS:
      hField = hBuffer:BUFFER-FIELD(iCount).
      IF CAN-DO(cAttributes,hField:NAME) THEN
        /* The following function does the datatype conversions */
        setFieldValue(piRequestNo, hField, phNode:GET-ATTRIBUTE(hField:NAME), 0).
    END.

    /* Now see if we can find the record in the database. */
    FIND FIRST bttImportVersion 
      WHERE bttImportVersion.record_version_obj = bttImport.record_version_obj
      NO-ERROR.
    /* If the record does not exist on the obj, try and find it by 
       entity mnemonic and key value */
    IF NOT AVAILABLE(bttImportVersion) THEN
    DO:
      FIND FIRST bttImportVersion
        WHERE bttImportVersion.entity_mnemonic = bttImport.entity_mnemonic
          AND bttImportVersion.key_field_value = bttImport.key_field_value
        NO-ERROR.
    END.

    /* If we don't have a bttImportVersion yet, we need to create one. */
    IF NOT AVAILABLE(bttImportVersion) THEN
    DO:
      /* Create the import version record */
      CREATE bttImportVersion.
      BUFFER-COPY bttImport 
        EXCEPT oObjOnDB
        TO bttImportVersion.

      /* Now we need to see if this record exists on the database.
         First try it on the obj... */
      FIND FIRST bgst_record_version NO-LOCK
        WHERE bgst_record_version.record_version_obj = bttImportVersion.record_version_obj
        NO-ERROR.
      IF NOT AVAILABLE(bgst_record_version) THEN
      DO:
        /* And if the obj version is not found, look for the entity_mnemonic and 
           key field value */
        FIND FIRST bgst_record_version
          WHERE bgst_record_version.entity_mnemonic = bttImportVersion.entity_mnemonic
            AND bgst_record_version.key_field_value = bttImportVersion.key_field_value
          NO-ERROR.
      END.

      /* If we have a gst_record_version we need to set the objOnDb to be the same
         as the one in the incoming record. */
      IF AVAILABLE(bgst_record_version) THEN
        ASSIGN
          bttImportVersion.oObjOnDB = bgst_record_version.record_version_obj
        .
      ELSE
        ASSIGN
          bttImportVersion.oObjOnDB = 0.0
        .
    
    END.
    ELSE
    DO:
      /* If we find an import record, we need to see what state the database is in
         to decide if we should do anything here. */
      IF bttImportVersion.oObjOnDB <> 0.0 THEN
      DO:
        /* Find the database record. */
        FIND FIRST bgst_record_version NO-LOCK
          WHERE bgst_record_version.record_version_obj = bttImportVersion.oObjOnDB
          NO-ERROR.
      END.
      
      /* If there's no gst_record_version just try again to find a gst_record_version,
         because it may have been created since we last looked at this record. */
      IF NOT AVAILABLE(bgst_record_version) THEN
      DO:
        FIND FIRST bgst_record_version NO-LOCK
          WHERE bgst_record_version.record_version_obj = bttImportVersion.record_version_obj
          NO-ERROR.
        IF NOT AVAILABLE(bgst_record_version) THEN
        DO:
          /* And if the obj version is not found, look for the entity_mnemonic and 
             key field value */
          FIND FIRST bgst_record_version
            WHERE bgst_record_version.entity_mnemonic = bttImportVersion.entity_mnemonic
              AND bgst_record_version.key_field_value = bttImportVersion.key_field_value
            NO-ERROR.
        END.

        /* If we have a gst_record_version we need to set the objOnDb to be the same
           as the one in the incoming record. */
        IF AVAILABLE(bgst_record_version) THEN
          ASSIGN
            bttImportVersion.oObjOnDB = bgst_record_version.record_version_obj
          .
        ASSIGN
          bttImportVersion.secondary_key_value       = bttImport.secondary_key_value
          bttImportVersion.import_version_number_seq = ABS(bttImport.import_version_number_seq)
          bttImportVersion.version_number_seq        = ABS(bttImport.version_number_seq)
          bttImportVersion.version_date              = bttImport.version_date
          bttImportVersion.version_time              = bttImport.version_time
          bttImportVersion.version_user              = bttImport.version_user
          bttImportVersion.deletion_flag             = bttImport.deletion_flag
        .
      END. /* IF NOT AVAILABLE(bgst_record_version) */
      ELSE
      DO:
        /* We should only hit this code if we are loading the same data twice
           in one dataset transaction -- unlikely, but possible.
           The issue is what we should do if we hit this situation. 
           
           In theory, if this does happen, the two copies of the record should
           have the same value because they were written out in the same dataset
           transaction. For that reason, I have not wasted any time doing any checks.
           We may need to revisit this code if it becomes an issue. */
        ASSIGN
          bttImportVersion.secondary_key_value       = bttImport.secondary_key_value
          bttImportVersion.import_version_number_seq = ABS(bttImport.import_version_number_seq)
          bttImportVersion.version_number_seq        = ABS(bttImport.version_number_seq)
          bttImportVersion.version_date              = bttImport.version_date
          bttImportVersion.version_time              = bttImport.version_time
          bttImportVersion.version_user              = bttImport.version_user
          bttImportVersion.deletion_flag             = bttImport.deletion_flag
        .

      END. /* ELSE IF NOT AVAILABLE(bgst_record_version) */

    END.
    /* Set the return value */
    oObj = bttImportVersion.record_version_obj.

    /* Whack the bttImport record that we created temporarily */
    DELETE bttImport.
  END.
  RETURN oObj.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-registerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION registerObject Procedure 
FUNCTION registerObject RETURNS LOGICAL
  ( INPUT piRequestNo AS INTEGER,
    INPUT pcHandle    AS CHARACTER,
    INPUT phHandle    AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the value of properties in the ttReqHandle table.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cHandles AS CHARACTER  
    INITIAL "QUERY,BUFFER,TEMP-TABLE,X-NODEREF,X-DOCUMENT":U
    NO-UNDO.

  DEFINE BUFFER bttReqHandle FOR ttReqHandle.

  
  /* Find the ttReqHandle record, creating it if necessary, and set the 
     value of the property to the value in the input parameter */
  DO FOR bttReqHandle:
    FIND bttReqHandle
      WHERE bttReqHandle.iRequestNo = piRequestNo
        AND bttReqHandle.cHandleName = pcHandle
      NO-ERROR.
    IF NOT AVAILABLE(bttReqHandle) THEN
    DO:
      CREATE bttReqHandle.
      ASSIGN
        bttReqHandle.iRequestNo = piRequestNo
        bttReqHandle.cHandleName = pcHandle
        .
    END.
    ASSIGN
      bttReqHandle.cHandleType = phHandle:TYPE
      bttReqHandle.iDelOrder = LOOKUP(phHandle:TYPE, cHandles)
      bttReqHandle.hHandle  = phHandle
      .
  END.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-replaceExt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION replaceExt Procedure 
FUNCTION replaceExt RETURNS LOGICAL
  ( INPUT pcFileName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cExt AS CHARACTER  NO-UNDO.

  IF NUM-ENTRIES(pcFileName, ".":U) < 2 THEN
    RETURN FALSE.

  cExt = ENTRY(NUM-ENTRIES(pcFileName,".":U),pcFileName,".":U).
  RETURN CAN-DO("p,w,i,t,ado":U,cExt). 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAttribute Procedure 
FUNCTION setAttribute RETURNS LOGICAL
  ( INPUT piRequestNo   AS INTEGER,
    INPUT pcAttribute   AS CHARACTER,
    INPUT pcValue       AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the value of attributes in the ttDSAttribute table.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE BUFFER bttDSAttribute FOR ttDSAttribute.


  /* Find the ttDSAttribute record, creating it if necessary, and set the 
     value of the property to the value in the input parameter */
  DO FOR bttDSAttribute:
    FIND bttDSAttribute
      WHERE bttDSAttribute.iRequestNo = piRequestNo
        AND bttDSAttribute.cAttribute = pcAttribute
      NO-ERROR.
    IF NOT AVAILABLE(bttDSAttribute) THEN
    DO:
      IF pcValue <> ? THEN
      DO:
        CREATE bttDSAttribute.
        ASSIGN
          bttDSAttribute.iRequestNo = piRequestNo
          bttDSAttribute.cAttribute = pcAttribute
          .
      END.
    END.
    ERROR-STATUS:ERROR = NO.

    IF pcValue <> ? THEN
      ASSIGN
        bttDSAttribute.cValue  = pcValue
        .
    ELSE
    DO:
      IF AVAILABLE(bttDSAttribute) THEN
        DELETE bttDSAttribute.
    END.
  END.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldLiteral) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldLiteral Procedure 
FUNCTION setFieldLiteral RETURNS LOGICAL
  ( INPUT phHandle AS HANDLE,
    INPUT plSet    AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  This function sets the LITERAL-QUESTION attribute on the field
            specified, or each field in the buffer, either on or off.
    Notes:  The LITERAL-QUESTION attribute has been provided to resolve an 
            issue that causes the value "?" assigned to a BUFFER-FIELD of type
            character to be set to the unknown value. If LITERAL-QUESTION is 
            set on before the assignment takes place, the buffer field is 
            assigned a value of "?" rather than ? which resolves the problem.
            ICF DOES NOT support ? in character fields at all in any database.
            These should always be converted to "?".
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hField AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount AS INTEGER    NO-UNDO.

  /* Check to see if the incoming handle is a buffer */
  IF phHandle:TYPE = "BUFFER":U THEN
  DO iCount = 1 TO phHandle:NUM-FIELDS: /* loop through all the fields on the buffer */
    hField = phHandle:BUFFER-FIELD(iCount). /* Get the handle to the field */
    IF hField:DATA-TYPE = "CHARACTER":U THEN  /* If the field is characte */
      hField:LITERAL-QUESTION = plSet.        /* set LITERAL-QUESTION */
  END.
  ELSE
  DO:
    phHandle:LITERAL-QUESTION = plSet.  /* Assume this a field and set LITERAL-QUESTION */
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldValue Procedure 
FUNCTION setFieldValue RETURNS LOGICAL
  ( INPUT piRequestNo    AS INTEGER,
    INPUT phField        AS HANDLE,
    INPUT pcFieldValue   AS CHARACTER,
    INPUT piExtentIndex  AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCurrDateFormat     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDatasetDateFormat  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrNumFormat      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDatasetNumFormat   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrNumSep         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDatasetNumSep      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrNumDec         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDatasetNumDec      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue              AS CHARACTER  NO-UNDO.

  CASE phField:DATA-TYPE:
    WHEN "INTEGER":U THEN
    DO:
      IF piExtentIndex > 0 THEN
      DO:
        IF piExtentIndex < phField:EXTENT THEN
         phField:BUFFER-VALUE[piExtentIndex] = INTEGER(pcFieldValue).
      END.
      ELSE
        phField:BUFFER-VALUE = INTEGER(pcFieldValue).
    END.
    WHEN "DECIMAL":U THEN
    DO:
      /* With a decimal, we need to swap the numeric format so that it
         is the same as it was in the incoming dataset */
      cCurrNumSep = SESSION:NUMERIC-SEPARATOR.
      cDatasetNumSep = getAttribute(piRequestNo,"NumericSeparator":U).
      cCurrNumDec = SESSION:NUMERIC-DECIMAL-POINT.
      cDatasetNumDec = getAttribute(piRequestNo,"NumericDecimal":U).
      IF cDatasetNumSep <> ? AND
         cDatasetNumSep <> "":U AND
         cDatasetNumDec <> ? AND
         cDatasetNumDec <> "":U THEN
        SESSION:SET-NUMERIC-FORMAT(cDatasetNumSep, cDatasetNumDec).
      IF piExtentIndex > 0 THEN
      DO:
        IF piExtentIndex < phField:EXTENT THEN
          phField:BUFFER-VALUE[piExtentIndex] = DECIMAL(pcFieldValue).
      END.
      ELSE
        phField:BUFFER-VALUE = DECIMAL(pcFieldValue).
      SESSION:SET-NUMERIC-FORMAT(cCurrNumSep, cCurrNumDec).
    END.
    WHEN "DATE":U OR
    WHEN "DATETIME":U OR
    WHEN "DATETIME-TZ":U THEN
    DO:
      /* With a date, we need to swap the date format so that it
         is the same as it was in the incoming dataset */
      cCurrDateFormat = SESSION:DATE-FORMAT.
      cDatasetDateFormat = getAttribute(piRequestNo,"DateFormat":U).
      IF cDatasetDateFormat <> ? AND
         cDatasetDateFormat <> "":U THEN
        SESSION:DATE-FORMAT = cDatasetDateFormat.
      IF piExtentIndex > 0 THEN
      DO:
        IF piExtentIndex < phField:EXTENT THEN
        DO:
          CASE phField:DATA-TYPE:
            WHEN "DATE":U THEN
              phField:BUFFER-VALUE[piExtentIndex] = DATE(pcFieldValue).
            WHEN "DATETIME":U THEN
              phField:BUFFER-VALUE[piExtentIndex] = DATETIME(pcFieldValue).
            WHEN "DATETIME-TZ":U THEN
              phField:BUFFER-VALUE[piExtentIndex] = DATETIME-TZ(pcFieldValue).
          END.
        END.
      END.
      ELSE
      DO:
        CASE phField:DATA-TYPE:
          WHEN "DATE":U THEN
            phField:BUFFER-VALUE = DATE(pcFieldValue).
          WHEN "DATETIME":U THEN
            phField:BUFFER-VALUE = DATETIME(pcFieldValue).
          WHEN "DATETIME-TZ":U THEN
            phField:BUFFER-VALUE = DATETIME-TZ(pcFieldValue).
        END.
      END.
      SESSION:DATE-FORMAT = cCurrDateFormat.
    END.
    WHEN "LOGICAL":U THEN
    DO:
      IF piExtentIndex > 0 THEN
      DO:
        IF piExtentIndex < phField:EXTENT THEN
          phField:BUFFER-VALUE[piExtentIndex] = TRIM(pcFieldValue) = "YES":U OR TRIM(pcFieldValue) = "TRUE":U.
      END.
      ELSE
        phField:BUFFER-VALUE = TRIM(pcFieldValue) = "YES":U OR TRIM(pcFieldValue) = "TRUE":U.
    END.
    WHEN "CHARACTER":U THEN
    DO:
      cValue = pcFieldValue.
      IF cValue = ? OR 
         cValue = "?":U THEN
        cValue = "?":U.
      ELSE
        cValue = replaceCtrlChar(cValue,NO).
       /* IZ 4064
      setFieldLiteral(phField, YES). /* Make sure we handle ? properly */
      */
        IF piExtentIndex > 0 THEN
        DO:
          IF piExtentIndex < phField:EXTENT THEN
            phField:BUFFER-VALUE[piExtentIndex] = cValue.
        END.
        ELSE
          phField:BUFFER-VALUE = cValue.
      /*
      setFieldLiteral(phField, NO).
      */
    END.
  END.

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFileDetails) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFileDetails Procedure 
FUNCTION setFileDetails RETURNS CHARACTER
  ( INPUT pcFileName     AS CHARACTER,
    INPUT pcPath         AS CHARACTER,
    INPUT pcDefaultPath  AS CHARACTER,
    OUTPUT pcRetPath     AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFileName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPath      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOutDir    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cRelative  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRetFile   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDirectory AS CHARACTER  NO-UNDO.


  cFileName     = RIGHT-TRIM(REPLACE(pcFileName,"~\":U,"/":U),"/").
  pcPath        = RIGHT-TRIM(REPLACE(pcPath,"~\":U,"/":U),"/").
  pcDefaultPath = RIGHT-TRIM(REPLACE(pcDefaultPath,"~\":U,"/":U),"/").

  /* If the two paths are the same for the first section, then set the 
     blank path to be just the extra relative piece */
  IF SUBSTRING(pcDefaultPath,1,LENGTH(pcPath)) = pcPath THEN
  DO:
    ASSIGN
      cRelative = RIGHT-TRIM(REPLACE(SUBSTRING(pcDefaultPath,LENGTH(pcPath) + 1),"~\":U,"/":U),"/":U)
      .
  END.

  IF NUM-ENTRIES(pcFileName,"/":U) > 1 THEN
  DO:
    cPath     = pcPath.
    cRelative = SUBSTRING(cFileName,1,R-INDEX(cFileName,"/":U) - 1).
    cFileName = ENTRY(NUM-ENTRIES(cFileName,"/":U),cFileName,"/":U).
  END.
  ELSE
  DO:
    IF cRelative <> "":U THEN
    DO:
      cPath   = pcPath.
    END.
    ELSE
      cPath   = pcDefaultPath.
  END.

  /* Calculate what the return file name and path will be. The return file
     name needs to include a relative path */
  pcRetPath   = cPath.
  cRetFile    = cRelative + (IF cRelative = "":U THEN "":U ELSE "/":U) 
              + cFileName.
    
  /* Now we need to make sure that all the directories exist */
  cPath       = cPath + (IF cRelative = "":U THEN "":U ELSE "/":U) 
              + cRelative.
  /* Call into Gen Manager since it deals with UNC as well as 
     'normal' paths equally well. */
  if not {fnarg createFolder cPath gshGenManager} then
    return ?.
  else
    RETURN cRetFile.
END FUNCTION.    /* setFileDetails */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNodeValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNodeValue Procedure 
FUNCTION setNodeValue RETURNS LOGICAL
  ( INPUT piRequestNo   AS INTEGER,
    INPUT piNodeLevel   AS INTEGER,
    INPUT piTableNo     AS INTEGER,
    INPUT pcNodeName    AS CHARACTER,
    INPUT piExtentIndex AS INTEGER,
    INPUT pcValue       AS CHARACTER,
    INPUT plDelete      AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttNode FOR ttNode.
  /* Write a record into the table for this field */
  DO TRANSACTION:
    FIND FIRST bttNode 
      WHERE bttNode.iRequestNo   = piRequestNo
        AND bttNode.iLevelNo     = piNodeLevel
        AND bttNode.iTableNo     = piTableNo
        AND bttNode.cNode        = pcNodeName
        AND bttNode.iExtentIndex = piExtentIndex
     NO-ERROR.
    IF NOT AVAILABLE(bttNode) THEN
    DO:
      CREATE bttNode.
      ASSIGN
        bttNode.iRequestNo = piRequestNo
        bttNode.iLevelNo   = piNodeLevel
        bttNode.iTableNo   = piTableNo
        bttNode.cNode      = pcNodeName
        bttNode.iExtentIndex = piExtentIndex
      .
    END.
    ERROR-STATUS:ERROR = NO.
    ASSIGN
      bttNode.cValue     = pcValue
      bttNode.lDelete    = plDelete
    .
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setupQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setupQuery Procedure 
FUNCTION setupQuery RETURNS HANDLE
  ( INPUT phBuffer AS HANDLE,
    INPUT pcQueryString AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Creates a QUERY object, adds the buffer to the query, and prepares
            and opens the query. If anything goes wrong, the function cleans
            up and returns ? as the handle to the query. 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery    AS HANDLE   NO-UNDO.
  DEFINE VARIABLE lSuccess  AS LOGICAL    NO-UNDO.

  RUN obtainPoolObject /* IN ghObjectPool */
      ("QUERY":U,
       "":U,
       OUTPUT hQuery).
  
  hQuery:SET-BUFFERS(phBuffer).

  lSuccess = hQuery:QUERY-PREPARE(pcQueryString) NO-ERROR.
  /* Check the error status */
  IF ERROR-STATUS:ERROR OR
     NOT lSuccess THEN
  DO:
    {af/sup2/afcheckerr.i 
      &errors-not-zero = YES
      &no-return = YES}
     IF cMessageList <> "":U THEN
      gcMessageList = gcMessageList + CHR(3) + 
                      {af/sup2/aferrortxt.i 'AF' '113' '?' '?' pcQueryString cMessageList}.
     RUN releasePoolObject /* IN ghObjectPool */
       (hQuery).
    hQuery = ?.
  END.

  IF VALID-HANDLE(hQuery) THEN
    /* Close the query */
    hQuery:QUERY-OPEN().

  RETURN hQuery.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateChangesetRycsoFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION updateChangesetRycsoFields Procedure 
FUNCTION updateChangesetRycsoFields RETURNS LOGICAL PRIVATE
        ( input phRycso              as handle,
          input phChangeset          as handle         ):
/*------------------------------------------------------------------------------
  Purpose:  Updates the ttReleaseChangeset record's rycso_ fields with information
                    from the ryc_smartobject record.
        Notes:
------------------------------------------------------------------------------*/
    define variable hField                as handle                no-undo.
    
    define buffer gscot for gsc_object_type.
    define buffer gscpm for gsc_product_module.
    
    if valid-handle(phRycso) and phRycso:available and
       valid-handle(phChangeset) and phChangeset:available then
    do:
        hField = phRycso:buffer-field('object_type_obj':u).
        find gscot where
             gscot.object_type_obj = hField:buffer-value
             no-lock no-error.
        if available gscot then
            phChangeset::rycso_Class = gscot.object_type_code.
        
        phChangeset::rycso_StaticObject = phRycso::static_object.
        phChangeset::rycso_DesignObject = phRycso::design_only.
        
        /* The path comes from the object or product module */
        hField = phChangeset:buffer-field('rycso_ObjectPath':u).
        hField:buffer-value = phRycso::object_path.
        if hField:buffer-value eq '':u then
        do:
            hField = phRycso:buffer-field('product_module_obj':u).
            find gscpm where
                 gscpm.product_module_obj = hField:buffer-value
                 no-lock no-error.
            if available gscpm then
            do:
                hField = phChangeset:buffer-field('rycso_ObjectPath':u).
                hField:buffer-value = gscpm.relative_path.            
            end.    /* available prod mod */
        end.    /* no path on object */
    end.    /* records available */
    
    error-status:error = no.
    return true.
END FUNCTION.    /* updateChangesetRycsoFields */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeContainedRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION writeContainedRecord Procedure 
FUNCTION writeContainedRecord RETURNS LOGICAL
  ( INPUT phNode           AS HANDLE,
    INPUT phBuff           AS HANDLE,
    INPUT pcEntityMnemonic AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:    This procedure writes out a record and its contained records
              and recursively calls itself to write out all children.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttTable            FOR ttTable.
  
  DEFINE VARIABLE hRecordNode           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cQueryString          AS CHARACTER  NO-UNDO.

  /* Put in a dataset records node */
  hRecordNode = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr,
                                 phNode, 
                                 "contained_record":U).
  
  /* Make sure we know what table is getting written out */
  hRecordNode:SET-ATTRIBUTE("DB", LC(phBuff:DBNAME)).
  hRecordNode:SET-ATTRIBUTE("Table", phBuff:NAME).

  /* Write out the record version attributes of this record,
     if applicable. */
  writeRecordVersionAttr(pcEntityMnemonic, /* Entity mnemonic */
                         phBuff,           /* Buffer          */
                         "":U,
                         hRecordNode).     /* XML record node */


  /* Create a Node Element for each field in the input buffer */
  DYNAMIC-FUNCTION("buildElementsFromBuffer":U IN ghXMLHlpr,
                   hRecordNode, 
                   INPUT phBuff, 
                   "*":U).

  FOR EACH bttTable NO-LOCK
    WHERE bttTable.cJoinMnemonic = pcEntityMnemonic:

    /* Set the buffer handle */
    hBuffer = bttTable.hBuffer.

    /* Loop through the required records table to figure out what records
       need to be deployed. */
    cQueryString = buildForEach(hBuffer, 
                                bttTable.cJoinFieldList, 
                                phBuff, 
                                "":U,
                                bttTable.cWhereClause,
                                NO).

     /* Set up the query */ 
     hQuery = setupQuery(hBuffer, cQueryString).
     hQuery:GET-FIRST().

     /* Loop through all the query records */
     DO WHILE NOT hQuery:QUERY-OFF-END:

       /* Write out this record and anything it contains */
       writeContainedRecord(hRecordNode, 
                            hBuffer,
                            bttTable.cEntityMnemonic).

       /* Get the next query result */
       hQuery:GET-NEXT().
     END.

     /* Close the query and delete it */
     hQuery:QUERY-CLOSE().
     RUN releasePoolObject /* IN ghObjectPool */
       (hQuery).
     hQuery = ?.

  END.
  
  /* Delete all the header related objects */
  DELETE OBJECT hRecordNode.
  hRecordNode = ?.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeDataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION writeDataset Procedure 
FUNCTION writeDataset RETURNS INTEGER
  ( INPUT phNode          AS HANDLE,
    INPUT plDeletions     AS LOGICAL,
    INPUT plDeletionsOnly AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  Writes out the header node and calls the code to write the dataset
            entities.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttTable            FOR ttTable.
  DEFINE BUFFER bttRequiredRecord   FOR ttRequiredRecord.

  DEFINE VARIABLE hRecordNode           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cQueryString          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTransNo              AS INTEGER    NO-UNDO.
  
  /* Put in a dataset records node */
  hRecordNode = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr,
                                 phNode, 
                                 "dataset_records":U).


  /* Now we need to figure out the primary table */
  FOR EACH bttTable NO-LOCK
    WHERE bttTable.cJoinMnemonic = "":U
    BY bttTable.iEntitySeq:
    /* Set the buffer handle */
    hBuffer = bttTable.hBuffer.

    IF bttTable.lPrimary THEN
    DO:

      IF plDeletions THEN
        iTransNo = writeDatasetDeletions(hRecordNode, bttTable.cEntityMnemonic).

      /* Loop through the required records table to figure out what records
         need to be deployed. */
      IF NOT plDeletionsOnly THEN
      FOR EACH bttRequiredRecord NO-LOCK
        BY bttRequiredRecord.iSequence:
  
         /* Build the query string that we create the query with */
         IF bttRequiredRecord.iSequence = 1 AND
            bttRequiredRecord.cJoinFieldValue = "*":U THEN
           cQueryString = buildForEach(hBuffer, 
                                       "":U, 
                                       ?, 
                                       "":U, 
                                       bttTable.cWhereClause, 
                                       NO).
         ELSE 
           cQueryString = buildForEach(hBuffer, 
                                       bttTable.cJoinFieldList, 
                                       ?, 
                                       bttRequiredRecord.cJoinFieldValue,
                                       bttTable.cWhereClause,
                                       NO).
  
         /* Open the query and write the XML */
         iTransNo = datasetQuery(hBuffer, cQueryString, hRecordNode, bttTable.cEntityMnemonic, iTransNo).
  
         /* If this was an ALL, jump out here */
         IF bttRequiredRecord.iSequence = 1 AND
            bttRequiredRecord.cJoinFieldValue = "*":U THEN
           LEAVE.
      END. /* FOR EACH bttRequiredRequired */
    END. /* IF bttTable.lPrimary */
    ELSE
    DO:
      IF plDeletions THEN
        iTransNo = writeDatasetDeletions(hRecordNode, bttTable.cEntityMnemonic).

      IF NOT plDeletionsOnly THEN
      DO:
        /* Just get all the records */
        cQueryString = buildForEach(hBuffer, 
                                    "":U, 
                                    ?, 
                                    "":U, 
                                    bttTable.cWhereClause, 
                                    NO).


        /* Open the query and write the XML */
        iTransNo = datasetQuery(hBuffer, 
                                cQueryString, 
                                hRecordNode, 
                                bttTable.cEntityMnemonic, 
                                iTransNo).
      END.

    END.
  
  END. /* FOR EACH bttTable*/

  /* Set the number of transactions contained in this dataset. */
  phNode:SET-ATTRIBUTE("Transactions":U,STRING(iTransNo)).

  /* Delete all the header related objects */
  DELETE OBJECT hRecordNode.
  hRecordNode = ?.
  
  RETURN iTransNo.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeDatasetDeletions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION writeDatasetDeletions Procedure 
FUNCTION writeDatasetDeletions RETURNS INTEGER
  ( INPUT phRecordNode AS HANDLE,
    INPUT pcEntityMnemonic AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:    Writes a deletions node for each of the primary entities that 
              are marked as deleted.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bgst_record_version FOR gst_record_version.
  DEFINE BUFFER bttVersionReset     FOR ttVersionReset.

  DEFINE VARIABLE iTransNo    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTransGroup AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContained  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lReset      AS LOGICAL    NO-UNDO.
  
  /* Check the ResetModifiedStatus flag. */
  lReset = getAttribute(0, "ResetModifiedStatus":U) = "YES":U.
  IF lReset = ? THEN
    lReset = NO.

  FOR EACH bgst_record_version NO-LOCK
    WHERE bgst_record_version.entity_mnemonic = pcEntityMnemonic
      AND bgst_record_version.deletion_flag:

    /* Add a transaction level entry */
    hTransGroup = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr,
                                   phRecordNode, 
                                   "dataset_transaction":U).

    /* Increment Transaction Number */
    iTransNo = iTransNo + 1.

    hTransGroup:SET-ATTRIBUTE("TransactionNo":U, STRING(iTransNo)).
    hTransGroup:SET-ATTRIBUTE("TransactionType":U, "DELETION":U).

    hContained = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr,
                                   hTransGroup, 
                                   "contained_record":U).


    writeVersionAttr(hContained, INPUT BUFFER bgst_record_version:HANDLE).
    
    DELETE OBJECT hContained.
    hContained = ?.

    /* Delete the transaction group node */
    DELETE OBJECT hTransGroup.
    hTransGroup = ?.


    /* If the reset modified status flag is set to yes, we need to reset this record
       when we have finished dumping the dataset. This means that we need to write
       the obj into the ttVersionReset table so that we can reset it later. */
    IF lReset THEN
    DO:
      FIND bttVersionReset 
        WHERE bttVersionReset.record_version_obj = bgst_record_version.record_version_obj
        NO-ERROR.
      IF NOT AVAILABLE(bttVersionReset) THEN
      DO:
        CREATE bttVersionReset.
        ASSIGN
          bttVersionReset.record_version_obj = bgst_record_version.record_version_obj
          bttVersionReset.delete_record      = YES
        .
      END.
    END.

  END.

  RETURN iTransNo.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeDatasetHeader) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION writeDatasetHeader Procedure 
FUNCTION writeDatasetHeader RETURNS LOGICAL
  ( INPUT phNode       AS HANDLE,
    INPUT phBuff       AS HANDLE,
    INPUT plAbbrHeader AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  Writes out the header node and calls the code to write the dataset
            entities.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttTable                FOR ttTable.
  DEFINE BUFFER bttList                 FOR ttEntityList.
  DEFINE BUFFER bgsc_entity_mnemonic    FOR gsc_entity_mnemonic.
  DEFINE VARIABLE hHeaderNode           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDSetObj              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDSetCode             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDSetRI               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDSetSCM              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iSiteNo               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cCurrTimeSource       AS CHARACTER  NO-UNDO.

  /* Get the handle to the deployment dataset obj field */
  hDSetObj = phBuff:BUFFER-FIELD("deploy_dataset_obj":U).
  hDSetCode = phBuff:BUFFER-FIELD("dataset_code":U).
  hDSetRI = phBuff:BUFFER-FIELD("disable_ri":U).
  hDSetSCM = phBuff:BUFFER-FIELD("source_code_data":U).

  /* We need to get the site number that this data is being written for */
  IF VALID-HANDLE(gshGenManager) THEN
    /* Get the current site number */
    RUN getSiteNumber IN gshGenManager
      (OUTPUT iSiteNo).
  ELSE 
    iSiteNo = ?.

  /* Write the header node. XML Junkies will probably have a hissy
     about the attribute settings on the dataset, especially as these
     are written out from the buffer. The problem is that the buffer's 
     data only gets written if a full header is requested. We need this
     information even if it is a short header. */
  hHeaderNode = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr,
                                 phNode, 
                                 "dataset_header":U).

  hHeaderNode:SET-ATTRIBUTE("DateFormat":U,SESSION:DATE-FORMAT).
  hHeaderNode:SET-ATTRIBUTE("NumericFormat":U,SESSION:NUMERIC-FORMAT).
  hHeaderNode:SET-ATTRIBUTE("NumericDecimal":U,SESSION:NUMERIC-DECIMAL-POINT).
  hHeaderNode:SET-ATTRIBUTE("NumericSeparator":U,SESSION:NUMERIC-SEPARATOR).
  hHeaderNode:SET-ATTRIBUTE("YearOffset":U,STRING(SESSION:YEAR-OFFSET)).
  hHeaderNode:SET-ATTRIBUTE("FullHeader":U,STRING(NOT plAbbrHeader)).
  /*
  cCurrTimeSource = SESSION:TIME-SOURCE.
  SESSION:TIME-SOURCE = phBuff:DBNAME.
  
  hHeaderNode:SET-ATTRIBUTE("DateCreated":U,
                            STRING(TODAY, 
                                   ENTRY(LOOKUP(SESSION:DATE-FORMAT,{&DateFormats}),{&FormatMasks}))).
  hHeaderNode:SET-ATTRIBUTE("TimeCreated":U,STRING(TIME,"HH:MM:SS":U)).
  
  SESSION:TIME-SOURCE = cCurrTimeSource.
  */
  hHeaderNode:SET-ATTRIBUTE("DatasetCode":U,STRING(hDSetCode:BUFFER-VALUE)).
  hHeaderNode:SET-ATTRIBUTE("DatasetObj":U,STRING(hDSetObj:BUFFER-VALUE)).
  hHeaderNode:SET-ATTRIBUTE("DisableRI":U,STRING(hDSetRI:BUFFER-VALUE)).
  hHeaderNode:SET-ATTRIBUTE("SCMManaged":U,STRING(hDSetSCM:BUFFER-VALUE)).
  hHeaderNode:SET-ATTRIBUTE("OriginatingSite":U,STRING(iSiteNo)).

  /* If it's a full header, write out the whole lot, including the table
     definitions. */
  IF NOT plAbbrHeader THEN
    /* Create a Node Element for each field in the input buffer */
    DYNAMIC-FUNCTION("buildElementsFromBuffer":U IN ghXMLHlpr,
                     hHeaderNode, 
                     INPUT phBuff, 
                     "*":U).

  /* Add all the Dataset Entities to this node. */
  writeEntityNodes(hDSetObj:BUFFER-VALUE, hHeaderNode, plAbbrHeader).

  
  IF NOT plAbbrHeader THEN
  DO:
    /* We also write out the structure of all the tables that we're going
       to use so that a) we can create temp-table when they come back in,
       and b) we can check whether the schema has changed. */
  
    EMPTY TEMP-TABLE bttList.
  
    FOR EACH bttTable:
      FIND FIRST bttList 
        WHERE bttList.cEntityMnemonic = bttTable.cEntityMnemonic
        NO-ERROR.
      IF NOT AVAILABLE(bttList) THEN
      DO:
        CREATE bttList.
        ASSIGN
          bttList.cEntityMnemonic = bttTable.cEntityMnemonic
          bttList.hBuffer = bttTable.hBuffer
        .
        FIND FIRST bgsc_entity_mnemonic NO-LOCK
          WHERE bgsc_entity_mnemonic.entity_mnemonic = bttTable.cEntityMnemonic
          NO-ERROR.
        IF AVAILABLE(bgsc_entity_mnemonic) THEN
          ASSIGN
            bttList.cDatabase       = bgsc_entity_mnemonic.entity_dbname
            bttList.cTableName      = bgsc_entity_mnemonic.entity_mnemonic_short_desc
            bttList.cObjField       = bgsc_entity_mnemonic.entity_object_field
            bttList.cKeyField       = bgsc_entity_mnemonic.entity_key_field
            bttList.lHasObj         = bgsc_entity_mnemonic.table_has_object_field
            bttList.lVersionData    = bgsc_entity_mnemonic.version_data
          .
        /* Get the handle to the temp-table buffer */
        hTable = bttList.hBuffer. 
  
        IF VALID-HANDLE(hTable) THEN
          /* Write out the table's structure */
          DYNAMIC-FUNCTION("writeDBSchemaInfo":U IN ghXMLHlpr,
                           hHeaderNode, 
                           hBuffer).
        ELSE
          DELETE bttList.
      END.
    END.
  
  END.
  
  
  /* Delete all the header related objects */
  DELETE OBJECT hHeaderNode.
  hHeaderNode = ?.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeEntityNodes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION writeEntityNodes Procedure 
FUNCTION writeEntityNodes RETURNS LOGICAL
  (INPUT pdObj        AS DECIMAL,  
   INPUT phNode       AS HANDLE,
   INPUT plAbbrHeader AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  Writes the data for the dataset_entities out to the header 
            section of the XML file.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bgsc_dataset_entity FOR gsc_dataset_entity.
  DEFINE BUFFER bgsc_entity_mnemonic FOR gsc_entity_mnemonic.
  DEFINE BUFFER bttTable FOR ttTable.
  

  DEFINE VARIABLE hBuffer          AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hEntity          AS HANDLE   NO-UNDO.
  DEFINE VARIABLE cQualTable       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hXDoc            AS HANDLE   NO-UNDO.
  
  /* Loop through the dataset entity table */
  FOR EACH bgsc_dataset_entity NO-LOCK
      WHERE bgsc_dataset_entity.deploy_dataset_obj = pdObj
    BY bgsc_dataset_entity.deploy_dataset_obj
    BY bgsc_dataset_entity.entity_sequence:

    /* Find the entity mnemonic for the dataset entity */
    FIND FIRST bgsc_entity_mnemonic NO-LOCK
      WHERE bgsc_entity_mnemonic.entity_mnemonic = bgsc_dataset_entity.entity_mnemonic
      NO-ERROR.
    IF NOT AVAILABLE(bgsc_entity_mnemonic) THEN
      NEXT.

    /* Make sure there's an entry for this table in the temp-table */
    FIND bttTable 
      WHERE bttTable.iEntitySeq      = bgsc_dataset_entity.entity_sequence
        AND bttTable.cEntityMnemonic = bgsc_dataset_entity.entity_mnemonic
      NO-ERROR.
    IF NOT AVAILABLE(bttTable) THEN
    DO:
      CREATE bttTable.
      ASSIGN
        bttTable.iEntitySeq      = bgsc_dataset_entity.entity_sequence
        bttTable.cEntityMnemonic = bgsc_dataset_entity.entity_mnemonic
        bttTable.cDatabase       = bgsc_entity_mnemonic.entity_dbname
        bttTable.cTableName      = bgsc_entity_mnemonic.entity_mnemonic_description
        bttTable.lPrimary        = bgsc_dataset_entity.primary_entity
        bttTable.cJoinMnemonic   = bgsc_dataset_entity.join_entity_mnemonic
        bttTable.cJoinFieldList  = bgsc_dataset_entity.join_field_list
        bttTable.cWhereClause    = bgsc_dataset_entity.filter_where_clause
        bttTable.cExcludeFields  = bgsc_dataset_entity.exclude_field_list
        bttTable.hBuffer         = ?
      .
    END.

    /* Now we make sure that the buffer handle is valid */
    hBuffer = bttTable.hBuffer.
    cQualTable = "":U.
    IF NOT VALID-HANDLE(hBuffer) OR
       hBuffer:DBNAME <> bttTable.cDatabase OR
       hBuffer:NAME <> bttTable.cTableName THEN
    DO:
      /* If the buffer handle is not valid, we need to create one. */


      /* First determine what the qualified database name is for this
         table. If cDatabase is not blank, try and qualify the table with
         the database name */
      IF bttTable.cDatabase <> ? AND
         bttTable.cDatabase <> "":U THEN
        cQualTable = bttTable.cDatabase + ".":U.

      /* Tag on the table name. */
      cQualTable = cQualTable + bttTable.cTableName.

      /* Create a buffer for the table */
      RUN obtainPoolObject /* IN ghObjectPool */
        ("BUFFER":U, 
         cQualTable, 
         OUTPUT hBuffer).

      /* Set the handle to the buffer on the temp-table */
      bttTable.hBuffer = hBuffer.
    END.

    IF NOT plAbbrHeader THEN
    DO:
      /* Create a dataset_entity node for this table */
      hEntity = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr, phNode, "dataset_entity":U).
  
      /* Create a Node Element for each field */
      DYNAMIC-FUNCTION("buildElementsFromBuffer":U IN ghXMLHlpr,
                              hEntity,
                              INPUT BUFFER bgsc_dataset_entity:HANDLE,
                              "*":U).
  
      /* Create a Node Element for each field */
      DYNAMIC-FUNCTION("buildElementsFromBuffer":U IN ghXMLHlpr,
                              hEntity,
                              INPUT BUFFER bgsc_entity_mnemonic:HANDLE,
                              "entity_dbname,entity_mnemonic_description":U).
  
      /* Delete the entity node object */
      DELETE OBJECT hEntity.
      hEntity = ?.
    END.
  END. /* FOR EACH */
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeRecordVersionAttr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION writeRecordVersionAttr Procedure 
FUNCTION writeRecordVersionAttr RETURNS LOGICAL
  ( INPUT pcEntityMnemonic AS CHARACTER, 
    INPUT phBuff           AS HANDLE,
    INPUT pcKey            AS CHARACTER,
    INPUT phRecordNode     AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  This procedure takes a buffer, obtains the gst_record_version 
            record for the buffer and writes out the version data into attributes
            of the XML node
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lAns              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lReset            AS LOGICAL    NO-UNDO.
  
  DEFINE BUFFER bgst_record_version FOR gst_record_version.
  DEFINE BUFFER bttVersionReset     FOR ttVersionReset.

  DO FOR bgst_record_version, bttVersionReset:

    /* First find the gst_record_version */
    lAns = obtainDataVersionRec(pcEntityMnemonic,
                                phBuff,
                                pcKey,
                                INPUT BUFFER bgst_record_version:HANDLE,
                                "NO-LOCK":U).
  
    /* If you found the gst_record_version record, 
       write out all the attributes */
    IF lAns AND AVAILABLE(bgst_record_version) THEN
    DO:
      writeVersionAttr(phRecordNode, INPUT BUFFER bgst_record_version:HANDLE).
      
      /* Check the ResetModifiedStatus flag. */
      lReset = getAttribute(0, "ResetModifiedStatus":U) = "YES":U.
      IF lReset = ? THEN
        lReset = NO.
      
      /* If the reset modified status flag is set to yes, we need to reset this record
         when we have finished dumping the dataset. This means that we need to write
         the obj into the ttVersionReset table so that we can reset it later. */
      IF lReset THEN
      DO:
        FIND bttVersionReset 
          WHERE bttVersionReset.record_version_obj = bgst_record_version.record_version_obj
          NO-ERROR.
        IF NOT AVAILABLE(bttVersionReset) THEN
        DO:
          CREATE bttVersionReset.
          ASSIGN
            bttVersionReset.record_version_obj = bgst_record_version.record_version_obj
          .
        END.
      END.

      RETURN TRUE.
    END. /* IF lAns AND AVAILABLE(bgst_record_version) */
    ELSE
      RETURN FALSE.   
  END. /* DO FOR bgst_record_version, bttVersionReset */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeVersionAttr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION writeVersionAttr Procedure 
FUNCTION writeVersionAttr RETURNS LOGICAL
  ( INPUT phRecordNode AS HANDLE,
    INPUT phRVBuffer   AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  phRecordNode:SET-ATTRIBUTE("version_number_seq":U, 
                            STRING(ABS(phRVBuffer:BUFFER-FIELD("version_number_seq":U):BUFFER-VALUE))).
  phRecordNode:SET-ATTRIBUTE("import_version_number_seq":U, 
                            STRING(ABS(phRVBuffer:BUFFER-FIELD("import_version_number_seq":U):BUFFER-VALUE))).
  phRecordNode:SET-ATTRIBUTE("version_user":U, 
                            phRVBuffer:BUFFER-FIELD("version_user":U):BUFFER-VALUE).
  phRecordNode:SET-ATTRIBUTE("version_date":U, 
                            STRING(phRVBuffer:BUFFER-FIELD("version_date":U):BUFFER-VALUE, 
                                   ENTRY(LOOKUP(SESSION:DATE-FORMAT,{&DateFormats}),{&FormatMasks}))).
  phRecordNode:SET-ATTRIBUTE("version_time":U, 
                            STRING(phRVBuffer:BUFFER-FIELD("version_time":U):BUFFER-VALUE)).
  phRecordNode:SET-ATTRIBUTE("key_field_value":U, 
                            replaceCtrlChar(phRVBuffer:BUFFER-FIELD("key_field_value":U):BUFFER-VALUE,YES)).
  phRecordNode:SET-ATTRIBUTE("secondary_key_value":U, 
                            replaceCtrlChar(phRVBuffer:BUFFER-FIELD("secondary_key_value":U):BUFFER-VALUE,YES)).
  phRecordNode:SET-ATTRIBUTE("entity_mnemonic":U, 
                            phRVBuffer:BUFFER-FIELD("entity_mnemonic":U):BUFFER-VALUE).
  phRecordNode:SET-ATTRIBUTE("record_version_obj":U,
                            STRING(phRVBuffer:BUFFER-FIELD("record_version_obj":U):BUFFER-VALUE)).
  phRecordNode:SET-ATTRIBUTE("deletion_flag":U,
                            STRING(phRVBuffer:BUFFER-FIELD("deletion_flag":U):BUFFER-VALUE)).
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

