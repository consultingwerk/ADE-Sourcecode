&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME LoadSave_Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS LoadSave_Win 
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

  File: _smoupg.w

  Description: SmartObject Load and Save Utility

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Gerry Seidl

  Created: Sept. 12, 1996

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

/*CREATE WIDGET-POOL.*/

/* ***************************  Definitions  ************************** */
{adeuib/sharvars.i}
{protools/ptlshlp.i}
{adecomm/_adetool.i}
{protools/_runonce.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE hStatusLine AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE iDummy      AS INTEGER       NO-UNDO.
DEFINE VARIABLE inprocess   AS LOGICAL       NO-UNDO INIT NO.

DEFINE TEMP-TABLE FilesToProcess
  FIELD FileName AS CHARACTER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME loadsave

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 FileSpec SOTypes Suppress Dir ~
btn_BrowseDir Recursive Btn_Start_Upgrade 
&Scoped-Define DISPLAYED-OBJECTS FileSpec SOTypes Suppress Dir Recursive 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR LoadSave_Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_File 
       MENU-ITEM m_Exit         LABEL "E&xit"         .

DEFINE SUB-MENU m_Help 
       MENU-ITEM m_OpenEdge_Master_Help LABEL "OpenEdge &Master Help"
       MENU-ITEM m_Contents     LABEL "PRO*Tools &Help Topics"
       MENU-ITEM m_Tool_Help    LABEL "&SmartObject Upgrade Utility Help" ACCELERATOR "F1"
       RULE
       MENU-ITEM m_About_SmartObject_Upgrade_U LABEL "&About SmartObject Upgrade Utility".

DEFINE MENU MENU-BAR-LoadSave_Win MENUBAR
       SUB-MENU  m_File         LABEL "&File"         
       SUB-MENU  m_Help         LABEL "&Help"         .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btn_BrowseDir 
     LABEL "&Browse..." 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_Start_Upgrade 
     LABEL "&Start Upgrade" 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_Stop_Upgrade 
     LABEL "Sto&p Upgrade" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE Dir AS CHARACTER FORMAT "X(256)":U INITIAL "." 
     VIEW-AS FILL-IN 
     SIZE 43 BY 1.1 NO-UNDO.

DEFINE VARIABLE FileSpec AS CHARACTER FORMAT "X(256)":U INITIAL "*.W" 
     VIEW-AS FILL-IN 
     SIZE 27 BY 1 NO-UNDO.

DEFINE VARIABLE SOTypes AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "&Non-container SmartObjects", 1,
"S&martFrames && SmartDialogs", 2,
"Smart&Windows", 3
     SIZE 31 BY 1.86 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 63 BY 2.67.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 63 BY 2.95.

DEFINE VARIABLE Recursive AS LOGICAL INITIAL yes 
     LABEL "&Include Subdirectories" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .76 NO-UNDO.

DEFINE VARIABLE Suppress AS LOGICAL INITIAL yes 
     LABEL "&Suppress compile" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .76 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME loadsave
     FileSpec AT ROW 2.1 COL 2 COLON-ALIGNED HELP
          "Enter the file specification to use (e.g. *.W)" NO-LABEL
     SOTypes AT ROW 1.81 COL 33 HELP
          "Select the type of SmartObjects to upgrade" NO-LABEL
     Suppress AT ROW 3.14 COL 4
     Dir AT ROW 5.05 COL 2 COLON-ALIGNED HELP
          "Enter the starting directory of your SmartObjects" NO-LABEL
     btn_BrowseDir AT ROW 5.05 COL 48 HELP
          "Browse for a starting directory"
     Recursive AT ROW 6.14 COL 4 HELP
          "Preform a recursive directory search"
     Btn_Start_Upgrade AT ROW 7.48 COL 14 HELP
          "Start the upgrade process"
     Btn_Stop_Upgrade AT ROW 7.48 COL 37 HELP
          "Stop the upgrade process"
     RECT-1 AT ROW 4.52 COL 2
     RECT-2 AT ROW 1.29 COL 2
     " Fi&leSpec" VIEW-AS TEXT
          SIZE 9 BY .81 AT ROW 1 COL 4
     " &Directory" VIEW-AS TEXT
          SIZE 10 BY .62 AT ROW 4.24 COL 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.2 ROW 1
         SIZE 64.2 BY 7.91.

 

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
  CREATE WINDOW LoadSave_Win ASSIGN
         HIDDEN             = YES
         TITLE              = "SmartObject Upgrade Utility"
         HEIGHT             = 7.91
         WIDTH              = 65
         MAX-HEIGHT         = 7.91
         MAX-WIDTH          = 65
         VIRTUAL-HEIGHT     = 7.91
         VIRTUAL-WIDTH      = 65
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MENU-BAR-LoadSave_Win:HANDLE.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT LoadSave_Win:LOAD-ICON("adeicon\smoupgrd":U) THEN
    MESSAGE "Unable to load icon: adeicon\smoupgrd"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */


&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW LoadSave_Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME loadsave
   Custom                                                               */
/* SETTINGS FOR BUTTON Btn_Stop_Upgrade IN FRAME loadsave
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(LoadSave_Win)
THEN LoadSave_Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */
&Scoped-define SELF-NAME LoadSave_Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LoadSave_Win LoadSave_Win
ON END-ERROR OF LoadSave_Win /* SmartObject Upgrade Utility */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LoadSave_Win LoadSave_Win
ON WINDOW-CLOSE OF LoadSave_Win /* SmartObject Upgrade Utility */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_BrowseDir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_BrowseDir LoadSave_Win
ON CHOOSE OF btn_BrowseDir IN FRAME loadsave /* Browse... */
DO:
  DEFINE VARIABLE d      AS CHARACTER INITIAL "^" NO-UNDO.
  DEFINE VARIABLE choice AS LOGICAL               NO-UNDO.
  
  SYSTEM-DIALOG GET-FILE d
          TITLE      "Enter starting directory for upgrade ..."
          FILTERS    "All Files (*.*)"   "*.*"
          USE-FILENAME
          UPDATE choice.
  
  IF choice THEN DO:
    IF SUBSTRING(d,LENGTH(d),1) = "^" THEN d = SUBSTRING(d,1,LENGTH(d) - 1).
    ASSIGN dir:SCREEN-VALUE = d.
  END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Start_Upgrade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Start_Upgrade LoadSave_Win
ON CHOOSE OF Btn_Start_Upgrade IN FRAME loadsave /* Start Upgrade */
DO:
  ASSIGN filespec sotypes dir recursive suppress.
  
  IF filespec = ? OR filespec = "" THEN DO:
    MESSAGE "Please enter a filespec." VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO filespec IN FRAME {&FRAME-NAME}.
    RETURN NO-APPLY.
  END.
  ELSE IF dir = ? OR dir = "" THEN DO:
    MESSAGE "Please enter a starting directory." VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO dir IN FRAME {&FRAME-NAME}.
    RETURN NO-APPLY.
  END.  
  
  RUN Sensitize (NO). /* Insensitize widgets */
  
  /* Clear the temp-table */
  FOR EACH FilesToProcess:
    DELETE FilesToProcess.
  END.
  
  /* Create a list of files */
  RUN CreateFileList (dir).
  
  IF NOT (CAN-FIND (FIRST FilesToProcess)) THEN DO:
    MESSAGE "No files match " + filespec VIEW-AS ALERT-BOX WARNING.
    RUN Sensitize (YES).
    APPLY "ENTRY" TO FileSpec IN FRAME {&FRAME-NAME}.
    RETURN NO-APPLY.
  END.
  ELSE IF RETURN-VALUE = "CANCEL" THEN DO:
    MESSAGE "SmartObject upgrade cancelled." VIEW-AS ALERT-BOX INFORMATION.
    RUN Sensitize (YES).
    APPLY "ENTRY" TO Dir IN FRAME {&FRAME-NAME}.
    RETURN NO-APPLY.
  END.
  
  IF suppress THEN THIS-PROCEDURE:PRIVATE-DATA = "SmartObject Upgrade Utility,YES".
  ELSE THIS-PROCEDURE:PRIVATE-DATA = "SmartObject Upgrade Utility,NO".
  
  ASSIGN inprocess                   = TRUE
         btn_start_upgrade:SENSITIVE = FALSE
         btn_stop_upgrade:SENSITIVE  = TRUE.
         
  /* Load, Save & Close each file in the list in the UIB */
  RUN upgrade.
  
  IF RETURN-VALUE <> "CANCEL" AND inprocess THEN 
    MESSAGE "SmartObject upgrade complete." VIEW-AS ALERT-BOX INFORMATION.
  ELSE
    MESSAGE "SmartObject upgrade cancelled." VIEW-AS ALERT-BOX INFORMATION.
    
  RUN Sensitize (YES). /* Re-sensitize widgets */
  
  ASSIGN btn_start_upgrade:SENSITIVE = TRUE
         btn_stop_upgrade:SENSITIVE  = FALSE
         inprocess                   = FALSE
         THIS-PROCEDURE:PRIVATE-DATA = "SmartObject Upgrade Utility,NO".
           
  APPLY "ENTRY" TO dir IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Stop_Upgrade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Stop_Upgrade LoadSave_Win
ON CHOOSE OF Btn_Stop_Upgrade IN FRAME loadsave /* Stop Upgrade */
DO:
  ASSIGN inprocess = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_About_SmartObject_Upgrade_U
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_About_SmartObject_Upgrade_U LoadSave_Win
ON CHOOSE OF MENU-ITEM m_About_SmartObject_Upgrade_U /* About SmartObject Upgrade Utility */
DO:
    RUN adecomm/_about.p (INPUT "SmartObject Upgrade Utility", INPUT "adeicon/smoupgrd").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Contents
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Contents LoadSave_Win
ON CHOOSE OF MENU-ITEM m_Contents /* Help Topics */
DO:
  RUN adecomm/_adehelp.p( "ptls", "TOPICS", {&SmartObject_Upgrade_Utility}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Exit LoadSave_Win
ON CHOOSE OF MENU-ITEM m_Exit /* Exit */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_OpenEdge_Master_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_OpenEdge_Master_Help LoadSave_Win
ON CHOOSE OF MENU-ITEM m_OpenEdge_Master_Help /* OpenEdge Master Help */
DO:
  RUN adecomm/_adehelp.p ( INPUT "mast",
                           INPUT "TOPICS",
                           INPUT ?,
                           INPUT ? ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Tool_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Tool_Help LoadSave_Win
ON CHOOSE OF MENU-ITEM m_Tool_Help /* SmartObject Upgrade Utility Help */
DO:
  RUN adecomm/_adehelp.p( "ptls", "CONTEXT", {&SmartObject_Upgrade_Utility}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME SOTypes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SOTypes LoadSave_Win
ON VALUE-CHANGED OF SOTypes IN FRAME loadsave
DO:
  CASE INTEGER(SELF:SCREEN-VALUE):
    WHEN 1 THEN FileSpec:SCREEN-VALUE = "b-*.w,v-*.w,q-*.w".
    WHEN 2 THEN FileSpec:SCREEN-VALUE = "f-*.w,d-*.w".
    WHEN 3 THEN FileSpec:SCREEN-VALUE = "w-*.w".
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK LoadSave_Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

ON ENTRY OF FileSpec, Dir, Btn_Start_Upgrade, Btn_Stop_Upgrade,
  btn_BrowseDir, Recursive
    RUN adecomm/_statdsp.p(hStatusLine, 1, SELF:HELP).         

ON ALT-L ANYWHERE
  APPLY "ENTRY" TO FileSpec IN FRAME {&FRAME-NAME}.
  
ON ALT-D ANYWHERE
  APPLY "ENTRY" TO Dir IN FRAME {&FRAME-NAME}.
      
/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN CreateStatusArea.
  RUN enable_UI.
  APPLY "ENTRY" TO dir IN FRAME {&FRAME-NAME}.
  APPLY "VALUE-CHANGED" TO sotypes IN FRAME {&FRAME-NAME}.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreateFileList LoadSave_Win 
PROCEDURE CreateFileList :
/*------------------------------------------------------------------------------
  Purpose:     Creates a list of files to process
  Parameters:  startdir (char)
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER startdir AS CHARACTER NO-UNDO.
   
   DEFINE VARIABLE basename AS CHARACTER NO-UNDO.
   DEFINE VARIABLE absname  AS CHARACTER NO-UNDO.
   DEFINE VARIABLE flags    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE i        AS INTEGER   NO-UNDO.
   
   RUN adecomm/_statdsp.p(hStatusLine,1, "Building file list...").

   /* Start reading the files from startdir */
   INPUT FROM OS-DIR(startdir) NO-ECHO.
   DIRLOOP:
   REPEAT ON ERROR UNDO, NEXT
          ON STOP  UNDO, RETURN "CANCEL":
     IMPORT basename absname flags.
     IF INDEX(flags,"D",1) > 0 AND /* check if it's a directory */
        basename <> "."        AND 
        basename <> ".."       THEN 
     DO:
       IF recursive THEN 
       DO ON STOP UNDO, RETURN "CANCEL": 
         RUN CreateFileList (absname). /* run recursive */
         NEXT DIRLOOP.
       END.
     END.
     CHK-FILESPEC:
     /* Look for a match in the filespec list */
     DO i = 1 TO NUM-ENTRIES(filespec) ON STOP UNDO, RETURN "CANCEL":
       IF basename MATCHES ENTRY(i,filespec) THEN 
       DO ON STOP UNDO, RETURN "CANCEL": /* process it in the UIB */
         CREATE FilesToProcess.
         ASSIGN FilesToProcess.FileName = absname.
         LEAVE CHK-FILESPEC. /* no need to look for anymore matches */
       END.
     END.     
   END.
   RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreateStatusArea LoadSave_Win 
PROCEDURE CreateStatusArea :
/*------------------------------------------------------------------------------
  Purpose:     Creates a status line in the window
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Make adjustment for Win95 font */
  IF SESSION:PIXELS-PER-COLUMN = 5 THEN 
    ASSIGN {&WINDOW-NAME}:WIDTH      = {&WINDOW-NAME}:WIDTH + 1
           FRAME {&FRAME-NAME}:WIDTH = FRAME {&FRAME-NAME}:WIDTH + 1.

  /* Create generic ADE status bar in the window */
  RUN adecomm/_status.p ( INPUT {&WINDOW-NAME}:HANDLE, 
                       INPUT "50", 
                       INPUT FALSE, 
                       INPUT (IF SESSION:PIXELS-PER-COLUMN = 5 THEN 4 ELSE ?), 
                       OUTPUT hStatusLine,
                       OUTPUT iDummy).
                      
  /* resize the window, and position the status bar */                    
  ASSIGN {&WINDOW-NAME}:HEIGHT-P = {&WINDOW-NAME}:HEIGHT-P + hStatusLine:HEIGHT-P
         hStatusLine:Y           = {&WINDOW-NAME}:HEIGHT-P - hStatusLine:HEIGHT-P
         hStatusLine:VISIBLE     = TRUE.
  

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI LoadSave_Win _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(LoadSave_Win)
  THEN DELETE WIDGET LoadSave_Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI LoadSave_Win _DEFAULT-ENABLE
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
  DISPLAY FileSpec SOTypes Suppress Dir Recursive 
      WITH FRAME loadsave IN WINDOW LoadSave_Win.
  ENABLE RECT-1 RECT-2 FileSpec SOTypes Suppress Dir btn_BrowseDir Recursive 
         Btn_Start_Upgrade 
      WITH FRAME loadsave IN WINDOW LoadSave_Win.
  {&OPEN-BROWSERS-IN-QUERY-loadsave}
  VIEW LoadSave_Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Sensitize LoadSave_Win 
PROCEDURE Sensitize :
/*------------------------------------------------------------------------------
  Purpose:     Turn widgets on and off
  Parameters:  mode (logical)
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER mode AS LOGICAL.

  DO WITH FRAME {&FRAME-NAME}:  
    ASSIGN filespec:SENSITIVE      = mode
           sotypes:SENSITIVE       = mode
           dir:SENSITIVE           = mode 
           recursive:SENSITIVE     = mode 
           suppress:SENSITIVE      = mode
           btn_BrowseDir:SENSITIVE = mode
           Btn_Start_Upgrade:SENSITIVE          = mode
           MENU MENU-BAR-LoadSave_Win:SENSITIVE = mode.
  END.
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Upgrade LoadSave_Win 
PROCEDURE Upgrade :
/*------------------------------------------------------------------------------
  Purpose:     Upgrade the SmartObjects by loading and saving
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   FOR EACH FilesToProcess ON STOP UNDO, RETRY:
     IF RETRY OR NOT inprocess THEN RETURN "CANCEL".
     RUN adecomm/_statdsp.p(hStatusLine,1, "Upgrading " + FilesToProcess.FileName).
     RUN adeuib/_open-w.p (FilesToProcess.FileName, "", "WINDOW").
     RUN choose_file_save in _h_uib.
     RUN choose_close in _h_uib.
     PROCESS EVENTS.
   END.
   RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

