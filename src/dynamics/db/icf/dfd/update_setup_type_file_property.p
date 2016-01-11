/************************************************************  
 * Copyright (c) 2006,2007 by Progress Software Corporation      *
 * All rights reserved.                                     *
************************************************************/
/*---------------------------------------------------------------------------------
  File: update_setup_type_file_property.p

  Description:  Noddy to update the setup_type_file session property

  DCU Information:
  	PatchStage: PostADOLoad
    Rerunnable: Yes
    NewDB: No
    ExistingDB: Yes
    UpdateMandatory: Yes

  History:
  --------
  (v:010000)    Task:           0   UserRef: 
                Date:   2006-01-03   Author: Peter Judge

  Update Notes: Created from scratch

-------------------------------------------------------------------------*/
define variable lError            as logical            no-undo.
define variable lFoundProp        as logical            no-undo.
define variable iLoop             as integer            no-undo.
define variable dSessionTypeObj   as decimal            no-undo.

define buffer gsmse        for gsm_session_type.
define buffer gscsp        for gsc_session_property.
define buffer gsmsy        for gsm_session_type_property.
define buffer gsmsy_parent for gsm_session_type_property.

&scoped-define PROPERTY-NAME setup_type_file
&scoped-define PROPERTY-VALUE db/icf/dfd/setup102A.xml
&scoped-define SETUP-TYPES ProgressSetup,Migrate21Setup,Migrate100Setup,Migrate101ASetup,Migrate101BSetup,Migrate101CSetup

publish 'DCU_WriteLog' ('Start update of {&PROPERTY-NAME} session property ...').

find gscsp where
     gscsp.session_property_name = '{&PROPERTY-NAME}'
     exclusive-lock no-wait no-error.

if not available gscsp or locked gscsp then
do:
    publish 'DCU_WriteLog' ('ERROR: Unable to find {&PROPERTY-NAME} session property.').
    lError = yes.
end.    /* n/a session prop */
else
do:
	/* Make sure the default value is set correctly */
    assign gscsp.default_property_value = '{&PROPERTY-VALUE}' no-error.
    validate gscsp no-error.
    if error-status:error or return-value ne '' then
    do:
        publish 'DCU_WriteLog' ('ERROR: Unable to update {&PROPERTY-NAME} session property default value.').
        lError = yes.    
    end.    /* error updating session property default value */
end.    /* found & locked prop */

/* Update all the session property types that we know belong to
   Dynamics. */
if not lError then
do iLoop = 1 to num-entries('{&SETUP-TYPES}'):
    find gsmse where
         gsmse.session_type_code = entry(iLoop, '{&SETUP-TYPES}')
         no-lock no-error.
    
    if not available gsmse then
    do:
        publish 'DCU_WriteLog' ('ERROR: Unable to find session type: ' + entry(iLoop, '{&SETUP-TYPES}')).
        lError = yes.
    end.    /* n/a session type */
    else
    do:
        lFoundProp = no.
        
        find gsmsy where
             gsmsy.session_type_obj = gsmse.session_type_obj and
             gsmsy.session_property_obj = gscsp.session_property_obj
             exclusive-lock no-wait no-error.        
        if locked gscsp then
        do:
            publish 'DCU_WriteLog' ('ERROR: Unable to lock {&PROPERTY-NAME} session property value for update.').
            lError = yes.
        end.    /* locked session prop */
        else
        if not available gsmsy then
        do:
            /* If there's no property against this session type, then
               see if this session type has a parent. If it does, then
               check up the tree to see if we can find a property. 	*/
            dSessionTypeObj = gsmse.extends_session_type_obj.
            repeat while dSessionTypeObj gt 0 and not lFoundProp:
                find gsmse where
                     gsmse.session_type_obj = dSessionTypeObj
                     no-lock no-error.
                if available gsmse then
                do:
                    find gsmsy where
                         gsmsy.session_type_obj = gsmse.session_type_obj and
                         gsmsy.session_property_obj = gscsp.session_property_obj
                         exclusive-lock no-wait no-error.
                    if locked gscsp then
                    do:
                        publish 'DCU_WriteLog' ('ERROR: Unable to lock {&PROPERTY-NAME} session property value for update.').
                        lError = yes.
                        dSessionTypeObj = 0.    /* force the leave. */
                    end.    /* locked session prop */
                    else
                    if available gsmsy then
                        lFoundProp = yes.
                    else    /* if not available gsmsy */
                        dSessionTypeObj = gsmse.extends_session_type_obj.
                end.    /* parent session type available */
            end.    /* climb tree */
            
            /* By climbing the tree, we may be affecting other session type when we change
               the {&PROPERTY-NAME} property. */
            if lFoundProp then
                publish 'DCU_WriteLog' ('WARNING: The "'
                                       + entry(iLoop, '{&SETUP-TYPES}') + '" setup type inherits the value '
                                       + 'of the {&PROPERTY-NAME} property from the "' 
                                       + gsmse.session_type_code + '" session type.'
                                       + ' This may affect other child session types.').
        end.    /* n/a gsmsy */
        else
            lFoundProp = yes.
        
        if lFoundProp then
        do:
            assign gsmsy.property_value = '{&PROPERTY-VALUE}' no-error.
            
            validate gsmsy no-error.
        	if error-status:error or return-value ne '' then
        	do:
        	    publish 'DCU_WriteLog' ('ERROR: Unable to update {&PROPERTY-NAME} session property value.').
        	    lError = yes.
        	end.    /* error updating session property default value */     
        end.    /* found & locked sess prop */
        else
        do:
            publish 'DCU_WriteLog' ('ERROR: Unable to find {&PROPERTY-NAME} session property value for session type "'
                                    + entry(iLoop, '{&SETUP-TYPES}') + '"').
        	lError = yes.
        end.    /* property not found */
    end.    /* available sess type */
end.    /* each session type */

publish 'DCU_WriteLog' ('Update of {&PROPERTY-NAME} session property completed '
                          + (if lError then 'with errors!' else 'successfully.') ).

error-status:error = no.
return.
/* EOF */
