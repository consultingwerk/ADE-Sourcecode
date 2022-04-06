&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
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
  File: rytresuprp.p

  Description:  Dynamic TreeView Super Procedure

  Purpose:      Dynamic TreeView Super Procedure

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/05/2002  Author:     Mark Davies (MIP)

  Update Notes: Created from Template rytemplipp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rytresuprp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

&GLOBAL-DEFINE define-only YES
{launch.i }

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{src/adm2/globals.i}

DEFINE VARIABLE ghTreeViewObject AS HANDLE     NO-UNDO.

/** Temp-table definition for TT used in storeAttributeValues
 *  ----------------------------------------------------------------------- **/
{ ry/inc/ryrepatset.i }
      
/** Temp-table definition for TT used in insertObjectLink
 *  ----------------------------------------------------------------------- **/
DEFINE TEMP-TABLE ttTreeSmartLink NO-UNDO
    FIELD tContainerObj   AS DECIMAL
    FIELD tLinkName       AS CHARACTER
    FIELD tUserLinkName   AS CHARACTER
    FIELD tSourceObj      AS DECIMAL
    FIELD tTargetObj      AS DECIMAL
    INDEX idxContainer
        tContainerObj
    .

/* Defines the NO-RESULT-CODE and DEFAULT-RESULT-CODE result codes. */
{ ry/app/rydefrescd.i }
      
{af/app/afdatatypi.i}

/*{ry/inc/rycntnerbi.i}*/

/** Contains definitions for all design-time API temp-tables. **/
{ry/inc/rydestdefi.i}
    
DEFINE VARIABLE ghTreeTable        AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghWindowHandle     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghContainerHandle  AS HANDLE     NO-UNDO.
DEFINE VARIABLE glAppBuilder       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glDoPrompt         AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE ghProcLib          AS HANDLE     NO-UNDO.
DEFINE VARIABLE glLockWindow       AS LOGICAL    NO-UNDO.

DEFINE VARIABLE ghDesignManager    AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getTreeTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTreeTable Procedure 
FUNCTION getTreeTable RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTreeViewName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTreeViewName Procedure 
FUNCTION getTreeViewName RETURNS CHARACTER
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

&IF DEFINED(EXCLUDE-statusText) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD statusText Procedure 
FUNCTION statusText RETURNS LOGICAL
  ( pcStatusText AS CHARACTER )  FORWARD.

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
         HEIGHT             = 24.67
         WIDTH              = 51.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-changedAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changedAttribute Procedure 
PROCEDURE changedAttribute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcAttributeLabel AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcAttributeValue AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcDataType       AS CHARACTER  NO-UNDO.
  
  FIND FIRST ttObject
       WHERE ttObject.tContainerSmartObjectObj  = 0
       AND   ttObject.tSmartObjectObj          <> 0
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ttObject THEN
    RETURN.
  
  FIND FIRST ttObjectAttribute
       WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
       AND   ttObjectAttribute.tObjectInstanceObj = 0
       AND   ttObjectAttribute.tAttributeLabel    = pcAttributeLabel
       EXCLUSIVE-LOCK NO-ERROR.
  
  IF NOT AVAILABLE ttObjectAttribute THEN DO:
    CREATE ttObjectAttribute.
    ASSIGN ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
           ttObjectAttribute.tObjectInstanceObj = 0
           ttObjectAttribute.tAttributeLabel    = pcAttributeLabel
           ttObjectAttribute.tWhereStored       = "MASTER":U
           ttObjectAttribute.tRenderTypeObj     = 0.
    CASE pcDataType:
      WHEN "DECIMAL" THEN ttObjectAttribute.tDataType = {&DECIMAL-DATA-TYPE}.
      WHEN "INTEGER" THEN ttObjectAttribute.tDataType = {&INTEGER-DATA-TYPE}.
      WHEN "DATE"    THEN ttObjectAttribute.tDataType = {&DATE-DATA-TYPE}.
      WHEN "RAW"     THEN ttObjectAttribute.tDataType = {&RAW-DATA-TYPE}.
      WHEN "LOGICAL" THEN ttObjectAttribute.tDataType = {&LOGICAL-DATA-TYPE}.
      OTHERWISE ttObjectAttribute.tDataType = {&CHARACTER-DATA-TYPE} NO-ERROR.
    END CASE.
  END.
  
  ASSIGN ttObjectAttribute.tAttributeValue = pcAttributeValue.

  RUN assignPropertyValues IN ghProcLib (INPUT TARGET-PROCEDURE,
                                         INPUT STRING(ttObject.tSmartObjectObj),
                                         INPUT STRING(ttObject.tSmartObjectObj),
                                         INPUT pcAttributeLabel + CHR(3) + "":U + CHR(3) + pcAttributeValue,
                                         INPUT "":U,
                                         INPUT TRUE).
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

  DEFINE VARIABLE cMessage            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lContainerChanges   AS LOGICAL    NO-UNDO.

  /* Get the container modes in all the related programs */
  ASSIGN
      plContinue = FALSE.
  lContainerChanges = DYNAMIC-FUNCTION("getChangesMade":U IN ghTreeViewObject).
  /* If we have any changes in any part of the container, prepare the relevant message and present the user with the prompt to save */
  IF lContainerChanges = TRUE THEN
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
      /* Finally, save the changes in the container */
      RUN toolbar IN TARGET-PROCEDURE (INPUT "Save":U) NO-ERROR.
      
      IF ERROR-STATUS:ERROR OR 
         RETURN-VALUE <> "":U THEN
        RETURN "ERROR":U.

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

&IF DEFINED(EXCLUDE-clearReurnValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearReurnValue Procedure 
PROCEDURE clearReurnValue :
/*------------------------------------------------------------------------------
  Purpose:     This will clear the RETURN-VALUE used in destroyObject to save
               deteails before exiting.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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
  DEFINE VARIABLE cRunAttr    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDFObject  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lChanges    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lClose      AS LOGICAL    NO-UNDO.
  
  IF glAppBuilder = FALSE THEN DO:
    IF glDoPrompt THEN DO:
      RUN checkIfSaved IN TARGET-PROCEDURE (INPUT  TRUE,
                                             INPUT  FALSE,
                                             OUTPUT lChanges,
                                             OUTPUT lClose).
    IF lClose = FALSE THEN
      RETURN ERROR "ADM-ERROR".  /* stop destroyobject in the container from wacking the 
                          admprops - cause we are just hiding, not destroying */
  END.
/*    
    /* Check if we need to ask the user if they want to save before closing */
    RUN dataChanged IN ghTreeViewObject.
  */  
    IF RETURN-VALUE <> "":U THEN DO:
      IF RETURN-VALUE = "DO_NOTHING":U THEN
        RETURN "ERROR":U.
      IF RETURN-VALUE = "NEED_TO_SAVE":U THEN DO:
        RUN clearReurnValue IN TARGET-PROCEDURE.
        RUN toolbar IN TARGET-PROCEDURE ("Save":U).
        /* Check if the save went well */
        IF RETURN-VALUE <> "":U THEN
          RETURN "ERROR":U.
      END.
    END.
  
    {get RunAttribute cRunAttr TARGET-PROCEDURE}.
    IF cRunAttr <> "":U THEN DO:
      hSDFObject = WIDGET-HANDLE(cRunAttr) NO-ERROR.
      IF VALID-HANDLE(hSDFObject) THEN
        DYNAMIC-FUNCTION("closeObject":U IN hSDFObject) NO-ERROR.
    END.
    
    RUN clearReurnValue IN TARGET-PROCEDURE.
  
    RUN SUPER.
  END.
  ELSE DO:
    RUN hideObject IN TARGET-PROCEDURE.
    RETURN ERROR "ADM-ERROR".  /* stop destroyobject in the container from wacking the admprops - cause we are just hiding, not destroying */
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectDetail) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getObjectDetail Procedure 
PROCEDURE getObjectDetail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcLogicalObjectName AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER phDataTable         AS HANDLE    NO-UNDO.

  DEFINE VARIABLE cButton                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataset                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dSmartObjectObj             AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cCustomSuperProcedure       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectDescription          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectType                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataTable                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDynTreeClasses             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cToolbarClasses             AS CHARACTER  NO-UNDO.

  RUN unregisterPSObjects IN TARGET-PROCEDURE (INPUT "":U).
  
  EMPTY TEMP-TABLE ttObject.
  EMPTY TEMP-TABLE ttPage.
  EMPTY TEMP-TABLE ttLink.
  EMPTY TEMP-TABLE ttObjectAttribute.
  EMPTY TEMP-TABLE ttUIEvent.
  
  /* Fetch the object from the Repository */
  IF NOT VALID-HANDLE(ghDesignManager) THEN
    ASSIGN ghDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U) NO-ERROR.
  /* Retrieve the objects and instances for the current existing object opened in the appBuilder */
  RUN retrieveDesignObject IN ghDesignManager ( INPUT  pcLogicalObjectName,
                                               INPUT  "{&DEFAULT-RESULT-CODE}",  /* Dynamic TreeView cannot be customized - retrieve default */
                                               OUTPUT TABLE ttObject,
                                               OUTPUT TABLE ttPage,
                                               OUTPUT TABLE ttLink,
                                               OUTPUT TABLE ttUiEvent,
                                               OUTPUT TABLE ttObjectAttribute ) NO-ERROR.
  
  /* Check if this is a valid object */
  FIND FIRST ttObject 
       WHERE ttObject.tLogicalObjectName = pcLogicalObjectName 
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ttObject THEN
    RETURN.

  ASSIGN dSmartObjectObj       = ttObject.tSmartObjectObj
         cObjectType           = ttObject.tClassName
         cCustomSuperProcedure = ttObject.tCustomSuperProcedure
         cCustomSuperProcedure = REPLACE(cCustomSuperProcedure,"~\":U,"/":U).
  /* Remove any relative path information - this will allow the lookup to
     find the record for the super procedure */
  IF INDEX(cCustomSuperProcedure,"/":U) > 0 THEN
    cCustomSuperProcedure = SUBSTRING(cCustomSuperProcedure,R-INDEX(cCustomSuperProcedure,"/":U) + 1).
  
  /* Get Object's Description */
  RUN getRecordDetail IN gshGenManager ( INPUT "FOR EACH ryc_smartobject 
                                                WHERE ryc_smartobject.smartobject_obj = " + TRIM(QUOTER(dSmartObjectObj)) + " NO-LOCK ":U,
                                         OUTPUT cDataset ).
  ASSIGN cObjectDescription = "":U.
  IF cDataset <> "":U AND cDataset <> ? THEN 
    ASSIGN cObjectDescription  = ENTRY(LOOKUP("ryc_smartobject.object_description":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3)) 
           NO-ERROR.
  
  cDynTreeClasses = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "DynTree":U).
  IF LOOKUP(cObjectType,cDynTreeClasses) = 0 THEN DO:
    RUN showMessages IN gshSessionManager (INPUT  "The Dynamic TreeView specified " + pcLogicalObjectName + " is not a valid TreeView object. " + cObjectType,    /* message to display */
                                           INPUT  "ERR":U,          /* error type */
                                           INPUT  "&OK,&Cancel":U,    /* button list */
                                           INPUT  "&OK":U,           /* default button */ 
                                           INPUT  "&Cancel":U,       /* cancel button */
                                           INPUT  "Not a Valid TreeView Object":U,             /* error window title */
                                           INPUT  NO,              /* display if empty */ 
                                           INPUT  ?,                /* container handle */ 
                                           OUTPUT cButton           /* button pressed */
                                          ).
    RETURN.
  END.

  hDataTable = getTreeTable().
  
  hDataTable = hDataTable:DEFAULT-BUFFER-HANDLE.
  
  hDataTable:EMPTY-TEMP-TABLE.

  hDataTable:BUFFER-CREATE().
  hDataTable:BUFFER-FIELD('cLayout':U):BUFFER-VALUE         = "TreeView":U.
  ASSIGN hDataTable:BUFFER-FIELD('cObjectDescription':U):BUFFER-VALUE = cObjectDescription
         hDataTable:BUFFER-FIELD('cCustomSuperProc':U):BUFFER-VALUE   = cCustomSuperProcedure
         hDataTable:BUFFER-FIELD('cObjectTypeCode':U):BUFFER-VALUE    = cObjectType.
  
  
  FOR EACH ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                               AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj:
    CASE ttObjectAttribute.tAttributeLabel:
      WHEN "WindowName":U THEN
        hDataTable:BUFFER-FIELD('cWindowName':U):BUFFER-VALUE     = ttObjectAttribute.tAttributeValue.
      WHEN "RootNodeCode":U THEN
        hDataTable:BUFFER-FIELD('cRootNodeCode':U):BUFFER-VALUE   = ttObjectAttribute.tAttributeValue.
      WHEN "TreeStyle":U THEN
        hDataTable:BUFFER-FIELD('iTreeStyle':U):BUFFER-VALUE      = INTEGER(ttObjectAttribute.tAttributeValue).
      WHEN "ImageHeight":U THEN
        hDataTable:BUFFER-FIELD('iImageHeight':U):BUFFER-VALUE    = INTEGER(ttObjectAttribute.tAttributeValue).
      WHEN "ImageWidth":U THEN
        hDataTable:BUFFER-FIELD('iImageWidth':U):BUFFER-VALUE     = INTEGER(ttObjectAttribute.tAttributeValue).
      WHEN "HideSelection":U THEN
        hDataTable:BUFFER-FIELD('lHideSelection':U):BUFFER-VALUE  = LOGICAL(ttObjectAttribute.tAttributeValue).
      WHEN "AutoSort":U THEN
        hDataTable:BUFFER-FIELD('lAutoSort':U):BUFFER-VALUE       = LOGICAL(ttObjectAttribute.tAttributeValue).
      WHEN "ShowCheckBoxes":U THEN
        hDataTable:BUFFER-FIELD('lShowCheckBoxes':U):BUFFER-VALUE = LOGICAL(ttObjectAttribute.tAttributeValue).
      WHEN "ShowRootLines":U THEN
        hDataTable:BUFFER-FIELD('lShowRootLines':U):BUFFER-VALUE  = LOGICAL(ttObjectAttribute.tAttributeValue).
    END CASE.
  END.

  
  /* Check for Filter Viewer */
  cToolbarClasses = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "SmartToolbar":U).
  FIND FIRST ttObject
       WHERE ttObject.tLogicalObjectName <> pcLogicalObjectName
       /* look for the first object that isn't a SmartToolbar, since a Dynamic TreeView
          will only ever have 2 instance objects, a SmartToolbar and an optional
          Filter Viewer */
       AND   LOOKUP(ttObject.tClassName,cToolbarClasses) = 0
       NO-LOCK NO-ERROR.
  IF AVAILABLE ttObject THEN
    ASSIGN hDataTable:BUFFER-FIELD('cFilterViewer':U):BUFFER-VALUE    = ttObject.tLogicalObjectName
           hDataTable:BUFFER-FIELD('cOldFilterViewer':U):BUFFER-VALUE = ttObject.tLogicalObjectName.
  ELSE
    ASSIGN hDataTable:BUFFER-FIELD('cFilterViewer':U):BUFFER-VALUE    = "":U
           hDataTable:BUFFER-FIELD('cOldFilterViewer':U):BUFFER-VALUE = "":U.
  
  phDataTable = hDataTable:HANDLE.
  hDataTable = ?.
  
  /* Register the object instances in the Property Sheet */
  RUN registerPSObjects IN TARGET-PROCEDURE (INPUT "":U).
  
  IF VALID-HANDLE(ghProcLib) THEN
    RUN displayProperties IN ghProcLib (TARGET-PROCEDURE, ttObject.tSmartObjectObj, ttObject.tSmartObjectObj, ?, ?, ?).
 
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
  DEFINE VARIABLE hToolbarSource    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainerSource  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cHiddenActions    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRunAttribute     AS CHARACTER  NO-UNDO.

  {get ContainerToolbarSource hToolbarSource}.
  
  {get RunAttribute cRunAttribute TARGET-PROCEDURE}.
  /* Hide extra actions when running from the AppBuilder property sheet */
  IF cRunAttribute <> "":U AND
     cRunAttribute BEGINS "AppBuilder":U THEN DO:
    glAppBuilder = TRUE.
    ASSIGN cHiddenActions = DYNAMIC-FUNCTION("getHiddenActions":U   IN hToolbarSource)
           cHiddenActions = cHiddenActions + (IF cHiddenActions = "":U THEN "":U ELSE ",":U)
                            + "New,cbCancel,cbCopy,cbDelete,cbFind,txtExit".
    DYNAMIC-FUNCTION("sethiddenActions":U IN hToolbarSource, cHiddenActions).
  END.
  
  ghTreeViewObject = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U IN TARGET-PROCEDURE,"DynTree-Source":U)).
  {get ContainerSource hContainerSource}.
  {get WindowFrameHandle ghWindowHandle TARGET-PROCEDURE}.
  ghWindowHandle = ghWindowHandle:PARENT.
  ghContainerHandle = DYNAMIC-FUNCTION("getContainerHandle":U IN TARGET-PROCEDURE).

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
  
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "changedAttribute" IN TARGET-PROCEDURE.

  RUN SUPER.
  
  /* Fetch the object from the Repository */
  IF NOT VALID-HANDLE(ghDesignManager) THEN
    ASSIGN ghDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U) NO-ERROR.
  
  IF NOT VALID-HANDLE(ghDesignManager) THEN
      MESSAGE "The Repository Design Manager could not be found.":U VIEW-AS ALERT-BOX INFORMATION.
  
  DYNAMIC-FUNCTION("setToolbarHandle":U IN ghTreeViewObject,hToolbarSource).
  
  IF glAppBuilder THEN
    DYNAMIC-FUNCTION("assignObjectType":U IN ghTreeViewObject, INPUT ENTRY(3,cRunAttribute,CHR(3))).

  RUN viewObject IN TARGET-PROCEDURE.
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

&IF DEFINED(EXCLUDE-launchProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE launchProperties Procedure 
PROCEDURE launchProperties :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  FIND FIRST ttObject
       WHERE ttObject.tSmartObjectObj <> 0
       AND   ttObject.tContainerSmartObjectObj = 0
       AND   ttObject.tResultCode     = "{&DEFAULT-RESULT-CODE}".

  {fnarg lockWindow TRUE}.
  
  /* Launch the Property Sheet */
  RUN launchPropertyWindow IN ghProcLib.
  
  RUN displayProperties IN ghProcLib (TARGET-PROCEDURE,  ttObject.tSmartObjectObj,  ttObject.tSmartObjectObj, ?, ?, ?).

  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "PropertyChangedAttribute":U IN ghProcLib.

  {fnarg lockWindow FALSE}.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadTreeView) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadTreeView Procedure 
PROCEDURE loadTreeView :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectFileName AS CHARACTER  NO-UNDO.

  IF pcObjectFileName = "":U THEN
    RUN toolbar IN TARGET-PROCEDURE (INPUT "NEW":U).
  ELSE DO:
    RUN toolbar IN TARGET-PROCEDURE (INPUT "OPEN":U).
    RUN openTreeView IN ghTreeViewObject (INPUT pcObjectFileName).
  END.
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
      glAppBuilder = FALSE
      glDoPrompt   = FALSE.
  
  {fnarg setUserProperty "'CloseWindow', 'yes'"}.

  RUN destroyObject IN TARGET-PROCEDURE.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE newRecord Procedure 
PROCEDURE newRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectName AS CHARACTER  NO-UNDO.
  
  RUN unregisterPSObjects IN TARGET-PROCEDURE (INPUT "":U).
  
  /* Clear the Object temp-tables - leave the class and the class attribute 
     tables with their data, we won't be clearing then here */
  EMPTY TEMP-TABLE ttObject.
  EMPTY TEMP-TABLE ttPage.
  EMPTY TEMP-TABLE ttLink.
  EMPTY TEMP-TABLE ttObjectAttribute.
  EMPTY TEMP-TABLE ttUIEvent.
  
  /* If we are adding a new record then just create the container record first */
  IF pcObjectName = "":U THEN DO:
    /* Create the new record */
    CREATE ttObject.
    ASSIGN ttObject.tSmartObjectObj = -1 /* Indicates a new record was added */
           ttObject.tResultCode     = "{&DEFAULT-RESULT-CODE}"
           .
  END.
  ELSE DO:
    /* Fetch the object from the Repository */
    IF NOT VALID-HANDLE(ghDesignManager) THEN
      ASSIGN ghDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U) NO-ERROR.
    /* Retrieve the objects and instances for the current existing object opened in the appBuilder */
    RUN retrieveDesignObject IN ghDesignManager ( INPUT  pcObjectName,
                                                 INPUT  "{&DEFAULT-RESULT-CODE}",  /* Dynamic TreeView cannot be customized - retrieve default */
                                                 OUTPUT TABLE ttObject,
                                                 OUTPUT TABLE ttPage,
                                                 OUTPUT TABLE ttLink,
                                                 OUTPUT TABLE ttUiEvent,
                                                 OUTPUT TABLE ttObjectAttribute ) NO-ERROR.

  END.
  /* Register the object instances in the Property Sheet */
  RUN registerPSObjects IN TARGET-PROCEDURE (INPUT "":U).

  IF VALID-HANDLE(ghProcLib) THEN
    RUN displayProperties IN ghProcLib (TARGET-PROCEDURE, ttObject.tSmartObjectObj, ttObject.tSmartObjectObj, "":U, TRUE, 0).
  
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

ASSIGN cDescription = "Dynamic TreeView Super Procedure".

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
  
  FIND FIRST ttObject
       WHERE ttObject.tSmartObjectObj = DECIMAL(pcContainer)
         AND ttObject.tResultCode     = "{&DEFAULT-RESULT-CODE}" NO-ERROR.

  IF NOT AVAILABLE ttObject THEN
    RETURN.
  
  RUN changesMade IN ghTreeViewObject.
  
  FIND FIRST ttObjectAttribute
       WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
       AND   ttObjectAttribute.tObjectInstanceObj = 0
       AND   ttObjectAttribute.tAttributeLabel    = pcAttributeLabel
       EXCLUSIVE-LOCK NO-ERROR.
  
  IF NOT AVAILABLE ttObjectAttribute THEN DO:
    CREATE ttObjectAttribute.
    ASSIGN ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
           ttObjectAttribute.tObjectInstanceObj = 0
           ttObjectAttribute.tAttributeLabel    = pcAttributeLabel
           ttObjectAttribute.tWhereStored       = "MASTER":U
           ttObjectAttribute.tRenderTypeObj     = 0.
    CASE pcDataType:
      WHEN "DECIMAL" THEN ttObjectAttribute.tDataType = {&DECIMAL-DATA-TYPE}.
      WHEN "INTEGER" THEN ttObjectAttribute.tDataType = {&INTEGER-DATA-TYPE}.
      WHEN "DATE"    THEN ttObjectAttribute.tDataType = {&DATE-DATA-TYPE}.
      WHEN "RAW"     THEN ttObjectAttribute.tDataType = {&RAW-DATA-TYPE}.
      WHEN "LOGICAL" THEN ttObjectAttribute.tDataType = {&LOGICAL-DATA-TYPE}.
      OTHERWISE ttObjectAttribute.tDataType = {&CHARACTER-DATA-TYPE} NO-ERROR.
    END CASE.
  END.

  ASSIGN ttObjectAttribute.tAttributeValue = pcAttributeValue.
  
  PUBLISH "changedAttribute" FROM TARGET-PROCEDURE (INPUT pcAttributeLabel, INPUT pcAttributeValue).

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
  
  DEFINE VARIABLE cObjectFilename           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttributeList            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStatusDefault            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cText                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dSmartObjectObj           AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cResultCodeList           AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bttObjectAttribute FOR ttObjectAttribute.
  DEFINE BUFFER  ttObjectAttribute FOR ttObjectAttribute.

  ASSIGN
      cResultCodeList = "{&DEFAULT-RESULT-CODE}":U.

  /* Find the container's smartobject record - we can find the main container or the customized. It does not matter, we only need its name */
  FIND FIRST ttObject
       WHERE ttObject.tSmartobjectObj         <> 0
       AND   ttObject.tContainerSmartObjectObj = 0
       AND   ttObject.tResultCode              = "{&DEFAULT-RESULT-CODE}":U
       NO-LOCK NO-ERROR.

  IF NOT AVAILABLE ttObject THEN
    RETURN.

  IF ttObject.tLogicalObjectName = "":U THEN
    cObjectFilename = "<Enter container name>":U.
  ELSE
    cObjectFilename = ttObject.tLogicalObjectName.

  dSmartObjectObj = ttObject.tSmartObjectObj.

  /* Go through the objects on the container, build up their attribute strings and finally register the object */
  ASSIGN
      cAttributeList = "":U.

  /* Step through the attributes of the object instance */
  FOR EACH ttObjectAttribute
     WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
       AND ttObjectAttribute.tObjectInstanceObj = 0:

    cAttributeList = cAttributeList
                   + (IF cAttributeList = "":U THEN "":U ELSE   CHR(3))
                   + TRIM(ttObjectAttribute.tAttributeLabel) + CHR(3)
                   + "":U /*TRIM(ttObject.tResultCode)*/ + CHR(3) 
                   + ttObjectAttribute.tAttributeValue.
  END.

  cText = "Registering in Property Sheet: " + cObjectFileName + "...".

  {set StatusDefault cText}.
  /* We do not have any events for the TreeView Object or any of its instances */
  
  RUN registerObject IN ghProcLib (INPUT TARGET-PROCEDURE,                /* Calling procedure */
                                   INPUT dSmartObjectObj,                 /* Container Name    */
                                   INPUT cObjectFilename,                 /* Container Label   */
                                   INPUT dSmartObjectObj,                 /* Object Name       */
                                   INPUT cObjectFilename,                 /* Object Label      */
                                   INPUT ttObject.tClassName,             /* Object Class      */
                                   INPUT "":U,                            /* Object Class list */
                                   INPUT "MASTER":U,                      /* Object Level      */
                                   INPUT cAttributeList,                  /* Attribute list    */
                                   INPUT "":U,                            /* Event List        */
                                   INPUT "":U,                            /* Attribute Default */  
                                   INPUT "":U,                            /* Event Default     */  
                                   INPUT cResultCodeList).
  {set StatusDefault cStatusDefault}.
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeSDF) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeSDF Procedure 
PROCEDURE removeSDF :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will remove an existing SDF field
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcSDFFileName AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cErrorMessage         AS CHARACTER  NO-UNDO.

  IF NOT VALID-HANDLE(ghDesignManager) THEN
    ASSIGN ghDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U) NO-ERROR.

  IF NOT VALID-HANDLE(ghDesignManager) THEN DO:
    cErrorMessage = cErrorMessage + (IF NUM-ENTRIES(cErrorMessage,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                  {af/sup2/aferrortxt.i 'AF' '29' '' '' '"Repository Design Manager PLIP"'}.
    RETURN cErrorMessage.
  END.

  /* If everything is fine, then delete the object */
  RUN removeObject IN ghDesignManager (INPUT pcSDFFileName,
                                      INPUT "":U). /* Result Code */
  IF ERROR-STATUS:ERROR OR
     RETURN-VALUE <> "":U THEN
    RETURN RETURN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-saveTreeInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveTreeInfo Procedure 
PROCEDURE saveTreeInfo :
/*------------------------------------------------------------------------------
  Purpose:     This procedure received the temp-table from the Tree Maint tool
               and will create/modify the Tree using procedure available in the
               Repository Design Manager.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectName        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phDataTable         AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcCustomSuperProc   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcDescription       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcProductModuleCode AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcObjectTypeCode    AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cErrorMessage           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dSmartObjectObj         AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hAttributeValueBuffer   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hAttributeValueTable    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSmartLinkBuffer        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSmartLinkTable         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFilterViewer           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dInstanceSmartObjectObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dFolderObj              AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dTopToolbarObj          AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dFolderToolbarObj       AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dFilterViewerObj        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cLayoutCode             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldFilterViewer        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAttrValueSame          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE dMasterObjectObj        AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE iField                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hField                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFieldDataType          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldName              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cInheritsFromClasses    AS CHARACTER  NO-UNDO.
  
    define buffer lbStoreAttribute        for ttStoreAttribute.  

  IF NOT VALID-HANDLE(ghDesignManager) THEN
    ASSIGN ghDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U) NO-ERROR.

  IF NOT VALID-HANDLE(ghDesignManager) THEN DO:
    cErrorMessage = cErrorMessage + (IF NUM-ENTRIES(cErrorMessage,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                  {af/sup2/aferrortxt.i 'AF' '29' '' '' '"Repository Design Manager PLIP"'}.
    RETURN cErrorMessage.
  END.
  
  /* Retrieve the class and its attributes */
  RUN retrieveDesignClass IN ghDesignManager ( INPUT  pcObjectTypeCode,
                                               OUTPUT cInheritsFromClasses,
                                               OUTPUT TABLE ttClassAttribute,
                                               OUTPUT TABLE ttUiEvent,
                                               output table ttSupportedLink) NO-ERROR.
    
  dMasterObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN ghDesignManager, INPUT pcObjectName, INPUT 0) NO-ERROR.
  
  IF dMasterObjectObj = ? OR 
     dMasterObjectObj = 0 THEN DO:
    dMasterObjectObj = 0.
  END.
  
  phDataTable:FIND-LAST() NO-ERROR.
  IF NOT phDataTable:AVAILABLE THEN DO:
    cErrorMessage = cErrorMessage + (IF NUM-ENTRIES(cErrorMessage,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                  {af/sup2/aferrortxt.i 'AF' '1' '' '' '"Root node code"'}.
    RETURN cErrorMessage.
  END.
  ELSE 
    IF phDataTable:BUFFER-FIELD("cRootNodeCode":U):BUFFER-VALUE = "":U OR
       phDataTable:BUFFER-FIELD("cRootNodeCode":U):BUFFER-VALUE = ? THEN DO:
      cErrorMessage = cErrorMessage + (IF NUM-ENTRIES(cErrorMessage,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' '' '' '"Root node code"'}.
      RETURN cErrorMessage.
    END.

  
  ASSIGN cFilterViewer    = phDataTable:BUFFER-FIELD('cFilterViewer':U):BUFFER-VALUE
         cOldFilterViewer = phDataTable:BUFFER-FIELD('cOldFilterViewer':U):BUFFER-VALUE
         cLayoutCode      = phDataTable:BUFFER-FIELD('cLayout':U):BUFFER-VALUE.
  
  /* Set the attributes */
  EMPTY TEMP-TABLE ttStoreAttribute.

  IF dMasterObjectObj = 0 THEN DO:
    FIND FIRST ttObject
         WHERE ttObject.tLogicalObjectName = pcObjectName
         AND   ttObject.tResultCode        = "{&DEFAULT-RESULT-CODE}"
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ttObject THEN
      /* If not available with Object Name, check for new */
      FIND FIRST ttObject
           WHERE ttObject.tSmartObjectObj = -1
           NO-LOCK NO-ERROR.
    IF AVAILABLE ttObject THEN
      dMasterObjectObj = ttObject.tSmartObjectObj.
  END.

  IF dMasterObjectObj <> 0 THEN DO:
    FOR EACH  ttObjectAttribute
        WHERE ttObjectAttribute.tSmartObjectObj    = dMasterObjectObj
        AND   ttObjectAttribute.tObjectInstanceObj = 0
        NO-LOCK:
                  
      CREATE ttStoreAttribute.
      ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
             ttStoreAttribute.tAttributeParentObj = dMasterObjectObj
             ttStoreAttribute.tAttributeLabel     = ttObjectAttribute.tAttributeLabel
             ttStoreAttribute.tConstantValue      = NO.
      CASE ttObjectAttribute.tDataType:
        WHEN {&DECIMAL-DATA-TYPE} THEN ttStoreAttribute.tDecimalValue = DECIMAL(ttObjectAttribute.tAttributeValue).
        WHEN {&INTEGER-DATA-TYPE} THEN ttStoreAttribute.tIntegerValue = INTEGER(ttObjectAttribute.tAttributeValue).
        WHEN {&DATE-DATA-TYPE}    THEN ttStoreAttribute.tDateValue = DATE(ttObjectAttribute.tAttributeValue).
        WHEN {&RAW-DATA-TYPE}     THEN.
        WHEN {&LOGICAL-DATA-TYPE} THEN ttStoreAttribute.tLogicalValue = LOGICAL(ttObjectAttribute.tAttributeValue).
        OTHERWISE ttStoreAttribute.tCharacterValue = ttObjectAttribute.tAttributeValue.
      END CASE.
    END.
  END.    /* existing object */
  ELSE DO:
    phDataTable:FIND-FIRST() NO-ERROR.
    IF phDataTable:AVAILABLE THEN DO:
      DO iField = 1 TO phDataTable:NUM-FIELDS:
        hField = phDataTable:BUFFER-FIELD(iField).
        IF hField:NAME = "cObjectDescription":U OR  
           hField:NAME = "cLayout":U OR
           hField:NAME = "cFilterViewer":U OR 
           hField:NAME = "cOldFilterViewer":U OR
           hField:NAME = "cObjectTypeCode":U THEN
          NEXT.
        ASSIGN cFieldDataType = SUBSTRING(hField:NAME,1,1)
               cFieldName     = TRIM(SUBSTRING(hField:NAME,2,LENGTH(hField:NAME))).
    
        CREATE ttStoreAttribute.
        ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
               ttStoreAttribute.tAttributeParentObj = 0
               ttStoreAttribute.tAttributeLabel     = cFieldName
               ttStoreAttribute.tConstantValue      = NO.
        CASE cFieldDataType:
          WHEN "I":U THEN /* INTEGER */
            ttStoreAttribute.tIntegerValue = phDataTable:BUFFER-FIELD(hField:NAME):BUFFER-VALUE.
          WHEN "D":U THEN /* DECIMAL */
            ttStoreAttribute.tDecimalValue = phDataTable:BUFFER-FIELD(hField:NAME):BUFFER-VALUE.
          WHEN "L":U THEN /* LOGICAL */
            ttStoreAttribute.tLogicalValue = phDataTable:BUFFER-FIELD(hField:NAME):BUFFER-VALUE.
          WHEN "T":U THEN /* DATE */
            ttStoreAttribute.tDateValue = phDataTable:BUFFER-FIELD(hField:NAME):BUFFER-VALUE.
          OTHERWISE /* CHARACTER */
            ttStoreAttribute.tCharacterValue = phDataTable:BUFFER-FIELD(hField:NAME):BUFFER-VALUE.
        END CASE.
      END. /* iField */
    END. /* Available */
  END.    /* new object */
  
  /* First remove all the older attribute values */
  IF dMasterObjectObj <> 0 THEN DO:
    ASSIGN hAttributeValueBuffer = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE
           hAttributeValueTable  = ?.
    RUN removeAttributeValues IN ghDesignManager (INPUT hAttributeValueBuffer,           
                                                 INPUT TABLE-HANDLE hAttributeValueTable).
  END.
  
  FOR EACH ttStoreAttribute
      EXCLUSIVE-LOCK:
    FIND FIRST ttClassAttribute
         WHERE ttClassAttribute.tAttributeLabel = ttStoreAttribute.tAttributeLabel
         NO-LOCK NO-ERROR.

    IF NOT AVAILABLE ttClassAttribute THEN
      NEXT.
    lAttrValueSame = FALSE.
    CASE ttClassAttribute.tDataType:
      WHEN {&DECIMAL-DATA-TYPE} THEN
        IF DECIMAL(ttClassAttribute.tAttributeValue) = ttStoreAttribute.tDecimalValue THEN
          lAttrValueSame = TRUE.
      WHEN {&INTEGER-DATA-TYPE} THEN
        IF INTEGER(ttClassAttribute.tAttributeValue) = ttStoreAttribute.tIntegerValue THEN
          lAttrValueSame = TRUE.
      WHEN {&DATE-DATA-TYPE}    THEN
        IF DATE(ttClassAttribute.tAttributeValue) = ttStoreAttribute.tDateValue THEN
          lAttrValueSame = TRUE.
      WHEN {&LOGICAL-DATA-TYPE} THEN
        IF LOGICAL(ttClassAttribute.tAttributeValue) = ttStoreAttribute.tLogicalValue THEN
          lAttrValueSame = TRUE.
      OTHERWISE 
        IF TRIM(ttClassAttribute.tAttributeValue) = ttStoreAttribute.tCharacterValue THEN
          lAttrValueSame = TRUE.
    END CASE.
    IF lAttrValueSame THEN
      DELETE ttStoreAttribute.
    else
    /* Special cases */
    case ttStoreAttribute.tAttributeLabel:
        /* The SuperProcedure attribute and the pcCustomSuperProc
           parameter must match each other.
         */
        when 'SuperProcedure' then
        do:
          /* Handle super procedure is if it blank, otherwise, insertObjectMaster
             should be used to set it */
          IF pcCustomSuperProc = '':U THEN
          DO:
            ttStoreAttribute.tCharacterValue = pcCustomSuperProc.
            
            /* When removing the super procedure by blanking it
               out, make sure the SuperProcedureMode attribute is 
               also blanked.
             */
            if ttStoreAttribute.tCharacterValue eq '' or
               ttStoreAttribute.tCharacterValue eq ? then
            do:
                find first lbStoreAttribute where
                           lbStoreAttribute.tAttributeLabel = 'SuperProcedureMode'
                           no-error.
                /* Do nothing if there's no SuperProcedureMode attribute.
                   There's no point in creating it just to have it blanked out.
                 */
                if available lbStoreAttribute then
                   lbStoreAttribute.tCharacterValue = ''.
            end.    /* blank super procedure */
          END.  /* if pccustomsuper is blank */
        end.    /* super procedure */
    end case.    /* attribute label */
  END.    /* each attribute */
  
  ASSIGN hAttributeValueBuffer = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE
         hAttributeValueTable  = ?.
  RUN insertObjectMaster IN ghDesignManager (INPUT pcObjectName,
                                            INPUT "":U,
                                            INPUT pcProductModuleCode,
                                            INPUT pcObjectTypeCode,
                                            INPUT pcDescription,
                                            INPUT "":U,
                                            INPUT "":U,
                                            INPUT pcCustomSuperProc,
                                            INPUT FALSE,
                                            INPUT FALSE,
                                            INPUT "rydyntreew.w":U,
                                            INPUT TRUE,
                                            INPUT "":U,
                                            INPUT "":U, 
                                            INPUT cLayoutCode,
                                            INPUT hAttributeValueBuffer,
                                            INPUT TABLE-HANDLE hAttributeValueTable,
                                            OUTPUT dSmartObjectObj).

  IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
    RETURN RETURN-VALUE.

  /* Add Folder Toolbar */
  EMPTY TEMP-TABLE ttStoreAttribute.
  
  CREATE ttStoreAttribute.
  ASSIGN ttStoreAttribute.tAttributeParent    = "INSTANCE":U
         ttStoreAttribute.tAttributeParentObj = 0
         ttStoreAttribute.tAttributeLabel     = "HiddenActions":U
         ttStoreAttribute.tConstantValue      = NO
         ttStoreAttribute.tCharacterValue     = "txtOK,txtCancel".
  
  ASSIGN hAttributeValueBuffer = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE
         hAttributeValueTable  = ?.
  RUN insertObjectInstance IN ghDesignManager ( INPUT  dSmartObjectObj,                   /* pdContainerObjectObj */
                                               INPUT  "ObjcTop",                         /* Instance Object Name */
                                               INPUT  "":U,                              /* pcResultCode */
                                               INPUT  "ObjcTop",                         /* pcInstanceName */
                                               INPUT  "ObjcTop":U,                       /* pcInstanceDescription */
                                               INPUT  "top":U,                           /* pcLayoutPosition */
                                               INPUT  0,                                 /* On page 0 */
                                               INPUT  1,                                 /* Page sequence */
                                               INPUT  NO,                                /* plForceCreateNew */
                                               INPUT  hAttributeValueBuffer,             /* phAttributeValueBuffer */
                                               INPUT  TABLE-HANDLE hAttributeValueTable, /* TABLE-HANDLE phAttributeValueTable */
                                               OUTPUT dInstanceSmartObjectObj,           /* pdSmartObjectObj */
                                               OUTPUT dTopToolbarObj) NO-ERROR.
  IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
  IF cFilterViewer <> cOldFilterViewer AND 
   cOldFilterViewer <> "":U THEN DO:
    RUN removeObjectInstance IN ghDesignManager ( INPUT pcObjectName,
                                                 INPUT "{&DEFAULT-RESULT-CODE}":U,
                                                 INPUT cOldFilterViewer,           /* pcInstanceObjectName */
                                                 INPUT "":U,           /* pcInstanceName       */
                                                 INPUT "{&ALL-RESULT-CODE}":U   ) NO-ERROR.
  END.

  /* Add Filter Viewer */
  IF cFilterViewer <> "":U  THEN DO:
    EMPTY TEMP-TABLE ttStoreAttribute.
    ASSIGN hAttributeValueBuffer = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE
           hAttributeValueTable  = ?.
    RUN insertObjectInstance IN ghDesignManager ( INPUT  dSmartObjectObj,                   /* pdContainerObjectObj */
                                                 INPUT  cFilterViewer,                     /* Instance Object Name */
                                                 INPUT  "":U,                              /* pcResultCode */
                                                 INPUT  cFilterViewer,                     /* pcInstanceName */
                                                 INPUT  "Filter Viewer for TreeView":U,    /* pcInstanceDescription */
                                                 INPUT  "top":U,                           /* pcLayoutPosition */
                                                 INPUT  0,                                 /* On page 0 */
                                                 INPUT  2,                                 /* Page sequence */
                                                 INPUT  NO,                                /* plForceCreateNew */
                                                 INPUT  hAttributeValueBuffer,             /* phAttributeValueBuffer */
                                                 INPUT  TABLE-HANDLE hAttributeValueTable, /* TABLE-HANDLE phAttributeValueTable */
                                                 OUTPUT dInstanceSmartObjectObj,           /* pdSmartObjectObj */
                                                 OUTPUT dFilterViewerObj) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
  END.
  
  /* Add Links */
  EMPTY TEMP-TABLE ttTreeSmartLink.
  CREATE ttTreeSmartLink.
  ASSIGN ttTreeSmartLink.tContainerObj = dSmartObjectObj
         ttTreeSmartLink.tLinkName     = "Navigation":U
         ttTreeSmartLink.tUserLinkName = "":U
         ttTreeSmartLink.tSourceObj    = dTopToolbarObj
         ttTreeSmartLink.tTargetObj    = 0.
  
  CREATE ttTreeSmartLink.
  ASSIGN ttTreeSmartLink.tContainerObj = dSmartObjectObj
         ttTreeSmartLink.tLinkName     = "ContainerToolbar":U
         ttTreeSmartLink.tUserLinkName = "":U
         ttTreeSmartLink.tSourceObj    = dTopToolbarObj
         ttTreeSmartLink.tTargetObj    = 0.
  
  IF cFilterViewer <> "":U  THEN DO:
    CREATE ttTreeSmartLink.
    ASSIGN ttTreeSmartLink.tContainerObj = dSmartObjectObj
           ttTreeSmartLink.tLinkName     = "TreeFilter":U
           ttTreeSmartLink.tUserLinkName = "":U
           ttTreeSmartLink.tSourceObj    = dFilterViewerObj
           ttTreeSmartLink.tTargetObj    = 0.
  END.

  ASSIGN hSmartLinkBuffer = TEMP-TABLE ttTreeSmartLink:DEFAULT-BUFFER-HANDLE
         hSmartLinkTable  = ?.
  
  RUN insertObjectLinks IN ghDesignManager (INPUT dSmartObjectObj,                /* Container Object Obj */
                                           INPUT hSmartLinkBuffer,              /* hSmartLinkBuffer */
                                           INPUT TABLE-HANDLE hSmartLinkTable). /* TABLE-HANDLE hSmartLinkTable */
                                            
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
  DEFINE INPUT  PARAMETER pcAction AS CHARACTER  NO-UNDO.

  CASE pcAction:
    WHEN "NEW":U THEN DO:
      DYNAMIC-FUNCTION("clearDetails":U IN ghTreeViewObject, TRUE).
      RUN setFields IN ghTreeViewObject ("New":U).
    END.
    WHEN "Open":U THEN DO:
      DYNAMIC-FUNCTION("clearDetails":U IN ghTreeViewObject, TRUE).
      RUN setFields IN ghTreeViewObject ("Find":U).
    END.
    WHEN "Delete":U THEN
      RUN removeSDF IN ghTreeViewObject.
    WHEN "Cancel":U THEN
      RUN setFields IN ghTreeViewObject ("Cancel":U).
    WHEN "Save":U THEN DO:
      RUN validateData IN ghTreeViewObject.
      IF RETURN-VALUE = "":U THEN DO:
        RUN saveDetails IN ghTreeViewObject.
        IF RETURN-VALUE = "":U THEN 
          RUN setFields IN ghTreeViewObject ("Save":U).
        ELSE
          RETURN ERROR "SAVE_FAILED".
      END.
      ELSE
        RETURN ERROR "VALIDATION_FAILED".
    END.
    WHEN "Undo":U THEN
      RUN resetData IN ghTreeViewObject.
    WHEN "previewContainer":U THEN
      RUN previewTreeView IN ghTreeViewObject.
    WHEN "nodeMaintenance":U THEN
      RUN nodeMaintenance IN ghTreeViewObject.
    WHEN "containerProperties" THEN
        RUN launchProperties IN TARGET-PROCEDURE.
    OTHERWISE RUN SUPER (INPUT pcAction).
  END CASE.
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

  /* If the handle to the PropertySheet procedure library is not valid, then there would be nothing to unregister */
  IF NOT VALID-HANDLE(ghProcLib) THEN
    RETURN.

  /* See if container details were retrieved - if so, the objects would have been registered */
  FOR EACH ttObject
     WHERE ttObject.tSmartObjectObj <> 0:

    /* Unregister all the previously registered objects */
    {set StatusDefault "'Unregistering from Property Sheet: All instances...'"}.
    
    RUN unregisterObject IN ghProcLib (INPUT TARGET-PROCEDURE,         /* Calling procedure */
                                       INPUT ttObject.tSmartObjectObj, /* Container Name    */
                                       INPUT "*":U).                   /* Object Name       */

    RUN displayProperties IN ghProcLib (TARGET-PROCEDURE, ttObject.tSmartObjectObj, "":U, "{&DEFAULT-RESULT-CODE}", TRUE, 0).
  END.

  {set StatusDefault cStatusDefault}.

  RETURN.

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

  IF NOT glAppBuilder THEN DO:
    RUN setFields IN ghTreeViewObject (INPUT "Init").
    RUN setFields IN ghTreeViewObject (INPUT "Find").
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getTreeTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTreeTable Procedure 
FUNCTION getTreeTable RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will create the dynamic temp-table for the dynamic
            TreeView.
    Notes:  
------------------------------------------------------------------------------*/

  IF VALID-HANDLE(ghTreeTable) THEN
     RETURN ghTreeTable.
  
  CREATE TEMP-TABLE ghTreeTable.
  ghTreeTable:ADD-NEW-FIELD('cWindowName':U,       'CHARACTER':U).
  ghTreeTable:ADD-NEW-FIELD('cObjectTypeCode':U,   'CHARACTER':U).
  ghTreeTable:ADD-NEW-FIELD('cObjectDescription':U,'CHARACTER':U).
  ghTreeTable:ADD-NEW-FIELD('cCustomSuperProc':U,  'CHARACTER':U).
  ghTreeTable:ADD-NEW-FIELD('cRootNodeCode':U,     'CHARACTER':U).
  ghTreeTable:ADD-NEW-FIELD('cLayout':U,           'CHARACTER':U).
  ghTreeTable:ADD-NEW-FIELD('cFilterViewer':U,     'CHARACTER':U).
  ghTreeTable:ADD-NEW-FIELD('cOldFilterViewer':U,  'CHARACTER':U).
  ghTreeTable:ADD-NEW-FIELD('iTreeStyle':U,        'INTEGER':U,0,'',7).
  ghTreeTable:ADD-NEW-FIELD('iImageHeight':U,      'INTEGER':U,0,'',16).
  ghTreeTable:ADD-NEW-FIELD('iImageWidth':U,       'INTEGER':U,0,'',16).
  ghTreeTable:ADD-NEW-FIELD('lHideSelection':U,    'LOGICAL':U).
  ghTreeTable:ADD-NEW-FIELD('lAutoSort':U,         'LOGICAL':U,0,'',TRUE).
  ghTreeTable:ADD-NEW-FIELD('lShowCheckBoxes':U,   'LOGICAL':U).
  ghTreeTable:ADD-NEW-FIELD('lShowRootLines':U,    'LOGICAL':U,0,'',TRUE).
  
  ghTreeTable:TEMP-TABLE-PREPARE("tTreeView":U).
  
  RETURN ghTreeTable.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTreeViewName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTreeViewName Procedure 
FUNCTION getTreeViewName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTreeViewName AS CHARACTER  NO-UNDO.
  cTreeViewName = DYNAMIC-FUNCTION("getTreeViewName" IN ghTreeViewObject).
  RETURN cTreeViewName.   /* Function return value. */

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
  DEFINE VARIABLE iReturnCode AS INTEGER    NO-UNDO.

  IF glLockWindow = plLockWindow THEN
    RETURN FALSE.
  
  glLockWindow = plLockWindow.

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

&IF DEFINED(EXCLUDE-statusText) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION statusText Procedure 
FUNCTION statusText RETURNS LOGICAL
  ( pcStatusText AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets Status Text
    Notes:  
------------------------------------------------------------------------------*/
  IF VALID-HANDLE(ghWindowHandle) THEN
    STATUS DEFAULT pcStatusText IN WINDOW ghWindowHandle.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

