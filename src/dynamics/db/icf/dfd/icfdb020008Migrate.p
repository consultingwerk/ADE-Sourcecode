
/* This noddy is to be run after applying icfdb020008delta.df */

/* Overridew the triggers */
DISABLE TRIGGERS FOR LOAD OF gsc_dataset_entity.            DISABLE TRIGGERS FOR DUMP OF gsc_dataset_entity.
DISABLE TRIGGERS FOR LOAD OF gsc_default_code.              DISABLE TRIGGERS FOR DUMP OF gsc_default_code.
DISABLE TRIGGERS FOR LOAD OF gsc_default_set_usage.         DISABLE TRIGGERS FOR DUMP OF gsc_default_set_usage.
DISABLE TRIGGERS FOR LOAD OF gsc_entity_display_field.      DISABLE TRIGGERS FOR DUMP OF gsc_entity_display_field.
DISABLE TRIGGERS FOR LOAD OF gsm_entity_field.              DISABLE TRIGGERS FOR DUMP OF gsm_entity_field.
DISABLE TRIGGERS FOR LOAD OF gsc_entity_mnemonic.           DISABLE TRIGGERS FOR DUMP OF gsc_entity_mnemonic.
DISABLE TRIGGERS FOR LOAD OF gsc_entity_mnemonic_procedure. DISABLE TRIGGERS FOR DUMP OF gsc_entity_mnemonic_procedure.
DISABLE TRIGGERS FOR LOAD OF gsc_error.                     DISABLE TRIGGERS FOR DUMP OF gsc_error.
DISABLE TRIGGERS FOR LOAD OF gsc_global_default.            DISABLE TRIGGERS FOR DUMP OF gsc_global_default.
DISABLE TRIGGERS FOR LOAD OF gsc_object.                    DISABLE TRIGGERS FOR DUMP OF gsc_object.
DISABLE TRIGGERS FOR LOAD OF gsc_language_text.             DISABLE TRIGGERS FOR DUMP OF gsc_language_text.
DISABLE TRIGGERS FOR LOAD OF gsc_object_type.               DISABLE TRIGGERS FOR DUMP OF gsc_object_type.
DISABLE TRIGGERS FOR LOAD OF gsc_product_module.            DISABLE TRIGGERS FOR DUMP OF gsc_product_module.
DISABLE TRIGGERS FOR LOAD OF gsc_service_type.              DISABLE TRIGGERS FOR DUMP OF gsc_service_type.
DISABLE TRIGGERS FOR LOAD OF gsc_sequence.                  DISABLE TRIGGERS FOR DUMP OF gsc_sequence.

DISABLE TRIGGERS FOR LOAD OF gsm_comment.                   DISABLE TRIGGERS FOR DUMP OF gsm_comment.
DISABLE TRIGGERS FOR LOAD OF gsm_control_code.              DISABLE TRIGGERS FOR DUMP OF gsm_control_code.
DISABLE TRIGGERS FOR LOAD OF gsm_default_report_format.     DISABLE TRIGGERS FOR DUMP OF gsm_default_report_format.
DISABLE TRIGGERS FOR LOAD OF gsm_external_xref.             DISABLE TRIGGERS FOR DUMP OF gsm_external_xref.
DISABLE TRIGGERS FOR LOAD OF gsm_flow_step.                 DISABLE TRIGGERS FOR DUMP OF gsm_flow_step.
DISABLE TRIGGERS FOR LOAD OF gsm_menu_item.                 DISABLE TRIGGERS FOR DUMP OF gsm_menu_item.
DISABLE TRIGGERS FOR LOAD OF gsm_multi_media.               DISABLE TRIGGERS FOR DUMP OF gsm_multi_media.
DISABLE TRIGGERS FOR LOAD OF gsm_node.                      DISABLE TRIGGERS FOR DUMP OF gsm_node.
DISABLE TRIGGERS FOR LOAD OF gsm_object_menu_structure.     DISABLE TRIGGERS FOR DUMP OF gsm_object_menu_structure.
DISABLE TRIGGERS FOR LOAD OF gsm_required_manager.          DISABLE TRIGGERS FOR DUMP OF gsm_required_manager.
DISABLE TRIGGERS FOR LOAD OF gsm_security_structure.        DISABLE TRIGGERS FOR DUMP OF gsm_security_structure.
DISABLE TRIGGERS FOR LOAD OF gsm_status_history.            DISABLE TRIGGERS FOR DUMP OF gsm_status_history.
DISABLE TRIGGERS FOR LOAD OF gsm_toolbar_menu_structure.    DISABLE TRIGGERS FOR DUMP OF gsm_toolbar_menu_structure.
DISABLE TRIGGERS FOR LOAD OF gsm_translation.               DISABLE TRIGGERS FOR DUMP OF gsm_translation.
DISABLE TRIGGERS FOR LOAD OF gsm_user_allocation.           DISABLE TRIGGERS FOR DUMP OF gsm_user_allocation.
DISABLE TRIGGERS FOR LOAD OF gsm_valid_object_partition.    DISABLE TRIGGERS FOR DUMP OF gsm_valid_object_partition.

DISABLE TRIGGERS FOR LOAD OF gst_audit.                     DISABLE TRIGGERS FOR DUMP OF gst_audit.
DISABLE TRIGGERS FOR LOAD OF gst_record_version.            DISABLE TRIGGERS FOR DUMP OF gst_record_version.
DISABLE TRIGGERS FOR LOAD OF gst_error_log.                 DISABLE TRIGGERS FOR DUMP OF gst_error_log.

DISABLE TRIGGERS FOR LOAD OF ryc_action.                    DISABLE TRIGGERS FOR DUMP OF ryc_action.
DISABLE TRIGGERS FOR DUMP OF ryc_attribute.                 DISABLE TRIGGERS FOR LOAD OF ryc_attribute.
DISABLE TRIGGERS FOR DUMP OF ryc_attribute_value.           DISABLE TRIGGERS FOR LOAD OF ryc_attribute_value.
DISABLE TRIGGERS FOR LOAD OF ryc_object_instance.           DISABLE TRIGGERS FOR DUMP OF ryc_object_instance.
DISABLE TRIGGERS FOR LOAD OF ryc_smartobject.               DISABLE TRIGGERS FOR DUMP OF ryc_smartobject.
DISABLE TRIGGERS FOR LOAD OF ryc_smartlink_type.            DISABLE TRIGGERS FOR DUMP OF ryc_smartlink_type.
DISABLE TRIGGERS FOR DUMP OF ryc_page.                      DISABLE TRIGGERS FOR LOAD OF ryc_page.        


FUNCTION getInstanceName RETURNS CHARACTER
  (pcInstanceName AS CHARACTER
  ,pdInstanceObj  AS DECIMAL
  ) FORWARD.

/* Include the NextObj Fuction */
FUNCTION getNextObj RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.


DEFINE TEMP-TABLE ttAttribute  NO-UNDO
    FIELD tAttributeLabel      AS CHARACTER
    FIELD tDataType            AS INTEGER
    FIELD tCreateAttribute     AS LOGICAL
    .


/* ttAttrInput contains the list of data types that have
   to be converted. */
DEFINE TEMP-TABLE ttAttrInput NO-UNDO
  FIELD cAttributeLabel      AS CHARACTER
  FIELD lExistsV1            AS LOGICAL
  FIELD lExistsV2            AS LOGICAL
  FIELD cV1DataType          AS CHARACTER
  FIELD cV2DataType          AS CHARACTER
  FIELD cAttrTLA             AS CHARACTER
  FIELD iAttrDT              AS INTEGER
  INDEX pudx IS PRIMARY UNIQUE
    cAttributeLabel
.

DEFINE STREAM streamOut.

/*------------------------------------------------------------------------------
  MAIN BLOCK
------------------------------------------------------------------------------*/

RUN createNewData.

RUN updateSourceLanguage.

RUN updateNewFields.

RUN migrateObject.

RUN migrateObjectFLA.

RUN updateSmartobject.

RUN mergeObjects.

RUN updateInstances.

/* Now we go through and remove all attributes that are set to the same value as the
   master or (if not overridden at the master level) the object type. */
RUN cleanUpAttribute.

/* Now we move the data in the attribute_value field into the new appropriate data type */
RUN setAttributeDataType.

RUN fixPageSecurity.

/*------------------------------------------------------------------------------
  INTERNAL PROCEDURES
------------------------------------------------------------------------------*/

PROCEDURE createNewData:
/*-----------------------------------------------------------------------*/
/* Purpose: Adds some extra attributes that we don't have for all        */
/*          objects and associates them with the object type.            */
/*          Also makes all object types an extension of DynamicObject    */
/*  Notes:                                                               */
/*-----------------------------------------------------------------------*/
  DO TRANSACTION:

    /* Find an object type for the dynamic object based on the obj */
    FIND gsc_object_type 
      WHERE gsc_object_type.object_type_obj = 1000000253.48
      NO-ERROR.
    IF NOT AVAILABLE(gsc_object_type) THEN
    DO:
      /* If you can't find it on the obj, try the code */
      FIND gsc_object_type 
        WHERE gsc_object_type.object_type_code = "DynamicObject"
        NO-ERROR.
    END.
    /* If it's not available, create it */
    IF NOT AVAILABLE(gsc_object_type) THEN
    DO:
      CREATE gsc_object_type.
      PUBLISH "DCU_WriteLog":U ("Created Object Type: DynamicObject").
    END.

    ASSIGN
      gsc_object_type.object_type_obj = 1000000253.48
      gsc_object_type.object_type_code = "DynamicObject"
      gsc_object_type.object_type_description = "Dynamic Object"
      gsc_object_type.disabled = no
      gsc_object_type.layout_supported = yes
      gsc_object_type.deployment_type = ""
      gsc_object_type.static_object = no
      gsc_object_type.class_smartobject_obj = 0.0
      gsc_object_type.extends_object_type_obj = 0.0
    .
  
    /* Find an attribute for the folder label based on the obj */
    FIND ryc_attribute 
      WHERE ryc_attribute.attribute_obj = 1000000276.48
      NO-ERROR.
    IF NOT AVAILABLE(ryc_attribute) THEN
    DO:
      /* If you can't find it on the obj, try the label */
      FIND ryc_attribute 
        WHERE ryc_attribute.attribute_label = "FolderLabels"
        NO-ERROR.
    END.
    /* If it's not available, create it */
    IF NOT AVAILABLE(ryc_attribute) THEN
    DO:
      CREATE ryc_attribute.
      PUBLISH "DCU_WriteLog":U ("Created Attribute: FolderLabels").
    END.
    /* Assign the appropriate values */
    ASSIGN
      ryc_attribute.attribute_label = "FolderLabels"
      ryc_attribute.attribute_group_obj = 0.0
      ryc_attribute.data_type = 1
      ryc_attribute.attribute_narrative = "This attribute is used to store the FolderLabels when construct"
      ryc_attribute.override_type = ""
      ryc_attribute.runtime_only = no
      ryc_attribute.is_private = no
      ryc_attribute.constant_level = ""
      ryc_attribute.derived_value = yes
      ryc_attribute.lookup_type = ""
      ryc_attribute.lookup_value = ""
      ryc_attribute.design_only = no
      ryc_attribute.system_owned = no
      ryc_attribute.attribute_obj = 1000000276.48
    .

    /* Find an attribute for the logical version based on the obj */
    FIND ryc_attribute 
      WHERE ryc_attribute.attribute_obj = 1000000272.48
      NO-ERROR.
    IF NOT AVAILABLE(ryc_attribute) THEN
    DO:
      /* If you can't find it on the obj, try the label */
      FIND ryc_attribute 
        WHERE ryc_attribute.attribute_label = "LogicalVersion"
        NO-ERROR.
    END.
    /* If it's not available, create it */
    IF NOT AVAILABLE(ryc_attribute) THEN
    DO:
      CREATE ryc_attribute.
      PUBLISH "DCU_WriteLog":U ("Created Attribute: LogicalVersion").      
    END.

    ASSIGN
      ryc_attribute.attribute_label = "LogicalVersion"
      ryc_attribute.attribute_group_obj = 0.0
      ryc_attribute.data_type = 1
      ryc_attribute.attribute_narrative = "The version of a logical (non-static) object, as stored in the"
      ryc_attribute.override_type = ""
      ryc_attribute.runtime_only = no
      ryc_attribute.is_private = no
      ryc_attribute.constant_level = ""
      ryc_attribute.derived_value = yes
      ryc_attribute.lookup_type = ""
      ryc_attribute.lookup_value = ""
      ryc_attribute.design_only = no
      ryc_attribute.system_owned = no
      ryc_attribute.attribute_obj = 1000000272.48
    .

    /* Create the attribute values that we need. */
    FIND ryc_attribute_value 
      WHERE ryc_attribute_value.attribute_value_obj = 1000000278.48
      NO-ERROR.
    IF NOT AVAILABLE(ryc_attribute_value) THEN
      CREATE ryc_attribute_value.
    
    ASSIGN
      ryc_attribute_value.attribute_value_obj = 1000000278.48
      ryc_attribute_value.object_type_obj = 490.0
      ryc_attribute_value.container_smartobject_obj = 0.0
      ryc_attribute_value.smartobject_obj = 0.0
      ryc_attribute_value.object_instance_obj = 0.0
      ryc_attribute_value.constant_value = no
      ryc_attribute_value.attribute_label = "FolderLabels"
      ryc_attribute_value.character_value = ""
      ryc_attribute_value.integer_value = 0
      ryc_attribute_value.date_value = ?
      ryc_attribute_value.decimal_value = 0.0
      ryc_attribute_value.logical_value = no
      ryc_attribute_value.primary_smartobject_obj = 0.0
    .

    /* Create the attribute values that we need. */
    FIND ryc_attribute_value 
      WHERE ryc_attribute_value.attribute_value_obj = 1000000269.48
      NO-ERROR.
    IF NOT AVAILABLE(ryc_attribute_value) THEN
    DO:
      CREATE ryc_attribute_value.
      PUBLISH "DCU_WriteLog":U ("Created Attribute: LogicalObjectName").
    END.
    ASSIGN
      ryc_attribute_value.attribute_value_obj = 1000000269.48
      ryc_attribute_value.object_type_obj = 1000000253.48
      ryc_attribute_value.container_smartobject_obj = 0.0
      ryc_attribute_value.smartobject_obj = 0.0
      ryc_attribute_value.object_instance_obj = 0.0
      ryc_attribute_value.constant_value = no
      ryc_attribute_value.attribute_label = "LogicalObjectName"
      ryc_attribute_value.character_value = ""
      ryc_attribute_value.integer_value = 0
      ryc_attribute_value.date_value = ?
      ryc_attribute_value.decimal_value = 0.0
      ryc_attribute_value.logical_value = no
      ryc_attribute_value.primary_smartobject_obj = 0.0
    .

    /* Create the attribute values that we need. */
    FIND ryc_attribute_value 
      WHERE ryc_attribute_value.attribute_value_obj = 1000000274.48
      NO-ERROR.
    IF NOT AVAILABLE(ryc_attribute_value) THEN
      CREATE ryc_attribute_value.
    ASSIGN
      ryc_attribute_value.attribute_value_obj = 1000000274.48
      ryc_attribute_value.object_type_obj = 1000000253.48
      ryc_attribute_value.container_smartobject_obj = 0.0
      ryc_attribute_value.smartobject_obj = 0.0
      ryc_attribute_value.object_instance_obj = 0.0
      ryc_attribute_value.constant_value = no
      ryc_attribute_value.attribute_label = "LogicalVersion"
      ryc_attribute_value.character_value = ""
      ryc_attribute_value.integer_value = 0
      ryc_attribute_value.date_value = ?
      ryc_attribute_value.decimal_value = 0.0
      ryc_attribute_value.logical_value = no
      ryc_attribute_value.primary_smartobject_obj = 0.0
    .

  END.

  /* Now make sure that all the object types are extended from the
     DynamicObject object type */
  FOR EACH gsc_object_type 
    WHERE gsc_object_type.object_type_code <> "DynamicObject" :
    ASSIGN 
      gsc_object_type.extends_object_type_Obj = 1000000253.48
    .
  END.

END.


PROCEDURE updateSourceLanguage:
/*-----------------------------------------------------------------------*/
/* Purpose: Update the source language values on related tables          */
/*  Notes:                                                               */
/*-----------------------------------------------------------------------*/

  DEFINE VARIABLE dDefaultLanguageObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dGscLanguageObj     AS DECIMAL    NO-UNDO.

  DEFINE BUFFER b_gsc_error           FOR gsc_error.

  /* First determine the default language value */
  ASSIGN
    dDefaultLanguageObj = 0.

  RUN getDefaultLanguage (OUTPUT dDefaultLanguageObj).
  
  PUBLISH "DCU_WriteLog":U ("Setting Source Language Obj to: " + STRING(dDefaultLanguageObj)).      
  

  /* Assign a default source language to all existing gsm_menu_item records */
  FOR EACH gsm_menu_item EXCLUSIVE-LOCK
    :

    /* Ensure the new obj field value is not null */
    ASSIGN
      gsm_menu_item.source_language_obj  = (IF gsm_menu_item.source_language_obj = ? THEN 0 ELSE gsm_menu_item.source_language_obj)
      dGscLanguageObj                    = 0
      .

    /* Find the appropriate language */
    RUN getGscLanguage (INPUT  gsm_menu_item.source_language_obj
                       ,OUTPUT dGscLanguageObj).

    /* Assign the found language else the default language */
    IF dGscLanguageObj <> 0
    THEN
      ASSIGN
        gsm_menu_item.source_language_obj = dGscLanguageObj.
    ELSE
      ASSIGN
        gsm_menu_item.source_language_obj = dDefaultLanguageObj.

  END.

  /* Assign a default source language to all existing gsm_translation records */
  FOR EACH gsm_translation EXCLUSIVE-LOCK
    :

    /* Ensure the new obj field value is not null */
    ASSIGN
      gsm_translation.source_language_obj = (IF gsm_translation.source_language_obj = ? THEN 0 ELSE gsm_translation.source_language_obj)
      dGscLanguageObj                     = 0
      .

    /* Find the appropriate language */
    RUN getGscLanguage (INPUT  gsm_translation.source_language_obj
                       ,OUTPUT dGscLanguageObj).

    /* Assign the found language else the default language */
    IF dGscLanguageObj <> 0
    THEN
      ASSIGN
        gsm_translation.source_language_obj = dGscLanguageObj.
    ELSE
      ASSIGN
        gsm_translation.source_language_obj = dDefaultLanguageObj.

  END.

  /* Set the source language flag on the appropriate gsc_error record */
  FOR EACH gsc_error EXCLUSIVE-LOCK
    BY gsc_error.error_group
    BY gsc_error.error_number
    :

    /* If equal to the default language set the source language flag to YES */
    IF gsc_error.language_obj = dDefaultLanguageObj
    THEN DO:

      ASSIGN
        gsc_error.source_language = YES.

    END.
    ELSE DO:

      /* Determine if a record exist for the default language or one that already has the source flag set */
      IF CAN-FIND(FIRST b_gsc_error
                  WHERE b_gsc_error.language_obj    = dDefaultLanguageObj
                  AND   b_gsc_error.error_group     = gsc_error.error_group
                  AND   b_gsc_error.error_number    = gsc_error.error_number
                 )
      OR CAN-FIND(FIRST b_gsc_error
                  WHERE b_gsc_error.language_obj    <> gsc_error.language_obj
                  AND   b_gsc_error.error_group     = gsc_error.error_group
                  AND   b_gsc_error.error_number    = gsc_error.error_number
                  AND   b_gsc_error.source_language = YES
                 )
      THEN
        ASSIGN
          gsc_error.source_language = NO.
      ELSE
        ASSIGN
          gsc_error.source_language = YES.

    END.

  END.

END PROCEDURE. /* updateSourceLanguage */


PROCEDURE updateNewFields:
/*-----------------------------------------------------------------------*/
/* Purpose: Update all new field added and correct default values        */
/*  Notes:                                                               */
/*-----------------------------------------------------------------------*/

  PUBLISH "DCU_WriteLog":U ("Populating new field defaults").
  /* Migrate the data from the used_define_link field to the user_defined_link field */
  FOR EACH ryc_smartlink_type EXCLUSIVE-LOCK
    :

    ASSIGN
      ryc_smartlink_type.user_defined_link = ryc_smartlink_type.used_defined_link
      .

  END.

  FOR EACH gsm_session_type EXCLUSIVE-LOCK
    :

    /* Ensure the new obj field value is not null */
    ASSIGN
      gsm_session_type.extends_session_type_obj   = (IF gsm_session_type.extends_session_type_obj   = ? THEN 0 ELSE gsm_session_type.extends_session_type_obj)
      .

  END.

  FOR EACH gsc_product_module EXCLUSIVE-LOCK
    :

    /* Ensure the new obj field value is not null */
    ASSIGN
      gsc_product_module.parent_product_module_obj   = (IF gsc_product_module.parent_product_module_obj   = ? THEN 0 ELSE gsc_product_module.parent_product_module_obj)
      .

  END.

  FOR EACH gsc_object_type EXCLUSIVE-LOCK
    :

    /* Set the static object flag accordingly */
    IF gsc_object_type.object_type_code BEGINS "DYN":U
    THEN
      ASSIGN
        gsc_object_type.static_object = NO.
    ELSE
      ASSIGN
        gsc_object_type.static_object = YES.

    /* Ensure the new obj field values is not null */
    ASSIGN
      gsc_object_type.class_smartobject_obj   = (IF gsc_object_type.class_smartobject_obj   = ? THEN 0 ELSE gsc_object_type.class_smartobject_obj)
      gsc_object_type.extends_object_type_obj = (IF gsc_object_type.extends_object_type_obj = ? THEN 0 ELSE gsc_object_type.extends_object_type_obj)
      .

  END.

END PROCEDURE. /* updateNewFields */


PROCEDURE migrateObject:
/*-----------------------------------------------------------------------*/
/* Purpose: Migrate the gsc_object records to ryc_smartobject table      */
/*  Notes:                                                               */
/*-----------------------------------------------------------------------*/

  DEFINE VARIABLE dRycsmartobjectObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dGscObjectObj       AS DECIMAL    NO-UNDO EXTENT 2.

   /* The extent and initial value must be the same */
  DEFINE VARIABLE iLoopTotal          AS INTEGER    NO-UNDO INITIAL 2. 
  DEFINE VARIABLE iLoopEntry          AS INTEGER    NO-UNDO.
  
  PUBLISH "DCU_WriteLog":U ("Migrating gsc_object to ryc_smartobject...").

  FOR EACH gsc_object NO-LOCK
    :

    ASSIGN
      dRycsmartobjectObj = 0
      dGscObjectObj[1]   = 0
      dGscObjectObj[2]   = 0
      dGscObjectObj[1]   = gsc_object.object_obj
      .

    RUN getRycsmartobject (INPUT  0
                          ,INPUT  gsc_object.object_obj
                          ,INPUT  gsc_object.object_filename
                          ,INPUT  gsc_object.object_extension
                          ,OUTPUT dRycsmartobjectObj
                          ).

    IF dRycsmartobjectObj = 0 THEN 
    DO:
      PUBLISH "DCU_WriteLog":U ("  Creating new ryc_smartobject for " + gsc_object.object_filename).
      CREATE ryc_smartobject.
      ASSIGN
        /* EXISTING */
        ryc_smartobject.smartobject_obj           = gsc_object.object_obj /* getNextObj() - Rather use the current object_obj value */
        ryc_smartobject.object_obj                = gsc_object.object_obj
        ryc_smartobject.object_type_obj           = gsc_object.object_type_obj
        ryc_smartobject.product_module_obj        = gsc_object.product_module_obj
        ryc_smartobject.object_filename           = gsc_object.object_filename
        ryc_smartobject.static_object             = (IF gsc_object.logical_object THEN NO ELSE YES)
        ryc_smartobject.custom_super_procedure    = "":U
        ryc_smartobject.system_owned              = YES
        ryc_smartobject.shutdown_message_text     = "":U
        ryc_smartobject.template_smartobject      = NO
        ryc_smartobject.layout_obj                = 0
        ryc_smartobject.sdo_smartobject_obj       = 0
        /* MERGED*/
        ryc_smartobject.object_description        = gsc_object.object_description
        ryc_smartobject.object_extension          = gsc_object.object_extension
        ryc_smartobject.object_path               = gsc_object.object_path
        ryc_smartobject.runnable_from_menu        = gsc_object.runnable_from_menu
        ryc_smartobject.disabled                  = gsc_object.disabled
        ryc_smartobject.run_persistent            = gsc_object.run_persistent
        ryc_smartobject.run_when                  = gsc_object.run_when
        ryc_smartobject.container_object          = gsc_object.container_object
        ryc_smartobject.generic_object            = gsc_object.generic_object
        ryc_smartobject.required_db_list          = gsc_object.required_db_list
        ryc_smartobject.security_smartobject_obj  = gsc_object.security_object_obj
        ryc_smartobject.physical_smartobject_obj  = gsc_object.physical_object_obj
        /* ADDED */
        ryc_smartobject.customization_result_obj  = 0
        ryc_smartobject.custom_smartobject_obj    = 0
        ryc_smartobject.extends_smartobject_obj   = 0
        ryc_smartobject.deployment_type           = "":U
        ryc_smartobject.design_only               = NO
        .
      ASSIGN
        dRycsmartobjectObj = ryc_smartobject.smartobject_obj
        .
    END.

    FIND FIRST ryc_smartobject EXCLUSIVE-LOCK
      WHERE ryc_smartobject.smartobject_obj = dRycsmartobjectObj
      NO-ERROR.
    IF AVAILABLE ryc_smartobject THEN 
    DO:
      ASSIGN
        /* EXISTING */
        ryc_smartobject.smartobject_obj           = (IF ryc_smartobject.smartobject_obj     = 0     THEN gsc_object.object_obj          ELSE ryc_smartobject.smartobject_obj)
        ryc_smartobject.object_obj                = (IF ryc_smartobject.object_obj          = 0     THEN gsc_object.object_obj          ELSE ryc_smartobject.object_obj)
        ryc_smartobject.object_type_obj           = (IF ryc_smartobject.object_type_obj     = 0     THEN gsc_object.object_type_obj     ELSE ryc_smartobject.object_type_obj)
        ryc_smartobject.product_module_obj        = (IF ryc_smartobject.product_module_obj  = 0     THEN gsc_object.product_module_obj  ELSE ryc_smartobject.product_module_obj)
        ryc_smartobject.object_filename           = (IF ryc_smartobject.object_filename     = "":U  THEN gsc_object.object_filename     ELSE ryc_smartobject.object_filename)
        ryc_smartobject.static_object             = (IF gsc_object.logical_object                   THEN NO                             ELSE YES)
        /* MERGED*/
        ryc_smartobject.object_description        = gsc_object.object_description
        ryc_smartobject.object_extension          = gsc_object.object_extension
        ryc_smartobject.object_path               = gsc_object.object_path
        ryc_smartobject.runnable_from_menu        = gsc_object.runnable_from_menu
        ryc_smartobject.disabled                  = gsc_object.disabled
        ryc_smartobject.run_persistent            = gsc_object.run_persistent
        ryc_smartobject.run_when                  = gsc_object.run_when
        ryc_smartobject.container_object          = gsc_object.container_object
        ryc_smartobject.generic_object            = gsc_object.generic_object
        ryc_smartobject.required_db_list          = gsc_object.required_db_list
        ryc_smartobject.security_smartobject_obj  = gsc_object.security_object_obj
        ryc_smartobject.physical_smartobject_obj  = gsc_object.physical_object_obj
        /* ADDED */
        ryc_smartobject.customization_result_obj  = 0
        ryc_smartobject.extends_smartobject_obj   = 0
        ryc_smartobject.deployment_type           = "":U
        ryc_smartobject.design_only               = NO
        .

      ASSIGN
        dGscObjectObj[2]    = ryc_smartobject.object_obj
        dRycsmartobjectObj  = ryc_smartobject.smartobject_obj
        .

      IF ryc_smartobject.object_obj <> gsc_object.object_obj
      THEN
        ASSIGN
          ryc_smartobject.object_obj = gsc_object.object_obj
          .

    END.

    ASSIGN
      iLoopEntry = 0.

    /* Update Related table*/
    BlkObj:
    REPEAT:

      ASSIGN
        iLoopEntry = iLoopEntry + 1.

      IF iLoopEntry > iLoopTotal THEN 
        LEAVE BlkObj.

      IF dGscObjectObj[iLoopEntry] = 0
      OR dGscObjectObj[iLoopEntry] = dRycsmartobjectObj
      OR (iLoopEntry > 1 AND dGscObjectObj[iLoopEntry] = dGscObjectObj[1]) THEN 
        NEXT BlkObj.

      RUN migrateObjectObj (INPUT dRycsmartobjectObj
                           ,INPUT dGscObjectObj[iLoopEntry]
                           ).
    END. /* loop */

  END.

END PROCEDURE. /* migrateObject */

/* Run from migrateObject */
PROCEDURE migrateObjectObj:
/*-----------------------------------------------------------------------*/
/* Purpose: Migrate the gsc_object obj value to ryc_smartobject obj value*/
/*  Notes:                                                               */
/*-----------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pdRycsmartobjectObj  AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdGscObjectObj       AS DECIMAL    NO-UNDO.

  FOR EACH ryc_action EXCLUSIVE-LOCK
    WHERE  ryc_action.object_obj = pdGscObjectObj:
    ASSIGN ryc_action.object_obj = pdRycsmartobjectObj.
  END.

  FOR EACH gsm_toolbar_menu_structure EXCLUSIVE-LOCK
    WHERE  gsm_toolbar_menu_structure.object_obj = pdGscObjectObj:
    ASSIGN gsm_toolbar_menu_structure.object_obj = pdRycsmartobjectObj.
  END.

  FOR EACH gsm_object_menu_structure EXCLUSIVE-LOCK
    WHERE  gsm_object_menu_structure.object_obj = pdGscObjectObj:
    ASSIGN gsm_object_menu_structure.object_obj = pdRycsmartobjectObj.
  END.

  FOR EACH gsm_security_structure EXCLUSIVE-LOCK
    WHERE  gsm_security_structure.object_obj = pdGscObjectObj:
    ASSIGN gsm_security_structure.object_obj = pdRycsmartobjectObj.
  END.
  
  FOR EACH gsm_menu_item EXCLUSIVE-LOCK
    WHERE  gsm_menu_item.object_obj = pdGscObjectObj:
    ASSIGN gsm_menu_item.object_obj = pdRycsmartobjectObj.
  END.

  FOR EACH gsm_flow_step EXCLUSIVE-LOCK
    WHERE  gsm_flow_step.object_obj = pdGscObjectObj:
    ASSIGN gsm_flow_step.object_obj = pdRycsmartobjectObj.
  END.

  FOR EACH gsm_valid_object_partition EXCLUSIVE-LOCK
    WHERE  gsm_valid_object_partition.object_obj = pdGscObjectObj:
    ASSIGN gsm_valid_object_partition.object_obj = pdRycsmartobjectObj.
  END.

  FOR EACH gsm_required_manager EXCLUSIVE-LOCK
    WHERE  gsm_required_manager.object_obj = pdGscObjectObj:
    ASSIGN gsm_required_manager.object_obj = pdRycsmartobjectObj.
  END.

  FOR EACH gsc_service_type EXCLUSIVE-LOCK
    WHERE  gsc_service_type.management_object_obj = pdGscObjectObj:
    ASSIGN gsc_service_type.management_object_obj = pdRycsmartobjectObj.
  END.

  FOR EACH gsc_service_type EXCLUSIVE-LOCK
    WHERE  gsc_service_type.maintenance_object_obj = pdGscObjectObj:
    ASSIGN gsc_service_type.maintenance_object_obj = pdRycsmartobjectObj.
  END.

  /* Entity Mnemonic - Generic Links */
  FOR EACH gsc_language_text EXCLUSIVE-LOCK
    WHERE  gsc_language_text.owning_obj = pdGscObjectObj:
    ASSIGN gsc_language_text.owning_obj = pdRycsmartobjectObj.
  END.

  FOR EACH gsm_control_code EXCLUSIVE-LOCK
    WHERE  gsm_control_code.owning_obj = pdGscObjectObj:
    ASSIGN gsm_control_code.owning_obj = pdRycsmartobjectObj.
  END.

  FOR EACH gsm_multi_media EXCLUSIVE-LOCK
    WHERE  gsm_multi_media.owning_obj = pdGscObjectObj:
    ASSIGN gsm_multi_media.owning_obj = pdRycsmartobjectObj.
  END.

  FOR EACH gsm_status_history EXCLUSIVE-LOCK
    WHERE  gsm_status_history.owning_obj = pdGscObjectObj:
    ASSIGN gsm_status_history.owning_obj = pdRycsmartobjectObj.
  END.

  FOR EACH gsc_global_default EXCLUSIVE-LOCK
    WHERE  gsc_global_default.owning_obj = pdGscObjectObj:
    ASSIGN gsc_global_default.owning_obj = pdRycsmartobjectObj.
  END.

  FOR EACH gsm_default_report_format EXCLUSIVE-LOCK
    WHERE  gsm_default_report_format.owning_obj = pdGscObjectObj:
    ASSIGN gsm_default_report_format.owning_obj = pdRycsmartobjectObj.
  END.

  FOR EACH gsm_user_allocation EXCLUSIVE-LOCK
    WHERE  gsm_user_allocation.owning_obj = pdGscObjectObj:
    ASSIGN gsm_user_allocation.owning_obj = pdRycsmartobjectObj.
  END.

  FOR EACH gsm_security_structure EXCLUSIVE-LOCK
    WHERE  gsm_security_structure.owning_obj = pdGscObjectObj:
    ASSIGN gsm_security_structure.owning_obj  = pdRycsmartobjectObj.
  END.

  FOR EACH gsc_default_set_usage EXCLUSIVE-LOCK
    WHERE  gsc_default_set_usage.owning_obj = pdGscObjectObj:
    ASSIGN gsc_default_set_usage.owning_obj = pdRycsmartobjectObj.
  END.

  FOR EACH gsm_external_xref EXCLUSIVE-LOCK
    WHERE  gsm_external_xref.related_owning_obj = pdGscObjectObj:
    ASSIGN gsm_external_xref.related_owning_obj = pdRycsmartobjectObj.
  END.

  FOR EACH gsm_external_xref EXCLUSIVE-LOCK
    WHERE  gsm_external_xref.internal_owning_obj = pdGscObjectObj:
    ASSIGN gsm_external_xref.internal_owning_obj = pdRycsmartobjectObj.
  END.

  FOR EACH gsm_external_xref EXCLUSIVE-LOCK
    WHERE  gsm_external_xref.external_owning_obj = pdGscObjectObj:
    ASSIGN gsm_external_xref.external_owning_obj = pdRycsmartobjectObj.
  END.

  FOR EACH gst_error_log EXCLUSIVE-LOCK
    WHERE  gst_error_log.owning_obj = pdGscObjectObj:
    ASSIGN gst_error_log.owning_obj = pdRycsmartobjectObj.
  END.

  FOR EACH gsm_comment EXCLUSIVE-LOCK
    WHERE  gsm_comment.owning_obj = pdGscObjectObj:
    ASSIGN gsm_comment.owning_obj = pdRycsmartobjectObj.
  END.

  FOR EACH gst_audit EXCLUSIVE-LOCK
    WHERE  gst_audit.owning_obj = pdGscObjectObj:
    ASSIGN gst_audit.owning_obj = pdRycsmartobjectObj.
  END.

END PROCEDURE. /* migrateObjects */


PROCEDURE migrateObjectFLA:
/*-----------------------------------------------------------------------*/
/* Purpose: Migrate the gsc_object FLA to ryc_smartobject FLA            */
/*  Notes:                                                               */
/*-----------------------------------------------------------------------*/

  DEFINE VARIABLE cGscobFla           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRycsoFla           AS CHARACTER  NO-UNDO.

  /* Assign the values for variables used in the procedure */
  ASSIGN
    cGscobFla     = "gscob":U
    cRycsoFla     = "rycso":U
    .

  PUBLISH "DCU_WriteLog":U ("Changing FLAs from GSCOB to RYCSO").

  /* Entity Mnemonic - Generic Links */
  FOR EACH gsc_global_default EXCLUSIVE-LOCK
    WHERE  gsc_global_default.owning_entity_mnemonic = cGscobFla:
    ASSIGN gsc_global_default.owning_entity_mnemonic = cRycsoFla.
  END.

  FOR EACH gsm_default_report_format EXCLUSIVE-LOCK
    WHERE  gsm_default_report_format.owning_entity_mnemonic = cGscobFla:
    ASSIGN gsm_default_report_format.owning_entity_mnemonic = cRycsoFla.
  END.

  FOR EACH gsm_user_allocation EXCLUSIVE-LOCK
    WHERE  gsm_user_allocation.owning_entity_mnemonic = cGscobFla:
    ASSIGN gsm_user_allocation.owning_entity_mnemonic = cRycsoFla.
  END.

  FOR EACH gsm_security_structure EXCLUSIVE-LOCK
    WHERE  gsm_security_structure.owning_entity_mnemonic = cGscobFla:
    ASSIGN gsm_security_structure.owning_entity_mnemonic = cRycsoFla.
  END.

  FOR EACH gsc_default_set_usage EXCLUSIVE-LOCK
    WHERE  gsc_default_set_usage.owning_entity_mnemonic = cGscobFla:
    ASSIGN gsc_default_set_usage.owning_entity_mnemonic = cRycsoFla.
  END.

  FOR EACH gsm_external_xref EXCLUSIVE-LOCK
    WHERE  gsm_external_xref.related_entity_mnemonic = cGscobFla:
    ASSIGN gsm_external_xref.related_entity_mnemonic = cRycsoFla.
  END.

  FOR EACH gsm_external_xref EXCLUSIVE-LOCK
    WHERE  gsm_external_xref.internal_entity_mnemonic = cGscobFla:
    ASSIGN gsm_external_xref.internal_entity_mnemonic = cRycsoFla.
  END.

  FOR EACH gsm_external_xref EXCLUSIVE-LOCK
    WHERE  gsm_external_xref.external_entity_mnemonic = cGscobFla:
    ASSIGN gsm_external_xref.external_entity_mnemonic = cRycsoFla.
  END.

  FOR EACH gst_error_log EXCLUSIVE-LOCK
    WHERE  gst_error_log.owning_entity_mnemonic = cGscobFla:
    ASSIGN gst_error_log.owning_entity_mnemonic = cRycsoFla.
  END.

  FOR EACH gsm_comment EXCLUSIVE-LOCK
    WHERE  gsm_comment.owning_entity_mnemonic = cGscobFla:
    ASSIGN gsm_comment.owning_entity_mnemonic = cRycsoFla.
  END.

  FOR EACH gst_audit EXCLUSIVE-LOCK
    WHERE  gst_audit.owning_entity_mnemonic = cGscobFla:
    ASSIGN gst_audit.owning_entity_mnemonic = cRycsoFla.
  END.

  FOR EACH gsc_default_code EXCLUSIVE-LOCK
    WHERE  gsc_default_code.owning_entity_mnemonic = cGscobFla:
    ASSIGN gsc_default_code.owning_entity_mnemonic = cRycsoFla.
  END.

  FOR EACH gsc_entity_mnemonic_procedure EXCLUSIVE-LOCK
    WHERE  gsc_entity_mnemonic_procedure.owning_entity_mnemonic = cGscobFla:
    ASSIGN gsc_entity_mnemonic_procedure.owning_entity_mnemonic = cRycsoFla.
  END.

  FOR EACH gsc_entity_display_field EXCLUSIVE-LOCK
    WHERE  gsc_entity_display_field.entity_mnemonic = cGscobFla:
    ASSIGN gsc_entity_display_field.entity_mnemonic = cRycsoFla.
  END.

  FOR EACH gsm_entity_field EXCLUSIVE-LOCK
    WHERE  gsm_entity_field.owning_entity_mnemonic = cGscobFla:
    ASSIGN gsm_entity_field.owning_entity_mnemonic = cRycsoFla.
  END.

  FOR EACH gsc_sequence EXCLUSIVE-LOCK
    WHERE  gsc_sequence.owning_entity_mnemonic = cGscobFla:
    ASSIGN gsc_sequence.owning_entity_mnemonic = cRycsoFla.
  END.

END PROCEDURE. /* migrateObjectFLA */


PROCEDURE updateSmartobject:
/*-----------------------------------------------------------------------*/
/* Purpose: Update and correct the ryc_smartobject values                */
/*  Notes:                                                               */
/*-----------------------------------------------------------------------*/

  DEFINE VARIABLE iObjEntryInt        AS INTEGER    NO-UNDO.

  DEFINE VARIABLE cObjectName         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectPath         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dRycsmartobjectObj  AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE cCustomObjects      AS CHARACTER  NO-UNDO.

  DEFINE BUFFER b_ryc_smartobject     FOR ryc_smartobject.

  ASSIGN
    cCustomObjects = "customobjects.tmp"
    .

  OUTPUT STREAM streamOut TO VALUE(cCustomObjects).

  FOR EACH b_ryc_smartobject EXCLUSIVE-LOCK
    WHERE b_ryc_smartobject.custom_super_procedure <> "":U:

    ASSIGN
      iObjEntryInt        = 0
      cObjectName         = "":U
      cObjectPath         = "":U
      dRycsmartobjectObj  = 0
      .

    IF NUM-ENTRIES(b_ryc_smartobject.custom_super_procedure,"/":U) > 1 THEN 
    DO:
      ASSIGN
        iObjEntryInt  = NUM-ENTRIES(b_ryc_smartobject.custom_super_procedure,"/":U)
        cObjectName   = ENTRY(iObjEntryInt,b_ryc_smartobject.custom_super_procedure,"/":U)
        cObjectPath   = SUBSTRING(b_ryc_smartobject.custom_super_procedure,1,LENGTH(b_ryc_smartobject.custom_super_procedure) - LENGTH(cObjectName) )
        cObjectPath   = TRIM(REPLACE(cObjectPath,"~\":U,"~/":U),"~/":U)
        .
    END.
    ELSE 
    DO:
      ASSIGN
        cObjectName = b_ryc_smartobject.custom_super_procedure
        cObjectPath = "":U
        .
    END.

    RUN getRycsmartobject (INPUT  0
                          ,INPUT  0
                          ,INPUT  cObjectName
                          ,INPUT  "":U
                          ,OUTPUT dRycsmartobjectObj
                          ).

    FIND FIRST ryc_smartobject EXCLUSIVE-LOCK
      WHERE ryc_smartobject.smartobject_obj = dRycsmartobjectObj
      NO-ERROR.
    IF AVAILABLE ryc_smartobject THEN 
    DO:
      ASSIGN
        b_ryc_smartobject.custom_smartobject_obj  = ryc_smartobject.smartobject_obj
        b_ryc_smartobject.custom_super_procedure  = "":U
        .
    END.

    IF dRycsmartobjectObj = 0
    OR NOT AVAILABLE ryc_smartobject THEN 
    DO:

      EXPORT STREAM streamOut
        b_ryc_smartobject.smartobject_obj
        b_ryc_smartobject.object_obj
        b_ryc_smartobject.object_filename
        b_ryc_smartobject.object_ext
        b_ryc_smartobject.custom_super_procedure
        cObjectName
        cObjectPath
        b_ryc_smartobject.custom_smartobject_obj
        .

    END.

  END.

  OUTPUT STREAM streamOut CLOSE.
  
  IF SEARCH("customobjects.tmp") <> ? THEN
    PUBLISH "DCU_WriteLog":U ("Writing out custom objects to " + SEARCH("customobjects.tmp")).

  PUBLISH "DCU_WriteLog":U ("Checking all ryc_smartobject initial values have been set...").
  FOR EACH ryc_smartobject EXCLUSIVE-LOCK:

    /* Ensure the new obj field values is not null */
    ASSIGN
      ryc_smartobject.layout_obj                = (IF ryc_smartobject.layout_obj                = ? THEN 0 ELSE ryc_smartobject.layout_obj)
      ryc_smartobject.sdo_smartobject_obj       = (IF ryc_smartobject.sdo_smartobject_obj       = ? THEN 0 ELSE ryc_smartobject.sdo_smartobject_obj)
      ryc_smartobject.customization_result_obj  = (IF ryc_smartobject.customization_result_obj  = ? THEN 0 ELSE ryc_smartobject.customization_result_obj)
      ryc_smartobject.custom_smartobject_obj    = (IF ryc_smartobject.custom_smartobject_obj    = ? THEN 0 ELSE ryc_smartobject.custom_smartobject_obj)
      ryc_smartobject.extends_smartobject_obj   = (IF ryc_smartobject.extends_smartobject_obj   = ? THEN 0 ELSE ryc_smartobject.extends_smartobject_obj)
      ryc_smartobject.physical_smartobject_obj  = (IF ryc_smartobject.physical_smartobject_obj  = ? THEN 0 ELSE ryc_smartobject.physical_smartobject_obj)
      ryc_smartobject.security_smartobject_obj  = (IF ryc_smartobject.security_smartobject_obj  = ? THEN ryc_smartobject.smartobject_obj ELSE ryc_smartobject.security_smartobject_obj)
      .

    /* Reset the field to 0 as it is not implemented yet */
    IF ryc_smartobject.extends_smartobject_obj <> 0 THEN
      ASSIGN
        ryc_smartobject.extends_smartobject_obj = 0.

    IF ryc_smartobject.security_smartobject_obj <> 0 THEN 
    DO:

      ASSIGN
        dRycsmartobjectObj = 0.

      RUN getRycsmartobject (INPUT  ryc_smartobject.security_smartobject_obj
                            ,INPUT  ryc_smartobject.security_smartobject_obj
                            ,INPUT  "":U
                            ,INPUT  "":U
                            ,OUTPUT dRycsmartobjectObj
                            ).

      ASSIGN
        ryc_smartobject.security_smartobject_obj  = dRycsmartobjectObj.

    END.

    IF ryc_smartobject.physical_smartobject_obj <> 0 THEN 
    DO:

      ASSIGN
        dRycsmartobjectObj = 0.

      RUN getRycsmartobject (INPUT  ryc_smartobject.physical_smartobject_obj
                            ,INPUT  ryc_smartobject.physical_smartobject_obj
                            ,INPUT  "":U
                            ,INPUT  "":U
                            ,OUTPUT dRycsmartobjectObj
                            ).

      IF dRycsmartobjectObj <> 0 THEN 
      DO:

        ASSIGN
          ryc_smartobject.physical_smartobject_obj   = dRycsmartobjectObj
          .

      END.
      ELSE 
      DO:
        PUBLISH "DCU_WriteLog":U 
          ("  Smartobject: " + ryc_smartobject.object_filename
           + "  * ERROR * Physical Object Record not Available: " 
           + STRING(ryc_smartobject.physical_smartobject_obj)).
        UNDO, NEXT.

      END.

    END.

  END.

END PROCEDURE. /* updateSmartobject */


PROCEDURE mergeObjects:
/*-----------------------------------------------------------------------*/
/* Purpose: Merge instances of gsc_object and ryc_smartobject records    */
/*          and images                                                   */
/*  Notes:                                                               */
/*-----------------------------------------------------------------------*/

  DEFINE VARIABLE dRycsmartobjectObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cGscobObject        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRycsoObject        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cImageAfBmp         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cImageRyImg         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lReset              AS LOGICAL    NO-UNDO.

  DEFINE BUFFER b_ryc_smartobject     FOR ryc_smartobject.

  /* Assign the values for variables used in the procedure */
  ASSIGN
    dRycsmartobjectObj  = 0
    cGscobObject        = "gscobful2o.w":U
    cRycsoObject        = "rycsoful2o.w":U
    cImageAfBmp         = "af/bmp":U
    cImageRyImg         = "ry/img":U
    .

  PUBLISH "DCU_WriteLog":U ("Merging gsc_object and ryc_smartobject...").

  /* Replace gsc_object with ryc_smartobject records */
  FIND ryc_smartobject NO-LOCK
    WHERE ryc_smartobject.object_filename = cRycsoObject
    NO-ERROR.
  IF AVAILABLE ryc_smartobject THEN
    ASSIGN
      dRycsmartobjectObj = ryc_smartobject.smartobject_obj
      .
  RELEASE ryc_smartobject.

  /* Repoint any browsers or viewers using the gsc_object with ryc_smartobject records */
  FIND b_ryc_smartobject NO-LOCK
    WHERE b_ryc_smartobject.object_filename = cGscobObject
    NO-ERROR.
  IF dRycsmartobjectObj <> 0
  AND AVAILABLE b_ryc_smartobject THEN 
  DO:

    FOR EACH ryc_smartobject EXCLUSIVE-LOCK
      WHERE ROWID(ryc_smartobject) <> ROWID(b_ryc_smartobject)
      :
      lReset = NO.

      IF ryc_smartobject.sdo_smartobject_obj = b_ryc_smartobject.smartobject_obj THEN
        ASSIGN
          ryc_smartobject.sdo_smartobject_obj = dRycsmartobjectObj
          lReset = YES.

      IF ryc_smartobject.custom_smartobject_obj = b_ryc_smartobject.smartobject_obj THEN
        ASSIGN
          ryc_smartobject.custom_smartobject_obj = dRycsmartobjectObj
          lReset = YES.

      IF ryc_smartobject.physical_smartobject_obj = b_ryc_smartobject.smartobject_obj THEN
        ASSIGN
          ryc_smartobject.physical_smartobject_obj = dRycsmartobjectObj
          lReset = YES.

      IF ryc_smartobject.security_smartobject_obj = b_ryc_smartobject.smartobject_obj THEN
        ASSIGN
          ryc_smartobject.security_smartobject_obj = dRycsmartobjectObj
          lReset = YES.

      IF ryc_smartobject.extends_smartobject_obj = b_ryc_smartobject.smartobject_obj THEN
        ASSIGN
          ryc_smartobject.extends_smartobject_obj = dRycsmartobjectObj
          lReset = YES.

      IF lReset THEN    
        PUBLISH "DCU_WriteLog":U ("  Reset SDO for Object: " + ryc_smartobject.object_filename).
      
    END.

    FOR EACH ryc_object_instance EXCLUSIVE-LOCK
      WHERE ryc_object_instance.smartobject_obj = b_ryc_smartobject.smartobject_obj:
      ASSIGN
        ryc_object_instance.smartobject_obj = dRycsmartobjectObj.
    END.

  END.

  FOR EACH gsm_node EXCLUSIVE-LOCK:

    /* Repoint treeview nodes usiong the gsc_object with ryc_smartobject records */
    IF gsm_node.primary_sdo = cGscobObject THEN
      ASSIGN
        gsm_node.primary_sdo = cRycsoObject
        .

    IF gsm_node.data_source = cGscobObject THEN
      ASSIGN
        gsm_node.data_source = cRycsoObject
        .

    /* Repoint any foreign fields or label text substitution fields in the treeview using gsc_object */
    IF gsm_node.primary_sdo = cRycsoObject
    OR gsm_node.data_source = cRycsoObject THEN
      ASSIGN
        gsm_node.foreign_fields                 = REPLACE(gsm_node.foreign_fields                 , "gsc_object.object_obj","ryc_smartobject.smartobject_obj")
        gsm_node.foreign_fields                 = REPLACE(gsm_node.foreign_fields                 , "gsc_object","ryc_smartobject")
        gsm_node.foreign_fields                 = REPLACE(gsm_node.foreign_fields                 , "ryc_smartobject_type","gsc_object_type")
        gsm_node.label_text_substitution_fields = REPLACE(gsm_node.label_text_substitution_fields , "gsc_object.object_obj","ryc_smartobject.smartobject_obj")
        gsm_node.label_text_substitution_fields = REPLACE(gsm_node.label_text_substitution_fields , "gsc_object","ryc_smartobject")
        gsm_node.label_text_substitution_fields = REPLACE(gsm_node.label_text_substitution_fields , "ryc_smartobject_type","gsc_object_type")
        .

    /* Update gsm_node image paths */
    IF gsm_node.image_file_name          BEGINS cImageAfBmp
    OR gsm_node.selected_image_file_name BEGINS cImageAfBmp THEN 
    DO:

      ASSIGN
        gsm_node.image_file_name          = REPLACE(gsm_node.image_file_name,cImageAfBmp,cImageRyImg)
        gsm_node.selected_image_file_name = REPLACE(gsm_node.selected_image_file_name,cImageAfBmp,cImageRyImg)
        .

    END.

  END.

  FOR EACH gsm_multi_media EXCLUSIVE-LOCK:

    /* Update gsm_multi_media paths */
    IF gsm_multi_media.physical_file_name BEGINS cImageAfBmp THEN 
    DO:
      ASSIGN
        gsm_multi_media.physical_file_name = REPLACE(gsm_multi_media.physical_file_name,cImageAfBmp,cImageRyImg)
        .
    END.

  END.

END PROCEDURE. /* mergeObjects */

PROCEDURE updateInstances:
/*-----------------------------------------------------------------------*/
/* Purpose: Update the object instance values                            */
/*  Notes:                                                               */
/*-----------------------------------------------------------------------*/

  DEFINE VARIABLE cObjectInstanceName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectName         AS CHARACTER  NO-UNDO.

  /* Assign the default values for the new instance fields */
  FOR EACH ryc_object_instance EXCLUSIVE-LOCK:

    ASSIGN
      cObjectInstanceName = "":U
      cObjectName         = "":U
      .

    IF cObjectName = "":U THEN 
    DO:
      FIND FIRST ryc_smartobject NO-LOCK
        WHERE ryc_smartobject.smartobject_obj = ryc_object_instance.smartobject_obj
        NO-ERROR.
      IF AVAILABLE ryc_smartobject
      THEN
        ASSIGN
          cObjectName = ryc_smartobject.object_filename.
    END.

    IF cObjectName = "":U THEN 
    DO:
      FIND FIRST ryc_smartobject NO-LOCK
        WHERE ryc_smartobject.smartobject_obj = ryc_object_instance.container_smartobject_obj
        NO-ERROR.
      IF AVAILABLE ryc_smartobject
      THEN
        ASSIGN
          cObjectName = ryc_smartobject.object_filename.
    END.

    ASSIGN
      cObjectInstanceName = getInstanceName(cObjectName,ryc_object_instance.object_instance_obj)
      .

    ASSIGN
      ryc_object_instance.instance_name         = cObjectInstanceName
      ryc_object_instance.instance_description  = cObjectInstanceName
      .

  END.

END PROCEDURE. /* updateInstances */


PROCEDURE cleanUpAttribute:
/*-----------------------------------------------------------------------*/
/* Purpose: Remove cascaded attributes.                                  */
/*  Notes:                                                               */
/*-----------------------------------------------------------------------*/

  DEFINE VARIABLE lDelete                 AS LOGICAL      NO-UNDO.

  DEFINE BUFFER b1_ryc_attribute_value    FOR ryc_attribute_value.
  DEFINE BUFFER b2_ryc_attribute_value    FOR ryc_attribute_value.
  
  PUBLISH "DCU_WriteLog":U ("Cleaning up attribute values...").

  
  /* Loop through all object types */
  FOR EACH gsc_object_type NO-LOCK:

    /* Loop through all masters for the object type */
    FOR EACH ryc_smartobject NO-LOCK
      WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj:

      
      /* Loop through all the instances of the master */
      FOR EACH ryc_object_instance NO-LOCK
        WHERE ryc_object_instance.smartobject_obj = ryc_smartobject.smartobject_obj:

        /* Loop through all attributes of the instance. */
        FOR EACH ryc_attribute_value EXCLUSIVE-LOCK
          WHERE ryc_attribute_value.object_type_obj           = ryc_smartobject.object_type_obj
          AND   ryc_attribute_value.smartobject_obj           = ryc_smartobject.smartobject_obj
          AND   ryc_attribute_value.object_instance_obj       = ryc_object_instance.object_instance_obj
          AND   ryc_attribute_value.container_smartobject_obj = ryc_object_instance.container_smartobject_obj
          ,FIRST ryc_attribute NO-LOCK
            WHERE ryc_attribute.attribute_label = ryc_attribute_value.attribute_label:

          ASSIGN
            lDelete = NO.

          /* Find the corresponding attribute value for the master */ 
          FIND FIRST b1_ryc_attribute_value NO-LOCK
            WHERE b1_ryc_attribute_value.object_type_obj           = ryc_smartobject.object_type_obj
            AND   b1_ryc_attribute_value.smartobject_obj           = ryc_smartobject.smartobject_obj
            AND   b1_ryc_attribute_value.object_instance_obj       = 0
            AND   b1_ryc_attribute_value.container_smartobject_obj = 0
            AND   b1_ryc_attribute_value.attribute_label           = ryc_attribute_value.attribute_label 
            NO-ERROR.
            
          /* If we have found an attribute value for the instance, delete the instance attribute
             if it has the same value as the master. */
          IF AVAILABLE b1_ryc_attribute_value THEN 
          DO:

            /* Values are the same */
            ASSIGN
              lDelete = (ryc_attribute_value.attribute_value = b1_ryc_attribute_value.attribute_value).
            IF lDelete THEN 
            DO:
              DELETE ryc_attribute_value NO-ERROR.
              IF ERROR-STATUS:ERROR
              OR RETURN-VALUE <> "":U THEN
              DO:
                PUBLISH "DCU_WriteLog":U 
                  ("  Delete failed for Class: " + gsc_object_type.object_type_code
                   + "  Master: " + ryc_smartobject.object_filename
                   + "  Instance: " + ryc_object_instance.instance_name
                   + "  Attribute: " + ryc_attribute.attribute_label
                   + " **RETURN-VALUE: " + RETURN-VALUE
                  ).
                  UNDO, NEXT.
              END.
            END.    /* delete attribute value. */

          END.    /* avail b1_ryc_attribute_value (master of instance) */

        END.    /* each attribute value for instance  */

      END.    /* each object instance. */

      /* Loop through the master attributes. */
      FOR EACH ryc_attribute_value EXCLUSIVE-LOCK
        WHERE ryc_attribute_value.object_type_obj           = ryc_smartobject.object_type_obj
        AND   ryc_attribute_value.smartobject_obj           = ryc_smartobject.smartobject_obj
        AND   ryc_attribute_value.object_instance_obj       = 0
        AND   ryc_attribute_value.container_smartobject_obj = 0
        ,FIRST ryc_attribute NO-LOCK
          WHERE ryc_attribute.attribute_label = ryc_attribute_value.attribute_label
        :

        ASSIGN
          lDelete = NO.
          
        /* Find the corresponding attribute on the object type. */  
        FIND FIRST b1_ryc_attribute_value NO-LOCK
          WHERE b1_ryc_attribute_value.object_type_obj           = ryc_smartobject.object_type_obj
          AND   b1_ryc_attribute_value.smartobject_obj           = 0
          AND   b1_ryc_attribute_value.object_instance_obj       = 0
          AND   b1_ryc_attribute_value.container_smartobject_obj = 0
          AND   b1_ryc_attribute_value.attribute_label           = ryc_attribute_value.attribute_label
          NO-ERROR.
          
        /* If we find the attribute on the object type and the values are the same, delete it */
        IF AVAILABLE b1_ryc_attribute_value THEN 
        DO:
          /* Values are the same */
          ASSIGN
            lDelete = (ryc_attribute_value.attribute_value = b1_ryc_attribute_value.attribute_value).
        END.    /* avail b1_ryc_attribute_value (class of master) */
        
        IF lDelete THEN 
        DO:

          DELETE ryc_attribute_value NO-ERROR.
          IF ERROR-STATUS:ERROR
          OR RETURN-VALUE <> "":U
          THEN
          DO:
            PUBLISH "DCU_WriteLog":U 
              ("  Delete failed for Class: " + gsc_object_type.object_type_code
               + "  Master: " + ryc_smartobject.object_filename
               + "  Attribute: " + ryc_attribute.attribute_label
               + " **RETURN-VALUE: " + RETURN-VALUE
              ).
            UNDO, NEXT.
          END.

        END.    /* delete attribute value. */

      END.    /* each attribute value  for master object */

    END.    /* each master smartobject */

  END.    /* object type. */

END PROCEDURE.  /* cleanUpAttribute. */

PROCEDURE setAttributeDataType:
/*-----------------------------------------------------------------------*/
/* Purpose: Sets the data type for an attribute, and ensures that the    */
/*          correct field is set to the correct value, based on the      */
/*          data_type.                                                   */
/* Notes:                                                                */
/*-----------------------------------------------------------------------*/

  DEFINE BUFFER ryc_attribute     FOR ryc_attribute.
  DEFINE BUFFER bttAttrInput      FOR ttAttrInput.

  DEFINE VARIABLE cAttrFile       AS CHARACTER NO-UNDO.

  PUBLISH "DCU_WriteLog":U ("Resetting attribute data types...").

  cAttrFile = SEARCH("db/icf/dfd/v1v2attrtype.d").

  IF cAttrFile <> ? THEN
  DO:
    INPUT FROM VALUE(cAttrFile) NO-ECHO.
    PUBLISH "DCU_WriteLog":U ("  Version 2 attribute data type file found at " + cAttrFile).
    REPEAT:
      CREATE bttAttrInput.
      IMPORT bttAttrInput.
    END.
  END.
  ELSE
    PUBLISH "DCU_WriteLog":U ("  **Version 2 attribute data type file db/icf/dfd/v1v2attrtype.d not found").

  
  FOR EACH ryc_attribute EXCLUSIVE-LOCK:

    FIND FIRST bttAttrInput 
      WHERE bttAttrInput.cAttributeLabel = ryc_attribute.attribute_label
      NO-ERROR.
    IF AVAILABLE(bttAttrInput) THEN
    DO:
      ASSIGN ryc_attribute.data_type = bttAttrInput.iAttrDT.
    END.
    ELSE
    DO:
      FIND FIRST ryc_attribute_value NO-LOCK
        WHERE ryc_attribute_value.attribute_label = ryc_attribute.attribute_label
        NO-ERROR.
      IF AVAILABLE ryc_attribute_value THEN
        CASE ryc_attribute_value.attribute_type_tla:
          WHEN "CHARACTER" OR
          WHEN "CHAR" OR
          WHEN "CHR"
            THEN ASSIGN ryc_attribute.data_type = 1.
          WHEN "DATE" OR
          WHEN "DAT"
            THEN ASSIGN ryc_attribute.data_type = 2.
          WHEN "LOGICAL" OR
          WHEN "LOG"
            THEN ASSIGN ryc_attribute.data_type = 3.
          WHEN "INTEGER" OR
          WHEN "INT"
            THEN ASSIGN ryc_attribute.data_type = 4.
          WHEN "DECIMAL" OR
          WHEN "DEC"
            THEN ASSIGN ryc_attribute.data_type = 5.
          WHEN "RECID" OR
          WHEN "REC"
            THEN ASSIGN ryc_attribute.data_type = 7.
          WHEN "RAW"
            THEN ASSIGN ryc_attribute.data_type = 8.
          WHEN "ROWID" OR
          WHEN "ROW"
            THEN ASSIGN ryc_attribute.data_type = 9.
          WHEN "HANDLE" OR
          WHEN "HNDL"
            THEN ASSIGN ryc_attribute.data_type = 10.
          OTHERWISE 
            ASSIGN ryc_attribute.data_type = 1.
        END CASE.
      ELSE
        ASSIGN
          ryc_attribute.data_type = 1.
    END.

    FOR EACH ryc_attribute_value EXCLUSIVE-LOCK
      WHERE ryc_attribute_value.attribute_label = ryc_attribute.attribute_label:

      CASE ryc_attribute.data_type:
        WHEN 2
          THEN ASSIGN ryc_attribute_value.date_value      = DATE(ryc_attribute_value.attribute_value) NO-ERROR.
        WHEN 3
          THEN ASSIGN ryc_attribute_value.logical_value   = (IF ryc_attribute_value.attribute_value = "YES"
                                                             OR ryc_attribute_value.attribute_value = "TRUE"
                                                             THEN YES ELSE NO) NO-ERROR.
        WHEN 4
          THEN ASSIGN ryc_attribute_value.integer_value   = INTEGER(ryc_attribute_value.attribute_value) NO-ERROR.
        WHEN 5
          THEN ASSIGN ryc_attribute_value.decimal_value   = DECIMAL(ryc_attribute_value.attribute_value) NO-ERROR.
        WHEN 8
          THEN ASSIGN ryc_attribute_value.raw_value       = ? NO-ERROR.
        OTHERWISE DO:
          ASSIGN ryc_attribute_value.character_value = ryc_attribute_value.attribute_value NO-ERROR.
        END.
      END CASE.   /* data type */

      IF ryc_attribute_value.container_smartobject_obj > 0 THEN
        ASSIGN ryc_attribute_value.primary_smartobject_obj = ryc_attribute_value.container_smartobject_obj.
      ELSE
        ASSIGN ryc_attribute_value.primary_smartobject_obj = ryc_attribute_value.smartobject_obj.

      VALIDATE ryc_attribute_value NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
      DO:
        PUBLISH "DCU_WriteLog":U 
          ("  Write failed for Attribute: " + ryc_attribute.attribute_label
           + " **RETURN-VALUE: " + RETURN-VALUE
          ).
        UNDO, NEXT.
      END.

    END.    /* each b1_ryc_attribute_value */

  END.    /* each rycat */

END PROCEDURE.  /* setAttributeDataType */

/* Internal Procedure */

PROCEDURE fixPageSecurity:
  /*------------------------------------------------------------------------------
    Purpose:  Resets the page level security.
      Notes:  
  ------------------------------------------------------------------------------*/
  PUBLISH "DCU_WriteLog":U ("Fixing page security...").

  FOR EACH ryc_page 
    WHERE ryc_page.security_token EQ ''
    EXCLUSIVE-LOCK:
    
    ASSIGN ryc_page.security_token = ryc_page.page_label.
    
  END.
END.


/* Internal Procedure */

PROCEDURE getDefaultLanguage:
/*------------------------------------------------------------------------------
  Purpose:  Get the default language obj value
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER opcDefaultLanguageObj AS DECIMAL              NO-UNDO.

  DEFINE BUFFER pb_gsc_language        FOR gsc_language.

  ASSIGN
    opcDefaultLanguageObj = 0.

  FIND FIRST gsc_global_control NO-LOCK
    NO-ERROR.
  IF AVAILABLE gsc_global_control THEN 
  DO:
    FIND FIRST pb_gsc_language NO-LOCK
      WHERE pb_gsc_language.language_obj = gsc_global_control.default_language_obj
      NO-ERROR.
    IF AVAILABLE pb_gsc_language THEN
      ASSIGN
        opcDefaultLanguageObj = pb_gsc_language.language_obj.
  END.

  IF opcDefaultLanguageObj = 0 THEN 
  DO:
    FIND FIRST pb_gsc_language NO-LOCK
      WHERE pb_gsc_language.language_code = "English":U
      NO-ERROR.
    IF AVAILABLE pb_gsc_language THEN
      ASSIGN
        opcDefaultLanguageObj = pb_gsc_language.language_obj.

  END.

END PROCEDURE.



PROCEDURE getGscLanguage:
/*------------------------------------------------------------------------------
  Purpose:  Determine if a language obj is valid else returnd the default language obj value
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER ipcGscLanguageObj AS DECIMAL              NO-UNDO.
  DEFINE OUTPUT PARAMETER opcGscLanguageObj AS DECIMAL              NO-UNDO.

  DEFINE BUFFER pb_gsc_language        FOR gsc_language.

  ASSIGN
    opcGscLanguageObj = 0.

  FIND FIRST pb_gsc_language NO-LOCK
    WHERE pb_gsc_language.language_obj = ipcGscLanguageObj
    NO-ERROR.
  IF AVAILABLE pb_gsc_language THEN
    ASSIGN
      opcGscLanguageObj = pb_gsc_language.language_obj.

  IF opcGscLanguageObj = 0 THEN
    RUN getDefaultLanguage (OUTPUT opcGscLanguageObj).

END PROCEDURE.



PROCEDURE getRycsmartobject:
/*------------------------------------------------------------------------------
  Purpose:  determine if a ryc_smartobject or gsc_object record is available
            depending on the passed in values
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER ipcRycsmartobjectObj    AS DECIMAL              NO-UNDO.
  DEFINE INPUT  PARAMETER ipcGscObjectObj         AS DECIMAL              NO-UNDO.
  DEFINE INPUT  PARAMETER ipcGscObjectName        AS CHARACTER            NO-UNDO.
  DEFINE INPUT  PARAMETER ipcGscObjectExt         AS CHARACTER            NO-UNDO.
  DEFINE OUTPUT PARAMETER opcRycObjectObj         AS DECIMAL              NO-UNDO.

  DEFINE BUFFER pb_ryc_smartobject     FOR ryc_smartobject.

  ASSIGN
    opcRycObjectObj = 0.

  IF opcRycObjectObj = 0
  AND ipcRycsmartobjectObj <> 0 THEN 
  DO:
    FIND FIRST pb_ryc_smartobject NO-LOCK
      WHERE pb_ryc_smartobject.smartobject_obj = ipcRycsmartobjectObj
      NO-ERROR.
    IF AVAILABLE pb_ryc_smartobject THEN
      ASSIGN
        opcRycObjectObj = pb_ryc_smartobject.smartobject_obj.
  END.

  IF opcRycObjectObj = 0
  AND ipcGscObjectObj <> 0 THEN 
  DO:
    FIND FIRST pb_ryc_smartobject NO-LOCK
      WHERE pb_ryc_smartobject.object_obj = ipcGscObjectObj
      NO-ERROR.
    IF AVAILABLE pb_ryc_smartobject THEN
      ASSIGN
        opcRycObjectObj = pb_ryc_smartobject.smartobject_obj.
  END.

  IF opcRycObjectObj = 0
  AND TRIM(ipcGscObjectName) <> "":U THEN 
  DO:
    FIND FIRST pb_ryc_smartobject NO-LOCK
      WHERE pb_ryc_smartobject.object_filename = TRIM(ipcGscObjectName)
      NO-ERROR.
    IF AVAILABLE pb_ryc_smartobject THEN
      ASSIGN
        opcRycObjectObj = pb_ryc_smartobject.smartobject_obj.
  END.

  IF opcRycObjectObj = 0
  AND TRIM(ipcGscObjectName) <> "":U
  AND TRIM(ipcGscObjectExt)  <> "":U THEN 
  DO:
    FIND FIRST pb_ryc_smartobject NO-LOCK
      WHERE pb_ryc_smartobject.object_filename = TRIM(ipcGscObjectName,".":U) + "." + TRIM(ipcGscObjectExt,".":U)
      NO-ERROR.
    IF AVAILABLE pb_ryc_smartobject THEN
      ASSIGN
        opcRycObjectObj = pb_ryc_smartobject.smartobject_obj.
  END.

END PROCEDURE.

/*------------------------------------------------------------------------------
  FUNCTIONS
------------------------------------------------------------------------------*/

FUNCTION getInstanceName RETURNS CHARACTER
  (pcInstanceName AS CHARACTER
  ,pdInstanceObj  AS DECIMAL
  ):
/*------------------------------------------------------------------------------
  Purpose:  To return the next available unique object instance name.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cInstanceName       AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cInstancePrefix     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cInstanceSuffix     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iInstanceNumber     AS INTEGER    NO-UNDO.

  DEFINE VARIABLE cInstanceHalf       AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iRightValue         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLeftValue          AS INTEGER    NO-UNDO.

  DEFINE BUFFER b_ryc_object_instance FOR ryc_object_instance.
  DEFINE BUFFER c_ryc_object_instance FOR ryc_object_instance.

  FIND FIRST b_ryc_object_instance NO-LOCK
    WHERE b_ryc_object_instance.object_instance_obj = pdInstanceObj
    NO-ERROR.

  ASSIGN
    cInstancePrefix = "":U
    cInstanceSuffix = "":U
    iRightValue     = R-INDEX(pcInstanceName, ")":U)
    iLeftValue      = R-INDEX(pcInstanceName, "(":U)
    .

  IF  iRightValue <> 0
  AND iLeftValue  <> 0
  AND iRightValue  > iLeftValue THEN 
  DO:

    ASSIGN
      iInstanceNumber = INTEGER( SUBSTRING(pcInstanceName, iLeftValue + 1, iRightValue - iLeftValue - 1) )
      NO-ERROR.

    IF ERROR-STATUS:ERROR = FALSE THEN 
    DO:
      ASSIGN
        cInstancePrefix = TRIM( SUBSTRING(pcInstanceName, 1, iLeftValue - 1) )
        cInstanceSuffix = TRIM( SUBSTRING(pcInstanceName, iRightValue + 1) )
        .
    END.
    ELSE 
    DO:
      ASSIGN
        cInstancePrefix = TRIM(pcInstanceName)
        cInstanceSuffix = "":U
        iInstanceNumber = 0
        .
    END.

  END.
  ELSE 
  DO:
    ASSIGN
      cInstancePrefix = TRIM(pcInstanceName)
      cInstanceSuffix = "":U
      iInstanceNumber = 0
      .
  END.

  ERROR-STATUS:ERROR = FALSE.

  blkUniqueName:
  REPEAT:

    ASSIGN
      cInstanceName = cInstancePrefix
                    + (IF iInstanceNumber > 0
                       THEN "(":U + TRIM(STRING(iInstanceNumber)) + ")":U
                       ELSE "":U
                      )
                    + cInstanceSuffix.

    IF NOT CAN-FIND(FIRST c_ryc_object_instance
                    WHERE c_ryc_object_instance.container_smartobject_obj = b_ryc_object_instance.container_smartobject_obj
                    AND   c_ryc_object_instance.instance_name             = cInstanceName
                    AND   c_ryc_object_instance.object_instance_obj      <> b_ryc_object_instance.object_instance_obj
                    )
    THEN
      LEAVE blkUniqueName.

    ASSIGN
      iInstanceNumber = iInstanceNumber + 1.

  END.

  RETURN cInstanceName.   /* Function return value. */

END FUNCTION.



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

  IF iSeqObj1 = 0 THEN
    ASSIGN
      iSeqObj2 = NEXT-VALUE(seq_obj2,ICFDB).

  ASSIGN
    dSeqNext = DECIMAL((iSeqObj2 * 1000000000.0) + iSeqObj1)
    .

  IF  iSeqSiteDiv <> 0
  AND iSeqSiteRev <> 0 THEN
    ASSIGN
      dSeqNext = dSeqNext + (iSeqSiteRev / iSeqSiteDiv).

  RETURN dSeqNext. /* Function return value */

END FUNCTION.
