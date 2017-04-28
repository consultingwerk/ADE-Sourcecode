/*************************************************************/
/* Copyright (c) 2016 by Progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : put_cdctablepolicies.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : mkondra
    Created     : Thu Aug 04 15:37:19 IST 2016
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
{darest/restbase.i put cdctablepolicies} 
  
procedure Execute :
    define input parameter restRequest as IRestRequest  no-undo.   
    /* ***************************  Definitions  ************************** */
    define variable tablePolicy       as ICdcTablePolicy       no-undo.
    define variable tablePolicies     as ICdcTablePolicySet    no-undo.
    define variable dealloctable      as ITable                no-undo.
    define variable partition         as IPartition            no-undo.
    define variable fieldPolicies     as ICdcFieldPolicySet    no-undo.
    define variable fileLogger        as FileLogger            no-undo.
    define variable service           as DataAdminService      no-undo.
    define variable errorHandler      as DataAdminErrorHandler no-undo.
    define variable deallocateUtility as DeallocateUtility     no-undo.
    define variable cFile             as character             no-undo.
    define variable cFileOut          as character             no-undo.
    define variable cTaskname         as character             no-undo.
    define variable clong             as longchar              no-undo.
    define variable lok               as logical               no-undo.
    /* ***************************  Main Block  *************************** */
    
    service = new DataAdminService(restRequest:ConnectionName).
    restRequest:Validate().
    
    service:URL = restRequest:ConnectionUrl.
    assign
        cFile    = restRequest:FileName
        cFileOut = restRequest:OutFileName.
    
    if restRequest:KeyValue[1] > "" then 
    do:
        tablePolicy = service:GetCdcTablePolicy(restRequest:KeyValue[1]).
        if tablePolicy = ? then
            undo, throw new NotFoundError("CDC Table Policy "  + restRequest:KeyValue[1]  + " not found").
    end.
    else 
    do:
        tablePolicies = service:GetCdcTablePolicies().
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
        put stream  acceptstream unformatted 
            "HTTP/1.1 202 ACCEPTED" skip(1) .
        output stream  acceptstream  close.        
    end.
    if restRequest:KeyValue[1] > "" then 
    do: 
        if restRequest:NumLevels > 1 and restRequest:CollectionName[2] > "" then
        do:
            if restRequest:CollectionName[2] = "cdcFieldPolicies" then
            do:
                fieldPolicies = tablePolicy:FieldPolicies.
                fieldPolicies:ImportTree(cFile).
                service:UpdateCdcTablePolicy(tablePolicy).
                fieldPolicies:ExportLastSavedTree(cFileOut).
            end.
            else         
                undo, throw new NotFoundError("URL not found: " + restRequest:RequestUrl).   
        end.            
        else 
        do: 
            tablePolicy:ImportTree(cFile).
            service:UpdateCdcTablePolicy(tablePolicy).
            tablePolicy:ExportTree(cFileOut).
        end.
    end. /* if restRequest:KeyValue[1] > "" then */
    else 
    do:
        tablePolicies:ImportTree(cFile).
        service:UpdateCdcTablePolicies(tablePolicies).
              
        tablePolicies:ExportLastSavedTree(cFileOut).
                 
        copy-lob file cFileOut to clong.     
        substring(cLong,2,0) = '"success" : true,'.
        copy-lob clong to file cFileOut.
        
    end.
        
    /* write Request complete once put_policys completes. */
    if cTaskName > "" then 
    do:
        if valid-object(fileLogger) then
        do:
            fileLogger:Log("Request complete").
        end.    
        output stream  acceptstream to value(cFileOut).
        put stream  acceptstream unformatted 
            "HTTP/1.1 200 OK" skip(1) .
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
