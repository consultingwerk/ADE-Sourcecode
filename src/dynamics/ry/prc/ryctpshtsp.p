&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************
* Copyright (C) 1984-2007 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
***********************************************************************/
/*---------------------------------------------------------------------------------
  File: ryctpshtsp.p

  Description:  Container Property Sheet Super Procedure

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   03/09/2002  Author:     Chris Koster

  Update Notes: Created from Template rytemplipp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ryctpshtsp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{defrescd.i}
{src/adm2/globals.i}
{af/app/afdatatypi.i}
{ry/inc/rycntnerbi.i}

DEFINE TEMP-TABLE ttClassValues
  FIELD cClassCode      AS CHARACTER
  FIELD cAttributeLabel AS CHARACTER
  FIELD cAttributeValue AS CHARACTER
  INDEX idx1 cClassCode.

{launch.i &define-only = YES}

DEFINE VARIABLE gcProductModuleCode AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcObjectTypeCode    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcEnabledActions    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcFolderClasses     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcClassChildren     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcRunAttribute      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBatchedMode       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcTitle             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glToolbarDisabled   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glTransferActive    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glAppBuilder        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glEditMaster        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glDoPrompt          AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE gdTabRowHeight      AS DECIMAL    NO-UNDO INITIAL ?.
DEFINE VARIABLE gdHeightDifference  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE giLockWindow        AS INTEGER    NO-UNDO.
DEFINE VARIABLE ghGridObjectViewer  AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghLinkMaintenance   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghPageMaintenance   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghContainerViewer   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghContainerHandle   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghSBODLProcedure    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghDesignManager     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghPropertySheet     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghObjectLocator     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghPreferences       AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghSequencing        AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghPageSource        AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghMenuStruct        AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghFFMapper          AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghToolbar           AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghProcLib           AS HANDLE     NO-UNDO.

DEFINE TEMP-TABLE ttTmpltObjectMenuStructure  LIKE ttObjectMenuStructure.
DEFINE TEMP-TABLE ttTmpltObjectInstance       LIKE ttObjectInstance.
DEFINE TEMP-TABLE ttTmpltAttributeValue       LIKE ttAttributeValue.
DEFINE TEMP-TABLE ttTmpltSmartObject          LIKE ttSmartObject.
DEFINE TEMP-TABLE ttTmpltSmartLink            LIKE ttSmartLink.
DEFINE TEMP-TABLE ttTmpltUiEvent              LIKE ttUiEvent.
DEFINE TEMP-TABLE ttTmpltPage                 LIKE ttPage.

/* Preferences */
DEFINE VARIABLE gcTabVisualization  AS CHARACTER  NO-UNDO INITIAL "Framework":U.
DEFINE VARIABLE gcDefaultValues     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDefaultMode       AS CHARACTER  NO-UNDO INITIAL "Open":U.
DEFINE VARIABLE glSetTabsPerRow     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glAddPageNumber     AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE glRepositionPT      AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE glDeleteFolder      AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE glHideSubTools      AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE glIncludeTitle      AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE glConfirmSave       AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE giTabsPerRow        AS INTEGER    NO-UNDO INITIAL 7.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-checkChildWindows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD checkChildWindows Procedure 
FUNCTION checkChildWindows RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableEnabledActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD disableEnabledActions Procedure 
FUNCTION disableEnabledActions RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD displayAttribute Procedure 
FUNCTION displayAttribute RETURNS LOGICAL
  (pdObjectInstanceObj AS DECIMAL,
   pcAttributeLabel    AS CHARACTER,
   phWidget            AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-evaluateActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD evaluateActions Procedure 
FUNCTION evaluateActions RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAttributeValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAttributeValue Procedure 
FUNCTION getAttributeValue RETURNS CHARACTER
  (pdObjectInstanceObj AS DECIMAL,
   pcAttributeLabel    AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentPrefs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentPrefs Procedure 
FUNCTION getCurrentPrefs RETURNS CHARACTER
  (plCurrentValues  AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectInstanceObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectInstanceObj Procedure 
FUNCTION getObjectInstanceObj RETURNS DECIMAL
  (pcInstanceName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPageSequence) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPageSequence Procedure 
FUNCTION getPageSequence RETURNS INTEGER
  (piPageNumber AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getStatusDefault) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getStatusDefault Procedure 
FUNCTION getStatusDefault RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUniqueInstanceName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUniqueInstanceName Procedure 
FUNCTION getUniqueInstanceName RETURNS CHARACTER
  (pcInstanceName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasFolder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hasFolder Procedure 
FUNCTION hasFolder RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hideSubtools) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hideSubtools Procedure 
FUNCTION hideSubtools RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-lockWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD lockWindow Procedure 
FUNCTION lockWindow RETURNS LOGICAL
  (plLockWindow AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mySetPageNTargets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD mySetPageNTargets Procedure 
FUNCTION mySetPageNTargets RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-restoreToolbarContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD restoreToolbarContext Procedure 
FUNCTION restoreToolbarContext RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectFilename) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setObjectFilename Procedure 
FUNCTION setObjectFilename RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setStatusDefault) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setStatusDefault Procedure 
FUNCTION setStatusDefault RETURNS LOGICAL
  (pcStatusDefault AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-transferActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD transferActive Procedure 
FUNCTION transferActive RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewStaticPropsheet) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD viewStaticPropsheet Procedure 
FUNCTION viewStaticPropsheet RETURNS LOGICAL
  (pcObjectTypeCode AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 20.91
         WIDTH              = 49.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord Procedure 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     This is not run anymore... Find Record will be used instead because
               of program folw reasons.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContainerMode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lContinue       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lChanges        AS LOGICAL    NO-UNDO.

  cContainerMode = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U).

  IF cContainerMode = "INITIAL":U OR
     cContainerMode = "MODIFY":U  OR
     cContainerMode = "FIND":U    OR
     cContainerMode = ?           THEN
  DO:
    RUN checkIfSaved IN TARGET-PROCEDURE (INPUT  TRUE,
                                           INPUT  FALSE,
                                           OUTPUT lChanges,
                                           OUTPUT lContinue) NO-ERROR.

    IF ERROR-STATUS:ERROR OR
       NOT lContinue      THEN
      RETURN.

    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultCode":U, "":U).
    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U, "0":U).
    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U, "ADD":U).
    DYNAMIC-FUNCTION("evaluateActions":U IN TARGET-PROCEDURE).
    DYNAMIC-FUNCTION("clearLinkObject":U IN ghGridObjectViewer, "SOURCE":U, ?).
    DYNAMIC-FUNCTION("clearLinkObject":U IN ghGridObjectViewer, "TARGET":U, ?).
    DYNAMIC-FUNCTION("evaluateActions":U IN ghGridObjectViewer).

    PUBLISH "fetchContainerData":U  FROM TARGET-PROCEDURE (INPUT "":U).
    /*RUN displayContainerDetails IN TARGET-PROCEDURE (INPUT 1).*/

    PUBLISH "enableViewerObjects":U FROM TARGET-PROCEDURE (INPUT TRUE).
    PUBLISH "enableSearchLookups":U FROM TARGET-PROCEDURE (INPUT TRUE).

    PUBLISH "clearFilters":U FROM TARGET-PROCEDURE.

    RUN trgMenuChoose IN ghGridObjectViewer (INPUT ?, "ClearCut":U).
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addSmartLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addSmartLink Procedure 
PROCEDURE addSmartLink :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdSourceObjectInstanceObj AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdTargetObjectInstanceObj AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdSmartLinkTypeObj        AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcLinkName                AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plEvaluateOnly            AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER plSuccess                 AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcReason                  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.

  DEFINE BUFFER ttSmartObject FOR ttSmartObject.
  DEFINE BUFFER ttSmartLink   FOR ttSmartLink.

  IF {fnarg getUserProperty 'DataContainer'} = "yes":U AND pcLinkName <> "Data":U THEN
  DO:
    ASSIGN
        plSuccess = FALSE
        pcReason  = "Instances on a Dynamic SBO can only be linked with a 'Data' link.":U.

    RETURN.
  END.

  dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U)).

  FIND FIRST ttSmartObject
       WHERE ttSmartObject.d_smartobject_obj         <> 0.00
         AND ttSmartObject.d_customization_result_obj = dCustomizationResultObj.

  FIND FIRST ttSmartLink
       WHERE ttSmartLink.d_container_smartobject_obj  = ttSmartObject.d_smartobject_obj
         AND ttSmartLink.d_source_object_instance_obj = pdSourceObjectInstanceObj
         AND ttSmartLink.d_target_object_instance_obj = pdTargetObjectInstanceObj
         AND ttSmartLink.c_link_name                  = pcLinkName NO-ERROR.

  IF AVAILABLE ttSmartLink THEN
  DO:
    IF ttSmartLink.c_action = "D":U THEN
    DO:
      ASSIGN
          ttSmartLink.c_action = (IF ttSmartLink.d_smartlink_type_obj > 0.00 THEN "M":U ELSE "A":U)
          plSuccess            = TRUE.
    
      RUN launchLinks IN TARGET-PROCEDURE (INPUT FALSE,
                                            INPUT 0.00).
    END.
    ELSE
      ASSIGN
          pcReason  = "The link already exists."
          plSuccess = FALSE.
  END.
  ELSE
  DO:
    IF plEvaluateOnly = FALSE THEN
    DO:
      CREATE ttSmartLink.
      ASSIGN
          ttSmartLink.d_source_object_instance_obj = pdSourceObjectInstanceObj
          ttSmartLink.d_target_object_instance_obj = pdTargetObjectInstanceObj
          ttSmartLink.d_container_smartobject_obj  = ttSmartObject.d_smartobject_obj
          ttSmartLink.d_customization_result_obj   = dCustomizationResultObj
          ttSmartLink.d_smartlink_type_obj         = pdSmartLinkTypeObj
          ttSmartLink.d_smartlink_obj              = DYNAMIC-FUNCTION("getTemporaryObj":U IN TARGET-PROCEDURE)
          ttSmartLink.c_link_name                  = pcLinkName
          ttSmartLink.c_action                     = "A":U
          plSuccess                                = TRUE.

      IF VALID-HANDLE(ghLinkMaintenance) THEN
        {fnarg setUserProperty "'DisplayNow':U, 'No':U" ghLinkMaintenance}.

      /* Send the TEMP-TABLE to the links maintenance program */
      RUN launchLinks IN TARGET-PROCEDURE (INPUT FALSE,                         /* plLaunchMaintenance */
                                           INPUT ttSmartLink.d_smartlink_obj).  /* pdSmartLinkObj      */

      IF DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U) <> "UPDATE":U AND
         DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U) <> "ADD":U    THEN
      DO:
        DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U, "UPDATE":U).
        DYNAMIC-FUNCTION("evaluateActions":U IN TARGET-PROCEDURE).
      END.

      IF VALID-HANDLE(ghLinkMaintenance) THEN
        {fnarg setUserProperty "'DisplayNow':U, 'Yes':U" ghLinkMaintenance}.
    END.
  END.
  
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-autoLinkInstance) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE autoLinkInstance Procedure 
PROCEDURE autoLinkInstance :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdObjectInstanceObj  AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE cFailureReason      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dSourceInstanceObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dTargetInstanceObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lExist              AS LOGICAL    NO-UNDO.

  DEFINE BUFFER ttObjectInstance  FOR ttObjectInstance.
  DEFINE BUFFER ttSmartLinkType   FOR ttSmartLinkType.
  DEFINE BUFFER ttObjectType      FOR ttObjectType.

  FOR FIRST ttObjectInstance
      WHERE ttObjectInstance.d_object_instance_obj = pdObjectInstanceObj,
      FIRST ttObjectType
      WHERE ttObjectType.d_object_type_obj = ttObjectInstance.d_object_type_obj:

    IF LOOKUP(ttObjectType.c_object_type_code, gcFolderClasses) <> 0
    THEN DO:
        dSourceInstanceObj = DYNAMIC-FUNCTION("getObjectInstanceObj":U IN TARGET-PROCEDURE, ttObjectInstance.c_instance_name).

        FIND FIRST ttSmartLinkType WHERE ttSmartLinkType.c_link_name = "Page":U.

        RUN addSmartLink IN TARGET-PROCEDURE (INPUT  dSourceInstanceObj,
                                               INPUT  0,
                                               INPUT  ttSmartLinkType.d_smartlink_type_obj,
                                               INPUT  "Page":U,
                                               INPUT  FALSE,
                                               OUTPUT lExist,
                                               OUTPUT cFailureReason).
    END.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRecord Procedure 
PROCEDURE cancelRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContainerMode  AS CHARACTER  NO-UNDO.
  
  cContainerMode = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U).
  
  IF cContainerMode = "ADD":U THEN
  DO:
    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U, "0":U).

    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U, "FIND":U).
    DYNAMIC-FUNCTION("evaluateActions":U IN TARGET-PROCEDURE).
    DYNAMIC-FUNCTION("evaluateActions":U IN ghGridObjectViewer).

    DYNAMIC-FUNCTION("clearLinkObject":U IN ghGridObjectViewer, "SOURCE":U, ?).
    DYNAMIC-FUNCTION("clearLinkObject":U IN ghGridObjectViewer, "TARGET":U, ?).
    DYNAMIC-FUNCTION("evaluateActions":U IN ghGridObjectViewer).
    
    RUN "fetchContainerData":U IN TARGET-PROCEDURE (INPUT "":U).

    PUBLISH "enableViewerObjects":U FROM TARGET-PROCEDURE (INPUT FALSE).
    PUBLISH "enableSearchLookups":U FROM TARGET-PROCEDURE (INPUT TRUE).
  END.

  ghContainerHandle:TITLE = gcTitle + " Open":U.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-changeFolderPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeFolderPage Procedure 
PROCEDURE changeFolderPage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF glToolbarDisabled = TRUE THEN
    RETURN.
  
  IF DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "selectPage":U) <> "No":U THEN
  DO:
    DYNAMIC-FUNCTION("mySetPageNTargets":U IN TARGET-PROCEDURE). /* This will avoid a redraw of the object grid */
  
    {fnarg lockWindow TRUE TARGET-PROCEDURE}.

    RUN setupPageObjects IN ghGridObjectViewer (INPUT 0.00).
  
    {fnarg lockWindow FALSE TARGET-PROCEDURE}.  
  
    PUBLISH "refreshData":U FROM TARGET-PROCEDURE (INPUT "PageChange":U, INPUT 0.00).
  END.

  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkContainerDetails) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkContainerDetails Procedure 
PROCEDURE checkContainerDetails :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER plContinue  AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cPanelClasses           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldList              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lHasToolbar             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hLookup                 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hLookupFillIn           AS HANDLE     NO-UNDO.

  DEFINE BUFFER ttObjectInstance  FOR ttObjectInstance.
  DEFINE BUFFER ttSmartObject     FOR ttSmartObject.

  ASSIGN
      dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U))
      plContinue              = TRUE.

  FIND FIRST ttSmartObject
       WHERE ttSmartObject.d_smartobject_obj         <> 0.00
         AND ttSmartObject.d_customization_result_obj = dCustomizationResultObj.

  IF ttSmartObject.c_object_filename = "":U THEN
  DO:
    ASSIGN
        plContinue = FALSE
        cMessage   = {aferrortxt.i 'AF' '1' '?' '?' "'Container Name':U" "'Please specify the Container Name in order to save the object.'"}.

    RUN showMessages IN gshSessionManager (INPUT  cMessage,                     /* message to display */
                                           INPUT  "ERR":U,                      /* error type         */
                                           INPUT  "&OK":U,                      /* button list        */
                                           INPUT  "&OK":U,                      /* default button     */ 
                                           INPUT  "&OK":U,                      /* cancel button      */
                                           INPUT  "Container Name is invalid",  /* error window title */
                                           INPUT  YES,                          /* display if empty   */ 
                                           INPUT  TARGET-PROCEDURE,             /* container handle   */ 
                                           OUTPUT cButton).                     /* button pressed     */
    RETURN ERROR.
  END.
  
  IF ttSmartObject.d_product_module_obj = 0.00 OR
     ttSmartObject.d_product_module_obj = ?    THEN
  DO:
    ASSIGN
        plContinue = FALSE
        cMessage   = {aferrortxt.i 'AF' '1' '?' '?' "'Product Module'"}.
    
    RUN showMessages IN gshSessionManager (INPUT  cMessage,                       /* message to display */
                                           INPUT  "ERR":U,                        /* error type         */
                                           INPUT  "&OK":U,                        /* button list        */
                                           INPUT  "&OK":U,                        /* default button     */ 
                                           INPUT  "&Cancel":U,                    /* cancel button      */
                                           INPUT  "Product Module is invalid",   /* error window title */
                                           INPUT  YES,                            /* display if empty   */ 
                                           INPUT  TARGET-PROCEDURE,              /* container handle   */ 
                                           OUTPUT cButton).                       /* button pressed     */
    RETURN ERROR.
  END.

  IF dCustomizationResultObj = 0.00 THEN
  DO:
    cQuery = "FOR EACH ryc_smartobject NO-LOCK":U
           + "   WHERE ryc_smartobject.object_filename          = ":U + QUOTER(ttSmartObject.c_object_filename)
           + "     AND ryc_smartobject.customization_result_obj = 0":U
           + "     AND ryc_smartobject.smartobject_obj         <> ":U + QUOTER(ttSmartObject.d_smartobject_obj).
  
    RUN getRecordDetail IN gshGenManager (INPUT  cQuery,
                                          OUTPUT cFieldList).
    
    IF cFieldList <> "":U THEN
    DO:
      ASSIGN
          plContinue = FALSE
          cMessage   = "'":U + ttSmartObject.c_object_filename + "'":U
          cMessage   = {aferrortxt.i 'AF' '8' '?' '?' "'an object filename of'" cMessage}.
      
      RUN showMessages IN gshSessionManager (INPUT  cMessage,                       /* message to display */
                                             INPUT  "ERR":U,                        /* error type         */
                                             INPUT  "&OK":U,                        /* button list        */
                                             INPUT  "&OK":U,                        /* default button     */ 
                                             INPUT  "&Cancel":U,                    /* cancel button      */
                                             INPUT  "Object Filename is invalid",   /* error window title */
                                             INPUT  YES,                            /* display if empty   */ 
                                             INPUT  TARGET-PROCEDURE,              /* container handle   */ 
                                             OUTPUT cButton).                       /* button pressed     */

      RETURN ERROR.
    END.
  END.

  /* Check the custom super procedure */
  ASSIGN
      hLookup       = {fnarg getSDFHandle    'hCustomSuperProcedure':U ghContainerViewer}
      hLookupFillIn = {fn    getLookupHandle hLookup}.

  IF hLookupFillIn:SCREEN-VALUE                   <> "":U AND
     hLookupFillIn:SCREEN-VALUE                   <> ?    AND
     {fnarg getUserProperty 'DataValue':U hLookup} = "":U THEN
  DO:
    ASSIGN
        plContinue = FALSE
        cMessage   = {aferrortxt.i 'AF' '1' '?' '?' "'Super Procedure'"}.

    RUN showMessages IN gshSessionManager (INPUT  cMessage,                     /* message to display */
                                           INPUT  "ERR":U,                      /* error type         */
                                           INPUT  "&OK":U,                      /* button list        */
                                           INPUT  "&OK":U,                      /* default button     */ 
                                           INPUT  "&OK":U,                      /* cancel button      */
                                           INPUT  "Super Procedure is invalid", /* error window title */
                                           INPUT  YES,                          /* display if empty   */ 
                                           INPUT  TARGET-PROCEDURE,             /* container handle   */ 
                                           OUTPUT cButton).                     /* button pressed     */
    RETURN ERROR.
  END.

  /* Check the data logic procedure */
  ASSIGN
      hLookup       = {fnarg getSDFHandle    'hDLProcedure':U ghContainerViewer}
      hLookupFillIn = {fn    getLookupHandle hLookup}.

  IF hLookupFillIn:SCREEN-VALUE                   <> "":U AND
     hLookupFillIn:SCREEN-VALUE                   <> ?    AND
     {fnarg getUserProperty 'DataValue':U hLookup} = "":U THEN
  DO:
    ASSIGN
        plContinue = FALSE
        cMessage   = {aferrortxt.i 'AF' '1' '?' '?' "'DataLogic Procedure'"}.

    RUN showMessages IN gshSessionManager (INPUT  cMessage,                         /* message to display */
                                           INPUT  "ERR":U,                          /* error type         */
                                           INPUT  "&OK":U,                          /* button list        */
                                           INPUT  "&OK":U,                          /* default button     */ 
                                           INPUT  "&OK":U,                          /* cancel button      */
                                           INPUT  "DataLogic Procedure is invalid", /* error window title */
                                           INPUT  YES,                              /* display if empty   */ 
                                           INPUT  TARGET-PROCEDURE,                 /* container handle   */ 
                                           OUTPUT cButton).                         /* button pressed     */
    RETURN ERROR.
  END.

  IF NOT {fn getRecordComplete ghGridObjectViewer} THEN
  DO:
    ASSIGN
        plContinue = FALSE
        cMessage   = "The details for the object instance you are adding/updating is incomplete."
                   + CHR(10) + CHR(10)
                   + "Please ensure that you have specified a valid object, its instance name and grid location.".
        cMessage   = {aferrortxt.i 'AF' '40' '?' '?' cMessage}.

    RUN showMessages IN gshSessionManager (INPUT  cMessage,                       /* message to display */
                                           INPUT  "ERR":U,                        /* error type         */
                                           INPUT  "&OK":U,                        /* button list        */
                                           INPUT  "&OK":U,                        /* default button     */ 
                                           INPUT  "&OK":U,                        /* cancel button      */
                                           INPUT  "Instance details incomplete",  /* error window title */
                                           INPUT  YES,                            /* display if empty   */ 
                                           INPUT  TARGET-PROCEDURE,               /* container handle   */ 
                                           OUTPUT cButton).                       /* button pressed     */
    RETURN ERROR.
  END.

  IF CAN-FIND(FIRST ttObjectMenuStructure
              WHERE ttObjectMenuStructure.c_action <> "D":U) THEN
  DO:
    cPanelClasses = {fnarg getClassChildrenFromDB 'Toolbar':U gshRepositoryManager}.
    
    find_Toolbar:
    FOR EACH ttObjectType
       WHERE LOOKUP(ttObjectType.c_object_type_code, cPanelClasses) <> 0,
       FIRST ttObjectInstance
       WHERE ttObjectInstance.d_object_type_obj = ttObjectType.d_object_type_obj
         AND ttObjectInstance.c_action         <> "D":U:

      lHasToolbar = TRUE.

      LEAVE find_Toolbar.
    END.
    
    IF NOT lHasToolbar THEN
    DO:
      cMessage = {aferrortxt.i 'AF' '134' '?' '?'}.

      RUN showMessages IN gshSessionManager (INPUT  cMessage,                           /* message to display */
                                             INPUT  "WAR":U,                            /* error type         */
                                             INPUT  "&OK":U,                            /* button list        */
                                             INPUT  "&OK":U,                            /* default button     */ 
                                             INPUT  "&OK":U,                            /* cancel button      */
                                             INPUT  "Menu structures will not render",  /* error window title */
                                             INPUT  YES,                                /* display if empty   */ 
                                             INPUT  TARGET-PROCEDURE,                   /* container handle   */ 
                                             OUTPUT cButton).                           /* button pressed     */
    END.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkFolderExistance) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkFolderExistance Procedure 
PROCEDURE checkFolderExistance :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER piNumPages AS INTEGER    NO-UNDO.
  DEFINE       PARAMETER BUFFER ttObjectInstance FOR ttObjectInstance.
  
  DEFINE VARIABLE cObjectDescription      AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cObjectFilename         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPreferences            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldList              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTitle                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dSmartObjectObj         AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lExist                  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iRow                    AS INTEGER    NO-UNDO.

  DEFINE BUFFER ttSmartLinkType FOR ttSmartLinkType.
  DEFINE BUFFER ttSmartObject   FOR ttSmartObject.
  DEFINE BUFFER ttPage          FOR ttPage.
  
  ASSIGN
      dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U))
      lExist                  = FALSE.
  
  fe-blk:
  FOR EACH ttObjectType
     WHERE LOOKUP(ttObjectType.c_object_type_code, gcFolderClasses) <> 0,
     FIRST ttObjectInstance
     WHERE ttObjectInstance.d_object_type_obj = ttObjectType.d_object_type_obj
       AND ttObjectInstance.c_action         <> "D":U:

    lExist = TRUE.
    LEAVE fe-blk.
  END.
  
  IF lExist = FALSE THEN
  DO:
    DO iRow = 1 TO 9:
      lExist = CAN-FIND(FIRST ttObjectInstance
                        WHERE ttObjectInstance.d_customization_result_obj = dCustomizationResultObj
                          AND ttObjectInstance.i_page                     = 0
                          AND ttObjectInstance.i_column                   = 1
                          AND ttObjectInstance.i_row                      = iRow
                          AND ttObjectInstance.c_action                  <> "D":U
                          AND ttObjectInstance.l_visible_object           = TRUE).
      
      IF lExist = FALSE THEN
        LEAVE.
    END.
    
    IF lExist = FALSE THEN
    DO:
      FOR FIRST ttSmartObject
          WHERE ttSmartObject.d_smartobject_obj         <> 0.00
            AND ttSmartObject.d_customization_result_obj = dCustomizationResultObj,
           EACH ttObjectType
          WHERE LOOKUP(ttObjectType.c_object_type_code, gcFolderClasses) <> 0,
          FIRST ttSmartLinkType
          WHERE ttSmartLinkType.c_link_name = "Page":U:

        cQuery = "FOR EACH ryc_smartobject NO-LOCK":U
               + "   WHERE ryc_smartobject.object_type_obj = ":U + QUOTER(ttObjectType.d_object_type_obj)
               + "     AND ryc_smartobject.object_filename = 'afspfoldrw.w'":U.

        RUN getRecordDetail IN gshGenManager (INPUT  cQuery,
                                              OUTPUT cFieldList).

        IF cFieldList <> "":U THEN
        DO:
          ASSIGN
              dSmartObjectObj    = DECIMAL(ENTRY(LOOKUP("ryc_smartobject.smartobject_obj":U,    cFieldList, CHR(3)) + 1, cFieldList, CHR(3)))
              cObjectDescription =         ENTRY(LOOKUP("ryc_smartobject.object_description":U, cFieldList, CHR(3)) + 1, cFieldList, CHR(3))
              cObjectFilename    =         ENTRY(LOOKUP("ryc_smartobject.object_filename":U,    cFieldList, CHR(3)) + 1, cFieldList, CHR(3)).

          CREATE ttObjectInstance.
          ASSIGN ttObjectInstance.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj
                 ttObjectInstance.d_object_instance_obj       = DYNAMIC-FUNCTION("getTemporaryObj":U IN TARGET-PROCEDURE)
                 ttObjectInstance.d_customization_result_obj  = dCustomizationResultObj
                 ttObjectInstance.c_action                    = "A":U
                 ttObjectInstance.c_smartobject_filename      = cObjectFilename
                 ttObjectInstance.d_smartobject_obj           = dSmartObjectObj
                 ttObjectInstance.d_object_type_obj           = ttObjectType.d_object_type_obj
                 ttObjectInstance.c_instance_description      = cObjectDescription
                 ttObjectInstance.c_instance_name             = REPLACE(cObjectFilename, ".":U, "":U)
                 ttObjectInstance.l_system_owned              = FALSE
                 ttObjectInstance.c_layout_position           = "M":U + STRING(iRow) + "1":U
                 ttObjectInstance.i_column                    = 1
                 ttObjectInstance.i_page                      = 0
                 ttObjectInstance.i_row                       = iRow
                 ttObjectInstance.c_lcr                       = "L":U
                 ttObjectInstance.l_resize_horizontal         = TRUE
                 ttObjectInstance.l_resize_vertical           = TRUE
                 ttObjectInstance.l_visible_object            = TRUE.

          ASSIGN
              cMessage = "Because there is more than 1 page on the container, a SmartFolder was added automatically on page 0, row " + STRING(iRow) + "."
              cMessage = {aferrortxt.i 'AF' '39' '?' '?' 'SmartFolder' cMessage}
              cTitle   = "SmartFolder does not exist".

          RUN addSmartLink IN TARGET-PROCEDURE (INPUT  ttObjectInstance.d_object_instance_obj,
                                                 INPUT  0,
                                                 INPUT  ttSmartLinkType.d_smartlink_type_obj,
                                                 INPUT  "Page":U,
                                                 INPUT  FALSE,
                                                 OUTPUT lExist,
                                                 OUTPUT cButton).

          RUN registerPSObjects IN TARGET-PROCEDURE  (INPUT STRING(ttObjectInstance.d_object_instance_obj)).
          RUN setupPageObjects  IN ghGridObjectViewer (INPUT ttObjectInstance.d_object_instance_obj).
        END.

        RUN showMessages IN gshSessionManager (INPUT  cMessage,         /* message to display */
                                               INPUT  "INF",            /* error type         */
                                               INPUT  "&OK",            /* button list        */
                                               INPUT  "&OK",            /* default button     */ 
                                               INPUT  "&OK",            /* cancel button      */
                                               INPUT  cTitle,           /* error window title */
                                               INPUT  YES,              /* display if empty   */
                                               INPUT  TARGET-PROCEDURE, /* container handle   */
                                               OUTPUT cButton).
      END.
    END.
  END.
  ELSE
  IF glDeleteFolder = TRUE AND
     piNumPages     = 1    THEN
  DO:
    IF dCustomizationResultObj = 0.00 THEN
    DO:
      FIND FIRST ttSmartObject NO-LOCK
           WHERE ttSmartObject.d_smartobject_obj <> 0.00.

      cQuery = "FOR EACH ryc_smartobject NO-LOCK":U
             + "   WHERE ryc_smartobject.object_filename           = ":U + QUOTER(ttSmartObject.c_object_filename)
             + "     AND ryc_smartobject.customization_result_obj <> 0,":U
             + "   FIRST ryc_page NO-LOCK":U
             + "   WHERE ryc_page.container_smartobject_obj = ryc_smartobject.smartobject_obj":U.

      RUN getRecordDetail IN gshGenManager (INPUT  cQuery,
                                            OUTPUT cFieldList).

      /* IF we found data, then we cannot delete the folder as we have customized pages */
      IF cFieldList <> "":U THEN
        RETURN.
    END.

    cPreferences = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "ProfileData":U).

    IF ENTRY(LOOKUP("ConfirmDeletion":U, cPreferences, "|":U) + 1, cPreferences, "|":U) = "yes":U THEN
    DO:
      cMessage = "There are no more selectable pages left on the container.":U + CHR(10) + CHR(10)
               + "Do you want to delete the 'SmartFolder' object instance?":U.

      RUN askQuestion IN gshSessionManager ( INPUT cMessage,                    /* messages       */
                                             INPUT "&Yes,&No":U,                /* button list    */
                                             INPUT "&No":U,                     /* default        */
                                             INPUT "&No":U,                     /* cancel         */
                                             INPUT "Delete object instance":U,  /* title          */
                                             INPUT "":U,                        /* datatype       */
                                             INPUT "":U,                        /* format         */
                                             INPUT-OUTPUT cButton,              /* answer         */
                                             OUTPUT cButton).                   /* button pressed */
      
      IF cButton = "&No":U THEN
        RETURN.
    END.

    /* Find the object instance and flag it as deleted */
    FOR EACH ttObjectType
       WHERE LOOKUP(ttObjectType.c_object_type_code, gcFolderClasses) <> 0,
       FIRST ttObjectInstance
       WHERE ttObjectInstance.d_object_type_obj = ttObjectType.d_object_type_obj
         AND ttObjectInstance.c_action         <> "D":U:

      ttObjectInstance.c_action = "D":U.

      RUN unregisterPSObjects IN TARGET-PROCEDURE   (INPUT STRING(ttObjectInstance.d_object_instance_obj)).
      RUN setupPageObjects    IN ghGridObjectViewer (INPUT 0.00).
    END.
  END.
  
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkIfSaved) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkIfSaved Procedure 
PROCEDURE checkIfSaved :
/*------------------------------------------------------------------------------
  Purpose:  Checks to see if any details about the container changed, prompts
            the user if he wants to save those changes and then proceeds to
            save the changes in the relevant programs if so desired.

  Parameters:  OUTPUT plContinue - Flag to indicate if the process that called
                                   checkIfSaved should continue.

  Notes:  checkIfSaved is called when the container is to be closed and we want
          to ensure that the user doesn't lose any unsaved changes. Likewise,
          it is also called when the user wants to find or add a new container.
          If any errors occured, subsequent process (like the closing of the
          container) is not continued.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER plPrompt    AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plAutoSave  AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER plChanges   AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER plContinue  AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cGridContainerMode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMainContainerMode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lContainerChanges   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lGridChanges        AS LOGICAL    NO-UNDO.

  /* Get the container modes in all the related programs */
  {fn checkInstanceName ghGridObjectViewer}.

  ASSIGN
      ERROR-STATUS:ERROR = FALSE
      cGridContainerMode = DYNAMIC-FUNCTION("getUserProperty":U IN ghGridObjectViewer, "ContainerMode":U)
      cMainContainerMode = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE,  "ContainerMode":U)
      plContinue         = FALSE.

  /* Check for changes in all the related programs */
  IF cMainContainerMode = "UPDATE":U OR cMainContainerMode = "ADD":U THEN lContainerChanges = TRUE. /* Container        */
  IF cGridContainerMode = "UPDATE":U OR cGridContainerMode = "ADD":U THEN lGridChanges      = TRUE. /* Object instances */

  /* If we have any changes in any part of the container, prepare the relevant message and present the user with the prompt to save */
  IF lContainerChanges = TRUE OR
     lGridChanges      = TRUE THEN
  DO:
    plChanges = TRUE.

    IF plPrompt   = FALSE AND
       plAutoSave = FALSE THEN
      RETURN.
    
    cMessage = {aferrortxt.i 'AF' '131' '?' '?' "'the container'"}.

    IF plPrompt = TRUE THEN
      RUN showMessages IN gshSessionManager (INPUT  cMessage,                       /* message to display */
                                             INPUT  "INF":U,                        /* error type         */
                                             INPUT  "&Yes,&No,&Cancel":U,           /* button list        */
                                             INPUT  "&Cancel":U,                    /* default button     */ 
                                             INPUT  "&Cancel":U,                    /* cancel button      */
                                             INPUT  "Save changes before closing",  /* error window title */
                                             INPUT  YES,                            /* display if empty   */ 
                                             INPUT  TARGET-PROCEDURE,              /* container handle   */ 
                                             OUTPUT cButton).                       /* button pressed     */

    /* If the user chose 'Cancel', return - plContinue will have the default value of FALSE */
    IF cButton = "&Cancel":U THEN
      RETURN.

    /* If the user decided to save his changes, proceed to save in all maintenance programs. They will then return their
       updated temp tables which will be used when we save the details for the container using saveContainer */
    IF cButton    = "&Yes":U OR
       plAutoSave = TRUE     THEN
    DO:

      /* Save the changes in the object instances if any */
      IF lGridChanges THEN
        RUN newSave IN ghGridObjectViewer NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR "ERROR":U.

      /* Finally, save the changes in the container */
      RUN saveContainer IN TARGET-PROCEDURE (INPUT FALSE,
                                             INPUT FALSE) NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR "ERROR":U.

      plContinue = TRUE. /* If we reached this point, changes were saved successfully and any process that called checkIfSaved can contiue */
    END.
    ELSE
      plContinue = TRUE. /* At this point, the user selected 'No' */
  END.
  ELSE
    plContinue = TRUE. /* At this point, no change in the container were found */

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyInstanceAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyInstanceAttributes Procedure 
PROCEDURE copyInstanceAttributes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdSourceObjectInstanceObj  AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdTargetObjectInstanceObj  AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.

  DEFINE BUFFER ttSourceAttributeValue  FOR ttAttributeValue.
  DEFINE BUFFER ttTargetAttributeValue  FOR ttAttributeValue.

  dCustomizationResultObj = DECIMAL({fnarg getUserProperty 'CustomizationResultObj':U}).

  /* Just ensure that we do not overwrite attributes for an object instance with existing attributes */
  IF CAN-FIND(FIRST ttTargetAttributeValue
              WHERE ttTargetAttributeValue.d_object_instance_obj      = pdTargetObjectInstanceObj
                AND ttTargetAttributeValue.d_customization_result_obj = dCustomizationResultObj) THEN
    RETURN.

  /* Find the attributes for instance of the current customization */
  FOR EACH ttSourceAttributeValue
     WHERE ttSourceAttributeValue.d_object_instance_obj        = pdSourceObjectInstanceObj
       AND ttSourceAttributeValue.d_customization_result_obj   = dCustomizationResultObj
       AND ttSourceAttributeValue.d_container_smartobject_obj <> 0.00
       AND ttSourceAttributeValue.c_action                    <> "D":U:

    CREATE ttTargetAttributeValue.

    BUFFER-COPY ttSourceAttributeValue
         EXCEPT ttSourceAttributeValue.d_object_instance_obj
                ttSourceAttributeValue.d_attribute_value_obj
                ttSourceAttributeValue.c_action
             TO ttTargetAttributeValue
         ASSIGN ttTargetAttributeValue.d_object_instance_obj = pdTargetObjectInstanceObj
                ttTargetAttributeValue.d_attribute_value_obj = {fn getTemporaryObj}
                ttTargetAttributeValue.c_action              = "A":U.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyPageInstances) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyPageInstances Procedure 
PROCEDURE copyPageInstances :
/*------------------------------------------------------------------------------
  Purpose:  To copy all the object instances on a page to the specified page. This
            must copy all detail about the object instances, including attributes,
            ui events, etc.

  Parameters:  INPUT piPageToCopy - The page the object instances reside on that should be copied
               INPUT piCopyToPage - The page the object instances should be copied to

  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER piPageToCopy AS INTEGER    NO-UNDO.
  DEFINE INPUT PARAMETER piCopyToPage AS INTEGER    NO-UNDO.

  DEFINE VARIABLE cCustomizationResultCode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContainerMode            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iSequence                 AS INTEGER    NO-UNDO INITIAL 1.  

  DEFINE BUFFER bttObjectInstance FOR ttObjectInstance.
  DEFINE BUFFER ttObjectInstance  FOR ttObjectInstance.
  DEFINE BUFFER bttAttributeValue FOR ttAttributeValue.
  DEFINE BUFFER ttAttributeValue  FOR ttAttributeValue.
  DEFINE BUFFER ttSmartObject     FOR ttSmartObject.
  DEFINE BUFFER bttSmartLink      FOR ttSmartLink.
  DEFINE BUFFER ttSmartLink       FOR ttSmartLink.
  DEFINE BUFFER bttUiEvent        FOR ttUiEvent.
  DEFINE BUFFER ttUiEvent         FOR ttUiEvent.
  DEFINE BUFFER ttPage            FOR ttPage.

  ASSIGN
      dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U))
      cContainerMode          = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U).

  FIND FIRST ttSmartObject
       WHERE ttSmartObject.d_smartobject_obj         <> 0.00
         AND ttSmartObject.d_customization_result_obj = dCustomizationResultObj.

  /* First try to find the page on the master container, if it exists, then use that page */
  FIND FIRST ttPage
       WHERE ttPage.i_page_sequence            = piCopyToPage
         AND ttPage.d_customization_result_obj = 0.00 NO-ERROR.

  /* If the page did not exist in the above find, then it must exist as the customization */
  IF NOT AVAILABLE ttPage THEN
    FIND FIRST ttPage
         WHERE ttPage.i_page_sequence            = piCopyToPage
           AND ttPage.d_customization_result_obj = dCustomizationResultObj.

  /* --------- ObjectInstance --------- */
  FOR EACH bttObjectInstance
     WHERE bttObjectInstance.d_smartobject_obj <> 0.00
       AND bttObjectInstance.i_page             = piPageToCopy:

    CREATE ttObjectInstance.

    BUFFER-COPY bttObjectInstance
             TO ttObjectInstance
         ASSIGN ttObjectInstance.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj
                ttObjectInstance.d_customization_result_obj  = dCustomizationResultObj
                ttObjectInstance.d_object_instance_obj       = DYNAMIC-FUNCTION("getTemporaryObj":U IN TARGET-PROCEDURE)
                ttObjectInstance.c_instance_name             = DYNAMIC-FUNCTION("getUniqueInstanceName":U IN TARGET-PROCEDURE, bttObjectInstance.c_instance_name)
                ttObjectInstance.i_object_sequence           = iSequence
                ttObjectInstance.c_action                    = "A":U
                ttObjectInstance.i_page                      = piCopyToPage
                iSequence                                    = iSequence + 1.

    /* --------- SmartLink --------- */
    FOR EACH bttSmartLink
       WHERE bttSmartLink.d_source_object_instance_obj = bttObjectInstance.d_object_instance_obj
          OR bttSmartLink.d_target_object_instance_obj = bttObjectInstance.d_object_instance_obj:

      CREATE ttSmartLink.

      BUFFER-COPY bttSmartLink
               TO ttSmartLink.
           ASSIGN ttSmartLink.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj
                  ttSmartLink.d_customization_result_obj  = dCustomizationResultObj
                  ttSmartLink.d_smartlink_obj             = DYNAMIC-FUNCTION("getTemporaryObj":U IN TARGET-PROCEDURE)
                  ttSmartLink.c_action                    = "A":U.

      /* Make sure the SmartLinks point to the newly created object instances */
      IF ttSmartLink.d_source_object_instance_obj = bttObjectInstance.d_object_instance_obj THEN
        ttSmartLink.d_source_object_instance_obj = ttObjectInstance.d_object_instance_obj.

      IF ttSmartLink.d_target_object_instance_obj = bttObjectInstance.d_object_instance_obj THEN
        ttSmartLink.d_target_object_instance_obj = ttObjectInstance.d_object_instance_obj.
    END.

    /* --------- AttributeValue --------- */
    FOR EACH bttAttributeValue
       WHERE bttAttributeValue.d_primary_smartobject_obj = bttObjectInstance.d_container_smartobject_obj
         AND bttAttributeValue.d_object_instance_obj     = bttObjectInstance.d_object_instance_obj:

      CREATE ttAttributeValue.
      
      BUFFER-COPY bttAttributeValue
               TO ttAttributeValue
           ASSIGN ttAttributeValue.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj
                  ttAttributeValue.d_primary_smartobject_obj   = ttSmartObject.d_smartobject_obj
                  ttAttributeValue.d_customization_result_obj  = dCustomizationResultObj
                  ttAttributeValue.d_attribute_value_obj       = DYNAMIC-FUNCTION("getTemporaryObj":U IN TARGET-PROCEDURE)
                  ttAttributeValue.d_object_instance_obj       = ttObjectInstance.d_object_instance_obj
                  ttAttributeValue.c_action                    = "A":U.
    END.

    RUN registerPSObjects IN TARGET-PROCEDURE (INPUT STRING(ttObjectInstance.d_object_instance_obj)).
  END.

  IF cContainerMode <> "ADD":U THEN
    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U, "UPDATE":U).

  DYNAMIC-FUNCTION("evaluateActions":U IN TARGET-PROCEDURE).

  /* If the links browser is open, refresh its temp-table, else our new records would get lost */
  RUN launchLinks IN TARGET-PROCEDURE (INPUT FALSE,
                                        INPUT 0.00).

  /* Refresh the contents of the PropertySheet */
  IF VALID-HANDLE(ghProcLib) THEN
  DO:
    cCustomizationResultCode = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultCode":U).

    RUN displayProperties IN ghProcLib (TARGET-PROCEDURE, ttSmartObject.d_smartobject_obj, "":U, cCustomizationResultCode, TRUE, 0).
  END.

  RUN displayContainerDetails IN TARGET-PROCEDURE (INPUT piCopyToPage + 1).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteContainer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteContainer Procedure 
PROCEDURE deleteContainer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFieldList              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lDelete                 AS LOGICAL    NO-UNDO.

  dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U)).

  IF dCustomizationResultObj = 0.00 THEN
  DO:
    FIND FIRST ttSmartObject
         WHERE ttSmartObject.d_smartobject_obj         <> 0.00
           AND ttSmartObject.d_customization_result_obj = dCustomizationResultObj.

    cQuery = "FOR EACH ryc_smartobject NO-LOCK":U
           + "   WHERE ryc_smartobject.object_filename = '":U + TRIM(ttSmartObject.c_object_filename) + "'":U
           + "     AND ryc_smartobject.customization_result_obj <> 0":U.

    RUN getRecordDetail IN gshGenManager (INPUT  cQuery,
                                          OUTPUT cFieldList).
  END.

  cMessage = "Answering 'Yes' to the following will delete the container and its entire contents. "
           + "Answering 'No' will leave the container in its current state."  + CHR(10) + CHR(10).

  IF dCustomizationResultObj = 0.00 AND
     TRIM(cFieldList)       <> "":U THEN
    cMessage = cMessage
             + "Customizations have been made against this container. If you delete the master container, all customizations will also be deleted.":U
             + CHR(10) + CHR(10).

  cMessage = cMessage
           + "WARNING: There will be no way to undo this operation!"          + CHR(10) + CHR(10)
           + "Do you wish to delete this container?".

  RUN showMessages IN gshSessionManager (INPUT  cMessage,             /* message to display */
                                         INPUT  "INF":U,              /* error type         */
                                         INPUT  "&Yes,&No":U,         /* button list        */
                                         INPUT  "&No":U,              /* default button     */ 
                                         INPUT  "&No":U,              /* cancel button      */
                                         INPUT  "Delete container",   /* error window title */
                                         INPUT  YES,                  /* display if empty   */ 
                                         INPUT  THIS-PROCEDURE,       /* container handle   */ 
                                         OUTPUT cButton).             /* button pressed     */

  IF cButton = "&Yes":U THEN
  DO:
    dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U)).    

    FIND FIRST ttSmartObject
         WHERE ttSmartObject.d_smartobject_obj         <> 0.00
           AND ttSmartObject.d_customization_result_obj = dCustomizationResultObj.

    ttSmartObject.c_action = "D":U.

    RUN saveContainer IN TARGET-PROCEDURE (INPUT TRUE,
                                            INPUT TRUE) NO-ERROR.

    IF ERROR-STATUS:ERROR = FALSE THEN
    DO:
      DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U, "FIND":U).
      DYNAMIC-FUNCTION("evaluateActions":U IN TARGET-PROCEDURE).
      DYNAMIC-FUNCTION("evaluateActions":U IN ghGridObjectViewer).

      PUBLISH "enableViewerObjects":U FROM TARGET-PROCEDURE (INPUT FALSE).
      PUBLISH "enableSearchLookups":U FROM TARGET-PROCEDURE (INPUT TRUE).
      
      PUBLISH "clearFilters":U FROM TARGET-PROCEDURE.
    END.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lChanges  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lClose    AS LOGICAL    NO-UNDO.

  ASSIGN
      ERROR-STATUS:ERROR = FALSE /* Clear the ERROR-STATUS. This is kept raised somewhere in the AppBuilder because of not being able to find an _HTM record */
      lClose             = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "closeWindow":U) = "yes":U.

  IF NOT VALID-HANDLE(ghGridObjectViewer) OR
     NOT VALID-HANDLE(ghContainerViewer)  OR
     NOT VALID-HANDLE(ghPageSource)       THEN
  DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    
    RETURN.
  END.

  IF (NOT glAppBuilder) OR (glAppBuilder AND glEditMaster) THEN
  DO:
    IF glDoPrompt = TRUE THEN
    DO:
      RUN checkIfSaved IN TARGET-PROCEDURE (INPUT  TRUE,
                                            INPUT  FALSE,
                                            OUTPUT lChanges,
                                            OUTPUT lClose) NO-ERROR.

      IF lClose = FALSE OR ERROR-STATUS:ERROR THEN
        RETURN ERROR "error".  /* stop destroyobject in the container from wacking the 
                                  admprops - cause we are just hiding, not destroying */
    END.

    /* Unregister all objects from the PropertySheet */
    RUN unregisterPSObjects IN TARGET-PROCEDURE (INPUT "":U).

    /* Close the links maintenance if it is open */
    IF VALID-HANDLE(ghLinkMaintenance) THEN
      RUN closeWindow IN ghLinkMaintenance NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR.

    /* Close the page maintenance if it is open */
    IF VALID-HANDLE(ghPageMaintenance) THEN
      RUN closeWindow IN ghPageMaintenance NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR.

    /* Close the menu structure maintenance if it is open */
    IF VALID-HANDLE(ghMenuStruct) THEN
      RUN closeWindow IN ghMenuStruct NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR.

    /* Close the page object sequence maintenance if it is open */
    IF VALID-HANDLE(ghSequencing) THEN
      RUN closeWindow IN ghSequencing NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR.

    /* Close the object locator if it is open */
    IF VALID-HANDLE(ghObjectLocator) THEN
      RUN closeWindow IN ghObjectLocator NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR.

    /* Close the preferences window if it is open */
    IF VALID-HANDLE(ghPreferences) THEN
      RUN closeWindow IN ghPreferences NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR.

    /* Close the foreign field mapping window if it is open */
    IF VALID-HANDLE(ghFFMapper) THEN
      RUN closeWindow IN ghFFMapper NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR.

    /* Close the SBO data logic procedure generator window if it is open */
    IF VALID-HANDLE(ghSBODLProcedure) THEN
      RUN closeWindow IN ghSBODLProcedure NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR.

    RUN setupFolderPages IN TARGET-PROCEDURE (INPUT ?).

    IF VALID-HANDLE(ghProcLib) THEN
      RUN destroyObject IN ghProcLib.

    RUN SUPER.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
  END.
  ELSE
  DO:
    RUN hideObject IN TARGET-PROCEDURE.

    IF VALID-HANDLE(ghLinkMaintenance) THEN RUN hideObject IN ghLinkMaintenance.
    IF VALID-HANDLE(ghPageMaintenance) THEN RUN hideObject IN ghPageMaintenance.
    IF VALID-HANDLE(ghObjectLocator)   THEN RUN hideObject IN ghObjectLocator.
    IF VALID-HANDLE(ghPreferences)     THEN RUN hideObject IN ghPreferences.
    IF VALID-HANDLE(ghMenuStruct)      THEN RUN hideObject IN ghMenuStruct.
    IF VALID-HANDLE(ghSequencing)      THEN RUN hideObject IN ghSequencing.

    {fn checkChildWindows}.

    RETURN ERROR "ERROR".  /* stop destroyobject in the container from wacking the admprops - cause we are just hiding, not destroying */
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayContainerDetails) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayContainerDetails Procedure 
PROCEDURE displayContainerDetails :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER piPageNumber AS INTEGER    NO-UNDO.
  
  DEFINE VARIABLE cContainerMode          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectFilename         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE httSmartObject          AS HANDLE     NO-UNDO.

  DEFINE BUFFER ttSmartObject FOR ttSmartObject.
  DEFINE BUFFER ttObjectType  FOR ttObjectType.

  ASSIGN
      dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U))
      cContainerMode          = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U).

  FIND FIRST ttSmartObject
       WHERE ttSmartObject.d_smartobject_obj         <> 0.00
         AND ttSmartObject.d_customization_result_obj = dCustomizationResultObj.

  FOR FIRST ttObjectType
      WHERE ttObjectType.d_object_type_obj = ttSmartObject.d_object_type_obj.
    
    ASSIGN
        cObjectFilename         = (IF ttSmartObject.c_object_filename = "":U THEN "New":U ELSE ttSmartObject.c_object_filename)
        ghContainerHandle:TITLE = gcTitle + " ":U + cObjectFilename
                                + (IF cContainerMode <> "ADD":U THEN " (":U + ttObjectType.c_object_type_code + ")":U ELSE "":U).
  END.


/*  IF cContainerMode <> "FIND":U THEN*/
  DO:

    /*IF ttSmartObject.c_object_filename = "":U THEN*/
    RUN selectPage IN TARGET-PROCEDURE (INPUT piPageNumber).

    RUN setupFolderPages IN TARGET-PROCEDURE (INPUT piPageNumber).

    httSmartObject = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "ttSmartObject":U).

    httSmartObject:FIND-FIRST("WHERE ttSmartObject.d_smartobject_obj         <> 0 ":U
                              + "AND ttSmartObject.d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj)).

    RUN getContainerDetails IN ghContainerViewer (httSmartObject).
    RUN changeFolderPage IN TARGET-PROCEDURE.

    /* Refresh the link and page details if they are open */
    RUN launchLinks IN TARGET-PROCEDURE (INPUT FALSE,
                                          INPUT 0.00).
    RUN launchPages IN TARGET-PROCEDURE (INPUT FALSE,
                                          INPUT piPageNumber - 1).

    IF cContainerMode <> "FIND":U THEN
      PUBLISH "enableViewerObjects":U FROM TARGET-PROCEDURE (INPUT TRUE).
/*
    RUN clearSourceTarget IN TARGET-PROCEDURE.*/
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchContainerData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchContainerData Procedure 
PROCEDURE fetchContainerData :
/*------------------------------------------------------------------------------
  Purpose:  This is the point where all details for the containers will be fetched
            from.

  Parameters:  INPUT pcObjectFilename - The name of the container that needs to
                                        be fetched.

  Notes:  The customization result obj will be retrieved here from a user property
          set when the Result Code lookup was used.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcObjectFilename AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cCustomizationResultCode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectFilename           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStatusDefault            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContainerMode            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cInstanceName             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldList                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iCurrentPage              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNumPages                 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hPropSheet                AS HANDLE     NO-UNDO.

  /* Set the wait-state */
  SESSION:SET-WAIT-STATE("GENERAL":U).

  {get StatusDefault cStatusDefault}.

  DEFINE BUFFER ttObjectInstance FOR ttObjectInstance.
  DEFINE BUFFER ttSmartObject    FOR ttSmartObject.

  DEFINE VARIABLE hLastCallingProc          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLastContainerName        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLastObjectName           AS CHARACTER  NO-UNDO.

  IF VALID-HANDLE(ghProcLib) THEN
  DO:
    RUN getLastObjectDetails IN ghProcLib (OUTPUT hLastCallingProc,
                                           OUTPUT cLastContainerName,
                                           OUTPUT cLastObjectName).
  
    hPropSheet = DYNAMIC-FUNCTION("getPropSheet":U IN ghProcLib).
  END.
  
  /* Unregister the objects of the container from the Property Sheet before we open the new objects */
  RUN unregisterPSObjects IN TARGET-PROCEDURE (INPUT "":U).

  /* Empty all the TEMP-TABLEs */
  EMPTY TEMP-TABLE ttObjectMenuStructure.
  EMPTY TEMP-TABLE ttObjectInstance.
  EMPTY TEMP-TABLE ttAttributeValue.
  EMPTY TEMP-TABLE ttSmartObject.
  EMPTY TEMP-TABLE ttSmartLink.
  EMPTY TEMP-TABLE ttUiEvent.
  EMPTY TEMP-TABLE ttPage.

  /* Get some of the data necessary to pass to the Container Builder PLIP */
  ASSIGN
      cCustomizationResultCode = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultCode":U)
      dCustomizationResultObj  = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U))
      cContainerMode           = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U)
      iCurrentPage             = DYNAMIC-FUNCTION("getCurrentPage":U  IN TARGET-PROCEDURE)
      cQuery                   = "FOR EACH ryc_smartobject ":U
                               + "   WHERE ryc_smartobject.object_filename          = '":U + TRIM(pcObjectFilename) + "'":U
                               + "     AND ryc_smartobject.customization_result_obj = 0".

  /* We check to see if the master container exists */
  RUN getRecordDetail IN gshGenManager (INPUT  cQuery,
                                        OUTPUT cFieldList).

  /* Check if a valid container was found - if one could not find be found, inform the user. If the ContainerMode is ADD, then it is valid not to find anything */
  IF NOT (TRIM(cFieldList) <> "":U)    AND
     cContainerMode         = "FIND":U THEN
  DO:
    ASSIGN
        cMessage = "The container '":U + pcObjectFilename + "' could not be found.":U.

    IF pcObjectFilename = "":U THEN
      SESSION:SET-WAIT-STATE("":U).
    ELSE
    DO:
      RUN showMessages IN gshSessionManager (INPUT  cMessage,                     /* message to display */
                                             INPUT  "ERR":U,                      /* error type         */
                                             INPUT  "&Ok":U,                      /* button list        */
                                             INPUT  "&Ok":U,                      /* default button     */ 
                                             INPUT  "&Ok":U,                      /* cancel button      */
                                             INPUT  "Could not find container":U, /* error window title */
                                             INPUT  YES,                          /* display if empty   */ 
                                             INPUT  THIS-PROCEDURE,               /* container handle   */ 
                                             OUTPUT cButton).                     /* button pressed     */

      RETURN.
    END.
  END.

  {set StatusDefault "'Fetching data...'"}.

  /* This will clear the temp-tables if the record does not exist, or find it if it does */
  {launch.i &PLIP     = 'ry/app/rycntbplip.p'
            &IProc    = 'getContainerDetails'
            &PList    = "(INPUT  pcObjectFilename,
                          INPUT  gcProductModuleCode,
                          INPUT  gcObjectTypeCode,
                          INPUT  dCustomizationResultObj,
                          OUTPUT TABLE ttSmartObject,
                          OUTPUT TABLE ttPage,
                          OUTPUT TABLE ttPageObject,      /* Not to be used anymore */
                          OUTPUT TABLE ttObjectInstance,
                          OUTPUT TABLE ttAttributeValue,
                          OUTPUT TABLE ttUiEvent,
                          OUTPUT TABLE ttSmartLink,
                          OUTPUT TABLE ttObjectMenuStructure)"
            &OnApp    = 'YES'
            &AutoKill = YES}

  /* Set the handles of the TEMP-TABLES in the TARGET-PROCEDURE as user properties so the other procedures and viewers can have access them */
  DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ttObjectMenuStructure":U, STRING(TEMP-TABLE ttObjectMenuStructure:DEFAULT-BUFFER-HANDLE)).
  DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ttObjectInstance":U,      STRING(TEMP-TABLE ttObjectInstance:DEFAULT-BUFFER-HANDLE)).
  DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ttAttributeValue":U,      STRING(TEMP-TABLE ttAttributeValue:DEFAULT-BUFFER-HANDLE)).
  DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ttSmartObject":U,         STRING(TEMP-TABLE ttSmartObject:DEFAULT-BUFFER-HANDLE)).
  DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ttSmartLink":U,           STRING(TEMP-TABLE ttSmartLink:DEFAULT-BUFFER-HANDLE)).
  DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ttUiEvent":U,             STRING(TEMP-TABLE ttUiEvent:DEFAULT-BUFFER-HANDLE)).
  DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ttPage":U,                STRING(TEMP-TABLE ttPage:DEFAULT-BUFFER-HANDLE)).

  FIND FIRST ttSmartObject
       WHERE ttSmartObject.d_smartobject_obj         <> 0.00
         AND ttSmartObject.d_customization_result_obj = dCustomizationResultObj.
  
  DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ObjectFilename":U, ttSmartObject.c_object_filename).

  FOR FIRST ttObjectType
      WHERE ttObjectType.d_object_type_obj = ttSmartObject.d_object_type_obj.
    
    ASSIGN
        cObjectFilename         = (IF ttSmartObject.c_object_filename = "":U THEN "New":U ELSE ttSmartObject.c_object_filename)
        ghContainerHandle:TITLE = gcTitle + " ":U + cObjectFilename
                                + (IF cContainerMode <> "ADD":U THEN " (":U + ttObjectType.c_object_type_code + ")":U ELSE "":U).
  END.
  
  /* Count the number of pages the container has */
  iNumPages = 0.
  FOR EACH ttPage
     WHERE ttPage.d_customization_result_obj = dCustomizationResultObj
       AND ttPage.c_action                  <> "D":U:
    iNumPages = iNumPages + 1.
  END.

  IF iCurrentPage >= iNumPages + 1 THEN
    iCurrentPage = 1.

  IF ttSmartObject.c_object_filename <> "":U THEN
    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U, "MODIFY":U).

  DYNAMIC-FUNCTION("evaluateActions" IN TARGET-PROCEDURE).

  PUBLISH "enableSearchLookups":U FROM TARGET-PROCEDURE (INPUT FALSE).

  /* Let the Container Builder process the data */
  {set StatusDefault "'Processing data...'"}.

  RUN displayContainerDetails IN TARGET-PROCEDURE (INPUT iCurrentPage).

  /*PROCESS EVENTS.*/

  /* Register the object instances in the Property Sheet */
  RUN registerPSObjects IN TARGET-PROCEDURE (INPUT "":U).
    
  /* If other tools of the Container Builder are open, let them refresh and display the newly saved data */
  PUBLISH "refreshData":U FROM TARGET-PROCEDURE (INPUT "NewData":U, INPUT 0.00).

  FIND FIRST ttObjectInstance
       WHERE ttObjectInstance.d_object_instance_obj <> 0
         AND ttObjectInstance.d_object_instance_obj  = DECIMAL(cLastObjectName) NO-ERROR.

  IF AVAILABLE ttObjectInstance                                             AND
     ttObjectInstance.d_customization_result_obj <> dCustomizationResultObj THEN
  DO:
    cInstanceName = ttObjectInstance.c_instance_name.

    FIND FIRST ttObjectInstance
         WHERE ttObjectInstance.c_instance_name = cInstanceName
           AND ttObjectInstance.d_customization_result_obj = dCustomizationResultObj.

    ASSIGN
        cLastObjectName    = STRING(ttObjectInstance.d_object_instance_obj)
        cLastContainerName = ttObjectInstance.c_instance_name.
  END.

  IF NOT AVAILABLE ttObjectInstance             AND
     VALID-HANDLE(hPropSheet)                   AND
    (ttSmartObject.d_smartobject_obj > 0.00     OR
     cContainerMode                  = "ADD":U) THEN
    RUN displayProperties IN ghProcLib (TARGET-PROCEDURE, ttSmartObject.d_smartobject_obj, ttSmartObject.d_smartobject_obj, cCustomizationResultCode, TRUE, 0).
  ELSE
    IF VALID-HANDLE(hPropSheet) THEN
      RUN launchProperties IN TARGET-PROCEDURE.
    
  /* Lift the wait-state */
  SESSION:SET-WAIT-STATE("":U).

  /* Clear the Status Default */
  {set StatusDefault cStatusDefault}.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchTemplateData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchTemplateData Procedure 
PROCEDURE fetchTemplateData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcObjectFilename AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cCustomizationResultCode  AS CHARACTER  NO-UNDO.

  DEFINE BUFFER ttTmpltObjectInstance FOR ttTmpltObjectInstance.
  DEFINE BUFFER ttTmpltAttributeValue FOR ttTmpltAttributeValue.
  DEFINE BUFFER ttTmpltSmartObject    FOR ttTmpltSmartObject.
  DEFINE BUFFER ttTmpltSmartLink      FOR ttTmpltSmartLink.
  DEFINE BUFFER ttTmpltPage           FOR ttTmpltPage.
  DEFINE BUFFER ttObjectInstance      FOR ttObjectInstance.
  DEFINE BUFFER ttAttributeValue      FOR ttAttributeValue.
  DEFINE BUFFER ttSmartObject         FOR ttSmartObject.
  
  DEFINE BUFFER ttSmartLink           FOR ttSmartLink.
  DEFINE BUFFER ttPage                FOR ttPage.

  EMPTY TEMP-TABLE ttTmpltObjectMenuStructure.
  EMPTY TEMP-TABLE ttTmpltObjectInstance.
  EMPTY TEMP-TABLE ttTmpltAttributeValue.
  EMPTY TEMP-TABLE ttTmpltSmartObject.
  EMPTY TEMP-TABLE ttTmpltSmartLink.
  EMPTY TEMP-TABLE ttTmpltUiEvent.
  EMPTY TEMP-TABLE ttTmpltPage.

  DEFINE VARIABLE lAssignObjectType AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE hObjectTypeCombo  AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hComboHandle      AS HANDLE   NO-UNDO.

  SESSION:SET-WAIT-STATE("GENERAL":U).

  {launch.i &PLIP     = 'ry/app/rycntbplip.p'
            &IProc    = 'getContainerDetails'
            &PList    = "(INPUT  pcObjectFilename,
                          INPUT  gcProductModuleCode,
                          INPUT  gcObjectTypeCode,
                          INPUT  0.00,
                          OUTPUT TABLE ttTmpltSmartObject,
                          OUTPUT TABLE ttTmpltPage,
                          OUTPUT TABLE ttPageObject,   /* Not to be used anymore */
                          OUTPUT TABLE ttTmpltObjectInstance,
                          OUTPUT TABLE ttTmpltAttributeValue,
                          OUTPUT TABLE ttTmpltUiEvent,
                          OUTPUT TABLE ttTmpltSmartLink,
                          OUTPUT TABLE ttTmpltObjectMenuStructure)"
            &OnApp    = 'YES'
            &AutoKill = YES}

  /* Determine if we will be able to assign the object type of the template */
  IF VALID-HANDLE(ghContainerViewer) THEN
    hObjectTypeCombo = {fnarg getSDFHandle 'hObjectType':U ghContainerViewer}.

  IF VALID-HANDLE(hObjectTypeCombo) THEN
    ASSIGN
        hComboHandle      = {fn getComboHandle hObjectTypeCombo}
        lAssignObjectType = (IF {fn getObjectEnabled hObjectTypeCombo} AND NOT hComboHandle:MODIFIED THEN TRUE ELSE FALSE).

  /* ------------------------------------------------------ SmartObject ------------------------------------------------------ */
  FIND FIRST ttSmartObject
       WHERE ttSmartObject.d_smartobject_obj         <> 0.00
         AND ttSmartObject.d_customization_result_obj = 0.00.
  
  FIND FIRST ttTmpltSmartObject
       WHERE ttTmpltSmartObject.d_smartobject_obj <> 0.00.
  
  BUFFER-COPY ttTmpltSmartObject
       EXCEPT ttTmpltSmartObject.d_smartobject_obj
              ttTmpltSmartObject.l_template
              ttTmpltSmartObject.d_product_module_obj
              ttTmpltSmartObject.d_object_type_obj
              ttTmpltSmartObject.d_customization_result_obj
              ttTmpltSmartObject.c_template_object_name
              ttTmpltSmartObject.c_object_description
              ttTmpltSmartObject.c_object_filename
              ttTmpltSmartObject.d_layout_obj
              ttTmpltSmartObject.d_object_obj
              ttTmpltSmartObject.c_action
           TO ttSmartObject.

  IF ttSmartObject.c_object_description = "":U OR
     ttSmartObject.c_object_description = ?    THEN
    ttSmartObject.c_object_description = ttTmpltSmartObject.c_object_description.

  ttSmartObject.c_template_object_name = pcObjectFilename.

  IF lAssignObjectType THEN
    ttSmartObject.d_object_type_obj = ttTmpltSmartObject.d_object_type_obj.

  /* ------------------------------------ Page, ObjectInstance and SmartLink ------------------------------------- */
  /* DELETING*/
  /* --------- Page --------- */
  FOR EACH ttPage:
    ttPage.c_action = "D":U.
    
    IF ttPage.d_page_obj <= 0.00 THEN
      DELETE ttPage.
  END.

  /* --------- ObjectInstance --------- */
  FOR EACH ttObjectInstance
     WHERE ttObjectInstance.d_smartobject_obj <> 0.00:

    RUN unregisterPSObjects IN TARGET-PROCEDURE (INPUT STRING(ttObjectInstance.d_object_instance_obj)).

    ttObjectInstance.c_action = "D":U.
  
    IF ttObjectInstance.d_object_instance_obj <= 0.00 THEN
      DELETE ttObjectInstance.
  END.
      
  /* --------- SmartLink --------- */
  FOR EACH ttSmartLink:
    ttSmartLink.c_action = "D":U.

    IF ttSmartLink.d_smartlink_obj <= 0.00 THEN
      DELETE ttSmartLink.
  END.
  
  /* --------- AttributeValue --------- */
  FOR EACH ttAttributeValue:
    ttAttributeValue.c_action = "D":U.

    IF ttAttributeValue.d_attribute_value_obj <= 0.00 THEN
      DELETE ttAttributeValue.
  END.
  
  /* --------- UiEvent --------- */
  FOR EACH ttUiEvent:
    ttUiEvent.c_action = "D":U.

    IF ttUiEvent.d_ui_event_obj <= 0.00 THEN
      DELETE ttUiEvent.
  END.
  
  /* --------- ObjectMenuStructure --------- */
  FOR EACH ttObjectMenuStructure:
     ttObjectMenuStructure.c_action = "D":U.

    IF ttObjectMenuStructure.d_object_menu_structure_obj <= 0.00 THEN
      DELETE ttObjectMenuStructure.
  END.

  /* CREATING*/
  /* --------- Page --------- */
  FOR EACH ttTmpltPage:

    CREATE ttPage.
    
    BUFFER-COPY ttTmpltPage
             TO ttPage.
         ASSIGN ttPage.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj
                ttPage.d_page_obj                  = DYNAMIC-FUNCTION("getTemporaryObj":U IN TARGET-PROCEDURE)
                ttPage.c_action                    = "A":U.
    
    /* Update the page_obj on the template object instance records to reflect the new page obj */
    FOR EACH ttTmpltObjectInstance
       WHERE ttTmpltObjectInstance.d_page_obj = ttTmpltPage.d_page_obj:

      ttTmpltObjectInstance.d_page_obj = ttPage.d_page_obj.
    END.
  END.

  /* --------- ObjectMenuStructure --------- */
  FOR EACH ttTmpltObjectMenuStructure:
    CREATE ttObjectMenuStructure.
    
    BUFFER-COPY ttTmpltObjectMenuStructure
             TO ttObjectMenuStructure
         ASSIGN ttObjectMenuStructure.d_object_menu_structure_obj = DYNAMIC-FUNCTION("getTemporaryObj":U IN TARGET-PROCEDURE)
                ttObjectMenuStructure.d_object_obj                = ttSmartObject.d_smartobject_obj
                ttObjectMenuStructure.c_action                    = "A":U.
  END.
  
  /* --------- SmartLink --------- */
  FOR EACH ttTmpltSmartLink:
    
    CREATE ttSmartLink.
    
    BUFFER-COPY ttTmpltSmartLink
             TO ttSmartLink.
         ASSIGN ttSmartLink.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj
                ttSmartLink.d_smartlink_obj             = DYNAMIC-FUNCTION("getTemporaryObj":U IN TARGET-PROCEDURE)
                ttSmartLink.c_action                    = "A":U.
  END.
  
  /* --------- AttributeValue --------- */
  FOR EACH ttTmpltAttributeValue:

    CREATE ttAttributeValue.

    BUFFER-COPY ttTmpltAttributeValue
             TO ttAttributeValue
         ASSIGN ttAttributeValue.d_container_smartobject_obj = (IF ttTmpltAttributeValue.d_container_smartobject_obj = 0.00 THEN 0.00 ELSE ttSmartObject.d_smartobject_obj)
                ttAttributeValue.d_primary_smartobject_obj   = ttSmartObject.d_smartobject_obj
                ttAttributeValue.d_customization_result_obj  = 0.00
                ttAttributeValue.d_attribute_value_obj       = DYNAMIC-FUNCTION("getTemporaryObj":U IN TARGET-PROCEDURE)
                /* Check if it is a container property - if so, point it at the new container, else it was a property for an object instance, so point it at the correct smartobject */
                ttAttributeValue.d_smartobject_obj           = (IF ttTmpltAttributeValue.d_smartobject_obj = 0.00 THEN
                                                                  0.00
                                                                ELSE
                                                                  IF ttTmpltAttributeValue.d_smartobject_obj = ttTmpltSmartObject.d_smartobject_obj THEN
                                                                    ttSmartObject.d_smartobject_obj
                                                                  ELSE
                                                                    ttTmpltAttributeValue.d_smartobject_obj)
                /* Check if it is a container property - if so, point it at the object type of the new container, else it was a property for an object instance, so point it at the correct object type of the instance*/
                ttAttributeValue.d_object_type_obj           = (IF ttTmpltAttributeValue.d_smartobject_obj = 0.00 THEN
                                                                  0.00
                                                                ELSE
                                                                  IF ttTmpltAttributeValue.d_smartobject_obj = ttTmpltSmartObject.d_smartobject_obj THEN
                                                                    ttSmartObject.d_object_type_obj
                                                                  ELSE
                                                                    ttTmpltAttributeValue.d_object_type_obj)
                ttAttributeValue.c_action                    = "A":U.
  END.

  /* --------- UiEvent --------- */
  FOR EACH ttTmpltUiEvent:

    CREATE ttUiEvent.

    BUFFER-COPY ttTmpltUiEvent
             TO ttUiEvent
         ASSIGN ttUiEvent.d_container_smartobject_obj = (IF ttTmpltUiEvent.d_container_smartobject_obj = 0.00 THEN 0.00 ELSE ttSmartObject.d_smartobject_obj)
                ttUiEvent.d_primary_smartobject_obj   = ttSmartObject.d_smartobject_obj
                ttUiEvent.d_customization_result_obj  = 0.00
                ttUiEvent.d_ui_event_obj              = DYNAMIC-FUNCTION("getTemporaryObj":U IN TARGET-PROCEDURE)
                /* Check if it is a container ui event - if so, point it at the new container, else it was a ui event for an object instance, so point it at the correct smartobject */
                ttUiEvent.d_smartobject_obj           = (IF ttTmpltUiEvent.d_smartobject_obj = 0.00 THEN
                                                           0.00
                                                         ELSE
                                                           IF ttTmpltUiEvent.d_smartobject_obj = ttTmpltSmartObject.d_smartobject_obj THEN
                                                             ttSmartObject.d_smartobject_obj
                                                           ELSE
                                                             ttTmpltUiEvent.d_smartobject_obj)
                /* Check if it is a container ui event - if so, point it at the object type of the new container, else it was a ui event for an object instance, so point it at the correct object type of the instance*/
                ttUiEvent.d_smartobject_obj           = (IF ttTmpltUiEvent.d_smartobject_obj = 0.00 THEN
                                                           0.00
                                                         ELSE
                                                           IF ttTmpltUiEvent.d_smartobject_obj = ttTmpltSmartObject.d_smartobject_obj THEN
                                                             ttSmartObject.d_smartobject_obj
                                                           ELSE
                                                             ttTmpltUiEvent.d_smartobject_obj)
                ttUiEvent.c_action                    = "A":U.
  END.

  /* --------- ObjectInstance --------- */
  FOR EACH ttTmpltObjectInstance
     WHERE ttTmpltObjectInstance.d_smartobject_obj <> 0.00:
    
    CREATE ttObjectInstance.

    BUFFER-COPY ttTmpltObjectInstance
         EXCEPT ttTmpltObjectInstance.c_instance_name
             TO ttObjectInstance.
         ASSIGN ttObjectInstance.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj
                ttObjectInstance.d_object_instance_obj       = DYNAMIC-FUNCTION("getTemporaryObj":U IN TARGET-PROCEDURE)
                ttObjectInstance.c_action                    = "A":U
                ttObjectInstance.c_instance_name             = DYNAMIC-FUNCTION("getUniqueInstanceName":U IN TARGET-PROCEDURE, REPLACE(ttTmpltObjectInstance.c_instance_name, ".":U, "":U)).

    /* Make sure the SmartLinks point to the newly created object instances */
    FOR EACH  ttSmartLink
       WHERE  ttSmartLink.d_container_smartobject_obj  = ttSmartObject.d_smartobject_obj
         AND (ttSmartLink.d_source_object_instance_obj = ttTmpltObjectInstance.d_object_instance_obj
          OR  ttSmartLink.d_target_object_instance_obj = ttTmpltObjectInstance.d_object_instance_obj)
         AND  ttSmartLink.c_action                     <> "D":U:
      
      IF ttSmartLink.d_source_object_instance_obj = ttTmpltObjectInstance.d_object_instance_obj THEN
        ttSmartLink.d_source_object_instance_obj = ttObjectInstance.d_object_instance_obj.

      IF ttSmartLink.d_target_object_instance_obj = ttTmpltObjectInstance.d_object_instance_obj THEN
        ttSmartLink.d_target_object_instance_obj = ttObjectInstance.d_object_instance_obj.
    END.

    /* Make sure the attributes of the object instance point to the new object instance record */
    FOR EACH ttAttributeValue
       WHERE ttAttributeValue.d_primary_smartobject_obj = ttSmartObject.d_smartobject_obj
         AND ttAttributeValue.d_object_instance_obj     = ttTmpltObjectInstance.d_object_instance_obj:

      ttAttributeValue.d_object_instance_obj = (IF ttAttributeValue.d_object_instance_obj = 0.00 THEN 0.00 ELSE ttObjectInstance.d_object_instance_obj).
    END.

    /* Make sure the ui events of the object instance point to the new object instance record */
    FOR EACH ttUiEvent
       WHERE ttUiEvent.d_primary_smartobject_obj = ttSmartObject.d_smartobject_obj
         AND ttUiEvent.d_object_instance_obj     = ttTmpltObjectInstance.d_object_instance_obj:

      ttUiEvent.d_object_instance_obj = (IF ttUiEvent.d_object_instance_obj = 0.00 THEN 0.00 ELSE ttObjectInstance.d_object_instance_obj).
    END.

    RUN registerPSObjects IN TARGET-PROCEDURE (INPUT STRING(ttObjectInstance.d_object_instance_obj)).
  END.

  EMPTY TEMP-TABLE ttTmpltObjectMenuStructure.
  EMPTY TEMP-TABLE ttTmpltObjectInstance.
  EMPTY TEMP-TABLE ttTmpltAttributeValue.
  EMPTY TEMP-TABLE ttTmpltSmartObject.
  EMPTY TEMP-TABLE ttTmpltSmartLink.
  EMPTY TEMP-TABLE ttTmpltUiEvent.
  EMPTY TEMP-TABLE ttTmpltPage.

  /* Refresh the contents of the PropertySheet */
  IF VALID-HANDLE(ghProcLib) THEN
  DO:
    cCustomizationResultCode = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultCode":U).

    RUN displayProperties IN ghProcLib (TARGET-PROCEDURE, ttSmartObject.d_smartobject_obj, "":U, cCustomizationResultCode, TRUE, 0).
  END.

  RUN displayContainerDetails IN TARGET-PROCEDURE (INPUT 1).

  SESSION:SET-WAIT-STATE("":U).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchTemplatePageData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchTemplatePageData Procedure 
PROCEDURE fetchTemplatePageData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcObjectFilename         AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pdCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER piPageSequenceToReplace  AS INTEGER    NO-UNDO.
  DEFINE INPUT PARAMETER piPageSequenceToFetch    AS INTEGER    NO-UNDO.

  DEFINE VARIABLE cCustomizationResultCode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContainerMode            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iPageSequenceToKeep       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSequence                 AS INTEGER    NO-UNDO INITIAL 1.

  DEFINE BUFFER ttTmpltObjectInstance FOR ttTmpltObjectInstance.
  DEFINE BUFFER ttTmpltSmartObject    FOR ttTmpltSmartObject.
  DEFINE BUFFER ttTmpltSmartLink      FOR ttTmpltSmartLink.
  DEFINE BUFFER ttTmpltPage           FOR ttTmpltPage.
  DEFINE BUFFER ttObjectInstance      FOR ttObjectInstance.
  DEFINE BUFFER ttSmartObject         FOR ttSmartObject.
  DEFINE BUFFER ttObjectType          FOR ttObjectType.
  DEFINE BUFFER ttSmartLink           FOR ttSmartLink.
  DEFINE BUFFER ttPage                FOR ttPage.

  EMPTY TEMP-TABLE ttTmpltObjectMenuStructure.
  EMPTY TEMP-TABLE ttTmpltObjectInstance.
  EMPTY TEMP-TABLE ttTmpltAttributeValue.
  EMPTY TEMP-TABLE ttTmpltSmartObject.
  EMPTY TEMP-TABLE ttTmpltSmartLink.
  EMPTY TEMP-TABLE ttTmpltUiEvent.
  EMPTY TEMP-TABLE ttTmpltPage.

  SESSION:SET-WAIT-STATE("GENERAL":U).

  {launch.i &PLIP     = 'ry/app/rycntbplip.p'
            &IProc    = 'getContainerDetails'
            &PList    = "(INPUT  pcObjectFilename,
                          INPUT  gcProductModuleCode,
                          INPUT  gcObjectTypeCode,
                          INPUT  pdCustomizationResultObj,
                          OUTPUT TABLE ttTmpltSmartObject,
                          OUTPUT TABLE ttTmpltPage,
                          OUTPUT TABLE ttPageObject,   /* Not to be used anymore */
                          OUTPUT TABLE ttTmpltObjectInstance,
                          OUTPUT TABLE ttTmpltAttributeValue,
                          OUTPUT TABLE ttTmpltUiEvent,
                          OUTPUT TABLE ttTmpltSmartLink,
                          OUTPUT TABLE ttTmpltObjectMenuStructure)"
            &OnApp    = 'YES'
            &AutoKill = YES}

  ASSIGN
      dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U))
      cContainerMode          = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U).

  FIND FIRST ttSmartObject
       WHERE ttSmartObject.d_smartobject_obj         <> 0.00
         AND ttSmartObject.d_customization_result_obj = dCustomizationResultObj.

  /* First try to find the page on the master container, if it exists, then use that page */
  FIND FIRST ttPage
       WHERE ttPage.i_page_sequence            = piPageSequenceToReplace
         AND ttPage.d_customization_result_obj = 0.00 NO-ERROR.

  /* If the page did not exist in the above find, then it must exist as the customization */
  IF NOT AVAILABLE ttPage THEN
    FIND FIRST ttPage
         WHERE ttPage.i_page_sequence            = piPageSequenceToReplace
           AND ttPage.d_customization_result_obj = dCustomizationResultObj.

  FIND FIRST ttTmpltPage NO-LOCK
       WHERE ttTmpltPage.i_original_page_sequence = piPageSequenceToFetch NO-ERROR.

  IF AVAILABLE ttTmpltPage THEN
    iPageSequenceToKeep = ttTmpltPage.i_page_sequence.
  ELSE
    iPageSequenceToKeep = piPageSequenceToFetch.

  /* ----------------------------------------- Deleting unnecessary template records ----------------------------------------- */
  FOR EACH ttObjectType
     WHERE LOOKUP(ttObjectType.c_object_type_code, gcFolderClasses) <> 0:
  
      FOR EACH  ttTmpltObjectInstance
         WHERE  ttTmpltObjectInstance.i_page           <> iPageSequenceToKeep
            OR (ttTmpltObjectInstance.d_object_type_obj = ttObjectType.d_object_type_obj
           AND  piPageSequenceToReplace                <> 0):

        /* SmartLinks */
        FOR EACH ttTmpltSmartLink
           WHERE ttTmpltSmartLink.d_source_object_instance_obj = ttTmpltObjectInstance.d_object_instance_obj
              OR ttTmpltSmartLink.d_target_object_instance_obj = ttTmpltObjectInstance.d_object_instance_obj:
    
          DELETE ttTmpltSmartLink.
        END.
    
        /* Attributes */
        FOR EACH ttTmpltAttributeValue
           WHERE ttTmpltAttributeValue.d_object_instance_obj = ttTmpltObjectInstance.d_object_instance_obj:
    
          DELETE ttTmpltAttributeValue.
        END.
    
        /* Ui Events */
        FOR EACH ttTmpltUiEvent
           WHERE ttTmpltUiEvent.d_object_instance_obj = ttTmpltObjectInstance.d_object_instance_obj:
    
          DELETE ttTmpltUiEvent.
        END.
        
        /* ObjectInstance */
        DELETE ttTmpltObjectInstance.
      END.
  END.

  /* Pages */
  FOR EACH ttTmpltPage
     WHERE ttTmpltPage.i_page_sequence <> iPageSequenceToKeep:

    DELETE ttTmpltPage.
  END.

  /* ----------------------------------------- Deleting existing objects on the page ----------------------------------------- */
  FOR EACH ttObjectInstance
     WHERE ttObjectInstance.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj
       AND ttObjectInstance.d_smartobject_obj          <> 0.00
       AND ttObjectInstance.i_page                      = piPageSequenceToReplace:

    ttObjectInstance.c_action = "D":U.

    /* SmartLinks */
    FOR EACH  ttSmartLink
       WHERE  ttSmartLink.d_container_smartobject_obj  = ttSmartObject.d_smartobject_obj
         AND (ttSmartLink.d_source_object_instance_obj = ttObjectInstance.d_object_instance_obj
          OR  ttSmartLink.d_target_object_instance_obj = ttObjectInstance.d_object_instance_obj):

      ttSmartLink.c_action = "D":U.
      
      IF ttSmartLink.d_smartlink_obj <= 0.00 THEN
        DELETE ttSmartLink.
    END.

    /* AttributeValues */
    FOR EACH ttAttributeValue
       WHERE ttAttributeValue.d_object_instance_obj     = ttObjectInstance.d_object_instance_obj
         AND ttAttributeValue.d_primary_smartobject_obj = ttSmartObject.d_smartobject_obj:
       
      ttAttributeValue.c_action = "D":U.
      
      IF ttAttributeValue.d_attribute_value_obj <= 0.00 THEN
        DELETE ttAttributeValue.
    END.

    /* UiEvents */
    FOR EACH ttUiEvent
       WHERE ttUiEvent.d_object_instance_obj     = ttObjectInstance.d_object_instance_obj
         AND ttUiEvent.d_primary_smartobject_obj = ttSmartObject.d_smartobject_obj:
       
      ttUiEvent.c_action = "D":U.
      
      IF ttUiEvent.d_ui_event_obj <= 0.00 THEN
        DELETE ttUiEvent.
    END.

    /* ObjectInstance */
    RUN unregisterPSObjects IN TARGET-PROCEDURE (INPUT STRING(ttObjectInstance.d_object_instance_obj)).

    IF ttObjectInstance.d_object_instance_obj <= 0.00 THEN
      DELETE ttObjectInstance.
  END.

  /* ----------------------------- Ensure that the template instances have unique instance names ----------------------------- */
  FOR EACH ttTmpltObjectInstance:
    IF CAN-FIND(FIRST ttObjectInstance
                WHERE ttObjectInstance.c_instance_name = ttTmpltObjectInstance.c_instance_name) THEN
      ASSIGN
          ttTmpltObjectInstance.c_instance_name = DYNAMIC-FUNCTION("getUniqueInstanceName":U IN TARGET-PROCEDURE, ttTmpltObjectInstance.c_instance_name).
  END.
  
  /* ------------------------------- Updating existing page details and creating new instances ------------------------------- */
  /* ttPage is still available from the find above */
  IF piPageSequenceToReplace <> 0 THEN
  DO:
    FOR FIRST ttTmpltPage
        WHERE ttTmpltPage.i_page_sequence = iPageSequenceToKeep:
      
      IF iPageSequenceToKeep <> 0 THEN
        BUFFER-COPY ttTmpltPage
             EXCEPT ttTmpltPage.d_container_smartobject_obj
                    ttTmpltPage.d_customization_result_obj
                    ttTmpltPage.c_page_reference
                    ttTmpltPage.c_security_token
                    ttTmpltPage.i_page_sequence
                    ttTmpltPage.c_page_label
                    ttTmpltPage.d_page_obj
                    ttTmpltPage.c_action
                 TO ttPage.
    END.

    /* Update the page_obj on the template object instance records to reflect the new page obj */
    FOR EACH ttTmpltObjectInstance
       WHERE ttTmpltObjectInstance.d_page_obj = ttTmpltPage.d_page_obj:

      ttTmpltObjectInstance.d_page_obj = ttPage.d_page_obj.
    END.
  END.
  
  /* --------- SmartLink --------- */
  FOR EACH ttTmpltSmartLink:
    
    CREATE ttSmartLink.
    
    BUFFER-COPY ttTmpltSmartLink
             TO ttSmartLink.
         ASSIGN ttSmartLink.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj
                ttSmartLink.d_customization_result_obj  = dCustomizationResultObj
                ttSmartLink.d_smartlink_obj             = DYNAMIC-FUNCTION("getTemporaryObj":U IN TARGET-PROCEDURE)
                ttSmartLink.c_action                    = "A":U.
  END.

  /* --------- ObjectInstance --------- */
  FOR EACH ttTmpltObjectInstance
     WHERE ttTmpltObjectInstance.d_smartobject_obj <> 0.00
       AND ttTmpltObjectInstance.i_page             = iPageSequenceToKeep:

    CREATE ttObjectInstance.

    BUFFER-COPY ttTmpltObjectInstance
         EXCEPT ttTmpltObjectInstance.c_instance_name
             TO ttObjectInstance
         ASSIGN ttObjectInstance.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj
                ttObjectInstance.d_customization_result_obj  = dCustomizationResultObj
                ttObjectInstance.d_object_instance_obj       = DYNAMIC-FUNCTION("getTemporaryObj":U IN TARGET-PROCEDURE)
                ttObjectInstance.c_action                    = "A":U
                ttObjectInstance.i_page                      = piPageSequenceToReplace
                ttObjectInstance.i_object_sequence           = iSequence
                ttObjectInstance.c_instance_name             = DYNAMIC-FUNCTION("getUniqueInstanceName":U IN TARGET-PROCEDURE, REPLACE(ttTmpltObjectInstance.c_instance_name, ".":U, "":U))
                iSequence                                    = iSequence + 1.

    /* --------- SmartLink --------- */
    /* Make sure the SmartLinks point to the newly created object instances */
    FOR EACH ttSmartLink
       WHERE ttSmartLink.d_container_smartobject_obj  = ttSmartObject.d_smartobject_obj
         AND ttSmartLink.c_action                     <> "D":U:

      IF ttSmartLink.d_source_object_instance_obj = ttTmpltObjectInstance.d_object_instance_obj THEN
        ttSmartLink.d_source_object_instance_obj = ttObjectInstance.d_object_instance_obj.

      IF ttSmartLink.d_target_object_instance_obj = ttTmpltObjectInstance.d_object_instance_obj THEN
        ttSmartLink.d_target_object_instance_obj = ttObjectInstance.d_object_instance_obj.
    END.
  
    /* --------- AttributeValue --------- */
    FOR EACH ttTmpltAttributeValue
       WHERE ttTmpltAttributeValue.d_primary_smartobject_obj = ttTmpltObjectInstance.d_container_smartobject_obj
         AND ttTmpltAttributeValue.d_object_instance_obj     = ttTmpltObjectInstance.d_object_instance_obj:

      CREATE ttAttributeValue.
      
      BUFFER-COPY ttTmpltAttributeValue
               TO ttAttributeValue
           ASSIGN ttAttributeValue.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj
                  ttAttributeValue.d_primary_smartobject_obj   = ttSmartObject.d_smartobject_obj
                  ttAttributeValue.d_customization_result_obj  = dCustomizationResultObj
                  ttAttributeValue.d_attribute_value_obj       = DYNAMIC-FUNCTION("getTemporaryObj":U IN TARGET-PROCEDURE)
                  ttAttributeValue.d_object_instance_obj       = ttObjectInstance.d_object_instance_obj
                  ttAttributeValue.c_action                    = "A":U.
    END.
    
    /* --------- UiEvent --------- */
    FOR EACH ttTmpltUiEvent
       WHERE ttTmpltUiEvent.d_primary_smartobject_obj = ttTmpltObjectInstance.d_container_smartobject_obj
         AND ttTmpltUiEvent.d_object_instance_obj     = ttTmpltObjectInstance.d_object_instance_obj:

      CREATE ttUiEvent.
      
      BUFFER-COPY ttTmpltUiEvent
               TO ttUiEvent
           ASSIGN ttUiEvent.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj
                  ttUiEvent.d_primary_smartobject_obj   = ttSmartObject.d_smartobject_obj
                  ttUiEvent.d_customization_result_obj  = dCustomizationResultObj
                  ttUiEvent.d_ui_event_obj              = DYNAMIC-FUNCTION("getTemporaryObj":U IN TARGET-PROCEDURE)
                  ttUiEvent.d_object_instance_obj       = ttObjectInstance.d_object_instance_obj
                  ttUiEvent.c_action                    = "A":U.
    END.
    
    RUN registerPSObjects IN TARGET-PROCEDURE (INPUT STRING(ttObjectInstance.d_object_instance_obj)).
  END.

  /* If the source or target object instance does not exist, delete the link */
  FOR EACH ttSmartLink
     WHERE ttSmartLink.d_container_smartobject_obj  = ttSmartObject.d_smartobject_obj
       AND ttSmartLink.c_action                    <> "D":U:

    IF NOT CAN-FIND(FIRST  ttObjectInstance
                    WHERE  ttObjectInstance.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj
                      AND (ttObjectInstance.d_object_instance_obj       = ttSmartlink.d_source_object_instance_obj
                       OR  ttObjectInstance.d_object_instance_obj       = ttSmartlink.d_source_object_instance_obj)
                      AND  ttObjectInstance.c_action                   <> "D":U) THEN
    DO:
      ttSmartLink.c_action = "D":U.
      
      IF ttSmartLink.d_smartlink_obj <= 0.00 THEN
        DELETE ttSmartLink.
    END.
  END.
  
  EMPTY TEMP-TABLE ttTmpltObjectMenuStructure.
  EMPTY TEMP-TABLE ttTmpltObjectInstance.
  EMPTY TEMP-TABLE ttTmpltAttributeValue.
  EMPTY TEMP-TABLE ttTmpltSmartObject.
  EMPTY TEMP-TABLE ttTmpltSmartLink.
  EMPTY TEMP-TABLE ttTmpltUiEvent.
  EMPTY TEMP-TABLE ttTmpltPage.

  IF cContainerMode <> "ADD":U THEN
    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U, "UPDATE":U).

  DYNAMIC-FUNCTION("evaluateActions":U IN TARGET-PROCEDURE).

  /* If the links browser is open, refresh its temp-table, else our new records would get lost */
  RUN launchLinks IN TARGET-PROCEDURE (INPUT FALSE,
                                        INPUT 0.00).
  
  /* Refresh the contents of the PropertySheet */
  IF VALID-HANDLE(ghProcLib) THEN
  DO:
    cCustomizationResultCode = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultCode":U).

    RUN displayProperties IN ghProcLib (TARGET-PROCEDURE, ttSmartObject.d_smartobject_obj, "":U, cCustomizationResultCode, TRUE, 0).
  END.

  IF glRepositionPT THEN
    RUN displayContainerDetails IN TARGET-PROCEDURE (INPUT piPageSequenceToReplace + 1).

  SESSION:SET-WAIT-STATE("":U).

  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findRecord Procedure 
PROCEDURE findRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContainerMode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lContinue       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lChanges        AS LOGICAL    NO-UNDO.

  cContainerMode = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U).
  
  IF cContainerMode = "INITIAL":U OR
     cContainerMode = "MODIFY":U  OR
     cContainerMode = ?           THEN
  DO:
    RUN checkIfSaved IN TARGET-PROCEDURE (INPUT  TRUE,
                                          INPUT  FALSE,
                                          OUTPUT lChanges,
                                          OUTPUT lContinue) NO-ERROR.

    IF ERROR-STATUS:ERROR OR
       NOT lContinue      THEN
      RETURN.

    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U,  "0":U).
    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultCode":U, "":U).
    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U, "FIND":U).
    DYNAMIC-FUNCTION("evaluateActions":U IN TARGET-PROCEDURE).
    DYNAMIC-FUNCTION("clearLinkObject":U IN ghGridObjectViewer, "SOURCE":U, ?).
    DYNAMIC-FUNCTION("clearLinkObject":U IN ghGridObjectViewer, "TARGET":U, ?).
    DYNAMIC-FUNCTION("evaluateActions":U IN ghGridObjectViewer).

    PUBLISH "enableViewerObjects":U FROM TARGET-PROCEDURE (INPUT FALSE).

    RUN "fetchContainerData":U IN TARGET-PROCEDURE (INPUT "":U).

    PUBLISH "enableSearchLookups":U FROM TARGET-PROCEDURE (INPUT TRUE).
    
    PUBLISH "clearFilters":U FROM TARGET-PROCEDURE.

    RUN trgMenuChoose IN ghGridObjectViewer (INPUT ?, "ClearCut":U).
  END.

  ghContainerHandle:TITLE = gcTitle + " Open":U.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAttributeList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAttributeList Procedure 
PROCEDURE getAttributeList :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcInstanceName  AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcAttributeList AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cAttributeLabels        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttributeValues        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentClasses          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTempValue              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dObjectInstanceObj      AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iCounter                AS INTEGER    NO-UNDO.

  DEFINE BUFFER bttAttributeValue FOR ttAttributeValue.
  DEFINE BUFFER  ttAttributeValue FOR ttAttributeValue.
  DEFINE BUFFER bttObjectInstance FOR ttObjectInstance.
  DEFINE BUFFER  ttObjectInstance FOR ttObjectInstance.
  DEFINE BUFFER  ttSmartObject    FOR ttSmartObject.

  dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U)).

  /* Find the container's smartobject record - we can find the main container or the customized. It does not matter, we only need its name */
  /* Go through the objects on the container, build up their attribute strings and finally register the object */
  IF pcInstanceName = "":U THEN
  DO:
    FOR EACH ttSmartObject
       WHERE ttSmartObject.d_smartobject_obj <> 0.00,
       FIRST ttObjectType
       WHERE ttObjectType.d_object_type_obj = ttSmartObject.d_object_type_obj
       BREAK
          BY ttSmartObject.c_object_filename:

      /* Step through the attributes of the object instance */
      FOR EACH ttAttributeValue
         WHERE ttAttributeValue.d_object_instance_obj = 0.00:

        pcAttributeList = pcAttributeList + (IF pcAttributeList = "":U THEN "":U ELSE CHR(3))
                        + TRIM(ttAttributeValue.c_attribute_label) + CHR(4).

        CASE ttAttributeValue.i_data_type:
          WHEN {&DECIMAL-DATA-TYPE}   THEN cTempValue = STRING(ttAttributeValue.d_decimal_value).
          WHEN {&INTEGER-DATA-TYPE}   THEN cTempValue = STRING(ttAttributeValue.i_integer_value).
          WHEN {&DATE-DATA-TYPE}      THEN cTempValue = STRING(ttAttributeValue.t_date_value).
          WHEN {&RAW-DATA-TYPE}       THEN.
          WHEN {&LOGICAL-DATA-TYPE}   THEN cTempValue = STRING(ttAttributeValue.l_logical_value).
          WHEN {&CHARACTER-DATA-TYPE} THEN cTempValue = ttAttributeValue.c_character_value.
        END CASE.
        ASSIGN
            cTempValue      = (IF cTempValue = ? THEN "?":U ELSE cTempValue)
            pcAttributeList = pcAttributeList + cTempValue.
      END.
    END.
  END.
  ELSE
  DO:
    /* Go through the objects on the container, build up their attribute strings and finally register the object */
    FOR EACH ttObjectInstance
       WHERE ttObjectInstance.d_object_instance_obj <> 0.00
         AND ttObjectInstance.c_instance_name        = pcInstanceName,
       FIRST ttObjectType
       WHERE ttObjectType.d_object_type_obj = ttObjectInstance.d_object_type_obj
       BREAK
          BY ttObjectType.c_object_type_code
          BY ttObjectInstance.d_customization_result_obj:
  
      IF FIRST-OF(ttObjectType.c_object_type_code) THEN
      DO:
        IF NOT CAN-FIND(FIRST ttClassValues
                        WHERE ttClassValues.cClassCode = ttObjectType.c_object_type_code) THEN
        DO:
          {launch.i &PLIP     = 'ry/app/rycntbplip.p'
                    &IProc    = 'getClassValues'
                    &PList    = "(INPUT  ttObjectType.c_object_type_code,
                                  INPUT-OUTPUT TABLE ttClassValues)"
                    &OnApp    = 'YES'
                    &AutoKill = YES}
        END.
      END.

      IF dCustomizationResultObj <> 0.00 THEN
      DO:
        FIND FIRST bttObjectInstance
             WHERE bttObjectInstance.c_instance_name             = ttObjectInstance.c_instance_name
               AND bttObjectInstance.d_customization_result_obj <> 0.00.
        
        dObjectInstanceObj = bttObjectInstance.d_object_instance_obj.
      END.

      /* Step through the attributes of the MASTER instance */
      FOR EACH ttAttributeValue
         WHERE ttAttributeValue.d_smartobject_obj           = ttObjectInstance.d_smartobject_obj
           AND ttAttributeValue.d_primary_smartobject_obj   = ttObjectInstance.d_smartobject_obj
           AND ttAttributeValue.d_container_smartobject_obj = 0.00
           AND ttAttributeValue.d_object_instance_obj       = 0.00:
        /* Only read this attribute if no override is specified */
        IF CAN-FIND(FIRST bttAttributeValue
                    WHERE bttAttributeValue.d_smartobject_obj     = ttAttributeValue.d_smartobject_obj
                      AND bttAttributeValue.d_object_instance_obj = ttObjectInstance.d_object_instance_obj
                      AND bttAttributeValue.c_attribute_label     = ttAttributeValue.c_attribute_label)    OR 
          (ttObjectInstance.d_customization_result_obj            = 0.00                                   AND
           dCustomizationResultObj                               <> 0.00                                   AND
           CAN-FIND(FIRST bttAttributeValue
                    WHERE bttAttributeValue.d_smartobject_obj     = ttAttributeValue.d_smartobject_obj
                      AND bttAttributeValue.d_object_instance_obj = dObjectInstanceObj
                      AND bttAttributeValue.c_attribute_label     = ttAttributeValue.c_attribute_label))   THEN
          NEXT.

        IF LOOKUP(ttAttributeValue.c_attribute_label, cAttributeLabels) = 0 THEN
        DO:
          ASSIGN
              cAttributeLabels = cAttributeLabels + (IF cAttributeLabels = "" THEN "":U ELSE ",":U) + ttAttributeValue.c_attribute_label
              cAttributeValues = cAttributeValues + CHR(3).

          CASE ttAttributeValue.i_data_type:
            WHEN {&DECIMAL-DATA-TYPE}   THEN cTempValue = STRING(ttAttributeValue.d_decimal_value).
            WHEN {&INTEGER-DATA-TYPE}   THEN cTempValue = STRING(ttAttributeValue.i_integer_value).
            WHEN {&DATE-DATA-TYPE}      THEN cTempValue = STRING(ttAttributeValue.t_date_value).
            WHEN {&RAW-DATA-TYPE}       THEN.
            WHEN {&LOGICAL-DATA-TYPE}   THEN cTempValue = STRING(ttAttributeValue.l_logical_value).
            WHEN {&CHARACTER-DATA-TYPE} THEN cTempValue = ttAttributeValue.c_character_value.
          END CASE.

          ASSIGN
              cTempValue       = (IF cTempValue = ? THEN "?":U ELSE cTempValue)
              cAttributeValues = cAttributeValues + cTempValue.
        END.
      END.
 
      /* Step through the attributes of the OBJECT instance */
      FOR EACH ttAttributeValue
         WHERE ttAttributeValue.d_object_instance_obj = ttObjectInstance.d_object_instance_obj:
    
        IF ttObjectInstance.d_customization_result_obj            = 0.00                                AND
           dCustomizationResultObj                               <> 0.00                                AND
           CAN-FIND(FIRST bttAttributeValue
                    WHERE bttAttributeValue.d_smartobject_obj     = ttAttributeValue.d_smartobject_obj
                      AND bttAttributeValue.d_object_instance_obj = dObjectInstanceObj
                      AND bttAttributeValue.c_attribute_label     = ttAttributeValue.c_attribute_label) THEN
          NEXT.

        IF LOOKUP(ttAttributeValue.c_attribute_label, cAttributeLabels) = 0 THEN
        DO:
          ASSIGN
              cAttributeLabels = cAttributeLabels + (IF cAttributeLabels = "" THEN "":U ELSE ",":U) + ttAttributeValue.c_attribute_label
              cAttributeValues = cAttributeValues + CHR(3).

          CASE ttAttributeValue.i_data_type:
            WHEN {&DECIMAL-DATA-TYPE}   THEN cTempValue = STRING(ttAttributeValue.d_decimal_value).
            WHEN {&INTEGER-DATA-TYPE}   THEN cTempValue = STRING(ttAttributeValue.i_integer_value).
            WHEN {&DATE-DATA-TYPE}      THEN cTempValue = STRING(ttAttributeValue.t_date_value).
            WHEN {&RAW-DATA-TYPE}       THEN.
            WHEN {&LOGICAL-DATA-TYPE}   THEN cTempValue = STRING(ttAttributeValue.l_logical_value).
            WHEN {&CHARACTER-DATA-TYPE} THEN cTempValue = ttAttributeValue.c_character_value.
          END CASE.
          ASSIGN
              cTempValue       = (IF cTempValue = ? THEN "?":U ELSE cTempValue)
              cAttributeValues = cAttributeValues + cTempValue.
        END.
      END.
 
      /* If we are dealing with SmartToolbars, we do not want to override any detail about the toolbars' band and actions (picked up by Property Sheet) */
      IF LAST-OF(ttObjectType.c_object_type_code) THEN
        IF LOOKUP(ttObjectType.c_object_type_code, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "Toolbar":U)) = 0 THEN
        DO:
          cParentClasses = DYNAMIC-FUNCTION("getClassParentsFromDB":U IN gshRepositoryManager, ttObjectType.c_object_type_code).
          
          DO iCounter = 1 TO NUM-ENTRIES(cParentClasses):
            /* Get the Values for the Class */
            FOR EACH ttClassValues
               WHERE ttClassValues.cClassCode       = ENTRY(iCounter, cParentClasses):
    
              /* Exclude any attribute which will override and name detail about the objects */
              IF INDEX(ttClassValues.cAttributeLabel, "ObjectName":U) <> 0 THEN
                NEXT.
    
              IF LOOKUP(ttClassValues.cAttributeLabel, cAttributeLabels) = 0 THEN
                ASSIGN
                    cAttributeValues = cAttributeValues + CHR(3) + ttClassValues.cAttributeValue
                    cAttributeLabels = cAttributeLabels + (IF cAttributeLabels = "":U THEN "":U ELSE ",":U)  + ttClassValues.cAttributeLabel.
            END.
          END.
        END.
    END.
  END.

  cAttributeValues = SUBSTRING(cAttributeValues, 2). /* Trim the leading CHR(3) */
  /* Merge cAttributeLabels and cAttributeValues */
  DO iCounter = 1 TO NUM-ENTRIES(cAttributeLabels):
    pcAttributeList = pcAttributeList + (IF pcAttributeList = "":U THEN "":U ELSE CHR(3))
                    + ENTRY(iCounter, cAttributeLabels) + CHR(4)
                    + ENTRY(iCounter, cAttributeValues, CHR(3)).
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInstancefromCustom) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getInstancefromCustom Procedure 
PROCEDURE getInstancefromCustom :
/*------------------------------------------------------------------------------
   Name:      getInstanceFromCustom
   Purpose:   Returns the Original Instance Obj for a specified instance Obj 
              of a customized instance.
              When a result code is added to a container, a negative instance 
              obj is created as a placeholder. This procedure returns the original
              obj.
               
  Parameters:  pdInstanceObj  INPUT-OUTPUT InstanceObj of customized instance. 
                              This is always a negative value.
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETER pdInstanceObj AS DECIMAL     NO-UNDO.

DEFINE BUFFER b_ttObjectInstance FOR ttObjectInstance.

FIND FIRST ttObjectInstance
     WHERE ttObjectInstance.d_object_instance_obj = pdInstanceObj NO-ERROR.
IF AVAIL ttObjectInstance THEN
  FIND FIRST b_ttObjectInstance 
       WHERE b_ttObjectInstance.c_instance_name = ttObjectInstance.c_instance_name
         AND b_ttObjectInstance.d_object_instance_obj > 0 NO-ERROR.

IF AVAIL b_ttObjectInstance
    THEN ASSIGN pdInstanceObj = b_ttObjectInstance.d_object_instance_obj.

 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLinkDetails) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLinkDetails Procedure 
PROCEDURE getLinkDetails :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcInstanceName        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcLinkName            AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plSource              AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcLinkedObjectName    AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcLinkedObjectObj     AS DECIMAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcLinkedObjectType    AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcLinkedObjectInstanceName AS CHARACTER NO-UNDO.

  DEFINE VARIABLE lFinished         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE httObjectInstance AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httObjectType     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httSmartLink      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery            AS HANDLE     NO-UNDO.

  ASSIGN
      httObjectInstance = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "ttObjectInstance":U))
      httObjectType     = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "ttObjectType":U))
      httSmartLink      = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "ttSmartLink":U)).

  DEFINE BUFFER ttObjectInstance FOR ttObjectInstance.
  
  FIND FIRST ttObjectInstance
       WHERE ttObjectInstance.c_instance_name            = pcInstanceName
         AND ttObjectInstance.d_customization_result_obj = 0 NO-ERROR.
  
  IF NOT AVAILABLE ttObjectInstance THEN
    FIND FIRST ttObjectInstance
         WHERE ttObjectInstance.c_instance_name            = pcInstanceName
           AND ttObjectInstance.d_customization_result_obj <> 0.
  
  CREATE BUFFER httObjectInstance FOR TABLE httObjectInstance.
  CREATE BUFFER httObjectType     FOR TABLE httObjectType.
  CREATE BUFFER httSmartLink      FOR TABLE httSmartLink.
  CREATE QUERY  hQuery.

  hQuery:SET-BUFFERS(httSmartLink, httObjectInstance, httObjectType).
  hQuery:QUERY-PREPARE("FOR EACH ttSmartLink":U
                       + " WHERE ttSmartLink.c_link_name = ":U + QUOTER(pcLinkName)
                       + "   AND ttSmartLink.d_":U + (IF plSource THEN "target_":U ELSE "source_":U) + "object_instance_obj = ":U + QUOTER(ttObjectInstance.d_object_instance_obj) + ",":U
                       + " FIRST ttObjectInstance":U
                       + " WHERE ttObjectInstance.d_object_instance_obj = ttSmartLink.d_":U + (IF plSource THEN "source_":U ELSE "target_":U) + "object_instance_obj,":U
                       + " FIRST ttObjectType":U
                       + " WHERE ttObjectType.d_object_type_obj = ttObjectInstance.d_object_type_obj":U).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().
  
  DO WHILE NOT lFinished:
    IF NOT hQuery:QUERY-OFF-END THEN
    DO:
      ASSIGN
          pcLinkedObjectName         = httObjectInstance:BUFFER-FIELD("c_smartobject_filename":U):BUFFER-VALUE
          pcLinkedObjectObj          = httObjectInstance:BUFFER-FIELD("d_smartobject_obj":U):BUFFER-VALUE
          pcLinkedObjectType         = httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE
          pcLinkedObjectInstanceName = httObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE
          lFinished            = TRUE.
      
      hQuery:GET-NEXT().
    END.
    ELSE
      lFinished = TRUE.
  END.

  DELETE OBJECT httObjectInstance.
  DELETE OBJECT httObjectType.
  DELETE OBJECT httSmartLink.
  DELETE OBJECT hQuery.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMasterValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getMasterValues Procedure 
PROCEDURE getMasterValues :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdObjectInstanceObj    AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER plRefetchMasterValues  AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cDenormalizedAttributes AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttributeLabel         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttributeValue         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentClasses          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lAttributeAvailable     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lClassAvailable         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iAttribute              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iClass                  AS INTEGER    NO-UNDO.

  DEFINE BUFFER ttObjectInstance FOR ttObjectInstance.
  DEFINE BUFFER ttAttributeValue FOR ttAttributeValue.
  DEFINE BUFFER ttUiEvent        FOR ttUiEvent.

  dCustomizationResultObj = DECIMAL({fnarg getUserProperty 'CustomizationResultObj':U}).

  FIND FIRST ttObjectInstance NO-LOCK
       WHERE ttObjectInstance.d_object_instance_obj = pdObjectInstanceObj NO-ERROR.

  IF NOT AVAILABLE ttObjectInstance THEN
    RETURN.

  FIND FIRST ttObjectType
       WHERE ttObjectType.d_object_type_obj = ttObjectInstance.d_object_type_obj.

  /* If we are to clear the master values, do so now */
  IF plRefetchMasterValues THEN
  DO:
    /* Clear the values for the class */
    FOR EACH ttClassValues
       WHERE ttClassValues.cClassCode = ttObjectType.c_object_type_code:

      DELETE ttClassValues.
    END.

    /* Clear the values for the master smartobject */
    FOR EACH ttAttributeValue
       WHERE ttAttributeValue.d_primary_smartobject_obj   = ttObjectInstance.d_smartobject_obj
         AND ttAttributeValue.d_container_smartobject_obj = 0.00
         AND ttAttributeValue.d_object_instance_obj       = 0.00
         AND ttAttributeValue.d_smartobject_obj           = ttObjectInstance.d_smartobject_obj
         AND ttAttributeValue.d_object_type_obj           = ttObjectInstance.d_object_type_obj
         AND ttAttributeValue.l_master_attribute          = TRUE:

      DELETE ttAttributeValue.
    END.

    /* Clear the events for the master smartobject */
    FOR EACH ttUiEvent
       WHERE ttUiEvent.d_primary_smartobject_obj   = ttObjectInstance.d_smartobject_obj
         AND ttUiEvent.d_container_smartobject_obj = 0.00
         AND ttUiEvent.d_object_instance_obj       = 0.00
         AND ttUiEvent.d_smartobject_obj           = ttObjectInstance.d_smartobject_obj
         AND ttUiEvent.d_object_type_obj           = ttObjectInstance.d_object_type_obj
         AND ttUiEvent.l_master_event              = TRUE:

      DELETE ttAttributeValue.
    END.
  END.

  /* Check to see if we already have the values for the master object */
  ASSIGN
      lAttributeAvailable = CAN-FIND(FIRST ttAttributeValue
                                     WHERE ttAttributeValue.d_container_smartobject_obj = 0.00
                                       AND ttAttributeValue.d_primary_smartobject_obj   = ttObjectInstance.d_smartobject_obj
                                       AND ttAttributeValue.d_object_instance_obj       = 0.00
                                       AND ttAttributeValue.d_smartobject_obj           = ttObjectInstance.d_smartobject_obj
                                       AND ttAttributeValue.d_object_type_obj           = ttObjectInstance.d_object_type_obj)
      lClassAvailable     = CAN-FIND(FIRST ttClassValues
                                     WHERE ttClassValues.cClassCode = ttObjectType.c_object_type_code).

  IF NOT (lAttributeAvailable AND lClassAvailable) THEN
  DO:
    {launch.i &PLIP     = 'ry/app/rycntbplip.p'
              &IProc    = 'getMasterAttributes'
              &PList    = "(INPUT              (IF lAttributeAvailable THEN '':U ELSE ttObjectInstance.c_smartobject_filename),
                            INPUT              (IF lClassAvailable     THEN '':U ELSE ttObjectType.c_object_type_code),
                            INPUT              dCustomizationResultObj,
                            OUTPUT       TABLE ttAttributeValue APPEND,
                            OUTPUT       TABLE ttUiEvent APPEND,
                            INPUT-OUTPUT TABLE ttClassValues)"
              &OnApp    = 'YES'
              &AutoKill = YES}
  END.

  ASSIGN
      cDenormalizedAttributes = "ResizeHorizontal,ResizeVertical,ForeignFields":U
      cParentClasses          = DYNAMIC-FUNCTION("getClassParentsFromDB":U IN gshRepositoryManager, ttObjectType.c_object_type_code).

  DO iAttribute = 1 TO NUM-ENTRIES(cDenormalizedAttributes):
    cAttributeLabel = ENTRY(iAttribute, cDenormalizedAttributes).

    /* Check if there is an attribute value on the instance */
    FIND FIRST ttAttributeValue
         WHERE ttAttributeValue.d_container_smartobject_obj <> 0.00
           AND ttAttributeValue.d_primary_smartobject_obj    = ttObjectInstance.d_container_smartobject_obj
           AND ttAttributeValue.d_object_instance_obj        = ttObjectInstance.d_object_instance_obj
           AND ttAttributeValue.d_smartobject_obj            = ttObjectInstance.d_smartobject_obj
           AND ttAttributeValue.d_object_type_obj            = ttObjectInstance.d_object_type_obj
           AND ttAttributeValue.c_attribute_label            = cAttributeLabel
           AND ttAttributeValue.c_action                    <> "D":U NO-ERROR.

    /* If we do not have a value for the instance, check if there is an attribute value on the master */
    IF NOT AVAILABLE ttAttributeValue THEN
      FIND FIRST ttAttributeValue
           WHERE ttAttributeValue.d_container_smartobject_obj = 0.00
             AND ttAttributeValue.d_primary_smartobject_obj   = ttObjectInstance.d_smartobject_obj
             AND ttAttributeValue.d_object_instance_obj       = 0.00
             AND ttAttributeValue.d_smartobject_obj           = ttObjectInstance.d_smartobject_obj
             AND ttAttributeValue.d_object_type_obj           = ttObjectInstance.d_object_type_obj
             AND ttAttributeValue.c_attribute_label           = cAttributeLabel NO-ERROR.

    IF NOT AVAILABLE ttAttributeValue THEN
    DO:
      cAttributeValue = "":U.

      Class_Blk:
      DO iClass = 1 TO NUM-ENTRIES(cParentClasses):

        FIND FIRST ttClassValues
             WHERE ttClassValues.cClassCode      = ENTRY(iClass, cParentClasses)
               AND ttClassValues.cAttributeLabel = cAttributeLabel NO-ERROR.

        IF AVAILABLE ttClassValues THEN
        DO:
          cAttributeValue = ttClassValues.cAttributeValue.

          LEAVE Class_Blk.
        END.
      END.
    END.

    CASE cAttributeLabel:
      WHEN "ResizeHorizontal":U THEN
        ttObjectInstance.l_resize_horizontal = (IF AVAILABLE ttAttributeValue THEN ttAttributeValue.l_logical_value
                                                                              ELSE cAttributeValue = "yes":U).

      WHEN "ResizeVertical":U THEN
        ttObjectInstance.l_resize_vertical = (IF AVAILABLE ttAttributeValue THEN ttAttributeValue.l_logical_value
                                                                            ELSE cAttributeValue = "yes":U).

      WHEN "ForeignFields":U THEN
        ttObjectInstance.c_foreign_fields = (IF AVAILABLE ttAttributeValue THEN ttAttributeValue.c_character_value
                                                                           ELSE cAttributeValue).
    END CASE.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTTPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTTPage Procedure 
PROCEDURE getTTPage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER piPageSequence AS INTEGER    NO-UNDO.

  DEFINE VARIABLE cGridContainerMode      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContainerMode          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPageString             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iNumPages               AS INTEGER    NO-UNDO.

  DEFINE BUFFER bttObjectInstance FOR ttObjectInstance.
  DEFINE BUFFER ttPage            FOR ttPage.

  ASSIGN    
      dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U))
      cGridContainerMode      = DYNAMIC-FUNCTION("getUserProperty":U IN ghGridObjectViewer, "ContainerMode":U)
      cContainerMode          = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE,  "ContainerMode":U).

  iNumPages = 0.

  FOR EACH ttPage
     WHERE ttPage.c_action                  <> "D":U
       AND ttPage.d_customization_result_obj = dCustomizationResultObj:
    iNumPages = iNumPages + 1.
  END.
  
  RUN checkFolderExistance IN TARGET-PROCEDURE (INPUT  iNumPages,
                                                BUFFER bttObjectInstance).

  /* In this case, the page we are trying to re-position to has been deleted */
  IF piPageSequence + 1 >= iNumPages + 1 THEN
    piPageSequence = 0.

  RUN setupFolderPages IN TARGET-PROCEDURE (INPUT piPageSequence).
  /*RUN selectPage IN TARGET-PROCEDURE (INPUT piPageSequence + 1).*/

  /* If there are changes in the object instances and we received new pages, disable the new pages */
  IF cGridContainerMode = "UPDATE":U OR
     cGridContainerMode = "ADD":U    THEN
  DO:
    ASSIGN
        gcBatchedMode = "UPDATE":U
        cPageString   = DYNAMIC-FUNCTION("getPageString":U IN ghGridObjectViewer, FALSE).

        DYNAMIC-FUNCTION("disablePagesInFolder":U IN TARGET-PROCEDURE, cPageString).
  END.
  ELSE
    IF cContainerMode <> "ADD":U THEN
    DO:
      DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U, "UPDATE":U).
      DYNAMIC-FUNCTION("evaluateActions":U IN TARGET-PROCEDURE).
    END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hideObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE hideObject Procedure 
PROCEDURE hideObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF VALID-HANDLE(ghContainerHandle) THEN
    ghContainerHandle:HIDDEN = TRUE.
  
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
  DEFINE VARIABLE cHiddenActions  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSuccess        AS LOGICAL    NO-UNDO.

  EMPTY TEMP-TABLE ttObjectInstance.
  EMPTY TEMP-TABLE ttSmartLinkType.
  EMPTY TEMP-TABLE ttSupportedLink.
  EMPTY TEMP-TABLE ttSmartObject.
  EMPTY TEMP-TABLE ttObjectType.
  EMPTY TEMP-TABLE ttSmartLink.
  EMPTY TEMP-TABLE ttClassValues.
  EMPTY TEMP-TABLE ttPage.
  
  /* Get the 'base' details needed for the container builder */
  ASSIGN
      ghGridObjectViewer = DYNAMIC-FUNCTION("linkHandles":U        IN TARGET-PROCEDURE, "gridv-Source":U)
      ghContainerViewer  = DYNAMIC-FUNCTION("linkHandles":U        IN TARGET-PROCEDURE, "containerv-Source":U)
      ghPageSource       = DYNAMIC-FUNCTION("getPageSource":U      IN TARGET-PROCEDURE)
      ghToolbar          = DYNAMIC-FUNCTION("linkHandles":U        IN TARGET-PROCEDURE, "ContainerToolbar-Source":U)
      ghContainerHandle  = DYNAMIC-FUNCTION("getContainerHandle":U IN TARGET-PROCEDURE)
      cHiddenActions     = DYNAMIC-FUNCTION("getHiddenActions":U   IN ghToolbar).

  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "fetchContainerData":U  IN TARGET-PROCEDURE.
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "changeFolderPage":U    IN TARGET-PROCEDURE.

  {launch.i &PLIP     = 'ry/app/rycntbplip.p'
            &IProc    = 'getBasicDetails'
            &PList    = "(OUTPUT TABLE ttSmartLinkType,
                          OUTPUT TABLE ttSupportedLink,
                          OUTPUT TABLE ttObjectType)"
            &OnApp    = 'YES'
            &AutoKill = YES}

  DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U, "0":U).
  DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ttSmartLinkType":U, STRING(TEMP-TABLE ttSmartLinkType:DEFAULT-BUFFER-HANDLE)).
  DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ttSupportedLink":U, STRING(TEMP-TABLE ttSupportedLink:DEFAULT-BUFFER-HANDLE)).
  DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ttObjectType":U,    STRING(TEMP-TABLE ttObjectType:DEFAULT-BUFFER-HANDLE)).
  DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ttAttributeValue":U, STRING(TEMP-TABLE ttAttributeValue:DEFAULT-BUFFER-HANDLE)).
  
  /* Launch the PropertySheet procedure library */  
  IF NOT VALID-HANDLE(ghProcLib) THEN
  DO:
    /* See if the Property Sheet procedure library is already running */
    ghProcLib = SESSION:FIRST-PROCEDURE.
    DO WHILE VALID-HANDLE(ghProcLib) AND ghProcLib:FILE-NAME NE "ry/prc/ryvobplipp.p":U:
      ghProcLib = ghProcLib:NEXT-SIBLING.
    END.

    /* If the procedure library is not running, start it persistantly */
    IF NOT VALID-HANDLE(ghProcLib) THEN
      RUN ry/prc/ryvobplipp.p PERSISTENT SET ghProcLib NO-ERROR.    
  END.
  
  ASSIGN
      ghDesignManager = {fnarg getManagerHandle 'RepositoryDesignManager':U}
      gcFolderClasses = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "SmartFolder":U)
      gcRunAttribute  = DYNAMIC-FUNCTION("getRunAttribute":U IN TARGET-PROCEDURE)
      gcTitle         = ghContainerHandle:TITLE
      glAppBuilder    = FALSE
      glEditMaster    = FALSE.

  IF LOOKUP("AppBuilder":U, gcRunAttribute, CHR(3)) <> 0 THEN
  DO:
    ASSIGN
        gcProductModuleCode = ENTRY(2, gcRunAttribute, CHR(3)) /* If we are running from the AppBuilder, the product module- and object type codes will be specified */
        gcObjectTypeCode    = ENTRY(3, gcRunAttribute, CHR(3))
        glAppBuilder        = TRUE
        glEditMaster        = LOOKUP("EditMaster":U, gcRunAttribute, CHR(3)) <> 0
        cHiddenActions      = cHiddenActions + (IF cHiddenActions = "":U THEN "":U ELSE ",":U)
                            + "New,cbCancel,cbCopy,cbDelete,cbFind,nodeMaintenance,cbSaveAs".

    DYNAMIC-FUNCTION("setUserProperty":U  IN TARGET-PROCEDURE, "AppBuilder":U, "yes":U).
    DYNAMIC-FUNCTION("sethiddenActions":U IN ghToolbar, cHiddenActions).
  END.
  ELSE DO:
    cHiddenActions = cHiddenActions + (IF cHiddenActions = "":U THEN "":U ELSE ",":U)
                   + "nodeMaintenance,cbSaveAs".
    DYNAMIC-FUNCTION("sethiddenActions":U IN ghToolbar, cHiddenActions).
  END.

  RUN processProfileData IN TARGET-PROCEDURE (INPUT FALSE).

  {fnarg lockWindow TRUE}.

  RUN SUPER.

  IF {fn getTabVisualization ghPageSource} <> "TABS":U THEN
    RUN resizeWindow IN TARGET-PROCEDURE.
  
  IF glAppBuilder = FALSE THEN
  DO:
    IF gcDefaultMode = "New":U THEN
      RUN addRecord IN TARGET-PROCEDURE.
    ELSE
      RUN findRecord IN TARGET-PROCEDURE.
  END.
  ELSE
    RUN enableViewerObjects IN ghContainerViewer (INPUT FALSE).

  {fnarg lockWindow FALSE}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killPlip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip Procedure 
PROCEDURE killPlip :
/*------------------------------------------------------------------------------
  Purpose:     entry point to instantly kill the plip if it should get lost in memory
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipkill.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-launchFFMapper) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE launchFFMapper Procedure 
PROCEDURE launchFFMapper :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hHandle           AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cProcedureType    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTargets          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hTarget           AS HANDLE    NO-UNDO.
  DEFINE VARIABLE i                 AS INTEGER   NO-UNDO. 
  DEFINE VARIABLE cObjectName       AS CHARACTER NO-UNDO.
    
  {get ContainerHandle hHandle}.

  IF NOT VALID-HANDLE(ghFFMapper) THEN
    RUN launchContainer IN gshSessionManager (INPUT  "rycntbffmw":U ,   /* pcObjectFileName       */
                                              INPUT  "":U,              /* pcPhysicalName         */
                                              INPUT  "":U,              /* pcLogicalName          */
                                              INPUT  FALSE,             /* plOnceOnly             */
                                              INPUT  "":U,              /* pcInstanceAttributes   */
                                              INPUT  "":U,              /* pcChildDataKey         */
                                              INPUT  "":U,              /* pcRunAttribute         */
                                              INPUT  "":U,              /* container mode         */
                                              INPUT  hHandle,           /* phParentWindow         */
                                              INPUT  TARGET-PROCEDURE,  /* phParentProcedure      */
                                              INPUT  TARGET-PROCEDURE,  /* phObjectProcedure      */
                                              OUTPUT ghFFMapper,        /* phProcedureHandle      */
                                              OUTPUT cProcedureType).   /* pcProcedureType        */
  ELSE DO:
    /* Get the Viewer object so that the resize can be performed */
    cTargets = DYNAMIC-FUNCTION('linkHandles':U IN ghFFMapper, 'Container-Target':U) NO-ERROR.
    DO i = 1 to NUM-ENTRIES(cTargets):
        hTarget = WIDGET-HANDLE(ENTRY(i, cTargets)).
        {get ObjectName cObjectName hTarget} .
        IF cObjectName = "rycntbffmv":U THEN
           LEAVE.
        ELSE
           hTarget = ?.
    END.
    IF VALID-HANDLE(hTarget) THEN
    DO:       
       {get ContainerHandle hHandle hTarget}.
       RUN resizeObject in hTarget (hHandle:HEIGHT, hHandle:WIDTH).
    END.

    RUN viewObject IN ghFFMapper.

  END.
   
    
  /* This will check to see if any child windows are open and visible to set the corresponding userProperty for the prompt of the 'child windows open' */
  {fn checkChildWindows}.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-launchLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE launchLinks Procedure 
PROCEDURE launchLinks :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER plLaunchMaintenance  AS LOGICAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdSmartLinkObj       AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE hHandle           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cProcedureType    AS CHARACTER  NO-UNDO.
  
  IF plLaunchMaintenance = TRUE THEN
  DO:
    IF VALID-HANDLE(ghLinkMaintenance) THEN
      RUN viewObject IN ghLinkMaintenance.
    ELSE
    DO:
      {get ContainerHandle hHandle TARGET-PROCEDURE}.

      RUN launchContainer IN gshSessionManager (INPUT  "cntainrliw":U ,   /* pcObjectFileName       */
                                                INPUT  "":U,              /* pcPhysicalName         */
                                                INPUT  "":U,              /* pcLogicalName          */
                                                INPUT  FALSE,             /* plOnceOnly             */
                                                INPUT  "":U,              /* pcInstanceAttributes   */
                                                INPUT  "":U,              /* pcChildDataKey         */
                                                INPUT  "":U,              /* pcRunAttribute         */
                                                INPUT  "":U,              /* container mode         */
                                                INPUT  hHandle,           /* phParentWindow         */
                                                INPUT  TARGET-PROCEDURE,  /* phParentProcedure      */
                                                INPUT  TARGET-PROCEDURE,  /* phObjectProcedure      */
                                                OUTPUT ghLinkMaintenance, /* phProcedureHandle      */
                                                OUTPUT cProcedureType).   /* pcProcedureType        */

      RUN addToolbarLinks IN ghLinkMaintenance.  
    END.
  END.

  IF NOT VALID-HANDLE(ghLinkMaintenance) THEN
    RETURN.

  RUN refreshData IN ghLinkMaintenance (INPUT "newData", pdSmartLinkObj).
/*
  DYNAMIC-FUNCTION("evaluateActions":U IN ghLinkMaintenance).
*/
  /* This will check to see if any child windows are open and visible to set the corresponding userProperty for the prompt of the 'child windows open' */
  {fn checkChildWindows}.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-launchLocator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE launchLocator Procedure 
PROCEDURE launchLocator :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phOwner        AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER phPublishFrom  AS HANDLE     NO-UNDO.

  DEFINE VARIABLE hHandle           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cProcedureType    AS CHARACTER  NO-UNDO.
  
  {get ContainerHandle hHandle}.        

  IF NOT VALID-HANDLE(ghObjectLocator) THEN
    RUN launchContainer IN gshSessionManager (INPUT  "rycboblocw":U ,   /* pcObjectFileName       */
                                              INPUT  "":U,              /* pcPhysicalName         */
                                              INPUT  "":U,              /* pcLogicalName          */
                                              INPUT  FALSE,             /* plOnceOnly             */
                                              INPUT  "":U,              /* pcInstanceAttributes   */
                                              INPUT  "":U,              /* pcChildDataKey         */
                                              INPUT  "":U,              /* pcRunAttribute         */
                                              INPUT  "":U,              /* container mode         */
                                              INPUT  hHandle,           /* phParentWindow         */
                                              INPUT  TARGET-PROCEDURE,  /* phParentProcedure      */
                                              INPUT  TARGET-PROCEDURE,  /* phObjectProcedure      */
                                              OUTPUT ghObjectLocator,   /* phProcedureHandle      */
                                              OUTPUT cProcedureType).   /* pcProcedureType        */
  ELSE
    RUN viewObject IN ghObjectLocator.

  DYNAMIC-FUNCTION("setUserProperty":U IN ghObjectLocator, "PublishFrom":U, STRING(phPublishFrom)).
  DYNAMIC-FUNCTION("setUserProperty":U IN ghObjectLocator, "Owner":U,       STRING(phOwner)).
  
  /* This will check to see if any child windows are open and visible to set the corresponding userProperty for the prompt of the 'child windows open' */
  {fn checkChildWindows}.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-launchMenuStruct) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE launchMenuStruct Procedure 
PROCEDURE launchMenuStruct :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hHandle           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cProcedureType    AS CHARACTER  NO-UNDO.

  {get ContainerHandle hHandle TARGET-PROCEDURE}.        

  IF NOT VALID-HANDLE(ghMenuStruct) THEN
    RUN launchContainer IN gshSessionManager (INPUT  "ryobjmnusw":U ,   /* pcObjectFileName       */
                                              INPUT  "":U,              /* pcPhysicalName         */
                                              INPUT  "":U,              /* pcLogicalName          */
                                              INPUT  FALSE,             /* plOnceOnly             */
                                              INPUT  "":U,              /* pcInstanceAttributes   */
                                              INPUT  "":U,              /* pcChildDataKey         */
                                              INPUT  "":U,              /* pcRunAttribute         */
                                              INPUT  "":U,              /* container mode         */
                                              INPUT  hHandle,           /* phParentWindow         */
                                              INPUT  TARGET-PROCEDURE,  /* phParentProcedure      */
                                              INPUT  TARGET-PROCEDURE,  /* phObjectProcedure      */
                                              OUTPUT ghMenuStruct,      /* phProcedureHandle      */
                                              OUTPUT cProcedureType).   /* pcProcedureType        */
  ELSE
    RUN viewObject IN ghMenuStruct.

  /* This publish is made with no action. The menu structure maintenance does not require that
     and doing it this will way will not cause all the other programs to refresh as well */
  PUBLISH "refreshData":U FROM TARGET-PROCEDURE (INPUT "":U, INPUT 0.00).

  /* This will check to see if any child windows are open and visible to set the corresponding userProperty for the prompt of the 'child windows open' */
  {fn checkChildWindows}.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-launchPages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE launchPages Procedure 
PROCEDURE launchPages :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER plLaunchMaintenance  AS LOGICAL    NO-UNDO.
  DEFINE INPUT PARAMETER piPageSequence       AS INTEGER    NO-UNDO.
  
  DEFINE VARIABLE hHandle           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cProcedureType    AS CHARACTER  NO-UNDO.
  
  IF plLaunchMaintenance = TRUE THEN
  DO:
    IF VALID-HANDLE(ghPageMaintenance) THEN
      RUN viewObject IN ghPageMaintenance.
    ELSE
    DO:
      {get ContainerHandle hHandle TARGET-PROCEDURE}.        

      RUN launchContainer IN gshSessionManager (INPUT  "cntainrpaw":U ,   /* pcObjectFileName       */
                                                INPUT  "":U,              /* pcPhysicalName         */
                                                INPUT  "":U,              /* pcLogicalName          */
                                                INPUT  FALSE,             /* plOnceOnly             */
                                                INPUT  "":U,              /* pcInstanceAttributes   */
                                                INPUT  "":U,              /* pcChildDataKey         */
                                                INPUT  "":U,              /* pcRunAttribute         */
                                                INPUT  "":U,              /* container mode         */
                                                INPUT  hHandle,           /* phParentWindow         */
                                                INPUT  TARGET-PROCEDURE,  /* phParentProcedure      */
                                                INPUT  TARGET-PROCEDURE,  /* phObjectProcedure      */
                                                OUTPUT ghPageMaintenance, /* phProcedureHandle      */
                                                OUTPUT cProcedureType).   /* pcProcedureType        */
    END.
  END.

  IF NOT VALID-HANDLE(ghPageMaintenance) THEN
    RETURN.

  IF piPageSequence = 0 THEN
    piPageSequence = DYNAMIC-FUNCTION("getPageSequence":U IN TARGET-PROCEDURE, ?).

  RUN refreshData IN ghPageMaintenance (INPUT "newData", DECIMAL(piPageSequence)).

  DYNAMIC-FUNCTION("evaluateActions":U    IN ghPageMaintenance, "VIEW":U).
  DYNAMIC-FUNCTION("evaluateMoveUpDown":U IN ghPageMaintenance).

  /* This will check to see if any child windows are open and visible to set the corresponding userProperty for the prompt of the 'child windows open' */
  {fn checkChildWindows}.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-launchPreferences) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE launchPreferences Procedure 
PROCEDURE launchPreferences :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hHandle           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cProcedureType    AS CHARACTER  NO-UNDO.
  
  {get ContainerHandle hHandle TARGET-PROCEDURE}.        

  IF NOT VALID-HANDLE(ghPreferences) THEN
    RUN launchContainer IN gshSessionManager (INPUT  "rycntprefw":U ,   /* pcObjectFileName       */
                                              INPUT  "":U,              /* pcPhysicalName         */
                                              INPUT  "":U,              /* pcLogicalName          */
                                              INPUT  FALSE,             /* plOnceOnly             */
                                              INPUT  "":U,              /* pcInstanceAttributes   */
                                              INPUT  "":U,              /* pcChildDataKey         */
                                              INPUT  "actAsDialog":U,   /* pcRunAttribute         */
                                              INPUT  "":U,              /* container mode         */
                                              INPUT  hHandle,           /* phParentWindow         */
                                              INPUT  TARGET-PROCEDURE,  /* phParentProcedure      */
                                              INPUT  TARGET-PROCEDURE,  /* phObjectProcedure      */
                                              OUTPUT ghPreferences,     /* phProcedureHandle      */
                                              OUTPUT cProcedureType).   /* pcProcedureType        */
  ELSE
    RUN viewObject IN ghPreferences.
    
  /* This will check to see if any child windows are open and visible to set the corresponding userProperty for the prompt of the 'child windows open' */
  {fn checkChildWindows}.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-launchProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE launchProperties Procedure 
PROCEDURE launchProperties :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCustomizationResultCode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj   AS DECIMAL    NO-UNDO.
  
  ASSIGN
      cCustomizationResultCode = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultCode":U)
      dCustomizationResultObj  = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U)).

  FIND FIRST ttSmartObject
       WHERE ttSmartObject.d_smartobject_obj         <> 0.00
         AND ttSmartObject.d_customization_result_obj = dCustomizationResultObj.

  {fnarg lockWindow TRUE}.
  
  /* Launch the Property Sheet */
  RUN launchPropertyWindow IN ghProcLib.

  RUN displayProperties IN ghProcLib (TARGET-PROCEDURE, ttSmartObject.d_smartobject_obj, ttSmartObject.d_smartobject_obj, cCustomizationResultCode, TRUE, 0).

  SUBSCRIBE PROCEDURE TARGET-PROCEDURE   TO "PropertyChangedAttribute":U IN ghProcLib.
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE   TO "PropertyChangedEvent":U     IN ghProcLib.
  SUBSCRIBE PROCEDURE ghGridObjectViewer TO "PropertyChangedObject":U    IN ghProcLib.

  {fnarg lockWindow FALSE}.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-launchSBODLProc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE launchSBODLProc Procedure 
PROCEDURE launchSBODLProc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cProcedureType  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hHandle         AS HANDLE     NO-UNDO.

  IF VALID-HANDLE(ghSBODLProcedure) THEN
    RUN viewObject IN ghSBODLProcedure.
  ELSE
  DO:
    {get ContainerHandle hHandle TARGET-PROCEDURE}.

    RUN launchContainer IN gshSessionManager (INPUT  "rycbsbodlw":U ,   /* pcObjectFileName       */
                                              INPUT  "":U,              /* pcPhysicalName         */
                                              INPUT  "":U,              /* pcLogicalName          */
                                              INPUT  FALSE,             /* plOnceOnly             */
                                              INPUT  "":U,              /* pcInstanceAttributes   */
                                              INPUT  "":U,              /* pcChildDataKey         */
                                              INPUT  "":U,              /* pcRunAttribute         */
                                              INPUT  "":U,              /* container mode         */
                                              INPUT  hHandle,           /* phParentWindow         */
                                              INPUT  TARGET-PROCEDURE,  /* phParentProcedure      */
                                              INPUT  TARGET-PROCEDURE,  /* phObjectProcedure      */
                                              OUTPUT ghSBODLProcedure,  /* phProcedureHandle      */
                                              OUTPUT cProcedureType).   /* pcProcedureType        */
  END.

  IF NOT VALID-HANDLE(ghSBODLProcedure) THEN
    RETURN.

  /* This will check to see if any child windows are open and visible to set the corresponding userProperty for the prompt of the 'child windows open' */
  {fn checkChildWindows}.

  PUBLISH "refreshData":U FROM ghSBODLProcedure (INPUT "newData", INPUT 0.00).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-launchSequencing) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE launchSequencing Procedure 
PROCEDURE launchSequencing :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hHandle           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cProcedureType    AS CHARACTER  NO-UNDO.

  {get ContainerHandle hHandle TARGET-PROCEDURE}.        

  IF NOT VALID-HANDLE(ghSequencing) THEN
    RUN launchContainer IN gshSessionManager (INPUT  "rycbinitow":U ,   /* pcObjectFileName       */
                                              INPUT  "":U,              /* pcPhysicalName         */
                                              INPUT  "":U,              /* pcLogicalName          */
                                              INPUT  FALSE,             /* plOnceOnly             */
                                              INPUT  "":U,              /* pcInstanceAttributes   */
                                              INPUT  "":U,              /* pcChildDataKey         */
                                              INPUT  "":U,              /* pcRunAttribute         */
                                              INPUT  "":U,              /* container mode         */
                                              INPUT  hHandle,           /* phParentWindow         */
                                              INPUT  TARGET-PROCEDURE,  /* phParentProcedure      */
                                              INPUT  TARGET-PROCEDURE,  /* phObjectProcedure      */
                                              OUTPUT ghSequencing,      /* phProcedureHandle      */
                                              OUTPUT cProcedureType).   /* pcProcedureType        */
  ELSE
    RUN viewObject IN ghSequencing.

  PUBLISH "refreshData":U FROM ghSequencing (INPUT "newData", INPUT 0.00).

  /* This will check to see if any child windows are open and visible to set the corresponding userProperty for the prompt of the 'child windows open' */
  {fn checkChildWindows}.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadContainer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadContainer Procedure 
PROCEDURE loadContainer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcObjectFilename AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cContainerMode  AS CHARACTER  NO-UNDO.

  {fnarg lockWindow TRUE}.

  IF pcObjectFilename = "":U OR
     pcObjectFilename = ?    THEN
    cContainerMode = "ADD":U.
  ELSE
    cContainerMode = "MODIFY":U.

  DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U, "0":U).
  DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U,          cContainerMode).

  RUN fetchContainerData IN TARGET-PROCEDURE (INPUT pcObjectFilename).

  {fnarg lockWindow FALSE}.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-myExitObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE myExitObject Procedure 
PROCEDURE myExitObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  ASSIGN
      glDoPrompt   = FALSE
      glAppBuilder = FALSE.

  {fnarg setUserProperty "'CloseWindow', 'yes'"}.
 
  RUN destroyObject IN TARGET-PROCEDURE.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-objectDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription Procedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.

ASSIGN cDescription = "Dynamics Template PLIP".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-oldPropertySheets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE oldPropertySheets Procedure 
PROCEDURE oldPropertySheets :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdObjectInstanceObj    AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE cLinkedObjectName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStatusDefault          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkedObjectType       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttributeLabels        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttributeValues        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButtonPressed          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataClasses            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cLinkedObjectId         AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cLinkedObjectInstanceName AS CHARACTER  NO-UNDO.

  DEFINE BUFFER ttObjectInstance FOR ttObjectInstance.
  DEFINE BUFFER ttSmartObject    FOR ttSmartObject.
  DEFINE BUFFER ttObjectType     FOR ttObjectType.

  ASSIGN
      dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U))
      cStatusDefault          = DYNAMIC-FUNCTION("getStatusDefault":U IN TARGET-PROCEDURE).

  IF pdObjectInstanceObj = 0 THEN
  DO:
    FIND FIRST ttSmartObject
         WHERE ttSmartObject.d_customization_result_obj = dCustomizationResultObj
           AND ttSmartObject.d_smartobject_obj         <> 0.00.

    FIND FIRST ttObjectType
         WHERE ttObjectType.d_object_type_obj = ttSmartObject.d_object_type_obj.
  END.
  ELSE
  DO:
    FIND FIRST ttObjectInstance
         WHERE ttObjectInstance.d_object_instance_obj = pdObjectInstanceObj.

    FIND FIRST ttObjectType
         WHERE ttObjectType.d_object_type_obj = ttObjectInstance.d_object_type_obj.
  END.

  IF DYNAMIC-FUNCTION("viewStaticPropsheet":U IN TARGET-PROCEDURE, ttObjectType.c_object_type_code) THEN
  DO:
    ASSIGN cLinkedObjectName = "":U
           cLinkedObjectId   = 0
           cLinkedObjectType = "":U.

    RUN getLinkDetails IN TARGET-PROCEDURE (INPUT  ttObjectInstance.c_instance_name,
                                            INPUT  "Data":U,
                                            INPUT  TRUE,
                                            OUTPUT cLinkedObjectName,
                                            OUTPUT cLinkedObjectId,
                                            OUTPUT cLinkedObjectType,
                                            OUTPUT cLinkedObjectInstanceName).

    IF cLinkedObjectName = "":U THEN
      RUN getLinkDetails IN TARGET-PROCEDURE (INPUT  ttObjectInstance.c_instance_name,
                                              INPUT  "Navigation":U,
                                              INPUT  FALSE,
                                              OUTPUT cLinkedObjectName,
                                              OUTPUT cLinkedObjectId,
                                              OUTPUT cLinkedObjectType,
                                              OUTPUT cLinkedObjectInstanceName).

    ASSIGN
        cDataClasses      = DYNAMIC-FUNCTION("getDataSourceClasses":U IN ghDesignManager)
        cLinkedObjectName = (IF LOOKUP(cLinkedObjectType, cDataClasses) <> 0 THEN cLinkedObjectName ELSE "":U).    

    RUN af/cod2/afpropwin.p (INPUT  TARGET-PROCEDURE,
                             INPUT  (IF pdObjectInstanceObj = 0 THEN ttSmartObject.c_object_filename ELSE ttObjectInstance.c_smartobject_filename),
                             INPUT  (IF pdObjectInstanceObj = 0 THEN ttSmartObject.c_object_filename ELSE ttObjectInstance.c_instance_name),
                             INPUT  cLinkedObjectName,    /* SDO Name */
                             INPUT  TRUE,                /* return only changes? */
                             INPUT  cLinkedObjectInstanceName,
                             OUTPUT cAttributeLabels,
                             OUTPUT cAttributeValues) NO-ERROR.

    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
    DO:
      RUN showMessages IN gshSessionManager (INPUT  RETURN-VALUE,     /* message to display */
                                             INPUT  "ERR",            /* error type         */
                                             INPUT  "&OK",            /* button list        */
                                             INPUT  "&OK",            /* default button     */ 
                                             INPUT  "&OK",            /* cancel button      */
                                             INPUT  "",               /* error window title */
                                             INPUT  YES,              /* display if empty   */ 
                                             INPUT  TARGET-PROCEDURE, /* container handle   */ 
                                             OUTPUT cButtonPressed).
      RETURN ERROR.
    END.    /* error */

    IF cAttributeLabels <> "":U AND
       cAttributeLabels <> ?    THEN
    DO:
      SESSION:SET-WAIT-STATE("GENERAL":U).
      
      DYNAMIC-FUNCTION("setStatusDefault":U IN TARGET-PROCEDURE, "Processing attributes...":U).

      RUN setAttributeListValues IN TARGET-PROCEDURE (INPUT TARGET-PROCEDURE,
                                                      INPUT (IF pdObjectInstanceObj = 0 THEN "":U ELSE ttObjectInstance.c_instance_name),
                                                      INPUT cAttributeLabels,
                                                      INPUT cAttributeValues).

      DYNAMIC-FUNCTION("setStatusDefault":U IN TARGET-PROCEDURE, cStatusDefault).

      SESSION:SET-WAIT-STATE("":U).
    END.
  END.
  ELSE
    RUN setProperties IN ghGridObjectViewer.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipSetup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup Procedure 
PROCEDURE plipSetup :
/*------------------------------------------------------------------------------
  Purpose:    Run by main-block of PLIP at startup of PLIP
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipsetu.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run just before the calling program 
               terminates
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processProfileData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processProfileData Procedure 
PROCEDURE processProfileData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER plRefreshGridViewer  AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE cTabVisualization AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPrefs            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTabsPerRow       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEntry            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE rRowId            AS ROWID      NO-UNDO.

  iTabsPerRow = giTabsPerRow.

  IF VALID-HANDLE(gshProfileManager) THEN
    RUN getProfileData IN gshProfileManager (INPUT "Window":U,          /* Profile type code     */
                                             INPUT "CBuilder":U,        /* Profile code          */
                                             INPUT "MainPreferences":U, /* Profile data key      */
                                             INPUT "NO":U,              /* Get next record flag  */
                                             INPUT-OUTPUT rRowid,       /* Rowid of profile data */
                                             OUTPUT cPrefs).            /* Found profile data. */

  /* --- Preference lookup ------------------------- */ /* --- Preference value assignment ------------------------------------------------------- */
  iEntry = LOOKUP("TabVisualization":U, cPrefs, "|":U). IF iEntry <> 0 THEN gcTabVisualization =         ENTRY(iEntry + 1, cPrefs, "|":U).
  iEntry = LOOKUP("AddPageNumber":U,    cPrefs, "|":U). IF iEntry <> 0 THEN glAddPageNumber    =        (ENTRY(iEntry + 1, cPrefs, "|":U) = "yes":U).
  iEntry = LOOKUP("RepositionPT":U,     cPrefs, "|":U). IF iEntry <> 0 THEN glRepositionPT     =        (ENTRY(iEntry + 1, cPrefs, "|":U) = "yes":U).
  iEntry = LOOKUP("DeleteFolder":U,     cPrefs, "|":U). IF iEntry <> 0 THEN glDeleteFolder     =        (ENTRY(iEntry + 1, cPrefs, "|":U) = "yes":U).
  iEntry = LOOKUP("HideSubtools":U,     cPrefs, "|":U). IF iEntry <> 0 THEN glHideSubtools     =        (ENTRY(iEntry + 1, cPrefs, "|":U) = "yes":U).
  iEntry = LOOKUP("IncludeTitle":U,     cPrefs, "|":U). IF iEntry <> 0 THEN glIncludeTitle     =        (ENTRY(iEntry + 1, cPrefs, "|":U) = "yes":U).
  iEntry = LOOKUP("ConfirmSave":U,      cPrefs, "|":U). IF iEntry <> 0 THEN glConfirmSave      =        (ENTRY(iEntry + 1, cPrefs, "|":U) = "yes":U).
  iEntry = LOOKUP("DefaultMode":U,      cPrefs, "|":U). IF iEntry <> 0 THEN gcDefaultMode      =         ENTRY(iEntry + 1, cPrefs, "|":U).
  iEntry = LOOKUP("TabsPerRow":U,       cPrefs, "|":U). IF iEntry <> 0 THEN giTabsPerRow       = INTEGER(ENTRY(iEntry + 1, cPrefs, "|":U)).

  {fnarg setUserProperty "'ProfileData':U, cPrefs"}.

  cTabVisualization = gcTabVisualization.

  IF cTabVisualization = "FrameWork":U THEN
  DO:
    /* Determine the FrameWork default */
    DEFINE VARIABLE hAttributeBuffer  AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hClassBuffer      AS HANDLE     NO-UNDO.
    
    /* Fetch the repository class*/
    hClassBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN gshRepositoryManager, "SmartFolder":U).
  
    IF VALID-HANDLE(hClassBuffer) THEN
      hAttributeBuffer = hClassBuffer:BUFFER-FIELD("classBufferHandle":U):BUFFER-VALUE.   
  
    IF VALID-HANDLE(hAttributeBuffer) THEN
    DO:
      hAttributeBuffer:BUFFER-CREATE().
  
      cTabVisualization = hAttributeBuffer:BUFFER-FIELD("TabVisualization":U):BUFFER-VALUE.
  
      hAttributeBuffer:BUFFER-DELETE().
    END.
  END.
  
  /* Set the TabVisualization */
  {set TabVisualization cTabVisualization ghPageSource}.

  {set TabsPerRow giTabsPerRow ghPageSource}.
  
  IF iTabsPerRow <> giTabsPerRow AND plRefreshGridViewer THEN
    DYNAMIC-FUNCTION("setFolderLabels":U IN ghPageSource, {fn getFolderLabels ghPageSource} + ".":U). /* Give a differnt folder label property so that setupFolderPages will re-initialize */

  IF plRefreshGridViewer THEN
  DO:
    RUN processProfileData IN ghGridObjectViewer (INPUT TRUE).

    RUN setupFolderPages IN TARGET-PROCEDURE (INPUT {fn getCurrentPage}).
  END.

/*  
  IF {fn getTabVisualization ghPageSource} <> cTabVisualization THEN
  DO:*/
       /*
    {fnarg lockWindow 'TRUE'}.

    IF {fn getObjectInitialized ghPageSource} THEN
      RUN initializeObject IN ghPageSource.

    {fnarg lockWindow 'FALSE'}.
  END.
         */
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-propertyChangedAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE propertyChangedAttribute Procedure 
PROCEDURE propertyChangedAttribute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phHandle         AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER pcContainer      AS CHARACTER  NO-UNDO. /* Object number */
  DEFINE INPUT PARAMETER pcObject         AS CHARACTER  NO-UNDO. /* Object number */
  DEFINE INPUT PARAMETER pcResultCode     AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcAttributeLabel AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcAttributeValue AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcDataType       AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER plOverride       AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cContainerMode            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldList                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dContainerSmartObjectObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dObjectInstanceObj        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dSmartObjectObj           AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dObjectTypeObj            AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dResultCodeObj            AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lContainerProperty        AS LOGICAL    NO-UNDO.

  DEFINE BUFFER bttAttributeValue FOR ttAttributeValue.
  DEFINE BUFFER  ttAttributeValue FOR ttAttributeValue.
  DEFINE BUFFER  ttObjectInstance FOR ttObjectInstance.
  DEFINE BUFFER  ttSmartObject    FOR ttSmartObject.

  ASSIGN
      dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U))
      cContainerMode          = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U).

  FIND FIRST ttSmartObject
       WHERE ttSmartObject.d_customization_result_obj = dCustomizationResultObj
         AND ttSmartObject.d_smartobject_obj          = DECIMAL(pcContainer) NO-ERROR.

  IF NOT AVAILABLE ttSmartObject THEN
    RETURN.

  FIND FIRST ttObjectInstance
       WHERE ttObjectInstance.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj
         AND ttObjectInstance.d_object_instance_obj       = DECIMAL(pcObject) NO-ERROR.

  IF NOT AVAILABLE ttObjectInstance THEN
    IF pcContainer = pcObject THEN
      lContainerProperty = TRUE.
    ELSE
      RETURN.

  IF pcResultCode <> "":U THEN
  DO:
    FIND FIRST ttAttributeValue
         WHERE ttAttributeValue.c_customization_result_code = pcResultCode NO-ERROR.
    
    IF AVAILABLE ttAttributeValue THEN
      dResultCodeObj = ttAttributeValue.d_customization_result_obj.
    ELSE
    DO:
      cQuery = "FOR EACH ryc_customization_result NO-LOCK":U
             + "   WHERE ryc_customization_result.customization_result_code = '":U + TRIM(pcResultCode) + "'":U.
  
      RUN getRecordDetail IN gshGenManager (INPUT  cQuery,
                                            OUTPUT cFieldList) NO-ERROR.
  
      IF cFieldList <> "":U THEN
        dResultCodeObj = DECIMAL(ENTRY(LOOKUP("ryc_customization_result.customization_result_obj":U, cFieldList, CHR(3)) + 1, cFieldList, CHR(3))).
    END.
  END.

  IF dCustomizationResultObj <> dResultCodeObj THEN
  DO:
    MESSAGE "This won't save. Only update values pertaining to the result code of the container you are modifying.".
  
    RETURN.
  END.

  IF lContainerProperty THEN
    ASSIGN
        dContainerSmartObjectObj = 0.00
        dObjectInstanceObj       = 0.00
        dSmartObjectObj          = ttSmartObject.d_smartobject_obj
        dObjectTypeObj           = ttSmartObject.d_object_type_obj.
  ELSE
    ASSIGN
        dContainerSmartObjectObj = ttSmartObject.d_smartobject_obj
        dObjectInstanceObj       = ttObjectInstance.d_object_instance_obj
        dSmartObjectObj          = ttObjectInstance.d_smartobject_obj
        dObjectTypeObj           = ttObjectInstance.d_object_type_obj.

  FIND FIRST ttAttributeValue NO-LOCK
       WHERE ttAttributeValue.d_container_smartobject_obj = dContainerSmartObjectObj
         AND ttAttributeValue.d_customization_result_obj  = dCustomizationResultObj
         AND ttAttributeValue.d_primary_smartobject_obj   = ttSmartObject.d_smartobject_obj
         AND ttAttributeValue.d_object_instance_obj       = dObjectInstanceObj
         AND ttAttributeValue.d_smartobject_obj           = dSmartObjectObj
         AND ttAttributeValue.d_object_type_obj           = dObjectTypeObj
         AND ttAttributeValue.c_attribute_label           = pcAttributeLabel
         AND ttAttributeValue.l_master_attribute          = FALSE NO-ERROR.

  IF NOT AVAILABLE ttAttributeValue THEN
  DO:
    CREATE ttAttributeValue.
    ASSIGN ttAttributeValue.d_attribute_value_obj       = DYNAMIC-FUNCTION("getTemporaryObj":U IN TARGET-PROCEDURE)
           ttAttributeValue.d_container_smartobject_obj = dContainerSmartObjectObj
           ttAttributeValue.d_primary_smartobject_obj   = ttSmartobject.d_smartobject_obj
           ttAttributeValue.d_object_instance_obj       = dObjectInstanceObj
           ttAttributeValue.d_smartobject_obj           = dSmartObjectObj
           ttAttributeValue.d_object_type_obj           = dObjectTypeObj
           ttAttributeValue.c_attribute_label           = pcAttributeLabel
           ttAttributeValue.c_customization_result_code = pcResultCode
           ttAttributeValue.d_customization_result_obj  = dCustomizationResultObj
           ttAttributeValue.c_action                    = "A":U.

    FIND FIRST bttAttributeValue NO-LOCK
         WHERE bttAttributeValue.c_attribute_label      = pcAttributeLabel
           AND bttAttributeValue.d_attribute_value_obj <> ttAttributeValue.d_attribute_value_obj NO-ERROR.

    IF AVAILABLE bttAttributeValue THEN
      ttAttributeValue.i_data_type = bttAttributeValue.i_data_type.
    ELSE
    DO:
      cQuery = "FOR EACH ryc_attribute NO-LOCK":U
             + "   WHERE ryc_attribute.attribute_label = '":U + TRIM(pcAttributeLabel) + "'":U.

      RUN getRecordDetail IN gshGenManager (INPUT  cQuery,
                                            OUTPUT cFieldList) NO-ERROR.

      IF cFieldList <> "":U THEN
        ttAttributeValue.i_data_type = INTEGER(ENTRY(LOOKUP("ryc_attribute.data_type":U, cFieldList, CHR(3)) + 1, cFieldList, CHR(3))).
    END.
  END.
  ELSE
  DO:
    IF plOverride = FALSE THEN
      ttAttributeValue.c_action = "D":U.
    ELSE
      ttAttributeValue.c_action = IF ttAttributeValue.c_action = "":U THEN "M":U ELSE ttAttributeValue.c_action.
  END.

  CASE ttAttributeValue.i_data_type:
    WHEN {&DECIMAL-DATA-TYPE}   THEN ttAttributeValue.d_decimal_value   = DECIMAL(pcAttributeValue) NO-ERROR.
    WHEN {&INTEGER-DATA-TYPE}   THEN ttAttributeValue.i_integer_value   = INTEGER(pcAttributeValue) NO-ERROR.
    WHEN {&DATE-DATA-TYPE}      THEN ttAttributeValue.t_date_value      =    DATE(pcAttributeValue) NO-ERROR.
    WHEN {&RAW-DATA-TYPE}       THEN.
    WHEN {&LOGICAL-DATA-TYPE}   THEN ttAttributeValue.l_logical_value   = (pcAttributeValue = "TRUE":U OR
                                                                           pcAttributeValue = "YES":U) NO-ERROR.
    OTHERWISE ttAttributeValue.c_character_value = pcAttributeValue NO-ERROR.
  END CASE.

  IF cContainerMode <> "ADD":U THEN
    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U, "UPDATE":U).

  IF {fn getInstanceComplete ghGridObjectViewer} THEN
    DYNAMIC-FUNCTION("evaluateActions":U IN TARGET-PROCEDURE).
  
  /* Update the de-normalized information */
  IF NOT lContainerProperty THEN
  DO:
    CASE pcAttributeLabel:
      WHEN "ResizeHorizontal":U THEN ttObjectInstance.l_resize_horizontal = ttAttributeValue.l_logical_value.
      WHEN "ResizeVertical":U   THEN ttObjectInstance.l_resize_vertical   = ttAttributeValue.l_logical_value.
      WHEN "ForeignFields":U    THEN ttObjectInstance.c_foreign_fields    = ttAttributeValue.c_character_value.
    END CASE.

    DYNAMIC-FUNCTION("updatePropertyValue":U IN ghGridObjectViewer, pcObject, pcAttributeLabel, pcAttributeValue).
  END.
  ELSE
    DYNAMIC-FUNCTION("updatePropertyValue":U IN ghContainerViewer,  pcObject, pcAttributeLabel, pcAttributeValue).
    
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-propertyChangedEvent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE propertyChangedEvent Procedure 
PROCEDURE propertyChangedEvent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phHandle         AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER pcContainer      AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcObject         AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcResultCode     AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcEventName      AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcEventAction    AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcActionType     AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcActionTarget   AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcEventParameter AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER plEventDisabled  AS LOGICAL    NO-UNDO.
  DEFINE INPUT PARAMETER plOverride       AS LOGICAL    NO-UNDO.
  DEFINE INPUT PARAMETER pcFieldsModified AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cContainerMode            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldList                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dContainerSmartObjectObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dObjectInstanceObj        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dSmartObjectObj           AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dObjectTypeObj            AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dResultCodeObj            AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lContainerEvent           AS LOGICAL    NO-UNDO.
  
  DEFINE BUFFER ttObjectInstance FOR ttObjectInstance.
  DEFINE BUFFER ttSmartObject    FOR ttSmartObject.
  DEFINE BUFFER ttUiEvent        FOR ttUiEvent.

  ASSIGN
      dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U))
      cContainerMode          = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U).

  FIND FIRST ttSmartObject
       WHERE ttSmartObject.d_customization_result_obj = dCustomizationResultObj
         AND ttSmartObject.d_smartobject_obj          = DECIMAL(pcContainer) NO-ERROR.

  IF NOT AVAILABLE ttSmartObject THEN
    RETURN.

  FIND FIRST ttObjectInstance
       WHERE ttObjectInstance.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj
         AND ttObjectInstance.d_object_instance_obj       = DECIMAL(pcObject) NO-ERROR.

  IF NOT AVAILABLE ttObjectInstance THEN
    IF pcContainer = pcObject THEN
      lContainerEvent = TRUE.
    ELSE
      RETURN.

  IF pcResultCode <> "":U THEN
  DO:
    FIND FIRST ttUiEvent
         WHERE ttUiEvent.c_customization_result_code = pcResultCode NO-ERROR.

    IF AVAILABLE ttUiEvent THEN
      dResultCodeObj = ttUiEvent.d_customization_result_obj.
    ELSE
    DO:
      cQuery = "FOR EACH ryc_customization_result NO-LOCK":U
             + "   WHERE ryc_customization_result.customization_result_code = '":U + TRIM(pcResultCode) + "'":U.

      RUN getRecordDetail IN gshGenManager (INPUT  cQuery,
                                            OUTPUT cFieldList) NO-ERROR.

      IF cFieldList <> "":U THEN
        dResultCodeObj = DECIMAL(ENTRY(LOOKUP("ryc_customization_result.customization_result_obj":U, cFieldList, CHR(3)) + 1, cFieldList, CHR(3))).
    END.
  END.

  IF dCustomizationResultObj <> dResultCodeObj THEN
  DO:
    MESSAGE "This won't save. Only update values pertaining to the result code of the container you are modifying.".
  
    RETURN.
  END.

  IF lContainerEvent THEN
    ASSIGN
        dContainerSmartObjectObj = 0.00
        dObjectInstanceObj       = 0.00
        dSmartObjectObj          = ttSmartObject.d_smartobject_obj
        dObjectTypeObj           = ttSmartObject.d_object_type_obj.
  ELSE
    ASSIGN
        dContainerSmartObjectObj = ttSmartObject.d_smartobject_obj
        dObjectInstanceObj       = ttObjectInstance.d_object_instance_obj
        dSmartObjectObj          = ttObjectInstance.d_smartobject_obj
        dObjectTypeObj           = ttObjectInstance.d_object_type_obj.

  FIND FIRST ttUiEvent NO-LOCK
       WHERE ttUiEvent.d_container_smartobject_obj = dContainerSmartObjectObj
         AND ttUiEvent.d_primary_smartobject_obj   = ttSmartObject.d_smartobject_obj
         AND ttUiEvent.d_object_instance_obj       = dObjectInstanceObj
         AND ttUiEvent.d_smartobject_obj           = dSmartObjectObj
         AND ttUiEvent.d_object_type_obj           = dObjectTypeObj
         AND ttUiEvent.c_event_name                = pcEventName
         AND ttUiEvent.l_master_event              = FALSE NO-ERROR.

  IF NOT AVAILABLE ttUiEvent THEN
  DO:
    CREATE ttUiEvent.
    ASSIGN ttUiEvent.d_ui_event_obj              = DYNAMIC-FUNCTION("getTemporaryObj":U IN TARGET-PROCEDURE)
           ttUiEvent.d_container_smartobject_obj = dContainerSmartObjectObj
           ttUiEvent.d_primary_smartobject_obj   = ttSmartobject.d_smartobject_obj
           ttUiEvent.d_object_instance_obj       = dObjectInstanceObj
           ttUiEvent.d_smartobject_obj           = dSmartObjectObj
           ttUiEvent.d_object_type_obj           = dObjectTypeObj
           ttUiEvent.c_event_name                = pcEventName
           ttUiEvent.c_customization_result_code = pcResultCode
           ttUiEvent.d_customization_result_obj  = dCustomizationResultObj
           ttUiEvent.c_action                    = "A":U.
  END.
  ELSE
  DO:
    IF plOverride = FALSE THEN
      ttUiEvent.c_action = "D":U.
    ELSE
      ttUiEvent.c_action = IF ttUiEvent.c_action = "":U THEN "M":U ELSE ttUiEvent.c_action.
  END.

  ASSIGN
    /*ttUiEvent.l_constant_value  = plConstantValue*/
      ttUiEvent.c_action_type     = pcActionType
      ttUiEvent.c_action_target   = pcActionTarget
      ttUiEvent.c_event_action    = pcEventAction
      ttUiEvent.c_event_parameter = pcEventParameter
      ttUiEvent.l_event_disabled  = plEventDisabled.

  IF cContainerMode <> "ADD":U THEN
    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U, "UPDATE":U).

  DYNAMIC-FUNCTION("evaluateActions":U IN TARGET-PROCEDURE).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-registerPSObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE registerPSObjects Procedure 
PROCEDURE registerPSObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  
  Parameters:  INPUT pcInstanceName - The name the object is registered in the property
                                      sheet with. This is actually the object instance obj
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcInstanceName AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cCustomizationResultCode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMasterAttributeList      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMasterEventList          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectFilename           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cResultCodeList           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttributeList            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStatusDefault            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTempValue                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEventList                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cText                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dSmartObjectObj           AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lSmartFolder              AS LOGICAL    NO-UNDO.

  DEFINE BUFFER bttAttributeValue FOR ttAttributeValue.
  DEFINE BUFFER  ttAttributeValue FOR ttAttributeValue.
  DEFINE BUFFER  ttObjectInstance FOR ttObjectInstance.

  ASSIGN
      dCustomizationResultObj   = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U))
      cResultCodeList           = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultCode":U)
      cResultCodeList           = (IF cResultCodeList = "?":U OR cResultCodeList = ? THEN "":U ELSE cResultCodeList)
      cCustomizationResultCode  = cResultCodeList
      cResultCodeList           = (IF cResultCodeList = "":U  THEN "":U ELSE ",":U + cResultCodeList).

  {get StatusDefault cStatusDefault}.

  /* Find the container's smartobject record - we can find the main container or the customized. It does not matter, we only need its name */
  FIND FIRST ttSmartObject
       WHERE ttSmartObject.d_smartobject_obj         <> 0.00
         AND ttSmartObject.d_customization_result_obj = dCustomizationResultObj.

  IF ttSmartObject.c_object_filename = "":U THEN
    cObjectFilename = "<Enter container name>":U.
  ELSE
    cObjectFilename = ttSmartobject.c_object_filename.

  dSmartObjectObj = ttSmartObject.d_smartobject_obj.

  /* Go through the objects on the container, build up their attribute strings and finally register the object */
  IF pcInstanceName = "":U THEN
  DO:
    ASSIGN
        cAttributeList = "":U
        cEventList     = "":U.

    FOR EACH ttSmartObject
       WHERE ttSmartObject.d_smartobject_obj <> 0.00,
       FIRST ttObjectType
       WHERE ttObjectType.d_object_type_obj = ttSmartObject.d_object_type_obj
       BREAK
          BY ttSmartObject.c_object_filename
          BY ttSmartObject.d_customization_result_obj:

      /* Step through the attributes of the object instance */
      FOR EACH ttAttributeValue
         WHERE ttAttributeValue.d_object_instance_obj = 0.00
           AND ttAttributeValue.d_smartobject_obj     = ttSmartObject.d_smartobject_obj:

        cAttributeList = cAttributeList
                       + (IF cAttributeList = "":U THEN "":U ELSE   CHR(3))
                       + TRIM(ttAttributeValue.c_attribute_label) + CHR(3)
                       + (IF ttSmartObject.d_customization_result_obj <> 0.00 THEN TRIM(ttAttributeValue.c_customization_result_code) ELSE "":U)
                       + CHR(3).

        CASE ttAttributeValue.i_data_type:
          WHEN {&DECIMAL-DATA-TYPE}   THEN cTempValue = STRING(ttAttributeValue.d_decimal_value).
          WHEN {&INTEGER-DATA-TYPE}   THEN cTempValue = STRING(ttAttributeValue.i_integer_value).
          WHEN {&DATE-DATA-TYPE}      THEN cTempValue = STRING(ttAttributeValue.t_date_value).
          WHEN {&RAW-DATA-TYPE}       THEN.
          WHEN {&LOGICAL-DATA-TYPE}   THEN cTempValue = (IF ttAttributeValue.l_logical_value THEN "YES":U ELSE "NO":U).
          WHEN {&CHARACTER-DATA-TYPE} THEN cTempValue = ttAttributeValue.c_character_value.
        END CASE.
        
        cAttributeList = cAttributeList + (IF cTempValue = ? THEN "":U ELSE cTempValue).
      END.

      /* Step through the ui events of the object instance */
      FOR EACH ttUiEvent
         WHERE ttUiEvent.d_object_instance_obj = 0.00
           AND ttUiEvent.d_smartobject_obj     = ttSmartObject.d_smartobject_obj:

        cEventList = cEventList 
                   + (IF cEventList = "":U THEN "":U ELSE  CHR(3))
                   + TRIM(ttUiEvent.c_event_name)        + CHR(3)
                   + cCustomizationResultCode            + CHR(3)
                   + ttUiEvent.c_event_action            + CHR(3)
                   + ttUiEvent.c_action_type             + CHR(3)
                   + ttUiEvent.c_action_target           + CHR(3)
                   + ttUiEvent.c_event_parameter         + CHR(3)
                   + STRING(ttUiEvent.l_event_disabled).
      END.

      /* Register the container */
      IF LAST-OF(ttSmartObject.c_object_filename) THEN
      DO:
        cText = "Registering in Property Sheet: " + cObjectFileName + "...".

        {set StatusDefault cText}.

        RUN registerObject IN ghProcLib (INPUT TARGET-PROCEDURE,                /* Calling procedure */
                                         INPUT dSmartObjectObj,                 /* Container Name    */
                                         INPUT cObjectFilename,                 /* Container Label   */
                                         INPUT dSmartObjectObj,                 /* Object Name       */
                                         INPUT cObjectFilename,                 /* Object Label      */
                                         INPUT ttObjectType.c_object_type_code, /* Object Class      */
                                         INPUT "":U,                            /* Object Class list */
                                         INPUT "MASTER":U,                      /* Object Level      */
                                         INPUT cAttributeList,                  /* Attribute list    */
                                         INPUT cEventList,                      /* Event List        */
                                         INPUT "":U,                            /* Attribute Default */  /* This is for the master, which is the instance */
                                         INPUT "":U,                            /* Event Default List */
                                         INPUT cResultCodeList).
      END.
    END.
  END.

  /* Go through the objects on the container, build up their attribute strings and finally register the object */
  FOR EACH ttObjectInstance
     WHERE ttObjectInstance.d_object_instance_obj <> 0.00
       AND (pcInstanceName  = "":U
        OR (pcInstanceName <> "":U
       AND  pcInstanceName  = STRING(ttObjectInstance.d_object_instance_obj))),
     FIRST ttObjectType
     WHERE ttObjectType.d_object_type_obj = ttObjectInstance.d_object_type_obj
     BREAK
        BY ttObjectInstance.c_instance_name
        BY ttObjectInstance.d_customization_result_obj:

    /* If we are busy with a new object instance, clear the attribute list */
    IF FIRST-OF(ttObjectInstance.c_instance_name) THEN
      ASSIGN
          cMasterAttributeList = "":U
          cMasterEventList     = "":U
          cAttributeList       = "":U
          cEventList           = "":U
          lSmartFolder         = LOOKUP(ttObjectType.c_object_type_code, gcFolderClasses) <> 0.

    /* Step through the attributes of the MASTER instance */
    FOR EACH ttAttributeValue
       WHERE ttAttributeValue.d_smartobject_obj           = ttObjectInstance.d_smartobject_obj
         AND ttAttributeValue.d_primary_smartobject_obj   = ttObjectInstance.d_smartobject_obj
         AND ttAttributeValue.d_container_smartobject_obj = 0.00
         AND ttAttributeValue.d_object_instance_obj       = 0.00:

      cMasterAttributeList = cMasterAttributeList
                           + (IF cMasterAttributeList = "":U THEN "":U ELSE   CHR(3))
                           + TRIM(ttAttributeValue.c_attribute_label) + CHR(3)
                           + cCustomizationResultCode
                           + CHR(3).

      CASE ttAttributeValue.i_data_type:
        WHEN {&DECIMAL-DATA-TYPE}   THEN cTempValue = STRING(ttAttributeValue.d_decimal_value).
        WHEN {&INTEGER-DATA-TYPE}   THEN cTempValue = STRING(ttAttributeValue.i_integer_value).
        WHEN {&DATE-DATA-TYPE}      THEN cTempValue = STRING(ttAttributeValue.t_date_value).
        WHEN {&RAW-DATA-TYPE}       THEN.
        WHEN {&LOGICAL-DATA-TYPE}   THEN cTempValue = (IF ttAttributeValue.l_logical_value THEN "YES":U ELSE "NO":U).
        WHEN {&CHARACTER-DATA-TYPE} THEN cTempValue = ttAttributeValue.c_character_value.
      END CASE.
      
      cMasterAttributeList = cMasterAttributeList + (IF cTempValue = ? THEN "":U ELSE cTempValue).
    END.

    /* Step through the events of the MASTER instance */
    FOR EACH ttUiEvent
       WHERE ttUiEvent.d_smartobject_obj           = ttObjectInstance.d_smartobject_obj
         AND ttUiEvent.d_primary_smartobject_obj   = ttObjectInstance.d_smartobject_obj
         AND ttUiEvent.d_container_smartobject_obj = 0.00
         AND ttUiEvent.d_object_instance_obj       = 0.00:

      cMasterEventList = cMasterEventList 
                       + (IF cMasterEventList = "":U THEN "":U ELSE CHR(3))
                       + TRIM(ttUiEvent.c_event_name)             + CHR(3)
                       + cCustomizationResultCode                 + CHR(3)
                       + ttUiEvent.c_event_action                 + CHR(3)
                       + ttUiEvent.c_action_type                  + CHR(3)
                       + ttUiEvent.c_action_target                + CHR(3)
                       + ttUiEvent.c_event_parameter              + CHR(3)
                       + STRING(ttUiEvent.l_event_disabled).
    END.

    /* Step through the attributes of the OBJECT instance */
    FOR EACH ttAttributeValue
       WHERE ttAttributeValue.d_object_instance_obj = ttObjectInstance.d_object_instance_obj:

      cAttributeList = cAttributeList
                     + (IF cAttributeList = "":U THEN "":U ELSE   CHR(3))
                     + TRIM(ttAttributeValue.c_attribute_label) + CHR(3)
                     + cCustomizationResultCode
                     + CHR(3).

      CASE ttAttributeValue.i_data_type:
        WHEN {&DECIMAL-DATA-TYPE}   THEN cTempValue = STRING(ttAttributeValue.d_decimal_value).
        WHEN {&INTEGER-DATA-TYPE}   THEN cTempValue = STRING(ttAttributeValue.i_integer_value).
        WHEN {&DATE-DATA-TYPE}      THEN cTempValue = STRING(ttAttributeValue.t_date_value).
        WHEN {&RAW-DATA-TYPE}       THEN.
        WHEN {&LOGICAL-DATA-TYPE}   THEN cTempValue = (IF ttAttributeValue.l_logical_value THEN "YES":U ELSE "NO":U).
        WHEN {&CHARACTER-DATA-TYPE} THEN cTempValue = ttAttributeValue.c_character_value.
      END CASE.

      cAttributeList = cAttributeList + (IF cTempValue = ? THEN "":U ELSE cTempValue).
    END.

    /* Step through the ui events of the OBJECT instance */
    FOR EACH ttUiEvent
       WHERE ttUiEvent.d_object_instance_obj = ttObjectInstance.d_object_instance_obj:

      cEventList = cEventList 
                 + (IF cEventList = "":U THEN "":U ELSE  CHR(3))
                 + TRIM(ttUiEvent.c_event_name)        + CHR(3)
                 + cCustomizationResultCode            + CHR(3)
                 + ttUiEvent.c_event_action            + CHR(3)
                 + ttUiEvent.c_action_type             + CHR(3)
                 + ttUiEvent.c_action_target           + CHR(3)
                 + ttUiEvent.c_event_parameter         + CHR(3)
                 + STRING(ttUiEvent.l_event_disabled).
    END.

    /* Register the object */
    IF LAST-OF(ttObjectInstance.c_instance_name) THEN
    DO:
      cText = "Registering in Property Sheet: " + ttObjectInstance.c_instance_name + "...".

      {set StatusDefault cText}.

      RUN registerObject IN ghProcLib (INPUT TARGET-PROCEDURE,                        /* Calling procedure */
                                       INPUT dSmartObjectObj,                         /* Container Name    */
                                       INPUT cObjectFilename,                         /* Container Label   */
                                       INPUT ttObjectInstance.d_object_instance_obj,  /* Object Name       */
                                       INPUT ttObjectInstance.c_instance_name,        /* Object Label      */
                                       INPUT ttObjectType.c_object_type_code,         /* Object Class      */
                                       INPUT "":U,                                    /* Object Class list */
                                       INPUT "INSTANCE":U,                            /* Object Level      */
                                       INPUT cAttributeList,                          /* Attribute list    */
                                       INPUT cEventList,                              /* Event List        */
                                       INPUT cMasterAttributeList,                    /* Attribute Default */
                                       INPUT cMasterEventList,                        /* Event Default     */
                                       INPUT cResultCodeList).

      IF lSmartFolder THEN
        RUN assignPropertySensitive IN ghProcLib (INPUT TARGET-PROCEDURE,                                   /* Calling procedure */
                                                  INPUT dSmartObjectObj,                                    /* Container Name    */
                                                  INPUT ttObjectInstance.d_object_instance_obj,             /* Object Name       */
                                                  INPUT cResultCodeList,                                    /* ResultCode        */
                                                  INPUT "ResizeHorizontal":U + CHR(3) + "ResizeVertical":U, /* Attribute list    */
                                                  INPUT "":U,                                               /* Event List        */
                                                  INPUT TRUE).                                              /* Disabled          */
    END.
  END.

  {set StatusDefault cStatusDefault}.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repointAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repointAttributes Procedure 
PROCEDURE repointAttributes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  This will only be called by ryobjgridv.w when 'Save' is pressed and
          a smartobject has been changed
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdObjectInstanceObj  AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdOldSmartObjectObj  AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdNewSmartObjectObj  AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdNewObjectTypeObj   AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE cCustomizationResultCode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj   AS DECIMAL    NO-UNDO.

  DEFINE BUFFER ttAttributeValue FOR ttAttributeValue.
  DEFINE BUFFER ttUiEvent        FOR ttUiEvent.

  ASSIGN
      cCustomizationResultCode = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultCode":U)
      dCustomizationResultObj  = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U)).
  
  FOR EACH ttAttributeValue NO-LOCK
     WHERE ttAttributeValue.d_customization_result_obj = dCustomizationResultObj
       AND ttAttributeValue.d_object_instance_obj      = pdObjectInstanceObj
       AND ttAttributeValue.d_smartobject_obj          = pdOldSmartObjectObj:

    ASSIGN
        ttAttributeValue.d_smartobject_obj = pdNewSmartObjectObj
        ttAttributeValue.d_object_type_obj = pdNewObjectTypeObj
        ttAttributeValue.c_action          = (IF ttAttributeValue.c_action <> "":U THEN ttAttributeValue.c_action ELSE "M":U).
  END.

  FOR EACH ttUiEvent
     WHERE ttUiEvent.d_customization_result_obj = dCustomizationResultObj
       AND ttUiEvent.d_object_instance_obj      = pdObjectInstanceObj
       AND ttUiEvent.d_smartobject_obj          = pdOldSmartObjectObj:

    ASSIGN
        ttUiEvent.d_smartobject_obj = pdNewSmartObjectObj
        ttUiEvent.d_object_type_obj = pdNewObjectTypeObj
        ttUiEvent.c_action          = (IF ttUiEvent.c_action <> "":U THEN ttUiEvent.c_action ELSE "M":U).
  END.

  RUN unregisterPSObjects IN TARGET-PROCEDURE (INPUT STRING(pdObjectInstanceObj)).
  RUN registerPSObjects   IN TARGET-PROCEDURE (INPUT STRING(pdObjectInstanceObj)).

  RUN displayProperties IN ghProcLib (TARGET-PROCEDURE, STRING(ttSmartObject.d_smartobject_obj), STRING(pdObjectInstanceObj), cCustomizationResultCode, TRUE, 0).
  
  RETURN.

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
  DEFINE VARIABLE cContainerMode          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFolderLabels           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iCurrentPage            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNumPages               AS INTEGER    NO-UNDO.
  
  DEFINE BUFFER ttPage FOR ttPage.

  ASSIGN
      dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U))
      cContainerMode          = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U)
      iCurrentPage            = DYNAMIC-FUNCTION("getCurrentPage":U  IN TARGET-PROCEDURE) - 1
      cFolderLabels           = DYNAMIC-FUNCTION("getFolderLabels":U IN ghPageSource).

  FIND FIRST ttSmartObject
       WHERE ttSmartObject.d_smartobject_obj         <> 0.00
         AND ttSmartObject.d_customization_result_obj = dCustomizationResultObj.

  DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U, "MODIFY":U).

  PUBLISH "fetchContainerData":U FROM TARGET-PROCEDURE (INPUT ttSmartObject.c_object_filename).

  DYNAMIC-FUNCTION("evaluateActions":U IN TARGET-PROCEDURE).

  iNumPages = 0.

  FOR EACH ttPage
     WHERE ttPage.c_action                  <> "D":U
       AND ttPage.d_customization_result_obj = dCustomizationResultObj:

    iNumPages = iNumPages + 1.
  END.

  /* In this case, the page we are trying to re-position to has been deleted */
  IF iCurrentPage + 1 >= iNumPages + 1 THEN
    iCurrentPage = 0.

  RUN selectPage    IN TARGET-PROCEDURE   (INPUT iCurrentPage + 1).
  RUN trgMenuChoose IN ghGridObjectViewer (INPUT ?, "ClearCut":U).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-runContainer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runContainer Procedure 
PROCEDURE runContainer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCustomizationResultCode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCacheToolbar             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStatusDefault            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProcedureType            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilename                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hHandle                   AS HANDLE     NO-UNDO.
  
  DEFINE BUFFER ttSmartObject FOR ttSmartObject.

  ASSIGN
      cCustomizationResultCode = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultCode":U)
      dCustomizationResultObj  = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U))
      cStatusDefault           = DYNAMIC-FUNCTION("getStatusDefault":U IN TARGET-PROCEDURE)
      cCacheToolbar            = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, "cacheToolbar":U, TRUE)
      cCacheToolbar            = (IF cCacheToolbar = ? OR cCacheToolbar = "?":U THEN "":U ELSE cCacheToolbar).

  IF cCustomizationResultCode = "?":U OR
     cCustomizationResultCode = ?     THEN
    cCustomizationResultCode = "":U.

  cCustomizationResultCode = cCustomizationResultCode + (IF cCustomizationResultCode = "":U THEN "":U ELSE ",":U) + "{&DEFAULT-RESULT-CODE}":U.

  FIND FIRST ttSmartObject
       WHERE ttSmartObject.d_smartobject_obj         <> 0.00
         AND ttSmartObject.d_customization_result_obj = dCustomizationResultObj.

  cFilename = ttSmartObject.c_object_filename.

  DYNAMIC-FUNCTION("setStatusDefault":U IN TARGET-PROCEDURE, "Clearing client cache...":U).

  RUN clearClientCache IN gshRepositoryManager.

  DYNAMIC-FUNCTION("setStatusDefault":U IN TARGET-PROCEDURE, "Running '":U + cFilename + "'...":U).
          .
  /* Cache the custom objects for all instances on all pages */
  RUN cacheRepositoryObject IN gshRepositoryManager
         (INPUT cFileName,  /* Object Filename */
          INPUT "Page:*":U, /* Instance - get all instances */
          INPUT "",         /* Run attribute */
          INPUT cCustomizationResultCode). /* Customization code */

  DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager, "cacheToolbar":U, "no":U, FALSE).

  RUN launchContainer IN gshSessionManager (INPUT  cFilename,       /* pcObjectFileName       */
                                            INPUT  "":U,            /* pcPhysicalName         */
                                            INPUT  cFilename,       /* pcLogicalName          */
                                            INPUT  FALSE,           /* plOnceOnly             */
                                            INPUT  "":U,            /* pcInstanceAttributes   */
                                            INPUT  "":U,            /* pcChildDataKey         */
                                            INPUT  "":U,            /* pcRunAttribute         */
                                            INPUT  "":U,            /* container mode         */
                                            INPUT  ?,               /* phParentWindow         */
                                            INPUT  ?,               /* phParentProcedure      */
                                            INPUT  ?,               /* phObjectProcedure      */
                                            OUTPUT hHandle,         /* phProcedureHandle      */
                                            OUTPUT cProcedureType). /* pcProcedureType        */

  DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager, "cacheToolbar":U, cCacheToolbar, TRUE).

  DYNAMIC-FUNCTION("setStatusDefault":U IN TARGET-PROCEDURE, cStatusDefault).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-saveContainer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveContainer Procedure 
PROCEDURE saveContainer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER plDeleteContainer  AS LOGICAL    NO-UNDO.
  DEFINE INPUT PARAMETER plRefetchData      AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cCustomizationResultCode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLastContainerName        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectFilename           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLastObjectName           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReturnValue              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTitle                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dSmartobjectObj           AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lErrorStatus              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lContinue                 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hLastCallingProc          AS HANDLE     NO-UNDO.

  DEFINE VARIABLE lSaveWidgetIDFileName       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lUseDefaultWidgetIDFileName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cWidgetIDFileName           AS CHARACTER NO-UNDO.

  ERROR-STATUS:ERROR = FALSE.

  DEFINE BUFFER ttObjectInstance FOR ttObjectInstance.
  DEFINE BUFFER ttSmartObject    FOR ttSmartObject.

  DYNAMIC-FUNCTION("applyLeaveToLookups":U IN ghContainerViewer).

  ASSIGN
      cCustomizationResultCode = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultCode":U)
      dCustomizationResultObj  = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U)).

  SESSION:SET-WAIT-STATE("GENERAL":U).

  FIND FIRST ttSmartObject
       WHERE ttSmartObject.d_smartobject_obj         <> 0
         AND ttSmartObject.d_customization_result_obj = dCustomizationResultObj NO-ERROR.

  IF AVAILABLE ttSmartObject THEN
  DO:
    IF ttSmartObject.d_smartobject_obj > 0.00 THEN
      ASSIGN
          cObjectFilename = ttSmartObject.c_object_filename
          dSmartObjectObj = ttSmartObject.d_smartobject_obj.

    IF ttSmartObject.d_smartobject_obj > 0.00 AND
       ttSmartObject.c_action          = "":U THEN
      ASSIGN
          ttSmartObject.c_action = "M":U.

    /* When we are adding, a different object type could have been chosen, so make sure the attribute records are correct */
    IF {fnarg getUserProperty 'ContainerMode':U} = "ADD":U THEN
    DO:
     GET-KEY-VALUE SECTION "ProAB":U KEY "WidgetIDSaveFileName":U VALUE lSaveWidgetIDFileName.
     GET-KEY-VALUE SECTION "ProAB":U KEY "WidgetIDDefaultFileName":U VALUE lUseDefaultWidgetIDFileName.
     IF CAN-DO("true,yes,on",lSaveWidgetIDFileName) AND
        NOT CAN-DO("true,yes,on",lUseDefaultWidgetIDFileName) THEN     DO:
         GET-KEY-VALUE SECTION "ProAB":U KEY "WidgetIDFileName":U VALUE cWidgetIDFileName.
         IF cWidgetIDFileName NE ? AND cWidgetIDFileName NE "" THEN
         DO:
            CREATE ttAttributeValue.
            ASSIGN ttAttributeValue.d_container_smartobject_obj = 0.0 /*ttSmartObject.d_smartobject_obj*/
                   ttAttributeValue.d_primary_smartobject_obj   = ttSmartObject.d_smartobject_obj
                   ttAttributeValue.d_object_instance_obj       = 0.0
                   ttAttributeValue.d_smartobject_obj           = ttSmartObject.d_smartobject_obj
                   ttAttributeValue.d_object_type_obj           = ttSmartObject.d_object_type_obj
                   ttAttributeValue.c_attribute_label           = "WidgetIDFileName":U
                   ttAttributeValue.d_customization_result_obj  = dCustomizationResultObj
                   ttAttributeValue.c_action                    = "A":U
                   ttAttributeValue.c_character_value           = cWidgetIDFileName
                   ttAttributeValue.i_data_type                 = 1.
         END.
     END.

      FOR EACH ttAttributeValue NO-LOCK
         WHERE ttAttributeValue.d_container_smartobject_obj = 0.00
           AND ttAttributeValue.d_smartobject_obj           = ttSmartObject.d_smartobject_obj
           AND ttAttributeValue.d_object_type_obj          <> ttSmartObject.d_object_type_obj
           AND ttAttributeValue.c_action                   <> "D":U:

        ttAttributeValue.d_object_type_obj = ttSmartObject.d_object_type_obj.
      END.
    END.
  END.

  {fn checkInstanceName ghGridObjectViewer}.

  RUN checkContainerDetails IN TARGET-PROCEDURE (OUTPUT lContinue) NO-ERROR.

  IF NOT lContinue  OR ERROR-STATUS:ERROR THEN
  DO:
    SESSION:SET-WAIT-STATE("":U).

    RETURN ERROR "ERROR":U.
  END.

  RUN getLastObjectDetails IN ghProcLib (OUTPUT hLastCallingProc,
                                         OUTPUT cLastContainerName,
                                         OUTPUT cLastObjectName).

  /* We need to find the object instance and store the name of the object instance. This will
     be used to refind the object instance as the object number could have been changed if it
     is a newly added instance. */
  IF cLastContainerName <> cLastObjectName THEN
  DO:
    FIND FIRST ttObjectInstance
         WHERE ttObjectInstance.d_object_instance_obj = DECIMAL(cLastObjectName) NO-ERROR.

    IF AVAILABLE ttObjectInstance THEN
      cLastObjectName = ttObjectInstance.c_instance_name.
  END.

  RUN unregisterPSObjects IN TARGET-PROCEDURE (INPUT "":U).

  {launch.i &PLIP     = 'ry/app/rycntbplip.p'
            &IProc    = 'setContainerDetails'
            &PList    = "(INPUT dCustomizationResultObj,
                          INPUT-OUTPUT TABLE ttSmartObject,
                          INPUT-OUTPUT TABLE ttPage,
                          INPUT-OUTPUT TABLE ttPageObject,  /* Not to be used anymore */
                          INPUT-OUTPUT TABLE ttObjectInstance,
                          INPUT-OUTPUT TABLE ttAttributeValue,
                          INPUT-OUTPUT TABLE ttUiEvent,
                          INPUT-OUTPUT TABLE ttSmartLink,
                          INPUT-OUTPUT TABLE ttObjectMenuStructure)"
            &OnApp    = 'YES'
            &AutoKill = YES}

  ASSIGN
      lErrorStatus = ERROR-STATUS:ERROR
      cReturnValue = RETURN-VALUE.

  IF lErrorStatus = TRUE THEN
    ASSIGN
        cMessage = RETURN-VALUE
        cTitle   = (IF plDeleteContainer = TRUE THEN "Deletion " ELSE "Saving ")
                 + "of the container was unsuccessful".
  ELSE
  DO:
    /* IZ 6618. When saving an object, force tools to refresh its instances of the saved smartobject */
    PUBLISH "MasterObjectModified":U FROM gshRepositoryManager (INPUT dSmartObjectObj, INPUT cObjectFilename).

    /* Refetch the container to ensure the temp-tables are properly cleaned out */
    IF plDeleteContainer <> TRUE AND
       plRefetchData      = TRUE THEN
      RUN fetchContainerData IN TARGET-PROCEDURE (INPUT ttSmartObject.c_object_filename).

    ASSIGN
        cMessage = (IF plDeleteContainer = TRUE THEN "deletion " ELSE "saving ")
                 + "of the container"
        cMessage = {aferrortxt.i 'AF' '108' '?' '?' cMessage}
        cTitle   = (IF plDeleteContainer = TRUE THEN "Deletion ":U ELSE "Saving ")
                 + "of the "
                 + IF dCustomizationResultObj = 0.00 THEN "container " ELSE "customization "
                 + "was successful".

    IF plDeleteContainer = TRUE THEN
    DO:
      DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U, "0":U).
      DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U, "MODIFY":U).

      RUN clearViewer IN ghContainerViewer.
      RUN findRecord  IN TARGET-PROCEDURE.
    END.
    ELSE
    DO:
      RUN registerPSObjects IN TARGET-PROCEDURE (INPUT "":U).

      DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U, "MODIFY":U).
      DYNAMIC-FUNCTION("evaluateActions":U IN TARGET-PROCEDURE).
      DYNAMIC-FUNCTION("evaluateActions":U IN ghGridObjectViewer).

      PUBLISH "enableSearchLookups":U FROM TARGET-PROCEDURE (INPUT FALSE).
    END.

    /* Set the handles of the TEMP-TABLES in the TARGET-PROCEDURE as user properties so the other procedures and viewers can have access them */
    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ttObjectMenuStructure":U, STRING(TEMP-TABLE ttObjectMenuStructure:DEFAULT-BUFFER-HANDLE)).
    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ttObjectInstance":U,      STRING(TEMP-TABLE ttObjectInstance:DEFAULT-BUFFER-HANDLE)).
    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ttAttributeValue":U,      STRING(TEMP-TABLE ttAttributeValue:DEFAULT-BUFFER-HANDLE)).
    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ttSmartObject":U,         STRING(TEMP-TABLE ttSmartObject:DEFAULT-BUFFER-HANDLE)).
    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ttSmartLink":U,           STRING(TEMP-TABLE ttSmartLink:DEFAULT-BUFFER-HANDLE)).
    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ttUiEvent":U,             STRING(TEMP-TABLE ttUiEvent:DEFAULT-BUFFER-HANDLE)).
    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ttPage":U,                STRING(TEMP-TABLE ttPage:DEFAULT-BUFFER-HANDLE)).

    RUN displayContainerDetails IN TARGET-PROCEDURE (INPUT DYNAMIC-FUNCTION("getCurrentPage":U IN TARGET-PROCEDURE)).

    PUBLISH "updateTitle":U FROM TARGET-PROCEDURE.
  END.

  SESSION:SET-WAIT-STATE("":U).

  IF lErrorStatus OR glConfirmSave THEN
    RUN showMessages IN gshSessionManager (INPUT  cMessage,                                         /* message to display */
                                           INPUT  IF lErrorStatus = TRUE THEN "ERR":U ELSE "INF":U, /* error type         */
                                           INPUT  "&Ok":U,                                          /* button list        */
                                           INPUT  "&Ok":U,                                          /* default button     */ 
                                           INPUT  "&Ok":U,                                          /* cancel button      */
                                           INPUT  cTitle,                                           /* error window title */
                                           INPUT  YES,                                              /* display if empty   */ 
                                           INPUT  TARGET-PROCEDURE,                                   /* container handle   */ 
                                           OUTPUT cButton).                                         /* button pressed     */

  /* Refind the records because their object numbers could possibly have changed */
  FIND FIRST ttSmartObject
       WHERE ttSmartObject.d_smartobject_obj         <> 0
         AND ttSmartObject.d_customization_result_obj = dCustomizationResultObj NO-ERROR.

  IF cLastContainerName <> cLastObjectName THEN
  DO:
    FIND FIRST ttObjectInstance
         WHERE ttObjectInstance.c_instance_name            = cLastObjectName
           AND ttObjectInstance.d_customization_result_obj = dCustomizationResultObj NO-ERROR.

    IF AVAILABLE ttObjectInstance THEN
      cLastObjectName = STRING(ttObjectInstance.d_object_instance_obj).
  END.
  ELSE
    IF AVAILABLE ttSmartObject THEN
      cLastObjectName = STRING(ttSmartObject.d_smartobject_obj).

  IF AVAILABLE ttSmartObject THEN
    RUN displayProperties IN ghProcLib (TARGET-PROCEDURE,
                                        STRING(ttSmartObject.d_smartobject_obj),
                                        cLastObjectName,
                                        cCustomizationResultCode,
                                        FALSE,
                                        0).  

  IF glAppBuilder THEN
    RUN adeshar/_mrulist.p (ttSmartObject.c_object_filename,"").  

  IF lErrorStatus = TRUE THEN
    RETURN ERROR.
  ELSE
    RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAttributeListValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAttributeListValues Procedure 
PROCEDURE setAttributeListValues :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phHandle           AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER pcObject           AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcAttributeLabels  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcAttributeValues  AS CHARACTER  NO-UNDO.
 
  DEFINE VARIABLE cCustomizationResultCode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttributeChanges         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttributeLabel           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttributeValue           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cInstanceName             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContainer                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObject                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iEntry                    AS INTEGER    NO-UNDO.

  DEFINE BUFFER ttObjectInstance  FOR ttObjectInstance.
  DEFINE BUFFER ttSmartObject     FOR ttSmartObject.

  dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U)).

  FIND FIRST ttSmartObject
       WHERE ttSmartObject.d_customization_result_obj = dCustomizationResultObj
         AND ttSmartObject.d_smartobject_obj         <> 0.00.

  IF pcObject <> "":U THEN
  DO:
    FIND FIRST ttObjectInstance
         WHERE ttObjectInstance.c_instance_name            = pcObject
           AND ttObjectInstance.d_customization_result_obj = dCustomizationResultObj NO-ERROR.
    
    IF NOT AVAILABLE ttObjectInstance THEN
      FIND FIRST ttObjectInstance
           WHERE ttObjectInstance.c_instance_name            = pcObject
             AND ttObjectInstance.d_customization_result_obj = 0.00.
  END.

  ASSIGN
      cCustomizationResultCode = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultCode":U)
      cCustomizationResultCode = (IF cCustomizationResultCode = ? OR cCustomizationResultCode = "?":U THEN "":U ELSE cCustomizationResultCode)
      cContainer               = STRING(ttSmartObject.d_smartobject_obj)
      cObject                  = (IF pcObject = "":U THEN cContainer ELSE STRING(ttObjectInstance.d_object_instance_obj)).

  DO iEntry = 1 TO NUM-ENTRIES(pcAttributeLabels):
    ASSIGN
        cAttributeLabel   = ENTRY(iEntry, pcAttributeLabels)
        cAttributeValue   = ENTRY(iEntry, pcAttributeValues, CHR(3))
        cAttributeChanges = cAttributeChanges
                          + (IF cAttributeChanges = "":U THEN "":U ELSE CHR(3))
                          + cAttributeLabel + CHR(3) + cCustomizationResultCode + CHR(3) + cAttributeValue.

    RUN propertyChangedAttribute IN TARGET-PROCEDURE (INPUT phHandle,                 /* phHandle        */
                                                      INPUT cContainer,               /* pcContainer     */
                                                      INPUT cObject,                  /* pcObject        */
                                                      INPUT cCustomizationResultCode, /* pcResultCode    */
                                                      INPUT cAttributeLabel,          /* cAttributeLabel */
                                                      INPUT cAttributeValue,          /* cAttributeValue */
                                                      INPUT "":U,                     /* pcDataType      */   /* This is not needed as it is determined by the label */
                                                      INPUT TRUE).                    /* plOverride      */
  END.

  IF cAttributeChanges <> "":U THEN
  DO:
    RUN assignPropertyValues IN ghProcLib (INPUT TARGET-PROCEDURE,
                                           INPUT cContainer,
                                           INPUT cObject,
                                           INPUT cAttributeChanges,
                                           INPUT "":U,
                                           INPUT TRUE).
    
    RUN displayProperties IN ghProcLib (TARGET-PROCEDURE, cContainer, cObject, cCustomizationResultCode, TRUE, 0).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setupFolderPages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setupFolderPages Procedure 
PROCEDURE setupFolderPages :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER piPageSequence AS INTEGER    NO-UNDO.

  DEFINE VARIABLE cFolderLabels           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dTabRowHeight           AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dTabDifference          AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dDifference             AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iPageNumber             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hQuery                  AS HANDLE     NO-UNDO.

  {fnarg lockWindow TRUE}.

  DEFINE BUFFER ttPage FOR ttPage.
  
  ASSIGN
      dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U))
      cFolderLabels           = "Container":U + IF glAddPageNumber THEN " (Pg. 0)":U ELSE "":U
      iPageNumber             = 0.

  FOR EACH ttPage NO-LOCK
     WHERE ttPage.c_action                  <> "D":U
       AND ttPage.i_page_sequence           <> 0
       AND ttPage.d_customization_result_obj = dCustomizationResultObj
        BY ttPage.i_page_sequence:

    ASSIGN
        iPageNumber   = iPageNumber + 1
        cFolderLabels = cFolderLabels + "|":U
                      + TRIM(ttPage.c_page_label)
                      + (IF glAddPageNumber THEN " (Pg ":U + TRIM(STRING(iPageNumber)) + ")":U ELSE "":U).
  END.

  IF piPageSequence = ? THEN
    cFolderLabels = "Container":U.

  IF {fn getFolderLabels ghPageSource} <> cFolderLabels OR piPageSequence = ? OR (PROGRAM-NAME(2) BEGINS "processProfileData":U AND {fn getObjectInitialized ghPageSource}) THEN
  DO:
    IF gdTabRowHeight = ? THEN
      {get TabRowHeight gdTabRowHeight ghPageSource}.

    DYNAMIC-FUNCTION("constructFolderLabels":U IN ghPageSource, cFolderLabels).
/*
    {fnarg setFolderLabels cFolderLabels ghPageSource}.
    RUN initializeObject IN ghPageSource.*/
    {get TabRowHeight dTabRowHeight ghPageSource}.

    IF dTabRowHeight <> gdTabRowHeight THEN
    DO:
      ASSIGN
          dTabDifference                     = dTabRowHeight - gdTabRowHeight
          ghContainerHandle:MIN-HEIGHT-CHARS = ghContainerHandle:MIN-HEIGHT-CHARS + dTabDifference.

      /* Sizing the container larger is taken care of by the resizeWindow, but not when sizing smaller */
      IF dTabDifference < 0 THEN
      DO:
        DYNAMIC-FUNCTION("setMinHeight":U IN ghPageSource, {fn getHeight ghPageSource} + dTabDifference).

        ghContainerHandle:HEIGHT-CHARS = ghContainerHandle:HEIGHT-CHARS + dTabDifference.
      END.
      ELSE
        ASSIGN
            dDifference    = ({fn getHeight ghGridObjectViewer} - ({fn getMinHeight ghGridObjectViewer} + 0.09))
            dDifference    = (IF dDifference = 0 THEN -(dTabDifference)
                                                 ELSE (IF dDifference > dTabDifference THEN 0
                                                                                       ELSE dDifference - dTabDifference + 0.16))
            ghContainerHandle:HEIGHT-CHARS = ghContainerHandle:HEIGHT-CHARS
                                           + (dTabDifference + dDifference).
        
      RUN resizeWindow IN TARGET-PROCEDURE.

      gdTabRowHeight = dTabRowHeight.
    END.

    RUN viewObject  IN ghGridObjectViewer.
  END.

  {fnarg lockWindow FALSE}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-swapPageNumbers) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE swapPageNumbers Procedure 
PROCEDURE swapPageNumbers :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER piSwapPage AS INTEGER    NO-UNDO.
  DEFINE INPUT PARAMETER piWithPage AS INTEGER    NO-UNDO.
  
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iTemporaryPage          AS INTEGER    NO-UNDO INITIAL 1000000.

  dCustomizationResultObj = DECIMAL({fnarg getUserProperty 'CustomizationResultObj':U}).
  
  DEFINE BUFFER ttObjectInstance FOR ttObjectInstance.

  FOR EACH ttObjectInstance
     WHERE ttObjectInstance.d_customization_result_obj = dCustomizationResultObj
       AND ttObjectInstance.i_page                     = piSwapPage:
    
    ttObjectInstance.i_page = iTemporaryPage.
  END.

  FOR EACH ttObjectInstance
     WHERE ttObjectInstance.d_customization_result_obj = dCustomizationResultObj
       AND ttObjectInstance.i_page                     = piWithPage:

    ttObjectInstance.i_page = piSwapPage.
  END.

  FOR EACH ttObjectInstance
     WHERE ttObjectInstance.d_customization_result_obj = dCustomizationResultObj
       AND ttObjectInstance.i_page                     = iTemporaryPage:

    ttObjectInstance.i_page = piWithPage.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-toolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toolbar Procedure 
PROCEDURE toolbar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcAction   AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cDataLogicProcedure AS CHARACTER  NO-UNDO.

  DEFINE BUFFER ttSmartObject FOR ttSmartObject.

  IF NOT glToolbarDisabled THEN
    {fn evaluateActions}.

  CASE pcAction:
    WHEN "genDataLogicProcedure":U  THEN RUN launchSBODLProc   IN TARGET-PROCEDURE.
    WHEN "containerProperties":U    THEN RUN launchProperties  IN TARGET-PROCEDURE.
    WHEN "previewContainer":U       THEN RUN runContainer      IN TARGET-PROCEDURE.
    WHEN "oldProperties":U          THEN RUN oldPropertySheets IN TARGET-PROCEDURE (INPUT 0).
    WHEN "objMenuStruct":U          THEN RUN launchMenuStruct  IN TARGET-PROCEDURE.
    WHEN "pageSequence":U           THEN RUN launchSequencing  IN TARGET-PROCEDURE.
    WHEN "locateObject":U           THEN RUN launchLocator     IN TARGET-PROCEDURE (INPUT TARGET-PROCEDURE, INPUT TARGET-PROCEDURE).
    WHEN "launchLinks":U            THEN RUN launchLinks       IN TARGET-PROCEDURE (INPUT TRUE,  INPUT 0.00).
    WHEN "launchPages":U            THEN RUN launchPages       IN TARGET-PROCEDURE (INPUT TRUE,  INPUT 0).
    WHEN "Preferences":U            THEN RUN launchPreferences IN TARGET-PROCEDURE.
    WHEN "Save":U                   THEN RUN saveContainer     IN TARGET-PROCEDURE (INPUT FALSE, INPUT FALSE).
    WHEN "Delete":U                 THEN RUN deleteContainer   IN TARGET-PROCEDURE.
    WHEN "New":U                    THEN RUN addRecord         IN TARGET-PROCEDURE. /* Used to run add record, but find record is now used for program flow reasons */
    WHEN "Open":U                   THEN RUN findRecord        IN TARGET-PROCEDURE.
    WHEN "Cancel":U                 THEN RUN cancelRecord      IN TARGET-PROCEDURE.
    WHEN "Undo":U                   THEN RUN resetRecord       IN TARGET-PROCEDURE.

    WHEN "SuperProcedure":U THEN
    DO:
      FIND FIRST ttSmartObject
           WHERE ttSmartObject.d_smartobject_obj         <> 0.00
             AND ttSmartObject.d_customization_result_obj = DECIMAL({fnarg getUserProperty 'CustomizationResultObj':U}) NO-ERROR.

      RUN editRyObjectInAB IN ghDesignManager (INPUT ttSmartobject.c_custom_super_procedure,
                                               INPUT ttSmartobject.d_custom_smartobject_obj).
    END.

    WHEN "DataLogicProcedure":U THEN
    DO:
      FIND FIRST ttSmartObject
           WHERE ttSmartObject.d_smartobject_obj         <> 0.00
             AND ttSmartObject.d_customization_result_obj = DECIMAL({fnarg getUserProperty 'CustomizationResultObj':U}) NO-ERROR.

      cDataLogicProcedure = {fnarg getAttributeValue "?, 'DataLogicProcedure':U}.

      RUN editRyObjectInAB IN ghDesignManager (INPUT cDataLogicProcedure,
                                               INPUT 0.00).
    END.

    OTHERWISE RUN SUPER (INPUT pcAction).
  END CASE.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-transferToExcel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE transferToExcel Procedure 
PROCEDURE transferToExcel :
/*------------------------------------------------------------------------------
  Purpose:  Transfers the contents of a browser to Excel

  Parameters:  INPUT phBrowse          - The handle of the browse that needs to
                                         be exported to Excel
               INPUT phContainerSource - The handle of the container the browse
                                         is on (needed for the container's title)

  Notes:  The browse is used to export the data to Excel seeing that there might
          be calculated fields in the browse that you would not be able to pick
          up from the query associated with the browse.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phBrowse           AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER phContainerSource  AS HANDLE     NO-UNDO.

  DEFINE VARIABLE chWorkSheet       AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE chWorkbook        AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE chColumns         AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE chExcel           AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE chRange           AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE cCustomCode       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRange            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lExcelInstalled   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSensitive        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iSelectedRow      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCurrentRow       AS INTEGER    NO-UNDO INITIAL 1.
  DEFINE VARIABLE iReposRow         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iColumn           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRow              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hContainerHandle  AS HANDLE     NO-UNDO.

  SESSION:SET-WAIT-STATE("GENERAL":U).

  /* Check if Excel is installed. */
  IF NOT lExcelInstalled THEN DO:
    /* Only allow export to MS Excel if at least Office97 exists */
    LOAD "Excel.Application":U BASE-KEY "HKEY_CLASSES_ROOT":U NO-ERROR. /* Open Registry key */

    lExcelInstalled = NOT ERROR-STATUS:ERROR.

    UNLOAD "Excel.Application":U NO-ERROR.
  END.

  /* If Excel is not installed, inform the user and exit */
  IF NOT lExcelInstalled THEN
  DO:
    SESSION:SET-WAIT-STATE("":U).
    ASSIGN cErrorMessage = "Excel not installed or running version prior to Office 97".

    RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                           INPUT "INF":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Excel Tranfer Error",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).
    RETURN.
  END.

  /* Connect to excel if it is there, otherwhise start it up */
  CREATE "Excel.Application" chExcel CONNECT NO-ERROR.

  IF NOT VALID-HANDLE(chExcel) THEN
    CREATE "Excel.Application" chExcel.

  {get ContainerHandle hContainerHandle phContainerSource}.

  ASSIGN
      glTransferActive    = TRUE
      lSensitive          = phBrowse:SENSITIVE
      phBrowse:SENSITIVE  = FALSE
      chExcel:VISIBLE     = FALSE                    /* Launch Excel so it is visible to the user    */
      chWorkbook          = chExcel:Workbooks:ADD()  /* Create a new Workbook                        */
      chWorkSheet         = chExcel:Sheets:ITEM(1)   /* Get the active Worksheet                     */
      chWorkSheet:NAME    = "Browser Details"        /* Set the worksheet name                       */
      iSelectedRow        = phBrowse:QUERY:CURRENT-RESULT-ROW
      iReposRow           = phBrowse:FOCUSED-ROW
      cCustomCode         = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultCode":U)
      cCustomCode         = (IF cCustomCode = "?":U THEN "<Default>":U ELSE cCustomCode).
  
  /* Insert the title contents into the sheet if required */
  IF glIncludeTitle = TRUE THEN
    ASSIGN
        cRange                              = "A":U + STRING(iCurrentRow)
        chWorkSheet:Range(cRange):VALUE     = hContainerHandle:TITLE
        chWorkSheet:Range(cRange):FONT:Bold = TRUE
        iCurrentRow                         = iCurrentRow + 1
        cRange                              = "A":U + STRING(iCurrentRow)
        chWorkSheet:Range(cRange):VALUE     = "Result Code:"
        chWorkSheet:Range(cRange):FONT:Bold = TRUE
        iCurrentRow                         = iCurrentRow + 2.

  /* Insert column headings */
  DO iColumn = 1 TO phBrowse:NUM-COLUMNS:
    ASSIGN
        cRange                              = CHR(ASC("A":U) + iColumn - 1) + STRING(iCurrentRow)
        cLabel                              = TRIM(phBrowse:GET-BROWSE-COLUMN(iColumn):LABEL)
        cLabel                              = (IF INDEX(cLabel, "!":U) <> 0 THEN REPLACE(cLabel, "!":U, CHR(10)) ELSE cLabel)
        chWorkSheet:Range(cRange):VALUE     = cLabel
        chWorkSheet:Range(cRange):FONT:Bold = TRUE.
  END.

  /* Position the browse to the first row */
  phBrowse:SELECT-ROW(1).
  
  /* Step through the rows in the browse */
  DO iRow = 1 TO phBrowse:QUERY:NUM-RESULTS:
    iCurrentRow = iCurrentRow + 1.

    DO iColumn = 1 TO phBrowse:NUM-COLUMNS:
      ASSIGN
          cRange                          = CHR(ASC("A":U) + iColumn - 1) + STRING(iCurrentRow)
          chWorkSheet:Range(cRange):VALUE = phBrowse:GET-BROWSE-COLUMN(iColumn):SCREEN-VALUE.
    END.

    phBrowse:SELECT-NEXT-ROW().
  END.

  ASSIGN
      cRange    = "A":U + (IF glIncludeTitle THEN "2:":U ELSE "1:":U) + STRING((CHR(ASC("A":U) + (phBrowse:NUM-COLUMNS - 1)) + STRING(iCurrentRow)))
      chRange   = chWorkSheet:Range(cRange)
      chColumns = chRange:COLUMNS.

  chColumns:AutoFit.

  IF glIncludeTitle THEN
    chWorkSheet:Range("B2":U):VALUE = cCustomCode.

  chExcel:VISIBLE = TRUE.

  /* Make sure that the COM objects are released properly */
  IF VALID-HANDLE(chWorkSheet)  THEN RELEASE OBJECT chWorkSheet.
  IF VALID-HANDLE(chWorkbook)   THEN RELEASE OBJECT chWorkbook.
  IF VALID-HANDLE(chColumns)    THEN RELEASE OBJECT chColumns.
  IF VALID-HANDLE(chExcel)      THEN RELEASE OBJECT chExcel.
  IF VALID-HANDLE(chRange)      THEN RELEASE OBJECT chRange.

  ASSIGN
      phBrowse:SENSITIVE = lSensitive
      glTransferActive   = FALSE
      chWorkSheet        = ?
      chWorkbook         = ?
      chColumns          = ?
      chExcel            = ?
      chRange            = ?.

  /* Put the browse and the query back to the way they were */
  phBrowse:SET-REPOSITIONED-ROW(iReposRow).
  phBrowse:QUERY:REPOSITION-TO-ROW(iSelectedRow).

  SESSION:SET-WAIT-STATE("":U).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-unregisterPSObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE unregisterPSObjects Procedure 
PROCEDURE unregisterPSObjects :
/*------------------------------------------------------------------------------
  Purpose:  This procedure will unregister all the objects on the container that
            was maintained in the Container Builder from the Property Sheet

  Parameters:  INPUT pcInstanceName - The name the object is registered in the property
                                      sheet with. This is actually the object instance obj
  Notes:  
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcInstanceName AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cCustomizationResultCode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStatusDefault            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cText                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj   AS DECIMAL    NO-UNDO.

  DEFINE BUFFER ttObjectInstance FOR ttObjectInstance.
  DEFINE BUFFER ttSmartObject    FOR ttSmartObject.

  /* If the handle to the PropertySheet procedure library is not valid, then there would be nothing to unregister */
  IF NOT VALID-HANDLE(ghProcLib) THEN
    RETURN.

  dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U)).

  {get StatusDefault cStatusDefault}.

  /* See if container details were retrieved - if so, the objects would have been registered */
  FOR EACH ttSmartObject
     WHERE ttSmartObject.d_smartobject_obj <> 0.00:

    /* Unregister all objects that was part of the container */
    IF pcInstanceName = "":U THEN
    DO:
      cCustomizationResultCode = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultCode":U).

      /* Unregister all the previously registered objects */
      {set StatusDefault "'Unregistering from Property Sheet: All instances...'"}.
      
      RUN unregisterObject IN ghProcLib (INPUT TARGET-PROCEDURE,               /* Calling procedure */
                                         INPUT ttSmartObject.d_smartobject_obj, /* Container Name    */
                                         INPUT "*":U).                          /* Object Name       */

      RUN displayProperties IN ghProcLib (TARGET-PROCEDURE, ttSmartObject.d_smartobject_obj, "":U, cCustomizationResultCode, TRUE, 0).
    END.
    ELSE
    DO:
      FIND FIRST ttObjectInstance
           WHERE ttObjectInstance.d_object_instance_obj = DECIMAL(pcInstanceName).

      cText = "Unregistering from Property Sheet: ":U + ttObjectInstance.c_instance_name + "...".

      {set StatusDefault cText}.

      /* Unregister the specified object */
      RUN unregisterObject IN ghProcLib (INPUT TARGET-PROCEDURE,               /* Calling procedure */
                                         INPUT ttSmartObject.d_smartobject_obj, /* Container Name    */
                                         INPUT pcInstanceName).                 /* Object Name       */
    END.
  END.

  {set StatusDefault cStatusDefault}.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-checkChildWindows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION checkChildWindows Procedure 
FUNCTION checkChildWindows RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: to check if child windows open from this window - use to give warning
           when closing window with X or ESC 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iLoop             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTargets          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hHandle           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lChildren         AS LOGICAL    NO-UNDO.

  {get containerTarget cTargets}.

  Target-loop:
  DO iLoop = 1 TO NUM-ENTRIES(cTargets):

    hHandle = WIDGET-HANDLE(ENTRY(iLoop, cTargets)) NO-ERROR.
    
    IF VALID-HANDLE(hHandle) AND
       INDEX(hHandle:FILE-NAME, "rydyncontw":U) <> 0 THEN
    DO:
      {get WindowFrameHandle hHandle hHandle}.

      IF VALID-HANDLE(hHandle) AND
         hHandle:VISIBLE       THEN
      DO:
        lChildren = YES.
        LEAVE Target-loop.    
      END.
    END.
  END.

  IF lChildren = TRUE THEN
    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "promptForChildWindows":U, "YES":U).
  ELSE
    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "promptForChildWindows":U, "NO":U).

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableEnabledActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION disableEnabledActions Procedure 
FUNCTION disableEnabledActions RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, gcEnabledActions).

  glToolbarDisabled = TRUE.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION displayAttribute Procedure 
FUNCTION displayAttribute RETURNS LOGICAL
  (pdObjectInstanceObj AS DECIMAL,
   pcAttributeLabel    AS CHARACTER,
   phWidget            AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAttributeValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cListItems      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntry          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lInvalid        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCounter        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEntry          AS INTEGER    NO-UNDO.

  cAttributeValue = {fnarg getAttributeValue "pdObjectInstanceObj, pcAttributeLabel"}.

  CASE phWidget:TYPE:
    WHEN "COMBO-BOX":U  THEN
    DO:
      IF CAN-QUERY(phWidget, "LIST-ITEMS":U) AND cAttributeValue <> "":U THEN
      DO:
        DO iEntry = 1 TO NUM-ENTRIES(cAttributeValue):
          cEntry = TRIM(ENTRY(iEntry, cAttributeValue)).

          IF LOOKUP(cEntry, phWidget:LIST-ITEMS, phWidget:DELIMITER) = 0 THEN
            lInvalid = TRUE.
        END.
        
        DO iCounter = 1 TO NUM-ENTRIES(phWidget:LIST-ITEMS, phWidget:DELIMITER):
          IF ENTRY(iCounter, phWidget:LIST-ITEMS, phWidget:DELIMITER) MATCHES "*(*** INVALID)":U THEN
            NEXT.

          cListItems = cListItems
                     + phWidget:DELIMITER
                     + ENTRY(iCounter, phWidget:LIST-ITEMS, phWidget:DELIMITER).
        END.

        IF lInvalid THEN
          ASSIGN
              cListItems            = cListItems + (IF cListItems = "":U THEN "":U ELSE phWidget:DELIMITER)
                                    + cAttributeValue + " (*** INVALID)":U
              phWidget:LIST-ITEMS   = cListItems
              phWidget:SCREEN-VALUE = phWidget:ENTRY(NUM-ENTRIES(phWidget:LIST-ITEMS, phWidget:DELIMITER)).
        ELSE
        DO:
          IF LOOKUP(cAttributeValue, phWidget:LIST-ITEMS, phWidget:DELIMITER) = 0 THEN
            cListItems = cListItems + (IF cListItems = "":U THEN "":U ELSE phWidget:DELIMITER)
                       + cAttributeValue.

          ASSIGN
              phWidget:LIST-ITEMS   = cListItems
              phWidget:SCREEN-VALUE = cAttributeValue.
        END.
      END.
    END.

    WHEN "RADIO-SET":U  OR
    WHEN "FILL-IN":U    THEN phWidget:SCREEN-VALUE = cAttributeValue NO-ERROR.

    WHEN "TOGGLE-BOX":U THEN phWidget:CHECKED      = (cAttributeValue = "yes":U) NO-ERROR.
  END CASE.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-evaluateActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION evaluateActions Procedure 
FUNCTION evaluateActions RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDisabledActions  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContainerMode    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lFrameContainer   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDataContainer    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDataLogicProc    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lHasSuper         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSuccess          AS LOGICAL    NO-UNDO.

  DEFINE BUFFER ttSmartObject FOR ttSmartObject.

  ASSIGN
      lFrameContainer = {fnarg getUserProperty 'FrameContainer'} = "yes":U
      lDataContainer  = {fnarg getUserProperty 'DataContainer'} = "yes":U
      cContainerMode  = {fnarg getUserProperty 'ContainerMode'}
      lDataLogicProc  = ({fnarg getAttributeValue "?, 'DataLogicProcedure':U} <> "":U).

  FIND FIRST ttSmartObject
       WHERE ttSmartObject.d_smartobject_obj         <> 0.00
         AND ttSmartObject.d_customization_result_obj = DECIMAL({fnarg getUserProperty 'CustomizationResultObj':U}) NO-ERROR.

  IF AVAILABLE ttSmartObject AND (ttSmartObject.d_custom_smartobject_obj <> 0.00 
                              OR  ttSmartObject.c_custom_super_procedure <> "":U) THEN
    lHasSuper = TRUE.

  CASE cContainerMode:
    WHEN "ADD":U THEN
      ASSIGN
          cDisabledActions = "New,cbDelete,cbFind,cbUndo,CntainerPreview,cbGenDataLogic":U
                           + (IF lDataContainer THEN ",Pages,objMenuStruct,cbPageSequence":U
                                                ELSE (IF lFrameContainer THEN ",objMenuStruct":U ELSE "":U))
                           + (IF lHasSuper      THEN "":U ELSE ",cbEditCustomObj":U)
                           + (IF lDataLogicProc THEN "":U ELSE ",cbEditDataLogic":U)
          gcEnabledActions = "cbSave,cbCancel,Links,cbObjectLocator,Properties,Pref":U
                           + (IF lDataContainer THEN "":U
                                                ELSE (IF lFrameContainer THEN ",Pages,cbPageSequence":U ELSE ",Pages,objMenuStruct,cbPageSequence":U))
                           + (IF lHasSuper      THEN ",cbEditCustomObj":U ELSE "":U)
                           + (IF lDataLogicProc THEN ",cbEditDataLogic":U ELSE "":U)
          lSuccess         = DYNAMIC-FUNCTION("setDisabledActions":U IN ghToolbar, cDisabledActions)
          lSuccess         = DYNAMIC-FUNCTION("disableActions":U     IN ghToolbar, cDisabledActions)
          lSuccess         = DYNAMIC-FUNCTION("enableActions":U      IN ghToolbar, gcEnabledActions).

    WHEN "FIND":U THEN
      ASSIGN
          cDisabledActions = "cbCancel,cbDelete,cbFind,cbSave,cbUndo,CntainerPreview,Properties,Pages,Links,cbPageSequence,cbObjectLocator,objMenuStruct":U
                           + ",cbEditCustomObj,cbGenDataLogic,cbEditDataLogic":U
          gcEnabledActions = "New,Pref":U
          lSuccess         = DYNAMIC-FUNCTION("setDisabledActions":U IN ghToolbar, cDisabledActions)
          lSuccess         = DYNAMIC-FUNCTION("disableActions":U     IN ghToolbar, cDisabledActions)
          lSuccess         = DYNAMIC-FUNCTION("enableActions":U      IN ghToolbar, gcEnabledActions).

    WHEN "INITIAL":U THEN
      ASSIGN
          cDisabledActions = "cbDelete,cbSave,cbUndo,cbCancel,CntainerPreview,Properties,Pages,Links,objMenuStruct":U
                           + ",cbEditCustomObj,cbGenDataLogic,cbEditDataLogic":U
          gcEnabledActions = "New,cbFind":U
          lSuccess         = DYNAMIC-FUNCTION("setDisabledActions":U IN ghToolbar, cDisabledActions)
          lSuccess         = DYNAMIC-FUNCTION("disableActions":U     IN ghToolbar, cDisabledActions)
          lSuccess         = DYNAMIC-FUNCTION("enableActions":U      IN ghToolbar, gcEnabledActions).

    WHEN "MODIFY":U THEN
      ASSIGN
          cDisabledActions = "cbCancel,cbSave,cbUndo":U
                           + (IF lDataContainer THEN ",Pages,objMenuStruct,CntainerPreview,cbPageSequence":U
                                                ELSE (IF lFrameContainer THEN ",objMenuStruct,CntainerPreview":U ELSE ",cbGenDataLogic":U))
                           + (IF lHasSuper      THEN "":U ELSE ",cbEditCustomObj":U)
                           + (IF lDataLogicProc THEN "":U ELSE ",cbEditDataLogic":U)
          gcEnabledActions = "New,cbDelete,cbFind,Links,Properties,cbObjectLocator,Pref":U
                           + (IF lDataContainer THEN ",cbGenDataLogic":U  ELSE (IF lFrameContainer THEN ",Pages,cbPageSequence":U ELSE ",Pages,cbPageSequence,objMenuStruct,CntainerPreview":U))
                           + (IF lHasSuper      THEN ",cbEditCustomObj":U ELSE "":U)
                           + (IF lDataLogicProc THEN ",cbEditDataLogic":U ELSE "":U)
          lSuccess         = DYNAMIC-FUNCTION("setDisabledActions":U IN ghToolbar, cDisabledActions)
          lSuccess         = DYNAMIC-FUNCTION("disableActions":U     IN ghToolbar, cDisabledActions)
          lSuccess         = DYNAMIC-FUNCTION("enableActions":U      IN ghToolbar, gcEnabledActions).

    WHEN "UPDATE":U THEN
      ASSIGN
          cDisabledActions = "New,cbDelete,cbFind,cbCancel,CntainerPreview":U
                           + (IF lDataContainer THEN ",Pages,objMenuStruct,cbPageSequence":U
                                                ELSE (IF lFrameContainer THEN ",objMenuStruct":U ELSE ",cbGenDataLogic":U))
                           + (IF lHasSuper      THEN "":U ELSE ",cbEditCustomObj":U)
                           + (IF lDataLogicProc THEN "":U ELSE ",cbEditDataLogic":U)
          gcEnabledActions = "cbSave,cbUndo,Links,cbObjectLocator,Properties,Pref":U
                           + (IF lDataContainer THEN ",cbGenDataLogic":U  ELSE (IF lFrameContainer THEN ",Pages,cbPageSequence":U ELSE ",Pages,objMenuStruct,cbPageSequence":U))
                           + (IF lHasSuper      THEN ",cbEditCustomObj":U ELSE "":U)
                           + (IF lDataLogicProc THEN ",cbEditDataLogic":U ELSE "":U)
          lSuccess         = DYNAMIC-FUNCTION("setDisabledActions":U IN ghToolbar, cDisabledActions)
          lSuccess         = DYNAMIC-FUNCTION("disableActions":U     IN ghToolbar, cDisabledActions)
          lSuccess         = DYNAMIC-FUNCTION("enableActions":U      IN ghToolbar, gcEnabledActions).
  END CASE.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAttributeValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAttributeValue Procedure 
FUNCTION getAttributeValue RETURNS CHARACTER
  (pdObjectInstanceObj AS DECIMAL,
   pcAttributeLabel    AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAttributeValue         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dObjectInstanceObj      AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dSmartObjectObj         AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dObjectTypeObj          AS DECIMAL    NO-UNDO.

  DEFINE BUFFER ttObjectInstance  FOR ttObjectInstance.
  DEFINE BUFFER ttAttributeValue  FOR ttAttributeValue.
  DEFINE BUFFER ttSmartObject     FOR ttSmartObject.

  dCustomizationResultObj = DECIMAL({fnarg getUserProperty 'CustomizationResultObj'}).

  FIND FIRST ttSmartObject
       WHERE ttSmartObject.d_customization_result_obj = dCustomizationResultObj
         AND ttSmartObject.d_smartobject_obj         <> 0.00 NO-ERROR.

  IF NOT AVAILABLE ttSmartObject THEN
    RETURN "":U.

  IF pdObjectInstanceObj <> ? THEN
  DO:
    FIND FIRST ttObjectInstance
         WHERE ttObjectInstance.d_object_instance_obj = pdObjectInstanceObj.

    ASSIGN
        dObjectInstanceObj = ttObjectInstance.d_object_instance_obj
        dSmartObjectObj    = ttObjectInstance.d_smartobject_obj
        dObjectTypeObj     = ttObjectInstance.d_object_type_obj.
  END.
  ELSE
    ASSIGN
        dObjectInstanceObj = 0.00
        dSmartObjectObj    = ttSmartObject.d_smartobject_obj
        dObjectTypeObj     = ttSmartObject.d_object_type_obj.

  FIND FIRST ttAttributeValue
       WHERE ttAttributeValue.d_customization_result_obj = dCustomizationResultObj
         AND ttAttributeValue.d_object_instance_obj      = dObjectInstanceObj
         AND ttAttributeValue.d_smartobject_obj          = dSmartObjectObj
         AND ttAttributeValue.d_object_type_obj          = dObjectTypeObj
         AND ttAttributeValue.c_attribute_label          = pcAttributeLabel NO-ERROR.
  
  IF NOT AVAILABLE ttAttributeValue THEN
    FIND FIRST ttAttributeValue
         WHERE ttAttributeValue.d_smartobject_obj           = ttObjectInstance.d_smartobject_obj
           AND ttAttributeValue.d_primary_smartobject_obj   = ttObjectInstance.d_smartobject_obj
           AND ttAttributeValue.d_container_smartobject_obj = 0.00
           AND ttAttributeValue.d_object_instance_obj       = 0.00
           AND ttAttributeValue.d_object_type_obj           = dObjectTypeObj
           AND ttAttributeValue.c_attribute_label           = pcAttributeLabel NO-ERROR.

  IF NOT AVAILABLE ttAttributeValue THEN
    cAttributeValue = "":U.
  ELSE
    CASE ttAttributeValue.i_data_type:
      WHEN {&DECIMAL-DATA-TYPE}   THEN cAttributeValue = STRING(ttAttributeValue.d_decimal_value) NO-ERROR.
      WHEN {&INTEGER-DATA-TYPE}   THEN cAttributeValue = STRING(ttAttributeValue.i_integer_value) NO-ERROR.
      WHEN {&DATE-DATA-TYPE}      THEN cAttributeValue = STRING(ttAttributeValue.t_date_value)    NO-ERROR.
      WHEN {&RAW-DATA-TYPE}       THEN.
      WHEN {&LOGICAL-DATA-TYPE}   THEN cAttributeValue = STRING(ttAttributeValue.l_logical_value) NO-ERROR.

      OTHERWISE cAttributeValue = ttAttributeValue.c_character_value NO-ERROR.
    END CASE.

  RETURN cAttributeValue.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentPrefs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentPrefs Procedure 
FUNCTION getCurrentPrefs RETURNS CHARACTER
  (plCurrentValues  AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPreferences    AS CHARACTER  NO-UNDO.

  IF plCurrentValues = TRUE THEN
    cPreferences = "AddPageNumber":U    + "|":U + STRING(glAddPageNumber) + "|":U
                 + "DeleteFolder":U     + "|":U + STRING(glDeleteFolder)  + "|":U
                 + "ConfirmSave":U      + "|":U + STRING(glConfirmSave)   + "|":U
                 + "HideSubtools":U     + "|":U + STRING(glHideSubtools)  + "|":U
                 + "IncludeTitle":U     + "|":U + STRING(glIncludeTitle)  + "|":U
                 + "RepositionPT":U     + "|":U + STRING(glRepositionPT)  + "|":U
                 + "DefaultMode":U      + "|":U + gcDefaultMode           + "|":U
                 + "TabVisualization":U + "|":U + gcTabVisualization      + "|":U
                 + "TabsPerRow":U       + "|":U + STRING(giTabsPerRow)    + "|":U.
  ELSE
    cPreferences = "AddPageNumber":U    + "|":U + STRING(TRUE)  + "|":U
                 + "DeleteFolder":U     + "|":U + STRING(TRUE)  + "|":U
                 + "ConfirmSave":U      + "|":U + STRING(FALSE) + "|":U
                 + "HideSubtools":U     + "|":U + STRING(TRUE)  + "|":U
                 + "IncludeTitle":U     + "|":U + STRING(TRUE)  + "|":U
                 + "RepositionPT":U     + "|":U + STRING(TRUE)  + "|":U
                 + "DefaultMode":U      + "|":U + "Open":U      + "|":U
                 + "TabVisualization":U + "|":U + "Framework":U + "|":U
                 + "TabsPerRow":U       + "|":U + STRING(7)     + "|":U.

  cPreferences = cPreferences
               + DYNAMIC-FUNCTION("getCurrentPrefs":U IN ghGridObjectViewer, INPUT plCurrentValues).

  RETURN cPreferences.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectInstanceObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectInstanceObj Procedure 
FUNCTION getObjectInstanceObj RETURNS DECIMAL
  (pcInstanceName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dObjectInstanceObj      AS DECIMAL    NO-UNDO.

  DEFINE BUFFER ttObjectInstance FOR ttObjectInstance.
  
  dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U)).

  FIND FIRST ttObjectInstance
       WHERE ttObjectInstance.d_customization_result_obj = 0.00
         AND ttObjectInstance.c_instance_name            = pcInstanceName NO-ERROR.

  IF NOT AVAILABLE ttObjectInstance THEN
    FIND FIRST ttObjectInstance
         WHERE ttObjectInstance.d_customization_result_obj = dCustomizationResultObj
           AND ttObjectInstance.c_instance_name            = pcInstanceName NO-ERROR.

  IF AVAILABLE ttObjectInstance THEN
    dObjectInstanceObj = ttObjectInstance.d_object_instance_obj.
  ELSE
    dObjectInstanceObj = 0.00.

  RETURN dObjectInstanceObj.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPageSequence) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPageSequence Procedure 
FUNCTION getPageSequence RETURNS INTEGER
  (piPageNumber AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iPageSequence           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCurrentPage            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCounter                AS INTEGER    NO-UNDO.

  DEFINE BUFFER ttPage FOR ttPage.

  ASSIGN
      dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U))
      iCounter                = 0.

  IF piPageNumber = ? THEN
    iCurrentPage = DYNAMIC-FUNCTION("getCurrentPage":U IN TARGET-PROCEDURE).
  ELSE
    iCurrentPage = piPageNumber + 1.

  Page_block:
  FOR EACH ttPage
     WHERE ttPage.d_customization_result_obj = dCustomizationResultObj
       AND ttPage.c_action                  <> "D":U
        BY ttPage.i_page_sequence:
    
    iCounter = iCounter + 1.
    
    IF iCounter = iCurrentPage THEN
    DO:
      iPageSequence = ttPage.i_page_sequence.
    
      LEAVE Page_block.
    END.
  END.

  RETURN iPageSequence.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getStatusDefault) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getStatusDefault Procedure 
FUNCTION getStatusDefault RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cStatusDefault  AS CHARACTER  NO-UNDO.

  ASSIGN
      cStatusDefault = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "statusDefault":U)
      cStatusDefault = IF cStatusDefault = ? THEN "":U ELSE cStatusDefault.

  RETURN cStatusDefault.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUniqueInstanceName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUniqueInstanceName Procedure 
FUNCTION getUniqueInstanceName RETURNS CHARACTER
  (pcInstanceName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cInstanceName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSuffix       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lFinished     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE isNumeric     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCounter      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRight        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLeft         AS INTEGER    NO-UNDO.

  DEFINE BUFFER ttObjectInstance FOR ttObjectInstance.

  IF CAN-FIND(FIRST ttObjectInstance
              WHERE ttObjectInstance.c_instance_name = pcInstanceName) THEN
  DO:
    ASSIGN
        isNumeric = FALSE
        iRight    = R-INDEX(pcInstanceName, ")":U)
        iLeft     = R-INDEX(pcInstanceName, "(":U).

    IF iRight <> 0     AND
       iLeft  <> 0     AND
       iRight  > iLeft THEN
      ASSIGN
          iCounter = INTEGER(SUBSTRING(pcInstanceName, iLeft + 1, iRight - iLeft - 1)) NO-ERROR.

    IF ERROR-STATUS:ERROR = FALSE THEN
      isNumeric = TRUE.
    ELSE
      ERROR-STATUS:ERROR = FALSE.

    ASSIGN
        cSuffix        = IF iRight <> 0 THEN TRIM(SUBSTRING(pcInstanceName, iRight + 1))  ELSE "":U
        pcInstanceName = IF isNumeric = TRUE THEN SUBSTRING(pcInstanceName, 1, iLeft - 1) ELSE pcInstanceName
        iCounter       = 0.

    DO WHILE lFinished = FALSE:
      ASSIGN
          iCounter      = iCounter + 1
          cInstanceName = pcInstanceName + "(":U + TRIM(STRING(iCounter)) + ")":U + cSuffix.

      IF NOT CAN-FIND(FIRST ttObjectInstance
                      WHERE ttObjectInstance.c_instance_name = cInstanceName) THEN
       lFinished = TRUE.
    END.
  END.
  ELSE
    cInstanceName = pcInstanceName.

  RETURN cInstanceName.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasFolder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hasFolder Procedure 
FUNCTION hasFolder RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFolderClasses  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lHasFolder      AS LOGICAL    NO-UNDO.

  DEFINE BUFFER ttObjectInstance  FOR ttObjectInstance.
  DEFINE BUFFER ttObjectType      FOR ttObjectType.

  FOR EACH ttObjectType
     WHERE LOOKUP(ttObjectType.c_object_type_code, gcFolderClasses) <> 0
       AND lHasFolder = FALSE:

    IF CAN-FIND(FIRST ttObjectInstance
                WHERE ttObjectInstance.d_object_type_obj = ttObjectType.d_object_type_obj) THEN
      lHasFolder = TRUE.
  END.

  RETURN lHasFolder.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hideSubtools) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hideSubtools Procedure 
FUNCTION hideSubtools RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN glHideSubtools.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-lockWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION lockWindow Procedure 
FUNCTION lockWindow RETURNS LOGICAL
  (plLockWindow AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iReturnCode       AS INTEGER    NO-UNDO.

  giLockWindow = giLockWindow + (IF plLockWindow THEN 1 ELSE -1).

  IF plLockWindow AND giLockWindow > 1 THEN
    RETURN FALSE.

  IF NOT plLockWindow AND giLockWindow > 0 THEN
    RETURN FALSE.
  
  IF plLockWindow AND ghContainerHandle:HWND EQ ? THEN
     RETURN FALSE.

  IF plLockWindow THEN
    RUN lockWindowUpdate IN gshSessionManager (INPUT ghContainerHandle:HWND, OUTPUT iReturnCode).
  ELSE
    RUN lockWindowUpdate IN gshSessionManager (INPUT 0, OUTPUT iReturnCode).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mySetPageNTargets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION mySetPageNTargets Procedure 
FUNCTION mySetPageNTargets RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  This function was added to let the container think there
            are objects on all the other pages even though there are
            no objects on any of the pages except page one
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFolderLabels AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPageNTargets AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCounter      AS INTEGER    NO-UNDO.
  
  /* Get the folder lables to see how many entries we need to add */
  cFolderLabels = DYNAMIC-FUNCTION("getFolderLabels":U IN ghPageSource).
  
  DO iCounter = 1 TO NUM-ENTRIES(cFolderLabels, "|":U):
    
    cPageNTargets = cPageNTargets
                  + (IF cPageNTargets = "":U THEN "":U ELSE ",":U)
                  + STRING(ghGridObjectViewer) + "|":U
                  + STRING(iCounter).
  END.
  
  {set PageNTarget cPageNTargets TARGET-PROCEDURE}.
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-restoreToolbarContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION restoreToolbarContext Procedure 
FUNCTION restoreToolbarContext RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF TRIM(gcBatchedMode) <> "":U  THEN
  DO:
    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U, gcBatchedMode).
    DYNAMIC-FUNCTION("evaluateActions":U IN TARGET-PROCEDURE).
    
    gcBatchedMode = "":U.
  END.
  ELSE
    DYNAMIC-FUNCTION("enableActions":U IN ghToolbar, gcEnabledActions).

  glToolbarDisabled = FALSE.
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectFilename) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setObjectFilename Procedure 
FUNCTION setObjectFilename RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjectFilename AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dSmartObjectObj AS DECIMAL    NO-UNDO.

  cObjectFilename = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "ObjectFilename":U).
  
  IF cObjectFilename <> ? THEN
  DO:
    FOR EACH ttSmartObject /*
       WHERE ttSmartObject.c_object_filename = "":U */ :
      
      ttSmartObject.c_object_filename = cObjectFilename.
      
      IF ttSmartObject.d_smartobject_obj <> 0.00 THEN
        dSmartObjectObj = ttSmartObject.d_smartobject_obj.
    END.

    /* If we already have the property sheet open, we need to make sure that the correct object name is reflected */
    IF DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U) = "ADD":U AND
       VALID-HANDLE(ghProcLib)                                                                THEN
    DO:
      IF cObjectFilename = "":U THEN
        cObjectFilename = "<Enter container name>":U.

      RUN changeContainerLabel IN ghProcLib (INPUT TARGET-PROCEDURE,
                                             INPUT STRING(dSmartObjectObj),
                                             INPUT cObjectFilename).

      RUN changeObjectLabel IN ghProcLib (INPUT TARGET-PROCEDURE,
                                          INPUT STRING(dSmartObjectObj),
                                          INPUT STRING(dSmartObjectObj),
                                          INPUT cObjectFilename).
    END.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setStatusDefault) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setStatusDefault Procedure 
FUNCTION setStatusDefault RETURNS LOGICAL
  (pcStatusDefault AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, "statusDefault":U, pcStatusDefault).

  SUPER(pcStatusDefault).
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-transferActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION transferActive Procedure 
FUNCTION transferActive RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN glTransferActive.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewStaticPropsheet) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION viewStaticPropsheet Procedure 
FUNCTION viewStaticPropsheet RETURNS LOGICAL
  (pcObjectTypeCode AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF gcClassChildren = "":U THEN
    gcClassChildren = REPLACE(DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "Viewer,StaticSO,DynFrame":U), CHR(3), ",":U).

  RETURN LOOKUP(pcObjectTypeCode, gcClassChildren) = 0.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

