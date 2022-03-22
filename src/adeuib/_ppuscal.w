&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME LoadSave_Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS LoadSave_Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _ppuscal.w

  Description: Utility to .w files that were built with the old PPU's

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Ross Hunter

  Created: Feb. 10, 1997
  
  Modified:
      04/15/99  tsm  Added support for Intl Numeric Formats (in addition to 
                     American and European).  Old pixels per column/row were
                     being converted to ensure that if the user is using 
                     European format "," is used for decimal point and if the
                     user is using American format "." is used.  Now we just
                     ensure that any numeric separator entered is converted
                     to a numeric-decimal-point for any format being used. 
                     
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
{adeuib/uniwidg.i}
{adeuib/layout.i}
{protools/ptlshlp.i}
{adecomm/_adetool.i}
{protools/_runonce.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE hStatusLine AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE iDummy      AS INTEGER       NO-UNDO.
DEFINE VARIABLE inprocess   AS LOGICAL       NO-UNDO INIT NO.
DEFINE VARIABLE x-fact      AS DECIMAL       NO-UNDO.
DEFINE VARIABLE y-fact      AS DECIMAL       NO-UNDO.

DEFINE TEMP-TABLE FilesToProcess
  FIELD FileName AS CHARACTER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME loadsave

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FileSpec old-ppc old-ppr Dir btn_BrowseDir ~
Recursive Scale-Options Btn_Start_Upgrade RECT-1 RECT-2 RECT-3 
&Scoped-Define DISPLAYED-OBJECTS FileSpec old-ppc old-ppr Dir Recursive ~
Scale-Options 

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
       MENU-ITEM m_Help_Topics  LABEL "PRO*Tools &Help Topics"
       MENU-ITEM m_Tool_Help    LABEL "&Screen Scaling Utility Help" ACCELERATOR "F1"
       RULE
       MENU-ITEM m_About_Screen_Scaling_U LABEL "&About Screen Scaling Utility".

DEFINE MENU MENU-BAR-LoadSave_Win MENUBAR
       SUB-MENU  m_File         LABEL "&File"         
       SUB-MENU  m_Help         LABEL "&Help"         .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btn_BrowseDir 
     LABEL "&Browse..." 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_Start_Upgrade 
     LABEL "&Start Scaling" 
     SIZE 19 BY 1.14.

DEFINE BUTTON Btn_Stop_Upgrade 
     LABEL "Sto&p Scaling" 
     SIZE 19 BY 1.14.

DEFINE VARIABLE Dir AS CHARACTER FORMAT "X(256)":U INITIAL "." 
     VIEW-AS FILL-IN 
     SIZE 46 BY 1.1 NO-UNDO.

DEFINE VARIABLE FileSpec AS CHARACTER FORMAT "X(256)":U INITIAL "*.W" 
     VIEW-AS FILL-IN 
     SIZE 29 BY 1 NO-UNDO.

DEFINE VARIABLE old-ppc AS CHARACTER FORMAT "X(5)":U INITIAL "7" 
     LABEL "Old Pixels-Per-&Column" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE old-ppr AS CHARACTER FORMAT "X(5)":U INITIAL "26" 
     LABEL "Old Pixels-Per-&Row" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE Scale-Options AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Reposition all controls, don't resize controls specified in pixels", 1,
"Only scale controls specified in Character Units", 2,
"Scale all controls", 3,
"Reposition all controls, don't resize controls with Images", 4
     SIZE 62 BY 3.1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 65 BY 2.67.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 65 BY 3.05.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 65 BY 4.24.

DEFINE VARIABLE Recursive AS LOGICAL INITIAL yes 
     LABEL "&Include Subdirectories" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .76 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME loadsave
     FileSpec AT ROW 1.95 COL 2 COLON-ALIGNED HELP
          "Enter the file specification to use (e.g. *.W)" NO-LABEL
     old-ppc AT ROW 1.95 COL 57 COLON-ALIGNED HELP
          "Enter the value of PIXELS-PER-COLUMN in effect in 8.1A."
     old-ppr AT ROW 3.14 COL 57 COLON-ALIGNED HELP
          "Enter the value of PIXELS-PER-ROW in effect in 8.1A."
     Dir AT ROW 5.38 COL 2 COLON-ALIGNED HELP
          "Enter the starting directory of your .w files." NO-LABEL
     btn_BrowseDir AT ROW 5.38 COL 51 HELP
          "Browse for a starting directory"
     Recursive AT ROW 6.48 COL 4 HELP
          "Preform a recursive directory search"
     Scale-Options AT ROW 8.86 COL 4 NO-LABEL
     Btn_Start_Upgrade AT ROW 12.91 COL 14 HELP
          "Start the scaling process"
     Btn_Stop_Upgrade AT ROW 12.91 COL 35 HELP
          "Stop the scaling process"
     RECT-1 AT ROW 4.86 COL 2
     RECT-2 AT ROW 1.24 COL 2
     RECT-3 AT ROW 8.19 COL 2
     " Fi&leSpec" VIEW-AS TEXT
          SIZE 9 BY .62 AT ROW 1 COL 4
     " &Directory" VIEW-AS TEXT
          SIZE 10 BY .62 AT ROW 4.57 COL 4
     " Scaling &Options" VIEW-AS TEXT
          SIZE 16 BY .81 AT ROW 7.91 COL 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.2 ROW 1
         SIZE 66.8 BY 13.33.


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
         TITLE              = "Screen Scaling Utility"
         HEIGHT             = 13.38
         WIDTH              = 67
         MAX-HEIGHT         = 13.38
         MAX-WIDTH          = 70
         VIRTUAL-HEIGHT     = 13.38
         VIRTUAL-WIDTH      = 70
         MAX-BUTTON         = no
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



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

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
ON END-ERROR OF LoadSave_Win /* Screen Scaling Utility */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LoadSave_Win LoadSave_Win
ON WINDOW-CLOSE OF LoadSave_Win /* Screen Scaling Utility */
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
          TITLE      "Enter starting directory for scaling ..."
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
ON CHOOSE OF Btn_Start_Upgrade IN FRAME loadsave /* Start Scaling */
DO:
  DEFINE VARIABLE doit AS LOGICAL               NO-UNDO.
  
  ASSIGN filespec dir recursive old-ppc old-ppr Scale-Options
         x-fact = ?
         y-fact = ?.
         
  /* If the user has entered a numeric separator in the old pixels per column or row
     we assume that it should be a decimal point and convert it */
  ASSIGN x-fact = DECIMAL(REPLACE(old-ppc,SESSION:NUMERIC-SEPARATOR,SESSION:NUMERIC-DECIMAL-POINT)) / 5.0 NO-ERROR.
  IF x-fact = ? OR x-fact <= 0 THEN DO:
    MESSAGE old-ppc "is an invalid value for pixels-per-column."
            VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO old-ppc IN FRAME {&FRAME-NAME}.
    RETURN NO-APPLY.
  END.
  ASSIGN y-fact = DECIMAL(REPLACE(old-ppr,SESSION:NUMERIC-SEPARATOR,SESSION:NUMERIC-DECIMAL-POINT)) / 21.0 NO-ERROR.
  IF y-fact = ? OR y-fact <= 0 THEN DO:
    MESSAGE old-ppr "is an invalid value for pixels-per-row."
            VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO old-ppr IN FRAME {&FRAME-NAME}.
    RETURN NO-APPLY.
  END.
   
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
  
  MESSAGE "You should have a backup of the files that you are" SKIP
          "about to scale as they will be over-written." SKIP (1)
          "Ok to proceed?" VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
          UPDATE doit.
 
  IF NOT doit THEN RETURN NO-APPLY.
  
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
    MESSAGE "Screen scaling cancelled." VIEW-AS ALERT-BOX INFORMATION.
    RUN Sensitize (YES).
    APPLY "ENTRY" TO Dir IN FRAME {&FRAME-NAME}.
    RETURN NO-APPLY.
  END.
  
  ASSIGN inprocess                   = TRUE
         btn_start_upgrade:SENSITIVE = FALSE
         btn_stop_upgrade:SENSITIVE  = TRUE.
         
  /* Load, Save & Close each file in the list in the UIB */
  RUN upgrade.
  
  IF RETURN-VALUE <> "CANCEL" AND inprocess THEN 
    MESSAGE "Screen scaling complete." VIEW-AS ALERT-BOX INFORMATION.
  ELSE
    MESSAGE "Screen scaling cancelled." VIEW-AS ALERT-BOX INFORMATION.
    
  RUN Sensitize (YES). /* Re-sensitize widgets */
  
  ASSIGN btn_start_upgrade:SENSITIVE = TRUE
         btn_stop_upgrade:SENSITIVE  = FALSE
         inprocess                   = FALSE
         THIS-PROCEDURE:PRIVATE-DATA = "Screen Scaling Utility,NO".
           
  APPLY "ENTRY" TO dir IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Stop_Upgrade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Stop_Upgrade LoadSave_Win
ON CHOOSE OF Btn_Stop_Upgrade IN FRAME loadsave /* Stop Scaling */
DO:
  ASSIGN inprocess = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_About_Screen_Scaling_U
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_About_Screen_Scaling_U LoadSave_Win
ON CHOOSE OF MENU-ITEM m_About_Screen_Scaling_U /* About Screen Scaling Utility */
DO:
    RUN adecomm/_about.p (INPUT "Screen Scaling Utility", INPUT "adeicon/smoupgrd").
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


&Scoped-define SELF-NAME m_Help_Topics
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Help_Topics LoadSave_Win
ON CHOOSE OF MENU-ITEM m_Help_Topics /* Help Topics */
DO:
  RUN adecomm/_adehelp.p( "ptls", "TOPICS", {&SmartObject_Upgrade_Utility}, ?).
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
ON CHOOSE OF MENU-ITEM m_Tool_Help /* Screen Scaling Utility Help */
DO:
  RUN adecomm/_adehelp.p( "ptls", "CONTEXT", {&Screen_Scaling_Utility}, ?).
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
  
ON ALT-O ANYWHERE
  APPLY "ENTRY" TO Scale-Options IN FRAME {&FRAME-NAME}.
      
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI LoadSave_Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI LoadSave_Win  _DEFAULT-ENABLE
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
  DISPLAY FileSpec old-ppc old-ppr Dir Recursive Scale-Options 
      WITH FRAME loadsave IN WINDOW LoadSave_Win.
  ENABLE FileSpec old-ppc old-ppr Dir btn_BrowseDir Recursive Scale-Options 
         Btn_Start_Upgrade RECT-1 RECT-2 RECT-3 
      WITH FRAME loadsave IN WINDOW LoadSave_Win.
  {&OPEN-BROWSERS-IN-QUERY-loadsave}
  VIEW LoadSave_Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE expand LoadSave_Win 
PROCEDURE expand :
/*------------------------------------------------------------------------------
  Purpose:  The procedure expands whatever widget it is handed   
  Parameters:  RECID(_U)
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER u-recid AS RECID   NO-UNDO.
   DEFINE VARIABLE resize         AS LOGICAL NO-UNDO.
   DEFINE BUFFER x_U FOR _U.

   FIND x_U  WHERE RECID(x_U) = u-recid.
   IF Scale-Options = 2 AND NOT x_U._LAYOUT-UNIT THEN RETURN.

   FIND _L WHERE _L._u-recid = u-recid AND
        _L._LO-NAME = "Master Layout":U NO-ERROR.

   IF AVAILABLE _L THEN DO:
   
     ASSIGN _L._COL = ((_L._COL - 1.0) * x-fact) + 1
            _L._ROW = ((_L._ROW - 1.0) * y-fact) + 1
            resize  = TRUE.

     IF Scale-Options EQ 1 AND NOT x_U._LAYOUT-UNIT THEN resize = FALSE.
     ELSE IF Scale-Options EQ 4 AND
             (x_U._TYPE = "IMAGE":U OR x_U._TYPE = "BUTTON") THEN DO:
       FIND _F WHERE RECID(_F) = x_U._x-recid.
       IF x_U._TYPE = "IMAGE":U OR
          (_F._IMAGE-FILE NE "" AND _F._IMAGE-FILE NE ?) THEN
         resize = FALSE.
     END.  /* IF option 4 and a button or image */
     IF resize THEN DO:
       ASSIGN _L._HEIGHT = _L._HEIGHT * y-fact
              _L._WIDTH  = _L._WIDTH * x-fact.
       IF _L._VIRTUAL-HEIGHT NE  ? THEN
         ASSIGN _L._VIRTUAL-HEIGHT = _L._VIRTUAL-HEIGHT * y-fact
                _L._VIRTUAL-WIDTH  = _L._VIRTUAL-WIDTH * x-fact.
     END. /* If we need to resize */
     
   END. /* If we have an _L */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE expand-flds LoadSave_Win 
PROCEDURE expand-flds :
/*------------------------------------------------------------------------------
  Purpose:  This procedure finds all field level widgets of a frame
            and calls expand for them.     
  Parameters:  u-recid of the frame
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER u-recid AS RECID NO-UNDO.
  DEFINE BUFFER x_U FOR _U.

  FOR EACH x_U where x_U._PARENT-RECID = u-recid AND
           x_U._TYPE NE "FRAME":U AND /* Frames are done elsewhere */
           RECID(x_U) NE u-recid: /* Dialog-box have be done elsewhere */
    RUN expand(INPUT RECID(x_U)).
  END.
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
    ASSIGN filespec:SENSITIVE                   = mode
           old-ppc:SENSITIVE                    = mode
           old-ppr:SENSITIVE                    = mode
           dir:SENSITIVE                        = mode 
           recursive:SENSITIVE                  = mode 
           btn_BrowseDir:SENSITIVE              = mode
           Scale-Options:SENSITIVE              = mode
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
  Purpose:     Upgrade the .ws by loading and saving
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE pos-cnvrt  AS LOGICAL                     NO-UNDO.
DEFINE VARIABLE size-cnvrt AS LOGICAL                     NO-UNDO.

DEFINE BUFFER f_U FOR _U.
DEFINE BUFFER w_U FOR _U.

   FOR EACH FilesToProcess ON STOP UNDO, RETRY:
     IF RETRY OR NOT inprocess THEN RETURN "CANCEL".
     RUN adecomm/_statdsp.p(hStatusLine,1, "Scaling " + FilesToProcess.FileName).
     RUN adeuib/_open-w.p (FilesToProcess.FileName, "", "WINDOW").
     
     /* Find Window _U to see if it is laid out in pixels */
     FIND w_U WHERE w_U._HANDLE = _h_win.
     /* Expand window or dialog-box */
     RUN expand(INPUT RECID(w_U)).
     
     IF w_U._TYPE = "DIALOG-BOX":U AND
       (w_U._LAYOUT-UNIT OR Scale-Options NE 2) THEN
       /* Expand the fields in the dialog */
       RUN expand-flds(INPUT RECID(w_U)).

     IF w_U._LAYOUT-UNIT OR Scale-Options NE 2 THEN DO:
       /* Now find all frames */
       FOR EACH f_U WHERE f_U._WINDOW-HANDLE = _h_win AND
                          f_U._TYPE          = "FRAME":U:
         IF f_U._LAYOUT-UNIT OR Scale-Options NE 2 THEN DO:
           RUN expand(INPUT RECID(f_U)).   /* Expand the frame */
           /* Expand the frames children */
           RUN expand-flds(INPUT RECID(f_U)).
         END. /* Expand the frames children */
       END. /* For each frame in the window */
     END.  /* IF the window is to be expanded */
       
     RUN choose_file_save in _h_uib.
     RUN choose_close in _h_uib.
     PROCESS EVENTS.
   END.
   RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

