/*************************************************************/
/* Copyright (c) 2013 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : delete_policies.p
    Purpose     : Delete of IPartitionPolicy or IPartitionPolicyDetail
    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : 2013
    Notes       :     
  ----------------------------------------------------------------------*/
using OpenEdge.DataAdmin.Core.FileLogger from propath.
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
using OpenEdge.DataAdmin.Error.NotFoundError from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.IDomain from propath.
using OpenEdge.DataAdmin.IPartitionPolicy from propath.
using OpenEdge.DataAdmin.IPartitionPolicyDetail from propath.
using OpenEdge.DataAdmin.IPartitionPolicySet from propath.
using OpenEdge.DataAdmin.IUser from propath.
using OpenEdge.DataAdmin.Rest.IRestRequest from propath.
using Progress.Lang.*.

routine-level on error undo, throw.

define stream acceptstream. 

function CapitalizeFirst returns char(cword as char):
    return caps(substr(cWord,1,1)) + substr(cWord,2).
end function. 
    
/* to be deprecated */
{darest/restbase.i delete partitionpolicies}
 
procedure Execute :
    define input parameter restRequest as IRestRequest  no-undo. 
 
    /* ***************************  Definitions  ************************** */
/*    define variable groupinst    as IPartitionPolicy no-undo.*/
    define variable service              as DataAdminService no-undo.
    define variable errorHandler         as DataAdminErrorHandler no-undo.
    define variable policy               as IPartitionPolicy no-undo.
    define variable policyDetail         as IPartitionPolicyDetail no-undo.
    define variable cFile                as character no-undo.
    define variable cFileOut             as character no-undo.
    define variable fileLogger           as FileLogger no-undo.
    define variable lSuccess             as logical no-undo.
    define variable policies             as IPartitionPolicySet no-undo.
    define variable cLong as longchar no-undo.
     
    /* ***************************  Main Block  *************************** */
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
            service:DeletePartitionPolicy(restRequest:KeyValue[1]).
        else if restRequest:NumLevels = 2 then
        do:
            if  restRequest:CollectionName[2] <> "partitionPolicyDetails" then
                undo, throw new NotFoundError("URL not found: " + restRequest:RequestUrl).              
            policy =  service:GetPartitionPolicy(restRequest:KeyValue[1]).
             
            if not valid-object(policy) then
                undo, throw new NotFoundError("Partition Policy " + quoter(restRequest:KeyValue[1])  + " not found").
            case restRequest:CollectionName[2]:
                when "partitionPolicyDetails" then
                do: 
                    if restRequest:KeyValue[2] > "" then
                    do:
                        policyDetail = policy:Details:Find(restRequest:KeyValue[2]).
                        if not valid-object(policyDetail) then
                            undo, throw new NotFoundError("Partition Policy Detail " + quoter(restRequest:KeyValue[2]) + " of Partition Policy '"  + quoter(restRequest:KeyValue[1])  + "' not found").
                   
                        lSuccess = policy:Details:Remove(policyDetail).   
                    end. 
                    else do:
                        policy:Details:ImportDelete(cFile).
                        lsuccess = true.
                    end.    
                end.
            end case.
    
            if lsuccess then 
            do:
                service:UpdatePartitionPolicy(policy).
            end.
            else /* remove should not normally fail when we know the record is there and the reason is not known if it does */
            
                undo, throw new NotFoundError("Delete of "  + quoter(restRequest:KeyValue[2]) + " from Partition Policy " + quoter(restRequest:KeyValue[1]) +  " " + CapitalizeFirst(restRequest:CollectionName[2]) + " failed" + ".").
               
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
    else do:
        policies = service:GetPartitionPolicies().
        policies:ImportDelete(cFile).
        service:UpdatePartitionPolicies(policies).
        output stream  acceptstream to value(cFileOut).
        put stream  acceptstream unformatted 
                "HTTP/1.1 200 OK" skip(1) 
                '~{"success" : true~}'.
        output stream  acceptstream  close.
/*        undo, throw new UnsupportedOperationError("DELETE with no key in URL:" + restRequest:RequestUrl).*/
    end.
    
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