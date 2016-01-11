/* Copyright (C) 2006 Progress Software Corporation.  All Rights Reserved. */
/*------------------------------------------------------------------------
    File        : afdmpdatap.p
    Purpose     : Dumps definitions for a database

    Author(s)   : pjudge
    Created     : 8/3/2006
    Notes       : Created from scratch
  ----------------------------------------------------------------------*/
define input parameter pcDbName            as character            no-undo.
define input parameter pcTables            as character            no-undo.
define input parameter pcOutputdir         as character            no-undo.
define input parameter pcLobDir            as character            no-undo.
define input parameter pcCharacterMapping  as character            no-undo.
define input parameter pcCodePage          as character            no-undo.

define variable cDummy                   as character no-undo.
define variable hDeploymentHelper        as handle no-undo.
define variable iErrorNum                as integer no-undo.
define variable hDumpProc                as handle no-undo.

/* Log levels: Used as a parameter into logMessage(). */
{af/app/afloglevel.i}
&scoped-define LOG-CATEGORY DumpData

run startProcedure in target-procedure ("ONCE|af/app/afdeplyhlp.p":U, output hDeploymentHelper).
if not valid-handle(hDeploymentHelper) then
    return error 'Unable to start Deployment Helper procedure (af/app/afdeplyhlp.p)'.

/* make sure we have a source and target db */
if pcDbName eq ? or pcDbName eq '':u or
   not connected(pcDbName) then
    return error {aferrortxt.i 'AF' '5' '?' '?' '"source DB"'}.

/* make sure we have a name for the df */
if pcOutputdir eq '':u or pcOutputdir eq ? then
do:
    pcOutputdir = session:temp-directory.
    publish 'ICFDA_logMessage':U ({&LOG-LEVEL-MESSAGE}, '{&LOG-CATEGORY}':u,
                    'Setting output directory to ' + pcOutputdir).
end.    /* filename not good */

iErrorNum = dynamic-function('prepareDirectory':u in hDeploymentHelper,
                              pcOutputdir,
                              No,     /* clear contents? */
                              Yes     /* create if missing */ ).
if iErrorNum gt 0 then
    return error {aferrortxt.i 'AF' '40' '?' '?' "'Unable to write to directory ' + pcOutputdir"}.

if pcLobDir ne ? and pcLobDir ne '':u then
do:
    iErrorNum = dynamic-function('prepareDirectory':u in hDeploymentHelper,
                                  pcLobDir,
                                  No,     /* clear contents? */
                                  Yes     /* create if missing */ ).
    if iErrorNum gt 0 then
        return error {aferrortxt.i 'AF' '40' '?' '?' "'Unable to write to directory ' + pcLobDir"}.
end.    /* a lobdir was specified */

/* check encoding */
if pcCodePage ne '':u then
do:
    cDummy = codepage-convert('x':u, session:cpstream, pcCodePage) no-error.
    if error-status:error or error-status:num-messages gt 0 then
    do:
        publish 'ICFDA_logMessage':U ({&LOG-LEVEL-MESSAGE}, '{&LOG-CATEGORY}':u,
                            'Unable to find code page ' + pcCodePage + '. Setting to session default.').
        pcCodePage = '':u.
    end.
end.    /* code page <> '' */

/* Blank defaults to the session encoding. */
if pcCodePage eq '':u then
    pcCodePage = session:cpstream.
        
/* Make sure we have a Tables entry */
if pcTables eq ? or pcTables eq '':u then
    pcTables = 'All':u.

/* Set DICTDB alias for DB */
delete alias 'DICTDB':u.
create alias 'DICTDB':u for database value(pcDbName).
    
/* Running dump_d persistently makes it act more 'objectly', allowing us to 
   set any additional parameters before making the dump */
run prodict/dump_d.p persistent set hDumpProc ( pcTables, pcOutputDir, pcCodePage ).

/* Set values for the dump. We could also set pcTables, pcOutputDir 
   and pcCodePage here, but they're already passed in to the API. */
run setMap in hDumpProc (pcCharacterMapping).
run setLobDir in hDumpProc (pcLobDir).

/* Dump the data */
run doDump in hDumpProc.

/* Clean up */
delete procedure hDumpProc no-error.
hDumpProc = ?.

error-status:error = no.
return.
/* - E - O - F - */