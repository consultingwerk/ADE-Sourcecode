/*************************************************************/
 /* Copyright (c) 2011 by progress Software Corporation.      */
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
using OpenEdge.DataAdmin.Internal.Util.UtilityFactory.
using OpenEdge.DataAdmin.Error.*.
 
/* ***************************  Definitions  ************************** */
define variable definitions  as ISchema no-undo.
define variable defSchema as Schema no-undo.
define variable restRequest  as RestRequest no-undo.
define variable service      as DataAdminService no-undo.
define variable errorHandler as DataAdminErrorHandler no-undo.
define variable fileLogger   as FileLogger no-undo.
define variable cFile        as character no-undo.
define variable cFileOut     as character no-undo.
define variable utilityFactory  as UtilityFactory no-undo.
define variable utility         as IDataAdminUtility no-undo.
 
 
/* ***************************  Main Block  *************************** */
define stream acceptstream.

define variable mMode       as char init "post" no-undo.
define variable mCollection as char init "utilities" no-undo.

if session:batch-mode and not this-procedure:persistent then 
do:
   output to value("post_utilities.log"). 
   run executeRequest(session:parameter).  
end.
finally:
    if session:batch-mode then output close.            
end finally.  
 
procedure executeRequest:
    define input  parameter pcParam as character no-undo.   

    restRequest = new RestRequest(mMode,mCollection,pcParam).  
    restRequest:Validate().
     
    
    /* start logger */
    fileLogger = new FileLogger(restRequest:LogFileName). 
    fileLogger:TaskName = restRequest:GetQueryValue("TaskName").
    
    
    cFile = restRequest:FileName.
    cFileOut = restRequest:OutFileName.
    
    
    utilityFactory = new UtilityFactory().
    service = new DataAdminService(restRequest:ConnectionName). 
    /* not really needed for this.. */ 
    service:URL = restRequest:ConnectionUrl.
    service:TransactionLogger = fileLogger.
    
    utility = UtilityFactory:GetUtility(restRequest:KeyValue[1]). 
    utility:ImportOptions(cFile).   
    
    output stream acceptstream to value(cFileOut).                                 
    put stream  acceptstream unformatted "HTTP/1.1 202 ACCEPTED" skip(1) .
    output stream  acceptstream  close.                                         
                                                                                
    fileLogger:Log("Request start").    
    
    service:ExecuteUtility(utility).
    
    fileLogger:Log("Request complete").
    
    output stream  acceptstream to value(cFileOut).
    put stream  acceptstream unformatted "HTTP/1.1 200 OK" skip(1) .
    output stream  acceptstream  close.
    
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
       delete object fileLogger. 		
    end finally.
end.   