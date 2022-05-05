&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
/* Procedure Description
"Structured Procedure File Template.

Use this template to create a new Structured Procedure file to compile and run PROGRESS 4GL code. You edit structured procedure files using the AB's Section Editor."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/* Copyright (c) 2006 Progress Software Corporation.  All Rights Reserved. */
/*------------------------------------------------------------------------
    File        : afbuildplp.p
    Purpose     : 

    Syntax      :

    Description : Deployment Automation: BuildLibrary

    Author(s)   : pjudge
    Created     : 8/10/2006
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .p file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
define input parameter pcLibrary            as character no-undo.
define input parameter pcPathType           as character no-undo.
define input parameter plRecurse            as logical no-undo.
define input parameter pcCodePage           as character no-undo.
define input parameter phCriteria           as handle no-undo.

define stream sOutput.
define stream sImport.

/* Log levels: Used as a parameter into logMessage(). */
{af/app/afloglevel.i}
&scoped-define LOG-CATEGORY BuildLibrary

/* Defines ttCriteria temp-table. We don't use it here, since we use a buffer handle,
   but it's included here for refernece.
{af/app/afdeplycrit.i}
*/

define variable ghDeploymentHelper             as handle no-undo.

define temp-table ttFilename no-undo
    field ParentDir   as character
    field FileName    as character
    field IsDir       as logical
    field RootDir     as character
    .

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
define variable mb_hQuery               as handle no-undo.
define variable mb_cScriptFile          as character no-undo.
define variable mb_cFileMask            as character no-undo.

/* Start the Deployment helper procedure. We need it  */
run startProcedure in target-procedure ("ONCE|af/app/afdeplyhlp.p":U, output ghDeploymentHelper).
if not valid-handle(ghDeploymentHelper) then
    return error 'Unable to start Deployment Helper procedure (af/app/afdeplyhlp.p)'.

pcLibrary = replace(pcLibrary, '~\':u, '/':u).
mb_cDirectory = pcLibrary.
entry(num-entries(mb_cDirectory, '/':u), mb_cDirectory, '/':u) = '':u.    
mb_cDirectory = right-trim(mb_cDirectory, '/':u).

mb_iErrorNum = dynamic-function('prepareDirectory':u in ghDeploymentHelper,
                             mb_cDirectory,
                             No,    /* empty directory */
                             Yes    /*create missing */ ).
if mb_iErrorNum gt 0 then
    return error 'Error initializing directory for ' + pcLibrary.

if not valid-handle(phCriteria) or
    phCriteria:type ne 'Buffer':u then
    return error 'Invalid criteria buffer passed into procedure'.

create query mb_hQuery.
mb_hQuery:set-buffers(phCriteria).
mb_hQuery:query-prepare('for each ':u + phCriteria:name + ' where ':u
                     + phCriteria:name + '.Type = "Source" ':u ).                         
mb_hQuery:query-open().

mb_hQuery:get-first().
do while phCriteria:available:
    /* There's no need to validate the root directory, since
       because the root dir and dir are the same thing, getFilesByDir will
       do it for us. */
    mb_cDirectory = replace(phCriteria::Primary, '~\':u, '/':u).

    mb_cFileMask = phCriteria::Secondary.
    
    /* If the filemask is something like '*.r', or 'a*.r', the we want to fetch the individual
       files from the directory. If the file mask is something like 'adm2\*.r' (with a directory
       slash), then we use the filemask as-is and let PROLIB do the selection
     */
    mb_cFileMask = replace(mb_cFileMask, '~\':u, '/':U).
    if index(mb_cFileMask, '/':U) eq 0 then
        run getFilesByDir in target-procedure ( mb_cDirectory,
                                                mb_cDirectory,
                                                mb_cFileMask,
                                                pcPathType,
                                                plRecurse      ) no-error.
    else
        run getFilesByMask in target-procedure ( mb_cDirectory, mb_cFileMask ) no-error.
    
    if error-status:error or return-value ne '':u then
        publish 'ICFDA_LogMessage':u ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u,
                    'Error building file list: ' + return-value).
    
    mb_hQuery:get-next().
end.    /* criteria */
mb_hQuery:query-close().
delete object mb_hQuery no-error.
mb_hQuery = ?.

publish 'ICFDA_LogMessage':u ({&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u,            
            'Building script file').
run buildScriptfile in target-procedure ( input  pcLibrary,
                                          input  pcPathType,
                                          input  pcCodePage,
                                          output mb_cScriptfile  ) no-error.
if error-status:error or return-value ne '':u then
    return error return-value.

publish 'ICFDA_LogMessage':u ({&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u,
            'Executing script file ' + mb_cScriptFile).

mb_iErrorNum = dynamic-function('execScriptFile':u in ghDeploymentHelper,
                                 mb_cScriptFile, session:temp-dir + 'prolib.log':u).
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
  Purpose:     
  Parameters:  <none>
  Notes:        
------------------------------------------------------------------------------*/
    define input  parameter pcLibrary            as character no-undo.
    define input  parameter pcPathType           as character no-undo.
    define input  parameter pcCodePage           as character no-undo.
    define output parameter pcScriptfile         as character no-undo.
    
    define variable cCall                as character no-undo.
    define variable cDirSlash            as character no-undo.
    define variable cAction              as character no-undo.
    define variable cModifier            as character no-undo.
    define variable cDirectory           as character no-undo.
    define variable cCommand             as character no-undo.
    
    define buffer lbFilename for ttFilename.
    
    pcScriptfile = session:temp-directory + 'buildLibrary.':u.
    cAction = '-add':u.
    cModifier = '-nowarn':u.
    
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
    
    /* Set up the command */
    cCommand = {fn getDLC ghDeploymentHelper}.
    if cCommand eq ? then
        return error 'No DLC directory was found.'.
    
    cCommand = cCommand + cDirSlash + 'bin':u + cDirSlash + 'prolib':u.
    
    /* Make good for the opsys. The individual directories or files are dealt with by PROLIB. */
    pcLibrary = replace(pcLibrary, '/':u, cDirSlash).
    pcLibrary = replace(pcLibrary, '~\':u, cDirSlash).        
    
    cCommand = replace(cCommand, '/':u, cDirSlash).
    cCommand = replace(cCommand, '~\':u, cDirSlash).
    
    /* Create the library, if it doesn't exist */        
    if search(pcLibrary) eq ? then
    do:
        put stream sOutput unformatted
            cCall space(1) cCommand  space(1) pcLibrary space(1) '-create':u space(1).
        
        if pcCodePage gt '':u then
            put stream sOutput unformatted
                '-codepage ' + pcCodePage.
        
        /* don't forget to skip ... */        
        put stream sOutput unformatted
            skip.
    end.    /* create lib */
    
    for each lbFilename where
             lbFilename.IsDir = No
             break by lbFilename.ParentDir:
        
        if first(lbFilename.ParentDir) then
        do:
            /* Make sure the directory is added in here */
            if pcPathType eq 'Rel':u or pcPathType eq 'Full':u then
            do:
                cDirectory = replace(lbFilename.RootDir, '/':u, cDirSlash).
                cDirectory = replace(cDirectory, '~\':u, cDirSlash).
                
                put stream sOutput unformatted
                    'cd ':u cDirectory skip.
            end.    /* pathtype = REL */
        end.    /* first parent dir */
        
        if first-of(lbFilename.ParentDir) then
        do:
            publish 'ICFDA_LogMessage':u ({&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u,
                    'Adding files from directory ' + lbFilename.ParentDir).
            
            /* Make sure the directory is added in here */
            if pcPathType eq 'None':u then
            do:
                cDirectory = replace(lbFilename.ParentDir, '/':u, cDirSlash).
                cDirectory = replace(cDirectory, '~\':u, cDirSlash).                    
                
                put stream sOutput unformatted
                    'cd ':u cDirectory skip.                
            end.    /* pathtype = NONE */
        end.    /* first-of directory */
        
        put stream sOutput unformatted
            cCall space(1)
            cCommand space(1)
            pcLibrary space(1)
            cAction space(1)
            lbFilename.Filename space(1)
            cModifier
            skip.
    end.    /* each filename */
    output stream sOutput close.

    error-status:error = no.
    return.
END PROCEDURE.    /* buildScriptfile */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilesByDir) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFilesByDir Procedure 
PROCEDURE getFilesByDir :
/*------------------------------------------------------------------------------
  Purpose:    Builds a list of files based on a filemask.
  Parameters: (I) pcRootDirectory - the top level we started from
                          (I) pcDirectory - the current directory we're traversing
                          (I) pcFileMask - 
                          (I) pcPathType - REL,FULL,NONE
                          (I) plRecurse
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcRootDirectory           as character no-undo.
    define input parameter pcDirectory               as character no-undo.
    define input parameter pcFileMask                as character no-undo.
    define input parameter pcPathType                as character no-undo.
    define input parameter plRecurse                 as logical no-undo.
    
    define variable iErrorNum             as integer no-undo.
    define variable cFullFilename         as character no-undo.
    define variable cFileName             as character no-undo.
    define variable lIsDir                as logical no-undo.
    define variable lMatchesMask          as logical no-undo.
    define variable iLoop                 as integer no-undo.
    
    define buffer lbFile for ttFilename.
    
    /* Make sure the source directory exists */
    pcDirectory = replace(pcDirectory, '~\':u, '/':u).
    iErrorNum = dynamic-function('prepareDirectory':u in ghDeploymentHelper,
                                 pcDirectory,
                                 No,    /* empty */
                                 No     /* create missing */ ).
    if iErrorNum gt 0 then
        return error 'Unable to initialize directory ' + pcDirectory.
    
    for each lbFile where lbFile.ParentDir = pcDirectory:
        delete lbFile.
    end.
    
    input stream sImport from os-dir(pcDirectory).
    IMPORT-BLOCK:
    repeat:
        import stream sImport cFilename.
        
        /* Skip . and .. */
        if cFilename eq '.':u or cFilename eq '..':u then
            next IMPORT-BLOCK.
        
        /* While we're here, get the directories and files to compile */
        cFullFilename = pcDirectory + '/':u + cFilename.
        file-information:file-name = cFullFilename.
        
        /* Only concern ourselves with files and dirs */
        if index(file-information:file-type, 'D':U) gt 0 or
           index(file-information:file-type, 'F':U) gt 0 then
        do:
            lIsDir = index(file-information:file-type, 'D':U) gt 0.
            
            /* Does the file fit our filemask? */
            if not lIsDir then
            do:
                lMatchesMask = no.
                do iLoop = 1 to num-entries(pcFileMask) while not lMatchesMask:
                    lMatchesMask = cFilename matches trim(entry(iLoop, pcFileMask)).
                end.    /* file masks */
                if not lMatchesMask then
                    next IMPORT-BLOCK.
            end.    /* not a dir */
            
            /* If we get here, we should only have directories and files to compile */
            create lbFile.
            assign lbFile.ParentDir = pcDirectory                   
                   lbFile.RootDir = pcRootDirectory
                   lbFile.IsDir = lIsDir
                   cFullFilename = replace(cFullFilename, '~\':u, '/':u).
            if lbFile.IsDir or pcPathType eq 'Full':u then
                assign lbFile.FileName = cFullFilename.
            else
            if pcPathType eq 'Rel':u then
                assign lbFile.FileName = replace(cFullFilename, pcRootDirectory, '':u)
                       lbFile.FileName = trim(lbFile.FileName, '/':u).
            else
            if pcPathType eq 'None':u then
                assign lbFile.FileName = cFilename
                       lbFile.FileName = trim(lbFile.FileName, '/':u).
        end.    /* files and dirs */
    end.    /* IMPORT-BLOCK: file loop */
    input stream sImport close.

    if plRecurse then
    for each lbFile where
             lbFile.ParentDir = pcDirectory and
             lbFile.IsDir = Yes:
        
        run getFilesByDir in target-procedure (pcRootDirectory,
                                               lbFile.Filename,
                                               pcFileMask,
                                               pcPathType,
                                               plRecurse          ) no-error.
        if error-status:error or return-value ne '':u then
            return error return-value.
    end.    /* reach directory */
    
    error-status:error = no.
    return.
END PROCEDURE.    /* getFilesByDir */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilesByMask) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFilesByMask Procedure 
PROCEDURE getFilesByMask :
/*------------------------------------------------------------------------------
  Purpose:    Builds a filerecord based on a subdirectory file mask
  Parameters: (I) pcDirectory - the current directory we're traversing
                          (I) pcFileMask - 
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcDirectory               as character no-undo.
    define input parameter pcFileMask                as character no-undo.
    
    define variable iErrorNum             as integer no-undo.
    define variable cFullFilename         as character no-undo.
    define variable cFileName             as character no-undo.
    define variable lIsDir                as logical no-undo.
    define variable lMatchesMask          as logical no-undo.
    define variable iLoop                 as integer no-undo.
    
    define buffer lbFile for ttFilename.
    
    /* Make sure the source directory exists */
    pcDirectory = replace(pcDirectory, '~\':u, '/':u).
    iErrorNum = dynamic-function('prepareDirectory':u in ghDeploymentHelper,
                                 pcDirectory,
                                 No,    /* empty */
                                 No     /* create missing */ ).
    if iErrorNum gt 0 then
        return error 'Unable to initialize directory ' + pcDirectory.

    /* If we get here, we should only have directories and files to compile */
    create lbFile.
    assign lbFile.ParentDir = pcDirectory                   
           lbFile.RootDir = pcDirectory
           lbFile.IsDir = No
           lbFile.FileName = pcFileMask.
    
    error-status:error = no.
    return.
END PROCEDURE.    /* getFilesByMask */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

