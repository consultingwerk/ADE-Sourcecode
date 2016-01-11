/*------------------------------------------------------------------
  File: MigrateEntityFieldstoDataFields.p

  Description:  Migrate EntityFields to DataFields

  Purpose:      To migrate attributes from EntityFields to 
                DataField Masters.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        9041   UserRef:    
                Date:   24/03/2003  

  Update Notes: This Fix Migrates The Attributes FORMAT, LABEL, Order,
                and ColumnLabel from the EntityFields to DataField
                Masters.

--------------------------------------------------------------------*/

DEFINE VARIABLE cAttributes AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCounter    AS INTEGER    NO-UNDO.

ASSIGN cAttributes = "FORMAT,LABEL,Order,ColumnLabel":U.

/* Go through the entity_display_fields */
FOR EACH gsc_entity_mnemonic NO-LOCK,
  EACH gsc_entity_display_field NO-LOCK
    WHERE gsc_entity_display_field.entity_mnemonic = gsc_entity_mnemonic.entity_mnemonic:
  
    /* Find the smartObject MASTER for the field */
    FIND FIRST ryc_smartobject NO-LOCK
         WHERE ryc_smartobject.object_filename          = gsc_entity_mnemonic.entity_mnemonic_description
                                                        + '.' + gsc_entity_display_field.display_field_name
           AND ryc_smartobject.customization_result_obj = 0.00
      NO-ERROR.
      
    IF AVAILABLE ryc_smartobject THEN
    DO:
    
      /* For each Attribute we want to Migrate */ 
      DO iCounter = 1 TO NUM-ENTRIES(cAttributes):
      
        /* find the Attribute value we want to oveerride */
        FIND FIRST ryc_attribute_value EXCLUSIVE-LOCK
            WHERE ryc_attribute_value.object_type_obj     = ryc_smartobject.object_type_obj
              AND ryc_attribute_value.smartobject_obj     = ryc_smartobject.smartobject_obj
              AND ryc_attribute_value.object_instance_obj = 0.00
              AND ryc_attribute_value.attribute_label     = ENTRY(iCounter, cAttributes)
              NO-ERROR.
            
        IF NOT AVAILABLE ryc_attribute_value THEN
        DO:
          CREATE ryc_attribute_value NO-ERROR.
          ASSIGN ryc_attribute_value.smartobject_obj             = ryc_smartobject.smartobject_obj
               /*ryc_attribute_value.raw_value                   = invalid - cannot assign                */
               /*ryc_attribute_value.primary_smartobject_obj     = taken care of by trigger               */
                 ryc_attribute_value.object_type_obj             = ryc_smartobject.object_type_obj
                 ryc_attribute_value.object_instance_obj         = 0.00
               /*ryc_attribute_value.logical_value               = invalid - cannot assign                */
               /*ryc_attribute_value.integer_value               = taken care of by Case  statement below */
               /*ryc_attribute_value.decimal_value               = invalid - cannot Assign                */
               /*ryc_attribute_value.date_value                  = invalid - cannot Assign                */
                 ryc_attribute_value.container_smartobject_obj   = 0.00
               /*ryc_attribute_value.constant_value              = invalid - cannot Assign                */
               /*ryc_attribute_value.character_value             = taken care of by Case statement below  */
               /*ryc_attribute_value.attribute_value_obj         = taken care of by trigger               */
                 ryc_attribute_value.attribute_label             = ENTRY(iCounter, cAttributes)
                 NO-ERROR.
                 
          /* To publish errors to the DCU, if it is running in the DCU         
          IF ERROR-STATUS:ERROR THEN
          DO:
            PUBLISH "DCU_WriteLog":U ("Error creating Attribute Values record for object":U + ryc_smartobject.object_filename).
            ERROR-STATUS:ERROR = FALSE.
          END.
          */
                 
        END.

        /* Transfer the relevant attributes from entity_display_fields to the MASTER
           datafield smartObject Attributes                                          */
        CASE ENTRY(iCounter, cAttributes):
          WHEN "FORMAT":U       THEN
            ASSIGN ryc_attribute_value.character_value = gsc_entity_display_field.display_field_format.
          WHEN "LABEL":U        THEN
            ASSIGN ryc_attribute_value.character_value = gsc_entity_display_field.display_field_label.
          WHEN "Order":U        THEN
            ASSIGN ryc_attribute_value.integer_value   = gsc_entity_display_field.display_field_order.
          WHEN "ColumnLabel":U  THEN
            ASSIGN ryc_attribute_value.character_value = gsc_entity_display_field.display_field_column_label.
        END CASE.
        
      END.  /*for each Attribute to be changed */
       
    END.   /* if a dataField is available */
       
END. /*for each gsc_enetity_display_field  record  */


