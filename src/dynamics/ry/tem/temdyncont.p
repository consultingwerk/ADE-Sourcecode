##Include:[StandardHeaderComment]##

&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.

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
/* ThinRendering */
##If:End##

&scoped-define adm-prepare-static-object yes
&scoped-define adm-prepare-class-name ##[ClassName]##
##If:generateSuperInConstructor()##
&scoped-define adm-prepare-super-procedure ##[ObjectSuperProcedure]##
&scoped-define adm-prepare-super-procedure-mode ##[ObjectSuperProcedureMode]##
##If:End##

/* Astra 2 object identifying preprocessor */
&glob   astra2-dynamicContainer YES

/* tell smart.i that we can use the default destroyObject */ 
&SCOPED-DEFINE include-destroyobject

{launch.i &Define-Only = yes}
##If:[ObjectHasMenu]##
{src/adm2/ttaction.i}
{src/adm2/tttoolbar.i}
##If:End##

/* ********************  Preprocessor Definitions  ******************** */
define variable hContainerHandle as handle no-undo.
define variable cContainerType as character no-undo.
define variable cProcedureType as character no-undo.

&scoped-define ADM-CONTAINER-HANDLE hContainerHandle
&Scoped-define PROCEDURE-TYPE cProcedureType
&Scoped-define ADM-CONTAINER cContainerType
&Scoped-define FRAME-NAME fMain

/* ***********************  Control Definitions  ********************** */
/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

##Loop:ListContainerObjects##
define variable ##getInstanceHandleName([InstanceName])## as handle no-undo.    /* ##[InstanceName]## */
##Loop:End##

/* ************************  Frame Definitions  *********************** */
DEFINE FRAME fMain
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 68.2 BY 9.81.

/* *************************  Create Window  ************************** */
define variable glRunAsFrame as logical no-undo.
define variable hCaller as handle no-undo.

{get TargetProcedure hCaller Source-Procedure} no-error.
if not valid-handle(hCaller) then
    hCaller = source-procedure.
    
glRunAsFrame = ##[RenderAsFrame]##.
/* Am I launched from a DynTree? */
if not glRunAsFrame then
    glRunAsFrame = {fnarg InstanceOf 'DynTree' hCaller} no-error.

/* Treat unknown value as no */
if glRunAsFrame ne yes and SESSION:DISPLAY-TYPE = "GUI":U THEN
do:
    CREATE WINDOW wWin
        ASSIGN HIDDEN             = YES
               TITLE              = "Dynamic Object Controller"
               HEIGHT             = 9.81
               WIDTH              = 68.2
               MAX-HEIGHT         = 34.33
               MAX-WIDTH          = 204.8
               VIRTUAL-HEIGHT     = 34.33
               VIRTUAL-WIDTH      = 204.8
               RESIZE             = yes
               SCROLL-BARS        = no
               STATUS-AREA        = no
               BGCOLOR            = ?
               FGCOLOR            = ?
               THREE-D            = yes
               MESSAGE-AREA       = no
               SENSITIVE          = yes.
    
    assign hContainerHandle = wWin
           cContainerType = 'Window'
           cProcedureType = 'SmartWindow'.
end.    /* run as window */
ELSE
    assign hContainerHandle = frame {&Frame-Name}:handle
           cContainerType = 'Frame'
           cProcedureType = 'SmartFrame'
           {&WINDOW-NAME} = CURRENT-WINDOW.

/* ************************* Included-Libraries *********************** */
{src/adm2/containr.i}

&scoped-define xp-Assign
{set ContainerType cContainerType}
{set ObjectType cProcedureType}.
&undefine xp-Assign

/* ***********  Runtime Attributes and AppBuilder Settings  *********** */
hContainerHandle:hidden = yes.

/* ************************  Control Triggers  ************************ */
if cContainerType eq 'Window' then
do:
    ON END-ERROR OF wWin /* Dynamic Object Controller */
    OR ENDKEY OF {&WINDOW-NAME} ANYWHERE
    DO:
        RUN windowEndError IN TARGET-PROCEDURE NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
            RETURN NO-APPLY.
        
        APPLY "CLOSE":U TO TARGET-PROCEDURE. /* ensure close down nicely */
    
        /* Add the return no-apply so that the entire application doesn't shut down. */
        IF TARGET-PROCEDURE:PERSISTENT THEN
            RETURN NO-APPLY.
    END.
        
    ON WINDOW-CLOSE OF wWin /* Dynamic Object Controller */
    DO:
        /* This ADM code must be left here in order for the SmartWindow
         * and its descendents to terminate properly on exit. */
        APPLY "CLOSE":U TO TARGET-PROCEDURE.
        RETURN NO-APPLY.
    END.
    
    ON WINDOW-MINIMIZED OF wWin /* Dynamic Object Controller */
    DO:
        RUN windowMinimized IN TARGET-PROCEDURE NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
            RETURN NO-APPLY.
    END.
    
    ON WINDOW-RESIZED OF wWin /* Dynamic Object Controller */
    DO:
        RUN resizeWindow IN TARGET-PROCEDURE NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
            RETURN NO-APPLY.
    END. 
end.    /* container type is window */

/* ***************************  Main Block  *************************** */
##If:[GenerateSecurity]##
define variable dSmartObjectobj as decimal no-undo.
define variable cSecuredObjectName as character no-undo.
define variable cButton as character no-undo.
define variable lContainerSecured as logical no-undo.
define variable cRunAttribute as character no-undo.

/* First force the caching of all container-related security */
{get RunAttribute cRunAttribute}.
run cacheContainerSecurity in gshSecurityManager (input '##[ObjectName]##',
                                                  input cRunAttribute,
                                                  input '##listContainerMenuStructures()##',
                                                  input '##listContainerMenuItems()##' ).
dSmartObjectObj = 0.
cSecuredObjectName = '##[ObjectName]##'.
run objectSecurityCheck IN gshSecurityManager ( INPUT-OUTPUT cSecuredObjectName,
                                                INPUT-OUTPUT dSmartObjectObj,
                                                      OUTPUT lContainerSecured).
if lContainerSecured then
do:
    RUN showMessages IN gshSessionManager ( INPUT  {aferrortxt.i 'AF' '17' '?' '?' '"You do not have the necessary security permission to launch this object"'},
                                            INPUT  "ERR":U,                  /* error type */
                                            INPUT  "&OK":U,                  /* button list */
                                            INPUT  "&OK":U,                  /* default button */ 
                                            INPUT  "&OK":U,                  /* cancel button */
                                            INPUT  "Security Message":U,  /* error window title */
                                            INPUT  YES,                      /* display if empty */ 
                                            INPUT  TARGET-PROCEDURE,           /* container handle */ 
                                            OUTPUT cButton                   /* button pressed */       ).
    return.
end.    /* container secured */
##If:End##    /* GenerateSecurity */

IF VALID-HANDLE({&WINDOW-NAME}) and cContainerType eq 'Window' then
do:
    /* Window Container Specific Stuff */
    RUN start-super-proc IN TARGET-PROCEDURE ("ry/app/rydynwindp.p":U).
    
    ASSIGN CURRENT-WINDOW                    = {&WINDOW-NAME} 
           {&WINDOW-NAME}:KEEP-FRAME-Z-ORDER = YES
           TARGET-PROCEDURE:CURRENT-WINDOW   = {&WINDOW-NAME}.
    
    /* The CLOSE event can be used from inside or outside the procedure to 
       terminate it.
     */
    ON CLOSE OF TARGET-PROCEDURE
    DO:
        RUN destroyObject IN TARGET-PROCEDURE NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE = 'adm-error' THEN
            RETURN NO-APPLY.
    END.
    
    /* This will bring up all the links of the current object */
    ON CTRL-ALT-SHIFT-HOME ANYWHERE
    DO:
        RUN displayLinks IN TARGET-PROCEDURE.
    END.      
    
    /* By default, Make sure current-window is always the window with focus. */
    ON ENTRY OF {&WINDOW-NAME}
    DO:
        ASSIGN CURRENT-WINDOW = SELF NO-ERROR.
    END.
END. /* IF VALID-HANDLE({&WINDOW-NAME}) */

/* **********************  Internal Procedures  *********************** */
procedure adm-create-objects :
    define variable cCurrentLanguage as character no-undo.
    define variable cProperties as character no-undo.
    define variable cInitPages as character no-undo.
    define variable lTranslationEnabled as logical no-undo.
    define variable lSecurityEnabled as logical no-undo.
    define variable iCurrentPage as integer no-undo.
    define variable iStartPage as integer no-undo.
    define variable hContainingWindow as handle no-undo.
    define variable hWindow as handle no-undo. 
    
    /* Set the frame to a large size so that we have enough
       room to create the objects on. The packing will ensure
       that the frame is sized to fit the objects on it.
     */
    hContainingWindow = {fn getContainingWindow}.
    if valid-handle(hContainingWindow) THEN
        {get ContainerHandle hWindow hContainingWindow}.
    
    assign frame {&Frame-Name}:SCROLLABLE     = TRUE
           frame {&Frame-Name}:VIRTUAL-WIDTH  = SESSION:WIDTH-CHARS
           frame {&Frame-Name}:VIRTUAL-HEIGHT = SESSION:HEIGHT-CHARS
           frame {&Frame-Name}:WIDTH          = SESSION:WIDTH-CHARS
           frame {&Frame-Name}:HEIGHT         = SESSION:HEIGHT-CHARS
           frame {&Frame-Name}:SCROLLABLE     = FALSE
           hWindow:VIRTUAL-WIDTH              = SESSION:WIDTH-CHARS
           hWindow:VIRTUAL-HEIGHT             = SESSION:HEIGHT-CHARS
           no-error.
    
    {get CurrentPage iCurrentPage}.
    case iCurrentPage:
        ##Loop:CreateContainerPage##
        when ##[CurrentPage]## then
        do:
            ##Loop:CreateContainerObjects##
            {set CurrentLogicalName '##[InstanceObjectName]##'}.
            RUN constructObject IN TARGET-PROCEDURE (INPUT  '##[InstanceRenderingProcedure]##',
                                                     INPUT  frame {&Frame-Name}:handle,
                                                     INPUT  ##[InstanceInstanceProperties]##,
                                                     OUTPUT ##getInstanceHandleName([InstanceName])##).
            {set CurrentLogicalName ''}.
            
            &scoped-define xp-Assign
            {set LogicalObjectName '##[InstanceObjectName]##' ##getInstanceHandleName([InstanceName])##}
            ##Loop:InstanceProperties-Assign##
            {set ##[PropertyName]## ##[PropertyValue]## ##getInstanceHandleName([InstanceName])##}
            ##Exclude:##
            /* Break up the assign statement every 50 properties or so,
		       since they all make up one assign statement. */
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
            ##Loop:InstanceProperties-Set##
            {set ##[PropertyName]## ##[PropertyValue]## ##getInstanceHandleName([InstanceName])##}
            ##Loop:End##
            .
            &undefine xp-Assign

            ##If:instanceIsVisual([InstanceClass])##
            /* If this is not a generated object, then make sure it will be secured and translated.
               the retrieval will have set the ObjectTranslated and ObjectSecured flags correctly,
               but the translations will not have been applied correctly in all cases.
             */
            if not can-do(##getInstanceHandleName([InstanceName])##:internal-entries, 'adm-assignObjectProperties') then
            do:
                &scoped-define xp-Assign
                {set ObjectTranslated no ##getInstanceHandleName([InstanceName])##}
                {set ObjectSecured no ##getInstanceHandleName([InstanceName])##}.
                &undefine xp-Assign
            end.    /* not a generated object */            
            ##If:End##    /* instance is Visual */
            
            dynamic-function('adm-startSuperProcedure' in target-procedure, ##getInstanceHandleName([InstanceName])##).
            ##Loop:End##    /* CreateContainerObjects */
            
            cInitPages = '##getInitPages([CurrentPageReference])##'.
            /* Init other pages this page may need */
            if cInitPages gt '' then                
                run initPages in target-procedure(cInitPages).
            
            ##Loop:AddLinks##
            run addLink in target-procedure (##getInstanceHandleName([SourceInstanceName])##, '##[LinkName]##' , ##getInstanceHandleName([TargetInstanceName])##).
            ##Loop:End##
        end.    /* page ##[CurrentPage]## */
        ##Loop:End##    /* CreateContainerPage */
    end case.    /* current page */
    
    /* Select a Startup page. */
    if iCurrentPage eq 0 then
    do:
        ##If:[GenerateTranslations]##
        /* Translate the container. */
        assign cProperties = dynamic-function('getPropertyList':U IN gshSessionManager,
                                              'TranslationEnabled,CurrentLanguageCode':U,
                                              No)
               lTranslationEnabled = logical(ENTRY(1, cProperties, CHR(3)))
               cCurrentLanguage = ENTRY(2, cProperties, CHR(3))
               no-error.
        if lTranslationEnabled eq ? then lTranslationEnabled = yes.
        
        if lTranslationEnabled and
           can-do(this-procedure:internal-entries, 'translate-' + cCurrentLanguage) then
            run value('translate-' + cCurrentLanguage).
        ##If:End##
        
        ##If:[GenerateSecurity]##
        /* Secure the object. This is mainly tab security. */
        assign cProperties = dynamic-function('getPropertyList':U IN gshSessionManager,
                                              'SecurityEnabled':U,
                                              No)
               lSecurityEnabled = logical(ENTRY(1, cProperties, CHR(3)))
               no-error.
        if lSecurityEnabled eq ? then lSecurityEnabled = yes.
        
        if lSecurityEnabled then
            run adm-secureWindow in target-procedure.         
        ##If:End##
                    
        {set StartPage ##getStartPage()##}.
    end.    /* current page = 0 */   
        
    error-status:error = no.
    return.    
end procedure.    /* adm-create-obejcts */    

##If:[GenerateTranslations]##
##Loop:translateWindow##
procedure translate-##[LanguageCode]##:
    ##If:[TranslatedWindowName]##
    /* Force the set function. WindowName is not a real property. */
    dynamic-function('setWindowName' in target-procedure, '##[WindowTitle]##').
    ##If:End##
    ##If:[TranslatedFolderLabels]##
    ##Exclude:##
    /* Use a dyn-function here instead of {set} since it makes dealing with quotes way way easier. */
    ##Exclude:End##
    dynamic-function('setFolderLabels' in ##getInstanceHandleName([FolderInstanceName])##, '##[FolderLabels]##').
    ##If:End##
    {set ObjectTranslated yes}.
    
    error-status:error = no.
    return.
end procedure.    /* translate-##[LanguageCode]## */
##Loop:End##    /* translatewindow loop */

##Loop:translateToolbar##
procedure translateToolbar-##[LanguageCode]##:
    {set ObjectTranslated yes}.
    
    ##If:[ObjectHasMenu]##
    ##Loop:translateMenuItem##    
        find ttAction where ttAction.Action = '##[MenuAction]##' no-error.
        if available ttAction then
            assign 
        ##Loop:createMenuField##
               ttAction.##[MenuFieldName]## = ##[MenuFieldValue]##
        ##Loop:End##
            .
    ##Loop:End##
    ##If:End##
    
    error-status:error = no.
    return.
end procedure.    /* translateToolbar-##[LanguageCode]## */
##Loop:End##    /* translateToolbar loop */
##If:End##    /* generate translations */

##If:[GenerateSecurity]##
procedure adm-secureWindow:
    define variable cRunAttribute as character no-undo.
    define variable cSecuredTokens as character no-undo.
    define variable cDisabledPages as character no-undo.
    define variable cTabsEnabled as character no-undo.
    define variable iLoop as integer no-undo.
    define variable cPageTokens as character no-undo.
    define variable cToken as character no-undo.
    ##If:[WindowHasFolder]##    
    &scoped-define xp-assign 
    {get PageTokens cPageTokens}
    {get RunAttribute cRunAttribute}.
    &undefine xp-assign
    run tokenSecurityCheck in gshSecurityManager ( input  '##[ObjectName]##',
                                                   input  cRunAttribute,
                                                   output cSecuredTokens ) no-error.
    cSecuredTokens = replace(cSecuredTokens, '&', '').
    cPageTokens = replace(cPageTokens, '&', '').
    assign cTabsEnabled = fill('|yes', num-entries(cPageTokens, '|'))
           cTabsEnabled = left-trim(cTabsEnabled, '|').
    
    if cSecuredTokens ne '' then
    do iLoop = 1 to num-entries(cPageTokens, '|'):
        cToken = entry(iLoop, cPageTokens, '|').
        
        if can-do(cSecuredTokens, cToken) then
            assign entry(iLoop, cTabsEnabled, '|') = 'no'
                   cDisabledPages = cDisabledPages
                                  + (IF cDisabledPages <> '' THEN ',' ELSE '')
                                  +  STRING(iLoop).
    end.    /* loop through labels */    
    {set TabEnabled cTabsEnabled ##getInstanceHandleName([FolderInstanceName])##}.
    {set SecuredTokens cSecuredTokens}.
    
    /* Secure pages */
    if cDisabledPages ne '' then
        dynamic-function('disablePagesInFolder' in target-procedure,
                         'security,' + cDisabledPages).
    ##If:End##
    error-status:error = no.
    return.
end procedure.    /* adm-secureWindow */
##If:End##    /* generate security */

##If:[ObjectHasMenu]##
procedure adm-loadToolbar:
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
    ##If:[GenerateTranslations]##
    define variable cProperties as character no-undo.        
    define variable lTranslationEnabled as logical no-undo.
    define variable cCurrentLanguage as character no-undo.
    ##If:End##    /* generate translations */
    
    {get RunAttribute cRunAttribute}.
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
##If:End##

PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
    if cContainerType eq 'Window' then
    do:
        /* Delete the WINDOW we created */
        IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin) THEN
            DELETE WIDGET wWin.
    end.
    else
        hide frame {&Frame-Name}.
    
    IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

PROCEDURE doThisOnceOnly :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       * This procedure is here because doThisOnceOnly is not part of the ADM
                 procedures and is thus not 'visible' from the INTERNAL-ENTRIES
                 attribute. This API is needed so that doThisOnceOnly will happen for 
                 dynamic containers.
------------------------------------------------------------------------------*/
    IF NOT {fn getObjectsCreated} THEN
        RUN createObjects IN TARGET-PROCEDURE.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* doThisOnceOnly */

PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
    if cContainerType eq 'Window' then
    do:
        VIEW FRAME fMain IN WINDOW wWin.
        VIEW wWin.
    end. 
END PROCEDURE.    /* enable_UI */

PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/
    APPLY "CLOSE":U TO TARGET-PROCEDURE.
END PROCEDURE.  /* exitObject */

PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hWindow                 AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE cErrorMessage           AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cButton                 AS CHARACTER                NO-UNDO.

    /* This is to in the .W to ensure that if there is stuff in a custom super procedure
     * that it will run. This is because the custom super procedure will execute BEFORE
     * any of the super procedures associated with this container window, rydywindp.p and
     * rydynframp.p.                                                                      */
    IF NOT {fn getObjectsCreated} THEN
    DO:
        RUN createObjects IN TARGET-PROCEDURE.
        
        if cContainerType eq 'Window' then
        do:
            /* The container handle will always be a window.
             * Check the error status because the window may already have been
             * shut down.                                                     */
            {get ContainerHandle hWindow} NO-ERROR.
        
            /* Check forced exit of the dynamic container. We may get window packing errors here. */
            IF NOT VALID-HANDLE(hWindow)                                    OR
                (VALID-HANDLE(hWindow)                                      AND
                 LENGTH(hWindow:PRIVATE-DATA)            GT 0               AND
                 ENTRY(1, hWindow:PRIVATE-DATA, CHR(3))  EQ "ForcedExit":U) THEN
            DO:
                /* Select Page in rydynframp.p might have shown this message already */
                IF NOT VALID-HANDLE(hWindow) OR (VALID-HANDLE(hWindow) AND LOOKUP("MessageShown-YES":U, hWindow:PRIVATE-DATA, CHR(3)) = 0) THEN
                DO:
                    IF VALID-HANDLE(hWindow) AND NUM-ENTRIES(hWindow:PRIVATE-DATA, CHR(3)) GE 2 THEN
                        ASSIGN cErrorMessage = ENTRY(2, hWindow:PRIVATE-DATA, CHR(3)).
    
                    IF cErrorMessage EQ "":U OR cErrorMessage EQ ? THEN
                        ASSIGN cErrorMessage = "Program aborted due to unknown reason":U.
    
                    RUN showMessages IN gshSessionManager ( INPUT  cErrorMessage,           /* message to display */
                                                            INPUT  "ERR":U,                 /* error type */
                                                            INPUT  "&OK":U,                 /* button list */
                                                            INPUT  "&OK":U,                 /* default button */
                                                            INPUT  "&OK":U,                 /* cancel button */
                                                            INPUT  "Error on folder window creation":U, /* error window title */
                                                            INPUT  YES,                     /* display if empty */
                                                            INPUT  TARGET-PROCEDURE,        /* container handle */
                                                            OUTPUT cButton               ). /* button pressed */
                END.
                    
                RUN destroyObject IN TARGET-PROCEDURE.
                RETURN.
            END.    /* forced exit */
        end.    /* Object is a window. */
    END.    /* Objects not already created. */
    

    /* The super will not run if there has been a forced exit. */
    RUN SUPER.
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* initializeObject */

PROCEDURE manualInitializeObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       * This procedure is here because manualInitializeObjects is not part of the ADM
                 procedures and is thus not 'visible' from the INTERNAL-ENTRIES
                 attribute. This API is needed so that manualInitializeObjects will happen for 
                 dynamic containers.
------------------------------------------------------------------------------*/
    RUN SUPER.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* manualInitializeObjects */

PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     Resize procedure.
  Parameters:  pdHeight -
               pcWidth  -
  Notes:       * This procedure is here because resizeObject is not part of the ADM
                 procedures and is thus not 'visible' from the INTERNAL-ENTRIES
                 attribute. This API is needed so that resizing will happen for 
                 dynamic containers.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdHeight             AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdWidth              AS DECIMAL              NO-UNDO.
    
    /* We don't check for errors because there will be many cases where
     * there is no resizeObject for the viewer. In this cse, simply ignore 
     * any errors.                                                         */
    RUN SUPER (INPUT pdHeight, INPUT pdWidth) NO-ERROR.
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* resizeObject */

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
    {set HasObjectMenu ##[ObjectHasMenu]##}
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

function adm-startSuperProcedure returns logical
    ( input phObject        as handle ):
    
    define variable iLoop as integer no-undo.
    define variable cEntry as character no-undo.
    define variable cSuperProcedure as character no-undo.
    define variable cSuperProcedureMode as character no-undo.
    define variable cSuperHandle as character no-undo.
    
    /* Start the super procedure(s) for the object instance. */
    {get SuperProcedure cSuperProcedure phObject}.
    if cSuperProcedure ne '' and cSuperProcedure ne ? then
    do:
        cSuperHandle = ''.
        {get SuperProcedureMode cSuperProcedureMode phObject}.
        
        /* Default to stateful mode */
        if cSuperProcedureMode eq '' or cSuperProcedureMode eq ? then
        do:
            cSuperProcedureMode = 'Stateful'.
            {set SuperProcedureMode cSuperProcedureMode phObject}.
        end.
        
        do iLoop = num-entries(cSuperProcedure) to 1 by -1:
            cEntry = entry(iLoop, cSuperProcedure).
            if cEntry eq ? or cEntry eq '' or cEntry eq '?' then
                next.
            /* Start the super */
            {launch.i
                &Plip = cEntry
                &OnApp = 'No'
                &IProc = ''
                &NewInstance = "(cSuperProcedureMode ne 'Stateless')"
            }
            if valid-handle(hPlip) then
            do:
                dynamic-function('addAsSuperProcedure' in gshSessionManager,
                                 hPlip, phObject).
                if cSuperProcedureMode ne 'Stateless' then
                    cSuperHandle = cSuperHandle + ',' + string(hPlip).
            end.    /* valid plip handle */
        end.    /* loop through supers */
        
        /* Keep the list of custom supers in context. */
        {set SuperProcedureHandle left-trim(cSuperHandle,',') phObject}.
    end.    /* start the super procedure  */
    
    error-status:error = no.
    return true.
end function.    /* adm-startSuperProcedure */

##If:generateSuperInline()##
/* Object Custom Super Procedure */
{##[ObjectSuperProcedure]##}
##If:End##

/* ---oo00oo--- */
