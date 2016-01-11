/*************************************************************/
/* Copyright (c) 2010-2012 by progress Software Corporation  */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : post_tenants.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : July 2010
    Notes       : Post handles create only simply by ensuring that no
                  data is read before the import. This way all records 
                  will be set as new and cause errors if they already exists   
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.*.
using OpenEdge.DataAdmin.Core.*.
using OpenEdge.DataAdmin.Rest.*.
using OpenEdge.DataAdmin.Error.*.
using OpenEdge.DataAdmin.Util.*.

define stream acceptstream.
 
/* to be deprecated */
{darest/restbase.i post tenants} 
  
procedure Execute :
    define input parameter restRequest as IRestRequest  no-undo.
 
    /* ***************************  Definitions  ************************** */
    define variable tenant       as ITenant no-undo.
    define variable tenants      as ITenantSet no-undo.
    define variable newusers     as IUserSet no-undo.
    define variable newdomains   as IDomainSet no-undo.
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable cFile        as character no-undo.
    define variable cFileOut     as character no-undo.
    define variable cTaskname    as character no-undo.
    define variable fileLogger   as FileLogger no-undo.
    define variable cLong        as longchar no-undo.
     
    /* ***************************  Main Block  *************************** */
    service = new DataAdminService(restRequest:ConnectionName).
   
    restRequest:Validate().
    
    service:URL = restRequest:ConnectionUrl.
    
    assign
        cFile = restRequest:FileName
        cFileOut = restRequest:OutFileName.
           
    If restRequest:KeyValue[1] > "" then
    do: 
        tenant = service:GetTenant(restRequest:KeyValue[1]).
        if tenant = ? then
            undo, throw new NotFoundError("Tenant "  + restRequest:KeyValue[1]  + " not found").
        

        /* get taskname and write Request Start to the logfile */ 
        cTaskName = restRequest:GetQueryValue("TaskName").
        if cTaskName > "" then
        do:
                fileLogger = new FileLogger(restRequest:LogFileName). 
                fileLogger:TaskName = cTaskName.
                fileLogger:Log("Request start").    
                service:TransactionLogger = fileLogger.
                output stream acceptstream to value(cFileOut).                                 
                put stream  acceptstream unformatted "HTTP/1.1 202 ACCEPTED" skip(1) .
                output stream  acceptstream  close.        
        end.
        
        if restRequest:NumLevels > 1 and restRequest:CollectionName[2] > "" then
        do:
 
            if restRequest:CollectionName[2] = "users" then
            do:
                newusers = service:NewUsers().            
                newusers:Import(cfile).
                tenant:Users:AddAll(newusers). 
                service:UpdateTenant(tenant).
                tenant:Users:ExportLastSaved(cFileOut).
                copy-lob file cFileOut to clong.     
                substring(cLong,2,0) = '"success" : true, '.
                copy-lob clong to file cFileOut.
                
            end.
            else if restRequest:CollectionName[2] = "domains" then
            do:
                newdomains = service:NewDomains(). 
                newdomains:Import(cFile).
                tenant:Domains:AddAll(newdomains).
                service:UpdateTenant(tenant).
                tenant:Domains:ExportLastSaved(cFileOut).
                copy-lob file cFileOut to clong.     
                substring(cLong,2,0) = '"success" : true, '.
                copy-lob clong to file cFileOut.
                
            end.
            else         
                undo, throw new NotFoundError("URL: " + restRequest:ConnectionUrl).  
        end.    
        else 
           undo, throw new NotFoundError("URL: " + restRequest:ConnectionUrl).
           
        /* write Request complete once put_tenants completes. */
        if cTaskName > "" then do:
            if valid-object(fileLogger) then
            do:
                  fileLogger:Log("Request complete").
            end.  
  
            output stream  acceptstream to value(cFileOut).
            put stream  acceptstream unformatted "HTTP/1.1 200 OK" skip(1) .
            output stream  acceptstream  close.
        end.                   
    end.
    else do:
        
        /* get taskname and write Request Start to the logfile */ 
        cTaskName = restRequest:GetQueryValue("TaskName").
        if cTaskName > "" then
        do:
                fileLogger = new FileLogger(restRequest:LogFileName). 
                fileLogger:TaskName = cTaskName.
                fileLogger:Log("Request start").    
                service:TransactionLogger = fileLogger.
                output stream acceptstream to value(cFileOut).                                 
                put stream  acceptstream unformatted "HTTP/1.1 202 ACCEPTED" skip(1) .
                output stream  acceptstream  close.        
        end.
        
        tenants = service:NewTenants().
        tenants:ImportTree(cFile).   
        service:CreateTenants(tenants).
        tenants:ExportTree(cFileOut,"partitions,tenantgroupmembers").
        copy-lob file cFileOut to clong.   
        substring(cLong,2,0) = '"success" : true, '.
        copy-lob clong to file cFileOut.
        
        /* write Request complete once put_tenants completes. */
        if cTaskName > "" then do:
            if valid-object(fileLogger) then
            do:
                  fileLogger:Log("Request complete").
            end.    
            output stream  acceptstream to value(cFileOut).
            put stream  acceptstream unformatted "HTTP/1.1 200 OK" skip(1) .
            output stream  acceptstream  close.
        end.                           
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