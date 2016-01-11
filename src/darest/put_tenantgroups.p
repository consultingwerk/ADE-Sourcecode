/*************************************************************/
/* Copyright (c) 2010-2012 by progress Software Corporation  */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : put_tenantgroups.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : 2010
    Notes       :     
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.ITenantGroup from propath.
using OpenEdge.DataAdmin.ITable from propath.
using OpenEdge.DataAdmin.Error.NotFoundError from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
using OpenEdge.DataAdmin.Util.DeallocateUtility  from propath.
using OpenEdge.DataAdmin.Rest.IRestRequest  from propath.
using OpenEdge.DataAdmin.Core.FileLogger  from propath.

define stream acceptstream.

/* to be deprecated */
{darest/restbase.i put tenantgroups} 
  
procedure Execute :
    define input parameter restRequest as IRestRequest  no-undo. 
 
    /* ***************************  Definitions  ************************** */
    define variable groupinst    as ITenantGroup no-undo.    
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable deallocateUtility as DeallocateUtility no-undo.
  
    define variable cFile        as character no-undo.
    define variable cFileOut     as character no-undo.
    define variable fileLogger   as FileLogger no-undo.
    define variable cLong as longchar no-undo.
     
    /* ***************************  Main Block  *************************** */
    service = new DataAdminService(restRequest:ConnectionName).
   
    restRequest:Validate().
    
    service:URL = restRequest:ConnectionUrl.
    
    assign
        cFile = restRequest:FileName
        cFileOut = restRequest:OutFileName.
    
    
    If restRequest:KeyValue[1] > "" then
    do: 
        if restRequest:NumLevels = 1 
        or restRequest:CollectionName[2] = "deallocate" then
        do:
            groupinst = service:GetTenantGroup(restRequest:KeyValue[1]).
            if groupinst = ? then
                undo, throw new NotFoundError("Tenant group "  + restRequest:KeyValue[1]  + " not found").
            
            if restRequest:NumLevels = 1 then
            do:            
                groupinst:ImportTree(cFile).                   
                service:UpdateTenantGroup(groupinst).
                groupinst:ExportTree(cFileOut).
                copy-lob file cFileOut to clong.   
                substring(cLong,2,0) = '"success" : true, '.
                copy-lob clong to file cFileOut. 
                
            end.    
            else if restRequest:CollectionName[2] = "deallocate" then
            do:
                if restRequest:GetQueryValue("TaskName") > "" then
                do:
                     /* start logger */
                    fileLogger = new FileLogger(restRequest:LogFileName). 
                    fileLogger:TaskName = restRequest:GetQueryValue("TaskName").
                    fileLogger:Log("Request start").    
                    service:TransactionLogger = fileLogger.
                         
                    output stream acceptstream to value(cFileOut).                                 
                    put stream  acceptstream unformatted "HTTP/1.1 202 ACCEPTED" skip(1) .
                    output stream  acceptstream  close.        
                end.
                
                deallocateUtility = new DeallocateUtility(groupinst).
                service:ExecuteUtility(deallocateUtility).
                
/*                groupinst:Deallocate().                 */
/*                service:UpdateTenantGroup(groupinst).*/
            
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
           undo, throw new UnsupportedOperationError("URL: " + restRequest:RequestUrl).    
 
    end.
    else 
        undo, throw new UnsupportedOperationError("PUT with no key in URL:" + restRequest:ConnectionUrl).    
 
    catch e as Progress.Lang.Error :
        if valid-object(fileLogger) then
            fileLogger:Log("Request failed").
        if session:batch-mode then
            errorHandler = new DataAdminErrorHandler(restRequest:ErrorFileName).
        else
            errorHandler = new DataAdminErrorHandler().
        errorHandler:Error(e).      
    end catch.
    finally:
        delete object service no-error.     
    end finally.
    
end.