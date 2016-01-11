/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : delete_tenants.p
    Purpose     : Delete of Tenant, or delete of entity from 
                  Tenant:TenantGroupMembers, :Users or :Domains

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : 2011
    Notes       :     
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.ITenant from propath.
using OpenEdge.DataAdmin.ITenantGroupMember from propath.
using OpenEdge.DataAdmin.IDomain from propath.
using OpenEdge.DataAdmin.IUser from propath.
using OpenEdge.DataAdmin.Error.NotFoundError from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
using OpenEdge.DataAdmin.Rest.RestRequest  from propath.
using OpenEdge.DataAdmin.Core.FileLogger  from propath.

define variable mMode       as char init "delete" no-undo.
define variable mCollection as char init "tenants" no-undo.
define stream acceptstream. 
if session:batch-mode and not this-procedure:persistent then 
do:
    output to value("delete_tenants.log"). 
    run executeRequest(session:parameter).  
end.
finally:
    if session:batch-mode then output close.            
end finally.  

function CapitalizeFirst returns char(cword as char):
    return caps(substr(cWord,1,1)) + substr(cWord,2).
end function. 
    
 
procedure executeRequest:
    define input  parameter pcParam as character no-undo.   
 
    /* ***************************  Definitions  ************************** */
/*    define variable groupinst    as ITenant no-undo.*/
    define variable restRequest          as RestRequest no-undo.
    define variable service              as DataAdminService no-undo.
    define variable errorHandler         as DataAdminErrorHandler no-undo.
    define variable tenant               as ITenant no-undo.
    define variable tenantGroupMember    as ITenantGroupMember no-undo.
    define variable deluser              as IUser no-undo.
    define variable domain               as IDomain no-undo.
    define variable cFile                as character no-undo.
    define variable cFileOut             as character no-undo.
    define variable fileLogger           as FileLogger no-undo.
    define variable lSuccess             as logical no-undo.
    define variable cLong as longchar no-undo.
     
    /* ***************************  Main Block  *************************** */
    restRequest = new RestRequest(mMode,mCollection,pcParam).  
    
    service = new DataAdminService(restRequest:ConnectionName).
   
    restRequest:Validate().
    assign
        cFile = restRequest:FileName
        cFileOut = restRequest:OutFileName.
    
    service:URL = restRequest:ConnectionUrl.
    if restRequest:GetQueryValue("TaskName") > "" then
    do:
        /* start logger */   
        fileLogger = new FileLogger(restRequest:LogFileName). 
        fileLogger:TaskName = restRequest:GetQueryValue("TaskName").
        service:TransactionLogger = fileLogger.
    end.
        
    if valid-object(fileLogger) then 
    do:
        output stream acceptstream to value(cFileOut).                                
        put stream  acceptstream unformatted "HTTP/1.1 202 ACCEPTED" skip(1) .
        output stream  acceptstream  close.                                                                                                                     
        fileLogger:Log("Request start"). 
    end. 
    If restRequest:KeyValue[1] > "" then
    do: 
        if restRequest:NumLevels = 1 then
            service:DeleteTenant(restRequest:KeyValue[1]).
        else if restRequest:NumLevels = 2 then
        do:
            if lookup(restRequest:CollectionName[2],"tenantGroupMembers,users,domains") = 0 then
                undo, throw new NotFoundError("URL not found: " + restRequest:RequestUrl).              
            
            tenant =  service:GetTenant(restRequest:KeyValue[1]).
             
            if not valid-object(tenant) then
                undo, throw new NotFoundError("Tenant " + quoter(restRequest:KeyValue[1])  + " not found").
            case restRequest:CollectionName[2]:
                when "tenantGroupMembers" then
                do: 
                    tenantGroupMember = tenant:TenantGroupMembers:Find(restRequest:KeyValue[2]).
                    if not valid-object(tenantGroupMember) then
                        undo, throw new NotFoundError("TenantGroupMember for Group " + quoter(restRequest:KeyValue[2]) + " and Tenant '"  + quoter(restRequest:KeyValue[1])  + "' not found").
               
                    lSuccess = tenant:TenantGroupMembers:Remove(tenantGroupMember).    
                end.
                when "users" then
                do:
                    deluser = tenant:Users:Find(restRequest:KeyValue[2]).
                    if not valid-object(deluser) then
                        undo, throw new NotFoundError("User " + quoter(restRequest:KeyValue[2]) + " not found for Tenant '"  + quoter(restRequest:KeyValue[1]) + ".").
                  
                    lSuccess = tenant:Users:Remove(deluser).    
                end.  
                when "domains" then
                do: 
                    domain = tenant:Domains:Find(restRequest:KeyValue[2]).
                    if not valid-object(domain) then
                        undo, throw new NotFoundError("Domain " + quoter(restRequest:KeyValue[2]) + " not found for Tenant '"  + quoter(restRequest:KeyValue[1]) + ".").
               
                    lSuccess = tenant:Domains:Remove(domain).    
                end.      
            end case.
    
            if lsuccess then 
            do:
                service:UpdateTenant(tenant).
            end.
            else /* remove should not normally fail when we know the record is there and the reason is not known if it does */
            
                 undo, throw new NotFoundError("Delete of "  + quoter(restRequest:KeyValue[2]) + " from Tenant " + quoter(restRequest:KeyValue[1]) +  " " + CapitalizeFirst(restRequest:CollectionName[2]) + " failed" + ".").
               
        end.    
        if valid-object(fileLogger) then  
        do:
            fileLogger:Log("Request complete"). 
        end.
        output stream  acceptstream to value(cFileOut).
        put stream  acceptstream unformatted 
                "HTTP/1.1 200 OK" skip(1) 
                '~{"success" : true~}'.
        output stream  acceptstream  close.
    end.
    else 
        undo, throw new UnsupportedOperationError("DELETE with no key in URL:" + restRequest:RequestUrl).    
    
    
    catch e as Progress.Lang.Error :
        if valid-object(fileLogger) then
        do:
           fileLogger:Log("Request failed").   
        end. 
        
        if session:batch then
            errorHandler = new DataAdminErrorHandler(restRequest:ErrorFileName).
        else
            errorHandler = new DataAdminErrorHandler().
        
        errorHandler:Error(e).      
    end catch.
    
    finally:
       delete object service no-error.
       delete object fileLogger no-error.        
    end finally.
end.