/*************************************************************/
/* Copyright (c) 2010,2011 by progress Software Corporation  */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : put_tenants.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : July 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.*.
using OpenEdge.DataAdmin.Core.*.
using OpenEdge.DataAdmin.Rest.*.
using OpenEdge.DataAdmin.Util.*.
using OpenEdge.DataAdmin.Error.*.

define variable mMode       as char init "put" no-undo.
define variable mCollection as char init "tenants" no-undo.
define stream acceptstream.

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
    define variable tenant            as ITenant no-undo.
    define variable dealloctable      as ITable no-undo.
    define variable tenantuser        as IUser no-undo.
    define variable tenantusers       as IUserSet no-undo.
    define variable tenantdomain      as IDomain no-undo.
    define variable partition         as IPartition no-undo.
    define variable seqValues         as ISequenceValueMap no-undo.
    define variable restRequest       as RestRequest no-undo.
    define variable fileLogger        as FileLogger no-undo.
    define variable service           as DataAdminService no-undo.
    define variable errorHandler      as DataAdminErrorHandler no-undo.
    define variable deallocateUtility as DeallocateUtility no-undo.
    define variable cFile             as character no-undo.
    define variable cFileOut          as character no-undo.
    define variable cTaskname         as character no-undo.
    define variable clong             as longchar no-undo.
    define variable lok               as logical no-undo.
    /* ***************************  Main Block  *************************** */
    
    restRequest = new RestRequest(mMode,mCollection,pcParam).  
    service = new DataAdminService(restRequest:ConnectionName).
    restRequest:Validate().
    
    service:URL = restRequest:ConnectionUrl.
    assign
       cFile = restRequest:FileName
       cFileOut = restRequest:OutFileName.
    
    if restRequest:KeyValue[1] > "" then 
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
            /**
            if restRequest:ChildCollectionName = "partitions" then 
            do:
                service:Tenants:Get(int(restRequest:KeyValue)):Partitions:Export(cFile).
            end. 
            else 
        **/
            if restRequest:CollectionName[2] = "sequenceValues" then
            do:
                seqValues = tenant:SequenceValues.
                seqValues:Import(cFile).
                service:UpdateTenant(tenant).
              
                seqValues:ExportLastSaved(cFileOut).
                 
                copy-lob file cFileOut to clong.     
                substring(cLong,2,0) = '"success" : true,'.
                copy-lob clong to file cFileOut.
                
            end.
            else if restRequest:CollectionName[2] = "users" then
            do:
                if restRequest:KeyValue[2] <> ? then
                do:
                    tenantuser = tenant:Users:Find(restRequest:KeyValue[2]).
                    if tenantuser = ? then
                         undo, throw new NotFoundError("User "  + restRequest:KeyValue[2]  + " not found").
         
                    tenantuser:Import(cFile).
                    service:UpdateUser(tenantuser).
                    tenantuser:Export(cFileOut).
                end.
                else do:
                     tenantusers = tenant:Users.
                     tenantusers:Import(cFile).
                     service:UpdateUsers(tenantusers).
                     tenantusers:ExportLastSaved(cFileOut).                  
                end.    
                copy-lob file cFileOut to clong.     
                substring(cLong,2,0) = '"success" : true,'.
                copy-lob clong to file cFileOut.
                
            end.
            else if restRequest:CollectionName[2] = "domains" then
            do:
                tenantdomain = service:GetDomain(restRequest:KeyValue[2]).
                tenantdomain:Import(cFile).
                service:UpdateDomain(tenantdomain).
                tenantdomain:Export(cFileOut).
       
                copy-lob file cFileOut to clong.     
                substring(cLong,2,0) = '"success" : true,'.
                copy-lob clong to file cFileOut.
                
            end.
            else if restRequest:CollectionName[2] = "partitions"
            and restRequest:NumLevels = 3 
            and restRequest:CollectionName[3] = "deallocate" then
            do:
                                                
                deallocTable = service:GetTable(restRequest:KeyValue[2]).
                if not valid-object(deallocTable) then
                    undo, throw new NotFoundError("Table " + restRequest:KeyValue[2] + " was not found.").                
                deallocateUtility = new DeallocateUtility(tenant,deallocTable).
                service:ExecuteUtility(deallocateUtility).

/*                partition = tenant:Partitions:FindTable(restRequest:KeyValue[2]).*/
/*                if not valid-object(partition) then                                                                                               */
/*                    undo, throw new NotFoundError("Partition for tenant" + tenant:name + " Table " + restRequest:KeyValue[2] + " was not found.").*/
/*                lok = partition:Deallocate().*/
/*                if not lok then                                                                           */
/*                    undo, throw new AppError("Table " + restRequest:KeyValue[2] + " is not allocated.",?).*/
/*                service:UpdateTenant(tenant).*/
                

                /*
                else do:
                    partition:Export(cFileOut).
                
                    copy-lob file cFileOut to clong.     
                    substring(cLong,2,0) = '"success" : true,'.
                    copy-lob clong to file cFileOut.
                end.
                */
            end.
            else         
                undo, throw new NotFoundError("URL not found: " + restRequest:RequestUrl).   
        end.
            
        else do: 
            tenant:ImportTree(cFile).
            service:UpdateTenant(tenant).
            tenant:ExportTree(cFileOut,"partitions,tenantGroupMembers").
            copy-lob file cFileOut to clong.
            substring(cLong,2,0) = '"success" : true,'.
            copy-lob clong to file cFileOut.
        end.
    
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
    else 
        undo, throw new UnsupportedOperationError("PUT with no key in URL:" + restRequest:RequestUrl).       
 
    catch e as Progress.Lang.Error :
        if valid-object(FileLogger) then 
            fileLogger:Log("Request failed").    
                   
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