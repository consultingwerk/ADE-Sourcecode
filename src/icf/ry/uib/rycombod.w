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

  File: rycombod.w 

  Description: Instance Attributes Dialog for ICF Dynamic Combo.

  Input Parameters:
     p_hSMO -- Procedure Handle of calling SmartObject.

  Output Parameters:
      <none>

  Modified: 08/27/2001 (Mark Davies)
            If more than one field is displayed in the combo's list items 
            and the developer changes the substitute field to view fields 
            in a different order or change the delimiter, the field is reset 
            upon selecting the OK button.

 Modifed:  08/28/2001 (Mark Davies)
           The Dynamic Lookup and Combo's Base Query String editor 
           concatenates the whole query string and thus causes the 
           string to be invalid. Make sure that when enter was pressed 
           that spaces are left in its place.

Modified: 09/25/2001         Mark Davies (MIP)
          1. Allow detaching of combo from template if properties
             were changed.
          2. Remove references to KeyFieldValue and SavedScreenValue
          3. Reposition Product and Product module combos to template
             combo or combo smartobject.
          4. Grey-out object description when disabled.
Modified: 10/01/2001        Mark Davies (MIP)
          Resized the dialog to fit in 800x600
Modofied: 10/16/2001        Mark Davies (MIP)
          1. Removed 'Sort' option and added Inner Lines
Modified: 01/16/2002        Mark Davies (MIP)
          Fixed issue #3683 - Data is lost have it has been saved when 
          dismissing a window
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_hSMO                   AS HANDLE     NO-UNDO.

DEFINE VARIABLE ghFuncLib               AS HANDLE     NO-UNDO. 
DEFINE VARIABLE gcBaseQuery             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcNameList              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcFormatList            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcTypeList              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLabelList             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcCLabelList            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcKeyField              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSaveDisplayField      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDisplayedFields       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDisplayFormat         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDisplayDataType       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSDFFileName           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSDFTemplate           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBrowseFields          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcFieldLabel            AS CHARACTER  NO-UNDO.

/* Template Storage Variables */
DEFINE VARIABLE gcLSDFFileName          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLSDFTemplate          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLObjectDescription    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLKeyField             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLFieldLabel           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLFieldTooltip         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLKeyFormat            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLKeyDataType          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLDisplayedFields      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLDisplayFormat        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLDisplayDataType      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLBaseQueryString      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLQueryTables          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLParentField          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLParentFilterQuery    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLDescSubstitute       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLComboFlag            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLFlagValue            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE giLInnerLines           AS INTEGER    NO-UNDO.
DEFINE VARIABLE giLBuildSeq             AS INTEGER    NO-UNDO.

DEFINE VARIABLE glChanges               AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cRowPreVal              AS CHARACTER  NO-UNDO EXTENT 5.

/* temp-table for query field information */
DEFINE TEMP-TABLE ttFields NO-UNDO
FIELD cFieldName              AS CHARACTER    /* name of query field */
FIELD cFieldDataType          AS CHARACTER    /* data type */
FIELD cFieldFormat            AS CHARACTER    /* format */
FIELD cOrigLabel              AS CHARACTER    /* Original Column Label */
FIELD iBrowseFieldSeq         AS INTEGER      /* if to be included in browser, sequence of field within browser */
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
&Scoped-define FIELDS-IN-QUERY-BrBrowse ttFields.cFieldName ttFields.iBrowseFieldSeq ttFields.cOrigLabel ttFields.cFieldDataType ttFields.cFieldFormat   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrBrowse ttFields.iBrowseFieldSeq   
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
&Scoped-Define ENABLED-OBJECTS fiInnerLines buClear fiComboTemplate ~
buLookup buQuery EdQuery BrBrowse coKeyField fiWidth fiColumn ~
EdDisplayedFields fiHeight fiRow fiBuildSeq fiFieldLabel fiFieldToolTip ~
raFlag fiParentField EdParentFilterQuery edHelp buOK buCancel 
&Scoped-Define DISPLAYED-OBJECTS fiInnerLines coProduct coProductModule ~
fiComboTemplate fiComboName edObjectDescription EdQuery fiQueryTables ~
coKeyField fiWidth fiColumn fiExternalField EdDisplayedFields fiHeight ~
fiFieldDatatype fiRow fiDescSubstitute fiBuildSeq fiFieldLabel ~
fiFieldToolTip raFlag fiDefaultValue fiParentField EdParentFilterQuery ~
edHelp 

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

DEFINE VARIABLE EdDisplayedFields AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 69 BY 1.71 NO-UNDO.

DEFINE VARIABLE edHelp AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 39.2 BY 5.48 NO-UNDO.

DEFINE VARIABLE EdParentFilterQuery AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 69 BY 1.71 TOOLTIP "Parent filter query addition." NO-UNDO.

DEFINE VARIABLE EdQuery AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 10000 SCROLLBAR-VERTICAL LARGE
     SIZE 113 BY 1.71 NO-UNDO.

DEFINE VARIABLE edObjectDescription AS CHARACTER FORMAT "X(70)":U 
     LABEL "Object Description" 
     VIEW-AS FILL-IN 
     SIZE 65 BY 1 NO-UNDO.

DEFINE VARIABLE fiBuildSeq AS INTEGER FORMAT "->9":U INITIAL 0 
     LABEL "Build Sequence" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE fiColumn AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "&Column" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 TOOLTIP "Column for displayed field" NO-UNDO.

DEFINE VARIABLE fiComboName AS CHARACTER FORMAT "X(35)":U 
     LABEL "Object Name" 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 NO-UNDO.

DEFINE VARIABLE fiComboTemplate AS CHARACTER FORMAT "X(35)":U 
     LABEL "Use Template" 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 TOOLTIP "The template lookup to base this lookup on." NO-UNDO.

DEFINE VARIABLE fiDefaultValue AS CHARACTER FORMAT "X(35)":U 
     LABEL "Default Value" 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 NO-UNDO.

DEFINE VARIABLE fiDescSubstitute AS CHARACTER FORMAT "X(70)":U 
     LABEL "Descr Substitute" 
     VIEW-AS FILL-IN 
     SIZE 69 BY 1 TOOLTIP "Specify the description substitution. e.g. &&&1 - &&&2 / &&&3" NO-UNDO.

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

DEFINE VARIABLE fiFieldToolTip AS CHARACTER FORMAT "X(256)":U INITIAL "Select option from list" 
     LABEL "&Tooltip" 
     VIEW-AS FILL-IN 
     SIZE 69 BY 1 TOOLTIP "Tooltip for displayed field" NO-UNDO.

DEFINE VARIABLE fiHeight AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "&Height" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 TOOLTIP "height of displayed field" NO-UNDO.

DEFINE VARIABLE fiInnerLines AS INTEGER FORMAT ">9":U INITIAL 5 
     LABEL "Inner Lines" 
     VIEW-AS FILL-IN 
     SIZE 8.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiParentField AS CHARACTER FORMAT "X(70)":U 
     LABEL "Parent Fields" 
     VIEW-AS FILL-IN 
     SIZE 69 BY 1 TOOLTIP "The Field/Widget Name for the parent field that this combo is dependant on." NO-UNDO.

DEFINE VARIABLE fiQueryTables AS CHARACTER FORMAT "X(256)":U 
     LABEL "Query Tables" 
     VIEW-AS FILL-IN 
     SIZE 112.6 BY 1 TOOLTIP "Comma delimited list of tables in above query" NO-UNDO.

DEFINE VARIABLE fiRow AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "&Row" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 TOOLTIP "Row for displayed field" NO-UNDO.

DEFINE VARIABLE fiWidth AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "&Width" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 TOOLTIP "Width of displayed field" NO-UNDO.

DEFINE VARIABLE raFlag AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Data Only", "",
"<All> and Data", "A",
"<None> and Data", "N"
     SIZE 69 BY .76 TOOLTIP "Add extra option on combo." NO-UNDO.

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
      ttFields.iBrowseFieldSeq FORMAT ">>9":U    LABEL "Display Seq.":U
      ttFields.cOrigLabel      FORMAT "X(35)":U  LABEL "Column Label":U
      ttFields.cFieldDataType  FORMAT "X(15)":U  LABEL "Data Type":U
      ttFields.cFieldFormat    FORMAT "X(30)":U  LABEL "Format":U
  ENABLE
      ttFields.iBrowseFieldSeq
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 128.8 BY 5.14 ROW-HEIGHT-CHARS .62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frmAttributes
     fiInnerLines AT ROW 23.48 COL 20.8 COLON-ALIGNED
     coProduct AT ROW 1 COL 20.8 COLON-ALIGNED
     buClear AT ROW 1.1 COL 119.6
     coProductModule AT ROW 2 COL 20.8 COLON-ALIGNED
     buApply AT ROW 3 COL 76.6
     fiComboTemplate AT ROW 3 COL 20.8 COLON-ALIGNED
     buLookup AT ROW 3.1 COL 71.4
     fiComboName AT ROW 4.05 COL 20.8 COLON-ALIGNED
     edObjectDescription AT ROW 5.1 COL 20.8 COLON-ALIGNED
     buSave AT ROW 5 COL 88.6
     buCancelSave AT ROW 5 COL 104.2
     buQuery AT ROW 6.81 COL 119.8
     EdQuery AT ROW 6.76 COL 6 NO-LABEL
     fiQueryTables AT ROW 8.52 COL 20 COLON-ALIGNED
     BrBrowse AT ROW 9.57 COL 5.8
     coKeyField AT ROW 15.71 COL 20.8 COLON-ALIGNED
     fiFieldFormat AT ROW 15.71 COL 102.4 COLON-ALIGNED
     fiWidth AT ROW 16.76 COL 102.4 COLON-ALIGNED
     fiColumn AT ROW 16.76 COL 122.8 COLON-ALIGNED
     fiExternalField AT ROW 14.71 COL 9 NO-TAB-STOP 
     EdDisplayedFields AT ROW 16.81 COL 22.8 NO-LABEL
     fiHeight AT ROW 17.81 COL 102.4 COLON-ALIGNED
     fiFieldDatatype AT ROW 14.71 COL 102.4 COLON-ALIGNED NO-TAB-STOP 
     fiRow AT ROW 17.81 COL 122.8 COLON-ALIGNED
     fiDescSubstitute AT ROW 18.57 COL 20.8 COLON-ALIGNED
     fiBuildSeq AT ROW 18.86 COL 122.8 COLON-ALIGNED
     fiFieldLabel AT ROW 19.62 COL 20.8 COLON-ALIGNED
     fiFieldToolTip AT ROW 20.62 COL 20.8 COLON-ALIGNED
     raFlag AT ROW 21.67 COL 22.6 NO-LABEL
     fiDefaultValue AT ROW 22.48 COL 20.8 COLON-ALIGNED
     fiParentField AT ROW 24.48 COL 20.8 COLON-ALIGNED
     EdParentFilterQuery AT ROW 25.48 COL 22.8 NO-LABEL
     edHelp AT ROW 19.91 COL 95.6 NO-LABEL NO-TAB-STOP 
     buOK AT ROW 26.05 COL 104.2
     buCancel AT ROW 26.05 COL 120.2
     "Specify Base Query String (FOR EACH):" VIEW-AS TEXT
          SIZE 83.6 BY .62 AT ROW 6.14 COL 5
     "Parent Filter Query:" VIEW-AS TEXT
          SIZE 18.4 BY .62 AT ROW 25.38 COL 4.2
     "Extra Options:" VIEW-AS TEXT
          SIZE 14 BY .62 AT ROW 21.81 COL 9
     "Description Fields:" VIEW-AS TEXT
          SIZE 17.6 BY .62 AT ROW 16.86 COL 5
     SPACE(112.60) SKIP(9.71)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Dynamic Combo Properties":L
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
       EdDisplayedFields:RETURN-INSERTED IN FRAME frmAttributes  = TRUE
       EdDisplayedFields:READ-ONLY IN FRAME frmAttributes        = TRUE.

ASSIGN 
       edHelp:RETURN-INSERTED IN FRAME frmAttributes  = TRUE
       edHelp:READ-ONLY IN FRAME frmAttributes        = TRUE.

/* SETTINGS FOR FILL-IN edObjectDescription IN FRAME frmAttributes
   NO-ENABLE                                                            */
ASSIGN 
       EdParentFilterQuery:RETURN-INSERTED IN FRAME frmAttributes  = TRUE.

ASSIGN 
       EdQuery:RETURN-INSERTED IN FRAME frmAttributes  = TRUE.

/* SETTINGS FOR FILL-IN fiComboName IN FRAME frmAttributes
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiDefaultValue IN FRAME frmAttributes
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiDescSubstitute IN FRAME frmAttributes
   NO-ENABLE                                                            */
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
ASSIGN 
       fiFieldFormat:READ-ONLY IN FRAME frmAttributes        = TRUE.

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
ON GO OF FRAME frmAttributes /* Dynamic Combo Properties */
DO:     
  DEFINE VARIABLE hFrame                              AS HANDLE     NO-UNDO.

  IF NOT VALID-HANDLE(p_hSMO) THEN RETURN.
  
  DYNAMIC-FUNCTION('setDisplayedField':U    IN p_hSMO, edDisplayedFields). 
  DYNAMIC-FUNCTION('setKeyField':U          IN p_hSMO, coKeyField). 
  DYNAMIC-FUNCTION('setFieldLabel':U        IN p_hSMO, fiFieldLabel). 
  DYNAMIC-FUNCTION('setFieldTooltip':U      IN p_hSMO, fiFieldToolTip). 
  DYNAMIC-FUNCTION('setKeyFormat':U         IN p_hSMO, fiFieldFormat). 
  DYNAMIC-FUNCTION('setKeyDataType':U       IN p_hSMO, fiFieldDatatype). 
  DYNAMIC-FUNCTION('setDisplayFormat':U     IN p_hSMO, gcDisplayFormat). 
  DYNAMIC-FUNCTION('setDisplayDataType':U   IN p_hSMO, gcDisplayDataType). 
  DYNAMIC-FUNCTION('setBaseQueryString':U   IN p_hSMO, gcBaseQuery). 
  DYNAMIC-FUNCTION('setQueryTables':U       IN p_hSMO, fiQueryTables). 
  DYNAMIC-FUNCTION('setSDFFileName':U       IN p_hSMO, fiComboName).
  DYNAMIC-FUNCTION('setSDFTemplate':U       IN p_hSMO, fiComboTemplate).
  DYNAMIC-FUNCTION('setParentField':U       IN p_hSMO, fiParentField).
  DYNAMIC-FUNCTION('setParentFilterQuery':U IN p_hSMO, edParentFilterQuery).
  DYNAMIC-FUNCTION('setComboFlag':U         IN p_hSMO, raFlag).
  DYNAMIC-FUNCTION('setDescSubstitute':U    IN p_hSMO, fiDescSubstitute).
  DYNAMIC-FUNCTION('setFlagValue':U         IN p_hSMO, fiDefaultValue).
  DYNAMIC-FUNCTION('setBuildSequence':U     IN p_hSMO, fiBuildSeq).
  DYNAMIC-FUNCTION('setInnerLines':U        IN p_hSMO, fiInnerLines).
  
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
ON HELP OF FRAME frmAttributes /* Dynamic Combo Properties */
OR HELP OF FRAME {&FRAME-NAME}
DO: 
  /* Help for this Frame */
  RUN adecomm/_adehelp.p
                ("ICAB":U, "CONTEXT":U, {&Dynamic_Combo_Instance_Properties_Dialog_Box}  , "":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frmAttributes frmAttributes
ON WINDOW-CLOSE OF FRAME frmAttributes /* Dynamic Combo Properties */
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
ON LEAVE OF BrBrowse IN FRAME frmAttributes
DO:
/* We should re-build the displayed field list */
  DEFINE VARIABLE iLoop AS INTEGER    NO-UNDO.

  DEFINE BUFFER bttFields FOR ttFields.
  ASSIGN edDisplayedFields = "":U
         fiDescSubstitute  = "":U.
  FOR EACH bttFields BY bttFields.iBrowseFieldSeq:
    IF bttFields.iBrowseFieldSeq > 0 THEN
      ASSIGN 
        edDisplayedFields = edDisplayedFields +
                            (IF edDisplayedFields = "":U THEN "":U ELSE ",":U) +
                            bttFields.cFieldName
        gcLKeyFormat      = bttFields.cFieldFormat
        gcLKeyDataType    = bttFields.cFieldDataType.
                                      
  END.
  DO iLoop = 1 TO NUM-ENTRIES(edDisplayedFields):
    ASSIGN fiDescSubstitute = fiDescSubstitute +
                              (IF fiDescSubstitute = "":U 
                                  THEN "&":U + STRING(iLoop)
                                  ELSE (IF iLoop = 1 THEN " - ":U ELSE " / ":U) + "&":U + STRING(iLoop)).
  END.
  DO WITH FRAME {&FRAME-NAME}:
    IF numOccurance(fiDescSubstitute:SCREEN-VALUE,"&") = NUM-ENTRIES(edDisplayedFields) AND 
       fiDescSubstitute:SCREEN-VALUE <> fiDescSubstitute THEN
      fiDescSubstitute = fiDescSubstitute:SCREEN-VALUE.
  END.
  /* If more than one field is displayed in the combo 
     set the format to X(256) */
  IF NUM-ENTRIES(edDisplayedFields) > 1 THEN
    ASSIGN gcLKeyFormat   = "X(256)":U
           gcLKeyDataType = "CHARACTER":U.

           
  DISPLAY edDisplayedFields
          fiDescSubstitute
          WITH FRAME {&FRAME-NAME}.

  IF (iLoop - 1) > 1 THEN
    ENABLE fiDescSubstitute WITH FRAME {&FRAME-NAME}.
  ELSE
    DISABLE fiDescSubstitute WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BrBrowse frmAttributes
ON ROW-ENTRY OF BrBrowse IN FRAME frmAttributes
DO:
  ASSIGN cRowPreVal[1] = ttFields.iBrowseFieldSeq:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BrBrowse frmAttributes
ON ROW-LEAVE OF BrBrowse IN FRAME frmAttributes
DO:
  IF cRowPreVal[1] <> ttFields.iBrowseFieldSeq:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} THEN
    glChanges = TRUE.
  APPLY "LEAVE":U TO SELF.
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
  RUN applySOValues (INPUT fiComboTemplate).
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
          fiComboName
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
  ASSIGN fiComboTemplate       = "":U
         fiComboName           = "":U
         edObjectDescription   = "":U
         edQuery               = "":U
         fiFieldLabel          = "":U
         fiParentField         = "":U
         edParentFilterQuery   = "":U
         fiFieldTooltip        = "":U.
  DISPLAY fiComboTemplate
          fiComboName
          edObjectDescription
          edQuery
          fiFieldLabel
          fiParentField
          edParentFilterQuery
          fiFieldTooltip
          WITH FRAME {&FRAME-NAME}.
  APPLY "LEAVE":U TO fiComboTemplate IN FRAME {&FRAME-NAME}.
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
                           INPUT "DynCombo":U,
                           INPUT FALSE,
                           OUTPUT fiComboTemplate).
  DISPLAY fiComboTemplate WITH FRAME {&FRAME-NAME}.
  APPLY "LEAVE":U TO fiComboTemplate IN FRAME {&FRAME-NAME}.
  APPLY "ENTRY":U TO buApply IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOK frmAttributes
ON CHOOSE OF buOK IN FRAME frmAttributes /* OK */
DO:
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

    coKeyField:LIST-ITEM-PAIRS = "x,x":U.
    edDisplayedFields:SCREEN-VALUE = "":U.
    coKeyField = "x".
    coKeyField:SCREEN-VALUE = coKeyField:SCREEN-VALUE.  
    fiQueryTables:SCREEN-VALUE = "":U.
    DISPLAY
      BrBrowse.
    DISABLE
      BrBrowse edDisplayedFields coKeyField.

    /* populate other fields */
    APPLY "value-changed" TO coKeyField.  

    RETURN NO-APPLY.    
  END.
  ELSE
  DO WITH FRAME {&FRAME-NAME}:
    /* Query is valid - rebuild screen values */
    ENABLE
      BrBrowse edDisplayedFields coKeyField.
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

    coKeyField:SCREEN-VALUE = fiExternalField:SCREEN-VALUE NO-ERROR. 

    gcKeyField = DYNAMIC-FUNCTION('getKeyField':U IN p_hSMO) NO-ERROR.
    coKeyField:SCREEN-VALUE = gcKeyField NO-ERROR. 

    DISPLAY
      BrBrowse.

    /* populate other fields */
    APPLY "value-changed" TO coKeyField.  
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
  
  ASSIGN fiComboName
         edObjectDescription.
  IF fiComboName = "":U THEN DO:
    RUN showMessages IN gshSessionManager (INPUT  "You must enter an Object Name.",    /* message to display */
                                           INPUT  "ERR":U,          /* error type */
                                           INPUT  "&OK,&Cancel":U,    /* button list */
                                           INPUT  "&OK":U,           /* default button */ 
                                           INPUT  "&Cancel":U,       /* cancel button */
                                           INPUT  "Object Name Mandetory":U,             /* error window title */
                                           INPUT  YES,              /* display if empty */ 
                                           INPUT  ?,                /* container handle */ 
                                           OUTPUT cButton           /* button pressed */
                                          ).
    APPLY "ENTRY":U TO fiComboName.
    RETURN NO-APPLY.
  END.
  
  IF edObjectDescription = "":U THEN DO:
    RUN showMessages IN gshSessionManager (INPUT  "You must enter a Description for this new object.",    /* message to display */
                                           INPUT  "ERR":U,          /* error type */
                                           INPUT  "&OK,&Cancel":U,    /* button list */
                                           INPUT  "&OK":U,           /* default button */ 
                                           INPUT  "&Cancel":U,       /* cancel button */
                                           INPUT  "Combo Description Mandetory":U,             /* error window title */
                                           INPUT  YES,              /* display if empty */ 
                                           INPUT  ?,                /* container handle */ 
                                           OUTPUT cButton           /* button pressed */
                                          ).
    APPLY "ENTRY":U TO edObjectDescription.
    RETURN NO-APPLY.
  END.
  
  /* First check if it already exists */
  IF CAN-FIND(FIRST ryc_smartobject
              WHERE ryc_smartobject.object_filename = fiComboName NO-LOCK) THEN DO:
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
    APPLY "ENTRY":U TO fiComboName.
    RETURN NO-APPLY.
  END.
              
  SESSION:SET-WAIT-STATE("GENERAL":U).
  RUN setSmartObjectDetails (INPUT fiComboName).
  IF RETURN-VALUE <> "":U THEN
    RETURN NO-APPLY.
  SESSION:SET-WAIT-STATE("":U).
  
  ENABLE ALL WITH FRAME {&FRAME-NAME}.
  DISABLE coProduct
          coProductModule 
          fiComboName
          edObjectDescription
          buSave buCancelSave
          WITH FRAME {&FRAME-NAME}.
  ASSIGN buSave:HIDDEN       = TRUE
         buCancelSave:HIDDEN = TRUE.
  APPLY "CHOOSE":U TO buOK IN FRAME {&FRAME-NAME}.
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
    IF (fiFieldLabel:SCREEN-VALUE = "":U OR gcKeyField <> coKeyField) AND
      LOOKUP(coKeyField,coKeyField:LIST-ITEM-PAIRS) > 0 AND
      gcCLabelList <> "":U THEN
    fiFieldLabel:SCREEN-VALUE = ENTRY(LOOKUP(coKeyField,gcNameList),gcCLabelList,CHR(1)) NO-ERROR.
    ELSE IF gcKeyField = coKeyField THEN
      fiFieldLabel:SCREEN-VALUE = gcFieldLabel.
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


&Scoped-define SELF-NAME EdDisplayedFields
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL EdDisplayedFields frmAttributes
ON VALUE-CHANGED OF EdDisplayedFields IN FRAME frmAttributes
DO:
  glChanges = TRUE.
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


&Scoped-define SELF-NAME fiBuildSeq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiBuildSeq frmAttributes
ON VALUE-CHANGED OF fiBuildSeq IN FRAME frmAttributes /* Build Sequence */
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


&Scoped-define SELF-NAME fiComboTemplate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiComboTemplate frmAttributes
ON LEAVE OF fiComboTemplate IN FRAME frmAttributes /* Use Template */
DO:
  ASSIGN fiComboTemplate.
  IF fiComboTemplate <> "":U THEN DO:
    ENABLE buApply WITH FRAME {&FRAME-NAME}.
    APPLY "ENTRY":U TO buApply IN FRAME {&FRAME-NAME}.
  END.
  ELSE
    buApply:HIDDEN = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiDefaultValue
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiDefaultValue frmAttributes
ON LEAVE OF fiDefaultValue IN FRAME frmAttributes /* Default Value */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiDefaultValue frmAttributes
ON VALUE-CHANGED OF fiDefaultValue IN FRAME frmAttributes /* Default Value */
DO:
  glChanges = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiDescSubstitute
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiDescSubstitute frmAttributes
ON VALUE-CHANGED OF fiDescSubstitute IN FRAME frmAttributes /* Descr Substitute */
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


&Scoped-define SELF-NAME fiInnerLines
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiInnerLines frmAttributes
ON VALUE-CHANGED OF fiInnerLines IN FRAME frmAttributes /* Inner Lines */
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


&Scoped-define SELF-NAME fiWidth
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiWidth frmAttributes
ON VALUE-CHANGED OF fiWidth IN FRAME frmAttributes /* Width */
DO:
  glChanges = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME raFlag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL raFlag frmAttributes
ON VALUE-CHANGED OF raFlag IN FRAME frmAttributes
DO:
  ASSIGN raFlag.

  IF raFlag = "":U THEN
    ASSIGN fiDefaultValue:SCREEN-VALUE = "":U
           fiDefaultValue:SENSITIVE    = FALSE.
  ELSE
    fiDefaultValue:SENSITIVE = TRUE.
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
  
  buLookup:LOAD-IMAGE("adeicon/select.bmp").
  
  RUN buildCombos (coProduct:HANDLE).
  /* Enable the interface. */         
  RUN enable_UI.  
  setForeignFieldHelp().
  /* Get the values of the attributes in the SmartObject that can be changed 
     in this dialog-box. */
  
  RUN get-SmO-attributes.

  /* Set the cursor */
  RUN adecomm/_setcurs.p ("":U).  

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
      gcBaseQuery = gcLBaseQueryString
      edQuery     = gcBaseQuery
      .
    DISPLAY
      edQuery
      .

    APPLY "CHOOSE":U TO buQuery.

    ASSIGN
      fiFieldLabel         = gcLFieldLabel  
      fiFieldToolTip       = gcLFieldTooltip
      fiParentField        = gcLParentField
      edParentFilterQuery  = gcLParentFilterQuery
      edDisplayedFields    = gcLDisplayedFields
      raFlag               = gcLComboFlag
      fiDescSubstitute     = gcLDescSubstitute
      fiInnerLines         = giLInnerLines
      fiDefaultValue       = gcLFlagValue
      gcBrowseFields       = edDisplayedFields
      fiBuildSeq           = giLBuildSeq.
    
    DISPLAY
      fiFieldLabel 
      fiFieldToolTip 
      fiParentField        
      edParentFilterQuery
      edDisplayedFields 
      raFlag            
      fiDescSubstitute
      fiInnerLines
      fiDefaultValue
      fiBuildSeq.
      
      
      APPLY "CHOOSE":U TO buQuery IN FRAME {&FRAME-NAME}.
      APPLY "LEAVE":U  TO brBrowse IN FRAME {&FRAME-NAME}.
      APPLY "VALUE-CHANGED":U TO raFlag IN FRAME {&FRAME-NAME}.
      ASSIGN coKeyField:SCREEN-VALUE  = gcLKeyField.
      APPLY "VALUE-CHANGED":U TO coKeyField IN FRAME {&FRAME-NAME}.
      APPLY "ENTRY":U TO coKeyField IN FRAME {&FRAME-NAME}.
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
      fiFieldDatatype 
      fiFieldFormat 
      fiFieldLabel
      fiFieldToolTip 
      fiRow 
      fiColumn 
      fiHeight 
      fiWidth 
      fiComboTemplate
      fiComboName
      fiParentField
      edParentFilterQuery
      edObjectDescription
      coProduct
      coProductModule
      edDisplayedFields
      fiDescSubstitute
      fiInnerLines
      fiDefaultValue
      fiBuildSeq.
    ASSIGN raFlag.

    IF fiFieldToolTip = "":U THEN
      ASSIGN fiFieldToolTip = "Select option from list"
             fiFieldToolTip:SCREEN-VALUE = fiFieldToolTip.
    ASSIGN 
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
    RUN adm2/cobuildp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttComboData).
  
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
    ASSIGN fiComboName
           fiComboTemplate.
  END.
  IF fiComboName = "":U AND 
     fiComboTemplate = "":U THEN DO:
    RUN askQuestion IN gshSessionManager (INPUT        "This combo is not a SmartObject yet! Would you like to add this combo's properties as a SmartObject?",    /* message to display */
                                           INPUT        "&YES,&NO,&Cancel":U,    /* button list */
                                           INPUT        "&YES":U,                /* default button */ 
                                           INPUT        "&Cancel":U,             /* cancel button */
                                           INPUT        "Add new SmartObject":U, /* window title */
                                           INPUT        "":U,                    /* data type of question */ 
                                           INPUT        "":U,                    /* format mask for question */ 
                                           INPUT-OUTPUT cAnswer,                 /* character value of answer to question */ 
                                                 OUTPUT cButton                  /* button pressed */
                                           ).
    IF cButton = "&YES":U THEN DO:
      DISABLE ALL WITH FRAME {&FRAME-NAME}.
      ENABLE coProduct
             coProductModule 
             fiComboName
             edObjectDescription
             buSave buCancelSave
             WITH FRAME {&FRAME-NAME}.
      APPLY "ENTRY":U TO fiComboName.
      RETURN "NO-EXIT":U.
    END.
  END.
  
  IF fiComboTemplate <> "":U AND
     fiComboName      = "":U THEN DO:
    IF gcBaseQuery           <> gcLBaseQueryString     OR
       fiFieldLabel          <> gcLFieldLabel          OR
       fiFieldToolTip        <> gcLFieldTooltip        OR
       fiParentField         <> gcLParentField         OR
       edParentFilterQuery   <> gcLParentFilterQuery   OR
       edDisplayedFields     <> gcLDisplayedFields     OR
       coKeyField            <> gcLKeyField            OR
       fiDescSubstitute      <> gcLDescSubstitute      OR
       raFlag                <> gcLComboFlag           OR
       fiInnerLines          <> giLInnerLines          OR
       fiDefaultValue        <> gcLFlagValue THEN DO:
       
      RUN askQuestion IN gshSessionManager (INPUT        "This combo's properties is now different to the properties inherited from it's template.~nDo you want to make this combo a new SmartObject?",    /* message to display */
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
               fiComboName
               edObjectDescription
               buSave buCancelSave
               WITH FRAME {&FRAME-NAME}.
        APPLY "ENTRY":U TO fiComboName.
        RETURN "NO-EXIT":U.
      END.
      ELSE DO:
        RUN askQuestion IN gshSessionManager (INPUT        "Do you want to detach this combo from the template?",    /* message to display */
                                              INPUT        "&YES,&NO,&Cancel":U,    /* button list */
                                              INPUT        "&YES":U,           /* default button */ 
                                              INPUT        "&Cancel":U,       /* cancel button */
                                              INPUT        "Detach combo from Template":U,             /* window title */
                                              INPUT        "":U,      /* data type of question */ 
                                              INPUT        "":U,          /* format mask for question */ 
                                              INPUT-OUTPUT cAnswer,              /* character value of answer to question */ 
                                                    OUTPUT cButton           /* button pressed */
                                              ).
        IF cButton = "&YES":U THEN DO:
          ASSIGN fiComboTemplate:SCREEN-VALUE    = "":U
                 edObjectDescription:SCREEN-VALUE = "":U.
          ASSIGN fiComboTemplate
                 edObjectDescription.
        END.
      END.
    END.
  END.
  /* If lookup name specified - save any new changes made */
  IF fiComboName <> "":U THEN
    RUN setSmartObjectDetails (INPUT fiComboName).

  IF RETURN-VALUE <> "":U THEN
    RETURN.

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
  Parameters:  pcComboName - Name of the lookup template, or actual Lookup SmartObject
               pcType       - Template if pcComboName contains the name of the
                              lookup's template.
                              SmartObject if pcComboName contains the actual 
                              lookup's SmartObject name.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcComboName   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcType        AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cButton AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAnswer AS CHARACTER  NO-UNDO.
  
  IF pcComboName = "":U THEN
    RETURN.
    
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN edDisplayedFields
           fiDescSubstitute
           coKeyField.
    ASSIGN raFlag.
  END.
  
  RUN getSmartObjectDetails (INPUT pcComboName).

  IF gcBaseQuery           <> gcLBaseQueryString     OR
     fiFieldLabel          <> gcLFieldLabel          OR
     fiFieldToolTip        <> gcLFieldTooltip        OR
     fiParentField         <> gcLParentField         OR
     edParentFilterQuery   <> gcLParentFilterQuery   OR
     edDisplayedFields     <> gcLDisplayedFields     OR
     coKeyField            <> gcLKeyField            OR
     fiDescSubstitute      <> gcLDescSubstitute      OR
     raFlag                <> gcLComboFlag           OR
     fiInnerLines          <> giLInnerLines          OR
     fiDefaultValue        <> gcLFlagValue THEN DO:
     
    RUN askQuestion IN gshSessionManager (INPUT        "The " + pcType + "'s properties has changed, do you want to apply these changes to this combo?",    /* message to display */
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
      RUN applySOValues (INPUT pcComboName).
    ELSE
      IF pcType = "Template":U THEN
        fiComboTemplate:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U.
      ELSE 
        ASSIGN fiComboName:SCREEN-VALUE IN FRAME {&FRAME-NAME}         = "":U
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
  DISPLAY fiInnerLines coProduct coProductModule fiComboTemplate fiComboName 
          edObjectDescription EdQuery fiQueryTables coKeyField fiWidth fiColumn 
          fiExternalField EdDisplayedFields fiHeight fiFieldDatatype fiRow 
          fiDescSubstitute fiBuildSeq fiFieldLabel fiFieldToolTip raFlag 
          fiDefaultValue fiParentField EdParentFilterQuery edHelp 
      WITH FRAME frmAttributes.
  ENABLE fiInnerLines buClear fiComboTemplate buLookup buQuery EdQuery BrBrowse 
         coKeyField fiWidth fiColumn EdDisplayedFields fiHeight fiRow 
         fiBuildSeq fiFieldLabel fiFieldToolTip raFlag fiParentField 
         EdParentFilterQuery edHelp buOK buCancel 
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
      .
    DISPLAY
      edQuery
      fiExternalField 
      .

    ASSIGN
      fiFieldLabel          = DYNAMIC-FUNCTION('getFieldLabel':U        IN p_hSMO)
      gcFieldLabel          = fiFieldLabel
      fiFieldToolTip        = DYNAMIC-FUNCTION('getFieldTooltip':U      IN p_hSMO)
      fiComboTemplate       = DYNAMIC-FUNCTION('getSDFTemplate':U       IN p_hSMO)
      fiComboName           = DYNAMIC-FUNCTION('getSDFFileName':U       IN p_hSMO)
      fiParentField         = DYNAMIC-FUNCTION('getParentField':U       IN p_hSMO)
      edParentFilterQuery   = DYNAMIC-FUNCTION('getParentFilterQuery':U IN p_hSMO)
      edDisplayedFields     = DYNAMIC-FUNCTION('getDisplayedField':U    IN p_hSMO)
      fiDescSubstitute      = DYNAMIC-FUNCTION('getDescSubstitute':U    IN p_hSMO)
      raFlag                = DYNAMIC-FUNCTION('getComboFlag':U         IN p_hSMO)
      hFrame                = DYNAMIC-FUNCTION("getContainerHandle":U   IN p_hSMO)
      fiDefaultValue        = DYNAMIC-FUNCTION('getFlagValue':U         IN p_hSMO)
      fiInnerLines          = DYNAMIC-FUNCTION('getInnerLines':U       IN p_hSMO)
      fiBuildSeq            = DYNAMIC-FUNCTION('getBuildSequence':U     IN p_hSMO)
      gcBrowseFields        = edDisplayedFields
      fiColumn              = hFrame:COL
      fiRow                 = hFrame:ROW
      fiWidth               = hFrame:WIDTH
      fiHeight              = hFrame:HEIGHT
      .

    IF fiFieldToolTip = "":U THEN
      ASSIGN fiFieldToolTip = "Select option from list".
    
    APPLY "CHOOSE":U TO buQuery.
    
    IF fiBuildSeq = ? THEN
      fiBuildSeq = 1.
   
    IF fiInnerLines = ? OR
       fiInnerLines = 0 THEN
      fiInnerLines = 5.
    
    DISPLAY
      fiFieldLabel 
      fiFieldToolTip 
      fiRow 
      fiColumn 
      fiHeight 
      fiWidth 
      fiComboTemplate
      fiComboName    
      fiParentField        
      edParentFilterQuery
      edDisplayedFields
      fiDescSubstitute 
      raFlag
      fiDefaultValue
      fiInnerLines
      fiBuildSeq.
    
    APPLY "VALUE-CHANGED":U TO raFlag.
    APPLY "LEAVE":U TO BrBrowse.
    
    IF fiComboName <> "":U THEN
      RUN checkScrTemplate (INPUT fiComboName,
                            INPUT "SmartObject":U).
    ELSE 
      RUN checkScrTemplate (INPUT fiComboTemplate,
                            INPUT "Template":U).
    ASSIGN edObjectDescription:SCREEN-VALUE  = IF fiComboName:SCREEN-VALUE <> "":U THEN gcLObjectDescription ELSE "".
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
  
  DEFINE VARIABLE cButton AS CHARACTER  NO-UNDO.
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
                                           INPUT  "Combo Field Object Not Found":U,             /* error window title */
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
          gcLDisplayedFields = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager, INPUT ryc_attribute_value.attribute_type_TLA, INPUT ryc_attribute_value.attribute_value).
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
      END CASE.
    END.
  END.

  RETURN. 
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
  DEFINE VARIABLE dContainer      AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dContainerType  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cObjectLayout   AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cButton AS CHARACTER  NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN coProduct
           coProductModule
           fiFieldFormat
           fiExternalField
           .
  END.
  
  /* create / update gsc_object and ryc_smartobject records */
  RUN updateDynamicObject (INPUT "combo":U,
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
    /* Update attribute values */
    RUN updateAttributeValues (INPUT dContainerType,
                               INPUT dContainer,
                               INPUT 0,
                               INPUT 0,
                               INPUT 'SDFFileName,SDFTemplate,DisplayedField,KeyField,FieldLabel,FieldTooltip,DisplayFormat,DisplayDataType,KeyFormat,KeyDataType,BaseQueryString,QueryTables,ParentField,ParentFilterQuery,MasterFile,VisualizationType,Width-Chars,Height-Chars,Column,Row,ComboFlag,DescSubstitute,InnerLines,FlagValue,BuildSequence,EnableField,HideOnInit,DisableOnInit,ObjectLayout,FieldName',
                               INPUT fiComboName + CHR(3) + fiComboTemplate + CHR(3) + edDisplayedFields + CHR(3) + coKeyField + CHR(3) + fiFieldLabel + CHR(3) + fiFieldToolTip + CHR(3) + gcLDisplayFormat + CHR(3) + gcLKeyDataType + CHR(3) + fiFieldFormat + CHR(3) + gcLDisplayDatatype + CHR(3) + EdQuery + CHR(3) + fiQueryTables + CHR(3) + fiParentField + CHR(3) + edParentFilterQuery + CHR(3) + "adm2/dyncombo.w" + CHR(3) + "SmartDataField":U + CHR(3) + STRING(fiWidth) + CHR(3) + STRING(fiHeight) + CHR(3) + STRING(fiColumn) + CHR(3) + STRING(fiRow) + CHR(3) + raFlag + CHR(3) + fiDescSubstitute + CHR(3) + STRING(fiInnerLines) + CHR(3) + fiDefaultValue + CHR(3) + STRING(fiBuildSeq) + CHR(3) + STRING(YES) + CHR(3) + STRING(NO) + CHR(3) + STRING(NO) + CHR(3) + cObjectLayout + CHR(3) + fiExternalField).
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
    ASSIGN fiComboName:SCREEN-VALUE = "":U
           edObjectDescription:SCREEN-VALUE = "":U.
    RETURN cErrorText.
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
  WHEN "Combo":U THEN  /* Dynamic Combo */
  DO:
    ASSIGN
      lContainer = YES
      cPhysicalObject = "dyncombo.w":U
      cObjectType = "dyncombo":U
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

DEFINE VARIABLE cButton                     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAllFields                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAllNames                   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cField                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cName                       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.

DEFINE VARIABLE dDate                       AS DATE       NO-UNDO.
DEFINE VARIABLE dDecimal                    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE iInteger                    AS INTEGER    NO-UNDO.

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

  IF edDisplayedFields = "":U THEN
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
  
  IF NUM-ENTRIES(edDisplayedFields) <> numOccurance(fiDescSubstitute,"&":U) THEN DO:
    MESSAGE "The number of fields to display does not match the field substitution entries."
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    ASSIGN plOK = NO.
    RETURN.
  END.

  /* Check for valid data types in the default value */
  IF fiDefaultValue <> "":U THEN DO:
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
  IF fiInnerLines = ? OR 
     fiInnerLines <= 0 THEN DO:
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
  
  /* Check that the parent filter query is valid */
  IF edParentFilterQuery <> "":U THEN DO:
    IF INDEX(edParentFilterQuery,"FOR ":U)   <> 0 OR
       INDEX(edParentFilterQuery,"EACH ":U)  <> 0 OR 
       INDEX(edParentFilterQuery,"WHERE ":U)  <> 0 OR 
       INDEX(edParentFilterQuery,"FIRST ":U) <> 0 OR
       INDEX(edParentFilterQuery,"LAST ":U)  <> 0 OR
       INDEX(edParentFilterQuery,"BREAK ":U) <> 0 /*OR 
       INDEX(edParentFilterQuery,",":U) <> 0*/ THEN DO:
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

