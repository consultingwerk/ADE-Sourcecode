/** This utility ensures that the instance_name of a particular ryc_object_instance record is unique for
 *  a particular instance of an object on a container. This is needed before the application of an index
 *  that enforeces this functionality.
 * 
 *  This utility mustbe run before delta 22 is applied.
 * ------------------------------------------------------------------------------------------------------ **/

/* Disable all triggers */
DISABLE TRIGGERS FOR DUMP OF ryc_object_instance.
DISABLE TRIGGERS FOR LOAD OF ryc_object_instance.

define temp-table ttDuplicate       no-undo
    like ryc_object_instance.
    
define buffer rycoi  for ryc_object_instance.

define variable lError      as logical              no-undo.
define variable iAdder      as integer              no-undo.

/* First make sure that there are no blanks. */
PUBLISH "DCU_WriteLog":U ("Populating blank instance names.").
for each ryc_object_instance where
         ryc_object_instance.instance_name = "":U
         no-lock,
   first ryc_smartobject where
         ryc_smartobject.smartobject_obj = ryc_object_instance.smartobject_obj
         no-lock:
         
    find rycoi where
         rowid(rycoi) = rowid(ryc_object_instance)
         exclusive-lock no-wait no-error.
    if locked rycoi then
    do:
        PUBLISH "DCU_WriteLog":U ("Unable to obtain exclusive lock. Proceeding with next record.").
        assign lError = yes.
        next.            
    end.    /* locked. */
    
    if can-find(first rycoi where                        
                      rycoi.container_smartobject_obj = ryc_object_instance.container_smartobject_obj and
                      rycoi.smartobject_obj           = ryc_smartobject.smartobject_obj               and
                      rowid(rycoi) <> rowid(ryc_object_instance) ) then
        assign rycoi.instance_name = "***":U + ryc_smartobject.object_filename no-error.
    else
        assign rycoi.instance_name = ryc_smartobject.object_filename no-error.
    
    if error-status:error then
    do:
        PUBLISH "DCU_WriteLog":U ("Error migrating object instance record. Proceeding with next record.").
        assign lError = yes.
        next.
    end.    /* error assigning values. */
end.    /* each rycoi with instance_name = '' */
PUBLISH "DCU_WriteLog":U ("Population of blank instance names completed "
                          + (if lError then "with errors!" else "succesfully.") ).
                          
assign lError = no.
PUBLISH "DCU_WriteLog":U ("Ensure that each object instance has a unique instance name ...").

for each ryc_object_instance no-lock,
   FIRST ryc_smartObject where
         ryc_smartObject.smartobject_obj = ryc_object_instance.container_smartOBject_obj
         no-lock
         break by ryc_object_instance.container_smartobject_obj
               by ryc_object_instance.instance_name:
                       
    /* There is a duplicate name. Keep a copy of this record for later processing. */
    if not first-of(ryc_object_instance.instance_name) then
    do:
        create ttDuplicate.
        buffer-copy ryc_object_instance to ttDuplicate.        
    end.    /* there is a duplicate name */
END.    /* each object instance. */

for each ttDuplicate:
    assign iAdder = 1.
    
    /* we create a new instance name as follows:
     * ttDuplicate.instance_name(iAdder). We need to find the largest value for iAdder.
     */
    repeat:
        find first ryc_object_instance where
	               ryc_object_instance.container_smartobject_obj = ttDuplicate.container_smartobject_obj     and
	               ryc_object_instance.instance_name             = ttDuplicate.instance_name 
                                                                 + "(":U + string(iAdder) + ")":U
	               no-lock no-error.
        /* if there is no instance by this name, then we can use this and there is no need for the loop */
        if not available ryc_object_instance then
            leave.
        /* aalternatively, increment by one and continue. */    
        assign iAdder = iAdder + 1.
        next.            
    end.    /* find unique name. */
    
    /* At this stage of proceedings we should have the makings for a 
     * unique name. Now we update the record. 
     */
    find rycoi where
         rycoi.object_instance_obj = ttDuplicate.object_instance_obj
         exclusive-lock no-wait no-error.
    if locked rycoi then
    do:
        PUBLISH "DCU_WriteLog":U ("Unable to obtain exclusive lock. Proceeding with next record.").
        assign lError = yes.
        next.            
    end.    /* locked. */
        
    assign rycoi.instance_name = ttDuplicate.instance_name + "(":U + string(iAdder) + ")":U no-error.
    if error-status:error then
    do:
        PUBLISH "DCU_WriteLog":U ("Error migrating object instance record. Proceeding with next record.").
        assign lError = yes.
        next.
    end.    /* error assigning values. */
    
    /* Log the changed name, in case of problems later. */    
    PUBLISH "DCU_WriteLog":U ("Changing instance name from " + ttDuplicate.instance_name + " to ":U + rycoi.instance_name).
end.    /* each duplicate. */

PUBLISH "DCU_WriteLog":U ("Ensuring that instance names are unique completed "
                          + (if lError then "with errors!" else "successfully.") ).

/* eof */