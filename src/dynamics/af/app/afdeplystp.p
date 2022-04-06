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
/* Copyright (C) 2006 Progress Software Corporation.  All Rights Reserved. */
/*---------------------------------------------------------------------------------
  File: afdeplystp.p

  Description:  Deployment Automation: DeployStaticCode

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   08/04/2006  Author:     pjudge

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afdeplgenp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

define input parameter pcDeploymentType      as character                    no-undo.
define input parameter pcDynamicsRoot        as character                    no-undo.
define input parameter plDeployAll           as logical                      no-undo.
define input parameter plWriteListing        as logical                      no-undo.
define input parameter plWriteListingOnly    as logical                      no-undo.
define input parameter pcListingFile         as character                    no-undo.
define input parameter pcTarget              as character                    no-undo.
define input parameter pcLogFile             as character                    no-undo.
define input parameter phCriteria            as handle                       no-undo.

/* Log levels: Used as a parameter into logMessage(). */
{af/app/afloglevel.i}
&scoped-define LOG-CATEGORY DeployStaticCode

/* Defines ttCriteria temp-table. We don't use it here, since we use a buffer handle,
   but it's included here for refernece.
{af/app/afdeplycrit.i}
*/

define stream sImport.
define stream sLogging.

&scoped-define LOG-TYPES LOG,LISTING
define variable gcLogFiles         as character    extent 10 no-undo initial ?.

define variable ghDeploymentHelper        as handle                    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-copyFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD copyFile Procedure 
FUNCTION copyFile RETURNS INTEGER
    ( input pcSourceFile        as character,
      input pcTargetDir         as character       ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRcode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findRcode Procedure 
FUNCTION findRcode RETURNS CHARACTER
    ( input pcSourceDir        as character,
      input pcObjectPath       as character,
      input pcObjectName       as character,
      input pcObjectExt        as character     ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeLogFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initializeLogFile Procedure 
FUNCTION initializeLogFile RETURNS LOGICAL
  ( INPUT pcLog     AS CHARACTER,
    INPUT pcLogfile AS CHARACTER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateLogFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD updateLogFile Procedure 
FUNCTION updateLogFile RETURNS LOGICAL
  ( INPUT pcLog AS CHARACTER,
    INPUT pcLine AS CHARACTER )  FORWARD.

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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
define variable iErrorNum             as integer                no-undo.

/* Start the deplyment helper procedure. We need it  */
run startProcedure in target-procedure ("ONCE|af/app/afdeplyhlp.p":U, output ghDeploymentHelper).
if not valid-handle(ghDeploymentHelper) then
    return error 'Unable to start Deployment Helper procedure (af/app/afdeplyhlp.p)'.

if pcDynamicsRoot eq '':u or pcDynamicsRoot eq ? then
    return error {aferrortxt.i 'AF' '1' '?' '?' '"Dynamics root directory"'}.
pcDynamicsRoot = replace(pcDynamicsRoot, '~\':u, '/':u).    

iErrorNum = dynamic-function('prepareDirectory':u in ghDeploymentHelper,
                              pcTarget,
                              Yes,    /* clear contents? */
                              Yes     /* create if missing */ ).
if iErrorNum gt 0 then
    return error {aferrortxt.i 'AF' '40' '?' '?' "'Unable to write to directory ' + pcDynamicsRoot"}.

/* Get the log file ready */
if pcLogFile gt '':u and 
   not dynamic-function('initializeLogFile':u in target-procedure,
                        'LOG':u, pcLogFile        ) then
    return error {aferrortxt.i 'AF' '40' '?' '?' "'Unable to initialize log file ' + pcLogFile "}.


if plWriteListing and 
   not dynamic-function('initializeLogFile':u in target-procedure,
                         'LISTING':u, pcListingFile        ) then
    return error {aferrortxt.i 'AF' '40' '?' '?' "'Unable to initialize lsting file ' + pcListingFile "}.

/* Make sure we can write the listing file */
if plWriteListing then
    /* write header */
    dynamic-function('updateLogFile':u in target-procedure,
                     'Listing':u,
                     'File Name' + '~t':u
                     + 'Relative Path' + '~t':u
                     + 'Deployment Type' + '~t':u
                     + 'Design Object' + '~t':u ).
                         
publish 'ICFDA_logMessage':u ({&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u, 'Starting deployment of static objects').
if plDeployAll then
do:
    run deployAllObjects in target-procedure ( input pcDeploymentType,
                                               input pcDynamicsRoot,
                                               input plWriteListing,
                                               input plWriteListingOnly,
                                               input pcTarget               ) no-error.
    if error-status:error or return-value ne '':u then
        return error return-value.
end.    /* deploy all */

if valid-handle(phCriteria) and phCriteria:Type eq 'Buffer':u then
do:
    run deployIndividualObjects in target-procedure ( input pcDeploymentType,
                                                      input pcDynamicsRoot,
                                                      input pcTarget,
                                                      input phCriteria,
                                                      input plWriteListing,
                                                      input plWriteListingOnly  ) no-error.
    if error-status:error or return-value ne '':u then
        return error return-value.

    run deploySubDirectory in target-procedure (input pcDynamicsRoot,
                                                input pcTarget,
                                                input phCriteria     ) no-error.
    if error-status:error or return-value ne '':u then
        return error return-value.
end.    /* are there any criteria */

/* clean up empty directories */
run deleteEmptyDirectories in ghDeploymentHelper (pcTarget) no-error.
if error-status:error or return-value ne '':u then
    return error return-value.

publish 'ICFDA_logMessage':u ({&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u, 'Completed deployment of static objects').

error-status:error = no.
return.
/* - E - O - F - */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-deployAllObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deployAllObjects Procedure 
PROCEDURE deployAllObjects :
/*------------------------------------------------------------------------------
  Purpose:     Deploys all RYCSO static objecs for the deployment type(s).
  Parameters:  (I) pcDeploymentType
               (I) pcDynamicsRoot
               (I) plWriteListing
               (I) plWriteListingOnly
               (I) pcTarget
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcDeploymentType      as character                    no-undo.
    define input parameter pcDynamicsRoot        as character                    no-undo.
    define input parameter plWriteListing        as logical                      no-undo.
    define input parameter plWriteListingOnly    as logical                      no-undo.
    define input parameter pcTarget              as character                    no-undo.
    
    define variable cDataFieldChildren            as character                    no-undo.
    define variable iErrorNum                     as integer                      no-undo.
    define variable cObjectPath                   as character                    no-undo.
    define variable cTargetPath                   as character                    no-undo.
    define variable cSourceFile                   as character                    no-undo.
    define variable cCLFilename                   as character                    no-undo.

    define buffer rycso for ryc_smartobject.
    define buffer gscot for gsc_object_type.

    publish 'ICFDA_logMessage':u ({&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u, 'Starting deployment of all objects').
    cDataFieldChildren = {fnarg getClassChildrenFromDB 'DataField' gshRepositoryManager}.
    
    OBJECT-LOOP:    
    for each gscot where
             gscot.static_object = yes and
             not can-do(cDataFieldChildren, gscot.object_type_code)
             no-lock,
        each rycso where
             rycso.object_type_obj = gscot.object_type_obj and
             rycso.static_object = Yes and
             rycso.object_path <> 'ry/tem':u and
             not rycso.object_path matches '*template*':u
             no-lock
       break by rycso.object_path
             by rycso.object_filename:
        
        if first-of(rycso.object_path) then
        do:
            cObjectPath = rycso.object_path.
            cTargetPath = pcTarget + '/':u + cObjectPath.
            cTargetPath = trim(cTargetPath, '/':u).
            if cTargetPath eq ? or cTargetPath = '':u then
                cTargetPath = '.':u.
            
            publish 'ICFDA_logMessage':u ({&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u, 'Deploying directory - ' + cTargetPath).
            
            /* make sure the target path exists */
            iErrorNum = dynamic-function('prepareDirectory':u in ghDeploymentHelper,
                                          cTargetPath,
                                          No,    /* clear contents? */
                                          Yes     /* create if missing */ ).
            if iErrorNum gt 0 then
            do:
                publish 'ICFDA_logMessage':u ({&LOG-LEVEL-CRITICAL}, '{&LOG-CATEGORY}':u, 'Unable to write to ' + cTargetPath).
                next OBJECT-LOOP.
            end.    /* unable to prepare directory */
        end.    /* first rycso path */
        
        /* Should we deploy this? 
           lbDeployStaticCode.ReleaseVersion = 'WEB,SRV,CLT,BLANK,DESIGN' */
        if rycso.deployment_type eq '':u and
           not can-do(pcDeploymentType, 'Blank':u) then
            next OBJECT-LOOP.
        
        if rycso.design_only and
           not can-do(pcDeploymentType, 'Design':u) then
            next OBJECT-LOOP. 
        
        /* now the actual deployment types */
        if can-do(pcDeploymentType, 'Cln':u) and
           not can-do(rycso.deployment_type, 'Cln':u) then
            next OBJECT-LOOP.

        if can-do(pcDeploymentType, 'Srv':u) and
           not can-do(rycso.deployment_type, 'Srv':u) then
            next OBJECT-LOOP.

        if can-do(pcDeploymentType, 'Web':u) and
           not can-do(rycso.deployment_type, 'Web':u) then
            next OBJECT-LOOP.
        
        if not plWriteListingOnly then
        do:
            /* SDOs and their Logic Procedures have _CL file (the client proxies) that need to be deployed
               to the client. They're not registerd in the repository, so we have to derive them. */
            if dynamic-function('ClassIsA':u in gshRepositoryManager, gscot.object_type_code, 'Data':u) or
               dynamic-function('ClassIsA':u in gshRepositoryManager, gscot.object_type_code, 'DLProc':u) then
            do:
                /* We may want to deploy client and server simultaneously, so cater for both */                
                if can-do(pcDeploymentType, 'Cln':u) then
                do:
                    /* Build up the filename with the _CL */
                    cCLFilename = rycso.object_filename.
                    if num-entries(cCLFilename, '.':U) eq 1 then
                        cCLFilename = cCLFilename + '_cl':u.
                    else
                        entry(num-entries(cCLFilename, '.':u) - 1, cCLFilename, '.':u) =
                            entry(num-entries(cCLFilename, '.':u) - 1, cCLFilename, '.':u) + '_cl':u.
                    
                    cSourceFile = dynamic-function('findRcode':u in target-procedure,
                                                    pcDynamicsRoot, cObjectPath,
                                                    cCLFilename, rycso.object_extension).
                    if cSourceFile eq ? or cSourceFile eq '':u then
                    do:
                        publish 'ICFDA_logMessage':u ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u, 'Could not find r-code for ' + cCLFilename).
                        next OBJECT-LOOP.
                    end.    /* no rcode found */
                    
                    /* Copy the r-code to the target */
                    publish 'ICFDA_logMessage':u ({&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u, 'Deploying ' + cSourceFile).
                    iErrorNum = dynamic-function('copyFile':u in target-procedure,
                                                cSourceFile, cTargetPath).
                    if iErrorNum gt 0 then
                    do:
                        publish 'ICFDA_logMessage':u ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u, 'Unable to copy ' + cCLFilename).
                        next OBJECT-LOOP.
                    end.    /* copy failed */
                end.    /* client portion */
                
                if can-do(pcDeploymentType, 'Srv':u) then
                do:
                    cSourceFile = dynamic-function('findRcode':u in target-procedure,
                                                    pcDynamicsRoot, cObjectPath,
                                                    rycso.object_filename, rycso.object_extension).
                    if cSourceFile eq ? or cSourceFile eq '':u then
                    do:
                        publish 'ICFDA_logMessage':u ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u, 'Could not find r-code for ' + rycso.object_filename).
                        next OBJECT-LOOP.
                    end.    /* no rcode found */
                    
                    /* Copy the r-code to the target */
                    publish 'ICFDA_logMessage':u ({&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u, 'Deploying ' + cSourceFile).
                    iErrorNum = dynamic-function('copyFile':u in target-procedure,
                                                 cSourceFile, cTargetPath).
                    if iErrorNum gt 0 then
                    do:
                        publish 'ICFDA_logMessage':u ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u, 'Unable to copy ' + cSourceFile).
                        next OBJECT-LOOP.
                    end.    /* copy failed */
                end.    /* server portion */
            end.    /* DLProc or SDO */
            else
            do:
                /* Derive the name of the r-code file */
                cSourceFile = dynamic-function('findRcode':u in target-procedure,
                                                pcDynamicsRoot, cObjectPath,
                                                rycso.object_filename, rycso.object_extension).
                if cSourceFile eq ? or cSourceFile eq '':u then
                do:
                    publish 'ICFDA_logMessage':u ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u, 'Could not find r-code for ' + rycso.object_filename).
                    next OBJECT-LOOP.
                end.    /* no rcode found */            
                
                /* Copy the r-code to the target */
                publish 'ICFDA_logMessage':u ({&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u, 'Deploying ' + cSourceFile).
                iErrorNum = dynamic-function('copyFile':u in target-procedure,
                                        cSourceFile, cTargetPath).
                if iErrorNum gt 0 then
                do:
                    publish 'ICFDA_logMessage':u ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u, 'Unable to copy ' + cSourceFile).
                    next OBJECT-LOOP.
                end.    /* copy failed */
            end.    /* DLPRoc */
        end.    /* not listing only */
        
        if plWriteListing then
            /* write the listing */
            dynamic-function('updateLogFile':u in target-procedure,
                             'Listing':u,
                             rycso.object_filename
                             + (if rycso.object_extension eq '':u then '':u 
                                else '.':u + rycso.object_extension) + '~t':u
                             + rycso.object_path + '~t':u
                             + rycso.deployment_type + '~t':u
                             + string(rycso.design_only) +  '~t':u).
    end.    /* object loop */
    
    publish 'ICFDA_logMessage':u ({&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u, 'DeployStaticCode: Completed deployment of all objects').

    error-status:error = no.
    return.
END PROCEDURE.    /* deployAllObjects */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deployIndividualObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deployIndividualObjects Procedure 
PROCEDURE deployIndividualObjects :
/*------------------------------------------------------------------------------
  Purpose:     Deploys individual objects
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcDeploymentType      as character                    no-undo.
    define input parameter pcDynamicsRoot        as character                    no-undo.
    define input parameter pcTarget              as character                    no-undo.
    define input parameter phCriteria            as handle                       no-undo.
    define input parameter plWriteListing        as logical                      no-undo.
    define input parameter plWriteListingOnly    as logical                      no-undo.

    define variable hQuery                as handle                        no-undo.
    define variable hField                as handle                        no-undo.
    define variable cTargetPath           as character                     no-undo.
    define variable iErrorNum             as integer                       no-undo.
    define variable cCLFilename           as character                     no-undo.
    define variable cSourceFile           as character                     no-undo.
    
    define buffer rycso for ryc_smartobject.
    define buffer gscot for gsc_object_type.    

    create query hQuery.
    hQuery:set-buffers(phCriteria).
    hQuery:query-prepare('for each ':u + phCriteria:name + ' where ':u
                        + phCriteria:name + '.Type = "Object" ':u ).
    hQuery:query-open().
    
    publish 'ICFDA_logMessage':u ({&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u, 'DeployStaticCode: Deploying individual objects').
    hField = phCriteria:buffer-field('Primary':u).
    hQuery:get-first().
    do while phCriteria:available:
        find first rycso where
                   rycso.object_filename = hField:buffer-value
                   no-lock no-error.
        if available rycso then
        do:
            cTargetPath = pcTarget + '/':u + rycso.object_path.
            
            /* make sure the path exists */
            iErrorNum = dynamic-function('prepareDirectory':u in ghDeploymentHelper,
                                            cTargetPath,
                                            No,    /* clear contents? */
                                            Yes     /* create if missing */ ).
            if iErrorNum gt 0 then
            do:
                publish 'ICFDA_logMessage':u ({&LOG-LEVEL-CRITICAL}, '{&LOG-CATEGORY}':u, 'Unable to write to ' + cTargetPath).            
                hQuery:get-next().
                next.
            end.    /* unable to prepare directory */        
            
            if not plWriteListingOnly then
            do:
                find gscot where
                     gscot.object_type_obj = rycso.object_type_obj
                     no-lock.
                
                /* SDOs and their Logic Procedures have _CL file (the client proxies) that need to be deployed
                       to the client. They're not registered in the repository, so we have to derive them. */
                if dynamic-function('ClassIsA':u in gshRepositoryManager, gscot.object_type_code, 'Data':u) or
                   dynamic-function('ClassIsA':u in gshRepositoryManager, gscot.object_type_code, 'DLProc':u) then
                do:
                    /* We may want to deploy client and server simultaneously, so cater for both */                
                    if can-do(pcDeploymentType, 'Cln':u) then
                    do:
                        /* Build up the filename with the _CL */
                        cCLFilename = rycso.object_filename.
                        if num-entries(cCLFilename, '.':U) eq 1 then
                            cCLFilename = cCLFilename + '_cl':u.
                        else
                            entry(num-entries(cCLFilename, '.':u) - 1, cCLFilename, '.':u) =
                                entry(num-entries(cCLFilename, '.':u) - 1, cCLFilename, '.':u) + '_cl':u.
                        
                        cSourceFile = dynamic-function('findRcode':u in target-procedure,
                                                        pcDynamicsRoot, rycso.object_path,
                                                        cCLFilename, rycso.object_extension).
                        if cSourceFile eq ? or cSourceFile eq '':u then
                        do:
                            publish 'ICFDA_logMessage':u ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u, 'Could not find r-code for ' + cCLFilename).
                            hQuery:get-next().
                            next.
                        end.    /* no rcode found */
                        
                        /* Copy the r-code to the target */
                        publish 'ICFDA_logMessage':u ({&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u, 'Deploying ' + cSourceFile).
                        iErrorNum = dynamic-function('copyFile':u in target-procedure,
                                                    cSourceFile, cTargetPath).
                        if iErrorNum gt 0 then
                        do:
                            publish 'ICFDA_logMessage':u ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u, 'Unable to copy ' + cCLFilename).
                            hQuery:get-next().
                            next.
                        end.    /* copy failed */
                    end.    /* client portion */
                    
                    if can-do(pcDeploymentType, 'Srv':u) then
                    do:
                        cSourceFile = dynamic-function('findRcode':u in target-procedure,
                                                        pcDynamicsRoot, rycso.object_path,
                                                        rycso.object_filename, rycso.object_extension).
                        if cSourceFile eq ? or cSourceFile eq '':u then
                        do:
                            publish 'ICFDA_logMessage':u ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u, 'Could not find r-code for ' + rycso.object_filename).
                            hQuery:get-next().
                            next.
                        end.    /* no rcode found */
                        
                        /* Copy the r-code to the target */
                        publish 'ICFDA_logMessage':u ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u, 'Deploying ' + cSourceFile).
                        iErrorNum = dynamic-function('copyFile':u in target-procedure,
                                                     cSourceFile, cTargetPath).
                        if iErrorNum gt 0 then
                        do:
                            publish 'ICFDA_logMessage':u ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u, 'Unable to copy ' + cCLFilename).
                            hQuery:get-next().
                            next.
                        end.    /* copy failed */
                    end.    /* server portion */
                end.    /* DLProc or SDO */
                else
                do:
                    /* Derive the name of the r-code file */
                    cSourceFile = dynamic-function('findRcode':u in target-procedure,
                                                    pcDynamicsRoot, rycso.object_path,
                                                    rycso.object_filename, rycso.object_extension).
                    if cSourceFile eq ? or cSourceFile eq '':u then
                    do:
                        publish 'ICFDA_logMessage':u ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u, 'Could not find r-code for ' + rycso.object_filename).
                        hQuery:get-next().
                        next.
                    end.    /* no rcode found */            
                    
                    /* Copy the r-code to the target */
                    iErrorNum = dynamic-function('copyFile':u in target-procedure,
                                            cSourceFile, cTargetPath).
                    if iErrorNum gt 0 then
                    do:
                        hQuery:get-next().
                        next.
                    end.    /* copy failed */
                end.    /* DLPRoc */
            end.    /* not listing only */
            
            if plWriteListing then
                /* write the listing */
                dynamic-function('updateLogFile':u in target-procedure,
                                 'Listing':u,
                                 rycso.object_filename
                                 + (if rycso.object_extension eq '':u then '':u 
                                    else '.':u + rycso.object_extension) + '~t':u
                                 + rycso.object_path + '~t':u
                                 + rycso.deployment_type + '~t':u
                                 + string(rycso.design_only) +  '~t':u).     
        end.    /* available RYCSO */
        else
        do:
            cTargetPath = pcTarget.
            
            iErrorNum = dynamic-function('prepareDirectory':u in ghDeploymentHelper,
                                            cTargetPath,
                                            No,    /* clear contents? */
                                            Yes     /* create if missing */ ).
            if iErrorNum gt 0 then
            do:
                publish 'ICFDA_logMessage':u ({&LOG-LEVEL-CRITICAL}, '{&LOG-CATEGORY}':u, 'Unable to write to ' + cTargetPath).
                hQuery:get-next().
                next.
            end.    /* unable to prepare directory */
            
            cSourceFile = pcDynamicsRoot + '/':u + hField:buffer-value.
            cSourceFile = search(cSourceFile).            
            if cSourceFile eq ? or cSourceFile eq '':u then
            do:
                publish 'ICFDA_logMessage':u ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u, 'Could not find ' + hField:buffer-value).
                hQuery:get-next().
                next.
            end.    /* no rcode found */
                                                              
            /* Copy the r-code to the target */
            iErrorNum = dynamic-function('copyFile':u in target-procedure,
                                    cSourceFile, cTargetPath).
            if iErrorNum gt 0 then
            do:
                publish 'ICFDA_logMessage':u ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u, 'Could not copy ' + hField:buffer-value).
                hQuery:get-next().
                next.
            end.    /* copy failed */        
        end.    /* not available rycso */
        
        hQuery:get-next().
    end.    /* available changeset */                                    
    hQuery:query-close().
    
    delete object hQuery no-error.
    hQuery = ?.
    error-status:error = no.
    return.
END PROCEDURE.    /* deployIndividualObjects */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deploySubDirectory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deploySubDirectory Procedure 
PROCEDURE deploySubDirectory :
/*------------------------------------------------------------------------------
  Purpose:     Deploys contents of a sub-directory(ies)
  Parameters:  (I) pcDynamicsRoot
               (I) pcTarget
               (I) phCriteria
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcDynamicsRoot        as character                    no-undo.
    define input parameter pcTarget              as character                    no-undo.
    define input parameter phCriteria            as handle                       no-undo.

    define variable hQuery                as handle                    no-undo.
    define variable cTargetPath           as character                 no-undo.
    define variable cSourcePath           as character                 no-undo.
    define variable cObjectPath           as character                 no-undo.
    define variable cSourceFile           as character                 no-undo.
    define variable iErrorNum             as integer                   no-undo.

        /* now deploy contents of directories */
    publish 'ICFDA_logMessage':u ({&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u, 'Deploying sub-directories').
    
    create query hQuery.
    hQuery:set-buffers(phCriteria).    
    hQuery:query-prepare('for each ':u + phCriteria:name + ' where ':u
                        + phCriteria:name + '.Type = "Source" ':u ).
    hQuery:query-open().
    
    hQuery:get-first().    
    do while phCriteria:available:
        cObjectPath = phCriteria::Primary.
        
        cTargetPath = pcTarget + '/':u + cObjectPath.
        cSourcePath = pcDynamicsRoot + '/':u + cObjectPath.
        
        /* make sure the source path exists */
        iErrorNum = dynamic-function('prepareDirectory':u in ghDeploymentHelper,
                                     cSourcePath,
                                     No,    /* clear contents? */
                                     No     /* create if missing */ ).
        if iErrorNum gt 0 then
        do:
            publish 'ICFDA_logMessage':u ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u, 'Could not initialise ' + cSourcePath).
            hQuery:get-next().
            next.
        end.    /* unable to prepare directory */
    
        /* make sure the target path exists */
        iErrorNum = dynamic-function('prepareDirectory':u in ghDeploymentHelper,
                                     cTargetPath,
                                     No,    /* clear contents? */
                                     Yes     /* create if missing */ ).
        if iErrorNum gt 0 then
        do:
            publish 'ICFDA_logMessage':u ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u, 'Could not initialise ' + cTargetPath).
            hQuery:get-next().
            next.
        end.    /* unable to prepare directory */
        
        /* Now do the copy */
        input stream sImport from os-dir(cSourcePath).
        
        repeat:
            import stream sImport cSourceFile.
            if cSourceFile eq '.':u or cSourceFile eq '..':u then
                next.
            cSourceFile = cSourcePath + '/':u + cSourceFile.
            
            publish 'ICFDA_logMessage':u ({&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u, 'Copying ' + cSourceFile).
            iErrorNum  = dynamic-function('copyFile':u in target-procedure,
                                          cSourceFile, cTargetPath ).
            if iErrorNum gt 0 then
            do:
                publish 'ICFDA_logMessage':u ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u, 'Could not copy ' + cSourceFile).
                hQuery:get-next().
                next.
            end.    /* copy failed */
        end.    /* import */
        input stream sImport close.
        
        hQuery:get-next().
    end.    /* each */
    hQuery:query-close().
    
    delete object hQuery no-error.
    hQuery = ?.
    
    error-status:error = no.
    return.
END PROCEDURE.    /* deploySubDirectory */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-logMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE logMessage Procedure 
PROCEDURE logMessage :
/*------------------------------------------------------------------------------
  Purpose:     Listener for ICFDA_logMessage events. Logs messages.
  Parameters:  (I) piErrorType
               (I) pcLogCategory
               (I) pcMessage
  Notes:       This procedure ignores the log leve (piErrorType)
------------------------------------------------------------------------------*/
    define input parameter piErrorType            as integer            no-undo.
    define input parameter pcLogCategory          as character          no-undo.
    define input parameter pcMessage              as character          no-undo.
    
    /* We ignore the log level (piErrorType) here */
    if can-do('{&LOG-CATEGORY},DeploymentHelper':u, pcLogCategory) then
        dynamic-function('updateLogFile':u in target-procedure,
                         'LOG':U,
                         string(iso-date(now)) + ' ':u + pcMessage).
    
    error-status:error = no.
    return.
END PROCEDURE.    /* logMessage */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-copyFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION copyFile Procedure 
FUNCTION copyFile RETURNS INTEGER
    ( input pcSourceFile        as character,
      input pcTargetDir         as character       ):
/*------------------------------------------------------------------------------
  Purpose: Copies a file (fully-pathed) to a specified directory.
        Notes:
------------------------------------------------------------------------------*/
    define variable iOSError        as integer                        no-undo.
    
    os-copy value(pcSourceFile) value(pcTargetDir).
    iOSError = os-error.
    
    error-status:error = no.
    return iOSError.
END FUNCTION.    /* CopyFile */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRcode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findRcode Procedure 
FUNCTION findRcode RETURNS CHARACTER
    ( input pcSourceDir        as character,
      input pcObjectPath       as character,
      input pcObjectName       as character,
      input pcObjectExt        as character     ):
/*------------------------------------------------------------------------------
  Purpose: Finds an r-code file in a directory structure 
    Notes: pcSourceDir  c:/app/src
           pcObjectPath ry/app
           pcObjectName custwin.w or custwin
           pcObjectExt  <blank> or w
------------------------------------------------------------------------------*/
    define variable cRcodeFile                as character             no-undo.
    
    pcSourceDir = replace(pcSourceDir, '~\':u, '/':u).
    pcObjectPath = replace(pcObjectPath, '~\':u, '/':u).
    
    /* First, look in the source dir specified by the user, relatively pathed: c:/source/ry/prc/ryrepclntp.r */
    cRcodeFile = pcSourceDir + '/':u
               + (if pcObjectPath eq '':u then '':u else pcObjectPath + '/':u)
               + pcObjectName
               + (if pcObjectExt eq '':u then '' else '.' + pcObjectExt).    
    entry(num-entries(cRcodeFile, '.':u), cRcodeFile, '.':u) = 'r':u.
    cRcodeFile = search(cRcodeFile).
    
    if cRcodeFile eq ? then
    do:
        /* Secondly, look in the source dir specified by the user, root only, ignore the relative path: c:/source/ryrepclntp.r */
        cRcodeFile = pcSourceDir  + '/':u
                   + pcObjectName
                   + (if pcObjectExt eq '':u then '' else '.' + pcObjectExt).
        entry(num-entries(cRcodeFile, '.':u), cRcodeFile, '.':u) = 'r':u.
        cRcodeFile = search(cRcodeFile).
    end.    /* #1 failed */
    
    /* If we can't find it here either, look for it in the PROPATH: SEARCH("ry/prc/ryrepclntp.r") */
    if cRcodeFile eq ? then
    do:
        cRcodeFile = pcObjectPath + '/':u
                   + pcObjectName
                   + (if pcObjectExt eq '':u then '' else '.' + pcObjectExt).
        entry(num-entries(cRcodeFile, '.':u), cRcodeFile, '.':u) = 'r':u.
        
        /* get a fully-pathed filename */
        cRcodeFile = search(cRcodeFile).
        if cRcodeFile ne ? then
            file-information:file-name = cRcodeFile.
    end.    /* #2 failed */
    
    /* File-info and search() return the filename with the OPSYS dir delimiter */
    cRcodeFile = replace(cRcodeFile, '~\':u, '/':u) no-error.
    
    error-status:error =  no.
    return cRcodeFile.
END FUNCTION.    /* findRcode */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeLogFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initializeLogFile Procedure 
FUNCTION initializeLogFile RETURNS LOGICAL
  ( INPUT pcLog     AS CHARACTER,
    INPUT pcLogfile AS CHARACTER  ) :
/*------------------------------------------------------------------------------
  Purpose:  Stores name of logfile internally, and clears log.
    Notes:  pclog = LISTING or LOG
            pclogfile = name of logfile
------------------------------------------------------------------------------*/
    define variable iIndex         as integer            no-undo.
    define variable iErrorNum      as integer            no-undo.
    define variable lOok           as logical            no-undo.
    define variable cPath          as character          no-undo.
    
    pcLogFile = replace(pcLogFile, '~\':u, '/':u).
    cPath = pcLogFile.
    entry(num-entries(cPath, '/':u), cPath, '/':u) = '':u.
    cPath = right-trim(cPath, '/':u).
    iErrorNum = dynamic-function('prepareDirectory':u in ghDeploymentHelper,
                                  cPath,
                                  No,    /* clear contents? */
                                  Yes     /* create if missing */ ).
    
    if iErrorNum gt 0 then
        publish 'ICFDA_logMessage' ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u, 'Unable to write to directory ' + cPath).
    else
    do:
        iIndex = lookup(pcLog, '{&LOG-TYPES}':u) no-error.
        if iIndex eq ? then iIndex = 0.
        
        if iIndex gt 0 then
        do:
            gcLogfiles[iIndex] = pcLogFile.
            
            output stream sLogging to value(gcLogfiles[iIndex]).
            output stream sLogging close.
        end.    /* valid logfile */
    end.    /* init logfile */
    
    subscribe procedure target-procedure
        to 'ICFDA_logMessage':u
        anywhere
        run-procedure 'logMessage':u.
    
    error-status:error = no.
    return (iIndex gt 0).
END FUNCTION.   /* initializeLogFile */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateLogFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION updateLogFile Procedure 
FUNCTION updateLogFile RETURNS LOGICAL
  ( INPUT pcLog AS CHARACTER,
    INPUT pcLine AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Writes messages to a log
    Notes: pcLog is one of LISTING or LOG
------------------------------------------------------------------------------*/
    define variable iIndex         as integer                        no-undo.
    
    iIndex = lookup(pcLog, '{&LOG-TYPES}':u) no-error.
    if iIndex eq ? then iIndex = 0.
    
    if iIndex gt 0 and gcLogfiles[iIndex] gt '':u then
    do:
        output stream sLogging to value(gcLogfiles[iIndex]) append.
        put stream sLogging unformatted pcLine skip.
        output stream sLogging close.
    end.    /* valid logfile */
    
    return true.
END FUNCTION.    /* updateLogFile */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

