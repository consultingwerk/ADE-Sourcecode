/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : dbconnectionrole_enable.p
    Purpose     : Enables the Db connection role feature 
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
                    GRANTEE     : (optional) a qualified user-id for whom to revoke a grant.
                                  if not provided, the current db user will be used.
                  * A grant will be created with can-grant rights for the GRANTEE or the current user                                  
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
using OpenEdge.DataAdmin.IGrantedRoleSet.
using OpenEdge.DataAdmin.Lang.Collections.IIterator.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.

/* ********************  Definitions  ******************** */
define variable oDAS as IDataAdminService no-undo.
define variable cDB as character no-undo.
define variable cRoleName as character no-undo.
define variable oDbOpt as IDatabaseOption no-undo.
define variable oRole as IRole no-undo.
define variable oGrant as IGrantedRole no-undo.
define variable oGrants as IGrantedRoleSet no-undo.
define variable iMax as integer no-undo.
define variable iLoop as integer no-undo.
define variable hCurrentUser as handle no-undo.
define variable cFolder as character no-undo.
define variable cRunLog as character no-undo.
define variable cEntry as character no-undo.
define variable cUid as character no-undo.
define variable cGrantee as character no-undo.

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
        when 'GRANTEE':u then                   
            assign cGrantee = entry(2, cEntry, ':':u)
                   no-error.
    end case.
end.

/* ROLE NAME */
if cRoleName eq ? or cRoleName eq '':u then
    assign cRoleName = '{&CONN-AUTH-ROLE}':u.
     
/* dump info */
assign cRunLog = GetOutputFolder(cFolder) + '/dbconnectionrole_enable.log':u.
InitLog().

PutMessage('OPERATION: ENABLE':u,                                LogLevelEnum:INFO).
PutMessage(substitute('SESSION:PARAM: &1':u, session:parameter), LogLevelEnum:INFO).
PutMessage(substitute('Role name: &1', cRoleName),               LogLevelEnum:INFO).
PutMessage(substitute('Grantee: &1', cGrantee),                  LogLevelEnum:INFO).

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
           
    if valid-object(oDbOpt) and oDbOpt:OptionValue ne ? then
    do:
        PutMessage(substitute('Connection authorization already enabled for &1', 
                        quoter(oDAS:Name)),   
                   LogLevelEnum:INFO).
        /* futures */
        if cRoleName ne oDbOpt:OptionValue then
            PutMessage(substitute('Connection authorization role is &1; the &2 role was passed in', 
                            quoter(oDbOpt:OptionValue),
                            quoter(cRoleName)),   
                       LogLevelEnum:WARN).
        next.
    end.
    
    /* Make sure there's a role */
    oRole = oDAS:GetRole(cRoleName).
    if not valid-object(oRole) then
    do:
        assign oRole = oDAS:NewRole(cRoleName).
        oDAS:CreateRole(oRole).
    end.
    
    /* assign the grantee */
    if cGrantee eq '':u or cGrantee eq ? then
        assign cUid = substitute('&1@&2':u, hCurrentUser:user-id, hCurrentUser:domain-name).
    else
        assign cUid = cGrantee. 
    
    oGrants = oDAS:GetGrantedRoles(substitute('where RoleName eq &1 and Grantee eq &2':u,
                                              quoter(cRoleName),
                                              quoter(cUid))).
    if oGrants:IsEmpty then
    do:                
        assign oGrant = oDAS:NewGrantedRole()
               oGrant:Role     = oRole
               oGrant:Grantee  = cUid
               /* MUST have a can-grant user */
               oGrant:CanGrant = true.
        oDAS:CreateGrantedRole(oGrant).
    end.
    
    /* no option? create it now */
    if not valid-object(oDbOpt) then
    do:
        assign oDbOpt             = oDAS:NewDatabaseOption('{&DB-OPTION-CODE}':u)
               oDbOpt:Description = 'Defines if role-based authorization is performed and which type'
               oDbOpt:OptionType  = integer(DatabaseOptionTypeEnum:AuthenticationGateway)
               oDbOpt:OptionValue = '':u.
        oDAS:CreateDatabaseOption(oDbOpt).
    end.
    else
    do:
        assign oDbOpt:OptionValue = '':u.
        oDAS:UpdateDatabaseOption(oDbOpt).
    end.
    
    PutMessage(substitute('Connection authorization now enabled for &1', 
                        quoter(oDAS:Name)),
                   LogLevelEnum:INFO).
end.

{OpenEdge/DataAdmin/Util/dbconnectionrole_eof.i
        &EXPORT-LOG=cRunLog}

/* eof */
