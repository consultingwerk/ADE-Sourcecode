/** Include to create attribute values in temp-table.
 *
 *  Arguments:
 *      &ClassBuffer    - handle variable
 *      &AttributeTable - name of the ryc_attribute_value table
 *      &InstanceId     - variable containing instanceid field
 *      &CacheTable - name of the buffer of the cache_Object temp-table. 
 *   ----------------------------------------------------------------------------------------------- **/
/* Make sure that the attribute is in the class table. We
 * need to do this so that we can get the ordinal value of the field. */
assign hBufferField = ?
       hBufferField = {&ClassBuffer}:buffer-field({&AttributeTable}.attribute_label) no-error.
if valid-handle(hBufferField) then
do:
    /* If we have stored this attribute value already, then we need go no
     * further.
     */
    if can-do({&CacheTable}.AttrOrdinals, string(hBufferField:POSITION - 1)) then
        next.
    
    CASE hBufferField:DATA-TYPE:
        WHEN "DECIMAL":U THEN ASSIGN cAttributeValue = STRING({&AttributeTable}.decimal_value).
        WHEN "INTEGER":U THEN ASSIGN cAttributeValue = STRING({&AttributeTable}.integer_value).
        WHEN "DATE":U    THEN ASSIGN cAttributeValue = STRING({&AttributeTable}.date_value).
        WHEN "RAW":U     THEN ASSIGN cAttributeValue = STRING({&AttributeTable}.raw_value).
        WHEN "LOGICAL":U THEN ASSIGN cAttributeValue = STRING({&AttributeTable}.logical_value).
        WHEN "RECID":U   THEN ASSIGN cAttributeValue = STRING({&AttributeTable}.integer_value).
        WHEN "HANDLE":U  THEN ASSIGN cAttributeValue = "?":U.
        OTHERWISE             ASSIGN cAttributeValue = {&AttributeTable}.character_value.
    END CASE.   /* data type */
    
    /* Special treatment for certain attributes.
     */
    CASE {&AttributeTable}.attribute_label:
        /* A super procedure may have it's own super procedures. Resolve this 
           in the retrieval.
         */
        when "SuperProcedure":U then
        do:
            /* If there is a valid value, then determine the super procedures
             */
            if cAttributeValue ne "":U and cAttributeValue ne ? then
                assign cAttributeValue = cAttributeValue + ",":U
                                       + dynamic-function("deriveSuperProcedures":U in target-procedure,
                                                           input cAttributeValue,
                                                           input {&AttributeTable}.Render_Type_Obj   ).
                       cAttributeValue = trim(cAttributeValue, ",":U).
        end.    /* SuperProcedure */
    END CASE.    /* attribute label */
    
    ASSIGN {&CacheTable}.AttrOrdinals = {&CacheTable}.AttrOrdinals + ",":U + string(hBufferField:POSITION - 1)
           {&CacheTable}.AttrValues   = {&CacheTable}.AttrValues + {&Value-Delimiter}
                                        + (if cAttributeValue eq ? then "?":U else cAttributeValue).
end.    /* valid buffer field. */
/* ---  eof --- */