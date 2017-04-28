/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : dbconnectionrole_revoke.p
    Purpose     : Revokes connection auth for one or more users
    Author(s)   : pjudge 
    Created     : 2016-05-04
    Notes       : * This utility operates against all currently-connected DBs
                  * Behaviour can be tweaked using the -param switch, with
                    values formatted in comma- and colon-delimited pairs
                    <name-1>:<value-1>,<name-2>:<value-2> ...
                  * Supported options
                    FOLDER      : (optional) an extant folder name for writing logs
                                  If not provided, we use the first
                                  extant folder:
                                    - WRKDIR env var
                                    - '.' (current dir)
                                    - session temp-dir (-T) 
                    REVOKEE     : (optional) a qualified user-id for whom to revoke a grant
                    REVOKE-FILE : (optional) an extant filename containing qualified user-ids
                                  for revocation. The format of the file is
                                  - One user-id per line, with comma-delimited values
                                  - the first field is the user-id
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.DatabaseOptionTypeEnum.
using OpenEdge.DataAdmin.IDataAdminService.
using OpenEdge.DataAdmin.IDatabaseOption.
using OpenEdge.DataAdmin.IRole.
using OpenEdge.DataAdmin.IGrantedRole.
using OpenEdge.DataAdmin.IGrantedRoleSet.
using OpenEdge.DataAdmin.Lang.Collections.IIterator.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using OpenEdge.Core.Assert.

/* ********************  Preprocessor Definitions  ******************** */
define variable oDAS as IDataAdminService no-undo.
define variable cRoleName as character no-undo.
define variable oDbOpt as IDatabaseOption no-undo.
define variable oGrant  as IGrantedRole no-undo.
define variable oGrants as IGrantedRoleSet no-undo.
define variable iMax as integer no-undo.
define variable iLoop as integer no-undo.
define variable hCurrentUser as handle no-undo.
define variable cFolder as character no-undo.
define variable cUid as character no-undo.
define variable cRunLog as character no-undo.
define variable cEntry as character no-undo.
define variable oIterator as IIterator no-undo.
define variable cRevokeFile as character no-undo.

/* ************************** UDFs & procedures  *************************** */
{OpenEdge/DataAdmin/Util/dbconnectionrole_fn.i
        &EXPORT-LOG=cRunLog}

/* ***************************  Main Block  *************************** */
/* extract params */
assign iMax = num-entries (session:parameter)
       cUid = ?.
do iLoop = 1 to iMax:
    assign cEntry = entry(iLoop, session:parameter).
    
    case entry(1, cEntry, ':':u):
        when 'FOLDER':u then
            /* the folder may have a : in it so don't use ENTRY() */
            assign cFolder = substring(cEntry, 8)
                   no-error.
        when 'REVOKEE':u then                   
            assign cUid = entry(2, cEntry, ':':u)
                   no-error.
        when 'REVOKE-FILE':u then
            assign cRevokeFile = substring(cEntry, 13)
                   no-error.
    end case.
end.


/* FILE NAME */
/* dump info */
assign cRunLog = GetOutputFolder(cFolder) + '/dbconnectionrole_revoke.log':u.
InitLog().
PutMessage('OPERATION: REVOKE':u,                                   LogLevelEnum:INFO).
PutMessage(substitute('SESSION:PARAM: &1':u, session:parameter),    LogLevelEnum:INFO).

if cUid ne ? and cUid ne '':u then
do:
    PutMessage(substitute('Grantee: &1', cUid), LogLevelEnum:INFO).
    
    create UserGrant.
    assign UserGrant.Grantee = cUid.
end.

if cRevokeFile ne ? and cRevokeFile ne '':u then
do:
    PutMessage(substitute('Revoke file: &1', cRevokeFile),    LogLevelEnum:INFO).
    assign file-info:file-name = cRevokeFile.
    if file-info:full-pathname eq ? then
        PutMessage(substitute('Unable to find revoke-file: &1', cRevokeFile),        
                   LogLevelEnum:ERROR).
    else
    do:    
        input from value(file-info:full-pathname).
        repeat:
            assign cUid = '':u.
            import cUid.
            
            if not(cUid eq '':u or cUid begins '#':u) then
            do:
                create UserGrant.
                assign UserGrant.Grantee  = cUid.                
            end.
        end.    
        input close.
    end.
end.

/* main run */
do iLoop = 1 to num-dbs:
    assign hCurrentUser = get-db-client(ldbname(iLoop))
           cRoleName    = '':u.
    if hCurrentUser:qualified-user-id eq '':u then
    do:
        PutMessage(substitute('Blank userids cannot be role grantors for db &1', 
                        quoter(ldbname(iLoop))),
                   LogLevelEnum:ERROR).
        next.
    end.
               
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
        PutMessage(substitute('Connection authorization disabled for db &1.', 
                        quoter(oDAS:Name)),
                   LogLevelEnum:INFO).
    
    if valid-object(oDbOpt) then
        assign cRoleName = oDbOpt:OptionValue.
    if cRoleName eq '':u or cRoleName eq ? then
        assign cRoleName = '{&CONN-AUTH-ROLE}':u.

    /* Get the grants for this user, role */
    for each UserGrant:
        assign oGrants = oDAS:GetGrantedRoles(substitute('where RoleName eq &1 and Grantee eq &2',
                                                  quoter(cRoleName),
                                                  quoter(UserGrant.Grantee))).
        if oGrants:IsEmpty then
        do:
            PutMessage(substitute('No grants found for user &3 role &2 in db &1',
                        quoter(oDAS:Name),
                        quoter(cRoleName),
                        quoter(UserGrant.Grantee)),
                      LogLevelEnum:INFO).
            next.
        end.
    
        assign oIterator = oGrants:Iterator().
        do while oIterator:HasNext():
            assign oGrant = cast(oIterator:Next(), IGrantedRole).        
            oDAS:DeleteGrantedRole(oGrant:Id).
        end.
        
        PutMessage(substitute('Connection authorization now revoked for user &1 role &3 on db &2', 
                            quoter(UserGrant.Grantee),
                            quoter(oDAS:Name),
                            quoter(cRoleName)),
                       LogLevelEnum:INFO).
    end.
end.

{OpenEdge/DataAdmin/Util/dbconnectionrole_eof.i
        &EXPORT-LOG=cRunLog}
/* eof */
