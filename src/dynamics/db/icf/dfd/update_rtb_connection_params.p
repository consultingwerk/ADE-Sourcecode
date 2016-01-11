/* Copyright (c) 2006-2007 by Progress Software Corporation. All rights reserved. */
/*---------------------------------------------------------------------------------
  File: update_rtb_connection_params.p
  Description:  Noddy to update the connection parameters of the RTB* physical connections.
  DCU Information:
  	PatchStage: PostADOLoad
    Rerunnable: Yes
    NewDB: No
    ExistingDB: Yes
    UpdateMandatory: Yes
    
  History:
  --------
  (v:010000)    Task:           0   UserRef: 
                Date:   2006-11-03  Author: Peter Judge
  Update Notes: Created from scratch
-------------------------------------------------------------------------*/
define variable iLoop         as integer no-undo.
define variable lError        as logical no-undo.
define variable cService      as character no-undo.
define variable cConnType     as character no-undo.
define variable cConnParams   as character no-undo.
define variable iLoop2        as integer no-undo.

define buffer gsmpy for gsm_physical_service.

&scoped-define RTB-SERVICE-CODES asb_094dyndep,asb_095dyndep,asb_095dyndev,asb_095dyntst 
&scoped-define RTB-CONNECTION-PARAMS R-H localhost -S NS1 -AppService asb_090dyndep

publish 'DCU_WriteLog' ('Start update of RoundTable physical session connection parameters ...').

lError = no.
do iLoop = 1 to num-entries('{&RTB-SERVICE-CODES}':u):
    cService = entry(iLoop, '{&RTB-SERVICE-CODES}':u).
    publish 'DCU_WriteLog' ('Updating physical service ' + cService).    

    find gsmpy where
         gsmpy.physical_service_code = cService
         exclusive-lock no-wait no-error.

    if locked gsmpy then
    do:
        publish 'DCU_WriteLog' ('ERROR: Unable to lock physical service ' + cService + ' for update.').
        lError = yes.
        next.
    end.    /* locked */    

    if not available gsmpy then
    do:
        publish 'DCU_WriteLog' ('ERROR: Unable to find physical service ' + cService + ' for update.').
        lError = yes.
        next.
    end.    /* not available */    

    /* We want to replace the -AppService with the service code.
       RTB connection parameters should have this format:
       
        R-H localhost -S NS1 -AppService asb_090dyndep        

       There's no guarantee that any other physical services have 
       the same format (AppServers should though, but we haven't established
       that these are AppServer services). */
    cConnParams = gsmpy.connection_parameters.
    cConnType = entry(1, cConnParams, chr(3)).
    cConnParams = entry(2, cConnParams, chr(3)).        

    do iLoop2 = 1 to num-entries(cConnParams, ' ':u) by 2:
        if entry(iLoop2, cConnParams, ' ':u) eq '-AppService':u then
        do:
            entry(iLoop2 + 1, cConnParams, ' ':u) = cService.
            leave.
        end.    /* -AppService */
    end.    /* loop through conn params */

    cConnParams = cConnType + chr(3) + cConnParams.    

    gsmpy.connection_parameters = cConnParams no-error.
    validate gsmpy no-error.
	  if error-status:error or return-value ne '' then
	  do: 
	      publish 'DCU_WriteLog' ('ERROR: Unable to update physical service ' + cService).
	      lError = yes.
	  end.    /* error updating */
end.    /* loop through */

publish 'DCU_WriteLog' ('Update of of RoundTable physical session connection parameters completed '
                          + (if lError then 'with errors!' else 'successfully.') ).
error-status:error = no.
return.
/* EOF */
