/*************************************************************/  
/* Copyright (c) 1984-2009 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: update_dynamics_version_property.p

  Description:  Noddy to update the DynamicsVersion session property

  DCU Information:
  	PatchStage: PostADOLoad
    Rerunnable: Yes
    NewDB: No
    ExistingDB: Yes
    UpdateMandatory: Yes

  History:
  --------
  (v:010000)    Task:           0   UserRef: 
                Date:   2005-03-14   Author: Peter Judge

  Update Notes: Created from scratch

-------------------------------------------------------------------------*/
define variable lError        as logical            no-undo.

define buffer gscsp    for gsc_session_property.
define buffer gsmsy    for gsm_session_type_property.

&scoped-define DYNAMICS-VERSION 10.2B

publish 'DCU_WriteLog' ('Start update of DynamicsVersion session property ...').

find gscsp where
     gscsp.session_property_name = 'DynamicsVersion'
     exclusive-lock no-wait no-error.

if not available gscsp or locked gscsp then
do:
    publish 'DCU_WriteLog' ('ERROR: Unable to find DynamicsVersion session property.').
    
    error-status:error = no.
    return.
end.    /* n/a session prop */

/* Make sure the default value is set correctly */
assign gscsp.default_property_value = '{&DYNAMICS-VERSION}' no-error.
validate gscsp no-error.
if error-status:error or return-value ne '' then
do:
    publish 'DCU_WriteLog' ('ERROR: Unable to update DynamicsVersion session property default value.').
    
    error-status:error = no.
    return.
end.    /* error updating session property default value */

/* update all the session property types */
lError = no.
for each gsmsy where
         gsmsy.session_property_obj = gscsp.session_property_obj
         exclusive-lock:
    assign gsmsy.property_value = '{&DYNAMICS-VERSION}' no-error.
    
    validate gsmsy no-error.
	if error-status:error or return-value ne '' then
	do:
	    publish 'DCU_WriteLog' ('ERROR: Unable to update DynamicsVersion session property value.').
	    lError = yes.
	end.    /* error updating session property default value */     
end.    /* each session property type */

publish 'DCU_WriteLog' ('Update of DynamicsVersion session property completed '
                          + (if lError then 'with errors!' else 'successfully.') ).
                          
error-status:error = no.
return.
/* EOF */
