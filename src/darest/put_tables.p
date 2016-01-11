/*************************************************************/
/* Copyright (c) 2014 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : put_tables.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Jan 2014
    Notes       : this only works on PUB tables
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.*.
using OpenEdge.DataAdmin.Core.*.
using OpenEdge.DataAdmin.Rest.*.
using OpenEdge.DataAdmin.Error.*.


define stream acceptstream.

define variable fileLogger  as FileLogger no-undo.

 /* to be deprecated */
{darest/restbase.i put tables} 
  
procedure Execute :
    define input parameter restRequest as IRestRequest  no-undo.      
    /* ***************************  Definitions  ************************** */
    define variable schemaInst     as ISchema no-undo.
    define variable tableSet       as ITableSet no-undo.
    define variable tableinst      as ITable no-undo.
    define variable service        as DataAdminService no-undo.
    define variable errorHandler   as DataAdminErrorHandler no-undo.
    define variable cFile          as character no-undo.
    define variable cFileOut       as character no-undo.
    define variable clong          as longchar no-undo.
    define variable cTaskName      as character no-undo.
    
    /* ***************************  Main Block  *************************** */
    service = new DataAdminService(restRequest:ConnectionName).
    restRequest:Validate().
        
    service:TransactionLogger = fileLogger.
    service:URL = restRequest:ConnectionUrl.
        
    assign
        cFile = restRequest:FileName
        cFileOut = restRequest:OutFileName
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
    if restRequest:KeyValue[1] = ? then 
    do:
        tableSet = service:GetTables().
        tableSet:ImportTree(cFile,"options,partitions").
    end.
    else do:
        tableinst = service:GetTable(restRequest:KeyValue[1]).         
        if not valid-object(tableinst) then
            undo, throw new NotFoundError("Table "  + restRequest:KeyValue[1]  + " not found").
    end.    
    
    if valid-object(tableSet) then
    do:                
        service:UpdateTables(tableset).
        if cTaskName = "" or cTaskName = ? then
        do:
           tableset:ExportLastSaved(cFileOut).      
           copy-lob file cFileOut to clong.     
           substring(cLong,2,0) = '"success" : true,'.
           copy-lob clong to file cFileOut.      
        end.
    end.
    else do:
        service:UpdateTable(tableinst).
        if cTaskName = "" or cTaskName = ? then
        do:
           tableinst:Export(cFileOut).      
           copy-lob file cFileOut to clong.     
           substring(cLong,2,0) = '"success" : true,'.
           copy-lob clong to file cFileOut.      
        end.
    end.       
    
    /* write Request complete */
    if cTaskName > "" then 
    do:
        if valid-object(fileLogger) then
        do:
             fileLogger:Log("Request complete").
        end.    
        output stream  acceptstream to value(cFileOut).
        put stream  acceptstream unformatted "HTTP/1.1 200 OK" skip(1) .
        output stream  acceptstream  close.
    end. 
    
    catch e as Progress.Lang.Error :
        if valid-object(fileLogger) then
            fileLogger:Log("Request failed").
        if session:batch-mode then
            errorHandler =  new DataAdminErrorHandler(restRequest:ErrorFileName).
        else
           errorHandler = new DataAdminErrorHandler().
       errorHandler:Error(e).      
    end catch.
    
    finally:
        delete object service no-error.  
        output stream  acceptstream  close. 
        if valid-object(fileLogger) then
            delete object fileLogger .        
    end finally.
      
end.