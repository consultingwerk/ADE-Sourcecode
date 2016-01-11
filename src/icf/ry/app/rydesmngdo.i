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
    &IF DEFINED(Server-side) EQ 0 &THEN    
    {dynlaunch.i &PLIP              = "'RepositoryDesignManager'"
                 &iProc             = "'generateDataObject'"
                 &compileStaticCall = NO
                 &mode1  = INPUT &parm1  = pcDatabaseName           &dataType1  = CHARACTER
                 &mode2  = INPUT &parm2  = pcTableName              &dataType2  = CHARACTER
                 &mode3  = INPUT &parm3  = pcDumpName               &dataType3  = CHARACTER
                 &mode4  = INPUT &parm4  = pcDataObjectName         &dataType4  = CHARACTER
                 &mode5  = INPUT &parm5  = pcObjectTypeCode         &dataType5  = CHARACTER
                 &mode6  = INPUT &parm6  = pcProductModule          &dataType6  = CHARACTER               
                 &mode7  = INPUT &parm7  = pcResultCode             &dataType7  = CHARACTER                 
                 &mode8  = INPUT &parm8  = plCreateSDODataFields    &dataType8  = LOGICAL
                 &mode9  = INPUT &parm9  = plSdoDeleteInstances     &dataType9  = LOGICAL
                 &mode10 = INPUT &parm10 = plSuppressValidation     &dataType10 = LOGICAL
                 &mode11 = INPUT &parm11 = plFollowJoins            &dataType11 = LOGICAL
                 &mode12 = INPUT &parm12 = piFollowDepth            &dataType12 = INTEGER
                 &mode13 = INPUT &parm13 = pcFieldSequence          &dataType13 = CHARACTER
                 &mode14 = INPUT &parm14 = pcLogicProcedureName     &dataType14 = CHARACTER
                 &mode15 = INPUT &parm15 = pcDataObjectRelativePath &dataType15 = CHARACTER
                 &mode16 = INPUT &parm16 = pcDataLogicRelativePath  &dataType16 = CHARACTER
                 &mode17 = INPUT &parm17 = pcRootFolder             &dataType17 = CHARACTER
                 &mode18 = INPUT &parm18 = plCreateMissingFolder    &dataType18 = LOGICAL
                 &mode19 = INPUT &parm19 = pcAppServerPartition     &dataType19 = CHARACTER
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.    
    &ELSE /* &IF DEFINED(Server-side) <> 0   */
    DEFINE VARIABLE iDatabaseLoop                   AS INTEGER              NO-UNDO.
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
    DEFINE VARIABLE iExtent                         AS INTEGER              NO-UNDO.
    DEFINE VARIABLE hClassBuffer                    AS HANDLE               NO-UNDO.
    
    DEFINE BUFFER bttDataObjectField FOR ttDataObjectField.

    getFuncLibHandle().
    &SCOPED-DEFINE FRAME-NAME frCodeEditor
    /* The editor is used for creating the SDO .i file. */
    DEFINE VARIABLE edCodeEditor AS CHARACTER 
        VIEW-AS EDITOR
        SCROLLBAR-VERTICAL
        LARGE
        SIZE 200 BY 20 
        FONT 2
        NO-UNDO .

    DEFINE FRAME {&FRAME-NAME}
        edCodeEditor        AT ROW 1 COL 1 NO-LABEL
        WITH NO-BOX SIZE 205 BY 25.

    DEFINE QUERY qryField FOR ttDataObjectField.

    EMPTY TEMP-TABLE ttStoreAttribute.
    IF NOT TRANSACTION THEN EMPTY TEMP-TABLE ttDataObjectField. ELSE FOR EACH ttDataObjectField: DELETE ttDataObjectField. END.

    /** First retrieve all the information we need 
     *  ----------------------------------------------------------------------- **/
    IF pcDatabaseName EQ ? OR pcDatabaseName EQ "":U THEN
        ASSIGN pcDatabaseName = DYNAMIC-FUNCTION("getBufferDbName":U, INPUT pcTableName).

    IF pcDatabaseName EQ ? OR pcDatabaseName EQ "":U THEN
        ASSIGN pcDatabaseName = LDBNAME("dictdb":U).
  DO  WITH FRAME {&FRAME-NAME}:

    ASSIGN hQuery = DYNAMIC-FUNCTION("getSchemaQueryHandle":U IN TARGET-PROCEDURE,
                                     INPUT  pcDatabaseName,
                                     INPUT  pcTableName,
                                     OUTPUT cWidgetPoolName ).

    IF VALID-HANDLE(hQuery) THEN
    DO:
        ASSIGN hFileBuffer  = hQuery:GET-BUFFER-HANDLE(2)
               hFieldBuffer = hQuery:GET-BUFFER-HANDLE(3)
               .
        hQuery:QUERY-OPEN().

        hQuery:GET-FIRST().
        DO WHILE hFieldBuffer:AVAILABLE:
            CREATE ttDataObjectField.            
            ASSIGN ttDataObjectField.tDatabaseName = pcDatabaseName
                   ttDataObjectField.tTableName    = hFileBuffer:BUFFER-FIELD("_File-name":U):BUFFER-VALUE
                   ttDataObjectField.tDumpName     = hFileBuffer:BUFFER-FIELD("_Dump-name":U):BUFFER-VALUE
                   ttDataObjectField.tFieldName    = hFieldBuffer:BUFFER-FIELD("_Field-name":U):BUFFER-VALUE
                   ttDataObjectField.tFieldOrder   = hFieldBuffer:BUFFER-FIELD("_Order":U):BUFFER-VALUE
                   .
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
            ASSIGN ttDataObjectField.tKeepField = (pcTableName EQ ttDataObjectField.tTableName).
            
            /* Create Extent Fields */
            IF hFieldBuffer:BUFFER-FIELD("_Extent":U):BUFFER-VALUE > 0 THEN DO:
              DO iExtent = 2 TO hFieldBuffer:BUFFER-FIELD("_Extent":U):BUFFER-VALUE:
                CREATE bttDataObjectField.
                BUFFER-COPY ttDataObjectField TO bttDataObjectField.
                ASSIGN bttDataObjectField.tFieldName = ttDataObjectField.tFieldName + STRING(iExtent).
                cExtentFieldList = IF cExtentFieldList = "":U THEN bttDataObjectField.tFieldName + ",":U + ttDataObjectField.tFieldName + "[":U + STRING(iExtent) + "]":U
                                                              ELSE cExtentFieldList + ",":U + bttDataObjectField.tFieldName + ",":U + ttDataObjectField.tFieldName + "[":U + STRING(iExtent) + "]":U.
              END.
              cExtentFieldList = ttDataObjectField.tFieldName + "1":U + ",":U + ttDataObjectField.tFieldName + "[":U + "1":U + "]":U + ",":U + cExtentFieldList.
              ASSIGN ttDataObjectField.tFieldName = ttDataObjectField.tFieldName + "1":U.
            END.
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
            OPEN QUERY qryField
                FOR EACH ttDataObjectField WHERE ttDataObjectField.tKeepField = YES  BY ttDataObjectField.tFieldName.
        OTHERWISE
            OPEN QUERY qryField
                FOR EACH ttDataObjectField WHERE ttDataObjectField.tKeepField = YES BY ttDataObjectField.tFieldOrder.
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
                   ttTableColumn.tDatabaseName = ttDataObjectField.tDatabaseName
                   .
            IF ttTableColumn.tTableName EQ pcTableName THEN
                ASSIGN ttTableColumn.tOrder = 1.
            ELSE
                ASSIGN iTableOrder          = iTableOrder + 1
                       ttTableColumn.tOrder = iTableOrder
                       .
            /* ttTableColumn.tWhereClause */
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
        IF LOOKUP(ttDataObjectField.tFieldName,cExtentFieldList) > 0 THEN DO: /* Field is an extent */
          edCodeEditor:INSERT-STRING("  FIELD " + ttDataObjectField.tFieldName + " LIKE " + ttDataObjectField.tTableName + ".":U + ENTRY(LOOKUP(ttDataObjectField.tFieldName,cExtentFieldList) + 1,cExtentFieldList)).
        END.
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
        ASSIGN cTables = cTables + (IF NUM-ENTRIES(cTables) EQ 0 THEN "":U ELSE ",":U) + (IF VALID-HANDLE(gFuncLibHdl) THEN db-tbl-name(ttTableColumn.tDatabaseName + ".":U + ttTableColumn.tTableName) ELSE ttTableColumn.tDatabaseName + ".":U + ttTableColumn.tTableName).

        ASSIGN cDataColumnsByTable      = (IF NUM-ENTRIES(cDataColumnsByTable, ";":U) EQ 0 THEN "":U ELSE ";":U)
                                        + cDataColumnsByTable + (IF NUM-ENTRIES(cDataColumnsByTable) EQ 0 THEN "":U ELSE ",":U)
                                        + ttTableColumn.tDataColumns
               cUpdatableColumnsByTable = (IF NUM-ENTRIES(cUpdatableColumnsByTable, ";":U) EQ 0 THEN "":U ELSE ";":U)
                                        + cUpdatableColumnsByTable + (IF NUM-ENTRIES(cUpdatableColumnsByTable) EQ 0 THEN "":U ELSE ",":U)
                                        + ttTableColumn.tUpdatableColumns
                 .
        IF ttTableColumn.tOrder EQ 1 THEN
            ASSIGN cBaseQuery = " FOR EACH ":U + (IF VALID-HANDLE(gFuncLibHdl) THEN db-tbl-name(ttTableColumn.tDatabaseName + ".":U + ttTableColumn.tTableName) ELSE ttTableColumn.tTableName) + " NO-LOCK ":U.
        ELSE        
            ASSIGN cBaseQuery = cBaseQuery
                              + ", EACH ":U + (IF VALID-HANDLE(gFuncLibHdl) THEN db-tbl-name(ttTableColumn.tDatabaseName + ".":U + ttTableColumn.tTableName) ELSE ttTableColumn.tTableName) + " WHERE ":U
                              + ttTableColumn.tWhereClause
                              + " NO-LOCK ":U.

        ASSIGN cQBTableList = cQBTableList + (IF NUM-ENTRIES(cQBTableList) > 0 THEN ',':U ELSE '':U) + 
                              ttTableColumn.tDatabaseName + '.':U + ttTableColumn.tTableName.


    END.    /* ordered tables. */

    IF plFollowJoins
    AND cFollowQuery <> "":U
    THEN DO:
        
      /* Add new fields to the SDO's include File */
      DO iFollowCount = 1 TO NUM-ENTRIES(cFollowTables):

        ASSIGN
          cFollowTableValue  = ENTRY(iFollowCount,cFollowTables)
          cFollowTableFields = ENTRY(iFollowCount,cFollowFields,";":U)
          cQBTableOptionList = cQBTableOptionList + ",FIRST":U.
        
        DO iFollowFieldCount = 1 TO NUM-ENTRIES(cFollowTableFields):
          ASSIGN cFollowFieldValue = ENTRY(iFollowFieldCount,cFollowTableFields).
          IF INDEX(cDataColumns,cFollowFieldValue) > 0 THEN
            ASSIGN cAssignedFollowFieldName = cFollowFieldValue + "-":U + STRING(getDupFieldCount(cDataColumns,cFollowFieldValue) + 1).
          ELSE
            ASSIGN cAssignedFollowFieldName = cFollowFieldValue.
          
          cDataColumns = cDataColumns + ",":U + cAssignedFollowFieldName.
          /* Create entry in the SDO .i file. */
          edCodeEditor:INSERT-STRING("  FIELD " + cAssignedFollowFieldName
                                                + " LIKE " + cFollowTableValue + ".":U + cFollowFieldValue).
  
          IF NOT plSuppressValidation THEN
              edCodeEditor:INSERT-STRING(" VALIDATE ~~ ":U).
  
          edCodeEditor:INSERT-STRING("  ~n ":U).

          IF cAssignedFollowFieldName <> cFollowFieldValue THEN DO:
            IF cAssignList = "":U THEN
              ASSIGN cAssignList = FILL(";":U,NUM-ENTRIES(cFollowTables)).
            IF ENTRY(iFollowCount + 1,cAssignList,";":U) = "":U THEN
              ENTRY(iFollowCount + 1,cAssignList,";":U) = cAssignedFollowFieldName + ",":U + cFollowFieldValue.
            ELSE 
              ENTRY(iFollowCount + 1,cAssignList,";":U) = ENTRY(iFollowCount + 1,cAssignList,";":U) + ",":U + cAssignedFollowFieldName + ",":U + cFollowFieldValue.
            ENTRY(iFollowFieldCount,cFollowTableFields) = cAssignedFollowFieldName.
          END.
        END.
        ASSIGN ENTRY(iFollowCount,cFollowFields,";":U) = cFollowTableFields.
        /* Add the new fields */
        ASSIGN
          cFollowFieldValue = ENTRY(iFollowCount,cFollowFields,";":U).
        ASSIGN
          cDataColumnsByTable      = cDataColumnsByTable      + ";":U + cFollowFieldValue
          cUpdatableColumnsByTable = cUpdatableColumnsByTable + ";":U. /* We don't want any of the linked fields to be updateable */
        /* Add the new tables */
        ASSIGN
          cTables = cTables
                  + (IF NUM-ENTRIES(cTables) EQ 0 THEN "":U ELSE ",":U)
                  + cFollowTableValue.

        /* ***
        For the time we will not need to add the joined tables field's since we are not adding them as instances to the SDO

        /* We also need to generate DataField for the other tables now */
        RUN generateDataFields (INPUT pcDataBaseName,
                                INPUT cFollowTableValue,
                                INPUT pcProductModule,
                                INPUT pcResultCode,
                                INPUT TRUE,              /* plGenerateFromDataObject - was FALSE, but if TRUE will use the passed in fields */
                                INPUT cFollowTableFields /* List of Fields to process */
                                INPUT pcDataObjectName,  /* pcSdoObjectName */
                                INPUT "DataField":U).
           *** */
      END.

      /* Add the new query */
      ASSIGN 
          cBaseQuery = cBaseQuery + ", ":U + cFollowQuery
          cQBTableList = cQBTableList + ",":U + cFollowTableList
          cQBJoinCode = IF cFollowJoinCode NE "":U THEN ("?":U + CHR(5) + cFollowJoinCode) ELSE "":U.

    END.
    
    /* Lastly, add INDEXED-REPOSITION keyworkd in base query */
    IF INDEX(cBaseQuery,"INDEXED-REPOSITION":U) = 0 THEN
      cBaseQuery = cBaseQuery + " INDEXED-REPOSITION":U.

    IF cExtentFieldList <> "":U THEN DO:
      IF cAssignList <> "":U THEN
        IF NUM-ENTRIES(cAssignList,";":U) > 1 THEN
          ENTRY(1,cAssignList,";":U) = cExtentFieldList + (IF ENTRY(1,cAssignList,";":U) <> "":U THEN ",":U + ENTRY(1,cAssignList,";":U) ELSE "":U).
        ELSE 
          cAssignList = cExtentFieldList + ",":U + cAssignList.
      ELSE
        cAssignList = cExtentFieldList.
    END.
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
    END.    /* folder doesnøt exist */

    edCodeEditor:SAVE-FILE(pcRootFolder + pcDataObjectRelativePath + pcDataObjectName + ".i":U) IN FRAME {&FRAME-NAME}.
    
    EMPTY TEMP-TABLE ttStoreAttribute.

    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "DbNames":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = cDatabases
           .
    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "Tables":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = cTables
           .
    IF cUpdatableColumns NE "":U THEN
    DO:
        /* UpdatableColumns */
        CREATE ttStoreAttribute.
        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
               ttStoreAttribute.tAttributeParentObj = 0
               ttStoreAttribute.tAttributeLabel     = "UpdatableColumns":U
               ttStoreAttribute.tConstantValue      = NO
               ttStoreAttribute.tCharacterValue     = cUpdatableColumns
               .
        /* UpdatableColumnsByTable */
        CREATE ttStoreAttribute.
        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
               ttStoreAttribute.tAttributeParentObj = 0
               ttStoreAttribute.tAttributeLabel     = "UpdatableColumnsByTable":U
               ttStoreAttribute.tConstantValue      = NO
               ttStoreAttribute.tCharacterValue     = cUpdatableColumnsByTable
               .
    END.    /* updateable columns */

    /* DataColumns */
    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "DataColumns":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = cDataColumns
           .
    /* DataColumnsByTable */
    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "DataColumnsByTable":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = cDataColumnsByTable
           .
    /* Assign List */
    IF cAssignList NE "":U THEN
    DO:
        CREATE ttStoreAttribute.
        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
               ttStoreAttribute.tAttributeParentObj = 0
               ttStoreAttribute.tAttributeLabel     = "AssignList":U
               ttStoreAttribute.tConstantValue      = NO
               ttStoreAttribute.tCharacterValue     = cAssignList
               .
    END.    /* ASsign List <> '' */

    /* Base Query */
    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "BaseQuery":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = cBaseQuery
           .
    /* Write Table Options for QueryBuilder */
    IF NUM-ENTRIES(cFollowTables) > 0 THEN DO:
      CREATE ttStoreAttribute.
      ASSIGN ttStoreAttribute.tAttributeParent      = "MASTER":U
             ttStoreAttribute.tAttributeParentObj   = 0
             ttStoreAttribute.tAttributeLabel       = "QueryBuilderTableOptionList":U
             ttStoreAttribute.tConstantValue        = NO
             ttStoreAttribute.tCharacterValue       = cQBTableOptionList
             .
    END.  /* If there are joins */

    /* Write Table Options for JoinCode */
    IF NUM-ENTRIES(cQBJoinCode,CHR(5)) > 0 THEN DO:
      CREATE ttStoreAttribute.
      ASSIGN ttStoreAttribute.tAttributeParent      = "MASTER":U
             ttStoreAttribute.tAttributeParentObj   = 0
             ttStoreAttribute.tAttributeLabel       = "QueryBuilderJoinCode":U
             ttStoreAttribute.tConstantValue        = NO
             ttStoreAttribute.tCharacterValue       = cQBJoinCode
             .
    END.  /* If there is join code */
    
    /* Write Tablelist for QueryBuilder */
    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "QueryBuilderTableList":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = cQBTableList
           .

    /* Write Options for QueryBuilder */
    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "QueryBuilderOptionList":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = "NO-LOCK INDEXED-REPOSITION":U
           .
    /* pcAppServerPartition */
    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "AppService":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = pcAppServerPartition
           .
    
    /* To ensure data logic procedures created in a product module
       without a relative path is still abe to run */
    IF TRIM(pcDataLogicRelativePath) = "/":U  OR
       TRIM(pcDataLogicRelativePath) = "~\":U THEN
      pcDataLogicRelativePath = "":U.

    /* pcLogicProcedureName */
    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "DataLogicProcedure ":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = pcDataLogicRelativePath + pcLogicProcedureName
           .
    ASSIGN hAttributeBuffer = BUFFER ttStoreAttribute:HANDLE
           hAttributeTable  = ?.

    /* Get rid of any attribute values that match those at the Class level. */
    DYNAMIC-FUNCTION("cleanStoreAttributeValues":U IN TARGET-PROCEDURE,
                     INPUT "":U,              /* pcObjectName*/
                     INPUT pcObjectTypeCode,
                     INPUT "CLASS":U,
                     INPUT hAttributeBuffer   ).
        
    RUN insertObjectMaster IN TARGET-PROCEDURE ( INPUT  pcDataObjectName,               /* pcObjectName         */
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
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

    /* We need to delete old attribute values before assigning new ones - this is
       to fix issue #5494 */
    IF dSmartObjectObj <> 0 THEN DO:
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
      IF CAN-FIND(FIRST ttStoreAttribute) THEN DO:
        ASSIGN hAttributeBuffer = BUFFER ttStoreAttribute:HANDLE
               hAttributeTable  = ?.

        RUN removeAttributeValues IN TARGET-PROCEDURE ( INPUT  hAttributeBuffer,
                                                        INPUT  TABLE-HANDLE hAttributeTable) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
      END.
    END. /* Delete Attributes that might have stayed behind from a prev generation */

    IF plSdoDeleteInstances THEN
    DO:
        RUN removeObjectInstance IN TARGET-PROCEDURE ( INPUT pcDataObjectName,
                                                       INPUT pcResultCode,
                                                       INPUT "":U,          /* pcInstanceObjectName */

                                   INPUT "":U,          /* pcInstanceName       */
                                   INPUT pcResultCode   ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    END.    /* delete existing instances. */

    /* Associate DataFields with SDO */
    IF plCreateSDODataFields THEN DO:
      RUN generateSDOInstances ( INPUT  pcDataObjectName,
                                 INPUT  pcResultCode,
                                 INPUT  plSdoDeleteInstances,
                                 INPUT  cTables          ) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    END.
  
  END.
    &UNDEFINE FRAME-NAME
    &ENDIF
        
/* E O F */
