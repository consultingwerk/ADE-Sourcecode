/* Copyright (C) 2006 Progress Software Corporation.  All Rights Reserved. */
/*------------------------------------------------------------------------
    File        : afdumpincp.p
    Purpose     : 

    Syntax      :

    Description : Dump Incremental Defs (delta dump)

    Author(s)   : pjudge
    Created     : 7/31/2006
    Notes       : Content taken from prodict/dump_inc.p
  ----------------------------------------------------------------------*/
/*          This .p file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
define input parameter pcSourceDB        as character                no-undo.
define input parameter pcTargetDB        as character                no-undo.
define input parameter pcDfFilename      as character                no-undo.
define input parameter pcEncoding        as character                no-undo.
define input parameter pcIndexMode       as character                no-undo.
define input parameter pcRenameFile      as character                no-undo.

/* Dictionary stuff */
/* The following is taken from { prodict/user/uservar.i "NEW"}, since we can't
   Prodict directly in Dynamics. */
define new shared variable user_env as character extent 35 no-undo.
define new shared variable user_dbname as character no-undo.

/* The following is taken from { prodict/dictvar.i "NEW"}, since we can't
   Prodict directly in Dynamics. */
define new shared variable drec_db as recid initial ? no-undo.
/* End Dictionary stuff */

define variable cDummy                as character                    no-undo.
define variable hDeploymentHelper     as handle                       no-undo.

/* Log levels: Used as a parameter into logMessage(). */
{af/app/afloglevel.i}
&scoped-define LOG-CATEGORY BuildLibrary

/* ***************************  Main Block  *************************** */
/* make sure we have a name for the df */
if pcDfFilename eq '':u or pcDfFilename eq ? then
do:
    pcDfFilename = session:temp-dir + '/delta.df':u.
    publish 'ICFDA_logMessage':U ({&LOG-LEVEL-MESSAGE}, '{&LOG-CATEGORY}':u,
                'Setting DF filename to ' + pcDfFilename).
end.    /* check filename */

/* make sure we have a source and target db */
if pcSourceDb eq ? or pcSourceDb eq '':u or
   not connected(pcSourceDb) then
    return error {aferrortxt.i 'AF' '5' '?' '?' '"source DB"'}.

if pcTargetDb eq ? or pcTargetDb eq '':u or
   not connected(pcTargetDb) then
    return error {aferrortxt.i 'AF' '5' '?' '?' '"target DB"'}.
    
/* make sure we have the index mode set correctly */
if pcIndexMode eq ? or pcIndexMode eq '':u or
   not can-do('Inactive,Active':u, pcIndexMode) then
    pcIndexMode = 'Inactive':u.
        
/* test, if `rename-file' exists */
if pcRenameFile gt '':u then
do:
    file-information:file-name = pcRenameFile.
    if not file-information:file-type matches '*R*':u then
    do:
        publish 'ICFDA_logMessage':U ({&LOG-LEVEL-MESSAGE}, '{&LOG-CATEGORY}':u,
                            'Unable to find rename file (' + pcRenameFile + '). Setting to blank.').
        pcRenameFile = '':u.
    end.            
end.    /* test that rename file exists */
        
/* check encoding */
if pcEncoding ne '':u then
do:
    cDummy = codepage-convert('x':u, session:cpstream, pcEncoding) no-error.
    if error-status:error or error-status:num-messages gt 0 then
    do:
        publish 'ICFDA_logMessage':U ({&LOG-LEVEL-MESSAGE}, '{&LOG-CATEGORY}':u,
                            'Unable to find code page ' + pcEncoding + '. Setting to session default.').
        pcEncoding = '':u.
    end.
end.    /* code page <> '' */

/* Blank defaults to the session encoding. */
if pcEncoding eq '':u then
    pcEncoding = session:cpstream.

/* user_env[19] will be changed BY _dmpincr.p */
ASSIGN user_env[19] = pcRenameFile + ',':u
                    + pcIndexMode + ',':u
                    + string(0)        /* debug mode. */
       user_env[02] = pcDfFilename
       user_env[05] = pcEncoding.

/* Set DICTDB alias for source DB */
delete alias 'DICTDB':u.
create alias 'DICTDB':u for database value(pcSourceDb).
    
/* This starts a new instance, so we don't have to worry about killing any running
   instances in order to get the right DICTDB. */
run startProcedure in target-procedure ("ONCE|af/app/afdeplyhlp.p":U, output hDeploymentHelper).
if not valid-handle(hDeploymentHelper) then
    return error {aferrortxt.i 'AF' '15' '?' '?' '"the Deployment Helper procedure could not be started"' "return-value"}.

/* drec_db is a shared var defined in dictvar.i */
drec_db = {fn getDictdbRecid hDeploymentHelper}.

/* Set DICTDB2 alias for target DB */
delete alias 'DICTDB2':u.
create alias 'DICTDB2':U for database value(pcTargetDb).

run prodict/dump/_dmpincr.p.

error-status:error = no.
return.        
/* - E - O - F - */
