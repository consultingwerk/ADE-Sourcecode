/*************************************************************/
/* Copyright (c) 2024 by progress Software Corporation       */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : get_roles.p
    Purpose     : 
    Syntax      :
    Description : Fetch the roles & associated auth tags
    Author(s)   : tmasood
    Created     : Thu Aug 08 15:08:39 IST 2024
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

routine-level on error undo, throw.

using Progress.Lang.Error.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Rest.IRestRequest.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler.
using OpenEdge.DataAdmin.IRole.
using OpenEdge.DataAdmin.IRoleSet.
using OpenEdge.DataAdmin.Error.NotFoundError.
 
 /* old behavior - to be deprecated */
{darest/restbase.i get roles}  

procedure Execute:
    define input  parameter restRequest as IRestRequest  no-undo.      
    /* ***************************  Definitions  ************************** */
    define variable oRole        as IRole                 no-undo.
    define variable roleset      as IRoleSet              no-undo.
    define variable service      as DataAdminService      no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable cRole        as character             no-undo.
    /* ***************************  Main Block  *************************** */
    restRequest:Validate().
    service = new DataAdminService(restRequest:ConnectionName).
    cRole = if restRequest:KeyValue[1] <> "" then restRequest:KeyValue[1] else "".
   
    service:URL = restRequest:ConnectionUrl.
    
    if cRole > "" then 
    do:
        oRole = service:GetRole(cRole).
        if not valid-object(oRole) then
            undo, throw new NotFoundError("Role '"  + cRole  + "' not found").
         
        oRole:Export(restRequest:OutFileName).
    end.    
    else do:
       roleset = service:GetRoles().
       roleset:Export(restRequest:OutFileName).
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
