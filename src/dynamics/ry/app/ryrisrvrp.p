&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
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
/*---------------------------------------------------------------------------------
  File: ryrisrv.p

  Description:  Referential Integrity Manager

  Purpose:      Referential Integrity Manager

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    aaa
                Date:   07/21/2002  Author:     aaa

  Update Notes: Created from Template rytemplipp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ryrisrvrp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{src/adm2/globals.i}

  DEFINE TEMP-TABLE ttEntity       NO-UNDO 
    LIKE gsc_entity_mnemonic .

  DEFINE TEMP-TABLE ttDSEntity     NO-UNDO
    LIKE gsc_dataset_entity 
    FIELD cParentJoinString AS CHARACTER
    FIELD cChildJoinString  AS CHARACTER
    FIELD cParentJoinFields AS CHARACTER
    FIELD cChildJoinFields  AS CHARACTER
    FIELD cParentReplace    AS CHARACTER
    FIELD cChildReplace     AS CHARACTER
    .

  DEFINE VARIABLE gdSiteNo  AS DECIMAL DECIMALS 9   NO-UNDO.  /* Global site number */
  DEFINE VARIABLE glSiteSet AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getFieldStringValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldStringValue Procedure 
FUNCTION getFieldStringValue RETURNS CHARACTER
  ( INPUT phField AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSiteMantissa) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSiteMantissa Procedure 
FUNCTION getSiteMantissa RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-replaceWhereTokens) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD replaceWhereTokens Procedure 
FUNCTION replaceWhereTokens RETURNS CHARACTER
  ( INPUT pcJoinString  AS CHARACTER,
    INPUT pcReplaceList AS CHARACTER,
    INPUT phBuffer1     AS HANDLE,
    INPUT phBuffer2     AS HANDLE)  FORWARD.

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
         HEIGHT             = 26.91
         WIDTH              = 56.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-buildDSWhereClause) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildDSWhereClause Procedure 
PROCEDURE buildDSWhereClause :
/*------------------------------------------------------------------------------
  Purpose:     Sets up the where clauses for a dataset entity. This call is
               generally made from cacheDatasetInfo so that it does not
               need to take place every time the triggers fire.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE PARAMETER BUFFER bttDSEntity FOR ttDSEntity.
  DEFINE BUFFER bttParentEntity       FOR ttEntity.
  DEFINE BUFFER bttChildEntity        FOR ttEntity.

  DEFINE VARIABLE cParentWhere   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChildWhere    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentReplace AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChildReplace  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iChildCount    AS INTEGER    NO-UNDO.

  /* If this is the primary entity, we should do nothing */
  IF bttDSEntity.primary_entity THEN
    RETURN.

  /* First find the entities for both the parent and the child. */
  FIND FIRST bttParentEntity 
    WHERE bttParentEntity.entity_mnemonic = bttDSEntity.join_entity_mnemonic.

  FIND FIRST bttChildEntity
    WHERE bttChildEntity.entity_mnemonic = bttDSEntity.entity_mnemonic.

  /* Now create the where clause for the find of the parent record.
     You can always do a singleton find on the parent record as we assume
     a one-to-many relationship. */
  cParentWhere = "":U.
  DO iCount = 1 TO NUM-ENTRIES(cParentJoinFields):
    ASSIGN
      cParentWhere   = cParentWhere + (IF cParentWhere = "":U THEN "":U ELSE " AND ":U)
                     + ENTRY(iCount,cParentJoinFields) + " = ":U 
                     + "#":U + STRING(iCount,"99":U) + "#":U
      cParentReplace = cParentReplace + (IF cParentReplace = "":U THEN "":U ELSE ",":U)
                     + ENTRY(iCount,cChildJoinFields)
    .
  END.
  IF cParentWhere <> "":U THEN
  DO:
    ASSIGN
      bttDSEntity.cParentJoinString = "WHERE ":U + cParentWhere
      bttDSEntity.cParentReplace    = cParentReplace
    .
  END.

  /* Now build the child where clause */
  cChildWhere = "":U.
  iChildCount = 0.
  /* We need to include the obj field and key field if we can so that we can make
     sure that we can find the child record that we came from. */
  IF bttChildEntity.table_has_obj THEN
  DO:
    ASSIGN
      iChildCount    = iChildCount + 1
      cChildWhere    = cChildWhere + (IF cChildWhere = "":U THEN "":U ELSE " AND ":U)
                     + bttChildEntity.entity_object_field + " = ":U 
                     + "#":U + STRING(iChildCount,"99":U) + "#":U
      cChildReplace  = cChildReplace + (IF cChildReplace = "":U THEN "":U ELSE ",":U)
                     + "c.":U +  bttChildEntity.entity_object_field
    .
  END.

  IF bttChildEntity.entity_key_field <> "":U THEN
  DO:
    DO iCount = 1 TO NUM-ENTRIES(bttChildEntity.entity_key_field):
      /* If we've already included this field in the list, skip it */
      IF CAN-DO(cChildReplace,"c.":U + ENTRY(iCount,bttChildEntity.entity_key_field)) THEN
        NEXT.

      ASSIGN
        iChildCount    = iChildCount + 1
        cChildWhere    = cChildWhere + (IF cChildWhere = "":U THEN "":U ELSE " AND ":U)
                       + ENTRY(iCount,bttChildEntity.entity_key_field) + " = ":U 
                       + "#":U + STRING(iChildCount,"99":U) + "#":U
        cChildReplace  = cChildReplace + (IF cChildReplace = "":U THEN "":U ELSE ",":U)
                       + "c.":U + ENTRY(iCount,bttChildEntity.entity_key_field)
      .
    END.
  END.

  /* Now loop through all the join fields and add them to the list */
  DO iCount = 1 TO NUM-ENTRIES(cChildJoinFields):
    ASSIGN
      iChildCount    = iChildCount + 1
      cChildWhere    = cChildWhere + (IF cChildWhere = "":U THEN "":U ELSE " AND ":U)
                     + ENTRY(iCount,cChildJoinFields) + " = ":U 
                     + "#":U + STRING(iChildCount,"99":U) + "#":U
      cChildReplace  = cChildReplace + (IF cChildReplace = "":U THEN "":U ELSE ",":U)
                     + ENTRY(iCount,cParentJoinFields)
    .
  END.

  /* If the filter where clause is not empty, we need to add it and the key fields
     to the where so that we can find the child record from the parent. */
  IF bttDSEntity.filter_where_clause <> "":U THEN
  DO:
    ASSIGN
      cChildWhere = cChildWhere + (IF cChildWhere = "":U THEN "":U ELSE " AND ":U)
                  + bttDSEntity.filter_where_clause
    .
  END.
  IF cChildWhere <> "":U THEN
  DO:
    ASSIGN
      bttDSEntity.cChildJoinString = "WHERE ":U + cChildWhere
      bttDSEntity.cChildReplace    = cChildReplace
    .
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cacheDatasetInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cacheDatasetInfo Procedure 
PROCEDURE cacheDatasetInfo :
/*------------------------------------------------------------------------------
  Purpose:     Retrieves all the dataset definitions from the repository and
               constructs a cache of them so that they can be quickly retrieved
               at run time. 
  Parameters:  <none>
  Notes:       
    We only cache datasets that are used by an entity to do data versioning.
    As other datasets are used, this data will be cached as required.
------------------------------------------------------------------------------*/
  DEFINE BUFFER bgsc_dataset_entity  FOR gsc_dataset_entity.
  DEFINE BUFFER bgsc_deploy_dataset  FOR gsc_deploy_dataset.
  DEFINE BUFFER bttDSEntity          FOR ttDSEntity.

  DEFINE VARIABLE lEntityExists AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCount        AS INTEGER    NO-UNDO.

  EMPTY TEMP-TABLE ttDSEntity.

  /* We're only going to cache datasets that are used for RI.
     That means datasets that have the enable_data_versioning flag switched on */
  FOR EACH bgsc_deploy_dataset NO-LOCK
    WHERE bgsc_deploy_dataset.enable_data_versioning = YES:

    /* Now loop through all the related dataset entities. */
    FOR EACH bgsc_dataset_entity NO-LOCK
      WHERE bgsc_dataset_entity.deploy_dataset_obj = bgsc_deploy_dataset.deploy_dataset_obj:

      CREATE bttDSEntity.
      BUFFER-COPY bgsc_dataset_entity TO bttDSEntity.

      /* Split out the key fields so that we know that they are easy to read and that they are
         valid. We're not interested in the primary table as it has no relationships upwards. */
      IF NOT bttDSEntity.primary_entity THEN
      DO:
        DO iCount = 1 TO NUM-ENTRIES(bttDSEntity.join_field_list) BY 2:
          ASSIGN
            bttDSEntity.cParentJoinFields = bttDSEntity.cParentJoinFields 
                                          + (IF bttDSEntity.cParentJoinFields = "":U THEN "":U ELSE ",":U)
                                          + ENTRY(iCount + 1,bttDSEntity.join_field_list)
            bttDSEntity.cChildJoinFields  = bttDSEntity.cChildJoinFields
                                          + (IF bttDSEntity.cChildJoinFields = "":U THEN "":U ELSE ",":U)
                                          + ENTRY(iCount,bttDSEntity.join_field_list)
          .                      
        END.
        /* Build up the where clauses on this record so that we don't need to do
           this every time we update the record */
        IF NOT bttDSEntity.primary_entity THEN
          RUN buildDSWhereClause IN TARGET-PROCEDURE (BUFFER bttDSEntity).

      END.

    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cacheEntityInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cacheEntityInfo Procedure 
PROCEDURE cacheEntityInfo :
/*------------------------------------------------------------------------------
  Purpose:     Reads all the entities from the database and stores their info
               in cache to prevent having to re-fetch them from the database.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE BUFFER bgsc_entity_mnemonic FOR gsc_entity_mnemonic.
  DEFINE BUFFER bttEntity            FOR ttEntity.

  /* Loop through all the entity mnemonics and load them into the temp-table */
  FOR EACH bgsc_entity_mnemonic NO-LOCK:
    CREATE bttEntity.
    BUFFER-COPY bgsc_entity_mnemonic TO bttEntity.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-calcLastVersionNo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcLastVersionNo Procedure 
PROCEDURE calcLastVersionNo :
/*------------------------------------------------------------------------------
  Purpose:     This procedure calculates the value of the last version number
               field that is used to increment the version number sequence.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT        PARAMETER pdeVersionNoSeq       AS DECIMAL    NO-UNDO.
  DEFINE INPUT        PARAMETER pdeImportVerNoSeq     AS DECIMAL    NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pdeLastVersion        AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE dLastVer   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dImpVer    AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dVerNo     AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dMaxVer    AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dLastSeq   AS DECIMAL    NO-UNDO.
  
  /* Need to verify that the last_version_number_seq was defined at this site. */
  IF (ABS(pdeLastVersion) - TRUNCATE(ABS(pdeLastVersion),0)) <> gdSiteNo THEN
  DO:
    /* Lets make sure that the last_version_number_seq is for this site and that its value is greater than anything
       in the current version number seq or import_version_number_seq fields.*/
    ASSIGN
      dImpVer = 0
      dLastVer = 0
      dVerNo = 0
      dMaxVer = 0
    .

    /* If the version_number_seq is of this site number, lets store the last away */
    IF (ABS(pdeVersionNoSeq) - TRUNCATE(ABS(pdeVersionNoSeq),0)) = gdSiteNo THEN
      dVerNo = TRUNCATE(ABS(pdeVersionNoSeq),0).

    /* If the import_version_number_seq is of this site number, lets store the last away */
    IF (ABS(pdeImportVerNoSeq) - TRUNCATE(ABS(pdeImportVerNoSeq),0)) = gdSiteNo THEN
      dImpVer = TRUNCATE(ABS(pdeImportVerNoSeq),0).

    /* Figure out the last version number seq' top value, and what we expect the highest value to be.*/
    ASSIGN
      dLastVer = INTEGER(ABS(pdeLastVersion))
      dMaxVer  = MAXIMUM(dVerNo,dImpVer,dLastVer)
      dLastSeq = dMaxVer + gdSiteNo
      pdeLastVersion = dLastSeq + 1
    .
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-calcRVKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcRVKey Procedure 
PROCEDURE calcRVKey :
/*------------------------------------------------------------------------------
  Purpose:     Calculates the strings to be stored in the record versioning
               key_field_value and secondary_key_value fields.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER plTableHasObj            AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcObjField               AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcKeyField               AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phBuffer                 AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER pcFieldValue             AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcSecondaryValue         AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hField                           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount                           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cKeyField                        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSecondaryKey                    AS CHARACTER  NO-UNDO.

  ASSIGN
    pcFieldValue     = "":U
    pcSecondaryValue = "":U
    hField = ?
    .

  /* Set up the appropriate key fields and secondary key fields */
  IF plTableHasObj AND
     pcKeyField <> "":U  THEN
    ASSIGN 
      cKeyField     = pcObjField
      cSecondaryKey = pcKeyField
    .
  ELSE
    ASSIGN 
      cKeyField     = pcObjField
      cSecondaryKey = "":U
    .
  /* If bgsc_entity_mnemonic.entity_key_field represents a multi-field identifier,then cKeyField will 
     contain a comma-seperated list of field names. In that case, build a pcFieldValue based 
     on the field list*/
  pcFieldValue = "":U.
  IF cKeyField <> "":U THEN
  DO:
    IF NUM-ENTRIES(cKeyField) >= 2 THEN
    DO iCount = 1 TO NUM-ENTRIES(cKeyField):
      ASSIGN
        hField  = phBuffer:BUFFER-FIELD(ENTRY(iCount,cKeyField)) NO-ERROR.
      IF VALID-HANDLE(phBuffer) AND VALID-HANDLE(hField) AND phBuffer:AVAILABLE THEN
        ASSIGN
          pcFieldValue = pcFieldValue + CHR(1) WHEN pcFieldValue <> "":U
          pcFieldValue = pcFieldValue + getFieldStringValue(hField).
    END.
    ELSE 
    DO:
      ASSIGN
        hField  = phBuffer:BUFFER-FIELD(cKeyField) NO-ERROR
        .       
      IF VALID-HANDLE(phBuffer) AND VALID-HANDLE(hField) AND phBuffer:AVAILABLE THEN
        ASSIGN
          pcFieldValue = getFieldStringValue(hField).
    END.
  END.

  /* If bgsc_entity_mnemonic.entity_key_field represents a multi-field identifier,then cKeyField will 
    contain a comma-seperated list of field names. In that case, build a pcFieldValue based 
    on the field list*/
  pcSecondaryValue = "":U.
  IF cSecondaryKey <> "":U THEN
  DO:
    IF NUM-ENTRIES(cSecondaryKey) >= 2 THEN
    DO iCount = 1 TO NUM-ENTRIES(cSecondaryKey):
      ASSIGN
        hField  = phBuffer:BUFFER-FIELD(ENTRY(iCount,cSecondaryKey)) NO-ERROR.
      IF VALID-HANDLE(phBuffer) AND VALID-HANDLE(hField) AND phBuffer:AVAILABLE THEN
        ASSIGN
          pcSecondaryValue = pcSecondaryValue + CHR(1) WHEN pcSecondaryValue <> "":U
          pcSecondaryValue = pcSecondaryValue + getFieldStringValue(hField).
    END.
    ELSE DO:
      ASSIGN
        hField  = phBuffer:BUFFER-FIELD(cSecondaryKey) NO-ERROR
        .       
      IF VALID-HANDLE(phBuffer) AND VALID-HANDLE(hField) AND phBuffer:AVAILABLE THEN
        ASSIGN
          pcSecondaryValue = getFieldStringValue(hField).
    END.
  END.
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

&IF DEFINED(EXCLUDE-objectDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription Procedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.

ASSIGN cDescription = "Dynamics Template PLIP".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainVersionBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtainVersionBuffer Procedure 
PROCEDURE obtainVersionBuffer :
/*------------------------------------------------------------------------------
  Purpose:     Finds a parent record on which data versioning should take place.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE PARAMETER BUFFER bttDSEntity        FOR ttDSEntity.
  DEFINE INPUT  PARAMETER phBuffer           AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER pcBufferFLA        AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER phVersionBuffer    AS HANDLE     NO-UNDO.

  DEFINE BUFFER bttParentEntity   FOR ttEntity.
  DEFINE BUFFER bttChildEntity    FOR ttEntity.
  DEFINE BUFFER bttParentDSEntity FOR ttDSEntity.

  DEFINE VARIABLE hParentBuffer AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hChildBuffer  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cParentTable  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChildTable   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentWhere  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChildWhere   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAns          AS LOGICAL    NO-UNDO.

  /* Now we build up the where clause that we will use for the find */
  cParentWhere = replaceWhereTokens(bttDSEntity.cParentJoinString, 
                                    bttDSEntity.cParentReplace,
                                    phBuffer,
                                    ?).

  IF cParentWhere = "":U OR 
     cParentWhere = ? THEN
    RETURN.

  /* Let's find the parent dataset entity as we will need this to determine whether
     this is the primary entity in the dataset, and to pass it on in the recursive
     call later. */
  FIND FIRST bttParentDSEntity NO-LOCK
    WHERE bttParentDSEntity.deploy_dataset_obj = bttDSEntity.deploy_dataset_obj
      AND bttParentDSEntity.entity_mnemonic    = bttDSEntity.join_entity_mnemonic
    NO-ERROR.

  IF NOT AVAILABLE(bttParentDSEntity) THEN
    RETURN.
  
  /* Find the parent entity mnemonic to construct the buffer name */
  FIND FIRST bttParentEntity NO-LOCK
    WHERE bttParentEntity.entity_mnemonic = bttDSEntity.join_entity_mnemonic
    NO-ERROR.

  IF NOT AVAILABLE(bttParentEntity) THEN
    RETURN.
  
  /* Construct the buffer name */
  IF bttParentEntity.entity_dbname <> "":U AND 
     CONNECTED(bttParentEntity.entity_dbname) THEN
    cParentTable = bttParentEntity.entity_dbname + ".":U 
                 + bttParentEntity.entity_mnemonic_description.
  ELSE
    cParentTable = bttParentEntity.entity_mnemonic_description.

  /* Create a buffer for the parent record */
  CREATE BUFFER hParentBuffer FOR TABLE cParentTable NO-ERROR.

  ERROR-STATUS:ERROR = NO.
  IF NOT VALID-HANDLE(hParentBuffer) THEN
    RETURN.

  /* Try and find the parent record using the parent where clause */
  lAns = hParentBuffer:FIND-FIRST(cParentWhere, NO-LOCK) NO-ERROR.
  ERROR-STATUS:ERROR = NO.

  /* If there is no parent record, there is no error and we return. Using the dataset 
     mechanism we do not know if this is an outer join so we can't return an error */
  IF NOT hParentBuffer:AVAILABLE THEN
  DO:
    DELETE OBJECT hParentBuffer.
    RETURN.
  END.

  /* At this point, we have found the appropriate record. Now what we need to do is
     make sure that the parent to child join gets us the same record. If not, there 
     we have an invalid join back. */

  /* Find the entity so we can set up the table name */
  FIND FIRST bttChildEntity NO-LOCK
    WHERE bttChildEntity.entity_mnemonic = bttDSEntity.entity_mnemonic
    NO-ERROR.

  IF NOT AVAILABLE(bttChildEntity) THEN
    RETURN.

  /* Construct the buffer name */
  IF bttChildEntity.entity_dbname <> "":U AND 
     CONNECTED(bttChildEntity.entity_dbname) THEN
    cChildTable = bttChildEntity.entity_dbname + ".":U 
                 + bttChildEntity.entity_mnemonic_description.
  ELSE
    cChildTable = bttChildEntity.entity_mnemonic_description.


  /* Now we need to build up the parent to child where clause so that
     we can make sure that the record that we have in the child buffer is
     the right one. */
  cChildWhere  = replaceWhereTokens(bttDSEntity.cChildJoinString, 
                                    bttDSEntity.cChildReplace,
                                    hParentBuffer,
                                    phBuffer).

  /* If the where clause is valid, we need to try and find the record. */
  IF cChildWhere <> "":U AND
     cChildWhere <> ? THEN
  DO:
    /* Create a buffer for the parent record */
    CREATE BUFFER hChildBuffer FOR TABLE cChildTable NO-ERROR.

    ERROR-STATUS:ERROR = NO.
    IF NOT VALID-HANDLE(hChildBuffer) THEN
      RETURN.

    /* Try and find the parent record using the parent where clause */
    lAns = hChildBuffer:FIND-FIRST(cChildWhere, NO-LOCK) NO-ERROR.
    ERROR-STATUS:ERROR = NO.

    /* If there is no parent record, there is no error and we return. Using the dataset 
       mechanism we do not know if this is an outer join so we can't return an error */
    IF NOT hChildBuffer:AVAILABLE OR
       hChildBuffer:ROWID <> phBuffer:ROWID THEN
    DO:
      /* Check to see if we're in a delete...  This is indicated by the fact that
         the child record no longer exists in the database.  If the record was not
         deleted, that simply means the key has changed. */
      IF phBuffer:ROWID NE ? THEN
        hChildBuffer:FIND-BY-ROWID(phBuffer:ROWID, NO-LOCK) NO-ERROR.
      IF hChildBuffer:AVAILABLE THEN DO:
        DELETE OBJECT hParentBuffer.
        DELETE OBJECT hChildBuffer.
        RETURN.
      END.
    END.

    DELETE OBJECT hChildBuffer.
  END.

  /* If we get this far, we need to figure out if the parent record is the primary entity.
     If not, we need to run this procedure recursively. */
  IF bttParentDSEntity.primary_entity THEN
    ASSIGN
      pcBufferFLA     = bttParentDSEntity.entity_mnemonic
      phVersionBuffer = hParentBuffer
    .
  ELSE
  DO:
    RUN obtainVersionBuffer IN TARGET-PROCEDURE
      (BUFFER bttParentDSEntity,
       hParentBuffer,
       OUTPUT pcBufferFLA,
       OUTPUT phVersionBuffer).
    DELETE OBJECT hParentBuffer.
    RETURN.
  END.

  
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
  /* Setup the site number if you can */
  RUN setupSiteNo IN TARGET-PROCEDURE.

  /* Cache all the entities */
  RUN cacheEntityInfo IN TARGET-PROCEDURE.
  
  /* Cache all the Datasets */
  RUN cacheDatasetInfo IN TARGET-PROCEDURE.

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

{ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-reuseObjectID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reuseObjectID Procedure 
PROCEDURE reuseObjectID :
/*------------------------------------------------------------------------------
  Purpose:     This procedure attempts to reuse an object ID based on the 
               the key value provided for a key if a record can be found in the
               gst_record_version table.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcFLA                    AS CHARACTER    NO-UNDO.  
  DEFINE INPUT PARAMETER phBuffer                 AS HANDLE       NO-UNDO.

  DEFINE BUFFER bttEntity             FOR ttEntity.
  DEFINE BUFFER bgst_record_version   FOR gst_record_version.

  DEFINE VARIABLE cCurrNumSep     AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cCurrNumDec     AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cKeyField       AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cFieldValue     AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE hField          AS HANDLE               NO-UNDO.
  DEFINE VARIABLE hObjField       AS HANDLE               NO-UNDO.
  DEFINE VARIABLE dObjValue       AS DECIMAL DECIMALS 9   NO-UNDO.
  DEFINE VARIABLE iCount          AS INTEGER              NO-UNDO.

  /* Find the entity mnemonic record */
  FIND bttEntity NO-LOCK
    WHERE bttEntity.entity_mnemonic = pcFLA
    NO-ERROR.

  /* If the entity mnemonic is not available or reuse_deleted_keys is NO we 
     have nothing to do so just return */
  IF NOT AVAILABLE(bttEntity) OR
     NOT bttEntity.reuse_deleted_keys OR
     NOT bttEntity.table_has_object_field THEN
  DO:
    ERROR-STATUS:ERROR = NO.
    RETURN.
  END.

  /* Now we have to get hold of the data versioning record if there is one. To do
     this we have to build up the key. */
  ASSIGN
    cKeyField     = bttEntity.entity_key_field
    cFieldValue   = "":U
    hField        = ?
    .
  
  ERROR-STATUS:ERROR = NO.
  hObjField = phBuffer:BUFFER-FIELD(bttEntity.entity_object_field) NO-ERROR.
  IF ERROR-STATUS:ERROR OR
     NOT VALID-HANDLE(hObjField) THEN
  DO:
    ERROR-STATUS:ERROR = NO.
    RETURN.
  END.

  /* If the key field represents a multi-field identifier,then cKeyField will 
     contain a comma-seperated list of field names. In that case, build a cFieldvalue based 
     on the field list*/
  IF cKeyField <> "":U THEN
  DO:
    IF NUM-ENTRIES(cKeyField) >= 2 THEN
    DO iCount = 1 TO NUM-ENTRIES(cKeyField):
      ASSIGN
        hField  = phBuffer:BUFFER-FIELD(ENTRY(iCount,cKeyField)) NO-ERROR.
      IF VALID-HANDLE(phBuffer) AND VALID-HANDLE(hField) AND phBuffer:AVAILABLE THEN
        ASSIGN
          cFieldValue = cFieldValue + CHR(1) WHEN cFieldValue <> "":U
          cFieldValue = cFieldValue + getFieldStringValue(hField).
    END.
    ELSE 
    DO:
      ASSIGN
        hField  = phBuffer:BUFFER-FIELD(cKeyField) NO-ERROR
        .       
      IF VALID-HANDLE(phBuffer) AND 
         VALID-HANDLE(hField)   AND 
         phBuffer:AVAILABLE THEN
        ASSIGN
          cFieldValue = getFieldStringValue(hField).
    END.
  END.

  /* Find the gst_record_version for this record if possible */
  FIND FIRST bgst_record_version EXCLUSIVE-LOCK
     WHERE bgst_record_version.entity_mnemonic = pcFLA
       AND bgst_record_version.secondary_key_value = cFieldValue
     NO-ERROR.

  /* If the record version record is available we need to set the obj value */
  IF AVAILABLE(bgst_record_version) THEN
  DO:
    cCurrNumSep = SESSION:NUMERIC-SEPARATOR.
    cCurrNumDec = SESSION:NUMERIC-DECIMAL-POINT.
    SESSION:SET-NUMERIC-FORMAT(",":U,".":U).
    dObjValue = DECIMAL(bgst_record_version.key_field_value).
    SESSION:SET-NUMERIC-FORMAT(cCurrNumSep,cCurrNumDec).
    IF dObjValue <> 0.0 AND
       dObjValue <> ? THEN
    DO:
      ASSIGN
        hObjField:BUFFER-VALUE = dObjValue
        bgst_record_version.deletion_flag = NO
      .
    END.
  END.

  ERROR-STATUS:ERROR = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setupSiteNo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setupSiteNo Procedure 
PROCEDURE setupSiteNo :
/*------------------------------------------------------------------------------
  Purpose:     Obtains the site number for this repository so we don't have to
               do it on every iterations.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cSite       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cConvSite   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iNumChar    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSeqSiteDiv AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSeqSiteRev AS INTEGER    NO-UNDO.

  ERROR-STATUS:ERROR = NO.
  RUN getSiteNumber IN gshGenManager
    (OUTPUT iSeqSiteRev) NO-ERROR.

  IF ERROR-STATUS:ERROR THEN
  DO:
    ERROR-STATUS:ERROR = NO.
    RETURN.
  END.

  /* Switch it round so we can put the right stuff
     in the mantissa of the version number seq */
  cSite = STRING(iSeqSiteRev).
  iSeqSiteDiv = 1.
  DO iNumChar = LENGTH(cSite) TO 1 BY -1:
    cConvSite = cConvSite + SUBSTRING(cSite,iNumChar,1).
    iSeqSiteDiv = iSeqSiteDiv * 10.
  END.

  iSeqSiteRev = INTEGER(cConvSite).

  gdSiteNo  = iSeqSiteRev / iSeqSiteDiv.
  glSiteSet = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-versionData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE versionData Procedure 
PROCEDURE versionData :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is responsible for versioning the data that is
               to be deployed.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phBuffer                 AS HANDLE       NO-UNDO.
  DEFINE INPUT PARAMETER pcFLA                    AS CHARACTER    NO-UNDO.  
  DEFINE INPUT PARAMETER pcAction                 AS CHARACTER    NO-UNDO.   

  DEFINE VARIABLE hVersionBuffer                  AS HANDLE       NO-UNDO.
  DEFINE VARIABLE cBufferFLA                      AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cAction                         AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cFieldValue                     AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cSecondaryValue                 AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE hField                          AS HANDLE       NO-UNDO.
  DEFINE VARIABLE iCount                          AS INTEGER      NO-UNDO.
  DEFINE VARIABLE cErrorText                      AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cUserLogin                      AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lDynBuff                        AS LOGICAL      NO-UNDO.

  DEFINE BUFFER bttDSEntity         FOR ttDSEntity.
  DEFINE BUFFER bttEntity           FOR ttEntity.
  DEFINE BUFFER bgst_record_version FOR gst_record_version.

  IF NOT glSiteSet THEN
    RUN setupSiteNo IN TARGET-PROCEDURE.

  /* Get the current user's login - we'll need this later and it's cheaper
     to do it once here than on every iteration of record that we need to update */
  cUserLogin = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                INPUT "currentUserLogin":U,
                                INPUT NO).


  /* Loop through all the dataset entities for this entity and make sure that 
     we version each of the parent records. */
  FOR EACH bttDSEntity NO-LOCK
    WHERE bttDSEntity.entity_mnemonic = pcFLA:
    lDynBuff = NO.

    /* If this is the primary entity, we need to version this record */
    IF bttDSEntity.primary_entity THEN
    DO:
      ASSIGN
        cBufferFLA     = pcFLA
        hVersionBuffer = phBuffer
        cAction        = pcAction
      .
    END.
    ELSE /* If this is not the primary entity, we need to find the primary entity */
    DO:
      RUN obtainVersionBuffer IN TARGET-PROCEDURE
        (BUFFER bttDSEntity,
         INPUT phBuffer,
         OUTPUT cBufferFLA, 
         OUTPUT hVersionBuffer). 
      cAction = "write":U.
      lDynBuff = YES.
    END.

    /* We don't do any versioning if the version buffer is not valid */
    IF NOT VALID-HANDLE(hVersionBuffer) THEN
      NEXT.

    /* Find the entity record and make sure we need to version data on this record. */
    FIND FIRST bttEntity NO-LOCK
      WHERE bttEntity.entity_mnemonic = cBufferFLA
      NO-ERROR. 
    IF NOT AVAILABLE (bttEntity) OR 
       bttEntity.version_data = NO THEN
      NEXT.

    /* Now figure out what the key values are based on the new key criteria */
    RUN calcRVKey
      (bttEntity.table_has_object_field,
       bttEntity.entity_object_field,
       bttEntity.entity_key_field,
       INPUT hVersionBuffer,
       OUTPUT cFieldValue,
       OUTPUT cSecondaryValue).

    /* At this point, let's write the versioning information away */
    IF VALID-HANDLE(hVersionBuffer) AND 
       hVersionBuffer:AVAILABLE AND 
      cFieldValue <> "":U THEN
    DO:
      trn-block:
      DO FOR bgst_record_version TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:
        FIND FIRST bgst_record_version EXCLUSIVE-LOCK
             WHERE bgst_record_version.entity_mnemonic = cBufferFLA
               AND bgst_record_version.key_field_value = cFieldValue
             NO-ERROR.
        IF NOT AVAILABLE bgst_record_version THEN
        DO:
          CREATE bgst_record_version NO-ERROR.
          {af/sup2/afcheckerr.i &no-return = YES}    
          cErrorText = cMessageList.
          IF cErrorText <> "":U THEN UNDO trn-block, LEAVE trn-block.
          /* Seed the last version number with the site number */
          ASSIGN
            bgst_record_version.last_version_number_seq = gdSiteNo
            .
        END.

        RUN calcLastVersionNo
          (INPUT        bgst_record_version.version_number_seq,
           INPUT        bgst_record_version.import_version_number_seq,
           INPUT-OUTPUT bgst_record_version.last_version_number_seq).

        ASSIGN
          bgst_record_version.entity_mnemonic = cBufferFLA
          bgst_record_version.key_field_value = cFieldValue
          bgst_record_version.secondary_key_value = cSecondaryValue
          bgst_record_version.last_version_number_seq = bgst_record_version.last_version_number_seq + 1
          bgst_record_version.version_number_seq = bgst_record_version.last_version_number_seq
          bgst_record_version.version_date = TODAY
          bgst_record_version.version_time = TIME
          bgst_record_version.version_user = cUserLogin
          bgst_record_version.deletion_flag = (INDEX(cAction,"delete":U) <> 0)
          .          

        VALIDATE bgst_record_version NO-ERROR.
        {af/sup2/afcheckerr.i &no-return = YES}    
        cErrorText = cMessageList.
        IF cErrorText <> "":U THEN UNDO trn-block, LEAVE trn-block.

      END. /* trn-block */
    END. /* valid buffer and field */

    IF lDynBuff AND 
       VALID-HANDLE(hVersionBuffer) THEN
    DO:
      hVersionBuffer:BUFFER-RELEASE().
      DELETE OBJECT hVersionBuffer.
    END.

    IF cErrorText <> "":U OR
       ERROR-STATUS:ERROR THEN
      UNDO, LEAVE. 

  END.

  IF ERROR-STATUS:ERROR THEN
    RETURN ERROR cErrorText.
  ELSE
    RETURN cErrorText.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getFieldStringValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldStringValue Procedure 
FUNCTION getFieldStringValue RETURNS CHARACTER
  ( INPUT phField AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:   Obtains the string value of a field from a field handle. 
    Notes:   This function has been specifically written for record versioning
             because the data in the repository needs to be consistently
             retrieved. So record versions keys should always have
             dates and decimals in American format.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRetVal     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrDF     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrNumSep AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrNumDec AS CHARACTER  NO-UNDO.

  CASE phField:DATA-TYPE:
    WHEN "DECIMAL":U THEN
    DO:
      cCurrNumSep = SESSION:NUMERIC-SEPARATOR.
      cCurrNumDec = SESSION:NUMERIC-DECIMAL-POINT.
      SESSION:SET-NUMERIC-FORMAT(",":U,".":U).
      cRetVal = STRING(phField:BUFFER-VALUE).
      SESSION:SET-NUMERIC-FORMAT(cCurrNumSep,cCurrNumDec).
    END.
    WHEN "DATE":U    THEN
    DO:
      cCurrDF = SESSION:DATE-FORMAT.
      SESSION:DATE-FORMAT = "mdy":U.
      cRetVal = STRING(phField:BUFFER-VALUE, "99/99/9999":U).
      SESSION:DATE-FORMAT = cCurrDF.
    END.
    OTHERWISE
      cRetVal = STRING(phField:BUFFER-VALUE).
  END CASE.

  IF cRetVal = ? THEN
    cRetVal = "?":U.
  
  RETURN cRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSiteMantissa) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSiteMantissa Procedure 
FUNCTION getSiteMantissa RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the site number in the mantissa of a decimal.
    Notes:  
------------------------------------------------------------------------------*/
  IF gdSiteNo = 0.00 THEN
    RUN setupSiteNo.

  RETURN gdSiteNo.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-replaceWhereTokens) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION replaceWhereTokens Procedure 
FUNCTION replaceWhereTokens RETURNS CHARACTER
  ( INPUT pcJoinString  AS CHARACTER,
    INPUT pcReplaceList AS CHARACTER,
    INPUT phBuffer1     AS HANDLE,
    INPUT phBuffer2     AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  Replaces the tokens in a string with the field values from the 
            replace list in the buffer.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hField      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cJoinString AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrent    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldValue AS CHARACTER  NO-UNDO.

  /* Set the join string for the return value equal to the incoming string */
  cJoinString = pcJoinString.

  /* Loop through all the entries in the replace list */
  do-block:
  DO iCount = 1 TO NUM-ENTRIES(pcReplaceList):
    cCurrent = ENTRY(iCount,pcReplaceList).

    /* If the current entry is delimited with "." we need to split out the prefix which 
       indicates the buffer to derive the field from. "C" is the child buffer. "P" is the
       parent buffer */
    IF NUM-ENTRIES(cCurrent,".":U) > 1 THEN
    DO:
      IF ENTRY(1,cCurrent,".":U) = "C":U THEN
        hField   = phBuffer2:BUFFER-FIELD(ENTRY(2,cCurrent,".":U)) NO-ERROR.
      ELSE
        hField   = phBuffer1:BUFFER-FIELD(ENTRY(2,cCurrent,".":U)) NO-ERROR.
    END.
    ELSE
      hField = phBuffer1:BUFFER-FIELD(cCurrent) NO-ERROR.

    ERROR-STATUS:ERROR = NO.

    /* At this point we should have a valid field handle, if we don't we need to return ""
       which means that the WHERE clause is invalid. */
    IF NOT VALID-HANDLE(hField) THEN
    DO:
      cJoinString = "":U.
      LEAVE do-block.
    END.
    ELSE
    DO:
      /* Use the quoter function to quote this field and put it in the join string */
      cFieldValue = TRIM(QUOTER(hField:BUFFER-VALUE)).
      cJoinString = REPLACE(cJoinString,"#":U + STRING(iCount,"99":U) + "#":U, cFieldValue).
    END.
  END.
  
  RETURN cJoinString.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

