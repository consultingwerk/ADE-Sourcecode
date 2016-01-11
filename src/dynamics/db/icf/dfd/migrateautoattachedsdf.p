/** This utility will migrate any auto-attached dynamic lookups and combos to become object instances.
   
   ------------------------------------------------------------------------------------------------------ **/

DEFINE VARIABLE lError              AS LOGICAL      NO-UNDO.
define variable iLoop                as integer        no-undo.
define variable cVisualizationType    as character    no-undo.
define variable cSdfFilename        as character    no-undo.
define variable cClassList            as character    no-undo.

define buffer rycoi        for ryc_object_instance.
define buffer rycso        for ryc_smartobject.
define buffer rycso_2   for ryc_smartobject.

function getClassChildren    returns character
    (input pcClass as character) forward.

function inheritsFrom    returns logical
    (input pcClass          as character,
     input pcInheritsFrom as character) forward.

/* These are attributes whose values must be taken from the underlying 
   field to which the SDF is auto-attached. Entries which have an = in them
   denote mapped fields: the attribute name on the left is the mapped to the
   attribute name on the right in the SDF.
 */
&SCOPED-DEFINE AUTO-ATTACH-KEEP-ATTRIBS FieldName,WidgetName,Name,ROW,COLUMN,Order,InitialValue,ENABLED,DisplayField,TableName,Name,ObjectName
        
PUBLISH "DCU_WriteLog":U ("Starting conversion of auto-attached SDFs into instances of SDFs on viewers.").

assign cClassList = getClassChildren('DynView'). 

do iLoop = 1 to num-entries(cClassList, chr(1)):
    /* Get all viewers & their contained objects. */
    VIEWER-INSTANCE-LOOP:
    for each ryc_smartobject where
             ryc_smartobject.object_type_obj = decimal(entry(iLoop,cClassList, chr(1)))
             no-lock,
        each ryc_object_instance where
             ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj
             no-lock,        
       first rycso_2 where
             rycso_2.smartobject_obj = ryc_object_instance.smartobject_obj
             no-lock,
       first gsc_object_type where
                gsc_object_type.object_type_obj = rycso_2.object_type_obj
                no-lock:
           
        assign cSdfFilename       = "":U
               cVisualizationType = "":U.
        
        /* Skip those that are already SDFs. */             
        if inheritsFrom(gsc_object_type.object_type_code, 'Field') then
            next VIEWER-INSTANCE-LOOP.
        
        /* If the object instance has an attribute of "VisualizationType" and
         * this has a value which is not "SmartDataField" and the "SDFFileName"
         * attribute has a value, then the SmartDataField referenced in the attribute
         * value is the auto-attached SDF.
         */
        FIND FIRST ryc_attribute_value WHERE
                   ryc_attribute_value.attribute_label = "SdfFileName":U         and
                   ryc_attribute_value.object_type_obj = rycso_2.object_Type_obj and
                   ryc_attribute_value.smartobject_obj = rycso_2.smartobject_obj and
                   ryc_attribute_value.object_instance_obj = ryc_object_instance.object_instance_obj
                   no-lock no-error.
        if not available ryc_attribute_Value then
        FIND FIRST ryc_attribute_value WHERE
                   ryc_attribute_value.attribute_label = "SdfFileName":U         and
                   ryc_attribute_value.object_type_obj = rycso_2.object_Type_obj and
                   ryc_attribute_value.smartobject_obj = rycso_2.smartobject_obj and
                   ryc_attribute_value.object_instance_obj = 0
                   no-lock no-error.
        if available ryc_attribute_value then
        do:
            assign cSdfFilename = ryc_attribute_value.character_value.
            
            if cSdfFilename ne "" then
            do:
                FIND FIRST ryc_attribute_value WHERE
                           ryc_attribute_value.attribute_label = "VisualizationType":U   and
                           ryc_attribute_value.object_type_obj = rycso_2.object_Type_obj and
                           ryc_attribute_value.smartobject_obj = rycso_2.smartobject_obj and
                           ryc_attribute_value.object_instance_obj = ryc_object_instance.object_instance_obj
                           no-lock no-error.
                if not available ryc_attribute_Value then               
                FIND FIRST ryc_attribute_value WHERE
                           ryc_attribute_value.attribute_label = "VisualizationType":U   and
                           ryc_attribute_value.object_type_obj = rycso_2.object_Type_obj and
                           ryc_attribute_value.smartobject_obj = rycso_2.smartobject_obj and
                           ryc_attribute_value.object_instance_obj = 0
                           no-lock no-error.
                if available ryc_attribute_value then
                    assign cVisualizationType = ryc_attribute_value.character_value.
            end.    /* there is an Sdf filename attribute */
        end.    /* there is a sdffilename */
        
        /* This is an auto-attached sdf ... */
        if cSdfFilename ne "":U and cVisualizationType ne "SmartDataField":U then
        MOVE-AA-SDF-BLOCK:
        do transaction:
            /* find the SDF */
            FIND FIRST rycso WHERE
                       rycso.object_filename          = cSdfFilename AND
                       rycso.customization_result_obj = 0
                       NO-LOCK NO-ERROR.
            
            if not available rycso then
            do:
                assign lError = yes.
                publish "DCU_WriteLog":U ("Unable to find SDF object for " + cSdfFilename).
                undo MOVE-AA-SDF-BLOCK, next VIEWER-INSTANCE-LOOP.
            end.
            
            /* Update the attributes. Use a preselect because we are changing the 
               key values.
               Only keep those attributes defined in the AUTO-ATTACH-KEEP-ATTRIBS
               preprocessor.
             */
            repeat preselect 
                      each ryc_attribute_value where
                           ryc_attribute_value.smartobject_obj     = ryc_object_instance.smartobject_obj    and
                           ryc_attribute_value.object_instance_obj = ryc_object_instance.object_instance_obj
                           exclusive-lock:
                find next ryc_attribute_value.
                
                if can-do("{&AUTO-ATTACH-KEEP-ATTRIBS}":U, ryc_attribute_value.attribute_label) then
                do:
                    /* Some of these actually change names ... */
                    if can-do("ENABLED,Name,WidgetName":U, ryc_attribute_value.attribute_label) then
                    case ryc_attribute_value.attribute_label:
                        when "ENABLED":U then assign ryc_attribute_value.attribute_label = "EnableField":U.
                        when "Name":U or when "WidgetName":U then assign ryc_attribute_value.attribute_label = "FieldName":U.                        
                    end case.    /* label */
                    
	                assign ryc_attribute_value.smartobject_obj = rycso.smartobject_obj
	                       ryc_attribute_value.object_type_obj = rycso.object_type_obj
	                       no-error.
	                if error-status:error then
	                do:
	                    assign lError = yes.
	                    publish "DCU_WriteLog":U ("Unable to update attribute value " + ryc_attribute_value.attribute_label
	                                                 + " for " + ryc_object_instance.instance_name).
	                    undo MOVE-AA-SDF-BLOCK, next VIEWER-INSTANCE-LOOP.
	                end.    /* update error */
                end.    /* keep these attributes */
                else
                do:
                    delete ryc_attribute_value no-error.
	                if error-status:error then
	                do:
	                    assign lError = yes.
	                    publish "DCU_WriteLog":U ("Unable to delete attribute value " + ryc_attribute_value.attribute_label
	                                                 + " for " + ryc_object_instance.instance_name).
	                    undo MOVE-AA-SDF-BLOCK, next VIEWER-INSTANCE-LOOP.
	                end.    /* update error */                    
                end.    /* don't keep this attribute */                 
            end.    /* preselect attributes */
            
            /* Update the Events. Use a preselect because we are changing the 
               key values.
             */
            repeat preselect 
                       each ryc_ui_event where
                           ryc_ui_event.smartobject_obj     = ryc_object_instance.smartobject_obj    and
                           ryc_ui_event.object_instance_obj = ryc_object_instance.object_instance_obj
                           exclusive-lock:
                find next ryc_ui_event.
                
                assign ryc_ui_event.smartobject_obj = rycso.smartobject_obj
                       ryc_ui_event.object_type_obj = rycso.object_type_obj
                       no-error.
                if error-status:error then
                do:
                    assign lError = yes.
                    publish "DCU_WriteLog":U ("Unable to update UI event value " + ryc_ui_event.event_name
                                              + " for " + ryc_object_instance.instance_name).
                    undo MOVE-AA-SDF-BLOCK, next VIEWER-INSTANCE-LOOP.
                end.    /* update error */
            end.    /* preselect ui events */
            
            /* change the object instance record to point at the new smartobject  */
            find rycoi where
                 rowid(rycoi) = rowid(ryc_object_instance)
                 exclusive-lock no-wait no-error.
            if locked rycoi then
            do:
                assign lError = yes.
                publish "DCU_WriteLog":U ("Unable to lock object instance for update.").
                undo MOVE-AA-SDF-BLOCK, next VIEWER-INSTANCE-LOOP.
            end.    /* locked */
            
            assign rycoi.smartobject_obj = rycso.smartobject_obj no-error.
            if error-status:error then
            do:
                assign lError = yes.
                publish "DCU_WriteLog":U ("Unable to assign new smartobject " + cSdfFilename + " for " + rycoi.instance_name).
                undo MOVE-AA-SDF-BLOCK, next VIEWER-INSTANCE-LOOP.            
            end.            
            
            publish "DCU_WriteLog" ("Converted auto-attached SDF `" + cSDfFilename
                                    + "` into instance `" + ryc_object_instance.instance_name
                                    + "` on viewer " + ryc_smartobject.object_filename    ).
        end.    /* MOVE-AA-SDF-BLOCK: transaction: update auto attached */             
    end.    /* objects, instances in class */
end.    /* loop through datafield classes */

PUBLISH "DCU_WriteLog":U ("Conversion of auto-attached SDFs into instances of SDFs on viewers, completed "
                          + (IF lError THEN "with errors!" ELSE "successfully.") ).                          

RETURN.

function getClassChildren    returns character
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
        END.    /* each class */
    END.    /* available class */
    
    return cCurrentClassList.                 
end function.    /* getclasschildren */

function inheritsFrom    returns logical
    (input pcClass          as character,
     input pcInheritsFrom as character):
     
    define variable cHierarchy        as character    no-undo.
    
    assign cHierarchy = getClassChildren(pcInheritsFrom).
    
    if cHierarchy = "":U then
        return no.
    
    find first gsc_object_type where
               gsc_object_type.object_type_code = pcClass
               no-lock no-error.
    if not available gsc_object_Type then
        return no.
            
    return lookup(string(gsc_object_type.object_type_obj), cHierarchy, chr(1)) gt 0.
end function.    /* inheritsFrom */