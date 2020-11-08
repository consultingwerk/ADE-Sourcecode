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
       {"af/obj2/gscsqfullo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/* Copyright (C) 2005,2007 by Progress Software Corporation. All rights
   reserved.  Prior versions of this work may contain portions
   contributed by participants of Possenet. */
/*---------------------------------------------------------------------------------
  File: gscsqviewv.w

  Description:  Sequence SmartDataViewer

  Purpose:      Sequence Static SmartDataViewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000044   UserRef:    posse
                Date:   28/03/2001  Author:     Tammy St Pierre

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

&scop object-name       gscsqviewv.w
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
&Scoped-define DATA-FIELD-DEFS "af/obj2/gscsqfullo.i"

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.sequence_short_desc ~
RowObject.sequence_description RowObject.sequence_tla RowObject.min_value ~
RowObject.max_value RowObject.sequence_format RowObject.next_value ~
RowObject.number_of_sequences RowObject.sequence_active ~
RowObject.auto_generate RowObject.multi_transaction 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define DISPLAYED-FIELDS RowObject.sequence_short_desc ~
RowObject.sequence_description RowObject.sequence_tla RowObject.min_value ~
RowObject.max_value RowObject.sequence_format RowObject.next_value ~
RowObject.number_of_sequences RowObject.sequence_active ~
RowObject.auto_generate RowObject.multi_transaction 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS fiEntityMnemonic 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_dyncombo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dynlookup-2 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiEntityMnemonic AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.sequence_short_desc AT ROW 1 COL 31.8 COLON-ALIGNED
          LABEL "Sequence short desc."
          VIEW-AS FILL-IN 
          SIZE 34.8 BY 1
     RowObject.sequence_description AT ROW 2.1 COL 31.8 COLON-ALIGNED
          LABEL "Sequence description"
          VIEW-AS FILL-IN 
          SIZE 74.8 BY 1
     fiEntityMnemonic AT ROW 4.29 COL 83 COLON-ALIGNED NO-LABEL
     RowObject.sequence_tla AT ROW 5.38 COL 31.8 COLON-ALIGNED
          LABEL "Sequence TLA"
          VIEW-AS FILL-IN 
          SIZE 8.6 BY 1
     RowObject.min_value AT ROW 6.48 COL 31.8 COLON-ALIGNED
          LABEL "Min. value"
          VIEW-AS FILL-IN 
          SIZE 14.6 BY 1
     RowObject.max_value AT ROW 7.57 COL 31.8 COLON-ALIGNED
          LABEL "Max. value"
          VIEW-AS FILL-IN 
          SIZE 14.6 BY 1
     RowObject.sequence_format AT ROW 8.67 COL 31.8 COLON-ALIGNED
          LABEL "Sequence format"
          VIEW-AS FILL-IN 
          SIZE 74.8 BY 1
     RowObject.next_value AT ROW 9.76 COL 31.8 COLON-ALIGNED
          LABEL "Next value"
          VIEW-AS FILL-IN 
          SIZE 14.6 BY 1
     RowObject.number_of_sequences AT ROW 10.86 COL 31.8 COLON-ALIGNED
          LABEL "Number of sequences"
          VIEW-AS FILL-IN 
          SIZE 11.8 BY 1
     RowObject.sequence_active AT ROW 11.91 COL 33.8
          LABEL "Sequence active"
          VIEW-AS TOGGLE-BOX
          SIZE 21.4 BY 1
     RowObject.auto_generate AT ROW 12.95 COL 33.8
          LABEL "Auto generate"
          VIEW-AS TOGGLE-BOX
          SIZE 18.8 BY 1
     RowObject.multi_transaction AT ROW 14 COL 33.8
          LABEL "Multi transaction"
          VIEW-AS TOGGLE-BOX
          SIZE 21.2 BY 1
     SPACE(28.80) SKIP(0.00)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gscsqfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gscsqfullo.i}
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
         HEIGHT             = 14.24
         WIDTH              = 126.
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

/* SETTINGS FOR TOGGLE-BOX RowObject.auto_generate IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN fiEntityMnemonic IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN RowObject.max_value IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.min_value IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.multi_transaction IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.next_value IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.number_of_sequences IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.sequence_active IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.sequence_description IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.sequence_format IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.sequence_short_desc IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.sequence_tla IN FRAME frMain
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

&Scoped-define SELF-NAME RowObject.multi_transaction
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.multi_transaction vTableWin
ON VALUE-CHANGED OF RowObject.multi_transaction IN FRAME frMain /* Multi transaction */
DO:
  /* The value of multi_transaction determines whether number_of_sequences 
     is enabled.  */
  IF SELF:SCREEN-VALUE = 'yes':U THEN
    RowObject.number_of_sequences:SENSITIVE = TRUE.
  ELSE RowObject.number_of_sequences:SENSITIVE = FALSE.
  DYNAMIC-FUNCTION('setDataModified':U, INPUT TRUE).
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
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsm_login_company.login_company_short_name,gsm_login_company.login_company_codeKeyFieldgsm_login_company.login_company_objFieldLabelLogin companyFieldTooltipSelect a login company from the listKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH gsm_login_company NO-LOCK BY gsm_login_company.login_company_codeQueryTablesgsm_login_companySDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1 (&2)ComboDelimiterListItemPairsInnerLines5SortnoComboFlagAFlagValue0BuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesUseCacheyesSuperProcedureDataSourceNameFieldNamecompany_organisation_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dyncombo ).
       RUN repositionObject IN h_dyncombo ( 3.19 , 33.80 ) NO-ERROR.
       RUN resizeObject IN h_dyncombo ( 1.05 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_entity_mnemonic.entity_mnemonicKeyFieldgsc_entity_mnemonic.entity_mnemonicFieldLabelEntityFieldTooltipEnter an Entity Mnemonic or press F4 for LookupKeyFormatX(8)KeyDatatypecharacterDisplayFormatX(8)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_entity_mnemonic NO-LOCK BY gsc_entity_mnemonic.entity_mnemonicQueryTablesgsc_entity_mnemonicBrowseFieldsgsc_entity_mnemonic.entity_mnemonic,gsc_entity_mnemonic.entity_mnemonic_descriptionBrowseFieldDataTypescharacter,characterBrowseFieldFormatsX(8),X(35)RowsToBatch200BrowseTitleLookup Entity MnemonicViewerLinkedFieldsgsc_entity_mnemonic.entity_mnemonic_descriptionLinkedFieldDataTypescharacterLinkedFieldFormatsX(35)ViewerLinkedWidgetsfiEntityMnemonicColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNameowning_entity_mnemonicDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup-2 ).
       RUN repositionObject IN h_dynlookup-2 ( 4.29 , 33.80 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup-2 ( 1.00 , 50.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_dyncombo ,
             RowObject.sequence_description:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_dynlookup-2 ,
             h_dyncombo , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFields vTableWin 
PROCEDURE displayFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcColValues AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cFieldHandles AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cMultiTrans   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE hFrameField   AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hNumSeq       AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hSeqShortDesc AS HANDLE       NO-UNDO.
  DEFINE VARIABLE iColCount     AS INTEGER      NO-UNDO.
  DEFINE VARIABLE iValue        AS INTEGER      NO-UNDO.

  RUN SUPER( INPUT pcColValues).

  /* Get the value of multi_transaction to determine whether 
     number_of_sequences should be enabled.  */
  {get FieldHandles cFieldHandles}.
  iColCount = NUM-ENTRIES(cFieldHandles).
  DO iValue = 1 TO iColCount:
    hFrameField = WIDGET-HANDLE(ENTRY(iValue,cFieldHandles)).
    IF hFrameField:TYPE NE 'PROCEDURE':U THEN
    DO:
      IF hFrameField:NAME = 'sequence_short_desc':U THEN
        ASSIGN hSeqShortDesc = hFrameField.
      IF hFrameField:NAME = 'multi_transaction':U THEN
        ASSIGN cMultiTrans = ENTRY(iValue + 1, pcColValues, CHR(1)).
      IF hFrameField:NAME = 'number_of_sequences':U THEN
        ASSIGN hNumSeq = hFrameField.
    END.  /* frame field ne procedure */
  END.  /* do iValue 1 to column count */

  IF hSeqShortDesc:SENSITIVE THEN
  DO:
    IF cMultiTrans = 'no':U THEN
      hNumSeq:SENSITIVE = FALSE.
    ELSE hNumSeq:SENSITIVE = TRUE.
  END.  /* if Seq Short Desc sensitive */

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
  DEFINE VARIABLE cFieldHandles AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cMultiTrans   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE hFrameField   AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hNumSeq       AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hSeqShortDesc AS HANDLE       NO-UNDO.
  DEFINE VARIABLE iColCount     AS INTEGER      NO-UNDO.
  DEFINE VARIABLE iValue        AS INTEGER      NO-UNDO.

  RUN SUPER.

  /* Get the value of multi_transaction to determine whether 
     number_of_sequences should be enabled.  */
  {get FieldHandles cFieldHandles}.
  iColCount = NUM-ENTRIES(cFieldHandles).
  DO iValue = 1 TO iColCount:
    hFrameField = WIDGET-HANDLE(ENTRY(iValue,cFieldHandles)).
    IF hFrameField:TYPE NE 'PROCEDURE':U THEN
    DO:
      IF hFrameField:NAME = 'sequence_short_desc':U THEN
        ASSIGN hSeqShortDesc = hFrameField.
      IF hFrameField:NAME = 'multi_transaction':U THEN
        ASSIGN cMultiTrans = hFrameField:SCREEN-VALUE.
      IF hFrameField:NAME = 'number_of_sequences':U THEN
        ASSIGN hNumSeq = hFrameField.
    END.  /* frame field ne procedure */
  END.  /* do iValue 1 to column count */

  IF VALID-HANDLE(hNumSeq) THEN DO:
    IF hSeqShortDesc:SENSITIVE THEN
    DO:
      IF cMultiTrans = 'no':U THEN
        hNumSeq:SENSITIVE = FALSE.
      ELSE hNumSeq:SENSITIVE = TRUE.
    END.  /* if Seq Short Desc sensitive */
  END.  /* if hNumSeq valid */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


