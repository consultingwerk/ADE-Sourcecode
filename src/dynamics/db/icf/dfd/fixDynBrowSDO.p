/* The procedure will attempt to associate an SDO with
   all existing Dynamic Browsers that do not have an
   SDO already associated.
   
   It should be run after all the deltas have been applied
   and all the ados have been loaded 
   
   Mark Davies (MIP) 10/16/2002 */

DEFINE VARIABLE cSDOName      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCnt          AS INTEGER    NO-UNDO.
DEFINE VARIABLE cFileName     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dSDOObj       AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dContainerObj AS DECIMAL    NO-UNDO.

DEFINE BUFFER bryc_smartobject FOR ryc_smartobject.
DEFINE BUFFER bgsc_object_type FOR gsc_object_type.

FIND FIRST gsc_object_type
     WHERE gsc_object_type.object_type_code = "DynBrow":U
     NO-LOCK NO-ERROR.
FOR EACH  ryc_smartobject
    WHERE ryc_smartobject.object_type_obj     = gsc_object_type.object_type_obj
    AND   ryc_smartobject.sdo_smartobject_obj = 0
    EXCLUSIVE-LOCK:
    ASSIGN cSDOName = "":U
           dSDOObj  = 0.
  
  
  /* First try and find the browser in a container somewhere and
     see if there is an SDO there */
  dContainerObj = 0.
  FIND FIRST ryc_object_instance
       WHERE ryc_object_instance.smartobject_obj = ryc_smartobject.smartobject_obj
       NO-LOCK NO-ERROR.
  IF AVAILABLE ryc_object_instance THEN
    ASSIGN dContainerObj = ryc_object_instance.container_smartobject_obj.
  IF dContainerObj <> 0 THEN DO:
    FOR EACH  ryc_object_instance
        WHERE ryc_object_instance.container_smartobject_obj = dContainerObj
        NO-LOCK,
        FIRST bryc_smartobject
        WHERE bryc_smartobject.smartobject_obj = ryc_object_instance.smartobject_obj
        NO-LOCK,
        FIRST bgsc_object_type
        WHERE bgsc_object_type.object_type_obj  = bryc_smartobject.object_type_obj
        AND  (bgsc_object_type.object_type_code = "SDO"
        OR    bgsc_object_type.object_type_code = "SBO":U)
        NO-LOCK:
      ASSIGN cSDOName = bryc_smartobject.object_filename
             dSDOObj  = bryc_smartobject.smartobject_obj.
    END.
  END.
  
  /* If we couldn't find an SDO in the same container then we
     need to do some guessing and find the best match */
  IF cSDOName = "":U OR cSDOName = ? OR cSDOName = "?":U THEN DO:
    GUESSING_BLOCK:
    DO iCnt = 1 TO LENGTH(ryc_smartobject.object_filename):
      IF LENGTH(ryc_smartobject.object_filename) - iCnt < 5 THEN
        LEAVE GUESSING_BLOCK.
      cFileName = SUBSTRING(ryc_smartobject.object_filename,1,LENGTH(ryc_smartobject.object_filename) - iCnt).
      FOR EACH  bgsc_object_type
          WHERE bgsc_object_type.object_type_code = "SDO":U /* We didn't have Dynamic SDOs for V1 yet */
          OR    bgsc_object_type.object_type_code = "SBO":U
          NO-LOCK,
          FIRST bryc_smartobject
          WHERE bryc_smartobject.object_type_obj = bgsc_object_type.object_type_obj
          AND   bryc_smartobject.object_filename BEGINS cFileName
          NO-LOCK:
        ASSIGN cSDOName = bryc_smartobject.object_filename
               dSDOObj  = bryc_smartobject.smartobject_obj.
        LEAVE GUESSING_BLOCK.
      END.
    END.
  END.

  IF dSDOObj <> 0 THEN
    ASSIGN ryc_smartobject.sdo_smartobject_obj = dSDOObj.

END.
