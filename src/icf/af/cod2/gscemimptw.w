&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          rvdb             PROGRESS
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

  File: gsmemimptw.w

  Description: Entity Mnemonic Import Window
               Allows the user to choose a database and tables from that database
               to import data to create/update entity mnemonic records.

  Input Parameters: 
     <none>

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

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{adeuib/uibhlp.i}          /* Help File Preprocessor Directives         */
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE gdDbList    AS CHARACTER    NO-UNDO.

{afglobals.i NEW GLOBAL}

/* temp table to store the tables to be imported */
DEFINE TEMP-TABLE ttTable
  FIELD cDatabase      AS CHARACTER
  FIELD cTable         AS CHARACTER
  FIELD cDumpName      AS CHARACTER
  FIELD cDescription   AS CHARACTER
  FIELD lImport        AS LOGICAL.

/* temp table to process the importing of table data */
DEFINE TEMP-TABLE ttImport LIKE ttTable.

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
&Scoped-define INTERNAL-TABLES ttTable

/* Definitions for BROWSE BrBrowse                                      */
&Scoped-define FIELDS-IN-QUERY-BrBrowse ttTable.cTable   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrBrowse   
&Scoped-define SELF-NAME BrBrowse
&Scoped-define OPEN-QUERY-BrBrowse OPEN QUERY {&SELF-NAME} FOR EACH ttTable     WHERE ttTable.cDatabase = coDatabase:SCREEN-VALUE.
&Scoped-define TABLES-IN-QUERY-BrBrowse ttTable
&Scoped-define FIRST-TABLE-IN-QUERY-BrBrowse ttTable


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-BrBrowse}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coDatabase BrBrowse buSelectAll buSelectOne ~
buDeSelectOne buDeselectAll fiPrefixLength raAuditing fiSeparator ~
coProductModule ToAuto ToDisplayFields ToDataFields buImport buExit 
&Scoped-Define DISPLAYED-OBJECTS coDatabase fiPrefixLength raAuditing ~
fiSeparator coProductModule ToAuto ToDisplayFields ToDataFields 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buDeselectAll 
     LABEL "Deselect A&ll" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buDeSelectOne 
     LABEL "&Deselect" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buExit 
     LABEL "&Exit" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buImport 
     LABEL "&Import" 
     SIZE 52 BY 1.14 TOOLTIP "Import entities with selected options"
     BGCOLOR 8 .

DEFINE BUTTON buSelectAll 
     LABEL "Select &All" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buSelectOne 
     LABEL "&Select" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE coDatabase AS CHARACTER FORMAT "X(256)":U 
     LABEL "Database" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 62 BY 1 NO-UNDO.

DEFINE VARIABLE coProductModule AS CHARACTER FORMAT "X(256)":U 
     LABEL "Product Module" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE fiPrefixLength AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 4 
     LABEL "Prefix Length" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 TOOLTIP "Table prefix length or 0 for none, default is 4" NO-UNDO.

DEFINE VARIABLE fiSeparator AS CHARACTER FORMAT "X(1)":U INITIAL "_" 
     LABEL "Field Name Separator" 
     VIEW-AS FILL-IN 
     SIZE 4 BY 1 TOOLTIP "Word separation character for field names, default is underscore" NO-UNDO.

DEFINE VARIABLE raAuditing AS CHARACTER INITIAL "I" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Yes", "Y",
"No", "N",
"Ignore", "I"
     SIZE 12 BY 2.57 TOOLTIP "Enable auditing for selected entities" NO-UNDO.

DEFINE VARIABLE ToAuto AS LOGICAL INITIAL yes 
     LABEL "Auto Properform Strings" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.2 BY .81 TOOLTIP "Enable properforming of character strings for selected entities" NO-UNDO.

DEFINE VARIABLE ToDataFields AS LOGICAL INITIAL no 
     LABEL "Generate Data Fields" 
     VIEW-AS TOGGLE-BOX
     SIZE 31.6 BY .81 TOOLTIP "Generate Data Field Objects for each field in Table" NO-UNDO.

DEFINE VARIABLE ToDisplayFields AS LOGICAL INITIAL no 
     LABEL "Update Display Field List" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .81 TOOLTIP "Update lists of fields for entities to display in generic objects" NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrBrowse FOR 
      ttTable SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrBrowse C-Win _FREEFORM
  QUERY BrBrowse DISPLAY
      ttTable.cTable FORMAT 'x(75)':U LABEL 'Table Name':U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 74.8 BY 16.38 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     coDatabase AT ROW 1.29 COL 11.6 COLON-ALIGNED
     BrBrowse AT ROW 2.62 COL 4.6
     buSelectAll AT ROW 19.19 COL 4.6
     buSelectOne AT ROW 19.19 COL 24.6
     buDeSelectOne AT ROW 19.19 COL 44.6
     buDeselectAll AT ROW 19.19 COL 64.6
     fiPrefixLength AT ROW 20.71 COL 22.4 COLON-ALIGNED
     raAuditing AT ROW 20.81 COL 66.6 NO-LABEL
     fiSeparator AT ROW 21.76 COL 22.4 COLON-ALIGNED
     coProductModule AT ROW 22.91 COL 22.4 COLON-ALIGNED
     ToAuto AT ROW 23.95 COL 24.4
     ToDisplayFields AT ROW 24.71 COL 24.4
     ToDataFields AT ROW 25.52 COL 24.4
     buImport AT ROW 26.38 COL 4.6
     buExit AT ROW 26.38 COL 64.6
     "Auditing Enabled:" VIEW-AS TEXT
          SIZE 17.6 BY .76 AT ROW 20.76 COL 48.6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 100.6 BY 26.81.


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
         TITLE              = "Entity Mnemonic Import"
         HEIGHT             = 26.91
         WIDTH              = 81.6
         MAX-HEIGHT         = 26.91
         MAX-WIDTH          = 141.8
         VIRTUAL-HEIGHT     = 26.91
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

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT C-Win:LOAD-ICON("adeicon/icfdev.ico":U) THEN
    MESSAGE "Unable to load icon: adeicon/icfdev.ico"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* BROWSE-TAB BrBrowse coDatabase DEFAULT-FRAME */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrBrowse
/* Query rebuild information for BROWSE BrBrowse
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttTable
    WHERE ttTable.cDatabase = coDatabase:SCREEN-VALUE.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BrBrowse */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Entity Mnemonic Import */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Entity Mnemonic Import */
DO:

    /* This event will close the window and terminate the procedure.  */
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DEFAULT-FRAME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DEFAULT-FRAME C-Win
ON HELP OF FRAME DEFAULT-FRAME
OR HELP OF FRAME {&FRAME-NAME}
DO: 
  /* Help for this Frame */

  RUN adecomm/_adehelp.p
                ("ICADS":U, "CONTEXT":U, {&Entity_Mnemonic_Import_Dialog_Box}  , "":U).


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDeselectAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDeselectAll C-Win
ON CHOOSE OF buDeselectAll IN FRAME DEFAULT-FRAME /* Deselect All */
DO:
    BROWSE {&BROWSE-NAME}:DESELECT-ROWS().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDeSelectOne
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDeSelectOne C-Win
ON CHOOSE OF buDeSelectOne IN FRAME DEFAULT-FRAME /* Deselect */
DO:
  {&BROWSE-NAME}:DESELECT-FOCUSED-ROW().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buExit C-Win
ON CHOOSE OF buExit IN FRAME DEFAULT-FRAME /* Exit */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buImport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buImport C-Win
ON CHOOSE OF buImport IN FRAME DEFAULT-FRAME /* Import */
DO:
  DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cAnswer AS CHARACTER NO-UNDO.

  IF toDataFields:CHECKED AND (coProductModule:SCREEN-VALUE EQ ? OR 
                               coProductModule:SCREEN-VALUE EQ "":U )
     THEN
      RUN showMessages IN gshSessionManager (INPUT "You must specify a Product Module when Generating Data Fields":U,
                                           INPUT "MES":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Data Field Generation",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).
      
     
  ELSE DO:
 
    RUN askQuestion IN gshSessionManager (INPUT "Do you wish to continue and import entity records for the selected tables and options?",    /* messages */
                                          INPUT "&Yes,&No":U,     /* button list */
                                          INPUT "&No":U,         /* default */
                                          INPUT "&No":U,          /* cancel */
                                          INPUT "Continue import":U, /* title */
                                          INPUT "":U,             /* datatype */
                                          INPUT "":U,             /* format */
                                          INPUT-OUTPUT cAnswer,   /* answer */
                                          OUTPUT cButton          /* button pressed */
                                          ).

    IF cButton = "&Yes":U OR cButton = "Yes":U THEN RUN importData.    
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSelectAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSelectAll C-Win
ON CHOOSE OF buSelectAll IN FRAME DEFAULT-FRAME /* Select All */
DO:
  BROWSE {&BROWSE-NAME}:SELECT-ALL().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSelectOne
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSelectOne C-Win
ON CHOOSE OF buSelectOne IN FRAME DEFAULT-FRAME /* Select */
DO:
  {&BROWSE-NAME}:SELECT-FOCUSED-ROW().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coDatabase
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coDatabase C-Win
ON VALUE-CHANGED OF coDatabase IN FRAME DEFAULT-FRAME /* Database */
DO:
  {&OPEN-QUERY-{&BROWSE-NAME}}
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

RUN initializeData.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    RUN enable_UI.

    APPLY "VALUE-CHANGED":U TO coDatabase.

    IF NOT THIS-PROCEDURE:PERSISTENT
    THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
  DISPLAY coDatabase fiPrefixLength raAuditing fiSeparator coProductModule 
          ToAuto ToDisplayFields ToDataFields 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE coDatabase BrBrowse buSelectAll buSelectOne buDeSelectOne 
         buDeselectAll fiPrefixLength raAuditing fiSeparator coProductModule 
         ToAuto ToDisplayFields ToDataFields buImport buExit 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateDataFields C-Win 
PROCEDURE generateDataFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cButton         AS CHARACTER    NO-UNDO.

    FOR EACH ttImport:
        RUN storeTableFields ( INPUT ttImport.cDatabase,
                               INPUT ttImport.cTable,
                               INPUT coProductModule:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

        IF RETURN-VALUE NE "":U THEN
            RUN showMessages IN gshSessionManager ( INPUT RETURN-VALUE,
                                                    INPUT "ERR":U,
                                                    INPUT "OK":U,
                                                    INPUT "OK":U,
                                                    INPUT "OK":U,
                                                    INPUT "Data Field Generation Failure",
                                                    INPUT YES,
                                                    INPUT ?,
                                                    OUTPUT cButton).

    END. /*for each */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importData C-Win 
PROCEDURE importData :
/*------------------------------------------------------------------------------
  Purpose:     Starts the import process on the AppServer
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cButton         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cError          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iNumSelected    AS INTEGER      NO-UNDO.

    SESSION:SET-WAIT-STATE("GENERAL":U).

  /* sets import flag for all selected tables */
  DO WITH FRAME {&FRAME-NAME}:
    DO iNumSelected = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
      {&BROWSE-NAME}:FETCH-SELECTED-ROW(iNumSelected).
      GET CURRENT {&BROWSE-NAME} NO-LOCK.
      ASSIGN ttTable.lImport = YES.
    END.  /* do iNumSelected */
  END.  /* do with with frame */ 

  /* creates import records to be passed to the AppServer for import processing */
  FOR EACH ttTable WHERE ttTable.lImport:
    CREATE ttImport.
    BUFFER-COPY ttTable TO ttImport.
    ASSIGN ttTable.lImport = FALSE.
  END.  /* for each ttTable */

  /* run procedure on the AppServer to create gsc_entity_mnemonic records for 
     the tables included in ttImport */
  
  RUN af/sup2/gscemcrrcp.p ON gshAstraAppServer
    (INPUT toAuto:SCREEN-VALUE,
     INPUT fiPrefixLength:SCREEN-VALUE,
     INPUT fiSeparator:SCREEN-VALUE,
     INPUT raAuditing:SCREEN-VALUE,
     INPUT toDisplayFields:SCREEN-VALUE,
     INPUT TABLE ttImport, 
     OUTPUT cError) NO-ERROR.

  

  /* if toDatafields checked then generate data fields for all the
   * ttImport tables. Do this before we empty the table.
   */
  IF toDataFields:CHECKED 
      THEN RUN GenerateDataFields IN THIS-PROCEDURE.

    SESSION:SET-WAIT-STATE("":U).

  IF cError <> '':U  THEN
  DO:
    RUN showMessages IN gshSessionManager (INPUT cError,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Entity Mnemonic Import Failure",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).
  END.  /* if error */
  ELSE DO:
    RUN showMessages IN gshSessionManager (INPUT "The entity mnemonic import completed sucessfully.":U,
                                           INPUT "MES":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Entity Mnemonic Import Complete",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).

  END.
  EMPTY TEMP-TABLE ttImport.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeData C-Win 
PROCEDURE initializeData :
/*------------------------------------------------------------------------------
  Purpose:     Gets the list of connected databases (on the AppServer) and tables
               for those database 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lDisplayRepository      AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE cDBList                 AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cProductModules         AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cProfileData            AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE rRowid                  AS ROWID                    NO-UNDO.

    EMPTY TEMP-TABLE ttTable.

    /* Display Repository?  */
    ASSIGN rRowid = ?.
    RUN getProfileData IN gshProfileManager ( INPUT        "General":U,
                                              INPUT        "DispRepos":U,
                                              INPUT        "DispRepos":U,
                                              INPUT        NO,
                                              INPUT-OUTPUT rRowid,
                                                    OUTPUT cProfileData).
    ASSIGN lDisplayRepository = (cProfileData EQ "YES":U).

    RUN af/sup2/gscemrddbp.p ON gshAstraAppServer ( INPUT  lDisplayRepository,
                                                    OUTPUT cDBList,
                                                    OUTPUT cProductModules,
                                                    OUTPUT TABLE ttTable    ) NO-ERROR.

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN coDatabase:LIST-ITEMS        = cDBList
               coDatabase:SCREEN-VALUE      = coDatabase:ENTRY(1)
               coProductModule:LIST-ITEMS   = cProductModules
               coProductModule:SCREEN-VALUE = coProductModule:ENTRY(1)
               raAuditing:SCREEN-VALUE      = "I":U
               .
        {&OPEN-QUERY-{&BROWSE-NAME}}        
    END.    /* with frame ... */

    RETURN. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject C-Win 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     When an object is launched it tries to run viewObject. Since this
               is not a standard viewer I added this procedure to avoid getting
               an error that the procedure does not exist.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

