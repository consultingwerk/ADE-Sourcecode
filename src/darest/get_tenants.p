/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : get_tenants.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : Sat Jun 19 15:53:21 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.*.
using OpenEdge.DataAdmin.Rest.*.
using OpenEdge.DataAdmin.Util.*.
using OpenEdge.DataAdmin.Error.*.

 /* old behavior - to be deprecated */
{darest/restbase.i get tenants}  

procedure Execute:
    define input  parameter restRequest as IRestRequest  no-undo.   
    /* ***************************  Definitions  ************************** */
    define variable tenant       as ITenant no-undo.
    define variable tenants      as ITenantSet no-undo.
    define variable domains      as IDomainSet no-undo.
    define variable domain       as IDomain    no-undo.
    define variable pageRequest  as IPageRequest no-undo.
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable tntreq       as IRequestInfo no-undo.
    define variable valuereq     as IRequestInfo no-undo.
    
    /* ***************************  Main Block  *************************** */
     
    service = new DataAdminService(restRequest:ConnectionName). 
    service:URL = restRequest:ConnectionUrl.
      
    if restRequest:KeyValue[1] > "" then
    do:
        
        tntreq = new RequestInfo("Name",restRequest:KeyValue[1]).
        if restRequest:NumLevels = 2 and restRequest:CollectionName[2] > "" then
        do:
            pageRequest = restRequest:GetPageRequest().
            if valid-object(pageRequest) then
               tntreq:Add(pageRequest).
            else if restRequest:Query > "" then
            do:
                valuereq = new RequestInfo(restRequest:CollectionName[2]).
                valueReq:QueryString = restRequest:Query.
                tntreq:Add(valueReq).
            end.
        end.     
        
        tenant = service:GetTenant(tntreq).
        if tenant = ? then
             undo, throw new NotFoundError("Tenant "  + restRequest:KeyValue[1]  + " not found").
        if restRequest:NumLevels > 1 then
        do:
            if restRequest:CollectionName[2] > "" then
            do:
                if restRequest:KeyValue[2] > "" then
                do:
                    if restRequest:CollectionName[2] = "domains" then
                    do:
                        domain = tenant:Domains:Find(restRequest:KeyValue[2]).
                        if domain = ? then
                             undo, throw new NotFoundError("Domain "  +  quoter(restRequest:KeyValue[2])  + " not found in Tenant " + quoter(restRequest:KeyValue[1]) + ".").
                        
                        domain:Export(restRequest:OutFileName).
                    end.
                    else
                       undo, throw new UnsupportedOperationError ("Get of single row for collection " + quoter(restRequest:CollectionName[2])).
                end.
                else do:
                    case restRequest:CollectionName[2]:
                        when "partitions" then
                            tenant:Partitions:Export(restRequest:OutFileName).
                        when "tenantGroupMembers" then
                        do:
                            tenant:TenantGroupMembers:Export(restRequest:OutFileName).
                        end.
                        when "users" then
                            tenant:Users:Export(restRequest:OutFileName).
                        when "domains" then
                            tenant:Domains:Export(restRequest:OutFileName).
                        when "sequenceValues" then
                            tenant:SequenceValues:Export(restRequest:OutFileName).
                        otherwise
                            undo, throw new NotFoundError ("Invalid collection reference" + quoter(restRequest:CollectionName[2]) + " in URL " + quoter(restRequest:ConnectionURL)).
                    end case.
                end.
            end.
            else
               undo, throw new NotFoundError ("Unknown URL: " + restRequest:ConnectionURL).
        end.
        else
             tenant:Export(restRequest:OutFileName).
    end.
    else do:
        pageRequest = restRequest:GetPageRequest().
        if valid-object(pageRequest) then 
            tenants = service:GetTenants(pageRequest).
        else if restRequest:Query > "" then
            tenants = service:GetTenants(restRequest:Query).
        else
            tenants = service:GetTenants().
        
        tenants:ExportList(restRequest:OutFileName).
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
   
