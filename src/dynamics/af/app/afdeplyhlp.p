&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/* Copyright (c) 2006 Progress Software Corporation.  All Rights Reserved. */
/*---------------------------------------------------------------------------------
  File: afdeplyhlp.p

  Description:  Deployment Automation Helper Procedure

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/28/2006  Author:     Peter Judge

  Update Notes: Created from Template rytemplipp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afdeplyhlp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{src/adm2/globals.i}

define variable ghDSAPI            as handle                no-undo.

{af/app/afdeplycrit.i}

/* Log levels: Used as a parameter into logMessage(). */
{af/app/afloglevel.i}
&scoped-define LOG-CATEGORY DeploymentHelper

define stream sImport.
define temp-table ttDirectory no-undo
    field ParentDir   as character
    field DirName     as character
    .

/* Error #s taken from: http://cvs.opensolaris.org/source/xref/on/usr/src/uts/common/sys/errno.h */
&scoped-define ERRNO-ENOENT 2 /* No such file or directory */
&scoped-define ERRNO-EACCESS 13 /* Permission denied */
&scoped-define ERRNO-ENOTDIR 20 /* Not a directory */


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-execScriptFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD execScriptFile Procedure
FUNCTION execScriptFile RETURNS INTEGER 
	( input pcScriptFile        as character,
      input pcLogFile           as character  ) FORWARD.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-getDLC) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDLC Procedure
FUNCTION getDLC RETURNS CHARACTER 
	(  ) FORWARD.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-cleanTree) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cleanTree Procedure 
FUNCTION cleanTree RETURNS LOGICAL PRIVATE
        ( input pcDirectory    as character ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDictdbRecid) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDictdbRecid Procedure 
FUNCTION getDictdbRecid RETURNS RECID
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareDirectory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD prepareDirectory Procedure 
FUNCTION prepareDirectory RETURNS INTEGER
    ( input pcDirectory        as character,
      input plEmpty            as logical,
      input plCreateMissing    as logical  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 1.52
         WIDTH              = 43.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */
    /* Start the Dataset API procedure. We need it  */
    run startProcedure in target-procedure ("ONCE|af/app/gscddxmlp.p":U, output ghDSAPI).
    if not valid-handle(ghDSAPI) then
        return error 'Unable to start Dataset API procedure (af/app/afgscddxmlp.p)'.
    
{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-deleteEmptyDirectories) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteEmptyDirectories Procedure 
PROCEDURE deleteEmptyDirectories :
/*------------------------------------------------------------------------------
  Purpose:    Cleans up any empty directories. 
  Parameters: (I) pcTarget - directory to clear
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcTarget        as character                no-undo.
    
    define variable iErrorNum             as integer                           no-undo.
    define variable lDeleteDir            as logical                           no-undo.

    lDeleteDir = {fnarg cleanTree pcTarget}.
    if lDeleteDir then
    do:
        os-delete value(pcTarget).
        iErrorNum = os-error.
        if iErrorNum gt 0 then
            publish 'ICFDA_logMessage':u ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u, 'Unable to clean tree ' + pcTarget).    
    end.    /* delete dir */
    
    error-status:error = no.
    return.
END PROCEDURE.    /* deleteEmptyDirectories */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDatasetDefaults) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDatasetDefaults Procedure 
PROCEDURE getDatasetDefaults :
/*------------------------------------------------------------------------------
  Purpose:     Updates a buffer with default values from the gsc_deploy_dataset
               table.
  Parameters:  (I) phDataset - buffer handle of the ttDataset temp-table
               (I) phDRecordSet - buffer handle pf the ttSelected temp-table
  Notes:       - The input buffers are populated from the deployment automation XML 
                 file. It may be missing some values. These are indicated in the
                 input buffer by the unknown value.
------------------------------------------------------------------------------*/
    define input parameter phDataset        as handle                    no-undo.
    define input parameter phRecordset      as handle                    no-undo.
    
    define variable cDatasetCode            as character                 no-undo.
    define variable cFilename               as character                 no-undo.
    define variable cWhereClause            as character                 no-undo.
    define variable hQryDS                  as handle                    no-undo.
    define variable hQryRS                  as handle                    no-undo.
    define variable hBuffer                 as handle                    no-undo.
    
    define buffer gscdd for gsc_deploy_dataset.
    define buffer gscde for gsc_dataset_entity.
    define buffer gscem for gsc_entity_mnemonic.    
    
    /* We can do nothing unless this buffer is available */
    if not valid-handle(phDataset) or not phDataset:Type eq 'Buffer' then
        return error {aferrortxt.i 'AF' '5' '?' '?' '"dataset buffer"'}.
    
    create query hQryRs.
    hQryRs:set-buffers(phRecordset).
    
    create query hQryDS.
    hQryDS:set-buffers(phDataset).
    hQryDS:query-prepare('for each ':u + phDataset:name).
    hQryDS:query-open.
    
    hQryDS:get-first().
    do while phDataset:available:
        cDatasetCode = phDataset::dataset_code.
        find first gscdd where
                   gscdd.dataset_code = cDatasetCode
                   no-lock no-error.
        if available gscdd then
        do:
            phDataset:buffer-copy(buffer gscdd:handle, 'lFilePerRecord,cFileName').
            /* If the value is ? then we know that it's safe to fill those values in.        */
            if phDataset::lFilePerRecord eq ? then phDataset::lFilePerRecord = gscdd.source_code_data.            
            if phDataset::cFileName eq ? then
            do:
                if phDataset::lFilePerRecord then
                do:
                    find first gscde where
                               gscde.deploy_dataset_obj = gscdd.deploy_dataset_obj and
                               gscde.primary_entity = yes
                               no-lock.
                    phDataset::cFileName = gscde.join_field_list.
                end.    /* file per record */
                else
                do:
                    phDataset::cFileName = gscdd.default_ado_filename.
                    if phDataset::cFileName eq ? or phDataset::cFileName eq '':u then                         
                        phDataset::cFileName = lc(gscdd.dataset_code) + '.ado':u.
                end.    /* not one file per record */
            end.    /* file-name = ? */            
            
            /* we closed the query earlier. */            
            hQryRs:query-prepare('for each ':u + phRecordset:name + ' where ':u
                                + phRecordset:name + '.dataset_code = ':u +  quoter(cDatasetCode) ).
            hQryRS:query-open.
            hQryRS:get-first().
            do while phRecordset:available:
                if phRecordset::cFilename eq ? then
                do:
                    if phDataset::lFilePerRecord eq Yes then
                    do:
                        if not valid-handle(hBuffer) then
                        do:
                            if not available gscde or
                               gscde.deploy_dataset_obj ne gscdd.deploy_dataset_obj then
                                find first gscde where
                                           gscde.deploy_dataset_obj = gscdd.deploy_dataset_obj and
                                           gscde.primary_entity = yes
                                           no-lock.
                            
                            find gscem where
                                 gscem.entity_mnemonic = gscde.entity_mnemonic
                                 no-lock no-error.
                            if not available gscem then
                            do:
                                hQryRS:get-next().
                                next.
                            end.

                            if valid-handle(hBuffer) then
                                run releasePoolObject in target-procedure (hBuffer).
                            
                            run obtainPoolObject in target-procedure ('Buffer':u,
                                                                      gscem.entity_dbname + '.':u + gscem.entity_mnemonic_description,
                                                                      output hBuffer).
                            if not valid-handle(hBuffer) then
                            do:
                                hQryRS:get-next().
                                next.
                            end.
                        end.    /* create buffer */
                        
                        /* At this point we need to figure out what data we are going to dump. First we need to find the
                           record in the main table for this record version record  */
                        cWhereClause = 'Where ':U 
                                     + dynamic-function('buildWhereFromKeyVal':u in ghDSAPI,
                                                        chr(1),
                                                        (if gscem.table_has_object_field then gscem.entity_object_field else gscem.entity_key_field),
                                                        phRecordset::cKey,
                                                        hBuffer).
                        if cWhereClause eq ? or cWhereClause eq '':u then                                                            
                        do:
                            hQryRS:get-next().
                            next.
                        end.
                        
                        hBuffer:find-first(cWhereClause, no-lock) no-error.
                        error-status:error = no.
                        
                        cFileName = dynamic-function('getFileNameFromField':u in ghDSAPI,
                                                     phDataset::cFileName,    /* this is the field used to build the ADO file name */
                                                     hBuffer).
                        phRecordset::cFileName = cFileName.                                                                 
                    end.    /* file per record */
                    else
                        phRecordset::cFileName = pHDataset::cFileName.                                                                       
                end.    /* filename eq ? */
                hQryRS:get-next().
            end.    /* avialable recordset */
            hQryRS:query-close.
            
            /* clean up buffer object */
            delete object hBuffer no-error.
            hBuffer = ?.                
        end.    /* available gscdd */
        
        hQryDS:get-next().
    end.    /* while available*/
    hQryDS:query-close.

    delete object hQryDS no-error.
    hQryDS = ?.
    
    delete object hQryRs no-error.
    hQryRS = ?.  
    
    error-status:error = no.
    return.
END PROCEDURE.    /* getDatasetDefaults */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killPlip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip Procedure 
PROCEDURE killPlip :
/*------------------------------------------------------------------------------
  Purpose:     entry point to instantly kill the plip if it should get lost in memory
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipkill.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-objectDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription Procedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.

ASSIGN cDescription = "Dynamics Deployment Helper PLIP".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipSetup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup Procedure 
PROCEDURE plipSetup :
/*------------------------------------------------------------------------------
  Purpose:    Run by main-block of PLIP at startup of PLIP
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipsetu.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run just before the calling program 
               terminates
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-execScriptFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION execScriptFile Procedure
FUNCTION execScriptFile RETURNS INTEGER 
	( input pcScriptFile        as character,
      input pcLogFile           as character    ):
/*------------------------------------------------------------------------------
  Purpose: Executes a script file, and logs the output, if a logfile is specified.
	Notes:
------------------------------------------------------------------------------*/
    define variable iErrorNum                as integer no-undo.
    
    if pcLogFile ne ? and pcLogFile ne '':u then    
        publish 'ICFDA_LogMessage':u ({&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u,
                    'The output of script ' + pcScriptfile + ' logged to ' + pcLogFile).
    
    os-command silent value(pcScriptFile + ' > ':U + pcLogFile).
    iErrorNum = os-error.
    
    error-status:error = no.
    return iErrorNum.
END FUNCTION.    /* execScriptFile */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-getDLC) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDLC Procedure
FUNCTION getDLC RETURNS CHARACTER 
	(  ):
/*------------------------------------------------------------------------------
  Purpose: Returns the value of $DLC
	Notes: Looks in the following places, in order:
             1. OS-GETENV
             2. Registry/INI file
             3. 'version' file
------------------------------------------------------------------------------*/
    define variable cDlc                as character no-undo.
    define variable cFile               as character no-undo.
    define variable cVersion            as character no-undo.
    
    /* Easiest place first */
    cDLC = os-getenv('DLC':u).
    /* Maybe it's lower-case? */
    if cDLC eq ? then
        cDLC = os-getenv('dlc':u).
    
    /* Look in the registry/INI. This won't work for all OSes */
    if cDLC eq ? and opsys ne 'Unix':u then
        get-key-value section 'Startup':u key 'DLC':u value cDLC.
    
    /* The version file contains information about the version. Find one
       and make sure it matches the session's version, as per PROVERSION.
       If it does, then we assume that the directory we found it in is $DLC. */
    if cDLC eq ? then
    do:
        cFile = search('version':u).
        if cFile ne ? then
        do:
            /* Get the data from the file. It should look something like:
            	"OpenEdge Release 10.1B1B as of Mon Aug  7 23:33:05 EDT 2006" */
            input stream sImport from value(cFile).
            /* There should only be one line in the file.
               Get the 3rd word: it's the version */
            import stream sImport unformatted cVersion.
            input stream sImport close.
            
            cVersion = trim(entry(3, cVersion, ' ':u)).
            
            if cVersion eq proversion then
                assign cDLC = replace(cFile, 'version':u, '':u)
                       cDLC = trim(cDLC)
                       cDLC = trim(cDLC, '/':u)
                       cDLC = trim(cDLC, '~\':u).
        end.    /* found a 'version' file */
    end.    /* DLC = ? */
    
    error-status:error = no.
    return cDlc.
END FUNCTION.    /* getDLC */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-cleanTree) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cleanTree Procedure 
FUNCTION cleanTree RETURNS LOGICAL PRIVATE
        ( input pcDirectory    as character ):
/*------------------------------------------------------------------------------
  Purpose: Deletes empty directories in a specified tree 
        Notes:
------------------------------------------------------------------------------*/
    define variable lDeleteDir            as logical                no-undo.
    define variable lDelChildDir          as logical                no-undo.
    define variable cFilename             as character              no-undo.    
    define variable iErrorNum             as integer                no-undo.
    
    define buffer lbDirectory for ttDirectory.
    
    pcDirectory = replace(pcDirectory, '~\':u, '/':u).
    
    lDeleteDir = yes.
    for each lbDirectory where lbDirectory.ParentDir = pcDirectory:
        delete lbDirectory.
    end.
    
    /* find all the chiold directories, and check for the existence of files */
    input stream sImport from os-dir(pcDirectory).    
    repeat:
        import stream sImport cFilename.
        /* Don't care about our parents. */
        if cFilename eq '.':U or cFilename eq '..':u then
            next.
        
        cFilename = pcDirectory + '/':u + cFilename.
        file-information:file-name = cFilename.
        if index(file-information:file-type, 'D':U) gt 0 then
        do: 
            create lbDirectory.
            lbDirectory.DirName = cFilename.
            lbDirectory.ParentDir = pcDirectory.
        end.
        else
        if index(file-information:file-type, 'F':U) gt 0 then
            lDeleteDir = no.
    end.    /* input */
    input stream sImport close.
    
    /* recurse through the directories */
    for each lbDirectory where lbDirectory.ParentDir = pcDirectory:
        lDelChildDir = {fnarg cleanTree lbDirectory.DirName}.
        if lDelChildDir then
        do:
            publish 'ICFDA_logMessage':u ({&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u, 'Deleting directory ' + lbDirectory.DirName).
            os-delete value(lbDirectory.DirName).
            iErrorNum = os-error.
            if iErrorNum gt 0 then
            do:
                publish 'ICFDA_logMessage':u ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u,
                                'Deletion of directory failed for ' + lbDirectory.DirName).
                /* Don't delete the current directory */
                lDeleteDir = no.
            end.    /* error */
        end.    /* delete the dir */
        else
            /* Don't delete me if my children aren't deleted */
            lDeleteDir = lDelChildDir.
    end.    /* each directory */
    
    error-status:error = no.
    return lDeleteDir.
END FUNCTION.    /* cleanTree */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDictdbRecid) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDictdbRecid Procedure 
FUNCTION getDictdbRecid RETURNS RECID
        (  ):
/*------------------------------------------------------------------------------
  Purpose: Returns the RECID of the _Db record for the DICTDB
        Notes: 
------------------------------------------------------------------------------*/
    find first DICTDB._Db no-lock.
    
    return recid(DICTDB._Db).
END FUNCTION.    /* getDictdbRecid */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareDirectory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION prepareDirectory Procedure 
FUNCTION prepareDirectory RETURNS INTEGER
    ( input pcDirectory        as character,
      input plEmpty            as logical,
      input plCreateMissing    as logical  ):
/*------------------------------------------------------------------------------
  Purpose: Prepares a directory for writing. Creates and empties if required.  
    Notes: plEmpty will delete the directory specified by pcDirectory recursively.
------------------------------------------------------------------------------*/
    define variable cCurrentDir         as character                  no-undo.
    define variable iLoop               as integer                    no-undo.
    define variable iOSError            as integer                    no-undo.
    
    pcDirectory = replace(pcDirectory, '~\':u, '/':u).
    file-information:file-name = pcDirectory.
    
    if plEmpty and file-information:file-type ne ? then
    do:
        publish 'ICFDA_logMessage':u ({&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u,'Clearing directory ' + pcDirectory).
        
        os-delete value(pcDirectory) recursive.
        file-information:file-name = pcDirectory.
        plCreateMissing = Yes.
    end.    /* empty directory */
    
    /* Does this directory exist? And is it a DIR? */
    if file-information:file-type eq ? and plCreateMissing then
    do:
        publish 'ICFDA_logMessage':u ({&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u,'Creating directory ' + pcDirectory).
        do iLoop = 1 to num-entries(pcDirectory, '/':u).
            cCurrentDir = cCurrentDir 
                        + (if iLoop eq 1 then '':u else '/':u)
                        + entry(iLoop, pcDirectory, '/':u).
            
            publish 'ICFDA_logMessage':u ({&LOG-LEVEL-INFO},'{&LOG-CATEGORY}':u, 'Creating directory - ' + cCurrentDir).
            os-create-dir value(cCurrentDir).
            iOSError = os-error.
            if iOSError gt 0 then
                return iOSError.
        end.    /* loop through directories and create the missing ones */
        
        file-information:file-name = pcDirectory.
    end.    /* create directory */

    /* Do we have a directory, and can we write to it? */
    if file-information:file-type eq ? then
        return {&ERRNO-ENOENT}.
    if index(file-information:file-type, 'D':u) eq 0 then
        return {&ERRNO-ENOTDIR}.
    if index(file-information:file-type, 'W':u) eq 0 then
        return {&ERRNO-EACCESS}.
    
    error-status:error = no.
    return iOSError.
END FUNCTION.    /* prepareDirectory */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

