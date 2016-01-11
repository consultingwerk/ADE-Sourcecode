/* Program:     addLabelAttr.p 
   Parameters:  <none>
   Purpose:     This utility adds the  'LABEL' attribute to Dynamic 
                SDO objects and to any exteneded objects of the DynSDO class.
                
                It tries to find the first enabled physical table and 
                searches in the entity mnemonic table and uses the short description as 
                the label. If this isn't found, it uses the logicalobjectName.
                 
 *  This utility must be run after the ADO gscot has been applied.
 * ------------------------------------------------------------------------------------------------------ **/

DEFINE VARIABLE cDynSDOList        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iObjectTypeLoop    AS INTEGER    NO-UNDO.

DEFINE VARIABLE cEnabledTables     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTables            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPhysicalTables    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFirstTable        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iPos               AS INTEGER  NO-UNDO.
DEFINE VARIABLE cLabel             AS CHARACTER  NO-UNDO.


PUBLISH "DCU_SetStatus":U ("Calculating dynSDO child classes ...").

ASSIGN cDynSDOList = "dynSDO":U.

 /* See if the given class exists */
FIND FIRST gsc_object_type NO-LOCK
     WHERE gsc_object_type.object_type_code = cDynSDOList NO-ERROR.
IF AVAILABLE gsc_object_type THEN 
DO:
    ASSIGN cDynSDOList = gsc_object_type.object_type_code.           
    RUN FindExtendedClass IN THIS-PROCEDURE (gsc_object_type.object_type_obj).
END.    
ELSE cDynSDOList = "".

/* Loop through dynamic sdo objects */
dynSDOObjectBlock:
DO iObjectTypeLoop = 1 TO NUM-ENTRIES(cDynSDOList):
   PUBLISH "DCU_SetStatus":U ("Adding 'Label' attribute for dynamic SDO object '" +   ENTRY(iObjectTypeLoop,cDynSDOList) + "'").
   FIND FIRST gsc_object_type NO-LOCK
      WHERE gsc_object_type.object_type_code = ENTRY(iObjectTypeLoop,cDynSDOList)
      NO-ERROR.           
   IF AVAIL gsc_object_type THEN
   DO:
     dynSmartobjectBlock:
     FOR EACH ryc_smartobject NO-LOCK
         WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj:
        
        ASSIGN cLabel     = ""
              cFirstTable = ""
              cTables     = "".
              
        FIND FIRST ryc_attribute_value NO-LOCK WHERE
                   ryc_attribute_value.object_Type_obj     = ryc_smartObject.object_Type_obj AND
                   ryc_attribute_value.smartobject_obj     = ryc_smartObject.smartobject_obj AND
                   ryc_attribute_value.object_instance_obj = 0                     AND
                   ryc_attribute_value.attribute_label     = "Tables":U
                   NO-ERROR.
        IF AVAIL ryc_attribute_value THEN
        DO:
          ASSIGN cTables = ryc_attribute_value.character_value.
          FIND FIRST ryc_attribute_value NO-LOCK WHERE
                     ryc_attribute_value.object_Type_obj     = ryc_smartObject.object_Type_obj AND
                     ryc_attribute_value.smartobject_obj     = ryc_smartObject.smartobject_obj AND
                     ryc_attribute_value.object_instance_obj = 0                     AND
                     ryc_attribute_value.attribute_label     = "UpdatableColumnsByTable":U
                     NO-ERROR.
          IF AVAIL ryc_attribute_value THEN
          DO:
             Table-Loop:
             DO iPos = 1 to NUM-ENTRIES(cTables):
               IF ENTRY(iPos,ryc_attribute_value.character_value,";":U) <> "":U THEN
                  LEAVE Table-Loop.
             END.
             FIND FIRST ryc_attribute_value NO-LOCK WHERE
                        ryc_attribute_value.object_Type_obj     = ryc_smartObject.object_Type_obj AND
                        ryc_attribute_value.smartobject_obj     = ryc_smartObject.smartobject_obj AND
                        ryc_attribute_value.object_instance_obj = 0                     AND
                        ryc_attribute_value.attribute_label     = "PhysicalTables":U
                        NO-ERROR.
             IF AVAIL ryc_attribute_value THEN
             DO:
                IF iPos > 0 THEN 
                   ASSIGN cFirstTable = ENTRY(iPos,ryc_attribute_value.character_value) NO-ERROR. 
                /* Look in the entity mnemonic table and use the short description if found */   
                IF cFirstTable > "" THEN
                DO:
                  FIND FIRST gsc_entity_mnemonic NO-LOCK
                       WHERE gsc_entity_mnemonic.entity_mnemonic_description = cFirstTable NO-ERROR.
                  IF AVAIL gsc_entity_mnemonic THEN
                     cLabel = gsc_entity_mnemonic.entity_mnemonic_short_desc.
                  IF cLabel = "" THEN
                     cLabel = cFirstTable.             
                END.                
             END.                                
          END. /* End if avail UpdatableColumnsByTable attribute */
        END. /* End if avail Tables attribute */
        
        /* Ensure the first letter is capitalized and the remaining name is lower case */
        IF LENGTH(cLabel) > 1 THEN
           cLabel = CAPS(SUBSTR(cLabel,1,1)) + LC(SUBSTR(cLabel,2)) NO-ERROR. 
           
        IF cLabel = "" THEN /* Use the object filename if still blank */
           ASSIGN cLabel = ryc_smartObject.object_filename.                      

        /* Create the attribute if cLabel is not blank */
        IF cLabel > "" THEN
        DO:
           FIND FIRST ryc_attribute_value WHERE
                      ryc_attribute_value.object_Type_obj     = ryc_smartObject.object_Type_obj AND
                      ryc_attribute_value.smartobject_obj     = ryc_smartObject.smartobject_obj AND
                      ryc_attribute_value.object_instance_obj = 0                     AND
                      ryc_attribute_value.attribute_label     = "Label":U
                      EXCLUSIVE-LOCK NO-ERROR.
           IF NOT AVAILABLE ryc_attribute_value THEN
           DO:
                CREATE ryc_attribute_value.
                ASSIGN ryc_attribute_value.object_type_obj         = ryc_smartObject.object_Type_obj
                       ryc_attribute_value.smartobject_obj         = ryc_smartObject.smartobject_obj
                       ryc_attribute_value.object_instance_obj     = 0                           
                       ryc_attribute_value.attribute_label         = "Label":U
                       ryc_attribute_value.primary_smartobject_obj = ryc_smartObject.smartobject_obj
                       ryc_attribute_value.character_value = cLabel
                       NO-ERROR.
                IF ERROR-STATUS:ERROR THEN 
                DO:
                  PUBLISH "DCU_WriteLog":U ("Creating of Label attribute failed for: " 
                                             + " Class: " + gsc_object_type.object_type_code
                                             + "  Master: " + ryc_smartobject.object_filename  ).
                  NEXT dynSmartobjectBlock.
                END.   
           END.
           
        END. /* End cLabel > "" */       
     END. /* End FOR EACH ryc_smartobject */  
   END.  /* End avail gsc_object_type */
END. /* Object type loop */

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

/* eof */
