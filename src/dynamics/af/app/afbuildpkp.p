&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
/* Procedure Description
"Structured Procedure File Template.

Use this template to create a new Structured Procedure file to compile and run PROGRESS 4GL code. You edit structured procedure files using the AB's Section Editor."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : afbuildpkp.p
    Purpose     : 

    Syntax      :

    Description : Deployment Automation: BuildPackage

    Author(s)   : pjudge
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .p file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* *************************** Definitions  ************************** */
define input parameter pcPackage            as character no-undo.
define input parameter pcCommand            as character no-undo.
define input parameter pcCmdParam           as character no-undo.
define input parameter pcCmdModifier        as character no-undo.
define input parameter phCriteria           as handle no-undo.

define stream sOutput.

/* Log levels: Used as a parameter into logMessage(). */
{af/app/afloglevel.i}
&scoped-define LOG-CATEGORY BuildPackage

/* Defines ttCriteria temp-table. We don't use it here, since we use a buffer handle,
   but it's included here for refernece.
{af/app/afdeplycrit.i}
*/

define variable ghDeploymentHelper             as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure Template
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
procedure main-block : /* for IDE */ end procedure.
define variable mb_cDirectory           as character no-undo.
define variable mb_iErrorNum            as integer no-undo.
define variable mb_cScriptFile          as character no-undo.

/* Start the Deployment helper procedure. We need it. */
run startProcedure in target-procedure ("ONCE|af/app/afdeplyhlp.p":U, output ghDeploymentHelper).
if not valid-handle(ghDeploymentHelper) then
    return error 'Unable to start Deployment Helper procedure (af/app/afdeplyhlp.p)'.

pcPackage = replace(pcPackage, '~\':u, '/':u).
mb_cDirectory = pcPackage.
entry(num-entries(mb_cDirectory, '/':u), mb_cDirectory, '/':u) = '':u.    
mb_cDirectory = right-trim(mb_cDirectory, '/':u).
    
/* Make sure we have a directory for the package to live in. */
mb_iErrorNum = dynamic-function('prepareDirectory':u in ghDeploymentHelper,
                             mb_cDirectory,
                             No,    /* empty directory */
                             Yes    /* create missing */ ).
if mb_iErrorNum gt 0 then
    return error 'Error initializing directory for ' + pcPackage.

if not valid-handle(phCriteria) or
    phCriteria:type ne 'Buffer':u then
    return error 'Invalid criteria buffer passed into procedure'.

publish 'ICFDA_LogMessage':u ({&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u,            
            'Building script file').
run buildScriptfile in target-procedure ( input  pcPackage,
                                          input  pcCommand,
                                          input  pcCmdParam,
                                          input  pcCmdModifier,
                                          input  phCriteria,
                                          output mb_cScriptfile  ) no-error.
if error-status:error or return-value ne '':u then
    return error return-value.

publish 'ICFDA_LogMessage':u ({&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u,
            'Executing script file ' + mb_cScriptFile).

mb_iErrorNum = dynamic-function('execScriptFile':u in ghDeploymentHelper,
                                 mb_cScriptFile, session:temp-dir + 'buildpackage.log':u).
if mb_iErrorNum gt 0 then
    return error 'Scriptfile ' + mb_cScriptfile + ' failed with error = ' + string(mb_iErrorNum).

error-status:error = no.
return.
/* - E - O - F */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-buildScriptfile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildScriptfile Procedure 
PROCEDURE buildScriptfile :
/*------------------------------------------------------------------------------
  Purpose:     Creates a scriptfile based on the inputted commands and criteria
  Parameters:  <none>
  Notes:        
------------------------------------------------------------------------------*/
    define input  parameter pcPackage           as character no-undo.
    define input  parameter pcCommand           as character no-undo.
    define input  parameter pcCmdParam          as character no-undo.
    define input  parameter pcCmdModifier       as character no-undo.
    define input  parameter phCriteria          as handle no-undo.
    define output parameter pcScriptFile        as character no-undo.
    
    define variable cCall                as character no-undo.
    define variable cDirSlash            as character no-undo.
    define variable cDirectory           as character no-undo.
    define variable hQuery               as handle no-undo.        
    
    pcScriptfile = session:temp-directory + 'buildpackage.':u.
    
    if opsys eq 'Unix':u then
    do:
        cCall = '':u.
        cDirSlash = '/':u.        
        pcScriptFile = pcScriptFile + 'sh':u.
        
        publish 'ICFDA_LogMessage':u ({&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u,
                'Building script file ' + pcScriptFile).
        
        output stream sOutput to value(pcScriptFile).
        put stream sOutput unformatted
            '#!/bin/sh':u skip.
    end.    /* unix */
    else
    do:
        cCall = 'call':u.
        cDirSlash = '~\':u.
        pcScriptFile = pcScriptFile + 'bat':u.
        
        publish 'ICFDA_LogMessage':u ({&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u,
                'Building script file ' + pcScriptFile).
        
        output stream sOutput to value(pcScriptFile).
        put stream sOutput unformatted
            '@echo off':u skip.
    end.    /* windows */
    
    /* Make good for the opsys. */
    pcPackage = replace(pcPackage, '/':u, cDirSlash).
    pcPackage = replace(pcPackage, '~\':u, cDirSlash).        
    
    pcCommand = replace(pcCommand, '/':u, cDirSlash).
    pcCommand = replace(pcCommand, '~\':u, cDirSlash).
    
    create query hQuery.
    hQuery:set-buffers(phCriteria).
    hQuery:query-prepare('for each ':u + phCriteria:name + ' where ':u
                             + phCriteria:name + '.Type = "Source" ':u ).
    hQuery:query-open().
    
    hQuery:get-first().
    do while phCriteria:available:
        /* make good for the opsys */
        cDirectory = replace(phCriteria::Primary, '~\':u, cDirSlash).
        cDirectory = replace(cDirectory, '/':u, cDirSlash).
        
        put stream sOutput unformatted
            'cd ':u cDirectory skip
            cCall space(1)
            pcCommand space(1)
            pcPackage space(1)
            pcCmdParam space(1)
            phCriteria::Secondary space(1)
            pcCmdModifier
            skip.
        
        hQuery:get-next().
    end.    /* criteria */
    output stream sOutput close.
    hQuery:query-close().
        
    delete object hQuery no-error.
    hQuery = ?.
    
    error-status:error = no.
    return.
END PROCEDURE.    /* buildScriptfile */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

