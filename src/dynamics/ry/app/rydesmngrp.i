&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Include _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
        Last change: PJ 5/23/2003 12:47:14
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/* Copyright © 1984-2007 by Progress Software Corporation.  All rights 
   reserved.  Prior versions of this work may contain portions 
   contributed by participants of Possenet.  */   
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

  (v:020000)    Task:          49   UserRef:    
                Date:   06/20/2003  Author:     Thomas Hansen

  Update Notes: Issue 5504:
                Add support for changeObjectType making SCM checks.

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* object identifying preprocessor */
&glob   AstraInclude    YES

{ src/adm2/globals.i }

/** These pre-processors are use for defaults when no physical object name
 *  is specified. They object type codes list determine which 
 *  ----------------------------------------------------------------------- **/
&GLOBAL-DEFINE CLASS-PHYSICAL-CONTAINER DynObjc,DynWind,DynFold,DynMenc,DynTree,SmartWindow
&GLOBAL-DEFINE CLASS-PHYSICAL-COMBO     DynCombo
&GLOBAL-DEFINE CLASS-PHYSICAL-FRAME     DynFrame
&GLOBAL-DEFINE CLASS-PHYSICAL-VIEWER    DynView
&GLOBAL-DEFINE CLASS-PHYSICAL-BROWSE    DynBrow
&GLOBAL-DEFINE CLASS-PHYSICAL-LOOKUP    DynLookup
&GLOBAL-DEFINE CLASS-PHYSICAL-SDO       DynSDO
&GLOBAL-DEFINE CLASS-PHYSICAL-SBO       DynSBO

/** This pre-processor contains the codes of classes that can be containers.
 *  ----------------------------------------------------------------------- **/
&GLOBAL-DEFINE CONTAINER-CLASSES {&CLASS-PHYSICAL-CONTAINER},{&CLASS-PHYSICAL-COMBO},{&CLASS-PHYSICAL-FRAME}

/** This pre-processor determines which object types have an extension associated 
 *  with their filenames. 
 *  ----------------------------------------------------------------------- **/
&GLOBAL-DEFINE CLASS-USES-EXTENSION Base,DLProc,Procedure

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
DEFINE VARIABLE gcCLASS-USES-EXTENSION     AS CHARACTER  NO-UNDO.
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

       gcCLASS-USES-EXTENSION   = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "{&CLASS-USES-EXTENSION}":U)
       gcCLASS-USES-EXTENSION   = REPLACE(gcCLASS-USES-EXTENSION, CHR(3), ",")

       gcCLASS-PHYSICAL-FRAME     = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "{&CLASS-PHYSICAL-FRAME}":U)
       gcCLASS-PHYSICAL-FRAME     = REPLACE(gcCLASS-PHYSICAL-FRAME, CHR(3), ",")

       gcCLASS-PHYSICAL-SBO       = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "{&CLASS-PHYSICAL-SBO}":U)
       gcCLASS-PHYSICAL-SBO       = REPLACE(gcCLASS-PHYSICAL-SBO, CHR(3), ",")
       .

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
DEFINE VARIABLE giUniquenessGuarantor       AS INTEGER                  NO-UNDO.

/** These TTs used by buildSchemaFieldTable().
 *  ----------------------------------------------------------------------- **/
DEFINE TEMP-TABLE ttTableField              NO-UNDO
    LIKE _field
    FIELD tDataBaseName         AS CHARACTER
    FIELD tTableName            AS CHARACTER
    FIELD tTableDumpName        AS CHARACTER
    FIELD tKeyField             AS LOGICAL      INITIAL NO
    FIELD tEntityObjectField    AS LOGICAL      INITIAL NO
    .

/** Default size pre-processors for buildSchemaFieldTable()
 *  ----------------------------------------------------------------------- **/
&SCOPED-DEFINE MAX-FIELD-LENGTH 30
&SCOPED-DEFINE MAX-FIELD-WIDTH-CHARS 50

/* Definitions for dynamic call, only defined client side, as we're only using the dynamic call to reduce Appserver hits in this instance */
&IF DEFINED(server-side) = 0 &THEN
{src/adm2/calltables.i &PARAM-TABLE-TYPE = "1" &PARAM-TABLE-NAME = "ttSeqType"}
&ENDIF

/* Generic query handle to reduce the number of CREATE QUERY ... statements. */
DEFINE VARIABLE ghQuery1                    AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghQuery2                    AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghQuery3                    AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghQuery4                    AS HANDLE                   NO-UNDO.

DEFINE VARIABLE glSuppressDbName            AS LOGICAL INITIAL ?        NO-UNDO.

/** The following temp-tables are used for copyObjectMaster().
  *  ----------------------------------------------------------------------- **/
DEFINE TEMP-TABLE ttXref        NO-UNDO
    FIELD tElementType          AS CHARACTER
    FIELD tSourceData           AS CHARACTER
    FIELD tTargetData           AS CHARACTER
    INDEX idxSource
        tElementType
        tSourceData
    INDEX idxTarget
        tElementType
        tTargetData
    .

/* This stream is used with the Analyser in getWidgetSizeFromFormat */
DEFINE STREAM stAnalyze.

/** Contains definitions for all design-time API temp-tables.
 *  ----------------------------------------------------------------------- **/
{ry/inc/rydestdefi.i}

/** Contains definitions of the data types stored in the ryc_attribute table.
 *  ----------------------------------------------------------------------- **/
{af/app/afdatatypi.i}

/* Log levels: Used as a parameter into logMessage() for deployment automation */
{af/app/afloglevel.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-updateInstanceSequence) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD updateInstanceSequence Procedure
FUNCTION updateInstanceSequence RETURNS LOGICAL 
	(input pdObjectInstanceObj as decimal,
	 input piSequence as integer) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectInstanceObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectInstanceObj Procedure
FUNCTION getObjectInstanceObj RETURNS DECIMAL 
	(input pdContainerObj as decimal,
	 input pcInstanceName as character) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cleanStoreAttributeValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cleanStoreAttributeValues Procedure
FUNCTION cleanStoreAttributeValues RETURNS LOGICAL 
	(INPUT pcObjectName                AS CHARACTER,
	 INPUT pcClassName                 AS CHARACTER,
	 INPUT pcCleanToLevel              AS CHARACTER,
	 INPUT phStoreAttributeBuffer      AS HANDLE) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-customObjectExists) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD customObjectExists Procedure
FUNCTION customObjectExists RETURNS LOGICAL 
	(input pcObjectName as character,
	 input pcResultCode as character) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectNameFromObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectNameFromObj Procedure
FUNCTION getObjectNameFromObj RETURNS CHARACTER 
	( input pdSmartObjectObj as decimal  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataTypeCode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataTypeCode Procedure
FUNCTION getDataTypeCode RETURNS integer
	( input pcDataTypeName as character ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildClassAttributes Include 
FUNCTION buildClassAttributes RETURNS LOGICAL
        ( input        pcClassName               as character,
          input        pdRetrieveClassObj        as decimal,
          input-output pcInheritsFromClasses     as character  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cacheClassExtInfo Include 
FUNCTION cacheClassExtInfo RETURNS LOGICAL
    ( INPUT pcClassName     AS CHARACTER    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD classHasAttribute Include 
FUNCTION classHasAttribute RETURNS LOGICAL
    ( INPUT pcClassName             AS CHARACTER,
      INPUT pcAttributeOrEventName  AS CHARACTER,
      INPUT plAttributeIsEvent      AS LOGICAL          )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createClassCacheFile Include 
FUNCTION createClassCacheFile RETURNS LOGICAL PRIVATE
        ( input pcFilename         as character,
      input phClassBuffer      as handle         ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createRYObjectAB Include 
FUNCTION createRYObjectAB RETURNS LOGICAL
  ( pcObjectName AS CHAR,
    pcObjectString AS CHAR )  FORWARD.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentProductModule Include 
FUNCTION getCurrentProductModule RETURNS CHARACTER
  (/* parameter-definitions */)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataSourceClasses Include 
FUNCTION getDataSourceClasses RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getIndexFields Include 
FUNCTION getIndexFields RETURNS CHARACTER
    ( INPUT pcTable AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getIndexFieldsUnique Include 
FUNCTION getIndexFieldsUnique RETURNS CHARACTER
  ( INPUT pcTable           AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectTypeCodeFromDB Include 
FUNCTION getObjectTypeCodeFromDB RETURNS CHARACTER
  (pdObjectTypeObj AS DECIMAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getProductModuleList Include 
FUNCTION getProductModuleList RETURNS CHARACTER
 (pcValueField AS CHAR,
  pcDescFields AS CHAR,
  pcDescFormat AS CHAR,
  pcDelimiter  AS CHAR  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQualifiedTableName Include 
FUNCTION getQualifiedTableName RETURNS CHARACTER
    ( INPUT pcDbName        AS CHARACTER,
      INPUT pcTableName     AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getResultCodeObj Include 
FUNCTION getResultCodeObj RETURNS DECIMAL
    ( INPUT pcResultCode            AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSchemaQueryHandle Include 
FUNCTION getSchemaQueryHandle RETURNS HANDLE
    ( INPUT  pcDatabaseName         AS CHARACTER,
      INPUT  pcTableNames            AS CHARACTER,
      OUTPUT pcWidgetPoolName       AS CHARACTER    ) FORWARD.

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
    (INPUT pcObjectName         AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD openRyObjectAB Include 
FUNCTION openRyObjectAB RETURNS LOGICAL
  ( INPUT pcObjectName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD prepareObjectName Include 
FUNCTION prepareObjectName RETURNS CHARACTER
  ( INPUT pcObjectName   AS CHAR,  INPUT pcResultCode AS CHAR ,
    INPUT pcObjectString AS CHAR,  INPUT pcAction     AS CHAR, 
    INPUT pcObjectType   AS CHAR,  INPUT pcEntityName AS CHAR, 
    INPUT pcProductModule AS CHAR, OUTPUT pcNewObjectName AS CHAR,
    OUTPUT pcNewObjectExt AS CHAR )  FORWARD.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQualifiedTableName Include 
FUNCTION setQualifiedTableName RETURNS LOGICAL
    ( INPUT plSuppressDbName         AS LOGICAL  )  FORWARD.

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
         HEIGHT             = 20.05
         WIDTH              = 62.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  ******************************* */
CREATE WIDGET-POOL NO-ERROR.

ON CLOSE OF THIS-PROCEDURE 
DO:
    DELETE WIDGET-POOL NO-ERROR.

    RUN plipShutdown IN TARGET-PROCEDURE.

    DELETE PROCEDURE THIS-PROCEDURE.
    RETURN.
END.

/* Listen for the clearing of the Repository cache. If the repository cache is cleared, then we need
 * to signal the design cache that it is also to be cleared.                                        */
SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "repositoryCacheCleared" ANYWHERE RUN-PROCEDURE "clearDesignCache":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addMasterAttrs Include 
PROCEDURE addMasterAttrs :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
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
  IF RETURN-VALUE <> "":U THEN RETURN RETURN-VALUE.   
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
ACCESS_LEVEL=PRIVATE
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
  IF RETURN-VALUE <> "":U THEN RETURN RETURN-VALUE.   
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
ACCESS_LEVEL=PRIVATE
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
  IF RETURN-VALUE <> "":U THEN RETURN RETURN-VALUE.   
  &ELSE   
  DEFINE BUFFER bgsc_object_type FOR gsc_object_type.

  /* Find the object type that we are looking for. */
  FIND FIRST bgsc_object_type NO-LOCK
    WHERE bgsc_object_type.object_type_obj = poObjectTypeObj
    NO-ERROR.

  /* If it's not available, return */
  IF NOT AVAILABLE(bgsc_object_type) THEN
    RETURN.
 
  /* If this object type has a customising class, first add that class. */
  IF bgsc_object_type.custom_object_type_obj <> 0.0 THEN
    RUN addParentOTAttrs IN TARGET-PROCEDURE (INPUT bgsc_object_type.custom_object_type_obj, INPUT phOTTable).


  /* Add the attributes from this object type */
  RUN addOTAttrs IN TARGET-PROCEDURE (INPUT bgsc_object_type.object_type_obj, INPUT phOTTable).

  /* If this object type is descended from a parent one, add the parent one. */
  IF bgsc_object_type.extends_object_type_obj <> 0.0 THEN
    RUN addParentOTAttrs IN TARGET-PROCEDURE (INPUT bgsc_object_type.extends_object_type_obj, INPUT phOTTable).
  &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bufferRetrieveClassExtInfo Include 
PROCEDURE bufferRetrieveClassExtInfo :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Creates entries in the ttClassExtInformation TT for the specified
               class.
  Parameters:  pcClassName - the name of a class to retrieve extended information
                             for. This API only creates values for one 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcClassName          AS CHARACTER            NO-UNDO.
        
    RETURN ERROR "*** THIS API HAS BEEN DEPRECATED ***".
END PROCEDURE.  /* bufferRetrieveClassExtInfo */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildSchemaFieldTable Include 
PROCEDURE buildSchemaFieldTable :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
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
    DEFINE VARIABLE httEntityMnemonic           AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cValue                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cInheritClasses             AS CHARACTER            NO-UNDO.

    ASSIGN phTableFieldBuffer = BUFFER ttTableField:HANDLE.    
    phTableFieldBuffer:EMPTY-TEMP-TABLE().

    /* First value in = pair is the name in the TT being returned. The 2nd value is the 
     * name of the attribute.   */
    ASSIGN cFieldMapping = "_format=Format,_Data-type=Data-type,_Label=Label,_Help=Help,_Initial=DefaultValue,_View-as=ViewAs,":U
                         + "_Field-Name=NAME,_Field-Name=ObjectName,_Col-label=ColumnLabel,tTableDumpName=EntityMnemonic,":U
                         + "tDatabaseName=EntityDbname":U.

    DO iTableLoop = 1 TO NUM-ENTRIES(pcTableNames):
        /* Get the object from the Repository */
        IF NOT CAN-FIND(FIRST ttClassAttribute WHERE ttClassAttribute.tClassname = "DataField":U) THEN
            RUN retrieveDesignClass IN TARGET-PROCEDURE
                                ( INPUT  "DataField":U,
                                  OUTPUT cInheritClasses,
                                  OUTPUT TABLE ttClassAttribute ,
                                  OUTPUT TABLE ttUiEvent,
                                  output table ttSupportedLink    ) NO-ERROR.  
        RUN retrieveDesignObject IN TARGET-PROCEDURE 
                                   ( INPUT  ENTRY(iTableLoop, pcTableNames),
                                     INPUT  "",  /* Get  default result Codes */
                                     OUTPUT TABLE ttObject,
                                     OUTPUT TABLE ttPage,
                                     OUTPUT TABLE ttLink,
                                     OUTPUT TABLE ttUiEvent,
                                     OUTPUT TABLE ttObjectAttribute ) NO-ERROR. 
       
        /* get the Entity attribtues */
        httEntityMnemonic = DYNAMIC-FUNCTION ("getEntityCacheBuffer" IN gshGenManager, ENTRY(iTableLoop, pcTableNames), "":U) NO-ERROR.
        httEntityMnemonic:FIND-FIRST("WHERE ttEntityMnemonic.entity_mnemonic = '":U + ENTRY(iTableLoop, pcTableNames) + "'":U, NO-LOCK) NO-ERROR.
        IF httEntityMnemonic:AVAILABLE THEN
           ASSIGN cKeyField          = httEntityMnemonic:BUFFER-FIELD('EntityKeyField':U):BUFFER-VALUE
                  cEntityObjectField = httEntityMnemonic:BUFFER-FIELD('EntityObjectField':U):BUFFER-VALUE
                  NO-ERROR.
        /* get instances */    
        FOR EACH ttObject WHERE ttObject.tContainerSmartObjectObj > 0:

           phTableFieldBuffer:BUFFER-CREATE().
           ASSIGN phTableFieldBuffer:BUFFER-FIELD("tTableName":U):BUFFER-VALUE     = ENTRY(iTableLoop, pcTableNames)
                  phTableFieldBuffer:BUFFER-FIELD("_Order":U):BUFFER-VALUE         = ttObject.tPageObjectSequence
                  phTableFieldBuffer:BUFFER-FIELD("tKeyField":U):BUFFER-VALUE          = CAN-DO(cKeyField, ttObject.tObjectInstanceName)
                  phTableFieldBuffer:BUFFER-FIELD("tEntityObjectField":U):BUFFER-VALUE = (ttObject.tObjectInstanceName EQ cEntityObjectField)
                  NO-ERROR.
           MAPPING-LOOP:       
           DO iFieldLoop = 1 TO NUM-ENTRIES(cFieldMapping):
               ASSIGN cFieldNameFrom = ENTRY(2, ENTRY(iFieldLoop, cFieldMapping), "=":U)
                      cFieldNameTo   = ENTRY(1, ENTRY(iFieldLoop, cFieldMapping), "=":U).

               FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                        AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj
                                        AND ttObjectAttribute.tAttributelabel    = cFieldNameFrom NO-ERROR.
               IF NOT AVAIL ttObjectAttribute THEN
                  FIND ttClassAttribute WHERE ttClassAttribute.tClassname      = "DataField":U 
                                          AND ttClassAttribute.tAttributeLabel = cFieldNameFrom NO-ERROR.
               IF AVAIL ttObjectAttribute THEN
                  cValue = ttObjectAttribute.tAttributeValue.
               ELSE IF AVAIL ttClassAttribute THEN
                  cValue = ttClassAttribute.tAttributeValue.
               ELSE
                 NEXT MAPPING-LOOP.
               
               RELEASE ttObjectAttribute.
               RELEASE ttClassAttribute.
               
               ASSIGN hFieldNameTo   = phTableFieldBuffer:BUFFER-FIELD(cFieldNameTo) NO-ERROR.
               IF VALID-HANDLE(hFieldNameTo) THEN
                   ASSIGN hFieldNameTo:BUFFER-VALUE = cValue NO-ERROR.
           END.    /* loop through attributes. */

           phTableFieldBuffer:BUFFER-RELEASE().

        END.    /* For each ttobject (instances ) */
    END.    /* loop through tables */

    /* Determine whether to return the buffer or handle. */
    IF (SESSION:CLIENT-TYPE = "APPSERVER":U OR
        SESSION:CLIENT-TYPE = "MULTI-SESSION-AGENT":U )AND
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
ACCUESS_LEVEL=PUBLIC
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
      dSourceSmartObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN TARGET-PROCEDURE, INPUT pcNameObjectSource, INPUT dCustomisationResultObj).
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
      dTargetSmartObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN TARGET-PROCEDURE, INPUT pcNameObjectTarget, INPUT dCustomisationResultObj).
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
        dSmartObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN TARGET-PROCEDURE, INPUT pcNameContainer, INPUT dCustomisationResultObj).
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

      RUN removeObject IN TARGET-PROCEDURE
                      (INPUT pcNameObjectSource,
                       INPUT pcResultCode).

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
ACCESS_LEVEL=PUBLIC
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

  /* Definitoins for SCM integration */
  DEFINE VARIABLE hScmTool            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lScmChecksOn        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cOldScmObjectType   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewScmObjectType   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectTypeCode     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dObjectTypeObj      AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cError              AS CHARACTER  NO-UNDO.
  
  IF NOT VALID-HANDLE(hScmTool)  THEN
    ASSIGN hScmTool = DYNAMIC-FUNCTION('getProcedureHandle':U IN THIS-PROCEDURE, INPUT 'PRIVATE-DATA:SCMTool':U) NO-ERROR.

  ASSIGN lScmChecksOn = FALSE.
  IF VALID-HANDLE(hScmTool) THEN
  DO:
    ASSIGN lScmChecksOn = DYNAMIC-FUNCTION('scmChecksOn':U IN hScmTool).
  END.
  
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
      
    IF lScmChecksOn THEN
    DO:
      /* First get the old SCM object type */
      RUN scmGetRepoXref IN hScmTool (INPUT "RTB":U, 
                                      INPUT bgsc_object_type.object_type_code, 
                                      INPUT "GSCOT":U, 
                                      INPUT 0,
                                      INPUT "":U, 
                                      OUTPUT cObjectTypeCode, 
                                      OUTPUT dObjectTypeObj, 
                                      OUTPUT cOldScmObjectType, 
                                      OUTPUT cError) 
                                      NO-ERROR. 
                        
      IF cOldScmObjectType = "":U THEN      
        RETURN {af/sup2/aferrortxt.i 'SCM' '1' '?' '?' "'Object Type'" bgsc_object_type.object_type_code}.      

      /* First get the old SCM object type */
      RUN scmGetRepoXref IN hScmTool (INPUT "RTB":U, 
                                      INPUT bnew_object_type.object_type_code, 
                                      INPUT "GSCOT":U, 
                                      INPUT 0,
                                      INPUT "":U, 
                                      OUTPUT cObjectTypeCode, 
                                      OUTPUT dObjectTypeObj, 
                                      OUTPUT cNewScmObjectType, 
                                      OUTPUT cError) 
                                      NO-ERROR. 
                          
      IF cNewScmObjectType = "":U THEN      
        RETURN {af/sup2/aferrortxt.i 'SCM' '1' '?' '?' "'Object Type'" bnew_object_type.object_type_code}.      
      
      /* The current limitation is that we ar eonly allowed to change the object type of an object if 
         the SCM object type is the same for both the new and the old objec type. 
          
          This may change later when the SCm tool (RTB) suppors this. */
      IF cNewScmObjectType NE cOldScmObjectType THEN
        RETURN {af/sup2/aferrortxt.i 'SCM' '2' '?' '?' "'Object Type'" bgsc_object_type.object_type_code bnew_object_type.object_type_code}.      
    END.
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

  IF plRemoveDefaultAttr OR plRemoveNonOTAttr THEN
      RUN removeDefaultAttrValues IN TARGET-PROCEDURE
                      (INPUT pcObjectFileName,
                       INPUT plRemoveDefaultAttr,
                       INPUT plRemoveNonOTAttr).
  &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearDesignCache Include 
PROCEDURE clearDesignCache :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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

           gcCLASS-USES-EXTENSION   = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "{&CLASS-USES-EXTENSION}":U)
           gcCLASS-USES-EXTENSION   = REPLACE(gcCLASS-USES-EXTENSION, CHR(3), ",")

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyObjectMaster Include 
PROCEDURE copyObjectMaster :
/*------------------------------------------------------------------------------
  Purpose:     Creates a deep copy of an object.
  Parameters:  pcSourceObjectName    -
               pcSourceResultCode    -
               pcTargetObjectName    -
               pcTargetClass         -
               pcTargetProductModule -
               pcTargetRelativePath  -
               plCreatedAggregated   -
               pdSmartObjectObj      -
  Notes:       * This can be used for "Save As ..." functionality.
               * This is a PUBLIC API.
               * If a non-default result code is specified, then the API will ensure
                 that a record exists for the DEFAULT-RESULT-CODE and the specified
                 result code. This is so that the newly created object is a complete
                 object in its own right.                 
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcSourceObjectName          AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcSourceResultCode          AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcTargetObjectName          AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcTargetClass               AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcTargetProductModule       AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcTargetRelativePath        AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pdSmartObjectObj            AS DECIMAL          NO-UNDO.

    &IF DEFINED(Server-Side) EQ 0 &THEN
    {dynlaunch.i
        &Plip   = 'RepositoryDesignManager'
        &IProc  = 'copyObjectMaster'
        
        &mode1 = INPUT  &parm1 = pcSourceObjectName     &dataType1 = CHARACTER
        &mode2 = INPUT  &parm2 = pcSourceResultCode     &dataType2 = CHARACTER
        &mode3 = INPUT  &parm3 = pcTargetObjectName     &dataType3 = CHARACTER
        &mode4 = INPUT  &parm4 = pcTargetClass          &dataType4 = CHARACTER
        &mode5 = INPUT  &parm5 = pcTargetProductModule  &dataType5 = CHARACTER
        &mode6 = INPUT  &parm6 = pcTargetRelativePath   &dataType6 = CHARACTER
        &mode7 = OUTPUT &parm7 = pdSmartObjectObj       &dataType7 = DECIMAL
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE   
    /** All code moved into an include because of section editor limits.
     *  ----------------------------------------------------------------------- **/
    RUN ry/app/rydescpmop.p ( INPUT  pcSourceObjectName,
                              INPUT  pcSourceResultCode,
                              INPUT  pcTargetObjectName,
                              INPUT  pcTargetClass,
                              INPUT  pcTargetProductModule,
                              INPUT  pcTargetRelativePath,
                              OUTPUT pdSmartObjectObj           ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    &ENDIF
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* copyObjectMaster */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doServerRetrieveClassExtInfo Include 
PROCEDURE doServerRetrieveClassExtInfo :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     
  Parameters:  <none>
  Notes:       
*** THIS API HAS BEEN DEPRECATED ***  
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcClassName          AS CHARACTER            NO-UNDO.
    RETURN ERROR "*** THIS API HAS BEEN DEPRECATED ***":U.
END PROCEDURE.  /* doServerRetrieveClassExtInfo */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE editRyObjectInAB Include 
PROCEDURE editRyObjectInAB :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
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

  RUN getRecordDetail IN gshGenManager (INPUT cQuery,
                                       OUTPUT cFieldValues) NO-ERROR.

  IF cFieldValues = "":U THEN
    cObjectFilename = pcObjectFilename.
  ELSE
  DO:
    ASSIGN
        cObjectFilename = ENTRY(LOOKUP("ryc_smartobject.object_filename":U,  cFieldValues, CHR(3)) + 1, cFieldValues, CHR(3))
        cObjectTypeCode = ENTRY(LOOKUP("gsc_object_type.object_type_code":U, cFieldValues, CHR(3)) + 1, cFieldValues, CHR(3)).

    IF LOOKUP(cObjectTypeCode, {fnarg getClassChildrenFromDB 'Toolbar' gshRepositoryManager}) <> 0 THEN
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
        cRunAttribute = "AppBuilder":U + CHR(3) + CHR(3) + CHR(3) + "EditMaster":U.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exportClassCache Include 
PROCEDURE exportClassCache :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcClassList            as character        no-undo.
    define input parameter pcOutputDir            as character        no-undo.
    
    define variable cDateFormat                as character            no-undo.
    define variable cNumericSeparator          as character            no-undo.
    define variable cNumericPoint              as character            no-undo.    
    define variable hClassBuffer               as handle               no-undo.
    define variable cMessage                   as character            no-undo.
    define variable hQuery                     as handle               no-undo.
    define variable cOutputFilename            as character            no-undo.
    define variable cWhere                     as character            no-undo.
    define variable iLoop                      as integer              no-undo.
    define variable lOk                        as logical              no-undo.
    define variable hDeploymentHelper          as handle no-undo.
    define variable iErrorNum                  as integer no-undo.
    
    /* Don't kill this off - it gets used by various processes in the deployment automation,
       which is where this API can be called from. Using startProcedure() to start it means
       that only one instance is started. */
    run startProcedure in target-procedure ("ONCE|af/app/afdeplyhlp.p":U, output hDeploymentHelper).
    if not valid-handle(hDeploymentHelper) then
        return error {aferrortxt.i 'AF' '40' '?' '?' "'Unable to start Deployment Helper procedure (af/app/afdeplyhlp.p)'"}.
    
    /* Make sure the directory exists and is writable */
    if pcOutputDir eq ? then
        return error {aferrortxt.i 'AF' '1' '?' '?' '"output directory"'}.
    
    /* Blank defaults to working directory */    
    if pcOutputDir eq '':u then
        pcOutputDir = '.':u.
    
    pcOutputDir = replace(pcOutputDir, '~\', '/').    
    pcOutputDir = pcOutputDir + '/':u.
    if pcOutputDir eq '/':u then
        pcOutputDir = '':u.
    
    iErrorNum = dynamic-function('prepareDirectory':u in hDeploymentHelper,
                                  pcOutputdir,
                                  No,     /* clear contents? */
                                  Yes     /* create if missing */ ).
    if iErrorNum gt 0 then
        return error {aferrortxt.i 'AF' '40' '?' '?' "'Unable to write to directory ' + pcOutputdir"}.

    /* Default to ALL classes */
    if pcClassList eq ? or pcClassList eq '':u then
        pcClassList = '*':u.

    /* The formats need to be converted to American and mdy before dump so that it is consistent.
       
       DO NOT SIMPLY RETURN BEFORE RESETTING TO THE ORIGINAL VALUES. */
    cDateFormat = session:date-format.
    cNumericSeparator = session:numeric-separator.
    cNumericPoint = session:numeric-decimal-point.
    session:date-format = "mdy":u.
    session:numeric-format = "American":u.
    
    /* Get the class information from the repository API - this will fetch from the database */
    hClassBuffer = {fnarg getCacheClassBuffer pcClasslist gshRepositoryManager}.
    if valid-handle(hClassBuffer) then
    do:
        cWhere = 'for each ':u + hClassBuffer:name.
        if pcClassList ne '*':u then
        do:
            cWhere = cWhere + ' where false ':u.
            do iLoop = 1 to num-entries(pcClassList):
                cWhere = cWhere + ' or ':u
                       + hClassBuffer:name + '.ClassName = ':u
                       + quoter(entry(iLoop, pcClassList)).
            end.    /* loop */
        end.    /* don't get all */
        
        create query hQuery.
        hquery:set-buffers(hClassBuffer).
        hQuery:query-prepare(cWhere).
        hQuery:query-open().
        
        hQuery:get-first().
        do while hClassBuffer:available:
            cOutputFilename = pcOutputDir + '/':u + 'c_':u + hClassBuffer::ClassName + '.p':u.
            
            lOk = dynamic-function('createClassCacheFile':u in target-procedure,
                                   cOutputFilename, hClassBuffer).
                                   
            if not lOk then
            do:
                cMessage = 'Unable to create output file for class ' + hClassBuffer::ClassName.
                leave.
            end.
            
            compile value(cOutputFilename) no-error.
            if error-status:error or compiler:error then
            do:
                cMessage = 'Unable to compile file ' + cOutputFilename + ' for class ' + hClassBuffer::ClassName.
                leave.
            end.    /* compiler error */
            
            hQuery:get-next().
        end.    /* available class buffer */
        hQuery:query-close().
        delete object hQuery no-error.
        hquery = ?.
    end.    /* valid class buffer */
    else
        /* Don't return immediately since we need to clean up first. */
        cMessage = 'Unable to retrieve classes for class list ' + pcClassList.
    
    /* Reset the date and numeric formats */
    session:date-format = cDateFormat.
    session:set-numeric-format(cNumericSeparator, cNumericPoint).
    
    error-status:error = no.
    if cMessage eq '':u then
        return.
    else
        return error cMessage.
END PROCEDURE.    /* exportClassCache */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exportEntityCache Include 
PROCEDURE exportEntityCache :
/*------------------------------------------------------------------------------
  Purpose:    Dumps out entities in .D format.
  Parameters: (I) pcEntityList 
              (I) pcLanguageList
              (I) pcOutputDir
  Notes:      
------------------------------------------------------------------------------*/
    define input parameter pcEntityList                as character        no-undo.
    define input parameter pcLanguageList              as character        no-undo.
    define input parameter pcOutputDir                 as character        no-undo.
    
    define variable cError                          as character no-undo.
    define variable cMessage                        as character no-undo.
    define variable hDeploymentHelper               as handle no-undo.
    define variable iErrorNum                       as integer no-undo.
    
    /* Don't kill this off - it gets used by various processes in the deployment automation,
       which is where this API can be called from. Using startProcedure() to start it means
       that only one instance is started. */
    run startProcedure in target-procedure ("ONCE|af/app/afdeplyhlp.p":U, output hDeploymentHelper).
    if not valid-handle(hDeploymentHelper) then
        return error {aferrortxt.i 'AF' '40' '?' '?' "'Unable to start Deployment Helper procedure (af/app/afdeplyhlp.p)'"}.
    
    /* Make sure the directory exists and is writable */
    if pcOutputDir eq ? then
        return error {aferrortxt.i 'AF' '1' '?' '?' '"output directory"'}.
    
    /* Blank defaults to working directory */    
    if pcOutputDir eq '':u then
        pcOutputDir = '.':u.
    
    iErrorNum = dynamic-function('prepareDirectory':u in hDeploymentHelper,
                                  pcOutputdir,
                                  No,     /* clear contents? */
                                  Yes     /* create if missing */ ).
    if iErrorNum gt 0 then
        return error {aferrortxt.i 'AF' '40' '?' '?' "'Unable to write to directory ' + pcOutputdir"}.

    /* Make sure we have a language list */
    if pcLanguageList eq '':u or pcLanguageList eq ? then
    do:
        pcLanguageList = dynamic-function('getPropertyList':u in gshSessionManager,
                                          'CurrentLanguageCode':u, yes).
        if pcLanguageList eq '':u or pcLanguageList eq ? then
            pcLanguageList = 'None':u.
    end.    /* language list */
    
    cError = dynamic-function('createEntityCacheFile':u in gshRepositoryManager,
                              input pcEntityList,
                              input pcLanguageList,
                              input pcOutputDir,
                              input No, /* plDeleteExisting */
                              input-output cMessage ).
    if cError ne '':u then
        return error cError.
    
    error-status:error = no.
    return.        
END PROCEDURE.    /* exportEntityCache */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateCalculatedField Include 
PROCEDURE generateCalculatedField :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
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

    RUN ry/app/rydesgecfp.p ON gshAstraAppServer ( INPUT pcCalcFieldName,
                                                   INPUT pcDataType,
                                                   INPUT pcFieldFormat,
                                                   INPUT pcFieldLabel,
                                                   INPUT pcFieldHelp,
                                                   INPUT pcProductModuleCode,
                                                   INPUT pcResultCode,
                                                   INPUT pcObjectTypeCode    ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generateCalculatedField */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateClassCache Include 
PROCEDURE generateClassCache :
/*------------------------------------------------------------------------------
  /* Public - Draft needs to be finalized */
  
  Purpose:     This proc will output the class cache to the disk
  Parameters:  Input - ClassList - a Comma seaparated list of Classes to output
               Output - psStatus - Status of the class cache.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcClassList     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcStatus        AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE httClass           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hClassBuffer       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFileName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullFileName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hQuery             AS WIDGET-HANDLE.
  DEFINE VARIABLE cClassCacheDir     AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hAttributeBuffer   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hAttributeTable    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hEventBufferHandle AS HANDLE  NO-UNDO.
  DEFINE VARIABLE dDlObj             AS DECIMAL NO-UNDO.
  DEFINE VARIABLE cDesc              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lFileWritable      AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cClassName           AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cDateFormat          AS CHARACTER  NO-UNDO.
  DEFINE variable cNumericPoint        as character  no-undo.
  DEFINE variable cNumericSeparator    as character  no-undo.
  
  /* let us output to the log file */
  ASSIGN ERROR-STATUS:ERROR = FALSE
         pcStatus           = "Getting the selected class information from the Repository.".
  
  /* Now let us get the path for the directory based on the prodyct module */
  RUN getClientCacheDir IN gshRepositoryManager (INPUT "ry-clc", OUTPUT cClassCacheDir) NO-ERROR.
  IF (ERROR-STATUS:ERROR) THEN
    RETURN ERROR RETURN-VALUE.

  ASSIGN pcStatus = pcStatus + chr(10) + "All classes will be generated to the following directory: " + cClassCacheDir.

  /* The formats need to be converted to American and mdy before dump so that it is consistent */
  ASSIGN cDateFormat = SESSION:DATE-FORMAT
         cNumericSeparator = SESSION:NUMERIC-separator
         cNumericPoint = session:numeric-decimal-point
         SESSION:DATE-FORMAT = "mdy"
         SESSION:NUMERIC-FORMAT = "American".
  
  /* Before getting the class information from memory, we will first delete the 
     class cache from the disk and then destroy the class cache in memory
     This will ensure that only the latest changes are picked-up. 
  */
  DO i = 1 TO NUM-ENTRIES(pcClassList, ",":U):
    ASSIGN cClassName = ENTRY(i, pcClassList, ",":U).
    IF cClassName = "":U OR cClassName = ? THEN NEXT.

    /* Get the file name */
    ASSIGN cFileName = "class_" + cClassName 
      cFullFileName = RIGHT-TRIM(cClassCacheDir, "/":U) + (IF cClassCacheDir > "":U THEN "/" ELSE "") + cFileName.

    /* If the file exists, let's delete the .p file */
    OS-DELETE VALUE(cFullFileName + ".p").

    /* If the file exists, let's delete the .r file too */
    OS-DELETE VALUE(cFullFileName + ".r").

  END.

  /* Now let's clear the memory - After this step, there is no class cache on 
     disk and there is no cache in memory */
  RUN destroyClassCache IN gshRepositoryManager NO-ERROR.

  /* Get the class information from the repository API - this will fetch from the database */
  httClass = DYNAMIC-FUNCTION("getCacheClassBuffer" IN gshRepositoryManager, pcClassList) NO-ERROR.
  
  IF ERROR-STATUS:ERROR OR NOT VALID-HANDLE(httClass) THEN
  DO:
    /* Let's set the formats back to session settings. */
    ASSIGN SESSION:DATE-FORMAT = cDateFormat.
    SESSION:set-NUMERIC-FORMAT(cNumericSeparator, cNumericPoint).
           
    RETURN ERROR "getCacheClassBuffer call to repository Manager failed: " + RETURN-VALUE.
  END.
  
  /* Build the where clause based on the class list */
  ASSIGN cWhere = "".
  DO i = 1 TO NUM-ENTRIES(pcClassList, ",":U):
    IF ( ENTRY(i, pcClassList, ",":U) > "":U ) THEN
      ASSIGN cWhere = cWhere + (IF cWhere > "":U THEN " OR " ELSE " WHERE ")
             cWhere = cWhere + httClass:NAME + ".ClassName = ":U + QUOTER(ENTRY(i, pcClassList, ",":U)).
  END.
  
  /* Create the query and get ready for class information */
  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS(httClass). 
  hQuery:QUERY-PREPARE("FOR EACH " + httClass:NAME + cWhere).
  hQuery:QUERY-OPEN.
  hQuery:GET-FIRST().
  
  /* let us output to the log file */
  pcStatus = pcStatus + CHR(10) + "Starting class generation for classes that inherit from 'Base' Class.".
  
  DO WHILE httClass:AVAILABLE:
    /* Get the class bufffer handle, clas name and inheritance information */
    cClassName           = httClass:BUFFER-FIELD('ClassName'):BUFFER-VALUE.
  
    /* Get the file name */
    ASSIGN cFileName = "class_" + cClassName + ".p"
      cFullFileName = RIGHT-TRIM(cClassCacheDir, "/":U) + (IF cClassCacheDir > "":U THEN "/" ELSE "") + cFileName.

    /* If the file is not writable then log an error and go to the next */
    FILE-INFO:FILE-NAME = cFullFileName.
    IF (FILE-INFO:FILE-TYPE <> ? AND INDEX(FILE-INFO:FILE-TYPE,'W':U) = 0 ) THEN
    DO:
      ASSIGN pcStatus = pcStatus + CHR(10) + "Can not generate class for the class : " + cClassName + " as file is not writable". .
      hQuery:GET-NEXT().
      NEXT.
    END.
    /* let us output to the log file */
    pcStatus = pcStatus + CHR(10) + "Generating cache for the class: " + 
                   cClassName + " in file: " + cFullFileName .
    
    dynamic-function('createClassCacheFile':u in target-procedure, cFullFileName, httClass).
    
    /* Now let us try and compile the file */
    COMPILE VALUE(cFullFileName) SAVE NO-ERROR.
    IF ERROR-STATUS:ERROR OR COMPILER:ERROR THEN
       ASSIGN pcStatus = pcStatus + CHR(10) + "Compiling of : " + cFullFileName + 
                 " Failed: " + ERROR-STATUS:GET-MESSAGE(1).

    /* register the object */
    ASSIGN cDesc = "Class cache procedure for class: " + cClassName.

    RUN insertObjectMaster IN TARGET-PROCEDURE( 
      INPUT  cFileName,                    /* pcObjectName         */
      INPUT  "":U,                          /* pcResultCode         */
      INPUT  "ry-clc",                      /* pcProductModuleCode  */
      INPUT  "Procedure",                   /* pcObjectTypeCode     */
      INPUT  cDesc,                         /* pcObjectDescription  */
      INPUT  "":U,                          /* pcObjectPath         */
      INPUT  "":U,                          /* pcSdoObjectName      */
      INPUT  "":U,                          /* pcSuperProcedureName */
      INPUT  NO,                            /* plIsTemplate         */
      INPUT  YES,                           /* plIsStatic           */
      INPUT  "":U,                          /* pcPhysicalObjectName */
      INPUT  NO,                            /* plRunPersistent      */
      INPUT  "":U,                          /* pcTooltipText        */
      INPUT  "":U,                          /* pcRequiredDBList     */
      INPUT  "":U,                          /* pcLayoutCode         */
      INPUT  hAttributeBuffer,
      INPUT  TABLE-HANDLE hAttributeTable,
      OUTPUT dDlObj) NO-ERROR.

    IF (ERROR-STATUS:ERROR) THEN
    DO:
      hQuery:QUERY-CLOSE().
      DELETE OBJECT hQuery.  
      session:date-format = cDateFormat.
      SESSION:set-NUMERIC-FORMAT(cNumericSeparator, cNumericPoint).
      RETURN ERROR "Object Registration failed: " + RETURN-VALUE.
    END.
    hQuery:GET-NEXT().
  END.
  
  /* Clean-up */
  hQuery:QUERY-CLOSE().
  DELETE OBJECT hQuery.  
  
  /* Let's set the formats back to session settings. */
  ASSIGN SESSION:DATE-FORMAT = cDateFormat.
  SESSION:set-NUMERIC-FORMAT(cNumericSeparator, cNumericPoint).

  RETURN "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateDataFields Include 
PROCEDURE generateDataFields :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
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

    RUN ry/app/rydesgedfp.p ON gshAstraAppserver ( INPUT pcDataBaseName,
                                                   INPUT pcTableName,
                                                   INPUT pcProductModuleCode,
                                                   INPUT pcResultCode,
                                                   INPUT plGenerateFromDataObject,
                                                   INPUT pcDataObjectFieldList,
                                                   INPUT pcSdoObjectName,
                                                   INPUT pcObjectTypeCode,
                                                   INPUT pcOverrideAttributes,
                                                   INPUT pcFieldNames            ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generateDataFields */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateDataLogicObject Include 
PROCEDURE generateDataLogicObject :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
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

    RUN ry/app/rydesgdlop.p ON gshAstraAppserver ( INPUT pcDatabaseName,
                                                   INPUT pcTableName,
                                                   INPUT pcDumpName,
                                                   INPUT pcDataObjectName,
                                                   INPUT pcProductModule,        
                                                   INPUT pcResultCode,         
                                                   INPUT plSuppressValidation,
                                                   INPUT pcLogicProcedureName,
                                                   INPUT pcLogicObjectType,
                                                   INPUT pcLogicProcedureTemplate,
                                                   INPUT pcDataObjectRelativePath,
                                                   INPUT pcDataLogicRelativePath,
                                                   INPUT pcRootFolder, 
                                                   INPUT pcFolderIndicator,
                                                   INPUT plCreateMissingFolder    ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generateDataLogicObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateDataObject Include 
PROCEDURE generateDataObject :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
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

    RUN ry/app/rydesgedop.p ON gshAstraAppserver ( INPUT pcDatabaseName,
                                                   INPUT pcTableName,
                                                   INPUT pcDumpName,
                                                   INPUT pcDataObjectName,
                                                   INPUT pcObjectTypeCode,
                                                   INPUT pcProductModule,
                                                   INPUT pcResultCode,
                                                   INPUT plCreateSDODataFields,
                                                   INPUT plSdoDeleteInstances,   
                                                   INPUT plSuppressValidation,
                                                   INPUT plFollowJoins,    
                                                   INPUT piFollowDepth,           
                                                   INPUT pcFieldSequence,
                                                   INPUT pcLogicProcedureName,
                                                   INPUT pcDataObjectRelativePath,
                                                   INPUT pcDataLogicRelativePath,
                                                   INPUT pcRootFolder,
                                                   INPUT plCreateMissingFolder,
                                                   INPUT pcAppServerPartition     ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generateDataObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateDynamicBrowse Include 
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

    RUN ry/app/rydesgedbp.p ON gshAstraAppserver ( INPUT  pcObjectTypeCode,
                                                   INPUT  pcObjectName,
                                                   INPUT  pcObjectDescription,
                                                   INPUT  pcProductModuleCode,    
                                                   INPUT  pcResultCode,
                                                   INPUT  pcSdoObjectName,
                                                   INPUT  plDeleteExistingInstances,
                                                   INPUT  pcDisplayedDatabases,
                                                   INPUT  pcEnabledDatabases,
                                                   INPUT  pcDisplayedTables,
                                                   INPUT  pcEnabledTables,
                                                   INPUT  pcDisplayedFields,
                                                   INPUT  pcEnabledFields,       
                                                   INPUT  piMaxFieldsPerColumn,
                                                   INPUT  pcDataObjectFieldSequence,
                                                   INPUT  pcDataObjectFieldList,
                                                   OUTPUT pdVisualObjectObj              ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).    

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.    
END PROCEDURE.  /* generateDynamicBrowse */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateDynamicSDF Include 
PROCEDURE generateDynamicSDF :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
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

    RUN ry/app/rydesgsdfp.p ON gshAstraAppServer ( INPUT  pcObjectName,
                                                   INPUT  pcObjectDescription,
                                                   INPUT  pcProductModuleCode,
                                                   INPUT  pcResultCode,
                                                   INPUT  plDeleteExistingInstances,
                                                   INPUT  pcSDFType,
                                                   INPUT  pcSuperProcedure,
                                                   INPUT  pcAttributeLabels,        
                                                   INPUT  pcAttributeValues,       
                                                   INPUT  pcAttributeDataType,
                                                   OUTPUT pdSDFObjectObj            ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generateDynamicSDF */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateDynamicViewer Include 
PROCEDURE generateDynamicViewer :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
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

    RUN ry/app/rydesgedvp.p ON gshAstraAppserver ( INPUT  pcObjectTypeCode,
                                                   INPUT  pcObjectName,
                                                   INPUT  pcObjectDescription,
                                                   INPUT  pcProductModuleCode,
                                                   INPUT  pcResultCode,
                                                   INPUT  pcSdoObjectName,
                                                   INPUT  plDeleteExistingInstances,
                                                   INPUT  pcDisplayedDatabases,
                                                   INPUT  pcEnabledDatabases,    
                                                   INPUT  pcDisplayedTables,      
                                                   INPUT  pcEnabledTables,       
                                                   INPUT  pcDisplayedFields,
                                                   INPUT  pcEnabledFields,       
                                                   INPUT  piMaxFieldsPerColumn,
                                                   INPUT  pcDataObjectFieldSequence,
                                                   INPUT  pcDataObjectFieldList,
                                                   OUTPUT pdVisualObjectObj        ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generateDynamicViewer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateEntityInstances Include 
PROCEDURE generateEntityInstances :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
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
    
    RUN ry/app/rydesgeeip.p ON gshAstraAppserver ( INPUT pcEntityObjectName,
                                                   INPUT pcFieldList,
                                                   INPUT plDeleteExistingInstances ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generateEntityInstances */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateEntityObject Include 
PROCEDURE generateEntityObject :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
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

    RUN ry/app/rydesgeeop.p ON gshAstraAppServer ( INPUT pcTableNames,
                                                   INPUT pcEntityObjectType,
                                                   INPUT pcEntityProductModule,
                                                   INPUT plAutoProPerform,
                                                   INPUT piPrefixLength,    
                                                   INPUT pcSeparator,
                                                   INPUT pcAuditingEnabled,
                                                   INPUT pcDescFieldQualifiers,
                                                   INPUT pcKeyFieldQualifiers,
                                                   INPUT pcObjFieldQualifiers,
                                                   INPUT plDeployData,
                                                   INPUT plVersionData,
                                                   INPUT plReuseDeletedKeys,
                                                   INPUT plAssociateDataFields  ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generateEntityObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateSBODataLogicObject Include 
PROCEDURE generateSBODataLogicObject :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
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

    RUN ry/app/rydesgsdlp.p ON gshAstraAppserver ( INPUT pcDatabaseName,
                                                   INPUT pcTableList,
                                                   INPUT pcDumpName,
                                                   INPUT pcDataObjectName,
                                                   INPUT pcProductModule,
                                                   INPUT pcResultCode,
                                                   INPUT pcLogicProcedureName,
                                                   INPUT pcLogicObjectType,    
                                                   INPUT pcLogicProcedureTemplate,
                                                   INPUT pcDataLogicRelativePath,
                                                   INPUT pcRootFolder, 
                                                   INPUT pcIncludeFileList,
                                                   INPUT plCreateMissingFolder    ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generateSBODataLogicObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateSDOInstances Include 
PROCEDURE generateSDOInstances :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
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

    RUN ry/app/rydesgesip.p ON gshAstraAppserver ( INPUT pcSdoObjectName,
                                                   INPUT pcResultCode,
                                                   INPUT plDeleteExistingInstances,
                                                   INPUT pcTableList                ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.    
END PROCEDURE.  /* generateSDOInstances */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateVisualObject Include 
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

    RUN ry/app/rydesgevop.p ON gshAstraAppserver (  INPUT  pcObjectType,
                                                    INPUT  pcObjectName,
                                                    INPUT  pcProductModuleCode,
                                                    INPUT  pcResultCode,
                                                    INPUT  pcSdoObjectName,
                                                    INPUT  pcTableName,         
                                                    INPUT  pcDataBaseName,
                                                    INPUT  piMaxObjectFields,
                                                    INPUT  piMaxFieldsPerColumn,
                                                    INPUT  plGenerateFromDataObject,
                                                    INPUT  pcDataObjectFieldList,
                                                    INPUT  plDeleteExistingInstances,
                                                    INPUT  pcDataObjectFieldSequence,
                                                    INPUT  plUseSDOFieldOrder,
                                                    OUTPUT pdVisualObjectObj          ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generateVisualObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE insertAttributeValues Include 
PROCEDURE insertAttributeValues :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
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

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* insertAttributeValues */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE insertClass Include 
PROCEDURE insertClass :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     Adds and modifies a class to/in the repository.
  Parameters:  unless specified:
                                        non-mandatory.
                                        ? keeps existing value.
                                        blanks allowed.
        pcClassName: unique name of class. mandatory.
        pcClassDescription: description of class. blanks not allowed.
        pcExtendsClassName: name of class that this class extends. 
        pcCustomClassName: name of class that customises this class. The custom
                                           class cannot inherit from the same class that pcClassName
                                           does.
        plClassDisabled: whether class is disabled
        plLayoutSupported: whether layouts supported for this class
        pcDeploymentType: where objects deployed by default.
                          one or more of 'Cli,Srv,Web' or blank.
        plStaticObject:
        plCacheOnClient: whether P-code can be generated and deployed onto client.
        pcClassObjectName: class object name. not used. matches a smartobject record
                                           of procedure type.   
        pdClassObj: _obj of the class being maintained                                             
  Notes: * attributes are set using the storeAttributeValues() API.
                 * events, supported links have their own api too.       
------------------------------------------------------------------------------*/
    DEFINE input parameter pcClassName            as character         no-undo.
    DEFINE input parameter pcClassDescription     as character         no-undo.
    DEFINE input parameter pcExtendsClassName     as character         no-undo.
    DEFINE input parameter pcCustomClassName      as character         no-undo.    
    DEFINE input parameter plClassDisabled        as logical           no-undo.
    DEFINE input parameter plLayoutSupported      as logical           no-undo.
    DEFINE input parameter pcDeploymentType       as character         no-undo.
    DEFINE input parameter plStaticObject         as logical           no-undo.
    DEFINE input parameter plCacheOnClient        as logical           no-undo.    
    DEFINE input parameter pcClassObjectName      as character         no-undo.    
    DEFINE output parameter pdClassObj            as decimal           no-undo.
    
    &IF DEFINED(Server-Side) EQ 0 &THEN    
    { dynlaunch.i 
        &PLIP  = 'RepositoryDesignManager'
        &iProc = 'insertClass'
                &mode1  = input  &parm1  = pcClassName        &dataType1  = character
                &mode2  = input  &parm2  = pcClassDescription &dataType2  = character
                &mode3  = input  &parm3  = pcExtendsClassName &dataType3  = character
                &mode4  = input  &parm4  = pcCustomClassName  &dataType4  = character
                &mode5  = input  &parm5  = plClassDisabled    &dataType5  = logical
                &mode6  = input  &parm6  = plLayoutSupported  &dataType6  = logical
                &mode7  = input  &parm7  = pcDeploymentType   &dataType7  = character
                &mode8  = input  &parm8  = plStaticObject     &dataType8  = logical
                &mode9  = input  &parm9  = plCacheOnClient    &dataType9  = logical
                &mode10 = input  &parm10 = pcClassObjectName  &dataType10 = character
                &mode11 = output &parm11 = pdClassObj         &dataType11 = decimal
    }
    IF RETURN-VALUE <> "":U or error-status:error THEN RETURN ERROR RETURN-VALUE.   
    &ELSE
    DEFINE variable iLoop                as integer                        no-undo.
    DEFINE variable dClassObj            as decimal                        no-undo.
    DEFINE variable cBaseParents         as character                      no-undo.
    
    DEFINE buffer gscot        for gsc_object_type.
    DEFINE buffer gscot_extend for gsc_object_type.
    
    /* Class name is mandatory */
    if pcClassName eq '' or pcClassName eq ? then
        return error {aferrortxt.i 'AF' '1' '?' '?' '"class name"'}.
        
    find gscot where
         gscot.object_type_code = pcClassName
         exclusive-lock no-wait no-error.
         
    if locked gscot then    
        return error {aferrortxt.i 'AF' '104' '?' '?' "'class ' + pcClassName"}.
        
    if not available gscot then
    do:
        create gscot no-error.
        if error-status:error or return-value ne '' then return error return-value.
        
        assign gscot.object_type_code = pcClassName no-error.        
        if error-status:error or return-value ne '' then return error return-value.
    end.    /* create class */
    
    assign pdClassObj = gscot.object_type_obj.
    
    /* update existing class */
    case pcClassDescription:
        when '' then return error {aferrortxt.i 'AF' '1' 'gscot' 'object_type_description' '"class description"'}.
        when ? then
        do:
            /* new classes must have a description. */
            if new gscot then
                return error {aferrortxt.i 'AF' '1' 'gscot' 'object_type_description' '"class description"'}.
        end.    /* value is ? */
        otherwise gscot.object_type_description = pcClassDescription.
    end case.    /* description */    
    
    /* get the parent class name */
    if pcExtendsClassName ne ? then
    do:
        if pcExtendsClassName eq '' then
            dClassObj = 0.
        else
        do:
            find gscot_extend where
                 gscot_extend.object_type_code = pcExtendsClassName
                 no-lock no-error.
            if not available gscot_extend then
                return error {aferrortxt.i 'AF' '5' 'gscot_extend' 'object_type_code' '"class"' "'Class name: ' + pcExtendsClassName"}.
            
            dClassObj = gscot_extend.object_type_obj.
        end.    /* non-blank */
                
        gscot.extends_object_type_obj = dClassObj.
    end.    /* extends class name changed */    
        
    /* get the custom class name */
    if pcCustomClassName ne ? then
    do:
        if pcCustomClassName eq '' then
            dClassObj = 0.
        else
        do:
            find gscot_extend where
                 gscot_extend.object_type_code = pcCustomClassName
                 no-lock no-error.
            if not available gscot_extend then
                return error {aferrortxt.i 'AF' '5' 'gscot_extend' 'object_type_code' '"class"' "'Class name: ' + pcCustomClassName"}.
            
            dClassObj = gscot_extend.object_type_obj.
        end.    /* non-blank */
        
        /* now that it exists, does it live in the same tree as
           the class that it customises?
           
           if this is a new class then check against the class' parent
           class.           
         */
        if new gscot then
            cBaseParents = {fnarg getClassParents pcExtendsClassName gshRepositoryManager} no-error.
        else
            cBaseParents = {fnarg getClassParents pcClassName gshRepositoryManager} no-error.
        
        if cBaseParents ne '' and
           dynamic-function("classIsA":U in gshRepositoryManager,
                            pcCustomClassName, entry(num-entries(cBaseParents), cBaseParents)) then                            
            return error {aferrortxt.i 'AF' '40' 'gsc_object_type' 'custom_object_type_obj'
                                       "'The selected class cannot inherit from the ' + entry(num-entries(cBaseParents), cBaseParents) + ' class when used for customising this class.'"}.
        
        gscot.custom_object_type_obj = dClassObj.
    end.    /* custom class name changed */    
    
    /* logicals, no validation */        
    if plClassDisabled ne ? then gscot.disabled = plClassDisabled.
    if plLayoutSupported ne ? then gscot.layout_supported = plLayoutSupported.
    if plStaticObject ne ? then gscot.static_object = plStaticObject.
    if plCacheOnClient ne ? then gscot.cache_on_client = plCacheOnClient.
    
    /* deployment type */
    if pcDeploymentType ne ? then
    do:
        do iLoop = 1 to num-entries(pcDeploymentType):
            if not can-do('Cli,Srv,Web,', entry(iLoop, pcDeploymentType)) then
                return error {aferrortxt.i 'AF' '5' 'gscot' 'deployment_type' '"deployment type options"' '"Only Srv, Cli, Web or (blank) are valid values."'}.
        end.    /* loop through deployment type */
                                    
        gscot.deployment_type = pcDeploymentType.
    end.    /* deployment type */
    
    /* class object name */
    if pcClassObjectName ne ? then
    do:
        if pcClassObjectName eq '' then
            gscot.class_smartobject_obj = 0.
        /* NOT USED */        
    end.    /* class object name */
    
    /* after all updates applied, validate */
    validate gscot no-error.
    if error-status:error or return-value ne '' then return error return-value.
    &ENDIF
    
    error-status:error = no.            
    return.
END PROCEDURE.    /* insertClass */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE insertObjectInstance Include 
PROCEDURE insertObjectInstance :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     To add/update an object instance on a container
  Parameters:  pdContainerObjectObj               -
               pcObjectName                       -
               pcResultCode                       -
               pcInstanceName                     -
               pcInstanceDescription              -
               pcLayoutPosition                   -               
               piPageNumber                       - Applies to visual objects only.
                                                    Pass ? if not applicable.
               piPageSequence                     - Applies to visual objects only.
                                                    Pass ? if not applicable.
               plForceCreateNew                   -
               phAttributeValueBuffer             -
               TABLE-HANDLE phAttributeValueTable -
               pdSmartObjectObj                   -
               pdObjectInstanceObj                - 
                              
  Notes:       * If object already exists on container, the instance and its
               attribute values will be updated accordingly, otherwise the
               instance will be created.
               * If the force new create flag is set, a new object instance is
               created regardless of whether one exists or not.
               * We determine whether the object exists based on the object instance
               name as an object can exist on a container multiple times. This behaviour can
               also be overridden by the force new create flag.
               * All the attribute values which are contained in the attribute value table which
               are set against the INSTANCE owner will be set against this object.
               * The pcInstanceName must be unique:
                 - If the plForceCreateNew flag is true, and there is an existing
                   instance with the instance name as passed in, "(n)" will be appended
                   to the instance name, where n is an integer value.
                 - If an object instance with the passed in instance name is found,
                   but the smartobject _obj value passed in does not match that
                   of the object instance record, then a new instance will be created,
                   with "(n)" appended, as above.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pdContainerObjectObj        AS DECIMAL          NO-UNDO.
    DEFINE INPUT  PARAMETER pcObjectName                AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcResultCode                AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcInstanceName              AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcInstanceDescription       AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcLayoutPosition            AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER piPageNumber                AS INTEGER          NO-UNDO.
    DEFINE INPUT  PARAMETER piPageSequence              AS INTEGER          NO-UNDO.
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
    DEFINE VARIABLE iAdder                              AS INTEGER          NO-UNDO.
    DEFINE VARIABLE cBaseInstanceName                   AS CHARACTER        NO-UNDO.
    
    define buffer ryc_object_instance    for ryc_object_instance.
    DEFINE BUFFER rycoi                  FOR ryc_object_instance.

    /** Find the result code
     *  ----------------------------------------------------------------------- **/
    ASSIGN dCustomisationResultObj = {fnarg getResultCodeObj pcResultCode}.
    IF dCustomisationResultObj EQ ? THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'Customization Result'" pcResultCode}.
    
    /** Determine the object ID of the record to add to the container.
     *  ----------------------------------------------------------------------- **/
    ASSIGN pdSmartObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN TARGET-PROCEDURE, INPUT pcObjectName, INPUT dCustomisationResultObj).
    IF pdSmartObjectObj EQ 0 THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'Object to be contained'" pcObjectName}.

    /* Check if the instance already exists.
     */    
    FIND rycoi WHERE
         rycoi.container_smartobject_obj = pdContainerObjectObj AND
         rycoi.instance_name             = pcInstanceName
         EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
    
    IF LOCKED rycoi THEN
        RETURN ERROR {aferrortxt.i 'AF' '104' '?' '?' "'object instance ' + pcInstanceName"}.
    
    /* Create a new instance if the force create flag is set, or if no
       instance exists already. See the notes in the header of this procedure
       for details.
       
       Always use the plForceCreateNew flag to determine whether to 
       create a new instance or not.
     */
    if not available rycoi then
        assign plForceCreateNew = yes.
    else
    if rycoi.smartobject_obj ne pdSmartObjectObj then
        assign plForceCreateNew = yes.
    
    /* Make sure that we have a unqiue instance name.
       If an object instance with the supplied name does 
       not exist, then create the new object instance with that name;
       if an object instance does exist, then determine a
       newly unique name for that instance.
     */
    if plForceCreateNew and available rycoi then
    do:
        assign iAdder            = 1
               cBaseInstanceName = pcInstanceName.
        
        FIND-NEW-NAME:
        repeat:
            assign pcInstanceName = cBaseInstanceName + "(":U + string(iAdder) + ")":U.
            
                find first ryc_object_instance where
                               ryc_object_instance.container_smartobject_obj = pdContainerObjectObj and
                               ryc_object_instance.instance_name             = pcInstanceName
                               no-lock no-error.
                /* if there is no instance by this name, then we can use this and there is no need for the loop */
                if not available ryc_object_instance then
                    leave FIND-NEW-NAME.
            
                /* alternatively, increment by one and continue. */
                assign iAdder = iAdder + 1.
                next FIND-NEW-NAME.
            end.    /* FIND-NEW-NAME: find unique name. */
    end.    /* smartobject_obj doesn't match */
    
    IF plForceCreateNew THEN
    DO:
        CREATE rycoi NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
        
        ASSIGN rycoi.container_smartobject_obj = pdContainerObjectObj
               rycoi.smartobject_obj           = pdSmartObjectObj
               rycoi.system_owned              = NO
               rycoi.instance_name             = pcInstanceName
               NO-ERROR.
        /* Validation here in case there are issues with duplicate
           instance names. There shouldn't be, but check just in case.
         */
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    END.    /* create a record */
    
    ASSIGN rycoi.layout_position      = pcLayoutPosition
           rycoi.instance_description = pcInstanceDescription
           rycoi.object_sequence      = piPageSequence
           NO-ERROR.
    
    /* If applicable, assign the page_obj and page_sequence */
    IF piPageNumber <> ? and piPageNumber <> 0 THEN 
    DO:        
        FIND FIRST ryc_page NO-LOCK
             WHERE ryc_page.container_smartobject_obj = pdContainerObjectObj
               AND ryc_page.page_sequence             = piPageNumber
             NO-ERROR.
        
        IF NOT AVAILABLE ryc_page THEN
            RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'page number (' + STRING(piPageNumber) + ')'" STRING(piPageNumber)}.

        ASSIGN rycoi.page_obj = ryc_page.page_obj.
    END.    /* there is a page specified */
    ELSE
        ASSIGN rycoi.page_obj = 0. /* Page 0 is a valid page */
    
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
            RUN insertAttributeValues IN TARGET-PROCEDURE
                                      (INPUT "INSTANCE":U,
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
ACCESS_LEVEL=PUBLIC
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
ACCESS_LEVEL=PUBLIC
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
               pcPhysicalObjectName                - (OPT) the name of the physical object associated with this object.
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
               * The object name passed into this procedure must contain the extension,
                 if any. The extension is important 
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
    DEFINE OUTPUT PARAMETER pdSmartObjectObj        AS DECIMAL              NO-UNDO.
 
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
    DEFINE VARIABLE cNewObjectExt               AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cPrepObjectName             AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cPrepObjectExt              AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE lHasExtension               AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE lContainerObject            AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE dPhysicalObjectObj          AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dSdoObjectObj               AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dSuperProcObjectObj         AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dCustomisationResultObj     AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE hClassBuffer                AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hField                      AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE cError                      AS CHARACTER                NO-UNDO.
    
    DEFINE BUFFER rycso         FOR ryc_smartObject.

    IF pcTooltipText EQ "":U THEN
        ASSIGN pcTooltipText = pcObjectDescription.
    
    ASSIGN lHasExtension    = can-do(gcCLASS-USES-EXTENSION, pcObjectTypeCode)
           lContainerObject = LOOKUP(pcObjectTypeCode, gcCONTAINER-CLASSES) GT 0.
    
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
    
    /** Determine the class to which the object belongs.
     *  ----------------------------------------------------------------------- **/
    FIND FIRST gsc_object_type WHERE
               gsc_object_type.object_type_code = pcObjectTypeCode
               NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gsc_object_type THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'Object Type'" pcObjectTypeCode}.

    IF NOT gsc_object_type.layout_supported AND pcLayoutCode NE "":U THEN
        RETURN ERROR {aferrortxt.i 'AF' '40' '?' '?' '"the layout suported flag for the specified object~~'s class is set to no, and a layout has been specified."'}.
    ELSE
    IF gsc_object_type.layout_supported AND pcLayoutCode EQ "":U THEN
        ASSIGN pcLayoutCode = "RELATIVE":U.
    
    /* Only validate the physical object name if one has been specified.
     * If none is specified, the class' behaviour is inherited.         */
    IF pcPhysicalObjectName NE "":U THEN
    DO:
        ASSIGN dPhysicalObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN gshRepositoryManager,
                                                     INPUT pcPhysicalObjectName,
                                                     INPUT dCustomisationResultObj).
        IF dPhysicalObjectObj EQ 0 THEN
            RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'object record'" pcPhysicalObjectName}.
        ASSIGN pcPhysicalObjectName = DYNAMIC-FUNCTION("getObjectPathedName":U IN gshRepositoryManager,
                                                       INPUT dPhysicalObjectObj).
        
        /* Create the attribute record for the rendering procedure. */
        IF NOT VALID-HANDLE(phAttributeValueBuffer) AND VALID-HANDLE(phAttributeValueTable) THEN
            ASSIGN phAttributeValueBuffer = phAttributeValueTable:DEFAULT-BUFFER-HANDLE.
        ELSE
        IF NOT VALID-HANDLE(phAttributeValueBuffer) THEN
            ASSIGN phAttributeValueBuffer = BUFFER ttStoreAttribute:HANDLE.

        phAttributeValueBuffer:FIND-FIRST(" WHERE ":U
                                          + phAttributeValueBuffer:NAME + ".tAttributeParent = 'MASTER' AND ":U
                                          + phAttributeValueBuffer:NAME + ".tAttributeParentObj = 0 AND ":U
                                          + phAttributeValueBuffer:NAME + ".tAttributeLabel = 'RenderingProcedure' ":U) NO-ERROR.
        IF NOT phAttributeValueBuffer:AVAILABLE THEN
        DO:
            phAttributeValueBuffer:BUFFER-CREATE().
            ASSIGN phAttributeValueBuffer:BUFFER-FIELD("tAttributeParent":U):BUFFER-VALUE    = "MASTER":U
                   phAttributeValueBuffer:BUFFER-FIELD("tAttributeParentObj":U):BUFFER-VALUE = 0
                   phAttributeValueBuffer:BUFFER-FIELD("tAttributeLabel":U):BUFFER-VALUE     = "RenderingProcedure":U.
        END.    /* not in TT yet. */
        
        ASSIGN phAttributeValueBuffer:BUFFER-FIELD("tCharacterValue":U):BUFFER-VALUE = pcPhysicalObjectName.
        
        phAttributeValueBuffer:BUFFER-RELEASE().
    END.    /* rendering procedure specified. */

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
    
    /** Find SDO name if passed in (viewers / browsers)
     *  ----------------------------------------------------------------------- **/
    IF pcSdoObjectName NE "":U THEN
    DO:
        ASSIGN dSdoObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN gshRepositoryManager,
                                                INPUT pcSdoObjectName, INPUT dCustomisationResultObj).
        IF dSdoObjectObj EQ 0 THEN
            RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'SDO Object'" pcSdoObjectName}.
    END.    /* SDO passed in */
    
    /* Store the SuperProcedure attribute*/
    IF DYNAMIC-FUNCTION("classHasAttribute":U IN gshRepositoryManager,
                         INPUT gsc_object_type.object_type_code,
                         INPUT "SuperProcedure":U,
                         INPUT NO              /* plAttributeIsEvent */ ) THEN
    DO:
        IF pcSuperProcedureName NE ""
		THEN DO:
	        ASSIGN dSuperProcObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN gshRepositoryManager,
    	                                                  INPUT pcSuperProcedureName, INPUT dCustomisationResultObj).
        	IF dSuperProcObjectObj EQ 0 THEN
            	RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'Custom Super Procedure Object'" pcSuperProcedureName}.

	        /* Store the relatively pathed object name */
    	    ASSIGN pcSuperProcedureName = DYNAMIC-FUNCTION("getObjectPathedName":U IN gshRepositoryManager,
        	                                               INPUT dSuperProcObjectObj).
        END.

        /* Create the attribute record for the rendering procedure. */
        IF NOT VALID-HANDLE(phAttributeValueBuffer) AND VALID-HANDLE(phAttributeValueTable) THEN
            ASSIGN phAttributeValueBuffer = phAttributeValueTable:DEFAULT-BUFFER-HANDLE.
        ELSE
        IF NOT VALID-HANDLE(phAttributeValueBuffer) THEN
            ASSIGN phAttributeValueBuffer = BUFFER ttStoreAttribute:HANDLE.

        phAttributeValueBuffer:FIND-FIRST(" WHERE ":U
                                          + phAttributeValueBuffer:NAME + ".tAttributeParent = 'MASTER' AND ":U
                                          + phAttributeValueBuffer:NAME + ".tAttributeParentObj = 0 AND ":U
                                          + phAttributeValueBuffer:NAME + ".tAttributeLabel = 'SuperProcedure' ":U) NO-ERROR.
        IF NOT phAttributeValueBuffer:AVAILABLE THEN
        DO:
            phAttributeValueBuffer:BUFFER-CREATE().
            ASSIGN phAttributeValueBuffer:BUFFER-FIELD("tAttributeParent":U):BUFFER-VALUE    = "MASTER":U
                   phAttributeValueBuffer:BUFFER-FIELD("tAttributeParentObj":U):BUFFER-VALUE = 0
                   phAttributeValueBuffer:BUFFER-FIELD("tAttributeLabel":U):BUFFER-VALUE     = "SuperProcedure":U.
        END.    /* not in TT yet. */

        ASSIGN phAttributeValueBuffer:BUFFER-FIELD("tCharacterValue":U):BUFFER-VALUE = pcSuperProcedureName.

        phAttributeValueBuffer:BUFFER-RELEASE().

        /* The default behaviour in Dynamics is for object super procedures to be
         * started in a stateful mode. This is stored in the SuperProcedureMode attribute.
         * It is not inherited from the class since typically class super procedures are 
         * started as stateless procedures.
         */
        phAttributeValueBuffer:FIND-FIRST(" WHERE ":U
                                          + phAttributeValueBuffer:NAME + ".tAttributeParent = 'MASTER' AND ":U
                                          + phAttributeValueBuffer:NAME + ".tAttributeParentObj = 0 AND ":U
                                          + phAttributeValueBuffer:NAME + ".tAttributeLabel = 'SuperProcedureMode' ":U) NO-ERROR.
        IF NOT phAttributeValueBuffer:AVAILABLE THEN
        DO:
            phAttributeValueBuffer:BUFFER-CREATE().
            ASSIGN phAttributeValueBuffer:BUFFER-FIELD("tAttributeParent":U):BUFFER-VALUE    = "MASTER":U
                   phAttributeValueBuffer:BUFFER-FIELD("tAttributeParentObj":U):BUFFER-VALUE = 0
                   phAttributeValueBuffer:BUFFER-FIELD("tAttributeLabel":U):BUFFER-VALUE     = "SuperProcedureMode":U.
        END.    /* not in TT yet. */

        ASSIGN phAttributeValueBuffer:BUFFER-FIELD("tCharacterValue":U):BUFFER-VALUE = "STATEFUL":U.

        phAttributeValueBuffer:BUFFER-RELEASE().
    END.      /* The SuperProcedure Attribute can be stored for the class. */

    /* Find existing object record or create new one.        
       Always check whether the name passed in has an existing 
       smartobject.
     */
    
    /* First look for a object named the same as the value passed in.
     */
    FIND FIRST rycso WHERE
               rycso.object_filename          = pcObjectName            AND
               rycso.customization_result_obj = dCustomisationResultObj AND
               rycso.object_extension         = "":U
               no-lock no-error.
    
    /* Make sure that the extension is clear. */
    ASSIGN cObjectFileNameNoExt = pcObjectName
           cObjectExt           = "":U.
    
    /* If there is no exact match, and this object belongs to a class that
       allows for the use of the extension field, then check whether an
       object already exists with the extension in the object_extension
       field.
     */
    IF NOT AVAILABLE rycso and lHasExtension then
    DO:
        /* Split the name into its component parts. */
        RUN extractRootFile IN gshRepositoryManager ( INPUT  pcObjectName,
                                                      OUTPUT cObjectFileNameNoExt,
                                                      OUTPUT cObjectFileNameWithExt ).
        ASSIGN cObjectExt = REPLACE(cObjectFileNameWithExt, (cObjectFileNameNoExt + ".":U), "":U).
        
        /* If there's an extension, check if the object exists with a separated
           extension. We checked for the extended name earlier.
           
           If this object exists, then we update it.
           
           Look for the object based on the un-extended name. The object_filename
           of the object is unique.
         */
        find first rycso where
                   rycso.object_filename          = cObjectFileNameNoExt   and
                   rycso.customization_result_obj = dCustomisationResultObj
                   no-lock no-error.
        
        /* As a sanity check, ensure that if an object is found, that the extension
           of the passed-in name and that of the object match. If they don't then 
           return an error.
         */
        if available rycso and rycso.object_extension ne cObjectExt then
            return error {aferrortxt.i 'AF' '40' '?' '?'
                    "'Unable to update the object named ' + cObjectFileNameNoExt 
                    + ' because the object in the Repository has an extension of '
                    + rycso.object_extension
                          + '; the extension passed to this procedure is ' 
                          + cObjectExt " }.
    end.    /* no object available based on the full name. */
    
    /* If an object by this name already exists,
       find and lock it for updating.
       
       Also make sure that we have the right object ... if there is a class
       mis-match then throw an error.
     */
    if available rycso then
    do:
      /* If we are updating an existing object, and the class passed in does
         not match that of the object, then we need to report an error. Either
         we are trying to change the class with the wrong API, or we are
         trying to create an object with the same name.
       */
      if gsc_object_type.object_type_obj ne rycso.object_type_obj then
      do:
          find first gsc_object_type where
                     gsc_object_type.object_type_obj = rycso.object_type_obj
                     no-lock no-error.
          return error {aferrortxt.i 'AF' '36' '?' '?' "'object ' + pcObjectName" "'the object~~'s object type (' 
                                      + gsc_object_type.object_type_code + ') differs from the object type passed in ('
                                      + pcObjectTypeCode + ') '"
                                      "'This could mean that you are attempting to change the object type of the object, or '
                                       + 'that an object already exists named ' + pcObjectName + '. '
                                       + 'Object types cannot be changed using this API.'" }.
        end.    /* object type mismatch */
        
        /* Now lock the record for updating. */
        find current rycso exclusive-lock no-wait no-error.
        IF LOCKED rycso THEN
            RETURN ERROR {aferrortxt.i 'AF' '104' '?' '?' "'object ' + pcObjectName"}.               
    end.    /* existing object */
    ELSE
    DO:
        /* If this is a new object, search for any overrides on the name.
           This function will allow the specification of any specific pre- or
           suffixes, or any special other processing, such as enforcing a
           naming convention.
         */
        assign cError = DYNAMIC-FUNCTION("prepareObjectName":U in TARGET-PROCEDURE,
                                         input  pcObjectName,
                                         input  pcResultCode,
                                         input  "":U,        /* object string */
                                         input  "SAVE":U,
                                         input  pcObjectTypeCode,
                                         input  "":U,        /* entity name (not req'd) */
                                         input  pcProductModuleCode,
                                         OUTPUT cNewObjectName,
                                         OUTPUT cObjectExt              ).
        IF cError > "" THEN
            RETURN ERROR cError.
        
        /* Check whether we are going to violate an index at this stage of proceedings.
        
           Even though a check has already been made, based on the pcObjectName, it
           is possible that the prepareObjectName() call has modified the value of
           pcObjectName. If so, we need to re-check whether there are clashes with
           the new object's name.      
         */
        find first rycso where
                   rycso.object_filename          = cNewObjectName         and
                   rycso.customization_result_obj = dCustomisationResultObj
                   no-lock no-error.
        if available rycso then
            return error {aferrortxt.i 'AF' '40' '?' '?'
                    "'Unable to create the object named ' + cObjectFileNameNoExt 
                    + ' because an object exists in the Repository with as an extension of '
                    + rycso.object_extension
                          + '; the extension passed to this procedure is ' + cObjectExt " }.
        
        /* If a record exists, and we are trying to create a customised version,
           there must be a default version available first (ie. no customisation result).
        */
        if dCustomisationResultObj ne 0 and
           not can-find(ryc_smartobject where
                        ryc_smartobject.object_filename          =  cNewObjectName and
                        ryc_smartobject.customization_result_obj = 0                  ) then
            return error {aferrortxt.i 'AF' '40' '?' '?' "'Unable to find the default (non-customised) object named ' + cNewObjectName"}.
        CREATE rycso NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
        
        ASSIGN rycso.object_filename          = cNewObjectName
               rycso.customization_result_obj = dCustomisationResultObj
               rycso.object_extension         = cObjectExt
               rycso.disabled                 = NO
               rycso.system_owned             = NO
               rycso.shutdown_message_text    = "":U
               rycso.template_smartobject     = plIsTemplate               
               rycso.object_type_obj          = gsc_object_type.object_type_obj
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
           rycso.required_db_list         = pcRequiredDBList
           rycso.runnable_from_menu       = LOOKUP(pcObjectTypeCode, gcCLASS-PHYSICAL-CONTAINER) GT 0
           rycso.run_persistent           = plRunPersistent
           rycso.run_when                 = "ANY":U
           rycso.product_module_obj       = gsc_product_module.product_module_obj
           rycso.layout_obj               = (IF AVAILABLE ryc_layout THEN ryc_layout.layout_obj ELSE 0)
           rycso.security_smartobject_obj = rycso.smartobject_obj
           rycso.sdo_smartobject_obj      = dSdoObjectObj
           NO-ERROR.
    {checkerr.i &return-error=YES }

    VALIDATE rycso NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    
    ASSIGN pdSmartObjectObj = rycso.smartobject_obj.

    /** If there are attribute value records passed in, they will all be set at
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
            RUN insertAttributeValues IN TARGET-PROCEDURE (INPUT "MASTER":U, INPUT pdSmartObjectObj, INPUT phAttributeValueBuffer) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
        END.    /* there  are attribute value records. */
    END.    /* there are attribute value records. */
    &ENDIF
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* insertObjectMaster */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE insertObjectPage Include 
PROCEDURE insertObjectPage :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     Creates and updates an object page
  Parameters:  pcContainerObjectName -
               pcContainerResultCode -
               pcPageLabel           -
               pcSecurityToken       -
               pcPageReference       -
               piPageSequence        -
               pcLayoutCode          -
               pcEnableOn            -
               pdPageObj             -
  Notes:       * This procedure is PUBLIC.
               * The pcEnableOn parameter contains a CAN-DO style list, which 
                 needs to be able to resolve VIEW,MODIFY and CREATE. 
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcContainerObjectName   AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcContainerResultCode   AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcPageLabel             AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcSecurityToken         AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcPageReference         AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER piPageSequence          AS INTEGER          NO-UNDO.
    DEFINE INPUT  PARAMETER pcLayoutCode            AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcEnableOn              AS CHARACTER        NO-UNDO.    /* CAN-DO: Create,Modify,View */
    DEFINE OUTPUT PARAMETER pdPageObj               AS DECIMAL          NO-UNDO.

    &IF DEFINED(Server-Side) EQ 0 &THEN
    {dynlaunch.i
        &Plip  = 'RepositoryDesignManager'
        &Iproc = 'insertObjectPage'
        
        &mode1 = INPUT  &parm1 = pcContainerObjectName &DataType1 = CHARACTER  
        &mode2 = INPUT  &parm2 = pcContainerResultCode &DataType2 = CHARACTER  
        &mode3 = INPUT  &parm3 = pcPageLabel           &DataType3 = CHARACTER
        &mode4 = INPUT  &parm4 = pcSecurityToken       &DataType4 = CHARACTER
        &mode5 = INPUT  &parm5 = pcPageReference       &DataType5 = CHARACTER
        &mode6 = INPUT  &parm6 = piPageSequence        &DataType6 = INTEGER  
        &mode7 = INPUT  &parm7 = pcLayoutCode          &DataType7 = CHARACTER
        &mode8 = INPUT  &parm8 = pcEnableOn            &DataType8 = CHARACTER
        &mode9 = OUTPUT &parm9 = pdPageObj             &DataType9 = DECIMAL
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
    DEFINE VARIABLE iOrder                  AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE dContainerResultObj     AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dSmartObjectObj         AS DECIMAL                  NO-UNDO.

    DEFINE BUFFER ryc_page      FOR ryc_page.
    DEFINE BUFFER rycpa         FOR ryc_page.

    /** Find the container result code
     *  ----------------------------------------------------------------------- **/
    ASSIGN dContainerResultObj = DYNAMIC-FUNCTION("getResultCodeObj":U IN TARGET-PROCEDURE,
                                                  INPUT pcContainerResultCode).
    /* A value of 0 means that the default result code is used, and is a valid value. */
    IF dContainerResultObj EQ ? THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'Customization Result'" pcContainerResultCode}.

    /** Find the container object.
     *  ----------------------------------------------------------------------- **/
    ASSIGN dSmartObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN TARGET-PROCEDURE,
                                              INPUT pcContainerObjectName, INPUT dContainerResultObj).
    IF dSmartObjectObj EQ 0 THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'container object'" pcContainerObjectName}.

    FIND FIRST ryc_page WHERE
               ryc_page.page_reference            = pcPageReference  AND
               ryc_page.container_smartObject_obj = dSmartObjectObj
               EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
    IF LOCKED ryc_page THEN
        RETURN ERROR {aferrortxt.i 'AF' '104' '?' '?' "'page ' + pcPageReference"}.

    IF NOT AVAILABLE ryc_page THEN
    DO:
        CREATE ryc_page NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

        ASSIGN ryc_page.container_smartObject_obj = dSmartObjectObj
               ryc_page.page_reference            = pcPageReference
               NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

        /* Validate later. */
    END.    /* n/a page */

    /* Make sure the sequence is non-zero */
    IF piPageSequence EQ 0 THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' '"page sequence"' '"The page sequence must be a non-zero integer."' }.

    /* Make sure the layout is correct. */ 
    FIND FIRST ryc_layout WHERE
               ryc_layout.layout_code = pcLayoutCode
               NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ryc_layout THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' 'ryc_layout' 'layout_code' '"layout"' "'Layout code:' + pcLayoutCode" }.

    ASSIGN ryc_page.security_token   = pcSecurityToken
           ryc_page.page_label       = pcPageLabel
           ryc_page.layout_obj       = ryc_layout.layout_obj
           ryc_page.enable_on_view   = CAN-DO(pcEnableOn, "view":U)
           ryc_page.enable_on_create = CAN-DO(pcEnableOn, "CREATE":U)
           ryc_page.enable_on_modify = CAN-DO(pcEnableOn, "modify":U)           
           NO-ERROR.

    VALIDATE ryc_page NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

    ASSIGN pdPageObj = ryc_page.page_obj.

    /* Make sure that the page's sequence doesn't clash with an existing record. */
    IF CAN-FIND(rycpa WHERE
                rycpa.container_smartObject_obj = dSmartObjectObj AND                
                rycpa.page_sequence             = piPageSequence   AND
                ROWID(rycpa)                   <> ROWID(ryc_page)      ) THEN
    DO:
        RUN reorderPageObjects IN TARGET-PROCEDURE ( INPUT "PAGE":U,
                                                     INPUT dSmartObjectObj,
                                                     INPUT pdPageObj,
                                                     INPUT 0, /* Object instance obj */
                                                     INPUT piPageSequence            ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.        
    END.    /* page sequence clash */
    ELSE
        ASSIGN ryc_page.page_sequence = piPageSequence.
    &ENDIF
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* insertObjectPage */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE insertSupportedLink Include 
PROCEDURE insertSupportedLink :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     Adds or updates a supported link record for a class
  Parameters:  pcClassName - mandatory. the name of the class for which the
                                                         link is supported. blanks and the unknown value 
                                                         not allowed.
                           pcLinkName - mandatory. the name of the link being added. this
                                                        link must exist as a smartlink_type. blanks and 
                                                        the unknown value not allowed.
                           plHideOnDeactivate - If set to YES, this link for this type of 
                                                                    smartobject will be automatically deactivated 
                                                                    when the object is hidden, and activated again
                                                                    when the object is viewed. The unknown value keeps
                                                                    the existing value.
                           plIsLinkSource - If set to YES, objects of this smart type are 
                                                                capable of acting as the source for the specified 
                                                                link. The unknown value keeps the existing value.
                           plIsLinkTarget - If set to YES, objects of this smart type are 
                                                                capable of acting as the target for the specified 
                                                                link. The unknown value keeps the existing value.
                          pdSupportedLinkObj - the object id of the updated record.                                                             
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE input parameter pcClassName                as character        no-undo.
    DEFINE input parameter pcLinkName                 as character        no-undo.
    DEFINE input parameter plDeactivateOnHide         as logical          no-undo.
    DEFINE input parameter plIsLinkSource             as logical          no-undo.
    DEFINE input parameter plIsLinkTarget             as logical          no-undo.
    DEFINE output parameter pdSupportedLinkObj        as decimal          no-undo.
    
    &IF DEFINED(Server-Side) EQ 0 &THEN    
    { dynlaunch.i 
        &PLIP  = 'RepositoryDesignManager'
        &iProc = 'insertSupportedLink'
                &mode1 = input  &parm1 = pcClassName        &dataType1 = character
                &mode2 = input  &parm2 = pcLinkName         &dataType2 = character
                &mode3 = input  &parm3 = plDeactivateOnHide &dataType3 = logical
                &mode4 = input  &parm4 = plIsLinkSource     &dataType4 = logical
                &mode5 = input  &parm5 = plIsLinkTarget     &dataType5 = logical
                &mode6 = output  &parm6 = pdSupportedLinkObj &dataType6 = decimal
    }
    IF RETURN-VALUE <> "":U or error-status:error THEN RETURN ERROR RETURN-VALUE.   
    &ELSE
    DEFINE buffer gscot        for gsc_object_type.
    DEFINE buffer rycst        for ryc_smartlink_type.
    DEFINE buffer rycsl        for ryc_supported_link.
    
    /* Class is mandatory */
    if pcClassName eq '' or pcClassName eq ? then
        return error {aferrortxt.i 'AF' '1' '?' '?' '"class name"'}.
        
    find gscot where
         gscot.object_type_code = pcClassName
         no-lock no-error.
         
    if not available gscot then
        return error {aferrortxt.i 'AF' '5' '?' '?' '"class"' "'Class name: ' + pcClassName"}.    
    
    /* Link type is mandatory */    
    if pcLinkName eq '' or pcLinkName eq ? then
        return error {aferrortxt.i 'AF' '1' '?' '?' '"link name"'}.
        
    find rycst where
         rycst.link_name = pcLinkName
         no-lock no-error.
         
    if not available rycst then
        return error {aferrortxt.i 'AF' '5' '?' '?' '"link"' "'Link name: ' + pcLinkName"}.    
    
    /* Now check whether to create or update */
    find rycsl where
         rycsl.object_type_obj    = gscot.object_type_obj and
         rycsl.smartlink_type_obj = rycst.smartlink_type_obj
         exclusive-lock no-wait no-error.

    if locked rycsl then    
        return error {aferrortxt.i 'AF' '104' '?' '?' '"supported link"'}.
        
    if not available rycsl then
    do:
        create rycsl no-error.
        if error-status:error or return-value ne '' then return error return-value.
        
        assign rycsl.object_type_obj = gscot.object_type_obj
               rycsl.smartlink_type_obj = rycst.smartlink_type_obj
               no-error.
        if error-status:error or return-value ne '' then return error return-value.
    end.    /* create class */

    /* always return the object id */
    assign pdSupportedLinkObj = rycsl.supported_link_obj.
    
    if plDeactivateOnHide ne ? then rycsl.deactivated_link_on_hide = plDeactivateOnHide no-error.
    if plIsLinkSource ne ? then rycsl.link_source = plIsLinkSource no-error.
    if plIsLinkTarget ne ? then rycsl.link_target = plIsLinkTarget no-error.
    
    validate rycsl no-error.
    if error-status:error or return-value ne '' then return error return-value.    
    &ENDIF
        
    error-status:error = no.
    return.
END PROCEDURE.    /* insertSupportedLink */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE insertUiEvents Include 
PROCEDURE insertUiEvents :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
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
            /* event names must have a valid value */
            if cEventName eq ? or cEventName eq '' then
            do:
                cMessageList = cMessageList + (if num-entries(cMessageList, chr(3)) gt 0 then chr(3) else '')
                             + {aferrortxt.i 'AF' '1' '?' '?' '"event name"'} .
                hQuery:get-next().
                next.
            end.    /* event name blank or unknown */
            
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
ACCESS_LEVEL=PUBLIC
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
ACCESS_LEVEL=PRIVATE
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
ACCESS_LEVEL=PUBLIC
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
ACCESS_LEVEL=PRIVATE
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
  RUN addParentOTAttrs IN TARGET-PROCEDURE (INPUT bgsc_object_type.object_type_obj, INPUT hOTTable).

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
ACCESS_LEVEL=PRIVATE
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

    RUN removeObjectInstance IN TARGET-PROCEDURE
                             ( INPUT cContainerName,
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
ACCESS_LEVEL=PUBLIC
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
           IF AVAIL rycso2 THEN
              cContainerObject = "container " + rycso2.object_filename.
           ELSE
              cContainerObject = "at least one container".
           cContainerObject = cContainerObject + '. Unable to delete object'.
           cMessageList = {aferrortxt.i 'AF' '28' '?' '?' "'repository object ' + pcObjectName" cContainerObject}.
           UNDO trans-block, LEAVE trans-block.
       END.
       
       /** Delete Pages and Page Instances, and the object instances that
        *  these page instances refer to.
        *  ----------------------------------------------------------------------- **/
       FOR EACH rycpa EXCLUSIVE-LOCK
          WHERE rycpa.container_smartObject = rycso.smartObject_obj:

           FOR EACH rycoi EXCLUSIVE-LOCK
              WHERE rycoi.page_obj = rycpa.page_obj:
    
               DELETE rycoi NO-ERROR.
               IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
               DO:
                   cMessageList = IF RETURN-VALUE <> "" THEN RETURN-VALUE ELSE "Error":U.
                   UNDO trans-block, LEAVE trans-block.
               END.
           END.

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
ACCESS_LEVEL=PUBLIC
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
    {dynlaunch.i &PLIP              = "'RepositoryDesignManager'"
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
    ASSIGN dContainerResultObj = DYNAMIC-FUNCTION("getResultCodeObj":U IN TARGET-PROCEDURE, INPUT pcContainerResultCode).
    IF dContainerResultObj EQ ? THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'Customization Result'" pcContainerResultCode}.
    
    /** Find the instance result code
     *  ----------------------------------------------------------------------- **/
    IF pcInstanceResultCode EQ "":U THEN
        ASSIGN pcInstanceResultCode = "{&DEFAULT-RESULT-CODE}":U.

    ASSIGN dInstanceResultObj = DYNAMIC-FUNCTION("getResultCodeObj":U IN TARGET-PROCEDURE, INPUT pcInstanceResultCode).
    IF dInstanceResultObj EQ ? THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'Customization Result'" pcInstanceResultCode}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeObjectPage Include 
PROCEDURE removeObjectPage :
/*------------------------------------------------------------------------------
  Purpose:     Removes a page from an object.
  Parameters:  pcContainerObjectName    - } used to find the container object
               pcContainerResultCode    - } 
               pcPageReference          - } finds the relevant page
               piPageSequence           - }
               plRemoveObjectInstances  -
  Notes:       * This is a PUBLIC api.  
               * If '*' is passed in as the value of the PageReference parameter,
                 all pages are removed.
               * Either the page reference or the page sequence can be used, but 
                 the page reference takes preference over the sequence.
               * If the plRemoveObjectInstances flag is set to true, then the 
                 actual object instance record is also removed. If not, then only
                 the record linking the object instance to a particular page is
                 removed.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcContainerObjectName        AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcContainerResultCode        AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcPageReference              AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER piPageSequence               AS INTEGER          NO-UNDO.
    DEFINE INPUT PARAMETER plRemoveObjectInstances      AS LOGICAL          NO-UNDO.
    
    &IF DEFINED(Server-Side) EQ 0 &THEN
    {dynlaunch.i
        &Plip  = 'RepositoryDesignManager'
        &IProc = 'removeObjectPage'

        &Mode1 = INPUT &Parm1 = pcContainerObjectName    &DataType1 = CHARACTER
        &Mode2 = INPUT &Parm2 = pcContainerResultCode    &DataType2 = CHARACTER
        &Mode3 = INPUT &Parm3 = pcPageReference          &DataType3 = CHARACTER
        &Mode4 = INPUT &Parm4 = piPageSequence           &DataType4 = INTEGER
        &Mode5 = INPUT &Parm5 = plRemoveObjectInstances  &DataType5 = LOGICAL
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
    DEFINE VARIABLE dSmartObjectObj                 AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dContainerResultObj             AS DECIMAL              NO-UNDO.

    DEFINE QUERY qryPage            FOR ryc_page.

    DEFINE BUFFER ryc_page          FOR ryc_page.

    /** Find the container result code
     *  ----------------------------------------------------------------------- **/
    ASSIGN dContainerResultObj = DYNAMIC-FUNCTION("getResultCodeObj":U IN TARGET-PROCEDURE,
                                                  INPUT pcContainerResultCode).
    /* A value of 0 means that the default result code is used, and is a valid value. */
    IF dContainerResultObj EQ ? THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'Customization Result'" pcContainerResultCode}.

    /** Find the container object.
     *  ----------------------------------------------------------------------- **/
    ASSIGN dSmartObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN TARGET-PROCEDURE,
                                              INPUT pcContainerObjectName, INPUT dContainerResultObj).
    IF dSmartObjectObj EQ 0 THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'container object'" pcContainerObjectName}.

    IF pcPageReference EQ "*":U THEN
        OPEN QUERY qryPage
            FOR EACH ryc_page WHERE
                     ryc_page.container_smartObject_obj = dSmartObjectObj
                     EXCLUSIVE-LOCK.
    ELSE
    IF pcPageReference NE "":U THEN
    DO:
        FIND FIRST ryc_page WHERE
                   ryc_page.container_smartObject_obj = dSmartObjectObj AND
                   ryc_page.page_reference            = pcPageReference
                   NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ryc_page THEN
            RETURN ERROR {aferrortxt.i 'AF' '5' 'ryc_page' '?' '"page record"' "'Page reference = ' + pcPageReference" }.
    
        OPEN QUERY qryPage
            FOR EACH ryc_page WHERE
                     ryc_page.container_smartObject_obj = dSmartObjectObj AND
                     ryc_page.page_reference            = pcPageReference
                     EXCLUSIVE-LOCK.
    END.    /* page reference has a value. */
    ELSE
    IF piPageSequence NE 0 THEN
    DO:    
        FIND FIRST ryc_page WHERE
                   ryc_page.container_smartObject_obj = dSmartObjectObj AND
                   ryc_page.page_sequence             = piPageSequence
                   NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ryc_page THEN
            RETURN ERROR {aferrortxt.i 'AF' '5' 'ryc_page' '?' '"page record"' "'Page sequence = ' + STRING(piPageSequence)" }.

        OPEN QUERY qryPage
            FOR EACH ryc_page WHERE
                     ryc_page.container_smartObject_obj = dSmartObjectObj AND
                     ryc_page.page_sequence             = piPageSequence
                     EXCLUSIVE-LOCK.
    END.    /* page sequence has a value */
    ELSE
        RETURN ERROR {aferrortxt.i 'AF' '40' '?' '?' '"Unable to identify page(s) to remove from container."'}.               

    GET FIRST qryPage EXCLUSIVE-LOCK.
    DO WHILE AVAILABLE ryc_page:
        /* First remove all the page instance records. */
        FOR EACH ryc_object_instance NO-LOCK
           WHERE ryc_object_instance.container_smartobject_obj = dSmartObjectObj
             AND ryc_object_instance.page_obj                  = ryc_page.page_obj:

            RUN removePageInstance IN TARGET-PROCEDURE ( INPUT pcContainerObjectName,
                                                         INPUT pcContainerResultCode, 
                                                         INPUT ryc_page.page_reference,
                                                         INPUT ryc_object_instance.instance_name,
                                                         INPUT plRemoveObjectInstances) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
        END.    /* page object records. */

        /* Now delete the page records. */
        DELETE ryc_page NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

        GET NEXT qryPage.
    END.    /* available page record. */
    CLOSE QUERY qryPage.   
    &ENDIF
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* removeObjectPage */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removePageInstance Include 
PROCEDURE removePageInstance :
/*------------------------------------------------------------------------------
  Purpose:     Removes a page object record.
  Parameters:  pcContainerObjectName  -
               pcContainerResultCode  -
               pcPageReference        -
               pcInstanceName         -
               plDeleteObjectInstance -  
  Notes:       * This is a PUBLIC api.
               * A one-to-one relationship is assumed between then ryc-object-instance
                 and ryc-page-object records.
               * Specifying the plDeleteObjectInstance parameter will result in
                 the ryc-object-instance record being removed too.
               *             
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcContainerObjectName        AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pcContainerResultCode        AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pcPageReference              AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pcInstanceName               AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER plDeleteObjectInstance       AS LOGICAL      NO-UNDO.

    &IF DEFINED(SERVER_side) EQ 0 &THEN
    {dynlaunch.i
        &Plip  = 'RepositoryDesignManager'
        &IProc = 'removePageInstance'
        
        &Mode1 = INPUT &Parm1 = pcContainerObjectName  &DataType1 = CHARACTER 
        &Mode2 = INPUT &Parm2 = pcContainerResultCode  &DataType2 = CHARACTER
        &Mode3 = INPUT &Parm3 = pcPageReference        &DataType3 = CHARACTER
        &Mode4 = INPUT &Parm4 = pcInstanceName         &DataType4 = CHARACTER
        &Mode5 = INPUT &Parm5 = plDeleteObjectInstance &DataType5 = LOGICAL
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
    DEFINE VARIABLE dContainerResultObj             AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dSmartObjectObj                 AS DECIMAL              NO-UNDO.

    DEFINE QUERY qryPageInstance      FOR ryc_object_instance.
    DEFINE BUFFER ryc_object_instance FOR ryc_object_instance.

    /** Find the container result code
     *  ----------------------------------------------------------------------- **/
    ASSIGN dContainerResultObj = DYNAMIC-FUNCTION("getResultCodeObj":U IN TARGET-PROCEDURE,
                                                  INPUT pcContainerResultCode).
    /* A value of 0 means that the default result code is used, and is a valid value. */
    IF dContainerResultObj EQ ? THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'Customization Result'" pcContainerResultCode}.

    /** Find the container object.
     *  ----------------------------------------------------------------------- **/
    ASSIGN dSmartObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN TARGET-PROCEDURE,
                                              INPUT pcContainerObjectName, INPUT dContainerResultObj).
    IF dSmartObjectObj EQ 0 THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'container object'" pcContainerObjectName}.

    /** Find the page.
     *  ----------------------------------------------------------------------- **/
    FIND FIRST ryc_page WHERE
               ryc_page.container_smartObject_obj = dSmartObjectObj AND
               ryc_page.page_reference            = pcPageReference
               NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ryc_page THEN
        RETURN ERROR {aferrortxt.i 'AF' '1' 'ryc_page' 'page_obj' '"Page"' "'Page reference = ' + pcPageReference" }.

    /** Find the Page Object
     *  ----------------------------------------------------------------------- **/
    IF pcInstanceName EQ "*":U THEN
        OPEN QUERY qryPageInstance
            FOR EACH ryc_object_instance WHERE
                     ryc_object_instance.container_smartObject_obj = dSmartObjectObj   AND
                     ryc_object_instance.page_obj                  = ryc_page.page_obj
                     EXCLUSIVE-LOCK.
    ELSE
        OPEN QUERY qryPageInstance
            FOR EACH ryc_object_instance WHERE
                     ryc_object_instance.container_smartObject_obj = dSmartObjectObj   AND
                     ryc_object_instance.page_obj                  = ryc_page.page_obj AND
                     ryc_object_instance.instance_name             = pcInstanceName
                     EXCLUSIVE-LOCK.

    GET FIRST qQryPageInstance EXCLUSIVE-LOCK.
    DO WHILE AVAILABLE ryc_object_instance:
        /* First delete the object instance record, if required. */
        IF plDeleteObjectInstance EQ YES THEN
        DO:
            RUN removeObjectInstance IN TARGET-PROCEDURE ( INPUT pcContainerObjectName,
                                                           INPUT pcContainerResultCode,
                                                           INPUT "":U,                  /* pcInstanceObjectName */
                                                           INPUT pcInstanceName,        /* pcInstanceName       */
                                                           INPUT "{&ALL-RESULT-CODE}":U   ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
        END.    /* delete object instance. */

        GET NEXT qryPageInstance.
    END.    /* available page object. */
    CLOSE QUERY qryPageInstance.
    &ENDIF
             
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* removePageInstance */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeSupportedLink Include 
PROCEDURE removeSupportedLink :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     Removes a supported link record for a class
  Parameters:  pcClassName - mandatory. the name of the class for which the
                                                         link is supported. blanks and the unknown value 
                                                         not allowed.
                           pcLinkName - mandatory. the name of the link being added. this
                                                        link must exist as a smartlink_type. blanks and 
                                                        the unknown value not allowed.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE input parameter pcClassName                as character        no-undo.
    DEFINE input parameter pcLinkName                 as character        no-undo.
    
    &IF DEFINED(Server-Side) EQ 0 &THEN    
    { dynlaunch.i 
        &PLIP  = 'RepositoryDesignManager'
        &iProc = 'removeSupportedLink'
                &mode1 = input  &parm1 = pcClassName        &dataType1 = character
                &mode2 = input  &parm2 = pcLinkName         &dataType2 = character
    }
    IF RETURN-VALUE <> "":U or error-status:error THEN RETURN ERROR RETURN-VALUE.   
    &ELSE
    DEFINE buffer gscot        for gsc_object_type.
    DEFINE buffer rycst        for ryc_smartlink_type.
    DEFINE buffer rycsl        for ryc_supported_link.
    
    /* Class is mandatory */
    if pcClassName eq '' or pcClassName eq ? then
        return error {aferrortxt.i 'AF' '1' '?' '?' '"class name"'}.
        
    find gscot where
         gscot.object_type_code = pcClassName
         no-lock no-error.
         
    if not available gscot then
        return error {aferrortxt.i 'AF' '5' '?' '?' '"class"' "'Class name: ' + pcClassName"}.    
    
    /* Link type is mandatory */    
    if pcLinkName eq '' or pcLinkName eq ? then
        return error {aferrortxt.i 'AF' '1' '?' '?' '"link name"'}.
        
    find rycst where
         rycst.link_name = pcLinkName
         no-lock no-error.
         
    if not available rycst then
        return error {aferrortxt.i 'AF' '5' '?' '?' '"link"' "'Link name: ' + pcLinkName"}.    
    
    /* Now check whether to create or update */
    find rycsl where
         rycsl.object_type_obj    = gscot.object_type_obj and
         rycsl.smartlink_type_obj = rycst.smartlink_type_obj
         exclusive-lock no-wait no-error.

    if locked rycsl then    
        return error {aferrortxt.i 'AF' '104' '?' '?' '"supported link"'}.
        
    if not available rycsl then
        return error {aferrortxt.i 'AF' '5' '?' '?' '"supported link"'}.
    
    delete rycsl no-error.
    if error-status:error or return-value ne '' then return error return-value.    
    &ENDIF
        
    error-status:error = no.
    return.
END PROCEDURE.    /* removeSupportedLink */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeUIEvents Include 
PROCEDURE removeUIEvents :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
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
ACCESS_LEVEL=PRIVATE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reorderPageObjects Include 
PROCEDURE reorderPageObjects :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Reorders page and page object records.
  Parameters:  pcWhichObject          -
               pdContainerSmartObject -
               pdPageObj              -
               pdPageObjectObj        -
               piSequence             -
  Notes:       * This is a PRIVATE api.
               * This code is in a separate procedure because it blows the e-code 
                 segments of insertPageObject() when it is included as inline code. 
                 For that reason, an include cannot be used.
               * This API is only for use with a DB connected.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcWhichObject            AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pdContainerSmartObject   AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdPageObj                AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdObjectInstanceObj      AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER piSequence               AS INTEGER              NO-UNDO.

    /* The code in this procedure has been externalised (put into a separate .P file) 
     * deliberately because the entire server-side Repository Design Manager is in
     * danger of blowing the e-code limit. This is a temporary solution which will
     * need to be resolved asap.                                                   */        
    RUN ry/app/rydesrpobp.p ON gshAstraAppServer ( INPUT pcWhichObject,
                                                   INPUT pdContainerSmartObject,
                                                   INPUT pdPageObj,
                                                   INPUT pdObjectInstanceObj,
                                                   INPUT piSequence                 ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* reorderPageObjects */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retrieveDesignAttribute Include 
PROCEDURE retrieveDesignAttribute :
/*------------------------------------------------------------------------------
  ACCESS_LEVEL=PRIVATE
  Purpose:     Retrieves object attribute information for one or more objects
  Parameters:  pcObjectList     Comma delimited list of objects
               pcResultCode     "*" Get all result codes
                                ""  Get default result code
                                Specified result code to retrieve
               pcGetWhat        "MASTER"  Only retrieves MASTER attributes
                                "INSTANCE" Retrieves only Instance attributes
                                "" or "ALL" Retrieves both Instance and Master attributes 
               plGetClass       YES  Get class attribute values                 
               plRecursive      YES  If pcGetWhat is 'INSTANCE' or 'ALL' then get the Master objects
                                     of the children and retrieve their instances. Repeat recursively.
               TABLE ttObject
               TABLE ttObjectAttribute 
               TABLE ttClassAttribute
  Notes:            
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcObjectList    AS CHARACTER NO-UNDO.
 DEFINE INPUT  PARAMETER pcResultCode    AS CHARACTER NO-UNDO.
 DEFINE INPUT  PARAMETER pcGetWhat       AS CHARACTER NO-UNDO.
 DEFINE INPUT  PARAMETER plGetClass      AS LOGICAL   NO-UNDO.
 DEFINE INPUT  PARAMETER plRecursive     AS LOGICAL   NO-UNDO.
 DEFINE OUTPUT PARAMETER TABLE FOR ttObject.
 DEFINE OUTPUT PARAMETER TABLE FOR ttObjectAttribute.
 DEFINE OUTPUT PARAMETER TABLE FOR ttClassAttribute.
 
 &IF DEFINED(Server-Side) EQ 0 &THEN
  RUN ry/app/rydesredap.p ON gshAstraAppServer ( INPUT  pcObjectList,
                                                 INPUT pcResultCode,
                                                 INPUT  pcGetWhat,
                                                 INPUT plgetClass,
                                                 INPUT plRecursive,
                                                 OUTPUT TABLE ttObject,
                                                 OUTPUT TABLE ttObjectAttribute,
                                                 OUTPUT TABLE ttClassAttribute) NO-ERROR.
  IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN 
     RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).                                                       
 &ELSE
   
  EMPTY TEMP-TABLE ttObject.
  EMPTY TEMP-TABLE ttObjectAttribute.
  EMPTY TEMP-TABLE ttClassAttribute.
  empty temp-table ttUiEvent.
   
  RUN retrieveDesignAttrRecursive IN TARGET-PROCEDURE 
                                  (INPUT pcObjectList,
                                   INPUT pcResultCode,
                                   INPUT pcGetWhat,
                                   INPUT plGetClass,
                                   INPUT plRecursive,
                                   INPUT-OUTPUT TABLE ttObject,
                                   INPUT-OUTPUT TABLE ttObjectAttribute,
                                   INPUT-OUTPUT TABLE ttClassAttribute ).
    /* We don't currently care about UI events, 
       so delete the contents of this TT.     
     */
    empty temp-table ttUiEvent.
&ENDIF

    assign error-status:error = no.
    return.
END PROCEDURE.    /* retrieveDesignAttribute */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retrieveDesignAttrRecursive Include 
PROCEDURE retrieveDesignAttrRecursive :
/*------------------------------------------------------------------------------
  ACCESS_LEVEL=PRIVATE
  Purpose:     Retrieves object attribute information called recursively
  Parameters:  pcObjectList     Comma delimited list of objects
               pcResultCode     "*" Get all result codes
                                ""  Get default result code
                                Specified result code to retrieve
               pcGetWhat        "MASTER"  Only retrieves MASTER attributes
                                "INSTANCE" Retrieves only Instance attributes
                                "" or "ALL" Retrieves both Instance and Master attributes 
               plGetClass       YES  Get class attributes                 
               plRecursive        YES  If pcGetWhat is 'INSTANCE' or 'ALL' then get the Master objects
                                     of the children and retrieve their instances. Repeat recursively.
               TABLE ttObject
               TABLE ttObjectAttribute 
  Notes:            
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcObjectList    AS CHARACTER NO-UNDO.
 DEFINE INPUT  PARAMETER pcResultCode    AS CHARACTER NO-UNDO.
 DEFINE INPUT  PARAMETER pcGetWhat       AS CHARACTER NO-UNDO.
 DEFINE INPUT  PARAMETER plGetClass      AS LOGICAL   NO-UNDO.
 DEFINE INPUT  PARAMETER plRecursive     AS LOGICAL   NO-UNDO.
 DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttObject.
 DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttObjectAttribute.   
 DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttClassAttribute.   
   
 DEFINE VARIABLE iResultCodeLoop    AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iObjectLoop        AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iClassLoop         AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cResultCode        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE dResultCodeObj     AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE cObjectName        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cClassList         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cClassName         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE dParentClassObj    AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE cContainerObjects  AS CHARACTER  NO-UNDO.
    define variable cInheritsFromClasses    as character                no-undo.

 DEFINE BUFFER rycso                 FOR ryc_smartObject.
 DEFINE BUFFER rycoi                 FOR ryc_object_instance.

/* Ensure that the list of result codes is non-blank, non-* and includes the 
 * default result code.                                                      */
 RUN resolveResultCodes IN gshRepositoryManager ( INPUT YES, INPUT-OUTPUT pcResultCode ) NO-ERROR.
 IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN 
    RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

OBJECT-LOOP:
DO iObjectLoop = 1 TO NUM-ENTRIES(pcObjectList):
  ASSIGN cObjectName = ENTRY(iObjectLoop,pcObjectList).
  RESULT-CODE-LOOP:
  DO iResultCodeLoop = 1 TO NUM-ENTRIES(pcResultCode):
     ASSIGN cResultCode = ENTRY(iResultCodeLoop, pcResultCode).

     FIND FIRST ryc_customization_result WHERE
                ryc_customization_result.customization_result_code = cResultCode
                NO-LOCK NO-ERROR.
     IF NOT AVAILABLE ryc_customization_result THEN
     DO:
         IF cResultCode EQ "{&DEFAULT-RESULT-CODE}":U THEN
             ASSIGN dResultCodeObj = 0.
         ELSE
             RETURN ERROR {aferrortxt.i 'AF' '5' 'ryc_customization_result' 'customization_result_code' '"result code"' "'Result code:' + cResultCode"}.
     END.    /* n/a result code */
     ELSE
         ASSIGN dResultCodeObj = ryc_customization_result.customization_result_obj.

     /** Container Object 
      *  ----------------------------------------------------------------------- **/
     /* Object */
     FIND FIRST ryc_smartObject WHERE
                ryc_smartObject.object_filename          = cObjectName AND
                ryc_smartObject.customization_result_obj = dResultCodeObj
                NO-LOCK NO-ERROR.
     IF NOT AVAILABLE ryc_smartObject THEN
     DO:
         IF dResultCodeObj EQ 0 THEN
             RETURN ERROR {aferrortxt.i 'AF' '5' 'ryc_smartObject' 'object_filename' '"object"' "'Object name:' + cObjectName" }.
         ELSE
             NEXT RESULT-CODE-LOOP.
     END.    /* n/a object */

     /* Related information */
     FIND FIRST gsc_object_type WHERE
                gsc_object_type.object_type_obj = ryc_smartObject.object_type_obj
                NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gsc_object_type THEN
         RETURN ERROR {aferrortxt.i 'AF' '5' 'gsc_object_type' 'object_type_obj' '"object type (class)"' }.

     FIND FIRST gsc_product_module WHERE
                gsc_product_module.product_module_obj = ryc_smartObject.product_module_obj
                NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gsc_product_module THEN
         RETURN ERROR {aferrortxt.i 'AF' '5' 'gsc_product_module' 'product_module_obj' '"product module"' }.

     /* Container/Master object */
     CREATE ttObject.
     ASSIGN ttObject.tLogicalObjectName       = ryc_smartObject.object_filename
            ttObject.tResultCode              = cResultCode
            ttObject.tSmartObjectObj          = ryc_smartObject.smartObject_obj
            ttObject.tContainerSmartObjectObj = 0
            ttObject.tObjectInstanceObj       = 0
            ttObject.tObjectInstanceName      = "":U
            ttObject.tClassName               = gsc_object_type.object_type_code
            ttObject.tLayoutPosition          = "":U
            ttObject.tPageNumber              = 0
            ttObject.tProductModuleCode       = gsc_product_module.product_module_code               
            ttObject.tObjectIsAContainer      = CAN-FIND(FIRST ryc_object_instance WHERE
                                                               ryc_object_instance.container_smartObject_obj = ryc_smartObject.smartObject_obj).
     /* Assign Class list used later to retrieve class attributes */
     IF LOOKUP(gsc_object_type.object_type_code,cClassList) EQ 0 THEN
        ASSIGN cClassList = cClassList + (IF cClassList = "" THEN "" ELSE ",") + gsc_object_type.object_type_code.

     /* If there is a design-time SDO associated with this object,find it  */
     IF ryc_smartObject.sdo_smartObject_obj NE 0 AND ryc_smartObject.sdo_smartObject_obj NE ? THEN
     DO:
         FIND FIRST rycso WHERE
                    rycso.smartObject_obj = ryc_smartObject.sdo_smartObject_obj
                    NO-LOCK NO-ERROR.
         IF NOT AVAILABLE rycso THEN
             RETURN ERROR {aferrortxt.i 'AF' '5' 'ryc_smartObject' 'smartObject_obj' '"associated SDO object record"' }.

         ASSIGN ttObject.tSdoObjectName = rycso.object_filename.
     END.    /* there is an associated SDO */

     /* Master Attributes. */
     IF pcGetWhat NE "INSTANCE":U THEN
     FOR EACH ryc_attribute_value WHERE
              ryc_attribute_value.object_type_obj     = gsc_object_type.object_type_obj AND
              ryc_attribute_value.smartObject_obj     = ryc_smartObject.smartObject_obj AND
              ryc_attribute_value.object_instance_obj = 0
              NO-LOCK,
        FIRST ryc_attribute WHERE
              ryc_attribute.attribute_label = ryc_attribute_value.attribute_label AND
              ryc_attribute.derived_value   = NO
              NO-LOCK:
         CREATE ttObjectAttribute.
         ASSIGN ttObjectAttribute.tSmartObjectObj    = ryc_attribute_value.smartObject_obj
                ttObjectAttribute.tObjectInstanceObj = 0
                ttObjectAttribute.tAttributeLabel    = ryc_attribute.attribute_label
                ttObjectAttribute.tDataType          = ryc_attribute.data_type
                ttObjectAttribute.tWhereStored       = "MASTER":U.
         CASE ryc_attribute.data_type:
           WHEN {&CHARACTER-DATA-TYPE} THEN ASSIGN ttObjectAttribute.tAttributeValue = ryc_attribute_value.character_value.
           WHEN {&LOGICAL-DATA-TYPE}   THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.logical_value).
           WHEN {&INTEGER-DATA-TYPE}   THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.integer_value).
           WHEN {&HANDLE-DATA-TYPE}    THEN ASSIGN ttObjectAttribute.tAttributeValue = "?":U.
           WHEN {&DECIMAL-DATA-TYPE}   THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.decimal_value).
           WHEN {&ROWID-DATA-TYPE}     THEN ASSIGN ttObjectAttribute.tAttributeValue = ryc_attribute_value.character_value.
           WHEN {&RAW-DATA-TYPE}       THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.raw_value).
           WHEN {&DATE-DATA-TYPE}      THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.date_value).
           WHEN {&RECID-DATA-TYPE}     THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(IF ryc_attribute_value.integer_value = 0 THEN ? ELSE ryc_attribute_value.integer_value).
           OTHERWISE                        ASSIGN ttObjectAttribute.tAttributeValue = ryc_attribute_value.character_value.
         END CASE.   /* DataType */

         /* Assign the Super Procedure */
         IF AVAILABLE ttObject AND ttObjectAttribute.tAttributeLabel = "SuperProcedure":U THEN
            ASSIGN ttObject.tCustomSuperProcedure = ttObjectAttribute.tAttributeValue.    
     END.    /* master attributes  FOR EACH ryc_attribute_value */


     /* Object Instances (Contained objects)  */
     IF ttObject.tObjectIsAContainer AND pcGetWhat NE "MASTER":U THEN
     FOR EACH ryc_object_instance WHERE
              ryc_object_instance.container_smartObject_obj = ryc_smartObject.smartObject_obj
              NO-LOCK,
        FIRST rycso WHERE
              rycso.smartObject_obj = ryc_object_instance.smartObject_obj
              NO-LOCK,
        FIRST gsc_object_type WHERE
              gsc_object_type.object_type_obj = rycso.object_type_obj
              NO-LOCK,                 
        FIRST gsc_product_module WHERE                  
              gsc_product_module.product_module_obj = rycso.product_module_obj
              NO-LOCK:       
        /* Object instances. */
        CREATE ttObject.
        ASSIGN ttObject.tLogicalObjectName       = rycso.object_filename
               ttObject.tResultCode              = cResultCode
               ttObject.tSmartObjectObj          = rycso.smartObject_obj
               ttObject.tContainerSmartObjectObj = ryc_object_instance.container_smartObject_obj
               ttObject.tObjectInstanceObj       = ryc_object_instance.object_instance_obj
               ttObject.tObjectInstanceName      = ryc_object_instance.instance_name
               ttObject.tClassName               = gsc_object_type.object_type_code
               ttObject.tLayoutPosition          = ryc_object_instance.layout_position
               ttObject.tCustomSuperProcedure    = "":U     /* Supers only stored at the master/container level. */
               ttObject.tProductModuleCode       = gsc_product_module.product_module_code
               ttObject.tSdoObjectName           = "":U     /* the SDO name is only set for master/container objects */
               ttObject.tObjectIsAContainer      = CAN-FIND(FIRST rycoi WHERE rycoi.container_smartObject_obj = rycso.smartObject_obj)
               ttObject.tPageObjectSequence      = ryc_object_instance.object_sequence.

        /* Assign Class list used later to retrieve class attributes */
        IF LOOKUP(gsc_object_type.object_type_code,cClassList) EQ 0 THEN
           ASSIGN cClassList = cClassList + (IF cClassList = "" THEN "" ELSE ",") + gsc_object_type.object_type_code.
       
       IF LOOKUP(ttObject.tLogicalObjectName,cContainerObjects) EQ 0 AND ttObject.tObjectIsAContainer THEN   
          ASSIGN cContainerObjects = cContainerObjects + (IF cContainerObjects = "" THEN "" ELSE ",")
                                                    + ttObject.tLogicalObjectName.   

         IF ryc_object_instance.page_obj NE 0 AND ryc_object_instance.page_obj NE ? THEN
         DO:
             FIND FIRST ryc_page WHERE
                        ryc_page.page_obj = ryc_object_instance.page_obj
                        NO-LOCK NO-ERROR.
             IF NOT AVAILABLE ryc_page THEN
                 RETURN ERROR {aferrortxt.i 'AF' '5' 'ryc_page' 'page_obj' '"page"' }.

             ASSIGN ttObject.tPageNumber         = ryc_page.page_sequence   .
         END.  /* page exists */

        /* Attributes - instance  */
        IF NOT CAN-FIND(FIRST ttObjectAttribute WHERE
                       ttObjectAttribute.tSmartObjectObj    = rycso.smartObject_obj AND
                       ttObjectAttribute.tObjectInstanceObj = ryc_object_instance.object_instance_obj ) THEN             
        FOR EACH ryc_attribute_value WHERE
                 ryc_attribute_value.object_type_obj     = rycso.object_type_obj                  AND
                 ryc_attribute_value.smartObject_obj     = ryc_object_instance.smartObject_obj    AND
                 ryc_attribute_value.object_instance_obj = ryc_object_instance.object_instance_obj
                 NO-LOCK,
           FIRST ryc_attribute WHERE
                 ryc_attribute.attribute_label = ryc_attribute_value.attribute_label AND
                 ryc_attribute.derived_value   = NO
                 NO-LOCK:
           CREATE ttObjectAttribute.                     
           ASSIGN ttObjectAttribute.tSmartObjectObj    = ryc_attribute_value.smartObject_obj
                  ttObjectAttribute.tObjectInstanceObj = ryc_attribute_value.object_instance_obj
                  ttObjectAttribute.tAttributeLabel    = ryc_attribute.attribute_label
                  ttObjectAttribute.tDataType          = ryc_attribute.data_type
                  ttObjectAttribute.tWhereStored       = "INSTANCE":U.
           CASE ryc_attribute.data_type:
              WHEN {&CHARACTER-DATA-TYPE} THEN ASSIGN ttObjectAttribute.tAttributeValue = ryc_attribute_value.character_value.
              WHEN {&LOGICAL-DATA-TYPE}   THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.logical_value).
              WHEN {&INTEGER-DATA-TYPE}   THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.integer_value).
              WHEN {&HANDLE-DATA-TYPE}    THEN ASSIGN ttObjectAttribute.tAttributeValue = "?":U.
              WHEN {&DECIMAL-DATA-TYPE}   THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.decimal_value).
              WHEN {&ROWID-DATA-TYPE}     THEN ASSIGN ttObjectAttribute.tAttributeValue = ryc_attribute_value.character_value.
              WHEN {&RAW-DATA-TYPE}       THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.raw_value).
              WHEN {&DATE-DATA-TYPE}      THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.date_value).
              WHEN {&RECID-DATA-TYPE}     THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(IF ryc_attribute_value.integer_value = 0 THEN ? ELSE ryc_attribute_value.integer_value).
              OTHERWISE                        ASSIGN ttObjectAttribute.tAttributeValue = ryc_attribute_value.character_value.
            END CASE.   /* DataType */
        END.    /* attributes - instance */

        /* Get the instance's master attributes.*/
        IF NOT CAN-FIND(FIRST ttObjectAttribute WHERE
                        ttObjectAttribute.tSmartObjectObj    = rycso.smartObject_obj AND
                        ttObjectAttribute.tObjectInstanceObj = 0                    ) THEN             
        FOR EACH ryc_attribute_value WHERE
                 ryc_attribute_value.object_type_obj     = rycso.object_type_obj               AND
                 ryc_attribute_value.smartObject_obj     = ryc_object_instance.smartObject_obj AND
                 ryc_attribute_value.object_instance_obj = 0
                 NO-LOCK,
           FIRST ryc_attribute WHERE
                 ryc_attribute.attribute_label = ryc_attribute_value.attribute_label AND
                 ryc_attribute.derived_value   = NO
                 NO-LOCK:
            CREATE ttObjectAttribute.
            ASSIGN ttObjectAttribute.tSmartObjectObj    = ryc_attribute_value.smartObject_obj
                   ttObjectAttribute.tObjectInstanceObj = 0
                   ttObjectAttribute.tAttributeLabel    = ryc_attribute.attribute_label
                   ttObjectAttribute.tDataType          = ryc_attribute.data_type
                   ttObjectAttribute.tWhereStored       = "MASTER":U.
            CASE ryc_attribute.data_type:
              WHEN {&CHARACTER-DATA-TYPE} THEN ASSIGN ttObjectAttribute.tAttributeValue = ryc_attribute_value.character_value.
              WHEN {&LOGICAL-DATA-TYPE}   THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.logical_value).
              WHEN {&INTEGER-DATA-TYPE}   THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.integer_value).
              WHEN {&HANDLE-DATA-TYPE}    THEN ASSIGN ttObjectAttribute.tAttributeValue = "?":U.
              WHEN {&DECIMAL-DATA-TYPE}   THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.decimal_value).
              WHEN {&ROWID-DATA-TYPE}     THEN ASSIGN ttObjectAttribute.tAttributeValue = ryc_attribute_value.character_value.
              WHEN {&RAW-DATA-TYPE}       THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.raw_value).
              WHEN {&DATE-DATA-TYPE}      THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.date_value).
              WHEN {&RECID-DATA-TYPE}     THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(IF ryc_attribute_value.integer_value = 0 THEN ? ELSE ryc_attribute_value.integer_value).
              OTHERWISE                        ASSIGN ttObjectAttribute.tAttributeValue = ryc_attribute_value.character_value.
            END CASE.   /* DataType */
        END.    /* attributes - master */
     END.    /* object instances */
  END.    /* RESULT-CODE-LOOP:  */
END. /* Object Loop */

/* Retrieve class attributes and add them to the ttObjectAttributeTable  */

IF plGetClass THEN
CLASS-LOOP:
DO iClassLoop = 1 TO NUM-ENTRIES(cClassList):
  ASSIGN cClassName = ENTRY(iClassLoop,cClassList).

    /* This function is a recursive function which reads the class
       hierarchy and custom classes to retrieve attributes and events.    
       Don't empty the ttClassAttribute temp-table here because we 
       may be retrieving multiple classes. The ttClass temp-table is 
       emptied in this procedure's caller.
     */
    dynamic-function("buildClassAttributes":U in target-procedure,
                     input        cClassName,
                     input        0,
                     input-output cInheritsFromClasses ).
END.  /* Class Loop */

/* Build list of all instance object that are containers */
IF plRecursive AND pcGetWhat NE "MASTER":U THEN 
DO:
   IF cContainerObjects > "" THEN
      RUN retrieveDesignAttrRecursive (INPUT cContainerObjects,
                                       INPUT pcResultCode,
                                       INPUT pcGetWhat,
                                       INPUT plGetClass,
                                       INPUT plRecursive,
                                       INPUT-OUTPUT TABLE ttObject,
                                       INPUT-OUTPUT TABLE ttObjectAttribute,
                                       INPUT-OUTPUT TABLE ttClassAttribute).
END.                                    

    assign error-status:error = no.
    return.
END PROCEDURE.    /* retrieveDesignAttrRecursive */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retrieveDesignClass Include 
PROCEDURE retrieveDesignClass :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Retrieves class-level information for a specific class.
  Parameters:  pcClassName          
               pcInheritsFromClasses
               TABLE ttClassAttribute
               TABLE ttUiEvent 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcClassName             AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcInheritsFromClasses   AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttClassAttribute.
    DEFINE OUTPUT PARAMETER TABLE FOR ttUiEvent.
    DEFINE output parameter table for ttSupportedLink.

    &IF DEFINED(Server-Side) EQ 0 &THEN
    RUN ry/app/rydesredcp.p ON gshAstraAppServer ( INPUT  pcClassName,
                                                   OUTPUT pcInheritsFromClasses,
                                                   OUTPUT TABLE ttClassAttribute,
                                                   OUTPUT TABLE ttUiEvent,
                                                   output table ttSupportedLink         ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).                                                       
    &ELSE
    EMPTY TEMP-TABLE ttClassAttribute.
    EMPTY TEMP-TABLE ttUiEvent.
    empty temp-table ttSupportedLink.
        
    /* This function is a recursive function which reads the class
       hierarchy and custom classes to retrieve attributes and events.    
     */
    dynamic-function("buildClassAttributes":U in target-procedure,
                     input        pcClassName,
                     input        0,
                     input-output pcInheritsFromClasses ).    
    &ENDIF
                
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* retrieveDesignClass */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retrieveDesignObject Include 
PROCEDURE retrieveDesignObject :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Returns an object and its instances for a specific result code,
               or for all result codes. 
  Parameters:  pcObjectName -            
               pcResultCode -
               TABLE ttObject
               TABLE ttPage           
               TABLE ttLink            
               TABLE ttUIEvent
               TABLE ttObjectAttribute
  Notes:       * This will return an object and its contained instances. If one
                 of those instances is itself a container, a separate call needs
                 to be made to retrieve that information.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcObjectName            AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcResultCode            AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttObject.
    DEFINE OUTPUT PARAMETER TABLE FOR ttPage.
    DEFINE OUTPUT PARAMETER TABLE FOR ttLink.
    DEFINE OUTPUT PARAMETER TABLE FOR ttUIEvent.
    DEFINE OUTPUT PARAMETER TABLE FOR ttObjectAttribute.

    &IF DEFINED(Server-Side) EQ 0 &THEN
    RUN ry/app/rydesredop.p ON gshAstraAppServer ( INPUT  pcObjectName,
                                                   INPUT  pcResultCode,
                                                   OUTPUT TABLE ttObject,
                                                   OUTPUT TABLE ttPage,
                                                   OUTPUT TABLE ttLink,
                                                   OUTPUT TABLE ttUiEvent,
                                                   OUTPUT TABLE ttObjectAttribute ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    &ELSE 
    DEFINE VARIABLE iResultCodeLoop             AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE cResultCode                 AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE dResultCodeObj              AS DECIMAL                  NO-UNDO.

    DEFINE BUFFER rycso         FOR ryc_smartObject.
    DEFINE BUFFER rycoi         FOR ryc_object_instance.

    /** Setup & Initialise
     *  ----------------------------------------------------------------------- **/
    EMPTY TEMP-TABLE ttObject.
    EMPTY TEMP-TABLE ttPage.
    EMPTY TEMP-TABLE ttLink.
    EMPTY TEMP-TABLE ttUIEvent.
    EMPTY TEMP-TABLE ttObjectAttribute.

    /* Ensure that the list of result codes is non-blank, non-* and includes the 
     * default result code.                                                      */
    RUN resolveResultCodes IN gshRepositoryManager ( INPUT YES, INPUT-OUTPUT pcResultCode ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

    /* Get the objects, per result code. */
    RESULT-CODE-LOOP:
    DO iResultCodeLoop = 1 TO NUM-ENTRIES(pcResultCode):
        ASSIGN cResultCode = ENTRY(iResultCodeLoop, pcResultCode).

        FIND FIRST ryc_customization_result WHERE
                   ryc_customization_result.customization_result_code = cResultCode
                   NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ryc_customization_result THEN
        DO:
            IF cResultCode EQ "{&DEFAULT-RESULT-CODE}":U THEN
                ASSIGN dResultCodeObj = 0.
            ELSE
                RETURN ERROR {aferrortxt.i 'AF' '5' 'ryc_customization_result' 'customization_result_code' '"result code"' "'Result code:' + cResultCode"}.
        END.    /* n/a result code */
        ELSE
            ASSIGN dResultCodeObj = ryc_customization_result.customization_result_obj.

        /** Container Object 
         *  ----------------------------------------------------------------------- **/
        /* Object */
        FIND FIRST ryc_smartObject WHERE
                   ryc_smartObject.object_filename          = pcObjectName AND
                   ryc_smartObject.customization_result_obj = dResultCodeObj
                   NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ryc_smartObject THEN
        DO:
            IF dResultCodeObj EQ 0 THEN
                RETURN ERROR {aferrortxt.i 'AF' '5' 'ryc_smartObject' 'object_filename' '"object"' "'Object name:' + pcObjectName" }.
            ELSE
                NEXT RESULT-CODE-LOOP.
        END.    /* n/a object */

        /* Related information */
        FIND FIRST gsc_object_type WHERE
                   gsc_object_type.object_type_obj = ryc_smartObject.object_type_obj
                   NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gsc_object_type THEN
            RETURN ERROR {aferrortxt.i 'AF' '5' 'gsc_object_type' 'object_type_obj' '"object type (class)"' }.

        FIND FIRST gsc_product_module WHERE
                   gsc_product_module.product_module_obj = ryc_smartObject.product_module_obj
                   NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gsc_product_module THEN
            RETURN ERROR {aferrortxt.i 'AF' '5' 'gsc_product_module' 'product_module_obj' '"product module"' }.

        /* Container/Master object */
        CREATE ttObject.
        ASSIGN ttObject.tLogicalObjectName       = ryc_smartObject.object_filename
               ttObject.tObjectDescription       = ryc_smartObject.object_description
               ttObject.tResultCode              = cResultCode
               ttObject.tSmartObjectObj          = ryc_smartObject.smartObject_obj
               ttObject.tContainerSmartObjectObj = 0
               ttObject.tObjectInstanceObj       = 0
               ttObject.tObjectInstanceName      = "":U
               ttObject.tClassName               = gsc_object_type.object_type_code
               ttObject.tLayoutPosition          = "":U
               ttObject.tPageNumber              = 0
               ttObject.tProductModuleCode       = gsc_product_module.product_module_code               
               ttObject.tObjectIsAContainer      = CAN-FIND(FIRST ryc_object_instance WHERE
                                                                  ryc_object_instance.container_smartObject_obj = ryc_smartObject.smartObject_obj).

        /* If there is a design-time SDO associated with this object, 
         * find that SDO's object record.                              */
        IF ryc_smartObject.sdo_smartObject_obj NE 0 THEN
        DO:
            FIND FIRST rycso WHERE
                       rycso.smartObject_obj = ryc_smartObject.sdo_smartObject_obj
                       NO-LOCK NO-ERROR.
            IF NOT AVAILABLE rycso THEN
                RETURN ERROR {aferrortxt.i 'AF' '5' 'ryc_smartObject' 'smartObject_obj' '"associated SDO object record"' }.
         
            ASSIGN ttObject.tSdoObjectName = rycso.object_filename.
        END.    /* there is an associated SDO */
        
        /* Attributes. */
        FOR EACH ryc_attribute_value WHERE
                 ryc_attribute_value.object_type_obj     = gsc_object_type.object_type_obj AND
                 ryc_attribute_value.smartObject_obj     = ryc_smartObject.smartObject_obj AND
                 ryc_attribute_value.object_instance_obj = 0
                 NO-LOCK,
           FIRST ryc_attribute WHERE
                 ryc_attribute.attribute_label = ryc_attribute_value.attribute_label AND
                 ryc_attribute.derived_value   = NO
                 NO-LOCK:
            CREATE ttObjectAttribute.
            ASSIGN ttObjectAttribute.tSmartObjectObj    = ryc_attribute_value.smartObject_obj
                   ttObjectAttribute.tObjectInstanceObj = 0
                   ttObjectAttribute.tAttributeLabel    = ryc_attribute.attribute_label
                   ttObjectAttribute.tDataType          = ryc_attribute.data_type
                   ttObjectAttribute.tWhereStored       = "MASTER":U.
            CASE ryc_attribute.data_type:
              WHEN {&CHARACTER-DATA-TYPE} THEN ASSIGN ttObjectAttribute.tAttributeValue = ryc_attribute_value.character_value.
              WHEN {&LOGICAL-DATA-TYPE}   THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.logical_value).
              WHEN {&INTEGER-DATA-TYPE}   THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.integer_value).
              WHEN {&HANDLE-DATA-TYPE}    THEN ASSIGN ttObjectAttribute.tAttributeValue = "?":U.
              WHEN {&DECIMAL-DATA-TYPE}   THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.decimal_value).
              WHEN {&ROWID-DATA-TYPE}     THEN ASSIGN ttObjectAttribute.tAttributeValue = ryc_attribute_value.character_value.
              WHEN {&RAW-DATA-TYPE}       THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.raw_value).
              WHEN {&DATE-DATA-TYPE}      THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.date_value).
              WHEN {&RECID-DATA-TYPE}     THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(IF ryc_attribute_value.integer_value = 0 THEN ? ELSE ryc_attribute_value.integer_value).
              OTHERWISE                        ASSIGN ttObjectAttribute.tAttributeValue = ryc_attribute_value.character_value.
            END CASE.   /* DataType */
            
            /* Assign the Super Procedure */
            IF AVAILABLE ttObject AND ttObjectAttribute.tAttributeLabel = "SuperProcedure":U THEN
               ASSIGN ttObject.tCustomSuperProcedure = ttObjectAttribute.tAttributeValue.    
        END.    /* attributes */


        /* Links */
        FOR EACH ryc_smartlink WHERE
                 ryc_smartlink.container_smartObject_obj = ryc_smartObject.smartObject_obj
                 NO-LOCK:
            CREATE ttLink.
            ASSIGN ttLink.tSmartObjectObj          = ryc_smartlink.container_smartObject_obj
                   ttLink.tSourceObjectInstanceObj = ryc_smartlink.source_object_instance_obj
                   ttLink.tTargetObjectInstanceObj = ryc_smartlink.target_object_instance_obj
                   ttLink.tLinkName                = ryc_smartlink.link_name.
        END.    /* each link. */

        /* Ui Events */
        FOR EACH ryc_ui_event WHERE
                 ryc_ui_event.object_type_obj     = gsc_object_type.object_type_obj AND
                 ryc_ui_event.smartobject_obj     = ryc_smartObject.smartObject_obj AND
                 ryc_ui_event.object_instance_obj = 0
                 NO-LOCK:
            /* We don't update the class name since these objects can be uniquely
             * found by the tSmartObjectObj + tObjectInstanceObj. The temp-table has the
             * class name field in it because the TT is used for both class and object UI 
             * events.                                                                    */
            CREATE ttUiEvent.
            ASSIGN ttUiEvent.tSmartObjectObj    = ryc_ui_event.smartObject_obj
                   ttUiEvent.tObjectInstanceObj = ryc_ui_event.object_instance_obj
                   ttUiEvent.tClassName         = "":U
                   ttUiEvent.tEventName         = ryc_ui_event.event_name
                   ttUiEvent.tActionType        = ryc_ui_event.action_type
                   ttUiEvent.tActionTarget      = ryc_ui_event.action_target
                   ttUiEvent.tEventAction       = ryc_ui_event.event_action
                   ttUiEvent.tEventParameter    = ryc_ui_event.event_parameter
                   ttUiEvent.tEventDisabled     = ryc_ui_event.event_disabled
                   ttUiEvent.tWhereStore        = "MASTER":U.
        END.    /* each UI event */

        /* Pages */
        FOR EACH ryc_page WHERE
                 ryc_page.container_smartobject_obj = ryc_smartObject.smartobject_obj
                 NO-LOCK:
            FIND FIRST ryc_layout WHERE
                       ryc_layout.layout_obj = ryc_page.layout_obj
                       NO-LOCK NO-ERROR.
            CREATE ttPage.
            ASSIGN ttPage.tSmartObjectObj = ryc_smartObject.smartObject_obj
                   ttPage.tPageNumber     = ryc_page.page_sequence
                   ttPage.tPageReference  = ryc_page.page_reference
                   ttPage.tPageLabel      = ryc_page.page_label
                   ttPage.tLayoutCode     = (IF AVAILABLE ryc_layout THEN ryc_layout.layout_code ELSE "00":U)                   
                   ttPage.tPageObj        = ryc_page.page_obj
                   ttPage.tSecurityToken  = ryc_page.security_token.
        END.    /* pages */

        /* Page 0 
         * There should always be a page zero record. This will usually be
         * created from the ryc_page record, but for backwards compatibility
         * we make sure that there is a page 0 record.                       */
        FIND FIRST ttPage WHERE
                   ttPage.tSmartObjectObj = ryc_smartObject.smartObject_obj AND
                   ttPage.tPageNumber      = 0
                   NO-ERROR.
        IF NOT AVAILABLE ttPage THEN
        DO:
            FIND FIRST ryc_layout WHERE
                       ryc_layout.layout_obj = ryc_smartObject.layout_obj
                       NO-LOCK NO-ERROR.
            CREATE ttPage.
            ASSIGN ttPage.tSmartObjectObj  = ryc_smartObject.smartObject_obj
                   ttPage.tPageNumber      = 0
                   ttPage.tPageReference   = "":U
                   ttPage.tPageLabel       = "Page Zero"
                   ttPage.tLayoutCode      = (IF AVAILABLE ryc_layout THEN ryc_layout.layout_code ELSE "00":U)
                   ttPage.tPageObj         = 0
                   ttPage.tSecurityToken   = "":U.
        END.    /* no page zero */

        /** Object Instances (Contained objects)
         *  ----------------------------------------------------------------------- **/
        IF ttObject.tObjectIsAContainer THEN
        FOR EACH ryc_object_instance WHERE
                 ryc_object_instance.container_smartObject_obj = ryc_smartObject.smartObject_obj
                 NO-LOCK,
           FIRST rycso WHERE
                 rycso.smartObject_obj = ryc_object_instance.smartObject_obj
                 NO-LOCK,
         FIRST gsc_object_type WHERE
                 gsc_object_type.object_type_obj = rycso.object_type_obj
                 NO-LOCK,                 
           FIRST gsc_product_module WHERE                  
                 gsc_product_module.product_module_obj = rycso.product_module_obj
                 NO-LOCK:       
            /* Object instances. */
            CREATE ttObject.
            ASSIGN ttObject.tLogicalObjectName       = rycso.object_filename
                   ttObject.tObjectDescription       = rycso.object_description
                   ttObject.tResultCode              = cResultCode
                   ttObject.tSmartObjectObj          = rycso.smartObject_obj
                   ttObject.tContainerSmartObjectObj = ryc_object_instance.container_smartObject_obj
                   ttObject.tObjectInstanceObj       = ryc_object_instance.object_instance_obj
                   ttObject.tObjectInstanceName      = ryc_object_instance.instance_name
                   ttObject.tClassName               = gsc_object_type.object_type_code
                   ttObject.tLayoutPosition          = ryc_object_instance.layout_position
                   ttObject.tCustomSuperProcedure    = "":U     /* Supers only stored at the master/container level. */
                   ttObject.tProductModuleCode       = gsc_product_module.product_module_code
                   ttObject.tSdoObjectName           = "":U     /* the SDO name is only set for master/container objects */
                   ttObject.tObjectIsAContainer      = CAN-FIND(FIRST rycoi WHERE rycoi.container_smartObject_obj = rycso.smartObject_obj)
                   ttObject.tPageObjectSequence      = ryc_object_instance.object_sequence.

            IF ryc_object_instance.page_obj NE 0 THEN
            DO:
                FIND FIRST ryc_page WHERE
                           ryc_page.page_obj = ryc_object_instance.page_obj
                           NO-LOCK NO-ERROR.
                IF NOT AVAILABLE ryc_page THEN
                    RETURN ERROR {aferrortxt.i 'AF' '5' 'ryc_page' 'page_obj' '"page"' }.
                
                ASSIGN ttObject.tPageNumber         = ryc_page.page_sequence   .
            END.  /* page exists */
            
            /** First get the instance's master attributes.
             *  There is the possibility that one object may be placed multiple times on the same container.
             *  In this case, we only need to retrieve the master attributes once. We assume that if one attribute
             *  is in the temp-table, then all of them are.
             *  ----------------------------------------------------------------------- **/
           IF NOT CAN-FIND(FIRST ttObjectAttribute WHERE
                          ttObjectAttribute.tSmartObjectObj    = rycso.smartObject_obj AND
                          ttObjectAttribute.tObjectInstanceObj = 0                    ) THEN             
            FOR EACH ryc_attribute_value WHERE
                     ryc_attribute_value.object_type_obj     = rycso.object_type_obj               AND
                     ryc_attribute_value.smartObject_obj     = ryc_object_instance.smartObject_obj AND
                     ryc_attribute_value.object_instance_obj = 0
                     NO-LOCK,
               FIRST ryc_attribute WHERE
                     ryc_attribute.attribute_label = ryc_attribute_value.attribute_label AND
                     ryc_attribute.derived_value   = NO
                     NO-LOCK:
                CREATE ttObjectAttribute.
                ASSIGN ttObjectAttribute.tSmartObjectObj    = ryc_attribute_value.smartObject_obj
                       ttObjectAttribute.tObjectInstanceObj = 0
                       ttObjectAttribute.tAttributeLabel    = ryc_attribute.attribute_label
                       ttObjectAttribute.tDataType          = ryc_attribute.data_type
                       ttObjectAttribute.tWhereStored       = "MASTER":U.
                CASE ryc_attribute.data_type:
                  WHEN {&CHARACTER-DATA-TYPE} THEN ASSIGN ttObjectAttribute.tAttributeValue = ryc_attribute_value.character_value.
                  WHEN {&LOGICAL-DATA-TYPE}   THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.logical_value).
                  WHEN {&INTEGER-DATA-TYPE}   THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.integer_value).
                  WHEN {&HANDLE-DATA-TYPE}    THEN ASSIGN ttObjectAttribute.tAttributeValue = "?":U.
                  WHEN {&DECIMAL-DATA-TYPE}   THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.decimal_value).
                  WHEN {&ROWID-DATA-TYPE}     THEN ASSIGN ttObjectAttribute.tAttributeValue = ryc_attribute_value.character_value.
                  WHEN {&RAW-DATA-TYPE}       THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.raw_value).
                  WHEN {&DATE-DATA-TYPE}      THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.date_value).
                  WHEN {&RECID-DATA-TYPE}     THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(IF ryc_attribute_value.integer_value = 0 THEN ? ELSE ryc_attribute_value.integer_value).
                  OTHERWISE                        ASSIGN ttObjectAttribute.tAttributeValue = ryc_attribute_value.character_value.
                END CASE.   /* DataType */
            END.    /* attributes - master */
            
            /* Attributes - instance  */
            FOR EACH ryc_attribute_value WHERE
                     ryc_attribute_value.object_type_obj     = rycso.object_type_obj                  AND
                     ryc_attribute_value.smartObject_obj     = ryc_object_instance.smartObject_obj    AND
                     ryc_attribute_value.object_instance_obj = ryc_object_instance.object_instance_obj
                     NO-LOCK,
               FIRST ryc_attribute WHERE
                     ryc_attribute.attribute_label = ryc_attribute_value.attribute_label AND
                     ryc_attribute.derived_value   = NO
                     NO-LOCK:
            CREATE ttObjectAttribute.                     
                ASSIGN ttObjectAttribute.tSmartObjectObj    = ryc_attribute_value.smartObject_obj
                       ttObjectAttribute.tObjectInstanceObj = ryc_attribute_value.object_instance_obj
                       ttObjectAttribute.tAttributeLabel    = ryc_attribute.attribute_label
                       ttObjectAttribute.tDataType          = ryc_attribute.data_type
                       ttObjectAttribute.tWhereStored       = "INSTANCE":U.
                CASE ryc_attribute.data_type:
                  WHEN {&CHARACTER-DATA-TYPE} THEN ASSIGN ttObjectAttribute.tAttributeValue = ryc_attribute_value.character_value.
                  WHEN {&LOGICAL-DATA-TYPE}   THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.logical_value).
                  WHEN {&INTEGER-DATA-TYPE}   THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.integer_value).
                  WHEN {&HANDLE-DATA-TYPE}    THEN ASSIGN ttObjectAttribute.tAttributeValue = "?":U.
                  WHEN {&DECIMAL-DATA-TYPE}   THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.decimal_value).
                  WHEN {&ROWID-DATA-TYPE}     THEN ASSIGN ttObjectAttribute.tAttributeValue = ryc_attribute_value.character_value.
                  WHEN {&RAW-DATA-TYPE}       THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.raw_value).
                  WHEN {&DATE-DATA-TYPE}      THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(ryc_attribute_value.date_value).
                  WHEN {&RECID-DATA-TYPE}     THEN ASSIGN ttObjectAttribute.tAttributeValue = STRING(IF ryc_attribute_value.integer_value = 0 THEN ? ELSE ryc_attribute_value.integer_value).
                  OTHERWISE                        ASSIGN ttObjectAttribute.tAttributeValue = ryc_attribute_value.character_value.
                END CASE.   /* DataType */
            END.    /* attributes - instance */
            
            /* Ui Events - master 
             *  There is the possibility that one object may be placed multiple times on the same container.
             *  In this case, we only need to retrieve the master UI events once. We assume that if one event
             *  is in the temp-table, then all of them are.
             */            
           IF NOT CAN-FIND(FIRST ttUiEvent WHERE
                          ttUiEvent.tSmartObjectObj    = rycso.smartObject_obj AND
                          ttUiEvent.tObjectInstanceObj = 0                      ) THEN
            FOR EACH ryc_ui_event WHERE
                     ryc_ui_event.object_type_obj           = rycso.object_type_obj AND
                     ryc_ui_event.smartobject_obj           = rycso.smartObject_obj AND
                     ryc_ui_event.object_instance_obj       = 0
                     NO-LOCK:
                CREATE ttUiEvent.
                ASSIGN ttUiEvent.tSmartObjectObj    = ryc_ui_event.smartObject_obj
                       ttUiEvent.tObjectInstanceObj = 0
                       ttUiEvent.tClassName         = "":U
                       ttUiEvent.tEventName         = ryc_ui_event.event_name
                       ttUiEvent.tActionType        = ryc_ui_event.action_type
                       ttUiEvent.tActionTarget      = ryc_ui_event.action_target
                       ttUiEvent.tEventAction       = ryc_ui_event.event_action
                       ttUiEvent.tEventParameter    = ryc_ui_event.event_parameter
                       ttUiEvent.tEventDisabled     = ryc_ui_event.event_disabled
                       ttUiEvent.tWhereStored       = "MASTER":U.
            END.    /* each UI event - master */

            /* Ui Events - instance  */
            FOR EACH ryc_ui_event WHERE
                     ryc_ui_event.object_type_obj           = rycso.object_type_obj            AND
                     ryc_ui_event.smartobject_obj           = rycso.smartObject_obj               AND
                     ryc_ui_event.object_instance_obj       = ryc_object_instance.object_instance_obj
                     NO-LOCK:
                CREATE ttUiEvent.
                ASSIGN ttUiEvent.tSmartObjectObj    = ryc_ui_event.smartObject_obj
                       ttUiEvent.tObjectInstanceObj = ryc_ui_event.object_instance_obj
                       ttUiEvent.tClassName         = "":U
                       ttUiEvent.tEventName         = ryc_ui_event.event_name
                       ttUiEvent.tActionType        = ryc_ui_event.action_type
                       ttUiEvent.tActionTarget      = ryc_ui_event.action_target
                       ttUiEvent.tEventAction       = ryc_ui_event.event_action
                       ttUiEvent.tEventParameter    = ryc_ui_event.event_parameter
                       ttUiEvent.tEventDisabled     = ryc_ui_event.event_disabled
                       ttUiEvent.tWhereStored       = "INSTANCE":U.
            END.    /* each UI event - instance */
        END.    /* object instances */
    END.    /* RESULT-CODE-LOOP:  */
    &ENDIF
        
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* retrieveDesignObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverRetrieveClassExtInfo Include 
PROCEDURE serverRetrieveClassExtInfo :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Returns tables with the exteneded class information in them to 
               a caller.
  Parameters:  pcClassName     -
               phClassExtTable -
  Notes:       
*** THIS API HAS BEEN DEPRECATED ***  
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcClassName             AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER phClassExtTable         AS HANDLE           NO-UNDO. 
    
    RETURN ERROR "*** THIS API HAS BEEN DEPRECATED ***":U.    
END PROCEDURE.  /* serverRetrieveClassExtInfo */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateDeploymentType Include 
PROCEDURE updateDeploymentType :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     To set a new value of deployment type in an ryc_smartobject record
  Parameters:  pdobj            - obj number of the record
               pcDeploymentType - Value to be set
  Notes:  This is necessary because the AppBuilder calls InsertObjectMaster to
          create ryc_smartObject records, but the InsertObjectMaster API doesn't
          allow for the setting of the deployment_type field.    
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pdobj                AS DECIMAL    NO-UNDO.
 DEFINE INPUT  PARAMETER pcDeploymentType     AS CHARACTER  NO-UNDO.

  &IF DEFINED(Server-Side) EQ 0 &THEN    
  { dynlaunch.i &PLIP              = "'RepositoryDesignManager'"
                &iProc             = "'updateDeploymentType'"
               &mode1  = INPUT  &parm1  = pdObj                       &dataType1  = DECIMAL
               &mode2  = INPUT  &parm2  = pcDeploymentType            &dataType2  = CHARACTER
  }
  IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.   
  &ELSE   
  DEFINE BUFFER bryc_smartobject      FOR ryc_smartobject.
  /* First try and find the object that we are going to change */
  FIND bryc_smartobject EXCLUSIVE-LOCK 
    WHERE bryc_smartobject.smartobject_obj = pdObj NO-ERROR.
  IF NOT AVAILABLE(bryc_smartobject) THEN
    RETURN {aferrortxt.i 'RY' '01' '?' '?'}.

  bryc_smartobject.deployment_type = pcDeploymentType.

  &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDataFieldAttrs Include 
PROCEDURE validateDataFieldAttrs :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Private procedure to validate attribute values and 
               return invalid attributes and any errors 
  Parameters:  INPUT  pcDataFieldName AS CHARACTER
               OUTPUT pcInvalidAttrs  AS CHARACTER
               OUTPUT pcMessageList   AS CHARACTER
  Notes:       This is a private API that may change or be removed in
               the future.  It should not be used by application
               code, it should only be used by the framework.   
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcDataFieldName AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcInvalidAttrs  AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcMessageList   AS CHARACTER  NO-UNDO.

  RUN ry/app/rydesvaldfp.p (INPUT pcDataFieldName,
                            OUTPUT pcInvalidAttrs,
                            OUTPUT pcMessageList).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */
&IF DEFINED(EXCLUDE-updateInstanceSequence) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION updateInstanceSequence Procedure
FUNCTION updateInstanceSequence RETURNS LOGICAL 
	( input pdObjectInstanceObj as decimal,
	  input piSequence as integer ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
    Purpose:  Updates the object sequence field on an instance
    Notes:    * The order attribute will be deprecated, the rendering currently uses
                 object sequence for tab order but the order attribute is still maintained
                 and kept in sync with _U._TAB-ORDER by the AppBuilder.
              * Server-side/connected ICFDB only
              * This should only be used by adeuib/_gendyn.p
------------------------------------------------------------------------------*/
    define variable lOK as logical no-undo.
    
    &if defined(server-side) <> 0 &then 
    define buffer rycoi for ryc_object_instance.
    find rycoi where
         rycoi.object_instance_obj = pdObjectInstanceObj
         exclusive-lock no-wait no-error.
    if not available rycoi or locked rycoi then
        lOK = false.
    else
    do:
        rycoi.object_sequence = piSequence no-error.
        if return-value ne '':u or error-status:error then
            lOk = false.
        else
        do:
            validate rycoi no-error.
            if return-value ne '':u or error-status:error then
                lOk = false.
        end.    /* assignment passed */
    end.    /* found, locked rycoi */         
    &endif 
    
    return lOK.
END FUNCTION.    /* updateInstanceSequence */
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
&IF DEFINED(EXCLUDE-getObjectInstanceObj) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectInstanceObj Procedure
FUNCTION getObjectInstanceObj RETURNS DECIMAL 
	( input pdContainerObj as decimal,
	  input pcInstanceName as character ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
    Purpose: Returns the object ID of a ryc_object_instance record, if it exists.
    Notes:   * Used by adeuib/_gendyn.p
             * Only called from AppBuilder, ie ICFDB connected
------------------------------------------------------------------------------*/
    define variable dObjectInstanceObj as decimal no-undo.
    
    &IF DEFINED(Server-Side) <> 0 &THEN
    define buffer rycoi for ryc_object_instance.
    
    find rycoi where
         rycoi.container_smartobject_obj = pdContainerObj and
         rycoi.instance_name = pcInstanceName
         no-lock no-error.
    if available rycoi then
        dObjectInstanceObj = rycoi.object_instance_obj.
    &ENDIF 
    
    return dObjectInstanceObj.
END FUNCTION.    /* getObjectInstanceObj */
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
&IF DEFINED(EXCLUDE-cleanStoreAttributeValues) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cleanStoreAttributeValues Procedure
FUNCTION cleanStoreAttributeValues RETURNS LOGICAL 
	( INPUT pcObjectName                AS CHARACTER,
      INPUT pcClassName                 AS CHARACTER,
      INPUT pcCleanToLevel              AS CHARACTER,
      INPUT phStoreAttributeBuffer      AS HANDLE ):
/*------------------------------------------------------------------------------
  Purpose:  Cleans up the ttStoreAttribute TT
    Notes: * We need to compare default values set at the class and master object 
             level to ensure that we do not add attributes at instance level that
             will cause unnecessary duplication of values.
           * pcCleanToLevel - MASTER, CLASS: Master used when validating instances
                              and CLASS used when validating Masters.
           * pcClassName - only required when pcCleanToLevel is CLASS.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cAttributeName      AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hAttributeField     AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hObjectBuffer       AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer    AS HANDLE       NO-UNDO.
    DEFINE VARIABLE dInstanceId         AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE lDeleteRecord       AS LOGICAL      NO-UNDO.
    DEFINE VARIABLE cInheritClasses     AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cValue              AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE iValue              AS INTEGER      NO-UNDO.
    DEFINE VARIABLE dValue              AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE dtValue             AS DATE         NO-UNDO.
    DEFINE VARIABLE iDataType           AS INTEGER      NO-UNDO.
    
    /* Scope these buffers to this procedure. */    
    DEFINE BUFFER ttObject            FOR ttObject.
    DEFINE BUFFER ttObjectAttribute   FOR ttObjectAttribute.
    DEFINE BUFFER ttClassAttribute    FOR ttClassAttribute.
    
    IF NOT VALID-HANDLE(phStoreAttributeBuffer) THEN
        RETURN FALSE.
        
    /* Get the Master Object from the cache. Do this first since
       the class name is not passed in when cleaning to master level.
     */
    IF pcCleanToLevel EQ "MASTER":U THEN
    DO:
        RUN retrieveDesignObject IN target-procedure ( INPUT  pcObjectName,
                                                      INPUT  "",                        /* Get default result Codes */
                                                      OUTPUT TABLE ttObject,
                                                      OUTPUT TABLE ttPage,
                                                      OUTPUT TABLE ttLink,
                                                      OUTPUT TABLE ttUiEvent,
                                                      OUTPUT TABLE ttObjectAttribute ) NO-ERROR.
        FIND FIRST ttObject WHERE ttObject.tLogicalObjectName       = pcObjectName         
                             AND ttObject.tContainerSmartObjectObj = 0 NO-ERROR.
        IF AVAILABLE ttObject THEN
            ASSIGN pcClassName = ttObject.tClassName.
    END.    /* clean to master */
    
    /* At this stage there should always be a class specified. It will either
       be passed in as the parameter when the clean to level is CLASS, or it 
       will be derived from the ttObject record when cleaning to the MASTER level.       
       
       In either case, we cannot go any further without a class. This also serves
       as validation for the existence of the ttObject record, since the value of
       the class name will only be set if there is an existing ttObject record.
     */
    IF pcClassName EQ ? OR pcClassName EQ "":U THEN
        RETURN FALSE.     
     
    /* Get the class attributes */
    IF NOT CAN-FIND(FIRST ttClassAttribute WHERE ttClassAttribute.tClassname = pcClassName) THEN
       RUN retrieveDesignClass IN target-procedure
                               ( INPUT  pcClassName,
                                 OUTPUT cInheritClasses,
                                 OUTPUT TABLE ttClassAttribute,
                                 OUTPUT TABLE ttUiEvent,
                                 output table ttSupportedLink         ) NO-ERROR.                                   
               
    IF NOT VALID-HANDLE(ghQuery4) THEN
       CREATE QUERY ghQuery4.

    ghQuery4:SET-BUFFERS(phStoreAttributeBuffer).

     /* Use PRESELECT since we may delete some of the records in the TT. */
    ghQuery4:QUERY-PREPARE(" PRESELECT EACH ":U + phStoreAttributeBuffer:NAME).
    ghQuery4:QUERY-OPEN().
   
    ghQuery4:GET-FIRST().
    DO WHILE phStoreAttributeBuffer:AVAILABLE:
       ASSIGN cAttributeName = phStoreAttributeBuffer:BUFFER-FIELD("tAttributeLabel":U):BUFFER-VALUE
              lDeleteRecord  = NO
              iDataType      = 0
              cValue         = "":U.
       
       FIND ttClassAttribute WHERE ttClassAttribute.tClassname      = pcClassName
                               AND ttClassAttribute.tAttributelabel = cAttributeName NO-ERROR.
       IF AVAIL ttClassAttribute THEN
          ASSIGN cValue    = ttClassAttribute.tAttributeValue
                 iDataType = ttClassAttribute.tDataType.
       
       IF pcCleanToLevel EQ "MASTER":U THEN
       DO:
          FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                   AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj
                                   AND ttObjectAttribute.tAttributeLabel    = cAttributeName NO-ERROR.
          IF AVAIL ttObjectAttribute THEN
             ASSIGN cValue    = ttObjectAttribute.tAttributeValue
                    iDataType = ttObjectAttribute.tDataType.
       END.    /* clean to: MASTER */
       
       CASE iDataType:
           WHEN {&LOGICAL-DATA-TYPE} THEN
               ASSIGN lDeleteRecord = (LOGICAL(cValue) EQ phStoreAttributeBuffer:BUFFER-FIELD("tLogicalValue":U):BUFFER-VALUE).
           WHEN {&DATE-DATA-TYPE} THEN DO:
               ASSIGN dtValue = DATE(cValue) NO-ERROR.
               IF NOT ERROR-STATUS:ERROR THEN
                  ASSIGN lDeleteRecord = (dtValue EQ phStoreAttributeBuffer:BUFFER-FIELD("tDateValue":U):BUFFER-VALUE).
           END.
           WHEN {&INTEGER-DATA-TYPE} THEN DO:
               ASSIGN iValue = INTEGER(cValue) NO-ERROR.
               IF NOT ERROR-STATUS:ERROR THEN
                   lDeleteRecord = (iValue EQ phStoreAttributeBuffer:BUFFER-FIELD("tIntegerValue":U):BUFFER-VALUE).
           END.
           WHEN {&DECIMAL-DATA-TYPE} THEN DO:
               ASSIGN dValue = DECIMAL(cValue) NO-ERROR.
               IF NOT ERROR-STATUS:ERROR THEN
                 ASSIGN lDeleteRecord = (dValue EQ phStoreAttributeBuffer:BUFFER-FIELD("tDecimalValue":U):BUFFER-VALUE).
           END.
           OTHERWISE
               ASSIGN lDeleteRecord = (cValue EQ phStoreAttributeBuffer:BUFFER-FIELD("tCharacterValue":U):BUFFER-VALUE) NO-ERROR.
       END CASE.   /* data type */
       
       IF lDeleteRecord THEN
           phStoreAttributeBuffer:BUFFER-DELETE().
        
        ghQuery4:GET-NEXT().
    END.    /* available phStoreAttributeBuffer */
    ghQuery4:QUERY-CLOSE().
    
    RETURN TRUE.
END FUNCTION.   /* cleanStoreAttributeValues */
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
&IF DEFINED(EXCLUDE-customObjectExists) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION customObjectExists Procedure
FUNCTION customObjectExists RETURNS LOGICAL 
	( input pcObjectName as character,
	  input pcResultCode as character  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
    Purpose: Determines whether a customised version of an object exists
      Notes: This code should never check for the existence of an uncustomised
             object, since we can do that via objectExists. We need to know,
             in some circumstances in the AppBuilder, whether a custom object
             exists, and we already know that the object exists.
------------------------------------------------------------------------------*/
    define variable lObjectExists as logical no-undo.
    
    /* only used in AppBuilder session */
    &IF DEFINED(server-side) <> 0 &THEN
    DEFINE VARIABLE cRootFile               AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cRootFileExt            AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cObjectExt              AS CHARACTER                NO-UNDO.
    
    define buffer ryccr for ryc_customization_result.

    find ryccr where
         ryccr.customization_result_code = pcResultCode
         no-lock no-error.
    lObjectExists = available ryccr.
    
    if lObjectExists then
    do:
        lObjectExists = CAN-FIND(ryc_SmartObject WHERE
                                 ryc_SmartObject.object_Filename = pcObjectName and
                                 ryc_smartobject.customization_result_obj = ryccr.customization_result_obj).
        
        IF NOT lObjectExists THEN
        DO:
            /* Strip the name apart, and use the pices to find the object. */
            RUN extractRootFile IN gshRepositoryManager (INPUT pcObjectName, OUTPUT cRootFile, OUTPUT cRootFileExt) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN FALSE.
    
            /* Figure out what the extension is. */
            cObjectExt = TRIM(REPLACE(cRootFileExt, (cRootFile + ".":U), "":U)).
    
            /* If there is a root file with an extension, first try to find the object name using this.
	         * We perform this check only if the root filename differs from the pcObjectName. It
	         * shouldn't, but it is theoretically possible for the pcObjectName to contain a pathed
	         * filename.                                                                                  */
            IF cRootFileExt NE "":U AND pcObjectName NE cRootFileExt THEN
                lObjectExists = CAN-FIND(ryc_SmartObject WHERE
                                         ryc_SmartObject.object_Filename = cRootFileExt and
                                         ryc_smartobject.customization_result_obj = ryccr.customization_result_obj).
    
            IF NOT lObjectExists THEN
                lObjectExists = CAN-FIND(ryc_SmartObject WHERE
                                         ryc_SmartObject.object_Filename  = cRootFile AND
                                         ryc_smartObject.object_extension = cObjectExt and
                                         ryc_smartobject.customization_result_obj = ryccr.customization_result_obj).
        END.    /* filename doesn't match exactly. */
    end.    /* result code exists */
    &ENDIF 
    
    error-status:error = no.
    return lObjectExists.
END FUNCTION.    /* custom object exists */
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
&IF DEFINED(EXCLUDE-getObjectNameFromObj) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectNameFromObj Procedure
FUNCTION getObjectNameFromObj RETURNS CHARACTER 
	( input pdSmartObjectObj as decimal ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
    Purpose: Returns the objectfilename (plus any extension) for a given object id
    Notes:   - Server-side only code
------------------------------------------------------------------------------*/
    define variable cObjectFilename as character no-undo.
    
    &IF DEFINED(server-side) = 0 &THEN 
    define buffer rycso for ryc_smartobject.
    
    find rycso where
         rycso.smartobject_obj = pdSmartobjectObj
         no-lock no-error.
    if available rycso then
        cObjectFilename = rycso.object_filename 
                        + (if rycso.object_extension eq '':u then '':u else '.' + rycso.object_extension).
    &endif 
    
    error-status:error = no.
    return cObjectFilename.
END FUNCTION.    /* getObjectNameFromObj */
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataTypeCode) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataTypeCode Procedure
FUNCTION getDataTypeCode RETURNS integer
	( input pcDataTypeName as character ):
/*------------------------------------------------------------------------------
    Purpose: Returns the data type code/internal identifier from a named datatype
    Notes:
------------------------------------------------------------------------------*/
    define variable iDataTypeCode as integer no-undo.
    
    case pcDataTypeName:
        when 'Character' or when 'Char' then iDataTypeCode = {&CHARACTER-DATA-TYPE}.
        when 'Date' then iDataTypeCode = {&DATE-DATA-TYPE}.
        when 'Logical' or when 'Log' then iDataTypeCode = {&LOGICAL-DATA-TYPE}.
        when 'Integer' or when 'Int' then iDataTypeCode = {&INTEGER-DATA-TYPE}.
        when 'Decimal' or when 'Dec' then iDataTypeCode = {&DECIMAL-DATA-TYPE}.
        when 'Recid' then iDataTypeCode = {&RECID-DATA-TYPE}.
        when 'Raw' then iDataTypeCode = {&RAW-DATA-TYPE}.
        when 'Rowid' then iDataTypeCode = {&ROWID-DATA-TYPE}.
        when 'Handle' then iDataTypeCode = {&HANDLE-DATA-TYPE}.
        when 'Blob' then iDataTypeCode = {&BLOB-DATA-TYPE}.
        when 'Clob' then iDataTypeCode = {&CLOB-DATA-TYPE}.
        when 'Datetime' then iDataTypeCode = {&DATETIME-DATA-TYPE}.
        when 'Datetime-TZ' then iDataTypeCode = {&DATETIME-TZ-DATA-TYPE}.
        when 'Int64' then iDataTypeCode = {&INT64-DATA-TYPE}.
    end case.
    
    return iDataTypeCode.
END FUNCTION.    /* getDataTypeCode */
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildClassAttributes Include 
FUNCTION buildClassAttributes RETURNS LOGICAL
        ( input        pcClassName               as character,
          input        pdRetrieveClassObj        as decimal,
          input-output pcInheritsFromClasses     as character  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Retrieves attributes and ui events for a given class. Will typically
            be called recursively.
    Notes: * The pcClassName is the name of the class that was originally requested.
             This must always stay the same as we read up the heirarchy, so that 
             this function knows which table to add attributes to.
           * pdRetrieveClassObj contains the class whose attributes must be queried
             in this iteration of the function.
         * The ttUiEvent and ttClassAttribute temp-tables must be emptied (if
             required) by this function's caller, and not by this function, since
             this is a recursive function.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dParentClassObj             AS DECIMAL              NO-UNDO.
    define variable cCustomClassObj             as character            no-undo.
   
    DEFINE BUFFER gscot             FOR gsc_object_type.
    DEFINE buffer rycsl             for ryc_supported_link.
    define buffer ttClassAttribute  for ttClassAttribute.
    define buffer ttUiEvent         for ttUiEvent.
    
    if pdRetrieveClassObj eq 0 then    
      FIND FIRST gscot WHERE
                 gscot.object_type_code = pcClassName
                 NO-LOCK NO-ERROR.
    else
      FIND FIRST gscot WHERE
                 gscot.object_type_obj = pdRetrieveClassObj
                 NO-LOCK NO-ERROR.
                    
    IF NOT AVAILABLE gscot THEN
        return false.
    
    ASSIGN pcInheritsFromClasses = pcInheritsFromClasses + ",":U + gscot.object_type_code
           pcInheritsFromClasses = left-trim(pcInheritsFromClasses, ",":U).
    
    /* Is there a custom class?
       If so then retrieve those attributes.
     */
    if gscot.custom_object_type_obj <> 0 then
      dynamic-function("buildClassAttributes":U in target-procedure,
                       input        pcClassName,
                       input        gscot.custom_object_type_obj,
                       input-output pcInheritsFromClasses             ).
    
    /* Get the attributes */
    FOR EACH ryc_attribute_value WHERE
             ryc_attribute_value.object_type_obj     = gscot.object_type_obj AND
             ryc_attribute_value.smartObject_obj     = 0                     AND
             ryc_attribute_value.object_instance_obj = 0
             NO-LOCK,
       FIRST ryc_attribute WHERE
             ryc_attribute.attribute_label = ryc_attribute_value.attribute_label AND
             ryc_attribute.derived_value   = NO
             NO-LOCK:
        IF NOT CAN-FIND(FIRST ttClassAttribute WHERE
                              ttClassAttribute.tClassName      = pcClassName AND
                              ttClassAttribute.tAttributeLabel = ryc_attribute.attribute_label ) THEN
        DO:
            CREATE ttClassAttribute.
            ASSIGN ttClassAttribute.tClassName      = pcClassName
                   ttClassAttribute.tAttributeLabel = ryc_attribute.attribute_label
                   ttClassAttribute.tNarrative      = ryc_attribute.attribute_narrative
                   ttClassAttribute.tLookupType     = ryc_attribute.lookup_type
                   ttClassAttribute.tLookupValue    = ryc_attribute.lookup_value
                   ttClassAttribute.tDesignOnly     = ryc_attribute.design_only
                   ttClassAttribute.tRuntimeOnly    = ryc_attribute.runtime_only
                   ttClassAttribute.tDataType       = ryc_attribute.data_type
                   ttClassAttribute.tWhereConstant  = ryc_attribute.constant_level
                   ttClassAttribute.tWhereStored    = gscot.object_type_code.

            CASE ryc_attribute.data_type:
              WHEN {&CHARACTER-DATA-TYPE} THEN ASSIGN ttClassAttribute.tAttributeValue = ryc_attribute_value.character_value.
              WHEN {&LOGICAL-DATA-TYPE}   THEN ASSIGN ttClassAttribute.tAttributeValue = STRING(ryc_attribute_value.logical_value).
              WHEN {&INTEGER-DATA-TYPE}   THEN ASSIGN ttClassAttribute.tAttributeValue = STRING(ryc_attribute_value.integer_value).
              WHEN {&HANDLE-DATA-TYPE}    THEN ASSIGN ttClassAttribute.tAttributeValue = "?":U.
              WHEN {&DECIMAL-DATA-TYPE}   THEN ASSIGN ttClassAttribute.tAttributeValue = STRING(ryc_attribute_value.decimal_value).
              WHEN {&ROWID-DATA-TYPE}     THEN ASSIGN ttClassAttribute.tAttributeValue = ryc_attribute_value.character_value.
              WHEN {&RAW-DATA-TYPE}       THEN ASSIGN ttClassAttribute.tAttributeValue = STRING(ryc_attribute_value.raw_value).
              WHEN {&DATE-DATA-TYPE}      THEN ASSIGN ttClassAttribute.tAttributeValue = STRING(ryc_attribute_value.date_value).              
              WHEN {&RECID-DATA-TYPE}     THEN ASSIGN ttClassAttribute.tAttributeValue = STRING(IF ryc_attribute_value.integer_value = 0 THEN ? ELSE ryc_attribute_value.integer_value).
              OTHERWISE                        ASSIGN ttClassAttribute.tAttributeValue = ryc_attribute_value.character_value.
            END CASE.   /* DataType */

            FIND FIRST ryc_attribute_group WHERE
                       ryc_attribute_group.attribute_group_obj = ryc_attribute.attribute_group_obj
                       NO-LOCK NO-ERROR.
            IF AVAILABLE ryc_attribute_group THEN
                ASSIGN ttClassAttribute.tGroupName      = ryc_attribute_group.attribute_group_name
                       ttClassAttribute.tGroupNarrative = ryc_attribute_group.attribute_group_narrative.
        END.    /* n/a attribute record. */
    END.    /* all attributes for the class */

    /* Ui Events */
    FOR EACH ryc_ui_event WHERE
             ryc_ui_event.object_type_obj     = gscot.object_type_obj AND
             ryc_ui_event.smartObject_obj     = 0                     AND
             ryc_ui_event.object_instance_obj = 0
             NO-LOCK:
        IF NOT CAN-FIND(FIRST ttUiEvent WHERE
                              ttUiEvent.tClassName = pcClassName AND
                              ttUiEvent.tEventName = ryc_ui_event.event_name ) THEN
        DO:
            CREATE ttUiEvent.
            ASSIGN ttUiEvent.tSmartObjectObj    = 0
                   ttUiEvent.tObjectInstanceObj = 0
                   ttUiEvent.tClassName         = pcClassName
                   ttUiEvent.tEventName         = ryc_ui_event.event_name
                   ttUiEvent.tActionType        = ryc_ui_event.action_type
                   ttUiEvent.tActionTarget      = ryc_ui_event.action_target
                   ttUiEvent.tEventAction       = ryc_ui_event.event_action
                   ttUiEvent.tEventParameter    = ryc_ui_event.event_parameter
                   ttUiEvent.tEventDisabled     = ryc_ui_event.event_disabled
                   ttUiEvent.tWhereStored       = gscot.object_type_code.
        END.    /* n/a event record */
    END.    /* UI events */
    
    /* Get the supported links */
    for each ryc_supported_link where
             ryc_supported_link.object_type_obj = gscot.object_type_obj
             no-lock,
       first ryc_smartlink_type where
             ryc_smartlink_type.smartlink_type_obj = ryc_supported_link.smartlink_type_obj
             no-lock:
        
        if not can-find(first ttSupportedLink where
                              ttSupportedLink.ClassName = pcClassName and
                              ttSupportedLink.LinkName = ryc_smartlink_type.link_name ) then
        do:
           create ttSupportedLink.
           assign ttSupportedLink.ClassName        = pcClassName
                  ttSupportedLink.LinkName         = ryc_smartlink_type.link_name
                  ttSupportedLink.IsLinkSource     = ryc_supported_link.link_source
                  ttSupportedLink.IsLinkTarget     = ryc_supported_link.link_target
                  ttSupportedLink.DeactivateOnHide = ryc_supported_link.deactivated_link_on_hide
                  ttSupportedLink.WhereStored      = gscot.object_type_code.
        end.    /* n/a supported link. */
    end.    /* supported links */
    
    if gscot.extends_object_type_obj <> 0 then
      dynamic-function("buildClassAttributes":U in target-procedure,
                       input        pcClassName,
                       input        gscot.extends_object_type_obj,
                       input-output pcInheritsFromClasses             ).
    
    return true.
END FUNCTION.    /* buildClassAttributes */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cacheClassExtInfo Include 
FUNCTION cacheClassExtInfo RETURNS LOGICAL
    ( INPUT pcClassName     AS CHARACTER    ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  
    Notes:  
*** THIS API HAS BEEN DEPRECATED ***                     
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hClassBuffer        AS HANDLE                       NO-UNDO.
    
    MESSAGE "*** THIS API HAS BEEN DEPRECATED ***" VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN ?.
END FUNCTION.   /* cacheClassExtInfo */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION classHasAttribute Include 
FUNCTION classHasAttribute RETURNS LOGICAL
    ( INPUT pcClassName             AS CHARACTER,
      INPUT pcAttributeOrEventName  AS CHARACTER,
      INPUT plAttributeIsEvent      AS LOGICAL          ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Returns whether or not the specified attribute or event exists for 
            a class.
    Notes:  classHasAttribute API also exists in repository manager but that API 
            checks for runtime attributes only. Hence this API should be used
            in Tools where design time attributes need to be checked.
            
            NOTE: USE THIS API ONLY FOR DESIGN TIME - AT RUN TIME USE THE API IN
            REPOSITORY MANAGER. 
            
            Input - pcClassName - Name of the class.
                    pcAttributeOrEventName - Name of the attribute or event
                    plAttributeIsEvent - Is this a event.
------------------------------------------------------------------------------*/
  DEFINE BUFFER gsc_object_type      FOR gsc_object_type.
  DEFINE BUFFER gscot                FOR gsc_object_type.
  DEFINE BUFFER ryc_attribute_value  FOR ryc_attribute_value.
  DEFINE BUFFER ryc_attribute        FOR ryc_attribute.

  FIND FIRST gsc_object_type 
       WHERE gsc_object_type.object_type_code = pcClassName NO-LOCK NO-ERROR.

  /* If we can't find class, we can't find the attribute */
  IF NOT AVAILABLE gsc_object_type THEN
  DO:
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN FALSE.
  END.

  IF NOT plAttributeIsEvent THEN
  DO:
    /* If this is a attribute - check if attribute name can be found */
    FIND FIRST ryc_attribute_value 
         WHERE ryc_attribute_value.object_type_obj     = gsc_object_type.object_type_obj
           AND ryc_attribute_value.attribute_label     = pcAttributeOrEventName
           AND ryc_attribute_value.smartObject_obj     = 0
           AND ryc_attribute_value.object_instance_obj = 0 NO-LOCK NO-ERROR.

    /* If we find a attribute value record then we are all set and return true */
    IF AVAILABLE ryc_attribute_value THEN
    DO:
      ASSIGN ERROR-STATUS:ERROR = NO.
      RETURN TRUE.
    END.
  END.
  ELSE
  DO:
    /* If this is a event - check if event name can be found*/
    FIND FIRST ryc_ui_event 
         WHERE ryc_ui_event.object_type_obj     = gsc_object_type.object_type_obj 
           AND ryc_ui_event.event_name          = pcAttributeOrEventName
           AND ryc_ui_event.smartObject_obj     = 0                               
           AND ryc_ui_event.object_instance_obj = 0                               
           AND ryc_ui_event.event_disabled      = NO NO-LOCK NO-ERROR.

    /* If we find a event then we are all ser so return true */
    IF AVAILABLE ryc_ui_event THEN
    DO:
      ASSIGN ERROR-STATUS:ERROR = NO.
      RETURN TRUE.
    END.
  END.

  /* If there is a parent class, then go look in there */
  IF gsc_object_type.extends_object_type_obj NE 0 THEN
  DO:

    /* Find the parent class name from the obj */
    FIND FIRST gscot 
        WHERE gscot.object_type_obj = gsc_object_type.extends_object_type_obj 
    NO-LOCK NO-ERROR.

    /* If parent class is not found, we have some database problem so return FALSE */
    IF NOT AVAILABLE gscot THEN
    DO:
      ASSIGN ERROR-STATUS:ERROR = NO.
      RETURN FALSE.
    END.

    /* Call this function recursively for the parent */
    RETURN DYNAMIC-FUNCTION("classHasAttribute":U IN THIS-PROCEDURE, 
                            gscot.object_type_code, 
                            pcAttributeOrEventName, 
                            plAttributeIsEvent).
  END.

  ASSIGN ERROR-STATUS:ERROR = NO.
  RETURN FALSE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createClassCacheFile Include 
FUNCTION createClassCacheFile RETURNS LOGICAL PRIVATE
        ( input pcFilename         as character,
      input phClassBuffer      as handle         ):
/*------------------------------------------------------------------------------
  Purpose: Creates the actual class cache c_<Name>.p file 
        Notes:
------------------------------------------------------------------------------*/
    define variable hBuffer           as handle                       no-undo.    
    define variable cAttributeName    as character                    no-undo.
    define variable cDataType         as character                    no-undo.
    define variable cFormat           as character                    no-undo.
    define variable iExtent           as integer                      no-undo.
    define variable cInitialValue     as character                    no-undo    format 'x(200)':u.
    define variable iLoop             as integer                      no-undo.
    
    if not valid-handle(phClassBuffer) or 
       not phClassBuffer:type eq 'Buffer':U or
       not phClassBuffer:available then
        return false.
    
    /* Start the new class TT definition */
    OUTPUT TO VALUE(pcFilename). 
    PUT UNFORMATTED 
      "DEFINE OUTPUT PARAMETER pcClassName           AS CHARACTER NO-UNDO." SKIP
      "DEFINE OUTPUT PARAMETER pdClassObj            AS DECIMAL   NO-UNDO." SKIP
      "DEFINE OUTPUT PARAMETER pcClassTableName      AS CHARACTER NO-UNDO." SKIP
      "DEFINE OUTPUT PARAMETER phClass               AS HANDLE    NO-UNDO." SKIP
      "DEFINE OUTPUT PARAMETER pcInheritsFromClasses AS CHARACTER NO-UNDO." SKIP
      "DEFINE OUTPUT PARAMETER pcSuperProcedures     AS CHARACTER NO-UNDO." SKIP
      "DEFINE OUTPUT PARAMETER pcSuperProcedureModes AS CHARACTER NO-UNDO." SKIP
      "DEFINE OUTPUT PARAMETER pcEventTableName      AS CHARACTER NO-UNDO." SKIP
      "DEFINE OUTPUT PARAMETER phEvent               AS HANDLE    NO-UNDO." SKIP
      "DEFINE OUTPUT PARAMETER pcSetList             AS CHARACTER NO-UNDO." SKIP
      "DEFINE OUTPUT PARAMETER pcGetList             AS CHARACTER NO-UNDO." SKIP
      "DEFINE OUTPUT PARAMETER pcRuntimeList         AS CHARACTER NO-UNDO." SKIP(2)
      "ASSIGN pcClassName           = " quoter(phClassBuffer::ClassName) SKIP
      "       pdClassObj            = " phClassBuffer::ClassObj SKIP
      "       pcClassTableName      = " QUOTER(phClassBuffer::ClassTableName) SKIP
      "       pcInheritsFromClasses = " QUOTER(phClassBuffer::InheritsFromClasses) SKIP
      "       pcSuperProcedures     = " QUOTER(phClassBuffer::SuperProcedures) SKIP
      "       pcSuperProcedureModes = " QUOTER(phClassBuffer::SuperProcedureModes) SKIP
      "       pcEventTableName      = " QUOTER(phClassBuffer::EventTableName) SKIP
      "       pcSetList             = " QUOTER(phClassBuffer::SetList) SKIP
      "       pcGetList             = " QUOTER(phClassBuffer::GetList) SKIP
      "       pcRuntimeList         = " QUOTER(phClassBuffer::RuntimeList) "." SKIP(1)
      "CREATE TEMP-TABLE phClass." SKIP.
   
    /* For each httClass, go thru' each column and dump to a file */
    hBuffer = phClassBuffer::ClassBufferHandle.
    hBuffer:BUFFER-CREATE().
    DO iLoop = 1 TO hBuffer:NUM-FIELDS:
        /* output the class */
        ASSIGN cAttributeName = hBuffer:BUFFER-FIELD(iLoop):NAME 
               cDataType = hBuffer:BUFFER-FIELD(iLoop):DATA-TYPE 
               cFormat = hBuffer:BUFFER-FIELD(iLoop):FORMAT 
               iExtent = hBuffer:BUFFER-FIELD(iLoop):EXTENT
               cInitialValue = TRIM(hBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE).
        
        /* Deal with Today or now case */
        IF cDataType = "DATE" AND hBuffer:BUFFER-FIELD(iLoop):DEFAULT-STRING = "TODAY" THEN
            cInitialValue = "TODAY".
        ELSE
        IF (cDataType= "DATETIME" OR cDataType = "DATETIME-TZ" ) AND 
           hBuffer:BUFFER-FIELD(iLoop):DEFAULT-STRING  = "NOW" THEN
            cInitialValue   = "NOW".
        
        PUT UNFORMATTED "phClass:ADD-NEW-FIELD(" QUOTER(cAttributeName) "," 
                                                 QUOTER(cDataType) "," 
                                                 iExtent "," 
                                                 QUOTER(cFormat) "," 
                                                 QUOTER(cInitialValue) ")." SKIP.
    END.    /* loop through fields */
    hBuffer:buffer-delete().
    hBuffer:buffer-release().
    
    /* complete the TT definition */
    PUT UNFORMATTED "/* Add Indexes */" SKIP(1)
                    "phClass:ADD-NEW-INDEX('idxRecordID', FALSE, TRUE)." SKIP
                    "phClass:ADD-INDEX-FIELD('idxRecordID':U, 'InstanceId':U)." SKIP(1)
                    "/* ADM key used for each running instance */" SKIP(1)
                    "phClass:ADD-NEW-INDEX('idxTargetID', FALSE, FALSE)." SKIP
                    "phClass:ADD-INDEX-FIELD('idxTargetID':U, 'Target':U)." SKIP
                    "phClass:TEMP-TABLE-PREPARE('c_" phClassBuffer::ClassName "')." SKIP(1).
    
    /* Now if the event table is not ?, then we need to create a event table */
    hBuffer = phClassBuffer::EventBufferHandle.
    IF VALID-HANDLE(hBuffer) AND phClassBuffer::EventTableName > "":U THEN
    DO:
        PUT UNFORMATTED "CREATE TEMP-TABLE phEvent." SKIP.
        
        hBuffer:BUFFER-CREATE().
        DO iLoop = 1 TO hBuffer:NUM-FIELDS:
            /* output the events */
            ASSIGN cAttributeName = hBuffer:BUFFER-FIELD(iLoop):NAME 
                   cDataType = hBuffer:BUFFER-FIELD(iLoop):DATA-TYPE 
                   cFormat   = hBuffer:BUFFER-FIELD(iLoop):FORMAT 
                   iExtent   = hBuffer:BUFFER-FIELD(iLoop):EXTENT
                   cInitialValue = TRIM(hBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE).
            
            PUT UNFORMATTED "phEvent:ADD-NEW-FIELD(" QUOTER(cAttributeName) "," 
                                                     QUOTER(cDataType) "," 
                                                     iExtent "," 
                                                     QUOTER(cFormat) "," 
                                                     QUOTER(cInitialValue) ")." SKIP.
        END.    /* buffer field loop */
        hBuffer:buffer-delete().
        hBuffer:buffer-release().
        
        PUT UNFORMATTED "phEvent:TEMP-TABLE-PREPARE(pcEventTableName)." SKIP(1).
    END.    /* valid event table */
    ELSE
        PUT UNFORMATTED "ASSIGN phEvent = ?." SKIP(1).
        
    PUT UNFORMATTED "RETURN." SKIP(1).    
    OUTPUT CLOSE.
        
    error-status:error = no.
    return true.
END FUNCTION.    /* createClassCacheFile */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createRYObjectAB Include 
FUNCTION createRYObjectAB RETURNS LOGICAL
  ( pcObjectName AS CHAR,
    pcObjectString AS CHAR ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Creates the appBuilder required temp table record _RYObject 
            from a repository object
   Params:  pcObjectName   Name of repository object to be created
            pcObjectString String containing all information of repository
                           object. (CHR(3) delimited)
            plError        YES  Error occurred during temp table creation.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE plError AS LOGICAL    NO-UNDO.
    
  RUN adeuib/_ryobjectab.p  (INPUT pcObjectName,
                             INPUT pcObjectString,
                            OUTPUT plError).

  RETURN plError.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBufferDbName Include 
FUNCTION getBufferDbName RETURNS CHARACTER
    ( INPUT pcTableName         AS CHARACTER) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Returns the database name for a given table 
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
ACCESS_LEVEL=PRIVATE
  Purpose:  Returns the buffer handle of the class extended information table.
    Notes:  * If a class is specified, then this API attempts to reposition 
              the buffer to the first record spcified.
            * If the attribute nasme is specified, then this API attempts to
              reposition the dataset to that record.
*** THIS API HAS BEEN DEPRECATED ***              
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hCacheClassExtBuffer                AS HANDLE     NO-UNDO.
    
    MESSAGE "*** THIS API HAS BEEN DEPRECATED ***" VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
    RETURN ?.
END FUNCTION.   /* getCacheClassExtBuffer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentProductModule Include 
FUNCTION getCurrentProductModule RETURNS CHARACTER
  (/* parameter-definitions */) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataSourceClasses Include 
FUNCTION getDataSourceClasses RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Returns a comma delimited list of the class names that could be used
           as Data-Source in a data link.
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cValidObjectTypes AS CHARACTER   NO-UNDO.

DEFINE VARIABLE cClassesToRetrieve AS CHARACTER   NO-UNDO INITIAL "SBO,DataQuery":U.
DEFINE VARIABLE cQueryClasses      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDataClasses       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cQueryClass        AS CHARACTER   NO-UNDO.

DEFINE VARIABLE iCounter           AS INTEGER     NO-UNDO.
DEFINE VARIABLE iQueryCounter      AS INTEGER     NO-UNDO.
DEFINE VARIABLE iNotValid          AS INTEGER     NO-UNDO.

&IF DEFINED(server-side) = 0 &THEN
    {
     dynlaunch.i &PLIP      = 'RepositoryManager'
     &IProc                 = 'getDataSourceClasses'
     &mode1 = OUTPUT &parm1 = cValidObjectTypes &datatype1 = CHARACTER
    }
    IF RETURN-VALUE <> "":U THEN RETURN RETURN-VALUE.
&ELSE

    DO iCounter = 1 TO NUM-ENTRIES(cClassesToRetrieve).
        cValidObjectTypes = cValidObjectTypes + {fnarg getClassChildrenFromDB "ENTRY(iCounter, cClassesToRetrieve)" gshRepositoryManager} + ",".
    END.

    ASSIGN cValidObjectTypes = TRIM(cValidObjectTypes, ",").
   
    /* Get rid of the ADM classes themselves. */
    DO iCounter = 1 TO NUM-ENTRIES(cValidObjectTypes):
      CASE ENTRY(iCounter, cValidObjectTypes):
        WHEN "Query" THEN
        DO:
            /* query is below dataview and above data, 
               remove all extended objects that not are part of the data class */
            cQueryClasses = {fnarg getClassChildrenFromDB 'Query' gshRepositoryManager}.
            cDataClasses  = {fnarg getClassChildrenFromDB 'Data' gshRepositoryManager}.
              
            DO iQueryCounter = 1 TO NUM-ENTRIES(cQueryClasses):
               cQueryClass = ENTRY(iQueryCounter , cQueryClasses).
               IF LOOKUP(cQueryClass,cDataClasses) = 0 THEN
               DO:
                 iNotValid = LOOKUP(cQueryClass,cValidObjectTypes).
                 IF iNotValid > 0 THEN
                   ENTRY(iNotValid, cValidObjectTypes) = "":U.
               END.
            END.
        END.
        WHEN "DataQuery":U OR
        WHEN "DataView":U OR
        WHEN "Data":U     OR
        WHEN "Toolbar":U  OR
        WHEN "Panel":U    OR
        WHEN "Viewer"     OR
        WHEN "Browser":U THEN 
          ENTRY(iCounter, cValidObjectTypes) = "":U.
      END CASE.   /* obejct type */

    END. /*DO iCounter = 1 TO NUM-ENTRIES(cValidObjectTypes). Loop through valid object types */

    /* Clear off double commas left because of the replace */
    DO WHILE INDEX(cValidObjectTypes, ",,":U) <> 0:
        cValidObjectTypes = REPLACE(cValidObjectTypes, ",,":U, ",":U).
    END.

    /* Clear off any extra commas */
    ASSIGN cValidObjectTypes = TRIM(cValidObjectTypes, ",":U).

&ENDIF

RETURN cValidObjectTypes.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getIndexFields Include 
FUNCTION getIndexFields RETURNS CHARACTER
    ( INPUT pcTable AS CHARACTER) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
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
END FUNCTION.   /* getIndexFields */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getIndexFieldsUnique Include 
FUNCTION getIndexFieldsUnique RETURNS CHARACTER
  ( INPUT pcTable           AS CHARACTER ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
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
               cReturnFields     = "":U.   
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
            END.    /* loop through index information */
        END.    /* loop through indexes */
    END.    /* valid handle */

    DELETE OBJECT hKeyBuffer NO-ERROR.
    ASSIGN hKeyBuffer = ?.
         
    RETURN cReturnFields.
END FUNCTION.   /* getIndexFieldsUnique */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectTypeCodeFromDB Include 
FUNCTION getObjectTypeCodeFromDB RETURNS CHARACTER
  (pdObjectTypeObj AS DECIMAL) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
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
  IF RETURN-VALUE <> "":U THEN RETURN RETURN-VALUE.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getProductModuleList Include 
FUNCTION getProductModuleList RETURNS CHARACTER
 (pcValueField AS CHAR,
  pcDescFields AS CHAR,
  pcDescFormat AS CHAR,
  pcDelimiter  AS CHAR  ) :
/*------------------------------------------------------------------------------
  ACCESS_LEVEL=PUBLIC
  Purpose:  Returns a list-item-pairs list of Product Module information for use
            in Product Module combo-boxes. 
            
    Params: pcValueField   A field from the product_module table used as the value
                           field in the list-item-pairs
            pcDescFields   A comma delimited list of product module fields to display 
                           in the label portion of the list-item-pairs. This can be a 
                           maximum of 3 (three) fields               
            pcDescFormat   A base string containing substitution parameters of the 
                           form &n used to substitute the description fields
            pcDelimtier    A delimtier used to build the list-item-pairs. 
                           Default = CHR(3)               
       
   Syntax:  getProductModuleList(INPUT 'product_module_code',
                                 INPUT 'product_module_code,product_module_description,relative_path'
                                 INPUT "&1 // &2 (&3) "
                                 INPUT CHR(3) ).
            This returns a list-item-pairs such as:
                      "af-aaa // ICF Root Directory (af/aaa)|af-aaa..."
             
    Notes:  The Query String Filter Set for the session is used to show or not show 
            Repository Modules.
            
            This API replaces deprecated API productModuleList
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cProductModuleList AS CHARACTER  NO-UNDO.

  &IF DEFINED(server-side) = 0 &THEN
  {
   dynlaunch.i &PLIP              = 'RepositoryDesignManager'
               &IProc             = 'getProductModuleList'
               &mode1 = INPUT  &parm1 = pcValueField       &datatype1 = CHARACTER
               &mode2 = INPUT  &parm2 = pcDescFields       &datatype2 = CHARACTER
               &mode3 = INPUT  &parm3 = pcDescFormat       &datatype3 = CHARACTER
               &mode4 = INPUT  &parm4 = pcDelimiter        &datatype4 = CHARACTER
               &mode5 = OUTPUT &parm5 = cProductModuleList &datatype5 = CHARACTER
               
  }
  IF RETURN-VALUE <> "":U THEN RETURN RETURN-VALUE.
  &ELSE
    DEFINE VARIABLE hBuffer     AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cPMList     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cQuery      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hQuery      AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cDescField1 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cDescField2 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cDescField3 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cDescValue1 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cDescValue2 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cDescValue3 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cValueField AS CHARACTER  NO-UNDO.

    IF NUM-ENTRIES(pcDescFields) >= 3 THEN
        ASSIGN cDescField1 = ENTRY(1,pcDescFields)
               cDescField2 = ENTRY(2,pcDescFields)
               cDescField3 = ENTRY(3,pcDescFields) NO-ERROR.
    ELSE IF NUM-ENTRIES(pcDescFields) = 2 THEN
        ASSIGN cDescField1 = ENTRY(1,pcDescFields)
               cDescField2 = ENTRY(2,pcDescFields) NO-ERROR.
    ELSE 
        ASSIGN cDescField1 = ENTRY(1,pcDescFields) NO-ERROR.
    ASSIGN pcDescFormat = IF pcDescFormat = ? OR pcDescFormat = "" THEN "&1":U ELSE pcDescFormat
           pcDelimiter  = IF pcDelimiter = "" OR pcDelimiter = ? THEN CHR(3) ELSE pcDelimiter
           NO-ERROR.
    cQuery = "FOR EACH gsc_product_module NO-LOCK WHERE [&FilterSet=|&EntityList=GSCPM] BY gsc_product_module.product_module_code":U.

    RUN processQueryStringFilterSets IN gshGenManager (INPUT  cQuery, OUTPUT cQuery).
    
    ASSIGN hBuffer = BUFFER gsc_product_module:HANDLE.

    CREATE QUERY hQuery.
    hQuery:SET-BUFFERS(hBuffer).
    hQuery:QUERY-PREPARE(cQuery).
    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST(NO-LOCK).
    DO WHILE hBuffer:AVAILABLE:
      ASSIGN cValueField = hBuffer:BUFFER-FIELD(pcValueField):BUFFER-VALUE
             cDescValue1 = hBuffer:BUFFER-FIELD(cDescField1):BUFFER-VALUE
             cDescValue2 = hBuffer:BUFFER-FIELD(cDescField2):BUFFER-VALUE
             cDescValue3 = hBuffer:BUFFER-FIELD(cDescField3):BUFFER-VALUE
             NO-ERROR.
      /* Replace any ? with blanks to prevent string from being corrupted */
      ASSIGN cValueField = IF cValueField = ? THEN "" ELSE cValueField
             cDescValue1 = IF cDescValue1 = ? THEN "" ELSE cDescValue1
             cDescValue2 = IF cDescValue2 = ? THEN "" ELSE cDescValue2
             cDescValue3 = IF cDescValue3 = ? THEN "" ELSE cDescValue3
             NO-ERROR.
    
      cPMList = cPMList + (IF cPMList EQ "":U THEN "":U ELSE pcDelimiter)
                       + SUBSTITUTE(pcDescFormat, cDescValue1 , cDescValue2, cDescValue3) 
                       + pcDelimiter + cValueField NO-ERROR.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQualifiedTableName Include 
FUNCTION getQualifiedTableName RETURNS CHARACTER
    ( INPUT pcDbName        AS CHARACTER,
      INPUT pcTableName     AS CHARACTER ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Returns a table name. If the default rule is to qualify the table
            name then the dbname will be pre-pended.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE rRowid                  AS ROWID                    NO-UNDO.
    DEFINE VARIABLE cProfileData            AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE hAppBuilderFunctionLib  AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE lProfileValue           AS LOGICAL                  NO-UNDO.

    IF glSuppressDbName EQ ? THEN
    DO:
        /* First get the value from the Appbuilder, if available */
        ASSIGN hAppBuilderFunctionLib = SESSION:FIRST-PROCEDURE.
        DO WHILE VALID-HANDLE(hAppBuilderFunctionLib):
            IF hAppBuilderFunctionLib:FILE-NAME EQ "adeuib/_abfuncs.w":U THEN
                LEAVE.
            ASSIGN hAppBuilderFunctionLib = hAppBuilderFunctionLib:NEXT-SIBLING.
        END.  /* proceduretry walk. */

        /* Check for a valid handle and the correct name, because 
         * if the AB is not running, the handle will still be valid. */
        IF VALID-HANDLE(hAppBuilderFunctionLib)                      AND
           hAppBuilderFunctionLib:FILE-NAME EQ "adeuib/_abfuncs.w":U THEN
            ASSIGN glSuppressDbName = DYNAMIC-FUNCTION("getSuppressDbname":U IN hAppBuilderFunctionLib).
        
        /* Then use a user profile value if necessary. */
        ASSIGN rRowID = ?.

        /* Get profile data for the Save in combo-box list */
        RUN getProfileData IN gshProfileManager ( INPUT        "General":U,
                                                  INPUT        "Preference":U,
                                                  INPUT        "SuppressDbName":U,
                                                  INPUT        NO,
                                                  INPUT-OUTPUT rRowid,
                                                        OUTPUT cProfileData).
        ASSIGN lProfileValue = LOGICAL(cProfileData) NO-ERROR.

        /* If there is no profile value then use AB value. */
        IF lProfileValue NE ? THEN
            ASSIGN glSuppressDbName = lProfileValue.

        /* Default to NO */
        IF glSuppressDbName EQ ? THEN
            ASSIGN glSuppressDbName = YES.
    END.    /* glSuppressDbName not yet set */

    /** Add a DB qualifier if the database is not a temp-table DB (temp-db) or 
     *  if the user preference is set to such.
     *  ----------------------------------------------------------------------- **/
    IF NOT glSuppressDbName AND NOT CAN-DO("TEMP-DB":U, pcDbName) THEN
        ASSIGN pcTableName = pcDbName + ".":U + pcTableName.

    RETURN pcTableName.
END FUNCTION.   /* getQualifiedTableName */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getResultCodeObj Include 
FUNCTION getResultCodeObj RETURNS DECIMAL
    ( INPUT pcResultCode            AS CHARACTER ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Resolves a result code into an _OBJ value.
    Notes:  * This function will only work with a connected ICFDB.
            * This API is PRIVATE.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dContainerResultObj         AS DECIMAL              NO-UNDO.

    &IF DEFINED(Server-Side) NE 0 &THEN    
    DEFINE BUFFER ryc_customization_result      FOR ryc_customization_result.

    IF pcResultCode EQ "":U THEN
        ASSIGN pcResultCode = "{&DEFAULT-RESULT-CODE}":U.

    IF pcResultCode NE "{&DEFAULT-RESULT-CODE}":U AND pcResultCode NE "{&ALL-RESULT-CODE}":U THEN
    DO:
        FIND FIRST ryc_customization_result WHERE
                   ryc_customization_result.customization_result_code = pcResultCode
                   NO-LOCK NO-ERROR.
        IF AVAILABLE ryc_customization_result THEN
            ASSIGN dContainerResultObj = ryc_customization_result.customization_result_obj.
        ELSE
            ASSIGN dContainerResultObj = ?.
    END.    /* find the result code */
    ELSE
        ASSIGN dContainerResultObj = 0.
    &ENDIF
    
    RETURN dContainerResultObj.
END FUNCTION.   /* getResultCodeObj */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSchemaQueryHandle Include 
FUNCTION getSchemaQueryHandle RETURNS HANDLE
    ( INPUT  pcDatabaseName         AS CHARACTER,
      INPUT  pcTableNames            AS CHARACTER,
      OUTPUT pcWidgetPoolName       AS CHARACTER    ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSmartObjectObj Include 
FUNCTION getSmartObjectObj RETURNS DECIMAL
    ( INPUT pcObjectName                AS CHARACTER,
      INPUT pdCustmisationResultObj     AS DECIMAL      ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
Purpose:  Returns the object ID of an associated smartObject, given a 
            object name.
    Notes:  * This function's code has been moved into the Repository Manager
              since the object retrieval process needs this functionality too.
              There is no requirement for the RDM to exist in a runtime environment,
              so the code needs to be in the Repository Manager.
------------------------------------------------------------------------------*/
    RETURN DYNAMIC-FUNCTION("getSmartObjectObj":U IN gshRepositoryManager,
                            INPUT pcObjectName, INPUT pdCustmisationResultObj).
END FUNCTION.   /* getSmartObjectObj */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWidgetSizeFromFormat Include 
FUNCTION getWidgetSizeFromFormat RETURNS DECIMAL
    ( INPUT  pcFormatMask       AS CHARACTER,
      INPUT  pcUnit             AS CHARACTER,
      OUTPUT pdHeight           AS DECIMAL      ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
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
    (INPUT pcObjectName         AS CHARACTER) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Given an object name, return whether it exists in the repository
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lObjectExists       AS LOGICAL                      NO-UNDO.
    
    &IF DEFINED(server-side) = 0 &THEN
    {dynlaunch.i
        &PLIP  = 'RepositoryDesignManager'
        &IProc = 'ObjectExists'
        &mode1 = INPUT  &parm1 = pcObjectName  &datatype1 = CHARACTER
        &mode2 = OUTPUT &parm2 = lObjectExists &datatype2 = LOGICAL
    }
    IF RETURN-VALUE <> "":U THEN RETURN FALSE.
    &ELSE 
    DEFINE VARIABLE cRootFile               AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cRootFileExt            AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cObjectExt              AS CHARACTER                NO-UNDO.

    ASSIGN lObjectExists = CAN-FIND(FIRST ryc_SmartObject WHERE ryc_SmartObject.object_Filename = pcObjectName).

    IF NOT lObjectExists THEN
    DO:
        /* Strip the name apart, and use the pices to find the object. */
        RUN extractRootFile IN gshRepositoryManager (INPUT pcObjectName, OUTPUT cRootFile, OUTPUT cRootFileExt) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN FALSE.

        /* Figure out what the extension is. */
        ASSIGN cObjectExt = TRIM(REPLACE(cRootFileExt, (cRootFile + ".":U), "":U)).

        /* If there is a root file with an extension, first try to find the object name using this.
         * We perform this check only if the root filename differs from the pcObjectName. It
         * shouldn't, but it is theoretically possible for the pcObjectName to contain a pathed
         * filename.                                                                                  */
        IF cRootFileExt NE "":U AND pcObjectName NE cRootFileExt THEN
            ASSIGN lObjectExists = CAN-FIND(FIRST ryc_SmartObject WHERE ryc_SmartObject.object_Filename = cRootFileExt).

        IF NOT lObjectExists THEN
            ASSIGN lObjectExists = CAN-FIND(FIRST ryc_SmartObject WHERE
                                                  ryc_SmartObject.object_Filename  = cRootFile AND
                                                  ryc_smartObject.object_extension = cObjectExt     ).
    END.    /* filename doesn't match exactly. */
    &ENDIF
             
    RETURN lObjectExists.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION openRyObjectAB Include 
FUNCTION openRyObjectAB RETURNS LOGICAL
  ( INPUT pcObjectName AS CHARACTER ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Validates the specified object name 
            and creates an "OPEN" _RyObject record for the AppBuilder to use in
            opening a repository object for editing.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lError          AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE dSmartObjectObj AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE cColValues      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cQuery          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lObjectFound    AS LOGICAL    NO-UNDO.
  
  /* Validate that specified object name (for a default object) exists in repository 
     and returns object's Object_ID */
  /* If object name is the fullpathname, try the un-pathed name */
  ASSIGN pcObjectName = REPLACE(pcObjectName,"~\":U,"/":U)
         pcObjectName = ENTRY(NUM-ENTRIES(pcObjectName,"/":U),pcObjectName,"/":U).

  dSmartObjectObj = {fnarg getSmartObjectObj "pcObjectName, 0.00"}.

  


  IF dSmartObjectObj = 0 THEN
     RETURN FALSE.

  cQuery = "FOR EACH ryc_smartobject NO-LOCK":U
           + "  WHERE ryc_smartobject.smartobject_obj = ":U + QUOTER(dSmartObjectObj) + ",":U
           + "  FIRST gsc_object_type NO-LOCK":U
           + "  WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj" + ",":U
           + "  FIRST gsc_product_module NO-LOCK":U 
           + "  WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj INDEXED-REPOSITION":U.

  RUN getRecordDetail IN gshGenManager (INPUT cQuery,OUTPUT cColValues) NO-ERROR.

  IF cColValues > "" THEN
     RUN adeuib/_ryobjectab.p (INPUT pcObjectname,
                               INPUT cColValues,
                              OUTPUT lError).
  ELSE
     lError = TRUE.

  ASSIGN lObjectFound = NOT lError.

  RETURN lObjectFound.

    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION prepareObjectName Include 
FUNCTION prepareObjectName RETURNS CHARACTER
  ( INPUT pcObjectName   AS CHAR,  INPUT pcResultCode AS CHAR ,
    INPUT pcObjectString AS CHAR,  INPUT pcAction     AS CHAR, 
    INPUT pcObjectType   AS CHAR,  INPUT pcEntityName AS CHAR, 
    INPUT pcProductModule AS CHAR, OUTPUT pcNewObjectName AS CHAR,
    OUTPUT pcNewObjectExt AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  This public API can be used to enforce naming standards when creating
             a new dynamic object and writing it to the repository. All saves will
             pass through this API. Users can create their own customized version of 
             this API using the prescribed method of customizeing managers.
   Parameters:  
     INPUT  pcObjectName AS CHARACTER (Required if pcAction='Save')
               The suggested base name of the object.  
     INPUT  pcResultCode AS CHARACTER 
               The resultCode for a customized object          
     INPUT  pcObjectString AS CHARACTER 
               An optional string that can be used to pass additional info. (For future use)
     INPUT  pcAction      AS CHARACTER (Required)
            Indicates the type of action being requested.
              'SAVE' Specifies the object name is being saved to the repository.
              'DEFAULT' Specifies that a default object name is requested
     INPUT  pcObjectType  AS CHAR AS CHARACTER  (Required)
               Specifies the object type being saved
     INPUT  pcEntityName AS CHARACTER (Required if pcAction='Default')
               Specifies the entity mnemonic associated with the object
     INPUT  pcProductModule AS CHARACTER (Required if pcAction='Save')
               Specifies the product module for the object 
     OUTPUT pcNewObjectName AS CHARACTER (Required)
               Returns the new Object Name.  This field must be unique, non-blank and not null.
     OUTPUT pcNewObjectExt AS CHARACTER
               Returns the extension if required.       

   Returns:  CHARACTER
   Return Value:  An error message that gets passed back to the client.
         
    Notes: This API is called from procedure InsertObjectMaster using the pcAction='Save',
          in the ObjectGenerator (af\app\afgengenob.i) using pcAction = 'Default' and from
          the appBuilder save dialog using pcAction = 'Default'
------------------------------------------------------------------------------*/
    define variable cError             as character                    no-undo.
    
    &IF DEFINED(server-side) = 0 &THEN
    { dynlaunch.i
       &PLIP              = 'RepositoryDesignManager'
       &IProc             = 'prepareObjectName'
       &mode1  = INPUT  &parm1  = pcObjectName              &dataType1  = CHARACTER
       &mode2  = INPUT  &parm2  = pcResultCode              &dataType2  = CHARACTER
       &mode3  = INPUT  &parm3  = pcObjectString            &dataType3  = CHARACTER
       &mode4  = INPUT  &parm4  = pcAction                  &dataType4  = CHARACTER
       &mode5  = INPUT  &parm5  = pcObjectType              &dataType5  = CHARACTER
       &mode6  = INPUT  &parm6  = pcEntityName              &dataType6  = CHARACTER
       &mode7  = INPUT  &parm7  = pcProductModule           &dataType7  = CHARACTER
       &mode8  = OUTPUT &parm8  = pcNewObjectName           &datatype8  = CHARACTER
       &mode9  = OUTPUT &parm9  = pcNewObjectExt            &datatype9  = CHARACTER
    }
    IF RETURN-VALUE <> "":U THEN RETURN RETURN-VALUE.
    &ELSE 
    define variable cObjectFileNameWithExt             as character                    no-undo.
    define variable iLoop as integer no-undo.
    define variable iPos as integer no-undo.
    
    /** Default the return values to something usable.
     *  ----------------------------------------------------------------------- **/
    ASSIGN pcNewObjectName = ""
           pcNewObjectExt  = "":U
           cError          = "":U.
    
    if pcAction eq "Save":U then
    do:
        /* Object name should be specidifed */
        if pcObjectName eq "":U or pcObjectName eq ? then
        do:
            assign cError = {aferrortxt.i 'AF' '5' '?' '?' '"object name"'}.
            leave.
        end.    /* no name specified. */
        
        /* Object type should be specidifed */
        if pcObjectType eq "":U or pcObjectType eq ? then
        do:
            assign cError = {aferrortxt.i 'AF' '5' '?' '?' '"object type"'}.
            leave.
        end.    /* no type specified. */
                    
        /** Dynamic standard rules:
          ------------------------
          If the object inherits from the BASE,PROCEDURE or DLPROC class,
          then it is a candidate for having an extension stored in the 
          extension field. This is because these are 'proper' objects that
          can be launched or run. They will typically be either code that
          can be compiled into r-code objects, or be dynamic objects that
          are rendered using another procedure.
      
          Objects belonging to other classes will have their names saved 'as-is',
          ie whatever is passed in gets returned.
         **/
        if can-do(gcCLASS-USES-EXTENSION, pcObjectType) then
        do:
            /* Split the name into its component parts. */
            run extractRootFile in gshRepositoryManager ( input  pcObjectName,
                                                          output pcNewObjectName,
                                                          output cObjectFileNameWithExt ).
            /* and determine the */
            assign pcNewObjectExt = replace(cObjectFileNameWithExt, (pcNewObjectName + ".":U), "":U).             
        end.    /* is allowed an extension */
        else
            assign pcNewObjectName = pcObjectName
                   pcNewObjectExt  = "":U.
                    
        /* Naming syntax rules:
            - no invalid character in object names */
        &scoped-define INVALID-CHAR-LIST ),<,>,~",~~',=,?,|,:,/,!,@,^,+,*, ,(,\
    
        /*  - no commas or tildes in object names */
        iPos = index(pcNewObjectName, ',').
        if iPos eq 0 then
            iPos = index(pcNewObjectName, '~~').
        
        iLoop = 1.
        do while iPos eq 0 and iLoop le num-entries('{&INVALID-CHAR-LIST}':u):
            iPos = index(pcNewObjectName, entry(iLoop, '{&INVALID-CHAR-LIST}':u)).
            iLoop = iLoop + 1.            
        end.
        if iPos ne 0 then
            cError = {aferrortxt.i 'AF' '5' '?' '?' '"object name"' '"The object name specified contains at least one invalid character"'}.
        iLoop = iLoop + 1.            
    end.    /* SAVE */
    &ENDIF
    
    error-status:error = no.    
    return cError.
END FUNCTION.   /* prepareObjectName */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION productModuleList Include 
FUNCTION productModuleList RETURNS CHARACTER
  (/* parameter-definitions */) :
/*------------------------------------------------------------------------------
  Purpose:  Returns list of Product Module Codes and their Descriptions for use
            in Product Module combo-boxes. IZ 3195.
    Notes:  String returned is a comma-delimited list of code/description items
            of the form " pm_code // pm_description". The Query String Filter Set
            for the session to show or not show Repository Modules is automatically
            applied.
            
            This API is slated for deprecation. Please use getproductModuleList 
            instead.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cProductModuleListPairs AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cProductModuleList      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i                       AS INTEGER   NO-UNDO.
  
  cProductModuleListPairs = DYNAMIC-FUNCTION("getproductModuleList":U IN TARGET-PROCEDURE,
                                             INPUT "product_module_Code":U,
                                             INPUT "product_module_code,product_module_description":U,
                                             INPUT "&1 // &2":U,
                                             INPUT CHR(3))   NO-ERROR.
  
  /* Strip out the value string from the list-item-pair string to return a list-item string */
  DO i = 1 TO NUM-ENTRIES(cProductModuleList,CHR(3)) BY 2:
     cProductModuleList = cProductModuleList + (IF cProductModuleList = "" THEN "" ELSE ",")
                             +  ENTRY(i,cProductModuleList,CHR(3)).
  END.
  RETURN cProductModuleList.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCurrentProductModule Include 
FUNCTION setCurrentProductModule RETURNS LOGICAL
  ( INPUT cProductModule AS CHARACTER) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQualifiedTableName Include 
FUNCTION setQualifiedTableName RETURNS LOGICAL
    ( INPUT plSuppressDbName         AS LOGICAL  ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Sets the flag that indicates whether tables should be qualified
            with the logical database name or not.
    Notes:  
------------------------------------------------------------------------------*/
    ASSIGN glSuppressDbName = plSuppressDbName.

    /* Store as a profile setting. */
    RUN setProfileData IN gshProfileManager (INPUT "General":U,                 /* Profile type code */
                                             INPUT "Preference":U,              /* Profile code */
                                             INPUT "SuppressDbName":U,          /* Profile data key */
                                             INPUT ?,                           /* Rowid of profile data */
                                             INPUT STRING(plSuppressDbName),    /* Profile data value */
                                             INPUT NO,                          /* Delete flag */
                                             INPUT "PER":U).                    /* Save flag (permanent) */

    RETURN TRUE.
END FUNCTION.   /* setQualifiedTableName */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

