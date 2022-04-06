
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: afgengenob.i

  Description:  Object Generator Generate Objects Includ

  Purpose:      Object Generator Generate Objects Include. This include replaces the
                generateObjects IP because of Section Editor space issues.

  Parameters:   DEFINE INPUT  PARAMETER plRunSilent             AS LOGICAL          NO-UNDO.
                DEFINE INPUT  PARAMETER TABLE FOR ttInfoMaster.
                DEFINE INPUT  PARAMETER TABLE FOR ttInfoInstance.
                DEFINE OUTPUT PARAMETER TABLE FOR ttErrorLog.

---------------------------------------------------------------------------------*/

  DEFINE VARIABLE cLogDescription               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogMessage                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrorStatus                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lErrorEncountered             AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cGenerationList               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lGenerateDataObjects          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lGenerateDataFields           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lGenerateBrowsers             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lGenerateViewers              AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cScmWorkspace                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iScmTask                      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cScmWorkspaceRoot             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cScmDLPGroup                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cScmDLPSubtype                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lScmDLPOverwrite              AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cFolderIndicator              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFolderRootDirectory          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lFolderCreateMissing          AS LOGICAL    NO-UNDO.  

  DEFINE VARIABLE cDataObjectAppServerPartition AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataObjectFieldSequence      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDataObjectSuppressValidation AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDataObjectFollowJoins        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iDataObjectFollowDepth        AS INTEGER    NO-UNDO.

  DEFINE VARIABLE cDataObjectRelativePath       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataObjectFullPathName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataObjectModule             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataObjectObjectType         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataObjectSuffix             AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cDataLogicProcRelativePath    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataLogicProcFullPathName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataLogicProcModule          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataLogicProcObjectType      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataLogicProcSuffix          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataLogicProcTemplate        AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cDataFieldModule              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataFieldObjectType          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDataFieldFromDataObject      AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cViewerModule                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cViewerSuffix                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cViewerObjectType             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lViewerFromDataObject         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lViewerDeleteInstances        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iViewerFieldsPerColumn        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iViewerNumFields              AS INTEGER    NO-UNDO.

  DEFINE VARIABLE cBrowseModule                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBrowseSuffix                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBrowseObjectType             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lBrowseFromDataObject         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lBrowseDeleteInstances        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iBrowseNumFields              AS INTEGER    NO-UNDO.

  DEFINE VARIABLE hSmartDataObject              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dSmartobjectObj               AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE cNameDatabase                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNameModule                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNameTable                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNameEntity                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNameDataObject               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNameDataLogicProc            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNameCustomSuperProc          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNameViewer                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNameBrowser                  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iLoopCnt                      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLoopList                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLoopValue                    AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cValueDB                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValueTables                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataObjectFieldList          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValueEntity                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValidateFrom                 AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lUseSDOFieldOrderForBrowser   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lUseSDOFieldOrderForViewer    AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE hRepDesignManager             AS HANDLE  NO-UNDO.
  DEFINE VARIABLE cError                        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewObjectName                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewObjectExt                 AS CHARACTER  NO-UNDO.

  DEFINE BUFFER ttInfoMaster                    FOR ttInfoMaster.
  DEFINE BUFFER ttInfoInstance                  FOR ttInfoInstance.

  EMPTY TEMP-TABLE ttErrorLog.

  ASSIGN
    glCancelJob = NO.

  SUBSCRIBE "cancelGeneration":U ANYWHERE.

  /* Make sure we have the SCM tool PLIP available, if we are using RTB */
  ASSIGN 
    ghScmTool         = DYNAMIC-FUNCTION('getProcedureHandle':U IN THIS-PROCEDURE, INPUT "PRIVATE-DATA:SCMTool":U) 
    hRepDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U)
    NO-ERROR.
    .
/*   IF NOT VALID-HANDLE(ghScmTool)                                                 */
/*   THEN                                                                           */
/*     RETURN ERROR {aferrortxt.i 'AF' '19' '?' '?' "''" "'rtb/prc/afrtbprocp.p'"}. */
  ASSIGN
    cScmWorkspace     =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "SCM":U, INPUT "WORKSPACE":U)
    iScmTask          = INTEGER(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "SCM":U, INPUT "TASK":U))
    cScmWorkspaceRoot =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "SCM":U, INPUT "WORKSPACE-ROOT":U)
    cScmDLPGroup      =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "SCM":U, INPUT "DLP-GROUP":U)
    cScmDLPSubtype    =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "SCM":U, INPUT "DLP-SUBTYPE":U)
    lScmDLPOverwrite  = LOGICAL(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "SCM":U, INPUT "DLP-OVERWRITE-IN-TASK":U))
    .

  /* These values are not stored on the actual MASTER record */
  ASSIGN
    cNameDatabase = DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Tables":U, INPUT "DATABASE":U)
    cNameModule   = DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Tables":U, INPUT "MODULE":U)
    .

  ASSIGN
    cGenerationList      = DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Header":U, INPUT "CREATE-OBJECT-TYPES":U)
    lGenerateDataObjects = CAN-DO(cGenerationList, "DataObject":U)
    lGenerateDataFields  = CAN-DO(cGenerationList, "DataField":U)
    lGenerateBrowsers    = CAN-DO(cGenerationList, "Browse":U)
    lGenerateViewers     = CAN-DO(cGenerationList, "Viewer":U)
    .

  IF lGenerateDataFields
  THEN DO:
    ASSIGN
      cDataFieldModule          =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataField":U, INPUT "MODULE":U)
      cDataFieldObjectType      =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataField":U, INPUT "OBJECT-TYPE":U)
      lDataFieldFromDataObject  = LOGICAL(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataField":U, INPUT "USE-DATA-OBJECT":U))
      .
  END.

  IF lGenerateDataObjects
  THEN DO:
    ASSIGN
      cFolderIndicator              = "/":U
      cFolderRootDirectory          =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "ROOT-FOLDER":U)
      lFolderCreateMissing          = LOGICAL(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "CREATE-MISSING-FOLDER":U))
      cDataObjectAppServerPartition =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "AS-PARTITION":U)            
      cDataObjectFieldSequence      =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "FIELD-SEQUENCE":U)
      lDataObjectSuppressValidation = LOGICAL(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "SUPPRESS-VALIDATION":U))
      lDataObjectFollowJoins        = LOGICAL(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "FOLLOW-JOINS":U))
      iDataObjectFollowDepth        =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "FOLLOW-DEPTH":U)
      cDataObjectModule             =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "MODULE":U)
      cDataObjectObjectType         =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "OBJECT-TYPE":U)
      cDataObjectSuffix             =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "SUFFIX":U)
      cDataObjectRelativePath       =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "PATH":U)
      cDataLogicProcModule          =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "LP-MODULE":U)
      cDataLogicProcObjectType      =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "LP-OBJECT-TYPE":U)
      cDataLogicProcSuffix          =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "LP-SUFFIX":U)
      cDataLogicProcTemplate        =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "LP-TEMPLATE":U)
      cDataLogicProcRelativePath    =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "LP-PATH":U)
      .

    IF LOGICAL(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "VALIDATE-FROM-MANDATORY":U)) THEN
        ASSIGN cValidateFrom = "Mandatory,":U.
    IF LOGICAL(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "VALIDATE-FROM-INDEX":U)) THEN
        ASSIGN cValidateFrom = cValidateFrom + "Index":U.

    ASSIGN cValidateFrom = RIGHT-TRIM(cValidateFrom, ",":U).

    /* Always set this property - if it is blank then no validation will be generated. */
    DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                     INPUT "OG_ValidateFrom":U,
                     INPUT cValidateFrom ).

    IF cFolderRootDirectory       EQ "":U OR cFolderRootDirectory       EQ ? THEN cFolderRootDirectory        = ".":U.
    IF cDataObjectRelativePath    EQ "":U OR cDataObjectRelativePath    EQ ? THEN cDataObjectRelativePath     = "":U.
    IF cDataLogicProcRelativePath EQ "":U OR cDataLogicProcRelativePath EQ ? THEN cDataLogicProcRelativePath  = "":U.

    /* Make sure the directory is a valid (writable) directory. */
    FILE-INFO:FILE-NAME = cFolderRootDirectory.
    IF FILE-INFO:FULL-PATHNAME = ?
    OR INDEX(FILE-INFO:FILE-TYPE,"D") = 0
    OR INDEX(FILE-INFO:FILE-TYPE,"W") = 0
    THEN ASSIGN cFolderRootDirectory = SESSION:TEMP-DIRECTORY.
    ELSE ASSIGN cFolderRootDirectory = FILE-INFO:FULL-PATHNAME.

    ASSIGN
      cFolderRootDirectory        = REPLACE(cFolderRootDirectory      ,"~\":U,cFolderIndicator)
      cDataObjectRelativePath     = REPLACE(cDataObjectRelativePath   ,"~\":U,cFolderIndicator)
      cDataLogicProcRelativePath  = REPLACE(cDataLogicProcRelativePath,"~\":U,cFolderIndicator)
      cFolderRootDirectory        = RIGHT-TRIM(cFolderRootDirectory      ,cFolderIndicator) + cFolderIndicator
      cDataObjectRelativePath     = RIGHT-TRIM(cDataObjectRelativePath   ,cFolderIndicator) + cFolderIndicator
      cDataLogicProcRelativePath  = RIGHT-TRIM(cDataLogicProcRelativePath,cFolderIndicator) + cFolderIndicator
      .
  END.

  IF lGenerateBrowsers
  THEN DO:
    ASSIGN
      cBrowseModule               =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Browse":U, INPUT "MODULE":U)
      cBrowseSuffix               =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Browse":U, INPUT "SUFFIX":U) 
      cBrowseObjectType           =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Browse":U, INPUT "OBJECT-TYPE":U)
      lBrowseFromDataObject       = LOGICAL(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Browse":U, INPUT "USE-DATA-OBJECT":U))
      lBrowseDeleteInstances      = LOGICAL(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Browse":U, INPUT "DELETE-INSTANCES":U))
      iBrowseNumFields            = INTEGER(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Browse":U, INPUT "NUM-FIELDS":U))
      lUseSDOFieldOrderForBrowser = LOGICAL(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Browse":U, INPUT "USE-DATA-OBJECT-FIELD-ORDER":U))
      .
  END.

  IF lGenerateViewers
  THEN DO:
    ASSIGN
      cViewerModule              =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Viewer":U, INPUT "MODULE":U)
      cViewerSuffix              =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Viewer":U, INPUT "SUFFIX":U) 
      cViewerObjectType          =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Viewer":U, INPUT "OBJECT-TYPE":U)
      lViewerFromDataObject      = LOGICAL(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Viewer":U, INPUT "USE-DATA-OBJECT":U))
      lViewerDeleteInstances     = LOGICAL(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Viewer":U, INPUT "DELETE-INSTANCES":U))
      iViewerNumFields           = INTEGER(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Viewer":U, INPUT "NUM-FIELDS":U))
      iViewerFieldsPerColumn     = INTEGER(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Viewer":U, INPUT "NUM-FIELDS-COLUMN":U))
      lUseSDOFieldOrderForViewer = LOGICAL(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Viewer":U, INPUT "USE-DATA-OBJECT-FIELD-ORDER":U))
      .
  END.

  DYNAMIC-FUNCTION("logTheError":U
                  ,INPUT plRunSilent
                  ,INPUT "Generator":U
                  ,INPUT "Started"
                  ,INPUT "":U
                  ,INPUT "MESSAGE":U
                  ,INPUT "Object generation started.":U
                  ).

  ASSIGN
    cLogMessage = "":U.

  /* Log all the settings */
  FOR EACH ttInfoInstance NO-LOCK
    BREAK BY ttInfoInstance.tIKey
    :

    ASSIGN
      cLogMessage = cLogMessage
                  + (IF cLogMessage <> "":U THEN CHR(10) ELSE "":U)
                  + ttInfoInstance.tIPData
                  + " : ":U
                  + ttInfoInstance.tIValue
                  .

    IF LAST-OF(ttInfoInstance.tIKey)
    THEN DO:
      DYNAMIC-FUNCTION("logTheError":U
                      ,INPUT plRunSilent
                      ,INPUT "Generator":U
                      ,INPUT "Settings":U
                      ,INPUT ttInfoInstance.tIKey
                      ,INPUT "MESSAGE":U
                      ,INPUT cLogMessage
                      ).
      ASSIGN
        cLogMessage = "":U.
    END.

  END.    /* Settings */

  /*
  *************************************

  PROCESS FLOW:
  -------------
  010) "DataFields"
  020) "DataObjects"
  021) "DataLogic Procedure"
       - If DataObject generation was successful
  030) "DataBrowser"
       - If DataObject generation was successful
  040) "DataViewer"
       - If DataObject generation was successful
       - If DataFields generation was successful

  *************************************
  */

  ASSIGN
    lErrorEncountered = NO.

  blkInfoMaster:
  FOR EACH ttInfoMaster NO-LOCK:

    /* Reset the error status */
    ASSIGN
      cErrorStatus = "":U.

    ASSIGN
      cLogDescription = (IF ttInfoMaster.tMPData EQ "DATABASE":U
                         THEN "Table: "
                         ELSE "Object: "
                        )
                      + ttInfoMaster.tMName
                      .

    DYNAMIC-FUNCTION("logTheError":U
                    ,INPUT plRunSilent
                    ,INPUT cLogDescription
                    ,INPUT "Started":U
                    ,INPUT "":U
                    ,INPUT "MESSAGE":U
                    ,INPUT "Generation started.":U
                    ).

    IF ttInfoMaster.tMPData EQ "DATABASE":U
    THEN DO:
      /* Find the Entity Mnemonic and Assign the Values */
      FIND FIRST gsc_entity_mnemonic NO-LOCK 
        WHERE gsc_entity_mnemonic.entity_mnemonic_description = ttInfoMaster.tMName
        NO-ERROR.
      IF AVAILABLE gsc_entity_mnemonic THEN 
      DO:
        ASSIGN
          cValueEntity         = gsc_entity_mnemonic.entity_mnemonic
          cValueDB             = gsc_entity_mnemonic.entity_dbname
          cValueTables         = gsc_entity_mnemonic.entity_mnemonic_description.
        /* The Entity object in the repository has the table name as object_filename,
           and not the entity mnemonic.
         */
        run getContainedInstanceNames in gshRepositoryManager ( input cValueTables,
                                                                output cDataObjectFieldList ) no-error.
      END.    /* available entity mnemonic */
    END.     /* "DATABASE" */
    ELSE DO: /* "SDO" */

      /* Start the SDO  and get the values */
      IF VALID-HANDLE(gshRepositoryManager)
      THEN
        RUN StartDataObject IN gshRepositoryManager
                           (INPUT ttInfoMaster.tMName
                           ,OUTPUT hSmartDataObject
                           ) NO-ERROR.

      IF VALID-HANDLE(hSmartDataObject)
      THEN DO:

        {get DBNames cValueDB hSmartDataObject}.
        {get PhysicalTables cValueTables hSmartDataObject}.
        {get DataColumns cDataObjectFieldList hSmartDataObject}.

        IF cValueDB = ?
        OR cValueDB = "":U
        THEN
          ASSIGN
            cValueDB = cValueTables.

        ASSIGN
          cLoopList = cValueDB
          cValueDB  = "":U.
        DO iLoopCnt = 1 TO NUM-ENTRIES(cLoopList,",":U):
          cLoopValue = ENTRY(iLoopCnt,cLoopList,",":U).
          cValueDB   = cValueDB
                     + (IF cValueDB <> "":U THEN ",":U ELSE "":U)
                     + ENTRY( 1 , cLoopValue ,".":U).
        END.

        ASSIGN
          cLoopList     = cValueTables
          cValueTables  = "":U.
        DO iLoopCnt = 1 TO NUM-ENTRIES(cLoopList,",":U):
          cLoopValue    = ENTRY(iLoopCnt,cLoopList,",":U).
          cValueTables  = cValueTables
                        + (IF cValueTables <> "":U THEN ",":U ELSE "":U)
                        + ENTRY( NUM-ENTRIES(cLoopValue,".":U) , cLoopValue ,".":U).
        END.

        FIND FIRST gsc_entity_mnemonic NO-LOCK
          WHERE gsc_entity_mnemonic.entity_mnemonic_description = ENTRY(1,cValueTables,",":U)
          NO-ERROR.
        IF AVAILABLE gsc_entity_mnemonic
        THEN cValueEntity = gsc_entity_mnemonic.entity_mnemonic.
        ELSE cValueEntity = "":U.

        RUN destroyObject IN hSmartDataObject.

        IF VALID-HANDLE(hSmartDataObject)
        THEN
          DELETE OBJECT hSmartDataObject.
      END.
      ELSE /* NOT VALID-HANDLE(hSmartDataObject) */
      DO:
        /* Log the fact that we could not start the Data Object */
        DYNAMIC-FUNCTION("logTheError":U
                        ,INPUT plRunSilent
                        ,INPUT cLogDescription
                        ,INPUT "Cancelled":U
                        ,INPUT "ERROR!":U
                        ,INPUT "ERROR":U
                        ,INPUT "Further generation for related objects cannot continue - ":U +
                               "could not start the DataObject '":U + ttInfoMaster.tMName + "'.":U +
                               (IF RETURN-VALUE <> "":U AND RETURN-VALUE <> ? THEN "~n~n":U + RETURN-VALUE ELSE "":U)
                        ).
        ASSIGN
          lErrorEncountered = YES.
  
        NEXT blkInfoMaster.
      END.
    END. /* "SDO" */

    ASSIGN
      cValueEntity             = LC(cValueEntity)
      cValueDB                 = LC(cValueDB)
      cValueTables             = LC(cValueTables)
      ttInfoMaster.tMEntity    = cValueEntity
      ttInfoMaster.tMDBList    = cValueDB
      ttInfoMaster.tMTableList = cValueTables
      .

    /* We always determine the name of the DataObject (SDO) first, since we are going to use it in most places. */
    IF ttInfoMaster.tMPData EQ "DATABASE":U
    THEN
      ASSIGN
        cNameDataObject           = LC(ttInfoMaster.tMEntity + cDataObjectSuffix)
        lDataFieldFromDataObject  = NO.
    ELSE
      ASSIGN
        cNameDataObject = LC(ttInfoMaster.tMName).

    ASSIGN
      cNameModule           = ttInfoMaster.tMModule
      cNameDatabase         = ENTRY(1,ttInfoMaster.tMDBList,",":U)
      cNameTable            = ENTRY(1,ttInfoMaster.tMTableList)
      cNameEntity           = LC(ttInfoMaster.tMEntity)
      cNameDataLogicProc    = LC(ttInfoMaster.tMEntity + cDataLogicProcSuffix)
      cNameCustomSuperProc  = "":U
      cNameViewer           = LC(ttInfoMaster.tMEntity + cViewerSuffix)
      cNameBrowser          = LC(ttInfoMaster.tMEntity + cBrowseSuffix)
      .

    IF lDataFieldFromDataObject = ?
    THEN
      ASSIGN
        lDataFieldFromDataObject = NO.

    ASSIGN
      cLogMessage = "Database Name : ":U  + cNameDatabase
        + CHR(10) + "Table Name : ":U     + cNameTable
        + CHR(10) + "Entity Name : ":U    + cNameEntity
        .
    DYNAMIC-FUNCTION("logTheError":U
                    ,INPUT plRunSilent
                    ,INPUT cLogDescription
                    ,INPUT "Settings":U
                    ,INPUT "":U
                    ,INPUT "MESSAGE":U
                    ,INPUT cLogMessage
                    ).

    IF cValueEntity = "":U
    THEN DO:

      ASSIGN
        cLogMessage = "Database Name : ":U  + cNameDatabase
          + CHR(10) + "Table Name : ":U     + cNameTable
          + CHR(10) + "Entity Name : ":U    + cNameEntity
          + CHR(10)
          + CHR(10) + " Entity Record not available"
          .
      DYNAMIC-FUNCTION("logTheError":U
                      ,INPUT plRunSilent
                      ,INPUT cLogDescription
                      ,INPUT "Cancelled":U
                      ,INPUT "ERROR!":U
                      ,INPUT "ERROR":U
                      ,INPUT cLogMessage
                      ).
      ASSIGN
        lErrorEncountered = YES.

      NEXT blkInfoMaster.

    END.

/* OVERRIDE
MESSAGE
  SKIP "Private-Data  : " ttInfoMaster.tMPData
  SKIP "Name          : " ttInfoMaster.tMName
  SKIP "Description   : " ttInfoMaster.tMDescription
  SKIP "Module        : " ttInfoMaster.tMModule
  SKIP "Class         : " ttInfoMaster.tMClass
  SKIP "Entity        : " ttInfoMaster.tMEntity
  SKIP "DB List       : " ttInfoMaster.tMDBList
  SKIP "Table List    : " ttInfoMaster.tMTableList
  SKIP "Name Module   : " cNameModule
  SKIP "Name Database : " cNameDatabase
  SKIP "Name Table    : " cNameTable
  SKIP "Name Entity   : " cNameEntity
  SKIP "Name Logic    : " cNameDataLogicProc
  SKIP "Name Custom   : " cNameCustomSuperProc
  SKIP "Name Viewer   : " cNameViewer
  SKIP "Name Browser  : " cNameBrowser
  SKIP(1) "Continue with generation ?"
  VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
  UPDATE lContinue AS LOGICAL.
IF NOT lContinue
THEN
  ASSIGN
  lGenerateDataObjects = NO
  lGenerateDataFields  = NO
  lGenerateBrowsers     = NO
  lGenerateViewers     = NO
  .
OVERRIDE */

    IF lGenerateDataFields
    THEN
    blkGenerateDataFields:
    DO:

      IF glCancelJob
      THEN LEAVE.

      DYNAMIC-FUNCTION("logTheError":U
                      ,INPUT plRunSilent
                      ,INPUT cLogDescription
                      ,INPUT "Generating DataFields for ":U + cNameTable
                      ,INPUT "Started":U
                      ,INPUT "MESSAGE":U
                      ,INPUT "Generation started.":U
                      ).

      ASSIGN
        cLogMessage = "DataObject":U
          + CHR(10) + "----------":U
          + CHR(10) + "Name : ":U                   + cNameDataObject
          + CHR(10)
          + CHR(10) + "DataField":U
          + CHR(10) + "----------":U
          + CHR(10) + "Module : ":U                 + cDataFieldModule
          + CHR(10) + "ObjectType : ":U             + cDataFieldObjectType
          + CHR(10) + "Use DataObject Fields : ":U  + STRING(lDataFieldFromDataObject)
          .
      DYNAMIC-FUNCTION("logTheError":U
                      ,INPUT plRunSilent
                      ,INPUT cLogDescription
                      ,INPUT "Generating DataFields for ":U + cNameTable
                      ,INPUT "Settings":U
                      ,INPUT "MESSAGE":U
                      ,INPUT cLogMessage
                      ).

      /* If we are generating DataObjects, we always generate the DataFields from the schema. */
      RUN generateDataFields IN ghRepositoryDesignManager
                            (INPUT cNameDatabase
                            ,INPUT cNameTable                 /* table name                */
                            ,INPUT cDataFieldModule
                            ,INPUT "{&DEFAULT-RESULT-CODE}":U
                            ,INPUT lDataFieldFromDataObject   /* plGenerateFromDataObject  */
                            ,INPUT cValueTables               /* List of DataObject Fields */
                            ,INPUT cNameDataObject            /* pcDataObjectName          */
                            ,INPUT cDataFieldObjectType
                            ,INPUT "":U                       /* pcOverrideAttributes */
                            ,INPUT "*":U                      /* pcFieldNames */
                            ) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U
      THEN DO:
        DYNAMIC-FUNCTION("logTheError":U
                        ,INPUT plRunSilent
                        ,INPUT cLogDescription
                        ,INPUT "Generating DataFields for ":U + cNameTable
                        ,INPUT "ERROR!":U
                        ,INPUT "ERROR":U
                        ,INPUT RETURN-VALUE
                        ).
        ASSIGN
          cErrorStatus = cErrorStatus
                       + (IF cErrorStatus <> "":U THEN ",":U ELSE "":U)
                       + "DataFields":U
                       .
        ERROR-STATUS:ERROR = NO.
        LEAVE blkGenerateDataFields.
      END. /* error */
      ELSE
        DYNAMIC-FUNCTION("logTheError":U
                        ,INPUT plRunSilent
                        ,INPUT cLogDescription
                        ,INPUT "Generating DataFields for ":U + cNameTable
                        ,INPUT "Completed":U
                        ,INPUT "MESSAGE":U
                        ,INPUT "Generation completed.":U
                        ).

    END. /* lGenerateDataFields */

    IF lGenerateDataObjects
    THEN DO:

      IF glCancelJob
      THEN LEAVE.

      ASSIGN
        cDataLogicProcFullPathName = cFolderRootDirectory
                                   + (IF cDataLogicProcRelativePath = cFolderIndicator
                                      THEN "":U ELSE cDataLogicProcRelativePath)
                                   + (IF cNameDataLogicProc         = cFolderIndicator
                                      THEN "":U ELSE cNameDataLogicProc)
                                   .
      IF VALID-HANDLE(ghScmTool)
      THEN DO:
        DYNAMIC-FUNCTION("logTheError":U
                        ,INPUT plRunSilent
                        ,INPUT cLogDescription
                        ,INPUT "SCM Checking":U
                        ,INPUT "Started":U
                        ,INPUT "MESSAGE":U
                        ,INPUT "SCM checks started.":U
                        ).
        RUN scmValidate (INPUT cScmWorkspace
                        ,INPUT iScmTask
                        ,INPUT cDataLogicProcModule
                        ,INPUT cNameDataObject
                        ,INPUT cDataLogicProcFullPathName
                        ,INPUT cScmDLPSubtype
                        ,INPUT lScmDLPOverwrite
                        ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U
        THEN DO:
          DYNAMIC-FUNCTION("logTheError":U
                          ,INPUT plRunSilent
                          ,INPUT cLogDescription
                          ,INPUT "SCM Checking":U
                          ,INPUT "ERROR!"
                          ,INPUT "ERROR":U
                          ,INPUT RETURN-VALUE
                          ).
          ASSIGN
            cErrorStatus = cErrorStatus
                         + (IF cErrorStatus <> "":U THEN ",":U ELSE "":U)
                         + "SCM":U
                         .
          ERROR-STATUS:ERROR = NO.
        END. /* error */
        ELSE
          DYNAMIC-FUNCTION("logTheError":U
                          ,INPUT plRunSilent
                          ,INPUT cLogDescription
                          ,INPUT "SCM Checking":U
                          ,INPUT "Completed":U
                          ,INPUT "MESSAGE":U
                          ,INPUT "SCM checks completed.":U
                          ).
      END.    /* RTB connected */

      blkGenerateDataObjects:
      DO:

        IF LOOKUP("SCM":U,cErrorStatus) <> 0
        THEN DO:
          DYNAMIC-FUNCTION("logTheError":U
                          ,INPUT plRunSilent
                          ,INPUT cLogDescription
                          ,INPUT "Generating DataObject":U
                          ,INPUT "Cancelled":U
                          ,INPUT "INFORMATION":U
                          ,INPUT "SCM Checking failed":U
                          ).
          ASSIGN
            cErrorStatus = cErrorStatus
                         + (IF cErrorStatus <> "":U THEN ",":U ELSE "":U)
                         + "DataObject":U
                         .
        END.
        ELSE DO:

          /* Generate the DataObject */
          DYNAMIC-FUNCTION("logTheError":U
                          ,INPUT plRunSilent
                          ,INPUT cLogDescription
                          ,INPUT "Generating DataObject":U
                          ,INPUT "Started":U
                          ,INPUT "MESSAGE":U
                          ,INPUT "Generation started.":U
                          ).

          IF cDataObjectAppServerPartition EQ "<None>":U
          THEN
            ASSIGN
              cDataObjectAppServerPartition = "":U.
         
                    /* Run prepareObject API for data object allowing system wide customization of name */
          cError = DYNAMIC-FUNCTION("prepareObjectName":U in hRepDesignManager,
                                             cNameDataObject,           /*Suggested Name */
                                             "{&DEFAULT-RESULT-CODE}",  /* Result Code */
                                             cDataObjectSuffix,         /* Additional string - suffix */
                                             "DEFAULT":U,               /* Default or Save */
                                             cDataObjectObjectType,     /* Object Type */
                                             cNameEntity,               /* Entity */
                                             cDataObjectModule,         /*Module */   
                                             OUTPUT cNewObjectName,     
                                             OUTPUT cNewObjectExt ) .
          IF cError > "" THEN DO:
             DYNAMIC-FUNCTION("logTheError":U
                        ,INPUT plRunSilent
                        ,INPUT cLogDescription
                        ,INPUT "Generating DataObject"
                        ,INPUT "ERROR!":U
                        ,INPUT "ERROR":U
                        ,INPUT cError
                        ).

            ERROR-STATUS:ERROR = NO.
            LEAVE blkGenerateDataObjects.
          END.
          ELSE IF cNewObjectName > "" THEN
             ASSIGN cNameDataObject = cNewObjectName + (IF cNewObjectExt > "" THEN "." ELSE "") + cNewObjectExt.
             
          /* Run prepareObject API for data logic object allowing system wide customization of name */
          ASSIGN cNewObjectName = ""
                 cNewObjectExt  = ""
                 cError         = "".
          cError = DYNAMIC-FUNCTION("prepareObjectName":U in hRepDesignManager,
                                             cNameDataLogicProc,        /*Suggested Name */
                                             "{&DEFAULT-RESULT-CODE}",  /* Result Code */
                                             cDataLogicProcSuffix,      /* Additional string - suffix */
                                             "DEFAULT":U,               /* Default or Save */
                                             cDataLogicProcObjectType,  /* Object Type */
                                             cNameEntity,               /* Entity */
                                             cDataLogicProcModule       /* Module */,     
                                             OUTPUT cNewObjectName,     
                                             OUTPUT cNewObjectExt ) .
          IF cError > "" THEN DO:
             DYNAMIC-FUNCTION("logTheError":U
                        ,INPUT plRunSilent
                        ,INPUT cLogDescription
                        ,INPUT "Generating DataLogicObject"
                        ,INPUT "ERROR!":U
                        ,INPUT "ERROR":U
                        ,INPUT cError
                        ).

            ERROR-STATUS:ERROR = NO.
            LEAVE blkGenerateDataObjects.
          END.
          ELSE IF cNewObjectName > "" THEN
             ASSIGN cNameDataLogicProc = cNewObjectName + (IF cNewObjectExt > "" THEN "." ELSE "") + cNewObjectExt.   
             

          ASSIGN
            cLogMessage = "DataObject":U
              + CHR(10) + "----------":U
              + CHR(10) + "Name : ":U                                 + cNameDataObject
              + CHR(10) + "Relative Path : ":U                        + IF cDataObjectRelativePath       = ? THEN "" ELSE cDataObjectRelativePath
              + CHR(10) + "Module : ":U                               + IF cDataObjectModule             = ? THEN "" ELSE cDataObjectModule
              + CHR(10) + "ObjectType : ":U                           + IF cDataObjectObjectType         = ? THEN "" ELSE cDataObjectObjectType
              + CHR(10) + "Suppress Validation : ":U                  + IF lDataObjectSuppressValidation = ? THEN "" ELSE STRING(lDataObjectSuppressValidation)
              + CHR(10) + "Follow Joins : ":U                         + IF lDataObjectFollowJoins        = ? THEN "" ELSE STRING(lDataObjectFollowJoins)
              + CHR(10) + "Follow Depth : ":U                         + IF iDataObjectFollowDepth        = ? THEN "" ELSE STRING(iDataObjectFollowDepth)
              + CHR(10) + "Field Sequences : ":U                      + IF cDataObjectFieldSequence      = ? THEN "" ELSE cDataObjectFieldSequence
              + CHR(10) + "AppServer Partition : ":U                  + IF cDataObjectAppServerPartition = ? THEN "" ELSE cDataObjectAppServerPartition
              + CHR(10)
              + CHR(10) + "DataLogic Procedure":U
              + CHR(10) + "-------------------":U
              + CHR(10) + "Name : ":U                                 + cNameDataLogicProc
              + CHR(10) + "Relative Path : ":U                        + cDataLogicProcRelativePath
              .

          DYNAMIC-FUNCTION("logTheError":U
                          ,INPUT plRunSilent
                          ,INPUT cLogDescription
                          ,INPUT "Generating DataObject":U
                          ,INPUT "Settings":U
                          ,INPUT "MESSAGE":U
                          ,INPUT cLogMessage
                          ).

          RUN generateDataObject IN ghRepositoryDesignManager
                                (INPUT cNameDatabase
                                ,INPUT cNameTable                 /* table name */
                                ,INPUT cNameEntity                /* dump name */
                                ,INPUT cNameDataObject
                                ,INPUT cDataObjectObjectType
                                ,INPUT cDataObjectModule
                                ,INPUT "{&DEFAULT-RESULT-CODE}":U
                                ,INPUT NO
                                ,INPUT NO
                                ,INPUT lDataObjectSuppressValidation
                                ,INPUT lDataObjectFollowJoins
                                ,INPUT iDataObjectFollowDepth
                                ,INPUT cDataObjectFieldSequence
                                ,INPUT cNameDataLogicProc
                                ,INPUT cDataObjectRelativePath
                                ,INPUT cDataLogicProcRelativePath
                                ,INPUT cFolderRootDirectory
                                ,INPUT lFolderCreateMissing
                                ,INPUT cDataObjectAppServerPartition
                                ) NO-ERROR.
          IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U
          THEN DO:                
            DYNAMIC-FUNCTION("logTheError":U
                            ,INPUT plRunSilent
                            ,INPUT cLogDescription
                            ,INPUT "Generating DataObject":U
                            ,INPUT "ERROR!"
                            ,INPUT "ERROR":U
                            ,INPUT RETURN-VALUE
                            ).
            ASSIGN
              cErrorStatus = cErrorStatus
                           + (IF cErrorStatus <> "":U THEN ",":U ELSE "":U)
                           + "DataObject":U
                           .
            ERROR-STATUS:ERROR = NO.
            LEAVE blkGenerateDataObjects.
          END. /* error */
          ELSE
            DYNAMIC-FUNCTION("logTheError":U
                            ,INPUT plRunSilent
                            ,INPUT cLogDescription
                            ,INPUT "Generating DataObject":U
                            ,INPUT "Completed":U
                            ,INPUT "MESSAGE":U
                            ,INPUT "Generation completed.":U
                            ).

        END.

        blkGenerateDataLogicProcedure:
        DO:

          IF LOOKUP("DataObject":U,cErrorStatus) <> 0
          THEN DO:
            DYNAMIC-FUNCTION("logTheError":U
                            ,INPUT plRunSilent
                            ,INPUT cLogDescription
                            ,INPUT "Generating DataLogic Procedure":U
                            ,INPUT "Cancelled":U
                            ,INPUT "INFORMATION":U
                            ,INPUT "DataObject generation failed":U
                            ).
            ASSIGN
              cErrorStatus = cErrorStatus
                           + (IF cErrorStatus <> "":U THEN ",":U ELSE "":U)
                           + "DataLogicProcedure":U
                           .
            LEAVE blkGenerateDataLogicProcedure.
          END.

          /* Generate the DataLogic Procedure  */
          DYNAMIC-FUNCTION("logTheError":U
                          ,INPUT plRunSilent
                          ,INPUT cLogDescription
                          ,INPUT "Generating DataLogic Procedure":U
                          ,INPUT "Started":U
                          ,INPUT "MESSAGE":U
                          ,INPUT "Generation started.":U
                          ).
          /* Ensure the relative path isn't just '/' */
          IF cDataLogicProcRelativePath = cFolderIndicator THEN
            cDataLogicProcRelativePath = "":U.

            ASSIGN
              cLogMessage = "DataObject":U
                + CHR(10) + "----------":U
                + CHR(10) + "Name : ":U                 + cNameDataObject
                + CHR(10) + "Relative Path : ":U        + cDataObjectRelativePath
                + CHR(10) + "Suppress Validation : ":U  + STRING(lDataObjectSuppressValidation)
                + CHR(10)
                + CHR(10) + "DataLogic Procedure":U
                + CHR(10) + "-------------------":U
                + CHR(10) + "Name : ":U                 + cNameDataLogicProc
                + CHR(10) + "Relative Path : ":U        + cDataLogicProcRelativePath
                + CHR(10) + "Module : ":U               + cDataLogicProcModule
                + CHR(10) + "ObjectType : ":U           + cDataLogicProcObjectType
                + CHR(10) + "Template : ":U             + cDataLogicProcTemplate
                .
            DYNAMIC-FUNCTION("logTheError":U
                            ,INPUT plRunSilent
                            ,INPUT cLogDescription
                            ,INPUT "Generating DataLogic Procedure":U
                            ,INPUT "Settings":U
                            ,INPUT "MESSAGE":U
                            ,INPUT cLogMessage
                            ).

          RUN generateDataLogicObject IN ghRepositoryDesignManager
                                     (INPUT cNameDatabase
                                     ,INPUT cNameTable              /* table name */
                                     ,INPUT cNameEntity             /* dump name */
                                     ,INPUT cNameDataObject
                                     ,INPUT cDataLogicProcModule
                                     ,INPUT "{&DEFAULT-RESULT-CODE}":U
                                     ,INPUT lDataObjectSuppressValidation
                                     ,INPUT cNameDataLogicProc
                                     ,INPUT cDataLogicProcObjectType
                                     ,INPUT cDataLogicProcTemplate
                                     ,INPUT cDataObjectRelativePath           /* SDO    */
                                     ,INPUT cDataLogicProcRelativePath        /* DLProc */
                                     ,INPUT cFolderRootDirectory
                                     ,INPUT cFolderIndicator
                                     ,INPUT lFolderCreateMissing
                                     ) NO-ERROR.
          IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U
          THEN DO:
            DYNAMIC-FUNCTION("logTheError":U
                            ,INPUT plRunSilent
                            ,INPUT cLogDescription
                            ,INPUT "Generating DataLogic Procedure":U
                            ,INPUT "ERROR!":U
                            ,INPUT "ERROR":U
                            ,INPUT RETURN-VALUE
                            ).
            ASSIGN
              cErrorStatus = cErrorStatus
                           + (IF cErrorStatus <> "":U THEN ",":U ELSE "":U)
                           + "DataLogicProcedure":U
                           .
            ERROR-STATUS:ERROR = NO.
            LEAVE blkGenerateDataLogicProcedure.
          END. /* error */
          ELSE
            DYNAMIC-FUNCTION("logTheError":U
                            ,INPUT plRunSilent
                            ,INPUT cLogDescription
                            ,INPUT "Generating DataLogic Procedure":U
                            ,INPUT "Completed":U
                            ,INPUT "MESSAGE":U
                            ,INPUT "Generation completed.":U
                            ).

        END.  /* Generate DataLogicProcedure */

      END.  /* Generate DataObjects */

    END.  /* Generate DataObjects */

    IF lGenerateBrowsers
    THEN
    blkGenerateBrowsers:
    DO:

      IF LOOKUP("DataObject":U,cErrorStatus) <> 0
      THEN DO:
        DYNAMIC-FUNCTION("logTheError":U
                        ,INPUT plRunSilent
                        ,INPUT cLogDescription
                        ,INPUT "Generating Browse":U
                        ,INPUT "Cancelled":U
                        ,INPUT "INFORMATION":U
                        ,INPUT "DataObject generation failed":U
                        ).
        ASSIGN
          cErrorStatus = cErrorStatus
                       + (IF cErrorStatus <> "":U THEN ",":U ELSE "":U)
                       + "Browse":U
                       .
        LEAVE blkGenerateBrowsers.
      END.

      IF glCancelJob
      THEN LEAVE.

      DYNAMIC-FUNCTION("logTheError":U
                      ,INPUT plRunSilent
                      ,INPUT cLogDescription
                      ,INPUT "Generating Browse":U
                      ,INPUT "Started":U
                      ,INPUT "MESSAGE":U
                      ,INPUT "Generation started.":U
                      ).
      /* Run prepareObject API for browser object allowing system wide customization of name */
       ASSIGN cNewObjectName = ""
              cNewObjectExt  = ""
              cError         = "".
       cError = DYNAMIC-FUNCTION("prepareObjectName":U in hRepDesignManager,
                                          cNameBrowser,              /*Suggested Name */
                                          "{&DEFAULT-RESULT-CODE}",  /* Result Code */
                                          cBrowseSuffix,             /* Additional string - suffix */
                                          "DEFAULT":U,               /* Default or Save */
                                          cBrowseObjectType,         /* Object Type */
                                          cNameEntity,               /* Entity */
                                          cBrowseModule,             /* Module */
                                          OUTPUT cNewObjectName,     
                                          OUTPUT cNewObjectExt ) .
       IF cError > "" THEN DO:
          DYNAMIC-FUNCTION("logTheError":U
                     ,INPUT plRunSilent
                     ,INPUT cLogDescription
                     ,INPUT "Generating Browser"
                     ,INPUT "ERROR!":U
                     ,INPUT "ERROR":U
                     ,INPUT cError
                     ).

         ERROR-STATUS:ERROR = NO.
         LEAVE blkGenerateBrowsers.
       END.
       ELSE IF cNewObjectName > "" THEN
          ASSIGN cNameBrowser = cNewObjectName + (IF cNewObjectExt > "" THEN "." ELSE "") + cNewObjectExt.                 
                      

      ASSIGN
        cLogMessage = "DataObject":U
          + CHR(10) + "----------":U
          + CHR(10) + "Name : ":U                               + cNameDataObject
          + CHR(10)                                             
          + CHR(10) + "Browse":U                                
          + CHR(10) + "------":U                                
          + CHR(10) + "Name : ":U                               + cNameBrowser
          + CHR(10) + "Module : ":U                             + cBrowseModule
          + CHR(10) + "ObjectType : ":U                         + cBrowseObjectType
          + CHR(10) + "Number of Fields : ":U                   + IF iBrowseNumFields = ? THEN "" ELSE STRING(iBrowseNumFields)
          + CHR(10) + "Use DataObject Fields : ":U              + IF lBrowseFromDataObject = ? THEN "" ELSE STRING(lBrowseFromDataObject)
          + CHR(10) + "Delete contained DataField instances : " + IF lBrowseDeleteInstances = ? THEN "" ELSE STRING(lBrowseDeleteInstances)
          + CHR(10) + "Use DataObject Field Order : "           + IF lUseSDOFieldOrderForBrowser = ? THEN "" ELSE STRING(lUseSDOFieldOrderForBrowser)
          .
      DYNAMIC-FUNCTION("logTheError":U
                      ,INPUT plRunSilent
                      ,INPUT cLogDescription
                      ,INPUT "Generating Browse":U
                      ,INPUT "Settings":U
                      ,INPUT "MESSAGE":U
                      ,INPUT cLogMessage
                      ).
      RUN generateVisualObject IN ghRepositoryDesignManager
                              (INPUT  cBrowseObjectType             /*pcObjectType              */
                              ,INPUT  cNameBrowser                  /*pcObjectName              */
                              ,INPUT  cBrowseModule                 /*pcModuleCode              */
                              ,INPUT  "{&DEFAULT-RESULT-CODE}":U    /*pcResultCode              */
                              ,INPUT  cNameDataObject               /*pcDataObjectName          */
                              ,INPUT  cNameTable                    /*pcNameTable               */
                              ,INPUT  cNameDatabase                 /*pcNameDatabase            */
                              ,INPUT  iBrowseNumFields              /*piMaxObjectFields         */
                              ,INPUT  ?                             /*piMaxFieldsPerColumn      */
                              ,INPUT  lBrowseFromDataObject         /*plUseSDOFields            */
                              ,INPUT  cDataObjectFieldList          /* List of DataObject Fields */
                              ,INPUT  lBrowseDeleteInstances        /*plDeleteExistingInstances */
                              ,INPUT  (IF lUseSDOFieldOrderForBrowser THEN "SDO":U ELSE cDataObjectFieldSequence) /*pcFieldSequence*/
                              ,INPUT  lUseSDOFieldOrderForBrowser   /*pllUseSDOFieldOrder */
                              ,OUTPUT dSmartobjectObj               /*pdSmartobjectObj          */
                              ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U
        THEN DO:
          DYNAMIC-FUNCTION("logTheError":U
                          ,INPUT plRunSilent
                          ,INPUT cLogDescription
                          ,INPUT "Generating Browse":U
                          ,INPUT "ERROR!"
                          ,INPUT "ERROR":U
                          ,INPUT RETURN-VALUE
                          ).
          ASSIGN
            cErrorStatus = cErrorStatus
                         + (IF cErrorStatus <> "":U THEN ",":U ELSE "":U)
                         + "Browse":U
                         .
          ERROR-STATUS:ERROR = NO.
          LEAVE blkGenerateBrowsers.
        END. /* error */
        ELSE
          DYNAMIC-FUNCTION("logTheError":U
                          ,INPUT plRunSilent
                          ,INPUT cLogDescription
                          ,INPUT "Generating Browse":U
                          ,INPUT "Completed":U
                          ,INPUT "MESSAGE":U
                          ,INPUT "Generation completed.":U
                          ).

    END.    /* generate browses */

    IF lGenerateViewers
    THEN
    blkGenerateViewers:
    DO:

      IF LOOKUP("DataObject":U,cErrorStatus) <> 0
      OR LOOKUP("DataFields":U,cErrorStatus) <> 0
      THEN DO:
        ASSIGN
          cLogMessage = "":U
          cLogMessage = (IF LOOKUP("DataFields":U,cErrorStatus) <> 0
                         THEN "DataFields generation failed. ":U
                         ELSE "":U
                        )
                      + (IF cLogMessage <> "":U THEN CHR(10) ELSE "":U)
                      + (IF LOOKUP("DataObject":U,cErrorStatus) <> 0
                         THEN "DataObject generation failed. ":U
                         ELSE "":U
                        ).
        DYNAMIC-FUNCTION("logTheError":U
                        ,INPUT plRunSilent
                        ,INPUT cLogDescription
                        ,INPUT "Generating Viewer":U
                        ,INPUT "Cancelled":U
                        ,INPUT "INFORMATION":U
                        ,INPUT cLogMessage
                        ).
        ASSIGN
          cErrorStatus = cErrorStatus
                       + (IF cErrorStatus <> "":U THEN ",":U ELSE "":U)
                       + "Viewer":U
                       .
        LEAVE blkGenerateViewers.
      END.

      IF glCancelJob
      THEN LEAVE.

      DYNAMIC-FUNCTION("logTheError":U
                      ,INPUT plRunSilent
                      ,INPUT cLogDescription
                      ,INPUT "Generating Viewer":U
                      ,INPUT "Started":U
                      ,INPUT "MESSAGE":U
                      ,INPUT "Generation started.":U
                      ).
      /* Run prepareObject API for viewer object allowing system wide customization of name */
       ASSIGN cNewObjectName = ""
              cNewObjectExt  = ""
              cError         = "".
       cError = DYNAMIC-FUNCTION("prepareObjectName":U in hRepDesignManager,
                                          cNameViewer,              /*Suggested Name */
                                          "{&DEFAULT-RESULT-CODE}",  /* Result Code */
                                          cViewerSuffix,             /* Additional string - suffix */
                                          "DEFAULT":U,               /* Default or Save */
                                          cViewerObjectType,         /* Object Type */
                                          cNameEntity,               /* Entity */
                                          cViewerModule,             /* Module */
                                          OUTPUT cNewObjectName,     
                                          OUTPUT cNewObjectExt ) .
       IF cError > "" THEN DO:
          DYNAMIC-FUNCTION("logTheError":U
                     ,INPUT plRunSilent
                     ,INPUT cLogDescription
                     ,INPUT "Generating Viewer"
                     ,INPUT "ERROR!":U
                     ,INPUT "ERROR":U
                     ,INPUT cError
                     ).

         ERROR-STATUS:ERROR = NO.
         LEAVE blkGenerateViewers.
       END.
       ELSE IF cNewObjectName > "" THEN
          ASSIGN cNameViewer = cNewObjectName + (IF cNewObjectExt > "" THEN "." ELSE "") + cNewObjectExt.                 

      ASSIGN
        cLogMessage = "DataObject":U
          + CHR(10) + "----------":U
          + CHR(10) + "Name : ":U                               + cNameDataObject
          + CHR(10)                                             
          + CHR(10) + "Viewer":U                                
          + CHR(10) + "------":U                                
          + CHR(10) + "Name : ":U                               + cNameViewer
          + CHR(10) + "Module : ":U                             + cViewerModule
          + CHR(10) + "ObjectType : ":U                         + cViewerObjectType
          + CHR(10) + "Number of Fields : ":U                   + IF iViewerNumFields = ? THEN "" ELSE STRING(iViewerNumFields)
          + CHR(10) + "Fields per Column : ":U                  + IF iViewerFieldsPerColumn = ? THEN "" ELSE STRING(iViewerFieldsPerColumn)
          + CHR(10) + "Use DataObject Fields : ":U              + IF lViewerFromDataObject = ? THEN "" ELSE STRING(lViewerFromDataObject)
          + CHR(10) + "Delete contained DataField instances : " + IF lViewerDeleteInstances = ? THEN "" ELSE STRING(lViewerDeleteInstances)
          + CHR(10) + "Use DataObject Field Order : "           + IF lUseSDOFieldOrderForViewer = ? THEN "" ELSE STRING(lUseSDOFieldOrderForViewer)
          .

      DYNAMIC-FUNCTION("logTheError":U
                      ,INPUT plRunSilent
                      ,INPUT cLogDescription
                      ,INPUT "Generating Viewer":U
                      ,INPUT "Settings":U
                      ,INPUT "MESSAGE":U
                      ,INPUT cLogMessage
                      ).

      RUN generateVisualObject IN ghRepositoryDesignManager
                              (INPUT  cViewerObjectType           /*pcObjectType              */
                              ,INPUT  cNameViewer                 /*pcObjectName              */
                              ,INPUT  cViewerModule               /*pcModuleCode              */
                              ,INPUT  "{&DEFAULT-RESULT-CODE}":U  /*pcResultCode              */
                              ,INPUT  cNameDataObject             /*pcDataObjectName          */
                              ,INPUT  cNameTable                  /*pcNameTable               */
                              ,INPUT  cNameDatabase               /*pcNameDatabase            */
                              ,INPUT  iViewerNumFields            /*piMaxObjectFields         */
                              ,INPUT  iViewerFieldsPerColumn      /*piMaxFieldsPerColumn      */
                              ,INPUT  lViewerFromDataObject       /*plUseSDOFields            */
                              ,INPUT  cDataObjectFieldList       /* List of DataObject Fields */
                              ,INPUT  lViewerDeleteInstances      /*plDeleteExistingInstances */
                              ,INPUT  (IF lUseSDOFieldOrderForViewer THEN "SDO":U ELSE cDataObjectFieldSequence) /*pcFieldSequence*/
                              ,INPUT  lUseSDOFieldOrderForViewer  /*pllUseSDOFieldOrder */
                              ,OUTPUT dSmartobjectObj             /*pdSmartobjectObj          */
                              ) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U
      THEN DO:
        DYNAMIC-FUNCTION("logTheError":U
                        ,INPUT plRunSilent
                        ,INPUT cLogDescription
                        ,INPUT "Generating Viewer":U
                        ,INPUT "ERROR!"
                        ,INPUT "ERROR":U
                        ,INPUT RETURN-VALUE
                        ).
        ASSIGN
          cErrorStatus = cErrorStatus
                       + (IF cErrorStatus <> "":U THEN ",":U ELSE "":U)
                       + "Viewer":U
                       .
        ERROR-STATUS:ERROR = NO.
        LEAVE blkGenerateViewers.
      END. /* error */
      ELSE
        DYNAMIC-FUNCTION("logTheError":U
                        ,INPUT plRunSilent
                        ,INPUT cLogDescription
                        ,INPUT "Generating Viewer":U
                        ,INPUT "Completed":U
                        ,INPUT "MESSAGE":U
                        ,INPUT "Generation completed.":U
                        ).
    END.    /* generate Viewers */

    IF cErrorStatus = "":U
    THEN
      DYNAMIC-FUNCTION("logTheError":U
                      ,INPUT plRunSilent
                      ,INPUT cLogDescription
                      ,INPUT "Completed":U
                      ,INPUT "":U
                      ,INPUT "MESSAGE":U
                      ,INPUT "Generation completed.":U
                      ).
    ELSE DO:
      DYNAMIC-FUNCTION("logTheError":U
                      ,INPUT plRunSilent
                      ,INPUT cLogDescription
                      ,INPUT "Completed":U
                      ,INPUT "":U
                      ,INPUT "INFORAMTION":U
                      ,INPUT "Completed with Errors":U
                      ).
      ASSIGN
        lErrorEncountered = YES.
    END.

  END.    /* browse data */

  IF glCancelJob
  THEN
    DYNAMIC-FUNCTION("logTheError":U
                    ,INPUT plRunSilent
                    ,INPUT "Generator":U
                    ,INPUT "Cancelled"
                    ,INPUT "":U
                    ,INPUT "INFORMATION":U
                    ,INPUT "Object generation cancelled at user request.":U
                    ).
  ELSE
  IF lErrorEncountered
  THEN
    DYNAMIC-FUNCTION("logTheError":U
                    ,INPUT plRunSilent
                    ,INPUT "Generator":U
                    ,INPUT "Completed with Errors"
                    ,INPUT "":U
                    ,INPUT "INFORMATION":U
                    ,INPUT "Object generation completed with Errors.":U
                    ).
  ELSE
    DYNAMIC-FUNCTION("logTheError":U
                    ,INPUT plRunSilent
                    ,INPUT "Generator":U
                    ,INPUT "Completed Successful"
                    ,INPUT "":U
                    ,INPUT "MESSAGE":U
                    ,INPUT "Object generation completed.":U
                    ).

/* EOF */
