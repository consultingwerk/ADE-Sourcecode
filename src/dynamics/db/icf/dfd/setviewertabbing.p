/* This fix program adds the AppBuilderTabbing attribute to existing 
   dynamic viewers and sets it to "Custom" */

DEFINE VARIABLE cClassList  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMessage    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iNumClasses AS INTEGER    NO-UNDO.

FUNCTION getClassChildren RETURNS CHARACTER
    (INPUT pcClass AS CHARACTER) FORWARD.

PUBLISH 'DCU_WriteLog':U ('Starting to add AppBuilderTabbing attribute to existing dynamic viewers.':U).

ASSIGN cClassList = getClassChildren('DynView':U).

DO iNumClasses = 1 TO NUM-ENTRIES(cClassList, CHR(1)):
  
  FOR EACH ryc_smartobject WHERE 
    ryc_smartobject.object_type_obj = DECIMAL(ENTRY(iNumClasses,cClassList,CHR(1))) NO-LOCK:

    FIND FIRST ryc_attribute_value WHERE 
        ryc_attribute_value.object_type_obj = ryc_smartobject.object_type_obj AND
        ryc_attribute_value.smartobject_obj = ryc_smartobject.smartobject_obj AND 
        ryc_attribute_value.object_instance_obj = 0 AND
        ryc_attribute_value.attribute_label = "AppBuilderTabbing":U NO-LOCK NO-ERROR.

     IF NOT AVAILABLE ryc_attribute_value THEN 
     DO:
       CREATE ryc_attribute_value.   
       ASSIGN 
         ryc_attribute_value.object_type_obj           = ryc_smartobject.object_type_obj
         ryc_attribute_value.smartobject_obj           = ryc_smartobject.smartobject_obj
         ryc_attribute_value.container_smartobject_obj = 0
         ryc_attribute_value.object_instance_obj       = 0
         ryc_attribute_value.primary_smartobject_obj   = ryc_smartobject.smartobject_obj
         ryc_attribute_value.attribute_label           = "AppBuilderTabbing":U
         ryc_attribute_value.character_value           = "Custom":U
         ryc_attribute_value.applies_at_runtime        = NO NO-ERROR.
       IF ERROR-STATUS:ERROR THEN
         cMessage = 'Error occurred adding AppBuilderTabbing attribute to ':U +
                     ryc_smartobject.object_filename.
       ELSE cMessage = 'Added AppBuilderTabbing attribute to ':U + 
                        ryc_smartobject.object_filename.

       PUBLISH 'DCU_WriteLog':U (cMessage).
     END.  /* if not avail attribute_value */  
  END.  /* for each smartobject */
END.  /* do iNumClasses */

RETURN.

FUNCTION getClassChildren RETURNS CHARACTER
	(INPUT pcClass AS CHARACTER):
	
	DEFINE VARIABLE cCurrentClassList AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dObjectTypeObj    AS DECIMAL    NO-UNDO.

    /* Localize the gsc_object_type buffer to this function. This is 
       particularly important seeing that the function is called recursively */
    DEFINE BUFFER gsc_object_type FOR gsc_object_type.
  
	/* See if the given class exists */
	FIND FIRST gsc_object_type WHERE gsc_object_type.object_type_code = pcClass NO-LOCK NO-ERROR.
	/* See if the specified class exists */
  	IF AVAILABLE gsc_object_type THEN
  	DO:  	
        ASSIGN dObjectTypeObj    = gsc_object_type.object_type_obj
        	   cCurrentClassList = STRING(dObjectTypeObj).
        	   
        /* Step through all the children of the current class */
        FOR EACH gsc_object_type WHERE 
            gsc_object_type.extends_object_type_obj = dObjectTypeObj NO-LOCK:
        	/* For every child, see if there are any children underneath it, by recursively calling this function */
		    ASSIGN cCurrentClassList = cCurrentClassList + CHR(1) + getClassChildren(gsc_object_type.object_type_code).
        END.	/* each class */
    END.	/* available class */
    
    RETURN cCurrentClassList.                 
END FUNCTION.	/* getclasschildren */
