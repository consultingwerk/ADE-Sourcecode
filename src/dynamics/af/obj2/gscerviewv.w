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
       {"af/obj2/gscerfullo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/* Copyright (C) 2005,2007 by Progress Software Corporation. All rights
   reserved.  Prior versions of this work may contain portions
   contributed by participants of Possenet. */
/*---------------------------------------------------------------------------------
  File: gscerviewv.w

  Description:  Error Maintenance Viewer

  Purpose:      Error Maintenance Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000033   UserRef:    
                Date:   22/03/2001  Author:     Bruce Gruenbaum

  Update Notes: Created from Template rysttviewv.w

  (v:010001)    Task:           0   UserRef:    
                Date:   01/22/2002  Author:     Mark Davies (MIP)

  Update Notes: Fix for issue #3721 - Error 132 adding translation messages.
                
                Removed static combo SDF and replaced with dynamic combo and removed <None> option for combo list.
                When adding a gsc_error record you MUST specify a language_obj

  (v:010002)    Task:           0   UserRef:    
                Date:   05/06/2002  Author:     Mark Davies (MIP)

  Update Notes: Added field source_language

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

&scop object-name       gscerviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}

DEFINE VARIABLE glRefresh AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "af/obj2/gscerfullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.error_group RowObject.error_number ~
RowObject.source_language RowObject.error_summary_description ~
RowObject.error_type RowObject.update_error_log ~
RowObject.error_full_description 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS fiMessageFullDescriptionLabel 
&Scoped-Define DISPLAYED-FIELDS RowObject.error_group ~
RowObject.error_number RowObject.source_language ~
RowObject.error_summary_description RowObject.error_type ~
RowObject.update_error_log RowObject.error_full_description 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS fiMessageFullDescriptionLabel 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hLanguageObj AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiMessageFullDescriptionLabel AS CHARACTER FORMAT "X(45)":U INITIAL "Message full description:" 
      VIEW-AS TEXT 
     SIZE 23.6 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.error_group AT ROW 1 COL 32 COLON-ALIGNED
          LABEL "Message group"
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     RowObject.error_number AT ROW 2.1 COL 32 COLON-ALIGNED
          LABEL "Message number"
          VIEW-AS FILL-IN 
          SIZE 14 BY 1
     RowObject.source_language AT ROW 4.24 COL 34
          LABEL "Source language"
          VIEW-AS TOGGLE-BOX
          SIZE 22 BY 1
     RowObject.error_summary_description AT ROW 5.29 COL 32 COLON-ALIGNED
          LABEL "Message summary description"
          VIEW-AS FILL-IN 
          SIZE 78.4 BY 1
     RowObject.error_type AT ROW 6.38 COL 32 COLON-ALIGNED
          LABEL "Message type"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Message","MES",
                     "Information","INF",
                     "Error","ERR",
                     "Warning","WAR",
                     "Question","QUE"
          DROP-DOWN-LIST
          SIZE 16 BY 1
     RowObject.update_error_log AT ROW 6.38 COL 60
          LABEL "Update message log"
          VIEW-AS TOGGLE-BOX
          SIZE 29.4 BY 1
     RowObject.error_full_description AT ROW 7.52 COL 34 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 3000 SCROLLBAR-VERTICAL LARGE
          SIZE 78.4 BY 7
     fiMessageFullDescriptionLabel AT ROW 7.29 COL 8 COLON-ALIGNED NO-LABEL
     SPACE(48.40) SKIP(0.00)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gscerfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gscerfullo.i}
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
         HEIGHT             = 13.81
         WIDTH              = 112.
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

/* SETTINGS FOR EDITOR RowObject.error_full_description IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.error_group IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.error_number IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.error_summary_description IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX RowObject.error_type IN FRAME frMain
   EXP-LABEL                                                            */
ASSIGN 
       fiMessageFullDescriptionLabel:PRIVATE-DATA IN FRAME frMain     = 
                "Message full description:".

/* SETTINGS FOR TOGGLE-BOX RowObject.source_language IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.update_error_log IN FRAME frMain
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

&Scoped-define SELF-NAME RowObject.source_language
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.source_language vTableWin
ON VALUE-CHANGED OF RowObject.source_language IN FRAME frMain /* Source language */
DO:
  DEFINE VARIABLE cDataset      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrorObj     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dLanguageObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cLanguageCode AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAnswer       AS CHARACTER  NO-UNDO.
  
  {set dataModified TRUE}.

  IF RowObject.source_language:CHECKED THEN DO:
    {get DataSource hDataSource}.
  
    IF VALID-HANDLE(hDataSource) THEN
      cErrorObj = DYNAMIC-FUNCTION("columnStringValue":U IN hDataSource, "gsc_error.error_obj":U).
    
    RUN getRecordDetail IN gshGenManager ( INPUT "FOR EACH gsc_error WHERE gsc_error.error_group = '" + RowObject.error_group:SCREEN-VALUE + "'" + 
                                                 " AND gsc_error.error_number = " + RowObject.error_number:SCREEN-VALUE + 
                                                 " AND gsc_error.error_obj <> " + QUOTER(cErrorObj) + 
                                                 " AND gsc_error.source_language = TRUE NO-LOCK ":U,
                                           OUTPUT cDataset ).
    
    IF cDataset <> "":U AND cDataset <> ? THEN DO:
      dLanguageObj = DECIMAL(ENTRY(LOOKUP("gsc_error.language_obj":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3))).
      RUN getRecordDetail IN gshGenManager ( INPUT "FOR EACH gsc_language WHERE gsc_language.language_obj = " + QUOTER(dLanguageObj) + " NO-LOCK ":U,
                                             OUTPUT cDataset ).
      cLanguageCode = ENTRY(LOOKUP("gsc_language.language_code":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3)).
      RUN askQuestion IN gshSessionManager (INPUT "Another message for this group and number has already been marked as the source language (" + cLanguageCode + "). Do you wish to make this error the source language?",      /* messages */
                                            INPUT "&Yes,&No":U,     /* button list */
                                            INPUT "&No":U,          /* default */
                                            INPUT "&No":U,          /* cancel */
                                            INPUT "Question":U,     /* title */
                                            INPUT "":U,             /* datatype */
                                            INPUT "":U,             /* format */
                                            INPUT-OUTPUT cAnswer,   /* answer */
                                            OUTPUT cButton          /* button pressed */
                                            ).
      IF cButton = "&No":U THEN
        RowObject.source_language:CHECKED = FALSE.
      ELSE
        glRefresh = TRUE.
    END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord vTableWin 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     Overrides default processing to default the language combo
               to the language of the logged in user.
               If the user has no language specified, we leave the language as
               the first item in the list.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dLanguageObj   AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE cPropList AS CHARACTER    NO-UNDO.

  RUN SUPER.

  /* Figure out what the user's login language is */
  cPropList = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,"CurrentLanguageObj":U,YES).
  /* Now convert the obj to decimal */
  ASSIGN
    dLanguageObj = DECIMAL(cPropList) NO-ERROR.

  /* If the conversion worked, set the combo's data value */
  IF NOT ERROR-STATUS:ERROR AND
     dLanguageObj <> 0 THEN
    DYNAMIC-FUNCTION('setDataValue':U IN hLanguageObj,INPUT STRING(dLanguageObj,"->>>>>>>>>>>>>>>>>9.999999999":U)).
  /* otherwise set the error-status handle to NO. */
  ELSE 
    ERROR-STATUS:ERROR = NO.

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
             INPUT  'DisplayedFieldgsc_language.language_name,gsc_language.language_codeKeyFieldgsc_language.language_objFieldLabelLanguageFieldTooltipSelect a Language from the listKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH gsc_language NO-LOCK BY gsc_language.language_nameQueryTablesgsc_languageSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1 (&2)ComboDelimiterListItemPairsInnerLines5SortnoComboFlagFlagValueBuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesUseCacheyesSuperProcedureDataSourceNameFieldNamelanguage_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hLanguageObj ).
       RUN repositionObject IN hLanguageObj ( 3.19 , 34.00 ) NO-ERROR.
       RUN resizeObject IN hLanguageObj ( 1.05 , 48.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( hLanguageObj ,
             RowObject.error_number:HANDLE IN FRAME frMain , 'AFTER':U ).
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord vTableWin 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRowident   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrorType  AS CHARACTER  NO-UNDO.
  
  /* Code placed here will execute PRIOR to standard behavior. */

  {get DataSource hDataSource}.  
  
  /*if the Error_type changes then the SDO will change all the related records, and here,
    we just refresh the browse so the related records will be refreshed in the browse. */
  ASSIGN cErrorType = DYNAMIC-FUNCTION("columnStringValue" IN hDataSource, INPUT "error_type").
  IF cErrorType <>  rowObject.error_type:SCREEN-VALUE IN FRAME {&FRAME-NAME} THEN
    ASSIGN glRefresh = TRUE.
  
  RUN SUPER.
  
  IF RETURN-VALUE NE "ADM-ERROR":U THEN
  DO:
    IF glRefresh THEN DO:
      cRowident = DYNAMIC-FUNCTION('getRowIdent':U IN hDataSource) NO-ERROR.
      IF VALID-HANDLE(hDataSource) THEN DO:
        DYNAMIC-FUNCTION('openQuery' IN hDataSource).
        IF cRowIdent <> ? AND cRowIdent <> "":U THEN
          DYNAMIC-FUNCTION('fetchRowIdent' IN hDataSource, cRowIdent, '':U) NO-ERROR.
      END.
    END.
    glRefresh = FALSE.
  END.  /* if no ADM-ERROR */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

