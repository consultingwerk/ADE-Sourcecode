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
       {"ry/obj/rycsoful2o.i"}.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/****************************************************************************
* Copyright (C) 1984-2005,2007 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions               *
* contributed by participants of Possenet.                                  *
*                                                                           *
****************************************************************************/
/*---------------------------------------------------------------------------------
  File: rysdflkupv.w

  Description:  Dynamic Lookup SmartObject (Viewe)

  Purpose:      Dynamic Lookup SmartObject (Viewe)

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/04/2002  Author:     Mark Davies (MIP)

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

&scop object-name       rysdfcombv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}
{checkerr.i &define-only = YES}

DEFINE VARIABLE gcBrowseFields         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBrowseFieldDataTypes AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBrowseFieldFormats   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLinkedFieldDataTypes AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLinkedFieldFormats   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcViewerLinkedFields   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcViewerLinkedWidgets  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSaveDisplayField     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcColumnLabels         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcColumnFormat         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcNameList             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcFormatList           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcTypeList             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLabelList            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcCLabelList           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDisplayFormat        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDisplayDataType      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSessionResultCodes   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gdCurrentUserObj       AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdCurrentLanguageObj   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE ghBufferCacheBuffer    AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcLogicalObjectName    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE giLastSelectedPage     AS INTEGER    NO-UNDO.
DEFINE VARIABLE ghContainerSource      AS HANDLE     NO-UNDO.
DEFINE VARIABLE glTrackChanges         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE gcDataSourceName       AS CHARACTER  NO-UNDO.
 
DEFINE VARIABLE gcQueryTables          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcPhysicalTableNames   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcTempTableNames       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glAssigned             AS LOGICAL    NO-UNDO.

/* temp-table for query field information */
DEFINE TEMP-TABLE ttFields NO-UNDO
FIELD cFieldName              AS CHARACTER    /* name of query field */
FIELD cFieldDataType          AS CHARACTER    /* data type */
FIELD cFieldFormat            AS CHARACTER    /* format */
FIELD cOrigLabel              AS CHARACTER    /* Original Column Label */
FIELD iDisplaySeq             AS INTEGER      /* if to be included in browser, sequence of field within browser */
INDEX idxFieldName cFieldName
.

DEFINE VARIABLE ghDataTable AS HANDLE     NO-UNDO.


/* Used for Query Builder */
{ adecomm/tt-brws.i NEW}
{ adeshar/quryshar.i NEW }
DEFINE VARIABLE glQueryBuilder                AS LOGICAL    NO-UNDO.
DEFINE VARIABLE gcQueryBuilderJoinCode        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcQueryBuilderOptionList      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcQueryBuilderOrderList       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcQueryBuilderTableOptionList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcQueryBuilderTuneOptions     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcQueryBuilderWhereClauses    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBufferList                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcTempTableList               AS CHARACTER  NO-UNDO.

DEFINE TEMP-TABLE ttPLIP NO-UNDO
  FIELDS cPLIP    AS CHARACTER
  FIELDS hHandle  AS HANDLE
  INDEX  idx1     AS PRIMARY UNIQUE cPLIP.

DEFINE VARIABLE gFuncLibHdl      AS HANDLE                            NO-UNDO.

FUNCTION db-tbl-name RETURNS CHARACTER
        (INPUT cTableName     AS CHARACTER) IN gFuncLibHdl.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/rycsoful2o.i"

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frMain
&Scoped-define BROWSE-NAME BrBrowse

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttFields

/* Definitions for BROWSE BrBrowse                                      */
&Scoped-define FIELDS-IN-QUERY-BrBrowse ttFields.cFieldName ttFields.iDisplaySeq ttFields.cOrigLabel ttFields.cFieldDataType ttFields.cFieldFormat   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrBrowse ttFields.iDisplaySeq   
&Scoped-define ENABLED-TABLES-IN-QUERY-BrBrowse ttFields
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BrBrowse ttFields
&Scoped-define SELF-NAME BrBrowse
&Scoped-define QUERY-STRING-BrBrowse FOR EACH ttFields BY ttFields.cFieldName INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrBrowse OPEN QUERY {&SELF-NAME} FOR EACH ttFields BY ttFields.cFieldName INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrBrowse ttFields
&Scoped-define FIRST-TABLE-IN-QUERY-BrBrowse ttFields


/* Definitions for FRAME frMain                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-frMain ~
    ~{&OPEN-QUERY-BrBrowse}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS EdQuery buClear fiResizeBar 
&Scoped-Define DISPLAYED-OBJECTS EdQuery seQueryTables fiResizeBar ~
fiBaseQueryLabel fiQTables 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataTable vTableWin 
FUNCTION getDataTable RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFuncLibHandle vTableWin 
FUNCTION getFuncLibHandle RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataSourceName vTableWin 
FUNCTION setDataSourceName RETURNS LOGICAL
  ( INPUT pcDataSourceName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD sortString vTableWin 
FUNCTION sortString RETURNS CHARACTER
  ( pcSortPhrase AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-EdQuery-2 
       MENU-ITEM m_Query_Builder-2 LABEL "&Query Builder"
       MENU-ITEM m_Define_Buffers-2 LABEL "Define &Buffers"
       MENU-ITEM m_Define_Temp_Tables LABEL "Define &Temp Tables".


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hafspfoldrw AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buClear 
     LABEL "&Clear" 
     SIZE 15 BY 1.14 TOOLTIP "Clear all settings"
     BGCOLOR 8 .

DEFINE BUTTON buRefresh 
     LABEL "&Refresh" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE EdQuery AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 108.4 BY 3.33 TOOLTIP "Right-click to define a buffer, temp-table or to activate the query builder".

DEFINE VARIABLE fiBaseQueryLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Specify base query string (FOR EACH)" 
      VIEW-AS TEXT 
     SIZE 42.8 BY .62 NO-UNDO.

DEFINE VARIABLE fiQTables AS CHARACTER FORMAT "X(35)":U INITIAL "Query tables" 
      VIEW-AS TEXT 
     SIZE 13.6 BY .62 NO-UNDO.

DEFINE VARIABLE fiResizeBar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 146.8 BY .19 NO-UNDO.

DEFINE VARIABLE seQueryTables AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 37.6 BY 2.1
     FONT 3 NO-UNDO.

DEFINE VARIABLE coKeyField AS CHARACTER FORMAT "X(256)":U 
     LABEL "Key field" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "x","x"
     DROP-DOWN-LIST
     SIZE 70 BY 1 TOOLTIP "Field to assign to external field" NO-UNDO.

DEFINE VARIABLE fiBuildSeq AS INTEGER FORMAT "->>9":U INITIAL 0 
     LABEL "Build sequence" 
     VIEW-AS FILL-IN 
     SIZE 12 BY 1 TOOLTIP "Sequence in which Dynamic Combos will be built" NO-UNDO.

DEFINE VARIABLE fiDescSubstitute AS CHARACTER FORMAT "X(70)":U 
     LABEL "Description substitute" 
     VIEW-AS FILL-IN 
     SIZE 70 BY 1 TOOLTIP "Specify the Description Substitute" NO-UNDO.

DEFINE VARIABLE fiFieldDatatype AS CHARACTER FORMAT "X(256)":U 
     LABEL "Datatype" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 TOOLTIP "Data type of key field and external field" NO-UNDO.

DEFINE VARIABLE fiFieldFormat AS CHARACTER FORMAT "X(256)":U 
     LABEL "For&mat" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 TOOLTIP "Format of key field and external field" NO-UNDO.

DEFINE VARIABLE fiFieldLabel AS CHARACTER FORMAT "X(256)":U 
     LABEL "Field &label" 
     VIEW-AS FILL-IN 
     SIZE 56 BY 1 TOOLTIP "Label for displayed field" NO-UNDO.

DEFINE VARIABLE fiFieldToolTip AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Tooltip" 
     VIEW-AS FILL-IN 
     SIZE 70 BY 1 TOOLTIP "Tooltip for displayed field" NO-UNDO.

DEFINE VARIABLE fiFieldWidth AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 50 
     LABEL "Field width" 
     VIEW-AS FILL-IN 
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE fiInnerLines AS INTEGER FORMAT "->9":U INITIAL 0 
     LABEL "Inner lines" 
     VIEW-AS FILL-IN 
     SIZE 9.4 BY 1 TOOLTIP "The number of visible inner lines for the Dynamic Combo" NO-UNDO.

DEFINE VARIABLE toDisplayField AS LOGICAL INITIAL NO 
     LABEL "Display field" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.2 BY .81 NO-UNDO.

DEFINE VARIABLE toEnableField AS LOGICAL INITIAL NO 
     LABEL "Enable field" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.8 BY .81 NO-UNDO.

DEFINE VARIABLE toLabel AS LOGICAL INITIAL NO 
     LABEL "No-label" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.8 BY .95 NO-UNDO.

DEFINE VARIABLE toSortfield AS LOGICAL INITIAL NO 
     LABEL "Sort" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.2 BY .81 NO-UNDO.

DEFINE VARIABLE EdParentFilterQuery AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 123.2 BY 2.19 TOOLTIP "Parent filter query addition." NO-UNDO.

DEFINE VARIABLE fiComboTypeLabel AS CHARACTER FORMAT "X(15)":U INITIAL "Combo type:" 
      VIEW-AS TEXT 
     SIZE 13.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiDefaultValue AS CHARACTER FORMAT "X(35)":U 
     LABEL "Default value" 
     VIEW-AS FILL-IN 
     SIZE 78.4 BY 1 TOOLTIP "Default value of combo when choosing <All> or <None>." NO-UNDO.

DEFINE VARIABLE fiParentField AS CHARACTER FORMAT "X(70)":U 
     LABEL "Parent fields" 
     VIEW-AS FILL-IN 
     SIZE 123.2 BY 1 TOOLTIP "The field name(s) for the parent field(s) that this lookup is dependant on." NO-UNDO.

DEFINE VARIABLE fiParentFilterQueryLabel AS CHARACTER FORMAT "X(35)":U INITIAL "Parent filter query:" 
      VIEW-AS TEXT 
     SIZE 17.8 BY 1 NO-UNDO.

DEFINE VARIABLE raFlag AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Data only", "",
"<All> and data", "A",
"<None> and data", "N"
     SIZE 78.8 BY .95 TOOLTIP "Add extra option on combo." NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrBrowse FOR 
      ttFields SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrBrowse vTableWin _FREEFORM
  QUERY BrBrowse NO-LOCK DISPLAY
      ttFields.cFieldName      FORMAT "X(50)":U  LABEL "Field name":U
      ttFields.iDisplaySeq     FORMAT ">>9":U    LABEL "Display seq.":U
      ttFields.cOrigLabel      FORMAT "X(35)":U  LABEL "Column label":U
      ttFields.cFieldDataType  FORMAT "X(15)":U  LABEL "Data type":U
      ttFields.cFieldFormat    FORMAT "X(30)":U  LABEL "Format":U
  ENABLE
      ttFields.iDisplaySeq
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 146.4 BY 5.29 ROW-HEIGHT-CHARS .62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     EdQuery AT ROW 1.67 COL 1.4 NO-LABEL
     seQueryTables AT ROW 1.67 COL 110.2 NO-LABEL NO-TAB-STOP 
     buClear AT ROW 3.86 COL 110.4
     buRefresh AT ROW 3.86 COL 132.6
     fiResizeBar AT ROW 5 COL 1 NO-LABEL NO-TAB-STOP 
     BrBrowse AT ROW 5.19 COL 1.4
     fiBaseQueryLabel AT ROW 1 COL 1.8 NO-LABEL
     fiQTables AT ROW 1 COL 108.2 COLON-ALIGNED NO-LABEL
     SPACE(23.60) SKIP(16.14)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .

DEFINE FRAME frPage2
     raFlag AT ROW 1.14 COL 22.6 NO-LABEL
     fiDefaultValue AT ROW 2.14 COL 20.6 COLON-ALIGNED
     fiParentField AT ROW 3.19 COL 20.6 COLON-ALIGNED
     EdParentFilterQuery AT ROW 4.24 COL 22.6 NO-LABEL
     fiParentFilterQueryLabel AT ROW 4.19 COL 2.8 COLON-ALIGNED NO-LABEL
     fiComboTypeLabel AT ROW 1.1 COL 7.4 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.8 ROW 11.81
         SIZE 145.2 BY 5.48.

DEFINE FRAME frPage1
     coKeyField AT ROW 1.1 COL 22.2 COLON-ALIGNED
     fiDescSubstitute AT ROW 2.14 COL 22.2 COLON-ALIGNED
     fiFieldLabel AT ROW 3.19 COL 22.2 COLON-ALIGNED
     fiFieldToolTip AT ROW 4.24 COL 22.2 COLON-ALIGNED
     fiInnerLines AT ROW 5.29 COL 22.2 COLON-ALIGNED
     toLabel AT ROW 3.24 COL 80.8
     fiFieldDatatype AT ROW 1 COL 109.8 COLON-ALIGNED NO-TAB-STOP 
     fiFieldFormat AT ROW 2.05 COL 109.8 COLON-ALIGNED
     fiFieldWidth AT ROW 3.1 COL 109.8 COLON-ALIGNED
     fiBuildSeq AT ROW 4.14 COL 109.8 COLON-ALIGNED
     toEnableField AT ROW 3.19 COL 124.6
     toDisplayField AT ROW 4.24 COL 124.6
     toSortfield AT ROW 5.29 COL 124.6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.8 ROW 11.86
         SIZE 145.2 BY 5.43.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/rycsoful2o.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/rycsoful2o.i}
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
         HEIGHT             = 16.81
         WIDTH              = 146.8.
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
/* REPARENT FRAME */
ASSIGN FRAME frPage1:FRAME = FRAME frMain:HANDLE
       FRAME frPage2:FRAME = FRAME frMain:HANDLE.

/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB BrBrowse fiResizeBar frMain */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR BROWSE BrBrowse IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       BrBrowse:ALLOW-COLUMN-SEARCHING IN FRAME frMain = TRUE
       BrBrowse:COLUMN-RESIZABLE IN FRAME frMain       = TRUE.

/* SETTINGS FOR BUTTON buRefresh IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       EdQuery:RETURN-INSERTED IN FRAME frMain  = TRUE
       EdQuery:POPUP-MENU IN FRAME frMain       = MENU POPUP-MENU-EdQuery-2:HANDLE.

/* SETTINGS FOR FILL-IN fiBaseQueryLabel IN FRAME frMain
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       fiBaseQueryLabel:PRIVATE-DATA IN FRAME frMain     = 
                "Specify base query string (FOR EACH)".

/* SETTINGS FOR FILL-IN fiQTables IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiQTables:PRIVATE-DATA IN FRAME frMain     = 
                "Query tables".

/* SETTINGS FOR FILL-IN fiResizeBar IN FRAME frMain
   ALIGN-L                                                              */
ASSIGN 
       fiResizeBar:HIDDEN IN FRAME frMain           = TRUE
       fiResizeBar:MOVABLE IN FRAME frMain          = TRUE.

/* SETTINGS FOR SELECTION-LIST seQueryTables IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME frPage1
   L-To-R,COLUMNS                                                       */
ASSIGN 
       FRAME frPage1:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fiDescSubstitute IN FRAME frPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiFieldDatatype IN FRAME frPage1
   NO-ENABLE                                                            */
ASSIGN 
       fiFieldDatatype:READ-ONLY IN FRAME frPage1        = TRUE.

/* SETTINGS FOR FILL-IN fiFieldFormat IN FRAME frPage1
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FRAME frPage2
   L-To-R,COLUMNS                                                       */
ASSIGN 
       EdParentFilterQuery:RETURN-INSERTED IN FRAME frPage2  = TRUE.

/* SETTINGS FOR FILL-IN fiComboTypeLabel IN FRAME frPage2
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fiComboTypeLabel:PRIVATE-DATA IN FRAME frPage2     = 
                "Combo type:".

/* SETTINGS FOR FILL-IN fiDefaultValue IN FRAME frPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiParentFilterQueryLabel IN FRAME frPage2
   NO-ENABLE                                                            */
ASSIGN 
       fiParentFilterQueryLabel:PRIVATE-DATA IN FRAME frPage2     = 
                "Parent filter query:".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrBrowse
/* Query rebuild information for BROWSE BrBrowse
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttFields BY ttFields.cFieldName INDEXED-REPOSITION
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE BrBrowse */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME BrBrowse
&Scoped-define SELF-NAME BrBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BrBrowse vTableWin
ON LEAVE OF BrBrowse IN FRAME frMain
DO:
  /* We should re-build the displayed field list */
  DEFINE VARIABLE iLoop             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cDisplayedFields  AS CHARACTER  NO-UNDO.
  
  DEFINE BUFFER bttFields FOR ttFields.
  
  DO WITH FRAME frPage1:
    ASSIGN fiDescSubstitute = "":U.
    FOR EACH bttFields BY bttFields.iDisplaySeq:
      IF bttFields.iDisplaySeq > 0 THEN
        ASSIGN 
          cDisplayedFields  = cDisplayedFields +
                              (IF cDisplayedFields = "":U THEN "":U ELSE ",":U) +
                              bttFields.cFieldName
          gcDisplayFormat   = bttFields.cFieldFormat
          gcDisplayDataType = bttFields.cFieldDataType.
                                        
    END.
    DO iLoop = 1 TO NUM-ENTRIES(cDisplayedFields):
      ASSIGN fiDescSubstitute = fiDescSubstitute +
                                (IF fiDescSubstitute = "":U 
                                    THEN "&":U + STRING(iLoop)
                                    ELSE (IF iLoop = 1 THEN " - ":U ELSE " / ":U) + "&":U + STRING(iLoop)).
    END.
    IF (NUM-ENTRIES(fiDescSubstitute:SCREEN-VALUE,"&") - 1) = NUM-ENTRIES(cDisplayedFields) AND 
       fiDescSubstitute:SCREEN-VALUE <> fiDescSubstitute THEN
      fiDescSubstitute = fiDescSubstitute:SCREEN-VALUE.
    /* If more than one field is displayed in the combo 
       set the format to X(256) */
    IF NUM-ENTRIES(cDisplayedFields) > 1 THEN
      ASSIGN gcDisplayFormat   = "X(256)":U
             gcDisplayDataType = "CHARACTER":U.
  
             
    DISPLAY fiDescSubstitute.
  
    IF (iLoop - 1) > 1 THEN
      ENABLE fiDescSubstitute.
    ELSE
      DISABLE fiDescSubstitute.
  END.
  ASSIGN glAssigned = TRUE.
  RUN assignBrowseData.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BrBrowse vTableWin
ON ROW-LEAVE OF BrBrowse IN FRAME frMain
DO:
  APPLY "LEAVE":U TO SELF.
END.

ON 'VALUE-CHANGED':U OF ttFields.iDisplaySeq IN BROWSE brBrowse
DO:
    IF glTrackChanges THEN
        PUBLISH "changesMade":U FROM ghContainerSource.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BrBrowse vTableWin
ON START-SEARCH OF BrBrowse IN FRAME frMain
DO:
  DEFINE VARIABLE hColumn AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRow    AS ROWID      NO-UNDO.
  DEFINE VARIABLE cSortBy AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hQuery  AS HANDLE     NO-UNDO.
  ASSIGN
      hColumn = {&BROWSE-NAME}:CURRENT-COLUMN
      rRow    = ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
  IF VALID-HANDLE( hColumn ) THEN
  DO:
      ASSIGN
          cSortBy = (IF hColumn:TABLE <> ? THEN
                        hColumn:TABLE + '.':U + hColumn:NAME
                        ELSE hColumn:NAME)
          hQuery = {&browse-name}:QUERY              
          .
      hQuery:QUERY-PREPARE("FOR EACH ttFields BY ":U + cSortBy). 
      hQuery:QUERY-OPEN().
      IF NUM-RESULTS( '{&BROWSE-NAME}':U ) > 0 THEN
        DO:
          REPOSITION {&BROWSE-NAME} TO ROWID rRow NO-ERROR.
          {&BROWSE-NAME}:CURRENT-COLUMN = hColumn.
          APPLY 'VALUE-CHANGED':U TO {&BROWSE-NAME}.
        END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buClear
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buClear vTableWin
ON CHOOSE OF buClear IN FRAME frMain /* Clear */
DO:
  RUN clearAll.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRefresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRefresh vTableWin
ON CHOOSE OF buRefresh IN FRAME frMain /* Refresh */
DO:
  RUN populateCombo (INPUT FALSE).
  IF glTrackChanges THEN
    PUBLISH "changesMade":U FROM ghContainerSource.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frPage1
&Scoped-define SELF-NAME coKeyField
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coKeyField vTableWin
ON VALUE-CHANGED OF coKeyField IN FRAME frPage1 /* Key field */
DO:
  DEFINE VARIABLE iEntry AS INTEGER NO-UNDO.
  DEFINE VARIABLE cLabel AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      coKeyField
      iEntry = LOOKUP(coKeyField, gcNameList).
    IF iEntry > 0 THEN DO:
      ASSIGN
        fiFieldDataType:SCREEN-VALUE = ENTRY(iEntry,gcTypeList)
        fiFieldFormat:SCREEN-VALUE   = ENTRY(iEntry,gcFormatList,CHR(1))
        cLabel                       = ENTRY(iEntry,gcLabelList,CHR(1)).

      IF (cLabel <> "":U OR (cLabel = "":U AND iEntry <> 0)) AND (fiFieldLabel:SCREEN-VALUE = "":U OR gcSaveDisplayField <> coKeyField:SCREEN-VALUE) AND toLabel = FALSE THEN
        ASSIGN fiFieldLabel:SCREEN-VALUE = cLabel.
  
      ASSIGN gcSaveDisplayField = SELF:SCREEN-VALUE.
    END.
    ELSE
      ASSIGN
        fiFieldDataType:SCREEN-VALUE = "":U
        fiFieldFormat:SCREEN-VALUE = "":U
        .
  END.
  IF glTrackChanges THEN
    PUBLISH "changesMade":U FROM ghContainerSource.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frPage2
&Scoped-define SELF-NAME EdParentFilterQuery
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL EdParentFilterQuery vTableWin
ON VALUE-CHANGED OF EdParentFilterQuery IN FRAME frPage2
DO:
  IF glTrackChanges THEN
    PUBLISH "changesMade":U FROM ghContainerSource.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frMain
&Scoped-define SELF-NAME EdQuery
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL EdQuery vTableWin
ON ENTRY OF EdQuery IN FRAME frMain
DO:
  ASSIGN edQuery.
  IF glQueryBuilder OR
     edQuery:SCREEN-VALUE = "":U THEN
    DYNAMIC-FUNCTION("statusText":U IN ghContainerSource,"Right-Click or Double-Click on editor to launch the query builder.").  
  ELSE
    DYNAMIC-FUNCTION("statusText":U IN ghContainerSource,"":U).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL EdQuery vTableWin
ON LEAVE OF EdQuery IN FRAME frMain
DO:
  DYNAMIC-FUNCTION("statusText":U IN ghContainerSource,"":U).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL EdQuery vTableWin
ON MOUSE-SELECT-DBLCLICK OF EdQuery IN FRAME frMain
DO:
  RUN QueryBuilder.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL EdQuery vTableWin
ON VALUE-CHANGED OF EdQuery IN FRAME frMain
DO:
  DEFINE VARIABLE cAnswer AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton AS CHARACTER  NO-UNDO.

  IF glTrackChanges THEN
    PUBLISH "changesMade":U FROM ghContainerSource.
  IF glQueryBuilder THEN DO:
    RUN askQuestion IN gshSessionManager (INPUT        "If you change this query manually you will not be able to use the query builder to edit it.~n~nDo you wish to continue?",    /* message to display */
                                          INPUT        "&YES,&NO":U,    /* button list */
                                          INPUT        "&NO":U,                /* default button */ 
                                          INPUT        "&NO":U,             /* cancel button */
                                          INPUT        "Freeform Query":U, /* window title */
                                          INPUT        "":U,                    /* data type of question */ 
                                          INPUT        "":U,                    /* format mask for question */ 
                                          INPUT-OUTPUT cAnswer,                 /* character value of answer to question */ 
                                                OUTPUT cButton                  /* button pressed */
                                           ).
    IF cButton = "&YES":U THEN DO:
      ASSIGN gcQueryBuilderOptionList      = "":U
             gcQueryBuilderTableOptionList = "":U
             gcQueryBuilderOrderList       = "":U
             gcQueryBuilderTuneOptions     = "":U
             gcQueryBuilderJoinCode        = "":U 
             gcQueryBuilderWhereClauses    = "":U
             glQueryBuilder                = FALSE.
    END.
    ELSE DO:
      edQuery:SCREEN-VALUE = edQuery.
      RETURN NO-APPLY.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frPage1
&Scoped-define SELF-NAME fiBuildSeq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiBuildSeq vTableWin
ON VALUE-CHANGED OF fiBuildSeq IN FRAME frPage1 /* Build sequence */
DO:
  IF glTrackChanges THEN
    PUBLISH "changesMade":U FROM ghContainerSource.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frPage2
&Scoped-define SELF-NAME fiDefaultValue
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiDefaultValue vTableWin
ON VALUE-CHANGED OF fiDefaultValue IN FRAME frPage2 /* Default value */
DO:
  IF glTrackChanges THEN
    PUBLISH "changesMade":U FROM ghContainerSource.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frPage1
&Scoped-define SELF-NAME fiDescSubstitute
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiDescSubstitute vTableWin
ON VALUE-CHANGED OF fiDescSubstitute IN FRAME frPage1 /* Description substitute */
DO:
  IF glTrackChanges THEN
    PUBLISH "changesMade":U FROM ghContainerSource.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiFieldDatatype
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFieldDatatype vTableWin
ON VALUE-CHANGED OF fiFieldDatatype IN FRAME frPage1 /* Datatype */
DO:
  IF glTrackChanges THEN
    PUBLISH "changesMade":U FROM ghContainerSource.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiFieldFormat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFieldFormat vTableWin
ON VALUE-CHANGED OF fiFieldFormat IN FRAME frPage1 /* Format */
DO:
  IF glTrackChanges THEN
    PUBLISH "changesMade":U FROM ghContainerSource.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiFieldLabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFieldLabel vTableWin
ON VALUE-CHANGED OF fiFieldLabel IN FRAME frPage1 /* Field label */
DO:
  IF glTrackChanges THEN
    PUBLISH "changesMade":U FROM ghContainerSource.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiFieldToolTip
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFieldToolTip vTableWin
ON VALUE-CHANGED OF fiFieldToolTip IN FRAME frPage1 /* Tooltip */
DO:
  IF glTrackChanges THEN
    PUBLISH "changesMade":U FROM ghContainerSource.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiFieldWidth
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFieldWidth vTableWin
ON VALUE-CHANGED OF fiFieldWidth IN FRAME frPage1 /* Field width */
DO:
  IF glTrackChanges THEN
    PUBLISH "changesMade":U FROM ghContainerSource.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiInnerLines
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiInnerLines vTableWin
ON VALUE-CHANGED OF fiInnerLines IN FRAME frPage1 /* Inner lines */
DO:
  IF glTrackChanges THEN
    PUBLISH "changesMade":U FROM ghContainerSource.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frPage2
&Scoped-define SELF-NAME fiParentField
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiParentField vTableWin
ON VALUE-CHANGED OF fiParentField IN FRAME frPage2 /* Parent fields */
DO:
  IF glTrackChanges THEN
    PUBLISH "changesMade":U FROM ghContainerSource.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frMain
&Scoped-define SELF-NAME fiResizeBar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiResizeBar vTableWin
ON END-MOVE OF fiResizeBar IN FRAME frMain
DO:
  IF fiResizeBar:ROW < 5 THEN
    fiResizeBar:ROW = 5.

  IF (FRAME frPage1:ROW - (fiResizeBar:ROW + 0.19) - 1.24) <= 3.5 THEN
    fiResizeBar:ROW = FRAME frPage1:ROW - 1.24 - 3.5.

  RUN resizeViewerObjects (INPUT FRAME {&FRAME-NAME}:HEIGHT-CHARS, INPUT FRAME {&FRAME-NAME}:WIDTH-CHARS).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Define_Buffers-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Define_Buffers-2 vTableWin
ON CHOOSE OF MENU-ITEM m_Define_Buffers-2 /* Define Buffers */
DO:
  DEFINE VARIABLE lCancel AS LOGICAL    NO-UNDO.

  RUN ry/uib/rysdfbuffd.w (INPUT-OUTPUT gcBufferList,
                           OUTPUT       lCancel).
  IF lCancel THEN
    RETURN.
  RUN createBuffers.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Define_Temp_Tables
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Define_Temp_Tables vTableWin
ON CHOOSE OF MENU-ITEM m_Define_Temp_Tables /* Define Temp Tables */
DO:
  DEFINE VARIABLE lCancel AS LOGICAL    NO-UNDO.

  RUN ry/uib/rysdfttdfd.w (INPUT-OUTPUT gcTempTableList,
                           OUTPUT       lCancel).
  IF lCancel THEN
    RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Query_Builder-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Query_Builder-2 vTableWin
ON CHOOSE OF MENU-ITEM m_Query_Builder-2 /* Query Builder */
DO:
  RUN QueryBuilder.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frPage2
&Scoped-define SELF-NAME raFlag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL raFlag vTableWin
ON VALUE-CHANGED OF raFlag IN FRAME frPage2
DO:
  ASSIGN raFlag.
  IF raFlag = "":U THEN
    ASSIGN fiDefaultValue:SCREEN-VALUE = "":U
           fiDefaultValue:SENSITIVE    = FALSE.
  ELSE
    fiDefaultValue:SENSITIVE = TRUE.
  IF glTrackChanges THEN
    PUBLISH "changesMade":U FROM ghContainerSource.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frPage1
&Scoped-define SELF-NAME toDisplayField
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toDisplayField vTableWin
ON VALUE-CHANGED OF toDisplayField IN FRAME frPage1 /* Display field */
DO:
  IF toDisplayField:CHECKED = FALSE THEN
    ASSIGN toEnableField:CHECKED   = FALSE
           toEnableField:SENSITIVE = FALSE.
  ELSE
    ASSIGN toEnableField:CHECKED   = TRUE
           toEnableField:SENSITIVE = TRUE.
  
  IF glTrackChanges THEN
    PUBLISH "changesMade":U FROM ghContainerSource.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toEnableField
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toEnableField vTableWin
ON VALUE-CHANGED OF toEnableField IN FRAME frPage1 /* Enable field */
DO:
  IF glTrackChanges THEN
    PUBLISH "changesMade":U FROM ghContainerSource.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toLabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toLabel vTableWin
ON VALUE-CHANGED OF toLabel IN FRAME frPage1 /* No-label */
DO:
  ASSIGN toLabel.
  IF toLabel THEN DO:
    ASSIGN fiFieldLabel:SCREEN-VALUE = "":U.
    fiFieldLabel:SENSITIVE = FALSE.
  END.
  ELSE DO:
    APPLY "VALUE-CHANGED":U TO coKeyField.
    fiFieldLabel:SENSITIVE = fiFieldToolTip:SENSITIVE.
  END.
    
  APPLY "VALUE-CHANGED":U TO fiFieldLabel.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toSortfield
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toSortfield vTableWin
ON VALUE-CHANGED OF toSortfield IN FRAME frPage1 /* Sort */
DO:
  IF toDisplayField:CHECKED = FALSE THEN
    ASSIGN toEnableField:CHECKED   = FALSE
           toEnableField:SENSITIVE = FALSE.
  ELSE
    ASSIGN toEnableField:CHECKED   = TRUE
           toEnableField:SENSITIVE = TRUE.
  
  IF glTrackChanges THEN
    PUBLISH "changesMade":U FROM ghContainerSource.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frMain
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
             INPUT  'af/sup2/afspfoldrw.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FolderLabels':U + '&Details|&Other' + 'TabFGcolor':U + 'Default|Default' + 'TabBGcolor':U + 'Default|Default' + 'TabINColor':U + 'GrayText|GrayText' + 'ImageEnabled':U + '' + 'ImageDisabled':U + '' + 'Hotkey':U + '' + 'Tooltip':U + 'Dynamic Lookup Details|Other Details' + 'TabHidden':U + 'no|no' + 'EnableStates':U + 'All|All' + 'DisableStates':U + 'All|All' + 'VisibleRows':U + '10' + 'PanelOffset':U + '20' + 'FolderMenu':U + '' + 'TabsPerRow':U + '8' + 'TabHeight':U + '3' + 'TabFont':U + '4' + 'LabelOffset':U + '0' + 'ImageWidth':U + '0' + 'ImageHeight':U + '0' + 'ImageXOffset':U + '0' + 'ImageYOffset':U + '2' + 'TabSize':U + 'Proportional' + 'SelectorFGcolor':U + 'Default' + 'SelectorBGcolor':U + 'Default' + 'SelectorFont':U + '4' + 'SelectorWidth':U + '3' + 'TabPosition':U + 'Upper' + 'MouseCursor':U + '' + 'InheritColor':U + 'no' + 'TabVisualization':U + 'TABS' + 'PopupSelectionEnabled':U + 'yes' + 'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hafspfoldrw ).
       RUN repositionObject IN hafspfoldrw ( 10.71 , 1.00 ) NO-ERROR.
       RUN resizeObject IN hafspfoldrw ( 7.05 , 146.40 ) NO-ERROR.

       /* Links to SmartFolder hafspfoldrw. */
       RUN addLink ( hafspfoldrw , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( hafspfoldrw ,
             BrBrowse:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignBrowseData vTableWin 
PROCEDURE assignBrowseData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iEntry AS INTEGER    NO-UNDO.

  DEFINE VARIABLE cBrowseFields         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBrowseFieldDataTypes AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBrowseFieldFormats   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkedFieldDataTypes AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkedFieldFormats   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cViewerLinkedFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cViewerLinkedWidgets  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnLabels         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnFormat         AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bttFields FOR ttFields.

  /* work out rest of values from temp-table, etc. */
  APPLY "row-leave":U TO BROWSE {&browse-name}.
  
  /* Assign Old Values to determine if something changed */
  ASSIGN cBrowseFields         = gcBrowseFields        
         cBrowseFieldDataTypes = gcBrowseFieldDataTypes
         cBrowseFieldFormats   = gcBrowseFieldFormats.

  IF NUM-ENTRIES(cBrowseFields) = 1 THEN
    ASSIGN 
      gcDisplayFormat   = "X(256)":U
      gcDisplayDataType = "CHARACTER":U
      .
  ELSE DO:
    ASSIGN iEntry = LOOKUP(cBrowseFields, gcNameList).
    IF iEntry > 0 THEN
      ASSIGN 
        gcDisplayFormat = ENTRY(iEntry, gcFormatList,CHR(1))
        gcDisplayDataType = ENTRY(iEntry, gcTypeList)
        .
  END.

  ASSIGN gcBrowseFields         = "":U
         gcBrowseFieldDataTypes = "":U
         gcBrowseFieldFormats   = "":U.

  FOR EACH bttFields BY bttFields.iDisplaySeq:
    IF bttFields.iDisplaySeq > 0 THEN
      ASSIGN
        gcBrowseFields = gcBrowseFields +
                         (IF gcBrowseFields = "":U THEN "":U ELSE ",":U) +
                         bttFields.cFieldName
        gcBrowseFieldDataTypes = gcBrowseFieldDataTypes +
                         (IF gcBrowseFieldDataTypes = "":U THEN "":U ELSE ",":U) +
                         bttFields.cFieldDataType
        gcBrowseFieldFormats = gcBrowseFieldFormats +
                         (IF gcBrowseFieldFormats = "":U THEN "":U ELSE "|":U) +
                         bttFields.cFieldFormat
        .                         
  END.

  IF cBrowseFields         <> gcBrowseFields         OR
     cBrowseFieldDataTypes <> gcBrowseFieldDataTypes OR
     cBrowseFieldFormats   <> gcBrowseFieldFormats   THEN
    IF glTrackChanges THEN
      PUBLISH "changesMade":U FROM ghContainerSource.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignBuffTT vTableWin 
PROCEDURE assignBuffTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iLoop        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTableName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cActualTable AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPlipName    AS CHARACTER  NO-UNDO.

  IF gcBufferList = "":U AND
     gcTempTableList = "":U THEN
    RETURN.

  ASSIGN gcPhysicalTableNames = "":U
         gcTempTableNames     = "":U.
  
  IF gcQueryTables = "":U THEN
    RETURN.
  
  /* Buffers */
  IF gcBufferList <> "":U THEN DO:
    ASSIGN gcPhysicalTableNames = FILL(",":U,NUM-ENTRIES(gcQueryTables) - 1).
    DO iLoop = 1 TO NUM-ENTRIES(gcBufferList):
      ASSIGN cTableName   = TRIM(ENTRY(iLoop,gcBufferList))
             cActualTable = TRIM(ENTRY(iLoop + 1,gcBufferList)).
      IF LOOKUP(cTableName,gcQueryTables) > 0 THEN 
        ENTRY(LOOKUP(cTableName,gcQueryTables),gcPhysicalTableNames) = cActualTable.
      iLoop = iLoop + 1.
    END.
  END.

  /* Temp Tables */
  IF gcTempTableList <> "":U THEN DO:
    ASSIGN gcTempTableNames = FILL(",":U,NUM-ENTRIES(gcQueryTables) - 1).
    DO iLoop = 1 TO NUM-ENTRIES(gcTempTableList):
      ASSIGN cTableName = TRIM(ENTRY(1,ENTRY(iLoop,gcTempTableList),"^":U))
             cPlipName  = TRIM(ENTRY(2,ENTRY(iLoop,gcTempTableList),"^":U)).
      IF LOOKUP(cTableName,gcQueryTables) > 0 THEN 
        ENTRY(LOOKUP(cTableName,gcQueryTables),gcTempTableNames) = cPlipName.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignValues vTableWin 
PROCEDURE assignValues :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will assing the values back to the temp-table to
               save back to the repository.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DO WITH FRAME {&FRAME-NAME}:
    /* Remove trailing colons and full stops */
    ASSIGN
      edQuery:SCREEN-VALUE = TRIM(edQuery:SCREEN-VALUE)
      edQuery:SCREEN-VALUE = TRIM(edQuery:SCREEN-VALUE,":":U)
      edQuery:SCREEN-VALUE = TRIM(edQuery:SCREEN-VALUE,".":U)
      .
  
    ASSIGN
      EdQuery 
      seQueryTables.
    ASSIGN gcQueryTables = seQueryTables:LIST-ITEMS.
  END.
  DO WITH FRAME frPage1:
    ASSIGN coKeyField 
           fiDescSubstitute
           fiFieldDatatype 
           fiFieldFormat 
           fiFieldLabel
           fiFieldToolTip 
           fiFieldWidth
           fiInnerLines
           fiBuildSeq
           toDisplayField
           toEnableField
           toSortField.
  END.
  DO WITH FRAME frPage2:
    ASSIGN raFlag
           fiDefaultValue
           fiParentField
           edParentFilterQuery.
  END.
  ASSIGN fiDefaultValue.
  IF fiDefaultValue = ? THEN
    fiDefaultValue = "?":U.

  IF NOT glAssigned THEN
      RUN assignBrowseData.
  ASSIGN glAssigned = FALSE.

  ghDataTable:FIND-FIRST().
  IF NOT ghDataTable:AVAILABLE THEN
    RETURN "SAVE-FAILED":U.
  
  RUN assignBuffTT.
  
  ASSIGN
      ghDataTable:BUFFER-FIELD("cBaseQueryString":U):BUFFER-VALUE    = edQuery 
      ghDataTable:BUFFER-FIELD('cQueryTables':U):BUFFER-VALUE        = IF gcDataSourceName = "":U THEN seQueryTables:LIST-ITEMS 
                                                                       ELSE "":U
      ghDataTable:BUFFER-FIELD('cPhysicalTableNames':U):BUFFER-VALUE = gcPhysicalTableNames
      ghDataTable:BUFFER-FIELD('cTempTables':U):BUFFER-VALUE         = gcTempTableNames
      ghDataTable:BUFFER-FIELD('cDisplayDataType':U):BUFFER-VALUE    = IF gcDataSourceName = "":U THEN gcDisplayDataType
                                                                       ELSE "":U  
      ghDataTable:BUFFER-FIELD("cKeyFormat":U):BUFFER-VALUE          = IF gcDataSourceName = "":U THEN fiFieldFormat
                                                                       ELSE "":U
      ghDataTable:BUFFER-FIELD('cKeyDataType':U):BUFFER-VALUE        = IF gcDataSourceName = "":U THEN fiFieldDatatype
                                                                       ELSE "":U
      ghDataTable:BUFFER-FIELD("cDisplayFormat":U):BUFFER-VALUE      = IF gcDataSourceName = "":U THEN gcDisplayFormat 
                                                                       ELSE "":U
      ghDataTable:BUFFER-FIELD('cKeyField':U):BUFFER-VALUE           = coKeyField
      ghDataTable:BUFFER-FIELD('cDisplayedField':U):BUFFER-VALUE     = gcBrowseFields
      ghDataTable:BUFFER-FIELD('cDescSubstitute':U):BUFFER-VALUE     = fiDescSubstitute
      ghDataTable:BUFFER-FIELD('cFieldLabel':U):BUFFER-VALUE         = fiFieldLabel
      ghDataTable:BUFFER-FIELD('lLabels':U):BUFFER-VALUE             = (fiFieldLabel NE "":U)
      ghDataTable:BUFFER-FIELD('cFieldTooltip':U):BUFFER-VALUE       = fiFieldTooltip
      ghDataTable:BUFFER-FIELD('dFieldWidth':U):BUFFER-VALUE         = fiFieldWidth
      ghDataTable:BUFFER-FIELD('cComboFlag':U):BUFFER-VALUE          = raFlag
      ghDataTable:BUFFER-FIELD('cFlagValue':U):BUFFER-VALUE          = IF fiFieldDataType = "DECIMAL":U THEN
                                                                          REPLACE(STRING(DECIMAL(fiDefaultValue)),SESSION:NUMERIC-DECIMAL-POINT,".":U)
                                                                       ELSE fiDefaultValue
      ghDataTable:BUFFER-FIELD('iInnerLines':U):BUFFER-VALUE         = fiInnerLines
      ghDataTable:BUFFER-FIELD('iBuildSequence':U):BUFFER-VALUE      = fiBuildSeq
      ghDataTable:BUFFER-FIELD('cParentFilterQuery':U):BUFFER-VALUE  = edParentFilterQuery
      ghDataTable:BUFFER-FIELD('cParentField':U):BUFFER-VALUE        = fiParentField
      ghDataTable:BUFFER-FIELD('lEnableField':U):BUFFER-VALUE        = toEnableField
      ghDataTable:BUFFER-FIELD('lDisplayField':U):BUFFER-VALUE       = toDisplayField
      ghDataTable:BUFFER-FIELD('lSort':U):BUFFER-VALUE               = toSortField
      ghDataTable:BUFFER-FIELD('cDataSourceName':U):BUFFER-VALUE     = gcDataSourceName
      ghDataTable:BUFFER-FIELD('cQueryBuilderJoinCode':U):BUFFER-VALUE        = gcQueryBuilderJoinCode       
      ghDataTable:BUFFER-FIELD('cQueryBuilderOptionList':U):BUFFER-VALUE      = gcQueryBuilderOptionList     
      ghDataTable:BUFFER-FIELD('cQueryBuilderTableOptionList':U):BUFFER-VALUE = gcQueryBuilderTableOptionList
      ghDataTable:BUFFER-FIELD('cQueryBuilderOrderList':U):BUFFER-VALUE       = gcQueryBuilderOrderList      
      ghDataTable:BUFFER-FIELD('cQueryBuilderTuneOptions':U):BUFFER-VALUE     = gcQueryBuilderTuneOptions    
      ghDataTable:BUFFER-FIELD('cQueryBuilderWhereClauses':U):BUFFER-VALUE    = gcQueryBuilderWhereClauses.
      

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeSource vTableWin 
PROCEDURE changeSource :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcSource AS CHARACTER  NO-UNDO.

  IF pcSource = 'SDO':U THEN
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN 
      EdQuery:SCREEN-VALUE       = '':U
      seQueryTables:LIST-ITEMS   = "":U
      EdQuery:SENSITIVE          = FALSE
      fiBaseQueryLabel:SENSITIVE = FALSE 
      seQueryTables:SENSITIVE    = FALSE
      buClear:SENSITIVE          = FALSE
      fiQTables:SENSITIVE        = FALSE
      buRefresh:SENSITIVE        = FALSE.

  END.
  ELSE DO WITH FRAME {&FRAME-NAME}:
    ASSIGN 
      EdQuery:SENSITIVE          = TRUE
      fiBaseQueryLabel:SENSITIVE = TRUE 
      seQueryTables:SENSITIVE    = TRUE
      buClear:SENSITIVE          = TRUE
      fiQTables:SENSITIVE        = TRUE
      buRefresh:SENSITIVE        = TRUE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearAll vTableWin 
PROCEDURE clearAll :
/*------------------------------------------------------------------------------
  Purpose:     The header viewer will publish this event to clear the screen
               for new data.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Clear the screen and return */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN edQuery:SCREEN-VALUE     = "":U
           seQueryTables:LIST-ITEMS = "":U.

    ASSIGN gcQueryTables        = "":U
           gcBufferList         = "":U
           gcTempTableList      = "":U
           gcPhysicalTableNames = "":U
           gcTempTableNames     = "":U.
    FOR EACH _tt-tbl EXCLUSIVE-LOCK:
      DELETE _tt-tbl.
    END.
    EMPTY TEMP-TABLE ttFields.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  END.

  DO WITH FRAME frPage1:
    ASSIGN fiFieldLabel:SCREEN-VALUE     = "":U
           fiFieldTooltip:SCREEN-VALUE   = "":U
           fiFieldDataType:SCREEN-VALUE  = "":U
           fiFieldFormat:SCREEN-VALUE    = "":U
           fiFieldWidth:SCREEN-VALUE     = "":U
           fiInnerLines:SCREEN-VALUE     = "":U
           fiBuildSeq:SCREEN-VALUE       = "":U
           fiDescSubstitute:SCREEN-VALUE = "":U
           toEnableField:CHECKED         = TRUE
           toDisplayField:CHECKED        = TRUE
           toLabel:CHECKED               = FALSE.
      ASSIGN coKeyField:LIST-ITEM-PAIRS       = ?.
      DISABLE ALL WITH FRAME frPage1.
  END.
  DO WITH FRAME frPage2:
    ASSIGN raFlag:SCREEN-VALUE              = "":U
           fiDefaultValue:SCREEN-VALUE      = "":U
           edParentFilterQuery:SCREEN-VALUE = "":U
           fiParentField:SCREEN-VALUE       = "":U.
    DISABLE ALL WITH FRAME frPage2.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createBuffers vTableWin 
PROCEDURE createBuffers :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iLoop       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iFieldLoop  AS INTEGER    NO-UNDO.
  
  FOR EACH  _tt-tbl
      WHERE _tt-tbl.table-type = "B":U /* Buffers */
      EXCLUSIVE-LOCK:
    FOR EACH  _tt-fld
        WHERE _tt-fld.tt-recid = RECID(_tt-tbl)
        EXCLUSIVE-LOCK:
      DELETE _tt-fld.
    END.
    DELETE _tt-tbl.
  END.
  
  DO iLoop = 1 TO NUM-ENTRIES(gcBufferList):
    CREATE _tt-tbl.
    ASSIGN _tt-tbl.tt-name    = TRIM(ENTRY(iLoop,gcBufferList))
           _tt-tbl.like-db    = IF NUM-ENTRIES(TRIM(ENTRY(iLoop + 1,gcBufferList)),".":U) > 1 THEN ENTRY(1,TRIM(ENTRY(iLoop + 1,gcBufferList)),".":U) ELSE "ICFDB":U
           _tt-tbl.like-table = IF NUM-ENTRIES(TRIM(ENTRY(iLoop + 1,gcBufferList)),".":U) > 1 THEN ENTRY(2,TRIM(ENTRY(iLoop + 1,gcBufferList)),".":U) ELSE TRIM(ENTRY(iLoop + 1,gcBufferList))
           _tt-tbl.table-type = "B":U.
    iLoop = iLoop + 1.
  END.
  
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
  FOR EACH ttPLIP:
    IF VALID-HANDLE(ttPLIP.hHandle) THEN
      RUN killPlip IN ttPLIP.hHandle NO-ERROR.
  END.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN saveResizeBarRow.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableObject vTableWin 
PROCEDURE disableObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DISABLE ALL WITH FRAME {&FRAME-NAME}.
    DISABLE ALL WITH FRAME frPage1.
    DISABLE ALL WITH FRAME frPage2.

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
  HIDE FRAME frPage1.
  HIDE FRAME frPage2.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE hideObject vTableWin 
PROCEDURE hideObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  RUN selectPage (INPUT 1).
  
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  
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
  DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */

  {get ContainerSource ghContainerSource}.

  RUN SUPER.
  fiResizeBar:LOAD-MOUSE-POINTER("size-n":U) IN FRAME {&FRAME-NAME}.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN resizeObject (INPUT FRAME {&FRAME-NAME}:HEIGHT, INPUT FRAME {&FRAME-NAME}:WIDTH).
  RUN SelectPage (INPUT 1).
  ASSIGN fiParentFilterQueryLabel:SCREEN-VALUE IN FRAME frPage2 = "Parent filter query:":U
         fiComboTypeLabel:SCREEN-VALUE IN FRAME frPage2         = "Combo type:":U.

  {get ContainerSource hContainerSource}.
  IF VALID-HANDLE(hContainerSource) THEN DO:
    SUBSCRIBE TO "clearAll":U IN hContainerSource.
    SUBSCRIBE TO "disableObject":U IN hContainerSource.
  END.

  RUN setResizeBar.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pageSelected vTableWin 
PROCEDURE pageSelected :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER piPageNum AS INTEGER    NO-UNDO.

  CASE piPageNum:
    WHEN 1 THEN DO:
      ASSIGN FRAME frPage2:HIDDEN = TRUE.
      ASSIGN FRAME frPage1:HIDDEN = FALSE.
    END.
    WHEN 2 THEN DO:
      ASSIGN FRAME frPage1:HIDDEN = TRUE.
      ASSIGN FRAME frPage2:HIDDEN = FALSE.
    END.
  END CASE.

  giLastSelectedPage = piPageNum.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateCombo vTableWin 
PROCEDURE populateCombo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER plValidateOnly AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE cQuery                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBufferList                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValueList                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQueryValid                 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cValuePairs                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cField                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iBrowseEntry                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLinkedEntry                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cMessage                    AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hTempTable                  AS HANDLE     NO-UNDO EXTENT 10.
  DEFINE VARIABLE cTempTableName              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTempTablePLIP              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTempTablePLIPHandle        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cButton                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cError                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldKeyField                AS CHARACTER  NO-UNDO.

  DO WITH FRAME frPage1:
    cOldKeyField = coKeyField:SCREEN-VALUE.
  END.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      cQuery = TRIM(edQuery:SCREEN-VALUE)
      cQuery = TRIM(cQuery,":":U)
      cQuery = TRIM(cQuery,".":U)
      edQuery:SCREEN-VALUE = cQuery
      .
  END.
  /* Remove any Line Breaks */
  cQuery = REPLACE(cQuery,CHR(10)," ":U).

  /* Refresh query details by evaluating query */
  SESSION:SET-WAIT-STATE("general":U).
  IF gcTempTableList <> "":U THEN DO:
    DO iLoop = 1 TO NUM-ENTRIES(gcTempTableList):
      ASSIGN cTempTableName = ENTRY(1,ENTRY(iLoop,gcTempTableList),"^":U)
             cTempTablePLIP = ENTRY(2,ENTRY(iLoop,gcTempTableList),"^":U).
      FIND FIRST ttPLIP
           WHERE ttPLIP.cPLIP = cTempTablePLIP
           NO-LOCK NO-ERROR.
      IF AVAILABLE ttPLIP THEN
        hTempTablePLIPHandle = ttPLIP.hHandle.
      ELSE DO:
        IF SEARCH(cTempTablePLIP) = ? OR
           SEARCH(cTempTablePLIP) = "":U THEN DO:
          cValue = "the PLIP name specified '" + cTempTablePLIP + "' does not exist, or could not be found in the PROPATH.".
          cError = {af/sup2/aferrortxt.i 'AF' '15' '' '' "cValue"}.
          RUN showMessages IN gshSessionManager (INPUT cError,
                                                 INPUT "ERR":U,
                                                 INPUT "OK":U,
                                                 INPUT "OK":U,
                                                 INPUT "OK":U,
                                                 INPUT "Temp-Table PLIP Error",
                                                 INPUT YES,
                                                 INPUT ?,
                                                 OUTPUT cButton).
          RETURN "ERROR":U.
        END.
        RUN VALUE(cTempTablePLIP) PERSISTENT SET hTempTablePLIPHandle NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
          cValue = "the PLIP '" + cTempTablePLIP + "' returned the following errors: " + ERROR-STATUS:GET-MESSAGE(1).
          cError = {af/sup2/aferrortxt.i 'AF' '15' '' '' "cValue"}.
          RUN showMessages IN gshSessionManager (INPUT cError,
                                                 INPUT "ERR":U,
                                                 INPUT "OK":U,
                                                 INPUT "OK":U,
                                                 INPUT "OK":U,
                                                 INPUT "Temp-Table PLIP Error",
                                                 INPUT YES,
                                                 INPUT ?,
                                                 OUTPUT cButton).
          RETURN "ERROR":U.
        END.
        IF VALID-HANDLE(hTempTablePLIPHandle) THEN DO:
          CREATE ttPLIP.
          ASSIGN ttPLIP.cPLIP   = cTempTablePLIP
                 ttPLIP.hHandle = hTempTablePLIPHandle.
        END.
      END.
      IF NOT VALID-HANDLE(hTempTablePLIPHandle) THEN DO:
        cValue = "the PLIP '" + cTempTablePLIP + "' could not be run persistent.".
        cError = {af/sup2/aferrortxt.i 'AF' '15' '' '' "cValue"}.
        RUN showMessages IN gshSessionManager (INPUT cError,
                                               INPUT "ERR":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "Temp-Table PLIP Error",
                                               INPUT YES,
                                               INPUT ?,
                                               OUTPUT cButton).
        RETURN "ERROR":U.
      END.
      hTempTable[iLoop] = DYNAMIC-FUNCTION("get" + cTempTableName + "Handle":U IN hTempTablePLIPHandle) .
      IF ERROR-STATUS:ERROR THEN DO:
        cValue = "FUNCTION '" + "get" + cTempTableName + "Handle":U + "' in PLIP '" + cTempTablePLIP + "'".
        cError = {af/sup2/aferrortxt.i 'AF' '29' '' '' "cValue"}.
        RUN showMessages IN gshSessionManager (INPUT cError,
                                               INPUT "ERR":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "Temp-Table PLIP Error",
                                               INPUT YES,
                                               INPUT ?,
                                               OUTPUT cButton).
        RETURN "ERROR":U.
      END.
      IF NOT VALID-HANDLE( hTempTable[iLoop]) THEN DO:
        cValue = "the handle returned by FUNCTION '" + "get" + cTempTableName + "Handle":U + "' in PLIP '" + cTempTablePLIP + "' was invalid.".
        cError = {af/sup2/aferrortxt.i 'AF' '15' '' '' "cValue"}.
        RUN showMessages IN gshSessionManager (INPUT cError,
                                               INPUT "ERR":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "Temp-Table PLIP Error",
                                               INPUT YES,
                                               INPUT ?,
                                               OUTPUT cButton).
        RETURN "ERROR":U.
      END.
    END.
  END.
  /* Remove references to EXCLUDE_REPOSITORY_PRODUCTS and
     EXCLUDE_REPOSITORY_PRODUCT_MODULES */
  ASSIGN cQuery = REPLACE(cQuery,"[EXCLUDE_REPOSITORY_PRODUCTS]":U,"TRUE":U)
         cQuery = REPLACE(cQuery,"[EXCLUDE_REPOSITORY_PRODUCT_MODULES]":U,"TRUE":U).

  RUN processQueryStringFilterSets IN gshGenManager (INPUT  cQuery,
                                                     OUTPUT cQuery).

  RUN af/app/afqrydetlp.p (INPUT cQuery,
                           INPUT  gcBufferList, /* Buffers */
                           INPUT  TABLE-HANDLE hTempTable[1],
                           INPUT  TABLE-HANDLE hTempTable[2],
                           INPUT  TABLE-HANDLE hTempTable[3],
                           INPUT  TABLE-HANDLE hTempTable[4],
                           INPUT  TABLE-HANDLE hTempTable[5],
                           INPUT  TABLE-HANDLE hTempTable[6],
                           INPUT  TABLE-HANDLE hTempTable[7],
                           INPUT  TABLE-HANDLE hTempTable[8],
                           INPUT  TABLE-HANDLE hTempTable[9],
                           INPUT  TABLE-HANDLE hTempTable[10],
                           INPUT  TRUE,
                           OUTPUT lQueryValid,
                           OUTPUT cBufferList,
                           OUTPUT gcNameList,
                           OUTPUT gcFormatList,
                           OUTPUT gcTypeList,
                           OUTPUT gcLabelList,
                           OUTPUT gcCLabelList,
                           OUTPUT cValueList).
  SESSION:SET-WAIT-STATE("":U).

  IF NOT lQueryValid OR cBufferList = "":U THEN DO:
    cMessage = "Query specified is syntactically incorrect - please specify a valid query~n~n" +
               "Check the query starts with FOR EACH and does NOT end in a full stop or colon.~n" +
               "Also check you have not misspelled any table names or field names and that " +
               "you have not missed off any commas. Try pasting the query into the procedure " +
               "editor and syntax checking from there - if it works there it should work here " +
               "minus the colon and the end statement.".
    IF plValidateOnly THEN
      RETURN cMessage.
    ELSE
      MESSAGE cMessage
              VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    APPLY "ENTRY":U TO edQuery IN FRAME {&FRAME-NAME}.
    
    RETURN.
  END.
  ELSE
    IF plValidateOnly THEN
      RETURN.

  EMPTY TEMP-TABLE ttFields.

  DO WITH FRAME {&FRAME-NAME}:
    {&OPEN-QUERY-{&BROWSE-NAME}}
    DO WITH FRAME frPage1:
      coKeyField:LIST-ITEM-PAIRS = "x,x".
      coKeyField = "x".
      coKeyField:SCREEN-VALUE = coKeyField:SCREEN-VALUE.  
    END.
    seQueryTables:LIST-ITEMS = "":U.
    DISPLAY
      BrBrowse.
    DISABLE
      BrBrowse.
    DISPLAY coKeyField WITH FRAME frPage1.

    /* populate other fields */
    APPLY "value-changed" TO coKeyField IN FRAME frPage1.

    DO WITH FRAME frPage1:
      IF fiFieldTooltip:SCREEN-VALUE = "":U THEN
        fiFieldTooltip:SCREEN-VALUE = "Select option from list":U.
    END.

    /* Query is valid - rebuild screen values */
    ENABLE
      BrBrowse.
    ENABLE coKeyField WITH FRAME frPage1.

    seQueryTables:LIST-ITEMS = cBufferList.
    
    DO iLoop = 1 TO NUM-ENTRIES(gcNameList):
      CREATE ttFields.
      ASSIGN
        ttFields.cFieldName = ENTRY(iLoop,gcNameList)
        ttFields.cOrigLabel = ENTRY(iLoop,gcCLabelList,CHR(1))
        ttFields.cFieldDataType = ENTRY(iLoop,gcTypeList)
        ttFields.cFieldFormat = ENTRY(iLoop,gcFormatList,CHR(1))
        iBrowseEntry = LOOKUP(ttFields.cFieldName,gcBrowseFields)
        ttFields.iDisplaySeq = iBrowseEntry
        .
      RELEASE ttFields.
      /* If a field has extents, ensure that it is not available in the
         keyfield combo */
      IF INDEX(ENTRY(iLoop,gcNameList),"[":U) > 0 THEN
          NEXT.
      
      ASSIGN
        cValuePairs = cValuePairs +
                      (IF cValuePairs = "":U THEN "":U ELSE ",":U) +
                      ENTRY(iLoop,gcNameList) + ",":U + ENTRY(iLoop,gcNameList)
        .
    END.
    {&OPEN-QUERY-{&BROWSE-NAME}}
    DO WITH FRAME frPage1:
      coKeyField:LIST-ITEM-PAIRS = cValuePairs.

      IF cOldKeyField <> "":U THEN
        coKeyField:SCREEN-VALUE = cOldKeyField NO-ERROR.
      ELSE
        coKeyField:SCREEN-VALUE = ENTRY(1,cValuePairs) NO-ERROR.
      
      IF ERROR-STATUS:ERROR THEN
        coKeyField:SCREEN-VALUE = ENTRY(1,cValuePairs) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN
        coKeyField:SCREEN-VALUE = coKeyField:ENTRY(1) NO-ERROR. 
      
      ASSIGN fiFieldWidth:SCREEN-VALUE = IF DECIMAL(fiFieldWidth:SCREEN-VALUE) <= 0 THEN "50":U ELSE fiFieldWidth:SCREEN-VALUE
             fiInnerLines:SCREEN-VALUE = IF INTEGER(fiInnerLines:SCREEN-VALUE) <= 0 THEN "5":U ELSE fiInnerLines:SCREEN-VALUE
             fiBuildSeq:SCREEN-VALUE   = IF INTEGER(fiBuildSeq:SCREEN-VALUE) <= 0 THEN "1":U ELSE fiBuildSeq:SCREEN-VALUE.
    END.

    DISPLAY
      BrBrowse.

    /* populate other fields */
    APPLY "VALUE-CHANGED" TO coKeyField IN FRAME frPage1.  
  END.

  ENABLE ALL EXCEPT fiFieldDataType fiFieldFormat fiDescSubstitute WITH FRAME frPage1.
  ENABLE ALL EXCEPT fiDefaultValue WITH FRAME frPage2.
  APPLY "VALUE-CHANGED":U TO raFlag IN FRAME frPage2.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateComboFromSDO vTableWin 
PROCEDURE populateComboFromSDO :
/*------------------------------------------------------------------------------
  Purpose:     Populates browse with SDO field list and populates Key field
               combo list items
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cOldKeyField      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTempBrowseFields AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValuePairs       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hSDO              AS HANDLE     NO-UNDO.
DEFINE VARIABLE iBrowseEntry      AS INTEGER    NO-UNDO.
DEFINE VARIABLE iField            AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLoop             AS INTEGER    NO-UNDO.
DEFINE VARIABLE hMainViewer       AS HANDLE     NO-UNDO.
DEFINE VARIABLE lDataView         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cField            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDataColumns      AS CHARACTER  NO-UNDO.

    hMainViewer = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U,"DynCombo-Source":U)).
    
    hSDO = DYNAMIC-FUNCTION('getDataViewSource':U IN hMainviewer). 
    IF VALID-HANDLE(hSDO) THEN
      lDataView = TRUE.
    ELSE
      RUN startDataObject IN gshRepositoryManager (INPUT gcDataSourceName, OUTPUT hSDO).
      
  /* This API is used for both SDO and DatView data sources. SDOs must not have
     the qualification, while DataViews shuld have the field names qualified by
     the table/entity name.
   */    
  IF NOT lDataView THEN     
  DO WITH FRAME frPage1:
    /* If this combo was based on a query the key field was qualified with the table name
       and should be removed from the key field */
    cOldKeyField = IF NUM-ENTRIES(coKeyField:SCREEN-VALUE,".":U) > 1 THEN
                     ENTRY(2,coKeyField:SCREEN-VALUE,".":U)
                   ELSE coKeyField:SCREEN-VALUE.
  END.

  EMPTY TEMP-TABLE ttFields.

  /* If this combo was based on a query, its display fields were qualified with table names
     and should be removed from the browse field list */
  IF NOT lDataView AND NUM-ENTRIES(ENTRY(1, gcBrowseFields),".":U) > 1 THEN
  DO:
    DO iField = 1 TO NUM-ENTRIES(gcBrowseFields):
      cTempBrowseFields = cTempBrowseFields + 
                          (IF iField > 1 THEN ",":U ELSE "":U) +
                          ENTRY(2,ENTRY(iField,gcBrowseFields),".":U).
    END.
    gcBrowseFields = cTempBrowseFields.
  END.

  DO WITH FRAME {&FRAME-NAME}:
    {&OPEN-QUERY-{&BROWSE-NAME}}
    DO WITH FRAME frPage1:
      coKeyField:LIST-ITEM-PAIRS = "x,x".
      coKeyField = "x".
      coKeyField:SCREEN-VALUE = coKeyField:SCREEN-VALUE.  
    END.
    seQueryTables:LIST-ITEMS = "":U.
    DISPLAY
      BrBrowse.
    DISABLE
      BrBrowse.
    DISPLAY coKeyField WITH FRAME frPage1.

    /* populate other fields */
    APPLY "value-changed" TO coKeyField IN FRAME frPage1.

    DO WITH FRAME frPage1:
      IF fiFieldTooltip:SCREEN-VALUE = "":U THEN
        fiFieldTooltip:SCREEN-VALUE = "Select option from list":U.
    END.

    /* Query is valid - rebuild screen values */
    ENABLE
      BrBrowse.
    ENABLE coKeyField WITH FRAME frPage1.
    
    ASSIGN
      gcTypeList   = "":U
      gcFormatList = "":U
      gcLabelList  = "":U
      gcNameList   = "":U.

    {get DataColumns cDataColumns hSDO}.
    DO iLoop = 1 TO NUM-ENTRIES(cDataColumns):
      cField = ENTRY(iLoop, cDataColumns).
      /* As of current we just filter the fields from the viewer's source 
        (starting a separate dataview with the selected table, may be a 
         cleaner solution)*/
      IF lDataview AND ENTRY(1,cField,'.') <> gcDataSourceName  THEN
        NEXT.

      CREATE ttFields.
      ASSIGN
        ttFields.cFieldName     = cField.

      ASSIGN
        gcNameList              = gcNameList 
                                + (IF gcNameList = "":U THEN "":U ELSE ',':u) 
                                + cField
        ttFields.cOrigLabel     = DYNAMIC-FUNCTION('columnLabel':U IN hSDO, INPUT ttFields.cFieldName)
        ttFields.cFieldDataType = DYNAMIC-FUNCTION('columnDataType':U IN hSDO, INPUT ttFields.cFieldName)
        ttFields.cFieldFormat   = DYNAMIC-FUNCTION('columnFormat':U IN hSDO, INPUT ttFields.cFieldName)
        iBrowseEntry            = LOOKUP(ttFields.cFieldName,gcBrowseFields)               
        ttFields.iDisplaySeq    = iBrowseEntry                      
        cValuePairs             = cValuePairs 
                                + (IF cValuePairs = "":U THEN "":U ELSE ",":U)
                                + ttFields.cFieldName + ",":U + ttFields.cFieldName
        gcTypeList              = gcTypeList
                                + (IF gcTypeList = "":U THEN "":U ELSE ",":U) 
                                + ttFields.cFieldDataType
        gcFormatList            = gcFormatList 
                                + (IF gcFormatList = "":U THEN "":U ELSE CHR(1)) 
                                + ttFields.cFieldFormat
        gcLabelList             = gcLabelList 
                                + (IF gcLabelList = "":U THEN "":U ELSE CHR(1)) 
                                + ttFields.cOrigLabel
        .
    END. /* DO iLoop = 1 TO NUM-ENTRIES(cDataColumns) */
    
    IF VALID-HANDLE(hSdo) AND NOT lDataView THEN
      RUN destroyObject IN hSdo NO-ERROR.
    
    {&OPEN-QUERY-{&BROWSE-NAME}}
    DO WITH FRAME frPage1:
      IF gcNameList <> '' THEN
      DO:
        coKeyField:LIST-ITEM-PAIRS = cValuePairs.
  
        IF cOldKeyField <> "":U THEN
          coKeyField:SCREEN-VALUE = cOldKeyField NO-ERROR.
        ELSE
          coKeyField:SCREEN-VALUE = ENTRY(1,cValuePairs) NO-ERROR.
  
        IF ERROR-STATUS:ERROR THEN
          coKeyField:SCREEN-VALUE = ENTRY(1,cValuePairs) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          coKeyField:SCREEN-VALUE = coKeyField:ENTRY(1) NO-ERROR.
      END.
      ELSE 
        coKeyField:LIST-ITEM-PAIRS = ?.

       ASSIGN fiFieldWidth:SCREEN-VALUE = IF DECIMAL(fiFieldWidth:SCREEN-VALUE) <= 0 THEN "50":U ELSE fiFieldWidth:SCREEN-VALUE
              fiInnerLines:SCREEN-VALUE = IF INTEGER(fiInnerLines:SCREEN-VALUE) <= 0 THEN "5":U ELSE fiInnerLines:SCREEN-VALUE
              fiBuildSeq:SCREEN-VALUE   = IF INTEGER(fiBuildSeq:SCREEN-VALUE) <= 0 THEN "1":U ELSE fiBuildSeq:SCREEN-VALUE.
    END.

    DISPLAY
      BrBrowse.

    /* populate other fields */
    APPLY "VALUE-CHANGED" TO coKeyField IN FRAME frPage1.  
  END.

  ENABLE ALL EXCEPT fiFieldDataType fiFieldFormat fiDescSubstitute WITH FRAME frPage1.
  ENABLE ALL EXCEPT fiDefaultValue WITH FRAME frPage2.
  APPLY "VALUE-CHANGED":U TO raFlag IN FRAME frPage2.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE postCreateObjects vTableWin 
PROCEDURE postCreateObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hAttributeBuffer  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hClassBuffer      AS HANDLE     NO-UNDO.

  /* Fetch the repository class*/
  hClassBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN gshRepositoryManager, "SmartFolder":U).

  IF VALID-HANDLE(hClassBuffer) THEN
    hAttributeBuffer = hClassBuffer:BUFFER-FIELD("classBufferHandle":U):BUFFER-VALUE.   

  IF VALID-HANDLE(hAttributeBuffer) THEN
  DO:
    hAttributeBuffer:BUFFER-CREATE().

    {fnarg setPopupSelectionEnabled "hAttributeBuffer:BUFFER-FIELD('PopupSelectionEnabled'):BUFFER-VALUE" hafspfoldrw}.
    {fnarg setTabVisualization      "hAttributeBuffer:BUFFER-FIELD('TabVisualization'):BUFFER-VALUE"      hafspfoldrw}.
    {fnarg setTabPosition           "hAttributeBuffer:BUFFER-FIELD('TabPosition'):BUFFER-VALUE"           hafspfoldrw}.

    hAttributeBuffer:BUFFER-DELETE().
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE queryBuilder vTableWin 
PROCEDURE queryBuilder :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lCancel       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iLoop         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cMessage      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cButton       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTblListEntry AS CHARACTER NO-UNDO.

  getFuncLibHandle().

  DO WITH FRAME frMain:
    IF EdQuery:SCREEN-VALUE <> "":U AND
       NOT glQueryBuilder THEN DO:
      cMessage = "We are sorry, but we do not have enough information to allow you to use the Query Builder.~n" +
                 "To be able to make use of the Query Builder you should clear your existing query and try again.".
      RUN showMessages IN gshSessionManager (INPUT cMessage,
                                             INPUT "INF":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Query Builder Unavailable",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
      RETURN NO-APPLY.
    END.

    IF gcTempTableList <> "":U THEN DO:
      cMessage = "We are sorry, but the Query Builder cannot be used with Temp Tables.~n" +
                 "Remove the Temp Tables and try again.".
      RUN showMessages IN gshSessionManager (INPUT cMessage,
                                             INPUT "INF":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Query Builder Unavailable",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
      RETURN NO-APPLY.
    END.

    /* Make sure everything is cleared */
    ASSIGN _4GLQury     = "":U
           _TblList     = "":U
           _OptionList  = "":U
           _OrdList     = "":U
           _TblOptList  = "":U
           _TuneOptions = "":U
           _JoinCode    = "":U
           _Where       = "":U.

    IF EdQuery:SCREEN-VALUE <> "":U THEN DO:
      ASSIGN _4GLQury     = EdQuery:SCREEN-VALUE + ":":U
             _OptionList  = gcQueryBuilderOptionList
             _TblOptList  = gcQueryBuilderTableOptionList
             _TuneOptions = gcQueryBuilderTuneOptions
             _OrdList     = REPLACE(REPLACE(gcQueryBuilderOrderList,",":U,{&Sep1}),"^":U,{&Sep2}).

      /*The 'Query Builder' (_query.p) needs the OF option for the joins of the table, otherwise it is
        missed the next time the Query Builder is opened. Fix for OE00104049.*/
      DO iLoop = 1 TO NUM-ENTRIES(seQueryTables:LIST-ITEMS):
          ASSIGN cTblListEntry = TRIM(ENTRY(iLoop, EdQuery:SCREEN-VALUE, CHR(10))).

          IF INDEX(cTblListEntry, " OF ") > 0 THEN
               ASSIGN cTblListEntry = ENTRY(2, cTblListEntry, " ") + " " +
                                      ENTRY(3, cTblListEntry, " ") + " " +
                                      ENTRY(4, cTblListEntry, " ").
          ELSE ASSIGN cTblListEntry = ENTRY(iLoop, seQueryTables:LIST-ITEMS).

          ASSIGN _TblList = _TblList + cTblListEntry + {&Sep1}.
      END.
      ASSIGN _TblList = TRIM(_TblList, {&Sep1}).

      DO iLoop = 1 TO NUM-ENTRIES(gcQueryBuilderJoinCode):
        _JoinCode[iLoop] = ENTRY(iLoop,gcQueryBuilderJoinCode).
        IF iLoop > 1 AND
           _JoinCode[iLoop] <> "":U THEN
          ENTRY(iLoop,_TblList,{&Sep1}) = ENTRY(iLoop,_TblList,{&Sep1}) + " WHERE ":U + ENTRY(iLoop - 1,_TblList,{&Sep1}) + " ...":U.
      END.
      DO iLoop = 1 TO NUM-ENTRIES(gcQueryBuilderWhereClauses):
        _Where[iLoop] = ENTRY(iLoop,gcQueryBuilderWhereClauses).
      END.
    END.
    
    RUN adeshar\_query.p (INPUT "", /* If we enter a name here, the Remove option doesn't work */
                          INPUT TRUE,
                          INPUT "AB",
                          INPUT "Table,Join,Where,Sort,Options",
                          INPUT FALSE,
                          INPUT FALSE,
                          OUTPUT lCancel).
    IF lCancel THEN
      RETURN.

    glQueryBuilder = TRUE.
    
    edQuery:SCREEN-VALUE = REPLACE(_4GLQury,":":U,"":U).
    
    /* Check for database prefix */
    IF VALID-HANDLE(gFuncLibHdl) THEN DO:
      /* Check if the DataBase prefix should be used - 
         if not - we should remove it from the query */
      IF db-tbl-name("ICFDB.gsm_user":U) = "gsm_user":U THEN DO:
        /* Remove any DB Prefix */
        DO iLoop = 1 TO NUM-DBS:
          /* Make sure we found the actual database we are looking for and not
            a partial mach - Issue 11008 */
          IF INDEX(edQuery:SCREEN-VALUE," ":U + LDBNAME(iLoop) + ".":U) > 0 THEN
          edQuery:SCREEN-VALUE = REPLACE(edQuery:SCREEN-VALUE," ":U + LDBNAME(iLoop) + ".":U, " ":U).
        END.
      END.
    END.
    
    IF _4GLQury <> "":U THEN DO:
      ASSIGN gcQueryBuilderOptionList      = _OptionList
             gcQueryBuilderTableOptionList = _TblOptList
             gcQueryBuilderTuneOptions     = _TuneOptions
             gcQueryBuilderJoinCode        = "":U
             gcQueryBuilderWhereClauses    = "":U
             gcQueryBuilderOrderList       = REPLACE(REPLACE(_OrdList,{&Sep1},",":U),{&Sep2},"^":U).
      DO iLoop = 1 TO NUM-ENTRIES(_TblList,{&Sep1}):
        IF _JoinCode[iLoop] = ? THEN
          _JoinCode[iLoop] = "":U.
        IF iLoop > 1 THEN
          gcQueryBuilderJoinCode = gcQueryBuilderJoinCode + ",":U + _JoinCode[iLoop].
        ELSE 
          gcQueryBuilderJoinCode = _JoinCode[iLoop].
      END.
      DO iLoop = 1 TO NUM-ENTRIES(_TblList,{&Sep1}):
        IF _Where[iLoop] = ? THEN
          _Where[iLoop] = "":U.
        IF iLoop > 1 THEN
          gcQueryBuilderWhereClauses = gcQueryBuilderWhereClauses + ",":U + _Where[iLoop].
        ELSE 
          gcQueryBuilderWhereClauses = _Where[iLoop].
      END.
      
      APPLY "CHOOSE":U TO buRefresh.
    END.
    ELSE
      ASSIGN gcQueryBuilderOptionList      = "":U
             gcQueryBuilderTableOptionList = "":U
             gcQueryBuilderOrderList       = "":U
             gcQueryBuilderTuneOptions     = "":U
             gcQueryBuilderJoinCode        = "":U 
             gcQueryBuilderWhereClauses    = "":U.
      APPLY "ENTRY":U TO edQuery IN FRAME frMain.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject vTableWin 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdHeight   AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth    AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE lResizedObjects   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE dFrameHeight      AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dFrameWidth       AS DECIMAL    NO-UNDO.

  HIDE FRAME {&FRAME-NAME}.

  ASSIGN
      dFrameHeight = FRAME {&FRAME-NAME}:HEIGHT-CHARS
      dFrameWidth  = FRAME {&FRAME-NAME}:WIDTH-CHARS.
  
  /* If the height OR width of the frame was made smaller */
  IF pdHeight < dFrameHeight OR
     pdWidth  < dFrameWidth  THEN
  DO:
    /* Just in case the window was made longer or wider, allow for the new length or width */
    IF pdHeight > dFrameHeight THEN FRAME {&FRAME-NAME}:HEIGHT-CHARS = pdHeight.
    IF pdWidth  > dFrameWidth  THEN FRAME {&FRAME-NAME}:WIDTH-CHARS  = pdWidth.
    
    lResizedObjects = TRUE.
    fiResizeBar:ROW = 5.
    RUN resizeViewerObjects (INPUT pdHeight, INPUT pdWidth).
  END.
  
  ASSIGN    
      FRAME {&FRAME-NAME}:HEIGHT-CHARS = pdHeight
      FRAME {&FRAME-NAME}:WIDTH-CHARS  = pdWidth.

  IF lResizedObjects = FALSE THEN DO:
    fiResizeBar:ROW = 5.
    RUN resizeViewerObjects (INPUT pdHeight, INPUT pdWidth).
  END.
  
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeViewerObjects vTableWin 
PROCEDURE resizeViewerObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdHeight AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth  AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE dRow          AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dCol          AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dHeight       AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dWidth        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dFolderHeight AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dFolderWidth  AS DECIMAL    NO-UNDO.
  
  IF DYNAMIC-FUNCTION("getObjectInitialized":U) = FALSE THEN
    RETURN.
  DO WITH FRAME {&FRAME-NAME}:
    DO WITH FRAME {&FRAME-NAME}:
      RUN resizeObject IN hafspfoldrw (INPUT {fn getHeight hafspfoldrw}, INPUT pdWidth - .2).
      RUN repositionObject IN hafspfoldrw (INPUT pdHeight - ({fn getHeight hafspfoldrw} + 0.5) + 1.5, INPUT 1).
      ASSIGN FRAME frPage1:ROW    = pdHeight - FRAME frPage1:HEIGHT + 0.84
                                  - (IF {fn getTabPosition hafspfoldrw} = "Upper":U THEN 0 ELSE {fn getTabRowHeight hafspfoldrw})
             FRAME frPage2:ROW    = pdHeight - FRAME frPage2:HEIGHT + 0.84
                                  - (IF {fn getTabPosition hafspfoldrw} = "Upper":U THEN 0 ELSE {fn getTabRowHeight hafspfoldrw})
             fiResizeBar:COL      = 1
             fiResizeBar:WIDTH    = pdWidth - 0.1
             edQuery:HEIGHT       = fiResizeBar:ROW - edQuery:ROW
             brBrowse:HEIGHT      = 3.5 /* Assign it smaller first */
             brBrowse:ROW         = fiResizeBar:ROW + 0.19
             buRefresh:ROW        = fiResizeBar:ROW - buRefresh:HEIGHT
             buClear:ROW          = buRefresh:ROW
             seQueryTables:HEIGHT = buRefresh:ROW - .09 - seQueryTables:ROW

             brBrowse:WIDTH    = pdWidth - 1
             brBrowse:HEIGHT   = {fn getRow hafspfoldrw} - brBrowse:ROW - 0.24
             seQueryTables:COL = pdWidth - seQueryTables:WIDTH + .5
             buRefresh:COL     = pdWidth - buRefresh:WIDTH + .5
             buClear:COL       = seQueryTables:COL
             fiQTables:COL     = seQueryTables:COL
             edQuery:WIDTH     = seQueryTables:COL - edQuery:COL - .4.
    END.
  END.
  IF DYNAMIC-FUNCTION("getObjectHidden":U) = FALSE THEN DO:
    VIEW FRAME {&FRAME-NAME}.
    IF giLastSelectedPage <> 0 THEN
      RUN selectPage (giLastSelectedPage).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveResizeBarRow vTableWin 
PROCEDURE saveResizeBarRow :
/*------------------------------------------------------------------------------
  Purpose:     We will use the Dynamic TreeView size property to save the position
               of this resize bar
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lSaveWindowPos      AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE cProfileData        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE rProfileRid         AS ROWID        NO-UNDO.
  DEFINE VARIABLE cObjectName         AS CHARACTER    NO-UNDO.
  
  ASSIGN lSaveWindowPos = NO.
  {get LogicalObjectName cObjectName ghContainerSource}.

  /* We have to check if this handle is valid since it might 
    have been killed if a developer was running something
    and closed the AppBuilder and it then attempts to close
    down any running containers. */
  IF VALID-HANDLE(gshProfileManager) THEN
   RUN getProfileData IN gshProfileManager (INPUT "Window":U,
                                            INPUT "SaveSizPos":U,
                                            INPUT "SaveSizPos":U,
                                            INPUT NO,
                                            INPUT-OUTPUT rProfileRid,
                                            OUTPUT cProfileData).
  ASSIGN
    lSaveWindowPos = cProfileData <> "NO":U.

  /* Only position and size if asked to */
  IF lSaveWindowPos THEN DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      cProfileData = REPLACE(STRING(fiResizeBar:ROW), SESSION:NUMERIC-DECIMAL-POINT, ".":U).
  
    IF cProfileData <> "":U AND LENGTH(cObjectName) > 0 THEN DO:
     /* We have to check if this handle is valid since it might 
        have been killed if a developer was running something
        and closed the AppBuilder and it then attempts to close
        down any running containers. */
     IF VALID-HANDLE(gshProfileManager) THEN
       RUN setProfileData IN gshProfileManager (INPUT "Window":U,          /* Profile type code */
                                                INPUT "DynTVSize":U,         /* Profile code */
                                                INPUT cObjectName,         /* Profile data key */
                                                INPUT ?,                   /* Rowid of profile data */
                                                INPUT cProfileData,        /* Profile data value */
                                                INPUT NO,                  /* Delete flag */
                                                INPUT "PER":u).            /* Save flag (permanent) */
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectPage vTableWin 
PROCEDURE selectPage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER piPageNum AS INTEGER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  IF NOT VALID-HANDLE(hafspfoldrw) THEN
    RETURN.

  RUN showCurrentPage IN hafspfoldrw (piPageNum).
  RUN pageSelected (piPageNum).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setInfo vTableWin 
PROCEDURE setInfo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phDataTable AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE cSortString     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSource         AS HANDLE     NO-UNDO.

  phDataTable:FIND-FIRST().
  IF NOT phDataTable:AVAILABLE THEN
    RETURN.
  
  ghDataTable = phDataTable.
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN gcQueryBuilderJoinCode        = "":U
           gcQueryBuilderOptionList      = "":U
           gcQueryBuilderOrderList       = "":U
           gcQueryBuilderTableOptionList = "":U
           gcQueryBuilderTuneOptions     = "":U
           gcQueryBuilderWhereClauses    = "":U.
    glTrackChanges = FALSE.
    ASSIGN edQuery:SCREEN-VALUE = phDataTable:BUFFER-FIELD("cBaseQueryString":U):BUFFER-VALUE.
    ASSIGN gcBrowseFields                = phDataTable:BUFFER-FIELD('cDisplayedField':U):BUFFER-VALUE
           gcQueryTables                 = phDataTable:BUFFER-FIELD('cQueryTables':U):BUFFER-VALUE
           gcPhysicalTableNames          = phDataTable:BUFFER-FIELD('cPhysicalTableNames':U):BUFFER-VALUE
           gcTempTableNames              = phDataTable:BUFFER-FIELD('cTempTables':U):BUFFER-VALUE
           gcQueryBuilderJoinCode        = phDataTable:BUFFER-FIELD('cQueryBuilderJoinCode':U):BUFFER-VALUE
           gcQueryBuilderOptionList      = phDataTable:BUFFER-FIELD('cQueryBuilderOptionList':U):BUFFER-VALUE
           gcQueryBuilderTableOptionList = phDataTable:BUFFER-FIELD('cQueryBuilderTableOptionList':U):BUFFER-VALUE
           gcQueryBuilderOrderList       = phDataTable:BUFFER-FIELD('cQueryBuilderOrderList':U):BUFFER-VALUE
           gcQueryBuilderTuneOptions     = phDataTable:BUFFER-FIELD('cQueryBuilderTuneOptions':U):BUFFER-VALUE
           gcQueryBuilderWhereClauses    = phDataTable:BUFFER-FIELD('cQueryBuilderWhereClauses':U):BUFFER-VALUE.
    glQueryBuilder = FALSE.
    IF gcQueryBuilderWhereClauses <> "":U OR
       gcQueryBuilderJoinCode <> "":U THEN
      glQueryBuilder = TRUE.
    ELSE DO: /* If we only have one table with no joins - then we'll allow them to use the AppBuilder */
      IF INDEX(edQuery:SCREEN-VALUE,"WHERE ":U) = 0 AND
        INDEX(edQuery:SCREEN-VALUE,"OF ":U) = 0 AND 
        NUM-ENTRIES(gcQueryTables) = 1 THEN DO:
       ASSIGN gcQueryBuilderJoinCode        = "":U
              gcQueryBuilderOptionList      = "NO-LOCK":U + IF INDEX(edQuery:SCREEN-VALUE,"INDEXED-REPOSITION":U) > 0 THEN " INDEXED-REPOSITION":U ELSE "":U
              gcQueryBuilderTableOptionList = "NO-LOCK":U
              gcQueryBuilderTuneOptions     = "":U
              gcQueryBuilderWhereClauses    = "":U
              glQueryBuilder                = TRUE.
       IF (INDEX(edQuery:SCREEN-VALUE,"BREAK BY ":U) > 0 OR
           INDEX(edQuery:SCREEN-VALUE,"BY ":U) > 0) AND 
           gcQueryBuilderOrderList = "":U THEN DO:
         cSortString = REPLACE(edQuery:SCREEN-VALUE,"INDEXED-REPOSITION":U,"":U).
         IF INDEX(cSortString,"BREAK BY ":U) < INDEX(cSortString,"BY ":U) AND 
            INDEX(cSortString,"BREAK BY ":U) <> 0 THEN
           cSortString = SUBSTRING(cSortString,INDEX(cSortString,"BREAK BY ":U),LENGTH(cSortString)).
         ELSE
           cSortString = SUBSTRING(cSortString,INDEX(cSortString,"BY ":U),LENGTH(cSortString)).
         gcQueryBuilderOrderList = sortString(cSortString).
       END.
      END.
    END.
    RUN setUpBuffTT.
    gcDataSourceName = phDataTable:BUFFER-FIELD('cDataSourceName':U):BUFFER-VALUE.
    IF gcDataSourceName NE '':U THEN
    DO:
      RUN populateComboFromSDO.
      hSource = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U,"DynCombo-Source":U)).
      IF VALID-HANDLE(hSource) THEN
        DYNAMIC-FUNCTION('setDataObjectName':U IN hSource,
                         INPUT gcDataSourceName).
      APPLY "LEAVE":U TO BROWSE BrBrowse.
    END.
    ELSE IF edQuery:SCREEN-VALUE <> "":U THEN DO:
      RUN populateCombo (INPUT FALSE).
      APPLY "LEAVE":U TO BROWSE BrBrowse.

    END.

    IF gcDataSourceName NE '':U OR edQuery:SCREEN-VALUE <> "":U THEN
    DO:
      DO WITH FRAME frPage1:
        ASSIGN coKeyField:SCREEN-VALUE       = phDataTable:BUFFER-FIELD('cKeyField':U):BUFFER-VALUE
               fiDescSubstitute:SCREEN-VALUE = phDataTable:BUFFER-FIELD('cDescSubstitute':U):BUFFER-VALUE.
        APPLY "VALUE-CHANGED":U TO coKeyField.
        ASSIGN fiFieldLabel:SCREEN-VALUE   = phDataTable:BUFFER-FIELD('cFieldLabel':U):BUFFER-VALUE
               fiFieldTooltip:SCREEN-VALUE = phDataTable:BUFFER-FIELD('cFieldTooltip':U):BUFFER-VALUE
               fiFieldWidth:SCREEN-VALUE   = STRING(phDataTable:BUFFER-FIELD('dFieldWidth':U):BUFFER-VALUE,">>>,>>9.99":U)
               fiInnerLines:SCREEN-VALUE   = STRING(phDataTable:BUFFER-FIELD('iInnerLines':U):BUFFER-VALUE)
               fiBuildSeq:SCREEN-VALUE     = STRING(phDataTable:BUFFER-FIELD('iBuildSequence':U):BUFFER-VALUE)
               toEnableField:CHECKED       = phDataTable:BUFFER-FIELD('lEnableField':U):BUFFER-VALUE
               toDisplayField:CHECKED      = phDataTable:BUFFER-FIELD('lDisplayField':U):BUFFER-VALUE
               toSortField:CHECKED         = phDataTable:BUFFER-FIELD('lSort':U):BUFFER-VALUE
               gcDisplayFormat             = phDataTable:BUFFER-FIELD("cDisplayFormat":U):BUFFER-VALUE
               gcDisplayDataType           = phDataTable:BUFFER-FIELD('cDisplayDataType':U):BUFFER-VALUE
               toLabel:CHECKED             = fiFieldLabel:SCREEN-VALUE = "":U.
      END.
      DO WITH FRAME frPage2:
        ASSIGN raFlag:SCREEN-VALUE = phDataTable:BUFFER-FIELD('cComboFlag':U):BUFFER-VALUE.
        APPLY "VALUE-CHANGED":U TO raFlag.
        ASSIGN fiDefaultValue:SCREEN-VALUE      = IF phDataTable:BUFFER-FIELD('cKeyDataType':U):BUFFER-VALUE = "DECIMAL":U THEN
                                                    REPLACE(phDataTable:BUFFER-FIELD('cFlagValue':U):BUFFER-VALUE,".":U,SESSION:NUMERIC-DECIMAL-POINT)
                                                  ELSE phDataTable:BUFFER-FIELD('cFlagValue':U):BUFFER-VALUE
               edParentFilterQuery:SCREEN-VALUE = phDataTable:BUFFER-FIELD('cParentFilterQuery':U):BUFFER-VALUE
               fiParentField:SCREEN-VALUE       = phDataTable:BUFFER-FIELD('cParentField':U):BUFFER-VALUE.
      END.
      RUN assignBrowseData.
      ENABLE ALL EXCEPT fiFieldDataType fiFieldFormat fiDescSubstitute WITH FRAME frPage1.
      fiFieldLabel:SENSITIVE IN FRAME frPage1 = toLabel:CHECKED IN FRAME frPage1 = FALSE.
      APPLY "LEAVE":U TO BROWSE BrBrowse.
      ENABLE ALL EXCEPT fiDefaultValue WITH FRAME frPage2.
    END.
    ELSE ASSIGN toDisplayField:CHECKED IN FRAME frPage1 = TRUE
                toEnableField:CHECKED IN FRAME frPage1  = TRUE.

    glTrackChanges = TRUE.
    ENABLE ALL EXCEPT WITH FRAME {&FRAME-NAME}.
    RUN selectPage (INPUT 1).
  END.
  IF gcDataSourceName NE "":U THEN
    APPLY "ENTRY":U TO coKeyField IN FRAME frPage1.
  ELSE APPLY "ENTRY":U TO edQuery IN FRAME {&FRAME-NAME}.
  
  IF toDisplayField:CHECKED IN FRAME frPage1 = FALSE THEN
    APPLY "VALUE-CHANGED":U TO toDisplayField IN FRAME frPage1.

  RUN changeSource (INPUT IF gcDataSourceName NE "":U THEN "SDO":U
                          ELSE "DB":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setResizeBar vTableWin 
PROCEDURE setResizeBar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cProfileData    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE rProfileRid     AS ROWID      NO-UNDO.
  DEFINE VARIABLE lSaveWindowPos  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE dResizeBarRow   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cObjectName     AS CHARACTER    NO-UNDO.
  
  {get LogicalObjectName cObjectName ghContainerSource}.
  
  /* determine if window positions and sizes are saved */
  IF VALID-HANDLE(gshProfileManager) THEN
    RUN getProfileData IN gshProfileManager (INPUT "Window":U,
                                             INPUT "SaveSizPos":U,
                                             INPUT "SaveSizPos":U,
                                             INPUT NO,
                                             INPUT-OUTPUT rProfileRid,
                                             OUTPUT cProfileData).
                                           
  ASSIGN
      lSaveWindowPos = cProfileData <> "NO":U.

  IF  lSaveWindowPos THEN DO:
    ASSIGN
      cProfileData = "":U
      rProfileRid  = ?.
    
    IF VALID-HANDLE(gshProfileManager) THEN
      RUN getProfileData IN gshProfileManager (INPUT "Window":U,          /* Profile type code     */
                                               INPUT "DynTVSize":U,       /* Profile code          */
                                               INPUT cObjectName,        /* Profile data key      */
                                               INPUT "NO":U,              /* Get next record flag  */
                                               INPUT-OUTPUT rProfileRid,  /* Rowid of profile data */
                                               OUTPUT cProfileData).      /* Found profile data. */
  END. /* save window position and sizes */
  ELSE ASSIGN cProfileData = "":U.
  
  IF SESSION:NUMERIC-DECIMAL-POINT = ",":U AND INDEX(cProfileData,".") <> 0 THEN
    cProfileData = REPLACE(cProfileData,".":U,",":U).
  IF SESSION:NUMERIC-DECIMAL-POINT = ".":U AND INDEX(cProfileData,",") <> 0 THEN
    cProfileData = REPLACE(cProfileData,",":U,".":U).
  
  dResizeBarRow = 0.
  IF cProfileData <> "":U THEN
    dResizeBarRow = DECIMAL(cProfileData) NO-ERROR.
  
  IF dResizeBarRow <= 0 THEN
    fiResizeBar:ROW IN FRAME {&FRAME-NAME} = 5.
  
  IF NOT ERROR-STATUS:ERROR AND
     dResizeBarRow > 0 THEN
    fiResizeBar:ROW IN FRAME {&FRAME-NAME} = dResizeBarRow.
  
  APPLY "END-MOVE":U TO fiResizeBar.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setUpBuffTT vTableWin 
PROCEDURE setUpBuffTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iLoop         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTableName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cActualTable  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPlipName     AS CHARACTER  NO-UNDO.

  IF gcPhysicalTableNames = "":U AND
     gcTempTableNames = "":U THEN
    RETURN.

  ASSIGN gcBufferList    = "":U
         gcTempTableList = "":U.
  
  IF gcQueryTables = "":U THEN
    RETURN.

  /* Buffers */
  IF gcPhysicalTableNames <> "":U THEN DO:
    DO iLoop = 1 TO NUM-ENTRIES(gcPhysicalTableNames):
      ASSIGN cActualTable = TRIM(ENTRY(iLoop,gcPhysicalTableNames)).
      IF cActualTable <> "":U THEN
        ASSIGN cTableName   = TRIM(ENTRY(iLoop,gcQueryTables))
               gcBufferList = IF gcBufferList = "":U THEN cTableName + ",":U + cActualTable
                                                     ELSE gcBufferList + ",":U + cTableName + ",":U + cActualTable.
    END.
  END.
  
  /* Temp Tables */
  IF gcTempTableNames <> "":U THEN DO:
    DO iLoop = 1 TO NUM-ENTRIES(gcTempTableNames):
      ASSIGN cPlipName = TRIM(ENTRY(iLoop,gcTempTableNames)).
      IF cPlipName <> "":U THEN
        ASSIGN cTableName   = TRIM(ENTRY(iLoop,gcQueryTables))
               gcTempTableList = IF gcTempTableList = "":U THEN cTableName + "^":U + cPlipName
                                                           ELSE gcTempTableList + ",":U + cTableName + "^":U + cPlipName.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateData vTableWin 
PROCEDURE validateData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcError AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cMessage        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iInteger        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE dDecimal        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lLogical        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE dtDate          AS DATE       NO-UNDO.
  DEFINE VARIABLE riRowid         AS ROWID      NO-UNDO.
  DEFINE VARIABLE rRaw            AS RAW        NO-UNDO.
  DEFINE VARIABLE reRecid         AS RECID      NO-UNDO.
  DEFINE VARIABLE mMemPtr         AS MEMPTR     NO-UNDO.
  DEFINE VARIABLE hHandle         AS HANDLE     NO-UNDO.
  
  IF gcDataSourceName = "":U THEN
  DO:
    RUN populateCombo (INPUT TRUE).
    cMessage = RETURN-VALUE.
    IF cMessage <> "":U THEN DO:
      pcError = cMessage.
      RETURN.
    END.
  
    DO WITH FRAME {&FRAME-NAME}:
      IF seQueryTables:LIST-ITEMS = "":U OR
         seQueryTables:LIST-ITEMS = ? THEN 
        pcError = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                      {af/sup2/aferrortxt.i 'AF' '5' '' '' '"Base Query"' '"Invalid Query - cannot apply changes~n~nCheck the query starts with FOR EACH and does NOT end in a full stop or colon.~nAlso check you have not misspelled any table names or field names and that you have not missed off any commas. Try pasting the query into the procedure editor and syntax checking from there - if it works there it should work here minus the colon and the end statement."'}.
    END.

    APPLY "LEAVE":U TO BROWSE BrBrowse.
  END.

  RUN assignBrowseData.

  IF gcBrowseFields = "":U THEN
    pcError = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                  {af/sup2/aferrortxt.i 'AF' '18' '' '' '"Combo"' '"at least 1 field to be displayed"'}.
  

  DO WITH FRAME frPage1:
    ASSIGN coKeyField
           fiDescSubstitute
           fiFieldLabel
           fiFieldTooltip
           fiFieldDataType
           fiFieldFormat
           fiFieldWidth
           fiInnerLines
           fiBuildSeq.
    IF NUM-ENTRIES(gcBrowseFields) <> (NUM-ENTRIES(fiDescSubstitute,"&":U) - 1) THEN
      ASSIGN cMessage = STRING(NUM-ENTRIES(gcBrowseFields)) + " substitution characters '&'"
             pcError  = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                            {af/sup2/aferrortxt.i 'AF' '18' '' '' '"Description Substitution"' cMessage}.

   IF NOT INTEGER(fiInnerLines:SCREEN-VALUE) > 0 THEN
     pcError = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                   {af/sup2/aferrortxt.i 'AF' '25' '' '' '"Inner Lines of the combo"' '"zero (0)"'}.

   IF NOT INTEGER(fiBuildSeq:SCREEN-VALUE) > 0 THEN
    pcError = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                  {af/sup2/aferrortxt.i 'AF' '25' '' '' '"Build Sequence"' '"zero (0)"'}.

   IF NOT INTEGER(fiFieldWidth:SCREEN-VALUE) > 0 THEN
     pcError = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                   {af/sup2/aferrortxt.i 'AF' '25' '' '' '"Field Width"' '"zero (0)"'}.
      
  END.


  DO WITH FRAME frPage2:
    ASSIGN raFlag
           fiDefaultValue
           fiParentField
           edParentFilterQuery.
    IF raFlag <> "":U AND 
       fiDefaultValue = "":U THEN
      pcError = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '18' '' '' '"Default Value field"' '"a value other than BLANK when <All> or <None> should be added to the combo"'}.
    
    /* Check for valid data types */
    IF fiDefaultValue <> "":U AND 
       fiDefaultValue <> ".":U AND 
       fiFieldDataType <> "CHARACTER":U THEN DO:
      CASE fiFieldDataType:
        WHEN "INTEGER":U THEN
          ASSIGN iInteger = INTEGER(fiDefaultValue) NO-ERROR.
        WHEN "DECIMAL":U THEN
          ASSIGN dDecimal = DECIMAL(fiDefaultValue) NO-ERROR.
        WHEN "LOGICAL":U THEN
          ASSIGN lLogical = LOGICAL(fiDefaultValue) NO-ERROR.
        /* The following ones are very unlikely, but you never know   */
        WHEN "DATE":U THEN
          ASSIGN dtDate = DATE(fiDefaultValue) NO-ERROR.
        WHEN "ROWID":U THEN
          ASSIGN riRowid = TO-ROWID(fiDefaultValue) NO-ERROR.
        WHEN "HANDLE":U THEN
          ASSIGN hHandle = WIDGET-HANDLE(fiDefaultValue) NO-ERROR.
      END CASE.
      IF ERROR-STATUS:ERROR THEN DO:
        ERROR-STATUS:ERROR = FALSE.
        pcError = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                  {af/sup2/aferrortxt.i 'AF' '5' '' '' '"Default value"' '"The data type of the Default value should be the same data type as the key field."'}.
      END.


    END.
    IF fiDefaultValue = ? OR
       fiDefaultValue = "?":U THEN
      pcError = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                {af/sup2/aferrortxt.i 'AF' '5' '' '' '"Default value"' '"The default value cannot be UNKNOWN (?)"'}.

    IF edParentFilterQuery = ? THEN
      edParentFilterQuery = "":U.

    IF fiParentField       <> "":U AND
       edParentFilterQuery = "":U  THEN 
      pcError = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '22' '' '' '"Parent Filter Query"' '"specified"' '"Parent Field"'}.

   IF edParentFilterQuery <> "":U AND
      fiParentField        = "":U  THEN 
     pcError = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                   {af/sup2/aferrortxt.i 'AF' '22' '' '' '"Parent Fields"' '"specified"' '"Parent Filter Query"'}.

    /* Check that the parent filter query is valid */
    IF edParentFilterQuery <> "":U THEN 
      IF INDEX(edParentFilterQuery,"FOR ":U)   <> 0 OR
         INDEX(edParentFilterQuery,"EACH ":U)  <> 0 OR 
         INDEX(edParentFilterQuery,"WHERE ":U)  <> 0 OR 
         INDEX(edParentFilterQuery,"FIRST ":U) <> 0 OR
         INDEX(edParentFilterQuery,"LAST ":U)  <> 0 OR
         INDEX(edParentFilterQuery,"BREAK ":U) <> 0 THEN 
        pcError = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                      {af/sup2/aferrortxt.i 'AF' '5' '' '' '"Parent Filter Query"' '"Should not contain FOR EACH, FIRST, LAST, Comma or BREAK BY"'}.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataTable vTableWin 
FUNCTION getDataTable RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN ghDataTable.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFuncLibHandle vTableWin 
FUNCTION getFuncLibHandle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the handle of the AppBuilder function library .   
    Notes:  
------------------------------------------------------------------------------*/
  IF NOT VALID-HANDLE(gFuncLibHdl) THEN 
  DO:
      gFuncLibHdl = SESSION:FIRST-PROCEDURE.
      DO WHILE VALID-HANDLE(gFuncLibHdl):
        IF gFuncLibHdl:FILE-NAME = "adeuib/_abfuncs.w":U THEN LEAVE.
        gFuncLibHdl = gFuncLibHdl:NEXT-SIBLING.
      END.
  END.
  RETURN gFuncLibHdl.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataSourceName vTableWin 
FUNCTION setDataSourceName RETURNS LOGICAL
  ( INPUT pcDataSourceName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets viewer global data source name
    Notes:  
------------------------------------------------------------------------------*/
  
  ASSIGN gcDataSourceName = pcDataSourceName.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION sortString vTableWin 
FUNCTION sortString RETURNS CHARACTER
  ( pcSortPhrase AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSingle     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDescending AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iLoop       AS INTEGER    NO-UNDO.
  
  pcSortPhrase = REPLACE(pcSortPhrase,CHR(10)," ":U).
  pcSortPhrase = REPLACE(pcSortPhrase,CHR(12)," ":U).
  pcSortPhrase = REPLACE(pcSortPhrase,CHR(13)," ":U).
  pcSortPhrase = REPLACE(pcSortPhrase,"~n"," ":U).
  
  pcSortPhrase = REPLACE(pcSortPhrase,"BREAK BY ","BREAK_BY ":U).
  pcSortPhrase = REPLACE(pcSortPhrase," BY ":U,",BY ":U).
  pcSortPhrase = REPLACE(pcSortPhrase,"BREAK_BY":U,",BREAK BY":U).
  
  DO iLoop = 1 TO NUM-ENTRIES(pcSortPhrase):
    cSingle = ENTRY(iLoop,pcSortPhrase).
    IF INDEX(cSingle,"DESCENDING":U) > 0 THEN
      lDescending = TRUE.
    ELSE 
      lDescending = FALSE.
    ASSIGN cSingle = REPLACE(cSingle,"DESCENDING":U,"":U)
           cSingle = REPLACE(cSingle,"ASCENDING":U,"":U)
           cSingle = REPLACE(cSingle,"BY ":U,"":U)
           cSingle = REPLACE(cSingle,"BREAK BY ":U,"":U)
           cSingle = RIGHT-TRIM(cSingle)
           cSingle = TRIM(cSingle).
    ENTRY(iLoop,pcSortPhrase) = cSingle + "^":U + STRING(NOT lDescending).
  END.

  RETURN pcSortPhrase.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

