/* ***********************************************************/
/* Copyright (c) 2011-2013 by Progress Software Corporation  */
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


/* *************************** Definitions *************************** */
define variable resOutput as longchar no-undo.
define variable useLongChar as logical no-undo init false.
define stream capture .
/* ***************************  Main Block  *************************** */

 
if not this-procedure:persistent then
do:
    if session:batch-mode then 
        run runapi (session:param).
    else 
        undo, throw new UnsupportedOperationError("rest.p must be run persistent when not in batch mode") .   
end.


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
    define variable lOk               as logical no-undo.
    define variable cDb               as character no-undo.
 
    requestInfo = new RestRequestInfo().
    requestInfo:InitFromJsonFile(pcPrm). 
    assign 
       cConnectionString = requestInfo:Connection
       cProgramName      = requestInfo:ProcedureName.
    
    if session:batch-mode then
        output to value(requestInfo:captureFileName).
        
    do on error undo, throw:     
        connect value(cConnectionString).
        catch e as Progress.Lang.Error :
            /* ignore already connected */
        	if e:GetMessageNum(1) <> 1012 then
        	    undo, throw e.
        end catch.
    end.
     
    request = new RestRequest(requestInfo).
    request:ConnectionName = ldbname(num-dbs).
    cDb = request:ConnectionName.
    /* on stop or quit seems to mess up on error - catch so we use to blocks*/
    do on stop undo, leave on quit, leave:
        do on error undo, leave :
            run value(cProgramName) persistent set hRestService.
            run execute in hRestService (request).
            catch e as Progress.Lang.Error:
                run handleError(e,requestInfo:ErrorFileName).
            end.
        end.
        lok = true.
    end.   
    if not lok then
    do:
        run handleStop(requestInfo:captureFileName,requestInfo:ErrorFileName).
    end. 
    catch e as Progress.Lang.Error:
        run handleError(e,requestInfo:ErrorFileName).
    end.
    finally:  
        if valid-handle(hRestService) then 
            delete object hRestService. 
         /* use no-error - if connection failed the request will not be valid */  
        disconnect value(cDb) no-error.
        if useLongChar and search(requestInfo:OutFileName ) <> ? then 
            copy-lob from file requestInfo:OutFileName to resOutput convert target codepage "UTF-8". 
        if session:batch-mode then                                                                         
            output close. 
        		
    end finally. 
end.

procedure handleStop:
    define input  parameter pLogFile as character no-undo.
    define input  parameter pErrorfile as character no-undo.
    define variable cline as character no-undo.
    define variable err as AppError no-undo.
    err = new AppError("The service request was stopped. This could be because a schema lock exists or could not be aquired.",?).
    if session:batch-mode then output close.                               
    undo, throw err.
    catch e as Progress.Lang.Error :
		run handleError(e,pErrorfile).
    end catch.
end. 

procedure handleError:
    define input  parameter perr as error no-undo.
    define input  parameter pfile as character no-undo.
    define variable errorHandler      as DataAdminErrorHandler no-undo.
   
    if session:batch-mode then
        errorHandler = new DataAdminErrorHandler(pfile).
    else
        errorHandler = new DataAdminErrorHandler().
    errorHandler:Error(perr).
end.    
