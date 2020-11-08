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
       {"af/obj2/gsmpyfullo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/* Copyright (C) 2005,2007 by Progress Software Corporation. All rights
   reserved.  Prior versions of this work may contain portions
   contributed by participants of Possenet. */
/*---------------------------------------------------------------------------------
  File: gsmpyviewv.w

  Description:  Physical Service SmartDataViewer

  Purpose:      Physical Service Static SmartDataViewer
                
                This viewer contains a placeholder SDF which is replaced at runtime with a
                SDF based on the maintenance object of the service type of the current
                physical service.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000026   UserRef:    posse
                Date:   12/04/2001  Author:     Tammy St Pierre

  Update Notes: Created from Template rysttviewv.w

  (v:010001)    Task:    90000043   UserRef:    posse
                Date:   20/04/2001  Author:     Tammy St Pierre

  Update Notes: Added note about placeholder SDF

  (v:010002)    Task:           0   UserRef:    
                Date:   10/29/2001  Author:     Mark Davies (MIP)

  Update Notes: The viewers always went into a modifiable state when navigating through the records.
                Added code to force disablement when in view mode.

-------------------------------------------------------------------------------*/
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

&scop object-name       gsmpyviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}
{af/sup2/afttcombo.i}

DEFINE VARIABLE gdServiceTypeObj    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gcMode              AS CHARACTER  NO-UNDO.

DEFINE VARIABLE glComboValueChanged AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "af/obj2/gsmpyfullo.i"

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.physical_service_code ~
RowObject.physical_service_description 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS RECT-1 
&Scoped-Define DISPLAYED-FIELDS RowObject.physical_service_code ~
RowObject.physical_service_description 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS fiConnectionParametersLabel 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hServiceType AS HANDLE NO-UNDO.
DEFINE VARIABLE h_connectParam AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiConnectionParametersLabel AS CHARACTER FORMAT "X(35)":U INITIAL "Connection parameters:" 
      VIEW-AS TEXT 
     SIZE 23.2 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 135 BY 23.14.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.physical_service_code AT ROW 1 COL 37.2 COLON-ALIGNED
          LABEL "Physical service code"
          VIEW-AS FILL-IN 
          SIZE 45.4 BY 1
     RowObject.physical_service_description AT ROW 2.1 COL 37.2 COLON-ALIGNED
          LABEL "Physical service description"
          VIEW-AS FILL-IN 
          SIZE 78.4 BY 1
     fiConnectionParametersLabel AT ROW 4.33 COL 4.6 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 4.52 COL 5
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gsmpyfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gsmpyfullo.i}
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
         HEIGHT             = 27.76
         WIDTH              = 142.4.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fiConnectionParametersLabel IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiConnectionParametersLabel:PRIVATE-DATA IN FRAME frMain     = 
                "Connection parameters:".

/* SETTINGS FOR FILL-IN RowObject.physical_service_code IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.physical_service_description IN FRAME frMain
   EXP-LABEL                                                            */
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
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_service_type.service_type_description,gsc_service_type.service_type_codeKeyFieldgsc_service_type.service_type_objFieldLabelService typeFieldTooltipSelect a service type from the listKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH gsc_service_type NO-LOCK BY gsc_service_type.service_type_codeQueryTablesgsc_service_typeSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1 / &2ComboDelimiterListItemPairsInnerLines5SortnoComboFlagFlagValueBuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesUseCacheyesSuperProcedureDataSourceNameFieldNameservice_type_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hServiceType ).
       RUN repositionObject IN hServiceType ( 3.19 , 39.20 ) NO-ERROR.
       RUN resizeObject IN hServiceType ( 1.05 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'af/obj2/gsmpydatfv.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FieldNameconnection_parametersDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_connectParam ).
       RUN repositionObject IN h_connectParam ( 5.00 , 6.60 ) NO-ERROR.
       RUN resizeObject IN h_connectParam ( 5.14 , 92.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( hServiceType ,
             RowObject.physical_service_description:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_connectParam ,
             hServiceType , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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
  DEFINE INPUT PARAMETER pcKeyFieldValue        AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcScreenValue          AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phCombo                AS HANDLE     NO-UNDO. 

  IF phCombo = hServiceType THEN DO:
    glComboValueChanged = TRUE.
    RUN recreateSDF.
    glComboValueChanged = FALSE.
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

  DEFINE INPUT PARAMETER pcColValues AS CHARACTER    NO-UNDO.

  RUN recreateSDF.

  RUN SUPER( INPUT pcColValues).

  IF gcMode = "View":U THEN DO:
    RUN disableFields (INPUT "":U).
    IF VALID-HANDLE(h_connectParam) THEN
      RUN disableField IN h_connectParam.
  END.
  ELSE DO:
    RUN enableFields.
    IF VALID-HANDLE(h_connectParam) THEN
      RUN enableField IN h_connectParam.
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

  SUBSCRIBE TO "comboValueChanged":U IN THIS-PROCEDURE.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recreateSDF vTableWin 
PROCEDURE recreateSDF :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cAllFieldHandles  AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cAllFieldNames    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cDataValue        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cDisplayedFields  AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cEnabledFields    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cEnabledHandles   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cFieldHandles     AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cFileName         AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cNewRecord        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cPath             AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cSDF              AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE dCol              AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dRow              AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE hDataSource       AS HANDLE       NO-UNDO.
  DEFINE VARIABLE iFieldHeight      AS INTEGER      NO-UNDO.
  DEFINE VARIABLE iFieldWidth       AS INTEGER      NO-UNDO.
  DEFINE VARIABLE iRectHeight       AS INTEGER      NO-UNDO.
  DEFINE VARIABLE iRectWidth        AS INTEGER      NO-UNDO.

  hDataSource = DYNAMIC-FUNCTION('getDataSource':U).

  cNewRecord = DYNAMIC-FUNCTION('getNewRecord':U).

  /* We need to destroy the connection parameters SDF and construct a new
     connection parameters SDF based on the service type maintenance object  */
  IF VALID-HANDLE(h_connectParam) THEN 
  DO:
    dCol = DYNAMIC-FUNCTION('getCol':U IN h_connectParam).
    dRow = DYNAMIC-FUNCTION('getRow':U IN h_connectParam).

    /* Destroy the SDF that is currently there */
    RUN destroyObject IN h_connectParam.

    
    /* If recreateSDF is being called from the service type SDF on value-changed event we want to 
       get the current data value to determine which SDF need to be run */
    IF glComboValueChanged THEN 
    DO:
      cDataValue = DYNAMIC-FUNCTION('getDataValue':U IN hServiceType). 
      RUN af/sup2/gscstmntop.p ON gshAstraAppServer (INPUT cDataValue , OUTPUT cPath, OUTPUT cFileName).
    END.  /* if source-proc = service type SDF */
    /* If recreateSDF is not being called from the service type SDF and is being called from
       display fields we need to try to get the object path and filename from the SDO, if this is
       a new record, the path and filename returned are blank and we need to get the path and
       filename for the first service type record (by code) that will display in the combo. */
    ELSE DO:
      cPath = DYNAMIC-FUNCTION('columnStringValue':U IN hDataSource, INPUT 'object_path':U).
      cFileName = DYNAMIC-FUNCTION('columnStringValue':U IN hDataSource, INPUT 'object_filename':U).
      IF cPath = '':U AND cFileName = '':U THEN
        RUN af/sup2/gscstmntop.p ON gshAstraAppServer (INPUT 0, OUTPUT cPath, OUTPUT cFileName).
    END.  /* else do */

    cSDF = TRIM(cPath) + '/':U + TRIM(cFileName).
    IF cSDF = '/':U OR cSDF = '':U OR cSDF = "?":U OR cSDF = ? THEN
      cSDF = 'af/obj2/gsmpydatfv.w':U.

    /* Construct the SDF based on the path and filename we retrieved above */
    RUN constructObject (
          INPUT  cSDF ,
          INPUT  FRAME frMain:HANDLE ,
          INPUT  'FieldNameconnection_parametersDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
          OUTPUT h_ConnectParam ).

    RUN repositionObject IN h_connectParam( dRow , dCol ) NO-ERROR.

    iFieldHeight = DYNAMIC-FUNCTION('getHeight':U IN h_connectParam).
    iFieldWidth = DYNAMIC-FUNCTION('getWidth':U IN h_connectParam).

    RUN initializeObject IN h_connectParam.

    /* Replace the handle of the placeholder SDF (or last SDF) with the handle for the SDF 
       just constructed */
    cDisplayedFields = DYNAMIC-FUNCTION('getDisplayedFields':U).
    cFieldHandles = DYNAMIC-FUNCTION('getFieldHandles':U).
    ENTRY(LOOKUP('connection_parameters':U, cDisplayedFields), cFieldHandles) = STRING(h_connectParam).

    cEnabledFields = DYNAMIC-FUNCTION('getEnabledFields':U).
    cEnabledHandles = DYNAMIC-FUNCTION('getEnabledHandles':U).
    ENTRY(LOOKUP('connection_parameters':U, cEnabledFields), cEnabledHandles) = STRING(h_connectParam).
    
    DYNAMIC-FUNCTION('setFieldHandles':U, INPUT cFieldHAndles).
    DYNAMIC-FUNCTION('setEnabledHandles':U, INPUT cEnabledHandles).
     
    cAllFieldNames = DYNAMIC-FUNCTION('getAllFieldNames':U).
    cAllFieldHandles = DYNAMIC-FUNCTION('getAllFieldHandles':U).
    ENTRY(LOOKUP('connection_parameters':U, cAllFieldNames), cAllFieldHandles) = STRING(h_connectParam).
  
    DYNAMIC-FUNCTION('setAllFieldHandles':U, INPUT cAllFieldHandles). 
  END.  /* if valid-handle */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateMode vTableWin 
PROCEDURE updateMode :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcMode AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcMode).

  IF pcMode = "View":U THEN
    gcMode = "View":U.
  ELSE 
    gcMode = "Enabled":U.
    
  /* Code placed here will execute AFTER standard behavior.    */

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
DEFINE VARIABLE cButton     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cErrorList  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cErrorText  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iNumError   AS INTEGER      NO-UNDO.

  PUBLISH 'validateField' (OUTPUT cErrorList).

  DO iNumError = 1 TO NUM-ENTRIES(cErrorList):
    cErrorText = cErrorText + (IF NUM-ENTRIES(cErrorText,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                 {af/sup2/aferrortxt.i 'AF' ENTRY(iNumError,cErrorList) 'gsm_physical_service' 'connection_parameters' "'Connection Parameters'"}.
  END.  /* do iNumError */

  IF cErrorText NE '':U THEN DO:
    RUN showMessages IN gshSessionManager (INPUT cErrorText,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Validate Physical Service Connections",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).
    RETURN 'ADM-ERROR':U.
  END. /* if error */

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

