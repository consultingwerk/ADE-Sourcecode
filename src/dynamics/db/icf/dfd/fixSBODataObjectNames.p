/* fixSBODataObjectNames.p - This program will convert any instance attribute references to 
   DataObjectNames to UpdateOrder */

PUBLISH "DCU_WriteLog":U ("Starting conversion of instance attribute DataObjectNames to UpdateOrder.").

DO TRANSACTION:
  FOR EACH ryc_attribute_value WHERE
           ryc_attribute_value.attribute_label = "DataObjectNames" AND
           ryc_attribute_value.smartobject_obj > 0:
    ryc_attribute_value.attribute_label = "UpdateOrder".
  END.
END.

PUBLISH "DCU_WriteLog":U ("End of DataObjectNames conversion to UpdateOrder").
RETURN.
