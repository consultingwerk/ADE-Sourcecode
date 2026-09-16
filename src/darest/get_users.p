/*************************************************************/
/* Copyright (c) 2011-2026 by progress Software Corporation  */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : get_users.p
    Purpose     : 

    Syntax      :

    Description : API to export users & granted roles to a user

    Author(s)   : rkumar
    Created     : Wed Mar 16 16:39:10 IST 2011
    Notes       :
    History     : tmasood   02/13/26  Added code to export roles granted to a user
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.

using Progress.Lang.Error.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Rest.IRestRequest.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler.
using OpenEdge.DataAdmin.IUser.
using OpenEdge.DataAdmin.IUserSet.
using OpenEdge.DataAdmin.IGrantedRoleSet.
using OpenEdge.DataAdmin.Error.NotFoundError.
using OpenEdge.DataAdmin.Rest.IPageRequest.

 
 /* old behavior - to be deprecated */
{darest/restbase.i get users}  

procedure Execute:
    define input  parameter restRequest as IRestRequest  no-undo.      
    /* ***************************  Definitions  ************************** */
    define variable tuser        as IUser no-undo.
    define variable oGrants      as IGrantedRoleSet no-undo.
    define variable userset      as IUserSet no-undo.
    define variable pageRequest  as IPageRequest no-undo.
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    /* ***************************  Main Block  *************************** */
    restRequest:Validate().
    service = new DataAdminService(restRequest:ConnectionName).
   
    service:URL = restRequest:ConnectionUrl.
    
    if restRequest:KeyValue[1] > "" then 
    do:
        if restRequest:NumLevels = 1 then 
        do:
        tuser = service:GetUser(restRequest:KeyValue[1]).
        if not valid-object(tuser) then
            undo, throw new NotFoundError("User '"  + restRequest:KeyValue[1]  + "' not found").
         
        tuser:Export(restRequest:OutFileName).
    end.    
        else If restRequest:NumLevels = 2 and restRequest:CollectionName[2] = "roles" then do:
            
            // Obtain the single user record for the ID given.
            tuser = service:GetUser(restRequest:KeyValue[1]).
            if not valid-object(tuser) then
                undo, throw new NotFoundError("User '"  + restRequest:KeyValue[1]  + "' not found").
        
            IF tuser:Domain:Name EQ "" THEN 
            // Iterate through the roles granted to this user@domain as the grantee.
                oGrants = service:GetGrantedRoles(substitute("where Grantee eq '&1'", tuser:Name)).
            ELSE
                oGrants = service:GetGrantedRoles(substitute("where Grantee eq '&1@&2'", tuser:Name, tuser:Domain:Name)).
        
            oGrants:export(restRequest:OutFileName).
        end.
        else
            undo, throw new NotFoundError("URL has wrong key values: " + restRequest:RequestUrl).
    end.    
    else do:
        pageRequest = restRequest:GetPageRequest().
        if valid-object(pageRequest) then 
            userset = service:GetUsers(pageRequest).
        else
        if restRequest:Query > "" then 
            userset = service:GetUsers(restRequest:Query ).  
        else 
            userset = service:GetUsers().
            
        userset:Export(restRequest:OutFileName).    
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
