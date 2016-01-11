/** Ths utility will ensure that the instance_name field is correct in that it matches the value of the
    attribute that contains the name of the instance.
   
   ------------------------------------------------------------------------------------------------------ **/
function getClassChildren	returns character
	(input pcClass as character) forward.

function inheritsFrom	returns logical
	(input pcClass		  as character,
	 input pcInheritsFrom as character) forward.


DEFINE VARIABLE lError              AS LOGICAL      NO-UNDO.
define variable cNewValue			as character	no-undo.

define buffer rycoi		for ryc_object_instance.
define buffer rycso		for ryc_smartobject.

publish "DCU_WriteLog":U ("Update of blank layout positions started.").

for each ryc_object_instance where
		 ryc_object_instance.layout_position = "":U
		 no-lock,
   first ryc_smartobject where
   		 ryc_smartobject.smartobject_obj = ryc_object_instance.smartobject_obj
   		 no-lock,
   first gsc_object_type where
   		 gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj
   		 no-lock:
          		    		 
	/* Only update the layout position if this is not a field on a viewer. */
	if inheritsFrom(gsc_object_type.object_type_code, 'Base')      then
	do:
		/* Use the page's layout. If there is no associated page, then
		 * look at the container object iteself.
		 */
		find first ryc_page where
				   ryc_page.page_obj = ryc_object_instance.page_obj
				   no-lock no-error.
		if available ryc_page then
			find first ryc_layout where
					   ryc_layout.layout_obj = ryc_page.layout_obj
					   no-lock no-error.
		else
		do:
			find first rycso where
					   rycso.smartobject_obj = ryc_object_instance.container_smartobject_obj
					   no-lock no-error.
			if available rycso then
				find first ryc_layout where
						   ryc_layout.layout_obj = rycso.layout_obj
						   no-lock no-error.
		end.	/* not on a page. */
		
		if available ryc_layout then
		do:		
			if inheritsFrom(gsc_object_type.object_type_code, 'Browser') then
			do:
				if ryc_layout.layout_code = "06" then
					assign cNewValue = "M91".
				else
					assign cNewValue = "Bottom".
			end.	/* browser */
			else
			if inheritsFrom(gsc_object_type.object_type_code, 'SmartToolbar') then
			do:
				if ryc_layout.layout_code = "06" then
					assign cNewValue = "M11".
				else
					assign cNewValue = "Top".
			end.	/* toolbar */
			else
			do:
				if ryc_layout.layout_code = "06" then
					assign cNewValue = "M21".
				else
					assign cNewValue = "Centre".								
			end.	/* all others */

			/* change the object instance record to point at the new smartobject  */
			find rycoi where
				 rowid(rycoi) = rowid(ryc_object_instance)
				 exclusive-lock no-wait no-error.
			if locked rycoi then
			do:
				assign lError = yes.
				publish "DCU_WriteLog":U ("Unable to lock object instance for update.").
				undo, next.
			end.	/* locked */
			
			assign rycoi.layout_position = cNewValue no-error.
			if error-status:error then
			do:
				assign lError = yes.
				publish "DCU_WriteLog":U ("Unable to assign layout position " + cNewValue + " for " + rycoi.instance_name).
				undo, next.
			end.
															
			publish "DCU_WriteLog" ("Updated layout position for instance `" + ryc_object_instance.instance_name
							        + "` to `" + cNewValue + "` for layout " + ryc_layout.layout_name
							        + "(Object instance: " + string(rycoi.object_instance_obj) + ") ":U).
		end.	/* available layout */
	end.	/* not a datafield or local fill-in */
end.	/* each object instance */

publish "DCU_WriteLog":U ("Update of blank layout positions completed "
                          + (IF lError THEN "with errors!" ELSE "successfully.") ).

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

function inheritsFrom	returns logical
	(input pcClass		  as character,
	 input pcInheritsFrom as character):
	 
	define variable cHierarchy		as character	no-undo.
	
	assign cHierarchy = getClassChildren(pcInheritsFrom).
	
	if cHierarchy = "":U then
		return no.
	
	find first gsc_object_type where
			   gsc_object_type.object_type_code = pcClass
			   no-lock no-error.
	if not available gsc_object_Type then
		return no.
			
	return lookup(string(gsc_object_type.object_type_obj), cHierarchy, chr(1)) gt 0.
end function.	/* inheritsFrom */