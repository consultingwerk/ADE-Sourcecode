&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
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
/****************************************************************************
* Copyright (C) 1984-2005,2007 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions               *
* contributed by participants of Possenet.                                  *
*                                                                           *
****************************************************************************/
/*---------------------------------------------------------------------------------
  File: rysdfsuprp.p

  Description:  SmartDataField Super Procedure

  Purpose:      SmartDataField Super Procedure

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

&scop object-name       rysdfsuprp.p
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

DEFINE VARIABLE ghSDFObject AS HANDLE     NO-UNDO.

/** Temp-table definition for TT used in storeAttributeValues
 *  ----------------------------------------------------------------------- **/
{ ry/inc/ryrepatset.i }

/* Defines the NO-RESULT-CODE and DEFAULT-RESULT-CODE result codes. */
{ ry/app/rydefrescd.i }

/** Contains definitions for all design-time API temp-tables. **/
{ry/inc/rydestdefi.i}

/* Defines pre-processor variable for data types */
{af/app/afdatatypi.i}

DEFINE VARIABLE ghDesignManager AS HANDLE     NO-UNDO.

DEFINE VARIABLE ghComboTable    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghLookupTable   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghWindowHandle  AS HANDLE     NO-UNDO.
DEFINE VARIABLE glInitialized   AS LOGICAL    NO-UNDO.

DEFINE VARIABLE gcComboClasses  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLookupClasses AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghSDFProc       AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-assignAttributeValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignAttributeValue Procedure 
FUNCTION assignAttributeValue RETURNS LOGICAL
  ( phDataTable      AS HANDLE,
    pcAttributeLabel AS CHARACTER,
    pcAttributeValue AS CHARACTER,
    pcObjectType     AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getComboTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getComboTable Procedure 
FUNCTION getComboTable RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLookupTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLookupTable Procedure 
FUNCTION getLookupTable RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSDFProcHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSDFProcHandle Procedure 
FUNCTION getSDFProcHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSDFProcHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSDFProcHandle Procedure 
FUNCTION setSDFProcHandle RETURNS LOGICAL
  ( phProc AS HANDLE )  FORWARD.

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
   Compile into: 
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
         HEIGHT             = 18.81
         WIDTH              = 51.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */
 
{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-clearReturnValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearReturnValue Procedure 
PROCEDURE clearReturnValue :
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

  /* Check if we need to ask the user if they want to save before closing */
  RUN dataChanged IN ghSDFObject.
  
  IF RETURN-VALUE <> "":U THEN DO:
    IF RETURN-VALUE = "DO_NOTHING":U THEN
      RETURN ERROR "ERROR":U.
    IF RETURN-VALUE = "NEED_TO_SAVE":U THEN DO:
      RUN clearReturnValue IN TARGET-PROCEDURE.
      RUN toolbar IN TARGET-PROCEDURE ("Save":U).
      /* Check if the save went well */
      IF RETURN-VALUE <> "":U THEN
        RETURN ERROR "ERROR":U.
    END.
  END.

  {get RunAttribute cRunAttr TARGET-PROCEDURE}.
  IF cRunAttr <> "":U THEN DO:
    hSDFObject = WIDGET-HANDLE(ENTRY(1,cRunAttr,CHR(3))) NO-ERROR.
    IF VALID-HANDLE(hSDFObject) THEN
      DYNAMIC-FUNCTION("closeObject":U IN hSDFObject) NO-ERROR.
  END.
  
  RUN clearReturnValue IN TARGET-PROCEDURE.
  
  RUN SUPER.

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
  DEFINE VARIABLE cProductModuleCode          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cInheritsFromClasses        AS CHARACTER  NO-UNDO.

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
         cProductModuleCode    = ttObject.tProductModuleCode.
  
  IF NOT CAN-FIND(FIRST ttClassAttribute 
                  WHERE ttClassAttribute.tClassName = cObjectType) THEN
    /* Retrieve the class and its attributes */
    RUN retrieveDesignClass IN ghDesignManager ( INPUT  cObjectType,
                                                 OUTPUT cInheritsFromClasses,
                                                 OUTPUT TABLE ttClassAttribute,
                                                 OUTPUT TABLE ttUiEvent,
                                                 OUTPUT TABLE ttSupportedLink ) NO-ERROR.

  
  /* Get Object's Description */
  RUN getRecordDetail IN gshGenManager ( INPUT "FOR EACH ryc_smartobject 
                                                WHERE ryc_smartobject.smartobject_obj = " + TRIM(QUOTER(dSmartObjectObj)) + " NO-LOCK ":U,
                                         OUTPUT cDataset ).
  ASSIGN cObjectDescription  = "":U.

  IF cDataset <> "":U AND cDataset <> ? THEN 
    ASSIGN cObjectDescription  = ENTRY(LOOKUP("ryc_smartobject.object_description":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3)) 
           NO-ERROR.

  IF LOOKUP(cObjectType, gcComboClasses)  = 0 AND
     LOOKUP(cObjectType, gcLookupClasses) = 0
  THEN DO:
    RUN showMessages IN gshSessionManager (INPUT  "The SmartObject specified " + pcLogicalObjectName + " is not a valid SDF object - valid types are Dynamic Combo and Dynamic Lookup. " + cObjectType,    /* message to display */
                                           INPUT  "ERR":U,          /* error type */
                                           INPUT  "&OK,&Cancel":U,    /* button list */
                                           INPUT  "&OK":U,           /* default button */ 
                                           INPUT  "&Cancel":U,       /* cancel button */
                                           INPUT  "Not a Valid SDF Object":U,             /* error window title */
                                           INPUT  NO,              /* display if empty */ 
                                           INPUT  ?,                /* container handle */ 
                                           OUTPUT cButton           /* button pressed */
                                          ).
    RETURN.
  END.

  IF LOOKUP(cObjectType, gcComboClasses) <> 0 THEN
      ASSIGN hDataTable = getComboTable().
  ELSE
      ASSIGN hDataTable = getLookupTable().

  hDataTable = hDataTable:DEFAULT-BUFFER-HANDLE.

  hDataTable:BUFFER-CREATE().
  ASSIGN hDataTable:BUFFER-FIELD("cSDFFileName":U):BUFFER-VALUE       = pcLogicalObjectName
         hDataTable:BUFFER-FIELD("cObjectDescription":U):BUFFER-VALUE = cObjectDescription
         hDataTable:BUFFER-FIELD("cCustomSuperProc":U):BUFFER-VALUE   = cCustomSuperProcedure
         hDataTable:BUFFER-FIELD("cProductModule":U):BUFFER-VALUE     = cProductModuleCode.

  /* First assign default attribute values from the class */
  FOR EACH  ttClassAttribute 
      WHERE ttClassAttribute.tClassName = cObjectType:
    DYNAMIC-FUNCTION("assignAttributeValue":U IN TARGET-PROCEDURE, INPUT hDataTable, 
                                                                   INPUT ttClassAttribute.tAttributeLabel, 
                                                                   INPUT ttClassAttribute.tAttributeValue,
                                                                   INPUT cObjectType).
  END. /* Available Attributes */
  /* Now assign attribute values from the Master object */
  FOR EACH ttObjectAttribute 
      WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
      AND   ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj:
    DYNAMIC-FUNCTION("assignAttributeValue":U IN TARGET-PROCEDURE, INPUT hDataTable, 
                                                                   INPUT ttObjectAttribute.tAttributeLabel, 
                                                                   INPUT ttObjectAttribute.tAttributeValue,
                                                                   INPUT cObjectType).
  END. /* Available Attributes */

  phDataTable = hDataTable:HANDLE.
  hDataTable = ?.

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

  ASSIGN gcComboClasses  = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "dynLookup,dynCombo":U)
         gcLookupClasses = ENTRY(1, gcComboClasses, CHR(3))
         gcComboClasses  = ENTRY(2, gcComboClasses, CHR(3)).
  
  {get ContainerToolbarSource hToolbarSource}.
  
  ghSDFObject = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U IN TARGET-PROCEDURE,"SmartDataField-Source":U)).
  {get ContainerSource hContainerSource}.
  {get WindowFrameHandle ghWindowHandle TARGET-PROCEDURE}.
  ghWindowHandle = ghWindowHandle:PARENT.
  RUN SUPER.
  
  /* Enable the interface. */         
  ASSIGN ghDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE,
                                                      INPUT "RepositoryDesignManager":U).
  IF NOT VALID-HANDLE(ghDesignManager) THEN
      MESSAGE "The Repository Design Manager could not be found.":U VIEW-AS ALERT-BOX INFORMATION.

  DYNAMIC-FUNCTION("setToolbarHandle":U IN ghSDFObject,hToolbarSource).
  
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

&IF DEFINED(EXCLUDE-objectDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription Procedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.

ASSIGN cDescription = "Dynamic SDF PLIP".

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
  DEFINE VARIABLE cWhereUsed            AS CHARACTER  NO-UNDO.

  ASSIGN hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).

  IF NOT VALID-HANDLE(hDesignManager) THEN DO:
    cErrorMessage = cErrorMessage + (IF NUM-ENTRIES(cErrorMessage,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                  {af/sup2/aferrortxt.i 'AF' '29' '' '' '"Repository Design Manager PLIP"'}.
    RETURN cErrorMessage.
  END.

  /* We need to do some validation to check that we do not remove an SDF
     if it is used somewhere on other objects */
  {launch.i &PLIP  = 'ry/app/rysdfusedp.p' 
              &IPROC = 'whereSDFUsed' 
              &ONAPP = 'YES'
              &PLIST = "(INPUT pcSDFFileName, OUTPUT cWhereUsed)"
              &AUTOKILL = YES}
              
  IF cWhereUsed <> "":U THEN DO:
    cErrorMessage = cErrorMessage + (IF NUM-ENTRIES(cErrorMessage,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                  {af/sup2/aferrortxt.i 'AF' '101' '' '' '"object"' '"instances of it"' '"Use the Where Used function to find out where it is used and removed those instances before atempting to delete it."'}.
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

&IF DEFINED(EXCLUDE-saveSDFInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveSDFInfo Procedure 
PROCEDURE saveSDFInfo :
/*------------------------------------------------------------------------------
  Purpose:     This procedure received the temp-table from the SDF Maint tool
               and will create/modify the SDF using procedure available in the
               Repository Design Manager.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phDataTable         AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcSDFType           AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcProductModuleCode AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cErrorMessage         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dSmartObjectObj       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hAttributeValueBuffer AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hAttributeValueTable  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iField                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hField                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFieldDataType        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldName            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAttrValueSame        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE dMasterObjectObj      AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cInheritsFromClasses  AS CHARACTER  NO-UNDO.

  ASSIGN ghDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).

  IF NOT VALID-HANDLE(ghDesignManager) THEN DO:
    cErrorMessage = cErrorMessage + (IF NUM-ENTRIES(cErrorMessage,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                  {af/sup2/aferrortxt.i 'AF' '29' '' '' '"Repository Design Manager PLIP"'}.
    RETURN cErrorMessage.
  END.

  phDataTable:FIND-FIRST().
  
  /* See if you can find the SDF smartobject_obj */ 
  IF phDataTable:BUFFER-FIELD("cSDFFileName":U):BUFFER-VALUE <> "":U THEN
    dMasterObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN ghDesignManager, INPUT phDataTable:BUFFER-FIELD("cSDFFileName":U):BUFFER-VALUE, INPUT 0) NO-ERROR.
  IF dMasterObjectObj = ? THEN
    dMasterObjectObj = 0.
     
   
  EMPTY TEMP-TABLE ttStoreAttribute.

  DO iField = 1 TO phDataTable:NUM-FIELDS:
    hField = phDataTable:BUFFER-FIELD(iField).
    IF hField:NAME = "cSDFTemplate":U OR  
       hField:NAME = "cObjectDescription":U OR
       hField:NAME = "cCustomSuperProc":U OR 
       hField:NAME = "cProductModule":U OR
       hField:NAME = "cActualField":U THEN
      NEXT.
    ASSIGN cFieldDataType = SUBSTRING(hField:NAME,1,1)
           cFieldName     = TRIM(SUBSTRING(hField:NAME,2,LENGTH(hField:NAME))).
    IF cFieldName = "FieldWidth":U THEN
      cFieldName = "WIDTH-CHARS":U.

    CREATE ttStoreAttribute.
    ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
           ttStoreAttribute.tAttributeParentObj = dMasterObjectObj
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
  END.
/**
  /* Some extra attributes required */
  CREATE ttStoreAttribute.
  ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
         ttStoreAttribute.tAttributeParentObj = dMasterObjectObj
         ttStoreAttribute.tAttributeLabel     = "DisplayField":U
         ttStoreAttribute.tConstantValue      = NO
         ttStoreAttribute.tLogicalValue       = TRUE.
  
  CREATE ttStoreAttribute.
  ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
         ttStoreAttribute.tAttributeParentObj = dMasterObjectObj
         ttStoreAttribute.tAttributeLabel     = "EnableField":U
         ttStoreAttribute.tConstantValue      = NO
         ttStoreAttribute.tLogicalValue       = TRUE.
   **/
  CREATE ttStoreAttribute.
  ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
         ttStoreAttribute.tAttributeParentObj = dMasterObjectObj
         ttStoreAttribute.tAttributeLabel     = "HideOnInit":U
         ttStoreAttribute.tConstantValue      = NO
         ttStoreAttribute.tLogicalValue       = FALSE.
   
  CREATE ttStoreAttribute.
  ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
         ttStoreAttribute.tAttributeParentObj = dMasterObjectObj
         ttStoreAttribute.tAttributeLabel     = "DisableOnInit":U
         ttStoreAttribute.tConstantValue      = NO
         ttStoreAttribute.tLogicalValue       = FALSE.
  

  /* First remove all the older attribute values */
  IF dMasterObjectObj <> 0 THEN DO:
    ASSIGN hAttributeValueBuffer = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE
           hAttributeValueTable  = ?.
    RUN removeAttributeValues IN ghDesignManager (INPUT hAttributeValueBuffer,           
                                                 INPUT TABLE-HANDLE hAttributeValueTable).
  END.
  /* Now we need to check which of these attributes is the same as those set in
     the class level */
  IF NOT CAN-FIND(FIRST ttClassAttribute 
                  WHERE ttClassAttribute.tClassName = pcSDFType) THEN
    /* Retrieve the class and its attributes */
    RUN retrieveDesignClass IN ghDesignManager ( INPUT  pcSDFType,
                                                 OUTPUT cInheritsFromClasses,
                                                 OUTPUT TABLE ttClassAttribute,
                                                 OUTPUT TABLE ttUiEvent,
                                                 OUTPUT TABLE ttSupportedLink ) NO-ERROR.

  FOR EACH ttStoreAttribute
      EXCLUSIVE-LOCK:
    FIND FIRST ttClassAttribute
         WHERE ttClassAttribute.tClassName      = pcSDFType
         AND   ttClassAttribute.tAttributeLabel = ttStoreAttribute.tAttributeLabel
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
  END.
  /* End: Remove attribute value records if same as class level */


  ASSIGN hAttributeValueBuffer = TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE
         hAttributeValueTable  = ?.
  
  RUN insertObjectMaster IN ghDesignManager (INPUT phDataTable:BUFFER-FIELD("cSDFFileName":U):BUFFER-VALUE,
                                            INPUT "":U,
                                            INPUT pcProductModuleCode,
                                            INPUT pcSDFType,
                                            INPUT phDataTable:BUFFER-FIELD("cObjectDescription":U):BUFFER-VALUE,
                                            INPUT "":U,
                                            INPUT "":U,
                                            INPUT phDataTable:BUFFER-FIELD("cCustomSuperProc":U):BUFFER-VALUE,
                                            INPUT FALSE,
                                            INPUT FALSE,
                                            INPUT "",  /* Physical Object Name */
                                            INPUT TRUE,
                                            INPUT phDataTable:BUFFER-FIELD("cFieldTooltip":U):BUFFER-VALUE,
                                            INPUT "":U, 
                                            INPUT "":U,
                                            INPUT hAttributeValueBuffer,
                                            INPUT TABLE-HANDLE hAttributeValueTable,
                                            OUTPUT dSmartObjectObj).

  IF ERROR-STATUS:ERROR OR
     RETURN-VALUE <> "":U THEN
    RETURN RETURN-VALUE.




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
      DYNAMIC-FUNCTION("clearDetails":U IN ghSDFObject, TRUE).
      RUN setFields IN ghSDFObject ("New":U).
    END.
    WHEN "Open":U THEN DO:
      DYNAMIC-FUNCTION("clearDetails":U IN ghSDFObject, TRUE).
      RUN setFields IN ghSDFObject ("Find":U).
    END.
    WHEN "Delete":U THEN DO:
      RUN removeSDF IN ghSDFObject.
    END.
    WHEN "Cancel":U THEN
      RUN setFields IN ghSDFObject ("Cancel":U).
    WHEN "Save":U THEN DO:
      /*This trigger is executed for a flat button, which does not accept FOCUS.
        Because this, if the focus is in the browser, the row-leave trigger is never fired, the
        apply entry forces the row-leave to be fired. Part of the fix for OE00022099.*/
      APPLY "ENTRY":U TO SELF.
      RUN validateData IN ghSDFObject.
      IF RETURN-VALUE = "":U THEN DO:
        RUN saveDetails IN ghSDFObject.
        IF RETURN-VALUE = "":U THEN 
          RUN setFields IN ghSDFObject ("Save":U).
        ELSE
          IF RETURN-VALUE <> "STATIC_SDF":U THEN
          RETURN ERROR "SAVE_FAILED".
      END.
      ELSE
        RETURN ERROR "VALIDATION_FAILED".
    END.
    WHEN "SaveAs" THEN
      RUN saveAs IN ghSDFObject.
    WHEN "Undo":U THEN DO:
      RUN resetData IN ghSDFObject.
    END.
    OTHERWISE
       RUN SUPER (pcAction).
  END CASE.
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
  
  RUN setFields IN ghSDFObject (INPUT "Init").
  RUN setFields IN ghSDFObject (INPUT "Find").

  IF glInitialized = TRUE THEN DO:
    RUN checkForStaticSDF IN ghSDFObject.
    IF RETURN-VALUE = "EXIT":U THEN
      RUN destroyObject IN TARGET-PROCEDURE.
  END.
  glInitialized = TRUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-assignAttributeValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignAttributeValue Procedure 
FUNCTION assignAttributeValue RETURNS LOGICAL
  ( phDataTable      AS HANDLE,
    pcAttributeLabel AS CHARACTER,
    pcAttributeValue AS CHARACTER,
    pcObjectType     AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE pcAttributeLabel:
    WHEN "SDFTemplate":U THEN
      phDataTable:BUFFER-FIELD("cSDFTemplate":U):BUFFER-VALUE                 = pcAttributeValue.
    WHEN "DisplayedField":U THEN
      phDataTable:BUFFER-FIELD("cDisplayedField":U):BUFFER-VALUE              = pcAttributeValue.
    WHEN "KeyField":U THEN
      phDataTable:BUFFER-FIELD("cKeyField":U):BUFFER-VALUE                    = pcAttributeValue.
    WHEN "FieldLabel":U THEN
      phDataTable:BUFFER-FIELD("cFieldLabel":U):BUFFER-VALUE                  = pcAttributeValue.
    WHEN "FieldTooltip":U THEN
      phDataTable:BUFFER-FIELD("cFieldTooltip":U):BUFFER-VALUE                = pcAttributeValue.
    WHEN "KeyFormat":U THEN
      phDataTable:BUFFER-FIELD("cKeyFormat":U):BUFFER-VALUE                   = pcAttributeValue.
    WHEN "KeyDataType":U THEN
      phDataTable:BUFFER-FIELD("cKeyDataType":U):BUFFER-VALUE                 = pcAttributeValue. 
    WHEN "DisplayFormat":U THEN
      phDataTable:BUFFER-FIELD("cDisplayFormat":U):BUFFER-VALUE               = pcAttributeValue. 
    WHEN "DisplayDataType":U THEN
      phDataTable:BUFFER-FIELD("cDisplayDataType":U):BUFFER-VALUE             = pcAttributeValue. 
    WHEN "BaseQueryString":U THEN
      phDataTable:BUFFER-FIELD("cBaseQueryString":U):BUFFER-VALUE             = pcAttributeValue. 
    WHEN "QueryTables":U THEN
      phDataTable:BUFFER-FIELD("cQueryTables":U):BUFFER-VALUE                 = pcAttributeValue. 
    WHEN "PhysicalTableNames":U THEN
      phDataTable:BUFFER-FIELD("cPhysicalTableNames":U):BUFFER-VALUE          = pcAttributeValue. 
    WHEN "TempTables":U THEN
      phDataTable:BUFFER-FIELD("cTempTables":U):BUFFER-VALUE                  = pcAttributeValue. 
    WHEN "ParentField":U THEN
      phDataTable:BUFFER-FIELD("cParentField":U):BUFFER-VALUE                 = pcAttributeValue. 
    WHEN "ParentFilterQuery":U THEN
      phDataTable:BUFFER-FIELD("cParentFilterQuery":U):BUFFER-VALUE           = pcAttributeValue.
    WHEN "WIDTH-CHARS":U THEN
      phDataTable:BUFFER-FIELD("dFieldWidth":U):BUFFER-VALUE                  = DECIMAL(pcAttributeValue).
    WHEN "QueryBuilderJoinCode":U THEN
      phDataTable:BUFFER-FIELD('cQueryBuilderJoinCode':U):BUFFER-VALUE        = pcAttributeValue. 
    WHEN "QueryBuilderOptionList":U THEN
      phDataTable:BUFFER-FIELD('cQueryBuilderOptionList':U):BUFFER-VALUE      = pcAttributeValue. 
    WHEN "QueryBuilderOrderList":U THEN
      phDataTable:BUFFER-FIELD('cQueryBuilderOrderList':U):BUFFER-VALUE       = pcAttributeValue. 
    WHEN "QueryBuilderTableOptionList":U THEN
      phDataTable:BUFFER-FIELD('cQueryBuilderTableOptionList':U):BUFFER-VALUE = pcAttributeValue.
    WHEN "QueryBuilderTuneOptions":U THEN
      phDataTable:BUFFER-FIELD('cQueryBuilderTuneOptions':U):BUFFER-VALUE     = pcAttributeValue. 
    WHEN "QueryBuilderWhereClauses":U THEN
      phDataTable:BUFFER-FIELD('cQueryBuilderWhereClauses':U):BUFFER-VALUE    = pcAttributeValue.
    WHEN "EnableField":U THEN
      phDataTable:BUFFER-FIELD('lEnableField':U):BUFFER-VALUE                 = LOGICAL(pcAttributeValue).
    WHEN "DisplayField":U THEN
      phDataTable:BUFFER-FIELD('lDisplayField':U):BUFFER-VALUE                = LOGICAL(pcAttributeValue).
    WHEN "Sort":U THEN
      phDataTable:BUFFER-FIELD('lSort':U):BUFFER-VALUE                        = LOGICAL(pcAttributeValue).
    WHEN "UseCache":U THEN
      phDataTable:BUFFER-FIELD('lUseCache':U):BUFFER-VALUE                    = LOGICAL(pcAttributeValue).
  END. /* CASE */
  IF LOOKUP(pcObjectType, gcComboClasses) <> 0 THEN
    CASE pcAttributeLabel:
      WHEN "DescSubstitute":U THEN
        phDataTable:BUFFER-FIELD("cDescSubstitute":U):BUFFER-VALUE = pcAttributeValue. 
      WHEN "ComboFlag":U THEN
        phDataTable:BUFFER-FIELD("cComboFlag":U):BUFFER-VALUE      = pcAttributeValue. 
      WHEN "FlagValue":U THEN
        phDataTable:BUFFER-FIELD("cFlagValue":U):BUFFER-VALUE      = pcAttributeValue. 
      WHEN "InnerLines":U THEN
        phDataTable:BUFFER-FIELD("iInnerLines":U):BUFFER-VALUE     = INTEGER(pcAttributeValue).
      WHEN "BuildSequence":U THEN
        phDataTable:BUFFER-FIELD("iBuildSequence":U):BUFFER-VALUE  = INTEGER(pcAttributeValue).
      WHEN "DataSourceName":U THEN
        phDataTable:BUFFER-FIELD("cDataSourceName":U):BUFFER-VALUE = pcAttributeValue.
    END. /* case */
  ELSE
    CASE pcAttributeLabel:
      WHEN "BrowseFields":U THEN
        phDataTable:BUFFER-FIELD("cBrowseFields":U):BUFFER-VALUE           = pcAttributeValue. 
      WHEN "ColumnLabels":U THEN
        phDataTable:BUFFER-FIELD("cColumnLabels":U):BUFFER-VALUE           = pcAttributeValue. 
      WHEN "ColumnFormat":U THEN
        phDataTable:BUFFER-FIELD("cColumnFormat":U):BUFFER-VALUE           = pcAttributeValue. 
      WHEN "BrowseFieldDataTypes":U THEN
        phDataTable:BUFFER-FIELD("cBrowseFieldDataTypes":U):BUFFER-VALUE   = pcAttributeValue. 
      WHEN "BrowseFieldFormats":U THEN
        phDataTable:BUFFER-FIELD("cBrowseFieldFormats":U):BUFFER-VALUE     = pcAttributeValue. 
      WHEN "RowsToBatch":U THEN
        phDataTable:BUFFER-FIELD("iRowsToBatch":U):BUFFER-VALUE            = INTEGER(pcAttributeValue).
      WHEN "BrowseTitle":U THEN
        phDataTable:BUFFER-FIELD("cBrowseTitle":U):BUFFER-VALUE            = pcAttributeValue. 
      WHEN "ViewerLinkedFields":U THEN
        phDataTable:BUFFER-FIELD("cViewerLinkedFields":U):BUFFER-VALUE     = pcAttributeValue. 
      WHEN "LinkedFieldDataTypes":U THEN
        phDataTable:BUFFER-FIELD("cLinkedFieldDataTypes":U):BUFFER-VALUE   = pcAttributeValue. 
      WHEN "LinkedFieldFormats":U THEN
        phDataTable:BUFFER-FIELD("cLinkedFieldFormats":U):BUFFER-VALUE     = pcAttributeValue. 
      WHEN "ViewerLinkedWidgets":U THEN
        phDataTable:BUFFER-FIELD("cViewerLinkedWidgets":U):BUFFER-VALUE    = pcAttributeValue. 
      WHEN "LookupImage":U THEN
        phDataTable:BUFFER-FIELD("cLookupImage":U):BUFFER-VALUE            = pcAttributeValue. 
      WHEN "MaintenanceObject":U THEN
        phDataTable:BUFFER-FIELD("cMaintenanceObject":U):BUFFER-VALUE      = pcAttributeValue. 
      WHEN "MaintenanceSDO":U THEN
        phDataTable:BUFFER-FIELD("cMaintenanceSDO":U):BUFFER-VALUE         = pcAttributeValue.
      WHEN "PopupOnAmbiguous":U THEN
        phDataTable:BUFFER-FIELD("lPopupOnAmbiguous":U):BUFFER-VALUE       = LOGICAL(pcAttributeValue).
      WHEN "PopupOnUniqueAmbiguous":U THEN
        phDataTable:BUFFER-FIELD("lPopupOnUniqueAmbiguous":U):BUFFER-VALUE = LOGICAL(pcAttributeValue).
      WHEN "PopupOnNotAvail":U THEN
        phDataTable:BUFFER-FIELD("lPopupOnNotAvail":U):BUFFER-VALUE        = LOGICAL(pcAttributeValue).
      WHEN "BlankOnNotAvail":U THEN
        phDataTable:BUFFER-FIELD("lBlankOnNotAvail":U):BUFFER-VALUE        = LOGICAL(pcAttributeValue).
      WHEN "MappedFields":U THEN
        phDataTable:BUFFER-FIELD('cMappedFields':U):BUFFER-VALUE           = pcAttributeValue.
    END. /* case */

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getComboTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getComboTable Procedure 
FUNCTION getComboTable RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will create the dynamic temp-table for the dynamic
            lookup.
    Notes:  
------------------------------------------------------------------------------*/

  IF VALID-HANDLE(ghComboTable) THEN
     RETURN ghComboTable.
  
  CREATE TEMP-TABLE ghComboTable.
  ghComboTable:ADD-NEW-FIELD('cActualField':U,          'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('cSDFFileName':U,          'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('cSDFTemplate':U,          'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('cObjectDescription':U,    'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('cProductModule':U,        'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('cDisplayedField':U,       'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('cDescSubstitute':U,       'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('cKeyField':U,             'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('cFieldLabel':U,           'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('lLabels':U,               'LOGICAL':U).
  ghComboTable:ADD-NEW-FIELD('lLocalField':U,           'LOGICAL':U).
  ghComboTable:ADD-NEW-FIELD('lUseCache':U,             'LOGICAL':U).

  ghComboTable:ADD-NEW-FIELD('cFieldTooltip':U,         'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('cKeyFormat':U,            'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('cKeyDataType':U,          'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('cDisplayFormat':U,        'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('cDisplayDataType':U,      'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('cBaseQueryString':U,      'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('cQueryTables':U,          'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('cPhysicalTableNames':U,   'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('cTempTables':U,           'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('cParentField':U,          'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('cParentFilterQuery':U,    'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('dFieldWidth':U,           'DECIMAL':U).
  ghComboTable:ADD-NEW-FIELD('cComboFlag':U,            'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('cFlagValue':U,            'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('iInnerLines':U,           'INTEGER':U).
  ghComboTable:ADD-NEW-FIELD('iBuildSequence':U,        'INTEGER':U).
  ghComboTable:ADD-NEW-FIELD('cCustomSuperProc':U,      'CHARACTER':U).
  /* For use with Query Builder */
  ghComboTable:ADD-NEW-FIELD('cQueryBuilderJoinCode':U,        'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('cQueryBuilderOptionList':U,      'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('cQueryBuilderOrderList':U,       'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('cQueryBuilderTableOptionList':U, 'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('cQueryBuilderTuneOptions':U,     'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('cQueryBuilderWhereClauses':U,    'CHARACTER':U).
  ghComboTable:ADD-NEW-FIELD('lEnableField':U,                 'LOGICAL':U,0,?,TRUE).
  ghComboTable:ADD-NEW-FIELD('lDisplayField':U,                'LOGICAL':U,0,?,TRUE).
  ghComboTable:ADD-NEW-FIELD('lSort':U,                       'LOGICAL':U,0,?,FALSE).
  ghComboTable:ADD-NEW-FIELD('cDataSourceName':U,             'CHARACTER':U).
  /*
  /* Add Indices */
  /* Node Handle - Primary - Unique */
  ghComboTable:ADD-NEW-INDEX('puNodeKey':U, TRUE, TRUE).
  ghComboTable:ADD-INDEX-FIELD('puNodeKey':U, 'node_key':U).
  */
  
  ghComboTable:TEMP-TABLE-PREPARE("tCombo":U).
  
  RETURN ghComboTable.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLookupTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLookupTable Procedure 
FUNCTION getLookupTable RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will create the dynamic temp-table for the dynamic
            lookup.
    Notes:  
------------------------------------------------------------------------------*/

  IF VALID-HANDLE(ghLookupTable) THEN
     RETURN ghLookupTable.
  
  CREATE TEMP-TABLE ghLookupTable.
  ghLookupTable:ADD-NEW-FIELD('cActualField':U,          'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cSDFFileName':U,          'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cSDFTemplate':U,          'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cObjectDescription':U,    'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cProductModule':U,        'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cDisplayedField':U,       'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cKeyField':U,             'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cFieldLabel':U,           'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('lLabels':U,               'LOGICAL':U).
  ghLookupTable:ADD-NEW-FIELD('lLocalField':U,           'LOGICAL':U).
  ghLookupTable:ADD-NEW-FIELD('lUseCache':U,             'LOGICAL':U).

  ghLookupTable:ADD-NEW-FIELD('cFieldTooltip':U,         'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cKeyFormat':U,            'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cKeyDataType':U,          'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cDisplayFormat':U,        'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cDisplayDataType':U,      'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cBaseQueryString':U,      'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cQueryTables':U,          'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cPhysicalTableNames':U,   'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cTempTables':U,           'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cBrowseFields':U,         'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cColumnLabels':U,         'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cColumnFormat':U,         'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cBrowseFieldDataTypes':U, 'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cBrowseFieldFormats':U,   'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('iRowsToBatch':U,          'INTEGER':U).
  ghLookupTable:ADD-NEW-FIELD('cBrowseTitle':U,          'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cViewerLinkedFields':U,   'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cLinkedFieldDataTypes':U, 'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cLinkedFieldFormats':U,   'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cViewerLinkedWidgets':U,  'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cLookupImage':U,          'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cParentField':U,          'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cParentFilterQuery':U,    'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cMaintenanceObject':U,    'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cMaintenanceSDO':U,       'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('dFieldWidth':U,           'DECIMAL':U).
  ghLookupTable:ADD-NEW-FIELD('cCustomSuperProc':U,      'CHARACTER':U).
  /* For use with Query Builder */
  ghLookupTable:ADD-NEW-FIELD('cQueryBuilderJoinCode':U,        'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cQueryBuilderOptionList':U,      'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cQueryBuilderTableOptionList':U, 'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cQueryBuilderOrderList':U,       'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cQueryBuilderTuneOptions':U,     'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cQueryBuilderWhereClauses':U,    'CHARACTER':U).
  /* Auto Lookup Browse Popups */
  ghLookupTable:ADD-NEW-FIELD('lPopupOnAmbiguous',              'LOGICAL':U).
  ghLookupTable:ADD-NEW-FIELD('lPopupOnUniqueAmbiguous',        'LOGICAL':U).
  ghLookupTable:ADD-NEW-FIELD('lPopupOnNotAvail',               'LOGICAL':U).
  ghLookupTable:ADD-NEW-FIELD('lBlankOnNotAvail',               'LOGICAL':U).
  ghLookupTable:ADD-NEW-FIELD('lEnableField':U,                 'LOGICAL':U,0,?,TRUE).
  ghLookupTable:ADD-NEW-FIELD('lDisplayField':U,                'LOGICAL':U,0,?,TRUE).
  ghLookupTable:ADD-NEW-FIELD('cMappedFields':U,                'CHARACTER':U).
  ghLookupTable:ADD-NEW-FIELD('cDataSourceName':U,             'CHARACTER':U).
  /*
  /* Add Indices */
  /* Node Handle - Primary - Unique */
  ghLookupTable:ADD-NEW-INDEX('puNodeKey':U, TRUE, TRUE).
  ghLookupTable:ADD-INDEX-FIELD('puNodeKey':U, 'node_key':U).
  */
  
  ghLookupTable:TEMP-TABLE-PREPARE("tLookup":U).
  
  RETURN ghLookupTable.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSDFProcHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSDFProcHandle Procedure 
FUNCTION getSDFProcHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Gets the procedure handle of the SDF super procedure
             (i.e. adm2/lookup.p, adm2/combo.p)
    Notes:  
------------------------------------------------------------------------------*/

  RETURN ghSDFProc.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSDFProcHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSDFProcHandle Procedure 
FUNCTION setSDFProcHandle RETURNS LOGICAL
  ( phProc AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the procedure handle of the SDF super procedure
             (i.e. adm2/lookup.p, adm2/combo.p)
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN ghSDFProc  = phProc.   
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

