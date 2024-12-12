/*************************************************************/
/* Copyright (c) 2024 by progress Software Corporation       */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : get_vstdata.p
    
    Description : Dump VST table(s) data into a JSON
    Author(s)   : tmasood
    Created     : Thur Aug 08 10:34:45 IST 2024
    Notes       :
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.Rest.RestService from propath.
using OpenEdge.DataAdmin.Rest.IRestRequest from propath.
using OpenEdge.DataAdmin.Error.NotFoundError from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
 
{darest/restbase.i get vstdata}  

procedure Execute:
    define input  parameter restRequest as IRestRequest  no-undo.     
    /* ***************************  Definitions  ************************** */
   
    define variable service      as RestService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable tthdl        as handle     no-undo.
    define variable bConnecthdl  as handle     no-undo.
    define variable btthdl       as handle     no-undo.
    define variable cTableName   as character  no-undo.
    define variable lRetVal      as logical    no-undo.
    define variable cOutputFile  as character  no-undo.
    /* ***************************  Main Block  *************************** */
    restRequest:Validate().
    service = new RestService(restRequest:ConnectionName).
    service:URL = restRequest:ConnectionUrl.
    cTableName  = if restRequest:KeyValue[1] > "" then restRequest:KeyValue[1] else "" .
    
    case cTableName: 
    // Moving forward we can add more tables under the CASE statement
    when "_Connect" then do:
        /* Get VST table handle */
        bConnecthdl = BUFFER _Connect:HANDLE.
        /* Create an empty, undefined TEMP-TABLE */
        CREATE TEMP-TABLE tthdl.
        /* Give it _Connect table's fields & indexes */
        tthdl:CREATE-LIKE(bConnecthdl).
        tthdl:SERIALIZE-NAME = "_Connect".
        tthdl:TEMP-TABLE-PREPARE("ttConnect").
        /* Get the buffer handle for the temp-table */
        btthdl = tthdl:DEFAULT-BUFFER-HANDLE.
 
        // Populate the temp-table buffer with data
        for each _connect no-lock:
            btthdl:BUFFER-CREATE.
            btthdl:BUFFER-COPY(bConnecthdl).
        end.
        // make sure the output filename is provided
        if INDEX(restRequest:OutFileName, ".json") = 0 then
          cOutputFile = cTableName + ".json".
        else
          cOutputFile = restRequest:OutFileName.
        // Write the temp-table to JSON and capture any error, if occured
        lRetVal = btthdl:WRITE-JSON("file", cOutputFile, TRUE) NO-ERROR.
        if ERROR-STATUS:ERROR and ERROR-STATUS:NUM-MESSAGES > 0 then
          undo, throw new NotFoundError("Error occurred: '" + ERROR-STATUS:GET-MESSAGE(1)).
             
        if not lRetVal then
          undo, throw new NotFoundError(substitute("Unable to write JSON output file: &1", cOutputFile)).        
    end.    
    otherwise do:
        if cTableName = "" then
          undo, throw new NotFoundError("VST name cannot be blank. Please enter valid VST name in URL.").
        else
          undo, throw new NotFoundError("VST name not found. Please enter valid VST name in URL.").
    end. 
    
    end case. 
  
    catch e as Progress.Lang.Error :
        if session:batch-mode then
            errorHandler =  new DataAdminErrorHandler(restRequest:ErrorFileName).
        else
            errorHandler = new DataAdminErrorHandler().
        errorHandler:Error(e).      
    end catch.
    finally:
        delete object service no-error. 
        if valid-handle(btthdl) then 
          btthdl:BUFFER-RELEASE().
        delete object tthdl no-error.
    end finally.
    
end.
