/* Cleans up orphan records:   
   1. Remove object instance records where there are no associated master records.
   2. Remove object instances where there are no container smartobject records associated.   
   3. remove orphan attribute value records (no object instances, no containers, etc).
   4. remove orphan UI events records (no object instances, no containers, etc).   
   5. remove orphan smarklink records (no source or target object instances, no containrs)
   
   This procedure can be re-run as need be.
 */
 
/* Disable triggers, for use in the DCU. These 'disable' statements are undone
   scope when this procedure completes its run.
 */ 
disable triggers for dump of ryc_attribute_value.    disable triggers for load of ryc_attribute_value.
disable triggers for dump of ryc_ui_event.           disable triggers for load of ryc_ui_event.
disable triggers for dump of ryc_smartlink.          disable triggers for load of ryc_smartlink.
disable triggers for dump of ryc_object_instance.    disable triggers for load of ryc_object_instance.
 
function deleteRYCAV returns logical (input prRowid as rowid) forward.    
function deleteRYCUE returns logical (input prRowid as rowid) forward.    
function deleteRYCSM returns logical (input prRowid as rowid) forward. 

define variable lError     as logical            no-undo.

define buffer rycoi        for ryc_object_instance.

/* 1. & 2. Remove object instance records where there are no associated master records. */
publish "DCU_WriteLog":U (" ** Removing object instances with no associated smartobject records ...").   
for each ryc_object_instance no-lock:
    /* 1. No master records */
    if not can-find(ryc_smartobject where
                    ryc_smartobject.smartobject_obj = ryc_object_instance.smartobject_obj) then
    do transaction:
        find first rycoi where
                   rowid(rycoi) = rowid(ryc_object_instance)
                   exclusive-lock no-wait no-error.
        if locked rycoi then
        do:
	        publish "DCU_WriteLog":U ("Unable to lock instance `" 
                                     + ryc_object_instance.instance_name
	                                 + "` for deletion. "      ).
	        undo, next.
        end.    /* instance record locked */
        
        delete rycoi no-error.
        if error-status:error then
        do:
            assign lError = true.
	        PUBLISH "DCU_WriteLog":U ("Unable to delete instance `" + ryc_object_instance.instance_name + "`~n":U
	                                 + " Error: " + error-status:get-message(1) + "~n":U
	                                 + " ReturnValue: " + return-value        ).
            undo, next.
        end.    /* deletion error. */
        else
            publish "DCU_WriteLog":U ("Deleted instance `" + ryc_object_instance.instance_name + "`.").
        
        /* skip to the next record since we've deleted this record. */            
        next.            
    end.    /* transaction: no associated smartobject */
    
    /* 2. No container records */
    if not can-find(ryc_smartobject where
                    ryc_smartobject.smartobject_obj = ryc_object_instance.container_smartobject_obj) then
    do transaction:
        find first rycoi where
                   rowid(rycoi) = rowid(ryc_object_instance)
                   exclusive-lock no-wait no-error.
        if locked rycoi then
        do:
	        publish "DCU_WriteLog":U ("Unable to lock instance `" 
                                     + ryc_object_instance.instance_name
	                                 + "` for deletion. "      ).
	        undo, next.
        end.    /* instance record locked */
        
        delete rycoi no-error.
        if error-status:error then
        do:
            assign lError = true.
	        PUBLISH "DCU_WriteLog":U ("Unable to delete instance `" + ryc_object_instance.instance_name + "`~n":U
	                                 + " Error: " + error-status:get-message(1) + "~n":U
	                                 + " ReturnValue: " + return-value        ).
            undo, next.
        end.    /* deletion error. */
        else
            publish "DCU_WriteLog":U ("Deleted instance `" + ryc_object_instance.instance_name + "`.").
    end.    /* transaction: no associated smartobject */
end.    /* each object instance. */ 

PUBLISH "DCU_WriteLog":U (" ** Removing object instances with no associated container smartobject record completed " + (IF lError THEN "with errors!" ELSE "successfully.")).

/* 3. Remove attribute value records where there is no associated object instance, 
      container smartobject, smartobject or object type associated; also remove those
      where the smartobjects and container objects don't match the object instance record.
 */
assign lError = no. 
PUBLISH "DCU_WriteLog":U (" ** Removing orphan attribute values ... ").

for each ryc_attribute_value no-lock:    
    /* object type not there */
    if not can-find(first gsc_object_type where
                          gsc_object_type.object_type_obj = ryc_attribute_value.object_type_obj) then
    do:
        assign lError = deleteRYCAV(rowid(ryc_attribute_value)).
        /* look for next record since we've already deleted this one. */
        next.
    end.    /* no object type */

    /* smartobject not there */
    if ryc_attribute_value.smartobject_obj ne 0 and
       not can-find(first ryc_smartobject where
                          ryc_smartobject.smartobject_obj = ryc_attribute_value.smartobject_obj) then
    do:
        assign lError = deleteRYCAV(rowid(ryc_attribute_value)).
        /* look for next record since we've already deleted this one. */    
        next.
    end.    /* no smart object  */
    
    /* container smartobject not there */
    if ryc_attribute_value.container_smartobject_obj ne 0 and
       not can-find(first ryc_smartobject where
                          ryc_smartobject.smartobject_obj = ryc_attribute_value.container_smartobject_obj) then
    do:
        assign lError = deleteRYCAV(rowid(ryc_attribute_value)).
        /* look for next record since we've already deleted this one. */    
        next.
    end.    /* no container smart object  */
    
    /* object instance not there */
    if ryc_attribute_value.object_instance_obj ne 0 and
       not can-find(first ryc_object_instance where
                          ryc_object_instance.object_instance_obj = ryc_attribute_value.object_instance_obj) then
    do:
        assign lError = deleteRYCAV(rowid(ryc_attribute_value)).
        /* look for next record since we've already deleted this one. */    
        next.
    end.    /* no container smart object  */
    
    /* there is an object instance, but no container smartobject */
    if ryc_attribute_value.object_instance_obj ne 0 and
       ryc_attribute_value.container_smartobject_obj eq 0 then
    do:
        assign lError = deleteRYCAV(rowid(ryc_attribute_value)).
        /* look for next record since we've already deleted this one. */    
        next.
    end.    /* no container smart object but has object instance */
           
    /* there is a container smartobject, but no object instance */
    if ryc_attribute_value.container_smartobject_obj ne 0 and
       ryc_attribute_value.object_instance_obj eq 0 then
    do:
        assign lError = deleteRYCAV(rowid(ryc_attribute_value)).
        /* look for next record since we've already deleted this one. */    
        next.
    end.    /* has object instance but no container */
    
    /* If there is an associated object instance, the smartobject
       of the attribute value should match the smartobject of the 
       object instance. If not, delete the attribute.
     */
    if ryc_attribute_value.object_instance_obj gt 0 then
    do:
        /* at this stage there should be an object instance. if not, we 
           should have deleted the attribute value already.
         */
        find first ryc_object_instance where
                   ryc_object_instance.object_instance_obj = ryc_Attribute_value.object_instance_obj
                   no-lock no-error.
        /* the master smartobjects should match */
        if ryc_object_instance.smartobject_obj <> ryc_attribute_value.smartobject_obj then                   
        do:
	        assign lError = deleteRYCAV(rowid(ryc_attribute_value)).
	        /* look for next record since we've already deleted this one. */    
	        next.
        end.    /* master smartobjects don't match */
        
        /* the container smartobjects should match */
        if ryc_object_instance.container_smartobject_obj <> ryc_attribute_value.container_smartobject_obj then
        do:
	        assign lError = deleteRYCAV(rowid(ryc_attribute_value)).
	        /* look for next record since we've already deleted this one. */
	        next.
        end.    /* container smartobjects don't match */
        
        /* object types matches are taken care of by another migration program.
         */
    end.    /* there is an object instance. */
end.    /* each attribute value. */
PUBLISH "DCU_WriteLog":U (" ** Removing orphan attribute values completed " + (IF lError THEN "with errors!" ELSE "successfully.")).

/* 4. Remove UI event records where there is no associated object instance, 
      container smartobject, smartobject or object type associated; also remove those
      where the smartobjects and container objects don't match the object instance record.
 */
assign lError = no. 
PUBLISH "DCU_WriteLog":U (" ** Removing orphan UI events ... ").

for each ryc_ui_event no-lock:
    /* object type not there */
    if not can-find(first gsc_object_type where
                          gsc_object_type.object_type_obj = ryc_ui_event.object_type_obj) then
    do:
        assign lError = deleteRYCUE(rowid(ryc_ui_event)).
        /* look for next record since we've already deleted this one. */
        next.
    end.    /* no object type */

    /* smartobject not there */
    if ryc_ui_event.smartobject_obj ne 0 and
       not can-find(first ryc_smartobject where
                          ryc_smartobject.smartobject_obj = ryc_ui_event.smartobject_obj) then
    do:
        assign lError = deleteRYCUE(rowid(ryc_ui_event)).
        /* look for next record since we've already deleted this one. */    
        next.
    end.    /* no smart object  */
    
    /* container smartobject not there */
    if ryc_ui_event.container_smartobject_obj ne 0 and
       not can-find(first ryc_smartobject where
                          ryc_smartobject.smartobject_obj = ryc_ui_event.container_smartobject_obj) then
    do:
        assign lError = deleteRYCUE(rowid(ryc_ui_event)).
        /* look for next record since we've already deleted this one. */    
        next.
    end.    /* no container smart object  */
    
    /* object instance not there */
    if ryc_ui_event.object_instance_obj ne 0 and
       not can-find(first ryc_object_instance where
                          ryc_object_instance.object_instance_obj = ryc_ui_event.object_instance_obj) then
    do:
        assign lError = deleteRYCUE(rowid(ryc_ui_event)).
        /* look for next record since we've already deleted this one. */    
        next.
    end.    /* no container smart object  */
        
    /* there is an object instance, but no container smartobject */
    if ryc_ui_event.object_instance_obj ne 0 and
       ryc_ui_event.container_smartobject_obj eq 0 then
    do:
        assign lError = deleteRYCUE(rowid(ryc_ui_event)).
        /* look for next record since we've already deleted this one. */    
        next.
    end.    /* no container smart object but has object instance */
           
    /* there is a container smartobject, but no object instance */
    if ryc_ui_event.container_smartobject_obj ne 0 and
       ryc_ui_event.object_instance_obj eq 0 then
    do:
        assign lError = deleteRYCUE(rowid(ryc_ui_event)).
        /* look for next record since we've already deleted this one. */    
        next.
    end.    /* has object instance but no container */
    
    /* If there is an associated object instance, the smartobject
       of the UI event should match the smartobject of the 
       object instance. If not, delete the event.
     */
    if ryc_ui_event.object_instance_obj gt 0 then
    do:
        /* at this stage there should be an object instance. if not, we 
           should have deleted the event already.
         */
        find first ryc_object_instance where
                   ryc_object_instance.object_instance_obj = ryc_ui_event.object_instance_obj
                   no-lock no-error.
        /* the master smartobjects should match */
        if ryc_object_instance.smartobject_obj <> ryc_ui_event.smartobject_obj then                   
        do:
	        assign lError = deleteRYCUE(rowid(ryc_ui_event)).
	        /* look for next record since we've already deleted this one. */    
	        next.
        end.    /* master smartobjects don't match */
        
        /* the container smartobjects should match */
        if ryc_object_instance.container_smartobject_obj <> ryc_ui_event.container_smartobject_obj then
        do:
	        assign lError = deleteRYCUE(rowid(ryc_ui_event)).
	        /* look for next record since we've already deleted this one. */
	        next.
        end.    /* container smartobjects don't match */
        
        /* object types matches are taken care of by another migration program.
         */
    end.    /* there is an object instance. */
end.    /* each UI event. */
PUBLISH "DCU_WriteLog":U (" ** Removing orphan UI events completed " + (IF lError THEN "with errors!" ELSE "successfully.")).

/* 5. remove orphan smarklink records (no source or target object instances, no containrs)
 */
assign lError = no. 
PUBLISH "DCU_WriteLog":U (" ** Removing orphan link records  ... ").

for each ryc_smartlink no-lock:
    /* container smartobject not there */
    if ryc_smartlink.container_smartobject_obj ne 0 and
       not can-find(first ryc_smartobject where
                          ryc_smartobject.smartobject_obj = ryc_smartlink.container_smartobject_obj) then
    do:
        assign lError = deleteRYCSM(rowid(ryc_smartlink)).
        /* look for next record since we've already deleted this one. */
        next.
    end.    /* no container smart object  */
    
    /* source object instance not there */
    if ryc_smartlink.source_object_instance_obj ne 0 and
       not can-find(first ryc_object_instance where
                          ryc_object_instance.object_instance_obj = ryc_smartlink.source_object_instance_obj) then
    do:
        assign lError = deleteRYCUE(rowid(ryc_smartlink)).
        /* look for next record since we've already deleted this one. */    
        next.
    end.    /* no container smart object  */
    
    /* source object instance not there */
    if ryc_smartlink.target_object_instance_obj ne 0 and
       not can-find(first ryc_object_instance where
                          ryc_object_instance.object_instance_obj = ryc_smartlink.target_object_instance_obj) then
    do:
        assign lError = deleteRYCUE(rowid(ryc_smartlink)).
        /* look for next record since we've already deleted this one. */    
        next.
    end.    /* no container smart object  */            
end.    /* each UI event. */
PUBLISH "DCU_WriteLog":U (" ** Removing orphan link records completed " + (IF lError THEN "with errors!" ELSE "successfully.")).

/* *** FUNCTIONS *** */
function deleteRYCAV returns logical (input prRowid as rowid):
    /* This function performs the actual deletion of
       the attribute value records. 
     */
    define variable lError     as logical        no-undo.
    
    define buffer rycav    for ryc_attribute_value.
    
    do transaction:
	    assign lError = no.
        
	    find first rycav where
	               rowid(rycav) = prRowid
	               exclusive-lock no-wait no-error.
	    if locked rycav then
	    do:
	        publish "DCU_WriteLog":U ("Unable to lock attribute value " 
	                                 + quoter(ryc_attribute_value.attribute_value_obj)
	                                 + " for deletion. "      ).
	        undo, leave.
	    end.    /* attribute value record locked */
	    
	    delete rycav no-error.
	    if error-status:error then
	    do:
	        assign lError = true.
	        PUBLISH "DCU_WriteLog":U ("Unable to delete attribute `" + ryc_attribute_value.attribute_label + "`~n":U
	                                 + " Error: " + error-status:get-message(1) + "~n":U
	                                 + " ReturnValue: " + return-value        ).
            undo, leave.                                  
	    end.    /* deletion error. */
	    else
	        publish "DCU_WriteLog":U ("Deleted attribute value `" + quoter(ryc_attribute_value.attribute_value_obj) + "`.").        
    end.    /* transaction block. */
    
    return lError.
end function.    /* deleteRYCAV  */


function deleteRYCUE returns logical (input prRowid as rowid):
    /* This function performs the actual deletion of
       the UI event records. 
     */    
    define variable lError     as logical        no-undo.
    
    define buffer rycue    for ryc_ui_event.
    
    do transaction:
	    assign lError = no.
        
	    find first rycue where
	               rowid(rycue) = prRowid
	               exclusive-lock no-wait no-error.
	    if locked rycue then
	    do:
	        publish "DCU_WriteLog":U ("Unable to lock UI event " 
	                                 + quoter(ryc_ui_event.ui_event_obj)
	                                 + " for deletion. "      ).
	        undo, leave.
	    end.    /* attribute value record locked */
	    
	    delete rycue no-error.
	    if error-status:error then
	    do:
	        assign lError = true.
	        PUBLISH "DCU_WriteLog":U ("Unable to delete UI event `" + ryc_ui_event.event_name + "`~n":U
	                                 + " Error: " + error-status:get-message(1) + "~n":U
	                                 + " ReturnValue: " + return-value        ).
            undo, leave.                                  
	    end.    /* deletion error. */
	    else
	        publish "DCU_WriteLog":U ("Deleted UI event `" + quoter(ryc_ui_event.event_name) + "`.").
    end.    /* transaction block. */
            
    return lError.
end function.    /* deleteRYCUE  */

function deleteRYCSM returns logical (input prRowid as rowid):
    /* This function performs the actual deletion of
       the link records. 
     */    
    define variable lError     as logical        no-undo.
    
    define buffer rycsm    for ryc_smartlink.
    
    do transaction:
	    assign lError = no.
        
	    find first rycsm where
	               rowid(rycsm) = prRowid
	               exclusive-lock no-wait no-error.
	    if locked rycsm then
	    do:
	        publish "DCU_WriteLog":U ("Unable to lock UI event " 
	                                 + quoter(ryc_smartlink.smartlink_obj)
	                                 + " for deletion. "      ).
	        undo, leave.
	    end.    /* smartlink record locked */
	    
	    delete rycsm no-error.
	    if error-status:error then
	    do:
	        assign lError = true.
	        PUBLISH "DCU_WriteLog":U ("Unable to delete link `" + ryc_smartlink.link_name + "`~n":U
	                                 + " Error: " + error-status:get-message(1) + "~n":U
	                                 + " ReturnValue: " + return-value        ).
            undo, leave.                                  
	    end.    /* deletion error. */
	    else
	        publish "DCU_WriteLog":U ("Deleted link `" + ryc_smartlink.link_name + "`.").
    end.    /* transaction block. */
    
    return lError.
end function.    /* deleteRYCSM  */

/* EOF */