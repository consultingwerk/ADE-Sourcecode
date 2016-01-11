/* toolbar04.p  - creates missing attributes for the toolbar 
                - updates objects and instances for all attributes
                - updates attribute list on object instance
*/


ON WRITE OF ryc_attribute_value OVERRIDE DO: END.

DEFINE VARIABLE h         AS HANDLE     NO-UNDO.
DEFINE VARIABLE cList     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEntry    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cProp     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValue    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDatatype AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSignature AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i AS INTEGER    NO-UNDO.

RUN adm2/dyntoolbar.p PERSISTENT SET h.

FIND ryc_attribute_group NO-LOCK WHERE  
         ryc_attribute_group.attribute_group_name = 'defaults'.
    
FIND gsc_object_type NO-LOCK WHERE gsc_object_type.object_type_code = 'smarttoolbar'.

/* add new toolbar instance properties to smarttoolbar object type */
cList = {fnarg InstancePropertylist '' h}.
DO i = 1 TO NUM-ENTRIES(cList,CHR(3)) WITH DOWN:  
  ASSIGN 
    cEntry     = ENTRY(i,cList,CHR(3))
    cProp      = ENTRY(1,cEntry,CHR(4))
    cValue     = ENTRY(2,cEntry,CHR(4))
    cSignature = {fnarg signature "'get' + cProp" h}
    cDataType  = IF cSignature <> '' THEN ENTRY(2,cSignature) ELSE ''.
  
  IF cdataType <> '' THEN
  DO:
    FIND ryc_attribute NO-LOCK WHERE ryc_attribute.attribute_label = cProp NO-ERROR.
    
    IF NOT AVAIL ryc_attribute THEN
    DO:
      CREATE ryc_attribute.
      ASSIGN 
        ryc_attribute.attribute_group_obj  = ryc_attribute_group.attribute_group_obj
        ryc_attribute.attribute_type_tla =
                        IF      cDataType = 'logical'   THEN 'LOG' 
                        ELSE IF cDataType = 'integer'   THEN 'INT'
                        ELSE IF cDataType = 'decimal'   THEN 'DEC' 
                        ELSE IF cdataType = 'date'      THEN 'DAT'
                        ELSE 'CHR'    
        ryc_attribute.attribute_label = cprop
        ryc_attribute.system_owned =TRUE
        ryc_attribute.attribute_narrative = "Created automatically from the object's instance attributes.".
      
      CREATE ryc_attribute_value.
      ASSIGN
        ryc_attribute_value.OBJECT_type_obj     = gsc_object_type.object_type_obj
        ryc_attribute_value.container_smartobject_obj = 0
        ryc_attribute_value.smartobject_obj = 0
        ryc_attribute_value.object_instance_obj = 0
        ryc_attribute_value.attribute_group_obj = ryc_attribute.attribute_group_obj
        ryc_attribute_value.attribute_label     = ryc_attribute.attribute_label 
        ryc_attribute_value.attribute_type_tla  = ryc_attribute.attribute_type_tla
        ryc_attribute_value.PRIMARY_smartobject_obj = ryc_attribute_value.OBJECT_type_obj
        ryc_attribute_value.attribute_value     = cValue
        ryc_attribute_value.inheritted_value    = no
        ryc_attribute_value.collect_attribute_value_obj = ryc_attribute_value.attribute_value_obj
        .
      
    END.
  END.
END.

/* loop around smarttoolbar masters and instances to add new attributes to them */
FOR EACH ryc_smartobject NO-LOCK
         WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj
         AND   ryc_smartObject.OBJECT_filename <> 'rydyntoolt.w' WITH FRAME X DOWN:
    RUN updateObject(gsc_object_type.object_type_obj,
                     ryc_smartobject.smartobject_obj).
    FOR EACH ryc_object_instance NO-LOCK
         WHERE ryc_object_instance.smartobject_obj = ryc_smartobject.smartobject_obj:
       RUN updateInstance(gsc_object_type.object_type_obj,
                          ryc_smartobject.smartobject_obj,
                          ryc_object_instance.OBJECT_instance_obj,
                          ryc_object_instance.CONTAINER_smartobject_obj).

    END.
END.

/* ensure attribute list is correct for toolbar instances */
DEFINE VARIABLE cAttributeList  AS CHARACTER  NO-UNDO.

FOR EACH ryc_smartobject NO-LOCK
         WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj:
    FOR EACH ryc_object_instance EXCLUSIVE-LOCK
       WHERE ryc_object_instance.smartobject_obj = ryc_smartobject.smartobject_obj:

      /* update attribute list for instance */
      ASSIGN
          cAttributeList = "".
      FOR EACH ryc_attribute_value NO-LOCK
          WHERE ryc_attribute_value.object_type_obj = ryc_smartobject.object_type_obj
          AND ryc_attribute_value.container_smartobject_obj = ryc_object_instance.container_smartobject_obj
          AND ryc_attribute_value.smartobject_obj = ryc_smartObject.smartobject_obj
          AND ryc_attribute_value.object_instance_obj = ryc_object_instance.object_instance_obj:

          IF cAttributeList <> ""
          THEN
              ASSIGN
                  cAttributeList = cAttributeList + CHR(3).
          ASSIGN
              cAttributeList = cAttributeList + ryc_attribute_value.attribute_label + CHR(4) + ryc_attribute_value.attribute_value.
      END.
    
      ASSIGN ryc_object_instance.attribute_list = cAttributeList.
    
    END.
END.

PROCEDURE updateInstance:
 
 DEFINE INPUT  PARAMETER pdObjectType  AS DECIMAL  NO-UNDO.
 DEFINE INPUT  PARAMETER pdSmartObject AS DECIMAL  NO-UNDO.
 DEFINE input  PARAMETER pdInstance    AS DECIMAL  NO-UNDO.
 DEFINE INPUT  PARAMETER pdContainer   AS DECIMAL  NO-UNDO.

 DEFINE BUFFER bryc_attribute_value FOR ryc_attribute_value.
 
 attribute-loop:
 FOR EACH ryc_attribute_value NO-LOCK
      WHERE ryc_attribute_value.object_type_obj           = pdObjectType
        AND ryc_attribute_value.smartobject_obj           = pdSmartObject
        AND ryc_attribute_value.OBJECT_instance_obj       = 0
        AND ryc_attribute_value.container_smartobject_obj = 0:

    FIND FIRST bryc_attribute_value EXCLUSIVE-LOCK
         WHERE bryc_attribute_value.object_type_obj = pdObjectType
           AND bryc_attribute_value.smartobject_obj = pdSmartObject
           AND bryc_attribute_value.object_instance_obj = pdInstance
           AND bryc_attribute_value.container_smartobject_obj = pdContainer
           AND bryc_attribute_value.attribute_label = ryc_attribute_value.attribute_label
         NO-ERROR.           

    IF AVAILABLE bryc_attribute_value AND bryc_attribute_value.inheritted_value = FALSE THEN
      NEXT attribute-loop.  /* do not override manual customisations */

    IF NOT AVAILABLE bryc_attribute_value THEN
    DO:
      CREATE bryc_attribute_value NO-ERROR.
      /*
      {af/sup2/afcheckerr.i &no-return = YES}
      IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
      */
    END.

    ASSIGN
      bryc_attribute_value.object_type_obj = pdObjectType
      bryc_attribute_value.smartobject_obj = pdSmartObject
      bryc_attribute_value.object_instance_obj = pdInstance
      bryc_attribute_value.container_smartobject_obj = pdContainer
      bryc_attribute_value.collect_attribute_value_obj = bryc_attribute_value.attribute_value_obj
      bryc_attribute_value.collection_sequence = 0
      bryc_attribute_value.constant_value = ryc_attribute_value.constant_value
      bryc_attribute_value.attribute_group_obj = ryc_attribute_value.attribute_group_obj
      bryc_attribute_value.attribute_type_tla = ryc_attribute_value.attribute_type_tla
      bryc_attribute_value.attribute_label = ryc_attribute_value.attribute_label
      bryc_attribute_value.PRIMARY_smartobject_obj = pdContainer
      bryc_attribute_value.inheritted_value = TRUE
      bryc_attribute_value.attribute_value = ryc_attribute_value.attribute_value
      .


    VALIDATE bryc_attribute_value NO-ERROR.
    IF RETURN-VALUE <> "":U THEN do:
      MESSAGE RETURN-VALUE.  
      UNDO, RETURN error.
    END.
 END. /* attribute-loop */
END.

PROCEDURE updateObject:
 
 DEFINE INPUT  PARAMETER pdObjectType  AS DECIMAL  NO-UNDO.
 DEFINE INPUT  PARAMETER pdSmartObject AS DECIMAL  NO-UNDO.
 DEFINE BUFFER bryc_attribute_value FOR ryc_attribute_value.

 attribute-loop:
 FOR EACH ryc_attribute_value NO-LOCK
      WHERE ryc_attribute_value.object_type_obj           = pdObjectType
        AND ryc_attribute_value.smartobject_obj           = 0
        AND ryc_attribute_value.OBJECT_instance_obj       = 0
        AND ryc_attribute_value.container_smartobject_obj = 0:

    FIND FIRST bryc_attribute_value EXCLUSIVE-LOCK
         WHERE bryc_attribute_value.object_type_obj = pdObjectType
           AND bryc_attribute_value.smartobject_obj = pdSmartObject
           AND bryc_attribute_value.object_instance_obj = 0
           AND bryc_attribute_value.container_smartobject_obj = 0
           AND bryc_attribute_value.attribute_label = ryc_attribute_value.attribute_label
         NO-ERROR.           

    IF AVAILABLE bryc_attribute_value AND bryc_attribute_value.inheritted_value = FALSE THEN
      NEXT attribute-loop.  /* do not override manual customisations */

    IF NOT AVAILABLE bryc_attribute_value THEN
    DO:
      CREATE bryc_attribute_value NO-ERROR.
      /*
      {af/sup2/afcheckerr.i &no-return = YES}
      IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
      */
    END.

    ASSIGN
      bryc_attribute_value.object_type_obj = pdObjectType
      bryc_attribute_value.smartobject_obj = pdSmartObject
      bryc_attribute_value.object_instance_obj = 0
      bryc_attribute_value.container_smartobject_obj = 0
      bryc_attribute_value.collect_attribute_value_obj = bryc_attribute_value.attribute_value_obj
      bryc_attribute_value.collection_sequence = 0
      bryc_attribute_value.constant_value = ryc_attribute_value.constant_value
      bryc_attribute_value.attribute_group_obj = ryc_attribute_value.attribute_group_obj
      bryc_attribute_value.attribute_type_tla = ryc_attribute_value.attribute_type_tla
      bryc_attribute_value.attribute_label = ryc_attribute_value.attribute_label
      bryc_attribute_value.PRIMARY_smartobject_obj = pdSmartObject
      bryc_attribute_value.inheritted_value = TRUE
      bryc_attribute_value.attribute_value = ryc_attribute_value.attribute_value
      .

    VALIDATE bryc_attribute_value NO-ERROR.
    IF RETURN-VALUE <> "":U THEN do:
      MESSAGE RETURN-VALUE.  
      UNDO, RETURN error.
    END.
 END. /* attribute-loop */

END. 
