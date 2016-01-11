/* Program:     createassignlist.p 
   Parameters:  <none>
   Purpose:     This utility adds the 'AssignList' attribute to Dynamic SDO objects
                that have multiple tables.  It will also update blank 'AssignList' 
                attributes for Dynamic SDO objects that have multiple tables.
                
                This utility processes all Dynamic SDO objects and any extended objects
                of the DynSDO class.  It set the 'AssignList' attribute with a semicolon delimiter based on 
                the number of tables joined in the SDO.                 
 * ------------------------------------------------------------------------------------------------------ **/
DEFINE VARIABLE cAssignList     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDynSDOList     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTables         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iObjectTypeLoop AS INTEGER    NO-UNDO.

ASSIGN cDynSDOList = "DynSDO":U.

 /* See if the given class exists */
FIND FIRST gsc_object_type NO-LOCK
     WHERE gsc_object_type.object_type_code = cDynSDOList NO-ERROR.
IF AVAILABLE gsc_object_type THEN 
DO:
    ASSIGN cDynSDOList = gsc_object_type.object_type_code.           
    RUN FindExtendedClass IN THIS-PROCEDURE (gsc_object_type.object_type_obj).
END.    
ELSE cDynSDOList = "".

PUBLISH "DCU_WriteLog":U ("Adding/Updating dynamic SDO AssignList attribute":U).

ObjectBlock:
DO iObjectTypeLoop = 1 TO NUM-ENTRIES(cDynSDOList):
  FIND FIRST gsc_object_type NO-LOCK
       WHERE gsc_object_type.object_type_code = ENTRY(iObjectTypeLoop,cDynSDOList)
       NO-ERROR.           
  IF AVAIL gsc_object_type THEN
  DO:
    SmartObjectBlock:
    FOR EACH ryc_smartobject NO-LOCK
        WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj:

      ASSIGN cTables     = "":U
             cAssignList = "":U.
  
      /* Physical Tables */
      FIND FIRST ryc_attribute_value
           WHERE ryc_attribute_value.container_smartobject_obj = 0
           AND   ryc_attribute_value.smartobject_obj      = ryc_smartobject.smartobject_obj
           AND   ryc_attribute_value.attribute_label      = "Tables"
           NO-LOCK NO-ERROR.
      IF AVAILABLE ryc_attribute_value THEN
        cTables = ryc_attribute_value.character_value.
      ELSE DO:
        PUBLISH "DCU_WriteLog":U ("Unable to find Tables attribute for object " + ryc_smartobject.object_filename).
        NEXT SmartObjectBlock.
      END.
      RELEASE ryc_attribute_value.
  
      /* AssignList */
      FIND FIRST ryc_attribute_value
           WHERE ryc_attribute_value.container_smartobject_obj = 0
           AND   ryc_attribute_value.smartobject_obj      = ryc_smartobject.smartobject_obj
           AND   ryc_attribute_value.attribute_label      = "AssignList"
           EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE ryc_attribute_value THEN
        cAssignList      = ryc_attribute_value.character_value.
  
      IF NUM-ENTRIES(cTables) > 1 AND cAssignList = "":U THEN
      DO:
        cAssignList = FILL(";":U, NUM-ENTRIES(cTables) - 1).
        IF NOT AVAILABLE ryc_attribute_value THEN
        DO:
          CREATE ryc_attribute_value.
          ASSIGN ryc_attribute_value.object_type_obj         = ryc_smartObject.object_Type_obj
                 ryc_attribute_value.smartobject_obj         = ryc_smartObject.smartobject_obj
                 ryc_attribute_value.object_instance_obj     = 0                           
                 ryc_attribute_value.attribute_label         = "AssignList":U
                 ryc_attribute_value.primary_smartobject_obj = ryc_smartObject.smartobject_obj NO-ERROR.
          IF ERROR-STATUS:ERROR THEN
          DO:
            PUBLISH "DCU_WriteLog":U ("Creation of AssignList attribute failed for object ":U +
                                      ryc_smartobject.object_filename).
            NEXT SmartObjectBlock.
          END.
          ELSE PUBLISH "DCU_WriteLog":U ("Creation of AssignList attribute for object ":U +
                                         ryc_smartobject.object_filename + "succeeded":U).
        END.  /* if not avail AssignList */
        ryc_attribute_value.character_value = cAssignList NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
        DO:
          PUBLISH "DCU_WriteLog":U ("Updating AssignList attribute failed for object ":U +
                                    ryc_smartobject.object_filename).
          NEXT SmartObjectBlock.
        END.
        ELSE PUBLISH "DCU_WriteLog":U ("Updating AssignList attribute for object ":U +
                                    ryc_smartobject.object_filename + "succeeded":U).
      END.  /* if assignlist blank */

    END.  /* SmartObjectBlock */
  END.  /* if avail object type */
END.  /* ObjectBlock */

RETURN.

PROCEDURE FindExtendedClass:
  DEFINE INPUT PARAMETER pdObj AS DECIMAL NO-UNDO.
  DEFINE BUFFER bObjectType FOR gsc_object_type.

  FOR EACH bObjectType NO-LOCK
      WHERE bObjectType.extends_object_type_obj = pdObj
         BY bObjectType.object_type_code:
      /* For every child, see if there are any children underneath it, by recursively calling this procedure */
         cDynSDOList = cDynSDOList + ",":U  + bObjectType.object_type_code.
      RUN FindExtendedClass IN THIS-PROCEDURE (bObjectType.object_type_obj).
  END.

END PROCEDURE.
