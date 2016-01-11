&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
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
       {"ry/obj/rycoiful3o.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rycoivietv.w

  Description:  SmartObject Instance SmartDataViewer

  Purpose:      SmartObject Instance SmartDataViewer to be used in TreeView

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:   101000026   UserRef:    
                Date:   09/07/2001  Author:     Mark Davies

  Update Notes: Created from Template rysttviewv.w
                SmartObject Instance SmartDataViewer to be used in TreeView

  (v:010001)    Task:               UserRef:    
                Date:   09/25/2001  Author:     Mark Davies (MIP)

  Update Notes: Replace references to KeyFieldValue by DataValue

  (v:010002)    Task:           0   UserRef:    
                Date:   11/16/2001  Author:     Mark Davies (MIP)

  Update Notes: Disable object type and object instance smartobject when modifying

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

&scop object-name       rycoivietv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{afglobals.i}

DEFINE TEMP-TABLE ttRycPageObject RCODE-INFORMATION /* Defined same as RowobjUpd temp table */
    {ry/obj/rycpofullo.i}
    {src/adm2/rupdflds.i}.

DEFINE VARIABLE gcAction        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcObjectTypeObj AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/rycoiful3o.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.container_smartobject_obj ~
RowObject.iCreateSequence RowObject.layout_position RowObject.instance_x ~
RowObject.instance_y RowObject.instance_width RowObject.instance_height 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-FIELDS RowObject.container_smartobject_obj ~
RowObject.iCreateSequence RowObject.layout_position RowObject.instance_x ~
RowObject.instance_y RowObject.instance_width RowObject.instance_height ~
RowObject.dObjectInstanceObj 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_InstanceObj AS HANDLE NO-UNDO.
DEFINE VARIABLE h_ObjectTypeObj AS HANDLE NO-UNDO.
DEFINE VARIABLE h_PageObj AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.container_smartobject_obj AT ROW 2.81 COL 1.8 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 1.6 BY 1
     RowObject.iCreateSequence AT ROW 4.14 COL 18.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.6 BY 1
     RowObject.layout_position AT ROW 5.19 COL 18.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY 1
     RowObject.instance_x AT ROW 6.33 COL 18.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.8 BY 1
     RowObject.instance_y AT ROW 7.33 COL 18.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.8 BY 1
     RowObject.instance_width AT ROW 6.33 COL 59 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.8 BY 1
     RowObject.instance_height AT ROW 7.33 COL 59 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.8 BY 1
     RowObject.dObjectInstanceObj AT ROW 4.62 COL 69 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 2.4 BY 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/rycoiful3o.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/rycoiful3o.i}
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
         HEIGHT             = 7.33
         WIDTH              = 72.8.
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
   NOT-VISIBLE Size-to-Fit L-To-R,COLUMNS                               */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.container_smartobject_obj IN FRAME frMain
   ALIGN-L                                                              */
ASSIGN 
       RowObject.container_smartobject_obj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.container_smartobject_obj:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

/* SETTINGS FOR FILL-IN RowObject.dObjectInstanceObj IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.dObjectInstanceObj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.dObjectInstanceObj:READ-ONLY IN FRAME frMain        = TRUE
       RowObject.dObjectInstanceObj:PRIVATE-DATA IN FRAME frMain     = 
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

  /* Code placed here will execute PRIOR to standard behavior. */

  gcAction = "Add":U.
  RUN SUPER.
    
  RUN setFieldValues.
  /* Code placed here will execute AFTER standard behavior.    */

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
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_object_type.object_type_code,gsc_object_type.object_type_descriptionKeyFieldgsc_object_type.object_type_objFieldLabelObject TypeFieldTooltipSelect option from listKeyFormat>>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH gsc_object_type NO-LOCK BY gsc_object_type.object_type_code INDEXED-REPOSITIONQueryTablesgsc_object_typeSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1 / &2CurrentKeyValueComboDelimiterListItemPairsCurrentDescValueInnerLines0ComboFlagFlagValueBuildSequence1SecurednoFieldNamedObjectTypeObjDisplayFieldyesEnableFieldyesHideOnInitDisableOnInitnoObjectLayout':U ,
             OUTPUT h_ObjectTypeObj ).
       RUN repositionObject IN h_ObjectTypeObj ( 1.00 , 20.20 ) NO-ERROR.
       RUN resizeObject IN h_ObjectTypeObj ( 1.00 , 52.40 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.smartobject_objFieldLabelObject FilenameFieldTooltipKeyFormat>>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_smartobject NO-LOCK,
                     FIRST gsc_product_module WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj NO-LOCK,
                     FIRST gsc_product WHERE gsc_product.product_obj = gsc_product_module.product_obj NO-LOCK,
                     FIRST gsc_object WHERE gsc_object.object_obj = ryc_smartobject.object_obj NO-LOCK,
                     FIRST gsc_object_type WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj NO-LOCK BY gsc_product.product_code BY gsc_product_module.product_module_code BY ryc_smartobject.object_filename INDEXED-REPOSITIONQueryTablesryc_smartobject,gsc_product_module,gsc_product,gsc_object,gsc_object_typeBrowseFieldsgsc_product.product_code,gsc_product_module.product_module_code,gsc_object_type.object_type_code,ryc_smartobject.object_filename,gsc_object.object_descriptionBrowseFieldDataTypescharacter,character,character,character,characterBrowseFieldFormatsX(10),X(10),X(15),X(70),X(35)RowsToBatch200BrowseTitleLookup Instance ObjectViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFielddObjectTypeObjParentFilterQueryryc_smartobject.object_type_obj = DECIMAL(~'&1~')MaintenanceObjectMaintenanceSDOFieldNamesmartobject_objDisplayFieldyesEnableFieldyesHideOnInitDisableOnInitnoObjectLayout':U ,
             OUTPUT h_InstanceObj ).
       RUN repositionObject IN h_InstanceObj ( 2.05 , 20.20 ) NO-ERROR.
       RUN resizeObject IN h_InstanceObj ( 1.00 , 52.40 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_page.page_labelKeyFieldryc_page.page_objFieldLabelPageFieldTooltipSelect option from listKeyFormat>>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(28)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_page NO-LOCK BY ryc_page.page_sequenceQueryTablesryc_pageSDFFileNameSDFTemplateParentFieldcontainer_smartobject_objParentFilterQueryryc_page.container_smartobject_obj = DECIMAL(~'&1~')DescSubstitute&1CurrentKeyValueComboDelimiterListItemPairsCurrentDescValueInnerLines0ComboFlagNFlagValue0BuildSequence1SecurednoFieldNamedInstancePageObjDisplayFieldyesEnableFieldyesHideOnInitDisableOnInitnoObjectLayout':U ,
             OUTPUT h_PageObj ).
       RUN repositionObject IN h_PageObj ( 3.10 , 20.20 ) NO-ERROR.
       RUN resizeObject IN h_PageObj ( 1.00 , 52.40 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_ObjectTypeObj ,
             RowObject.container_smartobject_obj:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_InstanceObj ,
             h_ObjectTypeObj , 'AFTER':U ).
       RUN adjustTabOrder ( h_PageObj ,
             h_InstanceObj , 'AFTER':U ).
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
  DEFINE INPUT  PARAMETER pcKeyFieldValue AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcScreenValue   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phComboHandle   AS HANDLE     NO-UNDO.
  
  RUN setFieldState.
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

  gcAction = "Copy":U.
  RUN SUPER.

  RUN setFieldValues.
  /* Code placed here will execute AFTER standard behavior.    */

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
  
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcColValues).
  gcObjectTypeObj = ENTRY(12,pcColValues,CHR(1)) NO-ERROR.
  
  RUN setComboValue.
  RUN setFieldState.
  /* Code placed here will execute AFTER standard behavior.    */

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
    RUN SUPER.

    /* If the fields are not being enabled, and this is not an add or 
     * copy action, then it must be a modify action.                  */
    IF LOOKUP(gcAction, "ADD,COPY":U) EQ 0 THEN DO:
      RUN disableField IN h_ObjectTypeObj.
      RUN disableField IN h_InstanceObj.
    END.

    /* Reset the gcAction flag */
    ASSIGN gcAction = "":U.

    RETURN.
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

  /* Code placed here will execute PRIOR to standard behavior. */

  SUBSCRIBE TO "comboValueChanged":U IN THIS-PROCEDURE.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RTB_xref_generator vTableWin 
PROCEDURE RTB_xref_generator :
/* -----------------------------------------------------------
Purpose:    Generate RTB xrefs for SMARTOBJECTS.
Parameters: <none>
Notes:      This code is generated by the UIB.  DO NOT modify it.
            It is included for Roundtable Xref generation. Without
            it, Xrefs for SMARTOBJECTS could not be maintained by
            RTB.  It will in no way affect the operation of this
            program as it never gets executed.
-------------------------------------------------------------*/
  RUN "adm2\dyncombo.w *RTB-SmObj* ".
  RUN "adm2\dynlookup.w *RTB-SmObj* ".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setComboValue vTableWin 
PROCEDURE setComboValue :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hComboHandle    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cKeyFieldValue  AS CHARACTER  NO-UNDO.
  /* Change the '<All>' option to THIS-OBJECT in the two combos */
  hComboHandle = DYNAMIC-FUNCTION("getComboHandle":U IN h_PageObj).
  hComboHandle:LIST-ITEM-PAIRS = REPLACE(hComboHandle:LIST-ITEM-PAIRS,"<None>":U,"Page 0":U).
  cKeyFieldValue = DYNAMIC-FUNCTION("getDataValue":U IN h_PageObj).
  IF gcObjectTypeObj = ? OR 
     gcObjectTypeObj = "?":U THEN
    cKeyFieldValue = "0".
  
  hComboHandle:SCREEN-VALUE = cKeyFieldValue.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFieldState vTableWin 
PROCEDURE setFieldState :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cKeyFieldValue AS CHARACTER  NO-UNDO.
  cKeyFieldValue = DYNAMIC-FUNCTION("getDataValue":U IN h_PageObj).
  
  DO WITH FRAME {&FRAME-NAME}:
    IF DECIMAL(cKeyFieldValue) = 0 THEN
      ASSIGN rowObject.iCreateSequence:SCREEN-VALUE = "0"
             rowObject.iCreateSequence:SENSITIVE    = FALSE.
    ELSE IF RowObject.instance_x:SENSITIVE = TRUE THEN
      ASSIGN rowObject.iCreateSequence:SENSITIVE = TRUE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFieldValues vTableWin 
PROCEDURE setFieldValues :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDataSource     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hParentData     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cColvalues      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPageObj        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLevel          AS CHARACTER  NO-UNDO.
  
  {get DataSource cDataSource}.
  DO iLoop = 1 TO NUM-ENTRIES(cDataSource):
    hDataSource = WIDGET-HANDLE(ENTRY(iLoop,cDataSource)).
    IF VALID-HANDLE(hDataSource) THEN DO:
      /* Determine where we are */
      ASSIGN cLevel = DYNAMIC-FUNCTION("getSDOLevel":U IN hDataSource) NO-ERROR.
      {get DataSource hParentData hDataSource}.
      IF cLevel = "":U THEN
        cLevel = "SmartObject".
      CASE cLevel:
        WHEN "SmartObject":U THEN
          ASSIGN cColvalues = DYNAMIC-FUNCTION ("colValues" IN hParentData, INPUT "smartobject_obj").
        WHEN "Page":U THEN DO:
          ASSIGN cColvalues = DYNAMIC-FUNCTION ("colValues" IN hParentData, INPUT "container_smartobject_obj,page_obj")
                 cPageObj   = TRIM(DYNAMIC-FUNCTION("columnStringValue" IN hParentData, INPUT "page_obj")).
        END.
      END CASE.
      DO WITH FRAME {&FRAME-NAME}:
        ASSIGN RowObject.container_smartobject_obj:SCREEN-VALUE = ENTRY(2, cColValues, CHR(1)).
        RUN refreshChildDependancies IN h_PageObj ("container_smartobject_obj").
        RUN setComboValue.
        IF DECIMAL(cPageObj) <> 0 THEN DO:
          DYNAMIC-FUNCTION("setDataValue" IN h_PageObj, cPageObj).
          RUN setFieldState.
          RUN disableField IN h_PageObj.
          {set DataModified YES h_PageObj}.
        END.
      END.
    END.
  END.     

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

  DEFINE VARIABLE cDataSource     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLevel          AS CHARACTER  NO-UNDO.
  
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcMode).    

  IF pcMode <> "ENABLE" THEN
    RETURN.
  RUN setFieldState.
    
  {get DataSource cDataSource}.
  DO iLoop = 1 TO NUM-ENTRIES(cDataSource):
    hDataSource = WIDGET-HANDLE(ENTRY(iLoop,cDataSource)).
    IF VALID-HANDLE(hDataSource) THEN DO:
      /* Determine where we are */
      ASSIGN cLevel = DYNAMIC-FUNCTION("getSDOLevel":U IN hDataSource) NO-ERROR.
      IF cLevel = "":U THEN
        cLevel = "SmartObject".
      IF cLevel = "Page":U THEN
        RUN disableField IN h_PageObj.
    END.
  END.
    

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

