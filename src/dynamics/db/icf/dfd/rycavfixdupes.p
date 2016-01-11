/* Remove duplicate attribute values */
/* A D Swindells 04/16/02 */
/* Required before loading icfdb020008delta.df */

DISABLE TRIGGERS FOR LOAD OF ryc_attribute_value.

DEFINE BUFFER bryc_attribute_value FOR ryc_attribute_value.

FOR EACH ryc_attribute_value NO-LOCK BY ryc_attribute_value.attribute_value_obj:
  
    FOR EACH bryc_attribute_value EXCLUSIVE-LOCK
         WHERE bryc_attribute_value.attribute_value_obj <> ryc_attribute_value.attribute_value_obj
           AND bryc_attribute_value.OBJECT_type_obj = ryc_attribute_value.OBJECT_type_obj
           AND bryc_attribute_value.container_smartobject_obj = ryc_attribute_value.container_smartobject_obj
           AND bryc_attribute_value.smartobject_obj = ryc_attribute_value.smartobject_obj
           AND bryc_attribute_value.object_instance_obj = ryc_attribute_value.object_instance_obj
           AND bryc_attribute_value.attribute_label = ryc_attribute_value.attribute_label:
           
        PUBLISH "DCU_WriteLog":U 
          ("Removed Duplicate Attribute Value " + STRING(bryc_attribute_value.attribute_value_obj)
           + " - " + bryc_attribute_value.attribute_label
           + " Object Type Obj: " + STRING(bryc_attribute_value.OBJECT_type_obj)
           + " Smartobject Obj: " + STRING(bryc_attribute_value.smartobject_obj)
           + " Object Instance Obj: " + STRING(bryc_attribute_value.object_instance_obj)
           + " Container SO Obj: " + STRING(bryc_attribute_value.container_smartobject_obj)). 
   
         
        DELETE bryc_attribute_value.
        
    END.
END.

DISABLE TRIGGERS FOR LOAD OF gsm_server_context.
FOR EACH gsm_server_context:
    DELETE gsm_server_context.
END.
