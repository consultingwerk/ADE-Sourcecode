&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
/* Procedure Description
"Super Procedure for Dynamic SmartDataViewer"
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------

  File: gsmsxotviewvsupr.p

  Description: Super Procedure for SCM Xref Object Type viewer

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Thomas Hansen

  Created: 05/27/03 -  1:03 am

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{src/adm2/globals.i}

DEFINE VARIABLE ghOwningObjLookup         AS HANDLE   NO-UNDO.
DEFINE VARIABLE ghOwningEntityLookup      AS HANDLE   NO-UNDO.
DEFINE VARIABLE ghSCMForeignKeyCombo      AS HANDLE   NO-UNDO.
DEFINE VARIABLE gcScmObjectTypeList       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghDataSource              AS HANDLE   NO-UNDO.

DEFINE VARIABLE gcOwningEntity            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcOldOwningEntity         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gdOwningObj               AS DECIMAL    NO-UNDO.

DEFINE VARIABLE gcContainerMode           AS CHARACTER  NO-UNDO.

DEFINE VARIABLE ghSCMTool            AS HANDLE     NO-UNDO.

DEFINE VARIABLE ghToolbar           AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghContainerSource         AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghContainerHandle         AS HANDLE   NO-UNDO.

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
         HEIGHT             = 17.05
         WIDTH              = 117.
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

&IF DEFINED(EXCLUDE-addRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord Procedure 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSCMCombo AS HANDLE   NO-UNDO.
  DEFINE VARIABLE cSCMListItems AS CHARACTER  NO-UNDO.
  
  RUN SUPER. 
    
    /* If the initial value of the SCM tool combo is blank - then 
       set it to the first entry in the list item pairs of the combo */
    IF widgetValue('scm_tool_obj') = ? THEN
      ASSIGN hSCMCombo = widgetHandle('scm_tool_obj':U). 
    IF VALID-HANDLE(hSCMCombo) THEN
    DO:
      ASSIGN cSCMListItems = DYNAMIC-FUNCTION('getListItemPairs' IN hSCMCombo). 
        IF DYNAMIC-FUNCTION('getDataValue':U IN hSCMCombo) = 0.0 AND 
           cSCMListItems NE "":U THEN 
        assignWidgetValue('scm_tool_obj':U, ENTRY(2,cSCMListItems, CHR(1))).
    END.
    
    /* Assign the value of the hidden field for owning_entity_mnemomnic */
    assignWidgetValue('owning_entity_mnemonic':U, "GSCOT":U).     
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
  DEFINE VARIABLE hFolderHandle    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cBaseQuerySTring  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSCMForeignKeyLookup  AS HANDLE   NO-UNDO.
  
  /* Code placed here will execute PRIOR to standard behavior. */
  {get containerSource ghContainerSource}. 
  {get ContainerToolbarSource   ghToolbar   ghContainerSource}.    
  
  {get containerHandle ghContainerHandle ghContainerSource}.
  
  IF NOT VALID-HANDLE(ghScmTool) THEN
    ASSIGN ghScmTool = DYNAMIC-FUNCTION('getProcedureHandle':U IN THIS-PROCEDURE, INPUT 'PRIVATE-DATA:SCMTool':U) NO-ERROR.

  /* Hide the owning_entity_mnemomnic field as this is not beig hidden properly */
  hideWidget('owning_entity_mnemomnic'). 

  RUN SUPER.       
  
  ASSIGN hSCMForeignKeyLookup = widgetHandle('scm_foreign_key':U). 
  
  IF VALID-HANDLE(ghScmTool) THEN
  DO:
    IF CONNECTED("RTB":U) THEN
    DO:
      ASSIGN cBaseQueryString = "FOR EACH rtb.rtb_subtype NO-LOCK":U. 
      
      /* Set the lookup datatypes */
      DYNAMIC-FUNCTION('setDisplayDataType'      IN hSCMForeignKeyLookup, INPUT "CHARACTER").                          
      DYNAMIC-FUNCTION('setKeyDataType'          IN hSCMForeignKeyLookup, INPUT "CHARACTER"). 
      
      /* Set the label of the field */
      DYNAMIC-FUNCTION('setFieldLabel'           IN hSCMForeignKeyLookup, INPUT "SCM code subtype"). 
      
      /* Set the lookup field formats */
      DYNAMIC-FUNCTION('setDisplayFormat'        IN hSCMForeignKeyLookup, INPUT "X(35)").
      DYNAMIC-FUNCTION('setKeyFormat'            IN hSCMForeignKeyLookup, INPUT "X(35)").   
      
      
      DYNAMIC-FUNCTION('setKeyField'             IN hSCMForeignKeyLookup, INPUT "rtb_subtype.sub-type"). 
      DYNAMIC-FUNCTION('setDisplayedField'       IN hSCMForeignKeyLookup, INPUT "rtb_subtype.sub-type"). 
      
      /* Set query properties */
      DYNAMIC-FUNCTION('setBaseQueryString':U    IN hSCMForeignKeyLookup, INPUT cBaseQueryString).
      DYNAMIC-FUNCTION('setQueryTables'          IN hSCMForeignKeyLookup, INPUT "rtb_subtype").
      
      /* Set browser properties  */
      DYNAMIC-FUNCTION('setBrowseFields'         IN hSCMForeignKeyLookup, INPUT "rtb_subtype.sub-type").
      DYNAMIC-FUNCTION('setColumnFormat'         IN hSCMForeignKeyLookup, INPUT "X(20)").      
      DYNAMIC-FUNCTION('setColumnLabels'         IN hSCMForeignKeyLookup, INPUT "Code subtype").
      DYNAMIC-FUNCTION('setBrowseFieldDataTypes' IN hSCMForeignKeyLookup, INPUT "character").
      DYNAMIC-FUNCTION('setBrowseTitle'          IN hSCMForeignKeyLookup, INPUT "SCM code subtype lookup").
    END.        
  END.
  ELSE
  DO:
    disableWidget('scm_foreign_key':U).
    disableWidget('owning_obj':U).
    disableWidget('scm_tool_obj':U).  
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject Procedure 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE cDisabledActions  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWindowTitle    AS CHARACTER  NO-UNDO.
  
  RUN SUPER.  
  
  IF NOT VALID-HANDLE(ghScmTool) THEN
  DO:  
    /* Disable the menu actions that are not valid if the 
       SCM tool is not available. 
    */
    {get disabledActions cDisabledActions ghToolbar}. 
    cDisabledActions = cDisabledActions + (IF cDisabledActions = "":U THEN "":U ELSE ",":U) 
                     + "Add,Copy,Delete,Modify".   
    
    DYNAMIC-FUNCTION("setDisabledActions":U IN ghToolbar, cDisabledActions).
    DYNAMIC-FUNCTION("disableActions":U     IN ghToolbar, cDisabledActions).
  
    /* Show that the SCM tool is not available in the window title */        
    IF INDEX(ghContainerHandle:TITLE, "SCM tool":U) = 0 THEN
    DO:
      ASSIGN 
        cWindowTitle = ghContainerHandle:TITLE + " [":U + "READ ONLY : SCM tool not available]". 
        {set WindowName cWindowTitle ghContainerSource}.      
    END.  
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

