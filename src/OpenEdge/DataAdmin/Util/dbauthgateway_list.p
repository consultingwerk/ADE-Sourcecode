/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : dbauthgatewaylist.p
    Purpose     : Writes the list of grants for the db-connection-role-auth feature
    Author(s)   : pjudge 
    Created     : 2016-05-11
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
                  * status is written to dbconnection_list.txt. One line per 
                    db in the format
                        DbName,Grantee,CanGrant,Grantor,RoleName
                  * writes a run log to dbconnection_status.log in FOLDER
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.LogLevelEnum.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.IDataAdminService.
using OpenEdge.DataAdmin.IDatabaseOption.

/* ********************  Definitions  ******************** */
define variable oDAS as IDataAdminService no-undo.
define variable oDbOpt as IDatabaseOption no-undo.
define variable cFolder as character no-undo.
define variable cRunLog as character no-undo.
define variable cEntry as character no-undo.
define variable cDumpFile as character no-undo.
define variable iMax as integer no-undo.
define variable iLoop as integer no-undo.
define variable cValue as character no-undo.

define stream strDump.

/* ************************** UDFs & procedures  *************************** */
&scoped-define DB-OPTION-CODE _db.sts.url

{OpenEdge/DataAdmin/Util/dboptionutils_fn.i
    &EXPORT-LOG-GROUP='DBSTSURL'
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

assign cFolder   = GetOutputFolder(cFolder)
       cRunLog   = cFolder + '/dbauthgateway_list.log':u
       cDumpFile = cFolder + '/dbauthgateway_list.txt':u.

InitLog().

PutMessage('OPERATION: LIST':u,                                  LogLevelEnum:INFO).
PutMessage(substitute('SESSION:PARAM: &1':u, session:parameter), LogLevelEnum:INFO).
PutMessage(substitute('List file: &1', cDumpFile),               LogLevelEnum:INFO).

/* main run */
output stream strDump to value(cDumpFile).
put stream strDump unformatted 
    '#DbName,URL':u
    skip. 

do iLoop = 1 to num-dbs:
    assign oDAS      = new DataAdminService(ldbname(iLoop))
           oDbOpt    = oDAS:GetDatabaseOption('{&DB-OPTION-CODE}':u)
           .
    /* if not enabled, log that and goto next db */
    if valid-object(oDbOpt) then
        assign cValue = oDbOpt:OptionValue.
    else
        assign cValue = ?.
    
    export stream strDump delimiter ',':u
        //'#DbName,STSUrl':u
        oDAS:Name
        cValue
        .
end.

{OpenEdge/DataAdmin/Util/dbconnectionrole_eof.i
        &EXPORT-LOG=cRunLog}
/* eof */