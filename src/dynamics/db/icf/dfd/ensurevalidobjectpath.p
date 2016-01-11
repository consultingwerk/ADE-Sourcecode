/** Ths utility will ensure that the object path field is specified as that of the relative path of the
    object's product module. Existing object paths should be left as is - per instruction from Bruce Gruenbaum
   
   ------------------------------------------------------------------------------------------------------ **/
DEFINE VARIABLE cRelativePath AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lError        AS LOGICAL    NO-UNDO.

DEFINE BUFFER ryc_smartobject     FOR ryc_smartobject.
DEFINE BUFFER gsc_product_module  FOR gsc_product_module.

PUBLISH "DCU_WriteLog":U ("Object path specification started.").

FOR EACH ryc_smartobject EXCLUSIVE-LOCK
   WHERE ryc_smartobject.object_path = "":U
      OR ryc_smartobject.object_path = ?,
   FIRST gsc_product_module NO-LOCK
   WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
   BREAK
      BY ryc_smartobject.product_module_obj:

  IF FIRST-OF(ryc_smartobject.product_module_obj) THEN
    /* 'src/' should not be stored as part of the object path - as per instruction from Bruce Gruenbaum */
    ASSIGN
        cRelativePath = REPLACE(REPLACE(gsc_product_module.relative_path, "~\":U, "/":U), "src/":U, "":U).

  ryc_smartobject.object_path = cRelativePath NO-ERROR.

  IF ERROR-STATUS:ERROR THEN
  DO:
    ASSIGN lError = TRUE.
    PUBLISH "DCU_WriteLog":U ("Unable to assign object path '" + cRelativePath + "' for '" + ryc_smartobject.object_filename + "'":U).

    ERROR-STATUS:ERROR = FALSE.
  END.
END.

PUBLISH "DCU_WriteLog":U ("Object path specification completed " + (IF lError THEN "with errors!" ELSE "successfully.")).
