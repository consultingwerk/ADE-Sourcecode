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
       {"ry/obj/rycsmful2o.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/* Copyright (C) 2005,2007 by Progress Software Corporation. All rights
   reserved.  Prior versions of this work may contain portions
   contributed by participants of Possenet. */
/*---------------------------------------------------------------------------------
  File: rycsmvietv.w

  Description:  SmartLink TreeView SmartDataViewer

  Purpose:      SmartLink TreeView SmartDataViewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:   101000026   UserRef:    
                Date:   09/10/2001  Author:     Mark Davies

  Update Notes: Created from Template rysttviewv.w
                SmartLink TreeView SmartDataViewer

  Modified: Mark Davies (MIP)     09/25/2001
            Replace references to KeyFieldValue by DataValue

  (v:010001)    Task:           0   UserRef:    
                Date:   03/11/2002  Author:     Mark Davies (MIP)

  Update Notes: Fix for issue #3963 - Adding Links in Repository Maintenance does not save the correct source or target if there are more than one instances of the same object for a container.

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

&scop object-name       rycsmvietv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}

DEFINE VARIABLE glAdd AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/rycsmful2o.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.container_smartobject_obj ~
RowObject.link_name 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS cContainerObjs 
&Scoped-Define DISPLAYED-FIELDS RowObject.container_smartobject_obj ~
RowObject.link_name 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS toSourceThisProc toTargetThisProc 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hSource AS HANDLE NO-UNDO.
DEFINE VARIABLE hTarget AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dynlookup AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE cContainerObjs AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 2.4 BY 1 NO-UNDO.

DEFINE VARIABLE toSourceThisProc AS LOGICAL INITIAL no 
     LABEL "THIS-OBJECT (Source)" 
     VIEW-AS TOGGLE-BOX
     SIZE 34.4 BY .81 NO-UNDO.

DEFINE VARIABLE toTargetThisProc AS LOGICAL INITIAL no 
     LABEL "THIS-OBJECT (Target)" 
     VIEW-AS TOGGLE-BOX
     SIZE 32.8 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     cContainerObjs AT ROW 1.1 COL 1.8 NO-LABEL
     RowObject.container_smartobject_obj AT ROW 1.1 COL 5.4 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 1.6 BY 1
     toSourceThisProc AT ROW 1.19 COL 17.8
     RowObject.link_name AT ROW 4.24 COL 15.8 COLON-ALIGNED
          LABEL "Link name"
          VIEW-AS FILL-IN 
          SIZE 30 BY 1
     toTargetThisProc AT ROW 6.38 COL 17.8
     SPACE(48.00) SKIP(0.00)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/rycsmful2o.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/rycsmful2o.i}
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
         HEIGHT             = 6.81
         WIDTH              = 97.6.
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

/* SETTINGS FOR FILL-IN cContainerObjs IN FRAME frMain
   NO-DISPLAY ALIGN-L                                                   */
ASSIGN 
       cContainerObjs:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.container_smartobject_obj IN FRAME frMain
   ALIGN-L EXP-LABEL                                                    */
ASSIGN 
       RowObject.container_smartobject_obj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.container_smartobject_obj:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

/* SETTINGS FOR FILL-IN RowObject.link_name IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX toSourceThisProc IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX toTargetThisProc IN FRAME frMain
   NO-ENABLE                                                            */
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
  
  glAdd = TRUE.

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN SUPER.
 
  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN newRecord.

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
             INPUT  'DisplayedFieldryc_object_instance.instance_nameKeyFieldryc_object_instance.object_instance_objFieldLabelSourceFieldTooltipPress F4 For LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_object_instance NO-LOCK,
                     FIRST ryc_smartobject WHERE ryc_smartobject.smartobject_obj = ryc_object_instance.smartobject_obj NO-LOCK
                     BY ryc_smartobject.object_filenameQueryTablesryc_object_instance,ryc_smartobjectBrowseFieldsryc_object_instance.instance_name,ryc_object_instance.instance_description,ryc_smartobject.object_filename,ryc_smartobject.object_descriptionBrowseFieldDataTypescharacter,character,character,characterBrowseFieldFormatsX(35)|X(70)|X(70)|X(35)RowsToBatch200BrowseTitleLookup Source InstanceViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldcContainerObjsParentFilterQueryLOOKUP(STRING(ryc_object_instance.container_smartobject_obj),~'&1~') > 0MaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNamesource_object_instance_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hSource ).
       RUN repositionObject IN hSource ( 2.05 , 17.80 ) NO-ERROR.
       RUN resizeObject IN hSource ( 1.00 , 80.80 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartlink_type.link_nameKeyFieldryc_smartlink_type.smartlink_type_objFieldLabelLink typeFieldTooltipPress F4 to lookup a smartlinkKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(28)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_smartlink_type NO-LOCK BY ryc_smartlink_type.link_name INDEXED-REPOSITIONQueryTablesryc_smartlink_typeBrowseFieldsryc_smartlink_type.link_name,ryc_smartlink_type.system_owned,ryc_smartlink_type.user_defined_linkBrowseFieldDataTypescharacter,logical,logicalBrowseFieldFormatsX(28)|YES/NO|YES/NORowsToBatch200BrowseTitleLookup SmartLinksViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListNO-LOCK INDEXED-REPOSITIONQueryBuilderOrderListryc_smartlink_type.link_name^yesQueryBuilderTableOptionListNO-LOCKQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNamesmartlink_type_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup ).
       RUN repositionObject IN h_dynlookup ( 3.14 , 17.80 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup ( 1.00 , 80.80 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_object_instance.instance_nameKeyFieldryc_object_instance.object_instance_objFieldLabelTargetFieldTooltipPress F4 For LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_object_instance NO-LOCK,
                     FIRST ryc_smartobject WHERE ryc_smartobject.smartobject_obj = ryc_object_instance.smartobject_obj NO-LOCK
                     BY ryc_smartobject.object_filenameQueryTablesryc_object_instance,ryc_smartobjectBrowseFieldsryc_object_instance.instance_name,ryc_object_instance.instance_description,ryc_smartobject.object_filename,ryc_smartobject.object_descriptionBrowseFieldDataTypescharacter,character,character,characterBrowseFieldFormatsX(35)|X(70)|X(70)|X(35)RowsToBatch200BrowseTitleLookup Target InstanceViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldcContainerObjsParentFilterQueryLOOKUP(STRING(ryc_object_instance.container_smartobject_obj),~'&1~') > 0MaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNametarget_object_instance_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hTarget ).
       RUN repositionObject IN hTarget ( 5.33 , 17.80 ) NO-ERROR.
       RUN resizeObject IN hTarget ( 1.00 , 80.40 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( hSource ,
             toSourceThisProc:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_dynlookup ,
             hSource , 'AFTER':U ).
       RUN adjustTabOrder ( hTarget ,
             RowObject.link_name:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE collectChanges vTableWin 
PROCEDURE collectChanges :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER pcChanges AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcInfo    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cInstance    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessageList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton      AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN toSourceThisProc
           toTargetThisProc.
  END.
  
  /* SOURCE */
  cInstance = DYNAMIC-FUNCTION("getDataValue":U IN hSource).
  IF DECIMAL(cInstance) <> 0 AND 
     toSourceThisProc THEN
    cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                  {af/sup2/aferrortxt.i 'AF' '41' '' '' "'THIS-PROCEDURE (Source)'" "'Source procedure'"}.

  /* TARGET */
  cInstance = DYNAMIC-FUNCTION("getDataValue":U IN hTarget).
  IF DECIMAL(cInstance) <> 0 AND 
     toTargetThisProc THEN
    cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                  {af/sup2/aferrortxt.i 'AF' '41' '' '' "'THIS-PROCEDURE (Target)'" "'Target procedure'"}.

  IF cMessageList <> "":U THEN DO:
    RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Validation Failed",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).                        
    RETURN ERROR.
  END.
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT-OUTPUT pcChanges, INPUT-OUTPUT pcInfo).

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyRecord vTableWin 
PROCEDURE copyRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.
  
  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN newRecord.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableFields vTableWin 
PROCEDURE disableFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcFieldType AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcFieldType).

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN toSourceThisProc:SENSITIVE = rowObject.link_name:SENSITIVE
           toTargetThisProc:SENSITIVE = rowObject.link_name:SENSITIVE.
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

  DEFINE VARIABLE cInstance   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dSourceObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dTargetObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cColValues  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSourceHdl  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTargetHdl  AS HANDLE     NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcColValues).
  
  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN setDetails.

  IF NOT glAdd THEN DO WITH FRAME {&FRAME-NAME}:
    {get DataSource hDataSource}.
    ASSIGN cColValues = DYNAMIC-FUNCTION ("colValues" IN hDataSource, INPUT "source_object_instance_obj,target_object_instance_obj").
    ASSIGN dSourceObj = DECIMAL(ENTRY(2, cColValues, CHR(1)))
           dTargetObj = DECIMAL(ENTRY(3, cColValues, CHR(1))).

    {get LookupHandle hSourceHdl hSource}.
    {get LookupHandle hTargetHdl hTarget}.

    /* SOURCE */
    cInstance = DYNAMIC-FUNCTION("getDataValue":U IN hSource).
    IF DECIMAL(cInstance) = 0 AND dSourceObj <> 0 THEN DO:
      RUN assignNewValue IN hSource (STRING(hSource), "", FALSE).
      cInstance = DYNAMIC-FUNCTION("getDataValue":U IN hSource).
    END.
    
    IF DECIMAL(cInstance) = 0 AND dSourceObj = 0 THEN
      ASSIGN toSourceThisProc:CHECKED IN FRAME {&FRAME-NAME} = TRUE.
    ELSE
      ASSIGN toSourceThisProc:CHECKED IN FRAME {&FRAME-NAME} = FALSE.

    IF dSourceObj <> 0 AND LENGTH(cInstance) = 0 THEN DO:
      RUN assignNewValue IN hSource (INPUT dSourceObj, INPUT "":U, INPUT FALSE).
      cInstance = DYNAMIC-FUNCTION("getDataValue":U IN hSource).
      IF dSourceObj <> 0 AND LENGTH(cInstance) = 0 THEN
        ASSIGN toSourceThisProc:CHECKED = FALSE
               hSourceHdl:SCREEN-VALUE  = "<INVALID OBJECT INSTANCE>".
      ELSE
        ASSIGN toSourceThisProc:CHECKED = FALSE.
    END.

    /* TARGET */
    cInstance = DYNAMIC-FUNCTION("getDataValue":U IN hTarget).
    IF DECIMAL(cInstance) = 0 AND dTargetObj <> 0 THEN DO:
      RUN assignNewValue IN hTarget(STRING(dTargetObj), "", FALSE).
      cInstance = DYNAMIC-FUNCTION("getDataValue":U IN hTarget).
    END.

    IF DECIMAL(cInstance) = 0 AND dTargetObj = 0 THEN
      ASSIGN toTargetThisProc:CHECKED IN FRAME {&FRAME-NAME} = TRUE.
    ELSE
      ASSIGN toTargetThisProc:CHECKED IN FRAME {&FRAME-NAME} = FALSE.
    IF dTargetObj <> 0 AND DECIMAL(cInstance) = 0 THEN
    ASSIGN toTargetThisProc:CHECKED = FALSE
           hTargetHdl:SCREEN-VALUE  = "<INVALID OBJECT INSTANCE>".
  END.
  glAdd = FALSE.
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
    ASSIGN toSourceThisProc:SENSITIVE = rowObject.link_name:SENSITIVE
           toTargetThisProc:SENSITIVE = rowObject.link_name:SENSITIVE.
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
  DEFINE VARIABLE hDataSource AS HANDLE     NO-UNDO.


  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  {get DataSource hDataSource}.

  /* This will set the lookups correctly. The first time the lookups
     are not set for some reason - redisplaying the data solves this problem */
  IF NOT glAdd THEN
    PUBLISH "DataAvailable":U FROM hDataSource (INPUT "DIFFERENT":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE newRecord vTableWin 
PROCEDURE newRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDataSource AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hParentData AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cColvalues  AS CHARACTER  NO-UNDO.

  {get DataSource cDataSource}.
  
  DO iLoop = 1 TO NUM-ENTRIES(cDataSource):
    hDataSource = WIDGET-HANDLE(ENTRY(iLoop,cDataSource)).
    IF VALID-HANDLE(hDataSource) THEN DO:
      {get DataSource hParentData hDataSource}.
      ASSIGN cColvalues = DYNAMIC-FUNCTION ("colValues" IN hParentData, INPUT "smartobject_obj").
      DO WITH FRAME {&FRAME-NAME}:
        ASSIGN RowObject.container_smartobject_obj:SCREEN-VALUE = ENTRY(2, cColValues, CHR(1)).
      END.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDetails vTableWin 
PROCEDURE setDetails :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDataSet    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomObj  AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE cAllObjects AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
  RUN getRecordDetail IN gshGenManager ( INPUT "FOR EACH ryc_smartobject "
                                             + "WHERE ryc_smartobject.smartobject_obj = DECIMAL('" + rowObject.container_smartobject_obj:SCREEN-VALUE + "') NO-LOCK ":U,
                                         OUTPUT cDataset ).
  
    IF cDataset = "":U OR cDataset = ? THEN 
      RETURN "".
    ELSE
      ASSIGN cObjectName = ENTRY(LOOKUP("ryc_smartobject.object_filename":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3)) 
             dCustomObj  = DECIMAL(ENTRY(LOOKUP("ryc_smartobject.customization_result_obj":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3))) NO-ERROR.
      cAllObjects = STRING(DECIMAL(rowObject.container_smartobject_obj:SCREEN-VALUE)).
    IF dCustomObj <> 0 THEN DO:
      RUN getRecordDetail IN gshGenManager ( INPUT "FOR EACH ryc_smartobject " +
                                                    "WHERE ryc_smartobject.object_filename = '" + cObjectName + "' " 
                                                + " AND ryc_smartobject.customization_result_obj = 0 NO-LOCK ":U,
                                             OUTPUT cDataset ).
  
      IF cDataset = "":U OR cDataset = ? THEN 
        RETURN "".
      ELSE
        ASSIGN dCustomObj = DECIMAL(ENTRY(LOOKUP("ryc_smartobject.smartobject_obj":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3))) NO-ERROR.
      IF dCustomObj <> 0 THEN
        cAllObjects = cAllObjects + ",":U + STRING(dCustomObj).
    END.
    cContainerObjs:SCREEN-VALUE = cAllObjects.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

