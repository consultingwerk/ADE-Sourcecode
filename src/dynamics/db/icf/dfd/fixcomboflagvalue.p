/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/* fixcomboflagvalue.p 

   Fix program to convert FlagValue attribute values for decimal
   dynamic combos to American format.
   
   This must run with the numeric format that was used when 
   the FlagValue attribute values were stored in the repository.

*/


DEFINE VARIABLE cComboList          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cContainerName      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cConvertedFlagValue AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMessage            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLastDataType       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dFlagValue          AS DECIMAL    NO-UNDO.
DEFINE VARIABLE iTypeLoop           AS INTEGER    NO-UNDO.
DEFINE VARIABLE lDecimal            AS LOGICAL    NO-UNDO.

DEFINE BUFFER bAttrValue  FOR ryc_attribute_value.
DEFINE BUFFER bContainer  FOR ryc_smartobject.
DEFINE BUFFER bCustomType FOR gsc_object_type. 

/* Temp table to store the datatype for the Dynamic Combo class
   hierarchy including class customizations */
DEFINE TEMP-TABLE ttClassDT
    FIELD ttObjectTypeObj LIKE ryc_attribute_value.OBJECT_type_obj
    FIELD ttObjectType    LIKE gsc_object_type.OBJECT_type_code
    FIELD ttDataType        AS CHARACTER.

FUNCTION getClassChildren RETURNS CHARACTER
    (INPUT pcClass AS CHARACTER) FORWARD.

PUBLISH 'DCU_SetStatus':U ('Converting dynamic combo flagvalue attributes to American numeric format ...').

cComboList = getClassChildren(INPUT 'DynCombo':U).

/* Lookupfield defines KeyDataType as blank, it is not defined for DynCombo.
   First find KeyDataType for Lookupfield and any Lookupfield customizing 
   class to use for DynCombo. */
FIND FIRST gsc_object_type WHERE 
  gsc_object_type.object_type_code = 'LookupField':U NO-LOCK NO-ERROR.
IF AVAILABLE gsc_object_type THEN
DO:
  CREATE ttClassDT.
  ASSIGN
    ttClassDT.ttObjectTypeObj = gsc_object_type.OBJECT_type_obj
    ttClassDT.ttObjectType    = gsc_object_type.OBJECT_type_code.

  FIND ryc_attribute_value WHERE
      ryc_attribute_value.OBJECT_type_obj = gsc_object_type.OBJECT_type_obj AND
      ryc_attribute_value.smartobject_obj = 0 AND
      ryc_attribute_value.OBJECT_instance_obj = 0 AND
      ryc_attribute_value.render_type_obj = 0 AND
      ryc_attribute_value.attribute_label = 'KeyDataType':U NO-LOCK NO-ERROR.
  IF AVAILABLE ryc_attribute_value THEN
    ASSIGN 
      ttClassDT.ttDataType = ryc_attribute_value.CHARACTER_value
      cLastDataType        = ryc_attribute_value.CHARACTER_value.

  /* Check for attribute for a Lookupfield customizing class */
  FIND bCustomType WHERE 
    bCustomType.OBJECT_type_obj = gsc_object_type.custom_object_type_obj NO-LOCK NO-ERROR.
  IF AVAILABLE bCustomType THEN
  DO:
    FIND ryc_attribute_value WHERE
        ryc_attribute_value.OBJECT_type_obj = bCustomType.OBJECT_type_obj AND
        ryc_attribute_value.smartobject_obj = 0 AND
        ryc_attribute_value.OBJECT_instance_obj = 0 AND
        ryc_attribute_value.render_type_obj = 0 AND
        ryc_attribute_value.attribute_label = 'KeyDataType':U NO-LOCK NO-ERROR.
    IF AVAILABLE ryc_attribute_value THEN
      ASSIGN 
        ttClassDT.ttDataType = ryc_attribute_value.CHARACTER_value
        cLastDataType        = ryc_attribute_value.CHARACTER_value.
  END.  /* if avail Lookupfield custom type */

END.  /* if avail Lookupfield object type */

/* Create temp table records to store datatype for combo class hierarchy */
DO iTypeLoop = 1 TO NUM-ENTRIES(cComboList, CHR(1)):

  FIND gsc_object_type WHERE
    gsc_object_type.OBJECT_type_obj = DECIMAL(ENTRY(iTypeLoop,cComboList,CHR(1))) NO-LOCK NO-ERROR.
  IF AVAILABLE gsc_object_type THEN 
  DO:

    CREATE ttClassDT.
    ASSIGN 
      ttClassDT.ttObjectTypeObj = gsc_object_type.OBJECT_type_obj
      ttClassDT.ttObjectType    = gsc_object_type.OBJECT_type_code
      ttClassDT.ttDataType      = cLastDataType.
  
    FIND ryc_attribute_value WHERE
        ryc_attribute_value.OBJECT_type_obj = ttClassDT.ttObjectTypeObj AND
        ryc_attribute_value.smartobject_obj = 0 AND
        ryc_attribute_value.OBJECT_instance_obj = 0 AND
        ryc_attribute_value.render_type_obj = 0 AND
        ryc_attribute_value.attribute_label = 'KeyDataType':U NO-LOCK NO-ERROR.
    IF AVAILABLE ryc_attribute_value THEN
      ASSIGN
        ttClassDT.ttDataType = ryc_attribute_value.CHARACTER_value
        cLastDataType = ryc_attribute_value.CHARACTER_value.

    /* Look at customizing class */
    FIND bCustomType WHERE 
      bCustomType.OBJECT_type_obj = gsc_object_type.custom_object_type_obj NO-LOCK NO-ERROR.
    IF AVAILABLE bCustomType THEN
    DO:
      FIND ryc_attribute_value WHERE
          ryc_attribute_value.OBJECT_type_obj = bCustomType.OBJECT_type_obj AND
          ryc_attribute_value.smartobject_obj = 0 AND
          ryc_attribute_value.OBJECT_instance_obj = 0 AND
          ryc_attribute_value.render_type_obj = 0 AND
          ryc_attribute_value.attribute_label = 'KeyDataType':U NO-LOCK NO-ERROR.
      IF AVAILABLE ryc_attribute_value THEN
        ASSIGN 
          ttClassDT.ttDataType = ryc_attribute_value.CHARACTER_value
          cLastDataType        = ryc_attribute_value.CHARACTER_value.
    END.  /* if avail custom type */
  END.  /* if avail object type */
END.  /* do iTypeLoop */ 

/* Process classes */
FOR EACH ttClassDT:

  IF ttClassDT.ttDataType = 'decimal':U THEN
  DO:
    cMessage = '':U.

    FIND ryc_attribute_value WHERE
      ryc_attribute_value.OBJECT_type_obj = ttClassDT.ttObjectTypeObj AND
      ryc_attribute_value.smartobject_obj = 0 AND
      ryc_attribute_value.OBJECT_instance_obj = 0 AND
      ryc_attribute_value.render_type_obj = 0 AND
      ryc_attribute_value.attribute_label = 'FlagValue':U EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE ryc_attribute_value THEN
    DO:
      IF ryc_attribute_value.CHARACTER_value = '':U THEN
        cMessage = 'The FlagValue attribute stored against ':U +
                   ttClassDT.ttObjectType +
                   ' class is blank and cannot be converted to American format.':U.
      ELSE DO:
        dFlagValue = DECIMAL(ryc_attribute_value.CHARACTER_value) NO-ERROR.
        IF ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 0 THEN
          cMessage = 'The FlagValue attribute stored against ':U +
                     ttClassDT.ttObjectType + 
                     ' class is not a decimal value and cannot be converted to American format.':U.
        ELSE DO:
          cConvertedFlagValue = REPLACE(STRING(dFlagValue),SESSION:NUMERIC-DECIMAL-POINT,'.':U) NO-ERROR.
          IF ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 0 THEN
            cMessage = 'The FlagValue attribute stored against ':U +
                       ttClassDT.ttObjectType +
                       ' class cannot be converted to American format.':U.
          ELSE DO:
            ASSIGN ryc_attribute_value.CHARACTER_value = cConvertedFlagValue NO-ERROR.
            IF ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 0 THEN
              cMessage = 'The converted FlagValue attribute for ':U +
                         ttClassDT.ttObjectType + 
                         ' class cannot be written to the repository.':U.
            ELSE cMessage = 'The FlagValue attribute stored against ':U + 
                            ttClassDT.ttObjectType + 
                            ' class has been converted to American format.':U.
          END.  /* else do - update attribute value with converted value */                                             
        END.  /* else do - stored value could be converted to decimal */                                                
      END.  /* else do - attribute value not blank */
      PUBLISH 'DCU_WriteLog':U (cMessage).
    END.  /* if available FlagValue attribute */    
  END.  /* if class data type is decimal */
END.  /* class processing */

/* Process master objects and instances */
DO iTypeLoop = 1 TO NUM-ENTRIES(cComboList, CHR(1)):
  
  /* Process master objects */
  FOR EACH ryc_smartobject WHERE
    ryc_smartobject.OBJECT_type_obj = DECIMAL(ENTRY(iTypeLoop,cComboList,CHR(1))) NO-LOCK:

    ASSIGN 
      cMessage = '':U
      lDecimal = NO.
    
    FIND ryc_attribute_value WHERE
      ryc_attribute_value.OBJECT_type_obj = ryc_smartobject.OBJECT_type_obj AND
      ryc_attribute_value.smartobject_obj = ryc_smartobject.smartobject_obj AND
      ryc_attribute_value.OBJECT_instance_obj = 0 AND
      ryc_attribute_value.render_type_obj = 0 AND
      ryc_attribute_value.attribute_label = 'KeyDataType':U EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE ryc_attribute_value THEN
    DO:
      IF ryc_attribute_value.CHARACTER_value = 'decimal':U THEN
        ASSIGN lDecimal = YES.
    END.  /* if keydatatype available for object master */
    ELSE DO:
      FIND ttClassDT WHERE ttClassDT.ttObjectTypeObj = ryc_smartobject.OBJECT_type_obj.
      IF AVAILABLE ttClassDT AND ttClassDT.ttDataType = 'decimal':U THEN
        lDecimal = TRUE.
    END.  /* else do - check datatype for class */

    IF lDecimal THEN
    DO:
      FIND bAttrValue WHERE
        bAttrValue.OBJECT_type_obj = ryc_smartobject.OBJECT_type_obj AND
        bAttrValue.smartobject_obj = ryc_smartobject.smartobject_obj AND
        bAttrValue.OBJECT_instance_obj = 0 AND
        bAttrValue.render_type_obj = 0 AND
        bAttrValue.attribute_label = 'FlagValue':U EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE bAttrValue THEN
      DO:
        IF bAttrValue.CHARACTER_value = '':U THEN
          cMessage = 'The FlagValue attribute stored against ':U +
                     ryc_smartobject.OBJECT_filename +
                     'master object is blank and cannot be converted to American format.':U.
        ELSE DO:        
          dFlagValue = DECIMAL(bAttrValue.CHARACTER_value) NO-ERROR.
          IF ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 0 THEN
              cMessage = 'The FlagValue attribute stored against ':U +
                         ryc_smartobject.OBJECT_filename + 
                         ' master object is not a decimal value and cannot be converted to American format.':U.
          ELSE DO: 
            cConvertedFlagValue = REPLACE(STRING(dFlagValue),SESSION:NUMERIC-DECIMAL-POINT,'.':U) NO-ERROR.
            IF ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 0 THEN
              cMessage = 'The FlagValue attribute stored against ':U +
                         ryc_smartobject.OBJECT_filename +
                         ' master object cannot be converted to American format.':U.
            ELSE DO:
              ASSIGN bAttrValue.CHARACTER_value = cConvertedFlagValue NO-ERROR.
              IF ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 0 THEN
                cMessage = 'The converted FlagValue attribute for ':U +
                           ryc_smartobject.OBJECT_filename + 
                           ' master object cannot be written to the repository.':U.
              ELSE cMessage = 'The FlagValue attribute stored against ':U + 
                              ryc_smartobject.OBJECT_filename + 
                              ' master has been converted to American format.':U.
            END.  /* else do - update attribute with converted value */
          END.  /* else do - stored value could be converted to decimal */  
        END.  /* else do - attribute value not blank */
        PUBLISH 'DCU_WriteLog':U (cMessage).
      END.  /* if available FlagValue attribute */
    END.  /* if decimal */


    /* Process instances */
    FOR EACH ryc_object_instance WHERE
      ryc_object_instance.smartobject_obj = ryc_smartobject.smartobject_obj NO-LOCK:

      FIND ryc_attribute_value WHERE
        ryc_attribute_value.OBJECT_type_obj = ryc_smartobject.OBJECT_type_obj AND
        ryc_attribute_value.smartobject_obj = ryc_smartobject.smartobject_obj AND
        ryc_attribute_value.OBJECT_instance_obj = ryc_object_instance.OBJECT_instance_obj AND
        ryc_attribute_value.render_type_obj = 0 AND
        ryc_attribute_value.attribute_label = 'FlagValue':U EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE ryc_attribute_value THEN
      DO:
        
        FIND bAttrValue WHERE
          bAttrValue.OBJECT_type_obj = ryc_smartobject.OBJECT_type_obj AND
          bAttrValue.smartobject_obj = ryc_smartobject.smartobject_obj AND
          bAttrValue.OBJECT_instance_obj = ryc_object_instance.OBJECT_instance_obj AND
          bAttrValue.render_type_obj = 0 AND
          bAttrValue.attribute_label = 'KeyDataType':U NO-LOCK NO-ERROR.
        IF AVAILABLE bAttrValue THEN
          ASSIGN lDecimal = IF bAttrValue.CHARACTER_value = 'decimal':U THEN TRUE
                            ELSE FALSE.  

        IF lDecimal THEN
        DO:
          FIND bContainer WHERE
            bContainer.smartobject_obj = ryc_object_instance.container_smartobject_obj NO-LOCK NO-ERROR.
          IF AVAILABLE bContainer THEN
            cContainerName = bContainer.OBJECT_filename.
          ELSE cContainerName = '<unknown>':U.

          IF ryc_attribute_value.CHARACTER_value = '':U THEN
            cMessage = 'The FlagValue attribute stored against ':U +
                       ryc_object_instance.instance_name +
                       ' instance on ':U +
                       cContainerName +
                       ' master object is blank and cannot be converted to American format.':U.
          ELSE DO:
            dFlagValue = DECIMAL(ryc_attribute_value.CHARACTER_value) NO-ERROR.
            IF ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 0 THEN
                cMessage = 'The FlagValue attribute stored against ':U +
                           ryc_object_instance.instance_name + 
                           ' instance on ':U + 
                           cContainerName + 
                           ' master object is not a decimal value and cannot be converted to American format.':U.
            ELSE DO: 
              cConvertedFlagValue = REPLACE(STRING(dFlagValue),SESSION:NUMERIC-DECIMAL-POINT,'.':U) NO-ERROR.
              IF ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 0 THEN
                cMessage = 'The FlagValue attribute stored against ':U +
                           ryc_object_instance.instance_name +
                           ' instance on ':U + 
                           cContainerName +
                           ' master object cannot be converted to American format.':U.
              ELSE DO:
                ASSIGN ryc_attribute_value.CHARACTER_value = cConvertedFlagValue NO-ERROR.
                IF ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 0 THEN
                  cMessage = 'The converted FlagValue attribute for ':U +
                             ryc_object_instance.instance_name + 
                             ' instance on ':U +
                             cContainerName + 
                             ' master object cannot be written to the repository.':U.
                ELSE cMessage = 'The FlagValue attribute stored against ':U + 
                                ryc_object_instance.instance_name +
                                ' instance on ':U + 
                                cContainerName + 
                                ' master has been converted to American format.':U.
              END.  /* else do - update attribute with converted value */
            END.  /* else do - stored value could be converted to decimal */  
          END.  /* else do - attribute value not blank */
          PUBLISH 'DCU_WriteLog':U (cMessage).
        END.  /* if decimal instance */        
      END.  /* if available keyvalue instance attribute */
    END.  /* for each object instance */
  END.  /* for each master SMO */
END.  /* do iTypeLoop */

EMPTY TEMP-TABLE ttClassDT.

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
