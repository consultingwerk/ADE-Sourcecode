/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : dbauthgateway_status.p
    Purpose     : Writes the status of the db-connection-role-auth feature
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
                  * status is written to dbauthgateway_status.txt. One line per 
                    db in the format
                        DbName,RoleEnabled,RoleName
                  * writes a run log to dbauthgateway_status.log in FOLDER
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.DataSource.DatabaseInfo.
using OpenEdge.DataAdmin.IDataAdminService.

/* ********************  Definitions  ******************** */
define variable oDAS as IDataAdminService no-undo.
define variable oDbInfo as DatabaseInfo no-undo.
define variable cFolder as character no-undo.
define variable cRunLog as character no-undo.
define variable cEntry as character no-undo.
define variable cStatusFile as character no-undo.
define variable iLoop as integer no-undo.
define variable iMax as integer no-undo.
define variable cRoleName as character no-undo.

define stream strDump.

&scoped-define DB-OPTION-CODE _db.sts.url

/* ************************** UDFs & procedures  *************************** */
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

assign cFolder     = GetOutputFolder(cFolder)
       cRunLog     = cFolder + '/dbauthgateway_status.log':u
       cStatusFile = cFolder + '/dbauthgateway_status.txt':u.

InitLog().

PutMessage('OPERATION: STATUS':u,                                LogLevelEnum:INFO).
PutMessage(substitute('SESSION:PARAM: &1':u, session:parameter), LogLevelEnum:INFO).
PutMessage(substitute('Status file: &1', cStatusFile),           LogLevelEnum:INFO).

/* main run */
output stream strDump to value(cStatusFile).
put stream strDump unformatted 
    '#DbName,Enabled':u
    skip. 

do iLoop = 1 to num-dbs
   on error undo, throw:
    assign oDAS = new DataAdminService(ldbname(iLoop)).
    
    /* The DAS only creates an alias when we do data access,
       so we have to create it ourselves. */
    create alias 'dictdb':u for database value(oDAS:Name).
    
    assign oDbInfo = new DatabaseInfo().

    export stream strDump delimiter ',':u
        //'#DbName,Enabled':u
        oDAS:Name 
        oDbInfo:AuthenticationGatewayEnabled 
        .
    
    finally:
        delete alias 'dictdb':u.
    end finally.
end.

{OpenEdge/DataAdmin/Util/dboptionutils_eof.i
        &EXPORT-LOG=cRunLog}
/* eof */