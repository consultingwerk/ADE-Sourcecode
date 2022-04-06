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
/**********************************************************************************/
/* Copyright (C) 2006,2008 by Progress Software Corporation. All rights reserved. */
/* Prior versions of this work may contain portions contributed by                */
/* participants of Possenet.                                                      */
/**********************************************************************************/
/*---------------------------------------------------------------------------------
  File: afdeplystp.p

  Description:  Deployment Automation: DeployStaticObjec

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


/* Log levels: Used as a parameter into logMessage(). */
{af/app/afloglevel.i}
&scoped-define LOG-CATEGORY Generate4GLObjects

/* Defines ttCriteria temp-table. We don't use it here, since we use a buffer handle,
   but it's included here for refernece.
{af/app/afdeplycrit.i}
*/

define variable ghDeploymentHelper        as handle                    no-undo.
define variable ghPgenProc                as handle                    no-undo.

/* Used for determining the Template */
{destdefi.i}
define temp-table ttTemplate no-undo
    field ClassName        as character
    field TemplateName     as character
    index idxMain as unique primary
        ClassName.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-cleanupQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cleanupQuery Procedure
FUNCTION cleanupQuery RETURNS LOGICAL PRIVATE
	( input phQuery        as handle,
      input plDeleteBuffer as logical ) FORWARD.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-getGenerationTemplate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getGenerationTemplate Procedure
FUNCTION getGenerationTemplate RETURNS CHARACTER PRIVATE
	(  input pcClassName        as character ) FORWARD.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-getDataFieldViewer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataFieldViewer Procedure
FUNCTION getDataFieldViewer RETURNS LOGICAL PRIVATE
	( input pcObjectFilename        as character,
      input phCriteria              as handle,
      input plIncludeInstances      as logical     ) FORWARD.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-createInstanceRecords) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createInstanceRecords Procedure
FUNCTION createInstanceRecords RETURNS LOGICAL PRIVATE
	( input pcObjectFilename    as character, 
      input phCriteria          as handle      ) FORWARD.


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
/* Start the Deployment helper procedure. We need it  */
run startProcedure in target-procedure ("ONCE|af/app/afdeplyhlp.p":U, output ghDeploymentHelper).
if not valid-handle(ghDeploymentHelper) then
    return error 'Unable to start Deployment Helper procedure (af/app/afdeplyhlp.p)'.

/* Start the PGen procdure . We need it  */
run startProcedure in target-procedure ("ONCE|ry/app/rygentempp.p":U, output ghPgenProc).
if not valid-handle(ghPgenProc) then
    return error 'Unable to start object generation procedure (ry/app/rygentempp.p)'.

/* - E - O - F - */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */


&IF DEFINED(EXCLUDE-buildCriteria) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildCriteria Procedure
PROCEDURE buildCriteria :
/*------------------------------------------------------------------------------
  Purpose:    Builds creiteria records for the ProductModule and ObjectType
              criteria
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter phCriteria                as handle             no-undo.
    define input parameter plIncludeInstances        as logical            no-undo.
    define input parameter plIncludeDatafieldViewers as logical            no-undo.
    
    define variable hQuery                    as handle                   no-undo.
    define variable hPrimary                  as handle                   no-undo.
    define variable hBuffer                   as handle                   no-undo.
    define variable cDataFieldChildren        as character                no-undo.
    define variable lOk                       as logical                  no-undo.
    define variable hQuery2                   as handle                   no-undo.
    define variable hBuffer2                  as handle                   no-undo.
    define variable iLoop                     as integer                  no-undo.
    define variable cTableName                as character                no-undo.
    define variable cBufferName               as character                no-undo.
    define variable hObjectType               as handle                   no-undo.
    define variable hRycso                    as handle                   no-undo.          
    
    /* Make sure to always use named buffers here, because any queries that come in
       may have names that conflict with ours.
     */
    define buffer bc_gscot for gsc_object_type.
    define buffer bc_rycso for ryc_smartobject.
    define buffer bc_gscpm for gsc_product_module.
    
    cDataFieldChildren = {fnarg getClassChildrenFromDB 'DataField' gshRepositoryManager}.
    
    /* Use this buffer to do a FIND-FIRST later */    
    create buffer hBuffer for table phCriteria buffer-name 'lbCriteria'.
    
    create query hQuery.
    hQuery:set-buffers(phCriteria).
        
    hPrimary = phCriteria:buffer-field('Primary':u).        
    
    /* Use a preselect because we don't want to update 
       any of the records we create inside this query.
       We're also going to be deleting some records.     */
    hQuery:query-prepare('preselect each ':u + phCriteria:name ).
    hQuery:query-open().
    
    hQuery:get-first().
    CRITERIA-LOOP:
    do while phCriteria:available:
        if phCriteria::Type eq 'Object':u then
        do:
            find first bc_rycso where
                       bc_rycso.object_filename = hPrimary:buffer-value
                       no-lock no-error.
            if not available bc_rycso then
            find first bc_rycso where
                       bc_rycso.object_filename = entry(1, hPrimary:buffer-value, '.':u)
                       no-lock no-error.
            if not available bc_rycso then
                phCriteria:buffer-delete().
            else
            do:
                find bc_gscot where
                     bc_gscot.object_type_obj = bc_rycso.object_type_obj
                     no-lock.                     
                phCriteria::Secondary = bc_gscot.object_type_code.
                
                if plIncludeDatafieldViewers and
                   can-do(cDataFieldChildren, bc_gscot.object_type_code) then
                    dynamic-function('getDataFieldViewer':u in target-procedure,
                                     bc_rycso.object_filename, phCriteria, plIncludeInstances).
                
                if plIncludeInstances then
                    dynamic-function('createInstanceRecords':u in target-procedure,
                                     bc_rycso.object_filename, phCriteria).
            end.    /* avialable bc_rycso */
        end.    /* object */
        else
        if phCriteria::Type eq 'ObjectType':u then
        do:
            find bc_gscot where
                 bc_gscot.object_type_code = hPrimary:buffer-value
                 no-lock no-error.
            if available bc_gscot then
            do:
                for each bc_rycso where
                         bc_rycso.object_type_obj = bc_gscot.object_type_obj and
                         bc_rycso.customization_result_obj = 0
                         no-lock:
                    /* DataFields are marked as static, but aren't really. */
                    if bc_rycso.static_object eq no or
                       can-do(cDataFieldChildren, bc_gscot.object_type_code) then
                    do:
                        hBuffer:find-first(' where ':u + hBuffer:name + '.Type = "object" and ':u
                                          + hBuffer:name + '.Primary = ':u + quoter(bc_rycso.object_filename) ) no-error.
                        if not hBuffer:available then
                        do:
                            hBuffer:buffer-create().
                            hBuffer::Type = 'Object':u.
                            hBuffer::Primary = bc_rycso.object_filename.
                            hBuffer::Secondary = bc_gscot.object_type_code.
                            hBuffer:buffer-release().
                        end.    /* buffer n/a */
                        
                        if plIncludeDatafieldViewers and
                           can-do(cDataFieldChildren, bc_gscot.object_type_code) then
                            dynamic-function('getDataFieldViewer':u in target-procedure,
                                             bc_rycso.object_filename, phCriteria, plIncludeInstances).
                        
                        if plIncludeInstances then
                            dynamic-function('createInstanceRecords':u in target-procedure,
                                             bc_rycso.object_filename, phCriteria).
                    end.    /* not static */
                end.    /* each bc_rycso */
            end.    /* available bc_gscot */
            else
                publish 'ICFDA_logMessage':U ({&LOG-LEVEL-DEBUG}, '{&LOG-CATEGORY}':u,
                                'Object type ' + hPrimary:buffer-value + ' not found').
        end.    /* ObjectType */
        else
        if phCriteria::Type eq 'ProductModule':u then
        do:
            find bc_gscpm where
                 bc_gscpm.product_module_code = hPrimary:buffer-value
                 no-lock no-error.
            if available bc_gscpm then
            do:
                for each bc_rycso where
                         bc_rycso.product_module_obj = bc_gscpm.product_module_obj and
                         bc_rycso.customization_result_obj = 0
                         no-lock,
                   first bc_gscot where
                         bc_gscot.object_type_obj = bc_rycso.object_type_obj
                         no-lock:
                    /* DataFields are marked as static, but aren't really. */
                    if bc_rycso.static_object eq no or
                       can-do(cDataFieldChildren, bc_gscot.object_type_code) then
                    do:
                        hBuffer:find-first(' where ':u + hBuffer:name + '.Type = "object" and ':u
                                          + hBuffer:name + '.Primary = ':u + quoter(bc_rycso.object_filename) ) no-error.
                        if not hBuffer:available then
                        do:
                            hBuffer:buffer-create().
                            hBuffer::Type = 'Object':u.
                            hBuffer::Primary = bc_rycso.object_filename.
                            hBuffer::Secondary = bc_gscot.object_type_code.
                            hBuffer:buffer-release().
                        end.    /* buffer n/a */
                        
                        if plIncludeDatafieldViewers and
                           can-do(cDataFieldChildren, bc_gscot.object_type_code) then
                            dynamic-function('getDataFieldViewer':u in target-procedure,
                                             bc_rycso.object_filename, phCriteria, plIncludeInstances).
                        
                        if plIncludeInstances then
                            dynamic-function('createInstanceRecords':u in target-procedure,
                                             bc_rycso.object_filename, phCriteria).
                    end.    /* not static */
                end.    /* each bc_rycso */
            end.    /* product module */
            else
                publish 'ICFDA_logMessage':U ({&LOG-LEVEL-DEBUG}, '{&LOG-CATEGORY}':u,
                                'Product module ' + hPrimary:buffer-value + ' not found').
        end.    /* product module */
        if phCriteria::Type eq 'Query':u then
        do:
            create query hQuery2.
            
            hRycso = ?.
            do iLoop = 1 to num-entries(phCriteria::Secondary):
                /* phCriteria::Secondary is a comma-delimted list of 
                   buffer names. Each buffer can also be a BufferName=TableName
                   set.
                */
                cTableName = entry(iLoop, phCriteria::Secondary).
                
                cBufferName = entry(1, cTableName, '=':u).
                if num-entries(cTableName, '=':u) gt 1 then
                    cTableName = entry(2, cTableName, '=':u).
                
                create buffer hBuffer2 for table cTableName buffer-name cBufferName no-error.
                if not valid-handle(hBuffer2) then
                do:
                    publish 'ICFDA_logMessage':U ({&LOG-LEVEL-DEBUG}, '{&LOG-CATEGORY}':u,
                                'Unable to create buffer for ' + cBufferName + ' (':u + cTableName + ')':u).
                    
                    dynamic-function('cleanupQuery' in target-procedure, hQuery2, Yes).
                    
                    hQuery:get-next().                        
                    next CRITERIA-LOOP.
                end.    /* not valid-buffer */
                
                /* We need to know what the rycso buffer is */
                if hBuffer2:table eq 'ryc_smartobject':u then
                    assign hObjectType = hbuffer2:buffer-field('object_type_obj':u)
                           hRycso = hBuffer2.
                
                hQuery2:add-buffer(hBuffer2).
            end.    /* loop through buffers */
            
            if not valid-handle(hRycso) then
            do:
                publish 'ICFDA_logMessage':U ({&LOG-LEVEL-DEBUG}, '{&LOG-CATEGORY}':u,
                            'Unable find smartobject buffer for query ' + phCriteria::Primary).
                
                dynamic-function('cleanupQuery' in target-procedure, hQuery2, Yes).
                hQuery:get-next().                        
                next CRITERIA-LOOP.
            end.    /* not valid rycso */                       
            
            lOk = hQuery2:query-prepare(phCriteria::Primary) /* no-error.*/.
            if not lOk then
            do:
                publish 'ICFDA_logMessage':U ({&LOG-LEVEL-DEBUG}, '{&LOG-CATEGORY}':u,
                            'Unable to prepare query ' + phCriteria::Primary).
                
                dynamic-function('cleanupQuery' in target-procedure, hQuery2, Yes).
                hQuery:get-next().                        
                next CRITERIA-LOOP.
            end.    /* not valid rycso */                       
            
            hQuery2:query-open().
            
            hquery2:get-first().
            do while not hQuery2:query-off-end:
                find bc_gscot where
                     bc_gscot.object_type_obj = hObjectType:buffer-value
                     no-lock.
                
                /* DataFields are marked as static, but aren't really. */
                if hRycso::static_object eq no or
                   can-do(cDataFieldChildren, bc_gscot.object_type_code) then
                do:
                    hBuffer:find-first(' where ':u + hBuffer:name + '.Type = "object" and ':u
                                      + hBuffer:name + '.Primary = ':u + quoter(hRycso::object_filename) ) no-error.
                    if not hBuffer:available then
                    do:
                        hBuffer:buffer-create().
                        hBuffer::Type = 'Object':u.
                        hBuffer::Primary = hrycso::object_filename.
                        hBuffer::Secondary = bc_gscot.object_type_code.
                        hBuffer:buffer-release().
                    end.    /* buffer n/a */
                    
                    if plIncludeDatafieldViewers and
                       can-do(cDataFieldChildren, bc_gscot.object_type_code) then
                        dynamic-function('getDataFieldViewer':u in target-procedure,
                                         hRycso::object_filename, phCriteria, plIncludeInstances).
                    
                    if plIncludeInstances then
                        dynamic-function('createInstanceRecords':u in target-procedure,
                                         hRycso::object_filename, phCriteria).
                end.    /* not static */
                
                hquery2:get-next().
            end.    /* query available */
            
            dynamic-function('cleanupQuery' in target-procedure, hQuery2, Yes).
        end.    /* query */
        
        hQuery:get-next().
    end.    /* CRITERIA-LOOP: each criteria */
    hQuery:query-close.
    
    delete object hBuffer no-error.
    hBuffer = ?.
    
    dynamic-function('cleanupQuery' in target-procedure, hQuery, No).
    
    error-status:error = no.
    return.
END PROCEDURE.    /* buildCriteria */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF



&IF DEFINED(EXCLUDE-generateObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateObject Procedure
PROCEDURE generateObject :
/*------------------------------------------------------------------------------
  Purpose:     Performs the generation for an object
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input  parameter pcLanguageList        as character            no-undo.
    define input  parameter pcResultCodeList      as character            no-undo.
    define input  parameter pcTarget              as character            no-undo.
    define input  parameter pcSuperProcLocation   as character            no-undo.
    define input  parameter phCriteria            as handle               no-undo.
    define input  parameter pcPgenOptions         as character            no-undo.
    define input  parameter pcPluginProcedure     as character            no-undo.
    define output parameter pcPgenFile            as character            no-undo.
    
    define variable cTemplate                    as character             no-undo.
    
    if phCriteria:available then
    do:
        publish 'ICFDA_logMessage':u ({&LOG-LEVEL-DEBUG}, '{&LOG-CATEGORY}':u,
                        'Processing ' + pHCriteria::Primary + ' of class ' + phCriteria::Secondary).
        
        cTemplate = {fnarg getGenerationTemplate phCriteria::Secondary}.        
        if cTemplate eq '':u then
            publish 'ICFDA_logMessage':u ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u,
                            'No template found for object ' + phCriteria::Primary + ' of class ' + phCriteria::Secondary).
        else
        do:
            etime(yes).
            run generateObject in ghPgenProc ( phCriteria::Primary,
                                               cTemplate,
                                               pcPluginProcedure,
                                               pcLanguageList,
                                               pcResultCodeList,
                                               pcSuperProcLocation,
                                               pcTarget,
                                               pcPgenOptions,
                                               output pcPgenFile ) no-error.
            if error-status:error or return-value ne '':u then return error return-value.
            publish 'ICFDA_logMessage':u ({&LOG-LEVEL-DEBUG}, '{&LOG-CATEGORY}':u,
                            'Generation of ' + pHCriteria::Primary + ' took ' + string(etime) + 'ms').
        end.    /* template available */
    end.    /* available criteria */
    
    error-status:error = no.
    return.        
END PROCEDURE.    /* generateObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF



&IF DEFINED(EXCLUDE-compileObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE compileObject Procedure
PROCEDURE compileObject :
/*------------------------------------------------------------------------------
  Purpose:     Compiles the generatead object
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcPgenFilename        as character            no-undo.
    define input parameter pcCompileTarget       as character            no-undo.
    define input parameter pcCompileOptions      as character            no-undo.
    
    publish 'ICFDA_logMessage':U ({&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u,
                'Compiling ' + pcPgenFilename + ' into ' + pcCompileTarget + ' with options: ' + pcCompileOptions).

    /* Use the fully-pathed name of the PGEN file so that we can compile the r-code
       into another directory without a relative path. Pgen is meant to have all the
       r-code in one flat directory. */
    file-information:file-name = pcPgenFilename.
    pcPgenFilename = file-info:full-pathname.
    
    compile value(pcPgenFilename) save into value(pcCompileTarget)
        generate-md5 = can-do(pcCompileOptions, 'MD5':U)
        min-size = can-do(pcCompileOptions, 'Min-Size':U)
        no-error.
    if compiler:error then
        publish 'ICFDA_logMessage':U ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u,
                    'Compile error for ' + pcPgenFilename
                    + error-status:get-message(1) ).        
    if compiler:warning then
        publish 'ICFDA_logMessage':U ({&LOG-LEVEL-WARNING}, '{&LOG-CATEGORY}':u,
                    'Compile warning(s) for ' + pcPgenFilename
                    + error-status:get-message(1) ).
    
    error-status:error = no.
    return.                                
END PROCEDURE.    /* compileObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-generateObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateObjects Procedure
PROCEDURE generate4GLObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcLanguageList            as character                no-undo.
    define input parameter pcResultCodeList          as character                no-undo.
    define input parameter pcTarget                  as character                no-undo.
    define input parameter plCompile                 as logical                  no-undo.
    define input parameter pcCompileOptions          as character                no-undo.
    define input parameter pcCompileTarget           as character                no-undo.
    define input parameter plIncludeInstances        as logical                  no-undo.
    define input parameter pcSuperProcLocation       as character                no-undo.
    define input parameter plIncludeDatafieldViewers as logical                  no-undo.
    define input parameter plThinRendering           as logical                  no-undo.
    define input parameter plPluginProcedure         as character                no-undo.
    define input parameter phCriteria                as handle                   no-undo.
    
    define variable hQuery                     as handle                        no-undo.
    define variable iErrorNum                  as integer                       no-undo.
    define variable cPgenFile                  as character                     no-undo.
    define variable cPgenOptions               as character                     no-undo.
    define variable cReturnValue               as character                     no-undo.
    define variable lError                     as logical                       no-undo.
    
    /* Make sure that we have a directory to write into. */
    if pcTarget eq '':u or pcTarget eq ? then
        return error {aferrortxt.i 'AF' '1' '?' '?' '"Generation root directory"'}.
    pcTarget = replace(pcTarget, '~\':u, '/':u).    
    
    iErrorNum = dynamic-function('prepareDirectory':u in ghDeploymentHelper,
                                  pcTarget,
                                  No,     /* clear contents? */
                                  Yes     /* create if missing */ ).
    if iErrorNum gt 0 then
        return error {aferrortxt.i 'AF' '40' '?' '?' "'Unable to write to directory ' + pcTarget"}.
    
    if plCompile then
    do:
        if pcCompileTarget eq '':u or pcCompileTarget eq ? then
            return error {aferrortxt.i 'AF' '1' '?' '?' '"Compile root directory"'}.
        pcCompileTarget = replace(pcCompileTarget, '~\':u, '/':u).
        
        iErrorNum = dynamic-function('prepareDirectory':u in ghDeploymentHelper,
                                      pcCompileTarget,
                                      No,     /* clear contents? */
                                      Yes     /* create if missing */ ).
        if iErrorNum gt 0 then
            return error {aferrortxt.i 'AF' '40' '?' '?' "'Unable to write to directory ' + pcCompileTarget"}.            
    end.    /* compile */
    
    cPgenOptions = 'GenerateSecurity':u
                 + (if pcLanguageList gt '':u then ',GenerateTranslations':u else '':u)
                 + (if plThinRendering then ',GenerateThinRendering':u else '':u).
    cPgenOptions = trim(cPgenOptions, ',':u).
    
    if pcResultCodeList eq '':u or pcResultCodeList eq ? then
        pcResultCodeList = 'Default-Result-Code':u.
    
    /* Transform the non-Object criteria into objects */
    run buildCriteria in target-procedure (phCriteria, plIncludeInstances, plIncludeDatafieldViewers) no-error.
    if error-status:error or return-value ne '':u then
        return error return-value.
    
    publish 'ICFDA_logMessage':u ({&LOG-LEVEL-INFO}, '{&LOG-CATEGORY}':u,
                'Generation options:'
               + "~nTarget location         : " + pcTarget
               + "~nPlugin procedure        : " + plPluginProcedure
               + "~nGenerate thin rendering : " + string(plThinRendering)
               + "~nSuper procedure loc     : " + pcSuperProcLocation
               + "~nResult codes            : " + pcResultCodeList
               + "~nGenerate translations   : " + STRING(LOOKUP("generatetranslations":U, cPgenOptions) > 0)
               + (IF (LOOKUP("generatetranslations":U, cPgenOptions) > 0) THEN
                   "~nLanguages               : " + pcLanguageList 
                  ELSE
                  "")
               + (IF plCompile THEN "~nRcode location          : " + pcCompileTarget ELSE "")
               + (IF plCompile THEN "~nCompile options         : " + pcCompileOptions ELSE "") ).

    /* for each tCriteria */
    create query hQuery.
    hQuery:set-buffers(phCriteria).
    hQuery:query-prepare(' for each ':u + phCriteria:name + ' where ':u
                        + phCriteria:name + '.Type = "Object" ':u).
    hQuery:query-open.

    hQuery:get-first().
    do while phCriteria:available:
        run generateObject in target-procedure (input  pcLanguageList,
                                                input  pcResultCodeList,
                                                input  pcTarget,
                                                input  pcSuperProcLocation,
                                                input  phCriteria,
                                                input  cPgenOptions,
                                                input  plPluginProcedure,
                                                output cPGenFile        ) no-error.
        if error-status:error or return-value ne '':u then
        do:
            cReturnValue = return-value.
            lError = error-status:error.
            leave.
        end.
        
        if plCompile and cPGenFile gt '':u then
        do:
            run compileObject in target-procedure ( cPgenFile, pcCompileTarget, pcCompileOptions) no-error.
            if error-status:error or return-value ne '':u then
            do:
                cReturnValue = return-value.
                lError = error-status:error.
                leave.
            end.
        end.    /* compile */
        
        hQuery:get-next().
    end.    /* each object */
    hQuery:query-close().
        
    delete object hQuery no-error.
    hQuery = ?.
    
    error-status:error = lError.
    if cReturnValue eq '' then
        return.
    else
        return error cReturnValue.
END PROCEDURE.    /* generateObjects */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF




/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-cleanupQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cleanupQuery Procedure
FUNCTION cleanupQuery RETURNS LOGICAL PRIVATE
	( input phQuery        as handle,
      input plDeleteBuffer as logical  ):
/*------------------------------------------------------------------------------
  Purpose: Deletes a query object and its buffers, if required.
	Notes:
------------------------------------------------------------------------------*/
    define variable iLoop     as integer                        no-undo.
    
    if plDeleteBuffer then
    do iLoop = 1 to phQuery:num-buffers:
        delete object phQuery:get-buffer-handle(iLoop) no-error.
    end.
    
    delete object phQuery no-error.
    
    return true.
END FUNCTION.    /* cleanupQuery */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-getGenerationTemplate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getGenerationTemplate Procedure
FUNCTION getGenerationTemplate RETURNS CHARACTER PRIVATE
	( input pcClassName        as character ):
/*------------------------------------------------------------------------------
  Purpose:  
	Notes:
------------------------------------------------------------------------------*/
    define variable hRDM            as handle                        no-undo.
    define variable cAncestors      as character                     no-undo.
    
    define buffer lbTemplate for ttTemplate.
    
    find lbTemplate where lbTemplate.ClassName = pcClassName no-error.
    if not available lbTemplate then
    do:
        hRDM = {fnarg getManagerHandle 'RepositoryDesignManager'}.
        run retrieveDesignClass in hRDM (pcClassName,
                                         output cAncestors,
                                         output table ttClassAttribute,
                                         output table ttUiEvent,
                                         output table ttSupportedLink) no-error.
        /* Don't return on error here - create a dummy record instead. */
        
        find ttClassAttribute where
             ttClassAttribute.tClassName = pcClassName and
             ttClassAttribute.tAttributeLabel = 'GenerationTemplate':U
             no-error.
    
        create lbTemplate.
        assign lbTemplate.ClassName = pcClassName
               lbTemplate.TemplateName = (if available ttClassAttribute then ttClassAttribute.tAttributeValue else '':u).             
    end.    /* n/a lbTempalte */
    
    error-status:error = no.
    return lbTemplate.TemplateName.
END FUNCTION.    /* getGenerationTemplate */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-getDataFieldViewer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataFieldViewer Procedure
FUNCTION getDataFieldViewer RETURNS LOGICAL PRIVATE
	( input pcObjectFilename        as character,
      input phCriteria              as handle,
      input plIncludeInstances      as logical      ):
/*------------------------------------------------------------------------------
  Purpose: Finds the objects that contain DataFields and adds them to the list of
  		   objects for generation.
	Notes:
------------------------------------------------------------------------------*/
    define variable hBuffer                as handle                    no-undo.
    
    define buffer rycso_datafield for ryc_smartobject.
    define buffer rycoi for ryc_object_instance.
    define buffer rycso_viewer for ryc_smartobject.
    define buffer gscot for gsc_object_type.
    
    /* Use this buffer to do a FIND-FIRST later */    
    create buffer hBuffer for table phCriteria buffer-name 'lbCriteria'.    
    
    for each rycso_datafield where
             rycso_datafield.object_filename = pcObjectFilename
             no-lock,
        each rycoi where 
             rycoi.smartobject_obj = rycso_datafield.smartobject_obj
             no-lock,
       first rycso_viewer where
             rycso_viewer.smartobject_obj = rycoi.container_smartobject_obj and
             rycso_viewer.static_object = no    /* we do't generate static objects */
             no-lock,
       first gscot where
             gscot.object_type_obj = rycso_viewer.object_type_obj
             no-lock:
        
        hBuffer:find-first(' where ':u + hBuffer:name + '.Type = "Object" and ':u
                          + hBuffer:name + '.Primary = ':u + quoter(rycso_viewer.object_filename) ) no-error.
        if not hBuffer:available then
        do:
            hBuffer:buffer-create().
            hBuffer::Type = 'Object':u.
            hBuffer::Primary = rycso_viewer.object_filename.
            hBuffer::Secondary = gscot.object_type_code.
            hBuffer:buffer-release().
        end.    /* buffer n/a */
        
        if plIncludeInstances then
            dynamic-function('createInstanceRecords':u in target-procedure,
                             rycso_viewer.object_filename, phCriteria).
    end.    /* each rycso container */
    
    delete object hBuffer no-error.
    hBuffer = ?.
    
    error-status:error = no.
    return True.
END FUNCTION.    /* getDataFieldViewer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-createInstanceRecords) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createInstanceRecords Procedure
FUNCTION createInstanceRecords RETURNS LOGICAL PRIVATE
	( input pcObjectFilename    as character, 
      input phCriteria          as handle              ):
/*------------------------------------------------------------------------------
  Purpose:  
	Notes:
------------------------------------------------------------------------------*/
    define variable hBuffer                as handle                    no-undo.
    
    define buffer rycso_container for ryc_smartobject.
    define buffer rycoi for ryc_object_instance.
    define buffer rycso for ryc_smartobject.
    define buffer gscot for gsc_object_type.
    
    /* Use this buffer to do a FIND-FIRST later */    
    create buffer hBuffer for table phCriteria buffer-name 'lbCriteria'.    
    
    for each rycso_container where
             rycso_container.object_filename = pcObjectFilename
             no-lock,
        each rycoi where 
             rycoi.container_smartobject_obj = rycso_container.smartobject_obj
             no-lock,
       first rycso where
             rycso.smartobject_obj = rycoi.smartobject_obj and
             rycso.static_obj = no
             no-lock,
       first gscot where
             gscot.object_type_obj = rycso.object_type_obj
             no-lock:
        
        hBuffer:find-first(' where ':u + hBuffer:name + '.Type = "Object" and ':u
                          + hBuffer:name + '.Primary = ':u + quoter(rycso.object_filename) ) no-error.
        if not hBuffer:available then
        do:
            hBuffer:buffer-create().
            hBuffer::Type = 'Object':u.
            hBuffer::Primary = rycso.object_filename.
            hBuffer::Secondary = gscot.object_type_code.
            hBuffer:buffer-release().
        end.    /* buffer n/a */
        
        /* Now go and recurse */
        dynamic-function('createInstanceRecords':u in target-procedure,
                         rycso.object_filename, phCriteria).
    end.    /* each rycso container */
    
    delete object hBuffer no-error.
    hBuffer = ?.
    
    error-status:error = no.
    return true.        
END FUNCTION.    /* createInstanceRecords */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


