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

/* Astra 2 object identifying preprocessor */
&glob   astra2-dynamicbrowser yes

{src/adm2/globals.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
&SCOPED-DEFINE include-destroyobject

/* ********************  Preprocessor Definitions  ******************** */
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table
&scoped-define ADM-CONTAINER-HANDLE frame {&Frame-Name}:handle

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 

/* ************************  Function Prototypes ********************** */

/* ***********************  Control Definitions  ********************** */

/* Browse definitions                                                   */
DEFINE BROWSE br_table
    WITH NO-ASSIGN NO-ROW-MARKERS NO-COLUMN-SCROLLING SEPARATORS SIZE 66 BY 6.67.


/* ************************  Frame Definitions  *********************** */
DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */
/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

/* ************************* Included-Libraries *********************** */
{src/adm2/browser.i}

&scoped-define xp-Assign
{set ContainerType ''}
{set ObjectType 'SmartDataBrowser'}.
&undefine xp-Assign

/* ***********  Runtime Attributes and AppBuilder Settings  *********** */
ASSIGN FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table

ON CTRL-END OF br_table IN FRAME F-Main
DO:
   APPLY "END":U TO BROWSE {&BROWSE-NAME}.
END.

ON CTRL-HOME OF br_table IN FRAME F-Main
DO:
  APPLY "HOME":U TO BROWSE {&BROWSE-NAME}.
END.

ON END OF br_table IN FRAME F-Main
DO:
  {src/adm2/brsend.i}
END.

ON F5 OF br_table IN FRAME F-Main
DO:
    RUN refreshQuery IN TARGET-PROCEDURE.
END.

ON HOME OF br_table IN FRAME F-Main
DO:
  {src/adm2/brshome.i}
END.

ON OFF-END OF br_table IN FRAME F-Main
DO:
  {src/adm2/brsoffnd.i}
END.

ON OFF-HOME OF br_table IN FRAME F-Main
DO:
  {src/adm2/brsoffhm.i}
END.

ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  {src/adm2/brsentry.i}
END.

ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
  {src/adm2/brsleave.i}
END.

ON SCROLL-NOTIFY OF br_table IN FRAME F-Main
DO:
  {src/adm2/brsscrol.i}
END.

ON START-SEARCH OF br_table IN FRAME F-Main
DO:
  RUN startSearch IN TARGET-PROCEDURE(SELF).
END.

ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  {src/adm2/brschnge.i}
END.


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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    RUN SUPER.
      
    /* fix for issues 5931, 8293 */
    /* The following code is a workaround for a core bug in the browse */
    /* widget which causes the browse query to release the current query */
    /* buffer as a result of direct manipulation of certain attributes. */
    /* So, we need to save the current Rowid, if any, and re-find it later */
    DEFINE VARIABLE hRO       AS HANDLE     NO-UNDO. 
    DEFINE VARIABLE rCurRowid AS ROWID      NO-UNDO.
    hRO = BROWSE {&BROWSE-NAME}:QUERY:GET-BUFFER-HANDLE() NO-ERROR.
    IF VALID-HANDLE(hRO) AND hRO:AVAILABLE THEN
      rCurRowid = hRO:ROWID.
 
    BROWSE {&BROWSE-NAME}:EXPANDABLE = TRUE.

    IF VALID-HANDLE(hRO) THEN 
      IF rCurRowid <> ? THEN 
        IF rCurRowid <> hRO:ROWID THEN     /* IF a valid buffer existed in the beginning... */
          hRO:FIND-BY-ROWID (rCurRowid, NO-LOCK). /* ...attempt to find saved */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.

END PROCEDURE.  /* initializeObject */

FUNCTION notNull RETURNS CHARACTER
  ( pcValue AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN (IF pcValue = ? THEN "?" ELSE pcValue).

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

##If:[GenerateTranslations]##
##Loop:translateBrowser##
procedure translate-##[LanguageCode]##:
    ##Exclude:##
    /* Use a dyn-function here instead of {set} since it makes dealing with quotes way way easier. */
    ##Exclude:End##
    dynamic-function('set##[LabelAttribute]##' in target-procedure, '##[TranslatedLabel]##').
    {set ObjectTranslated yes}.
    
    error-status:error = no.
    return.
end procedure.    /* translate-##[LanguageCode]## */
##Loop:End##
##If:End##    /* generate translations */
    
##If:eitherTranslationOrSecurityEnabled()##
procedure createObjects:
    define variable cProperties as character no-undo.
    define variable cFieldSecurity as character no-undo.
    define variable cDisplayedFields as character no-undo.
    ##If:[GenerateSecurity]##    
    define variable lSecurityEnabled as logical no-undo.
    define variable lFieldSecurityExists as logical no-undo.
    define variable hContainer as handle no-undo.
    define variable cContainerName as character no-undo.
    define variable cRunAttribute as character no-undo.    
    define variable iLoop as integer no-undo.
    define variable iPos as integer no-undo.
    define variable cSecuredFields as character no-undo.
    ##If:End##
    ##If:[GenerateTranslations}##        
    define variable lTranslationEnabled as logical no-undo.
    define variable cCurrentLanguage as character no-undo.
    ##If:End##
                    
    run super.
    
    cProperties = dynamic-function('getPropertyList':U IN gshSessionManager,
                                   'SecurityEnabled,GSMFFSecurityExists,TranslationEnabled,CurrentLanguageCode',
                                   No).
    
    {get DisplayedFields cDisplayedFields}.
    cFieldSecurity = fill(',', num-entries(cDisplayedfields) - 1).
        
    ##If:[GenerateSecurity]##
    lSecurityEnabled = logical(entry(1, cProperties, chr(3))) no-error.
    if lSecurityEnabled eq ? then lSecurityEnabled = yes.
    
    if lSecurityEnabled then
    do:
        lFieldSecurityExists = logical(entry(4, cProperties, chr(3))) no-error.
        if lFieldSecurityExists eq ? then lFieldSecurityExists = yes.
        {get ContainerSource hContainer}.
        &scoped-define xp-Assign
        {get LogicalObjectName cContainerName hContainer}
        {get RunAttribute cRunAttribute hContainer}
        .
        &undefine xp-Assign
        run fieldSecurityCheck in gshSecurityManager (input  cContainerName,
                                                      input  cRunAttribute,
                                                      output cSecuredFields ).
        
        if cSecuredFields ne ? and cSecuredFields ne '' then
        do:
            do iLoop = 1 to num-entries(cDisplayedFields):
                iPos = lookup(entry(iLoop, cDisplayedFields), cSecuredFields).
                if iPos gt 0 then
                    entry(iLoop, cFieldSecurity) = entry(iPos + 1, cSecuredFields).
            end.    /* loop through fields and secure */
            
            {set ObjectSecured yes}.
        end.    /* there is security */
    end.    /* security enabled */    
    ##If:End##    /* generate security */
    
    /* always set the FieldSecurity property, 
       even if there is no security.
     */
    {set FieldSecurity cFieldSecurity}.
    
    ##If:[GenerateTranslations]##
    /* Translate the browser. */
    assign lTranslationEnabled = logical(entry(3, cProperties, CHR(3)))
           cCurrentLanguage = entry(4, cProperties, CHR(3)).
    
    if lTranslationEnabled and
       can-do(this-procedure:internal-entries, 'translate-' + cCurrentLanguage) then
        run value('translate-' + cCurrentLanguage).
    ##If:End##    /* generate translations */
        
    error-status:error = no.        
    return.
end procedure.    /* createObjects */
##If:End##    /* either security or translations enabled */
    
##If:generateSuperInline()##
{##[ObjectSuperProcedure]##}
##If:End##
