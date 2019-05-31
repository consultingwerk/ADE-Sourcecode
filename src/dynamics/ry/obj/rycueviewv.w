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
       {"ry/obj/rycuefullo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rycueviewv.w

  Description:  UI Event Viewer

  Purpose:      UI Event Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:   101000029   UserRef:    
                Date:   09/12/2001  Author:     Peter Judge

  Update Notes: Created from Template rysttviewv.w

  (v:010001)    Task:           0   UserRef:    
                Date:   06/20/2002  Author:     Mark Davies (MIP)

  Update Notes: Added support for ObjectType UI Events

--------------------------------------------------------------------------------*/
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

&scop object-name       rycueviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/rycuefullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.smartobject_obj ~
RowObject.container_smartobject_obj RowObject.object_type_obj ~
RowObject.object_instance_obj RowObject.event_name RowObject.action_type ~
RowObject.action_target RowObject.event_action RowObject.event_parameter ~
RowObject.event_disabled 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS fiClassList 
&Scoped-Define DISPLAYED-FIELDS RowObject.smartobject_obj ~
RowObject.container_smartobject_obj RowObject.object_type_obj ~
RowObject.object_instance_obj RowObject.event_name RowObject.action_type ~
RowObject.action_target RowObject.event_action RowObject.event_parameter ~
RowObject.event_disabled RowObject.constant_value 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject


/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hEvent AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiClassList AS CHARACTER FORMAT "X(3000)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.smartobject_obj AT ROW 1 COL 86.6 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 1.2 BY 1
     RowObject.container_smartobject_obj AT ROW 1 COL 87.4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 1.2 BY 1
     RowObject.object_type_obj AT ROW 1 COL 88.2 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 1.2 BY 1
     RowObject.object_instance_obj AT ROW 1 COL 89.4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 1.2 BY 1
     RowObject.event_name AT ROW 1.24 COL 18.6 COLON-ALIGNED
          LABEL "Event name"
          VIEW-AS FILL-IN 
          SIZE 37 BY 1
     RowObject.action_type AT ROW 2.33 COL 18.6 COLON-ALIGNED
          LABEL "Action type" FORMAT "X(15)"
          VIEW-AS FILL-IN 
          SIZE 30 BY 1
     RowObject.action_target AT ROW 3.43 COL 18.6 COLON-ALIGNED
          LABEL "Action target"
          VIEW-AS FILL-IN 
          SIZE 30 BY 1
     RowObject.event_action AT ROW 4.52 COL 18.6 COLON-ALIGNED
          LABEL "Event action"
          VIEW-AS FILL-IN 
          SIZE 37 BY 1
     RowObject.event_parameter AT ROW 5.62 COL 18.6 COLON-ALIGNED
          LABEL "Event parameter"
          VIEW-AS FILL-IN 
          SIZE 72 BY 1
     RowObject.event_disabled AT ROW 6.67 COL 20.6
          LABEL "Event disabled"
          VIEW-AS TOGGLE-BOX
          SIZE 19.4 BY .81
     fiClassList AT ROW 6.71 COL 82.6 COLON-ALIGNED NO-LABEL
     RowObject.constant_value AT ROW 7.43 COL 20.6
          LABEL "Constant value"
          VIEW-AS TOGGLE-BOX
          SIZE 19.4 BY .81
     SPACE(30.60) SKIP(0.00)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/rycuefullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/rycuefullo.i}
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
         HEIGHT             = 8.1
         WIDTH              = 91.6.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.action_target IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.action_type IN FRAME frMain
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR TOGGLE-BOX RowObject.constant_value IN FRAME frMain
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN RowObject.container_smartobject_obj IN FRAME frMain
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.container_smartobject_obj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.container_smartobject_obj:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

/* SETTINGS FOR FILL-IN RowObject.event_action IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.event_disabled IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.event_name IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.event_parameter IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN fiClassList IN FRAME frMain
   NO-DISPLAY                                                           */
ASSIGN 
       fiClassList:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.object_instance_obj IN FRAME frMain
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.object_instance_obj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.object_instance_obj:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

/* SETTINGS FOR FILL-IN RowObject.object_type_obj IN FRAME frMain
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.object_type_obj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.object_type_obj:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

/* SETTINGS FOR FILL-IN RowObject.smartobject_obj IN FRAME frMain
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.smartobject_obj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.smartobject_obj:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord vTableWin 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hContainer          AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hDataSource         AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hParentData         AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE cDataSource         AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cMode               AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cColValues          AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cLevel              AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cColumns            AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cColumnValue        AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE iLoop               AS INTEGER                      NO-UNDO.
    
    RUN SUPER.
    
    DO WITH FRAME {&FRAME-NAME}:
        {get DataSource cDataSource}.
        DO iLoop = 1 TO NUM-ENTRIES(cDataSource):
            ASSIGN hDataSource = WIDGET-HANDLE(ENTRY(iLoop, cDataSource)).
            IF VALID-HANDLE(hDataSource) THEN
            DO:
                /* Determine where we are */
                ASSIGN cLevel = DYNAMIC-FUNCTION("getSDOLevel":U IN hDataSource).

                {get DataSource hParentData hDataSource}.

                IF VALID-HANDLE(hParentData) THEN
                DO:
                    CASE cLevel:
                      WHEN "ObjectType":U THEN
                        ASSIGN cColumns = "object_type_obj":U.
                      WHEN "SmartObject":U THEN
                        ASSIGN cColumns = "object_type_obj,smartobject_obj":U.
                      WHEN "ObjectInstance":U THEN
                        ASSIGN cColumns = "container_smartobject_obj,smartobject_obj,object_type_obj,object_instance_obj":U.
                    END CASE.

                    ASSIGN cColValues = DYNAMIC-FUNCTION ("colValues" IN hParentData, INPUT cColumns).

                    CASE cLevel:
                      WHEN "ObjectType":U THEN
                      DO:                        
                          ASSIGN cColumnValue                           = ENTRY(2, cColValues, CHR(1))
                                 rowObject.object_type_obj:SCREEN-VALUE = cColumnValue
                                 .                      
                      END.    /* ObjectType */
                      WHEN "SmartObject":U THEN
                      DO:                        
                          ASSIGN cColumnValue                           = ENTRY(2, cColValues, CHR(1))
                                 rowObject.object_type_obj:SCREEN-VALUE = cColumnValue
                                 .                      
                          ASSIGN cColumnValue                           = ENTRY(3, cColValues, CHR(1))
                                 rowObject.smartObject_obj:SCREEN-VALUE = cColumnValue
                                 .
                          ASSIGN rowObject.container_smartObject_obj:SCREEN-VALUE = STRING(0)
                                 rowObject.object_instance_obj:SCREEN-VALUE       = STRING(0)
                                 .
                      END.    /* SmartObject */
                      WHEN "ObjectInstance":U THEN
                      DO:
                          ASSIGN cColumnValue                                     = ENTRY(2, cColValues, CHR(1))
                                 rowObject.container_smartObject_obj:SCREEN-VALUE = cColumnValue
                                 .
                          ASSIGN cColumnValue                           = ENTRY(3, cColValues, CHR(1))
                                 rowObject.smartObject_obj:SCREEN-VALUE = cColumnValue
                                 .
                          ASSIGN cColumnValue                           = ENTRY(4, cColValues, CHR(1))
                                 rowObject.object_type_obj:SCREEN-VALUE = cColumnValue
                                 .
                          ASSIGN cColumnValue = ENTRY(5, cColValues, CHR(1))
                                 rowObject.object_instance_obj:SCREEN-VALUE = cColumnValue
                                 .
                      END.    /* ObjectInstance */
                    END CASE.
                END.    /* valid parent */
            END.    /* valid data source */
        END.    /* loop through data sources */
    END.    /* ADD mode */    

    RUN assignNewValue IN hEvent ("":U,"":U,TRUE).

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_ui_event.event_nameKeyFieldryc_ui_event.event_nameFieldLabelEvent nameFieldTooltipPress F4 For LookupKeyFormatX(35)KeyDatatypecharacterDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_ui_event WHERE ryc_ui_event.smartobject_obj = 0 NO-LOCK,
                     FIRST gsc_object_type WHERE gsc_object_type.object_type_obj = ryc_ui_event.object_type_obj BY gsc_object_type.object_type_code BY ryc_ui_event.event_nameQueryTablesryc_ui_event,gsc_object_typeBrowseFieldsryc_ui_event.event_name,gsc_object_type.object_type_code,ryc_ui_event.action_type,ryc_ui_event.action_target,ryc_ui_event.event_action,ryc_ui_event.event_disabledBrowseFieldDataTypescharacter,character,character,character,character,logicalBrowseFieldFormatsX(35)|X(35)|X(3)|X(28)|X(35)|YES/NORowsToBatch200BrowseTitleLookup EventsViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldfiClassList,fiClassListParentFilterQueryIF ~'&1~' <> ~'~' THEN (LOOKUP(gsc_object_type.object_type_code,~'&1~') > 0) ELSE TRUEMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldName<Local>DisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hEvent ).
       RUN repositionObject IN hEvent ( 1.19 , 20.60 ) NO-ERROR.
       RUN resizeObject IN hEvent ( 1.00 , 50.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( hEvent ,
             RowObject.object_instance_obj:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignClassHierarchy vTableWin 
PROCEDURE assignClassHierarchy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDataSource     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dObjectTypeObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cColValues      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hParentData     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDesignManager  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectType     AS CHARACTER  NO-UNDO.
  
  ASSIGN hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
  
  IF NOT VALID-HANDLE(hDesignManager) THEN
    RETURN.
  
  {get DataSource cDataSource}.
  DO iLoop = 1 TO NUM-ENTRIES(cDataSource):
    ASSIGN hDataSource = WIDGET-HANDLE(ENTRY(iLoop, cDataSource)).
    IF VALID-HANDLE(hDataSource) THEN DO:
      {get DataSource hParentData hDataSource}.
      IF VALID-HANDLE(hParentData) THEN DO:
        ASSIGN cColValues = DYNAMIC-FUNCTION ("colValues" IN hParentData, INPUT "object_type_obj":U).
        ASSIGN dObjectTypeObj = DECIMAL(ENTRY(2, cColValues, CHR(1))).
      END.    /* valid parent */
    END.    /* valid data source */
  END.    /* loop through data sources */
  
  IF dObjectTypeObj = 0 OR
     dObjectTypeObj = ? THEN
    dObjectTypeObj = DECIMAL(RowObject.OBJECT_type_obj:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
  cObjectType = DYNAMIC-FUNCTION("getObjectTypeCodeFromDB":U IN hDesignManager, INPUT dObjectTypeObj).
  
  IF cObjectType <> "":U AND
     cObjectType <> "?":U AND
     cObjectType <> ? THEN 
    cObjectType = DYNAMIC-FUNCTION("getClassParentsFromDB":U IN gshRepositoryManager, cObjectType).

  IF RowObject.event_name:HIDDEN IN FRAME {&FRAME-NAME} = FALSE THEN
    cObjectType = "":U.
  
  ASSIGN fiClassList:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cObjectType.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRecord vTableWin 
PROCEDURE deleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hPropertysheet AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hProcedure     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSource        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cClass         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProp          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLevel         AS CHARACTER  NO-UNDO.

  /* Get the DataSource of the parent node */
  {get DataSource hSource}.
  ASSIGN cLevel = DYNAMIC-FUNCTION("getSDOLevel":U IN hSource).
  {get DataSource hSource hSource}.
  ASSIGN cClass =  trim(DYNAMIC-FUNC("ColumnStringValue" IN hSource,"Object_type_code":U))
         cProp  =  trim(DYNAMIC-FUNC("getDataValue" IN hEvent ))
         NO-ERROR.

  RUN SUPER.
  
  IF RETURN-VALUE <> "ADM-ERROR":U 
  THEN DO:
     hProcedure = SESSION:FIRST-PROCEDURE.
     DO WHILE VALID-HANDLE(hProcedure) AND hProcedure:FILE-NAME NE "ry/prc/ryvobplipp.p":U:
       hProcedure = hProcedure:NEXT-SIBLING.
     END.
     
     IF VALID-HANDLE(hProcedure) AND 
        cLevel = "ObjectType" AND
        cClass <> ? THEN
     DO:
        
        RUN refreshProperty IN hProcedure 
            (INPUT cClass,
             INPUT cProp,
             INPUT "Delete":U,
             INPUT "Event":U
             ) NO-ERROR.
     END.
     ELSE DO:
        RUN destroyClassCache IN gshRepositoryManager.
     END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFields vTableWin 
PROCEDURE displayFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcColValues AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cEventName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE     NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcColValues).

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    {get DataSource hDataSource}.
    ASSIGN cEventName = ENTRY(2,DYNAMIC-FUNCTION ("colValues" IN hDataSource, INPUT "event_name"),CHR(1)).
    IF cEventName = ? OR /* We are probably adding a new record */
       cEventName = "?":U THEN 
      cEventName = "":U.
    RUN assignNewValue IN hEvent (INPUT cEventName, INPUT cEventName, INPUT FALSE).
  END.

  IF fiClassList:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U THEN
    RUN assignClassHierarchy.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields vTableWin 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    IF RowObject.event_name:HIDDEN THEN
      RUN enableField IN hEvent.
    ELSE
      RUN disableField IN hEvent.
  END.
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

  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "lookupDisplayComplete":U  IN THIS-PROCEDURE.
  
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lookupDisplayComplete vTableWin 
PROCEDURE lookupDisplayComplete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFieldList     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcFieldValues   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcKeyValue      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phLookupHandle  AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    IF RowObject.event_name:HIDDEN AND 
       RowObject.action_type:SENSITIVE THEN
      ASSIGN RowObject.event_name:SCREEN-VALUE = pcKeyValue
             RowObject.event_name:MODIFIED     = TRUE.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord vTableWin 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hPropertysheet AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hProcedure     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSource        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNew           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLevel         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cClass         AS CHARACTER  NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  {get NewRecord cNew}.
  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
   /* Code placed here will execute AFTER standard behavior.    */
  IF RETURN-VALUE <> "ADM-ERROR":U 
  THEN DO:
     hProcedure = SESSION:FIRST-PROCEDURE.
     DO WHILE VALID-HANDLE(hProcedure) AND hProcedure:FILE-NAME NE "ry/prc/ryvobplipp.p":U:
       hProcedure = hProcedure:NEXT-SIBLING.
     END.
     
     IF VALID-HANDLE(hProcedure) THEN
     DO:
        /* Get the DataSource of the parent node */
        {get DataSource hSource}.
        ASSIGN cLevel = DYNAMIC-FUNCTION("getSDOLevel":U IN hSource).
        {get DataSource hSource hSource}.
        /* Determine where we are */
        ASSIGN cClass = TRIM(DYNAMIC-FUNC("ColumnStringValue" IN hSource,"Object_type_code":U)).
        /* Only do this for Class Level UI Events */
        IF cLevel = "ObjectType" AND 
           cClass <> ? THEN
          RUN refreshProperty IN hProcedure 
              (INPUT cClass,
               INPUT trim(DYNAMIC-FUNC("getDataValue" IN hEvent )),
               INPUT IF cNew = "ADD" OR cNew = "Copy":U THEN "Add":U ELSE "Modifiy":U ,
               INPUT "Event":U
               ) NO-ERROR.
     END.
     ELSE DO:
        RUN destroyClassCache IN gshRepositoryManager.
     END.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject vTableWin 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLevel      AS CHARACTER  NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  {get DataSource hDataSource}.
  /* Determine where we are */
  IF VALID-HANDLE(hDataSource) THEN
    ASSIGN cLevel = DYNAMIC-FUNCTION("getSDOLevel":U IN hDataSource).
  IF cLevel <> "ObjectType":U THEN DO:
    RUN viewObject IN hEvent.
    ASSIGN RowObject.event_name:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.
  END.
  ELSE DO:
    RUN hideObject IN hEvent.
    ASSIGN RowObject.event_name:HIDDEN IN FRAME {&FRAME-NAME} = FALSE.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

