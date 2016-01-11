/*************************************************************/
/* Copyright (c) 2010-2013 by progress Software Corporation  */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : post_scripts.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : 2010
    Notes       :     
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.*.
using OpenEdge.DataAdmin.Rest.*.
using OpenEdge.DataAdmin.Error.*.

/* to be deprecated */
{darest/restbase.i post scripts} 
  
procedure Execute :
    define input parameter restRequest as IRestRequest  no-undo.  

     
    /* ***************************  Definitions  ************************** */
    define variable tenant       as ITenant no-undo.
    define variable tenantSet    as ITenantSet no-undo.
    define variable groupinst    as ITenantGroup no-undo.
    define variable groupset     as ITenantGroupSet no-undo.
    define variable policy       as IPartitionPolicy no-undo.
    define variable policySet    as IPartitionPolicySet no-undo.
   
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable cFile        as character no-undo.
    define variable cKey         as character no-undo.
    define variable adminError   as DataAdminError no-undo.
    /* ***************************  Main Block  *************************** */
    
    service = new DataAdminService(restRequest:ConnectionName).
        
    restRequest:Validate().
    service:URL = restRequest:ConnectionUrl.
    cFile = restRequest:FileName.
   
    if restRequest:KeyValue[1] = ? then 
        undo, throw new UnsupportedOperationError("POST scripts with no key in URL:" + restRequest:RequestUrl).  
    case restRequest:KeyValue[1]:    
        
        when "CreateTenantScript" then
        do:
            cKey = restRequest:GetQueryValue("Name").
            
            /* if url has name  then find the existing tenant */
            if cKey > "" then
            do:
               tenant = service:GetTenant(cKey).
               if not valid-object(tenant) then
                  undo, throw new NotFoundError("Tenant "  + quoter(cKey)  + " not found").
               tenant:ExportAsProcedure(restRequest:DownloadFileName,"domains,tenantgroups,partitions").  
            end.
            /* else import the json and export it */
            else do:
                /* use collection to import non existing  Tenant (don't know the name) */
                tenantSet = service:NewTenants().
                tenantSet:ImportTree(cFile).
                tenantSet:ExportAsProcedure(restRequest:DownloadFileName,"domains,tenantgroups,partitions").    
            end. 
        end. /* when tenant */
        when "CreateGroupScript" then
        do:
            cKey = restRequest:GetQueryValue("Name").
            
            /* if url has name  then find the existing tenant */
            if cKey > "" then
            do:
               groupinst = service:GetTenantGroup(cKey).
               if not valid-object(groupinst) then
                  undo, throw new NotFoundError("Tenant Group "  + quoter(cKey)  + " not found").
               groupinst:ExportAsProcedure(restRequest:DownloadFileName,"partitions").  
            end.
            /* else import the json and export it */
            else do:
                /* use collection to import non existing TenantGroup (don't know the name)*/
                groupSet = service:newTenantGroups().
                groupSet:ImportTree(cFile).
                groupSet:ExportAsProcedure(restRequest:DownloadFileName,"partitions").    
            end. 
        end. /* when group */
        when "CreatePolicyScript" then
        do:
            cKey = restRequest:GetQueryValue("Name").
            
            /* if url has name  then find the existing tenant */
            if cKey > "" then
            do:
               policy = service:GetPartitionPolicy(cKey).
               if not valid-object(policy) then
                  undo, throw new NotFoundError("policy "  + quoter(cKey)  + " not found").
               policy:ExportAsProcedure(restRequest:DownloadFileName).  
            end.
            /* else import the json and export it */
            else do:
                /* use collection to import non existing  policy (don't know the name) */
                policySet = service:NewPartitionPolicies().
                policySet:ImportTree(cFile).
                policySet:ExportAsProcedure(restRequest:DownloadFileName).    
            end. 
        end. /* when tenant */
        otherwise 
             undo, throw new IllegalArgumentError("Invalid script reference " + quoter(restRequest:KeyValue[1])).  
    
    end case. 
    catch e as Progress.Lang.Error :
        if session:batch-mode then
        do:
            /* script download logic does not check for error if 200  */
            if type-of(e,DataAdminError) then
            do: 
                adminError = cast(e,DataAdminError).
                if adminError:HTTPErrorNum = 200 then 
                   adminError:HTTPErrorNum = 500.
            end.    
            errorHandler =  new DataAdminErrorHandler(restRequest:ErrorFileName).
        end.
        else
            errorHandler = new DataAdminErrorHandler().
        
        errorHandler:Error(e).      
    end catch.
    finally:
        delete object service no-error.     
    end finally.
    
 
end.