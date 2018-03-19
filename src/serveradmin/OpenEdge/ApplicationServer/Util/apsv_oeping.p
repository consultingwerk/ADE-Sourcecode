/* *************************************************************************************************************************
Copyright (c) 2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : OpenEdge/ApplicationServer/Util/apsv_oeping.p
    Purpose     : A service interface around the OpenEdge.Rest.Admin.AppServerStatus
                  class used to establish life on the server. See that class' ServerStatus
                  method for more information.
    Author(s)   : pjudge
    Created     : 2017-09-14
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Rest.Admin.AppServerStatus.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.AppError.

/* ***************************  Main Block  *************************** */
define output parameter pStatus as JsonObject no-undo.

define variable ass as AppServerStatus no-undo.
define variable logger as ILogWriter no-undo.
define variable pingData as JsonObject no-undo.
define variable statusResponse as character no-undo.
define variable svrStatus as JsonConstruct no-undo.

assign logger = LoggerBuilder:GetLogger(this-procedure).

// Log in case we want to see who's been pinging us
logger:Trace('APSV ping request recieved').

assign pStatus  = new JsonObject()
       pingData = new JsonObject()
       .
// envelope first 
pStatus:Add('response':u, pingData).

// Use a CCS Service Manager if extant, and let it control this object's lifecycle.
if valid-object(Ccs.Common.Application:ServiceManager) then
   assign ass = cast(Ccs.Common.Application:ServiceManager:getService(get-class(AppServerStatus)),
                     AppServerStatus).

if not valid-object(ass) then
    assign ass = new AppServerStatus().

assign statusResponse = ass:ServerStatus().
// separate ASSIGN for the Parse() operation to avoid trapping errors
assign svrStatus = (new ObjectModelParser()):Parse(statusResponse) 
       no-error.
case true:
    when not valid-object(svrStatus)    then pingData:Add('_retVal':u, statusResponse).
    when type-of(svrStatus, JsonObject) then pingData:Add('_retVal':u, cast(svrStatus, JsonObject)).
    when type-of(svrStatus, JsonArray)  then pingData:Add('_retVal':u, cast(svrStatus, JsonArray)).
end case.

catch pingError as Progress.Lang.Error:
    define variable errList as JsonArray no-undo.
    define variable errData as JsonObject no-undo.
    define variable cnt as integer no-undo.
    
    if valid-object(logger) then
        logger:Error('APSV Ping error', pingError).
    
    /* build the current error */
    assign pStatus = new JsonObject()
           errList = new JsonArray()
           .
    if type-of(pingError, AppError) then
        pStatus:Add('_retVal':u, cast(pingError, AppError):ReturnValue).
    
    pStatus:Add('_errors':u, errList).
    do cnt = 1 to pingError:NumMessages:
        assign errData = new JsonObject().
        errList:Add(errData).
        
        errData:Add('_errorMsg':u, pingError:GetMessage(cnt)).
        errData:Add('_errorNum':u, pingError:GetMessageNum(cnt)).
    end.
end catch.
/* EOF */