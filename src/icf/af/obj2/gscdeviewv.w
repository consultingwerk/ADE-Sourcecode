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
       {"af/obj2/gscdefullo.i"}.


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
  File: gscdeviewv.w

  Description:  Dataset Entity Static SmartDataViewer

  Purpose:      SmartDataViewer for maintaining gsc_dataset_entity records

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000085   UserRef:    posse
                Date:   27/04/2001  Author:     Tammy St Pierre

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

&scop object-name       gscdeviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}

DEFINE VARIABLE glAddRecord AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "af/obj2/gscdefullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.entity_sequence ~
RowObject.primary_entity RowObject.delete_related_records ~
RowObject.overwrite_records RowObject.keep_own_site_data ~
RowObject.deletion_action RowObject.join_field_list ~
RowObject.filter_where_clause 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS fiEntityDesc buValidate 
&Scoped-Define DISPLAYED-FIELDS RowObject.entity_sequence ~
RowObject.primary_entity RowObject.delete_related_records ~
RowObject.overwrite_records RowObject.keep_own_site_data ~
RowObject.deploy_dataset_obj RowObject.deletion_action ~
RowObject.join_field_list RowObject.filter_where_clause 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS fiEntityDesc fiJoinFieldListLabel ~
fiFilterWhereClauseLabel 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hJoinEntityMnemonic AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dynlookup AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buValidate 
     LABEL "Validate Dataset Query" 
     SIZE 95.6 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE fiEntityDesc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 70.4 BY 1.14 NO-UNDO.

DEFINE VARIABLE fiFilterWhereClauseLabel AS CHARACTER FORMAT "X(35)":U INITIAL "Filter Where Clause:" 
      VIEW-AS TEXT 
     SIZE 19.2 BY .62 NO-UNDO.

DEFINE VARIABLE fiJoinFieldListLabel AS CHARACTER FORMAT "X(35)":U INITIAL "Join Field List:" 
      VIEW-AS TEXT 
     SIZE 13.6 BY .62 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiEntityDesc AT ROW 1 COL 50.8 COLON-ALIGNED NO-LABEL
     RowObject.entity_sequence AT ROW 2.05 COL 25.6 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.6 BY 1
     RowObject.primary_entity AT ROW 3.14 COL 27.6
          VIEW-AS TOGGLE-BOX
          SIZE 17.6 BY 1
     RowObject.delete_related_records AT ROW 3.14 COL 45.8
          VIEW-AS TOGGLE-BOX
          SIZE 27.8 BY 1
     RowObject.overwrite_records AT ROW 3.14 COL 74.6
          VIEW-AS TOGGLE-BOX
          SIZE 22.6 BY 1
     RowObject.keep_own_site_data AT ROW 3.14 COL 97.8
          VIEW-AS TOGGLE-BOX
          SIZE 24.4 BY 1
     RowObject.deploy_dataset_obj AT ROW 3.57 COL 23.8 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE .8 BY .19
     RowObject.deletion_action AT ROW 4.19 COL 25.8 COLON-ALIGNED FORMAT "X(1)"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "<Not Used>","",
                     "None","N",
                     "Set Null","S",
                     "Cascade","C"
          DROP-DOWN-LIST
          SIZE 21.6 BY 1
     RowObject.join_field_list AT ROW 6.43 COL 27.6 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 95.2 BY 5.29
     RowObject.filter_where_clause AT ROW 11.91 COL 27.6 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 500 SCROLLBAR-VERTICAL
          SIZE 95.2 BY 4.62
     buValidate AT ROW 16.52 COL 27.6
     fiJoinFieldListLabel AT ROW 6.48 COL 11.8 COLON-ALIGNED NO-LABEL
     fiFilterWhereClauseLabel AT ROW 11.95 COL 5.8 COLON-ALIGNED NO-LABEL
     SPACE(96.00) SKIP(0.00)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gscdefullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gscdefullo.i}
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
         HEIGHT             = 16.95
         WIDTH              = 123.2.
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

/* SETTINGS FOR COMBO-BOX RowObject.deletion_action IN FRAME frMain
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN RowObject.deploy_dataset_obj IN FRAME frMain
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       RowObject.deploy_dataset_obj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.deploy_dataset_obj:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

/* SETTINGS FOR FILL-IN fiFilterWhereClauseLabel IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiFilterWhereClauseLabel:PRIVATE-DATA IN FRAME frMain     = 
                "Filter Where Clause:".

/* SETTINGS FOR FILL-IN fiJoinFieldListLabel IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiJoinFieldListLabel:PRIVATE-DATA IN FRAME frMain     = 
                "Join Field List:".

ASSIGN 
       RowObject.join_field_list:RETURN-INSERTED IN FRAME frMain  = TRUE.

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

&Scoped-define SELF-NAME buValidate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buValidate vTableWin
ON CHOOSE OF buValidate IN FRAME frMain /* Validate Dataset Query */
DO:
  DEFINE VARIABLE lValidQuery    AS LOGICAL      NO-UNDO.

  RUN validateQuery (OUTPUT lValidQuery).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.overwrite_records
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.overwrite_records vTableWin
ON VALUE-CHANGED OF RowObject.overwrite_records IN FRAME frMain /* Overwrite Records */
DO:
    IF SELF:CHECKED THEN
        ASSIGN rowObject.keep_own_site_data:SENSITIVE = YES.
    ELSE
        ASSIGN rowObject.keep_own_site_data:SENSITIVE = NO
               rowObject.keep_own_site_data:CHECKED   = NO
               .
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
  
  glAddRecord = TRUE.
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

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
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_entity_mnemonic.entity_mnemonicKeyFieldgsc_entity_mnemonic.entity_mnemonicFieldLabelEntityFieldTooltipEnter Entity Mnemonic or Press F4 for Entity Mnemonic LookupKeyFormatX(8)KeyDatatypecharacterDisplayFormatX(8)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_entity_mnemonic NO-LOCK
                     BY gsc_entity_mnemonic.entity_mnemonicQueryTablesgsc_entity_mnemonicBrowseFieldsgsc_entity_mnemonic.entity_mnemonic,gsc_entity_mnemonic.entity_mnemonic_short_desc,gsc_entity_mnemonic.entity_mnemonic_descriptionBrowseFieldDataTypescharacter,character,characterBrowseFieldFormatsX(8),X(35),X(35)RowsToBatch200BrowseTitleLookup Entity MnemonicsViewerLinkedFieldsgsc_entity_mnemonic.entity_mnemonic_descriptionLinkedFieldDataTypescharacterLinkedFieldFormatsX(35)ViewerLinkedWidgetsfiEntityDescColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcFieldNameentity_mnemonicDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup ).
       RUN repositionObject IN h_dynlookup ( 1.00 , 27.40 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup ( 1.00 , 24.80 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_entity_mnemonic.entity_mnemonic,gsc_entity_mnemonic.entity_mnemonic_descriptionKeyFieldgsc_dataset_entity.entity_mnemonicFieldLabelJoin Entity MnemonicFieldTooltipSelect option from listKeyFormatX(8)KeyDatatypecharacterDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH gsc_dataset_entity NO-LOCK, FIRST gsc_entity_mnemonic WHERE gsc_entity_mnemonic.entity_mnemonic = gsc_dataset_entity.entity_mnemonic BY gsc_dataset_entity.entity_sequenceQueryTablesgsc_dataset_entity,gsc_entity_mnemonicSDFFileNameSDFTemplateParentFielddeploy_dataset_objParentFilterQuerygsc_dataset_entity.deploy_dataset_obj = DECIMAL(~'&1~')DescSubstitute&1 / &2CurrentKeyValueComboDelimiterListItemPairsCurrentDescValueInnerLines5ComboFlagNFlagValue.BuildSequence1SecurednoCustomSuperProcFieldNamejoin_entity_mnemonicDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hJoinEntityMnemonic ).
       RUN repositionObject IN hJoinEntityMnemonic ( 5.33 , 27.80 ) NO-ERROR.
       RUN resizeObject IN hJoinEntityMnemonic ( 1.00 , 95.20 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_dynlookup ,
             fiEntityDesc:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( hJoinEntityMnemonic ,
             RowObject.deletion_action:HANDLE IN FRAME frMain , 'AFTER':U ).
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

  IF DYNAMIC-FUNCTION("getDataValue":U IN hJoinEntityMnemonic) = ".":U THEN
    DYNAMIC-FUNCTION("setDataValue":U IN hJoinEntityMnemonic, "":U).
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT-OUTPUT pcChanges, INPUT-OUTPUT pcInfo).
  
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
    DEFINE INPUT PARAMETER pcColValues      AS CHARACTER                NO-UNDO.

    DEFINE VARIABLE hDataSource AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cJoinEntity AS CHARACTER  NO-UNDO.

    RUN SUPER( INPUT pcColValues).

    APPLY "VALUE-CHANGED":U TO rowObject.overwrite_records IN FRAME {&FRAME-NAME}.
    {get DataSource hDataSource}.
    IF VALID-HANDLE(hDataSource) THEN DO:
      cJoinEntity = "":U.
      IF NOT glAddRecord THEN
        cJoinEntity = ENTRY(2,DYNAMIC-FUNCTION("ColValues":U IN hDataSource,"join_entity_mnemonic":U),CHR(1)).
      glAddRecord = FALSE.
      IF cJoinEntity = "":U THEN
        DYNAMIC-FUNCTION("setDataValue":U IN hJoinEntityMnemonic,".":U).
    END.
   RETURN.
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
  RUN "af\obj2\gscdeccsfv.w *RTB-SmObj* ".
  RUN "adm2\dynlookup.w *RTB-SmObj* ".

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
DEFINE VARIABLE cNewRecord     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cObj           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cOrgPrimary    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cPrimary       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cRowid         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cWhere         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hDataSource    AS HANDLE       NO-UNDO.
DEFINE VARIABLE lValidQuery    AS LOGICAL      NO-UNDO.

  RUN validateQuery (OUTPUT lValidQuery).
  IF NOT lvalidQuery THEN RETURN 'ADM-ERROR':U.

  cNewRecord  = DYNAMIC-FUNCTION('getNewRecord':U).
  hDataSource = DYNAMIC-FUNCTION('getDataSource':U).
  cOrgPrimary = DYNAMIC-FUNCTION('columnStringValue':U IN hDataSource,
                                 INPUT 'primary_entity':U).

  RUN SUPER.

  /* When a new dataset entity is create the combo needs to be rebuild to 
     include the new entity */
  IF LOOKUP(cNewRecord, 'Add,Copy':U) > 0 THEN
    RUN refreshChildDependancy IN hJoinEntityMnemonic ("deploy_dataset_obj").
  /*
    RUN rebuildCombo IN h_gscdeccsfv.
    */
  /* If the primary entity is being changed, or we have copied an entity and 
     primary entity is true, then we need to reopen the query
     because the setting of the primary entity in other records in the 
     dataset may have changed during validation in preTransactionValidate
     in the SDO  */
  cPrimary = DYNAMIC-FUNCTION('columnStringValue':U IN hDataSource,
                              INPUT 'primary_entity':U).

  IF (cOrgPrimary NE cPrimary) OR 
    (cNewRecord = 'Copy':U AND cPrimary = 'yes':U)
  THEN
  DO:
    cObj = DYNAMIC-FUNCTION('columnStringValue':U IN hDataSource,
                            INPUT 'dataset_entity_obj':U).
    cWhere = 'dataset_entity_obj = ':U + cObj.
    cRowid = DYNAMIC-FUNCTION('rowidWhere':U IN hDataSource, INPUT cWhere).
    DYNAMIC-FUNCTION('openQuery':U IN hDataSource).
    DYNAMIC-FUNCTION('fetchRowIdent':U IN hDataSource, 
                     INPUT cRowid, 
                     INPUT '':U).
  END.  /* if primary changed */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateQuery vTableWin 
PROCEDURE validateQuery :
/*------------------------------------------------------------------------------
  Purpose:     Invokes validateDatasetQuery to determine whether the current
               dataset query is valid.
  Parameters:  OUTPUT lValid AS LOGICAL - returns T or F indicating whether the
               query is valid
  Notes:       validateDatasetQuery is passed the current entity mnemonic, 
               join entity mnemonic, join field list, filter where clause and 
               primary entity
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER lValid AS LOGICAL NO-UNDO.

DEFINE VARIABLE cButton           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cEntityMnemonic   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cError            AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cJoinEntity       AS CHARACTER    NO-UNDO.

  ASSIGN 
    cEntityMnemonic = DYNAMIC-FUNCTION('getDataValue':U IN h_dynlookup)
    cJoinEntity = DYNAMIC-FUNCTION('getDataValue':U IN hJoinEntityMnemonic).
  
  IF cJoinEntity = ".":U THEN
    cJoinEntity = "":U.

  DO WITH FRAME {&FRAME-NAME}:      
    {af/sup2/afrun2.i &PLIP = 'af/app/gscddxmlp.p'
                      &IProc = 'validateDatasetQuery'
                      &OnApp = 'NO'
                      &PList =
    "(cEntityMnemonic,cJoinEntity,RowObject.join_field_list:SCREEN-VALUE,RowObject.filter_where_clause:SCREEN-VALUE,RowObject.primary_entity:CHECKED)"
                      &AutoKill = YES}
  END.  /* do with frame */

  cError = RETURN-VALUE.

  IF cError <> '':U  THEN
  DO:
    ASSIGN lValid = FALSE.
    RUN showMessages IN gshSessionManager (INPUT cError,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Validate Dataset Query",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).
  END.  /* if error */
  ELSE DO:
    ASSIGN lValid = TRUE. 
    /* Only show the success message if running this from the Validate
       Dataset Query button */
    IF PROGRAM-NAME(2) BEGINS 'USER-INTERFACE-TRIGGER':U THEN
    DO:
      cError = {af/sup2/aferrortxt.i 'AF' '108' '' '' "'query validation'"}.
      RUN showMessages IN gshSessionManager (INPUT cError,
                                             INPUT "MES":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Validate Dataset Query",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
    END.  /* if called from ui trigger */
  END.  /* else do */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

