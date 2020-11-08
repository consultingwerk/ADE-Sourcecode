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
       {"af/obj2/gsmitfullo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afgsmitview.w

  Description:  Menu Structure Item viewer

  Purpose:      used to build items per menu band

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   08/23/2001  Author:     Donald Bulua

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

&scop object-name       gsmitview.w
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
&Scoped-define DATA-FIELD-DEFS "af/obj2/gsmitfullo.i"

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.menu_item_sequence 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS RECT-1 
&Scoped-Define DISPLAYED-FIELDS RowObject.menu_item_sequence ~
RowObject.menu_structure_item_obj RowObject.item_control_type 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS fiBand fibanddesc fiItemLabel fiItemDesc ~
fitype fisubBand fiBandItemsLabel fiModule 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_dynlookup-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dynlookup-3 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiBand AS CHARACTER FORMAT "X(256)":U 
     LABEL "Band code" 
     VIEW-AS FILL-IN 
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE fibanddesc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiBandItemsLabel AS CHARACTER FORMAT "X(20)":U INITIAL "Band Items" 
      VIEW-AS TEXT 
     SIZE 10.6 BY .62 NO-UNDO.

DEFINE VARIABLE fiItemDesc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item description" 
     VIEW-AS FILL-IN 
     SIZE 39 BY 1 NO-UNDO.

DEFINE VARIABLE fiItemLabel AS CHARACTER FORMAT "X(256)":U 
     LABEL "Label" 
     VIEW-AS FILL-IN 
     SIZE 30 BY 1 NO-UNDO.

DEFINE VARIABLE fiModule AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .62 NO-UNDO.

DEFINE VARIABLE fisubBand AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 77 BY 1 NO-UNDO.

DEFINE VARIABLE fitype AS CHARACTER FORMAT "X(256)":U 
     LABEL "Type" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 104 BY 7.62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiBand AT ROW 1.71 COL 20.4 COLON-ALIGNED
     fibanddesc AT ROW 1.71 COL 43.4 COLON-ALIGNED NO-LABEL
     fiItemLabel AT ROW 2.81 COL 68.8 COLON-ALIGNED
     fiItemDesc AT ROW 3.91 COL 20.4 COLON-ALIGNED
     fitype AT ROW 3.91 COL 68.8 COLON-ALIGNED
     RowObject.menu_item_sequence AT ROW 5 COL 20.4 COLON-ALIGNED
          LABEL "Item sequence"
          VIEW-AS FILL-IN 
          SIZE 8 BY 1
     fisubBand AT ROW 7.24 COL 20.4 COLON-ALIGNED NO-LABEL
     fiBandItemsLabel AT ROW 1.1 COL 3.6 NO-LABEL
     RowObject.menu_structure_item_obj AT ROW 4.57 COL 89 COLON-ALIGNED NO-LABEL
           VIEW-AS TEXT 
          SIZE 10 BY .62
     fiModule AT ROW 5.29 COL 87.8 COLON-ALIGNED NO-LABEL BLANK 
     RowObject.item_control_type AT ROW 5.95 COL 87.8 COLON-ALIGNED NO-LABEL
           VIEW-AS TEXT 
          SIZE 14 BY .62
     RECT-1 AT ROW 1.38 COL 1.6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gsmitfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gsmitfullo.i}
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
         HEIGHT             = 8.48
         WIDTH              = 105.2.
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

/* SETTINGS FOR FILL-IN fiBand IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fibanddesc IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiBandItemsLabel IN FRAME frMain
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       fiBandItemsLabel:PRIVATE-DATA IN FRAME frMain     = 
                "Band Items".

/* SETTINGS FOR FILL-IN fiItemDesc IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiItemLabel IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiModule IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiModule:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN fisubBand IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fitype IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN RowObject.item_control_type IN FRAME frMain
   NO-ENABLE EXP-LABEL                                                  */
ASSIGN 
       RowObject.item_control_type:HIDDEN IN FRAME frMain           = TRUE
       RowObject.item_control_type:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN RowObject.menu_item_sequence IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.menu_structure_item_obj IN FRAME frMain
   NO-ENABLE EXP-LABEL                                                  */
ASSIGN 
       RowObject.menu_structure_item_obj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.menu_structure_item_obj:READ-ONLY IN FRAME frMain        = TRUE.

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
  DEFINE VARIABLE hSource    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSeq       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSeq       AS INTEGER    NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  
  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  {get ContainerSource hSource}.
  IF VALID-HANDLE(hSource) THEN 
  DO WITH FRAME {&FRAME-NAME}:
    IF LOOKUP("getSequence":U,hSource:INTERNAL-ENTRIES) > 0 THEN
    DO:
      cSeq = DYNAMIC-FUNCTION("getSequence":U IN hSource).
      IF cSeq = "" OR cSeq = ? THEN
         cSeq = "0".
      ASSIGN iseq           = INT(cSeq)
             iSeq           = iSeq + 1
             RowObject.MENU_item_sequence:SCREEN-VALUE = STRING(iseq)
             NO-ERROR.
    END.
  END.
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
             INPUT  'DisplayedFieldgsm_menu_item.menu_item_referenceKeyFieldgsm_menu_item.menu_item_objFieldLabelItem referenceFieldTooltipPress F4 for LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(15)DisplayDatatypecharacterBaseQueryStringfor each gsm_menu_item NO-LOCK,
                     each gsc_product_module of gsm_menu_item OUTER-JOIN
                     by menu_item_referenceQueryTablesgsm_menu_item,gsc_product_moduleBrowseFieldsgsm_menu_item.menu_item_reference,gsm_menu_item.menu_item_label,gsm_menu_item.item_control_type,gsm_menu_item.menu_item_description,gsc_product_module.product_module_codeBrowseFieldDataTypescharacter,character,character,character,characterBrowseFieldFormatsX(15)|X(28)|X(15)|X(35)|X(35)RowsToBatch200BrowseTitleLookupViewerLinkedFieldsgsm_menu_item.menu_item_label,gsm_menu_item.item_control_type,gsm_menu_item.menu_item_descriptionLinkedFieldDataTypescharacter,character,characterLinkedFieldFormatsX(28),X(15),X(35)ViewerLinkedWidgetsfiItemLabel,fitype,fiitemDescColumnLabels,,,,Product moduleColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNamemenu_item_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup-2 ).
       RUN repositionObject IN h_dynlookup-2 ( 2.81 , 22.40 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup-2 ( 1.00 , 38.60 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsm_menu_structure.menu_structure_codeKeyFieldgsm_menu_structure.menu_structure_objFieldLabelSubmenu/subbandFieldTooltipPress F4 for LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(28)DisplayDatatypecharacterBaseQueryStringFOR each gsm_menu_structure ,
                     FIRST gsc_product_module OUTER-JOIN
                     where gsm_menu_structure.product_module_obj = gsc_product_module .product_module_obj
                     by menu_structure_codeQueryTablesgsm_menu_structure,gsc_product_moduleBrowseFieldsgsm_menu_structure.menu_structure_code,gsm_menu_structure.menu_structure_description,gsc_product_module.product_module_codeBrowseFieldDataTypescharacter,character,characterBrowseFieldFormatsX(28)|X(35)|X(35)RowsToBatch200BrowseTitleSubmenu LookupViewerLinkedFieldsgsm_menu_structure.menu_structure_descriptionLinkedFieldDataTypescharacterLinkedFieldFormatsX(35)ViewerLinkedWidgetsfiSubBandColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNamechild_menu_structure_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup-3 ).
       RUN repositionObject IN h_dynlookup-3 ( 6.10 , 22.40 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup-3 ( 1.00 , 39.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_dynlookup-2 ,
             fibanddesc:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_dynlookup-3 ,
             RowObject.menu_item_sequence:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRecord vTableWin 
PROCEDURE cancelRecord :
/*------------------------------------------------------------------------------
  Purpose:    If Add or Copy action is cancelled, it may be that the selected tree 
              is not in synch with the current record. This happens if the user 
              selected to add a record from the popup menus
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cNew    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hSource AS HANDLE     NO-UNDO.
DEFINE VARIABLE cKey    AS CHARACTER  NO-UNDO.


  /* Code placed here will execute PRIOR to standard behavior. */
 {get NewRecord cNew}.
  RUN SUPER.
  IF cNew = "Add":U OR cNew = "Copy":U THEN DO:
    {get ContainerSource hSource}.
    IF VALID-HANDLE(hSource) THEN
       RUN treeSynch IN hSource ("BandItem":U) NO-ERROR.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteComplete vTableWin 
PROCEDURE deleteComplete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hSource AS HANDLE     NO-UNDO.

{get ContainerSource hSource}.

IF VALID-HANDLE(hSource) THEN
    RUN deleteNode IN hSource ("Banditem":U,NO).

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

  DEFINE VARIABLE hSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSDO    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cCols   AS CHARACTER  NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcColValues).

  /* Code placed here will execute AFTER standard behavior.    */
  
  /* Get the band code info from the gsmmsfullo SDO */
  hSource = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U ,"Data-Source":U)) NO-ERROR.
  IF VALID-HANDLE(hSource) THEN
    hSDO = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U IN hSource ,"Data-Source":U)) NO-ERROR.
  IF VALID-HANDLE(hSDO) THEN
     cCols     = DYNAMIC-FUNC("colValues" IN hSDO,"MENU_structure_code,MENU_structure_description,menu_structure_obj":U).
  IF NUM-ENTRIES(cCols,CHR(1)) > 2 THEN
      ASSIGN fiBand:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(2,cCols,CHR(1) )
             fiBand:PRIVATE-DATA                        = ENTRY(4,cCols,CHR(1) )
             fiBandDesc:SCREEN-VALUE  = ENTRY(3,cCols,CHR(1)).
  
  /* If band item is not of type label, disable the child subband field. Only a label
     can have a submenu*/
  IF RowObject.item_control_type:SCREEN-VALUE <> "Label":U THEN
      RUN disableField IN h_dynlookup-3 NO-ERROR.
  ELSE 
     RUN enableField IN h_dynlookup-3 NO-ERROR.
 
  {get ContainerSource hSource}.
  IF LOOKUP("getModuleObj":U,hSource:INTERNAL-ENTRIES) > 0 THEN
     fiModule:SCREEN-VALUE IN FRAME {&FRAME-NAME} = DYNAMIC-FUNC("getModuleObj":U IN hSource).

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
  IF RowObject.item_control_type:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "Label":U THEN
      RUN disableField IN h_dynlookup-3.
  ELSE 
     RUN enableField IN h_dynlookup-3.
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
  SUBSCRIBE TO 'lookupComplete' IN THIS-PROCEDURE.
  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

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

/*------------------------------------------------------------------------------
  Purpose:     Get the default link from the category table
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcnames    AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcValues   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcNewKey   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcNewValue AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcOldValue AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plWhere    AS LOGICAL    NO-UNDO.
DEFINE INPUT  PARAMETER pHandle    AS HANDLE     NO-UNDO.

DEFINE VARIABLE cCols AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iObj  AS INTEGER    NO-UNDO.


IF fiType:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "LABEL":U THEN
  RUN enableField IN h_dynlookup-3.
ELSE
  RUN disableField IN h_dynlookup-3.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord vTableWin 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Append Source or Target value to the item field
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cNew           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSource        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cKeyFieldItem  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFieldChild AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReference     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hLookup        AS HANDLE     NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */
 
 {get NewRecord cNew}.
  RUN SUPER.
  /* If sucessfull, add node if adding */
  IF RETURN-VALUE <> "ADM-ERROR":U THEN 
  DO:
    {get DataValue cKeyFieldItem h_dynlookup-2}.
    {get LookupHandle hLookup h_dynlookup-2}.
    cReference = hLookup:SCREEN-VALUE NO-ERROR.
    IF cKeyFielditem = "" OR cKeyFieldItem = ? THEN cKeyFieldItem = "0".
    {get DataValue cKeyFieldChild h_dynlookup-3}.
    IF cKeyFieldChild = "" OR cKeyFieldChild = ? THEN cKeyFieldChild = "0".
    {get ContainerSource hSource}.
    IF cNew = "Add":U OR cNew = "Copy":U AND VALID-HANDLE(hSource) THEN 
    DO WITH FRAME {&FRAME-NAME}:
       cLabel = DYNAMIC-FUNC("getItemLabel":U IN hSource,fiItemLabel:SCREEN-VALUE, cReference, fiItemDesc:SCREEN-VALUE,fiType:SCREEN-VALUE).
       
       RUN addNode IN hSource (INPUT "BandItem":U,
                               INPUT cLabel ,
                               INPUT RowObject.menu_structure_item_obj:SCREEN-VALUE + "|" + fiBand:PRIVATE-DATA + "|" 
                               + RowObject.MENU_item_sequence:SCREEN-VALUE + "|" + rowobject.item_control_type:SCREEN-VALUE + "|" 
                               + ckeyFieldChild + "|" + cKeyFieldItem).
        
    END.
    ELSE IF  VALID-HANDLE(hSource)  THEN
      RUN updateNode IN hSOurce("BandItem","",rowObject.MENU_item_sequence:SCREEN-VALUE).
  END.

  /* Code placed here will execute AFTER standard behavior.    */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

