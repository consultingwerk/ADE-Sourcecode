/*************************************************************/
/* Copyright (c) 2011-2026 by progress Software Corporation  */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : delete_users.p
    Purpose     : 

    Syntax      :

    Description : API to delete user & granted roles

    Author(s)   : rkumar
    Created     : 2011
    Notes       :     
    History     : tmasood   03/04/26  Added code to delete roles granted to a user     
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.IUser from propath.
using OpenEdge.DataAdmin.IGrantedRoleSet from propath.
using OpenEdge.DataAdmin.IGrantedRole from propath.
using OpenEdge.DataAdmin.IRole from propath.
using OpenEdge.DataAdmin.Lang.Collections.IIterator from propath.
using OpenEdge.DataAdmin.Error.NotFoundError from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
using OpenEdge.DataAdmin.Rest.IRestRequest  from propath.
using Progress.Json.ObjectModel.ObjectModelParser from propath.
using Progress.Json.ObjectModel.JsonObject from propath.
using Progress.Json.ObjectModel.JsonArray from propath.

define stream acceptstream. 

/* to be deprecated */
{darest/restbase.i delete users}
 
procedure Execute :
    define input parameter restRequest as IRestRequest  no-undo. 
 
    /* ***************************  Definitions  ************************** */
    define variable service              as DataAdminService no-undo.
    define variable errorHandler         as DataAdminErrorHandler no-undo.
    define variable tuser                as IUser no-undo.
    define variable cFile                as character no-undo.
    define variable cFileOut             as character no-undo.
    define variable oGrants      as IGrantedRoleSet       no-undo.
    define variable oGrant       as IGrantedRole          no-undo.
    define variable oRole        as IRole                 no-undo.
    define variable iter         as IIterator             no-undo.
    define variable oParser      as ObjectModelParser     no-undo.
    define variable oJson        as JsonObject            no-undo.
    define variable oRoleArray   as JsonArray             no-undo.
    define variable cRoleName    as character             no-undo.
    define variable iLoop        as integer               no-undo.
    define variable iMax         as integer               no-undo.   
    define variable cLong as longchar no-undo.
    define variable oAllGrants   as IGrantedRoleSet       no-undo.
     
    /* ***************************  Main Block  *************************** */
    
    service = new DataAdminService(restRequest:ConnectionName).
   
    restRequest:Validate().
    
    service:URL = restRequest:ConnectionUrl.
    
    assign
        cFile = restRequest:FileName
        cFileOut = restRequest:OutFileName.
    
    If restRequest:KeyValue[1] > "" then
    do: 
        if restRequest:NumLevels = 1 then 
        do:
            service:DeleteUser(restRequest:KeyValue[1]).
        
            output stream  acceptstream to value(cFileOut).
            put stream  acceptstream unformatted 
                "HTTP/1.1 200 OK" skip(1) 
                '~{"success" : true~}'.
            output stream  acceptstream  close.
        end.
        else if restRequest:NumLevels = 2 then 
            do:
            // DELETE /users/{grantee}/roles — delete granted roles listed in request body
            // Request body: { "roles": ["role1", "role2", ...] }
                if restRequest:CollectionName[2] <> "roles" then
                    undo, throw new NotFoundError("URL not found: " + restRequest:RequestUrl).

                tuser = service:GetUser(restRequest:KeyValue[1]).
                if not valid-object(tuser) then
                    undo, throw new NotFoundError("User '" + restRequest:KeyValue[1] + "' not found").

                oParser = new ObjectModelParser().
                oJson   = cast(oParser:ParseFile(cFile), JsonObject).
                oRoleArray = oJson:GetJsonArray("roles").

                if not valid-object(oRoleArray) or oRoleArray:Length = 0 then
                    undo, throw new OpenEdge.DataAdmin.Error.IllegalArgumentError(
                        "Request body must contain a non-empty 'roles' array").

                iMax = oRoleArray:Length.
                oAllGrants = service:NewGrantedRoles().
                // Pass 1: validate all roles and their grants — no deletes yet.
                do iLoop = 1 to iMax:
                    assign 
                        cRoleName = oRoleArray:GetCharacter(iLoop).

                    oRole = service:GetRole(cRoleName).
                    if not valid-object(oRole) then
                        undo, throw new NotFoundError("Role '" + cRoleName + "' not found").

                    oGrants = service:GetGrantedRoles(
                        substitute("where RoleName eq '&1' and Grantee eq '&2'",
                        oRole:Name, restRequest:KeyValue[1])).

                    if oGrants:IsEmpty then
                        undo, throw new NotFoundError(
                            substitute("Role '&1' is not granted to '&2'",
                            cRoleName, restRequest:KeyValue[1])).

                    iter = oGrants:Iterator().
                    do while iter:HasNext():
                        oAllGrants:Add(cast(iter:Next(), IGrantedRole)).
                    end.
                end.
                // Pass 2: all validations passed — single atomic SaveData.
                do transaction on error undo, throw:
                    service:DeleteGrantedRoles(oAllGrants) no-error.
                    if error-status:error or error-status:num-messages > 0 then
                        undo, throw new UnsupportedOperationError(error-status:get-message(1) + " All granted roles deletion have been rolled back.").
                end.

                output stream acceptstream to value(cFileOut).
                put stream acceptstream unformatted
                    "HTTP/1.1 200 OK" skip(1)
                    '~{"success" : true~}'.
                output stream acceptstream close.
            end.
        else
            undo, throw new NotFoundError("URL not found: " + restRequest:RequestUrl).
    end.
    else 
        undo, throw new UnsupportedOperationError("DELETE with no key in URL:" + restRequest:RequestUrl).    
     
    catch e as Progress.Lang.Error :
        if session:batch-mode then
            errorHandler = new DataAdminErrorHandler(restRequest:ErrorFileName).
        else 
            errorHandler = new DataAdminErrorHandler().
      
        errorHandler:Error(e).      
    end catch.
    finally:
        delete object service no-error.     
    end finally.
    
end.
