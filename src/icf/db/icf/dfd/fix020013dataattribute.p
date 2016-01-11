/******************************************************************************* 
Purpose : The procedure will read through all current ryc_attribute_value
          records, except those for the ObjectType and remove DataSource and 
          DataSourceName.  
 Author : HD
   Date : 07/12/2002
   Note : The DataSource was wrongly used while DataSourceNames is deprecated
          completely. There will be ADO submission for the ryc_attribute and 
          object type relations.  
******************************************************************************/
DEFINE VARIABLE cRemove AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i       AS INTEGER    NO-UNDO.

cRemove = 'DataSource,DataSourceName'.

DO i = 1 TO NUM-ENTRIES(cRemove): 
  FOR EACH ryc_attribute_value 
                WHERE ryc_attribute_value.attribute_label =  ENTRY(i,cRemove)
                AND   ryc_attribute_value.smartobject_obj <> 0 EXCLUSIVE:
    DELETE ryc_attribute_value.
  /***
  FIND ryc_smartobject OF ryc_attribute_value NO-ERROR.
  DISP gsc_object_type.object_type_code FORMAT "x(15)" 
       ryc_attribute_value.CHARACTER_value  FORMAT "x(12)".
  
  IF AVAIL ryc_smartobject THEN  
    DISPLAY
      ryc_smartobject.OBJECT_filename FORMAT "x(12)".
  ELSE 
    DISPLAY
      ryc_attribute_value.smartobject_obj.
  ******/    
  END.
END.

      
