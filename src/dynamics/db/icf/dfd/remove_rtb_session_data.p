/* Copyright (c) 2006 by Progress Software Corporation. All rights reserved. */
/*---------------------------------------------------------------------------------
  File: remove_rtb_session_data.p

  Description: Removes RoundTable-specific session type data. The RTB site
               changes with each branch, and we can't do this via
               ADO load since in some cases the new 'input' session type has the
               same name as one of the 'output' session types for an earlier release.
               This causes index errors and the load to fail.
                
               This program will remove all RTB session data, which will then be re-added
               via ADO later. This program will only run on migrations, not for upgrades.

  DCU Information:
  	PatchStage: PreADOLoad
    Rerunnable: Yes
    NewDB: No
    ExistingDB: Yes
    UpdateMandatory: Yes

  History:
  --------
  (v:010000)    Task:           0   UserRef: 
                Date:   2006-11-22  Author: Peter Judge

  Update Notes: Created from scratch 

-------------------------------------------------------------------------*/
define variable lError                  as logical no-undo.
define variable rPhysicalService        as rowid no-undo extent 10.
define variable iRowidCnt               as integer no-undo.
define variable iLoop                   as integer no-undo.

define buffer gsmpy for gsm_physical_service.
define buffer gsmse for gsm_session_type.
define buffer gsmse2 for gsm_session_type.
define buffer gsmsv for gsm_session_service.
define buffer gscst for gsc_service_type.

publish 'DCU_WriteLog' ('Start removal of RoundTable session types ...').

lError = no.
rPhysicalService = ?.
iRowidCnt = 0.
for each gsmse where
         gsmse.session_type_code begins 'rtb_':u
         no-lock:
    for each gsmsv where
             gsmsv.session_type_obj = gsmse.session_type_obj
             no-lock,
         each gsmpy where
              gsmpy.physical_service_obj = gsmsv.physical_service_obj
              no-lock,
         each gscst where
              gscst.service_type_obj = gsmpy.service_type_obj and
              gscst.service_type_code = 'AppServer':u
              no-lock:
        iRowidCnt = iRowidCnt + 1.
        rPhysicalService[iRowidCnt] = rowid(gsmpy).
    end.    /* each session service */
    
    /* find and delete the session type */
    find gsmse2 where
         rowid(gsmse2) = rowid(gsmse)
         exclusive-lock no-wait no-error.
    if locked gsmse2 then
    do:
        publish 'DCU_WriteLog' ('ERROR: Unable to lock session type ' + gsmse.session_type_code + ' for deletion.').
        lError = yes.        
        next.
    end.    /* locked */
    
    if not available gsmse2 then
    do:
        publish 'DCU_WriteLog' ('ERROR: Unable to find session type ' + gsmse.session_type_code + ' for deletion.').
        lError = yes.        
        next.
    end.    /* not available */
    
    delete gsmse2 no-error.
    if error-status:error or return-value ne '':u then
    do:
        publish 'DCU_WriteLog' ('ERROR: Unable to delete session type ' + gsmse.session_type_code).
        lError = yes.
        next.
    end.    /* deletion error */
end.  /* each session type */

/* now delete the physical services, after the session service records have been
   removed by the cascading delete. */
do iLoop = 1 to iRowidCnt:
	/* find and delete the physical service */
    find gsmpy where
         rowid(gsmpy) = rPhysicalService[iLoop] 
         no-lock no-error.

    if not available gsmpy then
    do:
        publish 'DCU_WriteLog' ('ERROR: Unable to find physical service ' + string(rPhysicalService[iLoop]) + ' for deletion.').
        lError = yes.
        next.
    end.    /* not available */

    find current gsmpy exclusive-lock no-wait no-error.         
    if locked gsmpy then
    do:
        publish 'DCU_WriteLog' ('ERROR: Unable to lock physical service ' + gsmpy.physical_service_code + ' for deletion.').
        lError = yes.
        next.
    end.    /* locked */
    
    delete gsmpy no-error.
    if error-status:error or return-value ne '':u then
    do:
        publish 'DCU_WriteLog' ('ERROR: Unable to delete physical service ' + gsmpy.physical_service_code).
        lError = yes.
        next.
    end.    /* deletion error */
end.    /* loop through rowids */

publish 'DCU_WriteLog' ('Removal of RoundTable session data completed '
                          + (if lError then 'with errors!' else 'successfully.') ).

error-status:error = no.
return.
/* EOF */