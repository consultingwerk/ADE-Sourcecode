/* Copyright (C) 2006 Progress Software Corporation.  All Rights Reserved. */
/*------------------------------------------------------------------------
    File        : afdmpseqvp.p
    Purpose     : Dumps sequence values for a database

    Author(s)   : pjudge
    Created     : 8/1/2006
    Notes       : Created from scratch
  ----------------------------------------------------------------------*/
define input parameter pcDbName        as character            no-undo.
define input parameter pcFileName      as character            no-undo.
define input parameter pcCodePage      as character            no-undo.

define variable hDeploymentHelper        as handle            no-undo.
define variable cDummy                   as character         no-undo.
define variable iErrorNum                as integer no-undo.

/* Dictionary stuff */
/* The following is taken from { prodict/user/uservar.i "NEW"}, since we can't
   include Prodict directly in Dynamics. */
define new shared variable user_env as character extent 35 no-undo.
define new shared variable user_dbname as character no-undo.
define new shared stream logfile.

/* The following is taken from { prodict/dictvar.i "NEW"}, since we can't
   include Prodict directly in Dynamics. */
define new shared variable drec_db as recid initial ? no-undo.
define new shared temp-table tt_cache_file no-undo
    field nPos        as integer
    field cName       as character
    field p_flag      as logical
    index nPos is unique primary nPos
    index cName cName.
/* End Dictionary stuff */

/* Log levels: Used as a parameter into logMessage(). */
{af/app/afloglevel.i}
&scoped-define LOG-CATEGORY DumpSeqValue

run startProcedure in target-procedure ("ONCE|af/app/afdeplyhlp.p":U, output hDeploymentHelper).
if not valid-handle(hDeploymentHelper) then
    return error 'Unable to start Deployment Helper procedure (af/app/afdeplyhlp.p)'.

/* make sure we have a name for the df */
if pcFileName eq '':u or pcFileName eq ? then
do:
    pcFileName = session:temp-dir + '/_seqval.d':u.
    publish 'ICFDA_logMessage':U ({&LOG-LEVEL-MESSAGE}, '{&LOG-CATEGORY}':u,
                'Setting .D filename to ' + pcFileName).
end.    /* set filename to a default */

/* prepare and create the directory, if missing */
cDummy = replace(pcFileName, '~\':u, '/':u).
entry(num-entries(cDummy, '/':u), cDummy, '/':u) = '':u.
cDummy = right-trim(cDummy, '/':u).

if cDummy eq ? or cDummy eq '':u then
    cDummy = '.':u.

iErrorNum = dynamic-function('prepareDirectory':u in hDeploymentHelper,
                              cDummy,
                              No,     /* clear contents? */
                              Yes     /* create if missing */ ).
if iErrorNum gt 0 then
    return error {aferrortxt.i 'AF' '40' '?' '?' "'Unable to write to directory ' + cDummy"}.

/* make sure we have a source and target db */
if pcDbName eq ? or pcDbName eq '':u or
   not connected(pcDbName) then
    return error {aferrortxt.i 'AF' '5' '?' '?' '"source DB"'}.

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

/* Set DICTDB alias for DB */
delete alias 'DICTDB':u.
create alias 'DICTDB':u for database value(pcDbName).
    
/* This starts a new instance, so we don't have to worry about killing any running
   instances in order to get the right DICTDB. */
run startProcedure in target-procedure ("ONCE|af/app/afdeplyhlp.p":U, output hDeploymentHelper).
if not valid-handle(hDeploymentHelper) then
    return error {aferrortxt.i 'AF' '15' '?' '?' '"the Deployment Helper procedure could not be started"' "return-value"}.

/* setup shared variables for Prodict */
drec_db = {fn getDictdbRecid hDeploymentHelper}.
user_dbname = pcDbName.
user_env[2] = pcFilename.
user_env[5] = pcCodePage.
user_env[6] = 'no-alert-boxes':u.

run prodict/dump/_dmpseqs.p.

error-status:error = no.
return.
/* - E - O - F - */