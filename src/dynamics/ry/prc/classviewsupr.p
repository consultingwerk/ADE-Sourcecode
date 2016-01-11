&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
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
/*---------------------------------------------------------------------------------
  File: classviewsupr.p

  Description:  Super procedure for object type (class) viewer.

  Purpose:      

  Parameters:   

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/24/2003  Author:    pjudge 

  Update Notes: Initial Implementation
                

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       classviewsupr.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}
{destdefi.i}

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
         HEIGHT             = 37.29
         WIDTH              = 43.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{adm2/widgetprto.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */
&IF DEFINED(EXCLUDE-deleteRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRecord Procedure
PROCEDURE deleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    run super.
    
    if return-value eq 'adm-error' then
        return return-value.

    /* Clear the class cache so that the client caches are correctly updated.
     */
    run destroyClassCache in gshRepositoryManager.
        
    return.
END PROCEDURE.    /* deleteRecord */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findCustomizingClass) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCustomizingClass Procedure
PROCEDURE findCustomizingClass :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE output parameter pcCustomClass            as character       no-undo.
    
    DEFINE variable hContainer                    as handle             no-undo.
    
    {get ContainerSource hContainer}.
    pcCustomClass = {fnarg getUserProperty 'CustomClass' hContainer}.
    assign pcCustomClass = '' when pcCustomClass eq ?.
    
    return.
END PROCEDURE.    /* findCustomizingClass */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-changeDeploymentType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeDeploymentType Procedure 
PROCEDURE changeDeploymentType :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PROTECTED  
  Purpose:     UI event fired when the deployment type toggles change.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE variable cDeploymentType        as character                no-undo.
    
    assign cDeploymentType = (if {fnarg widgetIsTrue 'toDeployServer'} then 'Srv' else '')
                                                   + (if {fnarg widgetIsTrue 'toDeployClient'} then ',Cli' else '')
                                                   + (if {fnarg widgetIsTrue 'toDeployWeb'} then ',Web' else '')
           cDeploymentType = left-trim(cDeploymentType, ',').
    
    dynamic-function("assignWidgetValue" in target-procedure,
                    'deployment_type', cDeploymentType).
    
    return.
END PROCEDURE.    /* changeDeploymentType */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-displayFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFields Procedure 
PROCEDURE displayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT parameter pcColValues        AS CHARACTER            NO-UNDO.
    
    DEFINE variable cDeploymentType         as character              no-undo.
    DEFINE variable cCustomClass            as character              no-undo.
    DEFINE variable hToggle                 as handle                 no-undo.    
    DEFINE variable hRDM                    as handle                 no-undo.
    DEFINE variable cInheritsFromClasses    as character              no-undo.
    DEFINE variable hContainer              as handle                 no-undo.
    DEFINE variable hCustomClassLookup      as handle                 no-undo.
    
    RUN SUPER (pcColValues).
    
    cDeploymentType = {fnarg widgetValue 'deployment_type'}.
    
    /* clientAPI always sets modified true, so we need to do this 
       stuff manually to avoid the toolbar being placed into 'modified'
       mode initially (and also on every reset).
     */
    hToggle = {fnarg widgetHandle 'toDeployServer'}.
    hToggle:checked = can-do(cDeploymentType, 'Srv').
    hToggle:modified = no.
    
    hToggle = {fnarg widgetHandle 'toDeployClient'}.
    hToggle:checked = can-do(cDeploymentType, 'Cli').
    hToggle:modified = no.
    
    hToggle = {fnarg widgetHandle 'toDeployWeb'}.
    hToggle:checked = can-do(cDeploymentType, 'Web').
    hToggle:modified = no.
    
    /* Get the class' related data. This must happen after the RUN SUPER
       since only then has the UI been updated - and we need the updated 
       UI for the class name.
     */     
    hRdm = {fnarg getManagerHandle 'RepositoryDesignManager'}.
    if valid-handle(hRdm) then
        run retrieveDesignClass in hRDM (input  {fnarg widgetValue 'object_type_code'},
                                         output cInheritsFromClasses,
                                         output table ttClassAttribute,
                                         output table ttUiEvent,
                                         output table ttSupportedLink  ) no-error.
    
    /* tell whoever's expecting this stuff that its ready */
    {get ContainerSource hContainer}.
    
    /* Store the name of the custom class so that other objects
       can use it.
     */
    hCustomClassLookup = {fnarg widgetHandle 'custom_object_type_obj'}.
    {get DisplayValue cCustomClass hCustomClassLookup}.
    dynamic-function('setUserProperty' in hContainer,
                     'CustomClass', cCustomClass).

    publish "populateRelatedData" from hContainer.
        
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.    
END PROCEDURE.    /* displayFields */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClassAttributeBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getClassAttributeBuffer Procedure 
PROCEDURE getClassAttributeBuffer :
/*------------------------------------------------------------------------------
  Purpose:     Returns the handle of the ttClassATtribute buffer to a caller.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE output parameter phAttributeBuffer            as handle     no-undo.
    
    phAttributeBuffer = buffer ttClassAttribute:handle.
    
    assign error-status:error = no.    
    return.
END PROCEDURE.    /* getClassAttributeBuffer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClassEventBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getClassEventBuffer Procedure 
PROCEDURE getClassEventBuffer :
/*------------------------------------------------------------------------------
  Purpose:     Returns the handle of the ttSupportedLink buffer to a caller.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE output parameter phEventBuffer            as handle     no-undo.
    
    phEventBuffer = buffer ttUiEvent:handle.
    
    assign error-status:error = no.
    return.
END PROCEDURE.    /* getClassEventBuffer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClassLinkBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getClassLinkBuffer Procedure 
PROCEDURE getClassLinkBuffer :
/*------------------------------------------------------------------------------
  Purpose:     Returns the handle of the ttSupportedLink buffer to a caller.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE output parameter phLinkBuffer            as handle     no-undo.
    
    phLinkBuffer = buffer ttSupportedLink:handle.
    
    assign error-status:error = no.    
    return.
END PROCEDURE.    /* getClassLinkBuffer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <None>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE variable hContainer         as handle                    no-undo.
    
    run super.
    
    {get ContainerSource hContainer}.
    
    subscribe procedure target-procedure to "lookupComplete" in target-procedure.
        
    /* The below are callbacks for the child data viewers to populate their SDOs */
    subscribe procedure target-procedure to "getClassAttributeBuffer" in hContainer.
    subscribe procedure target-procedure to "getClassEventBuffer" in hContainer.
    subscribe procedure target-procedure to "getClassLinkBuffer" in hContainer.
    
    /* other objects will need to know what the custom class is. */
    subscribe procedure target-procedure to "findCustomizingClass" in hContainer.
    
    return.
END PROCEDURE.    /* initializeObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-lookupComplete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lookupComplete Procedure 
PROCEDURE lookupComplete :
/*------------------------------------------------------------------------------
  Purpose:     Catch when the lookup is left. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcFieldNames         AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcFieldValues        AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcKeyFieldValue      AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcNewScreenValue     AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcOldScreenValue     AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER plBrowseUsed         AS LOGICAL              NO-UNDO.
    DEFINE INPUT PARAMETER phLookup             AS HANDLE               NO-UNDO.
    
    DEFINE VARIABLE cLookupName              AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cTopLevelClass           AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE cCustomClassName         AS CHARACTER               NO-UNDO.
    define variable cButtonPressed           as character               no-undo.
    define variable hContainerSource         as handle                  no-undo.
    DEFINE variable hParentClass             as handle                  no-undo.
    
    {get FieldName cLookupName phLookup}.
    
    case cLookupName:
        when "custom_object_type_obj":U then
        do:
            assign cCustomClassName = pcNewScreenValue.
            
            if cCustomClassName ne "":U and cCustomClassName ne ? then
            do:
                /* Do not allow this class to customise itself.
                 */
                if cCustomClassName eq {fnarg widgetValue 'object_type_code'} then
                do:                 
                    {get ContainerSource hContainerSource}.
                    
                    /* display the warning ..., */
                    RUN showMessages IN gshSessionManager (INPUT  {aferrortxt.i 'AF' '40' 'gsc_object_type' 'custom_object_type_obj'
                                                                  '"A class cannot customize itself."'},
                                                           INPUT  "ERR",        /* error type */
                                                           INPUT  "&OK",        /* button list */
                                                           INPUT  "&OK",        /* default button */ 
                                                           INPUT  "&OK",        /* cancel button */
                                                           INPUT  "Error customizing class",
                                                           INPUT  YES,              /* display if empty */ 
                                                           INPUT  hContainerSource,
                                                           OUTPUT cButtonPressed       ).
                    /* ... clear the dynamic lookup ... */
                    run assignNewValue in phLookup ( input "":U, input "":U, input no).
                    /* ... and fail */
                    return error.
                end.    /* custom class is this class */
                
                /* Find out what the current class' top-level
                   ancestor is.
                   
                   We do this by getting the parent class, since if this
                   is an 'add' action, the class we're creating does not
                   yet exist.
                 */                 
                hParentClass = {fnarg widgetHandle 'extends_object_type_obj'}.
                {get DisplayValue cTopLevelClass hParentClass}.
                
                if cTopLevelClass eq '' then
                    cTopLevelClass = {fnarg widgetValue 'object_type_code'}.
                
                assign cTopLevelClass = {fnarg getClassParents cTopLevelClass gshRepositoryManager}
                       cTopLevelClass = entry(num-entries(cTopLevelClass), cTopLevelClass).
                               
                
                /* The class to be used as a custom class cannot be a class that is in the current class
                   hierarchy, since this may result in inheritance from the same class more than once.
                 */
                if dynamic-function("classIsA":U in gshRepositoryManager, cCustomClassName, cTopLevelClass) then
                do:
                    {get ContainerSource hContainerSource}.
                    
                    /* display the warning ..., */
                    RUN showMessages IN gshSessionManager (INPUT  {aferrortxt.i 'AF' '40' 'gsc_object_type' 'custom_object_type_obj'
                                                                  "'The selected class cannot inherit from the ' + cTopLevelClass + ' class when used for customising this class.'"},
                                                           INPUT  "ERR",          /* error type */
                                                           INPUT  "&OK",    /* button list */
                                                           INPUT  "&OK",           /* default button */ 
                                                           INPUT  "&OK",       /* cancel button */
                                                           INPUT  "Error customizing class",
                                                           INPUT  YES,              /* display if empty */ 
                                                           INPUT  hContainerSource,                /* container handle */
                                                           OUTPUT cButtonPressed       ).    /* button pressed */
                    /* ... clear the dynamic lookup ... */
                    run assignNewValue in phLookup ( input "":U, input "":U, input no).
                    /* ... and fail */
                    return error.
                end.    /* inherits badly */
            end.    /* a custom class was added/modified */            
        end.    /* custom class */
        when "extends_object_type_obj":U then
        do:
            assign cCustomClassName = pcNewScreenValue.
            
            if cCustomClassName ne "":U and cCustomClassName ne ? then
            do:
                /* Do not allow this class to extend itself.
                 */
                if cCustomClassName eq {fnarg widgetValue 'object_type_code'} then
                do:                 
                    {get ContainerSource hContainerSource}.
                    
                    /* display the warning ..., */
                    RUN showMessages IN gshSessionManager (INPUT  {aferrortxt.i 'AF' '40' 'gsc_object_type' 'extends_object_type_obj'
                                                                  '"A class cannot extend itself."'},
                                                           INPUT  "ERR",        /* error type */
                                                           INPUT  "&OK",        /* button list */
                                                           INPUT  "&OK",        /* default button */ 
                                                           INPUT  "&OK",        /* cancel button */
                                                           INPUT  "Error extending class",
                                                           INPUT  YES,              /* display if empty */ 
                                                           INPUT  hContainerSource,
                                                           OUTPUT cButtonPressed       ).
                    /* ... clear the dynamic lookup ... */
                    run assignNewValue in phLookup ( input "":U, input "":U, input no).
                    /* ... and fail */
                    return error.
               end.    /* custom class is this class */
            end.    /* there is a extends class. */
        end.    /* extends class */
    end case.    /* lookup name */
    
    assign error-status:error = no.
    return.
END PROCEDURE.    /* lookupComplete */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord Procedure 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE variable hRdm            as handle                        no-undo.
    DEFINE variable hContainer      as handle                        no-undo.
    DEFINE variable cButton         as character                     no-undo.
    DEFINE variable cClassName      as character                     no-undo.
    DEFINE variable cStatus         as character                     no-undo.
    
    run super.
    if return-value eq 'adm-error' then
        return return-value.
    
    /* Generate class cache, if the toggle is set. */
    if {fnarg widgetIsTrue 'cache_on_client'} then
    do:
        hRdm = {fnarg getManagerHandle 'RepositoryDesignManager'}.
        if valid-handle(hRdm) then
        do:
            cClassName = {fnarg widgetValue 'object_type_code'}.
            RUN generateClassCache IN hRdm (INPUT cClassName, OUTPUT cStatus) NO-ERROR.
            /* the status parameter is used for logging what's going on.
               it does not act as a error-tracking mechanism, the 
               return value/error-status does that.
             */
            if error-status:error or return-value ne '' then
            do:
                {get ContainerSource hContainer}.
                if valid-handle(gshSessionManager) then
                RUN showMessages IN gshSessionManager (INPUT  return-value,
                                                       INPUT  "WAR", /* error type */
                                                       INPUT  "&OK", /* button list */
                                                       INPUT  "&OK", /* default button */ 
                                                       INPUT  "&OK", /* cancel button */
                                                       INPUT  "Error generating client cache for " + cClassName, /* window title */
                                                       INPUT  YES, /* display if empty */ 
                                                       INPUT  hContainer,
                                                       OUTPUT cButton       ).
            end.    /* error */
        end.    /* valid design manager */
    end.    /* cache on client */
    
    /* Clear the class cache so that the client caches are correctly updated.
     */
    run destroyClassCache in gshRepositoryManager.
    
    error-status:error = no.
    return.
END PROCEDURE.    /* updateRecord */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateTitle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateTitle Procedure 
PROCEDURE updateTitle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE variable cCustomizingClass        as character                 no-undo.
    DEFINE variable cWindowTitle             as character                 no-undo.
    DEFINE variable hContainer               as handle                    no-undo.
    
    run super.
    
    {get ContainerSource hContainer}.
    
    run findCustomizingClass in target-procedure (output cCustomizingClass).   
    if cCustomizingClass ne '' then
    do:
        {get WindowName cWindowTitle hContainer}.
        cWindowTitle = cWindowTitle + " customized by " + cCustomizingClass.
        {set WindowName cWindowTitle hContainer}.
    end.    /* there is a customising class */
    
    return.
END PROCEDURE.    /* updateTitle */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

