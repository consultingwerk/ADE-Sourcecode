&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
/* Procedure Description
"Super Procedure for Custom Layout Selection Viewer"
*/
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
  File: rycstlovsupr.p

  Description:  Custom Layout Selection Viewer

  Purpose:      Provides the UI that allows developers to specify a different custom layout
                for the current object in the AppBuilder

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   02/14/2003  Author:     

  Update Notes: Created from Template viewv

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rycstlovsupr.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

&GLOBAL-DEFINE Default-Layout "Default Layout":U

define variable gc-PROP-CodeList as character no-undo.
define variable gc-PROP-ListItems as character no-undo.
define variable ghSuperProc as handle no-undo.
DEFINE VARIABLE ghCurObject     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghcType         AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghEdDescription AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghResultCode    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghRemoveButton  AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghAddButton     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghRCLookup      AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getListItems) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getListItems Procedure
FUNCTION getListItems RETURNS CHARACTER 
	(  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCodeList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCodeList Procedure
FUNCTION getCodeList RETURNS CHARACTER 
	(  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setListItems) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setListItems Procedure
FUNCTION setListItems RETURNS LOGICAL 
	(input pcListItems as character) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCodeList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCodeList Procedure
FUNCTION setCodeList RETURNS LOGICAL 
	(input pcCodeList as character) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Compile into: 
   Allow: Basic,Browse,DB-Fields
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 16.33
         WIDTH              = 71.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
    /* Start a custom super procedure that deals with the ADEUIB stuff, 
       like _ tables. This super must be started manually, since adeuib
       files aren't registered in the repository, and the Dynamics rendering
       engines require super procedures to be registered in the repository. 
       
       Note that manual start means manual stop, in destroyObject. */
    run startProcedure ('ONCE|adeuib/_customlayoutselsuper.p', output ghSuperProc).
    if valid-handle(ghSuperProc) then
        target-procedure:add-super-procedure(ghSuperProc, search-target).

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */ 
&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure
PROCEDURE destroyObject:
/*------------------------------------------------------------------------------
    Purpose:
    Parameters: <none>
    Notes:
------------------------------------------------------------------------------*/
    run super.
    
    /* Kill off the super procedure */    
    if valid-handle(ghSuperProc) then
        run killPlips in gshSessionManager ('', string(ghSuperProc)).
    
END PROCEDURE.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addResultCode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addResultCode Procedure 
PROCEDURE addResultCode :
/*------------------------------------------------------------------------------
  Purpose:     Add a new result code for the current object
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cNewCode                         AS CHARACTER  NO-UNDO.
    define variable cValues as character no-undo.
    define variable cCodeList as character no-undo.
    define variable cListItems as character no-undo.
    define variable cButtonPressed as character no-undo.

    {get DataValue cNewCode ghRCLookup}.
  
    run getRecordDetail in gshGenManager (" FOR EACH ryc_customization_result WHERE ":u
                                          + " ryc_customization_result.customization_result_obj = ":u
                                          + quoter(cNewCode)
                                          + "  NO-LOCK ":u,
                                          output cValues).
    if cValues ne ? and cValues ne '':u then
    do:
        cNewCode = entry(lookup('ryc_customization_result.customization_result_code':u, cValues, chr(3)) + 1, cValues, chr(3)).

        {get CodeList cCodeList}.
        IF LOOKUP(cNewCode, cCodeList) > 0 THEN
        DO:
            run showMessages in gshSessionManager ({errortxt.i 'AF' '31' '?' '?' "'customization for ' + ghCurObject:SCREEN-VALUE" "'result code ' + cNewCode"},
                                                   'Info':u,
                                                   '&OK',
                                                   '&OK',
                                                   '&OK',
                                                   '',
                                                   Yes,
                                                   {fn getContainerSource},
                                                   cButtonPressed).
            return error.
        END.
        
        {get ListItems cListItems}.
        
        ASSIGN cCodeList  = cCodeList + ",":U + cNewCode
               cListItems = cListItems + "|":U + cNewCode + "|":U + cNewCode
               ghResultCode:LIST-ITEM-PAIRS = cListItems
               ghResultCode:SCREEN-VALUE    = cNewCode.
      
        {set CodeList cCodeList}.
        {set ListItems cListItems}.
        RUN DisplayCodes in target-procedure.
    
        {set DataValue '' ghRCLookup}.
        {set DataModified TRUE}.
    END.    /* available customisation result */
    ELSE
        run showMessages in gshSessionManager ({errortxt.i 'AF' '1' '?' '?' '"Result Code"'},
                                               'Info':u,
                                               '&OK',
                                               '&OK',
                                               '&OK',
                                               '',
                                               Yes,
                                               {fn getContainerSource},
                                               cButtonPressed).
    
    ghAddButton:SENSITIVE = FALSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DisplayCodes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DisplayCodes Procedure 
PROCEDURE DisplayCodes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define variable cValues as character no-undo.

    run getRecordDetail in gshGenManager (" FOR EACH ryc_customization_result WHERE ":u
                                          + " ryc_customization_result.customization_result_code = ":u
                                          + quoter(ghResultCode:SCREEN-VALUE)
                                          + "  NO-LOCK, ":u
                                          + " FIRST ryc_customization_type OF ryc_customization_result NO-LOCK":U,
                                          output cValues).
                                          
    if cValues eq ? or cValues eq '':u then
    do:
        IF ghResultCode:SCREEN-VALUE = {&Default-Layout} THEN
            ASSIGN ghEdDescription:SCREEN-VALUE = 'The default or "Master" layout'
                   ghcType:SCREEN-VALUE = "<None>":U
                   ghRemoveButton:SENSITIVE = FALSE.
    END.
    ELSE DO:
        ghEdDescription:SCREEN-VALUE = dynamic-function('mappedEntry':u in target-procedure,
                                                        'ryc_customization_result.customization_result_desc':u,
                                                        cValues,
                                                        yes,
                                                        chr(3)).
        ghcType:SCREEN-VALUE = dynamic-function('mappedEntry':u in target-procedure,
                                                'ryc_customization_type.customization_type_desc':u,
                                                cValues,
                                                yes,
                                                chr(3)).
        ghRemoveButton:SENSITIVE = TRUE.
    END.

    IF SELF = ghResultCode THEN
        {set DataModified TRUE}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    run super.
    
    ghRCLookup = {fnarg WidgetHandle '<LOCAL>':U}.
    ghAddButton = {fnarg WidgetHandle 'buAdd':U}.    
    ghRemoveButton = {fnarg WidgetHandle 'buRemove':U}.
    ghCurObject = {fnarg WidgetHandle 'cCurObj'}.
    ghcType = {fnarg WidgetHandle 'cRCType':U}.
    ghEdDescription = {fnarg WidgetHandle 'cRCDescription':U}.
    ghResultCode = {fnarg WidgetHandle 'cResultCode':U}.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-LookupComplete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LookupComplete Procedure 
PROCEDURE LookupComplete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcnames    AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcValues   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcNewKey   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcNewValue AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcOldValue AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plWhere    AS LOGICAL    NO-UNDO.
DEFINE INPUT  PARAMETER pHandle    AS HANDLE     NO-UNDO.

  ghAddButton:SENSITIVE = TRUE.
  APPLY "ENTRY" TO ghAddButton.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */
&IF DEFINED(EXCLUDE-getListItems) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getListItems Procedure
FUNCTION getListItems RETURNS CHARACTER 
	(  ):
/*------------------------------------------------------------------------------
    Purpose:
    Notes:
------------------------------------------------------------------------------*/
    return gc-PROP-ListItems.
END FUNCTION.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
&IF DEFINED(EXCLUDE-getCodeList) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCodeList Procedure
FUNCTION getCodeList RETURNS CHARACTER 
	(  ):
/*------------------------------------------------------------------------------
    Purpose:
    Notes:
------------------------------------------------------------------------------*/
    return gc-PROP-CodeList.
END FUNCTION.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setListItems) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setListItems Procedure
FUNCTION setListItems RETURNS LOGICAL 
	( input pcListItems as character ):
/*------------------------------------------------------------------------------
    Purpose:
    Notes:
------------------------------------------------------------------------------*/
    gc-PROP-ListItems = pcListItems.
    return true.
END FUNCTION.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
&IF DEFINED(EXCLUDE-setCodeList) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCodeList Procedure
FUNCTION setCodeList RETURNS LOGICAL 
	( input pcCodeList as character ):
/*------------------------------------------------------------------------------
    Purpose:
    Notes:
------------------------------------------------------------------------------*/
    gc-PROP-CodeList = pcCodeList.    
    return true.
END FUNCTION.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

