/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : dbconnectionrole_status.p
    Purpose     : Writes the status of the db-connection-role-auth feature
    Author(s)   : pjudge 
    Created     : 2016-05-03
    Notes       : * This utility operates against all currently-connected DBs
                  * Behaviour can be tweaked using the -param switch, with
                    values formatted in comma- and colon-delimited pairs
                    <name-1>:<value-1>,<name-2>:<value-2> ...
                  * Supported options
                    FOLDER      : (optioanal) an extant folder name for writing logs. 
                                  If not provided, we use the first
                                  extant folder:
                                    - WRKDIR env var
                                    - '.' (current dir)
                                    - session temp-dir (-T) 
                  * status is written to dbconnection_status.txt. One line per 
                    db in the format
                        DbName,RoleEnabled,RoleName
                  * writes a run log to dbconnection_status.log in FOLDER
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.IDataAdminService.
using OpenEdge.DataAdmin.IDatabaseOption.

/* ********************  Definitions  ******************** */
define variable oDAS as IDataAdminService no-undo.
define variable oDbOpt as IDatabaseOption no-undo.
define variable cFolder as character no-undo.
define variable cRunLog as character no-undo.
define variable cEntry as character no-undo.
define variable cStatusFile as character no-undo.
define variable lEnabled as logical no-undo.
define variable iLoop as integer no-undo.
define variable iMax as integer no-undo.
define variable cRoleName as character no-undo.

define stream strDump.

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

assign cFolder     = GetOutputFolder(cFolder)
       cRunLog     = cFolder + '/dbconnection_status.log':u
       cStatusFile = cFolder + '/dbconnection_status.txt':u.

InitLog().

PutMessage('OPERATION: STATUS':u,                                LogLevelEnum:INFO).
PutMessage(substitute('SESSION:PARAM: &1':u, session:parameter), LogLevelEnum:INFO).
PutMessage(substitute('Status file: &1', cStatusFile),           LogLevelEnum:INFO).

/* main run */
output stream strDump to value(cStatusFile).
put stream strDump unformatted 
    '#DbName,Enabled,RoleName':u
    skip. 

do iLoop = 1 to num-dbs:
    assign oDAS = new DataAdminService(ldbname(iLoop))
           oDbOpt = oDAS:GetDatabaseOption('{&DB-OPTION-CODE}':u)
           lEnabled = valid-object(oDbOpt) and oDbOpt:OptionValue ne ?
           .
    if lEnabled then
    do:
        assign cRoleName = oDbOpt:OptionValue.
        if cRoleName eq '':u then
            cRoleName = '{&CONN-AUTH-ROLE}':u.
    end.
    
    export stream strDump delimiter ',':u
        //'#DbName,RoleEnabled,RoleName':u
        oDAS:Name 
        lEnabled
        cRoleName
        .
end.

{OpenEdge/DataAdmin/Util/dbconnectionrole_eof.i
        &EXPORT-LOG=cRunLog}
/* eof */