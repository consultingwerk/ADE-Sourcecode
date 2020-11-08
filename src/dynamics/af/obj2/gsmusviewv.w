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
       {"af/obj2/gsmusfullo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/* Copyright (C) 2000,2007 by Progress Software Corporation. All rights
   reserved. Prior versions of this work may contain portions
   contributed by participants of Possenet.  */
/*---------------------------------------------------------------------------------
  File: gsmusviewv.w

  Description:  User Maintenance SmartDataViewer

  Purpose:      SmartDataViewer for general user maintenance

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000009   UserRef:    POSSE
                Date:   14/03/2001  Author:     Phillip Magnay

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

&scop object-name       gsmusviewv.w
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
&Scoped-define DATA-FIELD-DEFS "af/obj2/gsmusfullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.user_login_name RowObject.disabled ~
RowObject.user_full_name RowObject.profile_user RowObject.development_user ~
RowObject.maintain_system_data RowObject.user_password ~
RowObject.confirm_password RowObject.password_minimum_length ~
RowObject.password_preexpired RowObject.update_password_history ~
RowObject.check_password_history RowObject.password_expiry_date ~
RowObject.password_expiry_days RowObject.user_email_address ~
RowObject.external_userid 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS buBlank buBlank2 
&Scoped-Define DISPLAYED-FIELDS RowObject.user_login_name ~
RowObject.disabled RowObject.user_full_name RowObject.profile_user ~
RowObject.development_user RowObject.maintain_system_data ~
RowObject.user_creation_date RowObject.fmt_user_create_time ~
RowObject.user_password RowObject.confirm_password ~
RowObject.password_creation_date RowObject.fmt_password_create_time ~
RowObject.password_minimum_length RowObject.password_preexpired ~
RowObject.update_password_history RowObject.check_password_history ~
RowObject.password_expiry_date RowObject.fmt_password_expire_time ~
RowObject.password_expiry_days RowObject.last_login_date ~
RowObject.fmt_user_login_time RowObject.password_fail_date ~
RowObject.fmt_password_fail_time RowObject.password_fail_count ~
RowObject.user_email_address RowObject.external_userid 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS fiProfileUserName 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_dyncombo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dyncombo-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dynlookup AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dynlookup-2 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buBlank 
     LABEL "&Blank" 
     SIZE 12.8 BY .95
     BGCOLOR 8 .

DEFINE BUTTON buBlank2 
     LABEL "&Blank" 
     SIZE 12.8 BY .95
     BGCOLOR 8 .

DEFINE VARIABLE fiProfileUserName AS CHARACTER FORMAT "X(35)":U 
     VIEW-AS FILL-IN 
     SIZE 55.2 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.user_login_name AT ROW 1 COL 22.6 COLON-ALIGNED
          LABEL "User login name"
          VIEW-AS FILL-IN 
          SIZE 34.8 BY 1
     RowObject.disabled AT ROW 1 COL 66.2
          LABEL "Disabled"
          VIEW-AS TOGGLE-BOX
          SIZE 16 BY .81
     RowObject.user_full_name AT ROW 2.05 COL 22.6 COLON-ALIGNED
          LABEL "Full name"
          VIEW-AS FILL-IN 
          SIZE 78.4 BY 1
     RowObject.profile_user AT ROW 4.14 COL 24.6
          LABEL "Profile user"
          VIEW-AS TOGGLE-BOX
          SIZE 15.8 BY 1
     RowObject.development_user AT ROW 4.14 COL 56.2
          LABEL "Development user"
          VIEW-AS TOGGLE-BOX
          SIZE 22.6 BY 1
     RowObject.maintain_system_data AT ROW 4.14 COL 85.8
          LABEL "Maintain system data"
          VIEW-AS TOGGLE-BOX
          SIZE 25.6 BY 1
     fiProfileUserName AT ROW 5.14 COL 54.2 COLON-ALIGNED NO-LABEL
     RowObject.user_creation_date AT ROW 6.19 COL 22.6 COLON-ALIGNED
          LABEL "User created date"
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     RowObject.fmt_user_create_time AT ROW 6.19 COL 54.2 COLON-ALIGNED
          LABEL "Time"
          VIEW-AS FILL-IN 
          SIZE 10 BY 1
     RowObject.user_password AT ROW 7.57 COL 22.6 COLON-ALIGNED BLANK 
          LABEL "Password"
          VIEW-AS FILL-IN 
          SIZE 41.2 BY 1
     buBlank AT ROW 7.62 COL 67
     RowObject.confirm_password AT ROW 8.62 COL 22.6 COLON-ALIGNED BLANK 
          LABEL "Confirm password"
          VIEW-AS FILL-IN 
          SIZE 41.2 BY 1
     buBlank2 AT ROW 8.71 COL 67
     RowObject.password_creation_date AT ROW 9.67 COL 22.6 COLON-ALIGNED
          LABEL "Password created date"
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     RowObject.fmt_password_create_time AT ROW 9.67 COL 54.2 COLON-ALIGNED
          LABEL "Time"
          VIEW-AS FILL-IN 
          SIZE 10 BY 1
     RowObject.password_minimum_length AT ROW 10.71 COL 22.6 COLON-ALIGNED
          LABEL "Minimum length"
          VIEW-AS FILL-IN 
          SIZE 12.4 BY 1
     RowObject.password_preexpired AT ROW 11.76 COL 24.6
          LABEL "Password pre-expired"
          VIEW-AS TOGGLE-BOX
          SIZE 24.8 BY 1
     RowObject.update_password_history AT ROW 11.76 COL 56.2
          LABEL "Update history"
          VIEW-AS TOGGLE-BOX
          SIZE 18.8 BY 1
     RowObject.check_password_history AT ROW 11.76 COL 85.8
          LABEL "Check history"
          VIEW-AS TOGGLE-BOX
          SIZE 18.8 BY 1
     RowObject.password_expiry_date AT ROW 13.05 COL 22.6 COLON-ALIGNED
          LABEL "Password expiry date"
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     RowObject.fmt_password_expire_time AT ROW 13.05 COL 54.2 COLON-ALIGNED
          LABEL "Time"
          VIEW-AS FILL-IN 
          SIZE 10 BY 1
     RowObject.password_expiry_days AT ROW 13.05 COL 83.8 COLON-ALIGNED
          LABEL "Expiry days"
          VIEW-AS FILL-IN 
          SIZE 10.4 BY 1
     RowObject.last_login_date AT ROW 14.1 COL 22.6 COLON-ALIGNED
          LABEL "Last login date"
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     RowObject.fmt_user_login_time AT ROW 14.1 COL 54.2 COLON-ALIGNED
          LABEL "Time"
          VIEW-AS FILL-IN 
          SIZE 10 BY 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME frMain
     RowObject.password_fail_date AT ROW 15.14 COL 22.6 COLON-ALIGNED
          LABEL "Password fail date"
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     RowObject.fmt_password_fail_time AT ROW 15.14 COL 54.2 COLON-ALIGNED
          LABEL "Time"
          VIEW-AS FILL-IN 
          SIZE 10 BY 1
     RowObject.password_fail_count AT ROW 15.14 COL 83.8 COLON-ALIGNED
          LABEL "Fail count"
          VIEW-AS FILL-IN 
          SIZE 10.4 BY 1
     RowObject.user_email_address AT ROW 19.24 COL 22.6 COLON-ALIGNED
          LABEL "Email address"
          VIEW-AS FILL-IN 
          SIZE 50 BY 1
     RowObject.external_userid AT ROW 20.29 COL 22.6 COLON-ALIGNED
          LABEL "External reference"
          VIEW-AS FILL-IN 
          SIZE 21.6 BY 1
     SPACE(56.80) SKIP(0.00)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gsmusfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gsmusfullo.i}
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
         HEIGHT             = 20.29
         WIDTH              = 110.4.
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

/* SETTINGS FOR TOGGLE-BOX RowObject.check_password_history IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.confirm_password IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.development_user IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.disabled IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.external_userid IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN fiProfileUserName IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN RowObject.fmt_password_create_time IN FRAME frMain
   NO-ENABLE EXP-LABEL                                                  */
ASSIGN 
       RowObject.fmt_password_create_time:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN RowObject.fmt_password_expire_time IN FRAME frMain
   NO-ENABLE EXP-LABEL                                                  */
ASSIGN 
       RowObject.fmt_password_expire_time:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN RowObject.fmt_password_fail_time IN FRAME frMain
   NO-ENABLE EXP-LABEL                                                  */
ASSIGN 
       RowObject.fmt_password_fail_time:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN RowObject.fmt_user_create_time IN FRAME frMain
   NO-ENABLE EXP-LABEL                                                  */
ASSIGN 
       RowObject.fmt_user_create_time:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN RowObject.fmt_user_login_time IN FRAME frMain
   NO-ENABLE EXP-LABEL                                                  */
ASSIGN 
       RowObject.fmt_user_login_time:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN RowObject.last_login_date IN FRAME frMain
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX RowObject.maintain_system_data IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.password_creation_date IN FRAME frMain
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN RowObject.password_expiry_date IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.password_expiry_days IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.password_fail_count IN FRAME frMain
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN RowObject.password_fail_date IN FRAME frMain
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN RowObject.password_minimum_length IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.password_preexpired IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.profile_user IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.update_password_history IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.user_creation_date IN FRAME frMain
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN RowObject.user_email_address IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.user_full_name IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.user_login_name IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.user_password IN FRAME frMain
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

&Scoped-define SELF-NAME buBlank
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buBlank vTableWin
ON CHOOSE OF buBlank IN FRAME frMain /* Blank */
DO:
   ASSIGN
       RowObject.USER_password:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U
       .
   APPLY "VALUE-CHANGED":U TO rowObject.USER_password IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buBlank2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buBlank2 vTableWin
ON CHOOSE OF buBlank2 IN FRAME frMain /* Blank */
DO:
   ASSIGN
       RowObject.confirm_password:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U
       .
   APPLY "VALUE-CHANGED":U TO rowObject.USER_password IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.profile_user
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.profile_user vTableWin
ON VALUE-CHANGED OF RowObject.profile_user IN FRAME frMain /* Profile user */
DO:

   {set DataModified TRUE}.
   RUN valueChangedProfileUser.   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.user_login_name
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.user_login_name vTableWin
ON LEAVE OF RowObject.user_login_name IN FRAME frMain /* User login name */
DO:
  /* If a new user record and the full name has not yet been entered then,
     default full name to login name upon leave */
  DEFINE VARIABLE cNewRecord      AS CHARACTER      NO-UNDO.
  {get newRecord cNewRecord}.
  DO WITH FRAME {&FRAME-NAME}:
      IF cNewRecord EQ "ADD":U AND RowObject.USER_full_name:SCREEN-VALUE EQ "":U THEN
          RowObject.USER_full_name:SCREEN-VALUE = RowObject.USER_login_name:SCREEN-VALUE.
  END.

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
             INPUT  'DisplayedFieldgsm_user_category.user_category_description,gsm_user_category.user_category_codeKeyFieldgsm_user_category.user_category_objFieldLabelUser categoryFieldTooltipSelect the user category from the listKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH gsm_user_category NO-LOCK BY gsm_user_category.user_category_descriptionQueryTablesgsm_user_categorySDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1 (&2)ComboDelimiterListItemPairsInnerLines5ComboFlagFlagValueBuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesFieldNameuser_category_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dyncombo ).
       RUN repositionObject IN h_dyncombo ( 3.10 , 24.60 ) NO-ERROR.
       RUN resizeObject IN h_dyncombo ( 1.05 , 78.40 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsm_user.user_login_nameKeyFieldgsm_user.user_objFieldLabelBased on profileFieldTooltipBased on profileKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(15)DisplayDatatypecharacterBaseQueryStringFOR EACH gsm_user NO-LOCK
                     WHERE gsm_user.profile_user = TRUE,
                     FIRST gsm_user_category NO-LOCK
                     WHERE gsm_user_category.user_category_obj = gsm_user.user_category_obj
                     BY gsm_user.user_login_nameQueryTablesgsm_user,gsm_user_categoryBrowseFieldsgsm_user.user_login_name,gsm_user.user_full_name,gsm_user_category.user_category_codeBrowseFieldDataTypescharacter,character,characterBrowseFieldFormatsX(15)|X(70)|X(10)RowsToBatch200BrowseTitleLookup Profile UserViewerLinkedFieldsgsm_user.user_full_nameLinkedFieldDataTypescharacterLinkedFieldFormatsX(70)ViewerLinkedWidgetsfiProfileUserNameColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoFieldNamecreated_from_profile_user_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup ).
       RUN repositionObject IN h_dynlookup ( 5.14 , 24.60 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup ( 1.00 , 30.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_language.language_code,gsc_language.language_nameKeyFieldgsc_language.language_objFieldLabelLanguageFieldTooltipSelect a language from the listKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH gsc_language NO-LOCK BY gsc_language.language_nameQueryTablesgsc_languageSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1 (&2)ComboDelimiterListItemPairsInnerLines5ComboFlagNFlagValue0BuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesFieldNamelanguage_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dyncombo-2 ).
       RUN repositionObject IN h_dyncombo-2 ( 17.10 , 24.60 ) NO-ERROR.
       RUN resizeObject IN h_dyncombo-2 ( 1.05 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsm_login_company.login_company_short_nameKeyFieldgsm_login_company.login_company_objFieldLabelLogin companyFieldTooltipPress F4 For LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(15)DisplayDatatypecharacterBaseQueryStringFOR EACH gsm_login_company NO-LOCKQueryTablesgsm_login_companyBrowseFieldsgsm_login_company.login_company_code,gsm_login_company.login_company_short_name,gsm_login_company.login_company_nameBrowseFieldDataTypescharacter,character,characterBrowseFieldFormatsX(35)|X(15)|X(70)RowsToBatch200BrowseTitleLogin Company LookupViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListNO-LOCKQueryBuilderOrderListQueryBuilderTableOptionListNO-LOCKQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoFieldNamedefault_login_company_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup-2 ).
       RUN repositionObject IN h_dynlookup-2 ( 18.14 , 24.60 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup-2 ( 1.00 , 50.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_dyncombo ,
             RowObject.user_full_name:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_dynlookup ,
             RowObject.maintain_system_data:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_dyncombo-2 ,
             RowObject.password_fail_count:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_dynlookup-2 ,
             h_dyncombo-2 , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRecord vTableWin 
PROCEDURE cancelRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  RUN valueChangedProfileUser.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable vTableWin 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcRelative AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcRelative).

  /* Code placed here will execute AFTER standard behavior.    */

  RUN valueChangedProfileUser.

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

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE hContainerSource       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLinkHandles           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hPageSource            AS HANDLE     NO-UNDO.

  {get ContainerSource hContainerSource}.

  cLinkHandles   = DYNAMIC-FUNCTION('linkHandles' IN hContainerSource, 'Page-Source').
  hPageSource    = WIDGET-HANDLE(ENTRY(1,cLinkHandles)). 

  IF VALID-HANDLE(hPageSource) THEN
  DO:

      SUBSCRIBE PROCEDURE  hPageSource TO 'disableFolderPage' IN THIS-PROCEDURE.                
      SUBSCRIBE PROCEDURE  hPageSource TO 'enableFolderPage'  IN THIS-PROCEDURE.                

  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetRecord vTableWin 
PROCEDURE resetRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  RUN valueChangedProfileUser.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord vTableWin 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  RUN valueChangedProfileUser.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueChangedProfileUser vTableWin 
PROCEDURE valueChangedProfileUser :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   IF rowObject.profile_user:CHECKED IN FRAME {&FRAME-NAME} THEN
       PUBLISH "enableFolderPage" (INPUT 3).
   ELSE
       PUBLISH "disableFolderPage" (INPUT 3).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

