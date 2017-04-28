/*************************************************************/
/* Copyright (c) 2016 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : delete_cdctablepolicies.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : mkondra
    Created     : Fri Apr 22 18:17:16 IST 2016
    Notes       :
  ----------------------------------------------------------------------*/
using OpenEdge.DataAdmin.Core.FileLogger from propath.
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
using OpenEdge.DataAdmin.Error.NotFoundError from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.IDomain from propath.
using OpenEdge.DataAdmin.ICdcTablePolicy from propath.
using OpenEdge.DataAdmin.ICdcFieldPolicy from propath.
using OpenEdge.DataAdmin.ICdcTablePolicySet from propath.
using OpenEdge.DataAdmin.IUser from propath.
using OpenEdge.DataAdmin.Rest.IRestRequest from propath.
using Progress.Lang.*.

routine-level on error undo, throw.

define stream acceptstream. 

function CapitalizeFirst returns char(cword as char):
    return caps(substr(cWord,1,1)) + substr(cWord,2).
end function. 
    
/* to be deprecated */
{darest/restbase.i delete cdctablepolicies}
 
procedure Execute :
    define input parameter restRequest as IRestRequest  no-undo. 
 
    /* ***************************  Definitions  ************************** */
    define variable service              as DataAdminService no-undo.
    define variable errorHandler         as DataAdminErrorHandler no-undo.
    define variable policy               as ICdcTablePolicy no-undo.
    define variable fieldPolicy          as ICdcFieldPolicy no-undo.    
    define variable cFile                as character no-undo.
    define variable cFileOut             as character no-undo.
    define variable fileLogger           as FileLogger no-undo.
    define variable policies             as ICdcTablePolicySet no-undo.
    define variable cLong                as longchar no-undo.
    define variable lSuccess             as logical no-undo.
     
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
            service:DeleteCdcTablePolicy(restRequest:KeyValue[1]).
                else if restRequest:NumLevels = 2 then
        do:
            if  restRequest:CollectionName[2] <> "cdcFieldPolicies" then
                undo, throw new NotFoundError("URL not found: " + restRequest:RequestUrl).              
            policy =  service:GetCdcTablePolicy(restRequest:KeyValue[1]).
             
            if not valid-object(policy) then
                undo, throw new NotFoundError("CDC Table Policy " + quoter(restRequest:KeyValue[1])  + " not found").
            case restRequest:CollectionName[2]:
                when "cdcFieldPolicies" then
                do: 
                    if restRequest:KeyValue[2] > "" then
                    do:
                        fieldPolicy = policy:FieldPolicies:Find(restRequest:KeyValue[2]).
                        if not valid-object(fieldPolicy) then
                            undo, throw new NotFoundError("CDC Field Policy " + quoter(restRequest:KeyValue[2]) + " of CDC Table Policy '"  + quoter(restRequest:KeyValue[1])  + "' not found").
                   
                        lSuccess = policy:FieldPolicies:Remove(fieldPolicy).   
                    end. 
                    else do:
                        policy:FieldPolicies:ImportDelete(cFile).
                        lsuccess = true.
                    end.    
                end.
            end case.
    
            if lsuccess then 
            do:
                service:UpdateCdcTablePolicy(policy).
            end.
            else /* remove should not normally fail when we know the record is there and the reason is not known if it does */
            
                undo, throw new NotFoundError("Delete of "  + quoter(restRequest:KeyValue[2]) + " from CDC Table Policy " + quoter(restRequest:KeyValue[1]) +  " " + CapitalizeFirst(restRequest:CollectionName[2]) + " failed" + ".").
               
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
        policies = service:GetCdcTablePolicies().
        policies:ImportDelete(cFile).
        service:UpdateCdcTablePolicies(policies).
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