/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : get_tenantcounts.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : rkumar
    Created     : 2011
    Notes       :
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.

using Progress.Lang.Error.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Rest.RestRequest.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler.
using OpenEdge.DataAdmin.ITenant.
using OpenEdge.DataAdmin.ITenantSet.
using OpenEdge.DataAdmin.Error.NotFoundError.

define variable mMode       as char init "get" no-undo.
define variable mCollection as char init "tenantcounts" no-undo.

define temp-table ttTenantCounts serialize-name "tenantCounts" 
    field Name                as character  serialize-name "name"
    field NumDomains          as int  serialize-name "numDomains"
    field NumUsers            as int  serialize-name "numUsers"
 .
    
if session:batch-mode and not this-procedure:persistent then 
do:
   output to value("get_tenantcounts.log"). 
   run executeRequest(session:parameter).  
end.
finally:
    if session:batch-mode then output close.            
end finally.  

procedure executeRequest:
    define input  parameter pcURL as character no-undo.
     
    /* ***************************  Definitions  ************************** */
    
    define variable tenant       as ITenant no-undo.
    define variable restRequest  as RestRequest no-undo.
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    
    
     
    /* ***************************  Main Block  *************************** */
    
    restRequest = new RestRequest(mMode,mCollection,pcUrl).  
    
    service = new DataAdminService(restRequest:ConnectionName). 
    restRequest:Validate().   
    service:URL = restRequest:ConnectionUrl.
  
    if restRequest:KeyValue[1] > "" then
    do:
        tenant = service:GetTenant(restRequest:KeyValue[1]).
        if tenant = ? then
             undo, throw new NotFoundError("Tenant "  + restRequest:KeyValue[1]  + " not found").
    end.
    else if restRequest:KeyValue[1] EQ "" OR restRequest:KeyValue[1] EQ ? then
         undo, throw new NotFoundError("Tenant name not provided in URL. ").
         
     create ttTenantCounts.
     assign 
       ttTenantCounts.Name = restRequest:KeyValue[1]
       ttTenantCounts.NumUsers   =  tenant:Users:Count
       ttTenantCounts.NumDomains =  tenant:Domains:Count
.       
 
    run writeTenantCounts(restRequest:OutFileName).  
     
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


procedure WriteTenantCounts.
    define input  parameter pcfile as character no-undo.
    temp-table ttTenantCounts:write-json("File",pcfile,yes).
end.

