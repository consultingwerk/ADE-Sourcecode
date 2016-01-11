/* ***********************************************************/
/* Copyright (c) 2011-2012 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/

/*------------------------------------------------------------------------
    File        : runapi.p
    Purpose     :

    Syntax      :

    Description :

    Author(s)   : egarcia
    Created     : Thu Mar 31 17:41:21 EDT 2011
    Notes       :
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.
using Progress.Lang.* from propath.
using OpenEdge.DataAdmin.Rest.IRestRequestInfo from propath.
using OpenEdge.DataAdmin.Rest.IRestRequest from propath.
using OpenEdge.DataAdmin.Rest.RestRequest from propath.
using OpenEdge.DataAdmin.Rest.RestRequestInfo from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
using OpenEdge.DataAdmin.Error.OperationError from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.

/* ***************************  Main Block  *************************** */
if not this-procedure:persistent then
do:
    if session:batch-mode then 
        run runapi (session:param).
    else 
        undo, throw new UnsupportedOperationError("rest.p must be run persistent when not in batch mode") .   
end.

define variable resOutput as longchar no-undo.
define variable useLongChar as logical no-undo init false.

procedure getOutput:
    define output parameter res as longchar no-undo.
    res = resOutput.
end.

procedure SetUseLongChar:
    define input parameter pUseLongChar as logical no-undo.
    useLongChar = pUseLongchar.
end.

procedure runApi:
    define input parameter pcPrm as character no-undo.
    define variable requestInfo       as IRestRequestInfo no-undo.
    define variable request           as IRestRequest     no-undo.
    define variable cProgramName      as character no-undo.
    define variable cConnectionString as character no-undo.
    define variable cURL              as character no-undo.
    define variable hRestService      as handle    no-undo.

    define variable errorHandler      as DataAdminErrorHandler no-undo.
    
    
    requestInfo = new RestRequestInfo().
    requestInfo:InitFromJsonFile(pcPrm). 
    assign 
       cConnectionString = requestInfo:Connection
       cProgramName      = requestInfo:ProcedureName.
    
    if session:batch-mode then
        output to value(requestInfo:captureFileName). 
        
    connect value(cConnectionString).
    request = new RestRequest(requestInfo).
    request:ConnectionName = ldbname(num-dbs).
    
    do on stop undo, leave:
        run value(cProgramName) persistent set hRestService.
    end.
    if valid-handle(hRestService) then
    do:
        run execute in hRestService (request).
    end. 
    

    catch e as Progress.Lang.Error:
        
        if session:batch-mode then
            errorHandler = new DataAdminErrorHandler(requestInfo:ErrorFileName).
        else
            errorHandler = new DataAdminErrorHandler().
        errorHandler:Error(e).
    end.
    finally :
        if valid-handle(hRestService) then
	        delete object hRestService.
        /* if connection failed the request will not be valid */
        if valid-object(request) then 
            disconnect value(request:ConnectionName).
                  
        if useLongChar then do:
            copy-lob from file requestInfo:OutFileName to resOutput convert target codepage "UTF-8".
        end.
           
        if session:batch-mode then 
            output close.   
           
           
    end.
end.
