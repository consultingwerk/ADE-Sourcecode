/*************************************************************/  
/* Copyright (c) 1984-2006 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: rydesgendf.i

  Description:  Repository Design Manager: generateDataFields() API include file

  Purpose:      This code contains the server-side processing used by the 
                generateDataField() API in the Repository Design Manager. This code
                needed to be moved into a separate include bcause it was blowing the
                Section Editor's 32 limit.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   06/06/2003  Author:     Peter Judge

  Update Notes: Created from scratch.

---------------------------------------------------------------------------------*/ 
    DEFINE VARIABLE cWidgetPoolName             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFieldName                  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFileName                   AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDataFieldName              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cViewAs                     AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDatabaseName               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE hFieldBuffer                AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hFileBuffer                 AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hQuery                      AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hAttributeTable             AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hStoreAttributeBuffer       AS HANDLE               NO-UNDO.
    DEFINE VARIABLE iExtent                     AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iMaxExtent                  AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iDbLoop                     AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iLoop                       AS INTEGER              NO-UNDO.
    DEFINE VARIABLE dDataFieldObj               AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dHeight                     AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dWidth                      AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE cFieldDataType              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFieldFormat                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFieldLabel                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cColumnLabel                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE hSmartDataObject            AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cSDOFieldList               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cExistingTableDb            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iTableCnt                   AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cTable                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cTableFields                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cTableValues                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cError                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cInheritClasses             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cAttrList                   AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cPrimaryField               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cPrimaryValue               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cSecondaryField             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cSecondaryValue             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iPrimaryDataType            AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iAttrLoop                   AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cSchemaField                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE lForceOverride              AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE cNewValue                   AS CHARACTER            NO-UNDO.
    
    define buffer ttObject        for ttObject.

&GLOBAL-DEFINE CLOB-VIEW-AS-PHRASE VIEW-AS EDITOR SIZE 50 BY 5 SCROLLBAR-VERTICAL LARGE

    /* First make sure that we are creating DataFields. */
    IF NOT DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, INPUT pcObjectTypeCode, INPUT "DataField":U) THEN
        RETURN ERROR {aferrortxt.i 'AF' '15' '?' '?' "'the class specified does not inherit from the DataField class.'"}.

    /* Default to all fields. */
    IF pcFieldNames EQ "":U OR pcFieldNames EQ ? THEN
        ASSIGN pcFieldNames = "*":U.

    /* Default to no overrides. */
    IF pcOverrideAttributes EQ ? THEN
        ASSIGN pcOverrideAttributes = "":U.
    
    IF plGenerateFromDataObject THEN
    DO:
        /* Start the SDO and get the values */
        RUN startDataObject IN gshRepositoryManager (INPUT pcSdoObjectName, OUTPUT hSmartDataObject) NO-ERROR.
        IF VALID-HANDLE(hSmartDataObject) THEN
            ASSIGN cSDOFieldList  = DYNAMIC-FUNCTION("getDataColumns":U IN hSmartDataObject) 
                   pcDataBaseName = DYNAMIC-FUNCTION("getDBNames":U IN hSmartDataObject) 
                   pcTableName    = DYNAMIC-FUNCTION("getTables":U IN hSmartDataObject) NO-ERROR.
        
        IF VALID-HANDLE(hSmartDataObject) THEN
            RUN destroyObject IN hSmartDataObject.

        IF VALID-HANDLE(hSmartDataObject) THEN
            DELETE OBJECT hSmartDataObject.
    END. /* generate from DataObject */

    IF pcDatabaseName EQ ? OR pcDatabaseName EQ "":U THEN
        ASSIGN pcDatabaseName = DYNAMIC-FUNCTION("getBufferDbName":U IN ghDesignManager, INPUT pcTableName).
    
    IF pcDatabaseName EQ ? OR pcDatabaseName EQ "":U THEN
        ASSIGN pcDatabaseName = LDBNAME("DICTDB":U).
    
    IF pcDatabaseName EQ ? OR pcDatabaseName EQ "":U THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'Database Name'" pcDatabaseName}.
    
    /* Make sure we're not overwriting an entity imported on another database */
    IF NUM-ENTRIES(pcTableName) <> 0 
    THEN DO:
        do-blk:
        DO iTableCnt = 1 TO NUM-ENTRIES(pcTableName):
            ASSIGN cTable       = ENTRY(iTableCnt, pcTableName)
                   cTableFields = "":U
                   cTableValues = "":U.

            RUN getEntityDetail IN gshGenManager (INPUT  cTable,
                                                  OUTPUT cTableFields,
                                                  OUTPUT cTableValues).
            IF cTableFields <> "":U /* the entity already exists in the db */
            THEN DO:
                ASSIGN cExistingTableDb = ENTRY(LOOKUP("entity_dbname":U, cTableFields, CHR(1)), cTableValues, CHR(1)) NO-ERROR.
                IF cExistingTableDb <> pcDatabaseName THEN
                    ASSIGN cError = cError 
                                  + (IF cError = "":U
                                     THEN CHR(3)
                                     ELSE '~n':U)
                                  + 'Table ' + cTable + ' has already been imported for database ' + cExistingTableDb + '.':U.
            END.
        END.
 
        IF cError <> "":U 
        THEN DO:
            ASSIGN cError = cError + "~nImport aborted.".
            RETURN ERROR {aferrortxt.i 'AF' '40' '' '' "cError"}.
        END.
    END.

    DBNAME-LOOP:
    DO iDbLoop = 1 TO NUM-ENTRIES(pcDatabaseName):
        ASSIGN cDatabaseName = ENTRY(iDbLoop, pcDatabaseName)
               hQuery        = DYNAMIC-FUNCTION("getSchemaQueryHandle":U IN ghDesignManager,
                                                INPUT  cDataBaseName,
                                                INPUT  "*":U,           /* pcTableName */
                                                OUTPUT cWidgetPoolName ).
        IF VALID-HANDLE(hQuery) THEN
        DO:
            /* The query buffer handles are, in order: _DB, _FILE, _FIELD */
            ASSIGN hFileBuffer  = hQuery:GET-BUFFER-HANDLE(2)
                   hFieldBuffer = hQuery:GET-BUFFER-HANDLE(3)
                   NO-ERROR.
    
            hQuery:QUERY-OPEN().
            hQuery:GET-FIRST(NO-LOCK).

            IF NOT hFieldBuffer:AVAILABLE THEN
                RETURN {aferrortxt.i 'AF' '5' '?' '?' "'Table Name'" pcTableName}.
        
            /* For each field in the table, create a DataField - smartobject and object */
            FIELD_LOOP:
            DO WHILE hFieldBuffer:AVAILABLE:
                ASSIGN cFieldName     = hFieldBuffer:BUFFER-FIELD("_Field-Name":U):BUFFER-VALUE
                       iExtent        = hFieldBuffer:BUFFER-FIELD("_Extent":U):BUFFER-VALUE
                       cFileName      = hFileBuffer:BUFFER-FIELD("_File-name":U):BUFFER-VALUE
                       cFieldDataType = hFieldBuffer:BUFFER-FIELD("_Data-Type":U):BUFFER-VALUE
                       cFieldFormat   = hFieldBuffer:BUFFER-FIELD("_Format":U):BUFFER-VALUE.

                /* Only import for specified tables */
                IF NOT CAN-DO(pcTableName, cFileName) THEN
                DO:
                    hQuery:GET-NEXT(NO-LOCK).
                    NEXT FIELD_LOOP.
                END.    /* not in table list */

                /* Only import those fields that are specified in the pcFieldNames parameter. */
                IF NOT CAN-DO(pcFieldNames, cFileName + ".":U + cFieldname) THEN
                DO:
                    hQuery:GET-NEXT(NO-LOCK).
                    NEXT FIELD_LOOP.
                END.    /* not in field list */

                IF iExtent EQ 0 THEN
                    ASSIGN iMaxExtent   = 1
                           cFieldLabel  = hFieldBuffer:BUFFER-FIELD("_Label":U):BUFFER-VALUE
                           cColumnLabel = hFieldBuffer:BUFFER-FIELD("_Col-Label":U):BUFFER-VALUE.
                ELSE
                    ASSIGN iMaxExtent   = iExtent
                           cFieldLabel  = REPLACE(hFieldBuffer:BUFFER-FIELD("_Label":U):BUFFER-VALUE, "&":U, "&&":U) + " &1":U
                           cColumnLabel = REPLACE(hFieldBuffer:BUFFER-FIELD("_Col-Label":U):BUFFER-VALUE, "&":U, "&&":U) + " &1":U.

                DO iLoop = 1 TO iMaxExtent:
                    IF iExtent NE 0 THEN
                        ASSIGN cDataFieldName = cFieldname + STRING(iLoop).
                    ELSE
                        ASSIGN cDataFieldName = cFieldname.

                    /* Check if we only want to include fields from the SDO */
                    IF cSDOFieldList EQ "":U OR CAN-DO(cSDOFieldList, cDataFieldName) THEN                        
                    DO:
                        /** Build the TT of all attribute values, so that we only do one A/S hit.
                         *  ----------------------------------------------------------------------- **/
                        EMPTY TEMP-TABLE ttStoreAttribute.

                        /* The TableName attribute is set to CONSTANT-VALUE = YES for 
                         * this DataField Master because any instances of this datafield
                         * on a dynamic viewer and other containers will take their 
                         * TableName value from the run-time DataSource (SDO).          */
                        CREATE ttStoreAttribute.
                        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                               ttStoreAttribute.tAttributeParentObj = 0
                               ttStoreAttribute.tAttributeLabel     = "TableName":U
                               ttStoreAttribute.tConstantValue      = YES
                               ttStoreAttribute.tCharacterValue     = cFileName.
                        
                        /* We always update the SCHEMA-* attributes since these are defined as the 
                         * value as per the schema. If this is a new DataField, then we also need to update
                         * the non-SCHEMA attributes. We also update the non-SCHEMA attributes but only if
                         * they are the same as the existing schema attributes. This way we can keep the
                         * Repository in synch with the DB meta-schema.                                    */
                        RUN retrieveDesignObject IN ghDesignManager ( INPUT  cFileName + ".":U + cDataFieldName,
                                                                      INPUT  "",  /* Get default  result Codes */
                                                                      OUTPUT TABLE ttObject,
                                                                      OUTPUT TABLE ttPage,
                                                                      OUTPUT TABLE ttLink,
                                                                      OUTPUT TABLE ttUiEvent,
                                                                      OUTPUT TABLE ttObjectAttribute ) NO-ERROR.
                        FIND FIRST ttObject WHERE ttObject.tLogicalObjectName       = cFileName + ".":U + cDataFieldName 
                                              AND ttObject.tContainerSmartObjectObj = 0 NO-ERROR.
                        /* get class if master object doesn't exist */
                        IF NOT CAN-FIND(FIRST ttClassAttribute WHERE ttClassAttribute.tClassname = pcObjectTypeCode) THEN
                            RUN retrieveDesignClass IN ghDesignManager
                                                     ( INPUT  pcObjectTypeCode,
                                                       OUTPUT cInheritClasses,
                                                       OUTPUT TABLE ttClassAttribute,
                                                       OUTPUT TABLE ttUiEvent,
                                                       output table ttSupportedLink         ) NO-ERROR.  
                        ELSE
                        DO:
                            /* No error checking on whether the previous call failed or not.  If it failed, run retrieveDesignClass *
                             * if necessary.  However, clear the error status and return value so they don't confuse us later       */
                            RUN setReturnValue IN gshSessionManager (INPUT "":U).
                            ASSIGN ERROR-STATUS:ERROR = NO.
                        END.

                        ASSIGN cAttrList = "SCHEMA-INITIAL,DefaultValue,_Initial,SCHEMA-FORMAT,FORMAT,,SCHEMA-LABEL,LABEL,,~
                                            SCHEMA-COLUMN-LABEL,ColumnLabel,,SCHEMA-HELP,Help,_Help,SCHEMA-VIEW-AS,ViewAs,_View-As,~
                                            SCHEMA-VALIDATE-EXPRESSION,,_ValExp,SCHEMA-VALIDATE-MESSAGE,,_ValMsg,~
                                            SCHEMA-MANDATORY,Mandatory,_Mandatory,SCHEMA-DECIMALS,,_Decimals,~
                                            SCHEMA-DESCRIPTION,,_Desc,SCHEMA-CASE-SENSITIVE,,_Fld-case,~
                                            SCHEMA-ORDER,,_Order":U.
                       ATTRIBUTE-LOOP:
                       DO iAttrloop = 1 to NUM-ENTRIES(cAttrList) BY 3:
                          ASSIGN cPrimaryField   = TRIM(ENTRY(iAttrloop,cAttrList))
                                 cSecondaryField = TRIM(ENTRY(iAttrloop + 1,cAttrList))
                                 cSchemaField    = TRIM(ENTRY(iAttrloop + 2,cAttrList))
                                 NO-ERROR.
                                 
                          IF cSecondaryField > "" THEN
                             lForceOverride = NOT AVAILABLE ttObject OR CAN-DO(pcOverrideAttributes, cSecondaryField).
                          ELSE
                            lForceOverride = NOT AVAILABLE ttObject .
                            
                          IF cSchemaField > "" THEN
                            cNewValue = hFieldBuffer:BUFFER-FIELD(cSchemaField):BUFFER-VALUE.
                          ELSE DO:
                            IF cSecondaryField = "FORMAT":U THEN
                               cNewValue = cFieldFormat.
                            ELSE IF cSecondaryField = "LABEL":U THEN
                               cNewValue = IF iExtent = 0 THEN cFieldLabel ELSE SUBSTITUTE(cFieldLabel, STRING(iLoop)).
                            ELSE IF cSecondaryField = "ColumnLabel":U THEN
                               cNewValue = IF iExtent = 0 THEN cColumnLabel ELSE SUBSTITUTE(cColumnLabel, STRING(iLoop)).
                          END.
                          
                          IF cSchemaField = "_View-As":U THEN DO:
                             cViewAS = cNewValue.
                             IF cFieldDataType = "CLOB":U THEN
                                cViewAS = "{&CLOB-VIEW-AS-PHRASE}":U.
                          END.
                          
                          /* get the primary field value */
                          RELEASE ttObjectAttribute.
                          RELEASE ttClassAttribute.
                          IF AVAIL ttObject THEN
                             FIND FIRST ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                                            AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj 
                                                            AND ttObjectAttribute.tAttributeLabel    = cPrimaryField NO-ERROR.
                          IF NOT AVAIL ttObject OR NOT AVAIL ttObjectAttribute THEN                                  
                             FIND FIRST ttClassAttribute WHERE ttClassAttribute.tClassname      = pcObjectTypeCode
                                                           AND ttClassAttribute.tAttributelabel = cPrimaryField NO-ERROR.
                          IF AVAIL ttObjectAttribute THEN
                             ASSIGN cPrimaryValue    = ttObjectAttribute.tAttributeValue
                                    iPrimaryDataType = ttObjectAttribute.tDataType.
                          ELSE IF AVAIL ttClassAttribute THEN
                             ASSIGN cPrimaryValue    = ttClassAttribute.tAttributeValue
                                    iPrimaryDataType = ttClassAttribute.tDataType.
                          ELSE  
                            NEXT ATTRIBUTE-LOOP.

                         /* get the secondary field value */
                          IF cSecondaryField > "" THEN
                          DO:
                             IF AVAIL ttObject THEN
                                FIND FIRST ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                                               AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj 
                                                               AND ttObjectAttribute.tAttributeLabel    = cSecondaryField NO-ERROR.
                             IF NOT AVAIL ttObject OR NOT AVAIL  ttObjectAttribute THEN
                                FIND FIRST ttClassAttribute WHERE ttClassAttribute.tClassname      = pcObjectTypeCode
                                                              AND ttClassAttribute.tAttributelabel = cSecondaryField NO-ERROR.

                             IF AVAIL ttObjectAttribute THEN
                                cSecondaryValue = ttObjectAttribute.tAttributeValue.
                             ELSE IF AVAIL ttClassAttribute THEN
                                cSecondaryValue = ttClassAttribute.tAttributeValue.
                             ELSE
                                cSecondaryValue = "".
                          END.
                          ELSE
                              cSecondaryValue = "".
                          
                          DYNAMIC-FUNCTION("buildDataFieldAttribute":U IN TARGET-PROCEDURE,
                                           INPUT lForceoverride,
                                           INPUT cPrimaryField,
                                           INPUT iPrimaryDataType,
                                           INPUT cPrimaryValue,
                                           INPUT cSecondaryField,
                                           INPUT cSecondaryValue,
                                           INPUT cNewValue).
                        END. /* ATTRIBUTE-LOOP: End loop through attribute list */

                        ASSIGN dWidth = DYNAMIC-FUNCTION("getWidgetSizeFromFormat":U IN ghDesignManager,
                                                         INPUT  cFieldFormat,
                                                         INPUT  "CHARACTER":U,
                                                         OUTPUT dHeight).

                        IF cFieldDataType = "BLOB":U OR cFieldDataType = "CLOB":U THEN DO:
                           CREATE ttStoreAttribute.
                           ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                                  ttStoreAttribute.tAttributeParentObj = 0
                                  ttStoreAttribute.tAttributeLabel     = "CanFilter":U
                                  ttStoreAttribute.tConstantValue      = NO
                                  ttStoreAttribute.tLogicalValue       = NO.

                           CREATE ttStoreAttribute.
                           ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                                  ttStoreAttribute.tAttributeParentObj = 0
                                  ttStoreAttribute.tAttributeLabel     = "CanSort":U
                                  ttStoreAttribute.tConstantValue      = NO
                                  ttStoreAttribute.tLogicalValue       = NO.

                           CREATE ttStoreAttribute.
                           ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                                  ttStoreAttribute.tAttributeParentObj = 0
                                  ttStoreAttribute.tAttributeLabel     = "IncludeInDefaultView":U
                                  ttStoreAttribute.tConstantValue      = NO
                                  ttStoreAttribute.tLogicalValue       = (cFieldDataType = "CLOB":U).

                           CREATE ttStoreAttribute.
                           ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                                  ttStoreAttribute.tAttributeParentObj = 0
                                  ttStoreAttribute.tAttributeLabel     = "IncludeInDefaultListView":U
                                  ttStoreAttribute.tConstantValue      = NO
                                  ttStoreAttribute.tLogicalValue       = NO.

                           IF cFieldDataType = "CLOB":U THEN DO:
                              CREATE ttStoreAttribute.
                              ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                                     ttStoreAttribute.tAttributeParentObj = 0
                                     ttStoreAttribute.tAttributeLabel     = "HELP":U
                                     ttStoreAttribute.tConstantValue      = NO
                                     ttStoreAttribute.tCharacterValue     = ?.

                              CREATE ttStoreAttribute.
                              ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                                     ttStoreAttribute.tAttributeParentObj = 0
                                     ttStoreAttribute.tAttributeLabel     = "ViewAs":U
                                     ttStoreAttribute.tConstantValue      = NO
                                     ttStoreAttribute.tCharacterValue     = "{&CLOB-VIEW-AS-PHRASE}":U.
                           END.
                        END.

                        CREATE ttStoreAttribute.
                        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                               ttStoreAttribute.tAttributeParentObj = 0
                               ttStoreAttribute.tAttributeLabel     = "HEIGHT-CHARS":U
                               ttStoreAttribute.tConstantValue      = NO
                               ttStoreAttribute.tDecimalValue       = dHeight.

                        CREATE ttStoreAttribute.
                        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                               ttStoreAttribute.tAttributeParentObj = 0
                               ttStoreAttribute.tAttributeLabel     = "WIDTH-CHARS":U
                               ttStoreAttribute.tConstantValue      = NO
                               ttStoreAttribute.tDecimalValue       = dWidth.
                        
                        CREATE ttStoreAttribute.
                        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                               ttStoreAttribute.tAttributeParentObj = 0
                               ttStoreAttribute.tAttributeLabel     = "ShowPopup":U
                               ttStoreAttribute.tConstantValue      = NO
                               ttStoreAttribute.tLogicalValue       = LOOKUP(hFieldBuffer:BUFFER-FIELD("_Data-Type":U):BUFFER-VALUE, "DATE,INTEGER,DECIMAL,INT64":U) GT 0.

                        /* The VIEW-AS phrase is in VIEW-AS type [details] */
                        CREATE ttStoreAttribute.
                        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                               ttStoreAttribute.tAttributeParentObj = 0
                               ttStoreAttribute.tAttributeLabel     = "VisualizationType":U
                               ttStoreAttribute.tConstantValue      = NO.

                        IF NUM-ENTRIES(cViewAs, " ":U) = 0 OR cViewAs = ? OR cViewAs = "?":U THEN
                            ASSIGN ttStoreAttribute.tCharacterValue = "FILL-IN":U.
                        ELSE
                        DO:
                            ASSIGN cViewAs                          = TRIM(ENTRY(2, cViewAs, " ":U))
                                   ttStoreAttribute.tCharacterValue = (IF LOOKUP(cViewAs, gcUSE-SCHEMA-VIEW-AS) NE 0 THEN cViewAs ELSE "FILL-IN":U).

                        IF cFieldDataType = "CLOB":U THEN
                            RUN ripViewAsPhrase IN TARGET-PROCEDURE ("{&CLOB-VIEW-AS-PHRASE}":U).
                        ELSE
                            RUN ripViewAsPhrase IN TARGET-PROCEDURE (INPUT hFieldBuffer:BUFFER-FIELD("_View-as":U):BUFFER-VALUE).
                            
                            /* We don't want to have a popup for anything other than a FILL-IN */
                            FIND FIRST ttStoreAttribute WHERE ttStoreAttribute.tAttributeLabel = "ShowPopup":U EXCLUSIVE-LOCK NO-ERROR.
                            IF AVAILABLE ttStoreAttribute THEN
                                ASSIGN ttStoreAttribute.tLogicalValue = FALSE.
                        END.    /* there is a view-as phrase */

                        /* The VIEW-AS Phrase might have set this already */
                        IF NOT CAN-FIND(FIRST ttStoreAttribute WHERE
                                              ttStoreAttribute.tAttributeLabel = "Height-Chars":U) AND
                           TRIM(cViewAs) <> "EDITOR"                THEN
                        DO:
                            CREATE ttStoreAttribute.
                            ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                                   ttStoreAttribute.tAttributeParentObj = 0
                                   ttStoreAttribute.tAttributeLabel     = "Height-Chars":U
                                   ttStoreAttribute.tConstantValue      = NO
                                   ttStoreAttribute.tDecimalValue       = 1.
                        END.    /* check for height */

                        CREATE ttStoreAttribute.
                        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                               ttStoreAttribute.tAttributeParentObj = 0
                               ttStoreAttribute.tAttributeLabel     = "Visible":U
                               ttStoreAttribute.tConstantValue      = NO
                               ttStoreAttribute.tLogicalValue       = YES.

                        CREATE ttStoreAttribute.
                        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                               ttStoreAttribute.tAttributeParentObj = 0
                               ttStoreAttribute.tAttributeLabel     = "LABELS":U
                               ttStoreAttribute.tConstantValue      = NO
                               ttStoreAttribute.tLogicalValue       = YES.

                        ASSIGN hStoreAttributeBuffer = BUFFER ttStoreAttribute:HANDLE
                               hAttributeTable  = ?.
                        
                        /* Get rid of any attribute values that match those at the Class level. */
                        DYNAMIC-FUNCTION("cleanStoreAttributeValues":U IN TARGET-PROCEDURE,
                                         INPUT "":U,              /* pcObjectName*/
                                         INPUT pcObjectTypeCode,
                                         INPUT "CLASS":U,
                                         INPUT hStoreAttributeBuffer   ).
                        
                        /* The DATA-TYPE attribute must always be stored against DataField masters,
                           even if it has the same values as the class values, so only now
                           do we create the ttStoreAttribute record for this (aftewr clearing out 
                           the duplicates).
                           
                           The DATATYPE attribute is constant at the master data field level.
                         */
                        CREATE ttStoreAttribute.
                        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                               ttStoreAttribute.tAttributeParentObj = 0
                               ttStoreAttribute.tAttributeLabel     = "DATA-TYPE":U
                               ttStoreAttribute.tConstantValue      = NO
                               ttStoreAttribute.tCharacterValue     = cFieldDataType.
                        
                        RUN insertObjectMaster IN ghDesignManager ( INPUT  cFileName + ".":U + cDataFieldName,       /* pcObjectName         */
                                                                    INPUT  pcResultCode,                             /* pcResultCode         */
                                                                    INPUT  pcProductModuleCode,                      /* pcProductModuleCode  */
                                                                    INPUT  pcObjectTypeCode,                         /* pcObjectTypeCode     */
                                                                    INPUT  "DataField for ":U + cDataFieldName,      /* pcObjectDescription  */
                                                                    INPUT  "":U,                                     /* pcObjectPath         */
                                                                    INPUT  "":U,                                     /* pcSdoObjectName      */
                                                                    INPUT  "":U,                                     /* pcSuperProcedureName */
                                                                    INPUT  NO,                                       /* plIsTemplate         */
                                                                    INPUT  YES,                                      /* plIsStatic           */
                                                                    INPUT  "":U,                                     /* pcPhysicalObjectName */
                                                                    INPUT  NO,                                       /* plRunPersistent      */
                                                                    INPUT  "":U,                                     /* pcTooltipText        */
                                                                    INPUT  "":U,                                     /* pcRequiredDBList     */
                                                                    INPUT  "":U,                                     /* pcLayoutCode         */
                                                                    INPUT  hStoreAttributeBuffer,
                                                                    INPUT  TABLE-HANDLE hAttributeTable,
                                                                    OUTPUT dDataFieldObj                  ) NO-ERROR.
                        ASSIGN lError       = ERROR-STATUS:ERROR
                               cReturnValue = RETURN-VALUE.

                        /* We don't return an error from here because we need to 
                         * clean up first.                                       */
                        IF lError OR cReturnValue NE "":U THEN
                            LEAVE DBNAME-LOOP.
                            
                        /* Look through all the attributes we were supposed to create,
                           and check which ones we are actually creating or updating.
                           There may be some missing since the values we are creating 
                           here may match the values as stored against the class. 
                           
                           If a DataField is being updated, and there is already an 
                           attribute stored against the DataField, we need to remove 
                           that value, since it is wrong (in terms of the DB metaschema).                                                   
                           
                           We need to loop through the defined list of attributes that this
                           API creates, because attribute values may be added to the DataField
                           master by a developer of some other process. In this case, it may
                           be desirable to have the master value match the class value, so as
                           to always ensure particular behaviour. This API cannot make any
                           judgements on any attribute values not created by it, so it needs
                           to leave those alone.
                         */
                         
                        /* Only do this if the DataField already exists in the Repository. */
                        if available ttObject then
                        do:
                            empty temp-table ttDeleteAttribute.
                            
                            DELETE-ATTRIBUTES:
                            do iAttrloop = 1 to NUM-ENTRIES(cAttrList):
                                /* Skip every 3rd entry, since this corresponds to the _Field 
                                   field.
                                   
                                   cAttrList looks something like:
                                   SCHEMA-<attribute-name>,<attribute-name>,_Field.<attribute-field>
                                 */
                                if iAttrLoop mod 3 eq 0 then
                                    next DELETE-ATTRIBUTES.
                                
                                assign cPrimaryField = trim(entry(iAttrLoop, cAttrList)).
                                
                                if cPrimaryField eq "":U then
                                    next DELETE-ATTRIBUTES.
								
                                /* Only delete attributes if we've actually attempted to update them.
                                   The pcOverrideAttributes parameter contains a CSV list of attributes
                                   to override when updating (not newly creating) a DataField record. 
                                   
                                   The deletion works on the basis of there not being a ttStoreAttribute
                                   record; however, in cases where the attribute is not supposed to be
                                   overriden, there will not be a record and so the attribute in the 
                                   repository will be deleted erroneously. A check to see whether the
                                   attribute is supposed to be overwritten is required to make sure
                                   that the attribute in the repository is not deleted.
                                   
                                   Only the attributes used by Dynamics - the non SCHEMA-* attributes -
                                   are allowed to be out of synch with the DB metaschema. The SCHEMA-*
                                   attributes (by definition) contain metachema information.                                   
                                   
                                 */
                                IF iAttrLoop MOD 3 EQ 2 AND 
                                   NOT CAN-DO(pcOverrideAttributes, cPrimaryField) THEN
                                	NEXT DELETE-ATTRIBUTES.
								
	                            if /* Is there an attribute in the DB (prior to insertObjectMaster)? */
                                   can-find(ttObjectAttribute where
                                            ttObjectAttribute.tAttributeLabel    = cPrimaryField            and
                                            ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj and
                                            ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj ) and
	                               /* this is the newly-stored attribute value. */
                                   not can-find(ttStoreAttribute where
                                                ttStoreAttribute.tAttributeParent = "MASTER"     and
                                                ttStoreAttribute.tAttributeLabel  = cPrimaryField   ) then
                                do:
                                    create ttDeleteAttribute.
                                    assign ttDeleteAttribute.tAttributeParent    = "MASTER":U
                                           ttDeleteAttribute.tAttributeParentObj = ttObject.tSmartObjectObj
                                           ttDeleteAttribute.tAttributeLabel     = cPrimaryField.
	                            end.    /* this attribute needs to be deleted. */	                            
	                        end.    /* DELETE-ATTRIBUTES: attribute loop */
                            
                            if can-find(first ttDeleteAttribute) then
                            do:
                                assign hStoreAttributeBuffer = buffer ttDeleteAttribute:handle
                                       hAttributeTable       = ?.
                                
                                run removeAttributeValues in ghDesignManager (input hStoreAttributeBuffer,
                                                                              input table-handle hAttributeTable ) no-error.
                                assign lError       = error-status:error
                                       cReturnValue = return-value.
                                
                                /* We don't return an error from here because we need to 
                                   clean up first.
                                 */
                                if lError or cReturnValue ne "":U then
                                    leave DBNAME-LOOP.
                            end.    /* delete attributes */
                        end.    /* this is an existing datafield */
                    END. /* Field should not be included */
                END.    /* loop through extents. */

                hQuery:GET-NEXT(NO-LOCK).
            END.        /* END DO WHILE Field AVAILABLE */
            hQuery:QUERY-CLOSE().
        END.    /* valid query handle */
        ELSE
            ASSIGN lError       = YES
                   cReturnValue = {aferrortxt.i 'AF' '16' '?' '?' "'Unable to create a valid query for table ' + pcTableName + ' in database ' + pcDatabaseName "}.
    END.    /* DBNAME-LOOP: */    
    
    DELETE OBJECT hQuery NO-ERROR.
    ASSIGN hQuery = ?.

    DELETE WIDGET-POOL cWidgetPoolName NO-ERROR.
    /* - - EOF  - - */
