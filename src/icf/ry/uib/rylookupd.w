&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          sports2000       PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME frmAttributes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS frmAttributes 
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
/*------------------------------------------------------------------------

  File: lookupd.w 

  Description: Instance Attributes Dialog for Astra2 Dynamic Lookups.

  Input Parameters:
     p_hSMO -- Procedure Handle of calling SmartObject.

  Output Parameters:
      <none>


     Modifed:  08/28/2001       Mark Davies (MIP)
               The Dynamic Lookup and Combo's Base Query String editor 
               concatenates the whole query string and thus causes the 
               string to be invalid. Make sure that when enter was pressed 
               that spaces are left in its place.
    Modified: 09/25/2001         Mark Davies (MIP)
              1. Allow detaching of lookup from template if properties
                 were changed.
              2. Remove references to KeyFieldValue and SavedScreenValue
              3. Reposition Product and Product module combos to template
                 lookup or lookup smartobject.
              4. Grey-out object description when disabled.
              5. Default tooltip to 'Press F4 For Lookup' if left empty.

    Modified: 10/01/2001        Mark Davies (MIP)
              Resized the dialog to fit in 800x600
    Modified: 10/22/2001        Mark Davies (MIP)
              The displayed field data type and format and the key field
              data type and format attribute values were incorrectly
              written to the database.
    Modified: 01/16/2002        Mark Davies (MIP)
              Fixed issue #3683 - Data is lost have it has been saved when 
              dismissing a window
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_hSMO                   AS HANDLE     NO-UNDO.

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

DEFINE VARIABLE gcDisplayFormat         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDisplayDataType       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glChanges               AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cRowPreVal              AS CHARACTER  NO-UNDO EXTENT 5.

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

{src/adm2/ttcombo.i}
{src/adm2/globals.i}
{checkerr.i &define-only = YES}
{adeuib/uibhlp.i}          /* Help File Preprocessor Directives         */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frmAttributes
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
&Scoped-define OPEN-QUERY-BrBrowse OPEN QUERY {&SELF-NAME} FOR EACH ttFields BY ttFields.cFieldName INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrBrowse ttFields
&Scoped-define FIRST-TABLE-IN-QUERY-BrBrowse ttFields


/* Definitions for DIALOG-BOX frmAttributes                             */
&Scoped-define OPEN-BROWSERS-IN-QUERY-frmAttributes ~
    ~{&OPEN-QUERY-BrBrowse}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buClear fiLookupTemplate buLookup ~
fiRowsToBatch EdQuery buQuery BrBrowse coKeyField coDisplayedField fiWidth ~
fiColumn fiFieldLabel fiHeight fiRow fiParentField EdParentFilterQuery ~
fiFieldToolTip fiBrowseTitle fiMaintenanceSDO buLookupSDO ~
fiMaintenanceObject buLookupObject buOK buCancel edHelp 
&Scoped-Define DISPLAYED-OBJECTS coProduct coProductModule fiLookupTemplate ~
fiLookupName edObjectDescription fiRowsToBatch EdQuery fiQueryTables ~
coKeyField coDisplayedField fiWidth fiColumn fiFieldLabel fiHeight ~
fiExternalField fiRow fiParentField fiFieldDatatype EdParentFilterQuery ~
fiFieldToolTip fiBrowseTitle fiMaintenanceSDO fiMaintenanceObject edHelp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFuncLibHandle frmAttributes 
FUNCTION getFuncLibHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD numOccurance frmAttributes 
FUNCTION numOccurance RETURNS INTEGER
  ( INPUT pcString    AS CHARACTER,
    INPUT pcCharacter AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setForeignFieldHelp frmAttributes 
FUNCTION setForeignFieldHelp RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON buApply 
     LABEL "A&pply" 
     SIZE 15 BY 1.14 TOOLTIP "Apply template properties."
     BGCOLOR 8 .

DEFINE BUTTON buCancel DEFAULT 
     LABEL "&Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buCancelSave 
     LABEL "C&ancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buClear 
     LABEL "C&lear Settings" 
     SIZE 15 BY 1.14 TOOLTIP "Clear all the current settings for this lookup."
     BGCOLOR 8 .

DEFINE BUTTON buLookup 
     LABEL "" 
     SIZE 5 BY 1 TOOLTIP "Lookup template lookup."
     BGCOLOR 8 .

DEFINE BUTTON buLookupObject 
     LABEL "" 
     SIZE 5 BY 1 TOOLTIP "Find logical object to be launched for maintaining maintenance on this lookup."
     BGCOLOR 8 .

DEFINE BUTTON buLookupSDO 
     LABEL "" 
     SIZE 5 BY 1 TOOLTIP "Find and SDO to be launched."
     BGCOLOR 8 .

DEFINE BUTTON buOK AUTO-GO DEFAULT 
     LABEL "&OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buQuery 
     LABEL "&Refresh" 
     SIZE 15 BY 1.14 TOOLTIP "Validate Query and initialize query related prompts"
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

DEFINE VARIABLE coProduct AS CHARACTER FORMAT "X(256)":U 
     LABEL "Product" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "x","x"
     DROP-DOWN-LIST
     SIZE 48.4 BY 1 NO-UNDO.

DEFINE VARIABLE coProductModule AS CHARACTER FORMAT "X(256)":U 
     LABEL "Product Module" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "x","x"
     DROP-DOWN-LIST
     SIZE 48.4 BY 1 NO-UNDO.

DEFINE VARIABLE edHelp AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 39.2 BY 5.62 NO-UNDO.

DEFINE VARIABLE EdParentFilterQuery AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 70.4 BY 1.71 TOOLTIP "Parent filter query addition." NO-UNDO.

DEFINE VARIABLE EdQuery AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 10000 SCROLLBAR-VERTICAL LARGE
     SIZE 112.8 BY 1.71 NO-UNDO.

DEFINE VARIABLE edObjectDescription AS CHARACTER FORMAT "X(70)":U 
     LABEL "Object Description" 
     VIEW-AS FILL-IN 
     SIZE 63.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiBrowseTitle AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Browse Title" 
     VIEW-AS FILL-IN 
     SIZE 70.4 BY 1 TOOLTIP "Title for lookup window" NO-UNDO.

DEFINE VARIABLE fiColumn AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "&Column" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 TOOLTIP "Column for displayed field" NO-UNDO.

DEFINE VARIABLE fiExternalField AS CHARACTER FORMAT "X(256)":U 
     LABEL "External Field" 
     VIEW-AS FILL-IN 
     SIZE 46 BY 1 TOOLTIP "Field to be updated with value of key field" NO-UNDO.

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

DEFINE VARIABLE fiHeight AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "&Height" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 TOOLTIP "height of displayed field" NO-UNDO.

DEFINE VARIABLE fiLookupName AS CHARACTER FORMAT "X(35)":U 
     LABEL "Lookup Name" 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 NO-UNDO.

DEFINE VARIABLE fiLookupTemplate AS CHARACTER FORMAT "X(35)":U 
     LABEL "Use Template" 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 TOOLTIP "The template lookup to base this lookup on." NO-UNDO.

DEFINE VARIABLE fiMaintenanceObject AS CHARACTER FORMAT "X(35)":U 
     LABEL "Maintenance Object" 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 TOOLTIP "Enter the static/logical object name to be launched for maintaining lookup data" NO-UNDO.

DEFINE VARIABLE fiMaintenanceSDO AS CHARACTER FORMAT "X(35)":U 
     LABEL "Maintenance SDO" 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 TOOLTIP "The name of the SDO to be launched when maintenance is allowed." NO-UNDO.

DEFINE VARIABLE fiParentField AS CHARACTER FORMAT "X(70)":U 
     LABEL "Parent Fields" 
     VIEW-AS FILL-IN 
     SIZE 70.4 BY 1 TOOLTIP "The Field Name(s) for the parent field(s) that this lookup is dependant on." NO-UNDO.

DEFINE VARIABLE fiQueryTables AS CHARACTER FORMAT "X(256)":U 
     LABEL "Query Tables" 
     VIEW-AS FILL-IN 
     SIZE 115 BY 1 TOOLTIP "Comma delimited list of tables in above query" NO-UNDO.

DEFINE VARIABLE fiRow AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "&Row" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 TOOLTIP "Row for displayed field" NO-UNDO.

DEFINE VARIABLE fiRowsToBatch AS INTEGER FORMAT ">>>>>9":U INITIAL 200 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1 TOOLTIP "Specify rows to batch for lookup data" NO-UNDO.

DEFINE VARIABLE fiWidth AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "&Width" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 TOOLTIP "Width of displayed field" NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrBrowse FOR 
      ttFields SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrBrowse frmAttributes _FREEFORM
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
    WITH NO-ROW-MARKERS SEPARATORS SIZE 128.8 BY 5.1 ROW-HEIGHT-CHARS .62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frmAttributes
     coProduct AT ROW 1 COL 19.4 COLON-ALIGNED
     buClear AT ROW 1.1 COL 116.8
     coProductModule AT ROW 2.05 COL 19.4 COLON-ALIGNED
     buApply AT ROW 3.05 COL 75
     fiLookupTemplate AT ROW 3.14 COL 19.4 COLON-ALIGNED
     buLookup AT ROW 3.14 COL 69.6
     fiLookupName AT ROW 4.24 COL 19.4 COLON-ALIGNED
     edObjectDescription AT ROW 5.29 COL 19.4 COLON-ALIGNED
     buSave AT ROW 5.19 COL 85.4
     buCancelSave AT ROW 5.19 COL 101
     fiRowsToBatch AT ROW 6.48 COL 114.6 COLON-ALIGNED NO-LABEL
     EdQuery AT ROW 7.1 COL 3.4 NO-LABEL
     buQuery AT ROW 7.57 COL 117
     fiQueryTables AT ROW 8.91 COL 15.2 COLON-ALIGNED
     BrBrowse AT ROW 9.95 COL 3.4
     coKeyField AT ROW 16.24 COL 19.4 COLON-ALIGNED
     fiFieldFormat AT ROW 16.24 COL 99.8 COLON-ALIGNED
     coDisplayedField AT ROW 17.43 COL 19.4 COLON-ALIGNED
     fiWidth AT ROW 17.43 COL 99.8 COLON-ALIGNED
     fiColumn AT ROW 17.43 COL 120.2 COLON-ALIGNED
     fiFieldLabel AT ROW 18.57 COL 19.4 COLON-ALIGNED
     fiHeight AT ROW 18.57 COL 99.8 COLON-ALIGNED
     fiExternalField AT ROW 15.1 COL 7.6 NO-TAB-STOP 
     fiRow AT ROW 18.57 COL 120.2 COLON-ALIGNED
     fiParentField AT ROW 19.67 COL 19.4 COLON-ALIGNED
     fiFieldDatatype AT ROW 15.1 COL 99.8 COLON-ALIGNED NO-TAB-STOP 
     EdParentFilterQuery AT ROW 20.81 COL 21.4 NO-LABEL
     fiFieldToolTip AT ROW 22.62 COL 19.4 COLON-ALIGNED
     fiBrowseTitle AT ROW 23.76 COL 19.4 COLON-ALIGNED
     fiMaintenanceSDO AT ROW 24.81 COL 19.4 COLON-ALIGNED
     buLookupSDO AT ROW 24.81 COL 69.8
     fiMaintenanceObject AT ROW 25.86 COL 19.4 COLON-ALIGNED
     buLookupObject AT ROW 25.91 COL 69.8
     buOK AT ROW 25.67 COL 99.8
     buCancel AT ROW 25.67 COL 117.2
     edHelp AT ROW 19.67 COL 93 NO-LABEL NO-TAB-STOP 
     "Rows to Batch:" VIEW-AS TEXT
          SIZE 15.6 BY .62 AT ROW 5.81 COL 116.6
     "Specify Base Query String (FOR EACH):" VIEW-AS TEXT
          SIZE 112.4 BY .62 AT ROW 6.43 COL 3.4
     "Parent Filter Query:" VIEW-AS TEXT
          SIZE 18.4 BY .62 AT ROW 20.81 COL 2.6
     SPACE(111.20) SKIP(5.48)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Dynamic Lookup Properties":L
         DEFAULT-BUTTON buOK.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX frmAttributes
   Custom                                                               */
/* BROWSE-TAB BrBrowse fiQueryTables frmAttributes */
ASSIGN 
       FRAME frmAttributes:SCROLLABLE       = FALSE
       FRAME frmAttributes:HIDDEN           = TRUE.

ASSIGN 
       BrBrowse:ALLOW-COLUMN-SEARCHING IN FRAME frmAttributes = TRUE
       BrBrowse:COLUMN-RESIZABLE IN FRAME frmAttributes       = TRUE.

/* SETTINGS FOR BUTTON buApply IN FRAME frmAttributes
   NO-ENABLE                                                            */
ASSIGN 
       buApply:HIDDEN IN FRAME frmAttributes           = TRUE.

/* SETTINGS FOR BUTTON buCancelSave IN FRAME frmAttributes
   NO-ENABLE                                                            */
ASSIGN 
       buCancelSave:HIDDEN IN FRAME frmAttributes           = TRUE.

/* SETTINGS FOR BUTTON buSave IN FRAME frmAttributes
   NO-ENABLE                                                            */
ASSIGN 
       buSave:HIDDEN IN FRAME frmAttributes           = TRUE.

/* SETTINGS FOR COMBO-BOX coProduct IN FRAME frmAttributes
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX coProductModule IN FRAME frmAttributes
   NO-ENABLE                                                            */
ASSIGN 
       edHelp:RETURN-INSERTED IN FRAME frmAttributes  = TRUE
       edHelp:READ-ONLY IN FRAME frmAttributes        = TRUE.

/* SETTINGS FOR FILL-IN edObjectDescription IN FRAME frmAttributes
   NO-ENABLE                                                            */
ASSIGN 
       EdParentFilterQuery:RETURN-INSERTED IN FRAME frmAttributes  = TRUE.

ASSIGN 
       EdQuery:RETURN-INSERTED IN FRAME frmAttributes  = TRUE.

/* SETTINGS FOR FILL-IN fiExternalField IN FRAME frmAttributes
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       fiExternalField:READ-ONLY IN FRAME frmAttributes        = TRUE.

/* SETTINGS FOR FILL-IN fiFieldDatatype IN FRAME frmAttributes
   NO-ENABLE                                                            */
ASSIGN 
       fiFieldDatatype:READ-ONLY IN FRAME frmAttributes        = TRUE.

/* SETTINGS FOR FILL-IN fiFieldFormat IN FRAME frmAttributes
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fiLookupName IN FRAME frmAttributes
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiQueryTables IN FRAME frmAttributes
   NO-ENABLE                                                            */
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

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX frmAttributes
/* Query rebuild information for DIALOG-BOX frmAttributes
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX frmAttributes */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME frmAttributes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frmAttributes frmAttributes
ON GO OF FRAME frmAttributes /* Dynamic Lookup Properties */
DO:     
  DEFINE VARIABLE hFrame                              AS HANDLE     NO-UNDO.

  IF NOT VALID-HANDLE(p_hSMO) THEN RETURN.

  DYNAMIC-FUNCTION('setDisplayedField':U IN p_hSMO, coDisplayedField). 
  DYNAMIC-FUNCTION('setKeyField':U IN p_hSMO, coKeyField). 
  DYNAMIC-FUNCTION('setFieldLabel':U IN p_hSMO, fiFieldLabel). 
  DYNAMIC-FUNCTION('setFieldTooltip':U IN p_hSMO, fiFieldToolTip). 
  DYNAMIC-FUNCTION('setKeyFormat':U IN p_hSMO, fiFieldFormat). 
  DYNAMIC-FUNCTION('setKeyDataType':U IN p_hSMO, fiFieldDatatype). 
  DYNAMIC-FUNCTION('setDisplayFormat':U IN p_hSMO, gcDisplayFormat). 
  DYNAMIC-FUNCTION('setDisplayDataType':U IN p_hSMO, gcDisplayDataType). 
  DYNAMIC-FUNCTION('setBrowseFields':U IN p_hSMO, gcBrowseFields). 
  DYNAMIC-FUNCTION('setBrowseFieldDataTypes':U IN p_hSMO, gcBrowseFieldDataTypes). 
  DYNAMIC-FUNCTION('setBrowseFieldFormats':U IN p_hSMO, gcBrowseFieldFormats). 
  DYNAMIC-FUNCTION('setRowsToBatch':U IN p_hSMO, fiRowsToBatch). 
  DYNAMIC-FUNCTION('setBrowseTitle':U IN p_hSMO, fiBrowseTitle). 
  DYNAMIC-FUNCTION('setViewerLinkedFields':U IN p_hSMO, gcViewerLinkedFields). 
  DYNAMIC-FUNCTION('setViewerLinkedWidgets':U IN p_hSMO, gcViewerLinkedWidgets). 
  DYNAMIC-FUNCTION('setLinkedFieldDataTypes':U IN p_hSMO, gcLinkedFieldDataTypes). 
  DYNAMIC-FUNCTION('setLinkedFieldFormats':U IN p_hSMO, gcLinkedFieldFormats). 
  DYNAMIC-FUNCTION('setBaseQueryString':U IN p_hSMO, gcBaseQuery). 
  DYNAMIC-FUNCTION('setQueryTables':U IN p_hSMO, fiQueryTables). 
  DYNAMIC-FUNCTION('setColumnLabels':U IN p_hSMO, gcColumnLabels).
  DYNAMIC-FUNCTION('setColumnFormat':U IN p_hSMO, gcColumnFormat).
  DYNAMIC-FUNCTION('setSDFFileName':U IN p_hSMO, fiLookupName).
  DYNAMIC-FUNCTION('setSDFTemplate':U IN p_hSMO, fiLookupTemplate).
  DYNAMIC-FUNCTION('setParentField':U IN p_hSMO, fiParentField).
  DYNAMIC-FUNCTION('setParentFilterQuery':U IN p_hSMO, edParentFilterQuery).
  DYNAMIC-FUNCTION('setMaintenanceObject':U IN p_hSMO, fiMaintenanceObject).
  DYNAMIC-FUNCTION('setMaintenanceSDO':U IN p_hSMO, fiMaintenanceSDO).
  
  RUN repositionObject IN p_hSMO (INPUT fiRow, INPUT fiColumn).

  ASSIGN
    hFrame        = DYNAMIC-FUNCTION("getContainerHandle" IN p_hSMO)
    hFrame:HEIGHT = fiHeight
    hFrame:WIDTH  = fiWidth NO-ERROR.

  /* Notify AppBuilder that size or position values has changed.
     The AB will run resizeObject which will run initializeObject */
  APPLY "END-RESIZE" TO hFrame.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frmAttributes frmAttributes
ON HELP OF FRAME frmAttributes /* Dynamic Lookup Properties */
OR HELP OF FRAME {&FRAME-NAME}
DO: 
  /* Help for this Frame */
  RUN adecomm/_adehelp.p
                ("ICAB":U, "CONTEXT":U, {&Dynamic_Lookup_Instance_Properties_Dialog_Box}  , "":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frmAttributes frmAttributes
ON WINDOW-CLOSE OF FRAME frmAttributes /* Dynamic Lookup Properties */
DO:
  DEFINE VARIABLE lExit AS LOGICAL    NO-UNDO.
  
  lExit = TRUE.
  IF glChanges THEN 
    MESSAGE "Your changes were not saved. Are you sure you want to exit without saving the current settings?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE lExit.
  IF NOT lExit OR lExit = ? THEN
    RETURN NO-APPLY.

  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrBrowse
&Scoped-define SELF-NAME BrBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BrBrowse frmAttributes
ON ROW-ENTRY OF BrBrowse IN FRAME frmAttributes
DO:
  ASSIGN cRowPreVal[1] = ttFields.iBrowseFieldSeq:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
         cRowPreVal[2] = ttFields.lLinkedField:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
         cRowPreVal[3] = ttFields.cLinkedWidget:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
         cRowPreVal[4] = ttFields.cColumnLabels:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
         cRowPreVal[5] = ttFields.cColumnFormat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} .

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BrBrowse frmAttributes
ON ROW-LEAVE OF BrBrowse IN FRAME frmAttributes
DO:
  IF cRowPreVal[1] <> ttFields.iBrowseFieldSeq:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} OR
     cRowPreVal[2] <> ttFields.lLinkedField:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} OR
     cRowPreVal[3] <> ttFields.cLinkedWidget:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} OR
     cRowPreVal[4] <> ttFields.cColumnLabels:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} OR
     cRowPreVal[5] <> ttFields.cColumnFormat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} THEN
    glChanges = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BrBrowse frmAttributes
ON START-SEARCH OF BrBrowse IN FRAME frmAttributes
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


&Scoped-define SELF-NAME buApply
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buApply frmAttributes
ON CHOOSE OF buApply IN FRAME frmAttributes /* Apply */
DO:
  SESSION:SET-WAIT-STATE("GENERAL":U).
  RUN applySOValues (INPUT fiLookupTemplate).
  SESSION:SET-WAIT-STATE("":U).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCancel frmAttributes
ON CHOOSE OF buCancel IN FRAME frmAttributes /* Cancel */
DO:
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR */
  APPLY "WINDOW-CLOSE":U TO FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCancelSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCancelSave frmAttributes
ON CHOOSE OF buCancelSave IN FRAME frmAttributes /* Cancel */
DO:
  ENABLE ALL WITH FRAME {&FRAME-NAME}.
  DISABLE coProduct
          coProductModule 
          fiLookupName
          edObjectDescription
          buSave buCancelSave
          WITH FRAME {&FRAME-NAME}.
  ASSIGN buSave:HIDDEN       = TRUE
         buCancelSave:HIDDEN = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buClear
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buClear frmAttributes
ON CHOOSE OF buClear IN FRAME frmAttributes /* Clear Settings */
DO:
  ASSIGN fiLookupTemplate      = "":U
         fiLookupName          = "":U
         edObjectDescription   = "":U
         edQuery               = "":U
         fiFieldLabel          = "":U
         fiParentField         = "":U
         edParentFilterQuery   = "":U
         fiFieldTooltip        = "":U
         fiBrowseTitle         = "":U
         fiMaintenanceObject   = "":U
         fiMaintenanceSDO      = "":U.
  DISPLAY fiLookupTemplate
          fiLookupName
          edObjectDescription
          edQuery
          fiFieldLabel
          fiParentField
          edParentFilterQuery
          fiFieldTooltip
          fiBrowseTitle
          fiMaintenanceObject
          fiMaintenanceSDO
          WITH FRAME {&FRAME-NAME}.
  APPLY "LEAVE":U TO fiLookupTemplate IN FRAME {&FRAME-NAME}.
  APPLY "CHOOSE":U TO buQuery IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buLookup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buLookup frmAttributes
ON CHOOSE OF buLookup IN FRAME frmAttributes
DO: 
  ASSIGN coProduct
         coProductModule.
  RUN ry/uib/rylookupbd.w (INPUT coProduct,
                           INPUT coProductModule,
                           INPUT "DynLookup":U,
                           INPUT FALSE,
                           OUTPUT fiLookupTemplate).
  DISPLAY fiLookupTemplate WITH FRAME {&FRAME-NAME}.
  APPLY "LEAVE":U TO fiLookupTemplate IN FRAME {&FRAME-NAME}.
  APPLY "ENTRY":U TO buApply IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buLookupObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buLookupObject frmAttributes
ON CHOOSE OF buLookupObject IN FRAME frmAttributes
DO: 
  ASSIGN coProduct
         coProductModule.
  RUN ry/uib/rylookupbd.w (INPUT coProduct,
                           INPUT coProductModule,
                           INPUT "DynFold":U,
                           INPUT TRUE,
                           OUTPUT fiMaintenanceObject).
  DISPLAY fiMaintenanceObject WITH FRAME {&FRAME-NAME}.
  APPLY "LEAVE":U TO fiMaintenanceObject IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buLookupSDO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buLookupSDO frmAttributes
ON CHOOSE OF buLookupSDO IN FRAME frmAttributes
DO: 
  ASSIGN coProduct
         coProductModule.
  RUN ry/uib/rylookupbd.w (INPUT coProduct,
                           INPUT coProductModule,
                           INPUT "SDO":U,
                           INPUT TRUE,
                           OUTPUT fiMaintenanceSDO).
  DISPLAY fiMaintenanceSDO WITH FRAME {&FRAME-NAME}.
  APPLY "LEAVE":U TO fiMaintenanceSDO IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOK frmAttributes
ON CHOOSE OF buOK IN FRAME frmAttributes /* OK */
DO:
  IF fiFieldTooltip:SCREEN-VALUE = "":U THEN
    fiFieldTooltip:SCREEN-VALUE = "Press F4 For Lookup":U.
  RUN assignValues.
  IF RETURN-VALUE = "ERROR":U THEN
    RETURN NO-APPLY.
  glChanges = FALSE.

  RUN checkSaved.
  IF RETURN-VALUE = "NO-EXIT":U THEN
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buQuery
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buQuery frmAttributes
ON CHOOSE OF buQuery IN FRAME frmAttributes /* Refresh */
DO:

  DEFINE VARIABLE cQuery                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBufferList                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValueList                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQueryValid                 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cValuePairs                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cField                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iBrowseEntry                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLinkedEntry                AS INTEGER    NO-UNDO.

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

    IF fiFieldTooltip = "":U THEN
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

    coDisplayedField:SCREEN-VALUE = fiExternalField:SCREEN-VALUE NO-ERROR.
    coKeyField:SCREEN-VALUE = fiExternalField:SCREEN-VALUE NO-ERROR. 

    coDisplayedField:SCREEN-VALUE = DYNAMIC-FUNCTION('getDisplayedField':U IN p_hSMO) NO-ERROR.
    coKeyField:SCREEN-VALUE = DYNAMIC-FUNCTION('getKeyField':U IN p_hSMO) NO-ERROR. 

    DISPLAY
      BrBrowse.

    /* populate other fields */
    APPLY "value-changed" TO coKeyField.  
    APPLY "value-changed" TO coDisplayedField.  
  END.
  glChanges = TRUE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSave frmAttributes
ON CHOOSE OF buSave IN FRAME frmAttributes /* Save */
DO:
  DEFINE VARIABLE cButton AS CHARACTER  NO-UNDO.
  
  ASSIGN fiLookupName
         edObjectDescription.
  IF fiLookupName = "":U THEN DO:
    RUN showMessages IN gshSessionManager (INPUT  "You must enter a Lookup Name.",    /* message to display */
                                           INPUT  "ERR":U,          /* error type */
                                           INPUT  "&OK,&Cancel":U,    /* button list */
                                           INPUT  "&OK":U,           /* default button */ 
                                           INPUT  "&Cancel":U,       /* cancel button */
                                           INPUT  "Lookup Name Mandetory":U,             /* error window title */
                                           INPUT  YES,              /* display if empty */ 
                                           INPUT  ?,                /* container handle */ 
                                           OUTPUT cButton           /* button pressed */
                                          ).
    APPLY "ENTRY":U TO fiLookupName.
    RETURN NO-APPLY.
  END.
  
  IF edObjectDescription = "":U THEN DO:
    RUN showMessages IN gshSessionManager (INPUT  "You must enter a Description for this new object.",    /* message to display */
                                           INPUT  "ERR":U,          /* error type */
                                           INPUT  "&OK,&Cancel":U,    /* button list */
                                           INPUT  "&OK":U,           /* default button */ 
                                           INPUT  "&Cancel":U,       /* cancel button */
                                           INPUT  "Lookup Description Mandetory":U,             /* error window title */
                                           INPUT  YES,              /* display if empty */ 
                                           INPUT  ?,                /* container handle */ 
                                           OUTPUT cButton           /* button pressed */
                                          ).
    APPLY "ENTRY":U TO edObjectDescription.
    RETURN NO-APPLY.
  END.
  
  /* First check if it already exists */
  IF CAN-FIND(FIRST ryc_smartobject
              WHERE ryc_smartobject.object_filename = fiLookupName NO-LOCK) THEN DO:
    RUN showMessages IN gshSessionManager (INPUT  "A SmartObject alreay exists with this name.",    /* message to display */
                                           INPUT  "ERR":U,          /* error type */
                                           INPUT  "&OK,&Cancel":U,    /* button list */
                                           INPUT  "&OK":U,           /* default button */ 
                                           INPUT  "&Cancel":U,       /* cancel button */
                                           INPUT  "Name not unque":U,             /* error window title */
                                           INPUT  YES,              /* display if empty */ 
                                           INPUT  ?,                /* container handle */ 
                                           OUTPUT cButton           /* button pressed */
                                          ).
    APPLY "ENTRY":U TO fiLookupName.
    RETURN NO-APPLY.
  END.
              
  SESSION:SET-WAIT-STATE("GENERAL":U).
  RUN setSmartObjectDetails (INPUT fiLookupName).
  SESSION:SET-WAIT-STATE("":U).
  
  ENABLE ALL WITH FRAME {&FRAME-NAME}.
  DISABLE coProduct
          coProductModule 
          fiLookupName
          edObjectDescription
          buSave buCancelSave
          WITH FRAME {&FRAME-NAME}.
  ASSIGN buSave:HIDDEN       = TRUE
         buCancelSave:HIDDEN = TRUE.
  APPLY "CHOOSE":U TO buOK IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coDisplayedField
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coDisplayedField frmAttributes
ON ENTRY OF coDisplayedField IN FRAME frmAttributes /* Displayed Field */
DO:
  ASSIGN gcSaveDisplayField = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coDisplayedField frmAttributes
ON VALUE-CHANGED OF coDisplayedField IN FRAME frmAttributes /* Displayed Field */
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
  glChanges = TRUE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coKeyField
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coKeyField frmAttributes
ON VALUE-CHANGED OF coKeyField IN FRAME frmAttributes /* Key Field */
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
  glChanges = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coProduct
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coProduct frmAttributes
ON VALUE-CHANGED OF coProduct IN FRAME frmAttributes /* Product */
DO:
  RUN buildCombos (coProductModule:HANDLE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME EdParentFilterQuery
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL EdParentFilterQuery frmAttributes
ON VALUE-CHANGED OF EdParentFilterQuery IN FRAME frmAttributes
DO:
  glChanges = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME EdQuery
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL EdQuery frmAttributes
ON VALUE-CHANGED OF EdQuery IN FRAME frmAttributes
DO:
  glChanges = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiBrowseTitle
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiBrowseTitle frmAttributes
ON VALUE-CHANGED OF fiBrowseTitle IN FRAME frmAttributes /* Browse Title */
DO:
  glChanges = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiColumn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiColumn frmAttributes
ON VALUE-CHANGED OF fiColumn IN FRAME frmAttributes /* Column */
DO:
  glChanges = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiFieldLabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFieldLabel frmAttributes
ON VALUE-CHANGED OF fiFieldLabel IN FRAME frmAttributes /* Field Label */
DO:
  glChanges = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiFieldToolTip
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFieldToolTip frmAttributes
ON VALUE-CHANGED OF fiFieldToolTip IN FRAME frmAttributes /* Tooltip */
DO:
  glChanges = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiHeight
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiHeight frmAttributes
ON VALUE-CHANGED OF fiHeight IN FRAME frmAttributes /* Height */
DO:
  glChanges = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiLookupTemplate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiLookupTemplate frmAttributes
ON LEAVE OF fiLookupTemplate IN FRAME frmAttributes /* Use Template */
DO:
  ASSIGN fiLookupTemplate.
  IF fiLookupTemplate <> "":U THEN DO:
    ENABLE buApply WITH FRAME {&FRAME-NAME}.
    APPLY "ENTRY":U TO buApply IN FRAME {&FRAME-NAME}.
  END.
  ELSE
    buApply:HIDDEN = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiMaintenanceObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiMaintenanceObject frmAttributes
ON VALUE-CHANGED OF fiMaintenanceObject IN FRAME frmAttributes /* Maintenance Object */
DO:
  glChanges = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiMaintenanceSDO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiMaintenanceSDO frmAttributes
ON VALUE-CHANGED OF fiMaintenanceSDO IN FRAME frmAttributes /* Maintenance SDO */
DO:
  glChanges = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiParentField
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiParentField frmAttributes
ON VALUE-CHANGED OF fiParentField IN FRAME frmAttributes /* Parent Fields */
DO:
  glChanges = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiRow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiRow frmAttributes
ON VALUE-CHANGED OF fiRow IN FRAME frmAttributes /* Row */
DO:
  glChanges = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiRowsToBatch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiRowsToBatch frmAttributes
ON VALUE-CHANGED OF fiRowsToBatch IN FRAME frmAttributes
DO:
  glChanges = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiWidth
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiWidth frmAttributes
ON VALUE-CHANGED OF fiWidth IN FRAME frmAttributes /* Width */
DO:
  glChanges = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK frmAttributes 


/* **************** Standard Buttons and Help Setup ******************* */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* ***************************  Main Block  *************************** */

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  
  gcLookupImg = DYNAMIC-FUNCTION("getLookupImage":U IN p_hSMO).
  buLookup:LOAD-IMAGE(gcLookupImg).
  buLookupSDO:LOAD-IMAGE(gcLookupImg).
  buLookupObject:LOAD-IMAGE(gcLookupImg).
  RUN buildCombos (coProduct:HANDLE).
  
  /* Enable the interface. */         
  RUN enable_UI.  
  setForeignFieldHelp().
  /* Get the values of the attributes in the SmartObject that can be changed 
     in this dialog-box. */
  RUN get-SmO-attributes.

  /* Set the cursor */
  RUN adecomm/_setcurs.p ("":U).  
  glChanges = FALSE.
  WAIT-FOR GO OF FRAME {&FRAME-NAME} FOCUS edQuery. 

END.

RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applySOValues frmAttributes 
PROCEDURE applySOValues :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFileName  AS CHARACTER  NO-UNDO.
  
  RUN getSmartObjectDetails (INPUT pcFileName).

  DO WITH FRAME {&FRAME-NAME}:
    
    ASSIGN
      gcBaseQuery           = gcLBaseQueryString
      edQuery               = gcBaseQuery
      gcBrowseFields        = gcLBrowseFields
      gcViewerLinkedFields  = gcLViewerLinkedFields 
      gcViewerLinkedWidgets = gcLViewerLinkedWidgets
      gcColumnLabels        = gcLColumnLabels
      gcColumnFormat        = gcLCoulmnFormat
      .
    DISPLAY
      edQuery
      .

    APPLY "CHOOSE":U TO buQuery.

    ASSIGN
      fiFieldLabel     = gcLFieldLabel  
      fiFieldToolTip   = gcLFieldTooltip
      fiRowsToBatch    = giLRowsToBatch
      fiBrowseTitle    = gcLBrowseTitle
      
      fiParentField        = gcLParentField
      edParentFilterQuery  = gcLParentFilterQuery
      fiMaintenanceObject  = gcLMaintenanceObject
      fiMaintenanceSDO     = gcLMaintenanceSDO
      .
    
    DISPLAY
      fiFieldLabel 
      fiBrowseTitle 
      fiFieldToolTip 
      fiRowsToBatch
      fiParentField        
      edParentFilterQuery
      fiMaintenanceObject  
      fiMaintenanceSDO
      .
      
      ASSIGN coDisplayedField:SCREEN-VALUE = gcLDisplayedField
             coKeyField:SCREEN-VALUE       = gcLKeyField.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignValues frmAttributes 
PROCEDURE assignValues :
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
      fiExternalField 
      coKeyField 
      coDisplayedField 
      fiBrowseTitle 
      fiFieldDatatype 
      fiFieldFormat 
      fiFieldLabel
      fiFieldToolTip 
      fiRow 
      fiColumn 
      fiHeight 
      fiWidth 
      fiRowsToBatch
      fiLookupTemplate
      fiLookupName
      fiParentField
      edParentFilterQuery
      edObjectDescription
      fiMaintenanceObject
      fiMaintenanceSDO
      coProduct
      coProductModule
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildCombos frmAttributes 
PROCEDURE buildCombos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER phCombo AS HANDLE     NO-UNDO.
  
  IF phCombo:NAME = "coProduct":U THEN DO:
    /** Product **/
    FIND FIRST ttComboData
         WHERE ttComboData.cWidgetName = "coProduct":U
         NO-ERROR.
    IF NOT AVAILABLE ttComboData THEN CREATE ttComboData.
  
    ASSIGN
      ttComboData.cWidgetName = "coProduct":U
      ttComboData.cWidgetType = "character":U
      ttComboData.hWidget = phCombo
      ttComboData.cForEach = "FOR EACH gsc_product NO-LOCK BY gsc_product.product_code":U
      ttComboData.cBufferList = "gsc_product":U
      ttComboData.cKeyFieldName = "gsc_product.product_code":U
      ttComboData.cDescFieldNames = "gsc_product.product_code,gsc_product.product_description":U
      ttComboData.cDescSubstitute = "&1 / &2":U
      ttComboData.cFlag = "":U
      ttComboData.cCurrentKeyValue = "":U
      ttComboData.cListItemDelimiter = ",":U
      ttComboData.cListItemPairs = "":U
      ttComboData.cCurrentDescValue = "":U
      .
  END.
  /** Product Module **/
  ELSE DO:
    FOR EACH  ttComboData
        WHERE ttComboData.cWidgetName = phCombo:NAME
        EXCLUSIVE-LOCK:
      DELETE ttComboData.
    END.
    CREATE ttComboData.
  
    DO WITH FRAME {&FRAME-NAME}:
      ASSIGN coProduct.
    END.
    ASSIGN
      ttComboData.cWidgetName = phCombo:NAME
      ttComboData.cWidgetType = "character":U
      ttComboData.hWidget = phCombo
      ttComboData.cForEach = "FOR EACH gsc_product NO-LOCK WHERE gsc_product.product_code = '":U + coProduct + "',":U +
                             "  EACH gsc_product_module NO-LOCK WHERE gsc_product_module.product_obj = gsc_product.product_obj " +
                             " BY gsc_product_module.product_module_code":U
      ttComboData.cBufferList = "gsc_product,gsc_product_module":U
      ttComboData.cKeyFieldName = "gsc_product_module.product_module_code":U
      ttComboData.cDescFieldNames = "gsc_product_module.product_module_code,gsc_product_module.product_module_description":U
      ttComboData.cDescSubstitute = "&1 / &2":U
      ttComboData.cFlag = "":U
      ttComboData.cCurrentKeyValue = "":U
      ttComboData.cListItemDelimiter = ",":U
      ttComboData.cListItemPairs = "":U
      ttComboData.cCurrentDescValue = "":U
      .
  END.

  IF VALID-HANDLE(gshAstraAppserver) AND CAN-FIND(FIRST ttComboData) THEN
    RUN af/app/afcobuildp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttComboData).
  
  FIND FIRST ttComboData WHERE ttComboData.hWidget = phCombo.
  IF NOT AVAILABLE ttComboData THEN RETURN.

  IF phCombo:NAME = "coProduct":U THEN
    coProduct:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ttComboData.cListItemPairs.
  ELSE
    coProductModule:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ttComboData.cListItemPairs.

  ASSIGN phCombo:SCREEN-VALUE = phCombo:ENTRY(1).
  APPLY "VALUE-CHANGED":U TO phCombo.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkSaved frmAttributes 
PROCEDURE checkSaved :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cButton AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAnswer AS CHARACTER  NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fiLookupName
           fiLookupTemplate.
  END.
  IF fiLookupName = "":U AND 
     fiLookupTemplate = "":U THEN DO:
     RUN askQuestion IN gshSessionManager (INPUT        "This lookup is not a SmartObject yet! Would you like to add this lookup's properties as a SmartObject?",    /* message to display */
                                           INPUT        "&YES,&NO,&Cancel":U,    /* button list */
                                           INPUT        "&YES":U,           /* default button */ 
                                           INPUT        "&Cancel":U,       /* cancel button */
                                           INPUT        "Add new SmartObject":U,             /* window title */
                                           INPUT        "":U,      /* data type of question */ 
                                           INPUT        "":U,          /* format mask for question */ 
                                           INPUT-OUTPUT cAnswer,              /* character value of answer to question */ 
                                                 OUTPUT cButton           /* button pressed */
                                           ).
    IF cButton = "&YES":U THEN DO:
      DISABLE ALL WITH FRAME {&FRAME-NAME}.
      ENABLE coProduct
             coProductModule 
             fiLookupName
             edObjectDescription
             buSave buCancelSave
             WITH FRAME {&FRAME-NAME}.
      APPLY "ENTRY":U TO fiLookupName.
      RETURN "NO-EXIT":U.
    END.
  END.
  
  IF fiLookupTemplate <> "":U AND
     fiLookupName      = "":U THEN DO:
    IF gcBaseQuery           <> gcLBaseQueryString     OR
       gcBrowseFields        <> gcLBrowseFields        OR
       gcViewerLinkedFields  <> gcLViewerLinkedFields  OR
       gcViewerLinkedWidgets <> gcLViewerLinkedWidgets OR
       gcColumnLabels        <> gcLColumnLabels        OR
       gcColumnFormat        <> gcLCoulmnFormat        OR
       fiFieldLabel          <> gcLFieldLabel          OR
       fiFieldToolTip        <> gcLFieldTooltip        OR
       fiRowsToBatch         <> giLRowsToBatch         OR
       fiBrowseTitle         <> gcLBrowseTitle         OR
       fiParentField         <> gcLParentField         OR
       edParentFilterQuery   <> gcLParentFilterQuery   OR
       fiMaintenanceObject   <> gcLMaintenanceObject   OR
       fiMaintenanceSDO      <> gcLMaintenanceSDO      OR
       coDisplayedField      <> gcLDisplayedField      OR
       coKeyField            <> gcLKeyField THEN DO:
       
      RUN askQuestion IN gshSessionManager (INPUT        "This lookup's properties is now different to the properties inherited from it's template.~nDo you want to make this lookup a new SmartObject?",    /* message to display */
                                            INPUT        "&YES,&NO,&Cancel":U,    /* button list */
                                            INPUT        "&YES":U,           /* default button */ 
                                            INPUT        "&Cancel":U,       /* cancel button */
                                            INPUT        "Create New SmartObject":U,             /* window title */
                                            INPUT        "":U,      /* data type of question */ 
                                            INPUT        "":U,          /* format mask for question */ 
                                            INPUT-OUTPUT cAnswer,              /* character value of answer to question */ 
                                                  OUTPUT cButton           /* button pressed */
                                            ).
      IF cButton = "&YES":U THEN DO:
        DISABLE ALL WITH FRAME {&FRAME-NAME}.
        ENABLE coProduct
               coProductModule 
               fiLookupName
               edObjectDescription
               buSave buCancelSave
               WITH FRAME {&FRAME-NAME}.
        APPLY "ENTRY":U TO fiLookupName.
        RETURN "NO-EXIT":U.
      END.
      ELSE DO:
        RUN askQuestion IN gshSessionManager (INPUT        "Do you want to detach this lookup from the template?",    /* message to display */
                                              INPUT        "&YES,&NO,&Cancel":U,    /* button list */
                                              INPUT        "&YES":U,           /* default button */ 
                                              INPUT        "&Cancel":U,       /* cancel button */
                                              INPUT        "Detach lookup from Template":U,             /* window title */
                                              INPUT        "":U,      /* data type of question */ 
                                              INPUT        "":U,          /* format mask for question */ 
                                              INPUT-OUTPUT cAnswer,              /* character value of answer to question */ 
                                                    OUTPUT cButton           /* button pressed */
                                              ).
        IF cButton = "&YES":U THEN DO:
          ASSIGN fiLookupTemplate:SCREEN-VALUE    = "":U
                 edObjectDescription:SCREEN-VALUE = "":U.
          ASSIGN fiLookupTemplate
                 edObjectDescription.
        END.
      END.
    END.
  END.
  
  /* If lookup name specified - save any new changes made */
  IF fiLookupName <> "":U THEN
    RUN setSmartObjectDetails (INPUT fiLookupName).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkScrTemplate frmAttributes 
PROCEDURE checkScrTemplate :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will check of the template used has different
               values than those on scree, it will then prompt the user for 
               change of screen values. If user does not allow change, the template
               use will be removed.
  Parameters:  pcLookupName - Name of the lookup template, or actual Lookup SmartObject
               pcType       - Template if pcLookupName contains the name of the
                              lookup's template.
                              SmartObject if pcLookupName contains the actual 
                              lookup's SmartObject name.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcLookupName  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcType        AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cButton AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAnswer AS CHARACTER  NO-UNDO.
  
  IF pcLookupName = "":U THEN
    RETURN.
    
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN coDisplayedField
           coKeyField.
  END.
  
  RUN getSmartObjectDetails (INPUT pcLookupName).

  IF gcBaseQuery           <> gcLBaseQueryString     OR
     gcBrowseFields        <> gcLBrowseFields        OR
     gcViewerLinkedFields  <> gcLViewerLinkedFields  OR
     gcViewerLinkedWidgets <> gcLViewerLinkedWidgets OR
     gcColumnLabels        <> gcLColumnLabels        OR
     gcColumnFormat        <> gcLCoulmnFormat        OR
     fiFieldLabel          <> gcLFieldLabel          OR
     fiFieldToolTip        <> gcLFieldTooltip        OR
     fiRowsToBatch         <> giLRowsToBatch         OR
     fiBrowseTitle         <> gcLBrowseTitle         OR
     fiParentField         <> gcLParentField         OR
     edParentFilterQuery   <> gcLParentFilterQuery   OR
     fiMaintenanceObject   <> gcLMaintenanceObject   OR
     fiMaintenanceSDO      <> gcLMaintenanceSDO      OR
     coDisplayedField      <> gcLDisplayedField      OR
     coKeyField            <> gcLKeyField THEN DO:
     
    RUN askQuestion IN gshSessionManager (INPUT        "The " + pcType + "'s properties has changed, do you want to apply these changes to this lookup?",    /* message to display */
                                          INPUT        "&YES,&NO,&Cancel":U,    /* button list */
                                          INPUT        "&YES":U,           /* default button */ 
                                          INPUT        "&Cancel":U,       /* cancel button */
                                          INPUT        "Use Template Defaults":U,             /* window title */
                                          INPUT        "":U,      /* data type of question */ 
                                          INPUT        "":U,          /* format mask for question */ 
                                          INPUT-OUTPUT cAnswer,              /* character value of answer to question */ 
                                                OUTPUT cButton           /* button pressed */
                                          ).
    IF cButton = "&YES":U THEN
      RUN applySOValues (INPUT pcLookupName).
    ELSE
      IF pcType = "Template":U THEN
        fiLookupTemplate:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U.
      ELSE 
        ASSIGN fiLookupName:SCREEN-VALUE IN FRAME {&FRAME-NAME}        = "":U
               edObjectDescription:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI frmAttributes  _DEFAULT-DISABLE
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
  HIDE FRAME frmAttributes.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI frmAttributes  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY coProduct coProductModule fiLookupTemplate fiLookupName 
          edObjectDescription fiRowsToBatch EdQuery fiQueryTables coKeyField 
          coDisplayedField fiWidth fiColumn fiFieldLabel fiHeight 
          fiExternalField fiRow fiParentField fiFieldDatatype 
          EdParentFilterQuery fiFieldToolTip fiBrowseTitle fiMaintenanceSDO 
          fiMaintenanceObject edHelp 
      WITH FRAME frmAttributes.
  ENABLE buClear fiLookupTemplate buLookup fiRowsToBatch EdQuery buQuery 
         BrBrowse coKeyField coDisplayedField fiWidth fiColumn fiFieldLabel 
         fiHeight fiRow fiParentField EdParentFilterQuery fiFieldToolTip 
         fiBrowseTitle fiMaintenanceSDO buLookupSDO fiMaintenanceObject 
         buLookupObject buOK buCancel edHelp 
      WITH FRAME frmAttributes.
  VIEW FRAME frmAttributes.
  {&OPEN-BROWSERS-IN-QUERY-frmAttributes}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-SmO-attributes frmAttributes 
PROCEDURE get-SmO-attributes :
/*------------------------------------------------------------------------------
  Purpose:     Ask the "parent" SmartObject for the attributes that can be 
               changed in this dialog.  Save some of the initial-values.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOk                                 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hFrame                              AS HANDLE     NO-UNDO.

  IF NOT VALID-HANDLE(p_hSMO) THEN RETURN.

  DO WITH FRAME {&FRAME-NAME}:
    
    ASSIGN
      gcBaseQuery           = DYNAMIC-FUNCTION('getBaseQueryString':U IN p_hSMO )
      edQuery               = gcBaseQuery
      fiExternalField       = DYNAMIC-FUNCTION('getFieldName':U IN p_hSMO)
      gcBrowseFields        = DYNAMIC-FUNCTION('getBrowseFields':U IN p_hSMO )
      gcViewerLinkedFields  = DYNAMIC-FUNCTION('getViewerLinkedFields':U IN p_hSMO )
      gcViewerLinkedWidgets = DYNAMIC-FUNCTION('getViewerLinkedWidgets':U IN p_hSMO )
      gcColumnLabels        = DYNAMIC-FUNCTION('getColumnLabels':U IN p_hSMO )
      gcColumnFormat        = DYNAMIC-FUNCTION('getColumnFormat':U IN p_hSMO )
      .
    DISPLAY
      edQuery
      fiExternalField 
      .

    APPLY "choose":U TO buQuery.

    ASSIGN
      fiFieldLabel          = DYNAMIC-FUNCTION('getFieldLabel':U IN p_hSMO)
      fiFieldToolTip        = DYNAMIC-FUNCTION('getFieldTooltip':U IN p_hSMO)
      fiRowsToBatch         = DYNAMIC-FUNCTION('getRowsToBatch':U IN p_hSMO )
      fiBrowseTitle         = DYNAMIC-FUNCTION('getBrowseTitle':U IN p_hSMO )
      fiLookupTemplate      = DYNAMIC-FUNCTION('getSDFTemplate':U IN p_hSMO )
      fiLookupName          = DYNAMIC-FUNCTION('getSDFFileName':U IN p_hSMO )
      fiParentField         = DYNAMIC-FUNCTION('getParentField':U IN p_hSMO )
      edParentFilterQuery   = DYNAMIC-FUNCTION('getParentFilterQuery':U IN p_hSMO )
      fiMaintenanceObject   = DYNAMIC-FUNCTION('getMaintenanceObject':U IN p_hSMO )
      fiMaintenanceSDO      = DYNAMIC-FUNCTION('getMaintenanceSDO':U IN p_hSMO )
      hFrame                = DYNAMIC-FUNCTION("getContainerHandle":U IN p_hSMO)
      fiColumn              = hFrame:COL
      fiRow                 = hFrame:ROW
      fiWidth               = hFrame:WIDTH
      fiHeight              = hFrame:HEIGHT
      .
      
    
    DISPLAY
      fiFieldLabel 
      fiBrowseTitle 
      fiFieldToolTip 
      fiRow 
      fiColumn 
      fiHeight 
      fiWidth 
      fiRowsToBatch
      fiLookupTemplate
      fiLookupName    
      fiParentField        
      edParentFilterQuery
      fiMaintenanceObject  
      fiMaintenanceSDO
      .

    IF fiLookupName <> "":U THEN
      RUN checkScrTemplate (INPUT fiLookupName,
                            INPUT "SmartObject":U).
    ELSE 
      RUN checkScrTemplate (INPUT fiLookupTemplate,
                            INPUT "Template":U).
      
    ASSIGN edObjectDescription:SCREEN-VALUE  = gcLObjectDescription.

  END.
  glChanges = FALSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSmartObjectDetails frmAttributes 
PROCEDURE getSmartObjectDetails :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFileName  AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cButton       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProdCode     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProdModCode  AS CHARACTER  NO-UNDO.

  FIND FIRST ryc_smartobject
       WHERE ryc_smartobject.object_filename = pcFileName
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ryc_smartobject THEN DO:
    RUN showMessages IN gshSessionManager (INPUT  "The SmartObject specified " + pcFileName + " could not be found. Check that the file name is correct and refresh the data.",    /* message to display */
                                           INPUT  "ERR":U,          /* error type */
                                           INPUT  "&OK,&Cancel":U,    /* button list */
                                           INPUT  "&OK":U,           /* default button */ 
                                           INPUT  "&Cancel":U,       /* cancel button */
                                           INPUT  "Lookup Field Object Not Found":U,             /* error window title */
                                           INPUT  NO,              /* display if empty */ 
                                           INPUT  ?,                /* container handle */ 
                                           OUTPUT cButton           /* button pressed */
                                          ).
    
  END.
  ELSE DO:
    FIND FIRST gsc_product_module
         WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
         NO-LOCK NO-ERROR.
    FIND FIRST gsc_product
         WHERE gsc_product.product_obj = gsc_product_module.product_obj
         NO-LOCK NO-ERROR.
    ASSIGN cProdCode    = IF AVAILABLE gsc_product THEN gsc_product.product_code ELSE "":U
           cProdModCode = IF AVAILABLE gsc_product_module THEN gsc_product_module.product_module_code ELSE "":U.
    DO WITH FRAME {&FRAME-NAME}:
      ASSIGN coProduct:SCREEN-VALUE = cProdCode.
      APPLY "VALUE-CHANGED":U TO coProduct.
      ASSIGN coProductModule:SCREEN-VALUE = cProdModCode.
    END.
    FIND FIRST gsc_object
         WHERE gsc_object.object_obj = ryc_smartobject.object_obj
         NO-LOCK NO-ERROR.
    IF AVAILABLE gsc_object THEN
      gclObjectDescription = gsc_object.object_description.
    FOR EACH  ryc_attribute_value
        WHERE ryc_attribute_value.smartobject_obj = ryc_smartobject.smartobject_obj
        NO-LOCK:
      CASE ryc_attribute_value.attribute_label:
        WHEN "SDFFileName" THEN
          gcLSDFFileName = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
        WHEN "SDFTemplate" THEN
          gcLSDFTemplate = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
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
      END CASE.
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSmartObjectDetails frmAttributes 
PROCEDURE setSmartObjectDetails :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFileName  AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cErrorText      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectLayout   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dContainer      AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dContainerType  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cAttributes     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValues         AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cButton AS CHARACTER  NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN coProduct
           coProductModule
           fiFieldDataType
           fiFieldFormat
           fiExternalField
           .
  END.
  
  /* create / update gsc_object and ryc_smartobject records */
  RUN updateDynamicObject (INPUT "lookup":U,
                           INPUT coProductModule,
                           INPUT pcFileName,
                           INPUT edObjectDescription,
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
          cValues     = fiLookupName + CHR(3) + fiLookupTemplate + CHR(3) + coDisplayedField + CHR(3) + coKeyField + CHR(3) 
                                    + fiFieldLabel + CHR(3) + fiFieldToolTip + CHR(3) + fiFieldFormat + CHR(3) + fiFieldDataType + CHR(3)
                                    + gcDisplayFormat + CHR(3) + gcDisplayDatatype + CHR(3) + EdQuery + CHR(3) + fiQueryTables + CHR(3) 
                                    + gcBrowseFields + CHR(3) + gcColumnLabels + CHR(3) + gcColumnFormat + CHR(3) + gcBrowseFieldDataTypes
                                    + CHR(3) + gcBrowseFieldFormats + CHR(3) + STRING(fiRowsToBatch) + CHR(3) + fiBrowseTitle + CHR(3) 
                                    + gcViewerLinkedFields + CHR(3) + gcLinkedFieldDataTypes + CHR(3) + gcLinkedFieldFormats + CHR(3) 
                                    + gcViewerLinkedWidgets + CHR(3) + gcLLookupImage + CHR(3) + fiParentField + CHR(3) + edParentFilterQuery 
                                    + CHR(3) + fiMaintenanceObject + CHR(3) + fiMaintenanceSDO + CHR(3) + "adm2/dynlookup.w" + CHR(3)
                                    + "SmartDataField":U + CHR(3) + "adeicon/select.bmp":U + CHR(3) + STRING(fiHeight) + CHR(3) 
                                    + STRING(fiWidth) + CHR(3) + STRING(fiColumn) + CHR(3) + STRING(fiRow) + CHR(3) + "YES":U
                                    + CHR(3) + STRING(YES) + CHR(3) + STRING(NO) + CHR(3) + STRING(NO) + CHR(3) + cObjectLayout + CHR(3) + fiExternalField.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateAttributeValues frmAttributes 
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
        .        
      IF bryc_attribute_value.container_smartobject_obj > 0 THEN
        ASSIGN bryc_attribute_value.primary_smartobject_obj = bryc_attribute_value.container_smartobject_obj.
      ELSE
        ASSIGN bryc_attribute_value.primary_smartobject_obj = bryc_attribute_value.smartobject_obj.
    END.

    ASSIGN
      bryc_attribute_value.collect_attribute_value_obj = bryc_attribute_value.attribute_value_obj
      bryc_attribute_value.collection_sequence = 0
      bryc_attribute_value.attribute_value = cAttributeValue
      bryc_attribute_value.inheritted_value = NO
      .

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateDynamicObject frmAttributes 
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
  WHEN "lookup":U THEN  /* Dynamic Lookup */
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
      .      
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
    .
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
      .      
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
    .  
  VALIDATE bryc_smartobject NO-ERROR.
  {checkerr.i &no-return = YES}
  IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

  ASSIGN
    pdSmartObject = bryc_smartobject.smartobject_obj
    pdObjectType = dObjectType
    .

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
      .

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateData frmAttributes 
PROCEDURE validateData :
/*------------------------------------------------------------------------------
  Purpose:     To validate property data entered
  Parameters:  output ok, yes or no.
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER plOk                AS LOGICAL    NO-UNDO.

DEFINE VARIABLE cAllFields                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAllNames                   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cField                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cName                       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.

ASSIGN plOK = YES.

DO WITH FRAME {&FRAME-NAME}:

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

  /*IF fiFieldLabel:SCREEN-VALUE = "":U THEN
  DO:
    MESSAGE "A Field Label Must be Specified - cannot apply changes"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    ASSIGN plOK = NO.
    RETURN.
  END.
    */
  IF fiBrowseTitle:SCREEN-VALUE = "":U THEN
  DO:
    MESSAGE "A Browse Title Must be Specified - cannot apply changes"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    ASSIGN plOK = NO.
    RETURN.
  END.

  IF NOT INTEGER(fiRowsToBatch:SCREEN-VALUE) > 0 THEN
  DO:
    MESSAGE "Rows to Batch Must be Greater Than 0 - cannot apply changes"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    ASSIGN plOK = NO.
    RETURN.
  END.

  IF gcBrowseFields = "":U THEN
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
  DEFINE VARIABLE cButton AS CHARACTER  NO-UNDO.
  
  ASSIGN fiParentField
         edParentFilterQuery.
  
  IF NUM-ENTRIES(fiParentField) <> numOccurance(edParentFilterQuery,"&":U) THEN DO:
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
  
  IF fiMaintenanceObject <> "":U AND
     fiMaintenanceSDO     = "":U THEN DO:
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
    APPLY "ENTRY":U TO fiMaintenanceSDO IN FRAME {&FRAME-NAME}.
    RETURN NO-APPLY.
  END.

  IF fiMaintenanceSDO    <> "":U AND
     fiMaintenanceObject = "":U THEN DO:
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
    APPLY "ENTRY":U TO fiMaintenanceObject IN FRAME {&FRAME-NAME}.
    RETURN NO-APPLY.
  END.
  
  /* Check that the parent filter query is valid */
  IF edParentFilterQuery <> "":U THEN DO:
    IF INDEX(edParentFilterQuery,"FOR ":U)   <> 0 OR
       INDEX(edParentFilterQuery,"EACH ":U)  <> 0 OR 
       INDEX(edParentFilterQuery,"WHERE ":U)  <> 0 OR 
       INDEX(edParentFilterQuery,"FIRST ":U) <> 0 OR
       INDEX(edParentFilterQuery,"LAST ":U)  <> 0 OR
       INDEX(edParentFilterQuery,"BREAK ":U) <> 0 OR 
       INDEX(edParentFilterQuery,",":U) <> 0 THEN DO:
      RUN showMessages IN gshSessionManager (INPUT  "The parent filter query specified is invalid. Should not contain FOR EACH, FIRST, LAST or BREAK BY",    /* message to display */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFuncLibHandle frmAttributes 
FUNCTION getFuncLibHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF NOT VALID-HANDLE(ghFuncLib) THEN 
  DO:
      ghFuncLib = SESSION:FIRST-PROCEDURE.
      DO WHILE VALID-HANDLE(ghFuncLib):
        IF ghFuncLib:FILE-NAME = "adeuib/_abfuncs.w":U THEN LEAVE.
        ghFuncLib = ghFuncLib:NEXT-SIBLING.
      END.
  END.
  RETURN ghFuncLib.   /* Function return value. */

  RETURN ?.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION numOccurance frmAttributes 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setForeignFieldHelp frmAttributes 
FUNCTION setForeignFieldHelp RETURNS LOGICAL
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

