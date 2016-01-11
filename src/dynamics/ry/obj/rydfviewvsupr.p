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
/*---------------------------------------------------------------------------------
  File: rydfviewvsupr.p

  Description:  Datafield maintenance viewer super procedure

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/05/2004  Author:     

  Update Notes: Created from Template rytemcustomsuper.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rydfviewvsupr.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}
{destdefi.i}             /* Definitions for dynamics design-time temp-tables. */

DEFINE VARIABLE ghPropertySheet       AS HANDLE     NO-UNDO.

/* Temp table to keep track of information for the target procedure the
   super is running on behalf of */
DEFINE TEMP-TABLE ttLocalContext NO-UNDO
    FIELD tTargetProcedure AS HANDLE
    FIELD tContextName     AS CHARACTER
    FIELD tContextValue    AS CHARACTER
    INDEX idxName
      tTargetProcedure
      tContextName.

/* dps attribute to pass to SDO for updates */
DEFINE TEMP-TABLE ttdpsAttr
    FIELD tLabel     AS CHARACTER
    FIELD tDataType  AS CHARACTER
    FIELD tValue     AS CHARACTER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getCalcClassList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCalcClassList Procedure 
FUNCTION getCalcClassList RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRegisteredFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRegisteredFields Procedure 
FUNCTION getRegisteredFields RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCalcClassList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCalcClassList Procedure 
FUNCTION setCalcClassList RETURNS LOGICAL
  ( INPUT pcCalcClassList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRegisteredFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRegisteredFields Procedure 
FUNCTION setRegisteredFields RETURNS LOGICAL
  ( INPUT pcRegisteredFields AS CHARACTER )  FORWARD.

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
         HEIGHT             = 24.81
         WIDTH              = 61.4.
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord Procedure 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     addRecord override procedure
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN SUPER.

  RUN changeViewerState IN TARGET-PROCEDURE ('Add':U).
  RUN initializeAttributes IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRecord Procedure 
PROCEDURE cancelRecord :
/*------------------------------------------------------------------------------
  Purpose:     cancelRecord override procedure
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN SUPER.

  RUN changeViewerState IN TARGET-PROCEDURE (INPUT 'Initial':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-changeViewerState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeViewerState Procedure 
PROCEDURE changeViewerState :
/*------------------------------------------------------------------------------
  Purpose:     Enables/disables fields and sets some defaults for various 
               viewer operations (states).
  Parameters:  cState AS CHARACTER
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER cState AS CHARACTER  NO-UNDO.

DEFINE VARIABLE hToBox AS HANDLE     NO-UNDO.

DEFINE VARIABLE cCalcClassList AS CHARACTER  NO-UNDO.

  CASE cState:
    WHEN 'AddInstance':U THEN
    DO:
      disableWidget('tData-Type,tFormat,tLabel,tColumnLabel,tDefaultValue,tProductModule,tIncludeListView,tIncludeView':U).
      assignWidgetValue('toBoxEditMaster':U, 'NO':U).
    END.
    WHEN 'AddMaster':U THEN
    DO:
      enableWidget('tData-Type,tFormat,tLabel,tColumnLabel,tDefaultValue,tIncludeListView,tIncludeView,btnProp').
      assignWidgetValue('toBoxEditMaster':U, 'YES':U).
      disableWidget('toBoxEditMaster':U).
    END.
    WHEN 'EditInstance':U THEN
      disableWidget('tData-Type,tFormat,tLabel,tColumnLabel,tDefaultValue,tIncludeListView,tIncludeView,btnProp':U).
    WHEN 'EditMaster':U THEN
      enableWidget('tData-Type,tFormat,tLabel,tColumnLabel,tDefaultValue,tIncludeListView,tIncludeView,btnProp':U).
    WHEN 'Add':U THEN
    DO:
      enableWidget('tClassName,tInstanceName,tProductModule':U).
      disableWidget('btnProp':U).
      assignWidgetValue('toBoxEditMaster':U, 'YES':U).
      cCalcClassList = getCalcClassList().
      IF LOOKUP(widgetValue('tClassName':U), cCalcClassList) > 0  THEN
        enableWidget('tFieldName':U).    
    END.
    WHEN 'Initial':U THEN
    DO:
      disableWidget('tClassName,tFieldName,tProductModule,tSchemaHelp,tSchemaViewAs,tSchemaValExp,tSchemaValMsg':U).
      enableWidget('toBoxEditMaster,tData-Type,tFormat,tLabel,tColumnLabel,tDefaultValue,tIncludeListView,tIncludeView,btnProp').
      hToBox = widgetHandle('toBoxEditMaster':U).
      IF hToBox:VISIBLE THEN
        assignWidgetValue('toBoxEditMaster':U, 'YES':U).
      cCalcClassList = getCalcClassList().
      IF LOOKUP(widgetValue('tClassName':U), cCalcClassList) > 0 THEN
        enableWidget('tInstanceName':U).
      ELSE disableWidget('tInstanceName':U).
    END.
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-chooseBtnProp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE chooseBtnProp Procedure 
PROCEDURE chooseBtnProp :
/*------------------------------------------------------------------------------
  Purpose:     When property button is pressed, launch property Library
               and run procedure to display and register data fields.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hProcedure        AS HANDLE     NO-UNDO.
 
 /* If the Property sheet library is not running persistently, run it now */
 IF NOT VALID-HANDLE(ghPropertySheet) THEN
 DO:
    hProcedure = SESSION:FIRST-PROCEDURE.
    DO WHILE VALID-HANDLE(hProcedure) AND hProcedure:FILE-NAME NE "ry/prc/ryvobplipp.p":U:
      hProcedure = hProcedure:NEXT-SIBLING.
    END.
    IF NOT VALID-HANDLE(hProcedure) THEN
      RUN ry/prc/ryvobplipp.p PERSISTENT SET ghPropertySheet NO-ERROR.
    ELSE 
      ASSIGN ghPropertySheet = hProcedure.
    /* Subscribe to events */
    SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'PropertyChangedAttribute':U IN ghPropertySheet.
 END.

 IF VALID-HANDLE(ghPropertySheet) THEN
 DO:
    RUN launchPropertyWindow IN ghPropertySheet. 
    RUN DPSDisplay IN TARGET-PROCEDURE.
 END.
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyRecord Procedure 
PROCEDURE copyRecord :
/*------------------------------------------------------------------------------
  Purpose:     copyRecord override
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN SUPER.

  RUN changeViewerState IN TARGET-PROCEDURE ('Add':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable Procedure 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     dataAvailable override 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcRelative AS CHARACTER NO-UNDO.

DEFINE VARIABLE cCalcClassList AS CHARACTER  NO-UNDO.

  RUN SUPER (INPUT pcRelative).

  cCalcClassList = getCalcClassList().
  IF LOOKUP(widgetValue('tClassName':U), cCalcClassList) > 0 THEN
    enableWidget('tInstanceName':U).
  ELSE disableWidget('tInstanceName':U).

  RUN DPSDisplay IN TARGET-PROCEDURE.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     destroyObject override - unregister objects from the DPS
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cEntity           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDataField        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMasterObject     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRegisteredFields AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop             AS INTEGER    NO-UNDO.

IF VALID-HANDLE(ghPropertySheet) THEN
DO:
  cRegisteredFields = DYNAMIC-FUNCTION('getRegisteredFields':U IN TARGET-PROCEDURE).
  DO iLoop = 1 TO NUM-ENTRIES(cRegisteredFields,CHR(3)):
     cMasterObject = ENTRY(iLoop,cRegisteredFields,CHR(3)).
     IF NUM-ENTRIES(cMasterObject) NE 2 THEN
        NEXT.

     ASSIGN cEntity    = trim(ENTRY(1,cMasterObject))
            cDataField = trim(ENTRY(2,cMasterObject)).
   
    RUN unregisterObject IN ghPropertySheet
       (TARGET-PROCEDURE, /* Calling procedure handle */
        cEntity,          /* Name of container object */
        cDataField).      /* Name of object.. same as container */
 END.

 RUN destroyObject IN ghPropertySheet.

END.

EMPTY TEMP-TABLE ttLocalContext.

RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DPSDisplay) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DPSDisplay Procedure 
PROCEDURE DPSDisplay :
/*------------------------------------------------------------------------------
  Purpose:     Called when the property sheet has been launched and the user 
               clicks on a Display Properties button
  Parameters:  pcObject
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cEntityName       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cFieldName        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cRegisteredFields AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hContainerSource  AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hDataSource       AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hFieldName        AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hProcedure        AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hPropWindowProc   AS HANDLE     NO-UNDO.
 
 /* If DPS hasn't yet been run, return to improve performance  */
 IF NOT VALID-HANDLE(ghPropertySheet) THEN
    RETURN.

 /* If property sheet is closed, return */
 hPropWindowProc = DYNAMIC-FUNC("getPropSheet":U IN ghPropertySheet).
 IF NOT VALID-HANDLE(hPropWindowProc) THEN 
    RETURN.

 ASSIGN
   hContainerSource = DYNAMIC-FUNCTION('getContainerSource':U IN TARGET-PROCEDURE)
   hDataSource      = DYNAMIC-FUNCTION('getDataSource':U IN hContainerSource)
   hFieldName       = widgetHandle('tFieldName':U)
   cFieldName       = TRIM(DYNAMIC-FUNCTION('getDataValue':U IN hFieldName))
   NO-ERROR.

 IF VALID-HANDLE(hDataSource) THEN
   cEntityName = TRIM(DYNAMIC-FUNCTION('columnValue':U IN hDataSource,
                                   INPUT 'entity_mnemonic_description':U)).
 /* Ensure the Data field is only registered once */
 cRegisteredFields = DYNAMIC-FUNCTION('getRegisteredFields':U IN TARGET-PROCEDURE).
 IF LOOKUP(cEntityName + "," + cFieldName,cRegisteredFields,CHR(3)) = 0 THEN
   RUN DPSRegister IN TARGET-PROCEDURE (INPUT cEntityName, INPUT cFieldName).

 RUN displayProperties IN ghPropertySheet 
       (TARGET-PROCEDURE,
        cEntityName,
        cFieldName,
        "" ,
        YES ,    /* make the result code disabled */
        3 ).



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DPSRegister) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DPSRegister Procedure 
PROCEDURE DPSRegister :
/*------------------------------------------------------------------------------
  Purpose:     Registers the DataFields in the DPS
  Parameters:  <none>
  Notes:       Called from DPSDiplay
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcEntity    AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcFieldName AS CHARACTER  NO-UNDO.

 DEFINE VARIABLE hRepDesignManager AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cAttributeList    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cRegisteredFields AS CHARACTER  NO-UNDO.

 ASSIGN hRepDesignManager = DYNAMIC-FUNCTION('getManagerHandle':U, 
                                              INPUT 'RepositoryDesignManager':U) NO-ERROR.
 RUN retrieveDesignObject IN hRepDesignManager 
        (INPUT pcFieldName,
         INPUT  '':U,  /* Get default result Code */
         OUTPUT TABLE ttObject,
         OUTPUT TABLE ttPage,
         OUTPUT TABLE ttLink,
         OUTPUT TABLE ttUiEvent,
         OUTPUT TABLE ttObjectAttribute ) NO-ERROR.   

 FIND FIRST ttObject WHERE ttObject.tLogicalObjectName = pcFieldName NO-ERROR.
 IF AVAIL ttObject THEN
 DO:
  /* Construct attribute list for all master data fields */
    FOR EACH ttObjectAttribute:
       ASSIGN
         cAttributeList = cAttributeList + (IF cAttributeList = "" THEN "" ELSE CHR(3))
                           + ttObjectAttribute.tAttributeLabel + CHR(3) /* Label */
                           + '':U + CHR(3)                              /* result code */
                           + (IF ttObjectAttribute.tAttributeValue = ?  /* Value */
                              THEN '?':U ELSE ttObjectAttribute.tAttributeValue) .
    END.

    cRegisteredFields = DYNAMIC-FUNCTION('getRegisteredFields':U IN TARGET-PROCEDURE).
    RUN registerObject IN ghPropertySheet
          (INPUT TARGET-PROCEDURE,     /* Calling procedure handle */
           INPUT pcEntity,             /* Name of container object */  
           INPUT pcEntity,             /* Label of container object */  
           INPUT pcFieldName,          /* Name of object */
           INPUT pcFieldName,          /* Label of object */
           INPUT ttObject.tClassName,  /* Class of object */
           INPUT ttObject.tClassName,  /* Other supported classes */
           INPUT 'MASTER':U,           /* MASTER or INSTANCE */
           INPUT cAttributeList,       /* Attribute list */
           INPUT '':U,                 /* Events */
           INPUT '':U,                 /* Default attribtue list */
           INPUT '':U,                 /* Default Event list */
           INPUT '':U).                /* result code  Blank = default*/

    ASSIGN cRegisteredFields = cRegisteredFields 
                                    + (IF cRegisteredFields = "" THEN "" ELSE CHR(3))
                                    + pcEntity + "," + pcFieldName.                   
    DYNAMIC-FUNCTION('setRegisteredFields':U IN TARGET-PROCEDURE,
                     INPUT cRegisteredFields).
 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeAttributes Procedure 
PROCEDURE initializeAttributes :
/*------------------------------------------------------------------------------
  Purpose:     Initializes viewer attributes on add
  Parameters:  <none>
  Notes:       Invoked from addRecord override
------------------------------------------------------------------------------*/
DEFINE VARIABLE cClassName        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDefaultView      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cInheritClasses   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hRepDesignManager AS HANDLE     NO-UNDO.

  cClassName = widgetValue('tClassName':U).

  hRepDesignManager = DYNAMIC-FUNCTION('getManagerHandle':U, INPUT 'RepositoryDesignManager':U) NO-ERROR.
  RUN retrieveDesignClass IN hRepDesignManager
                        ( INPUT  cClassName,
                          OUTPUT cInheritClasses,
                          OUTPUT TABLE ttClassAttribute ,
                          OUTPUT TABLE ttUiEvent,
                          OUTPUT TABLE ttSupportedLink    ) NO-ERROR.

  FOR EACH ttClassAttribute:
    CASE ttClassAttribute.tAttributeLabel:
      WHEN 'Data-Type':U THEN
        assignWidgetValue('tData-Type':U, ttClassAttribute.tAttributeValue).
      WHEN 'Format':U THEN
        assignWidgetValue('tFormat':U, ttClassAttribute.tAttributeValue).
      WHEN 'Label':U THEN
        assignWidgetValue('tLabel':U, ttClassAttribute.tAttributeValue).
      WHEN 'ColumnLabel':U THEN
        assignWidgetValue('tColumnLabel':U, ttClassAttribute.tAttributeValue).
      WHEN 'DefaultValue':U THEN
        assignWidgetValue('tDefaultValue':U, ttClassAttribute.tAttributeValue).
      WHEN 'IncludeInDefaultView':U THEN
      DO:
        assignWidgetValue('tIncludeView':U, ttClassAttribute.tAttributeValue).
        cDefaultView = ttClassAttribute.tAttributeValue.
      END.
    END CASE.
  END.

  FIND ttClassAttribute WHERE ttClassAttribute.tClassName = cClassName AND
        ttClassAttribute.tAttributeLabel = 'IncludeInDefaultListView':U NO-ERROR.
  IF AVAILABLE ttClassAttribute THEN
  DO:
    IF ttClassAttribute.tAttributeValue = ? THEN
        assignWidgetValue('tIncludeListView':U, cDefaultView).
    ELSE assignWidgetValue('tIncludeListView':U, ttClassAttribute.tAttributeValue).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     initializeObject override - subscribes to lookupComplete 
               for the field name lookup, also subscribes to populateMasterData
               for when this is invoke to update a single master object
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hCombo           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.

  hContainerSource = DYNAMIC-FUNCTION('getContainerSource':U IN TARGET-PROCEDURE).
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'lookupComplete':U IN TARGET-PROCEDURE.
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'populateMasterData':U IN hContainerSource.

  setCalcClassList(DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT 'CalculatedField':U)).
  hCombo = widgetHandle('tClassName':U).
  hCombo:LIST-ITEMS = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "DataField").
  hCombo = widgetHandle('tData-Type':U).
  hCombo:LIST-ITEMS = 'Character,Decimal,Integer,INT64,Date,DateTime,DateTime-TZ,Logical,BLOB,CLOB,Raw':U.
  
  RUN changeViewerState IN TARGET-PROCEDURE ('Initial':U).

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-leavetInstanceName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leavetInstanceName Procedure 
PROCEDURE leavetInstanceName :
/*------------------------------------------------------------------------------
  Purpose:     Invoke on leave of instance name field
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cCalcClassList       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEntityName          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hContainerDataSource AS HANDLE     NO-UNDO.
DEFINE VARIABLE hContainerSource     AS HANDLE     NO-UNDO.

  ASSIGN 
    hContainerSource     = DYNAMIC-FUNCTION('getContainerSource':U IN TARGET-PROCEDURE)
    hContainerDataSource = DYNAMIC-FUNCTION('getDataSource':U IN hContainerSource)
    cCalcClassList = getCalcClassList().

  /* Sets the field name for non-calculated fields */
  IF LOOKUP(widgetValue('tClassName':U), cCalcClassList) = 0 THEN
  DO:
    IF VALID-HANDLE(hContainerDataSource) THEN
      cEntityName = DYNAMIC-FUNCTION('columnValue':U IN hContainerDataSource,
                                      INPUT 'entity_mnemonic_description':U).
    assignWidgetValue('tFieldName':U, cEntityName + '.':U + widgetValue('tInstanceName':U)).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-lookupComplete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lookupComplete Procedure 
PROCEDURE lookupComplete :
/*------------------------------------------------------------------------------
  Purpose:     lookupComplete hook for the field name lookup - populates
               viewer fields when a calculated field is chosen with the lookup
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcFieldNames     AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER pcFieldValues    AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER pcKeyFieldValue  AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER pcNewScreenValue AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER pcOldScreenValue AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER plBrowseUsed     AS LOGICAL      NO-UNDO.
DEFINE INPUT PARAMETER phLookup         AS HANDLE       NO-UNDO. 

DEFINE VARIABLE cAttribute        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cIncludeListView  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cInheritClasses   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cViewerAttrList   AS CHARACTER  NO-UNDO INITIAL
    'Data-Type,Format,Label,ColumnLabel,DefaultValue':U.
DEFINE VARIABLE hProductCombo     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRepDesignManager AS HANDLE     NO-UNDO.
DEFINE VARIABLE iNumAttr          AS INTEGER    NO-UNDO.

  IF pcFieldValues NE '':U THEN
  DO:
    hRepDesignManager = DYNAMIC-FUNCTION('getManagerHandle':U, INPUT 'RepositoryDesignManager':U) NO-ERROR.
    RUN retrieveDesignObject IN hRepDesignManager
        (INPUT pcNewScreenValue,
         INPUT '':U,              /* Default result codes */
         OUTPUT TABLE ttObject,
         OUTPUT TABLE ttPage,
         OUTPUT TABLE ttLink,
         OUTPUT TABLE ttUIEvent,
         OUTPUT TABLE ttObjectAttribute).

    FIND ttObject WHERE ttObject.tContainerSmartObjectObj = 0 NO-ERROR.
    IF AVAILABLE ttObject THEN
    DO:
      hProductCombo = widgetHandle('tProductModule':U).
      IF VALID-HANDLE(hProductCombo) THEN
        DYNAMIC-FUNCTION('setDataValue':U IN hProductCombo, ttObject.tProductModuleCode).
      RUN retrieveDesignClass IN hRepDesignManager
                            ( INPUT  ttObject.tClassName,
                              OUTPUT cInheritClasses,
                              OUTPUT TABLE ttClassAttribute ,
                              OUTPUT TABLE ttUiEvent,
                              OUTPUT TABLE ttSupportedLink    ) NO-ERROR.

      DO iNumAttr = 1 TO NUM-ENTRIES(cViewerAttrList):
        cAttribute = ENTRY(iNumAttr, cViewerAttrList).
        FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj      = ttObject.tSmartobjectObj 
                                 AND ttObjectAttribute.tObjectInstanceObj = 0
                                 AND ttObjectAttribute.tAttributeLabel    = cAttribute NO-ERROR.
        IF NOT AVAILABLE ttObjectAttribute THEN
          FIND ttClassAttribute WHERE ttClassAttribute.tClassName      = ttObject.tClassName 
                                  AND ttClassAttribute.tAttributeLabel = cAttribute NO-ERROR.
        assignWidgetValue('t':U + cAttribute, 
                          IF AVAILABLE ttObjectAttribute THEN ttObjectAttribute.tAttributeValue
                          ELSE ttClassAttribute.tAttributeValue).
      END.  /* do iNumAttr to number of viewer attributes */
      
      FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj      = ttObject.tSmartobjectObj 
                                 AND ttObjectAttribute.tObjectInstanceObj = 0
                                 AND ttObjectAttribute.tAttributeLabel    = 'IncludeInDefaultView':U NO-ERROR.
      IF NOT AVAILABLE ttObjectAttribute THEN
        FIND ttClassAttribute WHERE ttClassAttribute.tClassName      = ttObject.tClassName 
                                AND ttClassAttribute.tAttributeLabel = 'IncludeInDefaultView':U NO-ERROR.
      assignWidgetValue('tIncludeView':U, 
                        IF AVAILABLE ttObjectAttribute THEN ttObjectAttribute.tAttributeValue
                        ELSE ttClassAttribute.tAttributeValue).
                                          
      FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj      = ttObject.tSmartobjectObj 
                                 AND ttObjectAttribute.tObjectInstanceObj = 0
                                 AND ttObjectAttribute.tAttributeLabel    = 'IncludeInDefaultListView':U NO-ERROR.
      IF NOT AVAILABLE ttObjectAttribute THEN
        FIND ttClassAttribute WHERE ttClassAttribute.tClassName      = ttObject.tClassName 
                                AND ttClassAttribute.tAttributeLabel = 'IncludeInDefaultListView':U NO-ERROR.
      cIncludeListView = IF AVAILABLE ttObjectAttribute THEN ttObjectAttribute.tAttributeValue
                         ELSE ttClassAttribute.tAttributeValue.
      IF cIncludeListView = ? THEN 
        cIncludeListView = widgetValue('tIncludeView':U).
      assignWidgetValue('tIncludeListView':U, cIncludeListView).

      RUN changeViewerState IN TARGET-PROCEDURE (INPUT 'AddInstance':U).

    END.  /* if avail ttObject */
  END.  /* if field found */
  ELSE RUN changeViewerState IN TARGET-PROCEDURE (INPUT 'AddMaster':U).   
  
  assignWidgetValue('tInstanceName':U, pcNewScreenValue).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-populateMasterData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateMasterData Procedure 
PROCEDURE populateMasterData :
/*------------------------------------------------------------------------------
  Purpose:     Published by rydfobjcw when updating one master object
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  hideWidget('tInstanceName,tInstanceOrder,toBoxEditMaster':U).
  viewWidget('cEditMaster':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-propertyChangedAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE propertyChangedAttribute Procedure 
PROCEDURE propertyChangedAttribute :
/*------------------------------------------------------------------------------
  Purpose:     Called from the DPS when an attribute value is changed to sync
               the changes to the viewer.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phHandle      AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER pcContainer   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcObject      AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcResultCode  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcAttribute   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcValue       AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcDataType    AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plOverride    AS LOGICAL    NO-UNDO.

  CASE pcAttribute:
    WHEN 'Data-Type':U THEN
      assignWidgetValue('tDataType':U, pcValue).
    WHEN 'Format':U THEN
      assignWidgetValue('tFormat':U, pcValue).
    WHEN 'Label':U THEN
      assignWidgetValue('tLabel':U, pcValue).
    WHEN 'ColumnLabel':U THEN
      assignWidgetValue('tColumnLabel':U, pcValue).
    WHEN 'DefaultValue':U THEN
      assignWidgetValue('tDefaultValue':U, pcValue).
    WHEN 'IncludeInDefaultListView':U THEN
      assignWidgetValue('tIncludeListView':U, pcValue).
    WHEN 'IncludeInDefaultView':U THEN
      assignWidgetValue('tIncludeView':U, pcValue).
  END CASE.

  DYNAMIC-FUNCTION('setDataModified':U IN TARGET-PROCEDURE, TRUE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetRecord Procedure 
PROCEDURE resetRecord :
/*------------------------------------------------------------------------------
  Purpose:     Reset the DPS.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cEntityName       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cFieldName        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cRegisteredFields AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hContainerSource  AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hDataSource       AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hFieldName        AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hProcedure        AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hPropWindowProc   AS HANDLE     NO-UNDO.
 
 RUN SUPER.

 /* If DPS hasn't yet been run, return to improve performance  */
 IF NOT VALID-HANDLE(ghPropertySheet) THEN
    RETURN.

ASSIGN
   hContainerSource  = DYNAMIC-FUNCTION('getContainerSource':U IN TARGET-PROCEDURE)
   hDataSource       = DYNAMIC-FUNCTION('getDataSource':U IN hContainerSource)
   hFieldName        = widgetHandle('tFieldName':U)
   cFieldName        = DYNAMIC-FUNCTION('getDataValue':U IN hFieldName)
   cRegisteredFields = DYNAMIC-FUNCTION('getRegisteredFields':U IN TARGET-PROCEDURE)
   NO-ERROR.

IF VALID-HANDLE(hDataSource) THEN
   cEntityName = DYNAMIC-FUNCTION('columnValue':U IN hDataSource,
                                   INPUT 'entity_mnemonic_description':U).

RUN unregisterObject IN ghPropertySheet
     (TARGET-PROCEDURE, /* Calling procedure handle */
      cEntityName,          /* Name of container object */
      cFieldName).      /* Name of object.. same as container */

ASSIGN 
  cRegisteredFields = REPLACE(cRegisteredFields,cEntityName + "," + cFieldName, "" )
  cRegisteredFields = REPLACE(cRegisteredFields,CHR(3) + CHR(3), CHR(3) )
  cRegisteredFields = TRIM(cRegisteredFields,CHR(3)).

DYNAMIC-FUNCTION('setRegisteredFields':U IN TARGET-PROCEDURE,
                 INPUT cRegisteredFields).

RUN DPSDisplay IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord Procedure 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     updateRecord override
               Gets DPS attributes to send to data source
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cEntityName          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldName           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cInvalidAttrs        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMessage             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hAttrBuffer          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hAttrQuery           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hContainerDataSource AS HANDLE     NO-UNDO.
DEFINE VARIABLE hContainerSource     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDataSource          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hFieldName           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRepDesignManager    AS HANDLE     NO-UNDO.

  /* tEditMaster indicates whether the master is being updated along with 
     the instance.  It could not be put on the viewer directly because
     changing it set DataModified.  An attempt was made to set ModifyFields 
     but that failed so a local field was used instead. */
  assignWidgetValue('tEditMaster':U, widgetValue('toBoxEditMaster')).

  /* Get the container's data source to get the entity name */
  ASSIGN
    hDataSource          = DYNAMIC-FUNCTION('getDataSource':U IN TARGET-PROCEDURE)
    hContainerSource     = DYNAMIC-FUNCTION('getContainerSource':U IN TARGET-PROCEDURE)
    hContainerDataSource = DYNAMIC-FUNCTION('getDataSource':U IN hContainerSource)
    hFieldName           = widgetHandle('tFieldName':U)
    cFieldName           = DYNAMIC-FUNCTION('getDataValue':U IN hFieldName).

  IF VALID-HANDLE(hContainerDataSource) THEN
    cEntityName = DYNAMIC-FUNCTION('columnValue':U IN hContainerDataSource,
                                    INPUT 'entity_mnemonic_description':U).

  IF VALID-HANDLE(ghPropertySheet) THEN
  DO:
    hAttrBuffer = DYNAMIC-FUNCTION("getBuffer":U IN ghPropertySheet, 'ttAttribute':U).
    CREATE QUERY hAttrQuery.
    hAttrQuery:SET-BUFFERS(hAttrBuffer).
    hAttrQuery:QUERY-PREPARE('FOR EACH ' + hAttrBuffer:NAME + ' WHERE ':U 
                             + hAttrBuffer:NAME + ".callingProc = '":U + STRING(TARGET-PROCEDURE) + "' AND ":U
                             + hAttrBuffer:NAME + ".containerName = '":U + cEntityName + "' AND ":U
                             + hAttrBuffer:NAME + ".objectName = '":U + cFieldName + "' AND ":U
                             + hAttrBuffer:NAME + ".rowModified = 'TRUE'" ).
    hAttrQuery:QUERY-OPEN().
    hAttrQuery:GET-FIRST().
    DO WHILE hAttrBuffer:AVAILABLE:
       /* Don't need to create recs for attribute maintained on the viewer */
      IF LOOKUP(hAttrBuffer:BUFFER-FIELD('attrLabel':U):BUFFER-VALUE, 'Data-Type,Format,Label,ColumnLabel,DefaultValue,IncludeInDefaultListView,IncludeInDefaultView':U) = 0 THEN
      DO:
        CREATE ttdpsAttr.
        ASSIGN
          ttdpsAttr.tLabel    = hAttrBuffer:BUFFER-FIELD('attrLabel':U):BUFFER-VALUE
          ttdpsAttr.tDataType = hAttrBuffer:BUFFER-FIELD('dataType':U):BUFFER-VALUE
          ttdpsAttr.tValue    = hAttrBuffer:BUFFER-FIELD('setValue':U):BUFFER-VALUE.
      END.  /* if lookup */
      hAttrQuery:GET-NEXT().
    END.  /* do while avail */
  END.  /* if property sheet valid */
  
  /* Pass attributes modified with the DPS to the data source */
  IF VALID-HANDLE(hDataSource) THEN
    RUN setdpsAttr IN hDataSource (INPUT TABLE ttdpsAttr).

  EMPTY TEMP-TABLE ttdpsAttr.
  
  RUN SUPER.

  RUN changeViewerState IN TARGET-PROCEDURE (INPUT 'Initial':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-vctClassName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE vctClassName Procedure 
PROCEDURE vctClassName :
/*------------------------------------------------------------------------------
  Purpose:     Invoked from value changed of class name
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cCalcClassList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hFieldLookup   AS HANDLE     NO-UNDO.

  cCalcClassList = getCalcClassList().
  IF LOOKUP(widgetValue('tClassName':U), cCalcClassList) > 0 THEN
    enableWidget('tFieldName':U).
  ELSE disableWidget('tFieldName':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-vctIncludeListView) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE vctIncludeListView Procedure 
PROCEDURE vctIncludeListView :
/*------------------------------------------------------------------------------
  Purpose:     Include in browsers valud changed logic
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lAnswer AS LOGICAL    NO-UNDO.

  IF widgetIsTrue('tIncludeListView':U) THEN
  DO:
    CASE widgetValue('tData-Type':U):
    WHEN 'BLOB':U THEN
    DO:
      MESSAGE "Visualization of BLOBs is not supported in Browsers. Are you sure you want to use this setting?":U
                       VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE lAnswer.
      IF NOT lAnswer THEN
      DO:
        assignWidgetValue('tIncludeListView':U, 'NO':U).
        RETURN.
      END.
    END.
    WHEN 'CLOB':U THEN
    DO:
      MESSAGE "Visualization of CLOBs is not supported in Browsers. Are you sure you want to use this setting?":U
                       VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE lAnswer.
      IF NOT lAnswer THEN
      DO:
        assignWidgetValue('tIncludeListView':U, 'NO':U).
        RETURN.
      END.
    END.
    END CASE.
  END.

  DYNAMIC-FUNCTION('setDataModified':U IN TARGET-PROCEDURE, INPUT TRUE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-vctIncludeView) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE vctIncludeView Procedure 
PROCEDURE vctIncludeView :
/*------------------------------------------------------------------------------
  Purpose:     Include in viewers value changed logic
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lAnswer AS LOGICAL    NO-UNDO.

  IF widgetIsTrue('tIncludeView':U) AND widgetValue('tData-Type':U) = 'BLOB':U THEN
  DO:
    MESSAGE "Visualization of BLOBs is not supported in Viewers. Are you sure you want to use this setting?":U
                     VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE lAnswer.
    IF NOT lAnswer THEN
    DO:
      assignWidgetValue('tIncludeView':U, 'NO':U).
      RETURN.
    END.
  END.

  DYNAMIC-FUNCTION('setDataModified':U IN TARGET-PROCEDURE, INPUT TRUE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-vctoBoxEditMaster) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE vctoBoxEditMaster Procedure 
PROCEDURE vctoBoxEditMaster :
/*------------------------------------------------------------------------------
  Purpose:     Invoked from value changed of edit master toggle box
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF LOGICAL(widgetValue('toBoxEditMaster':U)) THEN
   RUN changeViewerState IN TARGET-PROCEDURE (INPUT 'EditMaster':U).
  ELSE RUN changeViewerState IN TARGET-PROCEDURE (INPUT 'EditInstance':U).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getCalcClassList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCalcClassList Procedure 
FUNCTION getCalcClassList RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns calculated field class list for target procedure
    Notes:  
------------------------------------------------------------------------------*/
  FIND ttLocalContext WHERE
      ttLocalContext.tTargetProcedure = TARGET-PROCEDURE AND
      ttLocalContext.tContextName = 'CalcClassList':U NO-ERROR.
  IF AVAILABLE ttLocalContext THEN
    RETURN ttLocalContext.tContextValue.
  ELSE RETURN '':U.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRegisteredFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRegisteredFields Procedure 
FUNCTION getRegisteredFields RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns Registered fields for the target procedure
    Notes:  
------------------------------------------------------------------------------*/
  FIND ttLocalContext WHERE
      ttLocalContext.tTargetProcedure = TARGET-PROCEDURE AND
      ttLocalContext.tContextName = 'RegisteredFields':U NO-ERROR.
  IF AVAILABLE ttLocalContext THEN
    RETURN ttLocalContext.tContextValue.
  ELSE RETURN '':U.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCalcClassList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCalcClassList Procedure 
FUNCTION setCalcClassList RETURNS LOGICAL
  ( INPUT pcCalcClassList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets calcualted field class list for the target procedure
    Notes:  
------------------------------------------------------------------------------*/
  FIND ttLocalContext WHERE
      ttLocalContext.tTargetProcedure = TARGET-PROCEDURE AND
      ttLocalContext.tContextName     = 'CalcClassList':U NO-ERROR.
  IF NOT AVAILABLE ttLocalContext THEN
  DO:
    CREATE ttLocalContext.
    ASSIGN 
      ttLocalContext.tTargetProcedure = TARGET-PROCEDURE  
      ttLocalContext.tContextName     = 'CalcClassList':U.
  END.
  ttLocalContext.tContextValue = pcCalcClassList.
  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRegisteredFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRegisteredFields Procedure 
FUNCTION setRegisteredFields RETURNS LOGICAL
  ( INPUT pcRegisteredFields AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets registered fields for the target procedure
    Notes:  
------------------------------------------------------------------------------*/
  FIND ttLocalContext WHERE
      ttLocalContext.tTargetProcedure = TARGET-PROCEDURE AND
      ttLocalContext.tContextName     = 'RegisteredFields':U NO-ERROR.
  IF NOT AVAILABLE ttLocalContext THEN
  DO:
    CREATE ttLocalContext.
    ASSIGN 
      ttLocalContext.tTargetProcedure = TARGET-PROCEDURE  
      ttLocalContext.tContextName     = 'RegisteredFields':U.
  END.
  ttLocalContext.tContextValue = pcRegisteredFields.
  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

