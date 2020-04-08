/************************************************
  Copyright (c) 2019 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : dbpolicyutil_status.p
    Purpose     : This procedure queries the the _db-options table to find the policies it is set to

    Syntax      :

    Description : 

    Author(s)   : mkondra
    Created     : Mon Aug 26 13:51:58 IST 2019
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

USING OpenEdge.DataAdmin.DataAdminService FROM PROPATH.
USING OpenEdge.DataAdmin.Error.DataAdminErrorHandler FROM PROPATH.
USING OpenEdge.DataAdmin.IDataAdminService FROM PROPATH.
USING OpenEdge.DataAdmin.IDatabaseOption FROM PROPATH.
USING OpenEdge.DataAdmin.IDatabaseOptionSet FROM PROPATH.
USING OpenEdge.DataAdmin.Lang.Collections.IIterator FROM PROPATH.
USING OpenEdge.Logging.LogLevelEnum FROM PROPATH.

/* ********************  Definitions  ******************** */
define variable oDAS          as IDataAdminService     no-undo.
define variable oDbOpt        as IDatabaseOption       no-undo.
define variable oDbOpts       as IDatabaseOptionSet    no-undo.
define variable iMax          as integer               no-undo.
define variable iLoop         as integer               no-undo.
define variable cFolder       as character             no-undo.
define variable cRunLog       as character             no-undo.

define variable sessionParams as character             no-undo.
define variable policyEntry   as character             no-undo.
define variable oLogLevel     as LogLevelEnum          no-undo.
define variable errorHandler  as DataAdminErrorHandler no-undo.

define variable queryString   as longchar              no-undo.
define variable typeValue     as character             no-undo.
define variable policyMatch   as character             no-undo.
DEFINE VARIABLE policyIter    AS IIterator             NO-UNDO.
define variable isTypeAll     as logical               no-undo.
define variable policyValue    as character             no-undo.
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
        .   
    case entry(1, policyEntry, "=":u):
        when entry(4, dbopt_lkup[1], ':':u) then queryString = queryString + " or Code = ":u + quoter(ENTRY(4, dbopt_lkup[1],":")).            
        when entry(4, dbopt_lkup[2], ':':u) then queryString = queryString + " or Code = ":u + quoter(ENTRY(4, dbopt_lkup[2],":")).  
        when entry(4, dbopt_lkup[3], ':':u) then queryString = queryString + " or Code = ":u + quoter(ENTRY(4, dbopt_lkup[3],":")).
        when entry(4, dbopt_lkup[4], ':':u) then queryString = queryString + " or Code = ":u + quoter(ENTRY(4, dbopt_lkup[4],":")).
        when entry(4, dbopt_lkup[5], ':':u) then queryString = queryString + " or Code = ":u + quoter(ENTRY(4, dbopt_lkup[5],":")).
        when entry(4, dbopt_lkup[6], ':':u) then queryString = queryString + " or Code = ":u + quoter(ENTRY(4, dbopt_lkup[6],":")).
        when entry(4, dbopt_lkup[7], ':':u) then queryString = queryString + " or Code = ":u + quoter(ENTRY(4, dbopt_lkup[7],":")).
        when entry(4, dbopt_lkup[8], ':':u) then queryString = queryString + " or Code = ":u + quoter(ENTRY(4, dbopt_lkup[8],":")).
        when entry(4, dbopt_lkup[9], ':':u) then queryString = queryString + " or Code = ":u + quoter(ENTRY(4, dbopt_lkup[9],":")).
        when 'type':u then 
            do:
                typeValue = entry(2, policyEntry, '=':u). 
                if typeValue eq "all":u then 
                    isTypeAll = true.
                else do:    
                    run GetPolicyMatchForType(input typeValue, output policyMatch).
                    queryString = queryString + " or Code matches ":u + quoter(policyMatch).
                end.                
                //run GetPolicyListForType(entry(2, policyEntry, '=':u)).
            end.
        when 'LOG':u then 
            do:
                /* dump info to temp file*/
                fRandomValue = entry(2, policyEntry, '=':u).
                assign 
                    cRunLog = GetOutputFolder(cFolder) + '/dbpolicyutil_' + fRandomValue + '.log':u.
                    InitLog().
                if hCurrentUser:qualified-user-id eq '':u then
                do:
                    PutDirectMessage(substitute('Blank userids cannot query policy options for db &1', quoter(ldbname(1)))).
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
             PutDirectMessage("  {&QUERY_EXAMPLE}":u).
             return.
            end.
    end case.    
end.

queryString = trim(queryString, " or ":u).
run GetDatabaseOption.

/**
    Based on the policy type find the appropriate query match
**/
PROCEDURE GetPolicyMatchForType:
    DEFINE input PARAMETER typeValue AS character NO-UNDO.
    DEFINE output PARAMETER policyMatch AS character NO-UNDO.
    
    case typeValue:
        when 'AVM':u then policyMatch =  "_pvm.*":u.
             
        when 'SQL':u then policyMatch = "_sql.*":u.
            
        when 'DB':u then policyMatch = "_db.*":u.
                      
        when 'STS':u then policyMatch = "_sts.*":u.
    end case.    
END PROCEDURE.

/**
    call to get the database policies
**/
PROCEDURE GetDatabaseOption:    
    if isTypeAll then
        oDbOpts = oDAS:GetDatabaseOptions().
    else oDbOpts = oDAS:GetDatabaseOptions(string(queryString)).
    
    if valid-object(oDbOpts) then
    do:    
        policyIter = oDbOpts:Iterator().
        do while policyIter:HasNext():
            oDbOpt = cast(policyIter:next(),IDatabaseOption).
            do iloop = 1 to extent(dbopt_lkup) :
                if lookup(oDbOpt:Code, dbopt_lkup[iloop],":") gt 0 then 
                do:
                    PutDirectMessage(substitute('&1=&2',entry(2, dbopt_lkup[iloop], ':':u) + "." + entry(1, dbopt_lkup[iloop], ':':u),oDbOpt:OptionValue)).
                    leave.
                end. 
            end.
        end.         
    end.
    else do:
        PutMessageNoTimeStamp('No database policy found for given query':u,LogLevelEnum:WARN).
    end.  
    catch e1 as Progress.Lang.Error:
       PutMessageNoTimeStamp(substitute("Error while finding the database policy option: &1":u,e1:GetMessage(1)),LogLevelEnum:ERROR).
        errorHandler = new DataAdminErrorHandler().
        errorHandler:Error(e1).
    end catch.
    finally:
        if valid-object(oDbOpt) then
            delete object oDbOpt no-error.
    end finally.
    
END PROCEDURE.

if valid-object(oDAS) then
    delete object oDAS no-error.

catch e2 as Progress.Lang.Error:
    PutMessageNoTimeStamp(substitute("Error while finding the database policy option: &1":u,e2:GetMessage(1)),LogLevelEnum:ERROR).
    errorHandler = new DataAdminErrorHandler().
    errorHandler:Error(e2).
    
    if valid-object(oDAS) then
        delete object oDAS no-error.
end catch.
