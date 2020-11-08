&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" vTableWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" vTableWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject
       {"ry/obj/ryemptysdo.i"}.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*---------------------------------------------------------------------------------
  File: rysdfobjmv.w

  Description:  SmartDataField Viewer

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/05/2002  Author: Mark Davies (MIP)

  Update Notes: Created from Template rysttviewv.w

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

&scop object-name       rysdfobjmv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}


&GLOBAL-DEFINE define-only YES
{launch.i }

DEFINE VARIABLE ghContainerSource   AS HANDLE     NO-UNDO.
DEFINE VARIABLE glAppBuilder        AS LOGICAL    NO-UNDO.

DEFINE VARIABLE ghToolbar           AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghDataTable         AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghDynLookup         AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghDynCombo          AS HANDLE     NO-UNDO.
DEFINE VARIABLE glNew               AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glStaticSDF         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE ghSDFObject         AS HANDLE     NO-UNDO.
DEFINE VARIABLE glNeedToSave        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glIsDynView         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glUsedExisting      AS LOGICAL    NO-UNDO.

DEFINE VARIABLE gcComboClasses      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLookupClasses     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glAppliedLeave      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glUpdateMasterOnly  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glValidationError   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glCheckChange       AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/ryemptysdo.i"

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS toUseCache coObjType ToSave fiProdModObj 
&Scoped-Define DISPLAYED-OBJECTS raSource toUseCache fiFieldName coObjType ~
ToSave fiObjectDescription 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD clearDetails vTableWin 
FUNCTION clearDetails RETURNS LOGICAL
  ( plClearAll AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataViewSource vTableWin 
FUNCTION getDataViewSource RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSDFProc vTableWin 
FUNCTION getSDFProc RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataObjectName vTableWin 
FUNCTION setDataObjectName RETURNS LOGICAL
  ( INPUT pcName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolbarHandle vTableWin 
FUNCTION setToolbarHandle RETURNS LOGICAL
  ( INPUT phToolbarHandle AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hCustomSuperProcedure AS HANDLE NO-UNDO.
DEFINE VARIABLE hDataObject AS HANDLE NO-UNDO.
DEFINE VARIABLE hObjectFilename AS HANDLE NO-UNDO.
DEFINE VARIABLE hProductModule AS HANDLE NO-UNDO.
DEFINE VARIABLE hResultCode AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buSynch 
     LABEL "&Synch with Master" 
     SIZE 19.6 BY 1.14 TOOLTIP "Synch the instance properties with that of the master"
     BGCOLOR 8 .

DEFINE BUTTON buSynchInstances 
     LABEL "&Synch Instances ..." 
     SIZE 20 BY 1.14 TOOLTIP "Synchronize instances with master"
     BGCOLOR 8 .

DEFINE BUTTON buWhereUsed 
     LABEL "&Where Used" 
     SIZE 20 BY 1.14 TOOLTIP "Find out where this SDF is currently used."
     BGCOLOR 8 .

DEFINE VARIABLE coObjType AS CHARACTER FORMAT "X(256)":U 
     LABEL "SDF type" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 52.8 BY 1 TOOLTIP "Select a Smart Data Field Type" NO-UNDO.

DEFINE VARIABLE fiDataObjectTypes AS CHARACTER FORMAT "X(70)":U 
     VIEW-AS FILL-IN 
     SIZE 2 BY 1 NO-UNDO.

DEFINE VARIABLE fiFieldName AS CHARACTER FORMAT "X(75)":U 
     LABEL "Field name" 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 TOOLTIP "The field name of the underlying field the SDF was dropped onto." NO-UNDO.

DEFINE VARIABLE fiObjectDescription AS CHARACTER FORMAT "X(35)":U 
     LABEL "Description" 
     VIEW-AS FILL-IN 
     SIZE 48.8 BY 1 TOOLTIP "Description of SmartDataField" NO-UNDO.

DEFINE VARIABLE fiProdModObj AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 2 BY 1 NO-UNDO.

DEFINE VARIABLE fiValidTypes AS CHARACTER FORMAT "X(70)":U 
     VIEW-AS FILL-IN 
     SIZE 2 BY 1 TOOLTIP "Do not remove" NO-UNDO.

DEFINE VARIABLE raSource AS CHARACTER 
     CONTEXT-HELP-ID 0
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Database query", "DB",
"DataObject", "SDO"
     SIZE 43.8 BY .86 NO-UNDO.

DEFINE VARIABLE ToSave AS LOGICAL INITIAL no 
     LABEL "Save as SmartObject" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.8 BY .81 NO-UNDO.

DEFINE VARIABLE toUseCache AS LOGICAL INITIAL no 
     LABEL "Use cache" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.4 BY .81 TOOLTIP "If set then the SDF cache manager will be used to retrieve data where available" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     raSource AT ROW 5.38 COL 20.2 NO-LABEL
     toUseCache AT ROW 3.14 COL 95.8
     fiFieldName AT ROW 2.05 COL 93.8 COLON-ALIGNED
     buSynch AT ROW 4.05 COL 124.2
     coObjType AT ROW 2.05 COL 17.8 COLON-ALIGNED
     fiValidTypes AT ROW 2.05 COL 67 COLON-ALIGNED NO-LABEL
     ToSave AT ROW 4.05 COL 95.8
     fiObjectDescription AT ROW 4.14 COL 17.8 COLON-ALIGNED
     fiProdModObj AT ROW 1 COL 69 NO-LABEL
     buWhereUsed AT ROW 4.05 COL 74.6
     fiDataObjectTypes AT ROW 6.48 COL 68.2 COLON-ALIGNED NO-LABEL
     buSynchInstances AT ROW 5.43 COL 74.6
     "Data source:" VIEW-AS TEXT
          SIZE 13 BY .62 AT ROW 5.38 COL 6.8
     SPACE(124.00) SKIP(1.43)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Compile into: 
   Data Source: "ry/obj/ryemptysdo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/ryemptysdo.i}
      END-FIELDS.
   END-TABLES.
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW vTableWin ASSIGN
         HEIGHT             = 6.71
         WIDTH              = 142.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB vTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW vTableWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON buSynch IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       buSynch:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR BUTTON buSynchInstances IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       buSynchInstances:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR BUTTON buWhereUsed IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       buWhereUsed:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN fiDataObjectTypes IN FRAME frMain
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fiDataObjectTypes:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN fiFieldName IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiObjectDescription IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiProdModObj IN FRAME frMain
   NO-DISPLAY ALIGN-L                                                   */
ASSIGN 
       fiProdModObj:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN fiValidTypes IN FRAME frMain
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fiValidTypes:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR RADIO-SET raSource IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       ToSave:HIDDEN IN FRAME frMain           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME buSynch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSynch vTableWin
ON CHOOSE OF buSynch IN FRAME frMain /* Synch with Master */
DO:
  DEFINE VARIABLE cMessage AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAnswer  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hLookup  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSDFType AS CHARACTER  NO-UNDO.

  cMessage = "Are you sure that you want to apply the values from the Master object to your instance?".
  RUN askQuestion IN gshSessionManager (INPUT cMessage,         /* messages */
                                        INPUT "&Yes,&No":U,     /* button list */
                                        INPUT "&Yes":U,          /* default */
                                        INPUT "&No":U,          /* cancel */
                                        INPUT "Apply Master Values":U, /* title */
                                        INPUT "":U,             /* datatype */
                                        INPUT "":U,             /* format */
                                        INPUT-OUTPUT cAnswer,   /* answer */
                                        OUTPUT cButton          /* button pressed */
                                        ).
  IF cButton <> "&Yes":U THEN
      RETURN NO-APPLY.
  ELSE DO:
    {get lookupHandle hLookup hObjectFileName}.
    RUN getObjectDetail IN ghContainerSource (INPUT hLookup:SCREEN-VALUE,
                                              OUTPUT ghDataTable).
    ghDataTable:FIND-FIRST().
    ghDataTable:BUFFER-DELETE().
    ghDataTable:FIND-LAST().
    IF LOOKUP(coObjType:SCREEN-VALUE, gcLookupClasses) > 0 
    THEN DO:
        IF VALID-HANDLE(ghDynLookup) THEN
          RUN setInfo IN ghDynLookup (INPUT ghDataTable).
    END.
    ELSE
        IF LOOKUP(coObjType:SCREEN-VALUE, gcComboClasses) > 0 
        THEN DO:
            IF VALID-HANDLE(ghDynCombo) THEN
              RUN setInfo IN ghDynCombo (INPUT ghDataTable).
        END.
    
    /* Update this viewer. Only update the instance attributes,
       and not the master values (like the obejct_filename).
     */
    toUseCache:CHECKED = ghDataTable:BUFFER-FIELD("lUseCache":U):BUFFER-VALUE.
    setDataObjectName(ghDataTable:BUFFER-FIELD("cDataSourceName":U):BUFFER-VALUE).  
    
    RUN changesMade.
    ASSIGN buSynch:SENSITIVE = FALSE
           buSynch:HIDDEN    = TRUE.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSynchInstances
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSynchInstances vTableWin
ON CHOOSE OF buSynchInstances IN FRAME frMain /* Synch Instances ... */
DO:
  RUN synchInstances.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buWhereUsed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buWhereUsed vTableWin
ON CHOOSE OF buWhereUsed IN FRAME frMain /* Where Used */
DO:
  RUN whereUsed.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coObjType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coObjType vTableWin
ON TAB OF coObjType IN FRAME frMain /* SDF type */
DO:
  APPLY "VALUE-CHANGED":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coObjType vTableWin
ON VALUE-CHANGED OF coObjType IN FRAME frMain /* SDF type */
DO:
  DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFolder    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataValue AS CHARACTER  NO-UNDO.

  {get dataValue CDataValue hObjectFileName}.

  {get ContainerSource hContainer}.
  hFolder = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U IN hContainer,"Page-Source":U)).
  
  IF LOOKUP(coObjType:SCREEN-VALUE, gcLookupClasses) > 0 
  THEN DO:
      RUN disableFolderPage IN hFolder (INPUT 2).
      RUN enableFolderPage IN hFolder (INPUT 1).
      RUN selectPage IN hContainer (INPUT 1).
      IF glNew AND cDataValue <> "":U THEN
        RUN "leaveLookup" IN hObjectFileName.
      DISABLE raSource WITH FRAME {&FRAME-NAME}.
      RUN disableField IN hDataObject.
      RUN assignNewValue IN hDataObject (INPUT "":U, INPUT "":U, INPUT FALSE).
  END.
  ELSE
      IF LOOKUP(coObjType:SCREEN-VALUE, gcComboClasses) > 0 
      THEN DO:
          RUN disableFolderPage IN hFolder (INPUT 1).
          RUN enableFolderPage IN hFolder (INPUT 2).
          RUN selectPage IN hContainer (INPUT 2).
          IF glNew AND cDataValue <> "":U THEN
            RUN "leaveLookup" IN hObjectFileName.
          ENABLE raSource WITH FRAME {&FRAME-NAME}.
          ASSIGN raSource:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "DB":U.
      END.

    APPLY "entry":U TO SELF.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiFieldName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFieldName vTableWin
ON VALUE-CHANGED OF fiFieldName IN FRAME frMain /* Field name */
DO:
  RUN changesMade.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiObjectDescription
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiObjectDescription vTableWin
ON VALUE-CHANGED OF fiObjectDescription IN FRAME frMain /* Description */
DO:
  RUN changesMade.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME raSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL raSource vTableWin
ON VALUE-CHANGED OF raSource IN FRAME frMain
DO:
  ASSIGN raSource.
  IF raSource = 'SDO':U THEN
    RUN enableField IN hDataObject.
  ELSE DO: 
    RUN disableField IN hDataObject.
    RUN clearField IN hDataObject.
    DYNAMIC-FUNCTION('setDataSourceName':U IN ghDynCombo,
                     INPUT '':U).
  END.
  RUN changeSource IN ghDynCombo (INPUT raSource).
  RUN changesMade.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToSave vTableWin
ON VALUE-CHANGED OF ToSave IN FRAME frMain /* Save as SmartObject */
DO:
  DEFINE VARIABLE hLookup       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hProdModCombo AS HANDLE     NO-UNDO.

  ASSIGN toSave.
  IF glCheckChange THEN
    RUN changesMade.

  IF NOT glStaticSDF THEN
    RETURN NO-APPLY.
  
  {get ComboHandle hProdModCombo hProductModule}.
  
  IF toSave THEN DO:
    glNew = TRUE.
    RUN enableField IN hObjectFileName.
    IF NOT glStaticSDF THEN 
      RUN disableButton IN hObjectFileName.
    ASSIGN hProdModCombo:SCREEN-VALUE = hProdModCombo:ENTRY(1).
    RUN enableField IN hProductModule.
    {get LookupHandle hLookup hObjectFileName}.
    hLookup:SCREEN-VALUE = "":U.
    ENABLE fiObjectDescription toUseCache WITH FRAME {&FRAME-NAME}.
    IF VALID-HANDLE(ghToolbar) THEN
      DYNAMIC-FUNCTION("enableActions":U IN ghToolbar, "cbCancel":U).
  END.
  ELSE DO:
    ASSIGN hProdModCombo:LIST-ITEM-PAIRS = hProdModCombo:LIST-ITEM-PAIRS.
    RUN setFields ("Cancel":U).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toUseCache
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toUseCache vTableWin
ON VALUE-CHANGED OF toUseCache IN FRAME frMain /* Use cache */
DO:
  RUN changesMade.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects vTableWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage: 

    WHEN 0 THEN DO:
       RUN constructObject (
             INPUT  'ry/obj/rysdfdatasource.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelDataObject nameFieldTooltipPress F4 for LookupKeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK, EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj AND [&FilterSet=|&EntityList=GSCPM,RYCSO]
                     BY gsc_object_type.object_type_code BY ryc_smartobject.object_filename INDEXED-REPOSITIONQueryTablesgsc_object_type,ryc_smartobject,gsc_product_moduleBrowseFieldsryc_smartobject.object_filename,gsc_object_type.object_type_code,gsc_product_module.product_module_code,ryc_smartobject.object_descriptionBrowseFieldDataTypescharacter,character,character,characterBrowseFieldFormatsX(70)|X(35)|X(35)|X(35)RowsToBatch200BrowseTitleLookupViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldfiDataObjectTypesParentFilterQueryLOOKUP(gsc_object_type.object_type_code,~'&1~') > 0|MaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNamefiDataObjectDisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hDataObject ).
       RUN repositionObject IN hDataObject ( 6.43 , 20.00 ) NO-ERROR.
       RUN resizeObject IN hDataObject ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelSmartDataFieldFieldTooltipPress F4 to Lookup existing SmartDataFieldsKeyFormatx(256)KeyDatatypecharacterDisplayFormatx(256)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK, EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj AND [&FilterSet=|&EntityList=GSCPM,RYCSO]
                     BY gsc_object_type.object_type_code BY ryc_smartobject.object_filename INDEXED-REPOSITIONQueryTablesgsc_object_type,ryc_smartobject,gsc_product_moduleBrowseFieldsryc_smartobject.object_filename,gsc_object_type.object_type_code,gsc_product_module.product_module_code,ryc_smartobject.object_descriptionBrowseFieldDataTypescharacter,character,character,characterBrowseFieldFormatsRowsToBatch200BrowseTitleLookup SmartDataFieldViewerLinkedFieldsgsc_object_type.object_type_code,gsc_product_module.product_module_code,ryc_smartobject.object_descriptionLinkedFieldDataTypescharacter,character,characterLinkedFieldFormatsViewerLinkedWidgetscoObjType,?,fiObjectDescriptionColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldfiValidTypesParentFilterQueryLOOKUP(gsc_object_type.object_type_code,~'&1~') > 0|MaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNamefiSmartDataFieldDisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hObjectFilename ).
       RUN repositionObject IN hObjectFilename ( 1.00 , 19.80 ) NO-ERROR.
       RUN resizeObject IN hObjectFilename ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_customization_result.customization_result_codeKeyFieldryc_customization_result.customization_result_objFieldLabelResult codeFieldTooltipPress F4 For LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_customization_type NO-LOCK,
                     EACH ryc_customization_result NO-LOCK
                     WHERE ryc_customization_result.customization_type_obj = ryc_customization_type.customization_type_obj INDEXED-REPOSITIONQueryTablesryc_customization_type,ryc_customization_resultBrowseFieldsryc_customization_result.customization_result_code,ryc_customization_result.customization_result_desc,ryc_customization_result.system_owned,ryc_customization_type.customization_type_code,ryc_customization_type.customization_type_desc,ryc_customization_type.api_nameBrowseFieldDataTypescharacter,character,logical,character,character,characterBrowseFieldFormatsX(70)|X(70)|YES/NO|X(15)|X(35)|X(70)RowsToBatch200BrowseTitleResult Code LookupViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldName<Local2>DisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hResultCode ).
       RUN repositionObject IN hResultCode ( 2.05 , 19.80 ) NO-ERROR.
       RUN resizeObject IN hResultCode ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelSuper procedureFieldTooltipPress F4 to Lookup a Super ProcedureKeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK
                     WHERE gsc_object_type.object_type_code = ~'PROCEDURE~':U,
                     EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj AND [&FilterSet=|&EntityList=GSCPM,RYCSO] INDEXED-REPOSITIONQueryTablesgsc_object_type,ryc_smartobject,gsc_product_moduleBrowseFieldsryc_smartobject.object_filename,ryc_smartobject.object_description,gsc_product_module.product_module_code,ryc_smartobject.template_smartobject,ryc_smartobject.object_pathBrowseFieldDataTypescharacter,character,character,logical,characterBrowseFieldFormatsX(70)|X(35)|X(35)|YES/NO|X(70)RowsToBatch200BrowseTitleLookup Custom Super ProcedureViewerLinkedFieldsryc_smartobject.object_pathLinkedFieldDataTypescharacterLinkedFieldFormatsX(70)ViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldName<Local5>DisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hCustomSuperProcedure ).
       RUN repositionObject IN hCustomSuperProcedure ( 3.10 , 19.80 ) NO-ERROR.
       RUN resizeObject IN hCustomSuperProcedure ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_product_module.product_module_code,gsc_product_module.product_module_descriptionKeyFieldgsc_product_module.product_module_codeFieldLabelProduct moduleFieldTooltipSelect a Product Module from the listKeyFormatX(35)KeyDatatypecharacterDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_product_module
                     WHERE [&FilterSet=|&EntityList=GSCPM] NO-LOCK BY gsc_product_module.product_module_code INDEXED-REPOSITIONQueryTablesgsc_product_moduleSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1 / &2ComboDelimiterListItemPairsInnerLines5SortnoComboFlagFlagValueBuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesUseCacheyesSuperProcedureDataSourceNameFieldNamefiProductModuleDisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hProductModule ).
       RUN repositionObject IN hProductModule ( 1.00 , 95.80 ) NO-ERROR.
       RUN resizeObject IN hProductModule ( 1.00 , 48.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( hDataObject ,
             raSource:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( hObjectFilename ,
             ToSave:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( hResultCode ,
             hObjectFilename , 'AFTER':U ).
       RUN adjustTabOrder ( hCustomSuperProcedure ,
             hResultCode , 'AFTER':U ).
       RUN adjustTabOrder ( hProductModule ,
             fiProdModObj:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignSDFValues vTableWin 
PROCEDURE assignSDFValues :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will assign the SDF's other details to the 
               fields on this viewer
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hLookup       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hProdModCombo AS HANDLE     NO-UNDO.

  IF NOT VALID-HANDLE(ghDataTable) THEN
    RETURN.

  ghDataTable:FIND-FIRST().
  IF NOT ghDataTable:AVAILABLE THEN
    RETURN.


  DO WITH FRAME {&FRAME-NAME}:
    {get LookupHandle hLookup hObjectFileName}.
    
    IF ghDataTable:BUFFER-FIELD("cSDFFileName":U):BUFFER-VALUE <> "":U THEN DO:
      hLookup:SCREEN-VALUE = ghDataTable:BUFFER-FIELD("cSDFFileName":U):BUFFER-VALUE.
      IF glStaticSDF THEN DO:
        ASSIGN toSave:CHECKED = TRUE.
        APPLY "VALUE-CHANGED":U TO toSave.
      END.
    END.
    ELSE
      hLookup:SCREEN-VALUE = "":U.

    DYNAMIC-FUNCTION("setDataValue":U IN hProductModule, ghDataTable:BUFFER-FIELD("cProductModule":U):BUFFER-VALUE).

    ASSIGN fiObjectDescription:SCREEN-VALUE = ghDataTable:BUFFER-FIELD("cObjectDescription":U):BUFFER-VALUE
           fiFieldName:SCREEN-VALUE         = ghDataTable:BUFFER-FIELD("cActualField":U):BUFFER-VALUE
           toUseCache:CHECKED               = ghDataTable:BUFFER-FIELD("lUseCache":U):BUFFER-VALUE.
    setDataObjectName(ghDataTable:BUFFER-FIELD("cDataSourceName":U):BUFFER-VALUE).
    RUN assignNewValue IN hCustomSuperProcedure (INPUT ghDataTable:BUFFER-FIELD("cCustomSuperProc":U):BUFFER-VALUE, INPUT ghDataTable:BUFFER-FIELD("cCustomSuperProc":U):BUFFER-VALUE, TRUE).        
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changesMade vTableWin 
PROCEDURE changesMade :
/*------------------------------------------------------------------------------
  Purpose:     This event will be published from the maintenance viewer to 
               indicate that we should enable the save and reset buttons.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/  
  IF INDEX(PROGRAM-NAME(2),"rysdflkupv":U) > 0 OR
     INDEX(PROGRAM-NAME(2),"rysdfcombv":U) > 0 THEN
    DISABLE coObjType WITH FRAME {&FRAME-NAME}.

  IF (glNew AND NOT glStaticSDF) THEN
    RETURN.

  RUN setFields (INPUT "Change":U).
  
  IF glStaticSDF AND NOT glNew THEN
    RUN disableButton IN hObjectFileName.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkForStaticSDF vTableWin 
PROCEDURE checkForStaticSDF :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will check if this SDF Maintenance window was 
               launched from a Static SDF field.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRunAttribute     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDFType          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hLookup           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lExisting         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hCompare          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cButton           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAnswer           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cHiddenActions    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hProdModCombo     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRepDesignManager AS HANDLE     NO-UNDO.  
  DEFINE VARIABLE cViewerFields     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSourceHandle AS HANDLE     NO-UNDO.
  
  glStaticSDF = FALSE.

  {get RunAttribute cRunAttribute ghContainerSource}.
  {get ContainerHandle hContainer ghContainerSource}.
       
  IF cRunAttribute <> "":U THEN
    ASSIGN ghSDFObject = WIDGET-HANDLE(ENTRY(1,cRunAttribute,CHR(3))) NO-ERROR.
  IF cRunAttribute = "":U OR 
     NOT VALID-HANDLE(ghSDFObject) THEN DO:
    ASSIGN fiValidTypes:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gcComboClasses + ",":U + gcLookupClasses.
    IF cRunAttribute = "":U THEN DO:
      hContainer:TITLE = hContainer:TITLE + " (Master Properties)".
      RETURN.
    END.
  END.
  
  IF VALID-HANDLE(ghSDFObject) THEN DO:
    /* Get details required for MAPPING fields */
    RUN returnViewerFields     IN ghSDFObject (OUTPUT cViewerFields) NO-ERROR.
    IF NOT ERROR-STATUS:ERROR THEN
      PUBLISH "viewerFields":U     FROM ghContainerSource (cViewerFields).

    RUN returnDataSourceHandle IN ghSDFObject (OUTPUT hDataSourceHandle) NO-ERROR.
    IF NOT ERROR-STATUS:ERROR THEN
      PUBLISH "dataSourceHandle":U FROM ghContainerSource (hDataSourceHandle).

  END.

  /* When user used 'Edit Master' option on popup menu */
  IF cRunAttribute <> "":U AND
     NOT VALID-HANDLE(ghSDFObject) THEN DO:
    hContainer:TITLE = hContainer:TITLE + " (Master Properties)".
    IF ENTRY(1,cRunAttribute,CHR(3)) = "NOMASTER":U THEN DO:
      RUN showMessages IN gshSessionManager (INPUT "No Master Object (SmartDataField) could be found for this object.",
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "No Master Exists",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
  
      RETURN "EXIT":U.
    END.
    glUpdateMasterOnly = TRUE.
    RUN setFields ("Find":U).
    RUN assignNewValue IN hObjectFilename (INPUT cRunAttribute,INPUT cRunAttribute,FALSE).
    cHiddenActions = cHiddenActions + (IF cHiddenActions = "":U THEN "":U ELSE ",":U)
                     + "cbSaveAs".
    DYNAMIC-FUNCTION("sethiddenActions":U IN ghToolbar, cHiddenActions).
    RETURN.
  END.

  IF VALID-HANDLE(ghSDFObject) THEN DO:
    glUpdateMasterOnly = FALSE.
    /* Set the Title to indicate that we are editing instance properties */
    hContainer:TITLE = hContainer:TITLE + " (Instance Properties)".
    
    glIsDynView = FALSE.
    IF DYNAMIC-FUNCTION("getViewerType":U IN ghSDFObject) BEGINS "Dyn":U THEN
      glIsDynView = TRUE.
    
    cSDFType = DYNAMIC-FUNCTION("getSDFType":U IN ghSDFObject) NO-ERROR.

    IF  LOOKUP(cSDFType, gcLookupClasses) = 0
    AND LOOKUP(cSDFType, gcComboClasses)  = 0
    THEN DO:
      MESSAGE "The Static SDF is invalid" cSDFType
              VIEW-AS ALERT-BOX ERROR.
    END.

    glStaticSDF = TRUE.
    RUN setFields ("New":U).
    glNew = TRUE.
    DO WITH FRAME {&FRAME-NAME}:
      IF LOOKUP(cSDFType, gcLookupClasses) <> 0 THEN
          ASSIGN coObjType:LIST-ITEMS = gcLookupClasses.
      ELSE
          ASSIGN coObjType:LIST-ITEMS = gcComboClasses.
      ASSIGN coObjType:SCREEN-VALUE = cSDFType NO-ERROR.
      APPLY "VALUE-CHANGED":U TO coObjType.
      ASSIGN fiValidTypes:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gcLookupClasses + ",":U + gcComboClasses.
    END.

    ASSIGN toSave:CHECKED IN FRAME {&FRAME-NAME} = TRUE.
    
    RUN enablefield IN hProductModule.
    IF NUM-ENTRIES(cRunAttribute,CHR(3)) >= 2 AND
       ENTRY(2,cRunAttribute,CHR(3)) <> "NEW":U THEN
    DO:
      RUN assignNewValue IN hObjectFileName (INPUT ENTRY(2,cRunAttribute,CHR(3)), INPUT ENTRY(2,cRunAttribute,CHR(3)), FALSE).
      /* If we are using an existing SDF - assign it's Super */
      IF VALID-HANDLE(ghDataTable) AND
         ghDataTable:AVAILABLE THEN 
      DO:
        IF ghDataTable:BUFFER-FIELD("cCustomSuperProc":U):BUFFER-VALUE <> "":U THEN
          RUN assignNewValue IN hCustomSuperProcedure (INPUT ghDataTable:BUFFER-FIELD("cCustomSuperProc":U):BUFFER-VALUE, INPUT "":U, INPUT FALSE).
        IF ghDataTable:BUFFER-FIELD("cDataSourceName":U):BUFFER-VALUE <> "":U THEN
        DO:
          setDataObjectName(ghDataTable:BUFFER-FIELD("cDataSourceName":U):BUFFER-VALUE).
          raSource:SCREEN-VALUE = "SDO":U.
          RUN enableField IN hDataObject.          
        END.
      END.
    END.
    ELSE DO:
      IF LOOKUP(cSDFType, gcComboClasses) <> 0 THEN
        ghDataTable = DYNAMIC-FUNCTION("getComboTable":U IN ghContainerSource).
      ELSE
        IF LOOKUP(cSDFType, gcLookupClasses) <> 0 THEN
          ghDataTable = DYNAMIC-FUNCTION("getLookupTable":U IN ghContainerSource).
      ghDataTable = ghDataTable:DEFAULT-BUFFER-HANDLE.
      ghDataTable:BUFFER-CREATE().
      /* Set default value */
      ASSIGN ghDataTable:BUFFER-FIELD("lUseCache":U):BUFFER-VALUE = TRUE.
      
      RUN populateSDFData IN ghSDFObject (INPUT-OUTPUT ghDataTable).
      /* If we are using an existing SDF - assign it's Super */
      IF VALID-HANDLE(ghDataTable) AND
         ghDataTable:AVAILABLE THEN 
      DO: 
        IF ghDataTable:BUFFER-FIELD("cCustomSuperProc":U):BUFFER-VALUE <> "":U THEN
          RUN assignNewValue IN hCustomSuperProcedure (INPUT ghDataTable:BUFFER-FIELD("cCustomSuperProc":U):BUFFER-VALUE, INPUT "":U, INPUT FALSE).
        IF ghDataTable:BUFFER-FIELD("cDataSourceName":U):BUFFER-VALUE <> "":U THEN
        DO:
          setDataObjectName(ghDataTable:BUFFER-FIELD("cDataSourceName":U):BUFFER-VALUE).
          raSource:SCREEN-VALUE = "SDO":U.
          RUN enableField IN hDataObject.          
        END.
      END.
    END.

    {get LookupHandle hLookup hObjectFileName}.
    
    IF VALID-HANDLE(ghDataTable) THEN DO:
      ghDataTable:FIND-FIRST().
      IF ghDataTable:AVAILABLE THEN DO:

        /* Allow the change of the Field Name if it is a local field */
        ASSIGN fiObjectDescription:SCREEN-VALUE = ghDataTable:BUFFER-FIELD("cObjectDescription":U):BUFFER-VALUE
               fiFieldName:SCREEN-VALUE         = ghDataTable:BUFFER-FIELD("cActualField":U):BUFFER-VALUE
               toUseCache:CHECKED               = ghDataTable:BUFFER-FIELD("lUseCache":U):BUFFER-VALUE.
        /*
        RUN assignSDFValues.
        */
        IF NUM-ENTRIES(cRunAttribute,CHR(3)) >= 3 AND
           ENTRY(3,cRunAttribute,CHR(3)) <> "":U THEN
          fiFieldName:SCREEN-VALUE = ENTRY(3,cRunAttribute,CHR(3)).
        IF fiFieldName:SCREEN-VALUE <> "":U AND
           NUM-ENTRIES(fiFieldName:SCREEN-VALUE,".":U) >= 3 AND
           ENTRY(1,fiFieldName:SCREEN-VALUE,".":U) = ENTRY(2,fiFieldName:SCREEN-VALUE,".":U) THEN
          fiFieldName:SCREEN-VALUE = SUBSTRING(fiFieldName:SCREEN-VALUE,LENGTH(ENTRY(1,fiFieldName:SCREEN-VALUE,".":U)) + 2).

        IF ghDataTable:BUFFER-FIELD("lLocalField":U):BUFFER-VALUE = TRUE AND 
           glIsDynView = FALSE THEN
          ENABLE fiFieldName toUseCache WITH FRAME {&FRAME-NAME}.

        /* If we are on a DynViewer, and we have been told by the caller
           that we are a NEW SDF, then ensure that we create a new Master
           object in addition (well, prior to) to the instance.
         */
        IF glIsDynView AND 
           num-entries(cRunAttribute, chr(3)) ge 2 and
           entry(2, cRunAttribute, chr(3)) eq 'New':u then
          glUpdateMasterOnly = TRUE.
          
        IF ghDataTable:BUFFER-FIELD("cSDFFileName":U):BUFFER-VALUE = "":U THEN DO:
          ASSIGN toSave:CHECKED IN FRAME {&FRAME-NAME} = FALSE.
          glCheckChange = FALSE.
          APPLY "VALUE-CHANGED":U TO toSave IN FRAME {&FRAME-NAME}.
          glCheckChange = TRUE.
          glNew = TRUE.
          {get ComboHandle hProdModCombo hProductModule}.
          ASSIGN hProdModCombo:LIST-ITEM-PAIRS = hProdModCombo:LIST-ITEM-PAIRS.
        END.
        ELSE DO:
          hLookup:SCREEN-VALUE = ghDataTable:BUFFER-FIELD("cSDFFileName":U):BUFFER-VALUE.
          /* First check if we have a valid smartobject that exists */
          /* Check whether object name already exists */
          ASSIGN hRepDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
          IF DYNAMIC-FUNCTION("ObjectExists":U IN hRepDesignManager, INPUT hLookup:SCREEN-VALUE) THEN DO:
            RUN disableField IN hObjectFileName.
            RUN disableField IN hProductModule.
            /* We need to get the field from the DB and do a buffer-compare */
            SESSION:SET-WAIT-STATE("GENERAL":U).
            DYNAMIC-FUNCTION("statusText":U IN ghContainerSource,"Retrieving data from Repository. Please Wait...").
            
            CREATE BUFFER hCompare FOR TABLE ghDataTable BUFFER-NAME "CompareBuffer".
  
            RUN getObjectDetail IN ghContainerSource (INPUT hLookup:SCREEN-VALUE,
                                                      OUTPUT ghDataTable).
            ghDataTable:FIND-FIRST().
            IF VALID-HANDLE(hCompare) THEN DO:
              hCompare:FIND-LAST().
              IF hCompare:AVAILABLE THEN DO WITH FRAME {&FRAME-NAME}:
                ASSIGN fiObjectDescription:SCREEN-VALUE = hCompare:BUFFER-FIELD("cObjectDescription":U):BUFFER-VALUE.
                DYNAMIC-FUNCTION("setDataValue":U IN hProductModule, hCompare:BUFFER-FIELD("cProductModule":U):BUFFER-VALUE).
                 /* Issue  20030718-002 , ColumnFormat from master not displayed */               
                IF LOOKUP(cSDFType, gcLookupClasses) > 0 AND  ghDataTable:BUFFER-FIELD("cColumnFormat":U):BUFFER-VALUE = "" THEN
                   ghDataTable:BUFFER-FIELD("cColumnFormat":U):BUFFER-VALUE = hCompare:BUFFER-FIELD("cColumnFormat":U):BUFFER-VALUE .
                glNew = FALSE.
                IF hCompare:BUFFER-COMPARE(ghDataTable,"","cActualField,cLookupImage,cObjectDescription,cProductModule,dFieldWidth","") = FALSE THEN DO:
                  ASSIGN buSynch:HIDDEN    = FALSE
                         buSynch:SENSITIVE = TRUE.
                  /* Delete the mast object's record from the temp-table */
                  ghDataTable:FIND-LAST().
                  ghDataTable:BUFFER-DELETE().
                END.
              END.
            END.
            DELETE WIDGET hCompare.
            SESSION:SET-WAIT-STATE("":U).
            DYNAMIC-FUNCTION("statusText":U IN ghContainerSource,"").
          END.
          /* SDF Name specified does not exist in Repository */
          ELSE DO:
            ASSIGN hLookup:SCREEN-VALUE = "":U.
            ASSIGN toSave:CHECKED = FALSE.
            APPLY "VALUE-CHANGED":U TO toSave.
          END.

        END.
        ENABLE toUseCache WITH FRAME {&FRAME-NAME}.
        
        IF glIsDynView AND VALID-HANDLE(ghToolbar) THEN
          DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, "New,cbCancel":U).
      END. /* Avail ghDataTable */
    END.
    
    /* Do not disable the Type combo if we have subclasses */
    IF NUM-ENTRIES(coObjType:LIST-ITEMS) = 1 OR NOT glNew THEN
      DISABLE coObjType WITH FRAME {&FRAME-NAME}.

    IF NOT glIsDynView OR lExisting = FALSE THEN DO:
      IF LOOKUP(cSDFType, gcLookupClasses) > 0 
      THEN DO:
        IF VALID-HANDLE(ghDynLookup) THEN
          RUN setInfo IN ghDynLookup (INPUT ghDataTable).
      END.
      ELSE
        IF LOOKUP(cSDFType, gcComboClasses) > 0 
        THEN DO:
            IF VALID-HANDLE(ghDynCombo) THEN
              RUN setInfo IN ghDynCombo (INPUT ghDataTable).
        END.
    END.
  END.
  
  /* Ensure the Product Module combo doesn't show values */
  IF NOT glUpdateMasterOnly THEN DO:
    {get ComboHandle hProdModCombo hProductModule}.
    hProdModCombo:LIST-ITEM-PAIRS = hProdModCombo:LIST-ITEM-PAIRS.
    /* Also ensure that super procedure lookup is disabled */
    RUN disableField IN hCustomSuperProcedure.
    
    IF VALID-HANDLE(ghSDFObject) AND 
       DYNAMIC-FUNCTION("isOnLocalField":U IN ghSDFObject) = TRUE AND
       glIsDynView = FALSE THEN
      ENABLE fiFieldName WITH FRAME {&FRAME-NAME}.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkIfSDFExists vTableWin 
PROCEDURE checkIfSDFExists :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hLookup            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cMessage           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRepDesignManager  AS HANDLE     NO-UNDO.
  
  {get LookupHandle hLookup hObjectFileName}.
  
  /* Check whether object name already exists */
  ASSIGN hRepDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
  IF DYNAMIC-FUNCTION("ObjectExists":U IN hRepDesignManager,INPUT hLookup:SCREEN-VALUE )  THEN
  DO:
    cMessage = hLookup:SCREEN-VALUE + " already exists in the repository.~n~n" +
               "To avoid overwriting it, please specify another object name or select the existing master ~n" +
               "from the SmartDataField lookup.".
    RUN showMessages IN gshSessionManager (INPUT cMessage,
                                           INPUT "INF":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Already exists",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).
    RETURN "OBJECT-EXISTS".
  END.  /* if it exists */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE comboValueChanged vTableWin 
PROCEDURE comboValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcKeyFieldValue  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcScreenValue    AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phField          AS HANDLE     NO-UNDO.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataChanged vTableWin 
PROCEDURE dataChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMessageList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAnswer      AS CHARACTER  NO-UNDO.
  
  IF glNeedToSave OR
     (glNew AND NOT glStaticSDF) THEN DO:
    cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                  {af/sup2/aferrortxt.i 'AF' '131' '' '' '"this SmartDataField"'}.
    RUN askQuestion IN gshSessionManager (INPUT cMessageList,    /* message to display */
                                          INPUT "&YES,&NO,&Cancel":U,    /* button list */
                                          INPUT "&YES":U,                /* default button */ 
                                          INPUT "&Cancel":U,             /* cancel button */
                                          INPUT "Add new SmartObject":U, /* window title */
                                          INPUT "":U,                    /* data type of question */ 
                                          INPUT "":U,                    /* format mask for question */ 
                                          INPUT-OUTPUT cAnswer,                 /* character value of answer to question */ 
                                                 OUTPUT cButton                  /* button pressed */
                                           ).
    /* Save before we close */
    IF cButton = "&YES":U THEN 
      RETURN "NEED_TO_SAVE":U.
  
    /* Don't save - just leave */
    IF cButton = "&NO":U THEN 
      RETURN.
  
    /* Just return back to screen */
    IF cButton = "&Cancel":U THEN 
      RETURN "DO_NOTHING":U.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject vTableWin 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */


  DEFINE VARIABLE h AS HANDLE     NO-UNDO.
  DEFINE VARIABLE h2 AS HANDLE     NO-UNDO.
  h = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(h).
    h2 = h.
    h = h:NEXT-SIBLING.
    IF VALID-HANDLE(h2) AND 
       INDEX(h2:FILE-NAME,"rysdfsuprp") > 0 THEN
      DELETE PROCEDURE h2.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI vTableWin  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME frMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAppBuilder   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hObjectLookup AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRunAttribute AS CHARACTER  NO-UNDO.

  ASSIGN gcComboClasses  = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "dynLookup,dynCombo")
         gcLookupClasses = ENTRY(1, gcComboClasses, CHR(3))
         gcComboClasses  = ENTRY(2, gcComboClasses, CHR(3)).

  ASSIGN fiDataObjectTypes:SCREEN-VALUE IN FRAME {&FRAME-NAME} = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "Data":U).
  
  /* Code placed here will execute PRIOR to standard behavior. */
  {get ContainerSource ghContainerSource}.  
  {get RunAttribute cRunAttribute ghContainerSource}.
   
  IF cRunAttribute <> "":U THEN 
    ghSDFObject = WIDGET-HANDLE(ENTRY(1,cRunAttribute,CHR(3))) NO-ERROR.

  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "lookupDisplayComplete":U  IN THIS-PROCEDURE.
  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "enableSearchLookups":U    IN ghContainerSource.
  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "enableViewerObjects":U    IN ghContainerSource.
  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "comboValueChanged":U      IN THIS-PROCEDURE.
  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "lookupComplete":U         IN THIS-PROCEDURE.
  
  RUN SUPER.
  
  {set FieldHidden TRUE hResultCode}.
  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    RUN adjustTabOrder (hObjectFilename,       hResultCode,                'BEFORE':U).
    
    RUN resizeObject (FRAME {&FRAME-NAME}:HEIGHT-CHARS, FRAME {&FRAME-NAME}:WIDTH-CHARS).
  END.
  
  ghDynLookup = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U,"DynLookup-Target":U)).
  ghDynCombo = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U,"DynCombo-Target":U)).
  
  cAppBuilder = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "AppBuilder":U).
  
  IF cAppBuilder = "yes":U THEN
      glAppBuilder = TRUE.
  
  RUN displayFields  IN TARGET-PROCEDURE (?).
  
  APPLY "VALUE-CHANGED":U TO coObjType IN FRAME {&FRAME-NAME}.
  SUBSCRIBE TO "changesMade":U IN ghContainerSource.

  {get LookupHandle hObjectLookup hObjectFileName}.
  
  ON RETURN OF hObjectLookup OR LEAVE OF hObjectLookup OR TAB OF hObjectLookup PERSISTENT RUN leftLookup IN TARGET-PROCEDURE.
  
  ON ANY-PRINTABLE OF hObjectLookup PERSISTENT RUN leaveObjectNameLookup IN TARGET-PROCEDURE.
  
  RUN adjustTabOrder (hObjectFilename,coObjType:HANDLE,"BEFORE":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveObjectNameLookup vTableWin 
PROCEDURE leaveObjectNameLookup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DYNAMIC-FUNCTION("setDataModified":U IN hObjectFileName, TRUE).
  IF glNew AND glStaticSDF THEN
    RUN changesMade.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leftLookup vTableWin 
PROCEDURE leftLookup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hLookup AS HANDLE     NO-UNDO.

/* To fix issue #8012 */
IF glValidationError THEN DO:
  glValidationError = FALSE.
  RETURN.
END.

{get LookupHandle hLookup hObjectFileName}.

IF glNew AND glStaticSDF AND hLookup:SCREEN-VALUE = "":U THEN
  RETURN.

IF glNew AND (LASTKEY = KEYCODE("TAB") OR 
              LASTKEY = 609 /* Mouse Click */ OR 
              LASTKEY = 619 OR 
              LASTKEY = -1 OR 
              LASTKEY = 13) AND NOT glAppliedLeave THEN DO:
  
  glAppliedLeave = TRUE.
  RUN leavelookup IN hObjectFileName.
  RETURN.
END.

IF NOT glNew AND hLookup:SCREEN-VALUE <> "":U THEN
  RUN leavelookup IN hObjectFileName.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lookupComplete vTableWin 
PROCEDURE lookupComplete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcColumnNames           AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcColumnValues          AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcKeyFieldValue         AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcDisplayedFieldValue   AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcOldFieldValue         AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER plLookup                AS LOGICAL      NO-UNDO.
  DEFINE INPUT  PARAMETER phObject                AS HANDLE       NO-UNDO.

  DEFINE VARIABLE cMessage           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessageList       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hLookupFillin      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cProductModule     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAnswer            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPath              AS CHARACTER  NO-UNDO.

  IF 1 = 2 THEN VIEW FRAME {&FRAME-NAME}. /* Lazy frame scoping */
  /* Check if it was a valid object */
  IF phObject = hObjectFileName THEN DO:
    IF (pcKeyFieldValue = "":U OR pcColumnValues = "":U OR NUM-ENTRIES(pcColumnNames) <> NUM-ENTRIES(pcColumnValues, CHR(1))) AND NOT glNew THEN
    DO:
      glUsedExisting = FALSE.
      cMessage = "Could find details for this Smart Data Field " + pcDisplayedFieldValue.
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '11' '' '' '"SmartObject Record"' '"the name you specified"'}.
       
      RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Error - Smart Data Field not found",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
      RETURN.
    END.
    /* We are adding a new record */
    IF pcDisplayedFieldValue <> "":U AND glNew THEN DO:
      glUsedExisting = FALSE.
      IF NOT glStaticSDF THEN DO:
        {get LookupHandle hLookupFillin hObjectFileName}.
        hLookupFillin:SCREEN-VALUE = pcDisplayedFieldValue.
        IF VALID-HANDLE(ghDataTable) THEN DO:
          ghDataTable:EMPTY-TEMP-TABLE().
          ghDataTable = ?.
        END.
        IF coObjType:SCREEN-VALUE = ? THEN
           coObjType:SCREEN-VALUE = coObjType:ENTRY(1).
        IF LOOKUP(coObjType:SCREEN-VALUE, gcComboClasses) > 0 THEN
          ghDataTable = DYNAMIC-FUNCTION("getComboTable":U IN ghContainerSource).
        ELSE
          IF LOOKUP(coObjType:SCREEN-VALUE, gcLookupClasses) > 0 THEN
              ghDataTable = DYNAMIC-FUNCTION("getLookupTable":U IN ghContainerSource).
        ghDataTable = ghDataTable:DEFAULT-BUFFER-HANDLE.
        ghDataTable:BUFFER-CREATE().
        IF NOT glStaticSDF THEN DO:
          IF LOOKUP(coObjType:SCREEN-VALUE, gcLookupClasses) > 0 
          THEN DO:
            IF VALID-HANDLE(ghDynLookup) THEN
              RUN setInfo IN ghDynLookup (INPUT ghDataTable).
          END.
          ELSE 
          IF LOOKUP(coObjType:SCREEN-VALUE, gcComboClasses) > 0 
          THEN DO:
              IF VALID-HANDLE(ghDynCombo) THEN
                RUN setInfo IN ghDynCombo (INPUT ghDataTable).
          END.
        END.
      END.
      ELSE DO: /* Static SDFs */
        
        /* The user specified a valid SDF */
        IF pcKeyFieldValue <> "":U THEN DO:
          /* Check if we should warn the user that we will be throwing away any
             existing data in all the fields */
          IF VALID-HANDLE(ghDataTable) THEN DO:
            ghDataTable:FIND-FIRST() NO-ERROR.
            IF ghDataTable:AVAILABLE AND 
               (ghDataTable:BUFFER-FIELD("cBaseQueryString"):BUFFER-VALUE <> "":U OR 
                ghDataTable:BUFFER-FIELD("cDataSourceName"):BUFFER-VALUE <> "":U) THEN DO:
              cMessage = "You have selected an existing SmartDataField to be used, but it seems that you " +
                         "have already specified some details for this SmartDataField.~n~nDo you wish to continue loading " +
                         "the data from the selected SmartDataField and clear any existing details for this SmartDataField?".
              RUN askQuestion IN gshSessionManager (INPUT cMessage,         /* messages */
                                                    INPUT "&Yes,&No":U,     /* button list */
                                                    INPUT "&Yes":U,          /* default */
                                                    INPUT "&No":U,          /* cancel */
                                                    INPUT "Use Existing SmartDataField":U,     /* title */
                                                    INPUT "":U,             /* datatype */
                                                    INPUT "":U,             /* format */
                                                    INPUT-OUTPUT cAnswer,   /* answer */
                                                    OUTPUT cButton          /* button pressed */
                                                    ).
              IF cButton <> "&YES":U THEN DO:
                {get LookupHandle hLookupFillin hObjectFileName}.
                IF VALID-HANDLE(ghDataTable) THEN
                  hLookupFillin:SCREEN-VALUE = ghDataTable:BUFFER-FIELD("cActualField":U):BUFFER-VALUE.
                ELSE
                  hLookupFillin:SCREEN-VALUE = "":U.
                RETURN.
              END.
                
            END.
          END.
          glUsedExisting = TRUE.
          IF VALID-HANDLE(ghDataTable) THEN DO:
            ghDataTable:EMPTY-TEMP-TABLE().
            ghDataTable = ?.
          END.
          SESSION:SET-WAIT-STATE("GENERAL":U).
          DYNAMIC-FUNCTION("statusText":U IN ghContainerSource,"Retrieving data from Repository. Please Wait...").

          RUN getObjectDetail IN ghContainerSource (INPUT pcDisplayedFieldValue,
                                                    OUTPUT ghDataTable).
          IF VALID-HANDLE(ghDataTable) THEN DO:
            ghDataTable:FIND-FIRST().
            IF ghDataTable:AVAILABLE THEN DO WITH FRAME {&FRAME-NAME}:
              IF LOOKUP(coObjType:SCREEN-VALUE, gcLookupClasses) > 0 
              THEN DO:
                  IF VALID-HANDLE(ghDynLookup) THEN
                    RUN setInfo IN ghDynLookup (INPUT ghDataTable).
              END.
              ELSE
                  IF LOOKUP(coObjType:SCREEN-VALUE, gcComboClasses) > 0 
                  THEN DO:
                      IF VALID-HANDLE(ghDynCombo) THEN
                        RUN setInfo IN ghDynCombo (INPUT ghDataTable).
                      RUN assignNewValue IN hDataObject(INPUT ghDataTable:BUFFER-FIELD("cDataSourceName":U):BUFFER-VALUE,
                                                        INPUT ghDataTable:BUFFER-FIELD("cDataSourceName":U):BUFFER-VALUE,
                                                        INPUT FALSE).  
                  END.
            END.
          END.
          SESSION:SET-WAIT-STATE("":U).
          DYNAMIC-FUNCTION("statusText":U IN ghContainerSource,"":U).
          IF VALID-HANDLE(ghDataTable) THEN DO:
            ghDataTable:FIND-FIRST() NO-ERROR.
            IF ghDataTable:AVAILABLE AND 
               (ghDataTable:BUFFER-FIELD("cBaseQueryString"):BUFFER-VALUE <> "":U OR 
                ghDataTable:BUFFER-FIELD("cDataSourceName"):BUFFER-VALUE <> "":U) THEN DO:
              /* Now that we have loaded the data - we need to disable the UI and
                 just leave the user to save this data to the SDV or cancel.
                 This is done since we do not want them to make changes to the 
                 master record and save this record again - they can only change
                 the master using the SDF Maintenance window from the Build menu */
              DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, "New,cbCopy,cbDelete,cbFind,cbUndo":U).
              DYNAMIC-FUNCTION("enableActions":U IN ghToolbar, "cbSave,cbCancel":U).
              RUN disableField IN hObjectFileName.
              RUN disableField IN hProductModule.
              RUN disableField IN hCustomSuperProcedure.
              ASSIGN toSave:CHECKED IN FRAME {&FRAME-NAME} = FALSE.
              DISABLE fiObjectDescription toUseCache toSave buWhereUsed buSynchInstances WITH FRAME {&FRAME-NAME}.
              PUBLISH "disableObject" FROM ghContainerSource.
              glNeedToSave = TRUE.
              DYNAMIC-FUNCTION("statusText":U IN ghContainerSource,"Click on the Save to save to your SDF or Cancel for a new SDF":U).
              IF pcColumnValues <> "":U AND 
                 pcColumnValues <> ? THEN DO:
                cProductModule = ENTRY(LOOKUP("gsc_product_module.product_module_code",pcColumnNames),pcColumnValues,CHR(1)).
                {set DataValue cProductModule hProductModule }.
              END.
            END.
          END.
          ELSE DO:
            IF VALID-HANDLE(ghDataTable) THEN DO:
              ghDataTable:EMPTY-TEMP-TABLE().
              ghDataTable = ?.
            END.
            IF coObjType:SCREEN-VALUE = ? THEN
              coObjType:SCREEN-VALUE = coObjType:ENTRY(1).
            IF LOOKUP(coObjType:SCREEN-VALUE, gcComboClasses) > 0 THEN
              ghDataTable = DYNAMIC-FUNCTION("getComboTable":U IN ghContainerSource).
            ELSE
              IF LOOKUP(coObjType:SCREEN-VALUE, gcLookupClasses) > 0 THEN
                ghDataTable = DYNAMIC-FUNCTION("getLookupTable":U IN ghContainerSource).
            ghDataTable = ghDataTable:DEFAULT-BUFFER-HANDLE.
            ghDataTable:BUFFER-CREATE().
            IF NOT glStaticSDF THEN DO:
              IF LOOKUP(coObjType:SCREEN-VALUE, gcLookupClasses) > 0 
              THEN DO:
                IF VALID-HANDLE(ghDynLookup) THEN
                  RUN setInfo IN ghDynLookup (INPUT ghDataTable).
              END.
              ELSE 
                IF LOOKUP(coObjType:SCREEN-VALUE, gcComboClasses) > 0 
                THEN DO:
                  IF VALID-HANDLE(ghDynCombo) THEN
                    RUN setInfo IN ghDynCombo (INPUT ghDataTable).
                END.
            END.
          END.
        END.
        ELSE DO: /* If not, then just make sure that the name is displayed in the lookup field */
          {get LookupHandle hLookupFillin hObjectFileName}.
          hLookupFillin:SCREEN-VALUE = pcDisplayedFieldValue.
        END.
      END.
    END.
    ELSE DO:
      IF VALID-HANDLE(ghDataTable) THEN DO:
        ghDataTable:EMPTY-TEMP-TABLE().
        ghDataTable = ?.
      END.
      IF fiObjectDescription:SCREEN-VALUE = ? OR 
         fiObjectDescription:SCREEN-VALUE = "?":U THEN
        ASSIGN fiObjectDescription:SCREEN-VALUE = "":U.
      SESSION:SET-WAIT-STATE("GENERAL":U).

      /* Determine what the object type is, rebuild and reposition the combo */
      DEFINE VARIABLE cObjectTypeCode AS CHARACTER  NO-UNDO.
      ASSIGN coObjType:LIST-ITEMS = gcComboClasses + "," + gcLookupClasses
             cObjectTypeCode      = ENTRY(LOOKUP("gsc_object_type.object_type_code":U, pcColumnNames), pcColumnValues, CHR(1)) NO-ERROR.
      IF LOOKUP(cObjectTypeCode, gcLookupClasses) <> 0 THEN
          ASSIGN coObjType:LIST-ITEMS = gcLookupClasses.
      ELSE
          IF LOOKUP(cObjectTypeCode, gcComboClasses) <> 0 THEN
            ASSIGN coObjType:LIST-ITEMS = gcComboClasses.

      ASSIGN coObjType:SCREEN-VALUE = cObjectTypeCode NO-ERROR.
      IF coObjType:SCREEN-VALUE = ? OR coObjType:SCREEN-VALUE = "" THEN
          ASSIGN coObjType:SCREEN-VALUE = coObjType:ENTRY(1) NO-ERROR.

      APPLY "VALUE-CHANGED":U TO coObjType IN FRAME {&FRAME-NAME}.

      DYNAMIC-FUNCTION("statusText":U IN ghContainerSource,"Retrieving data from Repository. Please Wait...").
      
      RUN getObjectDetail IN ghContainerSource (INPUT pcDisplayedFieldValue,
                                                OUTPUT ghDataTable).
      IF VALID-HANDLE(ghDataTable) THEN DO:
        ghDataTable:FIND-FIRST().
        IF ghDataTable:AVAILABLE THEN DO WITH FRAME {&FRAME-NAME}:
          RUN assignSDFValues.

          IF LOOKUP(coObjType:SCREEN-VALUE, gcLookupClasses) > 0 
          THEN DO:
              IF VALID-HANDLE(ghDynLookup) THEN
                RUN setInfo IN ghDynLookup (INPUT ghDataTable).
          END.
          ELSE
              IF LOOKUP(coObjType:SCREEN-VALUE, gcComboClasses) > 0 
              THEN DO:
                  IF VALID-HANDLE(ghDynCombo) THEN
                    RUN setInfo IN ghDynCombo (INPUT ghDataTable).
              END.
        END.
      END.
      SESSION:SET-WAIT-STATE("":U).
      DYNAMIC-FUNCTION("statusText":U IN ghContainerSource,"":U).
    END.
    DO WITH FRAME {&FRAME-NAME}:
      IF NOT glNew THEN DO:
        cProductModule = ENTRY(LOOKUP("gsc_product_module.product_module_code",pcColumnNames),pcColumnValues,CHR(1)).
        {set DataValue cProductModule hProductModule }.
      END.
    END.
    IF NOT glNew THEN
      RUN setFields (INPUT "Modify":U).
  END.
  ELSE IF phObject = hDataObject THEN
  DO:
    IF pcDisplayedFieldValue <> pcOldFieldValue THEN
    DO:
      IF VALID-HANDLE(ghDynCombo) THEN
      DO:
        DYNAMIC-FUNCTION('setDataSourceName':U IN ghDynCombo, INPUT pcDisplayedFieldValue).
        RUN populateComboFromSDO IN ghDynCombo.
      END.
      RUN changesMade.
    END.
  END.
  ELSE IF phObject = hCustomSuperProcedure THEN
  DO:
    IF pcDisplayedFieldValue <> pcOldFieldValue THEN
    RUN changesMade.
  END.
  ELSE DO:
      IF pcDisplayedFieldValue <> pcOldFieldValue AND
       pcDisplayedFieldValue <> "":U THEN
      RUN changesMade.
  END. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeSDF vTableWin 
PROCEDURE removeSDF :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSDFFileName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAnswer      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton      AS CHARACTER  NO-UNDO.

  RUN askQuestion IN gshSessionManager (INPUT "Do you wish to delete the current SmartDataField?",      /* messages */
                                        INPUT "&Yes,&No":U,     /* button list */
                                        INPUT "&No":U,          /* default */
                                        INPUT "&No":U,          /* cancel */
                                        INPUT "Delete SmartDataField":U,     /* title */
                                        INPUT "":U,             /* datatype */
                                        INPUT "":U,             /* format */
                                        INPUT-OUTPUT cAnswer,   /* answer */
                                        OUTPUT cButton          /* button pressed */
                                        ).
  IF cButton <> "&YES":U THEN
    RETURN.

  SESSION:SET-WAIT-STATE("GENERAL":U).
  {get DataValue cSDFFileName hObjectFileName}.
  DYNAMIC-FUNCTION("statusText":U IN ghContainerSource,"Removing SmartDataField from repository. Please Wait...").
  
  RUN removeSDF IN ghContainerSource (INPUT cSDFFileName).
  SESSION:SET-WAIT-STATE("":U).

  IF ERROR-STATUS:ERROR OR
     RETURN-VALUE <> "":U THEN DO:
    RUN showMessages IN gshSessionManager (INPUT RETURN-VALUE,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Error Removing SmartDataField",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).
    RETURN.
  END.
  DYNAMIC-FUNCTION("statusText":U IN ghContainerSource,"").
  clearDetails(TRUE).
  RUN setFields ("Find":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetData vTableWin 
PROCEDURE resetData :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will cancel any changes made without saving and 
               reset the data back to the original state
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSDFName AS CHARACTER  NO-UNDO.

  IF NOT VALID-HANDLE(ghDataTable) THEN DO:
    cSDFName = DYNAMIC-FUNCTION("getDataValue":U IN hObjectFilename).
    RUN getObjectDetail IN ghContainerSource (INPUT cSDFName,
                                              OUTPUT ghDataTable).
  END.
  
  IF VALID-HANDLE(ghDataTable) THEN DO:
    clearDetails(FALSE).
    RUN assignSDFValues.
    ghDataTable:FIND-FIRST().
    IF ghDataTable:AVAILABLE THEN DO WITH FRAME {&FRAME-NAME}:
      IF LOOKUP(coObjType:SCREEN-VALUE, gcLookupClasses) <> 0 
      THEN DO:
          IF VALID-HANDLE(ghDynLookup) THEN
            RUN setInfo IN ghDynLookup (INPUT ghDataTable).
      END.
      ELSE
          IF LOOKUP(coObjType:SCREEN-VALUE, gcComboClasses) <> 0 
          THEN DO:
              IF VALID-HANDLE(ghDynCombo) THEN
                RUN setInfo IN ghDynCombo (INPUT ghDataTable).
          END.
    END.
  END.
  RUN setFields (INPUT "Modify":U).
  
  glNeedToSave = FALSE.
  IF glStaticSDF THEN
    RUN disableButton IN hObjectFileName.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject vTableWin 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdHeight AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth  AS DECIMAL    NO-UNDO.

  IF pdWidth < FRAME {&FRAME-NAME}:WIDTH-CHARS THEN
  DO:
    RUN resizeViewerObjects (INPUT pdHeight, INPUT pdWidth).
    
    FRAME {&FRAME-NAME}:WIDTH-CHARS = pdWidth.
  END.
  ELSE
  DO:
    FRAME {&FRAME-NAME}:WIDTH-CHARS = pdWidth.
  
    RUN resizeViewerObjects (INPUT pdHeight, INPUT pdWidth).
  END.
  
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeViewerObjects vTableWin 
PROCEDURE resizeViewerObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdHeight AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth  AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE dNewColumn      AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dNewWidth       AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lSuccess        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hLabelHandle    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hHandle         AS HANDLE     NO-UNDO.
  
  IF DYNAMIC-FUNCTION("getObjectInitialized":U) = FALSE THEN
    RETURN.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        hLabelHandle  = DYNAMIC-FUNCTION("getLabelHandle":U  IN hCustomSuperProcedure)
        dNewWidth     = pdWidth - (hLabelHandle:WIDTH-CHARS + 0.50) - fiObjectDescription:COLUMN
        dNewWidth     = dNewWidth / 2
        dNewColumn    = fiObjectDescription:COLUMN + hLabelHandle:WIDTH-CHARS + dNewWidth + .5
        hHandle       = fiFieldName:SIDE-LABEL-HANDLE
        
        fiObjectDescription:WIDTH-CHARS  = dNewWidth
        coObjType:WIDTH-CHARS            = dNewWidth
        buWhereUsed:COLUMN               = dNewColumn + 5
        buSynchInstances:COLUMN          = dNewColumn + 5
        toSave:COLUMN                    = dNewColumn + 5
        toUSeCache:COLUMN                = dNewColumn + 5
        fiFieldName:COLUMN               = dNewColumn + 5
        fiFieldName:WIDTH                = dNewWidth - 4.80
        hHandle:COLUMN                   = (dNewColumn + 5) - hHandle:WIDTH
        buSynch:COLUMN                   = pdWidth - buSynch:WIDTH - 1
        .

    RUN resizeObject      IN hCustomSuperProcedure (1.00, dNewWidth).
    RUN resizeObject      IN hObjectFilename       (1.00, dNewWidth).
    RUN resizeObject      IN hResultCode           (1.00, dNewWidth).
    RUN repositionObject  IN hProductModule        (1.00, dNewColumn + 5).
    RUN resizeObject      IN hProductModule        (1.05, dNewWidth - 4.80).
    RUN resizeObject      IN hDataObject           (1.00, dNewWidth).
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveAs vTableWin 
PROCEDURE saveAs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAnswer       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hLookup       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cMessageList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPrefValue    AS CHARACTER  NO-UNDO.

  {get LookupHandle hLookup hObjectFileName}.

  RUN askQuestion IN gshSessionManager (INPUT        "Enter the new name to save this SmartDataField as",    /* message to display */
                                         INPUT        "&Save,&Cancel":U,    /* button list */
                                         INPUT        "&Save":U,                /* default button */ 
                                         INPUT        "&Cancel":U,             /* cancel button */
                                         INPUT        "Save SmartDataField As...":U, /* window title */
                                         INPUT        "CHARACTER":U,                    /* data type of question */ 
                                         INPUT        "X(30)":U,                    /* format mask for question */ 
                                         INPUT-OUTPUT cAnswer,                 /* character value of answer to question */ 
                                               OUTPUT cButton                  /* button pressed */
                                         ).
  
  IF cButton = "&Cancel" THEN
    RETURN.

  IF cAnswer = "":U THEN DO:
    cMessageList = {af/sup2/aferrortxt.i 'AF' '5' '' '' '"new SmartDataField name"'}.
    RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "New SmartDataField name required",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).
    RUN saveAs.
    RETURN.
  END.

  cPrefValue = hLookup:SCREEN-VALUE.
  hLookup:SCREEN-VALUE = cAnswer.
  RUN checkIfSDFExists.
  IF RETURN-VALUE = "OBJECT-EXISTS" THEN DO:
    hLookup:SCREEN-VALUE = cPrefValue.
    RUN saveAs.
    RETURN.
  END.

  RUN changesMade.
  ASSIGN glNew       = TRUE
         glStaticSDF = FALSE.
  RUN enableField IN hProductModule.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveDetails vTableWin 
PROCEDURE saveDetails :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will save the details back to the temp-table and
               ensure that data is saved back to the repository.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataTable      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hObjectLookup   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cButton         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProductModule  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cError          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRunAttribute   AS CHARACTER  NO-UNDO.

  {get RunAttribute cRunAttribute ghContainerSource}.

  SESSION:SET-WAIT-STATE("GENERAL":U).

  IF 1 = 2 THEN VIEW FRAME {&FRAME-NAME}. /* Lazy frame scoping */

  ASSIGN fiObjectDescription
         fiFieldName
         toUseCache.
  
  {get LookupHandle hObjectLookup hObjectFileName}.
  {get DataValue cProductModule hProductModule}.

  IF LOOKUP(coObjType:SCREEN-VALUE, gcLookupClasses) > 0 
  THEN DO:
      IF VALID-HANDLE(ghDynLookup) THEN DO:
        RUN assignValues IN ghDynLookup.
        hDataTable = DYNAMIC-FUNCTION("getDataTable":U IN ghDynLookup).
      END.
  END.
  ELSE 
      IF LOOKUP(coObjType:SCREEN-VALUE, gcComboClasses) > 0
      THEN DO:
          IF VALID-HANDLE(ghDynCombo) THEN DO:
            RUN assignValues IN ghDynCombo.
            hDataTable = DYNAMIC-FUNCTION("getDataTable":U IN ghDynCombo).
          END.
      END.

  IF VALID-HANDLE(hDataTable) THEN DO:
    hDataTable:FIND-FIRST().
    ASSIGN hDataTable:BUFFER-FIELD("cSDFFileName":U):BUFFER-VALUE       = hObjectLookup:SCREEN-VALUE
           hDataTable:BUFFER-FIELD("cObjectDescription":U):BUFFER-VALUE = fiObjectDescription
           hDataTable:BUFFER-FIELD("cActualField":U):BUFFER-VALUE       = fiFieldName
           hDataTable:BUFFER-FIELD("cCustomSuperProc":U):BUFFER-VALUE   = DYNAMIC-FUNCTION("getDataValue":U IN hCustomSuperProcedure)
           hDataTable:BUFFER-FIELD("lUseCache":U):BUFFER-VALUE          = toUseCache.
  END.
  
  /* Save to the Repository */
  IF (glStaticSDF AND toSave AND glNew) OR
     NOT glStaticSDF OR 
     (glIsDynView AND glStaticSDF AND glUpdateMasterOnly) THEN DO:
    RUN saveSDFInfo IN ghContainerSource (INPUT hDataTable,
                                          INPUT coObjType:SCREEN-VALUE,
                                          INPUT cProductModule).
    SESSION:SET-WAIT-STATE("":U).
    IF ERROR-STATUS:ERROR OR
       RETURN-VALUE <> "":U THEN DO:
      cError = RETURN-VALUE.
      SESSION:SET-WAIT-STATE("":U).
      RUN showMessages IN gshSessionManager (INPUT RETURN-VALUE,
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Error Saving SDF to Repository",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
      RETURN cError.
    END.
  END.

  /* If updating the master object, set the instance values 
     by running the 'Set' functions for all attributes */ 
  IF glUpdateMasterOnly THEN
     RUN SetSDFMaster IN THIS-PROCEDURE (INPUT hDataTable).

  /* Save to Static SDF */
  IF glStaticSDF AND
     VALID-HANDLE(ghSDFObject) THEN DO:
    SESSION:SET-WAIT-STATE("GENERAL":U).
    RUN saveSDFDetails IN ghSDFObject (INPUT hDataTable).
    SESSION:SET-WAIT-STATE("":U).
    IF ERROR-STATUS:ERROR OR
       RETURN-VALUE <> "":U THEN DO:
      cError = RETURN-VALUE.
      SESSION:SET-WAIT-STATE("":U).
      RUN showMessages IN gshSessionManager (INPUT RETURN-VALUE,
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Error Saving SDF to Static Object",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
      RETURN cError.
    END.
    /* This is to ensure that the buttons on the toolbar is not reset */
    glNeedToSave = FALSE.
  END.

  IF VALID-HANDLE(hDataTable) THEN DO:
    hDataTable = ?.
  END.
  glNeedToSave = FALSE.
  
  IF NUM-ENTRIES(cRunAttribute,CHR(3)) >= 2 AND
   ENTRY(2,cRunAttribute,CHR(3)) = "NEW":U THEN 
    DYNAMIC-FUNCTION("setRunAttribute":U IN ghContainerSource, REPLACE(cRunAttribute,"NEW":U,hObjectLookup:SCREEN-VALUE)).

  SESSION:SET-WAIT-STATE("":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFields vTableWin 
PROCEDURE setFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcState AS CHARACTER  NO-UNDO.
    
  DEFINE VARIABLE hLookup         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataSourceName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRunAttribute   AS CHARACTER  NO-UNDO.

  IF NOT VALID-HANDLE(ghToolbar) THEN
    RETURN.

  ASSIGN glNew = FALSE.
  RUN enableButton IN hObjectFilename.
  
  {get LookupHandle hLookup hObjectFileName}.
  {get RunAttribute cRunAttribute ghContainerSource}.

  IF glStaticSDF AND NOT glIsDynView THEN 
    ASSIGN toSave:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE
           toSave:HIDDEN IN FRAME {&FRAME-NAME} = FALSE.
  ELSE
    ASSIGN toSave:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE
           toSave:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.

  ASSIGN toUSeCache:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.

  IF glStaticSDF AND toSave:CHECKED AND hLookup:SENSITIVE THEN
    glNew = TRUE.
  
  IF NUM-ENTRIES(cRunAttribute,CHR(3)) >= 2 AND
       ENTRY(2,cRunAttribute,CHR(3)) = "NEW":U THEN 
      glNew = TRUE.
  
  CASE pcState:
    WHEN "Init" THEN DO:
      DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, "cbModify,cbCancel,cbCopy,cbDelete,cbSave,cbSaveAs,cbFind,cbUndo":U).
    END.
    WHEN "New":U THEN DO:
      ASSIGN buSynch:HIDDEN    = TRUE
             buSynch:SENSITIVE = FALSE.
      ASSIGN glAppliedLeave = FALSE.
      DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, "New,cbCopy,cbDelete,cbSaveAs,cbFind,cbUndo":U).

      RUN enableField IN hObjectFilename.
      IF NOT glStaticSDF THEN DO:
        DYNAMIC-FUNCTION("enableActions":U IN ghToolbar, "cbSave,cbCancel":U).
        RUN enableField IN hProductModule.
        RUN disableButton IN hObjectFilename.
      END.
      
      RUN enableField IN hCustomSuperProcedure.
      
      DISABLE buWhereUsed buSynchInstances WITH FRAME {&FRAME-NAME}.
      ASSIGN coObjType:LIST-ITEMS   = gcLookupClasses + "," + gcComboClasses
             coObjType:SCREEN-VALUE = coObjType:ENTRY(1) NO-ERROR.
      APPLY "value-changed":U TO coObjType.
      ENABLE coObjType fiObjectDescription toUseCache
             WITH FRAME {&FRAME-NAME}.
      PUBLISH "disableObject" FROM ghContainerSource.
      glNew = TRUE.
      DYNAMIC-FUNCTION("statusText":U IN ghContainerSource,"Create new Smart Data Field.").
    END.
    WHEN "Find":U THEN DO:
      DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, "cbCancel,cbCopy,cbDelete,cbSave,cbSaveAs,cbFind,cbUndo":U).
      DYNAMIC-FUNCTION("enableActions":U IN ghToolbar, "New":U).
      ASSIGN buSynch:HIDDEN    = TRUE
             buSynch:SENSITIVE = FALSE.
      DISABLE buWhereUsed buSynchInstances fiFieldName raSource WITH FRAME {&FRAME-NAME}.
      RUN disableField IN hProductModule.
      RUN disableField IN hCustomSuperProcedure.
      ASSIGN raSource:SCREEN-VALUE = "DB":U.
      RUN assignNewValue IN hDataObject (INPUT "":U, INPUT "":U, INPUT FALSE).
      RUN disableField IN hDataObject.
      RUN enableField IN hObjectFilename.
      DISABLE buWhereUsed buSynchInstances coObjType fiObjectDescription toUseCache WITH FRAME {&FRAME-NAME}.
      PUBLISH "disableObject" FROM ghContainerSource.
      DYNAMIC-FUNCTION("statusText":U IN ghContainerSource,"Find an existing Smart Data Field.").
    END.
    WHEN "Modify":U THEN DO:
      IF NOT glStaticSDF THEN DO:
        DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, "cbCancel,cbSave,cbUndo":U).
        IF NOT glUpdateMasterOnly THEN
          DYNAMIC-FUNCTION("enableActions":U IN ghToolbar, "New,cbCopy,cbFind,cbDelete,cbSaveAs":U).
        ELSE
          DYNAMIC-FUNCTION("enableActions":U IN ghToolbar, "New,cbCopy,cbFind,cbDelete":U).
        RUN disableField IN hObjectFilename.
        RUN disableField IN hProductModule.
        RUN enableField IN hCustomSuperProcedure.
        ENABLE fiObjectDescription buWhereUsed buSynchInstances WITH FRAME {&FRAME-NAME}.
      END.
      ELSE
        DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, "cbSave,cbUndo":U).
      IF glUpdateMasterOnly THEN
        DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, "New,cbCopy,cbFind,cbDelete":U).
      ENABLE toUSeCache WITH FRAME {&FRAME-NAME}.
      IF LOOKUP(coObjType:SCREEN-VALUE, gcComboClasses) > 0 THEN
      DO:
        ENABLE raSource WITH FRAME {&FRAME-NAME}.
        ghDataTable = DYNAMIC-FUNCTION("getComboTable":U IN ghContainerSource).
        ghDataTable = ghDataTable:DEFAULT-BUFFER-HANDLE.
        ghDataTable:FIND-FIRST().
        IF ghDataTable:AVAILABLE THEN
        DO:
          cDataSourceName = ghDataTable:BUFFER-FIELD("cDataSourceName":U):BUFFER-VALUE.
          IF cDataSourceName NE "":U THEN
          DO:
            setDataObjectName(INPUT cDataSourceName).
            RUN enableField IN hDataObject.
          END.
        END.
      END.
    END.
    WHEN "Cancel":U THEN DO:
      IF glUsedExisting THEN DO:
        clearDetails(TRUE).
        RUN setFields ("New":U).
        RUN checkForStaticSDF.
        glUsedExisting = FALSE.
        RETURN.
      END.
      IF glIsDynView THEN DO:
        RUN disableButton IN hObjectFilename.
        RETURN.
      END.

      RUN disableField IN hProductModule.
      DISABLE buWhereUsed buSynchInstances coObjType fiObjectDescription toUseCache
              WITH FRAME {&FRAME-NAME}.

      ASSIGN raSource:SCREEN-VALUE = "DB":U.
      RUN assignNewValue IN hDataObject (INPUT "":U, INPUT "":U, INPUT FALSE).
      IF NOT glStaticSDF THEN DO:
        DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, "cbCancel,cbSave":U).
        IF NOT glUpdateMasterOnly THEN
          DYNAMIC-FUNCTION("enableActions":U IN ghToolbar, "New,cbCopy,cbFind,cbDelete,cbSaveAs":U).
        ELSE
          DYNAMIC-FUNCTION("enableActions":U IN ghToolbar, "New,cbCopy,cbFind,cbDelete":U).
        RUN enableField IN hObjectFilename.
        RUN disableField IN hCustomSuperProcedure.
        clearDetails(TRUE).
        RUN setFields ("FIND":U).
        glNeedToSave = FALSE.
      END.
      ELSE DO:
        RUN disableField IN hObjectFilename.
        RUN disableButton IN hObjectFilename.
        DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, "cbCancel":U).
        hLookup:SCREEN-VALUE = "":U.
        ASSIGN toSave:CHECKED IN FRAME {&FRAME-NAME} = FALSE
               fiObjectDescription:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U.
        APPLY "VALUE-CHANGED":U TO toSave IN FRAME {&FRAME-NAME}.
        ENABLE toSave WITH FRAME {&FRAME-NAME}.
        IF NOT glNeedToSave THEN
          DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, "cbSave":U).
      END.
    END.
    WHEN "Save":U THEN DO:
      glNeedToSave = FALSE.
      IF NOT glStaticSDF THEN DO:
        DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, "cbCancel,cbSave,cbUndo":U).
        IF NOT glUpdateMasterOnly THEN
          DYNAMIC-FUNCTION("enableActions":U IN ghToolbar, "New,cbCopy,cbFind,cbDelete,cbSaveAs":U).
        ELSE
          DYNAMIC-FUNCTION("enableActions":U IN ghToolbar, "New,cbCopy,cbFind,cbDelete":U).
        RUN disableField IN hObjectFilename.
        RUN disableField IN hProductModule.
        RUN enableField IN hCustomSuperProcedure.
        ENABLE fiObjectDescription toUseCache buWhereUsed buSynchInstances WITH FRAME {&FRAME-NAME}.
      END.
      ELSE DO:
        RUN disableButton IN hObjectFileName.
        IF glIsDynView OR glStaticSDF THEN
          RUN disableField IN hObjectFileName.
        IF NOT glUsedExisting THEN
        DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, "cbSave,cbUndo,cbCancel":U).
        IF glUsedExisting THEN DO:
          DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, "cbSave":U).
          DISABLE toSave WITH FRAME {&FRAME-NAME}.
        END.
      END.
      IF glUpdateMasterOnly THEN
        DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, "New,cbCopy,cbFind,cbDelete":U).
    END.
    WHEN "Change":U THEN DO:
      glNeedToSave = TRUE.
      IF NOT glStaticSDF AND glNew THEN
        RUN disableButton IN hObjectFileName.
      DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, "New,cbCopy,cbFind,cbDelete":U).
      DYNAMIC-FUNCTION("enableActions":U IN ghToolbar, "cbSave,cbUndo":U).
    END.
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSDFMaster vTableWin 
PROCEDURE setSDFMaster :
/*------------------------------------------------------------------------------
  Purpose:    Upon saving a master object, all of the instance properties are
              set to equal the master properties. Otherwise, if a dynamic viewer 
              is opened and then the master SDF is changed, the code will 
              incorrectly write out the previous value of the master object.
  Parameters: phDataTable    Table containing property values
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER phDataTable AS HANDLE     NO-UNDO.
  
 DEFINE VARIABLE hFrame              AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cFieldLabel         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE dSuperProcObjectObj AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE hSMO                AS HANDLE      NO-UNDO.

 IF NOT VALID-HANDLE(phDataTable) THEN
   RETURN "Invalid handle to Data Table".

 ASSIGN hSMO = getSDFProc().
 
 IF NOT VALID-HANDLE(hSMO) THEN RETURN.
 phDataTable:FIND-FIRST().
  
 /* Add pathed name for super proc */
 IF phDataTable:BUFFER-FIELD("cCustomSuperProc":U):BUFFER-VALUE <> "":U THEN 
 DO:
   ASSIGN dSuperProcObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN gshRepositoryManager,
                                                 INPUT phDataTable:BUFFER-FIELD("cCustomSuperProc":U):BUFFER-VALUE, INPUT 0).
   IF dSuperProcObjectObj EQ 0 THEN
     phDataTable:BUFFER-FIELD("cCustomSuperProc":U):BUFFER-VALUE = "":U.
   ELSE
     /* Store the relatively pathed object name */
     ASSIGN phDataTable:BUFFER-FIELD("cCustomSuperProc":U):BUFFER-VALUE = DYNAMIC-FUNCTION("getObjectPathedName":U IN gshRepositoryManager,
                                                                        INPUT dSuperProcObjectObj).
 END.

/* Common properties fro dyncombos and dynlookups */ 
 DYNAMIC-FUNCTION('setDisplayedField':U              IN hSMO, phDataTable:BUFFER-FIELD("cDisplayedField":U):BUFFER-VALUE). 
 DYNAMIC-FUNCTION('setKeyField':U                    IN hSMO, phDataTable:BUFFER-FIELD("cKeyField":U):BUFFER-VALUE). 
 DYNAMIC-FUNCTION('setFieldLabel':U                  IN hSMO, phDataTable:BUFFER-FIELD("cFieldLabel":U):BUFFER-VALUE). 
 DYNAMIC-FUNCTION('setFieldTooltip':U                IN hSMO, phDataTable:BUFFER-FIELD("cFieldTooltip":U):BUFFER-VALUE). 
 DYNAMIC-FUNCTION('setSDFFileName':U                 IN hSMO, phDataTable:BUFFER-FIELD("cSDFFileName":U):BUFFER-VALUE).
 DYNAMIC-FUNCTION('setSDFTemplate':U                 IN hSMO, phDataTable:BUFFER-FIELD("cSDFTemplate":U):BUFFER-VALUE).
 DYNAMIC-FUNCTION('setParentField':U                 IN hSMO, phDataTable:BUFFER-FIELD("cParentField":U):BUFFER-VALUE).
 DYNAMIC-FUNCTION('setParentFilterQuery':U           IN hSMO, phDataTable:BUFFER-FIELD("cParentFilterQuery":U):BUFFER-VALUE).
 DYNAMIC-FUNCTION('setSuperProcedure':U              IN hSMO, phDataTable:BUFFER-FIELD("cCustomSuperProc":U):BUFFER-VALUE).
 DYNAMIC-FUNCTION('setPhysicalTableNames':U          IN hSMO, phDataTable:BUFFER-FIELD("cPhysicalTableNames":U):BUFFER-VALUE).
 DYNAMIC-FUNCTION('setTempTables':U                  IN hSMO, phDataTable:BUFFER-FIELD("cTempTables":U):BUFFER-VALUE).
 DYNAMIC-FUNCTION('setQueryBuilderJoinCode':U        IN hSMO, phDataTable:BUFFER-FIELD('cQueryBuilderJoinCode':U):BUFFER-VALUE).
 DYNAMIC-FUNCTION('setQueryBuilderOptionList':U      IN hSMO, phDataTable:BUFFER-FIELD('cQueryBuilderOptionList':U):BUFFER-VALUE). 
 DYNAMIC-FUNCTION('setQueryBuilderTableOptionList':U IN hSMO, phDataTable:BUFFER-FIELD('cQueryBuilderTableOptionList':U):BUFFER-VALUE).
 DYNAMIC-FUNCTION('setQueryBuilderOrderList':U       IN hSMO, phDataTable:BUFFER-FIELD('cQueryBuilderOrderList':U):BUFFER-VALUE).
 DYNAMIC-FUNCTION('setQueryBuilderTuneOptions':U     IN hSMO, phDataTable:BUFFER-FIELD('cQueryBuilderTuneOptions':U):BUFFER-VALUE).
 DYNAMIC-FUNCTION('setQueryBuilderWhereClauses':U    IN hSMO, phDataTable:BUFFER-FIELD('cQueryBuilderWhereClauses':U):BUFFER-VALUE).
 DYNAMIC-FUNCTION('setEnableField':U                 IN hSMO, phDataTable:BUFFER-FIELD('lEnableField':U):BUFFER-VALUE).
 DYNAMIC-FUNCTION('setDisplayField':U                IN hSMO, phDataTable:BUFFER-FIELD('lDisplayField':U):BUFFER-VALUE).
 DYNAMIC-FUNCTION('setUseCache':U                    IN hSMO, phDataTable:BUFFER-FIELD('lUseCache':U):BUFFER-VALUE).
 IF phDataTable:BUFFER-FIELD('lLocalField':U):BUFFER-VALUE THEN
   DYNAMIC-FUNCTION('setFieldName':U IN hSMO, phDataTable:BUFFER-FIELD('cActualField':U):BUFFER-VALUE).
 
 IF phDataTable:BUFFER-FIELD("cDataSourceName":U):BUFFER-VALUE = "":U THEN
 DO:
   DYNAMIC-FUNCTION('setKeyFormat':U                   IN hSMO, phDataTable:BUFFER-FIELD("cKeyFormat":U):BUFFER-VALUE).
   DYNAMIC-FUNCTION('setKeyDataType':U                 IN hSMO, phDataTable:BUFFER-FIELD("cKeyDataType":U):BUFFER-VALUE).
   DYNAMIC-FUNCTION('setDisplayFormat':U               IN hSMO, phDataTable:BUFFER-FIELD("cDisplayFormat":U):BUFFER-VALUE).
   DYNAMIC-FUNCTION('setDisplayDataType':U             IN hSMO, phDataTable:BUFFER-FIELD("cDisplayDataType":U):BUFFER-VALUE).
   DYNAMIC-FUNCTION('setBaseQueryString':U             IN hSMO, phDataTable:BUFFER-FIELD("cBaseQueryString":U):BUFFER-VALUE).
   DYNAMIC-FUNCTION('setQueryTables':U                 IN hSMO, phDataTable:BUFFER-FIELD("cQueryTables":U):BUFFER-VALUE).
 END.

IF LOOKUP(coObjType:SCREEN-VALUE IN FRAME {&FRAME-NAME}, gcLookupClasses) > 0 THEN 
DO:
  /* Lookup only */
  DYNAMIC-FUNCTION('setBrowseFields':U                IN hSMO, phDataTable:BUFFER-FIELD("cBrowseFields":U):BUFFER-VALUE). 
  DYNAMIC-FUNCTION('setBrowseFieldDataTypes':U        IN hSMO, phDataTable:BUFFER-FIELD("cBrowseFieldDataTypes":U):BUFFER-VALUE). 
  DYNAMIC-FUNCTION('setBrowseFieldFormats':U          IN hSMO, phDataTable:BUFFER-FIELD("cBrowseFieldFormats":U):BUFFER-VALUE). 
  DYNAMIC-FUNCTION('setViewerLinkedFields':U          IN hSMO, phDataTable:BUFFER-FIELD("cViewerLinkedFields":U):BUFFER-VALUE). 
  DYNAMIC-FUNCTION('setViewerLinkedWidgets':U         IN hSMO, phDataTable:BUFFER-FIELD("cViewerLinkedWidgets":U):BUFFER-VALUE). 
  DYNAMIC-FUNCTION('setLinkedFieldDataTypes':U        IN hSMO, phDataTable:BUFFER-FIELD("cLinkedFieldDataTypes":U):BUFFER-VALUE).
  DYNAMIC-FUNCTION('setLinkedFieldFormats':U          IN hSMO, phDataTable:BUFFER-FIELD("cLinkedFieldFormats":U):BUFFER-VALUE).
  DYNAMIC-FUNCTION('setColumnLabels':U                IN hSMO, phDataTable:BUFFER-FIELD("cColumnLabels":U):BUFFER-VALUE). 
  DYNAMIC-FUNCTION('setColumnFormat':U                IN hSMO, phDataTable:BUFFER-FIELD("cColumnFormat":U):BUFFER-VALUE). 
  DYNAMIC-FUNCTION('setBrowseTitle':U                 IN hSMO, phDataTable:BUFFER-FIELD('cBrowseTitle':U):BUFFER-VALUE).
  DYNAMIC-FUNCTION('setRowsToBatch':U                 IN hSMO, phDataTable:BUFFER-FIELD('iRowsToBatch':U):BUFFER-VALUE).
  DYNAMIC-FUNCTION('setMaintenanceObject':U           IN hSMO, phDataTable:BUFFER-FIELD('cMaintenanceObject':U):BUFFER-VALUE).
  DYNAMIC-FUNCTION('setMaintenanceSDO':U              IN hSMO, phDataTable:BUFFER-FIELD('cMaintenanceSDO':U):BUFFER-VALUE).
  DYNAMIC-FUNCTION('setLookupImage':U                 IN hSMO, phDataTable:BUFFER-FIELD('cLookupImage':U):BUFFER-VALUE).
  DYNAMIC-FUNCTION('setPopupOnAmbiguous':U            IN hSMO, phDataTable:BUFFER-FIELD('lPopupOnAmbiguous':U):BUFFER-VALUE).
  DYNAMIC-FUNCTION('setPopupOnUniqueAmbiguous':U      IN hSMO, phDataTable:BUFFER-FIELD('lPopupOnUniqueAmbiguous':U):BUFFER-VALUE).
  DYNAMIC-FUNCTION('setPopupOnNotAvail':U             IN hSMO, phDataTable:BUFFER-FIELD('lPopupOnNotAvail':U):BUFFER-VALUE).
  DYNAMIC-FUNCTION('setBlankOnNotAvail':U             IN hSMO, phDataTable:BUFFER-FIELD('lBlankOnNotAvail':U):BUFFER-VALUE).
  DYNAMIC-FUNCTION('setMappedFields':U                IN hSMO, phDataTable:BUFFER-FIELD('cMappedFields':U):BUFFER-VALUE).
END.
ELSE IF LOOKUP(coObjType:SCREEN-VALUE, gcComboClasses) > 0 THEN
DO:
 /*COMBO ONLY */
  DYNAMIC-FUNCTION('setComboFlag':U                   IN hSMO, phDataTable:BUFFER-FIELD("cComboFlag":U):BUFFER-VALUE).
  DYNAMIC-FUNCTION('setDescSubstitute':U              IN hSMO, phDataTable:BUFFER-FIELD("cDescSubstitute":U):BUFFER-VALUE).
  DYNAMIC-FUNCTION('setFlagValue':U                   IN hSMO, phDataTable:BUFFER-FIELD("cFlagValue":U):BUFFER-VALUE).
  DYNAMIC-FUNCTION('setBuildSequence':U               IN hSMO, phDataTable:BUFFER-FIELD("iBuildSequence":U):BUFFER-VALUE).
  DYNAMIC-FUNCTION('setInnerLines':U                  IN hSMO, phDataTable:BUFFER-FIELD("iInnerLines":U):BUFFER-VALUE).
  DYNAMIC-FUNCTION('setSort':U                        IN hSMO, phDataTable:BUFFER-FIELD('lSort':U):BUFFER-VALUE).
  DYNAMIC-FUNCTION('setDataSourceName':U              IN hSMO, phDataTable:BUFFER-FIELD('cDataSourceName':U):BUFFER-VALUE).
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE synchInstances vTableWin 
PROCEDURE synchInstances :
/*------------------------------------------------------------------------------
  Purpose:     Synchronizes instances of this master object by removing
               instance attribute overrides for data-related attribute
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cAnswer     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cButton     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQuestion   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSDFName    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cWhereUsed  AS CHARACTER  NO-UNDO.
    
  cQuestion = 'Synchronizing instances with this master SmartDataField ':U +
              'will remove data-related attribute overrides for every instance of this object. ':U +
              'Examples of data-related attributes are: base query string, displayed field, key field, ':U +
              'description substitute and display format.':U + CHR(13) + CHR(13) +
              'Do you wish to continue?':U.
              
  RUN askQuestion IN gshSessionManager ( INPUT cQuestion,
                                         INPUT "&Yes,&No":U,     /* button list */
                                         INPUT "&No":U,         /* default */
                                         INPUT "&No":U,          /* cancel */
                                         INPUT "Continue synchronization":U, /* title */
                                         INPUT "":U,             /* datatype */
                                         INPUT "":U,             /* format */
                                         INPUT-OUTPUT cAnswer,   /* answer */
                                         OUTPUT cButton          /* button pressed */ ).

  IF cButton = "&Yes":U OR cButton = "Yes":U THEN
  DO:
    {get DataValue cSDFName hObjectFileName}.

    {launch.i &PLIP  = 'ry/app/rysdfsynchp.p' 
              &IPROC = 'synchInstances' 
              &ONAPP = 'YES'
              &PLIST = "(INPUT cSDFName)"
              &AUTOKILL = YES}
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateData vTableWin 
PROCEDURE validateData :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will validate the data on the screen to ensure
               that the data enetered is valid.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjectFileName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProductModule    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessageList      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hFileNameLookup   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRunAttribute     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRepDesignManager AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSuperProc        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDesignManager    AS HANDLE     NO-UNDO.

  SESSION:SET-WAIT-STATE("GENERAL":U).
  DO WITH FRAME {&FRAME-NAME}:
    IF fiObjectDescription:SCREEN-VALUE = "?":U OR
       fiObjectDescription:SCREEN-VALUE = ? THEN
      fiObjectDescription:SCREEN-VALUE = "":U.
    ASSIGN fiObjectDescription
           coObjType
           toSave.
    {get DataValue cSuperProc hCustomSuperProcedure}.
  END.
  
  {get RunAttribute cRunAttribute ghContainerSource}.
  
  IF NUM-ENTRIES(cRunAttribute,CHR(3)) >= 2 AND
     ENTRY(2,cRunAttribute,CHR(3)) = "NEW":U THEN 
    glNew = TRUE.

  IF NOT glStaticSDF OR
     (glStaticSDF AND toSave AND glNew) OR 
     glIsDynView THEN DO:
    {get LookupHandle hFileNameLookup hObjectFileName}.
    {get DataValue cProductModule hProductModule}.
    
    cObjectFileName = hFileNameLookup:SCREEN-VALUE.
  
    IF cObjectFileName = "":U THEN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' '' '' '"Object Filename"'}.

    /* Check whether object name already exists */
    ASSIGN hRepDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
    IF DYNAMIC-FUNCTION("ObjectExists":U IN hRepDesignManager, INPUT cObjectFileName ) 
        AND glNew AND NOT glUsedExisting THEN DO:
      glValidationError = TRUE.
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '31' '' '' '"SmartDataField"' '"this name"'}.
      IF cMessageList <> "":U THEN DO:
        RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                               INPUT "ERR":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "Validation Error",
                                               INPUT YES,
                                               INPUT ?,
                                               OUTPUT cButton).
        RETURN ERROR "VALIDATION-FAILED":U.
      END.
    END.
        
    IF cProductModule = "":U THEN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' '' '' '"Product Module"'}.

  END.

  /* Check for valid super procedure */
  ASSIGN hRepDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
  IF cSuperProc <> "":U AND 
     DYNAMIC-FUNCTION("ObjectExists":U IN hRepDesignManager,INPUT cSuperProc) = FALSE THEN DO:
    cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                  {af/sup2/aferrortxt.i 'AF' '5' '' '' '"super procedure"'}.
    IF cMessageList <> "":U THEN DO:
      RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Validation Error",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
      RETURN ERROR "VALIDATION-FAILED":U.
    END.
  END.
  
  IF LOOKUP(coObjType:SCREEN-VALUE, gcLookupClasses) > 0 THEN
      RUN validateData IN ghDynLookup (OUTPUT cMessage).
  ELSE
      IF LOOKUP(coObjType:SCREEN-VALUE, gcComboClasses) > 0 THEN
          RUN validateData IN ghDynCombo (OUTPUT cMessage).
  
  cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + cMessage. 
  SESSION:SET-WAIT-STATE("":U).
  IF cMessageList <> "":U THEN DO:
    RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Validation Error",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).
    RETURN ERROR "VALIDATION-FAILED":U.
  END.

  /* Check if the name specified to save to exists in the Repository */
  IF glNew AND NOT glStaticSDF AND cObjectFileName <> "":U THEN DO:
    RUN getObjectNames IN gshRepositoryManager ( INPUT  cObjectFileName,
                                                 INPUT  "",
                                                 OUTPUT cObjectFileName,
                                                 OUTPUT cObjectFileName).
    IF cObjectFileName <> "":U THEN DO:
      cMessage = "Object Name '" + cObjectFileName + "'".
      cMessageList = {af/sup2/aferrortxt.i 'AF' '31' '' '' '"SmartDataField"' "cMessage"}.
      RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Validation Error",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
      RETURN ERROR "VALIDATION-FAILED":U.
    END.
    ELSE RETURN.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueChanged vTableWin 
PROCEDURE valueChanged :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hLookup AS HANDLE     NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.
  
  /* Code placed here will execute AFTER standard behavior.    */

  /* We only want to trigger the change event when we change
     the super procedure lookup's value */
  
  {get LookupHandle hLookup hCustomSuperProcedure}.

  IF VALID-HANDLE(FOCUS) AND
     FOCUS = hLookup THEN
    RUN changesMade.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE whereUsed vTableWin 
PROCEDURE whereUsed :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will run a proc on the AppServer to determine if
               the current SDF is used anywhere.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSDFName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhereUsed  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton     AS CHARACTER  NO-UNDO.

  {get DataValue cSDFName hObjectFileName}.
  
  {launch.i &PLIP  = 'ry/app/rysdfusedp.p' 
              &IPROC = 'whereSDFUsed' 
              &ONAPP = 'YES'
              &PLIST = "(INPUT cSDFName, OUTPUT cWhereUsed)"
              &AUTOKILL = YES}
              
  IF cWhereUsed <> "":U THEN
    RUN showMessages IN gshSessionManager (INPUT cWhereUsed,
                                           INPUT "MES":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Where Used",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).
  ELSE 
    RUN showMessages IN gshSessionManager (INPUT "This SmartDataField is currently not used anywhere in the application.",
                                           INPUT "INF":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Where Used",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION clearDetails vTableWin 
FUNCTION clearDetails RETURNS LOGICAL
  ( plClearAll AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF VALID-HANDLE(ghContainerSource) THEN
    PUBLISH "clearAll":U FROM ghContainerSource.
  
  IF plClearAll THEN DO:
    /* Clear old data out of frame */
    DO WITH FRAME {&FRAME-NAME}:
      ASSIGN fiObjectDescription:SCREEN-VALUE = "":U
             fiFieldName:SCREEN-VALUE = "":U
             toUseCache:CHECKED      = TRUE.
    END.
    RUN assignNewValue IN hObjectFilename (INPUT "":U, INPUT "":U, INPUT FALSE).
    RUN assignNewValue IN hCustomSuperProcedure (INPUT "":U, INPUT "":U, INPUT FALSE).
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataViewSource vTableWin 
FUNCTION getDataViewSource RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: get the Viewer's DataView object 
    Notes: DataSourcename Lookup and combo viewer needs this (early)   
           (There is a mechanism in checkForstaticSDF that actively publishes 
            the datasource, but that is too late for this)
         - This ONLY returns a handle if it is actuially DataView source.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSourceHandle AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lDBAware          AS LOGICAL    NO-UNDO.

  IF VALID-HANDLE(ghSDFObject) THEN
    RUN returnDataSourceHandle IN ghSDFObject (OUTPUT hDataSourceHandle) NO-ERROR.
  
  IF VALID-HANDLE(hDataSourceHandle) THEN
  DO:
    /* if the DataSource is not DBAware then it is a DataView */
    {get DBAware lDBAware hDataSourceHandle}.
    IF NOT lDBAware THEN
      RETURN hDataSourceHandle.
  END.
  RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSDFProc vTableWin 
FUNCTION getSDFProc RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE hSource AS HANDLE   NO-UNDO.
DEFINE VARIABLE hProc   AS HANDLE   NO-UNDO.

{get ContainerSource hSource}.
hProc = DYNAMIC-FUNCTION("getSDFProcHandle" IN hSource).

RETURN hProc.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataObjectName vTableWin 
FUNCTION setDataObjectName RETURNS LOGICAL
  ( INPUT pcName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets data object name lookup screen value and sets radio set 
            SCREEN-VALUE
    Notes:  assignNewValue is not used because that invoked lookupComplete which
            is not always desired
------------------------------------------------------------------------------*/
DEFINE VARIABLE hLookup AS HANDLE     NO-UNDO.

  {get LookupHandle hLookup hDataObject}.
  ASSIGN hLookup:SCREEN-VALUE = pcName.

  raSource:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF pcName = "":U THEN "DB":U
                                                 ELSE "SDO":U.
  IF pcName = "":U THEN 
  do:
    RUN disableField IN hDataObject.
    run clearField in hDataObject.
  end.    /* not SDO-based */

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolbarHandle vTableWin 
FUNCTION setToolbarHandle RETURNS LOGICAL
  ( INPUT phToolbarHandle AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  ASSIGN ghToolbar = phToolbarHandle.
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

