/** This utility updates the applies_at_runtime flag on the ryc_attribute_value table. The value of this
 *  flag is based on the runtime_only and design_only values on the ryc_attribute table.
 *  
 *  This utility must be run after delta 21 has been applied.
 * ------------------------------------------------------------------------------------------------------ **/

/* Disable all triggers */
DISABLE TRIGGERS FOR DUMP OF ryc_attribute_value.
DISABLE TRIGGERS FOR LOAD OF ryc_attribute_value.

define variable lError as logical no-undo.

assign lError = no.

PUBLISH "DCU_WriteLog":U ("Start update of applies_at_runtime flag ...").

/* if the value of the design_only flag is true, then this won't apply at runtime. */
for each ryc_attribute where
         ryc_attribute.design_only  = yes or
         ryc_attribute.runtime_only = yes
         no-lock,
   each ryc_attribute_value where
        ryc_attribute_value.attribute_label = ryc_attribute.attribute_label
        exclusive-lock:
    assign ryc_attribute_value.applies_at_runtime = no no-error.
    if error-status:error then
    do:
        PUBLISH "DCU_WriteLog":U ("Error updating applies_at_runtime flag. Proceeding with next record.").
        assign lError = yes.
        next.
    end.    /* error assigning values. */
end.    /* loop through runtime and design time attributes */
         
PUBLISH "DCU_WriteLog":U ("Update of applies_at_runtime flag completed "
                          + (if lError then "with errors!" else "successfully.") ).

/* eof */