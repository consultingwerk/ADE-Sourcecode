/** This migration utility populates the page_obj and object_sequence field on the ryc_object_instance
 *  table in preparation for the ryc_page_obj table being dropped. 
 * 
 *  This utility mustbe run before delta 22 is applied. 
 * ------------------------------------------------------------------------------------------------------ **/

/* Disable all triggers */
DISABLE TRIGGERS FOR DUMP OF ryc_object_instance.
DISABLE TRIGGERS FOR LOAD OF ryc_object_instance.

define variable lError as logical no-undo.

assign lError = no.

PUBLISH "DCU_WriteLog":U ("Start migration of page object information to object instance ...").

for each ryc_page_object no-lock:
    find first ryc_object_instance where
               ryc_object_instance.object_instance_obj = ryc_page_object.object_instance_obj
               exclusive-lock no-wait no-error.
    if locked ryc_object_instance then
    do:
        PUBLISH "DCU_WriteLog":U ("Unable to obtain exclusive lock. Proceeding with next record.").
        assign lError = yes.
        next.
    end.    /* locked rycoi */
    
    /* Ignore the fact that there are no associated object instance records
     * since we will be deleting the page object record anyway in delta22.
     */    
    if not available ryc_object_instance then
        next.
    
    assign ryc_object_instance.page_obj        = ryc_page_object.page_obj
           ryc_object_instance.object_sequence = ryc_page_object.page_object_sequence
           no-error.
    if error-status:error then
    do:
        PUBLISH "DCU_WriteLog":U ("Error migrating object instance record. Proceeding with next record.").
        assign lError = yes.
        next.
    end.    /* error assigning values. */
end.    /* each page object */

PUBLISH "DCU_WriteLog":U ("Migration of page object information to object instance completed "
                          + (if lError then "with errors!" else "successfully.") ).

/* eof */
