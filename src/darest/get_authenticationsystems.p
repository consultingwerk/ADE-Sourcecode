/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : get_authenticationsystems.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     :  
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.IAuthenticationSystemSet from propath.
using OpenEdge.DataAdmin.IAuthenticationSystem from propath.
using OpenEdge.DataAdmin.Rest.IRestRequest from propath.
using OpenEdge.DataAdmin.Rest.IPageRequest from propath.
using OpenEdge.DataAdmin.Error.NotFoundError from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.

{darest/restbase.i get authenticationsystems}
 
procedure Execute :
    define input  parameter restRequest as IRestRequest  no-undo.
    /* ***************************  Definitions  ************************** */
   
    define variable authenticationSystems  as IAuthenticationSystemSet no-undo.
    define variable authenticationSystem   as IAuthenticationSystem no-undo.
    define variable pageRequest  as IPageRequest no-undo.
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    /* ***************************  Main Block  *************************** */
    
    restRequest:Validate().
    service = new DataAdminService(restRequest:ConnectionName).
   
    service:URL = restRequest:ConnectionUrl.
    
    if restRequest:KeyValue[1] > "" then 
    do:
        authenticationSystem = service:GetAuthenticationSystem(restRequest:KeyValue[1]).
        if not valid-object(authenticationSystem) then
            undo, throw new NotFoundError("AuthenticationSystem '"  + restRequest:KeyValue[1]  + "' not found").
         
        authenticationSystem:Export(restRequest:OutFileName).
    end.    
    else do:
        pageRequest = restRequest:GetPageRequest().
        if valid-object(pageRequest) then 
            authenticationSystems = service:GetAuthenticationSystems(pageRequest).
        else
        if restRequest:Query > "" then 
            authenticationSystems = service:GetAuthenticationSystems(restRequest:Query).
        else 
            authenticationSystems = service:GetAuthenticationSystems().
        authenticationSystems:Export(restRequest:OutFileName).    
    end. 
 
    catch e as Progress.Lang.Error :
        if session:batch-mode then
            errorHandler =  new DataAdminErrorHandler(restRequest:ErrorFileName).
        else
            errorHandler = new DataAdminErrorHandler().
        errorHandler:Error(e).      
    end catch.
    finally:
        delete object service no-error.     
    end finally.
    
end.