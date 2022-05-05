&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
/* Procedure Description
"Structured Procedure File Template.

Use this template to create a new Structured Procedure file to compile and run PROGRESS 4GL code. You edit structured procedure files using the AB's Section Editor."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/* Copyright (c) 2006 Progress Software Corporation.  All Rights Reserved. */
/*------------------------------------------------------------------------
    File        : afbuildrcp.p
    Purpose     : 

    Syntax      :

    Description : Deployment Automation: BuildStaticCode

    Author(s)   : pjudge
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .p file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
define input parameter plRemoveRCode           as logical            no-undo.
define input parameter plCompileSubdir         as logical            no-undo.
define input parameter plCompileMinSize        as logical            no-undo.
define input parameter plCompileMD5            as logical            no-undo.
define input parameter plStreamIO              as logical            no-undo.
define input parameter plDebugListingEnable    as logical            no-undo.
define input parameter pcDebugListFile         as character          no-undo.
define input parameter plListingEnable         as logical            no-undo.
define input parameter pcListingFile           as character          no-undo.
define input parameter plListingAppend         as logical            no-undo.
define input parameter piListingPageWidth      as integer            no-undo.
define input parameter piListingPageSize       as integer            no-undo.
define input parameter plXrefEnable            as logical            no-undo.
define input parameter plXrefAppend            as logical            no-undo.
define input parameter pcXrefFile              as character          no-undo.
define input parameter plEncryptEnable         as logical            no-undo.
define input parameter pcEncryptKey            as character          no-undo.
define input parameter plSaveRCode             as logical            no-undo.
define input parameter plStringXrefEnable      as logical            no-undo.
define input parameter pcStringXrefFile        as character          no-undo.
define input parameter plStringXrefAppend      as logical            no-undo.
define input parameter pcLanguages             as character          no-undo.
define input parameter pdTextSegmentGrowthFactor as decimal          no-undo.
define input parameter plPreProcessEnable      as logical            no-undo.
define input parameter pcPreProcessDir         as character          no-undo.
define input parameter phCriteria              as handle             no-undo.

/* Log levels: Used as a parameter into logMessage(). */
{af/app/afloglevel.i}
&scoped-define LOG-CATEGORY BuildStaticCode

/* Defines ttCriteria temp-table. We don't use it here, since we use a buffer handle,
   but it's included here for refernece.
{af/app/afdeplycrit.i}
*/

define variable ghDeploymentHelper        as handle                    no-undo.

/* Used for recursing into child dirs */
define stream sImport.
define temp-table ttFilename no-undo
    field ParentDir   as character
    field FileName    as character
    field IsDir       as logical
    field SaveInto    as character
    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME
/* ************************  Function Prototypes ********************** */


&IF DEFINED(EXCLUDE-validateOutputArguments) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD validateOutputArguments Procedure
FUNCTION validateOutputArguments RETURNS LOGICAL PRIVATE
	( input pcDescription            as character,
      input plDirOnly                as logical,
      input-output plEnabled         as logical,
      input-output pcFilename        as character      ) FORWARD.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF




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
procedure main-block : end procedure.    /* so's Eclipse knows where it is ...*/

define variable hQuery            as handle                        no-undo.
define variable cSaveInto         as character                     no-undo.
define variable iErrorNum         as integer                       no-undo.

/* Start the Deployment helper procedure. We need it  */
run startProcedure in target-procedure ("ONCE|af/app/afdeplyhlp.p":U, output ghDeploymentHelper).
if not valid-handle(ghDeploymentHelper) then
    return error 'Unable to start Deployment Helper procedure (af/app/afdeplyhlp.p)'.


/* Validate inputs */
dynamic-function('validateOutputArguments':u in target-procedure,
                 'debug listing', No,
                 input-output plDebugListingEnable,
                 input-output pcDebugListFile ).

dynamic-function('validateOutputArguments':u in target-procedure,
                 'compile listing', No,
                 input-output plListingEnable,
                 input-output pcListingFile ).
    
dynamic-function('validateOutputArguments':u in target-procedure,
                 'xref', No,
                 input-output plXrefEnable,
                 input-output pcXrefFile ).

dynamic-function('validateOutputArguments':u in target-procedure,
                 'string xref', No,
                 input-output plStringXrefEnable,
                 input-output pcStringXrefFile ).

dynamic-function('validateOutputArguments':u in target-procedure,
                 'preprocess listing', Yes,
                 input-output plPreProcessEnable,
                 input-output pcPreProcessDir ).

if not valid-handle(phCriteria) or
    phCriteria:type ne 'Buffer':u then
    return error 'Invalid criteria buffer passed into procedure'.

create query hQuery.
hQuery:set-buffers(phCriteria).
hQuery:query-prepare(' for each ':u + phCriteria:name).
hQuery:query-open().

hQuery:get-first().
do while phCriteria:available:    
    /* Validate that the save-into directory has a value.
       We don't prepare it here - that gets done in compileDirectory() */
    if plSaveRCode then
    do:
        cSaveInto = phCriteria::Tertiary.
        if cSaveInto eq ? or cSaveInto eq '':u then
        do:
            publish 'ICFDA_LogMessage':u ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u,
                        'The Save-Into directory must be specified').
            hQuery:get-next().
            next.
        end.    /* error prep'ing directory */        
    end.    /* save r-code */
    
    if phCriteria::Type eq 'Source':u then
    do:
        run compileDirectory in target-procedure ( input phCriteria::Primary,      /* directory name */
                                                   input phCriteria::Secondary,    /* file mask */
                                                   input plRemoveRCode,
                                                   input plCompileSubdir,
                                                   input plCompileMinSize,
                                                   input plCompileMD5,
                                                   input cSaveInto,        /* from phCriteria::Tertiary */
                                                   input plStreamIO,
                                                   input pcDebugListFile,
                                                   input pcListingFile,
                                                   input plListingAppend,
                                                   input piListingPageWidth,
                                                   input piListingPageSize,
                                                   input plXrefAppend,
                                                   input pcXrefFile,
                                                   input plEncryptEnable,
                                                   input pcEncryptKey,
                                                   input plSaveRCode,
                                                   input pcStringXrefFile,
                                                   input plStringXrefAppend,
                                                   input pcLanguages,
                                                   input pdTextSegmentGrowthFactor,
                                                   input pcPreProcessDir            )  no-error.
        if error-status:error or return-value ne '':u then
            publish 'ICFDA_logMessage':U ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u,
                        'Error compiling directory ' + phCriteria::Primary 
                          + '. Error=' + return-value).
        
        /* Clean up empty dirs after compile. If it fails, it fails. */
        run deleteEmptyDirectories in ghDeploymentHelper (cSaveInto) no-error.
    end.    /* source */
    else
    if phCriteria::Type eq 'Object':u then
    do:
        run compileFile in target-procedure ( input phCriteria::Primary,    /* file name to compile */
                                              input cSaveInto,    /* from phCriteria::Tertiary */
                                              input plCompileMinSize,
                                              input plCompileMD5,
                                              input plStreamIO,
                                              input pcDebugListFile,
                                              input pcListingFile,
                                              input plListingAppend,
                                              input piListingPageWidth,
                                              input piListingPageSize,
                                              input plXrefAppend,
                                              input pcXrefFile,
                                              input plEncryptEnable,
                                              input pcEncryptKey,
                                              input plSaveRCode,
                                              input pcStringXrefFile,
                                              input plStringXrefAppend,                                              
                                              input pcLanguages,
                                              input pdTextSegmentGrowthFactor,
                                              input pcPreProcessDir             ) no-error.                                              
        if error-status:error or return-value ne '':u then
            publish 'ICFDA_logMessage':U ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u,
                        'Error compiling file ' + phCriteria::Primary 
                          + '. Error=' + return-value).        
    end.    /* objects */
    
    hQuery:get-next().                                               
end.    /* each criteria */
hQuery:query-close().
    
delete object hQuery no-error.
hQuery = ?.

error-status:error = no.
return.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-compileDirectory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE compileDirectory Procedure 
PROCEDURE compileDirectory :
/*------------------------------------------------------------------------------
  Purpose:     Compiles the contents of a directory.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcDirectory             as character          no-undo.
    define input parameter pcFileMask              as character          no-undo.
    define input parameter plRemoveRCode           as logical            no-undo.
    define input parameter plCompileSubdir         as logical            no-undo.
    define input parameter plCompileMinSize        as logical            no-undo.
    define input parameter plCompileMD5            as logical            no-undo.
    define input parameter pcSaveInto              as character          no-undo.
    define input parameter plStreamIO              as logical            no-undo.
    define input parameter pcDebugListFile         as character          no-undo.                        
    define input parameter pcListingFile           as character          no-undo.
    define input parameter plListingAppend         as logical            no-undo.
    define input parameter piListingPageWidth      as integer            no-undo.
    define input parameter piListingPageSize       as integer            no-undo.
    define input parameter plXrefAppend            as logical            no-undo.
    define input parameter pcXrefFile              as character          no-undo.
    define input parameter plEncryptEnable         as logical            no-undo.
    define input parameter pcEncryptKey            as character          no-undo.
    define input parameter plSaveRCode             as logical            no-undo.
    define input parameter pcStringXrefFile        as character          no-undo.
    define input parameter plStringXrefAppend      as logical            no-undo.
    define input parameter pcLanguages             as character          no-undo.
    define input parameter pdTextSegmentGrowthFactor as decimal          no-undo.
    define input parameter pcPreProcessDir         as character          no-undo.
    
    define variable cFilename                as character                  no-undo.
    define variable iErrorNum                as integer                    no-undo.
    define variable iLoop                    as integer                    no-undo.
    define variable cFullFilename            as character                  no-undo.
    define variable lIsDir                   as logical                    no-undo.
    define variable lMatchesMask             as logical                    no-undo.

    define buffer lbFile for ttFilename.
    
    /* Make sure the source directory exists */
    pcDirectory = replace(pcDirectory, '~\':u, '/':u).
    iErrorNum = dynamic-function('prepareDirectory':u in ghDeploymentHelper,
                                 pcDirectory,
                                 No,    /* empty */
                                 No     /* create missing */ ).
    if iErrorNum gt 0 then
        return error 'Unable to initialize directory for compile ' + pcDirectory.                                 
    
    /* Clean out all rcode, if required. Don't use prepareDirectory's option, 
       since that removes everything from the directory, not just r-code. */
    for each lbFile where lbFile.ParentDir = pcDirectory:
        delete lbFile.
    end.
    
    /* Make sure the file mask uses . as a literal . */
    if index(pcFileMask, '.':u) gt 0 and
       index(pcFileMask, '~~.':u) eq 0 then
        pcFileMask = replace(pcFileMask, '.':u, '~~.':u).           
    
    /* Build a list of directories to compile */           
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
            
            /* If this is r-code, and flagged to remove, remove it. */
            if plRemoveRCode and 
               not lIsDir and 
               entry(2, cFilename, '.':u) eq 'r':u then
            do:
                publish 'ICFDA_LogMessage':U ({&LOG-LEVEL-DEBUG}, '{&LOG-CATEGORY}':u, 'Deleting ' + cFullFilename).
                os-delete value(cFullFilename).
                if os-error gt 0 then
                    publish 'ICFDA_LogMessage':U ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u, 'Failed to delete ' + cFullFilename).                
            end.    /* remove rcode */
            
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
                   lbFile.FileName = replace(cFullFilename, '~\':u, '/':u)
                   lbFile.IsDir = lIsDir.
            if lbFile.IsDir then
                lbFile.SaveInto = pcSaveInto + '/':u + cFilename.
        end.    /* files and dirs */                       
    end.    /* IMPORT-BLOCK: file loop */
    input stream sImport close.
    
    /* Prepare the target directory */
    if plSaveRCode then
    do:
        pcSaveInto = replace(pcSaveInto, '~\':u, '/':u).
        iErrorNum = dynamic-function('prepareDirectory':u in ghDeploymentHelper,
                                     pcSaveInto,
                                     No,  /* empty */
                                     Yes  /* create missing */ ).
        if iErrorNum gt 0 then
            return error 'Unable to initialize target directory ' + pcSaveInto.
    end.    /* save r-code */
        
    /* Find all files that file the file mask, and compile them. */
    for each lbFile where
             lbFile.ParentDir = pcDirectory and
             lbFile.IsDir = no:
        
        run compileFile in target-procedure ( input lbFile.Filename,
                                              input pcSaveInto,
                                              input plCompileMinSize,
                                              input plCompileMD5,
                                              input plStreamIO,
                                              input pcDebugListFile,
                                              input pcListingFile,
                                              input plListingAppend,
                                              input piListingPageWidth,
                                              input piListingPageSize,
                                              input plXrefAppend,
                                              input pcXrefFile,
                                              input plEncryptEnable,
                                              input pcEncryptKey,
                                              input plSaveRCode,
                                              input pcStringXrefFile,
                                              input plStringXrefAppend,                                              
                                              input pcLanguages,
                                              input pdTextSegmentGrowthFactor,
                                              input pcPreProcessDir             ) no-error.
        if error-status:error or return-value ne '':u then
            return error return-value.     
    end.    /* each file */
    
    /* Recurse into child directories, if required */
    if plCompileSubDir then
    for each lbFile where
             lbFile.ParentDir = pcDirectory and
             lbFile.IsDir = Yes:
        publish 'ICFDA_LogMessage':U ({&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u,
                    'Compiling directory ' + lbFile.FileName).
        
        run compileDirectory in target-procedure ( input lbFile.FileName,      /* directory name */
                                                   input pcFileMask,
                                                   input plRemoveRCode,
                                                   input plCompileSubdir,
                                                   input plCompileMinSize,
                                                   input plCompileMD5,
                                                   input lbFile.SaveInto,
                                                   input plStreamIO,
                                                   input pcDebugListFile,
                                                   input pcListingFile,
                                                   input plListingAppend,
                                                   input piListingPageWidth,
                                                   input piListingPageSize,
                                                   input plXrefAppend,
                                                   input pcXrefFile,
                                                   input plEncryptEnable,
                                                   input pcEncryptKey,
                                                   input plSaveRCode,
                                                   input pcStringXrefFile,
                                                   input plStringXrefAppend,
                                                   input pcLanguages,
                                                   input pdTextSegmentGrowthFactor,
                                                   input pcPreProcessDir            ) no-error.
        if error-status:error or return-value ne '':u then
            return error return-value.
    end.    /* compile directories */
    
    error-status:error =  no.
END PROCEDURE.    /* compileDirectory */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-compileFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE compileFile Procedure 
PROCEDURE compileFile :
/*------------------------------------------------------------------------------
  Purpose:    Does the actual compilation of a file.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcFilename              as character          no-undo.
    define input parameter pcSaveInto              as character          no-undo.
    define input parameter plCompileMinSize        as logical            no-undo.
    define input parameter plCompileMD5            as logical            no-undo.
    define input parameter plStreamIO              as logical            no-undo.
    define input parameter pcDebugListFile         as character          no-undo.                        
    define input parameter pcListingFile           as character          no-undo.
    define input parameter plListingAppend         as logical            no-undo.
    define input parameter piListingPageWidth      as integer            no-undo.
    define input parameter piListingPageSize       as integer            no-undo.
    define input parameter plXrefAppend            as logical            no-undo.
    define input parameter pcXrefFile              as character          no-undo.
    define input parameter plEncryptEnable         as logical            no-undo.
    define input parameter pcEncryptKey            as character          no-undo.
    define input parameter plSaveRCode             as logical            no-undo.
    define input parameter pcStringXrefFile        as character          no-undo.
    define input parameter plStringXrefAppend      as logical            no-undo.
    define input parameter pcLanguages             as character          no-undo.
    define input parameter pdTextSegmentGrowthFactor as decimal          no-undo.
    define input parameter pcPreProcessDir         as character          no-undo.
    
    /* Use the fully-pathed name of the file so that we can compile the r-code
       into another directory without a relative path being appended to the save-into
       directory. This is especially pertinent when the filename has a relative,
       rather than a fully-pathed name. */
    file-information:file-name = pcFilename.
    pcFilename = file-info:full-pathname.
    
    if plEncryptEnable then
        COMPILE VALUE(pcFilename)
                XCODE pcEncryptKey
                SAVE = plSaveRCode
                    INTO VALUE(pcSaveInto)
                LANGUAGES (VALUE(pcLanguages))
                    Text-seg-grow = pdTextSegmentGrowthFactor
                STREAM-IO = plStreamIO
                no-error
                MIN-SIZE  = plCompileMinSize                
                GENERATE-MD5 = plCompileMD5.
    else
        COMPILE VALUE(pcFilename)
                SAVE = plSaveRCode
                    INTO VALUE(pcSaveInto)
                LISTING VALUE(pcListingFile)
                   APPEND  = plListingAppend
                   PAGE-SIZE piListingPageSize 
                   PAGE-WIDTH piListingPageWidth
                XREF VALUE(pcXrefFile)
                    APPEND  = plXrefAppend
                LANGUAGES (VALUE(pcLanguages))
                    Text-seg-grow = pdTextSegmentGrowthFactor
                DEBUG-LIST VALUE(pcDebugListFile)
                STREAM-IO = plStreamIO
                preprocess value(pcPreProcessDir)
                string-xref value(pcStringXrefFile)
                    append = plStringXrefAppend
                no-error
                MIN-SIZE  = plCompileMinSize
                GENERATE-MD5 = plCompileMD5.
    
    if compiler:error then
        publish 'ICFDA_LogMessage':u ({&LOG-LEVEL-FATAL}, '{&LOG-CATEGORY}':u,
                'Compile failed for ' + pcFilename + ': ':u + error-status:get-message(1)).
    else
    if compiler:warning then        
        publish 'ICFDA_LogMessage':u ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u,
                'Compile warning for ' + pcFilename + ': ':u + error-status:get-message(1)).
    
    compiler:error = no.
    error-status:error = no.
    return.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* ************************  Function Implementations ***************** */


&IF DEFINED(EXCLUDE-validateOutputArguments) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION validateOutputArguments Procedure
FUNCTION validateOutputArguments RETURNS LOGICAL PRIVATE
	( input pcDescription            as character,
      input plDirOnly                as logical,
      input-output plEnabled         as logical,
      input-output pcFilename        as character     ):
/*------------------------------------------------------------------------------
  Purpose: Validates an output directory and makes sure that the enabled flag is
           set correctly.  		
	Notes: Used to validate the debug listing, xref , xtring-xref, compile listing			
	       and preprocess parameters
------------------------------------------------------------------------------*/
    define variable iErrorNum                as integer                no-undo.
    define variable cDirectory               as character              no-undo.
    
    if plEnabled then
    do:
        pcFilename = replace(pcFilename, '~\':u, '/':u).
        cDirectory = pcFilename.
        if not plDirOnly then
            entry(num-entries(cDirectory, '/':u), cDirectory, '/':u) = '':u.
        
        cDirectory = right-trim(cDirectory, '/':u).
        if cDirectory eq '':u then
            cDirectory = '.':u.
        
        iErrorNum = dynamic-function('prepareDirectory':u in ghDeploymentHelper,
                                     cDirectory,
                                     No,    /* empty directory */
                                     Yes /*create missing */ ).
        if iErrorNum gt 0 then
        do:
            plEnabled = no.
            pcFilename = ?.
            publish 'ICFDA_logMessage':U ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u,
                        'Error initializing directory for ' + pcDescription  + ' file (' 
                        + cDirectory + '). ' + pcDescription + ' now disabled.').
        end.    /* error creating dbg list file */
    end.    /* enable debug listing */
    else
        pcFilename = ?.
    
    error-status:error = no.
    return true.
END FUNCTION.    /* pcStringXrefFile */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
