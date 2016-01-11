/*************************************************************/
 /* Copyright (c) 2011 by progress Software Corporation.      */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
/*------------------------------------------------------------------------
    File        : get_userpermissions.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     :  
    Notes       :
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.

using Progress.Lang.Error.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Rest.RestRequest.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler.
using OpenEdge.DataAdmin.IUserPermission.
using OpenEdge.DataAdmin.IUserPermissionSet.
using OpenEdge.DataAdmin.Error.NotFoundError.

define variable mMode       as char init "get" no-undo.
define variable mCollection as char init "userpermissions" no-undo.

if session:batch-mode and not this-procedure:persistent then 
do:
   output to value("get_userpermissions.log"). 
   run executeRequest(session:parameter).  
end.
finally:
    if session:batch-mode then output close.            
end finally.  

procedure executeRequest:
    define input  parameter pcParam as character no-undo.    
    /* ***************************  Definitions  ************************** */
    define variable perm         as IUserPermission no-undo.
    define variable permset      as IUserPermissionSet no-undo.
    define variable restRequest  as RestRequest no-undo.
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    /* ***************************  Main Block  *************************** */
    
    restRequest = new RestRequest(mMode,mCollection,pcParam).  
    
    restRequest:Validate().
    service = new DataAdminService(restRequest:ConnectionName).
   
    service:URL = restRequest:ConnectionUrl.
    
    if restRequest:KeyValue[1] > "" then 
    do:
        perm = service:GetUserPermission(restRequest:KeyValue[1]).
        if not valid-object(perm) then
            undo, throw new NotFoundError("UserPermission '"  + restRequest:KeyValue[1]  + "' not found").
         
        perm:ExportTree(restRequest:OutFileName).
    end.    
    else if restRequest:CollectionName[1] = "userpermissions" then
    do:
        if restRequest:Query > "" then 
            permSet = service:GetUserPermissions(restRequest:Query ).  
        else 
            permSet = service:GetUserPermissions(  ).  
            
        permSet:ExportTree(restRequest:OutFileName).    
    end.
    
 
    catch e as Progress.Lang.Error :
        if session:batch-mode then
            errorHandler =  new DataAdminErrorHandler(restRequest:ErrorFileName).
        else do:    
           
            errorHandler = new DataAdminErrorHandler().
        end.    
        errorHandler:Error(e).      
    end catch.
    finally:
        delete object service no-error.     
    end finally.
    
end.