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

DEFINE VARIABLE ghRepositoryDesignManager AS HANDLE     NO-UNDO.

DEFINE VARIABLE ghComboTable              AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghLookupTable             AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghWindowHandle            AS HANDLE     NO-UNDO.
DEFINE VARIABLE glInitialized             AS LOGICAL    NO-UNDO.

DEFINE VARIABLE gcComboClasses  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLookupClasses AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

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

&IF DEFINED(EXCLUDE-fetchObjectInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchObjectInfo Procedure 
PROCEDURE fetchObjectInfo :
/*------------------------------------------------------------------------------
  Purpose:    Does the ServerFecthObject Call 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectName    AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER phObjectBuffer  AS HANDLE     NO-UNDO.
  
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

  DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager, INPUT pcObjectName,
                                                                    INPUT ?, /* Result Code */
                                                                    INPUT ?,  /* Run Attribute */
                                                                    INPUT YES).
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
  DEFINE VARIABLE hMyObjectBuffer             AS HANDLE     NO-UNDO.
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
  DEFINE VARIABLE dProdModObj                 AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cProductModuleCode          AS CHARACTER  NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN fetchObjectInfo (INPUT pcLogicalObjectName, OUTPUT hObjectBuffer).
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
  ASSIGN cObjectDescription  = "":U
         dCustomSuperProcObj = 0.
  IF cDataset <> "":U AND cDataset <> ? THEN 
    ASSIGN cObjectDescription  = ENTRY(LOOKUP("ryc_smartobject.object_description":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3)) 
           dCustomSuperProcObj = DECIMAL(ENTRY(LOOKUP("ryc_smartobject.custom_smartobject_obj":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3)))
           dProdModObj         = DECIMAL(ENTRY(LOOKUP("ryc_smartobject.product_module_obj":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3)))
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
  /* Get Product Module Code */
  IF dProdModObj > 0 THEN DO:
    RUN getRecordDetail IN gshGenManager ( INPUT "FOR EACH gsc_product_module 
                                                  WHERE gsc_product_module.product_module_obj = " + TRIM(QUOTER(dProdModObj)) + " NO-LOCK ":U,
                                           OUTPUT cDataset ).
    ASSIGN cProductModuleCode  = "":U.
    IF cDataset <> "":U AND cDataset <> ? THEN 
      ASSIGN cProductModuleCode  = ENTRY(LOOKUP("gsc_product_module.product_module_code":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3)) 
             NO-ERROR.
  END.

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
  
  hClassAttributeBuffer:FIND-FIRST(" WHERE ":U + hClassAttributeBuffer:NAME + ".tRecordIdentifier = " + TRIM(QUOTER(dContainerRecordIdentifier))) NO-ERROR.
  IF hClassAttributeBuffer:AVAILABLE THEN
  DO:
    ASSIGN hDataTable:BUFFER-FIELD("cSDFTemplate":U):BUFFER-VALUE                 = hClassAttributeBuffer:BUFFER-FIELD("SDFTemplate":U):BUFFER-VALUE      
           hDataTable:BUFFER-FIELD("cDisplayedField":U):BUFFER-VALUE              = hClassAttributeBuffer:BUFFER-FIELD("DisplayedField":U):BUFFER-VALUE   
           hDataTable:BUFFER-FIELD("cKeyField":U):BUFFER-VALUE                    = hClassAttributeBuffer:BUFFER-FIELD("KeyField":U):BUFFER-VALUE         
           hDataTable:BUFFER-FIELD("cFieldLabel":U):BUFFER-VALUE                  = hClassAttributeBuffer:BUFFER-FIELD("FieldLabel":U):BUFFER-VALUE       
           hDataTable:BUFFER-FIELD("cFieldTooltip":U):BUFFER-VALUE                = hClassAttributeBuffer:BUFFER-FIELD("FieldTooltip":U):BUFFER-VALUE     
           hDataTable:BUFFER-FIELD("cKeyFormat":U):BUFFER-VALUE                   = hClassAttributeBuffer:BUFFER-FIELD("KeyFormat":U):BUFFER-VALUE        
           hDataTable:BUFFER-FIELD("cKeyDataType":U):BUFFER-VALUE                 = hClassAttributeBuffer:BUFFER-FIELD("KeyDataType":U):BUFFER-VALUE      
           hDataTable:BUFFER-FIELD("cDisplayFormat":U):BUFFER-VALUE               = hClassAttributeBuffer:BUFFER-FIELD("DisplayFormat":U):BUFFER-VALUE    
           hDataTable:BUFFER-FIELD("cDisplayDataType":U):BUFFER-VALUE             = hClassAttributeBuffer:BUFFER-FIELD("DisplayDataType":U):BUFFER-VALUE  
           hDataTable:BUFFER-FIELD("cBaseQueryString":U):BUFFER-VALUE             = hClassAttributeBuffer:BUFFER-FIELD("BaseQueryString":U):BUFFER-VALUE  
           hDataTable:BUFFER-FIELD("cQueryTables":U):BUFFER-VALUE                 = hClassAttributeBuffer:BUFFER-FIELD("QueryTables":U):BUFFER-VALUE      
           hDataTable:BUFFER-FIELD("cPhysicalTableNames":U):BUFFER-VALUE          = hClassAttributeBuffer:BUFFER-FIELD("PhysicalTableNames":U):BUFFER-VALUE      
           hDataTable:BUFFER-FIELD("cTempTables":U):BUFFER-VALUE                  = hClassAttributeBuffer:BUFFER-FIELD("TempTables":U):BUFFER-VALUE      
           hDataTable:BUFFER-FIELD("cParentField":U):BUFFER-VALUE                 = hClassAttributeBuffer:BUFFER-FIELD("ParentField":U):BUFFER-VALUE      
           hDataTable:BUFFER-FIELD("cParentFilterQuery":U):BUFFER-VALUE           = hClassAttributeBuffer:BUFFER-FIELD("ParentFilterQuery":U):BUFFER-VALUE
           hDataTable:BUFFER-FIELD("dFieldWidth":U):BUFFER-VALUE                  = hClassAttributeBuffer:BUFFER-FIELD("WIDTH-CHARS":U):BUFFER-VALUE
           hDataTable:BUFFER-FIELD('cQueryBuilderJoinCode':U):BUFFER-VALUE        = hClassAttributeBuffer:BUFFER-FIELD("QueryBuilderJoinCode":U):BUFFER-VALUE     
           hDataTable:BUFFER-FIELD('cQueryBuilderOptionList':U):BUFFER-VALUE      = hClassAttributeBuffer:BUFFER-FIELD("QueryBuilderOptionList":U):BUFFER-VALUE     
           hDataTable:BUFFER-FIELD('cQueryBuilderOrderList':U):BUFFER-VALUE       = hClassAttributeBuffer:BUFFER-FIELD("QueryBuilderOrderList":U):BUFFER-VALUE      
           hDataTable:BUFFER-FIELD('cQueryBuilderTableOptionList':U):BUFFER-VALUE = hClassAttributeBuffer:BUFFER-FIELD("QueryBuilderTableOptionList":U):BUFFER-VALUE
           hDataTable:BUFFER-FIELD('cQueryBuilderTuneOptions':U):BUFFER-VALUE     = hClassAttributeBuffer:BUFFER-FIELD("QueryBuilderTuneOptions":U):BUFFER-VALUE    
           hDataTable:BUFFER-FIELD('cQueryBuilderWhereClauses':U):BUFFER-VALUE    = hClassAttributeBuffer:BUFFER-FIELD("QueryBuilderWhereClauses":U):BUFFER-VALUE.
           hDataTable:BUFFER-FIELD('lEnableField':U):BUFFER-VALUE                 = hClassAttributeBuffer:BUFFER-FIELD("EnableField":U):BUFFER-VALUE.
           hDataTable:BUFFER-FIELD('lDisplayField':U):BUFFER-VALUE                = hClassAttributeBuffer:BUFFER-FIELD("DisplayField":U):BUFFER-VALUE.
    IF LOOKUP(cObjectType, gcComboClasses) <> 0 THEN
        ASSIGN hDataTable:BUFFER-FIELD("cDescSubstitute":U):BUFFER-VALUE = hClassAttributeBuffer:BUFFER-FIELD("DescSubstitute":U):BUFFER-VALUE   
               hDataTable:BUFFER-FIELD("cComboFlag":U):BUFFER-VALUE      = hClassAttributeBuffer:BUFFER-FIELD("ComboFlag":U):BUFFER-VALUE        
               hDataTable:BUFFER-FIELD("cFlagValue":U):BUFFER-VALUE      = hClassAttributeBuffer:BUFFER-FIELD("FlagValue":U):BUFFER-VALUE        
               hDataTable:BUFFER-FIELD("iInnerLines":U):BUFFER-VALUE     = hClassAttributeBuffer:BUFFER-FIELD("InnerLines":U):BUFFER-VALUE       
               hDataTable:BUFFER-FIELD("iBuildSequence":U):BUFFER-VALUE  = hClassAttributeBuffer:BUFFER-FIELD("BuildSequence":U):BUFFER-VALUE.   
    ELSE
        ASSIGN hDataTable:BUFFER-FIELD("cBrowseFields":U):BUFFER-VALUE           = hClassAttributeBuffer:BUFFER-FIELD("BrowseFields":U):BUFFER-VALUE         
               hDataTable:BUFFER-FIELD("cColumnLabels":U):BUFFER-VALUE           = hClassAttributeBuffer:BUFFER-FIELD("ColumnLabels":U):BUFFER-VALUE         
               hDataTable:BUFFER-FIELD("cColumnFormat":U):BUFFER-VALUE           = hClassAttributeBuffer:BUFFER-FIELD("ColumnFormat":U):BUFFER-VALUE         
               hDataTable:BUFFER-FIELD("cBrowseFieldDataTypes":U):BUFFER-VALUE   = hClassAttributeBuffer:BUFFER-FIELD("BrowseFieldDataTypes":U):BUFFER-VALUE 
               hDataTable:BUFFER-FIELD("cBrowseFieldFormats":U):BUFFER-VALUE     = hClassAttributeBuffer:BUFFER-FIELD("BrowseFieldFormats":U):BUFFER-VALUE   
               hDataTable:BUFFER-FIELD("iRowsToBatch":U):BUFFER-VALUE            = hClassAttributeBuffer:BUFFER-FIELD("RowsToBatch":U):BUFFER-VALUE          
               hDataTable:BUFFER-FIELD("cBrowseTitle":U):BUFFER-VALUE            = hClassAttributeBuffer:BUFFER-FIELD("BrowseTitle":U):BUFFER-VALUE          
               hDataTable:BUFFER-FIELD("cViewerLinkedFields":U):BUFFER-VALUE     = hClassAttributeBuffer:BUFFER-FIELD("ViewerLinkedFields":U):BUFFER-VALUE   
               hDataTable:BUFFER-FIELD("cLinkedFieldDataTypes":U):BUFFER-VALUE   = hClassAttributeBuffer:BUFFER-FIELD("LinkedFieldDataTypes":U):BUFFER-VALUE 
               hDataTable:BUFFER-FIELD("cLinkedFieldFormats":U):BUFFER-VALUE     = hClassAttributeBuffer:BUFFER-FIELD("LinkedFieldFormats":U):BUFFER-VALUE   
               hDataTable:BUFFER-FIELD("cViewerLinkedWidgets":U):BUFFER-VALUE    = hClassAttributeBuffer:BUFFER-FIELD("ViewerLinkedWidgets":U):BUFFER-VALUE  
               hDataTable:BUFFER-FIELD("cLookupImage":U):BUFFER-VALUE            = hClassAttributeBuffer:BUFFER-FIELD("LookupImage":U):BUFFER-VALUE          
               hDataTable:BUFFER-FIELD("cMaintenanceObject":U):BUFFER-VALUE      = hClassAttributeBuffer:BUFFER-FIELD("MaintenanceObject":U):BUFFER-VALUE    
               hDataTable:BUFFER-FIELD("cMaintenanceSDO":U):BUFFER-VALUE         = hClassAttributeBuffer:BUFFER-FIELD("MaintenanceSDO":U):BUFFER-VALUE
               hDataTable:BUFFER-FIELD("lPopupOnAmbiguous":U):BUFFER-VALUE       = hClassAttributeBuffer:BUFFER-FIELD("PopupOnAmbiguous":U):BUFFER-VALUE
               hDataTable:BUFFER-FIELD("lPopupOnUniqueAmbiguous":U):BUFFER-VALUE = hClassAttributeBuffer:BUFFER-FIELD("PopupOnUniqueAmbiguous":U):BUFFER-VALUE
               hDataTable:BUFFER-FIELD("lPopupOnNotAvail":U):BUFFER-VALUE        = hClassAttributeBuffer:BUFFER-FIELD("PopupOnNotAvail":U):BUFFER-VALUE
               hDataTable:BUFFER-FIELD("lBlankOnNotAvail":U):BUFFER-VALUE        = hClassAttributeBuffer:BUFFER-FIELD("BlankOnNotAvail":U):BUFFER-VALUE.
  END. /* Available Attributes */
  phDataTable = hDataTable:HANDLE.
  hDataTable = ?.

  DELETE OBJECT hObjectBuffer:TABLE-HANDLE NO-ERROR.

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
  
  {get ToolbarSource hToolbarSource}.
  
  ghSDFObject = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U IN TARGET-PROCEDURE,"SmartDataField-Source":U)).
  {get ContainerSource hContainerSource}.
  {get WindowFrameHandle ghWindowHandle TARGET-PROCEDURE}.
  ghWindowHandle = ghWindowHandle:PARENT.
  RUN SUPER.
  
  /* Enable the interface. */         
  ASSIGN ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE,
                                                      INPUT "RepositoryDesignManager":U).
  IF NOT VALID-HANDLE(ghRepositoryDesignManager) THEN
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

  DEFINE VARIABLE hDesignManager        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cErrorMessage         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dSmartObjectObj       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hAttributeValueBuffer AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hAttributeValueTable  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cPhysicalObjectName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iField                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hField                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFieldDataType        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldName            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hOTTable              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hOTBuffer             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hAttrField            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAttrValueSame        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE dMasterObjectObj      AS DECIMAL    NO-UNDO.

  ASSIGN hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).

  IF NOT VALID-HANDLE(hDesignManager) THEN DO:
    cErrorMessage = cErrorMessage + (IF NUM-ENTRIES(cErrorMessage,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                  {af/sup2/aferrortxt.i 'AF' '29' '' '' '"Repository Design Manager PLIP"'}.
    RETURN cErrorMessage.
  END.

  phDataTable:FIND-FIRST().
  
  /* See if you can find the SDF smartobject_obj */ 
  IF phDataTable:BUFFER-FIELD("cSDFFileName":U):BUFFER-VALUE <> "":U THEN
    dMasterObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN hDesignManager, INPUT phDataTable:BUFFER-FIELD("cSDFFileName":U):BUFFER-VALUE, INPUT 0) NO-ERROR.
  IF dMasterObjectObj = ? THEN
    dMasterObjectObj = 0.
  
  IF LOOKUP(pcSDFType, gcLookupClasses) > 0 THEN
      ASSIGN cPhysicalObjectName = "dynlookup.w".
  ELSE
      ASSIGN cPhysicalObjectName = "dyncombo.w".
  
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
    RUN removeAttributeValues IN hDesignManager (INPUT hAttributeValueBuffer,           
                                                 INPUT TABLE-HANDLE hAttributeValueTable).
  END.
  /* Now we need to check which of these attributes is the same as those set in
     the class level */
  FIND FIRST gsc_object_type
       WHERE gsc_object_type.object_type_code = pcSDFType
       NO-LOCK NO-ERROR.
  IF AVAILABLE gsc_object_type THEN DO:
    /* Create a Temp-Table that contains the valid attributes
       for this object type and their default values */
    CREATE TEMP-TABLE hOTTable.
    RUN addParentOTAttrs IN hDesignManager (INPUT gsc_object_type.object_type_obj,
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

      IF NOT VALID-HANDLE(hAttrField) THEN
        NEXT.

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
  RUN insertObjectMaster IN hDesignManager (INPUT phDataTable:BUFFER-FIELD("cSDFFileName":U):BUFFER-VALUE,
                                            INPUT "":U,
                                            INPUT pcProductModuleCode,
                                            INPUT pcSDFType,
                                            INPUT phDataTable:BUFFER-FIELD("cObjectDescription":U):BUFFER-VALUE,
                                            INPUT "":U,
                                            INPUT "":U,
                                            INPUT phDataTable:BUFFER-FIELD("cCustomSuperProc":U):BUFFER-VALUE,
                                            INPUT FALSE,
                                            INPUT FALSE,
                                            INPUT cPhysicalObjectName,
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

