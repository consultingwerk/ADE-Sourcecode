&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
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

         File: adeuib/_Tempdb.w

  Description: Temp-DB & Temp Table Maintenance Window
               
               This application is used for maintaining temp-table definitions.
               It allows users to create temp-table definitions in source files 
               and for the source files to be synched-up with table definitions
               in the temp-db database. 
                 
  Syntax      :
        
  Author(s)   : Don Bulua
  Created     : 05/01/2004
  Notes       : Requires a connection to TEMP-DB database
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure.  */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE glDynamicsRunning AS LOGICAL    NO-UNDO.
DEFINE VARIABLE gcMode       AS CHARACTER  NO-UNDO INIT "Edit":U.
DEFINE VARIABLE ghSchema     AS HANDLE  NO-UNDO.
DEFINE VARIABLE gLastRowID   AS ROWID      NO-UNDO.
DEFINE VARIABLE gcLastTable  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glSkip       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE ghTempDBLib  AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghmenuEntity AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghmenuPrint  AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghEditor     AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcSortBy     AS CHARACTER  NO-UNDO INIT "ttTableName":U.
DEFINE VARIABLE ghEntity     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghUserMod    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghCompare    AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcLogFile    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glUseLog     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE ghChooseWindow AS HANDLE     NO-UNDO.
/* Shared Variable Definitions ---                                       */
{adeuib/uibhlp.i}
{adeuib/sharvars.i}  

{protools/_schdef.i }  /* TableDetails, FieldDetails, IndexDetails temp table definitions */
{adeuib/_tempdbtt.i}  /* ttTempDB definition */


PROCEDURE LockWindowUpdate EXTERNAL "user32.dll":
      DEFINE INPUT  PARAMETER piWindowHwnd AS LONG NO-UNDO.
      DEFINE RETURN PARAMETER piResult     AS LONG NO-UNDO.
  END PROCEDURE.

/* The following external calls are used for opening the log file
   using the asociated windows program in procedure OpenDocument*/
PROCEDURE FindExecutableA EXTERNAL "shell32" :
  define input parameter lpFile as char.
  define input parameter lpDirectory as char.
  define input-output parameter lpResult as char.
  define return parameter hInstance as LONG.
END.

PROCEDURE ShellExecuteA EXTERNAL "shell32" :
  define input parameter hwnd as LONG.
  define input parameter lpOperation as char.
  define input parameter lpFile as char.
  define input parameter lpParameters as char.
  define input parameter lpDirectory as char.
  define input parameter nShowCmd as LONG.
  define return parameter hInstance as LONG.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME fMain
&Scoped-define BROWSE-NAME BrwMain

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttTempDB

/* Definitions for BROWSE BrwMain                                       */
&Scoped-define FIELDS-IN-QUERY-BrwMain ttTableName ttSourceFile ttUseInclude ttTableDate ttFileCHanged ttStatus   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwMain   
&Scoped-define SELF-NAME BrwMain
&Scoped-define QUERY-STRING-BrwMain FOR EACH ttTempDB WHERE ttProcedure = THIS-PROCEDURE                         BY gcSortBy
&Scoped-define OPEN-QUERY-BrwMain OPEN QUERY {&SELF-NAME} FOR EACH ttTempDB WHERE ttProcedure = THIS-PROCEDURE                         BY gcSortBy.
&Scoped-define TABLES-IN-QUERY-BrwMain ttTempDB
&Scoped-define FIRST-TABLE-IN-QUERY-BrwMain ttTempDB


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BrwMain}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECTTop RECTBottom RECT-5 coFilter BrwMain ~
btnRebuild fiLog btnLog btnView btnCompare btnOpen btnExit 
&Scoped-Define DISPLAYED-OBJECTS coFilter fiLog 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseHandle wWin 
FUNCTION getBrowseHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEditor wWin 
FUNCTION getEditor RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEditorProc wWin 
FUNCTION getEditorProc RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFileLabel wWin 
FUNCTION getFileLabel RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFileName wWin 
FUNCTION getFileName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMode wWin 
FUNCTION getMode RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_New 
       MENU-ITEM m_New_File     LABEL "New File"       ACCELERATOR "CTRL-N"
       MENU-ITEM m_Open_File    LABEL "Open File"      ACCELERATOR "CTRL-O".

DEFINE SUB-MENU m_File 
       SUB-MENU  m_New          LABEL "New"           
       RULE
       MENU-ITEM m_Save         LABEL "Save"           ACCELERATOR "CTRL-S"
       MENU-ITEM m_Delete       LABEL "Delete"         ACCELERATOR "CTRL-D"
       RULE
       MENU-ITEM m_View_Temp-Table LABEL "View TEMP-DB Schema..."
       MENU-ITEM m_Open_Source_File LABEL "Open Source File..."
       MENU-ITEM m_Compare      LABEL "Compare"       
       MENU-ITEM m_Check_Syntax LABEL "Check &Syntax"  ACCELERATOR "SHIFT-F2"
       RULE
       MENU-ITEM m_Rebuild      LABEL "Rebuild TEMP-DB".

DEFINE SUB-MENU m_Insert 
       MENU-ITEM m_Table_Definition LABEL "Table Definition..."
       MENU-ITEM m_Database_FIelds LABEL "Database Fields..."
       MENU-ITEM m_File_Contents LABEL "File Contents.."
       MENU-ITEM m_FileName     LABEL "File Name..."  .

DEFINE SUB-MENU m_Format 
       MENU-ITEM m_Indent_Selection LABEL "Indent Selection"
       MENU-ITEM m_Unindent_Selection LABEL "Unindent Selection"
       RULE
       MENU-ITEM m_Comment_Selection LABEL "Comment Selection" ACCELERATOR "CTRL-O"
       MENU-ITEM m_Uncomment_Selection LABEL "Uncomment Selection" ACCELERATOR "CTRL-U".

DEFINE SUB-MENU m_Edit 
       MENU-ITEM m_Undo         LABEL "Undo"           ACCELERATOR "CTRL-Z"
       MENU-ITEM m_Undo_All     LABEL "Undo &All"     
       RULE
       MENU-ITEM m_Cut          LABEL "Cu&t"           ACCELERATOR "CTRL-X"
       MENU-ITEM m_Copy         LABEL "Copy"           ACCELERATOR "CTRL-C"
       MENU-ITEM m_Paste        LABEL "Paste"          ACCELERATOR "CTRL-V"
       RULE
       SUB-MENU  m_Insert       LABEL "Insert"        
       SUB-MENU  m_Format       LABEL "Format"        
       RULE
       MENU-ITEM m_Refresh      LABEL "Refresh"        ACCELERATOR "F5".

DEFINE SUB-MENU m_Options 
       MENU-ITEM m_Preferences  LABEL "Preferences..."
       MENU-ITEM m_Editing_Options LABEL "Editing Options...".

DEFINE SUB-MENU m_Help 
       MENU-ITEM m_OpenEdge_Master_Help LABEL "OpenEdge &Master Help"
       MENU-ITEM m_AppBuilder_Help_Topics LABEL "AppBuilder &Help Topics"
       MENU-ITEM m_Help_Topics  LABEL "&Temp-DB Context Help" ACCELERATOR "F1".

DEFINE MENU MENU-BAR-wWin MENUBAR
       SUB-MENU  m_File         LABEL "File"          
       SUB-MENU  m_Edit         LABEL "Edit"          
       SUB-MENU  m_Options      LABEL "Options"       
       SUB-MENU  m_Help         LABEL "Help"          .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.
DEFINE VARIABLE h_tempdbedit AS HANDLE NO-UNDO.
DEFINE VARIABLE h_tempdbimport AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnCompare  NO-FOCUS FLAT-BUTTON
     LABEL "Compare" 
     CONTEXT-HELP-ID 0
     SIZE 5 BY 1.1 TOOLTIP "Compare source file with schema".

DEFINE BUTTON btnExit  NO-FOCUS FLAT-BUTTON
     LABEL "E&xit" 
     SIZE 6 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON btnImport  NO-FOCUS FLAT-BUTTON
     LABEL "Entity Import" 
     CONTEXT-HELP-ID 0
     SIZE 15 BY 1.1 TOOLTIP "Import Entities for selected tables".

DEFINE BUTTON btnLog 
     LABEL "Log" 
     CONTEXT-HELP-ID 0
     SIZE 4.8 BY 1.05.

DEFINE BUTTON btnOpen  NO-FOCUS FLAT-BUTTON
     LABEL "Open" 
     CONTEXT-HELP-ID 0
     SIZE 5 BY 1.1 TOOLTIP "Open source file in editor".

DEFINE BUTTON btnRebuild  NO-FOCUS FLAT-BUTTON
     LABEL "Rebuild TEMP-DB" 
     CONTEXT-HELP-ID 0
     SIZE 18 BY 1.1 TOOLTIP "Rebuild TEMP-DB database for selected tables".

DEFINE BUTTON btnView  NO-FOCUS FLAT-BUTTON
     LABEL "View" 
     CONTEXT-HELP-ID 0
     SIZE 5 BY 1.1 TOOLTIP "View TEMP-DB schema details".

DEFINE VARIABLE coFilter AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Filter" 
     CONTEXT-HELP-ID 0
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEM-PAIRS "All",0,
                     "Maintained Tables",1,
                     "Unmaintained Tables",2,
                     "Unknown Source File",3
     DROP-DOWN-LIST
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE fiLog AS CHARACTER FORMAT "X(100)":U 
     LABEL "Log File" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 62 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE .4 BY 1.38.

DEFINE RECTANGLE RECTBottom
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 104.8 BY .1.

DEFINE RECTANGLE RECTTop
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 104.8 BY .1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwMain FOR 
      ttTempDB SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwMain wWin _FREEFORM
  QUERY BrwMain DISPLAY
      ttTableName WIDTH 15
 ttSourceFile
 ttUseInclude
 ttTableDate WIDTH 18
 ttFileCHanged
 ttStatus
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS NO-COLUMN-SCROLLING SEPARATORS MULTIPLE SIZE 114 BY 7.86 ROW-HEIGHT-CHARS .57 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     btnImport AT ROW 1.14 COL 37.8
     coFilter AT ROW 1.19 COL 59 COLON-ALIGNED
     BrwMain AT ROW 2.67 COL 2
     btnRebuild AT ROW 1.14 COL 18.6
     fiLog AT ROW 24.33 COL 12 COLON-ALIGNED
     btnLog AT ROW 24.33 COL 76
     btnView AT ROW 1.14 COL 2
     btnCompare AT ROW 1.14 COL 12.6
     btnOpen AT ROW 1.14 COL 7.4
     btnExit AT ROW 1.1 COL 98
     RECTTop AT ROW 1 COL 1
     RECTBottom AT ROW 2.29 COL 1
     RECT-5 AT ROW 1 COL 17.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 116.2 BY 24.48.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Design Page: 2
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "TEMP-DB Maintenance"
         HEIGHT             = 24.43
         WIDTH              = 117.6
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.2
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.2
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MENU-BAR-wWin:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fMain
                                                                        */
/* BROWSE-TAB BrwMain coFilter fMain */
ASSIGN 
       BrwMain:ALLOW-COLUMN-SEARCHING IN FRAME fMain = TRUE
       BrwMain:COLUMN-RESIZABLE IN FRAME fMain       = TRUE.

/* SETTINGS FOR BUTTON btnImport IN FRAME fMain
   NO-ENABLE                                                            */
ASSIGN 
       btnImport:HIDDEN IN FRAME fMain           = TRUE.

ASSIGN 
       fiLog:READ-ONLY IN FRAME fMain        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwMain
/* Query rebuild information for BROWSE BrwMain
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttTempDB WHERE ttProcedure = THIS-PROCEDURE
                        BY gcSortBy.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BrwMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* TEMP-DB Maintenance */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* TEMP-DB Maintenance */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
 
  RUN exitObject IN THIS-PROCEDURE.
  IF RETURN-VALUE BEGINS "CANCEL":U THEN
       RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-RESIZED OF wWin /* TEMP-DB Maintenance */
DO:
  RUN resizeObject ({&WINDOW-NAME}:HEIGHT,{&WINDOW-NAME}:WIDTH).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-RESTORED OF wWin /* TEMP-DB Maintenance */
DO:
  IF VALID-HANDLE(ghCompare) THEN
      RUN MoveToTop IN ghCompare.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrwMain
&Scoped-define SELF-NAME BrwMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BrwMain wWin
ON ROW-DISPLAY OF BrwMain IN FRAME fMain
DO:
  IF CAN-DO(ttTempdb.ttStatusCode,"X":U) THEN
  DO:
     ASSIGN ttTableName:FGCOLOR IN BROWSE {&BROWSE-NAME}   = 12
            ttSourceFile:FGCOLOR IN BROWSE {&BROWSE-NAME}  = 12
            ttUseInclude:FGCOLOR IN BROWSE {&BROWSE-NAME}  = 12
            ttTableDate:FGCOLOR IN BROWSE {&BROWSE-NAME}   = 12
            ttFileCHanged:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
            ttStatus:FGCOLOR IN BROWSE {&BROWSE-NAME}      = 12.

     IF glDynamicsRunning THEN
        ASSIGN ghEntity:FGCOLOR   = 12
               ghUserMod:FGCOLOR = 12.   /*red */ 
  END.
  ELSE IF CAN-DO(ttTempdb.ttStatusCode,"M":U) THEN
  DO:
     ASSIGN ttTableName:FGCOLOR IN BROWSE {&BROWSE-NAME}   = 2
            ttSourceFile:FGCOLOR IN BROWSE {&BROWSE-NAME}  = 2
            ttUseInclude:FGCOLOR IN BROWSE {&BROWSE-NAME}  = 2
            ttTableDate:FGCOLOR IN BROWSE {&BROWSE-NAME}   = 2
            ttFileCHanged:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
            ttStatus:FGCOLOR IN BROWSE {&BROWSE-NAME}      = 2.

     IF glDynamicsRunning THEN
        ASSIGN ghEntity:FGCOLOR   = 2
               ghUserMod:FGCOLOR = 2.   /*green */ 
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BrwMain wWin
ON START-SEARCH OF BrwMain IN FRAME fMain
DO:
  RUN startSearch IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BrwMain wWin
ON VALUE-CHANGED OF BrwMain IN FRAME fMain
DO:
  IF AVAIL ttTempDB THEN
  DO:
     RUN loadFile IN h_tempdbedit (INPUT tttempDB.ttSourceFile,
                                   INPUT ttTempDB.ttStatusCode,
                                   INPUT ttTempDB.ttUseInclude).
     {set Include ttTempDB.ttUseInclude}.
     IF RETURN-VALUE BEGINS "CANCEL":U THEN
     DO:
        IF gLastRowID <> ?  THEN
            REPOSITION {&BROWSE-NAME} TO ROWID gLastRowID.
        RUN StateChanged IN THIS-PROCEDURE.
        RUN applyEntry IN h_tempdbEdit ("EdSource":U).        
        RETURN NO-APPLY RETURN-VALUE.
     END.
     ASSIGN gcMode = "Edit":U.
     gLastRowID = ROWID(ttTempDB).
     gcLastTable = ttTempDB.ttTableName.
  END.
  ELSE
    ASSIGN gcMode = "Add":U.

  RUN stateChanged IN THIS-PROCEDURE.
  STATUS DEFAULT "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnCompare
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnCompare wWin
ON CHOOSE OF btnCompare IN FRAME fMain /* Compare */
DO:
    RUN compareLoop IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnExit wWin
ON CHOOSE OF btnExit IN FRAME fMain /* Exit */
DO:
  
   APPLY "WINDOW-CLOSE" TO {&WINDOW-NAME}.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnImport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnImport wWin
ON CHOOSE OF btnImport IN FRAME fMain /* Entity Import */
DO:
  RUN entityImport IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnLog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnLog wWin
ON CHOOSE OF btnLog IN FRAME fMain /* Log */
DO:
  RUN OpenDocument IN THIS-PROCEDURE (fiLog:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnOpen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnOpen wWin
ON CHOOSE OF btnOpen IN FRAME fMain /* Open */
DO:
  RUN OpenFile IN THIS-PROCEDURE.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnRebuild
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnRebuild wWin
ON CHOOSE OF btnRebuild IN FRAME fMain /* Rebuild TEMP-DB */
DO:
  RUN rebuildLoop IN THIS-PROCEDURE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnView
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnView wWin
ON CHOOSE OF btnView IN FRAME fMain /* View */
DO:
  IF AVAIL ttTempDB  THEN
     RUN tempDBView IN THIS-PROCEDURE (ttTempDB.ttTableName).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coFilter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coFilter wWin
ON VALUE-CHANGED OF coFilter IN FRAME fMain /* Filter */
DO:
  RUN setFilter IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_AppBuilder_Help_Topics
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_AppBuilder_Help_Topics wWin
ON CHOOSE OF MENU-ITEM m_AppBuilder_Help_Topics /* AppBuilder Help Topics */
DO:
  RUN adecomm/_adehelp.p ("AB":U, "TOPICS":U, {&Main_Contents}, ? ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Check_Syntax
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Check_Syntax wWin
ON CHOOSE OF MENU-ITEM m_Check_Syntax /* Check Syntax */
DO:
    RUN EditorAction IN h_tempdbEdit ("CHECK-SYNTAX":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Comment_Selection
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Comment_Selection wWin
ON CHOOSE OF MENU-ITEM m_Comment_Selection /* Comment Selection */
DO:
    RUN EditorAction IN h_tempdbEdit ("comment-selection":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Compare
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Compare wWin
ON CHOOSE OF MENU-ITEM m_Compare /* Compare */
DO:
    RUN compareLoop IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Copy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Copy wWin
ON CHOOSE OF MENU-ITEM m_Copy /* Copy */
DO:
    RUN EditorAction IN h_tempdbEdit ("COPY":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Cut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Cut wWin
ON CHOOSE OF MENU-ITEM m_Cut /* Cut */
DO:
    RUN EditorAction IN h_tempdbEdit ("CUT":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Database_FIelds
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Database_FIelds wWin
ON CHOOSE OF MENU-ITEM m_Database_FIelds /* Database Fields... */
DO:
  RUN EditorAction IN h_tempdbEdit ("INSERT-FIELDS":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Delete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Delete wWin
ON CHOOSE OF MENU-ITEM m_Delete /* Delete */
DO:
  RUN DeleteRecord IN THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Edit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Edit wWin
ON MENU-DROP OF MENU m_Edit /* Edit */
DO:
  DEFINE VARIABLE hEditor       AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lReadOnly     AS LOGICAL NO-UNDO.
  DEFINE VARIABLE lTextSelected AS LOGICAL    NO-UNDO.

  {get EDITOR hEditor h_tempdbEdit}.
  IF AVAIL ttTempDB AND NOT CAN-DO(ttTempDB.ttStatusCode,"C":U) AND NOT CAN-DO(ttTempDB.ttStatusCode,"F") 
     OR gcMode= "Add":U THEN
   ASSIGN
        lReadOnly     = hEditor:READ-ONLY 
        lTextSelected = hEditor:TEXT-SELECTED
       
        SUB-MENU  m_Insert:SENSITIVE = (NOT lReadOnly)

        SUB-MENU  m_Format:SENSITIVE = /* TRUE IF... */
                        ( NOT lReadOnly ) AND ( lTextSelected )
        
        MENU-ITEM m_Cut:SENSITIVE IN MENU MENU-BAR-wWin = /* TRUE IF... */
                        ( NOT lReadOnly ) AND ( lTextSelected )

        MENU-ITEM m_Copy:SENSITIVE IN MENU  MENU-BAR-wWin = /* TRUE IF...*/
                        ( lTextSelected  )
                            
        MENU-ITEM m_Paste:SENSITIVE IN MENU  MENU-BAR-wWin = /* TRUE IF... */
                        ( hEditor:EDIT-CAN-PASTE ) AND ( NOT lReadOnly )
        
    .    
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Editing_Options
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Editing_Options wWin
ON CHOOSE OF MENU-ITEM m_Editing_Options /* Editing Options... */
DO:
   RUN EditorAction IN h_tempdbEdit ("EDITING-OPTIONS":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_FileName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_FileName wWin
ON CHOOSE OF MENU-ITEM m_FileName /* File Name... */
DO:
RUN EditorAction IN h_tempdbEdit ("INSERT-FILE-NAME":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_File_Contents
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_File_Contents wWin
ON CHOOSE OF MENU-ITEM m_File_Contents /* File Contents.. */
DO:
   RUN EditorAction IN h_tempdbEdit ("INSERT-FILE-CONTENTS":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Help_Topics
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Help_Topics wWin
ON CHOOSE OF MENU-ITEM m_Help_Topics /* Temp-DB Context Help */
DO:
    IF glDynamicsRunning THEN
        RUN adecomm/_adehelp.p( "AB", "CONTEXT", {&TEMP_DB_Maintenance_Win_Dyn}, ?).
    ELSE
        RUN adecomm/_adehelp.p( "AB", "CONTEXT", {&TEMP_DB_Maintenance_Win}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Indent_Selection
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Indent_Selection wWin
ON CHOOSE OF MENU-ITEM m_Indent_Selection /* Indent Selection */
DO:
   RUN EditorAction IN h_tempdbEdit ("tab":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_New_File
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_New_File wWin
ON CHOOSE OF MENU-ITEM m_New_File /* New File */
DO:
    RUN EditorAction IN h_tempdbEdit ("NEW-FILE":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_OpenEdge_Master_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_OpenEdge_Master_Help wWin
ON CHOOSE OF MENU-ITEM m_OpenEdge_Master_Help /* OpenEdge Master Help */
DO:
  RUN adecomm/_adehelp.p ( INPUT "mast":U, 
                           INPUT "TOPICS":U,
                           INPUT ?,
                           INPUT ? ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Open_File
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Open_File wWin
ON CHOOSE OF MENU-ITEM m_Open_File /* Open File */
DO:
  RUN EditorAction IN h_tempdbEdit ("OPEN-FILE":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Open_Source_File
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Open_Source_File wWin
ON CHOOSE OF MENU-ITEM m_Open_Source_File /* Open Source File... */
DO:
  APPLY "CHOOSE":U TO btnOpen IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Paste
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Paste wWin
ON CHOOSE OF MENU-ITEM m_Paste /* Paste */
DO:
    RUN EditorAction IN h_tempdbEdit ("Paste":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Preferences
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Preferences wWin
ON CHOOSE OF MENU-ITEM m_Preferences /* Preferences... */
DO:
  RUN PreferenceRun IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Rebuild
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Rebuild wWin
ON CHOOSE OF MENU-ITEM m_Rebuild /* Rebuild TEMP-DB */
DO:
  RUN rebuildLoop IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Refresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Refresh wWin
ON CHOOSE OF MENU-ITEM m_Refresh /* Refresh */
DO:
    SESSION:SET-WAIT-STATE("GENERAL":U).
    RUN rebuildBrowse.
    SESSION:SET-WAIT-STATE("":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Save
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Save wWin
ON CHOOSE OF MENU-ITEM m_Save /* Save */
DO:
  RUN EditorAction IN h_tempdbEdit ("SAVE-FILE":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Table_Definition
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Table_Definition wWin
ON CHOOSE OF MENU-ITEM m_Table_Definition /* Table Definition... */
DO:
   RUN EditorAction IN h_tempdbEdit ("INSERT-TABLE":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Uncomment_Selection
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Uncomment_Selection wWin
ON CHOOSE OF MENU-ITEM m_Uncomment_Selection /* Uncomment Selection */
DO:
      RUN EditorAction IN h_tempdbEdit ("uncomment-selection":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Undo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Undo wWin
ON CHOOSE OF MENU-ITEM m_Undo /* Undo */
DO:
  RUN EditorAction IN h_tempdbEdit ("UNDO":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Undo_All
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Undo_All wWin
ON CHOOSE OF MENU-ITEM m_Undo_All /* Undo All */
DO:
  RUN EditorAction IN h_tempdbEdit ("undo_All":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Unindent_Selection
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Unindent_Selection wWin
ON CHOOSE OF MENU-ITEM m_Unindent_Selection /* Unindent Selection */
DO:
     RUN EditorAction IN h_tempdbEdit ("back_tab":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_View_Temp-Table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_View_Temp-Table wWin
ON CHOOSE OF MENU-ITEM m_View_Temp-Table /* View TEMP-DB Schema... */
DO:
  IF AVAIL ttTempDB  THEN
     RUN tempDBView IN THIS-PROCEDURE (ttTempDB.ttTableName).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Launch tempdb library proc */
ghTempDBLib = SESSION:FIRST-PROCEDURE.
DO WHILE VALID-HANDLE(ghTempDBLib) AND ghTempDBLib:FILE-NAME NE "adeuib/_tempdblib.p":U:
  ghTempDBLib = ghTempDBLib:NEXT-SIBLING.
END.
IF NOT VALID-HANDLE(ghTempDBLib) THEN
  RUN VALUE("adeuib/_tempdblib.p":U) PERSISTENT SET ghTempDBLib.

THIS-PROCEDURE:ADD-SUPER-PROCEDURE(ghTempDBLib, SEARCH-TARGET). 


/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AddFilter wWin 
PROCEDURE AddFilter :
/*------------------------------------------------------------------------------
  Purpose:     Adds the Matched and Mismatched Items to the
               List-items of the filter combo box.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cValue AS CHARACTER  NO-UNDO.

IF LOOKUP("Matched Records",coFilter:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME})  = 0 THEN
DO:
  ASSIGN cValue                   = coFilter:SCREEN-VALUE  
         coFilter:LIST-ITEM-PAIRS = coFilter:LIST-ITEM-PAIRS + ",MisMatched Records,4,Matched Records,5".
         coFilter:SCREEN-VALUE    = cValue 
         NO-ERROR.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
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
             INPUT  'adm2/folder.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'FolderLabels':U + '&Source File|File &Import' + 'FolderTabWidth0FolderFont-1HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_folder ).
       RUN repositionObject IN h_folder ( 10.52 , 2.00 ) NO-ERROR.
       RUN resizeObject IN h_folder ( 13.33 , 113.80 ) NO-ERROR.

       /* Links to SmartFolder h_folder. */
       RUN addLink ( h_folder , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_folder ,
             BrwMain:HANDLE IN FRAME fMain , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN constructObject (
             INPUT  'adeuib/_tempdbedit.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_tempdbedit ).
       RUN repositionObject IN h_tempdbedit ( 12.91 , 5.00 ) NO-ERROR.
       RUN resizeObject IN h_tempdbedit ( 9.52 , 108.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_folder ,
             BrwMain:HANDLE IN FRAME fMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_tempdbedit ,
             h_folder , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN constructObject (
             INPUT  'adeuib/_tempdbimport.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_tempdbimport ).
       RUN repositionObject IN h_tempdbimport ( 12.19 , 4.00 ) NO-ERROR.
       RUN resizeObject IN h_tempdbimport ( 7.33 , 97.60 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_folder ,
             BrwMain:HANDLE IN FRAME fMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_tempdbimport ,
             h_folder , 'AFTER':U ).
    END. /* Page 2 */

  END CASE.
  /* Select a Startup page. */
  IF currentPage eq 0
  THEN RUN selectPage IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildMenu wWin 
PROCEDURE buildMenu :
/*------------------------------------------------------------------------------
  Purpose:    Adds menu items to the File menu. The adding of the Entity Import 
              is conditional on there being a Dynamics environment.
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hMenuBar  AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hMenuFile AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hmenuItem AS HANDLE     NO-UNDO.
 
 ASSIGN hMenuBar  = MENU menu-bar-wWin:HANDLE
        hMenuFile = hMenuBar:FIRST-CHILD.

 IF glDynamicsRunning THEN
    CREATE MENU-ITEM ghmenuEntity
       ASSIGN
         LABEL = "Entity &Import"
         PARENT = hMenuFile
       TRIGGERS:
         ON CHOOSE PERSISTENT RUN entityImport IN THIS-PROCEDURE.
       END TRIGGERS.

 /* Add the Exit option in the Menu */
 CREATE MENU-ITEM hmenuItem
      ASSIGN
         SUBTYPE = 'RULE':U
         PARENT = hMenuFile
      .

 CREATE MENU-ITEM ghmenuPrint
     ASSIGN
       LABEL  = "Print"
       PARENT = hMenuFile
     TRIGGERS:
       ON CHOOSE PERSISTENT RUN printFile IN THIS-PROCEDURE.
     END TRIGGERS.

 CREATE MENU-ITEM hmenuItem
       ASSIGN
         SUBTYPE = 'RULE':U
         PARENT = hMenuFile.

 CREATE MENU-ITEM hmenuItem
       ASSIGN
         LABEL = "E&xit"
         PARENT = hMenuFile
       TRIGGERS:
         ON CHOOSE PERSISTENT RUN exitObject IN THIS-PROCEDURE.
       END TRIGGERS.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE compareLoop wWin 
PROCEDURE compareLoop :
/*------------------------------------------------------------------------------
  Purpose:     Loops through all selected records and compares them.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lBrwReturn AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE cResult    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cString    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lLog       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cTableID   AS CHARACTER  NO-UNDO.

  IF {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} > 0 THEN
  DO:
    IF AVAIL ttTempDB THEN
       ASSIGN cTableID = ttTempDB.ttTableID NO-ERROR.
    {set LogCompare TRUE}.
    {get LogFile lLog}.
    /* Turn Off logging for compare operation */
    {set LogFile NO}.
    DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
      lBrwReturn = {&BROWSE-NAME}:FETCH-SELECTED-ROW(i).
      GET CURRENT {&BROWSE-NAME} NO-LOCK.
      IF NOT VALID-HANDLE(ghCompare) THEN
      DO:
        RUN adeuib/_tempdbcomp.w PERSISTENT SET ghCompare.
        RUN setParent IN ghCompare ({&WINDOW-NAME}:HANDLE).
        RUN centerwindow IN ghcompare.
      END.
      RUN moveToTop IN ghCompare.
      
      {set CompareHandle ghCompare}.
      {set LogCompare TRUE}.

      RUN getEditorString IN ghCompare (OUTPUT cString).
      IF cString > "" THEN
         RUN WriteToEditor IN ghCompare (CHR(10) + "**************************************************~
***********************************" + CHR(10)).

      RUN WriteToEditor IN ghCompare 
           (INPUT "Table: " + ttTempDB.ttTableName + CHR(10) + "Source: " + ttTempDB.ttSourceFile + CHR(10)).
      
      /* Compare selected source with table */
      RUN compareFile IN THIS-PROCEDURE (ttTempDB.ttSourceFile, ttTempDB.ttTableID, OUTPUT cResult).  
      IF NOT RETURN-VALUE BEGINS "ERROR":U THEN
      DO:
        IF cResult > ""  THEN
        DO:
          /* Set the temp table status field to indicate a mismatch */
          IF NOT CAN-DO (ttTempDB.ttStatusCode,"X":U) THEN
             ASSIGN ttTempDB.ttSTatusCode = ttTempDB.ttSTatusCode + (IF  ttTempDB.ttSTatusCode = "" THEN "" ELSE ",") + "X":U
                    ttTempDB.ttStatus     = ttTempDB.ttStatus + (IF ttTempDB.ttStatus = "" THEN "" ELSE ";")
                                                   + "Mismatched record".
          BELL.

        END.
        ELSE DO:
          ttTempDB.ttStatusCode = REPLACE(ttTempDB.ttStatusCode,"X":U,"").
          IF NOT CAN-DO (ttTempDB.ttStatusCode,"M":U) THEN
            ASSIGN ttTempDB.ttSTatusCode = ttTempDB.ttSTatusCode + (IF  ttTempDB.ttSTatusCode = "" THEN "" ELSE ",") + "M":U
                   ttTempDB.ttStatus     = ttTempDB.ttStatus + (IF ttTempDB.ttStatus = "" THEN "" ELSE ";")
                                               + "Matched record".
        END.
      END.
    END.
    {set logCompare FALSE}.
     /* Turn logging back on to original setting */
    RUN rebuildBrowse IN TARGET-PROCEDURE NO-ERROR. 
    {set LogFile lLog}.
      
    {&BROWSE-NAME}:SET-REPOSITIONED-ROW (MAX(1, {&BROWSE-NAME}:FOCUSED-ROW), "CONDITIONAL") .
    {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}

    IF cTableID > "" THEN 
    DO:
      FIND ttTempdb WHERE ttTempdb.ttTableID = cTableID NO-ERROR.
      REPOSITION {&BROWSE-NAME} TO ROWID(ROWID(ttTempDB)).
      {&BROWSE-NAME}:SELECT-FOCUSED-ROW().
    END.
    
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleterecord wWin 
PROCEDURE deleterecord :
/*------------------------------------------------------------------------------
  Purpose:    Deletes the current selected records 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE i          AS INTEGER    NO-UNDO.
DEFINE VARIABLE lBrwReturn AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cRecords   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lChoice    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lDeleted   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hTempDB    AS HANDLE     NO-UNDO.
DEFINE VARIABLE cTable     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFile      AS CHARACTER  NO-UNDO.


IF {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} > 0 THEN
DO:
    MESSAGE "Are you sure you want to delete the selected records and associated tables"
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lchoice.
  IF lchoice THEN 
  DO:
    RUN StartLog IN TARGET-PROCEDURE.
    /* Turn off messaging */
    
    DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
      lBrwReturn = {&BROWSE-NAME}:FETCH-SELECTED-ROW(i).
      GET CURRENT {&BROWSE-NAME} NO-LOCK.
      
      RUN adeuib/_tempdbawarelib.p PERSISTENT SET hTempdb.
      IF NOT VALID-HANDLE(hTempDB) THEN RETURN "ERROR":U.
      RUN deleteTempDB IN hTempDB (ttTempDB.ttTableID, OUTPUT lDeleted).
      DELETE PROCEDURE hTempDB.
          
      IF AVAIL ttTempDB THEN
      DO:
        IF lDeleted THEN 
        DO:
          {Set NoMessage FALSE}.
          ASSIGN cTable   = ttTempDB.ttTableID
                 cFile    = ttTempDB.ttSOurceFIle.
          DELETE ttTempDB NO-ERROR.
          IF NOT ERROR-STATUS:ERROR THEN
             cRecords = cRecords + (IF cRecords = "" then "" ELSE ",") + cTable + "-" + cFile.
        END.
        ELSE IF AVAIL ttTempDB THEN
             DELETE ttTempDB.

      END. /* IF avail tttempDB */
    END.
    
    RUN rebuildBrowse IN THIS-PROCEDURE.
    
    APPLY "VALUE-CHANGED":U TO {&BROWSE-NAME}.
    IF cRecords > "" THEN 
    DO:
       {Set NoMessage true}.
       RUN LogFile IN TARGET-PROCEDURE 
              ( INPUT "deleteTempdb":U ,
                INPUT IF NUM-ENTRIES(cRecords) > 1 
                      THEN "Tables '" + cRecords + "' have been removed from TEMP-DB"
                      ELSE "Table '" + cRecords + "' has been removed from TEMP-DB").
    END.
  END. /* IF lChoice */

END. /* IF NUM-SELECTED-ROWS > 0 */



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY coFilter fiLog 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE RECTTop RECTBottom RECT-5 coFilter BrwMain btnRebuild fiLog btnLog 
         btnView btnCompare btnOpen btnExit 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE entityImport wWin 
PROCEDURE entityImport :
/*------------------------------------------------------------------------------
  Purpose:     Imports selected records into the Dnamics repository
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTableList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLastTable  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lBrwReturn  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE i           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lOK         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cErr        AS CHARACTER  NO-UNDO.
  
  RUN ConnectDB(OUTPUT lok).
  IF NOT lok THEN RETURN.

  IF {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} > 0 THEN
  DO:
    ASSIGN cLastTable = IF AVAIL ttTempDB THEN ttTempDB.ttTableID
                                          ELSE "".
    RUN StartLog IN TARGET-PROCEDURE.
    /* Build list of selected tables */
    DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
      lBrwReturn = {&BROWSE-NAME}:FETCH-SELECTED-ROW(i).
      GET CURRENT {&BROWSE-NAME} NO-LOCK.
      IF AVAIL ttTempDB AND NOT CAN-DO(ttTempDB.ttStatusCode,"F":U) THEN
      /* Compare selected source with table */
        cTableList = cTableList + (IF cTableList = "" THEN "" ELSE ",") 
                                + ttTempdb.ttTableid.
    END.

    RUN adeuib/_tempdbEntity.w (INPUT cTableList, OUTPUT lOK, OUTPUT cErr).
    IF lOK THEN
    DO:
       {Set NoMessage TRUE}.
       RUN LogFile IN TARGET-PROCEDURE 
           ( INPUT "_tempdbEntity":U ,
             INPUT IF cErr > "" THEN cErr
                   ELSE "Entity Import successfully generated for tables '" + cTableList + "'").
      RUN rebuildBrowse IN THIS-PROCEDURE.

      IF cLastTable > "" THEN
      DO: 
          FIND ttTempdb WHERE ttTempdb.ttTableid = cLastTable NO-ERROR.
          IF AVAIL ttTempDB THEN
             REPOSITION {&BROWSE-NAME} TO ROWID(ROWID(ttTempDB)) NO-ERROR.
      END.
      STATUS DEFAULT "Entity Import Complete".
    END.
        
    
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/
  /* Check whether Editor was modified */
  {get Editor ghEditor h_tempdbEdit}.
  RUN CheckModified (ghEditor).
  IF RETURN-VALUE BEGINS "CANCEL":U THEN
       RETURN RETURN-VALUE.
  
  IF VALID-HANDLE(ghCompare) THEN
      RUN exitWIndow IN ghCompare.
  
  RUN setPreference IN THIS-PROCEDURE.
  IF VALID-HANDLE(ghTempDBLib) THEN
      DELETE PROCEDURE ghTempDBLib.

  APPLY "CLOSE":U TO THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBrowsePreference wWin 
PROCEDURE getBrowsePreference :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cValue     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cSection   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDel       AS CHARACTER  NO-UNDO INIT "|".

 ASSIGN cSection = "ProAB":U.

 GET-KEY-VALUE SECTION cSection KEY "TempDBBrowseCols":U VALUE cValue.
 IF NUM-ENTRIES(cValue,cDel) GE 4 THEN
    ASSIGN ttTableName:WIDTH IN BROWSE {&BROWSE-NAME}   = INT(ENTRY(1,cValue,cDel))
           ttSourceFile:WIDTH IN BROWSE {&BROWSE-NAME}  = INT(ENTRY(2,cValue,cDel))
           ttUseInclude:WIDTH IN BROWSE {&BROWSE-NAME}  = INT(ENTRY(3,cValue,cDel))
           ttTableDate:WIDTH IN BROWSE {&BROWSE-NAME}   = INT(ENTRY(4,cValue,cDel))
           ttFileChanged:WIDTH IN BROWSE {&BROWSE-NAME} = INT(ENTRY(5,cValue,cDel))
           ttStatus:WIDTH IN BROWSE {&BROWSE-NAME}      = INT(ENTRY(6,cValue,cDel))
           NO-ERROR.
IF VALID-HANDLE(ghEntity) AND NUM-ENTRIES(cValue,cDel) GE 7 THEN
    ghEntity:WIDTH = INT(ENTRY(7,cValue,cDel)).
IF VALID-HANDLE(ghUserMod) AND NUM-ENTRIES(cValue,cDel) GE 8 THEN
    ghUserMod:WIDTH = INT(ENTRY(8,cValue,cDel)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPreference wWin 
PROCEDURE getPreference :
/*------------------------------------------------------------------------------
  Purpose:     Get various preferences from the Registry on init
  Parameters:  <none>
  Notes:       Called from initializeObject
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cValue     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cSection   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDel     AS CHARACTER  NO-UNDO INIT "|".

 ASSIGN cSection = "ProAB":U.
 GET-KEY-VALUE SECTION cSection KEY "TempDBUseLogFile":U VALUE cValue.
 glUseLog = IF cValue EQ ? THEN TRUE
            ELSE CAN-DO ("true,yes,on",cValue).

 IF glUseLog THEN
 DO:
    GET-KEY-VALUE SECTION cSection KEY "TempDBLogFile":U VALUE cValue.
    IF cValue = ? THEN 
       ASSIGN FILE-INFO:FILE-NAME = "."
              gcLogFile = FILE-INFO:FULL-PATHNAME  + "~\" + "Temp-dbLog.txt":U .
    ELSE 
       ASSIGN gcLogFile = cValue.
 
    ASSIGN fiLog = gcLogFile
           fiLog:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gcLogFile
           btnLog:SENSITIVE = TRUE.

 END.
 ELSE ASSIGN gcLogFile          = ""
             fiLog              = ""
             btnLog:SENSITIVE   = FALSE
             fiLog:SCREEN-VALUE = "".

{Set LogFile glUseLog}.
{set LogFileName gcLogFile}.

GET-KEY-VALUE SECTION cSection KEY "TempDBWindow":U VALUE cValue.
IF NUM-ENTRIES(cValue,cDel) = 5 THEN
DO:
   /* Stores resolution, width, height, X and Y */
   IF ENTRY(1,cValue,cDel) = TRIM(STRING(SESSION:WIDTH-PIXELS,">>999")) + "X"
                           + TRIM(STRING(SESSION:HEIGHT-PIXELS,">>999"))  THEN
     ASSIGN {&WINDOW-NAME}:WIDTH = INT(ENTRY(2,cValue,cDel))
            {&WINDOW-NAME}:HEIGHT = INT(ENTRY(3,cValue,cDel))
            {&WINDOW-NAME}:X      = INT(ENTRY(4,cValue,cDel))
            {&WINDOW-NAME}:Y      = INT(ENTRY(5,cValue,cDel)).
     
END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initDynamics wWin 
PROCEDURE initDynamics :
/*------------------------------------------------------------------------------
  Purpose:    Initialize Dynamics specific UI
              Make visible the entity import function and add Dynamics specific 
              browse columns 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBrowse   AS HANDLE     NO-UNDO.
  
  ASSIGN btnImport:VISIBLE IN FRAME {&FRAME-NAME} = TRUE
         btnImport:SENSITIVE = TRUE
         hBrowse            = BrwMain:HANDLE 
         ghEntity           = hBrowse:ADD-LIKE-COLUMN("tttempdb.ttEntityImported")
         ghEntity:LABEL     = "Entity Imported"
         ghEntity:WIDTH     = 15
         ghUserMod          = hBrowse:ADD-LIKE-COLUMN("tttempdb.ttUserModified")
         ghUserMod:LABEL    = "User"
         ghUserMod:WIDTH    = 10.
         .
   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:    Init UI componenets, resize the windows, 
              apply dynamics specific UI
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  RUN getPreference IN THIS-PROCEDURE.
  RUN resizeObject({&WINDOW-NAME}:HEIGHT, {&WINDOW-NAME}:WIDTH).
  /* Load images from bitmap image */
  btnView:LOAD-IMAGE("adeicon/bitlib.bmp",51,102,16,16) IN FRAME {&FRAME-NAME}.
  btnOpen:LOAD-IMAGE("adeicon/bitlib.bmp",68,102,16,16) IN FRAME {&FRAME-NAME}.
  btnCompare:LOAD-IMAGE("adeicon/bitlib.bmp",204,102,16,16) IN FRAME {&FRAME-NAME}.
  btnLog:LOAD-IMAGE("adeicon/bitlib.bmp",136,85,16,16) IN FRAME {&FRAME-NAME}.
 
  /* Do not view object until resizing is done later to prevent flashing */
  {set hideoninit TRUE}.
  RUN SUPER.

  
   /* Subscribe to events for maintaining states */
  SUBSCRIBE TO "setMode":U IN THIS-PROCEDURE NO-ERROR.
  SUBSCRIBE TO "setMode":U IN h_tempdbedit NO-ERROR.
  SUBSCRIBE TO "stateChanged":U IN THIS-PROCEDURE NO-ERROR.
  SUBSCRIBE TO "stateChanged":U IN h_tempdbedit NO-ERROR.
  
  /* Check whether Dynamics is running */
  ASSIGN glDynamicsRunning = DYNAMIC-FUNCTION("IsICFRunning":U) NO-ERROR.
  IF glDynamicsRunning = ? THEN glDynamicsRunning = NO.
  /* If Dynamics is running, add dynamics specific options */
  IF glDynamicsRunning THEN
      RUN initDynamics IN THIS-PROCEDURE.

  /* Load window icons */
  IF glDynamicsRunning THEN
      {&WINDOW-NAME}:LOAD-ICON("adeicon/icfdev.ico":U) NO-ERROR.
  ELSE
      {&WINDOW-NAME}:LOAD-ICON("adeicon/uib%.ico":U) NO-ERROR.
  
  RUN getBrowsePreference.
 
  RUN BuildMenu IN THIS-PROCEDURE.  
 
  STATUS INPUT OFF.

  
  RUN rebuildBrowse IN THIS-PROCEDURE.
  
  
  
  APPLY "VALUE-CHANGED":U TO {&BROWSE-NAME} IN FRAME {&FRAME-NAME}.
  IF glUseLog THEN
    ASSIGN fiLog:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gcLogFile
           btnLog:SENSITIVE = TRUE.
 ELSE 
    ASSIGN btnLog:SENSITIVE = FALSE
           fiLog:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

  RUN viewObject.
  
  RUN checkDBReference IN THIS-PROCEDURE (NO).
 
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE moveToTop wWin 
PROCEDURE moveToTop :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{&WINDOW-NAME}:MOVE-TO-TOP().

IF {&WINDOW-NAME}:WINDOW-STATE = WINDOW-MINIMIZED THEN
   {&WINDOW-NAME}:WINDOW-STATE = WINDOW-NORMAL.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenDocument wWin 
PROCEDURE OpenDocument :
/*------------------------------------------------------------------------------
  Purpose:     Opens a specified documenet
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcDocument AS CHARACTER  NO-UNDO.

def var executable as char  no-undo.
def var hInstance as integer  no-undo.

FILE-INFO:FILE-NAME = pcDocument.
IF FILE-INFO:FULL-PATHNAME = ? THEN
DO:
  MESSAGE "Cannot find file '" pcDocument "'" 
      VIEW-AS ALERT-BOX WARNING  BUTTONS OK.
  RETURN.
END.
/* find the associated executable in registry */
Executable = fill("x", 255). /* Dallocate memory */
run FindExecutableA  (pcDocument,
                      "",
                    input-output Executable,
                    output hInstance).

/* if not found, show the OpenAs dialog from the Explorer */
if hInstance > 0 and hInstance<= 32 then
  run ShellExecuteA (0,
                     "open",
                     "rundll32.exe",
                     "shell32.dll,OpenAs_RunDLL " + pcDocument,
                     "",
                     1,
                     output hInstance).

/* now open the pcDocument. If the user canceled the OpenAs dialog,
this ShellExecute call will silently fail */

run ShellExecuteA (0,
                   "open",
                    pcDocument,
                    "",
                    "",
                    1,
                    output hInstance).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenFile wWin 
PROCEDURE OpenFile :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF AVAIL ttTempDB AND NOT CAN-DO(ttTempDB.ttStatusCode,"F" ) THEN 
DO:
   RUN setstatus IN _h_UIB (?, "Opening file...") .
   RUN adeuib/_open-w.p  (TRIM(ttTempDB.ttSourceFile), "", "WINDOW":U) .
   RUN setstatus IN _h_UIB ("":U, "":U) .
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PreferenceRun wWin 
PROCEDURE PreferenceRun :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lOK      AS LOGICAL    NO-UNDO.


RUN adeuib/_tempdbpref.w (OUTPUT lok) NO-ERROR.

IF lOK THEN
   RUN getPreference IN THIS-PROCEDURE.

   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE printFile wWin 
PROCEDURE printFile :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lPrinted      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cFullPathName AS CHARACTER   NO-UNDO.

IF AVAIL ttTempDB THEN
DO:
  ASSIGN FILE-INFO:FILE-NAME = ttTempDB.ttSourceFile
         cFullPathName       = FILE-INFO:FULL-PATHNAME.
  IF cFullPathName <> ?  THEN
     RUN adeuib/_abprint.p ( INPUT cFullPathName,
                             INPUT {&WINDOW-NAME}:HANDLE,
                             INPUT cFullPathName,
                             INPUT ?,
                             OUTPUT lPrinted ) .

END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rebuildBrowse wWin 
PROCEDURE rebuildBrowse :
/*------------------------------------------------------------------------------
  Purpose:     Returns the ttTEMPDB database and refreshes the browse.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cFile   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hFile   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTempDB AS HANDLE     NO-UNDO.
DEFINE VARIABLE Lok     AS LOGICAL     NO-UNDO.

RUN ConnectDB(OUTPUT lok).
IF NOT lok THEN RETURN.



RUN adeuib/_tempdbawarelib.p PERSISTENT SET hTempdb.
IF NOT VALID-HANDLE(hTempDB) THEN RETURN "ERROR":U.
RUN BuildTempDBBrowse IN hTempDB (INPUT-OUTPUT TABLE ttTempDB).
DELETE PROCEDURE hTempDB.

{&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
 lOK = {&BROWSE-NAME}:SET-REPOSITIONED-ROW 
    (MAX(1, {&BROWSE-NAME}:FOCUSED-ROW), "CONDITIONAL") IN FRAME {&FRAME-NAME}.

IF gcMode = "Edit":U THEN
DO:
  FIND ttTempDB WHERE ttTempDB.ttTableID = gcLastTable NO-ERROR.
  IF AVAIL ttTempDB THEN 
  DO:
     REPOSITION {&BROWSE-NAME} TO ROWID(ROWID(ttTempDB)).
     {&BROWSE-NAME}:SELECT-FOCUSED-ROW() IN FRAME {&FRAME-NAME}.
  END.
  ELSE DO:
    FIND FIRST ttTempDB NO-ERROR.
    /* If no record is available, go into add mode */
    IF NOT AVAIL ttTempDB THEN
    DO:
      PUBLISH "setMode":U ("Add").
      PUBLISH "stateChanged".
    END.
    ELSE DO:
       REPOSITION {&BROWSE-NAME} TO ROWID(ROWID(ttTempDB)).
       {&BROWSE-NAME}:SELECT-FOCUSED-ROW() IN FRAME {&FRAME-NAME}.
    END.
  END.
END.
ELSE IF gcMode = "Add" THEN
DO:
  hFile = getFileLabel().
  IF VALID-HANDLE(hFile) THEN
     cFile = hFile:SCREEN-VALUE.
  RUN adecomm/_relname.p (cFile,"MUST-BE-REL",OUTPUT cFile).
  FIND ttTempDB WHERE ttTempDB.ttSourceFile = cFile NO-ERROR.
  IF AVAIL ttTempDB THEN 
  DO:
     REPOSITION {&BROWSE-NAME} TO ROWID(ROWID(ttTempDB)).
    {&BROWSE-NAME}:SELECT-FOCUSED-ROW() IN FRAME {&FRAME-NAME}.
  END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rebuildLoop wWin 
PROCEDURE rebuildLoop :
/*------------------------------------------------------------------------------
  Purpose:     Loops through all selected records and rebuild them.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lBrwReturn AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hCompare   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cResult    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lChoice    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cLastTable AS CHARACTER  NO-UNDO.

  IF {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} > 0 THEN
  DO:
    IF AVAIL ttTempDB AND NOT CAN-DO(ttTempDB.ttStatusCode,"F":U) THEN
    DO:
       MESSAGE "Are you sure you want to rebuild " 
             + IF {&BROWSE-NAME}:NUM-SELECTED-ROWS > 1 
               THEN "all selected source files?"
               ELSE "the selected file '" + ttTempDB.ttSourceFile + "'"
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lchoice.
       IF NOT lchoice THEN
          RETURN.
    END.
    ELSE RETURN.
    
    ASSIGN cLastTable = IF AVAIL ttTempDB THEN ttTempDB.ttTableID
                                          ELSE "".
    RUN StartLog IN TARGET-PROCEDURE.
    DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
      lBrwReturn = {&BROWSE-NAME}:FETCH-SELECTED-ROW(i).
      GET CURRENT {&BROWSE-NAME} NO-LOCK.
      IF AVAIL ttTempDB AND NOT CAN-DO(ttTempDB.ttStatusCode,"F":U) THEN
      DO:
        /* Compare selected source with table */
        RUN rebuildFromFile IN THIS-PROCEDURE (ttTempDB.ttSourceFile, No). /* DO not rebuild browse. Do it at end */ 
        
        IF RETURN-VALUE > ""  THEN
        DO:
          /* Set the temp table status field to indicate a mismatch */
          IF NOT CAN-DO (ttTempDB.ttStatusCode,"X":U) THEN
             ASSIGN ttTempDB.ttSTatusCode = ttTempDB.ttSTatusCode + "X":U
                    ttTempDB.ttStatus     = ttTempDB.ttStatus + (IF ttTempDB.ttStatus = "" THEN "" ELSE ";")
                                                   + "Mismatched record".
          BELL.
          STATUS DEFAULT "Rebuild Error".

        END.
        ELSE DO:
            ASSIGN ttTempDB.ttStatusCode = REPLACE(ttTempDB.ttSTatusCode,"X":U,"")
                   ttTempDB.ttStatus     = REPLACE(ttTempDB.ttSTatus,";Mismatched record":U,"")
                   ttTempDB.ttStatus     = REPLACE(ttTempDB.ttSTatus,"Mismatched record":U,"").
            STATUS DEFAULT "Rebuild Complete".
        END.
      END.
    END.

    RUN rebuildBrowse IN TARGET-PROCEDURE NO-ERROR.

    {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
    IF cLastTable > "" THEN
    DO: 
        FIND ttTempdb WHERE ttTempdb.ttTableid = cLastTable NO-ERROR.
        IF AVAIL ttTempDB THEN DO:
           REPOSITION {&BROWSE-NAME} TO ROWID(ROWID(ttTempDB)) NO-ERROR.
           {&BROWSE-NAME}:SELECT-FOCUSED-ROW().
        END.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshBrowse wWin 
PROCEDURE refreshBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE rCurRowID AS ROWID      NO-UNDO.

 IF AVAIL ttTempDB THEN
    ASSIGN rCurRowID = ROWID(ttTempDB) NO-ERROR.
 {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}

 IF NOT AVAIL ttTempDB THEN
 DO:
    RUN clearEditor IN h_tempdbEdit.
 END.
 ELSE IF rCurRowID <> ? THEN
      REPOSITION {&BROWSE-NAME} TO ROWID(rCurRowid).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject wWin 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     Resizes the objects to fit in the specified width and height
  Parameters:  pdHeight   Window Height
               pdWidth    Window Width
  Notes:       Called from WINDOW-RESIZE trigger and initializeObject
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pdHeight AS DECIMAL NO-UNDO.
DEFINE INPUT  PARAMETER pdWidth AS DECIMAL  NO-UNDO.

DEFINE VARIABLE hFrame        AS HANDLE  NO-UNDO.
DEFINE VARIABLE iCurrentPage  AS INTEGER    NO-UNDO.
DEFINE VARIABLE dFolderWidth  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dFolderHeight AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dFolderRow    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dFOlderCol    AS DECIMAL    NO-UNDO.

&SCOPED-DEFINE Browse-Margin-Bottom .4
&SCOPED-DEFINE Margin-Sides 1.5

ASSIGN hFrame                = FRAME {&FRAME-NAME}:HANDLE
       hFrame:SCROLLABLE     = TRUE
       hFrame:WIDTH          = MAX(hFrame:WIDTH, pdWidth - hFrame:COL + 1)
       hFrame:HEIGHT         = MAX(hFrame:HEIGHT, pdHeight - hFrame:ROW + 1)
       hFrame:VIRTUAL-WIDTH  = hFrame:WIDTH
       hFrame:VIRTUAL-HEIGHT = hFrame:HEIGHT
       hFrame:SCROLLABLE     = FALSE
       RectTop:WIDTH         = pdWidth - RectTop:COL 
       Rectbottom:WIDTH      = pdWidth - RectBottom:COL 
       btnExit:COL           = MAX(coFilter:COL + 20, pdWidth - btnExit:WIDTH - 1)
       coFilter:WIDTH        = MAX(20,BtnExit:COL - BtnImport:COL - BtnImport:WIDTH - 10)
       Brwmain:COL           = {&Margin-Sides} + 1
       BrwMain:WIDTH         = pdWidth - brwMain:COL - {&Margin-Sides} + 1
       BrwMain:HEIGHT        = MAX(8, (pdHeight -  BrwMain:ROW) / 4) 
       fiLog:ROW             = MAX(brwMain:ROW + brwMain:HEIGHT + 5,pdHeight - .3)
       fiLog:SIDE-LABEL-HANDLE:ROW = fiLog:ROW
       btnLog:ROW            = fiLog:ROW
       dFolderHeight          = MAX(5,pdHeight - BrwMain:ROW - brwMain:HEIGHT - {&Browse-Margin-Bottom} - .5)
       dFolderWidth          =  pdWidth - BrwMain:COL - {&Margin-Sides} + 1
       dFolderRow            = BrwMain:ROW + brwMain:HEIGHT + {&Browse-Margin-Bottom}
       dFolderCol            = BrwMain:COL
       fiLog:WIDTH           = MAX(50, pdWidth - fiLog:COL  - 5.5)
       btnLog:COL            = fiLog:COL + fiLog:WIDTH + .1
       NO-ERROR.


RUN repositionObject IN h_folder(dFolderRow, dFolderCol).
RUN resizeObject IN h_folder(dFolderHeight, dFolderWidth).

/* Resize and reposition viewer */
IF VALID-HANDLE(h_tempdbedit) THEN 
DO:
   RUN resizeObject IN h_tempdbedit(dFolderHeight,dFolderWidth).
   RUN repositionObject IN h_tempdbedit(dFolderRow + 1.5, dFolderCol + 1.5).
END.

IF VALID-HANDLE(h_tempdbimport) THEN 
DO:
   RUN resizeObject IN h_tempdbimport(dFolderHeight,dFolderWidth).
   RUN repositionObject IN h_tempdbimport(dFolderRow + 1.5, dFolderCol + 1.5).
END.

/* Only run code when coming from trigger Window-Resized, otherwise the currentpage 
   is not yet set */
IF NOT PROGRAM-NAME(2) BEGINS "InitializeObject":U THEN
DO:
  {get Currentpage iCurrentPage}.
  IF iCurrentPage = 1 THEN 
  DO:
    RUN showCurrentPage IN h_folder (2).
    RUN showCurrentPage IN h_folder (1).
  END.
  ELSE DO:
    RUN showCurrentPage IN h_folder (1).
    RUN showCurrentPage IN h_folder (2).
  END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectPage wWin 
PROCEDURE selectPage :
/*------------------------------------------------------------------------------
  Purpose:     Manage page resize
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER piPageNum AS INTEGER NO-UNDO.
  
  DEFINE VARIABLE lNewInit      AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE dFolderHeight AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dFolderWidth  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dFolderRow    AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dFolderCol    AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iReturnCode   AS INTEGER    NO-UNDO.
  
  &SCOPED-DEFINE Browse-Margin-Bottom .4
  &SCOPED-DEFINE Margin-Sides 1.5
  
  IF piPageNum = 2 THEN
  DO:
    {get Editor ghEditor h_tempdbEdit}.
    RUN CheckModified (ghEditor).
    IF RETURN-VALUE BEGINS "CANCEL":U THEN
        RETURN NO-APPLY.

  END.

  /* Check whetehr 2nd page has already been initialized */
  lNewInit = NOT VALID-HANDLE(h_tempdbimport).

  /* Lock Window to prevent flashing when resizing. */
  IF {&WINDOW-NAME}:HWND NE ? THEN
     RUN lockWindowUpdate  (INPUT {&WINDOW-NAME}:HWND, OUTPUT iReturnCode).

  
  RUN SUPER( INPUT piPageNum).

  /* Code placed here will execute AFTER standard behavior.    */
  IF lNewInit AND piPageNum = 2 AND VALID-HANDLE(h_tempdbimport) THEN 
  DO WITH FRAME {&FRAME-NAME}:
  ASSIGN
     dFolderHeight  = MAX(5,{&WINDOW-NAME}:HEIGHT - BrwMain:ROW - brwMain:HEIGHT - {&Browse-Margin-Bottom} - .5)
     dFolderWidth   =  {&WINDOW-NAME}:WIDTH - BrwMain:COL - {&Margin-Sides} + 1
     dFolderRow     = BrwMain:ROW + brwMain:HEIGHT + {&Browse-Margin-Bottom}
     dFolderCol     = BrwMain:COL.

  
   /* Resize and reposition viewer */
   RUN resizeObject IN h_tempdbimport(dFolderHeight,dFolderWidth).
   RUN repositionObject IN h_tempdbimport(dFolderRow + 1.5, dFolderCol + 1.5).

   
  END.
  /* Unlock window */
  RUN lockWindowUpdate (0, OUTPUT iReturnCode).
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFilter wWin 
PROCEDURE setFilter :
/*------------------------------------------------------------------------------
  Purpose:     called when the filter combo is changed
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
CASE coFilter:SCREEN-VALUE IN FRAME {&FRAME-NAME}:
    WHEN "0":U THEN /* All records */
        OPEN QUERY {&BROWSE-NAME} FOR EACH ttTempDB WHERE ttProcedure = THIS-PROCEDURE BY gcSortBy.

    WHEN "1":U THEN  /* Maintained records in control file */
        OPEN QUERY {&BROWSE-NAME} FOR EACH ttTempDB WHERE ttProcedure = THIS-PROCEDURE
                                  AND NOT CAN-DO(ttTempDB.ttStatusCode,"o":U) 
                                  AND NOT CAN-DO(ttTempDB.ttStatusCode,"C":U) BY gcSortBy. 

    WHEN "2":U THEN  /* Unmaintained records. in Schema but not in ctrl file */
        OPEN QUERY {&BROWSE-NAME} FOR EACH ttTempDB WHERE ttProcedure = THIS-PROCEDURE 
                                  AND (CAN-DO(ttTempDB.ttStatusCode,"o":U) 
                                   OR CAN-DO(ttTempDB.ttStatusCode,"C":U))  BY gcSortBy. 

    WHEN "3":U THEN  /* Source file not found */
        OPEN QUERY {&BROWSE-NAME} FOR EACH ttTempDB WHERE ttProcedure = THIS-PROCEDURE 
                                  AND CAN-DO(ttTempDB.ttStatusCode,"F":U )  BY gcSortBy.                

    WHEN "4":U THEN  /* Mismatched records */
        OPEN QUERY {&BROWSE-NAME} FOR EACH ttTempDB WHERE ttProcedure = THIS-PROCEDURE 
                                  AND CAN-DO(ttTempDB.ttStatusCode,"X":U)  BY gcSortBy. 

   WHEN "5":U THEN  /* Matched records */
        OPEN QUERY {&BROWSE-NAME} FOR EACH ttTempDB WHERE ttProcedure = THIS-PROCEDURE 
                                  AND CAN-DO(ttTempDB.ttStatusCode,"M":U)  BY gcSortBy. 

  

END CASE.
IF AVAIL ttTempDB THEN 
   {&BROWSE-NAME}:SELECT-ROW(1).  
ELSE
    RUN ClearEditor IN h_tempdbEdit.
APPLY "VALUE-CHANGED":U TO {&BROWSE-NAME}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setMode wWin 
PROCEDURE setMode :
/*------------------------------------------------------------------------------
  Purpose:     Sets the edit/add mode accordingly.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcMode AS CHARACTER  NO-UNDO.

ASSIGN gcMode = pcMode.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setPreference wWin 
PROCEDURE setPreference :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cValue   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSection AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumns AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDel     AS CHARACTER  NO-UNDO INIT "|".


ASSIGN cSection = "ProAB":U.

ASSIGN cValue = TRIM(STRING(SESSION:WIDTH-PIXELS,">>999")) + "X"
                 + TRIM(STRING(SESSION:HEIGHT-PIXELS,">>999")) + cDel
                 + STRING({&WINDOW-NAME}:WIDTH) + cDel
                 + STRING({&WINDOW-NAME}:HEIGHT) + cDel
                 + STRING({&WINDOW-NAME}:X) + cDel
                 + STRING({&WINDOW-NAME}:Y) .
PUT-KEY-VALUE SECTION cSection KEY "TempDBWindow":U VALUE cValue.

ASSIGN cCOlumns =  STRING(ttTableName:WIDTH IN BROWSE {&BROWSE-NAME}) + cDel
                 + STRING(ttSourceFile:WIDTH IN BROWSE {&BROWSE-NAME}) + cDel
                 + STRING(ttUseInclude:WIDTH IN BROWSE {&BROWSE-NAME}) + cDel
                 + STRING(ttTableDate:WIDTH IN BROWSE {&BROWSE-NAME}) + cDel
                 + STRING(ttFileChanged:WIDTH IN BROWSE {&BROWSE-NAME}) + cDel
                 + STRING(ttStatus:WIDTH IN BROWSE {&BROWSE-NAME}).
IF VALID-HANDLE(ghEntity) THEN
    cColumns = cColumns + cDel + STRING(ghEntity:WIDTH).
IF VALID-HANDLE(ghUserMod) THEN
    cColumns = cColumns + cDel + STRING(ghUserMod:WIDTH).

PUT-KEY-VALUE SECTION cSection KEY "TempDBBrowseCols":U VALUE cColumns.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startSearch wWin 
PROCEDURE startSearch :
/*------------------------------------------------------------------------------
  Purpose:     reSorts the browse based on the current column
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hColumn AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRow    AS ROWID      NO-UNDO.
  
  DEFINE VARIABLE cQuery  AS CHARACTER  NO-UNDO.

  SESSION:SET-WAIT-STATE("GENERAL":U).

  /* Get handle to current column and save current position in browser */
  ASSIGN hColumn = {&BROWSE-NAME}:CURRENT-COLUMN IN FRAME {&FRAME-NAME}
         hQuery  = {&BROWSE-NAME}:QUERY
         hBuffer = hQuery:GET-BUFFER-HANDLE(1)
         rRow    = hBuffer:ROWID
         NO-ERROR.

  /* Handle to current column is valid */
  IF VALID-HANDLE(hColumn) 
  THEN DO:
      /* Construct sort string */
      ASSIGN gcSortBy = (IF hColumn:TABLE <> ? 
                        THEN hColumn:TABLE + '.':U + hColumn:NAME
                        ELSE hColumn:NAME).

      /* Construct query string using sort string, then open query */
      ASSIGN cQuery = "FOR EACH ":U + hBuffer:NAME + " NO-LOCK BY ":U + gcSortBy.

      IF hQuery:IS-OPEN THEN hQuery:QUERY-CLOSE().
      hQuery:QUERY-PREPARE(cQuery).
      hQuery:QUERY-OPEN().

      /* If new result set contains data, then reposition to the record in the browser saved in rRow */
      IF hQuery:NUM-RESULTS > 0 
      THEN DO:
          hQuery:REPOSITION-TO-ROWID(rRow) NO-ERROR.
          {&BROWSE-NAME}:CURRENT-COLUMN = hColumn.
          APPLY 'VALUE-CHANGED':U TO {&BROWSE-NAME}.
      END.
  END.
  SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE stateChanged wWin 
PROCEDURE stateChanged :
/*------------------------------------------------------------------------------
  Purpose:     Changes state of buttons on toolbar.
  Parameters:  <none>
  Notes:       ttStatusCode:
               Status Codes:
                 C - Control record not found for table in TEMP-DB
                 O - Orphan record in control file has Table that is not in TEMP-DB
                 F - File not found in disk
                 M - Matching File
                 X - Mismatched file
               
------------------------------------------------------------------------------*/
DEFINE VARIABLE lValidRec    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lValidTable  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lValidSource AS LOGICAL    NO-UNDO.

IF AVAILABLE ttTempDB AND gcMode = "Edit":U THEN
    ASSIGN lValidRec    = TRUE
           lValidSource = IF CAN-DO(ttTempDB.ttStatusCode,"C":U) OR CAN-DO(ttTempDB.ttStatusCode,"F")
                          THEN FALSE ELSE TRUE
           lValidTable  = IF ttTempDB.ttTableName > "" AND NOT CAN-DO(ttTempDB.ttStatusCode,"o":U)
                          THEN TRUE ELSE FALSE.
ELSE 
    ASSIGN lValidRec    = FALSE
           lValidTable  = FALSE
           lValidSOurce = FALSE.

DO WITH FRAME {&FRAME-NAME}:
  ASSIGN btnView:SENSITIVE      = lValidTable
         btnOpen:SENSITIVE      = lValidSource 
         btnCompare:SENSITIVE   = lValidSource AND lValidTable 
         btnRebuild:SENSITIVE   = lValidSource
         btnImport:SENSITIVE    = lValidSource AND lValidTable 
         ghmenuPrint:SENSITIVE  = lValidRec
         ghmenuEntity:SENSITIVE = btnImport:SENSITIVE
         ghmenuPrint:SENSITIVE  = lValidSOurce
         MENU-ITEM m_Undo:SENSITIVE             IN MENU m_Edit = lValidSource OR gcMode = "Add":U
         MENU-ITEM m_Undo_All:SENSITIVE         IN MENU m_Edit = lValidSource OR gcMode = "Add":U
         MENU-ITEM m_Cut:SENSITIVE              IN MENU m_Edit = lValidSource OR gcMode = "Add":U
         MENU-ITEM m_Copy:SENSITIVE             IN MENU m_Edit = lValidSource OR gcMode = "Add":U
         MENU-ITEM m_Paste:SENSITIVE            IN MENU m_Edit = lValidSource OR gcMode = "Add":U
         SUB-MENU  m_Insert:SENSITIVE           IN MENU m_Edit = lValidSource OR gcMode = "Add":U
         SUB-MENU  m_Format:SENSITIVE           IN MENU m_Edit = lValidSource OR gcMode = "Add":U
         SUB-MENU  m_New:SENSITIVE              IN MENU m_File = gcMode = "Edit":U 
         MENU-ITEM m_Save:SENSITIVE             IN MENU m_File = lValidSource OR gcMode = "Add":U
         MENU-ITEM m_view_temp-table:SENSITIVE  IN MENU m_File = btnView:SENSITIVE
         MENU-ITEM m_open_source_file:SENSITIVE IN MENU m_File = lValidSource
         MENU-ITEM m_compare:SENSITIVE          IN MENU m_File = btnCompare:SENSITIVE
         MENU-ITEM m_check_syntax:SENSITIVE     IN MENU m_File = lValidSource OR (gcMode = "Add":U)
         MENU-ITEM m_rebuild:SENSITIVE          IN MENU m_File = btnRebuild:SENSITIVE
         MENU-ITEM m_delete:SENSITIVE           IN MENU m_File = lValidRec
         
         NO-ERROR.
      
END.

IF gcMode = "Add":U AND {&BROWSE-NAME}:NUM-SELECTED-ROWS > 0 THEN
    {&BROWSE-NAME}:DESELECT-ROWS().
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseHandle wWin 
FUNCTION getBrowseHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN {&BROWSE-NAME}:HANDLE IN FRAME {&FRAME-NAME}.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEditor wWin 
FUNCTION getEditor RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN DYNAMIC-FUNC("getEditor":U IN h_tempdbedit).
  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEditorProc wWin 
FUNCTION getEditorProc RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN h_tempdbEdit.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFileLabel wWin 
FUNCTION getFileLabel RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the fill-in containing the file name
    Notes:  
------------------------------------------------------------------------------*/
  RETURN DYNAMIC-FUNC("getFileLabel":U IN h_tempdbEdit).
  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFileName wWin 
FUNCTION getFileName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Return the filename.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFileName AS CHARACTER  NO-UNDO.
  
  IF gcMode = "ADD":U OR NOT AVAIL ttTempDB THEN
     RETURN ?.
  ELSE 
     RETURN ttTempDB.ttSourceFile.
  


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMode wWin 
FUNCTION getMode RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the edit/add mode of variable gcmode 
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gcMode.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

