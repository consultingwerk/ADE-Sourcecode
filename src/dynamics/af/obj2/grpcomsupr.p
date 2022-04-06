&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
/* Procedure Description
"Super Procedure for Group to Company Allocation"
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
  File: grpcomsupr.p

  Description:  Group to Company Allocation

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/19/2003  Author:     

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

&scop object-name       grpcomsupr.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

DEFINE VARIABLE gdGroupObj    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE glChangesMade AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glInit        AS LOGICAL    NO-UNDO.

{af/app/afsecttdef.i}

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
         HEIGHT             = 13.1
         WIDTH              = 81.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/customsuper.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    /* RUN initializeObject. */  /* Commented out by migration progress */
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-allSelected) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE allSelected Procedure 
PROCEDURE allSelected :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER plAll AS LOGICAL    NO-UNDO.
  
  IF plAll THEN
    assignWidgetValue("toAll":U, "YES":U).
  ELSE
    assignWidgetValue("toAll":U, "NO":U).
  
  RUN appliesToAll IN TARGET-PROCEDURE (INPUT "":U).

  {set DataModified FALSE}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-appliesToAll) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE appliesToAll Procedure 
PROCEDURE appliesToAll :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcChanged AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hSecuritySource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFrame          AS HANDLE     NO-UNDO.

  hSecuritySource = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U IN TARGET-PROCEDURE, INPUT "Security-Target":U)).

  IF NOT VALID-HANDLE(hSecuritySource) THEN
    RETURN.
  
  RUN hideObject IN hSecuritySource.
  IF NOT widgetIsTrue("toAll":U) THEN DO:
    {get ContainerHandle hFrame}.
    IF NOT hFrame:HIDDEN THEN
      RUN viewObject IN hSecuritySource.
  END.

  IF pcChanged = "YES":U THEN
    RUN dataChanged IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable Procedure 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcState AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE hDataSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cQuestion   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton     AS CHARACTER  NO-UNDO.

  {get DataSource hDataSource}.

  IF glChangesMade THEN DO:
    cQuestion = {aferrortxt.i 'AF' '131' '' '?' '"group to login company allocations"'}.

    RUN showMessages IN gshSessionManager (INPUT cQuestion,
                                           INPUT "QUE":U,
                                           INPUT "&YES,&NO":U,
                                           INPUT "&NO":U,
                                           INPUT "&NO":U,
                                           INPUT "Save Changes",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).

    IF cButton = "&YES":U THEN 
      RUN updateRecord IN TARGET-PROCEDURE.
  END.

  glChangesMade = FALSE.
  gdGroupObj = DECIMAL(ENTRY(2,DYNAMIC-FUNCTION("colValues":U IN hDataSource, "user_obj":U),CHR(1))).
  
  IF gdGroupObj = ? THEN
    gdGroupObj = 0.

  IF glInit = TRUE THEN
  
  RUN initializeSecurity IN TARGET-PROCEDURE.
  RUN appliesToAll IN TARGET-PROCEDURE (INPUT "":U).
  
  {set DataModified FALSE}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataChanged Procedure 
PROCEDURE dataChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hToolbarHandle   AS HANDLE     NO-UNDO.

  hToolbarHandle = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U IN TARGET-PROCEDURE, "SecToolbar-Source":U)).
    
  IF VALID-HANDLE(hToolbarHandle) THEN
    DYNAMIC-FUNCTION("sensitizeActions":U IN hToolbarHandle, "Save,Reset":U, TRUE).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-InitializationDone) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializationDone Procedure 
PROCEDURE InitializationDone :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  glInit = TRUE.
  RUN initializeSecurity IN TARGET-PROCEDURE.

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
  DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hToolbarHandle AS HANDLE     NO-UNDO.

  {get ContainerSource hContainerSource}.

  hToolbarHandle = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U IN TARGET-PROCEDURE, "SecToolbar-Source":U)).
  
  IF VALID-HANDLE(hToolbarHandle) THEN DO:
    SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "updateRecord":U IN hToolbarHandle.
    SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "resetRecord":U IN hToolbarHandle.
  END.

  glInit = FALSE.
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "DataChanged":U IN hContainerSource.
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "resetSecurity":U IN hContainerSource.
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "InitializationDone" IN hContainerSource.
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "allSelected":U IN hContainerSource.
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "viewAllocationObject" IN hContainerSource.

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeSecurity Procedure 
PROCEDURE initializeSecurity :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSecuritySource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainer      AS HANDLE     NO-UNDO.

  {get ContainerSource hContainer}.

  hSecuritySource = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U IN TARGET-PROCEDURE, INPUT "Security-Target":U)).
  
  IF VALID-HANDLE(hSecuritySource) THEN
    RUN refreshQueryDetail IN hSecuritySource (INPUT gdGroupObj, 
                                               INPUT 0, 
                                               INPUT "GSMGA":U,
                                               INPUT "Login Company":U,
                                               INPUT TRUE,
                                               INPUT 1000).

  PUBLISH "companyAllocation":U FROM hContainer.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetRecord Procedure 
PROCEDURE resetRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO.
    
    {get ContainerSource hContainer}.
    
    PUBLISH "resetSecurity":U FROM hContainer.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetSecurity Procedure 
PROCEDURE resetSecurity :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hToolbarHandle   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainer       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cHiddenActions   AS CHARACTER  NO-UNDO.

  hToolbarHandle = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U IN TARGET-PROCEDURE, "SecToolbar-Source":U)).
    
  IF VALID-HANDLE(hToolbarHandle) THEN
    DYNAMIC-FUNCTION("sensitizeActions":U IN hToolbarHandle, "Save,Reset":U, FALSE).
  
  RUN initializeSecurity IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateForAll) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateForAll Procedure 
PROCEDURE updateForAll :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  /* Delete any records */
  CREATE ttUpdatedAllocations.
  ASSIGN ttUpdatedAllocations.owning_entity_mnemonic = "GSMLG":U
         ttUpdatedAllocations.owning_obj             = 0
         ttUpdatedAllocations.lDeleteAll             = TRUE.

  RUN updateUserAllocations IN gshSecurityManager (INPUT gdGroupObj,
                                                   INPUT 0,
                                                   INPUT TABLE ttUpdatedAllocations).
END PROCEDURE.

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
  DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO.
  
  {get ContainerSource hContainer}.
  
  IF widgetIsTrue("toAll":U) THEN DO:
    RUN updateForAll IN TARGET-PROCEDURE.
    RUN resetSecurity IN TARGET-PROCEDURE.
  END.
  ELSE
    PUBLISH "updateSecurity":U FROM hContainer.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewAllocationObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewAllocationObject Procedure 
PROCEDURE viewAllocationObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE hSecuritySource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFrame          AS HANDLE     NO-UNDO.

  hSecuritySource = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U IN TARGET-PROCEDURE, INPUT "Security-Target":U)).

  IF NOT VALID-HANDLE(hSecuritySource) THEN
    RETURN.
  
  IF widgetIsTrue("toAll":U) THEN 
    RUN hideObject IN hSecuritySource.

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

  RUN SUPER.
  
  IF glInit THEN
    RUN initializeSecurity IN TARGET-PROCEDURE.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

