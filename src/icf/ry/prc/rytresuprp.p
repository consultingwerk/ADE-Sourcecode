&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
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
{ry/inc/rycntnerbi.i}
    
DEFINE VARIABLE ghRepositoryDesignManager AS HANDLE     NO-UNDO.

DEFINE VARIABLE ghTreeTable        AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghWindowHandle     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghContainerHandle  AS HANDLE     NO-UNDO.
DEFINE VARIABLE glAppBuilder       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE ghProcLib          AS HANDLE     NO-UNDO.
DEFINE VARIABLE glLockWindow       AS LOGICAL    NO-UNDO.

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
         HEIGHT             = 26.67
         WIDTH              = 51.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm/method/attribut.i}

/* _UIB-CODE-BLOCK-END */
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

  FIND FIRST ttSmartObject
     WHERE ttSmartObject.d_smartobject_obj         <> 0.00
       AND ttSmartObject.d_customization_result_obj = 0.00.

  IF NOT AVAILABLE ttSmartObject THEN
    RETURN.
  
  FIND FIRST ttAttributeValue
       WHERE ttAttributeValue.d_smartobject_obj = ttSmartObject.d_smartobject_obj
       AND   ttAttributeValue.c_attribute_label = pcAttributeLabel
       EXCLUSIVE-LOCK NO-ERROR.
  
  IF NOT AVAILABLE ttAttributeValue THEN DO:
    CREATE ttAttributeValue.
    ASSIGN ttAttributeValue.d_smartobject_obj = ttSmartObject.d_smartobject_obj
           ttAttributeValue.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj
           ttAttributeValue.c_attribute_label = pcAttributeLabel
           ttAttributeValue.c_action          = "A":U. 
    CASE pcDataType:
      WHEN "decimal" THEN ttAttributeValue.i_data_type = {&DECIMAL-DATA-TYPE}.
      WHEN "Integer" THEN ttAttributeValue.i_data_type = {&INTEGER-DATA-TYPE}.
      WHEN "Date"    THEN ttAttributeValue.i_data_type = {&DATE-DATA-TYPE}.
      WHEN "raw"     THEN ttAttributeValue.i_data_type = {&RAW-DATA-TYPE}.
      WHEN "logical" THEN ttAttributeValue.i_data_type = {&LOGICAL-DATA-TYPE}.
      OTHERWISE ttAttributeValue.i_data_type = {&CHARACTER-DATA-TYPE} NO-ERROR.
    END CASE.
  END.

  CASE pcDataType:
    WHEN "decimal"   THEN ttAttributeValue.d_decimal_value   = DECIMAL(pcAttributeValue) NO-ERROR.
    WHEN "Integer"   THEN ttAttributeValue.i_integer_value   = INTEGER(pcAttributeValue) NO-ERROR.
    WHEN "Date"      THEN ttAttributeValue.t_date_value      =    DATE(pcAttributeValue) NO-ERROR.
    WHEN "raw"       THEN.
    WHEN "logical"   THEN ttAttributeValue.l_logical_value   = (pcAttributeValue = "TRUE":U OR
                                                                pcAttributeValue = "YES":U) NO-ERROR.
    OTHERWISE ttAttributeValue.c_character_value = pcAttributeValue NO-ERROR.
  END CASE.

  RUN assignPropertyValues IN ghProcLib (INPUT TARGET-PROCEDURE,
                                         INPUT STRING(ttSmartObject.d_smartobject_obj),
                                         INPUT STRING(ttSmartObject.d_smartobject_obj),
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

    RUN checkIfSaved IN TARGET-PROCEDURE (INPUT  TRUE,
                                           INPUT  FALSE,
                                           OUTPUT lChanges,
                                           OUTPUT lClose).

    IF lClose = FALSE THEN
      RETURN "ERROR".  /* stop destroyobject in the container from wacking the 
                          admprops - cause we are just hiding, not destroying */
/*    
    /* Check if we need to ask the user if they want to save before closing */
    RUN dataChanged IN ghTreeViewObject.
  */  
    IF RETURN-VALUE <> "":U THEN DO:
      IF RETURN-VALUE = "DO_NOTHING":U THEN
        RETURN ERROR "ERROR":U.
      IF RETURN-VALUE = "NEED_TO_SAVE":U THEN DO:
        RUN clearReurnValue IN TARGET-PROCEDURE.
        RUN toolbar IN TARGET-PROCEDURE ("Save":U).
        /* Check if the save went well */
        IF RETURN-VALUE <> "":U THEN
          RETURN ERROR "ERROR":U.
      END.
    END.
  /*
    {get RunAttribute cRunAttr TARGET-PROCEDURE}.
    IF cRunAttr <> "":U THEN DO:
      hSDFObject = WIDGET-HANDLE(cRunAttr) NO-ERROR.
      IF VALID-HANDLE(hSDFObject) THEN
        DYNAMIC-FUNCTION("closeObject":U IN hSDFObject) NO-ERROR.
    END.
   */ 
    RUN clearReurnValue IN TARGET-PROCEDURE.
  
    RUN SUPER.
  END.
  ELSE DO:
    RUN hideObject IN TARGET-PROCEDURE.
    RETURN ERROR "ERROR".  /* stop destroyobject in the container from wacking the admprops - cause we are just hiding, not destroying */
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchObjectInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchObjectInfo Procedure 
PROCEDURE fetchObjectInfo :
/*------------------------------------------------------------------------------
  Purpose:    Does the ServerFecthObject Call 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectName     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER phObjectBuffer   AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE hObjectTable          AS HANDLE               NO-UNDO.
  DEFINE VARIABLE hClassTable           AS HANDLE   EXTENT 26   NO-UNDO.
  DEFINE VARIABLE hPageTable            AS HANDLE               NO-UNDO.
  DEFINE VARIABLE hPageInstanceTable    AS HANDLE               NO-UNDO.
  DEFINE VARIABLE hLinkTable            AS HANDLE               NO-UNDO.
  DEFINE VARIABLE hUiEventTable         AS HANDLE               NO-UNDO.
  DEFINE VARIABLE cProperties           AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE dCurrentUserObj       AS DECIMAL              NO-UNDO.
  DEFINE VARIABLE dCurrentLanguageObj   AS DECIMAL              NO-UNDO.
  DEFINE VARIABLE iLoop                 AS INTEGER              NO-UNDO.

  ASSIGN cProperties         = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                INPUT "currentUserObj,currentLanguageObj":U,
                                                INPUT YES)
         dCurrentUserObj     = DECIMAL(ENTRY(1, cProperties, CHR(3))) 
         dCurrentLanguageObj = DECIMAL(ENTRY(2, cProperties, CHR(3)))
         NO-ERROR.

  RUN clearClientCache IN gshRepositoryManager.
  
  DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager, INPUT pcObjectName,
                                                                    INPUT "*":U, /* Result Code */
                                                                    INPUT "":U,  /* Run Attribute */
                                                                    INPUT TRUE).
  phObjectBuffer = DYNAMIC-FUNCTION("getcacheObjectBuffer":U IN gshRepositoryManager, ?).

  RETURN.

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

  DEFINE VARIABLE hObjectBuffer               AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hClassAttributeBuffer       AS HANDLE      NO-UNDO.
  DEFINE VARIABLE dContainerRecordIdentifier  AS DECIMAL     NO-UNDO.
  
  DEFINE VARIABLE cButton                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataset                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dSmartObjectObj             AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dCustomSuperProcObj         AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cCustomSuperProcedure       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectDescription          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectType                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataTable                  AS HANDLE     NO-UNDO.

  RUN unregisterPSObjects IN TARGET-PROCEDURE (INPUT "":U).
  /* Code placed here will execute PRIOR to standard behavior. */
  RUN fetchObjectInfo IN TARGET-PROCEDURE (INPUT pcLogicalObjectName, OUTPUT hObjectBuffer).
  /* Container Attribute Values */
  hObjectBuffer:FIND-FIRST(" WHERE ":U
                           + hObjectBuffer:NAME + ".tContainerObjectName = '":U + pcLogicalObjectName + "' AND ":U
                           + hObjectBuffer:NAME + ".tLogicalObjectName   = '":U + pcLogicalObjectName + "'":U
                            ) NO-ERROR.
  
  IF NOT hObjectBuffer:AVAILABLE THEN RETURN.

  ASSIGN hClassAttributeBuffer      = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
         dContainerRecordIdentifier = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
         .
  ASSIGN dSmartObjectObj = hObjectBuffer:BUFFER-FIELD("tSmartObjectObj":U):BUFFER-VALUE
         cObjectType     = hObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE.
  
  hClassAttributeBuffer:FIND-FIRST(" WHERE ":U + hClassAttributeBuffer:NAME + ".tRecordIdentifier = " + TRIM(QUOTER(dContainerRecordIdentifier))) NO-ERROR.
  
  /* Get Object's Description */
  RUN getRecordDetail IN gshGenManager ( INPUT "FOR EACH ryc_smartobject 
                                                WHERE ryc_smartobject.smartobject_obj = " + TRIM(QUOTER(dSmartObjectObj)) + " NO-LOCK ":U,
                                         OUTPUT cDataset ).
  ASSIGN cObjectDescription = "":U.
  IF cDataset <> "":U AND cDataset <> ? THEN 
    ASSIGN cObjectDescription  = ENTRY(LOOKUP("ryc_smartobject.object_description":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3)) 
           dCustomSuperProcObj = DECIMAL(ENTRY(LOOKUP("ryc_smartobject.custom_smartobject_obj":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3)))
           NO-ERROR.

  /* Get Custom Super Procedure */
  IF dCustomSuperProcObj > 0 THEN DO:
    RUN getRecordDetail IN gshGenManager ( INPUT "FOR EACH ryc_smartobject 
                                                  WHERE ryc_smartobject.smartobject_obj = " + TRIM(QUOTER(dCustomSuperProcObj)) + " NO-LOCK ":U,
                                           OUTPUT cDataset ).
    ASSIGN cCustomSuperProcedure  = "":U.
    IF cDataset <> "":U AND cDataset <> ? THEN 
      ASSIGN cCustomSuperProcedure  = ENTRY(LOOKUP("ryc_smartobject.object_filename":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3)) 
             NO-ERROR.
  END.
  
  IF cObjectType <> "DynTree"  THEN DO:
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

  hDataTable:BUFFER-CREATE().
  hDataTable:BUFFER-FIELD('cLayout':U):BUFFER-VALUE         = "TreeView":U.
  ASSIGN hDataTable:BUFFER-FIELD('cObjectDescription':U):BUFFER-VALUE = cObjectDescription
         hDataTable:BUFFER-FIELD('cCustomSuperProc':U):BUFFER-VALUE   = cCustomSuperProcedure.
  
  
  /*ASSIGN hDataTable:BUFFER-FIELD('cWindowName':U):BUFFER-VALUE     = */
  hClassAttributeBuffer:FIND-FIRST(" WHERE ":U + hClassAttributeBuffer:NAME + ".tRecordIdentifier = " + TRIM(QUOTER(dContainerRecordIdentifier))) NO-ERROR.
  IF hClassAttributeBuffer:AVAILABLE THEN
  DO:
    ASSIGN hDataTable:BUFFER-FIELD('cWindowName':U):BUFFER-VALUE     = hClassAttributeBuffer:BUFFER-FIELD("WindowName":U):BUFFER-VALUE    
           hDataTable:BUFFER-FIELD('cRootNodeCode':U):BUFFER-VALUE   = hClassAttributeBuffer:BUFFER-FIELD("RootNodeCode":U):BUFFER-VALUE 
           hDataTable:BUFFER-FIELD('iTreeStyle':U):BUFFER-VALUE      = hClassAttributeBuffer:BUFFER-FIELD("TreeStyle":U):BUFFER-VALUE   
           hDataTable:BUFFER-FIELD('iImageHeight':U):BUFFER-VALUE    = hClassAttributeBuffer:BUFFER-FIELD("ImageHeight":U):BUFFER-VALUE      
           hDataTable:BUFFER-FIELD('iImageWidth':U):BUFFER-VALUE     = hClassAttributeBuffer:BUFFER-FIELD("ImageWidth":U):BUFFER-VALUE    
           hDataTable:BUFFER-FIELD('lHideSelection':U):BUFFER-VALUE  = hClassAttributeBuffer:BUFFER-FIELD("HideSelection":U):BUFFER-VALUE  
           hDataTable:BUFFER-FIELD('lAutoSort':U):BUFFER-VALUE       = hClassAttributeBuffer:BUFFER-FIELD("AutoSort":U):BUFFER-VALUE
           hDataTable:BUFFER-FIELD('lShowCheckBoxes':U):BUFFER-VALUE = hClassAttributeBuffer:BUFFER-FIELD("ShowCheckBoxes":U):BUFFER-VALUE
           hDataTable:BUFFER-FIELD('lShowRootLines':U):BUFFER-VALUE  = hClassAttributeBuffer:BUFFER-FIELD("ShowRootLines":U):BUFFER-VALUE.
  END. /* Available Attributes */

  /* Check for Filter Viewer */
  hObjectBuffer:FIND-FIRST(" WHERE " + 
                            hObjectBuffer:NAME + ".tContainerObjectName = '" + pcLogicalObjectName + "' AND " +
                            hObjectBuffer:NAME + ".tClassName <> 'DynTree'  AND " +
                            hObjectBuffer:NAME + ".tClassName <> 'SmartToolbar'  AND " +
                            hObjectBuffer:NAME + ".tClassName <> 'SmartFolder'") NO-ERROR.
  IF hObjectBuffer:AVAILABLE THEN
    ASSIGN hDataTable:BUFFER-FIELD('cFilterViewer':U):BUFFER-VALUE    = hObjectBuffer:BUFFER-FIELD("tLogicalObjectName":U):BUFFER-VALUE
           hDataTable:BUFFER-FIELD('cOldFilterViewer':U):BUFFER-VALUE = hObjectBuffer:BUFFER-FIELD("tLogicalObjectName":U):BUFFER-VALUE.
  ELSE
    ASSIGN hDataTable:BUFFER-FIELD('cFilterViewer':U):BUFFER-VALUE    = "":U
           hDataTable:BUFFER-FIELD('cOldFilterViewer':U):BUFFER-VALUE = "":U.

  phDataTable = hDataTable:HANDLE.
  hDataTable = ?.

  DELETE OBJECT hObjectBuffer:TABLE-HANDLE NO-ERROR.
  
  /* This will clear the temp-tables if the record does not exist, or find it if it does */
  {launch.i &PLIP     = 'ry/app/rycntbplip.p'
            &IProc    = 'getContainerDetails'
            &PList    = "(INPUT  pcLogicalObjectName,
                          INPUT  '',
                          INPUT  cObjectType,
                          INPUT  0.00,
                          OUTPUT TABLE ttSmartObject,
                          OUTPUT TABLE ttPage,
                          OUTPUT TABLE ttPageObject,
                          OUTPUT TABLE ttObjectInstance,
                          OUTPUT TABLE ttAttributeValue,
                          OUTPUT TABLE ttUiEvent,
                          OUTPUT TABLE ttSmartLink,
                          OUTPUT TABLE ttObjectMenuStructure)"
            &OnApp    = 'YES'
            &AutoKill = YES}
  
  /* Register the object instances in the Property Sheet */
  RUN registerPSObjects IN TARGET-PROCEDURE (INPUT "":U).
  
  IF VALID-HANDLE(ghProcLib) THEN
    RUN displayProperties IN ghProcLib (TARGET-PROCEDURE, ttSmartObject.d_smartobject_obj, ttSmartObject.d_smartobject_obj, "":U, TRUE, 0).

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

  {get ToolbarSource hToolbarSource}.
  
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
  
  /* Enable the interface. */         
  ASSIGN ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE,
                                                      INPUT "RepositoryDesignManager":U).

  IF NOT VALID-HANDLE(ghRepositoryDesignManager) THEN
      MESSAGE "The Repository Design Manager could not be found.":U VIEW-AS ALERT-BOX INFORMATION.

  DYNAMIC-FUNCTION("setToolbarHandle":U IN ghTreeViewObject,hToolbarSource).

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
  DEFINE VARIABLE cCustomizationResultCode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj   AS DECIMAL    NO-UNDO.
  
  ASSIGN
      cCustomizationResultCode = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultCode":U)
      dCustomizationResultObj  = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U)).
  IF dCustomizationResultObj = ? THEN
    dCustomizationResultObj = 0.
  IF cCustomizationResultCode = ? THEN
    cCustomizationResultCode = "":U.
  
  FIND FIRST ttSmartObject
       WHERE ttSmartObject.d_smartobject_obj         <> 0.00
         AND ttSmartObject.d_customization_result_obj = dCustomizationResultObj.

  {fnarg lockWindow TRUE}.
  
  /* Launch the Property Sheet */
  RUN launchPropertyWindow IN ghProcLib.
  
  RUN displayProperties IN ghProcLib (TARGET-PROCEDURE, ttSmartObject.d_smartobject_obj, d_smartobject_obj, cCustomizationResultCode, TRUE, 0).

  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "PropertyChangedAttribute":U IN ghProcLib.
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "PropertyChangedEvent":U     IN ghProcLib.

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
      glAppBuilder = FALSE.

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
  /* This will clear the temp-tables if the record does not exist, or find it if it does */
  {launch.i &PLIP     = 'ry/app/rycntbplip.p'
            &IProc    = 'getContainerDetails'
            &PList    = "(INPUT  pcObjectName,
                          INPUT  '',
                          INPUT  'DynTree',
                          INPUT  0.00,
                          OUTPUT TABLE ttSmartObject,
                          OUTPUT TABLE ttPage,
                          OUTPUT TABLE ttPageObject,
                          OUTPUT TABLE ttObjectInstance,
                          OUTPUT TABLE ttAttributeValue,
                          OUTPUT TABLE ttUiEvent,
                          OUTPUT TABLE ttSmartLink,
                          OUTPUT TABLE ttObjectMenuStructure)"
            &OnApp    = 'YES'
            &AutoKill = YES}
  
  FIND FIRST ttSmartObject
       WHERE ttSmartObject.d_smartobject_obj         <> 0.00
         AND ttSmartObject.d_customization_result_obj = 0.00.

  IF ttSmartObject.c_object_filename = "":U THEN
    ttSmartObject.c_object_filename = pcObjectName.
  /* Register the object instances in the Property Sheet */
  RUN registerPSObjects IN TARGET-PROCEDURE (INPUT "":U).

  IF VALID-HANDLE(ghProcLib) THEN
    RUN displayProperties IN ghProcLib (TARGET-PROCEDURE, ttSmartObject.d_smartobject_obj, ttSmartObject.d_smartobject_obj, "":U, TRUE, 0).

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
  
  DEFINE VARIABLE cContainerMode            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj   AS DECIMAL    NO-UNDO.

  ASSIGN
      dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U))
      cContainerMode          = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U).

  IF dCustomizationResultObj = ? THEN
    dCustomizationResultObj = 0.
  FIND FIRST ttSmartObject
       WHERE ttSmartObject.d_customization_result_obj = dCustomizationResultObj
         AND ttSmartObject.d_smartobject_obj          = DECIMAL(pcContainer) NO-ERROR.

  IF NOT AVAILABLE ttSmartObject THEN
    RETURN.
  RUN changesMade IN ghTreeViewObject.
  
  FIND FIRST ttAttributeValue
       WHERE ttAttributeValue.d_smartobject_obj = ttSmartObject.d_smartobject_obj
       AND   ttAttributeValue.c_attribute_label = pcAttributeLabel
       EXCLUSIVE-LOCK NO-ERROR.
  
  IF NOT AVAILABLE ttAttributeValue THEN DO:
    CREATE ttAttributeValue.
    ASSIGN ttAttributeValue.d_smartobject_obj = ttSmartObject.d_smartobject_obj
           ttAttributeValue.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj
           ttAttributeValue.c_attribute_label = pcAttributeLabel
           ttAttributeValue.c_action          = "A":U. 
    CASE pcDataType:
      WHEN "decimal" THEN ttAttributeValue.i_data_type = {&DECIMAL-DATA-TYPE}.
      WHEN "Integer" THEN ttAttributeValue.i_data_type = {&INTEGER-DATA-TYPE}.
      WHEN "Date"    THEN ttAttributeValue.i_data_type = {&DATE-DATA-TYPE}.
      WHEN "raw"     THEN ttAttributeValue.i_data_type = {&RAW-DATA-TYPE}.
      WHEN "logical" THEN ttAttributeValue.i_data_type = {&LOGICAL-DATA-TYPE}.
      OTHERWISE ttAttributeValue.i_data_type = {&CHARACTER-DATA-TYPE} NO-ERROR.
    END CASE.
  END.

  CASE pcDataType:
    WHEN "decimal"   THEN ttAttributeValue.d_decimal_value   = DECIMAL(pcAttributeValue) NO-ERROR.
    WHEN "Integer"   THEN ttAttributeValue.i_integer_value   = INTEGER(pcAttributeValue) NO-ERROR.
    WHEN "Date"      THEN ttAttributeValue.t_date_value      =    DATE(pcAttributeValue) NO-ERROR.
    WHEN "raw"       THEN.
    WHEN "logical"   THEN ttAttributeValue.l_logical_value   = (pcAttributeValue = "TRUE":U OR
                                                                pcAttributeValue = "YES":U) NO-ERROR.
    OTHERWISE ttAttributeValue.c_character_value = pcAttributeValue NO-ERROR.
  END CASE.
  
  PUBLISH "changedAttribute" FROM TARGET-PROCEDURE (INPUT pcAttributeLabel, INPUT pcAttributeValue).

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
  DEFINE VARIABLE cObjectFilename           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttributeList            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStatusDefault            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTempValue                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEventList                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cText                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dSmartObjectObj           AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cResultCodeList           AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bttAttributeValue FOR ttAttributeValue.
  DEFINE BUFFER  ttAttributeValue FOR ttAttributeValue.
  DEFINE BUFFER  ttObjectInstance FOR ttObjectInstance.

  ASSIGN
      dCustomizationResultObj   = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U))
      cResultCodeList           = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultCode":U)
      cResultCodeList           = (IF cResultCodeList = "?":U OR cResultCodeList = ? THEN "":U ELSE cResultCodeList)
      cCustomizationResultCode  = cResultCodeList
      cResultCodeList           = (IF cResultCodeList = "":U  THEN "":U ELSE ",":U + cResultCodeList).

  IF dCustomizationResultObj = ? THEN
      dCustomizationResultObj = 0.
  IF cCustomizationResultCode = ? THEN
      cCustomizationResultCode = "":U.
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
       WHERE ttSmartObject.d_smartobject_obj <> 0.00
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
                 /*+ (IF ttSmartObject.d_customization_result_obj <> 0.00 THEN TRIM(ttUiEvent.c_customization_result_code) ELSE "":U) + CHR(3)*/
                   + cCustomizationResultCode
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
                                         INPUT "DynTree",                       /* Object Class      */
                                         INPUT "":U,                            /* Object Class list */
                                         INPUT "MASTER":U,                      /* Object Level      */
                                         INPUT cAttributeList,                  /* Attribute list    */
                                         INPUT cEventList,                      /* Event List        */
                                         INPUT "":U,                            /* Attribute Default */  
                                         INPUT "":U,                            /* Event Default     */  
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
          cAttributeList       = "":U
          cEventList           = "":U.

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
                    AND bttAttributeValue.c_attribute_label     = ttAttributeValue.c_attribute_label) THEN
        NEXT.
      
      cMasterAttributeList = cMasterAttributeList
                           + (IF cMasterAttributeList = "":U THEN "":U ELSE   CHR(3))
                           + TRIM(ttAttributeValue.c_attribute_label) + CHR(3)
                         /*+ (IF ttObjectInstance.d_customization_result_obj <> 0.00 THEN TRIM(ttAttributeValue.c_customization_result_code) ELSE "":U)*/
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
    
    /* Step through the attributes of the OBJECT instance */
    FOR EACH ttAttributeValue
       WHERE ttAttributeValue.d_object_instance_obj = ttObjectInstance.d_object_instance_obj:

      cAttributeList = cAttributeList
                     + (IF cAttributeList = "":U THEN "":U ELSE   CHR(3))
                     + TRIM(ttAttributeValue.c_attribute_label) + CHR(3)
                   /*+ (IF ttObjectInstance.d_customization_result_obj <> 0.00 THEN TRIM(ttAttributeValue.c_customization_result_code) ELSE "":U)*/
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
                 /*+ (IF ttUiEvent.d_customization_result_obj <> 0.00 THEN TRIM(ttUiEvent.c_customization_result_code) ELSE "":U) + CHR(3)*/
                   + cCustomizationResultCode
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
                                       INPUT cResultCodeList).
    END.
  END.

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

  DEFINE VARIABLE hDesignManager        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cErrorMessage         AS CHARACTER  NO-UNDO.

  ASSIGN hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).

  IF NOT VALID-HANDLE(hDesignManager) THEN DO:
    cErrorMessage = cErrorMessage + (IF NUM-ENTRIES(cErrorMessage,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                  {af/sup2/aferrortxt.i 'AF' '29' '' '' '"Repository Design Manager PLIP"'}.
    RETURN cErrorMessage.
  END.

  /* If everything is fine, then delete the object */
  RUN removeObject IN hDesignManager (INPUT pcSDFFileName,
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

  DEFINE VARIABLE hDesignManager          AS HANDLE     NO-UNDO.
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
  DEFINE VARIABLE hOTTable                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hOTBuffer               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hAttrField              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAttrValueSame          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE dMasterObjectObj        AS DECIMAL    NO-UNDO.

  ASSIGN hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).

  IF NOT VALID-HANDLE(hDesignManager) THEN DO:
    cErrorMessage = cErrorMessage + (IF NUM-ENTRIES(cErrorMessage,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                  {af/sup2/aferrortxt.i 'AF' '29' '' '' '"Repository Design Manager PLIP"'}.
    RETURN cErrorMessage.
  END.

  dMasterObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN hDesignManager, INPUT pcObjectName, INPUT 0) NO-ERROR.
  IF dMasterObjectObj = ? THEN
    dMasterObjectObj = 0.
  
  phDataTable:FIND-FIRST().
  
  ASSIGN cFilterViewer    = phDataTable:BUFFER-FIELD('cFilterViewer':U):BUFFER-VALUE
         cOldFilterViewer = phDataTable:BUFFER-FIELD('cOldFilterViewer':U):BUFFER-VALUE
         cLayoutCode      = phDataTable:BUFFER-FIELD('cLayout':U):BUFFER-VALUE.

  /* Set the attributes */
  EMPTY TEMP-TABLE ttStoreAttribute.

  IF dMasterObjectObj = 0 THEN DO:
    FIND FIRST ttSmartObject
         WHERE ttSmartObject.d_smartobject_obj         <> 0.00
         AND   ttSmartObject.d_customization_result_obj = 0.00
         NO-LOCK NO-ERROR.
    IF AVAILABLE ttSmartObject THEN
      dMasterObjectObj = ttSmartObject.d_smartobject_obj.
  END.
  
  FOR EACH  ttAttributeValue
      WHERE ttAttributeValue.d_smartobject_obj = dMasterObjectObj
      NO-LOCK:
    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = dMasterObjectObj
           ttStoreAttribute.tAttributeLabel     = ttAttributeValue.c_attribute_label
           ttStoreAttribute.tConstantValue      = NO.
    CASE ttAttributeValue.i_data_type:
      WHEN {&DECIMAL-DATA-TYPE} THEN ttStoreAttribute.tDecimalValue = ttAttributeValue.d_decimal_value.
      WHEN {&INTEGER-DATA-TYPE} THEN ttStoreAttribute.tIntegerValue = ttAttributeValue.i_integer_value.
      WHEN {&DATE-DATA-TYPE}    THEN ttStoreAttribute.tDateValue = ttAttributeValue.t_date_value.
      WHEN {&RAW-DATA-TYPE}     THEN.
      WHEN {&LOGICAL-DATA-TYPE} THEN ttStoreAttribute.tLogicalValue = ttAttributeValue.l_logical_value.
      OTHERWISE ttStoreAttribute.tCharacterValue = ttAttributeValue.c_character_value.
    END CASE.
  END.
  
  /* First remove all the older attribute values */
  IF dMasterObjectObj <> 0 THEN DO:
    ASSIGN hAttributeValueBuffer = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE
           hAttributeValueTable  = ?.
    RUN removeAttributeValues IN hDesignManager (INPUT hAttributeValueBuffer,           
                                                 INPUT TABLE-HANDLE hAttributeValueTable).
  END.

  
  /* Now we need to check which of these attributes is the same as those set in
     the class level */
  FIND FIRST ttSmartObject
       WHERE ttSmartObject.d_smartobject_obj <> 0
       NO-LOCK NO-ERROR.
  IF AVAILABLE ttSmartObject THEN DO:
    /* Create a Temp-Table that contains the valid attributes
       for this object type and their default values */
    CREATE TEMP-TABLE hOTTable.
    RUN addParentOTAttrs IN hDesignManager (INPUT ttSmartObject.d_object_type_obj,
                                            INPUT hOTTable).

    /* Prepare the temp-table */
    hOTTable:TEMP-TABLE-PREPARE("tOTAttr").

    /* Get the buffer handle for the object type handle */
    hOTBuffer = hOTTable:DEFAULT-BUFFER-HANDLE.
    
    FOR EACH ttStoreAttribute
        EXCLUSIVE-LOCK:
      lAttrValueSame = FALSE.
      ASSIGN hAttrField = hOTBuffer:BUFFER-FIELD(ttStoreAttribute.tAttributeLabel) NO-ERROR.
      ERROR-STATUS:ERROR = FALSE.

      IF NOT VALID-HANDLE(hAttrField) THEN DO:
        DELETE ttStoreAttribute.
        NEXT.
      END.
      
      CASE hAttrField:DATA-TYPE:
        WHEN "CHARACTER":U THEN
          IF TRIM(hAttrField:INITIAL) = ttStoreAttribute.tCharacterValue THEN
            lAttrValueSame = TRUE.
        WHEN "DECIMAL":U THEN
          IF DECIMAL(hAttrField:INITIAL) = ttStoreAttribute.tDecimalValue THEN
            lAttrValueSame = TRUE.
        WHEN "INTEGER":U THEN
          IF INTEGER(hAttrField:INITIAL) = ttStoreAttribute.tIntegerValue THEN
            lAttrValueSame = TRUE.
        WHEN "LOGICAL":U THEN
          IF LOGICAL(hAttrField:INITIAL) = ttStoreAttribute.tLogicalValue THEN
            lAttrValueSame = TRUE.
        WHEN "DATE":U THEN
          IF DATE(hAttrField:INITIAL) = ttStoreAttribute.tDateValue THEN
            lAttrValueSame = TRUE.
      END CASE.
      IF lAttrValueSame THEN
        DELETE ttStoreAttribute.
    END.
    DELETE OBJECT hOTTable.
  END.
  /* End: Remove attribute value records if same as class level */
  
  
  ASSIGN hAttributeValueBuffer = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE
         hAttributeValueTable  = ?.
  RUN insertObjectMaster IN hDesignManager (INPUT pcObjectName,
                                            INPUT "":U,
                                            INPUT pcProductModuleCode,
                                            INPUT "DynTree":U,
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

  /* Add Folder Window */
  EMPTY TEMP-TABLE ttStoreAttribute.
  ASSIGN hAttributeValueBuffer = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE
         hAttributeValueTable  = ?.
  RUN insertObjectInstance IN hDesignManager ( INPUT  dSmartObjectObj,                   /* pdContainerObjectObj */
                                               INPUT  "afspfoldrw.w",                    /* Instance Object Name */
                                               INPUT  "":U,                              /* pcResultCode */
                                               INPUT  "afspfoldrw.w",                    /* pcInstanceName */
                                               INPUT  "afspfoldrw.w":U,                  /* pcInstanceDescription */
                                               INPUT  "":U,                              /* pcLayoutPosition */
                                               INPUT  NO,                                /* plForceCreateNew */
                                               INPUT  hAttributeValueBuffer,             /* phAttributeValueBuffer */
                                               INPUT  TABLE-HANDLE hAttributeValueTable, /* TABLE-HANDLE phAttributeValueTable */
                                               OUTPUT dInstanceSmartObjectObj,           /* pdSmartObjectObj */
                                               OUTPUT dFolderObj) NO-ERROR.
  IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

  /* Add Top Toolbar */
  EMPTY TEMP-TABLE ttStoreAttribute.
  ASSIGN hAttributeValueBuffer = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE
         hAttributeValueTable  = ?.
  RUN insertObjectInstance IN hDesignManager ( INPUT  dSmartObjectObj,                   /* pdContainerObjectObj */
                                               INPUT  "ObjcTop",                         /* Instance Object Name */
                                               INPUT  "":U,                              /* pcResultCode */
                                               INPUT  "ObjcTop",                         /* pcInstanceName */
                                               INPUT  "ObjcTop":U,                       /* pcInstanceDescription */
                                               INPUT  "top":U,                           /* pcLayoutPosition */
                                               INPUT  NO,                                /* plForceCreateNew */
                                               INPUT  hAttributeValueBuffer,             /* phAttributeValueBuffer */
                                               INPUT  TABLE-HANDLE hAttributeValueTable, /* TABLE-HANDLE phAttributeValueTable */
                                               OUTPUT dInstanceSmartObjectObj,           /* pdSmartObjectObj */
                                               OUTPUT dTopToolbarObj) NO-ERROR.
  IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

  /* Add Folder Toolbar */
  EMPTY TEMP-TABLE ttStoreAttribute.
  
  CREATE ttStoreAttribute.
  ASSIGN ttStoreAttribute.tAttributeParent    = "INSTANCE":U
         ttStoreAttribute.tAttributeParentObj = 0
         ttStoreAttribute.tAttributeLabel     = "HiddenToolbarBands":U
         ttStoreAttribute.tConstantValue      = NO
         ttStoreAttribute.tCharacterValue     = "Navigation".

  CREATE ttStoreAttribute.
  ASSIGN ttStoreAttribute.tAttributeParent    = "INSTANCE":U
         ttStoreAttribute.tAttributeParentObj = 0
         ttStoreAttribute.tAttributeLabel     = "HiddenMenuBands":U
         ttStoreAttribute.tConstantValue      = NO
         ttStoreAttribute.tCharacterValue     = "Navigation".
  
  ASSIGN hAttributeValueBuffer = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE
         hAttributeValueTable  = ?.
  
  RUN insertObjectInstance IN hDesignManager ( INPUT  dSmartObjectObj,                   /* pdContainerObjectObj */
                                               INPUT  "FolderPageTop",                   /* Instance Object Name */
                                               INPUT  "":U,                              /* pcResultCode */
                                               INPUT  "FolderPageTop",                   /* pcInstanceName */
                                               INPUT  "FolderPageTop":U,                 /* pcInstanceDescription */
                                               INPUT  "centre":U,                        /* pcLayoutPosition */
                                               INPUT  NO,                                /* plForceCreateNew */
                                               INPUT  hAttributeValueBuffer,             /* phAttributeValueBuffer */
                                               INPUT  TABLE-HANDLE hAttributeValueTable, /* TABLE-HANDLE phAttributeValueTable */
                                               OUTPUT dInstanceSmartObjectObj,           /* pdSmartObjectObj */
                                               OUTPUT dFolderToolbarObj) NO-ERROR.
  IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
  
  /* Add Filter Viewer */
  IF cFilterViewer <> "":U  THEN DO:
    EMPTY TEMP-TABLE ttStoreAttribute.
    ASSIGN hAttributeValueBuffer = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE
           hAttributeValueTable  = ?.
    RUN insertObjectInstance IN hDesignManager ( INPUT  dSmartObjectObj,                   /* pdContainerObjectObj */
                                                 INPUT  cFilterViewer,                     /* Instance Object Name */
                                                 INPUT  "":U,                              /* pcResultCode */
                                                 INPUT  cFilterViewer,                     /* pcInstanceName */
                                                 INPUT  "Filter Viewer for TreeView":U,    /* pcInstanceDescription */
                                                 INPUT  "top":U,                           /* pcLayoutPosition */
                                                 INPUT  NO,                                /* plForceCreateNew */
                                                 INPUT  hAttributeValueBuffer,             /* phAttributeValueBuffer */
                                                 INPUT  TABLE-HANDLE hAttributeValueTable, /* TABLE-HANDLE phAttributeValueTable */
                                                 OUTPUT dInstanceSmartObjectObj,           /* pdSmartObjectObj */
                                                 OUTPUT dFilterViewerObj) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
  END.
  IF cFilterViewer = "":U AND cOldFilterViewer <> "":U THEN DO:
    RUN removeObjectInstance IN hDesignManager ( INPUT pcObjectName,
                                                 INPUT "{&DEFAULT-RESULT-CODE}":U,
                                                 INPUT cOldFilterViewer,           /* pcInstanceObjectName */
                                                 INPUT "":U,                       /* pcInstanceName       */
                                                 INPUT "{&ALL-RESULT-CODE}":U   ) NO-ERROR.
  END.
  /* Add Links */
  EMPTY TEMP-TABLE ttTreeSmartLink.
  CREATE ttTreeSmartLink.
  ASSIGN ttTreeSmartLink.tContainerObj = dSmartObjectObj
         ttTreeSmartLink.tLinkName     = "Page":U
         ttTreeSmartLink.tUserLinkName = "":U
         ttTreeSmartLink.tSourceObj    = dFolderObj
         ttTreeSmartLink.tTargetObj    = 0.

  CREATE ttTreeSmartLink.
  ASSIGN ttTreeSmartLink.tContainerObj = dSmartObjectObj
         ttTreeSmartLink.tLinkName     = "Navigation":U
         ttTreeSmartLink.tUserLinkName = "":U
         ttTreeSmartLink.tSourceObj    = dTopToolbarObj
         ttTreeSmartLink.tTargetObj    = 0.
  
  CREATE ttTreeSmartLink.
  ASSIGN ttTreeSmartLink.tContainerObj = dSmartObjectObj
         ttTreeSmartLink.tLinkName     = "Toolbar":U
         ttTreeSmartLink.tUserLinkName = "":U
         ttTreeSmartLink.tSourceObj    = dTopToolbarObj
         ttTreeSmartLink.tTargetObj    = 0.
  
  CREATE ttTreeSmartLink.
  ASSIGN ttTreeSmartLink.tContainerObj = dSmartObjectObj
         ttTreeSmartLink.tLinkName     = "TableIO":U
         ttTreeSmartLink.tUserLinkName = "":U
         ttTreeSmartLink.tSourceObj    = dFolderToolbarObj
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
  
  RUN insertObjectLinks IN hDesignManager (INPUT dSmartObjectObj,                /* Container Object Obj */
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
  DEFINE VARIABLE dCustomizationResultObj   AS DECIMAL    NO-UNDO.

  DEFINE BUFFER ttObjectInstance FOR ttObjectInstance.
  DEFINE BUFFER ttSmartObject    FOR ttSmartObject.

  /* If the handle to the PropertySheet procedure library is not valid, then there would be nothing to unregister */
  IF NOT VALID-HANDLE(ghProcLib) THEN
    RETURN.

  dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultObj":U)).
  IF dCustomizationResultObj = ? THEN
      dCustomizationResultObj = 0.
 

  /* See if container details were retrieved - if so, the objects would have been registered */
  FOR EACH ttSmartObject
     WHERE ttSmartObject.d_smartobject_obj <> 0.00:

    /* Unregister all objects that was part of the container */
    IF pcInstanceName = "":U THEN
    DO:
      cCustomizationResultCode = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "CustomizationResultCode":U).
      IF cCustomizationResultCode = ? THEN
          cCustomizationResultCode = "":U.
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
  ghTreeTable:ADD-NEW-FIELD('cObjectDescription':U,'CHARACTER':U).
  ghTreeTable:ADD-NEW-FIELD('cCustomSuperProc':U,  'CHARACTER':U).
  ghTreeTable:ADD-NEW-FIELD('cRootNodeCode':U,     'CHARACTER':U).
  ghTreeTable:ADD-NEW-FIELD('cLayout':U,           'CHARACTER':U).
  ghTreeTable:ADD-NEW-FIELD('cFilterViewer':U,     'CHARACTER':U).
  ghTreeTable:ADD-NEW-FIELD('cOldFilterViewer':U,  'CHARACTER':U).
  ghTreeTable:ADD-NEW-FIELD('iTreeStyle':U,        'INTEGER':U).
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

