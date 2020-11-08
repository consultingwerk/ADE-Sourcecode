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
       {"af/obj2/gscotfullo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: gscotviewv.w

  Description:  Object Type Smart Data Viewer

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/15/2002  Author:     Mark Davies (MIP)

  Update Notes: Created from Template rysttviewv.w
                Created from Template 12345678901234567890

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

&scop object-name       gscotviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "af/obj2/gscotfullo.i"

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.object_type_code ~
RowObject.object_type_description RowObject.disabled ~
RowObject.static_object RowObject.deployment_type ~
RowObject.layout_supported RowObject.cache_on_client 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS RECT-3 toDeployServer toDeployClient ~
toDeployWeb 
&Scoped-Define DISPLAYED-FIELDS RowObject.object_type_code ~
RowObject.object_type_description RowObject.disabled ~
RowObject.static_object RowObject.deployment_type ~
RowObject.layout_supported RowObject.cache_on_client 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS toDeployServer toDeployClient toDeployWeb ~
fiDepTypeTitle 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE class_smartobject_obj AS HANDLE NO-UNDO.
DEFINE VARIABLE custom_object_type_obj AS HANDLE NO-UNDO.
DEFINE VARIABLE extends_object_type_obj AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiDepTypeTitle AS CHARACTER FORMAT "X(15)":U INITIAL "Deployment type:" 
      VIEW-AS TEXT 
     SIZE 18 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 56 BY 1.14.

DEFINE VARIABLE toDeployClient AS LOGICAL INITIAL no 
     LABEL "Client" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .81 NO-UNDO.

DEFINE VARIABLE toDeployServer AS LOGICAL INITIAL no 
     LABEL "Server" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .81 NO-UNDO.

DEFINE VARIABLE toDeployWeb AS LOGICAL INITIAL no 
     LABEL "Web" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.object_type_code AT ROW 1 COL 25.8 COLON-ALIGNED
          LABEL "Class Name" FORMAT "X(30)"
          VIEW-AS FILL-IN 
          SIZE 55.4 BY 1
     RowObject.object_type_description AT ROW 2.1 COL 25.8 COLON-ALIGNED
          LABEL "Class Description"
          VIEW-AS FILL-IN 
          SIZE 55.4 BY 1
     RowObject.disabled AT ROW 3.1 COL 27.8
          LABEL "Disabled"
          VIEW-AS TOGGLE-BOX
          SIZE 13.2 BY 1
     RowObject.static_object AT ROW 3.1 COL 53
          LABEL "Static object"
          VIEW-AS TOGGLE-BOX
          SIZE 17.2 BY 1
     RowObject.deployment_type AT ROW 3.48 COL 20.2 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 2 BY 1
     RowObject.layout_supported AT ROW 3.91 COL 27.8
          LABEL "Layout supported"
          VIEW-AS TOGGLE-BOX
          SIZE 21.8 BY 1
     RowObject.cache_on_client AT ROW 3.91 COL 53
          LABEL "Cache on client"
          VIEW-AS TOGGLE-BOX
          SIZE 19.8 BY 1
     toDeployServer AT ROW 5.05 COL 25.8 COLON-ALIGNED
     toDeployClient AT ROW 5.05 COL 41.8 COLON-ALIGNED
     toDeployWeb AT ROW 5.05 COL 58.4 COLON-ALIGNED
     fiDepTypeTitle AT ROW 4.91 COL 6.2 COLON-ALIGNED NO-LABEL
     RECT-3 AT ROW 4.91 COL 24.6 COLON-ALIGNED
     SPACE(0.00) SKIP(3.47)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gscotfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gscotfullo.i}
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
         HEIGHT             = 8.67
         WIDTH              = 82.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB vTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/widgetprto.i}
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

/* SETTINGS FOR TOGGLE-BOX RowObject.cache_on_client IN FRAME frMain
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.deployment_type:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR TOGGLE-BOX RowObject.disabled IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN fiDepTypeTitle IN FRAME frMain
   NO-ENABLE DEF-LABEL DEF-HELP                                         */
ASSIGN 
       fiDepTypeTitle:PRIVATE-DATA IN FRAME frMain     = 
                "Deployment type:".

/* SETTINGS FOR TOGGLE-BOX RowObject.layout_supported IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.object_type_code IN FRAME frMain
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN RowObject.object_type_description IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR RECTANGLE RECT-3 IN FRAME frMain
   ALIGN-C DEF-LABEL DEF-FORMAT DEF-HELP                                */
/* SETTINGS FOR TOGGLE-BOX RowObject.static_object IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX toDeployClient IN FRAME frMain
   ALIGN-C DEF-FORMAT DEF-HELP                                          */
/* SETTINGS FOR TOGGLE-BOX toDeployServer IN FRAME frMain
   ALIGN-C DEF-FORMAT DEF-HELP                                          */
/* SETTINGS FOR TOGGLE-BOX toDeployWeb IN FRAME frMain
   ALIGN-C DEF-FORMAT DEF-HELP                                          */
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

&Scoped-define SELF-NAME toDeployClient
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toDeployClient vTableWin
ON VALUE-CHANGED OF toDeployClient IN FRAME frMain /* Client */
DO:
    RUN changeDeploymentType IN TARGET-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toDeployServer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toDeployServer vTableWin
ON VALUE-CHANGED OF toDeployServer IN FRAME frMain /* Server */
DO:
    RUN changeDeploymentType IN TARGET-PROCEDURE.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toDeployWeb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toDeployWeb vTableWin
ON VALUE-CHANGED OF toDeployWeb IN FRAME frMain /* Web */
DO:
    RUN changeDeploymentType IN TARGET-PROCEDURE.
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
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.smartobject_objFieldLabelClass Object NameFieldTooltipPress F4 for Procedure LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK WHERE gsc_object_type.object_type_code = "PROCEDURE":U, EACH ryc_smartobject NO-LOCK WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj AND ryc_smartobject.customization_result_obj = 0 BY ryc_smartobject.object_filenameQueryTablesgsc_object_type,ryc_smartobjectBrowseFieldsryc_smartobject.object_filename,ryc_smartobject.object_extension,ryc_smartobject.object_description,ryc_smartobject.object_pathBrowseFieldDataTypescharacter,character,character,characterBrowseFieldFormatsX(70)|X(35)|X(35)|X(70)RowsToBatch200BrowseTitleProcedure LookupViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameLookupProcedureSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailyesMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNameclass_smartobject_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT class_smartobject_obj ).
       RUN repositionObject IN class_smartobject_obj ( 6.33 , 27.20 ) NO-ERROR.
       RUN resizeObject IN class_smartobject_obj ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_object_type.object_type_codeKeyFieldgsc_object_type.object_type_objFieldLabelClass ExtendsFieldTooltipPress F4 for LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringfor each gsc_object_type no-lockQueryTablesgsc_object_typeBrowseFieldsgsc_object_type.object_type_code,gsc_object_type.object_type_descriptionBrowseFieldDataTypescharacter,characterBrowseFieldFormatsX(35)|X(35)RowsToBatch200BrowseTitleLookup ClassViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNamegscotcuslkSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListNO-LOCKQueryBuilderOrderListQueryBuilderTableOptionListNO-LOCKQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailyesMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNameextends_object_type_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT extends_object_type_obj ).
       RUN repositionObject IN extends_object_type_obj ( 7.43 , 27.20 ) NO-ERROR.
       RUN resizeObject IN extends_object_type_obj ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_object_type.object_type_codeKeyFieldgsc_object_type.object_type_objFieldLabelCustomizing ClassFieldTooltipPress F4 for LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringfor each gsc_object_type no-lockQueryTablesgsc_object_typeBrowseFieldsgsc_object_type.object_type_code,gsc_object_type.object_type_descriptionBrowseFieldDataTypescharacter,characterBrowseFieldFormatsX(35)|X(35)RowsToBatch200BrowseTitleLookup Customizing ClassViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNamegscotcuslkSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectryclsfoldwMaintenanceSDOgscotfullo.wCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListNO-LOCKQueryBuilderOrderListQueryBuilderTableOptionListNO-LOCKQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailyesMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNamecustom_object_type_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT custom_object_type_obj ).
       RUN repositionObject IN custom_object_type_obj ( 8.52 , 27.20 ) NO-ERROR.
       RUN resizeObject IN custom_object_type_obj ( 1.00 , 50.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( class_smartobject_obj ,
             toDeployWeb:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( extends_object_type_obj ,
             class_smartobject_obj , 'AFTER':U ).
       RUN adjustTabOrder ( custom_object_type_obj ,
             extends_object_type_obj , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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

