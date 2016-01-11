/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : get_tenantgroups.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : Sat Jun 19 15:53:21 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.*  from propath.
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.ITenantGroup from propath.
using OpenEdge.DataAdmin.ITenantGroupSet from propath.
using OpenEdge.DataAdmin.DataAdminService from propath.

using OpenEdge.DataAdmin.Rest.IRestRequest from propath.
using OpenEdge.DataAdmin.Rest.IPageRequest from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
using OpenEdge.DataAdmin.Error.NotFoundError from propath.
 
 
 /* old behavior - to be deprecated */
{darest/restbase.i get tenantgroups}  

procedure Execute:
    define input  parameter restRequest as IRestRequest  no-undo.   
    /* ***************************  Definitions  ************************** */
    define variable tenantGroup  as ITenantGroup no-undo.
    define variable tenantGroups as ITenantGroupSet no-undo.
    define variable pageRequest  as IPageRequest no-undo.
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    
    /* ***************************  Main Block  *************************** */
     
    service = new DataAdminService(restRequest:ConnectionName). 
    service:URL = restRequest:ConnectionUrl.
      
    if restRequest:KeyValue[1] > "" then
    do:
        tenantGroup = service:GetTenantGroup(restRequest:KeyValue[1]).
        if tenantGroup = ? then
             undo, throw new NotFoundError("Tenant Group "  + quoter(restRequest:KeyValue[1])  + " not found").
        if restRequest:NumLevels > 1 then
        do:
            undo, throw new NotFoundError ("Unknown URL: " + restRequest:ConnectionURL).
        end.
        else
            tenantGroup:ExportTree(restRequest:OutFileName).
    end.
    else do:
        pageRequest = restRequest:GetPageRequest().
        if valid-object(pageRequest) then 
            tenantGroups = service:GetTenantGroups(pageRequest).
        else
        if restRequest:Query > "" then
            tenantGroups = service:GetTenantGroups(restRequest:Query).
        else
            tenantGroups = service:GetTenantGroups().
        
        tenantGroups:ExportList(restRequest:OutFileName).
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
    
 end procedure.
   
