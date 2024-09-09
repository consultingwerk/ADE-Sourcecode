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
    Created     : Tue Aug 13 15:08:39 IST 2024
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

routine-level on error undo, throw.

using Progress.Lang.Error.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.DataSource.DatabaseInfo.
using OpenEdge.DataAdmin.Rest.IRestRequest.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler.
using OpenEdge.DataAdmin.IRole.
using OpenEdge.DataAdmin.IRoleSet.
USING OpenEdge.DataAdmin.IAuthTag.
USING OpenEdge.DataAdmin.IAuthTagSet.
using OpenEdge.DataAdmin.Error.NotFoundError.
using OpenEdge.DataAdmin.Rest.IPageRequest.
USING Progress.Json.ObjectModel.JsonObject.
USING Progress.Json.ObjectModel.JsonArray.
USING OpenEdge.DataAdmin.Lang.Collections.IIterator.
USING Progress.Database.DBConfig.

 
 /* old behavior - to be deprecated */
{darest/restbase.i get roles}  

procedure Execute:
    define input  parameter restRequest as IRestRequest  no-undo.      
    /* ***************************  Definitions  ************************** */
    define variable oRole        as IRole                 no-undo.
    define variable roleset      as IRoleSet              no-undo.
    define variable oAuthTags    as IAuthTagSet           no-undo.
    define variable oTags        as IAuthTag              no-undo.
    define variable pageRequest  as IPageRequest          no-undo.
    define variable service      as DataAdminService      no-undo.
    define variable oDBInfo      as DatabaseInfo          no-undo.
    define variable oDBConfig    as DBConfig              no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable oRoleJson    as JsonObject            no-undo.
    define variable oRoleArr     as JsonArray             no-undo.
    define variable iter         as IIterator             no-undo.
    define variable cRole        as character             no-undo.
    /* ***************************  Main Block  *************************** */
    restRequest:Validate().
    service = new DataAdminService(restRequest:ConnectionName).
    oDBInfo = NEW DatabaseInfo().
    cRole = if restRequest:KeyValue[1] <> "" then restRequest:KeyValue[1] else "".
   
    service:URL = restRequest:ConnectionUrl.
    
    if cRole > "" then 
    do:
        oRole = service:GetRole(cRole).
        if not valid-object(oRole) then
            undo, throw new NotFoundError("Role '"  + cRole  + "' not found").
         
        oRoleJson = oRole:ExportToJson().
        if oDBInfo:IsDDMEnabled then do: // add auth-tags if DDM is enabled
          // A DDMAdmin only dump the Auth-tags
          oDBConfig = NEW DBConfig(LDBNAME("DICTDB")).
          if not oDBConfig:IsDDMAdmin then
            undo, throw new NotFoundError("You must be a DDM Administrator to access this option!").
          // Add a new "authtags" property as array to the single role object returned. 
          oRoleJson:GetJsonArray("roles"):GetJsonObject(1):Add("authtags", new JsonArray()).
        
          // Iterate through the roles.
          oAuthTags = service:GetAuthTags(substitute("where RoleName eq '&1'", oRole:Name)).
          iter = oAuthTags:Iterator().
          do while iter:HasNext():
             assign oTags = cast(iter:Next(), IAuthTag).
             // Add the individual array element found in each of the AuthTag objects within the set.
             oRoleJson:GetJsonArray("roles"):GetJsonObject(1):GetJsonArray("authtags"):Add(oTags:Name).
          end.
        end.
    end.    
    else
       roleset = service:GetRoles().
    
    if cRole > "" THEN   
      oRoleJson:WriteFile(restRequest:OutFileName, true).
    else
       roleset:export(restRequest:OutFileName).
 
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
        delete object oDBConfig no-error.		
    end finally.
    
end.
