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

---------------------------------------------------------------------------*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD formatPersonDetails Include 
FUNCTION formatPersonDetails RETURNS CHARACTER
  (pcLastName  AS CHARACTER,
   pcFirstName AS CHARACTER,
   pcInitials  AS CHARACTER)  FORWARD.

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
&ENDIF

/* Populate the Entity Mnemonic cache on the server and client side */
RUN refreshMnemonicsCache.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
    { afrun2.i
        &PLIP            = 'af/app/afsuprmanp.p'
        &IProc           = 'setAsSuperProcedure'
        &PList           = "(INPUT 'GEN':U, INPUT 'ADD':U)"
        &AutoKillOnError = YES
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

    { afrun2.i
        &PLIP     = 'af/app/afsuprmanp.p'
        &IProc    = 'checkIfOverlaps'
        &PList    = "( INPUT  pcTable,~
                       INPUT  pcKeyField,~
                       INPUT  pcFromField,~
                       INPUT  pcToField,~
                       INPUT  pdCurrentRecordObj,~
                       INPUT  pdKeyValue,~
                       INPUT  ptFromValue,~
                       INPUT  ptToValue,~
                       INPUT  pcAdditionalWhere,~
                       OUTPUT plOverlap,~
                       OUTPUT ptOverlapFrom,~
                       OUTPUT ptOverlapTo)"
        &autoKill = YES
        &PlipRunError = "RETURN ERROR cErrorMessage."
    }    
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
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
    DELETE OBJECT hQuery.
    DELETE WIDGET-POOL cWidgetPool.
  &ENDIF

  RETURN.
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
{ afrun2.i
    &PLIP            = 'af/app/afsuprmanp.p'
    &IProc           = 'setAsSuperProcedure'
    &PList           = "(INPUT 'GEN':U, INPUT 'ADD':U)"
    &AutoKillOnError = YES
}
IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

{ afrun2.i
    &PLIP        = 'af/app/afsuprmanp.p'
    &IProc       = 'getDBVersion'
    &PList       = "( INPUT pcLogicalNames, OUTPUT pcVersions )"
    &AutoKill    = YES
    &PlipRunError = "RETURN ERROR cErrorMessage."
}
IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
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
          ASSIGN hField          = hFileBuffer:BUFFER-FIELD("_seq-init":U)
                 cVersion       = TRIM(hField:STRING-VALUE)
                 .
      IF cVersion = "":U OR cVersion = ? THEN
        ASSIGN cVersion = "000000":U.

      /* tidy up for next time */
      hQuery:QUERY-CLOSE.
      DELETE OBJECT hQuery NO-ERROR.
      ASSIGN hQuery = ?.
      DELETE OBJECT hField NO-ERROR.
      ASSIGN hField = ?.
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

    &IF DEFINED(server-side) = 0 &THEN
    { afrun2.i
        &PLIP            = 'af/app/afsuprmanp.p'
        &IProc           = 'setAsSuperProcedure'
        &PList           = "(INPUT 'GEN':U, INPUT 'ADD':U)"
        &AutoKillOnError = YES
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

    { afrun2.i
        &PLIP        = 'af/app/afsuprmanp.p'
        &IProc       = 'getDumpName'
        &PList       = "( INPUT pcQuery, OUTPUT pcTableDumpName )"
        &AutoKill    = YES
        &PlipRunError = "RETURN ERROR cErrorMessage."
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
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
        DEFINE VARIABLE cSchemaName         AS CHARACTER                NO-UNDO.

        ASSIGN cWidgetPool  = "_file":U
               cLogicalName = ENTRY(1, pcQuery, "|":U)
               cSchemaName  = SDBNAME(cLogicalName)
               .
        /* If the logical object name and the schema name differ, then we assume that we are working with 
         * a DataServer. If the schema and logical names are the same, we are dealing with a native 
         * Progress DB.                                                                                   */
        IF cSchemaName EQ cLogicalName THEN
            ASSIGN cDbBufferName   = cLogicalName + "._Db":U
                   cFileBufferName = cLogicalName + "._File":U
                   cQuerystring    = "FOR EACH ":U + cDbBufferName + " NO-LOCK, ":U
                                   + " EACH " + cFileBufferName + " WHERE ":U
                                   +   cFileBufferName + "._Db-recid  = RECID(_Db) AND ":U
                                   +   cFileBufferName + "._File-name = '":U + ENTRY(2, pcQuery, "|":U) + "' AND ":U
                                   +   cFileBufferName + "._Owner     = 'PUB':U ":U
                                   + " NO-LOCK ":U.
        ELSE
            ASSIGN cDbBufferName   = cSchemaName + "._Db":U
                   cFileBufferName = cSchemaName + "._File":U
                   cQuerystring    = " FOR EACH ":U + cDbBufferName + " WHERE ":U
                                   +   cDbBufferName + "._Db-Name = '" + cLogicalName + "' ":U
                                   + " NO-LOCK, ":U
                                   + " EACH " + cFileBufferName + " WHERE ":U
                                   +   cFileBufferName + "._Db-recid  = RECID(_Db) AND ":U
                                   +   cFileBufferName + "._File-name = '":U + ENTRY(2, pcQuery, "|":U) + "' AND ":U
                                   +   cFileBufferName + "._Owner     = '_Foreign':U ":U
                                   + " NO-LOCK ":U.

        CREATE BUFFER hDbBuffer    FOR TABLE cDbBufferName.
        CREATE BUFFER hFileBuffer  FOR TABLE cFileBufferName.

        CREATE WIDGET-POOL cWidgetPool.

        CREATE QUERY hQuery IN WIDGET-POOL cWidgetPool.
        
        hQuery:SET-BUFFERS(hDbBuffer,hFileBuffer).
        
        /* remove decimals with commas for Europe */
        ASSIGN cQueryString = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, INPUT cQueryString).
        hQuery:QUERY-PREPARE(cQueryString).
        hQuery:QUERY-OPEN().

        hQuery:GET-FIRST(NO-LOCK).
        IF hFileBuffer:AVAILABLE THEN
            ASSIGN hField          = hFileBuffer:BUFFER-FIELD("_dump-name":U)
                   pcTableDumpName = TRIM(hField:STRING-VALUE)
                   .
        hQuery:QUERY-CLOSE.

        DELETE OBJECT hQuery NO-ERROR.
        ASSIGN hQuery = ?.

        DELETE OBJECT hField NO-ERROR.
        ASSIGN hField = ?.

        DELETE OBJECT hDbBuffer NO-ERROR.
        ASSIGN hDbBuffer = ?.

        DELETE OBJECT hFileBuffer NO-ERROR.
        ASSIGN hFileBuffer = ?.
        
        DELETE WIDGET-POOL cWidgetPool.
    &ENDIF
    
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
    { afrun2.i
        &PLIP            = 'af/app/afsuprmanp.p'
        &IProc           = 'setAsSuperProcedure'
        &PList           = "(INPUT 'GEN':U, INPUT 'ADD':U)"
        &AutoKillOnError = YES
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

    { afrun2.i
        &PLIP        = 'af/app/afsuprmanp.p'
        &IProc       = 'getEntityDescription'
        &PList       = "( INPUT  pcEntityMnemonic,~
                          INPUT  pdEntityObj,~
                          INPUT  pcFieldName,~
                          OUTPUT pcEntityDescriptor)"
        &AutoKill    = YES
        &PlipRunError = "RETURN ERROR cErrorMessage."
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
    DEFINE VARIABLE cQueryPrepareString             AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cTableObjectFieldName           AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cTableBase                      AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hQuery                          AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hBuffer                         AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hDescriptionField               AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hCurrentField                   AS HANDLE       NO-UNDO.
    DEFINE VARIABLE iFieldLoop                      AS INTEGER      NO-UNDO.

    FIND ttEntityMnemonic WHERE
         ttEntityMnemonic.entity_mnemonic = pcEntityMnemonic
         NO-ERROR.
    IF NOT AVAILABLE ttEntityMnemonic THEN
        RETURN ERROR "ADM-ERROR":U.

    ASSIGN cTableBase = IF LENGTH(ttEntityMnemonic.entity_mnemonic_description) > 5 THEN 
                           SUBSTRING(ttEntityMnemonic.entity_mnemonic_description,5)
                        ELSE      ttEntityMnemonic.entity_mnemonic_description
           cTableObjectFieldName = getObjField(pcEntityMnemonic)
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
    /* CREATE BUFFER hBuffer FOR TABLE ttEntityMnemonic.entity_mnemonic_description IN WIDGET-POOL "queryWidgets":U. */
    IF NOT hQuery:ADD-BUFFER(hBuffer) THEN
    DO:
        DELETE OBJECT hQuery.
        DELETE WIDGET-POOL "queryWidgets":U.
        RETURN ERROR "ADM-ERROR":U.
    END.    /* can't add buffer */

    cQueryPrepareString = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, INPUT cQueryPrepareString).
    IF NOT hQuery:QUERY-PREPARE(cQueryPrepareString) THEN
    DO:
        DELETE OBJECT hQuery.
        DELETE WIDGET-POOL "queryWidgets":U.
        RETURN ERROR "ADM-ERROR":U.
    END.    /* can't prepare query */

    /* Determine what the description field is - may be a specific field name. */
    ASSIGN hDescriptionField = hBuffer:BUFFER-FIELD(pcFieldName) NO-ERROR.

    IF NOT VALID-HANDLE(hDescriptionField) THEN
    DO iFieldLoop = 1 TO hBuffer:NUM-FIELDS:
        ASSIGN hCurrentField = hBuffer:BUFFER-FIELD(iFieldLoop).
        /* Look for key items because they will tend to be more uniquely
         * descriptive. The character test helps with readability - object
         * numbers are meaningless for this.
         */
        IF hCurrentField:DATA-TYPE = "character":U AND
           hCurrentField:KEY       = YES           AND
          (pcFieldName             = "Code":U      OR
           pcFieldName             = "":U)         THEN
        DO:
            /* First get exact field names that imply a code */
            CASE hCurrentField:NAME:
                WHEN cTableBase + "_code":U        OR
                WHEN cTableBase + "_reference":U   OR
                WHEN cTableBase + "_type":U        OR
                WHEN cTableBase + "_tla":U         OR
                WHEN cTableBase + "_number":U      OR
                WHEN cTableBase + "_short_desc":U  THEN ASSIGN hDescriptionField = hCurrentField.
                /* Fuzzy Match */
                OTHERWISE
                    IF hCurrentField:NAME MATCHES "*_code":U        OR
                       hCurrentField:NAME MATCHES "*_reference":U   OR
                       hCurrentField:NAME MATCHES "*_type":U        OR
                       hCurrentField:NAME MATCHES "*_tla":U         OR
                       hCurrentField:NAME MATCHES "*_number":U      OR
                       hCurrentField:NAME MATCHES "*_short_desc":U  THEN
                        ASSIGN hDescriptionField = hCurrentField.
            END CASE.   /* hCurrentField:NAME */
        END.    /* character field in a key */
        IF VALID-HANDLE(hDescriptionField) THEN
            LEAVE.

        IF hCurrentField:DATA-TYPE = "character":U   AND
           pcFieldName             = "Description":U THEN
        DO:
            /* Get exact field names that imply a description */
            CASE hCurrentField:NAME:
                WHEN cTableBase + "_name":U        OR
                WHEN cTableBase + "_description":U OR
                WHEN cTableBase + "_short_name":U  OR
                WHEN cTableBase + "_desc":U        THEN ASSIGN hDescriptionField = hCurrentField.
                OTHERWISE
                    IF hCurrentField:NAME MATCHES "*_name":U       OR
                       hCurrentField:NAME MATCHES "*_desc*":U      OR
                       hCurrentField:NAME MATCHES "*_short_name":U THEN
                        ASSIGN hDescriptionField = hCurrentField.
            END CASE.   /* hCurrentField:NAME */
        END.    /* character field in a key */
        IF VALID-HANDLE(hDescriptionField) THEN
            LEAVE.
    END.    /* field loop */

    IF NOT VALID-HANDLE(hDescriptionField) THEN
    DO:
        DELETE OBJECT hQuery.
        DELETE WIDGET-POOL "queryWidgets":U.
        RETURN.
    END. /* no descriptor */

    IF NOT hQuery:QUERY-OPEN THEN
    DO:
        DELETE OBJECT hQuery.
        DELETE WIDGET-POOL "queryWidgets":U.
        RETURN.
    END.    /* query can't open */

    hQuery:GET-FIRST(NO-LOCK).
    IF hBuffer:AVAILABLE THEN
        ASSIGN pcEntityDescriptor = hDescriptionField:BUFFER-VALUE() NO-ERROR.

    /* Clean up all widgets used in this procedure. */
    DELETE OBJECT hQuery.
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
               pcEntityValues = pcEntityValues + (IF NUM-ENTRIES(pcEntityValues, CHR(1)) EQ 0 THEN "":U ELSE CHR(1)) + hCurrentField:STRING-VALUE
               .
    END. /* field loop */

    hQuery:QUERY-CLOSE().

    /* Clean up all widgets used in this procedure. */
    DELETE OBJECT hQuery NO-ERROR.
    ASSIGN hQuery = ?.

    DELETE OBJECT hCurrentField NO-ERROR.
    ASSIGN hCurrentField = ?.

    DELETE OBJECT hBuffer NO-ERROR.
    ASSIGN hBuffer = ?.

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
    { afrun2.i
        &PLIP            = 'af/app/afsuprmanp.p'
        &IProc           = 'setAsSuperProcedure'
        &PList           = "(INPUT 'GEN':U, INPUT 'ADD':U)"
        &AutoKillOnError = YES
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

    { afrun2.i
        &PLIP        = 'af/app/afsuprmanp.p'
        &IProc       = 'getEntityDisplayField'
        &PList       = "( INPUT  pcEntityMnemonic,~
                          INPUT  pcOwningValue,~
                          OUTPUT pcEntityLabel,~
                          OUTPUT pcEntityDescriptor)"
        &AutoKill    = YES
        &PlipRunError = "RETURN ERROR cErrorMessage."
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
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
        DELETE OBJECT hQuery.
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

    IF NOT hQuery:QUERY-PREPARE(cQueryPrepareString) THEN
    DO:
        DELETE OBJECT hQuery.
        DELETE WIDGET-POOL "queryWidgets":U.
        RETURN ERROR "ADM-ERROR":U.
    END.    /* can't prepare query */

    /* Determine what the description field is - may be a specific field name. */
    ASSIGN hDescriptionField = hBuffer:BUFFER-FIELD(ttEntityMnemonic.entity_description_field) NO-ERROR.

    IF NOT VALID-HANDLE(hDescriptionField) THEN
    DO:
        DELETE OBJECT hQuery.
        DELETE WIDGET-POOL "queryWidgets":U.
        RETURN.
    END. /* no descriptor */

    IF NOT hQuery:QUERY-OPEN THEN
    DO:
        DELETE OBJECT hQuery.
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
    DELETE OBJECT hQuery.
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
    { afrun2.i
        &PLIP            = 'af/app/afsuprmanp.p'
        &IProc           = 'setAsSuperProcedure'
        &PList           = "(INPUT 'GEN':U, INPUT 'ADD':U)"
        &AutoKillOnError = YES
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    
    { afrun2.i
        &PLIP        = 'af/app/afsuprmanp.p'
        &IProc       = 'getEntityExists'
        &PList       = "( INPUT  pcTableName,~
                          INPUT  pdTableObj,~
                          OUTPUT plExists,~
                          OUTPUT pcRejection)"
        &AutoKill    = YES
        &PlipRunError = "RETURN ERROR cErrorMessage."
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE

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
        DELETE OBJECT hQuery.
        DELETE WIDGET-POOL "query_widgets":U.
        RETURN.
    END.    /* can't add buffer */
    
    cQueryPrepareString = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, INPUT cQueryPrepareString).
    IF NOT hQuery:QUERY-PREPARE(cQueryPrepareString) THEN
    DO:
        ASSIGN pcRejection = "Error preparing dynamic query".
        DELETE OBJECT hQuery.
        DELETE WIDGET-POOL "query_widgets":U.
        RETURN.
    END.    /* can't prepare query */
    
    IF NOT hQuery:QUERY-OPEN THEN
    DO:
        ASSIGN pcRejection = "Error opening dynamic query".
        DELETE OBJECT hQuery.
        DELETE WIDGET-POOL "query_widgets":U.
        RETURN.
    END.    /* query can't open */
    
    hQuery:GET-FIRST(NO-LOCK).
    ASSIGN plExists = hBuffer:AVAILABLE.
    
    /* Clean up all widgets used in this procedure. */
    DELETE OBJECT hQuery.
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
    Notes:  This function will only be run on the AppServer, or a DB-aware client
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcEntityMnemonic     AS CHARACTER                NO-UNDO.    
    DEFINE INPUT PARAMETER pcLogicalDBName      AS CHARACTER                NO-UNDO.
    DEFINE OUTPUT PARAMETER pcEntityTablename   AS CHARACTER                NO-UNDO.

    &IF DEFINED(server-side) = 0 &THEN
        { afrun2.i
            &PLIP            = 'af/app/afsuprmanp.p'
            &IProc           = 'setAsSuperProcedure'
            &PList           = "(INPUT 'GEN':U, INPUT 'ADD':U)"
            &AutoKillOnError = YES
        }
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    
        { afrun2.i
            &PLIP        = 'af/app/afsuprmanp.p'
            &IProc       = 'getEntityTableName'
            &PList       = "( INPUT  pcEntityMnemonic,~
                              INPUT  pcLogicalDBName,~
                              OUTPUT pcEntityTablename)"
            &AutoKill    = YES
            &PlipRunError = "RETURN ERROR cErrorMessage."
        }
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
        DEFINE VARIABLE cQuery                      AS CHARACTER                NO-UNDO.
        DEFINE VARIABLE cWidgetPool                 AS CHARACTER                NO-UNDO.
        DEFINE VARIABLE cSchemaName                 AS CHARACTER                NO-UNDO.
        DEFINE VARIABLE hDbBuffer                   AS HANDLE                   NO-UNDO.
        DEFINE VARIABLE hFileBuffer                 AS HANDLE                   NO-UNDO.
        DEFINE VARIABLE cQuerystring                AS CHARACTER                NO-UNDO.
        DEFINE VARIABLE cDbBufferName               AS CHARACTER                NO-UNDO.
        DEFINE VARIABLE cFileBufferName             AS CHARACTER                NO-UNDO.
        DEFINE VARIABLE hQuery                      AS HANDLE                   NO-UNDO.
        DEFINE VARIABLE hFieldTableName             AS HANDLE                   NO-UNDO.
        DEFINE VARIABLE hFieldDumpName              AS HANDLE                   NO-UNDO.
    
        ASSIGN cWidgetPool = "DumpName":U
               cSchemaName = SDBNAME(pcLogicalDBName)
               .
        /* If the logical object name and the schema name differ, then we assume that we are working with 
         * a DataServer. If the schema and logical names are the same, we are dealing with a native 
         * Progress DB.                                                                                   */
        IF cSchemaName EQ pcLogicalDBName THEN
            ASSIGN cDbBufferName   = pcLogicalDBName + "._Db":U
                   cFileBufferName = pcLogicalDBName + "._File":U
                   cQuery          = "FOR EACH ":U + cDbBufferName + " NO-LOCK, ":U
                                   + " EACH " + cFileBufferName + " WHERE ":U
                                   +   cFileBufferName + "._Db-recid  = RECID(_Db) AND ":U
                                   +   cFileBufferName + "._Dump-name = '":U + pcEntityMnemonic + "' AND ":U
                                   +   cFileBufferName + "._Owner     = 'PUB':U ":U
                                   + " NO-LOCK ":U.
        ELSE
            ASSIGN cDbBufferName   = cSchemaName + "._Db":U
                   cFileBufferName = cSchemaName + "._File":U
                   cQuery          = " FOR EACH ":U + cDbBufferName + " WHERE ":U
                                   +   cDbBufferName + "._Db-Name = '" + pcLogicalDBName + "' ":U
                                   + " NO-LOCK, ":U
                                   + " EACH " + cFileBufferName + " WHERE ":U
                                   +   cFileBufferName + "._Db-recid  = RECID(_Db) AND ":U
                                   +   cFileBufferName + "._Dump-name = '":U + pcEntityMnemonic + "' AND ":U
                                   +   cFileBufferName + "._Owner     = '_Foreign':U ":U
                                   + " NO-LOCK ":U.

        CREATE WIDGET-POOL cWidgetPool.
        CREATE BUFFER hDbBuffer    FOR TABLE cDbBufferName      IN WIDGET-POOL cWidgetPool.
        CREATE BUFFER hFileBuffer  FOR TABLE cFileBufferName    IN WIDGET-POOL cWidgetPool.
        
        CREATE QUERY hQuery IN WIDGET-POOL cWidgetPool.
    
        hQuery:SET-BUFFERS(hDbBuffer,hFileBuffer).
        
        cQuery = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, INPUT cQuery).
        hQuery:QUERY-PREPARE(cQuery).
        
        ASSIGN hFieldTableName = hFileBuffer:BUFFER-FIELD("_File-name":U).

        hQuery:QUERY-OPEN.
        hQuery:GET-FIRST(NO-LOCK).
        DO WHILE hFileBuffer:AVAILABLE:
            ASSIGN pcEntityTableName = hFieldTableName:BUFFER-VALUE.
            hQuery:GET-NEXT(NO-LOCK).
        END.    /* loop through the query. */
    
        hQuery:QUERY-CLOSE.

        DELETE OBJECT hQuery NO-ERROR.
        ASSIGN hQuery = ?.

        DELETE OBJECT hDbBuffer NO-ERROR.
        ASSIGN hDbBuffer = ?.

        DELETE OBJECT hFileBuffer NO-ERROR.
        ASSIGN hFileBuffer = ?.

        DELETE OBJECT hFieldTableName NO-ERROR.
        ASSIGN hFieldTableName = ?.

        DELETE WIDGET-POOL cWidgetPool.
    &ENDIF
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
    { afrun2.i
        &PLIP            = 'af/app/afsuprmanp.p'
        &IProc           = 'setAsSuperProcedure'
        &PList           = "(INPUT 'GEN':U, INPUT 'ADD':U)"
        &AutoKillOnError = YES
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

    { afrun2.i
        &PLIP        = 'af/app/afsuprmanp.p'
        &IProc       = 'getLanguageText'
        &PList       = "( INPUT  pcCategoryType,~
                          INPUT  pcCategoryGroup,~
                          INPUT  pcSubGroup,~
                          INPUT  pcTextTla,~
                          INPUT  pdLanguageObj,~
                          INPUT  pdOwningObj,~
                          INPUT  pcSubstitute,~
                          OUTPUT pcLanguageText,~
                          OUTPUT pcFileName)"
        &AutoKill    = YES
        &PlipRunError = "RETURN ERROR cErrorMessage."
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
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

  &IF DEFINED(server-side) = 0
  &THEN

    { afrun2.i
        &PLIP            = 'af/app/afsuprmanp.p'
        &IProc           = 'setAsSuperProcedure'
        &PList           = "(INPUT 'GEN':U, INPUT 'ADD':U)"
        &AutoKillOnError = YES
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

    { afrun2.i
        &PLIP        = 'af/app/afsuprmanp.p'
        &IProc       = 'getRecordCheckAudit'
        &PList       = "(INPUT  pcEntityMnemonic,~
                         INPUT  pcEntityObjField,~
                         INPUT  pcEntityObjValue,~
                         OUTPUT plRowAuditExist)"
        &AutoKill    = YES
        &PlipRunError = "RETURN ERROR cErrorMessage."
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

  &ELSE

    IF CAN-FIND(FIRST gst_audit
                WHERE gst_audit.owning_entity_mnemonic  = pcEntityMnemonic
                AND   gst_audit.owning_reference        = pcEntityObjValue
               )
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

  &IF DEFINED(server-side) = 0
  &THEN

    { afrun2.i
        &PLIP            = 'af/app/afsuprmanp.p'
        &IProc           = 'setAsSuperProcedure'
        &PList           = "(INPUT 'GEN':U, INPUT 'ADD':U)"
        &AutoKillOnError = YES
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

    { afrun2.i
        &PLIP         = 'af/app/afsuprmanp.p'
        &IProc        = 'getRecordCheckComment'
        &PList        = "(INPUT  pcEntityMnemonic,~
                          INPUT  pcEntityObjField,~
                          INPUT  pcEntityObjValue,~
                          OUTPUT plRowCommentExist,~
                          OUTPUT pcRowCommentAuto)"
        &AutoKill     = YES
        &PlipRunError = "RETURN ERROR cErrorMessage."
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

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
    { afrun2.i
        &PLIP            = 'af/app/afsuprmanp.p'
        &IProc           = 'setAsSuperProcedure'
        &PList           = "(INPUT 'GEN':U, INPUT 'ADD':U)"
        &AutoKillOnError = YES
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    
    { afrun2.i
        &PLIP        = 'af/app/afsuprmanp.p'
        &IProc       = 'getRecordDetail'
        &PList       = "(INPUT pcQuery,~
                         OUTPUT pcFieldList)"
        &AutoKill    = YES
        &PlipRunError = "RETURN ERROR cErrorMessage."
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
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
  DEFINE INPUT  PARAMETER pcEntityObjField  AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pcEntityObjValue  AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pcRowUserProp     AS CHARACTER NO-UNDO.

  &IF DEFINED(server-side) = 0
  &THEN

    { afrun2.i
        &PLIP            = 'af/app/afsuprmanp.p'
        &IProc           = 'setAsSuperProcedure'
        &PList           = "(INPUT 'GEN':U, INPUT 'ADD':U)"
        &AutoKillOnError = YES
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

    { afrun2.i
        &PLIP        = 'af/app/afsuprmanp.p'
        &IProc       = 'getRecordUserProp'
        &PList       = "(INPUT  pcEntityMnemonic,~
                         INPUT  pcEntityObjField,~
                         INPUT  pcEntityObjValue,~
                         OUTPUT pcRowUserProp)"
        &AutoKill    = YES
        &PlipRunError = "RETURN ERROR cErrorMessage."
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

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
    { afrun2.i
        &PLIP            = 'af/app/afsuprmanp.p'
        &IProc           = 'setAsSuperProcedure'
        &PList           = "(INPUT 'GEN':U, INPUT 'ADD':U)"
        &AutoKillOnError = YES
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

    { afrun2.i
        &PLIP        = 'af/app/afsuprmanp.p'
        &IProc       = 'getSequenceExist'
        &PList       = "( INPUT  pdCompanyObj,~
                          INPUT  pcEntityMnemonic,~
                          INPUT  pcSequenceTLA,~
                          OUTPUT plSuccess)"
        &AutoKill    = YES
        &PlipRunError = "RETURN ERROR cErrorMessage."
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
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
                               + hSequenceBuffer:NAME + ".company_organisation_obj        = ":U + STRING(pdCompanyObj) + "  AND ":U
                               + hSequenceBuffer:NAME + ".owning_entity_mnemonic          = '":U + pcEntityMnemonic    + "' AND ":U
                               + hSequenceBuffer:NAME + ".sequence_tla    = '":U + pcSequenceTLA       + "' AND ":U
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
                                     + hSequenceBuffer:NAME + ".owning_entity_mnemonic          = '":U + pcEntityMnemonic    + "' AND ":U
                                     + hSequenceBuffer:NAME + ".sequence_tla    = '":U + pcSequenceTLA       + "' AND ":U
                                     + hSequenceBuffer:NAME + ".sequence_active = YES ":U
                                     + " NO-LOCK ":U).
        hSequenceQuery:QUERY-OPEN().
        hSequenceQuery:GET-FIRST(NO-LOCK).
    END.    /* no header for this company. */

    ASSIGN plSuccess = hSequenceBuffer:AVAILABLE.

    /* Clean up. */
    /* queries */
    DELETE OBJECT hSequenceQuery NO-ERROR.
    ASSIGN hSequenceQuery = ?.

    /* buffers  */
    DELETE OBJECT hSequenceBuffer NO-ERROR.
    ASSIGN hSequenceBuffer = ?.

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
            * The gsc_sequence table is for use on tables in the ICFDB database.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pdCompanyObj            AS DECIMAL              NO-UNDO.
    DEFINE INPUT  PARAMETER pcEntityMnemonic        AS CHARACTER            NO-UNDO.
    DEFINE INPUT  PARAMETER pcSequenceTLA           AS CHARACTER            NO-UNDO.
    DEFINE OUTPUT PARAMETER pcNextSequenceValue     AS CHARACTER            NO-UNDO.
    
    &IF DEFINED(server-side) = 0  &THEN
    { afrun2.i
        &PLIP            = 'af/app/afsuprmanp.p'
        &IProc           = 'setAsSuperProcedure'
        &PList           = "(INPUT 'GEN':U, INPUT 'ADD':U)"
        &AutoKillOnError = YES
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

    { afrun2.i
        &PLIP        = 'af/app/afsuprmanp.p'
        &IProc       = 'getSequenceValue'
        &PList       = "( INPUT  pdCompanyObj,~
                          INPUT  pcEntityMnemonic,~
                          INPUT  pcSequenceTLA,~
                          OUTPUT pcNextSequenceValue)"
        &AutoKill    = YES
        &PlipRunError = "RETURN ERROR cErrorMessage."
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
    DEFINE VARIABLE cSequenceMask                   AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cQuantityIndicator              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE hSequenceBuffer                 AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hNextSequenceBuffer             AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hNewNextSequenceBuffer          AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hSequenceQuery                  AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hNextSequenceQuery              AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hMultiTransaction               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hSequenceObj                    AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hSequenceFormat                 AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hNumberOfSequences              AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hSequenceNextValue              AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hSequenceAutoGenerate           AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hSequenceMaxValue               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hSequenceMinValue               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hNextSequenceNextValue          AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hNewSequenceNextValue           AS HANDLE               NO-UNDO.                    
    DEFINE VARIABLE hNextSequenceSequenceObj        AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hNewSequenceSequenceObj         AS HANDLE               NO-UNDO.

    CREATE WIDGET-POOL "getSequenceValue":U.
    CREATE BUFFER hSequenceBuffer   FOR TABLE "gsc_sequence":U     IN WIDGET-POOL "getSequenceValue":U.    
    CREATE QUERY hSequenceQuery                                    IN WIDGET-POOL "getSequenceValue":U.

    ASSIGN hMultiTransaction     = hSequenceBuffer:BUFFER-FIELD("multi_transaction":U)
           hSequenceObj          = hSequenceBuffer:BUFFER-FIELD("sequence_obj":U)
           hSequenceFormat       = hSequenceBuffer:BUFFER-FIELD("sequence_format":U)
           hNumberOfSequences    = hSequenceBuffer:BUFFER-FIELD("number_of_sequences":U)
           hSequenceNextValue    = hSequenceBuffer:BUFFER-FIELD("next_value":U)
           hSequenceAutoGenerate = hSequenceBuffer:BUFFER-FIELD("auto_generate":U)
           hSequenceMaxValue     = hSequenceBuffer:BUFFER-FIELD("max_value":U)
           hSequenceMinValue     = hSequenceBuffer:BUFFER-FIELD("min_value":U)
           .
    hSequenceQuery:ADD-BUFFER(hSequenceBuffer).
    hSequenceQuery:QUERY-PREPARE("FOR EACH ":U + hSequenceBuffer:NAME + " WHERE ":U
                               + hSequenceBuffer:NAME + ".company_organisation_obj        = ":U + STRING(pdCompanyObj) + "  AND ":U
                               + hSequenceBuffer:NAME + ".owning_entity_mnemonic          = '":U + pcEntityMnemonic    + "' AND ":U
                               + hSequenceBuffer:NAME + ".sequence_tla    = '":U + pcSequenceTLA       + "' AND ":U
                               + hSequenceBuffer:NAME + ".sequence_active = YES ":U
                               + " NO-LOCK ":U).
    hSequenceQuery:QUERY-OPEN().
    hSequenceQuery:GET-FIRST(NO-LOCK).

    IF NOT hSequenceBuffer:AVAILABLE AND
       pdCompanyObj          <> 0 THEN
    DO:
        hSequenceQuery:QUERY-CLOSE().
        hSequenceQuery:QUERY-PREPARE("FOR EACH ":U + hSequenceBuffer:NAME + " WHERE ":U
                                     + hSequenceBuffer:NAME + ".company_organisation_obj        = 0                               AND ":U
                                     + hSequenceBuffer:NAME + ".owning_entity_mnemonic          = '":U + pcEntityMnemonic    + "' AND ":U
                                     + hSequenceBuffer:NAME + ".sequence_tla    = '":U + pcSequenceTLA       + "' AND ":U
                                     + hSequenceBuffer:NAME + ".sequence_active = YES ":U
                                     + " NO-LOCK ":U).
        hSequenceQuery:QUERY-OPEN().
        hSequenceQuery:GET-FIRST(NO-LOCK).
    END.    /* no header for this company. */

    IF hSequenceBuffer:AVAILABLE THEN
    /* We need an explicit transaction here because we are working with dynamic buffers
     * and buffer scoping. */
    DO TRANSACTION:
        /** There are multiple sequences set up (done to avoid locking issues). **/
        IF hMultiTransaction:BUFFER-VALUE = YES THEN
        DO:
            /* Create the buffers. The first buffer "hNextSequenceBuffer"
             * if used to find the first available next sequence record.
             * This record is deleted after use. This is so that we can be assured
             * that a locked record _is_ currently in use.
             * 
             * The "hNewNextSequenceBuffer" buffer is used to create the next iteration
             * of the next sequence, and has an offset value (offset by the value specified on the 
             * sequence master record). This ensures that if someone else is looking for a
             * sequence value, we are not attempting to create a record which is 
             * immediately requested.
             *
             * This implies that the higher the activity levels on the sequence's owning
             * table, the higher the number of sequences should be stored.             
             */
            CREATE BUFFER hNextSequenceBuffer   FOR TABLE "gsc_next_sequence":U IN WIDGET-POOL "getSequenceValue":U.

            CREATE BUFFER hNewNextSequenceBuffer
                FOR TABLE "gsc_next_sequence":U
                BUFFER-NAME "lb_next_sequence":U
                IN WIDGET-POOL "getSequenceValue":U.

            CREATE QUERY hNextSequenceQuery IN WIDGET-POOL "getSequenceValue":U.

            ASSIGN hNextSequenceNextValue   = hNextSequenceBuffer:BUFFER-FIELD("next_sequence_value":U)
                   hNewSequenceNextValue    = hNewNextSequenceBuffer:BUFFER-FIELD("next_sequence_value":U)
                   hNextSequenceSequenceObj = hNextSequenceBuffer:BUFFER-FIELD("sequence_obj":U)
                   hNewSequenceSequenceObj  = hNewNextSequenceBuffer:BUFFER-FIELD("sequence_obj":U)
                   .
            hNextSequenceQuery:ADD-BUFFER(hNextSequenceBuffer).
            hNextSequenceQuery:QUERY-PREPARE("FOR EACH ":U + hNextSequenceBuffer:NAME + " WHERE ":U
                                             + hNextSequenceBuffer:NAME + ".sequence_obj = " + hSequenceObj:STRING-VALUE
                                             + " AND " + hNextSequenceBuffer:NAME + ".next_sequence_value >= " + hSequenceNextValue:STRING-VALUE + " NO-LOCK ":U).
            hNextSequenceQuery:QUERY-OPEN().
            hNextSequenceQuery:GET-FIRST(EXCLUSIVE-LOCK, NO-WAIT).
            IF NOT hNextSequenceBuffer:AVAILABLE THEN DO:
              hNextSequenceQuery:QUERY-PREPARE("FOR EACH ":U + hNextSequenceBuffer:NAME + " WHERE ":U
                                               + hNextSequenceBuffer:NAME + ".sequence_obj = " + hSequenceObj:STRING-VALUE
                                               + " NO-LOCK ":U).
              hNextSequenceQuery:QUERY-OPEN().
              hNextSequenceQuery:GET-FIRST(EXCLUSIVE-LOCK, NO-WAIT).
            END.

            /* There should always be the next sequence values set up.
             * The sequence master maintenance suite should take 
             * care of the initial creation of next-sequence values. */
            IF NOT hNextSequenceBuffer:AVAILABLE THEN
                RETURN ERROR {aferrortxt.i 'AF' '11' hNextSequenceBuffer:NAME '?' '"first sequence record"' '"the current sequence"' }.

            IF hNextSequenceBuffer:LOCKED THEN
            LOCK-LOOP:
            REPEAT WHILE NOT hNextSequenceQuery:QUERY-OFF-END:
                hNextSequenceQuery:GET-NEXT(EXCLUSIVE-LOCK, NO-WAIT).
                IF hNextSequenceBuffer:AVAILABLE THEN
                    LEAVE LOCK-LOOP.
            END.    /* next record locked. */

            RUN getSequenceMask ( INPUT  hSequenceFormat:BUFFER-VALUE,
                                  OUTPUT cQuantityIndicator,
                                  OUTPUT cSequenceMask ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
            
            /* Assign the sequence and delete it, so the next sequence is available as soon as possible */
            ASSIGN pcNextSequenceValue = SUBSTITUTE( hSequenceFormat:BUFFER-VALUE,
                                                     SUBSTRING(STRING(YEAR(TODAY)), 4, 1),
                                                     SUBSTRING(STRING(YEAR(TODAY)), 3, 2),
                                                     ENTRY(MONTH(TODAY), "JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC"),
                                                     STRING(YEAR(TODAY)),
                                                     STRING(MONTH(TODAY)),
                                                     STRING(DAY(TODAY)),
                                                     STRING(WEEKDAY(TODAY)),
                                                     STRING(hNextSequenceNextValue:BUFFER-VALUE, ">>>>>>>9":U),
                                                     STRING(hNextSequenceNextValue:BUFFER-VALUE, cSequenceMask)    )
                   NO-ERROR.
            hSequenceQuery:GET-CURRENT(EXCLUSIVE-LOCK, NO-WAIT).
            IF hSequenceBuffer:LOCKED THEN
                RETURN ERROR {aferrortxt.i 'AF' '104' "hSequenceBuffer:NAME" '?' "'modify the ' + hSequenceBuffer:NAME" }.
            ELSE 
              ASSIGN hSequenceNextValue:BUFFER-VALUE = hNextSequenceNextValue:BUFFER-VALUE NO-ERROR.

            IF cQuantityIndicator <> "":U THEN
                ASSIGN pcNextSequenceValue = REPLACE(pcNextSequenceValue, cQuantityIndicator, "":U).

            /* Create the new sequence, the db trigger will check for exceeding of min and max values. *
             * We can't start numbering from min when max is reached, as for the gsc_sequence, as this *
             * will cause min value to be created every time this code is run                          */
            hNewNextSequenceBuffer:BUFFER-CREATE() NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

            ASSIGN hNewSequenceSequenceObj:BUFFER-VALUE = hSequenceObj:BUFFER-VALUE.
            /* Check that the next sequence value is not more than the Maximum number allowed
               If this is the case set it back to the minimum value */
            IF (hNextSequenceNextValue:BUFFER-VALUE + hNumberOfSequences:BUFFER-VALUE) > hSequenceMaxValue:BUFFER-VALUE THEN
              ASSIGN hNewSequenceNextValue:BUFFER-VALUE = hSequenceNextValue:BUFFER-VALUE + hSequenceMinValue:BUFFER-VALUE + hNumberOfSequences:BUFFER-VALUE - hSequenceMaxValue:BUFFER-VALUE - 1.
            ELSE
              ASSIGN hNewSequenceNextValue:BUFFER-VALUE = hNextSequenceNextValue:BUFFER-VALUE + hNumberOfSequences:BUFFER-VALUE
                     NO-ERROR.
            hNewNextSequenceBuffer:BUFFER-RELEASE() NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

            hNextSequenceBuffer:BUFFER-DELETE() NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.            
        END. /* If hMultiTransaction:BUFFER-VALUE = YES */
        ELSE
        DO:
            hSequenceQuery:GET-CURRENT(EXCLUSIVE-LOCK, NO-WAIT).
            IF hSequenceBuffer:LOCKED THEN
                RETURN ERROR {aferrortxt.i 'AF' '104' "hSequenceBuffer:NAME" '?' "'modify the ' + hSequenceBuffer:NAME" }.

            RUN getSequenceMask ( INPUT  hSequenceFormat:BUFFER-VALUE,
                                  OUTPUT cQuantityIndicator,
                                  OUTPUT cSequenceMask ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.            

            ASSIGN pcNextSequenceValue = SUBSTITUTE(hSequenceFormat:BUFFER-VALUE,
                                                    SUBSTRING(STRING(YEAR(TODAY)),4,1),
                                                    SUBSTRING(STRING(YEAR(TODAY)),3,2),
                                                    ENTRY(MONTH(TODAY),"JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC":U),
                                                    STRING(YEAR(TODAY)),
                                                    STRING(MONTH(TODAY)),
                                                    STRING(DAY(TODAY)),
                                                    STRING(WEEKDAY(TODAY)),
                                                    STRING(hSequenceNextValue:BUFFER-VALUE, ">>>>>>>9":U),
                                                    STRING(hSequenceNextValue:BUFFER-VALUE, cSequenceMask)  )                
                NO-ERROR.

            IF cQuantityIndicator <> "":U THEN
                ASSIGN pcNextSequenceValue = REPLACE(pcNextSequenceValue, cQuantityIndicator, "":U).

            IF hSequenceAutoGenerate:BUFFER-VALUE = YES THEN
            DO:
                /* Start at the beginning again. */
                IF hSequenceNextValue:BUFFER-VALUE >= hSequenceMaxValue:BUFFER-VALUE THEN
                    ASSIGN hSequenceNextValue:BUFFER-VALUE = hSequenceMinValue:BUFFER-VALUE NO-ERROR.
                ELSE
                    ASSIGN hSequenceNextValue:BUFFER-VALUE = hSequenceNextValue:BUFFER-VALUE + 1 NO-ERROR.

                IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
            END.    /* auto generate */
        END.    /* no multi-sequence */
    END.    /* available sequence */

    /* Clean up. */
    /* queries */
    DELETE OBJECT hSequenceQuery NO-ERROR.
    ASSIGN hSequenceQuery = ?.

    DELETE OBJECT hNextSequenceQuery NO-ERROR.
    ASSIGN hNextSequenceQuery = ?.

    /* buffers  */
    DELETE OBJECT hSequenceBuffer NO-ERROR.
    ASSIGN hSequenceBuffer = ?.

    DELETE OBJECT hNextSequenceBuffer NO-ERROR.
    ASSIGN hNextSequenceBuffer = ?.

    DELETE OBJECT hNewNextSequenceBuffer NO-ERROR.
    ASSIGN hNewNextSequenceBuffer = ?.

    DELETE WIDGET-POOL "getSequenceValue":U.    
    &ENDIF
       
    RETURN.
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
{ afrun2.i
    &PLIP            = 'af/app/afsuprmanp.p'
    &IProc           = 'setAsSuperProcedure'
    &PList           = "(INPUT 'GEN':U, INPUT 'ADD':U)"
    &AutoKillOnError = YES
}
IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

{ afrun2.i
    &PLIP        = 'af/app/afsuprmanp.p'
    &IProc       = 'getSiteNumber'
    &PList       = "( OUTPUT piSite )"
    &AutoKill    = YES
    &PlipRunError = "RETURN ERROR cErrorMessage."
}
IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
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
    DELETE OBJECT hquery.
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
               Entry 3 - Obj Field of Table
                              
  Parameters:  phDataSource
               pcReturnValue
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcUpdatableTable    AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcReturnValue       AS CHARACTER        NO-UNDO. 

    &IF DEFINED(server-side) = 0 &THEN
    { afrun2.i
        &PLIP            = 'af/app/afsuprmanp.p'
        &IProc           = 'setAsSuperProcedure'
        &PList           = "(INPUT 'GEN':U, INPUT 'ADD':U)"
        &AutoKillOnError = YES
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

    { afrun2.i
        &PLIP     = 'af/app/afsuprmanp.p'
        &IProc    = 'getTableInfo'
        &PList    = "(INPUT pcUpdatableTable, OUTPUT pcReturnValue )"
        &AutoKill = YES
        &PlipRunError = "RETURN ERROR cErrorMessage."
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OverrideTriggers Include 
PROCEDURE OverrideTriggers :
/*------------------------------------------------------------------------------
  Purpose:     Server side only API to override triggers for the specified table
  Parameters:  input database name (if known)
               input table name to override triggers in
               input comma delimited list of triggers to override or * for all
               input override flag yes/no, yes = set override, no = delete it
  Notes:       The supported triggers for override are:
               create,delete,write,find,replication-create,replication-delete,replication-write
               This api assumes the trigger will contain code at the top using the
               standard include file aftrigover.i, e.g.
               
               {aftrigover.i &DB-NAME      = "ICFDB"
                                     &TABLE-NAME   = "gst_trigger_override"
                                     &TRIGGER-TYPE = "CREATE"}

               If the triggers were generated by ERwin, then this code is inserted
               automatically as it has been placed in the trigger macro templates
               afercustrg.i, aftemreplc.i, aftemreplw.i, and aftemrepld.i
               
               This API creates or deletes the gst_trigger_override records being
               checked by the include file.

               This API must be called from within the database transaction for
               both the create and delete
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcDbName                  AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcTableName               AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcTriggerList             AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  plOverride                AS LOGICAL    NO-UNDO.

DEFINE VARIABLE hBuffer                           AS HANDLE     NO-UNDO.
DEFINE VARIABLE cUserLogin                        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iTransaction                      AS INTEGER    NO-UNDO.

&IF DEFINED(server-side) <> 0 &THEN

  IF pcDbName = "":U THEN
  DO:
    CREATE BUFFER hBuffer FOR TABLE pcTableName.
    ASSIGN pcDbName = hBuffer:DBNAME.
    DELETE OBJECT hBuffer.
    ASSIGN hBuffer = ?.
  END.
  
  ASSIGN iTransaction = DBTASKID(pcDbName).
  IF NOT iTransaction > 0 THEN RETURN.
  
  IF plOverride THEN
  DO: /* override triggers */
    cUserLogin = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                  INPUT "currentUserLogin":U,
                                  INPUT NO).
    CREATE gst_trigger_override.
    ASSIGN
      gst_trigger_override.TABLE_name = pcTableName
      gst_trigger_override.TRANSACTION_id = iTransaction
      gst_trigger_override.OVERRIDE_date = TODAY
      gst_trigger_override.OVERRIDE_time = TIME
      gst_trigger_override.OVERRIDE_trigger_list = pcTriggerList
      gst_trigger_override.OVERRIDE_user = cUserLogin
      gst_trigger_override.calling_stack = "":U
      iLoop = 1
      .
    DO WHILE PROGRAM-NAME(iLoop) <> ?:
      ASSIGN
       gst_trigger_override.calling_stack = gst_trigger_override.calling_stack + PROGRAM-NAME(iLoop) + CHR(10)
       iLoop = iLoop + 1
       .
    END.
    
    RELEASE gst_trigger_override.
  END.
  ELSE
  DO: /* delete override */
    FIND FIRST gst_trigger_override EXCLUSIVE-LOCK
         WHERE gst_trigger_override.TABLE_name = pcTableName
           AND gst_trigger_override.TRANSACTION_id = iTransaction
           AND gst_trigger_override.OVERRIDE_date >= TODAY - 1
           AND gst_trigger_override.OVERRIDE_date <= TODAY + 1
         NO-ERROR.
    IF AVAILABLE gst_trigger_override THEN
      DELETE gst_trigger_override.
  END.

&ENDIF

ERROR-STATUS:ERROR = NO.
RETURN.
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
  Purpose:     To get the latest set of Entity Mnemonic Records into the cache
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE ttEntityMnemonic.
    
    &IF DEFINED(server-side) <> 0 &THEN
    /* On the server side run the internal procedure to populate the cache
       in this general manager */
    RUN gsgetenmnp (OUTPUT TABLE ttEntityMnemonic).
    &ELSE
    /* This is on the client-side so run gsgetenmp.p directly to populate
       the Entity Mnemonic cache */
    RUN af/app/gsgetenmnp.p ON gshAstraAppserver (OUTPUT TABLE ttEntityMnemonic).
    &ENDIF
          
    RETURN.
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
        ELSE
            RUN serverCommit IN hSDO ( INPUT-OUTPUT TABLE-HANDLE phRowObjUpd,
                                             OUTPUT cErrorList,
                                             OUTPUT cUndoRowids          ) NO-ERROR.
        ASSIGN lErrorStatus = ERROR-STATUS:ERROR.

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

    /* Has an Entity Mnemonic record been created yet? */
    IF CAN-FIND(ttEntityMnemonic WHERE ttEntityMnemonic.entity_mnemonic = pcEntityMnemonic) THEN
        ASSIGN pcResult = "OK":U.
    ELSE
    DO:
    &IF DEFINED(server-side) = 0 &THEN
        { afrun2.i
            &PLIP            = 'af/app/afsuprmanp.p'
            &IProc           = 'setAsSuperProcedure'
            &PList           = "(INPUT 'GEN':U, INPUT 'ADD':U)"
            &AutoKillOnError = YES
        }
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        { afrun2.i
            &PLIP         = 'af/app/afsuprmanp.p'
            &IProc        = 'validateEntityMnemonic'
            &PList        = "(INPUT pcEntityMnemonic, OUTPUT pcResult)"
            &AutoKill     = YES
            &PlipRunError = "RETURN ERROR cErrorMessage."
        }
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
    /* Has an Entity Mnemonic record been created yet?  */
    IF CAN-FIND(gsc_entity_mnemonic WHERE gsc_entity_mnemonic.entity_mnemonic = pcEntityMnemonic) THEN
        ASSIGN pcResult = "REFRESH":U.
    &ENDIF
    END.    /* not locally cached. */

    /* If the result is refresh, then the entity mnemonic has been found in the
     * database, but not in the cache. We refresh the cache, so that it can
     * be found there next time.                                               */
    IF pcResult = "REFRESH":U THEN
    DO:
        RUN refreshMnemonicsCache.
        ASSIGN pcResult = "OK":U.
    END.    /* result is refresh */

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
  FIND ttEntityMnemonic 
      WHERE ttEntityMnemonic.entity_mnemonic = pcEntityMnemonic NO-ERROR.

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
            Entry 3 - Obj Field of Table
            
    Notes:  The data source handle should be the handle of an SDO that you want
            to retrieve data for
            
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
  Purpose:  Find the property in the property list and add / replace it with the
            specified property value depending on the action specified
    Notes:  pcAction should have a value of "ADD":U or "REPLACE":U
            NB: If "":U or ? is specified as the action, a replacement of the
                property value will be done by default
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cNewPropertyList      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPropertyValue        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPropertyName         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntry                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iNumEntries           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEntry                AS INTEGER    NO-UNDO.
      
  ASSIGN iNumEntries = NUM-ENTRIES(pcPropertyList, CHR(3)).
  
  DO iEntry = 1 TO iNumEntries:
    ASSIGN cEntry         = ENTRY(iEntry, pcPropertyList, CHR(3))
           cPropertyName  = ENTRY(1, cEntry, CHR(4))
           cPropertyValue = ENTRY(2, cEntry, CHR(4)).
    
    IF cPropertyName = pcPropertyName THEN DO:
      IF pcAction = "REPLACE":U OR
         pcAction = ?           OR
         TRIM(pcAction) = "":U  THEN cPropertyValue = "":U.
      ELSE
        IF TRIM(cPropertyValue) <> "":U THEN cPropertyValue = cPropertyValue + " AND ":U.
      
      ASSIGN cEntry = pcPropertyName + CHR(4) + cPropertyValue + pcPropertyValue.
    END.
      
    ASSIGN cNewPropertyList = cNewPropertyList + cEntry.
  
    IF iEntry <> iNumEntries THEN
      ASSIGN cNewPropertyList = cNewPropertyList + CHR(3).
  END.

  RETURN cNewPropertyList.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

