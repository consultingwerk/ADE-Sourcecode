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
  (v:010005)    Task:           0   UserRef:    
                Date:   03/15/2002  Author:     Mark Davies (MIP)
  Update Notes: Fix for issue #3420 - Dynamic Lookups (and Combos) should have "CustomSuperProc" properties, and should launch this procedure.

  (v:010006)    Task:           0   UserRef:    
                Date:   06/18/2002  Author:     Mark Davies (MIP)

  Update Notes: Use new Repository Design Manager tools to create SDF and to read object details

  (v:010007)    Task:           0   UserRef:    
                Date:   06/21/2002  Author:     Mark Davies (MIP)

  Update Notes: Made changes to comply with V2 Repository changes.

  (v:010008)    Task:           0   UserRef:    
                Date:   08/13/2002  Author:     Mark Davies (MIP)

  Update Notes: Fix for issue #4942 - Error-Character number 3 of format x(4) is invalid

------------------------------------------------------------------------*/
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
DEFINE VARIABLE gcLSDFFileName            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLSDFTemplate            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gclObjectDescription      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLDisplayedField         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLKeyField               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLFieldLabel             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLFieldTooltip           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLKeyFormat              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLKeyDataType            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLDisplayFormat          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLDisplayDataType        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLBaseQueryString        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLQueryTables            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLBrowseFields           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLColumnLabels           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLCoulmnFormat           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLBrowseFieldDataTypes   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLBrowseFieldFormats     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE giLRowsToBatch            AS INTEGER    NO-UNDO.
DEFINE VARIABLE gcLBrowseTitle            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLViewerLinkedFields     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLLinkedFieldDataTypes   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLLinkedFieldFormats     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLViewerLinkedWidgets    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLLookupImage            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLParentField            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLParentFilterQuery      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLMaintenanceObject      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLMaintenanceSDO         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gdLFieldWidth             AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gcLDescSubstitute         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLComboFlag              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLFlagValue              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE giLInnerLines             AS INTEGER    NO-UNDO.
DEFINE VARIABLE giLBuildSeq               AS INTEGER    NO-UNDO.
DEFINE VARIABLE gcLCustomSuperProc        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDisplayedFields         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDisplayFormat           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDisplayDataType         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glChangesMade             AS LOGICAL    NO-UNDO.
DEFINE VARIABLE gcOldObjectName           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glInitialize              AS LOGICAL    NO-UNDO.
DEFINE VARIABLE ghRepositoryDesignManager AS HANDLE     NO-UNDO.
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

{af/app/afdatatypi.i}

/* Temp-table definitions for object tables, which take into account customisation */
{ ry/app/ryobjretri.i }

/* Defines the NO-RESULT-CODE and DEFAULT-RESULT-CODE result codes. */
{ ry/app/rydefrescd.i }

DEFINE VARIABLE gcSessionResultCodes  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gdCurrentUserObj      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdCurrentLanguageObj  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE ghBufferCacheBuffer   AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcLogicalObjectName   AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cComboChildClasses  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLookupChildClasses AS CHARACTER  NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS coObjType buClear fiDisplayRepository ~
fiObjectName fiObjectDescription EdQuery fiRowsToBatch buRefresh BrBrowse ~
coKeyField coDisplayedField fiFieldLabel fiFieldWidth fiFieldToolTip edHelp ~
fiBrowseTitle fiParentField EdParentFilterQuery buSave buClose 
&Scoped-Define DISPLAYED-OBJECTS coObjType fiObjectName fiObjectDescription ~
EdQuery fiRowsToBatch fiQueryTables coKeyField fiFieldDatatype ~
coDisplayedField fiFieldLabel fiFieldWidth fiFieldToolTip edHelp ~
fiBrowseTitle fiParentField EdParentFilterQuery fiTextLabel 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fetchObjectDetail vTableWin 
FUNCTION fetchObjectDetail RETURNS LOGICAL
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBufferHandle vTableWin 
FUNCTION getBufferHandle RETURNS HANDLE
    ( INPUT pcBufferName                AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD numOccurance vTableWin 
FUNCTION numOccurance RETURNS INTEGER
  ( INPUT pcString    AS CHARACTER,
    INPUT pcCharacter AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAttrValues vTableWin 
FUNCTION setAttrValues RETURNS LOGICAL
  ( pcAttrLabel AS CHARACTER,
    pcAttrValue AS CHARACTER )  FORWARD.

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
DEFINE VARIABLE hSuperProc AS HANDLE NO-UNDO.
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

DEFINE VARIABLE coObjType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object Type" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 50 BY 1 NO-UNDO.

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
    WITH NO-ROW-MARKERS SEPARATORS SIZE 130.4 BY 5.14 ROW-HEIGHT-CHARS .62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     coObjType AT ROW 1 COL 21.8 COLON-ALIGNED
     buClear AT ROW 1.1 COL 117.4
     fiDisplayRepository AT ROW 1.1 COL 128.2 COLON-ALIGNED NO-LABEL
     RowObject.product_module_obj AT ROW 1.1 COL 129.4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 1 BY 1
     fiObjectName AT ROW 3.95 COL 21.8 COLON-ALIGNED
     fiObjectDescription AT ROW 5.19 COL 21.8 COLON-ALIGNED
     EdQuery AT ROW 6.91 COL 2.2 NO-LABEL
     fiRowsToBatch AT ROW 7.86 COL 115.4 COLON-ALIGNED NO-LABEL
     buRefresh AT ROW 8.91 COL 117.4
     fiQueryTables AT ROW 10.14 COL 14 COLON-ALIGNED
     BrBrowse AT ROW 11.19 COL 1.8
     coKeyField AT ROW 16.33 COL 21 COLON-ALIGNED
     fiFieldDatatype AT ROW 16.33 COL 99.4 COLON-ALIGNED NO-TAB-STOP 
     fiDescSubstitute AT ROW 17.38 COL 21 COLON-ALIGNED
     coDisplayedField AT ROW 17.38 COL 21 COLON-ALIGNED
     fiFieldFormat AT ROW 17.38 COL 99.4 COLON-ALIGNED
     fiFieldLabel AT ROW 18.43 COL 21 COLON-ALIGNED
     fiFieldWidth AT ROW 18.43 COL 99.4 COLON-ALIGNED
     fiFieldToolTip AT ROW 19.48 COL 21 COLON-ALIGNED
     edHelp AT ROW 19.76 COL 94.6 NO-LABEL NO-TAB-STOP 
     fiBrowseTitle AT ROW 20.52 COL 21 COLON-ALIGNED
     raFlag AT ROW 20.52 COL 23 NO-LABEL
     fiDefaultValue AT ROW 21.48 COL 21 COLON-ALIGNED
     fiInnerLines AT ROW 22.62 COL 21 COLON-ALIGNED
     fiBuildSeq AT ROW 22.62 COL 60.6 COLON-ALIGNED
     fiParentField AT ROW 23.62 COL 21 COLON-ALIGNED
     EdParentFilterQuery AT ROW 24.62 COL 23 NO-LABEL
     buSave AT ROW 26.14 COL 101.8
     buClose AT ROW 26.14 COL 117.2
     fiTextLabel AT ROW 7.1 COL 115 COLON-ALIGNED NO-LABEL
     "Specify Base Query String (FOR EACH)" VIEW-AS TEXT
          SIZE 38.4 BY .62 AT ROW 6.24 COL 2.2
     "Parent Filter Query:" VIEW-AS TEXT
          SIZE 18.4 BY .62 AT ROW 24.62 COL 4.2
     SPACE(51.20) SKIP(2.09)
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
  ASSIGN coObjType.
  
  IF LOOKUP(coObjType:SCREEN-VALUE, cComboChildClasses) <> 0 THEN DO:
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
  DYNAMIC-FUNCTION("setDataValue" IN hSuperProc, "":U). 
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
  APPLY "VALUE-CHANGED":U TO coObjType IN FRAME {&FRAME-NAME}.
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
  DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO.
  
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
    IF cButton = "&YES":U THEN DO:
      APPLY "CHOOSE":U TO buSave IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
    END.
    ELSE
      glChangesMade = FALSE.
  END.
  RUN freeTableHandles. 
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
  IF LOOKUP(coObjType:SCREEN-VALUE, cLookupChildClasses) > 0 THEN
      RUN populateLookup.
  ELSE
      RUN populateCombo.

  glChangesMade = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSave vTableWin
ON CHOOSE OF buSave IN FRAME frMain /* Save */
DO:
  RUN setSmartObjectDetails.
  IF RETURN-VALUE <> "":U THEN
    RETURN NO-APPLY.
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


&Scoped-define SELF-NAME coObjType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coObjType vTableWin
ON VALUE-CHANGED OF coObjType IN FRAME frMain /* Object Type */
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

  hBrowse = BrBrowse:HANDLE.

  IF LOOKUP(coObjType:SCREEN-VALUE, cLookupChildClasses) > 0
  THEN DO:
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
    ELSE DO:
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

  APPLY "CHOOSE":U TO buRefresh.
  glChangesMade = FALSE.
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
    RUN getObjectDetail (INPUT fiObjectName).
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
    DISABLE coObjType WITH FRAME {&FRAME-NAME}.
  ELSE
    ENABLE coObjType WITH FRAME {&FRAME-NAME}.
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
                     ELSE TRUEDescSubstitute&1 / &2CurrentKeyValueComboDelimiterListItemPairsCurrentDescValueInnerLines5ComboFlagFlagValueBuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesFieldName<Local>DisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hProductModule ).
       RUN repositionObject IN hProductModule ( 2.05 , 23.80 ) NO-ERROR.
       RUN resizeObject IN hProductModule ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelUse TemplateFieldTooltipPress F4 For LookupKeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_smartobject NO-LOCK,
                     FIRST gsc_object_type NO-LOCK
                     WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj,
                     FIRST gsc_product NO-LOCK
                     WHERE gsc_product.product_obj = gsc_product_module.product_obj
                     BY gsc_product.product_code BY gsc_product_module.product_module_code BY ryc_smartobject.object_filenameQueryTablesryc_smartobject,gsc_object_type,gsc_product_module,gsc_productBrowseFieldsgsc_product.product_code,gsc_product_module.product_module_code,ryc_smartobject.object_filename,ryc_smartobject.object_description,gsc_object_type.object_type_descriptionBrowseFieldDataTypescharacter,character,character,character,characterBrowseFieldFormatsX(10),X(10),X(70),X(35),X(35)RowsToBatch200BrowseTitleLookupViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldraSDFTypeParentFilterQuerygsc_object_type.object_type_code = ~'&1~'MaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesFieldName<Local>DisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hTemplateObject ).
       RUN repositionObject IN hTemplateObject ( 3.10 , 23.80 ) NO-ERROR.
       RUN resizeObject IN hTemplateObject ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelFieldTooltipPress F4 For SDF LookupKeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_smartobject NO-LOCK,
                     FIRST gsc_object_type NO-LOCK
                     WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj,
                     FIRST gsc_product NO-LOCK
                     WHERE gsc_product.product_obj = gsc_product_module.product_obj
                     BY gsc_product.product_code BY gsc_product_module.product_module_code BY ryc_smartobject.object_filenameQueryTablesryc_smartobject,gsc_object_type,gsc_product_module,gsc_productBrowseFieldsgsc_product.product_code,gsc_product_module.product_module_code,ryc_smartobject.object_filename,ryc_smartobject.object_description,gsc_object_type.object_type_descriptionBrowseFieldDataTypescharacter,character,character,character,characterBrowseFieldFormatsX(10),X(10),X(70),X(35),X(35)RowsToBatch200BrowseTitleLookup Dynamic SDFViewerLinkedFieldsryc_smartobject.object_filenameLinkedFieldDataTypescharacterLinkedFieldFormatsX(70)ViewerLinkedWidgetsfiObjectNameColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldraSDFTypeParentFilterQuerygsc_object_type.object_type_code = ~'&1~'MaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesFieldName<Local>DisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hObjectName ).
       RUN repositionObject IN hObjectName ( 4.14 , 23.80 ) NO-ERROR.
       RUN resizeObject IN hObjectName ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelMaintenance SDOFieldTooltipPress F4 For Maintenance SDO LookupKeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK
                     WHERE gsc_object_type.object_type_code = "SDO":U
                     OR gsc_object_type.object_type_code = "dynSDO":U
                     OR gsc_object_type.object_type_code = "SBO":U,
                     EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj,
                     FIRST gsc_product NO-LOCK
                     WHERE gsc_product.product_obj = gsc_product_module.product_obj
                     BY gsc_product.product_code BY gsc_product_module.product_module_code BY ryc_smartobject.object_filenameQueryTablesgsc_object_type,ryc_smartobject,gsc_product_module,gsc_productBrowseFieldsgsc_product.product_code,gsc_product_module.product_module_code,ryc_smartobject.object_filename,ryc_smartobject.object_description,gsc_object_type.object_type_descriptionBrowseFieldDataTypescharacter,character,character,character,characterBrowseFieldFormatsX(10),X(10),X(70),X(35),X(35)RowsToBatch200BrowseTitleLookup Maintenance SDOViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesFieldName<Local>DisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hMaintenanceSDO ).
       RUN repositionObject IN hMaintenanceSDO ( 21.57 , 23.00 ) NO-ERROR.
       RUN resizeObject IN hMaintenanceSDO ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelMaintenenace ObjectFieldTooltipPress F4 For Maintenance Object LookupKeyFormatX(35)KeyDatatypecharacterDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.container_object = TRUE,
                     FIRST gsc_object_type NO-LOCK
                     WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj,
                     FIRST gsc_product NO-LOCK
                     WHERE gsc_product.product_obj = gsc_product_module.product_obj
                     BY gsc_product.product_code BY gsc_product_module.product_module_code BY ryc_smartobject.object_filenameQueryTablesryc_smartobject,gsc_object_type,gsc_product_module,gsc_productBrowseFieldsgsc_product.product_code,gsc_product_module.product_module_code,ryc_smartobject.object_filename,ryc_smartobject.object_description,gsc_object_type.object_type_descriptionBrowseFieldDataTypescharacter,character,character,character,characterBrowseFieldFormatsX(10),X(10),X(35),X(35),X(35)RowsToBatch200BrowseTitleLookup Maintenance ObjectViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesFieldName<Local>DisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hMaintenanceObject ).
       RUN repositionObject IN hMaintenanceObject ( 22.62 , 23.00 ) NO-ERROR.
       RUN resizeObject IN hMaintenanceObject ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.smartobject_objFieldLabelCustom Super ProcFieldTooltipPress F4 For Custom Super Procedure LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK
                     WHERE gsc_object_type.object_type_code = ~'Procedure~',
                     EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj,
                     FIRST gsc_product NO-LOCK
                     WHERE gsc_product.product_obj = gsc_product_module.product_obj
                     BY gsc_product.product_code BY gsc_product_module.product_module_code BY ryc_smartobject.object_filenameQueryTablesgsc_object_type,ryc_smartobject,gsc_product_module,gsc_productBrowseFieldsgsc_product.product_code,gsc_product_module.product_module_code,ryc_smartobject.object_filename,ryc_smartobject.object_description,gsc_object_type.object_type_description,ryc_smartobject.object_pathBrowseFieldDataTypescharacter,character,character,character,character,characterBrowseFieldFormatsX(10),X(10),X(70),X(35),X(35),X(70)RowsToBatch200BrowseTitleLookup Custom Super ProcedureViewerLinkedFieldsryc_smartobject.object_pathLinkedFieldDataTypescharacterLinkedFieldFormatsX(70)ViewerLinkedWidgetsfiRelativePathColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesFieldName<Local>DisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hSuperProc ).
       RUN repositionObject IN hSuperProc ( 26.33 , 23.00 ) NO-ERROR.
       RUN resizeObject IN hSuperProc ( 1.00 , 50.00 ) NO-ERROR.

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
       RUN adjustTabOrder ( hSuperProc ,
             buClose:HANDLE IN FRAME frMain , 'AFTER':U ).
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
    
    ASSIGN 
      gcLDisplayFormat   = IF NUM-ENTRIES(gcDisplayedFields) > 1 THEN "X(256)":U ELSE gcDisplayFormat
      gcLKeyDataType     = fiFieldDatatype
      gcLDisplayDatatype = gcDisplayDataType.

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
                           (IF gcBrowseFieldFormats = "":U THEN "":U ELSE "|":U) +
                           bttFields.cFieldFormat
        gcColumnLabels   = gcColumnLabels + bttFields.cColumnLabels + ",":U
        gcColumnFormat   = gcColumnFormat + bttFields.cColumnFormat + "|":U

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
  
    /* Trim the extra ',' and '|' from the lists */
    ASSIGN gcColumnLabels = RIGHT-TRIM(gcColumnLabels,",":U)
           gcColumnFormat = RIGHT-TRIM(gcColumnFormat,"|":U).

    /* Clear these fields if nothing has been assigned to them */
    IF gcColumnLabels = FILL(",":U,NUM-ENTRIES(gcBrowseFields) - 1) THEN
      gcColumnLabels = "":U.
    IF gcColumnFormat = FILL("|":U,NUM-ENTRIES(gcBrowseFields) - 1) THEN
      gcColumnFormat = "":U.
    
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
    IF cButton = "&YES":U THEN DO:
      plCancel = FALSE.
      APPLY "CHOOSE":U TO buSave IN FRAME {&FRAME-NAME}.
    END.
  END.
  RUN freeTableHandles.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE freeTableHandles vTableWin 
PROCEDURE freeTableHandles :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hObjectQuery            AS HANDLE                   NO-UNDO.
  DEFINE VARIABLE hDestroyObject          AS HANDLE                   NO-UNDO.
  DEFINE VARIABLE cObjectHandles          AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE iHandleLoop             AS INTEGER                  NO-UNDO.

  
  /** Destroy all dynamic temp-tables used by this procedure.
   *  ----------------------------------------------------------------------- **/
  CREATE WIDGET-POOL "destroyObject":U.
  CREATE QUERY hObjectQuery IN WIDGET-POOL "destroyObject":U.
  IF VALID-HANDLE(ghBufferCacheBuffer) THEN DO:
    hObjectQuery:ADD-BUFFER(ghBufferCacheBuffer).
    hObjectQuery:QUERY-PREPARE(" FOR EACH ":U + ghBufferCacheBuffer:NAME).
  
    hObjectQuery:QUERY-OPEN().
    hObjectQuery:GET-FIRST().
  
    DO WHILE ghBufferCacheBuffer:AVAILABLE:
        ASSIGN cObjectHandles = cObjectHandles + (IF NUM-ENTRIES(cObjectHandles) EQ 0 THEN "":U ELSE ",":U)
                              + STRING(ghBufferCacheBuffer:BUFFER-FIELD("tBufferHandle":U):BUFFER-VALUE).
        hObjectQuery:GET-NEXT().
    END.    /* available objects */
    hObjectQuery:QUERY-CLOSE().  
  END.

  DELETE WIDGET-POOL "destroyObject":U.
  
  /** Close all super procedures and Temp-tables marked for destruction. 
   *  ----------------------------------------------------------------------- **/
  DO iHandleLoop = 1 TO NUM-ENTRIES(cObjectHandles):
      ASSIGN hDestroyObject = WIDGET-HANDLE(ENTRY(iHandleLoop, cObjectHandles)).

      IF VALID-HANDLE(hDestroyObject) THEN
      DO:
          DELETE OBJECT hDestroyObject NO-ERROR.
          ASSIGN hDestroyObject = ?.
      END.    /* valid handle  */
  END.    /* handle loop */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getObjectDetail vTableWin 
PROCEDURE getObjectDetail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcLogicalObjectName AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iEntry                      AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cDataTargets                AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cSdoForeignFields           AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cInitialPageList            AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE hDataTarget                 AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hObjectBuffer               AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hPageBuffer                 AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hPageInstanceBuffer         AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hLinkBuffer                 AS HANDLE      NO-UNDO.  
  DEFINE VARIABLE hClassAttributeBuffer       AS HANDLE      NO-UNDO.
  DEFINE VARIABLE dContainerRecordIdentifier  AS DECIMAL     NO-UNDO.
  
  DEFINE VARIABLE iFieldLoop                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hObjectQuery                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTableQuery                 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cAttrList                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessageList                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton                     AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cDataset                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dSmartObjectObj             AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dProductModuleObj           AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cProductModuleCode          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCustomSuperProcedure       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomSuperProcedureObj    AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cObjectDescription          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dObjectTypeObj              AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cObjectType                 AS CHARACTER  NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  
  ASSIGN gcLogicalObjectName =  pcLogicalObjectName.

  /* Since we are developing it might be usefull to clear the cache everytime before
     getting new information */
  
  RUN clearClientCache IN gshRepositoryManager.
  
  IF NOT DYNAMIC-FUNCTION("fetchObjectDetail":U) THEN
  DO:
    /* We might be adding a new object */
    /*
    cMessage = "Could find details for this Smart Data Field " + pcLogicalObjectName.
    cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                  {af/sup2/aferrortxt.i 'AF' '11' '' '' '"SmartObject Record"' '"the name you specified"'}.
     
    RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Error - Object not found",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).
    */
    RETURN.
    
  END.    /* errors fdetching object detail. */

  ASSIGN hObjectBuffer       = DYNAMIC-FUNCTION("getBufferHandle", INPUT "return_Object":U)
         hPageBuffer         = DYNAMIC-FUNCTION("getBufferHandle", INPUT "return_ObjectPage":U)
         hPageInstanceBuffer = DYNAMIC-FUNCTION("getBufferHandle", INPUT "return_ObjectPageInstance":U)
         hLinkBuffer         = DYNAMIC-FUNCTION("getBufferHandle", INPUT "return_ObjectLink":U)
         .
  /* Container Attribute Values */
  hObjectBuffer:FIND-FIRST(" WHERE ":U
                           + hObjectBuffer:NAME + ".tContainerObjectName = '":U + gcLogicalObjectName                + "' AND ":U
                           + hObjectBuffer:NAME + ".tLogicalObjectName   = '":U + gcLogicalObjectName                + "' AND ":U
                           + hObjectBuffer:NAME + ".tResultCode          = '":U + gcSessionResultCodes               + "' AND ":U
                           + hObjectBuffer:NAME + ".tUserObj             = ":U  + TRIM(QUOTER(gdCurrentUserObj))     + " AND ":U
                           + hObjectBuffer:NAME + ".tRunAttribute        = '' AND ":U
                           + hObjectBuffer:NAME + ".tLanguageObj         = ":U  + TRIM(QUOTER(gdCurrentLanguageObj)) + " ":U
                            ) NO-ERROR.
  IF NOT hObjectBuffer:AVAILABLE  THEN RETURN.

  ASSIGN hClassAttributeBuffer      = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
         dContainerRecordIdentifier = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
         .
  ASSIGN cCustomSuperProcedure = hObjectBuffer:BUFFER-FIELD("tCustomSuperProcedure":U):BUFFER-VALUE
         dSmartObjectObj       = DYNAMIC-FUNCTION("getSmartObjectObj":U IN ghRepositoryDesignManager, pcLogicalObjectName, 0).
  
  hClassAttributeBuffer:FIND-FIRST(" WHERE ":U + hClassAttributeBuffer:NAME + ".tRecordIdentifier = " + TRIM(QUOTER(dContainerRecordIdentifier))) NO-ERROR.
  
  cAttrList = "":U.
  /* Create Attributes for main Object */
  IF hClassAttributeBuffer:AVAILABLE THEN
  DO iFieldLoop = 1 TO hClassAttributeBuffer:NUM-FIELDS:
    /* Setting the container mode for a viewer is giving me hassels in datavis.p */
    IF hClassAttributeBuffer:BUFFER-FIELD(ifieldLoop):NAME = "ContainerMode" THEN
      NEXT.
    setAttrValues(hClassAttributeBuffer:BUFFER-FIELD(ifieldLoop):NAME,STRING(hClassAttributeBuffer:BUFFER-FIELD(iFieldLoop):BUFFER-VALUE)).
  END.    /* loop through fields */
  
  /* Get Object's Product Module */
  RUN getRecordDetail IN gshGenManager ( INPUT "FOR EACH ryc_smartobject 
                                                WHERE ryc_smartobject.smartobject_obj = " + TRIM(QUOTER(dSmartObjectObj)) + " NO-LOCK ":U,
                                         OUTPUT cDataset ).
  ASSIGN dProductModuleObj        = 0
         cObjectDescription       = "":U
         dObjectTypeObj           = 0
         dCustomSuperProcedureObj = 0.
  IF cDataset <> "":U AND cDataset <> ? THEN 
    ASSIGN dProductModuleObj        = DECIMAL(ENTRY(LOOKUP("ryc_smartobject.product_module_obj":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3)))  
           cObjectDescription       = ENTRY(LOOKUP("ryc_smartobject.object_description":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3)) 
           dObjectTypeObj           = DECIMAL(ENTRY(LOOKUP("ryc_smartobject.object_type_obj":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3)))
           dCustomSuperProcedureObj = DECIMAL(ENTRY(LOOKUP("ryc_smartobject.custom_smartobject_obj":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3)))
           NO-ERROR.

  /* Get Object Type */
  RUN getRecordDetail IN gshGenManager ( INPUT "FOR EACH gsc_object_type 
                                                WHERE gsc_object_type.object_type_obj = " + TRIM(QUOTER(dObjectTypeObj)) + " NO-LOCK ":U,
                                         OUTPUT cDataset ).

  ASSIGN cObjectType = "":U.
  IF cDataset <> "":U AND cDataset <> ? THEN 
    ASSIGN cObjectType = ENTRY(LOOKUP("gsc_object_type.object_type_code":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3)) NO-ERROR.
  
  /* Get Product Module Code */
  RUN getRecordDetail IN gshGenManager ( INPUT "FOR EACH gsc_product_module 
                                                WHERE gsc_product_module.product_module_obj = " + TRIM(QUOTER(dProductModuleObj)) + " NO-LOCK ":U,
                                         OUTPUT cDataset ).

  ASSIGN cProductModuleCode = "":U.
  IF cDataset <> "":U AND cDataset <> ? THEN 
    ASSIGN cProductModuleCode = ENTRY(LOOKUP("gsc_product_module.product_module_code":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3)) NO-ERROR.
  
  IF  LOOKUP(cObjectType, cLookupChildClasses) = 0 
  AND LOOKUP(cObjectType, cComboChildClasses)  = 0 
  THEN DO:     
    RUN showMessages IN gshSessionManager (INPUT  "The SmartObject specified " + pcLogicalObjectName + " is not a valid SDF object - valid types are Dynamic Combo and Dynamic Lookup. " + cObjectType,    /* message to display */
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

  DELETE OBJECT hObjectQuery NO-ERROR.
  ASSIGN hObjectQuery = ?.

  ASSIGN coObjType = cObjectType.
  DISPLAY coObjType WITH FRAME {&FRAME-NAME}.
  APPLY "VALUE-CHANGED":U TO coObjType IN FRAME {&FRAME-NAME}.
  ASSIGN fiObjectName = pcLogicalObjectName.
  DISPLAY fiObjectName WITH FRAME {&FRAME-NAME}.
  APPLY "VALUE-CHANGED":U TO fiObjectName IN FRAME {&FRAME-NAME}.

  DO WITH FRAME {&FRAME-NAME}:
    
    ASSIGN
      gcBaseQuery    = gcLBaseQueryString
      fiFieldWidth   = gdLFieldWidth
      edQuery        = gcBaseQuery
      gcBrowseFields = IF LOOKUP(coObjType:SCREEN-VALUE, cLookupChildClasses) <> 0 THEN gcLBrowseFields ELSE gcLDisplayedField.
    
    DYNAMIC-FUNCTION("setDataValue":U IN hProductModule,cProductModuleCode).
    RUN assignNewValue IN hSuperProc (dCustomSuperProcedureObj,"":U,FALSE).

    IF LOOKUP(coObjType:SCREEN-VALUE, cLookupChildClasses) <> 0 THEN DO:
      ASSIGN 
        gcViewerLinkedFields  = gcLViewerLinkedFields 
        gcViewerLinkedWidgets = gcLViewerLinkedWidgets
        gcColumnLabels        = gcLColumnLabels
        gcColumnFormat        = gcLCoulmnFormat
        fiRowsToBatch         = giLRowsToBatch
        fiBrowseTitle         = gcLBrowseTitle.
      
      RUN assignNewValue IN hMaintenanceObject (gcLMaintenanceObject,"":U,FALSE).
      RUN assignNewValue IN hMaintenanceSDO (gcLMaintenanceSDO,"":U,FALSE).

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
      edParentFilterQuery = gcLParentFilterQuery
      fiObjectDescription = cObjectDescription.
    
    DISPLAY
      fiObjectDescription
      fiFieldLabel
      fiFieldWidth
      fiBrowseTitle WHEN LOOKUP(coObjType:SCREEN-VALUE, cLookupChildClasses) <> 0
      fiFieldToolTip 
      fiRowsToBatch WHEN LOOKUP(coObjType:SCREEN-VALUE, cLookupChildClasses) <> 0
      fiParentField 
      edParentFilterQuery
      fiDescSubstitute WHEN LOOKUP(coObjType:SCREEN-VALUE, cComboChildClasses) <> 0
      fiDefaultValue WHEN LOOKUP(coObjType:SCREEN-VALUE, cComboChildClasses) <> 0 
      fiInnerLines WHEN LOOKUP(coObjType:SCREEN-VALUE, cComboChildClasses) <> 0 
      fiBuildSeq WHEN LOOKUP(coObjType:SCREEN-VALUE, cComboChildClasses) <> 0.
      
      ASSIGN coDisplayedField:SCREEN-VALUE = IF LOOKUP(coObjType:SCREEN-VALUE, cLookupChildClasses) <> 0 THEN gcLDisplayedField ELSE coDisplayedField:ENTRY(1)
             coKeyField:SCREEN-VALUE       = gcLKeyField.
    APPLY "VALUE-CHANGED":U TO coKeyField.
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
  
  IF 1 = 2 THEN VIEW FRAME {&FRAME-NAME}. /* Lazy frame scoping */

  ASSIGN cComboChildClasses   = DYNAMIC-FUNCTION("getClassChildrenFromDb":U IN gshRepositoryManager, INPUT "dynCombo,dynLookup")
         coObjType:LIST-ITEMS = REPLACE(cComboChildClasses, CHR(3), ",":U)
         cLookupChildClasses  = ENTRY(2, cComboChildClasses, CHR(3))
         cComboChildClasses   = ENTRY(1, cComboChildClasses, CHR(3)).

  IF coObjType:SCREEN-VALUE = ?
  OR coObjType:SCREEN-VALUE = "":U THEN
      ASSIGN coObjType:SCREEN-VALUE = coObjType:ENTRY(1) NO-ERROR.
  APPLY "VALUE-CHANGED":U TO coObjType.

  RUN SUPER.
  glInitialize = TRUE.
  RUN displayFields IN TARGET-PROCEDURE (?).
  RUN enableField IN hProductModule.
  RUN enableField IN hTemplateObject.
  RUN enableField IN hObjectName.
  RUN enableField IN hMaintenanceSDO.
  RUN enableField IN hMaintenanceObject.
  RUN enableField IN hSuperProc.
  /* Determine whether the user wants to display repository data. */
  ASSIGN rRowid = ?.
  RUN getProfileData IN gshProfileManager ( INPUT        "General":U,
                                            INPUT        "DispRepos":U,
                                            INPUT        "DispRepos":U,
                                            INPUT        NO,
                                            INPUT-OUTPUT rRowid,
                                                  OUTPUT cDisplayRepository).
  ASSIGN ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE,
                                                      INPUT "RepositoryDesignManager":U).

  IF NOT VALID-HANDLE(ghRepositoryDesignManager) THEN
      RETURN "The Repository Design Manager could not be found.":U.
  
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
  
  DEFINE VARIABLE iEntry AS INTEGER    NO-UNDO.
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN coObjType. 
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
      RUN getObjectDetail (INPUT pcKeyFieldValue).
    DYNAMIC-FUNCTION("setDataValue":U IN hTemplateObject,pcKeyFieldValue).
    IF pcKeyFieldValue <> "":U THEN DO:
      DISABLE coObjType WITH FRAME {&FRAME-NAME}.
      APPLY "LEAVE":U TO BrBrowse IN FRAME {&FRAME-NAME}.
      glChangesMade = FALSE.
    END.
  END.
  
  IF phLookup = hMaintenanceSDO OR
     phLookup = hMaintenanceObject OR
     phLookup = hSuperProc THEN
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
  
      IF NUM-ENTRIES(gcColumnFormat,"|":U) = 1 AND 
         gcColumnFormat <> "":U THEN
        gcColumnFormat = REPLACE(gcColumnFormat,",":U,"|":U).
      
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
          ttFields.cColumnFormat = IF gcColumnFormat <> "":U AND gcColumnFormat <> ? THEN IF NUM-ENTRIES(gcColumnFormat) >= iBrowseEntry AND iBrowseEntry <> 0 THEN ENTRY(iBrowseEntry,gcColumnFormat,"|":U) ELSE "":U ELSE "":U
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
  DEFINE VARIABLE dSuperProc         AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE cSuperProcedure    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSet           AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cAttributeLabels   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttributeValues   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttributeDataType AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dSDFObjectObj      AS DECIMAL    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fiFieldDataType
           fiFieldFormat
           fiFieldWidth
           fiObjectDescription.
  END.
  ASSIGN cProductModule  = DYNAMIC-FUNCTION("getDataValue":U IN hProductModule)
         cObjectTemplate = DYNAMIC-FUNCTION("getDataValue":U IN hTemplateObject).
         dSuperProc      = DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hSuperProc)).
  /* Get Object's Product Module */
  RUN getRecordDetail IN gshGenManager ( INPUT "FOR EACH ryc_smartobject 
                                               WHERE ryc_smartobject.smartobject_obj = " + TRIM(QUOTER(dSuperProc)) + " NO-LOCK ":U,
                                        OUTPUT cDataset ).
  ASSIGN cSuperProcedure = "":U.
  IF cDataset <> "":U AND cDataset <> ? THEN 
   ASSIGN cSuperProcedure  = ENTRY(LOOKUP("ryc_smartobject.object_filename":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3))
          NO-ERROR.
  ASSIGN cAttributeLabels   = 'SDFFileName' + CHR(1) + 
                              'SDFTemplate' + CHR(1) + 
                              'DisplayedField' + CHR(1) + 
                              'KeyField' + CHR(1) +
                              'FieldLabel' + CHR(1) +
                              'FieldTooltip' + CHR(1) +
                              'DisplayFormat' + CHR(1) +
                              'DisplayDataType' + CHR(1) +
                              'KeyFormat' + CHR(1) +
                              'KeyDataType' + CHR(1) +
                              'BaseQueryString' + CHR(1) +
                              'QueryTables' + CHR(1) +
                              'ParentField' + CHR(1) +
                              'ParentFilterQuery' + CHR(1) +
                              'Width-Chars' + CHR(1) +
                              'Height-Chars' + CHR(1) +
                              'Column' + CHR(1) +
                              'Row' + CHR(1) +
                              'ComboFlag' + CHR(1) +
                              'DescSubstitute' + CHR(1) +
                              'InnerLines' + CHR(1) +
                              'FlagValue' + CHR(1) +
                              'BuildSequence' + CHR(1) +
                              'EnableField' + CHR(1) +
                              'HideOnInit' + CHR(1) +
                              'DisableOnInit' + CHR(1) +
                              'ObjectLayout' + CHR(1) +
                              'FieldName'
         cAttributeValues   = pcFileName + CHR(1) + 
                              cObjectTemplate + CHR(1) + 
                              gcDisplayedFields + CHR(1) + 
                              coKeyField + CHR(1) + 
                              fiFieldLabel + CHR(1) + 
                              fiFieldToolTip + CHR(1) + 
                              gcLDisplayFormat + CHR(1) + 
                              gcLDisplayDatatype + CHR(1) + 
                              fiFieldFormat + CHR(1) + 
                              gcLKeyDataType + CHR(1) + 
                              EdQuery + CHR(1) + 
                              fiQueryTables + CHR(1) + 
                              fiParentField + CHR(1) + 
                              edParentFilterQuery + CHR(1) + 
                              STRING(fiFieldWidth) + CHR(1) + 
                              "1":U + CHR(1) + 
                              "1":U + CHR(1) + 
                              "1":U + CHR(1) + 
                              raFlag + CHR(1) + 
                              fiDescSubstitute + CHR(1) + 
                              STRING(fiInnerLines) + CHR(1) + 
                              fiDefaultValue + CHR(1) + 
                              STRING(fiBuildSeq) + CHR(1) + 
                              "TRUE":U + CHR(1) + 
                              "FALSE":U + CHR(1) + 
                              "FALSE":U + CHR(1) + 
                              cObjectLayout + CHR(1) + 
                              "":U
         cAttributeDataType = '{&CHARACTER-DATA-TYPE}' + CHR(1) +      
                              '{&CHARACTER-DATA-TYPE}' + CHR(1) +      
                              '{&CHARACTER-DATA-TYPE}' + CHR(1) +   
                              '{&CHARACTER-DATA-TYPE}' + CHR(1) +         
                              '{&CHARACTER-DATA-TYPE}' + CHR(1) +       
                              '{&CHARACTER-DATA-TYPE}' + CHR(1) +     
                              '{&CHARACTER-DATA-TYPE}' + CHR(1) +    
                              '{&CHARACTER-DATA-TYPE}' + CHR(1) +  
                              '{&CHARACTER-DATA-TYPE}' + CHR(1) +        
                              '{&CHARACTER-DATA-TYPE}' + CHR(1) +      
                              '{&CHARACTER-DATA-TYPE}' + CHR(1) +  
                              '{&CHARACTER-DATA-TYPE}' + CHR(1) +      
                              '{&CHARACTER-DATA-TYPE}' + CHR(1) +      
                              '{&CHARACTER-DATA-TYPE}' + CHR(1) +       
                              '{&DECIMAL-DATA-TYPE}'   + CHR(1) +      
                              '{&DECIMAL-DATA-TYPE}'   + CHR(1) +     
                              '{&DECIMAL-DATA-TYPE}'   + CHR(1) +           
                              '{&DECIMAL-DATA-TYPE}'   + CHR(1) +              
                              '{&CHARACTER-DATA-TYPE}' + CHR(1) +        
                              '{&CHARACTER-DATA-TYPE}' + CHR(1) +   
                              '{&INTEGER-DATA-TYPE}'   + CHR(1) +       
                              '{&CHARACTER-DATA-TYPE}' + CHR(1) +        
                              '{&INTEGER-DATA-TYPE}'   + CHR(1) +    
                              '{&LOGICAL-DATA-TYPE}'   + CHR(1) +      
                              '{&LOGICAL-DATA-TYPE}'   + CHR(1) +       
                              '{&LOGICAL-DATA-TYPE}'   + CHR(1) +    
                              '{&CHARACTER-DATA-TYPE}' + CHR(1) +     
                              '{&CHARACTER-DATA-TYPE}'.
      
   RUN generateDynamicSDF IN ghRepositoryDesignManager ( INPUT  pcFileName,               /*pcObjectName              */
                                                         INPUT  fiObjectDescription,      /*pcObjectDescription       */
                                                         INPUT  cProductModule,           /*pcProductModuleCode       */
                                                         INPUT  "":U,                     /*pcResultCode              */
                                                         INPUT  TRUE,                     /*plDeleteExistingInstances */
                                                         INPUT  coObjType:SCREEN-VALUE,   /*pcSDFType                 */
                                                         INPUT  cSuperProcedure,          /*pcSuperProcedure          */
                                                         INPUT  cAttributeLabels,         /*pcAttributeLabels         */
                                                         INPUT  cAttributeValues,         /*pcAttributeValues         */
                                                         INPUT  cAttributeDataType,       /*pcAttributeDateType       */
                                                         OUTPUT dSDFObjectObj ) NO-ERROR. /*pdSDFObjectObj            */
   IF RETURN-VALUE <> "":U THEN
     ASSIGN cErrorText = RETURN-VALUE. 
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
  DEFINE VARIABLE dSuperProc         AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cSuperProcedure    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSet           AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cAttributeLabels   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttributeValues   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttributeDataType AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dSDFObjectObj      AS DECIMAL    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fiFieldDataType
           fiFieldFormat
           fiFieldWidth
           fiObjectDescription.
  END.
  ASSIGN cProductModule     = DYNAMIC-FUNCTION("getDataValue":U IN hProductModule)
         cObjectTemplate    = DYNAMIC-FUNCTION("getDataValue":U IN hTemplateObject)
         cMaintenanceObject = DYNAMIC-FUNCTION("getDataValue":U IN hMaintenanceObject)
         cMaintenanceSDO    = DYNAMIC-FUNCTION("getDataValue":U IN hMaintenanceSDO)
         dSuperProc         = DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hSuperProc)).
 
  /* Get Object's Product Module */
  RUN getRecordDetail IN gshGenManager ( INPUT "FOR EACH ryc_smartobject 
                                                WHERE ryc_smartobject.smartobject_obj = " + TRIM(QUOTER(dSuperProc)) + " NO-LOCK ":U,
                                         OUTPUT cDataset ).
  ASSIGN cSuperProcedure = "":U.
  IF cDataset <> "":U AND cDataset <> ? THEN 
    ASSIGN cSuperProcedure  = ENTRY(LOOKUP("ryc_smartobject.object_filename":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3))
           NO-ERROR.

  ASSIGN cAttributeLabels = 'SDFFileName'+ CHR(1) + 
                            'SDFTemplate'+ CHR(1) + 
                            'DisplayedField'+ CHR(1) + 
                            'KeyField'+ CHR(1) + 
                            'FieldLabel'+ CHR(1) + 
                            'FieldTooltip'+ CHR(1) + 
                            'KeyFormat'+ CHR(1) + 
                            'KeyDataType'+ CHR(1) + 
                            'DisplayFormat'+ CHR(1) + 
                            'DisplayDataType'+ CHR(1) + 
                            'BaseQueryString'+ CHR(1) + 
                            'QueryTables'+ CHR(1) + 
                            'BrowseFields'+ CHR(1) + 
                            'ColumnLabels'+ CHR(1) + 
                            'ColumnFormat'+ CHR(1) + 
                            'BrowseFieldDataTypes'+ CHR(1) + 
                            'BrowseFieldFormats'+ CHR(1) + 
                            'RowsToBatch'+ CHR(1) + 
                            'BrowseTitle'+ CHR(1) + 
                            'ViewerLinkedFields'+ CHR(1) + 
                            'LinkedFieldDataTypes'+ CHR(1) + 
                            'LinkedFieldFormats'+ CHR(1) + 
                            'ViewerLinkedWidgets'+ CHR(1) + 
                            'LookupImage'+ CHR(1) + 
                            'ParentField'+ CHR(1) + 
                            'ParentFilterQuery'+ CHR(1) + 
                            'MaintenanceObject'+ CHR(1) + 
                            'MaintenanceSDO'+ CHR(1) + 
                            'VisualizationType'+ CHR(1) + 
                            'LookupImage'+ CHR(1) + 
                            'Height-Chars'+ CHR(1) + 
                            'Width-Chars'+ CHR(1) + 
                            'Column'+ CHR(1) + 
                            'Row'+ CHR(1) + 
                            'DisplayField'+ CHR(1) + 
                            'EnableField'+ CHR(1) + 
                            'HideOnInit'+ CHR(1) + 
                            'DisableOnInit'+ CHR(1) + 
                            'ObjectLayout'+ CHR(1) + 
                            'FieldName'
        cAttributeValues = pcFileName + CHR(1) +            
                           cObjectTemplate + CHR(1) +       
                           coDisplayedField + CHR(1) +      
                           coKeyField + CHR(1) +            
                           fiFieldLabel + CHR(1) +          
                           fiFieldToolTip + CHR(1) +        
                           fiFieldFormat + CHR(1) +         
                           fiFieldDataType + CHR(1) +       
                           gcDisplayFormat + CHR(1) +       
                           gcDisplayDatatype + CHR(1) +     
                           EdQuery + CHR(1) +               
                           fiQueryTables + CHR(1) +         
                           gcBrowseFields + CHR(1) +        
                           gcColumnLabels + CHR(1) +        
                           gcColumnFormat + CHR(1) +        
                           gcBrowseFieldDataTypes + CHR(1) +
                           gcBrowseFieldFormats + CHR(1) +  
                           STRING(fiRowsToBatch) + CHR(1) + 
                           fiBrowseTitle + CHR(1) +         
                           gcViewerLinkedFields + CHR(1) +  
                           gcLinkedFieldDataTypes + CHR(1) +
                           gcLinkedFieldFormats + CHR(1) +  
                           gcViewerLinkedWidgets + CHR(1) + 
                           gcLLookupImage + CHR(1) +        
                           fiParentField + CHR(1) +         
                           edParentFilterQuery + CHR(1) +   
                           cMaintenanceObject + CHR(1) +    
                           cMaintenanceSDO + CHR(1) +       
                           "SmartDataField":U + CHR(1) +    
                           "adeicon/select.bmp":U + CHR(1) +
                           "1":U + CHR(1) +                 
                           STRING(fiFieldWidth) + CHR(1) +  
                           "1":U + CHR(1) +                 
                           "1":U + CHR(1) +                 
                           "TRUE":U + CHR(1) +              
                           "TRUE" + CHR(1) +                
                           "FALSE" + CHR(1) +               
                           "FALSE" + CHR(1) +               
                           cObjectLayout + CHR(1) +         
                           "":U
         cAttributeDataType = '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&INTEGER-DATA-TYPE}'   + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&DECIMAL-DATA-TYPE}'   + CHR(1) + 
                            '{&DECIMAL-DATA-TYPE}'   + CHR(1) + 
                            '{&DECIMAL-DATA-TYPE}'   + CHR(1) + 
                            '{&DECIMAL-DATA-TYPE}'   + CHR(1) + 
                            '{&LOGICAL-DATA-TYPE}'   + CHR(1) + 
                            '{&LOGICAL-DATA-TYPE}'   + CHR(1) + 
                            '{&LOGICAL-DATA-TYPE}'   + CHR(1) + 
                            '{&LOGICAL-DATA-TYPE}'   + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}' + CHR(1) + 
                            '{&CHARACTER-DATA-TYPE}'.
  
  RUN generateDynamicSDF IN ghRepositoryDesignManager ( INPUT  pcFileName,               /*pcObjectName              */
                                                        INPUT  fiObjectDescription,      /*pcObjectDescription       */
                                                        INPUT  cProductModule,           /*pcProductModuleCode       */
                                                        INPUT  "":U,                     /*pcResultCode              */
                                                        INPUT  TRUE,                     /*plDeleteExistingInstances */
                                                        INPUT  coObjType:SCREEN-VALUE,   /*pcSDFType                 */
                                                        INPUT  cSuperProcedure,          /*pcSuperProcedure          */
                                                        INPUT  cAttributeLabels,         /*pcAttributeLabels         */
                                                        INPUT  cAttributeValues,         /*pcAttributeValues         */
                                                        INPUT  cAttributeDataType,       /*pcAttributeDateType       */
                                                        OUTPUT dSDFObjectObj ) NO-ERROR. /*pdSDFObjectObj            */
  
  IF RETURN-VALUE <> "":U THEN
    ASSIGN cErrorText = RETURN-VALUE. 
  
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
  
  IF 1 = 2 THEN VIEW FRAME {&FRAME-NAME}. /* Lazy frame scoping */

  lOk = TRUE NO-ERROR.
  SESSION:SET-WAIT-STATE("GENERAL":U).
  IF LOOKUP(coObjType:SCREEN-VALUE, cLookupChildClasses) > 0 THEN
    RUN assignLookupValues.
  ELSE
    RUN assignComboValues.
  SESSION:SET-WAIT-STATE("":U).
  
  IF ERROR-STATUS:ERROR OR
     RETURN-VALUE <> "":U OR 
     NOT lOk THEN
    RETURN "VALIDATION-FAILED":U.
  SESSION:SET-WAIT-STATE("GENERAL":U).
  IF LOOKUP(coObjType:SCREEN-VALUE, cLookupChildClasses) > 0 THEN
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
  IF fiBrowseTitle:SCREEN-VALUE = "":U AND LOOKUP(coObjType:SCREEN-VALUE, cLookupChildClasses) > 0 THEN
  DO:
    MESSAGE "A Browse Title Must be Specified - cannot apply changes"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    ASSIGN plOK = NO.
    RETURN.
  END.
  IF NOT INTEGER(fiRowsToBatch:SCREEN-VALUE) > 0 AND LOOKUP(coObjType:SCREEN-VALUE, cLookupChildClasses) > 0 THEN
  DO:
    MESSAGE "Rows to Batch Must be Greater Than 0 - cannot apply changes"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    ASSIGN plOK = NO.
    RETURN.
  END.
  IF gcBrowseFields = "":U AND LOOKUP(coObjType:SCREEN-VALUE, cLookupChildClasses) > 0 THEN
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
  IF LOOKUP(coObjType:SCREEN-VALUE, cLookupChildClasses) > 0 THEN DO:
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
     LOOKUP(coObjType:SCREEN-VALUE, cLookupChildClasses) > 0 THEN DO:
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
     LOOKUP(coObjType:SCREEN-VALUE, cLookupChildClasses) > 0 THEN DO:
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
  
  IF gcDisplayedFields = "":U AND LOOKUP(coObjType:SCREEN-VALUE, cComboChildClasses) <> 0 THEN
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
     LOOKUP(coObjType:SCREEN-VALUE, cComboChildClasses) <> 0 THEN DO:
    MESSAGE "The number of fields to display does not match the field substitution entries." gcDisplayedFields
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    ASSIGN plOK = NO.
    RETURN.
  END.
  /* Check for valid data types in the default value */
  IF fiDefaultValue <> "":U AND 
     LOOKUP(coObjType:SCREEN-VALUE, cComboChildClasses) <> 0 THEN DO:
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
     LOOKUP(coObjType:SCREEN-VALUE, cComboChildClasses) <> 0 THEN DO:
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
     LOOKUP(coObjType:SCREEN-VALUE, cComboChildClasses) <> 0 THEN DO:
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fetchObjectDetail vTableWin 
FUNCTION fetchObjectDetail RETURNS LOGICAL
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hBufferCacheBuffer          AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hObjectTable                AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hClassTable                 AS HANDLE   EXTENT 26   NO-UNDO.
    DEFINE VARIABLE hPageTable                  AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hPageInstanceTable          AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hLinkTable                  AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hUiEventTable               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hCustomizationManager       AS HANDLE               NO-UNDO.
    DEFINE VARIABLE iAttributeExtent            AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cProperties                 AS CHARACTER            NO-UNDO.

    ASSIGN cProperties = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                          INPUT "currentUserObj,currentLanguageObj":U,
                                          INPUT YES).
    ASSIGN gdCurrentUserObj     = DECIMAL(ENTRY(1, cProperties, CHR(3))) NO-ERROR.
    ASSIGN gdCurrentLanguageObj = DECIMAL(ENTRY(2, cProperties, CHR(3))) NO-ERROR.

    ASSIGN hCustomizationManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "CustomizationManager":U).
    IF VALID-HANDLE(hCustomizationManager) THEN
        ASSIGN gcSessionResultCodes  = DYNAMIC-FUNCTION("getSessionResultCodes":U IN hCustomizationManager).
    ELSE
        ASSIGN gcSessionResultCodes  = "{&DEFAULT-RESULT-CODE}":U.
    
    RUN fetchObject IN gshRepositoryManager ( INPUT  gcLogicalObjectName,
                                              INPUT  gdCurrentUserObj,
                                              INPUT  gcSessionResultCodes,
                                              INPUT  "":U,
                                              INPUT  gdCurrentLanguageObj,
                                              INPUT  NO,        /* Get all contained records? */
                                              INPUT  NO,        /* design mode? */

                                              OUTPUT hBufferCacheBuffer,
                                              OUTPUT TABLE-HANDLE hObjectTable,
                                              OUTPUT TABLE-HANDLE hPageTable,
                                              OUTPUT TABLE-HANDLE hPageInstanceTable,
                                              OUTPUT TABLE-HANDLE hLinkTable,
                                              OUTPUT TABLE-HANDLE hUiEventTable,
                                              OUTPUT TABLE-HANDLE hClassTable[01], OUTPUT TABLE-HANDLE hClassTable[02],
                                              OUTPUT TABLE-HANDLE hClassTable[03], OUTPUT TABLE-HANDLE hClassTable[04],
                                              OUTPUT TABLE-HANDLE hClassTable[05], OUTPUT TABLE-HANDLE hClassTable[06],
                                              OUTPUT TABLE-HANDLE hClassTable[07], OUTPUT TABLE-HANDLE hClassTable[08],
                                              OUTPUT TABLE-HANDLE hClassTable[09], OUTPUT TABLE-HANDLE hClassTable[10],
                                              OUTPUT TABLE-HANDLE hClassTable[11], OUTPUT TABLE-HANDLE hClassTable[12],
                                              OUTPUT TABLE-HANDLE hClassTable[13], OUTPUT TABLE-HANDLE hClassTable[14],
                                              OUTPUT TABLE-HANDLE hClassTable[15], OUTPUT TABLE-HANDLE hClassTable[16],
                                              OUTPUT TABLE-HANDLE hClassTable[17], OUTPUT TABLE-HANDLE hClassTable[18],
                                              OUTPUT TABLE-HANDLE hClassTable[19], OUTPUT TABLE-HANDLE hClassTable[20],
                                              OUTPUT TABLE-HANDLE hClassTable[21], OUTPUT TABLE-HANDLE hClassTable[22],
                                              OUTPUT TABLE-HANDLE hClassTable[23], OUTPUT TABLE-HANDLE hClassTable[24],
                                              OUTPUT TABLE-HANDLE hClassTable[25], OUTPUT TABLE-HANDLE hClassTable[26]  ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN FALSE.

    IF NOT VALID-HANDLE(hBufferCacheBuffer) THEN
    DO:
        ASSIGN hBufferCacheBuffer = TEMP-TABLE cache_BufferCache:DEFAULT-BUFFER-HANDLE.

        /* Populate with class attribute tables.
         * The class attribute tables will be in a contiguous sequence. */
        DO iAttributeExtent = 1 TO EXTENT(hClassTable) WHILE VALID-HANDLE(hClassTable[iAttributeExtent]):
            DYNAMIC-FUNCTION("CreateBufferCacheRecord":U IN gshRepositoryManager, INPUT hClassTable[iAttributeExtent], INPUT YES, INPUT hBufferCacheBuffer).
        END.    /* loop through extents */

        DYNAMIC-FUNCTION("CreateBufferCacheRecord":U IN gshRepositoryManager, INPUT hObjectTable,       INPUT NO, INPUT hBufferCacheBuffer).
        DYNAMIC-FUNCTION("CreateBufferCacheRecord":U IN gshRepositoryManager, INPUT hPageTable,         INPUT NO, INPUT hBufferCacheBuffer).
        DYNAMIC-FUNCTION("CreateBufferCacheRecord":U IN gshRepositoryManager, INPUT hPageInstanceTable, INPUT NO, INPUT hBufferCacheBuffer).
        DYNAMIC-FUNCTION("CreateBufferCacheRecord":U IN gshRepositoryManager, INPUT hLinkTable,         INPUT NO, INPUT hBufferCacheBuffer).
        DYNAMIC-FUNCTION("CreateBufferCacheRecord":U IN gshRepositoryManager, INPUT hUiEventTable,      INPUT NO, INPUT hBufferCacheBuffer).            
    END.    /* not valid buffer cache. */        
    
    ASSIGN ghBufferCacheBuffer = hBufferCacheBuffer.

    RETURN TRUE.
END FUNCTION.   /* fetchObjectDetail */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBufferHandle vTableWin 
FUNCTION getBufferHandle RETURNS HANDLE
    ( INPUT pcBufferName                AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the buffer handle for a specified buffer from the buffer cache
            temp-table.
    Notes:  * fetchObjectDetail ensures that the buffer object cache temptable
              is always populated and that the ghBufferCacheBuffer handle is set.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hBuffer             AS HANDLE                       NO-UNDO.
    
    IF NOT VALID-HANDLE(ghBufferCacheBuffer) THEN
      RETURN ?.

    ghBufferCacheBuffer:FIND-FIRST(" WHERE ":U + ghBufferCacheBuffer:NAME + ".tBufferName = '":U + pcBufferName + "' ":U ) NO-ERROR.
    IF ghBufferCacheBuffer:AVAILABLE THEN
        ASSIGN hBuffer = ghBufferCacheBuffer:BUFFER-FIELD("tBufferHandle":U):BUFFER-VALUE.

    RETURN hBuffer.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAttrValues vTableWin 
FUNCTION setAttrValues RETURNS LOGICAL
  ( pcAttrLabel AS CHARACTER,
    pcAttrValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Set the values of the screen variables from the attribute values
    Notes:  
------------------------------------------------------------------------------*/
  CASE pcAttrLabel:
    WHEN "DisplayedField" THEN
      gcLDisplayedField = pcAttrValue.
    WHEN "KeyField" THEN
      gcLKeyField = pcAttrValue.
    WHEN "FieldLabel" THEN
      gcLFieldLabel = pcAttrValue.
    WHEN "FieldTooltip" THEN
      gcLFieldTooltip = pcAttrValue.
    WHEN "KeyFormat" THEN
      gcLKeyFormat = pcAttrValue.
    WHEN "KeyDataType" THEN
      gcLKeyDataType = pcAttrValue.
    WHEN "DisplayFormat" THEN
      gcLDisplayFormat = pcAttrValue.
    WHEN "DisplayDataType" THEN
      gcLDisplayDataType = pcAttrValue.
    WHEN "BaseQueryString" THEN
      gcLBaseQueryString = pcAttrValue.
    WHEN "QueryTables" THEN
      gcLQueryTables = pcAttrValue.
    WHEN "ParentField" THEN
      gcLParentField = pcAttrValue.
    WHEN "ParentFilterQuery" THEN
      gcLParentFilterQuery = pcAttrValue.
    /** Combo Specific Fields **/
    WHEN "DescSubstitute" THEN
      gcLDescSubstitute = pcAttrValue.
    WHEN "ComboFlag" THEN
      gcLComboFlag = pcAttrValue.
    WHEN "FlagValue" THEN
      gcLFlagValue = pcAttrValue.
    WHEN "InnerLines" THEN
      giLInnerLines = INTEGER(pcAttrValue).
    WHEN "BuildSequence" THEN
      giLBuildSeq = INTEGER(pcAttrValue).
    /** Lookup Specific Fields **/
    WHEN "BrowseFields" THEN
      gcLBrowseFields = pcAttrValue.
    WHEN "ColumnLabels" THEN
      gcLColumnLabels = pcAttrValue.
    WHEN "ColumnFormat" THEN
      gcLCoulmnFormat = pcAttrValue.
    WHEN "BrowseFieldDataTypes" THEN
      gcLBrowseFieldDataTypes = pcAttrValue.
    WHEN "BrowseFieldFormats" THEN
      gcLBrowseFieldFormats = pcAttrValue.
    WHEN "RowsToBatch" THEN
      giLRowsToBatch = INTEGER(pcAttrValue).
    WHEN "BrowseTitle" THEN
      gcLBrowseTitle = pcAttrValue.
    WHEN "ViewerLinkedFields" THEN
      gcLViewerLinkedFields = pcAttrValue.
    WHEN "LinkedFieldDataTypes" THEN
      gcLLinkedFieldDataTypes = pcAttrValue.
    WHEN "LinkedFieldFormats" THEN
      gcLLinkedFieldFormats = pcAttrValue.
    WHEN "ViewerLinkedWidgets" THEN
      gcLViewerLinkedWidgets = pcAttrValue.
    WHEN "LookupImage" THEN
      gcLLookupImage = pcAttrValue.
    WHEN "ParentField" THEN
      gcLParentField = pcAttrValue.
    WHEN "ParentFilterQuery" THEN
      gcLParentFilterQuery = pcAttrValue.
    WHEN "MaintenanceObject" THEN
      gcLMaintenanceObject = pcAttrValue.
    WHEN "MaintenanceSDO" THEN
      gcLMaintenanceSDO = pcAttrValue.
    WHEN "WIDTH-CHARS" THEN
      gdLFieldWidth = DECIMAL(pcAttrValue).
  END CASE.

  RETURN TRUE.   /* Function return value. */

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

