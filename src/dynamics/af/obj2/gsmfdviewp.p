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
  File: gsmfdviewp.p

  Description:  Filder Data Viewer Super Procedure

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/14/2003  Author:     

  Update Notes: Created from Template rytemplipp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gsmfdviewp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{src/adm2/globals.i}

DEFINE VARIABLE gcDisplayFieldDataType  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDisplayFieldFormat    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcEntityMnemonic        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSpecification         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glIgnoreLookupComplete  AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE glTableHasObjField      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glSetDataModified       AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE ghDataSource            AS HANDLE     NO-UNDO.

DEFINE TEMP-TABLE ttFields NO-UNDO
  FIELD cFields AS CHARACTER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



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
         HEIGHT             = 17.62
         WIDTH              = 43.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/customsuper.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-comboValueChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE comboValueChanged Procedure 
PROCEDURE comboValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcKeyFieldValue  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcScreenValue    AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phField          AS HANDLE     NO-UNDO.

  IF phField = widgetHandle('owning_entity_mnemonic':U) THEN
  DO:
    assignWidgetValue('expression_field_name':U, '':U).

    RUN prepareUI IN TARGET-PROCEDURE (TRIM(pcKeyFieldValue)).
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable Procedure 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcAction AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cOwningEntityMnemonic AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOwningReference      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cExpressionOperator   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSuccess              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hCoExpressionOperator AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hLookupFillIn         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hLookup               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hToNot                AS HANDLE     NO-UNDO.

  IF VALID-HANDLE(ghDataSource) THEN
  DO:
    ASSIGN
        cOwningEntityMnemonic = TRIM({fnarg ColumnStringValue 'owning_entity_mnemonic' ghDataSource})
        cOwningReference      = TRIM({fnarg ColumnStringValue 'owning_reference' ghDataSource}).

    IF cOwningEntityMnemonic <> ? THEN
    DO:
      ASSIGN
          cExpressionOperator                = {fnarg ColumnStringValue 'expression_operator'    ghDataSource}
          hCoExpressionOperator              = widgetHandle('coExpressionOperator':U)
          hToNot                             = widgetHandle('toNot':U)
          hToNot:CHECKED                     = (cExpressionOperator BEGINS "NOT ":U)
          cExpressionOperator                = TRIM(REPLACE(cExpressionOperator, "NOT":U, "":U))
          hCoExpressionOperator:SCREEN-VALUE = cExpressionOperator.

      RUN prepareUI IN TARGET-PROCEDURE (TRIM(cOwningEntityMnemonic)).
    END.
  END.

  RUN SUPER (pcAction).

  IF NOT glTableHasObjField THEN
  DO:
    hLookup = widgetHandle('owning_reference':U).

    IF VALID-HANDLE(hLookup) THEN
    DO:
      hLookupFillIn = WIDGET-HANDLE({fn getLookupHandle hLookup}).
      
      IF VALID-HANDLE(hLookupFillIn) THEN
        ASSIGN
            hLookupFillIn:SCREEN-VALUE = cOwningReference
            lSuccess                   = {fnarg setSavedScreenValue cOwningReference hLookup}.
    END.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN SUPER.
  
  APPLY "CLOSE":U TO THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields Procedure 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cOwningEntityMnemonic AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cExpressionOperator   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignField         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hCoExpressionOperator AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hToNot                AS HANDLE     NO-UNDO.
  
  RUN SUPER.

  IF NOT VALID-HANDLE(ghDataSource) THEN
    RETURN.

  ASSIGN
      cForeignField = {fn getForeignFields ghDataSource}
      cForeignField = ENTRY(1, cForeignField)
      cForeignField = ENTRY(2, cForeignField, ".":U).

  disableWidget(cForeignField).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  {get DataSource ghDataSource}.

  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "comboValueChanged":U IN TARGET-PROCEDURE.
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "lookupComplete":U    IN TARGET-PROCEDURE.

  RUN SUPER.
  
  /* There is a bug with the framework where if initializePageList is specified,
     SDF are not viewed/made visible after initialization */
  viewWidget('filter_set_obj':U).
  viewWidget('owning_entity_mnemonic':U).
  viewWidget('owning_reference':U).

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

&IF DEFINED(EXCLUDE-lookupComplete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lookupComplete Procedure 
PROCEDURE lookupComplete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcColumnNames   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcColumnValues  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcKeyFieldValue AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcNewValue      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcOldValue      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plWhere         AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER phLookup        AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cOwningReference  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStoredFields     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkedFields     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrentField     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSuccess          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCounter          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hWidget           AS HANDLE     NO-UNDO.

  IF glIgnoreLookupComplete THEN
  DO:
    glIgnoreLookupComplete = FALSE.

    RETURN.
  END.

  IF phLookup = widgetHandle('owning_reference':U) THEN
  DO:
    /* If the table has an obj field then we only need to store the value of the obj field in the reference */
    IF glTableHasObjField THEN
    DO:
      assignWidgetValue('expression_value':U, pcNewValue).

      ASSIGN
          hWidget          = widgetHandle('expression_value':U)
          hWidget:MODIFIED = TRUE.
    END.
    ELSE
    DO:
      cLinkedFields = {fn getViewerLinkedFields phLookup}.

      DO iCounter = 1 TO NUM-ENTRIES(cLinkedFields):
        ASSIGN
            cCurrentField    = ENTRY(iCounter, cLinkedFields)
            cStoredFields    = cStoredFields    + (IF cStoredFields    = "":U THEN "":U ELSE ",":U) + ENTRY(2, cCurrentField, ".":U)
            cOwningReference = cOwningReference + (IF cOwningReference = "":U THEN "":U ELSE CHR(4))
                             + ENTRY(LOOKUP(cCurrentField, pcColumnNames), pcColumnValues, CHR(1)).
      END.

      ASSIGN
          hWidget                = widgetHandle('expression_value':U)
          hWidget:SCREEN-VALUE   = cStoredFields
          hWidget:MODIFIED       = TRUE
          glIgnoreLookupComplete = TRUE
          hWidget                = {fn getLookupHandle phLookup}
          hWidget:SCREEN-VALUE   = cOwningReference
          lSuccess               = {fnarg setDataValue        cOwningReference phLookup}
          lSuccess               = {fnarg setSavedScreenValue cOwningReference phLookup}.

    END.
  END.
    
  RETURN.

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

&IF DEFINED(EXCLUDE-plipSetup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup Procedure 
PROCEDURE plipSetup :
/*------------------------------------------------------------------------------
  Purpose:    Run by main-block of PLIP at startup of PLIP
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/

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

&IF DEFINED(EXCLUDE-prepareLookup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prepareLookup Procedure 
PROCEDURE prepareLookup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcTitle                    AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcRequiredFields           AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcEntityDetailFieldNames   AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcEntityDetailFieldValues  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcDisplayFieldName         AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcDisplayFieldOrder        AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcDisplayFieldLabel        AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcDisplayFieldColumnLabel  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcDisplayFieldFormat       AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcDisplayFieldDataType     AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cBaseQueryString      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryTables          AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cLinkedFieldDataTypes AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkedFieldFormats   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkedFields         AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cBrowseFieldDataTypes AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBrowseFieldFormats   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBrowseFields         AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cDisplayDataType      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayedField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayFormat        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldLabel           AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cKeyDataType          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFormat            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField             AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cFieldName            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iDescFieldLookup      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iKeyFieldLookup       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iBrowseField          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iFieldLookup          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lSuccess              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hOwningReference      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hLookupFillIn         AS HANDLE     NO-UNDO.

  ASSIGN
      hOwningReference  = widgetHandle('owning_reference':U)
      cQueryTables      = ENTRY(LOOKUP("entity_mnemonic_description":U, pcEntityDetailFieldNames, CHR(1)), pcEntityDetailFieldValues, CHR(1))
      cBaseQueryString  = "FOR EACH ":U + cQueryTables + " NO-LOCK INDEXED-REPOSITION":U

      cKeyField         = ENTRY(LOOKUP("entity_object_field":U, pcEntityDetailFieldNames, CHR(1)), pcEntityDetailFieldValues, CHR(1))
      iKeyFieldLookup   = LOOKUP(cKeyField, pcDisplayFieldName, CHR(1))
      cKeyDataType      = ENTRY(iKeyFieldLookup, pcDisplayFieldDataType, CHR(1))
      cKeyFormat        = ENTRY(iKeyFieldLookup, pcDisplayFieldFormat,   CHR(1))
      cKeyFormat        = (IF glTableHasObjField THEN cKeyFormat ELSE "x(500)":U)

      cDisplayedField   = ENTRY(LOOKUP("entity_description_field":U, pcEntityDetailFieldNames, CHR(1)), pcEntityDetailFieldValues, CHR(1))
      cDisplayedField   = (IF cDisplayedField = "":U OR cDisplayedField = ? THEN cKeyField ELSE cDisplayedField)

      iDescFieldLookup  = LOOKUP(cDisplayedField, pcDisplayFieldName,     CHR(1))
      cDisplayDataType  = ENTRY(iDescFieldLookup, pcDisplayFieldDataType, CHR(1))
      cDisplayFormat    = ENTRY(iDescFieldLookup, pcDisplayFieldFormat,   CHR(1))
      cDisplayFormat    = (IF glTableHasObjField THEN cDisplayFormat ELSE "x(500)":U)

      cFieldLabel       = ENTRY(iDescFieldLookup, pcDisplayFieldLabel,    CHR(1))
      cFieldLabel       = (IF glTableHasObjField THEN cFieldLabel ELSE ENTRY(1, pcTitle, " ":U))

      hLookupFillIn        = {fn getLookupHandle hOwningReference}
      hLookupFillIn:FORMAT = (IF cDisplayDataType <> "character":U THEN FILL("x":U, LENGTH(cDisplayDataType)) ELSE cDisplayFormat)
      hLookupFillIn:FORMAT = (IF glTableHasObjField THEN hLookupFillIn:FORMAT ELSE "x(500)":U).

  DO iBrowseField = 1 TO NUM-ENTRIES(pcDisplayFieldName, CHR(1)):
    cFieldName = ENTRY(iBrowseField, pcDisplayFieldName, CHR(1)).

    IF INDEX(cFieldName, "_obj":U) = 0 THEN
      ASSIGN
          cBrowseFieldDataTypes = cBrowseFieldDataTypes + (IF cBrowseFieldDataTypes = "":U THEN "":U ELSE ",":U) + ENTRY(iBrowseField, pcDisplayFieldDataType, CHR(1))
          cBrowseFieldFormats   = cBrowseFieldFormats   + (IF cBrowseFieldFormats   = "":U THEN "":U ELSE "|":U) + ENTRY(iBrowseField, pcDisplayFieldFormat,   CHR(1))
          cBrowseFields         = cBrowseFields         + (IF cBrowseFields         = "":U THEN "":U ELSE ",":U) + cQueryTables + '.':U + ENTRY(iBrowseField, pcDisplayFieldName,     CHR(1)).
  END.

  /* Check if we have any linked fields we need to cater for */
  IF pcRequiredFields <> "":U THEN
  DO:
    DO iBrowseField = 1 TO NUM-ENTRIES(pcRequiredFields):
      ASSIGN
          cFieldName   = ENTRY(iBrowseField, pcRequiredFields)
          iFieldLookup = LOOKUP(cFieldName, pcDisplayFieldName, CHR(1))

          cLinkedFieldDataTypes = cLinkedFieldDataTypes + (IF cLinkedFieldDataTypes = "":U THEN "":U ELSE ",":U) + ENTRY(iFieldLookup, pcDisplayFieldDataType, CHR(1))
          cLinkedFieldFormats   = cLinkedFieldFormats   + (IF cLinkedFieldFormats   = "":U THEN "":U ELSE "|":U) + ENTRY(iFieldLookup, pcDisplayFieldFormat,   CHR(1))
          cLinkedFields         = cLinkedFields         + (IF cLinkedFields         = "":U THEN "":U ELSE ",":U) + cQueryTables + '.':U + ENTRY(iFieldLookup, pcDisplayFieldName, CHR(1)).
    END.
  END.
  ELSE
    /* No linked fields required so ensure the properties are properly cleared up */
    ASSIGN
        cLinkedFieldDataTypes = "":U
        cLinkedFieldFormats   = "":U
        cLinkedFields         = "":U.

  ASSIGN
      cDisplayedField = cQueryTables + '.':U + cDisplayedField
      cKeyField       = cQueryTables + '.':U + cKeyField

      lSuccess = {fnarg createLabel              cFieldLabel           hOwningReference}
      lSuccess = {fnarg setFieldLabel            cFieldLabel           hOwningReference}
      lSuccess = {fnarg setQueryTables           cQueryTables          hOwningReference}
      lSuccess = {fnarg setBaseQueryString       cBaseQueryString      hOwningReference}

      lSuccess = {fnarg setBrowseFieldDataTypes  cBrowseFieldDataTypes hOwningReference}
      lSuccess = {fnarg setBrowseFieldFormats    cBrowseFieldFormats   hOwningReference}
      lSuccess = {fnarg setBrowseFields          cBrowseFields         hOwningReference}

      lSuccess = {fnarg setLinkedFieldDataTypes  cLinkedFieldDataTypes hOwningReference}
      lSuccess = {fnarg setLinkedFieldFormats    cLinkedFieldFormats   hOwningReference}
      lSuccess = {fnarg setViewerLinkedFields    cLinkedFields         hOwningReference}

      lSuccess = {fnarg setBrowseTitle           pcTitle               hOwningReference}

      lSuccess = {fnarg setDisplayDataType       cDisplayDataType      hOwningReference}
      lSuccess = {fnarg setDisplayedField        cDisplayedField       hOwningReference}
      lSuccess = {fnarg setDisplayFormat         cDisplayFormat        hOwningReference}

      lSuccess = {fnarg setKeyDataType           cKeyDataType          hOwningReference}
      lSuccess = {fnarg setKeyField              cKeyField             hOwningReference}
      lSuccess = {fnarg setKeyFormat             cKeyFormat            hOwningReference}.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareUI) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prepareUI Procedure 
PROCEDURE prepareUI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcEntityMnemonic AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cDisplayFieldColumnLabel  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayFieldDataType     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayFieldFormat       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayFieldOrder        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayFieldLabel        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayFieldName         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOwningReference          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRequiredFields           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cComboFields              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldValues              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldNames               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTitle                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCounter                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lSuccess                  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hOwningEntityMnemonic     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hExpressionFieldName      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRaSpecification          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hExpressionValue          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hOwningReference          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hToNot                    AS HANDLE     NO-UNDO.

  hOwningReference = widgetHandle('owning_reference':U).

  IF pcEntityMnemonic = "?":U OR
     pcEntityMnemonic = "":U  OR
     pcEntityMnemonic = ?     THEN
  DO:
    /* Change the label of the lookup */
    {fnarg createLabel "'<No entity selected>':U" hOwningReference}.
    
    /* Disable all the required data entry widgets */
    disableWidget('owning_reference,expression_field_name,toNot,coExpressionOperator,expression_value,raSpecification').

    RETURN.
  END.
  ELSE
    enableWidget('raSpecification').

  ASSIGN
      hOwningEntityMnemonic = widgetHandle('owning_entity_mnemonic':U)
      hExpressionFieldName  = widgetHandle('expression_field_name':U).

  IF pcEntityMnemonic <> gcEntityMnemonic THEN
  DO:
    SESSION:SET-WAIT-STATE("GENERAL":U).

    EMPTY TEMP-TABLE ttFields.

    RUN getEntityDetail IN gshGenManager (INPUT  pcEntityMnemonic,
                                          OUTPUT cFieldNames,
                                          OUTPUT cFieldValues).

    RUN getEntityFields IN gshGenManager (INPUT  pcEntityMnemonic,
                                          INPUT  "":U,
                                          INPUT  FALSE,
                                          OUTPUT cDisplayFieldName,
                                          OUTPUT cDisplayFieldOrder,
                                          OUTPUT cDisplayFieldLabel,
                                          OUTPUT cDisplayFieldColumnLabel,
                                          OUTPUT cDisplayFieldFormat,
                                          OUTPUT cDisplayFieldDataType).

    DO iCounter = 1 TO NUM-ENTRIES(cDisplayFieldName, CHR(1)):
      CREATE ttFields.
      ASSIGN ttFields.cField = ENTRY(iCounter, cDisplayFieldName, CHR(1)).
    END.

    /* Sort the fields by field name */
    FOR EACH ttFields
          BY ttFields.cField:

      cComboFields = cComboFields + (IF cComboFields = "":U THEN "":U ELSE ",":U) + ttFields.cField.
    END.

    ASSIGN
        hExpressionFieldName:LIST-ITEMS = " ,":U + cComboFields
        gcEntityMnemonic                = pcEntityMnemonic.

    IF cFieldNames <> "":U AND
       cFieldNames <> ?    THEN
      ASSIGN
          glTableHasObjField = LOGICAL(ENTRY(LOOKUP("table_has_object_field":U, cFieldNames, CHR(1)), cFieldValues, CHR(1)))
          cRequiredFields    = (IF glTableHasObjField THEN "":U ELSE ENTRY(LOOKUP("entity_key_field":U, cFieldNames, CHR(1)), cFieldValues, CHR(1)))
          cTitle             = ENTRY(LOOKUP("entity_mnemonic_description":U, cFieldNames, CHR(1)), cFieldValues, CHR(1))
                             + " (":U + pcEntityMnemonic + ") Lookup":U.

    RUN prepareLookup IN TARGET-PROCEDURE   (INPUT cTitle,
                                             INPUT cRequiredFields,
                                             INPUT cFieldnames,
                                             INPUT cFieldValues,
                                             INPUT cDisplayFieldName,
                                             INPUT cDisplayFieldOrder,
                                             INPUT cDisplayFieldLabel,
                                             INPUT cDisplayFieldColumnLabel,
                                             INPUT cDisplayFieldFormat,
                                             INPUT cDisplayFieldDataType).

    SESSION:SET-WAIT-STATE("":U).
  END.
  ELSE
    /* Restore the label of the lookup */
    DYNAMIC-FUNCTION("createLabel":U IN hOwningReference, {fn getFieldLabel hOwningReference}).

  ASSIGN
      hRaSpecification                = widgetHandle('raSpecification':U)
      hToNot                          = widgetHandle('toNot':U)

      cOwningReference                = TRIM({fnarg columnStringValue 'owning_reference':U ghDataSource})
      cOwningReference                = (IF cOwningReference = ?    THEN "":U           ELSE cOwningReference)
      hRaSpecification:SCREEN-VALUE   = (IF cOwningReference = "":U THEN "expression":U ELSE "owning_reference":U).

  glSetDataModified = FALSE. RUN trgValueChanged IN TARGET-PROCEDURE ("coExpressionOperator":U).
  glSetDataModified = FALSE. RUN trgValueChanged IN TARGET-PROCEDURE ("raSpecification":U).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetRecord Procedure 
PROCEDURE resetRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN dataAvailable IN TARGET-PROCEDURE (INPUT "?":U).

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-trgValueChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgValueChanged Procedure 
PROCEDURE trgValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcParameter  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hExpressionOperator AS HANDLE   NO-UNDO.

  CASE pcParameter: /* Name of the field that was used */
    WHEN "raSpecification":U THEN
    DO:
      IF widgetValue(pcParameter) = "expression":U THEN
      DO:
        disableWidget('owning_reference').
        enableWidget ('expression_field_name,toNot,coExpressionOperator,expression_value':U).
      END.
      ELSE
      DO:
        disableWidget('expression_field_name,toNot,coExpressionOperator,expression_value':U).
        enableWidget ('owning_reference').
      END.
    END.

    WHEN "coExpressionOperator":U THEN
    DO:
      IF widgetValue(pcParameter) = "LOOKUP":U THEN
        viewWidget('fiIsZero':U).
      ELSE
        hideWidget('fiIsZero':U).

      ASSIGN
          hExpressionOperator              = widgetHandle('expression_operator':U)
          hExpressionOperator:SCREEN-VALUE = (IF widgetValue('toNot':U) = "yes":U THEN "NOT ":U ELSE "":U) + widgetValue('coExpressionOperator':U).
    END.
  
    WHEN "toNot":U THEN
    DO:
      ASSIGN
          hExpressionOperator              = widgetHandle('expression_operator':U)
          hExpressionOperator:SCREEN-VALUE = (IF widgetValue('toNot':U) = "yes":U THEN "NOT ":U ELSE "":U) + widgetValue('coExpressionOperator':U).
    END.
  END CASE.

  IF glSetDataModified THEN
    {set DataModified TRUE}.

  glSetDataModified = TRUE.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord Procedure 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCoExpressionOperator     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hExpressionFieldName      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hExpressionOperator       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFiEntityObjField         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hOwningReference          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRaSpecification          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hExpressionValue          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hToNot                    AS HANDLE     NO-UNDO.

  ASSIGN
      hCoExpressionOperator           = widgetHandle('coExpressionOperator':U)
      hExpressionFieldName            = widgetHandle('expression_field_name':U)
      hExpressionOperator             = widgetHandle('expression_operator':U)
      hFiEntityObjField               = widgetHandle('fiEntityObjField':U)
      hOwningReference                = widgetHandle('owning_reference':U)
      hRaSpecification                = widgetHandle('raSpecification':U)
      hExpressionValue                = widgetHandle('expression_value':U)
      hToNot                          = widgetHandle('toNot':U).

  IF hRaSpecification:SCREEN-VALUE = "owning_reference":U THEN
  DO:
    assignWidgetValueList('coExpressionOperator,expression_field_name,expression_operator,toNot':U, '|||NO':U, '|':U).
    
    /* I have to manually assign the modified attribute because the supplied functions do not assign it
       if the widget is disabled!!! */
    ASSIGN
        /* Clear the screen-value of the combos */
        hCoExpressionOperator:LIST-ITEM-PAIRS = hCoExpressionOperator:LIST-ITEM-PAIRS
        hExpressionFieldName:LIST-ITEMS       = hExpressionFieldName:LIST-ITEMS

        hCoExpressionOperator:MODIFIED = TRUE
        hExpressionFieldName:MODIFIED  = TRUE
        hExpressionOperator:MODIFIED   = TRUE
        hToNot:MODIFIED                = TRUE.
  END.
  ELSE
  DO:
    {set DataValue '':U hOwningReference}.
    assignWidgetValue("owning_reference":U, "":U).
  END.

  RUN SUPER.

  {fn clearFilterSetCache gshGenManager}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

