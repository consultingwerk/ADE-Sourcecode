##Include:[StandardHeaderComment]##

&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{src/adm2/globals.i}

##If:[GenerateThinRendering]##
/* ThinRendering Enabled */
&GLOBAL-DEFINE ADM-EXCLUDE-PROTOTYPES
&GLOBAL-DEFINE ADM-EXCLUDE-STATIC
&SCOPED-DEFINE exclude-start-super-proc
/* ThinRendering */
##If:End##

&scoped-define adm-prepare-static-object yes
&scoped-define adm-prepare-class-name ##[ClassName]##
##Exclude:##
/* SDOs don't have any super procedures. THeir business logic is
   typically contained in the DataLogic procedure.
*/
##Exclude:End##
&scoped-define adm-prepare-super-procedure 
&scoped-define adm-prepare-super-procedure-mode 

/* tell smart.i that we can use the default destroyObject */ 
&SCOPED-DEFINE include-destroyobject

/* Db-Required definitions. */
&IF DEFINED(DB-REQUIRED) = 0 &THEN
    &GLOBAL-DEFINE DB-REQUIRED TRUE
&ENDIF
&GLOBAL-DEFINE DB-REQUIRED-START   &IF {&DB-REQUIRED} &THEN
&GLOBAL-DEFINE DB-REQUIRED-END     &ENDIF

&Scoped-define QUERY-NAME Query-Main

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

/* ************************* Included-Libraries *********************** */
{src/adm2/data.i}

&scoped-define xp-Assign
{set ContainerType ''}
{set ObjectType 'SmartDataObject'}.
&undefine xp-Assign

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
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

##If:[GenerateTranslations]##
procedure createObjects:
    define variable cCurrentLanguage as character no-undo.
    define variable cProperties as character no-undo.
    define variable lTranslationEnabled as logical no-undo.    
    
    run super.
    
    /* Translations should only occur after the RowObject
       has been created.
     */
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
    
    error-status:error = no.
    return.
end procedure.    /* createObjects */
##If:End##    /* Generate translations */
    
##If:[GenerateTranslations]##
##Loop:translateSDO##
procedure translate-##[LanguageCode]##:
    define variable hRowObject as handle no-undo.
    {get RowObject hRowObject}.
    
    if valid-handle(hRowObject) then
        assign
    ##Loop:translateRowObject##
    ##If:[HasTranslatedLabel]##
            hRowObject:buffer-field('##[ColumnName]##'):label = '##[TranslatedLabel]##'
    ##If:End##
    ##If:[HasTranslatedColumnLabel]##
            hRowObject:buffer-field('##[ColumnName]##'):column-label = '##[TranslatedColumnLabel]##'
    ##If:End##
    ##Loop:End##
        .
    error-status:error = no.
    return.
end procedure.    /* translate-##[LanguageCode]## */
##Loop:End##    /* translateSDO loop */
##If:End##    /* generate translations */
    
/* *************************  Functions     ************************** */
FUNCTION adm-assignObjectProperties returns logical:
 /*------------------------------------------------------------------------------ 
  Purpose:  Sets the properties for the object.
    Notes: 
  ------------------------------------------------------------------------------*/ 
    /* Assignable properties */
    &scoped-define xp-Assign
    {set LogicalObjectName '##[ObjectName]##'}
    {set SuperProcedure ''}
    {set SuperProcedureMode ''}
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
/* ---oo00oo--- */
