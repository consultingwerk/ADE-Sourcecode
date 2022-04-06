&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Include _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afgenmngrp.i

  Description:  ICF Framework Manager PLIP Include
  
  Purpose:      ICF Framework Manager PLIP Include.
                This include containers the actual business logic code which will be run on
                the client and/or the server. This manager will be referenced by the
                gshGenManager handle.
                Only ICF Framework code belongs in this include.

  Parameters:

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   10/18/2001  Author:     

  Update Notes: Fixed multi_transaction sequences to wrap when they

  (v:010001)    Task:        7806   UserRef:    
                Date:   01/02/2001  Author:     Peter Judge

  Update Notes: AF2/BUG/ Manager Super Procedure:
                - getInternalEntries adds extra characters
                - call to getPeriodObj uses incorrect path

  (v:010002)    Task:   101000035   UserRef:    
                Date:   09/28/2001  Author:     Johan Meyer

  Update Notes: Change use the information in entity_key_field for tables that do not have object numbers.
                Add getentitykeyfield and getentitydisplayfield procedure

  (v:010003)    Task:        8188   UserRef:    IL17
                Date:   09/03/2001  Author:     Peter Judge

  Update Notes: AF2/BUG/ GL journal capture:
                - status caching doesn't cater properly for null (?) values
                - gstjt obj is updateable (shouldn't be)

  (v:010004)    Task:        8233   UserRef:    
                Date:   22/03/2001  Author:     Johan Meyer

  Update Notes: add GetRecordDetail Procedure

  (v:010005)    Task:        8565   UserRef:    
                Date:   30/04/2001  Author:     Peter Judge

  Update Notes: AF2/NEW/ Transaction Reversals - AR/AP & GL

  (v:010006)    Task:        8579   UserRef:    
                Date:   02/05/2001  Author:     Peter Judge

  Update Notes: AF2/NEW/ GL account/cost centre security maintenance:
                - added ROWID's of all tables fetched in getRecordDetail

  (v:010007)    Task:        8634   UserRef:    
                Date:   09/05/2001  Author:     Peter Judge

  Update Notes: AF2/MOD/ Added "updateTableViaSDO" procedure. This procedure takes an
                SDO name, description and a rowObjUpd temp table, and attempts to update
                the DB using the parameter specified.

  (v:010008)    Task:        8808   UserRef:    
                Date:   18/05/2001  Author:     Peter Judge

  Update Notes: AF2/BUG/ Recurring transactions:
                - error "getOEMCode not found". Increase the fields that "getEntityDescription"
                looks fuzzily for.

  (v:010009)    Task:    90000149   UserRef:    
                Date:   24/05/2001  Author:     Bruce Gruenbaum

  Update Notes: Updated from MIP

  (v:010010)    Task:    90000163   UserRef:    
                Date:   26/06/2001  Author:     Bruce Gruenbaum

  Update Notes: Modifications from MIP

  (v:010011)    Task:               UserRef:    
                Date:   10/18/2001  Author:     Mark Davies (MIP)

  Update Notes: Fixed multi_transaction sequences to wrap when they reach the
                maximum value.

  (v:010012)    Task:           0   UserRef:    
                Date:   02/05/2002  Author:     Mark Davies (MIP)

  Update Notes: Fix for issue #2626 - Max Value ignored for multi-transaction sequences

  (v:010013)    Task:           0   UserRef:    
                Date:   05/03/2002  Author:     Mark Davies (MIP)

  Update Notes: Added function called getUserSourceLanguage to use with menu translations

--------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ICF object identifying preprocessor */
&glob   AstraInclude    yes

{afcheckerr.i &define-only = YES}
{afrun2.i     &define-only = YES} 

{af/app/gsmstttcch.i}
{af/app/gsttenmn.i}
{src/adm2/globals.i}

DEFINE STREAM sInput.

DEFINE TEMP-TABLE ttUser                NO-UNDO LIKE gsm_user.

/* The temp-table for the filter sets are defined here because all filter set functionality
   exists in the General Manager only */
DEFINE TEMP-TABLE ttFilterSetClause NO-UNDO
  FIELD filter_set_code       AS CHARACTER
  FIELD entity_list           AS CHARACTER
  FIELD buffer_list           AS CHARACTER
  FIELD additional_arguments  AS CHARACTER
  FIELD filter_set_clause     AS CHARACTER

  INDEX idxFilterSet  filter_set_code
                      entity_list
                      buffer_list
                      additional_arguments.
                      
/* Used in cacheEntityDisplayFields for separating attribute values returned by getInstanceProperties().
 */
&SCOPED-DEFINE Value-Delimiter CHR(1)

DEFINE VARIABLE giSiteNumber AS INTEGER    NO-UNDO INITIAL ?.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD clearFilterSetCache Include 
FUNCTION clearFilterSetCache RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD convertTimeToInteger Include 
FUNCTION convertTimeToInteger RETURNS INTEGER
  (pcTime AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createFolder Include 
FUNCTION createFolder RETURNS LOGICAL
    ( INPUT pcFolderName       AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD detectFileType Include 
FUNCTION detectFileType RETURNS CHARACTER
    ( INPUT pcFileName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD formatPersonDetails Include 
FUNCTION formatPersonDetails RETURNS CHARACTER
  (pcLastName  AS CHARACTER,
   pcFirstName AS CHARACTER,
   pcInitials  AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEntityCacheBuffer Include 
FUNCTION getEntityCacheBuffer RETURNS HANDLE
  ( pcEntity    AS CHARACTER,
    pcTableName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEntityFieldCacheBuffer Include 
FUNCTION getEntityFieldCacheBuffer RETURNS HANDLE
  ( pcEntity    AS CHARACTER,
    pcTableName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHighKey Include 
FUNCTION getHighKey RETURNS CHARACTER
  ( INPUT pcCollationTableName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInternalEntries Include 
FUNCTION getInternalEntries RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getKeyField Include 
FUNCTION getKeyField RETURNS CHARACTER
  ( pcEntityMnemonic AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNextSequenceValue Include 
FUNCTION getNextSequenceValue RETURNS CHARACTER
  ( INPUT pdCompanyObj      AS DECIMAL,
    INPUT pcEntityMnemonic  AS CHARACTER,
    INPUT pcSequenceTLA     AS CHARACTER   ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjField Include 
FUNCTION getObjField RETURNS CHARACTER
  ( pcEntityMnemonic AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOEMCode Include 
FUNCTION getOEMCode RETURNS CHARACTER
  (INPUT pcEntityMnemonic AS CHARACTER, INPUT pdEntityObj AS DECIMAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOEMDescription Include 
FUNCTION getOEMDescription RETURNS CHARACTER
  (INPUT pcEntityMnemonic AS CHARACTER, INPUT pdEntityObj AS DECIMAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPropertyFromList Include 
FUNCTION getPropertyFromList RETURNS CHARACTER
  (pcPropertyList AS CHARACTER,
   pcPropertyName AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSequenceConfirmation Include 
FUNCTION getSequenceConfirmation RETURNS LOGICAL
  ( INPUT pdCompanyObj      AS DECIMAL,
    INPUT pcEntityMnemonic  AS CHARACTER,
    INPUT pcSequenceTLA    AS CHARACTER    ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSessionFilterSet Include 
FUNCTION getSessionFilterSet RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getStatusObj Include 
FUNCTION getStatusObj RETURNS DECIMAL
  ( INPUT pcCategoryType            AS CHARACTER,
    INPUT pcCategoryGroup           AS CHARACTER,
    INPUT pcCategorySubGroup        AS CHARACTER    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getStatusShortDesc Include 
FUNCTION getStatusShortDesc RETURNS CHARACTER
  ( INPUT pdStatusObj AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getStatusTLA Include 
FUNCTION getStatusTLA RETURNS CHARACTER
  ( INPUT pdStatusObj AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTableDumpName Include 
FUNCTION getTableDumpName RETURNS CHARACTER
  (pcQuery AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdatableTableInfo Include 
FUNCTION getUpdatableTableInfo RETURNS CHARACTER
  (INPUT phDataSource AS WIDGET-HANDLE) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdatableTableInfoObj Include 
FUNCTION getUpdatableTableInfoObj RETURNS CHARACTER
  (INPUT phDataSource AS WIDGET-HANDLE) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD haveOutstandingUpdates Include 
FUNCTION haveOutstandingUpdates RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD listLookup Include 
FUNCTION listLookup RETURNS CHARACTER
  ( INPUT pcElement   AS CHARACTER,
    INPUT pcSource    AS CHARACTER,
    INPUT pcTarget    AS CHARACTER,
    INPUT pcDelimiter AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPropertyValueInList Include 
FUNCTION setPropertyValueInList RETURNS CHARACTER
  (pcPropertyList   AS CHARACTER,
   pcPropertyName   AS CHARACTER,
   pcPropertyValue  AS CHARACTER,
   pcAction         AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setWidgetAttribute Include 
FUNCTION setWidgetAttribute RETURNS LOGICAL
    ( INPUT phWidget            AS HANDLE,
      INPUT pcAttributeName     AS CHARACTER,
      INPUT pcAttributeValue    AS CHARACTER,
      INPUT pcAttributeDataType AS CHARACTER,
      INPUT phExternalCall      AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 25.29
         WIDTH              = 62.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
CREATE WIDGET-POOL NO-ERROR.

ON CLOSE OF THIS-PROCEDURE 
DO:
    DELETE WIDGET-POOL NO-ERROR.

    RUN plipShutdown IN TARGET-PROCEDURE.

    DELETE PROCEDURE THIS-PROCEDURE.
    RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cacheEntity Include 
PROCEDURE cacheEntity :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Caches the entity passed in.
               The procedure will populate the ttEntityMnemonic table from 
               the entity mnemonic table               
  Parameters:  pcEntityToCache -
               pcTableToCache  -
  Notes:       * The population of the display fields has been removed from this
                 API for performance reasons. There is a separate API that is 
                 used for the population of the display field information.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcEntityToCache      AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcTableToCache       AS CHARACTER            NO-UNDO.
    
    /* Already cached? */
    IF CAN-FIND(FIRST ttEntityMnemonic WHERE ttEntityMnemonic.entity_mnemonic = pcEntityToCache) OR
       CAN-FIND(FIRST ttEntityMnemonic WHERE ttEntityMnemonic.entity_mnemonic_description = pcTableToCache) THEN
        RETURN.

    /* First, we always want to work with the tablename.  If the user has only passed in an entity FLA, map it to a tablename */
    IF pcTableToCache = "":U OR pcTableToCache = ? THEN
        FIND ttEntityMnemonic WHERE ttEntityMnemonic.entity_mnemonic = pcEntityToCache NO-ERROR.
    ELSE
        FIND ttEntityMnemonic WHERE ttEntityMnemonic.entity_mnemonic_description = pcTableToCache NO-ERROR.
             
    IF NOT AVAILABLE ttEntityMnemonic THEN
    DO:
        RUN cacheEntityMapping IN TARGET-PROCEDURE ( INPUT  pcEntityToCache,
                                                     INPUT  pcTableToCache, /* Table to cache */
                                                     OUTPUT TABLE ttEntityMnemonic APPEND )  NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

        IF pcTableToCache = "":U OR pcTableToCache = ? THEN
            FIND ttEntityMnemonic WHERE ttEntityMnemonic.entity_mnemonic = pcEntityToCache NO-ERROR.
        ELSE
            FIND ttEntityMnemonic WHERE ttEntityMnemonic.entity_mnemonic_description = pcTableToCache NO-ERROR.
    END.    /* n/a entity */

    IF AVAILABLE ttEntityMnemonic THEN
        ASSIGN pcEntityToCache = ttEntityMnemonic.entity_mnemonic
               pcTableToCache  = ttEntityMnemonic.entity_mnemonic_description.
    ELSE
        RETURN "ADM-ERROR":U.
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* cacheEntity */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cacheEntityDisplayFields Include 
PROCEDURE cacheEntityDisplayFields :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Caches the fields for the entity passed in.  The procedure will:
               1) Retrieve the entity object and instances from the rep manager
               2) Populate the ttDataField table from the rep man cache.
  Parameters:  <none>
  Notes:       * This procedure retrieves the field information for a particular
                 entity, based on the information in the Repository.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcEntityToCache AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcTableToCache  AS CHARACTER  NO-UNDO.
        
    DEFINE VARIABLE cPropertyNames        AS CHARACTER                      NO-UNDO.
    DEFINE VARIABLE cPropertyValues       AS CHARACTER                      NO-UNDO.
    DEFINE VARIABLE cDataFields           AS CHARACTER                      NO-UNDO.
    DEFINE VARIABLE iDataFieldLoop        AS INTEGER                        NO-UNDO.
    DEFINE VARIABLE dInstanceId           AS DECIMAL                        NO-UNDO.
    
    /** First make sure that the entity has been cached.
     *  This needs to happen first because we want to resolve the parameters
     *  in such a way that we know that the pcEntityToCache has a correct value.
     *  ----------------------------------------------------------------------- **/
    RUN cacheEntity IN TARGET-PROCEDURE ( INPUT pcEntityToCache, INPUT pcTableToCache) NO-ERROR.

    /* First, we always want to work with the tablename.  If the user has only passed in an entity FLA, map it to a tablename */
    IF pcTableToCache EQ "":U OR pcTableToCache EQ ? THEN
        FIND ttEntityMnemonic WHERE ttEntityMnemonic.entity_mnemonic = pcEntityToCache NO-ERROR.
    ELSE
        FIND ttEntityMnemonic WHERE ttEntityMnemonic.entity_mnemonic_description = pcTableToCache NO-ERROR.

    IF AVAILABLE ttEntityMnemonic THEN
        ASSIGN pcEntityToCache = ttEntityMnemonic.entity_mnemonic
               pcTableToCache  = ttEntityMnemonic.entity_mnemonic_description.
    ELSE
        RETURN "ADM-ERROR":U.
    
    /** Check whether at least one field has been cached yet.
     *  ----------------------------------------------------------------------- **/
    IF CAN-FIND(FIRST ttEntityDisplayField WHERE ttEntityDisplayField.entity_mnemonic = pcEntityToCache) THEN
        RETURN.
        
    /* Since the information we are looking for is in the RepMan, check if it is alive ... */
    IF VALID-HANDLE(gshRepositoryManager) THEN
    DO:
        /* Get the entity information from the cache. */
        RUN getContainedInstanceNames IN gshRepositoryManager ( INPUT  pcTableToCache,
                                                                OUTPUT cDataFields    ) NO-ERROR.
        
        /* We need the instance ID of the Entity object so that we can be 100% sure of getting
           the contained instances. 
         */
        ASSIGN cPropertyNames = "InstanceId":U.
        RUN getInstanceProperties IN gshRepositoryManager ( INPUT        pcTableToCache,
                                                            INPUT        "":U,
                                                            INPUT-OUTPUT cPropertyNames,
                                                                  OUTPUT cPropertyValues ) NO-ERROR.
        ASSIGN dInstanceId = DECIMAL(ENTRY(LOOKUP("InstanceId":U, cPropertyNames), cPropertyValues, {&Value-Delimiter})) NO-ERROR.
        
        DO iDataFieldLoop = 1 TO NUM-ENTRIES(cDataFields):
            ASSIGN cPropertyNames  = "Order,Label,ColumnLabel,Format,Data-Type":U
                   cPropertyValues = "":U.
            
            RUN getInstanceProperties IN gshRepositoryManager ( INPUT        STRING(dInstanceId),
                                                                INPUT        ENTRY(iDataFieldLoop, cDataFields),
                                                                INPUT-OUTPUT cPropertyNames,
                                                                      OUTPUT cPropertyValues ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
                RETURN (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
            
            CREATE ttEntityDisplayField.
            ASSIGN ttEntityDisplayField.entity_mnemonic    = pcEntityToCache
                   ttEntityDisplayField.display_field_name = ENTRY(iDataFieldLoop, cDataFields).
            
            ASSIGN ttEntityDisplayField.display_field_order = INTEGER(ENTRY(LOOKUP("Order":U, cPropertyNames), cPropertyValues, {&Value-Delimiter})) NO-ERROR.
            ASSIGN ttEntityDisplayField.display_field_label = ENTRY(LOOKUP("Label":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.
            ASSIGN ttEntityDisplayField.display_field_column_label = ENTRY(LOOKUP("ColumnLabel":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.
            ASSIGN ttEntityDisplayField.display_field_format = ENTRY(LOOKUP("Format":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.
            ASSIGN ttEntityDisplayField.display_field_datatype = ENTRY(LOOKUP("Data-Type":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.
        END.    /* loop through data fields */
    END.    /* valid Repository Manager */
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* cacheEntityDisplayFields */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cacheEntityMapping Include 
PROCEDURE cacheEntityMapping :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcEntity AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcTable  AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttEntityMap.

&IF DEFINED(server-side) = 0 &THEN
    RUN af/app/afgencchentmapp.p ON gshAstraAppServer
      (INPUT pcEntity,
       INPUT pcTable,
       OUTPUT TABLE ttEntityMap) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
        RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                        ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
&ELSE
    {af/app/afgencchentmapp.i}
&ENDIF

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.
END PROCEDURE.  /* cacheEntityMapping */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkIfOverlaps Include 
PROCEDURE checkIfOverlaps :
/*-----------------------------------------------------------------------------------------------------------
  Purpose:  Check if any record in a specified table exists that would overlap with a specified date range
  
  Parameters:  INPUT  pcTable             - Name of table to do search on
               INPUT  pcKeyField          - Name of the keyfield to use in search (Most probably foreign-key)
               INPUT  ptFromField         - Name of the 'from field', i.e. from_date / admission_date
               INPUT  ptToField           - Name of the 'to field',   i.e. to_date   / discharge_date
               INPUT  pdCurrentRecordObj  - Obj value of current record - just to ensure that you don't compare
                                            values to the same record when modifying
               INPUT  pdKeyValue          - Value of the keyfield,    i.e. obj number
               INPUT  ptFromValue         - Value to compare from
               INPUT  ptToValue           - Value to compare to
               INPUT  pcAdditionalWhere   - Addtional where clause that can be added to the query if needed
                      *** REMEMBER: It creates a buffer for pcTable, thus if you passed in gsm_person, the created
                                    buffer will be bgsm_person. In pcAdditionalWhere remember to use the prefixed
                                    'b' in your criteria specification
               OUTPUT plOverlap           - Logical value specifying if overlapping was found
               OUTPUT ptOverlapFrom       - Null(?) if no overlapping, otherwise from date of overlapping record
               OUTPUT ptOverlapTo         - Null(?) if no overlapping, otherwise to   date of overlapping record
  Notes:       
----------------------------------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcTable             AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcKeyField          AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcFromField         AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcToField           AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pdCurrentRecordObj  AS DECIMAL    NO-UNDO.
    DEFINE INPUT  PARAMETER pdKeyValue          AS DECIMAL    NO-UNDO.
    DEFINE INPUT  PARAMETER ptFromValue         AS DATE       NO-UNDO.
    DEFINE INPUT  PARAMETER ptToValue           AS DATE       NO-UNDO.
    DEFINE INPUT  PARAMETER pcAdditionalWhere   AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER plOverlap           AS LOGICAL    NO-UNDO.
    DEFINE OUTPUT PARAMETER ptOverlapFrom       AS DATE       NO-UNDO.
    DEFINE OUTPUT PARAMETER ptOverlapTo         AS DATE       NO-UNDO.

    &IF DEFINED(server-side) = 0 &THEN
    RUN af/app/afgenchkifovrlpp.p ON gshAstraAppServer
        (INPUT pcTable,
         INPUT pcKeyField,
         INPUT pcFromField,
         INPUT pcToField,
         INPUT pdCurrentRecordObj,
         INPUT pdKeyValue,
         INPUT ptFromValue,
         INPUT ptToValue,
         INPUT pcAdditionalWhere,
         OUTPUT plOverlap,
         OUTPUT ptOverlapFrom,
         OUTPUT ptOverlapTo) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
        RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                        ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    &ELSE
    DEFINE VARIABLE cWidgetPool           AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cValueBuffer          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cQueryPrepareString   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cObjFieldName         AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dRecordObj            AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE hQuery                AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hBuffer               AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hFromField            AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hToField              AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hObjField             AS HANDLE     NO-UNDO.
    DEFINE VARIABLE tFromValue            AS DATE       NO-UNDO.
    DEFINE VARIABLE tToValue              AS DATE       NO-UNDO.
    
    ASSIGN cWidgetPool       = "queryWidgets":U
           cValueBuffer      = "b":U + pcTable
           pcAdditionalWhere = TRIM(pcAdditionalWhere)
           plOverlap         = FALSE
           
           cQueryPrepareString = "FOR EACH ":U + cValueBuffer + " NO-LOCK":U
                               + "   WHERE ":U + cValueBuffer + ".":U + pcKeyField  + " = ":U + QUOTER(STRING(pdKeyValue))
                               +         " ":U + pcAdditionalWhere
                               + "      BY ":U + cValueBuffer + ".":U + pcFromField + " INDEXED-REPOSITION":U.
    
    CREATE WIDGET-POOL cWidgetPool.
    
    CREATE QUERY  hQuery IN WIDGET-POOL cWidgetPool.
    CREATE BUFFER hBuffer FOR TABLE pcTable BUFFER-NAME cValueBuffer IN WIDGET-POOL cWidgetPool.
    
    IF NOT hQuery:ADD-BUFFER(hBuffer) THEN
    DO:
        DELETE WIDGET-POOL cWidgetPool.
        RETURN ERROR "Error setting Buffer for Dynamic Query":U.
    END. /* Can't add Buffer */
  
    IF NOT hQuery:QUERY-PREPARE(cQueryPrepareString) THEN
    DO:
        DELETE WIDGET-POOL cWidgetPool.
        RETURN ERROR "Error preparing Query":U.
    END. /* Can't prepare Query */
  
    ASSIGN hFromField = hBuffer:BUFFER-FIELD(pcFromField)
           hToField   = hBuffer:BUFFER-FIELD(pcToField) NO-ERROR.
  
    IF NOT VALID-HANDLE(hFromField) AND
       NOT VALID-HANDLE(hToField) THEN
    DO:
        DELETE WIDGET-POOL cWidgetPool.
        RETURN ERROR "Error finding from and to Fields in Query":U.
    END. /* Can't find specified from and to Fields in Query */
  
    ASSIGN cObjFieldName     = getObjField(getTableDumpName(hBuffer:DBNAME + "|" + pcTable))
           hObjField  = hBuffer:BUFFER-FIELD(cObjFieldName) NO-ERROR.
  
    IF NOT VALID-HANDLE(hObjField) THEN
    DO:
        DELETE WIDGET-POOL cWidgetPool.
        RETURN ERROR "Error finding obj Field in Query":U.
    END. /* Can't find specified obj Field in Query */
    
    /* Loop through records and see if there are any records that overlap */
    IF NOT hQuery:QUERY-OPEN THEN
    DO:
        DELETE WIDGET-POOL cWidgetPool.
        RETURN ERROR "Error opening Query":U.
    END.    /* Can't Open Query */
    
    hQuery:GET-FIRST(NO-LOCK).
    DO WHILE hBuffer:AVAILABLE:
      
      ASSIGN tFromValue = hFromField:BUFFER-VALUE()
             tToValue   = hToField:BUFFER-VALUE()
             dRecordObj = hObjField:BUFFER-VALUE().
      
      IF dRecordObj = pdCurrentRecordObj THEN
      DO:
          hQuery:GET-NEXT(NO-LOCK).
          NEXT.
      END.
      
      IF tToValue = ? THEN
      DO:
        IF (ptFromValue >= tFromValue) OR     /* RecordFromDate --------------------> ? */
                                              /*                CompareFromDate ------> */
         
           (ptToValue   <> ?           AND    /* RecordFromDate ----------> ? */
            ptToValue   >= tFromValue) OR     /* -------------> CompareToDate */
         
           (ptFromValue <  tFromValue  AND    /*                 RecordFromDate ------> */
            ptToValue   = ?)           THEN   /* CompareFromDate -------------------> ? */
        
        ASSIGN plOverlap = TRUE.
      END.
      ELSE
      DO:
        IF (ptToValue   = ?              AND
           (tFromValue >= ptFromValue    OR   /*                 RecordFromDate ------> */
                                              /* CompareFromDate -------------------> ? */
            
            tToValue   >= ptFromValue))       /* <-------------- RecordToDate */
                                              /* CompareFromDate ---------> ? */
        OR (ptToValue  <> ?              AND  
          ((tFromValue >= ptFromValue    AND  /*                 RecordFromDate ------------> */
            tFromValue <= ptToValue)     OR   /* CompareFromDate <------------> CompareToDate */
           
           (tFromValue <= ptFromValue    AND  /* RecordFromDate <-------------> RecordToDate */
            tToValue   >= ptFromValue))) THEN /*                CompareFromDate -----------> */
            
          ASSIGN plOverlap = TRUE.
      END.
      
      IF plOverlap = TRUE THEN LEAVE.
      
      hQuery:GET-NEXT(NO-LOCK).
    END.
    
    IF plOverlap = TRUE THEN
      ASSIGN ptOverlapFrom = tFromValue
             ptOverlapTo   = tToValue.
    ELSE
      ASSIGN ptOverlapFrom = ?
             ptOverlapTo   = ?.
  
    /* Clean up all Widgets used in this Procedure. */
    DELETE WIDGET-POOL cWidgetPool.
  &ENDIF

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDBsForImportedEntities Include 
PROCEDURE getDBsForImportedEntities :
/*------------------------------------------------------------------------------
  Purpose:     Scans through the entity mnemonic table and returns a comma delimited
               list of all databases for which entities have been imported.
  Parameters:  plOnlyUseCache - If set to YES, only the current session entity cache will
                                be used to build the database list.  If set to NO, the list
                                will be built from the database gsc_entity_mnemonic records.
               pcDBList       - The list of databases for which entities have been imported.
  Notes:       In certain circumstances, we don't need the names of the connected
               databases, but rather the names of all databases that entities have
               been imported for.  This is what this API is for. This API must also take
               cognisance of whether we are allowed to return repository data.
------------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER plOnlyUseCache   AS LOGICAL    NO-UNDO. /* Redundant */
DEFINE OUTPUT       PARAMETER pcDBList         AS CHARACTER  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcAdditionalInfo AS CHARACTER  NO-UNDO. /* Not used yet, but we may need it later */

&IF DEFINED(server-side) = 0 &THEN /* we're client side, pass the request to the Appserver */
    RUN af/app/afgengtdbfrimpentp.p ON gshAstraAppServer
       (INPUT plOnlyUseCache,
        OUTPUT pcDBList,
        INPUT-OUTPUT pcAdditionalInfo) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
        RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                        ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

&ELSE
    DEFINE VARIABLE cFilterSetCode  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lRepository     AS LOGICAL    NO-UNDO.

    cFilterSetCode = {fn getSessionFilterSet}. /* The function is located in the GenManager */

    FOR EACH gsc_entity_mnemonic NO-LOCK
       BREAK BY gsc_entity_mnemonic.entity_dbname:
        IF FIRST-OF(gsc_entity_mnemonic.entity_dbname) THEN
        DO:
          IF cFilterSetCode <> "":U THEN
            lRepository = CAN-DO("ICFDB,RTB,RVDB,TEMP-DB":U, gsc_entity_mnemonic.entity_dbname).
          ELSE
            lRepository = FALSE.

          IF NOT lRepository THEN
            pcDBList = pcDBList + ",":U + gsc_entity_mnemonic.entity_dbname.
        END.
    END.
    ASSIGN pcDBList = SUBSTRING(pcDBList, 2) NO-ERROR.
&ENDIF

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDBVersion Include 
PROCEDURE getDBVersion :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to return the database version number from the database
               sequence initial value - where the sequence name must match the 
               naming convention - seq_<dblogical>_dbversion, e.g.
               seq_icfdb_dbversion
  Parameters:  input comma list of database logical names, e.g. ICFDB, RVDB
               output database version as character, e.g. 020005, 020006
  Notes:       A UDP exists in ERwin model called DBVersion that causes this
               sequence to be created and updated with the correct value when a
               delta is generated.
               This is used by the install and the help about window currently.
               If a sequence with the appropriate name is not found for a passed
               in database, the version number will be returned as 000000.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pcLogicalNames         AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcVersions            AS CHARACTER NO-UNDO.

&IF DEFINED(server-side) = 0 &THEN
    RUN af/app/afgengtdbverp.p ON gshAstraAppServer
       (INPUT pcLogicalNames,
        OUTPUT pcVersions) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
        RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                        ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
&ELSE    
  DEFINE VARIABLE hQuery              AS HANDLE                   NO-UNDO.
  DEFINE VARIABLE hField              AS HANDLE                   NO-UNDO.
  DEFINE VARIABLE hDbBuffer           AS HANDLE                   NO-UNDO.
  DEFINE VARIABLE hFileBuffer         AS HANDLE                   NO-UNDO.
  DEFINE VARIABLE cWidgetPool         AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE cQuerystring        AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE cDbBufferName       AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE cFileBufferName     AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE cLogicalName        AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE cVersion            AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE cWhere              AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE iLoop               AS INTEGER                  NO-UNDO.

  ASSIGN cWidgetPool  = "_sequence":U.

  CREATE WIDGET-POOL cWidgetPool.

  db-loop:
  DO iLoop = 1 TO NUM-ENTRIES(pcLogicalNames):

    ASSIGN
      cLogicalName = ENTRY(iLoop, pcLogicalNames)
      cVersion     = "000000":U
      hDbBuffer    = ?
      .

    /* try and find database version number */
    ASSIGN cDbBufferName   = cLogicalName + "._Db":U
           cFileBufferName = cLogicalName + "._Sequence":U
           cQuerystring    = "FOR EACH ":U + cDbBufferName + " NO-LOCK, ":U
                           + " EACH " + cFileBufferName + " WHERE ":U
                           +   cFileBufferName + "._Db-recid  = RECID(_Db) AND ":U
                           +   cFileBufferName + "._seq-name = '":U + "seq_":U + cLogicalName + "_dbversion":U + "'"
                           + " NO-LOCK ":U.

    CREATE BUFFER hDbBuffer    FOR TABLE cDbBufferName NO-ERROR.
    IF VALID-HANDLE(hDbBuffer) THEN
    DO:
      CREATE BUFFER hFileBuffer  FOR TABLE cFileBufferName.
      CREATE QUERY hQuery IN WIDGET-POOL cWidgetPool.
      hQuery:SET-BUFFERS(hDbBuffer,hFileBuffer).
      hQuery:QUERY-PREPARE(cQueryString).
      hQuery:QUERY-OPEN().
      hQuery:GET-FIRST(NO-LOCK).
      IF hFileBuffer:AVAILABLE THEN
          ASSIGN hField          = hFileBuffer:BUFFER-FIELD("_seq-max":U)
                 cVersion       = TRIM(hField:STRING-VALUE)
                 .
      IF cVersion = "":U OR cVersion = ? THEN
        ASSIGN cVersion = "000000":U.

      /* tidy up for next time */
      hQuery:QUERY-CLOSE.
      DELETE OBJECT hDbBuffer NO-ERROR.
      ASSIGN hDbBuffer = ?.
      DELETE OBJECT hFileBuffer NO-ERROR.
      ASSIGN hFileBuffer = ?.
    END.

    /* add to list of versions */  
    ASSIGN pcVersions = pcVersions + (IF pcVersions = "":U THEN "":U ELSE ",":U) +
                        cVersion.
  
  END. /* db-loop: loop of database logical names */

  DELETE WIDGET-POOL cWidgetPool.

&ENDIF

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDumpName Include 
PROCEDURE getDumpName :
/*------------------------------------------------------------------------------
  Purpose:     To see if a specified table exists in a database
  Parameters:  pcQuery
               pcTableDumpName
               
  Notes:       The input parameter has two entries pipe ("|") delimited:
               Entry 1 - Database name
               Entry 2 - Table name
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcQuery          AS CHARACTER               NO-UNDO.
  DEFINE OUTPUT PARAMETER pcTableDumpName  AS CHARACTER               NO-UNDO.

  /* Make sure the entity is cached */
  RUN cacheEntity IN TARGET-PROCEDURE ("":U,                    /* We don't know what the entity FLA is */
                                       ENTRY(2,pcQuery,"|":U)). /* Tablename */

  FIND FIRST ttEntityMnemonic
       WHERE ttEntityMnemonic.entity_mnemonic_description = ENTRY(2,pcQuery,"|":U)
       AND   ttEntityMnemonic.entity_dbname               = IF TRIM(ENTRY(1,pcQuery,"|":U)) <> "":U THEN TRIM(ENTRY(1,pcQuery,"|":U)) ELSE ttEntityMnemonic.entity_dbname
       NO-ERROR.
  IF AVAILABLE ttEntityMnemonic THEN
    pcTableDumpName = ttEntityMnemonic.entity_mnemonic.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEntityDescription Include 
PROCEDURE getEntityDescription :
/*------------------------------------------------------------------------------
  Purpose:     Returns the reference number, -code or similar description field
  Parameters:  pcEntityMnemonic
               pdEntityObj
               pcFieldName
               pcEntityDescriptor
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcEntityMnemonic        AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pdEntityObj             AS DECIMAL    NO-UNDO.
    DEFINE INPUT  PARAMETER pcFieldName             AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcEntityDescriptor      AS CHARACTER  NO-UNDO.

    &IF DEFINED(server-side) = 0 &THEN
        RUN af/app/afgengtentdescp.p ON gshAstraAppServer
           (INPUT pcEntityMnemonic,
            INPUT pdEntityObj,
            INPUT pcFieldName,
            OUTPUT pcEntityDescriptor) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
          RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                        ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    &ELSE
    DEFINE VARIABLE cQueryPrepareString             AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cTableObjectFieldName           AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hQuery                          AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hBuffer                         AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hDescriptionField               AS HANDLE       NO-UNDO.

    /* Make sure the entity is cached */
    RUN cacheEntity IN TARGET-PROCEDURE (pcEntityMnemonic, /* Table FLA */
                                         "":U).            /* Tablename */

    FIND ttEntityMnemonic WHERE
         ttEntityMnemonic.entity_mnemonic = pcEntityMnemonic
         NO-ERROR.

    IF NOT AVAILABLE ttEntityMnemonic THEN
        RETURN ERROR "ADM-ERROR":U.

    /* Find the description field */
    ASSIGN cTableObjectFieldName = getObjField(pcEntityMnemonic)
           cQueryPrepareString   = "FOR EACH " + ttEntityMnemonic.entity_mnemonic_description + " WHERE "
                                 +  TRIM(ttEntityMnemonic.entity_mnemonic_description) + ".":U  + cTableObjectFieldName
                                 + " = ":U
                                 + QUOTER(STRING(pdEntityObj))
                                 + " NO-LOCK ".

    /* Create the neccessary widgets in a named widget pool.
     * All of the widgets/handles/buffers etc created in this procedure are created in
     * this widget pool. This is because when we delete the widget pool at the procedure's end,
     * or at any other stage, we are assured that all of the widgets in that pool are deleted,
     *  and so we don't have to clean them up (delete them) manually.
     */
    CREATE WIDGET-POOL "queryWidgets":U.
    CREATE QUERY  hQuery IN WIDGET-POOL "queryWidgets":U.

    CREATE BUFFER hBuffer FOR TABLE ttEntityMnemonic.entity_mnemonic_description IN WIDGET-POOL "queryWidgets":U.
    IF NOT hQuery:ADD-BUFFER(hBuffer) THEN
    DO:
        DELETE WIDGET-POOL "queryWidgets":U.
        RETURN ERROR "ADM-ERROR":U.
    END.    /* can't add buffer */

    IF NOT hQuery:QUERY-PREPARE(cQueryPrepareString) THEN
    DO:
        DELETE WIDGET-POOL "queryWidgets":U.
        RETURN ERROR "ADM-ERROR":U.
    END.    /* can't prepare query */

    /* Determine what the description field is - may be a specific field name. */
    ASSIGN hDescriptionField = hBuffer:BUFFER-FIELD(pcFieldName) NO-ERROR.
    IF NOT VALID-HANDLE(hDescriptionField) THEN
        ASSIGN hDescriptionField = hBuffer:BUFFER-FIELD(ttEntityMnemonic.entity_description_field) NO-ERROR.

    IF NOT VALID-HANDLE(hDescriptionField) THEN
    DO:
        DELETE WIDGET-POOL "queryWidgets":U.
        RETURN.
    END. /* no descriptor */

    IF NOT hQuery:QUERY-OPEN THEN
    DO:
        DELETE WIDGET-POOL "queryWidgets":U.
        RETURN.
    END.    /* query can't open */

    hQuery:GET-FIRST(NO-LOCK).
    IF hBuffer:AVAILABLE THEN
        ASSIGN pcEntityDescriptor = hDescriptionField:BUFFER-VALUE() NO-ERROR.

    /* Clean up all widgets used in this procedure. */
    DELETE WIDGET-POOL "queryWidgets":U.

    &ENDIF

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEntityDetail Include 
PROCEDURE getEntityDetail :
/*------------------------------------------------------------------------------
  Purpose    : Returns information about an entity.
  Parameters : pcEntity       - the entity mnemonic 
                              - optionally add a comma separated list of fields 
                                to specify that only certain values should be 
                                retrieved.                                 
               pcEntityFields - CHR(1)-delimited list of the entity mnemonic 
                                field names.
               pcEntityValues - CHR(1)-delimited list of the values of the above.
    Notes:   * This function uses the cached GSC-ENTITY-MNEMONIC table. If no
               record exists in the cache, then the return valeus are blank.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcEntity            AS CHARACTER            NO-UNDO.
    DEFINE OUTPUT PARAMETER pcEntityFields      AS CHARACTER            NO-UNDO.
    DEFINE OUTPUT PARAMETER pcEntityValues      AS CHARACTER            NO-UNDO.

    DEFINE VARIABLE hBuffer                         AS HANDLE           NO-UNDO.
    DEFINE VARIABLE iFieldLoop                      AS INTEGER          NO-UNDO.    
    DEFINE VARIABLE hCurrentField                   AS HANDLE           NO-UNDO.
    DEFINE VARIABLE lTableCached                    AS LOGICAL          NO-UNDO.
    DEFINE VARIABLE lDescCached                     AS LOGICAL          NO-UNDO.
    DEFINE VARIABLE cEntity                         AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE lFieldList                      AS LOGICAL          NO-UNDO.
    DEFINE VARIABLE iNumFields                      AS INTEGER          NO-UNDO.
    
&SCOPED-DEFINE assignfieldlist ~
  DO iFieldLoop = 1 TO iNumFields:~
    ASSIGN hCurrentField = IF lFieldList~
                           THEN hBuffer:BUFFER-FIELD(ENTRY(iFieldLoop + 1,pcEntity))~
                           ELSE hBuffer:BUFFER-FIELD(iFieldLoop)~
           pcEntityFields = pcEntityFields + CHR(1) + hCurrentField:NAME~
           pcEntityValues = pcEntityValues + CHR(1) + IF hCurrentField:BUFFER-VALUE <> ? THEN hCurrentField:BUFFER-VALUE ELSE "":U NO-ERROR.~
    IF ERROR-STATUS:ERROR THEN RETURN ERROR ERROR-STATUS:GET-MESSAGE(1).~
  END.

 /* ********/

    ASSIGN
      /* optional list of fields */
      cEntity      = ENTRY(1,pcEntity)
      lTableCached = CAN-FIND(FIRST ttEntityMnemonic WHERE ttEntityMnemonic.entity_mnemonic = cEntity)
      lDescCached  = NOT lTableCached AND CAN-FIND(FIRST ttEntityMnemonic WHERE ttEntityMnemonic.entity_mnemonic_description = cEntity)
      .

    IF NOT lTableCached AND NOT lDescCached THEN
    DO:
      /* Make sure the entity is cached */
      RUN cacheEntity IN TARGET-PROCEDURE ("":U, /* Table FLA */
                                           cEntity).    /* Tablename */
      IF NOT CAN-FIND(FIRST ttEntityMnemonic
                      WHERE ttEntityMnemonic.entity_mnemonic = cEntity) THEN
        RUN cacheEntity IN TARGET-PROCEDURE (cEntity, /* Table FLA */
                                             "":U).    /* Tablename */
    END.
    
    ASSIGN 
      lFieldList = NUM-ENTRIES(pcEntity) > 1
      hBuffer    = BUFFER ttEntityMnemonic:HANDLE
      iNumFields = IF lFieldList THEN NUM-ENTRIES(pcEntity) - 1
                   ELSE hBuffer:NUM-FIELDS
      .

    IF lTableCached OR CAN-FIND(ttEntityMnemonic WHERE ttEntityMnemonic.entity_mnemonic = cEntity) THEN
    FOR EACH ttEntityMnemonic WHERE ttEntityMnemonic.entity_mnemonic = cEntity:
      {&assignfieldList}
    END.
    ELSE 
    FOR EACH ttEntityMnemonic WHERE ttEntityMnemonic.entity_mnemonic_description = cEntity:
      {&assignfieldList}
    END.
    &UNDEFINE assignfieldList
    /* remove delimiter in front */
    IF pcEntityFields BEGINS CHR(1) THEN
      ASSIGN
        pcEntityFields = SUBSTR(pcEntityFields,2)
        pcEntityValues = SUBSTR(pcEntityValues,2).

    RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEntityDisplayField Include 
PROCEDURE getEntityDisplayField :
/*------------------------------------------------------------------------------
  Purpose:     Returns the value defined in the entity_description_field
               using the pcOwningValue passed in for the fields in 
               either entity_object_field or entity_key_field
               
  Parameters:  pcEntityMnemonic
               pcOwningValue
               pcEntityDescriptor
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcEntityMnemonic        AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcOwningValue           AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcEntityLabel           AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcEntityDescriptor      AS CHARACTER  NO-UNDO.

    &IF DEFINED(server-side) = 0 &THEN
        RUN af/app/afgengtentdispfldp.p ON gshAstraAppServer
           (INPUT pcEntityMnemonic,
            INPUT pcOwningValue,
            OUTPUT pcEntityLabel,
            OUTPUT pcEntityDescriptor) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
          RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                        ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    &ELSE
    DEFINE VARIABLE cQueryPrepareString             AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cTableObjectFieldName           AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hQuery                          AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hBuffer                         AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hDescriptionField               AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hCurrentField                   AS HANDLE       NO-UNDO.
    DEFINE VARIABLE iLoop                           AS INTEGER      NO-UNDO.
    DEFINE VARIABLE cWhereClause                    AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cFieldname                      AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hField                          AS HANDLE       NO-UNDO.
    DEFINE VARIABLE lOk                             AS LOGICAL      NO-UNDO.

    /* Make sure the entity is cached */
    RUN cacheEntity IN TARGET-PROCEDURE (pcEntityMnemonic, /* Table FLA */
                                         "":U).            /* Tablename */

    FIND ttEntityMnemonic WHERE
         ttEntityMnemonic.entity_mnemonic = pcEntityMnemonic
         NO-ERROR.
    IF NOT AVAILABLE ttEntityMnemonic THEN
        RETURN ERROR "ADM-ERROR":U.

    /* Create the neccessary widgets in a named widget pool.
     * All of the widgets/handles/buffers etc created in this procedure are created in
     * this widget pool. This is because when we delete the widget pool at the procedure's end,
     * or at any other stage, we are assured that all of the widgets in that pool are deleted,
     *  and so we don't have to clean them up (delete them) manually.
     */
    CREATE WIDGET-POOL "queryWidgets":U.
    CREATE QUERY  hQuery IN WIDGET-POOL "queryWidgets":U.

    CREATE BUFFER hBuffer FOR TABLE ttEntityMnemonic.entity_mnemonic_description IN WIDGET-POOL "queryWidgets":U.
    IF NOT hQuery:ADD-BUFFER(hBuffer) THEN
    DO:
        DELETE WIDGET-POOL "queryWidgets":U.
        RETURN ERROR "ADM-ERROR":U.
    END.    /* can't add buffer */


    /*Build the where clause*/
    IF ttEntityMnemonic.table_has_object_field THEN
      ASSIGN
        cWhereClause = TRIM(ttEntityMnemonic.entity_mnemonic_description) + ".":U  + TRIM(ttEntityMnemonic.entity_object_field) + 
                       " = ":U + quoter(pcOwningValue).
    ELSE IF NUM-ENTRIES(ttEntityMnemonic.entity_key_field) = NUM-ENTRIES(pcOwningValue,CHR(1)) THEN DO:
      IF VALID-HANDLE(hBuffer) THEN DO iLoop = 1 TO NUM-ENTRIES(ttEntityMnemonic.entity_key_field):
        ASSIGN
          cFieldName = TRIM(ENTRY(iLoop,ttEntityMnemonic.entity_key_field))
          hField     = hBuffer:BUFFER-FIELD(cFieldName).

        /* hField was being used to test for the DATA-TYPE of the field 
           to determine whether to use quotes or not for pcOwningValue.
           Since the QUOTER function is used now, hField may not be needed,
           however, it is left to prevent side effects if the field was
           invalid.
         */
        IF VALID-HANDLE(hField) THEN DO: 
          ASSIGN
            cWhereClause = cWhereClause + " AND ":U WHEN cWhereClause <> "":U
            cWhereClause = cWhereClause + TRIM(ttEntityMnemonic.entity_mnemonic_description) + ".":U  + cFieldName +
                           " = ":U + QUOTER(ENTRY(iLoop,pcOwningValue,CHR(1))).
        END.
      END.
    END.
    ELSE 
      RETURN.

    /*Build the query string*/
    ASSIGN 
      cQueryPrepareString  = "FOR EACH " + ttEntityMnemonic.entity_mnemonic_description + " WHERE "
                             +  cWhereClause
                             + " NO-LOCK ".

    ASSIGN lOk = hQuery:QUERY-PREPARE(cQueryPrepareString) NO-ERROR.
    IF NOT lOk THEN
    DO:
        DELETE WIDGET-POOL "queryWidgets":U.
        RETURN ERROR "ADM-ERROR":U.
    END.    /* can't prepare query */

    /* Determine what the description field is - may be a specific field name. */
    ASSIGN hDescriptionField = hBuffer:BUFFER-FIELD(ttEntityMnemonic.entity_description_field) NO-ERROR.

    IF NOT VALID-HANDLE(hDescriptionField) THEN
    DO:
        DELETE WIDGET-POOL "queryWidgets":U.
        RETURN.
    END. /* no descriptor */

    IF NOT hQuery:QUERY-OPEN THEN
    DO:
        DELETE WIDGET-POOL "queryWidgets":U.
        RETURN.
    END.    /* query can't open */

    hQuery:GET-FIRST(NO-LOCK).
    IF hBuffer:AVAILABLE THEN
        ASSIGN 
          pcEntityDescriptor = hDescriptionField:BUFFER-VALUE() 
          pcEntityLabel      = hDescriptionField:LABEL 
          NO-ERROR.

    /* Clean up all widgets used in this procedure. */
    DELETE WIDGET-POOL "queryWidgets":U.

    &ENDIF

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEntityExists Include 
PROCEDURE getEntityExists :
/*-----------------------------------------------------------------------------
  Purpose:     Checks that the specified record exists.
  Parameters:  pcTableName
               pdTableObj
               plExists
               pcRejection
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcTableName            AS CHARACTER            NO-UNDO.
    DEFINE INPUT  PARAMETER pdTableObj             AS DECIMAL              NO-UNDO.
    DEFINE OUTPUT PARAMETER plExists               AS LOGICAL              NO-UNDO. 
    DEFINE OUTPUT PARAMETER pcRejection            AS CHARACTER            NO-UNDO.

    DEFINE VARIABLE cQueryPrepareString             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cTableObjectFieldName           AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE hQuery                          AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hBuffer                         AS HANDLE               NO-UNDO.

    &IF DEFINED(server-side) = 0 &THEN
        RUN af/app/afgengtentexstp.p ON gshAstraAppServer
           (INPUT pcTableName,
            INPUT pdTableObj,
            OUTPUT plExists,
            OUTPUT pcRejection) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
          RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                        ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    &ELSE
    /* Make sure the entity is cached */
    RUN cacheEntity IN TARGET-PROCEDURE (pcTableName, /* Table FLA, the parameter has been named incorrectly */
                                         "":U).       /* Tablename */
    
    /* Check whether a OEM has been passed in. */
    FIND ttEntityMnemonic WHERE
         ttEntityMnemonic.entity_mnemonic = pcTableName
         NO-ERROR.

    IF AVAILABLE ttEntityMnemonic THEN
        ASSIGN pcTableName = ttEntityMnemonic.entity_mnemonic_description.
    
    IF pdTableObj = ? THEN
       ASSIGN pdTableObj = 0.
    ASSIGN plExists                   = NO
           cTableObjectFieldName      = IF AVAILABLE ttEntityMnemonic THEN 
                                           getObjField(ttEntityMnemonic.entity_mnemonic)
                                        ELSE ( /* Use the old algorithm */
                                            TRIM(IF LENGTH(pcTableName) > 5 THEN 
                                                 SUBSTRING(pcTableName,5) + "_obj"
                                                 ELSE pcTableName))
           cQueryPrepareString        = "FOR EACH " + pcTableName + " WHERE "
                                      + TRIM(pcTableName) + ".":U  + cTableObjectFieldName + " = ":U + QUOTER(STRING(pdTableObj))
                                      + " NO-LOCK ".
    
    /* Create the neccessary widgets in a named widget pool.
     * All of the widgets/handles/buffers etc created in this procedure are  created in
     * this widget pool. This is because when we delete the widget pool at the procedure's end,
     * or at any other stage, we are assured that all of the widgets in that pool are deleted,
     *  and so we don't have to clean them up (delete them) manually.
     */
    CREATE WIDGET-POOL "query_widgets":U.
    CREATE QUERY  hQuery IN WIDGET-POOL "query_widgets":U.

    CREATE BUFFER hBuffer         FOR TABLE pcTableName             IN WIDGET-POOL "query_widgets":U.
    IF NOT hQuery:ADD-BUFFER(hBuffer) THEN
    DO:
        ASSIGN pcRejection = "Error setting buffers for dynamic query".
        DELETE WIDGET-POOL "query_widgets":U.
        RETURN.
    END.    /* can't add buffer */
    
    IF NOT hQuery:QUERY-PREPARE(cQueryPrepareString) THEN
    DO:
        ASSIGN pcRejection = "Error preparing dynamic query".
        DELETE WIDGET-POOL "query_widgets":U.
        RETURN.
    END.    /* can't prepare query */
    
    IF NOT hQuery:QUERY-OPEN THEN
    DO:
        ASSIGN pcRejection = "Error opening dynamic query".
        DELETE WIDGET-POOL "query_widgets":U.
        RETURN.
    END.    /* query can't open */
    
    hQuery:GET-FIRST(NO-LOCK).
    ASSIGN plExists = hBuffer:AVAILABLE.
    
    /* Clean up all widgets used in this procedure. */
    DELETE WIDGET-POOL "query_widgets":U.
&ENDIF
RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEntityFields Include 
PROCEDURE getEntityFields :
/*------------------------------------------------------------------------------
  Purpose:  Returns information about the fields in an entity.

  Parameters:  INPUT  pcEntity              - The name of the entity to retrieve fields for
               INPUT  pcTableName           - The name of the table  to retrieve fields for
               INPUT  plOrderAlphabetically - If 'no',  fields are ordered by field order.
                                              If 'yes', fields are ordered by field name
               OUTPUT pcFieldNames          - CHR(1)-delimited list of the names of the fields in the entity
               OUTPUT pcFieldOrders         - CHR(1)-delimited list of the order number that the fields appear in, in the entity
               OUTPUT pcFieldLabels         - CHR(1)-delimited list of the labels of the fields in the entity
               OUTPUT pcFieldColumnLabels   - CHR(1)-delimited list of the column-labels of the fields in the entity
               OUTPUT pcFieldFormats        - CHR(1)-delimited list of the formats of the fields in the entity
               OUTPUT pcFieldDataTypes      - CHR(1)-delimited list of the data-types of the fields in the entity

  Notes:  * This function uses the cached GSC-ENTITY-MNEMONIC table. If no
            record exists in the cache, then the return values are blank.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcEntity              AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcTableName           AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plOrderAlphabetically AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcFieldNames          AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcFieldOrders         AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcFieldLabels         AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcFieldColumnLabels   AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcFieldFormats        AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcFieldDataTypes      AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cTTFieldNames       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParameter          AS CHARACTER  NO-UNDO EXTENT 6.
  DEFINE VARIABLE cTempValue          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCounter            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iField              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hEntityFieldBuffer  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hEntityBuffer       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery              AS HANDLE     NO-UNDO.

  ASSIGN
      hEntityBuffer = {fnarg getEntityCacheBuffer "pcEntity, pcTableName"}                        /* Get the handle to the ENTITY buffer */
      cTTFieldNames = "display_field_name,display_field_order,display_field_label,":U
                    + "display_field_column_label,display_field_format,display_field_datatype":U. /* These are the fields we want values for from the buffer */

  IF VALID-HANDLE(hEntityBuffer) THEN
    IF pcEntity <> "":U AND
       pcEntity <> ?    THEN
      hEntityBuffer:FIND-FIRST("WHERE entity_mnemonic = ":U + QUOTER(pcEntity)) NO-ERROR.
    ELSE
      IF pcTableName <> "":U AND
         pcTableName <> ?    THEN
        hEntityBuffer:FIND-FIRST("WHERE entity_mnemonic_description = ":U + QUOTER(pcTableName)) NO-ERROR.

  IF VALID-HANDLE(hEntityBuffer) AND hEntityBuffer:AVAILABLE THEN
  DO:
    /* Get the handle to the entity FIELD buffer */
    hEntityFieldBuffer = {fnarg getEntityFieldCacheBuffer "hEntityBuffer:BUFFER-FIELD('entity_mnemonic':U):BUFFER-VALUE, ~
                                                           hEntityBuffer:BUFFER-FIELD('entity_mnemonic_description':U):BUFFER-VALUE"}.

    IF VALID-HANDLE(hEntityFieldBuffer) THEN
    DO:
      CREATE QUERY hQuery.

      /* Setup and prepare the query: Filter the entity field temp-table for the required entity and sort as required */
      hQuery:SET-BUFFERS(hEntityFieldBuffer).
      hQuery:QUERY-PREPARE("FOR EACH ":U + hEntityFieldBuffer:NAME
                           + " WHERE ":U + hEntityFieldBuffer:NAME + ".entity_mnemonic = ":U + QUOTER(hEntityBuffer:BUFFER-FIELD('entity_mnemonic':U):BUFFER-VALUE)
                           + "    BY ":U + hEntityFieldBuffer:NAME + (IF plOrderAlphabetically THEN ".display_field_name":U ELSE ".display_field_order":U)).
      hQuery:QUERY-OPEN().
      hQuery:GET-FIRST().

      DO WHILE NOT hQuery:QUERY-OFF-END:
        /* Assign the counter of the field we are at to ensure the delimiter is placed correctly */
        iField = iField + 1.

        /* Step through all the fields that need to be assigned as OUPUT PARAMETERs and assign them to the appropriate array extent for now */
        DO iCounter = 1 TO NUM-ENTRIES(cTTFieldNames):
          ASSIGN
              cTempValue           = TRIM(STRING(hEntityFieldBuffer:BUFFER-FIELD(ENTRY(iCounter, cTTFieldNames)):BUFFER-VALUE))
              cTempValue           = (IF cTempValue = ? THEN "?":U ELSE cTempValue)
              cParameter[iCounter] = cParameter[iCounter] + (IF iField = 1 THEN "":U ELSE CHR(1)) + cTempValue.
        END.

        /* Get the next field in the entity display field temp-table */
        hQuery:GET-NEXT.
      END.

      DELETE OBJECT hQuery.

      /* Assign the values of the OUTPUT PARAMETERs */
      ASSIGN
          pcFieldNames        = cParameter[1]
          pcFieldOrders       = cParameter[2]
          pcFieldLabels       = cParameter[3]
          pcFieldColumnLabels = cParameter[4]
          pcFieldFormats      = cParameter[5]
          pcFieldDataTypes    = cParameter[6].
    END.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEntityTableName Include 
PROCEDURE getEntityTableName :
/*------------------------------------------------------------------------------
  Purpose:  Returns the table name based on an entity
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcEntityMnemonic  AS CHARACTER                NO-UNDO.    
    DEFINE INPUT  PARAMETER pcLogicalDBName   AS CHARACTER                NO-UNDO.
    DEFINE OUTPUT PARAMETER pcEntityTablename AS CHARACTER                NO-UNDO.

    /* Make sure the entity is cached */
    RUN cacheEntity IN TARGET-PROCEDURE (pcEntityMnemonic, /* Table FLA */
                                         "":U).            /* Tablename */

    FIND FIRST ttEntityMnemonic
         WHERE ttEntityMnemonic.entity_mnemonic = pcEntityMnemonic
         AND   ttEntityMnemonic.entity_dbname   = IF TRIM(pcLogicalDBName) <> "":U THEN pcLogicalDBName ELSE ttEntityMnemonic.entity_dbname
         NO-ERROR.
    IF AVAILABLE ttEntityMnemonic THEN
      pcEntityTablename = ttEntityMnemonic.entity_mnemonic_description.
    
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFilterSetClause Include 
PROCEDURE getFilterSetClause :
/*------------------------------------------------------------------------------
  Purpose:  To build up a filter set clause based on the specified filter set and
            entities within a filterset
  
  Parameters:  INPUT-OUTPUT pcFilterSetCode       - Filter set we want to build/retrieve a clause for. If ?, "" or "?"
                                                    is sent, the filter set applicable to the session will be used
               INPUT        pcEntityList          - A comma seperated list entities we need to consider for the
                                                    given filter set when we construct our clause
               INPUT        pcBufferList          - A comma seperated list of corresponding buffer names for the listed
                                                    entities. If a buffer is not specified, the name is retrieved from
                                                    the supplied entity
               INPUT        pcAdditionalArguments - A carrot ('^') delimited list of additonal arguments that would be
                                                    considered when building the filter set clause - NOT IMPLEMENTED YET.
               OUTPUT       pcFilterSetClause     - The resolved clause for the given filter set and entities resolved
                                                    with the required buffer names

  Notes:  For an explanation of filter set parameter specification in a query string,
          refer to 'getFilterSetParameters' in this procedure.
          
          I am forcing the entity list to be specified. The reason for this is that
          new data could be added to the filter set on a continuing basis. This could
          invalidate a existing query string if we assumed an empty entity list meant
          that we should retrieve all entities for a given filter set.
          
           Note on pcAdditionalArguments:
           
           Currently, we not support the parameter yet, but it was added to avoid a
           signature change when we do get around to writing the code to support it.
           At that time, plans are to support something like 'getClassChildren'.
           This will, if an entity of GSCOT is passed in, check for all class
           children of the entity listed in the expression_value if the operator
           used in the expression is '=', '<>' or 'LOOKUP' or a specific record
           is selected. The idea behind a '^' delimited list is to allow it to
           grow if new requirements arise in future.
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER pcFilterSetCode       AS CHARACTER  NO-UNDO.
  DEFINE INPUT        PARAMETER pcEntityList          AS CHARACTER  NO-UNDO.
  DEFINE INPUT        PARAMETER pcBufferList          AS CHARACTER  NO-UNDO.
  DEFINE INPUT        PARAMETER pcAdditionalArguments AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT       PARAMETER pcFilterSetClause     AS CHARACTER  NO-UNDO.

  &IF DEFINED(server-side) = 0 &THEN
    DEFINE VARIABLE cFilterSetCode  AS CHARACTER  NO-UNDO.

    /* Check what filter set we are trying to get a clause for */
    cFilterSetCode = (IF pcFilterSetCode = "?":U OR
                         pcFilterSetCode = "":U  OR
                         pcFilterSetCode = ?     THEN {fn getSessionFilterSet} ELSE pcFilterSetCode).

    /* See if we have it cached - if not, go and fetch it */
    FIND FIRST ttFilterSetClause
         WHERE ttFilterSetClause.filter_set_code      = cFilterSetCode
           AND ttFilterSetClause.entity_list          = pcEntityList
           AND ttFilterSetClause.buffer_list          = pcBufferList
           AND ttFilterSetClause.additional_arguments = pcAdditionalArguments NO-ERROR.

    IF NOT AVAILABLE ttFilterSetClause THEN
    DO:
      /* Run the function in General Manager on the AppServer */
        RUN af/app/afgengtfltrsetclsp.p ON gshAstraAppServer
           (INPUT-OUTPUT pcFilterSetCode,
            INPUT pcEntityList,
            INPUT pcBufferList,
            INPUT pcAdditionalArguments,
            OUTPUT pcFilterSetClause) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
          RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                        ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

      /* If all was fine, create the record in the TEMP-TABLE */
      CREATE ttFilterSetClause.
      ASSIGN ttFilterSetClause.filter_set_code      = pcFilterSetCode
             ttFilterSetClause.entity_list          = pcEntityList
             ttFilterSetClause.buffer_list          = pcBufferList
             ttFilterSetClause.additional_arguments = pcAdditionalArguments
             ttFilterSetClause.filter_set_clause    = pcFilterSetClause.
    END.

    /* The record should be available. If not by the find, then by the create statement above */
    pcFilterSetClause = ttFilterSetClause.filter_set_clause.
  &ELSE   
    DEFINE VARIABLE cEntityObjField   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cFilterSetCode    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cEntityList       AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cBufferList       AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cTempClause       AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cDataType         AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cOperator         AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cBuffer           AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cField            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cValue            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iCounter          AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iLookup           AS INTEGER    NO-UNDO.
    DEFINE VARIABLE lTableHasObjField AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lNot              AS LOGICAL    NO-UNDO.

    /* Localize buffers for this procedure */
    DEFINE BUFFER gsc_entity_mnemonic FOR gsc_entity_mnemonic.
    DEFINE BUFFER gsm_filter_data     FOR gsm_filter_data.
    DEFINE BUFFER gsm_filter_set      FOR gsm_filter_set.

    /* If the filter set applicable to the session should be used, find out what it is */
    IF pcFilterSetCode = "?":U OR
       pcFilterSetCode = "":U  OR
       pcFilterSetCode = ?     THEN
      pcFilterSetCode = {fn getSessionFilterSet}. /* The function exists in the GenManager */

    cFilterSetCode = pcFilterSetCode.

    IF pcEntityList = "?":U OR
       pcEntityList = "":U  OR
       pcEntityList = ?     THEN
    DO:
      MESSAGE "Entities should be specified.".
      RETURN ERROR "ENTITY-FIELD SPECIFICATION":U.
    END.
    ELSE
      cEntityList = pcEntityList.

    IF pcBufferList = "?":U OR
       pcBufferList = "":U  OR
       pcBufferList = ?     THEN
      cBufferList = "":U.
    ELSE
      cBufferList = pcBufferList.

    /* Do CAN-FIND to check existance of gsmn_filter_set */
    FOR FIRST gsm_filter_set NO-LOCK
        WHERE gsm_filter_set.filter_set_code = cFilterSetCode,
         EACH gsm_filter_data NO-LOCK
        WHERE gsm_filter_data.filter_set_obj = gsm_filter_set.filter_set_obj
          AND (LOOKUP(gsm_filter_data.owning_entity_mnemonic, cEntityList) <> 0)
        BREAK
           BY gsm_filter_data.include_data
           BY gsm_filter_data.owning_entity_mnemonic
           BY gsm_filter_data.expression_field:

      /* Determine the buffer prefix */
      IF FIRST-OF(gsm_filter_data.owning_entity_mnemonic) THEN
      DO:
        FIND FIRST gsc_entity_mnemonic NO-LOCK
             WHERE gsc_entity_mnemonic.entity_mnemonic = gsm_filter_data.owning_entity_mnemonic NO-ERROR.

        /* If the entity record is not available, return with an error */

        ASSIGN
            lTableHasObjField = gsc_entity_mnemonic.table_has_object_field
            cEntityObjField   = gsc_entity_mnemonic.entity_object_field
            iLookup           = LOOKUP(gsm_filter_data.owning_entity_mnemonic, cEntityList)
            cBuffer           = (IF iLookup <> 0 AND NUM-ENTRIES(cBufferList) >= iLookup THEN TRIM(ENTRY(iLookup, cBufferList), ".":U) ELSE "":U)
            cBuffer           = (IF cBuffer = "":U THEN TRIM(gsc_entity_mnemonic.entity_mnemonic_description, ".":U) ELSE cBuffer)
            cBuffer           = TRIM(cBuffer).
      END.

      /* If an owning_reference was specified, then we should use that to construct the clause phrase instead of the expression information */
      IF gsm_filter_data.owning_reference <> "?":U AND
         gsm_filter_data.owning_reference <> "":U  AND
         gsm_filter_data.owning_reference <> ?     THEN
      DO:
        IF lTableHasObjField THEN
          /* If the table has an object field, then the reference value will point to a unique object number */
          cTempClause = "(":U + cBuffer + ".":U + cEntityObjField
                      + (IF gsm_filter_data.include_data THEN " = ":U ELSE " <> ":U)
                      + "'":U + TRIM(gsm_filter_data.owning_reference) + "')":U.
        ELSE
        DO:
          /* If the table does not have an object field, then we have the values from the key fields of that table. The key fields were stored
             in the expression value field to ensure the data remains correct even if an index change is made after the data has been captured.
             The value for these fields are stored in the owning_reference - CHR(4) delimited */
          cTempClause = "":U.

          blk_OwningReference:
          DO iCounter = 1 TO NUM-ENTRIES(gsm_filter_data.expression_value):
            cTempClause = cTempClause + (IF cTempClause = "":U THEN "":U ELSE "~nAND ":U)
                        + cBuffer + ".":U
                        + ENTRY(iCounter, gsm_filter_data.expression_value)         + " = '":U
                        + ENTRY(iCounter, gsm_filter_data.owning_reference, CHR(4)) + "'":U NO-ERROR.

            IF ERROR-STATUS:ERROR THEN
              LEAVE blk_OwningReference.
          END.

          /* If we have an error-status, then the data is not correct so do not generate a phrase for this record */
          IF ERROR-STATUS:ERROR THEN
            /* Clear the error-status and the temp clause */
            ASSIGN
                ERROR-STATUS:ERROR = FALSE
                cTempClause        = "":U.
          ELSE
          DO:
            /* Bracket the clause */
            cTempClause = "(":U + cTempClause + ")":U.

            /* Take cognisance of whether the data should be displayed or not */
            IF NOT gsm_filter_data.include_data THEN
              cTempClause = "(NOT ":U + cTempClause + ")":U.
          END.
        END.
      END.
      ELSE
      /* Build up the clause phrase from the expression information */
      DO:
        ASSIGN
            cOperator = TRIM(REPLACE(gsm_filter_data.expression_operator, "NOT ":U, "":U))          /* Extract the operator from the filter data      */
            cField    = TRIM(gsm_filter_data.expression_field)                                      /* Get the field name the filter data applies to  */
            cValue    = TRIM(gsm_filter_data.expression_value)                                      /* Get the value of the expression                */
            cValue    = (IF cOperator = "LOOKUP":U THEN REPLACE(cValue, "~n":U, "":U) ELSE cValue)  /* If we are doing a lookup, remove the newlines  */
            lNot      = (gsm_filter_data.expression_operator BEGINS "NOT ":U)
            lNot      = (IF NOT gsm_filter_data.include_data THEN (IF lNot THEN FALSE ELSE TRUE) ELSE lNot).  /* If we are to exclude data then we should invert the NOT on the expression */

        /* Depending on the operator, the clause would be constructed differently */
        CASE cOperator:
          /* Handle the LOOKUP operator */
          WHEN "LOOKUP":U THEN
            cTempClause = "(":U + (IF lNot THEN "NOT ":U ELSE "":U) + "LOOKUP(STRING(":U + cBuffer + ".":U + cField + "), '":U + cValue + "') <> 0)":U.

          /* Handle the MATCHES and BEGINS operators */
          WHEN "MATCHES":U OR
          WHEN "BEGINS":U  THEN
            cTempClause = "(":U + (IF lNot THEN "NOT ":U ELSE "":U) + "STRING(":U + cBuffer + ".":U + cField + ") ":U + cOperator + " '":U + cValue + "')":U.

          /* Handle all the remaining operators, this includes: =, <>, <, >, <=, >= */
          OTHERWISE
            cTempClause = "(":U + (IF lNot THEN "NOT ":U ELSE "":U) + cBuffer + ".":U + cField + " ":U + cOperator + " '":U + cValue + "')":U.
        END CASE.
      END.

      /* Add the temporary clause to the filter set clause, taking cognisance if the data should be included or excluded*/
      IF cTempClause <> "":U THEN
        pcFilterSetClause = pcFilterSetClause
                          + (IF pcFilterSetClause <> "":U THEN (IF gsm_filter_data.include_data THEN "~nOR ":U ELSE "~nAND ":U) ELSE "":U)
                          + cTempClause.
    END.

    /* Finally enusre that the filter set clause is bracketed AND, if there was no filter set clause (maybe
       the specified entity does not exist in the filter set), send back TRUE to ensure the filter set clause
       remains correct in syntax. */
    pcFilterSetClause = (IF pcFilterSetClause = "":U THEN " (TRUE) ":U ELSE " (":U + pcFilterSetClause + ") ":U).
  &ENDIF

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFilterSetParameters Include 
PROCEDURE getFilterSetParameters :
/*------------------------------------------------------------------------------
  Purpose:  This procedure only strips out the different parameters

  Parameters:  INPUT  pcFilterSetString     - Unresolved filter set phrase that should be analyzed
               OUTPUT pcFilterSetCode       - The filter set that should be used generate the filter set clause with
               OUTPUT pcEntityList          - Comma delimited list of entities to retrieve within the specified filter set
               OUTPUT pcBufferList          - Comma delimited list of overriding buffer-names of the specified entity list
               OUTPUT pcAdditionalArguments - Carrot ('^') delimited list of additional arguments that should be considered
                                              when constructing the filter set clause. NOTE: PLANNED - NOT YET SUPPORTED

  Notes:  The filter set phrase should be specified with an opening a square bracket ('[') and should be closed
          with a closing square bracket (']'). Resolving the parameters if they had a null or empty value is up
          to getFilterSetClause. pcAdditionalArguments has been added to avoid an API signature change in future
          but has not been catered for yet.

          IMPORTANT: Parameters for the filter set should be specified with an ampersand ('&'), a name and
                     an equals ('=') sign. The correct phrasing of the parameters should not contain any
                     spaces between the parameter and the '=' sign. They can be specified in any order
                     though. Blank values for parameters can be a string question mark (not a NULL!)
                     or an empty string.

                     The only valid parameters currently are (and are specified as): &FilterSet=
                                                                                     &EntityList=
                                                                                     &BufferList=
                                                                                     &AdditionalArguments=

  Examples: [&FilterSet=?|&EntityList=GSCPM,RYCSO|&BufferList=,b_ryc_smartobject]
            [&FilterSet=?|&EntityList=GSCOT|&AdditionalArguments=getClassChildren] *** PLANNED

------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFilterSetString     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcFilterSetCode       AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcEntityList          AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcBufferList          AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcAdditionalArguments AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cAdditionalArguments  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterSetCode        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntityList           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBufferList           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntry                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCounter              AS INTEGER    NO-UNDO.

  DO iCounter = 1 TO NUM-ENTRIES(pcFilterSetString, "|":U):
    cEntry = TRIM(ENTRY(iCounter, pcFilterSetString, "|":U), "[] ":U).

    IF cEntry BEGINS "&FilterSet=":U THEN
      cFilterSetCode = TRIM(REPLACE(cEntry, "&FilterSet=":U, "":U)).
    ELSE
      IF cEntry BEGINS "&EntityList=":U THEN
        cEntityList = TRIM(REPLACE(cEntry, "&EntityList=":U, "":U)).
      ELSE
        IF cEntry BEGINS "&BufferList=":U THEN
          cBufferList = TRIM(REPLACE(cEntry, "&BufferList=":U, "":U)).
        ELSE
          IF cEntry BEGINS "&AdditionalArguments=":U THEN
            cBufferList = TRIM(REPLACE(cEntry, "&AdditionalArguments=":U, "":U)).
  END.

  ASSIGN
      pcFilterSetCode       = cFilterSetCode
      pcEntityList          = cEntityList
      pcBufferList          = cBufferList
      pcAdditionalArguments = cAdditionalArguments.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLanguageText Include 
PROCEDURE getLanguageText :
/*------------------------------------------------------------------------------
  Purpose:     To retrieve the language text in the specified language. If a specific
               text tla is not specified, then all values for the specified language
               will be returned, pipe delimited. If the language is not specified, then
               the current login language will be used.
  Parameters:  INPUT  Category Type     CHARACTER
               INPUT  Category Group    CHARACTER
               INPUT  Category Subgroup CHARACTER
               INPUT  Text TLA          CHARACTER  <Optional> all if not passed in
               INPUT  Language obj      DECIMAL    <Optional> will default to login language
               INPUT  owning obj        DECIMAL    <Optional> may not be applicable
               INPUT  substitutions     CHARACTER  <Optional> if any required, pipe delimited
               OUTPUT Language Text     CHARACTER (pipe delimiter if multiple)
               OUTPUT Filename          CHARACTER (pipe delimiter if multiple)
  Notes:       Substitions if passed in will be made in the text wherever a placeholder
               is found, e.g. {1}, {2}, etc. They should be passed in pipe delimited.
               If the contents are empty, then a ? will be returned. The same goes for the
               filename.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcCategoryType      AS CHARACTER                   NO-UNDO.
    DEFINE INPUT  PARAMETER pcCategoryGroup     AS CHARACTER                   NO-UNDO.
    DEFINE INPUT  PARAMETER pcSubGroup          AS CHARACTER                   NO-UNDO.
    DEFINE INPUT  PARAMETER pcTextTla           AS CHARACTER                   NO-UNDO.
    DEFINE INPUT  PARAMETER pdLanguageObj       AS DECIMAL                     NO-UNDO.
    DEFINE INPUT  PARAMETER pdOwningObj         AS DECIMAL                     NO-UNDO.
    DEFINE INPUT  PARAMETER pcSubstitute        AS CHARACTER                   NO-UNDO.
    DEFINE OUTPUT PARAMETER pcLanguageText      AS CHARACTER                   NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFileName          AS CHARACTER                   NO-UNDO.

    &IF DEFINED(server-side) = 0 &THEN
        RUN af/app/afgengtlngtxtp.p ON gshAstraAppServer
           (INPUT pcCategoryType,
            INPUT pcCategoryGroup,
            INPUT pcSubGroup,
            INPUT pcTextTla,
            INPUT pdLanguageObj,
            INPUT pdOwningObj,
            INPUT pcSubstitute,
            OUTPUT pcLanguageText,
            OUTPUT pcFileName) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
          RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                        ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    &ELSE
    DEFINE VARIABLE iLoop                 AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iPosition             AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cLine                 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cContent              AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cSubstitute           AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cMessage              AS CHARACTER  NO-UNDO.

    DEFINE BUFFER gsc_language_text     FOR gsc_language_text.
    DEFINE BUFFER gsm_category          FOR gsm_category.
    
    ASSIGN
        pdOwningObj     = 0     WHEN pdOwningObj = ?
        pdLanguageObj   = 0     WHEN pdLanguageObj = ? 
        pcCategoryType  = "":U  WHEN pcCategoryType = ?
        pcCategoryGroup = "":U  WHEN pcCategoryGroup = ?
        pcSubGroup      = "":U  WHEN pcSubGroup = ?
        pcTextTla       = "":U  WHEN pcTextTla = ?
        pcLanguageText  = "":U
        pcFileName      = "":U
        .
    IF pdLanguageObj = 0 THEN
        ASSIGN pdLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                        INPUT "CurrentLanguageObj":U,
                                                        INPUT NO)
                                       ) NO-ERROR.
    
    IF pdLanguageObj = 0 THEN
    DO:
      FIND FIRST gsc_global_control NO-LOCK NO-ERROR.
      IF AVAILABLE gsc_global_control THEN
        ASSIGN pdLanguageObj = gsc_global_control.default_language_obj.
      ELSE
        ASSIGN pdLanguageObj = 0.
      END.
    
    IF pdLanguageObj = 0 THEN
        RETURN ERROR {aferrortxt.i 'AF' '39' '?' '?' "' default language'" }.   
    
    FIND FIRST gsm_category WHERE
               gsm_category.related_entity_mnemonic = "GSCLT":U            AND
               gsm_category.category_type           BEGINS pcCategoryType  AND
               gsm_category.category_group          BEGINS pcCategoryGroup AND
               gsm_category.category_subgroup       BEGINS pcSubGroup
               NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gsm_category THEN
        RETURN ERROR {aferrortxt.i 'AF' '39' '?' '?' "' category for GSCLT, Type, Group and Subgroup ' + pcCategoryType + ',' + pcCategoryGroup + ',' + pcSubGroup " }.
    
    FOR EACH gsc_language_text WHERE
             gsc_language_text.category_obj = gsm_category.category_obj AND
             gsc_language_text.language_obj = pdLanguageObj             AND
             gsc_language_text.owning_obj   = pdOwningObj               AND
             gsc_language_text.text_tla     BEGINS pcTextTla
             NO-LOCK:
        /* Can find a physical file */
        IF gsc_language_text.physical_file_name         <> "":U AND
           SEARCH(gsc_language_text.physical_file_name) <> ?    THEN
        DO:   /* Read in file contents */
            ASSIGN cContent = "":U.
            INPUT STREAM sInput FROM VALUE(gsc_language_text.physical_file_name) NO-ECHO.
            REPEAT:
                IMPORT STREAM sInput UNFORMATTED cLine.
                ASSIGN cContent = cContent + cLine + CHR(10).
            END.
            INPUT STREAM sInput CLOSE.
        END.    /* can find a physical file */
        ELSE
            ASSIGN cContent = gsc_language_text.text_content.

        IF LENGTH(cContent) = 0 THEN
            ASSIGN cContent = "?":U.

        /* Remove any pipes */
        ASSIGN cContent = REPLACE(cContent,"|":U,"":U).

        /* See if max length exceeded */
        IF gsc_language_text.max_length > 0 THEN
            ASSIGN cContent = TRIM(SUBSTRING(cContent,1,max_length)).
        
        /* Got contents  - do substitutions */
        IF pcSubstitute <> "":U THEN
        DO iLoop = 1 TO NUM-ENTRIES(pcSubstitute,"|":U):
            ASSIGN cSubstitute = "~{":U + STRING(iLoop) + "~}":U
                   cContent = REPLACE(cContent,cSubstitute,ENTRY(iLoop,pcSubstitute,"|":U)).
        END.    /* substitution loop */

        /* Add to output parameters */
        ASSIGN pcLanguageText = pcLanguageText + (IF pcLanguageText = "":U THEN "":U ELSE "|":U) + cContent
               pcFileName     = pcFileName + (IF pcFileName = "":U THEN "":U ELSE "|":U) +
                              (IF gsc_language_text.physical_file_name = "":U THEN "?":U ELSE gsc_language_text.physical_file_name)
               .
    END.    /* f/e lang text */
    &ENDIF
    
    RETURN.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRecordCheckAudit Include 
PROCEDURE getRecordCheckAudit :
/*------------------------------------------------------------------------------
  Purpose:     Check if Audit record exist for specific record.
  Parameters:  pcEntityMnemonic - Entity Mnemonic
               pcEntityObjField - Entity Mnemonic Object Field Value (STRING)
               plRowAuditExist  - Does a Audit Record Exist for this record.
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcEntityMnemonic  AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pcEntityObjField  AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pcEntityObjValue  AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER plRowAuditExist   AS LOGICAL   NO-UNDO.

  &IF DEFINED(server-side) = 0 &THEN
     RUN af/app/afgengtrecchkaudp.p ON gshAstraAppServer
             (INPUT pcEntityMnemonic,
              INPUT pcEntityObjField,
              INPUT pcEntityObjValue,
              OUTPUT plRowAuditExist) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
          RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                        ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

  IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
  &ELSE
    IF CAN-FIND(FIRST gst_audit
                WHERE gst_audit.owning_entity_mnemonic  = pcEntityMnemonic
                AND   gst_audit.owning_reference        = pcEntityObjValue)
    THEN ASSIGN plRowAuditExist = YES.
    ELSE ASSIGN plRowAuditExist = NO.
  &ENDIF

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRecordCheckComment Include 
PROCEDURE getRecordCheckComment :
/*------------------------------------------------------------------------------
  Purpose:     Check if Comment record exist for specific record.
  Parameters:  pcEntityMnemonic - Entity Mnemonic
               pcEntityObjField - Entity Mnemonic Object Field Value (STRING)
               plRowAuditExist  - Does a Comment Record Exist for this record.
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcEntityMnemonic  AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pcEntityObjField  AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pcEntityObjValue  AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER plRowCommentExist AS LOGICAL   NO-UNDO.
  DEFINE OUTPUT PARAMETER pcRowCommentAuto  AS CHARACTER NO-UNDO.

  &IF DEFINED(server-side) = 0 &THEN
       RUN af/app/afgengtrecchkcmntp.p ON gshAstraAppServer
               (INPUT pcEntityMnemonic,
                INPUT pcEntityObjField,
                INPUT pcEntityObjValue,
                OUTPUT plRowCommentExist,
                OUTPUT pcRowCommentAuto) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
                  RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                                ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
  &ELSE

    IF CAN-FIND(FIRST gsm_comment
                WHERE gsm_comment.owning_entity_mnemonic  = pcEntityMnemonic
                AND   gsm_comment.owning_reference        = pcEntityObjValue
               )
    THEN ASSIGN plRowCommentExist = YES.
    ELSE ASSIGN plRowCommentExist = NO.

    FOR EACH gsm_comment NO-LOCK
      WHERE gsm_comment.owning_entity_mnemonic  = pcEntityMnemonic
      AND   gsm_comment.owning_reference        = pcEntityObjValue
      AND   gsm_comment.auto_display            = YES
      :
      IF gsm_comment.expiry_date  < TODAY
      AND gsm_comment.expiry_date <> ?
      THEN NEXT.

      IF pcRowCommentAuto <> "":U THEN ASSIGN pcRowCommentAuto = pcRowCommentAuto + CHR(10).
      ASSIGN pcRowCommentAuto = pcRowCommentAuto + gsm_comment.comment_description.
    END.

  &ENDIF

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRecordDetail Include 
PROCEDURE getRecordDetail :
/*------------------------------------------------------------------------------
  Purpose:     Returns the details of the first record found for a specified query
  Parameters:  pcQuery     - a valid for each ... query
               pcFieldList - returns a chr(3) seperated list of all fields in the query 
               and their values
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcQuery             AS CHARACTER            NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldList         AS CHARACTER            NO-UNDO.

    &IF DEFINED(server-side) = 0 &THEN
       RUN af/app/afgengtrecdetp.p ON gshAstraAppServer
               (INPUT pcQuery,
                OUTPUT pcFieldList) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
                  RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                                ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    &ELSE   

    DEFINE VARIABLE hQuery                      AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hBuffer                     AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hField                      AS HANDLE               NO-UNDO.
    DEFINE VARIABLE iLoop                       AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iCnt                        AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iArrayCount                 AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cTableName                  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFieldName                  AS CHARACTER  NO-UNDO.

    CREATE QUERY hQuery NO-ERROR.

    /*Get the list of tables in the query, and create buffer in the query*/
    BUFFER-LOOP:
    DO iLoop = 1 to NUM-ENTRIES(pcQuery," ":U):
        IF CAN-DO("EACH,FIRST,LAST":U,ENTRY(iLoop,pcQuery," ":U)) THEN
        DO:
            ASSIGN cTableName = REPLACE(REPLACE(ENTRY(iLoop + 1,pcQuery," "),",":U,"":U),":":U,"":U).
            
            CREATE BUFFER hBuffer FOR TABLE cTableName NO-ERROR.
            {afcheckerr.i}

            hQuery:ADD-BUFFER(hBuffer) NO-ERROR.
            {afcheckerr.i}            
        END.    /* EACH,FIRST,LAST */
    END.    /* loop through query */

    hQuery:QUERY-PREPARE(pcQuery).

    hQuery:QUERY-OPEN() NO-ERROR.
    IF ERROR-STATUS:ERROR THEN RETURN.

    hQuery:GET-FIRST() NO-ERROR.
    IF ERROR-STATUS:ERROR THEN RETURN.

    IF hQuery:NUM-RESULTS > 0 THEN
    DO iLoop = 1 TO hQuery:NUM-BUFFERS:
        ASSIGN hBuffer = hQuery:GET-BUFFER-HANDLE(iLoop).

        IF VALID-HANDLE(hBuffer) THEN
        DO:        
            DO iCnt = 1 TO hBuffer:NUM-FIELDS:
                ASSIGN hField = hBuffer:BUFFER-FIELD(iCnt)
                       
                .
                cFieldName = TRIM(hBuffer:NAME) + ".":U + TRIM(hField:NAME).
                IF hField:EXTENT > 1 THEN
                DO iArrayCount = 1 TO hField:EXTENT:
                  ASSIGN
                      pcFieldList = pcFieldList + CHR(3) WHEN pcFieldList <> "":U
                      pcFieldList = pcFieldList + cFieldName + "[" + STRING(iArrayCount) + "]" + CHR(3)
                      pcFieldList = pcFieldList + (IF hField:BUFFER-VALUE[iArrayCount] = "?":U THEN "":U ELSE TRIM(hField:BUFFER-VALUE[iArrayCount]))
                  .
                END.
                ELSE
                DO:
                  ASSIGN
                    pcFieldList = pcFieldList + CHR(3) WHEN pcFieldList <> "":U
                    pcFieldList = pcFieldList + cFieldName + CHR(3)
                    pcFieldList = pcFieldList + (IF hField:BUFFER-VALUE = "?":U THEN "":U ELSE TRIM(hField:BUFFER-VALUE))
                  .
                END.
            END.    /* loop through query fields. */

            /* Add the rowid */
            ASSIGN pcFieldList = pcFieldList + CHR(3) + "ROWID(":U + hBuffer:NAME + ")":U + CHR(3) + STRING(hBuffer:ROWID).
        END.    /* valid buffer handle */
    END.    /* loop through query buffers. */

    hQuery:QUERY-CLOSE.

    /* Cleanup */
    DO iLoop = 1 TO hQuery:NUM-BUFFERS:
        ASSIGN hBuffer = hQuery:GET-BUFFER-HANDLE(iLoop).

        IF VALID-HANDLE(hBuffer) THEN
            DELETE OBJECT hBuffer NO-ERROR.
        ASSIGN hBuffer = ?.
    END.    /* lop through bffers for cleanup */


    DELETE OBJECT hQuery NO-ERROR.
    ASSIGN hQuery = ?.

    &ENDIF
       
    RETURN.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRecordUserProp Include 
PROCEDURE getRecordUserProp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcEntityMnemonic  AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pcEntityFields    AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pcEntityObjValue  AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pcRowUserProp     AS CHARACTER NO-UNDO.
  
  IF pcEntityFields = '':u THEN
     pcEntityFields = 'HasAudit,HasComment,AutoComment':U.

  &IF DEFINED(server-side) = 0 &THEN
        RUN af/app/afgengtrecusrprpp.p ON gshAstraAppServer
               (INPUT pcEntityMnemonic,
                INPUT pcEntityFields,
                INPUT pcEntityObjValue,
                OUTPUT pcRowUserProp) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
                  RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                                ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
  &ELSE

    DEFINE VARIABLE lRowAuditExist    AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE lRowCommentExist  AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE cRowCommentAuto   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lTableHasObjField AS LOGICAL   NO-UNDO.
    
    DEFINE BUFFER gsc_entity_mnemonic FOR gsc_entity_mnemonic.

    IF  LOOKUP('HasComment':U,pcEntityFields)  = 0 
    AND LOOKUP('AutoComment':U,pcEntityFields) = 0  
    AND LOOKUP('HasAudit':U,pcEntityFields)    = 0 
    THEN DO:
        ASSIGN pcRowUserProp = "gstad":U + CHR(3) + "NO":U + CHR(4)
                             + "gsmcm":U + CHR(3) + "NO":U.
        RETURN.
    END.

    /* Find the entity and check if we're dealing with an obj field */
    FIND gsc_entity_mnemonic NO-LOCK
         WHERE gsc_entity_mnemonic.entity_mnemonic = pcEntityMnemonic
         NO-ERROR.
         
    ASSIGN lTableHasObjField = AVAILABLE gsc_entity_mnemonic
                               AND gsc_entity_mnemonic.table_has_object_field.
    
    /* Check if any audits exist against the record */
    IF LOOKUP('HasAudit':U,pcEntityFields) > 0
    THEN DO:
        ASSIGN lRowAuditExist = CAN-FIND(FIRST gst_audit
                                         WHERE gst_audit.owning_entity_mnemonic = pcEntityMnemonic
                                           AND gst_audit.owning_reference = pcEntityObjValue) NO-ERROR. 
        IF lRowAuditExist = ? THEN
            ASSIGN lRowAuditExist = NO.
    END.
    ELSE 
        ASSIGN lRowAuditExist = NO.
    
    IF LOOKUP('HasComment':U,pcEntityFields) > 0 
    OR LOOKUP('AutoComment':U,pcEntityFields) > 0  
    THEN DO:
        
        /* If an entity has an object field, the value
           will be decimal (by definition of an object field).
           This value is stored in the owning_reference field,
           in American format. The value that we receive here 
           is not necessarily American format, and so we need
           to convert to American format.
           
           Also remove the nmumeric separator since the value is 
           not stored with a numeric separator.
         */
        if lTableHasObjField then
        do:
            pcEntityObjValue = replace(pcEntityObjValue, session:numeric-separator, '').
            pcEntityObjValue = replace(pcEntityObjValue, session:numeric-decimal-point, '.').                
        end.    /* table has object ID field */               
            
            ASSIGN lRowCommentExist = CAN-FIND(FIRST gsm_comment
                                               WHERE gsm_comment.owning_entity_mnemonic = pcEntityMnemonic
                                                 AND gsm_comment.owning_reference = pcEntityObjValue)
                   NO-ERROR.
        IF lRowCommentExist = ? THEN
            ASSIGN lRowCommentExist = NO.
    END.
    ELSE 
        ASSIGN lRowCommentExist = NO.

    /* Now build the list of auto comments */
    IF lRowCommentExist AND LOOKUP('AutoComment':U,pcEntityFields) > 0 
    THEN DO:
        FOR EACH gsm_comment NO-LOCK
           WHERE gsm_comment.owning_entity_mnemonic  = pcEntityMnemonic
             AND gsm_comment.owning_reference        = pcEntityObjValue
             AND gsm_comment.auto_display            = YES
             AND (gsm_comment.expiry_date           >= TODAY
               OR gsm_comment.expiry_date = ?):
    
            ASSIGN cRowCommentAuto = cRowCommentAuto 
                                   + (IF cRowCommentAuto = '':U THEN '':U ELSE CHR(10))  
                                   + gsm_comment.comment_description.
        END.
    END.

    ASSIGN pcRowUserProp 
            = "gstad":U + CHR(3) + (IF lRowAuditExist THEN "YES":U ELSE "NO":U)
            + CHR(4)
            + "gsmcm":U + CHR(3) + (IF lRowCommentExist THEN "YES":U ELSE "NO":U)
            + (IF cRowCommentAuto = "":U 
               THEN "":U
               ELSE (CHR(4) + "gsmcmauto":U + CHR(3) + cRowCommentAuto)).
   &ENDIF

  RETURN.

END PROCEDURE.    /* getRecordUserProp */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSequenceExist Include 
PROCEDURE getSequenceExist :
/*------------------------------------------------------------------------------
  Purpose:     Determines whether a sequence/reference exists.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pdCompanyObj            AS DECIMAL              NO-UNDO.
    DEFINE INPUT  PARAMETER pcEntityMnemonic        AS CHARACTER            NO-UNDO.
    DEFINE INPUT  PARAMETER pcSequenceTLA           AS CHARACTER            NO-UNDO.
    DEFINE OUTPUT PARAMETER plSuccess               AS LOGICAL              NO-UNDO.

    &IF DEFINED(server-side) = 0 &THEN
        RUN af/app/afgengtseqexstp.p ON gshAstraAppServer
               (INPUT pdCompanyObj,
                INPUT pcEntityMnemonic,
                INPUT pcSequenceTLA,
                OUTPUT plSuccess) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
                  RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                                ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    &ELSE
    DEFINE VARIABLE hSequenceBuffer             AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hSequenceQuery              AS HANDLE               NO-UNDO.
        
    /* Initialise */
    ASSIGN plSuccess = NO.

    CREATE WIDGET-POOL "getSequenceExists":U.
    CREATE BUFFER hSequenceBuffer   FOR TABLE "gsc_sequence":U IN WIDGET-POOL "getSequenceExists":U.    
    CREATE QUERY hSequenceQuery                                IN WIDGET-POOL "getSequenceExists":U.

    hSequenceQuery:ADD-BUFFER(hSequenceBuffer).
    hSequenceQuery:QUERY-PREPARE("FOR EACH ":U + hSequenceBuffer:NAME + " WHERE ":U
                               + hSequenceBuffer:NAME + ".company_organisation_obj        = ":U + QUOTER(pdCompanyObj) + "  AND ":U
                               + hSequenceBuffer:NAME + ".owning_entity_mnemonic          = ":U + QUOTER(pcEntityMnemonic)    + " AND ":U
                               + hSequenceBuffer:NAME + ".sequence_tla    = ":U + QUOTER(pcSequenceTLA)       + " AND ":U
                               + hSequenceBuffer:NAME + ".sequence_active = YES ":U
                               + " NO-LOCK ":U).
    hSequenceQuery:QUERY-OPEN().
    hSequenceQuery:GET-FIRST(NO-LOCK).

    IF NOT hSequenceBuffer:AVAILABLE AND
       pdCompanyObj             <> 0 THEN
    DO:
        hSequenceQuery:QUERY-CLOSE().
        hSequenceQuery:QUERY-PREPARE("FOR EACH ":U + hSequenceBuffer:NAME + " WHERE ":U
                                     + hSequenceBuffer:NAME + ".company_organisation_obj        = 0                               AND ":U
                                     + hSequenceBuffer:NAME + ".owning_entity_mnemonic          = ":U + QUOTER(pcEntityMnemonic)    + " AND ":U
                                     + hSequenceBuffer:NAME + ".sequence_tla    = ":U + QUOTER(pcSequenceTLA)       + " AND ":U
                                     + hSequenceBuffer:NAME + ".sequence_active = YES ":U
                                     + " NO-LOCK ":U).
        hSequenceQuery:QUERY-OPEN().
        hSequenceQuery:GET-FIRST(NO-LOCK).
    END.    /* no header for this company. */

    ASSIGN plSuccess = hSequenceBuffer:AVAILABLE.

    /* Clean up. */
    DELETE WIDGET-POOL "getSequenceExists":U.
    
    &ENDIF

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSequenceMask Include 
PROCEDURE getSequenceMask :
/*------------------------------------------------------------------------------
  Purpose:     Builds a format mask for the sequence
  Parameters:  pcSequenceFormat    -
               pcQuantityIndicator -
               pcSequenceMask      -
  Notes:       * this format mask is used to format integers: it calculates
                 the number of digits to display based on the number between 
                 '[' and ']'. If there is not value, we default to 8 characters.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcSequenceFormat        AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcQuantityIndicator     AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcSequenceMask          AS CHARACTER        NO-UNDO.

    DEFINE VARIABLE iStartPosition              AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iEndPosition                AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iRepeats                    AS INTEGER              NO-UNDO.

    ASSIGN iStartPosition     = INDEX(pcSequenceFormat, "[":U)
           iEndPosition       = INDEX(pcSequenceFormat, "]":U)
           iRepeats           = 0
           pcQuantityIndicator = "":U
           .

    IF iStartPosition <> 0              AND
       iEndPosition   <> 0              AND
       iEndPosition    > iStartPosition THEN
        ASSIGN pcQuantityIndicator =         SUBSTRING(pcSequenceFormat, iStartPosition, iEndPosition - iStartPosition + 1)
               iRepeats           = INTEGER(SUBSTRING(pcSequenceFormat, (iStartPosition + 1), iEndPosition - iStartPosition - 1))
               NO-ERROR.

    IF iRepeats = 0 THEN
        ASSIGN iRepeats = 8.
    
    ASSIGN pcSequenceMask = TRIM(FILL("9":U, iRepeats)).

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSequenceValue Include 
PROCEDURE getSequenceValue :
/*------------------------------------------------------------------------------
  Purpose:     Returns the next sequence to a caller.
  Parameters:  pdCompanyObj
               pcEntityMnemonic
               pcSequenceTLA
               pcNextSequenceValue
  Notes:    * The ICF Database uses the GSC_SEQUENCE and GSC_NEXT_SEQUENCE table set.
            * Depending on whether multi_transaction has been set:
              - multi_transaction = NO, simply get the sequence value on gsc_sequence
                and increment.
              - multi_transaction = YES, grab the first available sequence in the
                gsc_next_sequence list, assign it, delete it and add the next sequence
                at the end of the list.
                BEFORE gsc_next_sequence will look like this:
                1 2 3 4 5
                AFTER the sequence has been assigned gsc_next_sequence will look like this:
                2 3 4 5 6
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pdCompanyObj            AS DECIMAL              NO-UNDO.
DEFINE INPUT  PARAMETER pcEntityMnemonic        AS CHARACTER            NO-UNDO.
DEFINE INPUT  PARAMETER pcSequenceTLA           AS CHARACTER            NO-UNDO.
DEFINE OUTPUT PARAMETER pcNextSequenceValue     AS CHARACTER            NO-UNDO.
    
&IF DEFINED(server-side) = 0  &THEN
        RUN af/app/afgengtseqvalp.p ON gshAstraAppServer
               (INPUT pdCompanyObj,
                INPUT pcEntityMnemonic,
                INPUT pcSequenceTLA,
                OUTPUT pcNextSequenceValue) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
                  RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                                ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
&ELSE    
    DEFINE BUFFER gsc_sequence        FOR gsc_sequence.
    DEFINE BUFFER gsc_next_sequence   FOR gsc_next_Sequence.
    DEFINE BUFFER bgsc_next_sequence  FOR gsc_next_Sequence.
    DEFINE BUFFER b2gsc_next_sequence FOR gsc_next_Sequence.
    
    DEFINE VARIABLE cSequenceMask      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cQuantityIndicator AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iSite              AS INTEGER    NO-UNDO.

    /* See if a sequence has been set up for the company requested specifically */

    FIND FIRST gsc_sequence NO-LOCK
         WHERE gsc_sequence.company_organisation_obj = pdCompanyObj
           AND gsc_sequence.owning_entity_mnemonic   = pcEntityMnemonic
           AND gsc_sequence.sequence_tla             = pcSequenceTla
           AND gsc_sequence.sequence_active          = YES
         NO-ERROR.

    /* If not available for the specific company, look for a system wide sequence */

    IF NOT AVAILABLE gsc_sequence 
    AND pdCompanyObj <> 0 THEN
        FIND FIRST gsc_sequence NO-LOCK
             WHERE gsc_sequence.company_organisation_obj = 0
               AND gsc_sequence.owning_entity_mnemonic   = pcEntityMnemonic
               AND gsc_sequence.sequence_tla             = pcSequenceTla
               AND gsc_sequence.sequence_active          = YES
             NO-ERROR.

    IF AVAILABLE gsc_sequence THEN
        IF gsc_sequence.multi_transaction = YES 
        THEN DO:
            fe-blk:
            FOR EACH bgsc_next_sequence NO-LOCK
               WHERE bgsc_next_sequence.sequence_obj = gsc_sequence.sequence_obj
                  BY bgsc_next_sequence.next_sequence_value:

                /* We're going to grab the first sequence not locked */

                trn-blk:
                DO TRANSACTION ON ERROR UNDO fe-blk, LEAVE fe-blk:

                    FIND gsc_next_sequence EXCLUSIVE-LOCK
                         WHERE ROWID(gsc_next_sequence) = ROWID(bgsc_next_sequence)
                         NO-WAIT NO-ERROR.

                    IF NOT AVAILABLE gsc_next_sequence
                    OR LOCKED gsc_next_sequence THEN
                        UNDO trn-blk, LEAVE trn-blk.

                    RUN getSequenceMask IN TARGET-PROCEDURE (INPUT gsc_sequence.sequence_format,
                                                             OUTPUT cQuantityIndicator,
                                                             OUTPUT cSequenceMask) NO-ERROR.

                    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

                    iSite = INDEX(gsc_sequence.sequence_format, "&S":U).
                    IF iSite > 0 THEN
                    DO:
                      RUN getSiteNumber IN TARGET-PROCEDURE (OUTPUT iSite).
                      pcNextSequenceValue = REPLACE(gsc_sequence.sequence_format, "&S":U, STRING(iSite)).
                    END.
                    ELSE
                      pcNextSequenceValue = gsc_sequence.sequence_format.

                    /* Assign the sequence */
                    ASSIGN pcNextSequenceValue = SUBSTITUTE(pcNextSequenceValue,
                                                            SUBSTRING(STRING(YEAR(TODAY)), 4, 1),
                                                            SUBSTRING(STRING(YEAR(TODAY)), 3, 2),
                                                            ENTRY(MONTH(TODAY), "JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC"),
                                                            STRING(YEAR(TODAY),"9999":U),
                                                            STRING(MONTH(TODAY),"99":U),
                                                            STRING(DAY(TODAY),"99":U),
                                                            STRING(WEEKDAY(TODAY)),
                                                            TRIM(STRING(gsc_next_sequence.next_sequence_value, ">>>>>>>9":U)),
                                                            STRING(gsc_next_sequence.next_sequence_value, cSequenceMask)).

                    IF cQuantityIndicator <> "":U THEN
                        ASSIGN pcNextSequenceValue = REPLACE(pcNextSequenceValue, cQuantityIndicator, "":U).

                    /* Create a new sequence at the end of the list */

                    CREATE b2gsc_next_sequence.
                    ASSIGN b2gsc_next_sequence.sequence_obj        = gsc_sequence.sequence_obj
                           b2gsc_next_sequence.next_sequence_value = gsc_next_sequence.next_sequence_value + gsc_sequence.number_of_sequences.

                    /* Delete the sequence we assigned, it was first in the list */

                    DELETE gsc_next_sequence.
                    
                    /* We needed the first, not locked sequence in the next_Sequence list.  We found it, used it, we're finished, leave. */

                    LEAVE fe-blk.
                END.
            END.
        END.
        ELSE else-blk: DO TRANSACTION ON ERROR UNDO else-blk, LEAVE else-blk:

            FIND CURRENT gsc_sequence EXCLUSIVE-LOCK NO-WAIT NO-ERROR.

            IF LOCKED gsc_sequence THEN
                RETURN ERROR {aferrortxt.i 'AF' '104' "'gsc_sequence'" '?' "'modify the gsc_sequence'" }.

            RUN getSequenceMask IN TARGET-PROCEDURE (INPUT  gsc_sequence.sequence_format,
                                                     OUTPUT cQuantityIndicator,
                                                     OUTPUT cSequenceMask) NO-ERROR.

            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
            
            iSite = INDEX(gsc_sequence.sequence_format, "&S":U).
            IF iSite > 0 THEN
            DO:
              RUN getSiteNumber IN TARGET-PROCEDURE (OUTPUT iSite).
              pcNextSequenceValue = REPLACE(gsc_sequence.sequence_format, "&S":U, STRING(iSite)).
            END.
            ELSE
              pcNextSequenceValue = gsc_sequence.sequence_format.

            IF gsc_sequence.auto_generate AND
               gsc_sequence.NEXT_value < gsc_sequence.MIN_value THEN
               ASSIGN gsc_sequence.NEXT_value = gsc_sequence.MIN_value.

            /* Assign the sequence */
            ASSIGN pcNextSequenceValue = SUBSTITUTE(pcNextSequenceValue,
                                                    SUBSTRING(STRING(YEAR(TODAY)),4,1),
                                                    SUBSTRING(STRING(YEAR(TODAY)),3,2),
                                                    ENTRY(MONTH(TODAY),"JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC":U),
                                                    STRING(YEAR(TODAY),"9999":U),
                                                    STRING(MONTH(TODAY),"99":U),
                                                    STRING(DAY(TODAY),"99":U),
                                                    STRING(WEEKDAY(TODAY)),
                                                    TRIM(STRING(gsc_sequence.next_value, ">>>>>>>9":U)),
                                                    STRING(gsc_sequence.next_value, cSequenceMask)) NO-ERROR.
            IF cQuantityIndicator <> "":U THEN
                ASSIGN pcNextSequenceValue = REPLACE(pcNextSequenceValue, cQuantityIndicator, "":U).

            IF gsc_sequence.auto_generate = YES THEN
                IF gsc_sequence.next_value = gsc_sequence.max_value THEN
                    ASSIGN gsc_sequence.next_value = gsc_sequence.min_value.
                ELSE
                    ASSIGN gsc_sequence.next_value = gsc_sequence.next_value + 1.
        END.
&ENDIF
       
ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSiteNumber Include 
PROCEDURE getSiteNumber :
/*------------------------------------------------------------------------------
  ACCESS_LEVEL = PUBLIC
  Purpose:     Procedure to determine the current repository database site
               number from the RVDB if connected, otherwise from the ICFDB
               database sequence.
  Parameters:  Output current site number
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER piSite              AS INTEGER  NO-UNDO.

IF giSiteNumber <> ? THEN
DO:
    piSite = giSiteNumber.
    RETURN.
END.

&IF DEFINED(server-side) = 0 &THEN
        RUN af/app/afgengtstnop.p ON gshAstraAppServer
               (OUTPUT piSite) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
                  RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                                ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
&ELSE
  DEFINE VARIABLE iSeqObj1          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSeqObj2          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSeqSiteDiv       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSeqSiteRev       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSessnId          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cCalNumberRevICF  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSiteReverseICF   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSiteDivisionICF  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop             AS INTEGER    NO-UNDO.
  
  /* Obtain all the database sequence values */
  RUN ry/app/rygetnobjp.p (INPUT NO,          /* do not increment */
                           OUTPUT iSeqObj1,
                           OUTPUT iSeqObj2,
                           OUTPUT iSeqSiteDiv,
                           OUTPUT iSeqSiteRev,
                           OUTPUT iSessnId).
   
  ASSIGN
    cCalNumberRevICF  = "":U
    cSiteReverseICF   = STRING(iSeqSiteRev)
    cSiteDivisionICF  = STRING(iSeqSiteDiv)
    .

  /* Site number is reversed. Turn the site number around. */
  DO iLoop = LENGTH(cSiteReverseICF) TO 1 BY -1:
    cCalNumberRevICF  = cCalNumberRevICF + SUBSTRING(cSiteReverseICF,iLoop,1).
  END.

  /* Site number needs to be multiplied by 10 to the power of whatever the length of the
     cSiteDivisionICF is minus the length of the site number divided by 10. 
     This will make sure that all the zeros are tagged back on to the end of the site 
     number.*/
  ASSIGN
    piSite = INTEGER(cCalNumberRevICF) * 
             (EXP(10, 
                  (LENGTH(cSiteDivisionICF) - LENGTH(cCalNumberRevICF))) / 10).

&ENDIF

giSiteNumber = piSite.
RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getStatusRecord Include 
PROCEDURE getStatusRecord :
/*------------------------------------------------------------------------------
  Purpose:     Returns components of a status.
  Parameters:  pcCategoryType       (I)
               pcCategoryGroup      (I)
               pcCategorySubGroup   (I)
               pdStatusObj          (I)
               pcRequestedFields    (I)
               pcResultSet          (I)
  Notes:       * This procedure maintains the status cache temp table, and returns
                 the components of the temp-table to a caller.               
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcCategoryType                  AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcCategoryGroup                 AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcCategorySubGroup              AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pdStatusObj                     AS DECIMAL      NO-UNDO.
    DEFINE INPUT  PARAMETER pcRequestedFields               AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER pcResultSet                     AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE lOK                         AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE lInCache                    AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE rStatusCache                AS RAW                      NO-UNDO.
    DEFINE VARIABLE iFieldLoop                  AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE cQueryPrepareString         AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cWidgetPool                 AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE hBufferField                AS HANDLE                   NO-UNDO         EXTENT 50.
    DEFINE VARIABLE hQuery                      AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hTempTable                  AS HANDLE                   NO-UNDO.

    DEFINE BUFFER ttStatusCache         FOR ttStatusCache.

    ASSIGN cWidgetPool = "StatusCache":U.
    IF pdStatusObj <> 0 THEN
    DO:
        IF pdStatusObj = ? THEN
            ASSIGN pdStatusObj = 0.

        ASSIGN cQueryPrepareString = "FOR EACH ttStatusCache WHERE ttStatusCache.tStatusObj = ":U + QUOTER(STRING(pdStatusObj)) + " NO-LOCK":U
               lInCache            = CAN-FIND(FIRST ttStatusCache WHERE ttStatusCache.tStatusObj = pdStatusObj)
               .
    END.    /* pdStatusObj <> ? */
    ELSE
        ASSIGN cQueryPrepareString = "FOR EACH ttStatusCache WHERE ":U
                                   + "ttStatusCache.tCategoryType     = '":U + pcCategoryType     + "' AND ":U
                                   + "ttStatusCache.tCategoryGroup    = '":U + pcCategoryGroup    + "' AND ":U
                                   + "ttStatusCache.tCategorySubGroup = '":U + pcCategorySubGroup + "' ":U
                                   + "NO-LOCK":U
               lInCache            = CAN-FIND(FIRST ttStatusCache WHERE
                                                    ttStatusCache.tCategoryType     = pcCategoryType     AND
                                                    ttStatusCache.tCategoryGroup    = pcCategoryGroup    AND
                                                    ttStatusCache.tCategorySubGroup = pcCategorySubGroup     )
               .

    IF NOT lInCache THEN
    DO:
        /* If running on AppServer*/
        &IF DEFINED(server-side) <> 0 &THEN
            RUN gsgetstatp ( INPUT  pcCategoryType,
                             INPUT  pcCategoryGroup,
                             INPUT  pcCategorySubGroup,
                             INPUT  pdStatusObj,
                             OUTPUT rStatusCache
                           ).
        &ELSE
        /* Running Locally */
            RUN af/app/gsgetstatp.p ON gshAstraAppserver ( INPUT  pcCategoryType,
                                                           INPUT  pcCategoryGroup,
                                                           INPUT  pcCategorySubGroup,
                                                           INPUT  pdStatusObj,
                                                           OUTPUT rStatusCache
                                                         ).
        &ENDIF
        
        CREATE ttStatusCache.
        RAW-TRANSFER FIELD rStatusCache TO BUFFER ttStatusCache NO-ERROR.
    END.    /* record not in cache - retrieve from DB. */

    CREATE WIDGET-POOL cWidgetPool.
    CREATE QUERY hQuery IN WIDGET-POOL cWidgetPool.
    
    hQuery:ADD-BUFFER(BUFFER ttStatusCache:HANDLE).
    ASSIGN hTempTable = hQuery:GET-BUFFER-HANDLE(1).

    DO iFieldLoop = 1 TO NUM-ENTRIES(pcRequestedFields) WHILE iFieldLoop <= EXTENT(hBufferField):
        ASSIGN hBufferField[iFieldLoop] = hTempTable:BUFFER-FIELD(ENTRY(iFieldLoop, pcRequestedFields)) NO-ERROR.
    END.    /* set up buffer field handles */
    
    hQuery:QUERY-PREPARE(cQueryPrepareString).
    hQuery:QUERY-OPEN.

    hQuery:GET-FIRST(NO-LOCK).

    IF hTempTable:AVAILABLE THEN
    DO iFieldLoop = 1 TO NUM-ENTRIES(pcRequestedFields) WHILE iFieldLoop <= EXTENT(hBufferField):
        ASSIGN pcResultSet = pcResultSet + (IF pcResultSet = "":U THEN "":U ELSE CHR(4))
                           + hBufferField[iFieldLoop]:BUFFER-VALUE
               .
    END.    /* available */

    hQuery:QUERY-CLOSE().
    DELETE WIDGET-POOL cWidgetPool.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTableInfo Include 
PROCEDURE getTableInfo :
/*------------------------------------------------------------------------------
  Purpose:     Returns a CHR(4) delimited list of the following information about
               the updatable table in the supplied data source
               Entry 1 - Owning Entity Mnemonic
               Entry 2 - Table Name
               Entry 3 - Key Field of Table

  Parameters:  phDataSource
               pcReturnValue
  Notes:       This procedure differs from getTableInfoObj only in that it returns
               a key field for entry 3 in the return value.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcUpdatableTable    AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcReturnValue       AS CHARACTER        NO-UNDO. 

    &IF DEFINED(server-side) = 0 &THEN
        RUN af/app/afgengttblinfop.p ON gshAstraAppServer
               (INPUT pcUpdatableTable,
                OUTPUT pcReturnValue) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
                  RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                                ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    &ELSE
    DEFINE VARIABLE cOwningEntityMnemonic   AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE cTableDumpName          AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE cKeyField               AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE iCounter                AS INTEGER       NO-UNDO.
    
    IF TRIM(pcUpdatableTable) <> "":U  THEN
    DO:
        ASSIGN cTableDumpName = "":U.
        
        DO iCounter = 1 TO NUM-DBS:
            IF cTableDumpName = "":U THEN
                ASSIGN cTableDumpName = DYNAMIC-FUNCTION("getTableDumpName":U IN TARGET-PROCEDURE, INPUT LDBNAME(iCounter) + "|":U + pcUpdatableTable).
        END.    /* count DBS */

        IF cTableDumpName <> "":U THEN
        DO:
            ASSIGN cOwningEntityMnemonic = CAPS(cTableDumpName).
            
            IF INDEX(cOwningEntityMnemonic, ".D":U) <> 0 THEN
                ASSIGN cOwningEntityMnemonic = REPLACE(cOwningEntityMnemonic, ".D":U, "":U).

            ASSIGN
                cKeyField     = getKeyField(cTableDumpName)
                pcReturnValue = cOwningEntityMnemonic + CHR(4)
                              + pcUpdatableTable      + CHR(4)
                              + cKeyField
                .
        END. /*  cTableDumpName  */
    END.  /* pcUpdatableTable */
    &ENDIF
    
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTableInfoObj Include 
PROCEDURE getTableInfoObj :
/*------------------------------------------------------------------------------
  Purpose:     Returns a CHR(4) delimited list of the following information about
               the updatable table in the supplied data source
               Entry 1 - Owning Entity Mnemonic
               Entry 2 - Table Name
               Entry 3 - Obj Field of Table

  Parameters:  phDataSource
               pcReturnValue
  Notes:       This procedure differs from getTableInfo only in that it returns
               an obj field for entry 3 in the return value.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcUpdatableTable    AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcReturnValue       AS CHARACTER        NO-UNDO. 

    &IF DEFINED(server-side) = 0 &THEN
        RUN af/app/afgengttblinfobjp.p ON gshAstraAppServer
               (INPUT pcUpdatableTable,
                OUTPUT pcReturnValue) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
                  RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                                ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
    DEFINE VARIABLE cOwningEntityMnemonic   AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE cTableDumpName          AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE cObjField               AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE iCounter                AS INTEGER       NO-UNDO.
    
    IF TRIM(pcUpdatableTable) <> "":U  THEN
    DO:
        ASSIGN cTableDumpName = "":U.
        
        DO iCounter = 1 TO NUM-DBS:
            IF cTableDumpName = "":U THEN
                ASSIGN cTableDumpName = DYNAMIC-FUNCTION("getTableDumpName":U IN TARGET-PROCEDURE, INPUT LDBNAME(iCounter) + "|":U + pcUpdatableTable).
        END.    /* count DBS */

        IF cTableDumpName <> "":U 
        THEN DO:
            ASSIGN cOwningEntityMnemonic = CAPS(cTableDumpName).

            IF INDEX(cOwningEntityMnemonic, ".D":U) <> 0 THEN
                ASSIGN cOwningEntityMnemonic = REPLACE(cOwningEntityMnemonic, ".D":U, "":U).

            ASSIGN cObjField     = getObjField(cTableDumpName)
                   pcReturnValue = cOwningEntityMnemonic + CHR(4)
                                 + pcUpdatableTable      + CHR(4)
                                 + cObjField.
        END.
    END.
    &ENDIF
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN "":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getUserSourceLanguage Include 
PROCEDURE getUserSourceLanguage :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Source Language of a user
    Notes:  This function will only be run on the AppServer, or a DB-aware client
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pdUserObj           AS DECIMAL NO-UNDO.    
    DEFINE OUTPUT PARAMETER pdSourceLanguageObj AS DECIMAL NO-UNDO.

    &IF DEFINED(server-side) = 0 &THEN
        RUN af/app/afgengtusrsrclngp.p ON gshAstraAppServer
               (INPUT pdUserObj,
                OUTPUT pdSourceLanguageObj) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
                  RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                                ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
      DEFINE VARIABLE rRowid        AS ROWID      NO-UNDO.
      DEFINE VARIABLE cProfileData  AS CHARACTER  NO-UNDO.
      
      pdSourceLanguageObj = 0.
      /* First check if the current specified user has a language associated with him/her */
      FIND FIRST gsm_user
           WHERE gsm_user.user_obj      = pdUserObj 
           AND   gsm_user.language_obj <> 0
           NO-LOCK NO-ERROR.
      IF AVAILABLE gsm_user THEN
        pdSourceLanguageObj = gsm_user.language_obj.
      ELSE DO:
        ASSIGN rRowid = ?.
        RUN getProfileData IN gshProfileManager (INPUT "General":U,
                                                 INPUT "SLanguage":U,
                                                 INPUT "SLanguage":U,
                                                 INPUT NO,
                                                 INPUT-OUTPUT rRowid,
                                                 OUTPUT cProfileData).
        IF cProfileData = "":U OR
          cProfileData = ? OR
          NOT CAN-FIND(gsc_language WHERE gsc_language.language_obj = DECIMAL(cProfileData)) THEN DO:
          FIND FIRST gsc_global_control NO-LOCK NO-ERROR.
          IF AVAILABLE gsc_global_control THEN
            pdSourceLanguageObj = gsc_global_control.default_language_obj.
        END.
        ELSE
          pdSourceLanguageObj = DECIMAL(cProfileData).
      END.
    &ENDIF
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gsgetenmnp Include 
PROCEDURE gsgetenmnp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR ttEntityMnemonic.

    &IF DEFINED(server-side) = 0 &THEN
        RUN af/app/afgengsgetenmnpp.p ON gshAstraAppServer
               (OUTPUT TABLE ttEntityMnemonic) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
                  RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                                ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    &ELSE
      {af/app/afgengsgetenmnpp.i}
    &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gsgetgsced Include 
PROCEDURE gsgetgsced :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR ttEntityDisplayField.

    &IF DEFINED(server-side) = 0 &THEN
        RUN af/app/afgengsgetgscedp.p ON gshAstraAppServer
               (OUTPUT TABLE ttEntityDisplayField) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
                  RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                                ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    &ELSE
        {af/app/afgengsgetgscedp.i}
    &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gsgetstatp Include 
PROCEDURE gsgetstatp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pcCategoryType              AS CHARACTER                NO-UNDO.
    DEFINE INPUT  PARAMETER pcCategoryGroup             AS CHARACTER                NO-UNDO.
    DEFINE INPUT  PARAMETER pcCategorySubGroup          AS CHARACTER                NO-UNDO.
    DEFINE INPUT  PARAMETER pdStatusObj                 AS DECIMAL                  NO-UNDO.
    DEFINE OUTPUT PARAMETER prStatusCache               AS RAW                      NO-UNDO.

    &IF DEFINED(server-side) = 0 &THEN
        RUN af/app/afgengsgetstatpp.p ON gshAstraAppServer
               (INPUT pcCategoryType,
                INPUT pcCategoryGroup,
                INPUT pcCategorySubGroup,
                INPUT pdStatusObj,
                OUTPUT prStatusCache) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
                  RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                                ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    &ELSE
        DEFINE BUFFER gsm_status                    FOR gsm_status.
        DEFINE BUFFER gsm_category                  FOR gsm_category.
        
        EMPTY TEMP-TABLE ttStatusCache.
        
        IF pdStatusObj <> 0 THEN
        DO:
            FIND gsm_status WHERE
                 gsm_status.status_obj = pdStatusObj
                 NO-LOCK NO-ERROR.
            IF AVAILABLE gsm_status THEN
                FIND gsm_category WHERE
                     gsm_category.category_obj = gsm_status.category_obj
                     NO-LOCK NO-ERROR.
        END.    /* Status OBJ <> 0 */
        ELSE
        DO:
            FIND gsm_category WHERE
                 gsm_category.related_entity_mnemonic = "GSMST":U          AND
                 gsm_category.category_type           = pcCategoryType     AND
                 gsm_category.category_group          = pcCategoryGroup    AND
                 gsm_category.category_subgroup       = pcCategorySubGroup
                 NO-LOCK NO-ERROR.
            IF AVAILABLE gsm_category THEN
                FIND FIRST gsm_status WHERE
                           gsm_status.category_obj = gsm_category.category_obj
                           NO-LOCK NO-ERROR.
        END.    /* use category */
        
        IF AVAILABLE gsm_status THEN
        DO:
            CREATE ttStatusCache.
            ASSIGN ttStatusCache.tStatusObj         = gsm_status.status_obj
                   ttStatusCache.tCategoryType      = gsm_category.category_type
                   ttStatusCache.tCategoryGroup     = gsm_category.category_group
                   ttStatusCache.tCategorySubGroup  = gsm_category.category_subgroup
                   ttStatusCache.tStatusShortDesc   = gsm_status.status_short_desc
                   ttStatusCache.tStatusDescription = gsm_status.status_description
                   ttStatusCache.tStatusTLA         = gsm_status.status_tla
                   .
            RAW-TRANSFER BUFFER ttStatusCache TO FIELD prStatusCache.
        END.    /* avail category */

    &ENDIF
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Include 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     Run on close of procedure
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processQueryStringFilterSets Include 
PROCEDURE processQueryStringFilterSets :
/*------------------------------------------------------------------------------
  Purpose:  This procedure should evaludate a given query string and determine
            if there are any filter set clauses embedded in the query. It should
            then draw out these filter set clauses, resolve them and insert the
            resolved clause into the query string
  
  Parameters:  INPUT pcQueryString           - Query string to check for filter
                                               set phrases
               INPUT pcProcerssedQueryString - Query string that has te resolved
                                               filter set clauses included
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcQueryString           AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcProcessedQueryString  AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cCurrentFilterSetClause AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAdditionalArguments    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterSetClause        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterSetCode          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryString            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntityList             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBufferList             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iNextStart              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iStart                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEnd                    AS INTEGER    NO-UNDO.

  cQueryString = pcQueryString.

  /* Process ALL filter set phrases in the query string (There could be multiple) */
  DO WHILE INDEX(cQueryString, "[&":U) <> 0:
    /* Get the start and the end of the filter set phrase */
    ASSIGN
        iStart     = INDEX(cQueryString, "[&":U)
        iEnd       = INDEX(cQueryString, "]":U,  iStart)
        iNextStart = INDEX(cQueryString, "[&":U, iStart).

    /* Check the validity of the the current filter set phrase */
    IF iStart > iEnd THEN
      RETURN ERROR "FILTER-STRING-ERROR":U.     /* A filter set phrase was opened but not closed */
    ELSE
      IF iNextStart > iStart AND
         iNextStart < iEnd   THEN
        RETURN ERROR "FILTER-STRING-ERROR":U.   /* Another filter set phrase is nested in the current */

    /* If we reach this point, we at least have a properly bracketed filter set phrase */
    cCurrentFilterSetClause = SUBSTRING(cQueryString, iStart, iEnd - iStart + 1).

    /* Get the filter set details specified in the current filter set phrase */
    RUN getFilterSetParameters (INPUT  cCurrentFilterSetClause,
                                OUTPUT cFilterSetCode,
                                OUTPUT cEntityList,
                                OUTPUT cBufferList,
                                OUTPUT cAdditionalArguments).

    /* Take the filter set parameters and retrieve the filter set clause for it */
    RUN getFilterSetClause (INPUT-OUTPUT cFilterSetCode,
                            INPUT        cEntityList,
                            INPUT        cBufferList,
                            INPUT        cAdditionalArguments,
                            OUTPUT       cFilterSetClause).

    /* Replace the filter set phrase with the filter set clause */
    SUBSTRING(cQueryString, iStart, iEnd - iStart + 1) = cFilterSetClause.
  END.

  /* Assign the output parameter */
  pcProcessedQueryString = cQueryString.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshMnemonicsCache Include 
PROCEDURE refreshMnemonicsCache :
/*------------------------------------------------------------------------------
  Purpose:     To get the latest set of Entity Mnemonic and Entity Display Field
               Records into the cache
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE ttEntityMnemonic.
    EMPTY TEMP-TABLE ttEntityDisplayField.
    
    /* The cache will be repopulated as entities are requested */      

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sendLoginCache Include 
PROCEDURE sendLoginCache :
/*------------------------------------------------------------------------------
  Purpose:     When running Appserver, all cache needed for startup is cached in
               one Appserver hit.  As the managers need it, they request it from
               the cache PLIPP.  In this case, the entity_mnemonic cache has been
               requested.
  Parameters:  <none>
  Notes:       This procedure is redundant.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TABLE FOR ttEntityMnemonic.

/* We're not supposed to run this procedure any more.  If we do for some reason, clear the temp-tables to ensure *
 * we get our entity info from the rep manager as it's requested */
EMPTY TEMP-TABLE ttEntityMnemonic.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateTableViaSDO Include 
PROCEDURE updateTableViaSDO :
/*------------------------------------------------------------------------------
  Purpose:     Updates the DB via the relevant SDO.
  Parameters:  pcSdoName                - the file name of the SDO used for an update
               pcSdoDescription         - a description of the SDO above.
               pcExtraProperties        - a chr(3) string of additional properties
                                          to set in the SDO (see note below).
               pcUserProperties         - a chr(3) string of additional user properties
                                          to set in the SDO (see note below).
               table-handle phRowObjUpd - the rowObjUpd table containing records
                                          for update.
  Notes:       * No distinction is made between the client and server when running
                 this procedure since this procedure always attempts to run the SDO
                 on the ICF AppServer. If the calling procedure is already running
                 on the server, value of the gshAstraAppserver handle is that of the
                 SESSION; and so no problems are encountered.
               * This procedure starts the SDO, updates the DB and destroys the
                 SDO after any updates. Any errors are reported back to the calling
                 procedure using the RETURN-VALUE.
               * The ERROR-STATUS error condition is raised; it is recommended
                 that this procedure is run with the NO-ERROR option.
               * The table handle is returned to the calling procedure in case
                 there are further actions to be performed on it, or post-update
                 data is required (eg. a status which is determined in the SDO).
               * The extra properties string is a chr(3)-delimited  label,value
                 string. These properties will be set in the SDO after initialisation.
------------------------------------------------------------------------------*/
    DEFINE INPUT        PARAMETER pcSdoName         AS CHARACTER NO-UNDO.
    DEFINE INPUT        PARAMETER pcSdoDescription  AS CHARACTER NO-UNDO.
    DEFINE INPUT        PARAMETER pcExtraProperties AS CHARACTER NO-UNDO.
    DEFINE INPUT        PARAMETER pcUserProperties  AS CHARACTER NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd.      
    DEFINE VARIABLE cUndoRowids                 AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE cErrorList                  AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE cPropertyName               AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE cPropertyValue              AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE cPropertySignature          AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE cPropertyParameter          AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE hSDO                        AS HANDLE        NO-UNDO.
    DEFINE VARIABLE iPropertyLoop               AS INTEGER       NO-UNDO.
    DEFINE VARIABLE lErrorStatus                AS LOGICAL       NO-UNDO.

    /* If the TT is empty, go no further. */
    IF phRowObjUpd:has-records = NO THEN
        RETURN.

    /* Start up SDO */
    ASSIGN pcSdoName = REPLACE(pcSdoName,"~\":U,"/":U).

    IF INDEX(pcSdoName,"/":U) > 0 THEN
      ASSIGN pcSdoName = SUBSTRING(pcSdoName,R-INDEX(pcSdoName,"/":U) + 1).

    RUN startDataObject IN gshRepositoryManager (INPUT  pcSdoName,
                                                 OUTPUT hSDO) NO-ERROR.
    IF NOT VALID-HANDLE(hSDO) THEN
    DO:
      pcSdoName = pcSdoName + ".w":U.
      RUN startDataObject IN gshRepositoryManager (INPUT  pcSdoName,
                                                   OUTPUT hSDO) NO-ERROR.
    END.
    IF NOT VALID-HANDLE(hSDO) THEN
      RETURN ERROR {aferrortxt.i 'AF' '40' '?' '?' "'error running ' + pcSdoDescription + ' SDO'" }.

    IF VALID-HANDLE(hSDO) THEN
    DO:
        /* Properties needed by the SDO in order for all the validation to
         * fire properly.   */
        {set RowsToBatch         1        hSDO}.
        {set RebuildOnRepos      TRUE     hSDO}.
        {set ASDivision          'SERVER' hSDO}.
        {set CheckCurrentChanged NO       hSDO}.

        /* Extra Properties */
        IF NUM-ENTRIES(pcExtraProperties, CHR(3)) > 0 THEN
        DO iPropertyLoop = 1 TO NUM-ENTRIES(pcExtraProperties, CHR(3)) BY 2:
            ASSIGN cPropertyName  = ENTRY(iPropertyLoop, pcExtraProperties, CHR(3))
                   cPropertyValue = ENTRY(iPropertyLoop + 1, pcExtraProperties, CHR(3))
                   .
            ASSIGN cPropertySignature = hSDO:GET-SIGNATURE("set":U + TRIM(cPropertyName)).

            /* Assume only one parameter being set. */
            ASSIGN cPropertyParameter = ENTRY(3, cPropertySignature) NO-ERROR.

            /* Determine the parameter data type */
            IF NOT ERROR-STATUS:ERROR THEN
            CASE ENTRY(3, cPropertyParameter, " ":U):
                WHEN "LOGICAL":U THEN 
                  DYNAMIC-FUNCTION("set":U + TRIM(cPropertyName) IN hSDO, INPUT (cPropertyValue = "YES":U)) NO-ERROR.
                WHEN "DECIMAL":U THEN 
                  DYNAMIC-FUNCTION("set":U + TRIM(cPropertyName) IN hSDO, INPUT DECIMAL(cPropertyValue)) NO-ERROR.
                WHEN "INTEGER":U THEN 
                  DYNAMIC-FUNCTION("set":U + TRIM(cPropertyName) IN hSDO, INPUT INTEGER(cPropertyValue)) NO-ERROR.
                OTHERWISE 
                  DYNAMIC-FUNCTION("set":U + TRIM(cPropertyName) IN hSDO, INPUT cPropertyValue) NO-ERROR.
            END CASE.   /* the parameter type */
        END.    /* loop through extra properties */

        /* User properties */
        IF NUM-ENTRIES(pcUserProperties, CHR(3)) > 0 THEN
        DO iPropertyLoop = 1 TO NUM-ENTRIES(pcUserProperties, CHR(3)) BY 2:
            ASSIGN cPropertyName  = ENTRY(iPropertyLoop, pcUserProperties, CHR(3))
                   cPropertyValue = ENTRY(iPropertyLoop + 1, pcUserProperties, CHR(3))
                   .
            DYNAMIC-FUNCTION("setUserProperty":U IN hSDO, INPUT cPropertyName, INPUT cPropertyValue) NO-ERROR.
        END.    /* loop through user properties */

        RUN initializeObject IN hSDO NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
            RETURN ERROR {aferrortxt.i 'AF' '40' '?' '?' "'error initialising ' + pcSdoDescription + ' SDO'" }.
        ELSE DO:
          DYNAMIC-FUNCTION("setRowObjUpdTable":U IN hSDO,phRowObjUpd) NO-ERROR.
          RUN bufferCommit IN hSDO (OUTPUT cErrorList,
                                    OUTPUT cUndoRowids) NO-ERROR.
        END.
        
        ASSIGN lErrorStatus = ERROR-STATUS:ERROR
               cErrorList   = ERROR-STATUS:GET-MESSAGE(1).

        IF DYNAMIC-FUNCTION("getInternalEntryExists":U IN gshSessionManager, INPUT hSDO, INPUT "destroyObject":U) THEN
            RUN destroyObject IN hSDO.
        ELSE
            DELETE PROCEDURE hSDO NO-ERROR.

        IF ERROR-STATUS:ERROR OR lErrorStatus THEN
            RETURN ERROR {aferrortxt.i 'AF' '40' '?' '?' "'run error committing ' + pcSdoDescription + ' changes'" }.
 
        IF cErrorList <> "":U THEN
            RETURN ERROR cErrorList.
    END.    /* valid handle hSDO */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateEntityMnemonic Include 
PROCEDURE validateEntityMnemonic :
/*------------------------------------------------------------------------------
  Purpose:     Validates a given entity mnemonic against
  Parameters:  pcEntityMnemonic - the entity mnemonic to be checked
               pcResult         - the results of the validation
  Notes:       * First look in the local entity cache. The entity mnemonic
                 should be found in the cache 99% of the time. The rest of this IP
                 caters for the other 1%.
               * If the entity mnemonic can be found in the GSC-ENTITY-MNEMONIC table,
                 then we force a refresh of the cache.
               * If the entity mnemonic can't be found in the DB or the cache, then a
                 blank value is returned. We do not attempt to create an entity 
                 menmonic record.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcEntityMnemonic        AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcResult                AS CHARACTER NO-UNDO.

    /* Make sure the entity is cached */
    RUN cacheEntity IN TARGET-PROCEDURE (pcEntityMnemonic, /* Table FLA */
                                         "":U).            /* Tablename */
    
    /* Has an Entity Mnemonic record been created yet? */
    IF CAN-FIND(ttEntityMnemonic WHERE ttEntityMnemonic.entity_mnemonic = pcEntityMnemonic) THEN
        ASSIGN pcResult = "OK":U.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION clearFilterSetCache Include 
FUNCTION clearFilterSetCache RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Clears the FilterSetClause temp-table
    Notes:  The cache only exists on the client-side. By design, the program
            assumes that if you call the API on the AppServer, you want it to
            resolve the filter set clause as the data lies on the server at
            the time you call the API.
------------------------------------------------------------------------------*/
  EMPTY TEMP-TABLE ttFilterSetClause.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION convertTimeToInteger Include 
FUNCTION convertTimeToInteger RETURNS INTEGER
  (pcTime AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose:  Takes a character string and converts it into an integer value
    Notes:  The pcTime parameter can be specified as "HH:MM" or "HH:MM:SS" or
            even as "HHMMSS"
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cHour   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cMinute AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cSecond AS INTEGER   NO-UNDO.
  
  /* See that the time is in the proper format */
  IF INDEX(pcTime, ":":U) = 0 THEN
    ASSIGN pcTime = SUBSTRING(pcTime, 1, 2) + ":":U
                  + SUBSTRING(pcTime, 3, 2) + ":":U
                  + SUBSTRING(pcTime, 5, 2).
  
  IF NUM-ENTRIES(pcTime, ":":U) = 2 THEN
    ASSIGN pcTime = pcTime + ":0":U.

  /* Get the hour, minutes and seconds values */
  ASSIGN cHour = INTEGER(ENTRY(1, pcTime, ":":U)) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN ?.

  ASSIGN cMinute = INTEGER(ENTRY(2, pcTime, ":":U)) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN ?.

  ASSIGN cSecond = INTEGER(ENTRY(3, pcTime, ":":U)) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN ?.

  /* Check to see if the time was specified correctly */
  IF cHour < 0 OR cHour > 23 THEN
    RETURN ?.

  IF cMinute < 0 OR cMinute > 59 THEN
    RETURN ?.

  IF cSecond < 0 OR cSecond > 59 THEN
    RETURN ?.

  RETURN (cHour * 60 * 60) + (cMinute * 60) + cSecond. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createFolder Include 
FUNCTION createFolder RETURNS LOGICAL
    ( INPUT pcFolderName       AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Creates a folder, if it doesn't exist.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iErrorCode              AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE cCompositePath          AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cFolder                 AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE iFolderCOunt            AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iCount                  AS INTEGER    INITIAL 1     NO-UNDO.

    ASSIGN pcFolderName        = REPLACE(pcFolderName, "~\":U, "/":U)
           FILE-INFO:FILE-NAME = pcFolderName.
           
    IF FILE-INFO:FULL-PATHNAME EQ ? THEN
    DO:
        IF pcFolderName BEGINS "//":U THEN  /* UNC path Check */
          ASSIGN cCompositePath = "//":U + ENTRY(3, pcFolderName, "/":U)
                 iCount         = 4.
        ELSE
          ASSIGN cCompositePath = "":U.

        DO iFolderCount = iCount TO NUM-ENTRIES(pcFolderName, "/":U).
            ASSIGN cFolder = ENTRY(iFolderCount, pcFolderName, "/":U).

            ASSIGN cCompositePath = cCompositePath + (IF NUM-ENTRIES(cCompositePath, "/":U) EQ 0 THEN "":U ELSE "/":U)
                                  + cFolder.

            ASSIGN FILE-INFO:FILE-NAME = cCompositePath.
            IF FILE-INFO:FULL-PATHNAME EQ ? THEN
            DO:
                OS-CREATE-DIR VALUE(cCompositePath).
                ASSIGN iErrorCode = OS-ERROR.
                IF iErrorCode NE 0 THEN
                    LEAVE.
            END.    /* need to create the folder */
        END.    /* folder count. */
    END.    /* folder doesn't exist */

    RETURN (iErrorCode EQ 0).
END FUNCTION.   /* createFolder */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION detectFileType Include 
FUNCTION detectFileType RETURNS CHARACTER
    ( INPUT pcFileName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:   Determines from the filename the type of file.
    Notes:   Valid file types are:
             U = URL
             N = UNC File Name (\\Machine\share\directory\file)
             D = DOS/Windows   (D:\directory\file)
             X = Unix Filename
------------------------------------------------------------------------------*/
  /* If the first 7 characters are http:// or the
     first 8 are https:// (secure http) or the
     first 6 are ftp:// this is a URL */
  IF (SUBSTRING(pcFileName,1,7) = "http://":U OR
      SUBSTRING(pcFileName,1,8) = "https://":U OR
      SUBSTRING(pcFileName,1,6) = "ftp://":U) THEN
    RETURN "U":U.

  /* If the first two characters are // and we are on a WIN32 machine,
     it's a UNC file name */
  IF (SUBSTRING(pcFileName,1,2) = "//":U OR
      SUBSTRING(pcFileName,1,2) = "~\~\":U) THEN
    RETURN "N":U.

  /* If the second character is a colon, or there is a backslash
     anywhere in this filename, it is DOS filename */
  IF SUBSTRING(pcFileName,2,1) = ":":U OR
     INDEX(pcFileName,"~\":U) <> 0 THEN
    RETURN "D":U.

  /* If the first character is a / we've got a Unix file. */
  IF SUBSTRING(pcFileName,1,1) = "/":U THEN
   RETURN "X":U.

  /* Now we're down to figuring out from the operating system that we're on
     the type of file. */
  IF OPSYS = "UNIX":U THEN
    RETURN "X":U.

  RETURN "D":U.   /* If all else fails it must be DOS */
END FUNCTION.   /* detectFileType */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION formatPersonDetails Include 
FUNCTION formatPersonDetails RETURNS CHARACTER
  (pcLastName  AS CHARACTER,
   pcFirstName AS CHARACTER,
   pcInitials  AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Format the specified person details in a useful string to represent
            the data similarly with viewers in the system
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPersonDetails AS CHARACTER NO-UNDO.
  
  IF pcLastName  = ? THEN pcLastName  = "":U.
  IF pcFirstName = ? THEN pcFirstName = "":U.
  IF pcInitials  = ? THEN pcInitials  = "":U.
  
  ASSIGN pcLastName  = TRIM(pcLastName)
         pcFirstName = TRIM(pcFirstName)
         pcInitials  = TRIM(pcInitials).

  IF pcLastName <> "":U THEN DO:
    ASSIGN cPersonDetails = pcLastName.
    
    IF pcInitials <> "":U THEN
      ASSIGN cPersonDetails = cPersonDetails + ", ":U + pcInitials + ".":U.
    
    IF pcFirstName <> "":U THEN
      ASSIGN cPersonDetails = cPersonDetails + " (":U + pcFirstName + ")":U.
  END.
  
  RETURN cPersonDetails.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEntityCacheBuffer Include 
FUNCTION getEntityCacheBuffer RETURNS HANDLE
  ( pcEntity    AS CHARACTER,
    pcTableName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the buffer handle of the temp-table used to store the cached 
            entity mnemonic buffer.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer                 AS HANDLE                   NO-UNDO.
  
  /* Make sure the entity is cached */
  RUN cacheEntity IN TARGET-PROCEDURE (pcEntity, 
                                       pcTableName).
  
  /* If for some weird reason we still don't have any
     cached entities - return unknown */
  IF NOT CAN-FIND(FIRST ttEntityMnemonic) THEN
    ASSIGN hBuffer = ?.
  ELSE
    ASSIGN hBuffer = BUFFER ttEntityMnemonic:HANDLE.

  RETURN hBuffer.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEntityFieldCacheBuffer Include 
FUNCTION getEntityFieldCacheBuffer RETURNS HANDLE
  ( pcEntity    AS CHARACTER,
    pcTableName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the buffer handle of the temp-table used to store the cached 
            entity display field buffer.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer                 AS HANDLE                   NO-UNDO.
  
  /* Make sure the entity is cached */
  RUN cacheEntityDisplayFields IN TARGET-PROCEDURE (pcEntity, pcTableName).

  /* If we are passed an entity or table name we 
     want to check if they exist in the cache and if
     not we want to refresh the cache */
  IF pcEntity <> "":U THEN DO:
    IF NOT CAN-FIND(FIRST ttEntityMnemonic) OR
      (pcEntity <> "*":U AND 
       NOT CAN-FIND(FIRST ttEntityMnemonic
                    WHERE ttEntityMnemonic.entity_mnemonic = pcEntity)) THEN
      RUN refreshMnemonicsCache IN TARGET-PROCEDURE.
  END.
  IF pcTableName <> "":U THEN DO:
    IF NOT CAN-FIND(FIRST ttEntityMnemonic) OR
      (pcTableName <> "*":U AND 
       NOT CAN-FIND(FIRST ttEntityMnemonic
                    WHERE ttEntityMnemonic.entity_mnemonic_description = pcTableName)) THEN
      RUN refreshMnemonicsCache IN TARGET-PROCEDURE.
  END.
  
  IF pcEntity = "":U AND
     pcTableName = "":U AND
     NOT CAN-FIND(FIRST ttEntityMnemonic) THEN
    RUN refreshMnemonicsCache IN TARGET-PROCEDURE.
  
  /* If for some weird reason we still don't have any
     cached entities - return unknown */
  IF NOT CAN-FIND(FIRST ttEntityDisplayField) THEN
    hBuffer = ?.
  ELSE
    ASSIGN hBuffer = BUFFER ttEntityDisplayField:HANDLE.

  RETURN hBuffer.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHighKey Include 
FUNCTION getHighKey RETURNS CHARACTER
  ( INPUT pcCollationTableName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Function to return the character key with the highest sort rank
           for the given collation.
           You can then use this character to make a high key
           For example to search all names from "A" to "B", inclusive,
           you would code:
           
           Assign low = "A"
                  high = "B" + Get-High-Key(session:cpcoll).
                  
           For each customer where name >= low and name <= high.
        
           If you are preparing to use the COMPARE statement 
           or COLLATE  phrase with a specified collation table name, then
           you can supply that table name to this function to get the
           high key for that collation.
    Notes: This code was submitted by Tex Texin 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMaxChar  AS CHARACTER INIT "" NO-UNDO.
  DEFINE VARIABLE iLoop     AS INTEGER NO-UNDO.
  DEFINE VARIABLE iByte-1   AS INTEGER NO-UNDO.
  DEFINE VARIABLE cTestChar AS CHARACTER CASE-SENSITIVE NO-UNDO.

  /* Are we single-byte, double-byte or Unicode */
  IF SESSION:CPINTERNAL = "UTF-8" THEN
    cMaxChar = CHR(15712190). /* For binary sort cMaxChar = 0xFFEF */
  ELSE DO: 
    /* test for double-bytes
       dbcs leadbyte/tailbyte
       shift-jis 252/252
       eucjis    254/254

       big-5     254/254
       cp950     254/254

       ksc5601   254/254
       cp949     254/254
       cp1361    249/254

       gb2312    254/254
       cp936     254/254 */
    DO iLoop = 255 TO 245 BY -1: /* any lead bytes ? (1361 is lowest at 249)*/
      IF IS-LEAD-BYTE(CHR(iLoop * 256 + 245)) THEN DO:
        iByte-1 = iLoop.
        LEAVE.
      END.
    END.
    IF iByte-1 > 0 THEN 
      DO iLoop = 255 TO 250 BY -1: /* find max tail-byte (SJIS is low at 252)*/
        IF CHR(iByte-1 * 256 + iLoop) <> "" THEN DO:
          cMaxChar = CHR(iByte-1 * 256 + iLoop).
          LEAVE.
        END.
      END.
  END. /* ELSE */

  IF cMaxChar = "" THEN  /* if not multi-byte get the single-byte cMaxChar */
  DO:
    IF SESSION:CPCOLL = pcCollationTableName OR pcCollationTableName = "" THEN
       /* if it's the session, use the fast approach */
    DO iLoop = 255 TO 1 BY -1 WITH DOWN FRAME ff:
      cTestChar = CHR(iLoop).
      IF cMaxChar < cTestChar THEN cMaxChar = cTestChar.
    END.
    ELSE DO iLoop = 255 TO 1 BY -1:
      cTestChar = CHR(iLoop).
      IF COMPARE(cMaxChar,"lt",cTestChar,"case-sensitive",pcCollationTableName) THEN
        cMaxChar = cTestChar.
    END.
  END.

   /* not likely to get a string with 3 of these
      so if desired high key begins with "B" and cMaxChar is "z"
      this becomes "Bzzz" */
   RETURN (cMaxChar + cMaxChar + cMaxChar).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInternalEntries Include 
FUNCTION getInternalEntries RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: To pass back internal entries of SDO as internal-entries cannot be
           accessed for remote proxy procedures.
    Notes:  
------------------------------------------------------------------------------*/
    RETURN THIS-PROCEDURE:INTERNAL-ENTRIES.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getKeyField Include 
FUNCTION getKeyField RETURNS CHARACTER
  ( pcEntityMnemonic AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Given an Entity Mnemonic (pcEntityMnemonic) look up the cached 
            record in ttEntityMnemonic temp-table and return the field that 
            serves as the key field.
            
    Notes:  
            
------------------------------------------------------------------------------*/
  /* Make sure the entity is cached */
  RUN cacheEntity IN TARGET-PROCEDURE (pcEntityMnemonic, /* Entity Mnemonic */
                                       "":U).            /* Table */

  FIND ttEntityMnemonic 
       WHERE ttEntityMnemonic.entity_mnemonic = pcEntityMnemonic NO-ERROR.

  IF NOT AVAILABLE ttEntityMnemonic THEN
    RETURN "":U.
    
  IF ttEntityMnemonic.entity_key_field <> "":U THEN
    RETURN ttEntityMnemonic.entity_key_field.
  ELSE IF ttEntityMnemonic.Table_has_object_field AND ttEntityMnemonic.entity_object_field <> "":U THEN
    RETURN ttEntityMnemonic.entity_object_field.
  ELSE /* No Key or Obj field specified for this object */
     RETURN "":U.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNextSequenceValue Include 
FUNCTION getNextSequenceValue RETURNS CHARACTER
  ( INPUT pdCompanyObj      AS DECIMAL,
    INPUT pcEntityMnemonic  AS CHARACTER,
    INPUT pcSequenceTLA     AS CHARACTER   ):
/*------------------------------------------------------------------------------
  Purpose:  Returns the next sequence value for a given seqeunce.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cNextSequenceValue              AS CHARACTER            NO-UNDO.

    RUN getSequenceValue IN TARGET-PROCEDURE ( INPUT  pdCompanyObj,
                                               INPUT  pcEntityMnemonic,
                                               INPUT  pcSequenceTLA,
                                               OUTPUT cNextSequenceValue
                                             ).

    RETURN cNextSequenceValue.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjField Include 
FUNCTION getObjField RETURNS CHARACTER
  ( pcEntityMnemonic AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Given an Entity Mnemonic (pcEntityMnemonic) look up the cached 
            record in ttEntityMnemonic temp-table and return the field that 
            serves as the xxx_obj field.
            
    Notes:  The rules are:
            IF no record exists in the ttEntityMnemonic table or then
            ttEntityMnemonicCache.Table_has_object_field is "NO" 
               then return "" (blank)
            Else if ttEntityMnemonicCache.Entity_object_field is nonBlank
               then return that value
            Else return the traditional "_obj" field name.
            
------------------------------------------------------------------------------*/
  /* Make sure the entity is cached */
  RUN cacheEntity IN TARGET-PROCEDURE (pcEntityMnemonic, /* Entity Mnemonic */
                                       "":U).            /* Table */

  FIND ttEntityMnemonic 
       WHERE ttEntityMnemonic.entity_mnemonic = pcEntityMnemonic 
       NO-ERROR.

  IF NOT AVAILABLE ttEntityMnemonic OR NOT ttEntityMnemonic.table_has_object_field THEN
     RETURN "":U.   /* There is no _obj field */
  
  ELSE IF ttEntityMnemonic.entity_object_field <> "" THEN
     RETURN ttEntityMnemonic.entity_object_field.
  
  ELSE /* No Obj field specified for this table */
     RETURN "":U.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOEMCode Include 
FUNCTION getOEMCode RETURNS CHARACTER
  (INPUT pcEntityMnemonic AS CHARACTER, INPUT pdEntityObj AS DECIMAL) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the reference number, -code or similar key field
  Parameters:  pcEntityMnemonic
               pdEntityObj
  Notes:       See function getOEMDescription for name/description field
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEntityDescriptor      AS CHARACTER            NO-UNDO.
  RUN getEntityDescription IN TARGET-PROCEDURE (INPUT pcEntityMnemonic, 
                                                INPUT pdEntityObj, 
                                                INPUT "Code":U, 
                                                OUTPUT cEntityDescriptor).

  RETURN cEntityDescriptor.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOEMDescription Include 
FUNCTION getOEMDescription RETURNS CHARACTER
  (INPUT pcEntityMnemonic AS CHARACTER, INPUT pdEntityObj AS DECIMAL) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the name or similar description field
  Parameters:  pcEntityMnemonic
               pdEntityObj
  Notes:       See function getOEMCode for reference number, -code etc.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEntityDescriptor      AS CHARACTER            NO-UNDO.
  RUN getEntityDescription IN TARGET-PROCEDURE (INPUT pcEntityMnemonic, 
                                                INPUT pdEntityObj, 
                                                INPUT "Description":U, 
                                                OUTPUT cEntityDescriptor).

  RETURN cEntityDescriptor.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPropertyFromList Include 
FUNCTION getPropertyFromList RETURNS CHARACTER
  (pcPropertyList AS CHARACTER,
   pcPropertyName AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose:  Return the value of the specified property in the specified property
            list
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPropertyName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPropertyValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntry         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEntry         AS INTEGER    NO-UNDO.
  
  DO iEntry = 1 TO NUM-ENTRIES(pcPropertyList, CHR(3)):
    ASSIGN cEntry        = ENTRY(iEntry, pcPropertyList, CHR(3))
           cPropertyName = ENTRY(1, cEntry, CHR(4)).
    
    IF cPropertyName = pcPropertyName THEN
      ASSIGN cPropertyValue = ENTRY(2, cEntry, CHR(4)).
  END.

  RETURN cPropertyValue.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSequenceConfirmation Include 
FUNCTION getSequenceConfirmation RETURNS LOGICAL
  ( INPUT pdCompanyObj      AS DECIMAL,
    INPUT pcEntityMnemonic  AS CHARACTER,
    INPUT pcSequenceTLA    AS CHARACTER    ):
/*------------------------------------------------------------------------------
  Purpose:  Tells the caller whether the specified sequence is valid
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lSuccess                    AS LOGICAL                  NO-UNDO.

    RUN getSequenceExist IN TARGET-PROCEDURE ( INPUT  pdCompanyObj,
                                               INPUT  pcEntityMnemonic,
                                               INPUT  pcSequenceTLA,
                                               OUTPUT lSuccess
                                              ).

    RETURN lSuccess.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSessionFilterSet Include 
FUNCTION getSessionFilterSet RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Retrieves the filter set applicable for the current session
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cProfileData  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterSet    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE rRowID        AS ROWID      NO-UNDO.
  
  rRowID = ?.

  RUN getProfileData IN gshProfileManager (INPUT        "General":U,
                                           INPUT        "DispRepos":U,
                                           INPUT        "SessionFS":U,
                                           INPUT        NO,
                                           INPUT-OUTPUT rRowID,
                                                 OUTPUT cProfileData).

  ASSIGN
      cProfileData = (IF cProfileData = "?":U OR cProfileData = ? THEN "":U ELSE cProfileData)
      cFilterSet   = TRIM(cProfileData).

  RETURN cFilterSet.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getStatusObj Include 
FUNCTION getStatusObj RETURNS DECIMAL
  ( INPUT pcCategoryType            AS CHARACTER,
    INPUT pcCategoryGroup           AS CHARACTER,
    INPUT pcCategorySubGroup        AS CHARACTER    ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Status Obj to a calling procedure
    Notes:  * This is merely a wrapper function, which returns the object number.
              The getStatusRecord procedure maintains the cached status records.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cResultSet                  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE dStatusObj                  AS DECIMAL              NO-UNDO.

    /* Fetches the status record from the cache, and from the DB if needed. */
    RUN getStatusRecord IN TARGET-PROCEDURE ( INPUT  pcCategoryType,
                                              INPUT  pcCategoryGroup,
                                              INPUT  pcCategorySubGroup,
                                              INPUT  dStatusObj,
                                              INPUT  "tStatusObj":U,
                                              OUTPUT cResultSet
                                            ).

    ASSIGN dStatusObj = DECIMAL(ENTRY(1, cResultSet, CHR(4))) NO-ERROR.

    RETURN dStatusObj.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getStatusShortDesc Include 
FUNCTION getStatusShortDesc RETURNS CHARACTER
  ( INPUT pdStatusObj AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Status Obj to a calling procedure
    Notes:  * This is merely a wrapper function, which returns the object number.
              The getStatusRecord procedure maintains the cached status records.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cResultSet                  AS CHARACTER            NO-UNDO.
    
    /* Fetches the status record from the cache, and from the DB if needed. */
    RUN getStatusRecord IN TARGET-PROCEDURE ( INPUT  "":U,
                                              INPUT  "":U,
                                              INPUT  "":U,
                                              INPUT  pdStatusObj,
                                              INPUT  "tStatusShortDesc":U,
                                              OUTPUT cResultSet
                                            ).

    RETURN cResultSet.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getStatusTLA Include 
FUNCTION getStatusTLA RETURNS CHARACTER
  ( INPUT pdStatusObj AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Status TLA to a calling procedure
    Notes:  * This is merely a wrapper function, which returns the object number.
              The getStatusRecord procedure maintains the cached status records.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cResultSet                  AS CHARACTER            NO-UNDO.
    
    /* Fetches the status record from the cache, and from the DB if needed. */
    RUN getStatusRecord IN TARGET-PROCEDURE ( INPUT  "":U,
                                              INPUT  "":U,
                                              INPUT  "":U,
                                              INPUT  pdStatusObj,
                                              INPUT  "tStatusTLA":U,
                                              OUTPUT cResultSet
                                            ).

    RETURN cResultSet.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTableDumpName Include 
FUNCTION getTableDumpName RETURNS CHARACTER
  (pcQuery AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  To see if a specified table exists in a database
    
    Notes:  The input parameter has two entries pipe ("|") delimited:
            Entry 1 - Database name
            Entry 2 - Table name
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cTableDumpName          AS CHARACTER                NO-UNDO.

    RUN getDumpName IN TARGET-PROCEDURE ( INPUT pcQuery, OUTPUT cTableDumpName ) NO-ERROR.

    RETURN cTableDumpName.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdatableTableInfo Include 
FUNCTION getUpdatableTableInfo RETURNS CHARACTER
  (INPUT phDataSource AS WIDGET-HANDLE):
/*------------------------------------------------------------------------------
  Purpose:  Returns a CHR(4) delimited list of the following information about
            the updatable table in the supplied data source
            Entry 1 - Owning Entity Mnemonic
            Entry 2 - Table Name
            Entry 3 - Key Field of Table
            
    Notes:  The data source handle should be the handle of an SDO that you want
            to retrieve data for.
            This function only differs from getUpdatableTableInfoObj in that it returns
            a key field for entry 3 in the list.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cUpdatableColumns       AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE cUpdatableTable         AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE cReturnValue            AS CHARACTER     NO-UNDO.  

    ASSIGN cUpdatableTable = "":U.
    
    IF VALID-HANDLE(phDataSource) THEN
      ASSIGN cUpdatableColumns = DYNAMIC-FUNCTION("getUpdatableColumns":U IN phDataSource)
             cUpdatableTable   = DYNAMIC-FUNCTION("columnTable":U         IN phDataSource, INPUT ENTRY(1, cUpdatableColumns)).

    IF cUpdatableTable <> "":U THEN
      RUN getTableInfo IN TARGET-PROCEDURE (INPUT cUpdatableTable, OUTPUT cReturnValue) NO-ERROR.

    RETURN cReturnValue.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdatableTableInfoObj Include 
FUNCTION getUpdatableTableInfoObj RETURNS CHARACTER
  (INPUT phDataSource AS WIDGET-HANDLE):
/*------------------------------------------------------------------------------
  Purpose:  Returns a CHR(4) delimited list of the following information about
            the updatable table in the supplied data source
            Entry 1 - Owning Entity Mnemonic
            Entry 2 - Table Name
            Entry 3 - Obj Field of Table
            
    Notes:  The data source handle should be the handle of an SDO that you want
            to retrieve data for.
            This function only differs from getUpdatableTableInfo in that it returns
            an obj field for entry 3 in the list.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cUpdatableColumns       AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE cUpdatableTable         AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE cReturnValue            AS CHARACTER     NO-UNDO.  

    ASSIGN cUpdatableTable = "":U.

    IF VALID-HANDLE(phDataSource) THEN
        ASSIGN cUpdatableColumns = DYNAMIC-FUNCTION("getUpdatableColumns":U IN phDataSource)
               cUpdatableTable   = DYNAMIC-FUNCTION("columnTable":U IN phDataSource, INPUT ENTRY(1, cUpdatableColumns)).

    IF cUpdatableTable <> "":U THEN
        RUN getTableInfoObj IN TARGET-PROCEDURE (INPUT cUpdatableTable, OUTPUT cReturnValue) NO-ERROR.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN cReturnValue.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION haveOutstandingUpdates Include 
FUNCTION haveOutstandingUpdates RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  This table checks the ryt_dbupdate_status record for any outstanding
            updates and returns a value indicating whether there are any.
    Notes:  
------------------------------------------------------------------------------*/
  &IF DEFINED(server-side) <> 0 &THEN
    DEFINE BUFFER bryt_dbupdate_status FOR ryt_dbupdate_status.
    /* If we're on the server side, we have a connection to the database. 
       See if we can find an ryt_dbupdate_status record that has not been
       applied */

    RETURN CAN-FIND(FIRST bryt_dbupdate_status 
                      WHERE bryt_dbupdate_status.update_completed = NO).
  
  &ELSE
    /* If we're on the client side, we don't have a connection to the database.
       The connection to the AppServer will fail so we can just return NO
       here. */
    RETURN NO.
  &ENDIF


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION listLookup Include 
FUNCTION listLookup RETURNS CHARACTER
  ( INPUT pcElement   AS CHARACTER,
    INPUT pcSource    AS CHARACTER,
    INPUT pcTarget    AS CHARACTER,
    INPUT pcDelimiter AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the value of an element in pcTarget as indicated by the position for
            pcElement in pcSource. If pcDelimiter is empty, it defaults to "," (comma)
    Notes:  
------------------------------------------------------------------------------*/

  IF pcDelimiter = ""
  THEN
    ASSIGN
      pcDelimiter = ",".

  IF NUM-ENTRIES(pcTarget,pcDelimiter) >= LOOKUP(pcElement,pcSource,pcDelimiter) 
  THEN
    RETURN ENTRY(LOOKUP(pcElement,pcSource,pcDelimiter),pcTarget,pcDelimiter).
  ELSE 
    RETURN "".   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPropertyValueInList Include 
FUNCTION setPropertyValueInList RETURNS CHARACTER
  (pcPropertyList   AS CHARACTER,
   pcPropertyName   AS CHARACTER,
   pcPropertyValue  AS CHARACTER,
   pcAction         AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose:  Find the property in the property list and add / replace /remove it 
            with the specified property value depending on the action specified
    Notes:  pcAction should have a value of "REMOVE" if a property is to be 
            deleted. If pcAction is anything else, the function will add the 
            property if it is not in the list, else if it is, it will replace it.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cNewPropertyList      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPropertyValue        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPropertyName         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntry                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iNumEntries           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEntry                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lFound                AS LOGICAL    NO-UNDO.
      
  ASSIGN iNumEntries = NUM-ENTRIES(pcPropertyList, CHR(3))
         lFound      = FALSE.
  
  DO iEntry = 1 TO iNumEntries:
    ASSIGN cEntry         = ENTRY(iEntry, pcPropertyList, CHR(3))
           cPropertyName  = ENTRY(1, cEntry, CHR(4))
           cPropertyValue = ENTRY(2, cEntry, CHR(4)) NO-ERROR.
    
    IF cPropertyName = pcPropertyName THEN 
      ASSIGN cEntry = pcPropertyName + CHR(4) + pcPropertyValue
             lFound = TRUE.
             
    IF lFound AND pcAction = "REMOVE" THEN
      NEXT.
      
    IF cNewPropertyList = "" THEN
      ASSIGN cNewPropertyList = cEntry.
    ELSE
      ASSIGN cNewPropertyList = cNewPropertyList + CHR(3) + cEntry.
      
  END.
  
  IF NOT lFound AND pcAction <> "REMOVE" THEN
  DO:
    IF cNewPropertyList <> "" THEN
       ASSIGN cNewPropertyList = cNewPropertyList + CHR(3).
    ASSIGN cNewPropertyList = cNewPropertyList  + pcPropertyName + CHR(4) + pcPropertyValue.
  END.
    
  IF cNewPropertyList = ? THEN
    RETURN "".
  ELSE
    RETURN cNewPropertyList.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setWidgetAttribute Include 
FUNCTION setWidgetAttribute RETURNS LOGICAL
    ( INPUT phWidget            AS HANDLE,
      INPUT pcAttributeName     AS CHARACTER,
      INPUT pcAttributeValue    AS CHARACTER,
      INPUT pcAttributeDataType AS CHARACTER,
      INPUT phExternalCall      AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  Sets an attribute value for a widget handle.
    Notes:  If desired, the CREATE CALL... statement can be made externally, this
            will improve performance.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lDeleteCall AS LOGICAL    NO-UNDO.

    /* Only set this value if we are allowed to. */
    IF CAN-SET(phWidget, pcAttributeName) 
    THEN DO:
        IF NOT VALID-HANDLE(phExternalCall) 
        THEN DO:
            CREATE CALL phExternalCall.
            ASSIGN phExternalCall:CALL-TYPE = SET-ATTR-CALL-TYPE
                   lDeleteCall              = YES.
        END.

        phExternalCall:IN-HANDLE = phWidget.                 /* Widget handle to apply to */
        phExternalCall:CALL-NAME = pcAttributeName.          /* Attribute name to set */
        
        /* With a SET-ATTR call type we need to pass the value that we are setting as *
         * the only input parameter                                                   */

        phExternalCall:NUM-PARAMETERS = 1.                   /* 1 parameter for the value to set */
        phExternalCall:SET-PARAMETER(1, 
                            pcAttributeDataType,    /* The attribute's data type */
                            "INPUT",                /* Always INPUT for a SET-ATTR call */
                            pcAttributeValue        /* The value to set */
                            ) NO-ERROR.
        phExternalCall:INVOKE.                               /* Invoke the call */

        IF lDeleteCall = YES THEN
            DELETE OBJECT phExternalCall.                    /* Delete the call object */
    END.    /* can set attribute */

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

