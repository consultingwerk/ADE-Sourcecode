&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _protgen.w

  Description: PRO*Tools Prototype Include File Generator
               This procedure runs a Super procedure persistently, reads
               its INTERNAL-ENTRIES and generates an include file 
               containing prototypes of all of the procedures and functions
               contained within it. The generated include file will typically
               be used by Proxygen users so that Proxygen will be able to
               determine all of the procedures and functions available in
               a procedure (including all of its super procedures).

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Gerry Seidl

  Created: March 6, 1998

  Modified by GFS on 04/03/98 - Correctly handle Function with MAP TO option
              GFS on 11/04/98 - Correctly handle "Table" parameters
              JEP on 08/01/00 - Correctly handle "Table-Handle" parameters
                                and "Buffer" parameters for Functions.
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{ protools/ptlshlp.i } /* help definitions */
{ adecomm/_adetool.i }
{ protools/_runonce.i }

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE hStatusLine AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE iDummy      AS INTEGER       NO-UNDO.
DEFINE VARIABLE oldname     AS CHARACTER     NO-UNDO.

/* Stream Definitions */
DEFINE STREAM out.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rect_Include rect_Super Super_Proc Btn_File ~
Include_File Btn_Close Btn_Generate Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS Super_Proc Include_File 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD CreateParam C-Win 
FUNCTION CreateParam RETURNS CHARACTER
  ( sparm AS CHARACTER /* signature of param */,
    ptype AS CHARACTER /* parameter type "Procedure" or "Function") */)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD MakeProtoName C-Win 
FUNCTION MakeProtoName RETURNS CHARACTER FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Close 
     LABEL "&Close" 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_File 
     LABEL "&File..." 
     SIZE 10 BY 1.

DEFINE BUTTON Btn_Generate DEFAULT 
     LABEL "&Generate" 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE Include_File AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY 1 NO-UNDO.

DEFINE VARIABLE Super_Proc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE RECTANGLE rect_Include
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 48 BY 2.14.

DEFINE RECTANGLE rect_Super
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 48 BY 2.14.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     Super_Proc AT ROW 1.95 COL 2 COLON-ALIGNED HELP
          "Enter the name of the super procedure" NO-LABEL
     Btn_File AT ROW 1.95 COL 39 HELP
          "Choose a Super Procedure"
     Include_File AT ROW 4.57 COL 2 COLON-ALIGNED HELP
          "Enter the name of the include file to generate" NO-LABEL
     Btn_Close AT ROW 1.24 COL 52 HELP
          "Close this window"
     Btn_Generate AT ROW 2.67 COL 52 HELP
          "Generate the prototype include file"
     Btn_Help AT ROW 4.1 COL 52 HELP
          "Get help on this window"
     rect_Include AT ROW 3.86 COL 2
     rect_Super AT ROW 1.24 COL 2
     " &Super Procedure" VIEW-AS TEXT
          SIZE 18 BY .62 AT ROW 1 COL 4
     " &Include file to generate" VIEW-AS TEXT
          SIZE 26 BY .62 AT ROW 3.62 COL 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 67.2 BY 5.38
         DEFAULT-BUTTON Btn_Generate.


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
         TITLE              = "Prototype Generator"
         HEIGHT             = 5.29
         WIDTH              = 66.8
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 105.8
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 105.8
         MAX-BUTTON         = no
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
IF NOT C-Win:LOAD-ICON("adeicon\protogen":U) THEN
    MESSAGE "Unable to load icon: adeicon\protogen"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   Custom                                                               */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Prototype Generator */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Prototype Generator */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Close
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Close C-Win
ON CHOOSE OF Btn_Close IN FRAME DEFAULT-FRAME /* Close */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Close C-Win
ON ENTRY OF Btn_Close IN FRAME DEFAULT-FRAME /* Close */
DO:
  RUN adecomm/_statdsp.p(hStatusLine, 1, SELF:HELP).         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_File
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_File C-Win
ON CHOOSE OF Btn_File IN FRAME DEFAULT-FRAME /* File... */
DO:
  DEFINE VARIABLE l_ok AS LOGICAL.
  
  SYSTEM-DIALOG GET-FILE Super_Proc
    TITLE "Choose Super Procedure"
    FILTERS "All Source(*.p~;*.w)" "*.p~;*.w",
            "Procedures(*.p)" "*.p",
            "AppBuilder files(*.w)" "*.w",
            "All Files(*.*)" "*.*"
    MUST-EXIST
    UPDATE l_ok IN WINDOW {&WINDOW-NAME}.
  
  IF l_ok THEN DO: /* "Open" was chosen */
    /* If the file is in the PROPATH, make it a relative pathname */
    FILE-INFO:FILE-NAME = Super_Proc. 
    IF FILE-INFO:PATHNAME NE ? THEN 
      Super_Proc:SCREEN-VALUE = FILE-INFO:PATHNAME.
    
    DISPLAY Super_Proc WITH FRAME {&FRAME-NAME}.
    ASSIGN Include_File:SCREEN-VALUE = MakeProtoName().
    APPLY "ENTRY" TO Include_File.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_File C-Win
ON ENTRY OF Btn_File IN FRAME DEFAULT-FRAME /* File... */
DO:
  RUN adecomm/_statdsp.p(hStatusLine, 1, SELF:HELP).         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Generate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Generate C-Win
ON CHOOSE OF Btn_Generate IN FRAME DEFAULT-FRAME /* Generate */
OR GO OF FRAME {&FRAME-NAME}
DO:
  DEFINE VARIABLE OKtoOverwrite AS LOGICAL NO-UNDO.
  
  /* Complain if there was no procedure entered */
  IF Super_Proc:SCREEN-VALUE = "" THEN DO:
    MESSAGE "You must enter the name of a super procedure." 
      VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY":U TO Super_Proc.
    RETURN NO-APPLY.
  END.
  ELSE IF Include_File:SCREEN-VALUE = "" THEN DO:
    MESSAGE "You must enter a name for the include file to generate."
      VIEW-AS ALERT-BOX ERROR.
    Include_File:SCREEN-VALUE = MakeProtoName().
    APPLY "ENTRY":U TO Include_File.
    RETURN NO-APPLY.
  END.

  /* Check to see if include file already exists */
  ASSIGN FILE-INFO:FILE-NAME = Include_File:SCREEN-VALUE.
  IF FILE-INFO:FULL-PATHNAME NE ? THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT OKtoOverwrite, "Q":U, "Yes-No":U, 
      "The file, " + Include_File:SCREEN-VALUE + ", already exists. " + 
      "Do you want to overwrite it?").
    IF NOT OKtoOverwrite THEN DO:
      APPLY "ENTRY":U TO Include_File.
      RETURN NO-APPLY.
    END.
  END.
  
  RUN Generate_Prototypes. /* generate include file */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Generate C-Win
ON ENTRY OF Btn_Generate IN FRAME DEFAULT-FRAME /* Generate */
DO:
  RUN adecomm/_statdsp.p(hStatusLine, 1, SELF:HELP).         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help C-Win
ON CHOOSE OF Btn_Help IN FRAME DEFAULT-FRAME /* Help */
DO:
  RUN adecomm/_adehelp.p("ptls":U, "CONTEXT":U, {&Protogen}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help C-Win
ON ENTRY OF Btn_Help IN FRAME DEFAULT-FRAME /* Help */
DO:
  RUN adecomm/_statdsp.p(hStatusLine, 1, SELF:HELP).         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Include_File
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Include_File C-Win
ON ENTRY OF Include_File IN FRAME DEFAULT-FRAME
DO:
  RUN adecomm/_statdsp.p(hStatusLine, 1, SELF:HELP).         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Super_Proc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Super_Proc C-Win
ON ENTRY OF Super_Proc IN FRAME DEFAULT-FRAME
DO:
  ASSIGN oldname = SELF:SCREEN-VALUE. /* Store off old name to compare later */
  RUN adecomm/_statdsp.p(hStatusLine, 1, SELF:HELP).         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Super_Proc C-Win
ON LEAVE OF Super_Proc IN FRAME DEFAULT-FRAME
DO:
  /* If there is no include file name, generate a default one */
  IF (SELF:SCREEN-VALUE NE "" AND Include_File:SCREEN-VALUE = "") OR
      SELF:SCREEN-VALUE NE oldname THEN DO:
    Include_File:SCREEN-VALUE = MakeProtoName().
    APPLY "ENTRY":U TO Include_File.
    RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

ON ALT-S ANYWHERE
  APPLY "ENTRY":U TO Super_Proc IN FRAME {&FRAME-NAME}.
  
ON ALT-I ANYWHERE
  APPLY "ENTRY":U TO Include_File IN FRAME {&FRAME-NAME}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreateStatusArea C-Win 
PROCEDURE CreateStatusArea :
/*------------------------------------------------------------------------------
  Purpose:     Creates a status line in the window
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Create generic ADE status bar in the window */
  RUN adecomm/_status.p ( INPUT {&WINDOW-NAME}:HANDLE, 
                       INPUT "50":U, 
                       INPUT FALSE, 
                       INPUT (IF SESSION:PIXELS-PER-COLUMN = 5 THEN 4 ELSE ?), 
                       OUTPUT hStatusLine,
                       OUTPUT iDummy).
                      
  /* resize the window, and position the status bar */                    
  ASSIGN {&WINDOW-NAME}:HEIGHT-P = {&WINDOW-NAME}:HEIGHT-P + hStatusLine:HEIGHT-P
         hStatusLine:Y           = {&WINDOW-NAME}:HEIGHT-P - hStatusLine:HEIGHT-P
         hStatusLine:VISIBLE     = TRUE.

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
  DISPLAY Super_Proc Include_File 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE rect_Include rect_Super Super_Proc Btn_File Include_File Btn_Close 
         Btn_Generate Btn_Help 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generate_Prototypes C-Win 
PROCEDURE Generate_Prototypes :
/*------------------------------------------------------------------------------
  Purpose:     Reads the internal entries of the super procedure and writes the
               prototypes to the specified include file.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSuper  AS HANDLE    NO-UNDO. /* handle to super procedure */
  DEFINE VARIABLE Entries AS CHARACTER NO-UNDO. /* to store internal entries */
  DEFINE VARIABLE i       AS INTEGER   NO-UNDO. /* loop counter */
  DEFINE VARIABLE c       AS INTEGER   NO-UNDO. /* loop counter */
  DEFINE VARIABLE sig     AS CHARACTER NO-UNDO. /* signature of proc or fcn */
  DEFINE VARIABLE name    AS CHARACTER NO-UNDO. /* name of proc or fcn */
  DEFINE VARIABLE sparm   AS CHARACTER NO-UNDO. /* Param with "AS" added */
  DEFINE VARIABLE aproc   AS LOGICAL   NO-UNDO. /* are we writing a procedure? */
  
  /* Store screen values */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN Super_Proc Include_File.
  END.
  
  /* Run the Super procedure */
  DO ON STOP UNDO, LEAVE:
      RUN adecomm/_runcode.p(INPUT super_proc, 
        INPUT "_PERSISTENT":U, INPUT ?, OUTPUT hSuper).     
  END.
  
  /* Check for valid procedure handle */
  IF NOT VALID-HANDLE(hSuper) THEN DO:
    MESSAGE Super_Proc "did not run sucessfully." VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY":U TO Super_Proc.
    RETURN "ERROR":U.
  END.
  
  /* Get it's internal entries */
  ASSIGN Entries = hSuper:INTERNAL-ENTRIES.
  
  /* Check for any procedures and/or functions */
  IF Entries = ? OR Entries = "" THEN DO:
    MESSAGE "There are no internal procedures or functions" SKIP
            "defined in procedure " Super_Proc VIEW-AS ALERT-BOX ERROR.
    DELETE PROCEDURE hSuper.
    APPLY "ENTRY":U TO Super_Proc.
    RETURN "ERROR":U.
  END.
             
  RUN adecomm/_statdsp.p(hStatusLine,1, "Creating prototypes...").
  
  /* Open a stream to the include file */
  OUTPUT STREAM out TO VALUE(Include_File).
  
  /* Write Include file header */
  PUT STREAM out UNFORMATTED "/*":U SKIP
                 " * Prototype include file: " + Include_File SKIP
                 " * Created from procedure: " + Super_Proc + 
                 " at " + STRING(TIME,"HH:MM") + " on " STRING(TODAY) SKIP
                 " * by the PROGRESS PRO*Tools Prototype Include File Generator" SKIP
                 " */":U SKIP(1).
                 
  /* Process the procedures and functions */
  DO i = 1 to NUM-ENTRIES(hSuper:INTERNAL-ENTRIES):
    ASSIGN name = ENTRY(i,Entries)
           sig  = hSuper:GET-SIGNATURE(name).

    /* Write block type and its name */
    CASE ENTRY(1,sig):
      WHEN "DLL-ENTRY":U THEN PUT STREAM out UNFORMATTED "PROCEDURE ":U + name. /* DLL */
      WHEN "EXTERN":U THEN PUT STREAM out UNFORMATTED "FUNCTION ":U + name. /* MAPS TO */
      OTHERWISE PUT STREAM out UNFORMATTED ENTRY(1,sig) + " ":U + name.
    END CASE.
    
    /* If it's a function, write out RETURNS line with data-type */
    IF ENTRY(2,sig) NE "" THEN DO:
      PUT STREAM out UNFORMATTED " RETURNS ":U CAPS(ENTRY(2,sig)). 
      ASSIGN aproc = FALSE.
    END.
    ELSE DO:
      /* It's a procedure (or DLL-ENTRY) */      
      PUT STREAM out UNFORMATTED " IN SUPER:":U SKIP.
      ASSIGN aproc = TRUE. 
    END.
    
    /* Process the parameters */
    IF NUM-ENTRIES(sig) > 2 AND ENTRY(3,sig) NE "" THEN 
    DO:
      DO c = 3 TO NUM-ENTRIES(sig):
        IF aproc THEN PUT STREAM out UNFORMATTED "  ":U CreateParam(ENTRY(c,sig),"Procedure":U) SKIP.
        ELSE DO: /* Function */
          IF c = 3 THEN PUT STREAM out UNFORMATTED SKIP "  (":U.
          ELSE PUT STREAM out UNFORMATTED ",":U SKIP "   ":U.
          PUT STREAM out UNFORMATTED CreateParam(ENTRY(c,sig),"Function":U).
        END.
      END.
      IF NOT aproc THEN PUT STREAM out ")":U.
    END.
    IF aproc THEN PUT STREAM out UNFORMATTED "END PROCEDURE.":U SKIP(1).
    ELSE PUT STREAM out " IN SUPER.":U SKIP(1).
  END. /* DO i = 1 to NUM-ENTRIES(hSuper:INTERNAL-ENTRIES): */
  
  /* Close output file */
  OUTPUT STREAM out CLOSE.
  
  /* Shut down super procedure */
  DELETE PROCEDURE hSuper.
  
  RUN adecomm/_statdsp.p(hStatusLine,1, "Done").
  
  APPLY "ENTRY":U TO Super_Proc.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION CreateParam C-Win 
FUNCTION CreateParam RETURNS CHARACTER
  ( sparm AS CHARACTER /* signature of param */,
    ptype AS CHARACTER /* parameter type "Procedure" or "Function") */) :
/*------------------------------------------------------------------------------
  Purpose: Constructs correct parameter line for prototype based on the 
           signature returned by get-signature. 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE vparam AS CHARACTER NO-UNDO.

  IF ENTRY(1,sparm," ":U) = "BUFFER":U THEN
  DO:
    IF ptype = "PROCEDURE":U THEN
    DO:
       ASSIGN vparam = SUBSTITUTE("DEFINE PARAMETER BUFFER &1 FOR &2":U,
                                   ENTRY(2,sparm," ":U), ENTRY(3,sparm," ":U) ).
    END.
    ELSE IF ptype = "FUNCTION":U THEN
    DO:
       ASSIGN vparam = SUBSTITUTE("BUFFER &1 FOR &2":U,
                                   ENTRY(2,sparm," ":U), ENTRY(3,sparm," ":U) ).
    END.
  END.
  ELSE DO:
    IF ptype = "PROCEDURE":U THEN
    DO:
       ASSIGN vparam = SUBSTITUTE("DEFINE &1 PARAMETER &2":U,
                                   ENTRY(1,sparm," ":U),
                                   ENTRY(2,sparm," ":U)).
    END.
    ELSE IF ptype = "FUNCTION":U THEN
    DO:
       ASSIGN vparam = SUBSTITUTE("&1 &2":U, ENTRY(1,sparm," ":U), ENTRY(2,sparm," ":U)).
    END.
    
    /* Determine Table and Table-Handle parameter formats. */
    IF ENTRY(2,sparm," ":U) BEGINS "TABLE":U THEN
    DO:
       IF ENTRY(2,sparm," ":U) = "TABLE":U THEN
           vparam = SUBSTITUTE(vparam + " &1 &2":U, "FOR":U, ENTRY(3,sparm," ":U)).
       ELSE IF ENTRY(2,sparm," ":U) = "TABLE-HANDLE":U THEN
           vparam = SUBSTITUTE(vparam + " &1 &2":U,
                               (IF NUM-ENTRIES(sparm, " ":U) = 4 THEN ENTRY(4,sparm," ":U) ELSE "":U),
                                ENTRY(3,sparm," ":U)).
    END.
    /* Determine Data-Type/Variable parameters format. */
    ELSE IF NOT ENTRY(2,sparm," ":U) BEGINS "TABLE":U THEN
    DO:
       ASSIGN vparam = SUBSTITUTE(vparam + " &1 &2":U, "AS":U, ENTRY(3,sparm," ":U)).
    END.
  END.
  
  /* If this is a procedure, add the trailing period. */
  IF ptype = "PROCEDURE":U THEN
      ASSIGN vparam = (vparam + ".":U).
  
  RETURN vparam.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION MakeProtoName C-Win 
FUNCTION MakeProtoName RETURNS CHARACTER:
/*------------------------------------------------------------------------------
  Purpose: Generate a prototype include file name from super proc name 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE path    AS CHARACTER NO-UNDO. /* the path */
  DEFINE VARIABLE fname   AS CHARACTER NO-UNDO. /* file name */
  DEFINE VARIABLE ext     AS CHARACTER NO-UNDO. /* file extention */ 
  DEFINE VARIABLE newname AS CHARACTER NO-UNDO. /* new filename */

  RUN adecomm/_osprefx.p (Super_Proc:SCREEN-VALUE IN FRAME {&FRAME-NAME}, OUTPUT path, output fname).
  RUN adecomm/_osfext.p (fname, output ext).
  
  IF ext NE "" THEN
    ASSIGN newname = REPLACE(fname,ext,"":U).
  ELSE newname = fname.
  
  /* Use up to the first 4 characters of the original name to start with */
  IF LENGTH(newname,"CHARACTER":U) > 4 THEN 
    ASSIGN newname = SUBSTRING(newname,1,4,"CHARACTER":U).
  
  /* Assemble new name */
  ASSIGN ext     = ".i":U.
         newname = path + newname + "prto":U + ext.

  RETURN newname.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

