##Include:[StandardHeaderComment]##
    
&Scoped-define WINDOW-NAME wTreeWin
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
&glob   astra2-dynamiccontainer YES
/* tell smart.i that we can use the default destroyObject */ 
&SCOPED-DEFINE include-destroyobject

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE ghTreeViewOCX AS HANDLE     NO-UNDO.

{src/adm2/treettdef.i}

{launch.i &Define-Only = yes}
##If:[ObjectHasMenu]##
{src/adm2/ttaction.i}
{src/adm2/tttoolbar.i}
##If:End##


/* ********************  Preprocessor Definitions  ******************** */
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME fTreeMain
&Scoped-define ADM-CONTAINER-HANDLE {&Window-Name}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiResizeFillIn fiTitle 
&Scoped-Define DISPLAYED-OBJECTS fiResizeFillIn fiTitle 

/* ************************  Function Prototypes ********************** */
FUNCTION getResizeBar RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

FUNCTION getTitleBar RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

FUNCTION getTreeViewOCX RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* ***********************  Control Definitions  ********************** */
##Loop:ListContainerObjects##
define variable ##getInstanceHandleName([InstanceName])## as handle no-undo.    /* ##[InstanceName]## */
##Loop:End##
    
/* Define the widget handle for the window                              */
DEFINE VAR wTreeWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_smarttreeview AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiResizeFillIn AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 1.4 BY 10.29
     BGCOLOR 0  NO-UNDO.

DEFINE VARIABLE fiTitle AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 54 BY .86
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fTreeMain
     fiResizeFillIn AT ROW 1.48 COL 41 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fiTitle AT ROW 1.57 COL 42.6 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 99 BY 10.86.


/* *************************  Create Window  ************************** */
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wTreeWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Dynamic TreeView Controller"
         HEIGHT             = 10.86
         WIDTH              = 99
         MAX-HEIGHT         = 35.67
         MAX-WIDTH          = 204.8
         VIRTUAL-HEIGHT     = 35.67
         VIRTUAL-WIDTH      = 204.8
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

/* ************************* Included-Libraries *********************** */
{src/adm2/tvcontnr.i}

&scoped-define xp-Assign
{set ContainerType 'Window'}
{set ObjectType 'SmartWindow'}.
&undefine xp-Assign

/* ***********  Runtime Attributes and AppBuilder Settings  *********** */
ASSIGN fiResizeFillIn:MOVABLE IN FRAME fTreeMain          = TRUE
       fiResizeFillIn:READ-ONLY IN FRAME fTreeMain        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wTreeWin)
THEN wTreeWin:HIDDEN = yes.

/* ************************  Control Triggers  ************************ */
ON END-ERROR OF wTreeWin /* Dynamic TreeView Controller */
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

ON WINDOW-CLOSE OF wTreeWin /* Dynamic TreeView Controller */
DO:
    /* This ADM code must be left here in order for the SmartWindow
     * and its descendents to terminate properly on exit. */
    APPLY "CLOSE":U TO TARGET-PROCEDURE.
    RETURN NO-APPLY.
END.

ON WINDOW-MINIMIZED OF wTreeWin /* Dynamic TreeView Controller */
DO:
    RUN windowMinimized IN TARGET-PROCEDURE NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
        RETURN NO-APPLY.
END.

ON WINDOW-RESIZED OF wTreeWin /* Dynamic TreeView Controller */
DO:
  RUN resizeWindow IN TARGET-PROCEDURE NO-ERROR.
  IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
      RETURN NO-APPLY.
  PUBLISH "windowResized":U FROM TARGET-PROCEDURE.
END.

ON END-MOVE OF fiResizeFillIn IN FRAME fTreeMain
DO:
  PUBLISH "treeResized":U FROM TARGET-PROCEDURE.
END.

/* ***************************  Main Block  *************************** */
DEFINE VARIABLE iStartPage AS INTEGER NO-UNDO.

IF VALID-HANDLE({&WINDOW-NAME}) THEN
DO:
    /* Window Container Specific Stuff */
    RUN start-super-proc IN TARGET-PROCEDURE ("ry/app/rydynwindp.p":U).   

    ASSIGN CURRENT-WINDOW                    = {&WINDOW-NAME} 
           {&WINDOW-NAME}:KEEP-FRAME-Z-ORDER = YES
           TARGET-PROCEDURE:CURRENT-WINDOW   = {&WINDOW-NAME}
           .
  /* The CLOSE event can be used from inside or outside the procedure to  */
  /* terminate it.                                                        */
  ON CLOSE OF TARGET-PROCEDURE
  DO:
     RUN destroyObject IN TARGET-PROCEDURE NO-ERROR.
     IF ERROR-STATUS:ERROR THEN
       RETURN NO-APPLY.
  END.

  /* This will bring up all the links of the current object */
  ON CTRL-ALT-SHIFT-HOME ANYWHERE
  DO:
      RUN displayLinks IN TARGET-PROCEDURE.
  END.      

    ON ENTRY OF {&WINDOW-NAME} DO:
      ASSIGN CURRENT-WINDOW = SELF NO-ERROR.
    END.
END. /* IF VALID-HANDLE({&WINDOW-NAME}) */

/* **********************  Internal Procedures  *********************** */
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
    define variable cCurrentLanguage as character no-undo.
    define variable cProperties as character no-undo.
    define variable cInitPages as character no-undo.
    define variable lTranslationEnabled as logical no-undo.
    define variable iCurrentPage as integer no-undo.
    define variable iStartPage as integer no-undo.
    define variable hContainingWindow as handle no-undo.
    define variable hWindow as handle no-undo. 
    define variable cSuperProcedure as character no-undo.
    define variable cSuperProcedureMode as character no-undo.
    define variable cSuperHandle as character no-undo.
    define variable iLoop as integer no-undo.
    define variable cEntry as character no-undo.
    
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
            ##If:instanceIsVisual([InstanceClass])##            
            /* if this is not a generated object, then make sure it will be secured and translated.
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
            ##If:End##    /* instance is visual */
            
            /* Start the super procedure(s) for the object instance. */
            {get SuperProcedure cSuperProcedure ##getInstanceHandleName([InstanceName])##}.
            if cSuperProcedure ne '' and cSuperProcedure ne ? then
            do:
                cSuperHandle = ''.
                {get SuperProcedureMode cSuperProcedureMode ##getInstanceHandleName([InstanceName])##}.
                
                /* Default to stateful mode */
                if cSuperProcedureMode eq '' or cSuperProcedureMode eq ? then
                do:
                    cSuperProcedureMode = 'Stateful'.
                    {set SuperProcedureMode cSuperProcedureMode ##getInstanceHandleName([InstanceName])##}.
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
                                         hPlip, ##getInstanceHandleName([InstanceName])##).
                        if cSuperProcedureMode ne 'Stateless' then
                            cSuperHandle = cSuperHandle + ',' + string(hPlip).
                    end.    /* valid plip handle */
                end.    /* loop through supers */
                
                /* Keep the list of custom supers in context. */
                {set SuperProcedureHandle left-trim(cSuperHandle,',') ##getInstanceHandleName([InstanceName])##}.
            end.    /* start the super procedure  */
            ##Loop:End##    /* CreateContainerObjects */
            
            cInitPages = '##getInitPages([CurrentPageReference])##'.
            /* Init other pages this page may need */
            if cInitPages gt '':u then
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
        /* There are some static object that need to be
           manually constructed.
         */
        run constructObject in target-procedure ( INPUT  'adm2/dyntreeview.w':U ,
                                                  INPUT  frame {&Frame-Name}:handle,
                                                  INPUT  'AutoSortyesHideSelectionnoImageHeight16ImageWidth16ShowCheckBoxesnoShowRootLinesnoTreeStyle7ExpandOnAddnoFullRowSelectnoOLEDragnoOLEDropnoScrollyesSingleSelnoIndentation5LabelEdit1LineStyle1HideOnInitnoDisableOnInitnoObjectLayout':U ,
                                                  OUTPUT h_smarttreeview ).
        RUN repositionObject IN h_smarttreeview ( 1.57 , 1.80 ) NO-ERROR.
        RUN resizeObject IN h_smarttreeview ( 10.19 , 41.20 ) NO-ERROR.
        /* Links to SmartTreeView h_smarttreeview. */
        RUN addLink ( h_smarttreeview , 'TVController':U , Target-Procedure).
        
        ##If:[GenerateTranslations]##
        /* Translate the container. */
        assign cProperties = dynamic-function('getPropertyList':U IN gshSessionManager,
                                              'TranslationEnabled,CurrentLanguageCode':U,
                                              No)
               lTranslationEnabled = logical(ENTRY(1, cProperties, CHR(3)))
               cCurrentLanguage = ENTRY(2, cProperties, CHR(3))
               no-error.
        if lTranslationEnabled eq ? then
            lTranslationEnabled = yes.
        
        if lTranslationEnabled and
           can-do(this-procedure:internal-entries, 'translate-' + cCurrentLanguage) then
            run value('translate-' + cCurrentLanguage).
        ##If:End##
        
        {set StartPage ##getStartPage()##}.
    end.    /* current page = 0 */
    
    error-status:error = no.
    return.        
END PROCEDURE.    /* adm-create-objects */

PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wTreeWin)
  THEN DELETE WIDGET wTreeWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

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
  DISPLAY fiResizeFillIn fiTitle 
      WITH FRAME fTreeMain IN WINDOW wTreeWin.
  ENABLE fiResizeFillIn fiTitle 
      WITH FRAME fTreeMain IN WINDOW wTreeWin.
  VIEW wTreeWin.
END PROCEDURE.

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

##If:[ObjectHasMenu]##
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

##If:[GenerateTranslations]##
##Loop:translateWindow##
procedure translate-##[LanguageCode]##:
    ##If:[TranslatedWindowName]##
    /* Force the set function. WindowName is not a real property. */
    dynamic-function('setWindowName' in target-procedure, '##[WindowTitle]##').
    ##If:End##
    {set ObjectTranslated yes}.
    
    error-status:error = no.
    return.
end procedure.    /* translate-##[LanguageCode]## */

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
##Loop:End##    /* translatewindow loop */
##If:End##    /* generate translations */

procedure adm-loadNodes :
    define output parameter table for ttNode.
    
    ##Loop:createTreeviewNodes##
    create ttNode.
    assign
  	       ##Loop:createTreeviewNodeField##
           ttNode.##[NodeFieldName]## = ##[NodeFieldValue]##
	       ##Loop:End##    /* createTreeviewNodeField */
    .
    ##Loop:End##    /* createTreeviewNodes */
    
    error-status:error = no.
    return.
end procedure.    /* adm-loadNodes */

/* ************************  Function Implementations ***************** */
FUNCTION getResizeBar RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    RETURN fiResizeFillIn:HANDLE IN FRAME {&FRAME-NAME}.   /* Function return value. */
END FUNCTION.

FUNCTION getTitleBar RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN fiTitle:HANDLE IN FRAME {&FRAME-NAME}.   /* Function return value. */
END FUNCTION.

FUNCTION getTreeViewOCX RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF NOT VALID-HANDLE(ghTreeViewOCX) THEN 
    ghTreeViewOCX = WIDGET-HANDLE(ENTRY(1, DYNAMIC-FUNCTION("linkHandles":U IN TARGET-PROCEDURE, INPUT "TVController-Source":U))).

  RETURN ghTreeViewOCX.   /* Function return value. */
END FUNCTION.

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

##If:generateSuperInline()##
/* Object Custom Super Procedure */
{##[ObjectSuperProcedure]##}
##If:End##

/* ---oo00oo--- */
