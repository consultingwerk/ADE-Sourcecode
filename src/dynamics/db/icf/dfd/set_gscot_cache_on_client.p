/* This is a fix program to populate the cache_on_client field 
   in the gsc_objec_type table.
   
   This program first builds a list of classes to be set and then
   goes ahead and set the values.
   
   This program will pick any user defined classes that have RYCSO 
   record. This fix program is re-runnable.
*/
   

DEFINE TEMP-TABLE ttList NO-UNDO
  FIELD tObj AS DECIMAL
  FIELD tCode AS CHARACTER.

/* Build the list of classes to set the cache_on_client attribute */
RUN buildClassList NO-ERROR.

/* Set the cache_on_client field in gsc_object_type for each ttList record */
FOR EACH gsc_object_type EXCLUSIVE-LOCK,
   FIRST ttList NO-LOCK
   WHERE gsc_object_type.OBJECT_type_obj = ttList.tObj:

  ASSIGN gsc_object_type.CACHE_on_client = TRUE.

END.

/*---------------------------------------------------------------------------*/
/* Build the list of classes for setting the values 
   All classes that start from ProgressWidget except ProgressWidget need to be picked 
   Only classes that start from Base, which have a RYCSO need to be picked
   In addition, pick DataField and CalculatedField 
*/

PROCEDURE buildClassList:

  FOR EACH gsc_object_type NO-LOCK
     WHERE gsc_object_type.OBJECT_type_code = 'ProgressWidget' 
        OR gsc_object_type.OBJECT_type_code = 'Base' 
        OR gsc_object_type.OBJECT_type_code = 'DataField'
        OR gsc_object_type.OBJECT_type_code = 'CalculatedField':

    /* get ALL Progress widget classes */
    IF gsc_object_type.OBJECT_type_code = 'ProgressWidget' THEN
      RUN getChildren(gsc_object_type.OBJECT_type_obj, NO, YES).
    /* get ALL classes under BASE WHERE there is a RYCSO record */
    ELSE IF gsc_object_type.OBJECT_type_code = 'Base' THEN
      RUN getChildren(gsc_object_type.OBJECT_type_obj, YES, NO).
    /* Add only 'DataField' and 'CalculatedField' from the others */
    ELSE
    DO:
      CREATE ttList.
      ASSIGN tCode = gsc_object_type.OBJECT_type_code
             tObj = gsc_object_type.OBJECT_type_obj.
    END.
  END.
END PROCEDURE.

/*-----------------------------------------------------------------------*/
/* Get the values recursively 
   pdObj - Is the gscot.object_type_obj
   plLookForRYCSO - If YES, find classes that have a RYCSO record associated with it - 
                    And ensure that the RYCSO is not for the palette or template.
   plIgnoreFirstRecord - Ignote the first class. This is used for ignoring ProgressWidget
 */

PROCEDURE getChildren:
  DEFINE INPUT  PARAMETER pdObj AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plLookForRYCSO AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plIgnoreFirstRecord AS LOGICAL    NO-UNDO.

  DEFINE BUFFER gscot FOR gsc_object_type.
  DEFINE VARIABLE lFound AS LOGICAL    NO-UNDO.
  ASSIGN lFound = FALSE.

  FOR EACH gscot NO-LOCK 
     WHERE gscot.extends_object_type_obj = pdObj 
        BY gscot.object_type_code:

    RUN getChildren(INPUT gscot.object_type_obj, plLookForRYCSO, NO).

  END.
  
  FIND FIRST gscot 
       WHERE gscot.OBJECT_type_obj = pdObj 
  NO-LOCK NO-ERROR.

  IF AVAILABLE gscot THEN
  DO:

    /* If the class is 'Palette' the ignore */
    IF gscot.OBJECT_type_code = 'Palette' THEN
      RETURN.

    /* plLookForRYCSO then look for objects with that object type */
    IF plLookForRYCSO THEN
    DO:
      /* Loose template records from both ry/tem and adm2/template */
      FIND FIRST ryc_smartObject 
           WHERE ryc_smartObject.OBJECT_type_obj = pdObj 
             AND ryc_smartObject.OBJECT_path <> "ry/tem"
             AND ryc_smartObject.OBJECT_path <> "adm2/template"
      NO-LOCK NO-ERROR.

    END.

    IF plLookForRYCSO AND NOT AVAILABLE ryc_smartObject THEN
      RETURN.

    IF plIgnoreFirstRecord THEN
      RETURN.

    CREATE ttList.
    ASSIGN tCode = gscot.OBJECT_type_code
           tObj = gscot.OBJECT_type_obj.
  END.

END PROCEDURE.
