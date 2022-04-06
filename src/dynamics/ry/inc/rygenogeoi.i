/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: rygenogeoi.i

  Description:  Design Manager: Object Generator: generateEntityObject()

  Purpose:      Code from generateEntityObject() internal procedure; moved into this include
                because of Section Editor limits.

  Parameters:

  History:
  --------
  (v:010000)    Task:              UserRef:    
                Date:   07/15/2003  Author:     Peter Judge

  Update Notes: Created from scratch.

---------------------------------------------------------------------------------*/    
    DEFINE VARIABLE dSmartObjectObj                 AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE iDbLoop                         AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iTableLoop                      AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iLoop                           AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer                AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hAttributeTable                 AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hQuery                          AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hFieldQuery                     AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hDbBuffer                       AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hFileBuffer                     AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hFieldBuffer                    AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hField                          AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hEntityTable                    AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE iIdx                            AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iFieldLoop                      AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iExtent                         AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iMaxExtent                      AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE cDbName                         AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cTableName                      AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cFieldName                      AS CHARACTER                NO-UNDO.     
    DEFINE VARIABLE cDumpName                       AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cDbTables                       AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cWidgetPoolName                 AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cPrepareString                  AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cTableBase                      AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cIndexInfo                      AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cTableIndex                     AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cUniqueSingleFieldIndexes       AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cLetter                         AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cFieldQueryString               AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cAllFields                      AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cTempString                     AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE lAddMe                          AS LOGICAL                  NO-UNDO.

    /* Set defaults */
    IF pcDescFieldQualifiers EQ "":U OR pcDescFieldQualifiers  EQ ? THEN
        ASSIGN pcDescFieldQualifiers  = "description,desc,short[SEPARATOR]name,name":U.

    IF pcKeyFieldQualifiers  EQ "":U OR pcKeyFieldQualifiers EQ ? THEN
        ASSIGN pcKeyFieldQualifiers = "code,reference,type,tla,number,short[SEPARATOR]desc":U.

    IF pcObjFieldQualifiers EQ "":U OR pcObjFieldQualifiers EQ ? THEN
        ASSIGN pcObjFieldQualifiers = "obj":U.

    /* Validate some data up front. */
    IF NOT DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, INPUT pcEntityObjectType, INPUT "Entity":U ) THEN
        RETURN ERROR {aferrortxt.i 'RY' '13' '?' '?' pcEntityObjectType 'Entity' '"Generation cancelled."'}.

    IF plAssociateDataFields THEN
        CREATE QUERY hFieldQuery.

    ASSIGN hAttributeBuffer = ?
           hAttributeTable  = ?.
    
    DO iDbLoop = 1 TO NUM-ENTRIES(pcTableNames, CHR(3)) BY 2:
        ASSIGN cDbName   = ENTRY(iDbLoop, pcTableNames, CHR(3))
               cDbTables = ENTRY(iDbLoop + 1, pcTableNames, CHR(3)).

        /* Get all tables for the DB because we may pass in a CAN-DO() style list. */
        ASSIGN hQuery = DYNAMIC-FUNCTION("getSchemaQueryHandle":U IN ghDesignManager,
                                         INPUT  cDbName,
                                         INPUT  "*":U,              /* pcTableName */
                                         OUTPUT cWidgetPoolName ).
        IF VALID-HANDLE(hQuery) THEN
        DO:
            IF hQuery:IS-OPEN THEN
                hQuery:QUERY-CLOSE().

            ASSIGN hDbBuffer         = hQuery:GET-BUFFER-HANDLE(1)
                   hFileBuffer       = hQuery:GET-BUFFER-HANDLE(2)
                   hFieldBuffer      = hQuery:GET-BUFFER-HANDLE(3)
                   cPrepareString    = hQuery:PREPARE-STRING
                   /* Keep this in case we have to create the instances. */
                   cTempString       = ENTRY(3, cPrepareString)
                   
                   cFieldQueryString = SUBSTRING(cTempString, 1, INDEX(cTempString, "(":U) - 6 )
                                     + "INTEGER(&1)":U
                                     + SUBSTRING(cTempString, INDEX(cTempString, ")":U) + 1 )

                   /* Strip off the _Field stuff */
                   ENTRY(3, cPrepareString) = "":U
                   cPrepareString           = RIGHT-TRIM(cPrepareString, ",":U).

            hQuery:SET-BUFFERS(hDbBuffer, hFileBuffer).
            hQuery:QUERY-PREPARE(cPrepareString).
            hQuery:QUERY-OPEN().

            ASSIGN hFileBuffer = hQuery:GET-BUFFER-HANDLE(2).

            hQuery:GET-FIRST().
            DO WHILE hFileBuffer:AVAILABLE:
                ASSIGN cTableName = hFileBuffer:BUFFER-FIELD("_File-name":U):BUFFER-VALUE.

                /* Do we want to work with this table? */
                IF CAN-DO(cDbTables, cTableName) THEN
                DO:
                    /* This is equivalent to the Entity mnemonic. */
                    ASSIGN cDumpName = hFileBuffer:BUFFER-FIELD("_Dump-name":U):BUFFER-VALUE.

                    FIND FIRST gsc_entity_mnemonic WHERE
                               gsc_entity_mnemonic.entity_mnemonic = cDumpName
                               EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
                    IF LOCKED gsc_entity_mnemonic THEN
                        RETURN ERROR {aferrortxt.i 'AF' '104' 'gsc_entity_mnemonic' '?' cTableName}.

                    IF NOT AVAILABLE gsc_entity_mnemonic THEN
                    DO:
                        CREATE gsc_entity_mnemonic NO-ERROR.
                        IF ERROR-STATUS:ERROR THEN
                        DO:
                            DELETE OBJECT hQuery NO-ERROR.
                            DELETE WIDGET-POOL cWidgetPoolName NO-ERROR.
                            ASSIGN hQuery = ?.

                            RETURN ERROR RETURN-VALUE.
                        END.    /* error */

                        ASSIGN gsc_entity_mnemonic.entity_mnemonic = CAPS(cDumpName).
                    END.  /* not available entity mnemonic */

                    ASSIGN gsc_entity_mnemonic.entity_mnemonic_description = cTableName
                           gsc_entity_mnemonic.entity_dbname               = cDbName
                           gsc_entity_mnemonic.auto_properform_strings     = plAutoProPerform
                           gsc_entity_mnemonic.entity_narration            = hFileBuffer:BUFFER-FIELD("_Desc":U):BUFFER-VALUE
                           gsc_entity_mnemonic.table_prefix_length         = piPrefixLength
                           gsc_entity_mnemonic.field_name_separator        = pcSeparator.

                    IF pcSeparator EQ "Upper":U THEN
                    DO:
                        ASSIGN lAddMe     = NO
                               cTableBase = "":U.
                        LETTER-LOOP:
                        DO iLoop = piPrefixLength + 1 TO LENGTH(cTableName, "CHARACTER":U):
                            ASSIGN cLetter = SUBSTRING(cTableName, iLoop, 1, "CHARACTER":U).

                            /* Ignore the first letter if it is capitalised. */
                            IF lAddMe EQ NO AND ASC(cLetter) EQ ASC(CAPS(cLetter)) THEN
                                ASSIGN lAddMe = YES.

                            IF lAddMe THEN
                                ASSIGN cTableBase = cTableBase + cLetter.
                        END.    /* LETTER-LOOP: */
                    END.    /* pcSeparator = upper */
                    ELSE
                        ASSIGN cTableBase = SUBSTRING(cTableName, piPrefixLength + 1).

                    CASE pcAuditingEnabled:
                        WHEN "Y":U THEN ASSIGN gsc_entity_mnemonic.auditing_enabled = TRUE.
                        WHEN "N":U THEN ASSIGN gsc_entity_mnemonic.auditing_enabled = FALSE.
                        OTHERWISE       ASSIGN gsc_entity_mnemonic.auditing_enabled = ?.
                    END CASE.   /* Auditing enabled */

                    CASE pcSeparator:
                        WHEN "":U THEN ASSIGN gsc_entity_mnemonic.entity_mnemonic_short_desc = cTableBase.
                        WHEN "Upper" THEN
                        DO:
                            LETTER-LOOP:
                            DO iLoop = 1 TO LENGTH(cTableBase, "CHARACTER":U):
                                ASSIGN cLetter = SUBSTRING(cTableBase, iLoop, 1, "CHARACTER":U).

                                /* Add a space before each caps letter, except the first one. */
                                IF iLoop GT 1 AND ASC(cLetter) EQ ASC(CAPS(cLetter)) THEN
                                    ASSIGN gsc_entity_mnemonic.entity_mnemonic_short_desc = gsc_entity_mnemonic.entity_mnemonic_short_desc + " ":U.

                                ASSIGN gsc_entity_mnemonic.entity_mnemonic_short_desc = gsc_entity_mnemonic.entity_mnemonic_short_desc + cLetter.
                            END.    /* LETTER-LOOP: */
                        END.    /* Upper */
                        OTHERWISE ASSIGN gsc_entity_mnemonic.entity_mnemonic_short_desc = REPLACE(cTableBase, pcSeparator, " ":U).
                    END CASE.   /* separator */

                    CREATE BUFFER hEntityTable FOR TABLE cTableName BUFFER-NAME "importTable":U NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN
                    DO:
                        DELETE OBJECT hQuery NO-ERROR.
                        DELETE WIDGET-POOL cWidgetPoolName NO-ERROR.
                        ASSIGN hQuery = ?.

                        RETURN ERROR {aferrortxt.i 'AF' '40' '?' '?' "'unable to create buffer for ' + cTableName" }.
                    END.    /* error */

                    ASSIGN iIdx                      = 1
                           cTableIndex               = "":U
                           cUniqueSingleFieldIndexes = "":U.

                    DO WHILE hEntityTable:INDEX-INFORMATION(iIdx) NE ?:
                        ASSIGN cIndexInfo  = hEntityTable:INDEX-INFORMATION(iIdx)
                               cTableIndex = cTableIndex + cIndexInfo + CHR(3)
                               iIdx        = iIdx + 1.

                        /* Build a list of all unique single field indexes. */
                        IF NUM-ENTRIES(cIndexInfo) EQ 6 AND
                           ENTRY(2, cIndexInfo)    EQ "1":U  THEN
                            ASSIGN cUniqueSingleFieldIndexes = cUniqueSingleFieldIndexes + cIndexInfo + CHR(3).
                    END.  /* IndexBlock */
                    ASSIGN cTableIndex               = RIGHT-TRIM(cTableIndex, CHR(3))
                           cUniqueSingleFieldIndexes = RIGHT-TRIM(cUniqueSingleFieldIndexes, CHR(3)).

                    /** Certain information should only be updated when the Entity is imported.
                     *  ----------------------------------------------------------------------- **/
                    IF NEW gsc_entity_mnemonic THEN
                    DO:
                        ASSIGN gsc_entity_mnemonic.deploy_data                 = plDeployData
                               gsc_entity_mnemonic.reuse_deleted_keys          = plReUseDeletedKeys
                               gsc_entity_mnemonic.version_data                = plVersionData.

                        /** Entity Object Field
                         *  ----------------------------------------------------------------------- **/
                        ASSIGN gsc_entity_mnemonic.entity_object_field = DYNAMIC-FUNCTION("getFieldNames":U IN TARGET-PROCEDURE,
                                                                                          INPUT hEntityTable,
                                                                                          INPUT pcObjFieldQualifiers,
                                                                                          INPUT pcSeparator,
                                                                                          INPUT cTableBase,
                                                                                          INPUT "DECIMAL":U,
                                                                                          INPUT NO,                /* plNonKeyFieldsAllowed */
                                                                                          INPUT NO,                /* plBuildFromIndexes */
                                                                                          INPUT "":U,              /* pcAllIndexes */
                                                                                          INPUT "":U,              /* pcUniqueSingleFieldIndexes */
                                                                                          INPUT "":U,              /* pcAlternateDataTypes */
                                                                                          INPUT "":U ).            /* pcObjectFieldName */
                        ASSIGN gsc_entity_mnemonic.table_has_object_field = (gsc_entity_mnemonic.entity_object_field NE "":U).

                        /** Entity_Key_field
                         *  ----------------------------------------------------------------------- **/
                        ASSIGN gsc_entity_mnemonic.entity_key_field = DYNAMIC-FUNCTION("getFieldNames":U IN TARGET-PROCEDURE,
                                                                                       INPUT hEntityTable,
                                                                                       INPUT pcKeyFieldQualifiers,
                                                                                       INPUT pcSeparator,
                                                                                       INPUT cTableBase,
                                                                                       INPUT "CHARACTER":U,
                                                                                       INPUT NO,                        /* plNonKeyFieldsAllowed */
                                                                                       INPUT YES,                       /* plBuildFromIndexes */
                                                                                       INPUT cTableIndex,               /* pcAllIndexes */
                                                                                       INPUT cUniqueSingleFieldIndexes, /* pcUniqueSingleFieldIndexes */
                                                                                       INPUT "DECIMAL,INTEGER":U,       /* pcAlternateDataTypes */
                                                                                       INPUT gsc_entity_mnemonic.entity_object_field). /* pcObjectFieldName */
                    END.    /* New Record only */

                    /** Entity_description_field
                     *  ----------------------------------------------------------------------- **/
                    ASSIGN gsc_entity_mnemonic.entity_description_field = DYNAMIC-FUNCTION("getFieldNames":U IN TARGET-PROCEDURE,
                                                                                           INPUT hEntityTable,
                                                                                           INPUT pcDescFieldQualifiers,
                                                                                           INPUT pcSeparator,
                                                                                           INPUT cTableBase,
                                                                                           INPUT "CHARACTER":U,
                                                                                           INPUT YES,               /* plNonKeyFieldsAllowed */
                                                                                           INPUT NO,                /* plBuildFromIndexes */
                                                                                           INPUT "":U,              /* pcAllIndexes */
                                                                                           INPUT "":U,              /* pcUniqueSingleFieldIndexes */
                                                                                           INPUT "":U,              /* pcAlternateDataTypes */
                                                                                           INPUT gsc_entity_mnemonic.entity_object_field). /* pcObjectFieldName */
                    
                    /* Delete the table buffer once the entity has been imported. */
                    DELETE OBJECT hEntityTable NO-ERROR.
                    ASSIGN hEntityTable = ?.

                    VALIDATE gsc_entity_mnemonic NO-ERROR.
                    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
                    DO:
                        DELETE WIDGET-POOL cWidgetPoolName NO-ERROR.
                        DELETE OBJECT hQuery NO-ERROR.
                        DELETE OBJECT hEntityTable NO-ERROR.
                        ASSIGN hEntityTable = ?
                               hQuery       = ?.

                        RETURN ERROR RETURN-VALUE.
                    END.    /* error from write trigger */

                    /** Create an object master for this Entity.
                     *  ----------------------------------------------------------------------- **/
                    /* There are currently no attributes for this object. */
                    RUN insertObjectMaster IN ghDesignManager ( INPUT  gsc_entity_mnemonic.entity_mnemonic_description,
                                                                INPUT  "{&DEFAULT-RESULT-CODE}":U,                 /* pcResultCode         */
                                                                INPUT  pcEntityProductModule,                      /* pcProductModuleCode  */
                                                                INPUT  pcEntityObjectType,                         /* pcObjectTypeCode     */
                                                                INPUT  "Entity object for table ":U + cTablename,  /* pcObjectDescription  */
                                                                INPUT  "":U,                                       /* pcDataLogicRelativePath */ 
                                                                INPUT  "":U,                                       /* pcSdoObjectName      */
                                                                INPUT  "":U,                                       /* pcSuperProcedureName */
                                                                INPUT  NO,                                         /* plIsTemplate         */
                                                                INPUT  YES,                                        /* plIsStatic           */
                                                                INPUT  "":U,                                       /* pcPhysicalObjectName */
                                                                INPUT  NO,                                         /* plRunPersistent      */
                                                                INPUT  "":U,                                       /* pcTooltipText        */
                                                                INPUT  "":U,                                       /* pcRequiredDBList     */
                                                                INPUT  "":U,                                       /* pcLayoutCode         */
                                                                INPUT  hAttributeBuffer,
                                                                INPUT  TABLE-HANDLE hAttributeTable,
                                                                OUTPUT dSmartObjectObj                     ) NO-ERROR.
                    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
                    DO:
                        DELETE WIDGET-POOL cWidgetPoolName NO-ERROR.
                        DELETE OBJECT hQuery NO-ERROR.
                        ASSIGN hQuery = ?.

                        RETURN ERROR RETURN-VALUE.
                    END.    /* error */

                    /** Now associate DataFields, if requred. The GenerateEntityInstances API
                     *  has details of the parameters supplied.
                     *  ----------------------------------------------------------------------- **/
                    IF plAssociateDataFields THEN
                    DO:
                        ASSIGN cAllFields = "":U.

                        hFieldQuery:SET-BUFFERS(hFieldBuffer).
                        hFieldQuery:QUERY-PREPARE(" FOR ":U + SUBSTITUTE(cFieldQueryString, QUOTER(hFileBuffer:RECID)) ).
                        hFieldQuery:QUERY-OPEN().

                        hFieldQuery:GET-FIRST(NO-LOCK).
                        DO WHILE hFieldBuffer:AVAILABLE:
                            ASSIGN iExtent = hFieldBuffer:BUFFER-FIELD("_Extent":U):BUFFER-VALUE.

                            IF iExtent EQ 0 THEN
                                ASSIGN iMaxExtent = 1.
                            ELSE
                                ASSIGN iMaxExtent = iExtent.
                            
                            DO iLoop = 1 TO iMaxExtent:
                                IF iExtent NE 0 THEN
                                    ASSIGN cFieldName = hFieldBuffer:BUFFER-FIELD("_Field-name":U):BUFFER-VALUE + STRING(iLoop).
                                ELSE
                                    ASSIGN cFieldName = hFieldBuffer:BUFFER-FIELD("_Field-name":U):BUFFER-VALUE.
                            
                                ASSIGN cAllFields = cAllFields + cTableName + ".":U + cFieldName + CHR(3).
                            END.        /* to extent  */
                            
                            hFieldQuery:GET-NEXT(NO-LOCK).
                        END.    /* available field buffer */
                        hFieldQuery:QUERY-CLOSE().

                        ASSIGN cAllFields = RIGHT-TRIM(cAllFields, CHR(3)).

                        RUN generateEntityInstances IN ghDesignManager ( INPUT gsc_entity_mnemonic.entity_mnemonic_description,
                                                                         INPUT cAllFields,
                                                                         INPUT No  /*Delete existin instances? */  ) NO-ERROR.
                        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
                        DO:
                            DELETE WIDGET-POOL cWidgetPoolName NO-ERROR.
                            DELETE OBJECT hQuery NO-ERROR.
                            DELETE OBJECT hFieldQuery NO-ERROR.
                            ASSIGN hFieldQuery = ?
                                   hQuery      = ?.
                            RETURN ERROR RETURN-VALUE.
                        END.    /* error */
                    END.    /* associate datafields */
                END.    /* table in the list */
                hQuery:GET-NEXT().
            END.    /* loop through records */
            hQuery:QUERY-CLOSE().
        END.    /* valid query */

        /* Clean up */
        DELETE WIDGET-POOL cWidgetPoolName  NO-ERROR.
        DELETE OBJECT hQuery                NO-ERROR.
        DELETE OBJECT hEntityTable          NO-ERROR.
        DELETE OBJECT hFieldQuery           NO-ERROR.
        ASSIGN hFieldQuery  = ?
               hEntityTable = ?
               hQuery       = ?.
    END.    /* loop through tablenames parameter */
    /* ***** -EOF- ***** */
