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
       {"af/obj2/gsmssfullo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/* Copyright (C) 2000,2007 by Progress Software Corporation. All rights
   reserved. Prior versions of this work may contain portions
   contributed by participants of Possenet. */
/*---------------------------------------------------------------------------------
  File: gsmssviewv.w

  Description:  Security Structure SmartDataViewer

  Purpose:      SmartDataViewer for maintaining gsm_security_structure for ranges, tokens
                and fields.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000018   UserRef:    posse
                Date:   14/03/2001  Author:     Tammy St Pierre

  Update Notes: Created from Template rysttviewv.w
      
  (v:010001)    Task:               UserRef:    
                Date:   10/15/2001  Author:     Mark Davies (MIP)

  Update Notes: Changed lookup fields to use new Parent Fields and 
                Parent Filter Query properties rather than setting
                the lookup queries manually.
      

  (v:010002)    Task:           0   UserRef:    
                Date:   03/07/2002  Author:     Mark Davies (MIP)

  Update Notes: Fix for issue #3843 - Field security lookups function wrong.
                This was due to the container mode not be correct for the structure viewer.

  (v:010003)    Task:           0   UserRef:    
                Date:   04/12/2002  Author:     Mark Davies (MIP)

  Update Notes: Fixed issue #4316 - Token/Field/Range Security maint Errors

------------------------------------------------------------------------------*/
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

&scop object-name       gsmssviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}

DEFINE VARIABLE gcUIBMode                  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE gcObjectQueryString        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE gcProductModuleCode        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE gdProductModuleObj         AS DECIMAL      NO-UNDO.
DEFINE VARIABLE gcContainerMode            AS CHARACTER    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "af/obj2/gsmssfullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.disabled 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define DISPLAYED-FIELDS RowObject.disabled 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject


/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_attribute AS HANDLE NO-UNDO.
DEFINE VARIABLE h_object AS HANDLE NO-UNDO.
DEFINE VARIABLE h_product_module AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.disabled AT ROW 4.1 COL 28
          LABEL "Disabled"
          VIEW-AS TOGGLE-BOX
          SIZE 13.2 BY .81
     SPACE(44.20) SKIP(0.00)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gsmssfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gsmssfullo.i}
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
         HEIGHT             = 3.95
         WIDTH              = 85.
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

/* SETTINGS FOR TOGGLE-BOX RowObject.disabled IN FRAME frMain
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME frMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frMain vTableWin
ON MOUSE-SELECT-DBLCLICK OF FRAME frMain
DO:
  MESSAGE DYNAMIC-FUNCTION("getDataValue" IN h_product_module) " - " gdProductModuleObj.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord vTableWin 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer  AS HANDLE     NO-UNDO.

  RUN SUPER.
  
  {get containerSource hContainer}.
  
  IF VALID-HANDLE(hContainer) THEN
    {set ContainerMode 'Add' hContainer}.
  
  gcContainerMode = "Add":U.

  /* When a new gsm_security_structure record is being added, the object and *
   * attribute lookups need to be disabled until a product module code is    *
   * entered.                                                                */
  RUN disableField IN h_object.
  RUN disableField IN h_attribute.

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
             INPUT  'DisplayedFieldgsc_product_module.product_module_codeKeyFieldgsc_product_module.product_module_objFieldLabelProduct moduleFieldTooltipPress F4 for Product Module LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_product_module NO-LOCK
                     BY gsc_product_module.product_module_codeQueryTablesgsc_product_moduleBrowseFieldsgsc_product_module.product_module_code,gsc_product_module.product_module_descriptionBrowseFieldDataTypescharacter,characterBrowseFieldFormatsX(35)|X(35)RowsToBatch200BrowseTitleLookup Product ModulesViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListNO-LOCKQueryBuilderOrderListgsc_product_module.product_module_code^yesQueryBuilderTableOptionListNO-LOCKQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoFieldNameproduct_module_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_product_module ).
       RUN repositionObject IN h_product_module ( 1.10 , 28.00 ) NO-ERROR.
       RUN resizeObject IN h_product_module ( 1.00 , 57.40 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.smartobject_objFieldLabelObject filenameFieldTooltipPress F4 for Object LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_smartobject NO-LOCK,
                     EACH gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     BY ryc_smartobject.object_filenameQueryTablesryc_smartobject,gsc_product_moduleBrowseFieldsryc_smartobject.object_filename,ryc_smartobject.object_description,gsc_product_module.product_module_codeBrowseFieldDataTypescharacter,character,characterBrowseFieldFormatsX(70)|X(35)|X(35)RowsToBatch200BrowseTitleLookup ObjectsViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldproduct_module_objParentFilterQueryryc_smartobject.product_module_obj = DECIMAL(~'&1~')MaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoFieldNameobject_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_object ).
       RUN repositionObject IN h_object ( 2.10 , 28.00 ) NO-ERROR.
       RUN resizeObject IN h_object ( 1.00 , 57.40 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_instance_attribute.attribute_codeKeyFieldgsc_instance_attribute.instance_attribute_objFieldLabelAttribute codeFieldTooltipPress F4 for Instance Attribute LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_instance_attribute NO-LOCK
                     WHERE gsc_instance_attribute.attribute_type = "MEN"
                     BY gsc_instance_attribute.attribute_codeQueryTablesgsc_instance_attributeBrowseFieldsgsc_instance_attribute.attribute_code,gsc_instance_attribute.attribute_descriptionBrowseFieldDataTypescharacter,characterBrowseFieldFormatsX(35)|X(500)RowsToBatch200BrowseTitleLookup Instance AttributesViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoFieldNameinstance_attribute_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_attribute ).
       RUN repositionObject IN h_attribute ( 3.10 , 28.00 ) NO-ERROR.
       RUN resizeObject IN h_attribute ( 1.00 , 57.40 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_product_module ,
             RowObject.disabled:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( h_object ,
             h_product_module , 'AFTER':U ).
       RUN adjustTabOrder ( h_attribute ,
             h_object , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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

  DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO.


  RUN SUPER.
  {get containerSource hContainer}.
  IF VALID-HANDLE(hContainer) THEN
    {set ContainerMode 'Copy' hContainer}.
  
  gcContainerMode = "Copy":U.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dispAllInCombos vTableWin 
PROCEDURE dispAllInCombos :
/*------------------------------------------------------------------------------
  Purpose:     We'll check the 3 combos, if any of their values are 0, set their display value to <All>
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dValue          AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hLookupFillIn   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hLoopLookup         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCnt            AS INTEGER    NO-UNDO.

  DO iCnt = 1 TO 3:

      CASE iCnt:
          WHEN 1 THEN ASSIGN hLoopLookup = h_product_module.
          WHEN 2 THEN ASSIGN hLoopLookup = h_object.
          WHEN 3 THEN ASSIGN hLoopLookup = h_attribute.
      END CASE.

      {get dataValue dValue hLoopLookup}.

      IF dValue = 0 
      THEN DO:
          {get lookupHandle hLookupFillIn hLoopLookup}.
          ASSIGN hLookupFillIn:SCREEN-VALUE = "<All>".

          /* If the user is in the lookup, select <All>, so he can just start typing without having to delete the <All> first */
          IF SELF = hLookupFillIn THEN
              hLookupFillIn:SET-SELECTION(1,6).
      END.
  END.

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
DEFINE VARIABLE dProductModuleObj   AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dObjectObj          AS DECIMAL      NO-UNDO.

  RUN SUPER.

  /* The object and attribute lookups need to be disabled if the product module
     obj is zero. */
  dProductModuleObj = DECIMAL(DYNAMIC-FUNCTION('getKeyFieldValue':U IN h_product_module)).
  IF dProductModuleObj = 0 
  THEN DO:
      RUN disableField IN h_object.
      RUN disableField IN h_attribute.
  END.  /* if dProductModuleObj = 0 */

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
  DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  {get UIBMode gcUIBMode}.   

  /* Subscribe to lookup events */
  IF NOT (gcUIBMode BEGINS "DESIGN":U) 
  THEN DO: 
      SUBSCRIBE TO "lookupComplete":U        IN THIS-PROCEDURE.
      SUBSCRIBE TO "lookupDisplayComplete":U IN THIS-PROCEDURE.
      SUBSCRIBE TO "lookupEntry":U           IN THIS-PROCEDURE.
      SUBSCRIBE TO "initializeBrowse":U      IN THIS-PROCEDURE.
  END.

  {get containerSource hContainer}.
  /* Default Container mode to MODIFY since it will 
     always be created with the <All> record #3843 */
  {set ContainerMode 'Modify' hContainer}.

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lookupComplete vTableWin 
PROCEDURE lookupComplete :
/*------------------------------------------------------------------------------
  Purpose:     Lookup complete hook 
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

DEFINE VARIABLE hLookup         AS HANDLE       NO-UNDO.
DEFINE VARIABLE hLookupField    AS HANDLE       NO-UNDO.
DEFINE VARIABLE iEntry          AS INTEGER      NO-UNDO.

  /* The object and attribute lookups need to have their values removed 
     if the product module obj is zero. */
  IF phObject = h_product_module THEN
  DO:
    ASSIGN gdProductModuleObj = DECIMAL(pcKeyFieldValue) NO-ERROR.
    ASSIGN gcProductModuleCode = pcDisplayedFieldValue.
    IF gdProductModuleObj = 0 THEN
    DO:
      hLookupField = DYNAMIC-FUNCTION('getLookupHandle':U IN h_object).
      ASSIGN hLookupField:SCREEN-VALUE = "":U.
      DYNAMIC-FUNCTION('setKeyFieldValue':U IN h_object, INPUT "0":U).
      DYNAMIC-FUNCTION('setDataModified':U IN h_object, INPUT TRUE).
      hLookupField = DYNAMIC-FUNCTION('getLookupHandle':U IN h_attribute).
      ASSIGN hLookupField:SCREEN-VALUE = "":U.
      DYNAMIC-FUNCTION('setKeyFieldValue':U IN h_attribute, INPUT "0":U).
      DYNAMIC-FUNCTION('setDataModified':U IN h_attribute, INPUT TRUE).
    END.  /* if gdProductModuleObj = 0 */
  END.  /* if h_product_module */

  /* The attribute lookup needs to have its value removed if the object 
     obj has no value. */
  IF phObject = h_object THEN
  DO:
    IF pcKeyFieldValue = "":U THEN
    DO:
      hLookupField = DYNAMIC-FUNCTION('getLookupHandle':U IN h_attribute).
      ASSIGN hLookupField:SCREEN-VALUE = "":U.
      DYNAMIC-FUNCTION('setKeyFieldValue':U IN h_attribute, INPUT "0":U).
      DYNAMIC-FUNCTION('setDataModified':U IN h_attribute, INPUT TRUE).
    END.  /* if pcKeyFieldValue blank */
  END.  /* if h_object */

  RUN dispAllInCombos.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lookupDisplayComplete vTableWin 
PROCEDURE lookupDisplayComplete :
/*------------------------------------------------------------------------------
  Purpose:     Lookup display complete hook 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcFieldNames     AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcFieldValues    AS CHARACTER  NO-UNDO.  
DEFINE INPUT PARAMETER pcKeyFieldValue  AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER phLookup         AS HANDLE     NO-UNDO.

DEFINE VARIABLE hLookup         AS HANDLE       NO-UNDO.
DEFINE VARIABLE hLookupField    AS HANDLE       NO-UNDO.
DEFINE VARIABLE iEntry          AS INTEGER      NO-UNDO.
DEFINE VARIABLE lEnabled        AS LOGICAL      NO-UNDO.

/* The object lookup needs to be enabled when the product module obj has   *
 * a value and the object and attribute lookups need to be disabled if the *
 * product module obj is zero.  The BaseQuerySring also needs to be set    *
 * for the object lookup.                                                  */

lEnabled = DYNAMIC-FUNCTION('getFieldEnabled':U IN h_product_module).

IF phLookup = h_product_module 
THEN DO:
    ASSIGN gdProductModuleObj = DECIMAL(pcKeyFieldValue) NO-ERROR.

    IF lEnabled 
    THEN DO:
        IF gdProductModuleObj > 0 THEN
            RUN enableField IN h_object.
        ELSE DO:
            RUN disableField IN h_object.
            RUN disableField IN h_attribute.
        END.  /* else do */
    END.  /* if lEnabled */

    ASSIGN iEntry = LOOKUP("gsc_product_module.product_module_code":U, pcFieldNames).

    IF iEntry > 0 AND gdProductModuleObj > 0 THEN
        ASSIGN gcProductModuleCode = ENTRY(iEntry, pcFieldValues, CHR(1)).
    ELSE
        ASSIGN gcProductModuleCode = "":U.
END.  /* if h_product_module */

/* The attribute lookup needs to be enabled when the object obj has a *
* value and the attribute lookup needs to be disabled if the object  *
* obj has not value.                                                 */

IF phLookup = h_object 
THEN DO:
    ASSIGN iEntry = LOOKUP("ryc_smartobject.object_filename":U, pcFieldNames).
    IF iEntry > 0 AND lEnabled 
    THEN DO:
        IF pcKeyFieldValue = "":U THEN
            RUN disableField IN h_attribute.
        ELSE 
            RUN enableField IN h_attribute.
    END.  /* if iEntry > 0 */
END.  /* if h_object */

RUN dispAllInCombos.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lookupEntry vTableWin 
PROCEDURE lookupEntry :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcScreenValue            AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER phLookup                 AS HANDLE       NO-UNDO. 

DEFINE VARIABLE hContainer    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hLookupFillIn AS HANDLE     NO-UNDO.

  {get containerSource hContainer}.
  {set ContainerMode gcContainerMode hContainer}.

  /* If the user is in a lookup with screen value <All>, select the whole string, *
   * so he can just start typing, instead of having to delete the <All> first.    */

  {get lookupHandle hLookupFillIn phLookup}.

  IF hLookupFillIn:SCREEN-VALUE = "<All>":U THEN
      hLookupFillIn:SET-SELECTION(1,6).

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
  DEFINE VARIABLE hLoopLookup   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hLookupFillIn AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCnt          AS INTEGER    NO-UNDO.

  /* Make sure the LEAVE trigger has fired if we're in a lookup */

  IF VALID-HANDLE(SELF) THEN
      APPLY "VALUE-CHANGED":U TO SELF.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  DEFINE VARIABLE hDataSource AS HANDLE     NO-UNDO.

  {get DataSource hDataSource}.
  IF VALID-HANDLE(hDataSource) THEN
      RUN refreshRow IN hDataSource.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateState vTableWin 
PROCEDURE updateState :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO.
  
  {get containerSource hContainer}.
  
  /* Code placed here will execute PRIOR to standard behavior. */

  IF pcState = "UpdateComplete" THEN
    gcContainerMode = "Modify":U.
      {set ContainerMode gcContainerMode hContainer}.
    
  RUN SUPER( INPUT pcState).

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

