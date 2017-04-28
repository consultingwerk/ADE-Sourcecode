/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : dbconnectionrole_grant.p
    Purpose     : Grants connection auth for one or more users
    Author(s)   : pjudge 
    Created     : 2016-05-04
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
                    GRANTEE     : (optional) a qualified user-id for whom to revoke a grant.
                                  if not provided, the current db user will be used.
                    CAN-GRANT   : (optional) does the GRANTEE have can-grant rights?     
                    GRANT-FILE  : an extant filename containing qualified user-ids
                                  for grant. The format of the file is
                                  - One user-id per line, with comma-delimited values
                                  - the first field is the user-id
                                  - the second field is the can-grant value
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.IDatabaseOption .
using OpenEdge.DataAdmin.IRole.
using OpenEdge.DataAdmin.IGrantedRole.
 using OpenEdge.DataAdmin.IGrantedRoleSet.
using OpenEdge.DataAdmin.IDataAdminService.

/* ********************  Preprocessor Definitions  ******************** */
define variable oDAS as IDataAdminService no-undo.
define variable cRoleName as character no-undo.
define variable oDbOpt as IDatabaseOption no-undo.
define variable oRole as IRole no-undo.
define variable oGrant as IGrantedRole no-undo.
define variable oGrants as IGrantedRoleSet no-undo.
define variable iMax as integer no-undo.
define variable iLoop as integer no-undo.
define variable hCurrentUser as handle no-undo.
define variable cFolder as character no-undo.
define variable cUid as character no-undo.
define variable cRunLog as character no-undo.
define variable cEntry as character no-undo.
define variable lCanGrant as logical no-undo.
define variable cGrantFile as character no-undo.

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
        when 'GRANTEE':u then
            assign cUid = entry(2, cEntry, ':':u)
                   no-error.
        when 'CAN-GRANT':u then
            assign lCanGrant = logical(entry(2, cEntry, ':':u))
                   no-error.       
        when 'GRANT-FILE':u then
            assign cGrantFile = substring(cEntry, 12)
                   no-error.
    end case.
end.

/* CAN GRANT? */
if lCanGrant eq ? then
    assign lCanGrant = false.
    
/* FILE NAME */
assign cRunLog = GetOutputFolder(cFolder) + '/dbconnectionrole_grant.log':u.
InitLog().

PutMessage('OPERATION: GRANT':u,                                    LogLevelEnum:INFO).
PutMessage(substitute('SESSION:PARAM: &1':u, session:parameter),    LogLevelEnum:INFO).

if cUid ne ? and cUid ne '':u then
do:
    PutMessage(substitute('Grantee: &1', cUid),        LogLevelEnum:INFO).
    PutMessage(substitute('Can-grant? &1', lCanGrant),  LogLevelEnum:INFO).
    
    create UserGrant.
    assign UserGrant.Grantee  = cUid
           UserGrant.CanGrant = lCanGrant.
end.

if cGrantFile ne ? and cGrantFile ne '':u then
do:
    PutMessage(substitute('Grant file: &1', cGrantFile),    LogLevelEnum:INFO).
    assign file-info:file-name = cGrantFile.
    if file-info:full-pathname eq ? then
        PutMessage(substitute('Unable to find grant-file: &1', cGrantFile),        
                   LogLevelEnum:ERROR).
    else
    do:    
        input from value(file-info:full-pathname).
        repeat:
            assign cUid = '':u. 
            import delimiter ',':u
                cUid
                lCanGrant
                .
            if not(cUid eq '':u or cUid begins '#':u) then
            do:
                create UserGrant.
                assign UserGrant.Grantee  = cUid                
                       UserGrant.CanGrant = lCanGrant.
            end.
        end.
        input close.
    end.
end.

/* main run */
do iLoop = 1 to num-dbs:
    assign hCurrentUser = get-db-client(ldbname(iLoop)).
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
        PutMessage(substitute('Connection authorization disabled for db &1. Continuing with grant.', 
                        quoter(oDAS:Name)),   
                   LogLevelEnum:INFO).
    
    if valid-object(oDbOpt) then
        assign cRoleName = oDbOpt:OptionValue.
    if cRoleName eq '':u or cRoleName eq ? then
        assign cRoleName = '{&CONN-AUTH-ROLE}':u.

    /* Make sure there's a role */
    assign oRole = oDAS:GetRole(cRoleName).
    if not valid-object(oRole) then
    do:
        assign oRole = oDAS:NewRole(cRoleName).
        oDAS:CreateRole(oRole).
    end.
    
    for each UserGrant:
        assign oGrants = oDAS:GetGrantedRoles(substitute('where RoleName eq &1 and Grantee eq &2 ',
                                                  quoter(cRoleName),
                                                  quoter(UserGrant.Grantee))).
        if not oGrants:IsEmpty then
        do: 
            PutMessage(substitute('Connection authorization already exists for user &1 on db &2', 
                                quoter(UserGrant.Grantee),
                                quoter(oDAS:Name)),
                           LogLevelEnum:INFO).
            next.
        end.

        assign oGrant          = oDAS:NewGrantedRole()
               oGrant:Role     = oRole
               oGrant:Grantee  = UserGrant.Grantee
               oGrant:CanGrant = UserGrant.CanGrant.
        oDAS:CreateGrantedRole(oGrant).
                
        PutMessage(substitute('Connection authorization now granted for user &1 on db &2', 
                            quoter(UserGrant.Grantee),
                            quoter(oDAS:Name)),
                       LogLevelEnum:INFO).
        catch oError as Progress.Lang.Error:
            PutMessage(substitute('Caught Progress.Lang.Error: &1', oError:GetMessage(1)),
                       OpenEdge.Logging.LogLevelEnum:ERROR).
            next.
        end catch.
    end.
end.

{OpenEdge/DataAdmin/Util/dbconnectionrole_eof.i
        &EXPORT-LOG=cRunLog}
/* eof */
