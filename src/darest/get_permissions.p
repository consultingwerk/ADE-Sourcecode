/*************************************************************/
 /* Copyright (c) 2011 by progress Software Corporation.      */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
/*------------------------------------------------------------------------
    File        : get_permissions.p
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
using OpenEdge.DataAdmin.Rest.IRestRequest.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler.
using OpenEdge.DataAdmin.IUserTablePermission.
using OpenEdge.DataAdmin.IUserTablePermissionSet.
using OpenEdge.DataAdmin.Error.NotFoundError.

/* keeping old - to be deprecated */
{darest/restbase.i get permissions} 

procedure Execute:
    define input  parameter restRequest as IRestRequest  no-undo.      
    /* ***************************  Definitions  ************************** */
    define variable perm           as IUserTablePermission no-undo.
    define variable permset        as IUserTablePermissionSet no-undo.
    define variable service        as DataAdminService no-undo.
    define variable errorHandler   as DataAdminErrorHandler no-undo.
    define variable collectionList as character no-undo.
    /* ***************************  Main Block  *************************** */
   
    restRequest:Validate().
    service = new DataAdminService(restRequest:ConnectionName).
   
    service:URL = restRequest:ConnectionUrl.

    if restRequest:KeyValue[1] > "" then 
    do:
         /*        perm = service:GetPermission(restRequest:KeyValue[1]).*/
        if not valid-object(perm) then
            undo, throw new NotFoundError("Permission '"  + restRequest:KeyValue[1]  + "' not found").
         
        perm:ExportTree(restRequest:OutFileName).
    end.    
    else if restRequest:CollectionName[1] = "permissions" then
    do:
        collectionList = restRequest:GetQueryValue("collections").
        permSet = service:GetPermissions( collectionList ).  
        permSet:ExportNormalized(restRequest:OutFileName).
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