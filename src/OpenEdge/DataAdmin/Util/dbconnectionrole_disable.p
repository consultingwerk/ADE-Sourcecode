/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : dbconnectionrole_disable.p
    Purpose     : Disables the connection auth feature 
    Author(s)   : pjudge 
    Created     : 2016-05-03
    Notes       : * This utility operates against all currently-connected DBs
                  * Behaviour can be tweaked using the -param switch, with
                    values formatted in comma- and colon-delimited pairs
                    <name-1>:<value-1>,<name-2>:<value-2> ...
                  * Supported options
                    FOLDER      : (optional) an extant folder name for writing logs. 
                                  If not provided, we use the first
                                  extant folder:
                                    - WRKDIR env var
                                    - '.' (current dir)
                                    - session temp-dir (-T) 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Core.Session.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.DatabaseOptionTypeEnum.
using OpenEdge.DataAdmin.IDataAdminService.
using OpenEdge.DataAdmin.IDatabaseOption.
using OpenEdge.DataAdmin.IRole.
using OpenEdge.DataAdmin.IGrantedRole.
using OpenEdge.DataAdmin.Lang.Collections.IIterator.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.

/* ********************  Preprocessor Definitions  ******************** */
define variable oDAS as IDataAdminService no-undo.
define variable cDB as character no-undo.
define variable cRoleName as character no-undo.
define variable oDbOpt as IDatabaseOption no-undo.
define variable oRole as IRole no-undo.
define variable oGrant as IGrantedRole no-undo.
define variable iMax as integer no-undo.
define variable iLoop as integer no-undo.
define variable hCurrentUser as handle no-undo.
define variable cFolder as character no-undo.
define variable cRunLog as character no-undo.
define variable cEntry as character no-undo.

/* ************************** UDFs & procedures  *************************** */
{OpenEdge/DataAdmin/Util/dbconnectionrole_fn.i
    &EXPORT-LOG=cRunLog}

/* ***************************  Main Block  *************************** */
/* extract params */
assign iMax = num-entries (session:parameter).
do iLoop = 1 to iMax:
    assign cEntry = entry(iLoop, session:parameter).
    
    case entry(1, cEntry, ':':u):
        when 'FOLDER':u then
            /* the folder may have a : in it so don't use ENTRY() */
            assign cFolder = substring(cEntry, 8)
                   no-error.
    end case.
end.

assign cRunLog = GetOutputFolder(cFolder) + '/dbconnectionrole_disable.log':u.
InitLog().

PutMessage('OPERATION: DISABLE':u,                               LogLevelEnum:INFO).
PutMessage(substitute('SESSION:PARAM: &1':u, session:parameter), LogLevelEnum:INFO).

/* main run */
do iLoop = 1 to num-dbs:
    assign hCurrentUser = get-db-client(ldbname(iLoop)).
    if not IsAdmin(hCurrentUser:qualified-user-id) then
    do: 
        PutMessage(substitute('Current user is not a security admin for db &1', 
                        quoter(ldbname(iLoop))),   
                   LogLevelEnum:ERROR).
        next.
    end.
    
    assign oDAS   = new DataAdminService(ldbname(iLoop))
           oDbOpt = oDAS:GetDatabaseOption('{&DB-OPTION-CODE}':u).
    
    if not valid-object(oDbOpt) or oDbOpt:OptionValue eq ? then
    do:
        PutMessage(substitute('Connection authorization already disabled for &1', 
                        quoter(oDAS:Name)),
                   LogLevelEnum:INFO).
        next.
    end.
    
    /* cannot delete the dboptions */
    assign oDbOpt:OptionValue = ?.
    oDAS:UpdateDatabaseOption(oDbOpt).
    
    PutMessage(substitute('Connection authorization now disabled for &1', 
                        quoter(oDAS:Name)),
                   LogLevelEnum:INFO).
end.

{OpenEdge/DataAdmin/Util/dbconnectionrole_eof.i
        &EXPORT-LOG=cRunLog}
/* eof */