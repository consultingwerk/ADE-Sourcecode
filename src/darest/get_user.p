/*************************************************************/
/* Copyright (c) 2024 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : get_user.p
    Purpose     : 
    Syntax      :
    Description : Fetch the user & granted roles
    Author(s)   : tmasood
    Created     : Tue Aug 13 15:29:10 IST 2024
    Notes       :
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.

using Progress.Lang.Error.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Rest.IRestRequest.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler.
using OpenEdge.DataAdmin.IUser.
using OpenEdge.DataAdmin.IUserSet.
using OpenEdge.DataAdmin.Error.NotFoundError.
using OpenEdge.DataAdmin.Rest.IPageRequest.
using OpenEdge.DataAdmin.IGrantedRoleSet.
using OpenEdge.DataAdmin.IGrantedRole.
using OpenEdge.DataAdmin.IRoleSet.
using OpenEdge.DataAdmin.Lang.Collections.IIterator.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonArray.

/* old behavior - to be deprecated */
{darest/restbase.i get user}

procedure Execute:
    define input parameter restRequest as IRestRequest  no-undo.

    /* ***************************  Definitions  ************************** */
    define variable oUser        as IUser                 no-undo.
    define variable userset      as IUserSet              no-undo.
    define variable pageRequest  as IPageRequest          no-undo.
    define variable service      as DataAdminService      no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable oGrants      as IGrantedRoleSet       no-undo.
    define variable oGrant       as IGrantedRole          no-undo.
    define variable iter         as IIterator             no-undo.
    define variable cUserID      as character             no-undo.
    define variable oUserJson    as JsonObject            no-undo.
    define variable oRoleArr     as JsonArray             no-undo.

    /* ***************************  Main Block  *************************** */

    restRequest:Validate().
    service = new DataAdminService(restRequest:ConnectionName).
    service:URL = restRequest:ConnectionUrl.
    cUserID = restRequest:KeyValue[1].

    if (cUserID gt "") eq true then
    do:
        // Obtain the single user record for the ID given.
        oUser = service:GetUser(cUserID).
        if not valid-object(oUser) then
            undo, throw new NotFoundError("User '"  + cUserID + "' not found").
        oUserJson = oUser:ExportToJson().

        // Add a new "roles" property as array to the single user object returned. 
        oUserJson:GetJsonArray("users"):GetJsonObject(1):Add("roles", new JsonArray()).

        // Iterate through the roles granted to this user@domain as the grantee.
        oGrants = service:GetGrantedRoles(substitute("where Grantee eq '&1@&2'", oUser:Name, oUser:Domain:Name)).
        
        iter = oGrants:Iterator().
        do while iter:HasNext():
           assign oGrant = cast(iter:Next(), IGrantedRole).
           // Add the individual array element found in each of the Grant objects within the set.
           oUserJson:GetJsonArray("users"):GetJsonObject(1):GetJsonArray("roles"):Add(oGrant:Role:ExportToJson():GetJsonArray("roles"):GetJsonObject(1)).
        end.
    end.
    else
        oUserJson = new JsonObject().

    oUserJson:WriteFile(restRequest:OutFileName, true).

    catch e as Progress.Lang.Error:
        if session:batch-mode then
            errorHandler = new DataAdminErrorHandler(restRequest:ErrorFileName).
        else do:
            errorHandler = new DataAdminErrorHandler().
        end.
        errorHandler:Error(e).
    end catch.
    finally:
        delete object service no-error.
    end finally.
end.