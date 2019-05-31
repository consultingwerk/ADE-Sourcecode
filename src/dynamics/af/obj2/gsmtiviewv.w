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
       {"af/obj2/gsmtifullo.i"}.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: gsmtiviewv.w

  Description:  Translated Menu Item SmartDataViewer

  Purpose:      Translated Menu Item SmartDataViewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   04/05/2002  Author:     Mark Davies (MIP)

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

&scop object-name       gsmtiviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}

DEFINE TEMP-TABLE ttAvailTrans NO-UNDO
  FIELDS dLanguageObj     AS DECIMAL
  FIELDS dTransObj        AS DECIMAL
  FIELDS cFieldName       AS CHARACTER
  FIELDS cFieldValue      AS CHARACTER
  FIELDS rTransMenuItem   AS ROWID
  INDEX  idx1             AS PRIMARY UNIQUE dLanguageObj dTransObj cFieldName.

DEFINE TEMP-TABLE ttTransItems NO-UNDO
  FIELDS iFieldSeq        AS INTEGER  
  FIELDS cFieldName       AS CHARACTER FORMAT "X(70)":U 
  FIELDS cFieldLabel      AS CHARACTER FORMAT "X(10)":U  LABEL "Field description"
  FIELDS cFieldType       AS CHARACTER FORMAT "X(15)":U 
  FIELDS cOriginalText    AS CHARACTER FORMAT "X(256)":U LABEL "From languge"
  FIELDS cTranslatedText  AS CHARACTER FORMAT "X(256)":U LABEL "To language" 
  INDEX  idx1             AS PRIMARY UNIQUE iFieldSeq
  INDEX  idx2             AS UNIQUE cFieldLabel
  INDEX  idx3             cOriginalText
  INDEX  idx4             cTranslatedText.
 
DEFINE VARIABLE gcFieldList    AS CHARACTER  NO-UNDO INITIAL
  "menu_item_label,tooltip_text,alternate_shortcut_key,item_toolbar_label,image1_up_filename,image1_down_filename,image1_insensitive_filename,image2_up_filename,image2_down_filename,image2_insensitive_filename,item_narration".
DEFINE VARIABLE gcFieldLabels  AS CHARACTER  NO-UNDO INITIAL
  "Menu Item Label,Tooltip Text,Alternate Shortcut Key,Item Toolbar Label,Image1 Up Filename,Image1 Down Filename,Image1 Insensitive Filename,Image2 Up Filename,Image2 Down Filename,Image2 Insensitive Filename,Item Narration".
DEFINE VARIABLE gcFieldTypes   AS CHARACTER  NO-UNDO INITIAL
  "TEXT,TEXT,TEXT,TEXT,IMAGE,IMAGE,IMAGE,IMAGE,IMAGE,IMAGE,TEXT".
DEFINE VARIABLE gcFieldListMnu AS CHARACTER  NO-UNDO INITIAL
  "menu_item_label,tooltip_text,shortcut_key,item_toolbar_label,image1_up_filename,image1_down_filename,image1_insensitive_filename,image2_up_filename,image2_down_filename,image2_insensitive_filename,item_narration".

DEFINE VARIABLE ghBrowse          AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghQuery           AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghBuffer          AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghFieldLabel      AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghOrigText        AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTransText       AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghMenuItem        AS HANDLE     NO-UNDO.

DEFINE VARIABLE ghSourceViewer    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTransDataSource AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTreeContainer   AS HANDLE     NO-UNDO.
DEFINE VARIABLE gdSourceLanguage  AS DECIMAL    NO-UNDO.

DEFINE VARIABLE gdToLanguageObj   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE glDoUpdate        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE gcColSizes        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gdMenuItemObj     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE glCancelRecord    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE gcMenuItemNode    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghTreeView        AS HANDLE     NO-UNDO.
DEFINE VARIABLE gdLastSelLangObj  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE glDoNotRun        AS LOGICAL    NO-UNDO.

DEFINE TEMP-TABLE ttTranslatedMenuItem RCODE-INFORMATION /* Defined same as RowobjUpd temp table */
    {af/obj2/gsmtifullo.i}
    {src/adm2/rupdflds.i}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "af/obj2/gsmtifullo.i"

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buPlaceHolder EdFromText EdToText buImage1 ~
buImage2 
&Scoped-Define DISPLAYED-OBJECTS fiMenuItem fiSourceLanguage fiFromLanguage ~
fiToLanguage EdFromText EdToText fiImageTextFrom fiImageTextTo 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataModified vTableWin 
FUNCTION setDataModified RETURNS LOGICAL
  ( INPUT plModified AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hFromLanguage AS HANDLE NO-UNDO.
DEFINE VARIABLE hToLanguage AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buImage1 
     LABEL "" 
     SIZE 5.2 BY 1.24
     BGCOLOR 8 .

DEFINE BUTTON buImage2 
     LABEL "" 
     SIZE 5.2 BY 1.24
     BGCOLOR 8 .

DEFINE BUTTON buPlaceHolder 
     LABEL "Place_Holder_Do_Not_Remove" 
     SIZE 2.4 BY .48
     BGCOLOR 8 .

DEFINE BUTTON buSave 
     LABEL "&Save" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE EdFromText AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 44.4 BY 6.38 NO-UNDO.

DEFINE VARIABLE EdToText AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 44.4 BY 6.38 NO-UNDO.

DEFINE VARIABLE fiFromLanguage AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY 1 NO-UNDO.

DEFINE VARIABLE fiImageTextFrom AS CHARACTER FORMAT "X(256)":U INITIAL "Image:" 
      VIEW-AS TEXT 
     SIZE 6.4 BY .62 NO-UNDO.

DEFINE VARIABLE fiImageTextTo AS CHARACTER FORMAT "X(256)":U INITIAL "Image:" 
      VIEW-AS TEXT 
     SIZE 6.8 BY .62 NO-UNDO.

DEFINE VARIABLE fiLanguageString AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 1.4 BY 1 NO-UNDO.

DEFINE VARIABLE fiMenuItem AS CHARACTER FORMAT "X(70)":U 
     LABEL "Translating menu item" 
     VIEW-AS FILL-IN 
     SIZE 65 BY 1 NO-UNDO.

DEFINE VARIABLE fiSourceLanguage AS CHARACTER FORMAT "X(35)":U 
     LABEL "Source language" 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 NO-UNDO.

DEFINE VARIABLE fiSourceLanguageObj AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 1.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiToLanguage AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 91 BY 2.57.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 91 BY 7.52.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 91 BY 9.24.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiMenuItem AT ROW 1.19 COL 22.4 COLON-ALIGNED
     fiLanguageString AT ROW 1.24 COL 88.8 COLON-ALIGNED NO-LABEL
     fiSourceLanguageObj AT ROW 1.43 COL 88.4 COLON-ALIGNED NO-LABEL
     fiSourceLanguage AT ROW 2.24 COL 22.4 COLON-ALIGNED
     buSave AT ROW 2.24 COL 74.4
     buPlaceHolder AT ROW 4.91 COL 2.6
     fiFromLanguage AT ROW 11.38 COL 2.6 NO-LABEL
     fiToLanguage AT ROW 11.38 COL 47.6 NO-LABEL
     EdFromText AT ROW 12.48 COL 2.6 NO-LABEL
     EdToText AT ROW 12.48 COL 47.6 NO-LABEL
     buImage1 AT ROW 18.95 COL 10.4
     buImage2 AT ROW 18.95 COL 55.4
     fiImageTextFrom AT ROW 19.24 COL 1 COLON-ALIGNED NO-LABEL
     fiImageTextTo AT ROW 19.29 COL 45.8 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 3.57 COL 1.8
     RECT-3 AT ROW 11.1 COL 1.8
     RECT-1 AT ROW 1 COL 1.8
     SPACE(0.00) SKIP(1.19)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gsmtifullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gsmtifullo.i}
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
         HEIGHT             = 19.48
         WIDTH              = 91.8.
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

/* SETTINGS FOR BUTTON buSave IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       EdFromText:RETURN-INSERTED IN FRAME frMain  = TRUE.

ASSIGN 
       EdToText:RETURN-INSERTED IN FRAME frMain  = TRUE.

/* SETTINGS FOR FILL-IN fiFromLanguage IN FRAME frMain
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fiImageTextFrom IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiImageTextTo IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiLanguageString IN FRAME frMain
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fiLanguageString:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN fiMenuItem IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiSourceLanguage IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiSourceLanguageObj IN FRAME frMain
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fiSourceLanguageObj:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN fiToLanguage IN FRAME frMain
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-2 IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-3 IN FRAME frMain
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME buImage1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buImage1 vTableWin
ON CHOOSE OF buImage1 IN FRAME frMain
DO:
  IF edFromText:READ-ONLY = TRUE THEN
    RETURN NO-APPLY.

  RUN getButtonImage (INPUT edFromText:HANDLE,
                      INPUT SELF).
  APPLY "LEAVE":U TO edFromText IN FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buImage2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buImage2 vTableWin
ON CHOOSE OF buImage2 IN FRAME frMain
DO:
  RUN getButtonImage (INPUT edToText:HANDLE,
                      INPUT SELF).
  APPLY "LEAVE":U TO edToText IN FRAME {&FRAME-NAME}.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSave vTableWin
ON CHOOSE OF buSave IN FRAME frMain /* Save */
DO:
  DEFINE VARIABLE cKeyFormat      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dToLanguageObj  AS DECIMAL    NO-UNDO.

  dToLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hToLanguage)).
  glDoUpdate = TRUE.
  RUN updateState ("UpdateComplete":U).
  glDoUpdate = FALSE.
  {set DataModified FALSE}.
  RUN NewMenuItemSelected (INPUT FALSE).
  {get KeyFormat cKeyFormat hToLanguage}.
  {set DataValue STRING(dToLanguageObj,cKeyFormat) hToLanguage}.
  RUN comboValueChanged (INPUT STRING(dToLanguageObj),
                         INPUT "":U,
                         INPUT hToLanguage).
  glDoUpdate = TRUE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME EdFromText
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL EdFromText vTableWin
ON LEAVE OF EdFromText IN FRAME frMain
DO:
  DEFINE VARIABLE rRowid AS ROWID      NO-UNDO.

  IF AVAILABLE ttTransItems THEN DO:
    rRowid = ROWID(ttTransItems).
    IF ttTransItems.cOriginalText <> edFromText:SCREEN-VALUE THEN DO:
      ASSIGN ttTransItems.cOriginalText = edFromText:SCREEN-VALUE.
      {set DataModified TRUE}.
      ghQuery:QUERY-OPEN().
      ghQuery:REPOSITION-TO-ROWID(rRowid) NO-ERROR.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME EdToText
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL EdToText vTableWin
ON LEAVE OF EdToText IN FRAME frMain
DO:
  DEFINE VARIABLE rRowid AS ROWID      NO-UNDO.

  IF AVAILABLE ttTransItems THEN DO:
    rRowid = ROWID(ttTransItems).
    IF ttTransItems.cTranslatedText <> edToText:SCREEN-VALUE THEN DO:
      ASSIGN ttTransItems.cTranslatedText = edToText:SCREEN-VALUE.
      ASSIGN ghTransText:SCREEN-VALUE     = edToText:SCREEN-VALUE NO-ERROR.
      {set DataModified TRUE}.
      ghQuery:QUERY-OPEN().
      ghQuery:REPOSITION-TO-ROWID(rRowid) NO-ERROR.
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
             INPUT  'DisplayedFieldgsc_language.language_nameKeyFieldgsc_language.language_objFieldLabelFromFieldTooltipSelect a language to translate from, from the listKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH gsc_language NO-LOCK BY gsc_language.language_nameQueryTablesgsc_languageSDFFileNameSDFTemplateParentFieldfiLanguageStringParentFilterQueryLOOKUP(STRING(gsc_language.language_obj),~'&1~') > 0DescSubstitute&1ComboDelimiterListItemPairsInnerLines5SortnoComboFlagFlagValueBuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesUseCacheyesSuperProcedureDataSourceNameFieldName<Local_1>DisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayoutKeyFieldgsc_language.language_obj':U ,
             OUTPUT hFromLanguage ).
       RUN repositionObject IN hFromLanguage ( 3.76 , 8.20 ) NO-ERROR.
       RUN resizeObject IN hFromLanguage ( 1.00 , 37.60 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_language.language_nameKeyFieldgsc_language.language_objFieldLabelToFieldTooltipSelect a language to translate to, from the listKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH gsc_language NO-LOCK BY gsc_language.language_nameQueryTablesgsc_languageSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1ComboDelimiterListItemPairsInnerLines5SortnoComboFlagFlagValue0BuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListNO-LOCKQueryBuilderOrderListgsc_language.language_name^yesQueryBuilderTableOptionListNO-LOCKQueryBuilderTuneOptionsQueryBuilderWhereClausesUseCacheyesSuperProcedureDataSourceNameFieldName<Local_2>DisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayoutKeyFieldgsc_language.language_obj':U ,
             OUTPUT hToLanguage ).
       RUN repositionObject IN hToLanguage ( 3.76 , 52.60 ) NO-ERROR.
       RUN resizeObject IN hToLanguage ( 1.00 , 37.60 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( hFromLanguage ,
             buSave:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( hToLanguage ,
             hFromLanguage , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BrowseValueChanged vTableWin 
PROCEDURE BrowseValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iX      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iY      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iWidth  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iHeight AS INTEGER    NO-UNDO.

  IF AVAILABLE ttTransItems THEN DO WITH FRAME {&FRAME-NAME}:
    ASSIGN edFromText:SCREEN-VALUE = ttTransItems.cOriginalText
           edToText:SCREEN-VALUE   = ttTransItems.cTranslatedText.

    CASE ttTransItems.cFieldType:
      WHEN "TEXT":U THEN DO:
        ASSIGN buImage1:SENSITIVE = FALSE
               buImage2:SENSITIVE = FALSE.
        buImage1:LOAD-IMAGE("":U).
        buImage2:LOAD-IMAGE("":U).
      END.
      WHEN "IMAGE":U THEN DO:
        ASSIGN buImage1:SENSITIVE = TRUE
               buImage2:SENSITIVE = TRUE
               ERROR-STATUS:ERROR = NO.

        /* Clear the image button before we try loading the new image */
        buImage1:LOAD-IMAGE("":U).
        buImage2:LOAD-IMAGE("":U).

        /* Image 1 */
        IF NUM-ENTRIES(ttTransItems.cOriginalText) = 1 THEN
            buImage1:LOAD-IMAGE(ttTransItems.cOriginalText) NO-ERROR.
        ELSE
            IF NUM-ENTRIES(ttTransItems.cOriginalText) = 5
            THEN DO:
                ASSIGN iX      = INTEGER(ENTRY(2, ttTransItems.cOriginalText))
                       iY      = INTEGER(ENTRY(3, ttTransItems.cOriginalText))
                       iWidth  = INTEGER(ENTRY(4, ttTransItems.cOriginalText))
                       iHeight = INTEGER(ENTRY(5, ttTransItems.cOriginalText))
                       NO-ERROR.

                IF NOT ERROR-STATUS:ERROR THEN
                    buImage1:LOAD-IMAGE(ENTRY(1, ttTransItems.cOriginalText), iX, iY, iWidth, iHeight) NO-ERROR.
            END.

        /* Image 2 */
        IF NUM-ENTRIES(ttTransItems.cTranslatedText) = 1 THEN
            buImage2:LOAD-IMAGE(ttTransItems.cTranslatedText) NO-ERROR.
        ELSE
            IF NUM-ENTRIES(ttTransItems.cTranslatedText) = 5
            THEN DO:
                ASSIGN iX      = INTEGER(ENTRY(2, ttTransItems.cTranslatedText))
                       iY      = INTEGER(ENTRY(3, ttTransItems.cTranslatedText))
                       iWidth  = INTEGER(ENTRY(4, ttTransItems.cTranslatedText))
                       iHeight = INTEGER(ENTRY(5, ttTransItems.cTranslatedText))
                       NO-ERROR.

                IF NOT ERROR-STATUS:ERROR THEN
                    buImage2:LOAD-IMAGE(ENTRY(1, ttTransItems.cTranslatedText), iX, iY, iWidth, iHeight) NO-ERROR.
            END.
      END.
    END CASE.
  END. /* Available ttTransItems */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildBrowser vTableWin 
PROCEDURE buildBrowser :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hField             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hCurField          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rID                AS ROWID      NO-UNDO.
  DEFINE VARIABLE cLogicalObjectName AS CHARACTER  NO-UNDO.
  
  IF VALID-HANDLE(ghBrowse) THEN
    DELETE OBJECT ghBrowse.
  
  IF VALID-HANDLE(ghQuery) THEN
    DELETE OBJECT ghQuery.

  /* Check for saved column sizes */
  rID = ?.
  {get LogicalObjectName cLogicalObjectName}.
  RUN getProfileData IN gshProfileManager
      (INPUT 'Browser':U,
       INPUT 'Columns':U,
       INPUT cLogicalObjectName,
       INPUT NO,
       INPUT-OUTPUT rID,
       OUTPUT gcColSizes).

  
  DO WITH FRAME {&FRAME-NAME}:
    ghBuffer = BUFFER ttTransItems:HANDLE.
    CREATE QUERY ghQuery.
    ghQuery:ADD-BUFFER(ghBuffer).
    ghQuery:QUERY-PREPARE("FOR EACH ttTransItems NO-LOCK BY ttTransItems.iFieldSeq").

    CREATE BROWSE ghBrowse
           ASSIGN FRAME            = FRAME {&FRAME-NAME}:handle
                  NAME             = "Browse1"
                  ROW              = buPlaceHolder:ROW
                  COL              = buPlaceHolder:COL
                  WIDTH-CHARS      = RECT-2:WIDTH - 1
                  HEIGHT-CHARS     = RECT-2:HEIGHT - 1.5
                  REFRESHABLE      = YES
                  SEPARATORS       = TRUE
                  ROW-MARKERS      = FALSE
                  EXPANDABLE       = TRUE
                  COLUMN-RESIZABLE = TRUE
                  ALLOW-COLUMN-SEARCHING = TRUE
                  READ-ONLY        = FALSE
                  QUERY            = ghQuery
            /* Set procedures to handle browser events */
            TRIGGERS:   
              ON VALUE-CHANGED 
                 PERSISTENT RUN BrowseValueChanged IN THIS-PROCEDURE.
              ON START-SEARCH
                 PERSISTENT RUN startSearch    IN THIS-PROCEDURE.
              ON ROW-DISPLAY
                 PERSISTENT RUN rowDisplay     IN THIS-PROCEDURE.
              ON ROW-LEAVE
                 PERSISTENT RUN rowLeave       IN THIS-PROCEDURE.
            END TRIGGERS.
        
    DO iLoop = 1 TO ghBuffer:NUM-FIELDS:
        hCurField = ghBuffer:BUFFER-FIELD(iLoop).
        
        IF LOOKUP(hCurField:NAME,"cFieldLabel,cOriginalText,cTranslatedText":U) > 0 THEN DO:
          IF hCurField:NAME = "cFieldLabel" THEN
            hCurField:FORMAT = "x(35)":U.
          ELSE
            hCurField:FORMAT = "x(70)":U.
          
          hField = ghBrowse:ADD-LIKE-COLUMN(hCurField,iLoop).
          hField:VISIBLE = TRUE.
          CASE hCurField:NAME:
            WHEN "cFieldLabel" THEN DO:
              ASSIGN ghFieldLabel = hField
                     ghFieldLabel:LABEL = "Field description".
              IF gcColSizes <> "":U AND
                 gcColSizes <> ? AND 
                 DECIMAL(ENTRY(1,gcColSizes,CHR(3))) > 0 THEN
                ghFieldLabel:WIDTH-PIXELS = DECIMAL(ENTRY(1,gcColSizes,CHR(3))).
            END.
            WHEN "cOriginalText" THEN DO:
              ASSIGN ghOrigText           = hField
                     ghOrigText:READ-ONLY = TRUE.
              IF gcColSizes <> "":U AND
                 gcColSizes <> ? AND 
                 DECIMAL(ENTRY(2,gcColSizes,CHR(3))) > 0 THEN
                ghOrigText:WIDTH-PIXELS = DECIMAL(ENTRY(2,gcColSizes,CHR(3))).
            END.
            WHEN "cTranslatedText" THEN DO:
              ASSIGN ghTransText           = hField
                     ghTransText:READ-ONLY = FALSE.
              IF gcColSizes <> "":U AND
                 gcColSizes <> ? AND 
                 DECIMAL(ENTRY(3,gcColSizes,CHR(3))) > 0 THEN
                ghTransText:WIDTH-PIXELS = DECIMAL(ENTRY(3,gcColSizes,CHR(3))).
            END.
          END CASE.
      END. 
    END.
    
    ASSIGN ghBrowse:VISIBLE   = TRUE
           ghBrowse:SENSITIVE = TRUE.
    
  END.
  /* Open the query for the browser */
  ghQuery:QUERY-OPEN().
  IF gcColSizes = "":U OR
     gcColSizes = ? THEN
    RUN resizeBrowseColumns.
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
 glCancelRecord = TRUE.
  /* Code placed here will execute PRIOR to standard behavior. */
  glDoUpdate = FALSE.
  
  RUN SUPER.
  
  {set dataModified FALSE}.
  
  /* Code placed here will execute AFTER standard behavior.    */

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
  DEFINE INPUT  PARAMETER hComboHandle    AS HANDLE     NO-UNDO.

  DEFINE VARIABLE dFromLanguageObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dToLanguageObj   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lContinue        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cAnswer          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFormat       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cExtraMessage    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessageList     AS CHARACTER  NO-UNDO.
  
  ASSIGN dFromLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hFromLanguage))
         dToLanguageObj   = DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hToLanguage)).
  
  CASE hComboHandle:
    WHEN hFromLanguage THEN DO:
      fiFromLanguage:SCREEN-VALUE IN FRAME {&FRAME-NAME} = pcScreenValue.
      IF VALID-HANDLE(ghOrigText) THEN
        ghOrigText:LABEL = pcScreenValue.
      RUN loadFromLanguageRecords (INPUT DECIMAL(pcKeyFieldValue)).
      ghQuery:QUERY-OPEN().
      RUN BrowseValueChanged.
      /* Disable the From Language field if the Source Language is used */
      IF gdSourceLanguage = DECIMAL(pcKeyFieldValue) OR
         dFromLanguageObj = dToLanguageObj THEN
        ASSIGN ghOrigText:READ-ONLY = TRUE
               edFromText:READ-ONLY = TRUE.
      ELSE
        ASSIGN ghOrigText:READ-ONLY = TRUE
               edFromText:READ-ONLY = FALSE.
      IF DYNAMIC-FUNCTION("getListItemPairs":U IN hToLanguage) = DYNAMIC-FUNCTION("getComboDelimiter":U IN hToLanguage) THEN DO:
        RUN disableField IN hFromLanguage.
        RUN disableField IN hToLanguage.
        ghBrowse:SENSITIVE = FALSE.
        DISABLE edToText WITH FRAME {&FRAME-NAME}.
      END.
    END.
    WHEN hToLanguage THEN DO:
      IF DYNAMIC-FUNCTION("getDataModified":U) = TRUE THEN DO:
        ASSIGN cAnswer = "&Yes":U.
        RUN askQuestion IN gshSessionManager (INPUT "Current values have not been saved.~n~nDo you wish to save current values before loading new data?",      /* messages */
                                              INPUT "&Yes,&No":U,     /* button list */
                                              INPUT "&No":U,          /* default */
                                              INPUT "&No":U,          /* cancel */
                                              INPUT "Question":U,     /* title */
                                              INPUT "":U,             /* datatype */
                                              INPUT "":U,             /* format */
                                              INPUT-OUTPUT cAnswer,   /* answer */
                                              OUTPUT cButton          /* button pressed */
                                              ).
        
        IF cButton = "&Yes" THEN DO:
          {get KeyFormat cKeyFormat hToLanguage}.
          {set DataModified FALSE}.
          {set DataValue STRING(gdToLanguageObj,cKeyFormat) hToLanguage}.
          RUN saveChanges.
          RUN NewMenuItemSelected (INPUT FALSE).
          {set DataValue STRING(dToLanguageObj,cKeyFormat) hToLanguage}.
        END.
        glDoUpdate = FALSE.
        {set DataModified FALSE}.
        glDoUpdate = TRUE.
      END.
      fiToLanguage:SCREEN-VALUE IN FRAME {&FRAME-NAME} = pcScreenValue.
      IF VALID-HANDLE(ghTransText) THEN
        ghTransText:LABEL = pcScreenValue.
      RUN loadToLanguageRecords (INPUT DECIMAL(pcKeyFieldValue)).
      ghQuery:QUERY-OPEN().
      RUN BrowseValueChanged.
    END.
  END CASE.
  gdToLanguageObj = dToLanguageObj.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject vTableWin 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLogicalObjectName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnData        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hColumn            AS HANDLE     NO-UNDO.

  /* Save column sizes */      
  {get LogicalObjectName cLogicalObjectName}.
  hColumn = ghBrowse:FIRST-COLUMN.
  DO WHILE VALID-HANDLE(hColumn):
    cColumnData = IF cColumnData = "":U THEN STRING(hColumn:WIDTH-PIXELS)
                                        ELSE cColumnData + CHR(3) + STRING(hColumn:WIDTH-PIXELS).
    hColumn = hColumn:NEXT-COLUMN.
  END.
  
  RUN setProfileData IN gshProfileManager 
    (INPUT 'Browser':U,
     INPUT 'Columns':U,
     INPUT cLogicalObjectName,
     INPUT ?,
     INPUT cColumnData,
     INPUT NO,
     INPUT 'PER':U).
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.
  IF VALID-HANDLE(ghBrowse) THEN
    DELETE OBJECT ghBrowse.
  IF VALID-HANDLE(ghQuery) THEN
    DELETE OBJECT ghQuery.
  IF VALID-HANDLE(ghBuffer) THEN
    DELETE OBJECT ghBuffer.
  
  IF VALID-HANDLE(ghFieldLabel) THEN
    DELETE OBJECT ghFieldLabel.
  IF VALID-HANDLE(ghOrigText) THEN
    DELETE OBJECT ghOrigText.
  IF VALID-HANDLE(ghTransText) THEN
    DELETE OBJECT ghTransText.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE frameVisible vTableWin 
PROCEDURE frameVisible :
/*------------------------------------------------------------------------------
  Purpose:     Force frame to be visble.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO.

  {get ContainerSource hContainer}.
  FRAME {&FRAME-NAME}:VISIBLE = TRUE.
  IF VALID-HANDLE(hContainer) THEN DO:
    RUN selectPage IN hContainer (INPUT 0).
    RUN selectPage IN hContainer (INPUT 1).
    PROCESS EVENTS.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getButtonImage vTableWin 
PROCEDURE getButtonImage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phImageUp  AS HANDLE    NO-UNDO.
 
  DEFINE INPUT  PARAMETER phButton   AS HANDLE    NO-UNDO.
 

  define variable cFileName     as character format "x(60)":U no-undo.
  define variable cDirectory    as character format "x(60)":U no-undo.
  define variable cAbsFilename  as character format "x(60)":U no-undo.
  define variable cExtension    as character no-undo.
  DEFINE VARIABLE lOK           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE image-formats AS CHARACTER  NO-UNDO.
  assign cFileName  = phImageUp:SCREEN-VALUE
         cFileName  = substring(cFileName, 1, r-index(cFileName , ".":u)- 1)
         cDirectory = "adeicon,af/bmp":U 
         image-formats = "All Picture Files|*.bmp,*.gif,*.ico,*.jpg,*.png,*.tif" +
                        "|Bitmap (*.bmp)|*.bmp" +
                        "|GIF (*.gif)|*.gif" +
                        "|Icon (*.ico)|*.ico" + 
                        "|JPEG (*.jpg)|*.jpg" + 
                        "|PNG (*.png)|*.png" + 
                        "|TIFF (*.tif)|*.tif" +
                        "|All Files|*.*":U
                        NO-ERROR.

  RUN adecomm/_fndfile.p   (INPUT "Image",
                            INPUT "IMAGE":u,
                            &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
                              INPUT image-formats,
                            &ELSE
                              INPUT "*.xpm,*.xbm|*.*",
                            &ENDIF
                            INPUT-OUTPUT cDirectory,
                            INPUT-OUTPUT cFileName,
                            OUTPUT cAbsFileName,
                            OUTPUT lOk).

  IF lOK THEN DO:
     phButton:LOAD-IMAGE(cFileName) NO-ERROR.    
     phImageUp:SCREEN-VALUE = cFileName.
    {set DataModified YES}.
  END.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTransRecords vTableWin 
PROCEDURE getTransRecords :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFieldName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cWhere        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dMenuItemObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lRowAvailable AS LOGICAL    NO-UNDO.

  EMPTY TEMP-TABLE ttAvailTrans.

  /* First get the Source Language Record from the original Menu Item */
  IF VALID-HANDLE(ghTransDataSource) THEN DO:
    gcMenuItemNode = DYNAMIC-FUNC('getProperty':U IN ghTreeView,"KEY":U,"").

    dMenuItemObj = DECIMAL(DYNAMIC-FUNCTION("columnStringValue":U IN ghTransDataSource, "gsm_menu_item.menu_item_obj":U)).
    DO iLoop = 1 TO NUM-ENTRIES(gcFieldListMnu):
      cFieldName = ENTRY(iLoop,gcFieldListMnu).
      CREATE ttAvailTrans.
      ttAvailTrans.dLanguageObj = DECIMAL(DYNAMIC-FUNCTION("columnStringValue":U IN ghTransDataSource, "gsm_menu_item.source_language_obj":U)).
      ttAvailTrans.dTransObj    = DECIMAL(DYNAMIC-FUNCTION("columnStringValue":U IN ghTransDataSource, "gsm_menu_item.menu_item_obj":U)).
      ttAvailTrans.cFieldName   = ENTRY(iLoop,gcFieldList).
      ttAvailTrans.cFieldValue  = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN ghTransDataSource, "gsm_menu_item.":U + cFieldName)).
    END.
  END.

  /* Now look for any translated records in gsm_translated_menu_item */
  {get DataSource hDataSource}.
  IF VALID-HANDLE(hDataSource) THEN DO:
    /* Clear any previous queries */
    DYNAMIC-FUNCTION("setQueryWhere":U IN hDataSource, "":U).
    DYNAMIC-FUNCTION("addQueryWhere":U IN hDataSource,INPUT "menu_item_obj = ":U + QUOTER(dMenuItemObj), "":U, "AND":U).
    ASSIGN cWhere = "menu_item_obj = ":U + QUOTER(STRING(dMenuItemObj)) + CHR(3) + CHR(3) + "AND":U.
    {set manualAddQueryWhere cWhere hDataSource}.
    DYNAMIC-FUNCTION("openQuery":U IN hDataSource).
    
    RUN fetchFirst IN hDataSource.
    lRowAvailable = DYNAMIC-FUNCTION("rowAvailable":U IN hDataSource, "CURRENT":U).
    
    RECORD_AVAILABLE:
    DO WHILE lRowAvailable = TRUE:
      DO iLoop = 1 TO NUM-ENTRIES(gcFieldList):
        cFieldName = ENTRY(iLoop,gcFieldList).
        CREATE ttAvailTrans.
        ttAvailTrans.dLanguageObj = DECIMAL(DYNAMIC-FUNCTION("columnStringValue":U IN hDataSource, "gsm_translated_menu_item.language_obj":U)).
        ttAvailTrans.dTransObj    = DECIMAL(DYNAMIC-FUNCTION("columnStringValue":U IN hDataSource, "gsm_translated_menu_item.translated_menu_item_obj":U)).
        ttAvailTrans.cFieldName   = ENTRY(iLoop,gcFieldList).
        ASSIGN ttAvailTrans.cFieldValue    = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hDataSource, "gsm_translated_menu_item.":U + cFieldName))
               ttAvailTrans.rTransMenuItem = TO-ROWID(ENTRY(1,DYNAMIC-FUNCTION("getRowIdent":U IN hDataSource))).
      END.
      
      lRowAvailable = DYNAMIC-FUNCTION("rowAvailable":U IN hDataSource, "NEXT":U). 
      IF lRowAvailable THEN 
        RUN fetchNext IN hDataSource.
      ELSE 
        LEAVE RECORD_AVAILABLE.
    END. /* WHILE */
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
  DEFINE VARIABLE hDataSource    AS HANDLE     NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "comboValueChanged":U IN THIS-PROCEDURE.
  
  {get DataSource hDataSource}.
  IF VALID-HANDLE(hDataSource) THEN
    {set OpenOnInit FALSE hDataSource}.
  
  RUN SUPER.
  
  /* Code placed here will execute AFTER standard behavior.    */
  
  
  RUN displayFields IN TARGET-PROCEDURE (INPUT "":U).
  
  RUN enableField IN hFromLanguage.
  RUN enableField IN hToLanguage.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fiImageTextFrom:SCREEN-VALUE = "Image:"
           fiImageTextTo:SCREEN-VALUE   = "Image:".
  END.

  RUN rebuildTempTable.
  
  RUN buildBrowser.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadFromLanguageRecords vTableWin 
PROCEDURE loadFromLanguageRecords :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdLanguageObj AS DECIMAL    NO-UNDO.
  
  FOR EACH ttTransItems:
    FIND FIRST ttAvailTrans
         WHERE ttAvailTrans.cFieldName   = ttTransItems.cFieldName
         AND   ttAvailTrans.dLanguageObj = pdLanguageObj
         NO-LOCK NO-ERROR.
    IF AVAILABLE ttAvailTrans THEN
      ASSIGN ttTransItems.cOriginalText = ttAvailTrans.cFieldValue.
    ELSE
      ASSIGN ttTransItems.cOriginalText = "":U.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadToLanguageRecords vTableWin 
PROCEDURE loadToLanguageRecords :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdLanguageObj AS DECIMAL    NO-UNDO.
  
  FOR EACH ttTransItems:
    FIND FIRST ttAvailTrans
         WHERE ttAvailTrans.cFieldName   = ttTransItems.cFieldName
         AND   ttAvailTrans.dLanguageObj = pdLanguageObj
         NO-LOCK NO-ERROR.
    IF AVAILABLE ttAvailTrans THEN
      ASSIGN ttTransItems.cTranslatedText = ttAvailTrans.cFieldValue.
    ELSE
      ASSIGN ttTransItems.cTranslatedText = "":U.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NewMenuItemSelected vTableWin 
PROCEDURE NewMenuItemSelected :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run every time a new menu item record is 
               selected 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER plNewRecord AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cKeyFieldFormat AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dUserObj        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dSrcLang        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hContainer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lModified       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lError          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hCombo          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cExtraMessage   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessageList    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLanguageObj    AS CHARACTER  NO-UNDO.

  IF glDoNotRun THEN
    RETURN.

  /* If we moved of the Menu Item UI - disable all fields */
  IF plNewRecord = ? THEN DO:
    RUN disableField IN hFromLanguage.
    RUN disableField IN hToLanguage.
    ghBrowse:SENSITIVE = FALSE.
    DISABLE edToText buImage2 WITH FRAME {&FRAME-NAME}.
    RETURN.
  END.

  IF NOT VALID-HANDLE(ghTransDataSource) THEN DO:
    ghSourceViewer = WIDGET-HANDLE(ENTRY(1,DYNAMIC-FUNCTION("linkHandles":U,"Translation-Source":U))).
  
    IF VALID-HANDLE(ghSourceViewer) THEN DO:
      ghTransDataSource = WIDGET-HANDLE(ENTRY(1,DYNAMIC-FUNCTION("linkHandles":U IN ghSourceViewer,"Data-Source":U))).
      ghTreeContainer = WIDGET-HANDLE(ENTRY(1,DYNAMIC-FUNCTION("linkHandles":U IN ghSourceViewer,"MenuItem-Source":U))).
      ghTreeView = WIDGET-HANDLE(ENTRY(1,DYNAMIC-FUNCTION("linkHandles":U IN ghTreeContainer,"TreeView-Source":U))).
    END.
  END.

  /* Check if we are currently modifying a record  */
  IF buSave:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE THEN DO:
    glCancelRecord = FALSE.
    RUN okToContinueProcedure IN TARGET-PROCEDURE (INPUT 'Other':U,
                                                   OUTPUT lError).
    /* No was chosen */
    IF lError AND glCancelRecord THEN DO:
      {set DataModified FALSE}.
      buSave:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
    END.
    
    /* Cancel was chosen */
    IF NOT lError AND NOT glCancelRecord AND buSave:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE THEN DO:
      DYNAMIC-FUNCTION("selectNode":U IN ghTreeView, gcMenuItemNode).
      glDoNotRun = TRUE.
      RUN tvNodeEvent IN ghTreeContainer (INPUT "CLICK":U, INPUT gcMenuItemNode).
      glDoNotRun = FALSE.
      RETURN.
    END.
 END.

  IF VALID-HANDLE(ghTransDataSource) AND NOT plNewRecord THEN DO:
    ASSIGN fiMenuItem       = DYNAMIC-FUNCTION("columnStringValue":U IN ghTransDataSource, "gsm_menu_item.menu_item_reference":U)
           fiSourceLanguage = DYNAMIC-FUNCTION("columnStringValue":U IN ghTransDataSource, "gsc_language.language_name":U)
           gdSourceLanguage = DECIMAL(DYNAMIC-FUNCTION("columnStringValue":U IN ghTransDataSource, "gsm_menu_item.source_language_obj":U)).
  END.
  IF gdSourceLanguage = ? THEN
    gdSourceLanguage = 0.
  
  IF plNewRecord THEN DO:
    dUserObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                         INPUT "CurrentUserObj":U,
                                         INPUT NO)) NO-ERROR.
    RUN getUserSourceLanguage IN gshGenManager (INPUT dUserObj, OUTPUT dSrcLang).
    ASSIGN fiMenuItem       = "New Record Being Added"
           fiSourceLanguage = "":U.
           gdSourceLanguage = dSrcLang.
           
     IF VALID-HANDLE(ghBrowse) THEN
       ghBrowse:SENSITIVE = FALSE.
     DISABLE buImage1 buImage2 edFromText edToText WITH FRAME {&FRAME-NAME}.
     RUN disableField IN hFromLanguage.
     RUN disableField IN hToLanguage.
  END.
  DISPLAY fiMenuItem 
          fiSourceLanguage 
          WITH FRAME {&FRAME-NAME}.
  
  RUN getTransRecords. 
  
  /* Now only view languages that have a translation attached 
     to it in the From Language Combo */
  fiLanguageString = "":U.
  FOR EACH ttAvailTrans:
    cLanguageObj = REPLACE(STRING(ttAvailTrans.dLanguageObj),SESSION:NUMERIC-DECIMAL-POINT, ".":U).
    IF LOOKUP(STRING(ttAvailTrans.dLanguageObj),fiLanguageString) = 0 THEN
      fiLanguageString = IF fiLanguageString = "":U 
                         THEN cLanguageObj
                         ELSE fiLanguageString + ",":U + cLanguageObj.
  END.
  
  ASSIGN fiLanguageString:SCREEN-VALUE IN FRAME {&FRAME-NAME}    = fiLanguageString
         fiSourceLanguageObj:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(gdSourceLanguage).

  IF (DYNAMIC-FUNCTION('getSessionParam':U IN TARGET-PROCEDURE,
                                'keep_old_field_api':U) = 'YES':U) THEN
  DO:
      RUN refreshChildDependancies IN hFromLanguage (INPUT "fiLanguageString":U).
      RUN refreshChildDependancies IN hToLanguage   (INPUT "fiSourceLanguageObj":U).  
  END.
  ELSE
      RUN displayFields IN TARGET-PROCEDURE (INPUT "":U).

  {get KeyFormat cKeyFieldFormat hFromLanguage}.
  {set DataValue gdSourceLanguage hFromLanguage}.

  RUN valueChanged IN hFromLanguage.

  IF DYNAMIC-FUNCTION("getListItemPairs":U IN hToLanguage) = DYNAMIC-FUNCTION("getComboDelimiter":U IN hToLanguage) THEN DO:
    cExtraMessage = "You need at least one other language to translate to.".
    cMessageList  = {aferrortxt.i 'AF' '39' '' '' "'other languages to translate to'" cExtraMessage }.
    RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Translation",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).
    RUN disableField IN hFromLanguage.
    RUN disableField IN hToLanguage.
    ghBrowse:SENSITIVE = FALSE.
    DISABLE edToText WITH FRAME {&FRAME-NAME}.
  END.
  
  /* Always select the first entry in the 'To Language' */
  IF DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hToLanguage)) = 0 THEN DO:
    {get ComboHandle hCombo hToLanguage}.
    IF VALID-HANDLE(hCombo) AND 
       CAN-QUERY(hCombo,"LIST-ITEM-PAIRS":U) AND 
      DYNAMIC-FUNCTION("getListItemPairs":U IN hToLanguage) = DYNAMIC-FUNCTION("getComboDelimiter":U IN hToLanguage) THEN
      hCombo:SCREEN-VALUE = hCombo:ENTRY(1) NO-ERROR.
    {set DataValue hCombo:SCREEN-VALUE hToLanguage}.
    RUN valueChanged IN hToLanguage.
  END.

  /* Reselect the last language that the user used */
  IF gdLastSelLangObj <> 0 THEN DO:
    {set DataValue gdLastSelLangObj hToLanguage}.
    RUN valueChanged IN hToLanguage.
  END.
  IF VALID-HANDLE(ghTransDataSource) THEN
    gdMenuItemObj = DECIMAL(DYNAMIC-FUNCTION("columnStringValue":U IN ghTransDataSource, "gsm_menu_item.menu_item_obj":U)).
  
  /* Check if we have a language to translate to */
  IF DYNAMIC-FUNCTION("getListItemPairs":U IN hToLanguage) = DYNAMIC-FUNCTION("getComboDelimiter":U IN hToLanguage) THEN DO:
    RUN disableField IN hFromLanguage.
    RUN disableField IN hToLanguage.
    ghBrowse:SENSITIVE = FALSE.
    DISABLE edToText WITH FRAME {&FRAME-NAME}.
  END.
  ELSE DO:
    IF NOT plNewRecord THEN DO:
      IF VALID-HANDLE(ghBrowse) THEN
        ghBrowse:SENSITIVE = TRUE.
      RUN enableField IN hFromLanguage.
      RUN enableField IN hToLanguage.
      ENABLE edFromText edToText WITH FRAME {&FRAME-NAME}.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rebuildTempTable vTableWin 
PROCEDURE rebuildTempTable :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will cleae the ttTransItems temp table and rebuild
               it with the default translateable fields found in 
               gsm_translated_menu_item
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iSeq AS INTEGER    NO-UNDO.
  /* Clear the temp-table */
  EMPTY TEMP-TABLE ttTransItems.

  DO iSeq = 1 TO NUM-ENTRIES(gcFieldList):
    /* Add the translatable fields */
    CREATE ttTransItems.
    ASSIGN ttTransItems.iFieldSeq   = iSeq
           ttTransItems.cFieldName  = ENTRY(iSeq,gcFieldList)
           ttTransItems.cFieldLabel = ENTRY(iSeq,gcFieldLabels)
           ttTransItems.cFieldType  = ENTRY(iSeq,gcFieldTypes).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeBrowseColumns vTableWin 
PROCEDURE resizeBrowseColumns :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE dAveWidth AS DECIMAL    NO-UNDO.

  IF NOT VALID-HANDLE(ghBrowse) THEN
    RETURN.

  IF VALID-HANDLE(ghFieldLabel) THEN
    ghFieldLabel:WIDTH = 30.

  dAveWidth = (ghBrowse:WIDTH - ghFieldLabel:WIDTH) / 2.
  IF VALID-HANDLE(ghOrigText) THEN
    ghOrigText:WIDTH = dAveWidth.
  IF VALID-HANDLE(ghTransText) THEN
    ghTransText:WIDTH = dAveWidth.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject vTableWin 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdHeight AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdWidth  AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE dAveWidth AS DECIMAL    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    IF pdHeight > FRAME {&FRAME-NAME}:HEIGHT THEN DO:
      ASSIGN FRAME {&FRAME-NAME}:HEIGHT = pdHeight
             RECT-3:ROW                 = pdHeight - RECT-3:HEIGHT + .5
             fiFromLanguage:ROW         = RECT-3:ROW + .28
             fiToLanguage:ROW           = RECT-3:ROW + .28
             EdFromText:ROW             = RECT-3:ROW + 1.38
             EdToText:ROW               = RECT-3:ROW + 1.38
             RECT-2:HEIGHT              = RECT-3:ROW - 3.58
             buImage1:ROW        = EdFromText:ROW + EdFromText:HEIGHT + .10
             fiImageTextFrom:ROW = EdFromText:ROW + EdFromText:HEIGHT + .38
             buImage2:ROW        = EdToText:ROW + EdToText:HEIGHT + .10
             fiImageTextTo:ROW   = EdToText:ROW + EdToText:HEIGHT + .38.
      IF VALID-HANDLE(ghBrowse) THEN
        ghBrowse:HEIGHT-CHARS = RECT-2:HEIGHT - 1.5.
    END.
    ELSE DO:
      IF pdHeight < FRAME {&FRAME-NAME}:HEIGHT THEN DO:
        ASSIGN RECT-2:HEIGHT       = RECT-2:HEIGHT - (FRAME {&FRAME-NAME}:HEIGHT - pdHeight)
               RECT-3:ROW          = RECT-2:ROW + RECT-2:HEIGHT + .01
               fiFromLanguage:ROW  = RECT-3:ROW + .28
               fiToLanguage:ROW    = RECT-3:ROW + .28
               EdFromText:ROW      = RECT-3:ROW + 1.38
               EdToText:ROW        = RECT-3:ROW + 1.38
               buImage1:ROW        = EdFromText:ROW + EdFromText:HEIGHT + .10
               fiImageTextFrom:ROW = EdFromText:ROW + EdFromText:HEIGHT + .38
               buImage2:ROW        = EdToText:ROW + EdToText:HEIGHT + .10
               fiImageTextTo:ROW   = EdToText:ROW + EdToText:HEIGHT + .38.
        IF VALID-HANDLE(ghBrowse) THEN
          ghBrowse:HEIGHT-CHARS = RECT-2:HEIGHT - 1.5.
        
        FRAME {&FRAME-NAME}:HEIGHT = pdHeight.
      END.
    END.
    IF pdWidth <> FRAME {&FRAME-NAME}:HEIGHT THEN DO:
      IF pdWidth > FRAME {&FRAME-NAME}:WIDTH THEN
        ASSIGN FRAME {&FRAME-NAME}:WIDTH = pdWidth.
      ASSIGN RECT-1:WIDTH              = pdWidth - 2.4
             RECT-2:WIDTH              = pdWidth - 2.4
             RECT-3:WIDTH              = pdWidth - 2.4
             dAveWidth                 = (pdWidth - 5) / 2
             edFromText:WIDTH          = dAveWidth
             edToText:WIDTH            = dAveWidth
             fiFromLanguage:WIDTH      = dAveWidth
             fiToLanguage:WIDTH        = dAveWidth
             edToText:COL              = edFromText:COL + edFromText:WIDTH + 0.4
             fiToLanguage:COL          = edToText:COL
             fiImageTextFrom:COL       = edFromText:COL 
             buImage1:COL              = edFromText:COL + fiImageTextFrom:WIDTH + .02
             fiImageTextTo:COL         = edToText:COL
             buImage2:COL              = edToText:COL + fiImageTextTo:WIDTH + .02.
      IF VALID-HANDLE(ghBrowse) THEN
        ghBrowse:WIDTH-CHARS      = RECT-2:WIDTH - 1.
      IF pdWidth < FRAME {&FRAME-NAME}:WIDTH THEN
        ASSIGN FRAME {&FRAME-NAME}:WIDTH = pdWidth.
    END.
  END.
  
  VIEW FRAME {&FRAME-NAME}.
  
  IF gcColSizes = "":U OR
     gcColSizes = ? THEN
    RUN resizeBrowseColumns.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowDisplay vTableWin 
PROCEDURE rowDisplay :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowLeave vTableWin 
PROCEDURE rowLeave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  IF AVAILABLE ttTransItems THEN DO:
    IF ttTransItems.cOriginalText <> ghOrigText:SCREEN-VALUE THEN DO:
      ASSIGN ttTransItems.cOriginalText = ghOrigText:SCREEN-VALUE.
      {set DataModified TRUE}.
    END.
    IF ttTransItems.cTranslatedText <> ghTransText:SCREEN-VALUE THEN DO:
      ASSIGN ttTransItems.cTranslatedText = ghTransText:SCREEN-VALUE.
      {set DataModified TRUE}.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveChanges vTableWin 
PROCEDURE saveChanges :
/*------------------------------------------------------------------------------
  Purpose:     Save or Add translated menu item records
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dTranslatedLanguage AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cButton             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrorMessage       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hBuffer             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hCurField           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataSource         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNewValues          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyValues          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCols               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSuccess            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lValuesExist        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lRowAvailable       AS LOGICAL    NO-UNDO.

  /* Ensure screen values in dynamic browse are assigned to temp table buffer */
  APPLY "ROW-LEAVE":U TO ghBrowse.

  /* Get data value from User Smart Data Field */
  dTranslatedLanguage = gdToLanguageObj.
  
  gdLastSelLangObj = gdToLanguageObj.

  /* If not 'To Language' specified, we cannot save the details */
  IF dTranslatedLanguage = 0 THEN
  DO:
      cErrorMessage   = cErrorMessage 
                      + (IF NUM-ENTRIES(cErrorMessage,CHR(3)) > 0 THEN CHR(3) ELSE '':U)                   
                      + {af/sup2/aferrortxt.i 'AF' '1' '' '' '"Language to Translate to"'}.

      RUN showMessages IN gshSessionManager (INPUT cErrorMessage,
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Translate Language Required",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
      ERROR-STATUS:ERROR = NO.
      RETURN NO-APPLY.

  END.
  
  IF NOT TRANSACTION THEN EMPTY TEMP-TABLE ttTranslatedMenuItem. ELSE FOR EACH ttTranslatedMenuItem: DELETE ttTranslatedMenuItem. END.

  FIND FIRST ttAvailTrans
       WHERE ttAvailTrans.dLanguageObj = dTranslatedLanguage
       NO-LOCK NO-ERROR.
  
  {get DataSource hDataSource}.

  cNewValues = "":U.
  FOR EACH ttTransItems NO-LOCK:
    IF ttTransItems.cTranslatedText <> "":U THEN
      lValuesExist = TRUE.
    cNewValues = IF cNewValues = "":U 
                 THEN ttTransItems.cFieldName + CHR(1) + ttTransItems.cTranslatedText 
                 ELSE cNewValues + CHR(1) + ttTransItems.cFieldName + CHR(1) + ttTransItems.cTranslatedText.
  END.
          
  IF AVAILABLE ttAvailTrans THEN DO:
    DYNAMIC-FUNCTION("setQueryWhere":U IN hDataSource, "":U).
    /* Re-initialze the SDO to get the query back to a normal state */
    DYNAMIC-FUNCTION('assignQuerySelection':U IN hDataSource, "gsm_translated_menu_item.translated_menu_item_obj" , STRING(ttAvailTrans.dTransObj), '':U).
    DYNAMIC-FUNCTION('openQuery':U IN hDataSource). 
    RUN fetchFirst IN hDataSource.
    lRowAvailable = DYNAMIC-FUNCTION("rowAvailable":U IN hDataSource, "CURRENT":U).
    IF lValuesExist AND lRowAvailable THEN
      DYNAMIC-FUNCTION("updateRow":U IN hDataSource, ?, cNewValues).
    ELSE /* If nothing is translated - delete record */
      DYNAMIC-FUNCTION("deleteRow":U IN hDataSource, ?).
  END.
  ELSE DO:
    IF lValuesExist THEN DO:
      cCols = DYNAMIC-FUNCTION("AddRow":U IN hDataSource,"gsm_translated_menu_item.menu_item_obj":U).
      
      ASSIGN cCols = ENTRY(1,cCols,CHR(1))
             cCols = ENTRY(1,cCols).   /* RowIdent */
      ASSIGN cKeyValues = "menu_item_obj" + CHR(1) + STRING(gdMenuItemObj)
             cKeyValues = cKeyValues + CHR(1) + "source_language_obj" + CHR(1) + STRING(gdSourceLanguage)
             cKeyValues = cKeyValues + CHR(1) + "language_obj" + CHR(1) + STRING(dTranslatedLanguage).
      cNewValues = IF cNewValues = "":U 
                   THEN cKeyValues
                   ELSE cNewValues + CHR(1) + cKeyValues.
      /* Submit the row to be added */
      lSuccess = DYNAMIC-FUNCTION("SubmitRow":U IN hDataSource, cCols,cNewValues).
    END.
  END.

  ASSIGN glDoUpdate = FALSE.
  {set dataModified FALSE}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startSearch vTableWin 
PROCEDURE startSearch :
/*------------------------------------------------------------------------------
  Purpose:     Procedure for 'ROW-LEAVE' browser event
  Parameters:  <none>
  Notes:       Implements column sorting
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hColumn AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRow    AS ROWID      NO-UNDO.
  DEFINE VARIABLE cSortBy AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery  AS CHARACTER  NO-UNDO.

  /* Get handle to current column and save current position in browser */
  ASSIGN
      hColumn = ghBrowse:CURRENT-COLUMN
      rRow    = ghBuffer:ROWID.

  /* Handle to current column is valid */
  IF VALID-HANDLE(hColumn ) THEN
  DO:
      /* Construct sort string */
      ASSIGN
          cSortBy = (IF hColumn:TABLE <> ? THEN
                        hColumn:TABLE + '.':U + hColumn:NAME
                     ELSE hColumn:NAME).
      /* Construct query string using sort string, then open query */
      ASSIGN cQuery = "FOR EACH ":U + ghBuffer:NAME + " NO-LOCK BY ":U + cSortBy.

      IF ghQuery:IS-OPEN THEN
          ghQuery:QUERY-CLOSE().
      ghQuery:QUERY-PREPARE(cQuery).
      ghQuery:QUERY-OPEN().

      /* If new result set contains data, then reposition to the record in the browser saved in rRow */
      IF ghQuery:NUM-RESULTS > 0 THEN
      DO:
          ghQuery:REPOSITION-TO-ROWID(rRow) NO-ERROR.
          ghBrowse:CURRENT-COLUMN = hColumn.
          APPLY 'VALUE-CHANGED':U TO ghBrowse.
      END.

  END.

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

  /* Code placed here will execute PRIOR to standard behavior. */

  /*RUN SUPER.*/
  APPLY "CHOOSE":U TO buSave IN FRAME {&FRAME-NAME}.

  /* Code placed here will execute AFTER standard behavior.    */

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
  
  IF pcState = "UpdateComplete":U AND glDoUpdate THEN DO:
    RUN saveChanges.
    DISABLE buSave WITH FRAME {&FRAME-NAME}.
  END.
  IF pcState = "Update":U THEN DO:
    glDoUpdate = TRUE.
    ENABLE buSave WITH FRAME {&FRAME-NAME}.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataModified vTableWin 
FUNCTION setDataModified RETURNS LOGICAL
  ( INPUT plModified AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RETURN SUPER( INPUT plModified ).
 /* commented away because it gives warning as it is never reached... 
  IF plModified THEN
    ENABLE buSave WITH FRAME {&FRAME-NAME}.
  ELSE
    DISABLE buSave WITH FRAME {&FRAME-NAME}.
  */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

