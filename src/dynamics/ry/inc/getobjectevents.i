/** Include to create Ui Event records for an instance.
 *
 *  Arguments:
 *      &EventTable - name of the ryc_attribute_value table
 *      &CacheTable - name of the buffer of the cache_Object temp-table.
 *  ----------------------------------------------------------------------------------------------- **/
/* Have we retrieved this event already? If so, then don't do it again. */
IF CAN-DO({&CacheTable}.EventNames, {&EventTable}.event_name) THEN
    NEXT.
        
ASSIGN {&CacheTable}.EventNames   = {&CacheTable}.EventNames + ",":U + {&EventTable}.event_name
       {&CacheTable}.EventActions = {&CacheTable}.EventActions + {&Value-delimiter}
                                    + {&EventTable}.action_type + {&Value-delimiter}
                                    + {&EventTable}.action_target + {&Value-delimiter}
                                    + {&EventTable}.event_action + {&Value-delimiter}
                                    + {&EventTable}.event_parameter.
/* ---  eof --- */