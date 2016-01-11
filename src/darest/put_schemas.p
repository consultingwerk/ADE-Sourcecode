/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : put_schemas.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : rkumar
    Created     : March 2011
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.*.
using OpenEdge.DataAdmin.Core.*.
using OpenEdge.DataAdmin.Rest.*.
using OpenEdge.DataAdmin.Error.*.


define stream acceptstream.

define variable mMode       as char init "put" no-undo.
define variable mCollection as char init "schemas" no-undo.
define variable fileLogger  as FileLogger no-undo.

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
    define variable schemaInst     as ISchema no-undo.
    define variable tableSet       as ITableSet no-undo.
    define variable seq            as ISequence no-undo.
    define variable seqMap         as ISequenceValueMap no-undo.
    define variable restRequest    as RestRequest no-undo.
    define variable service        as DataAdminService no-undo.
    define variable errorHandler   as DataAdminErrorHandler no-undo.
    define variable cFile          as character no-undo.
    define variable cFileOut       as character no-undo.
    define variable clong as longchar no-undo.
    /* ***************************  Main Block  *************************** */
    do on stop undo, leave:       
        restRequest = new RestRequest(mMode,mCollection,pcParam).  
        service = new DataAdminService(restRequest:ConnectionName).
        restRequest:Validate().
        
        service:TransactionLogger = fileLogger.
        service:URL = restRequest:ConnectionUrl.
        
        assign
           cFile = restRequest:FileName
           cFileOut = restRequest:OutFileName.
        
        
        if restRequest:KeyValue[1] > "" then 
        do:
            if restRequest:KeyValue[1] <> "PUB" then 
                undo, throw new UnsupportedOperationError("Request for schema key " + quoter(restRequest:KeyValue[1])).    
         
            schemaInst = service:GetSchema().
            if schemaInst = ? then
                undo, throw new NotFoundError("Schemas "  + restRequest:KeyValue[1]  + " not found").
                  
            if restRequest:NumLevels > 1 and restRequest:CollectionName[2] > "" then
            do:
                case restRequest:CollectionName[2]:
                    when "tables" then
                    do:
                        fileLogger = new FileLogger(restRequest:LogFileName). 
                        fileLogger:TaskName = restRequest:GetQueryValue("TaskName").
                        fileLogger:Log("Request start").
                        tableSet = schemaInst:Tables.
                        tableSet:ImportTree(cFile,"options,partitions").
                        output stream acceptstream to value(cFileOut).
                        put stream  acceptstream unformatted "HTTP/1.1 202 ACCEPTED" skip(1) .
                        output stream  acceptstream  close.
                        
                        service:UpdateTables(tableset).
                        /*
                        cast(tableset,TableSet):ExportLastSavedTree(cFileout). 
                        copy-lob file cFileOut to clong.     
                        substring(cLong,2,0) = '"success" : true,'.
                        copy-lob clong to file cFileOut.                
                        */
                        fileLogger:Log("Request end").
        
                        output stream  acceptstream to value(cFileOut).
                        put stream  acceptstream unformatted "HTTP/1.1 200 OK" skip(1) .
                        output stream  acceptstream  close.
        
                    end.
                    when "sequences" then
                    do:
                        
                        if restRequest:KeyValue[2] <> ? then
                        do:  
                            if restRequest:CollectionName[3] = ? then                               
                                /* put should go to sequences without schema */
                                undo, throw new UnsupportedOperationError("PUT URL: " + restRequest:RequestUrl
                                            + "~n"
                                            + "Use PUT ~"sequences~" for multiple rows instead of single row with ~"schemas/PUB/sequences/"  + restRequest:KeyValue[2] + "~".").                             
                            
                            if restRequest:CollectionName[3] = "sequenceValues" then
                            do:
                                seq = service:GetSequence(restRequest:KeyValue[2]).
                                seq:SequenceValues:Import(cFile).
                                service:UpdateSequence(seq).
                                seq:SequenceValues:ExportLastSaved(cFileOut).
                                copy-lob file cFileOut to clong.     
                                substring(cLong,2,0) = '"success" : true,'.
                                copy-lob clong to file cFileOut.                  
                            end.
                            else
                                undo, throw new UnsupportedOperationError("PUT URL: " + restRequest:RequestUrl).  
                        end.
                        else
                            undo, throw new UnsupportedOperationError("PUT URL: " + restRequest:RequestUrl
                                            + "~n"
                                            + "Use PUT ~"sequences~" instead of ~"schemas/PUB/sequences~".").  
                      
                    end.
                    otherwise    
                        undo, throw new UnsupportedOperationError("PUT URL: " + restRequest:RequestUrl).  
                    
                end case.
            end.    
            else do: 
               undo, throw new UnsupportedOperationError("PUT URL: " + restRequest:RequestUrl).    
            end.
        end.
        else 
            undo, throw new UnsupportedOperationError("PUT with no key in URL: " + restRequest:RequestUrl).    
        
        catch e as Progress.Lang.Error :
            if valid-object(fileLogger) then
               fileLogger:Log("Request failed").
            if session:batch-mode then
                errorHandler =  new DataAdminErrorHandler(restRequest:ErrorFileName).
            else
                errorHandler = new DataAdminErrorHandler().
            errorHandler:Error(e).      
        end catch.
    end.
    
    finally:
        delete object service no-error.  
        output stream  acceptstream  close. 
        if valid-object(fileLogger) then
            delete object fileLogger .        
    end finally.
      
end.