/************************************************
  Copyright (c) 2019 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : dbpolicyutil_help.p
    Purpose     : help to get the 

    Syntax      :

    Description : 

    Author(s)   : mkondra
    Created     : Mon Aug 26 13:51:58 IST 2019
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

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



assign 
    iMax = num-entries (sessionParams).
do iLoop = 1 to iMax:
    assign 
        policyEntry = entry(iLoop, trim(sessionParams))
        .   
        //message policyEntry view-as alert-box.
    case entry(1, policyEntry, "=":u):
        when entry(4, dbopt_lkup[1], ':':u) then run PolicyOptionHelp(1).        
        when entry(4, dbopt_lkup[2], ':':u) then run PolicyOptionHelp(2).  
        when entry(4, dbopt_lkup[3], ':':u) then run PolicyOptionHelp(3).
        when entry(4, dbopt_lkup[4], ':':u) then run PolicyOptionHelp(4).
        when entry(4, dbopt_lkup[5], ':':u) then run PolicyOptionHelp(5).
        when entry(4, dbopt_lkup[6], ':':u) then run PolicyOptionHelp(6).
        when entry(4, dbopt_lkup[7], ':':u) then run PolicyOptionHelp(7).
        when entry(4, dbopt_lkup[8], ':':u) then run PolicyOptionHelp(8).
        when entry(4, dbopt_lkup[9], ':':u) then run PolicyOptionHelp(9).
        when 'type':u then 
            do:
                typeValue = entry(2, policyEntry, '=':u). 
                run PolicyTypeHelp(typeValue).                 
            end.
            
        when 'set':u then 
            do:
                run UsageHelp.   
                IsExampleUsed = true.
                run GetSetHelp.   
                run PutNewLine.
                PutDirectMessage("EXAMPLE:":u).                
                PutDirectMessage("  {&SET_EXAMPLE}":u).             
            end.
        when 'query':u then 
            do:
                run UsageHelp.             
                IsExampleUsed = true. 
                run GetQueryHelp.  
                run PutNewLine.            
                PutDirectMessage("EXAMPLE:":u). 
                PutDirectMessage("  {&QUERY_EXAMPLE}":u).
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
                    PutDirectMessage(substitute('Blank userids cannot get policy options help for db &1':u, quoter(ldbname(1)))).
                    return.
                end.
       
                if not IsAdmin(hCurrentUser:qualified-user-id) then
                do: 
                    PutDirectMessage(substitute('Current user is not a security admin for db &1':u, quoter(ldbname(1)))).
                    return.
                end.
            end.
         otherwise do:
             run UsageHelp.             
             run GetAllHelp.
             run PutNewLine.
             PutDirectMessage("EXAMPLES:":u).
             PutDirectMessage("  {&SET_EXAMPLE}":u).
             PutDirectMessage("  {&QUERY_EXAMPLE}":u). 
            end.
    end case.    
end.

catch e as Progress.Lang.Error:
    PutDirectMessage(substitute("Error while finding the database policy option: &1":u,e:GetMessage(1))).
    errorHandler = new DataAdminErrorHandler().
    errorHandler:Error(e).
end catch.
