/** This migration utility attempts to ensure a valid, non-zero value for the object_sequence field on
    the ryc_object_instance record. It does this by checking for the existence of an "Order" attribute.
  
    This utility can be re-run.
   ------------------------------------------------------------------------------------------------------ **/

function getClassChildren	returns character
	(input pcClass as character) forward.

define variable lError 			as logical 		no-undo.
define variable cClassList		as character	no-undo.
define variable iObjectSequence as integer		no-undo.
define variable iLoop			as integer		no-undo.

define buffer rycoi		for ryc_object_instance.

assign lError = no.

/* For objects contained by ENTITY objects, use the LAYOUT_POSITION value, since this was
 * a temporary solution caused by the lack of a proper sequence field prior to ICFDB version 22.
 */
assign cClassList = getClassChildren("Entity").

publish "DCU_WriteLog" ("*** Migrate sequence stored in layout_position for objects contained by Entity objects.").

do iLoop = 1 to num-entries(cClassList, chr(1)):
	for each ryc_smartobject where
		 	 ryc_smartobject.object_type_obj = decimal(entry(iLoop, cClassList, chr(1)))
		 	 no-lock,
		each ryc_object_instance where
			 ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj and
			 ryc_object_instance.object_sequence 		   = 0
			 no-lock:
	    find rycoi where
	         rowid(rycoi) = rowid(ryc_object_instance)
	         exclusive-lock no-wait no-error.
	    if locked rycoi then
	    do:
	        PUBLISH "DCU_WriteLog":U ("Unable to obtain exclusive lock. Proceeding with next record.").
	        assign lError = yes.
	        undo, next.
	    end.    /* locked rycoi */
	    
	    assign rycoi.object_sequence = integer(ryc_object_instance.layout_position)
	           no-error.
	    if error-status:error then
	    do:
	        PUBLISH "DCU_WriteLog":U ("Error migrating object instance record. Proceeding with next record.").
	        assign lError = yes.
	        undo, next.
	    end.    /* error assigning values. */
	    
	    PUBLISH "DCU_WriteLog":U ("Updated object sequence for instance `" + ryc_object_instance.instance_name
							        + "` to `" + string(rycoi.object_sequence)
							        + "` (Object instance: " + string(rycoi.object_instance_obj) + ") ":U).		
	end.	/* each object of Entity class. */		 	 		
end.	/* loop through Entity objects */

publish "DCU_WriteLog" ("*** Migrate sequence stored in layout_position for objects contained by Entity objects, completed "
   			           + (if lError then "with errors!" else "successfully.~n") ).
assign lError = no.

PUBLISH "DCU_WriteLog":U ("*** Update object instance object_sequence with Order attribute value ...").   			           
/* Find all object instances with zero sequence values. */
for each ryc_object_instance where
		 ryc_object_instance.container_smartobject_obj >= 0 and
		 ryc_object_instance.page_obj 				   >= 0 and
		 ryc_object_instance.object_sequence 		    = 0
		 no-lock,
    first ryc_smartobject where
    	  ryc_smartobject.smartobject_obj = ryc_object_instance.smartobject_obj
    	  no-lock:
	FIND FIRST ryc_attribute_value WHERE
			   ryc_attribute_value.attribute_label = "Order":U 		 				 and
			   ryc_attribute_value.object_type_obj = ryc_smartobject.object_Type_obj and
			   ryc_attribute_value.smartobject_obj = ryc_smartobject.smartobject_obj and
			   ryc_attribute_value.object_instance_obj = ryc_object_instance.object_instance_obj
			   no-lock no-error.
	if not available ryc_attribute_Value then			   
	FIND FIRST ryc_attribute_value WHERE
			   ryc_attribute_value.attribute_label = "Order":U 		 			     and
			   ryc_attribute_value.object_type_obj = ryc_smartobject.object_Type_obj and
			   ryc_attribute_value.smartobject_obj = ryc_smartobject.smartobject_obj and
			   ryc_attribute_value.object_instance_obj = 0
			   no-lock no-error.
	/* Only attempt an update if the new value is non-zero. */			   
	if available ryc_attribute_value and ryc_attribute_value.integer_value ne 0 then
	do:
	    find rycoi where    
	         rowid(rycoi) = rowid(ryc_object_instance)
	         exclusive-lock no-wait no-error.
	    if locked rycoi then
	    do:
	        PUBLISH "DCU_WriteLog":U ("Unable to obtain exclusive lock. Proceeding with next record.").
	        assign lError = yes.
	        undo, next.
	    end.    /* locked rycoi */
	    
	    assign rycoi.object_sequence = ryc_attribute_value.integer_value
	           no-error.
	    if error-status:error then
	    do:
	        PUBLISH "DCU_WriteLog":U ("Error migrating object instance record. Proceeding with next record.").
	        assign lError = yes.
	        undo, next.
	    end.    /* error assigning values. */
	    
	    PUBLISH "DCU_WriteLog":U ("Updated object sequence for instance `" + ryc_object_instance.instance_name
							        + "` to `" + string(rycoi.object_sequence)
							        + "` (Object instance: " + string(rycoi.object_instance_obj) + ") ":U).
	end.	/* there is an Order attribute */
end.    /* each page object */

PUBLISH "DCU_WriteLog":U ("*** Update of object instance object_sequence with Order attribute value completed "
					      + (if lError then "with errors!" else "successfully.~n") ).
RETURN.

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

/* eof */