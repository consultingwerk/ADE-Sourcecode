/*************************************************************/
/* Copyright (c) 2013 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : put_partitionpolicies.p
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

define stream acceptstream.
 
/* to be deprecated */
{darest/restbase.i put partitionpolicies} 
  
procedure Execute :
    define input parameter restRequest as IRestRequest  no-undo.   
    /* ***************************  Definitions  ************************** */
    define variable policy            as IPartitionPolicy no-undo.
    define variable policies          as IPartitionPolicySet no-undo.
    define variable dealloctable      as ITable no-undo.
    define variable partition         as IPartition no-undo.
    define variable details           as IPartitionPolicyDetailSet no-undo.
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
    
    service = new DataAdminService(restRequest:ConnectionName).
    restRequest:Validate().
    
    service:URL = restRequest:ConnectionUrl.
    assign
       cFile = restRequest:FileName
       cFileOut = restRequest:OutFileName.
    
    if restRequest:KeyValue[1] > "" then 
    do:
        policy = service:GetPartitionPolicy(restRequest:KeyValue[1]).
        if policy = ? then
            undo, throw new NotFoundError("Partition Policy "  + restRequest:KeyValue[1]  + " not found").
    end.
    else do:
        policies = service:GetPartitionPolicies().
    end.    
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
    if restRequest:KeyValue[1] > "" then 
    do: 
        if restRequest:NumLevels > 1 and restRequest:CollectionName[2] > "" then
        do:
            /**
            if restRequest:ChildCollectionName = "partitions" then 
            do:
                service:Tenants:Get(int(restRequest:KeyValue)):Partitions:Export(cFile).
            end. 
            else 
        **/
            if restRequest:CollectionName[2] = "partitionPolicyDetails" then
            do:
                details = policy:Details.
                details:ImportTree(cFile).
                service:UpdatePartitionPolicy(policy).
                details:ExportLastSavedTree(cFileOut).
            end.
            else if restRequest:CollectionName[2] = "partitions"
            and restRequest:NumLevels = 3 
            and restRequest:CollectionName[3] = "deallocate" then
            do:
                undo, throw new UnsupportedOperationError("Deallocate of paretition policy details").   
                                 
    /*                deallocTable = service:GetTable(restRequest:KeyValue[2]).                                 */
    /*                if not valid-object(deallocTable) then                                                    */
    /*                    undo, throw new NotFoundError("Table " + restRequest:KeyValue[2] + " was not found.").*/
    /*                deallocateUtility = new DeallocateUtility(policy,deallocTable).                           */
    /*                service:ExecuteUtility(deallocateUtility).                                                */
    
            end.
            else         
                undo, throw new NotFoundError("URL not found: " + restRequest:RequestUrl).   
        end.
            
        else do: 
            policy:ImportTree(cFile).
            service:UpdatePartitionPolicy(policy).
            policy:ExportTree(cFileOut).
        end.
    end. /* if restRequest:KeyValue[1] > "" then */
    else do:
        policies:ImportTree(cFile).
        service:UpdatePartitionPolicies(policies).
              
        policies:ExportLastSavedTree(cFileOut).
                 
        copy-lob file cFileOut to clong.     
        substring(cLong,2,0) = '"success" : true,'.
        copy-lob clong to file cFileOut.
        
    end.
        
     /* write Request complete once put_policys completes. */
    if cTaskName > "" then do:
        if valid-object(fileLogger) then
        do:
              fileLogger:Log("Request complete").
        end.    
        output stream  acceptstream to value(cFileOut).
        put stream  acceptstream unformatted "HTTP/1.1 200 OK" skip(1) .
        output stream  acceptstream  close.
    end.                  
    
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