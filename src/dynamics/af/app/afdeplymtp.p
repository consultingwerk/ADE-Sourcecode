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
  File: afdeplymtp.p

  Description:  Deployment Automation Script Procedure

  Purpose:      Deployment Automation Script Procedure

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/12/2006  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************* */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afdeplymtp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}
{launch.i &Define-Only=Yes}

/* Dataset change management. Not to be confused with the Dataset temp-table, which
   is used in the ProDataset that's loaded from the XML document.
 */
define temp-table ttDataset no-undo
    field dataset_code         as character
    field dataset_description  as character  initial ?
    field lFilePerRecord       as logical    initial ?
    field cFileName            as character  initial ?
    field disable_ri           as logical    initial ?
    field source_code_data     as logical    initial ?
    field deploy_full_data     as logical    initial ?
    index idxMain is primary unique
        dataset_code
    .
    
define temp-table ttSelected no-undo
    field dataset_code    as character
    field cKey            as character
    field cFilename       as character
    index idxMain is primary unique
        dataset_code
        cKey.

/* Defines ttReleaseChangeset, which contains the action changes */
{af/app/afdplchgst.i}

/* Defines Deployment dataset and contained temp-tables */
{af/app/afdeployds.i}

/* Defines SetupInclude dataset  and contained temp-tables (CreatePatchFile and CreateADOListFile) */
{af/app/afstpincds.i}

/* Defines Setups dataset and contained temp-tables (UpdateDCU) */
{af/app/afdcusetds.i}

/* Defines ttCriteria temp-table */
{af/app/afdeplycrit.i}

define stream sLogging.

/* Log levels: Used as a parameter into logMessage(). */
{af/app/afloglevel.i}

/* Pseduo-properties */
define variable gc-PSEUDO-PROP-LogLevel as integer no-undo.
define variable gc-PSEUDO-PROP-LogFile as character no-undo.
define variable gc-PSEUDO-PROP-LogCategory as character no-undo.

/* Other globals */
define variable ghDeploymentHelper as handle        no-undo.

&scoped-define CHANGESET {&CHANGESET}
&scoped-define ALL {&ALL}

&scoped-define LOG-CATEGORY     DeploymentAutomation    /* log category for top-level */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-buildPatchStages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildPatchStages Procedure 
FUNCTION buildPatchStages RETURNS LOGICAL PRIVATE
        ( input pcReleaseVersion        as character ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDeploymentRoot) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDeploymentRoot Procedure 
FUNCTION getDeploymentRoot RETURNS CHARACTER
    ( input pcReleaseVersion as character ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEncoding) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEncoding Procedure 
FUNCTION getEncoding RETURNS CHARACTER
        ( input pcReleaseVersion as character ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLogCategory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLogCategory Procedure 
FUNCTION getLogCategory RETURNS CHARACTER
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLogFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLogFile Procedure 
FUNCTION getLogFile RETURNS CHARACTER
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLogLevel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLogLevel Procedure 
FUNCTION getLogLevel RETURNS INTEGER
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeTaskApi) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initializeTaskApi Procedure 
FUNCTION initializeTaskApi RETURNS LOGICAL private
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeTaskOrder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initializeTaskOrder Procedure 
FUNCTION initializeTaskOrder RETURNS LOGICAL PRIVATE
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLogCategory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLogCategory Procedure 
FUNCTION setLogCategory RETURNS LOGICAL
    ( input pcLogcategory as character ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLogFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLogFile Procedure 
FUNCTION setLogFile RETURNS LOGICAL
        ( input pcLogFile as character  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLogLevel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLogLevel Procedure 
FUNCTION setLogLevel RETURNS LOGICAL
        ( input piLogLevel    as integer ) FORWARD.

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
    /* Initialise API calls */
    {fn initializeTaskApi}.
    
    /* initialise task order */
    {fn initializeTaskOrder}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-BuildLibrary) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BuildLibrary Procedure 
PROCEDURE BuildLibrary :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcReleaseVersion        as character            no-undo.
    define input parameter pcDeploymentType        as character            no-undo.

    define variable cApiFile        as character                        no-undo.
    define variable cApiMethod      as character                        no-undo.
    define variable cEncoding       as character                        no-undo.
    define variable cLocation       as character                        no-undo.
    define variable cTaskName       as character                        no-undo.
           
    define buffer lbBuildLibrary for BuildLibrary.
    define buffer lbTask for Task.
    define buffer lbCriteria for ttCriteria.
    define buffer lbSourceLocation for SourceLocation.
    
    cTaskName = 'BuildLibrary':u.
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Start building procedure library').
    
    run getTaskApi in target-procedure (cTaskName, pcReleaseVersion,
                                        output cApiFile, output cApiMethod) no-error.
    if error-status:error or return-value ne '':u then
    do:
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-FATAL}, cTaskName, return-value).
        return error return-value.
    end.    /* error */
    
    for each lbBuildLibrary where lbBuildLibrary.ReleaseVersion = pcReleaseVersion,
        each lbTask where
             lbTask.TaskId = lbBuildLibrary.TaskId and
             lbTask.ReleaseVersion = lbBuildLibrary.ReleaseVersion and
             lbTask.Enabled = yes and
             Can-do(pcDeploymentType, lbTask.DeploymentType)
             by lbBuildLibrary.TaskId:
        
        empty temp-table ttCriteria.
        for each lbSourceLocation where
                 lbSourceLocation.ReleaseVersion = lbTask.ReleaseVersion and
                 lbSourceLocation.TaskId = lbTask.TaskId and
                 can-do(pcDeploymentType, lbSourceLocation.DeploymentType):
            cLocation =  replace(lbSourceLocation.Location,
                                 '#DeploymentRoot#':u,
                                 {fnarg getDeploymentRoot pcReleaseVersion}).            
            if not can-find(first lbCriteria where
                                  lbCriteria.Type = 'Source':U and
                                  lbCriteria.Primary = cLocation) then
            do:
                create lbCriteria.
                assign lbCriteria.Type = 'Source':u
                       lbCriteria.Primary = cLocation
                       lbCriteria.Secondary = lbSourceLocation.FileMask.
                
                if lbCriteria.Secondary eq ? or lbCriteria.Secondary eq '':u then
                    lbCriteria.Secondary = lbBuildLibrary.FileMask.
                
                /* If no value was specified, use the default on the BuildLibrary temp-table */
                if lbCriteria.Secondary eq ? or lbCriteria.Secondary eq '':u then
                    lbCriteria.Secondary = buffer lbBuildLibrary:buffer-field('FileMask':u):default-string.
            end.    /* n/a criteria */
        end.    /* source location */
        
        cEncoding = lbBuildLibrary.Encoding.
        if cEncoding eq ? then
            cEncoding = {fnarg getEncoding pcReleaseVersion}.            
        
        lbBuildLibrary.Target = replace(lbBuildLibrary.Target,
                                        '#DeploymentRoot#':u,
                                        {fnarg getDeploymentRoot pcReleaseVersion}).        
        
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-DEBUG}, cTaskName, cTaskName,
                        'Done gathering info, now preparing to run task ' + string(lbTask.TaskId)
                        + ' using ' + cApiMethod + ' in  ' + cApiFile).
        
        if cApiMethod eq '<None>':u then
        do on stop undo, leave:
            run value(cApiFile) ( input lbBuildLibrary.Target,
                                  input lbBuildLibrary.PathType,
                                  input lbBuildLibrary.Recurse,
                                  input cEncoding,
                                  input buffer lbCriteria:handle ) no-error.
        end.
        else
        do:                                      
            {launch.i
                &PLIP  = cApiFile
                &IProc = cApiMethod
                &PList = "( input lbBuildLibrary.Target,
                            input lbBuildLibrary.PathType,
                            input lbBuildLibrary.Recurse,
                            input cEncoding,
                            input buffer lbCriteria:handle )"
                &AutoKill = yes
             }
        end.    /* plip */
        
        if error-status:error or return-value ne '':u then
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName, return-value).
    end.    /* each BuildLibrary */
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Building procedure library complete').
    
    error-status:error = no.
    return.
END PROCEDURE.    /* BuildLibrary */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-BuildPackage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BuildPackage Procedure 
PROCEDURE BuildPackage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcReleaseVersion        as character            no-undo.
    define input parameter pcDeploymentType        as character            no-undo.
    
    define variable cApiFile        as character                        no-undo.
    define variable cApiMethod      as character                        no-undo.
    define variable cCommand        as character                        no-undo.
    define variable iExtent         as integer                          no-undo.
    define variable cLocation       as character                        no-undo.
    define variable cTaskName        as character                        no-undo.
    
    define buffer lbBuildPackage for BuildPackage.
    define buffer lbTask for Task.
    define buffer lbCriteria for ttCriteria.
    define buffer lbSourceLocation for SourceLocation.
    define buffer lbCommands for Commands.
    
    cTaskName = 'BuildPackage':u.
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Start building deplyment package').
    
    run getTaskApi in target-procedure (cTaskName, pcReleaseVersion,
                                        output cApiFile, output cApiMethod) no-error.
    if error-status:error or return-value ne '' then
    do:
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-FATAL}, cTaskName, return-value).
        return error return-value.
    end.    /* error */
    
    for each lbBuildPackage where lbBuildPackage.ReleaseVersion = pcReleaseVersion,
        each lbTask where
             lbTask.TaskId = lbBuildPackage.TaskId and
             lbTask.ReleaseVersion = lbBuildPackage.ReleaseVersion and
             lbTask.Enabled = yes and
             Can-do(pcDeploymentType, lbTask.DeploymentType)
             by lbBuildPackage.TaskId:
                 
        empty temp-table ttCriteria.
        iExtent = 0.
        for each lbSourceLocation where
                 lbSourceLocation.ReleaseVersion = lbTask.ReleaseVersion and
                 lbSourceLocation.TaskId = lbTask.TaskId and
                 can-do(pcDeploymentType, lbSourceLocation.DeploymentType):
            
            cLocation = replace(lbSourceLocation.Location,
                                '#DeploymentRoot#':u,
                                {fnarg getDeploymentRoot pcReleaseVersion}).
            
            if not can-find(first lbCriteria where
                                  lbCriteria.Type = 'Source':U and
                                  lbCriteria.Primary = cLocation) then
            do:
                create lbCriteria.
                assign lbCriteria.Type = 'Source':u
                       lbCriteria.Primary = cLocation
                       lbCriteria.Secondary = lbSourceLocation.FileMask.
            end.    /* n/a critera */
        end.    /* source location */
        
        /* Build the command */
        find first lbCommands where
                   lbCommands.ReleaseVersion = lbTask.ReleaseVersion and
                   lbCommands.TaskId = lbTask.TaskId and
                   lbCommands.Cmd > '':U
                   no-error.
        if not available lbCommands then
        do:
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName,
                                'Unable to find a command for the BuildPackage task.').
            next.
        end.    /* n/a command */
        
        lbBuildPackage.Target = replace(lbBuildPackage.Target,
                                        '#DeploymentRoot#':u,
                                        {fnarg getDeploymentRoot pcReleaseVersion}).            
        lbBuildPackage.Target = replace(lbBuildPackage.Target, '#ReleaseVersion#':u, pcReleaseVersion).
        
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-DEBUG}, cTaskName, cTaskName,
                        'Done gathering info, now preparing to run task ' + string(lbTask.TaskId)
                        + ' using ' + cApiMethod + ' in  ' + cApiFile).
                        
        if cApiMethod eq '<None>':u then
        do on stop undo, leave:
            run value(cApiFile) ( input lbBuildPackage.Target,
                                  input lbCommands.Cmd,
                                  input lbCommands.ParameterList,
                                  input lbCommands.Modifier,
                                  input buffer lbCriteria:handle ) no-error.
        end.
        else
        do:                        
            {launch.i
                &PLIP  = cApiFile
                &IProc = cApiMethod
                &PList = "( input lbBuildPackage.Target,
                            input lbCommands.Cmd,
                            input lbCommands.ParameterList,
                            input lbCommands.Modifier,
                            input buffer lbCriteria:handle )"
                &AutoKill = yes
             }
        end.
        if error-status:error or return-value ne '':u then
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName, return-value).
    end.    /* each BuildPackage */
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Building deployment package complete').
    
    error-status:error = no.
    return.
END PROCEDURE.    /* BuildPackage */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-BuildStaticCode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BuildStaticCode Procedure 
PROCEDURE BuildStaticCode :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcReleaseVersion        as character            no-undo.
    define input parameter pcDeploymentType        as character            no-undo.
    
    define variable cApiFile            as character                        no-undo.
    define variable cApiMethod          as character                        no-undo.
    define variable cLocation           as character                        no-undo.
    define variable cTaskName           as character                        no-undo.
    
    define buffer lbBuildStaticCode for BuildStaticCode.
    define buffer lbTask for Task.
    define buffer lbCriteria for ttCriteria.
    define buffer lbSourceLocation for SourceLocation.
    
    cTaskName = 'BuildStaticCode':u.
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Start building r-code').
    
    run getTaskApi in target-procedure (cTaskName, pcReleaseVersion,
                                        output cApiFile, output cApiMethod) no-error.
    if error-status:error or return-value ne '':u then
    do:
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-FATAL}, cTaskName, return-value).
        return error return-value.
    end.    /* error */
    
    for each lbBuildStaticCode where lbBuildStaticCode.ReleaseVersion = pcReleaseVersion,
        each lbTask where
             lbTask.TaskId = lbBuildStaticCode.TaskId and
             lbTask.ReleaseVersion = lbBuildStaticCode.ReleaseVersion and
             lbTask.Enabled = yes and
             Can-do(pcDeploymentType, lbTask.DeploymentType)
             by lbBuildStaticCode.TaskId:
        
        lbBuildStaticCode.SaveInto = replace(lbBuildStaticCode.SaveInto,
                                             '#DeploymentRoot#':u,
                                             {fnarg getDeploymentRoot pcReleaseVersion}).
        
        empty temp-table lbCriteria.
        for each lbSourceLocation where
                 lbSourceLocation.ReleaseVersion = lbTask.ReleaseVersion and
                 lbSourceLocation.TaskId = lbTask.TaskId and
                 can-do(pcDeploymentType, lbSourceLocation.DeploymentType):
            if lbSourceLocation.Location eq '{&CHANGESET}':u then
            do:
                publish 'ICFDA_LogMessage':u ({&LOG-LEVEL-INFO}, cTaskName, 'Changeset not supported for this task').                
                next.
            end.    /* changeset */
            else
            do:
                cLocation =  replace(lbSourceLocation.Location,
                                     '#DeploymentRoot#':u,
                                     {fnarg getDeploymentRoot pcReleaseVersion}).
                
                if not can-find(first lbCriteria where
                                      lbCriteria.Type = 'Source':U and
                                      lbCriteria.Primary = cLocation) then
                do:
                    create lbCriteria.
                    assign lbCriteria.Type = 'Source':u
                           lbCriteria.Primary = cLocation
                           lbCriteria.Secondary = lbSourceLocation.FileMask
                           lbCriteria.Tertiary = lbSourceLocation.SaveInto.
                    
                    if lbCriteria.Tertiary eq ? or lbCriteria.Tertiary eq '':u then
                        lbCriteria.Tertiary = lbBuildStaticCode.SaveInto.
                    lbCriteria.Tertiary = replace(lbCriteria.Tertiary,
                                                  '#SaveInto#':u, lbBuildStaticCode.SaveInto).
                end.    /* n/a critera */
            end.    /* not a changeset */
        end.    /* source location */        
        
        lbBuildStaticCode.DebugListFile = replace(lbBuildStaticCode.DebugListFile,
                                                 '#DeploymentRoot#':u,
                                                 {fnarg getDeploymentRoot pcReleaseVersion}).
        
        lbBuildStaticCode.ListingFile = replace(lbBuildStaticCode.ListingFile,
                                                '#DeploymentRoot#':u,
                                                {fnarg getDeploymentRoot pcReleaseVersion}).        
        
        lbBuildStaticCode.XrefFile = replace(lbBuildStaticCode.XrefFile,
                                             '#DeploymentRoot#':u,
                                             {fnarg getDeploymentRoot pcReleaseVersion}).
        
        lbBuildStaticCode.PreProcessDir = replace(lbBuildStaticCode.PreProcessDir,
                                                 '#DeploymentRoot#':u,
                                                 {fnarg getDeploymentRoot pcReleaseVersion}).
                                                 
        lbBuildStaticCode.StringXrefFile = replace(lbBuildStaticCode.StringXrefFile,
                                                 '#DeploymentRoot#':u,
                                                 {fnarg getDeploymentRoot pcReleaseVersion}).
        
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-DEBUG}, cTaskName, cTaskName,
                        'Done gathering info, now preparing to run task ' + string(lbTask.TaskId)
                        + ' using ' + cApiMethod + ' in  ' + cApiFile).          
                        
        if cApiMethod eq '<none>':u then
        do on stop undo, leave:
            run value(cApiFile) ( input lbBuildStaticCode.RemoveRCode,
                                  input lbBuildStaticCode.CompileSubdir,
                                  input lbBuildStaticCode.CompileMinSize,
                                  input lbBuildStaticCode.CompileMD5,
                                  input lbBuildStaticCode.StreamIO,
                                  input lbBuildStaticCode.DebugListingEnable,
                                  input lbBuildStaticCode.DebugListFile,                        
                                  input lbBuildStaticCode.ListingEnable,
                                  input lbBuildStaticCode.ListingFile,
                                  input lbBuildStaticCode.ListingAppend,
                                  input lbBuildStaticCode.ListingPageWidth,
                                  input lbBuildStaticCode.ListingPageSize,
                                  input lbBuildStaticCode.XrefEnable,
                                  input lbBuildStaticCode.XrefAppend,
                                  input lbBuildStaticCode.XrefFile,
                                  input lbBuildStaticCode.EncryptEnable,
                                  input lbBuildStaticCode.EncryptKey,
                                  input lbBuildStaticCode.SaveRCode,
                                  input lbBuildStaticCode.StringXrefEnable,
                                  input lbBuildStaticCode.StringXrefFile,
                                  input lbBuildStaticCode.StringXrefAppend,
                                  input lbBuildStaticCode.Languages,
                                  input lbBuildStaticCode.TextSegmentGrowthFactor,
                                  input lbBuildStaticCode.PreProcessEnable,
                                  input lbBuildStaticCode.PreProcessDir,
                                  input buffer lbCriteria:handle  ) no-error.
        end.
        else
        do:                        
            {launch.i
                &PLIP  = cApiFile
                &IProc = cApiMethod
                &PList = "( input lbBuildStaticCode.RemoveRCode,
                            input lbBuildStaticCode.CompileSubdir,
                            input lbBuildStaticCode.CompileMinSize,
                            input lbBuildStaticCode.CompileMD5,
                            input lbBuildStaticCode.StreamIO,
                            input lbBuildStaticCode.DebugListingEnable,
                            input lbBuildStaticCode.DebugListFile,                        
                            input lbBuildStaticCode.ListingEnable,
                            input lbBuildStaticCode.ListingFile,
                            input lbBuildStaticCode.ListingAppend,
                            input lbBuildStaticCode.ListingPageWidth,
                            input lbBuildStaticCode.ListingPageSize,
                            input lbBuildStaticCode.XrefEnable,
                            input lbBuildStaticCode.XrefAppend,
                            input lbBuildStaticCode.XrefFile,
                            input lbBuildStaticCode.EncryptEnable,
                            input lbBuildStaticCode.EncryptKey,
                            input lbBuildStaticCode.SaveRCode,
                            input lbBuildStaticCode.StringXrefEnable,
                            input lbBuildStaticCode.StringXrefFile,
                            input lbBuildStaticCode.StringXrefAppend,
                            input lbBuildStaticCode.Languages,
                            input lbBuildStaticCode.TextSegmentGrowthFactor,
                            input lbBuildStaticCode.PreProcessEnable,
                            input lbBuildStaticCode.PreProcessDir,
                            input buffer lbCriteria:handle  )"
                &AutoKill = yes
             }
         end.
           if error-status:error or return-value ne '':u then
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName, return-value).
    end.    /* each BuildStaticCode */
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Building r-code complete').
    
    error-status:error = no.
    return.
END PROCEDURE.    /* BuildStaticCode */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CreateADOListFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreateADOListFile Procedure 
PROCEDURE CreateADOListFile :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcReleaseVersion        as character            no-undo.
    define input parameter pcDeploymentType        as character            no-undo.

    define variable cApiFile        as character                        no-undo.
    define variable cApiMethod      as character                        no-undo.
    define variable cEncoding       as character                        no-undo.
    define variable iOrder          as integer                          no-undo.
    define variable cADOListFile    as character                        no-undo.
    define variable cTaskName       as character                        no-undo.
    
    define buffer lbCreateADOListFile for CreateADOListFile.
    define buffer lbTask for Task.  
    define buffer lbObjects for Objects.
    define buffer lbPatch for Patch.
    define buffer lbPatchStage for PatchStage.
    define buffer lbProgram for Program.
    define buffer lbChangeset for ttReleaseChangeset.
    
    cTaskName = 'CreateADOListFile':u.
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Starting creation of patch file').
                     
    run getTaskApi in target-procedure (cTaskName, pcReleaseVersion,
                                        output cApiFile, output cApiMethod) no-error.
    if error-status:error or return-value ne '' then
    do:
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-FATAL}, cTaskName, return-value).
        return error return-value.
    end.    /* error */
    
    for each lbCreateADOListFile where lbCreateADOListFile.ReleaseVersion = pcReleaseVersion,
        each lbTask where
             lbTask.TaskId = lbCreateADOListFile.TaskId and
             lbTask.ReleaseVersion = lbCreateADOListFile.ReleaseVersion and
             lbTask.Enabled = yes and
             Can-do(pcDeploymentType, lbTask.DeploymentType)
             by lbCreateADOListFile.TaskId:
        
        cEncoding = lbCreateADOListFile.Encoding.
        if cEncoding eq ? then
            cEncoding = {fnarg getEncoding lbTask.ReleaseVersion}.
        
        /* We're now creating records in the SetupInclude temp-table */
        empty temp-table lbPatch.
        empty temp-table lbProgram.
        {fnarg buildPatchStages lbTask.ReleaseVersion}.
        
        create lbPatch.
        lbPatch.PatchLevel = lbCreateADOListFile.PatchLevel.
        
        iOrder = 1.    /* actual order values will 1000 + this value */
        
        for each lbObjects where
                 lbObjects.ReleaseVersion = lbTask.ReleaseVersion and
                 lbObjects.TaskId = lbTask.TaskId and
                 can-do(pcDeploymentType, lbObjects.DeploymentType):
            
            case lbObjects.Name:
                when '{&CHANGESET}':u then
                do:
                    for each lbChangeset where
                             lbChangeset.Deletion = no
                             break by lbChangeset.DatasetCode:                                                                                                  
                        /* Create a record for each dataset, regardless of
                           whether each change is dumped out on a per-record
                           basis. */
                        if first-of(lbChangeset.DatasetCode) then
                        do:
                            create lbProgram.
                            assign lbProgram.Stage = 'ADOLoad':u
                                   lbProgram.FileType = 'ADO':u
                                   lbProgram.FileName = lbChangeset.DatasetADOFilename
                                   lbProgram.Description = 'Loading ADO for ' + lbProgram.FileName.
                        
                            /* Certain ADOs have to be loaded first. */
                            case lbChangeset.EntityMnemonic:
                                when 'GSCDD':u then lbProgram.Order = 1.
                                when 'GSCEM':u then lbProgram.Order = 2.
                                when 'RYCRI':u then lbProgram.Order = 3.
                                when 'RYCRE':u then lbProgram.Order = 4.
                                otherwise lbProgram.Order = 1000 + iOrder.
                            end case.    /* entity mnemonic */
                        end.    /* first-of */
                        
                        if lbChangeset.RecordADOFilename gt '':u and
                            not can-find(first lbProgram where
                                               lbProgram.Stage = 'ADOLoad':u and
                                               lbProgram.FileType = 'ADO':u and
                                               lbProgram.FileName = lbChangeset.DatasetADOFilename ) then
                         do:
                            create lbProgram.
                            assign lbProgram.Stage = 'ADOLoad':u
                                   lbProgram.FileType = 'ADO':u
                                   lbProgram.FileName = lbChangeset.DatasetADOFilename
                                   lbProgram.Description = 'Loading ADO for ' + lbProgram.FileName.
                            
                            /* Certain ADOs have to be loaded first. */
                            case lbChangeset.EntityMnemonic:
                                when 'GSCDD':u then lbProgram.Order = 1.
                                when 'GSCEM':u then lbProgram.Order = 2.
                                when 'RYCRI':u then lbProgram.Order = 3.
                                when 'RYCRE':u then lbProgram.Order = 4.
                                otherwise lbProgram.Order = 1000 + iOrder.
                            end case.    /* entity mnemonic */
                        end.    /* create recordset entires */
                        
                        iOrder = iOrder + 1.
                    end.    /* changeset */
                end.    /* changeset */
                otherwise
                if not can-find(first lbProgram where
                                      lbProgram.Stage = 'ADOLoad':u and
                                      lbProgram.FileType = 'ADO':u and
                                      lbProgram.FileName = lbObjects.Name ) then
                do:
                    create lbProgram.
                    assign lbProgram.Stage = 'ADOLoad':u
                           lbProgram.FileType = 'ADO':u
                           lbProgram.FileName = lbObjects.Name
                           lbProgram.Description = 'Loading ADO for ' + lbProgram.FileName
                           iOrder = iOrder + 1.
                end.    /* others */
            end case.    /* object name */
        end.    /* each objects */
        
        /* replace tokens */        
        cAdolistFile = replace(lbCreateADOListFile.Target, '#PatchLevel#':u, lbPatch.PatchLevel).
        cAdolistFile = replace(lbCreateADOListFile.Target,
                               '#DeploymentRoot#':u,
                               {fnarg getDeploymentRoot pcReleaseVersion}).
        
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-DEBUG}, cTaskName,
                        'Done gathering info, now preparing to run task ' + string(lbTask.TaskId)
                        + ' using ' + cApiMethod + ' in  ' + cApiFile).
        
        if cApiMethod eq '<none>':u then
        do on stop undo, leave:
            run value(cApiFile) (input cAdoListFile, input cEncoding, input dataset SetupInclude by-reference) no-error.
        end.
        else
        do:    
            {launch.i
                &PLIP  = cApiFile
                &IProc = cApiMethod
                &PList = "(input cAdoListFile, input cEncoding, input dataset SetupInclude by-reference)"
                &AutoKill = yes
             }
         end.
        if error-status:error or return-value ne '':u then            
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName, return-value).
    end.    /* each  */
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Patch file complete').
        
    error-status:error = no.
    return.
END PROCEDURE.    /* CreateADOListFile */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createDeployment) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createDeployment Procedure 
PROCEDURE createDeployment :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     
  Parameters:  (I) pcDeploymentType - FULL, DELTA, ALL
               (I) pcConfigFile     -
               (I) pcReleaseVersion -
  Notes:       - Error handling: each task call made needs to handle it's own 
                 message handling internally. Each call will be made NO-ERROR and
                 any errors or return-values returned will cause an error to be
                 raised and the deployment aborted.
                 If an error is raised within the task calls, it is up to the
                 task to decide whether the error condition should be raised, 
                 or whether the error should simply be logged (and at what level
                 that should be).    
------------------------------------------------------------------------------*/
    define input parameter pcDeploymentType    as character            no-undo.
    define input parameter pcConfigFile        as character            no-undo.
    define input parameter pcReleaseVersion    as character            no-undo.
    
    define variable cMessage                as character               no-undo. 
    define variable cDeploymentRoot         as character               no-undo.
    define variable iErrorNum               as integer                 no-undo.
    
    /* We must have a release version specified */
    if pcReleaseVersion eq ? or pcReleaseVersion eq '':u then
        return error {aferrortxt.i 'AF' '1' '?' '?' '"release version"'}.
    
    /* Make sure that we have a valid deployment type */
    if pcDeploymentType eq ? or pcDeploymentType eq '':u then
        return error {aferrortxt.i 'AF' '1' '?' '?' '"deployment type"'}.
    
    if not can-do('Full,Delta,All':u, pcDeploymentType) then
        return error {aferrortxt.i 'AF' '5' '?' '?' '"deployment type"' "'The deployment type must be one of ~~'Full~~', ~~'Delta~~' or ~~'All~~'. The type specified was ' + pcDeploymentType"}.

    /* Turn All into Full,Delta so that we can CAN-DO it. Still keep 'All' since the
       default DeploymentType value is 'all'.
       
       Also always add 'All' so that if we pass in Delta, and the XML has All,
       we run those tasks too. */
    if pcDeploymentType eq 'All':u then
        pcDeploymentType = 'Full,Delta':u.
    pcDeploymentType = pcDeploymentType + ',All':u.
    
    /* Load and validate XML */
    run loadConfigFile in target-procedure (pcConfigFile, pcReleaseVersion) no-error.
    /* At this point there's no lbLogging available, so barf. */
    if error-status:error or return-value ne '':u then return error return-value.
    
    /* Start the deployment automation helper procedure */
    run startProcedure in target-procedure ("ONCE|af/app/afdeplyhlp.p":U, output ghDeploymentHelper).
    if not valid-handle(ghDeploymentHelper) then
    do:
        cMessage = 'Unable to start deployment helper procedure (af/app/afdeplyhlp.p)'.
        publish 'ICFDA_logMessage':u ({&LOG-LEVEL-FATAL}, '{&LOG-CATEGORY}':u, cMessage).
        return error cMessage.
    end.    /* DS API not started */
    
    /* Make sure we have a deployment root. Do this before we init the logging, since the
       logging output may refer the #DeploymentRoot# token. */
    cDeploymentRoot = {fnarg getDeploymentRoot pcReleaseVersion}.
    if cDeploymentRoot eq ? or cDeploymentRoot eq '':u then
        return error {aferrortxt.i 'AF' '1' '?' '?' '"deployment root directory"'}.
    
    /* Make sure we can write to the directory, and that it exists.
       The deployment helper publishes messages to LogMessage but we 
       can't care about that because we haven't initialised the 
       Logging yet. */
    iErrorNum = dynamic-function('prepareDirectory':u in ghDeploymentHelper,
                                cDeploymentRoot,
                                Yes,      /* clear out? */
                                Yes ).    /* create missing? */
    if iErrorNum gt 0 then
        return error 'The deployment root directory - ' + cDeploymentRoot + ' - could not be prepared. ErrNum:' + string(iErrorNum).    
    
    /* Initialise lbLogging */
    run initializeLogging in target-procedure (input table Logging by-reference, pcReleaseVersion) no-error.
    /* If we hit an error, there's no reliable lbLogging available yet, and thus barf. */
    if error-status:error or return-value ne '':u then return error return-value.
    /* From here onwards, we know we have lbLogging enabled. */
    
    /* Build tasks */
    run executeCategoryTasks in target-procedure ('Build':u, pcReleaseVersion, pcDeploymentType) no-error.
    if error-status:error or return-value ne '':u then return error return-value.
    
    /* Package tasks */
    run executeCategoryTasks in target-procedure ('Package':u, pcReleaseVersion, pcDeploymentType) no-error.
    if error-status:error or return-value ne '':u then return error return-value.
    
    /* Finish up */
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-MESSAGE}, '{&LOG-CATEGORY}':u,
                    'Deployment for release ' + pcReleaseVersion + ' completed successfully.').
                    
    /* Clean up */
    apply 'close':u to ghDeploymentHelper.
    delete object ghDeploymentHelper no-error.
    ghDeploymentHelper = ?.
    
    error-status:error = no.
    return.    /* go home happy! */
END PROCEDURE.    /* createDeployment */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CreatePatchFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreatePatchFile Procedure 
PROCEDURE CreatePatchFile :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcReleaseVersion        as character            no-undo.
    define input parameter pcDeploymentType        as character            no-undo.

    define variable cApiFile        as character                        no-undo.
    define variable cApiMethod      as character                        no-undo.
    define variable cEncoding       as character                        no-undo.
    define variable cTaskName       as character                        no-undo.
    
    define buffer lbCreatePatchFile for CreatePatchFile.
    define buffer lbTask for Task.  
    define buffer lbPatchProgram for PatchProgram.  
    define buffer lbPatch for Patch.
    define buffer lbPatchStage for PatchStage.
    define buffer lbProgram for Program.
    
    cTaskName = 'CreatePatchFile':u.
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Starting creation of patch file').
                     
    run getTaskApi in target-procedure (cTaskName, pcReleaseVersion,
                                        output cApiFile, output cApiMethod) no-error.
    if error-status:error or return-value ne '' then
    do:
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-FATAL}, cTaskName, return-value).
        return error return-value.
    end.    /* error */
    
    for each lbCreatePatchFile where lbCreatePatchFile.ReleaseVersion = pcReleaseVersion,
        each lbTask where
             lbTask.TaskId = lbCreatePatchFile.TaskId and
             lbTask.ReleaseVersion = lbCreatePatchFile.ReleaseVersion and
             lbTask.Enabled = yes and
             Can-do(pcDeploymentType, lbTask.DeploymentType)
             by lbCreatePatchFile.TaskId:
        
        cEncoding = lbCreatePatchFile.Encoding.
        if cEncoding eq ? then
            cEncoding = {fnarg getEncoding lbTask.ReleaseVersion}.
        
        empty temp-table lbPatch.
        empty temp-table lbProgram.
        {fnarg buildPatchStages lbTask.ReleaseVersion}.
        
        create lbPatch.
        lbPatch.PatchLevel = lbCreatePatchFile.PatchLevel.
        
        for each lbPatchProgram where
                 lbPatchProgram.ReleaseVersion = lbTask.ReleaseVersion and
                 lbPatchProgram.TaskId = lbTask.TaskId
                 by lbPatchProgram.Order:
            create lbProgram.
            buffer-copy lbPatchProgram to lbProgram
                assign lbPatchProgram.FileName = replace(lbPatchProgram.FileName,
                                                         '#PatchLevel#':u, lbPatch.PatchLevel).            
        end.    /* create patch program */

        lbCreatePatchFile.Target = replace(lbCreatePatchFile.Target,
                                           '#DeploymentRoot#':u,
                                           {fnarg getDeploymentRoot pcReleaseVersion}).            

        lbCreatePatchFile.Target = replace(lbCreatePatchFile.Target,
                                           '#PatchLevel#':u, lbPatch.PatchLevel).
        
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-DEBUG}, cTaskName,
                        'Done gathering info, now preparing to run task ' + string(lbTask.TaskId)
                        + ' using ' + cApiMethod + ' in  ' + cApiFile).
        if cApiMethod eq '<none>':u then
        do on stop undo, leave:
            run value(cApiFile) (input lbCreatePatchFile.Target, input cEncoding, input dataset SetupInclude by-reference) no-error.
        end.
        else
        do:
            {launch.i
                &PLIP  = cApiFile
                &IProc = cApiMethod
                &PList = "(input lbCreatePatchFile.Target, input cEncoding, input dataset SetupInclude by-reference)"
                &AutoKill = yes
             }
        end.
        if error-status:error or return-value ne '':u then            
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName, return-value).
    end.    /* each  */
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Patch file complete').
        
    error-status:error = no.
    return.
END PROCEDURE.    /* CreatePatchFile */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DeployStaticCode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeployStaticCode Procedure 
PROCEDURE DeployStaticCode :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcReleaseVersion        as character            no-undo.
    define input parameter pcDeploymentType        as character            no-undo.
    
    define variable cApiFile        as character                        no-undo.
    define variable cApiMethod      as character                        no-undo.
    define variable iLoop           as character                        no-undo.
    define variable cLocation       as character                        no-undo.
    define variable cTaskName       as character                        no-undo.
    
    define buffer lbDeployStaticCode for DeployStaticCode.
    define buffer lbTask for Task.
    define buffer lbCriteria for ttCriteria.
    define buffer lbSourceLocation for SourceLocation.
    define buffer lbObjects for Objects.
    define buffer lbChangeset for ttReleaseChangeset.
    
    cTaskName = 'DeployStaticCode':u.
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Start deployment of static objects').
    
    run getTaskApi in target-procedure (cTaskName, pcReleaseVersion,
                                        output cApiFile, output cApiMethod) no-error.
    if error-status:error or return-value ne '' then
    do:
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-FATAL}, cTaskName, return-value).
        return error return-value.
    end.    /* error */
    
    for each lbDeployStaticCode where lbDeployStaticCode.ReleaseVersion = pcReleaseVersion,
        each lbTask where
             lbTask.TaskId = lbDeployStaticCode.TaskId and
             lbTask.ReleaseVersion = lbDeployStaticCode.ReleaseVersion and
             lbTask.Enabled = yes and
             Can-do(pcDeploymentType, lbTask.DeploymentType)
             by lbDeployStaticCode.TaskId:
        
        empty temp-table ttCriteria.
        
        for each lbSourceLocation where
                 lbSourceLocation.ReleaseVersion = lbTask.ReleaseVersion and
                 lbSourceLocation.TaskId = lbTask.TaskId and
                 can-do(pcDeploymentType, lbSourceLocation.DeploymentType):
            cLocation = replace(lbSourceLocation.Location,
                                '#DeploymentRoot#':u,
                                {fnarg getDeploymentRoot pcReleaseVersion}).            
                     
            if not can-find(first lbCriteria where
                                  lbCriteria.Type = 'Source':U and
                                  lbCriteria.Primary = cLocation) then
            do:
                create lbCriteria.
                assign lbCriteria.Type = 'Source':u
                       lbCriteria.Primary = cLocation.
            end.    /* n/a critera */
        end.    /* source location */
        
        OBJECT-LOOP:
        for each lbObjects where
                 lbObjects.ReleaseVersion = lbTask.ReleaseVersion and
                 lbObjects.TaskId = lbTask.TaskId and
                 can-do(pcDeploymentType, lbObjects.DeploymentType):
            case lbObjects.Name:
                when '{&CHANGESET}':u then
                do:
                    /* Changeset not supported */
                    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName, '{&CHANGESET} not supported for DeployStaticCode').
                    next OBJECT-LOOP.
                end.    /* changeset */
                when '{&ALL}':u then
                do:
                    /* All not supported */
                    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName, '{&ALL} not supported for DeployStaticCode').
                    next OBJECT-LOOP.
                end.    /* all */
                otherwise
                do:
                    if not can-find(first lbCriteria where
                                          lbCriteria.Type = 'Object':u and
                                          lbCriteria.Primary = lbObjects.Name) then
                    do:
                        create lbCriteria.
                        assign lbCriteria.Type = 'Object':u
                               lbCriteria.Primary = lbObjects.Name.
                    end.    /* criteria */
                end.    /* others */
            end case.    /* object name */
        end.    /* OBJECT-LOOP: objects */
        
        lbDeployStaticCode.DynamicsRoot = replace(lbDeployStaticCode.DynamicsRoot,
                                                '#DeploymentRoot#':u,
                                                {fnarg getDeploymentRoot pcReleaseVersion}).            

        lbDeployStaticCode.Target = replace(lbDeployStaticCode.Target,
                                            '#DeploymentRoot#':u,
                                            {fnarg getDeploymentRoot pcReleaseVersion}).            

        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-DEBUG}, cTaskName,
                        'Done gathering info, now preparing to run task ' + string(lbTask.TaskId)
                        + ' using ' + cApiMethod + ' in  ' + cApiFile).
        if cApiMethod eq '<none>':u then
        do on stop undo, leave:
            run value(cApiFile) ( input lbDeployStaticCode.DynamicsRoot,
                                  input lbDeployStaticCode.SiteType,
                                  input lbDeployStaticCode.WriteListing,
                                  input lbDeployStaticCode.WriteListingOnly,
                                  input lbDeployStaticCode.ListingFile,
                                  input lbDeployStaticCode.Target,
                                  input buffer lbCriteria:handle         ) no-error.
        end.
        else
        do:                        
            {launch.i
                &PLIP  = cApiFile
                &IProc = cApiMethod
                &PList = "( input lbDeployStaticCode.DynamicsRoot,
                            input lbDeployStaticCode.SiteType,
                            input lbDeployStaticCode.WriteListing,
                            input lbDeployStaticCode.WriteListingOnly,
                            input lbDeployStaticCode.ListingFile,
                            input lbDeployStaticCode.Target,
                            input buffer lbCriteria:handle         )"
                &AutoKill = yes
             }
         end.
        if error-status:error or return-value ne '':u then
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName, return-value).
    end.    /* each DeployStaticCode */
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Deployment of static objects complete').
    
    error-status:error = no.
    return.
END PROCEDURE.    /* DeployStaticCode */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DumpClassCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DumpClassCache Procedure 
PROCEDURE DumpClassCache :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcReleaseVersion        as character            no-undo.
    define input parameter pcDeploymentType        as character            no-undo.

    define variable cApiFile        as character                        no-undo.
    define variable cApiMethod      as character                        no-undo.
    define variable cClassList      as character                        no-undo.
    define variable cTaskName       as character                        no-undo.
    
    define buffer lbDumpClassCache for DumpClassCache.
    define buffer lbTask for Task.
    define buffer lbObjectType for ObjectType.
    define buffer lbChangeset for ttReleaseChangeset.
    
    cTaskName = 'DumpClassCache':u.
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Starting dump of class cache').
                     
    run getTaskApi in target-procedure (cTaskName, pcReleaseVersion,
                                        output cApiFile, output cApiMethod) no-error.
    if error-status:error or return-value ne '':u then
    do:
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-FATAL}, cTaskName, return-value).
        return error return-value.
    end.    /* error */
    
    for each lbDumpClassCache where lbDumpClassCache.ReleaseVersion = pcReleaseVersion,
        each lbTask where
             lbTask.TaskId = lbDumpClassCache.TaskId and
             lbTask.ReleaseVersion = lbDumpClassCache.ReleaseVersion and
             lbTask.Enabled = yes and
             Can-do(pcDeploymentType, lbTask.DeploymentType)
             by lbDumpClassCache.TaskId:
        
        cClassList = '':u.        
        OBJECT-TYPE-LOOP:
        for each lbObjectType where
                 lbObjectType.ReleaseVersion = lbTask.ReleaseVersion and
                 lbObjectType.TaskId = lbTask.TaskId and
                 Can-do(pcDeploymentType, lbTask.DeploymentType):
            case lbObjectType.Name:
                when '{&CHANGESET}':u then
                do:
                    /* We've already retrieved the changeset */
                    for each lbChangeset where
                             lbChangeset.DatasetCode = 'Gscot':u and
                             lbChangeset.Deletion = No:
                        if not can-do(cClassList, lbChangeset.DSKeyFieldValue) then
                            cClassList = cClassList + ',':u + lbChangeset.DSKeyFieldValue.
                    end.    /* changeset */
                end.    /* changeset */
                when '{&ALL}':u then
                do:
                    cClassList = '*':u.
                    leave OBJECT-TYPE-LOOP.
                end.    /* All */
                otherwise
                    if not can-do(cClassList, lbObjectType.Name) then
                        cClassList = cClassList + ',':u + lbObjectType.Name.
            end case.    /* name */
        end.    /* OBJECT-TYPE-LOOP: each object-type */
        cClassList = left-trim(cClassList, ',':U).

        lbDumpClassCache.Target = replace(lbDumpClassCache.Target,
                                          '#DeploymentRoot#':u,
                                          {fnarg getDeploymentRoot pcReleaseVersion}).
        
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-DEBUG}, cTaskName, 
                        'Done gathering info, now preparing to run task ' + string(lbTask.TaskId)
                        + ' using ' + cApiMethod + ' in  ' + cApiFile).
        if cApiMethod eq '<none>':u then
        do on stop undo, leave:
            run value(cApiFile) ( input cClassList, input lbDumpClassCache.Target ) no-error.
        end.
        else
        do:
            {launch.i
                &PLIP  = cApiFile
                &IProc = cApiMethod
                &PList = "( input cClassList, input lbDumpClassCache.Target )"
                &AutoKill = yes
             }
        end.
        if error-status:error or return-value ne '':u then            
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName, return-value).
    end.    /* each DumpClassCache */
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Dump of class cache complete').
    
    error-status:error = no.
    return.
END PROCEDURE.    /* DumpClassCache */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DumpData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DumpData Procedure 
PROCEDURE DumpData :
/*------------------------------------------------------------------------------
  Purpose:     Dumps data 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcReleaseVersion        as character            no-undo.
    define input parameter pcDeploymentType        as character            no-undo.

    define variable cApiFile        as character                        no-undo.
    define variable cApiMethod      as character                        no-undo.
    define variable cEncoding       as character                        no-undo.
    define variable cTaskName    as character                        no-undo.
    
    define buffer lbDumpData for DumpData.
    define buffer lbTask for Task.
    
    cTaskName = 'DumpData':u.
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Starting data dump').
                     
    run getTaskApi in target-procedure (cTaskName, pcReleaseVersion,
                                        output cApiFile, output cApiMethod) no-error.
    if error-status:error or return-value ne '' then
    do:
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-FATAL}, cTaskName, return-value).
        return error return-value.
    end.    /* error */
    
    for each lbDumpData where lbDumpData.ReleaseVersion = pcReleaseVersion,
        each lbTask where
             lbTask.TaskId = lbDumpData.TaskId and
             lbTask.ReleaseVersion = lbDumpData.ReleaseVersion and
             lbTask.Enabled = yes and
             Can-do(pcDeploymentType, lbTask.DeploymentType)
             by lbDumpData.TaskId:
                 
        if lbDumpData.Db eq '':u or lbDumpData.Db eq ? then
        do:
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName,
                            'DB Name not specified for task ' + string(lbTask.TaskId)).
            next.
        end.    /* blank db */                
        else
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Dumping data for ' + lbDumpData.Db).
                
        cEncoding = lbDumpData.Encoding.
        if cEncoding eq ? then
            cEncoding = {fnarg getEncoding pcReleaseVersion}.

        lbDumpdata.Target = replace(lbDumpData.Target,
                                   '#DeploymentRoot#':u,
                                   {fnarg getDeploymentRoot pcReleaseVersion}).
        
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-DEBUG}, cTaskName,
                        'Done gathering info, now preparing to run task ' + string(lbTask.TaskId)
                        + ' using ' + cApiMethod + ' in  ' + cApiFile).
                        
        if cApiMethod eq '<none>':u then
        do on stop undo, leave:
            run value(cApiFile) (input lbDumpData.Db,
                                 input lbDumpData.Filename,
                                 input lbDumpdata.Target,
                                 input lbDumpData.LobDir,
                                 input lbDumpData.CharacterMapping,
                                 input cEncoding        ) no-error.
        end.
        else
        do:
            {launch.i
                &PLIP  = cApiFile
                &IProc = cApiMethod
                &PList = "(input lbDumpData.Db,
                           input lbDumpData.Filename,
                           input lbDumpdata.Target,
                           input lbDumpData.LobDir,
                           input lbDumpData.CharacterMapping,
                           input cEncoding        )"
                &AutoKill = yes
             }
        end.
        if error-status:error or return-value ne '':u then
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName, return-value).
    end.    /* each dumpdata */
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Data dump complete').
        
    error-status:error = no.
    return.
END PROCEDURE.    /* dumpData */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DumpDataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DumpDataset Procedure 
PROCEDURE DumpDataset :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcReleaseVersion        as character            no-undo.
    define input parameter pcDeploymentType        as character            no-undo.
    
    define variable cApiFile        as character                        no-undo.
    define variable cApiMethod      as character                        no-undo.
    define variable cDeploymentType as character                        no-undo.
    define variable hDataset        as handle                           no-undo.
    define variable hRecordset      as handle                           no-undo.
    define variable cMessage        as character                        no-undo.
    define variable hBuffer         as handle                           no-undo.
    define variable cTaskName       as character                        no-undo.
    
    define buffer lbTask for Task.
    define buffer lbDumpDataset for DumpDataset.
    define buffer lbADO for ADODataset.
    define buffer lbRecordset for ADORecordset.
    define buffer lbDateRange for DateRange.
    define buffer lbChangeset for ttReleaseChangeset.
    define buffer lbDataset for ttDataset.
    define buffer lbSelected for ttSelected.
    
    cTaskName = 'DumpDataset':u.
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Starting ADO dataset dump').
    
    run getTaskApi in target-procedure (cTaskName, pcReleaseVersion,
                                        output cApiFile, output cApiMethod) no-error.
    if error-status:error or return-value ne '' then
    do:
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-FATAL}, cTaskName, return-value).
        return error return-value.
    end.    /* error */
    
    DUMP-DATASET-LOOP:
    for each lbDumpDataset where lbDumpDataset.ReleaseVersion = pcReleaseVersion,
        each lbTask where
             lbTask.TaskId = lbDumpDataset.TaskId and
             lbTask.ReleaseVersion = lbDumpDataset.ReleaseVersion and
             lbTask.Enabled = yes and
             can-do(pcDeploymentType, lbTask.DeploymentType)
             by lbDumpDataset.TaskId:
        
        empty temp-table lbSelected.
        empty temp-table lbDataset.
        
        /* If the DeployAllModified data flag is set, don't build a list of datasets to dump. */
        if lbDumpDataset.DeployAllModified then
        do:
            if lbDumpDataset.DeployByDate then
            do:
                find first lbDateRange where
                           lbDateRange.ReleaseVersion = lbDumpDataset.ReleaseVersion and
                           lbDateRange.TaskId = lbDumpDataset.TaskId
                           no-error.
                if not available lbDateRange then
                do:
                    create lbDateRange.
                    assign lbDateRange.ReleaseVersion = lbDumpDataset.ReleaseVersion
                           lbDateRange.TaskId = lbDumpDataset.TaskId.
                    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-MESSAGE}, cTaskName,
                                        'No date range found. Creating default record.').
                end.    /* n/a date range */
                
                /* Set some defaults */
                if lbDateRange.StartDate eq ? and lbDateRange.EndDate eq ? then
                do:
                    assign lbDateRange.StartDate = today
                           lbDateRange.EndDate = today.
                    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-MESSAGE}, cTaskName,
                                    'StartDate and EndDate set to TODAY as default value').
                end.
                           
                if lbDateRange.StartDate eq ? and lbDateRange.EndDate ne ? then
                do:
                    assign lbDateRange.StartDate = lbDateRange.EndDate.
                    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-MESSAGE}, cTaskName,
                                        'StartDate set to EndDate as default value').
                end.
                
                if lbDateRange.StartDate ne ? and lbDateRange.EndDate eq ? then
                do:
                    assign lbDateRange.EndDate = lbDateRange.StartDate.
                    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-MESSAGE}, cTaskName,
                                        'EndDate set to StartDate as default value').
                end.
            end.    /* deploy by date */
        end.    /* deploy modified */
        else
        do:
            for each lbADO where
                     lbADO.ReleaseVersion = lbDumpDataset.ReleaseVersion and
                     lbADO.TaskId = lbTask.TaskId and
                     lbADO.Enabled = Yes:
                
                create lbDataset.
                assign lbDataset.dataset_code  = lbADO.DatasetCode
                       lbDataset.lFilePerRecord = lbADO.FilePerRecord
                       lbDataset.cFileName = lbADO.FileName.
                
                /* Create a recordset  - a list of ADOs to dump */
                find first lbRecordset where
                           lbRecordset.ReleaseVersion = lbADO.ReleaseVersion and
                           lbRecordset.TaskId = lbADO.TaskId and
                           lbRecordset.DatasetCode = lbADO.DatasetCode and
                           lbRecordset.KeyValue = '{&ALL}':u and
                           Can-do(pcDeploymentType, lbRecordset.DeploymentType)
                           no-error.
                
                /* If we find an 'All' recordset, then don't create any recordset records.
                   The Dataset API (gscddxmlp) knows what an empty recordset means. */                           
                if available lbRecordset then
                /* Delete all other recordsets. */
                for each lbRecordset where
                         lbRecordset.ReleaseVersion = lbADO.ReleaseVersion and
                         lbRecordset.TaskId = lbADO.TaskId and
                         lbRecordset.DatasetCode = lbADO.DatasetCode and
                         Can-do(pcDeploymentType, lbRecordset.DeploymentType):
                    delete lbRecordset.
                end.    /* each recordset, not ALL */
                
                /* Now work through the recordsets and build a list of selected records
                   for which to create ADOs. */
                RECORDSET-LOOP:
                for each lbRecordset where
                         lbRecordset.ReleaseVersion = lbADO.ReleaseVersion and
                         lbRecordset.TaskId = lbADO.TaskId and
                         lbRecordset.DatasetCode = lbADO.DatasetCode and
                         Can-do(pcDeploymentType, lbRecordset.DeploymentType):
                    
                    if lbRecordset.KeyValue eq '{&CHANGESET}':u then
                    do:
                        /* We've already retrieved the changeset */
                        for each lbChangeset where
                                 lbChangeset.DatasetCode = lbRecordset.DatasetCode and
                                 lbChangeset.Deletion = No:
                            create lbSelected.
                            assign lbSelected.dataset_code = lbRecordset.DatasetCode
                                   lbSelected.cKey = lbChangeset.DSKeyFieldValue.
                            
                            /* We have already resolved the ADO filename for changeset objects.
                               We can save ourselves some work here.
                              
                              [PJ] It looks like the writeADODataset() API ignores any filenames
                                   and derives them from scratch, so the below is not strictly necessary.
                                   However, someone may override this API and find these values useful.
                                   Also, the above may change in the future. */
                            if lbChangeset.RecordADOFilename ne '':u then
                                lbSelected.cFilename = lbChangeset.RecordADOFilename.
                            else
                                lbSelected.cFilename = lbChangeset.DatasetADOFilename.
                        end.    /* changeset */
                    end.    /* CHANGESET */
                    else
                    do:
                        create lbSelected.
                        assign lbSelected.dataset_code = lbRecordset.DatasetCode
                               lbSelected.cKey = lbRecordset.KeyValue
                               lbSelected.cFilename = lbRecordset.Filename.
                    end.    /* normal record */
                end.    /* RECORDSET-LOOP: each recordset */
            end.    /* each ADOdataset (not allmodified) */
        end.    /* specify data to dump */
        
        hRecordset = buffer lbSelected:handle.
        hDataset = buffer lbDataset:handle.
        
        run getDatasetDefaults in ghDeploymentHelper (hDataset, hRecordset) no-error.
        if error-status:error or return-value ne '':u then
        do:
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName, return-value).
            next DUMP-DATASET-LOOP.
        end.    /* error */
        
        if lbDumpDataset.DefaultTarget eq '':u or lbDumpDataset.DefaultTarget eq ? then
            lbDumpDataset.DefaultTarget = lbDumpDataset.Target + '/db/icf/dump':u.
        
        lbDumpDataset.Target = replace(lbDumpDataset.Target,
                                       '#DeploymentRoot#':u,
                                       {fnarg getDeploymentRoot pcReleaseVersion}).
        lbDumpDataset.DefaultTarget = replace(lbDumpDataset.DefaultTarget,
                                              '#DeploymentRoot#':u,
                                              {fnarg getDeploymentRoot pcReleaseVersion}).
        
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-DEBUG}, cTaskName,
                        'Done gathering info, now preparing to run task ' + string(lbTask.TaskId)
                        + ' using ' + cApiMethod + ' in  ' + cApiFile).
        if cApiMethod eq '<none>':u then
        do on stop undo, leave:
            run value(cApiFile) ( lbDumpDataset.Target,
                                  lbDumpDataset.DefaultTarget,
                                  lbDumpDataset.ResetDataModified,
                                  lbDumpDataset.DeployDeletions,
                                  lbDumpDataset.RemoveDeletions,
                                  lbDumpDataset.DeployAllModified,
                                  lbDumpDataset.DeployFullDataset,
                                  hDataset,
                                  hRecordset,
                                  lbDumpDataset.DeployByDate,
                                  (if available lbDateRange then lbDateRange.StartDate else ?),
                                  (if available lbDateRange then lbDateRange.EndDate else ?)          ) no-error.
        end.
        else
        do:                                    
            {launch.i
                &PLIP  = cApiFile
                &IProc = cApiMethod
                &PList = "( lbDumpDataset.Target,
                            lbDumpDataset.DefaultTarget,
                            lbDumpDataset.ResetDataModified,
                            lbDumpDataset.DeployDeletions,
                            lbDumpDataset.RemoveDeletions,
                            lbDumpDataset.DeployAllModified,
                            lbDumpDataset.DeployFullDataset,
                            hDataset,
                            hRecordset,
                            lbDumpDataset.DeployByDate,
                            (if available lbDateRange then lbDateRange.StartDate else ?),
                            (if available lbDateRange then lbDateRange.EndDate else ?)          )"
                &AutoKill = yes
             }                  
        end.
        if error-status:error or return-value ne '':u then            
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName, return-value).
    end.    /* DUMP-DATASET-LOOP: each dumpdata */
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'ADO dataset dump complete').

    error-status:error = no.
    return.
END PROCEDURE.    /* DumpDataset */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DumpDefinition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DumpDefinition Procedure 
PROCEDURE DumpDefinition :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcReleaseVersion        as character            no-undo.
    define input parameter pcDeploymentType        as character            no-undo.
    
    define variable cApiFile        as character                        no-undo.
    define variable cApiMethod      as character                        no-undo.
    define variable cEncoding       as character                        no-undo.
    define variable cTaskName       as character                        no-undo.
    
    define buffer lbDumpDefinition for DumpDefinition.
    define buffer lbTask for Task.
    
    cTaskName = 'DumpDefinition':u.
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Starting data definition dump').
                     
    run getTaskApi in target-procedure (cTaskName, pcReleaseVersion,
                                        output cApiFile, output cApiMethod) no-error.
    if error-status:error or return-value ne '' then
    do:
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-FATAL}, cTaskName, return-value).
        return error return-value.
    end.    /* error */
    
    for each lbDumpDefinition where lbDumpDefinition.ReleaseVersion = pcReleaseVersion,
        each lbTask where
             lbTask.TaskId = lbDumpDefinition.TaskId and
             lbTask.ReleaseVersion = lbDumpDefinition.ReleaseVersion and
             lbTask.Enabled = yes and
             Can-do(pcDeploymentType, lbTask.DeploymentType)
             by lbDumpDefinition.TaskId:
        
        if lbDumpDefinition.Db eq '':u or lbDumpDefinition.Db eq ? then
        do:
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName,
                            'DB Name not specified for task ' + string(lbTask.TaskId)).
            next.
        end.    /* blank db */                
        else
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Dumping definition for ' + lbDumpDefinition.Db).
                
        cEncoding = lbDumpDefinition.Encoding.
        if cEncoding eq ? then
            cEncoding = {fnarg getEncoding pcReleaseVersion}.
                    
        lbDumpDefinition.Target = replace(lbDumpDefinition.Target,
                                          '#DeploymentRoot#':u,
                                          {fnarg getDeploymentRoot pcReleaseVersion}).
                                                                   
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-DEBUG}, cTaskName,
                        'Done gathering info, now preparing to run task ' + string(lbTask.TaskId)
                        + ' using ' + cApiMethod + ' in  ' + cApiFile).
        if cApiMethod eq '<none>':u then
        do on stop undo, leave:
            run value(cApiFile) (input lbDumpDefinition.Db,
                                 input lbDumpDefinition.Filename,
                                 input lbDumpDefinition.Target,
                                 input cEncoding,
                                 input lbDumpDefinition.RcodePosition ) no-error.
        end.
        else
        do:
            {launch.i
                &PLIP  = cApiFile
                &IProc = cApiMethod
                &PList = "(input lbDumpDefinition.Db,
                           input lbDumpDefinition.Filename,
                           input lbDumpDefinition.Target,
                           input cEncoding,
                           input lbDumpDefinition.RcodePosition )"
                &AutoKill = yes
             }         
        end.
        if error-status:error or return-value ne '':u then            
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName, return-value).
    end.    /* each dumpdata */
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Data definition dump complete').

    error-status:error = no.
    return.
END PROCEDURE.    /* DumpDefinition */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DumpEntityCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DumpEntityCache Procedure 
PROCEDURE DumpEntityCache :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcReleaseVersion        as character            no-undo.
    define input parameter pcDeploymentType        as character            no-undo.

    define variable cApiFile        as character                        no-undo.
    define variable cApiMethod      as character                        no-undo.
    define variable cEntityList     as character                        no-undo.
    define variable cClassName      as character                        no-undo.
    define variable iLoop           as integer                          no-undo.
    define variable cTaskName       as character                        no-undo.
    
    define buffer lbDumpEntityCache for DumpEntityCache.
    define buffer lbTask for Task.
    define buffer lbEntity for Entity.
    define buffer lbChangeset for ttReleaseChangeset.
    
    cTaskName = 'DumpEntityCache':u.
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Starting dump of entity cache').
                     
    run getTaskApi in target-procedure (cTaskName, pcReleaseVersion,
                                        output cApiFile, output cApiMethod) no-error.
    if error-status:error or return-value ne '':u then
    do:
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-FATAL}, cTaskName, return-value).
        return error return-value.
    end.    /* error */
    
    for each lbDumpEntityCache where lbDumpEntityCache.ReleaseVersion = pcReleaseVersion,
        each lbTask where
             lbTask.TaskId = lbDumpEntityCache.TaskId and
             lbTask.ReleaseVersion = lbDumpEntityCache.ReleaseVersion and
             lbTask.Enabled = yes and
             Can-do(pcDeploymentType, lbTask.DeploymentType)
             by lbDumpEntityCache.TaskId:
        
        cEntityList = '':u.
        ENTITY-LOOP:
        for each lbEntity where
                 lbEntity.ReleaseVersion = lbTask.ReleaseVersion and
                 lbEntity.TaskId = lbTask.TaskId and
                 Can-do(pcDeploymentType, lbTask.DeploymentType):
            case lbEntity.Name:
                when '{&CHANGESET}':u then
                do:
                    /* only add Entity objects to the list */
                    for each lbChangeset where
                             lbChangeset.DatasetCode = 'Rycso':u and
                             lbChangeset.Deletion = No and
                             lbChangeset.rycso_StaticObject = Yes:                                 
                        if dynamic-function('classIsA':u in gshRepositoryManager,
                                            lbChangeset.rycso_Class, 'Entity':u ) and
                           not can-do(cEntityList, lbChangeset.DSKeyFieldValue) then
                            cEntityList = cEntityList + ',':u + lbChangeset.DSKeyFieldValue.
                    end.    /* changeset loop */
                end.    /* changeset */
                when '{&ALL}':u then
                do:
                    cEntityList = '*':u.
                    leave ENTITY-LOOP.
                end.    /* All */
                otherwise
                    if not can-do(cEntityList, lbEntity.Name) then
                        cEntityList = cEntityList + ',':u + lbEntity.Name.
            end case.    /* name */
        end.    /* ENTITY-LOOP: each entity */
        cEntityList = left-trim(cEntityList, ',':U).

        lbDumpEntityCache.Target = replace(lbDumpEntityCache.Target,
                                           '#DeploymentRoot#':u,
                                           {fnarg getDeploymentRoot pcReleaseVersion}).
        
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-DEBUG}, cTaskName,
                        'Done gathering info, now preparing to run task ' + string(lbTask.TaskId)
                        + ' using ' + cApiMethod + ' in  ' + cApiFile).
        if cApiMethod eq '<none>':u then
        do on stop undo, leave:
            run value(cApiFile) ( input cEntityList,
                                  input lbDumpEntityCache.LanguageList,
                                  input lbDumpEntityCache.Target ) no-error.
        end.
        else
        do:                         
            {launch.i
                &PLIP  = cApiFile
                &IProc = cApiMethod
                &PList = "( input cEntityList,
                            input lbDumpEntityCache.LanguageList,
                            input lbDumpEntityCache.Target )"
                &AutoKill = yes
             }
         end.
         if error-status:error or return-value ne '':u then            
             publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName, return-value).
    end.    /* each DumpEntityCache */
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Dump of entity cache complete').
    
    error-status:error = no.
    return.
END PROCEDURE.    /* DumpEntityCache */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DumpIncrementalDefs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DumpIncrementalDefs Procedure 
PROCEDURE DumpIncrementalDefs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcReleaseVersion        as character            no-undo.
    define input parameter pcDeploymentType        as character            no-undo.

    define variable cApiFile        as character                        no-undo.
    define variable cApiMethod      as character                        no-undo.
    define variable cEncoding       as character                        no-undo.
    define variable cTaskName       as character                        no-undo.
    
    define buffer lbDumpIncrementalDefs for DumpIncrementalDefs.
    define buffer lbTask for Task.
    
    cTaskName = 'DumpIncrementalDefs':u.
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Starting dump of incremental definitions').
                     
    run getTaskApi in target-procedure (cTaskName, pcReleaseVersion,
                                        output cApiFile, output cApiMethod) no-error.
    if error-status:error or return-value ne '':u then
    do:
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-FATAL}, cTaskName, return-value).
        return error return-value.
    end.    /* error */
    
    for each lbDumpIncrementalDefs where lbDumpIncrementalDefs.ReleaseVersion = pcReleaseVersion,
        each lbTask where
             lbTask.TaskId = lbDumpIncrementalDefs.TaskId and
             lbTask.ReleaseVersion = lbDumpIncrementalDefs.ReleaseVersion and
             lbTask.Enabled = yes and
             Can-do(pcDeploymentType, lbTask.DeploymentType)
             by lbDumpIncrementalDefs.TaskId:
        
        if lbDumpIncrementalDefs.SourceDb eq '':u or lbDumpIncrementalDefs.SourceDb eq ? then
        do:
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName,
                            'Source DB not specified for task ' + string(lbTask.TaskId)).
            next.
        end.    /* blank db */                

        if lbDumpIncrementalDefs.TargetDb eq '':u or lbDumpIncrementalDefs.TargetDb eq ? then
        do:
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName,
                             'Target DB not specified for task ' + string(lbTask.TaskId)).
            next.
        end.    /* blank db */                
                
        cEncoding = lbDumpIncrementalDefs.Encoding.
        if cEncoding eq ? then
            cEncoding = {fnarg getEncoding pcReleaseVersion}.
            
        /* Setup output directory, file defaults */
        if lbDumpIncrementalDefs.TargetFile eq ? or lbDumpIncrementalDefs.TargetFile eq '':u then
            lbDumpIncrementalDefs.TargetFile = 'delta.df':u.
        
        if lbDumpIncrementalDefs.TargetDirectory eq ? or lbDumpIncrementalDefs.TargetDirectory eq '':u then
            lbDumpIncrementalDefs.TargetDirectory = session:temp-directory.

        lbDumpIncrementalDefs.TargetDirectory = replace(lbDumpIncrementalDefs.TargetDirectory,
                                                       '#DeploymentRoot#':u,
                                                       {fnarg getDeploymentRoot pcReleaseVersion}).
        
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-DEBUG}, cTaskName, cTaskName,
                        'Done gathering info, now preparing to run task ' + string(lbTask.TaskId)
                        + ' using ' + cApiMethod + ' in  ' + cApiFile).
        if cApiMethod eq '<none>':u then
        do on stop undo, leave:
            run value(cApiFile) ( input lbDumpIncrementalDefs.SourceDB,
                                  input lbDumpIncrementalDefs.TargetDB,
                                  input (lbDumpIncrementalDefs.TargetDirectory + '/':u + lbDumpIncrementalDefs.TargetFile),
                                  input cEncoding,
                                  input lbDumpIncrementalDefs.IndexMode,
                                  input lbDumpIncrementalDefs.RenameFile ) no-error.
        end.
        else
        do:                        
            {launch.i
                &PLIP  = cApiFile
                &IProc = cApiMethod
                &PList = "( input lbDumpIncrementalDefs.SourceDB,
                            input lbDumpIncrementalDefs.TargetDB,
                            input (lbDumpIncrementalDefs.TargetDirectory + '/':u + lbDumpIncrementalDefs.TargetFile),
                            input cEncoding,
                            input lbDumpIncrementalDefs.IndexMode,
                            input lbDumpIncrementalDefs.RenameFile )"
                &AutoKill = yes
             }
         end.
        if error-status:error or return-value ne '':u then            
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName, return-value).
    end.    /* each dumpdata */
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Incremental definition dump complete').
        
    error-status:error = no.
    return.
END PROCEDURE.    /* DumpIncrementalDefs */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DumpSeqValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DumpSeqValue Procedure 
PROCEDURE DumpSeqValue :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcReleaseVersion        as character            no-undo.
    define input parameter pcDeploymentType        as character            no-undo.
    
    define variable cApiFile        as character                        no-undo.
    define variable cApiMethod      as character                        no-undo.
    define variable cEncoding       as character                        no-undo.
    define variable cTaskName       as character                        no-undo.
    
    define buffer lbDumpSeqValue for DumpSeqValue.
    define buffer lbTask for Task.
    
    cTaskName = 'DumpSeqValue':u.
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Starting sequence value dump').
    
    run getTaskApi in target-procedure (cTaskName, pcReleaseVersion,
                                        output cApiFile, output cApiMethod) no-error.
    if error-status:error or return-value ne '' then
    do:
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-FATAL}, cTaskName, return-value).
        return error return-value.
    end.    /* error */
    
    for each lbDumpSeqValue where lbDumpSeqValue.ReleaseVersion = pcReleaseVersion,
        each lbTask where
             lbTask.TaskId = lbDumpSeqValue.TaskId and
             lbTask.ReleaseVersion = lbDumpSeqValue.ReleaseVersion and
             lbTask.Enabled = yes and
             Can-do(pcDeploymentType, lbTask.DeploymentType)
             by lbDumpSeqValue.TaskId:
                 
        if lbDumpSeqValue.Db eq '':u or lbDumpSeqValue.Db eq ? then
        do:
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName,
                            'DB Name not specified for task ' + string(lbTask.TaskId)).
            next.
        end.    /* blank db */                
        else
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Dumping sequence values for ' + lbDumpSeqValue.Db).
                
        cEncoding = lbDumpSeqValue.Encoding.
        if cEncoding eq ? then
            cEncoding = {fnarg getEncoding pcReleaseVersion}.

        lbDumpSeqValue.Target = replace(lbDumpSeqValue.Target,
                                        '#DeploymentRoot#':u,
                                        {fnarg getDeploymentRoot pcReleaseVersion}).

        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-DEBUG}, cTaskName, 
                        'Done gathering info, now preparing to run task ' + string(lbTask.TaskId)
                        + ' using ' + cApiMethod + ' in  ' + cApiFile).
        if cApiMethod eq '<none>':u then
        do on stop undo, leave:
            run value(cApiFile) (input lbDumpSeqValue.Db, input lbDumpSeqValue.Target, input cEncoding) no-error.
        end.
        else
        do:                        
            {launch.i
                &PLIP  = cApiFile
                &IProc = cApiMethod
                &PList = "(input lbDumpSeqValue.Db, input lbDumpSeqValue.Target, input cEncoding)"
                &AutoKill = yes
            }
        end.
        if error-status:error or return-value ne '':u then            
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName, return-value).
    end.    /* each dumpdata */
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Sequence value dump complete').
    
    error-status:error = no.
    return.
END PROCEDURE.    /* DumpSeqValue */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-executeCategoryTasks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE executeCategoryTasks Procedure 
PROCEDURE executeCategoryTasks :
/*------------------------------------------------------------------------------
  Purpose:     Executes all tasks for a category.
  Parameters:  (I) pcTaskCategory -
               (I) pcReleaseVersion - not used here, but passed in to tasks
               (I) pcDeploymentType - not used here, but passed in to tasks
  Notes: - pcReleaseVersion may be used 'correctly' as part of the TaskOrder
           search criteria in the future.
------------------------------------------------------------------------------*/
    define input parameter pcTaskCategory        as character            no-undo.
    define input parameter pcReleaseVersion      as character            no-undo.
    define input parameter pcDeploymentType      as character            no-undo.
    
    define variable cMessage            as character                    no-undo.
    
    define buffer lbTaskOrder for TaskOrder.
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u, 'Running build tasks').
    for each lbTaskOrder where
             lbTaskOrder.ReleaseVersion = ? and
             lbTaskOrder.TaskCategory = pcTaskCategory
             by lbTaskOrder.TaskOrder:
                 
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u,
                        'Running task ' + lbTaskOrder.TaskName + ' (Order: '+ string(lbTaskOrder.TaskOrder) + ')').
        run value(lbTaskOrder.TaskApi) in target-procedure (pcReleaseVersion, pcDeploymentType) no-error.
        if error-status:error or return-value ne '':u then
        do:
            cMessage = return-value.
            if cMessage eq ? or cMessage eq '':u then
                cMessage = error-status:get-message(1).
            
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-FATAL}, '{&LOG-CATEGORY}':u, cMessage).
            return error cMessage.
        end.    /* error running task */
    end.    /* loop through build tasks */
    
    error-status:error = no.
    return.
END PROCEDURE.    /* executeCategoryTasks */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ExportReleaseVersion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExportReleaseVersion Procedure 
PROCEDURE ExportReleaseVersion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       - only one release version is generated per deployment
                           - The functionality in this task could be replaced by
                 the following individual tasks, for more fine-grained 
                 control over the release:                               
                                        LoadChangeset
                                        CreatePatchFile
                                        CreateADOListFile
                                        DumpDataset
------------------------------------------------------------------------------*/
    define input parameter pcReleaseVersion        as character            no-undo.
    define input parameter pcDeploymentType        as character            no-undo.
    
    define variable cApiFile        as character                        no-undo.
    define variable cApiMethod      as character                        no-undo.
    define variable cEncoding       as character                        no-undo.
    define variable cTaskName       as character                        no-undo.
    
    define buffer lbExportReleaseVersion for ExportReleaseVersion.
    define buffer lbTask for Task.
    define buffer lbDeployment for Deployment.
    
    cTaskName = 'ExportReleaseVersion':u.
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Starting release generation').
    
    run getTaskApi in target-procedure (cTaskName, pcReleaseVersion,
                                        output cApiFile, output cApiMethod) no-error.
    if error-status:error or return-value ne '' then
    do:
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-FATAL}, cTaskName, return-value).
        return error return-value.
    end.    /* error */
    
    find first lbExportReleaseVersion where lbExportReleaseVersion.ReleaseVersion = pcReleaseVersion no-error.
    if available lbExportReleaseVersion then
    for first lbTask where
              lbTask.TaskId = lbExportReleaseVersion.TaskId and
              lbTask.ReleaseVersion = lbExportReleaseVersion.ReleaseVersion and
              lbTask.Enabled = yes and
              Can-do(pcDeploymentType, lbTask.DeploymentType)
              by lbExportReleaseVersion.TaskId:
        
        find first lbDeployment where lbDeployment.ReleaseVersion = lbTask.ReleaseVersion.
        
        lbExportReleaseVersion.Target = replace(lbExportReleaseVersion.Target,
                                                '#DeploymentRoot#':u,
                                                {fnarg getDeploymentRoot pcReleaseVersion}).
        
        if lbExportReleaseVersion.DefaultTarget eq ? or lbExportReleaseVersion.DefaultTarget eq '':u then
            lbExportReleaseVersion.DefaultTarget = lbExportReleaseVersion.Target + '/db/icf/dump':u.
        
        lbExportReleaseVersion.DefaultTarget = replace(lbExportReleaseVersion.DefaultTarget,
                                                        '#DeploymentRoot#':u,
                                                        {fnarg getDeploymentRoot pcReleaseVersion}).
        
        lbExportReleaseVersion.AdoListingFile = replace(lbExportReleaseVersion.AdoListingFile,
                                                        '#DeploymentRoot#':u,
                                                        {fnarg getDeploymentRoot pcReleaseVersion}).
        lbExportReleaseVersion.AdoListingFile = replace(lbExportReleaseVersion.AdoListingFile,
                                                        '#PatchLevel#':u, lbExportReleaseVersion.PatchLevel).
        
        lbExportReleaseVersion.PatchFileName = replace(lbExportReleaseVersion.PatchFileName,
                                                        '#DeploymentRoot#':u,
                                                        {fnarg getDeploymentRoot pcReleaseVersion}).
        lbExportReleaseVersion.PatchFileName = replace(lbExportReleaseVersion.PatchFileName,
                                                        '#PatchLevel#':u, lbExportReleaseVersion.PatchLevel).


        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName,
                                      'Generating release for task ' + string(lbTask.TaskId)).
        
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-DEBUG}, cTaskName, cTaskName,
                        'Done gathering info, now preparing to run task ' + string(lbTask.TaskId)
                        + ' using ' + cApiMethod + ' in  ' + cApiFile).
        if cApiMethod eq '<none>':u then
        do on stop undo, leave:
            run value(cApiFile) (lbDeployment.ReleaseVersion,
                                 lbDeployment.PreviousRelease,
                                 lbExportReleaseVersion.GenerateVersionData,
                                 lbExportReleaseVersion.ResetDataModified,
                                 lbExportReleaseVersion.PatchFileName,
                                 lbExportReleaseVersion.GenerateADO,
                                 lbExportReleaseVersion.GenerateFullDataset,
                                 lbExportReleaseVersion.Target,
                                 lbExportReleaseVersion.DefaultTarget,
                                 lbExportReleaseVersion.AdoListingFile,
                                 lbExportReleaseVersion.PatchLevel         ) no-error.
        end.
        else
        do:                        
            {launch.i
                &PLIP  = cApiFile
                &IProc = cApiMethod
                &PList = "(lbDeployment.ReleaseVersion,
                           lbDeployment.PreviousRelease,
                           lbExportReleaseVersion.GenerateVersionData,
                           lbExportReleaseVersion.ResetDataModified,
                           lbExportReleaseVersion.PatchFileName,
                           lbExportReleaseVersion.GenerateADO,
                           lbExportReleaseVersion.GenerateFullDataset,
                           lbExportReleaseVersion.Target,
                           lbExportReleaseVersion.DefaultTarget,
                           lbExportReleaseVersion.AdoListingFile,
                           lbExportReleaseVersion.PatchLevel         )"
                &AutoKill = yes
             }
        end.             
        if error-status:error or return-value ne '':u then            
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName, return-value).
    end.    /* each dumpdata */
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Release generation complete').
    
    error-status:error = no.
    return.
END PROCEDURE.    /* ExportReleaseVersion */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Generate4GLObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generate4GLObjects Procedure 
PROCEDURE Generate4GLObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcReleaseVersion        as character            no-undo.
    define input parameter pcDeploymentType        as character            no-undo.

    define variable cApiFile        as character                        no-undo.
    define variable cApiMethod      as character                        no-undo.
    define variable cCompileOptions as character                        no-undo.
    define variable cTaskName       as character                        no-undo.
        
    define buffer lbGenerate4GLObjects for Generate4GLObjects.
    define buffer lbTask for Task.
    define buffer lbChangeset for ttReleaseChangeset.
    define buffer lbObjects for Objects.
    define buffer lbObjectType for ObjectType.
    define buffer lbProductModule for ProductModule.
    define buffer lbCriteria for ttCriteria.
    define buffer lbQuery for Queries.
    
    cTaskName = 'Generate4GLObjects':u.
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Starting generation of 4GL objects (PGEN)').
    
    run getTaskApi in target-procedure (cTaskName, pcReleaseVersion,
                                        output cApiFile, output cApiMethod) no-error.
    if error-status:error or return-value ne '':u then
    do:
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-FATAL}, cTaskName, return-value).
        return error return-value.
    end.    /* error */
    
    for each lbGenerate4GLObjects where lbGenerate4GLObjects.ReleaseVersion = pcReleaseVersion,
        each lbTask where
             lbTask.TaskId = lbGenerate4GLObjects.TaskId and
             lbTask.ReleaseVersion = lbGenerate4GLObjects.ReleaseVersion and
             lbTask.Enabled = yes and
             Can-do(pcDeploymentType, lbTask.DeploymentType)
             by lbGenerate4GLObjects.TaskId:
                 
        empty temp-table lbCriteria.
        
        /* GAther any queries */
        for each lbQuery where
                 lbQuery.ReleaseVersion = lbTask.ReleaseVersion and
                 lbQuery.TaskId = lbTask.TaskId and
                 can-do(pcDeploymentType, lbQuery.DeploymentType):
            create lbCriteria.
            assign lbCriteria.Type = 'Query':u
                   lbCriteria.Primary = lbQuery.PrepareString
                   lbCriteria.Secondary = lbQuery.BufferList.
        end.    /* query */
            
        OBJECT-LOOP:
        for each lbObjects where
                 lbObjects.ReleaseVersion = lbTask.ReleaseVersion and
                 lbObjects.TaskId = lbTask.TaskId and
                 can-do(pcDeploymentType, lbObjects.DeploymentType):
            case lbObjects.Name:
                when '{&CHANGESET}':u then
                do:
                    for each lbChangeset where
                             lbChangeset.DatasetCode = 'Rycso':u and
                             lbChangeset.Deletion = no:
                        /* We can only generate dynamic objects or DataFIelds, which
                           are static (but can be distinguished by class). */
                        if lbChangeset.rycso_StaticObject = yes and
                           not dynamic-function('ClassIsA':u in gshRepositoryManager,
                                               rycso_Class, 'DataField':u ) then
                            next.    /* changeset */
                        
                        if not can-find(first lbCriteria where
                                              lbCriteria.Type = 'Object':u and
                                              lbCriteria.Primary = lbChangeset.DSKeyFieldValue) then
                        do:
                            create lbCriteria.
                            assign lbCriteria.Type = 'Object':u
                                   lbCriteria.Primary = lbChangeset.DSKeyFieldValue.
                        end.    /* criteria */
                    end.    /* each changeset */
                end.    /* changeset */
                when '{&ALL}':u then
                do:
                    /* If we want to dump ALL, then create a query rather than building 
                       a list of objects. */
                    create lbCriteria.
                    assign lbCriteria.Type = 'Query':u
                           lbCriteria.Primary = 'for each ryc_smartobject no-lock':u
                           lbCriteria.Secondary = 'ryc_smartobject':u.
                    leave OBJECT-LOOP.
                end.    /* all */
                otherwise
                do:
                    if not can-find(first lbCriteria where
                                          lbCriteria.Type = 'Object':u and
                                          lbCriteria.Primary = lbObjects.Name) then
                    do:
                        create lbCriteria.
                        assign lbCriteria.Type = 'Object':u
                               lbCriteria.Primary = lbObjects.Name.
                    end.    /* criteria */
                end.    /* others */
            end case.    /* object name */
        end.    /* OBJECT-LOOP: objects */
            
        for each lbObjectType where
                 lbObjectType.ReleaseVersion = lbTask.ReleaseVersion and
                 lbObjectType.TaskId = lbTask.TaskId and
                 can-do(pcDeploymentType, lbObjectType.DeploymentType):
            create lbCriteria.
            assign lbCriteria.Type = 'ObjectType':u
                   lbCriteria.Primary = lbObjectType.Name.
        end.    /* object type */
        
        for each lbProductModule where
                 lbProductModule.ReleaseVersion = lbTask.ReleaseVersion and
                 lbProductModule.TaskId = lbTask.TaskId and
                 can-do(pcDeploymentType, lbProductModule.DeploymentType):
            create lbCriteria.
            assign lbCriteria.Type = 'ProductModule':u
                   lbCriteria.Primary = lbProductModule.Name.
        end.    /* product module */                            

        /* Build a list of compile options */
        if lbGenerate4GLObjects.CompileMD5 then cCompileOptions = cCompileOptions + ',MD5':u.
        if lbGenerate4GLObjects.CompileMinSize then cCompileOptions = cCompileOptions + ',MIN-SIZE':u.
        
        lbGenerate4GLObjects.Target = replace(lbGenerate4GLObjects.Target,
                                             '#DeploymentRoot#':u,
                                             {fnarg getDeploymentRoot pcReleaseVersion}).        

        lbGenerate4GLObjects.CompileTarget = replace(lbGenerate4GLObjects.CompileTarget,
                                                     '#DeploymentRoot#':u,
                                                     {fnarg getDeploymentRoot pcReleaseVersion}).        
        
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-DEBUG}, cTaskName, 
                          'Done gathering info, now preparing to run task ' + string(lbTask.TaskId)
                          + ' using ' + cApiMethod + ' in  ' + cApiFile).
        if cApiMethod eq '<none>':u then
        do on stop undo, leave:
            run value(cAPiFile) ( input lbGenerate4GLObjects.LanguageList,
                                  input lbGenerate4GLObjects.ResultCodeList,
                                  input lbGenerate4GLObjects.Target,
                                  input lbGenerate4GLObjects.CompileEnabled,
                                  input cCompileOptions,
                                  input lbGenerate4GLObjects.CompileTarget,
                                  input lbGenerate4GLObjects.IncludeContainedInstances,
                                  input lbGenerate4GLObjects.SuperProcedureLocation,
                                  input lbGenerate4GLObjects.IncludeViewersForDatafields,
                                  input lbGenerate4GLObjects.ThinRendering,
                                  input lbGenerate4GLObjects.PluginProcedure,
                                  input buffer lbCriteria:handle ) no-error.
        end.
        else
        do:
            {launch.i
                &PLIP  = cApiFile
                &IProc = cApiMethod
                &PList = "( input lbGenerate4GLObjects.LanguageList,
                            input lbGenerate4GLObjects.ResultCodeList,
                            input lbGenerate4GLObjects.Target,
                            input lbGenerate4GLObjects.CompileEnabled,
                            input cCompileOptions,
                            input lbGenerate4GLObjects.CompileTarget,
                            input lbGenerate4GLObjects.IncludeContainedInstances,
                            input lbGenerate4GLObjects.SuperProcedureLocation,
                            input lbGenerate4GLObjects.IncludeViewersForDatafields,
                            input lbGenerate4GLObjects.ThinRendering,
                            input lbGenerate4GLObjects.PluginProcedure,
                            input buffer lbCriteria:handle )"
                &AutoKill = yes
             }
        end.
        if error-status:error or return-value ne '':u then            
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName, return-value).
    end.    /* each Generate4GLObjects */
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Generation of 4GL objects complete').
    
    error-status:error = no.
    return.
END PROCEDURE.    /* Generate4GLObjects */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTaskApi) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTaskApi Procedure 
PROCEDURE getTaskApi :
/*------------------------------------------------------------------------------
  Purpose:     Returns the name of the API to run for a task in a release, and also
                           the method name (if any).
  Parameters:  (I) pcTaskName
                   (I) pcReleaseVersion
                   (O) pcApiFile
                   (O) pcApiMethod
  Notes:       - initializeTaskApi() creates the default values for the ApiOverride
                 table.
------------------------------------------------------------------------------*/
    define input  parameter pcTaskName       as character                no-undo.
    define input  parameter pcReleaseVersion as character                no-undo.
    define output parameter pcApiFile        as character                no-undo.
    define output parameter pcApiMethod      as character                no-undo.

    define buffer lbApiOverride for ApiOverride.
    
    find first lbApiOverride where
               lbApiOverride.ReleaseVersion = pcReleaseVersion and
               lbApiOverride.TaskName       = pcTaskName and
               lbApiOverride.Enabled        = yes
               no-error.
    if not available lbApiOverride then
        find first lbApiOverride where
                   lbApiOverride.ReleaseVersion = ? and
                   lbApiOverride.TaskName       = pcTaskName and
                   lbApiOverride.Enabled        = yes
                   no-error.
    if available lbApiOverride then
    do:
        assign pcApiFile   = lbApiOverride.ApiFile
               pcApiMethod = lbApiOverride.ApiMethod.
        if pcApiFile eq '':u or pcApiFile eq ? then
            return error {aferrortxt.i 'AF' '5' '?' '?' '"API File"' "'The API definition for task ' + pcTaskName + ' is invalid.'"}.
    end.    /* available API */
    else
        return error {aferrortxt.i 'AF' '39' '?' '?' '"API definition"' "'The API definition for task ' + pcTaskName + ' was not found.'"}.

    if pcApiMethod eq '':u or pcApiMethod eq ? then
        pcApiMethod = '<None>':u.
    
    error-status:error = no.
    return.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeLogging) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeLogging Procedure 
PROCEDURE initializeLogging :
/*------------------------------------------------------------------------------
  Purpose:     Initializes the lbLogging functionality for the deployment.
  Parameters:  input table lbLogging (by-ref)
               input pcReleaseVersion
  Notes:       - If no lbLogging table was found, lbLogging is enabled with a default
                 Logging level of WARNING
------------------------------------------------------------------------------*/
    define input parameter table for Logging.
    define input parameter pcReleaseVersion        as character            no-undo.
    
    define buffer lbLogging for Logging.
    
    find first lbLogging where
               lbLogging.Enabled = yes and
               lbLogging.ReleaseVersion = pcReleaseVersion
               no-error.
    if not available lbLogging then
    do:
        create lbLogging.
        assign lbLogging.ReleaseVersion = pcReleaseVersion
               lbLogging.Enabled        = Yes
               lbLogging.LogLevel       = "Warning":u.
    end.    /* n/a lbLogging */
                  
    if lbLogging.Enabled then
    do:
        /* Convert the LogLevel into an integer value */
        lbLogging.LogLevelEnum = integer(entry(lookup(lbLogging.LogLevel, "{&LOG-LEVEL-ENUM}":u) + 1, "{&LOG-LEVEL-ENUM}":u)) no-error.
        if lbLogging.LogLevelEnum eq ? or lbLogging.LogLevelEnum eq 0 then
            lbLogging.LogLevelEnum = {&LOG-LEVEL-WARNING}.
        
        /* Resolve tokens */
        lbLogging.LogFile =  replace(lbLogging.LogFile,
                                     '#DeploymentRoot#':u,
                                     {fnarg getDeploymentRoot pcReleaseVersion}).            
        
        /* Set a sensible default. */
        if lbLogging.LogFile eq ? or lbLogging.LogFile eq '':u then
            lbLogging.LogFile = session:temp-dir + '/deployment.log':u.
        
        /* Clear log */
        if not lbLogging.LogAppend then
        do:
            output stream sLogging to value(lbLogging.LogFile).
            output stream sLogging close.
        end.    /* don't append */
        
        {fnarg setLogFile lbLogging.LogFile}.
        {fnarg setLogCategory lbLogging.LogCategory}.
    end.    /* lbLogging enabled */
    
    /*  If lbLogging is enabled, LogLevelEnum will be > 0 */
    {fnarg setLogLevel lbLogging.LogLevelEnum}.
    
    /* Setup a listener so that anyone can log a message. */
    subscribe procedure target-procedure
        to 'ICFDA_logMessage':u
        anywhere
        run-procedure 'logMessage':u.
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u, 'Logging initialised').
    
    error-status:error = no.
    return.
END PROCEDURE.    /* initializeLogging */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-LoadChangeset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LoadChangeset Procedure 
PROCEDURE LoadChangeset :
/*------------------------------------------------------------------------------
  Purpose:     Loads the Changeset
  Parameters:  (I) pcReleaseVersion -
               (I) pcDeploymentType
  Notes:       - This procedure is only run if the deployment is for a DELTA 
                 deployment.
------------------------------------------------------------------------------*/
    define input parameter pcReleaseVersion        as character        no-undo.
    define input parameter pcDeploymentType        as character        no-undo.

    define variable cApiFile        as character                        no-undo.
    define variable cApiMethod      as character                        no-undo.
    define variable cMessage        as character                        no-undo.
    define variable cTaskName       as character                        no-undo.
    
    define buffer lbDeployment for Deployment.
    define buffer lbChangesetRecords for ttReleaseChangeset.
    define buffer lbChangeset for Changeset.
    define buffer lbTask for Task.
        
    cTaskName = 'LoadChangeset':u.
        
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Starting load of changeset data').
    
    run getTaskApi in target-procedure (cTaskName, pcReleaseVersion,
                                        output cApiFile, output cApiMethod) no-error.
    if error-status:error or return-value ne '' then
    do:
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-FATAL}, cTaskName, return-value).
        return error return-value.
    end.    /* error */
    
    empty temp-table lbChangesetRecords.
    
    /* We've already validated the existence of this record. */
    find lbDeployment where lbDeployment.ReleaseVersion = pcReleaseVersion.
    
    find first lbChangeset where lbChangeset.ReleaseVersion = pcReleaseVersion no-error.
    if available lbChangeset then
    for first lbTask where
              lbTask.TaskId = lbChangeset.TaskId and
              lbTask.ReleaseVersion = lbChangeset.ReleaseVersion and
              lbTask.Enabled = yes and
              Can-do(pcDeploymentType, lbTask.DeploymentType)
              by lbChangeset.TaskId:
        if cApiMethod eq '<none>':u then
        do on stop undo, leave:
            run value(cApiFile) (input  pcReleaseVersion,
                                 input  lbDeployment.PreviousRelease,
                                 input  lbChangeset.CreateReleaseVersion,
                                 input  lbChangeset.ResetDataModified,
                                 output table lbChangesetRecords) no-error.
        end.
        else
        do:
            {launch.i
                &PLIP  = cApiFile
                &IProc = cApiMethod
                &PList = "(input  pcReleaseVersion,
                           input  lbDeployment.PreviousRelease,
                           input  lbChangeset.CreateReleaseVersion,
                           input  lbChangeset.ResetDataModified,
                           output table lbChangesetRecords)"
                &AutoKill = yes
             }
        end.
        /* No changeset is not a good enough reason to abort the deployment. There could be no changes
               to data in this release. */
        if error-status:error or return-value ne '':u then
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName, return-value).
    end.    /* each Changeset */
    
    /* Post a message if there are no changes */    
    if not can-find(first lbChangesetRecords) then
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName,'No data changes found for release ' + pcReleaseVersion).
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Changeset data load complete').
    
    error-status:error = no.
    return.
END PROCEDURE.    /* LoadChangeset */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadConfigFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadConfigFile Procedure 
PROCEDURE loadConfigFile :
/*------------------------------------------------------------------------------
  Purpose:     Loads the deployment config file into a ProDataSet for manipulation.
  Parameters:  pcConfigFile  - the name of the file to load.
  Notes:       - we don't use logMessage here because we haven't initialised the
                 Logging yet.
------------------------------------------------------------------------------*/
    define input parameter pcConfigFile        as character              no-undo.
    define input parameter pcReleaseVersion    as character              no-undo.
    
    define variable lOK                    as logical                    no-undo.
    
    /* Validate file name */
    if pcConfigFile eq ? or pcConfigFile eq '':u then
        return error {aferrortxt.i 'AF' '1' '?' '?' '"XML config file"'}.
        
    /* Check for existence of file */
    if search(pcConfigFile) eq ? then
        return error {aferrortxt.i 'AF' '5' '?' '?' '"XML config file"' "'Config file = ' + pcConfigFile"}.
    
    /* Load XML file into PDS. */
    lOK = dataset dsDeployment:read-xml('File':u, pcConfigFile,
                                        ?,     /* read mode */
                                        ?,     /* schema location */
                                        ?,     /* override mapping */
                                        ?,     /* field type mapping */
                                        'Ignore':u         ) /*no-error.*/ . 
    if not lOK then 
        return error {aferrortxt.i 'AF' '117' '?' '?' '"load"' '' "error-status:get-message(1)"}.
    
    /* Make sure we've got the current ReleaseVersion */
    find first Deployment where Deployment.ReleaseVersion = pcReleaseVersion no-error.
    if not available Deployment then
        return error {aferrortxt.i 'AF' '39' '?' '?' '"release version"' "'The XML config file (' + pcConfigFile + ') does not contain a deployment with a release version of ' + pcReleaseVersion" }.    
    
    error-status:error = no.
    return.
END PROCEDURE.    /* loadConfigFile */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-logMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE logMessage Procedure 
PROCEDURE logMessage :
/*------------------------------------------------------------------------------
  Purpose:     Logs a message
  Parameters:  (I) piErrorType - defined in af/app/afloglevel.i
               (I) pcLogCategory - the category of message. allows us to only
                   log certain groups of messages.
               (I) pcMessage - the message text
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter piErrorType            as integer            no-undo.
    define input parameter pcLogCategory          as character          no-undo.
    define input parameter pcMessage              as character          no-undo.
    
    /* If Logging is disabled, LogLevel = 0 and thus will never log anything,
       since all log levels are > 0. */
    if {fn getLogLevel} ge piErrorType and
       can-do({fn getLogCategory}, pcLogCategory) then
    do:
        /* always append here. initializeLogging will take care of 
           initialising the log file correctly. */
        output stream sLogging to value({fn getLogFile}) append.
        put stream sLogging unformatted
                   iso-date(now) space(1)
                   pcMessage
                   skip.
        output stream sLogging close.
    end.    /* available lbLogging */
    
    error-status:error = no.
    return.
END PROCEDURE.    /* logMessage */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-UpdateDCU) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE UpdateDCU Procedure 
PROCEDURE UpdateDCU :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcReleaseVersion        as character            no-undo.
    define input parameter pcDeploymentType        as character            no-undo.

    define variable cApiFile        as character                            no-undo.
    define variable cApiMethod      as character                            no-undo.
    define variable lOK             as logical                              no-undo.
    define variable cLocation       as character                            no-undo.
    define variable hDcuUpdater     as handle                               no-undo.
    define variable cMessage        as character                            no-undo.
    define variable cTaskName       as character                            no-undo.
    define variable cEncoding       as character                            no-undo.
    
    define buffer lbUpdateDCU for UpdateDCU.
    define buffer lbTask for Task.
    define buffer lbDCUPatch for DCUPatch.
    
    cTaskName = 'UpdateDCU':u.
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Start update of DCU files').
    
    run getTaskApi in target-procedure (cTaskName, pcReleaseVersion,
                                        output cApiFile, output cApiMethod) no-error.
    if error-status:error or return-value ne '' then
    do:
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-FATAL}, cTaskName, return-value).
        return error return-value.
    end.    /* error */
    
    run startProcedure in target-procedure ("ONCE|af/app/afupdicfsp.p":U, output hDcuUpdater).
    if not valid-handle(hDcuUpdater) then
    do:
        cMessage = 'Unable to start DCU updater procedure (af/app/afupdicfsp.p)'.
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-FATAL}, cTaskName, cMessage).
        return error cMessage.
    end.    /* DS API not started */

    
    for each lbUpdateDCU where lbUpdateDCU.ReleaseVersion = pcReleaseVersion,
        each lbTask where
             lbTask.TaskId = lbUpdateDCU.TaskId and
             lbTask.ReleaseVersion = lbUpdateDCU.ReleaseVersion and
             lbTask.Enabled = yes and
             Can-do(pcDeploymentType, lbTask.DeploymentType)
             by lbUpdateDCU.TaskId:
        
        cEncoding = lbUpdateDCU.Encoding.
        if cEncoding eq ? then
            cEncoding = {fnarg getEncoding pcReleaseVersion}.
        
        lbUpdateDCU.SetupTypeFile = replace(lbUpdateDCU.SetupTypeFile, '#PatchLevel#':u, lbUpdateDCU.PatchLevel).
        lbUpdateDCU.SetupTypeFile = replace(lbUpdateDCU.SetupTypeFile,
                                            '#DeploymentRoot#':u,
                                            {fnarg getDeploymentRoot pcReleaseVersion}).
        
        /* Load the setup XML file into the dataset */
        run readSetupXML in hDcuUpdater (lbUpdateDCU.SetupTypeFile,
                                         output dataset Setups by-reference ) no-error.
        if error-status:error or return-value ne '':u then
        do:
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName,
                            'Error loading ' + lbUpdateDCU.SetupTypeFile + '. ':u + return-value).
            next.
        end.    /* error loading XML */
        
        for each lbDcuPatch where
                 lbDcuPatch.ReleaseVersion = lbTask.ReleaseVersion and
                 lbDcuPatch.TaskId = lbTask.TaskId:                     
            find first ttPch where
                       ttPch.SetupType = lbUpdateDCU.SetupTypeName and
                       ttPch.DbNaam = lbDCUPatch.Db
                       no-error.
            
            cLocation = replace(lbDcuPatch.NodeURL,
                                '#DeploymentRoot#':u,
                                  {fnarg getDeploymentRoot pcReleaseVersion}).
            cLocation = replace(cLocation, '#PatchLevel#':u, lbUpdateDCU.PatchLevel).
            
            case lbDcuPatch.Action:
                when 'Add':u then
                do:
                    create ttPch.
                    assign ttPch.SetupType = lbUpdateDCU.SetupTypeName
                           ttPch.DbNaam = lbDcuPatch.Db
                           ttPch.PatchLevel = lbUpdateDCU.PatchLevel
                           ttPch.DbBuild = lbDcuPatch.DbBuild
                           ttPch.NodeURL = cLocation.
                end.    /* Add */
                when 'Remove':u then
                do:
                    if not available ttPch then
                        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName,
                                    'Could not find patch record for removal. '
                                        + ' Setup Type: '  + lbUpdateDCU.SetupTypeName
                                        + ', PatchLevel ' + lbUpdateDCU.PatchLevel
                                        + ', NodeURL ' + lbDcuPatch.NodeURL ).
                    else
                        delete ttPch.
                end.    /* remove */
                when 'Replace':u then
                do:
                    /* if replacing, and not found, then create. */
                    if not available ttPch then
                    do:
                        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-DEBUG}, cTaskName,
                                    'Could not find patch record for replacement. '
                                        + ' Setup Type: ' + lbUpdateDCU.SetupTypeName
                                        + ', PatchLevel ' + lbUpdateDCU.PatchLevel
                                        + ', NodeURL ' + lbDcuPatch.NodeURL ).
                        create ttPch.
                        assign ttPch.SetupType = lbUpdateDCU.SetupTypeName
                               ttPch.DbNaam = lbDcuPatch.Db.
                    end.    /* n/a */
                    
                    assign ttPch.PatchLevel = lbUpdateDCU.PatchLevel
                           ttPch.DbBuild = lbDcuPatch.DbBuild
                           ttPch.NodeURL = cLocation.
                end.    /* replace */
            end case.    /* action */
        end.    /* DCU patch records */
        
        publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-DEBUG}, cTaskName, cTaskName,
                        'Done gathering info, now preparing to run task ' + string(lbTask.TaskId)
                        + ' using ' + cApiMethod + ' in  ' + cApiFile).
        if cApiMethod eq '<none>':u then
        do on stop undo, leave:
            run value(cApiFile) ( input lbUpdateDCU.SetupTypeFile,
                                  input cEncoding,
                                  input dataset Setups by-reference)  no-error.
        end.
        else
        do:
            {launch.i
                &PLIP  = cApiFile
                &IProc = cApiMethod
                &PList = "( input lbUpdateDCU.SetupTypeFile,
                            input cEncoding,
                            input dataset Setups by-reference)"
                &AutoKill = yes
             }
         end.
         if error-status:error or return-value ne '':u then
            publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-WARNING}, cTaskName, return-value).
    end.    /* each UpdateDCU */
    
    /* Kill off the DCU Updater procedure */
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-DEBUG}, cTaskName,
                    'Killing DCU updater procedure').
    apply 'Close':u to hDcuUpdater.
    delete object hDcuUpdater no-error.
    hDcuUpdater = ?.
    
    publish 'ICFDA_logMessage':u ( {&LOG-LEVEL-INFO}, cTaskName, 'Update of DCU files complete').
    
    error-status:error = no.
    return.
END PROCEDURE.    /* UpdateDCU */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-buildPatchStages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildPatchStages Procedure 
FUNCTION buildPatchStages RETURNS LOGICAL PRIVATE
        ( input pcReleaseVersion        as character ):
/*------------------------------------------------------------------------------
  Purpose: Builds PatchStage records (these are pre-defined)
        Notes: 
------------------------------------------------------------------------------*/
    define buffer lbPatchStage for PatchStage.
    
    create PatchStage.
    assign PatchStage.PatchLevel = pcReleaseVersion
           PatchStage.Stage = 'PreDelta':u
           PatchStage.Order = 10.
    
    create PatchStage.
    assign PatchStage.PatchLevel = pcReleaseVersion
           PatchStage.Stage = 'Delta':u
           PatchStage.Order = 20.
    
    create PatchStage.
    assign PatchStage.PatchLevel = pcReleaseVersion
           PatchStage.Stage = 'PostDelta':u
           PatchStage.Order = 30.
    
    create PatchStage.
    assign PatchStage.PatchLevel = pcReleaseVersion
           PatchStage.Stage = 'PreAdOLoad':u
           PatchStage.Order = 40.
    
    create PatchStage.
    assign PatchStage.PatchLevel = pcReleaseVersion
           PatchStage.Stage = 'ADOLoad':u
           PatchStage.Order = 50.
    
    create PatchStage.
    assign PatchStage.PatchLevel = pcReleaseVersion
           PatchStage.Stage = 'PostADOLoad':u
           PatchStage.Order = 60.
    
    error-status:error = no.
    return true.        
END FUNCTION.    /* buildPatchStages */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDeploymentRoot) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDeploymentRoot Procedure 
FUNCTION getDeploymentRoot RETURNS CHARACTER
    ( input pcReleaseVersion as character ):
/*------------------------------------------------------------------------------
  Purpose:  Gets the eployment root directory for the deployment.
    Notes: 
------------------------------------------------------------------------------*/
    define buffer lbDeployment for Deployment.
    
    /* We've checked already that this exists in loadConfigFile().
       We also made sure that we have a deployment root directory.    
     */
    find lbDeployment where lbDeployment.ReleaseVersion = pcReleaseVersion.
    
    return lbDeployment.DeploymentRoot.
END FUNCTION.    /* getDeploymentRoot */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEncoding) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEncoding Procedure 
FUNCTION getEncoding RETURNS CHARACTER
        ( input pcReleaseVersion as character ):
/*------------------------------------------------------------------------------
  Purpose:  Gets the default encoding for the deployment.
        Notes: 
------------------------------------------------------------------------------*/
    define variable cEncoding         as character                no-undo.
    
    define buffer lbDeployment for Deployment.
    /* We've checked already that this exists in loadConfigFile() */
    find lbDeployment where lbDeployment.ReleaseVersion = pcReleaseVersion.
    cEncoding = lbDeployment.Encoding.
    if cEncoding eq ? then
        cEncoding = 'UTF-8':u.
    
    return cEncoding.
END FUNCTION.    /* getEncoding */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLogCategory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLogCategory Procedure 
FUNCTION getLogCategory RETURNS CHARACTER
        (  ):
/*------------------------------------------------------------------------------
  Purpose: Pseudo-property getter
    Notes:
------------------------------------------------------------------------------*/
    return gc-PSEUDO-PROP-LogCategory.
END FUNCTION.    /* getLogCategory */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLogFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLogFile Procedure 
FUNCTION getLogFile RETURNS CHARACTER
        (  ):
/*------------------------------------------------------------------------------
  Purpose:  Pseudo-property getter
    Notes:
------------------------------------------------------------------------------*/
    error-status:error = no.
    return gc-PSEUDO-PROP-LogFile.
END FUNCTION.    /* getLogFile */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLogLevel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLogLevel Procedure 
FUNCTION getLogLevel RETURNS INTEGER
        (  ):
/*------------------------------------------------------------------------------
  Purpose: Pseudo-property getter
    Notes:
------------------------------------------------------------------------------*/
    return gc-PSEUDO-PROP-LogLevel.
END FUNCTION.    /* getLogLevel */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeTaskApi) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initializeTaskApi Procedure 
FUNCTION initializeTaskApi RETURNS LOGICAL private
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose: This function creates ApiOverride records for all tasks                 
    Notes: - These ApiOverrides all have unknown ReleaseVersion fields. The getTaskApi
             function knows this and will look for these records after looking for
             a specific override.
------------------------------------------------------------------------------*/
    define buffer lbApiOverride for ApiOverride.
    
    /* LoadChangeset */
    create lbApiOverride.
    assign lbApiOverride.Enabled = yes
           lbApiOverride.TaskName = 'LoadChangeset':u
           lbApiOverride.ApiFile = 'af/app/gscddxmlp.p':u
           lbApiOverride.ApiMethod = 'buildReleaseChangeset':u
           lbApiOverride.ReleaseVersion = ?.
    
    /* Dump .D (“DumpData”) */
    create lbApiOverride.
    assign lbApiOverride.Enabled = yes
           lbApiOverride.TaskName = 'DumpData':u
           lbApiOverride.ApiFile = 'af/app/afdmpdatap.p':u
           lbApiOverride.ApiMethod = '':u
           lbApiOverride.ReleaseVersion = ?.
    
    /* Dump .DF (“DumpDefinition”) */
    create lbApiOverride.
    assign lbApiOverride.Enabled = yes
           lbApiOverride.TaskName = 'DumpDefinition':u
           lbApiOverride.ApiFile = 'af/app/afdmpdefsp.p':u
           lbApiOverride.ApiMethod = '':u
           lbApiOverride.ReleaseVersion = ?.
    
    /* Dump sequence current values (“DumpSeqValue”) */
    create lbApiOverride.
    assign lbApiOverride.Enabled = yes
           lbApiOverride.TaskName = 'DumpSeqValue':u
           lbApiOverride.ApiFile = 'af/app/afdmpseqvp.p':u
           lbApiOverride.ApiMethod = '':u
           lbApiOverride.ReleaseVersion = ?.
    
    /* Build release (“ExportReleaseVersion”) */
    create lbApiOverride.
    assign lbApiOverride.Enabled = yes
           lbApiOverride.TaskName = 'ExportReleaseVersion':u
           lbApiOverride.ApiFile = 'af/app/gscddxmlp.p':u
           lbApiOverride.ApiMethod = 'exportReleaseVersion':u
           lbApiOverride.ReleaseVersion = ?.
    
    /* Dump Datasets (“DumpDataset”) */
    create lbApiOverride.
    assign lbApiOverride.Enabled = yes
           lbApiOverride.TaskName = 'DumpDataset':u
           lbApiOverride.ApiFile = 'af/app/gscddxmlp.p':u
           lbApiOverride.ApiMethod = 'writeADOSet':u
           lbApiOverride.ReleaseVersion = ?.
    
    /* Create incremental DF (“DumpIncrementalDefs”) */
    create lbApiOverride.
    assign lbApiOverride.Enabled = yes
           lbApiOverride.TaskName = 'DumpIncrementalDefs':u
           lbApiOverride.ApiFile = 'af/app/afdumpincp.p':u
           lbApiOverride.ApiMethod = '':u
           lbApiOverride.ReleaseVersion = ?.
    
    /* Build Cache: Class (“DumpClassCache”) */
    create lbApiOverride.
    assign lbApiOverride.Enabled = yes
           lbApiOverride.TaskName = 'DumpClassCache':u
           lbApiOverride.ApiFile = 'ry/app/rydesmngrp.i':u
           lbApiOverride.ApiMethod = 'exportClassCache':u
           lbApiOverride.ReleaseVersion = ?.
    /* Build Cache: Entity (“DumpEntityCache”) */
    create lbApiOverride.
    assign lbApiOverride.Enabled = yes
           lbApiOverride.TaskName = 'DumpEntityCache':u
           lbApiOverride.ApiFile = 'ry/app/rydesmngrp.i':u
           lbApiOverride.ApiMethod = 'exportEntityCache':u
           lbApiOverride.ReleaseVersion = ?.
    /* Generate PGEN (“Generate4GLObjects”) */
    create lbApiOverride.
    assign lbApiOverride.Enabled = yes
           lbApiOverride.TaskName = 'Generate4GLObjects':u
           lbApiOverride.ApiFile = 'ry/app/rydeplgenp.p ':u
           lbApiOverride.ApiMethod = 'generate4GLObjects':u
           lbApiOverride.ReleaseVersion = ?.
    create lbApiOverride.
    /* Build R-code (“BuildStaticCode”) */
    create lbApiOverride.
    assign lbApiOverride.Enabled = yes
           lbApiOverride.TaskName = 'BuildStaticCode':u
           lbApiOverride.ApiFile = 'af/app/afbuildrcp.p':u
           lbApiOverride.ApiMethod = '':u
           lbApiOverride.ReleaseVersion = ?.
    /* Create procedure libraries (“BuildLibrary”) */
    create lbApiOverride.
    assign lbApiOverride.Enabled = yes
           lbApiOverride.TaskName = 'BuildLibrary':u
           lbApiOverride.ApiFile = 'af/app/afbuildplp.p':u
           lbApiOverride.ApiMethod = '':u
           lbApiOverride.ReleaseVersion = ?.
    /* Deploy static r-code (“DeployStaticCode”) */
    create lbApiOverride.
    assign lbApiOverride.Enabled = yes
           lbApiOverride.TaskName = 'DeployStaticCode':u
           lbApiOverride.ApiFile = 'af/app/afdeplystp.p':u
           lbApiOverride.ApiMethod = '':u
           lbApiOverride.ReleaseVersion = ?.

    /* Create DCU Patch File (“CreatePatchFile”) */
    create lbApiOverride.
    assign lbApiOverride.Enabled = yes
           lbApiOverride.TaskName = 'CreatePatchFile':u
           lbApiOverride.ApiFile = 'af/app/gscddxmlp.p':u
           lbApiOverride.ApiMethod = 'createSetupIncludeFile':u
           lbApiOverride.ReleaseVersion = ?.
    
    /* Create ADO Listing File (“CreateADOListFile”) */
    create lbApiOverride.
    assign lbApiOverride.Enabled = yes
           lbApiOverride.TaskName = 'createADOListFile':u
           lbApiOverride.ApiFile = 'af/app/gscddxmlp.p':u
           lbApiOverride.ApiMethod = 'createSetupIncludeFile':u
           lbApiOverride.ReleaseVersion = ?.

    /* Update DCU XML files (“UpdateDCU”) */
    create lbApiOverride.
    assign lbApiOverride.Enabled = yes
           lbApiOverride.TaskName = 'UpdateDCU':u
           lbApiOverride.ApiFile = 'af/app/afupdicfsp.p':u
           lbApiOverride.ApiMethod = 'writeSetupXML':u
           lbApiOverride.ReleaseVersion = ?.

    /* Packaging of deployment steps (“BuildPackage”) */
    create lbApiOverride.
    assign lbApiOverride.Enabled = yes
           lbApiOverride.TaskName = 'BuildPackage':u
           lbApiOverride.ApiFile = 'af/app/afbldpckgp.p':u
           lbApiOverride.ApiMethod = '':u
           lbApiOverride.ReleaseVersion = ?.

    error-status:error = no.
    return true.
END FUNCTION.    /* initializeTaskApi */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeTaskOrder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initializeTaskOrder Procedure 
FUNCTION initializeTaskOrder RETURNS LOGICAL PRIVATE
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose: Builds the TaskOrder temp-table
    Notes: We use a TaskOrder temp-table because in future we may decide to allow
           overrides of the order, which will be contained in the deployment XML
           file. But for now, it's hard-coded.
------------------------------------------------------------------------------*/
    define variable iLoop                   as integer                  no-undo.
    define variable cBuildTasks             as character                no-undo.
    define variable cPackageTasks           as character                no-undo.
    define variable cTask                   as character                no-undo.
    
    define buffer lbTaskOrder for TaskOrder.
    
    /* defaults */
    cBuildTasks = 'LoadChangeset':u.    /* always first */
    cBuildTasks = cBuildTasks + ',DumpData,DumpDefinition,DumpSeqValue,ExportReleaseVersion,DumpDataset,':u
                + 'DumpIncrementalDefs,DumpClassCache,DumpEntityCache,Generate4GLObjects,':u
                + 'BuildStaticCode,BuildLibrary,DeployStaticCode,CreatePatchFile,CreateADOListFile,UpdateDCU':u.
    cPackageTasks = 'BuildPackage':u.
    
    do iLoop = 1 to num-entries(cBuildTasks):
        cTask = entry(iLoop, cBuildTasks).
        create lbTaskOrder.
        assign lbTaskOrder.TaskOrder = iLoop
               lbTaskOrder.TaskName = cTask
               lbTaskOrder.TaskApi = cTask
               lbTaskOrder.TaskCategory = 'Build':u
               lbTaskOrder.ReleaseVersion = ?.
    end.    /* build tasks */

    do iLoop = 1 to num-entries(cPackageTasks):
        cTask = entry(iLoop, cPackageTasks).
        create lbTaskOrder.
        assign lbTaskOrder.TaskOrder = iLoop
               lbTaskOrder.TaskName = cTask
               lbTaskOrder.TaskApi = cTask
               lbTaskOrder.TaskCategory = 'Package':u
               lbTaskOrder.ReleaseVersion = ?.
    end.    /* package tasks */
    
    error-status:error = no.
    return true.
END FUNCTION.    /* initializeTaskOrder */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLogCategory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLogCategory Procedure 
FUNCTION setLogCategory RETURNS LOGICAL
    ( input pcLogcategory as character ):
/*------------------------------------------------------------------------------
  Purpose: Pseudo-property setter
    Notes:
------------------------------------------------------------------------------*/
    gc-PSEUDO-PROP-LogCategory = pcLogcategory.
    error-status:error = no.
    return true.
END FUNCTION.    /* setLogCategory */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLogFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLogFile Procedure 
FUNCTION setLogFile RETURNS LOGICAL
        ( input pcLogFile as character  ):
/*------------------------------------------------------------------------------
  Purpose:  Pseudo-property setter
    Notes:
------------------------------------------------------------------------------*/
    gc-PSEUDO-PROP-LogFile = pcLogFile.
    error-status:error = no.
    return true.
END FUNCTION.    /* setLogFile */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLogLevel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLogLevel Procedure 
FUNCTION setLogLevel RETURNS LOGICAL
        ( input piLogLevel    as integer ):
/*------------------------------------------------------------------------------
  Purpose: Pseduo-property setter
    Notes:
------------------------------------------------------------------------------*/
    gc-PSEUDO-PROP-LogLevel = piLogLevel.    
    error-status:error = no.
    return true.    /* setLogLevel */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

