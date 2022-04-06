&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
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
  File: rygenomngp.p

  Description:  Design Manager: Object Gen Procedures

  Purpose:      Design Manager: Object Gen Procedures

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/15/2003  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rygenomngp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

/** Temp-table definition for TT used in storeAttributeValues
 *  ----------------------------------------------------------------------- **/
{ ry/inc/ryrepatset.i }

define temp-table ttDeleteAttribute no-undo like ttStoreAttribute.
/* This include file contains pre-processors for the different data types for attributes */
{af/app/afdatatypi.i}


/** Defines the NO-RESULT-CODE and DEFAULT-RESULT-CODE result codes.
 *  ----------------------------------------------------------------------- **/
{ ry/app/rydefrescd.i }

{destdefi.i}             /* Definitions for dynamics design-time temp-tables. */

/** This preprocessor stores the _View-as fields that must keep their
 *  visualisation types instead of using the default FILL-IN visualisation.
 *  ----------------------------------------------------------------------- **/
&GLOBAL-DEFINE USE-SCHEMA-VIEW-AS TOGGLE-BOX,EDITOR,COMBO-BOX,SELECTION-LIST,RADIO-SET

/** Default size pre-processors for Dynamic Viewers
 *  ----------------------------------------------------------------------- **/
&SCOPED-DEFINE MAX-FIELD-LENGTH 30
&SCOPED-DEFINE MAX-FIELD-WIDTH-CHARS 50

/* Used by getInstanceProperties() in generateDynamicViewer and others. */
&SCOPED-DEFINE Value-Delimiter CHR(1)

DEFINE VARIABLE ghDesignManager             AS HANDLE                   NO-UNDO.
/* Generic query handle to reduce the number of CREATE QUERY ... statements. */
DEFINE VARIABLE ghQuery1                    AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghQuery2                    AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghQuery3                    AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghQuery4                    AS HANDLE                   NO-UNDO.

DEFINE VARIABLE gcUSE-SCHEMA-VIEW-AS        AS CHARACTER                NO-UNDO.

ASSIGN gcUSE-SCHEMA-VIEW-AS = "{&USE-SCHEMA-VIEW-AS}":U.

/* This stream is used with the Analyser in ripViewASPhrase */
DEFINE STREAM stAnalyze.


DEFINE TEMP-TABLE ttDataObjectField         NO-UNDO
    FIELD tDatabaseName         AS CHARACTER                                
    FIELD tTableName            AS CHARACTER
    FIELD tDumpName             AS CHARACTER
    FIELD tFieldName            AS CHARACTER
    FIELD tFieldOrder           AS CHARACTER
    FIELD tKeepField            AS LOGICAL      INITIAL NO
    FIELD tIsTableObjField      AS LOGICAL      INITIAL NO
    FIELD tFieldUpdatable       AS LOGICAL      INITIAL NO
    INDEX idxKeepMe
        tKeepField
    .

DEFINE TEMP-TABLE ttTableColumn     NO-UNDO
    FIELD tDatabaseName     AS CHARACTER
    FIELD tTableName        AS CHARACTER
    FIELD tDataColumns      AS CHARACTER
    FIELD tUpdatableColumns AS CHARACTER
    FIELD tWhereClause      AS CHARACTER
    FIELD tOrder            AS INTEGER
    INDEX idxTable
        tTableName
    INDEX idxSorder
        tOrder
    .
/* Temp-table for following joins of tables in the Dyn SDO */
DEFINE TEMP-TABLE ttRelate          NO-UNDO
    FIELD cOwnerTable     AS CHARACTER
    FIELD cDataBaseName   AS CHARACTER
    FIELD cRelatedTable   AS CHARACTER
    FIELD cLinkFieldName  AS CHARACTER
    FIELD cIndexName      AS CHARACTER
    INDEX idxIndex
        cIndexName
        cRelatedTable
    INDEX idxOwner
        cOwnerTable
    .

/** These TTs used by generateDynamicViewer.
 *  ----------------------------------------------------------------------- **/
DEFINE TEMP-TABLE ttTableField              NO-UNDO
    LIKE _field
    FIELD tDataBaseName         AS CHARACTER
    FIELD tTableName            AS CHARACTER
    FIELD tTableDumpName        AS CHARACTER
    FIELD tKeyField             AS LOGICAL      INITIAL NO
    FIELD tEntityObjectField    AS LOGICAL      INITIAL NO
    .

DEFINE TEMP-TABLE ttFrameField      NO-UNDO
    FIELD tFieldName            AS CHARACTER
    FIELD tDBFieldName          AS CHARACTER
    FIELD tFieldLength          AS DECIMAL
    FIELD tLabelLength          AS DECIMAL
    FIELD tLabelChars           AS DECIMAL
    FIELD tLabel                AS CHARACTER
    FIELD tTotalFieldWidth      AS DECIMAL
    FIELD tColumn               AS DECIMAL
    FIELD tRow                  AS DECIMAL
    FIELD tOrder                AS INTEGER
    FIELD tFieldHandle          AS HANDLE
    FIELD tLabelHandle          AS HANDLE
    FIELD tViewAs               AS CHARACTER
    FIELD tEnabled              AS LOGICAL
    FIELD tDataType             AS CHARACTER
    FIELD tFormat               AS CHARACTER
    FIELD tTableName            AS CHARACTER
    FIELD tTableDumpName        AS CHARACTER
    FIELD tSortOrder            AS CHARACTER
    FIELD tHelp                 AS CHARACTER
    FIELD tInitialValue         AS CHARACTER
    FIELD tSdoOverrides         AS CHARACTER
    FIELD tKeyField             AS LOGICAL      INITIAL NO
    FIELD tEntityObjectField    AS LOGICAL      INITIAL NO
    INDEX idxOrder      IS UNIQUE PRIMARY
        tOrder
    INDEX idxSortOrder
        tSortOrder
    INDEX idxKeyField
        tKeyField
    INDEX idxObejctField
        tEntityObjectField
    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-buildDataFieldAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildDataFieldAttribute Procedure 
FUNCTION buildDataFieldAttribute RETURNS LOGICAL
    ( INPUT plForceOverride         AS LOGICAL,
      INPUT pcPrimaryFieldName      AS CHARACTER,
      INPUT piPrimaryDataType       AS INTEGER,
      INPUT pcPrimaryValue          AS CHARACTER,
      INPUT pcSecondaryFieldName    AS CHARACTER,
      INPUT pcSecondaryValue        AS CHARACTER,
      INPUT pcNewCharacterValue     AS CHARACTER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cleanStoreAttributeValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cleanStoreAttributeValues Procedure 
FUNCTION cleanStoreAttributeValues RETURNS LOGICAL
    ( INPUT pcObjectName                AS CHARACTER,
      INPUT pcClassName                 AS CHARACTER,
      INPUT pcCleanToLevel              AS CHARACTER,
      INPUT phStoreAttributeBuffer      AS HANDLE       )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getComboBoxAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getComboBoxAttributes Procedure 
FUNCTION getComboBoxAttributes RETURNS CHARACTER
    ( INPUT pcViewAsList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDupFieldCount) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDupFieldCount Procedure 
FUNCTION getDupFieldCount RETURNS INTEGER
    ( INPUT pcFieldList         AS CHARACTER,
      INPUT pcField             AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEditorAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEditorAttributes Procedure 
FUNCTION getEditorAttributes RETURNS CHARACTER
    ( INPUT pcViewAsList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldNames Procedure 
FUNCTION getFieldNames RETURNS CHARACTER
    ( INPUT phTable                     AS HANDLE,
      INPUT pcFieldQualifiers           AS CHARACTER,
      INPUT pcFieldSeparator            AS CHARACTER,
      INPUT pcTableBase                 AS CHARACTER,     
      INPUT pcValidDataTypes            AS CHARACTER,
      INPUT plNonKeyFieldsAllowed       AS LOGICAL,
      INPUT plBuildFromIndexes          AS LOGICAL,
      INPUT pcAllIndexes                AS CHARACTER,
      INPUT pcUniqueSingleFieldIndexes  AS CHARACTER,
      INPUT pcAlternateDataTypes        AS CHARACTER,
      INPUT pcObjectFieldName           AS CHARACTER         )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRadioSetAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRadioSetAttributes Procedure 
FUNCTION getRadioSetAttributes RETURNS CHARACTER
    ( INPUT pcViewAsList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSelectionListAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSelectionListAttributes Procedure 
FUNCTION getSelectionListAttributes RETURNS CHARACTER
    ( INPUT pcViewAsList AS CHARACTER )  FORWARD.

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
         HEIGHT             = 28.19
         WIDTH              = 51.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
ASSIGN ghDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U IN TARGET-PROCEDURE,
                                          INPUT "RepositoryDesignManager":U).

IF NOT VALID-HANDLE(ghDesignManager) THEN
    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-generateCalculatedField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateCalculatedField Procedure 
PROCEDURE generateCalculatedField :
/*------------------------------------------------------------------------------
  Purpose:     Creates a calculated field
  Parameters:  pcCalcFieldName     AS CHARACTER
               pcDataType          AS CHARACTER
               pcFieldFormat       AS CHARACTER
               pcFieldLabel        AS CHARACTER
               pcFieldHelp         AS CHARACTER
               pcProductModuleCode AS CHARACTER
               pcResultCode        AS CHARACTER
               pcObjectTypeCode    AS CHARACTER
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcCalcFieldName          AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcDataType               AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcFieldFormat            AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcFieldLabel             AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcFieldHelp              AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcProductModuleCode      AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcResultCode             AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcObjectTypeCode         AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE cReturnValue            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dHeight                 AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dWidth                  AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE lError                  AS LOGICAL    NO-UNDO.

    DEFINE VARIABLE cDataFieldClasses AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dCalcFieldObj     AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE hAttrField        AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer  AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hAttributeTable   AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hOTTable          AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hOTBuffer         AS HANDLE     NO-UNDO.
    DEFINE VARIABLE lAttrValueSame    AS LOGICAL    NO-UNDO.

    /* Make sure that at least the CalculatedField class is cached. */
    IF NOT DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, INPUT pcObjectTypeCode, INPUT "CalculatedField":U) THEN
        RETURN ERROR {aferrortxt.i 'AF' '15' '?' '?' "'the class specified does not inherit from the CalculatedField class.'"}.

    EMPTY TEMP-TABLE ttStoreAttribute.
          
    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "DATA-TYPE":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = pcDataType.

    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "FORMAT":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = pcFieldFormat.

    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "LABEL":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = pcFieldLabel.

    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "HELP":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = pcFieldHelp.

    ASSIGN dWidth = DYNAMIC-FUNCTION("getWidgetSizeFromFormat":U IN ghDesignManager,
                                     INPUT  pcFieldFormat,
                                     INPUT  "CHARACTER":U,
                                     OUTPUT dHeight).

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

    ASSIGN hAttributeBuffer = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE
                              hAttributeTable  = ?.

    /* Get rid of any attribute values that match those at the Class level. */
    DYNAMIC-FUNCTION("cleanStoreAttributeValues":U IN TARGET-PROCEDURE,
                     INPUT "":U,              /* pcObjectName*/
                     INPUT pcObjectTypeCode,
                     INPUT "CLASS":U,
                     INPUT hAttributeBuffer   ).

    RUN insertObjectMaster IN ghDesignManager ( INPUT  pcCalcFieldName,                          /* pcObjectName         */
                                                INPUT  pcResultCode,                             /* pcResultCode         */
                                                INPUT  pcProductModuleCode,                      /* pcProductModuleCode  */
                                                INPUT  pcObjectTypeCode,                         /* pcObjectTypeCode     */
                                                INPUT  "Calculated field ":U + pcCalcFieldName,  /* pcObjectDescription  */
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
                                                INPUT  hAttributeBuffer,
                                                INPUT  TABLE-HANDLE hAttributeTable,
                                                OUTPUT dCalcFieldObj                  ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generateCalculatedField */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateDataFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateDataFields Procedure 
PROCEDURE generateDataFields :
/*------------------------------------------------------------------------------
  Purpose:     Creates DataField records for a table.
  Parameters:  pcDataBaseName           -
               pcTableName              -
               pcProductModuleCode      -
               pcResultCode             -
               plGenerateFromDataObject -
               pcDataObjectFieldList    -
               pcSdoObjectName          -
               pcObjectTypeCode         -
               pcOverrideAttributes     - a CAN-DO() compatible list of attributes
                                          to always load from the schema, even if
                                          there are local overrides.
               pcFieldNames             - a CAN-DO() compatible list of fields for which
                                          to generate DataField objects.
  Notes:       * This procedure will by default create a DataField smartobject for each 
                 field in the table.
               * Note that CAN-DO() evaluates from left-to-right, so that
                 CAN-DO('*,!Label', 'Label') will return true, while 
                 CAN-DO('!Label,*', 'Label') will return false (correctly).
               * Fields in the pcFieldNames parameters are a comma-delimited list
                 of fields in TableName.FieldName format. Array fields are one field
                 so al of the DataFields for one array field will be generated at a 
                 time.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcDataBaseName           AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcTableName              AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcProductModuleCode      AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcResultCode             AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER plGenerateFromDataObject AS LOGICAL          NO-UNDO.
    DEFINE INPUT PARAMETER pcDataObjectFieldList    AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcSdoObjectName          AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcObjectTypeCode         AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcOverrideAttributes     AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcFieldNames             AS CHARACTER        NO-UNDO.

    DEFINE VARIABLE cReturnValue                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE lError                      AS LOGICAL              NO-UNDO.

    /** The code meved from here into an include because the code blows the Section
     *  Editor's 32K limit.
     *  ----------------------------------------------------------------------- **/
    {ry/inc/rydesgendf.i}

    IF lError THEN
        RETURN ERROR cReturnValue.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generateDataFields */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateDataLogicObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateDataLogicObject Procedure 
PROCEDURE generateDataLogicObject :
/*------------------------------------------------------------------------------
  Purpose:     Generates the DLP for the SDO, compiles it and registers it.
  Parameters:  pcDatabaseName            DB Name (Not used)
               pcTableList               Comma delimited list of supported tables OR 
                     can also contain enabled fields in the format:  
                     Table1,Table2,... CHR(1) field1,field2,field3...CHR(1)field1,field2,..
                     The first list of fields (after the chr(1) delim) corresponds to Table1, etc..
               pcDumpName                (Not used)
               pcDataObjectName          Name of SBO object 
               pcProductModule           Product module of DLP
               pcResultCode              Result code (Blank is default result code)
               plSuppressValidation      YES   No validation is created 
               pcLogicProcedureName      Name of new logic procedure to be created
               pcLogicObjectType         Logic type of new procedure (i.e. DLCProc)
               pcLogicProcedureTemplate  Template file to base DLP
               pcDataObjectRelativePath  Relative path of SDO
               pcDataLogicRelativePath   Relative path of object to be saved
               pcRootFolder              Root directory   (i.e. "C:\workarea")
               pcFolderIndicator         "/"
               plCreateMissingFolder     Yes.  Create new directory if it doesn't exist

 Update Notes: Issue 7429. Now pcTableList accepts field list
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcDatabaseName               AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcTableName                  AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcDumpName                   AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcDataObjectName             AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcProductModule              AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcResultCode                 AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER plSuppressValidation         AS LOGICAL          NO-UNDO.
    DEFINE INPUT PARAMETER pcLogicProcedureName         AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcLogicObjectType            AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcLogicProcedureTemplate     AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcDataObjectRelativePath     AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcDataLogicRelativePath      AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcRootFolder                 AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcFolderIndicator            AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER plCreateMissingFolder        AS LOGICAL          NO-UNDO.

    DEFINE VARIABLE hAttributeTable                 AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cAbsolutePathedName             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cCompileError                   AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cRelativelyPathedName           AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDefinitionIncludeName          AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cOldPropath                     AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cValidationFields               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cValidateFrom                   AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE dSmartObjectObj                 AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE iLoop                           AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iLoop2                          AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cValidateCheck                  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cNewValidateCheck               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFieldList                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFieldListEntry                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cTableList                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cMasterDataType                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cMasterLabel                    AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cMandatoryList                  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cTempTable                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE lOK                             AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE cSourceFile                     AS CHARACTER            NO-UNDO.
    
    /* Ensure the data logic procedure contains a .p extension */
    IF NUM-ENTRIES(pcLogicProcedureName,".") < 2 THEN
       ASSIGN pcLogicProcedureName = pcLogicProcedureName + ".p":U.

    /* Create Logic Procedure */
    IF pcDataLogicRelativePath = "/":U  OR pcDataLogicRelativePath = "~\":U
    OR pcDataLogicRelativePath = "":U   OR pcDataLogicRelativePath = pcFolderIndicator THEN
        ASSIGN cRelativelyPathedName = pcLogicProcedureName
               cAbsolutePathedName   = RIGHT-TRIM(pcRootFolder,pcFolderIndicator)
                                     + pcFolderIndicator
                                     + pcLogicProcedureName.
    ELSE
        ASSIGN cRelativelyPathedName = RIGHT-TRIM(pcDataLogicRelativePath,pcFolderIndicator)
                                     + pcFolderIndicator
                                     + pcLogicProcedureName
               cAbsolutePathedName   = RIGHT-TRIM(pcRootFolder,pcFolderIndicator)
                                     + pcFolderIndicator
                                     + RIGHT-TRIM(pcDataLogicRelativePath,pcFolderIndicator)
                                     + pcFolderIndicator
                                     + pcLogicProcedureName.
    IF pcDataObjectRelativePath = "/":U OR pcDataObjectRelativePath = "~\":U
    OR pcDataObjectRelativePath = "":U  OR pcDataObjectRelativePath = pcFolderIndicator THEN
        ASSIGN cDefinitionIncludeName = (IF INDEX(pcDataObjectName,".w":U) > 0 THEN REPLACE(pcDataObjectName,".w":U,".i":U)
                                         ELSE pcDataObjectName + ".i":U).
    ELSE
        ASSIGN cDefinitionIncludeName = RIGHT-TRIM(pcDataObjectRelativePath,pcFolderIndicator)
                                      + pcFolderIndicator
                                      + (IF INDEX(pcDataObjectName,".w":U) > 0 THEN REPLACE(pcDataObjectName,".w":U,".i":U)
                                         ELSE pcDataObjectName + ".i":U).

    /* See if there are any overrides to the standard behaviour that 
     * determines how the rowObjectValidate procedure is built. By
     * default, both fields that are mandatory and fields that are
     * part of an index have code added to rowObjectValidate that will
     * ensure that they are not left blank.                            
     *
     * This behaviour can be overridden by setting the OG_ValidateFrom 
     * session parameter to contain a CSV list of values that determine
     * which fields are to be used as part of the rowObjectvalidate procedure. */
    ASSIGN cValidateFrom = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                            INPUT "OG_ValidateFrom":U).

    IF cValidateFrom EQ ? THEN
        ASSIGN cValidateFrom = "*":U.

    /* Since the parameter pcTablename can also contain enabled fields, check whether this is so */
    IF NUM-ENTRIES(pcTableName,CHR(1)) > 1 THEN
       ASSIGN cTableList = ENTRY(1,pcTableName,CHR(1))
              cFieldList = SUBSTRING(pcTableName,INDEX(pcTableName,CHR(1)) + 1).
    ELSE
       ASSIGN cTableList = pcTableName
              cFieldList = "".
       
    /* We need to derive the index fields and generate list */
    IF CAN-DO(cValidateFrom,"INDEX":U) THEN
    DO:
        /* IF passing only table names */
        IF cFieldList = "" THEN
        DO iLoop = 1 TO NUM-ENTRIES(cTableList):
            ASSIGN cValidationFields = cValidationFields + (IF cValidationFields = "" THEN "" ELSE CHR(1))
                                     +  DYNAMIC-FUNCTION("getIndexFieldsUnique":U IN ghDesignManager, INPUT ENTRY(iLoop,cTableList)).
        END.    /* loop through table list if fields are empty */
        ELSE
        DO:  /* If passing table names and field names */
            DO iLoop = 1 to NUM-ENTRIES(cFieldList,CHR(1)):
                ASSIGN cFieldListEntry = ENTRY(iLoop,cFieldList,CHR(1)) NO-ERROR.
                       cValidateCheck     = DYNAMIC-FUNCTION("getIndexFieldsUnique":U IN ghDesignManager, INPUT ENTRY(iLoop,cTableList)).

                /* If the pcTableName is being used to pass a list of enabled fields, ensure 
                 * the index field is contained in this list */
                ASSIGN cNewValidateCheck = cNewValidateCheck + (IF cNewValidateCheck = "" THEN "" ELSE CHR(1)).

                DO iLoop2 = 1 TO NUM-ENTRIES(cValidateCheck,CHR(2)) BY 3:
                    IF LOOKUP(ENTRY(iLoop2,cValidateCheck,CHR(2)),cFieldListEntry) > 0 THEN
                        ASSIGN cNewValidateCheck = cNewValidateCheck + (IF cNewValidateCheck = "" then "" else CHR(2))
                                                 + ENTRY(iLoop2,cValidateCheck,CHR(2)) +  CHR(2) 
                                                 + ENTRY(iLoop2 + 1,cValidateCheck,CHR(2)) + CHR(2) 
                                                 + ENTRY(iLoop2 + 2,cValidateCheck,CHR(2)).
                END.    /* loop through entries in validation check */
            END.    /* loop through entries is field */

            ASSIGN cValidationFields = cNewValidateCheck.
        END.    /* there is a valid field list */
    END.    /* can validate from INDEXes */

    /* Now derive the mandatoy fields */
    IF CAN-DO(cValidateFrom,"MANDATORY":U) THEN
    DO iLoop = 1 to NUM-ENTRIES(cTableList):
       RUN retrieveDesignObject IN ghDesignManager 
                          ( INPUT  ENTRY(iLoop,cTableList),
                            INPUT  "":U ,
                            OUTPUT TABLE ttObject,
                            OUTPUT TABLE ttPage,
                            OUTPUT TABLE ttLink,
                            OUTPUT TABLE ttUiEvent,
                            OUTPUT TABLE ttObjectAttribute ) NO-ERROR.
       ASSIGN cMandatoryList = "":U.
      /* Get all object instances and extract those fields that are mandatory */
       FOR EACH ttObject WHERE ttObject.tLogicalObjectName       =  ENTRY(iLoop,cTableList) 
                           AND ttObject.tContainerSmartObjectObj > 0 : 
          /* get  attributes of the master Data field */ 
          FIND FIRST  ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                          AND ttObjectAttribute.tObjectInstanceObj = 0
                                          AND ttObjectAttribute.tAttributeLabel    = "Mandatory":U NO-ERROR.
          IF AVAIL ttObjectAttribute AND LOGICAL(ttObjectAttribute.tAttributeValue)  THEN
          DO:
             FIND FIRST  ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                           AND ttObjectAttribute.tObjectInstanceObj = 0
                                           AND ttObjectAttribute.tAttributeLabel    = "LABEL":U NO-ERROR.
             IF AVAIL ttObjectAttribute THEN
                cMasterLabel = ttObjectAttribute.tAttributeValue.
             ELSE
                 cMasterLabel = ttObject.tObjectInstanceName.

             FIND FIRST  ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                           AND ttObjectAttribute.tObjectInstanceObj = 0
                                           AND ttObjectAttribute.tAttributeLabel    = "DATA-TYPE":U NO-ERROR.
             IF AVAIL ttObjectAttribute THEN
                cMasterDataType = ttObjectAttribute.tAttributeValue.
 
             IF cFieldList = "" OR (cFieldList  > "" AND LOOKUP(ttObject.tLogicalObjectName, cFieldList) > 0 )THEN
                ASSIGN cMandatoryList = cMandatoryList + (IF cMandatoryList = "" THEN "" ELSE CHR(2))
                                                       + ttObject.tLogicalObjectName + CHR(2) + cMasterDataType + CHR(2) 
                                                       + cMasterLabel.
          END.  /* End If Available ttObjectAttribute */
       END. /* End for each ttObject  */

        IF cMandatoryList > "" THEN
        DO:
            IF NUM-ENTRIES(cValidationFields,CHR(1)) = NUM-ENTRIES(cTableList) THEN
                ENTRY(iLoop,cValidationFields,CHR(1)) = ENTRY(iLoop,cValidationFields,CHR(1)) 
                                                      + (IF ENTRY(iLoop,cValidationFields,CHR(1)) = "" THEN "" ELSE CHR(2))
                                                      + cMandatoryList.
            ELSE
                ASSIGN cValidationFields = cValidationFields + (IF cValidationFields = "" THEN "" ELSE CHR(1))
                                                             + cMandatoryList.
        END. 
    END.     /* End DO iLoop per table */ 
    /* If temp-db database is used, create temp-table definition stmt and pass to DLP generator */
    IF pcDatabaseName = "temp-db":U THEN
        DO:
           RUN adeuib/_tempdbvalid.p (OUTPUT lok). /* Check whether control file is present in TEMP-DB */
           IF lOK THEN
           DO:
              RUN adeuib/_tempdbfind.p (INPUT "TABLE":U, INPUT ENTRY(1,cTableList), OUTPUT cSourceFile).
              IF cSourceFile NE "" THEN
                 ASSIGN cTempTable   = "/* ***********Included Temp-Table & Buffer definitions **************** */" + CHR(10) +
                                        "~{":U + cSourceFile + "}":U + CHR(10).
                                       
           END.
           IF cTempTable EQ "" THEN
              ASSIGN cTempTable = "DEFINE TEMP-TABLE ":U + ENTRY(1,cTableList)+ " NO-UNDO LIKE temp-db." + ENTRY(1,cTableList) + ".":U.

    END.    


    /* Run static sdo Data Logic file generator */
    RUN af/app/afgendlogp.p ( INPUT cRelativelyPathedName,
                              INPUT (RIGHT-TRIM(pcRootFolder,pcFolderIndicator) + pcFolderIndicator ),
                              INPUT pcLogicProcedureTemplate,
                              INPUT cTableList,
                              INPUT cFieldList,
                              INPUT cValidationFields,
                              INPUT cDefinitionIncludeName,
                              INPUT plCreateMissingFolder,
                              INPUT plSuppressValidation,
                              INPUT cTempTable,
                              INPUT "YES":U                  ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
        RETURN ERROR ("Generation of DataLogic Procedure Failed : " + RETURN-VALUE).

    /** Compile the objects just created.
     *  ----------------------------------------------------------------------- **/
    /* Make sure that the root folder is in the PROPATH */
    ASSIGN cOldPropath = PROPATH
           PROPATH     = pcRootFolder + (IF INDEX(PROPATH, ";":U) GT 0 THEN ";":U ELSE ",":U) + PROPATH.

    IF SEARCH(cAbsolutePathedName) EQ ? THEN
        RETURN ERROR {aferrortxt.i 'AF' '19' '?' '?' "''" "'logic procedure: ' + cAbsolutePathedName"}.

    COMPILE VALUE(cAbsolutePathedName) SAVE NO-ERROR.
    IF COMPILER:ERROR THEN
    DO:
        ASSIGN cCompileError = "Compiling of DataLogic Procedure Failed : " + CHR(10) + ERROR-STATUS:GET-MESSAGE(1).
        RETURN ERROR cCompileError.
    END.    /* DLProc failed to compile */

    /* Now compile the _CL (client proxy) */
    ASSIGN cAbsolutePathedName = REPLACE(cAbsolutePathedName, ".p":U, "_cl.p":U).
    
    IF SEARCH(cAbsolutePathedName) EQ ? THEN
        RETURN ERROR {aferrortxt.i 'AF' '19' '?' '?' "''" "'logic procedure client proxy: ' + cAbsolutePathedName"}.

    COMPILE VALUE(cAbsolutePathedName) SAVE NO-ERROR.
    IF COMPILER:ERROR THEN
    DO:
        ASSIGN cCompileError = "Compiling of DataLogic Client Proxy Failed : " + CHR(10) + ERROR-STATUS:GET-MESSAGE(1).
        RETURN ERROR cCompileError.
    END.    /* DLProc _CL failed to compile */

    /* Reset the PROPATH. */
    ASSIGN PROPATH = cOldPropath.

    /* Generate the Logic Procedure Object */
    /* There are currently no attributes for this object. */
    ASSIGN hAttributeTable  = ?.

    RUN insertObjectMaster IN ghDesignManager ( INPUT  pcLogicProcedureName,
                                                INPUT  pcResultCode,                           /* pcResultCode         */
                                                INPUT  pcProductModule,                        /* pcProductModuleCode  */
                                                INPUT  pcLogicObjectType,                      /* pcObjectTypeCode     */
                                                INPUT  "Logic Procedure for ":U + ENTRY(1,pcTablename,CHR(1)), /* pcObjectDescription  */
                                                INPUT  pcDataLogicRelativePath,                /* pcDataLogicRelativePath */ 
                                                INPUT  pcDataObjectName,                       /* pcSdoObjectName      */
                                                INPUT  "":U,                                   /* pcSuperProcedureName */
                                                INPUT  NO,                                     /* plIsTemplate         */
                                                INPUT  YES,                                    /* plIsStatic           */
                                                INPUT  "":U,                                   /* pcPhysicalObjectName */
                                                INPUT  NO,                                     /* plRunPersistent      */
                                                INPUT  "":U,                                   /* pcTooltipText        */
                                                INPUT  "":U,                                   /* pcRequiredDBList     */
                                                INPUT  "":U,                                   /* pcLayoutCode         */
                                                INPUT  ?,
                                                INPUT  TABLE-HANDLE hAttributeTable,
                                                OUTPUT dSmartObjectObj                ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
        RETURN ERROR ("Creation of DataLogic Procedure Failed : " + RETURN-VALUE).

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generateDataLogicObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateDataObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateDataObject Procedure 
PROCEDURE generateDataObject :
/*------------------------------------------------------------------------------
  Purpose:     Generates SDOs and other dataobjects.
  Parameters:  pcDatabaseName             -
               pcTableName                -
               pcDumpName                 -
               pcDataObjectName           -
               pcObjectTypeCode           -
               pcProductModule            -
               pcResultCode               -
               plCreateSDODataFields      -
               plSdoDeleteInstances       -
               plSuppressValidation       -
               plFollowJoins              -
               piFollowDepth              -
               pcFieldSequence            -
               pcLogicProcedureName       -
               pcDataObjectRelativePath   -
               pcDataLogicRelativePath    -
               pcRootFolder               -
               plCreateMissingFolder      -
               pcAppServerPartition       -
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcDatabaseName           AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcTableName              AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcDumpName               AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcDataObjectName         AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcObjectTypeCode         AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcProductModule          AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcResultCode             AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER plCreateSDODataFields    AS LOGICAL              NO-UNDO.
    DEFINE INPUT PARAMETER plSdoDeleteInstances     AS LOGICAL              NO-UNDO.
    DEFINE INPUT PARAMETER plSuppressValidation     AS LOGICAL              NO-UNDO.
    DEFINE INPUT PARAMETER plFollowJoins            AS LOGICAL              NO-UNDO.
    DEFINE INPUT PARAMETER piFollowDepth            AS INTEGER              NO-UNDO.
    DEFINE INPUT PARAMETER pcFieldSequence          AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcLogicProcedureName     AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcDataObjectRelativePath AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcDataLogicRelativePath  AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcRootFolder             AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER plCreateMissingFolder    AS LOGICAL              NO-UNDO.
    DEFINE INPUT PARAMETER pcAppServerPartition     AS CHARACTER            NO-UNDO.

    /** Code has been moved into a separate include to avoid Section Editor
     *  limits.
     *  ----------------------------------------------------------------------- **/
    {ry/app/rydesmngdo.i}

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generateDataObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateDynamicBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateDynamicBrowse Procedure 
PROCEDURE generateDynamicBrowse :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     Generates a dynamic browse based on the information obtained
               from the object generator.
  Parameters:  pcObjectTypeCode          -
               pcObjectName              -
               pcObjectDescription       -
               pcProductModuleCode       -
               pcResultCode              -
               pcSdoObjectName           -
               plDeleteExistingInstances -
               pcDisplayedFields         -
               pcEnabledFields           -
               piMaxFieldsPerColumn      -
               pcDataObjectFieldSequence -
               pcDataObjectFieldList     -
               pdVisualObjectObj         -
  Notes:       
------------------------------------------------------------------------------*/    
    DEFINE INPUT  PARAMETER pcObjectTypeCode            AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcObjectName                AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcObjectDescription         AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcProductModuleCode         AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcResultCode                AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcSdoObjectName             AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER plDeleteExistingInstances   AS LOGICAL      NO-UNDO.
    DEFINE INPUT  PARAMETER pcDisplayedDatabases        AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcEnabledDatabases          AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcDisplayedTables           AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcEnabledTables             AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcDisplayedFields           AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcEnabledFields             AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER piMaxFieldsPerColumn        AS INTEGER      NO-UNDO.
    DEFINE INPUT  PARAMETER pcDataObjectFieldSequence   AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcDataObjectFieldList       AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER pdVisualObjectObj           AS DECIMAL      NO-UNDO. 

    DEFINE VARIABLE dBrowseObjectObj            AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer            AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hAttributeTable             AS HANDLE               NO-UNDO.
    DEFINE VARIABLE iListLoop                   AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cNewList                    AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cOrderedList                AS CHARACTER            NO-UNDO.

    DEFINE VARIABLE hObjectBuffer               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hDataFieldAttributeBuffer   AS HANDLE               NO-UNDO.
    DEFINE VARIABLE dInstanceId                 AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE lIncludeFieldInViewer       AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE hIncludeFieldInViewer       AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hIncludeFieldInListView     AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cDataFieldName              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cEntityName                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cEntityKeyField             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cPropertyNames              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cPropertyValues             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDataType                   AS CHARACTER            NO-UNDO.

    /* Not valid yet for browse - but here for future use. */
    IF plDeleteExistingInstances THEN
    DO:
        RUN removeObjectInstance IN ghDesignManager ( INPUT pcObjectName,
                                                      INPUT pcResultCode,
                                                      INPUT "":U,          /* pcInstanceObjectName */
                                                      INPUT "":U,          /* pcInstanceName       */
                                                      INPUT pcResultCode   ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    END.    /* delete instances. */    

    /** Build the TT of all attribute values, so that we only do one A/S hit.
     *  ----------------------------------------------------------------------- **/
    EMPTY TEMP-TABLE ttStoreAttribute.

    ASSIGN cNewList = "":U.
    DO iListLoop = 1 TO NUM-ENTRIES(pcEnabledFields):
        IF NOT ENTRY(iListLoop, pcEnabledFields) MATCHES "*_obj":U THEN
            ASSIGN cNewList = cNewList + (IF NUM-ENTRIES(cNewList) EQ 0 THEN "":U ELSE ",":U)
                            + ENTRY(iListLoop, pcEnabledFields).
    END.    /* loop list */

    /* Removed creation of EnabledFields for Issue 6790, it needs to be
     * made optional in a future release.  
    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "EnabledFields":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = cNewList.
    */

    /* Use Data Object field order to display in Browse */
    IF pcDataObjectFieldSequence EQ "SDO":U AND pcDataObjectFieldList <> "":U THEN
        ASSIGN pcDisplayedFields = pcDataObjectFieldList.

    ASSIGN cNewList = "":U.
    
    /* Get the Entity Key Field to be excluded */
    RUN getDumpName IN gshGenManager (INPUT "|":U + ENTRY(1,pcDisplayedTables),
                                      OUTPUT cEntityName).
    IF cEntityName <> "":U THEN
        ASSIGN cEntityKeyField = DYNAMIC-FUNCTION("getKeyField":U IN gshGenManager, INPUT cEntityName).

    /* Only exclude the Entity Key Field by Default if it ends in _obj */
    IF cEntityKeyField <> "":U AND NOT cEntityKeyField MATCHES "*_obj":U THEN
        ASSIGN cEntityKeyField = "":U.

    DO iListLoop = 1 TO NUM-ENTRIES(pcDisplayedFields):
        /* Check for the 'IncludeInDefaultView' attribute to see if field should be added to browser */
        ASSIGN lIncludeFieldInViewer = TRUE. /* Default */

        IF pcDataObjectFieldSequence <> "SDO":U THEN
        DO:
            ASSIGN cDataFieldName  = ENTRY(1,pcDisplayedTables) + ".":U + ENTRY(iListLoop, pcDisplayedFields)
                   cPropertyNames  = "IncludeInDefaultListView,IncludeInDefaultView,DATA-TYPE":U
                   cPropertyValues = "":U.

             RUN getInstanceProperties IN gshRepositoryManager (INPUT  cDataFieldName,
                                                                INPUT  "",
                                                                INPUT-OUTPUT cPropertyNames,
                                                                OUTPUT cPropertyValues ) NO-ERROR.
            ASSIGN cDataType = ?
                   cDataType = ENTRY(LOOKUP("DATA-TYPE":U, cPropertyNames), cPropertyValues, CHR(1) ) NO-ERROR.
            ASSIGN lIncludeFieldInViewer  =  IF ENTRY(LOOKUP("IncludeInDefaultListView":U, cPropertyNames), cPropertyValues, CHR(1) ) <> "?"
                                             THEN LOGICAL(ENTRY(LOOKUP("IncludeInDefaultListView":U, cPropertyNames), cPropertyValues, CHR(1) ) )
                                             ELSE LOGICAL(ENTRY(LOOKUP("IncludeInDefaultView":U, cPropertyNames), cPropertyValues, CHR(1) ) )
                                             NO-ERROR.

        END.    /* pcDataObjectFieldSequence NE SDO */

        IF lIncludeFieldInViewer AND ENTRY(iListLoop, pcDisplayedFields) <> cEntityKeyField THEN
            ASSIGN cNewList = cNewList + (IF NUM-ENTRIES(cNewList) EQ 0 THEN "":U ELSE ",":U)
                            + ENTRY(iListLoop, pcDisplayedFields).
    END.    /* loop through displayed fields */

    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "DisplayedFields":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = cNewList.

    ASSIGN hAttributeBuffer = BUFFER ttStoreAttribute:HANDLE
           hAttributeTable  = ?.

    RUN insertObjectMaster IN ghDesignManager ( INPUT  pcObjectName,                             /* pcObjectName         */
                                                INPUT  pcResultCode,                             /* pcResultCode         */
                                                INPUT  pcProductModuleCode,                      /* pcProductModuleCode  */
                                                INPUT  pcObjectTypeCode,                         /* pcObjectTypeCode     */
                                                INPUT  pcObjectDescription,                      /* pcObjectDescription  */
                                                INPUT  "":U,                                     /* pcObjectPath         */
                                                INPUT  pcSdoObjectName,                          /* pcSdoObjectName      */
                                                INPUT  "":U,                                     /* pcSuperProcedureName */
                                                INPUT  NO,                                       /* plIsTemplate         */
                                                INPUT  NO,                                       /* plIsStatic           */
                                                INPUT  "":U,                                     /* pcPhysicalObjectName : use the default */
                                                INPUT  NO,                                       /* plRunPersistent      */
                                                INPUT  "":U,                                     /* pcTooltipText        */
                                                INPUT  "":U,                                     /* pcRequiredDBList     */
                                                INPUT  "":U,                                     /* pcLayoutCode         */
                                                INPUT  hAttributeBuffer,
                                                INPUT  TABLE-HANDLE hAttributeTable,
                                                OUTPUT pdVisualObjectObj               ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generateDynamicBrowse */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateDynamicSDF) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateDynamicSDF Procedure 
PROCEDURE generateDynamicSDF :
/*------------------------------------------------------------------------------
  Purpose:     Generates a dynamic Smart Data Field (SDF) based on the information 
               obtained from the SDF Maintenance Tool.
  Parameters:  pcObjectName              -
               pcObjectDescription       -
               pcProductModuleCode       -
               pcResultCode              -
               plDeleteExistingInstances -
               pcSDFType                 - DynCombo or DynLookup
               pcSuperProcedure          - Name of the super procedure
               pcAttributeLabels         - CHR(1) seperated list of attribute names
               pcAttributeValues         - CHR(1) seperated list of attribute values
                                           corresponding to attributes names from 
                                           pcAttributeLables
               pcAttributeDataType       - CHR(1) seperated list of attribute data type
                                           corresponding to attributes names from 
                                           pcAttributeLables (as specified in 
                                           af/app/afdatatypi.i
               pdSDFObjectObj            -
  Notes:       
------------------------------------------------------------------------------*/    
    DEFINE INPUT  PARAMETER pcObjectName                AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcObjectDescription         AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcProductModuleCode         AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcResultCode                AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER plDeleteExistingInstances   AS LOGICAL      NO-UNDO.
    DEFINE INPUT  PARAMETER pcSDFType                   AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcSuperProcedure            AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcAttributeLabels           AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcAttributeValues           AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcAttributeDataType         AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER pdSDFObjectObj              AS DECIMAL      NO-UNDO. 
    
    DEFINE VARIABLE hAttributeBuffer            AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hAttributeTable             AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE iListLoop                   AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE cAttributeName              AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cAttributeValue             AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE iAttributeDataType          AS INTEGER                  NO-UNDO.
    
    /** Build the TT of all attribute values, so that we only do one A/S hit.
    *  ----------------------------------------------------------------------- **/
    EMPTY TEMP-TABLE ttStoreAttribute.
    
    DO iListLoop = 1 TO NUM-ENTRIES(pcAttributeLabels,CHR(1)):
        ASSIGN cAttributeName     = ENTRY(iListLoop,pcAttributeLabels,CHR(1))
               cAttributeValue    = ENTRY(iListLoop,pcAttributeValues,CHR(1))
               iAttributeDataType = INTEGER(ENTRY(iListLoop,pcAttributeDataType,CHR(1))).

        CREATE ttStoreAttribute.
        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
               ttStoreAttribute.tAttributeParentObj = 0
               ttStoreAttribute.tAttributeLabel     = cAttributeName
               ttStoreAttribute.tConstantValue      = NO.

        CASE iAttributeDataType:
            WHEN {&DECIMAL-DATA-TYPE}   THEN ASSIGN ttStoreAttribute.tDecimalValue   = DECIMAL(cAttributeValue).
            WHEN {&INTEGER-DATA-TYPE}   THEN ASSIGN ttStoreAttribute.tIntegerValue   = INTEGER(cAttributeValue).
            WHEN {&DATE-DATA-TYPE}      THEN ASSIGN ttStoreAttribute.tDateValue      = DATE(cAttributeValue).
            WHEN {&RAW-DATA-TYPE}       THEN .
            WHEN {&LOGICAL-DATA-TYPE}   THEN ASSIGN ttStoreAttribute.tLogicalValue   = LOGICAL(cAttributeValue) NO-ERROR.
            WHEN {&CHARACTER-DATA-TYPE} THEN ASSIGN ttStoreAttribute.tCharacterValue = cAttributeValue.
        END CASE.   /* attribute data type */
    END.    /* attrob8loop through attribute labels */

    ASSIGN hAttributeBuffer = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE
           hAttributeTable  = ?.

    RUN insertObjectMaster IN ghDesignManager ( INPUT  pcObjectName,                             /* pcObjectName         */
                                                INPUT  pcResultCode,                             /* pcResultCode         */
                                                INPUT  pcProductModuleCode,                      /* pcProductModuleCode  */
                                                INPUT  pcSDFType,                                /* pcObjectTypeCode     */
                                                INPUT  pcObjectDescription,                      /* pcObjectDescription  */
                                                INPUT  "":U,                                     /* pcObjectPath         */
                                                INPUT  "":U,                                     /* pcSdoObjectName      */
                                                INPUT  pcSuperProcedure,                         /* pcSuperProcedureName */
                                                INPUT  NO,                                       /* plIsTemplate         */
                                                INPUT  NO,                                       /* plIsStatic           */
                                                INPUT  "":U,                                     /* pcPhysicalObjectName : use the default */
                                                INPUT  NO,                                       /* plRunPersistent      */
                                                INPUT  "":U,                                     /* pcTooltipText        */
                                                INPUT  "":U,                                     /* pcRequiredDBList     */
                                                INPUT  "":U,                                     /* pcLayoutCode         */
                                                INPUT  hAttributeBuffer,
                                                INPUT  TABLE-HANDLE hAttributeTable,
                                                OUTPUT pdSDFObjectObj               ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

    /* Not valid yet for browse - but here for future use. */
    IF plDeleteExistingInstances THEN
    DO:
        RUN removeObjectInstance IN ghDesignManager ( INPUT pcObjectName,
                                                      INPUT pcResultCode,
                                                      INPUT "":U,          /* pcInstanceObjectName */
                                                      INPUT "":U,          /* pcInstanceName       */
                                                      INPUT pcResultCode   ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    END.    /* delete instances. */    

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generateDynamicSDF */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateDynamicViewer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateDynamicViewer Procedure 
PROCEDURE generateDynamicViewer :
/*------------------------------------------------------------------------------
  Purpose:     Generates a dynamic viewer based on the information obtained
               from the object generator.
  Parameters:  pcObjectTypeCode          -
               pcObjectName              -
               pcObjectDescription       -
               pcProductModuleCode       -
               pcResultCode              -
               pcSdoObjectName           -
               plDeleteExistingInstances -
               pcDisplayedFields         -
               pcEnabledFields           -
               pdVisualObjectObj         -
               pcDataObjectFieldList     - 
  Notes:       
------------------------------------------------------------------------------*/    
    DEFINE INPUT  PARAMETER pcObjectTypeCode            AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcObjectName                AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcObjectDescription         AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcProductModuleCode         AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcResultCode                AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcSdoObjectName             AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER plDeleteExistingInstances   AS LOGICAL      NO-UNDO.
    DEFINE INPUT  PARAMETER pcDisplayedDatabases        AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcEnabledDatabases          AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcDisplayedTables           AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcEnabledTables             AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcDisplayedFields           AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcEnabledFields             AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER piMaxFieldsPerColumn        AS INTEGER      NO-UNDO.
    DEFINE INPUT  PARAMETER pcDataObjectFieldSequence   AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcDataObjectFieldList       AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER pdVisualObjectObj           AS DECIMAL      NO-UNDO. 
     
    /** Code moved into a separate include because of section editor limits.
     *  ----------------------------------------------------------------------- **/
    {ry/app/rydesmngdv.i}

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generateDynamicViewer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateEntityInstances) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateEntityInstances Procedure 
PROCEDURE generateEntityInstances :
/*------------------------------------------------------------------------------
  Purpose:     Associates DataFields and other master objects with an entity
  Parameters:  pcEntityObjectName          - Entity-object name. Same as the entity mnemonic.
               pcFieldList                 - list of fields to be added to the entity. These
                                             should be in order. CHR(3) delimited.
               plDeleteExistingInstances   - whether to remove all the existing instances before
                                             adding those specified here.               
  Notes:       * Entities cannot be customised, so they have no result code.
               * The field list is used as passed in. No calculations are performed.
                 This is because the objects to be associated with the are not 
                 bound to the schema - so passing in a table name limits this API.
                 The caller should determine which master objects(dataField or other)
                 are to be made instances of the entity.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcEntityObjectName           AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcFieldList                  AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER plDeleteExistingInstances    AS LOGICAL          NO-UNDO.
    
    DEFINE VARIABLE hStoreAttributeBuffer           AS HANDLE                           NO-UNDO.
    DEFINE VARIABLE hStoreAttributeTable            AS HANDLE                           NO-UNDO.
    DEFINE VARIABLE dEntityObjectObj                AS DECIMAL                          NO-UNDO.
    DEFINE VARIABLE dInstanceSmartObjectObj         AS DECIMAL                          NO-UNDO.
    DEFINE VARIABLE dObjectInstanceObj              AS DECIMAL                          NO-UNDO.
    DEFINE VARIABLE iInstanceOrder                  AS INTEGER                          NO-UNDO.
    DEFINE VARIABLE iOrderOffset                    AS INTEGER                          NO-UNDO.
    define variable iObjectSequence                 as integer                          no-undo.
    DEFINE VARIABLE cFieldName                      AS CHARACTER                        NO-UNDO.
    define variable cInstanceName                   as character                        no-undo.
    
    DEFINE BUFFER ryc_object_instance   FOR ryc_object_instance.

    /* Get the OBJ ID of the Entity object.
     * This also serves as a check for the existence
     * of the Entity object.                            */
    ASSIGN dEntityObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN gshRepositoryManager,
                                               INPUT pcEntityObjectName, INPUT 0           ).
    IF dEntityObjectObj EQ 0 THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' '"Entity object"' "'Entity name: ' + pcEntityObjectName" }.

    iOrderOffset = 0.
    
    /* If required, first remove all contained instances. */
    IF plDeleteExistingInstances THEN
    DO:
        RUN removeObjectInstance IN ghDesignManager ( INPUT pcEntityObjectName,            /* Container object name */
                                                      INPUT "{&DEFAULT-RESULT-CODE}":U,
                                                      INPUT "":U,                          /* pcInstanceObjectName */
                                                      INPUT "":U,                          /* pcInstanceName       */
                                                      INPUT "{&DEFAULT-RESULT-CODE}":U   ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    END.    /* delete instances. */       
    ELSE
    DO:
        /* Find the largest existing instance order */
        FOR EACH ryc_object_instance WHERE
                 ryc_object_instance.container_smartObject_obj = dEntityObjectObj
                 NO-LOCK
                 BY ryc_object_instance.object_sequence DESCENDING:
            ASSIGN iOrderOffset = ryc_object_instance.object_sequence.
            LEAVE.
        END.    /* look for order offset */
        
        /* Belts-and-braces checking. */
        IF iOrderOffset EQ ? THEN
            ASSIGN iOrderOffset = 0.

        ASSIGN iOrderOffset = iOrderOffset + 1.
    END.    /* don't delete them */
    
    /* There are no attributes stored (nor allowed to be stored, in fact). */
    ASSIGN hStoreAttributeBuffer = ?
           hStoreAttributeTable  = ?.
    
    DO iInstanceOrder = 1 TO NUM-ENTRIES(pcFieldList, CHR(3)):
        ASSIGN cFieldName = ENTRY(iInstanceOrder, pcFieldList, CHR(3))
               /* We just want the field name portion for the instance name,
                  not the table portion.
                */
               cInstanceName = ENTRY(NUM-ENTRIES(cFieldName, ".":U), cFieldName, ".":U)
               no-error.
        
        /* Keep the object sequence value the same for existing instances.
           Add any new instances off the end.
         */                   
        find ryc_object_instance where
             ryc_object_instance.container_smartobject_obj = dEntityObjectObj and
             ryc_object_instance.instance_name = cInstanceName
             no-lock no-error.
        
        if available ryc_object_instance then
            iObjectSequence = ryc_object_instance.object_sequence.
        else
            assign iObjectSequence = iOrderOffset
                   iOrderOffset = iOrderOffset + 1.
        
        RUN insertObjectInstance IN ghDesignManager ( INPUT  dEntityObjectObj,                         /* pdContainerObjectObj               */
                                                      INPUT  cFieldName,                               /* Contained Instance Object Name     */
                                                      INPUT  "{&DEFAULT-RESULT-CODE}":U,               /* pcResultCode,                      */                                                      
                                                      INPUT  cInstanceName,                            /* instance name */
                                                      INPUT  "":U,                                     /* pcInstanceDescription,             */
                                                      INPUT  STRING(iObjectSequence, "999":U),         /* pcLayoutPosition */
                                                      INPUT  ?,                                        /* Page number - not applicable */
                                                      INPUT  iObjectSequence,                          /* Object sequence */
                                                      INPUT  NO,                                       /* plForceCreateNew,                  */
                                                      INPUT  hStoreAttributeBuffer,                    /* phAttributeValueBuffer,            */
                                                      INPUT  TABLE-HANDLE hStoreAttributeTable,        /* TABLE-HANDLE phAttributeValueTable */
                                                      OUTPUT dInstanceSmartObjectObj,                  /* pdSmartObjectObj,                  */
                                                      OUTPUT dObjectInstanceObj            ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    END.    /* Loop through fields. */
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generateEntityInstances */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateEntityObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateEntityObject Procedure 
PROCEDURE generateEntityObject :
/*------------------------------------------------------------------------------
  Purpose:     Generates an object for an entity, from a table in the database.
  Parameters:  pcTableNames           - A list formatted as follows: DB1 chr(3) Table1 ....TableN chr(3) ... DBn
               pcEntityObjectType     - The class name of the Entity object. It
                                        must be descended from the Entity class.
               pcEntityProductModule  - The product module to create the Entity
                                        object into.
               plAutoProPerform       - 
               piPrefixLength         -
               pcSeparator            -
               pcAuditingEnabled      -
               pcDescFieldQualifiers  - These determine the criteria used when
                                        searching for the entity-description.field
               pcKeyFieldQualifiers   - These determine the criteria used when
                                        searching for the entity-key-field
               pcObjFieldQualifiers   - These determine the criteria used when
                                        searching for the entity-object-field
               plDeployData           -
               plVersionData          -
               plReuseDeletedKeys     -
               plAssociateDataFields  - whether to automatically associate 
                                        DataFields with the entity.
  Notes:       * If plAssociateDataFields is set to YES, then all existing 
                 datafield instances will be first removed.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcTableNames             AS CHARACTER            NO-UNDO.    /* DB chr(3) table1 ....tableN chr(3) DB .... */
    DEFINE INPUT PARAMETER pcEntityObjectType       AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcEntityProductModule    AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER plAutoProPerform         AS LOGICAL              NO-UNDO.
    DEFINE INPUT PARAMETER piPrefixLength           AS INTEGER              NO-UNDO.
    DEFINE INPUT PARAMETER pcSeparator              AS CHARACTER            NO-UNDO.    /* "Upper", blank or a printable char. */
    DEFINE INPUT PARAMETER pcAuditingEnabled        AS CHARACTER            NO-UNDO.    /* (Y)es, (N)o, (I)gnore */
    DEFINE INPUT PARAMETER pcDescFieldQualifiers    AS CHARACTER            NO-UNDO.    /* blank uses defaults */
    DEFINE INPUT PARAMETER pcKeyFieldQualifiers     AS CHARACTER            NO-UNDO.    /* blank uses defaults */
    DEFINE INPUT PARAMETER pcObjFieldQualifiers     AS CHARACTER            NO-UNDO.    /* blank uses defaults */
    DEFINE INPUT PARAMETER plDeployData             AS LOGICAL              NO-UNDO.
    DEFINE INPUT PARAMETER plVersionData            AS LOGICAL              NO-UNDO.
    DEFINE INPUT PARAMETER plReuseDeletedKeys       AS LOGICAL              NO-UNDO.    
    DEFINE INPUT PARAMETER plAssociateDataFields    AS LOGICAL              NO-UNDO.

    /** Code moved to separate include file to avoid section editor limits.
     *  ----------------------------------------------------------------------- **/
    {ry/inc/rygenogeoi.i}

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generateEntityObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateSBODataLogicObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateSBODataLogicObject Procedure 
PROCEDURE generateSBODataLogicObject :
/*------------------------------------------------------------------------------
  Purpose:     Generates the DLP for the SBO and it's client proxy, compiles them 
               and registers it in the repository
  Parameters:  pcDatabaseName            DB Name (Not used)
               pcTableList               Comma delimited list of supported tables
               pcDumpName                (Not used)
               pcDataObjectName          Name of SBO object 
               pcProductModule           Product module of DLP
               pcResultCode              Result code (Blank is default result code)
               pcLogicProcedureName      Name of new logic procedure to be created
               pcLogicObjectType         Logic type of new procedure (i.e. DLCProc)
               pcLogicProcedureTemplate  Template file to base DLP
               pcDataLogicRelativePath   Relative path of object to be saved
               pcRootFolder              Root directory   (i.e. "C:\workarea")
               pcIncludeFileList         Delimited list of include files of the SBO including relative path
                                         (i.e. modulea/custsdo.i,modulea/ordersdo.i,...)
                                         IMPORTANT:  This must correspond to the pcTableList delimited list
               plCreateMissingFolder    Yes.  Create new directory if relative directory specified doesn't exist
               
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcDatabaseName           AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcTableList              AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcDumpName               AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcDataObjectName         AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcProductModule          AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcResultCode             AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcLogicProcedureName     AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcLogicObjectType        AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcLogicProcedureTemplate AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcDataLogicRelativePath  AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcRootFolder             AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcIncludeFileList        AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER plCreateMissingFolder    AS LOGICAL              NO-UNDO.

    DEFINE VARIABLE cAbsolutePathedName     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cCompileError           AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cRelativePathedName     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cOldPropath             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dSmartObjectObj         AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE hUnknown                AS HANDLE     NO-UNDO.
    
    /* Ensure the data logic procedure contains a .p extension */
    IF NUM-ENTRIES(pcLogicProcedureName,".") < 2 THEN
       ASSIGN pcLogicProcedureName = pcLogicProcedureName + ".p":U.

    /* Create Logic Procedure */
    ASSIGN pcLogicProcedureName     = REPLACE(pcLogicProcedureName,"~\":U,"/":U)
           pcDataLogicRelativePath  = REPLACE(pcDataLogicRelativePath,"~\":U,"/":U)
           pcRootFolder             = REPLACE(pcRootFolder,"~\":U,"/":U)
           pcRootFolder             = RIGHT-TRIM(pcRootFolder,"/":U)  /* Remove trailing forward slash */
           pcIncludeFileList        = REPLACE(pcIncludeFileList,"~\":U,"/":U)
           cRelativePathedName      = RIGHT-TRIM(pcDataLogicRelativePath,"/":U) + "/":U + pcLogicProcedureName
           cAbsolutePathedName      = pcRootFolder + "/":U +  cRelativePathedName
           NO-ERROR. 
    
    /* Generate new DLP static file for SBO */
    RUN af/app/afgensbologp.p ( INPUT cRelativePathedName,
                                INPUT pcRootFolder + "/":U ,
                                INPUT pcLogicProcedureTemplate,
                                INPUT pcTableList,
                                INPUT pcIncludeFileList,
                                INPUT plCreateMissingFolder ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
        RETURN ERROR ("Generation of DataLogic Procedure Failed : " + RETURN-VALUE).

    /* Make sure that the root folder is in the PROPATH */
    ASSIGN cOldPropath = PROPATH
           PROPATH     = pcRootFolder + (IF INDEX(PROPATH, ";":U) GT 0 THEN ";":U ELSE ",":U) + PROPATH.

    IF SEARCH(cAbsolutePathedName) EQ ? THEN
        RETURN ERROR {aferrortxt.i 'AF' '19' '?' '?' "''" "'logic procedure: ' + cAbsolutePathedName"}.

    COMPILE VALUE(cAbsolutePathedName) SAVE NO-ERROR.
    IF COMPILER:ERROR THEN
      ASSIGN cCompileError = "Compiling of DataLogic Procedure Failed :" + CHR(10) + ERROR-STATUS:GET-MESSAGE(1).
        
    IF cCompileError = "":U THEN
    DO:
      ASSIGN cAbsolutePathedName = REPLACE(cAbsolutePathedName, ".p":U, "_cl.p":U).

      IF SEARCH(cAbsolutePathedName) EQ ? THEN
          RETURN ERROR {aferrortxt.i 'AF' '19' '?' '?' "''" "'logic procedure client proxy: ' + cAbsolutePathedName"}.        

      COMPILE VALUE(cAbsolutePathedName) SAVE NO-ERROR.
      IF COMPILER:ERROR THEN
        ASSIGN cCompileError = "Compiling of DataLogic Client Proxy Failed :" + CHR(10) + ERROR-STATUS:GET-MESSAGE(1).
    END.  /* if not compile error */

    /* Reset the PROPATH. */
    ASSIGN PROPATH = cOldPropath.

    /* Generate the Logic Procedure Object */
    /* There are currently no attributes for this object. */
    RUN insertObjectMaster IN ghDesignManager ( INPUT  pcLogicProcedureName,
                                                INPUT  pcResultCode,                           /* pcResultCode         */
                                                INPUT  pcProductModule,                        /* pcProductModuleCode  */
                                                INPUT  pcLogicObjectType,                      /* pcObjectTypeCode     */
                                                INPUT  "Logic Procedure for ":U + pcTableList, /* pcObjectDescription  */
                                                INPUT  pcDataLogicRelativePath,                /* pcDataLogicRelativePath */ 
                                                INPUT  "",                                     /* pcSdoObjectName      */
                                                INPUT  "":U,                                   /* pcSuperProcedureName */
                                                INPUT  NO,                                     /* plIsTemplate         */
                                                INPUT  YES,                                    /* plIsStatic           */
                                                INPUT  "":U,                                   /* pcPhysicalObjectName */
                                                INPUT  NO,                                     /* plRunPersistent      */
                                                INPUT  "":U,                                   /* pcTooltipText        */
                                                INPUT  "":U,                                   /* pcRequiredDBList     */
                                                INPUT  "":U,                                   /* pcLayoutCode         */
                                                INPUT  ?,
                                                INPUT  TABLE-HANDLE hUnknown,
                                                OUTPUT dSmartObjectObj          ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN 
        RETURN ERROR ("Creation of DataLogic Procedure Failed : " + RETURN-VALUE).

    IF cCompileError = "":U THEN
    DO:
      ASSIGN ERROR-STATUS:ERROR = NO.
      RETURN.    
    END.  /* if no compile error */
    ELSE RETURN ERROR cCompileError.
END PROCEDURE.  /* generateSBODataLogicObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateSDOInstances) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateSDOInstances Procedure 
PROCEDURE generateSDOInstances :
/*------------------------------------------------------------------------------
  Purpose:     Associated datafield instances with a given SDO object.
  Parameters:  pcSdoObjectName           -
               pcResultCode              -
               plDeleteExistingInstances - 
               pcTableList               - 
  Notes:       * Only the Enabled flag is set here - all other attributes
                 are inherited from the schema, because the SDO .i fields 
                 are created with the LIKE option, so the information is 
                 inherited from the schema.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcSdoObjectName              AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcResultCode                 AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER plDeleteExistingInstances    AS LOGICAL          NO-UNDO.
    DEFINE INPUT PARAMETER pcTableList                  AS CHARACTER        NO-UNDO.
    
    DEFINE VARIABLE dSdoObjectObj               AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE dInstanceSmartObjectObj     AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE dObjectInstanceObj          AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE cUpdatableColumns           AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cTableNames                 AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cTableColumns               AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cAllColumns                 AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cColumn                     AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cTable                      AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hStoreAttributeBuffer       AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hStoreAttributeTable        AS HANDLE       NO-UNDO.
    DEFINE VARIABLE iFieldLoop                  AS INTEGER      NO-UNDO.
    DEFINE VARIABLE iTableLoop                  AS INTEGER      NO-UNDO.
    DEFINE VARIABLE cPropertyNames              AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cPropertyValues             AS CHARACTER    NO-UNDO.

    IF plDeleteExistingInstances THEN
    DO:
        RUN removeObjectInstance IN ghDesignManager ( INPUT pcSdoObjectName,
                                                      INPUT pcResultCode,
                                                      INPUT "":U,          /* pcInstanceObjectName */
                                                      INPUT "":U,          /* pcInstanceName       */
                                                      INPUT pcResultCode   ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    END.    /* delete existing instances. */

    /* get the Object_obj of the SDO */
    dSdoObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN gshRepositoryManager,pcSdoObjectName).
    IF dSdoObjectObj = 0 OR dSdoObjectObj = ? THEN
        RETURN ERROR {aferrortxt.i 'AF' '15' '?' '?' "'the DataObject ' + pcSdoObjectName + ' could not be found.'" }.

    ASSIGN cPropertyNames  = "DataColumnsByTable,UpdatableColumns,Tables":U
            cPropertyValues = "":U.
            
   RUN getInstanceProperties IN gshRepositoryManager ( INPUT  pcSdoObjectName,
                                                       INPUT  "",
                                                       INPUT-OUTPUT cPropertyNames,
                                                       OUTPUT cPropertyValues ) NO-ERROR.
    ASSIGN cAllColumns       = ENTRY(LOOKUP("DataColumnsByTable":U, cPropertyNames), cPropertyValues, CHR(1) ) 
           cUpdatableColumns = ENTRY(LOOKUP("UpdatableColumns":U, cPropertyNames), cPropertyValues, CHR(1) ) 
           cTableNames       = ENTRY(LOOKUP("Tables":U, cPropertyNames), cPropertyValues, CHR(1) ) 
           NO-ERROR.
    
    IF cTableNames = "":U THEN
      cTableNames = pcTableList.

    /* I needed to only add the main table's field's as instances
     * since any joined table might have the same fields and this
     * is renamed and will thus fail here since the name of the 
     * field is now different from table.fieldName  */
    DO iTableLoop = 1 TO 1: /* NUM-ENTRIES(cTableNames): Mark Davies (MIP) 27/07/2002 */
        ASSIGN cTableColumns = ENTRY(iTableLoop, cAllColumns, ";":U).

        DO iFieldLoop = 1 TO NUM-ENTRIES(cTableColumns):
            ASSIGN cColumn = ENTRY(iFieldLoop, cTableColumns)
                   cTable  = ENTRY(iTableLoop, cTableNames).

            /* Strip off the DB qualifier, if any */
            IF NUM-ENTRIES(cTable, ".":U) EQ 2  THEN
                ASSIGN cTable = ENTRY(2, cTable, ".":U).

            EMPTY TEMP-TABLE ttStoreAttribute.

            CREATE ttStoreAttribute.
            ASSIGN ttStoreAttribute.tAttributeParent    = "INSTANCE":U
                   ttStoreAttribute.tAttributeParentObj = 0
                   ttStoreAttribute.tAttributeLabel     = "Enabled":U
                   ttStoreAttribute.tConstantValue      = NO
                   ttStoreAttribute.tLogicalValue       = CAN-DO(cUpdatableColumns, cColumn).

            ASSIGN hStoreAttributeBuffer = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE
                   hStoreAttributeTable  = ?.

            RUN insertObjectInstance IN ghDesignManager ( INPUT  dSdoObjectObj,                            /* pdContainerObjectObj               */
                                                          INPUT  (cTable + ".":U + cColumn),               /* Contained Instance Object Name     */
                                                          INPUT  pcResultCode,                             /* pcResultCode,                      */
                                                          INPUT  (cTable + ".":U + cColumn),               /* pcInstanceName                     */
                                                          INPUT  "":U,                                     /* pcInstanceDescription,             */
                                                          INPUT  "":U,                                     /* pcLayoutPosition,                  */
                                                          INPUT  ?,                                        /* Page number - not applicable */
                                                          INPUT  iFieldLoop,                               /* Object sequence */
                                                          INPUT  NO,                                       /* plForceCreateNew,                  */
                                                          INPUT  hStoreAttributeBuffer,                    /* phAttributeValueBuffer,            */
                                                          INPUT  TABLE-HANDLE hStoreAttributeTable,        /* TABLE-HANDLE phAttributeValueTable */
                                                          OUTPUT dInstanceSmartObjectObj,                  /* pdSmartObjectObj,                  */
                                                          OUTPUT dObjectInstanceObj            ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
        END.    /* loop through fields */
    END.    /* loop through tables */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generateSDOInstances */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateVisualObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateVisualObject Procedure 
PROCEDURE generateVisualObject :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     Creates a dynamic browse, based on a table and/or SDO
  Parameters:  
  Notes:       * This API is the starting point to create both dyn browses & viewers from the OG.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcObjectType              AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pcObjectName              AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pcProductModuleCode       AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pcResultCode              AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pcSdoObjectName           AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pcTableName               AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pcDataBaseName            AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER piMaxObjectFields         AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER piMaxFieldsPerColumn      AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER plGenerateFromDataObject  AS LOGICAL   NO-UNDO.
    DEFINE INPUT  PARAMETER pcDataObjectFieldList     AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER plDeleteExistingInstances AS LOGICAL   NO-UNDO.
    DEFINE INPUT  PARAMETER pcDataObjectFieldSequence AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER plUseSDOFieldOrder        AS LOGICAL   NO-UNDO.
    DEFINE OUTPUT PARAMETER pdVisualObjectObj         AS DECIMAL   NO-UNDO.

    DEFINE VARIABLE hQuery                  AS HANDLE               NO-UNDO. 
    DEFINE VARIABLE hObjectBuffer           AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hFieldBuffer            AS HANDLE               NO-UNDO.
    DEFINE VARIABLE dEntityInstanceId       AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dCustomisationResultObj AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dSdoObjectObj           AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE cObjectDescription      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cAllColumns             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cUpdatableColumns       AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cTableNames             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDatabaseNames          AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDatabase               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cEnabledDatabases       AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDisplayedDatabases     AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cEnabledTables          AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDisplayedTables        AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cEnabledFields          AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDisplayedFields        AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFieldName              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cProcedureName          AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cWidgetPoolName         AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cTable                  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cColumn                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cViewerClasses          AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cBrowseClasses          AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cTableColumns           AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iTableLoop              AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iFieldLoop              AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iFieldCount             AS INTEGER              NO-UNDO.
    DEFINE VARIABLE hSdo                    AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cCalcClassList          AS CHARACTER            NO-UNDO.

    IF plGenerateFromDataObject EQ ? THEN
        ASSIGN plGenerateFromDataObject = FALSE.
    IF plUseSDOFieldOrder EQ ? THEN
        ASSIGN plUseSDOFieldOrder = FALSE.

    if pcProductModuleCode eq ? or pcProductModuleCode eq '':u then
        return error {aferrortxt.i 'AF' '1' '?' '?' '"product module code"'}.
            
    if not can-find(first gsc_product_module where
                          gsc_product_module.product_module_code = pcProductModuleCode) then
        return error {aferrortxt.i 'AF' '5' '?' '?' '"product module"' "'Product module code: ' + pcProductModuleCode"}.

    /* Find the result code */
    IF pcResultCode EQ "":U THEN
        ASSIGN pcResultCode = "{&DEFAULT-RESULT-CODE}":U.

    IF pcResultCode NE "{&DEFAULT-RESULT-CODE}":U THEN
    DO:
        FIND FIRST ryc_customization_result WHERE
                   ryc_customization_result.customization_result_code = pcResultCode
                   NO-LOCK NO-ERROR.
        IF AVAILABLE ryc_customization_result THEN
            ASSIGN dCustomisationResultObj = ryc_customization_result.customization_result_Obj.
        ELSE
            RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'Customization Result'" pcResultCode}.
    END.    /* find the result code */
    ELSE
        ASSIGN dCustomisationResultObj = 0.

    /* There must always be an SDO associated with a browse. This is used for design purposes.
     * At runtime, the DATA-SOURCE data object is used. */
    IF pcSdoObjectName EQ "":U THEN
        RETURN ERROR {aferrortxt.i 'AF' '1' '?' '?' "'SDO Object'"}.

    ASSIGN dSdoObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN gshRepositoryManager,
                                            INPUT pcSdoObjectName,
                                            INPUT dCustomisationResultObj).
    IF dSdoObjectObj EQ 0 THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'SDO Object'" pcSdoObjectName}.

    ASSIGN iFieldCount = 0.

    /* Use fields in SDO */
    IF plGenerateFromDataObject THEN
    DO:
        RUN startDataObject IN gshRepositoryManager ( INPUT pcSdoObjectName, OUTPUT hSdo).

        &SCOPED-DEFINE xp-assign
        {get DataColumnsByTable cAllColumns hSdo}
        {get UpdatableColumnsByTable cUpdatableColumns hSdo}
        {get PhysicalTables cTableNames hSdo}
        {get DbNames cDatabaseNames hSdo}.
        &UNDEFINE xp-assign

        /* Shut the running SDO down. */
        RUN deleteObject IN hSdo NO-ERROR.
        ASSIGN hSdo = ?.

        ASSIGN cUpdatableColumns = REPLACE(cUpdatableColumns,";":U,",":U) 
               cUpdatableColumns = REPLACE(cUpdatableColumns,CHR(1),",":U) .

        BLKUseSDOFields:
        DO iTableLoop = 1 TO NUM-ENTRIES(cTableNames):
            ASSIGN cTableColumns = ENTRY(iTableLoop, cAllColumns, {&adm-tabledelimiter}).
            
            IF iFieldCount = piMaxObjectFields THEN
                LEAVE BLKUseSDOFields.

            DO iFieldLoop = 1 TO NUM-ENTRIES(cTableColumns):
                IF iFieldCount = piMaxObjectFields THEN
                    LEAVE BLKUseSDOFields.

                ASSIGN cColumn   = ENTRY(iFieldLoop, cTableColumns)
                       cTable    = ENTRY(iTableLoop, cTableNames)
                       cDatabase = (IF NUM-ENTRIES(cTable,".":U) > 1 THEN ENTRY(1,cTable,".":U) ELSE "":U)
                       NO-ERROR.

                IF cDatabase EQ ? OR cDatabase EQ "":U THEN
                    ASSIGN cDatabase = DYNAMIC-FUNCTION("getBufferDbName":U IN ghDesignManager, INPUT cTable).

                IF cDatabase EQ ? OR cDatabase EQ "":U THEN
                    ASSIGN cDatabase = LDBNAME("DICTDB":U).

                IF cDatabase EQ ? THEN
                    ASSIGN cDatabase = "":U.

                /* Keep _OBJ fields since they may be used for Dynamic Lookups and/or Combos. */
                /* Always add these to the Displayed lists. */
                IF CAN-DO(pcDataObjectFieldList, cColumn) THEN
                    ASSIGN cDisplayedFields = cDisplayedFields + cColumn + ",":U
                           iFieldCount      = iFieldCount      + 1.

                IF NOT CAN-DO(cDisplayedTables, cTable) THEN
                    ASSIGN cDisplayedTables = cDisplayedTables + cTable + ",":U.

                IF NOT CAN-DO(cDisplayedDatabases, cDatabase) AND cDatabase NE "":U THEN
                    ASSIGN cDisplayedDatabases = cDisplayedDatabases + cDatabase + ",":U.

                IF CAN-DO(cUpdatableColumns, cColumn) THEN
                DO:
                    ASSIGN cEnabledFields = cEnabledFields + cColumn + ",":U.

                    IF NOT CAN-DO(cEnabledTables, cTable) THEN
                        ASSIGN cEnabledTables = cEnabledTables + cTable + ",":U.

                    IF NOT CAN-DO(cEnabledDatabases, cDatabase) AND cDatabase NE "":U THEN
                        ASSIGN cEnabledDatabases = cEnabledDatabases + cDatabase + ",":U.
                END.    /* Enabled columns */
            END.    /* field loop */
        END.    /* BLKUseSDOFields: table loop */
    END.    /* Use SDO fields */
    ELSE DO:
        ASSIGN cDisplayedTables    = pcTableName
               cDisplayedDatabases = pcDatabaseName.
        RUN retrieveDesignObject IN ghDesignManager 
                          ( INPUT  pcTableName,
                            INPUT  "":U ,
                            OUTPUT TABLE ttObject,
                            OUTPUT TABLE ttPage,
                            OUTPUT TABLE ttLink,
                            OUTPUT TABLE ttUiEvent,
                            OUTPUT TABLE ttObjectAttribute ) NO-ERROR.
        if return-value ne '':u or error-status:error then return error return-value.
               
        cCalcClassList = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT 'CalculatedField':U).

        /* get all instances and determine their sequence */
        FOR EACH ttObject WHERE ttObject.tContainerSmartObjectObj > 0 
                             BY ttObject.tPageObjectSequence: 

           IF iFieldCount EQ piMaxObjectFields OR
              LOOKUP(ttObject.tClassName,cCalcClassList) > 0 THEN
               LEAVE.

           ASSIGN cDisplayedFields = cDisplayedFields + ttObject.tObjectInstanceName + ",":U
                  iFieldCount      = iFieldCount      + 1.
        END. /* For each ttObject */
    END.    /* not in SDO */

    ASSIGN cDisplayedFields    = TRIM(cDisplayedFields, ",":U)
           cDisplayedTables    = TRIM(cDisplayedTables, ",":U)
           cDisplayedDatabases = TRIM(cDisplayedDatabases, ",":U)
           cEnabledFields      = TRIM(cEnabledFields, ",":U)
           cEnabledTables      = TRIM(cEnabledTables, ",":U)
           cEnabledDatabases   = TRIM(cEnabledDatabases, ",":U).

    /* If there are no selected fields here, get the fields off the metaschema. */
    IF cDisplayedFields EQ "":U THEN
        RETURN ERROR {aferrortxt.i 'AF' '40' '?' '?' "'no display fields could be calculated for' + pcTableName" }.

    /* Determine which generateDynamic* procedure to run. */
    IF DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, INPUT pcObjectType, INPUT "DynView":U ) THEN
        ASSIGN cProcedureName     = "generateDynamicViewer":U
               cObjectDescription = "Dynamic viewer for " + (IF plGenerateFromDataObject THEN pcSdoObjectName ELSE pcTableName).
    ELSE
    IF DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager, INPUT pcObjectType, INPUT "DynBrow":U ) THEN
        ASSIGN cProcedureName     = "generateDynamicBrowse":U
               cObjectDescription = "Dynamic browse for " + (IF plGenerateFromDataObject THEN pcSdoObjectName ELSE pcTableName).
    ELSE
        RETURN ERROR {aferrortxt.i 'RY' '13' '?' '?' "'~~'' + pcObjectType + '~~''" "'DynBrow or DynView '"}.

    /* If there are no displayed fields, there can be no displayed tables or databases */
    IF cDisplayedFields EQ "":U THEN
        ASSIGN cDisplayedTables    = "":U
               cDisplayedDatabases = "":U.

    IF cEnabledFields EQ "":U THEN
        ASSIGN cEnabledTables    = "":U
               cEnabledDatabases = "":U.

    /* Unless we are generating objects from the SDO, there is no way of knowing whether or not a particular field is enabled.
     * We therefore assume that all fields are enabled. */
    IF NOT plGenerateFromDataObject THEN
        ASSIGN cEnabledFields    = cDisplayedFields
               cEnabledTables    = cDisplayedTables
               cEnabledDatabases = cDisplayedDatabases.

    IF NOT plUseSDOFieldOrder THEN
    DO:
        ASSIGN pcDataObjectFieldList = "":U.
        IF plGenerateFromDataObject THEN
            ASSIGN pcDataObjectFieldList = cDisplayedFields.
    END.    /* Don't use SDO field order */

    RUN VALUE(cProcedureName) IN ghDesignManager ( INPUT  pcObjectType,
                                                   INPUT  pcObjectName,
                                                   INPUT  cObjectDescription,
                                                   INPUT  pcProductModuleCode,
                                                   INPUT  pcResultCode,
                                                   INPUT  pcSdoObjectName,
                                                   INPUT  plDeleteExistingInstances,
                                                   INPUT  cDisplayedDatabases,
                                                   INPUT  cEnabledDatabases,
                                                   INPUT  cDisplayedTables,
                                                   INPUT  cEnabledTables,
                                                   INPUT  cDisplayedFields,
                                                   INPUT  cEnabledFields,
                                                   INPUT  piMaxFieldsPerColumn,
                                                   INPUT  pcDataObjectFieldSequence,
                                                   INPUT  pcDataObjectFieldList,
                                                   OUTPUT pdVisualObjectObj              ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generateVisualObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableJoins) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTableJoins Procedure 
PROCEDURE getTableJoins :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is passed a table and scans the database indeces
               for linked tables and builds a query with all the linked tables
               and returns a table list and fields to display aswell as the 
               query that needs to be appended to the master query.
  Parameters:  pcDataBaseName - The logical Database name of the table
               pcTableName    - The table name of the table you need to find linking
                                tables for
               piFollowDepth  - An integer value with the max number of levels of 
                                joins to append to the query - 0 (zero) for all
               pcAddOnQuery   - This will contain the full quert to be appended
                                to the base query - you will need to add a comma 
                                plus this value to your base query
               pcAddedTables  - This will return a comma seperated list of table
                                names that were included in the follow on query
               pcDisplayField - This will return a comma seperated list of field
                                names that will display descriptave information
                                of the table being linked to.
               pcAddTableList  - This will return a list of tables to be appended
                                to the list of tables in the base query for 
                                writing to the QueryBuilderTableList attribute
               pcJoinCode      - This will return the join code for writing to
                                the QueryBuilderJoinCode attribute
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcDataBaseName  AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcTableName     AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER piFollowDepth   AS INTEGER    NO-UNDO.
    DEFINE OUTPUT PARAMETER pcAddonQuery    AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcAddedTables   AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcDisplayFields AS CHARACTER  NO-UNDO.  
    DEFINE OUTPUT PARAMETER pcAddTableList  AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcJoinCode      AS CHARACTER  NO-UNDO.

    /** Code moved into this include because of section editor limits.
     *  ----------------------------------------------------------------------- **/
    {ry/inc/rygenogtji.i}

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* getTableJoins */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ripViewAsPhrase) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ripViewAsPhrase Procedure 
PROCEDURE ripViewAsPhrase :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will step through the VIEW-AS Phrase passed to
               it and strip out all the specific details and ensure that an
               attribute record is created for it.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcViewASPhrase  AS CHARACTER                NO-UNDO.

    DEFINE VARIABLE iLoop           AS INTEGER                          NO-UNDO.
    DEFINE VARIABLE cViewASList     AS CHARACTER      EXTENT 100        NO-UNDO.
    DEFINE VARIABLE cWidgetType     AS CHARACTER                        NO-UNDO.
    DEFINE VARIABLE cWidgetAttr     AS CHARACTER                        NO-UNDO.
    DEFINE VARIABLE cPhraseList     AS CHARACTER                        NO-UNDO.
    DEFINE VARIABLE lQt             AS LOGICAL                          NO-UNDO.
    DEFINE VARIABLE cValue          AS CHARACTER                        NO-UNDO.
    DEFINE VARIABLE cOrigViewAs     AS CHARACTER                        NO-UNDO.
    DEFINE VARIABLE cAnalProc       AS CHARACTER                        NO-UNDO.
    DEFINE VARIABLE cAnalValues     AS CHARACTER      EXTENT 100        NO-UNDO.
    DEFINE VARIABLE dHeightChars    AS DECIMAL                          NO-UNDO.
    DEFINE VARIABLE dWidthChars     AS DECIMAL                          NO-UNDO.

    ASSIGN cOrigViewAs    = pcViewASPhrase /* Save the original view-as phrase - we might need it later */
           pcViewASPhrase = REPLACE(pcViewASPhrase,CHR(10)," ":U)
           pcViewASPhrase = TRIM(REPLACE(pcViewASPhrase,"VIEW-AS ":U,"":U))
           cWidgetType    = TRIM(ENTRY(1,pcViewASPhrase," ":U)).

    /* Only do this for allowed VIEW-AS Widgets */
    IF LOOKUP(cWidgetType, gcUSE-SCHEMA-VIEW-AS) = 0 THEN
        RETURN.

    /* Get rid of spaces in LIST-ITEMS/LIST-ITEM-PAIRS/RADIO-BUTTONS etc. */
    DO WHILE INDEX(pcViewASPhrase,", ":U) > 0 OR INDEX(pcViewASPhrase," ,":U) > 0:
        ASSIGN pcViewASPhrase = REPLACE(pcViewASPhrase,", ":U,",":U)
               pcViewASPhrase = REPLACE(pcViewASPhrase," ,":U,",":U).
    END.    /* get rid of spaces */

    /* Replaces spaces in text of TOOLTIPS/LIST-ITEMS etc. */
    DO iLoop = 1 TO LENGTH(pcViewASPhrase):
        IF SUBSTRING(pcViewASPhrase,iLoop,1) = " ":U AND lQt THEN
            SUBSTRING(pcViewASPhrase,iLoop,1) = CHR(2).

        IF ASC(SUBSTRING(pcViewASPhrase,iLoop,1)) = 34 OR
           ASC(SUBSTRING(pcViewASPhrase,iLoop,1)) = 39 THEN
            ASSIGN lQt = IF lQt THEN FALSE ELSE TRUE.
    END.    /* replace spaces in tooltips etc */

    DO iLoop = 1 TO NUM-ENTRIES(pcViewASPhrase," ":U):
        ASSIGN cViewASList[iLoop] = TRIM(ENTRY(iLoop,pcViewASPhrase," ":U)).
    END.    /* loop through pieces of view-as phrase */

    ASSIGN cPhraseList = "":U.
    DO iLoop = 2 TO 100:
        IF cViewASList[iLoop] = "":U THEN NEXT.

        ASSIGN cValue      = REPLACE(cViewASList[iLoop],CHR(2)," ":U)
               cValue      = REPLACE(cValue,"'","":U)
               cValue      = REPLACE(cValue,'"',"":U)
               cPhraseList = IF cPhraseList = "":U THEN cValue ELSE cPhraseList + "|":U + cValue.
    END.    /* loop through extra information */
    
    /*
    Commented out to allow default attributes to be set - see issue 11196
    IF (cPhraseList = "":U OR cPhraseList = "|":U) THEN
        RETURN.
    */

    CASE cWidgetType:
        WHEN "EDITOR":U         THEN ASSIGN cWidgetAttr = DYNAMIC-FUNCTION("getEditorAttributes":U IN TARGET-PROCEDURE, INPUT cPhraseList).
        WHEN "COMBO-BOX":U      THEN ASSIGN cWidgetAttr = DYNAMIC-FUNCTION("getComboBoxAttributes":U IN TARGET-PROCEDURE, INPUT cPhraseList).
        WHEN "RADIO-SET":U      THEN ASSIGN cWidgetAttr = DYNAMIC-FUNCTION("getRadioSetAttributes":U IN TARGET-PROCEDURE, INPUT cPhraseList).
        WHEN "SELECTION-LIST":U THEN ASSIGN cWidgetAttr = DYNAMIC-FUNCTION("getSelectionListAttributes":U IN TARGET-PROCEDURE, INPUT cPhraseList).
    END CASE.   /* widget type */
    
    IF cWidgetAttr = "":U THEN
        RETURN.

    DO iLoop = 1 TO NUM-ENTRIES(cWidgetAttr,CHR(4)):
        CREATE ttStoreAttribute.
        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
               ttStoreAttribute.tAttributeParentObj = 0
               ttStoreAttribute.tAttributeLabel     = ENTRY(1,ENTRY(iLoop,cWidgetAttr,CHR(4)),"^":U)
               ttStoreAttribute.tConstantValue      = NO.
        CASE ENTRY(2,ENTRY(iLoop,cWidgetAttr,CHR(4)),"^":U):
            WHEN "CHARACTER":U THEN ASSIGN ttStoreAttribute.tCharacterValue = ENTRY(3,ENTRY(iLoop,cWidgetAttr,CHR(4)),"^":U).
            WHEN "INTEGER":U   THEN ASSIGN ttStoreAttribute.tIntegerValue = INTEGER(ENTRY(3,ENTRY(iLoop,cWidgetAttr,CHR(4)),"^":U)).
            WHEN "DECIMAL":U   THEN ASSIGN ttStoreAttribute.tDecimalValue = DECIMAL(ENTRY(3,ENTRY(iLoop,cWidgetAttr,CHR(4)),"^":U)).
            WHEN "LOGICAL":U   THEN ASSIGN ttStoreAttribute.tLogicalValue = LOGICAL(ENTRY(3,ENTRY(iLoop,cWidgetAttr,CHR(4)),"^":U)).
        END CASE.   /* entry 2 of widget attributes */
    END.    /* loop through widget attributes */

    /* Ensure we always have a WIDTH-CHARS and HEIGHT-CHARS Attribute to
     * ensure compatability with Dynamic Viewers */
    IF NOT CAN-FIND(FIRST ttStoreAttribute WHERE 
                          (ttStoreAttribute.tAttributeLabel = "WIDTH-CHARS":U OR
                           ttStoreAttribute.tAttributeLabel = "HEIGHT-CHARS":U) AND
                          ttStoreAttribute.tDecimalValue > 0                        ) THEN
    DO:
        /* We need to run the ANALYSER to predict the Width and Height
         * of an Editor or Selection list */
        IF cWidgetType = "EDITOR":U OR cWidgetType = "SELECTION-LIST":U THEN
        DO:
            ASSIGN cAnalProc = SESSION:TEMP-DIR + "dynanal.p":U.
            OUTPUT STREAM stAnalyze TO VALUE(cAnalProc).

            PUT STREAM stAnalyze UNFORMATTED
                "DEFINE VARIABLE cAnalyse AS CHARACTER NO-UNDO.":U SKIP(1)
                "FORM cAnalyse " + cOrigViewAs.
            OUTPUT STREAM stAnalyze CLOSE.

            /* If the file wasn't created - give up! */ 
            IF SEARCH(cAnalProc) = ? THEN
                RETURN.

            ANALYZE VALUE(cAnalProc) VALUE(REPLACE(cAnalProc,".p":U,".anl":U)) NO-ERROR.
            INPUT STREAM stAnalyze FROM VALUE(REPLACE(cAnalProc,".p":U,".anl":U)) NO-MAP.
            IF SEARCH(REPLACE(cAnalProc,".p":U,".anl":U)) = ? THEN
                RETURN.

            ANALIZER_BLOCK:
            REPEAT:
                IMPORT STREAM stAnalyze cAnalValues.
                IF cAnalValues[1] = "SE":U OR cAnalValues[1] = "ED":U THEN
                DO:
                    IMPORT STREAM stAnalyze cAnalValues.

                    /* The ANALYZER will always write the values in American format - we should ensure that when we convert 
                     * it to DECIMAL that we use the correct NUMERIC-DECIMAL-POINT  - ISSUE #7251 */
                    ASSIGN dWidthChars  = DECIMAL(REPLACE(cAnalValues[5],".":U,SESSION:NUMERIC-DECIMAL-POINT)) NO-ERROR.
                    IF ERROR-STATUS:ERROR OR dWidthChars = ? THEN
                        ASSIGN dWidthChars = 0.

                    /* The ANALYZER will always write the values in American format - we should ensure that when we convert 
                     * it to DECIMAL that we use the correct NUMERIC-DECIMAL-POINT  - ISSUE #7251 */
                    ASSIGN dHeightChars = DECIMAL(REPLACE(cAnalValues[6],".":U,SESSION:NUMERIC-DECIMAL-POINT)) NO-ERROR.
                    IF ERROR-STATUS:ERROR OR dHeightChars = ? THEN
                        ASSIGN dHeightChars = 0.

                    /* We know that the Width and Height is stored in field 5 and 6 */
                    LEAVE ANALIZER_BLOCK.
                END.    /* First value is SE or ED */
            END.    /*  ANALIZER_BLOCK: */

            INPUT STREAM stAnalyze CLOSE.
            
            /* Remove physical files on disk */
            OS-DELETE VALUE(cAnalProc).
            OS-DELETE VALUE(REPLACE(cAnalProc,".p":U,".anl":U)).

            /* Add new attributes to store height and width */
            IF dWidthChars <> 0 THEN
            DO:
                FIND FIRST ttStoreAttribute WHERE
                           ttStoreAttribute.tAttributeLabel = "WIDTH-CHARS":U
                           NO-ERROR.

                IF NOT AVAILABLE ttStoreAttribute THEN  
                DO:
                    CREATE ttStoreAttribute.
                    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                           ttStoreAttribute.tAttributeParentObj = 0
                           ttStoreAttribute.tAttributeLabel     = "WIDTH-CHARS":U
                           ttStoreAttribute.tConstantValue      = NO.
                END.    /* n/a store attribute record */

                ASSIGN ttStoreAttribute.tDecimalValue = dWidthChars.
            END.    /* there is a width */

            IF dHeightChars <> 0 THEN
            DO:
                FIND FIRST ttStoreAttribute WHERE
                           ttStoreAttribute.tAttributeLabel = "HEIGHT-CHARS":U
                           NO-ERROR.
                IF NOT AVAILABLE ttStoreAttribute THEN
                DO:
                    CREATE ttStoreAttribute.
                    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                           ttStoreAttribute.tAttributeParentObj = 0
                           ttStoreAttribute.tAttributeLabel     = "HEIGHT-CHARS":U
                           ttStoreAttribute.tConstantValue      = NO.
                END.    /* n/a store attribute record */

                ASSIGN ttStoreAttribute.tDecimalValue = dHeightChars.
            END.    /* there is a width */
        END.    /* widget type is editor or selection list */
    END.    /* no height or width attributes found. */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* ripViewAsPhrase */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-buildDataFieldAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildDataFieldAttribute Procedure 
FUNCTION buildDataFieldAttribute RETURNS LOGICAL
    ( INPUT plForceOverride         AS LOGICAL,
      INPUT pcPrimaryFieldName      AS CHARACTER,
      INPUT piPrimaryDataType       AS INTEGER,
      INPUT pcPrimaryValue          AS CHARACTER,
      INPUT pcSecondaryFieldName    AS CHARACTER,
      INPUT pcSecondaryValue        AS CHARACTER,
      INPUT pcNewCharacterValue     AS CHARACTER  ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Builds records in the ttStoreAttribute TT.
    Notes:  * This function is PRIVATE to the Repository Design Manager. It is
              not intended for use outside of the context of generateDataFields().
            * The primary field is the SCHEMA-* field (SCHEMA-FORMAT say) and the
              secondary field is the field that the visual objects use (eg FORMAT).
------------------------------------------------------------------------------*/
       CREATE ttStoreAttribute.
       ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
              ttStoreAttribute.tAttributeParentObj = 0
              ttStoreAttribute.tAttributeLabel     = pcPrimaryFieldName
              ttStoreAttribute.tConstantValue      = YES.
       CASE piPrimaryDataType:
           WHEN {&DECIMAL-DATA-TYPE} THEN ASSIGN ttStoreAttribute.tDecimalValue = DECIMAL(pcNewCharacterValue) NO-ERROR.
           WHEN {&INTEGER-DATA-TYPE} THEN ASSIGN ttStoreAttribute.tIntegerValue = INTEGER(pcNewCharacterValue) NO-ERROR.
           WHEN {&DATE-DATA-TYPE}    THEN ASSIGN ttStoreAttribute.tDateValue    = DATE(pcNewCharacterValue) NO-ERROR.
           WHEN {&LOGICAL-DATA-TYPE} THEN ASSIGN ttStoreAttribute.tLogicalValue = LOGICAL(pcNewCharacterValue) NO-ERROR.
           OTHERWISE ASSIGN ttStoreAttribute.tCharacterValue = pcNewCharacterValue.
       END CASE.   /* data type */                  

       IF pcSecondaryFieldName > "" AND
          (plForceOverride OR  pcSecondaryValue EQ pcPrimaryValue ) THEN
       DO:
           CREATE ttStoreAttribute.
           ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                  ttStoreAttribute.tAttributeParentObj = 0
                  ttStoreAttribute.tAttributeLabel     = pcSecondaryFieldName
                  ttStoreAttribute.tConstantValue      = NO.
           CASE piPrimaryDataType:
               WHEN {&DECIMAL-DATA-TYPE} THEN ASSIGN ttStoreAttribute.tDecimalValue = DECIMAL(pcNewCharacterValue) NO-ERROR.
               WHEN {&INTEGER-DATA-TYPE} THEN ASSIGN ttStoreAttribute.tIntegerValue = INTEGER(pcNewCharacterValue) NO-ERROR.
               WHEN {&DATE-DATA-TYPE}    THEN ASSIGN ttStoreAttribute.tDateValue    = DATE(pcNewCharacterValue) NO-ERROR.
               WHEN {&LOGICAL-DATA-TYPE} THEN ASSIGN ttStoreAttribute.tLogicalValue = LOGICAL(pcNewCharacterValue) NO-ERROR.
               OTHERWISE ASSIGN ttStoreAttribute.tCharacterValue = pcNewCharacterValue.
           END CASE.   /* data type */
       END.    /* need to update secondary field. */
        
    

    RETURN TRUE.
END FUNCTION.   /* buildDataFieldAttribute */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cleanStoreAttributeValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cleanStoreAttributeValues Procedure 
FUNCTION cleanStoreAttributeValues RETURNS LOGICAL
    ( INPUT pcObjectName                AS CHARACTER,
      INPUT pcClassName                 AS CHARACTER,
      INPUT pcCleanToLevel              AS CHARACTER,
      INPUT phStoreAttributeBuffer      AS HANDLE       ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PROTECTED
  Purpose:  Cleans up the ttStoreAttribute TT
    Notes: * We need to compare default values set at the class and master object 
             level to ensure that we do not add attributes at instance level that
             will cause unnecessary duplication of values.
           * pcCleanToLevel - MASTER, CLASS: Master used when validating instances
                              and CLASS used when validating Masters.
           * pcClassName - only required when pcCleanToLevel is CLASS.
           
           * This code has been moved to the Rep Design Manager - it should be
             called there. This stub remains for backwards compatability.
------------------------------------------------------------------------------*/
    return dynamic-function('cleanStoreAttributeValues':U in ghDesignManager,
                            pcObjectName,
                            pcClassName,
                            pcCleanToLevel,
                            phStoreAttributeBuffer).
END FUNCTION.   /* cleanStoreAttributeValues */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getComboBoxAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getComboBoxAttributes Procedure 
FUNCTION getComboBoxAttributes RETURNS CHARACTER
    ( INPUT pcViewAsList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This procedure will check what attributes are set in the view-as 
            phrase applicable for a COMBO-BOX Widget
    Notes:  It will create a CHR(4) seperated list of attributes to be created
            with a comma seperated list of:
            Attribute Name
            Data Type
            Value           
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cExtraAttributes AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cValue           AS CHARACTER  NO-UNDO.
    
    IF (LOOKUP("DROP-DOWN-LIST":U,pcViewAsList,"|":U) < 1) AND (LOOKUP("DROP-DOWN":U,pcViewAsList,"|":U) < 1) THEN
        ASSIGN pcViewAsList = pcViewAsList + (IF pcViewAsList = "":U THEN "":U ELSE "|":U) + "DROP-DOWN-LIST":U.
    
    IF LOOKUP("SIZE":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cValue           = ENTRY(LOOKUP("SIZE",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "WIDTH-CHARS^DECIMAL^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "WIDTH-CHARS^DECIMAL^" + cValue
               cValue           = ENTRY(LOOKUP("SIZE",pcViewAsList,"|":U) + 3,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "HEIGHT-CHARS^DECIMAL^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "HEIGHT-CHARS^DECIMAL^" + cValue.
    
    IF LOOKUP("SIZE-CHARS":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cValue           = ENTRY(LOOKUP("SIZE-CHARS",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "WIDTH-CHARS^DECIMAL^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "WIDTH-CHARS^DECIMAL^" + cValue
               cValue           = ENTRY(LOOKUP("SIZE-CHARS",pcViewAsList,"|":U) + 3,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "HEIGHT-CHARS^DECIMAL^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "HEIGHT-CHARS^DECIMAL^" + cValue.
    
    IF LOOKUP("SIZE-PIXELS":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cValue           = ENTRY(LOOKUP("SIZE-PIXELS",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "WIDTH-PIXELS^INTEGER^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "WIDTH-PIXELS^INTEGER^" + cValue
               cValue           = ENTRY(LOOKUP("SIZE-PIXELS",pcViewAsList,"|":U) + 3,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "HEIGHT-PIXELS^INTEGER^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "HEIGHT-PIXELS^INTEGER^" + cValue.
                                                              
    IF LOOKUP("LIST-ITEMS":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cValue           = ENTRY(LOOKUP("LIST-ITEMS",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "LIST-ITEMS^CHARACTER^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "LIST-ITEMS^CHARACTER^" + cValue.
    
    IF LOOKUP("LIST-ITEM-PAIRS":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cValue = ENTRY(LOOKUP("LIST-ITEM-PAIRS",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "LIST-ITEM-PAIRS^CHARACTER^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "LIST-ITEM-PAIRS^CHARACTER^" + cValue.
                                                              
    IF LOOKUP("INNER-LINES":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cValue           = ENTRY(LOOKUP("INNER-LINES",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "INNER-LINES^INTEGER^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "INNER-LINES^INTEGER^" + cValue.
    
    IF LOOKUP("TOOLTIP":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cValue           = ENTRY(LOOKUP("TOOLTIP",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "TOOLTIP^CHARACTER^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "TOOLTIP^CHARACTER^" + cValue.
                                                              
    IF LOOKUP("MAX-CHARS":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cValue           = ENTRY(LOOKUP("MAX-CHARS",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "MAX-CHARS^INTEGER^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "MAX-CHARS^INTEGER^" + cValue.
                                                              
    IF LOOKUP("SORT":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "SORT^LOGICAL^TRUE"
                                                             ELSE cExtraAttributes + CHR(4) + "SORT^LOGICAL^TRUE".
    
    IF LOOKUP("SIMPLE":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "SUBTYPE^CHARACTER^SIMPLE"
                                                             ELSE cExtraAttributes + CHR(4) + "SUBTYPE^CHARACTER^SIMPLE".
    
    IF LOOKUP("DROP-DOWN":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "SUBTYPE^CHARACTER^DROP-DOWN"
                                                             ELSE cExtraAttributes + CHR(4) + "SUBTYPE^CHARACTER^DROP-DOWN".
    
    IF LOOKUP("DROP-DOWN-LIST":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "SUBTYPE^CHARACTER^DROP-DOWN-LIST"
                                                             ELSE cExtraAttributes + CHR(4) + "SUBTYPE^CHARACTER^DROP-DOWN-LIST".
    
    IF LOOKUP("AUTO-COMPLETION":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "AUTO-COMPLETION^LOGICAL^TRUE"
                                                             ELSE cExtraAttributes + CHR(4) + "AUTO-COMPLETION^LOGICAL^TRUE".
    
    IF LOOKUP("UNIQUE-MATCH":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "UNIQUE-MATCH^LOGICAL^TRUE"
                                                             ELSE cExtraAttributes + CHR(4) + "UNIQUE-MATCH^LOGICAL^TRUE".
    
    /* Lastly, make sure we have a SUBTYPE and some LIST-ITEMS */
    IF INDEX(cExtraAttributes,"SUBTYPE^":U) = 0 THEN
        ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "SUBTYPE^CHARACTER^DROP-DOWN-LIST"
                                                             ELSE cExtraAttributes + CHR(4) + "SUBTYPE^CHARACTER^DROP-DOWN-LIST".

    IF INDEX(cExtraAttributes,"LIST-ITEMS^":U) = 0 AND 
       INDEX(cExtraAttributes,"LIST-ITEM-PAIRS^":U) = 0 THEN
        ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "LIST-ITEMS^CHARACTER^Item 1"
                                                             ELSE cExtraAttributes + CHR(4) + "LIST-ITEMS^CHARACTER^Item 1".
    
    RETURN cExtraAttributes.
END FUNCTION.   /* getComboBoxAttributes */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDupFieldCount) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDupFieldCount Procedure 
FUNCTION getDupFieldCount RETURNS INTEGER
    ( INPUT pcFieldList         AS CHARACTER,
      INPUT pcField             AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This function counts how many duplicate pcField's there are in the 
            pcFieldList and returns a number of occurances found
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iEntryCount         AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE iIndexNum           AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE iPrevIndex          AS INTEGER                      NO-UNDO.

    ASSIGN iEntryCount = 0
           iIndexNum   = 0
           iPrevIndex  = 1
           iIndexNum   = INDEX(pcFieldList,pcField).

    DO WHILE iIndexNum <> 0:
        ASSIGN iIndexNum = INDEX(pcFieldList,pcField,iPrevIndex)
               iPrevIndex = iIndexNum + 1.
        IF iIndexNum <> 0 THEN
            ASSIGN iEntryCount = iEntryCount + 1.
    END.    /* while indexnum <> 0 */

    RETURN iEntryCount.
END FUNCTION.   /* getDupFieldCount */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEditorAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEditorAttributes Procedure 
FUNCTION getEditorAttributes RETURNS CHARACTER
    ( INPUT pcViewAsList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This procedure will check what attributes are set in the view-as 
            phrase applicable for an EDITOR Widget
    Notes:  It will create a CHR(4) seperated list of attributes to be created
            with a comma seperated list of:
            Attribute Name
            Data Type
            Value            
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cExtraAttributes AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cValue           AS CHARACTER  NO-UNDO.
    
    IF LOOKUP("SIZE":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cValue           = ENTRY(LOOKUP("SIZE",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "WIDTH-CHARS^DECIMAL^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "WIDTH-CHARS^DECIMAL^" + cValue
               cValue           = ENTRY(LOOKUP("SIZE",pcViewAsList,"|":U) + 3,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "HEIGHT-CHARS^DECIMAL^" + cValue
                                                         ELSE cExtraAttributes + CHR(4) + "HEIGHT-CHARS^DECIMAL^" + cValue.
    IF LOOKUP("SIZE-CHARS":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cValue           = ENTRY(LOOKUP("SIZE-CHARS",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "WIDTH-CHARS^DECIMAL^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "WIDTH-CHARS^DECIMAL^" + cValue
               cValue           = ENTRY(LOOKUP("SIZE-CHARS",pcViewAsList,"|":U) + 3,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "HEIGHT-CHARS^DECIMAL^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "HEIGHT-CHARS^DECIMAL^" + cValue.    
    IF LOOKUP("SIZE-PIXELS":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cValue           = ENTRY(LOOKUP("SIZE-PIXELS",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "WIDTH-PIXELS^INTEGER^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "WIDTH-PIXELS^INTEGER^" + cValue
               cValue           = ENTRY(LOOKUP("SIZE-PIXELS",pcViewAsList,"|":U) + 3,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "HEIGHT-PIXELS^INTEGER^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "HEIGHT-PIXELS^INTEGER^" + cValue.                                                              
    IF LOOKUP("INNER-CHARS":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cValue           = ENTRY(LOOKUP("INNER-CHARS",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "INNER-CHARS^INTEGER^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "INNER-CHARS^INTEGER^" + cValue.
    
    IF LOOKUP("INNER-LINES":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cValue           = ENTRY(LOOKUP("INNER-LINES",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "INNER-LINES^INTEGER^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "INNER-LINES^INTEGER^" + cValue.
    
    IF LOOKUP("BUFFER-CHARS":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cValue           = ENTRY(LOOKUP("BUFFER-CHARS",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "BUFFER-CHARS^INTEGER^" + cValue
                                                         ELSE cExtraAttributes + CHR(4) + "BUFFER-CHARS^INTEGER^" + cValue.
    
    IF LOOKUP("BUFFER-LINES":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cValue           = ENTRY(LOOKUP("BUFFER-LINES",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "BUFFER-LINES^INTEGER^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "BUFFER-LINES^INTEGER^" + cValue.
                                                              
    IF LOOKUP("MAX-CHARS":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cValue           = ENTRY(LOOKUP("MAX-CHARS",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "MAX-CHARS^INTEGER^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "MAX-CHARS^INTEGER^" + cValue.
                                                              
    IF LOOKUP("LARGE":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "LARGE^LOGICAL^TRUE"
                                                             ELSE cExtraAttributes + CHR(4) + "LARGE^LOGICAL^TRUE".
    
    IF LOOKUP("NO-BOX":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "BOX^LOGICAL^FALSE"
                                                             ELSE cExtraAttributes + CHR(4) + "BOX^LOGICAL^FALSE".
    
    IF LOOKUP("NO-WORD-WRAP":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "WORD-WRAP^LOGICAL^FALSE"
                                                             ELSE cExtraAttributes + CHR(4) + "WORD-WRAP^LOGICAL^FALSE".
    
    IF LOOKUP("SCROLLBAR-HORIZONTAL":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "SCROLLBAR-HORIZONTAL^LOGICAL^TRUE"
                                                      ELSE cExtraAttributes + CHR(4) + "SCROLLBAR-HORIZONTAL^LOGICAL^TRUE".
    
    IF LOOKUP("SCROLLBAR-VERTICAL":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "SCROLLBAR-VERTICAL^LOGICAL^TRUE"
                                                      ELSE cExtraAttributes + CHR(4) + "SCROLLBAR-VERTICAL^LOGICAL^TRUE".
    
    RETURN cExtraAttributes.
END FUNCTION.   /* getEditorAttributes */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldNames Procedure 
FUNCTION getFieldNames RETURNS CHARACTER
    ( INPUT phTable                     AS HANDLE,
      INPUT pcFieldQualifiers           AS CHARACTER,
      INPUT pcFieldSeparator            AS CHARACTER,
      INPUT pcTableBase                 AS CHARACTER,     
      INPUT pcValidDataTypes            AS CHARACTER,
      INPUT plNonKeyFieldsAllowed       AS LOGICAL,
      INPUT plBuildFromIndexes          AS LOGICAL,
      INPUT pcAllIndexes                AS CHARACTER,
      INPUT pcUniqueSingleFieldIndexes  AS CHARACTER,
      INPUT pcAlternateDataTypes        AS CHARACTER,
      INPUT pcObjectFieldName           AS CHARACTER         ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the name of a field within a given table that conforms to 
            the criteria specified.
    Notes:  phTable                     - buffer handle to the table in which to search
            pcFieldQualifiers           - the qualifiers for the field name,
                                          eg description, name, code, etc.
            pcFieldSeparator            - separator for the 'words' in the field names.
            pcTableBase                 - the table name excluding the prefix. eg. Country
                                          from spc_Country
            pcValidDataTypes            - the valid data types for that the requested field
                                          may be.
            plNonKeyFieldsAllowed       - whether the field returned may be a non-indexed
                                          field or not.
            plBuildFromIndexes          - whether to construct a list of field names from
                                          the table's indexes. Usually NO.
            pcAllIndexes                - a string constrcuted of all the indexes for the
                                          table. See INDEX-INFORMATION() method for details.
            pcUniqueSingleFieldIndexes  - a string containing only those indexes that have
                                          1 field and that are unique.
            pcAlternateDataTypes        - when searching through indexes for field names,
                                          it may be necessary to search through other data types
                                          than those provided by the valid data types parameter.
                                          This is so that we can search as far as possible for
                                          relevant data.
            pcObjectFieldName           - The name of the object field. We need this so
                                          that we can avoid selecting the object field
                                          as a description or key field.
           * This function is primarily called from generateEntityObject() in this
             Manager. This API should be considered PRIVATE and the signature
             can thus change without notice.
           * The BuildFromIndexes is generally only used when finding an entity's 
             key fields.                                                    
           * Order of field name determination:
           (0) If BuildFromIndexes is specified, then look through the unique 
               single-field indexes for fields. These fields should not be the
               same as the object field (if one exists).
               (0.1) Check the primary unique indexes, using the primary data type
               (0.2) Check other unique indexes, using the primary data type
               (0.3) Check the primary unique indexes, using the alternate data type
               (0.4) Check other unique indexes, using the alternate data type               
           
           (1) Exact fit: TableBase(separator)Qualifier
           (2) Matches, using the leading separator: *(separator)Qualifier
           (3) Matches, but don't use a leading separator: *(separator)Qualifier
           (3.5) See if the table base is itself  a valid field.
           
           If the BuildFromIndexes flag is set to true:
           (4) Check whether there is a field (primary datatype) in a unique single 
               key field index that MATCHES the specified naming convention: *(separator)Qualifier
           (5) Check whether there is a field (alternate data type) in a 
               unique single key field index with the specified naming
               convention: TableBase(separator)Qualifier
           (6) Check whether there is a field (alternate datatype) in a unique single 
               key field index that MATCHES the specified naming convention: *(separator)Qualifier
           (7) Find the first primary unique index and assign the
               index's key fields - comma-sperated if more than one field.
           (8) Check any other unique index - if available assign the index's key fields - 
               comma-sperated if more than one field
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hField              AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE iLoop               AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE iQualLoop           AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE iFieldLoop          AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE cFieldName          AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cReturnFieldNames   AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cIndexInfo          AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cFieldDataType      AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cPrimaryFieldName   AS CHARACTER                    NO-UNDO.

    ASSIGN cReturnFieldNames = "":U.

    /* (0) If we are building from indexes, search the unique indexes first.
     * Check that we are not returning the name of the object field. */
    IF plBuildFromIndexes THEN
    DO:
        /* (0.1) Look in the primary key first. First check against the Primary Data type */
        INDEX-LOOP:
        DO iLoop = 1 TO NUM-ENTRIES(pcUniqueSingleFieldIndexes, CHR(3)):
            ASSIGN cIndexInfo = ENTRY(iLoop, pcUniqueSingleFieldIndexes, CHR(3)).

            /* Get the primary unique key field. */
            IF ENTRY(3, cIndexInfo)             EQ "1":U AND
               NOT CAN-DO(cIndexInfo, pcObjectFieldName) THEN
            DO:
                ASSIGN cPrimaryFieldName = ENTRY(5, cIndexInfo)
                       hField            = phTable:BUFFER-FIELD(cPrimaryFieldName)
                       cFieldDataType    = hField:DATA-TYPE.
                IF CAN-DO(pcValidDataTypes, cFieldDataType) THEN
                    ASSIGN cReturnFieldNames = cPrimaryFieldName.
            END.    /* got the field name */
        END.    /* INDEX-LOOP: 0.1 */

        /* (0.2) Then look at the other indexes. First check against the Primary Data type */
        IF cReturnFieldNames EQ "":U THEN
        INDEX-LOOP:
        DO iLoop = 1 TO NUM-ENTRIES(pcUniqueSingleFieldIndexes, CHR(3)):
            ASSIGN cIndexInfo = ENTRY(iLoop, pcUniqueSingleFieldIndexes, CHR(3)).

            IF NOT CAN-DO(cIndexInfo, pcObjectFieldName) THEN
            DO:
                ASSIGN cFieldName     = ENTRY(5, cIndexInfo)
                       hField         = phTable:BUFFER-FIELD(cFieldName)
                       cFieldDataType = hField:DATA-TYPE.
                IF CAN-DO(pcValidDataTypes, cFieldDataType) THEN
                    ASSIGN cReturnFieldNames = cFieldName.
            END.    /* got the field name */
        END.    /* INDEX-LOOP: 0.2 */

        /* (0.3) Is the primary key field of the alternate type? */
        IF cReturnFieldNames                    EQ "":U AND 
           CAN-DO(pcAlternateDataTypes, cFieldDataType) THEN
            ASSIGN cReturnFieldNames = cPrimaryFieldName.

        /* (0.4) Look at the other unique indexes again, checking against the alternate data type */
        IF cReturnFieldNames EQ "":U THEN
        INDEX-LOOP:
        DO iLoop = 1 TO NUM-ENTRIES(pcUniqueSingleFieldIndexes, CHR(3)):
            ASSIGN cIndexInfo = ENTRY(iLoop, pcUniqueSingleFieldIndexes, CHR(3)).

            IF NOT CAN-DO(cIndexInfo, pcObjectFieldName) THEN
            DO:
                ASSIGN cFieldName     = ENTRY(5, cIndexInfo)
                       hField         = phTable:BUFFER-FIELD(cFieldName)
                       cFieldDataType = hField:DATA-TYPE.
                IF CAN-DO(pcAlternateDataTypes, cFieldDataType) THEN
                    ASSIGN cReturnFieldNames = cFieldName.
            END.    /* got the field name */
        END.    /* INDEX-LOOP: 0.4 */
    END.    /* object field name */

    /* (1) First loop for exact fit. */
    IF cReturnFieldNames EQ "":U THEN
    QUAL-LOOP:
    DO iQualLoop = 1 TO NUM-ENTRIES(pcFieldQualifiers):
        ASSIGN cFieldName = ENTRY(iQualLoop, pcFieldQualifiers).

        IF CAN-DO("Upper,":U, pcFieldSeparator) THEN
            ASSIGN cFieldName = REPLACE(cFieldName, "[SEPARATOR]":U, "":U).
        ELSE
            ASSIGN cFieldName = REPLACE(cFieldName, "[SEPARATOR]":U, pcFieldSeparator).

        ASSIGN cFieldName = pcTableBase
                          + (IF CAN-DO("Upper,":U, pcFieldSeparator) THEN "":U ELSE pcFieldSeparator)
                          + cFieldName.

        ASSIGN hField = phTable:BUFFER-FIELD(cFieldName) NO-ERROR.
        IF VALID-HANDLE(hField)                                AND 
           (hField:KEY OR hField:KEY NE plNonKeyFieldsAllowed) AND 
           CAN-DO(pcValidDataTypes, hField:DATA-TYPE)          THEN
        DO:
            ASSIGN cReturnFieldNames = hField:NAME.
            LEAVE QUAL-LOOP.
        END.
    END.    /* QUAL-LOOP: exact fit */

    IF cReturnFieldNames EQ "":U THEN
    /* (2) Then loop for matches, using the leading separator  */
    QUAL-LOOP:
    DO iQualLoop = 1 TO NUM-ENTRIES(pcFieldQualifiers):
        ASSIGN cFieldName = ENTRY(iQualLoop, pcFieldQualifiers).

        IF CAN-DO("Upper,":U, pcFieldSeparator) THEN
            ASSIGN cFieldName = REPLACE(cFieldName, "[SEPARATOR]":U, "":U).
        ELSE
            ASSIGN cFieldName = REPLACE(cFieldName, "[SEPARATOR]":U, pcFieldSeparator).

        ASSIGN cFieldName = "*" + (IF CAN-DO("Upper,":U, pcFieldSeparator) THEN "":U ELSE pcFieldSeparator)
                          + cFieldName.

        FIELD-LOOP:
        DO iFieldLoop = 1 TO phTable:NUM-FIELDS:
            ASSIGN hField = phTable:BUFFER-FIELD(iFieldLoop).

            IF hField:NAME MATCHES cFieldName                      AND 
               (hField:KEY OR hField:KEY NE plNonKeyFieldsAllowed) AND 
               CAN-DO(pcValidDataTypes, hField:DATA-TYPE)          THEN
            DO:
                ASSIGN cReturnFieldNames = hField:NAME.
                LEAVE QUAL-LOOP.
            END.    /* found a matching value. */
        END.    /* FIELD-LOOP: */
    END.    /* QUAL-LOOP: matches */

    IF cReturnFieldNames EQ "":U THEN
    /* (3) Then loop for matches, but don't use a leading separator. */
    QUAL-LOOP:
    DO iQualLoop = 1 TO NUM-ENTRIES(pcFieldQualifiers):
        ASSIGN cFieldName = ENTRY(iQualLoop, pcFieldQualifiers).

        IF CAN-DO("Upper,":U, pcFieldSeparator) THEN
            ASSIGN cFieldName = REPLACE(cFieldName, "[SEPARATOR]":U, "":U).
        ELSE
            ASSIGN cFieldName = REPLACE(cFieldName, "[SEPARATOR]":U, pcFieldSeparator).

        ASSIGN cFieldName = "*" + cFieldName.

        FIELD-LOOP:
        DO iFieldLoop = 1 TO phTable:NUM-FIELDS:
            ASSIGN hField = phTable:BUFFER-FIELD(iFieldLoop).

            IF hField:NAME MATCHES cFieldName                      AND 
               (hField:KEY OR hField:KEY NE plNonKeyFieldsAllowed) AND 
               CAN-DO(pcValidDataTypes, hField:DATA-TYPE)          THEN
            DO:
                ASSIGN cReturnFieldNames = hField:NAME.
                LEAVE QUAL-LOOP.
            END.    /* found a matching value. */
        END.    /* FIELD-LOOP: */
    END.    /* QUAL-LOOP: matches */

    /* (3.5) See if the table base is itself  a valid field. */
    ASSIGN hField = phTable:BUFFER-FIELD(pcTableBase) NO-ERROR.

    IF VALID-HANDLE(hField) AND
       (hField:KEY OR hField:KEY NE plNonKeyFieldsAllowed) AND 
       CAN-DO(pcValidDataTypes, hField:DATA-TYPE)          THEN
        ASSIGN cReturnFieldNames = pcTableBase.

    /* Now lets look at the indexes. */
    IF cReturnFieldNames EQ "":U AND plBuildFromIndexes THEN
    DO:
        /* (4) Check whether there is a field (primary datatype) in a unique single 
         * key field index that MATCHES the specified naming convention.        */
        QUAL-LOOP:
        DO iQualLoop = 1 TO NUM-ENTRIES(pcFieldQualifiers):
            ASSIGN cFieldName = ENTRY(iQualLoop, pcFieldQualifiers).

            IF CAN-DO("Upper,":U, pcFieldSeparator) THEN
                ASSIGN cFieldName = REPLACE(cFieldName, "[SEPARATOR]":U, "":U).
            ELSE
                ASSIGN cFieldName = REPLACE(cFieldName, "[SEPARATOR]":U, pcFieldSeparator).

            ASSIGN cFieldName = "*" + (IF CAN-DO("Upper,":U, pcFieldSeparator) THEN "":U ELSE pcFieldSeparator)
                              + cFieldName.

            FIELD-LOOP:
            DO iFieldLoop = 1 TO phTable:NUM-FIELDS:
                ASSIGN hField = phTable:BUFFER-FIELD(iFieldLoop).

                IF hField:NAME MATCHES cFieldName AND hField:KEY   AND 
                   CAN-DO(pcValidDataTypes, hField:DATA-TYPE)      AND 
                   /* We only need to check that this field is in any unique index. */
                   CAN-DO(pcUniqueSingleFieldIndexes, hField:NAME) THEN
                DO:
                    ASSIGN cReturnFieldNames = hField:NAME.
                    LEAVE QUAL-LOOP.
                END.    /* found field in index. */
            END.    /* FIELD-LOOP: */
        END.    /* QUAL-LOOP: matches name */

        /* (5) Check whether there is a field (alternate data type) in a 
         * unique single key field index with the specified naming
         * convention.                                              */
        IF cReturnFieldNames EQ "":U THEN
        QUAL-LOOP:
        DO iQualLoop = 1 TO NUM-ENTRIES(pcFieldQualifiers):
            ASSIGN cFieldName = ENTRY(iQualLoop, pcFieldQualifiers).

            IF CAN-DO("Upper,":U, pcFieldSeparator) THEN
                ASSIGN cFieldName = REPLACE(cFieldName, "[SEPARATOR]":U, "":U).
            ELSE
                ASSIGN cFieldName = REPLACE(cFieldName, "[SEPARATOR]":U, pcFieldSeparator).

            ASSIGN cFieldName = pcTableBase
                              + (IF CAN-DO("Upper,":U, pcFieldSeparator) THEN "":U ELSE pcFieldSeparator)
                              + cFieldName.
            
            ASSIGN hField = phTable:BUFFER-FIELD(cFieldName) NO-ERROR.

            IF VALID-HANDLE(hField) AND hField:KEY AND 
               CAN-DO(pcAlternateDataTypes, hField:DATA-TYPE)  AND 
               /* We only need to check that this field is in any unique index. */
               CAN-DO(pcUniqueSingleFieldIndexes, hField:NAME) THEN
            DO:
                ASSIGN cReturnFieldNames = hField:NAME.
                LEAVE QUAL-LOOP.
            END.    /* found field in index. */
        END.    /* QUAL-LOOP: matches name */

        /* (6) Check whether there is a field (alternate datatype) in a unique single 
         * key field index that MATCHES the specified naming convention.        */
        IF cReturnFieldNames EQ "":U THEN
        QUAL-LOOP:
        DO iQualLoop = 1 TO NUM-ENTRIES(pcFieldQualifiers):
            ASSIGN cFieldName = ENTRY(iQualLoop, pcFieldQualifiers).

            IF CAN-DO("Upper,":U, pcFieldSeparator) THEN
                ASSIGN cFieldName = REPLACE(cFieldName, "[SEPARATOR]":U, "":U).
            ELSE
                ASSIGN cFieldName = REPLACE(cFieldName, "[SEPARATOR]":U, pcFieldSeparator).

            ASSIGN cFieldName = "*" + (IF CAN-DO("Upper,":U, pcFieldSeparator) THEN "":U ELSE pcFieldSeparator)
                              + cFieldName.

            FIELD-LOOP:
            DO iFieldLoop = 1 TO phTable:NUM-FIELDS:
                ASSIGN hField = phTable:BUFFER-FIELD(iFieldLoop).

                IF hField:NAME MATCHES cFieldName AND hField:KEY AND 
                   CAN-DO(pcAlternateDataTypes, hField:DATA-TYPE)  AND 
                   /* We only need to check that this field is in any unique index. */
                   CAN-DO(pcUniqueSingleFieldIndexes, hField:NAME) THEN
                DO:
                    ASSIGN cReturnFieldNames = hField:NAME.
                    LEAVE QUAL-LOOP.
                END.    /* found field in index. */
            END.    /* FIELD-LOOP: */
        END.    /* QUAL-LOOP: matches name */

        /* (7) Find the first primary unique index and assign the        
         * index's key fields - comma-sperated if more than one field. */
        IF cReturnFieldNames EQ "":U THEN
        INDEX-LOOP:
        DO iLoop = 1 TO NUM-ENTRIES(pcAllIndexes, CHR(3)):
            ASSIGN cIndexInfo = ENTRY(iLoop, pcAllIndexes, CHR(3)).

            /* Only use fields from the first primary unique index */
            IF ENTRY(2, cIndexInfo) EQ "1":U AND ENTRY(3, cIndexInfo) EQ "1":U THEN
            DO iFieldLoop = 5 TO NUM-ENTRIES(cIndexInfo) BY 2:
                ASSIGN cReturnFieldNames = cReturnFieldNames + ENTRY(iFieldLoop, cIndexInfo) + ",":U.
            END. /* iFieldLoop */

            IF cReturnFieldNames NE "":U THEN
            DO:
                ASSIGN cReturnFieldNames = RIGHT-TRIM(cReturnFieldNames, ",":U).
                LEAVE INDEX-LOOP.
            END.    /* found an  index */
        END.    /* INDEX-LOOP: */
        
        /* (8) check any other unique index - if available assign the index's key fields - 
         * comma-sperated if more than one field */
        IF cReturnFieldNames EQ "":U THEN
        INDEX-LOOP:
        DO iLoop = 1 TO NUM-ENTRIES(pcAllIndexes, CHR(3)):
            ASSIGN cIndexInfo = ENTRY(iLoop, pcAllIndexes, CHR(3)).

            /* Only use fields from the first primary unique index */
            IF ENTRY(2, cIndexInfo) EQ "1":U THEN
            DO iFieldLoop = 5 TO NUM-ENTRIES(cIndexInfo) BY 2:
                ASSIGN cReturnFieldNames = cReturnFieldNames + ENTRY(iFieldLoop, cIndexInfo) + ",":U.
            END. /* iFieldLoop */

            IF cReturnFieldNames NE "":U THEN
            DO:
                ASSIGN cReturnFieldNames = RIGHT-TRIM(cReturnFieldNames, ",":U).
                LEAVE INDEX-LOOP.
            END.    /* found an  index */
        END.    /* INDEX-LOOP: */
    END.    /* build from indexes */

    RETURN cReturnFieldNames.
END FUNCTION.   /* getFieldNames */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRadioSetAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRadioSetAttributes Procedure 
FUNCTION getRadioSetAttributes RETURNS CHARACTER
    ( INPUT pcViewAsList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This procedure will check what attributes are set in the view-as 
            phrase applicable for a RADIO-SET Widget
    Notes:  It will create a CHR(4) seperated list of attributes to be created
            with a comma seperated list of:
            Attribute Name
            Data Type
            Value
            
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cExtraAttributes       AS CHARACTER                 NO-UNDO.
    DEFINE VARIABLE cValue                 AS CHARACTER                 NO-UNDO.
    DEFINE VARIABLE cRadioButtons          AS CHARACTER                 NO-UNDO.
    DEFINE VARIABLE iLoop                  AS INTEGER                   NO-UNDO.
    DEFINE VARIABLE dTotalWidth            AS DECIMAL                   NO-UNDO.
    DEFINE VARIABLE iCnt                   AS INTEGER                   NO-UNDO.
    
    IF LOOKUP("SIZE":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cValue           = ENTRY(LOOKUP("SIZE",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "WIDTH-CHARS^DECIMAL^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "WIDTH-CHARS^DECIMAL^" + cValue
               cValue           = ENTRY(LOOKUP("SIZE",pcViewAsList,"|":U) + 3,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "HEIGHT-CHARS^DECIMAL^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "HEIGHT-CHARS^DECIMAL^" + cValue.
    
    IF LOOKUP("SIZE-CHARS":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cValue           = ENTRY(LOOKUP("SIZE-CHARS",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "WIDTH-CHARS^DECIMAL^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "WIDTH-CHARS^DECIMAL^" + cValue
               cValue           = ENTRY(LOOKUP("SIZE-CHARS",pcViewAsList,"|":U) + 3,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "HEIGHT-CHARS^DECIMAL^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "HEIGHT-CHARS^DECIMAL^" + cValue.
    
    IF LOOKUP("SIZE-PIXELS":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cValue           = ENTRY(LOOKUP("SIZE-PIXELS",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "WIDTH-PIXELS^INTEGER^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "WIDTH-PIXELS^INTEGER^" + cValue
               cValue           = ENTRY(LOOKUP("SIZE-PIXELS",pcViewAsList,"|":U) + 3,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "HEIGHT-PIXELS^INTEGER^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "HEIGHT-PIXELS^INTEGER^" + cValue.
    
    IF LOOKUP("RADIO-BUTTONS":U,pcViewAsList,"|":U) >= 1 THEN
    DO:
        ASSIGN cValue = ENTRY(LOOKUP("RADIO-BUTTONS",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U).
               cExtraAttributes = IF cExtraAttributes = "":U THEN "RADIO-BUTTONS^CHARACTER^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "RADIO-BUTTONS^CHARACTER^" + cValue.
        ASSIGN cRadioButtons = cValue
               iCnt          = NUM-ENTRIES(cValue).
    END.    /* radio buttons defined */
    
    IF LOOKUP("TOOLTIP":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cValue           = ENTRY(LOOKUP("TOOLTIP",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "TOOLTIP^CHARACTER^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "TOOLTIP^CHARACTER^" + cValue.
    
    IF LOOKUP("HORIZONTAL":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "HORIZONTAL^LOGICAL^TRUE"
                                                             ELSE cExtraAttributes + CHR(4) + "HORIZONTAL^LOGICAL^TRUE".
    
    IF LOOKUP("EXPAND":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "EXPAND^LOGICAL^FALSE"
                                                             ELSE cExtraAttributes + CHR(4) + "EXPAND^LOGICAL^FALSE".
    
    IF LOOKUP("VERTICAL":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "VERTICAL^LOGICAL^FALSE"
                                                             ELSE cExtraAttributes + CHR(4) + "VERTICAL^LOGICAL^FALSE".
    
    /* If the height of the radio-buttons has not been specified and
     * it isn't horizontal then we need to calculate suitable height */
    IF INDEX(cExtraAttributes,"HEIGHT":U) = 0 AND INDEX(cExtraAttributes,"HORIZONTAL":U) = 0 THEN
        ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "HEIGHT-CHARS^DECIMAL^" + STRING(iCnt / 2)
                                                             ELSE cExtraAttributes + CHR(4) + "HEIGHT-CHARS^DECIMAL^" + STRING(iCnt / 2).    

    IF INDEX(cExtraAttributes,"WIDTH":U) = 0 THEN
    DO: 
        /* If the RADIO-SET is vertical we need to have a total
           width of all the options combined */
        IF INDEX(cExtraAttributes,"HORIZONTAL":U) = 0 THEN
        DO:
            DO iLoop = 1 TO NUM-ENTRIES(cRadioButtons):
                ASSIGN dTotalWidth = dTotalWidth + LENGTH(ENTRY(iLoop,cRadioButtons))
                       iLoop = iLoop + 1.
            END.    /* loop through buttons */

            ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "WIDTH-CHARS^DECIMAL^" + STRING(dTotalWidth)
                                                                 ELSE cExtraAttributes + CHR(4) + "WIDTH-CHARS^DECIMAL^" + STRING(dTotalWidth).
        END.    /* this is a horizontal radio set */
        ELSE
        DO:
            DO iLoop = 1 TO NUM-ENTRIES(cRadioButtons):
                ASSIGN dTotalWidth = MAX(dTotalWidth,LENGTH(ENTRY(iLoop,cRadioButtons)))
                       iLoop = iLoop + 1.
            END.    /* loop through buttons */

            ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "WIDTH-CHARS^DECIMAL^" + STRING(dTotalWidth)
                                                                 ELSE cExtraAttributes + CHR(4) + "WIDTH-CHARS^DECIMAL^" + STRING(dTotalWidth).
        END.    /* not a horizontal radio set */
    END.    /* no width specified */

    RETURN cExtraAttributes.
END FUNCTION.   /* getRadioSetAttributes */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSelectionListAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSelectionListAttributes Procedure 
FUNCTION getSelectionListAttributes RETURNS CHARACTER
    ( INPUT pcViewAsList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This procedure will check what attributes are set in the view-as 
            phrase applicable for a SELECTION-LIST Widget
    Notes:  It will create a CHR(4) seperated list of attributes to be created
            with a comma seperated list of:
            Attribute Name
            Data Type
            Value            
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cExtraAttributes       AS CHARACTER                 NO-UNDO.
    DEFINE VARIABLE cValue                 AS CHARACTER                 NO-UNDO.

    IF LOOKUP("SIZE":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cValue           = ENTRY(LOOKUP("SIZE",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "WIDTH-CHARS^DECIMAL^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "WIDTH-CHARS^DECIMAL^" + cValue
               cValue           = ENTRY(LOOKUP("SIZE",pcViewAsList,"|":U) + 3,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "HEIGHT-CHARS^DECIMAL^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "HEIGHT-CHARS^DECIMAL^" + cValue.
    
    IF LOOKUP("SIZE-CHARS":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cValue           = ENTRY(LOOKUP("SIZE-CHARS",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "WIDTH-CHARS^DECIMAL^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "WIDTH-CHARS^DECIMAL^" + cValue
               cValue           = ENTRY(LOOKUP("SIZE-CHARS",pcViewAsList,"|":U) + 3,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "HEIGHT-CHARS^DECIMAL^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "HEIGHT-CHARS^DECIMAL^" + cValue.
    
    IF LOOKUP("SIZE-PIXELS":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cValue           = ENTRY(LOOKUP("SIZE-PIXELS",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "WIDTH-PIXELS^INTEGER^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "WIDTH-PIXELS^INTEGER^" + cValue
               cValue           = ENTRY(LOOKUP("SIZE-PIXELS",pcViewAsList,"|":U) + 3,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "HEIGHT-PIXELS^INTEGER^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "HEIGHT-PIXELS^INTEGER^" + cValue.
    
    IF LOOKUP("INNER-CHARS":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cValue           = ENTRY(LOOKUP("INNER-CHARS",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "INNER-CHARS^INTEGER^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "INNER-CHARS^INTEGER^" + cValue.
    
    IF LOOKUP("INNER-LINES":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cValue           = ENTRY(LOOKUP("INNER-LINES",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "INNER-LINES^INTEGER^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "INNER-LINES^INTEGER^" + cValue.
                                                              
    IF LOOKUP("LIST-ITEMS":U,pcViewAsList,"|":U) >= 1 THEN
    DO:
        ASSIGN cValue = ENTRY(LOOKUP("LIST-ITEMS",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U).

        IF NUM-ENTRIES(cValue) > 1 THEN
            ASSIGN cValue = REPLACE(cValue,",":U,CHR(3))
                   cExtraAttributes = IF cExtraAttributes = "":U THEN "DELIMITER^CHARACTER^" + CHR(3)
                                                                 ELSE cExtraAttributes + CHR(4) + "DELIMITER^CHARACTER^" + CHR(3).

        ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "LIST-ITEMS^CHARACTER^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "LIST-ITEMS^CHARACTER^" + cValue.
    END.    /* there are list items */

    IF LOOKUP("TOOLTIP":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cValue           = ENTRY(LOOKUP("TOOLTIP",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U)
               cExtraAttributes = IF cExtraAttributes = "":U THEN "TOOLTIP^CHARACTER^" + cValue
                                                             ELSE cExtraAttributes + CHR(4) + "TOOLTIP^CHARACTER^" + cValue.
                                                              
    IF LOOKUP("SORT":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "SORT^LOGICAL^TRUE"
                                                             ELSE cExtraAttributes + CHR(4) + "SORT^LOGICAL^TRUE".
                                                              
    IF LOOKUP("MULTIPLE":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "MULTIPLE^LOGICAL^TRUE"
                                                             ELSE cExtraAttributes + CHR(4) + "MULTIPLE^LOGICAL^TRUE".
    
    IF LOOKUP("SCROLLBAR-HORIZONTAL":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "SCROLLBAR-HORIZONTAL^LOGICAL^TRUE"
                                                             ELSE cExtraAttributes + CHR(4) + "SCROLLBAR-HORIZONTAL^LOGICAL^TRUE".

    IF LOOKUP("SCROLLBAR-VERTICAL":U,pcViewAsList,"|":U) >= 1 THEN
        ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "SCROLLBAR-VERTICAL^LOGICAL^TRUE"
                                                             ELSE cExtraAttributes + CHR(4) + "SCROLLBAR-VERTICAL^LOGICAL^TRUE".

    RETURN cExtraAttributes.
END FUNCTION.   /* getSelectionListAttributes */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

