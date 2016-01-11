&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
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
/*---------------------------------------------------------------------------------
  File: rydesmngrp.i

  Description:  Repository Design Manager Include

  Purpose:      Repository Design Manager Include. This include contains all of the logic
                which makes up the Repository Design Manager.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/22/2002  Author:     Peter Judge

  Update Notes: Created from Template ryteminclu.i
                Updated 06/19/2002    Modified removeObject to remove all
                customizations if default object is specified                  

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* object identifying preprocessor */
&glob   AstraInclude    YES

{ src/adm2/globals.i }

/** These pre-processors are use for defaults when no physical object name
 *  is specified. They object type codes list determine which 
 *  ----------------------------------------------------------------------- **/
&GLOBAL-DEFINE CLASS-PHYSICAL-CONTAINER DynObjc,DynWind,DynFold,DynMenc,DynTree
&GLOBAL-DEFINE CLASS-PHYSICAL-VIEWER    DynView
&GLOBAL-DEFINE CLASS-PHYSICAL-BROWSE    DynBrow
&GLOBAL-DEFINE CLASS-PHYSICAL-COMBO     DynCombo
&GLOBAL-DEFINE CLASS-PHYSICAL-LOOKUP    DynLookup
&GLOBAL-DEFINE CLASS-PHYSICAL-SDO       DynSDO
&GLOBAL-DEFINE CLASS-PHYSICAL-FRAME     DynFrame
&GLOBAL-DEFINE CLASS-PHYSICAL-SBO       DynSBO

/** This pre-processor contains the codes of classes that can be containers.
 *  ----------------------------------------------------------------------- **/
&GLOBAL-DEFINE CONTAINER-CLASSES {&CLASS-PHYSICAL-CONTAINER},{&CLASS-PHYSICAL-COMBO},{&CLASS-PHYSICAL-FRAME}

/** This pre-processor determines which object types have an extension associated 
 *  with their filenames. 
 *  ----------------------------------------------------------------------- **/
&GLOBAL-DEFINE CLASS-HAS-NO-EXTENSION DataField,DynButton,DynComboBox,DynEditor,DynFillin,DynImage,DynRadioSet,DynRectangle,DynText,DynToggle,Entity

/** This preprocessor stores the _View-as fields that must keep their
 *  visualisation types instead of using the default FILL-IN visualisation.
 *  ----------------------------------------------------------------------- **/
&GLOBAL-DEFINE USE-SCHEMA-VIEW-AS TOGGLE-BOX,EDITOR,COMBO-BOX,SELECTION-LIST,RADIO-SET

DEFINE VARIABLE gcCLASS-PHYSICAL-CONTAINER AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcCLASS-PHYSICAL-FRAME     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcCLASS-PHYSICAL-VIEWER    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcCLASS-PHYSICAL-BROWSE    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcCLASS-PHYSICAL-COMBO     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcCLASS-PHYSICAL-LOOKUP    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcCLASS-PHYSICAL-SDO       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcCONTAINER-CLASSES        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcCLASS-HAS-NO-EXTENSION   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcUSE-SCHEMA-VIEW-AS       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcCLASS-PHYSICAL-SBO       AS CHARACTER  NO-UNDO.

ASSIGN gcCLASS-PHYSICAL-CONTAINER = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "{&CLASS-PHYSICAL-CONTAINER}":U)
       gcCLASS-PHYSICAL-CONTAINER = REPLACE(gcCLASS-PHYSICAL-CONTAINER, CHR(3), ",")

       gcCLASS-PHYSICAL-VIEWER    = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "{&CLASS-PHYSICAL-VIEWER}":U)
       gcCLASS-PHYSICAL-VIEWER    = REPLACE(gcCLASS-PHYSICAL-VIEWER, CHR(3), ",")

       gcCLASS-PHYSICAL-BROWSE    = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "{&CLASS-PHYSICAL-BROWSE}":U)
       gcCLASS-PHYSICAL-BROWSE    = REPLACE(gcCLASS-PHYSICAL-BROWSE, CHR(3), ",")

       gcCLASS-PHYSICAL-COMBO     = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "{&CLASS-PHYSICAL-COMBO}":U)
       gcCLASS-PHYSICAL-COMBO     = REPLACE(gcCLASS-PHYSICAL-COMBO, CHR(3), ",")

       gcCLASS-PHYSICAL-LOOKUP    = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "{&CLASS-PHYSICAL-LOOKUP}":U)
       gcCLASS-PHYSICAL-LOOKUP    = REPLACE(gcCLASS-PHYSICAL-LOOKUP, CHR(3), ",")

       gcCLASS-PHYSICAL-SDO       = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "{&CLASS-PHYSICAL-SDO}":U)
       gcCLASS-PHYSICAL-SDO       = REPLACE(gcCLASS-PHYSICAL-SDO, CHR(3), ",")

       gcCONTAINER-CLASSES        = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "{&CONTAINER-CLASSES}":U)
       gcCONTAINER-CLASSES        = REPLACE(gcCONTAINER-CLASSES, CHR(3), ",")

       gcCLASS-HAS-NO-EXTENSION   = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "{&CLASS-HAS-NO-EXTENSION}":U)
       gcCLASS-HAS-NO-EXTENSION   = REPLACE(gcCLASS-HAS-NO-EXTENSION, CHR(3), ",")

       gcCLASS-PHYSICAL-FRAME     = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "{&CLASS-PHYSICAL-FRAME}":U)
       gcCLASS-PHYSICAL-FRAME     = REPLACE(gcCLASS-PHYSICAL-FRAME, CHR(3), ",")

       gcCLASS-PHYSICAL-SBO       = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "{&CLASS-PHYSICAL-SBO}":U)
       gcCLASS-PHYSICAL-SBO       = REPLACE(gcCLASS-PHYSICAL-SBO, CHR(3), ",")


       gcUSE-SCHEMA-VIEW-AS       = "{&USE-SCHEMA-VIEW-AS}".

/** These pre-processors define the names of the actual physical objects to
 *  use.
 *  ----------------------------------------------------------------------- **/
&GLOBAL-DEFINE CONTAINER-PHYSICAL-OBJECT rydyncontw.w
&GLOBAL-DEFINE VIEWER-PHYSICAL-OBJECT    rydynviewv.w
&GLOBAL-DEFINE BROWSE-PHYSICAL-OBJECT    rydynbrowb.w
&GLOBAL-DEFINE COMBO-PHYSICAL-OBJECT     dyncombo.w
&GLOBAL-DEFINE LOOKUP-PHYSICAL-OBJECT    dynlookup.w
&GLOBAL-DEFINE SDO-PHYSICAL-OBJECT       dynsdo.w
&GLOBAL-DEFINE FRAME-PHYSICAL-OBJECT     rydynframw
&GLOBAL-DEFINE SBO-PHYSICAL-OBJECT       dynsbo.w

/** Defines the NO-RESULT-CODE and DEFAULT-RESULT-CODE result codes.
 *  ----------------------------------------------------------------------- **/
{ ry/app/rydefrescd.i }

{launch.i    &Define-Only = YES}
{dynlaunch.i &Define-Only = YES}

{afcheckerr.i &Define-Only=YES }

/** Temp-table definition for TT used in storeAttributeValues
 *  ----------------------------------------------------------------------- **/
{ ry/inc/ryrepatset.i }

DEFINE TEMP-TABLE ttDeleteAttribute NO-UNDO
    LIKE ttStoreAttribute.

/** Temp-table definition for TT used to store Object Links
 *  ----------------------------------------------------------------------- **/
{ ry/inc/ryreplnset.i }

/** This variable is used to guarantee that widget pools have a unique name.
 *  ----------------------------------------------------------------------- **/
DEFINE VARIABLE giUniquenessGuarantor                   AS INTEGER                  NO-UNDO.

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

/** Default size pre-processors for Dynamic Viewers
 *  ----------------------------------------------------------------------- **/
&SCOPED-DEFINE MAX-FIELD-LENGTH 30
&SCOPED-DEFINE MAX-FIELD-WIDTH-CHARS 50

/* This include file contains pre-processors for the different data types for attributes */
{af/app/afdatatypi.i}

/* Definitions for dynamic call, only defined client side, as we're only using the dynamic call to reduce Appserver hits in this instance */

&IF DEFINED(server-side) = 0 &THEN
{
 src/adm2/calltables.i &PARAM-TABLE-TYPE = "1"
                       &PARAM-TABLE-NAME = "ttSeqType"
}
&ENDIF

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
        tKeepFIeld
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

/* Temp-tables use in conjunction with fetchObject. Used in at least getnerateSDOInstances. */
{ ry/app/ryobjretri.i }

/* Temp-table for following joins of tables in the Dyn SDO */
&IF DEFINED(server-side) <> 0 &THEN
DEFINE TEMP-TABLE ttRelate NO-UNDO
  FIELD cOwnerTable     AS CHARACTER
  FIELD cDataBaseName   AS CHARACTER
  FIELD cRelatedTable   AS CHARACTER
  FIELD cLinkFieldName  AS CHARACTER
  FIELD cIndexName      AS CHARACTER.
DEFINE BUFFER bttRelate FOR ttRelate.

&ENDIF

DEFINE VARIABLE gFuncLibHdl      AS HANDLE                            NO-UNDO.

FUNCTION db-tbl-name RETURNS CHARACTER
        (INPUT cTableName     AS CHARACTER) IN gFuncLibHdl.

/* This stream is used with the Analyser in ripViewASPhrase */
DEFINE STREAM stAnalyze.

DEFINE TEMP-TABLE ttClassExtInformation     NO-UNDO
    FIELD tClassName            AS CHARACTER
    FIELD tAttributeName        AS CHARACTER
    FIELD tNarrative            AS CHARACTER
    FIELD tLookupType           AS CHARACTER
    FIELD tLookupValue          AS CHARACTER
    FIELD tDesignOnly           AS LOGICAL
    FIELD tGroupName            AS CHARACTER
    FIELD tGroupNarrative       AS CHARACTER
    INDEX idxMain       AS PRIMARY UNIQUE
        tClassName
        tAttributeName
    .

/* Generic query handle to reduce the number of CREATE QUERY ... statements. */
DEFINE VARIABLE ghQuery1                    AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghQuery2                    AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghQuery3                    AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghQuery4                    AS HANDLE                   NO-UNDO.

{ry/inc/ryrepprmod.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildDataFieldAttribute Include 
FUNCTION buildDataFieldAttribute RETURNS LOGICAL
    ( INPUT phAttributeBuffer       AS HANDLE,
      INPUT plForceOverride         AS LOGICAL,
      INPUT pcPrimaryFieldName      AS CHARACTER,
      INPUT pcSecondaryFieldName    AS CHARACTER,
      INPUT pcNewCharacterValue     AS CHARACTER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cacheClassExtInfo Include 
FUNCTION cacheClassExtInfo RETURNS LOGICAL
    ( INPUT pcClassName     AS CHARACTER    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cleanStoreAttributeValues Include 
FUNCTION cleanStoreAttributeValues RETURNS LOGICAL
    ( INPUT pcObjectName                AS CHARACTER,
      INPUT pcClassName                 AS CHARACTER,
      INPUT pcCleanToLevel              AS CHARACTER,
      INPUT phStoreAttributeBuffer      AS HANDLE       )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBufferDbName Include 
FUNCTION getBufferDbName RETURNS CHARACTER
    ( INPUT pcTableName         AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCacheClassExtBuffer Include 
FUNCTION getCacheClassExtBuffer RETURNS HANDLE
    ( INPUT pcClassName         AS CHARACTER,
      INPUT pcAttributeName     AS CHARACTER        )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getComboBoxAttributes Include 
FUNCTION getComboBoxAttributes RETURNS CHARACTER
  ( INPUT pcViewAsList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentProductModule Include 
FUNCTION getCurrentProductModule RETURNS CHARACTER
  (/* parameter-definitions */)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDupFieldCount Include 
FUNCTION getDupFieldCount RETURNS INTEGER
  ( pcFieldList AS CHARACTER,
    pcField     AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEditorAttributes Include 
FUNCTION getEditorAttributes RETURNS CHARACTER
  ( INPUT pcViewAsList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldNames Include 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFuncLibHandle Include 
FUNCTION getFuncLibHandle RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getIndexFields Include 
FUNCTION getIndexFields RETURNS CHARACTER
    ( INPUT pcTable AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getIndexFieldsUnique Include 
FUNCTION getIndexFieldsUnique RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectTypeCodeFromDB Include 
FUNCTION getObjectTypeCodeFromDB RETURNS CHARACTER
  (pdObjectTypeObj AS DECIMAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRadioSetAttributes Include 
FUNCTION getRadioSetAttributes RETURNS CHARACTER
  ( INPUT pcViewAsList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSchemaQueryHandle Include 
FUNCTION getSchemaQueryHandle RETURNS HANDLE
    ( INPUT  pcDatabaseName         AS CHARACTER,
      INPUT  pcTableNames            AS CHARACTER,
      OUTPUT pcWidgetPoolName       AS CHARACTER    ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSelectionListAttributes Include 
FUNCTION getSelectionListAttributes RETURNS CHARACTER
  ( INPUT pcViewAsList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSmartObjectObj Include 
FUNCTION getSmartObjectObj RETURNS DECIMAL
    ( INPUT pcObjectName                AS CHARACTER,
      INPUT pdCustmisationResultObj     AS DECIMAL      )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWidgetSizeFromFormat Include 
FUNCTION getWidgetSizeFromFormat RETURNS DECIMAL
    ( INPUT  pcFormatMask       AS CHARACTER,
      INPUT  pcUnit             AS CHARACTER,
      OUTPUT pdHeight           AS DECIMAL      )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ObjectExists Include 
FUNCTION ObjectExists RETURNS LOGICAL
  (pcObjectName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD openRyObjectAB Include 
FUNCTION openRyObjectAB RETURNS LOGICAL
  ( INPUT pObjectName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD productModuleList Include 
FUNCTION productModuleList RETURNS CHARACTER
  (/* parameter-definitions */)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCurrentProductModule Include 
FUNCTION setCurrentProductModule RETURNS LOGICAL
  ( INPUT cProductModule AS CHARACTER)  FORWARD.

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
         HEIGHT             = 35.86
         WIDTH              = 57.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  ******************************* */
CREATE WIDGET-POOL NO-ERROR.

ON CLOSE OF THIS-PROCEDURE 
DO:
    DELETE WIDGET-POOL NO-ERROR.

    RUN plipShutdown.

    DELETE PROCEDURE THIS-PROCEDURE.
    RETURN.
END.

/* Listen for the clearing of the Repository cache. If the repository cache is cleared, then we need
 * to signal the design cache that it is also to be cleared.                                        */
SUBSCRIBE TO "repositoryCacheCleared" ANYWHERE RUN-PROCEDURE "clearDesignCache":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addMasterAttrs Include 
PROCEDURE addMasterAttrs :
/*------------------------------------------------------------------------------
  Purpose:     Adds the attributes that are defined for a specified master object
               to the temp-table handle as a field in the table.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdSmartObjectObj AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER phMOTable        AS HANDLE     NO-UNDO.

  &IF DEFINED(Server-Side) EQ 0 &THEN    
  { dynlaunch.i &PLIP              = "'RepositoryDesignManager'"
                &iProc             = "'addMasterAttrs'"
               &mode1  = INPUT  &parm1  = pdSmartObjectObj  &dataType1  = DECIMAL
               &mode2  = INPUT  &parm2  = phMOTable         &dataType2  = HANDLE
  }
  IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.   
  &ELSE   
  DEFINE BUFFER bryc_attribute_value FOR ryc_attribute_value.
  DEFINE BUFFER bryc_attribute       FOR ryc_attribute.
  DEFINE VARIABLE hBuffer            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFormat            AS CHARACTER  
    INITIAL "X(40)|99/99/9999|YES/NO|>>>,>>>,>>9|->>>,>>>,>>>,>>>,>>9.9<<<<<<<<|X(40)||||":U
    NO-UNDO.
  DEFINE VARIABLE cDataType          AS CHARACTER  
    INITIAL "CHARACTER,DATE,LOGICAL,INTEGER,DECIMAL,CHARACTER,RECID,RAW,ROWID,HANDLE":U
    NO-UNDO.
  DEFINE VARIABLE cField             AS CHARACTER  
    INITIAL "character_value,date_value,logical_value,integer_value,decimal_value,character_value,character_value,raw_value,character_value,character_value":U
    NO-UNDO.
  DEFINE VARIABLE iDataType AS INTEGER    NO-UNDO.

  hBuffer = BUFFER bryc_attribute_value:HANDLE.
  /* Loop through all the attribute values for this object type */
  FOR EACH bryc_attribute_value NO-LOCK
    WHERE bryc_attribute_value.smartobject_obj           = pdSmartObjectObj
      AND bryc_attribute_value.container_smartobject_obj = 0.0
      AND bryc_attribute_value.object_instance_obj       = 0.0
    BY bryc_attribute_value.attribute_label:

    FIND FIRST bryc_attribute NO-LOCK
      WHERE bryc_attribute.attribute_label = bryc_attribute_value.attribute_label
      NO-ERROR.

    IF NOT AVAILABLE(bryc_attribute) THEN 
      NEXT.


    /* Make sure that the data type is between 1 and 10 */
    iDataType = bryc_attribute.data_type.
    IF iDataType < 1 OR 
       iDataType > 10 THEN
      iDataType = 1.

    /* Add a field to the table with this information */
    phMOTable:ADD-NEW-FIELD(bryc_attribute.attribute_label,
                            ENTRY(iDataType,cDataType),
                            0,
                            ENTRY(iDataType,cFormat,"|":U),
                            STRING(hBuffer:BUFFER-FIELD(ENTRY(iDataType,cField)):BUFFER-VALUE)).

  END.
  &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addOTAttrs Include 
PROCEDURE addOTAttrs :
/*------------------------------------------------------------------------------
  Purpose:     Adds the attributes that are defined for a specified object type
               to the temp-table handle as a field in the table.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER poObjectTypeObj AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER phOTTable       AS HANDLE     NO-UNDO.

  &IF DEFINED(Server-Side) EQ 0 &THEN    
  { dynlaunch.i &PLIP              = "'RepositoryDesignManager'"
                &iProc             = "'addOTAttrs'"
               &mode1  = INPUT  &parm1  = poObjectTypeObj            &dataType1  = DECIMAL
               &mode2  = INPUT  &parm2  = phOTTable                  &dataType2  = HANDLE
  }
  IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.   
  &ELSE   
  DEFINE BUFFER bryc_attribute_value FOR ryc_attribute_value.
  DEFINE BUFFER bryc_attribute       FOR ryc_attribute.
  DEFINE VARIABLE hBuffer            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFormat            AS CHARACTER  
    INITIAL "X(40)|99/99/9999|YES/NO|>>>,>>>,>>9|->>>,>>>,>>>,>>>,>>9.9<<<<<<<<|X(40)||||":U
    NO-UNDO.
  DEFINE VARIABLE cDataType          AS CHARACTER  
    INITIAL "CHARACTER,DATE,LOGICAL,INTEGER,DECIMAL,CHARACTER,RECID,RAW,ROWID,HANDLE":U
    NO-UNDO.
  DEFINE VARIABLE cField             AS CHARACTER  
    INITIAL "character_value,date_value,logical_value,integer_value,decimal_value,character_value,character_value,raw_value,character_value,character_value":U
    NO-UNDO.
  DEFINE VARIABLE iDataType AS INTEGER    NO-UNDO.

  hBuffer = BUFFER bryc_attribute_value:HANDLE.
  /* Loop through all the attribute values for this object type */
  FOR EACH bryc_attribute_value NO-LOCK
    WHERE bryc_attribute_value.object_type_obj           = poObjectTypeObj
      AND bryc_attribute_value.smartobject_obj           = 0.0 
      AND bryc_attribute_value.container_smartobject_obj = 0.0
      AND bryc_attribute_value.object_instance_obj       = 0.0
    BY bryc_attribute_value.attribute_label:

    FIND FIRST bryc_attribute NO-LOCK
      WHERE bryc_attribute.attribute_label = bryc_attribute_value.attribute_label
      NO-ERROR.

    IF NOT AVAILABLE(bryc_attribute) THEN 
      NEXT.


    /* Make sure that the data type is between 1 and 10 */
    iDataType = bryc_attribute.data_type.
    IF iDataType < 1 OR 
       iDataType > 10 THEN
      iDataType = 1.

    /* Add a field to the table with this information */
    phOTTable:ADD-NEW-FIELD(bryc_attribute.attribute_label,
                            ENTRY(iDataType,cDataType),
                            0,
                            ENTRY(iDataType,cFormat,"|":U),
                            STRING(hBuffer:BUFFER-FIELD(ENTRY(iDataType,cField)):BUFFER-VALUE)).

  END.
  &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addParentOTAttrs Include 
PROCEDURE addParentOTAttrs :
/*------------------------------------------------------------------------------
  Purpose:     Finds a parent object type for an object and any parents of that 
               parent and adds its attributes to the object type temp-table.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER poObjectTypeObj AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER phOTTable       AS HANDLE     NO-UNDO.

  &IF DEFINED(Server-Side) EQ 0 &THEN    
  { dynlaunch.i &PLIP              = "'RepositoryDesignManager'"
                &iProc             = "'addParentOTAttrs'"
               &mode1  = INPUT  &parm1  = poObjectTypeObj            &dataType1  = DECIMAL
               &mode2  = INPUT  &parm2  = phOTTable                  &dataType2  = HANDLE
  }
  IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.   
  &ELSE   
  DEFINE BUFFER bgsc_object_type FOR gsc_object_type.

  /* Find the object type that we are looking for. */
  FIND FIRST bgsc_object_type NO-LOCK
    WHERE bgsc_object_type.object_type_obj = poObjectTypeObj
    NO-ERROR.

  /* If it's not available, return */
  IF NOT AVAILABLE(bgsc_object_type) THEN
    RETURN.

  /* Add the attributes from this object type */
  RUN addOTAttrs(bgsc_object_type.object_type_obj, phOTTable).

  /* If this object type is descended from a parent one, add the parent one. */
  IF bgsc_object_type.extends_object_type_obj <> 0.0 THEN
    RUN addParentOTAttrs(bgsc_object_type.extends_object_type_obj, phOTTable).
  &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bufferRetrieveClassExtInfo Include 
PROCEDURE bufferRetrieveClassExtInfo :
/*------------------------------------------------------------------------------
  Purpose:     Creates entries in the ttClassExtInformation TT for the specified
               class.
  Parameters:  pcClassName - the name of a class to retrieve extended information
                             for. This API only creates values for one 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcClassName          AS CHARACTER            NO-UNDO.

    &IF DEFINED(Server-Side) GT 0 &THEN
    DEFINE VARIABLE hClassBuffer            AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hClassAttributeBuffer   AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE iFieldLoop              AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE cAttributeName          AS CHARACTER                NO-UNDO.
     
    /* We are pretty much guaranteed that by this stage the class attributes exist in the 
     * ttClass temp-table, since we make a call to getCacheClassBuffer() in getCacheClassExtInfo(). */
    ASSIGN hClassBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN gshRepositoryManager, INPUT pcClassName).
    IF NOT hClassBuffer:AVAILABLE THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' '"class cache record"' pcClassName}.

    ASSIGN hClassAttributeBuffer = hClassBuffer:BUFFER-FIELD("classBufferHandle":U):BUFFER-VALUE.
    
    DO iFieldLoop = 1 TO hClassAttributeBuffer:NUM-FIELDS:
        ASSIGN cAttributeName = hClassAttributeBuffer:BUFFER-FIELD(iFieldLoop):NAME.

        FIND FIRST ttClassExtInformation WHERE
                   ttClassExtInformation.tClassName     = pcClassName    AND
                   ttClassExtInformation.tAttributeName = cAttributeName
                   NO-ERROR.
        IF NOT AVAILABLE ttClassExtInformation THEN
        DO:
            FIND FIRST ryc_attribute WHERE
                       ryc_attribute.attribute_label = cAttributeName
                       NO-LOCK NO-ERROR.
            IF AVAILABLE ryc_attribute THEN
            DO:
                CREATE ttClassExtInformation.
                ASSIGN ttClassExtInformation.tClassName     = pcClassName
                       ttClassExtInformation.tAttributeName = ryc_attribute.attribute_label
                       ttClassExtInformation.tNarrative     = ryc_attribute.attribute_narrative
                       ttClassExtInformation.tLookupType    = ryc_attribute.lookup_type
                       ttClassExtInformation.tLookupValue   = ryc_attribute.lookup_value
                       ttClassExtInformation.tDesignOnly    = ryc_attribute.design_only
                       .
                FIND FIRST ryc_attribute_group WHERE
                           ryc_attribute_group.attribute_group_obj = ryc_attribute.attribute_group_obj
                           NO-LOCK NO-ERROR.
                IF AVAILABLE ryc_attribute_group THEN
                    ASSIGN ttClassExtInformation.tGroupName      = ryc_attribute_group.attribute_group_name
                           ttClassExtInformation.tGroupNarrative = ryc_attribute_group.attribute_group_narrative
                           .
            END.    /* available attribute. */
        END.    /* n/a ttClassExtInformation */
    END.    /* loop through fields. */
    &ENDIF   
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* bufferRetrieveClassExtInfo */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildSchemaFieldTable Include 
PROCEDURE buildSchemaFieldTable :
/*------------------------------------------------------------------------------
  Purpose:     Builds a temp-table of all fields for the specified DB and tables
  Parameters:  pcDatabaseNames    - A CSV list of logical DB names
               pcTableNames       - A CSV list of tables
               phTableFieldBuffer - } 
               phTableFieldTable  - } 
  Notes:       * The TT produced here is used by the generateDynamicViewer API
                 but use is not limited to that API.
               * The data returned here is taken from the DataFields contained
                 by the Entity object that matches the Entity MNemonic.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcDatabaseNames         AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcTableNames            AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER phTableFieldBuffer      AS HANDLE           NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phTableFieldTable.

    &IF DEFINED(Server-Side) EQ 0 &THEN
    {dynlaunch.i
        &Plip  = 'RepositoryDesignManager'
        &IProc = 'buildSchemaFieldTable'
        
        &mode1  = INPUT  &parm1  = pcDatabaseNames    &datatype1 = CHARACTER
        &mode2  = INPUT  &parm2  = pcTableNames       &datatype2 = CHARACTER
        &mode3  = OUTPUT &parm3  = phTableFieldBuffer &datatype3 = HANDLE
        &mode4  = OUTPUT &parm4  = phTableFieldTable  &datatype4 = TABLE-HANDLE
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    /* Turn the table handle into a buffer handle. */
    IF NOT VALID-HANDLE(phTableFieldBuffer) THEN
        ASSIGN phTableFieldBuffer = phTableFieldTable:DEFAULT-BUFFER-HANDLE
               phTableFieldTable  = ?.
    &ELSE
    DEFINE VARIABLE hObjectBuffer               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hLocalObjectBuffer          AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer            AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hFieldNameFrom              AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hFieldNameTo                AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cFieldNameFrom              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFieldNameTo                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFieldMapping               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cKeyField                   AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cEntityObjectField          AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iTableLoop                  AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iFieldLoop                  AS INTEGER              NO-UNDO.
    DEFINE VARIABLE dEntityInstanceId           AS DECIMAL              NO-UNDO.

    ASSIGN phTableFieldBuffer = BUFFER ttTableField:HANDLE.    
    phTableFieldBuffer:EMPTY-TEMP-TABLE().

    /* First value in = pair is the name in the TT being returned. The 2nd value is the 
     * name of the attribute.   */
    ASSIGN cFieldMapping = "_format=Format,_Data-type=Data-type,_Label=Label,_Help=Help,_Initial=DefaultValue,_View-as=ViewAs,":U
                         + "_Field-Name=NAME,_Field-Name=ObjectName,_Col-label=ColumnLabel,tTableDumpName=EntityMnemonic,":U
                         + "tDatabaseName=EntityDbname":U.

    DO iTableLoop = 1 TO NUM-ENTRIES(pcTableNames):
        /* Get the object from the Repository */
        DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                         INPUT ENTRY(iTableLoop, pcTableNames), INPUT "{&DEFAULT-RESULT-CODE}":U, INPUT "":U, INPUT NO).
        ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?).

        IF hObjectBuffer:AVAILABLE THEN
        DO:
            ASSIGN dEntityInstanceId = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
                   hAttributeBuffer  = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE.

            hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(dEntityInstanceId) ) NO-ERROR.
            ASSIGN cKeyField          = hAttributeBuffer:BUFFER-FIELD("EntityKeyField":U):BUFFER-VALUE
                   cEntityObjectField = hAttributeBuffer:BUFFER-FIELD("EntityObjectField":U):BUFFER-VALUE
                   NO-ERROR.

            CREATE BUFFER hLocalObjectBuffer FOR TABLE hObjectBuffer BUFFER-NAME "lbObject":U.
            IF NOT VALID-HANDLE(ghQuery3) THEN
                CREATE QUERY ghQuery3.

            ghQuery3:SET-BUFFERS(hLocalObjectBuffer).
            ghQuery3:QUERY-PREPARE(" FOR EACH ":U + hLocalObjectBuffer:NAME + " WHERE ":U
                                 + hLocalObjectBuffer:NAME + ".tContainerRecordIdentifier = ":U + QUOTER(dEntityInstanceId)).
            ghQuery3:QUERY-OPEN().

            ghQuery3:GET-FIRST().
            DO WHILE hLocalObjectBuffer:AVAILABLE:
                ASSIGN hAttributeBuffer  = hLocalObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE.

                hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U
                                            + QUOTER(hLocalObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE) ).

                phTableFieldBuffer:BUFFER-CREATE().

                ASSIGN phTableFieldBuffer:BUFFER-FIELD("tTableName":U):BUFFER-VALUE     = ENTRY(iTableLoop, pcTableNames)
                       phTableFieldBuffer:BUFFER-FIELD("_Order":U):BUFFER-VALUE         = hLocalObjectBuffer:BUFFER-FIELD("tInstanceOrder":U):BUFFER-VALUE
                       
                       phTableFieldBuffer:BUFFER-FIELD("tKeyField":U):BUFFER-VALUE          = CAN-DO(cKeyField, hLocalObjectBuffer:BUFFER-FIELD("tObjectInstanceName":U):BUFFER-VALUE)
                       phTableFieldBuffer:BUFFER-FIELD("tEntityObjectField":U):BUFFER-VALUE = (hLocalObjectBuffer:BUFFER-FIELD("tObjectInstanceName":U):BUFFER-VALUE EQ cEntityObjectField)
                       .
                DO iFieldLoop = 1 TO NUM-ENTRIES(cFieldMapping):
                    ASSIGN cFieldNameFrom = ENTRY(2, ENTRY(iFieldLoop, cFieldMapping), "=":U)
                           cFieldNameTo   = ENTRY(1, ENTRY(iFieldLoop, cFieldMapping), "=":U).

                    ASSIGN hFieldNameFrom = hAttributeBuffer:BUFFER-FIELD(cFieldNameFrom)
                           hFieldNameTo   = phTableFieldBuffer:BUFFER-FIELD(cFieldNameTo)
                           NO-ERROR.
                    IF VALID-HANDLE(hFieldNameFrom) AND VALID-HANDLE(hFieldNameTo) THEN
                        ASSIGN hFieldNameTo:BUFFER-VALUE = hFieldNameFrom:BUFFER-VALUE NO-ERROR.
                END.    /* loop through attributes. */

                phTableFieldBuffer:BUFFER-RELEASE().

                ghQuery3:GET-NEXT().
            END.    /* object buffer available */
            ghQuery3:QUERY-CLOSE().

            DELETE OBJECT hLocalObjectBuffer NO-ERROR.
            ASSIGN hLocalObjectBuffer = ?.
        END.    /* available entity */
    END.    /* loop through tables */

    /* Determine whether to return the buffer or handle. */
    IF SESSION:CLIENT-TYPE = "APPSERVER":U AND
       (PROGRAM-NAME(2) EQ "":U OR PROGRAM-NAME(2) EQ ? OR PROGRAM-NAME(2) EQ "invokeCall adm2/caller.p")  THEN
        ASSIGN phTableFieldTable  = phTableFieldBuffer:TABLE-HANDLE
               phTableFieldBuffer = ?.
    ELSE
        ASSIGN phTableFieldTable  = ?.
    &ENDIF
          
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* buildSchemaFieldTable */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeObjectInstance Include 
PROCEDURE changeObjectInstance :
/*------------------------------------------------------------------------------
  Purpose:     Changes the object instance .
  Parameters:  pcNameContainer            : The container name
                                            -  <name> = A valid container name
                                            -  'ALL'  = All containers
               pcResultCode               : Customization Result Code
                                            - <name> = A valid result-code 
                                            - ''     = Master container
                                            -  ?     = All Result codes
               pcNameObjectSource            : The name of the source object to be replaced with the target object
                                            -  <name> = A valid object name
               pcNameObjectTarget            : The name of the target object to replaced the source object
                                            -  <name> = A valid object name
               plDeleteObjectSource          : Delete the source object if all instances has been changed and it has no other instance allocations
               plRemoveDefaultAttributes  : Remove default attributes set for this object instances
               plRemoveUnusedAttributes   : Remove unused attributes set for this object instances

  Notes:       * If ...
                 - the source object is a valid object, and
                 - the target object is a valid object, and
                 - both objects exist within the same class hierarchy
                 > the instance and it's attribute values will be updated accordingly.
               * For ...
                 - All containers unless a specific container name is given, only for the relevant container
               * If the object exists on a container multiple times.
                 - All instances will be changed unless a specific object instance name is given
               * All the attribute values which are contained in the attribute value table which
               are set against the INSTANCE owner will be set against this object.
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcNameContainer           AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcResultCode              AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcNameObjectInstance      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcNameObjectSource        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcNameObjectTarget        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plDeleteObjectSource      AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plRemoveDefaultAttributes AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plRemoveUnusedAttributes  AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER piReplacementCount        AS INTEGER    NO-UNDO.

  &IF DEFINED(Server-Side) EQ 0
  &THEN

    { dynlaunch.i &PLIP   = "'RepositoryDesignManager'"
                  &iProc  = "'changeObjectInstance'"
                  &mode1  = INPUT  &parm1  = pcNameContainer            &dataType1  = CHARACTER
                  &mode2  = INPUT  &parm2  = pcResultCode               &dataType2  = CHARACTER
                  &mode3  = INPUT  &parm3  = pcNameObjectInstance       &dataType3  = CHARACTER
                  &mode4  = INPUT  &parm4  = pcNameObjectSource         &dataType4  = CHARACTER
                  &mode5  = INPUT  &parm5  = pcNameObjectTarget         &dataType5  = CHARACTER
                  &mode6  = INPUT  &parm6  = plDeleteObjectSource       &dataType6  = LOGICAL
                  &mode7  = INPUT  &parm7  = plRemoveDefaultAttributes  &dataType7  = LOGICAL
                  &mode8  = INPUT  &parm8  = plRemoveUnusedAttributes   &dataType8  = LOGICAL
                  &mode9  = OUTPUT &parm9  = piReplacementCount         &dataType9  = INTEGER
    }
    IF RETURN-VALUE <> "":U
    THEN
      RETURN ERROR RETURN-VALUE.

  &ELSE

    DEFINE VARIABLE dCustomisationResultObj         AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dSmartObjectObj                 AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dTargetSmartObjectObj           AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dSourceSmartObjectObj           AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dObjectInstanceObj              AS DECIMAL    NO-UNDO.

    DEFINE VARIABLE cClassTypeList                  AS CHARACTER  NO-UNDO EXTENT 10.
    /*
    1 - Browser
    2 - Viewer
    3 - Data
    4 - SBO
    5 - Panel
    6 - SmartFrame
    7 - DynFrame
    8 - Field
    */
    DEFINE VARIABLE iClassTypeLoop                  AS INTEGER    NO-UNDO.

    DEFINE VARIABLE iSourceObjectTypeList           AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iTargetObjectTypeList           AS INTEGER    NO-UNDO.

    DEFINE VARIABLE httClassBuffer                  AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer                AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hAttributeField                 AS HANDLE     NO-UNDO.

    DEFINE BUFFER b_source_ryc_smartobject          FOR ryc_smartobject.
    DEFINE BUFFER b_target_ryc_smartobject          FOR ryc_smartobject.
    DEFINE BUFFER b_ryc_smartobject                 FOR ryc_smartobject.

    DEFINE BUFFER b_source_gsc_object_type          FOR gsc_object_type.
    DEFINE BUFFER b_target_gsc_object_type          FOR gsc_object_type.

    DEFINE BUFFER b_ryc_object_instance             FOR ryc_object_instance.

    DEFINE BUFFER b_source_ryc_attribute_value      FOR ryc_attribute_value.
    DEFINE BUFFER b_target_ryc_attribute_value      FOR ryc_attribute_value.

    DEFINE BUFFER b_ryc_ui_event                    FOR ryc_ui_event.

    ASSIGN
      piReplacementCount = 0.

    /* Find the result code */
    IF pcResultCode EQ "":U
    THEN
      ASSIGN
        pcResultCode = "{&DEFAULT-RESULT-CODE}":U.

    IF pcResultCode NE "{&DEFAULT-RESULT-CODE}":U
    THEN DO:
      FIND FIRST ryc_customization_result NO-LOCK
        WHERE ryc_customization_result.customization_result_code = pcResultCode
        NO-ERROR.
      IF AVAILABLE ryc_customization_result
      THEN
        ASSIGN
          dCustomisationResultObj = ryc_customization_result.customization_result_obj.
      ELSE
        RETURN ERROR {aferrortxt.i 'AF' '05' '?' '?' "'Customization Result'" pcResultCode}.
    END.    /* find the result code */
    ELSE DO:
      ASSIGN
        dCustomisationResultObj = 0.
    END.

    /* 01 --- Try and find the source object that we are going to change from */
    ASSIGN
      dSourceSmartObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U, INPUT pcNameObjectSource, INPUT dCustomisationResultObj).
    IF dSourceSmartObjectObj = 0
    THEN DO:
      RETURN ERROR {aferrortxt.i 'AF' '05' '?' '?' "'source contained Object '" pcNameObjectSource}.
    END.
    ELSE DO:
      FIND FIRST b_source_ryc_smartobject NO-LOCK
        WHERE b_source_ryc_smartobject.smartobject_obj = dSourceSmartObjectObj
        NO-ERROR.
      /* Now find the source object type that we need to work with */
      FIND FIRST b_source_gsc_object_type NO-LOCK
        WHERE b_source_gsc_object_type.object_type_obj = b_source_ryc_smartobject.object_type_obj
        NO-ERROR.
      IF NOT AVAILABLE(b_source_gsc_object_type)
      THEN
        RETURN {aferrortxt.i 'RY' '04' '?' '?' STRING(b_source_ryc_smartobject.object_type_obj)}.
    END.

    /* 02 --- Try and find the target object that we are going to change to */
    ASSIGN
      dTargetSmartObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U, INPUT pcNameObjectTarget, INPUT dCustomisationResultObj).
    IF dTargetSmartObjectObj = 0
    THEN DO:
      RETURN ERROR {aferrortxt.i 'AF' '05' '?' '?' "'target Object to be contained'" pcNameObjectTarget}.
    END.
    ELSE DO:
      FIND FIRST b_target_ryc_smartobject NO-LOCK
        WHERE b_target_ryc_smartobject.smartobject_obj = dTargetSmartObjectObj
        NO-ERROR.
      /* Now find the target object type that we need to work with */
      FIND FIRST b_target_gsc_object_type NO-LOCK
        WHERE b_target_gsc_object_type.object_type_obj = b_target_ryc_smartobject.object_type_obj
        NO-ERROR.
      IF NOT AVAILABLE(b_target_gsc_object_type)
      THEN
        RETURN {aferrortxt.i 'RY' '04' '?' '?' STRING(b_target_ryc_smartobject.object_type_obj)}.
    END.

    /* 03 --- Try and find the container object if specified */
    IF  pcNameContainer <> "":U
    AND pcNameContainer <> "ALL":U
    THEN DO:
      ASSIGN
        dSmartObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U, INPUT pcNameContainer, INPUT dCustomisationResultObj).
      IF dSmartObjectObj = 0
      THEN
        RETURN ERROR {aferrortxt.i 'AF' '05' '?' '?' "'container Object '" pcNameContainer}.
    END.
    ELSE DO:
      ASSIGN
        dSmartObjectObj = 0.
    END.

    /*
    1 - Browser
    2 - Viewer
    3 - Data
    4 - SBO
    5 - Panel
    6 - SmartFrame
    7 - DynFrame
    8 - Field
    */
    cClassTypeList[1] = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "browser").
    cClassTypeList[2] = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "viewer").
    cClassTypeList[3] = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "data").
    cClassTypeList[4] = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "sbo").
    cClassTypeList[5] = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "panel").
    cClassTypeList[6] = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "smartframe").
    cClassTypeList[7] = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "dynframe").
    cClassTypeList[8] = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "field").

    ASSIGN
      iSourceObjectTypeList = 0
      iTargetObjectTypeList = 0
      .

    DO iClassTypeLoop = 1 TO 10:

      /* Get the object type class type for the source object type */
      IF LOOKUP(b_source_gsc_object_type.object_type_code,cClassTypeList[iClassTypeLoop]) > 0
      THEN iSourceObjectTypeList = iClassTypeLoop.
      /* Get the object type class type for the target object type */
      IF LOOKUP(b_target_gsc_object_type.object_type_code,cClassTypeList[iClassTypeLoop]) > 0
      THEN iTargetObjectTypeList = iClassTypeLoop.

    END.

    IF iSourceObjectTypeList = 0
    THEN
      RETURN ERROR {aferrortxt.i 'AF' '40' '?' '?' "'Source Object Type ' + b_source_gsc_object_type.object_type_code + ' not part of a valid changable class.'"}.

    IF iTargetObjectTypeList = 0
    THEN
      RETURN ERROR {aferrortxt.i 'AF' '40' '?' '?' "'Target Object Type ' + b_target_gsc_object_type.object_type_code + ' not part of a valid changable class.'"}.

    IF iSourceObjectTypeList <> iTargetObjectTypeList
    THEN
      RETURN ERROR {aferrortxt.i 'AF' '40' '?' '?' "'Changing object instances from Object Type ' + b_source_gsc_object_type.object_type_code + ' to ' + b_target_gsc_object_type.object_type_code + ' not allowed.'"}.

    /* Fetch the repository class for the target object */
    httClassBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN gshRepositoryManager, b_target_gsc_object_type.object_type_code ).
    DYNAMIC-FUNCTION("cacheClassExtInfo":U , b_target_gsc_object_type.object_type_code).
    hAttributeBuffer = httClassBuffer:BUFFER-FIELD("classBufferHandle":U):BUFFER-VALUE.

    IF NOT VALID-HANDLE(httClassBuffer)
    OR NOT VALID-HANDLE(hAttributeBuffer)
    THEN 
      RETURN ERROR {aferrortxt.i 'AF' '40' '?' '?' "'Object Classes not available for Object Type' + b_target_gsc_object_type.object_type_code"}.

    /* Okay... looks like we're all set. Let's do it.
       Now we loop through all ryc_smartobjects with this filename. */
    FOR EACH b_source_ryc_smartobject EXCLUSIVE-LOCK
      WHERE b_source_ryc_smartobject.object_filename = pcNameObjectSource
      /* WHERE b_source_ryc_smartobject.smartobject_obj = dSourceSmartObjectObj */
      :

      blkObjectInstance:
      FOR EACH b_ryc_object_instance EXCLUSIVE-LOCK
        WHERE b_ryc_object_instance.smartobject_obj = b_source_ryc_smartobject.smartobject_obj
        :

        IF /* If the container name was specified and is valid only process for the particular container */
          ( dSmartObjectObj      <> 0    AND b_ryc_object_instance.container_smartobject_obj <> dSmartObjectObj )
        OR /* If the instance name was specified and is valid only process for the particular instance */
          ( pcNameObjectInstance <> "":U AND b_ryc_object_instance.instance_name             <> pcNameObjectInstance )
        THEN
          NEXT blkObjectInstance.

        FOR EACH b_source_ryc_attribute_value EXCLUSIVE-LOCK
          WHERE b_source_ryc_attribute_value.object_type_obj           = b_source_ryc_smartobject.object_type_obj
            AND b_source_ryc_attribute_value.smartobject_obj           = b_source_ryc_smartobject.smartobject_obj
            AND b_source_ryc_attribute_value.object_instance_obj       = b_ryc_object_instance.object_instance_obj
            AND b_source_ryc_attribute_value.container_smartobject_obj = b_ryc_object_instance.container_smartobject_obj
            :

          IF plRemoveDefaultAttributes = TRUE
          THEN DO:

            DELETE b_source_ryc_attribute_value NO-ERROR.
            IF ERROR-STATUS:ERROR
            OR RETURN-VALUE <> "":U
            THEN
              RETURN ERROR RETURN-VALUE.

          END.
          ELSE
          /* IF plRemoveDefaultAttributes = FALSE THEN */
          DO:

            /*

            Check if the current attributes exists for the target object type class
            If it doesn't - Delete it.
            If it does    - Change the relavant pointer values for it

            IF b_source_gsc_object_type.object_type_code <> b_target_gsc_object_type.object_type_code
            THEN DO:
            END. /* IF b_source_gsc_object_type.object_type_code <> b_target_gsc_object_type.object_type_code */

            */

            ASSIGN
              hAttributeField = hAttributeBuffer:BUFFER-FIELD(b_source_ryc_attribute_value.attribute_label) NO-ERROR.
            IF hAttributeField = ?
            OR NOT VALID-HANDLE(hAttributeField)
            THEN DO:

              IF plRemoveUnusedAttributes = TRUE
              THEN DO:

                DELETE b_source_ryc_attribute_value NO-ERROR.
                IF ERROR-STATUS:ERROR
                OR RETURN-VALUE <> "":U
                THEN
                  RETURN ERROR RETURN-VALUE.

              END.

            END.
            ELSE DO:

              /* */
              ASSIGN
                b_source_ryc_attribute_value.object_type_obj = b_target_gsc_object_type.object_type_obj
                b_source_ryc_attribute_value.smartobject_obj = b_target_ryc_smartobject.smartobject_obj /* dTargetSmartObjectObj */
                .
              VALIDATE b_source_ryc_attribute_value NO-ERROR.
              IF ERROR-STATUS:ERROR
              THEN
                UNDO, RETURN RETURN-VALUE.

            END.

          END. /* IF plRemoveDefaultAttributes = FALSE THEN */

        END. /* FOR EACH b_source_ryc_attribute_value NO-LOCK */

        FOR EACH b_ryc_ui_event EXCLUSIVE-LOCK
          WHERE b_ryc_ui_event.object_type_obj           = b_source_ryc_smartobject.object_type_obj
            AND b_ryc_ui_event.smartobject_obj           = b_source_ryc_smartobject.smartobject_obj
            AND b_ryc_ui_event.object_instance_obj       = b_ryc_object_instance.object_instance_obj
            AND b_ryc_ui_event.container_smartobject_obj = b_ryc_object_instance.container_smartobject_obj:

          ASSIGN
            b_ryc_ui_event.object_type_obj = b_target_gsc_object_type.object_type_obj
            b_ryc_ui_event.smartobject_obj = b_target_ryc_smartobject.smartobject_obj /* dTargetSmartObjectObj */
            .
          VALIDATE b_ryc_ui_event NO-ERROR.
          IF ERROR-STATUS:ERROR
          THEN
            UNDO, RETURN RETURN-VALUE.

        END. /* FOR EACH b_ryc_ui_event NO-LOCK */

        /* */
        ASSIGN
          b_ryc_object_instance.smartobject_obj = b_target_ryc_smartobject.smartobject_obj /* dTargetSmartObjectObj */
          .
        VALIDATE b_ryc_object_instance NO-ERROR.
        IF ERROR-STATUS:ERROR
        THEN
          UNDO, RETURN RETURN-VALUE.

      ASSIGN
        piReplacementCount = piReplacementCount + 1.


      END. /* FOR EACH b_ryc_object_instance */

    END. /* FOR EACH b_source_ryc_smartobject EXCLUSIVE-LOCK */

    IF plDeleteObjectSource = TRUE
    THEN DO:

      RUN removeObject IN THIS-PROCEDURE
                      (INPUT pcNameObjectSource
                      ,INPUT pcResultCode
                      ).

      IF ERROR-STATUS:ERROR
      OR RETURN-VALUE <> "":U
      THEN
        RETURN ERROR RETURN-VALUE.

    END. /* IF plDeleteObjectSource = TRUE */

  &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeObjectType Include 
PROCEDURE changeObjectType :
/*------------------------------------------------------------------------------
  Purpose:     Changes the object type of an object to another object type.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectFileName    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcObjectTypeCode    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plRemoveDefaultAttr AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plRemoveNonOTAttr   AS LOGICAL    NO-UNDO.

  &IF DEFINED(Server-Side) EQ 0 &THEN    
  { dynlaunch.i &PLIP              = "'RepositoryDesignManager'"
                &iProc             = "'changeObjectType'"
               &mode1  = INPUT  &parm1  = pcObjectFileName            &dataType1  = CHARACTER
               &mode2  = INPUT  &parm2  = pcObjectTypeCode            &dataType2  = CHARACTER
               &mode3  = INPUT  &parm3  = plRemoveDefaultAttr         &dataType3  = LOGICAL
               &mode4  = INPUT  &parm4  = plRemoveNonOTAttr           &dataType4  = LOGICAL
  }
  IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.   
  &ELSE   
  
  DEFINE VARIABLE cParentObjectList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChildObjectList  AS CHARACTER  NO-UNDO.
  
  DEFINE BUFFER bryc_smartobject      FOR ryc_smartobject.
  DEFINE BUFFER bgsc_object_type      FOR gsc_object_type.
  DEFINE BUFFER bnew_object_type      FOR gsc_object_type.
  DEFINE BUFFER bryc_object_instance  FOR ryc_object_instance.
  DEFINE BUFFER bryc_ui_event         FOR ryc_ui_event.
  DEFINE BUFFER bryc_attribute_value  FOR ryc_attribute_value.
  DEFINE BUFFER bobject_attribute     FOR ryc_attribute_value.

  /* First try and find the object that we are going to change */
  FIND FIRST bryc_smartobject NO-LOCK 
    WHERE bryc_smartobject.object_filename          = pcObjectFileName
      AND bryc_smartobject.customization_result_obj = 0.0
    NO-ERROR.
  IF NOT AVAILABLE(bryc_smartobject) THEN
    RETURN {aferrortxt.i 'RY' '01' '?' '?' pcObjectFileName}.

  /* Now find the new object type that we need to work with */
  FIND FIRST bnew_object_type NO-LOCK
    WHERE bnew_object_type.object_type_code = pcObjectTypeCode 
    NO-ERROR.
  IF NOT AVAILABLE(bnew_object_type) THEN
    RETURN {aferrortxt.i 'RY' '04' '?' '?' pcObjectTypeCode}.

  /* Now find the old object type that we need to work with */
  FIND FIRST bgsc_object_type NO-LOCK
    WHERE bgsc_object_type.object_type_obj = bryc_smartobject.object_type_obj 
    NO-ERROR.
  IF NOT AVAILABLE(bgsc_object_type) THEN
    RETURN {aferrortxt.i 'RY' '04' '?' '?' STRING(bryc_smartobject.object_type_obj)}.

  /* Next, get the list of parent items for the old object type */
  cParentObjectList = DYNAMIC-FUNCTION("getClassParentsFromDB":U IN gshRepositoryManager,
                                       bgsc_object_type.object_type_code).
  IF NOT CAN-DO(cParentObjectList,bnew_object_type.object_type_code) THEN
  DO:
    /* Next, get the list of child items for the old object type */
    cChildObjectList = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager,
                                         bgsc_object_type.object_type_code).
    IF NOT CAN-DO(cChildObjectList,bnew_object_type.object_type_code) THEN
      RETURN {aferrortxt.i 'RY' '12' '?' '?' pcObjectFileName pcObjectTypeCode bgsc_object_type.object_type_code}.
  END.

  /* Okay... looks like we're all set. Let's do it. 
     Now we loop through all ryc_smartobjects with this filename. */
  FOR EACH bryc_smartobject EXCLUSIVE-LOCK 
    WHERE bryc_smartobject.object_filename          = pcObjectFileName:

    FOR EACH bryc_attribute_value EXCLUSIVE-LOCK
      WHERE bryc_attribute_value.object_type_obj           = bryc_smartobject.object_type_obj
        AND bryc_attribute_value.smartobject_obj           = bryc_smartobject.smartobject_obj
        AND bryc_attribute_value.object_instance_obj       = 0.0
        AND bryc_attribute_value.container_smartobject_obj = 0.0:

      /* Check if this attribute exists at the object type level. If it doesn't, delete it. 
         Otherwise change the object type for it */
      FIND FIRST bobject_attribute NO-LOCK
        WHERE bobject_attribute.object_type_obj            = bnew_object_type.object_type_obj
          AND bobject_attribute.smartobject_obj           = 0.0
          AND bobject_attribute.object_instance_obj       = 0.0
          AND bobject_attribute.container_smartobject_obj = 0.0
          AND bobject_attribute.attribute_label           = bryc_attribute_value.attribute_label
        NO-ERROR.
      
      ASSIGN
        bryc_attribute_value.object_type_obj = bnew_object_type.object_type_obj
      .
      VALIDATE bryc_attribute_value NO-ERROR.
      IF ERROR-STATUS:ERROR THEN
        UNDO, RETURN RETURN-VALUE.
    END. /* FOR EACH bryc_attribute_value NO-LOCK */
    
    FOR EACH bryc_ui_event EXCLUSIVE-LOCK
      WHERE bryc_ui_event.object_type_obj           = bryc_smartobject.object_type_obj
        AND bryc_ui_event.smartobject_obj           = bryc_smartobject.smartobject_obj
        AND bryc_ui_event.object_instance_obj       = 0
        AND bryc_ui_event.container_smartobject_obj = 0:
      ASSIGN
        bryc_ui_event.object_type_obj = bnew_object_type.object_type_obj
      .
      VALIDATE bryc_ui_event NO-ERROR.
      IF ERROR-STATUS:ERROR THEN
        UNDO, RETURN RETURN-VALUE.
    END. /* FOR EACH bryc_ui_event NO-LOCK */
    
    FOR EACH bryc_object_instance NO-LOCK
      WHERE bryc_object_instance.smartobject_obj = bryc_smartobject.smartobject_obj:
    
      FOR EACH bryc_attribute_value EXCLUSIVE-LOCK
        WHERE bryc_attribute_value.object_type_obj           = bryc_smartobject.object_type_obj
          AND bryc_attribute_value.smartobject_obj           = bryc_smartobject.smartobject_obj
          AND bryc_attribute_value.object_instance_obj       = bryc_object_instance.object_instance_obj
          AND bryc_attribute_value.container_smartobject_obj = bryc_object_instance.container_smartobject_obj:
    
        /* Check if this attribute exists at the object type level. If it doesn't, delete it. 
           Otherwise change the object type for it */
        FIND FIRST bobject_attribute NO-LOCK
          WHERE bobject_attribute.object_type_obj            = bnew_object_type.object_type_obj
            AND bobject_attribute.smartobject_obj           = 0.0
            AND bobject_attribute.object_instance_obj       = 0.0
            AND bobject_attribute.container_smartobject_obj = 0.0
            AND bobject_attribute.attribute_label           = bryc_attribute_value.attribute_label
          NO-ERROR.
        ASSIGN
          bryc_attribute_value.object_type_obj = bnew_object_type.object_type_obj
        .
        VALIDATE bryc_attribute_value NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          UNDO, RETURN RETURN-VALUE.

      END. /* FOR EACH bryc_attribute_value NO-LOCK */
    
      FOR EACH bryc_ui_event EXCLUSIVE-LOCK
        WHERE bryc_ui_event.object_type_obj           = bryc_smartobject.object_type_obj
          AND bryc_ui_event.smartobject_obj           = bryc_smartobject.smartobject_obj
          AND bryc_ui_event.object_instance_obj       = bryc_object_instance.object_instance_obj
          AND bryc_ui_event.container_smartobject_obj = bryc_object_instance.container_smartobject_obj:
    
        ASSIGN
          bryc_ui_event.object_type_obj = bnew_object_type.object_type_obj
        .
        VALIDATE bryc_ui_event NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          UNDO, RETURN RETURN-VALUE.
    
      END. /* FOR EACH bryc_ui_event NO-LOCK */
    
    END.
    
    ASSIGN
      bryc_smartobject.object_type_obj = bnew_object_type.object_type_obj
    .
    VALIDATE bryc_smartobject NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
      UNDO, RETURN RETURN-VALUE.
  
  END. /* FOR EACH bryc_smartobject EXCLUSIVE-LOCK */


  /* If everything worked, we need to go ahead and remove the default values 
     if that flag was set */

  IF plRemoveDefaultAttr OR
     plRemoveNonOTAttr   THEN
  RUN removeDefaultAttrValues IN THIS-PROCEDURE
    (pcObjectFileName,
     plRemoveDefaultAttr,
     plRemoveNonOTAttr).
  &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearDesignCache Include 
PROCEDURE clearDesignCache :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE ttClassExtInformation.

    ASSIGN gcCLASS-PHYSICAL-CONTAINER = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "{&CLASS-PHYSICAL-CONTAINER}":U)
           gcCLASS-PHYSICAL-CONTAINER = REPLACE(gcCLASS-PHYSICAL-CONTAINER, CHR(3), ",")

           gcCLASS-PHYSICAL-VIEWER    = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "{&CLASS-PHYSICAL-VIEWER}":U)
           gcCLASS-PHYSICAL-VIEWER    = REPLACE(gcCLASS-PHYSICAL-VIEWER, CHR(3), ",")

           gcCLASS-PHYSICAL-BROWSE    = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "{&CLASS-PHYSICAL-BROWSE}":U)
           gcCLASS-PHYSICAL-BROWSE    = REPLACE(gcCLASS-PHYSICAL-BROWSE, CHR(3), ",")

           gcCLASS-PHYSICAL-COMBO     = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "{&CLASS-PHYSICAL-COMBO}":U)
           gcCLASS-PHYSICAL-COMBO     = REPLACE(gcCLASS-PHYSICAL-COMBO, CHR(3), ",")

           gcCLASS-PHYSICAL-LOOKUP    = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "{&CLASS-PHYSICAL-LOOKUP}":U)
           gcCLASS-PHYSICAL-LOOKUP    = REPLACE(gcCLASS-PHYSICAL-LOOKUP, CHR(3), ",")

           gcCLASS-PHYSICAL-SDO       = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "{&CLASS-PHYSICAL-SDO}":U)
           gcCLASS-PHYSICAL-SDO       = REPLACE(gcCLASS-PHYSICAL-SDO, CHR(3), ",")

           gcCONTAINER-CLASSES        = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "{&CONTAINER-CLASSES}":U)
           gcCONTAINER-CLASSES        = REPLACE(gcCONTAINER-CLASSES, CHR(3), ",")

           gcCLASS-HAS-NO-EXTENSION   = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "{&CLASS-HAS-NO-EXTENSION}":U)
           gcCLASS-HAS-NO-EXTENSION   = REPLACE(gcCLASS-HAS-NO-EXTENSION, CHR(3), ",")

           gcCLASS-PHYSICAL-FRAME     = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "{&CLASS-PHYSICAL-FRAME}":U)
           gcCLASS-PHYSICAL-FRAME     = REPLACE(gcCLASS-PHYSICAL-FRAME, CHR(3), ",")

           gcCLASS-PHYSICAL-SBO       = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "{&CLASS-PHYSICAL-SBO}":U)
           gcCLASS-PHYSICAL-SBO       = REPLACE(gcCLASS-PHYSICAL-SBO, CHR(3), ",")
           .
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* clearDesignCache */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doServerRetrieveClassExtInfo Include 
PROCEDURE doServerRetrieveClassExtInfo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcClassName          AS CHARACTER            NO-UNDO.

    DEFINE VARIABLE hClassExtTable              AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hClassExtBuffer             AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hCacheClassExtBuffer        AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hQuery                      AS HANDLE               NO-UNDO.

    {dynlaunch.i
        &Plip  = 'RepositoryDesignManager'
        &IProc = 'serverRetrieveClassExtInfo'
        &mode1 = INPUT  &parm1 = pcClassName    &datatype1 = CHARACTER
        &mode2 = OUTPUT &parm2 = hClassExtTable &datatype2 = TABLE-HANDLE
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

    /** Put this information in the client-side cache.
     *  ----------------------------------------------------------------------- **/
    ASSIGN hClassExtBuffer      = hClassExtTable:DEFAULT-BUFFER-HANDLE
           hCacheClassExtBuffer = BUFFER ttClassExtinformation:HANDLE
           .
    CREATE QUERY hQuery.
    hQuery:ADD-BUFFER(hClassExtBuffer).
    hQuery:QUERY-PREPARE(" FOR EACH ":U + hClassExtBuffer:NAME ).
    hQuery:QUERY-OPEN().

    hQuery:GET-FIRST().
    DO WHILE hClassExtBuffer:AVAILABLE:
        hCacheClassExtBuffer:FIND-FIRST(" WHERE ":U
                                        + hCacheClassExtBuffer:NAME + ".tClassName = ":U + QUOTER(hClassExtBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE) + " AND ":U
                                        + hCacheClassExtBuffer:NAME + ".tAttributeName = ":U + QUOTER(hClassExtBuffer:BUFFER-FIELD("tAttributeName":U):BUFFER-VALUE) ) NO-ERROR.
        IF NOT hCacheClassExtBuffer:AVAILABLE THEN
        DO:
            hCacheClassExtBuffer:BUFFER-CREATE().
            hCacheClassExtBuffer:BUFFER-COPY(hClassExtBuffer).
            hCacheClassExtBuffer:BUFFER-RELEASE().
        END.    /* n/a hCacheClassExtBuffer*/

        hQuery:GET-NEXT().
    END.    /* hClassExtBuffer */
    hQuery:QUERY-CLOSE().

    DELETE OBJECT hQuery NO-ERROR.
    ASSIGN hQuery               = ?
           hCacheClassExtBuffer = ?
           .
    /** Delete the returned tables since we have copied any relewant information
     *  into the client cache .
     *  ----------------------------------------------------------------------- **/
    DELETE OBJECT hClassExtTable NO-ERROR.
    ASSIGN hClassExtTable = ?.

    DELETE OBJECT hClassExtBuffer NO-ERROR.
    ASSIGN hClassExtBuffer = ?.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* doServerRetrieveClassExtInfo */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE editRyObjectInAB Include 
PROCEDURE editRyObjectInAB :
/*------------------------------------------------------------------------------
  Purpose:  This function will allow you to open an RyObject completely to be
            maintained using the correct tool. This is a procedure because if
            a function was used to call it, INPUT BLOCKING errors are encountered.

  Parameters:  INPUT pcObjectFilename - Can be a relatively pathed filename (like the
                                        value for a DataLogicProcedure attribute or
                                        the ryc_smartobject.object_filename. Values
                                        will be trimmed (if necessary) and used to
                                        locate the relevant record in ryc_smartobject.
               INPUT pdSmartObjectObj - ryc_smartobject.smartobject_obj field will
                                        be used to locate the record with the value
                                        specified

  Notes:  You can either specify the object_filename, or a smartobject_obj.
          If you specify both, the smartobject_obj will be used to try and
          locate the object.
          
          This can be used to edit custom super procedures, data logic procedures, dynamic
          objects etc. This will use openObjectAB in this procedure to create the _RyObject
          record needed by the AppBuilder.

          The tools to open the different objects will be as follows
          Toolbar & Menu Designer - Toolbars
          Container Builder       - DynFrame, DynSBO, DynObjc, DynFold, DynMenc
          AppBuilder              - Everything else
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcObjectFilename AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pdSmartObjectObj AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE cObjectFilename     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectTypeCode     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProcedureType      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRunAttribute       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldValues        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lFoundAppBuilder    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE dSmartObjectObj     AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hLaunchedProcedure  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hAppBuilder         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hHandle             AS HANDLE     NO-UNDO.

  dSmartObjectObj = (IF pdSmartObjectObj <> 0.00 THEN pdSmartObjectObj ELSE {fnarg getSmartObjectObj "pcObjectFilename, 0.00"}).

  cQuery = "FOR EACH ryc_smartobject NO-LOCK":U
         + "   WHERE ryc_smartobject.smartobject_obj = ":U + QUOTER(dSmartObjectObj) + ",":U
         + "   FIRST gsc_object_type NO-LOCK":U
         + "   WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj INDEXED-REPOSITION":U.

  RUN getRecordDetail IN gshGenManager (INPUT  cQuery,
                                        OUTPUT cFieldValues) NO-ERROR.

  IF cFieldValues = "":U THEN
    cObjectFilename = pcObjectFilename.
  ELSE
  DO:
    ASSIGN
        cObjectFilename = ENTRY(LOOKUP("ryc_smartobject.object_filename":U,  cFieldValues, CHR(3)) + 1, cFieldValues, CHR(3))
        cObjectTypeCode = ENTRY(LOOKUP("gsc_object_type.object_type_code":U, cFieldValues, CHR(3)) + 1, cFieldValues, CHR(3)).

    IF LOOKUP(cObjectTypeCode, {fnarg getClassChildrenFromDB 'Panel' gshRepositoryManager}) <> 0 THEN
    DO:
      RUN launchContainer IN gshSessionManager (INPUT  "afmenumaintw.w":U,  /* pcObjectFileName       */
                                                INPUT  "":U,                /* pcPhysicalName         */
                                                INPUT  "":U,                /* pcLogicalName          */
                                                INPUT  FALSE,               /* plOnceOnly             */
                                                INPUT  "":U,                /* pcInstanceAttributes   */
                                                INPUT  "":U,                /* pcChildDataKey         */
                                                INPUT  "":U,                /* pcRunAttribute         */
                                                INPUT  "":U,                /* container mode         */
                                                INPUT  ?,                   /* phParentWindow         */
                                                INPUT  ?,                   /* phParentProcedure      */
                                                INPUT  ?,                   /* phObjectProcedure      */
                                                OUTPUT hLaunchedProcedure,  /* phProcedureHandle      */
                                                OUTPUT cProcedureType).     /* pcProcedureType        */

      IF VALID-HANDLE(hLaunchedProcedure) THEN
      DO:
        RUN selectToolbarNode IN hLaunchedProcedure (cObjectFilename).

        {get ContainerHandle hHandle hLaunchedProcedure}.
        hHandle:MOVE-TO-TOP().
      END.

      RETURN.
    END.
    ELSE
      IF LOOKUP(cObjectTypeCode, {fnarg getClassChildrenFromDB 'DynFrame' gshRepositoryManager}) <> 0 OR
         LOOKUP(cObjectTypeCode, {fnarg getClassChildrenFromDB 'DynSBO'   gshRepositoryManager}) <> 0 OR
         LOOKUP(cObjectTypeCode, {fnarg getClassChildrenFromDB 'DynFold'  gshRepositoryManager}) <> 0 OR
         LOOKUP(cObjectTypeCode, {fnarg getClassChildrenFromDB 'DynObjc'  gshRepositoryManager}) <> 0 OR
         LOOKUP(cObjectTypeCode, {fnarg getClassChildrenFromDB 'DynMenc'  gshRepositoryManager}) <> 0 THEN
      DO:
        cRunAttribute = "AppBuilder":U + CHR(3) + CHR(3).

        RUN launchContainer IN gshSessionManager (INPUT  "rycntpshtw":U,      /* pcObjectFileName       */
                                                  INPUT  "":U,                /* pcPhysicalName         */
                                                  INPUT  "":U,                /* pcLogicalName          */
                                                  INPUT  FALSE,               /* plOnceOnly             */
                                                  INPUT  "":U,                /* pcInstanceAttributes   */
                                                  INPUT  "":U,                /* pcChildDataKey         */
                                                  INPUT  cRunAttribute,       /* pcRunAttribute         */
                                                  INPUT  "":U,                /* container mode         */
                                                  INPUT  ?,                   /* phParentWindow         */
                                                  INPUT  ?,                   /* phParentProcedure      */
                                                  INPUT  ?,                   /* phObjectProcedure      */
                                                  OUTPUT hLaunchedProcedure,  /* phProcedureHandle      */
                                                  OUTPUT cProcedureType).     /* pcProcedureType        */

        RUN loadContainer IN hLaunchedProcedure (INPUT cObjectFilename).

        RETURN.
      END.
  END.

  /* If the object was a DynFrame, DynSBO, DynMenc, DynObjc, DynFold or Toolbar, then we would have executed a return statement. If
     we reach this point, it is something that needs to be opened by the AppBuilder */
    
  /* Find the handle to the AppBuilder */
  hAppBuilder = SESSION:FIRST-PROCEDURE.

  DO WHILE VALID-HANDLE(hAppBuilder):
    IF hAppBuilder:FILENAME MATCHES("*adeuib/_abmbar.w":U) THEN
    DO:
      lFoundAppBuilder = TRUE.

      LEAVE.
    END.

    hAppBuilder = hAppBuilder:NEXT-SIBLING.
  END.

  /* If the AppBuilder was found, open the object */
  IF lFoundAppBuilder THEN
  DO:
    {fnarg openRyObjectAB cObjectFilename}.

    RUN adeuib/_open-w.p (cObjectFilename, "":U, "WINDOW":U).
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateCalculatedField Include 
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
    
    &IF DEFINED(Server-Side) EQ 0 &THEN    
    { dynlaunch.i &PLIP              = "'ry/app/rydessrvrp.p'"
                  &iProc             = "'generateCalculatedField'"
                 &mode1  = INPUT  &parm1  = pcCalcFieldName           &dataType1  = CHARACTER
                 &mode2  = INPUT  &parm2  = pcDataType                &dataType2  = CHARACTER
                 &mode3  = INPUT  &parm3  = pcFieldFormat             &dataType3  = CHARACTER
                 &mode4  = INPUT  &parm4  = pcFieldLabel              &dataType4  = CHARACTER
                 &mode5  = INPUT  &parm5  = pcFieldHelp               &dataType5  = CHARACTER
                 &mode6  = INPUT  &parm6  = pcProductModuleCode       &dataType6  = CHARACTER
                 &mode7  = INPUT  &parm7  = pcResultCode              &dataType7  = CHARACTER
                 &mode8  = INPUT  &parm8  = pcObjectTypeCode          &dataType8  = CHARACTER
    }
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.   
    &ELSE   
    
    DEFINE VARIABLE cDataFieldClasses AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dCalcFieldObj     AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE hAttrField        AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer  AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hAttributeTable   AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hOTTable          AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hOTBuffer         AS HANDLE     NO-UNDO.
    DEFINE VARIABLE lAttrValueSame    AS LOGICAL    NO-UNDO.

    /* Make sure that at least the CalculatedField class is cached. */
    RUN createClassCache IN gshRepositoryManager ( INPUT "CalculatedField,":U + pcObjectTypeCode).

    ASSIGN cDataFieldClasses = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "CalculatedField":U).
    IF NOT CAN-DO(cDataFieldClasses, pcObjectTypeCode) THEN
        RETURN ERROR {aferrortxt.i 'AF' '15' '?' '?' "'the class specified does not inherit from the CalculatedField class.'"}.

    EMPTY TEMP-TABLE ttStoreAttribute.
          
    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "DATA-TYPE":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = pcDataType
           .

    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "FORMAT":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = pcFieldFormat
           .

    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "LABEL":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = pcFieldLabel
           .

    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "HELP":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = pcFieldHelp
           .

    ASSIGN dWidth = DYNAMIC-FUNCTION("getWidgetSizeFromFormat":U,
                                      INPUT  pcFieldFormat,
                                      INPUT  "CHARACTER":U,
                                      OUTPUT dHeight).
    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "HEIGHT-CHARS":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tDecimalValue       = dHeight
           .

    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "WIDTH-CHARS":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tDecimalValue       = dWidth
           .
    ASSIGN hAttributeBuffer = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE
                              hAttributeTable  = ?.

    /* Get rid of any attribute values that match those at the Class level. */
    DYNAMIC-FUNCTION("cleanStoreAttributeValues":U IN TARGET-PROCEDURE,
                     INPUT "":U,              /* pcObjectName*/
                     INPUT pcObjectTypeCode,
                     INPUT "CLASS":U,
                     INPUT hAttributeBuffer   ).

    RUN insertObjectMaster ( INPUT  pcCalcFieldName,                          /* pcObjectName         */
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
    ASSIGN lError       = ERROR-STATUS:ERROR
           cReturnValue = RETURN-VALUE
           .

    &ENDIF
    
    IF lError THEN
        RETURN ERROR cReturnValue.
    ELSE
        RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateDataFields Include 
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
    
    &IF DEFINED(Server-Side) EQ 0 &THEN    
    {dynlaunch.i
        &PLIP              = "'RepositoryDesignManager'"
        &iProc             = "'generateDataFields'"
        &mode1  = INPUT  &parm1  = pcDataBaseName            &dataType1  = CHARACTER
        &mode2  = INPUT  &parm2  = pcTableName               &dataType2  = CHARACTER
        &mode3  = INPUT  &parm3  = pcProductModuleCode       &dataType3  = CHARACTER
        &mode4  = INPUT  &parm4  = pcResultCode              &dataType4  = CHARACTER
        &mode5  = INPUT  &parm5  = plGenerateFromDataObject  &dataType5  = LOGICAL
        &mode6  = INPUT  &parm6  = pcDataObjectFieldList     &dataType6  = CHARACTER
        &mode7  = INPUT  &parm7  = pcSdoObjectName           &dataType7  = CHARACTER
        &mode8  = INPUT  &parm8  = pcObjectTypeCode          &dataType8  = CHARACTER
        &mode9  = INPUT  &parm9  = pcOverrideAttributes      &dataType9  = CHARACTER
        &mode10 = INPUT  &parm10 = pcFieldNames              &dataType10 = CHARACTER
    }
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.   
    &ELSE   
    DEFINE VARIABLE cWidgetPoolName             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cFieldName                  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cFileName                   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cDataFieldName              AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cPhysicalSdoName            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cViewAs                     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cDatabaseName               AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hFieldBuffer                AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hFileBuffer                 AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hQuery                      AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hAttributeTable             AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hSchemaField                AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hNonSchemaField             AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hSDO                        AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hObjectBuffer               AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer            AS HANDLE     NO-UNDO.
    DEFINE VARIABLE iExtent                     AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iMaxExtent                  AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iDbLoop                     AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.
    DEFINE VARIABLE dDataFieldObj               AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dHeight                     AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dWidth                      AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dCustomisationResultObj     AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE cFieldDataType              AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cFieldFormat                AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cFieldLabel                 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cColumnLabel                AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hSmartDataObject            AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cSDOFieldList               AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hOTTable                    AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hOTBuffer                   AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hAttrField                  AS HANDLE     NO-UNDO.
    DEFINE VARIABLE lAttrValueSame              AS LOGICAL    NO-UNDO.

    DEFINE BUFFER ryc_smartObject       FOR ryc_smartObject.

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
        RUN startDataObject IN gshRepositoryManager ( INPUT pcSdoObjectName, OUTPUT hSmartDataObject ) NO-ERROR.
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
        ASSIGN pcDatabaseName = DYNAMIC-FUNCTION("getBufferDbName":U, INPUT pcTableName).
    
    IF pcDatabaseName EQ ? OR pcDatabaseName EQ "":U THEN
        ASSIGN pcDatabaseName = LDBNAME("DICTDB":U).
    
    IF pcDatabaseName EQ ? OR pcDatabaseName EQ "":U THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'Database Name'" pcDatabaseName}.
    
    DBNAME-LOOP:
    DO iDbLoop = 1 TO NUM-ENTRIES(pcDatabaseName):
        ASSIGN cDatabaseName = ENTRY(iDbLoop, pcDatabaseName)
               hQuery        = DYNAMIC-FUNCTION("getSchemaQueryHandle":U IN TARGET-PROCEDURE,
                                                INPUT  cDataBaseName,
                                                INPUT  pcTableName,
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
                           cFieldLabel  = hFieldBuffer:BUFFER-FIELD("_Label":U):BUFFER-VALUE + " &1":U
                           cColumnLabel = hFieldBuffer:BUFFER-FIELD("_Col-Label":U):BUFFER-VALUE + " &1":U.

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
                         * on a dynamic viewer and other copntainers will take their 
                         * TableName value from the run-time DataSource (SDO).          */
                        CREATE ttStoreAttribute.
                        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                               ttStoreAttribute.tAttributeParentObj = 0
                               ttStoreAttribute.tAttributeLabel     = "TableName":U
                               ttStoreAttribute.tConstantValue      = YES
                               ttStoreAttribute.tCharacterValue     = cFileName.

                        /* The DATATYPE attribute is constanct at the master data field level. */
                        CREATE ttStoreAttribute.
                        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                               ttStoreAttribute.tAttributeParentObj = 0
                               ttStoreAttribute.tAttributeLabel     = "DATA-TYPE":U
                               ttStoreAttribute.tConstantValue      = YES
                               ttStoreAttribute.tCharacterValue     = cFieldDataType.

                        /* We always update the SCHEMA-* attributes since these are defined as the 
                         * value as per the schema. If this is a new DataField, then we also need to update
                         * the non-SCHEMA attributes. We also update the non-SCHEMA attributes but only if
                         * they are the same as the existing schema attributes. This way we can keep the
                         * Repository in synch with the DB meta-schema.                                    */
                        FIND FIRST ryc_smartObject WHERE
                                   ryc_smartObject.object_filename = (cFileName + ".":U + cDataFieldName)
                                   NO-LOCK NO-ERROR.

                        IF AVAILABLE ryc_smartObject THEN
                        DO:
                            DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                                             INPUT (cFileName + ".":U + cDataFieldName), INPUT ?, INPUT ?, INPUT NO).
                            ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?).
                        END.    /* DataField already in the Repository */
                        ELSE
                            ASSIGN hObjectBuffer = ?.

                        IF VALID-HANDLE(hObjectBuffer) THEN
                        DO:
                            ASSIGN hAttributeBuffer = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE.
                            hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U
                                                        + QUOTER(hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE) ).
                        END.    /* buffer available*/
                        ELSE
                        DO:
                            ASSIGN hObjectBuffer    = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN gshRepositoryManager,
                                                                       INPUT pcObjectTypeCode)
                                   hAttributeBuffer = hObjectBuffer:BUFFER-FIELD("ClassBufferHandle":U):BUFFER-VALUE.
                            /* We need to create a record for comparison purposes. 
                             * This record will be deleted by the cleanStoreAttributeValues() API. */
                            hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(0) ) NO-ERROR.
                            IF NOT hAttributeBuffer:AVAILABLE THEN
                                hAttributeBuffer:BUFFER-CREATE().
                        END.    /* new DataField */

                        DYNAMIC-FUNCTION("buildDataFieldAttribute":U IN TARGET-PROCEDURE,
                                         INPUT hAttributeBuffer,
                                         INPUT (AVAILABLE ryc_smartObject EQ NO OR CAN-DO(pcOverrideAttributes, "DefaultValue":U)),
                                         INPUT "SCHEMA-INITIAL":U, INPUT "DefaultValue":U,
                                         INPUT hFieldBuffer:BUFFER-FIELD("_Initial":U):BUFFER-VALUE   ).

                        DYNAMIC-FUNCTION("buildDataFieldAttribute":U IN TARGET-PROCEDURE,
                                         INPUT hAttributeBuffer,
                                         INPUT (AVAILABLE ryc_smartObject EQ NO OR CAN-DO(pcOverrideAttributes, "FORMAT":U)),
                                         INPUT "SCHEMA-FORMAT":U, INPUT "FORMAT":U,
                                         INPUT cFieldFormat ).

                        DYNAMIC-FUNCTION("buildDataFieldAttribute":U IN TARGET-PROCEDURE,
                                         INPUT hAttributeBuffer,
                                         INPUT (AVAILABLE ryc_smartObject EQ NO OR CAN-DO(pcOverrideAttributes, "LABEL":U)),
                                         INPUT "SCHEMA-LABEL":U, INPUT "LABEL":U,
                                         INPUT SUBSTITUTE(cFieldLabel, STRING(iLoop)) ).

                        DYNAMIC-FUNCTION("buildDataFieldAttribute":U IN TARGET-PROCEDURE,
                                         INPUT hAttributeBuffer,
                                         INPUT (AVAILABLE ryc_smartObject EQ NO OR CAN-DO(pcOverrideAttributes, "ColumnLabel":U)),
                                         INPUT "SCHEMA-COLUMN-LABEL":U, INPUT "ColumnLabel":U,
                                         INPUT SUBSTITUTE(cColumnLabel, STRING(iLoop)) ).

                        DYNAMIC-FUNCTION("buildDataFieldAttribute":U IN TARGET-PROCEDURE,
                                         INPUT hAttributeBuffer,
                                         INPUT (AVAILABLE ryc_smartObject EQ NO OR CAN-DO(pcOverrideAttributes, "Help":U)),
                                         INPUT "SCHEMA-HELP":U, INPUT "Help":U,
                                         INPUT hFieldBuffer:BUFFER-FIELD("_Help":U):BUFFER-VALUE ).

                        ASSIGN cViewAs = hFieldBuffer:BUFFER-FIELD("_View-As":U):BUFFER-VALUE.

                        DYNAMIC-FUNCTION("buildDataFieldAttribute":U IN TARGET-PROCEDURE,
                                         INPUT hAttributeBuffer,
                                         INPUT (AVAILABLE ryc_smartObject EQ NO OR CAN-DO(pcOverrideAttributes, "ViewAs":U)),
                                         INPUT "SCHEMA-VIEW-AS":U, INPUT "ViewAs":U,
                                         INPUT cViewAs ).

                        DYNAMIC-FUNCTION("buildDataFieldAttribute":U IN TARGET-PROCEDURE,
                                         INPUT hAttributeBuffer, INPUT (AVAILABLE ryc_smartObject EQ NO),
                                         INPUT "SCHEMA-VALIDATE-EXPRESSION":U, INPUT "":U,
                                         INPUT hFieldBuffer:BUFFER-FIELD("_ValExp":U):BUFFER-VALUE ).

                        DYNAMIC-FUNCTION("buildDataFieldAttribute":U IN TARGET-PROCEDURE,
                                         INPUT hAttributeBuffer, INPUT (AVAILABLE ryc_smartObject EQ NO),
                                         INPUT "SCHEMA-VALIDATE-MESSAGE":U, INPUT "":U,
                                         INPUT hFieldBuffer:BUFFER-FIELD("_ValMsg":U):BUFFER-VALUE ).

                        DYNAMIC-FUNCTION("buildDataFieldAttribute":U IN TARGET-PROCEDURE,
                                         INPUT hAttributeBuffer,
                                         INPUT (AVAILABLE ryc_smartObject EQ NO OR CAN-DO(pcOverrideAttributes, "Mandatory":U)),
                                         INPUT "SCHEMA-MANDATORY":U, INPUT "Mandatory":U,
                                         INPUT STRING(hFieldBuffer:BUFFER-FIELD("_Mandatory":U):BUFFER-VALUE) ).

                        DYNAMIC-FUNCTION("buildDataFieldAttribute":U IN TARGET-PROCEDURE,
                                         INPUT hAttributeBuffer, INPUT (AVAILABLE ryc_smartObject EQ NO),
                                         INPUT "SCHEMA-DECIMALS":U, INPUT "":U,
                                         INPUT STRING(hFieldBuffer:BUFFER-FIELD("_Decimals":U):BUFFER-VALUE) ).

                        DYNAMIC-FUNCTION("buildDataFieldAttribute":U IN TARGET-PROCEDURE,
                                         INPUT hAttributeBuffer, INPUT (AVAILABLE ryc_smartObject EQ NO),
                                         INPUT "SCHEMA-DESCRIPTION":U, INPUT "":U,
                                         INPUT hFieldBuffer:BUFFER-FIELD("_Desc":U):BUFFER-VALUE ).

                        DYNAMIC-FUNCTION("buildDataFieldAttribute":U IN TARGET-PROCEDURE,
                                         INPUT hAttributeBuffer, INPUT (AVAILABLE ryc_smartObject EQ NO),
                                         INPUT "SCHEMA-CASE-SENSITIVE":U, INPUT "":U,
                                         INPUT STRING(hFieldBuffer:BUFFER-FIELD("_Fld-case":U):BUFFER-VALUE) ).

                        DYNAMIC-FUNCTION("buildDataFieldAttribute":U IN TARGET-PROCEDURE,
                                         INPUT hAttributeBuffer, INPUT (AVAILABLE ryc_smartObject EQ NO),
                                         INPUT "SCHEMA-ORDER":U, INPUT "":U,
                                         INPUT STRING(hFieldBuffer:BUFFER-FIELD("_Order":U):BUFFER-VALUE) ).

                        ASSIGN dWidth = DYNAMIC-FUNCTION("getWidgetSizeFromFormat":U IN TARGET-PROCEDURE,
                                                         INPUT  cFieldFormat,
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
                        
                        CREATE ttStoreAttribute.
                        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                               ttStoreAttribute.tAttributeParentObj = 0
                               ttStoreAttribute.tAttributeLabel     = "ShowPopup":U
                               ttStoreAttribute.tConstantValue      = NO
                               ttStoreAttribute.tLogicalValue       = LOOKUP(hFieldBuffer:BUFFER-FIELD("_Data-Type":U):BUFFER-VALUE, "DATE,INTEGER,DECIMAL":U) GT 0.

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

                            RUN ripViewAsPhrase IN TARGET-PROCEDURE (INPUT hFieldBuffer:BUFFER-FIELD("_View-as":U):BUFFER-VALUE).
                            
                            /* We don't want to have a popup for anything other than a FILL-IN */
                            FIND FIRST ttStoreAttribute WHERE ttStoreAttribute.tAttributeLabel = "ShowPopup":U EXCLUSIVE-LOCK NO-ERROR.
                            IF AVAILABLE ttStoreAttribute THEN
                                ASSIGN ttStoreAttribute.tLogicalValue = FALSE.
                        END.

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
                        END.

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

                        ASSIGN hAttributeBuffer = BUFFER ttStoreAttribute:HANDLE
                               hAttributeTable  = ?.
                        
                        /* Get rid of any attribute values that match those at the Class level. */
                        DYNAMIC-FUNCTION("cleanStoreAttributeValues":U IN TARGET-PROCEDURE,
                                         INPUT "":U,              /* pcObjectName*/
                                         INPUT pcObjectTypeCode,
                                         INPUT "CLASS":U,
                                         INPUT hAttributeBuffer   ).
                        
                        RUN insertObjectMaster IN TARGET-PROCEDURE ( INPUT  cFileName + ".":U + cDataFieldName,       /* pcObjectName         */
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
                                                                     INPUT  hAttributeBuffer,
                                                                     INPUT  TABLE-HANDLE hAttributeTable,
                                                                     OUTPUT dDataFieldObj                  ) NO-ERROR.
                        ASSIGN lError       = ERROR-STATUS:ERROR
                               cReturnValue = RETURN-VALUE.

                        /* We don't return an error from here because we need to 
                         * clean up first.                                       */
                        IF lError OR cReturnValue NE "":U THEN
                            LEAVE DBNAME-LOOP.
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
    &ENDIF
    
    IF lError THEN
        RETURN ERROR cReturnValue.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generateDataFields */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateDataLogicObject Include 
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
  DEFINE INPUT PARAMETER pcDatabaseName           AS CHARACTER            NO-UNDO.
  DEFINE INPUT PARAMETER pcTableName              AS CHARACTER            NO-UNDO.
  DEFINE INPUT PARAMETER pcDumpName               AS CHARACTER            NO-UNDO.
  DEFINE INPUT PARAMETER pcDataObjectName         AS CHARACTER            NO-UNDO.
  DEFINE INPUT PARAMETER pcProductModule          AS CHARACTER            NO-UNDO.
  DEFINE INPUT PARAMETER pcResultCode             AS CHARACTER            NO-UNDO.
  DEFINE INPUT PARAMETER plSuppressValidation     AS LOGICAL              NO-UNDO.
  DEFINE INPUT PARAMETER pcLogicProcedureName     AS CHARACTER            NO-UNDO.
  DEFINE INPUT PARAMETER pcLogicObjectType        AS CHARACTER            NO-UNDO.
  DEFINE INPUT PARAMETER pcLogicProcedureTemplate AS CHARACTER            NO-UNDO.
  DEFINE INPUT PARAMETER pcDataObjectRelativePath AS CHARACTER            NO-UNDO.
  DEFINE INPUT PARAMETER pcDataLogicRelativePath  AS CHARACTER            NO-UNDO.
  DEFINE INPUT PARAMETER pcRootFolder             AS CHARACTER            NO-UNDO.
  DEFINE INPUT PARAMETER pcFolderIndicator        AS CHARACTER            NO-UNDO.
  DEFINE INPUT PARAMETER plCreateMissingFolder    AS LOGICAL              NO-UNDO.

  &IF DEFINED(Server-Side) EQ 0 &THEN
    {dynlaunch.i &PLIP              = "'RepositoryDesignManager'"
                 &iProc             = "'generateDataLogicObject'"
                 &compileStaticCall = NO                 
                 &mode1  = INPUT  &parm1  = pcDatabaseName           &dataType1  = CHARACTER
                 &mode2  = INPUT  &parm2  = pcTableName              &dataType2  = CHARACTER
                 &mode3  = INPUT  &parm3  = pcDumpName               &dataType3  = CHARACTER
                 &mode4  = INPUT  &parm4  = pcDataObjectName         &dataType4  = CHARACTER
                 &mode5  = INPUT  &parm5  = pcProductModule          &dataType5  = CHARACTER
                 &mode6  = INPUT  &parm6  = pcResultCode             &dataType6  = CHARACTER               
                 &mode7  = INPUT  &parm7  = plSuppressValidation     &dataType7  = LOGICAL
                 &mode8  = INPUT  &parm8  = pcLogicProcedureName     &dataType8  = CHARACTER
                 &mode9  = INPUT  &parm9  = pcLogicObjectType        &dataType9  = CHARACTER
                 &mode10 = INPUT  &parm10 = pcLogicProcedureTemplate &dataType10 = CHARACTER
                 &mode11 = INPUT  &parm11 = pcDataObjectRelativePath &dataType11 = CHARACTER
                 &mode12 = INPUT  &parm12 = pcDataLogicRelativePath  &dataType12 = CHARACTER
                 &mode13 = INPUT  &parm13 = pcRootFolder             &dataType13 = CHARACTER
                 &mode14 = INPUT  &parm14 = pcFolderIndicator        &dataType14 = CHARACTER
                 &mode15 = INPUT  &parm15 = plCreateMissingFolder    &dataType15 = LOGICAL                
    }
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
  &ELSE
    DEFINE VARIABLE hAttributeBuffer                AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hAttributeTable                 AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cAbsolutePathedName             AS CHARACTER            NO-UNDO.
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
    DEFINE VARIABLE hObjectBuffer                   AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hObjectQuery                    AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cMasterObject                   AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cMasterDataType                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cMasterLabel                    AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE lMasterMandatory                AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE dRecordIdentifier               AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE cMandatoryList                  AS CHARACTER            NO-UNDO.
    
    /* Ensure the data logic procedure contains a .p extension */
    IF NUM-ENTRIES(pcLogicProcedureName,".") < 2 THEN
       ASSIGN pcLogicProcedureName = pcLogicProcedureName + ".p":U.

    /* Create Logic Procedure */
    IF pcDataLogicRelativePath = "/":U  OR pcDataLogicRelativePath = "~\":U
    OR pcDataLogicRelativePath = "":U   OR pcDataLogicRelativePath = pcFolderIndicator
    THEN
      ASSIGN
        cRelativelyPathedName = pcLogicProcedureName
        cAbsolutePathedName   = RIGHT-TRIM(pcRootFolder,pcFolderIndicator)
                              + pcFolderIndicator
                              + pcLogicProcedureName
                              .
    ELSE
      ASSIGN
        cRelativelyPathedName = RIGHT-TRIM(pcDataLogicRelativePath,pcFolderIndicator)
                              + pcFolderIndicator
                              + pcLogicProcedureName
        cAbsolutePathedName   = RIGHT-TRIM(pcRootFolder,pcFolderIndicator)
                              + pcFolderIndicator
                              + RIGHT-TRIM(pcDataLogicRelativePath,pcFolderIndicator)
                              + pcFolderIndicator
                              + pcLogicProcedureName
                              .
    IF pcDataObjectRelativePath = "/":U OR pcDataObjectRelativePath = "~\":U
    OR pcDataObjectRelativePath = "":U  OR pcDataObjectRelativePath = pcFolderIndicator
    THEN
      ASSIGN
        cDefinitionIncludeName = (IF INDEX(pcDataObjectName,".w":U) > 0
                                  THEN REPLACE(pcDataObjectName,".w":U,".i":U)
                                  ELSE pcDataObjectName + ".i":U).
    ELSE
      ASSIGN
        cDefinitionIncludeName = RIGHT-TRIM(pcDataObjectRelativePath,pcFolderIndicator)
                               + pcFolderIndicator
                               + (IF INDEX(pcDataObjectName,".w":U) > 0
                                  THEN REPLACE(pcDataObjectName,".w":U,".i":U)
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
       DO iLoop = 1 to NUM-ENTRIES(cTableList):
               cValidationFields = cValidationFields + (IF cValidationFields = "" then "" else CHR(1))
                                      +  getIndexFieldsUnique(ENTRY(iLoop,cTableList)).
       END.        
       ELSE DO:  /* If passing table names and field names */
          DO iLoop = 1 to NUM-ENTRIES(cFieldList,CHR(1)):
             ASSIGN cFieldListEntry = ENTRY(iLoop,cFieldList,CHR(1)) NO-ERROR.
                    cValidateCheck     = getIndexFieldsUnique(ENTRY(iLoop,cTableList)).
             /* IF the pcTableName is being used to pass a list of enabled fields, ensure 
                the index field is contained in this list */
             ASSIGN 
                 cNewValidateCheck = cNewValidateCheck + (IF cNewValidateCheck = "" then "" else CHR(1)).
                 DO iLoop2 = 1 to NUM-ENTRIES(cValidateCheck,CHR(2)) BY 3:
                    IF LOOKUP(ENTRY(iLoop2,cValidateCheck,CHR(2)),cFieldListEntry) > 0 THEN
                       cNewValidateCheck = cNewValidateCheck + (IF cNewValidateCheck = "" then "" else CHR(2))
                                                + ENTRY(iLoop2,cValidateCheck,CHR(2)) +  CHR(2) 
                                                + ENTRY(iLoop2 + 1,cValidateCheck,CHR(2)) + CHR(2) 
                                                + ENTRY(iLoop2 + 2,cValidateCheck,CHR(2))  .
                 END.
          END.
          ASSIGN cValidationFields = cNewValidateCheck.
       END.   
    END.
    
    /* Now derive the mandatoy fields */
    IF CAN-DO(cValidateFrom,"MANDATORY":U) THEN
    DO iLoop = 1 to NUM-ENTRIES(cTableList):
      IF DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                           INPUT ENTRY(iLoop,cTableList),
                           INPUT "", /* Get all Result Codes */
                           INPUT "",  /* RunTime Attributes not applicable in design mode */
                           INPUT YES  /* Design Mode is yes */
                        )  THEN
      DO:                  
         ASSIGN hObjectBuffer  = DYNAMIC-FUNC("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?).
         CREATE QUERY hObjectQuery.
         hObjectQuery:ADD-BUFFER(hObjectBuffer).
         /* Build result code list for DynViewer  master */
         hObjectQuery:QUERY-PREPARE( " FOR EACH " + hObjectBuffer:NAME + " WHERE ":U 
                                                  + hObjectBuffer:NAME +  ".tContainerRecordIdentifier = 0").
         hObjectQuery:QUERY-OPEN().
         hObjectQuery:GET-FIRST().
         ASSIGN cMandatoryList = "".
         DO WHILE hObjectBuffer:AVAILABLE: 
            ASSIGN hAttributeBuffer  = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
                   cMasterObject     = hObjectBuffer:BUFFER-FIELD("tLogicalObjectName"):BUFFER-VALUE  
                   dRecordIdentifier = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE.
            /* Skip if this is the master object */       
            IF cMasterObject =  ENTRY(iLoop,cTableList) THEN
            DO:
               hObjectQuery:GET-NEXT().
               NEXT.
            END.
            /* Strip off the table name */
            ASSIGN cMasterObject    = ENTRY(NUM-ENTRIES(cMasterObject,"."),cMasterObject,".") 
                   lMasterMandatory = FALSE.
            /* Get attribute buffer for the master and it's instances and call function to build it */
            hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = '" 
                                           + STRING(dRecordIdentifier) + "' ":U) NO-ERROR.
            IF hAttributeBuffer:AVAILABLE THEN                               
               ASSIGN cMasterDataType   = hAttributeBuffer:BUFFER-FIELD("DATA-TYPE":U):BUFFER-VALUE
                      cMasterLabel      = hAttributeBuffer:BUFFER-FIELD("LABEL":U):BUFFER-VALUE
                      lMasterMandatory  = hAttributeBuffer:BUFFER-FIELD("Mandatory":U):BUFFER-VALUE.
            
            IF lMasterMandatory THEN 
               IF cFieldList = "" OR (cFieldList  > "" AND LOOKUP(cMasterObject, cFieldList) > 0 )THEN
                   cMandatoryList  = cMandatoryList + (IF cMandatoryList = "" THEN "" ELSE CHR(2))
                                                    + cMasterObject + CHR(2) + cMasterDataType + CHR(2) + cMasterLabel. 
           hObjectQuery:GET-NEXT().
         END.  /* End Do While Available hObjectBuffer */
         hObjectQuery:QUERY-CLOSE().
         DELETE OBJECT hObjectQuery NO-ERROR.
         
      END.   /* End If cacheobjectonClient */
      
      IF cMandatoryList > "" THEN
      DO:
        IF NUM-ENTRIES(cValidationFields,CHR(1)) = NUM-ENTRIES(cTableList) THEN
           ENTRY(iLoop,cValidationFields,CHR(1)) = ENTRY(iLoop,cValidationFields,CHR(1)) 
                                                   + (IF ENTRY(iLoop,cValidationFields,CHR(1)) = "" THEN "" ELSE CHR(2))
                                                   + cMandatoryList.
        ELSE
          cValidationFields = cValidationFields + (IF cValidationFields = "" THEN "" ELSE CHR(1))
                                                   + cMandatoryList.
      END.
    
    END.     /* End DO iLoop per table */ 
    

    /* Run static sdo Data Logic file generator */
    RUN af/app/afgendlogp.p ( INPUT cRelativelyPathedName,
                              INPUT (RIGHT-TRIM(pcRootFolder,pcFolderIndicator) + pcFolderIndicator ),
                              INPUT pcLogicProcedureTemplate,
                              INPUT cTableList,
                              INPUT cFieldList,
                              INPUT cValidationFields,
                              INPUT cDefinitionIncludeName,
                              INPUT plCreateMissingFolder   ,
                              INPUT plSuppressValidation) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
        RETURN ERROR ("Generation of DataLogic Procedure Failed : " + RETURN-VALUE).

    
    /** Compile the objects just created.
     *  ----------------------------------------------------------------------- **/
    /* Make sure that the root folder is in the PROPATH */
    ASSIGN
      cOldPropath = PROPATH.

    ASSIGN
      PROPATH = pcRootFolder + (IF INDEX(PROPATH, ";":U) GT 0 THEN ";":U ELSE ",":U) + PROPATH.

    IF SEARCH(cAbsolutePathedName) EQ ?
    THEN
      RETURN ERROR {aferrortxt.i 'AF' '19' '?' '?' "''" "'logic procedure: ' + cAbsolutePathedName"}.

    COMPILE VALUE(cAbsolutePathedName) SAVE NO-ERROR.
    /* db. Removed return after compile error */ 
    /*
    IF COMPILER:ERROR
    THEN
      RETURN ERROR ("Compiling of DataLogic Procedure Failed : " + ERROR-STATUS:GET-MESSAGE(1)).
    */
    ASSIGN cAbsolutePathedName = REPLACE(cAbsolutePathedName, ".p":U, "_cl.p":U).

    IF SEARCH(cAbsolutePathedName) EQ ?
    THEN
      RETURN ERROR {aferrortxt.i 'AF' '19' '?' '?' "''" "'logic procedure client proxy: ' + cAbsolutePathedName"}.        

    COMPILE VALUE(cAbsolutePathedName) SAVE NO-ERROR.
    /*
    IF COMPILER:ERROR
    THEN
      RETURN ERROR ("Compiling of DataLogic Client Proxy Failed : " + ERROR-STATUS:GET-MESSAGE(1)).
    */
    /* Reset the PROPATH. */
    ASSIGN PROPATH = cOldPropath.

    /* Generate the Logic Procedure Object */
    /* There are currently no attributes for this object. */
    ASSIGN hAttributeBuffer = ?
           hAttributeTable  = ?
           .
                       
    RUN insertObjectMaster ( INPUT  pcLogicProcedureName,
                             INPUT  pcResultCode,                           /* pcResultCode         */
                             INPUT  pcProductModule,                        /* pcProductModuleCode  */
                             INPUT  pcLogicObjectType,                      /* pcObjectTypeCode     */
                             INPUT  "Logic Procedure for ":U 
                                             + ENTRY(1,pcTablename,CHR(1)), /* pcObjectDescription  */
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
                             INPUT  hAttributeBuffer,
                             INPUT  TABLE-HANDLE hAttributeTable,
                             OUTPUT dSmartObjectObj
                             ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U
    THEN RETURN ERROR ("Creation of DataLogic Procedure Failed : " + RETURN-VALUE).

  &ENDIF

  RETURN.

END PROCEDURE.  /* generateDataLogicObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateDataObject Include 
PROCEDURE generateDataObject :
/*------------------------------------------------------------------------------
  Purpose:     Generates SDOs and other dataobjects.
  Parameters:  <none>
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

    /* Moved the code for this API into a separate include due to section editor limits. */
    { ry/app/rydesmngdo.i }.

    RETURN.
END PROCEDURE.  /* generateDataObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateDynamicBrowse Include 
PROCEDURE generateDynamicBrowse :
/*------------------------------------------------------------------------------
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

    /* Not valid yet for browse - but here for future use. */
    IF plDeleteExistingInstances THEN
    DO:
        RUN removeObjectInstance IN TARGET-PROCEDURE ( INPUT pcObjectName,
                                                       INPUT pcResultCode,
                                                       INPUT "":U,          /* pcInstanceObjectName */
                                                       INPUT "":U,          /* pcInstanceName       */
                                                       INPUT pcResultCode   ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
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
       made optional in a future release.  
    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "EnabledFields":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = cNewList
           .
    */

    /* Use Data Object field order to display in Browse */
    IF pcDataObjectFieldSequence EQ "SDO":U AND pcDataObjectFieldList <> "":U THEN
        ASSIGN pcDisplayedFields = pcDataObjectFieldList.
    ASSIGN cNewList = "":U.
    
    /* Get the Entity Key Field to be excluded */
    RUN getDumpName IN gshGenManager (INPUT "|":U + ENTRY(1,pcDisplayedTables),
                                      OUTPUT cEntityName).
    IF cEntityName <> "":U THEN
      cEntityKeyField = DYNAMIC-FUNCTION("getKeyField":U IN gshGenManager,cEntityName).
    /* Only exclude the Entity Key Field by Default if it ends in _obj */
    IF cEntityKeyField <> "":U AND
      NOT cEntityKeyField MATCHES "*_obj":U THEN
      cEntityKeyField = "":U.

    DO iListLoop = 1 TO NUM-ENTRIES(pcDisplayedFields):
      /** Check for the 'IncludeInDefaultView' attribute to see if field should
          be added to browser */
      lIncludeFieldInViewer = TRUE.
      IF pcDataObjectFieldSequence <> "SDO":U THEN DO:
        cDataFieldName = ENTRY(1,pcDisplayedTables) + ".":U + ENTRY(iListLoop, pcDisplayedFields).
        DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                         INPUT cDataFieldName, 
                         INPUT "":U, 
                         INPUT ?, 
                         INPUT YES).
  
        ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?).
  
        IF hObjectBuffer:AVAILABLE THEN
        DO:
            ASSIGN hDataFieldAttributeBuffer = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE.
  
            ASSIGN dInstanceId = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE.
            hDataFieldAttributeBuffer:FIND-FIRST(" WHERE ":U + hDataFieldAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(dInstanceId) ).
            
            hIncludeFieldInListView = hDataFieldAttributeBuffer:BUFFER-FIELD("IncludeInDefaultListView":U) NO-ERROR.
            hIncludeFieldInViewer = hDataFieldAttributeBuffer:BUFFER-FIELD("IncludeInDefaultView":U) NO-ERROR.
            IF hDataFieldAttributeBuffer:AVAILABLE AND
               VALID-HANDLE(hIncludeFieldInListView) AND 
               VALID-HANDLE(hIncludeFieldInViewer) THEN
              lIncludeFieldInViewer = IF hIncludeFieldInListView:BUFFER-VALUE <> ? THEN hIncludeFieldInListView:BUFFER-VALUE ELSE hIncludeFieldInViewer:BUFFER-VALUE.
        END.    /* clean to class */
      END. /* Only when using Entity Fields */
      
      IF lIncludeFieldInViewer AND
         ENTRY(iListLoop, pcDisplayedFields) <> cEntityKeyField THEN
/*        IF NOT ENTRY(iListLoop, pcDisplayedFields) MATCHES "*_obj":U THEN*/
            ASSIGN cNewList = cNewList + (IF NUM-ENTRIES(cNewList) EQ 0 THEN "":U ELSE ",":U)
                            + ENTRY(iListLoop, pcDisplayedFields).
    END.    /* loop list */

    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = "DisplayedFields":U
           ttStoreAttribute.tConstantValue      = NO
           ttStoreAttribute.tCharacterValue     = cNewList.

    ASSIGN hAttributeBuffer = BUFFER ttStoreAttribute:HANDLE
           hAttributeTable  = ?.

    RUN insertObjectMaster IN TARGET-PROCEDURE ( INPUT  pcObjectName,                             /* pcObjectName         */
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
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.    
END PROCEDURE.  /* generateDynamicBrowse */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateDynamicSDF Include 
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

    &IF DEFINED(Server-Side) EQ 0 &THEN
    {
     dynlaunch.i &PLIP              = "'RepositoryDesignManager'"
                 &iProc             = "'generateDynamicSDF'"
                 &compileStaticCall = NO                 
                 &mode1  = INPUT  &parm1  = pcObjectName              &dataType1  = CHARACTER
                 &mode2  = INPUT  &parm2  = pcObjectDescription       &dataType2  = CHARACTER
                 &mode3  = INPUT  &parm3  = pcProductModuleCode       &dataType3  = CHARACTER
                 &mode4  = INPUT  &parm4  = pcResultCode              &dataType4  = CHARACTER
                 &mode5  = INPUT  &parm5  = plDeleteExistingInstances &dataType5  = LOGICAL
                 &mode6  = INPUT  &parm6  = pcSDFType                 &dataType6  = CHARACTER
                 &mode7  = INPUT  &parm7  = pcSuperProcedure          &dataType7  = CHARACTER
                 &mode8  = INPUT  &parm8  = pcAttributeLabels         &dataType8  = CHARACTER
                 &mode9  = INPUT  &parm9  = pcAttributeValues         &dataType9  = CHARACTER
                 &mode10 = INPUT  &parm10 = pcAttributeDataType       &dataType10 = CHARACTER
                 &mode11 = OUTPUT &parm11 = pdSDFObjectObj            &dataType11 = DECIMAL
    }
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
    
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
        WHEN {&DECIMAL-DATA-TYPE}   THEN ttStoreAttribute.tDecimalValue   = DECIMAL(cAttributeValue).
        WHEN {&INTEGER-DATA-TYPE}   THEN ttStoreAttribute.tIntegerValue   = INTEGER(cAttributeValue).
        WHEN {&DATE-DATA-TYPE}      THEN ttStoreAttribute.tDateValue      = DATE(cAttributeValue).
        WHEN {&RAW-DATA-TYPE}       THEN .
        WHEN {&LOGICAL-DATA-TYPE}   THEN ttStoreAttribute.tLogicalValue   = cAttributeValue = "TRUE":U OR cAttributeValue = "YES":U.
        WHEN {&CHARACTER-DATA-TYPE} THEN ttStoreAttribute.tCharacterValue = cAttributeValue.
      END CASE.
    END.


    ASSIGN hAttributeBuffer = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE
           hAttributeTable  = ?
           .
    RUN insertObjectMaster ( INPUT  pcObjectName,                             /* pcObjectName         */
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
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

    /* Not valid yet for browse - but here for future use. */
    IF plDeleteExistingInstances THEN
    DO:
        RUN removeObjectInstance ( INPUT pcObjectName,
                                   INPUT pcResultCode,
                                   INPUT "":U,          /* pcInstanceObjectName */
                                   INPUT "":U,          /* pcInstanceName       */
                                   INPUT pcResultCode   ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    END.    /* delete instances. */    
    &ENDIF
    
    RETURN.
END PROCEDURE.  /* generateDynamicBrowse */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateDynamicViewer Include 
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

    &IF DEFINED(Server-Side) EQ 0 &THEN
    {dynlaunch.i
        &PLIP              = 'RepositoryDesignManager'
        &iProc             = 'generateDynamicViewer'
        &mode1  = INPUT  &parm1  = pcObjectTypeCode           &dataType1  = CHARACTER
        &mode2  = INPUT  &parm2  = pcObjectName               &dataType2  = CHARACTER
        &mode3  = INPUT  &parm3  = pcObjectDescription        &dataType3  = CHARACTER
        &mode4  = INPUT  &parm4  = pcProductModuleCode        &dataType4  = CHARACTER
        &mode5  = INPUT  &parm5  = pcResultCode               &dataType5  = CHARACTER
        &mode6  = INPUT  &parm6  = pcSdoObjectName            &dataType6  = CHARACTER
        &mode7  = INPUT  &parm7  = plDeleteExistingInstances  &dataType7  = LOGICAL
        &mode8  = INPUT  &parm8  = pcDisplayedDatabases       &dataType8  = CHARACTER
        &mode9  = INPUT  &parm9  = pcEnabledDatabases         &dataType9  = CHARACTER
        &mode10 = INPUT  &parm10 = pcDisplayedTables          &dataType10 = CHARACTER
        &mode11 = INPUT  &parm11 = pcEnabledTables            &dataType11 = CHARACTER
        &mode12 = INPUT  &parm12 = pcDisplayedFields          &dataType12 = CHARACTER
        &mode13 = INPUT  &parm13 = pcEnabledFields            &dataType13 = CHARACTER
        &mode14 = INPUT  &parm14 = piMaxFieldsPerColumn       &dataType14 = INTEGER
        &mode15 = INPUT  &parm15 = pcDataObjectFieldSequence  &dataType15 = CHARACTER
        &mode16 = INPUT  &parm16 = pcDataObjectFieldList      &dataType16 = CHARACTER
        &mode17 = OUTPUT &parm17 = pdVisualObjectObj          &dataType17 = DECIMAL
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
    /** Code moved into a separate include because of section editor limits.
     *  ----------------------------------------------------------------------- **/
    {ry/app/rydesmngdv.i}
    &ENDIF
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generateDynamicViewer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateEntityInstances Include 
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
    
    &IF DEFINED(Server-Side) EQ 0 &THEN
    {dynlaunch.i
        &PLIP  = 'RepositoryDesignManager'
        &iProc = 'generateEntityInstances'
        
        &mode1  = INPUT  &parm1  = pcEntityObjectName            &dataType1  = CHARACTER
        &mode2  = INPUT  &parm2  = pcFieldList                 &dataType2  = CHARACTER
        &mode3  = INPUT  &parm3  = plDeleteExistingInstances   &dataType3  = LOGICAL
    }
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
    DEFINE VARIABLE hStoreAttributeBuffer           AS HANDLE                           NO-UNDO.
    DEFINE VARIABLE hStoreAttributeTable            AS HANDLE                           NO-UNDO.
    DEFINE VARIABLE dEntityObjectObj                AS DECIMAL                          NO-UNDO.
    DEFINE VARIABLE dInstanceSmartObjectObj         AS DECIMAL                          NO-UNDO.
    DEFINE VARIABLE dObjectInstanceObj              AS DECIMAL                          NO-UNDO.
    DEFINE VARIABLE iInstanceOrder                  AS INTEGER                          NO-UNDO.
    DEFINE VARIABLE iOrderOffset                    AS INTEGER                          NO-UNDO.
    DEFINE VARIABLE cFieldName                      AS CHARACTER                        NO-UNDO.

    DEFINE BUFFER ryc_object_instance   FOR ryc_object_instance.

    /* Get the OBJ ID of the Entity object.
     * This also serves as a check for the existence
     * of the Entity object.                            */
    ASSIGN dEntityObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN TARGET-PROCEDURE,
                                               INPUT pcEntityObjectName, INPUT 0           ).
    IF dEntityObjectObj EQ 0 THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' '"Entity object"' "'Entity name: ' + pcEntityObjectName" }.
    
    /* If required, first remove all contained instances. */
    IF plDeleteExistingInstances THEN
    DO:
        ASSIGN iOrderOffset = 0.
        RUN removeObjectInstance IN TARGET-PROCEDURE ( INPUT pcEntityObjectName,              /* Container object name */
                                                       INPUT "{&DEFAULT-RESULT-CODE}":U,
                                                       INPUT "":U,                          /* pcInstanceObjectName */
                                                       INPUT "":U,                          /* pcInstanceName       */
                                                       INPUT "{&DEFAULT-RESULT-CODE}":U   ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    END.    /* delete instances. */       
    ELSE
    DO:
        /* Find the largest existing instance order (aka layout_position) */
        FOR EACH ryc_object_instance WHERE
                 ryc_object_instance.container_smartObject_obj = dEntityObjectObj
                 NO-LOCK
                 BY ryc_object_instance.layout_position DESCENDING:
            ASSIGN iOrderOffset = INTEGER(ryc_object_instance.layout_position) NO-ERROR.
            /* Find the largest layout position where there is a numeric integer value. */
            IF NOT ERROR-STATUS:ERROR THEN
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
        ASSIGN cFieldName = ENTRY(iInstanceOrder, pcFieldList, CHR(3)).
        RUN insertObjectInstance IN TARGET-PROCEDURE ( INPUT  dEntityObjectObj,                         /* pdContainerObjectObj               */
                                                       INPUT  cFieldName,                               /* Contained Instance Object Name     */
                                                       INPUT  "{&DEFAULT-RESULT-CODE}":U,               /* pcResultCode,                      */
                                                       /* We just want the field name porting for the instance naem, not the table portion. */
                                                       INPUT  ENTRY(NUM-ENTRIES(cFieldName, ".":U), cFieldName, ".":U),
                                                       INPUT  "":U,                                     /* pcInstanceDescription,             */
                                                       INPUT  STRING(iOrderOffset + iInstanceOrder, "999":U), /* pcLayoutPosition,            */
                                                       INPUT  NO,                                       /* plForceCreateNew,                  */
                                                       INPUT  hStoreAttributeBuffer,                    /* phAttributeValueBuffer,            */
                                                       INPUT  TABLE-HANDLE hStoreAttributeTable,        /* TABLE-HANDLE phAttributeValueTable */
                                                       OUTPUT dInstanceSmartObjectObj,                  /* pdSmartObjectObj,                  */
                                                       OUTPUT dObjectInstanceObj            ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    END.    /* Loop through fields. */
    &ENDIF
             
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generateEntityInstances */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateEntityObject Include 
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

    &IF DEFINED(Server-Side) EQ 0 &THEN
    {dynlaunch.i &PLIP  = 'RepositoryDesignManager'
                 &iProc = 'generateEntityObject'                 
                 &mode1  = INPUT  &parm1  = pcTableNames            &dataType1  = CHARACTER
                 &mode2  = INPUT  &parm2  = pcEntityObjectType      &dataType2  = CHARACTER
                 &mode3  = INPUT  &parm3  = pcEntityProductModule   &dataType3  = CHARACTER
                 &mode4  = INPUT  &parm4  = plAutoProPerform        &dataType4  = LOGICAL
                 &mode5  = INPUT  &parm5  = piPrefixLength          &dataType5  = INTEGER
                 &mode6  = INPUT  &parm6  = pcSeparator             &dataType6  = CHARACTER
                 &mode7  = INPUT  &parm7  = pcAuditingEnabled       &dataType7  = CHARACTER
                 &mode8  = INPUT  &parm8  = pcDescFieldQualifiers   &dataType8  = CHARACTER
                 &mode9  = INPUT  &parm9  = pcKeyFieldQualifiers    &dataType9  = CHARACTER
                 &mode10 = INPUT  &parm10 = pcObjFieldQualifiers    &dataType10 = CHARACTER
                 &mode11 = INPUT  &parm11 = plDeployData            &dataType11 = LOGICAL
                 &mode12 = INPUT  &parm12 = plVersionData           &dataType12 = LOGICAL
                 &mode13 = INPUT  &parm13 = plReuseDeletedKeys      &dataType13 = LOGICAL
                 &mode14 = INPUT  &parm14 = plAssociateDataFields   &dataType14 = LOGICAL
    }
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.    
    &ELSE
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
        ASSIGN hQuery = DYNAMIC-FUNCTION("getSchemaQueryHandle":U IN TARGET-PROCEDURE,
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
                    RUN insertObjectMaster IN TARGET-PROCEDURE ( INPUT  gsc_entity_mnemonic.entity_mnemonic_description,
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

                        RUN generateEntityInstances IN TARGET-PROCEDURE ( INPUT gsc_entity_mnemonic.entity_mnemonic_description,
                                                                          INPUT cAllFields,
                                                                          INPUT YES             ) NO-ERROR.
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
    &ENDIF
      
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generateEntityObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateSBODataLogicObject Include 
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

  &IF DEFINED(Server-Side) EQ 0 &THEN
    {dynlaunch.i &PLIP              = "'RepositoryDesignManager'"
                 &iProc             = "'generateSBODataLogicObject'"
                 &compileStaticCall = NO                 
                 &mode1  = INPUT  &parm1  = pcDatabaseName           &dataType1  = CHARACTER
                 &mode2  = INPUT  &parm2  = pcTableList              &dataType2  = CHARACTER
                 &mode3  = INPUT  &parm3  = pcDumpName               &dataType3  = CHARACTER
                 &mode4  = INPUT  &parm4  = pcDataObjectName         &dataType4  = CHARACTER
                 &mode5  = INPUT  &parm5  = pcProductModule          &dataType5  = CHARACTER
                 &mode6  = INPUT  &parm6  = pcResultCode             &dataType6  = CHARACTER               
                 &mode7  = INPUT  &parm7  = pcLogicProcedureName     &dataType7  = CHARACTER
                 &mode8  = INPUT  &parm8  = pcLogicObjectType        &dataType8  = CHARACTER
                 &mode9  = INPUT  &parm9  = pcLogicProcedureTemplate &dataType9  = CHARACTER
                 &mode10 = INPUT  &parm10 = pcDataLogicRelativePath  &dataType10 = CHARACTER
                 &mode11 = INPUT  &parm11 = pcRootFolder             &dataType11 = CHARACTER
                 &mode12 = INPUT  &parm12 = pcIncludeFileList        &dataType12 = CHARACTER
                 &mode13 = INPUT  &parm13 = plCreateMissingFolder    &dataType13 = LOGICAL                
    }
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
  &ELSE
    DEFINE VARIABLE cAbsolutePathedName     AS CHARACTER  NO-UNDO.
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
           cRelativePathedName      = RIGHT-TRIM(pcDataLogicRelativePath,"/":U)
                                                 + "/":U 
                                                 + pcLogicProcedureName
           cAbsolutePathedName      = pcRootFolder 
                                                 + "/":U
                                                 +  cRelativePathedName
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
    ASSIGN cOldPropath = PROPATH.

    ASSIGN PROPATH = pcRootFolder + (IF INDEX(PROPATH, ";":U) GT 0 THEN ";":U ELSE ",":U) + PROPATH.

    IF SEARCH(cAbsolutePathedName) EQ ?
    THEN
      RETURN ERROR {aferrortxt.i 'AF' '19' '?' '?' "''" "'logic procedure: ' + cAbsolutePathedName"}.

    COMPILE VALUE(cAbsolutePathedName) SAVE NO-ERROR.
    ASSIGN cAbsolutePathedName = REPLACE(cAbsolutePathedName, ".p":U, "_cl.p":U).

    IF SEARCH(cAbsolutePathedName) EQ ?
    THEN
      RETURN ERROR {aferrortxt.i 'AF' '19' '?' '?' "''" "'logic procedure client proxy: ' + cAbsolutePathedName"}.        

    COMPILE VALUE(cAbsolutePathedName) SAVE NO-ERROR.
    
    /* Reset the PROPATH. */
    ASSIGN PROPATH = cOldPropath.

    /* Generate the Logic Procedure Object */
    /* There are currently no attributes for this object. */
    RUN insertObjectMaster ( INPUT  pcLogicProcedureName,
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
                             OUTPUT dSmartObjectObj
                             ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN 
       RETURN ERROR ("Creation of DataLogic Procedure Failed : " + RETURN-VALUE).

  &ENDIF

  RETURN.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateSDOInstances Include 
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

    DEFINE VARIABLE hObjectBuffer               AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer            AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hObjectQuery                AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE dSdoObjectObj               AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dInstanceSmartObjectObj     AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dObjectInstanceObj          AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dRecordIdentifier           AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE cUpdatableColumns           AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cDatabaseNames              AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cTableNames                 AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cTableColumns               AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cAllColumns                 AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cColumn                     AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cTable                      AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE hStoreAttributeBuffer       AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hStoreAttributeTable        AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE iFieldLoop                  AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iTableLoop                  AS INTEGER                  NO-UNDO.

    IF plDeleteExistingInstances THEN
    DO:
        RUN removeObjectInstance ( INPUT pcSdoObjectName,
                                   INPUT pcResultCode,
                                   INPUT "":U,          /* pcInstanceObjectName */
                                   INPUT "":U,          /* pcInstanceName       */
                                   INPUT pcResultCode   ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    END.    /* delete existing instances. */

    DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                     INPUT pcSdoObjectName, INPUT pcResultCode, INPUT ?, INPUT NO ).

    ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?).
    IF NOT hObjectBuffer:AVAILABLE THEN
        RETURN ERROR {aferrortxt.i 'AF' '15' '?' '?' "'the DataObject ' + pcSdoObjectName + ' could not be found.'" }.

    /* Get the list of all SDO fields, tables and databases */
    ASSIGN dSdoObjectObj     = hObjectBuffer:BUFFER-FIELD("tSmartObjectObj":U):BUFFER-VALUE
           hAttributeBuffer  = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
           dRecordIdentifier = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
           .
    hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = " + QUOTER(dRecordIdentifier) ) NO-ERROR.

    ASSIGN cAllColumns       = hAttributeBuffer:BUFFER-FIELD("DataColumnsByTable":U):BUFFER-VALUE
           cUpdatableColumns = hAttributeBuffer:BUFFER-FIELD("UpdatableColumns":U):BUFFER-VALUE
           cTableNames       = hAttributeBuffer:BUFFER-FIELD("Tables":U):BUFFER-VALUE
           cDatabaseNames    = hAttributeBuffer:BUFFER-FIELD("DbNames":U):BUFFER-VALUE
           NO-ERROR.
    IF cTableNames = "":U THEN
      cTableNames = pcTableList.

    RUN clearClientCache IN gshRepositoryManager.
    /* I needed to only add the main table's field's as instances
       since any joined table might have the same fields and this
       is renamed and will thus fail here since the name of the 
       field is now different from table.fieldName  */
    DO iTableLoop = 1 TO 1: /* NUM-ENTRIES(cTableNames): Mark Davies (MIP) 27/07/2002 */
        ASSIGN cTableColumns = ENTRY(iTableLoop, cAllColumns, ";":U).

        DO iFieldLoop = 1 TO NUM-ENTRIES(cTableColumns):
            ASSIGN cColumn = ENTRY(iFieldLoop, cTableColumns)
                   cTable  = ENTRY(iTableLoop, cTableNames)
                   .
            /* Strip off the DB qualifier, if any */
            IF NUM-ENTRIES(cTable, ".":U) EQ 2  THEN
                ASSIGN cTable = ENTRY(2, cTable, ".":U).

            EMPTY TEMP-TABLE ttStoreAttribute.

            CREATE ttStoreAttribute.
            ASSIGN ttStoreAttribute.tAttributeParent    = "INSTANCE":U
                   ttStoreAttribute.tAttributeParentObj = 0
                   ttStoreAttribute.tAttributeLabel     = "Enabled":U
                   ttStoreAttribute.tConstantValue      = NO
                   ttStoreAttribute.tLogicalValue       = CAN-DO(cUpdatableColumns, cColumn)
                   .
            ASSIGN hStoreAttributeBuffer = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE
                   hStoreAttributeTable  = ?
                   .
            RUN insertObjectInstance ( INPUT  dSdoObjectObj,                            /* pdContainerObjectObj               */
                                       INPUT  (cTable + ".":U + cColumn),               /* Contained Instance Object Name     */
                                       INPUT  pcResultCode,                             /* pcResultCode,                      */
                                       INPUT  (cTable + ".":U + cColumn),               /* pcInstanceName                     */
                                       INPUT  "":U,                                     /* pcInstanceDescription,             */
                                       INPUT  "":U,                                     /* pcLayoutPosition,                  */
                                       INPUT  NO,                                       /* plForceCreateNew,                  */
                                       INPUT  hStoreAttributeBuffer,                    /* phAttributeValueBuffer,            */
                                       INPUT  TABLE-HANDLE hStoreAttributeTable,        /* TABLE-HANDLE phAttributeValueTable */
                                       OUTPUT dInstanceSmartObjectObj,                  /* pdSmartObjectObj,                  */
                                       OUTPUT dObjectInstanceObj            ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
        END.    /* loop through fields */
    END.    /* loop through tables */

    RETURN.
END PROCEDURE.  /* generateSDOInstances */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateVisualObject Include 
PROCEDURE generateVisualObject :
/*------------------------------------------------------------------------------
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

    &IF DEFINED(Server-Side) EQ 0 &THEN
    {dynlaunch.i
        &PLIP              = 'RepositoryDesignManager'
        &iProc             = 'generateVisualObject'
        &mode1  = INPUT  &parm1  = pcObjectType              &dataType1  = CHARACTER
        &mode2  = INPUT  &parm2  = pcObjectName              &dataType2  = CHARACTER
        &mode3  = INPUT  &parm3  = pcProductModuleCode       &dataType3  = CHARACTER
        &mode4  = INPUT  &parm4  = pcResultCode              &dataType4  = CHARACTER
        &mode5  = INPUT  &parm5  = pcSdoObjectName           &dataType5  = CHARACTER
        &mode6  = INPUT  &parm6  = pcTableName               &dataType6  = CHARACTER
        &mode7  = INPUT  &parm7  = pcDataBaseName            &dataType7  = CHARACTER
        &mode8  = INPUT  &parm8  = piMaxObjectFields         &dataType8  = INTEGER
        &mode9  = INPUT  &parm9  = piMaxFieldsPerColumn      &dataType9  = INTEGER
        &mode10 = INPUT  &parm10 = plGenerateFromDataObject  &dataType10 = LOGICAL
        &mode11 = INPUT  &parm11 = pcDataObjectFieldList     &dataType11 = CHARACTER
        &mode12 = INPUT  &parm12 = plDeleteExistingInstances &dataType12 = LOGICAL
        &mode13 = INPUT  &parm13 = pcDataObjectFieldSequence &dataType13 = CHARACTER
        &mode14 = INPUT  &parm14 = plUseSDOFieldOrder        &dataType14 = LOGICAL
        &mode15 = OUTPUT &parm15 = pdVisualObjectObj         &dataType15 = DECIMAL
    }
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
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

    IF plGenerateFromDataObject EQ ? THEN
        ASSIGN plGenerateFromDataObject = FALSE.
    IF plUseSDOFieldOrder EQ ? THEN
        ASSIGN plUseSDOFieldOrder = FALSE.

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

    ASSIGN dSdoObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U, INPUT pcSdoObjectName, INPUT dCustomisationResultObj).
    IF dSdoObjectObj EQ 0 THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'SDO Object'" pcSdoObjectName}.

    ASSIGN iFieldCount = 0.

    /* Use fields in SDO */
    IF plGenerateFromDataObject THEN
    DO:
        RUN startDataObject IN gshRepositoryManager ( INPUT pcSdoObjectName, OUTPUT hSdo).

        {get DataColumnsByTable cAllColumns hSdo}.
        {get UpdatableColumnsByTable cUpdatableColumns hSdo}.
        {get Tables cTableNames hSdo}.
        {get DbNames cDatabaseNames hSdo}.

        /* Shut the running SDO down. */
        RUN deleteObject IN hSdo NO-ERROR.
        ASSIGN hSdo = ?.

        ASSIGN cUpdatableColumns = REPLACE(cUpdatableColumns,";":U,",":U) 
               cUpdatableColumns = REPLACE(cUpdatableColumns,CHR(1),",":U) .

        BLKUseSDOFields:
        DO iTableLoop = 1 TO NUM-ENTRIES(cTableNames):
            ASSIGN cTableColumns = ENTRY(iTableLoop, cAllColumns, CHR(1)).
            
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
                    ASSIGN cDatabase = DYNAMIC-FUNCTION("getBufferDbName":U IN TARGET-PROCEDURE, INPUT pcTableName).

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
    ELSE
    DO:
        ASSIGN cDisplayedTables    = pcTableName
               cDisplayedDatabases = pcDatabaseName.

        DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                         INPUT pcTableName, INPUT "{&DEFAULT-RESULT-CODE}":U, INPUT ?, INPUT NO).
        /* Get the handle of the Entity object */
        ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?).

        IF hObjectBuffer:AVAILABLE THEN
        DO:
            ASSIGN dEntityInstanceId = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE.

            IF NOT VALID-HANDLE(ghQuery2) THEN
                CREATE QUERY ghQuery2.

            ghQuery2:SET-BUFFERS(hObjectBuffer).
            ghQuery2:QUERY-PREPARE(" FOR EACH ":U + hObjectBuffer:NAME + " WHERE ":U
                                   + hObjectBuffer:NAME + ".tContainerRecordIdentifier = ":U + QUOTER(dEntityInstanceId)
                                   + " BY ":U + hObjectBuffer:NAME + ".tInstanceOrder ":U                                ).
            ghQuery2:QUERY-OPEN().

            ghQuery2:GET-FIRST().
            DO WHILE hObjectBuffer:AVAILABLE:
                IF iFieldCount EQ piMaxObjectFields THEN
                    LEAVE.

                ASSIGN cDisplayedFields = cDisplayedFields + hObjectBuffer:BUFFER-FIELD("tObjectInstanceName":U):BUFFER-VALUE + ",":U
                       iFieldCount      = iFieldCount      + 1.

                ghQuery2:GET-NEXT().
            END.    /* available buffer */
            ghQuery2:QUERY-CLOSE().
        END.    /* available Entity object */
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
        RETURN ERROR {aferrortxt.i 'RY' '13' '?' '?' 'pcObjectType' "'the DynBrow or DynView class'"}.

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

    RUN VALUE(cProcedureName) IN TARGET-PROCEDURE ( INPUT  pcObjectType,
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
    &ENDIF
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generateVisualObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTableJoins Include 
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

  getFuncLibHandle().
  
  &IF DEFINED(server-side) <> 0 &THEN
  
  DEFINE VARIABLE iFollow           AS INTEGER        NO-UNDO.
  DEFINE VARIABLE iLoop             AS INTEGER        NO-UNDO.
  DEFINE VARIABLE cQuery            AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE cDescField        AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE cAllFields        AS CHARACTER      NO-UNDO.
                                    
  DEFINE VARIABLE hbmFile           AS WIDGET-HANDLE  NO-UNDO.
  DEFINE VARIABLE hbxField          AS WIDGET-HANDLE  NO-UNDO.
  DEFINE VARIABLE hbxFile           AS WIDGET-HANDLE  NO-UNDO.
  DEFINE VARIABLE hIndex            AS WIDGET-HANDLE  NO-UNDO.
  DEFINE VARIABLE hFile             AS WIDGET-HANDLE  NO-UNDO.
  DEFINE VARIABLE hIndexField       AS WIDGET-HANDLE  NO-UNDO.
  DEFINE VARIABLE hField            AS WIDGET-HANDLE  NO-UNDO.
  DEFINE VARIABLE httRelate         AS WIDGET-HANDLE  NO-UNDO.
  
  DEFINE VARIABLE hMainQuery        AS HANDLE         NO-UNDO.
  DEFINE VARIABLE hIndexQuery       AS HANDLE         NO-UNDO.
  DEFINE VARIABLE hbxFieldQuery     AS HANDLE         NO-UNDO.
  DEFINE VARIABLE hRelateQuery      AS HANDLE         NO-UNDO.
  DEFINE VARIABLE hEntityTable      AS HANDLE         NO-UNDO.
  DEFINE VARIABLE hEntityFieldTable AS HANDLE         NO-UNDO.
  DEFINE VARIABLE hFieldQuery       AS HANDLE         NO-UNDO.

  CREATE BUFFER hbmFile     FOR TABLE (pcDataBaseName + "._File")  BUFFER-NAME "bmFile".
  CREATE BUFFER hbxField    FOR TABLE (pcDataBaseName + "._Field") BUFFER-NAME "bxField".
  CREATE BUFFER hbxFile     FOR TABLE (pcDataBaseName + "._File")  BUFFER-NAME "bxFile".
                            
  CREATE BUFFER hIndex      FOR TABLE (pcDataBaseName + "._Index").
  CREATE BUFFER hFile       FOR TABLE (pcDataBaseName + "._File").
  CREATE BUFFER hIndexField FOR TABLE (pcDataBaseName + "._Index-Field").
  CREATE BUFFER hField      FOR TABLE (pcDataBaseName + "._Field").
  
  CREATE BUFFER httRelate   FOR TABLE ("ttRelate").
  
  EMPTY TEMP-TABLE ttRelate.
  
  CREATE QUERY hMainQuery.
  hMainQuery:SET-BUFFERS(hbmFile).
  hMainQuery:QUERY-PREPARE("FOR EACH bmFile WHERE bmFile._File-name = '" + pcTableName + "'").
  hMainQuery:QUERY-OPEN().
  
  hMainQuery:GET-FIRST(NO-LOCK).
  MAIN_BLOCK:
  DO WHILE hbmFile:AVAILABLE:
    
    IF INTEGER(DBVERSION(pcDataBaseName)) > 8 AND
      (TRIM(hbmFile:BUFFER-FIELD("_Owner":U):BUFFER-VALUE) <> "PUB" AND 
       TRIM(hbmFile:BUFFER-FIELD("_Owner":U):BUFFER-VALUE) <> "_FOREIGN") THEN
      LEAVE MAIN_BLOCK.  
    CREATE QUERY hIndexQuery.
    
    hIndexQuery:SET-BUFFERS(hIndex,hFile,hIndexField,hField).
    hIndexQuery:QUERY-PREPARE("FOR EACH  " + pcDataBaseName + "._Index " +
                              "    WHERE " + pcDataBaseName + "._Index._Unique, " +
                              "    EACH  " + pcDataBaseName + "._File OF " + pcDataBaseName + "._Index " +
                              "    WHERE " + pcDataBaseName + "._File._File-number > 0," +
                              "    EACH  " + pcDataBaseName + "._Index-Field OF " + pcDataBaseName + "._Index," +
                              "    EACH  " + pcDataBaseName + "._Field OF " + pcDataBaseName + "._Index-Field").
    hIndexQuery:QUERY-OPEN().
  
    hIndexQuery:GET-FIRST(NO-LOCK).
    DO WHILE hIndex:AVAILABLE:
      IF hIndexField:BUFFER-FIELD("_Index-seq":U):BUFFER-VALUE = 1 THEN DO:
        
        CREATE QUERY hbxFieldQuery.
        hbxFieldQuery:SET-BUFFERS(hbxField,hbxFile).
        hbxFieldQuery:QUERY-PREPARE("FOR EACH  " + pcDataBaseName + ".bxField " +
                                    "    WHERE " + pcDataBaseName + ".bxField._Field-Name = '" + TRIM(hField:BUFFER-FIELD("_Field-Name":U):STRING-VALUE) + "'" +
                                    "    AND   ROWID(" + pcDataBaseName + ".bxField) <> TO-ROWID('" + STRING(hField:ROWID) + "'), " +
                                    "    EACH  " + pcDataBaseName + ".bxFile OF " + pcDataBaseName + ".bxField").
        hbxFieldQuery:QUERY-OPEN().
  
        hbxFieldQuery:GET-FIRST(NO-LOCK).
        DO WHILE hbxField:AVAILABLE:
          IF hbmFile:BUFFER-FIELD("_File-Name":U):BUFFER-VALUE <> hFile:BUFFER-FIELD("_File-Name":U):BUFFER-VALUE AND 
             hbmFile:BUFFER-FIELD("_File-Name":U):BUFFER-VALUE <> hbxFile:BUFFER-FIELD("_File-Name":U):BUFFER-VALUE THEN DO:
            hbxFieldQuery:GET-NEXT(NO-LOCK).
            NEXT.
          END.
          
          CREATE ttRelate.
          ASSIGN
            ttRelate.cOwnerTable   = hbxFile:BUFFER-FIELD("_File-Name":U):BUFFER-VALUE
            ttRelate.cDataBaseName = pcDataBaseName
            ttRelate.cRelatedTable = hFile:BUFFER-FIELD("_File-Name":U):BUFFER-VALUE
            ttRelate.cIndexName    = hIndex:BUFFER-FIELD("_Index-name":U):BUFFER-VALUE.
          hbxFieldQuery:GET-NEXT(NO-LOCK).
        END.
        hbxFieldQuery:QUERY-CLOSE().
        
        /* Destroy Query */
        DELETE OBJECT hbxFieldQuery NO-ERROR.
        ASSIGN hbxFieldQuery = ?.
        
      END.
      ELSE DO:
        CREATE QUERY hRelateQuery.
        hRelateQuery:SET-BUFFERS(httRelate,hbxFile).
        hRelateQuery:QUERY-PREPARE("FOR EACH  ttRelate " +
                                    "    WHERE ttRelate.cIndexName    = '" + hIndex:BUFFER-FIELD("_Index-Name":U):BUFFER-VALUE + "' " + 
                                    "    AND   ttRelate.cRelatedTable = '" + hFile:BUFFER-FIELD("_File-Name":U):BUFFER-VALUE + "', " + 
                                    "    EACH  " + pcDataBaseName + ".bxFile " +
                                    "    WHERE " + pcDataBaseName + ".bxFile._File-Name = ttRelate.cOwnerTable").
        hRelateQuery:QUERY-OPEN().
  
        hRelateQuery:GET-FIRST(NO-LOCK).
        DO WHILE httRelate:AVAILABLE:
          hbxField:FIND-FIRST("WHERE STRING(bxField._File-Recid) = '" + STRING(hbxFile:RECID) + "' AND bxField._Field-name = '" + hField:BUFFER-FIELD("_Field-Name":U):BUFFER-VALUE + "'",NO-LOCK) NO-ERROR.
          IF NOT hbxField:AVAILABLE THEN DO:
            httRelate:BUFFER-DELETE().
          END.
          hRelateQuery:GET-NEXT(NO-LOCK).
        END.                                                       
        hRelateQuery:QUERY-CLOSE().
        
        /* Destroy Query */
        DELETE OBJECT hRelateQuery NO-ERROR.
        ASSIGN hRelateQuery = ?.
      END.
      hIndexQuery:GET-NEXT(NO-LOCK).
    END. /* Index Query */
  
  
    hIndexQuery:QUERY-CLOSE().
    
    /* Destroy Query */
    DELETE OBJECT hIndexQuery NO-ERROR.
    ASSIGN hIndexQuery = ?.
  
    hMainQuery:GET-NEXT(NO-LOCK).
  END. /* Main Query */
  
  hMainQuery:QUERY-CLOSE().
  
  /* Destroy Query */
  DELETE OBJECT hMainQuery NO-ERROR.
  ASSIGN hMainQuery = ?.
  
  FOR EACH ttRelate EXCLUSIVE-LOCK 
      WHERE ttRelate.cOwnerTable = pcTableName 
         BY ttRelate.cOwnerTable:

    hbxFile:FIND-FIRST("WHERE bxFile._File-name = '" + ttRelate.cRelatedTable 
                       + IF DBVERSION(pcDatabaseName) <> '8'
                         THEN "' AND (bxFile._Owner = 'PUB' OR bxFile._Owner = '_FOREIGN')"
                         ELSE '', 
                       NO-LOCK) NO-ERROR.
    IF hbxFile:AVAILABLE THEN DO:
      hIndex:FIND-FIRST("WHERE STRING(" + pcDataBaseName + "._Index._File-Recid) = '" + STRING(hbxFile:RECID) + "' AND " + pcDataBaseName + "._Index._Index-Name = '" + ttRelate.cIndexName + "'",NO-LOCK) NO-ERROR.
      IF hIndex:AVAILABLE THEN DO:
        CREATE QUERY hIndexQuery.
  
        hIndexQuery:SET-BUFFERS(hIndexField,hField).
        hIndexQuery:QUERY-PREPARE("FOR EACH  " + pcDataBaseName + "._Index-Field " +
                                  "    WHERE STRING(" + pcDataBaseName + "._Index-Field._Index-Recid) = '" + STRING(hIndex:RECID) + "', " + 
                                  "    EACH  " + pcDataBaseName + "._Field OF " + pcDataBaseName + "._Index-Field").
        hIndexQuery:QUERY-OPEN().
  
        hIndexQuery:GET-FIRST(NO-LOCK).
        DO WHILE hIndexField:AVAILABLE:
          ASSIGN ttRelate.cLinkFieldName = IF ttRelate.cLinkFieldName = "":U 
                                            THEN hField:BUFFER-FIELD("_Field-name":U):BUFFER-VALUE
                                            ELSE ttRelate.cLinkFieldName + ",":U + hField:BUFFER-FIELD("_Field-name":U):BUFFER-VALUE.
          hIndexQuery:GET-NEXT(NO-LOCK).
        END.
        hIndexQuery:QUERY-CLOSE().
  
        /* Destroy Query */
        DELETE OBJECT hIndexQuery NO-ERROR.
        ASSIGN hIndexQuery = ?.
      END.
    END.
  END.
  
  /* Destroy Buffers */
  DELETE OBJECT hbmFile NO-ERROR.
  ASSIGN hbmFile = ?.
  
  DELETE OBJECT hbxField NO-ERROR.
  ASSIGN hbxField = ?.
      
  DELETE OBJECT hbxFile NO-ERROR.
  ASSIGN hbxFile = ?.
  
  DELETE OBJECT hIndex NO-ERROR.
  ASSIGN hIndex = ?.
  
  DELETE OBJECT hFile NO-ERROR.
  ASSIGN hFile = ?.
  
  DELETE OBJECT hIndexField NO-ERROR.
  ASSIGN hIndexField = ?.
  
  DELETE OBJECT hField NO-ERROR.
  ASSIGN hField = ?.
  
  DELETE OBJECT httRelate:TABLE-HANDLE NO-ERROR.
  ASSIGN httRelate = ?.
  
  /* Get rid of unqualified records */
  FOR EACH  ttRelate
      WHERE ttRelate.cOwnerTable   <> pcTableName
      OR    ttRelate.cLinkFieldName = "":U:
    DELETE ttRelate.
  END.
  
  /* We need to ensure that the Table Entity exists as an object before we 
     can add a join to it */
  RELATED_TABLES:
  FOR EACH ttRelate EXCLUSIVE-LOCK:
    IF NOT DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                             INPUT ttRelate.cRelatedTable,
                             INPUT "", /* Get all Result Codes */
                             INPUT "",  /* RunTime Attributes not applicable in design mode */
                             INPUT YES  /* Design Mode is NO to not disturb cache */
                        )  THEN DO:
      DELETE ttRelate.
      NEXT RELATED_TABLES.
    END.
  END.

  /* Look for Duplicate foreign keys e.g. warehouse_num and warehouse_obj */
  FOR EACH ttRelate EXCLUSIVE-LOCK:
    
    /* Get the handle to the Entiy Table */
    hEntityTable = DYNAMIC-FUNCTION("getEntityCacheBuffer" IN gshGenManager, INPUT "",INPUT ttRelate.cRelatedTable).
    hEntityFieldTable = DYNAMIC-FUNCTION("getEntityFieldCacheBuffer" IN gshGenManager, INPUT "",INPUT ttRelate.cRelatedTable).
    FIND FIRST bttRelate
         WHERE ROWID(bttRelate) <> ROWID(ttRelate)
         AND   bttRelate.cRelatedTable = ttRelate.cRelatedTable
         EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE bttRelate THEN DO:
      /* We want to keep an _obj field */
      IF SUBSTRING(bttRelate.cLinkFieldName,LENGTH(bttRelate.cLinkFieldName) - 3,4) <> "_obj":U AND
         SUBSTRING(ttRelate.cLinkFieldName,LENGTH(ttRelate.cLinkFieldName) - 3,4) <> "_obj":U THEN /* No Obj field here */
        DELETE bttRelate.
      ELSE DO:
        IF SUBSTRING(bttRelate.cLinkFieldName,LENGTH(bttRelate.cLinkFieldName) - 3,4) <> "_obj":U THEN
          DELETE bttRelate.
        ELSE
          DELETE ttRelate.
      END.
    END.
  END.
  
  ASSIGN pcAddOnQuery    = "":U
         pcDisplayFields = "":U
         pcAddedTables   = "":U
         iFollow         = 0.
  FOR EACH  ttRelate:
    IF INDEX(pcAddedTables,ttRelate.cRelatedTable) = 0 THEN
      iFollow = iFollow + 1.
    ELSE
      NEXT.
    IF iFollow > piFollowDepth AND piFollowDepth <> 0 THEN
      LEAVE.
    cQuery = "FIRST " + (IF VALID-HANDLE(gFuncLibHdl) THEN db-tbl-name(ttRelate.cDataBaseName + ".":U + ttRelate.cRelatedTable) ELSE ttRelate.cRelatedTable) + " NO-LOCK WHERE " + (IF VALID-HANDLE(gFuncLibHdl) THEN db-tbl-name(ttRelate.cDataBaseName + ".":U + ttRelate.cRelatedTable) ELSE ttRelate.cRelatedTable) + ".":U + ENTRY(1,ttRelate.cLinkFieldName) + " = ":U + (IF VALID-HANDLE(gFuncLibHdl) THEN db-tbl-name(pcDataBaseName + ".":U + pcTableName) ELSE pcTableName) + ".":U + ENTRY(1,ttRelate.cLinkFieldName).
    ASSIGN pcAddedTables  = IF pcAddedTables = "":U THEN (IF VALID-HANDLE(gFuncLibHdl) THEN db-tbl-name(ttRelate.cDataBaseName + ".":U + ttRelate.cRelatedTable) ELSE ttRelate.cRelatedTable) ELSE pcAddedTables + ",":U + (IF VALID-HANDLE(gFuncLibHdl) THEN db-tbl-name(ttRelate.cDataBaseName + ".":U + ttRelate.cRelatedTable) ELSE ttRelate.cRelatedTable)
           pcAddOnQuery   = IF pcAddOnQuery = "":U THEN cQuery ELSE pcAddOnQuery + ", ":U + cQuery
           pcAddTableList = pcAddTableList + (IF NUM-ENTRIES(pcAddTableList) > 0 THEN ",":U ELSE "":U) +  
                            ttRelate.cDataBaseName + ".":U + ttRelate.cRelatedTable + " WHERE ":U +
                            pcDataBaseName + ".":U + pcTableName + " ...":U
           pcJoinCode     = pcJoinCode + (IF NUM-ENTRIES(pcJoinCode) > 0 THEN CHR(5) ELSE "":U) + 
                            ttRelate.cDataBaseName + ".":U + ttRelate.cRelatedTable + ".":U + ENTRY(1,ttRelate.cLinkFieldName) + " = ":U +
                            pcDataBaseName + ".":U + pcTableName + ".":U + ENTRY(1,ttRelate.cLinkFieldName).
    hEntityTable:FIND-FIRST("WHERE entity_mnemonic_description = '" + ttRelate.cRelatedTable + "'":U, NO-LOCK) NO-ERROR.
    IF hEntityTable:AVAILABLE THEN DO:
      IF hEntityTable:BUFFER-FIELD("entity_description_field"):BUFFER-VALUE <> "":U THEN DO:
        ASSIGN pcDisplayFields = IF pcDisplayFields = "":U THEN hEntityTable:BUFFER-FIELD("entity_description_field"):BUFFER-VALUE ELSE pcDisplayFields + ";":U + hEntityTable:BUFFER-FIELD("entity_description_field"):BUFFER-VALUE.
        NEXT.
      END.
      ELSE DO:
        cDescField = "":U.
        /* Try and find a descriptave field */
        CREATE QUERY hFieldQuery.
        hFieldQuery:ADD-BUFFER(hEntityFieldTable).
        hFieldQuery:QUERY-PREPARE("FOR EACH " + hEntityFieldTable:NAME + " WHERE entity_mnemonic = '" + hEntityTable:BUFFER-FIELD("entity_mnemonic"):BUFFER-VALUE + "'") NO-ERROR.
        hFieldQuery:QUERY-OPEN().
        hFieldQuery:GET-FIRST().
        DO WHILE hEntityFieldTable:AVAILABLE:
          IF CAN-DO("*reference,*code,last_name,*tla,*short*,*id,*desc*,first_name,*name*",hEntityFieldTable:BUFFER-FIELD("display_field_name"):BUFFER-VALUE) THEN
            cDescField = IF cDescField = "":U THEN hEntityFieldTable:BUFFER-FIELD("display_field_name"):BUFFER-VALUE
                                              ELSE cDescField + ",":U + hEntityFieldTable:BUFFER-FIELD("display_field_name"):BUFFER-VALUE.
          hFieldQuery:GET-NEXT().
        END.
        hFieldQuery:QUERY-CLOSE().
        DELETE OBJECT hFieldQuery NO-ERROR.
        ASSIGN hFieldQuery = ?.
      END. /* Entity Available */
      /* If we could not find one in the list - use the link field */
      IF cDescField = "":U THEN
        cDescField = ttRelate.cLinkFieldName.
      
      /* Select the best fit */
      IF NUM-ENTRIES(cDescField) > 1 THEN DO:
        cAllFields = cDescField.
        DO iLoop = 1 TO NUM-ENTRIES(cAllFields):
          cDescField = ENTRY(iloop,cAllFields).
          IF CAN-DO("*desc*,first_name,*name*,*short*",cDescField) THEN
            LEAVE.
        END.
      END.
      /* If we could not find something in the list - use the first one */
      IF NUM-ENTRIES(cDescField) > 1 THEN
        cDescField = ENTRY(1,cDescField).

      pcDisplayFields = IF pcDisplayFields = "":U THEN ttRelate.cLinkFieldName ELSE pcDisplayFields + ";":U + cDescField.
    END.
    ELSE /* If the entity record does not exist - just reserve the space for it */
      pcDisplayFields = IF pcDisplayFields = "":U THEN ttRelate.cLinkFieldName ELSE pcDisplayFields + ";":U + ttRelate.cLinkFieldName.
  END.
  &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE insertAttributeValues Include 
PROCEDURE insertAttributeValues PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Ensures that attribute values are able to be passed to the 
               storeAttributeValues API in the Repository Manager.
  Parameters:  pcAttributeOwner       -
               pdAttributeOwnerObj    -
               phAttributeValueBuffer -
  Notes:       * This procedure is private to this Manager and is designed
                 to work on the server-side only.
               * All of the attribute values which have the specified attribute
                 parent will be updated with the relevant parent obj.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcAttributeOwner         AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pdAttributeOwnerObj      AS DECIMAL          NO-UNDO.
    DEFINE INPUT PARAMETER phAttributeValueBuffer   AS HANDLE           NO-UNDO.

    DEFINE VARIABLE hAttributeQuery         AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hAttributeValueTable    AS HANDLE                   NO-UNDO.

    CREATE WIDGET-POOL "insertAttributeValues":U.
    CREATE QUERY hAttributeQuery IN WIDGET-POOL "insertAttributeValues":U.
    
    hAttributeQuery:ADD-BUFFER(phAttributeValueBuffer).
    hAttributeQuery:QUERY-PREPARE(" FOR EACH ":U + phAttributeValueBuffer:NAME + " WHERE ":U 
                                  + phAttributeValueBuffer:NAME + ".tAttributeParent = '" + pcAttributeOwner + "' ":U).
    
    hAttributeQuery:QUERY-OPEN().
    hAttributeQuery:GET-FIRST().
    
    DO WHILE phAttributeValueBuffer:AVAILABLE:
        ASSIGN phAttributeValueBuffer:BUFFER-FIELD("tAttributeParentObj":U):BUFFER-VALUE = pdAttributeOwnerObj.
        hAttributeQuery:GET-NEXT().
    END.    /* available attribute value buffer */
    hAttributeQuery:QUERY-CLOSE().

    DELETE OBJECT hAttributeQuery NO-ERROR.
    ASSIGN hAttributeQuery = ?.
    
    DELETE WIDGET-POOL "insertAttributeValues":U.

    ASSIGN hAttributeValueTable = ?.

    RUN storeAttributeValues IN gshRepositoryManager ( INPUT phAttributeValueBuffer, INPUT TABLE-HANDLE hAttributeValueTable) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

    RETURN.
END PROCEDURE.  /* insertAttributeValues */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE insertObjectInstance Include 
PROCEDURE insertObjectInstance :
/*------------------------------------------------------------------------------
  Purpose:     To add/update an object instance on a container
  Parameters:  pdContainerObjectObj               -
               pcObjectName                       -
               pcResultCode                       -
               pcInstanceName                     -
               pcInstanceDescription              -
               pcLayoutPosition                   -
               plForceCreateNew                   -
               phAttributeValueBuffer             -
               TABLE-HANDLE phAttributeValueTable -
               pdSmartObjectObj                   -
               pdObjectInstanceObj                - 
                              
  Notes:       * If object already exists on container, the instance and its
               attribute values will be updated accordingly, otherwise the
               instance will be created.
               * If the force new create flag is set, a new object instance is
               created regardless of whetehr one exists or not.
               * We determine whether the object exists based on the object instance
               name as an object can exist on a container multiple times. This behaviour can
               also be overridden by the force new create flag.
               * All the attribute values which are contained in the attribute value table which
               are set against the INSTANCE owner will be set against this object.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pdContainerObjectObj        AS DECIMAL          NO-UNDO.
    DEFINE INPUT  PARAMETER pcObjectName                AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcResultCode                AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcInstanceName              AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcInstanceDescription       AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcLayoutPosition            AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER plForceCreateNew            AS LOGICAL          NO-UNDO.
    DEFINE INPUT  PARAMETER phAttributeValueBuffer      AS HANDLE           NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE-HANDLE phAttributeValueTable.
    DEFINE OUTPUT PARAMETER pdSmartObjectObj            AS DECIMAL          NO-UNDO.
    DEFINE OUTPUT PARAMETER pdObjectInstanceObj         AS DECIMAL          NO-UNDO.

    &IF DEFINED(Server-side) EQ 0 &THEN
    IF NOT VALID-HANDLE(phAttributeValueTable) THEN
        ASSIGN phAttributeValueTable  = phAttributeValueBuffer:TABLE-HANDLE
               phAttributeValueBuffer = ?
               .

    {dynlaunch.i
        &PLIP   = 'RepositoryDesignManager'
        &IProc  = 'insertObjectInstance'               
        &mode1  = INPUT  &Parm1  = pdContainerObjectObj     &DataType1  = DECIMAL
        &mode2  = INPUT  &Parm2  = pcObjectName             &DataType2  = CHARACTER
        &mode3  = INPUT  &Parm3  = pcResultCode             &DataType3  = CHARACTER
        &mode4  = INPUT  &Parm4  = pcInstanceName           &DataType4  = CHARACTER
        &mode5  = INPUT  &Parm5  = pcInstanceDescription    &DataType5  = CHARACTER
        &mode6  = INPUT  &Parm6  = pcLayoutPosition         &DataType6  = CHARACTER
        &mode7  = INPUT  &Parm7  = plForceCreateNew         &DataType7  = LOGICAL
        &mode8  = INPUT  &Parm8  = phAttributeValueBuffer   &DataType8  = HANDLE
        &mode9  = INPUT  &Parm9  = phAttributeValueTable    &DataType9  = TABLE-HANDLE
        &mode10 = OUTPUT &Parm10 = pdSmartObjectObj         &DataType10 = DECIMAL
        &mode11 = OUTPUT &Parm11 = pdObjectInstanceObj      &DataType11 = DECIMAL
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
    DEFINE VARIABLE dCustomisationResultObj             AS DECIMAL          NO-UNDO.

    DEFINE BUFFER rycoi     FOR ryc_object_instance.

    /** Find the result code
     *  ----------------------------------------------------------------------- **/
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

    /** Determine the object ID of the record to add to the container.
     *  ----------------------------------------------------------------------- **/
    ASSIGN pdSmartObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U, INPUT pcObjectName, INPUT dCustomisationResultObj).
    IF pdSmartObjectObj EQ 0 THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'Object to be contained'" pcObjectName}.

    FIND FIRST rycoi WHERE
               rycoi.container_smartobject_obj = pdContainerObjectObj AND
               rycoi.smartobject_obj           = pdSmartObjectObj     AND
               rycoi.instance_name             = pcInstanceName
               EXCLUSIVE-LOCK NO-WAIT NO-ERROR.

    /* Create a new instance if the force create flag is set, or if no
     * instance exists already.                                        */
    IF NOT AVAILABLE rycoi OR plForceCreateNew THEN
    DO:
        CREATE rycoi NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        ASSIGN rycoi.container_smartobject_obj = pdContainerObjectObj
               rycoi.smartobject_obj           = pdSmartObjectObj
               rycoi.system_owned              = NO
               rycoi.instance_name             = pcInstanceName
               NO-ERROR.
        /* validation takes place elsewhere */
    END.    /* create a record */

    ASSIGN rycoi.layout_position      = pcLayoutPosition
           rycoi.instance_description = pcInstanceDescription
           NO-ERROR.

    VALIDATE rycoi NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

    /* Set-up return values */
    ASSIGN pdObjectInstanceObj = rycoi.object_instance_obj.

    /** If there are attribute vlaue records passed in, they will all be set at
     *  the INSTANCE level.
     *  ----------------------------------------------------------------------- **/
    IF VALID-HANDLE(phAttributeValueBuffer) OR VALID-HANDLE(phAttributeValueTable) THEN
    DO:    
        IF NOT VALID-HANDLE(phAttributeValueBuffer) THEN
            ASSIGN phAttributeValueBuffer = phAttributeValueTable:DEFAULT-BUFFER-HANDLE.

        IF NOT VALID-HANDLE(phAttributeValueTable) THEN
            ASSIGN phAttributeValueTable = phAttributeValueBuffer:TABLE-HANDLE.

        IF VALID-HANDLE(phAttributeValueTable) AND
           phAttributeValueTable:HAS-RECORDS   THEN
        DO:
            RUN insertAttributeValues (INPUT "INSTANCE":U,
                                       INPUT pdObjectInstanceObj,
                                       INPUT phAttributeValueBuffer ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
        END.    /* there  are attribute value records. */
    END.    /* valid-handle attribute buffer. */
    &ENDIF  /* server-side yes */
                   
    RETURN.
END PROCEDURE.  /* insertObjectInstance */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE insertObjectLinks Include 
PROCEDURE insertObjectLinks :
/*------------------------------------------------------------------------------
  Purpose:     To add/update an object's links
  Parameters:  dContainerObjObjectObj          -
               phSmartLinkBuffer             -
               TABLE-HANDLE phSmartLinkTable -
                              
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER dContainerObjObjectObj   AS DECIMAL          NO-UNDO.
    DEFINE INPUT  PARAMETER phSmartLinkBuffer      AS HANDLE           NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE-HANDLE phSmartLinkTable.
    
    DEFINE VARIABLE cMessageList AS CHARACTER  NO-UNDO.

    &IF DEFINED(Server-side) EQ 0 &THEN
    IF NOT VALID-HANDLE(phSmartLinkTable) THEN
        ASSIGN phSmartLinkTable  = phSmartLinkBuffer:TABLE-HANDLE
               phSmartLinkBuffer = ?
               .
    {dynlaunch.i
        &Plip  = 'RepositoryDesignManager'
        &IProc = 'insertObjectLinks'
        &Mode1 = INPUT &Parm1 = dContainerObjObjectObj  &DataType1 = DECIMAL
        &Mode2 = INPUT &Parm2 = phSmartLinkBuffer       &DataType2 = HANDLE
        &Mode3 = INPUT &Parm3 = phSmartLinkTable        &DataType3 = TABLE-HANDLE
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
    
    DEFINE VARIABLE cLinkName                AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cUserLinkName            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dContainerObj            AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dSourceObj               AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dTargetObj               AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE hQuery                   AS HANDLE     NO-UNDO.    
    
    DEFINE BUFFER bryc_smartlink FOR ryc_smartlink.

    ASSIGN cMessageList = "":U.

    IF VALID-HANDLE(phSmartLinkTable) THEN
        ASSIGN phSmartLinkBuffer = phSmartLinkTable:DEFAULT-BUFFER-HANDLE.

    IF VALID-HANDLE(phSmartLinkBuffer) AND phSmartLinkBuffer:TYPE NE "BUFFER":U THEN
        ASSIGN phSmartLinkBuffer = phSmartLinkBuffer:DEFAULT-BUFFER-HANDLE.

    CREATE WIDGET-POOL "insertObjectLinks":U.
    CREATE QUERY hQuery IN WIDGET-POOL "insertObjectLinks":U.
    hQuery:ADD-BUFFER(phSmartLinkBuffer).

    hQuery:QUERY-PREPARE(" FOR EACH ":U + phSmartLinkBuffer:NAME + " BY ":U +  phSmartLinkBuffer:NAME + ".tContainerObj":U).

    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST().

    DO WHILE phSmartLinkBuffer:AVAILABLE:
    
      ASSIGN cLinkName     = phSmartLinkBuffer:BUFFER-FIELD("tLinkName":U):BUFFER-VALUE
             cUserLinkName = phSmartLinkBuffer:BUFFER-FIELD("tUserLinkName":U):BUFFER-VALUE
             dContainerObj = phSmartLinkBuffer:BUFFER-FIELD("tContainerObj":U):BUFFER-VALUE
             dSourceObj    = phSmartLinkBuffer:BUFFER-FIELD("tSourceObj":U):BUFFER-VALUE
             dTargetObj    = phSmartLinkBuffer:BUFFER-FIELD("tTargetObj":U):BUFFER-VALUE.

      /* validate link name / user link name specified */
      IF cUserLinkName <> "":U THEN DO:
        FIND FIRST ryc_smartlink_type NO-LOCK
             WHERE ryc_smartlink_type.link_name = cUserLinkName
             NO-ERROR.
        IF NOT AVAILABLE ryc_smartlink_type THEN DO:
          RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'User Defined Link Name'" cUserLinkName}.      
        END.
      END.
      ELSE DO:
        FIND FIRST ryc_smartlink_type NO-LOCK
             WHERE ryc_smartlink_type.link_name = cLinkName
             NO-ERROR.
        IF NOT AVAILABLE ryc_smartlink_type THEN DO:
          RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'Link Name'" cLinkName}.      
        END.
      END.
  
      trn-block:
      DO FOR bryc_smartlink TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:
        /* link specified is valid, see if link already exist */
        FIND FIRST bryc_smartlink EXCLUSIVE-LOCK
             WHERE bryc_smartlink.container_smartobject_obj = dContainerObj
               AND bryc_smartlink.link_name = ryc_smartlink_type.link_name
               AND bryc_smartlink.source_object_instance_obj = dSourceObj
               AND bryc_smartlink.target_object_instance_obj = dTargetObj
             NO-ERROR.
          
        IF AVAILABLE bryc_smartlink THEN DO:
          DELETE bryc_smartlink NO-ERROR.
          {af/sup2/afcheckerr.i &no-return = YES}
          IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
        END.
        /* create new smartlink */
        CREATE bryc_smartlink NO-ERROR.
        {af/sup2/afcheckerr.i &no-return = YES}
        IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
    
        ASSIGN
          bryc_smartlink.container_smartobject_obj = dContainerObj
          bryc_smartlink.smartlink_type_obj = ryc_smartlink_type.smartlink_type_obj
          bryc_smartlink.link_name = ryc_smartlink_type.link_name
          bryc_smartlink.source_object_instance_obj = dSourceObj
          bryc_smartlink.target_object_instance_obj = dTargetObj
          .    
        VALIDATE bryc_smartlink NO-ERROR.
        {af/sup2/afcheckerr.i &no-return = YES}
        IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
      END. /* trn-block */
      hQuery:GET-NEXT().
    END. /* Query */
    hQuery:QUERY-CLOSE().
    DELETE OBJECT hQuery.
    ASSIGN hQuery = ?.

    DELETE WIDGET-POOL "insertObjectLinks":U.

    &ENDIF  /* server-side yes */
    
    IF cMessageList <> "":U THEN 
      RETURN cMessageList.
    ELSE              
      RETURN.
END PROCEDURE.  /* insertObjectLinks */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE insertObjectMaster Include 
PROCEDURE insertObjectMaster :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to create / update ICFDB ryc_smartobject records for 
               dynamic or static object passed in.
  Parameters:  pcObjectName                        - the name of the object to be stored.
               pcResultCode                        - (OPT) a result code to store this object for.
               pcProductModuleCode                 - the product module in which to store the obejct.
               pcObjectTypeCode                    - the object type (class) of this object.
               pcObjectDescription                 - a description of the object.
               pcObjectPath                        - (OPT) the raltive path of this object.
               pcSdoObjectName                     - (OPT) the name of an SDO associated with this object.
               pcSuperProcedureName                - (OPT) the name of a super procedure associated with this object.
               plIsTemplate                        - is this object a template?
               plIsStatic                          - is this a static object?
               pcPhysicalObjectName                - (OPT) the name of the physical obejct associated with this object.
               plRunPersistent                     - whether the object must run persistently or not.
               pcTooltipText                       - the tooltip test for the object.
               pcRequiredDBList                    - the DBs required to run this object.
               pcLayoutCode                        - (OPT) the layout code for this object.
               phAttributeValueBuffer              - } pointers to the attribute value TT.
               TABLE-HANDLE phAttributeValueTable  - }
               pdSmartObjectObj                    - the smartobjectobj of the object updated here.
               
  Notes:       * All the attribute values which are contained in the attribute value table which
                 are set against the MASTER owner will be set against this object.
               *  A blank result code defaults to the DEFAULT-RESULT-CODE
               * The product module determines the relative path of the object
                 if the obejctpath passed in is blank.               
               * if the object is not a static object, a physical object name must be 
                 supplied. If no physical object name is passed in, a default value is 
                 used.
               * if not tooltip text is passed in, the object description is used.
               * If the object type of the object has the layout supported flag 
                 set to yes, the layout defaults to RELATIVE if none is specified.               
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcObjectName            AS CHARACTER            NO-UNDO.
    DEFINE INPUT  PARAMETER pcResultCode            AS CHARACTER            NO-UNDO.
    DEFINE INPUT  PARAMETER pcProductModuleCode     AS CHARACTER            NO-UNDO.
    DEFINE INPUT  PARAMETER pcObjectTypeCode        AS CHARACTER            NO-UNDO.
    DEFINE INPUT  PARAMETER pcObjectDescription     AS CHARACTER            NO-UNDO.
    DEFINE INPUT  PARAMETER pcObjectPath            AS CHARACTER            NO-UNDO.
    DEFINE INPUT  PARAMETER pcSdoObjectName         AS CHARACTER            NO-UNDO.
    DEFINE INPUT  PARAMETER pcSuperProcedureName    AS CHARACTER            NO-UNDO.
    DEFINE INPUT  PARAMETER plIsTemplate            AS LOGICAL              NO-UNDO.
    DEFINE INPUT  PARAMETER plIsStatic              AS LOGICAL              NO-UNDO.
    DEFINE INPUT  PARAMETER pcPhysicalObjectName    AS CHARACTER            NO-UNDO.
    DEFINE INPUT  PARAMETER plRunPersistent         AS LOGICAL              NO-UNDO.
    DEFINE INPUT  PARAMETER pcTooltipText           AS CHARACTER            NO-UNDO.
    DEFINE INPUT  PARAMETER pcRequiredDBList        AS CHARACTER            NO-UNDO.
    DEFINE INPUT  PARAMETER pcLayoutCode            AS CHARACTER            NO-UNDO.
    DEFINE INPUT  PARAMETER phAttributeValueBuffer  AS HANDLE               NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE-HANDLE phAttributeValueTable.
    DEFINE OUTPUT PARAMETER pdSmartObjectObj           AS DECIMAL              NO-UNDO.

    &IF DEFINED(Server-side) EQ 0 &THEN
    IF NOT VALID-HANDLE(phAttributeValueTable) THEN
        ASSIGN phAttributeValueTable  = phAttributeValueBuffer:TABLE-HANDLE
               phAttributeValueBuffer = ?.
    {dynlaunch.i
        &Plip  = 'RepositoryDesignManager'
        &IProc = 'insertObjectMaster'
        
        &Mode1  = INPUT  &Parm1  = pcObjectName           &DataType1  = CHARACTER
        &Mode2  = INPUT  &Parm2  = pcResultCode           &DataType2  = CHARACTER
        &Mode3  = INPUT  &Parm3  = pcProductModuleCode    &DataType3  = CHARACTER
        &Mode4  = INPUT  &Parm4  = pcObjectTypeCode       &DataType4  = CHARACTER
        &Mode5  = INPUT  &Parm5  = pcObjectDescription    &DataType5  = CHARACTER
        &Mode6  = INPUT  &Parm6  = pcObjectPath           &DataType6  = CHARACTER
        &Mode7  = INPUT  &Parm7  = pcSdoObjectName        &DataType7  = CHARACTER
        &Mode8  = INPUT  &Parm8  = pcSuperProcedureName   &DataType8  = CHARACTER
        &Mode9  = INPUT  &Parm9  = plIsTemplate           &DataType9  = LOGICAL
        &Mode10 = INPUT  &Parm10 = plIsStatic             &DataType10 = LOGICAL
        &Mode11 = INPUT  &Parm11 = pcPhysicalObjectName   &DataType11 = CHARACTER
        &Mode12 = INPUT  &Parm12 = plRunPersistent        &DataType12 = LOGICAL
        &Mode13 = INPUT  &Parm13 = pcTooltipText          &DataType13 = CHARACTER
        &Mode14 = INPUT  &Parm14 = pcRequiredDBList       &DataType14 = CHARACTER
        &Mode15 = INPUT  &Parm15 = pcLayoutCode           &DataType15 = CHARACTER
        &Mode16 = INPUT  &Parm16 = phAttributeValueBuffer &DataType16 = HANDLE
        &Mode17 = INPUT  &Parm17 = phAttributeValueTable  &DataType17 = TABLE-HANDLE
        &Mode18 = OUTPUT &Parm18 = pdSmartObjectObj       &DataType18 = DECIMAL        
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE   
    DEFINE VARIABLE cObjectExt                  AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cObjectFileNameWithExt      AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cObjectFileNameNoExt        AS CHARACTER                NO-UNDO.    
    DEFINE VARIABLE cNewObjectName              AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE lHasExtension               AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE lContainerObject            AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE dPhysicalObjectObj          AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dSdoObjectObj               AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dSuperProcObjectObj         AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dCustomisationResultObj     AS DECIMAL                  NO-UNDO.     
    DEFINE VARIABLE hAttributeQuery             AS HANDLE                   NO-UNDO.

    DEFINE BUFFER rycso         FOR ryc_smartObject.
    
    IF pcTooltipText EQ "":U THEN
        ASSIGN pcTooltipText = pcObjectDescription.

    ASSIGN lHasExtension = LOOKUP(pcObjectTypeCode, gcCLASS-HAS-NO-EXTENSION) EQ 0.

    IF NOT plIsStatic AND pcPhysicalObjectName EQ "":U THEN
    CASE TRUE:
        WHEN LOOKUP(pcObjectTypeCode, gcCLASS-PHYSICAL-CONTAINER) GT 0 THEN ASSIGN pcPhysicalObjectName = "{&CONTAINER-PHYSICAL-OBJECT}":U.
        WHEN LOOKUP(pcObjectTypeCode, gcCLASS-PHYSICAL-VIEWER)    GT 0 THEN ASSIGN pcPhysicalObjectName = "{&VIEWER-PHYSICAL-OBJECT}":U.
        WHEN LOOKUP(pcObjectTypeCode, gcCLASS-PHYSICAL-BROWSE)    GT 0 THEN ASSIGN pcPhysicalObjectName = "{&BROWSE-PHYSICAL-OBJECT}":U.
        WHEN LOOKUP(pcObjectTypeCode, gcCLASS-PHYSICAL-COMBO)     GT 0 THEN ASSIGN pcPhysicalObjectName = "{&COMBO-PHYSICAL-OBJECT}":U.
        WHEN LOOKUP(pcObjectTypeCode, gcCLASS-PHYSICAL-LOOKUP)    GT 0 THEN ASSIGN pcPhysicalObjectName = "{&LOOKUP-PHYSICAL-OBJECT}":U.
        WHEN LOOKUP(pcObjectTypeCode, gcCLASS-PHYSICAL-SDO)       GT 0 THEN ASSIGN pcPhysicalObjectName = "{&SDO-PHYSICAL-OBJECT}":U.
        WHEN LOOKUP(pcObjectTypeCode, gcCLASS-PHYSICAL-FRAME)     GT 0 THEN ASSIGN pcPhysicalObjectName = "{&FRAME-PHYSICAL-OBJECT}":U.
        WHEN LOOKUP(pcObjectTypeCode, gcCLASS-PHYSICAL-SBO)       GT 0 THEN ASSIGN pcPhysicalObjectName = "{&SBO-PHYSICAL-OBJECT}":U.
        OTHERWISE RETURN ERROR {aferrortxt.i 'AF' '36' '?' '?' "'No default physical object could be found for class ' + pcObjectTypeCode "}.
    END CASE.    /* no physical object name provided, and is not a static object. */

    ASSIGN lContainerObject = LOOKUP(pcObjectTypeCode, gcCONTAINER-CLASSES) GT 0.

    /** Find product module for object
     *  ----------------------------------------------------------------------- **/
    FIND FIRST gsc_product_module WHERE
               gsc_product_module.product_module_code = pcProductModuleCode
               NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gsc_product_module THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'Product Module'" pcProductModuleCode}.

    /* The relative path acts as a default for the object. */
    IF pcObjectPath EQ "":U THEN
        ASSIGN pcObjectPath = gsc_product_module.relative_path.

    FIND FIRST gsc_object_type WHERE
               gsc_object_type.object_type_code = pcObjectTypeCode
               NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gsc_object_type THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'Object Type'" pcObjectTypeCode}.

    IF NOT gsc_object_type.layout_supported AND pcLayoutCode NE "":U THEN
        RETURN ERROR {aferrortxt.i 'AF' '40' '?' '?' '"the layout suported flag for the specified object´s class is set to no, and a layout has been speficied."'}.
    ELSE
    IF gsc_object_type.layout_supported AND pcLayoutCode EQ "":U THEN
        ASSIGN pcLayoutCode = "RELATIVE":U.

    /* Find layout, if required. */
    IF pcLayoutCode NE "":U THEN
    DO:
        FIND FIRST ryc_layout WHERE
                   ryc_layout.layout_name = pcLayoutCode
                   NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ryc_layout THEN
            RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'Layout'" pcLayoutCode}.
    END.    /* a layout has been specified. */

    /** Find the result code
     *  ----------------------------------------------------------------------- **/
    IF pcResultCode EQ "":U OR pcResultCode EQ ? THEN
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

    /* Find corresponding physical object,
     * if one exists.                       */
    IF pcPhysicalObjectName NE pcObjectName AND pcPhysicalObjectName NE "":U THEN
    DO:
        ASSIGN dPhysicalObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U, INPUT pcPhysicalObjectName, INPUT dCustomisationResultObj).
        IF dPhysicalObjectObj EQ 0 THEN
            RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'physical Object'" pcPhysicalObjectName}.
    END.    /* physical name */

    /** Find SDO name if passed in (viewers / browsers)
     *  ----------------------------------------------------------------------- **/
    IF pcSdoObjectName NE "":U THEN
    DO:
        ASSIGN dSdoObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U, INPUT pcSdoObjectName, INPUT dCustomisationResultObj).
        IF dSdoObjectObj EQ 0 THEN
            RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'SDO Object'" pcSdoObjectName}.
    END.    /* SDO passed in */

    /** Find super procedure smartobject, if passed in.
     *  ----------------------------------------------------------------------- **/
    IF pcSuperProcedureName NE "":U THEN
    DO:
        ASSIGN dSuperProcObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U, INPUT pcSuperProcedureName, INPUT dCustomisationResultObj).
        IF dSuperProcObjectObj EQ 0 THEN
            RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'Custom Super Procedure Object'" pcSuperProcedureName}.
    END.    /* super procedure passed in */

    /* Find existing object record / create new one.
     * Always check whether the name passed in has an existing 
     * smartobject. This is relevant for backwards compatability. */
    FIND FIRST rycso WHERE
               rycso.object_filename          = pcObjectName            AND
               rycso.customization_result_obj = dCustomisationResultObj AND
               rycso.object_extension         = "":U
               EXCLUSIVE-LOCK NO-WAIT NO-ERROR.

    /* Make sure that the extension is clear. */
    ASSIGN cObjectExt     = "":U
           cNewObjectName = pcObjectName.

    IF NOT AVAILABLE rycso AND lHasExtension THEN
    DO:
        RUN extractRootFile IN gshRepositoryManager ( INPUT pcObjectName, OUTPUT cObjectFileNameNoExt, OUTPUT cObjectFileNameWithExt ).
        ASSIGN cObjectExt = REPLACE(cObjectFileNameWithExt, (cObjectFileNameNoExt + ".":U), "":U).

        /* If there is no extension, and we are expecting an extension,
         * we can only allow the create of this object if there are no other
         * objects with the same name (without extension). So if an object called
         * 'ABC' is passed in to this API, and it expects an extension, we can only
         * create that obejct if there are no objects called 'ABC' and which have
         * an object_extension.                                                      */
        IF cObjectExt EQ "":U THEN
        DO:
            IF CAN-FIND(FIRST rycso WHERE
                              rycso.object_filename          = cObjectFileNameNoExt    AND
                              rycso.customization_result_obj = dCustomisationResultObj AND
                              rycso.object_extension        <> cObjectExt                  ) THEN
                RETURN ERROR {aferrortxt.i 'AF' '40' 'ryc_smartObject' '?' '"an object already exists with this object name and a non-blank object extension"'}.        
        END.    /* blank extension. */
        ELSE
        DO:
            FIND FIRST rycso WHERE
                       rycso.object_filename          = cObjectFileNameNoExt    AND
                       rycso.customization_result_obj = dCustomisationResultObj AND
                       rycso.object_extension         = cObjectExt
                       EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
            IF LOCKED rycso THEN
                RETURN ERROR {aferrortxt.i 'AF' '104' '?' '?' "'object ' + pcObjectName"}.
            ELSE
            IF NOT AVAILABLE rycso THEN
            DO:
                /* If an object already exists with the non-extended filename,  then we need to create the object with a filename that has
                 * the file extension in it. If this is the first time that an ojbect with this filename (unextended)
                 * is being created, the populate the object extension field.              */
                IF CAN-FIND(FIRST rycso WHERE
                                  rycso.object_filename          = cObjectFileNameNoExt    AND
                                  rycso.customization_result_obj = dCustomisationResultObj AND
                                  rycso.object_extension        <> cObjectExt                  ) THEN
                    ASSIGN cNewObjectName = pcObjectName    
                           cObjectExt     = "":U.
                ELSE
                    ASSIGN cNewObjectName = cObjectFileNameNoExt.
            END.    /* can't find filename without extension. */
        END.    /* has an extension. */
    END.    /* has an extension and not available */

    IF LOCKED rycso THEN
        RETURN ERROR {aferrortxt.i 'AF' '104' '?' '?' "'object ' + pcObjectName"}.
    ELSE
    IF NOT AVAILABLE rycso THEN
    DO:
        CREATE rycso NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        ASSIGN rycso.object_filename          = cNewObjectName
               rycso.customization_result_obj = dCustomisationResultObj
               rycso.object_Extension         = cObjectExt
               rycso.DISABLED                 = NO
               rycso.system_owned             = NO
               rycso.shutdown_message_text    = "":U
               rycso.template_smartobject     = plIsTemplate
               NO-ERROR.
        { checkerr.i &return-error=YES }
        /* Validation takes place after we have assigned everything. */
    END.    /* create new rycso */

    /* Update object details */
    ASSIGN rycso.object_description       = pcObjectDescription
           rycso.static_object            = plIsStatic
           rycso.generic_object           = NO
           rycso.container_object         = lContainerObject
           rycso.object_path              = pcObjectPath
           rycso.object_type_obj          = gsc_object_type.object_type_obj
           rycso.required_db_list         = pcRequiredDBList
           rycso.runnable_from_menu       = LOOKUP(pcObjectTypeCode, gcCLASS-PHYSICAL-CONTAINER) GT 0
           rycso.run_persistent           = plRunPersistent
           rycso.run_when                 = "ANY":U
           rycso.product_module_obj       = gsc_product_module.product_module_obj
           rycso.layout_obj               = (IF AVAILABLE ryc_layout THEN ryc_layout.layout_obj ELSE 0)
           rycso.physical_smartobject_obj = dPhysicalObjectObj
           rycso.security_smartobject_obj = rycso.smartobject_obj
           rycso.sdo_smartobject_obj      = dSdoObjectObj
           rycso.custom_smartobject_obj   = dSuperProcObjectObj
           NO-ERROR.
    { checkerr.i &return-error=YES }

    VALIDATE rycso NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

    ASSIGN pdSmartObjectObj = rycso.smartobject_obj.

    /** If there are attribute vlaue records passed in, they will all be set at
     *  the MASTER level.
     *  ----------------------------------------------------------------------- **/
    IF VALID-HANDLE(phAttributeValueBuffer) OR VALID-HANDLE(phAttributeValueTable) THEN
    DO:    
        IF NOT VALID-HANDLE(phAttributeValueBuffer) THEN
            ASSIGN phAttributeValueBuffer = phAttributeValueTable:DEFAULT-BUFFER-HANDLE.

        IF NOT VALID-HANDLE(phAttributeValueTable) THEN
            ASSIGN phAttributeValueTable = phAttributeValueBuffer:TABLE-HANDLE.

        IF VALID-HANDLE(phAttributeValueTable) AND phAttributeValueTable:HAS-RECORDS THEN
        DO:
            RUN insertAttributeValues IN TARGET-PROCEDURE( INPUT "MASTER":U, INPUT pdSmartObjectObj, INPUT phAttributeValueBuffer ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
        END.    /* there  are attribute value records. */
    END.    /* there are attribute value records. */
    &ENDIF                   
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* insertObjectMaster */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE insertUiEvents Include 
PROCEDURE insertUiEvents :
/*------------------------------------------------------------------------------
  Purpose:     Stores UI Events 
  Parameters:  
  Notes:       * The buffer used in this API is based on the TT defined in
                 ry/inc/ryrepatset.i
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER phUiEventBuffer          AS HANDLE           NO-UNDO.
    DEFINE INPUT PARAMETER TABLE-HANDLE phUiEventTable.

    DEFINE VARIABLE cMessageList                AS CHARACTER            NO-UNDO.
    
    &IF DEFINED(Server-Side) EQ 0 &THEN
    /* Make sure we pass the correct thing to the AppServer */
    IF NOT VALID-HANDLE(phUiEventTable) THEN
        ASSIGN phUiEventTable  = phUiEventBuffer:TABLE-HANDLE
               phUiEventBuffer = ?.
    {dynlaunch.i
        &Plip  = 'RepositoryDesignManager'
        &IProc = 'insertUiEvents'
        &Mode1 = INPUT &Parm1 = phUiEventBuffer &DataType1 = HANDLE
        &Mode2 = INPUT &Parm2 = phUiEventTable  &DataType2 = TABLE-HANDLE
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
    DEFINE VARIABLE dObjectTypeObj              AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dSmartObjectObj             AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dContainerSmartObjectObj    AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dObjectInstanceObj          AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dEventParentObj             AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE lConstantValue              AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE hQuery                      AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hClassCacheBuffer           AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cEventParent                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cEventName                  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cAbstractClassNames         AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cInheritsFrom               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iClassLoop                  AS INTEGER              NO-UNDO.

    DEFINE BUFFER ryc_ui_event              FOR ryc_ui_event.
    DEFINE BUFFER rycui_delete              FOR ryc_ui_event.
    DEFINE BUFFER rycui_constant            FOR ryc_ui_event.
    DEFINE BUFFER gsc_object_type           FOR gsc_object_type.
    DEFINE BUFFER ryc_smartObject           FOR ryc_smartObject.
    DEFINE BUFFER ryc_object_instance       FOR ryc_object_instance.

    ASSIGN cAbstractClassNames = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                                  INPUT "AbstractClassNames":U ).

    IF VALID-HANDLE(phUiEventTable) THEN
        ASSIGN phUiEventBuffer = phUiEventTable:DEFAULT-BUFFER-HANDLE.

    IF VALID-HANDLE(phUiEventBuffer) AND phUiEventBuffer:TYPE NE "BUFFER":U THEN
        ASSIGN phUiEventBuffer = phUiEventBuffer:DEFAULT-BUFFER-HANDLE.

    CREATE WIDGET-POOL "insertUiEvents":U.
    CREATE QUERY hQuery IN WIDGET-POOL "insertUiEvents":U.
    hQuery:ADD-BUFFER(phUiEventBuffer).

    hQuery:QUERY-PREPARE(" FOR EACH ":U + phUiEventBuffer:NAME + " BY ":U +  phUiEventBuffer:NAME + ".tEventParentObj":U).

    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST().

    DO WHILE phUiEventBuffer:AVAILABLE:
        /** Find the UI event's parent record. 
         *  ----------------------------------------------------------------------- **/
        IF dEventParentObj NE phUiEventBuffer:BUFFER-FIELD("tEventParentObj":U):BUFFER-VALUE THEN
        DO:
            ASSIGN dEventParentObj = phUiEventBuffer:BUFFER-FIELD("tEventParentObj":U):BUFFER-VALUE
                   cEventParent    = phUiEventBuffer:BUFFER-FIELD("tEventParent":U):BUFFER-VALUE
                   .
            CASE cEventParent:
                WHEN "CLASS":U THEN
                DO:
                    FIND FIRST gsc_object_type WHERE
                               gsc_object_type.object_type_obj = dEventParentObj
                               NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE gsc_object_type THEN
                    DO:                  
                        ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                            + {aferrortxt.i 'AF' '5' 'gsc_object_type' '?' '"class"' 'STRING(dEventParentObj)'}.
                        hQuery:GET-NEXT().
                        NEXT.
                    END.     /* error */

                    ASSIGN dObjectTypeObj           = gsc_object_type.object_type_obj
                           dSmartObjectObj          = 0
                           dContainerSmartObjectObj = 0
                           dObjectInstanceObj       = 0
                           .
                END.    /* class */
                WHEN "MASTER":U THEN
                DO:
                    FIND FIRST ryc_smartObject WHERE
                               ryc_smartObject.smartObject_obj = dEventParentObj
                               NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE ryc_smartObject THEN
                    DO:
                        ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                            + {aferrortxt.i 'AF' '5' 'ryc_smartObject' '?' '"master smartobject"' 'STRING(dEventParentObj)'}.
                        hQuery:GET-NEXT().
                        NEXT.
                    END.     /* error */

                    ASSIGN dObjectTypeObj           = ryc_smartObject.object_type_obj
                           dSmartObjectObj          = ryc_smartObject.smartObject_obj
                           dContainerSmartObjectObj = 0
                           dObjectInstanceObj       = 0
                           .
                END.    /* master */
                WHEN "INSTANCE":U THEN
                DO:
                    FIND FIRST ryc_object_instance WHERE
                               ryc_object_instance.object_instance_obj = dEventParentObj
                               NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE ryc_object_instance THEN
                    DO:
                        ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                            + {aferrortxt.i 'AF' '5' 'ryc_object_instance' '?' '"smartobject instance"' 'STRING(dEventParentObj)'}.
                        hQuery:GET-NEXT().
                        NEXT.
                    END.     /* error */

                    FIND FIRST ryc_smartObject WHERE
                               ryc_smartObject.smartObject_obj = ryc_object_instance.smartObject_obj
                               NO-LOCK NO-ERROR.

                    ASSIGN dObjectTypeObj           = ryc_smartObject.object_type_obj
                           dSmartObjectObj          = ryc_object_instance.smartObject_obj
                           dContainerSmartObjectObj = ryc_object_instance.container_smartObject_obj
                           dObjectInstanceObj       = ryc_object_instance.object_instance_obj.

                    /* Certain classes are not allowed to have attributes stored against any contained
                     * object instances.                                                              
                     *
                     * We don't check the availability for these records since the RI
                     * ensures that there are records avaiable.                       */
                    FIND FIRST ryc_smartObject WHERE
                               ryc_smartObject.smartObject_obj = dContainerSmartObjectObj
                               NO-LOCK.
                    FIND FIRST gsc_object_type WHERE
                               gsc_object_type.object_type_obj = ryc_smartObject.object_type_obj
                               NO-LOCK.
                    ASSIGN hClassCacheBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN gshRepositoryManager,
                                                                INPUT gsc_object_type.object_type_code)
                           cInheritsFrom     = hClassCacheBuffer:BUFFER-FIELD("InheritsFromClasses":U):BUFFER-VALUE.

                    DO iClassLoop = 1 TO NUM-ENTRIES(cAbstractClassNames):
                        IF CAN-DO(cInheritsFrom, ENTRY(iClassLoop, cAbstractClassNames)) THEN
                        DO:
                            ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                                +  {aferrortxt.i 'AF' '36' '?' '?' '"instance UI events"' '"the container on which the object instance belongs is an abstract class"'}.
                            hQuery:GET-NEXT().
                            NEXT.
                        END.    /* can't store instance values. */
                    END.    /* loop through abstract classes */
                END.    /* instance*/
                OTHERWISE
                DO:
                    ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                        +  {aferrortxt.i 'AF' '5' '?' '?' '"UI event parent"' '"The UI event parent must be one of: CLASS, MASTER or INSTANCE."'}.
                    hQuery:GET-NEXT().
                    NEXT.
                END.    /* error */
            END CASE.   /* attribute parent */
        END.    /* new parent */

        /** Make sure that we are allowed to update this attribute value.
         *  ----------------------------------------------------------------------- **/
        ASSIGN cEventName = phUiEventBuffer:BUFFER-FIELD("tEventName":U):BUFFER-VALUE.

        /* If one of this attribute's parents is flagged as constant, we cannot 
         * update this value.                                                  */
        IF cEventParent                                                   EQ "INSTANCE":U AND
           CAN-FIND(FIRST rycui_constant WHERE
                          rycui_constant.object_type_obj           = dObjectTypeObj  AND
                          rycui_constant.smartobject_obj           = dSmartObjectObj AND
                          rycui_constant.object_instance_obj       = 0               AND
                          rycui_constant.event_name                = cEventName      AND
                          rycui_constant.container_smartObject_obj = 0               AND
                          rycui_constant.constant_value            = YES                 ) THEN
        DO:      
            ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                +  {aferrortxt.i 'AF' '36' 'ryc_ui_event' '?' '"the instance UI event"' '"the parent smartobject has its constant value flag set."' }.
            hQuery:GET-NEXT().
            NEXT.      
        END.    /* constant at MASTER level.*/

        IF cEventParent                                                      NE "CLASS":U AND
            CAN-FIND(FIRST rycui_constant WHERE
                           rycui_constant.object_type_obj           = dObjectTypeObj AND
                           rycui_constant.smartobject_obj           = 0              AND
                           rycui_constant.object_instance_obj       = 0              AND
                           rycui_constant.event_name                = cEventName     AND
                           rycui_constant.container_smartObject_obj = 0              AND
                           rycui_constant.constant_value            = YES               ) THEN
        DO:
            ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                 +  {aferrortxt.i 'AF' '36' 'ryc_ui_event' '?' '"the master object UI event"' '"the class has its constant value flag set."' }.
            hQuery:GET-NEXT().
            NEXT.      
        END.    /* constant at CLASS level */

        FIND FIRST ryc_ui_event WHERE
                   ryc_ui_event.object_type_obj           = dObjectTypeObj           AND
                   ryc_ui_event.smartObject_obj           = dSmartObjectObj          AND
                   ryc_ui_event.object_instance_obj       = dObjectInstanceObj       AND
                   ryc_ui_event.container_smartObject_obj = dContainerSmartObjectObj AND
                   ryc_ui_event.event_name                = cEventName
                   EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED ryc_ui_event THEN
        DO:
            ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                +  {aferrortxt.i 'AF' '103' 'ryc_ui_event' '?' "'update the UI event ' + cEventName " }.
            hQuery:GET-NEXT().
            NEXT.
        END.    /* error */

        IF NOT AVAILABLE ryc_ui_event THEN
        DO:
            CREATE ryc_ui_event NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
            DO:
                ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U) + RETURN-VALUE.
                hQuery:GET-NEXT().
                NEXT.
            END.    /* error */

            ASSIGN ryc_ui_event.object_type_obj           = dObjectTypeObj
                   ryc_ui_event.smartObject_obj           = dSmartObjectObj
                   ryc_ui_event.object_instance_obj       = dObjectInstanceObj
                   ryc_ui_event.container_smartObject_obj = dContainerSmartObjectObj
                   ryc_ui_event.event_name                = cEventName
                   NO-ERROR.
            /* Validation is done later. */
        END.    /* n/a attribute value */

        ASSIGN ryc_ui_event.Action_Type     = phUiEventBuffer:BUFFER-FIELD("tActionType":U):BUFFER-VALUE
               ryc_ui_event.Action_Target   = phUiEventBuffer:BUFFER-FIELD("tActionTarget":U):BUFFER-VALUE
               ryc_ui_event.Event_Action    = phUiEventBuffer:BUFFER-FIELD("tEventAction":U):BUFFER-VALUE
               ryc_ui_event.Event_Parameter = phUiEventBuffer:BUFFER-FIELD("tEventParameter":U):BUFFER-VALUE
               ryc_ui_event.Event_Disabled  = phUiEventBuffer:BUFFER-FIELD("tEventDisabled":U):BUFFER-VALUE
               NO-ERROR.
        
        /* There is no point in setting the constant_value flag at the instance level,
         * since the instance is the lowest level of inheritance.                     */
        IF cEventParent EQ  "INSTANCE":U THEN
            ASSIGN ryc_ui_event.constant_value = NO
                   NO-ERROR.
        ELSE
            ASSIGN lConstantValue              = ryc_ui_event.constant_value
                   ryc_ui_event.constant_value = phUiEventBuffer:BUFFER-FIELD("tConstantValue":U):BUFFER-VALUE
                   NO-ERROR.
    
        VALIDATE ryc_ui_event NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
        DO:
            ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U) + RETURN-VALUE.
            hQuery:GET-NEXT().
            NEXT.
        END.    /* validation error */

        IF ryc_ui_event.constant_value AND
           NOT lConstantValue                 THEN
        DO:
            FOR EACH ryc_smartObject WHERE
                     ryc_smartObject.object_type_obj = dObjectTypeObj AND
                     ryc_smartObject.smartObject_obj = dSmartObjectObj
                     NO-LOCK:
                /* If the constant value is set at the class level, delete all of 
                 * the master attribute value as well as the instance attribute values. */
                IF cEventParent EQ "CLASS":U THEN
                FOR EACH rycui_delete WHERE
                         rycui_delete.object_type_obj           = ryc_smartobject.object_type_obj  AND
                         rycui_delete.smartObject_obj           = ryc_smartobject.smartObject_obj  AND
                         rycui_delete.object_instance_obj       = 0                                AND
                         rycui_delete.event_name                = cEventName                       AND
                         rycui_delete.container_smartObject_obj = 0
                         EXCLUSIVE-LOCK:
                    DELETE rycui_delete NO-ERROR.
                    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
                        ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U) + RETURN-VALUE.
                END.    /* each attribute value to delete */

                /* Always delete the instance attribute values, since the constant value flag
                 * will always be set at a parent level.                                     */
                FOR EACH ryc_object_instance WHERE
                         ryc_object_instance.smartObject_obj = ryc_smartobject.smartObject_obj
                         NO-LOCK:
                    FOR EACH rycui_delete WHERE
                             rycui_delete.object_type_obj           = ryc_smartobject.object_type_obj          AND
                             rycui_delete.smartObject_obj           = ryc_smartobject.smartObject_obj          AND
                             rycui_delete.object_instance_obj       = ryc_object_instance.object_instance_obj  AND
                             rycui_delete.event_name                = cEventName                               AND
                             rycui_delete.container_smartObject_obj = ryc_object_instance.container_smartObject_obj
                             EXCLUSIVE-LOCK:
                        DELETE rycui_delete NO-ERROR.
                        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
                            ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U) + RETURN-VALUE.
                    END.    /* each attribute value to delete */
                END.    /* each object instance for a smartobject. */
            END.    /* each smartobject */
        END.    /* the constant value flag is set. */

        hQuery:GET-NEXT().
    END.    /* each record */

    hQuery:QUERY-CLOSE().
    DELETE OBJECT hQuery.
    ASSIGN hQuery = ?.

    DELETE WIDGET-POOL "insertUiEvents":U.
    &ENDIF
    
    RETURN cMessageList.
END PROCEDURE.  /* insertUiEvent */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Include 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RETURN.
END PROCEDURE.  /* plipShutdown */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE registerSdoFields Include 
PROCEDURE registerSdoFields :
/*------------------------------------------------------------------------------
  Purpose:     Obsolete procedure - it ensured that any values for certain 
               properties which are changed on an SDO are stored in the Repository.
  Parameters:  pcDataObjectName        - the name of the SDO whose fields to register
               pcFieldsAtInstanceLevel - a CSV list of field names whose attributes
                                         are to be stored at the instance level.
                                         
  Notes:       This procedure is now obsolete.  Changed are not allowed to 
               SDO fields, changes need to be made to DataField master objects 
               through DataField maintenance.  
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcDataObjectName         AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcFieldsAtInstanceLevel  AS CHARACTER        NO-UNDO.

    RETURN ERROR "registerSDOFields is obsolete":U.

END PROCEDURE.  /* registerSdoFields */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeAttributeValues Include 
PROCEDURE removeAttributeValues :
/*------------------------------------------------------------------------------
  Purpose:     Removes attribute values.
  Parameters:  INPUT ttAttributeValue
  Notes:       * The buffer used in this API is based on the TT defined in
                 ry/inc/ryrepatset.i
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER phAttributeValueBuffer   AS HANDLE           NO-UNDO.
    DEFINE INPUT PARAMETER TABLE-HANDLE phAttributeValueTable.

    DEFINE VARIABLE cMessageList                AS CHARACTER            NO-UNDO.

    &IF DEFINED(Server-Side) EQ 0 &THEN
    IF NOT VALID-HANDLE(phAttributeValueTable) THEN
        ASSIGN phAttributeValueTable  = phAttributeValueBuffer:TABLE-HANDLE
               phAttributeValueBuffer = ?
               .
    {dynlaunch.i
        &PLip  = 'RepositoryDesignManager'
        &IProc = 'removeAttributeValues'
                       
        &mode1 = INPUT &parm1 = phAttributeValueBuffer &datatype1 = HANDLE
        &mode2 = INPUT &parm2 = phAttributeValueTable  &datatype2 = TABLE-HANDLE
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
    DEFINE VARIABLE dObjectTypeObj              AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dSmartObjectObj             AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dContainerSmartObjectObj    AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dObjectInstanceObj          AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dAttributeParentObj         AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE hQuery                      AS HANDLE               NO-UNDO.    
    DEFINE VARIABLE cAttributeParent            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cAttributeLabel             AS CHARACTER            NO-UNDO.

    DEFINE BUFFER ryc_attribute             FOR ryc_attribute.
    DEFINE BUFFER ryc_attribute_value       FOR ryc_attribute_value.
    DEFINE BUFFER gsc_object_type           FOR gsc_object_type.
    DEFINE BUFFER ryc_smartObject           FOR ryc_smartObject.
    DEFINE BUFFER ryc_object_instance       FOR ryc_object_instance.

    IF VALID-HANDLE(phAttributeValueTable) THEN
        ASSIGN phAttributeValueBuffer = phAttributeValueTable:DEFAULT-BUFFER-HANDLE.

    IF VALID-HANDLE(phAttributeValueBuffer) AND phAttributeValueBuffer:TYPE NE "BUFFER":U THEN
        ASSIGN phAttributeValueBuffer = phAttributeValueBuffer:DEFAULT-BUFFER-HANDLE.

    CREATE WIDGET-POOL "removeAttributeValues":U.
    CREATE QUERY hQuery IN WIDGET-POOL "removeAttributeValues":U.
    hQuery:ADD-BUFFER(phAttributeValueBuffer).

    hQuery:QUERY-PREPARE(" FOR EACH ":U + phAttributeValueBuffer:NAME + " BY ":U +  phAttributeValueBuffer:NAME + ".tAttributeParentObj":U).

    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST().

    DO WHILE phAttributeValueBuffer:AVAILABLE:
        /** Find the attribute's parent record. 
         *  ----------------------------------------------------------------------- **/
        IF dAttributeParentObj NE phAttributeValueBuffer:BUFFER-FIELD("tAttributeParentObj":U):BUFFER-VALUE THEN
        DO:
            ASSIGN dAttributeParentObj = phAttributeValueBuffer:BUFFER-FIELD("tAttributeParentObj":U):BUFFER-VALUE
                   cAttributeParent    = phAttributeValueBuffer:BUFFER-FIELD("tAttributeParent":U):BUFFER-VALUE
                   NO-ERROR.
            CASE cAttributeParent:
                WHEN "CLASS":U THEN
                DO:
                    FIND FIRST gsc_object_type WHERE
                               gsc_object_type.object_type_obj = dAttributeParentObj
                               NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE gsc_object_type THEN
                    DO:                  
                        ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                            + {aferrortxt.i 'AF' '5' 'gsc_object_type' '?' '"class"' 'STRING(dAttributeParentObj)'}.
                        hQuery:GET-NEXT().
                        NEXT.
                    END.     /* error */

                    ASSIGN dObjectTypeObj           = gsc_object_type.object_type_obj
                           dSmartObjectObj          = 0
                           dContainerSmartObjectObj = 0
                           dObjectInstanceObj       = 0
                           .
                END.    /* class */
                WHEN "MASTER":U THEN
                DO:
                    FIND FIRST ryc_smartObject WHERE
                               ryc_smartObject.smartObject_obj = dAttributeParentObj
                               NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE ryc_smartObject THEN
                    DO:
                        ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                            + {aferrortxt.i 'AF' '5' 'ryc_smartObject' '?' '"master smartobject"' 'STRING(dAttributeParentObj)'}.
                        hQuery:GET-NEXT().
                        NEXT.
                    END.     /* error */

                    ASSIGN dObjectTypeObj           = ryc_smartObject.object_type_obj
                           dSmartObjectObj          = ryc_smartObject.smartObject_obj
                           dContainerSmartObjectObj = 0
                           dObjectInstanceObj       = 0
                           .
                END.    /* master */
                WHEN "INSTANCE":U THEN
                DO:
                    FIND FIRST ryc_object_instance WHERE
                               ryc_object_instance.object_instance_obj = dAttributeParentObj
                               NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE ryc_object_instance THEN
                    DO:
                        ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                            + {aferrortxt.i 'AF' '5' 'ryc_object_instance' '?' '"smartobject instance"' 'STRING(dAttributeParentObj)'}.
                        hQuery:GET-NEXT().
                        NEXT.
                    END.     /* error */

                    FIND FIRST ryc_smartObject WHERE
                               ryc_smartObject.smartObject_obj = ryc_object_instance.smartObject_obj
                               NO-LOCK NO-ERROR.

                    ASSIGN dObjectTypeObj           = ryc_smartObject.object_type_obj
                           dSmartObjectObj          = ryc_object_instance.smartObject_obj
                           dContainerSmartObjectObj = ryc_object_instance.container_smartObject_obj
                           dObjectInstanceObj       = ryc_object_instance.object_instance_obj
                           .
                END.    /* instance*/
                OTHERWISE
                DO:
                    ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                        +  {aferrortxt.i 'AF' '5' '?' '?' '"attribute parent"' '"The attribute parent must be one of: CLASS, MASTER or INSTANCE."'}.
                    hQuery:GET-NEXT().
                    NEXT.
                END.    /* error */
            END CASE.   /* attribute parent */
        END.    /* new parent */

        /** Make sure that we are allowed to update this attribute value.
         *  ----------------------------------------------------------------------- **/
        ASSIGN cAttributeLabel = phAttributeValueBuffer:BUFFER-FIELD("tAttributeLabel":U):BUFFER-VALUE NO-ERROR.
        FIND FIRST ryc_attribute WHERE
                   ryc_attribute.attribute_Label = cAttributeLabel
                   NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ryc_attribute THEN
        DO:
            ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                +  {aferrortxt.i 'AF' '5' 'ryc_attribute' 'attribute_Label' '"attribute label"' 'cAttributeLabel' }.
            hQuery:GET-NEXT().
            NEXT.
        END.    /* error */
                
        FIND FIRST ryc_attribute_value WHERE
                   ryc_attribute_value.object_type_obj           = dObjectTypeObj               AND
                   ryc_attribute_value.smartObject_obj           = dSmartObjectObj              AND
                   ryc_attribute_value.object_instance_obj       = dObjectInstanceObj           AND
                   ryc_attribute_value.container_smartObject_obj = dContainerSmartObjectObj     AND
                   ryc_attribute_value.attribute_Label           = ryc_attribute.attribute_Label
                   EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED ryc_attribute_value THEN
        DO:
            ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                +  {aferrortxt.i 'AF' '103' 'ryc_attribute_value' '?' "'update the attribute value ' + cAttributeLabel " }.
            hQuery:GET-NEXT().
            NEXT.
        END.    /* error */

        IF AVAILABLE ryc_attribute_value  THEN
        DO:
            DELETE ryc_attribute_value NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
            DO:
                ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U) + RETURN-VALUE.
                hQuery:GET-NEXT().
                NEXT.
            END.    /* validation error */
        END.    /* available attribute value */

        hQuery:GET-NEXT().
    END.    /* each record */

    hQuery:QUERY-CLOSE().
    DELETE OBJECT hQuery.
    ASSIGN hQuery = ?.

    DELETE WIDGET-POOL "removeAttributeValues":U.
    &ENDIF
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN cMessageList.
END PROCEDURE.  /* removeAttributeValues */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeDefaultAttrValues Include 
PROCEDURE removeDefaultAttrValues :
/*------------------------------------------------------------------------------
  Purpose:     Removes default attribute values for an object file or object 
               type.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectFileName AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plRemoveDefaultAttr AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plRemoveNonOTAttr   AS LOGICAL    NO-UNDO.

  /* No-op... if both logicals are no we have nothing to do */
  IF NOT plRemoveDefaultAttr AND
     NOT plRemoveNonOTAttr THEN
    RETURN.
  
  &IF DEFINED(Server-Side) EQ 0 &THEN    
  { dynlaunch.i &PLIP              = "'RepositoryDesignManager'"
                &iProc             = "'removeDefaultAttrValues'"
               &mode1  = INPUT  &parm1  = pcObjectFileName            &dataType1  = CHARACTER
               &mode2  = INPUT  &parm2  = plRemoveDefaultAttr         &dataType2  = LOGICAL
               &mode3  = INPUT  &parm3  = plRemoveNonOTAttr           &dataType3  = LOGICAL
  }
  IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.   
  &ELSE   
  DEFINE VARIABLE lDelete                  AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE hOTTable                 AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hOTBuffer                AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hAttrBuff                AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hAttrField               AS HANDLE       NO-UNDO.
  DEFINE VARIABLE iDataType                AS INTEGER      NO-UNDO.
  DEFINE VARIABLE cField                   AS CHARACTER  
    INITIAL "character_value,date_value,logical_value,integer_value,decimal_value,character_value,character_value,raw_value,character_value,character_value":U
    NO-UNDO.

  DEFINE BUFFER bobject_attribute_value    FOR ryc_attribute_value.
  DEFINE BUFFER bryc_smartobject           FOR ryc_smartobject.
  DEFINE BUFFER bryc_object_instance       FOR ryc_object_instance.
  DEFINE BUFFER bryc_attribute_value       FOR ryc_attribute_value.
  DEFINE BUFFER bryc_attribute             FOR ryc_attribute.
  DEFINE BUFFER bgsc_object_type           FOR gsc_object_type.

  /* First try and find the object that we are going to change */
  FIND FIRST bryc_smartobject NO-LOCK 
    WHERE bryc_smartobject.object_filename          = pcObjectFileName
      AND bryc_smartobject.customization_result_obj = 0.0
    NO-ERROR.
  IF NOT AVAILABLE(bryc_smartobject) THEN
    RETURN {aferrortxt.i 'RY' '01' '?' '?' pcObjectFileName}.

  /* Now find the old object type that we need to work with */
  FIND FIRST bgsc_object_type NO-LOCK
    WHERE bgsc_object_type.object_type_obj = bryc_smartobject.object_type_obj 
    NO-ERROR.
  IF NOT AVAILABLE(bgsc_object_type) THEN
    RETURN {aferrortxt.i 'RY' '04' '?' '?' STRING(bryc_smartobject.object_type_obj)}.

  /* Now build a temp-table for this object type */
  CREATE TEMP-TABLE hOTTable.

  /* Add a field for the object_filename */
  hOTTable:ADD-LIKE-FIELD("object_filename":U, "ryc_smartobject.object_filename":U).

  /* Add attributes for this object and all its parents */
  RUN addParentOTAttrs(bgsc_object_type.object_type_obj, hOTTable).

  /* Add a unique index on the object file name */
  hOTTable:ADD-NEW-INDEX("pudx",true,true).
  hOTTable:ADD-INDEX-FIELD("pudx","object_filename":U).

  /* Prepare the temp-table */
  hOTTable:TEMP-TABLE-PREPARE("tt_" + bgsc_object_type.object_type_code).

  /* Get the buffer handle for the object type handle */
  hOTBuffer = hOTTable:DEFAULT-BUFFER-HANDLE.

  hAttrBuff = BUFFER bryc_attribute_value:HANDLE.
  /* Now loop through each ryc_smartobject for this object type. */
  FOR EACH bryc_smartobject NO-LOCK
    WHERE bryc_smartobject.object_filename = pcObjectFileName:

    /* Add a record to the buffer for the current smartobject. */
    hOTBuffer:BUFFER-CREATE().
    hOTBuffer:BUFFER-FIELD("object_filename"):BUFFER-VALUE = bryc_smartobject.object_filename.

    /* Loop through all the attributes that belong to this object. */
    FOR EACH bryc_attribute_value EXCLUSIVE-LOCK
      WHERE bryc_attribute_value.object_type_obj           = bryc_smartobject.object_type_obj
        AND bryc_attribute_value.smartobject_obj           = bryc_smartobject.smartobject_obj
        AND bryc_attribute_value.object_instance_obj       = 0
        AND bryc_attribute_value.container_smartobject_obj = 0:
      
      /* Find the attribute record */
      FIND FIRST bryc_attribute NO-LOCK
        WHERE bryc_attribute.attribute_label = bryc_attribute_value.attribute_label
        NO-ERROR.

      /* If there is no attribute record, the attribute value should not be here. Delete it */
      IF NOT AVAILABLE(bryc_attribute) THEN
      DO:
        DELETE bryc_attribute_value.
        NEXT.
      END.

      /* There should be a field in the object cache for this attribute. Get a handle to it */
      hAttrField = hOTBuffer:BUFFER-FIELD(bryc_attribute_value.attribute_label) NO-ERROR.
      ERROR-STATUS:ERROR = NO.

      /* If the handle is invalid, this attribute is not defined at the class level. That means
         it should not exist at the object level either */
      IF NOT VALID-HANDLE(hAttrField) THEN
      DO:
        IF plRemoveNonOTAttr THEN
          DELETE bryc_attribute_value.
        NEXT.
      END.

      /* Make sure we have a valid data type to check against */
      iDataType = bryc_attribute.data_type.
      IF iDataType < 1 OR
         iDataType > 10 THEN
        iDataType = 1.


      /* If the buffer values match on the attribute value and the temp-table field, we can 
         delete the attribute value field */
      IF hAttrField:BUFFER-VALUE = hAttrBuff:BUFFER-FIELD(ENTRY(iDataType,cField)):BUFFER-VALUE THEN
      DO:
        IF plRemoveDefaultAttr THEN
          DELETE bryc_attribute_value.
        NEXT.
      END.
      ELSE
        /* Otherwise we set the temp-table field to have the master's value in it so that we
           can use this when we go through the instances */
        hAttrField:BUFFER-VALUE = hAttrBuff:BUFFER-FIELD(ENTRY(iDataType,cField)):BUFFER-VALUE.

    END. /* FOR EACH bryc_attribute_value NO-LOCK */
    
    FOR EACH bryc_object_instance NO-LOCK
      WHERE bryc_object_instance.smartobject_obj = bryc_smartobject.smartobject_obj:
      
      /* Loop through all the attribute values for the object instance */
      FOR EACH bryc_attribute_value EXCLUSIVE-LOCK
        WHERE bryc_attribute_value.object_type_obj           = bryc_smartobject.object_type_obj
          AND bryc_attribute_value.smartobject_obj           = bryc_smartobject.smartobject_obj
          AND bryc_attribute_value.object_instance_obj       = bryc_object_instance.object_instance_obj
          AND bryc_attribute_value.container_smartobject_obj = bryc_object_instance.container_smartobject_obj:
        
        /* Find the attribute record */
        FIND FIRST bryc_attribute NO-LOCK
          WHERE bryc_attribute.attribute_label = bryc_attribute_value.attribute_label
          NO-ERROR.

        /* If there is no attribute record, the attribute value should not be here. Delete it */
        IF NOT AVAILABLE(bryc_attribute) THEN
        DO:
          DELETE bryc_attribute_value.
          NEXT.
        END.

        /* There should be a field in the object cache for this attribute. Get a handle to it */
        hAttrField = hOTBuffer:BUFFER-FIELD(bryc_attribute_value.attribute_label) NO-ERROR.
        ERROR-STATUS:ERROR = NO.

        /* If the handle is invalid, this attribute is not defined at the class level. That means
           it should not exist at the object instance level either */
        IF NOT VALID-HANDLE(hAttrField) THEN
        DO:
          IF plRemoveNonOTAttr THEN
            DELETE bryc_attribute_value.
          NEXT.
        END.

        /* Make sure we have a valid data type to check against */
        iDataType = bryc_attribute.data_type.
        IF iDataType < 1 OR
           iDataType > 10 THEN
          iDataType = 1.


        /* If the buffer values match on the attribute value and the temp-table field, we can 
           delete the attribute value field */
        IF hAttrField:BUFFER-VALUE = hAttrBuff:BUFFER-FIELD(ENTRY(iDataType,cField)):BUFFER-VALUE THEN
        DO:
          IF plRemoveDefaultAttr THEN
            DELETE bryc_attribute_value.
          NEXT.
        END.

      END. /* FOR EACH bryc_attribute_value NO-LOCK */

    END. /* FOR EACH bryc_object_instance NO-LOCK */

    /* Make sure we delete the record out of the cache temp-table. We only needed it long enough to clean up */
    hOTBuffer:BUFFER-DELETE().
  
  END. /* FOR EACH bryc_smartobject NO-LOCK */

  DELETE OBJECT hOTTable.
  &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeInstances Include 
PROCEDURE removeInstances :
/*------------------------------------------------------------------------------
 Purpose:     Removes all instances of an object (all instances due to a different
              result codes) from a container given the instance obj of one of them.
  Parameters:  pdInstanceObj

  Notes:     Given an instance obj of an object, this procedure finds both the 
             container name and the object name of the instance.  It then calls
             removeObjectInstance to delete the instance and all of its sister
             instances (instances of the same object in the container with
             different result codes.)   
                 
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdInstanceObj                AS DECIMAL      NO-UNDO.

    &IF DEFINED(Server-side) EQ 0 &THEN
    {
     dynlaunch.i &PLIP              = "'RepositoryDesignManager'"
                 &iProc             = "'removeInstances'"
                 &compileStaticCall = NO                 
                 &mode1  = INPUT  &parm1  = pdInstanceObj &dataType1  = DECIMAL
    }
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
    
    DEFINE VARIABLE cContainerName                  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cObjectName                     AS CHARACTER            NO-UNDO.

    FIND ryc_object_instance NO-LOCK
        WHERE ryc_object_instance.OBJECT_instance_obj = pdInstanceObj NO-ERROR.
    
    IF NOT AVAILABLE ryc_object_instance THEN RETURN ERROR
        {aferrortxt.i '?' "'Object instance not found.'" }.

    FIND ryc_smartObject NO-LOCK
        WHERE ryc_smartObject.smartObject_obj = ryc_object_instance.container_smartobject_obj.
    cContainerName = ryc_smartObject.object_filename.

    FIND ryc_smartObject NO-LOCK
        WHERE ryc_smartObject.smartObject_obj = ryc_object_instance.smartobject_obj.
    cObjectName = ryc_smartObject.object_filename.

    RUN removeObjectInstance ( INPUT cContainerName,
                               INPUT "{&DEFAULT-RESULT-CODE}":U,
                               INPUT cObjectName,   /* pcInstanceObjectName */
                               INPUT "":U,          /* pcInstanceName       */
                               INPUT "{&ALL-RESULT-CODE}":U   ) NO-ERROR.

    &ENDIF
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeObject Include 
PROCEDURE removeObject :
/*------------------------------------------------------------------------------
  Purpose:     Removes an Object from the Repository.
  Parameters:  pcObjectName -
               pcResultCode - 
  Notes:       * The ryc-smartobject delete trigger deletes the following
                 records associated with the object:
                 - attribute values
                 - menu items
                 - valid object partitions
                 - toolbar menu structures
                 - object menu structures
                 - smartlinks
                 - comments
                 - user allocations
                 - multi-media
               * when deleting an object instance, the attribute values
                 and UI events are deleted for that object instance by
                 the delete triggers.  
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcObjectName         AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcResultCode         AS CHARACTER            NO-UNDO.

    &IF DEFINED(Server-side) EQ 0 &THEN
    {
     dynlaunch.i &PLIP              = "'RepositoryDesignManager'"
                 &iProc             = "'removeObject'"
                 &compileStaticCall = NO
                 &mode1  = INPUT  &parm1  = pcObjectName &dataType1  = CHARACTER
                 &mode2  = INPUT  &parm2  = pcResultCode &dataType2  = CHARACTER
    }
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
    DEFINE VARIABLE dCustomisationResultObj         AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE cCustomizationObjList           AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cContainerObject                AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iLoop                           AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cMessageList                    AS CHARACTER  NO-UNDO.

    DEFINE BUFFER rycso         FOR ryc_smartObject.
    DEFINE BUFFER rycso2        FOR ryc_smartObject.
    DEFINE BUFFER rycpa         FOR ryc_page.
    DEFINE BUFFER rycpo         FOR ryc_page_object.
    DEFINE BUFFER rycoi         FOR ryc_object_instance.

    /** Find the result code
     *  ----------------------------------------------------------------------- **/
    IF pcResultCode EQ "":U THEN
        ASSIGN pcResultCode = "{&DEFAULT-RESULT-CODE}":U.

    IF pcResultCode NE "{&DEFAULT-RESULT-CODE}":U THEN
    DO:
        FIND FIRST ryc_customization_result WHERE
                   ryc_customization_result.customization_result_code = pcResultCode
                   NO-LOCK NO-ERROR.
        IF AVAILABLE ryc_customization_result THEN
            ASSIGN dCustomisationResultObj = ryc_customization_result.customization_result_Obj
                   cCustomizationObjList   = STRING(dCustomisationResultObj).
        ELSE
            RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'Customization Result'" pcResultCode}.
    END.    /* find the result code */
    ELSE DO:
       FOR EACH rycso WHERE rycso.object_filename  = pcObjectName NO-LOCK:
          ASSIGN cCustomizationObjList = cCustomizationObjList + (IF cCustomizationObjList = "" THEN "" ELSE CHR(3))
                                                               + STRING(rycso.customization_result_obj).
       END.
    END.

  Trans-Block:
  DO TRANSACTION:
    DO iLoop = 1 TO NUM-ENTRIES(cCustomizationObjList,CHR(3)):
       ASSIGN dCustomisationResultObj = DECIMAL(ENTRY(iLoop,cCustomizationObjList,CHR(3))).
       FIND FIRST rycso WHERE
                  rycso.object_filename          = pcObjectName            AND
                  rycso.customization_result_obj = dCustomisationResultObj
                  NO-LOCK NO-ERROR.
       IF NOT AVAILABLE rycso THEN DO:
           cMessageList = {aferrortxt.i 'AF' '5' '?' '?' "'object: ' + pcObjectName"}.
           UNDO trans-block, LEAVE trans-block.
       END.
       /* Do not attempt to delete this object if it exists as a contained instance. */
       FIND FIRST ryc_object_instance WHERE ryc_object_instance.smartObject_obj = rycso.smartObject_obj NO-LOCK NO-ERROR.
       IF AVAILABLE ryc_object_instance THEN
       DO:
           FIND FIRST rycso2 WHERE rycso2.smartObject_obj = ryc_object_instance.container_smartObject_obj NO-LOCK NO-ERROR.
           cContainerObject = "this object exists as an object instance in at least ".
           IF AVAIL rycso THEN
              cContainerObject = cContainerObject + "container: " + rycso2.OBJECT_filename + " that".
           ELSE
              cContainerObject = cContainerObject + "one container that ".
           cMessageList = {aferrortxt.i 'AF' '101' '?' '?' "'repository object: ' + pcObjectName" cContainerObject}.
           UNDO trans-block, LEAVE trans-block.
       END.
       
       /** Delete Pages and Page Instances, and the object instances that
        *  these page instances refer to.
        *  ----------------------------------------------------------------------- **/
       FOR EACH rycpa WHERE
                rycpa.container_smartObject = rycso.smartObject_obj
                EXCLUSIVE-LOCK:
           FOR EACH rycpo WHERE
                    rycpo.container_smartObject = rycpa.container_smartObject_obj AND
                    rycpo.page_obj              = rycpa.page_obj
                    EXCLUSIVE-LOCK:
               FOR EACH rycoi WHERE
                        rycoi.object_instance_obj = rycpo.object_instance_obj
                        EXCLUSIVE-LOCK:
                   DELETE rycoi NO-ERROR.
                   IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
                   DO:
                      cMessageList = IF RETURN-VALUE <> "" THEN RETURN-VALUE ELSE "Error":U.
                      UNDO trans-block, LEAVE trans-block.
                   END.
               END.    /* object instances */

               DELETE rycpo NO-ERROR.
               IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
               DO:
                  cMessageList = IF RETURN-VALUE <> "" THEN RETURN-VALUE ELSE "Error":U.
                  UNDO trans-block, LEAVE trans-block.
               END.
           END.    /* page objects */

           DELETE rycpa NO-ERROR.
           IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
           DO:
              cMessageList = IF RETURN-VALUE <> "" THEN RETURN-VALUE ELSE "Error":U.
              UNDO trans-block, LEAVE trans-block.
           END.
       END.    /* pages */

       /** Delete contained object instances. These will be the object instances
        *  that are not on a particular page.
        *  ----------------------------------------------------------------------- **/
       FOR EACH rycoi WHERE
                rycoi.container_smartObject_obj = rycso.smartObject_obj
                EXCLUSIVE-LOCK:
           DELETE rycoi NO-ERROR.
           IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
           DO:
              cMessageList = IF RETURN-VALUE <> "" THEN RETURN-VALUE ELSE "Error":U.
              UNDO trans-block, LEAVE trans-block.
           END.
       END.    /* rycoi */

       /** Delete the object itself.
        *  ----------------------------------------------------------------------- **/
       FIND CURRENT rycso EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
       IF LOCKED rycso THEN 
       DO:
         cMessageList = {aferrortxt.i 'AF' '104' '?' '?' "'object: ' + pcObjectName"}.
         UNDO trans-block, LEAVE trans-block.
       END.

       DELETE rycso NO-ERROR.

       IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
       DO:
          cMessageList = IF RETURN-VALUE <> "" THEN RETURN-VALUE ELSE "Error":U.
          UNDO trans-block, LEAVE trans-block.
       END.
    END. /* End iLoop */
  END. /* End Trans-Block */
  IF cMessageList <> "":U THEN 
      RETURN ERROR cMessageList.
  &ENDIF
   
  ASSIGN ERROR-STATUS:ERROR = NO.
  RETURN.
END PROCEDURE.  /* removeObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeObjectInstance Include 
PROCEDURE removeObjectInstance :
/*------------------------------------------------------------------------------
  Purpose:     Removes object instaces from a container.
  Parameters:  pcContainerObjectName -
               pcContainerResultCode -
               pcInstanceObjectName  -
               pcInstanceName        -
               pcInstanceResultCode  -
  Notes:       * In all cases outlined below, the result code passed in will
                 determine which object instances are removed, unless the 
                 ALL-RESULT-CODE value is passed in. In this case all object
                 instances are removed.
               * The ALL-RESULT-CODE cannot be used for the container object.
               * The following rules are used to decide which object instances
                 to delete:
                 - if the pcInstanceName is set and the pcInstanceObjectName is
                   not set, the all object instance records which have the specified
                   instance name will be deleted.
                 - if the pcInstanceName is not set and the pcInstanceObjectName
                   is set, then all instances which have the given object name are removed.
                 - if neither the pcInstanceName or pcInstanceObjectName are set,
                   all object instances for the container are removed.               
                 
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcContainerObjectName        AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pcContainerResultCode        AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pcInstanceObjectName         AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pcInstanceName               AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pcInstanceResultCode         AS CHARACTER    NO-UNDO.   

    &IF DEFINED(Server-side) EQ 0 &THEN
    {
     dynlaunch.i &PLIP              = "'RepositoryDesignManager'"
                 &iProc             = "'removeObjectInstance'"
                 &compileStaticCall = NO                 
                 &mode1  = INPUT  &parm1  = pcContainerObjectName &dataType1  = CHARACTER
                 &mode2  = INPUT  &parm2  = pcContainerResultCode &dataType2  = CHARACTER
                 &mode3  = INPUT  &parm3  = pcInstanceObjectName  &dataType3  = CHARACTER
                 &mode4  = INPUT  &parm4  = pcInstanceName        &dataType4  = CHARACTER
                 &mode5  = INPUT  &parm5  = pcInstanceResultCode  &dataType5  = CHARACTER
    }
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
    DEFINE VARIABLE dContainerResultObj             AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dInstanceResultObj              AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE hInstanceQuery                  AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cQueryWhere                     AS CHARACTER            NO-UNDO.

    DEFINE BUFFER rycso_container       FOR ryc_smartObject.
    DEFINE BUFFER rycso_instance        FOR ryc_smartObject.
    DEFINE BUFFER rycoi                 FOR ryc_object_instance.

    DEFINE QUERY qObjectInstance FOR rycoi, rycso_instance.

    /** Find the container result code
     *  ----------------------------------------------------------------------- **/
    IF pcContainerResultCode EQ "":U THEN
        ASSIGN pcContainerResultCode = "{&DEFAULT-RESULT-CODE}":U.

    IF pcContainerResultCode NE "{&DEFAULT-RESULT-CODE}":U THEN
    DO:
        FIND FIRST ryc_customization_result WHERE
                   ryc_customization_result.customization_result_code = pcContainerResultCode
                   NO-LOCK NO-ERROR.
        IF AVAILABLE ryc_customization_result THEN
            ASSIGN dContainerResultObj = ryc_customization_result.customization_result_Obj.
        ELSE
            RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'Customization Result'" pcContainerResultCode}.
    END.    /* find the result code */
    ELSE
        ASSIGN dContainerResultObj = 0.

    /** Find the instance result code
     *  ----------------------------------------------------------------------- **/
    IF pcInstanceResultCode NE "":U                       AND
       pcInstanceResultCode NE "{&DEFAULT-RESULT-CODE}":U AND
       pcInstanceResultCode NE "{&ALL-RESULT-CODE}":U     THEN
    DO:
        FIND FIRST ryc_customization_result WHERE
                   ryc_customization_result.customization_result_code = pcInstanceResultCode
                   NO-LOCK NO-ERROR.
        IF AVAILABLE ryc_customization_result THEN
            ASSIGN dInstanceResultObj = ryc_customization_result.customization_result_Obj.
        ELSE
            RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'Customization Result'" pcInstanceResultCode}.
    END.    /* find the result code */
    ELSE
        ASSIGN dInstanceResultObj = 0.

    /* Find the container. */
    FIND FIRST rycso_container WHERE
               rycso_container.object_filename          = pcContainerObjectName AND
               rycso_container.customization_result_obj = dContainerResultObj
               NO-LOCK NO-ERROR.
    /* It might be that this is a new container, so do not return an error */
    IF NOT AVAILABLE rycso_container THEN
      RETURN.
    /* Fix for issue #5560 
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'container object: ' + pcContainerObjectName"}.
    */
    /** Remove the instance according the the rules specified above.
     *  ----------------------------------------------------------------------- **/
    IF pcInstanceObjectName NE "":U THEN
    DO:
        FIND FIRST rycso_instance WHERE
                   rycso_instance.object_filename          = pcInstanceObjectName AND
                   rycso_instance.customization_result_obj = dInstanceResultObj
                   NO-LOCK NO-ERROR.
        IF NOT AVAILABLE rycso_instance THEN
            RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'instance object: ' + pcInstanceObjectName"}.
    END.    /* object instance name not blank. */

    ASSIGN hInstanceQuery = QUERY qObjectInstance:HANDLE.

    ASSIGN cQueryWhere = " FOR EACH rycoi WHERE ":U
                       + " rycoi.container_smartObject_obj = ":U + QUOTER(rycso_container.smartObject_obj).

    IF pcInstanceName NE "":U THEN
        ASSIGN cQueryWhere = cQueryWhere + " AND rycoi.instance_name = '":U + pcInstanceName + "' ":U.

    ASSIGN cQueryWhere = cQueryWhere + " EXCLUSIVE-LOCK, ":U
                       + " FIRST rycso_instance WHERE ":U
                       + " rycso_instance.smartObject_obj = rycoi.smartObject_obj ":U.

    IF pcInstanceObjectName NE "":U THEN
        ASSIGN cQueryWhere = cQueryWhere
                           + " AND rycso_instance.object_filename = '":U + pcInstanceObjectName + "' ":U.

    IF pcInstanceResultCode NE "{&ALL-RESULT-CODE}":U THEN
        ASSIGN cQueryWhere = cQueryWhere + " AND rycso_instance.customization_result_obj = ":U + QUOTER(dInstanceResultObj).

    ASSIGN cQueryWhere = cQueryWhere + " NO-LOCK ":U.

    hInstanceQuery:QUERY-PREPARE(cQueryWhere).
    hInstanceQuery:QUERY-OPEN().
    hInstanceQuery:GET-FIRST().

    DO WHILE AVAILABLE rycoi:
        DELETE rycoi NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

        hInstanceQuery:GET-NEXT().
    END.    /* avail rycoi */

    hInstanceQuery:QUERY-CLOSE().
    &ENDIF
                      
    RETURN.
END PROCEDURE.  /* removeObjectInstance */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeUIEvents Include 
PROCEDURE removeUIEvents :
/*------------------------------------------------------------------------------
  Purpose:     Removes UI Events.
  Parameters:  
  Notes:       * The buffer used in this API is based on the TT defined in
                 ry/inc/ryrepatset.i
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER phUiEventBuffer          AS HANDLE           NO-UNDO.
    DEFINE INPUT PARAMETER TABLE-HANDLE phUiEventTable.

    DEFINE VARIABLE cMessageList                AS CHARACTER            NO-UNDO.

    &IF DEFINED(Server-Side) EQ 0 &THEN
    IF NOT VALID-HANDLE(phUiEventTable) THEN
        ASSIGN phUiEventTable  = phUiEventBuffer:TABLE-HANDLE
               phUiEventBuffer = ?
               .
    {dynlaunch.i
        &PLip  = 'RepositoryDesignManager'
        &IProc = 'removeUIEvents'
                       
        &mode1 = INPUT &parm1 = phUiEventBuffer &datatype1 = HANDLE
        &mode2 = INPUT &parm2 = phUiEventTable  &datatype2 = TABLE-HANDLE
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
    DEFINE VARIABLE dObjectTypeObj              AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dSmartObjectObj             AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dContainerSmartObjectObj    AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dObjectInstanceObj          AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dUiEventParentObj           AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE hQuery                      AS HANDLE               NO-UNDO.    
    DEFINE VARIABLE cEventParent                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cEventName                  AS CHARACTER            NO-UNDO.

    DEFINE BUFFER ryc_ui_event              FOR ryc_ui_event.
    DEFINE BUFFER gsc_object_type           FOR gsc_object_type.
    DEFINE BUFFER ryc_smartObject           FOR ryc_smartObject.
    DEFINE BUFFER ryc_object_instance       FOR ryc_object_instance.

    IF VALID-HANDLE(phUiEventTable) THEN
        ASSIGN phUiEventBuffer = phUiEventTable:DEFAULT-BUFFER-HANDLE.

    IF VALID-HANDLE(phUiEventBuffer) AND phUiEventBuffer:TYPE NE "BUFFER":U THEN
        ASSIGN phUiEventBuffer = phUiEventBuffer:DEFAULT-BUFFER-HANDLE.

    CREATE WIDGET-POOL "removeUiEvents":U.
    CREATE QUERY hQuery IN WIDGET-POOL "removeUiEvents":U.
    hQuery:ADD-BUFFER(phUiEventBuffer).

    hQuery:QUERY-PREPARE(" FOR EACH ":U + phUiEventBuffer:NAME + " BY ":U +  phUiEventBuffer:NAME + ".tEventParentObj":U).

    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST().

    DO WHILE phUiEventBuffer:AVAILABLE:
        /** Find the attribute's parent record. 
         *  ----------------------------------------------------------------------- **/
        IF dUiEventParentObj NE phUiEventBuffer:BUFFER-FIELD("tEventParentObj":U):BUFFER-VALUE THEN
        DO:
            ASSIGN dUiEventParentObj = phUiEventBuffer:BUFFER-FIELD("tEventParentObj":U):BUFFER-VALUE
                   cEventParent      = phUiEventBuffer:BUFFER-FIELD("tEventParent":U):BUFFER-VALUE
                   NO-ERROR.
            CASE cEventParent:
                WHEN "CLASS":U THEN
                DO:
                    FIND FIRST gsc_object_type WHERE
                               gsc_object_type.object_type_obj = dUiEventParentObj
                               NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE gsc_object_type THEN
                    DO:                  
                        ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                            + {aferrortxt.i 'AF' '5' 'gsc_object_type' '?' '"class"' 'STRING(dUiEventParentObj)'}.
                        hQuery:GET-NEXT().
                        NEXT.
                    END.     /* error */

                    ASSIGN dObjectTypeObj           = gsc_object_type.object_type_obj
                           dSmartObjectObj          = 0
                           dContainerSmartObjectObj = 0
                           dObjectInstanceObj       = 0
                           .
                END.    /* class */
                WHEN "MASTER":U THEN
                DO:
                    FIND FIRST ryc_smartObject WHERE
                               ryc_smartObject.smartObject_obj = dUiEventParentObj
                               NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE ryc_smartObject THEN
                    DO:
                        ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                            + {aferrortxt.i 'AF' '5' 'ryc_smartObject' '?' '"master smartobject"' 'STRING(dUiEventParentObj)'}.
                        hQuery:GET-NEXT().
                        NEXT.
                    END.     /* error */

                    ASSIGN dObjectTypeObj           = ryc_smartObject.object_type_obj
                           dSmartObjectObj          = ryc_smartObject.smartObject_obj
                           dContainerSmartObjectObj = 0
                           dObjectInstanceObj       = 0
                           .
                END.    /* master */
                WHEN "INSTANCE":U THEN
                DO:
                    FIND FIRST ryc_object_instance WHERE
                               ryc_object_instance.object_instance_obj = dUiEventParentObj
                               NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE ryc_object_instance THEN
                    DO:
                        ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                            + {aferrortxt.i 'AF' '5' 'ryc_object_instance' '?' '"smartobject instance"' 'STRING(dUiEventParentObj)'}.
                        hQuery:GET-NEXT().
                        NEXT.
                    END.     /* error */

                    FIND FIRST ryc_smartObject WHERE
                               ryc_smartObject.smartObject_obj = ryc_object_instance.smartObject_obj
                               NO-LOCK NO-ERROR.

                    ASSIGN dObjectTypeObj           = ryc_smartObject.object_type_obj
                           dSmartObjectObj          = ryc_object_instance.smartObject_obj
                           dContainerSmartObjectObj = ryc_object_instance.container_smartObject_obj
                           dObjectInstanceObj       = ryc_object_instance.object_instance_obj
                           .
                END.    /* instance*/
                OTHERWISE
                DO:
                    ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                        +  {aferrortxt.i 'AF' '5' '?' '?' '"attribute parent"' '"The attribute parent must be one of: CLASS, MASTER or INSTANCE."'}.
                    hQuery:GET-NEXT().
                    NEXT.
                END.    /* error */
            END CASE.   /* attribute parent */
        END.    /* new parent */

        ASSIGN cEventName = phUiEventBuffer:BUFFER-FIELD("tEventName":U):BUFFER-VALUE NO-ERROR.
        FIND FIRST ryc_ui_event WHERE
                   ryc_ui_event.object_type_obj           = dObjectTypeObj               AND
                   ryc_ui_event.smartObject_obj           = dSmartObjectObj              AND
                   ryc_ui_event.object_instance_obj       = dObjectInstanceObj           AND
                   ryc_ui_event.container_smartObject_obj = dContainerSmartObjectObj     AND
                   ryc_ui_event.event_name                = cEventName
                   EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED ryc_ui_event THEN
        DO:
            ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                +  {aferrortxt.i 'AF' '103' 'ryc_ui_event' '?' "'update the UI event ' + cEventName " }.
            hQuery:GET-NEXT().
            NEXT.
        END.    /* error */

        IF AVAILABLE ryc_ui_event  THEN
        DO:
            DELETE ryc_ui_event NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
            DO:
                ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U) + RETURN-VALUE.
                hQuery:GET-NEXT().
                NEXT.
            END.    /* validation error */
        END.    /* available attribute value */

        hQuery:GET-NEXT().
    END.    /* each record */

    hQuery:QUERY-CLOSE().
    DELETE OBJECT hQuery.
    ASSIGN hQuery = ?.

    DELETE WIDGET-POOL "removeUiEvents":U.
    &ENDIF
    
    RETURN cMessageList.
END PROCEDURE.  /* removeUiEvents */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE renameObjectInstance Include 
PROCEDURE renameObjectInstance :
/*------------------------------------------------------------------------------
  Purpose:     Changes the value of the INSTANCE_NAME field on an object instance
               record.
  Parameters:  pdObjectInstanceObj - the object-instance-obj of the record to update.
               pcNewInstanceName   - the new instance-name value.
  Notes:       * This API is only designed to change the value of the instance_name
                 field. All other fields and values realted to an ryc_object_instance
                 record should be updated by means of the insertObjectInstance() API
                 in this Manager.
               * The insertObjectInstance() API cannot be used for this since the
                 instance_name is used to find the ryc_obect_instance record.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdObjectInstanceObj      AS DECIMAL          NO-UNDO.
    DEFINE INPUT PARAMETER pcNewInstanceName        AS CHARACTER        NO-UNDO.

    &IF DEFINED(Server-side) EQ 0 &THEN
    {dynlaunch.i
        &PLIP  = 'RepositoryDesignManager'
        &iProc = 'renameObjectInstance'
        &mode1 = INPUT  &parm1 = pdObjectInstanceObj &dataType1 = DECIMAL
        &mode2 = INPUT  &parm2 = pcNewInstanceName   &dataType2 = CHARACTER
    }
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
    DEFINE BUFFER ryc_object_instance       FOR ryc_object_instance.

    FIND FIRST ryc_object_instance WHERE
               ryc_object_instance.object_instance_obj = pdObjectInstanceObj
               EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
    IF NOT AVAILABLE ryc_object_instance THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' 'ryc_object_instance' '?' '"object instance"'}.

    IF LOCKED ryc_object_instance THEN
        RETURN ERROR {aferrortxt.i 'AF' '104' 'ryc_object_instance' '?' '"update the object instance record"'}.

    ASSIGN ryc_object_instance.instance_name = pcNewInstanceName NO-ERROR.

    VALIDATE ryc_object_instance NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    &ENDIF
           
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* renameObjectInstance */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ripViewAsPhrase Include 
PROCEDURE ripViewAsPhrase :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will step through the VIEW-AS Phrase passed to
               it and strip out all the specific details and ensure that an
               attribute record is created for it.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcViewASPhrase AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iLoop        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cViewASList  AS CHARACTER  NO-UNDO EXTENT 100.
  DEFINE VARIABLE cWidgetType  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWidgetAttr  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPhraseList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQt          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cValue       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOrigViewAs  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAnalProc    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAnalValues  AS CHARACTER  NO-UNDO EXTENT 100.
  DEFINE VARIABLE dHeightChars AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dWidthChars  AS DECIMAL    NO-UNDO.

  ASSIGN cOrigViewAs    = pcViewASPhrase /* Save the original view-as phrase - we might need it later */
         pcViewASPhrase = REPLACE(pcViewASPhrase,CHR(10)," ":U)
         pcViewASPhrase = TRIM(REPLACE(pcViewASPhrase,"VIEW-AS ":U,"":U))
         cWidgetType    = TRIM(ENTRY(1,pcViewASPhrase," ":U)).
  /* Get rid of spaces in LIST-ITEMS/LIST-ITEM-PAIRS/RADIO-BUTTONS etc. */
  DO WHILE INDEX(pcViewASPhrase,", ":U) > 0 OR
           INDEX(pcViewASPhrase," ,":U) > 0:
    ASSIGN pcViewASPhrase = REPLACE(pcViewASPhrase,", ":U,",":U)
           pcViewASPhrase = REPLACE(pcViewASPhrase," ,":U,",":U).
  END.
  /* Replaces spaces in text of TOOLTIPS/LIST-ITEMS etc. */
  DO iLoop = 1 TO LENGTH(pcViewASPhrase):
    IF SUBSTRING(pcViewASPhrase,iLoop,1) = " ":U AND lQt THEN
      SUBSTRING(pcViewASPhrase,iLoop,1) = CHR(2).
    IF ASC(SUBSTRING(pcViewASPhrase,iLoop,1)) = 34 OR
       ASC(SUBSTRING(pcViewASPhrase,iLoop,1)) = 39 THEN
      lQt = IF lQt THEN FALSE ELSE TRUE.
  END.
  
  /* Only do this for allowed VIEW-AS Widgets */
  IF LOOKUP(cWidgetType, gcUSE-SCHEMA-VIEW-AS) = 0 THEN
    RETURN.
  
  DO iLoop = 1 TO NUM-ENTRIES(pcViewASPhrase," ":U):
    cViewASList[iLoop] = TRIM(ENTRY(iLoop,pcViewASPhrase," ":U)).
  END.

  cPhraseList = "":U.
  DO iLoop = 2 TO 100:
    IF cViewASList[iLoop] = "":U THEN
      NEXT.
    ASSIGN cValue      = REPLACE(cViewASList[iLoop],CHR(2)," ":U)
           cValue      = REPLACE(cValue,"'","":U)
           cValue      = REPLACE(cValue,'"',"":U)
           cPhraseList = IF cPhraseList = "":U THEN cValue ELSE cPhraseList + "|":U + cValue.
  END.

  IF cPhraseList = "":U OR cPhraseList = "|":U THEN
    RETURN.

  CASE cWidgetType:
    WHEN "EDITOR":U THEN
      cWidgetAttr = getEditorAttributes(cPhraseList).
    WHEN "COMBO-BOX":U THEN
      cWidgetAttr = getComboBoxAttributes(cPhraseList).
    WHEN "RADIO-SET":U THEN
      cWidgetAttr = getRadioSetAttributes(cPhraseList).
    WHEN "SELECTION-LIST":U THEN
      cWidgetAttr = getSelectionListAttributes(cPhraseList).
  END CASE.
  
  IF cWidgetAttr = "":U THEN
    RETURN.
  DO iLoop = 1 TO NUM-ENTRIES(cWidgetAttr,CHR(4)):
    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = 0
           ttStoreAttribute.tAttributeLabel     = ENTRY(1,ENTRY(iLoop,cWidgetAttr,CHR(4)),"^":U)
           ttStoreAttribute.tConstantValue      = NO.
    CASE ENTRY(2,ENTRY(iLoop,cWidgetAttr,CHR(4)),"^":U):
      WHEN "CHARACTER":U THEN
        ttStoreAttribute.tCharacterValue = ENTRY(3,ENTRY(iLoop,cWidgetAttr,CHR(4)),"^":U).
      WHEN "INTEGER":U THEN
        ttStoreAttribute.tIntegerValue = INTEGER(ENTRY(3,ENTRY(iLoop,cWidgetAttr,CHR(4)),"^":U)).
      WHEN "DECIMAL":U THEN
        ttStoreAttribute.tDecimalValue = DECIMAL(ENTRY(3,ENTRY(iLoop,cWidgetAttr,CHR(4)),"^":U)).
      WHEN "LOGICAL":U THEN
        ttStoreAttribute.tLogicalValue = LOGICAL(ENTRY(3,ENTRY(iLoop,cWidgetAttr,CHR(4)),"^":U)).
    END CASE.
  END.

  /* Ensure we always have a WIDTH-CHARS and HEIGHT-CHARS Attribute to
     ensure compatability with Dynamic Viewers */
  IF NOT CAN-FIND(FIRST ttStoreAttribute
                  WHERE (ttStoreAttribute.tAttributeLabel = "WIDTH-CHARS":U
                  OR     ttStoreAttribute.tAttributeLabel = "HEIGHT-CHARS":U)
                  AND    ttStoreAttribute.tDecimalValue > 0) THEN DO:
    /* We need to run the ANALYSER to predict the Width and Height
       of an Editor or Selection list */
    IF cWidgetType = "EDITOR":U OR
       cWidgetType = "SELECTION-LIST":U THEN DO:
      cAnalProc = SESSION:TEMP-DIR + "dynanal.p":U.
      OUTPUT STREAM stAnalyze TO VALUE(cAnalProc).
      PUT STREAM stAnalyze UNFORMATTED "DEFINE VARIABLE cAnalyse AS CHARACTER NO-UNDO.":U SKIP(1)
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
        IF cAnalValues[1] = "SE":U OR
           cAnalValues[1] = "ED":U THEN DO:
          IMPORT STREAM stAnalyze cAnalValues.
          /* The ANALYZER will always write the values in American format - we should ensure that when we convert 
             it to DECIMAL that we use the correct NUMERIC-DECIMAL-POINT  - ISSUE #7251 */
          ASSIGN dWidthChars  = DECIMAL(REPLACE(cAnalValues[5],".":U,SESSION:NUMERIC-DECIMAL-POINT)) NO-ERROR.
          IF ERROR-STATUS:ERROR OR
             dWidthChars = ? THEN
          ASSIGN dWidthChars = 0.

          /* The ANALYZER will always write the values in American format - we should ensure that when we convert 
             it to DECIMAL that we use the correct NUMERIC-DECIMAL-POINT  - ISSUE #7251 */
          ASSIGN dHeightChars = DECIMAL(REPLACE(cAnalValues[6],".":U,SESSION:NUMERIC-DECIMAL-POINT)) NO-ERROR.
          IF ERROR-STATUS:ERROR OR
             dHeightChars = ? THEN
          ASSIGN dHeightChars = 0.

          /* We know that the Width and Height is stored in field 5 and 6 */
          LEAVE ANALIZER_BLOCK.
        END.
      END.
      INPUT STREAM stAnalyze CLOSE.
      /* Remove physical files on disk */
      OS-DELETE VALUE(cAnalProc).
      OS-DELETE VALUE(REPLACE(cAnalProc,".p":U,".anl":U)).
      
      /* Add new attributes to store height and width */
      IF dWidthChars <> 0 THEN DO:
        FIND FIRST ttStoreAttribute
             WHERE ttStoreAttribute.tAttributeLabel = "WIDTH-CHARS":U
             EXCLUSIVE-LOCK.
        IF NOT AVAILABLE ttStoreAttribute THEN DO:
          CREATE ttStoreAttribute.
          ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                 ttStoreAttribute.tAttributeParentObj = 0
                 ttStoreAttribute.tAttributeLabel     = "WIDTH-CHARS":U
                 ttStoreAttribute.tConstantValue      = NO.
        END.
        ASSIGN ttStoreAttribute.tDecimalValue = dWidthChars.
      END.
      IF dHeightChars <> 0 THEN DO:
         FIND FIRST ttStoreAttribute
              WHERE ttStoreAttribute.tAttributeLabel = "HEIGHT-CHARS":U
              EXCLUSIVE-LOCK.
        IF NOT AVAILABLE ttStoreAttribute THEN DO:
          CREATE ttStoreAttribute.
          ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                 ttStoreAttribute.tAttributeParentObj = 0
                 ttStoreAttribute.tAttributeLabel     = "HEIGHT-CHARS":U
                 ttStoreAttribute.tConstantValue      = NO.
        END.
        ASSIGN ttStoreAttribute.tDecimalValue = dHeightChars.
      END.
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverRetrieveClassExtInfo Include 
PROCEDURE serverRetrieveClassExtInfo :
/*------------------------------------------------------------------------------
  Purpose:     Returns tables with the exteneded class information in them to 
               a caller.
  Parameters:  pcClassName     -
               phClassExtTable -
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcClassName             AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER phClassExtTable         AS HANDLE           NO-UNDO. 

    EMPTY TEMP-TABLE ttClassExtInformation.

    /* Create the extended class information. */
    RUN bufferRetrieveClassExtInfo ( INPUT pcClassName ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

    ASSIGN phClassExtTable = TEMP-TABLE ttClassExtInformation:HANDLE.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* serverRetrieveClassExtInfo */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildDataFieldAttribute Include 
FUNCTION buildDataFieldAttribute RETURNS LOGICAL
    ( INPUT phAttributeBuffer       AS HANDLE,
      INPUT plForceOverride         AS LOGICAL,
      INPUT pcPrimaryFieldName      AS CHARACTER,
      INPUT pcSecondaryFieldName    AS CHARACTER,
      INPUT pcNewCharacterValue     AS CHARACTER  ) :
/*------------------------------------------------------------------------------
  Purpose:  Builds records in the ttStoreAttribute TT.
    Notes:  * This function is PRIVATE to the Repository Design Manager. It is
              not intended for use outside of the context of generateDataFields().
            * The primary field is the SCHEMA-* field (SCHEMA-FORMAT say) and the
              secondary field is the field that the visual objects use (eg FORMAT).
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hPrimaryField               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hSecondaryField             AS HANDLE               NO-UNDO.

    IF VALID-HANDLE(phAttributeBuffer) AND phAttributeBuffer:AVAILABLE THEN
    DO:
        ASSIGN hPrimaryField   = phAttributeBuffer:BUFFER-FIELD(pcPrimaryFieldName) NO-ERROR.
        ASSIGN hSecondaryField = phAttributeBuffer:BUFFER-FIELD(pcSecondaryFieldName) NO-ERROR.

        IF VALID-HANDLE(hPrimaryField) THEN
        DO:
            CREATE ttStoreAttribute.
            ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                   ttStoreAttribute.tAttributeParentObj = 0
                   ttStoreAttribute.tAttributeLabel     = pcPrimaryFieldName
                   ttStoreAttribute.tConstantValue      = YES.
            CASE hPrimaryField:DATA-TYPE:
                WHEN "DECIMAL":U THEN ASSIGN ttStoreAttribute.tDecimalValue = DECIMAL(pcNewCharacterValue) NO-ERROR.
                WHEN "INTEGER":U THEN ASSIGN ttStoreAttribute.tIntegerValue = INTEGER(pcNewCharacterValue) NO-ERROR.
                WHEN "DATE":U    THEN ASSIGN ttStoreAttribute.tDateValue    = DATE(pcNewCharacterValue) NO-ERROR.
                WHEN "LOGICAL":U THEN ASSIGN ttStoreAttribute.tLogicalValue = LOGICAL(pcNewCharacterValue) NO-ERROR.
                OTHERWISE ASSIGN ttStoreAttribute.tCharacterValue = pcNewCharacterValue.
            END CASE.   /* data type */                  

            IF VALID-HANDLE(hSecondaryField)                                 AND
               (plForceOverride                                         OR
                hSecondaryField:BUFFER-VALUE EQ hPrimaryField:BUFFER-VALUE ) THEN
            DO:
                CREATE ttStoreAttribute.
                ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
                       ttStoreAttribute.tAttributeParentObj = 0
                       ttStoreAttribute.tAttributeLabel     = pcSecondaryFieldName
                       ttStoreAttribute.tConstantValue      = NO.
                CASE hPrimaryField:DATA-TYPE:
                    WHEN "DECIMAL":U THEN ASSIGN ttStoreAttribute.tDecimalValue = DECIMAL(pcNewCharacterValue) NO-ERROR.
                    WHEN "INTEGER":U THEN ASSIGN ttStoreAttribute.tIntegerValue = INTEGER(pcNewCharacterValue) NO-ERROR.
                    WHEN "DATE":U    THEN ASSIGN ttStoreAttribute.tDateValue    = DATE(pcNewCharacterValue) NO-ERROR.
                    WHEN "LOGICAL":U THEN ASSIGN ttStoreAttribute.tLogicalValue = LOGICAL(pcNewCharacterValue) NO-ERROR.
                    OTHERWISE ASSIGN ttStoreAttribute.tCharacterValue = pcNewCharacterValue.
                END CASE.   /* data type */
            END.    /* need to update secondary field. */
        END.    /* valid buffer for primary field */
    END.    /* valid attribute buffer */

    RETURN TRUE.
END FUNCTION.   /* buildDataFieldAttribute */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cacheClassExtInfo Include 
FUNCTION cacheClassExtInfo RETURNS LOGICAL
    ( INPUT pcClassName     AS CHARACTER    ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hClassBuffer        AS HANDLE                       NO-UNDO.

    /* Check whether this class' extended information has already been cached. */
    FIND FIRST ttClassExtInformation WHERE
               ttClassExtInformation.tClassName = pcClassName
               NO-ERROR.
    IF NOT AVAILABLE ttClassExtInformation THEN
    DO:
        /* First we make sure that the (runtime) class information is in the cache, both
         * client and server side. This procedure does potentially involve making 2 AppServer
         * calls, but since this is a design only API, and since the class may already be
         * cached there will in most cases only be aince AppServer hit casused by retrieving the
         * extended information.                                                                  */
        ASSIGN hClassBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN gshRepositoryManager,
                                               INPUT pcClassName).
        IF NOT hClassBuffer:AVAILABLE THEN
            RETURN FALSE.

        IF DYNAMIC-FUNCTION("isConnected":U, INPUT "ICFDB":U) THEN
            RUN bufferRetrieveClassExtInfo ( INPUT pcClassName ) NO-ERROR.
        ELSE
            RUN doServerRetrieveClassExtInfo ( INPUT pcClassName ) NO-ERROR.

        /* Check for errors. */
        IF RETURN-VALUE NE "":U OR ERROR-STATUS:ERROR THEN RETURN FALSE.

        /* Check that we have the relevant information. */
        FIND FIRST ttClassExtInformation WHERE
                   ttClassExtInformation.tClassName = pcClassName
                   NO-ERROR.
        IF NOT AVAILABLE ttClassExtInformation THEN
            RETURN FALSE.
    END.    /* Extended class info not available */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN TRUE. 
END FUNCTION.   /* cacheClassExtInfo */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cleanStoreAttributeValues Include 
FUNCTION cleanStoreAttributeValues RETURNS LOGICAL
    ( INPUT pcObjectName                AS CHARACTER,
      INPUT pcClassName                 AS CHARACTER,
      INPUT pcCleanToLevel              AS CHARACTER,
      INPUT phStoreAttributeBuffer      AS HANDLE       ) :
/*------------------------------------------------------------------------------
  Purpose:  Cleans up the ttStoreAttribute TT.
    Notes: * We need to compare default values set at the class and master object 
             level to ensure that we do not add attributes at instance level that
             will cause unnecessary duplication of values.
           * pcCleanToLevel - MASTER, CLASS: Master used when validating instances
                              and CLASS used when validating Masters.
           * pcClassName - only required when pcCleanToLevel is CLASS.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cAttributeName                  AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE hAttributeField                 AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hObjectBuffer                   AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer                AS HANDLE           NO-UNDO.
    DEFINE VARIABLE dInstanceId                     AS DECIMAL          NO-UNDO.
    DEFINE VARIABLE lDeleteRecord                   AS LOGICAL          NO-UNDO.

    IF NOT VALID-HANDLE(phStoreAttributeBuffer) THEN
        RETURN FALSE.

    /* Get the Master Object from the cache. */
    IF pcCleanToLevel EQ "CLASS":U THEN
    DO:
        /* Use the object buffer for classes - just saves defining another variable. */
        ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN gshRepositoryManager, INPUT pcClassName).

        IF hObjectBuffer:AVAILABLE THEN
        DO:
            ASSIGN hAttributeBuffer = hObjectBuffer:BUFFER-FIELD("ClassBufferHandle":U):BUFFER-VALUE.
            
            hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(0) ) NO-ERROR.
            IF NOT hAttributeBuffer:AVAILABLE THEN            
                hAttributeBuffer:BUFFER-CREATE().
        END.    /* available ttClass */
    END.    /* clear to class */
    ELSE
    DO:
        DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                         INPUT pcObjectName, INPUT "{&DEFAULT-RESULT-CODE}":U, INPUT ?, INPUT NO).

        ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?).

        IF hObjectBuffer:AVAILABLE THEN
        DO:
            ASSIGN hAttributeBuffer = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE.

            ASSIGN dInstanceId = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE.
            hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(dInstanceId) ).
        END.    /* clean to class */
    END.    /* clean to master */

    IF hAttributeBuffer:AVAILABLE THEN
    DO:
        IF NOT VALID-HANDLE(ghQuery4) THEN
            CREATE QUERY ghQuery4.

        ghQuery4:SET-BUFFERS(phStoreAttributeBuffer).

        /* Use PRESELECT since we may delete some of the records in the TT. */
        ghQuery4:QUERY-PREPARE(" PRESELECT EACH ":U + phStoreAttributeBuffer:NAME).
        ghQuery4:QUERY-OPEN().
        
        ghQuery4:GET-FIRST().
        DO WHILE phStoreAttributeBuffer:AVAILABLE:
            ASSIGN cAttributeName = phStoreAttributeBuffer:BUFFER-FIELD("tAttributeLabel":U):BUFFER-VALUE
                   lDeleteRecord  = NO.

            ASSIGN hAttributeField = hAttributeBuffer:BUFFER-FIELD(cAttributeName) NO-ERROR.
            IF VALID-HANDLE(hAttributeField) THEN
            DO:
                CASE hAttributeField:DATA-TYPE:
                    WHEN "LOGICAL":U THEN
                        ASSIGN lDeleteRecord = (hAttributeField:BUFFER-VALUE EQ phStoreAttributeBuffer:BUFFER-FIELD("tLogicalValue":U):BUFFER-VALUE).
                    WHEN "DATE":U THEN
                        ASSIGN lDeleteRecord = (hAttributeField:BUFFER-VALUE EQ phStoreAttributeBuffer:BUFFER-FIELD("tDateValue":U):BUFFER-VALUE).
                    WHEN "INTEGER":U THEN
                        ASSIGN lDeleteRecord = (hAttributeField:BUFFER-VALUE EQ phStoreAttributeBuffer:BUFFER-FIELD("tIntegerValue":U):BUFFER-VALUE).
                    WHEN "DECIMAL":U THEN
                        ASSIGN lDeleteRecord = (hAttributeField:BUFFER-VALUE EQ phStoreAttributeBuffer:BUFFER-FIELD("tDecimalValue":U):BUFFER-VALUE).
                    OTHERWISE
                        ASSIGN lDeleteRecord = (hAttributeField:BUFFER-VALUE EQ phStoreAttributeBuffer:BUFFER-FIELD("tCharacterValue":U):BUFFER-VALUE) NO-ERROR.
                END CASE.   /* data type */
            END.    /* field in attribute buffer */

            IF lDeleteRecord THEN
                phStoreAttributeBuffer:BUFFER-DELETE().
            
            ghQuery4:GET-NEXT().
        END.    /* available phStoreAttributeBuffer */
        ghQuery4:QUERY-CLOSE().

        /* Get rid of the empty one. */
        IF pcCleanToLevel EQ "CLASS":U THEN
        DO:
            hAttributeBuffer:BUFFER-DELETE().
            hAttributeBuffer:BUFFER-RELEASE().
        END.    /* clean to class. */
    END.    /* available object buffer */

    RETURN TRUE.
END FUNCTION.   /* cleanStoreAttributeValues */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBufferDbName Include 
FUNCTION getBufferDbName RETURNS CHARACTER
    ( INPUT pcTableName         AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  REturns the database name for a given table 
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hTableBuffer            AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE cDbName                 AS CHARACTER                NO-UNDO.

    CREATE BUFFER hTableBuffer FOR TABLE pcTableName NO-ERROR.
    IF NOT ERROR-STATUS:ERROR THEN
        ASSIGN cDbName = hTableBuffer:DBNAME.

    DELETE OBJECT hTableBuffer NO-ERROR.
    ASSIGN hTableBuffer = ?.

    RETURN cDbName.
END FUNCTION.   /* getBufferDbName */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCacheClassExtBuffer Include 
FUNCTION getCacheClassExtBuffer RETURNS HANDLE
    ( INPUT pcClassName         AS CHARACTER,
      INPUT pcAttributeName     AS CHARACTER        ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the buffer handle of the class extended information table.
    Notes:  * If a class is specified, then this API attempts to reposition 
              the buffer to the first record spcified.
            * If the attribute nasme is specified, then this API attempts to
              reposition the dataset to that record.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hCacheClassExtBuffer                AS HANDLE     NO-UNDO.

    IF pcClassName NE ? AND pcClassName NE "":U THEN
    DO:
        IF pcAttributeName EQ ? OR pcAttributeName EQ "":U THEN
            FIND FIRST ttClassExtInformation WHERE
                       ttClassExtInformation.tClassName = pcClassName
                       NO-ERROR.
        ELSE
            FIND FIRST ttClassExtInformation WHERE
                       ttClassExtInformation.tClassName     = pcClassName     AND
                       ttClassExtInformation.tAttributeName = pcAttributeName
                       NO-ERROR.
    END.    /* class is specified */

    ASSIGN hCacheClassExtBuffer = BUFFER ttClassExtInformation:HANDLE.

    RETURN hCacheClassExtBuffer.
END FUNCTION.   /* getCacheClassExtBuffer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getComboBoxAttributes Include 
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

  RETURN cExtraAttributes.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentProductModule Include 
FUNCTION getCurrentProductModule RETURNS CHARACTER
  (/* parameter-definitions */) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the value of the current product module for the AppBuilder.
    Notes:  See function productModuleList for details on the value.
            Copied from ryreposob.p
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cProductModule AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE rRowid       AS ROWID      NO-UNDO.
  DEFINE VARIABLE cProfileData AS CHARACTER  NO-UNDO.

  IF cProductModule = "" OR cProductModule = ? THEN
  DO:
     ASSIGN rRowID = ?.
    /* Get profile data for the Save in combo-box list */
     RUN getProfileData IN gshProfileManager ( INPUT        "General":U,
                                               INPUT        "DispRepos":U,
                                               INPUT        "ProductModuleDef":U,
                                               INPUT        NO,
                                               INPUT-OUTPUT rRowid,
                                               OUTPUT cProfileData).
     cProductModule = cProfileData.
  END.

  RETURN cProductModule.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDupFieldCount Include 
FUNCTION getDupFieldCount RETURNS INTEGER
  ( pcFieldList AS CHARACTER,
    pcField     AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This function counts how many duplicate pcField's there are in the 
            pcFieldList and returns a number of occurances found
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iEntryCount AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iIndexNum   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPrevIndex  AS INTEGER    NO-UNDO.
  ASSIGN iEntryCount = 0
         iIndexNum   = 0.
  ASSIGN iPrevIndex = 1
         iIndexNum  = INDEX(pcFieldList,pcField).
  DO WHILE iIndexNum <> 0:
    ASSIGN iIndexNum = INDEX(pcFieldList,pcField,iPrevIndex)
           iPrevIndex = iIndexNum + 1.
    IF iIndexNum <> 0 THEN
      iEntryCount = iEntryCount + 1.
  END.
  RETURN iEntryCount.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEditorAttributes Include 
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
    cExtraAttributes = IF cExtraAttributes = "":U THEN "SCROLLBAR-HORIZONTAL^LOGICAL^TRUE"
                                                  ELSE cExtraAttributes + CHR(4) + "SCROLLBAR-HORIZONTAL^LOGICAL^TRUE".
  
  IF LOOKUP("SCROLLBAR-VERTICAL":U,pcViewAsList,"|":U) >= 1 THEN
    cExtraAttributes = IF cExtraAttributes = "":U THEN "SCROLLBAR-VERTICAL^LOGICAL^TRUE"
                                                  ELSE cExtraAttributes + CHR(4) + "SCROLLBAR-VERTICAL^LOGICAL^TRUE".

  RETURN cExtraAttributes.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldNames Include 
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

    &IF DEFINED(Server-Side) NE 0 &THEN
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
    &ENDIF
       
    RETURN cReturnFieldNames.
END FUNCTION.   /* getFieldNames */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFuncLibHandle Include 
FUNCTION getFuncLibHandle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the handle of the AppBuilder function library .   
    Notes:  
------------------------------------------------------------------------------*/
  IF NOT VALID-HANDLE(gFuncLibHdl) THEN 
  DO:
      gFuncLibHdl = SESSION:FIRST-PROCEDURE.
      DO WHILE VALID-HANDLE(gFuncLibHdl):
        IF gFuncLibHdl:FILE-NAME = "adeuib/_abfuncs.w":U THEN LEAVE.
        gFuncLibHdl = gFuncLibHdl:NEXT-SIBLING.
      END.
  END.
  RETURN gFuncLibHdl.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getIndexFields Include 
FUNCTION getIndexFields RETURNS CHARACTER
    ( INPUT pcTable AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  To return a comma delimited list of fields in an AK index
            for the passed in table - selecting best index
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cReturnFields               AS CHARACTER            NO-UNDO.

    &IF DEFINED(Server-Side) GT 0 &THEN
    DEFINE VARIABLE cIndexInformation           AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cIndexField                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE hKeyBuffer                  AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hField                      AS HANDLE               NO-UNDO.
    DEFINE VARIABLE iLoop                       AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iCnt                        AS INTEGER              NO-UNDO.
    
    /* Create buffer for passed in table */    
    CREATE BUFFER hKeyBuffer FOR TABLE TRIM(pcTable) NO-ERROR.
    IF VALID-HANDLE(hKeyBuffer) THEN
    DO:
        ASSIGN iLoop             = 0
               iCnt              = 0
               cIndexInformation = "":U
               cReturnFields     = "":U
               .   
        find-index-loop:
        REPEAT WHILE cIndexInformation <> ?:
            ASSIGN iLoop = iLoop + 1
                   cIndexInformation = hKeyBuffer:INDEX-INFORMATION(iLoop).
            DO iCnt = 5 TO NUM-ENTRIES(cIndexInformation) BY 2:
                ASSIGN cIndexField = TRIM(ENTRY(iCnt, cIndexInformation)).
    
                IF LOOKUP(cIndexField,cReturnFields) = 0 THEN
                    ASSIGN hField        = hKeyBuffer:BUFFER-FIELD(cIndexField)
                           cReturnFields = cReturnFields + "," WHEN cReturnFields <> "":U
                           cReturnFields = cReturnFields + cIndexField + "," + hField:DATA-TYPE + "," + hField:LABEL.            
            END.
        END.
    END.    /* valid handle */

    DELETE OBJECT hKeyBuffer NO-ERROR.
    ASSIGN hKeyBuffer = ?.
    &ENDIF
       
    RETURN cReturnFields.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getIndexFieldsUnique Include 
FUNCTION getIndexFieldsUnique RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  To return a chr(2) delimited list of fields in an AK index
            for the passed in table that are unique
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cReturnFields               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cIndexInformation           AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cIndexField                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE hKeyBuffer                  AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hField                      AS HANDLE               NO-UNDO.
    DEFINE VARIABLE iLoop                       AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iCnt                        AS INTEGER              NO-UNDO.
    
    /* Create buffer for passed in table */    
    CREATE BUFFER hKeyBuffer FOR TABLE TRIM(pcTable) NO-ERROR.
    IF VALID-HANDLE(hKeyBuffer) THEN
    DO:
        ASSIGN iLoop             = 0
               iCnt              = 0
               cIndexInformation = "":U
               cReturnFields     = "":U
               .   
        find-index-loop:
        REPEAT WHILE cIndexInformation <> ?:
            ASSIGN iLoop = iLoop + 1
                   cIndexInformation = hKeyBuffer:INDEX-INFORMATION(iLoop).
            IF ENTRY(2,cIndexInformation) = "1":U THEN
            DO iCnt = 5 TO NUM-ENTRIES(cIndexInformation) BY 2:
                ASSIGN cIndexField = TRIM(ENTRY(iCnt, cIndexInformation)).
    
                IF LOOKUP(cIndexField,cReturnFields,CHR(2)) = 0 THEN
                    ASSIGN hField        = hKeyBuffer:BUFFER-FIELD(cIndexField)
                           cReturnFields = cReturnFields + CHR(2) WHEN cReturnFields <> "":U
                           cReturnFields = cReturnFields + cIndexField + CHR(2) + hField:DATA-TYPE + CHR(2) + hField:LABEL.            
            END.
        END.
    END.    /* valid handle */

    DELETE OBJECT hKeyBuffer NO-ERROR.
    ASSIGN hKeyBuffer = ?.
    
       
    RETURN cReturnFields.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectTypeCodeFromDB Include 
FUNCTION getObjectTypeCodeFromDB RETURNS CHARACTER
  (pdObjectTypeObj AS DECIMAL) :
/*------------------------------------------------------------------------------
  Purpose:  Given an object type obj, return the object type code.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjectTypeCode AS CHARACTER  NO-UNDO.

  &IF DEFINED(server-side) = 0 &THEN
  {
   dynlaunch.i &PLIP              = 'RepositoryDesignManager'
               &IProc             = 'getObjectTypeCodeFromDB'
               &mode1 = OUTPUT &parm1 = cObjectTypeCode &datatype1 = CHARACTER
  }
  IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
  &ELSE
      FIND FIRST gsc_object_type 
           WHERE gsc_object_type.object_type_obj = pdObjectTypeObj
           NO-LOCK NO-ERROR.
      IF AVAILABLE gsc_object_type THEN
          ASSIGN cObjectTypeCode = gsc_object_type.object_type_code.
      ELSE
          ASSIGN cObjectTypeCode = ?.
  
  &ENDIF

  RETURN cObjectTypeCode.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRadioSetAttributes Include 
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
  DEFINE VARIABLE cExtraAttributes AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRadioButtons    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE dTotalWidth      AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iCnt             AS INTEGER    NO-UNDO.

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

  IF LOOKUP("RADIO-BUTTONS":U,pcViewAsList,"|":U) >= 1 THEN DO:
    ASSIGN cValue = ENTRY(LOOKUP("RADIO-BUTTONS",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U).
           cExtraAttributes = IF cExtraAttributes = "":U THEN "RADIO-BUTTONS^CHARACTER^" + cValue
                                                         ELSE cExtraAttributes + CHR(4) + "RADIO-BUTTONS^CHARACTER^" + cValue.
    ASSIGN cRadioButtons = cValue
           iCnt          = NUM-ENTRIES(cValue).
  END.
  
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
     it isn't horizontal then we need to calculate suitable height */
  IF INDEX(cExtraAttributes,"HEIGHT":U) = 0 AND 
     INDEX(cExtraAttributes,"HORIZONTAL":U) = 0 THEN DO:
    ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "HEIGHT-CHARS^DECIMAL^" + STRING(iCnt / 2)
                                                         ELSE cExtraAttributes + CHR(4) + "HEIGHT-CHARS^DECIMAL^" + STRING(iCnt / 2).
    
  END.
  IF INDEX(cExtraAttributes,"WIDTH":U) = 0 THEN DO: 
    /* If the RADIO-SET is vertical we need to have a total
       width of all the options combined */
    IF INDEX(cExtraAttributes,"HORIZONTAL":U) = 0 THEN DO:
      DO iLoop = 1 TO NUM-ENTRIES(cRadioButtons):
        dTotalWidth = dTotalWidth + LENGTH(ENTRY(iLoop,cRadioButtons)).
        iLoop = iLoop + 1.
      END.
      ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "WIDTH-CHARS^DECIMAL^" + STRING(dTotalWidth)
                                                           ELSE cExtraAttributes + CHR(4) + "WIDTH-CHARS^DECIMAL^" + STRING(dTotalWidth).
    END.
    ELSE DO:
      DO iLoop = 1 TO NUM-ENTRIES(cRadioButtons):
        dTotalWidth = MAX(dTotalWidth,LENGTH(ENTRY(iLoop,cRadioButtons))).
        iLoop = iLoop + 1.
      END.
      ASSIGN cExtraAttributes = IF cExtraAttributes = "":U THEN "WIDTH-CHARS^DECIMAL^" + STRING(dTotalWidth)
                                                           ELSE cExtraAttributes + CHR(4) + "WIDTH-CHARS^DECIMAL^" + STRING(dTotalWidth).
    END.
  END.

  RETURN cExtraAttributes.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSchemaQueryHandle Include 
FUNCTION getSchemaQueryHandle RETURNS HANDLE
    ( INPUT  pcDatabaseName         AS CHARACTER,
      INPUT  pcTableNames            AS CHARACTER,
      OUTPUT pcWidgetPoolName       AS CHARACTER    ):
/*------------------------------------------------------------------------------
  Purpose:  Creates a query for the metaschema.
    Notes:  * Buffer 1: Database (_DB) hDbBuffer
              Buffer 2: File (_FILE) hFileBuffer
              Buffer 3: Field (_FIELD) hFieldBuffer
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hQuery                          AS HANDLE                       NO-UNDO.

    ASSIGN hQuery = ?.

    /* This code can only run with a DB connected. */
    &IF DEFINED(Server-Side) GT 0 &THEN    
    DEFINE VARIABLE iTableLoop                      AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE hFieldBuffer                    AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hFileBuffer                     AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hDbBuffer                       AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE cWhere                          AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cFieldBufferName                AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cLogicalDbName                  AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cSchemaName                     AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cDbBufferName                   AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cFileBufferName                 AS CHARACTER                    NO-UNDO.

    ASSIGN giUniquenessGuarantor = giUniquenessGuarantor + 1
           pcWidgetPoolName      = "getSchemaQueryHandle":U + STRING(giUniquenessGuarantor)
           .
    /** This widget-pool is created PERSISTENTly because it needs to be available
     *  outside of this function. This means, though, that the widget-pool must
     *  be manually deleted by the caller.
     *  ----------------------------------------------------------------------- **/
    CREATE WIDGET-POOL pcWidgetPoolName PERSISTENT.

    /* If the logical object name and the schema name differ, then we assume that we are working with 
     * a DataServer. If the schema and logical names are the same, we are dealing with a native 
     * Progress DB.                                                                                   */
    ASSIGN cLogicalDbName = pcDataBaseName
           cSchemaName    = SDBNAME(cLogicalDbName)
           NO-ERROR.
    IF ERROR-STATUS:ERROR THEN RETURN ?.

    IF cSchemaName EQ cLogicalDbName THEN
    DO:
    
        ASSIGN cDbBufferName    = cLogicalDbName + "._Db":U
               cFileBufferName  = cLogicalDbName + "._File":U
               cFieldBufferName = cLogicalDbName + "._Field":U
               cWhere           = "FOR EACH ":U + cDbBufferName + " NO-LOCK, ":U
                                + " EACH " + cFileBufferName + " WHERE ":U
                                +   cFileBufferName + "._Db-recid  = RECID(":U + cDbBufferName + ") AND ":U
                                + " ( ":U
               .
        IF pcTableNames EQ "*":U THEN
            ASSIGN cWhere = cWhere + cFileBufferName + "._Hidden = LOGICAL('NO') ":U.
        ELSE
        DO iTableLoop = 1 TO NUM-ENTRIES(pcTableNames):
            ASSIGN cWhere = cWhere + cFileBufferName + "._File-name = '":U + ENTRY(iTableLoop, pcTableNames) + "' OR ":U.
        END.    /* TableLoop */

        ASSIGN cWhere = RIGHT-TRIM(cWhere, "OR ":U)
          cWhere = cWhere + " )"
                 + (IF DBVERSION(cLogicalDbName) <> '8'
                    THEN " AND ":U + cFileBufferName + "._Owner     = 'PUB' ":U
                    ELSE '')
                 + " NO-LOCK, ":U
                 + " EACH ":U + cFieldBufferName + " WHERE ":U
                 +   cFieldBufferName + "._File-recid = RECID(":U + cFileBufferName + ") ":U
                 + " NO-LOCK ":U
                 + " BY ":U + cFieldBufferName + "._Order ":U.
    END.    /* not a schema holder */
    ELSE
    DO:
        ASSIGN cDbBufferName    = cSchemaName + "._Db":U
               cFileBufferName  = cSchemaName + "._File":U
               cFieldBufferName = cSchemaName + "._Field":U
               cWhere           = " FOR EACH ":U + cDbBufferName + " WHERE ":U
                                +   cDbBufferName + "._Db-Name = '" + cLogicalDbName + "' ":U
                                + " NO-LOCK, ":U
                                + " EACH " + cFileBufferName + " WHERE ":U
                                +   cFileBufferName + "._Db-recid  = RECID(":U + cDbBufferName + ") AND ":U
                                + " ( ":U
               .
        IF pcTableNames EQ "*":U THEN
            ASSIGN cWhere = cWhere + cFileBufferName + "._Hidden = LOGICAL('NO')  ":U.
        ELSE
        DO iTableLoop = 1 TO NUM-ENTRIES(pcTableNames):
            ASSIGN cWhere = cWhere + cFileBufferName + "._File-name = '":U + ENTRY(iTableLoop, pcTableNames) + "' OR ":U.
        END.    /* TableLoop */

        ASSIGN cWhere = RIGHT-TRIM(cWhere, "OR ":U)
               cWhere = cWhere + " ) AND ":U
                      +   cFileBufferName + "._Owner     = '_Foreign' ":U
                      + " NO-LOCK, ":U
                      + " EACH ":U + cFieldBufferName + " WHERE ":U
                      +   cFieldBufferName + "._File-recid = RECID(":U + cFileBufferName + ") ":U
                      + " NO-LOCK ":U
                      + " BY ":U + cFieldBufferName + "._Order ":U.
    END.    /* schema DB */

    CREATE BUFFER hDbBuffer     FOR TABLE cDbBufferName     IN WIDGET-POOL pcWidgetPoolName NO-ERROR.
    IF ERROR-STATUS:ERROR THEN RETURN ?.

    CREATE BUFFER hFileBuffer   FOR TABLE cFileBufferName   IN WIDGET-POOL pcWidgetPoolName NO-ERROR.
    IF ERROR-STATUS:ERROR THEN RETURN ?.

    CREATE BUFFER hFieldBuffer  FOR TABLE cFieldBufferName  IN WIDGET-POOL pcWidgetPoolName NO-ERROR.
    IF ERROR-STATUS:ERROR THEN RETURN ?.

    CREATE QUERY hQuery IN WIDGET-POOL pcWidgetPoolName NO-ERROR.
    
    hQuery:SET-BUFFERS(hDbBuffer, hFileBuffer, hFieldBuffer).    
    hQuery:QUERY-PREPARE(cWhere).
    &ENDIF
    
    RETURN hQuery.
END FUNCTION.   /* getSchemaQueryHandle */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSelectionListAttributes Include 
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
                                                              
  IF LOOKUP("LIST-ITEMS":U,pcViewAsList,"|":U) >= 1 THEN DO:
    ASSIGN cValue = ENTRY(LOOKUP("LIST-ITEMS",pcViewAsList,"|":U) + 1,pcViewAsList,"|":U).
    IF NUM-ENTRIES(cValue) > 1 THEN
      ASSIGN cValue = REPLACE(cValue,",":U,CHR(3))
             cExtraAttributes = IF cExtraAttributes = "":U THEN "DELIMITER^CHARACTER^" + CHR(3)
                                                           ELSE cExtraAttributes + CHR(4) + "DELIMITER^CHARACTER^" + CHR(3).

    cExtraAttributes = IF cExtraAttributes = "":U THEN "LIST-ITEMS^CHARACTER^" + cValue
                                                  ELSE cExtraAttributes + CHR(4) + "LIST-ITEMS^CHARACTER^" + cValue.

  END.
  
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
    cExtraAttributes = IF cExtraAttributes = "":U THEN "SCROLLBAR-HORIZONTAL^LOGICAL^TRUE"
                                                  ELSE cExtraAttributes + CHR(4) + "SCROLLBAR-HORIZONTAL^LOGICAL^TRUE".
  
  IF LOOKUP("SCROLLBAR-VERTICAL":U,pcViewAsList,"|":U) >= 1 THEN
    cExtraAttributes = IF cExtraAttributes = "":U THEN "SCROLLBAR-VERTICAL^LOGICAL^TRUE"
                                                  ELSE cExtraAttributes + CHR(4) + "SCROLLBAR-VERTICAL^LOGICAL^TRUE".

  RETURN cExtraAttributes.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSmartObjectObj Include 
FUNCTION getSmartObjectObj RETURNS DECIMAL
    ( INPUT pcObjectName                AS CHARACTER,
      INPUT pdCustmisationResultObj     AS DECIMAL      ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the object ID of an associated smartObject, given a 
            object name.
    Notes:  * the logic will always attempt to find the customised version
              and then a version without customisation before looking for 
              a version with an extension.
            * This funbction is designed to be private to this Manager and to
              only be called from the server-side portion.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dSmartObjectObj             AS DECIMAL              NO-UNDO.

    &IF DEFINED(Server-side) <> 0 &THEN
    DEFINE VARIABLE cObjectExt                  AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cObjectFileNameWithExt      AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cObjectFileNameNoExt        AS CHARACTER                NO-UNDO.

    DEFINE BUFFER rycso_associated      FOR ryc_smartObject.

    RUN extractRootFile IN gshRepositoryManager ( INPUT pcObjectName, OUTPUT cObjectFileNameNoExt, OUTPUT cObjectFileNameWithExt ) NO-ERROR.
    ASSIGN cObjectExt = REPLACE(cObjectFileNameWithExt, (cObjectFileNameNoExt + ".":U), "":U).

    FIND FIRST rycso_associated WHERE
               rycso_associated.object_filename          = pcObjectName            AND
               rycso_associated.customization_result_obj = pdCustmisationResultObj
               NO-LOCK NO-ERROR.
    IF NOT AVAILABLE rycso_associated AND pdCustmisationResultObj NE 0 THEN
        FIND FIRST rycso_associated WHERE
                   rycso_associated.object_filename          = pcObjectName AND
                   rycso_associated.customization_result_obj = 0
                   NO-LOCK NO-ERROR.

    /* If not available then check rycso_associated with separated file extension if any */
    IF NOT AVAILABLE rycso_associated AND cObjectExt NE "":U THEN
        FIND FIRST rycso_associated WHERE
                   rycso_associated.object_filename  = cObjectFileNameNoExt AND
                   rycso_associated.object_extension = cObjectExt
                   NO-LOCK NO-ERROR.
    IF NOT AVAILABLE rycso_associated AND pdCustmisationResultObj NE 0 THEN
        FIND FIRST rycso_associated WHERE
                   rycso_associated.object_filename          = cObjectFileNameNoExt AND
                   rycso_associated.object_extension         = cObjectExt           AND
                   rycso_associated.customization_result_obj = 0
                   NO-LOCK NO-ERROR.

    IF AVAILABLE rycso_associated THEN
        ASSIGN dSmartObjectObj = rycso_associated.smartObject_obj.
    ELSE
        ASSIGN dSmartObjectObj = 0.
    &ENDIF  /* server-side */
                  
    RETURN dSmartObjectObj.
END FUNCTION.   /* getSmartObjectObj */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWidgetSizeFromFormat Include 
FUNCTION getWidgetSizeFromFormat RETURNS DECIMAL
    ( INPUT  pcFormatMask       AS CHARACTER,
      INPUT  pcUnit             AS CHARACTER,
      OUTPUT pdHeight           AS DECIMAL      ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the height and width of a fill-in widget, based on the format.
    Notes:  * the pcUnit can be CHARACTER or PIXEL. The default is CHARACTER.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hWidget             AS HANDLE                       NO-UNDO.
  DEFINE VARIABLE dWidth              AS DECIMAL                      NO-UNDO.
  DEFINE VARIABLE cAnalProc           AS CHARACTER                    NO-UNDO.
  DEFINE VARIABLE cAnalValues         AS CHARACTER                    NO-UNDO EXTENT 100.
  DEFINE VARIABLE dWidthChars         AS DECIMAL                      NO-UNDO.
  DEFINE VARIABLE dHeightChars        AS DECIMAL                      NO-UNDO.

  CREATE FILL-IN hWidget
      ASSIGN FORMAT = pcFormatMask.
  
  /* This should never happen, but Just incase */
  IF NOT VALID-HANDLE(hWidget) THEN DO:
    pdHeight = 1.
    RETURN 10.00.
  END.

  /* Use Analyzer for field width and height calculation */
  cAnalProc = SESSION:TEMP-DIR + "dynanal.p":U.
  OUTPUT STREAM stAnalyze TO VALUE(cAnalProc).
  PUT STREAM stAnalyze UNFORMATTED "DEFINE VARIABLE TheWidget AS " hWidget:DATA-TYPE " FORMAT '" pcFormatMask "' NO-UNDO.":U SKIP(1)
                                   "FORM TheWidget".
  OUTPUT STREAM stAnalyze CLOSE.
  /* If the file wasn't created - give up! */ 
  IF SEARCH(cAnalProc) = ? THEN DO:
    pdHeight = 1.
    RETURN 10.00.
  END.
  ANALYZE VALUE(cAnalProc) VALUE(REPLACE(cAnalProc,".p":U,".anl":U)) NO-ERROR.
  INPUT STREAM stAnalyze FROM VALUE(REPLACE(cAnalProc,".p":U,".anl":U)) NO-MAP.
  IF SEARCH(REPLACE(cAnalProc,".p":U,".anl":U)) = ? THEN DO:
    pdHeight = 1.
    RETURN 10.00.
  END.
  ANALIZER_BLOCK:
  REPEAT:
    IMPORT STREAM stAnalyze cAnalValues.
    IF cAnalValues[1] = "FF":U THEN DO:
      IMPORT STREAM stAnalyze cAnalValues.
      /* The ANALYZER will always write the values in American format - we should ensure that when we convert 
         it to DECIMAL that we use the correct NUMERIC-DECIMAL-POINT  - ISSUE #7251 */
      ASSIGN dWidthChars  = DECIMAL(REPLACE(cAnalValues[5],".":U,SESSION:NUMERIC-DECIMAL-POINT)) NO-ERROR.
      IF ERROR-STATUS:ERROR OR
         dWidthChars = ? THEN
      ASSIGN dWidthChars = 1.
  
      /* The ANALYZER will always write the values in American format - we should ensure that when we convert 
         it to DECIMAL that we use the correct NUMERIC-DECIMAL-POINT  - ISSUE #7251 */
      ASSIGN dHeightChars = DECIMAL(REPLACE(cAnalValues[6],".":U,SESSION:NUMERIC-DECIMAL-POINT)) NO-ERROR.
      IF ERROR-STATUS:ERROR OR
         dHeightChars = ? THEN
      ASSIGN dHeightChars = 1.
  
      /* We know that the Width and Height is stored in field 5 and 6 */
      LEAVE ANALIZER_BLOCK.
    END.
  END.
  INPUT STREAM stAnalyze CLOSE.
  /* Remove physical files on disk */
  OS-DELETE VALUE(cAnalProc).
  OS-DELETE VALUE(REPLACE(cAnalProc,".p":U,".anl":U)).
  CASE pcUnit:
    WHEN "PIXEL" THEN
      ASSIGN dWidth   = dWidthChars * SESSION:PIXELS-PER-COL
             pdHeight = dHeightChars * SESSION:PIXELS-PER-ROW
             NO-ERROR.
    OTHERWISE DO:
      ASSIGN dWidth   = dWidthChars
             pdHeight = dHeightChars
             NO-ERROR.
      IF dWidth > {&MAX-FIELD-WIDTH-CHARS} THEN
        dWidth = {&MAX-FIELD-WIDTH-CHARS}.
    END.
  END CASE.   /* pcUnit */
  
  DELETE OBJECT hWidget NO-ERROR.
  ASSIGN hWidget = ?.

  RETURN dWidth.
END FUNCTION.   /* getWidgetSizeFromFormat */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ObjectExists Include 
FUNCTION ObjectExists RETURNS LOGICAL
  (pcObjectName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Given an object name, return whether it exists in the repository
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lObjectExists AS LOGICAL  NO-UNDO.

  &IF DEFINED(server-side) = 0 &THEN
  {
   dynlaunch.i &PLIP              = 'RepositoryDesignManager'
               &IProc             = 'ObjectExists'
               &compileStaticCall = NO
               &mode1 = INPUT &parm1 = pcObjectName &datatype1 = CHARACTER
               &mode2 = OUTPUT &parm2 = lObjectExists &datatype2 = LOGICAL
  }
  IF RETURN-VALUE <> "":U THEN RETURN ERROR FALSE.
  &ELSE
     IF CAN-FIND(FIRST ryc_SmartObject 
                 WHERE ryc_SmartObject.object_Filename = pcObjectName) THEN
        lObjectExists = TRUE.
     ELSE
        lObjectExists = FALSE.
  
  &ENDIF

  RETURN lObjectExists.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION openRyObjectAB Include 
FUNCTION openRyObjectAB RETURNS LOGICAL
  ( INPUT pObjectName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Creates an "OPEN" _RyObject record for the AppBuilder to use in
            opening a repository object for editing.
    Notes:  IZ 2342
            Copied from ryreposob.p
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE cError    AS CHARACTER      NO-UNDO.
    DEFINE VARIABLE hRyObject AS HANDLE         NO-UNDO.
    
    DO ON STOP UNDO, RETRY ON ERROR UNDO, RETRY:
        IF NOT RETRY THEN
        DO:
            RUN ry/obj/ryobjectab.w PERSISTENT SET hRyObject.
            RUN getRyObject IN hRyObject
                (INPUT-OUTPUT pObjectName, OUTPUT cError).
        END.
        ELSE
        DO:
            ASSIGN cError = "Cannot open requested object.".
        END.
    END.

    RETURN (cError = "").   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION productModuleList Include 
FUNCTION productModuleList RETURNS CHARACTER
  (/* parameter-definitions */) :
/*------------------------------------------------------------------------------
  Purpose:  Returns list of Product Module Codes and their Descriptions for use
            in Product Module combo-boxes. IZ 3195.
    Notes:  String returned is a comma-delimited list of code/description items
            of the form " pm_code // pm_description". The DispRepos General
            setting to show or not show Repository Modules is automatically
            applied.
            Copied from ryreposob.p
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cProductModuleList AS CHARACTER  NO-UNDO.

  &IF DEFINED(server-side) = 0 &THEN
  {
   dynlaunch.i &PLIP              = 'RepositoryDesignManager'
               &IProc             = 'productModuleList'
               &mode1 = OUTPUT &parm1 = cProductModuleList &datatype1 = CHARACTER
  }
  IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
  &ELSE
    DEFINE VARIABLE cPMList               AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lDisplayRepository    AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE rRowid                AS ROWID      NO-UNDO.
    DEFINE VARIABLE cProfileData          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cPMDesc               AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cProdModule           AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hQuery                AS HANDLE     NO-UNDO.
    DEFINE VARIABLE iLoop                 AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cPrMod                AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cQuery                AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cWhere                AS CHARACTER  NO-UNDO.

    ASSIGN rRowid = ?.
    RUN getProfileData IN gshProfileManager ( INPUT        "General":U,
                                              INPUT        "DispRepos":U,
                                              INPUT        "DispRepos":U,
                                              INPUT        NO,
                                              INPUT-OUTPUT rRowid,
                                                    OUTPUT cProfileData).
    ASSIGN lDisplayRepository = (cProfileData EQ "YES":U).

    cQuery = "FOR EACH gsc_product_module NO-LOCK BY gsc_product_module.product_module_code".
    
    IF NOT lDisplayRepository THEN DO:
      cWhere = "":U.
      DO iLoop = 1 TO NUM-ENTRIES("{&REPOSITORY-MODULES}":U):
        cPrMod = TRIM(ENTRY(iLoop,"{&REPOSITORY-MODULES}":U)).
        IF cPrMod = "":U THEN
          NEXT.
        IF cWhere = "":U THEN
          cWhere = "WHERE":U.
        ELSE 
          cWhere = cWhere + " AND ":U.
        cWhere = cWhere + " NOT gsc_product_module.product_module_code BEGINS '":U + cPrMod + "'":U.
      END.
      IF cWhere <> "":U THEN
        cQuery = REPLACE(cQuery,"NO-LOCK BY","NO-LOCK " + cWhere + " BY":U).
    END.
    
    CREATE QUERY hQuery.
    hQuery:SET-BUFFERS("gsc_product_module").
    hQuery:QUERY-PREPARE(cQuery).
    hQuery:QUERY-OPEN().
    
    hQuery:GET-FIRST(NO-LOCK).
    DO WHILE AVAILABLE gsc_product_module:
      ASSIGN cPMDesc = (IF gsc_product_module.product_module_description <> ?
                        THEN gsc_product_module.product_module_description
                        ELSE "") NO-ERROR.

      ASSIGN cPMList = cPMList + (IF cPMList EQ "":U THEN "":U ELSE ",":U)
                       + gsc_product_module.product_module_code + ' // ':U + cPMDesc NO-ERROR.
      hQuery:GET-NEXT(NO-LOCK).
    END.
    
    hQuery:QUERY-CLOSE().
    DELETE OBJECT hQuery.
    hQuery = ?.

    cProductModuleList = cPMList.
  &ENDIF

  RETURN cProductModuleList.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCurrentProductModule Include 
FUNCTION setCurrentProductModule RETURNS LOGICAL
  ( INPUT cProductModule AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the value of the current product module for the AppBuilder.
    Notes:  See function productModuleList for details on the value.
            Copied from ryreposob.p
------------------------------------------------------------------------------*/
  
  /* Save current product module to the repository */
  RUN setProfileData IN gshProfileManager (INPUT "General":U,          /* Profile type code */
                                           INPUT "DispRepos":U,        /* Profile code */
                                           INPUT "ProductModuleDef":U, /* Profile data key */
                                           INPUT ?,                    /* Rowid of profile data */
                                           INPUT cProductModule,       /* Profile data value */
                                           INPUT NO,                   /* Delete flag */
                                           INPUT "PER":u).             /* Save flag (permanent) */
  
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

