##Include:[StandardHeaderComment]##

/* Create an unnamed pool to store all the widgets created 
   by this procedure. This is a good default which assures
   that this procedure's triggers and internal procedures 
   will execute in this procedure's storage, and that proper
   cleanup will occur on deletion of the procedure. */
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
##If:[GenerateThinRendering]##
/* ThinRendering Enabled */
&GLOBAL-DEFINE ADM-EXCLUDE-PROTOTYPES
&GLOBAL-DEFINE ADM-EXCLUDE-STATIC
&SCOPED-DEFINE exclude-start-super-proc
/* ThinRendering */
##If:End##

&scoped-define adm-prepare-static-object yes
&scoped-define adm-prepare-class-name ##[ClassName]##
##If:generateSuperInConstructor()##
&scoped-define adm-prepare-super-procedure ##[ObjectSuperProcedure]##
&scoped-define adm-prepare-super-procedure-mode ##[ObjectSuperProcedureMode]##
##If:End##

/* Parameters Definitions ---                                           */
&GLOBAL-DEFINE ADM-Panel-Type    Toolbar
/* tell smart.i that we can use the default destroyObject */ 
&SCOPED-DEFINE include-destroyobject

{src/adm2/ttaction.i}
{src/adm2/tttoolbar.i}
{src/adm2/globals.i}

/* ********************  Preprocessor Definitions  ******************** */
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Panel-Frame
&scoped-define ADM-CONTAINER-HANDLE frame {&Frame-Name}:handle

/* ************************  Function Prototypes ********************** */
##If:[GenerateThinRendering]##
##Exclude:## /* exclude prototypes if thin rendering */
FUNCTION initializeMenu RETURNS LOGICAL
  ( )  FORWARD.

FUNCTION initializeToolBar RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.
##Exclude:End##
##If:End##

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Panel-Frame
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 67.2 BY 1.24.


/* *********************** Procedure Settings ************************ */
/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

/* ************************* Included-Libraries *********************** */
{src/adm2/toolbar.i}

&scoped-define xp-Assign
{set ContainerType ''}
{set ObjectType 'Toolbar'}.
&undefine xp-Assign

/* ***********  Runtime Attributes and AppBuilder Settings  *********** */
ASSIGN FRAME Panel-Frame:SCROLLABLE       = FALSE
       FRAME Panel-Frame:HIDDEN           = TRUE.


/* **********************  Internal Procedures  *********************** */
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME Panel-Frame.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

PROCEDURE getWindowName :
  DEFINE VARIABLE hWin AS HANDLE NO-UNDO.

  ASSIGN hwin =  DYNAMIC-FUNCTION('getContainerSource':U).

  RETURN hWin:file-name.
END PROCEDURE.

PROCEDURE publishEvent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcEventName AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcParameter AS CHARACTER NO-UNDO.

DEF VAR cLinkHandles AS CHARACTER.

cLinkHandles = DYNAMIC-FUNCTION('linkHandles':U IN TARGET-PROCEDURE, 
                                INPUT 'tableio-target':U).

IF pcParameter = ? 
    THEN PUBLISH pcEventName. 
    ELSE PUBLISH pcEventName (pcParameter).

    MESSAGE "Event " pcEventName " published." cLinkHandles.

END PROCEDURE.

##If:[GenerateSecurity]##
procedure createObjects :
    define variable cProperties as character no-undo.
    define variable lSecurityEnabled as logical no-undo.
    define variable hContainer as handle no-undo.
    define variable cRunAttribute as character no-undo.
    define variable cSecuredTokens as character no-undo.
    define variable lTokenSecurityExists as logical no-undo.
    define variable cContainerName as character no-undo.
    
    run super.
    
    cProperties = dynamic-function('getPropertyList':U IN gshSessionManager,
                                   'SecurityEnabled,GSMTOSecurityExists',
                                   No).
    
    lSecurityEnabled = logical(entry(1, cProperties, chr(3))) no-error.
    if lSecurityEnabled eq ? then lSecurityEnabled = yes.
    
    if lSecurityEnabled then
    do:
        lTokenSecurityExists = logical(entry(2, cProperties, chr(3))) no-error.
        if lTokenSecurityExists eq ? then lTokenSecurityExists = yes.
        {get ContainerSource hContainer}.
        &scoped-define xp-Assign
        {get LogicalObjectName cContainerName hContainer}
        {get RunAttribute cRunAttribute hContainer}.
        &undefine xp-Assign
        
        if lTokenSecurityExists then
            run tokenSecurityCheck in gshSecurityManager (input  cContainerName,
                                                          input  cRunAttribute,
                                                          output cSecuredTokens  ).
        &scoped-define xp-Assign
        {set ObjectSecured Yes}
        {set SecuredTokens cSecuredTokens}.
        &undefine xp-Assign
    end.    /* security enabled */
    
    error-status:error = no.
    return.
end procedure.    /* createObjects */
##If:End##    /* generate security */

##If:[GenerateTranslations]##
##Loop:translateToolbar##
procedure translateToolbar-##[LanguageCode]##:
    ##Loop:translateMenuItem##
    find ttAction where ttAction.Action = '##[MenuAction]##' no-error.
    if available ttAction then
        assign
        ##Loop:createMenuField##
            ttAction.##[MenuFieldName]## = ##[MenuFieldValue]##
        ##Loop:End##
        .
    ##Loop:End##    /* translate menus */
    
    {set ObjectTranslated yes}.
    
    error-status:error = no.
    return.
end procedure.    /* translateToolbar-##[LanguageCode]## */
##Loop:End##    /* loop translate */
##If:End##    /* generate translations */


/* ************************  Function Implementations ***************** */
FUNCTION initializeMenu RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Create the menus for the toolbar 
    Notes: This function is defined locally, but will skip the default 
           behavior if there is a super defined AND it returns true.     
           buildMenu() is always called! so it should not be part of the 
           super procedure. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOverridden AS LOG    NO-UNDO.
  DEFINE VARIABLE lOk         AS LOG    NO-UNDO.

 /* build the menubar */
 lOk = {fn constructMenu}.

 RETURN lOK. 
END FUNCTION.

FUNCTION initializeToolBar RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Creates the toolbar for the toolbar 
    Notes: This function is defined locally, but will skip the default 
           behavior if there is a super defined AND it returns true.      
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOverridden AS LOG    NO-UNDO.
  DEFINE VARIABLE lOk         AS LOG    NO-UNDO.

  /* Allow a super-procedure to override the default toolbar */
  lOverridden = SUPER() NO-ERROR.

  /* not (true) for unknown */
  IF NOT (lOverridden = TRUE) THEN
    RUN buildToolbar(OUTPUT lOk).
      
  RETURN lOk.   /* Function return value. */
END FUNCTION.

procedure adm-loadToolbar :
/*------------------------------------------------------------------------------
   Purpose:
     Notes:
 ------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR ttToolbarBand.
    DEFINE OUTPUT PARAMETER TABLE FOR ttObjectBand.
    DEFINE OUTPUT PARAMETER TABLE FOR ttBand.
    DEFINE OUTPUT PARAMETER TABLE FOR ttBandAction.
    DEFINE OUTPUT PARAMETER TABLE FOR ttAction.
    DEFINE OUTPUT PARAMETER TABLE FOR ttCategory.
    
    define variable cRunAttribute as character no-undo.
    define variable hContainer as handle no-undo.    
    ##If:[GenerateTranslations]##
    define variable cProperties as character no-undo.        
    define variable lTranslationEnabled as logical no-undo.
    define variable cCurrentLanguage as character no-undo.
    ##If:End##    /* generate translations */
    
    {get ContainerSource hContainer}.
    {get RunAttribute cRunAttribute hContainer}.
    if cRunAttribute eq ? then cRunAttribute = ''.

    ##Loop:createMenu-Action##
    CREATE ttAction.
    ASSIGN
    ##Loop:createMenuField##
           ttAction.##[MenuFieldName]## = ##[MenuFieldValue]##
    ##Loop:End##
    .
    ##Loop:End##
    
    ##Loop:createMenu-BandAction##
    CREATE ttBandAction.
    ASSIGN 
    ##Loop:createMenuField##
           ttBandAction.##[MenuFieldName]## = ##[MenuFieldValue]##
    ##Loop:End##
    .
    ##Loop:End##
    
    ##Loop:createMenu-Band##
    create ttBand.
    assign       
    ##Loop:createMenuField##
           ttBand.##[MenuFieldName]## = ##[MenuFieldValue]##
    ##Loop:End##
    .
    ##Loop:End##
    
    ##Loop:createMenu-ObjectBand##
    if cRunAttribute eq '##[MenuRunAttribute]##' then
    do:
        create ttObjectBand.
        assign
        ##Loop:createMenuField##
               ttObjectBand.##[MenuFieldName]## = ##[MenuFieldValue]##
        ##Loop:End##
        .
    end.    /* create object band */
    ##Loop:End##
    
    ##Loop:createMenu-ToolbarBand##
    create ttToolbarBand.
    assign
    ##Loop:createMenuField##
           ttToolbarBand.##[MenuFieldName]## = ##[MenuFieldValue]##
    ##Loop:End##
    .
    ##Loop:End##
    
    ##Loop:createMenu-Category##
    create ttCategory.
    assign
    ##Loop:createMenuField##
           ttCategory.##[MenuFieldName]## = ##[MenuFieldValue]##
    ##Loop:End##
    .
    ##Loop:End##
    
    ##If:[GenerateTranslations]## 
    cProperties = dynamic-function('getPropertyList':U IN gshSessionManager,
                                   'TranslationEnabled,CurrentLanguageCode', No).
    
    /* Translate the toolbar before it gets passed back to the caller. */
    lTranslationEnabled = logical(ENTRY(1, cProperties, CHR(3))) no-error.
    if lTranslationEnabled eq ? then lTranslationEnabled = yes.
    cCurrentLanguage = ENTRY(2, cProperties, CHR(3)).
    
    if lTranslationEnabled and
       can-do(this-procedure:internal-entries, 'translateToolbar-' + cCurrentLanguage) then
        run value('translateToolbar-' + cCurrentLanguage).
    ##If:End##   /* generate translation */
    
    error-status:error = no.
    return.
end procedure.    /* adm-loadToolbar */

FUNCTION adm-assignObjectProperties returns logical:
/*------------------------------------------------------------------------------ 
  Purpose:  Sets the properties for the object.
    Notes: 
 ------------------------------------------------------------------------------*/ 
    /* Assignable properties */
    &scoped-define xp-Assign
    {set LogicalObjectName '##[ObjectName]##'}
    {set ObjectTranslated ##initialObjectTranslated([ObjectName])##}
    {set ObjectSecured ##initialObjectSecured([ObjectName])##}    
    ##If:generateSuperInProperty()##
    {set SuperProcedure '##[ObjectSuperProcedure]##'}
    {set SuperProcedureMode '##[ObjectSuperProcedureMode]##'}
    ##If:End##
    ##If:generateSuperInLine()##
    {set SuperProcedure ''}
    {set SuperProcedureMode ''} 
    ##If:End##
    ##If:generateSuperInConstructor()##
    {set SuperProcedure ''}
    {set SuperProcedureMode ''} 
    ##If:End##
    
    ##Loop:ObjectProperties-Assign##
    {set ##[PropertyName]## ##[PropertyValue]##}
    ##Exclude:##
    /* Break up the assign statement every 50 properties or so,
       since they all make up one assign statement.
    */
    ##Exclude:End##    
    ##Every:50##
    .
    &undefine xp-Assign
    &scoped-define xp-Assign
    ##Every:End##    
    ##Loop:End##
    .
    &undefine xp-Assign
        
    /* Keep forced 'Set' properties separate. */
    &scoped-define xp-Assign
    {set LogicalVersion '##[ObjectVersion]##'}
    {set PhysicalObjectName ##[PhysicalObjectName]##}
    {set PhysicalVersion '##[ObjectVersion]##'}    
    ##Loop:ObjectProperties-Set##
    {set ##[PropertyName]## ##[PropertyValue]##}
    ##Loop:End##
    .
    &undefine xp-Assign

    RETURN TRUE.
END FUNCTION.        /* adm-assignObjectProperties */

