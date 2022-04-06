&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
/* Procedure Description
"Super Procedure for Dynamic SmartDataViewer"
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------

  File: gsmsxbrwsupr.p

  Description: Super procedure for browser for SCM Xref object controllers.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Thomas Hansen

  Created: 09/28/03

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

DEFINE VARIABLE ghToolbar                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghContainerSource         AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghContainerHandle         AS HANDLE   NO-UNDO.
  
DEFINE VARIABLE ghSCMTool            AS HANDLE     NO-UNDO.

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
         HEIGHT             = 9.76
         WIDTH              = 64.
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

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFolderHandle         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cBaseQuerySTring      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSCMForeignKeyLookup  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDisabledActions      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHiddenmenuActions    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWindowTitle          AS CHARACTER  NO-UNDO.

  RUN SUPER.
  
  /*      Get the container source and the handle to the toolbar (browsetoolbar) */
  /*      so that we can disable the actions that are not valid when the SCM     */
  /*      tool is not available                                                  */     
  &SCOPED-DEFINE xp-assign
  {get containerSource ghContainerSource}
  {get ToolbarSource ghToolbar}.
  &UNDEFINE xp-assign
  
  /* The container handle is needed to get the title of the container */
  {get containerHandle ghContainerHandle ghContainerSource}.
  
  IF NOT VALID-HANDLE(ghScmTool) THEN
    ASSIGN ghScmTool = {fnarg getProcedureHandle "'PRIVATE-DATA:SCMTool'"} NO-ERROR.
 
  IF NOT VALID-HANDLE(ghScmTool) THEN
  DO:
    /* Disable the menu actions that are not valid if the 
       SCM tool is not available - if there is a toolbar attached to this 
       object.
    */
    IF VALID-HANDLE(ghToolbar) THEN
    DO:
        {get disabledActions cDisabledActions ghToolbar}. 
        cDisabledActions = cDisabledActions + (IF cDisabledActions = "":U THEN "":U ELSE ",":U) 
                         + "Add2,Copy2,Delete2,Modify".
        
        {fnarg setDisabledActions cDisabledActions ghToolbar}.
        {fnarg disableActions cDisabledActions ghToolbar}.
    END.    /* valid toolbar */
    
    /* Show that the SCM tool is not available in the window title */        
    IF INDEX(ghContainerHandle:TITLE, "SCM tool":U) = 0 THEN
    DO:
      ASSIGN 
        cWindowTitle = ghContainerHandle:TITLE + " [":U + "READ ONLY : SCM tool not available" + "]":U. 
        {set WindowName cWindowTitle ghContainerSource}.
    END.
  END.    /* SCM tool is not running. */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

