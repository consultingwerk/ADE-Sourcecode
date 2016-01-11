/* TreeView conversion program to make use of DynFrame in the TreeView */
/* MA Davies - 04/17/2003 */
/* Should be run after standard migration */

/* This program will do the following:
   Remove the afspfoldrw object instance
   Remove the FolderPageTop Object instance
   Remove the Page link from the TreeView to the Folder
   Remove the TableIO link from the FolderPageTop toolbar to TreeView
   Remove the Page object created for the default page on the folder
   
   It will then also add the HiddenActions attribute for the ObjectTop toolbar
   to ensure we hide the OK and Cancel toolbar buttons
   */

DEFINE VARIABLE dDynTreeObject AS DECIMAL    NO-UNDO.

DEFINE BUFFER bryc_smartobject FOR ryc_smartobject.

FIND FIRST gsc_object_type
     WHERE gsc_object_type.object_type_code = "DynTree"
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE gsc_object_type THEN
  RETURN.
ELSE
  dDynTreeObject = gsc_object_type.object_type_obj.

PUBLISH "DCU_WriteLog":U ("--- Starting Dynamic TreeView Convertion":U).

/* This fix only applies to Dynamic TreeView Objects */
FOR EACH  ryc_smartobject
    WHERE ryc_smartobject.object_type_obj = dDynTreeObject
    NO-LOCK:
  /* First we'll remove the links Page and TableIO links */
  FOR EACH  ryc_smartlink
      WHERE ryc_smartlink.container_smartobject_obj = ryc_smartobject.smartobject_obj
      AND   (ryc_smartlink.link_name = "Page":U 
      OR     ryc_smartlink.link_name = "TableIO":U)
      EXCLUSIVE-LOCK:
    DELETE ryc_smartlink.
  END.
  /* Now remove the 'Details' page created for the initial folder window */
  FOR EACH  ryc_page
      WHERE ryc_page.container_smartobject_obj = ryc_smartobject.smartobject_obj
      EXCLUSIVE-LOCK:
    DELETE ryc_page.
  END.

  FOR EACH  ryc_object_instance EXCLUSIVE-LOCK
      WHERE ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj,
      FIRST bryc_smartobject NO-LOCK
      WHERE bryc_smartobject.smartobject_obj = ryc_object_instance.smartobject_obj:
    /* Only do something for the Folder and FolderPageTop toolbar instances */
    IF bryc_smartobject.object_filename = "afspfoldrw.w" OR
       bryc_smartobject.object_filename = "FolderPageTop" THEN DO:
      /* We need to delete any attributes for these instances */ 
      FOR EACH  ryc_attribute_value
          WHERE ryc_attribute_value.container_smartobject_obj = ryc_smartobject.smartobject_obj
          AND   ryc_attribute_value.smartobject_obj           = ryc_object_instance.smartobject_obj
          AND   ryc_attribute_value.object_instance_obj       = ryc_object_instance.object_instance_obj
          EXCLUSIVE-LOCK:
        DELETE ryc_attribute_value.
      END.
      /* Finally, we can delete the instance */
      DELETE ryc_object_instance.
    END.
  END.

  /* Now we need to add an attribute for the ObjcTop toolbar */
  FOR EACH  ryc_object_instance EXCLUSIVE-LOCK
      WHERE ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj,
      FIRST bryc_smartobject NO-LOCK
      WHERE bryc_smartobject.smartobject_obj = ryc_object_instance.smartobject_obj:
    /* Only do something for the Folder and FolderPageTop toolbar instances */
    IF bryc_smartobject.object_filename = "ObjcTop" THEN DO:
      /* We need to determine if the HiddenActions attribute already exist */ 
      FIND FIRST ryc_attribute_value
           WHERE ryc_attribute_value.container_smartobject_obj = ryc_object_instance.container_smartobject_obj
           AND   ryc_attribute_value.smartobject_obj           = ryc_object_instance.smartobject_obj
           AND   ryc_attribute_value.object_instance_obj       = ryc_object_instance.object_instance_obj
           AND   ryc_attribute_value.attribute_label           = "HiddenActions":U
           EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE ryc_attribute_value THEN DO:
        CREATE ryc_attribute_value.
        ASSIGN ryc_attribute_value.object_type_obj           = bryc_smartobject.object_type_obj
               ryc_attribute_value.container_smartobject_obj = ryc_object_instance.container_smartobject_obj
               ryc_attribute_value.primary_smartobject_obj   = ryc_object_instance.container_smartobject_obj
               ryc_attribute_value.smartobject_obj           = ryc_object_instance.smartobject_obj
               ryc_attribute_value.object_instance_obj       = ryc_object_instance.object_instance_obj
               ryc_attribute_value.attribute_label           = "HiddenActions":U.
      END.
      IF LOOKUP("txtOK":U,ryc_attribute_value.character_value) = 0 THEN
        ryc_attribute_value.character_value = IF ryc_attribute_value.character_value = "":U THEN "txtOK":U 
                                                                                            ELSE ryc_attribute_value.character_value + ",TxtOK":U.

      IF LOOKUP("txtCancel":U,ryc_attribute_value.character_value) = 0 THEN
        ryc_attribute_value.character_value = IF ryc_attribute_value.character_value = "":U THEN "txtCancel":U 
                                                                                            ELSE ryc_attribute_value.character_value + ",txtCancel":U.
    END.
  END.
END.

PUBLISH "DCU_WriteLog":U ("--- Dynamic TreeView Convertion Complete":U).

RETURN.

