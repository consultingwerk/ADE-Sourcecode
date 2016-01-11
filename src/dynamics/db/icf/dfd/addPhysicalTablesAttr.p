/* Program:     addPhysicalTablesAttr.p 
   Parameters:  <none>
   Purpose:     This utility adds the new 'PhysicalTables' attribute to
                Dynamic SmartDataObjects as a copy of the existing 'Tables'
                attribute. */
                
/* Error Handler preprocessor... Write out errors to the log file but don't stop the utility. */                
&GLOBAL-DEFINE ERROR_HANDLER IF ERROR-STATUS:ERROR THEN DO:~
      PUBLISH "DCU_WriteLog":U ("Errors occurred while adding PhysicalTables attribute value for " +~
                                rycso.OBJECT_filename + "; Value: " + oldAttr.CHARACTER_value ).~
    END.

DEFINE BUFFER oldAttr FOR icfdb.ryc_attribute_value.
DEFINE BUFFER newAttr FOR icfdb.ryc_attribute_value.
DEFINE BUFFER rycso   FOR icfdb.ryc_smartobject.

PUBLISH "DCU_SetStatus":U ("Adding PhysicalTables attribute to all DynSDOs").
FOR EACH oldAttr WHERE oldAttr.attribute_label EQ 'Tables' AND
                       oldAttr.OBJECT_instance_obj EQ 0 AND
                       oldAttr.smartobject_obj NE 0 AND
                       oldAttr.render_type_obj EQ 0 NO-LOCK:
  FIND FIRST newAttr WHERE newAttr.object_type_obj EQ oldAttr.object_type_obj AND 
                           newAttr.attribute_label EQ 'PhysicalTables' AND
                           newAttr.smartobject_obj EQ oldAttr.smartobject_obj AND
                           newAttr.OBJECT_instance_obj EQ oldAttr.OBJECT_instance_obj AND
                           newAttr.render_type_obj EQ oldAttr.render_type_obj NO-LOCK NO-ERROR.
  IF AVAILABLE newAttr THEN NEXT.

  FIND FIRST rycso WHERE rycso.smartobject_obj EQ oldAttr.smartobject_obj NO-LOCK NO-ERROR.
  IF NOT AVAILABLE rycso THEN
    PUBLISH "DCU_WriteLog":U ("Errors occurred while adding PhysicalTables attribute value. " +~
                              " Error: Could not find related SMO for ObjectId " + STRING(oldAttr.smartobject_obj) ).

  PUBLISH "DCU_WriteLog":U (" Adding PhysicalTables attribute value to " + rycso.OBJECT_filename + 
                            "; Value: " + oldAttr.CHARACTER_value).
  DO TRANSACTION:
    CREATE newAttr.
    BUFFER-COPY oldAttr EXCEPT oldAttr.attribute_label oldAttr.attribute_value_obj TO newAttr NO-ERROR.
    {&ERROR_HANDLER}

    ASSIGN newAttr.attribute_label = 'PhysicalTables' NO-ERROR.
    {&ERROR_HANDLER}
  END.
  
END.

RETURN.
