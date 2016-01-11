/** This migration utility sets the value of the applies_at_runtime attribute to NO for certain attributes,
    particularly those attributes that can be stored against a buffer field widget - ie. those attributes
    that can be stored by creating a temp-table.
  
    This utility can be re-run.
   ------------------------------------------------------------------------------------------------------ **/

function getClassChildren    returns character ( input pcClass as character) forward.

define variable lError                  as logical      no-undo.
DEFINE VARIABLE lAppliesAtRuntime       AS LOGICAL      NO-UNDO.
define variable cClassList              as character    no-undo.
define variable cEntityClasses          as character    no-undo.
define variable cBufferFieldCanQuery    as character    no-undo.
define variable iObjectSequence         as integer      no-undo.
define variable iLoop                   as integer      no-undo.
define variable hBuffer                 as handle       no-undo.
define variable hBufferField            as handle       no-undo.

/* Pick any field. We just need the handle to reference a buffer field object. */
assign cBufferFieldCanQuery = "Format,Data-Type,Label,DefaultValue,ColumnLabel".

define buffer rycav     for ryc_attribute_value.
define buffer rycoi     for ryc_object_instance.
define buffer rycso     for ryc_smartobject.

assign lError         = no
       cClassList     = getClassChildren("DataField")
       cEntityClasses = getClassChildren("Entity").

publish "DCU_WriteLog" ("Updating `applies_at_runtime` flag for DataField master attributes that can "
                        + " be set against a buffer field widget handle." ).

do iLoop = 1 to num-entries(cClassList, chr(1)):
    for each ryc_smartobject where
              ryc_smartobject.object_type_obj = decimal(entry(iLoop, cClassList, chr(1)))
              no-lock:
        for each ryc_attribute_value where
                 ryc_attribute_value.object_type_obj = ryc_smartobject.object_type_obj and
                 ryc_attribute_value.smartobject_obj = ryc_smartobject.smartobject_obj and
                 ryc_attribute_value.object_instance_obj = 0
                 no-lock:
            if can-do(cBufferFieldCanQuery, ryc_attribute_value.attribute_label) then
            do:
                /* Set the APPLIES_AT_RUNTIME value to NO if this object is contained
                   by an object belonging to the Entity class, otherwise set it TRUE.
                 */
                assign lAppliesAtRuntime = yes.
                for each rycoi where
                         rycoi.smartobject_obj = ryc_smartobject.smartobject_obj
                         no-lock,
                   first rycso where
                         rycso.smartobject_obj = rycoi.container_smartobject_obj and
                         can-do(cEntityClasses, string(rycso.object_type_obj))
                         no-lock:
                    assign lAppliesAtRuntime = no.
                    leave.
                end.    /* each object instance. */                             
       
                find rycav where
                     rowid(rycav) = rowid(ryc_attribute_value)
                     exclusive-lock no-wait no-error.
                if locked rycav then
                do:
                    PUBLISH "DCU_WriteLog":U ("Unable to obtain exclusive lock. Proceeding with next record.").
                    assign lError = yes.
                    undo, next.
                end.    /* locked rycav */
                
                assign rycav.applies_at_runtime = lAppliesAtRuntime no-error.
       
                if error-status:error then
                do:
                    PUBLISH "DCU_WriteLog":U ("Error updating attribnute value record. Proceeding with next record.").
                    assign lError = yes.
                    undo, next.
                end.    /* error assigning values. */
            
            end.    /* this is a can-query() attribute for the buffer field */            
        end.    /* attribute values  for the Datafield */                 
    end.    /* all DataField masters */
end.    /* data field classes */
                  
PUBLISH "DCU_WriteLog":U ("Update of DataField master applies_at_runtime flag completed "
                          + (if lError then "with errors!" else "successfully.~n") ).
RETURN.

function getClassChildren    returns character
    (input pcClass as character):
/* This code taken from getClassChildrenFromDB() in the Repository Manager.
 */
    
    DEFINE VARIABLE cCurrentClassList AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dObjectTypeObj    AS DECIMAL    NO-UNDO.

    /* Localize the gsc_object_type buffer to this function. 
     * This is particularly important seeing that the function is called recursively */
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
        END.    /* each class */
    END.    /* available class */
            
    return cCurrentClassList.
end function.    /* getclasschildren */

/* eof */