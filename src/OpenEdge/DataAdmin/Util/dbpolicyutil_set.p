/************************************************
  Copyright (c) 2019 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : dboptionspolicy_set.p
    Purpose     : set database policy option 

    Syntax      : dbpolicyutil <type>.<policyName=value>,<type>.<policyName=value>.... db -S 7848 -U foo -P bar 

    Description : This procedure is used to set any database options using dbpolicyutil command. 
                  The command is going to support wide range of command options

    Author(s)   : mkondra
    Created     : Wed Aug 07 18:07:30 IST 2019
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

USING OpenEdge.DataAdmin.DataAdminService FROM PROPATH.
USING OpenEdge.DataAdmin.DatabaseOptionTypeEnum FROM PROPATH.
USING OpenEdge.DataAdmin.Error.DataAdminErrorHandler FROM PROPATH.
USING OpenEdge.DataAdmin.IDataAdminService FROM PROPATH.
USING OpenEdge.DataAdmin.IDatabaseOption FROM PROPATH.
USING OpenEdge.DataAdmin.IDatabaseOptionSet FROM PROPATH.
USING OpenEdge.DataAdmin.Lang.Collections.IIterator FROM PROPATH.
USING OpenEdge.Logging.LogLevelEnum FROM PROPATH.

/* ********************  Definitions  ******************** */
define variable oDAS           as IDataAdminService     no-undo.
define variable oDbOpt         as IDatabaseOption       no-undo.
define variable iMax           as integer               no-undo.
define variable iLoop          as integer               no-undo.
define variable cFolder        as character             no-undo.
define variable cRunLog        as character             no-undo.

define variable sessionParams  as character             no-undo.
define variable policyEntry    as character             no-undo.
define variable oLogLevel      as LogLevelEnum          no-undo.
define variable errorHandler   as DataAdminErrorHandler no-undo.

define variable policyValue    as character             no-undo.
define variable policyName     as character             no-undo.
define variable fRandomValue   as character             no-undo.
define variable hCurrentUser   as handle                no-undo.

/* ************************** UDFs & procedures  *************************** */
{OpenEdge/DataAdmin/Util/dboptionutils_fn.i
    &EXPORT-LOG-GROUP='DBPOLICY'
    &EXPORT-LOG=cRunLog}

/* ***************************  Main Block  *************************** */
/* extract params */
sessionParams = session:parameter.

/* check user permissions */
assign hCurrentUser = get-db-client(ldbname(1)). 

oDAS = new DataAdminService(ldbname(1)).

assign 
    iMax = num-entries (sessionParams).
do iLoop = 1 to iMax:
    assign 
        policyEntry = entry(iLoop, trim(sessionParams))
        policyValue = entry(2, policyEntry, '=':u).
        
    case entry(1, policyEntry, '=':u):
        when entry(4, dbopt_lkup[1], ':':u) then run SetDatabaseOption(policyValue, 1).            
        when entry(4, dbopt_lkup[2], ':':u) then run SetDatabaseOption(policyValue, 2).   
        when entry(4, dbopt_lkup[3], ':':u) then run SetDatabaseOption(policyValue, 3).  
        when entry(4, dbopt_lkup[4], ':':u) then run SetDatabaseOption(policyValue, 4).    
        when entry(4, dbopt_lkup[5], ':':u) then run SetDatabaseOption(policyValue, 5).        
        when entry(4, dbopt_lkup[6], ':':u) then run SetDatabaseOption(policyValue, 6).            
        when entry(4, dbopt_lkup[7], ':':u) then run SetDatabaseOption(policyValue, 7).            
        when entry(4, dbopt_lkup[8], ':':u) then run SetDatabaseOption(policyValue, 8).            
        when entry(4, dbopt_lkup[9], ':':u) then run SetDatabaseOption(policyValue, 9).         
        when 'LOG':u then 
            do:
                /* dump info to temp file*/
                fRandomValue = entry(2, policyEntry, '=':u).
                assign 
                    cRunLog = GetOutputFolder(cFolder) + '/dbpolicyutil_' + fRandomValue + '.log':u.
                    InitLog().
                if hCurrentUser:qualified-user-id eq '':u then
                do:
                    PutDirectMessage(substitute('Blank userids cannot set policy options for db &1', quoter(ldbname(1)))).
                    return.
                end.
       
                if not IsAdmin(hCurrentUser:qualified-user-id) then
                do: 
                   PutDirectMessage(substitute('Current user is not a security admin for db &1', quoter(ldbname(1)))).
                   return.
                end.
            end.
        otherwise do:
            run UsageHelp.            
            run GetAllHelp.
            run PutNewLine.
            PutDirectMessage("EXAMPLE:":u).
            PutDirectMessage("  {&SET_EXAMPLE}":u).
            return.
            end.
    end case.
end.

PROCEDURE SetDatabaseOption:
    DEFINE input PARAMETER policyValue AS character NO-UNDO.
    DEFINE input PARAMETER idx AS int NO-UNDO.    
    
    policyName = ENTRY(1, dbopt_lkup[idx],":").
    
    //safeuserid has different set of policy values.
    //handle them separately
    if (idx eq 8) then
        run MapPolicyValueForSafeUserId(input-output policyValue).   
    
    if lookup(policyValue, dbopt_vals[idx],"#") le 0 then 
    do:
        PutDirectMessage(substitute('Unable to set database policy option &1 to invalid value &2':u, quoter(policyName), quoter(policyValue))).
        return.
    end.    
    
    oDbOpt = oDAS:GetDatabaseOption(ENTRY(4, dbopt_lkup[idx],":")).

    if valid-object(oDbOpt) then 
    do:
        if oDbOpt:OptionValue ne policyValue then 
        do:       
            if (idx eq 8) then
                oDbOpt:OptionValue = policyValue.
            else oDbOpt:OptionValue = upper(policyValue). //we need uppercase value to syncup with OEM UI
            
            oDAS:UpdateDatabaseOption(oDbOpt).
            PutDirectMessage(substitute('Database policy option &1 is now set to &2':u, quoter(policyName), quoter(policyValue))).
        end.
        else PutDirectMessage(substitute('Database policy option &1 is already set to &2':u, quoter(policyName), quoter(policyValue))).
    end.  
    else 
    do:     
        oDbOpt             = oDAS:NewDatabaseOption(ENTRY(4, dbopt_lkup[idx],":")).
        oDbOpt:Description = ENTRY(2, dbopt_desc[idx],":").
        oDbOpt:OptionType  = integer(DatabaseOptionTypeEnum:GeneralSecurity).
        oDbOpt:OptionValue = policyValue.
        oDAS:CreateDatabaseOption(oDbOpt).
        
        PutDirectMessage(substitute('Database policy option &1 is created and is set to &2':u, quoter(policyName), quoter(policyValue))).
    end.  
    catch e as Progress.Lang.Error:
       PutDirectMessage(substitute("Error while setting database policy option &1: &2":u,quoter(policyName), e:GetMessage(1))).
        errorHandler = new DataAdminErrorHandler().
        errorHandler:Error(e).
    end catch.
    finally:
        if valid-object(oDbOpt) then
            delete object oDbOpt no-error.
    end finally.
    
END PROCEDURE.

/**
 * we get the policyvalue for safeuserid as preact,postact,predeact,postdeact or disabled
 * map these values to the expected value to be stored in _db-option table
 **/
PROCEDURE MapPolicyValueForSafeUserId:
    define input-output parameter policValue as char no-undo.
    
    case policValue:
        when "preact":u then policValue = "ENABLED:preact":u.            
        when "postact":u then policValue = "ENABLED:postact":u.   
        when "predeact":u then policValue = "ENABLED:predeact":u.  
        when "postdeact":u then policValue = "ENABLED:postdeact":u. 
        when "disabled":u then policValue = "DISABLED":u. 
    end case.                
END PROCEDURE.

if valid-object(oDAS) then
    delete object oDAS no-error.

catch e as Progress.Lang.Error:
    if valid-object(oDAS) then
        delete object oDAS no-error.
        
    PutDirectMessage("Error while setting database policy option: ":u + e:GetMessage(1)).
    errorHandler = new DataAdminErrorHandler().
    errorHandler:Error(e).
end catch.

/* eof */
