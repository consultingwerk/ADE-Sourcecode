/*************************************************************/
/* Copyright (c) 2011-2012 by progress Software Corporation. */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : post_definitions.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : Oct 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.*  from propath.
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.ISchema from propath.
using OpenEdge.DataAdmin.IPartitionCollection from propath.
using OpenEdge.DataAdmin.IPartition from propath.
using OpenEdge.DataAdmin.Schema from propath.
using OpenEdge.DataAdmin.Core.FileLogger from propath. 
using OpenEdge.DataAdmin.Lang.Collections.IIterator from propath.
using OpenEdge.DataAdmin.Rest.IRestRequest from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
 
/* ***************************  Definitions  ************************** */
define variable definitions  as ISchema no-undo.
define variable defSchema as Schema no-undo.
define variable restRequest  as IRestRequest no-undo.
define variable service      as DataAdminService no-undo.
define variable errorHandler as DataAdminErrorHandler no-undo.
define variable fileLogger   as FileLogger no-undo.
define variable cFile        as character no-undo.
define variable cFileOut     as character no-undo.
define variable partitions as IPartitionCollection no-undo.
define variable partition as IPartition no-undo.
define variable iter as IIterator no-undo.
/* ***************************  Main Block  *************************** */
define stream acceptstream.

 
/* to be deprecated */
{darest/restbase.i post definitions} 
  
procedure Execute :
    define input parameter restRequest as IRestRequest  no-undo.   
    service = new DataAdminService(restRequest:ConnectionName).
    restRequest:Validate().
    fileLogger = new FileLogger(restRequest:LogFileName). 
    fileLogger:TaskName = restRequest:GetQueryValue("TaskName").
    service:TransactionLogger = fileLogger.
    service:URL = restRequest:ConnectionUrl.
    
    /* reads the definitions (creates objects/data from .df) */
    definitions = service:GetSchemaChanges(restRequest:FileName2). 
    
    cFile = restRequest:FileName.
    cFileOut = restRequest:OutFileName.
    definitions:ImportTree(cFile,"options,partitions").
    
    output stream acceptstream to value(cFileOut).
    put stream  acceptstream unformatted "HTTP/1.1 202 ACCEPTED" skip(1) .
    output stream  acceptstream  close.
    
    fileLogger:Log("Request start").
    
    /* loads the definitions  */
    service:UpdateSchemaChanges(definitions).
    
    defSchema = cast(definitions,Schema).
    if defSchema:ForceAllocation > "" then
    do: 
        /* the partitions collection will only have the new partitions created when the .df was loaded */ 
        partitions = defSchema:Partitions.
        
        iter = partitions:Iterator().
        
        do while iter:HasNext() :
           partition = cast(iter:Next(),IPartition).
           if partition:ObjectType = "table" and partition:AllocationState <> "Allocated" then 
           do:
              if (partition:AllocationState = "Delayed" or defSchema:ForceAllocation = "All") then
                  partition:AllocationState = "Allocated".
           end.
        end.    
    end.
    
    /* save partitions - can also have been imported  */
    service:UpdateSchema(defSchema).
    
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