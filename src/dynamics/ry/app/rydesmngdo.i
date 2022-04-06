/*---------------------------------------------------------------------------------
  File: rydesmngdo.i

  Description:  RDM GenerateDataObject Include

  Purpose:      RDM GenerateDataObject Include

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/12/2002  Author:     Peter Judge

  Update Notes: Created from Template ryteminclu.i

---------------------------------------------------------------------------------*/
    DEFINE VARIABLE iTableOrder                     AS INTEGER              NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer                AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hAttributeTable                 AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hQuery                          AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hFieldBuffer                    AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hFileBuffer                     AS HANDLE               NO-UNDO.
    DEFINE VARIABLE dSmartObjectObj                 AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE cAbsolutePathedName             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cWidgetPoolName                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDatabases                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cTables                         AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDataColumns                    AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cQBTableOptionList              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cQBTableList                    AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cQBJoinCode                     AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cUpdatableColumns               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDataColumnsByTable             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cUpdatableColumnsByTable        AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cAssignList                     AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cBaseQuery                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iFollowCount                    AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iFollowFieldCount               AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cFollowQuery                    AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFollowTables                   AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFollowTableList                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFollowJoinCode                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFollowTableFields              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFollowFields                   AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cAssignedFollowFieldName        AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFollowTableValue               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFollowFieldValue               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cExtentFieldList                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cExtentTempList                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cTempTableDef                   AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cSdoLabel                       AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iExtent                         AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iDatabaseloop                   AS INTEGER              NO-UNDO.
    DEFINE VARIABLE hClassBuffer                    AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hEntityBuffer                   AS HANDLE               NO-UNDO.
    define variable cError as character no-undo.
    define variable cNewObjectName as character no-undo.
    define variable cNewObjectExt as character no-undo.
    define variable cDataSourceClasses as character no-undo.
    
    DEFINE BUFFER bttDataObjectField FOR ttDataObjectField.

    /* The editor is used for creating the SDO .i file. */
    DEFINE VARIABLE edCodeEditor AS CHARACTER 
        VIEW-AS EDITOR
        SCROLLBAR-VERTICAL
        LARGE
        SIZE 200 BY 20 
        FONT 2
        NO-UNDO .

    DEFINE FRAME frCodeEditor
        edCodeEditor        AT ROW 1 COL 1 NO-LABEL
        WITH NO-BOX SIZE 205 BY 25.

    DEFINE QUERY qryField FOR ttDataObjectField.

    EMPTY TEMP-TABLE ttStoreAttribute.
    EMPTY TEMP-TABLE ttDataObjectField.
    
    /* Validate input data */
    if pcTableName eq ? or pcTableName eq '':u then
        return error {aferrortxt.i 'AF' '5' '?' '?' '"table name"'}.
        
    if pcDataObjectName eq ? or pcDataObjectName eq '':u then
        return error {aferrortxt.i 'AF' '5' '?' '?' '"data object name"'}.
    
    /* validate the object name */
    cError = DYNAMIC-FUNCTION("prepareObjectName":U in ghDesignManager,
                              pcDataObjectName,
                              '':u, /* pcResultCode */
                              "":U,        /* object string */
                              "SAVE":U,
                              pcObjectTypeCode,
                              "":U,        /* entity name (not req'd) */
                              pcProductModule,
                              output cNewObjectName,
                              output cNewObjectExt   ).
    if cError ne '':u then
        return error cError.
        
    if pcObjectTypeCode eq ? or pcObjectTypeCode eq '':u then
        return error  {aferrortxt.i 'AF' '5' '?' '?' '"object type"'}.
    cDataSourceClasses = dynamic-function('getDataSourceClasses':u in ghDesignManager).
    if not can-do(cDataSourceClasses, pcObjectTypeCode) then
        return error {aferrortxt.i 'RY' '13' '?' '?' "'~~'' + pcObjectTypeCode + '~~''" "'A data source class is one of: ' + cDataSourceClasses"}.
            
    if pcProductModule eq ? or pcProductModule eq '':u then
        return error  {aferrortxt.i 'AF' '5' '?' '?' '"product module"'}.
        
    if pcRootFolder eq ? or pcRootFolder eq '':u then
        return error  {aferrortxt.i 'AF' '5' '?' '?' '"Root Folder"'}.
        
    /** First retrieve all the information we need 
     *  ----------------------------------------------------------------------- **/
    IF pcDatabaseName EQ ? OR pcDatabaseName EQ "":U THEN
        ASSIGN pcDatabaseName = DYNAMIC-FUNCTION("getBufferDbName":U, INPUT pcTableName).

    IF pcDatabaseName EQ ? OR pcDatabaseName EQ "":U THEN
        ASSIGN pcDatabaseName = LDBNAME("dictdb":U).

    ASSIGN cExtentFieldList = "":U
           hQuery           = DYNAMIC-FUNCTION("getSchemaQueryHandle":U IN ghDesignManager,
                                               INPUT  pcDatabaseName,
                                               INPUT  pcTableName,
                                               OUTPUT cWidgetPoolName ).

    IF VALID-HANDLE(hQuery) THEN
    DO:
        ASSIGN hFileBuffer  = hQuery:GET-BUFFER-HANDLE(2)
               hFieldBuffer = hQuery:GET-BUFFER-HANDLE(3).

        hQuery:QUERY-OPEN().

        hQuery:GET-FIRST().
        DO WHILE hFieldBuffer:AVAILABLE:
            CREATE ttDataObjectField.            
            ASSIGN ttDataObjectField.tDatabaseName = pcDatabaseName
                   ttDataObjectField.tTableName    = hFileBuffer:BUFFER-FIELD("_File-name":U):BUFFER-VALUE
                   ttDataObjectField.tDumpName     = hFileBuffer:BUFFER-FIELD("_Dump-name":U):BUFFER-VALUE
                   ttDataObjectField.tFieldName    = hFieldBuffer:BUFFER-FIELD("_Field-name":U):BUFFER-VALUE
                   ttDataObjectField.tFieldOrder   = STRING(hFieldBuffer:BUFFER-FIELD("_Order":U):BUFFER-VALUE,"99999":U)
                   NO-ERROR.
            FIND FIRST gsc_entity_mnemonic WHERE
                       gsc_entity_mnemonic.entity_mnemonic_description = pcTableName
                       NO-LOCK NO-ERROR.
            IF AVAILABLE gsc_entity_mnemonic AND gsc_entity_mnemonic.table_has_object_field AND
               gsc_entity_mnemonic.entity_object_field EQ ttDataObjectField.tFieldName      THEN
                ASSIGN ttDataObjectField.tIsTableObjField = YES.
            ELSE
                ASSIGN ttDataObjectField.tIsTableObjField = NO.
            IF pcTableName                     EQ ttDataObjectField.tTableName AND
               ttDataObjectField.tDatabaseName EQ pcDataBaseName               THEN
                ASSIGN ttDataObjectField.tFieldUpdatable = NOT ttDataObjectField.tIsTableObjField.
            ELSE
                ASSIGN ttDataObjectField.tFieldUpdatable = NO.

            /* Flag all the fields on the requested table as 'keep me' */
            ASSIGN ttDataObjectField.tKeepField = (pcTableName EQ ttDataObjectField.tTableName)
                   cExtentTempList              =  "".
            
            /* Create Extent Fields */
            IF hFieldBuffer:BUFFER-FIELD("_Extent":U):BUFFER-VALUE > 0 THEN
            DO:
                DO iExtent = 1 TO hFieldBuffer:BUFFER-FIELD("_Extent":U):BUFFER-VALUE:
                    IF iExtent > 1 THEN
                    DO:                                       
                      CREATE bttDataObjectField.
                      BUFFER-COPY ttDataObjectField TO bttDataObjectField.
                      ASSIGN bttDataObjectField.tFieldName = ttDataObjectField.tFieldName + STRING(iExtent)
                             bttDataObjectField.tFieldOrder = ttDataObjectField.tFieldOrder + STRING(iExtent,"9999":U).
                    END.            
                    
                    ASSIGN cExtentTempList = cExtentTempList + (IF cExtentTempList > "" THEN ",":U ELSE "")
   	    		                                     + ttDataObjectField.tFieldName + STRING(iExtent) + ",":U
                                                             + ttDataObjectField.tFieldName + "[":U + STRING(iExtent) + "]":U.
                    
                END.    /* loop through extents */
             
                IF cExtentTempList > "" THEN
                   ASSIGN cExtentFieldList  = cExtentFieldList  + (IF cExtentFieldList > "" THEN "," ELSE "")
                                                                + cExtentTempList.
                                                                
                ASSIGN ttDataObjectField.tFieldName =  ttDataObjectField.tFieldName + "1":U.                                                
            END.    /* there are extents for this field */
            hQuery:GET-NEXT().
        END.    /* avail field buffer */
               
        hQuery:QUERY-CLOSE().
        DELETE OBJECT hQuery NO-ERROR.
        ASSIGN hQuery = ?.

        /* Clean up. */
        DELETE WIDGET-POOL cWidgetPoolName.
    END.    /* valid query */
    ELSE
        RETURN ERROR {aferrortxt.i 'AF' '16' '?' '?' "'Unable to create a valid query for table ' + pcTableName + ' in database ' + pcDatabaseName "}.

    /* Now get fid of any extra information. */
    IF plFollowJoins THEN
    DO:
        RUN getTableJoins IN TARGET-PROCEDURE ( INPUT  pcDataBaseName,
                                                INPUT  pcTableName,
                                                INPUT  piFollowDepth,
                                                OUTPUT cFollowQuery,
                                                OUTPUT cFollowTables,
                                                OUTPUT cFollowFields,
                                                OUTPUT cFollowTableList,
                                                OUTPUT cFollowJoinCode    ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    END.    /* follow joins */

    /** Use the relevant fields to determine information for the DataObject.
     *  ----------------------------------------------------------------------- **/
    EMPTY TEMP-TABLE ttTableColumn.

    /* The first counted table is table 2: the requested table pcTableName is always 1. */
    ASSIGN iTableOrder = 2.

    CASE pcFieldSequence:
        WHEN "NAME":U THEN
            OPEN QUERY qryField FOR EACH ttDataObjectField WHERE ttDataObjectField.tKeepField = YES  BY ttDataObjectField.tFieldName.
        OTHERWISE
            OPEN QUERY qryField FOR EACH ttDataObjectField WHERE ttDataObjectField.tKeepField = YES BY ttDataObjectField.tFieldOrder.
    END CASE.   /* field sequence. */

    GET FIRST qryField.
    DO WHILE AVAILABLE ttDataObjectField:
        FIND FIRST ttTableColumn WHERE
                   ttTableColumn.tTableName = ttDataObjectField.tTableName
                   NO-ERROR.
        IF NOT AVAILABLE ttTableColumn THEN
        DO:
            CREATE ttTableColumn.
            ASSIGN ttTableColumn.tTableName    = ttDataObjectField.tTableName
                   ttTableColumn.tDatabaseName = ttDataObjectField.tDatabaseName.
            IF ttTableColumn.tTableName EQ pcTableName THEN
                ASSIGN ttTableColumn.tOrder = 1.
            ELSE
                ASSIGN iTableOrder          = iTableOrder + 1
                       ttTableColumn.tOrder = iTableOrder.                
        END.    /* n/a tablecolumn */

        /* DataColumns */
        ASSIGN cDataColumns = cDataColumns + (IF NUM-ENTRIES(cDataColumns) EQ 0 THEN "":U ELSE ",":U)
                            + ttDataObjectField.tFieldName.

        IF ttDataObjectField.tFieldUpdatable AND NOT CAN-DO(cUpdatableColumns, ttDataObjectField.tFieldName) THEN
            ASSIGN cUpdatableColumns = cUpdatableColumns + (IF NUM-ENTRIES(cUpdatableColumns) EQ 0 THEN "":U ELSE ",":U)
                                     + ttDataObjectField.tFieldName.

        /* DataColumns - for creating the ByTable list */
        IF NOT CAN-DO(ttTableColumn.tDataColumns, ttDataObjectField.tFieldName) THEN
            ASSIGN ttTableColumn.tDataColumns = ttTableColumn.tDataColumns + (IF NUM-ENTRIES(ttTableColumn.tDataColumns) EQ 0 THEN "":U ELSE ",":U)
                                              + ttDataObjectField.tFieldName.
                                                                                                                                                        
        /* UpdatableColumns - for creating the ByTable list */
        IF ttDataObjectField.tFieldUpdatable AND NOT CAN-DO(ttTableColumn.tUpdatableColumns, ttDataObjectField.tFieldName) THEN
           ASSIGN ttTableColumn.tUpdatableColumns = ttTableColumn.tUpdatableColumns + (IF NUM-ENTRIES(ttTableColumn.tUpdatableColumns) EQ 0 THEN "":U ELSE ",":U)
                                                  + ttDataObjectField.tFieldName.
        
        /* Create entry in the SDO .i file. */
        /* Check if field is part of an extent */
        IF LOOKUP(ttDataObjectField.tFieldName,cExtentFieldList) > 0 THEN
            edCodeEditor:INSERT-STRING("  FIELD " + ttDataObjectField.tFieldName + " LIKE "+ ttDataObjectField.tTableName + ".":U 
                                       + ENTRY(LOOKUP(ttDataObjectField.tFieldName,cExtentFieldList) + 1,cExtentFieldList)).
        ELSE
            edCodeEditor:INSERT-STRING("  FIELD " + ttDataObjectField.tFieldName + " LIKE " + ttDataObjectField.tTableName + ".":U + ttDataObjectField.tFieldName).

        IF NOT plSuppressValidation THEN
            edCodeEditor:INSERT-STRING(" VALIDATE ~~ ":U).

        edCodeEditor:INSERT-STRING("  ~n ":U).

        GET NEXT qryField.
    END.    /* field */

    /** Build the TT of all attribute values, so that we only do one A/S hit.
     *  ----------------------------------------------------------------------- **/
    FOR EACH ttTableColumn BY ttTableColumn.tOrder:
        IF NOT CAN-DO(cDatabases, ttTableColumn.tDatabaseName) THEN
            ASSIGN cDatabases = cDatabases + (IF NUM-ENTRIES(cDatabases) EQ 0 THEN "":U ELSE ",":U) + ttTableColumn.tDatabaseName.

        /* Store tables */
        ASSIGN cTables = cTables + (IF NUM-ENTRIES(cTables) EQ 0 THEN "":U ELSE ",":U)
                       + DYNAMIC-FUNCTION("getQualifiedTableName":U IN ghDesignManager, INPUT ttTableColumn.tDatabaseName, INPUT ttTableColumn.tTableName).

        ASSIGN cDataColumnsByTable      = (IF NUM-ENTRIES(cDataColumnsByTable, ";":U) EQ 0 THEN "":U ELSE ";":U)
                                        + cDataColumnsByTable + (IF NUM-ENTRIES(cDataColumnsByTable) EQ 0 THEN "":U ELSE ",":U)
                                        + ttTableColumn.tDataColumns
               cUpdatableColumnsByTable = (IF NUM-ENTRIES(cUpdatableColumnsByTable, ";":U) EQ 0 THEN "":U ELSE ";":U)
                                        + cUpdatableColumnsByTable + (IF NUM-ENTRIES(cUpdatableColumnsByTable) EQ 0 THEN "":U ELSE ",":U)
                                        + ttTableColumn.tUpdatableColumns
                 .
        IF ttTableColumn.tOrder EQ 1 THEN
            ASSIGN cBaseQuery = " FOR EACH ":U
                              + DYNAMIC-FUNCTION("getQualifiedTableName":U IN ghDesignManager,
                                                 INPUT ttTableColumn.tDatabaseName, INPUT ttTableColumn.tTableName)
                              + " NO-LOCK ":U.
        ELSE        
            ASSIGN cBaseQuery = cBaseQuery
                              + ", EACH ":U
                              + DYNAMIC-FUNCTION("getQualifiedTableName":U IN ghDesignManager,
                                                 INPUT ttTableColumn.tDatabaseName, INPUT ttTableColumn.tTableName)                              
                              + " WHERE ":U
                              + ttTableColumn.tWhereClause
                              + " NO-LOCK ":U.

        ASSIGN cQBTableList = cQBTableList + (IF NUM-ENTRIES(cQBTableList) > 0 THEN ',':U ELSE '':U) + 
                              ttTableColumn.tDatabaseName + '.':U + ttTableColumn.tTableName.
    END.    /* ordered tables. */

    IF plFollowJoins AND cFollowQuery <> "":U THEN
    DO:
        /* Add new fields to the SDO's include File */
        DO iFollowCount = 1 TO NUM-ENTRIES(cFollowTables):
            ASSIGN cFollowTableValue  = ENTRY(iFollowCount, cFollowTables)
                   cFollowTableFields = ENTRY(iFollowCount, cFollowFields, ";":U)
                   cQBTableOptionList = cQBTableOptionList + ",FIRST":U.

            IF cFollowTableFields = "":U THEN
                cAssignList = cAssignList + ";":U.
            ELSE
                DO iFollowFieldCount = 1 TO NUM-ENTRIES(cFollowTableFields):
                    ASSIGN cFollowFieldValue = ENTRY(iFollowFieldCount,cFollowTableFields).
                    IF INDEX(cDataColumns,cFollowFieldValue) > 0 THEN
                        ASSIGN cAssignedFollowFieldName = cFollowFieldValue + "-":U + STRING(getDupFieldCount(cDataColumns,cFollowFieldValue) + 1).
                    ELSE
                        ASSIGN cAssignedFollowFieldName = cFollowFieldValue.
    
                    ASSIGN cDataColumns = cDataColumns + ",":U + cAssignedFollowFieldName.
    
                    /* Create entry in the SDO .i file. */
                    edCodeEditor:INSERT-STRING("  FIELD " + cAssignedFollowFieldName
                                               + " LIKE " + cFollowTableValue + ".":U + cFollowFieldValue).
    
                    IF NOT plSuppressValidation THEN
                        edCodeEditor:INSERT-STRING(" VALIDATE ~~ ":U).
    
                    edCodeEditor:INSERT-STRING("  ~n ":U).
    
                    IF cAssignedFollowFieldName <> cFollowFieldValue THEN
                    DO:
                        IF cAssignList = "":U THEN
                            ASSIGN cAssignList = FILL(";":U,NUM-ENTRIES(cFollowTables)).
    
                        IF ENTRY(iFollowCount + 1, cAssignList, ";":U) = "":U THEN
                            ENTRY(iFollowCount + 1, cAssignList, ";":U) = cAssignedFollowFieldName + ",":U
                                                                        + cFollowFieldValue.
                        ELSE 
                            ENTRY(iFollowCount + 1, cAssignList, ";":U) = ENTRY(iFollowCount + 1, cAssignList, ";":U)
                                                                      + ",":U + cAssignedFollowFieldName
                                                                      + ",":U + cFollowFieldValue.
    
                        ENTRY(iFollowFieldCount, cFollowTableFields) = cAssignedFollowFieldName.
                    END.    /* assigned follow field <> follow field */
                END.    /* loop through follow fields */

            ASSIGN ENTRY(iFollowCount, cFollowFields, ";":U) = cFollowTableFields.
            
            /* Add the new fields */
            ASSIGN cFollowFieldValue        = ENTRY(iFollowCount,cFollowFields,";":U)
                   cDataColumnsByTable      = cDataColumnsByTable      + ";":U + cFollowFieldValue
                   /* We don't want any of the linked fields to be updateable */
                   cUpdatableColumnsByTable = cUpdatableColumnsByTable + ";":U
                   /* Add the new tables */
                   cTables = cTables + (IF NUM-ENTRIES(cTables) EQ 0 THEN "":U ELSE ",":U) + cFollowTableValue.
        END.    /* loop through the tables to follow */

        /* Add the new query */
        ASSIGN cBaseQuery = cBaseQuery + ", ":U + cFollowQuery
               cQBTableList = cQBTableList + ",":U + cFollowTableList
               cQBJoinCode = IF cFollowJoinCode NE "":U THEN ("?":U + CHR(5) + cFollowJoinCode) ELSE "":U.
    END.    /* follow joins is yes and we have something to follow */

    /* Lastly, add INDEXED-REPOSITION keyworkd in base query */
    IF INDEX(cBaseQuery,"INDEXED-REPOSITION":U) = 0 THEN
        ASSIGN cBaseQuery = cBaseQuery + " INDEXED-REPOSITION":U.

    IF cExtentFieldList <> "":U THEN 
    DO:
        IF cAssignList <> "":U THEN
            IF NUM-ENTRIES(cAssignList,";":U) > 1 THEN
                ENTRY(1,cAssignList,";":U) = cExtentFieldList
                                           + (IF ENTRY(1, cAssignList, ";":U) <> "":U THEN ",":U + ENTRY(1, cAssignList, ";":U) ELSE "":U).
            ELSE 
                ASSIGN cAssignList = cExtentFieldList
                                   + ",":U + cAssignList.
        ELSE
            ASSIGN cAssignList = cExtentFieldList.
    END.    /* extent field list has something */

    /* Save SDO include file. */
    IF pcRootFolder EQ "/":U OR pcRootFolder EQ "~\":U THEN
        ASSIGN FILE-INFO:FILE-NAME = pcDataObjectRelativePath.
    ELSE
        ASSIGN FILE-INFO:FILE-NAME = pcRootFolder + pcDataObjectRelativePath.

    IF FILE-INFO:FULL-PATHNAME EQ ? THEN
    DO:
        IF plCreateMissingFolder THEN
        DO:
            IF NOT DYNAMIC-FUNCTION("createFolder":U IN gshGenManager, INPUT pcRootFolder + pcDataObjectRelativePath) THEN
                RETURN ERROR {aferrortxt.i 'AF' '19' '?' '?' "''" "'unable to create folder: ' + pcRootFolder + pcDataObjectRelativePath"}.
        END.    /* create the folder */
        ELSE
            RETURN ERROR {aferrortxt.i 'AF' '19' '?' '?' "''" "'folder does not exist: ' + pcRootFolder + pcDataObjectRelativePath"}.
    END.    /* folder doesn't exist */

    edCodeEditor:SAVE-FILE(pcRootFolder + pcDataObjectRelativePath + pcDataObjectName + ".i":U) IN FRAME frCodeEditor.
    
    EMPTY TEMP-TABLE ttStoreAttribute.

    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "DbNames":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = cDatabases.

    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "Tables":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = cTables.
    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "PhysicalTables":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = cTables.

    IF pcDatabaseName EQ "temp-db":U THEN
    DO:
        CREATE ttStoreAttribute.
        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
               ttStoreAttribute.tAttributeParentObj = 0
               ttStoreAttribute.tAttributeLabel     = "TempTables":U
               ttStoreAttribute.tConstantValue      = NO
               ttStoreAttribute.tCharacterValue     = cTables.  
        DO iDatabaseLoop = 1 to NUM-ENTRIES(cTables):
            ASSIGN cTempTableDef = cTempTableDef + (IF cTempTableDef = "" THEN "" ELSE CHR(3))
                                 + ENTRY(iDatabaseLoop,cTables) + " T ? NO-UNDO temp-db " + ENTRY(iDatabaseLoop,cTables).
        END.    /* loop through tables */
        
        CREATE ttStoreAttribute.       
        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U    
               ttStoreAttribute.tAttributeParentObj = 0
               ttStoreAttribute.tAttributeLabel     = "QueryTempTableDefinitions":U
               ttStoreAttribute.tConstantValue      = NO
               ttStoreAttribute.tCharacterValue     = cTempTableDef.
    END.    /* DB name is the TEMP-DB */
           

    IF cUpdatableColumns NE "":U THEN
    DO:
        /* UpdatableColumns */
        CREATE ttStoreAttribute.
        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
               ttStoreAttribute.tAttributeParentObj = 0
               ttStoreAttribute.tAttributeLabel     = "UpdatableColumns":U
               ttStoreAttribute.tConstantValue      = NO
               ttStoreAttribute.tCharacterValue     = cUpdatableColumns.

        /* UpdatableColumnsByTable */
        CREATE ttStoreAttribute.
        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
               ttStoreAttribute.tAttributeParentObj = 0
               ttStoreAttribute.tAttributeLabel     = "UpdatableColumnsByTable":U
               ttStoreAttribute.tConstantValue      = NO
               ttStoreAttribute.tCharacterValue     = cUpdatableColumnsByTable.
    END.    /* updateable columns */

    /* DataColumns */
    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "DataColumns":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = cDataColumns.

    /* DataColumnsByTable */
    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "DataColumnsByTable":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = cDataColumnsByTable.

    /* Assign List */
    IF cAssignList NE "":U THEN
    DO:
        CREATE ttStoreAttribute.
        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
               ttStoreAttribute.tAttributeParentObj = 0
               ttStoreAttribute.tAttributeLabel     = "AssignList":U
               ttStoreAttribute.tConstantValue      = NO
               ttStoreAttribute.tCharacterValue     = cAssignList.
    END.    /* ASsign List <> '' */

    /* Base Query */
    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "BaseQuery":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = cBaseQuery.

    /* Write Table Options for QueryBuilder */
    IF NUM-ENTRIES(cFollowTables) > 0 THEN
    DO:
        CREATE ttStoreAttribute.
        ASSIGN ttStoreAttribute.tAttributeParent      = "MASTER":U
               ttStoreAttribute.tAttributeParentObj   = 0
               ttStoreAttribute.tAttributeLabel       = "QueryBuilderTableOptionList":U
               ttStoreAttribute.tConstantValue        = NO
               ttStoreAttribute.tCharacterValue       = cQBTableOptionList.
    END.  /* If there are joins */

    /* Write Table Options for JoinCode */
    IF NUM-ENTRIES(cQBJoinCode,CHR(5)) > 0 THEN
    DO:
        CREATE ttStoreAttribute.
        ASSIGN ttStoreAttribute.tAttributeParent      = "MASTER":U
               ttStoreAttribute.tAttributeParentObj   = 0
               ttStoreAttribute.tAttributeLabel       = "QueryBuilderJoinCode":U
               ttStoreAttribute.tConstantValue        = NO
               ttStoreAttribute.tCharacterValue       = cQBJoinCode.
    END.  /* If there is join code */

    /* Write Tablelist for QueryBuilder */
    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "QueryBuilderTableList":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = IF pcDatabaseName = "temp-db" 
                                                  THEN REPLACE(cQBTableList,"temp-db":U,"Temp-Tables":U) ELSE cQBTableList.

    /* Write Options for QueryBuilder */
    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "QueryBuilderOptionList":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = "NO-LOCK INDEXED-REPOSITION":U.

    /* pcAppServerPartition */
    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "AppService":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = pcAppServerPartition.
    
    /* pcLogicProcedureName */
    if pcLogicProcedureName ne ? and pcLogicProcedureName ne '':u then
    do:
        /* To ensure data logic procedures created in a product module
	       without a relative path is still abe to run */
        IF TRIM(pcDataLogicRelativePath) = "/":U  OR
           TRIM(pcDataLogicRelativePath) = "~\":U THEN
            ASSIGN pcDataLogicRelativePath = "":U.

        CREATE ttStoreAttribute.
        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
               ttStoreAttribute.tAttributeParentObj = 0
               ttStoreAttribute.tAttributeLabel     = "DataLogicProcedure ":U
               ttStoreAttribute.tConstantValue      = NO
               ttStoreAttribute.tCharacterValue     = pcDataLogicRelativePath + pcLogicProcedureName.
    end.
               
    /* Set the Label of the SDO. This is used for resolving menu conflicts.
       Get the value of the Label from the Entity Mnemonic cache. If it cannot
       be found there for some reason, use that table name. If that is not available,
       then use the SDO's name.
     */
    if valid-handle(gshGenManager) then
    do:
        assign hEntityBuffer = dynamic-function("getEntityCacheBuffer":U in gshGenManager,
                                                input "":U, input pcTableName).
        hEntityBuffer:find-first(" WHERE ":U + hEntityBuffer:NAME 
                                 + ".entity_mnemonic_description = ":U + quoter(pcTableName) ) no-error.
        if valid-handle(hEntityBuffer) and hEntityBuffer:available then
            assign cSdoLabel = hEntityBuffer:buffer-field("entity_mnemonic_short_desc":U):buffer-value.
        else
            assign cSdoLabel = pcTableName.                                 
    end.    /* valid gen manager */
    else
        assign cSdoLabel = pcTableName.
        
    IF LENGTH(cSdoLabel) GT 1 THEN
        ASSIGN cSdoLabel = CAPS(SUBSTRING(cSdoLabel,1,1)) + SUBSTRING(cSdoLabel,2) NO-ERROR.
    
    IF cSdoLabel EQ "":U OR cSdoLabel EQ ? THEN
       ASSIGN cSdoLabel = pcDataObjectName.
    
    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "Label":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = cSdoLabel.

    ASSIGN hAttributeBuffer = BUFFER ttStoreAttribute:HANDLE
           hAttributeTable  = ?.

    /* Get rid of any attribute values that match those at the Class level. */
    DYNAMIC-FUNCTION("cleanStoreAttributeValues":U IN TARGET-PROCEDURE,
                     INPUT "":U,              /* pcObjectName*/
                     INPUT pcObjectTypeCode,
                     INPUT "CLASS":U,
                     INPUT hAttributeBuffer   ).
        
    RUN insertObjectMaster IN ghDesignManager ( INPUT  pcDataObjectName,               /* pcObjectName         */
                                                INPUT  pcResultCode,                   /* pcResultCode         */
                                                INPUT  pcProductModule,                /* pcProductModuleCode  */
                                                INPUT  pcObjectTypeCode,               /* pcObjectTypeCode     */
                                                INPUT  pcObjectTypeCode + " for ":U + pcTableName,     /* pcObjectDescription  */
                                                INPUT  "":U,                           /* pcObjectPath         */
                                                INPUT  "":U,                           /* pcSdoObjectName      */
                                                INPUT  "":U,                           /* pcSuperProcedureName */
                                                INPUT  NO,                             /* plIsTemplate         */
                                                INPUT  NO,                             /* plIsStatic           */
                                                INPUT  "":U,                           /* pcPhysicalObjectName */
                                                INPUT  NO,                             /* plRunPersistent      */
                                                INPUT  "":U,                           /* pcTooltipText        */
                                                INPUT  "":U,                           /* pcRequiredDBList     */
                                                INPUT  "":U,                           /* pcLayoutCode         */
                                                INPUT  hAttributeBuffer,
                                                INPUT  TABLE-HANDLE hAttributeTable,
                                                OUTPUT dSmartObjectObj                           ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    
    /* We need to delete old attribute values before assigning new ones - this is
     * to fix issue #5494 */
    IF dSmartObjectObj <> 0 THEN 
    DO:
        EMPTY TEMP-TABLE ttStoreAttribute.

        ASSIGN hClassBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN gshRepositoryManager,
                                               INPUT pcObjectTypeCode ).
        IF VALID-HANDLE(hClassBuffer) AND hClassBuffer:AVAILABLE THEN
            ASSIGN hClassBUffer = hClassBuffer:BUFFER-FIELD("ClassBufferHandle":U):BUFFER-VALUE.

        /* UpdatableColumns */
        IF cUpdatableColumns = "":U THEN
        DO:
            CREATE ttStoreAttribute.
            ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                   ttStoreAttribute.tAttributeParentObj = dSmartObjectObj
                   ttStoreAttribute.tAttributeLabel     = "UpdatableColumns":U.
            /* UpdatableColumnsByTable */
            CREATE ttStoreAttribute.
            ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                   ttStoreAttribute.tAttributeParentObj = dSmartObjectObj
                   ttStoreAttribute.tAttributeLabel     = "UpdatableColumnsByTable":U.
        END.    /* updateable columns */

        /* Assign List */
        IF cAssignList = "":U THEN
        DO:
            CREATE ttStoreAttribute.
            ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                   ttStoreAttribute.tAttributeParentObj = dSmartObjectObj
                   ttStoreAttribute.tAttributeLabel     = "AssignList":U.
        END.    /* Assign List <> '' */

        /* pcAppServerPartition */
        IF pcAppServerPartition = "":U OR
          ( VALID-HANDLE(hClassBuffer:BUFFER-FIELD("AppService":U)) AND 
            hClassBuffer:BUFFER-FIELD("AppService":U):INITIAL EQ pcAppServerPartition) THEN
        DO:
            CREATE ttStoreAttribute.
            ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                   ttStoreAttribute.tAttributeParentObj = dSmartObjectObj
                   ttStoreAttribute.tAttributeLabel     = "AppService":U.
        END.    /* AppService exists */

        IF CAN-FIND(FIRST ttStoreAttribute) THEN
        DO:
            ASSIGN hAttributeBuffer = BUFFER ttStoreAttribute:HANDLE
                   hAttributeTable  = ?.
            
            RUN removeAttributeValues IN ghDesignManager ( INPUT  hAttributeBuffer,
                                                           INPUT  TABLE-HANDLE hAttributeTable) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
        END.  /* there are attributes to remove */
    END. /* Delete Attributes that might have stayed behind from a prev generation */

    IF plSdoDeleteInstances THEN
    DO:
        RUN removeObjectInstance IN ghDesignManager ( INPUT pcDataObjectName,
                                                      INPUT pcResultCode,
                                                      INPUT "":U,          /* pcInstanceObjectName */
                                                      INPUT "":U,          /* pcInstanceName       */
                                                      INPUT pcResultCode   ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    END.    /* delete existing instances. */

    /* Associate DataFields with SDO */
    IF plCreateSDODataFields THEN 
    DO:
        RUN generateSDOInstances IN ghDesignManager ( INPUT  pcDataObjectName,
                                                      INPUT  pcResultCode,
                                                      INPUT  plSdoDeleteInstances,
                                                      INPUT  cTables          ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    END.    /* generate sdo instances? */    
/* E O F */
