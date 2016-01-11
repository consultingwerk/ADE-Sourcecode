/* This noddy will fix the relative paths for Data Logic procedures
   from a migrated database.
   
   It seems that the old object generator didn't save the relative path
   information for the object when it was generated.
   
   This procedure searches through only the Data Logic type objects
   for objects that do not have a relative path specified and then 
   uses the relative path specified for object's product module as 
   it's relative path.
   
   This would solve issue #5845 
   
   Mark Davies (MIP) 08/20/2002 */
   
DISABLE TRIGGERS FOR LOAD OF ryc_smartobject.
DISABLE TRIGGERS FOR DUMP OF ryc_smartobject.

PUBLISH "DCU_WriteLog":U ("Correcting data logic procedure paths...").

   
FIND FIRST gsc_object_type
     WHERE gsc_object_type.object_type_code = "DLProc":U
     NO-LOCK NO-ERROR.
IF AVAILABLE gsc_object_type THEN DO:
  FOR EACH  ryc_smartobject
      WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj
      AND   ryc_smartobject.object_path     = "":U
      EXCLUSIVE-LOCK,
      FIRST gsc_product_module
      WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
      NO-LOCK:
    IF gsc_product_module.relative_path <> "":U THEN
    DO:
      ASSIGN ryc_smartobject.object_path = gsc_product_module.relative_path.
      PUBLISH "DCU_WriteLog":U ("  Adding product module path " + gsc_product_module.relative_path 
                                + " to object " + ryc_smartobject.object_filename ).
    END.
  END.
END.

