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
  File: fixobjecthierarchy.p

  Description:  Converts object hierarchy from V1 to V2

  Purpose:      Converts object hierarchy from V1 to V2

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   10/11/2002  Author:     Bruce S Gruenbaum

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       fixobjecthierarchy.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

DEFINE VARIABLE gcOTSuffix AS CHARACTER  NO-UNDO.


/* object identifying preprocessor */
&glob   AstraProcedure    yes

/* ttObjectType contains a list of object types with the handle to the 
   corresponding temp-table */
DEFINE TEMP-TABLE ttObjectType NO-UNDO
  FIELD oObjectTypeObj     AS DECIMAL DECIMALS 9
  FIELD cObjectTypeCode    AS CHARACTER
  FIELD hObjectTypeTable   AS HANDLE
  INDEX pudx IS PRIMARY UNIQUE
    oObjectTypeObj
  INDEX udx IS UNIQUE
    cObjectTypeCode
.

/* ttV2Object contains a list of the objects that exist in V2 */
DEFINE TEMP-TABLE ttV2Object NO-UNDO
  FIELD cObjectTypeCode    AS CHARACTER
  INDEX pudx IS PRIMARY UNIQUE
    cObjectTypeCode
.


/* ttObjectAttr contains a list of all the attributes that have to be added
   to an object type to extend it. */
DEFINE TEMP-TABLE ttObjectAttr NO-UNDO
  FIELD cObjectTypeCode    AS CHARACTER FORMAT "X(28)":U  LABEL "Object Code":U
  FIELD cAttributeLabel    AS CHARACTER FORMAT "X(32)":U  LABEL "Attribute Label":U
  FIELD lExistsV1          AS LOGICAL   FORMAT "Y/N":U    LABEL "V1":U
  FIELD lExistsV2          AS LOGICAL   FORMAT "Y/N":U    LABEL "V2":U
  FIELD cV1Derived         AS CHARACTER FORMAT "X(28)":U  LABEL "Derived V1":U
  FIELD cV2Derived         AS CHARACTER FORMAT "X(28)":U  LABEL "Derived V2":U
  FIELD cV2Attrib          AS CHARACTER FORMAT "X(28)":U  LABEL "V2 Attribute":U
  FIELD cV1Value           AS CHARACTER FORMAT "X(70)":U  LABEL "V1 Value":U
  FIELD cV2Value           AS CHARACTER FORMAT "X(70)":U  LABEL "V2 Value":U
  INDEX pudx IS PRIMARY UNIQUE
    cObjectTypeCode
    cAttributeLabel
.

/* ttExtendedObjectType contains a list of object types that extend the existing
   object types as a result of this program. */
DEFINE TEMP-TABLE ttExtendedObjectType NO-UNDO
  FIELD cObjectTypeCode        AS CHARACTER
  FIELD hObjectTypeTable       AS HANDLE
  FIELD oExtendsObjectTypeObj  AS DECIMAL DECIMALS 9
  FIELD oObjectTypeObj         AS DECIMAL DECIMALS 9  
  INDEX pudx IS PRIMARY UNIQUE
    cObjectTypeCode
  INDEX udxExtendsOTObj IS UNIQUE
    oExtendsObjectTypeObj
  INDEX dxOTObj 
    oObjectTypeObj
.

/* ttAttrDefault contains a list of all the attributes that have to be added
   to an object type to extend it. */
DEFINE TEMP-TABLE ttAttrDefault NO-UNDO
  FIELD cObjectTypeCode    AS CHARACTER
  FIELD cAttributeLabel    AS CHARACTER
  FIELD constant_value     LIKE ryc_attribute_value.constant_value
  FIELD character_value    LIKE ryc_attribute_value.character_value
  FIELD logical_value      LIKE ryc_attribute_value.logical_value
  FIELD integer_value      LIKE ryc_attribute_value.integer_value
  FIELD date_value         LIKE ryc_attribute_value.date_value
  FIELD decimal_value      LIKE ryc_attribute_value.decimal_value
  FIELD raw_value          LIKE ryc_attribute_value.raw_value
  INDEX pudx IS PRIMARY UNIQUE
    cObjectTypeCode
    cAttributeLabel
.

/* ttExtendedObjectAttr contains a list of all the attributes that have to be added
   to an object type to extend it. */
DEFINE TEMP-TABLE ttExtendedObjectAttr NO-UNDO
  FIELD oObjectTypeObj     AS DECIMAL DECIMALS 9
  FIELD cAttributeLabel    AS CHARACTER
  FIELD constant_value     LIKE ryc_attribute_value.constant_value
  FIELD character_value    LIKE ryc_attribute_value.character_value
  FIELD logical_value      LIKE ryc_attribute_value.logical_value
  FIELD integer_value      LIKE ryc_attribute_value.integer_value
  FIELD date_value         LIKE ryc_attribute_value.date_value
  FIELD decimal_value      LIKE ryc_attribute_value.decimal_value
  FIELD raw_value          LIKE ryc_attribute_value.raw_value
  INDEX pudx IS PRIMARY UNIQUE
    oObjectTypeObj
    cAttributeLabel
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

&IF DEFINED(EXCLUDE-getNextObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNextObj Procedure 
FUNCTION getNextObj RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSiteNumber) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSiteNumber Procedure 
FUNCTION getSiteNumber RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

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
         HEIGHT             = 27.81
         WIDTH              = 53.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* First load attributes from temp file and clean up */
RUN loadStoredAttributes.

/* Now load the list of objects that exist in V2 */
RUN loadV2ObjectList.

/* Next get rid of all the attributes on the existing object types, masters
   and instances that are no longer used in V2. */
RUN removeOldAttributes.

/* Now build up the object type temp-tables for all the object types in the 
   repository */
RUN buildObjectTypeCache("*":U).

/* Now run through all ryc_smartobjects in the repository and make sure that 
   if they have attributes added that are not in the object type, we know
   about them. */
RUN determineObjectTypeExtensions.

/* We're done with the dynamic temp-tables. Delete them. */
RUN deleteTables.

/* Now clean up the data that we have in the temp-tables */
RUN normalizeData.

/* Next we need to create the new object types in the repository. */
RUN createExtendedObjectTypes.

/* Now go through the objects and object instances and change the object types for these */
RUN changeObjectTypes.

/* Now rebuild the object cache with all the newly created object types */
RUN buildObjectTypeCache("*":U).

/* Clean up the data in the repository */
RUN cleanupAttributeValues.

/* We're done with the dynamic temp-tables. Delete them. */
RUN deleteTables.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addObjectTypeExtension) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addObjectTypeExtension Procedure 
PROCEDURE addObjectTypeExtension :
/*------------------------------------------------------------------------------
  Purpose:     This procedure makes sure that we have data in the temp-tables
               for the object type extension that we are doing.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER poObjectTypeObj     AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcObjectTypeCode    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcObjectFileName    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcAttrLabel         AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plDerive            AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER phBuffer            AS HANDLE     NO-UNDO.

  DEFINE BUFFER bttExtendedObjectType FOR ttExtendedObjectType.
  DEFINE BUFFER bttExtendedObjectAttr FOR ttExtendedObjectAttr.

  DEFINE VARIABLE hBuffer             AS HANDLE     NO-UNDO.

  hBuffer = BUFFER bttExtendedObjectAttr:HANDLE.

  /* First see if we have a record in ttExtendedObjectType. If not, create it. */
  FIND bttExtendedObjectType 
    WHERE bttExtendedObjectType.oExtendsObjectTypeObj = poObjectTypeObj
    NO-ERROR.
  IF NOT AVAILABLE(bttExtendedObjectType) THEN
  DO:
    CREATE bttExtendedObjectType.
    ASSIGN
      bttExtendedObjectType.oExtendsObjectTypeObj = poObjectTypeObj
      bttExtendedObjectType.cObjectTypeCode       = pcObjectTypeCode
    .

    IF NOT plDerive THEN
      ASSIGN
        bttExtendedObjectType.oObjectTypeObj = poObjectTypeObj
      .
        
  END.

  /* Now see if we have an extends attribute for this attribute */
  FIND bttExtendedObjectAttr
    WHERE bttExtendedObjectAttr.oObjectTypeObj    = poObjectTypeObj
      AND bttExtendedObjectAttr.cAttributeLabel   = pcAttrLabel
    NO-ERROR.
  IF NOT AVAILABLE(bttExtendedObjectAttr) THEN
  DO:
    CREATE bttExtendedObjectAttr.
    ASSIGN
      bttExtendedObjectAttr.oObjectTypeObj    = poObjectTypeObj
      bttExtendedObjectAttr.cAttributeLabel   = pcAttrLabel
    .

    /* If we have a record in the buffer that came in, copy the default values */
    IF VALID-HANDLE(phBuffer) AND
       phBuffer:AVAILABLE THEN
    DO:
      hBuffer:BUFFER-COPY(phBuffer,"cObjectTypeCode,cAttributeLabel":U).
    END.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addOTAttrs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addOTAttrs Procedure 
PROCEDURE addOTAttrs :
/*------------------------------------------------------------------------------
  Purpose:     Adds the attributes that are defined for a specified object type
               to the temp-table handle as a field in the table.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER poObjectTypeObj AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER phOTTable       AS HANDLE     NO-UNDO.

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


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addParentOTAttrs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addParentOTAttrs Procedure 
PROCEDURE addParentOTAttrs :
/*------------------------------------------------------------------------------
  Purpose:     Finds a parent object type for an object and any parents of that 
               parent and adds its attributes to the object type temp-table.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER poObjectTypeObj AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER phOTTable       AS HANDLE     NO-UNDO.

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


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildObjectTypeCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildObjectTypeCache Procedure 
PROCEDURE buildObjectTypeCache :
/*------------------------------------------------------------------------------
  Purpose:     Loops through the gsc_object_type temp-table and builds objects
               for each type listed in the pcTypes. If pcTypes contains an 
               asterisk, all object types are built.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcTypes AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bgsc_object_type FOR gsc_object_type.
  DEFINE BUFFER bttObjectType    FOR ttObjectType.

  DEFINE VARIABLE hOTTable        AS HANDLE     NO-UNDO.

  EMPTY TEMP-TABLE ttObjectType.

  /* Loop through all the object types in pcTypes */
  FOR EACH bgsc_object_type NO-LOCK
    WHERE CAN-DO(pcTypes, bgsc_object_type.object_type_code):

    /* Create a temp-table */
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

    /* Create a record in the temp-table so that we have a default for the
       object type */
    hOTTable:DEFAULT-BUFFER-HANDLE:BUFFER-CREATE().
    hOTTable:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("object_filename":U):BUFFER-VALUE = "class-default":U.
    hOTTable:DEFAULT-BUFFER-HANDLE:BUFFER-RELEASE().

    /* Now add the temp-table to the list of temp-tables in the object type temp-table */
    CREATE bttObjectType.
    ASSIGN 
      bttObjectType.oObjectTypeObj   = bgsc_object_type.object_type_obj
      bttObjectType.cObjectTypeCode  = bgsc_object_type.object_type_code
      bttObjectType.hObjectTypeTable = hOTTable
    .
  END. /*  FOR EACH bgsc_object_type NO-LOCK */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-changeObjectTypes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeObjectTypes Procedure 
PROCEDURE changeObjectTypes :
/*------------------------------------------------------------------------------
  Purpose:     Loops through all data in the ttObjectList and ttObjectInst
               tables and change the object types for all related UI events and
               attributes.
               
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE BUFFER bryc_smartobject      FOR ryc_smartobject.
  DEFINE BUFFER bryc_object_instance  FOR ryc_object_instance.
  DEFINE BUFFER bryc_ui_event         FOR ryc_ui_event.
  DEFINE BUFFER bryc_attribute_value  FOR ryc_attribute_value.
  DEFINE BUFFER bttExtendedObjectType FOR ttExtendedObjectType.

  DISABLE TRIGGERS FOR LOAD OF bryc_attribute_value.
  DISABLE TRIGGERS FOR DUMP OF bryc_attribute_value.
  DISABLE TRIGGERS FOR LOAD OF bryc_smartobject.
  DISABLE TRIGGERS FOR DUMP OF bryc_smartobject.
  DISABLE TRIGGERS FOR LOAD OF bryc_object_instance.
  DISABLE TRIGGERS FOR DUMP OF bryc_object_instance.
  DISABLE TRIGGERS FOR LOAD OF bryc_ui_event.
  DISABLE TRIGGERS FOR DUMP OF bryc_ui_event.

  FOR EACH bttExtendedObjectType 
      WHERE bttExtendedObjectType.oExtendsObjectTypeObj <> bttExtendedObjectType.oObjectTypeObj:

    FOR EACH bryc_smartobject EXCLUSIVE-LOCK
       WHERE bryc_smartobject.object_type_obj          = bttExtendedObjectType.oExtendsObjectTypeObj:

      FOR EACH bryc_attribute_value EXCLUSIVE-LOCK
        WHERE bryc_attribute_value.object_type_obj           = bryc_smartobject.object_type_obj
          AND bryc_attribute_value.smartobject_obj           = bryc_smartobject.smartobject_obj
          AND bryc_attribute_value.object_instance_obj       = 0
          AND bryc_attribute_value.container_smartobject_obj = 0:
        ASSIGN
          bryc_attribute_value.object_type_obj = bttExtendedObjectType.oObjectTypeObj
        .
      END. /* FOR EACH bryc_attribute_value NO-LOCK */
  
      FOR EACH bryc_ui_event EXCLUSIVE-LOCK
        WHERE bryc_ui_event.object_type_obj           = bryc_smartobject.object_type_obj
          AND bryc_ui_event.smartobject_obj           = bryc_smartobject.smartobject_obj
          AND bryc_ui_event.object_instance_obj       = 0
          AND bryc_ui_event.container_smartobject_obj = 0:
        ASSIGN
          bryc_ui_event.object_type_obj = bttExtendedObjectType.oObjectTypeObj
        .
      END. /* FOR EACH bryc_ui_event NO-LOCK */
  
      FOR EACH bryc_object_instance EXCLUSIVE-LOCK
        WHERE bryc_object_instance.smartobject_obj = bryc_smartobject.smartobject_obj:
  
        FOR EACH bryc_attribute_value EXCLUSIVE-LOCK
          WHERE bryc_attribute_value.object_type_obj           = bryc_smartobject.object_type_obj
            AND bryc_attribute_value.smartobject_obj           = bryc_smartobject.smartobject_obj
            AND bryc_attribute_value.object_instance_obj       = bryc_object_instance.object_instance_obj
            AND bryc_attribute_value.container_smartobject_obj = bryc_object_instance.container_smartobject_obj:
  
          ASSIGN
            bryc_attribute_value.object_type_obj = bttExtendedObjectType.oObjectTypeObj
          .
        END. /* FOR EACH bryc_attribute_value NO-LOCK */
  
        FOR EACH bryc_ui_event EXCLUSIVE-LOCK
          WHERE bryc_ui_event.object_type_obj           = bryc_smartobject.object_type_obj
            AND bryc_ui_event.smartobject_obj           = bryc_smartobject.smartobject_obj
            AND bryc_ui_event.object_instance_obj       = bryc_object_instance.object_instance_obj
            AND bryc_ui_event.container_smartobject_obj = bryc_object_instance.container_smartobject_obj:
          
          ASSIGN
            bryc_ui_event.object_type_obj = bttExtendedObjectType.oObjectTypeObj
          .
  
        END. /* FOR EACH bryc_ui_event NO-LOCK */
  
      END.
  
      
      ASSIGN
        bryc_smartobject.object_type_obj = bttExtendedObjectType.oObjectTypeObj
      .
    END. /* FOR EACH bryc_smartobject */
    PUBLISH "DCU_WriteLog":U ("Moved all objects from Object Type " + ENTRY(1,bttExtendedObjectType.cObjectTypeCode,"_":U) +
                              " to Object Type " + bttExtendedObjectType.cObjectTypeCode).

  END. /*  FOR EACH bttExtendedObjectType */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cleanupAttributeValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cleanupAttributeValues Procedure 
PROCEDURE cleanupAttributeValues :
/*------------------------------------------------------------------------------
  Purpose:     Loops through the object types and attribute values to remove
               all attribute values that are set to the same value as the parent
               SDO and get rid of any attributes that do not exist in the 
               ryc_attribute table.
               
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE BUFFER bryc_smartobject      FOR ryc_smartobject.
  DEFINE BUFFER bryc_object_instance  FOR ryc_object_instance.
  DEFINE BUFFER bryc_attribute_value  FOR ryc_attribute_value.
  DEFINE BUFFER bryc_attribute        FOR ryc_attribute.
  DEFINE BUFFER bttObjectType         FOR ttObjectType.

  DISABLE TRIGGERS FOR LOAD OF bryc_attribute_value.
  DISABLE TRIGGERS FOR DUMP OF bryc_attribute_value.

  DEFINE VARIABLE hOTBuffer  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hAttrBuff  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hAttrField AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iDataType  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cField             AS CHARACTER  
    INITIAL "character_value,date_value,logical_value,integer_value,decimal_value,character_value,character_value,raw_value,character_value,character_value":U
    NO-UNDO.

  hAttrBuff = BUFFER bryc_attribute_value:HANDLE.

  /* Loop through all the objects in ttObjectList */
  FOR EACH bttObjectType:

    /* Get a handle to the temp-table's buffer and find the first record
       with the object type's default values in it */
    hOTBuffer = bttObjectType.hObjectTypeTable:DEFAULT-BUFFER-HANDLE.

    /* Now loop through each ryc_smartobject for this object type. */
    FOR EACH bryc_smartobject NO-LOCK
      WHERE bryc_smartobject.object_type_obj = bttObjectType.oObjectTypeObj:

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
            DELETE bryc_attribute_value.
            NEXT.
          END.

        END. /* FOR EACH bryc_attribute_value NO-LOCK */

      END. /* FOR EACH bryc_object_instance NO-LOCK */

      /* Make sure we delete the record out of the cache temp-table. We only needed it long enough to clean up */
      hOTBuffer:BUFFER-DELETE().
    
    END. /* FOR EACH bryc_smartobject NO-LOCK */

  END. /* FOR EACH bttObjectType: */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createExtendedObjectTypes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createExtendedObjectTypes Procedure 
PROCEDURE createExtendedObjectTypes :
/*------------------------------------------------------------------------------
  Purpose:     Reads through the data in the temp-tables and creates new object
               types derived from the parent object types.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE BUFFER bttExtendedObjectType FOR ttExtendedObjectType.
  DEFINE BUFFER bttExtendedObjectAttr FOR ttExtendedObjectAttr.
  DEFINE BUFFER bgsc_object_type      FOR gsc_object_type.
  DEFINE BUFFER bparent_object_type   FOR gsc_object_type.
  DEFINE BUFFER bryc_attribute_value  FOR ryc_attribute_value.

  DEFINE VARIABLE rDefault            AS ROWID      NO-UNDO.
  DEFINE VARIABLE iHigh               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iTotal              AS INTEGER    NO-UNDO.
  DISABLE TRIGGERS FOR LOAD OF bgsc_object_type.
  DISABLE TRIGGERS FOR DUMP OF bgsc_object_type.
  DISABLE TRIGGERS FOR LOAD OF bryc_attribute_value.
  DISABLE TRIGGERS FOR DUMP OF bryc_attribute_value.

  /* Set up the suffix to be tagged on to the end of all the extends object types. */
  ASSIGN
    gcOTSuffix = "_SITE_":U + STRING(getSiteNumber())
  .

  /* Now loop through the extends object types. */
  FOR EACH bttExtendedObjectType 
    BY bttExtendedObjectType.oExtendsObjectTypeObj TRANSACTION:

    /* If this object type obj and extends object type obj are the same, we are not extending the
       object type. */
    IF bttExtendedObjectType.oExtendsObjectTypeObj = bttExtendedObjectType.oObjectTypeObj THEN
    DO:
      FIND FIRST bgsc_object_type NO-LOCK
        WHERE bgsc_object_type.object_type_code = bttExtendedObjectType.cObjectTypeCode
        NO-ERROR.
      IF NOT AVAILABLE(bgsc_object_type) THEN
      DO:
        PUBLISH "DCU_WriteLog":U ("**Object Type " + bgsc_object_type.object_type_code + " no longer on file.").
        NEXT.
      END.
      ELSE
        PUBLISH "DCU_WriteLog":U ("Updating Object Type " + bgsc_object_type.object_type_code + "...").
    END. /* IF bttExtendedObjectType.oExtendsObjectTypeObj = bttExtendedObjectType.oObjectTypeObj */

    ELSE
    DO:
      /* We *are* extending the object type */
      FIND FIRST bparent_object_type NO-LOCK
        WHERE bparent_object_type.object_type_obj = bttExtendedObjectType.oExtendsObjectTypeObj
        NO-ERROR.
      IF NOT AVAILABLE(bparent_object_type) THEN
        NEXT.
      
      FIND FIRST bgsc_object_type NO-LOCK
        WHERE bgsc_object_type.object_type_code = TRIM(bttExtendedObjectType.cObjectTypeCode) + gcOTSuffix
        NO-ERROR.
      IF NOT AVAILABLE(bgsc_object_type) THEN
      DO:
        CREATE bgsc_object_type.
        BUFFER-COPY bparent_object_type 
          EXCEPT object_type_obj object_type_code extends_object_type_obj
          TO bgsc_object_type
          ASSIGN
            bgsc_object_type.object_type_obj         = getNextObj()
            bgsc_object_type.object_type_code        = bttExtendedObjectType.cObjectTypeCode + gcOTSuffix
            bgsc_object_type.extends_object_type_obj = bttExtendedObjectType.oExtendsObjectTypeObj
            bttExtendedObjectType.oObjectTypeObj     = bgsc_object_type.object_type_obj
            bttExtendedObjectType.cObjectTypeCode    = bgsc_object_type.object_type_code
          .

        PUBLISH "DCU_WriteLog":U ("New Object Type " + bgsc_object_type.object_type_code +
                                  " extends " + bparent_object_type.object_type_code).
      END.
    END.



    /* Loop through the extended attributes and add them to the object type. */
    FOR EACH bttExtendedObjectAttr 
      WHERE bttExtendedObjectAttr.oObjectTypeObj = bttExtendedObjectType.oExtendsObjectTypeObj:

      FIND FIRST bryc_attribute_value EXCLUSIVE-LOCK
        WHERE bryc_attribute_value.object_type_obj           = bttExtendedObjectType.oObjectTypeObj
          AND bryc_attribute_value.smartobject_obj           = 0.0 
          AND bryc_attribute_value.container_smartobject_obj = 0.0
          AND bryc_attribute_value.object_instance_obj       = 0.0
          AND bryc_attribute_value.attribute_label           = bttExtendedObjectAttr.cAttributeLabel
        NO-ERROR.

      IF AVAILABLE(bryc_attribute_value) THEN
        NEXT.

      CREATE bryc_attribute_value.
      ASSIGN
        bryc_attribute_value.attribute_value_obj       = getNextObj()
        bryc_attribute_value.object_type_obj           = bttExtendedObjectType.oObjectTypeObj
        bryc_attribute_value.smartobject_obj           = 0.0 
        bryc_attribute_value.container_smartobject_obj = 0.0
        bryc_attribute_value.object_instance_obj       = 0.0
        bryc_attribute_value.attribute_label           = bttExtendedObjectAttr.cAttributeLabel
      .
      
      PUBLISH "DCU_WriteLog":U ("  New Attribute " + bryc_attribute_value.attribute_label +
                                " for Object Type " + bgsc_object_type.object_type_code).

      BUFFER-COPY bttExtendedObjectAttr
        USING bttExtendedObjectAttr.constant_value 
              bttExtendedObjectAttr.character_value
              bttExtendedObjectAttr.logical_value  
              bttExtendedObjectAttr.integer_value  
              bttExtendedObjectAttr.date_value     
              bttExtendedObjectAttr.decimal_value  
              bttExtendedObjectAttr.raw_value      
        TO bryc_attribute_value.

    END. /* FOR EACH bttExtendedObjectAttr  */

  END. /* FOR EACH bttExtendedObjectType */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteTables Procedure 
PROCEDURE deleteTables :
/*------------------------------------------------------------------------------
  Purpose:     Deletes all the temp tables that were created.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hTable AS HANDLE NO-UNDO.
  
  /* Loop through the ttObjectType temp-table */
  FOR EACH ttObjectType:
    hTable = ttObjectType.hObjectTypeTable.
  
    /* Delete the temp-table structure */
    IF VALID-HANDLE(hTable) THEN
      DELETE OBJECT hTable.
  
    /* Delete the record */
    DELETE ttObjectType.
  
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-determineObjectTypeExtensions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE determineObjectTypeExtensions Procedure 
PROCEDURE determineObjectTypeExtensions :
/*------------------------------------------------------------------------------
  Purpose:     This procedure goes through each ryc_smartobject for an object 
               type and each ryc_object_instance of the ryc_smartobject and 
               checks if there are extra attributes at either level, we change 
               the object type for these.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE BUFFER bryc_smartobject     FOR ryc_smartobject.
  DEFINE BUFFER bryc_object_instance FOR ryc_object_instance.
  DEFINE BUFFER bryc_attribute_value FOR ryc_attribute_value.
  DEFINE BUFFER bryc_attribute       FOR ryc_attribute.
  DEFINE BUFFER bttObjectType        FOR ttObjectType.
  DEFINE BUFFER bttAttrDefault       FOR ttAttrDefault.

  DEFINE VARIABLE hOTBuffer  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hAttrBuff  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lDerive    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iDataType  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cField             AS CHARACTER  
    INITIAL "character_value,date_value,logical_value,integer_value,decimal_value,character_value,character_value,raw_value,character_value,character_value":U
    NO-UNDO.

  hAttrBuff = BUFFER bryc_attribute_value:HANDLE.
  /* Loop through all the object types */
  FOR EACH bttObjectType:

    /* Get a handle to the temp-table's buffer and find the first record
       with the object type's default values in it */
    hOTBuffer = bttObjectType.hObjectTypeTable:DEFAULT-BUFFER-HANDLE.
    hOTBuffer:FIND-FIRST().

    lDerive = CAN-FIND(FIRST ttV2Object WHERE ttV2Object.cObjectTypeCode = bttObjectType.cObjectTypeCode).

    /* Add any attributes that came in from the loaded ones */
    FOR EACH bttAttrDefault 
      WHERE bttAttrDefault.cObjectTypeCode = bttObjectType.cObjectTypeCode:

      IF NOT CAN-FIND(FIRST ryc_attribute 
                      WHERE ryc_attribute.attribute_label = bttAttrDefault.cAttributeLabel) THEN
        NEXT.

      hField = hOTBuffer:BUFFER-FIELD(bttAttrDefault.cAttributeLabel) NO-ERROR.
      ERROR-STATUS:ERROR = NO.
      IF NOT VALID-HANDLE(hField) THEN
      DO:
        RUN addObjectTypeExtension
          (bttObjectType.oObjectTypeObj,
           bttObjectType.cObjectTypeCode,
           "":U,
           bttAttrDefault.cAttributeLabel,
           lDerive,
           INPUT BUFFER bttAttrDefault:HANDLE).
      END.

    END.


    /* Now loop through each ryc_smartobject for this object type. */
    FOR EACH bryc_smartobject NO-LOCK
      WHERE bryc_smartobject.object_type_obj = bttObjectType.oObjectTypeObj:

      FOR EACH bryc_attribute_value NO-LOCK
        WHERE bryc_attribute_value.object_type_obj           = bryc_smartobject.object_type_obj
          AND bryc_attribute_value.smartobject_obj           = bryc_smartobject.smartobject_obj
          AND bryc_attribute_value.object_instance_obj       = 0
          AND bryc_attribute_value.container_smartobject_obj = 0:
        
        IF NOT CAN-FIND(FIRST ryc_attribute 
                        WHERE ryc_attribute.attribute_label = bryc_attribute_value.attribute_label) THEN
          NEXT.

        hField = hOTBuffer:BUFFER-FIELD(bryc_attribute_value.attribute_label) NO-ERROR.
        ERROR-STATUS:ERROR = NO.
        IF NOT VALID-HANDLE(hField) THEN
        DO:
          RUN addObjectTypeExtension
            (bttObjectType.oObjectTypeObj,
             bttObjectType.cObjectTypeCode,
             bryc_smartobject.object_filename,
             bryc_attribute_value.attribute_label,
             lDerive,
             ?).
        END.
      END. /* FOR EACH bryc_attribute_value NO-LOCK */
      
      FOR EACH bryc_object_instance NO-LOCK
        WHERE bryc_object_instance.smartobject_obj = bryc_smartobject.smartobject_obj:
        
        FOR EACH bryc_attribute_value NO-LOCK
          WHERE bryc_attribute_value.object_type_obj           = bryc_smartobject.object_type_obj
            AND bryc_attribute_value.smartobject_obj           = bryc_smartobject.smartobject_obj
            AND bryc_attribute_value.object_instance_obj       = bryc_object_instance.object_instance_obj
            AND bryc_attribute_value.container_smartobject_obj = bryc_object_instance.container_smartobject_obj:

          IF NOT CAN-FIND(FIRST ryc_attribute 
                          WHERE ryc_attribute.attribute_label = bryc_attribute_value.attribute_label) THEN
            NEXT.
          
          hField = hOTBuffer:BUFFER-FIELD(bryc_attribute_value.attribute_label) NO-ERROR.
          ERROR-STATUS:ERROR = NO.
          IF NOT VALID-HANDLE(hField) THEN
          DO:
            RUN addObjectTypeExtension
              (bttObjectType.oObjectTypeObj,
               bttObjectType.cObjectTypeCode,
               bryc_smartobject.object_filename,
               bryc_attribute_value.attribute_label,
               lDerive,
               ?).
          END.
        END. /* FOR EACH bryc_attribute_value NO-LOCK */

      END. /* FOR EACH bryc_object_instance NO-LOCK */

    END. /* FOR EACH bryc_smartobject NO-LOCK */

  END. /* FOR EACH bttObjectType: */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadStoredAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadStoredAttributes Procedure 
PROCEDURE loadStoredAttributes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUFFER bttAttrDefault FOR ttAttrDefault.
    DEFINE BUFFER bgsc_object_type     FOR gsc_object_type.
    DEFINE BUFFER bryc_attribute_value FOR icfdb.ryc_attribute_value.

    DEFINE VARIABLE cFile AS CHARACTER  NO-UNDO.

    /* Set up the file name that contains the attributes that were stored */
    cFile = REPLACE(SESSION:TEMP-DIRECTORY,"~\","/":U).
    IF SUBSTRING(cFile,LENGTH(cFile),1) <> "/":U THEN
      cFile = cFile + "/":U.

    cFile = SEARCH(cFile + "storeattrdflt.d":U).

    IF cFile = ? THEN
      PUBLISH "DCU_WriteLog":U ("Unable to find file storeattrdflt.d").

    /* Import the stored attributes into the temp-table. */
    INPUT FROM VALUE(cFile) NO-ECHO.
    PUBLISH "DCU_WriteLog":U ("Importing stored attributes from " + cFile).
    REPEAT:
      CREATE bttAttrDefault.
      IMPORT bttAttrDefault.
    END.
    INPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadV2ObjectList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadV2ObjectList Procedure 
PROCEDURE loadV2ObjectList :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttV2Object FOR ttV2Object.

  DEFINE VARIABLE cObjectFile AS CHARACTER  NO-UNDO.

  /* Find the file that contains the attributes that changed between 1.1 and 2.0 */
  cObjectFile = SEARCH("db/icf/dfd/v1v2objects.d").

  IF cObjectFile <> ? THEN
  DO:
    INPUT FROM VALUE(cObjectFile) NO-ECHO.
    PUBLISH "DCU_WriteLog":U ("Importing V2 Object from " + cObjectFile).
    REPEAT:
      CREATE bttV2Object.
      IMPORT bttV2Object.
    END.
  END.
  ELSE
  DO:
    PUBLISH "DCU_WriteLog":U ("**V2 Object file db/icf/dfd/v1v2objects.d not found").
    RETURN.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-normalizeData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE normalizeData Procedure 
PROCEDURE normalizeData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE BUFFER bttExtendedObjectType FOR ttExtendedObjectType.
  DEFINE BUFFER bttExtendedObjectAttr FOR ttExtendedObjectAttr.
  
  DEFINE VARIABLE iAttrCount          AS INTEGER    NO-UNDO.

  FOR EACH bttExtendedObjectType:
    iAttrCount = 0.
    FOR EACH bttExtendedObjectAttr
       WHERE bttExtendedObjectAttr.oObjectTypeObj = bttExtendedObjectType.oExtendsObjectTypeObj:
      ASSIGN 
        iAttrCount = iAttrCount + 1
      .
    END.

    IF iAttrCount = 0 THEN
      DELETE bttExtendedObjectType.

  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeOldAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeOldAttributes Procedure 
PROCEDURE removeOldAttributes :
/*------------------------------------------------------------------------------
  Purpose:     Reads in the contents of the v1v2objectattrs.d file that contains
               the attributes to be removed and works through the object list
               to remove them.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE BUFFER bgsc_object_type     FOR gsc_object_type.
  DEFINE BUFFER bryc_smartobject     FOR ryc_smartobject.
  DEFINE BUFFER bryc_object_instance FOR ryc_object_instance.
  DEFINE BUFFER bryc_attribute_value FOR ryc_attribute_value.
  DEFINE BUFFER bryc_attribute       FOR ryc_attribute.
  DEFINE BUFFER bttObjectAttr        FOR ttObjectAttr.
  DEFINE BUFFER bttAttrDefault       FOR ttAttrDefault.

  DEFINE VARIABLE lDelete               AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lCheck                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hBuffer               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectAttrFile       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCheckValue           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cField             AS CHARACTER  
    INITIAL "character_value,date_value,logical_value,integer_value,decimal_value,character_value,character_value,raw_value,character_value,character_value":U
    NO-UNDO.
  DEFINE VARIABLE iDataType AS INTEGER    NO-UNDO.

  hBuffer = BUFFER bryc_attribute_value:HANDLE.

  /* Find the file that contains the attributes that changed between 1.1 and 2.0 */
  cObjectAttrFile = SEARCH("db/icf/dfd/v1v2objectattrs.d").

  IF cObjectAttrFile <> ? THEN
  DO:
    INPUT FROM VALUE(cObjectAttrFile) NO-ECHO.
    PUBLISH "DCU_WriteLog":U ("Importing V2 Object attributes from " + cObjectAttrFile).
    REPEAT:
      CREATE bttObjectAttr.
      IMPORT bttObjectAttr.
    END.
  END.
  ELSE
  DO:
    PUBLISH "DCU_WriteLog":U ("**V2 Object attribute file db/icf/dfd/v1v2objectattrs.d not found").
    RETURN.
  END.

  /* Loop through all the records in the Object attribute table that we just populated */
  FOR EACH bttObjectAttr 
    BY cObjectTypeCode
    BY cAttributeLabel:

    lDelete = NO.
    lCheck  = NO.

    /* If the attribute existed in V1 but no longer exists in V2, we can delete it 
       here. */
    IF (bttObjectAttr.lExistsV1 AND
        NOT bttObjectAttr.lExistsV2) OR
        NOT CAN-FIND(FIRST ryc_attribute WHERE ryc_attribute.attribute_label = bttObjectAttr.cAttributeLabel) THEN
    DO:
      /* Whack this attribute from the stored attributes that we loaded back. */
      FIND FIRST bttAttrDefault 
        WHERE bttAttrDefault.cObjectTypeCode = bttObjectAttr.cObjectTypeCode
          AND bttAttrDefault.cAttributeLabel = bttObjectAttr.cAttributeLabel
        NO-ERROR.

      IF AVAILABLE(bttAttrDefault) THEN
        DELETE bttAttrDefault.
      
      lDelete = YES.
    END.

    IF bttObjectAttr.lExistsV1 AND
       bttObjectAttr.lExistsV2 AND
       cV1Derived <> "":U      THEN
      lCheck = YES.

    IF NOT lCheck AND
       NOT lDelete THEN
      NEXT.

    FIND FIRST bgsc_object_type NO-LOCK
      WHERE bgsc_object_type.object_type_code = bttObjectAttr.cObjectTypeCode
      NO-ERROR.
    IF NOT AVAILABLE(bgsc_object_type) THEN
      NEXT.

    
      /* Now loop through each ryc_smartobject for this object type. */
    FOR EACH bryc_smartobject NO-LOCK
      WHERE bryc_smartobject.object_type_obj = bgsc_object_type.object_type_obj:

      FOR EACH bryc_attribute_value EXCLUSIVE-LOCK
        WHERE bryc_attribute_value.object_type_obj           = bryc_smartobject.object_type_obj
          AND bryc_attribute_value.smartobject_obj           = bryc_smartobject.smartobject_obj
          AND bryc_attribute_value.object_instance_obj       = 0
          AND bryc_attribute_value.container_smartobject_obj = 0
          AND bryc_attribute_value.attribute_label           = bttObjectAttr.cAttributeLabel:

        FIND FIRST bryc_attribute NO-LOCK
          WHERE bryc_attribute.attribute_label = bryc_attribute_value.attribute_label
          NO-ERROR.
        
        IF NOT AVAILABLE(bryc_attribute) THEN 
        DO:
          DELETE bryc_attribute_value.
          NEXT.
        END.
        
        /* Make sure that the data type is between 1 and 10 */
        iDataType = bryc_attribute.data_type.
        IF iDataType < 1 OR 
           iDataType > 10 THEN
          iDataType = 1.

        cCheckValue = STRING(hBuffer:BUFFER-FIELD(ENTRY(iDataType,cField)):BUFFER-VALUE).
        
        IF  lDelete OR
            (lCheck AND
             (cCheckValue = ? OR 
              TRIM(cCheckValue) = "":U OR 
              cCheckValue = bttObjectAttr.cV2Value)) THEN
          DELETE bryc_attribute_value.
      END.


      FOR EACH bryc_object_instance NO-LOCK
        WHERE bryc_object_instance.smartobject_obj = bryc_smartobject.smartobject_obj:
        
        FOR EACH bryc_attribute_value EXCLUSIVE-LOCK
          WHERE bryc_attribute_value.object_type_obj           = bryc_smartobject.object_type_obj
            AND bryc_attribute_value.smartobject_obj           = bryc_smartobject.smartobject_obj
            AND bryc_attribute_value.object_instance_obj       = bryc_object_instance.object_instance_obj
            AND bryc_attribute_value.container_smartobject_obj = bryc_object_instance.container_smartobject_obj
            AND bryc_attribute_value.attribute_label           = bttObjectAttr.cAttributeLabel:

          FIND FIRST bryc_attribute NO-LOCK
            WHERE bryc_attribute.attribute_label = bryc_attribute_value.attribute_label
            NO-ERROR.

          IF NOT AVAILABLE(bryc_attribute) THEN 
          DO:
            DELETE bryc_attribute_value.
            NEXT.
          END.

          /* Make sure that the data type is between 1 and 10 */
          iDataType = bryc_attribute.data_type.
          IF iDataType < 1 OR 
             iDataType > 10 THEN
            iDataType = 1.

          cCheckValue = STRING(hBuffer:BUFFER-FIELD(ENTRY(iDataType,cField)):BUFFER-VALUE).

          IF  lDelete OR
              (lCheck AND
               (cCheckValue = ? OR 
                TRIM(cCheckValue) = "":U OR 
                cCheckValue = bttObjectAttr.cV2Value)) THEN
            DELETE bryc_attribute_value.

        END.
      END.
    END.

    FOR EACH bryc_attribute_value EXCLUSIVE-LOCK
      WHERE bryc_attribute_value.object_type_obj           = bgsc_object_type.object_type_obj
        AND bryc_attribute_value.smartobject_obj           = 0
        AND bryc_attribute_value.object_instance_obj       = 0
        AND bryc_attribute_value.container_smartobject_obj = 0
        AND bryc_attribute_value.attribute_label           = bttObjectAttr.cAttributeLabel:

      FIND FIRST bryc_attribute NO-LOCK
        WHERE bryc_attribute.attribute_label = bryc_attribute_value.attribute_label
        NO-ERROR.

      IF NOT AVAILABLE(bryc_attribute) THEN 
      DO:
        DELETE bryc_attribute_value.
        NEXT.
      END.
      
      IF lDelete THEN
        DELETE bryc_attribute_value.

    END.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getNextObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNextObj Procedure 
FUNCTION getNextObj RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  To return the next available unique object number.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dSeqNext    AS DECIMAL  NO-UNDO.

  DEFINE VARIABLE iSeqObj1    AS INTEGER  NO-UNDO.
  DEFINE VARIABLE iSeqObj2    AS INTEGER  NO-UNDO.

  DEFINE VARIABLE iSeqSiteDiv AS INTEGER  NO-UNDO.
  DEFINE VARIABLE iSeqSiteRev AS INTEGER  NO-UNDO.

  DEFINE VARIABLE iSessnId    AS INTEGER  NO-UNDO.

  ASSIGN
    iSeqObj1    = NEXT-VALUE(seq_obj1,ICFDB)
    iSeqObj2    = CURRENT-VALUE(seq_obj2,ICFDB)
    iSeqSiteDiv = CURRENT-VALUE(seq_site_division,ICFDB)
    iSeqSiteRev = CURRENT-VALUE(seq_site_reverse,ICFDB)
    iSessnId    = CURRENT-VALUE(seq_session_id,ICFDB)
    .

  IF iSeqObj1 = 0
  THEN
    ASSIGN
      iSeqObj2 = NEXT-VALUE(seq_obj2,ICFDB).

  ASSIGN
    dSeqNext = DECIMAL((iSeqObj2 * 1000000000.0) + iSeqObj1)
    .

  IF  iSeqSiteDiv <> 0
  AND iSeqSiteRev <> 0
  THEN
    ASSIGN
      dSeqNext = dSeqNext + (iSeqSiteRev / iSeqSiteDiv).

  RETURN dSeqNext. /* Function return value */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSiteNumber) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSiteNumber Procedure 
FUNCTION getSiteNumber RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSiteFwd AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSiteRev AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cFormat  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDivisor AS CHARACTER  NO-UNDO.
  
  cDivisor = STRING(CURRENT-VALUE(seq_site_division,ICFDB)).

  IF LENGTH(cDivisor) > 1 THEN
  DO iCount = 2 TO LENGTH(cDivisor):
    cFormat = cFormat + "9":U.
  END.

  ASSIGN
    cSiteRev = STRING(CURRENT-VALUE(seq_site_reverse,ICFDB),cFormat)
    cSiteFwd = "":U
    .

  DO iCount = LENGTH(cSiteRev) TO 1 BY -1:
    cSiteFwd = cSiteFwd + SUBSTRING(cSiteRev,iCount,1).
  END.
 
  RETURN INTEGER(cSiteFwd).   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

