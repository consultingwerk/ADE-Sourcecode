/* Program:     addlabelstaticsdo.p 
   Parameters:  <none>
   Purpose:     This utility adds the 'LABEL' attribute to static 
                SDO objects and to any exteneded objects of the SDO class.
                
                It tries to find the first enabled physical table and 
                searches in the entity mnemonic table and uses the short description as 
                the label. If this isn't found, it uses the logicalobjectName.
*/

{src/adm2/globals.i}

DEFINE VARIABLE cEnabledTables  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFirstTable     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLabel          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPhysicalTables AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSDOList        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTables         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hSDO            AS HANDLE     NO-UNDO.
DEFINE VARIABLE iObjectTypeLoop AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPosition       AS INTEGER    NO-UNDO.

ASSIGN cSDOList = 'SDO':U.

OUTPUT TO 'SDOaddlabel.log':U.
PUT UNFORMATTED 'Static SDO add label log':U SKIP.

FIND FIRST gsc_object_type NO-LOCK
     WHERE gsc_object_type.object_type_code = cSDOList NO-ERROR.
IF AVAILABLE gsc_object_type THEN 
DO:
    ASSIGN cSDOList = gsc_object_type.object_type_code.           
    RUN FindExtendedClass IN THIS-PROCEDURE (gsc_object_type.object_type_obj).
END.    
ELSE cSDOList = '':U.

SDOObjectBlock:
DO iObjectTypeLoop = 1 TO NUM-ENTRIES(cSDOList): 
  FIND FIRST gsc_object_type NO-LOCK
      WHERE gsc_object_type.object_type_code = ENTRY(iObjectTypeLoop,cSDOList)
      NO-ERROR.           
  IF AVAIL gsc_object_type THEN
  DO:
    ObjectBlock:
    FOR EACH ryc_smartobject NO-LOCK
        WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj:

      FIND gsc_product_module WHERE 
           gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj NO-LOCK NO-ERROR.
      IF LOOKUP(gsc_product_module.product_module_code,'ry-tem,dlc-adm2support,dlc-adm2template':U) > 0 THEN 
        NEXT ObjectBlock.

      FIND FIRST ryc_attribute_value WHERE
                 ryc_attribute_value.object_Type_obj     = ryc_smartObject.object_Type_obj AND
                 ryc_attribute_value.smartobject_obj     = ryc_smartObject.smartobject_obj AND
                 ryc_attribute_value.object_instance_obj = 0                     AND
                 ryc_attribute_value.attribute_label     = "Label":U
                 EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE ryc_attribute_value THEN
        NEXT ObjectBlock.

      PUT UNFORMATTED SKIP(1) 'Starting SDO ':U ryc_smartobject.object_filename SKIP.
      RUN StartDataObject IN gshRepositoryManager (INPUT ryc_smartobject.OBJECT_filename, OUTPUT hSDO) NO-ERROR.
      ASSIGN
        cLabel      = '':U
        cFirstTable = '':U.

      IF ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 0 THEN
        PUT UNFORMATTED
          'Error starting ':U ryc_smartobject.object_filename
          ' - label attribute not added':U SKIP.

      ELSE IF VALID-HANDLE(hSDO) THEN
      DO:
        cEnabledTables  = DYNAMIC-FUNCTION('getEnabledTables':U IN hSDO). 
        cTables         = DYNAMIC-FUNCTION('getTables':U IN hSDO).
        cPhysicalTables = DYNAMIC-FUNCTION('getPhysicalTables':U IN hSDO).
        
        ASSIGN iPosition = LOOKUP(ENTRY(1,cEnabledTables),cTables) NO-ERROR.
        IF iPosition > 0 THEN 
          cFirstTable = ENTRY(iPosition,cPhysicalTables) NO-ERROR.

        IF cFirstTable > '':U THEN
        DO:
          FIND FIRST gsc_entity_mnemonic NO-LOCK
               WHERE gsc_entity_mnemonic.entity_mnemonic_description = cFirstTable NO-ERROR.
          IF AVAIL gsc_entity_mnemonic THEN
            cLabel = gsc_entity_mnemonic.entity_mnemonic_short_desc.
          IF cLabel = '':U THEN
            cLabel = cFirstTable.
        END.

        /* Ensure the first letter is capitalized and the remaining name is lower case */
        IF LENGTH(cLabel) > 1 THEN
           cLabel = CAPS(SUBSTR(cLabel,1,1)) + LC(SUBSTR(cLabel,2)) NO-ERROR. 

        IF cLabel = '':U THEN
          cLabel = ryc_smartobject.object_filename.

        IF cLabel > '':U THEN
        DO:
          CREATE ryc_attribute_value.
          ASSIGN ryc_attribute_value.object_type_obj         = ryc_smartObject.object_Type_obj
                 ryc_attribute_value.smartobject_obj         = ryc_smartObject.smartobject_obj
                 ryc_attribute_value.object_instance_obj     = 0                           
                 ryc_attribute_value.attribute_label         = "Label":U
                 ryc_attribute_value.primary_smartobject_obj = ryc_smartObject.smartobject_obj
                 ryc_attribute_value.character_value         = cLabel
                 NO-ERROR.
            
          PUT UNFORMATTED
            'Label attribute: ' cLabel SKIP 
            'Added to ' ryc_smartobject.object_filename SKIP.
        END.  /* if label not blank */ 

        RUN destroyObject IN hSDO NO-ERROR.
      END.  /* valid SDO */
    END.  /* for each ryc_smartobject */
  END.  /* if avail object type */
END.  /* SDO object block */

PUT UNFORMATTED SKIP(1) 'Finished Processing':U SKIP.
OUTPUT CLOSE.

PROCEDURE FindExtendedClass:
  DEFINE INPUT PARAMETER pdObj AS DECIMAL NO-UNDO.
  DEFINE BUFFER bObjectType FOR gsc_object_type.

  FOR EACH bObjectType NO-LOCK
      WHERE bObjectType.extends_object_type_obj = pdObj
         BY bObjectType.object_type_code:
      /* For every child, see if there are any children underneath it, by recursively calling this procedure */
         cSDOList = cSDOList + ",":U  + bObjectType.object_type_code.
      RUN FindExtendedClass IN THIS-PROCEDURE (bObjectType.object_type_obj).
  END.

END PROCEDURE.

