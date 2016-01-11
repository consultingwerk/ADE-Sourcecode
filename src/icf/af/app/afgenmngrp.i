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

{afglobals.i}

DEFINE STREAM sInput.

DEFINE TEMP-TABLE ttUser                NO-UNDO LIKE gsm_user.

{ry/app/ryobjretri.i}
{dynlaunch.i &Define-Only = YES}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

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
         HEIGHT             = 21.24
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

    RUN plipShutdown.

    DELETE PROCEDURE THIS-PROCEDURE.
    RETURN.
END.

&IF DEFINED(server-side) <> 0 &THEN
/* This is the server-side so make these external procedures internal */
PROCEDURE gsgetstatp:
    DEFINE BUFFER ttStatusCache         FOR ttStatusCache.
    {af/app/gsgetstatp.p}
END PROCEDURE.

PROCEDURE gsgetenmnp:
    /* Get the cache of mnemonic table records from the server */
    {af/app/gsgetenmnp.p}
END PROCEDURE.
PROCEDURE gsgetgsced:
    /* Get the cache of entity display field table records from the server */
    {af/app/gsgetgsced.p}
END PROCEDURE.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cacheEntity Include 
PROCEDURE cacheEntity :
/*------------------------------------------------------------------------------
  Purpose:     Caches the entity passed in.  The procedure will:
               1) Retrieve the entity object and instances from the rep manager
               2) Populate the ttEntityMnemonic table from the rep man cache.
               3) Populate the ttDataField table from the rep man cache.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcEntityToCache AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcTableToCache  AS CHARACTER  NO-UNDO.

/* Store how the fields on ttEntityDisplayField map to the attributes against the datafield in the repository */
DEFINE VARIABLE cRepDataFieldAttr  AS CHARACTER  NO-UNDO
    INITIAL "name,,label,ColumnLabel,format,tableName":U.
DEFINE VARIABLE cTTDispFieldFields AS CHARACTER  NO-UNDO
    INITIAL "display_field_name,display_field_order,display_field_label,display_field_column_label,display_field_format,entity_mnemonic":U.

DEFINE VARIABLE dRecordIdentifier   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE hObjectBuffer       AS HANDLE    NO-UNDO.
DEFINE VARIABLE ghAttrBuffer        AS HANDLE    NO-UNDO.
DEFINE VARIABLE hField              AS HANDLE    NO-UNDO.
DEFINE VARIABLE iFieldCnt           AS INTEGER   NO-UNDO.
DEFINE VARIABLE hObjectTable        AS HANDLE    NO-UNDO.
DEFINE VARIABLE cSessionResultCodes AS CHARACTER NO-UNDO.
DEFINE VARIABLE hDisplayFieldBuffer AS HANDLE    NO-UNDO.
DEFINE VARIABLE hAttrBuffer         AS HANDLE    NO-UNDO.
DEFINE VARIABLE iCnt                AS INTEGER   NO-UNDO.
DEFINE VARIABLE cFieldName          AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFieldValue         AS CHARACTER NO-UNDO.

DEFINE BUFFER dataField_object FOR cache_object.
DEFINE BUFFER container_object FOR cache_object.

/* Already cached? */
IF CAN-FIND(FIRST ttEntityMnemonic
            WHERE ttEntityMnemonic.entity_mnemonic = pcEntityToCache) 
OR CAN-FIND(FIRST ttEntityMnemonic
            WHERE ttEntityMnemonic.entity_mnemonic_description = pcTableToCache) THEN
    RETURN.

/* First, we always want to work with the tablename.  If the user has only passed in an entity FLA, map it to a tablename */
IF pcTableToCache = "":U OR pcTableToCache = ? THEN
    FIND ttEntityMnemonic WHERE ttEntityMnemonic.entity_mnemonic = pcEntityToCache NO-ERROR.
ELSE
    FIND ttEntityMnemonic WHERE ttEntityMnemonic.entity_mnemonic_description = pcTableToCache NO-ERROR.

IF NOT AVAILABLE ttEntityMnemonic
THEN DO:
    RUN cacheEntityMapping IN TARGET-PROCEDURE (INPUT  pcEntityToCache,
                                                INPUT  pcTableToCache, /* Table to cache */
                                                OUTPUT TABLE ttEntityMnemonic APPEND )  NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

    IF pcTableToCache = "":U OR pcTableToCache = ? THEN
        FIND ttEntityMnemonic 
             WHERE ttEntityMnemonic.entity_mnemonic = pcEntityToCache
             NO-ERROR.
    ELSE
        FIND ttEntityMnemonic
             WHERE ttEntityMnemonic.entity_mnemonic_description = pcTableToCache
             NO-ERROR.
END.    /* n/a entity */

IF AVAILABLE ttEntityMnemonic THEN
    ASSIGN pcEntityToCache = ttEntityMnemonic.entity_mnemonic
           pcTableToCache  = ttEntityMnemonic.entity_mnemonic_description.
ELSE
    RETURN "ADM-ERROR":U.

EMPTY TEMP-TABLE cache_object. /* The local one, not the rep manager one */

IF VALID-HANDLE(gshRepositoryManager)
AND DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                     INPUT pcTableToCache,
                     INPUT "":U,        /* Result codes are irrelevant for Entity objects */
                     INPUT "":U,        /* Run attribute */
                     INPUT NO       )   /*  Design mode  */
THEN DO:
    /* The dataFields have been retrieved and cached.  Move them into local buffers now */
    ASSIGN hObjectBuffer     = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?)
           dRecordIdentifier = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
           NO-ERROR.

    IF ERROR-STATUS:ERROR OR dRecordIdentifier = ? THEN
        RETURN "ADM-ERROR":U.

    /* Make the cache_object table-handle a static TT. It makes our code faster and easier to read. */
    ASSIGN hObjectTable        = IF hObjectBuffer:TYPE EQ "BUFFER":U THEN hObjectBuffer:TABLE-HANDLE ELSE hObjectBuffer
           hDisplayFieldBuffer = BUFFER ttEntityDisplayField:HANDLE /* For later use */.

    RUN makeObjectTTHandleStatic IN TARGET-PROCEDURE (INPUT TABLE-HANDLE hObjectTable).

    /* Move the entity attribute information into the ttEntityMnemonic table */
    FIND container_object WHERE container_object.tRecordIdentifier = dRecordIdentifier NO-ERROR.

    ASSIGN hAttrBuffer = container_object.tClassBufferHandle NO-ERROR.
    hAttrBuffer:FIND-FIRST("WHERE tRecordIdentifier = ":U + QUOTER(container_object.tRecordIdentifier)) NO-ERROR.
    IF NOT hAttrBuffer:AVAILABLE THEN
        RETURN "ADM-ERROR":U.

    /* At this stage of proceedings we should have the entity cached,
     * so we donøt check for availability. */
    FIND FIRST ttEntityMnemonic WHERE
               ttEntityMnemonic.entity_mnemonic_description = pcTableToCache
               NO-ERROR.   
    ASSIGN ttEntityMnemonic.entity_mnemonic_obj = container_object.tSmartObjectObj.

    /* Now populate the datafield cache */
    fe-blk:
    FOR EACH dataField_object 
       WHERE dataField_object.tContainerRecordIdentifier = container_object.tRecordIdentifier:

        IF LOOKUP("dataField":U, dataField_object.tInheritsFromClasses) > 0
        THEN DO:
            ASSIGN ghAttrBuffer = dataField_object.tClassBufferHandle.
            ghAttrBuffer:FIND-FIRST("WHERE tRecordIdentifier = " + QUOTER(dataField_object.tRecordIdentifier)) NO-ERROR.

            hDisplayFieldBuffer:BUFFER-CREATE.
            hDisplayFieldBuffer:BUFFER-FIELD("entity_display_field_obj"):BUFFER-VALUE = dataField_object.tSmartObjectObj. /* Don't violate the unique index */

            DO iFieldCnt = 1 TO NUM-ENTRIES(cTTDispFieldFields):
                CASE iFieldCnt:
                    WHEN 1 /* Name */
                    THEN DO:
                        ASSIGN cFieldValue = ghAttrBuffer:BUFFER-FIELD("NAME":U):BUFFER-VALUE NO-ERROR.
                        /* If we can't get the field name from the class attributes, use the field's logical object name */
                        IF cFieldValue = "":U OR cFieldValue = ? THEN
                            ASSIGN cFieldValue = datafield_object.tObjectInstanceName.
                        ASSIGN hDisplayFieldBuffer:BUFFER-FIELD(ENTRY(iFieldCnt, cTTDispFieldFields)):BUFFER-VALUE = cFieldValue.
                    END.

                    WHEN 2 THEN
                        ASSIGN hDisplayFieldBuffer:BUFFER-FIELD(ENTRY(iFieldCnt, cTTDispFieldFields)):BUFFER-VALUE =
                               dataField_object.tInstanceOrder.

                    OTHERWISE
                        ASSIGN hDisplayFieldBuffer:BUFFER-FIELD(ENTRY(iFieldCnt, cTTDispFieldFields)):BUFFER-VALUE = 
                               ghAttrBuffer:BUFFER-FIELD(ENTRY(iFieldCnt, cRepDataFieldAttr)):BUFFER-VALUE
                               NO-ERROR.
                END CASE.
            END.
        END.
    END.
END.
ELSE
    RETURN "ADM-ERROR":U.

EMPTY TEMP-TABLE cache_object. /* The local one, not the rep manager one */

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cacheEntityMapping Include 
PROCEDURE cacheEntityMapping :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcEntity AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcTable  AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttEntityMap.

DEFINE VARIABLE httEntityMap    AS HANDLE     NO-UNDO.

&IF DEFINED(server-side) = 0 &THEN    
    /* Even though this is an output table, setting the handle will ensure that
     * the returned records will be put into the correct table automatically.   */
    ASSIGN httEntityMap = TEMP-TABLE ttEntityMap:HANDLE.

    {dynlaunch.i &PLIP              = "'GeneralManager'"
                 &iProc             = "'cacheEntityMapping'"
                 &compileStaticCall = NO
                 &mode1  = INPUT   &parm1  = pcEntity     &dataType1  = CHARACTER
                 &mode2  = INPUT   &parm2  = pcTable      &dataType2  = CHARACTER
                 &mode3  = OUTPUT  &parm3  = httEntityMap &dataType3  = TABLE-HANDLE
    }
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
&ELSE
    /* This table is just used for passing stuff back. */
    EMPTY TEMP-TABLE ttEntityMap.

    IF pcEntity <> "":U THEN
        FIND FIRST gsc_entity_mnemonic NO-LOCK                
           WHERE gsc_entity_mnemonic.entity_mnemonic = (IF pcEntity <> "":U THEN pcEntity ELSE gsc_entity_mnemonic.entity_mnemonic) NO-ERROR.
    ELSE
        FIND FIRST gsc_entity_mnemonic NO-LOCK
           WHERE gsc_entity_mnemonic.entity_mnemonic_description = (IF pcTable <> "":U THEN pcTable ELSE gsc_entity_mnemonic.entity_mnemonic) NO-ERROR.
    IF AVAILABLE gsc_entity_mnemonic THEN
    DO:
         CREATE ttEntityMap.
         BUFFER-COPY gsc_entity_mnemonic
                  TO ttEntityMap
              ASSIGN ttEntityMap.HasAudit   = CAN-FIND(FIRST gst_audit WHERE gst_audit.owning_entity_mnemonic = gsc_entity_mnemonic.entity_mnemonic)
                                           OR CAN-FIND(FIRST gst_audit WHERE gst_audit.owning_entity_mnemonic = gsc_entity_mnemonic.entity_mnemonic_description)
                     ttEntityMap.HasComment = CAN-FIND(FIRST gsm_comment WHERE gsm_comment.owning_entity_mnemonic = gsc_entity_mnemonic.entity_mnemonic)
                                           OR CAN-FIND(FIRST gsm_comment WHERE gsm_comment.owning_entity_mnemonic = gsc_entity_mnemonic.entity_mnemonic_description)
                     ttEntityMap.HasAutoComment = ttEntityMap.HasComment.
    END.    /* available entity mnemonic */
    ASSIGN httEntityMap = TEMP-TABLE ttEntityMap:HANDLE.
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
    {
     dynlaunch.i &PLIP              = "'GeneralManager'"
                 &iProc             = "'CheckIfOverlaps'"
                 &compileStaticCall = NO                 
                 &mode1  = INPUT  &parm1  = pcTable            &dataType1  = CHARACTER
                 &mode2  = INPUT  &parm2  = pcKeyField         &dataType2  = CHARACTER
                 &mode3  = INPUT  &parm3  = pcFromField        &dataType3  = CHARACTER
                 &mode4  = INPUT  &parm4  = pcToField          &dataType4  = CHARACTER
                 &mode5  = INPUT  &parm5  = pdCurrentRecordObj &dataType5  = DECIMAL
                 &mode6  = INPUT  &parm6  = pdKeyValue         &dataType6  = DECIMAL                 
                 &mode7  = INPUT  &parm7  = ptFromValue        &dataType7  = DATE
                 &mode8  = INPUT  &parm8  = ptToValue          &dataType8  = DATE
                 &mode9  = INPUT  &parm9  = pcAdditionalWhere  &dataType9  = CHARACTER
                 &mode10 = OUTPUT &parm10 = plOverlap          &dataType10 = LOGICAL
                 &mode11 = OUTPUT &parm11 = ptOverlapFrom      &dataType11 = DATE
                 &mode12 = OUTPUT &parm12 = ptOverlapTo        &dataType12 = DATE
    }
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
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
                               + "   WHERE ":U + cValueBuffer + ".":U + pcKeyField  + " = ":U + STRING(pdKeyValue)
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
  
    /* remove decimals with commas for Europe */
    cQueryPrepareString = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, INPUT cQueryPrepareString).
    
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
               been imported for.  This is what this API is for.
------------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER plOnlyUseCache   AS LOGICAL    NO-UNDO. /* Redundant */
DEFINE OUTPUT       PARAMETER pcDBList         AS CHARACTER  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcAdditionalInfo AS CHARACTER  NO-UNDO. /* Not used yet, but we may need it later */

&IF DEFINED(server-side) = 0 &THEN /* we're client side, pass the request to the Appserver */
    {
     dynlaunch.i &PLIP              = "'GeneralManager'"
                 &iProc             = "'getDBsForImportedEntities'"
                 &compileStaticCall = NO
                 &mode1  = INPUT        &parm1  = plOnlyUseCache   &dataType1 = LOGICAL
                 &mode2  = OUTPUT       &parm2  = pcDBList         &dataType2 = CHARACTER
                 &mode3  = INPUT-OUTPUT &parm3  = pcAdditionalInfo &dataType3 = CHARACTER
    }
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.        
&ELSE
    FOR EACH gsc_entity_mnemonic NO-LOCK
       BREAK BY gsc_entity_mnemonic.entity_dbname:
        IF FIRST-OF(gsc_entity_mnemonic.entity_dbname) THEN
            ASSIGN pcDBList = pcDBList + ",":U + gsc_entity_mnemonic.entity_dbname.
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
    {
     dynlaunch.i &PLIP              = "'GeneralManager'"
                 &iProc             = "'getDBVersion'"
                 &compileStaticCall = NO                 
                 &mode1  = INPUT  &parm1  = pcLogicalNames &dataType1 = CHARACTER
                 &mode2  = OUTPUT &parm2  = pcVersions     &dataType2 = CHARACTER
    }
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
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
  RUN cacheEntity IN THIS-PROCEDURE ("":U,                    /* We don't know what the entity FLA is */
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
    {
     dynlaunch.i &PLIP              = "'GeneralManager'"
                 &iProc             = "'getEntityDescription'"
                 &compileStaticCall = NO                 
                 &mode1 = INPUT  &parm1 = pcEntityMnemonic   &dataType1 = CHARACTER
                 &mode2 = INPUT  &parm2 = pdEntityObj        &dataType2 = DECIMAL
                 &mode3 = INPUT  &parm3 = pcFieldName        &dataType3 = CHARACTER
                 &mode4 = OUTPUT &parm4 = pcEntityDescriptor &dataType4 = CHARACTER
    }
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
    DEFINE VARIABLE cQueryPrepareString             AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cTableObjectFieldName           AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hQuery                          AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hBuffer                         AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hDescriptionField               AS HANDLE       NO-UNDO.

    /* Make sure the entity is cached */
    RUN cacheEntity IN THIS-PROCEDURE (pcEntityMnemonic, /* Table FLA */
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
                                 + STRING(pdEntityObj)
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

    cQueryPrepareString = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, INPUT cQueryPrepareString).
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
               pcEntityFields - CHR(1)-delimited list of the entity mnemonic 
                                field names.
               pcEntityValues - CHR(1)-delimited list of the values of the above.
    Notes:   * This function uses the cached GSC-ENTITY-MNEMONIC table. If no
               record exists in the cache, then the return valeus are blank.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcEntity            AS CHARACTER            NO-UNDO.
    DEFINE OUTPUT PARAMETER pcEntityFields      AS CHARACTER            NO-UNDO.
    DEFINE OUTPUT PARAMETER pcEntityValues      AS CHARACTER            NO-UNDO.

    DEFINE VARIABLE cWidgetPool                     AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE cQueryPrepareString             AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE hQuery                          AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hBuffer                         AS HANDLE           NO-UNDO.
    DEFINE VARIABLE iFieldLoop                      AS INTEGER          NO-UNDO.
    DEFINE VARIABLE hCurrentField                   AS HANDLE           NO-UNDO.

    /* Make sure the entity is cached */
    RUN cacheEntity IN THIS-PROCEDURE ("":U, /* Table FLA */
                                       pcEntity).    /* Tablename */

    IF NOT CAN-FIND(FIRST ttEntityMnemonic
                    WHERE ttEntityMnemonic.entity_mnemonic = pcEntity) THEN
        RUN cacheEntity IN THIS-PROCEDURE (pcEntity, /* Table FLA */
                                           "":U).    /* Tablename */

    ASSIGN cWidgetPool= "queryWidgets":U.

    IF CAN-FIND(ttEntityMnemonic WHERE ttEntityMnemonic.entity_mnemonic = pcEntity) THEN
        ASSIGN cQueryPrepareString = "FOR EACH ttEntityMnemonic WHERE ttEntityMnemonic.entity_mnemonic = '":U + pcEntity + "'":U.
    ELSE
    IF CAN-FIND(ttEntityMnemonic WHERE ttEntityMnemonic.entity_mnemonic_description = pcEntity) THEN
        ASSIGN cQueryPrepareString = "FOR EACH ttEntityMnemonic WHERE ttEntityMnemonic.entity_mnemonic_description = '":U + pcEntity + "'":U.
    ELSE
        RETURN.

    CREATE WIDGET-POOL cWidgetPool.
    CREATE QUERY hQuery IN WIDGET-POOL cWidgetPool.

    ASSIGN hBuffer = BUFFER ttEntityMnemonic:HANDLE.

    hQuery:ADD-BUFFER(hBuffer).
    ASSIGN cQueryPrepareString = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, INPUT cQueryPrepareString).

    hQuery:QUERY-PREPARE(cQueryPrepareString).
    hQuery:QUERY-OPEN().

    /* There should only be one record available here. */
    hQuery:GET-FIRST(NO-LOCK).

    IF hBuffer:AVAILABLE THEN
    DO iFieldLoop = 1 TO hBuffer:NUM-FIELDS:
        ASSIGN hCurrentField = hBuffer:BUFFER-FIELD(iFieldLoop).
        ASSIGN pcEntityFields = pcEntityFields + (IF NUM-ENTRIES(pcEntityFields, CHR(1)) EQ 0 THEN "":U ELSE CHR(1)) + hCurrentField:NAME
               pcEntityValues = pcEntityValues + (IF NUM-ENTRIES(pcEntityValues, CHR(1)) EQ 0 THEN "":U ELSE CHR(1)) 
                              + (IF hCurrentField:BUFFER-VALUE <> ? THEN hCurrentField:BUFFER-VALUE ELSE "":U)
               .
    END. /* field loop */

    hQuery:QUERY-CLOSE().

    /* Clean up all widgets used in this procedure. */
    DELETE WIDGET-POOL cWidgetPool.

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
    {
     dynlaunch.i &PLIP              = "'GeneralManager'"
                 &iProc             = "'getEntityDisplayField'"
                 &compileStaticCall = NO                 
                 &mode1 = INPUT  &parm1 = pcEntityMnemonic   &dataType1 = CHARACTER
                 &mode2 = INPUT  &parm2 = pcOwningValue      &dataType2 = CHARACTER
                 &mode3 = OUTPUT &parm3 = pcEntityLabel      &dataType3 = CHARACTER
                 &mode4 = OUTPUT &parm4 = pcEntityDescriptor &dataType4 = CHARACTER
    }
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
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
    DEFINE VARIABLE cQuote                          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE lOk                             AS LOGICAL      NO-UNDO.

    /* Make sure the entity is cached */
    RUN cacheEntity IN THIS-PROCEDURE (pcEntityMnemonic, /* Table FLA */
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
                       " = ":U + pcOwningValue.
    ELSE IF NUM-ENTRIES(ttEntityMnemonic.entity_key_field) = NUM-ENTRIES(pcOwningValue,CHR(1)) THEN DO:
      IF VALID-HANDLE(hBuffer) THEN DO iLoop = 1 TO NUM-ENTRIES(ttEntityMnemonic.entity_key_field):
        ASSIGN
          cFieldName = TRIM(ENTRY(iLoop,ttEntityMnemonic.entity_key_field))
          hField     = hBuffer:BUFFER-FIELD(cFieldName).

        IF VALID-HANDLE(hField) THEN DO: 
          IF hField:DATA-TYPE = "CHARACTER":U THEN
            ASSIGN
              cQuote = "'":U.
          ELSE
            ASSIGN
              cQuote = "":U.

          ASSIGN
            cWhereClause = cWhereClause + " AND ":U WHEN cWhereClause <> "":U
            cWhereClause = cWhereClause + TRIM(ttEntityMnemonic.entity_mnemonic_description) + ".":U  + cFieldName +
                           " = ":U + cQuote + ENTRY(iLoop,pcOwningValue,CHR(1)) + cQuote.
        END.
      END.
    END.
    ELSE 
      RETURN.

    /*Build the query string*/
    ASSIGN 
      cQueryPrepareString  = "FOR EACH " + ttEntityMnemonic.entity_mnemonic_description + " WHERE "
                             +  cWhereClause
                             + " NO-LOCK "
      cQueryPrepareString = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, INPUT cQueryPrepareString).

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
    {
     dynlaunch.i &PLIP              = "'GeneralManager'"
                 &iProc             = "'getEntityExists'"
                 &compileStaticCall = NO                 
                 &mode1 = INPUT  &parm1 = pcTableName  &dataType1 = CHARACTER
                 &mode2 = INPUT  &parm2 = pdTableObj   &dataType2 = DECIMAL
                 &mode3 = OUTPUT &parm3 = plExists     &dataType3 = LOGICAL
                 &mode4 = OUTPUT &parm4 = pcRejection  &dataType4 = CHARACTER
    }
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
    /* Make sure the entity is cached */
    RUN cacheEntity IN THIS-PROCEDURE (pcTableName, /* Table FLA, the parameter has been named incorrectly */
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
                                      + TRIM(pcTableName) + ".":U  + cTableObjectFieldName + " = ":U + STRING(pdTableObj)
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
    
    cQueryPrepareString = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, INPUT cQueryPrepareString).
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
    RUN cacheEntity IN THIS-PROCEDURE (pcEntityMnemonic, /* Table FLA */
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
    {
     dynlaunch.i &PLIP              = "'GeneralManager'"
                 &iProc             = "'getLanguageText'"
                 &compileStaticCall = NO
                 &mode1 = INPUT  &parm1 = pcCategoryType  &dataType1 = CHARACTER
                 &mode2 = INPUT  &parm2 = pcCategoryGroup &dataType2 = CHARACTER
                 &mode3 = INPUT  &parm3 = pcSubGroup      &dataType3 = CHARACTER
                 &mode4 = INPUT  &parm4 = pcTextTla       &dataType4 = CHARACTER
                 &mode5 = INPUT  &parm5 = pdLanguageObj   &dataType5 = DECIMAL
                 &mode6 = INPUT  &parm6 = pdOwningObj     &dataType6 = DECIMAL                 
                 &mode7 = INPUT  &parm7 = pcSubstitute    &dataType7 = CHARACTER
                 &mode8 = OUTPUT &parm8 = pcLanguageText  &dataType8 = CHARACTER
                 &mode9 = OUTPUT &parm9 = pcFileName      &dataType9 = CHARACTER
    }
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
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
  {
   dynlaunch.i &PLIP              = "'GeneralManager'"
               &iProc             = "'getRecordCheckAudit'"
               &compileStaticCall = NO
               &mode1 = INPUT  &parm1 = pcEntityMnemonic &dataType1 = CHARACTER
               &mode2 = INPUT  &parm2 = pcEntityObjField &dataType2 = CHARACTER
               &mode3 = INPUT  &parm3 = pcEntityObjValue &dataType3 = CHARACTER
               &mode4 = OUTPUT &parm4 = plRowAuditExist  &dataType4 = LOGICAL
  }
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
  {
   dynlaunch.i &PLIP              = "'GeneralManager'"
               &iProc             = "'getRecordCheckComment'"
               &compileStaticCall = NO                 
               &mode1 = INPUT  &parm1 = pcEntityMnemonic  &dataType1 = CHARACTER
               &mode2 = INPUT  &parm2 = pcEntityObjField  &dataType2 = CHARACTER
               &mode3 = INPUT  &parm3 = pcEntityObjValue  &dataType3 = CHARACTER
               &mode4 = OUTPUT &parm4 = plRowCommentExist &dataType4 = LOGICAL
               &mode5 = OUTPUT &parm5 = pcRowCommentAuto  &dataType5 = CHARACTER
  }
  IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
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
    {
     dynlaunch.i &PLIP              = "'GeneralManager'"
                 &iProc             = "'getRecordDetail'"
                 &compileStaticCall = NO                 
                 &mode1 = INPUT  &parm1 = pcQuery     &dataType1 = CHARACTER
                 &mode2 = OUTPUT &parm2 = pcFieldList &dataType2 = CHARACTER
    }
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE   

    DEFINE VARIABLE hQuery                      AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hBuffer                     AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hField                      AS HANDLE               NO-UNDO.
    DEFINE VARIABLE iLoop                       AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iCnt                        AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cTableName                  AS CHARACTER            NO-UNDO.

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

                       pcFieldList = pcFieldList + CHR(3) WHEN pcFieldList <> "":U
                       pcFieldList = pcFieldList + TRIM(hBuffer:NAME) + ".":U + TRIM(hField:NAME) + CHR(3)
                       pcFieldList = pcFieldList + (IF hField:STRING-VALUE = "?":U THEN "":U ELSE TRIM(hField:STRING-VALUE))
                       .
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
  {
   dynlaunch.i &PLIP              = "'GeneralManager'"
               &iProc             = "'getRecordUserProp'"
               &compileStaticCall = NO
               &mode1 = INPUT  &parm1 = pcEntityMnemonic &dataType1 = CHARACTER
               &mode2 = INPUT  &parm2 = pcEntityFields   &dataType2 = CHARACTER
               &mode3 = INPUT  &parm3 = pcEntityObjValue &dataType3 = CHARACTER
               &mode4 = OUTPUT &parm4 = pcRowUserProp    &dataType4 = CHARACTER
  }
  IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
  &ELSE

    DEFINE VARIABLE lRowAuditExist            AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE lRowCommentExist          AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE cRowCommentAuto           AS CHARACTER NO-UNDO.

    ASSIGN 
      lRowAuditExist   = NO
      lRowCommentExist = NO
      cRowCommentAuto  = "":U.
    
    /**
    Too expensive...  This is called for each record  
    RUN getRecordCheckAudit   (INPUT  pcEntityMnemonic
                              ,INPUT  pcEntityObjField
                              ,INPUT  pcEntityObjValue
                              ,OUTPUT lRowAuditExist
                              ).
    **/

    IF LOOKUP('HasAudit':U,pcEntityFields) > 0 THEN
      FIND FIRST gst_audit WHERE gst_audit.owning_entity_mnemonic = pcEntityMnemonic
                           AND   gst_audit.owning_reference = pcEntityObjValue
                           NO-LOCK NO-ERROR. 
    ELSE RELEASE gst_audit.
    
    /**
    RUN getRecordCheckComment (INPUT  pcEntityMnemonic
                              ,INPUT  pcEntityObjField
                              ,INPUT  pcEntityObjValue
                              ,OUTPUT lRowCommentExist
                              ,OUTPUT cRowCommentAuto
                              ).
    **/

    IF LOOKUP('HasComment':U,pcEntityFields) > 0 
    OR LOOKUP('AutoComment':U,pcEntityFields) > 0  THEN
      FIND FIRST gsm_comment WHERE gsm_comment.owning_entity_mnemonic = pcEntityMnemonic
                             AND gsm_comment.owning_reference = pcEntityObjValue
                             NO-LOCK NO-ERROR. 
    ELSE RELEASE gsm_comment.

    ASSIGN       
      lRowCommentExist = AVAIL gsm_comment
      lRowAuditExist   = AVAIL gst_audit.

    IF lRowCommentExist AND LOOKUP('AutoComment':U,pcEntityFields) > 0 THEN
    FOR EACH gsm_comment NO-LOCK
          WHERE gsm_comment.owning_entity_mnemonic  = pcEntityMnemonic
          AND   gsm_comment.owning_reference        = pcEntityObjValue
          AND   gsm_comment.auto_display            = YES
          AND   (gsm_comment.expiry_date             >= TODAY
                 OR gsm_comment.expiry_date = ?):

      cRowCommentAuto = cRowCommentAuto 
                      + (IF cRowCommentAuto = '':U THEN '':U ELSE CHR(10))  
                      + gsm_comment.comment_description.
    END.
    ASSIGN pcRowUserProp 
            = "gstad":U + CHR(3) + (IF lRowAuditExist THEN "YES":U ELSE "NO":U)
            + CHR(4)
            + "gsmcm":U + CHR(3) + (IF lRowCommentExist THEN "YES":U ELSE "NO":U)
            + (IF cRowCommentAuto = "":U 
               THEN "":U
               ELSE CHR(4) + "gsmcmauto":U + CHR(3) + cRowCommentAuto).
   &ENDIF

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRecordUserPropx Include 
PROCEDURE getRecordUserPropx :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcEntityMnemonic  AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pcEntityObjField  AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pcEntityObjValue  AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pcRowUserProp     AS CHARACTER NO-UNDO.

  &IF DEFINED(server-side) = 0 &THEN
  {
   dynlaunch.i &PLIP              = "'GeneralManager'"
               &iProc             = "'getRecordUserPropx'"
               &compileStaticCall = NO
               &mode1 = INPUT  &parm1 = pcEntityMnemonic &dataType1 = CHARACTER
               &mode2 = INPUT  &parm2 = pcEntityObjField &dataType2 = CHARACTER
               &mode3 = INPUT  &parm3 = pcEntityObjValue &dataType3 = CHARACTER
               &mode4 = OUTPUT &parm4 = pcRowUserProp    &dataType4 = CHARACTER
  }
  IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
  &ELSE

    DEFINE VARIABLE lRowAuditExist            AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE lRowCommentExist          AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE cRowCommentAuto           AS CHARACTER NO-UNDO.

    ASSIGN 
      lRowAuditExist   = NO
      lRowCommentExist = NO
      cRowCommentAuto  = "":U.

    RUN getRecordCheckAudit   (INPUT  pcEntityMnemonic
                              ,INPUT  pcEntityObjField
                              ,INPUT  pcEntityObjValue
                              ,OUTPUT lRowAuditExist
                              ).

    IF pcRowUserProp <> "":U THEN ASSIGN pcRowUserProp = pcRowUserProp + CHR(4).
    ASSIGN pcRowUserProp = pcRowUserProp + "gstad" + CHR(3) + (IF lRowAuditExist THEN "YES":U ELSE "NO":U).

    RUN getRecordCheckComment (INPUT  pcEntityMnemonic
                              ,INPUT  pcEntityObjField
                              ,INPUT  pcEntityObjValue
                              ,OUTPUT lRowCommentExist
                              ,OUTPUT cRowCommentAuto
                              ).

    IF pcRowUserProp <> "":U THEN ASSIGN pcRowUserProp = pcRowUserProp + CHR(4).
    ASSIGN pcRowUserProp = pcRowUserProp + "gsmcm" + CHR(3) + (IF lRowCommentExist THEN "YES":U ELSE "NO":U).

    IF cRowCommentAuto <> "":U
    THEN DO:
      IF pcRowUserProp <> "":U THEN ASSIGN pcRowUserProp = pcRowUserProp + CHR(4).
      ASSIGN pcRowUserProp = pcRowUserProp + "gsmcmauto" + CHR(3) + cRowCommentAuto.
    END.

  &ENDIF

  RETURN.

END PROCEDURE.

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
    {
     dynlaunch.i &PLIP              = "'GeneralManager'"
                 &iProc             = "'getSequenceExist'"
                 &compileStaticCall = NO                 
                 &mode1 = INPUT  &parm1 = pdCompanyObj     &dataType1 = DECIMAL
                 &mode2 = INPUT  &parm2 = pcEntityMnemonic &dataType2 = CHARACTER
                 &mode3 = INPUT  &parm3 = pcSequenceTLA    &dataType3 = CHARACTER
                 &mode4 = OUTPUT &parm4 = plSuccess        &dataType4 = LOGICAL
    }
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
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
{
 dynlaunch.i &PLIP              = "'GeneralManager'"
             &iProc             = "'getSequenceValue'"
             &compileStaticCall = NO             
             &mode1 = INPUT  &parm1 = pdCompanyObj        &dataType1 = DECIMAL
             &mode2 = INPUT  &parm2 = pcEntityMnemonic    &dataType2 = CHARACTER
             &mode3 = INPUT  &parm3 = pcSequenceTLA       &dataType3 = CHARACTER
             &mode4 = OUTPUT &parm4 = pcNextSequenceValue &dataType4 = CHARACTER
}
IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
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

                    RUN getSequenceMask (INPUT gsc_sequence.sequence_format,
                                         OUTPUT cQuantityIndicator,
                                         OUTPUT cSequenceMask) NO-ERROR.

                    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

                    iSite = INDEX(gsc_sequence.sequence_format, "&S":U).
                    IF iSite > 0 THEN
                    DO:
                      RUN getSiteNumber(OUTPUT iSite).
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

            RUN getSequenceMask (INPUT  gsc_sequence.sequence_format,
                                 OUTPUT cQuantityIndicator,
                                 OUTPUT cSequenceMask) NO-ERROR.

            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
            
            iSite = INDEX(gsc_sequence.sequence_format, "&S":U).
            IF iSite > 0 THEN
            DO:
              RUN getSiteNumber(OUTPUT iSite).
              pcNextSequenceValue = REPLACE(gsc_sequence.sequence_format, "&S":U, STRING(iSite)).
            END.
            ELSE
              pcNextSequenceValue = gsc_sequence.sequence_format.

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
  Purpose:     Procedure to determine the current repository database site
               number from the RVDB if connected, otherwise from the ICFDB
               database sequence.
  Parameters:  Output current site number
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER piSite              AS INTEGER  NO-UNDO.

&IF DEFINED(server-side) = 0 &THEN
    {
     dynlaunch.i &PLIP              = "'GeneralManager'"
                 &iProc             = "'getSiteNumber'"
                 &compileStaticCall = NO                 
                 &mode1  = OUTPUT &parm1 = piSite &dataType1 = INTEGER
    }
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
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
  

  /* use external procedure to avoid rvdb from having to be there at all
     when not required 
  */
  IF CONNECTED("RVDB") THEN
    RUN rv/app/rvgetnobjp.p (INPUT  NO,         /* do not increment */
                             OUTPUT iSeqObj1,
                             OUTPUT iSeqObj2,
                             OUTPUT iSeqSiteDiv,
                             OUTPUT iSeqSiteRev,
                             OUTPUT iSessnId).
  ELSE 
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

  DO iLoop = LENGTH(cSiteReverseICF) TO 1 BY -1:
    cCalNumberRevICF  = cCalNumberRevICF + SUBSTRING(cSiteReverseICF,iLoop,1).
  END.

  IF  LENGTH(cSiteDivisionICF) > 1
  AND LENGTH(cSiteDivisionICF) > LENGTH(cCalNumberRevICF) + 1
  THEN
  DO iLoop = LENGTH(cSiteReverseICF) + 1 TO LENGTH(cSiteDivisionICF) - LENGTH(cSiteReverseICF):
    cCalNumberRevICF  = cCalNumberRevICF + "0".
  END.

  ASSIGN
    piSite = INTEGER(cCalNumberRevICF).

&ENDIF

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

        ASSIGN cQueryPrepareString = "FOR EACH ttStatusCache WHERE ttStatusCache.tStatusObj = ":U + STRING(pdStatusObj) + " NO-LOCK":U
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
    
    cQueryPrepareString = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, INPUT cQueryPrepareString).
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
    {
     dynlaunch.i &PLIP              = "'GeneralManager'"
                 &iProc             = "'getTableInfo'"
                 &compileStaticCall = NO
                 &mode1 = INPUT  &parm1 = pcUpdatableTable &dataType1 = CHARACTER
                 &mode2 = OUTPUT &parm2 = pcReturnValue    &dataType2 = CHARACTER
    }
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
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
                ASSIGN cTableDumpName = DYNAMIC-FUNCTION("getTableDumpName":U, INPUT LDBNAME(iCounter) + "|":U + pcUpdatableTable).
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
    {
     dynlaunch.i &PLIP              = "'GeneralManager'"
                 &iProc             = "'getTableInfoObj'"
                 &compileStaticCall = NO
                 &mode1 = INPUT  &parm1 = pcUpdatableTable &dataType1 = CHARACTER
                 &mode2 = OUTPUT &parm2 = pcReturnValue    &dataType2 = CHARACTER
    }
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
                ASSIGN cTableDumpName = DYNAMIC-FUNCTION("getTableDumpName":U, INPUT LDBNAME(iCounter) + "|":U + pcUpdatableTable).
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
    {
     dynlaunch.i &PLIP              = "'GeneralManager'"
                 &iProc             = "'getUserSourceLanguage'"
                 &compileStaticCall = NO
                 &mode1 = INPUT  &parm1 = pdUserObj           &dataType1 = DECIMAL
                 &mode2 = OUTPUT &parm2 = pdSourceLanguageObj &dataType2 = DECIMAL
    }
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
      DEFINE VARIABLE rRowid        AS ROWID      NO-UNDO.
      DEFINE VARIABLE cProfileData  AS CHARACTER  NO-UNDO.
      
      pdSourceLanguageObj = 0.
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
    &ENDIF
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE makeObjectTTHandleStatic Include 
PROCEDURE makeObjectTTHandleStatic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TABLE FOR cache_object.

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
    RUN VALUE(pcSdoName) ON gshAstraAppServer PERSISTENT SET hSDO NO-ERROR.

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
    RUN cacheEntity IN THIS-PROCEDURE (pcEntityMnemonic, /* Table FLA */
                                       "":U).            /* Tablename */
    
    /* Has an Entity Mnemonic record been created yet? */
    IF CAN-FIND(ttEntityMnemonic WHERE ttEntityMnemonic.entity_mnemonic = pcEntityMnemonic) THEN
        ASSIGN pcResult = "OK":U.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

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

    ASSIGN pcFolderName        = REPLACE(pcFolderName, "~\":U, "/":U)
           FILE-INFO:FILE-NAME = pcFolderName
           .
    IF FILE-INFO:FULL-PATHNAME EQ ? THEN
    DO:
        ASSIGN cCompositePath = "":U.

        DO iFolderCount = 1 TO NUM-ENTRIES(pcFolderName, "/":U).
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
  RUN cacheEntity IN THIS-PROCEDURE (pcEntity, 
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
  RUN cacheEntity IN THIS-PROCEDURE (pcEntity,
                                     pcTableName).

  /* If we are passed an entity or table name we 
     want to check if they exist in the cache and if
     not we want to refresh the cache */
  IF pcEntity <> "":U THEN DO:
    IF NOT CAN-FIND(FIRST ttEntityMnemonic) OR
      (pcEntity <> "*":U AND 
       NOT CAN-FIND(FIRST ttEntityMnemonic
                    WHERE ttEntityMnemonic.entity_mnemonic = pcEntity)) THEN
      RUN refreshMnemonicsCache.
    ELSE
  END.
  IF pcTableName <> "":U THEN DO:
    IF NOT CAN-FIND(FIRST ttEntityMnemonic) OR
      (pcTableName <> "*":U AND 
       NOT CAN-FIND(FIRST ttEntityMnemonic
                    WHERE ttEntityMnemonic.entity_mnemonic_description = pcTableName)) THEN
      RUN refreshMnemonicsCache.
  END.
  
  IF pcEntity = "":U AND
     pcTableName = "":U AND
     NOT CAN-FIND(FIRST ttEntityMnemonic) THEN
    RUN refreshMnemonicsCache.
  
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
  RUN cacheEntity IN THIS-PROCEDURE (pcEntityMnemonic, /* Entity Mnemonic */
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

    RUN getSequenceValue ( INPUT  pdCompanyObj,
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
  RUN cacheEntity IN THIS-PROCEDURE (pcEntityMnemonic, /* Entity Mnemonic */
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
  RUN getEntityDescription (INPUT pcEntityMnemonic, 
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
  RUN getEntityDescription (INPUT pcEntityMnemonic, 
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

    RUN getSequenceExist ( INPUT  pdCompanyObj,
                           INPUT  pcEntityMnemonic,
                           INPUT  pcSequenceTLA,
                           OUTPUT lSuccess
                         ).

    RETURN lSuccess.
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
    RUN getStatusRecord ( INPUT  pcCategoryType,
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
    RUN getStatusRecord ( INPUT  "":U,
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
    RUN getStatusRecord ( INPUT  "":U,
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

    RUN getDumpName ( INPUT pcQuery, OUTPUT cTableDumpName ) NO-ERROR.

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
      RUN getTableInfo(INPUT cUpdatableTable, OUTPUT cReturnValue) NO-ERROR.

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
        RUN getTableInfoObj(INPUT cUpdatableTable, OUTPUT cReturnValue) NO-ERROR.

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

