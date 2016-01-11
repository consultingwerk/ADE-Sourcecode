/* addcalctoentity.p 
   Fix program to create instances of calculated fields against entities so that calculated
   fields no longer cost an extra AppServer hit - Dynamics 10.0B.
    
   The program iterates through all the dynamic SDOs in the reqository (static ones are not an issue) and
   determines if there are any calculated fields in the dynamic SDO. If there are, it checks to see whether
   an instance of the calculated field already exists against the entity. If the calculated field does not
   exist against the entity, a new object instance is created against the entity pointing to the calculated
   field.   
   */


DEFINE VARIABLE cSDOList        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iSDOClass       AS INTEGER    NO-UNDO.
DEFINE VARIABLE cColumnsProp    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTablesProp     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalcFields     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cUpdColsByTable AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEnabledTables  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEntity         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iVar            AS INTEGER    NO-UNDO.
DEFINE VARIABLE cCurrField      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iPos            AS INTEGER    NO-UNDO.
DEFINE VARIABLE cReposEnt AS CHARACTER  NO-UNDO.

DEFINE BUFFER ryc_DataColAttr FOR ryc_attribute_value.
DEFINE BUFFER ryc_TablesAttr  FOR ryc_attribute_value.
DEFINE BUFFER ryc_UpdColsAttr FOR ryc_attribute_value.
DEFINE BUFFER ryc_Entity      FOR ryc_smartobject.
DEFINE BUFFER ryc_CalcField   FOR ryc_smartobject.
DEFINE BUFFER ryc_SDO         FOR ryc_smartobject.
DEFINE BUFFER ryc_LastInst    FOR ryc_object_instance.


FUNCTION getClassChildren   RETURNS CHARACTER
	(INPUT pcClass AS CHARACTER) FORWARD.

/* Get a list of all the DynSDO object types */
cSDOList = getClassChildren('DynSDO':U).

/* Now loop through all attribute values that are DataColumnsByTable attributes 
   that apply to an object master (smartobject_obj <> 0 and object_instance_obj = 0 */
FOR EACH ryc_DataColAttr NO-LOCK
  WHERE ryc_DataColAttr.attribute_label       =   "DataColumnsByTable":U 
    AND ryc_DataColAttr.smartobject_obj       <>  0.0
    AND ryc_DataColAttr.object_instance_obj   =   0.0:

  /* We don't care about any objects that are not dynamic SDO derivatives */
  IF LOOKUP(STRING(ryc_DataColAttr.object_type_obj), cSDOList, chr(1)) = 0 THEN
    NEXT.

  /* Now we need to find the "Tables" attribute so that we can figure out
     if this object even has calculated fields */
  FIND FIRST ryc_TablesAttr NO-LOCK
    WHERE ryc_TablesAttr.object_type_obj      =   ryc_DataColAttr.object_type_obj
      AND ryc_TablesAttr.smartobject_obj      =   ryc_DataColAttr.smartobject_obj
      AND ryc_TablesAttr.object_instance_obj  =   ryc_DataColAttr.object_instance_obj
      AND ryc_TablesAttr.render_type_obj      =   ryc_DataColAttr.render_type_obj
      AND ryc_TablesAttr.attribute_label      =   "Tables":U
    NO-ERROR.

  /* This should never be the case. If there is no tables attribute for this object, there is a problem with the data */
  IF NOT AVAILABLE(ryc_TablesAttr) THEN
  DO:
   PUBLISH "DCU_WriteLog":U ("DataColumnsByTable attribute found with no corresponding Tables attribute for object_type_obj: " +
                             STRING(ryc_DataColAttr.object_type_obj) + " smartobject_obj: " + STRING(ryc_DataColAttr.smartobject_obj) +
                             " object_instance_obj: " + STRING(ryc_DataColAttr.object_instance_obj) + " render_type_obj: " + STRING(ryc_DataColAttr.render_type_obj)).

   NEXT.
  END.
    
  ASSIGN
    cColumnsProp = ryc_DataColAttr.character_value
    cTablesProp  = ryc_TablesAttr.character_value
    .

  IF NUM-ENTRIES(cColumnsProp,";":U) > NUM-ENTRIES(cTablesProp) THEN
    cCalcFields = ENTRY(NUM-ENTRIES(cTablesProp)+ 1,cColumnsProp,";":U).  
  ELSE 
    cCalcFields = "":U.

  IF cCalcFields = "":U THEN
    NEXT.

  /* Find the smartobject for the SDO so that we can refer to its name when we create it later */
  FIND FIRST ryc_SDO NO-LOCK
    WHERE ryc_SDO.smartobject_obj = ryc_DataColAttr.smartobject_obj
    NO-ERROR.
  /* This code should never be run as this would mean that the repository data's referential integrity
     is hosed.*/
  IF NOT AVAILABLE(ryc_SDO) THEN
  DO:
    PUBLISH "DCU_WriteLog":U ("ryc_smartobject not found for smartobject_obj: " + STRING(ryc_DataColAttr.smartobject_obj)).

    NEXT.
  END.
  /* Now we need to find the "UpdatableColumnsByTable" attribute so that we can figure out
     which entity we need to create an instance on. */
  FIND FIRST ryc_UpdColsAttr NO-LOCK
    WHERE ryc_UpdColsAttr.object_type_obj      =   ryc_DataColAttr.object_type_obj
      AND ryc_UpdColsAttr.smartobject_obj      =   ryc_DataColAttr.smartobject_obj
      AND ryc_UpdColsAttr.object_instance_obj  =   ryc_DataColAttr.object_instance_obj
      AND ryc_UpdColsAttr.render_type_obj      =   ryc_DataColAttr.render_type_obj
      AND ryc_UpdColsAttr.attribute_label      =   "UpdatableColumnsByTable":U
    NO-ERROR.

  /* This should never be the case. If there is no UpdatableColumnsByTable attribute for this object, there is a problem with the data */
  IF NOT AVAILABLE(ryc_UpdColsAttr) THEN
  DO:
   PUBLISH "DCU_WriteLog":U ("DataColumnsByTable attribute found with no corresponding UpdatableColumnsByTable attribute for object_type_obj: " +
                             STRING(ryc_DataColAttr.object_type_obj) + " smartobject_obj: " + STRING(ryc_DataColAttr.smartobject_obj) +
                             " object_instance_obj: " + STRING(ryc_DataColAttr.object_instance_obj) + " render_type_obj: " + STRING(ryc_DataColAttr.render_type_obj)).

   NEXT.
  END.


  /* The following code was borrowed from getEnabledTables in queryext.p. It determines the list of
     enabled tables. */
  ASSIGN
    cUpdColsByTable = ryc_UpdColsAttr.character_value
    cEnabledTables  = "":U
  .

  DO iVar = 1 TO NUM-ENTRIES(cTablesProp):
    IF ENTRY(iVar,cUpdColsByTable,";":U) <> "":U THEN
      cEnabledTables = cEnabledTables 
                      + (IF cEnabledTables = "":U THEN "":U ELSE ",":U)
                      + ENTRY(iVar, cTablesProp).
  END.

  IF cEnabledTables = "":U OR
     cEnabledTables = ? THEN
    cEnabledTables = cTablesProp.

  
  /* We should only ever update entities that are not repository entities. */
  cEntity = "":U.
  cReposEnt = "":U.
  DO iVar = 1 TO NUM-ENTRIES(cEnabledTables):
    cEntity = ENTRY(iVar,cEnabledTables).
    IF NOT CAN-FIND(FIRST icfdb._File WHERE icfdb._File._File-name = cEntity) THEN
      LEAVE.
    ELSE
    DO:
      IF cReposEnt = "":U THEN
        cReposEnt = cEntity.
      cEntity = "":U.
    END.
  END.

  /* If the entity is blank, we'll ignore this field instance because it would be added to a repository table */
  IF cEntity = "":U AND
     cReposEnt <> "":U THEN
  DO:
    PUBLISH "DCU_WriteLog":U ("Unable to create calculated field for " + cCalcFields + " for " + ryc_SDO.object_filename + " as it would need to be added to a repository entity " + cReposEnt + ".").
    NEXT.
  END.

  /* At this point we find the smartobject for the entity. */
  FIND FIRST ryc_Entity NO-LOCK
    WHERE ryc_Entity.object_filename = cEntity
    NO-ERROR.
  /* If we don't find an ryc_smartobject for the entity we can't do anything. */
  IF NOT AVAILABLE(ryc_Entity) THEN
  DO: 
    PUBLISH "DCU_WriteLog":U ("Could not find ryc_smartobject for entity: " + cEntity).
    NEXT.
  END.

  /* We need to get the last object instance for this entity so that we can get the 
     object_sequence right */
  iPos = 0.
  FOR EACH ryc_LastInst NO-LOCK
    WHERE ryc_LastInst.container_smartobject_obj = ryc_Entity.smartobject_obj
    BY ryc_LastInst.object_sequence DESCENDING:
    iPos = ryc_LastInst.object_sequence.
    LEAVE.
  END.

  /* Now we have the entity that we need to use to create all the instances for this SDO. Lets loop through all the 
     calculated fields in this SDO and create them where necessary. */

  DO iVar = 1 TO NUM-ENTRIES(cCalcFields):
    cCurrField = ENTRY(iVar,cCalcFields).

    /* Find the ryc_smartobject for this calculated field */
    FIND FIRST ryc_CalcField NO-LOCK
      WHERE ryc_CalcField.object_filename = cCurrField
      NO-ERROR.
    /* If we don't find an ryc_smartobject for the calculated field we can't do anything. */
    IF NOT AVAILABLE(ryc_CalcField) THEN
    DO: 
      PUBLISH "DCU_WriteLog":U ("Could not find ryc_smartobject for calculated field: " + cCurrField).
      NEXT.
    END.

    DO TRANSACTION ON ERROR UNDO, RETURN ERROR RETURN-VALUE:
      /* Now we need to see if there is an instance of this calculated field already on the entity */
      FIND FIRST ryc_object_instance EXCLUSIVE-LOCK
        WHERE ryc_object_instance.container_smartobject_obj = ryc_Entity.smartobject_obj
          AND ryc_object_instance.instance_name = cCurrField
        NO-ERROR.
      IF NOT AVAILABLE(ryc_object_instance) THEN
      DO:
        CREATE ryc_object_instance.
        ASSIGN
          ryc_object_instance.container_smartobject_obj = ryc_Entity.smartobject_obj
          ryc_object_instance.instance_name             = cCurrField
          ryc_object_instance.instance_description      = "Calculated field instance " + cCurrField + " created by addcalctoentity.p upgrade program."
          ryc_object_instance.smartobject_obj           = ryc_CalcField.smartobject_obj
          iPos                                          = iPos + 1
          ryc_object_instance.object_sequence           = iPos
          ryc_object_instance.layout_position           = STRING(iPos,"999")
        .
        PUBLISH "DCU_WriteLog":U ("Added calculated field " + cCurrField + " to entity " + cEntity + " for SDO " + ryc_SDO.object_filename).
      END.
      ELSE
      DO:
        PUBLISH "DCU_WriteLog":U ("Calculated field " + cCurrField + " previously added to entity " + cEntity + ". Not added for SDO " + ryc_SDO.object_filename).
      END.
    END.
  END.
END.



function getClassChildren	returns character
	(input pcClass as character):
	
  DEFINE VARIABLE cCurrentClassList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dObjectTypeObj    AS DECIMAL    NO-UNDO.

  /* Localize the gsc_object_type buffer to this function. This is particularly important seeing that the function is called recursively */
  DEFINE BUFFER gsc_object_type FOR gsc_object_type.
  
	/* See if the given class exists */
	FIND FIRST gsc_object_type WHERE	
			   gsc_object_type.object_type_code = pcClass 
			   no-lock NO-ERROR.
	/* See if the specified class exists */
  	IF AVAILABLE gsc_object_type THEN
  	DO:
        ASSIGN dObjectTypeObj    = gsc_object_type.object_type_obj
        	   cCurrentClassList = string(dObjectTypeObj).
        	   
        /* Step through all the children of the current class */
        FOR EACH gsc_object_type WHERE 
        	     gsc_object_type.extends_object_type_obj = dObjectTypeObj
        	     no-lock:
        	/* For every child, see if there are any children underneath it, by recursively calling this function */
			assign cCurrentClassList = cCurrentClassList + chr(1) + getClassChildren(gsc_object_type.object_type_code).
        END.	/* each class */
    END.	/* available class */
    
	return cCurrentClassList.                 
end function.	/* getclasschildren */

