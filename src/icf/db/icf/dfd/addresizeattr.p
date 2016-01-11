/***********************************************************************/
/* This procedure will create 2 new Attributes - ResizeHorizontal and  */
/* ResizeVertical. It will then add these two attributes for certain   */
/* object types and cascade it down to object instance level with      */
/* default values.                                                     */
/*                                                                     */
/*  Author: Mark Davies (MIP)                                          */
/*  Date  : 23/10/2001                                                 */
/***********************************************************************/
DEFINE VARIABLE gcResizeVertical     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcResizeHorizontal   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gdAttributeGroupObj  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gcObjectTypes        AS CHARACTER  NO-UNDO INITIAL
  "DynBrow,SmartBrowser,StaticSDB,SmartFolder,DynFold,StaticSDV,SmartViewer,DynView,SmartToolbar".

DEFINE BUFFER bryc_smartobject FOR ryc_smartobject.

FIND FIRST ryc_attribute_group
     WHERE ryc_attribute_group.attribute_group_name = "Defaults"
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE ryc_attribute_group THEN DO:
  MESSAGE "Could not find attribute group for 'Defaults'." SKIP
          "Make sure you have the latest data loaded from CVS."
          VIEW-AS ALERT-BOX ERROR.
  RETURN.
END.
ELSE
 gdAttributeGroupObj = ryc_attribute_group.attribute_group_obj.
 
/* Create the attributes - If they don't exist */
FIND FIRST ryc_attribute
     WHERE ryc_attribute.attribute_label = "ResizeHorizontal":U
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE ryc_attribute THEN DO:
  CREATE ryc_attribute.
  ASSIGN ryc_attribute.attribute_group_obj = ryc_attribute_group.attribute_group_obj
         ryc_attribute.attribute_label     = "ResizeHorizontal":U
         ryc_attribute.attribute_type_tla  = "LOG":U
         ryc_attribute.attribute_narrative = "Indicates if an object is Horizontally Resizable.".
END.

FIND FIRST ryc_attribute
     WHERE ryc_attribute.attribute_label = "ResizeVertical":U
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE ryc_attribute THEN DO:
  CREATE ryc_attribute.
  ASSIGN ryc_attribute.attribute_group_obj = ryc_attribute_group.attribute_group_obj
         ryc_attribute.attribute_label     = "ResizeVertical":U
         ryc_attribute.attribute_type_tla  = "LOG":U
         ryc_attribute.attribute_narrative = "Indicates if an object is Vertically Resizable.".
END.

SESSION:SET-WAIT-STATE("GENERAL":U).
/* First we will set the attribute values for the object types */
/* Creating these attributes for the object type will cascade 
   down to SmartObject level - we do not need to create the
   attributes at that level */
FOR EACH  gsc_object_type
    WHERE LOOKUP(gsc_object_type.object_type_code,gcObjectTypes) > 0
    NO-LOCK:
    PROCESS EVENTS.
    RUN createAttribute (INPUT gsc_object_type.object_type_obj,
                         INPUT 0,
                         INPUT 0,
                         INPUT 0,
                         INPUT gsc_object_type.object_type_code).
END.
SESSION:SET-WAIT-STATE("":U).

/* Now we need to create these attributes down to object instance
   level, but we will only do it for objects that has a Relative layout */
FIND FIRST ryc_layout
     WHERE ryc_layout.layout_name = "Relative"
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE ryc_layout THEN DO:
  MESSAGE "The Relative layout option has not been set." SKIP
          "You need to update your layout data." SKIP
          "There is no need to create attributes at object instance" SKIP
          "level since there aren't any objects with a Relative layout." SKIP
          "Conversion Complete!"
          VIEW-AS ALERT-BOX INFORMATION.
END.

SESSION:SET-WAIT-STATE("GENERAL":U).
FOR EACH  ryc_smartobject
    WHERE ryc_smartobject.layout_obj = ryc_layout.layout_obj
    NO-LOCK:
  FOR EACH  ryc_object_instance NO-LOCK
      WHERE ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj,
      FIRST bryc_smartobject NO-LOCK
      WHERE bryc_smartobject.smartobject_obj = ryc_object_instance.smartobject_obj,
      FIRST gsc_object_type NO-LOCK
      WHERE gsc_object_type.object_type_obj = bryc_smartobject.object_type_obj:
    /* Only update objects for the selected object types */
    IF LOOKUP(gsc_object_type.object_type_code,gcObjectTypes) = 0 THEN
      NEXT.
    RUN createAttribute (INPUT gsc_object_type.object_type_obj,
                         INPUT ryc_object_instance.container_smartobject_obj,
                         INPUT ryc_object_instance.smartobject_obj,
                         INPUT ryc_object_instance.object_instance_obj,
                         INPUT gsc_object_type.object_type_code).
  END.
END.
SESSION:SET-WAIT-STATE("":U).

MESSAGE "Conversion Complete!"
        VIEW-AS ALERT-BOX INFORMATION.
        
PROCEDURE createAttribute:
  DEFINE INPUT  PARAMETER pdObjectTypeObj     AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdcontainerObj      AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdSmartObjectObj    AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdObjectInstanceObj AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcObjectType        AS CHARACTER  NO-UNDO.
  
  ASSIGN gcResizeHorizontal = "NO":U
         gcResizeVertical   = "NO":U.
  CASE pcObjectType:   
    WHEN 'DynBrow':U OR
    WHEN 'SmartBrowser':U OR
    WHEN 'StaticSDB':U OR
    WHEN 'SmartFolder':U OR 
    WHEN 'DynFold':U THEN
      ASSIGN gcResizeVertical   = "YES":U
             gcResizeHorizontal = "YES":U.
    WHEN 'StaticSDV':U OR
    WHEN 'SmartViewer':U OR 
    WHEN 'DynView':U THEN
      ASSIGN gcResizeVertical   = "NO":U
             gcResizeHorizontal = "NO":U.
    WHEN 'SmartToolbar':U THEN
      ASSIGN gcResizeVertical   = "NO":U
             gcResizeHorizontal = "YES":U.
  END. /* CASE */
  
  /* Create ResizeHorizontal */
  FIND FIRST ryc_attribute_value
       WHERE ryc_attribute_value.object_type_obj           = pdObjectTypeObj    
       AND   ryc_attribute_value.container_smartobject_obj = pdcontainerObj     
       AND   ryc_attribute_value.smartobject_obj           = pdSmartObjectObj   
       AND   ryc_attribute_value.object_instance_obj       = pdObjectInstanceObj
       AND   ryc_attribute_value.primary_smartobject_obj   = pdcontainerObj
       AND   ryc_attribute_value.attribute_label           = "ResizeHorizontal":U
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ryc_attribute_value THEN DO:
    CREATE ryc_attribute_value.
    ASSIGN ryc_attribute_value.object_type_obj           = pdObjectTypeObj     
           ryc_attribute_value.container_smartobject_obj = pdcontainerObj      
           ryc_attribute_value.smartobject_obj           = pdSmartObjectObj    
           ryc_attribute_value.object_instance_obj       = pdObjectInstanceObj 
           ryc_attribute_value.primary_smartobject_obj   = pdcontainerObj      
           ryc_attribute_value.attribute_label           = "ResizeHorizontal":U
           ryc_attribute_value.attribute_value           = gcResizeHorizontal
           ryc_attribute_value.attribute_group_obj       = gdAttributeGroupObj
           ryc_attribute_value.attribute_type_tla        = "LOG":U
           ryc_attribute_value.inheritted_value          = TRUE
           ryc_attribute_value.constant_value            = FALSE.
  END.
  /* Create ResizeVertical */
  FIND FIRST ryc_attribute_value
       WHERE ryc_attribute_value.object_type_obj           = pdObjectTypeObj    
       AND   ryc_attribute_value.container_smartobject_obj = pdcontainerObj     
       AND   ryc_attribute_value.smartobject_obj           = pdSmartObjectObj   
       AND   ryc_attribute_value.object_instance_obj       = pdObjectInstanceObj
       AND   ryc_attribute_value.primary_smartobject_obj   = pdcontainerObj
       AND   ryc_attribute_value.attribute_label           = "ResizeVertical":U
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ryc_attribute_value THEN DO:
    CREATE ryc_attribute_value.
    ASSIGN ryc_attribute_value.object_type_obj           = pdObjectTypeObj     
           ryc_attribute_value.container_smartobject_obj = pdcontainerObj      
           ryc_attribute_value.smartobject_obj           = pdSmartObjectObj    
           ryc_attribute_value.object_instance_obj       = pdObjectInstanceObj 
           ryc_attribute_value.primary_smartobject_obj   = pdcontainerObj      
           ryc_attribute_value.attribute_label           = "ResizeVertical":U
           ryc_attribute_value.attribute_value           = gcResizeVertical
           ryc_attribute_value.attribute_group_obj       = gdAttributeGroupObj
           ryc_attribute_value.attribute_type_tla        = "LOG":U
           ryc_attribute_value.inheritted_value          = TRUE
           ryc_attribute_value.constant_value            = FALSE.
  END.

END. /* createAttribute */
      
      

