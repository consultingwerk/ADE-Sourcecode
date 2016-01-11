&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
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
/*--------------------------------------------------------------------------
    File        : sbo.p
    Purpose     : Super procedure for sbo class.

    Syntax      : RUN start-super-proc("adm2/sbo.p":U).

    Modified    : December 8, 2000 -- Version 9.1B+
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


&SCOP ADMSuper sbo.p

DEFINE VARIABLE ghTargetProcedure AS HANDLE     NO-UNDO.

/* Custom exclude file */

  {src/adm2/custom/sboexclcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-addQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addQueryWhere Procedure 
FUNCTION addQueryWhere RETURNS LOGICAL
  ( pcWhere  AS CHARACTER, 
    pcObject AS CHARACTER, 
    pcAndOr  AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addRow Procedure 
FUNCTION addRow RETURNS CHARACTER
  ( pcViewColList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-appendContainedObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD appendContainedObjects Procedure 
FUNCTION appendContainedObjects RETURNS LOGICAL PRIVATE
  ( INPUT-OUTPUT pcObjects AS CHARACTER, INPUT phObject AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignContainedProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignContainedProperties Procedure 
FUNCTION assignContainedProperties RETURNS LOGICAL
  (pcPropValues   AS CHAR,
   pcReplace      AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignCurrentMappedObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignCurrentMappedObject Procedure 
FUNCTION assignCurrentMappedObject RETURNS LOGICAL
  ( phRequester  AS HANDLE, 
    pcObjectName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignQuerySelection Procedure 
FUNCTION assignQuerySelection RETURNS LOGICAL
  ( pcColumns AS CHARACTER, pcValues AS CHARACTER, pcOperators AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cancelRow Procedure 
FUNCTION cancelRow RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-canNavigate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD canNavigate Procedure 
FUNCTION canNavigate RETURNS LOGICAL
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnColumnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnColumnLabel Procedure 
FUNCTION columnColumnLabel RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnDataType Procedure 
FUNCTION columnDataType RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDbColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnDbColumn Procedure 
FUNCTION columnDbColumn RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnExtent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnExtent Procedure 
FUNCTION columnExtent RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnFormat Procedure 
FUNCTION columnFormat RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnHelp Procedure 
FUNCTION columnHelp RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnInitial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnInitial Procedure 
FUNCTION columnInitial RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnLabel Procedure 
FUNCTION columnLabel RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnMandatory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnMandatory Procedure 
FUNCTION columnMandatory RETURNS LOGICAL
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnModified Procedure 
FUNCTION columnModified RETURNS LOGICAL
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnObjectHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnObjectHandle Procedure 
FUNCTION columnObjectHandle RETURNS HANDLE
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnPrivateData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnPrivateData Procedure 
FUNCTION columnPrivateData RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnProperty Procedure 
FUNCTION columnProperty RETURNS CHARACTER PRIVATE
  ( pcColumn AS CHARACTER, pcProperty AS CHARACTER, phTarget AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnQuerySelection Procedure 
FUNCTION columnQuerySelection RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnReadOnly) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnReadOnly Procedure 
FUNCTION columnReadOnly RETURNS LOGICAL
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnStringValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnStringValue Procedure 
FUNCTION columnStringValue RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnTable Procedure 
FUNCTION columnTable RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValExp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnValExp Procedure 
FUNCTION columnValExp RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValMsg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnValMsg Procedure 
FUNCTION columnValMsg RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnValue Procedure 
FUNCTION columnValue RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnWidth Procedure 
FUNCTION columnWidth RETURNS DECIMAL
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-colValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD colValues Procedure 
FUNCTION colValues RETURNS CHARACTER
    (pcColumns AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-containedProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD containedProperties Procedure 
FUNCTION containedProperties RETURNS CHARACTER
  (pcQueryProps   AS CHAR,
   plDeep         AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD copyRow Procedure 
FUNCTION copyRow RETURNS CHARACTER
  ( pcViewColList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-currentMappedObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD currentMappedObject Procedure 
FUNCTION currentMappedObject RETURNS CHARACTER
  (  phRequester AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataObjectHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD dataObjectHandle Procedure 
FUNCTION dataObjectHandle RETURNS HANDLE
  ( pcObjectName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteRow Procedure 
FUNCTION deleteRow RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTargetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTargetProcedure Procedure 
FUNCTION getTargetProcedure RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newDataObjectRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newDataObjectRow Procedure 
FUNCTION newDataObjectRow RETURNS CHARACTER
  ( pcMode        AS CHARACTER,
    pcTargetNames AS CHARACTER,
    pcViewColList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD openQuery Procedure 
FUNCTION openQuery RETURNS LOGICAL
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD removeQuerySelection Procedure 
FUNCTION removeQuerySelection RETURNS LOGICAL
  ( pcColumns AS CHARACTER, 
    pcOperators AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD resetQuery Procedure 
FUNCTION resetQuery RETURNS LOGICAL
  ( pcObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-submitRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD submitRow Procedure 
FUNCTION submitRow RETURNS LOGICAL
  ( pcRowIdent  AS CHARACTER, 
    pcValueList AS CHARACTER)  FORWARD.

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
         HEIGHT             = 17.19
         WIDTH              = 54.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/sboprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addDataTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addDataTarget Procedure 
PROCEDURE addDataTarget :
/*------------------------------------------------------------------------------
  Purpose:  Update the ObjectMapping property that are used to broker messages
            between contained objects and objects linked to the SBO and also 
            set DataSourceNames and UpdateTargetNames in the dataTarges.                
  Parameters:  <none>
  Notes:    Called from registerObject, which are subscribed as DataTargetEvent 
            and published from the DataTarget's initializeObject. 
          - DataSourceNames may be specified by the user in which case it 
            actually specifies how to generate the ObjectMapping. 
            If it's not set, we ensure that both it and UpdateTargetNames 
            is ALWAYS set here so that colValues, addRow, deleteRow and 
            updateRow etc. can identify the intended target or source without 
            looping through all the fields again and again.
          - Objects buildt against RowObject must find ALL columns in ONE
            of the ContainedDataObjects in order to become mapped. 
          - Only this procedure is allowed to add datatargets to the 
            ObjectMapping property.  
          - ObjectMapping versus DataSourceNames. Thee is some overlap here and
            we could certainly have managed add-, copy- and deleteRow with 
            ObjectMapping instead of DataSourceNames. But since both cases 
            requires that we know the requester anyways, there's not much 
            advantage of just using the ObjectMapping. We also do need a way to 
            distinguish between UpdateTargets and DataSources and having them 
            implemented the same ways makes it a bit easier to use. 
            Ideally (??) the SBO should be more transparent and have an API that
            makes it unnecessary for the SBO to have this mapping and instead 
            make the visual objects responsible of telling the SBO what to 
            update and for this reason the properties in the visual object seems
            to have a more certain future .. ()                     
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phTarget AS HANDLE NO-UNDO. 
   
  /* These are the variables we are going to set the properties with */
  DEFINE VARIABLE cMapping            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUpdateTargetNames  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSourceNames    AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lSourceSpecified    AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE hMaster             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSourceList         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSource             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSource             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hUpdateTarget       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTargetList         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTarget             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSource             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iTarget             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cObjectList         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectName         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTarget             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataColumns        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnabledColumns     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUpdate             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cContainedColumns   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContainedObjects   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOColumns         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumn             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iColumn             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lSourceFound        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSBOTarget          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDataObjectNames    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iUpdLoop            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hUpd                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lOneToOne           AS LOGICAL    NO-UNDO.

    cTarget = STRING(phTarget).
    {get ObjectMapping cMapping}.
    
    /* Don't add if its already in the list */  
    IF LOOKUP(cTarget,cMapping) = 0 THEN
    DO:
      hTarget = WIDGET-HANDLE(cTarget).
      IF VALID-HANDLE(hTarget) THEN
      DO: 
        /* We also support  (SDOs) as data-targets */
        IF {fn getObjectType hTarget} = 'SmartDataObject':U THEN
        DO:
          {get ForeignFields cForeignFields hTarget}.
          IF cForeignFields <> '':U THEN
          DO iColumn = 1 TO NUM-ENTRIES(cForeignFields) BY 2:
              ASSIGN           /* 2nd of pair is source RowObject fld */
                cColumn     = ENTRY(iColumn + 1, cForeignFields)
                cObjectName = ENTRY(1,cColumn,".":U)
                hSource     = {fnarg dataObjectHandle cObjectName} NO-ERROR.            
             /* If this is truly one of the SBO's DataObjects 
                and not already in the DataSourceNames list then update the 
                mapping and the DataSourceNames */
              IF  VALID-HANDLE(hSource) 
              AND LOOKUP(cObjectName,cDataSourceNames) = 0  THEN
              DO:
                ASSIGN
                 cMapping         = cMapping 
                                  + (IF cMapping = "":U THEN "":U ELSE ",":U) 
                                  + STRING(hTarget) + ",":U + STRING(hSource)
                 cDataSourceNames = cDataSourceNames
                                  + (IF cDataSourceNames = "":U THEN "":U ELSE ",":U)
                                  + (IF cObjectName = ? THEN "?":U ELSE cObjectName).
              END.
          END. /* iColumn = 1 to num-entries ForeignFields by 2 */
          ELSE DO:
            /* We 'map' to master if no foreign fields */ 
            {get MasterdataObject hMaster}.
            {get ObjectName cObjectName hMaster}. 
            ASSIGN
            cMapping          = cMapping 
                              + (IF cMapping = "":U THEN "":U ELSE ",":U) 
                              + STRING(hTarget) + ",":U + STRING(hMaster)
             cDataSourceNames = cDataSourceNames
                              + (IF cDataSourceNames = "":U THEN "":U ELSE ",":U)
                              + (IF cObjectName = ? THEN "?":U ELSE cObjectName).

          END. /* else (no ForeignFields) */         
          {set DataSourceNames cDataSourceNames hTarget}.
          /* The mapping is set at the end of this proc */
        END. /* SDO  */
        ELSE DO: /* Deal with visual objects */
          
          {get DataSourceNames cObjectList hTarget} NO-ERROR.

             /* Set the flag that tells us that we don't need to update 
                the DataTarget Properties (probably not a big deal, but let's
                keep them as specified at design time) */       
          ASSIGN
            lSourceSpecified = (cObjectList <> ? AND cObjectList <> "":U)
            lSourceFound     = FALSE.

            /* if the Instance property dataSourceNames isn't defined see if 
             the 'Master' property DisplayedTables can be used or if it is 
             'RowObject' and all fields must be checked. (The term 'Master' 
             property refers to the fact that the property is defined at build
             time and not at instance design time)*/ 
          IF NOT lSourceSpecified THEN
            {get DisplayedTables cObjectList hTarget} NO-ERROR.
          
          /* We want to update UpdateTargetNames according to which fields 
             that actually are enabled. */  
          {get EnabledFields cEnabledColumns hTarget} NO-ERROR.

         /* If the target was built with RowObject, we check each field in the 
            target for a complete match in one of the ContainedObjects. 
            The ObjectList = '' also for dynBrowsers built before 
            and for objects build against an SBO with all fields disabled 
            due to an AppBuilder bug */ 
          IF cObjectList = 'RowObject':U OR cObjectList = '':U THEN
          DO:
            {get DisplayedFields cDataColumns hTarget} NO-ERROR.
            
            IF cDataColumns = "":U OR cDataColumns = ? THEN
              RETURN.

            {get ContainedDataObjects cContainedObjects}.
            {get ContainedDataColumns cContainedColumns}. 
            
            /* If the first column is qualifed this is built against an SBO */
            lSBOTarget = NUM-ENTRIES(ENTRY(1,cDataColumns),".":U) > 1. 

            IF lSBOTarget THEN
            DO:
              {get DataObjectNames cDataObjectNames}.
              SBOColumnSearch:
              DO iColumn = 1 TO NUM-ENTRIES(cDataColumns):
                ASSIGN
                  cColumn       = ENTRY(iColumn, cDataColumns)
                  /* If we haven't already found a matching enabled column,
                     check if this one is */  
                  lUpdate       = LOOKUP(cColumn,cEnabledColumns) > 0                                  
                  cObjectName   = ENTRY(1,cColumn,".":U)
                  cColumn       = ENTRY(NUM-ENTRIES(cColumn,".":U),cColumn,".":U)
                  iSource       = LOOKUP(cObjectName,cDataObjectNames).
                
                /* The qualifier does not match any SDO */
                IF iSource = 0 THEN
                DO:
                  lSourceFound = FALSE.
                  LEAVE SBOColumnSearch. 
                END.

                ASSIGN 
                  lUpdate     = FALSE
                  cSDOColumns = ENTRY(iSource,cContainedColumns,';':U).
              
                /*  The Column does not match */
                IF LOOKUP(cColumn,cSDOColumns) EQ 0 THEN
                DO:
                  lSourceFound = FALSE.
                  LEAVE SBOColumnSearch.
                END.
           
                IF LOOKUP(cObjectName,cDataSourceNames) = 0 THEN
                DO:
                  ASSIGN
                   lSourceFound = TRUE
                   cSource      = ENTRY(iSource,cContainedObjects) 
                   cMapping     = cMapping 
                                + (IF cMapping = "":U THEN "":U ELSE ",":U) 
                                + STRING(hTarget) + ",":U + cSource
                   cDataSourceNames = cDataSourceNames
                                + (IF cDataSourceNames = "":U THEN "":U ELSE ",":U)
                                + (IF cObjectName = ? THEN "?":U ELSE cObjectName).

                  /* Add this as an update target if the field is enabled */ 
                  IF lUpdate THEN
                     cUpdateTargetNames = cUpdateTargetNames
                               + (IF cUpdateTargetNames = "":U THEN "":U ELSE ",":U)
                               + (IF cObjectName = ? THEN "?":U ELSE cObjectName).
                END.
              END. /* DO iColumn = 1 TO NUM-ENTRIES(cDataColumns) */
            END.

            /* Unqualified columns, find ONE SDO that matches the columns. */
            ELSE 
            ContainedObjectSearch:
            DO iSource = 1 TO NUM-ENTRIES(cContainedObjects):
              ASSIGN
                lUpdate     = FALSE
                cSDOColumns = ENTRY(iSource,cContainedColumns,';':U).
              /* Check if all the columns mathes the contained columns for
                 this sdo  */
              DO iColumn = 1 TO NUM-ENTRIES(cDataColumns):
               
                cColumn = ENTRY(iColumn, cDataColumns).
                
                IF LOOKUP(cColumn,cSDOColumns) EQ 0 THEN
                   NEXT ContainedObjectSearch.
                
                /* If we haven't already found a matching enabled column,
                   check if this one is */  
                IF NOT lUpdate THEN 
                  lUpdate = LOOKUP(cColumn,cEnabledColumns) > 0.  

              END. /* DO iColumn -- locate each fld in the SDO. */
              
              /* If we get here all the columns in the target was in the
                 current containedObject, so update properties accordingly */
              ASSIGN
                lSourceFound = TRUE
                cSource      = ENTRY(iSource, cContainedObjects)
                hSource      = WIDGET-HANDLE(cSource).
              
              {get ObjectName cObjectName hSource} NO-ERROR.

              ASSIGN
                cMapping     = cMapping 
                             + (IF cMapping = "":U THEN "":U ELSE ",":U) 
                             + STRING(hTarget) + ",":U + cSource
                cDataSourceNames = cDataSourceNames
                             + (IF cDataSourceNames = "":U THEN "":U ELSE ",":U)
                             + (IF cObjectName = ? THEN "?":U ELSE cObjectName).
              
              /* Let's also avoid the need to loop in addRows, colValues etc.*/ 
              IF lUpdate THEN
                cUpdateTargetNames = cUpdateTargetNames
                           + (IF cUpdateTargetNames = "":U THEN "":U ELSE ",":U)
                           + (IF cObjectName = ? THEN "?":U ELSE cObjectName).
              /* No need to search anymore */
              LEAVE ContainedObjectSearch. 
            END. /* DO iSource = 1 */
            
            IF NOT lSourceFound THEN
              DYNAMIC-FUNCTION('showMessage':U IN TARGET-PROCEDURE,
               "Unable to find an apropriate data-source for object.'" 
               + hTarget:FILE-NAME  + "'":U
               + chr(10) +   
               "All columns must exist in" 
               + (IF lSBOTarget THEN '':U ELSE ' ONE of') 
               + " the SmartBusinessObject's"
               + " contained objects.").

          END. /* cObjectList = 'RowObject' */
          ELSE IF cObjectList NE ? AND cObjectList NE "":U THEN
          DO iSource = 1 TO NUM-ENTRIES(cObjectList):
            ASSIGN
              cObjectName = ENTRY(iSource,cObjectList)
              hSource     = {fnarg dataObjectHandle cObjectName} NO-ERROR.
            
            /* Add the two objects to the list with the outside object first */ 
            IF VALID-HANDLE(hSource) THEN 
            DO:
              cMapping = cMapping 
                       + (IF cMapping NE "":U THEN ",":U ELSE "":U)
                       + STRING(hTarget) + ",":U + STRING(hSource).

              IF NOT lSourceSpecified THEN
              DO:
                 cDataSourceNames = cDataSourceNames
                       + (IF cDataSourceNames = "":U THEN "":U ELSE ",":U)
                       +  cObjectName.
                 /* if the Object is a qualifier in enabledFields also 
                    the dataSource is also an UpdateTarget */   
                 IF cEnabledColumns BEGINS cObjectName + '.' 
                 OR INDEX(cEnabledColumns,',' + cObjectName + '.':U ) > 0 THEN
                    cUpdateTargetNames = cUpdateTargetNames
                       + (IF cUpdateTargetNames = "":U THEN "":U ELSE ",":U)
                       + cObjectName.

              END. /* If NOT lSourceDefined */
            END. /* if valid-handle(hSource) */
          END. /* if cObjectList <> RowObject do iSource = 1 to  */
                    /* Let's avoid the need to loop in getDataHandle and other methods */
          
          IF NUM-ENTRIES(cUpdateTargetNames) > 1 THEN
          DO iUpdLoop = 1 TO NUM-ENTRIES(cUpdateTargetNames):
              ASSIGN 
                cObjectName = ENTRY(iUpdLoop,cUpdateTargetNames)
                hUpd        =  {fnarg dataObjectHandle cObjectName}
                lOneToOne   = {fn hasOneToOneTarget hUpd}
                              OR 
                              {fn getUpdateFromSource hUpd}.

            IF NOT lOneToOne THEN
            DO:
              DYNAMIC-FUNCTION('showMessage':U IN TARGET-PROCEDURE,
                 "The SmartBusinessObject " 
                               + TARGET-PROCEDURE:FILE-NAME + " cannot update "
                 + REPLACE(cUpdateTargetNames,',':U,' and ':U) + ' together.' 
                 + " Either make sure that only fields from the SmartDataObject Update"
                 + " Target are enabled"
                 + " or if these objects have a one-to-one relationship and should be"
                 + " updated together, specify that the Data Target is to be updated"
                 + " from the Data Source in the SmartDataObject's Instance Properties."
                 + CHR(10) + CHR(10)
                 + " The enabled fields and the update link will be disabled for now.").

              {set EnabledFields '':U hTarget}.
              {set UpdateTargetNames '':U hTarget}. 
              {set UpdateTarget ? hTarget}.
              LEAVE.
            END. /* not one to one */
          END. /* num-entries(update targets ) > 1 then loop */
          
          IF NOT lSourceSpecified THEN
          DO:   
            {set DataSourceNames cDataSourceNames hTarget}. 
            {set UpdateTargetNames cUpdateTargetNames hTarget}. 
          END. /* if not source specified  */

          /* In support of browsers with no enabled fields we do 
             a final check to see if we are the object's updateTarget 
             and use the DataSourceNames as UpdateTargetNames. 
             We reread both properties in case Source was specified. */   
          {get UpdateTargetNames cUpdateTargetNames hTarget}.
          IF cUpdateTargetNames = '':U THEN
          DO:         
            {get UpdateTarget hUpdateTarget hTarget}.
            {get DataSourceNames cDataSourceNames hTarget}. 
            IF hUpdateTarget = TARGET-PROCEDURE 
            AND NUM-ENTRIES(cDataSourceNames) = 1 THEN
              {set UpdateTargetNames cDataSourceNames hTarget}. 
          END. /*IF cUpdateTargetNames = '':U */
        END. /* else do (visual objects)*/
        {set ObjectMapping cMapping}.
      END. /* DO if valid-handle(hTarget) */
    END. /* DO if lookup(cTarget,cMapping) = 0*/
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addNavigationSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addNavigationSource Procedure 
PROCEDURE addNavigationSource :
/*------------------------------------------------------------------------------
  Purpose:  Update the ObjectMapping property that are used to broker messages
            between contained objects and objects linked to the SBO.       
  Parameters: phSource - the handle of the Source
  Notes:    Called from registerObject, which are subscribed as 
            NavigationSourceEvent and published from the NavigationSource's 
            initializeObject.  
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phSource AS HANDLE NO-UNDO.
  
DEFINE VARIABLE hSource     AS HANDLE    NO-UNDO.
DEFINE VARIABLE cSource     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMapping    AS CHARACTER NO-UNDO.
DEFINE VARIABLE hMaster     AS HANDLE    NO-UNDO.
DEFINE VARIABLE cObjectName AS CHARACTER NO-UNDO.
DEFINE VARIABLE hTarget     AS HANDLE    NO-UNDO.
DEFINE VARIABLE cPosition   AS CHARACTER NO-UNDO.

  {get MasterDataObject hMaster}.
  {get ObjectMapping cMapping}.
  
   ASSIGN 
     hSource = phSource 
     cSource = STRING(hSource).
   IF LOOKUP(cSource,cMapping) = 0 THEN
   DO:

     {get NavigationTargetName cObjectName hSource} NO-ERROR.
     IF cObjectName NE ? AND cObjectName NE "":U THEN
       hTarget = {fnarg dataObjectHandle cObjectName} NO-ERROR.
     ELSE 
       hTarget = hMaster.   /* Use MasterDataObject as a default. */
   
     IF VALID-HANDLE(hTarget) THEN
     DO:
       /* Send the current queryPosition to the NavigationSource */ 
       {get QueryPosition cPosition}.
       ghTargetProcedure = TARGET-PROCEDURE.
       RUN queryPosition IN hSource (cPosition).
       ghTargetProcedure = ?. 
       /* Add the two objects to the list with the outside object first */ 
       cMapping = cMapping 
                + (IF cMapping NE "":U THEN ",":U ELSE "":U)
                + STRING(hSource) + ",":U + STRING(hTarget).

       {set ObjectMapping cMapping}.
     END.  /* Valid hTarget */
   END. /* DO if lookup (cSource,cMapping) = 0 */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignMaxGuess) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignMaxGuess Procedure 
PROCEDURE assignMaxGuess :
/*------------------------------------------------------------------------------
  Purpose:     Receives the assignMaxGuess event from a contained SDO and 
               passes it on to the appropriate DATA-TARGET
  Parameters:  piMaxGuess AS INTEGER
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER piMaxGuess AS INTEGER NO-UNDO.

DEFINE VARIABLE cMapping   AS CHAR   NO-UNDO.
DEFINE VARIABLE hObject    AS HANDLE NO-UNDO.
DEFINE VARIABLE iObject    AS INT    NO-UNDO.
DEFINE VARIABLE cHandle    AS CHAR   NO-UNDO.

  {get ObjectMapping cMapping}.
  cHandle = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE, /* may be more than one match */
                   INPUT STRING(SOURCE-PROCEDURE),
                   INPUT cMapping,
                   INPUT FALSE,           /* Get entry/entries *before* this */
                   INPUT ",":U).          /* delimiter */

  DO iObject = 1 TO NUM-ENTRIES(cHandle):
    hObject = WIDGET-HANDLE(ENTRY(iObject, cHandle)).
    RUN assignMaxGuess IN hObject (piMaxGuess) NO-ERROR.
  END.    /* END DO iObject */

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelNew) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelNew Procedure 
PROCEDURE cancelNew :
/*------------------------------------------------------------------------------
  Purpose:     Receives the cancelNew event from a contained SDO and 
               passes it on to the appropriate DATA-TARGET
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cMapping   AS CHAR   NO-UNDO.
DEFINE VARIABLE hObject    AS HANDLE NO-UNDO.
DEFINE VARIABLE iObject    AS INT    NO-UNDO.
DEFINE VARIABLE cHandle    AS CHAR   NO-UNDO.

  {get ObjectMapping cMapping}.
  cHandle = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE, /* may be more than one match */
                   INPUT STRING(SOURCE-PROCEDURE),
                   INPUT cMapping,
                   INPUT FALSE,           /* Get entry/entries *before* this */
                   INPUT ",":U).          /* delimiter */

  DO iObject = 1 TO NUM-ENTRIES(cHandle):
    hObject = WIDGET-HANDLE(ENTRY(iObject, cHandle)).
    RUN cancelNew IN hObject NO-ERROR.
  END.    /* END DO iObject */

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-commitTransaction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE commitTransaction Procedure 
PROCEDURE commitTransaction :
/*------------------------------------------------------------------------------
  Purpose:     client-side event procedure to receive the Commit event,
               gather up the updates from contained SDOs, and pass then
               on to the server.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContained  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iDO         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hDO         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBuffer     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTable      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTable1     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTable2     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTable3     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTable4     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTable5     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTable6     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTable7     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTable8     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTable9     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTable10    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTable11    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTable12    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTable13    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTable14    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTable15    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTable16    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTable17    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTable18    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTable19    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTable20    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hAppServer  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cASDivision AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cMessages   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUndoIds    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOrdering   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cHasRecords AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cIsAvail    AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cMapping    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSource     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hParent     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lFFChanged  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cObjectName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lAutoCommit AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lCommitOk   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lCancel     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lError      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hUndoSDO    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cCurRowident AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewRowident AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSource      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cHandle      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRefresh     AS CHARACTER  NO-UNDO.
  
  {get AutoCommit lAutoCommit}.

  IF NOT lAutoCommit THEN
  DO:
    /* Visual dataTargets subscribes to this */
    PUBLISH 'confirmCommit':U FROM TARGET-PROCEDURE (INPUT-OUTPUT lCancel).
    IF lCancel THEN RETURN.
  END.

  {get ContainedDataObjects cContained}.
  {get ASDivision cASDivision}.

  /* If we're on the client side pass the RowObjUpd table to the server. 
     Rearrange the table order as necessary to match the AppBuilder-generated 
     order, which is the order of the parameters. */
  {get DataObjectOrdering cOrdering}.
  DO iDO = 1 TO NUM-ENTRIES(cOrdering):
      hDO = WIDGET-HANDLE(ENTRY(INTEGER(ENTRY(iDO, cOrdering)), cContained)).
      {get RowObjUpdTable hTable hDO}.
      /* SKip SDOs that have no updates, and keep track of them for use
          after the server transaction. */
      
      IF hTable:HAS-RECORDS THEN  
      DO:
        cHasRecords = cHasRecords + 
             (IF cHasRecords = "":U THEN "":U ELSE ",":U) +
             ENTRY(iDO, cOrdering).
        RUN doBuildUpd IN hDO. /* (OUTPUT TABLE-HANDLE hTable) REMOVED! */
      END.         /* END DO IF HAS-RECORDS */

      CASE iDO:
          WHEN 1 THEN
              hTable1 = hTable.
          WHEN 2 THEN
              hTable2 = hTable.
          WHEN 3 THEN
              hTable3 = hTable.
          WHEN 4 THEN
              hTable4 = hTable.
          WHEN 5 THEN
              hTable5 = hTable.
          WHEN 6 THEN
              hTable6 = hTable.
          WHEN 7 THEN
              hTable7 = hTable.
          WHEN 8 THEN
              hTable8 = hTable.
          WHEN 9 THEN
              hTable9 = hTable.
          WHEN 10 THEN
              hTable10 = hTable.
          WHEN 11 THEN
              hTable11 = hTable.
          WHEN 12 THEN
              hTable12 = hTable.
          WHEN 13 THEN
              hTable13 = hTable.
          WHEN 14 THEN
              hTable14 = hTable.
          WHEN 15 THEN
              hTable15 = hTable.
          WHEN 16 THEN
              hTable16 = hTable.
          WHEN 17 THEN
              hTable17 = hTable.
          WHEN 18 THEN
              hTable18 = hTable.
          WHEN 19 THEN
              hTable19 = hTable.
          WHEN 20 THEN
              hTable20 = hTable.
      END CASE.
  END.          /* END DO iDO */

  IF cASDivision = "Client":U THEN
      {get ASHandle hAppServer}.
  ELSE hAppServer = TARGET-PROCEDURE.
  
  RUN serverCommitTransaction IN hAppServer
      (INPUT-OUTPUT TABLE-HANDLE hTable1, 
       INPUT-OUTPUT TABLE-HANDLE hTable2,
       INPUT-OUTPUT TABLE-HANDLE hTable3,
       INPUT-OUTPUT TABLE-HANDLE hTable4,
       INPUT-OUTPUT TABLE-HANDLE hTable5,
       INPUT-OUTPUT TABLE-HANDLE hTable6,
       INPUT-OUTPUT TABLE-HANDLE hTable7,
       INPUT-OUTPUT TABLE-HANDLE hTable8,
       INPUT-OUTPUT TABLE-HANDLE hTable9,
       INPUT-OUTPUT TABLE-HANDLE hTable10,
       INPUT-OUTPUT TABLE-HANDLE hTable11,
       INPUT-OUTPUT TABLE-HANDLE hTable12,
       INPUT-OUTPUT TABLE-HANDLE hTable13,
       INPUT-OUTPUT TABLE-HANDLE hTable14,
       INPUT-OUTPUT TABLE-HANDLE hTable15,
       INPUT-OUTPUT TABLE-HANDLE hTable16,
       INPUT-OUTPUT TABLE-HANDLE hTable17,
       INPUT-OUTPUT TABLE-HANDLE hTable18,
       INPUT-OUTPUT TABLE-HANDLE hTable19,
       INPUT-OUTPUT TABLE-HANDLE hTable20,
       OUTPUT cMessages, 
       OUTPUT cUndoIds).

  /* If we're running standalone (not divided), then errors are logged
     via addMessage. Otherwise, if we're the client of a divided SBO,
     messages will have been returned from the server and we log them here. */
  IF cASDivision = 'Client':U AND cMessages NE "":U THEN
    RUN addMessage IN TARGET-PROCEDURE (cMessages, ?, ?).
  
  lCommitOk = NOT DYNAMIC-FUNCTION ('anyMessage':U IN TARGET-PROCEDURE) 
              AND cUndoIds = '':U. 
  /* We will need to improve this to happen after endClientdataRequest 
     This is here to solve cases where a visual object has more than 
     one source and the foreignField changed, Note that in the case of 
     an add/copy this is ALWAYS */
  IF lCommitOk THEN
  DO:
    {set RowObjectState 'NoUpdates':U}. 
    /* reset RowObjectState and checkif the commit changed ForeignFields,
       which require that we reopen the query to be in synch */ 
    DO iDO = 1 TO NUM-ENTRIES(cContained):
      hDO   = WIDGET-HANDLE(ENTRY(iDO,cContained)).
      
      IF LOOKUP(STRING(iDO), cHasRecords) NE 0 THEN
        RUN doReturnUpd IN hDO (INPUT cUndoIds).
      
      {set RowObjectState 'NoUpdates':U hDO}.
      {get DataSource hParent hDO}.
    
      /* Check if FF has changed in child objects  */
      IF iDO > 1 AND CAN-DO(cContained,STRING(hParent)) THEN
      DO:
        lFFChanged = {fn hasForeignKeyChanged hDO}.
        IF lFFChanged THEN
        DO:
          {get ObjectName cObjectName hDO}.
          RUN fetchContainedData IN TARGET-PROCEDURE (cObjectName).
          /* Logg that we have them avail so we don't publish further down */
          cIsAvail = cIsAvail 
                     + (IF cIsAvail= "":U THEN "":U ELSE ",":U) 
                     + STRING(iDO).
        END.
      END.
    END. /* DO iDO set ROS off in all SDOs. */
  END.

  RUN endClientDataRequest IN TARGET-PROCEDURE. 
  
    /* Now return any changed rows back to the individual SDOs. */
  {get ObjectMapping cMapping}.  
  /* We need this to logg reposition during return of errros */
  IF NOT lCommitOK THEN
    cRefresh = FILL(',',NUM-ENTRIES(cContained)).

  IF NOT lCommitOK THEN
  SDOloop:
  DO iDO = 1 TO NUM-ENTRIES(cContained):
    IF LOOKUP(STRING(iDO), cHasRecords) NE 0 THEN
    DO:
      {get Rowident cCurRowident hDO}. 
      RUN doReturnUpd IN hDO (INPUT cUndoIds).     
      {get Rowident cNewRowident hDO}. 
      /* The undo changed position, so we need to publish to SDO datatargets */ 
      IF cCurRowident <> cNewRowident THEN
      DO:
        /* Check if we have changed position of any source, which means that we 
           will receive a dataAvailable from that and don't need to mark this 
           to be refreshed */  
        hSource = hDO. 
        DO WHILE VALID-HANDLE(hSource):
          {get DataSource hSource hSource}.
          iSource = LOOKUP(STRING(hSource),cContained). 
          /* we have a parent that will be refreshed, so undo the next SDO */
          IF iSource > 0 AND ENTRY(iSource, cRefresh) <> '':U THEN
             NEXT SDOLoop.
        END.
         /* Set the refresh flag */
        ENTRY(ido,cRefresh) = '1':U.
      END. /* Changed position */
      /* If we did not NEXT SDoloop we need to refresh */  
    END.  /* IF Has-records */
  END.   /* if commit failed DO iDO loop */
 
  IF DYNAMIC-FUNCTION ('anyMessage':U IN TARGET-PROCEDURE) THEN
  DO:
    /* Get the client object (any one will do) to display the errors. */
    {get UpdateSource cHandle}.         /* There may be more than one. */
    hSource = WIDGET-HANDLE(ENTRY(1, cHandle)).
    IF VALID-HANDLE(hSource) THEN       /* sanity check */
        {fn showDataMessages hSource}.
    lError = TRUE.
  END.       /* END DO if there are error messages */
         
  IF NOT lCommitOk THEN
  DO:
    /* Block outgoing messages while we may do an internal dataAvailable in cases 
       where the position changed, since we always do an external dataAvailable 
       of  all data further down also when position has not changed */ 
    {set BlockDataAvailable YES}.
    DO iDO = 1 TO NUM-ENTRIES(cContained):
      hDO = WIDGET-HANDLE(ENTRY(iDO, cContained)).
      /* The position changed in doReturnUpd so publish */
      IF ENTRY(iDO,cRefresh) <> '':U THEN
        PUBLISH 'dataAvailable':U FROM hDO (INPUT "DIFFERENT":U).
    END.
    {set BlockDataAvailable NO}.
  END.  /* not commit ok */

  /* Now let external client objects know we might have changed data. */  
  PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE 
                 (IF lCommitOk THEN 'SAME':U ELSE 'DIFFERENT':U).
  
  RETURN IF lError THEN "ADM-ERROR":U ELSE '':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-confirmContinue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE confirmContinue Procedure 
PROCEDURE confirmContinue :
/*------------------------------------------------------------------------------
  Purpose:  Check for pending updates in data targets and ask if it is 
            ok to continue.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER pioCancel AS LOGICAL NO-UNDO.  
   
  /* don't ask data-targets if already cancelled */  
  IF NOT pioCancel THEN
    PUBLISH "confirmContinue":U FROM TARGET-PROCEDURE (INPUT-OUTPUT pioCancel). 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable Procedure 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     This version of dataAvailable basically just notifies other
               objects (Data-Targets) that the current row has been changed.
               Or if the DataSource is an external object, use the Foreign
               Fields property to get the key field values to use to reopen
               the Master object's query.
  Parameters:  pcRelative AS CHARACTER (see data.p for details)
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcRelative AS CHARACTER NO-UNDO.

  DEFINE VARIABLE hSource        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cForeignFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNewSource     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iField         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLocalFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSourceFields  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValues        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hMaster        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iEntry         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hDO            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cMapping       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHandles       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lInitted       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDataTargets   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lBlockDataAvailable AS LOGICAL NO-UNDO.

  {get ObjectInitialized lInitted}.
  /* Let the SBO call this later*/
  IF NOT lInitted THEN 
      RETURN.  

  /* First find out whether this came from our own dataSource or one
     of the contained DataObjects. */
  {get DataSource hSource}.    
                            /* identifies call from intializeObject*/ 
  IF hSource = SOURCE-PROCEDURE OR pcRelative = 'initialize':U THEN
  DO:
      /* It did come from an external DataSource. If it's not just the
         SAME row as before, get the foreign fields and prepare the Query
         for the Master DataObject using those values. */
      {get ForeignFields cForeignFields}.
      IF cForeignFields = "":U OR pcRelative = "SAME":U THEN
          RETURN.
      {get NewRow lNewSource hSource}.
      IF NOT lNewSource THEN
      DO:
          /* Don't deal with a row that's just being created. */
          DO iField = 1 TO NUM-ENTRIES(cForeignFields) BY 2:
              cLocalFields = cLocalFields +  /* 1st of each pair is SDO fld  */
               (IF cLocalFields NE "":U THEN ",":U ELSE "":U) +
                ENTRY(iField, cForeignFields).
              cSourceFields = cSourceFields +   /* 2nd of pair is source fld */
                (IF cSourceFields NE "":U THEN ",":U ELSE "":U) +
                   ENTRY(iField + 1, cForeignFields).
          END.        /* END DO iField */
    
          cValues = {fnarg colValues cSourceFields hSource} NO-ERROR.
  
          /* Throw away the RowIdent entry returned by colValues*/
          IF cValues NE ? THEN 
              cValues = SUBSTR(cValues, INDEX(cValues, CHR(1)) + 1).
  
          {set ForeignValues cValues}.  /* Save FF values for later querying. */
      END. /* not lNewSource  */

      /* NOTE: NOT (lNewSource = FALSE) because lNewSource = ? when 
         source closed */
      IF NOT (lNewSource = FALSE) OR cValues = ? THEN 
      DO:                     /* No row available in the Source. */
          {get MasterDataObject hMaster}.
          {fn closeQuery hMaster}.      /* Close the previous query. */
          RETURN.
      END.
      DYNAMIC-FUNCTION("assignQuerySelection":U IN TARGET-PROCEDURE, 
                    cLocalFields,
                    cValues,
                    '':U).   
     
      {fn openQuery}.
  END.      /* END DO IF this came from an external Object. */
  ELSE DO:     
     /* Find out if this came from one of our Data-*Target*s (such as a
        Browser). if so, send the event on to the associated SDO. 
        We must check that the SOURCE is the first entry of a pair,
        which means its an external object linked to an internal SDO. */
     {get ObjectMapping cMapping}.
     cHandles = DYNAMIC-FUNCTION ('mappedEntry':U IN TARGET-PROCEDURE,
                                  INPUT STRING(SOURCE-PROCEDURE),
                                  INPUT cMapping,
                                  INPUT TRUE, /* Return entry after this */
                                  INPUT ",":U).
     
     {get DataTarget cDataTargets}.
     
     IF cHandles NE ? THEN
     DO iEntry = 1 TO NUM-ENTRIES(cHandles):
         hDO = WIDGET-HANDLE(ENTRY(iEntry, cHandles)).
          /* Allow for the possibility of more than one match.  
             
             The SDO (9.1C) must receive 'value-changed' to just pass the 
             event on without applying ForeignFields and reopen the query 
             (This is the future event that any object can pass without 
             the SDO/SBO requiring to know who the caller is, but we still 
             support 'different' and 9.1C browsers still passes that, so check
             whether the caller is a target) */
        RUN dataAvailable IN hDO
              (IF pcRelative = 'DIFFERENT':U 
               AND CAN-DO(cDataTargets,STRING(SOURCE-PROCEDURE))  
               THEN 'VALUE-CHANGED':U 
               ELSE pcRelative) NO-ERROR.
     END.       /* END DO iEntry */
     ELSE DO:
         /* The event came from one of our internal DataObjects. Locate
            the external object mapped to it and pass the event along. */
        /* First check if outgoing DataAvailable is blocked, 
           Usually because of an ongoing update to avoid a lot of messages */  
        {get BlockDataAvailable lBlockDataAvailable}.
        IF NOT lBlockDataAvailable THEN
        DO:
          cHandles = DYNAMIC-FUNCTION ('mappedEntry':U IN TARGET-PROCEDURE,
                                  INPUT STRING(SOURCE-PROCEDURE),
                                  INPUT cMapping,
                                  INPUT FALSE, /* Return entry *before* this */
                                  INPUT ",":U).
        
          /* Allow for the possibility of more than one match. */
          IF cHandles NE ? THEN
          DO iEntry = 1 TO NUM-ENTRIES(cHandles):
            RUN dataAvailable IN WIDGET-HANDLE(ENTRY(iEntry, cHandles))
                  (INPUT pcRelative) NO-ERROR.
          END.    /* END DO iEntry */
        END.
     END.       /* END ELSE DO (if not from a data-target) */
  END.           /* END ELSE DO (if not from an external object) */

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteComplete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteComplete Procedure 
PROCEDURE deleteComplete :
/*------------------------------------------------------------------------------
  Purpose:     Receives the deleteComplete event from a contained SDO and 
               passes it on to the appropriate DATA-TARGET
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cMapping   AS CHAR   NO-UNDO.
DEFINE VARIABLE hObject    AS HANDLE NO-UNDO.
DEFINE VARIABLE iObject    AS INT    NO-UNDO.
DEFINE VARIABLE cHandle    AS CHAR   NO-UNDO.

  {get ObjectMapping cMapping}.
  cHandle = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE, /* may be more than one match */
                   INPUT STRING(SOURCE-PROCEDURE),
                   INPUT cMapping,
                   INPUT FALSE,           /* Get entry/entries *before* this */
                   INPUT ",":U).          /* delimiter */

  DO iObject = 1 TO NUM-ENTRIES(cHandle):
    hObject = WIDGET-HANDLE(ENTRY(iObject, cHandle)).
    RUN deleteComplete IN hObject NO-ERROR.
  END.    /* END DO iObject */

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyServerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyServerObject Procedure 
PROCEDURE destroyServerObject :
/*------------------------------------------------------------------------------
     Purpose:  Fetch context from the server side procedure   
  Parameters: 
       Notes: unbindServer is the public interface to this procedure. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hAsHandle         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cContainedProps   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cContainedObjects AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cQueryString      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iObject           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hObject           AS HANDLE    NO-UNDO.

  {get AsHandle hAsHandle}.

  IF VALID-HANDLE(hAsHandle) THEN
  DO:
    /* We have a problem.... 
       All SDOs except the upper one in a particular serverSendContained* 
       call is joined on server and the returned queryWhere will include 
       ForeignFields, which we don't know the position if. So if the queryString
       is blank we store the current openQuery or QueryWhere as the QueryString. 
       A non-blank QueryString will be used in query manipulation and we avoid 
       duplication of those ForeignFields.  
       This logic is currently duplicated in endClientDataRequest */     
    {get ContainedDataObjects cContainedObjects}.
    DO iObject = 2 TO NUM-ENTRIES(cContainedObjects):
      hObject = WIDGET-HANDLE(ENTRY(iObject,cContainedObjects)).
      {get QueryString cQueryString hObject}.
      IF cQueryString = '':U THEN
      DO:
        /* QueryWhere should normally be ? at this stage, but it might
           have been set from an external call */
        {get QueryWhere cQueryString hObject}.
        IF cQueryString = ? THEN
          {get OpenQuery cQueryString hObject}.

        {set QueryString cQueryString hObject}.
      END. /* QueryString = '' */
    END. /* Do iObject = 1 to num-entries(cContainedObjects) */
    
    RUN getContextAndDestroy IN hAsHandle (OUTPUT cContainedProps).

    {set AsHandle ?}. /* Set ? , valid-handle checks are not good enough */
                       
    DYNAMIC-FUNCTION('assignContainedProperties':U IN TARGET-PROCEDURE,
                      cContainedProps,
                     'QueryWhere,QueryContext':U). /* replace  */ 

  END. /* Valid(hAsHandle) */

  RETURN. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-endClientDataRequest) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endClientDataRequest Procedure 
PROCEDURE endClientDataRequest :
/*------------------------------------------------------------------------------
  Purpose: Contains logic to retrieve data properties from the Appserver 
           after a data request. Both queries and commit is considered as data 
           requests.        
    Notes: The purpose of this function is to encapsulate the logic for 
           stateless and state-aware requests in one call.           
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAsDivision       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOperatingMode    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hAsHandle         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cProperties       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lASBound          AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cContainedObjects AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iObject           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cQueryString      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hObject           AS HANDLE     NO-UNDO.
  
  {get AsDivision cAsDivision}.

  /* Get out if not 'client' */
  IF cAsDivision <> 'Client':U THEN 
    RETURN.
  
  {get ServerOperatingMode cOperatingMode}.
  
  IF cOperatingMode = 'stateless':U THEN  
    /* We must pass the caller to unbindServer to ensure proper unbinding. */ 
    RUN unbindServer IN TARGET-PROCEDURE(PROGRAM-NAME(2)).
  
  /* Check if we still are bound */ 
  {get AsBound lAsBound}.
  
  /* if we are state-aware or the unbind did not yet unbind we need these 
     properties after a data request */ 
  IF lAsBound THEN 
  DO:
    /* We have a problem.... 
       All SDOs except the upper one in a particular serverSendContained* 
       call is joined on server and the returned queryWhere will include 
       ForeignFields, which we don't know the position if. So if the queryString
       is blank we store the current openQuery or QueryWhere as the QueryString. 
       A non-blank QueryString will be used in query manipulation and we avoid 
       duplication of those ForeignFields. 
       This logic is currently duplicated in destroyServerObject 
       We will improve this .. */    
    {get ContainedDataObjects cContainedObjects}.
    
    DO iObject = 2 TO NUM-ENTRIES(cContainedObjects):
      hObject      = WIDGET-HANDLE(ENTRY(iObject,cContainedObjects)).
      {get QueryString cQueryString hObject}.
      IF cQueryString = '':U THEN
      DO:
        /* QueryWhere should normally be ? at this stage, but it might
           have been set from an external call */
        {get QueryWhere cQueryString hObject}.
        IF cQueryString = ? THEN
          {get OpenQuery cQueryString hObject}.

        {set QueryString cQueryString hObject}.
      END. /* QueryString = '' */
    END. /* Do iObject = 1 to num-entries(cContainedObjects) */
    
    {get AsHandle hasHandle}.

    cProperties = DYNAMIC-FUNC('containedProperties':U IN hAsHandle,
            'FirstRowNum,LastRowNum,ForeignValues,QueryWhere':U,
             NO).
    
    DYNAMIC-FUNC('assignContainedProperties':U IN TARGET-PROCEDURE,
                                cProperties,
                               'QueryWhere,QueryContext':U /* Replace */).

  END. /* lAsBound */

  RETURN.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchBatch Procedure 
PROCEDURE fetchBatch :
/*------------------------------------------------------------------------------
  Purpose:     Returns the next batch of rows to a browse object, communicating
               with its SDO.
  Parameters:
    INPUT plForwards - TRUE if we should retrieve a batch of rows after 
                       the current rows,
                       FALSE if before.  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER plForwards AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cMapping      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iEntry        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hSDO          AS HANDLE    NO-UNDO.
  
  /* Get the mapping of objects to DataObjects to locate the SDO for this
     browse.  */
  {get ObjectMapping cMapping}.
  
  iEntry = LOOKUP(STRING(SOURCE-PROCEDURE), cMapping).
 
  IF iEntry NE 0 THEN
  DO:
    hSDO = WIDGET-HANDLE(ENTRY(iEntry + 1, cMapping)).
    RUN fetchBatch IN hSDO(INPUT plForwards).
  END.         /* END DO IF SOURCE matches current Entry */
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchContainedData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchContainedData Procedure 
PROCEDURE fetchContainedData :
/*------------------------------------------------------------------------------
  Purpose:     client-side procedure to get a set of data back from the
               server.
  Parameters:  pcObject AS CHARACTER -- if specified, then fetch data sets
               from that Object down only.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcObject AS CHARACTER  NO-UNDO.
 
  DEFINE VARIABLE cASDivision    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAllQueries    AS CHARACTER  NO-UNDO INIT "":U.
  DEFINE VARIABLE hAppServer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject1    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject2    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject3    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject4    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject5    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject6    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject7    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject8    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject9    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject10   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject11   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject12   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject13   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject14   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject15   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject16   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject17   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject18   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject19   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject20   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hMaster        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSDOs          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDONames      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignValues AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSDO           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSDO           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iSDONum        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTTList        AS CHARACTER  NO-UNDO.

  {get ASDivision cASDivision}.
  
  RUN changeCursor IN TARGET-PROCEDURE('WAIT':U).

  IF cASDivision = 'Client':U THEN
  /* This is the Client half of a divided SBO; get the server to
     apply the where clause, open the server-side queries, and
     return the resulting temp-tables. */
  DO:
    RUN prepareQueriesForFetch IN TARGET-PROCEDURE
                 (INPUT pcObject,
                  INPUT '':U,
                  OUTPUT cAllQueries,
                  OUTPUT cTTList).
    
    IF RETURN-VALUE BEGINS 'ADM-ERROR':U THEN
       RETURN RETURN-VALUE.

    ASSIGN 
      hRowObject1  = WIDGET-H(ENTRY(1,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 1
      hRowObject2  = WIDGET-H(ENTRY(2,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 2
      hRowObject3  = WIDGET-H(ENTRY(3,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 3
      hRowObject4  = WIDGET-H(ENTRY(4,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 4
      hRowObject5  = WIDGET-H(ENTRY(5,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 5
      hRowObject6  = WIDGET-H(ENTRY(6,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 6
      hRowObject7  = WIDGET-H(ENTRY(7,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 7
      hRowObject8  = WIDGET-H(ENTRY(8,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 8
      hRowObject9  = WIDGET-H(ENTRY(9,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 9
      hRowObject10 = WIDGET-H(ENTRY(10,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 10
      hRowObject11 = WIDGET-H(ENTRY(11,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 11
      hRowObject12 = WIDGET-H(ENTRY(12,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 12
      hRowObject13 = WIDGET-H(ENTRY(13,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 13
      hRowObject14 = WIDGET-H(ENTRY(14,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 14
      hRowObject15 = WIDGET-H(ENTRY(15,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 15
      hRowObject16 = WIDGET-H(ENTRY(16,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 16
      hRowObject17 = WIDGET-H(ENTRY(17,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 17
      hRowObject18 = WIDGET-H(ENTRY(18,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 18
      hRowObject19 = WIDGET-H(ENTRY(19,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 19
      hRowObject20 = WIDGET-H(ENTRY(20,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 20.

    {get ASHandle hAppServer}.
 

    RUN serverFetchContainedData IN hAppServer
          (INPUT cAllQueries, 
           INPUT '':U, 
           OUTPUT TABLE-HANDLE hRowObject1, 
           OUTPUT TABLE-HANDLE hRowObject2,
           OUTPUT TABLE-HANDLE hRowObject3,
           OUTPUT TABLE-HANDLE hRowObject4,
           OUTPUT TABLE-HANDLE hRowObject5,
           OUTPUT TABLE-HANDLE hRowObject6,
           OUTPUT TABLE-HANDLE hRowObject7,
           OUTPUT TABLE-HANDLE hRowObject8,
           OUTPUT TABLE-HANDLE hRowObject9,
           OUTPUT TABLE-HANDLE hRowObject10,
           OUTPUT TABLE-HANDLE hRowObject11,
           OUTPUT TABLE-HANDLE hRowObject12,
           OUTPUT TABLE-HANDLE hRowObject13,
           OUTPUT TABLE-HANDLE hRowObject14,
           OUTPUT TABLE-HANDLE hRowObject15,
           OUTPUT TABLE-HANDLE hRowObject16,
           OUTPUT TABLE-HANDLE hRowObject17,
           OUTPUT TABLE-HANDLE hRowObject18,
           OUTPUT TABLE-HANDLE hRowObject19,
           OUTPUT TABLE-HANDLE hRowObject20).
      
    
    {get DataObjectNames cSDONames}.

    /* prepareQueriesForFetch will give error if not valid objectname */
    IF pcObject = ? THEN
       iSDONum = 1.
    ELSE 
      iSDONum = LOOKUP(pcObject, cSDONames).
    
    /* The ForeignValues passed as part of context for the table that 
       actually is changing is correct on the client, while the value 
       returned from the server is wrong */
    hMaster = {fnarg DataObjectHandle ENTRY(iSDONum,cSDONames)}.
    {get ForeignValues cForeignValues hMaster}.    
    
    /* Unbind or read data properties from appserver */
    RUN endClientDataRequest IN TARGET-PROCEDURE.

    /* Reset client values for upper table */
    {set ForeignValues cForeignValues hMaster}.

    {get ContainedDataObjects cSDOS}.
    DO iSDO = iSDONum TO NUM-ENTRIES(cSDOs):
       hSDO = WIDGET-HANDLE(ENTRY(iSDO, cSDOs)).
      /* Now reopen the RowObject query for each SDO. */
      {fnarg openDataQuery 'FIRST':U hSDO}.    
    END.  /* END DO iSDO */
    /* Now let client objects know we've got the data. */  
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE (INPUT "DIFFERENT":U).
  END.                 /* END DO IF 'Client' */
  ELSE DO:
    /* If this is just a stand-alone (non-divided) sbo, then just
       open the query in the main Data Object or run dataavailable if its
       not the master. */
    {get MasterDataObject hMaster}.
    IF pcObject <> ? THEN 
      hSDO = {fnarg DataObjectHandle pcObject} NO-ERROR. 

    IF pcObject = ? OR hSDO = hMaster THEN
      {fn openQuery hMaster} NO-ERROR.
    ELSE  
      RUN dataAvailable IN hSDO (?). /* unknown ensures foreignfield mapping */  
  END. /* not client */
  
  RUN changeCursor IN TARGET-PROCEDURE('':U).
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchContainedRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchContainedRows Procedure 
PROCEDURE fetchContainedRows :
/*------------------------------------------------------------------------------
  Purpose:     client-side procedure to get a batch of data from one 
               SDO and all tables from SDOs below in the data-link chain/tree .
               
  Parameters:  pcObject AS CHARACTER -- if specified, then fetch data sets
               from that Object down only.
               Intended for Internal use. 
               Called from clientSendRows in the contained SDO.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObject       AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER piStartRow     AS INTEGER   NO-UNDO.
  DEFINE INPUT  PARAMETER pcRowIdent     AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER plNext         AS LOGICAL   NO-UNDO.
  DEFINE INPUT  PARAMETER piRowsToReturn AS INTEGER   NO-UNDO.
  DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER   NO-UNDO.
  
  DEFINE VARIABLE cASDivision    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAllQueries    AS CHARACTER  NO-UNDO INIT "":U.
  DEFINE VARIABLE hAsHandle      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject1    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject2    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject3    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject4    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject5    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject6    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject7    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject8    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject9    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject10   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject11   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject12   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject13   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject14   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject15   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject16   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject17   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject18   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject19   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject20   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hMaster        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSDOs          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDONames      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSDO           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSDO           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iSDONum        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTTList        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignValues AS CHARACTER  NO-UNDO.

  {get ASDivision cASDivision}.
  
  IF cAsDivision <> 'client':U THEN
  DO:
    DYNAMIC-FUNCTION ('showMessage' IN TARGET-PROCEDURE,
      'fetchContainedRows should only be called on the client half of an SBO':U).
     RETURN 'ADM-ERROR':U.
  END.

  RUN changeCursor IN TARGET-PROCEDURE('WAIT':U).

  RUN prepareQueriesForFetch IN TARGET-PROCEDURE
                 (INPUT pcObject,
                  INPUT 'EmptyChildren':U, /* Empty temptables below pcObject*/
                  OUTPUT cAllQueries,
                  OUTPUT cTTList).
  
  IF RETURN-VALUE BEGINS 'ADM-ERROR':U THEN
     RETURN RETURN-VALUE.

  ASSIGN 
    hRowObject1  = WIDGET-H(ENTRY(1,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 1
    hRowObject2  = WIDGET-H(ENTRY(2,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 2
    hRowObject3  = WIDGET-H(ENTRY(3,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 3
    hRowObject4  = WIDGET-H(ENTRY(4,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 4
    hRowObject5  = WIDGET-H(ENTRY(5,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 5
    hRowObject6  = WIDGET-H(ENTRY(6,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 6
    hRowObject7  = WIDGET-H(ENTRY(7,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 7
    hRowObject8  = WIDGET-H(ENTRY(8,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 8
    hRowObject9  = WIDGET-H(ENTRY(9,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 9
    hRowObject10 = WIDGET-H(ENTRY(10,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 10
    hRowObject11 = WIDGET-H(ENTRY(11,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 11
    hRowObject12 = WIDGET-H(ENTRY(12,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 12
    hRowObject13 = WIDGET-H(ENTRY(13,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 13
    hRowObject14 = WIDGET-H(ENTRY(14,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 14
    hRowObject15 = WIDGET-H(ENTRY(15,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 15
    hRowObject16 = WIDGET-H(ENTRY(16,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 16
    hRowObject17 = WIDGET-H(ENTRY(17,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 17
    hRowObject18 = WIDGET-H(ENTRY(18,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 18
    hRowObject19 = WIDGET-H(ENTRY(19,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 19
    hRowObject20 = WIDGET-H(ENTRY(20,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 20.  

  {get ASHandle hAsHandle}.
  
  RUN serverFetchContainedRows IN hAsHandle
     (cAllQueries,
      piStartRow, 
      pcRowIdent, 
      plNext, 
      piRowsToReturn, 
      OUTPUT piRowsReturned,
      OUTPUT TABLE-HANDLE hRowObject1 APPEND, 
      OUTPUT TABLE-HANDLE hRowObject2 APPEND,
      OUTPUT TABLE-HANDLE hRowObject3 APPEND,
      OUTPUT TABLE-HANDLE hRowObject4 APPEND,
      OUTPUT TABLE-HANDLE hRowObject5 APPEND,
      OUTPUT TABLE-HANDLE hRowObject6 APPEND,
      OUTPUT TABLE-HANDLE hRowObject7 APPEND,
      OUTPUT TABLE-HANDLE hRowObject8 APPEND,
      OUTPUT TABLE-HANDLE hRowObject9 APPEND,
      OUTPUT TABLE-HANDLE hRowObject10 APPEND,
      OUTPUT TABLE-HANDLE hRowObject11 APPEND,
      OUTPUT TABLE-HANDLE hRowObject12 APPEND,
      OUTPUT TABLE-HANDLE hRowObject13 APPEND,
      OUTPUT TABLE-HANDLE hRowObject14 APPEND,
      OUTPUT TABLE-HANDLE hRowObject15 APPEND,
      OUTPUT TABLE-HANDLE hRowObject16 APPEND,
      OUTPUT TABLE-HANDLE hRowObject17 APPEND,
      OUTPUT TABLE-HANDLE hRowObject18 APPEND,
      OUTPUT TABLE-HANDLE hRowObject19 APPEND,
      OUTPUT TABLE-HANDLE hRowObject20 APPEND).
  
  {get DataObjectNames cSDONames}.

   /* prepareQueriesForFetch will give error if not valid objectname */
  IF pcObject = ? THEN
    iSDONum = 1.
  ELSE 
    iSDONum = LOOKUP(pcObject, cSDONames).

   /* The ForeignValues passed as part of context for the table that 
      actually is changing is correct on the client, while the value 
      returned from the server is wrong */
  hMaster = {fnarg DataObjectHandle ENTRY(iSDONum,cSDONames)}.
  {get ForeignValues cForeignValues hMaster}.    

  /* Unbind or read data properties from appserver */
  RUN endClientDataRequest IN TARGET-PROCEDURE.
  
  /* Reset client values for upper table */
  {set ForeignValues cForeignValues hMaster}.   

  {get ContainedDataObjects cSDOs}.
  /* prepareQueriesForFetch will give error if not valid objectname */
  DO iSDO = iSDONum TO NUM-ENTRIES(cSDOs):
    hSDO = WIDGET-HANDLE(ENTRY(iSDO, cSDOs)).
    /* Now reopen the RowObject query for each SDO. */
    {fnarg openDataQuery 'FIRST':U hSDO}.    
    IF iSDO > iSDONum THEN
      {set DataIsFetched TRUE hSDO}.
  END.  /* END DO iSDO */
  
  /* Now let client objects know we've got the data. */  
  PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE (INPUT "DIFFERENT":U).

  RUN changeCursor IN TARGET-PROCEDURE('':U).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchDOProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchDOProperties Procedure 
PROCEDURE fetchDOProperties :
/*------------------------------------------------------------------------------
  Purpose:     Retrieves any properties from the server-side SBO and its SDOs
               and sets them in the contained SDOs on the client.
  Parameters:  <none>
   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPropList   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hAppServer  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cSBOprops   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cAsDivision AS CHARACTER NO-UNDO.

  {get AsDivision cAsDivision}.
  
  IF cAsDivision = 'Client':U THEN
  DO:
    {get ASHandle hAppServer}.
    /* It's very unlikely that the handle is invalid here, as this only is 
       called during initialization, which would have given the error already.   
       so we leave the error to Progress. */
    RUN serverFetchDOProperties IN hAppServer (OUTPUT cPropList).

    DYNAMIC-FUNCTION('assignContainedProperties':U IN TARGET-PROCEDURE,
                      cPropList,
                      'QueryWhere,QueryContext':U  /* Replace */
                     ).
  END. /* Asdivision = 'client' */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchFirst) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchFirst Procedure 
PROCEDURE fetchFirst :
/*------------------------------------------------------------------------------
  Purpose:     SBO version of the event procedure to retrieve the first row
               in one of the ContainedDataObjects. It uses the ObjectMapping
               SBO property to match the caller to its Target, or uses
               the MasterDataObject by default.
  Parameters:  <none>
     Notes:    Uses the MasterDataObject by default.
------------------------------------------------------------------------------*/

    DEFINE VARIABLE hObject     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cMapping    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iObject     AS INTEGER     NO-UNDO.

    {get ObjectMapping cMapping}.
    iObject = LOOKUP(STRING(SOURCE-PROCEDURE), cMapping).
    IF iObject NE 0 THEN
        hObject = WIDGET-HANDLE(ENTRY(iObject + 1, cMapping)).
    IF NOT VALID-HANDLE(hObject) THEN
        {get MasterDataObject hObject}.
    RUN fetchFirst IN hObject.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchLast) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchLast Procedure 
PROCEDURE fetchLast :
/*------------------------------------------------------------------------------
  Purpose:     SBO version of the event procedure to retrieve the last row
               in one of the ContainedDataObjects. It uses the ObjectMapping
               SBO property to match the caller to its Target, or uses
               the MasterDataObject by default.
  Parameters:  <none>
     Notes:    Uses the MasterDataObject by default.
------------------------------------------------------------------------------*/

    DEFINE VARIABLE hObject     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cMapping    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iObject     AS INTEGER     NO-UNDO.

    {get ObjectMapping cMapping}.
    iObject = LOOKUP(STRING(SOURCE-PROCEDURE), cMapping).
    IF iObject NE 0 THEN
        hObject = WIDGET-HANDLE(ENTRY(iObject + 1, cMapping)).
    IF NOT VALID-HANDLE(hObject) THEN
        {get MasterDataObject hObject}.
    RUN fetchLast IN hObject.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchNext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchNext Procedure 
PROCEDURE fetchNext :
/*------------------------------------------------------------------------------
  Purpose:     SBO version of the event procedure to retrieve the next row
               in one of the ContainedDataObjects. It uses the ObjectMapping
               SBO property to match the caller to its Target, or uses
               the MasterDataObject by default.
  Parameters:  <none>
     Notes:    Uses the MasterDataObject by default.
------------------------------------------------------------------------------*/

    DEFINE VARIABLE hObject     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cMapping    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iObject     AS INTEGER     NO-UNDO.

    {get ObjectMapping cMapping}.
    iObject = LOOKUP(STRING(SOURCE-PROCEDURE), cMapping).
    IF iObject NE 0 THEN
        hObject = WIDGET-HANDLE(ENTRY(iObject + 1, cMapping)).
    IF NOT VALID-HANDLE(hObject) THEN
        {get MasterDataObject hObject}.
    RUN fetchNext IN hObject.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchPrev) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchPrev Procedure 
PROCEDURE fetchPrev :
/*------------------------------------------------------------------------------
  Purpose:     SBO version of the event procedure to retrieve the previous row
               in one of the ContainedDataObjects. It uses the ObjectMapping
               SBO property to match the caller to its Target, or uses
               the MasterDataObject by default.
  Parameters:  <none>
     Notes:    Uses the MasterDataObject by default.
------------------------------------------------------------------------------*/

    DEFINE VARIABLE hObject     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cMapping    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iObject     AS INTEGER     NO-UNDO.

    {get ObjectMapping cMapping}.
    iObject = LOOKUP(STRING(SOURCE-PROCEDURE), cMapping).
    IF iObject NE 0 THEN
        hObject = WIDGET-HANDLE(ENTRY(iObject + 1, cMapping)).
    IF NOT VALID-HANDLE(hObject) THEN
        {get MasterDataObject hObject}.
    RUN fetchPrev IN hObject.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContextAndDestroy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getContextAndDestroy Procedure 
PROCEDURE getContextAndDestroy :
/*------------------------------------------------------------------------------
  Purpose:     Server-side procedure run after new data has been requested by 
               the client.
  Parameters:  OUTPUT pcContaineProps - Properties of the Contained SDOs
  Notes:        
------------------------------------------------------------------------------*/
   DEFINE OUTPUT PARAMETER pcContainedProps AS CHAR NO-UNDO.
                                                                                      
                    /* We should use a property to decide which properties */
   pcContainedProps = 
       DYNAMIC-FUNCTION('containedProperties':U IN TARGET-PROCEDURE ,
       'FirstResultRow,LastResultRow,FirstRowNum,LastRowNum,QueryWhere,ForeignValues':U,
        NO). /* Deep not supported yet */

  RUN destroyObject IN TARGET-PROCEDURE.              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     SBO-specific code for initializeObject. 
  Parameters:  <none>
  Notes:       This procedure establishes the AppServer connection.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iTarget      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTarget      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cContained   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryString AS CHARACTER  NO-UNDO.

  /* NOTE: THESE ARE all the defs from data.p for the connect stuff.
     Move this to the session manager. */
  DEFINE VARIABLE cAppService      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSvrFileName     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUIBMode         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lQuery           AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hDataSource      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lOpenOnInit      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAsInitialize    AS LOGICAL    NO-UNDO.
  /* Skip all this if we're in design mode. */
  {get UIBMode cUIBMode}.
   /* NOTE: !!! THIS IS all the connect code from data.p; move this
     to the session manager. */
  /* If the object has a Partition named, then connect to it. */
  
  IF cUIBMode = "":U THEN
  DO:
    {get AppService cAppService}. 
    IF cAppService NE "":U THEN
    DO:
      /* The initialization of the server object and retrieval of start up
         properties happens in postCreateObject -> fethcDOProperties after 
         all SDO properties have been properly set, so we turn of the call to 
         initializeServerObject in runServerObject. */             
      {get ASInitializeOnRun lASInitialize}.
      {set ASInitializeOnRun FALSE}.

      RUN startServerObject IN TARGET-PROCEDURE NO-ERROR.      
      IF ERROR-STATUS:ERROR OR RETURN-VALUE = "ADM-ERROR":U THEN
         RETURN "ADM-ERROR":U.
      {set ASInitializeOnRun lASInitialize}.
    END.  /* IF AppService NE "":U */
    ELSE
    DO:
      /* If no AppService defined, check if the user is running the client
         proxy. If so, there can't be any required databases connected for
         the object to show data. Probably an AppServer setup problem. */
      IF TARGET-PROCEDURE:FILE-NAME MATCHES '*_cl.w':U OR
         TARGET-PROCEDURE:FILE-NAME MATCHES '*_cl.r':U THEN
      DO:
        cSvrFileName = REPLACE(TARGET-PROCEDURE:FILE-NAME, "_cl.w":U, ".w":U).
        IF cSvrFileName = TARGET-PROCEDURE:FILE-NAME THEN
          cSvrFileName = REPLACE(TARGET-PROCEDURE:FILE-NAME, "_cl.r":U, ".w":U).
        DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, cSvrFileName + 
        " SmartBusinessObject has no AppServer partition defined and is ":U +
        "running locally without proper database connection(s).":U).
        RETURN "ADM-ERROR":U.
      END.        /* END DO IF proxy (_cl) */
    END.          /* END ELSE DO IF AppService = "" */
  END.            /* END DO IF UIBMode ne "" */
  
  /* SDOs publishes queryPosition to the toolbar as soon as they are 
     initialized and the toolbars activeTarget check requires a non-hidden 
     object */  
  {set ObjectHidden no}.
  
  RUN SUPER.

  IF cUIBmode = '':U THEN
  DO:
    {get OpenOnInit lOpenOnInit}.
    IF lOpenOnInit THEN
    DO:
      {get DataSource hDataSource}.
      IF VALID-HANDLE(hDataSource) THEN
        RUN dataAvailable IN TARGET-PROCEDURE ('initialize':U).
      ELSE
        {fn openQuery}.
    END. /* openOnInit */
    RUN unbindServer IN TARGET-PROCEDURE ('unconditionally':U).
  END. /* if cuibmode = ''  */

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeServerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeServerObject Procedure 
PROCEDURE initializeServerObject :
/*------------------------------------------------------------------------------
  Purpose:   Set context and initialize the server object   
  Parameters:  <none>
  Notes:    This procedure is not considered to be part of the public API. It 
            is part of the start of the server object called from: 
           (bindServer ->) getAsHandle -> restartServerObject -> runServerObject.
             
           - ASInitializeOnRun is set to false to avoid calling this from 
             startServerObject -> runServerObject.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hAsHandle AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lASBound  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cContext  AS CHARACTER NO-UNDO.
 
  {get ASBound lASBound}.
  IF lASBound THEN
  DO:
    {get AsHandle hAsHandle}.

    cContext = DYNAMIC-FUNCTION('containedProperties':U IN TARGET-PROCEDURE,
              'QueryWhere,CheckCurrentChanged,FirstResultRow,LastResultRow,':U
               +
       /* currently we pass these, otherwise they will be returned 
         as unknown from objects that doesn't set them  */
              'FirstRowNum,LastRowNum,ForeignValues':U                                   ,
               NO). /* Deep is not supported yet */ 
    RUN setContextAndInitialize IN hAsHandle(cContext).
  END. /* if bound */

  RETURN. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isUpdatePending) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE isUpdatePending Procedure 
PROCEDURE isUpdatePending :
/*------------------------------------------------------------------------------
  Purpose:  Published through data-targets to check if any updates are pending.
            This SBO version of the event turns around and RUNS it in 
            the SDO to which the caller is mapped. 
            If no pending updates found it publishes isUpdatePending 
            to its targets     
  Parameters: input-output plUpdate 
              Returns TRUE and stops the publishing if update is pending. 
  Notes:      New is included as a pending update. 
              Called from canNavigate, which is used by navigating objects to 
              check if they can trust an updateState('updatecomplete') message 
------------------------------------------------------------------------------*/
 DEFINE INPUT-OUTPUT PARAMETER plUpdate AS LOGICAL    NO-UNDO.
  
 DEFINE VARIABLE cMapping     AS CHAR    NO-UNDO.
 DEFINE VARIABLE iObject      AS INT     NO-UNDO.
 DEFINE VARIABLE hObject      AS HANDLE  NO-UNDO.
 
 IF NOT plUpdate THEN
 DO:
   {get ObjectMapping cMapping}.
   iObject = LOOKUP(STRING(SOURCE-PROCEDURE), cMapping).
   IF iObject = 0 THEN
     {get MasterDataObject hObject} NO-ERROR.
  
   ELSE hObject = WIDGET-HANDLE(ENTRY(iObject + 1, cMapping)).
  
   /* This will check the mapped object, which will publish the event to all
      of its data-targets inside of the SBO */
   IF VALID-HANDLE(hObject) THEN
     RUN 'isUpdatePending':U IN hObject (INPUT-OUTPUT plUpdate).

   /* Check data-targets states */
   IF NOT plUpdate THEN 
     PUBLISH 'isUpdatePending':U FROM TARGET-PROCEDURE (INPUT-OUTPUT plUpdate).
 END. /* not plUpdate */
 
 RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-postCreateObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE postCreateObjects Procedure 
PROCEDURE postCreateObjects :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is run at the end of createObjects, after all
               contained Objects have been created (but not initialized).
               It sets various properties that are dependent on knowing
               the handles and Instance Properties of all contained objects,
               and also fetches property settings from the server-side SBO.
  Parameters:  <none>
  Notes:       This is a new "hook" as of 9.1B, run from createObjects
               after adm-create-objects.
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE cTargets          AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iTarget           AS INTEGER     NO-UNDO.
  DEFINE VARIABLE hTarget           AS HANDLE      NO-UNDO.
  DEFINE VARIABLE lQuery            AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE cDataColumns      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cContainedColumns AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cContainedObjects AS CHARACTER   NO-UNDO INIT "":U.
  DEFINE VARIABLE cObjectName       AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cDONames          AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cSBODataColumns   AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iColumn           AS INTEGER     NO-UNDO.
  DEFINE VARIABLE hSource           AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hMDO              AS HANDLE      NO-UNDO.
  DEFINE VARIABLE cQueryString      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cDOName           AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iEntry            AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cSourceList       AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cOrdering         AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cTables           AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cObjectType       AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iDO               AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cAsDivision       AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE lOpenOnInit       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAsBound          AS LOGICAL     NO-UNDO.
  /* Find the SDO with no Data-Source; this is considered the "Master". 
     If there's more than one then the SDOs are independent and there
     is no master, so we set the property to null. At the same time,
     turn off the AppService in each SDO, so they do not attempt to
     connect to the AppServer on their own, and get them to create the
     dynamic objects needed to receive data through the SBO. 
     The DataObjectNames property is an instance property, so this will
     be set in the preferred Object order. Set ContainedDataObjects
     and the Columns property in the same order.
     Also build a master list of all ContainedDataColumns from all SDOs. 
     Also build the DataColumns variant of this list, which is one
     list of qualified column names.
     Also build a list of the contained objects' handles. 
     Also subscribe to the dataAvailable event. */

  {get ContainerTarget cTargets}.
  {get DataObjectNames cDONames}.   /* This is the Instance Property */
  /* if it's been explicitly set, then build the list of handles in the
     same order; the master is the first SDO in the list. */
  IF cDONames NE "":U THEN
  DO:
    DO iEntry = 1 TO NUM-ENTRIES(cDONames):
      cDOName = ENTRY(iEntry, cDONames).
        /* Locate the ObjectName among the Container-Targets */
      DO iTarget = 1 TO NUM-ENTRIES(cTargets):
         hTarget = WIDGET-HANDLE(ENTRY(iTarget, cTargets)).
         {get ObjectName cObjectName hTarget}.
         IF cObjectName = cDOName THEN
           LEAVE.
      END.    /* END DO iTarget -- searching for ObjectName match */          
      IF iEntry = 1 THEN
        {set MasterDataObject hTarget}.
      cContainedObjects = cContainedObjects 
                        + (IF cContainedObjects = "":U THEN "":U ELSE ",":U) 
                        + STRING(hTarget).
    END.  /* END DO iEntry */
  END.   /* END DO if cDONames set */
  ELSE DO:
    /* If the property hasn't been set yet, build the list starting
        with the Master. */
    {get ContainerTarget cTargets}.
    DO iTarget = 1 TO NUM-ENTRIES(cTargets):
        hTarget = WIDGET-HANDLE(ENTRY(iTarget, cTargets)).
        {get QueryObject lQuery hTarget} NO-ERROR.
        IF lQuery THEN
          /* QueryObject is considered the definition of an SDO. */
        DO:
          /* First locate the 'master' -- with no Data-Source. */
          {get DataSource hSource hTarget}.
          IF hSource = ? THEN       /* This one has no Data-Source. */
          DO:
            hMDO = hTarget.   /*   hang on to that handle. */ 
            {set MasterDataObject hMDO}.
            LEAVE.
          END.      /* END DO IF no hSource */
        END.        /* END DO IF lQuery */
    END.          /* END DO iTarget -- initial search for Master DO */

      /* Now start with the Master DataObject and built a list of its 
         DataTargets, recursing as necessary. */
    IF VALID-HANDLE(hMDO) THEN     /* Could be ? if no SDOs at all */
          appendContainedObjects(INPUT-OUTPUT cContainedObjects, INPUT hMDO).   

      /* Now search for any "orphan" SDOs with no connection to the others. 
         NOTE: This currently presumes that the first one found with no
         Data-Source is the proper Master. */
    DO iTarget = 1 TO NUM-ENTRIES(cTargets):
          hTarget = WIDGET-HANDLE(ENTRY(iTarget, cTargets)).
          {get QueryObject lQuery hTarget} NO-ERROR.
          IF lQuery AND LOOKUP(STRING(hTarget), cContainedObjects) = 0 THEN
              appendContainedObjects(INPUT-OUTPUT cContainedObjects, 
                                     INPUT hTarget).
    END.        /* END DO iTarget -- re-search ContainerTargets */
      /* Now build the list of ObjectNames of the SDOs, in the same order
         as ContainedObjects. */
    DO iTarget = 1 TO NUM-ENTRIES(cContainedObjects):
          hTarget = WIDGET-HANDLE(ENTRY(iTarget, cContainedObjects)).
          {get ObjectName cDOName hTarget}.
          cDONames = cDONames + 
              (IF cDONames = "":U THEN "":U ELSE ",":U) + cDOName.
    END.       /* END DO iTarget == each contained object */
    {set DataObjectNames cDONames}.
  END.           /* END ELSE DO If ObjectNames not yet set. */
 
  /* Subscribe the SBO to all SDO events that are intended for objects linked
     to the SBO. 
     Also ensure that AppServer properties are correct */    
  {get AsDivision cAsDivision}.
  {get OpenOnInit lOpenOnInit}.
  DO iTarget = 1 TO NUM-ENTRIES(cContainedObjects):
      cObjectName = ENTRY(iTarget, cDONames).
      hTarget = WIDGET-HANDLE(ENTRY(iTarget, cContainedObjects)).
      cDataColumns = DYNAMIC-FUNCTION('getDataColumns':U IN hTarget).
      cContainedColumns = cContainedColumns +
        (IF cContainedColumns NE "":U THEN ";":U ELSE "":U) +
           cDataColumns.
      /* This is the form of the column list with SDO Name qualifiers. */
      DO iColumn = 1 TO NUM-ENTRIES(cDataColumns):
          cSBODataColumns = cSBODataColumns + 
              (IF cSBODataColumns NE "":U THEN ",":U ELSE "":U) +
               cObjectName + ".":U + ENTRY(iColumn, cDataColumns).
      END.         /* END DO iColumn */
      
      {set OpenOnInit lOpenOnInit hTarget}.  

       /* No AppService for contained SDOs */
      {set AppService '' hTarget}.  
      /* The logic in data.i that sets 'server' when source-procedure = ? is 
         not correct when the SDOs are started from this SBO object, so we copy 
         AsDivision to the SDOs. */
      {set AsDivision cAsDivision hTarget}.       
      /* SDOs in SBOs don't commit themselves in any case, so set their
         AutoCommit property to false. */ 
      {set AutoCommit FALSE hTarget}.       
      SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'dataAvailable':U IN hTarget.
      SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'queryPosition':U IN hTarget.
      SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'updateState':U IN hTarget.
      SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'assignMaxGuess':U IN hTarget.
      SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'deleteComplete':U IN hTarget.
      SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'cancelNew':U IN hTarget.
  END.  /* END DO iTarget */

  /* Set the SBO's property based on whether there's a CommitSource, 
     just as an SDO would do.  */
  {get CommitSource hSource}.
  IF hSource = ? THEN
    {set AutoCommit TRUE}.   /* It's false by default in the SBO. */

  {set ContainedDataObjects cContainedObjects}.
  {set ContainedDataColumns cContainedColumns}.
  {set DataColumns cSBODataColumns}.

  /* If running on AS, we must initialize serverobjects and retrieve properties 
     from it and its SDOs, this must happen after all the Contained* props have
     been set above, but preferably before the client SDOs are initialized. */ 
  {get AsBound lAsBound}.
  IF lAsBound THEN
    RUN fetchDOProperties IN TARGET-PROCEDURE.

  /* This maps the AppBuilder-generated Update Table order to the 
     DataObjectNames order. The code is in sbo.i but can't be run until now. */
  cOrdering = DYNAMIC-FUNCTION ('initDataObjectOrdering':U IN TARGET-PROCEDURE).
  {set DataObjectOrdering cOrdering}.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareErrorsForReturn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prepareErrorsForReturn Procedure 
PROCEDURE prepareErrorsForReturn :
/*------------------------------------------------------------------------------
  Purpose:  This appends the RETURN-VALUE from the user-defined transaction
            validation procedure or other update-related error to the list
            of any errors already in the log, and formats this string to
            prepare for returning it to the client.
    Notes:  invoked internally from serverCommitTransaction.
------------------------------------------------------------------------------*/
 DEFINE INPUT        PARAMETER pcReturnValue AS CHARACTER NO-UNDO.
 DEFINE INPUT        PARAMETER pcASDivision  AS CHARACTER NO-UNDO.
 DEFINE INPUT-OUTPUT PARAMETER pcMessages    AS CHARACTER NO-UNDO.  
 
  IF pcReturnValue NE "":U THEN
    RUN addMessage IN TARGET-PROCEDURE (pcReturnValue, ?, ?).
  IF pcASDivision = 'Server':U THEN
     pcMessages = LEFT-TRIM(pcMessages + CHR(3) + 
         DYNAMIC-FUNCTION ('fetchMessages' IN TARGET-PROCEDURE),CHR(3)).
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareQueriesForFetch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prepareQueriesForFetch Procedure 
PROCEDURE prepareQueriesForFetch :
/*------------------------------------------------------------------------------
   Purpose: Prepare the Queries in the SDOs for a fetch of data form the 
            server.   
Parameters: 
    INPUT pcObjectName 
           - ?           Retrieve data from all SDOs.  
           - ObjectName  Start on this object. (in ContainedDataObject order).
    INPUT pcOptions 
           - 'EmptyChildren' - Empty temp-table in objects below pcObjectName 
                   
    OUTPUT pocQueries 
            A CHR(1) separated string with Query expressions to pass to the 
            server when fetching temp-table handles.
            SKIP is returned as the entry for all SDOs that are before the 
            object indicated by pcObjectName (in ContainedDataObjects order).            
            A SKIP tells the serverFetch* methods not to return any data while 
            a blank entry indicates that the server shall use the default query. 
    OUTPUT pocTempTables 
            A list of temp-table handles. '?' for objects that are not part 
            of the fetch we are preparing for.  
    Notes:  This procedure exists in order to have common logic for 
            fetchContainedData and fetchContainedRows. This logic is a bit 
            complex and are also very likely to change. 
         -  Cannot be used across sessions as the temp-table handles are 
            concatinated in a list.             
            Tests indicates that it is faster to add all the handles 
            to a list than having a procedure with 20 output parameters for 
            the temp-table handles.   
         -  A manually changed setQueryWhere is always used. This may have 
            very weird results if done for a new batch, but if we should deal 
            with this we would need yet another query property to store the 
            query to use in batching. 
            It is considered to be a user error to setQueryWhere without an 
            immediate openQuery, if the object is batched. 
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectName  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcOptions     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pocQueries    AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER poctempTables AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cDataObjectHandles AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iSDONum            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cSDONames          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSDO               AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hSDO               AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cQuery             AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOpenQuery         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cQueryWhere        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lSubOrdinate       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hTempTable         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hrowObject         AS HANDLE    NO-UNDO.

  IF pcObjectName NE "":U AND pcObjectName NE ? THEN
  DO:
    {get DataObjectNames cSDONames}.
    iSDONum = LOOKUP(pcObjectName, cSDONames).
    IF iSDONum = 0 THEN
    DO:
      DYNAMIC-FUNCTION ('showMessage' IN TARGET-PROCEDURE,
        'Unknown Object Name ~'' 
        + pcObjectName 
        + '~'passed to prepareQueriesforFetch':U).
       RETURN "ADM-ERROR":U.
    END.
  END.     /* END DO IF pcObject specified. */
  ELSE iSDONum = 1.  /* Signal to start at the top. */

  /* Get the handles of the dynamic temp-tables from the SDOs. */
  {get ContainedDataObjects cDataObjectHandles}.

  DO iSDO = 1 TO NUM-ENTRIES(cDataObjectHandles):
    /* If the caller requested to start at a specific SDO, then set
       all prior handles to ? and signal not to use them. */
    IF iSDONum > iSDO THEN
      ASSIGN
        hTempTable = ?
        cQuery     = "SKIP":U.

    ELSE DO:
      
      hSDO = WIDGET-HANDLE(ENTRY(iSDO, cDataObjectHandles)).      
      {get RowObjectTable hTempTable hSDO}.
      {get QueryString cQuery hSDO}.      
      
      /* EmptyChildren means empty temp-table if below SdoNum */
      IF pcOptions = 'EmptyChildren':U 
      AND iSDO > iSDONum THEN 
      DO:
        {get RowObject hRowObject hSDO}.
        IF VALID-HANDLE(hRowObject) THEN
          hRowObject:EMPTY-TEMP-TABLE(). 
      END. /* pcOptions = EmptyChildren */


      IF cQuery = '':U THEN
      DO:
        /* A blank QueryString may indicate that QueryWhere has been set.
           The QueryWhere is stored on the client (also for state-aware objects),
           so we must ensure that it is sent to server if it has been set.*/
        {get OpenQuery  cOpenQuery hSDO}. 
        {get QueryWhere cQueryWhere hSDO}.
        /* We only need this if QueryWhere is <> default since a blank entry 
           tells the server to use default anyway */
        IF cOpenQuery <> cQueryWhere THEN 
          cQuery = cQueryWhere. 
      END. /* Blank querystring */
      ELSE IF iSDO = iSDONum THEN 
      DO:
      /* If this is called from fetchContainedRows the ForeignFields for the 
         SDO that is 'batched' may not yet have been set on the client, in which 
         case we use the QueryWhere, which returns the complete query returned 
         from the server. Since the QueryString currently is set from the 
         default query to avoid problems with FFs returned from server, we just 
         compare them to see if this is the case. */ 
        {get OpenQuery cOpenQuery hSDO}.
        IF cOpenQuery = cQuery THEN
          {get QueryWhere cQuery hSDO}.   
      END. /* iSDO = iSDONum */

      /* The QueryString Foreign Fields criteria are removed for every SDO 
         that are 'below' the one we are requesting, as these SDOs will 
         apply Foreign Fields on the server.  
         (We cannot trust that dataAvailable will replace the FF as the 
          positional info about criteria in QueryString is stored 
         in QueryColumns, and the server's QueryColumns may not match.) */
      ELSE
      DO: 
        {fn removeForeignKey hSDO}.
           /* Reread the queryString after removal of Foreign Field */
        {get QueryString cQuery hSDO}.
      END. /* Do for each subordinate query */
    END.  /* if this isn't a "SKIP" query */
    ASSIGN
      pocQueries    = pocQueries 
                      + (IF iSDO > 1 THEN CHR(1) ELSE "":U) 
                      + cQuery
      pocTempTables = pocTempTables 
                      + (IF iSDO > 1 THEN ",":U ELSE "":U) 
                      + (IF VALID-HANDLE(hTempTable)
                         THEN STRING(hTempTable)
                         ELSE '?':U).
  END. /* do iSDO = 1 to  */

  RETURN. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-queryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE queryPosition Procedure 
PROCEDURE queryPosition :
/*------------------------------------------------------------------------------
  Purpose:    Receives the queryPosition event from a contained SDO and
              passes it on to the appropriate Navigation-Source or other
              object.
  Parameters: pcPosition AS CHARACTER
  Notes:      Sets the ghTargetProcedure so that the toolbar can recognize the 
              actual target instance .
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pcPosition AS CHAR   NO-UNDO.

   DEFINE VARIABLE cMapping      AS CHAR      NO-UNDO.
   DEFINE VARIABLE hObject       AS HANDLE    NO-UNDO.
   DEFINE VARIABLE iObject       AS INT       NO-UNDO.
   DEFINE VARIABLE cHandle       AS CHAR      NO-UNDO.
   DEFINE VARIABLE cSDONames     AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cSourceName   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cSubscribed   AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE hNavTarget    AS HANDLE     NO-UNDO.
   DEFINE VARIABLE hDataSource   AS HANDLE     NO-UNDO.
   
   {get ObjectMapping cMapping}.
              /* may be more than one match */
   cHandle = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE, 
                  INPUT STRING(SOURCE-PROCEDURE),
                   INPUT cMapping,
                   INPUT FALSE,           /* Get entry/entries *before* this */
                   INPUT ",":U).          /* delimiter */
    DO iObject = 1 TO NUM-ENTRIES(cHandle): 
     hObject = WIDGET-HANDLE(ENTRY(iObject, cHandle)).
     IF VALID-HANDLE(hObject) THEN
     DO:
       /* We check what kind of link we have to this object and if the object 
          subscribes to this event from that link */ 
       ASSIGN
         hNavTarget  = ?
         hDataSource = ?
         cSubscribed = ''.

       {get NavigationTarget hNavTarget hObject} NO-ERROR.
       IF VALID-HANDLE(hNavTarget) THEN 
       DO: 
          IF hNavTarget = TARGET-PROCEDURE THEN
            {get NavigationTargetEvents cSubscribed hObject}.
       END.
       ELSE DO:
          {get DataSource hdataSource hObject} NO-ERROR.
          IF VALID-HANDLE(hDataSource) AND hDataSource = TARGET-PROCEDURE THEN 
            {get DataSourceEvents cSubscribed hObject}.
       END.

       IF CAN-DO(cSubscribed,'queryPosition':U) THEN
       DO:
         cSDONames = '':U.
        /* Currently we avoid passing QueryPosition to secondary or 
            not updatable tables in visual objects. Note that in the future 
            this will probably be dealt with in the visual object */       
         {get UpdateTargetNames cSDONames hObject} NO-ERROR.
         IF cSDONames = ? OR cSDONames = '':U THEN
           {get DataSourceNames cSDONames hObject} NO-ERROR.

         IF cSDONames <> ? AND cSDONames <> '':U THEN
         DO:
           {get ObjectName cSourceName SOURCE-PROCEDURE}.
         
           IF cSourceName <> ENTRY(1,cSDONames) THEN
             NEXT. /* deal with the next visual object */ 
         END. /* cSDONames <> ? or <> ''  */
         ghTargetProcedure = TARGET-PROCEDURE.
         RUN queryPosition IN hObject (pcPosition) NO-ERROR.
         ghTargetProcedure = ?. 
       END. /* lookup DataSourceEvents,queryposition */
     END.
   END.    /* END DO iObject */

   RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-registerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE registerObject Procedure 
PROCEDURE registerObject :
/*------------------------------------------------------------------------------
  Purpose: General purpose 'register' event published from objects at 
           initialization. This object defines this as navigationSourceEvent 
           and dataTargetEvent. The event is used to register objects in the 
           ObjectMapping and other properties. 
          (Currently we assume that updateSources also are DataTargets)
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSource AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTarget AS CHARACTER NO-UNDO.
 
  {get NavigationSource cSource}.
   
  /* If this is a NavigationSource add it as such */
  IF CAN-DO(cSource,STRING(SOURCE-PROCEDURE)) THEN
     RUN addNavigationSource IN TARGET-PROCEDURE (SOURCE-PROCEDURE).
  ELSE DO:
    /* The other current possibility is that this is a Datatarget
       if that's the case then add DataTarget 
        (which also registers updateSources ) */
    {get DataTarget cTarget}.
    IF CAN-DO(cTarget,STRING(SOURCE-PROCEDURE)) THEN
      RUN addDataTarget IN TARGET-PROCEDURE (SOURCE-PROCEDURE).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-restartServerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE restartServerObject Procedure 
PROCEDURE restartServerObject :
/*------------------------------------------------------------------------------
  Purpose:    When a SmartBusinessObject is split and running Statelessly on an
              AppServer, it is shutdown after each use and then restarted for
              the next.  restartServerObject is run on the client to restart
              the SmartBusinessObject on the server. 
  Notes:      This override is for error handling to show error message and
              return 'adm-error'. 
------------------------------------------------------------------------------*/ 
    DEFINE VARIABLE cMsg AS CHARACTER  NO-UNDO.
  
  RUN SUPER NO-ERROR.
  
 /* Handles only one message, which is sufficent with the current appserver 
    class */
  IF {fn anyMessage} THEN
  DO:
     cMsg = ENTRY(1,{fn fetchMessages},CHR(4)).
    {fnarg showMessage cMsg}.
    RETURN ERROR 'ADM-ERROR':U.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-serverContainedSendRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverContainedSendRows Procedure 
PROCEDURE serverContainedSendRows :
/*------------------------------------------------------------------------------
  Purpose:     Server-side SBO version of serverSendRows.
               Receives the SDO Object Name and runs SendRows in that,
               returning the RowObject table.
                              
   Parameters:  
    INPUT  piStartRow     - The RowNum value of the record to start the batch
                            to return.  Typically piStartRow is ? as a flag to 
                            use pcRowIdent instead of piStartRow.
    INPUT  pcRowIdent     - The RowIdent of the first record of the batch to
                            to return.  Can also be "FIRST" or "LAST" to force
                            the retrieval of the first (or last) batch of 
                            RowObject records.
    INPUT  plNext         - True if serverSendRows is to start on the "next"
                            record from what is indicated by piStartRow or
                            piRowIdent.
    INPUT  piRowsToReturn - The number of rows in a batch.
    INPUT  pcObjectName   - the ObjectName of the SDO to get data from.
    OUTPUT piRowsReturned - The actual number of rows returned. This number
                            will either be the same as piRowsToReturn or
                            less when there are not enough records to fill
                            up the batch.
    OUTPUT TABLE-HANDLE   - The batch of rows in the RowObject table.
  
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER piStartRow     AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcRowIdent     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plNext         AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER piRowsToReturn AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcObjectName   AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER    NO-UNDO.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject.
 
  DEFINE VARIABLE cContained  AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iObject     AS INTEGER     NO-UNDO.
  DEFINE VARIABLE hObject     AS HANDLE      NO-UNDO.
  DEFINE VARIABLE cObjectName AS CHARACTER   NO-UNDO.
  
  {get ContainedDataObjects cContained}.
  DO iObject = 1 TO NUM-ENTRIES(cContained):
      hObject = WIDGET-HANDLE(ENTRY(iObject, cContained)).
      {get ObjectName cObjectName hObject}.
      IF cObjectName = pcObjectName THEN
      DO:
          /* sendRows will populate the temp-table, and we can get its
             handle directly afterwards, so we can just call sendRows
             directly and *then* get the table as a simple handle. */
          RUN sendRows IN hObject
              (INPUT piStartRow, INPUT pcRowIdent,
               INPUT plNext, INPUT piRowsToReturn,
               OUTPUT piRowsReturned).
          {get RowObjectTable phRowObject hObject}.
      END.
  END.               /* END DO iObject -- match ObjectNames */
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-serverFetchContainedData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverFetchContainedData Procedure 
PROCEDURE serverFetchContainedData :
/*------------------------------------------------------------------------------
  Purpose:     server-side procedure to prepare and open a query
               and return all the resulting data to the client side.
  Parameters:  pcQueries AS CHARACTER -- CHR(1)-delimited-list of 
                  QueryString properties of the SDOs;
               pcPositions AS CHARACTER -- reserved for future use to
                  provide information on positioning each of the queries;
               phRowObject1-20 AS HANDLE -- temp-table handle of each SDO
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcQueries   AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pcPositions AS CHARACTER NO-UNDO.

  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject1.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject2.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject3.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject4.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject5.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject6.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject7.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject8.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject9.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject10.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject11.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject12.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject13.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject14.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject15.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject16.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject17.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject18.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject19.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject20.

  DEFINE VARIABLE hMaster      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSDOs        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryString AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPosition    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRelative    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSDO         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSDO         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iStartSDO    AS INTEGER    NO-UNDO INIT 0.
  
  /* First set the QueryString property of any SDO that has one. */
  {get ContainedDataObjects cSDOs}.
  
  DO iSDO = 1 TO NUM-ENTRIES(cSDOs):
    cQueryString = ENTRY(iSDO, pcQueries, CHR(1)).
    IF cQueryString NE "SKIP":U THEN
    DO:
      hSDO = WIDGET-HANDLE(ENTRY(iSDO, cSDOs)).
          /* If no data is passed from the client we must use the default query            
            otherwise Foreign Fields will be appended to the current query,
            which may have conflicting Foreign Fields from initialization */  
      IF cQueryString = '':U THEN 
        {get OpenQuery cQueryString hSdo}.
        
      {set QueryWhere cQueryString hSDO}.

    END.    /* END DO IF QueryString ne "SKIP" */
    ELSE IF cQueryString = "SKIP":U THEN
       iStartSDO = iSDO + 1.
  END. /* END DO iSDO */

  /* Locate the "master" SDO; open its query to get things rolling, unless 
     one or more of the queryStrings are "skip", which signals that the open
     should occur further down the chain. */
  IF iStartSDO NE 0 THEN 
    hMaster = WIDGET-HANDLE(ENTRY(iStartSDO, cSDOs)).
  ELSE 
    {get MasterDataObject hMaster}.
  
  {fn openQuery hMaster}.
  
  DO iSDO = 1 TO NUM-ENTRIES(cSDOs):
      hSDO = WIDGET-HANDLE(ENTRY(iSDO, cSDOs)).
      CASE iSDO:
          WHEN 1 THEN
              IF iStartSDO <= 1 THEN
             {get RowObjectTable phRowObject1 hSDO}.
          WHEN 2 THEN
              IF iStartSDO <= 2 THEN
             {get RowObjectTable phRowObject2 hSDO}.
          WHEN 3 THEN
              IF iStartSDO <= 3 THEN
             {get RowObjectTable phRowObject3 hSDO}.
          WHEN 4 THEN
              IF iStartSDO <= 4 THEN
             {get RowObjectTable phRowObject4 hSDO}.
          WHEN 5 THEN
              IF iStartSDO <= 5 THEN
             {get RowObjectTable phRowObject5 hSDO}.
          WHEN 6 THEN
              IF iStartSDO <= 6 THEN
             {get RowObjectTable phRowObject6 hSDO}.
          WHEN 7 THEN
              IF iStartSDO <= 7 THEN
             {get RowObjectTable phRowObject7 hSDO}.
          WHEN 8 THEN
              IF iStartSDO <= 8 THEN
             {get RowObjectTable phRowObject8 hSDO}.
          WHEN 9 THEN
              IF iStartSDO <= 9 THEN
             {get RowObjectTable phRowObject9 hSDO}.
          WHEN 10 THEN
              IF iStartSDO <= 10 THEN
             {get RowObjectTable phRowObject10 hSDO}.
          WHEN 11 THEN
              IF iStartSDO <= 11 THEN
             {get RowObjectTable phRowObject11 hSDO}.
          WHEN 12 THEN
              IF iStartSDO <= 12 THEN
             {get RowObjectTable phRowObject12 hSDO}.
          WHEN 13 THEN
              IF iStartSDO <= 13 THEN
             {get RowObjectTable phRowObject13 hSDO}.
          WHEN 14 THEN
              IF iStartSDO <= 14 THEN
             {get RowObjectTable phRowObject14 hSDO}.
          WHEN 15 THEN
              IF iStartSDO <= 15 THEN
             {get RowObjectTable phRowObject15 hSDO}.
          WHEN 16 THEN
              IF iStartSDO <= 16 THEN
             {get RowObjectTable phRowObject16 hSDO}.
          WHEN 17 THEN
              IF iStartSDO <= 17 THEN
             {get RowObjectTable phRowObject17 hSDO}.
          WHEN 18 THEN
              IF iStartSDO <= 18 THEN
             {get RowObjectTable phRowObject18 hSDO}.
          WHEN 19 THEN
              IF iStartSDO <= 19 THEN
             {get RowObjectTable phRowObject19 hSDO}.
          WHEN 20 THEN
              IF iStartSDO <= 20 THEN
             {get RowObjectTable phRowObject20 hSDO}.
      END CASE.    
  END.             /* END DO iSDO */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-serverFetchContainedRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverFetchContainedRows Procedure 
PROCEDURE serverFetchContainedRows :
/*------------------------------------------------------------------------------
  Purpose:     server-side procedure that retrieves a batch of data 
               in one of the contained SDOs and returns all the resulting 
               data to the client side.
  Parameters:  
    INPUT  pcQueries     -  CHR(1)-delimited-list of QueryString properties of 
                            the SDOs. SKIP indicates 
    INPUT  pcObject      -  The object to retrieve the batch from (? = Master)      
    INPUT  piStartRow    -  The RowNum value of the record to start the batch
                            to return.  Typically piStartRow is ? as a flag to 
                            use pcRowIdent instead of piStartRow.
    INPUT  pcRowIdent     - The RowIdent of the first record of the batch to
                            to return.  Can also be "FIRST" or "LAST" to force
                            the retrieval of the first (or last) batch of 
                            RowObject records.
    INPUT  plNext         - True if serverSendRows is to start on the "next"
                            record from what is indicated by piStartRow or
                            piRowIdent.
    INPUT  piRowsToReturn - The number of rows in a batch.
    OUTPUT piRowsReturned - The actual number of rows returned. This number
                            will either be the same as piRowsToReturn or
                            less when there are not enough records to fill
                            up the batch.
    
    OUTPUT TABLE-HANDLE phRowObject1-20 AS HANDLE 
                           - temp-table handle of each SDO
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcQueries      AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER piStartRow     AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pcRowIdent     AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER plNext         AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER piRowsToReturn AS INTEGER   NO-UNDO.
  DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER   NO-UNDO.

  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject1.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject2.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject3.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject4.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject5.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject6.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject7.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject8.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject9.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject10.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject11.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject12.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject13.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject14.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject15.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject16.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject17.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject18.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject19.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject20.

  DEFINE VARIABLE hMaster      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSDOs        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryString AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPosition    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRelative    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSDO         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSDO         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iStartSDO    AS INTEGER    NO-UNDO INIT 0.
  DEFINE VARIABLE hDataQuery   AS HANDLE     NO-UNDO.
  /* First set the QueryString property of any SDO that has one. */
  {get ContainedDataObjects cSDOs}.
  
  DO iSDO = 1 TO NUM-ENTRIES(cSDOs):
    cQueryString = ENTRY(iSDO, pcQueries, CHR(1)).
    IF cQueryString NE "SKIP":U THEN
    DO:
      hSDO = WIDGET-HANDLE(ENTRY(iSDO, cSDOs)).
      /* If no data is passed from the client we use the context query            
         otherwise Foreign Fields will be appended to the current query,
         which may have conflicting Foreign Fields from initialization */  
      IF cQueryString = '':U THEN 
        {get OpenQuery cQueryString hSdo}.
        
      {set QueryWhere cQueryString hSDO}.

    END.    /* END DO IF QueryString ne "SKIP" */
    ELSE IF cQueryString = "SKIP":U THEN
       iStartSDO = iSDO + 1.
  END. /* END DO iSDO */

  /* Locate the "master" SDO; run sendRows, unless one or more of the 
     queryStrings are "skip", which signals that the sendRows should 
      occur further down the chain. */
  IF iStartSDO NE 0 THEN 
    hMaster = WIDGET-HANDLE(ENTRY(iStartSDO, cSDOs)).
  ELSE 
    {get MasterDataObject hMaster}.

  RUN sendRows IN hMaster 
      (piStartRow,
       pcRowIdent,
       plNext,
       piRowsToReturn,
       OUTPUT piRowsReturned).
  
  {get DataHandle hDataQuery hMaster}.
  IF VALID-HANDLE(hDataQuery) THEN
  DO:
   {get DataQueryString cQueryString hMaster}.
    hDataQuery:QUERY-PREPARE(cQueryString) .
    hDataQuery:QUERY-OPEN().
    hDataQuery:GET-FIRST().
  END.
   
  PUBLISH 'dataAvailable':U FROM hMaster ('different':U). 
  DO iSDO = 1 TO NUM-ENTRIES(cSDOs):
      hSDO = WIDGET-HANDLE(ENTRY(iSDO, cSDOs)).
      CASE iSDO:
          WHEN 1 THEN
              IF iStartSDO <= 1 THEN
             {get RowObjectTable phRowObject1 hSDO}.
          WHEN 2 THEN
              IF iStartSDO <= 2 THEN
             {get RowObjectTable phRowObject2 hSDO}.
          WHEN 3 THEN
              IF iStartSDO <= 3 THEN
             {get RowObjectTable phRowObject3 hSDO}.
          WHEN 4 THEN
              IF iStartSDO <= 4 THEN
             {get RowObjectTable phRowObject4 hSDO}.
          WHEN 5 THEN
              IF iStartSDO <= 5 THEN
             {get RowObjectTable phRowObject5 hSDO}.
          WHEN 6 THEN
              IF iStartSDO <= 6 THEN
             {get RowObjectTable phRowObject6 hSDO}.
          WHEN 7 THEN
              IF iStartSDO <= 7 THEN
             {get RowObjectTable phRowObject7 hSDO}.
          WHEN 8 THEN
              IF iStartSDO <= 8 THEN
             {get RowObjectTable phRowObject8 hSDO}.
          WHEN 9 THEN
              IF iStartSDO <= 9 THEN
             {get RowObjectTable phRowObject9 hSDO}.
          WHEN 10 THEN
              IF iStartSDO <= 10 THEN
             {get RowObjectTable phRowObject10 hSDO}.
          WHEN 11 THEN
              IF iStartSDO <= 11 THEN
             {get RowObjectTable phRowObject11 hSDO}.
          WHEN 12 THEN
              IF iStartSDO <= 12 THEN
             {get RowObjectTable phRowObject12 hSDO}.
          WHEN 13 THEN
              IF iStartSDO <= 13 THEN
             {get RowObjectTable phRowObject13 hSDO}.
          WHEN 14 THEN
              IF iStartSDO <= 14 THEN
             {get RowObjectTable phRowObject14 hSDO}.
          WHEN 15 THEN
              IF iStartSDO <= 15 THEN
             {get RowObjectTable phRowObject15 hSDO}.
          WHEN 16 THEN
              IF iStartSDO <= 16 THEN
             {get RowObjectTable phRowObject16 hSDO}.
          WHEN 17 THEN
              IF iStartSDO <= 17 THEN
             {get RowObjectTable phRowObject17 hSDO}.
          WHEN 18 THEN
              IF iStartSDO <= 18 THEN
             {get RowObjectTable phRowObject18 hSDO}.
          WHEN 19 THEN
              IF iStartSDO <= 19 THEN
             {get RowObjectTable phRowObject19 hSDO}.
          WHEN 20 THEN
              IF iStartSDO <= 20 THEN
             {get RowObjectTable phRowObject20 hSDO}.
      END CASE.    
  END.             /* END DO iSDO */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-serverFetchDOProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverFetchDOProperties Procedure 
PROCEDURE serverFetchDOProperties :
/*------------------------------------------------------------------------------
  Purpose:     Server-side procedure run at startup to return property values
               needed on the client.
  Parameters:  OUTPUT pcPropList AS CHARACTER
                 Properties and Values in internal format that can be 
                 used to assign 
  Notes:       Currently returns the OpenQuery and IndexInformation property of 
               each SDO. 
               There's no need to do a call to initializeObject before calling
               this as it is initialized here if required.  
------------------------------------------------------------------------------*/
   DEFINE OUTPUT PARAMETER pcPropList   AS CHARACTER NO-UNDO.
   
   DEFINE VARIABLE cServerOperatingMode AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cContained           AS CHARACTER NO-UNDO.
   DEFINE VARIABLE lInitialized         AS LOGICAL   NO-UNDO.
   DEFINE VARIABLE iSDO                 AS INTEGER   NO-UNDO.
   DEFINE VARIABLE hSDO                 AS HANDLE    NO-UNDO.

   {get ObjectInitialized lInitialized}.
   
   IF NOT lInitialized THEN
   DO:
     {set OpenOnInit FALSE}.
     RUN initializeObject IN TARGET-PROCEDURE.
   END. /* if not initialized */

   /* We should have a Property to decide which props to fetch */
   pcPropList = DYNAMIC-FUNCTION('containedProperties':U IN TARGET-PROCEDURE,
       /* property from this SBO instance */
       'THIS;ServerOperatingMode' + ';':U +
       /* Properties from SDOs */
       'SmartDataObject;OpenQuery,DBNames,IndexInformation':U,
        NO). /* future */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContextAndInitialize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setContextAndInitialize Procedure 
PROCEDURE setContextAndInitialize :
/*------------------------------------------------------------------------------
  Purpose:  Reset context and initialize this server side object   
  Parameters:  pcContainedProps
               Properties in the format returned from 
               containedProperties to be passed to assignContainedProperties 
  Notes:    Called from a stateless client before a request.
            The format used in this may change in 9.1C        
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcContainedProps AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cContained           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iSDO                 AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hSDO                 AS HANDLE    NO-UNDO.
  
  {set OpenOnInit FALSE}. 

  RUN initializeObject IN TARGET-PROCEDURE.

  DYNAMIC-FUNCTION('assignContainedProperties':U IN TARGET-PROCEDURE,
                    pcContainedProps,
                    '':U). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPropertyList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setPropertyList Procedure 
PROCEDURE setPropertyList :
/*------------------------------------------------------------------------------
  Purpose:     To set a list of properties taken from a CHR(3) delimitted list
               of "propCHR(4)value" pairs.
  
  Parameters:  
    INPUT pcProperties - the CHR(3) delimitted list of "propCHR(4)value" pairs
                         to be set.
  
  Notes:      COPY of data.p () 
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcProperties AS CHARACTER                    NO-UNDO.
  
  DEFINE VARIABLE iProp        AS INTEGER                             NO-UNDO.
  DEFINE VARIABLE cProp        AS CHARACTER                           NO-UNDO.
  DEFINE VARIABLE cValue       AS CHARACTER                           NO-UNDO.
  DEFINE VARIABLE cSignature   AS CHARACTER                           NO-UNDO.
  DEFINE VARIABLE iCnt         AS INTEGER                             NO-UNDO.

  iCnt = NUM-ENTRIES(pcProperties,CHR(3)).
  DO iProp = 1 TO iCnt:
    /* Process Prop<->Value pairs */
    ASSIGN cProp  = ENTRY(iProp,pcProperties,CHR(3))
           cValue = ENTRY(2,cProp,CHR(4))
           cProp  = ENTRY(1,cProp,CHR(4)).

    /* Get the datatype of the property */
    cSignature = DYNAMIC-FUNCTION("Signature":U IN TARGET-PROCEDURE, "get":U + cProp).
    IF cSignature EQ "":U THEN  /* It wasn't found */
      DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "Property ":U + cProp + " not defined.":U).
    ELSE CASE ENTRY(2, cSignature):
      WHEN "CHARACTER":U THEN
        DYNAMIC-FUNCTION("set":U + cProp IN TARGET-PROCEDURE, 
                         IF cValue = "?" THEN ? ELSE cValue).
      WHEN "INTEGER":U THEN
        DYNAMIC-FUNCTION("set":U + cProp IN TARGET-PROCEDURE, 
                         INT(IF cValue = "?" THEN ? ELSE cValue)).
      WHEN "LOGICAL":U THEN
        DYNAMIC-FUNCTION("set":U + cProp IN TARGET-PROCEDURE,
                         IF cValue = "YES" THEN yes ELSE no).
      WHEN "DECIMAL":U THEN
        DYNAMIC-FUNCTION("set":U + cProp IN TARGET-PROCEDURE, 
                         DEC(IF cValue = "?" THEN ? ELSE cValue)).
    END.  /* CASE on property type */
  END.  /* DO iProp = 1 TO NUM-ENTRIES */
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startServerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startServerObject Procedure 
PROCEDURE startServerObject :
/*------------------------------------------------------------------------------
  Purpose:    When a SmartBusinessObject is split and running Statelessly on an
              AppServer, startServerObject is run on the client to start
              the SmartBusinessObject on the server.
  Parameters:  <none>
  Notes:      This override is for error handling to show error message and
              return 'adm-error'. 
------------------------------------------------------------------------------*/ 
  DEFINE VARIABLE cMsg AS CHARACTER  NO-UNDO.
  
  RUN SUPER NO-ERROR.
  
  /* Handles only one message, which is sufficent with the current appserver 
    class */
  IF {fn anyMessage} THEN
  DO:
    cMsg = ENTRY(1,{fn fetchMessages},CHR(4)).
    {fnarg showMessage cMsg}.
    RETURN ERROR 'ADM-ERROR':U.
  END.
  ELSE IF ERROR-STATUS:ERROR THEN
    RETURN ERROR RETURN-VALUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-undoTransaction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE undoTransaction Procedure 
PROCEDURE undoTransaction :
/*------------------------------------------------------------------------------
  Purpose:     Passes the undoTransaction event on to each contained
               DataObject that has any uncommitted changes.
  Parameters:  <none>
------------------------------------------------------------------------------*/ 
 DEFINE VARIABLE iDO          AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cContained   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hROUTable    AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hDO          AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hMaster      AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cCurRowident AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cNewRowident AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cRefresh     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hSource      AS HANDLE     NO-UNDO.
 DEFINE VARIABLE iSource      AS INTEGER    NO-UNDO.
 DEFINE VARIABLE lCancel      AS LOGICAL    NO-UNDO.
 
 /* Visual dataTargets subscribes to this */
 PUBLISH 'confirmUndo':U FROM TARGET-PROCEDURE (INPUT-OUTPUT lCancel).
 IF lCancel THEN RETURN.
  
 {get ContainedDataObjects cContained}.
 cRefresh = FILL(',',NUM-ENTRIES(cContained)).
 SDOLoop:
 DO iDO = 1 TO NUM-ENTRIES(cContained):
   hDO = WIDGET-HANDLE(ENTRY(iDO, cContained)).
   {get RowObjUpdTable hROUTable hDO}.
   IF hROUTable:HAS-RECORDS THEN 
   DO:
     {get Rowident cCurRowident hDO}. 
     RUN undoTransaction IN hDO.
     {get Rowident cNewRowident hDO}. 
     /* The undo changed position, so we need to publish to SDO datatargets */ 
     IF cCurRowident <> cNewRowident THEN
     DO:
       /* Check if we have changed position of any source, which means that we 
          will receive a dataAvailable from that and don't need to mark this 
          to be refresh */  
       hSource = hDO. 
       DO WHILE VALID-HANDLE(hSource):
         {get DataSource hSource hSource}.
         iSource = LOOKUP(STRING(hSource),cContained). 
         /* we have a parent that will be refreshed, so undo the next SDO */
         IF iSource > 0 AND ENTRY(iSource, cRefresh) <> '':U THEN
            NEXT SDOLoop.
       END.      
       /* Set the refresh flag */
       ENTRY(ido,cRefresh) = '1':U.      
     END.      
   END. /* ROUTable:has-records */   
 END.     /* END DO iDO */

 {set RowObjectState 'NoUpdates':U}.
 
 /* Block outgoing messages while we may do an internal dataAvailable in cases 
    where the position changed, since we always do an external dataAvailable of
    all data further down also when position has not changed */ 
 {set BlockDataAvailable YES}.
 DO iDO = 1 TO NUM-ENTRIES(cContained):
   hDO = WIDGET-HANDLE(ENTRY(iDO, cContained)).
   /* The popsition changed during undo so publish */
   IF ENTRY(iDO,cRefresh) <> '':U THEN
     PUBLISH 'dataAvailable':U FROM hDO (INPUT "DIFFERENT":U).
 END.
 {set BlockDataAvailable NO}.
 
 /* Now let external client objects know we might have changed data. */  
 PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE (INPUT "DIFFERENT":U).

 RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateState Procedure 
PROCEDURE updateState :
/*------------------------------------------------------------------------------
  Purpose:  Republishes any updateState event messages received from a
            Data-Target, to get them e.g. to Navigation Panel / Toolbar. 
   Params:  INPUT pcState AS CHARACTER   
    Notes:   
------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAMETER pcState AS CHARACTER  NO-UNDO.
   
   DEFINE VARIABLE cMapping          AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE lInProcess        AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE cContained        AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cObjects          AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE iObject           AS INTEGER    NO-UNDO.
   DEFINE VARIABLE hObject           AS HANDLE     NO-UNDO.
   DEFINE VARIABLE cTargets          AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cEvents           AS CHARACTER  NO-UNDO.

   {get ContainedDataObjects cContained}.
   {get ObjectMapping cMapping}.
   
   /* If the event did NOT come from one of our ContainedDataObjects, 
      we have reason to believe that it came from the outside */
   IF NOT CAN-DO(cContained,STRING(SOURCE-PROCEDURE)) THEN
   DO:
     /* When running updateState in SDOS, we will receive the same events from 
        them, which in again will be run in objects that may send it back 
        to the SBO in the course of republishing the event. We don't want the 
        SBO to react to these intermediate messages, so we set a flag on the 
        way in and turn it off when the event has been dealt with */    
     {get UpdateStateInProcess lInProcess}.

     IF lInProcess THEN 
       RETURN. 

     /* Get all internal objects linked to this */ 
     cObjects = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE,
                                 STRING(SOURCE-PROCEDURE), 
                                 cMapping, 
                                 TRUE,  /* return entry *after* */  
                                 ",":U).

     {set UpdateStateInProcess YES}.
     DO iObject = 1 TO NUM-ENTRIES(cObjects):
       hObject = WIDGET-HANDLE(ENTRY(iObject, cObjects)).
       ghTargetProcedure = TARGET-PROCEDURE.
       RUN updateState IN hObject (pcState) NO-ERROR.
       ghTargetProcedure = ?.
     END. /* END DO iObject */
     {set UpdateStateInProcess NO}.
   END. /* not can-do(contained,source) */
   ELSE DO: /* from the inside sending out */
     cObjects = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE,
                                 STRING(SOURCE-PROCEDURE), 
                                 cMapping, 
                                 FALSE,  /* return entry *before* */  
                                 ",":U).
     /* We check if data targets has subscribed. 
        Currently browsers do and viewers don't.  */
     {get DataTarget cTargets}.
     DO iObject = 1 TO NUM-ENTRIES(cObjects):
       ASSIGN
         hObject = WIDGET-HANDLE(ENTRY(iObject, cObjects))
         cEvents = ?.

       IF CAN-DO(cTargets,STRING(hObject)) THEN
         {get DataSourceEvents cEvents hObject}.
       
       IF CAN-DO(cEvents,'updateState':U) OR cEvents = ? THEN
       DO:
         ghTargetProcedure = TARGET-PROCEDURE.
         RUN updateState IN hObject (pcState) NO-ERROR.
         ghTargetProcedure = ?.
       END. /* can-do(cEvents,'updatestate') or cEvents = ? */
     END. /* DO iObject = 1 to  */
   END.  /* outgoing events */
   
   RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-addQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addQueryWhere Procedure 
FUNCTION addQueryWhere RETURNS LOGICAL
  ( pcWhere  AS CHARACTER, 
    pcObject AS CHARACTER, 
    pcAndOr  AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  SBO version of this where-clause function, which simply passes
            the parameters on to the SDO named in the pcObject argument.
   Params:  pcWhere AS CHAR (as for query.p function addQueyrWhere),
            pcBuffer AS CHAR (must be an SDO ObjectName),
            pcAndOr AS CHAR as for query.p fn)
    Notes:  Currently the pcObject argument must be specified.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hObject AS HANDLE NO-UNDO.

  hObject = DYNAMIC-FUNCTION('dataObjectHandle':U IN TARGET-PROCEDURE, pcObject).
  IF VALID-HANDLE(hObject) THEN
      RETURN DYNAMIC-FUNCTION('addQueryWhere':U IN hObject,
                              pcWhere, '':U, pcAndOr).
  ELSE RETURN FALSE.   /* If Object wasn't a known SDO Object Name */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addRow Procedure 
FUNCTION addRow RETURNS CHARACTER
  ( pcViewColList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: SBO version of this function, which passes the column list on to the
           contained DataObject which manages that data.
           Returns a chr(1) separated list of RowIdent(s) (separated with 
           semicolon for each object) and values corresponding to the passed 
           list.  
   Params: pcViewColList AS CHARACTER
           - List of columns qualifed with ObjectName or unqualified. 
    Notes: ALL or NONE columns must be qualified! 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRequester   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTargetNames AS CHARACTER  NO-UNDO.
  
  /* NOTE: AT least temporarily, we may need to get this value to get at
     the real calling object. */
  {get TargetProcedure hRequester SOURCE-PROCEDURE}.
  
  IF NOT VALID-HANDLE(hRequester) THEN
    hRequester = SOURCE-PROCEDURE.
   
  {get UpdateTargetNames cTargetNames hRequester}.  
 
  RETURN DYNAMIC-FUNCTION('newDataObjectRow':U IN TARGET-PROCEDURE,
                          'add':U,
                           cTargetNames,
                           pcViewColList).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-appendContainedObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION appendContainedObjects Procedure 
FUNCTION appendContainedObjects RETURNS LOGICAL PRIVATE
  ( INPUT-OUTPUT pcObjects AS CHARACTER, INPUT phObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  internal function to build the list of ContainedObjects
             in top-down Data-link order.
    Notes:  private function
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iTarget  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTargets AS CHARACTER  NO-UNDO.

  pcObjects = pcObjects + (IF pcObjects = "":U THEN "":U ELSE ",":U) +
      STRING(phObject).
  {get DataTarget cTargets phObject}.
  DO iTarget = 1 TO NUM-ENTRIES(cTargets):
      appendContainedObjects(pcObjects,      /* recurse as needed */
                             WIDGET-HANDLE(ENTRY(iTarget, cTargets))).
  END.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignContainedProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignContainedProperties Procedure 
FUNCTION assignContainedProperties RETURNS LOGICAL
  (pcPropValues   AS CHAR,
   pcReplace      AS CHAR):
/*------------------------------------------------------------------------------
   Purpose: Set properties in contained objects using the returned value of
            containedProperties().  
Parameters: 
   pcPropValues as char
         - Properties and values. 
           This parameter is intended to receive the value from the
           containedProperties   
       -   It is a CHR(3)-delimited list where the first entry decides 
           which properties the rest of the data pllies to.
            - Comma separated list(s) of properties (all objects are SDOs).
            - Alternatively a paired semicolon lists that specifies properties
              for different Object types.   
            Example: 
             - SmartBusinessObject;Prop1;SmartDataObject;propA,propB,propC
                 
            NB: 'THIS' indicates properties for this object instance.
            
            The rest of the CHR(entries) consists of paired 
            objectNames and CHR(4)-delimited properties. A blank objectname 
            indicates this-procedure.
 
            The chr(4) separated list of values corresponds to the Propertylist 
            for that objectType.    
   pcReplace - Comma separated pair of replace properties 
               There's currently no support to qualify this list with 
               ObjectTypes. 
                  
               Example:  
                'QueryWhere,QueryContext' 
               - Use 'QueryWhere' values in the list to setQueryContext 
              
     Notes: 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPropHeader   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iProp         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cProp         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iReplace      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iObject       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hObject       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cObjectType   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cObjectName   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cPropList     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cValueList    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lMultiTypes   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cValue        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cPassedProp   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUseProp      AS CHARACTER NO-UNDO.
  
  ASSIGN  /* The first entry is the property 'header' that defines which
             properties we get for each objectype */ 
    cPropHeader = ENTRY(1,pcPropValues,CHR(3))
    lMultiTypes = NUM-ENTRIES(cPropHeader,';':U) > 1.
 
  /* Replace propertyname(s) if replace specified */
  IF pcReplace <> '':U and pcReplace <> ? THEN
  DO iProp = 1 TO NUM-ENTRIES(cPropHeader,';':U) BY 2:
    ASSIGN  
     /* Currently no objecttype qualifier support */ 
     /* cObjectType  = ENTRY(iProp,cPropHeader,';':U)  */
      cPropList    = IF NOT lMultiTypes 
                     THEN cPropHeader
                     ELSE ENTRY(iProp + 1,cPropHeader,';':U).
    DO iReplace = 1 TO NUM-ENTRIES(pcReplace) BY 2:
      ASSIGN
        cPassedProp = ENTRY(iReplace,pcReplace)
        cUseProp    = ENTRY(iReplace + 1,pcReplace)      
        cPropList   = REPLACE(cPropList,cPassedProp,cUseProp).
    END.
    IF NOT lMultiTypes THEN
      cPropHeader = cPropList.
    ELSE
      ENTRY(iProp + 1,cPropHeader,';':U) = cPropList.
  END. /* IF pcReplace <> '':U */
  /* If one type set proplist once and for all here */
  cPropList = IF NOT lMultiTypes THEN cPropHeader ELSE '':U.
  
  /* The objects property pairs starts on the 2 entry */  
  DO iObject = 2 TO NUM-ENTRIES(pcPropValues,CHR(3)) BY 2:  
    ASSIGN
      cObjectName = ENTRY(iObject,pcPropValues,CHR(3))
      cValueList  = ENTRY(iObject + 1,pcPropValues,CHR(3)) 
      hObject     = IF cObjectName <> '':U 
                    THEN ({fnarg DataObjectHandle cObjectName})
                    ELSE TARGET-PROCEDURE.

    IF lMultiTypes THEN       
      ASSIGN 
        cObjectType = IF cObjectName <> '':U 
                      THEN {fn getObjectType hObject}
                      ELSE "THIS":U
        cPropList   = DYNAMIC-FUNCTION('MappedEntry':U IN TARGET-PROCEDURE,
                                       cObjectType, 
                                       cPropHeader, 
                                       TRUE,  /* return entry *after* */ 
                                       ";":U). 
    
    DO iProp = 1 TO NUM-ENTRIES(cPropList):
      ASSIGN
        cProp      = ENTRY(iProp,cPropList)
        cValue     = ENTRY(iProp,cValueList,CHR(4)).
      DYNAMIC-FUNCTION('set':U + cProp IN hObject,cValue) NO-ERROR.
    END. /* do iProp = 1 to num-entries(cPropHeader) */
  END. /* do iObject = 2 to num-entries(pcPropValues) */
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignCurrentMappedObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignCurrentMappedObject Procedure 
FUNCTION assignCurrentMappedObject RETURNS LOGICAL
  ( phRequester  AS HANDLE, 
    pcObjectName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Identifies the "current" contained Data Object for purposes of 
            Navigation or other access by the caller.
   Params:  phRequester AS HANDLE, pcObjectName AS CHARACTER
    Notes:  This function maps the caller to the specified DataObject using the
            ObjectMapping property.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hObject  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cMapping AS CHAR      NO-UNDO.
  DEFINE VARIABLE iObject  AS INT       NO-UNDO.
  DEFINE VARIABLE cTargets AS CHARACTER NO-UNDO.

  {get ObjectMapping cMapping}.
  hObject = {fnarg dataObjectHandle pcObjectName}.
  IF VALID-HANDLE (hObject) THEN
  DO:
      iObject = LOOKUP(STRING(phRequester), cMapping).
      IF iObject NE 0 THEN       /* Change the mapping if the source is there */
          ENTRY(iObject + 1, cMapping) = STRING(hObject).
      ELSE 
      DO:
        /* if requester is an unmapped DataTarget then call the procedure that 
           does the ObjectMapping and updates required properties in target*/  
        {get DataTarget cTargets}.
         IF CAN-DO(cTargets,STRING(phRequester)) THEN
           RUN addDataTarget IN TARGET-PROCEDURE (phRequester).
      END.                      
      RETURN TRUE.
  END.      /* END DO IF VALID-HANDLE */
  ELSE RETURN FALSE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignQuerySelection Procedure 
FUNCTION assignQuerySelection RETURNS LOGICAL
  ( pcColumns AS CHARACTER, pcValues AS CHARACTER, pcOperators AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  SBO version of this where-clause function, which separates the
            Columns by SDO and passes columns, values, and operators on to
            the appropriate SDO(s).
   Params:  pcColumns AS CHAR, pcValues AS CHAR, pcOperators AS CHAR --
            all as for the query.p assignQuerySelection function
    Notes:  All columns must be qualified by their SDO Objectname as TableName;
            this will be replaced with RowObject when the columns are passed
            on to the SDO.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iColumn      AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cCols        AS CHARACTER   NO-UNDO INIT "":U.
  DEFINE VARIABLE cVals        AS CHARACTER   NO-UNDO INIT "":U.
  DEFINE VARIABLE cOps         AS CHARACTER   NO-UNDO INIT "":U.
  DEFINE VARIABLE cObjectNames AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cColumn      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iName        AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cString      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE lSuccess     AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE hObject      AS HANDLE      NO-UNDO.

  {get DataObjectNames cObjectNames}.
  DO iColumn = 1 TO NUM-ENTRIES(cObjectNames):
      /* Initialize these to hold the cols, values, and ops for each SDO. 
         Use a delimiter of CHR(2) between groups for each SDO. */
      cCols = cCols + (IF iColumn = 1 THEN "":U ELSE CHR(2)).
  END.            /* END DO iColumn -- initialization of delimiters */
  cVals = cCols.
  /* If the request specified an operator per column, then initialize
     accordingly; otherwise just store the one entry passed in to us. */
  IF NUM-ENTRIES (pcOperators) > 1 THEN
      cOps = cCols.
  ELSE cOps = pcOperators.

  /* Now go through all the columns passed and divide them up (along with
     the corresponding values and, if specified, operators) by ObjectName. */
  DO iColumn = 1 TO NUM-ENTRIES(pcColumns):
      cColumn = ENTRY(iColumn, pcColumns).
      IF NUM-ENTRIES(cColumn, ".":U) NE 2 THEN
          RETURN FALSE.           /* Must be qualified by ObjectName */
      iName = LOOKUP(ENTRY(1, cColumn, ".":U), cObjectNames).
      IF iName = 0 THEN
          RETURN FALSE.
      /* First add the column to the right list, qualified as "RowObject" */
      ASSIGN cString = ENTRY(iName, cCols, CHR(2))
             cString = cString + (IF cString = "":U THEN "":U ELSE ",":U) +
                 "RowObject.":U + ENTRY(2, cColumn, ".":U)
             ENTRY(iName, cCols, CHR(2)) = cString
             /* Now add the corresponding value to its list. */
             cString = ENTRY(iName, cVals, CHR(2))
             cString = cString + (IF cString = "":U THEN "":U ELSE CHR(1)) +
                 ENTRY(iColumn, pcValues, CHR(1))
             ENTRY(iName, cVals, CHR(2)) = cString.
       /* Finally put the operator in its list, unless there's only one
          (or none) for the whole list). */
       IF NUM-ENTRIES(pcOperators) > 1 THEN
           ASSIGN cString = ENTRY(iName, cOps, CHR(2))
                  cString = cString + (IF cString = "":U THEN "":U ELSE ",":U) +
                      ENTRY(iColumn, pcOperators)
                  ENTRY(iName, cOps, CHR(2)) = cString.           
  END.         /* END DO iColumn -- divide up columns per SDO. */

  DO iName = 1 TO NUM-ENTRIES(cObjectNames):
      cColumn = ENTRY(iName, cCols, CHR(2)).
      IF cColumn NE "":U THEN
      DO:
          ASSIGN hObject = DYNAMIC-FUNCTION('dataObjectHandle':U 
                                            IN TARGET-PROCEDURE, 
                                     ENTRY(iName, cObjectNames))
                 lSuccess = DYNAMIC-FUNCTION('assignQuerySelection':U IN
                                hObject,
                                INPUT ENTRY(iName, cCols, CHR(2)),
                                INPUT ENTRY(iName, cVals, CHR(2)),
                                INPUT IF NUM-ENTRIES(pcOperators) <= 1 THEN
                                    pcOperators ELSE 
                                        ENTRY(iName, cOps, CHR(2))).
                 IF NOT lSuccess THEN
                     RETURN FALSE.
      END.          /* END DO if cColumns not "" */
  END.              /* END DO iName */

  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cancelRow Procedure 
FUNCTION cancelRow RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  SBO version of this function, which passes the request
            on to the contained DataObject which manages that data.
   Params:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRequester   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iEntry       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hTarget      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cTargetNames AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTargetName  AS CHARACTER  NO-UNDO.
  
  {get TargetProcedure hRequester SOURCE-PROCEDURE}.
  
  /* NOTE: AT least temporarily, we may need to get this value to get at
     the real calling object. */
  IF NOT VALID-HANDLE(hRequester) THEN
    hRequester = SOURCE-PROCEDURE.
  
  /* The UpdatTargetNames property is set in the caller and identifies the 
     intended target for the add. The user may specify it to solve cases 
     where fieldname recognition is not sufficient to find the correct target. 
     If not defined by the user it is updated in updateObjectMapping. */
  {get UpdateTargetNames cTargetNames hRequester}.  
  
  /* NOte that we currently only support one  Target */
  DO iEntry = 1 TO NUM-ENTRIES(cTargetNames):
    ASSIGN
      cTargetName = ENTRY(iEntry,cTargetNames) 
      hTarget     = {fnarg DataObjectHandle cTargetName}.

    IF VALID-HANDLE(hTarget) THEN
      {fn cancelRow hTarget}.

  END. /* do iEntry = 1 to  */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-canNavigate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION canNavigate Procedure 
FUNCTION canNavigate RETURNS LOGICAL
  (   ) :
/*------------------------------------------------------------------------------
  Purpose: Check if this object or its children has any updates.   
           This SBO version of the function turns around and returns 
           canNavigate from the SDO to which the caller is mapped.
           Otherwise it publishes isUpdatePending to its targets
    Notes: You can navigate an object that has uncommiited changes, but not 
           if the children has uncommitted changes, so this publishes 
           IsUpdatePending to check data-targets as this includes 
           rowObjectState in the check.
         - Navigating objects will typically call this to check if the object
           that they are navigating can be navigated. Nav objects receives
           updateState from the objects they navigate and will perform this 
           check in the source of any 'updateComplete' message. This is required
           because an 'updateComplete' may come from a branch of a data-link 
           tree while publish isUpdatePending will check the whole tree to 
           ensure that no branches has pending updates. 
         - This returns true if we can navigate while isUpdatePending is the 
           opposite and returns true if update is pending. 
          (The real reason: It's easier to have default false for i-o params)   
----------------------------------------------------------------------------*/
  DEFINE VARIABLE cMapping     AS CHAR    NO-UNDO.
  DEFINE VARIABLE iObject      AS INT     NO-UNDO.
  DEFINE VARIABLE hObject      AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRequester   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lCanNavigate AS LOGICAL NO-UNDO.
  DEFINE VARIABLE lUpdate      AS LOGICAL NO-UNDO.

  {get TargetProcedure hRequester SOURCE-PROCEDURE} NO-ERROR.   
  IF NOT VALID-HANDLE(hRequester) THEN
    hRequester = SOURCE-PROCEDURE.

  {get ObjectMapping cMapping}.
  
  iObject = LOOKUP(STRING(hRequester), cMapping).
  
  IF iObject = 0 THEN
    {get MasterDataObject hObject} NO-ERROR.
  
  ELSE 
    hObject = WIDGET-HANDLE(ENTRY(iObject + 1, cMapping)).
  
  lCanNavigate = {fn canNavigate hObject} NO-ERROR.
  
  IF lCanNavigate = FALSE THEN
    RETURN FALSE.
  
  ELSE DO: /* we will get here if lCanNavigae is ? so we do this also if 
             function was not found above */    
    PUBLISH 'isUpdatePending':U FROM TARGET-PROCEDURE (INPUT-OUTPUT lUpdate).  
    RETURN NOT lUpdate. 
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnColumnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnColumnLabel Procedure 
FUNCTION columnColumnLabel RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its Column Label by passing the
            request along to the appropriate Data Object.  
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
    Notes:  The SDO columnDataType option of permitting a name qualified by
            database table name is not supported.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty (pcColumn, 'ColumnLabel':U, TARGET-PROCEDURE).  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnDataType Procedure 
FUNCTION columnDataType RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its data-type by passing the
            request along to the appropriate Data Object.  
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
    Notes:  The SDO columnDataType option of permitting a name qualified by
            database table name is not supported.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty (pcColumn, 'DataType':U, TARGET-PROCEDURE).  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDbColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnDbColumn Procedure 
FUNCTION columnDbColumn RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its DB column name by passing the
            request along to the appropriate Data Object. 
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty(pcColumn, 'DbColumn':U, TARGET-PROCEDURE).   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnExtent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnExtent Procedure 
FUNCTION columnExtent RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its Extent by passing the
            request along to the appropriate Data Object.  
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
    Notes:  The SDO columnDataType option of permitting a name qualified by
            database table name is not supported.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty (pcColumn, 'Extent':U, TARGET-PROCEDURE).  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnFormat Procedure 
FUNCTION columnFormat RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its Format by passing the
            request along to the appropriate Data Object.  
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
    Notes:  The SDO columnDataType option of permitting a name qualified by
            database table name is not supported.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty (pcColumn, 'Format':U, TARGET-PROCEDURE).  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnHelp Procedure 
FUNCTION columnHelp RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its help string by passing the
            request along to the appropriate Data Object.  
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
    Notes:  The SDO columnDataType option of permitting a name qualified by
            database table name is not supported.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty (pcColumn, 'Help':U, TARGET-PROCEDURE).  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnInitial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnInitial Procedure 
FUNCTION columnInitial RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its initial value by passing the
            request along to the appropriate Data Object.  
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
    Notes:  The SDO columnDataType option of permitting a name qualified by
            database table name is not supported.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty (pcColumn, 'Initial':U, TARGET-PROCEDURE).  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnLabel Procedure 
FUNCTION columnLabel RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its Label by passing the
            request along to the appropriate Data Object. 
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty (pcColumn, 'Label':U, TARGET-PROCEDURE).  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnMandatory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnMandatory Procedure 
FUNCTION columnMandatory RETURNS LOGICAL
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its Mandatory setting by passing the
            request along to the appropriate Data Object.  
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
    Notes:  The SDO columnDataType option of permitting a name qualified by
            database table name is not supported.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMandatory AS CHARACTER    NO-UNDO.
  /* This fn does the work. */

  cMandatory = columnProperty (pcColumn, 'Mandatory':U, TARGET-PROCEDURE).  
  IF cMandatory = "YES":U OR cMandatory = "TRUE" THEN
      RETURN TRUE.
  ELSE RETURN FALSE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnModified Procedure 
FUNCTION columnModified RETURNS LOGICAL
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its Modified setting by passing the
            request along to the appropriate Data Object.  
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
    Notes:  The SDO columnDataType option of permitting a name qualified by
            database table name is not supported.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cModified AS CHARACTER    NO-UNDO.
  /* This fn does the work. */

  cModified = columnProperty (pcColumn, 'Modified':U, TARGET-PROCEDURE).  
  IF cModified = "YES":U OR cModified = "TRUE" THEN
      RETURN TRUE.
  ELSE RETURN FALSE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnObjectHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnObjectHandle Procedure 
FUNCTION columnObjectHandle RETURNS HANDLE
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Takes an unqualified SDO column name and returns the procedure
           handle of the first SDO in this SBO that has that column name.
   Params: pcColumn AS CHARACTER 
    Notes: Column Name requests for SBOs should normally be qualified by
           their SDO ObjectName. This function is called is there is no
           qualifier to return the handle of the SDO, used by other functions. 
------------------------------------------------------------------------------*/

 DEFINE VARIABLE cColumns    AS CHAR   NO-UNDO.
 DEFINE VARIABLE iDO         AS INT    NO-UNDO.
 DEFINE VARIABLE cObjects    AS CHAR   NO-UNDO.

 {get ContainedDataColumns cColumns}.
 {get ContainedDataObjects cObjects}.
 DO iDO = 1 TO NUM-ENTRIES(cColumns, ";":U):  /* Extract each SDO list. */
     IF LOOKUP(pcColumn, ENTRY(iDO, cColumns, ";")) NE 0 THEN
         RETURN WIDGET-HANDLE(ENTRY(iDO, cObjects)).
 END.         /* END DO iDO */
 RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnPrivateData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnPrivateData Procedure 
FUNCTION columnPrivateData RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its PRIVATE-DATA by passing the
            request along to the appropriate Data Object. 
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty(pcColumn, 'PrivateData':U, TARGET-PROCEDURE).   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnProperty Procedure 
FUNCTION columnProperty RETURNS CHARACTER PRIVATE
  ( pcColumn AS CHARACTER, pcProperty AS CHARACTER, phTarget AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  General purpose function used internally to identify the
            SDO in which one of the column<property> functions should be
            run and to run it and return the value.
            Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its property value by passing the
            request along to the appropriate Data Object. If the column name
            is not qualified by the SDO ObjectName, the first matching column
            name is used to identify which SDO to pass the request along to.
            
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName;
            pcProperty AS CHARACTER -- the property name to retrieve;
            phTarget AS HANDLE -- Target procedure handle
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cColumn AS CHAR   NO-UNDO.
  DEFINE VARIABLE hObject AS HANDLE NO-UNDO.
  DEFINE VARIABLE cObject AS CHAR   NO-UNDO.

  IF NUM-ENTRIES(pcColumn, ".":U) = 2 THEN   /* Use ObjectName qualifier */
      ASSIGN cColumn = ENTRY(2, pcColumn, ".":U)
             cObject = ENTRY(1, pcColumn, ".":U)
             hObject = DYNAMIC-FUNCTION ('dataObjectHandle':U IN phTarget, 
                                         cObject).
  ELSE 
      ASSIGN cColumn = pcColumn             /* Use the unqualified name */
             hObject = DYNAMIC-FUNCTION ('columnObjectHandle':U IN phTarget,
                                          cColumn).
  IF VALID-HANDLE(hObject) THEN
      RETURN DYNAMIC-FUNCTION('column':U + pcProperty IN hObject, cColumn).
  ELSE RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnQuerySelection Procedure 
FUNCTION columnQuerySelection RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its QuerySelection by passing the
            request along to the appropriate Data Object. 
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty(pcColumn, 'QuerySelection':U, TARGET-PROCEDURE).   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnReadOnly) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnReadOnly Procedure 
FUNCTION columnReadOnly RETURNS LOGICAL
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its ReadOnly setting by passing the
            request along to the appropriate Data Object.  
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
    Notes:  The SDO columnDataType option of permitting a name qualified by
            database table name is not supported.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cReadOnly AS CHARACTER    NO-UNDO.
  /* This fn does the work. */

  cReadOnly = columnProperty (pcColumn, 'ReadOnly':U, TARGET-PROCEDURE).  
  IF cReadOnly = "YES":U OR cReadOnly = "TRUE" THEN
      RETURN TRUE.
  ELSE RETURN FALSE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnStringValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnStringValue Procedure 
FUNCTION columnStringValue RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its String-Value by passing the
            request along to the appropriate Data Object. 
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty(pcColumn, 'StringValue':U, TARGET-PROCEDURE).   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnTable Procedure 
FUNCTION columnTable RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its Table name by passing the
            request along to the appropriate Data Object. 
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty(pcColumn, 'Table':U, TARGET-PROCEDURE).   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValExp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnValExp Procedure 
FUNCTION columnValExp RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its Validation Expression by passing the
            request along to the appropriate Data Object. 
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty(pcColumn, 'ValExp':U, TARGET-PROCEDURE).   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValMsg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnValMsg Procedure 
FUNCTION columnValMsg RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its ValMsg by passing the
            request along to the appropriate Data Object. 
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty(pcColumn, 'ValMsg':U, TARGET-PROCEDURE).   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnValue Procedure 
FUNCTION columnValue RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its Value by passing the
            request along to the appropriate Data Object. 
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty(pcColumn, 'Value':U, TARGET-PROCEDURE).   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnWidth Procedure 
FUNCTION columnWidth RETURNS DECIMAL
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its Width by passing the
            request along to the appropriate Data Object. 
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN DECIMAL(columnProperty(pcColumn, 'Width':U, TARGET-PROCEDURE)).   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-colValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION colValues Procedure 
FUNCTION colValues RETURNS CHARACTER
    (pcColumns AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:  SBO version of colValues to locate requested columns in contained
            Data Objects and assemble a list of their values.
   Params:  pcColumns AS CHARACTER -- comma-separated list of requested cols.
            - All qualified with objectname
            - One objectname qualified column will direct the call 
              to that SDO. 
            - unqualifed columns will use the value of the first column 
              encountered. (no ambiguity check)                
            The 'Rowident' will be a ; separated list of RowIdents 
            for all contained SDOs, also if only one SDO was encountered.
            The entry for SDOs for which no fields are requested will be blank.
            if pcColumns is blank then ALL SDOs rowids will be returned.
            For calls where one or more 
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cColValues            AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDONames              AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cContainedDataColumns AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cContainedDataObjects AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cColumn               AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iCol                  AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iDO                   AS INTEGER    NO-UNDO.
 DEFINE VARIABLE hDO                   AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cValue                AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lColFound             AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cColumnNames          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cObjectName           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cRowids               AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hRowObject            AS HANDLE     NO-UNDO.

 {get DataObjectNames cDONames}. 
 {get ContainedDataObjects cContainedDataObjects}.  /* List of contained Data Objects */

 /* We return a ; separated list of rowids as the first entry,
    we leave the entries blank if no fields were requested from the object
    but if no fields were requested at all we return all , */
 cRowids = FILL(';':U,NUM-ENTRIES(cDONames) - 1).
 
 IF pcColumns = '':U THEN
 DO: 
   DO iDO = 1 TO NUM-ENTRIES(cContainedDataObjects):
     hDO  = WIDGET-HANDLE(ENTRY(iDO,cContainedDataObjects)).
     IF NOT VALID-HANDLE(hDO) THEN
       RETURN ?.     /* Haven't been initialized yet. */
     {get RowObject hRowObject hDO}.
     ASSIGN
       ENTRY(iDO,cRowids,';':U)  = IF hRowObject:ROWID <> ? 
                                   THEN STRING(hRowObject:ROWID)
                                   ELSE '?':U.  
   END.
   RETURN cRowids + CHR(1).
 END. /* no columns requested */

 /* One qualified column qualifies all */
 IF INDEX(pcColumns,".":U) > 0 THEN
 DO:
   /* Check if we can resolve all columns in one SDO */
   DO iDO = 1 TO NUM-ENTRIES(cDONames) :
     /* replace ',object.' with ',' to see if all columns are for one object.
        left-trim because we add ',' to the columns to replace the first entry */
     ASSIGN
       cObjectName  = ENTRY(iDO,cDONames)
       cColumnNames = LEFT-TRIM(REPLACE(',':U + pcColumns,',':U + cObjectName + '.',',':U),',':U).
     IF INDEX(cColumnNames,'.':U) = 0 THEN
     DO:
       hDO  = {fnarg dataObjectHandle cObjectName}.       
       /* Haven't been initialized yet  */
       IF NOT VALID-HANDLE(hDO) THEN
         RETURN ?.    

       ASSIGN
         cColValues = {fnarg colValues cColumnNames hDo}
         /* Put the rowid part of the returned colvalues in the rowid list*/ 
         ENTRY(iDO,cRowids,';':U)  = ENTRY(1,cColValues) 
         /* then replace this list with the rowid part */
         ENTRY(1,cColValues,CHR(1)) = cRowids. 
       RETURN cColValues. /* We have all we need <------------------------- */
     END.  /* if index(cColumnnames,'.') = 0 */   
   END.  /* do iDO = 1 to num-entries(cDO) */
   
   ASSIGN 
      cObjectName = '':U
      hDO         = ?. 

   /* If we get here we did not return with data from one dataObject above */
   DO iCol = 1 TO NUM-ENTRIES(pcColumns):
     ASSIGN
       cColumn     = ENTRY(iCol,pcColumns).
     
     /* All columns must be qualified. We might probably get here if not 
        initialized if the logic above failed (?) */ 
     IF NUM-ENTRIES(cColumn,'.':U) <> 2 THEN
       RETURN ?.
     
     /* We don't need to keep regetting the SDO handle. */
     IF cObjectName NE ENTRY(1, cColumn, ".":U) THEN 
     DO:
       ASSIGN cObjectName = ENTRY(1, cColumn, ".":U)
              hDO         = {fnarg dataObjectHandle cObjectName}
              iDo         = LOOKUP(cObjectName,cDONames).
       
       /* Haven't been initialized  */
       IF NOT VALID-HANDLE(hDO) THEN
         RETURN ?.    

       /* if this is the first time this object was encountered get the ROWID */
       IF ENTRY(iDO,cRowids,';':U) = '':U THEN
       DO:
         {get RowObject hRowObject hDO}.
         ENTRY(iDO,cRowids,';':U) = IF hRowObject:ROWID <> ? 
                                    THEN STRING(hRowObject:ROWID)
                                    ELSE '?':U.
       END. /* first object encounter */
     END. /* new objectname */
     ASSIGN 
       cValue     = DYNAMIC-FUNCTION('columnValue':U IN hDO,ENTRY(2,cColumn,'.':U))
       cColValues = cColValues + CHR(1) + IF cValue = ? THEN "?":U 
                                          ELSE cValue.
   END. /* icol = 1 to num-entries */
 END. /* one or more columns qualified */  
 ELSE DO: /* no qualified columns */
   {get ContainedDataColumns cContainedDataColumns}. 
    
   DO iCol = 1 TO NUM-ENTRIES(pcColumns):
     ASSIGN 
       cColumn    = ENTRY(iCol,pcColumns)
       lColFound  = FALSE.
     DO iDO = 1 TO NUM-ENTRIES(cContainedDataColumns,';':U):
       IF CAN-DO(ENTRY(iDO,cContainedDataColumns,';':U),cColumn) THEN 
       DO:
         hDO        = WIDGET-HANDLE(ENTRY(iDO,cContainedDataObjects)).
         
          /* Haven't been initialized yet or not available  */
         IF NOT VALID-HANDLE(hDO) THEN
            RETURN ?.    

         ASSIGN
           cValue     = DYNAMIC-FUNCTION('columnValue':U IN hDO,cColumn)
           cColValues = cColValues + CHR(1) + IF cValue = ? THEN "?":U 
                                              ELSE cValue
                                          
           lColFound  = TRUE.
         /* if this is the first time this object was requested get the ROWID  */
         IF ENTRY(iDO,cRowids,';':U) = '':U THEN
         DO:
           {get RowObject hRowObject hDO}.
           ENTRY(iDO,cRowids,';':U) = IF hRowObject:ROWID <> ? 
                                      THEN STRING(hRowObject:ROWID)
                                      ELSE '?':U.
         END. /* first object encounter */
         LEAVE. /* iDo containedDataObject loop  */
       END.
     END. /* do iDo */
     IF NOT lColFound THEN RETURN ?.
   END. /* do icol 1 to num- pccolumns */
 END. 
 /* cColValues is prepended with chr(1) already */
 RETURN cRowids + cColValues.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-containedProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION containedProperties Procedure 
FUNCTION containedProperties RETURNS CHARACTER
  (pcQueryProps   AS CHAR,
   plDeep         AS LOG) :
/*------------------------------------------------------------------------------
   Purpose: Returns a CHR(3)-delimited list where the first entry is the 
            passed query parameter. The rest of the entries consists of paired 
            objectNames and CHR(4)-delimited properties.
             
            For 'plDeep' queries the ObjectName will be colon separated to 
            uniquely identify levels in the tree. 
            
            The second in each pair is a chr(4) separated list of values
            where each entry corresponds to the Propertlist for that object.   
            
            <pcQueryProps>
            CHR(3)
            <ObjectName1>CHR(3)<PropAvalue>CHR(4)<PropBvalue>
            CHR(3)      
            <ObjectName2>CHR(3)<PropAvalue>CHR(4)<PropBvalue>
            
Parameters: pcProperties 
              - Comma separated list(s) of properties to retrieve from SDOs.
              - Optionally use paired semicolom lists to query different 
                Object types.   
                Example: 
                 - SmartBusinessObject;Prop1;SmartDataObject;propA,propB,propC
                 
              NB: 'THIS' indicates properties for this object instance.   
                
            plDeep  (NOT SUPPORTED YET!)  
              - True  - Continue query in children of children.    
              - False - Only one level down.        
                                            
     Notes: The FORMAT of the returned string is INTERNAL and intended to 
            be transported as is (across servers) to be passed into  
            assignContainedProperties.   
         -  The format and delimiters may change completely in the 
            future.     
         -  When we implement support for plDeep and enforce unique objectnames
            this may be moved up to the container class.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContained  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iProp       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cProp       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iObject     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hObject     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cObjectType AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cObjectName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPropList   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lMultiTypes AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cValue      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cValueList  AS CHARACTER NO-UNDO.

  {get ContainedDataObjects cContained}.
  
  ASSIGN
    lMultiTypes = NUM-ENTRIES(pcQueryProps,';':U) > 1
    cPropList   = IF NOT lMultiTypes THEN pcQueryProps ELSE '':U.

  /* Start on 0 if multiTypes and use the 0 to handle 'this' instance */  
  DO iObject = (IF lMultiTypes THEN 0 ELSE 1) TO NUM-ENTRIES(cContained):   
    ASSIGN
      hObject     = IF iObject > 0 THEN WIDGET-HANDLE(ENTRY(iObject,cContained))
                                   ELSE TARGET-PROCEDURE.
    IF lMultiTypes THEN       
      ASSIGN 
        cObjectType = IF iObject > 0 THEN {fn getObjectType hObject}
                      ELSE "THIS":U
        cPropList   = DYNAMIC-FUNCTION('MappedEntry':U IN TARGET-PROCEDURE,
                                       cObjectType, 
                                       pcQueryProps, 
                                       TRUE,  /* return entry *after* */ 
                                       ";":U).
         
    IF cPropList <> ? THEN
    DO:
      IF iObject > 0 THEN {get ObjectName cObjectName hObject}.
      ELSE cObjectName = '':U.
      
      cValueList = cValueList + CHR(3) + cObjectName + CHR(3).
      DO iProp = 1 TO NUM-ENTRIES(cPropList):
        ASSIGN
          cProp      = ENTRY(iProp,cPropList)
          cValue     = DYNAMIC-FUNCTION('get':U + cProp IN hObject) 
         NO-ERROR.
        cValueList = cValueList 
                     + (IF iProp = 1 THEN '':U ELSE CHR(4))
                     +  IF cValue = ? THEN '?':U ELSE cValue.
      END. /* do iProp = 1 to num-entries(cPropList) */
    END. /* If cProplist <> ? */
  END. /* do iObject = 1 to num-entries(cContained) */
  
  /* Add the Query list as the first entry 
       (the list already starts with chr(3)) */
  RETURN pcQueryProps + cValueList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION copyRow Procedure 
FUNCTION copyRow RETURNS CHARACTER
  ( pcViewColList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: SBO version of this function, which passes the column list on to the
           contained DataObject which manages that data.
           Returns a chr(1) separated list of RowIdent(s) (separated with 
           semicolon for each object) and values corresponding to the passed 
           list.  
   Params: pcViewColList AS CHARACTER
           - List of columns qualifed with ObjectName or unqualified. 
    Notes: ALL or NONE columns must be qualified! 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRequester   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTargetNames AS CHARACTER  NO-UNDO.
  
  /* NOTE: AT least temporarily, we may need to get this value to get at
     the real calling object. */
  {get TargetProcedure hRequester SOURCE-PROCEDURE}.
  
  IF NOT VALID-HANDLE(hRequester) THEN
    hRequester = SOURCE-PROCEDURE.
   
  {get UpdateTargetNames cTargetNames hRequester}.  
 
  RETURN DYNAMIC-FUNCTION('newDataObjectRow':U IN TARGET-PROCEDURE,
                          'copy':U,
                           cTargetNames,
                           pcViewColList).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-currentMappedObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION currentMappedObject Procedure 
FUNCTION currentMappedObject RETURNS CHARACTER
  (  phRequester AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the object name which is currently mapped to this caller.
   Params:  input phRequester AS HANDLE
    Notes:  The value is derived from the ObjectMapping property in the SDO.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMapping    AS CHAR   NO-UNDO.
  DEFINE VARIABLE iObject     AS INT    NO-UNDO.
  DEFINE VARIABLE hObject     AS HANDLE NO-UNDO.
  DEFINE VARIABLE cObjectName AS CHAR   NO-UNDO.

  {get ObjectMapping cMapping}.
  iObject = LOOKUP(STRING(phRequester), cMapping).
  
  IF iObject > 0 THEN DO:
      hObject = WIDGET-HANDLE(ENTRY(iObject + 1, cMapping)).
      {get ObjectName cObjectName hObject} NO-ERROR.
      RETURN cObjectName.
  END.         /* END DO IF SOurce Object found in list. */
  ELSE RETURN ?.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataObjectHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION dataObjectHandle Procedure 
FUNCTION dataObjectHandle RETURNS HANDLE
  ( pcObjectName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Given the ObjectName (logical name) of a contained SDO,
           returns the handle of that SDO. 
   Params:  INPUT pcObjectName AS CHARACTER
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cObjectNames AS CHAR   NO-UNDO.
  DEFINE VARIABLE cDataHandles AS CHAR   NO-UNDO.
  DEFINE VARIABLE iName        AS INT    NO-UNDO.

  {get DataObjectNames cObjectNames}.
  {get ContainedDataObjects cDataHandles}.
  iName = LOOKUP(pcObjectName, cObjectNames).
  IF iName NE 0 THEN
      RETURN WIDGET-HANDLE(ENTRY(iName, cDataHandles)).
  ELSE RETURN ?. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteRow Procedure 
FUNCTION deleteRow RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  SBO version of this function, which passes the rowident
            on to the contained DataObject which manages that data.
   Params:  pcRowIdent AS CHARACTER
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjectName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iDO            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iDO2           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cRowIdent      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRowIdent2     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataObject    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataObject2   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAutoCommit    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSuccess       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cObjectHandles AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRowids        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hParent        AS HANDLE     NO-UNDO.
  
  {get ContainedDataObjects cObjectHandles}.
  
  /* Something is wrong, this is NOT allowed  */ 
  IF pcRowident = ? THEN RETURN FALSE. 

  /* Loop through to check if this is a delete of many ? and resort the list 
     so that we can delete the dependants first 
     Note: this is for support of One-to-One, not a cascade delete ..  */ 
  DO iDO = 1 TO NUM-ENTRIES(cObjectHandles) - 1: 
    cRowIdent = ENTRY(iDO,pcRowIdent,";":U). 
    /* we also sort unavailable rowident '?', probably not necessary, but   */
    IF cRowIdent <> '':U THEN
    DO:
      hDataObject = WIDGET-HANDLE(ENTRY(iDO,cObjectHandles)).     
      IF VALID-HANDLE(hDataObject) THEN
      DO:
        /* loop through all entries after this entry to check if we are 
           their datasource */  
        DO iDO2 = iDO + 1 TO NUM-ENTRIES(cObjectHandles):
          cRowIdent2 = ENTRY(iDO2,pcRowIdent,";":U).    
          IF cRowIdent2 <> '':U THEN
          DO:
            hDataObject2 = WIDGET-HANDLE(ENTRY(iDO2,cObjectHandles)).     
            IF VALID-HANDLE(hDataObject2) THEN
            DO:
              {get DataSource hParent hDataObject2}.
              /* if this object's DataSource is the object of the outer loop 
                 then swap them, so the child gets first in the list. */   
              IF hParent = hDataObject THEN
              DO:
                ASSIGN
                  ENTRY(iDO2,cObjectHandles)   = STRING(hDataObject)
                  ENTRY(iDO2,pcRowident,';':U) = cRowIdent
                  hDataObject = hDataObject2
                  cRowIdent  = cRowIdent2
                  ENTRY(iDO,cObjectHandles)   = STRING(hDataObject2)
                  ENTRY(iDO,pcRowident,';':U) = cRowIdent2.
              END. /* rowobject2's parent is rowobject */ 
            END. /* valid hROwObject2 */
            ELSE RETURN FALSE.
          END.  /* rowident2 is set */
        END.  /* do iDO2 = ido + 1 */ 
      END. /* valid(hRowObject) */
      ELSE RETURN FALSE.
    END. /* rowwident is set */ 
  END. /* do ido to num-entries(objects) - 1 */
  
  /* If AutoCommit commitTransaction will run dataavailable in targets 
     so just block outgoing while we delete */
  {get AutoCommit lAutoCommit}.

  IF lAutoCommit THEN 
    {set BlockDataAvailable TRUE}.
 
  /* Now loop through and delete */
  DO iDO = 1 TO NUM-ENTRIES(cObjectHandles): 
    ASSIGN
      cRowIdent   = ENTRY(iDO,pcRowIdent,";":U)    
      hDataObject = WIDGET-HANDLE(ENTRY(iDO,cObjectHandles)).
    
    IF cRowident <> '':U AND cRowident <> '?':U THEN
    DO:
      lSuccess  = DYNAMIC-FUNCTION('deleteRow':U IN hDataObject,cRowIdent).

      IF NOT lSuccess THEN
         RETURN FALSE.
    END.
  END. /* do ido to num-entries(objects) - 1 */
  
  
  /* We disabled outgoing dataAvailable messages while deleting if autocommit
     so set it back.  */    
  IF lAutoCommit THEN 
    {set BlockDataAvailable FALSE}.

  IF lSuccess = YES THEN
  DO:
    IF lAutoCommit THEN
    /* if there's no Commit-Source the changes will be committed now. */
    DO:
      RUN commitTransaction IN TARGET-PROCEDURE.
      RETURN RETURN-VALUE NE "ADM-ERROR":U.
    END.  /* END DO IF AutoCommit */
    ELSE {set RowObjectState 'RowUpdated':U}.
  END. /* do if lSuccess */
  ELSE RETURN FALSE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTargetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTargetProcedure Procedure 
FUNCTION getTargetProcedure RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Needed by toolbar to provide the actual caller object handle.
    Notes:  
------------------------------------------------------------------------------*/

  RETURN ghTargetProcedure.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newDataObjectRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newDataObjectRow Procedure 
FUNCTION newDataObjectRow RETURNS CHARACTER
  ( pcMode        AS CHARACTER,
    pcTargetNames AS CHARACTER,
    pcViewColList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Set one or more the SDOs in New (copy or add) mode.  
  Purpose: Returns a chr(1) separated list of RowIdent(s) (separated with 
           semicolon for each object) and values corresponding to the passed 
           list.  
   Params:  pcObjectNames 
                      - List of object names to set in add/copy mode  
            pcViewColList 
                      - List of columns qualifed with ObjectName or unqualified.
            pcMode    = Add / Copy                 
   Notes:  Columns must match the objects and be qualified with the correct object 
           name if they are qualified.
           Called from addRow and copyRow.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iEntry       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTarget      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRowids      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValueList   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumn      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iColumn      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cValue       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectNames AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lError       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cFunction    AS CHARACTER  NO-UNDO.

  IF NOT CAN-DO('Add,Copy':U,pcMode)  THEN
  DO:
    MESSAGE  "Function 'newMode()' called with invalid mode: '" pcMode "'."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN ?.
  END.
  
  cFunction = pcMode + 'Row':U. 

 /* We add in the SBOs object order, this also enablkes us to return the rowident 
    in submitRow order */
  {get DataObjectNames cObjectNames}.
  cRowids = FILL(';':U,NUM-ENTRIES(cObjectNames) - 1).
  DO iEntry = 1 TO NUM-ENTRIES(cObjectNames):
    ASSIGN
      cObjectName = ENTRY(iEntry,cObjectNames).
    
    /* Is this an updateTarget  */
    IF CAN-DO(pcTargetNames,cObjectName) THEN
    DO:      
    
      hTarget  = {fnarg DataObjectHandle cObjectName}.      
      
      IF NOT VALID-HANDLE(hTarget) THEN
      DO:
        lError = TRUE.
        LEAVE. /* leave the loop */ 
      END.
      /* If only one target all the fields belongs to the same object */   
      IF NUM-ENTRIES(pcTargetNames) = 1 THEN
      DO:
         /* Strip the SDO "tablename" qualifier because SDO addRow isn't
            expecting it. Make sure we don't replace a partial field name
            so replace ',<ObjectName.>' with ','. 
            This is about 4 to 10 times faster than a loop...  */ 
          ASSIGN
            pcViewColList = LEFT-TRIM(REPLACE(',':U + pcViewColList,
                                     /* Add comma to first entry so it is replaced */
                                             ',':U + cObjectName + '.':U,
                                             ','),
                                      ',':U) /* Trim off the first comma again */
        
            cValueList    = DYNAMIC-FUNC(cFunction IN hTarget, pcViewColList)
                       /* Put the rowid part of the returned colvalues in the rowid list*/ 
            ENTRY(iEntry,cRowids,';':U)  = ENTRY(1,cValueList) 
           /* then replace this list with the rowid part */
            ENTRY(1,cValueList,CHR(1)) = cRowids. 
          
          RETURN cValueList. /* We have all we need <---------------- */

      END. /* One target */
      ELSE DO: 
          /* We block dataAvailable while adding */
          {set BlockDataAvailable TRUE}. 

          ASSIGN  
           cRowids      = {fnarg addRow '':U hTarget}
           cValueList   = cValueList 
                          + (IF iEntry = 1 THEN "":U ELSE ";":U) 
                          + ENTRY(1,cRowids).
      END.
    END. /* Target found in entry( Sources )*/
    ELSE 
      cValueList  = cValueList 
                  + (IF iEntry = 1 THEN "":U ELSE ";":U) 
                  + '?':U.
  END. /* Do iEntry loop through DataObjectNames */
    
  /* Unblock dataAvailable again adding */
  {set BlockDataAvailable FALSE}. 
  
  IF lError THEN RETURN ?.
  
  /* All columns are qualifed if more than one Source, retrieve the value 
     from it. We only get down here if more than one target ann all of them were
     valid.   */
  DO iColumn = 1 TO NUM-ENTRIES(pcViewColList):
    ASSIGN cColumn     = ENTRY(iColumn,pcViewColList)
           cObjectName = ENTRY(1,cColumn,'.':U)
           cColumn     = ENTRY(2,cColumn,'.':U)
           hTarget     = {fnarg DataObjectHandle cObjectName}
           cValue      = {fnarg columnValue cColumn hTarget}
           cValueList  = cValueList + CHR(1)
                        + (IF cValue <> ? THEN cValue ELSE '?':U).
  END. /* do iColumn = 1 to */
  
  /* We need to ensure that potential GroupAssigntargets also get the new record
     so we cannot just run in requester. We cannot publish from SDOs either here
     because then add mode will be lost in datatargets if more than one is in addmode */
  PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ('DIFFERENT':U).

  RETURN cValueList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION openQuery Procedure 
FUNCTION openQuery RETURNS LOGICAL
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  This is just a wrapper for fetchContainedData, to allow the
            familiar SDO calling pattern to be used.
   Params:  <none>
------------------------------------------------------------------------------*/

  RUN fetchContainedData IN TARGET-PROCEDURE (?).
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION removeQuerySelection Procedure 
FUNCTION removeQuerySelection RETURNS LOGICAL
  ( pcColumns AS CHARACTER, 
    pcOperators AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  SBO version of this where-clause function, which separates the
            Columns by SDO and passes columns and operators on to
            the appropriate SDO(s).
   Params:  pcColumns   AS CHAR,
            pcOperators AS CHAR 
            -- both as for the query.p removeQuerySelection function
    Notes:  All columns must be qualified by their SDO Objectname as TableName;
            this will be replaced with RowObject when the columns are passed
            on to the SDO.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iColumn      AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cCols        AS CHARACTER   NO-UNDO INIT "":U.
  DEFINE VARIABLE cOps         AS CHARACTER   NO-UNDO INIT "":U.
  DEFINE VARIABLE cObjectNames AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cColumn      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iName        AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cString      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE lSuccess     AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE hObject      AS HANDLE      NO-UNDO.

  {get DataObjectNames cObjectNames}.
  DO iColumn = 1 TO NUM-ENTRIES(cObjectNames):
      /* Initialize these to hold the cols, values, and ops for each SDO. 
         Use a delimiter of CHR(2) between groups for each SDO. */
      cCols = cCols + (IF iColumn = 1 THEN "":U ELSE CHR(2)).
  END.            /* END DO iColumn -- initialization of delimiters */
  /* If the request specified an operator per column, then initialize
     accordingly; otherwise just store the one entry passed in to us. */
  IF NUM-ENTRIES (pcOperators) > 1 THEN
      cOps = cCols.
  ELSE cOps = pcOperators.

  /* Now go through all the columns passed and divide them up  
     by ObjectName. */
  DO iColumn = 1 TO NUM-ENTRIES(pcColumns):
      cColumn = ENTRY(iColumn, pcColumns).
      IF NUM-ENTRIES(cColumn, ".":U) NE 2 THEN
          RETURN FALSE.           /* Must be qualified by ObjectName */
      iName = LOOKUP(ENTRY(1, cColumn, ".":U), cObjectNames).
      IF iName = 0 THEN
          RETURN FALSE.
      /* First add the column to the right list, qualified as "RowObject" */
      ASSIGN cString = ENTRY(iName, cCols, CHR(2))
             cString = cString + (IF cString = "":U THEN "":U ELSE ",":U) +
                 "RowObject.":U + ENTRY(2, cColumn, ".":U)
             ENTRY(iName, cCols, CHR(2)) = cString.
       /* Now put the operator in its list, unless there's only one
          (or none) for the whole list). */
       IF NUM-ENTRIES(pcOperators) > 1 THEN
         ASSIGN cString = ENTRY(iName, cOps, CHR(2))
                cString = cString + (IF cString = "":U THEN "":U ELSE ",":U) 
                          + ENTRY(iColumn, pcOperators)
                ENTRY(iName, cOps, CHR(2)) = cString.           
  END.  /* END DO iColumn -- divide up columns per SDO. */

  DO iName = 1 TO NUM-ENTRIES(cObjectNames):
     cColumn = ENTRY(iName, cCols, CHR(2)).
     IF cColumn NE "":U THEN
     DO:
        ASSIGN hObject = DYNAMIC-FUNCTION('dataObjectHandle':U
                                          IN TARGET-PROCEDURE, 
                                          ENTRY(iName, cObjectNames))
               lSuccess = DYNAMIC-FUNCTION('removeQuerySelection':U IN
                                hObject,
                                INPUT ENTRY(iName, cCols, CHR(2)),
                                INPUT IF NUM-ENTRIES(pcOperators) <= 1 
                                      THEN pcOperators 
                                      ELSE ENTRY(iName, cOps, CHR(2))).
        IF NOT lSuccess THEN
          RETURN FALSE.
      END.          /* END DO if cColumns not "" */
  END.              /* END DO iName */

  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION resetQuery Procedure 
FUNCTION resetQuery RETURNS LOGICAL
  ( pcObject AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Resets the Query for all Contained SDOs, or if the pcObject
            parameter is specified, for that one SDO, to its original state
   Params:  pcObject AS CHARACTER -- SDO ObjectName
    Notes:  This function is here because setQueryWhere is not supported for
            SBOs, and running setQueryWhere('') would be the way to do it
            otherwise.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContained   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hObject      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iObject      AS INTEGER    NO-UNDO.
  
  IF pcObject = "":U OR pcObject = ? THEN
  DO:
    {get ContainedDataObjects cContained}.
    DO iObject = 1 TO NUM-ENTRIES(cContained):
       hObject = WIDGET-HANDLE(ENTRY(iObject, cContained)).
       DYNAMIC-FUNCTION('setQueryWhere':U IN hObject, '':U).
    END. /* DO iObject */
  END. /* DO if pcObject not specified. */
  ELSE DO:
    hObject = DYNAMIC-FUNCTION('dataObjectHandle':U IN TARGET-PROCEDURE,
                                pcObject).
    IF VALID-HANDLE(hObject) THEN
       DYNAMIC-FUNCTION('setQueryWhere':U IN hObject, '':U).
    ELSE RETURN FALSE.
  END.  /* END ELSE DO IF pcObject specified. */

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-submitRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION submitRow Procedure 
FUNCTION submitRow RETURNS LOGICAL
  ( pcRowIdent  AS CHARACTER, 
    pcValueList AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:     Accepts a list of changed values for a row and passes them
               on to the SDOs from which they came.
  Parameters:
    INPUT pcRowIdent  - "key" with RowObject rowid to update, plus a list of 
                        the ROWID(s) of the db record(s) the RowObject is 
                        derived from.
    INPUT pcValueList - CHR(1) delimited list of alternating column names 
                        and values to be assigned.             
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iSDO               AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hSDO               AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lSuccess           AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cValueList         AS CHARACTER NO-UNDO
      EXTENT {&MaxContainedDataObjects}.
  DEFINE VARIABLE iCol               AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cObjectName        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lAutoCommit        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cRowIdent          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cObjectNames       AS CHARACTER NO-UNDO.
  
  {get DataObjectNames cObjectNames}.

  /* If trim(';') removes all then we have only ONE rowid */ 
  IF NUM-ENTRIES(TRIM(pcRowIdent,';':U),';':U) = 1 THEN
  DO:
    /* If one target and the columns are qualified, remove the qualifier.*/
    IF NUM-ENTRIES(ENTRY(1, pcValueList, CHR(1)), ".":U) = 2 THEN
    DO iCol = 1 TO NUM-ENTRIES(pcValueList, CHR(1)) BY 2:
       ASSIGN cColumn = ENTRY(iCol, pcValueList, CHR(1))
              cColumn = ENTRY(2, cColumn, ".":U)
              ENTRY(iCol, pcValueList, CHR(1)) = cColumn.
    END.         /* END DO iCOL - remove qualifiers. */
  END. /* num-entries(cTargetNames) = 1 */
  
  /* Else if the values came from more than one SDO, we need to build up a 
     separate update list for each SDO, and pass that as the ValueList 
     parameter, along with the corresponding entry in the list of temp-table 
     rowids in RowIdent. */  
  ELSE 
  DO iCol = 1 TO NUM-ENTRIES(pcValueList,CHR(1)) BY 2:
    cColumn = ENTRY(iCol, pcValueList, CHR(1)).
    
    /* Column names are qualified so use that to find SDO. */
    ASSIGN cObjectName = ENTRY(1, cColumn, ".":U)
           iSDO        = LOOKUP(cObjectName,cObjectNames)
           cColumn     = ENTRY(2, cColumn, ".":U) NO-ERROR. 

    IF iSDO > 0 THEN
     /* Found a match. Add the name/value pair to the list for that SDO. */
      cValueList[iSDO] = cValueList[iSDO] 
                       + (IF cValueList[iSDO] NE "":U THEN CHR(1) ELSE "":U)
                       + cColumn 
                       + CHR(1) 
                       + ENTRY(iCol + 1, pcValueList,CHR(1)).

    ELSE DO:
      DYNAMIC-FUNCTION('showMessage':U IN TARGET-PROCEDURE,
         "Unable to update column ":U + "'":U 
          + cObjectName + ".":U + cColumn + "'.":U + CHR(10) +
         "Object '" + cObjectName + "' is either not available or not updatable").
      RETURN FALSE.
    END. /* else do (SDO not found), */
  END. /* else do (more than one target) */
  
  {get AutoCommit lAutoCommit}.
  /* if autocommit commitTransaction will run dataavailable in targets 
     so just block outgoing */
  IF lAutoCommit THEN 
    {set BlockDataAvailable TRUE}.
  /* Now loop through all the Objects and update when we find the target(s)
     We do this in objectnames order so we can submit foreignfields  */ 
  DO iSDO = 1 TO NUM-ENTRIES(pcRowident,';':U):
    cRowIdent = ENTRY(iSDO,pcRowIdent,";":U).
    IF cRowIdent <> '':U THEN
    DO:
      ASSIGN
        cObjectName = ENTRY(iSDO,cObjectNames)
        hSDO = {fnarg DataObjectHandle cObjectName}.
      
      IF NOT VALID-HANDLE(hSDO) THEN
        RETURN FALSE.

      /* If one target the data are still in the input parameter 
         (qualifiers were removed further up)*/
      IF NUM-ENTRIES(TRIM(pcRowIdent,';':U),';':U) = 1 THEN
      DO:
        lSuccess = DYNAMIC-FUNCTION('submitRow':U IN hSDO,
                                   cRowIdent, 
                                   pcValueList).
        LEAVE. /* no need to loop any more */
      END.
      ELSE DO:
        /* Multiple targets */
        IF cRowIdent <> '?':U THEN
          lSuccess  = DYNAMIC-FUNCTION('submitRow':U IN hSDO,
                                        cRowIdent,
                                        cValueList[iSDO]).              
        IF NOT lSuccess THEN
          RETURN FALSE.
      END. /* else do (multiple targets) */
    END.  /* can-do(cTargetNames,cObjectName) */
  END. /* do iSDO  */
  
  IF NOT lSuccess THEN
    RETURN FALSE.

  IF lAutoCommit = YES THEN
  /* if there's no Commit-Source the changes will be committed now. */
  DO:
    /* We disabled outgoing messages while updating if autocommit so set 
       it back */ 
    {set BlockDataAvailable FALSE}.

    RUN commitTransaction IN TARGET-PROCEDURE.
    RETURN RETURN-VALUE NE "ADM-ERROR":U.
  END.                    /* END DO IF AutoCOmmit */
  /* else signal Commit panel and others that there are uncommitted changes. */
  ELSE 
     {set RowObjectState 'RowUpdated':U}.  
  
  RETURN lSuccess.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

