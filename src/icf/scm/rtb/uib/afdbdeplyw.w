&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          rtb              PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
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

  File: afdbdeplyw.w

  Description: To dump selected static / transaction data into deployment 
               package directory.

  Input Parameters: input directory to dump data files into
                    input deployment directory
                    input site code
                    input license type
                    input deployment number
                    output error text if any

  Output Parameters:
      <none>

  Author: 

  Created: December 2000

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

/* Astra object identifying preprocessor */
&glob   AstraProcedure    yes

{af/sup2/afglobals.i}

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER pcDumpDirectory        AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER pcDeployDirectory      AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER pcSite                 AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER pcLicense              AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER piDeploymentSeq        AS INTEGER      NO-UNDO.
DEFINE OUTPUT PARAMETER pcErrorText           AS CHARACTER    NO-UNDO.

ASSIGN        
  pcDumpDirectory = LC( TRIM( REPLACE(pcDumpDirectory,"~\":U,"~/":U) ,"~/":U ) )
  pcErrorText = "":U
  .

/* Local Variable Definitions ---                                       */

DEFINE STREAM sMain.
DEFINE STREAM sOut1.

DEFINE TEMP-TABLE ttDumptables
       FIELD cLDBName           AS CHARACTER FORMAT "X(10)":U
       FIELD cTableName         AS CHARACTER FORMAT "X(50)":U
       FIELD lTableIncluded     AS LOGICAL
       INDEX idxMain            IS PRIMARY UNIQUE
              cLDBName
              cTableName
       INDEX idxProcess
              cLDBName
              lTableIncluded
       .

DEFINE VARIABLE glDone AS LOGICAL INITIAL NO NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrBrowse

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttDumptables

/* Definitions for BROWSE BrBrowse                                      */
&Scoped-define FIELDS-IN-QUERY-BrBrowse ttDumptables.cTableName ttDumptables.cLDBName   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrBrowse   
&Scoped-define SELF-NAME BrBrowse
&Scoped-define OPEN-QUERY-BrBrowse OPEN QUERY {&SELF-NAME} FOR EACH ttDumptables                             WHERE ttDumptables.cLDBName   = (IF coSelection = "<SELECTED>":U THEN ttDumptables.cLDBName ELSE coSelection)                             AND   ttDumptables.lTableIncluded  = (IF coSelection = "<SELECTED>":U THEN YES ELSE ttDumptables.lTableIncluded)                             .
&Scoped-define TABLES-IN-QUERY-BrBrowse ttDumptables
&Scoped-define FIRST-TABLE-IN-QUERY-BrBrowse ttDumptables


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buDefault coSelection BrBrowse buAllSelect ~
buOneSelect buDeselect buAllDeselect buCommit buOK buCancel 
&Scoped-Define DISPLAYED-OBJECTS coSelection 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAKFields C-Win 
FUNCTION getAKFields RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buAllDeselect DEFAULT 
     LABEL "Deselect All" 
     SIZE 14.4 BY 1.14 TOOLTIP "Deselect all tables currently shown - must press commit to action"
     BGCOLOR 8 .

DEFINE BUTTON buAllSelect DEFAULT 
     LABEL "Select All" 
     SIZE 14.4 BY 1.14 TOOLTIP "Select all tables currently shown - must press commit to action"
     BGCOLOR 8 .

DEFINE BUTTON buCancel AUTO-END-KEY DEFAULT 
     LABEL "&Cancel" 
     SIZE 18.4 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buCommit DEFAULT 
     LABEL "Commit Selection" 
     SIZE 18.4 BY 1.14 TOOLTIP "Update selected tables list with current selected tables"
     BGCOLOR 8 .

DEFINE BUTTON buDefault 
     LABEL "Default" 
     SIZE 15 BY 1.14 TOOLTIP "Revert back to default tables to dump"
     BGCOLOR 8 .

DEFINE BUTTON buDeselect DEFAULT 
     LABEL "Deselect" 
     SIZE 14.4 BY 1.14 TOOLTIP "Deselect current table - must press commit to action"
     BGCOLOR 8 .

DEFINE BUTTON buOK DEFAULT 
     LABEL "&Deploy Data for Selected Tables" 
     SIZE 62 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buOneSelect DEFAULT 
     LABEL "Select" 
     SIZE 14.4 BY 1.14 TOOLTIP "Select current table only - must press commit to action"
     BGCOLOR 8 .

DEFINE VARIABLE coSelection AS CHARACTER FORMAT "X(256)":U 
     LABEL "Show Tables From" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 8
     DROP-DOWN-LIST
     SIZE 43.6 BY 1
     BGCOLOR 15  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrBrowse FOR 
      ttDumptables SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrBrowse C-Win _FREEFORM
  QUERY BrBrowse NO-LOCK DISPLAY
      ttDumptables.cTableName COLUMN-LABEL "Table Name":U
      ttDumptables.cLDBName   COLUMN-LABEL "Logical DB Name":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 82.4 BY 15.81 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     buDefault AT ROW 1.48 COL 72.2
     coSelection AT ROW 1.57 COL 5
     BrBrowse AT ROW 2.91 COL 5
     buAllSelect AT ROW 19.1 COL 5
     buOneSelect AT ROW 19.1 COL 21
     buDeselect AT ROW 19.1 COL 37
     buAllDeselect AT ROW 19.1 COL 53
     buCommit AT ROW 19.1 COL 69
     buOK AT ROW 20.52 COL 6.2
     buCancel AT ROW 20.52 COL 69
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 21.43
         DEFAULT-BUTTON buOK CANCEL-BUTTON buCancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Dynamics Deploy Static Data"
         HEIGHT             = 21.43
         WIDTH              = 90
         MAX-HEIGHT         = 24.14
         MAX-WIDTH          = 141.8
         VIRTUAL-HEIGHT     = 24.14
         VIRTUAL-WIDTH      = 141.8
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* BROWSE-TAB BrBrowse coSelection DEFAULT-FRAME */
ASSIGN 
       BrBrowse:COLUMN-RESIZABLE IN FRAME DEFAULT-FRAME       = TRUE.

/* SETTINGS FOR COMBO-BOX coSelection IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrBrowse
/* Query rebuild information for BROWSE BrBrowse
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttDumptables
                            WHERE ttDumptables.cLDBName   = (IF coSelection = "<SELECTED>":U THEN ttDumptables.cLDBName ELSE coSelection)
                            AND   ttDumptables.lTableIncluded  = (IF coSelection = "<SELECTED>":U THEN YES ELSE ttDumptables.lTableIncluded)
                            .
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is NOT OPENED
*/  /* BROWSE BrBrowse */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* ICF Deploy Static Data */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* ICF Deploy Static Data */
DO:

    /* This event will close the window and terminate the procedure.  */
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buAllDeselect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAllDeselect C-Win
ON CHOOSE OF buAllDeselect IN FRAME DEFAULT-FRAME /* Deselect All */
DO:

    RUN rowsAllDeselect.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buAllSelect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAllSelect C-Win
ON CHOOSE OF buAllSelect IN FRAME DEFAULT-FRAME /* Select All */
DO:

    RUN rowsAllSelect.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCancel C-Win
ON CHOOSE OF buCancel IN FRAME DEFAULT-FRAME /* Cancel */
DO:

  IF NOT glDone THEN
  DO:
    MESSAGE "You have elected not to include any static data as part of" SKIP
            "this deployment package. Normally you should always send" SKIP
            "at least the default tables that were initially highlighted" SKIP
            "in this program." SKIP(1)
            "Continue with Cancel" SKIP
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            UPDATE lChoice AS LOGICAL.
    IF lChoice = NO THEN RETURN NO-APPLY.
    ELSE ASSIGN pcErrorText = "Cancelled":U.
  END.

  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCommit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCommit C-Win
ON CHOOSE OF buCommit IN FRAME DEFAULT-FRAME /* Commit Selection */
DO:

    RUN rowsCommit.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDefault
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDefault C-Win
ON CHOOSE OF buDefault IN FRAME DEFAULT-FRAME /* Default */
DO:
    EMPTY TEMP-TABLE ttDumptables.
    RUN assignDumptables.

    ASSIGN
      coSelection:SCREEN-VALUE = "<SELECTED>":U.
    APPLY "VALUE-CHANGED":u TO coSelection.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDeselect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDeselect C-Win
ON CHOOSE OF buDeselect IN FRAME DEFAULT-FRAME /* Deselect */
DO:

    RUN rowsOneDeselect.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOK C-Win
ON CHOOSE OF buOK IN FRAME DEFAULT-FRAME /* Deploy Data for Selected Tables */
DO:

  ASSIGN
    coSelection:SCREEN-VALUE = "<SELECTED>":U.
  APPLY "VALUE-CHANGED":u TO coSelection.

  MESSAGE
      SKIP "Do you want to deploy the data for the selected tables shown" SKIP
           "into directory: " pcDumpDirectory SKIP(1)
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      UPDATE lChoice AS LOGICAL.
  IF lChoice = YES
  THEN
      RUN deployData.
  ELSE
    RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOneSelect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOneSelect C-Win
ON CHOOSE OF buOneSelect IN FRAME DEFAULT-FRAME /* Select */
DO:

    RUN rowsOneSelect.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coSelection
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coSelection C-Win
ON VALUE-CHANGED OF coSelection IN FRAME DEFAULT-FRAME /* Show Tables From */
DO:

    ASSIGN coSelection.  
    RUN reopenSelected.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrBrowse
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN
    CURRENT-WINDOW                = {&WINDOW-NAME} 
    THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

RUN mainSetup.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    RUN enable_UI.

    APPLY "VALUE-CHANGED" TO coSelection.

    IF NOT THIS-PROCEDURE:PERSISTENT
    THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignDumpAll C-Win 
PROCEDURE assignDumpAll :
/*------------------------------------------------------------------------------
  Purpose:     Populates the ttFileField table with data from the _file and _field tables.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER cDBName  AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE cQuery          AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE cWidgetPool     AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hQuery          AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hBufferTable    AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hField          AS HANDLE       NO-UNDO.

    ASSIGN
        cWidgetPool = "lWidgets"
        cQuery      = 'FOR EACH '   + TRIM(cDBName) + '._file NO-LOCK '
                    + ' WHERE NOT ' + TRIM(cDBName) + '._file._file-name BEGINS "_" '
                    + ' AND '       + TRIM(cDBName) + '._file._file-number > 0'
                    + ' AND '       + TRIM(cDBName) + '._file._file-number < 32768 '
        .

    CREATE WIDGET-POOL cWidgetPool.
    CREATE QUERY hQuery IN WIDGET-POOL cWidgetPool.

    /* Create the buffers for the tables */
    CREATE BUFFER hBufferTable
           FOR TABLE      TRIM(cDBName) + "._file":U
           BUFFER-NAME    "_file":U
           IN WIDGET-POOL cWidgetPool.

    IF NOT hQuery:ADD-BUFFER(hBufferTable)
    THEN DO:
        DELETE WIDGET-POOL cWidgetPool.
        RETURN "Error setting buffers for dynamic query".
    END.

    IF NOT hQuery:QUERY-PREPARE(cQuery)
    THEN DO:
        DELETE WIDGET-POOL cWidgetPool.
        RETURN "Error preparing dynamic query".
    END.

    IF NOT hQuery:QUERY-OPEN
    THEN DO:
        DELETE WIDGET-POOL cWidgetPool.
        RETURN "Error opening dynamic query".
    END.

    IF NOT hQuery:REPOSITION-TO-ROW(1)
    THEN DO:
        DELETE WIDGET-POOL cWidgetPool.
        RETURN "Error re-positioning dynamic query".
    END.

    /* Retrieve the Field Values */
    REPEAT:

        IF NOT hQuery:GET-NEXT
        THEN LEAVE.

        ASSIGN
            hField = hBufferTable:BUFFER-FIELD("_file-name":U)
            .

        RUN createDumptables (hBufferTable:DBNAME,"EXC":U,hField:STRING-VALUE).

    END.

    /* Release the Buffers for the tables */
    hBufferTable:BUFFER-RELEASE.
    DELETE OBJECT hBufferTable.

    hQuery:QUERY-CLOSE.
    DELETE OBJECT hQuery.
    DELETE WIDGET-POOL cWidgetPool.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignDumpDefaults C-Win 
PROCEDURE assignDumpDefaults :
/*------------------------------------------------------------------------------
  Purpose:     Default data dumps for data that always should be deployed as
               part of the deployment package.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF CONNECTED("ICFDB":U) THEN
DO:
    RUN createDumptables ("icfdb":U,"INC":U,"gsc_entity_mnemonic":U).
    RUN createDumptables ("icfdb":U,"INC":U,"gsc_error":U).
    RUN createDumptables ("icfdb":U,"INC":U,"gsc_instance_attribute":U).
    RUN createDumptables ("icfdb":U,"INC":U,"gsc_object":U).
    RUN createDumptables ("icfdb":U,"INC":U,"gsc_object_type":U).
    RUN createDumptables ("icfdb":U,"INC":U,"gsc_product":U).
    RUN createDumptables ("icfdb":U,"INC":U,"gsc_product_module":U).
    RUN createDumptables ("icfdb":U,"INC":U,"gsm_help":U).
    RUN createDumptables ("icfdb":U,"INC":U,"gsm_menu_item":U).
    RUN createDumptables ("icfdb":U,"INC":U,"gsm_menu_structure":U).
    RUN createDumptables ("icfdb":U,"INC":U,"gsm_object_menu_structure":U).
    RUN createDumptables ("icfdb":U,"INC":U,"gsm_reporting_tool":U).
    RUN createDumptables ("icfdb":U,"INC":U,"gsm_report_definition":U).
    RUN createDumptables ("icfdb":U,"INC":U,"gsm_report_format":U).
    RUN createDumptables ("icfdb":U,"INC":U,"gsm_site":U).

    RUN createDumptables ("icfdb":U,"INC":U,"gsc_profile_type":U).
    RUN createDumptables ("icfdb":U,"INC":U,"gsc_profile_code":U).

    IF pcLicense = "P":U THEN
    DO:
      RUN createDumptables ("icfdb":U,"INC":U,"rvm_task":U).
      RUN createDumptables ("icfdb":U,"INC":U,"rvm_task_history":U).
      RUN createDumptables ("icfdb":U,"INC":U,"rvm_task_object":U).
    END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignDumpTables C-Win 
PROCEDURE assignDumpTables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:    
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iLoop   AS INTEGER      NO-UNDO.

    RUN assignDumpDefaults.

    IF NUM-DBS > 0
    THEN DO iLoop = 1 TO NUM-DBS:
        RUN assignDumpAll( LC(LDBNAME(iLoop)) ).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildcoSelection C-Win 
PROCEDURE buildcoSelection :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iLoop   AS INTEGER      NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN 
            coSelection:LIST-ITEMS = "":U
            .

        IF NUM-DBS > 0
        THEN DO iLoop = 1 TO NUM-DBS:
            coSelection:ADD-LAST( TRIM(LC(LDBNAME(iLoop))) ).
        END.

        coSelection:ADD-FIRST( "<SELECTED>":U).

        IF  coSelection:LIST-ITEMS <> "":U
        AND coSelection:LIST-ITEMS <> ? 
        THEN
            ASSIGN
                coSelection:SCREEN-VALUE = ENTRY(1,coSelection:LIST-ITEMS)
                .

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildDirectoryList C-Win 
PROCEDURE buildDirectoryList :
/*------------------------------------------------------------------------------
  Purpose:     Output a list of Progress files for the specified extensions for the
               passed in directory and all its sub-directories.  
  Parameters:  See below
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  ip_directory    AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  ip_recurse      AS LOGICAL      NO-UNDO.
DEFINE INPUT PARAMETER  ip_extensions   AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER op_file_list    AS CHARACTER    NO-UNDO.

DEFINE VARIABLE         lv_batchfile    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         lv_outputfile   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         lv_filename     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         lv_line_numbers AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         lv_line_texts   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         lv_recurse      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         lv_loop         AS INTEGER      NO-UNDO.

/* Write batch file to do a directory listing of all files in
   the directory tree specified */
ASSIGN
    lv_batchfile  = SESSION:TEMP-DIRECTORY + "dir.bat":U
    lv_outputfile = SESSION:TEMP-DIRECTORY + "dir.log":U
    ip_directory = LC(TRIM(REPLACE(ip_directory,"/":U,"\":U)))
    lv_recurse = (IF ip_recurse = YES THEN "/s ":U ELSE " ":U).

OUTPUT TO VALUE(lv_batchfile).
DO lv_loop = 1 TO NUM-ENTRIES(ip_extensions):
    PUT UNFORMATTED "dir /b/l/on":U +
                    lv_recurse +
                    ip_directory + 
                    "\*.":U +
                    ENTRY(lv_loop, ip_extensions) +
                    (IF lv_loop = 1 THEN " > ":U ELSE " >> ":U) +
                    lv_outputfile
                    SKIP.
END.

OUTPUT CLOSE.

/* Execute batch file */
OS-COMMAND SILENT VALUE(lv_batchfile).

/* Check result */
IF SEARCH(lv_outputfile) <> ? THEN
  DO:
    INPUT STREAM sMain FROM VALUE(lv_outputfile) NO-ECHO.
    REPEAT:
        IMPORT STREAM sMain UNFORMATTED lv_filename.
        IF ip_recurse  = NO THEN ASSIGN lv_filename = ip_directory + "\":U + lv_filename.
        ASSIGN
            op_file_list =  op_file_list +
                            (IF NUM-ENTRIES(op_file_list) > 0 THEN ",":U ELSE "":U) +
                            LC(TRIM(lv_filename)).
    END.
    INPUT STREAM sMain CLOSE.
  END.

/* Delete temp files */
OS-DELETE VALUE(lv_batchfile).
OS-DELETE VALUE(lv_outputfile). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createDumptables C-Win 
PROCEDURE createDumptables :
/*------------------------------------------------------------------------------
  Purpose:     To add a table to the list of selected tables
  Parameters:  input logical dbname for table
               input selected flag (INC/EXC)
               input table name (no db prefix)
  Notes:    
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pcDBName      AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pcTableSelect AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pcTableName   AS CHARACTER    NO-UNDO.

    FIND FIRST ttDumptables EXCLUSIVE-LOCK
        WHERE ttDumptables.cLDBName     = pcDBName
        AND   ttDumptables.cTableName   = pcTableName
        NO-ERROR.
    IF NOT AVAILABLE ttDumptables
    THEN DO:
        CREATE ttDumptables.
        ASSIGN
            ttDumptables.cLDBName     = pcDBName
            ttDumptables.cTableName   = pcTableName
            ttDumptables.lTableIncluded    = (IF pcTableSelect = "INC":U THEN YES ELSE NO)
            .
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deployData C-Win 
PROCEDURE deployData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       

------------------------------------------------------------------------------*/

    DEFINE VARIABLE cErrorValue   AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cSite         AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cDeleteFiles  AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cFileName     AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE iLoop         AS INTEGER      NO-UNDO.

    ASSIGN
        cSite = "":U.

    SESSION:SET-WAIT-STATE("GENERAL":U).

    /* First delete existing files in deployment directory */
    RUN buildDirectoryList (INPUT pcDumpDirectory,
                            INPUT NO,
                            INPUT "d":U,
                            OUTPUT cDeleteFiles).
    DO iLoop = 1 TO NUM-ENTRIES(cDeleteFiles):
      ASSIGN cFileName = ENTRY(iLoop,cDeleteFiles).
      OS-DELETE VALUE(cFileName).
    END.

    /* Output program header info */    
    OUTPUT STREAM sOut1 TO VALUE (pcDumpDirectory + "/":U + "icfstaticload.p":U).
    PUT STREAM sOut1 UNFORMATTED "/* Static Data for Deployment Site: " pcSite + "          */":U SKIP.
    PUT STREAM sOut1 UNFORMATTED "/* Static Data for Deployment No. : " STRING(piDeploymentSeq) + "        */":U SKIP.
    PUT STREAM sOut1 UNFORMATTED "/* Generated Date and Time   : " STRING(TODAY) + " Time: " + STRING(TIME,"hh:mm":U) + "        */":U SKIP(1).
    PUT STREAM sOut1 UNFORMATTED "DEFINE STREAM sImport." SKIP.
    PUT STREAM sOut1 UNFORMATTED "DEFINE STREAM sOut1." SKIP.
    PUT STREAM sOut1 UNFORMATTED "DEFINE VARIABLE cFullFile AS CHARACTER NO-UNDO." SKIP.
    PUT STREAM sOut1 UNFORMATTED "DEFINE VARIABLE dObj      AS INTEGER   NO-UNDO." SKIP(1).

    /* dump tables and build import program */
    FOR EACH ttDumptables NO-LOCK
        WHERE ttDumptables.lTableIncluded = TRUE
        :

      RUN dumpTable (INPUT ttDumptables.cTableName,
                     INPUT pcDumpDirectory,
                     INPUT pcSite,
                     INPUT "":U).

    END.
    SESSION:SET-WAIT-STATE("":U).

    OUTPUT STREAM sOut1 CLOSE.
    COMPILE VALUE(pcDumpDirectory + "/":U + "icfstaticload.p":U) SAVE.

    ASSIGN
        buCancel:LABEL IN FRAME {&FRAME-NAME} = "Close":U
        glDone = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dumpTable C-Win 
PROCEDURE dumpTable :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to dump the contents of a table to a flat file in a 
               format supported by the EXPORT/IMPORT statements.
  Parameters:  input table name (no db prefix required)
               input dump directory (full path with no / on end)
               input site code if you wish to check site specific data or else blank
               input fieldname (no table prefix) of reference field to check in site specific
                     data. If none passed in, will work out best guess field or leave
                     blank if no site code passed in.
  Notes:       Assumes dumped tables will have a unique primary index and that the
               tables in the primary index will not change.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcTable          AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcDirectory      AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcSite           AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcRefField       AS CHARACTER  NO-UNDO.

pcTable = TRIM(pcTable).

DEFINE VARIABLE hQuery1                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE hBuffer1                AS HANDLE     NO-UNDO.
DEFINE VARIABLE hQuery                  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hBuffer                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField                  AS HANDLE     NO-UNDO.
DEFINE VARIABLE iLoop                   AS INTEGER    NO-UNDO.
DEFINE VARIABLE iNumRecs                AS INTEGER    NO-UNDO.
DEFINE VARIABLE lOk                     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lFirst                  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cExport                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDumpName               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSchema                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hRefField               AS HANDLE     NO-UNDO.
DEFINE VARIABLE lSiteData               AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cDumpFile               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cField                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjField               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cWhere                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cWhere2                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cIndexFields            AS CHARACTER  NO-UNDO.

/* Get index fields and build a where clause */
ASSIGN cIndexFields = getAKFields(INPUT pcTable).

/* Create buffer for passed in table */
CREATE BUFFER hBuffer FOR TABLE pcTable NO-ERROR.

/* IF cIndexFields = "":U THEN                            */
/*   cIndexFields = getPrimaryIndexFields(INPUT pcTable). */
ASSIGN
  cWhere = "":U
  cWhere2 = "":U.
IF cIndexFields <> "":U THEN
DO:
  ASSIGN cWhere = "  WHERE ":U.
  DO iLoop = 1 TO NUM-ENTRIES(cIndexFields):
    ASSIGN
      cField = TRIM(ENTRY(iLoop, cIndexFields))
      cWhere = cWhere + (IF iLoop = 1 THEN "":U ELSE " AND ":U)
               + pcTable + ".":U + cField + " = ":U
               + "tt":U + pcTable + ".":U + cField
      .
  END.
END.
ASSIGN
  cDumpName = DYNAMIC-FUNCTION("getTableDumpName" IN gshGenManager, 
                               INPUT hBuffer:DBNAME + "|":U + pcTable)
  cObjField = DYNAMIC-FUNCTION("getObjField" IN gshGenManager, INPUT cDumpName)
  cWhere2 = "  WHERE ":U + pcTable + ".":U + cObjField + " = ":U
            + "tt":U + pcTable + ".":U + cObjField  
  .

/* get dump name for table from metaschema */
ASSIGN cSchema = hBuffer:DBNAME + "._file":U.

CREATE BUFFER hBuffer1 FOR TABLE cSchema NO-ERROR.
CREATE QUERY hQuery1 NO-ERROR.
lOk = hQuery1:SET-BUFFERS(hBuffer1).
lOk = hQuery1:QUERY-PREPARE("FOR EACH ":U + cSchema + " NO-LOCK WHERE ":U + cSchema + "._file-name BEGINS '":U + pcTable + "'":U).
hQuery1:QUERY-OPEN() NO-ERROR.
hQuery1:GET-FIRST() NO-ERROR.

IF VALID-HANDLE(hBuffer1) AND hBuffer1:AVAILABLE THEN
ASSIGN
  hField  = hBuffer1:BUFFER-FIELD("_dump-name":U)
  cDumpName = hField:BUFFER-VALUE
  .
hQuery1:QUERY-CLOSE() NO-ERROR.

IF cDumpName = "":U THEN ASSIGN cDumpName = pcTable.

/* Dump data from table using dynamic query */
CREATE QUERY hQuery NO-ERROR.
lOk = hQuery:SET-BUFFERS(hBuffer).
lOk = hQuery:QUERY-PREPARE("FOR EACH ":U + pcTable + " NO-LOCK ":U).
hQuery:QUERY-OPEN() NO-ERROR.
hQuery:GET-FIRST() NO-ERROR.

IF VALID-HANDLE(hBuffer) AND hBuffer:AVAILABLE THEN
DO:
  /* If a site passed in, see if any site specific data exists and if so,
     work out reference field - assumes dump name is table FLA
  */
  ASSIGN
    hRefField = ?.

  IF pcSite <> "":U AND CAN-FIND(FIRST gsm_site_specific WHERE gsm_site_specific.entity_mnemonic = cDumpName) THEN
    ASSIGN lSiteData = YES.
  ELSE
    ASSIGN lSiteData = NO.

  IF lSiteData = YES AND pcRefField <> "":U THEN
    hRefField = hBuffer:BUFFER-FIELD(pcRefField) NO-ERROR.

  IF lSiteData = YES AND NOT VALID-HANDLE(hRefField) THEN
  DO iLoop = 1 TO hBuffer:NUM-FIELDS:
    hField = hBuffer:BUFFER-FIELD(iLoop).
    IF INDEX(hField:NAME,"_reference":U) <> 0 THEN
    DO:
      hRefField = hField.
      LEAVE.
    END.
  END.
  IF lSiteData = YES AND NOT VALID-HANDLE(hRefField) THEN
  DO iLoop = 1 TO hBuffer:NUM-FIELDS:
    hField = hBuffer:BUFFER-FIELD(iLoop).
    IF INDEX(hField:NAME,"_code":U) <> 0 THEN
    DO:
      hRefField = hField.
      LEAVE.
    END.
  END.
  IF lSiteData = YES AND NOT VALID-HANDLE(hRefField) THEN
  DO iLoop = 1 TO hBuffer:NUM-FIELDS:
    hField = hBuffer:BUFFER-FIELD(iLoop).
    IF INDEX(hField:NAME,"_tla":U) <> 0 THEN
    DO:
      hRefField = hField.
      LEAVE.
    END.
  END.
  IF lSiteData = YES AND NOT VALID-HANDLE(hRefField) THEN
  DO iLoop = 1 TO hBuffer:NUM-FIELDS:
    hField = hBuffer:BUFFER-FIELD(iLoop).
    IF INDEX(hField:NAME,"_filename":U) <> 0 THEN
    DO:
      hRefField = hField.
      LEAVE.
    END.
  END.
  IF lSiteData = YES AND NOT VALID-HANDLE(hRefField) THEN
  DO iLoop = 1 TO hBuffer:NUM-FIELDS:
    hField = hBuffer:BUFFER-FIELD(iLoop).
    IF INDEX(hField:NAME,"_name":U) <> 0 THEN
    DO:
      hRefField = hField.
      LEAVE.
    END.
  END.
  IF NOT VALID-HANDLE(hRefField) THEN ASSIGN lSiteData = NO.

  OUTPUT STREAM sMain TO VALUE (pcDirectory + "/":U + cDumpName + ".d":U).
  ASSIGN
    lFirst = YES
    iNumRecs = 0
    cDumpFile = pcDirectory + "/":U + cDumpName + ".d":U
    cDumpFile = REPLACE(cDumpFile,pcDeployDirectory + "/":U,"":U).

  query-loop:
  REPEAT:
    IF lFirst THEN
    DO:
      hQuery:GET-FIRST().
      ASSIGN lFirst = NO.
    END.
    ELSE    
      hQuery:GET-NEXT().
    IF hQuery:QUERY-OFF-END THEN LEAVE query-loop.

    /* check site data */
    IF lSiteData = YES THEN
    DO:
      IF CAN-FIND(FIRST gsm_site_specific
                  WHERE gsm_site_specific.entity_mnemonic = cDumpName
                    AND gsm_site_specific.specific_reference = hRefField:BUFFER-VALUE) THEN
      DO:
        /* site data exists for record - check site code and ignore if not valid */      
        IF NOT CAN-FIND(FIRST gsm_site_specific
                        WHERE gsm_site_specific.entity_mnemonic = cDumpName
                          AND gsm_site_specific.specific_reference = hRefField:BUFFER-VALUE
                          AND gsm_site_specific.site_code = pcSite) THEN
          NEXT query-loop.                          
      END.
    END.

    /* got a record - export it */
    ASSIGN
      cExport = "":U
      iNumRecs = iNumRecs + 1.

    REPEAT iLoop = 1 TO hBuffer:NUM-FIELDS:
      hField = hBuffer:BUFFER-FIELD(iLoop).
      ASSIGN cExport = cExport +
                       (IF cExport <> "":U THEN CHR(3) ELSE "":U) +
                         (IF hField:DATA-TYPE = "CHARACTER":U THEN
                          '"':U + (IF hField:BUFFER-VALUE <> ? THEN hField:BUFFER-VALUE ELSE "":U) + '"':U
                        ELSE (IF hField:BUFFER-VALUE <> ? THEN hField:BUFFER-VALUE ELSE "?":U))
                       .
    END.
    IF iNumRecs > 1 THEN PUT STREAM Smain UNFORMATTED SKIP.
    PUT STREAM Smain UNFORMATTED TRIM(REPLACE(cExport,CHR(3)," ":U)).
  END.

  OUTPUT STREAM sMain CLOSE.

  /* Update load program with load statements */
  PUT STREAM sOut1 UNFORMATTED "IF CONNECTED('":U + hBuffer:DBNAME + "') THEN":U SKIP.
  PUT STREAM sOut1 UNFORMATTED "DO:":U SKIP.
  PUT STREAM sOut1 UNFORMATTED "  DISABLE TRIGGERS FOR LOAD OF ":U + pcTable + ".":U SKIP.
  PUT STREAM sOut1 UNFORMATTED "  DEFINE TEMP-TABLE tt":U + pcTable + " NO-UNDO LIKE " + pcTable + ".":U SKIP.
  PUT STREAM sOut1 UNFORMATTED "  ASSIGN cFullFile = SEARCH('":U + cDumpFile + "').":U SKIP.
  PUT STREAM sOut1 UNFORMATTED "  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).":U SKIP.
  PUT STREAM sOut1 UNFORMATTED "  IF cFullFile <> ? THEN":U SKIP.
  PUT STREAM sOut1 UNFORMATTED "  REPEAT:":U SKIP.
  PUT STREAM sOut1 UNFORMATTED "    CREATE tt":U + pcTable + " NO-ERROR.":U SKIP.
  PUT STREAM sOut1 UNFORMATTED "    IMPORT STREAM sImport tt":U + pcTable + " NO-ERROR.":U SKIP.
  PUT STREAM sOut1 UNFORMATTED "    IF tt":U  + pcTable + ".":U + cObjField + " = 0 THEN"  SKIP.
  PUT STREAM sOut1 UNFORMATTED "    DO:":U SKIP.
  PUT STREAM sOut1 UNFORMATTED "      DELETE tt":U + pcTable + " NO-ERROR." SKIP.
  PUT STREAM sOut1 UNFORMATTED "      NEXT.":U SKIP.
  PUT STREAM sOut1 UNFORMATTED "    END.":U SKIP.
  PUT STREAM sOut1 UNFORMATTED "    FIND FIRST ":U + pcTable + " EXCLUSIVE-LOCK":U SKIP.
  PUT STREAM sOut1 UNFORMATTED "         " + cWhere SKIP.
  PUT STREAM sOut1 UNFORMATTED "    NO-ERROR.":U SKIP.
  PUT STREAM sOut1 UNFORMATTED "    IF NOT AVAILABLE ":U + pcTable + " THEN ":U SKIP.
  PUT STREAM sOut1 UNFORMATTED "    FIND FIRST ":U + pcTable + " EXCLUSIVE-LOCK":U SKIP.
  PUT STREAM sOut1 UNFORMATTED "         " + cWhere2 SKIP.
  PUT STREAM sOut1 UNFORMATTED "    NO-ERROR.":U SKIP.
  PUT STREAM sOut1 UNFORMATTED "    IF AVAILABLE ":U + pcTable + " THEN ASSIGN dObj = " + pcTable + ".":U + cObjField + ". ELSE ASSIGN dObj = 0.":U   SKIP.
  PUT STREAM sOut1 UNFORMATTED "    BUFFER-COPY tt":U + pcTable + " TO ":U + pcTable + ".":U SKIP.
  PUT STREAM sOut1 UNFORMATTED "    IF AVAILABLE ":U + pcTable + " AND dObj <> 0 AND dObj <> " + pcTable + ".":U + cObjField + " THEN":U SKIP.
  PUT STREAM sOut1 UNFORMATTED "    DO:":U SKIP.
  PUT STREAM sOut1 UNFORMATTED "      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,'.d':U,'.e':U)) APPEND.":U SKIP.
  PUT STREAM sOut1 UNFORMATTED "      PUT UNFORMATTED STRING(TODAY) + ' ':U + STRING(TIME,'hh:mm':U) + ' old " + pcTable + ".":U + cObjField + " = ' + STRING(dObj) + ' new ":U + pcTable + ".":U + cObjField + " = ' + STRING(" + pcTable + ".":U + cObjField + ")." SKIP.
  PUT STREAM sOut1 UNFORMATTED "      OUTPUT STREAM sOut1 CLOSE.":U SKIP.
  PUT STREAM sOut1 UNFORMATTED "    END.":U SKIP.
  PUT STREAM sOut1 UNFORMATTED "    RELEASE ":U + pcTable + " NO-ERROR." SKIP.
  PUT STREAM sOut1 UNFORMATTED "    DELETE tt":U + pcTable + " NO-ERROR." SKIP.
  PUT STREAM sOut1 UNFORMATTED "  END.":U SKIP.
  PUT STREAM sOut1 UNFORMATTED "  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.":U SKIP.
  PUT STREAM sOut1 UNFORMATTED "END.":U SKIP(1).

END.

/* tidy up */
DELETE OBJECT hQuery1 NO-ERROR.
DELETE OBJECT hBuffer1 NO-ERROR.
hQuery:QUERY-CLOSE() NO-ERROR.
DELETE OBJECT hQuery NO-ERROR.
DELETE OBJECT hBuffer NO-ERROR.
ASSIGN
  hQuery = ?
  hBuffer = ?
  hQuery1 = ?
  hBuffer1 = ?
  .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  DISPLAY coSelection 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE buDefault coSelection BrBrowse buAllSelect buOneSelect buDeselect 
         buAllDeselect buCommit buOK buCancel 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mainSetup C-Win 
PROCEDURE mainSetup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            {&WINDOW-NAME}:TITLE = "Dynamics Deploy Static Data":U.
    END.

    RUN buildcoSelection.

    EMPTY TEMP-TABLE ttDumptables.

    RUN assignDumptables.

    {&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openSelectedRows C-Win 
PROCEDURE openSelectedRows :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lBrwReturn  AS LOGICAL      NO-UNDO.

    DEFINE VARIABLE rDumptable   AS ROWID       NO-UNDO.

    DEFINE BUFFER bttDumptables FOR ttDumptables.

    DO WITH FRAME {&FRAME-NAME}:

        FOR EACH bttDumptables NO-LOCK
            WHERE bttDumptables.cLDBName   = (IF coSelection   = "<SELECTED>":U THEN bttDumptables.cLDBName ELSE coSelection)
            AND   bttDumptables.lTableIncluded  = YES
            :

            /* Position query to this record and then select row in browse. */
            rDumptable = ROWID(bttDumptables).
            REPOSITION {&BROWSE-NAME} TO ROWID rDumptable.
            lBrwReturn = {&BROWSE-NAME}:SELECT-FOCUSED-ROW().

        END. 

        IF {&BROWSE-NAME}:NUM-SELECTED-ROWS > 0
        THEN lBrwReturn = {&BROWSE-NAME}:SCROLL-TO-SELECTED-ROW(1).

    END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reopenSelected C-Win 
PROCEDURE reopenSelected :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {&OPEN-QUERY-{&BROWSE-NAME}}

    RUN openSelectedRows.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowsAllDeselect C-Win 
PROCEDURE rowsAllDeselect :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lBrwReturn  AS LOGICAL      NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:

        lBrwReturn = {&BROWSE-NAME}:DESELECT-ROWS().

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowsAllSelect C-Win 
PROCEDURE rowsAllSelect :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lBrwReturn  AS LOGICAL      NO-UNDO.


    DO WITH FRAME {&FRAME-NAME}:

        lBrwReturn = {&BROWSE-NAME}:SELECT-ALL().

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowsCommit C-Win 
PROCEDURE rowsCommit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lBrwReturn  AS LOGICAL  NO-UNDO.
    DEFINE VARIABLE iLoop       AS INTEGER  NO-UNDO.
    DEFINE BUFFER bttDumptables FOR ttDumptables.

    DO WITH FRAME {&FRAME-NAME}:

        FOR EACH bttDumptables EXCLUSIVE-LOCK
            WHERE bttDumptables.cLDBName   = (IF coSelection   = "<SELECTED>":U THEN bttDumptables.cLDBName ELSE coSelection)
            :
            ASSIGN bttDumptables.lTableIncluded = NO.
        END. 

        DO iLoop = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:

            lBrwReturn = {&BROWSE-NAME}:FETCH-SELECTED-ROW(iLoop).

            GET CURRENT {&BROWSE-NAME} NO-LOCK.
            FIND FIRST bttDumptables EXCLUSIVE-LOCK
                WHERE bttDumptables.cLDBName     = ttDumptables.cLDBName
                AND   bttDumptables.cTableName   = ttDumptables.cTableName
                NO-ERROR.
            IF AVAILABLE bttDumptables
            THEN ASSIGN bttDumptables.lTableIncluded = YES.

        END.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowsOneDeselect C-Win 
PROCEDURE rowsOneDeselect :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lBrwReturn  AS LOGICAL      NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:

        lBrwReturn = {&BROWSE-NAME}:DESELECT-FOCUSED-ROW().

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowsOneSelect C-Win 
PROCEDURE rowsOneSelect :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lBrwReturn  AS LOGICAL      NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:

        lBrwReturn = {&BROWSE-NAME}:SELECT-FOCUSED-ROW().

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAKFields C-Win 
FUNCTION getAKFields RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  To return a comma delimited list of fields in an AK index
            for the passed in table - selecting best index
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cIndexInformation           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cIndexField                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReturnFields               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hKeyBuffer                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.

  DEFINE VARIABLE iUseIndex                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iOneFieldIndex              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iUniqueIndex                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPrimaryIndex               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cObjField                   AS CHARACTER  NO-UNDO.

  pcTable = TRIM(pcTable).
  /* Create buffer for passed in table */
  CREATE BUFFER hKeyBuffer FOR TABLE pcTable NO-ERROR.

  ASSIGN
    iLoop = 0
    iOneFieldIndex = 0
    iUseIndex = 0
    iPrimaryIndex = 0
    iUniqueIndex = 0
    cIndexInformation = "":U
    cReturnFields = "":U.

  find-index-loop:
  REPEAT WHILE cIndexInformation <> ?:
    ASSIGN iLoop             = iLoop + 1
           cIndexInformation = hKeyBuffer:INDEX-INFORMATION(iLoop)
           cObjField         = DYNAMIC-FUNCTION("getObjField" IN gshGenManager,
                                                INPUT hKeyBuffer:DBNAME + "|":U + pcTable).

    /* primary index */
    IF cIndexInformation <> ? AND
       INTEGER(ENTRY(3, cIndexInformation)) = 1 THEN ASSIGN iPrimaryIndex = iLoop. 

    /* single unique field <> table_obj */
    IF cIndexInformation <> ? AND
       INTEGER(ENTRY(2, cIndexInformation)) = 1 AND
       INDEX(cIndexInformation,cObjField + ",":U) = 0 AND
       ((NUM-ENTRIES(cIndexInformation) - 4) / 2) = 1
      THEN ASSIGN iOneFieldIndex = iLoop.

    /* 1st unique index that does not have table_obj in it */
    IF cIndexInformation <> ? AND
       INTEGER(ENTRY(2, cIndexInformation)) = 1 AND
       INDEX(cIndexInformation,cObjField + ",":U) = 0 AND 
       iUniqueIndex = 0 THEN
      ASSIGN iUniqueIndex = iLoop.

  END. /* Find index loop */

  IF iOneFieldIndex > 0 THEN
    ASSIGN iUseIndex = iOneFieldIndex.
  ELSE IF iUniqueIndex > 0 THEN
    ASSIGN iUseIndex = iUniqueIndex.
  ELSE
    ASSIGN iUseIndex = iPrimaryIndex.

  ASSIGN
    cIndexInformation = hKeyBuffer:INDEX-INFORMATION(iUseIndex)
    cReturnFields = "":U.

  DO iLoop = 5 TO NUM-ENTRIES(cIndexInformation) BY 2:
    ASSIGN
      cIndexField = TRIM(ENTRY(iLoop, cIndexInformation))
      .
    IF LOOKUP(cIndexField,cReturnFields) = 0 THEN
      ASSIGN cReturnFields = cReturnFields + (IF cReturnFields <> "":U THEN ",":U ELSE "":U) +
                             cIndexField
      .                                 
  END.

  DELETE OBJECT hKeyBuffer.
  ASSIGN hKeyBuffer = ?.
  RETURN cReturnFields.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

