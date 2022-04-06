&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
/* Procedure Description
"Super Procedure for Dynamic SmartDataViewer"
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*---------------------------------------------------------------------------------
  File: gsmsxmviewvsupr.p

  Description:  gsm_scm_xref maintenance viewer

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:          49   UserRef:    
                Date:   06/20/2003  Author:     Thomas Hansen

  Update Notes: Super procedure created for logic for maintenance viewer for gsm_scm_xref.

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

&scop object-name       gsmsxgenviewvsupr.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

DEFINE VARIABLE ghScmToolCombo    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghSDO             AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghScmTool         AS HANDLE   NO-UNDO.

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
         HEIGHT             = 16.29
         WIDTH              = 99.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/customsuper.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-buGenerateChoose) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buGenerateChoose Procedure 
PROCEDURE buGenerateChoose :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hScmToolObj    AS HANDLE   NO-UNDO.
DEFINE VARIABLE cOEM           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cError      AS CHARACTER  NO-UNDO.

  IF VALID-HANDLE(ghScmTool) THEN
  DO:
    ASSIGN ghScmToolCombo = widgetHandle('scm_tool_obj':U).
    
    
    SESSION:SET-WAIT-STATE("GENERAL":U). 
    
    {launch.i &PLIP = 'ry/prc/gsmsxplipp.p'
                      &IProc = 'generateScmXrefData'
                      &PList = "( INPUT DYNAMIC-FUNCTION('getDataValue' IN ghScmToolCombo),~
                                  INPUT widgetValue('raGenerateOEM'),~
                                  INPUT NO,~     /* Overwrite existing data */
                                  INPUT YES,  /* Set *unkown* in scm_foreign_key */
                                  INPUT widgetHandle('edStatus'),~
                                  OUTPUT cError)"
                      &OnApp = 'no'
                      &Autokill = YES}  
                      
    SESSION:SET-WAIT-STATE("":U).                            
  END.
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
  DEFINE VARIABLE cListItemPairs    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDelimiter        AS CHARACTER  NO-UNDO.
  
  /* get the handle of the SCM Tool */
  ghScmTool = DYNAMIC-FUNCTION('getProcedureHandle':U IN THIS-PROCEDURE, INPUT 'PRIVATE-DATA:SCMTool':U) NO-ERROR.
    
  /* If the SCM tool isn ot available, do not enable the window for generating 
     SCM xref data. We can opnly generate data when both the Dynamics repository 
     and the SCM repository are available. */
     
  IF NOT VALID-HANDLE(ghScmTool) THEN
  DO:
    assignWidgetValue('EdStatus', "The SCM Tool is not available. " + "~n":U + "~n":U +
                                  "SCM Xref data can only be generated when data is available from both the ICFDB database and the SCM tool at the same time.").    
    
    disableWidget('EdStaus').
    disableWidget('raGenerateOEM').
    disableWidget('buGenerate'). 
  END.
  
  RUN SUPER. 
      
  /* If the SCM tool is avauilable, then enable the combos and generate button */
  IF VALID-HANDLE(ghScmTool) THEN
  DO:
    enableWidget('buGenerate'). 
    enableWidget('raGenerateOEM').
    enableWidget('EdStaus').
    
    ASSIGN
      ghScmToolCombo = widgetHandle('scm_tool_obj':U).

    RUN displayFields IN TARGET-PROCEDURE (?).
    RUN enableField IN widgethandle('scm_tool_obj':U).
                
    /* Get the list-item pairs from the combo and set the initial screen value */
    {get ListItemPairs cListItemPairs ghScmToolCombo}.
    {get ComboDelimiter cDelimiter ghScmToolCombo}.
    IF cListItemPairs NE "":U THEN
      assignWidgetValue('scm_tool_obj':U, ENTRY(2, cListItemPairs, cDelimiter)).    
  END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

