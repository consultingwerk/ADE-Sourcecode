/*************************************************************/
/* Copyright (c) 2010,2011 by progress Software Corporation  */
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


define variable mMode       as char init "post" no-undo.
define variable mCollection as char init "scripts" no-undo.

if session:batch-mode and not this-procedure:persistent then 
do:
   output to value(mMode + "_" + mCollection + ".log"). 
   run executeRequest(session:parameter).  
end.
finally:
    if session:batch-mode then output close.            
end finally.  
 
procedure executeRequest:
    define input  parameter pcParam as character no-undo.   

     
    /* ***************************  Definitions  ************************** */
    define variable tenant       as ITenant no-undo.
    define variable tenantSet    as ITenantSet no-undo.
    define variable groupinst    as ITenantGroup no-undo.
    define variable groupset     as ITenantGroupSet no-undo.
    define variable restRequest  as RestRequest no-undo.
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable cFile        as character no-undo.
    define variable cKey         as character no-undo.
    /* ***************************  Main Block  *************************** */
    
    restRequest = new RestRequest(mMode,mCollection,pcParam).  
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
               tenant:ExportTree(restRequest:FileName2,"domains,tenantgroups,partitions").  
            end.
            /* else import the json and export it */
            else do:
                /* use collection to import non existing  Tenant (don't know the name) */
                tenantSet = service:NewTenants().
                tenantSet:ImportTree(cFile).
                tenantSet:ExportTree(restRequest:FileName2,"domains,tenantgroups,partitions,").    
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
               groupinst:ExportTree(restRequest:FileName2,"partitions").  
            end.
            /* else import the json and export it */
            else do:
                /* use collection to import non existing TenantGroup (don't know the name)*/
                groupSet = service:newTenantGroups().
                groupSet:ImportTree(cFile).
                groupSet:ExportTree(restRequest:FileName2,"partitions").    
            end. 
        end. /* when group */
        otherwise 
             undo, throw new IllegalArgumentError("Invalid script reference " + quoter(restRequest:KeyValue[1])).  
    
    end case. 
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