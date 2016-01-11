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
  File: rycustload.p

  Description:  Custom Class Load Procedure

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    MIP
                Date:   11/07/2002  Author:     Mark Davies (MIP)

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rycustload.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

{ry/inc/rycustprpt.i}

DEFINE INPUT        PARAMETER plCheckDB    AS LOGICAL    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttClassDef.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttAttribute.
DEFINE OUTPUT       PARAMETER pcResultList AS CHARACTER NO-UNDO.

DEFINE VARIABLE lAttrCreated AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-setMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMessage Procedure 
FUNCTION setMessage RETURNS LOGICAL
  ( pcMessage AS CHARACTER )  FORWARD.

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
         HEIGHT             = 12.1
         WIDTH              = 51.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
 
IF NOT plCheckDB THEN DO:
  /* First add any new class records */
  RUN addClass.
  
  /* Now add any new attributes for these classes */
  RUN addAttribute.
     
  /* Now add these new attributes to these new class records */
  RUN addAttributeToClass.
END.
ELSE
  RUN checkAttrOnDB.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addAttribute Procedure 
PROCEDURE addAttribute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iDataType AS INTEGER    NO-UNDO.

  FIND FIRST ryc_attribute_group
       WHERE ryc_attribute_group.attribute_group_name = "ADMAttributes"
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ryc_attribute_group THEN DO:
    lAttrCreated = FALSE.
    setMessage("ERROR: Could not create attributes. Could not find attribute group 'ADMAttributes' in the Repository.").
    RETURN.
  END.
  
  lAttrCreated = TRUE.

  FOR EACH  ttClassDef
      WHERE ttClassDef.dClassObj <> 0 NO-LOCK,
      EACH  ttAttribute
      WHERE ttAttribute.cFileName = ttClassDef.cFileName
      AND   ttAttribute.lLoad     = TRUE
      EXCLUSIVE-LOCK:
    IF NOT CAN-FIND(FIRST ryc_attribute
                    WHERE ryc_attribute.attribute_label = ttAttribute.cAttrName) THEN DO:
      CASE cDataType:
        WHEN "CHARACTER" THEN
          iDataType = 1.
        WHEN "DATE" THEN
          iDataType = 2.
        WHEN "LOGICAL" THEN
          iDataType = 3.
        WHEN "INTEGER" THEN
          iDataType = 4.
        WHEN "DECIMAL" THEN
          iDataType = 5.
        WHEN "RECID" THEN
          iDataType = 7.
        WHEN "RAW" THEN
          iDataType = 8.
        WHEN "ROWID" THEN
          iDataType = 8.
        WHEN "HANDLE" THEN
          iDataType = 10.
        WHEN "MEMPTR" THEN
          iDataType = 11.
        WHEN "COM-HANDLE" THEN
          iDataType = 14.
        OTHERWISE
          iDataType = 1.
      END CASE.
      
      CREATE ryc_attribute.
      ASSIGN ryc_attribute.attribute_group_obj = ryc_attribute_group.attribute_group_obj
             ryc_attribute.attribute_label     = ttAttribute.cAttrName
             ryc_attribute.data_type           = iDataType
             ryc_attribute.override_type       = ttAttribute.cOverrideType
             ryc_attribute.runtime_only        = ttAttribute.lRuntimeOnly
             ryc_attribute.is_private          = ttAttribute.lPrivate
             ryc_attribute.constant_level      = ttAttribute.cConstantLevel
             ryc_attribute.derived_value       = ttAttribute.lDerivedValue
             ryc_attribute.design_only         = ttAttribute.lDesignOnly
             ryc_attribute.system_owned        = ttAttribute.lSystemOwned
             ttAttribute.lExistInDB            = TRUE.
      VALIDATE ryc_attribute NO-ERROR.
      IF ERROR-STATUS:ERROR THEN 
        setMessage("ERROR: The following error occurred while trying to create a new attribute record for " + ttAttribute.cAttrName).
      ELSE
        setMessage("Created new attribute record for " + ttAttribute.cAttrName).
    
    END.
    ELSE 
      setMessage("Did not create new attribute record for " + ttAttribute.cAttrName + " since it already exists in the Repository.").
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addAttributeToClass) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addAttributeToClass Procedure 
PROCEDURE addAttributeToClass :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  FOR EACH  ttClassDef
      WHERE ttClassDef.dClassObj <> 0 NO-LOCK,
      EACH  ttAttribute
      WHERE ttAttribute.cFileName = ttClassDef.cFileName
      AND   ttAttribute.lLoad     = TRUE
      NO-LOCK:
    IF NOT CAN-FIND(FIRST ryc_attribute
                    WHERE ryc_attribute.attribute_label = ttAttribute.cAttrName) THEN DO:
      setMessage("Could not add attribute " + ttAttribute.cAttrName + " to class " + ttClassDef.cClassName + " since attribute does not exist. See previous log for details.").
      NEXT.
    END.
    FIND FIRST ryc_attribute_value
         WHERE ryc_attribute_value.object_type_obj           = ttClassDef.dClassObj
         AND   ryc_attribute_value.container_smartobject_obj = 0
         AND   ryc_attribute_value.smartobject_obj           = 0
         AND   ryc_attribute_value.primary_smartobject_obj   = 0
         AND   ryc_attribute_value.object_instance_obj       = 0
         AND   ryc_attribute_value.attribute_label           = ttAttribute.cAttrName
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ryc_attribute_value THEN DO:
      CREATE ryc_attribute_value.
      ASSIGN ryc_attribute_value.object_type_obj           = ttClassDef.dClassObj  
             ryc_attribute_value.attribute_label           = ttAttribute.cAttrName 
             ryc_attribute_value.container_smartobject_obj = 0
             ryc_attribute_value.smartobject_obj           = 0
             ryc_attribute_value.primary_smartobject_obj   = 0
             ryc_attribute_value.object_instance_obj       = 0.
      CASE ttAttribute.cDataType:
        WHEN "CHARACTER":U THEN
          ASSIGN ryc_attribute_value.character_value = ttAttribute.cInitial NO-ERROR.
        WHEN "INTEGER":U THEN
          ASSIGN ryc_attribute_value.integer_value = INTEGER(ttAttribute.cInitial) NO-ERROR.
        WHEN "DATE":U THEN
          ASSIGN ryc_attribute_value.date_value = DATE(ttAttribute.cInitial) NO-ERROR.
        WHEN "DECIMAL":U THEN
          ASSIGN ryc_attribute_value.decimal_value = DECIMAL(ttAttribute.cInitial) NO-ERROR.
        WHEN "LOGICAL":U THEN
          ASSIGN ryc_attribute_value.logical_value = LOGICAL(ttAttribute.cInitial) NO-ERROR.
      END CASE.
      VALIDATE ryc_attribute_value NO-ERROR.
      IF ERROR-STATUS:ERROR THEN 
        setMessage("ERROR: The following error occurred while trying to create a new attribute value record for " + ttAttribute.cAttrName + " for class " + ttClassDef.cClassName).
      ELSE
        setMessage("Created new attribute value record for " + ttAttribute.cAttrName + " for class " + ttClassDef.cClassName).
    END.
    /* Attribute already exist for class */
    ELSE 
      setMessage("Did not create new attribute value record for " + ttAttribute.cAttrName + " for class " + ttClassDef.cClassName + " since this attribute value record already exists.").
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addClass) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addClass Procedure 
PROCEDURE addClass :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE BUFFER bgsc_object_type FOR gsc_object_type.
  
  FOR EACH  ttClassDef
      WHERE ttClassDef.lCreate = TRUE
      EXCLUSIVE-LOCK:
    IF NOT CAN-FIND(FIRST gsc_object_type
                    WHERE gsc_object_type.object_type_code = ttClassDef.cClassName) THEN DO:
      FIND FIRST bgsc_object_type
           WHERE bgsc_object_type.object_type_code = ttClassDef.cExtendsFrom
           NO-LOCK NO-ERROR.

      CREATE gsc_object_type.
      ASSIGN gsc_object_type.object_type_code        = ttClassDef.cClassName
             gsc_object_type.object_type_description = "Customized class for " + ttClassDef.cExtendsFrom
             gsc_object_type.static_object           = TRUE
             gsc_object_type.extends_object_type_obj = IF AVAILABLE bgsc_object_type THEN bgsc_object_type.object_type_obj ELSE 0.
      VALIDATE gsc_object_type NO-ERROR.
      IF ERROR-STATUS:ERROR THEN
        setMessage("ERROR: The following error occurred while trying to create a new class record for " + ttClassDef.cClassName).
      ELSE DO:
        setMessage("Created new class for " + ttClassDef.cClassName).
        ASSIGN ttClassDef.dClassObj = gsc_object_type.object_type_obj.
      END.
    END.
    ELSE DO:
      /* Object Type already exists */
      FIND FIRST gsc_object_type
           WHERE gsc_object_type.object_type_code = ttClassDef.cClassName
           NO-LOCK NO-ERROR.
        setMessage("Did not create new class for " + ttClassDef.cClassName + " since it already exists in the Repository.").
      ASSIGN ttClassDef.dClassObj = IF AVAILABLE gsc_object_type THEN gsc_object_type.object_type_obj ELSE 0.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkAttrOnDB) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkAttrOnDB Procedure 
PROCEDURE checkAttrOnDB :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will run through all the attributes and check if
               thet already exist in the Repository
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH ttAttribute
      EXCLUSIVE-LOCK:
    FIND FIRST ryc_attribute
         WHERE ryc_attribute.attribute_label = ttAttribute.cAttrName
         NO-LOCK NO-ERROR.
    IF AVAILABLE ryc_attribute THEN DO:
      ASSIGN ttAttribute.cAttrName      = ryc_attribute.attribute_label
             ttAttribute.cOverrideType  = ryc_attribute.override_type  
             ttAttribute.lRuntimeOnly   = ryc_attribute.runtime_only   
             ttAttribute.lPrivate       = ryc_attribute.is_private     
             ttAttribute.cConstantLevel = ryc_attribute.constant_level 
             ttAttribute.lDerivedValue  = ryc_attribute.derived_value  
             ttAttribute.lDesignOnly    = ryc_attribute.design_only    
             ttAttribute.lSystemOwned   = ryc_attribute.system_owned
             ttAttribute.lExistInDB     = TRUE.
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-setMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setMessage Procedure 
FUNCTION setMessage RETURNS LOGICAL
  ( pcMessage AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  pcResultList = IF pcResultList = "":U 
                    THEN pcMessage
                    ELSE pcResultList + "~n" + pcMessage.

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

