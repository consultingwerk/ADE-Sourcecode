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
       {"af/obj2/gscpmfullo.i"}.


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
  File: rydynsdfmv.w

  Description:  Dynamic Lookup & Combo Repository Maint.

  Purpose:      Dynamic Lookup & Combo Repository Maintenance SmartDataViewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   11/18/2001  Author:     Mark Davies (MIP)

  Update Notes: Created from Template rysttviewv.w

  (v:010001)    Task:           0   UserRef:    
                Date:   12/06/2001  Author:     Mark Davies (MIP)

  Update Notes: Fixed issue #3392 - SmartDataField Maintenance does not include width field
                Fixed issue #3436 - SmartDataField Maintenance tool not working.

  (v:010002)    Task:           0   UserRef:    
                Date:   12/14/2001  Author:     Mark Davies (MIP)

  Update Notes: Fixed issue #3430 - "Save question.." not asked on close of SmartDataFieldMaintenane

  (v:010003)    Task:           0   UserRef:    
                Date:   02/05/2002  Author:     Mark Davies (MIP)

  Update Notes: Enable dynamic combo and lookup fields on initialization.
  
  (v:010004)    Task:           0   UserRef:    
                Date:   03/06/2002  Author:     Mark Davies (MIP)

  Update Notes: Fix for issue #3676 - Clicking Yes on "save" question does not 
                work for SDF Maintenance
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

&scop object-name       rydynsdfmv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}

DEFINE VARIABLE ghFuncLib                       AS HANDLE     NO-UNDO. 
DEFINE VARIABLE gcBrowseFields                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBrowseFieldDataTypes          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBrowseFieldFormats            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcViewerLinkedFields            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcViewerLinkedWidgets           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLinkedFieldDataTypes          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLinkedFieldFormats            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBaseQuery                     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcNameList                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcFormatList                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcTypeList                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLabelList                     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcCLabelList                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSaveDisplayField              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcColumnLabels                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcColumnFormat                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSDFFileName                   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSDFTemplate                   AS CHARACTER  NO-UNDO.

DEFINE VARIABLE gcLookupImg                     AS CHARACTER  NO-UNDO.

/* Template Storage Variables */
DEFINE VARIABLE gcLSDFFileName          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLSDFTemplate          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gclObjectDescription    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLDisplayedField       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLKeyField             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLFieldLabel           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLFieldTooltip         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLKeyFormat            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLKeyDataType          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLDisplayFormat        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLDisplayDataType      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLBaseQueryString      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLQueryTables          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLBrowseFields         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLColumnLabels         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLCoulmnFormat         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLBrowseFieldDataTypes AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLBrowseFieldFormats   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE giLRowsToBatch          AS INTEGER    NO-UNDO.
DEFINE VARIABLE gcLBrowseTitle          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLViewerLinkedFields   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLLinkedFieldDataTypes AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLLinkedFieldFormats   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLViewerLinkedWidgets  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLLookupImage          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLParentField          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLParentFilterQuery    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLMaintenanceObject    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLMaintenanceSDO       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gdLFieldWidth           AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gcLDescSubstitute       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLComboFlag            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLFlagValue            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE giLInnerLines           AS INTEGER    NO-UNDO.
DEFINE VARIABLE giLBuildSeq             AS INTEGER    NO-UNDO.

DEFINE VARIABLE gcDisplayedFields       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDisplayFormat         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDisplayDataType       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glChangesMade           AS LOGICAL    NO-UNDO.
DEFINE VARIABLE gcOldObjectName         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glInitialize            AS LOGICAL    NO-UNDO.

/* temp-table for query field information */
DEFINE TEMP-TABLE ttFields NO-UNDO
FIELD cFieldName              AS CHARACTER    /* name of query field */
FIELD cFieldDataType          AS CHARACTER    /* data type */
FIELD cFieldFormat            AS CHARACTER    /* format */
FIELD cOrigLabel              AS CHARACTER    /* Original Column Label */
FIELD cColumnLabels           AS CHARACTER    /* label override */
FIELD cColumnFormat           AS CHARACTER    /* Fromat override */
FIELD iBrowseFieldSeq         AS INTEGER      /* if to be included in browser, sequence of field within browser */
FIELD lLinkedField            AS LOGICAL      /* yes to indicate a linked field whose value should be returned */
FIELD cLinkedWidget           AS CHARACTER    /* widget name above linked field is associated with or ? for none */
INDEX idxFieldName cFieldName
.

DEFINE VARIABLE cOnlyCombo AS CHARACTER  NO-UNDO INIT
  "cFieldName,iBrowseFieldSeq,cOrigLabel,cFieldDataType,cFieldFormat":U.

{src/adm2/ttcombo.i}
{src/adm2/globals.i}
{checkerr.i &define-only = YES}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "af/obj2/gscpmfullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain
&Scoped-define BROWSE-NAME BrBrowse

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttFields

/* Definitions for BROWSE BrBrowse                                      */
&Scoped-define FIELDS-IN-QUERY-BrBrowse ttFields.cFieldName ttFields.iBrowseFieldSeq ttFields.lLinkedField ttFields.cLinkedWidget ttFields.cColumnLabels ttFields.cOrigLabel ttFields.cFieldDataType ttFields.cColumnFormat ttFields.cFieldFormat   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrBrowse ttFields.iBrowseFieldSeq ~
ttFields.lLinkedField ~
ttFields.cLinkedWidget ~
ttFields.cColumnLabels ~
ttFields.cColumnFormat   
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
&Scoped-Define ENABLED-OBJECTS raSDFType buClear fiDisplayRepository ~
fiObjectName fiObjectDescription EdQuery fiRowsToBatch buRefresh BrBrowse ~
coKeyField coDisplayedField fiFieldLabel fiFieldWidth fiFieldToolTip edHelp ~
fiBrowseTitle fiParentField EdParentFilterQuery buSave buClose 
&Scoped-Define DISPLAYED-OBJECTS raSDFType fiObjectName fiObjectDescription ~
EdQuery fiRowsToBatch fiQueryTables coKeyField fiFieldDatatype ~
coDisplayedField fiFieldLabel fiFieldWidth fiFieldToolTip edHelp ~
fiBrowseTitle fiParentField EdParentFilterQuery fiTextLabel 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD numOccurance vTableWin 
FUNCTION numOccurance RETURNS INTEGER
  ( INPUT pcString    AS CHARACTER,
    INPUT pcCharacter AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setParentFilterHelp vTableWin 
FUNCTION setParentFilterHelp RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hMaintenanceObject AS HANDLE NO-UNDO.
DEFINE VARIABLE hMaintenanceSDO AS HANDLE NO-UNDO.
DEFINE VARIABLE hObjectName AS HANDLE NO-UNDO.
DEFINE VARIABLE hProductModule AS HANDLE NO-UNDO.
DEFINE VARIABLE hTemplateObject AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buClear 
     LABEL "C&lear Settings" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buClose 
     LABEL "&Close" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buRefresh 
     LABEL "&Refresh" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buSave 
     LABEL "&Save" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE coDisplayedField AS CHARACTER FORMAT "X(256)":U 
     LABEL "Displayed Field" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "x","x"
     DROP-DOWN-LIST
     SIZE 46 BY 1 TOOLTIP "Field to display on viewer" NO-UNDO.

DEFINE VARIABLE coKeyField AS CHARACTER FORMAT "X(256)":U 
     LABEL "Key Field" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "x","x"
     DROP-DOWN-LIST
     SIZE 46 BY 1 TOOLTIP "Field to assign to external field" NO-UNDO.

DEFINE VARIABLE edHelp AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 37.2 BY 5.33 NO-UNDO.

DEFINE VARIABLE EdParentFilterQuery AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 70.4 BY 1.71 TOOLTIP "Parent filter query addition." NO-UNDO.

DEFINE VARIABLE EdQuery AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 114.4 BY 3.14 NO-UNDO.

DEFINE VARIABLE fiBrowseTitle AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Browse Title" 
     VIEW-AS FILL-IN 
     SIZE 70.4 BY 1 TOOLTIP "Title for lookup window" NO-UNDO.

DEFINE VARIABLE fiBuildSeq AS INTEGER FORMAT "->9":U INITIAL 1 
     LABEL "Build Sequence" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE fiDefaultValue AS CHARACTER FORMAT "X(35)":U 
     LABEL "Default Value" 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1.1 NO-UNDO.

DEFINE VARIABLE fiDescSubstitute AS CHARACTER FORMAT "X(70)":U 
     LABEL "Description Substitute" 
     VIEW-AS FILL-IN 
     SIZE 69 BY 1 TOOLTIP "Specify the description substitution. e.g. &&&1 - &&&2 / &&&3" NO-UNDO.

DEFINE VARIABLE fiDisplayRepository AS CHARACTER FORMAT "X(3)":U 
     VIEW-AS FILL-IN 
     SIZE 1.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiFieldDatatype AS CHARACTER FORMAT "X(256)":U 
     LABEL "Datatype" 
     VIEW-AS FILL-IN 
     SIZE 30.4 BY 1 TOOLTIP "Data type of key field and external field" NO-UNDO.

DEFINE VARIABLE fiFieldFormat AS CHARACTER FORMAT "X(256)":U 
     LABEL "For&mat" 
     VIEW-AS FILL-IN 
     SIZE 30.4 BY 1 TOOLTIP "Format of key field and external field" NO-UNDO.

DEFINE VARIABLE fiFieldLabel AS CHARACTER FORMAT "X(256)":U 
     LABEL "Field &Label" 
     VIEW-AS FILL-IN 
     SIZE 46 BY 1 TOOLTIP "Label for displayed field" NO-UNDO.

DEFINE VARIABLE fiFieldToolTip AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Tooltip" 
     VIEW-AS FILL-IN 
     SIZE 70.4 BY 1 TOOLTIP "Tooltip for displayed field" NO-UNDO.

DEFINE VARIABLE fiFieldWidth AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 50 
     LABEL "Field Width" 
     VIEW-AS FILL-IN 
     SIZE 30.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiInnerLines AS INTEGER FORMAT ">9":U INITIAL 5 
     LABEL "Inner Lines" 
     VIEW-AS FILL-IN 
     SIZE 8.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiObjectDescription AS CHARACTER FORMAT "X(70)":U 
     LABEL "Object Description" 
     VIEW-AS FILL-IN 
     SIZE 65.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiObjectName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Lookup Name" 
     VIEW-AS FILL-IN 
     SIZE 45.2 BY 1.05 NO-UNDO.

DEFINE VARIABLE fiParentField AS CHARACTER FORMAT "X(70)":U 
     LABEL "Parent Fields" 
     VIEW-AS FILL-IN 
     SIZE 70.4 BY 1 TOOLTIP "The Field Name(s) for the parent field(s) that this lookup is dependant on." NO-UNDO.

DEFINE VARIABLE fiQueryTables AS CHARACTER FORMAT "X(256)":U 
     LABEL "Query Tables" 
     VIEW-AS FILL-IN 
     SIZE 116.2 BY 1 TOOLTIP "Comma delimited list of tables in above query" NO-UNDO.

DEFINE VARIABLE fiRowsToBatch AS INTEGER FORMAT "->>>>9":U INITIAL 200 
     VIEW-AS FILL-IN 
     SIZE 14.8 BY 1 NO-UNDO.

DEFINE VARIABLE fiTextLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Rows to Batch:" 
      VIEW-AS TEXT 
     SIZE 15.2 BY .62 NO-UNDO.

DEFINE VARIABLE raFlag AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Data Only", "",
"<All> and Data", "A",
"<None> and Data", "N"
     SIZE 69 BY .95 TOOLTIP "Add extra option on combo." NO-UNDO.

DEFINE VARIABLE raSDFType AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Dynamic Lookup", "DynLookup",
"Dynamic Combo", "DynCombo"
     SIZE 50 BY .86 TOOLTIP "Select the SDF type you wish to add." NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrBrowse FOR 
      ttFields SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrBrowse vTableWin _FREEFORM
  QUERY BrBrowse NO-LOCK DISPLAY
      ttFields.cFieldName      FORMAT "X(50)":U  LABEL "Field Name":U
      ttFields.iBrowseFieldSeq FORMAT ">>9":U    LABEL "Browse Seq.":U
      ttFields.lLinkedField    FORMAT "YES/NO":U LABEL "Lnk Field":U
      ttFields.cLinkedWidget   FORMAT "X(35)":U  LABEL "Linked Widget":U
      ttFields.cColumnLabels   FORMAT "X(35)":U  LABEL "Override Label":U
      ttFields.cOrigLabel      FORMAT "X(35)":U  LABEL "Column Label":U
      ttFields.cFieldDataType  FORMAT "X(15)":U  LABEL "Data Type":U
      ttFields.cColumnFormat   FORMAT "X(35)":U  LABEL "Override Format":U
      ttFields.cFieldFormat    FORMAT "X(30)":U  LABEL "Format":U
  ENABLE
      ttFields.iBrowseFieldSeq
      ttFields.lLinkedField
      ttFields.cLinkedWidget
      ttFields.cColumnLabels
      ttFields.cColumnFormat
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 130.4 BY 5.91 ROW-HEIGHT-CHARS .62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     raSDFType AT ROW 1 COL 23 NO-LABEL
     buClear AT ROW 1.1 COL 117.4
     fiDisplayRepository AT ROW 1.1 COL 128.2 COLON-ALIGNED NO-LABEL
     RowObject.product_module_obj AT ROW 1.1 COL 129.4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 1 BY 1
     fiObjectName AT ROW 3.95 COL 21.8 COLON-ALIGNED
     fiObjectDescription AT ROW 5 COL 21.8 COLON-ALIGNED
     EdQuery AT ROW 6.91 COL 2.2 NO-LABEL
     fiRowsToBatch AT ROW 7.86 COL 115.4 COLON-ALIGNED NO-LABEL
     buRefresh AT ROW 8.91 COL 117.4
     fiQueryTables AT ROW 10.14 COL 14 COLON-ALIGNED
     BrBrowse AT ROW 11.19 COL 1.8
     coKeyField AT ROW 17.29 COL 21.4 COLON-ALIGNED
     fiFieldDatatype AT ROW 17.29 COL 99.8 COLON-ALIGNED NO-TAB-STOP 
     coDisplayedField AT ROW 18.33 COL 21.4 COLON-ALIGNED
     fiDescSubstitute AT ROW 18.33 COL 21.4 COLON-ALIGNED
     fiFieldFormat AT ROW 18.33 COL 99.8 COLON-ALIGNED
     fiFieldLabel AT ROW 19.38 COL 21.4 COLON-ALIGNED
     fiFieldWidth AT ROW 19.38 COL 99.8 COLON-ALIGNED
     fiFieldToolTip AT ROW 20.43 COL 21.4 COLON-ALIGNED
     edHelp AT ROW 20.71 COL 95 NO-LABEL NO-TAB-STOP 
     raFlag AT ROW 21.48 COL 23.4 NO-LABEL
     fiBrowseTitle AT ROW 21.48 COL 21.4 COLON-ALIGNED
     fiDefaultValue AT ROW 22.43 COL 21.4 COLON-ALIGNED
     fiInnerLines AT ROW 23.57 COL 21.4 COLON-ALIGNED
     fiBuildSeq AT ROW 23.57 COL 61 COLON-ALIGNED
     fiParentField AT ROW 24.57 COL 21.4 COLON-ALIGNED
     EdParentFilterQuery AT ROW 25.62 COL 23.4 NO-LABEL
     buSave AT ROW 26.14 COL 101.4
     buClose AT ROW 26.14 COL 117.2
     fiTextLabel AT ROW 7.1 COL 115 COLON-ALIGNED NO-LABEL
     "Object Type:" VIEW-AS TEXT
          SIZE 13.2 BY .62 AT ROW 1.1 COL 9.8
     "Specify Base Query String (FOR EACH)" VIEW-AS TEXT
          SIZE 38.4 BY .62 AT ROW 6.24 COL 2.2
     "Parent Filter Query:" VIEW-AS TEXT
          SIZE 18.4 BY .62 AT ROW 25.62 COL 4.6
     SPACE(50.80) SKIP(0.00)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gscpmfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gscpmfullo.i}
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
         HEIGHT             = 26.33
         WIDTH              = 131.4.
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
/* BROWSE-TAB BrBrowse fiQueryTables frMain */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

ASSIGN 
       BrBrowse:ALLOW-COLUMN-SEARCHING IN FRAME frMain = TRUE
       BrBrowse:COLUMN-RESIZABLE IN FRAME frMain       = TRUE.

ASSIGN 
       edHelp:RETURN-INSERTED IN FRAME frMain  = TRUE
       edHelp:READ-ONLY IN FRAME frMain        = TRUE.

ASSIGN 
       EdParentFilterQuery:RETURN-INSERTED IN FRAME frMain  = TRUE.

ASSIGN 
       EdQuery:RETURN-INSERTED IN FRAME frMain  = TRUE.

/* SETTINGS FOR FILL-IN fiBuildSeq IN FRAME frMain
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fiBuildSeq:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN fiDefaultValue IN FRAME frMain
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fiDefaultValue:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN fiDescSubstitute IN FRAME frMain
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fiDescSubstitute:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN fiDisplayRepository IN FRAME frMain
   NO-DISPLAY                                                           */
ASSIGN 
       fiDisplayRepository:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN fiFieldDatatype IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiFieldDatatype:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN fiFieldFormat IN FRAME frMain
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fiInnerLines IN FRAME frMain
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fiInnerLines:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN fiQueryTables IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiTextLabel IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN RowObject.product_module_obj IN FRAME frMain
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       RowObject.product_module_obj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.product_module_obj:READ-ONLY IN FRAME frMain        = TRUE
       RowObject.product_module_obj:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

/* SETTINGS FOR RADIO-SET raFlag IN FRAME frMain
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       raFlag:HIDDEN IN FRAME frMain           = TRUE.

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

  ASSIGN raSDFType.
  
  IF raSDFType = "DynCombo" THEN DO:
    ASSIGN fiDescSubstitute = "":U.
    FOR EACH bttFields BY bttFields.iBrowseFieldSeq:
      IF bttFields.iBrowseFieldSeq > 0 THEN
        ASSIGN 
          cDisplayedFields = cDisplayedFields +
                             (IF cDisplayedFields = "":U THEN "":U ELSE ",":U) +
                             bttFields.cFieldName
          gcLKeyFormat     = bttFields.cFieldFormat
          gcLKeyDataType   = bttFields.cFieldDataType.
                                        
    END.
    DO iLoop = 1 TO NUM-ENTRIES(cDisplayedFields):
      ASSIGN fiDescSubstitute = fiDescSubstitute +
                                (IF fiDescSubstitute = "":U 
                                    THEN "&":U + STRING(iLoop)
                                    ELSE (IF iLoop = 1 THEN " - ":U ELSE " / ":U) + "&":U + STRING(iLoop)).
    END.
    DO WITH FRAME {&FRAME-NAME}:
      IF numOccurance(fiDescSubstitute:SCREEN-VALUE,"&") = NUM-ENTRIES(cDisplayedFields) AND 
         fiDescSubstitute:SCREEN-VALUE <> fiDescSubstitute THEN
        fiDescSubstitute = fiDescSubstitute:SCREEN-VALUE.
    END.
    /* If more than one field is displayed in the combo 
       set the format to X(256) */
    IF NUM-ENTRIES(cDisplayedFields) > 1 THEN
      ASSIGN gcLKeyFormat   = "X(256)":U
             gcLKeyDataType = "CHARACTER":U.
  
             
    DISPLAY fiDescSubstitute
            WITH FRAME {&FRAME-NAME}.
  
    IF (iLoop - 1) > 1 THEN
      ENABLE fiDescSubstitute WITH FRAME {&FRAME-NAME}.
    ELSE
      DISABLE fiDescSubstitute WITH FRAME {&FRAME-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BrBrowse vTableWin
ON ROW-LEAVE OF BrBrowse IN FRAME frMain
DO:
  APPLY "LEAVE":U TO SELF.
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
ON CHOOSE OF buClear IN FRAME frMain /* Clear Settings */
DO:
  DEFINE VARIABLE cAnswer    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton    AS CHARACTER  NO-UNDO.

  IF glChangesMade THEN DO:
    RUN askQuestion IN gshSessionManager (INPUT "Your changes have not been saved yet. Would you like to save it now?",      /* messages */
                                          INPUT "&Yes,&No":U,     /* button list */
                                          INPUT "&No":U,          /* default */
                                          INPUT "&No":U,          /* cancel */
                                          INPUT "Question":U,     /* title */
                                          INPUT "":U,             /* datatype */
                                          INPUT "":U,             /* format */
                                          INPUT-OUTPUT cAnswer,   /* answer */
                                          OUTPUT cButton          /* button pressed */
                                          ).
    IF cButton = "&YES":U THEN
      APPLY "CHOOSE":U TO buSave IN FRAME {&FRAME-NAME}.
  END.
  ASSIGN fiObjectName          = "":U
         fiObjectDescription   = "":U
         edQuery               = "":U
         fiFieldLabel          = "":U
         fiParentField         = "":U
         edParentFilterQuery   = "":U
         fiFieldTooltip        = "":U
         fiBrowseTitle         = "":U
         fiDescSubstitute      = "":U
         raFlag                = "":U
         fiDefaultValue        = "":U
         fiInnerLines          = 5
         fiBuildSeq            = 1
         gcOldObjectName       = "":U.
  DYNAMIC-FUNCTION("setDataValue" IN hTemplateObject, "":U). 
  DYNAMIC-FUNCTION("setDataValue" IN hObjectName, "":U). 
  DYNAMIC-FUNCTION("setDataValue" IN hMaintenanceSDO, "":U). 
  DYNAMIC-FUNCTION("setDataValue" IN hMaintenanceObject, "":U). 
  DISPLAY fiObjectName
          fiObjectDescription
          edQuery
          fiFieldLabel
          fiParentField
          edParentFilterQuery
          fiFieldTooltip
          fiBrowseTitle
          fiDescSubstitute
          raFlag        
          fiDefaultValue
          fiInnerLines  
          fiBuildSeq    
          WITH FRAME {&FRAME-NAME}.
  APPLY "CHOOSE":U TO buRefresh IN FRAME {&FRAME-NAME}.
  APPLY "VALUE-CHANGED":U TO raFlag IN FRAME {&FRAME-NAME}.
  glChangesMade = FALSE.
  APPLY "VALUE-CHANGED":U TO raSDFType IN FRAME {&FRAME-NAME}.
  APPLY "VALUE-CHANGED":U TO fiObjectName IN FRAME {&FRAME-NAME}.
  DISABLE fiDescSubstitute WITH FRAME {&FRAME-NAME}.
  glChangesMade = FALSE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buClose
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buClose vTableWin
ON CHOOSE OF buClose IN FRAME frMain /* Close */
DO:
  DEFINE VARIABLE cAnswer    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton    AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO.
  
  IF glChangesMade THEN DO:
    RUN askQuestion IN gshSessionManager (INPUT "Your changes have not been saved yet. Would you like to save it now?",      /* messages */
                                          INPUT "&Yes,&No":U,     /* button list */
                                          INPUT "&No":U,          /* default */
                                          INPUT "&No":U,          /* cancel */
                                          INPUT "Question":U,     /* title */
                                          INPUT "":U,             /* datatype */
                                          INPUT "":U,             /* format */
                                          INPUT-OUTPUT cAnswer,   /* answer */
                                          OUTPUT cButton          /* button pressed */
                                          ).
    IF cButton = "&YES":U THEN
      APPLY "CHOOSE":U TO buSave IN FRAME {&FRAME-NAME}.
  END.
  
  {get ContainerSource hContainer}.
  IF VALID-HANDLE(hContainer) THEN
    RUN ExitObject IN hContainer.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRefresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRefresh vTableWin
ON CHOOSE OF buRefresh IN FRAME frMain /* Refresh */
DO:
  ASSIGN raSDFType.

  CASE raSDFType:
    WHEN "DynLookup":U THEN
      RUN populateLookup.
    WHEN "DynCombo":U THEN
      RUN populateCombo.
  END CASE.
  glChangesMade = TRUE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSave vTableWin
ON CHOOSE OF buSave IN FRAME frMain /* Save */
DO:
  RUN setSmartObjectDetails.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coDisplayedField
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coDisplayedField vTableWin
ON ENTRY OF coDisplayedField IN FRAME frMain /* Displayed Field */
DO:
  ASSIGN gcSaveDisplayField = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coDisplayedField vTableWin
ON VALUE-CHANGED OF coDisplayedField IN FRAME frMain /* Displayed Field */
DO:

  DEFINE VARIABLE iEntry      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLabel      AS CHARACTER  NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
  
    ASSIGN
      coDisplayedField
      iEntry = LOOKUP(coDisplayedField, gcNameList).
  
    IF iEntry > 0 THEN
      ASSIGN
        cLabel            = ENTRY(iEntry,gcLabelList,CHR(1))
        gcDisplayDataType = ENTRY(iEntry,gcTypeList)
        gcDisplayFormat   = ENTRY(iEntry,gcFormatList,CHR(1))
        .
  
    IF cLabel <> "":U AND (fiFieldLabel:SCREEN-VALUE = "":U OR gcSaveDisplayField <> coDisplayedField:SCREEN-VALUE) THEN
      ASSIGN fiFieldLabel:SCREEN-VALUE = cLabel.
  
    ASSIGN gcSaveDisplayField = SELF:SCREEN-VALUE.
  
  END.
  glChangesMade = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coKeyField
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coKeyField vTableWin
ON VALUE-CHANGED OF coKeyField IN FRAME frMain /* Key Field */
DO:

DEFINE VARIABLE iEntry AS INTEGER NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:

  ASSIGN
    coKeyField
    iEntry = LOOKUP(coKeyField, gcNameList).

  IF iEntry > 0 THEN
    ASSIGN
      fiFieldDataType:SCREEN-VALUE = ENTRY(iEntry,gcTypeList)
      fiFieldFormat:SCREEN-VALUE = ENTRY(iEntry,gcFormatList,CHR(1))
      .
  ELSE
    ASSIGN
      fiFieldDataType:SCREEN-VALUE = "":U
      fiFieldFormat:SCREEN-VALUE = "":U
      .

END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME EdParentFilterQuery
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL EdParentFilterQuery vTableWin
ON VALUE-CHANGED OF EdParentFilterQuery IN FRAME frMain
DO:
  glChangesMade = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiBrowseTitle
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiBrowseTitle vTableWin
ON VALUE-CHANGED OF fiBrowseTitle IN FRAME frMain /* Browse Title */
DO:
  glChangesMade = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiBuildSeq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiBuildSeq vTableWin
ON VALUE-CHANGED OF fiBuildSeq IN FRAME frMain /* Build Sequence */
DO:
  glChangesMade = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiDefaultValue
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiDefaultValue vTableWin
ON LEAVE OF fiDefaultValue IN FRAME frMain /* Default Value */
DO:
  ASSIGN fiDefaultValue
         raFlag.
  IF fiDefaultValue = "":U AND
     raFlag <> "":U THEN DO:
    MESSAGE "You may leave the Default Value blank, but be warned that if a combo's key field is BLANK the first entry <ALL> or <None> will not be selected." SKIP
            "This was still a bug in Progress V9.1C, but it might be fixed in a later version." SKIP
            "If it is possible, rather use .,?,0 etc."
            VIEW-AS ALERT-BOX WARNING.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiDefaultValue vTableWin
ON VALUE-CHANGED OF fiDefaultValue IN FRAME frMain /* Default Value */
DO:
  glChangesMade = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiDescSubstitute
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiDescSubstitute vTableWin
ON VALUE-CHANGED OF fiDescSubstitute IN FRAME frMain /* Description Substitute */
DO:
  glChangesMade = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiFieldLabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFieldLabel vTableWin
ON VALUE-CHANGED OF fiFieldLabel IN FRAME frMain /* Field Label */
DO:
  glChangesMade = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiFieldToolTip
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFieldToolTip vTableWin
ON VALUE-CHANGED OF fiFieldToolTip IN FRAME frMain /* Tooltip */
DO:
  glChangesMade = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiFieldWidth
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFieldWidth vTableWin
ON VALUE-CHANGED OF fiFieldWidth IN FRAME frMain /* Field Width */
DO:
  glChangesMade = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiInnerLines
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiInnerLines vTableWin
ON VALUE-CHANGED OF fiInnerLines IN FRAME frMain /* Inner Lines */
DO:
  glChangesMade = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiObjectDescription
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiObjectDescription vTableWin
ON VALUE-CHANGED OF fiObjectDescription IN FRAME frMain /* Object Description */
DO:
  glChangesMade = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiObjectName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiObjectName vTableWin
ON ENTRY OF fiObjectName IN FRAME frMain /* Lookup Name */
DO:
  gcOldObjectName = fiObjectName:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiObjectName vTableWin
ON LEAVE OF fiObjectName IN FRAME frMain /* Lookup Name */
DO:
  ASSIGN fiObjectName.
  IF fiObjectName <> "":U AND
     fiObjectName <> gcOldObjectName THEN DO:
    RUN getObjectDetails (INPUT fiObjectName).
    gcOldObjectName = fiObjectName.
    glChangesMade = FALSE.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiObjectName vTableWin
ON VALUE-CHANGED OF fiObjectName IN FRAME frMain /* Lookup Name */
DO:
  ASSIGN fiObjectName.
  IF fiObjectName <> "":U OR
     DYNAMIC-FUNCTION("getDataValue":U IN hTemplateObject) <> "":U THEN
    DISABLE raSDFType WITH FRAME {&FRAME-NAME}.
  ELSE
    ENABLE raSDFType WITH FRAME {&FRAME-NAME}.
  DYNAMIC-FUNCTION("setDataValue":U IN hObjectName, fiObjectName).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiParentField
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiParentField vTableWin
ON VALUE-CHANGED OF fiParentField IN FRAME frMain /* Parent Fields */
DO:
  glChangesMade = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiRowsToBatch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiRowsToBatch vTableWin
ON VALUE-CHANGED OF fiRowsToBatch IN FRAME frMain
DO:
  glChangesMade = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME raFlag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL raFlag vTableWin
ON VALUE-CHANGED OF raFlag IN FRAME frMain
DO:
  ASSIGN raFlag.

  IF raFlag = "":U THEN
    ASSIGN fiDefaultValue:SCREEN-VALUE = "":U
           fiDefaultValue:SENSITIVE    = FALSE.
  ELSE
    fiDefaultValue:SENSITIVE = TRUE.
    glChangesMade = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME raSDFType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL raSDFType vTableWin
ON VALUE-CHANGED OF raSDFType IN FRAME frMain
DO:
  DEFINE VARIABLE hBrowse AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hColumn AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cAnswer AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton AS CHARACTER  NO-UNDO.

  IF glChangesMade AND NOT glInitialize THEN DO:
    RUN askQuestion IN gshSessionManager (INPUT "Your changes have not been saved yet. Would you like to save it now?",      /* messages */
                                          INPUT "&Yes,&No":U,     /* button list */
                                          INPUT "&No":U,          /* default */
                                          INPUT "&No":U,          /* cancel */
                                          INPUT "Question":U,     /* title */
                                          INPUT "":U,             /* datatype */
                                          INPUT "":U,             /* format */
                                          INPUT-OUTPUT cAnswer,   /* answer */
                                          OUTPUT cButton          /* button pressed */
                                          ).
    IF cButton = "&YES":U THEN
      APPLY "CHOOSE":U TO buSave IN FRAME {&FRAME-NAME}.
  END.
  
  APPLY "CHOOSE":U TO buClear IN FRAME {&FRAME-NAME}.
  ASSIGN raSDFType.

  hBrowse = BrBrowse:HANDLE.

  CASE raSDFType:
    WHEN "DynLookup":U THEN DO:
      ASSIGN fiObjectName:LABEL = "Lookup Name".
      ASSIGN fiRowsToBatch:HIDDEN       = FALSE
             fiTextLabel:HIDDEN         = FALSE
             fiRowsToBatch:SCREEN-VALUE = "200":U
             coDisplayedField:HIDDEN    = FALSE
             fiBrowseTitle:HIDDEN       = FALSE
             fiDescSubstitute:HIDDEN    = TRUE
             raFlag:HIDDEN              = TRUE
             fiDefaultValue:HIDDEN      = TRUE
             fiBuildSeq:HIDDEN          = TRUE
             fiInnerLines:HIDDEN        = TRUE
             fiDescSubstitute:SCREEN-VALUE = "":U.
        RUN viewObject IN hMaintenanceSDO.
        RUN viewObject IN hMaintenanceObject.
        ASSIGN hColumn= hBrowse:FIRST-COLUMN.
        DO WHILE VALID-HANDLE(hColumn):
          IF LOOKUP(hColumn:NAME,cOnlyCombo) = 0 THEN
            ASSIGN hColumn:VISIBLE = TRUE.
          IF hColumn:NAME = "iBrowseFieldSeq" THEN
            hColumn:LABEL = "Browse Seq.".
          hColumn = hColumn:NEXT-COLUMN.
        END.
    END.
    WHEN "DynCombo":U THEN DO:
      ASSIGN fiObjectName:LABEL = "Combo Name".
      ASSIGN fiRowsToBatch:HIDDEN       = TRUE
             fiTextLabel:HIDDEN        = TRUE
             fiDescSubstitute:HIDDEN   = FALSE
             raFlag:HIDDEN             = FALSE
             fiDefaultValue:HIDDEN     = FALSE
             fiBuildSeq:HIDDEN         = FALSE
             fiInnerLines:HIDDEN       = FALSE
             fiInnerLines:SCREEN-VALUE = "5":U
             fiInnerLines:SENSITIVE    = TRUE
             fiBuildSeq:SENSITIVE      = TRUE
             raFlag:SENSITIVE          = TRUE
             coDisplayedField:HIDDEN   = TRUE
             fiBrowseTitle:HIDDEN      = TRUE.
      RUN hideObject IN hMaintenanceSDO.
      RUN hideObject IN hMaintenanceObject.
      ASSIGN hColumn= hBrowse:FIRST-COLUMN.
      DO WHILE VALID-HANDLE(hColumn):
        IF LOOKUP(hColumn:NAME,cOnlyCombo) = 0 THEN
          ASSIGN hColumn:VISIBLE = FALSE.
        IF hColumn:NAME = "iBrowseFieldSeq" THEN
          hColumn:LABEL = "Display Seq.".
        hColumn = hColumn:NEXT-COLUMN.
      END.
    END.
  END CASE.
  APPLY "CHOOSE":U TO buRefresh.
  glChangesMade = FALSE.

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
             INPUT  'DisplayedFieldgsc_product_module.product_module_code,gsc_product_module.product_module_descriptionKeyFieldgsc_product_module.product_module_codeFieldLabelProduct Module CodeFieldTooltipSelect a Product Module from the listKeyFormatX(10)KeyDatatypecharacterDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH gsc_product_module NO-LOCK INDEXED-REPOSITIONQueryTablesgsc_product_moduleSDFFileNameSDFTemplateParentFieldfiDisplayRepositoryParentFilterQueryIF ~'&1~'  EQ ~'NO~' THEN
                     NOT ( gsc_product_module.product_module_code BEGINS "RY":U  OR
                     gsc_product_module.product_module_code BEGINS "RV":U  OR
                     gsc_product_module.product_module_code BEGINS "ICF":U OR
                     gsc_product_module.product_module_code BEGINS "AF":U  OR
                     gsc_product_module.product_module_code BEGINS "GS":U  OR
                     gsc_product_module.product_module_code BEGINS "AS":U  OR
                     gsc_product_module.product_module_code BEGINS "RTB":U   )
                     ELSE TRUEDescSubstitute&1 / &2CurrentKeyValueComboDelimiterListItemPairsCurrentDescValueInnerLines5ComboFlagFlagValueBuildSequence1SecurednoFieldName<Local>DisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hProductModule ).
       RUN repositionObject IN hProductModule ( 1.86 , 23.80 ) NO-ERROR.
       RUN resizeObject IN hProductModule ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelUse TemplateFieldTooltipPress F4 For LookupKeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_smartobject NO-LOCK,
                     FIRST gsc_object_type NO-LOCK
                     WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj,
                     FIRST gsc_object NO-LOCK
                     WHERE gsc_object.object_obj = ryc_smartobject.object_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = gsc_object.product_module_obj,
                     FIRST gsc_product NO-LOCK
                     WHERE gsc_product.product_obj = gsc_product_module.product_obj
                     BY gsc_product.product_code BY gsc_product_module.product_module_code BY ryc_smartobject.object_filenameQueryTablesryc_smartobject,gsc_object_type,gsc_object,gsc_product_module,gsc_productBrowseFieldsgsc_product.product_code,gsc_product_module.product_module_code,ryc_smartobject.object_filename,gsc_object.object_description,gsc_object_type.object_type_descriptionBrowseFieldDataTypescharacter,character,character,character,characterBrowseFieldFormatsX(10),X(10),X(70),X(35),X(35)RowsToBatch200BrowseTitleLookupViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNamett2SDFTemplateLookupImageadeicon/select.bmpParentFieldraSDFTypeParentFilterQuerygsc_object_type.object_type_code = ~'&1~'MaintenanceObjectMaintenanceSDOFieldName<Local>DisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hTemplateObject ).
       RUN repositionObject IN hTemplateObject ( 2.91 , 23.80 ) NO-ERROR.
       RUN resizeObject IN hTemplateObject ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelFieldTooltipPress F4 For SDF LookupKeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_smartobject NO-LOCK,
                     FIRST gsc_object_type NO-LOCK
                     WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj,
                     FIRST gsc_object NO-LOCK
                     WHERE gsc_object.object_obj = ryc_smartobject.object_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = gsc_object.product_module_obj,
                     FIRST gsc_product NO-LOCK
                     WHERE gsc_product.product_obj = gsc_product_module.product_obj
                     BY gsc_product.product_code BY gsc_product_module.product_module_code BY ryc_smartobject.object_filenameQueryTablesryc_smartobject,gsc_object_type,gsc_object,gsc_product_module,gsc_productBrowseFieldsgsc_product.product_code,gsc_product_module.product_module_code,ryc_smartobject.object_filename,gsc_object.object_description,gsc_object_type.object_type_descriptionBrowseFieldDataTypescharacter,character,character,character,characterBrowseFieldFormatsX(10),X(10),X(70),X(35),X(35)RowsToBatch200BrowseTitleLookup Dynamic SDFViewerLinkedFieldsryc_smartobject.object_filenameLinkedFieldDataTypescharacterLinkedFieldFormatsX(70)ViewerLinkedWidgetsfiObjectNameColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldraSDFTypeParentFilterQuerygsc_object_type.object_type_code = ~'&1~'MaintenanceObjectMaintenanceSDOFieldName<Local>DisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hObjectName ).
       RUN repositionObject IN hObjectName ( 3.95 , 23.80 ) NO-ERROR.
       RUN resizeObject IN hObjectName ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_object.object_filenameKeyFieldgsc_object.object_filenameFieldLabelMaintenance SDOFieldTooltipPress F4 For Maintenance SDO LookupKeyFormatX(35)KeyDatatypecharacterDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK
                     WHERE gsc_object_type.object_type_code = "SDO":U
                     OR gsc_object_type.object_type_code = "SBO":U,
                     EACH gsc_object NO-LOCK
                     WHERE gsc_object.object_type_obj = gsc_object_type.object_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = gsc_object.product_module_obj,
                     FIRST gsc_product NO-LOCK
                     WHERE gsc_product.product_obj = gsc_product_module.product_obj
                     BY gsc_product.product_code BY gsc_product_module.product_module_code BY gsc_object.object_filenameQueryTablesgsc_object_type,gsc_object,gsc_product_module,gsc_productBrowseFieldsgsc_product.product_code,gsc_product_module.product_module_code,gsc_object.object_filename,gsc_object.object_description,gsc_object_type.object_type_descriptionBrowseFieldDataTypescharacter,character,character,character,characterBrowseFieldFormatsX(10),X(10),X(35),X(35),X(35)RowsToBatch200BrowseTitleLookup Maintenance SDOViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOFieldName<Local>DisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hMaintenanceSDO ).
       RUN repositionObject IN hMaintenanceSDO ( 22.52 , 23.40 ) NO-ERROR.
       RUN resizeObject IN hMaintenanceSDO ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_object.object_filenameKeyFieldgsc_object.object_filenameFieldLabelMaintenenace ObjectFieldTooltipPress F4 For Maintenance Object LookupKeyFormatX(35)KeyDatatypecharacterDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object NO-LOCK
                     WHERE gsc_object.container_object = TRUE,
                     FIRST gsc_object_type NO-LOCK
                     WHERE gsc_object_type.object_type_obj = gsc_object.object_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = gsc_object.product_module_obj,
                     FIRST gsc_product NO-LOCK
                     WHERE gsc_product.product_obj = gsc_product_module.product_obj
                     BY gsc_product.product_code BY gsc_product_module.product_module_code BY gsc_object.object_filenameQueryTablesgsc_object,gsc_object_type,gsc_product_module,gsc_productBrowseFieldsgsc_product.product_code,gsc_product_module.product_module_code,gsc_object.object_filename,gsc_object.object_description,gsc_object_type.object_type_descriptionBrowseFieldDataTypescharacter,character,character,character,characterBrowseFieldFormatsX(10),X(10),X(35),X(35),X(35)RowsToBatch200BrowseTitleLookup Maintenance ObjectViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOFieldName<Local>DisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hMaintenanceObject ).
       RUN repositionObject IN hMaintenanceObject ( 23.57 , 23.40 ) NO-ERROR.
       RUN resizeObject IN hMaintenanceObject ( 1.00 , 50.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( hProductModule ,
             RowObject.product_module_obj:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( hTemplateObject ,
             hProductModule , 'AFTER':U ).
       RUN adjustTabOrder ( hObjectName ,
             fiObjectName:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( hMaintenanceSDO ,
             fiDefaultValue:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( hMaintenanceObject ,
             fiInnerLines:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignComboValues vTableWin 
PROCEDURE assignComboValues :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lOk                                 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iEntry                              AS INTEGER    NO-UNDO.

  DEFINE BUFFER bttFields FOR ttFields.

  DO WITH FRAME {&FRAME-NAME}:
    /* Remove trailing colons and full stops */
    ASSIGN
      edQuery:SCREEN-VALUE = TRIM(edQuery:SCREEN-VALUE)
      edQuery:SCREEN-VALUE = TRIM(edQuery:SCREEN-VALUE,":":U)
      edQuery:SCREEN-VALUE = TRIM(edQuery:SCREEN-VALUE,".":U)
      .
  
    ASSIGN
      EdQuery 
      fiQueryTables 
      coKeyField 
      fiFieldDatatype 
      fiFieldFormat 
      fiFieldLabel
      fiFieldToolTip 
      fiParentField
      edParentFilterQuery
      fiObjectDescription
      fiDescSubstitute
      fiInnerLines
      fiDefaultValue
      fiBuildSeq.
    ASSIGN raFlag.

    IF fiFieldToolTip = "":U THEN
      ASSIGN fiFieldToolTip = "Select option from list"
             fiFieldToolTip:SCREEN-VALUE = fiFieldToolTip.
    ASSIGN 
      gcDisplayedFields = "":U
      gcDisplayFormat = "":U
      gcDisplayDataType = "":U
      .
  
    ASSIGN
      gcBaseQuery = edQuery
      .
  
    FOR EACH bttFields BY bttFields.iBrowseFieldSeq:
      IF bttFields.iBrowseFieldSeq > 0 THEN
        ASSIGN 
          gcDisplayedFields = gcDisplayedFields +
                              (IF gcDisplayedFields = "":U THEN "":U ELSE ",":U) +
                              bttFields.cFieldName
          gcDisplayDataType = bttFields.cFieldDataType
          gcDisplayFormat   = bttFields.cFieldFormat.

    END.
    
    /* If more than one field is displayed in the combo, 
       it should be made CHARACTER since all the values
       will be concatenated */
    IF NUM-ENTRIES(gcDisplayedFields) > 1 THEN
      ASSIGN gcDisplayDataType = "CHARACTER":U
             gcDisplayFormat   = "X(256)":U.

    ASSIGN lOk = TRUE.
    RUN validateData (OUTPUT lOk).
    IF NOT lOk THEN RETURN "ERROR":U.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignLookupValues vTableWin 
PROCEDURE assignLookupValues :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lOk                                 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iEntry                              AS INTEGER    NO-UNDO.

  DEFINE BUFFER bttFields FOR ttFields.

  DO WITH FRAME {&FRAME-NAME}:
    /* Remove trailing colons and full stops */
    ASSIGN
      edQuery:SCREEN-VALUE = TRIM(edQuery:SCREEN-VALUE)
      edQuery:SCREEN-VALUE = TRIM(edQuery:SCREEN-VALUE,":":U)
      edQuery:SCREEN-VALUE = TRIM(edQuery:SCREEN-VALUE,".":U)
      .
  
    ASSIGN
      EdQuery 
      fiQueryTables 
      coKeyField 
      coDisplayedField 
      fiBrowseTitle 
      fiFieldDatatype 
      fiFieldFormat 
      fiFieldLabel
      fiFieldToolTip 
      fiRowsToBatch
      fiParentField
      edParentFilterQuery
      fiObjectDescription
      .
  
    /* work out rest of values from temp-table, etc. */
    APPLY "row-leave":U TO BROWSE {&browse-name}.
  
    ASSIGN iEntry = LOOKUP(coDisplayedField, gcNameList).
    IF iEntry > 0 THEN
      ASSIGN 
        gcDisplayFormat = ENTRY(iEntry, gcFormatList,CHR(1))
        gcDisplayDataType = ENTRY(iEntry, gcTypeList)
        .
    ELSE
      ASSIGN 
        gcDisplayFormat = "":U
        gcDisplayDataType = "":U
        .
  
    ASSIGN
      gcBrowseFields         = "":U
      gcBrowseFieldDataTypes = "":U
      gcBrowseFieldFormats   = "":U
      gcViewerLinkedFields   = "":U
      gcViewerLinkedWidgets  = "":U
      gcLinkedFieldDataTypes = "":U
      gcLinkedFieldFormats   = "":U
      gcColumnLabels         = "":U
      gcColumnFormat         = "":U
      gcBaseQuery            = edQuery
      .
  
    FOR EACH bttFields BY bttFields.iBrowseFieldSeq:
      IF bttFields.iBrowseFieldSeq > 0 THEN
        ASSIGN
          gcBrowseFields = gcBrowseFields +
                           (IF gcBrowseFields = "":U THEN "":U ELSE ",":U) +
                           bttFields.cFieldName
          gcBrowseFieldDataTypes = gcBrowseFieldDataTypes +
                           (IF gcBrowseFieldDataTypes = "":U THEN "":U ELSE ",":U) +
                           bttFields.cFieldDataType
          gcBrowseFieldFormats = gcBrowseFieldFormats +
                           (IF gcBrowseFieldFormats = "":U THEN "":U ELSE ",":U) +
                           bttFields.cFieldFormat
          gcColumnLabels   = gcColumnLabels + 
                           (IF gcColumnLabels = "":U THEN "":U ELSE ",":U) +
                           bttFields.cColumnLabels
          gcColumnFormat   = gcColumnFormat + 
                           (IF gcColumnFormat = "":U THEN "":U ELSE ",":U) +
                           bttFields.cColumnFormat
          .                         
      IF bttFields.lLinkedField THEN
        ASSIGN
          gcViewerLinkedFields = gcViewerLinkedFields +
                           (IF gcViewerLinkedFields = "":U THEN "":U ELSE ",":U) +
                           bttFields.cFieldName
          gcLinkedFieldDataTypes = gcLinkedFieldDataTypes +
                           (IF gcLinkedFieldDataTypes = "":U THEN "":U ELSE ",":U) +
                           bttFields.cFieldDataType
          gcLinkedFieldFormats = gcLinkedFieldFormats +
                           (IF gcLinkedFieldFormats = "":U THEN "":U ELSE ",":U) +
                           bttFields.cFieldFormat
          gcViewerLinkedWidgets = gcViewerLinkedWidgets +
                           (IF gcViewerLinkedWidgets = "":U THEN "":U ELSE ",":U) +
                           (IF bttFields.cLinkedWidget <> "":U THEN bttFields.cLinkedWidget ELSE "?":U)
          .                         
  
  
    END.
  
    ASSIGN lOk = TRUE.
    RUN validateData (OUTPUT lOk).
    IF NOT lOk THEN RETURN "ERROR":U.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE confirmExit vTableWin 
PROCEDURE confirmExit :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER plCancel AS LOGICAL NO-UNDO.

  DEFINE VARIABLE cButton AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAnswer AS CHARACTER  NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  IF glChangesMade THEN DO:
    RUN askQuestion IN gshSessionManager (INPUT "Your changes have not been saved yet. Would you like to save it now?",      /* messages */
                                          INPUT "&Yes,&No":U,     /* button list */
                                          INPUT "&No":U,          /* default */
                                          INPUT "&No":U,          /* cancel */
                                          INPUT "Question":U,     /* title */
                                          INPUT "":U,             /* datatype */
                                          INPUT "":U,             /* format */
                                          INPUT-OUTPUT cAnswer,   /* answer */
                                          OUTPUT cButton          /* button pressed */
                                          ).
    IF cButton = "&YES":U THEN 
      APPLY "CHOOSE":U TO buSave IN FRAME {&FRAME-NAME}.
  END.

  RUN SUPER( INPUT-OUTPUT plCancel).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getObjectDetails vTableWin 
PROCEDURE getObjectDetails :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectName AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cButton       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProdCode     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProdModCode  AS CHARACTER  NO-UNDO.
  
  FIND FIRST ryc_smartobject
       WHERE ryc_smartobject.object_filename = pcObjectName
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ryc_smartobject THEN DO:
    ASSIGN NO-ERROR. /* To clear the error-status */
    RETURN.
  END.
  ELSE DO:
    FIND FIRST gsc_object
         WHERE gsc_object.object_obj = ryc_smartobject.object_obj
         NO-LOCK NO-ERROR.
    FIND FIRST gsc_object_type
         WHERE gsc_object_type.object_type_obj = gsc_object.object_type_obj
         NO-LOCK NO-ERROR.
    IF AVAILABLE gsc_object_type AND 
       (gsc_object_type.object_type_code <> "DynCombo" AND
        gsc_object_type.object_type_code <> "DynLookup") THEN DO:
      RUN showMessages IN gshSessionManager (INPUT  "The SmartObject specified " + pcObjectName + " is not a valid SDF object - valid types are Dynamic Combo and Dynamic Lookup.",    /* message to display */
                                             INPUT  "ERR":U,          /* error type */
                                             INPUT  "&OK,&Cancel":U,    /* button list */
                                             INPUT  "&OK":U,           /* default button */ 
                                             INPUT  "&Cancel":U,       /* cancel button */
                                             INPUT  "Not a Valid SDF Object":U,             /* error window title */
                                             INPUT  NO,              /* display if empty */ 
                                             INPUT  ?,                /* container handle */ 
                                             OUTPUT cButton           /* button pressed */
                                            ).

      RETURN.
    END.
    ELSE IF NOT AVAILABLE gsc_object_type THEN DO:
      RUN showMessages IN gshSessionManager (INPUT  "The SmartObject specified " + pcObjectName + " does not have a valid object type.",    /* message to display */
                                             INPUT  "ERR":U,          /* error type */
                                             INPUT  "&OK,&Cancel":U,    /* button list */
                                             INPUT  "&OK":U,           /* default button */ 
                                             INPUT  "&Cancel":U,       /* cancel button */
                                             INPUT  "Not a Valid Object Type":U,             /* error window title */
                                             INPUT  NO,              /* display if empty */ 
                                             INPUT  ?,                /* container handle */ 
                                             OUTPUT cButton           /* button pressed */
                                            ).

      RETURN.
    END.

    ASSIGN raSDFType = gsc_object_type.object_type_code.
    DISPLAY raSDFType WITH FRAME {&FRAME-NAME}.
    APPLY "VALUE-CHANGED":U TO raSDFType IN FRAME {&FRAME-NAME}.
    ASSIGN fiObjectName = pcObjectName.
    DISPLAY fiObjectName WITH FRAME {&FRAME-NAME}.
    APPLY "VALUE-CHANGED":U TO fiObjectName IN FRAME {&FRAME-NAME}.
    FIND FIRST gsc_product_module
         WHERE gsc_product_module.product_module_obj = gsc_object.product_module_obj
         NO-LOCK NO-ERROR.
    FOR EACH  ryc_attribute_value
        WHERE ryc_attribute_value.smartobject_obj = ryc_smartobject.smartobject_obj
        NO-LOCK:
      CASE ryc_attribute_value.attribute_label:
        WHEN "DisplayedField" THEN
          gcLDisplayedField = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "KeyField" THEN
          gcLKeyField = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "FieldLabel" THEN
          gcLFieldLabel = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "FieldTooltip" THEN
          gcLFieldTooltip = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "KeyFormat" THEN
          gcLKeyFormat = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "KeyDataType" THEN
          gcLKeyDataType = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "DisplayFormat" THEN
          gcLDisplayFormat = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "DisplayDataType" THEN
          gcLDisplayDataType = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "BaseQueryString" THEN
          gcLBaseQueryString = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "QueryTables" THEN
          gcLQueryTables = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "ParentField" THEN
          gcLParentField = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "ParentFilterQuery" THEN
          gcLParentFilterQuery = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        /** Combo Specific Fields **/
        WHEN "DescSubstitute" THEN
          gcLDescSubstitute = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "ComboFlag" THEN
          gcLComboFlag = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "FlagValue" THEN
          gcLFlagValue = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "InnerLines" THEN
          giLInnerLines = INTEGER(DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value)).
        WHEN "BuildSequence" THEN
          giLBuildSeq = INTEGER(DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value)).
        /** Lookup Specific Fields **/
        WHEN "BrowseFields" THEN
          gcLBrowseFields = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "ColumnLabels" THEN
          gcLColumnLabels = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "ColumnFormat" THEN
          gcLCoulmnFormat = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "BrowseFieldDataTypes" THEN
          gcLBrowseFieldDataTypes = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "BrowseFieldFormats" THEN
          gcLBrowseFieldFormats = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "RowsToBatch" THEN
          giLRowsToBatch = INTEGER(DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value)).
        WHEN "BrowseTitle" THEN
          gcLBrowseTitle = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "ViewerLinkedFields" THEN
          gcLViewerLinkedFields = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "LinkedFieldDataTypes" THEN
          gcLLinkedFieldDataTypes = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "LinkedFieldFormats" THEN
          gcLLinkedFieldFormats = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "ViewerLinkedWidgets" THEN
          gcLViewerLinkedWidgets = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "LookupImage" THEN
          gcLLookupImage = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "ParentField" THEN
          gcLParentField = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "ParentFilterQuery" THEN
          gcLParentFilterQuery = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "MaintenanceObject" THEN
          gcLMaintenanceObject = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "MaintenanceSDO" THEN
          gcLMaintenanceSDO = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "WIDTH-CHARS" THEN
          gdLFieldWidth = DECIMAL(DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value)).
       END CASE.
    END.
  END.
  
  DO WITH FRAME {&FRAME-NAME}:
    
    ASSIGN
      gcBaseQuery    = gcLBaseQueryString
      fiFieldWidth   = gdLFieldWidth
      edQuery        = gcBaseQuery
      gcBrowseFields = IF raSDFType = "DynLookup":U THEN gcLBrowseFields ELSE gcLDisplayedField.
    
    DYNAMIC-FUNCTION("setDataValue":U IN hProductModule,gsc_product_module.product_module_code).

    IF raSDFType = "DynLookup":U THEN DO:
      ASSIGN 
        gcViewerLinkedFields  = gcLViewerLinkedFields 
        gcViewerLinkedWidgets = gcLViewerLinkedWidgets
        gcColumnLabels        = gcLColumnLabels
        gcColumnFormat        = gcLCoulmnFormat
        fiRowsToBatch         = giLRowsToBatch
        fiBrowseTitle         = gcLBrowseTitle.
      DYNAMIC-FUNCTION("setDataValue":U IN hMaintenanceObject, gcLMaintenanceObject).
      DYNAMIC-FUNCTION("setDataValue":U IN hMaintenanceSDO, gcLMaintenanceSDO).
    END.
    ELSE DO:
      raFlag = gcLComboFlag.
      DISPLAY raFlag WITH FRAME {&FRAME-NAME}.
      APPLY "VALUE-CHANGED":U TO raFlag.
      ASSIGN 
        fiDescSubstitute = gcLDescSubstitute
        fiDefaultValue   = gcLFlagValue
        fiInnerLines     = giLInnerLines
        fiBuildSeq       = giLBuildSeq.
    END.
    
    DISPLAY edQuery.

    APPLY "CHOOSE":U TO buRefresh.

    ASSIGN
      fiFieldLabel        = gcLFieldLabel  
      fiFieldToolTip      = gcLFieldTooltip
      fiParentField       = gcLParentField
      edParentFilterQuery = gcLParentFilterQuery.
    
    IF AVAILABLE gsc_object THEN
      fiObjectDescription = gsc_object.object_description.
    
    DISPLAY
      fiObjectDescription
      fiFieldLabel
      fiFieldWidth
      fiBrowseTitle WHEN raSDFType = "DynLookup":U
      fiFieldToolTip 
      fiRowsToBatch WHEN raSDFType = "DynLookup":U
      fiParentField 
      edParentFilterQuery
      fiDescSubstitute WHEN raSDFType = "DynCombo":U
      fiDefaultValue WHEN raSDFType = "DynCombo":U 
      fiInnerLines WHEN raSDFType = "DynCombo":U   
      fiBuildSeq WHEN raSDFType = "DynCombo":U.
      
      ASSIGN coDisplayedField:SCREEN-VALUE = IF raSDFType = "DynLookup":U THEN gcLDisplayedField ELSE coDisplayedField:ENTRY(1)
             coKeyField:SCREEN-VALUE       = gcLKeyField.
  END.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDisplayRepository          AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE rRowid                      AS ROWID                NO-UNDO.

  SUBSCRIBE TO "LookupDisplayComplete":U IN THIS-PROCEDURE.
  
  RUN SUPER.

  glInitialize = TRUE.
  RUN displayFields IN TARGET-PROCEDURE (?).
  RUN enableField IN hProductModule.
  RUN enableField IN hTemplateObject.
  RUN enableField IN hObjectName.
  RUN enableField IN hMaintenanceSDO.
  RUN enableField IN hMaintenanceObject.

  /* Determine whether the user wants to display repository data. */
  ASSIGN rRowid = ?.
  RUN getProfileData IN gshProfileManager ( INPUT        "General":U,
                                            INPUT        "DispRepos":U,
                                            INPUT        "DispRepos":U,
                                            INPUT        NO,
                                            INPUT-OUTPUT rRowid,
                                                  OUTPUT cDisplayRepository).
  ASSIGN fiDisplayRepository:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cDisplayRepository.
  RUN RefreshChildDependancies IN hProductModule (INPUT "fiDisplayRepository":U).
  
  setParentFilterHelp().
  glChangesMade = FALSE.
  glInitialize = FALSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LookupDisplayComplete vTableWin 
PROCEDURE LookupDisplayComplete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcFieldNames           AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcFieldValues          AS CHARACTER  NO-UNDO.  
  DEFINE INPUT PARAMETER pcKeyFieldValue        AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phLookup               AS HANDLE     NO-UNDO. 
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN raSDFType. 
  END.

  IF phLookup = hObjectName THEN DO:
    APPLY "VALUE-CHANGED":U TO fiObjectName IN FRAME {&FRAME-NAME}.
    APPLY "LEAVE":U TO fiObjectName IN FRAME {&FRAME-NAME}.
    APPLY "LEAVE":U TO BrBrowse IN FRAME {&FRAME-NAME}.
    glChangesMade = FALSE.
  END.
  
  IF phLookup = hTemplateObject THEN DO:
    APPLY "CHOOSE":U TO buClear IN FRAME {&FRAME-NAME}.
    IF pcKeyFieldValue <> "":U THEN
      RUN getObjectDetails (INPUT pcKeyFieldValue).
    DYNAMIC-FUNCTION("setDataValue":U IN hTemplateObject,pcKeyFieldValue).
    IF pcKeyFieldValue <> "":U THEN DO:
      DISABLE raSDFType WITH FRAME {&FRAME-NAME}.
      APPLY "LEAVE":U TO BrBrowse IN FRAME {&FRAME-NAME}.
      glChangesMade = FALSE.
    END.
  END.
  IF phLookup = hMaintenanceSDO OR
     phLookup = hMaintenanceObject THEN
    glChangesMade = TRUE.

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
  DEFINE VARIABLE cQuery                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBufferList                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValueList                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQueryValid                 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cValuePairs                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cField                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iBrowseEntry                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLinkedEntry                AS INTEGER    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      cQuery = TRIM(edQuery:SCREEN-VALUE)
      cQuery = TRIM(cQuery,":":U)
      cQuery = TRIM(cQuery,".":U)
      edQuery:SCREEN-VALUE = cQuery
      .
    
    /* Remove any Line Breaks */
    cQuery = REPLACE(cQuery,CHR(10)," ":U).
  
    /* Refresh query details by evaluating query */
    SESSION:SET-WAIT-STATE("general":U).
    RUN af/app/afqrydetlp.p (INPUT cQuery,
                             OUTPUT lQueryValid,
                             OUTPUT cBufferList,
                             OUTPUT gcNameList,
                             OUTPUT gcFormatList,
                             OUTPUT gcTypeList,
                             OUTPUT gcLabelList,
                             OUTPUT gcCLabelList,
                             OUTPUT cValueList).
    SESSION:SET-WAIT-STATE("":U).
  
    EMPTY TEMP-TABLE ttFields.
  
    IF NOT lQueryValid OR cBufferList = "":U THEN
    DO WITH FRAME {&FRAME-NAME}:
      IF cQuery <> "":U THEN
      MESSAGE "Query specified is syntactically incorrect - please specify a valid query" SKIP(1)
              "Check the query starts with FOR EACH and does NOT end in a full stop or colon." SKIP
              "Also check you have not misspelled any table names or field names and that" SKIP
              "you have not missed off any commas. Try pasting the query into the procedure" SKIP
              "editor and syntax checking from there - if it works there it should work here" SKIP
              "minus the colon and the end statement"
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  
      {&OPEN-QUERY-{&BROWSE-NAME}}
  
      IF fiFieldTooltip = "":U OR INDEX(fiFieldTooltip,"lookup":U) > 0 THEN
        fiFieldTooltip:SCREEN-VALUE = "Select option from list":U.
      
      coKeyField:LIST-ITEM-PAIRS = "x,x":U.
      coKeyField = "x".
      coKeyField:SCREEN-VALUE = coKeyField:SCREEN-VALUE.  
      fiQueryTables:SCREEN-VALUE = "":U.
      DISPLAY
        BrBrowse.
      DISABLE
        BrBrowse coKeyField.
  
      /* populate other fields */
      APPLY "value-changed" TO coKeyField.  
  
      RETURN NO-APPLY.    
    END.
    ELSE
    DO WITH FRAME {&FRAME-NAME}:
      /* Query is valid - rebuild screen values */
      ENABLE
        BrBrowse coKeyField.
      fiQueryTables:SCREEN-VALUE = cBufferList.
  
      DO iLoop = 1 TO NUM-ENTRIES(gcNameList):
        CREATE ttFields.
        ASSIGN
          ttFields.cFieldName = ENTRY(iLoop,gcNameList)
          ttFields.cOrigLabel = ENTRY(iLoop,gcCLabelList,CHR(1))
          ttFields.cFieldDataType = ENTRY(iLoop,gcTypeList)
          ttFields.cFieldFormat = ENTRY(iLoop,gcFormatList,CHR(1))
          iBrowseEntry = LOOKUP(ttFields.cFieldName,gcBrowseFields)
          ttFields.iBrowseFieldSeq = iBrowseEntry
          .
        
        RELEASE ttFields.
        ASSIGN
          cValuePairs = cValuePairs +
                        (IF cValuePairs = "":U THEN "":U ELSE ",":U) +
                        ENTRY(iLoop,gcNameList) + ",":U + ENTRY(iLoop,gcNameList)
          .
      END.
      {&OPEN-QUERY-{&BROWSE-NAME}}
  
      coKeyField:LIST-ITEM-PAIRS = cValuePairs.
  
      coKeyField:SCREEN-VALUE = ENTRY(1,cValuePairs) NO-ERROR.
  
      coKeyField:SCREEN-VALUE = coKeyField:ENTRY(1) NO-ERROR. 
  
      DISPLAY
        BrBrowse.
  
      /* populate other fields */
      APPLY "value-changed" TO coKeyField.  
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateLookup vTableWin 
PROCEDURE populateLookup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQuery                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBufferList                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValueList                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQueryValid                 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cValuePairs                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cField                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iBrowseEntry                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLinkedEntry                AS INTEGER    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      cQuery = TRIM(edQuery:SCREEN-VALUE)
      cQuery = TRIM(cQuery,":":U)
      cQuery = TRIM(cQuery,".":U)
      edQuery:SCREEN-VALUE = cQuery
      .
    
    /* Remove any Line Breaks */
    cQuery = REPLACE(cQuery,CHR(10)," ":U).
  
    /* Refresh query details by evaluating query */
    SESSION:SET-WAIT-STATE("general":U).
    RUN af/app/afqrydetlp.p (INPUT cQuery,
                             OUTPUT lQueryValid,
                             OUTPUT cBufferList,
                             OUTPUT gcNameList,
                             OUTPUT gcFormatList,
                             OUTPUT gcTypeList,
                             OUTPUT gcLabelList,
                             OUTPUT gcCLabelList,
                             OUTPUT cValueList).
    SESSION:SET-WAIT-STATE("":U).
  
    EMPTY TEMP-TABLE ttFields.
  
    IF NOT lQueryValid OR cBufferList = "":U THEN
    DO WITH FRAME {&FRAME-NAME}:
      IF cQuery <> "":U THEN
      MESSAGE "Query specified is syntactically incorrect - please specify a valid query" SKIP(1)
              "Check the query starts with FOR EACH and does NOT end in a full stop or colon." SKIP
              "Also check you have not misspelled any table names or field names and that" SKIP
              "you have not missed off any commas. Try pasting the query into the procedure" SKIP
              "editor and syntax checking from there - if it works there it should work here" SKIP
              "minus the colon and the end statement"
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  
      {&OPEN-QUERY-{&BROWSE-NAME}}
  
      coKeyField:LIST-ITEM-PAIRS = "x,x".
      coDisplayedField:LIST-ITEM-PAIRS = "x,x".
      coKeyField = "x".
      coDisplayedField = "x".
      coKeyField:SCREEN-VALUE = coKeyField:SCREEN-VALUE.  
      coDisplayedField:SCREEN-VALUE = coDisplayedField:SCREEN-VALUE.
      fiQueryTables:SCREEN-VALUE = "":U.
      DISPLAY
        BrBrowse.
      DISABLE
        BrBrowse coDisplayedField coKeyField.
  
      /* populate other fields */
      APPLY "value-changed" TO coKeyField.  
  
      IF fiFieldTooltip = "":U OR INDEX(fiFieldTooltip,"option":U) > 0 THEN
        fiFieldTooltip:SCREEN-VALUE = "Press F4 for Lookup":U.
      IF fiBrowseTitle = "":U THEN
        fiBrowseTitle:SCREEN-VALUE = "Lookup":U.
  
      RETURN NO-APPLY.    
    END.
    ELSE
    DO WITH FRAME {&FRAME-NAME}:
      /* Query is valid - rebuild screen values */
      ENABLE
        BrBrowse coDisplayedField coKeyField.
      fiQueryTables:SCREEN-VALUE = cBufferList.
  
      DO iLoop = 1 TO NUM-ENTRIES(gcNameList):
        CREATE ttFields.
        ASSIGN
          ttFields.cFieldName = ENTRY(iLoop,gcNameList)
          ttFields.cOrigLabel = ENTRY(iLoop,gcCLabelList,CHR(1))
          ttFields.cFieldDataType = ENTRY(iLoop,gcTypeList)
          ttFields.cFieldFormat = ENTRY(iLoop,gcFormatList,CHR(1))
          iBrowseEntry = LOOKUP(ttFields.cFieldName,gcBrowseFields)
          iLinkedEntry = LOOKUP(ttFields.cFieldName,gcViewerLinkedFields)
          ttFields.iBrowseFieldSeq = iBrowseEntry
          ttFields.lLinkedField = iLinkedEntry > 0
          ttFields.cLinkedWidget = (IF iLinkedEntry > 0 AND iLinkedEntry <= NUM-ENTRIES(gcViewerLinkedWidgets) THEN ENTRY(iLinkedEntry,gcViewerLinkedWidgets) ELSE "":U)
          ttFields.cColumnLabels = IF gcColumnLabels <> "":U AND gcColumnLabels <> ? THEN IF NUM-ENTRIES(gcColumnLabels) >= iBrowseEntry AND iBrowseEntry <> 0 THEN ENTRY(iBrowseEntry,gcColumnLabels) ELSE "":U ELSE "":U
          ttFields.cColumnFormat = IF gcColumnFormat <> "":U AND gcColumnFormat <> ? THEN IF NUM-ENTRIES(gcColumnFormat) >= iBrowseEntry AND iBrowseEntry <> 0 THEN ENTRY(iBrowseEntry,gcColumnFormat) ELSE "":U ELSE "":U
          .
        RELEASE ttFields.
        ASSIGN
          cValuePairs = cValuePairs +
                        (IF cValuePairs = "":U THEN "":U ELSE ",":U) +
                        ENTRY(iLoop,gcNameList) + ",":U + ENTRY(iLoop,gcNameList)
          .
      END.
      {&OPEN-QUERY-{&BROWSE-NAME}}
  
      coDisplayedField:LIST-ITEM-PAIRS = cValuePairs.
      coKeyField:LIST-ITEM-PAIRS = cValuePairs.
  
      coDisplayedField:SCREEN-VALUE = ENTRY(1,cValuePairs) NO-ERROR.
      coKeyField:SCREEN-VALUE = ENTRY(1,cValuePairs) NO-ERROR.
  
      coDisplayedField:SCREEN-VALUE = coDisplayedField:ENTRY(1) NO-ERROR.
      coKeyField:SCREEN-VALUE = coKeyField:ENTRY(1) NO-ERROR. 
  
      DISPLAY
        BrBrowse.
  
      /* populate other fields */
      APPLY "value-changed" TO coKeyField.  
      APPLY "value-changed" TO coDisplayedField.  
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveComboDetails vTableWin 
PROCEDURE saveComboDetails :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFileName  AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cErrorText         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dContainer         AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dContainerType     AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cObjectLayout      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProductModule     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectTemplate    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMaintenanceObject AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMaintenanceSDO    AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fiFieldDataType
           fiFieldFormat
           fiFieldWidth
           fiObjectDescription.
  END.
  ASSIGN cProductModule  = DYNAMIC-FUNCTION("getDataValue":U IN hProductModule)
         cObjectTemplate = DYNAMIC-FUNCTION("getDataValue":U IN hTemplateObject).

  /* create / update gsc_object and ryc_smartobject records */
  RUN updateDynamicObject (INPUT "combo":U,
                           INPUT cProductModule,
                           INPUT pcFileName,
                           INPUT fiObjectDescription,
                           INPUT "":U,
                           INPUT "":U,
                           INPUT "":U,
                           OUTPUT dContainer,
                           OUTPUT dContainerType).
  IF RETURN-VALUE <> "":U THEN
    ASSIGN cErrorText = RETURN-VALUE. 

  IF cErrorText = "":U THEN DO:
    /* Update attribute values */
    RUN updateAttributeValues (INPUT dContainerType,
                               INPUT dContainer,
                               INPUT 0,
                               INPUT 0,
                               INPUT 'SDFFileName,SDFTemplate,DisplayedField,KeyField,FieldLabel,FieldTooltip,DisplayFormat,DisplayDataType,KeyFormat,KeyDataType,BaseQueryString,QueryTables,ParentField,ParentFilterQuery,MasterFile,VisualizationType,Width-Chars,Height-Chars,Column,Row,ComboFlag,DescSubstitute,InnerLines,FlagValue,BuildSequence,EnableField,HideOnInit,DisableOnInit,ObjectLayout,FieldName',
                               INPUT pcFileName + CHR(3) + cObjectTemplate + CHR(3) + gcDisplayedFields + CHR(3) + coKeyField + CHR(3) + fiFieldLabel + CHR(3) + fiFieldToolTip + CHR(3) + gcLDisplayFormat + CHR(3) + gcLKeyDataType + CHR(3) + fiFieldFormat + CHR(3) + gcLDisplayDatatype + CHR(3) + EdQuery + CHR(3) + fiQueryTables + CHR(3) + fiParentField + CHR(3) + edParentFilterQuery + CHR(3) + "adm2/dyncombo.w" + CHR(3) + "SmartDataField":U + CHR(3) + STRING(fiFieldWidth) + CHR(3) + "1":U + CHR(3) + "1":U + CHR(3) + "1":U + CHR(3) + raFlag + CHR(3) + fiDescSubstitute + CHR(3) + STRING(fiInnerLines) + CHR(3) + fiDefaultValue + CHR(3) + STRING(fiBuildSeq) + CHR(3) + STRING(YES) + CHR(3) + STRING(NO) + CHR(3) + STRING(NO) + CHR(3) + cObjectLayout + CHR(3) + "":U).
    IF RETURN-VALUE <> "":U THEN 
      ASSIGN cErrorText = RETURN-VALUE.
  END.
  
  IF cErrorText <> "":U THEN DO WITH FRAME {&FRAME-NAME}:
    RUN showMessages IN gshSessionManager (INPUT  cErrorText,    /* message to display */
                                           INPUT  "ERR":U,          /* error type */
                                           INPUT  "&OK,&Cancel":U,    /* button list */
                                           INPUT  "&OK":U,           /* default button */ 
                                           INPUT  "&Cancel":U,       /* cancel button */
                                           INPUT  "Error creating/update field object":U,             /* error window title */
                                           INPUT  YES,              /* display if empty */ 
                                           INPUT  ?,                /* container handle */ 
                                           OUTPUT cButton           /* button pressed */
                                          ).
    ASSIGN fiObjectName:SCREEN-VALUE = "":U
           fiObjectDescription:SCREEN-VALUE = "":U.
    APPLY "VALUE-CHANGED":U TO fiObjectName.
    RETURN cErrorText.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveLookupDetails vTableWin 
PROCEDURE saveLookupDetails :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFileName  AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cErrorText         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectLayout      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dContainer         AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dContainerType     AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cAttributes        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValues            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProductModule     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectTemplate    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMaintenanceObject AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMaintenanceSDO    AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fiFieldDataType
           fiFieldFormat
           fiFieldWidth
           fiObjectDescription.
  END.
  ASSIGN cProductModule     = DYNAMIC-FUNCTION("getDataValue":U IN hProductModule)
         cObjectTemplate    = DYNAMIC-FUNCTION("getDataValue":U IN hTemplateObject)
         cMaintenanceObject = DYNAMIC-FUNCTION("getDataValue":U IN hMaintenanceObject)
         cMaintenanceSDO    = DYNAMIC-FUNCTION("getDataValue":U IN hMaintenanceSDO).

  /* create / update gsc_object and ryc_smartobject records */
  RUN updateDynamicObject (INPUT "lookup":U,
                           INPUT cProductModule,
                           INPUT pcFileName,
                           INPUT fiObjectDescription,
                           INPUT "":U,
                           INPUT "":U,
                           INPUT "":U,
                           OUTPUT dContainer,
                           OUTPUT dContainerType).
  IF RETURN-VALUE <> "":U THEN
    ASSIGN cErrorText = RETURN-VALUE. 

  IF cErrorText = "":U THEN DO:
    ASSIGN cAttributes = 'SDFFileName,SDFTemplate,DisplayedField,KeyField,FieldLabel,FieldTooltip,KeyFormat,KeyDataType,'
                                    + 'DisplayFormat,DisplayDataType,BaseQueryString,QueryTables,BrowseFields,ColumnLabels,ColumnFormat,'
                                    + 'BrowseFieldDataTypes,BrowseFieldFormats,RowsToBatch,BrowseTitle,ViewerLinkedFields,'
                                    + 'LinkedFieldDataTypes,LinkedFieldFormats,ViewerLinkedWidgets,LookupImage,ParentField,ParentFilterQuery,'
                                    + 'MaintenanceObject,MaintenanceSDO,MasterFile,VisualizationType,LookupImage,Height-Chars,Width-Chars,'
                                    + 'Column,Row,DisplayField,EnableField,HideOnInit,DisableOnInit,ObjectLayout,FieldName'
          cValues     = pcFileName + CHR(3) + cObjectTemplate + CHR(3) + coDisplayedField + CHR(3) + coKeyField + CHR(3) 
                                    + fiFieldLabel + CHR(3) + fiFieldToolTip + CHR(3) + fiFieldFormat + CHR(3) + fiFieldDataType + CHR(3)
                                    + gcDisplayFormat + CHR(3) + gcDisplayDatatype + CHR(3) + EdQuery + CHR(3) + fiQueryTables + CHR(3) 
                                    + gcBrowseFields + CHR(3) + gcColumnLabels + CHR(3) + gcColumnFormat + CHR(3) + gcBrowseFieldDataTypes
                                    + CHR(3) + gcBrowseFieldFormats + CHR(3) + STRING(fiRowsToBatch) + CHR(3) + fiBrowseTitle + CHR(3) 
                                    + gcViewerLinkedFields + CHR(3) + gcLinkedFieldDataTypes + CHR(3) + gcLinkedFieldFormats + CHR(3) 
                                    + gcViewerLinkedWidgets + CHR(3) + gcLLookupImage + CHR(3) + fiParentField + CHR(3) + edParentFilterQuery 
                                    + CHR(3) + cMaintenanceObject + CHR(3) + cMaintenanceSDO + CHR(3) + "adm2/dynlookup.w" + CHR(3)
                                    + "SmartDataField":U + CHR(3) + "adeicon/select.bmp":U + CHR(3) + "1":U + CHR(3) 
                                    + STRING(fiFieldWidth) + CHR(3) + "1":U + CHR(3) + "1":U + CHR(3) + "YES":U
                                    + CHR(3) + STRING(YES) + CHR(3) + STRING(NO) + CHR(3) + STRING(NO) + CHR(3) + cObjectLayout + CHR(3) + "":U.
    /* Update attribute values */
    RUN updateAttributeValues (INPUT dContainerType,
                               INPUT dContainer,
                               INPUT 0,
                               INPUT 0,
                               INPUT cAttributes,
                               INPUT cValues).
    IF RETURN-VALUE <> "":U THEN
      ASSIGN cErrorText = RETURN-VALUE.
  END.
  
  IF cErrorText <> "":U THEN DO:
    RUN showMessages IN gshSessionManager (INPUT  cErrorText,    /* message to display */
                                           INPUT  "ERR":U,          /* error type */
                                           INPUT  "&OK,&Cancel":U,    /* button list */
                                           INPUT  "&OK":U,           /* default button */ 
                                           INPUT  "&Cancel":U,       /* cancel button */
                                           INPUT  "Error creating/update field object":U,             /* error window title */
                                           INPUT  YES,              /* display if empty */ 
                                           INPUT  ?,                /* container handle */ 
                                           OUTPUT cButton           /* button pressed */
                                          ).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSmartObjectDetails vTableWin 
PROCEDURE setSmartObjectDetails :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOk AS LOGICAL    NO-UNDO.
  
  lOk = TRUE NO-ERROR.
  SESSION:SET-WAIT-STATE("GENERAL":U).
  IF raSDFType = "DynLookup":U THEN
    RUN assignLookupValues.
  ELSE
    RUN assignComboValues.
  SESSION:SET-WAIT-STATE("":U).
  
  IF ERROR-STATUS:ERROR OR
     RETURN-VALUE <> "":U OR 
     NOT lOk THEN
    RETURN.
  SESSION:SET-WAIT-STATE("GENERAL":U).
  IF raSDFType = "DynLookup":U THEN
    RUN saveLookupDetails (INPUT fiObjectName).
  ELSE
    RUN saveComboDetails (INPUT fiObjectName).
  SESSION:SET-WAIT-STATE("":U).
  glChangesMade = FALSE.
  MESSAGE "Object Saved Successfully!"
          VIEW-AS ALERT-BOX INFORMATION.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateAttributeValues vTableWin 
PROCEDURE updateAttributeValues :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to update attribute values for an object type, a
               smartobject, or an object instance.
  Parameters:  input object type object number
               input smartobject object number (optional)
               input container smartobject object number (optional)
               input object instance object number (optional)
               input comma delimited list of attribute labels
               input CHR(3) delimited list of corresponding attribute values
  Notes:       If only an object type is passed in, then the attribute values
               will be set for the object type.
               If an object type and smartobject are passed in but no container
               and object instance, then the smartobject attribute values will be
               updated.
               If a container object instance is passed in then the object instance
               attribute values will be updated.
               The attribute value record should first be created if it does not
               yet exist.
               This procedure does not deal with attribute collections and simply
               sets the collect_attribute_value_obj equal to the attribute_value_obj
               when creating a new attribute, and the sequence to 0.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pdObjectType                  AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pdSmartObject                 AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pdContainer                   AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pdInstance                    AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pcAttributeLabels             AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcAttributeValues             AS CHARACTER  NO-UNDO.

DEFINE BUFFER bryc_attribute_value FOR ryc_attribute_value.

DEFINE VARIABLE iLoop                                 AS INTEGER    NO-UNDO.
DEFINE VARIABLE cAttributeLabel                       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttributeValue                       AS CHARACTER  NO-UNDO.

ASSIGN cMessageList = "":U.

/* In case run from rycsomainw.w */
ON FIND OF ryc_attribute OVERRIDE DO: END.

trn-block:
DO FOR bryc_attribute_value TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:

  DO iLoop = 1 TO NUM-ENTRIES(pcAttributeLabels):
    ASSIGN
      cAttributeLabel = ENTRY(iLoop, pcAttributeLabels)
      cAttributeValue = ENTRY(iLoop, pcAttributeValues, CHR(3))
      .

    FIND FIRST ryc_attribute NO-LOCK
         WHERE ryc_attribute.attribute_label = cAttributeLabel
         NO-ERROR.
    IF NOT AVAILABLE ryc_attribute THEN
    DO:
      ASSIGN cMessageList = {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'Attribute Label'" cAttributeLabel}.
      UNDO trn-block, LEAVE trn-block.      
    END.

    FIND FIRST bryc_attribute_value EXCLUSIVE-LOCK
         WHERE bryc_attribute_value.OBJECT_type_obj = pdObjectType
           AND bryc_attribute_value.smartobject_obj = pdSmartObject
           AND bryc_attribute_value.container_smartobject_obj = pdContainer
           AND bryc_attribute_value.object_instance_obj = pdInstance
           AND bryc_attribute_value.attribute_label = cAttributeLabel
         NO-ERROR.

    IF NOT AVAILABLE bryc_attribute_value THEN
    DO:
      CREATE bryc_attribute_value NO-ERROR.
      {checkerr.i &no-return = YES}
      IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
      ASSIGN
        bryc_attribute_value.OBJECT_type_obj = pdObjectType
        bryc_attribute_value.smartobject_obj = pdSmartObject
        bryc_attribute_value.container_smartobject_obj = pdContainer
        bryc_attribute_value.object_instance_obj = pdInstance
        bryc_attribute_value.attribute_label = ryc_attribute.attribute_label
        bryc_attribute_value.attribute_group_obj = ryc_attribute.attribute_group_obj
        bryc_attribute_value.attribute_type_tla = ryc_attribute.attribute_type_tla
        bryc_attribute_value.constant_value = NO
        NO-ERROR.        
      IF bryc_attribute_value.container_smartobject_obj > 0 THEN
        ASSIGN bryc_attribute_value.primary_smartobject_obj = bryc_attribute_value.container_smartobject_obj NO-ERROR.
      ELSE
        ASSIGN bryc_attribute_value.primary_smartobject_obj = bryc_attribute_value.smartobject_obj NO-ERROR.
    END.

    ASSIGN
      bryc_attribute_value.collect_attribute_value_obj = bryc_attribute_value.attribute_value_obj
      bryc_attribute_value.collection_sequence = 0
      bryc_attribute_value.attribute_value = cAttributeValue
      bryc_attribute_value.inheritted_value = NO
      NO-ERROR.

    VALIDATE bryc_attribute_value NO-ERROR.  
    {checkerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

  END. /* iLoop = 1 TO NUM-ENTRIES(pcAttributeLabels): */

END. /* trn-block */
IF cMessageList <> "":U THEN RETURN cMessageList.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateDynamicObject vTableWin 
PROCEDURE updateDynamicObject :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to create / update ASDB gsc_object and RYDB
               ryc_smartobject records for dynamic object passed in.
  Parameters:  input object type (menc, objc, fold, view, brow)
               input product module code
               input object name
               input object description
               input sdo name if required (browsers / viewers only)
               input custom super procedure
               input layout code
               output object number of smartobject created / updated
               output object type object number
  Notes:       Attribute values are cascaded down onto new smartobjects from the
               object type by the replication write trigger of the smartobject
               coded in rycsoreplw.i
               Despite this we copy them down again and update them, in case
               used delete object first option.
               Errors are passed back in return value.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcObjectType                AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcProductModuleCode         AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcObjectName                AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcObjectDescription         AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcSDOName                   AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcSuper                     AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcLayout                    AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pdSmartObject               AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pdObjectType                AS DECIMAL    NO-UNDO.

DEFINE BUFFER bgsc_object FOR gsc_object.
DEFINE BUFFER bryc_smartobject FOR ryc_smartobject.
DEFINE BUFFER bryc_attribute_value FOR ryc_attribute_value.

DEFINE VARIABLE lContainer                          AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cPhysicalObject                     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dPhysicalObject                     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cObjectType                         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dObjectType                         AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dProductModule                      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cLayout                             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dLayout                             AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dSDO                                AS DECIMAL    NO-UNDO.

ASSIGN cMessageList = "":U.

CASE pcObjectType:
  WHEN "Combo":U THEN  /* Dynamic Combo */
  DO:
    ASSIGN
      lContainer = YES
      cPhysicalObject = "dyncombo.w":U
      cObjectType = "dyncombo":U
      cLayout = (IF pcLayout <> "":U THEN pcLayout ELSE "Top/Center/Bottom":U)
      .
  END.
  WHEN "Lookup":U THEN  /* Dynamic Combo */
  DO:
    ASSIGN
      lContainer = YES
      cPhysicalObject = "dynlookup.w":U
      cObjectType = "dynlookup":U
      cLayout = (IF pcLayout <> "":U THEN pcLayout ELSE "Top/Center/Bottom":U)
      .
  END.
  OTHERWISE
  DO:
    RETURN {af/sup2/aferrortxt.i 'RY' '5' '?' '?' pcObjectType}.   
  END.
END CASE.

/* find product module for object */
FIND FIRST gsc_product_module NO-LOCK
     WHERE gsc_product_module.product_module_code = pcProductModuleCode
     NO-ERROR.
IF NOT AVAILABLE gsc_product_module THEN
DO:
  RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'Product Module'" pcProductModuleCode}.   
END.
ELSE ASSIGN dProductModule = gsc_product_module.product_module_obj.

/* Find layout if required */
IF cLayout <> "":U THEN
DO:
  FIND FIRST ryc_layout NO-LOCK
       WHERE ryc_layout.layout_name = cLayout
       NO-ERROR.
  IF NOT AVAILABLE ryc_layout THEN
  DO:
    RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'Layout'" cLayout}.   
  END.
END.
IF cLayout <> "":U AND AVAILABLE ryc_layout THEN
  ASSIGN dLayout = ryc_layout.layout_obj.
ELSE
  ASSIGN dLayout = 0.

/* find corresponding physical object */
FIND FIRST gsc_object NO-LOCK
     WHERE gsc_object.OBJECT_filename = cPhysicalObject
     NO-ERROR.
IF NOT AVAILABLE gsc_object THEN
DO:
  RETURN {af/sup2/aferrortxt.i 'RY' '3' '?' '?' cPhysicalObject}.   
END.
ELSE ASSIGN dPhysicalObject = gsc_object.OBJECT_obj.

/* find object type for object */
FIND FIRST gsc_object_type NO-LOCK
     WHERE gsc_object_type.OBJECT_type_code = cObjectType
     NO-ERROR.
IF NOT AVAILABLE gsc_object_type THEN
DO:
  RETURN {af/sup2/aferrortxt.i 'RY' '4' '?' '?' cObjectType}.   
END.
ELSE ASSIGN dObjectType = gsc_object_type.OBJECT_type_obj.

/* Find SDO name if passed in (viewers / browsers) */
IF pcSDOName <> "":U THEN
DO:
  FIND FIRST ryc_smartobject NO-LOCK
       WHERE ryc_smartobject.OBJECT_filename = pcSDOName
       NO-ERROR.
  IF NOT AVAILABLE ryc_smartobject THEN
  DO:
    RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'SDO Object'" pcSDOName}.   
  END.
  ELSE ASSIGN dSDO = ryc_smartobject.smartobject_obj.
END.
ELSE ASSIGN dSDO = 0.

trn-block:
DO FOR bgsc_object, bryc_smartobject, bryc_attribute_value TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:

  /* find existing ASDB object / create new one */
  FIND FIRST bgsc_object EXCLUSIVE-LOCK
       WHERE bgsc_object.OBJECT_filename = pcObjectName
       NO-ERROR.
  IF NOT AVAILABLE bgsc_object THEN
  DO:
    CREATE bgsc_object NO-ERROR.
    {checkerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

    ASSIGN
      bgsc_object.object_filename = pcObjectName
      bgsc_object.DISABLED = NO
      NO-ERROR.      
  END.

  /* Update ASDB object details */
  ASSIGN
    bgsc_object.object_description = pcObjectDescription 
    bgsc_object.logical_object = YES
    bgsc_object.generic_object = NO
    bgsc_object.container_object = lContainer
    bgsc_object.object_path = "":U
    bgsc_object.object_type_obj = dObjectType
    bgsc_object.physical_object_obj = dPhysicalObject
    bgsc_object.product_module_obj = dProductModule
    bgsc_object.required_db_list = "":U
    bgsc_object.runnable_from_menu = lContainer  
    bgsc_object.run_persistent = YES
    bgsc_object.run_when = "ANY":U
    bgsc_object.security_object_obj = bgsc_object.object_obj
    bgsc_object.toolbar_image_filename = "":U
    bgsc_object.toolbar_multi_media_obj = 0
    bgsc_object.tooltip_text = "":U
    NO-ERROR.
  VALIDATE bgsc_object NO-ERROR.
  {checkerr.i &no-return = YES}
  IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

  /* Find/create RYDB repository object */
  FIND FIRST bryc_smartobject EXCLUSIVE-LOCK
       WHERE bryc_smartobject.OBJECT_filename = pcObjectName
       NO-ERROR.

  IF NOT AVAILABLE bryc_smartobject THEN
  DO:
    CREATE bryc_smartobject NO-ERROR.
    {checkerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
    ASSIGN
      bryc_smartobject.object_filename = pcObjectName
      bryc_smartobject.system_owned = NO
      bryc_smartobject.shutdown_message_text = "":U
      bryc_smartobject.template_smartobject = NO
      NO-ERROR.
  END.

  /* Update rest of details */
  ASSIGN
    bryc_smartobject.static_object = NO
    bryc_smartobject.product_module_obj = dProductModule
    bryc_smartobject.layout_obj = dLayout
    bryc_smartobject.object_obj = bgsc_object.OBJECT_obj
    bryc_smartobject.object_type_obj = dObjectType
    bryc_smartobject.sdo_smartobject_obj = dSDO
    bryc_smartobject.custom_super_procedure = pcSuper
    NO-ERROR.  
  VALIDATE bryc_smartobject NO-ERROR.
  {checkerr.i &no-return = YES}
  IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

  ASSIGN
    pdSmartObject = bryc_smartobject.smartobject_obj
    pdObjectType = dObjectType
    NO-ERROR.

  /* now cascade attribute values down off object type, updating them if they
     already exist.
  */

  attribute-loop:
  FOR EACH ryc_attribute_value NO-LOCK
      WHERE ryc_attribute_value.object_type_obj           = pdObjectType
        AND ryc_attribute_value.smartobject_obj           = 0
        AND ryc_attribute_value.OBJECT_instance_obj       = 0
        AND ryc_attribute_value.container_smartobject_obj = 0:

    FIND FIRST bryc_attribute_value EXCLUSIVE-LOCK
         WHERE bryc_attribute_value.object_type_obj = pdObjectType
           AND bryc_attribute_value.smartobject_obj = pdSmartObject
           AND bryc_attribute_value.object_instance_obj = 0
           AND bryc_attribute_value.container_smartobject_obj = 0
           AND bryc_attribute_value.attribute_label = ryc_attribute_value.attribute_label
         NO-ERROR.           

    IF AVAILABLE bryc_attribute_value AND bryc_attribute_value.inheritted_value = FALSE THEN
      NEXT attribute-loop.  /* do not override manual customisations */

    IF NOT AVAILABLE bryc_attribute_value THEN
    DO:
      CREATE bryc_attribute_value NO-ERROR.
      {checkerr.i &no-return = YES}
      IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
    END.

    ASSIGN
      bryc_attribute_value.object_type_obj = pdObjectType
      bryc_attribute_value.smartobject_obj = pdSmartObject
      bryc_attribute_value.object_instance_obj = 0
      bryc_attribute_value.container_smartobject_obj = 0
      bryc_attribute_value.collect_attribute_value_obj = bryc_attribute_value.attribute_value_obj
      bryc_attribute_value.collection_sequence = 0
      bryc_attribute_value.constant_value = ryc_attribute_value.constant_value
      bryc_attribute_value.attribute_group_obj = ryc_attribute_value.attribute_group_obj
      bryc_attribute_value.attribute_type_tla = ryc_attribute_value.attribute_type_tla
      bryc_attribute_value.attribute_label = ryc_attribute_value.attribute_label
      bryc_attribute_value.PRIMARY_smartobject_obj = pdSmartObject
      bryc_attribute_value.inheritted_value = TRUE
      bryc_attribute_value.attribute_value = ryc_attribute_value.attribute_value
      NO-ERROR.

    VALIDATE bryc_attribute_value NO-ERROR.
    {checkerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

  END. /* attribute-loop */

END. /* trn-block */
IF cMessageList <> "":U THEN RETURN cMessageList.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateData vTableWin 
PROCEDURE validateData :
/*------------------------------------------------------------------------------
  Purpose:     To validate property data entered
  Parameters:  output ok, yes or no.
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER plOk                AS LOGICAL    NO-UNDO.

DEFINE VARIABLE cButton                     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAllFields                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAllNames                   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cField                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cName                       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.

DEFINE VARIABLE dDate                       AS DATE       NO-UNDO.
DEFINE VARIABLE dDecimal                    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE iInteger                    AS INTEGER    NO-UNDO.

DEFINE VARIABLE cMaintenanceObject          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMaintenanceSDO             AS CHARACTER  NO-UNDO.

ASSIGN plOK = YES.

ASSIGN cMaintenanceObject = DYNAMIC-FUNCTION("getDataValue":U IN hMaintenanceObject)
        cMaintenanceSDO   = DYNAMIC-FUNCTION("getDataValue":U IN hMaintenanceSDO). 

DO WITH FRAME {&FRAME-NAME}:

  IF fiObjectName = "":U THEN DO:
    MESSAGE "You must specify an object name."
           VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    ASSIGN plOK = NO.
    APPLY "ENTRY":U TO fiObjectName IN FRAME {&FRAME-NAME}.
    RETURN.
  END.
  IF fiObjectDescription = "":U THEN DO:
    MESSAGE "You must specify an object description."
           VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    ASSIGN plOK = NO.
    APPLY "ENTRY":U TO fiObjectDescription IN FRAME {&FRAME-NAME}.
    RETURN.
  END.
  
  IF fiQueryTables:SCREEN-VALUE = "":U THEN
  DO:
    MESSAGE "Invalid Query - cannot apply changes" SKIP(1)
            "Check the query starts with FOR EACH and does NOT end in a full stop or colon." SKIP
            "Also check you have not misspelled any table names or field names and that" SKIP
            "you have not missed off any commas. Try pasting the query into the procedure" SKIP
            "editor and syntax checking from there - if it works there it should work here" SKIP
            "minus the colon and the end statement"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    ASSIGN plOK = NO.
    RETURN.
  END.

  IF fiBrowseTitle:SCREEN-VALUE = "":U AND raSDFType = "DynLookup":U THEN
  DO:
    MESSAGE "A Browse Title Must be Specified - cannot apply changes"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    ASSIGN plOK = NO.
    RETURN.
  END.

  IF NOT INTEGER(fiRowsToBatch:SCREEN-VALUE) > 0 AND raSDFType = "DynLookup":U THEN
  DO:
    MESSAGE "Rows to Batch Must be Greater Than 0 - cannot apply changes"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    ASSIGN plOK = NO.
    RETURN.
  END.

  IF gcBrowseFields = "":U AND raSDFType = "DynLookup":U THEN
  DO:
    MESSAGE "At Least 1 Browse Field Must be Specified - cannot apply changes"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    ASSIGN plOK = NO.
    RETURN.
  END.

  /* check that we do not have a duplicate field name in 2 buffers for any
     of the selected browse fields, linked fields, key field, or description
     field as this will cause an issue when building the dynamic temp-table
     to store the results in
  */
  IF raSDFType = "DynLookup":U THEN DO:
    ASSIGN cAllFields = coKeyField.
    IF coKeyField <> coDisplayedField THEN
      ASSIGN cAllFields = cAllFields + ",":U + coDisplayedField.
    DO iLoop = 1 TO NUM-ENTRIES(gcBrowseFields):
      IF LOOKUP(ENTRY(iLoop,gcBrowseFields),cAllFields) = 0 THEN
        ASSIGN cAllFields = cAllFields + ",":U + ENTRY(iLoop,gcBrowseFields).
    END.
    DO iLoop = 1 TO NUM-ENTRIES(gcViewerLinkedFields):
      IF LOOKUP(ENTRY(iLoop,gcViewerLinkedFields),cAllFields) = 0 THEN
        ASSIGN cAllFields = cAllFields + ",":U + ENTRY(iLoop,gcViewerLinkedFields).
    END.
  
    field-loop:
    DO iLoop = 1 TO NUM-ENTRIES(cAllFields):
      ASSIGN
        cField = ENTRY(iLoop, cAllFields)
        cName = IF NUM-ENTRIES(cField,".":U) = 2 THEN ENTRY(2,cField,".":U) ELSE cField
        .
      IF LOOKUP(cName, cAllNames) = 0 THEN
        ASSIGN cAllNames = cAllNames + (IF cAllNames = "":U THEN "":U ELSE ",":U) + cName.
      ELSE
      DO:
        MESSAGE "The field name: '" cName "' exists more than once in the list of selected fields." SKIP
                "It is not possible to include fields with the same name in different buffers" SKIP
                "in the list of selected fields. Please check the fields you have selected" SKIP
                "for the browser, the linked fields, the key field and the displayed field" SKIP
                "and remove the duplication" SKIP(1)
                "Full list of selected fields is as follows:" SKIP(1)
                cAllFields
                .
        ASSIGN plOK = NO.
        RETURN.
      END.
    END.
  END.

  IF cMaintenanceObject <> "":U AND
     cMaintenanceSDO     = "":U AND 
     raSDFType = "DynLookup":U THEN DO:
    RUN showMessages IN gshSessionManager (INPUT  "You must specify a Maintenance SDO name when you specify a Maintenance Object.",    /* message to display */
                                           INPUT  "ERR":U,          /* error type */
                                           INPUT  "&OK,&Cancel":U,    /* button list */
                                           INPUT  "&OK":U,           /* default button */ 
                                           INPUT  "&Cancel":U,       /* cancel button */
                                           INPUT  "":U,             /* error window title */
                                           INPUT  YES,              /* display if empty */ 
                                           INPUT  ?,                /* container handle */ 
                                           OUTPUT cButton           /* button pressed */
                                          ).
    ASSIGN plOK = NO.
    RETURN NO-APPLY.
  END.

  IF cMaintenanceSDO    <> "":U AND
     cMaintenanceObject = "":U  AND 
     raSDFType = "DynLookup":U THEN DO:
    RUN showMessages IN gshSessionManager (INPUT  "You must specify a Maintenance Object when you specify a Maintenance SDO name.",    /* message to display */
                                           INPUT  "ERR":U,          /* error type */
                                           INPUT  "&OK,&Cancel":U,    /* button list */
                                           INPUT  "&OK":U,           /* default button */ 
                                           INPUT  "&Cancel":U,       /* cancel button */
                                           INPUT  "":U,             /* error window title */
                                           INPUT  YES,              /* display if empty */ 
                                           INPUT  ?,                /* container handle */ 
                                           OUTPUT cButton           /* button pressed */
                                          ).
    ASSIGN plOK = NO.
    RETURN NO-APPLY.
  END.
  
  IF gcDisplayedFields = "":U AND raSDFType = "DynCombo":U THEN
  DO:
    MESSAGE "At Least 1 Description Field Must be Specified - cannot apply changes"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    ASSIGN plOK = NO.
    RETURN.
  END.

  IF fiFieldLabel = "":U THEN DO:
    MESSAGE "You must specify a field Label!"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    ASSIGN plOK = NO.
    RETURN.
  END.
  
  IF NUM-ENTRIES(gcDisplayedFields) <> numOccurance(fiDescSubstitute,"&":U) AND 
     raSDFType = "DynCombo":U THEN DO:
    MESSAGE "The number of fields to display does not match the field substitution entries." gcDisplayedFields
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    ASSIGN plOK = NO.
    RETURN.
  END.

  /* Check for valid data types in the default value */
  IF fiDefaultValue <> "":U AND 
     raSDFType = "DynCombo":U THEN DO:
    IF (fiFieldDatatype = "CHARACTER":U AND
       (fiDefaultValue  = "?" OR
        fiDefaultValue  = ?)) THEN DO:
      MESSAGE "The default value specified is invalid."
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      ASSIGN plOK = NO.
      RETURN.
    END.
    IF fiFieldDatatype = "DATE":U THEN DO:
      dDate = DATE(fiDefaultValue) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE "The default value specified is invalid. It should be a date or ?"
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        ASSIGN plOK = NO.
        RETURN.
      END.
    END.
    IF fiFieldDatatype = "DECIMAL":U THEN DO:
      dDecimal = DECIMAL(fiDefaultValue) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE "The default value specified is invalid. It should be a valid DECIMAL Value."
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        ASSIGN plOK = NO.
        RETURN.
      END.
    END.
    IF fiFieldDatatype = "INTEGER":U THEN DO:
      iInteger = INTEGER(fiDefaultValue) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE "The default value specified is invalid. It should be a valid INTEGER Value."
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        ASSIGN plOK = NO.
        RETURN.
      END.
    END.
    IF fiFieldDatatype = "LOGICAL":U THEN DO:
      IF LOOKUP(TRIM(fiDefaultValue),"YES,TRUE,NO,FALSE") = 0 THEN DO:
        MESSAGE "The default value specified is invalid. It should be a valid LOGICAL Value e.g. TRUE/FALSE or YES/NO."
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        ASSIGN plOK = NO.
        RETURN.
      END.
    END.
  END.
  
  ASSIGN fiParentField
         edParentFilterQuery
         fiInnerLines.
  IF (fiInnerLines = ? OR 
      fiInnerLines <= 0) AND 
     raSDFType = "DynCombo":U THEN DO:
    RUN showMessages IN gshSessionManager (INPUT  "The Inner Lines specified for this combo is invalid. The inner lines must be equal to or more than 1.",    /* message to display */
                                           INPUT  "ERR":U,          /* error type */
                                           INPUT  "&OK,&Cancel":U,    /* button list */
                                           INPUT  "&OK":U,           /* default button */ 
                                           INPUT  "&Cancel":U,       /* cancel button */
                                           INPUT  "":U,             /* error window title */
                                           INPUT  YES,              /* display if empty */ 
                                           INPUT  ?,                /* container handle */ 
                                           OUTPUT cButton           /* button pressed */
                                          ).
    ASSIGN plOK = NO.
    APPLY "ENTRY":U TO fiInnerLines IN FRAME {&FRAME-NAME}.
    RETURN NO-APPLY.
  END.
  
  IF NUM-ENTRIES(fiParentField) <> numOccurance(edParentFilterQuery,"&":U) AND
     raSDFType = "DynCombo":U THEN DO:
    RUN showMessages IN gshSessionManager (INPUT  "The Parent Filter Query specified is Invalid. The substitution fields in the query does not match the number of parent widgets specified.",    /* message to display */
                                           INPUT  "ERR":U,          /* error type */
                                           INPUT  "&OK,&Cancel":U,    /* button list */
                                           INPUT  "&OK":U,           /* default button */ 
                                           INPUT  "&Cancel":U,       /* cancel button */
                                           INPUT  "":U,             /* error window title */
                                           INPUT  YES,              /* display if empty */ 
                                           INPUT  ?,                /* container handle */ 
                                           OUTPUT cButton           /* button pressed */
                                          ).
    ASSIGN plOK = NO.
    APPLY "ENTRY":U TO edParentFilterQuery IN FRAME {&FRAME-NAME}.
    RETURN NO-APPLY.
  END.
  
  /* Check that the parent filter query is valid */
  IF edParentFilterQuery <> "":U THEN DO:
    IF INDEX(edParentFilterQuery,"FOR ":U)   <> 0 OR
       INDEX(edParentFilterQuery,"EACH ":U)  <> 0 OR 
       INDEX(edParentFilterQuery,"WHERE ":U)  <> 0 OR 
       INDEX(edParentFilterQuery,"FIRST ":U) <> 0 OR
       INDEX(edParentFilterQuery,"LAST ":U)  <> 0 OR
       INDEX(edParentFilterQuery,"BREAK ":U) <> 0 THEN DO:
      RUN showMessages IN gshSessionManager (INPUT  "The parent filter query specified is invalid. Should not contain FOR EACH, FIRST, LAST, Comman ',' or BREAK BY",    /* message to display */
                                             INPUT  "ERR":U,          /* error type */
                                             INPUT  "&OK,&Cancel":U,    /* button list */
                                             INPUT  "&OK":U,           /* default button */ 
                                             INPUT  "&Cancel":U,       /* cancel button */
                                             INPUT  "":U,             /* error window title */
                                             INPUT  YES,              /* display if empty */ 
                                             INPUT  ?,                /* container handle */ 
                                             OUTPUT cButton           /* button pressed */
                                            ).
      ASSIGN plOK = NO.
      APPLY "ENTRY":U TO edParentFilterQuery IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
    END.
  END.


END.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION numOccurance vTableWin 
FUNCTION numOccurance RETURNS INTEGER
  ( INPUT pcString    AS CHARACTER,
    INPUT pcCharacter AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCnt  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLoop AS INTEGER    NO-UNDO.
  
  DO iLoop = 1 TO LENGTH(pcString):
    IF SUBSTRING(pcString,iLoop,1) = pcCharacter THEN
      iCnt = iCnt + 1.
  END.
  
  RETURN iCnt.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setParentFilterHelp vTableWin 
FUNCTION setParentFilterHelp RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  ASSIGN edHelp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
         "Specifying a Parent Filter Query: ~n" +
         "When this object is dependant on the value " +
         "of a parent widget/field, you should specify the name of " + 
         "a widget or field. For database fields, specify the name of the " +
         "field only (excluding the table name or RowObject). For SmartDataFields " +
         "specify the Key Field that the SDF is linked to - for these fields the " +
         "key field's value will be used and not the SCREEN-VALUE. For normal " +
         "FILL-IN widgets the SCREEN-VALUE will be used and for widgets like " +
         "COMBOs the Data Value is used. ~n" +
         "Only fields valid for the Base Query string may be used when " +
         "sepecifying a filter string. ~n" +
         "All string comparisons must be wrapped " +
         "within two singe quotes e.g. '&1'. If a value returned from " + 
         "the parent widget is not the same as the " +
         "table.field it is being compared to, a conversion statement " +
         "must be used to do so. When the filter query involves more than " +
         "one parent field, you should specify the AND/OR in the WHERE CLAUSE.~n~n" + 
         "Example:~n" + 
         "Customer.CustNum = INTEGER('&1') AND Customer.Name BEGINS '&2'".
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

