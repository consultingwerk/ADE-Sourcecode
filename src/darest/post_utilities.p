/*************************************************************/
/* Copyright (c) 2011-2012 by progress Software Corporation  */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
/*------------------------------------------------------------------------
    File        : post_utilities.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : Oct 2011
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.*.
using OpenEdge.DataAdmin.Core.*.
using OpenEdge.DataAdmin.Rest.*.
using OpenEdge.DataAdmin.Util.IDataAdminUtility.
using OpenEdge.DataAdmin.Util.UtilityFactory.
using OpenEdge.DataAdmin.Error.*.
using OpenEdge.DataAdmin.Util.ITableDataUtility.
 
/* ***************************  Definitions  ************************** */

 
 
/* ***************************  Main Block  *************************** */
define stream acceptstream.
 
/* to be deprecated */
{darest/restbase.i post utilities} 
  
procedure Execute :
    define input parameter restRequest as IRestRequest  no-undo.  
    define variable definitions  as ISchema no-undo.
    define variable defSchema as Schema no-undo.
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable fileLogger   as FileLogger no-undo.
    define variable cFile        as character no-undo.
    define variable cFileOut     as character no-undo.
    define variable utilityFactory  as UtilityFactory no-undo.
    define variable utility         as IDataAdminUtility no-undo.
    define variable cLogStatus      as character no-undo.
    define variable cTaskName       as character no-undo.
    define variable validateOnly    as logical no-undo.
    define variable dataFile        as IDataFileList no-undo.
    restRequest:Validate().
    
    cTaskName = restRequest:GetQueryValue("TaskName").
    cFile = restRequest:FileName.
    cFileOut = restRequest:OutFileName.
    
    validateOnly = restRequest:GetQueryValue("ValidateOnly") = "true".
    service = new DataAdminService(restRequest:ConnectionName). 
    if cTaskName > "" then
    do:
        /* start logger */
        fileLogger = new FileLogger(restRequest:LogFileName). 
        fileLogger:TaskName = cTaskName.
        service:TransactionLogger = fileLogger.
    end.
    
    
    utilityFactory = new UtilityFactory().
    /* not really needed for this.. */ 
    service:URL = restRequest:ConnectionUrl.
    /* import before output stream since caller may use same file (old code at least) */
    utility = UtilityFactory:GetUtility(restRequest:KeyValue[1]). 
    utility:ImportOptions(cFile).   
    
    if valid-object(fileLogger) then
    do:
    
        output stream acceptstream to value(cFileOut).                                 
        put stream  acceptstream unformatted "HTTP/1.1 202 ACCEPTED" skip(1) .
        output stream  acceptstream  close.                                         
        
        /* currently only used when logging */
        utility:TaskName = fileLogger:TaskName.
                                                                                    
        fileLogger:Log("Request start").    
    
    end.
    
    cLogstatus = restRequest:GetQueryValue("logStatus").
    if cLogstatus <> ? then
    do:
        assign
            utility:LogStatus = true
            utility:StatusFileName = restRequest:StatusFileName
            utility:StatusInterval = restRequest:StatusInterval.
       /*  not in use
       if cLogstatus = "Rows" then  
          utility:LogType = "Rows".*/
    end.    
         
    if validateOnly then
    do:
        cast(utility,ITableDataUtility):ValidateOnly = true.
    end.
    
    service:ExecuteUtility(utility).
    
    if validateOnly then
    do:
        dataFile = cast(utility,ITableDataUtility):ProblemFiles.
        dataFile:Export(cFileOut).
    end.
    else if valid-object(fileLogger) then
    do:
        fileLogger:Log("Request complete").
        
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
       delete object fileLogger no-error. 		
       delete object service no-error.
    end finally.
end.   