&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME d_print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS d_print 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _SCRPRTD.W

  Description: Print options for SCRCAP.W

  Input Parameters:
      <none>

  Output Parameters:
      x   (int) 
      y   (int)
      opt (int)
      image_to_print (int) 1 = original, 2 = modified.

  Author: Gerry Seidl

  Created: 01/20/95 - 11:26 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE INPUT  PARAMETER image_changed AS LOGICAL NO-UNDO.

DEFINE OUTPUT PARAMETER x   AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER y   AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER opt AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER image_to_print AS INTEGER NO-UNDO.

DEFINE VARIABLE l AS LOGICAL NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME d_print

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b_cancel b_ok RECT-1 rs_print_opt ~
rs_which_image r_print_opt 
&Scoped-Define DISPLAYED-OBJECTS rs_print_opt rs_which_image xscale yscale 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */
DEFINE BUTTON b_cancel AUTO-END-KEY 
     LABEL "Cancel":L 
     SIZE 10 BY 1.

DEFINE BUTTON b_ok AUTO-GO 
     LABEL "OK":L 
     SIZE 10 BY 1.

DEFINE VARIABLE xscale AS INTEGER FORMAT ">>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 7.5 BY 1 NO-UNDO.

DEFINE VARIABLE yscale AS INTEGER FORMAT ">>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 7.5 BY 1 NO-UNDO.

DEFINE VARIABLE rs_print_opt AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Best Fit", 1,
"Stretch To Page", 2,
"Scale", 3
     SIZE 20 BY 2.5 NO-UNDO.

DEFINE VARIABLE rs_which_image AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Original Image", 1,
"Modified Image", 2
     SIZE 18 BY 3.85 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 20 BY 4.88.

DEFINE RECTANGLE r_print_opt
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 25 BY 4.88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME d_print
     b_ok AT ROW 1.54 COL 50
     rs_which_image AT ROW 2 COL 3 NO-LABEL
     rs_print_opt AT ROW 2.23 COL 25 NO-LABEL
     b_cancel AT ROW 2.88 COL 50
     xscale AT ROW 5 COL 28 COLON-ALIGNED NO-LABEL
     yscale AT ROW 5 COL 38 COLON-ALIGNED NO-LABEL
     " Image To Print" VIEW-AS TEXT
          SIZE 15 BY .62 AT ROW 1.27 COL 3
     " Print Options" VIEW-AS TEXT
          SIZE 14 BY .65 AT ROW 1.27 COL 24
     RECT-1 AT ROW 1.5 COL 2
     r_print_opt AT ROW 1.5 COL 23
     "X" VIEW-AS TEXT
          SIZE 2 BY .65 AT ROW 5.23 COL 28
     "Y" VIEW-AS TEXT
          SIZE 2 BY .65 AT ROW 5.23 COL 38
     SPACE(21.28) SKIP(0.84)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER NO-HELP 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Print":L
         DEFAULT-BUTTON b_ok.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
ASSIGN 
       FRAME d_print:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN xscale IN FRAME d_print
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN yscale IN FRAME d_print
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME d_print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d_print d_print
ON END-ERROR OF FRAME d_print /* Print */
OR ENDKEY OF FRAME D_print DO:
  ASSIGN opt = -1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d_print d_print
ON GO OF FRAME d_print /* Print */
DO:
  ASSIGN xscale = INT(xscale:SCREEN-VALUE)
         yscale = INT(yscale:SCREEN-VALUE)
         rs_print_opt = INT(rs_print_opt:SCREEN-VALUE)
         image_to_print = INT(rs_which_image:SCREEN-VALUE)
         x = xscale
         y = yscale
         opt = rs_print_opt.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs_print_opt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs_print_opt d_print
ON VALUE-CHANGED OF rs_print_opt IN FRAME d_print
DO:
  IF INT(rs_print_opt:SCREEN-VALUE) = 3 THEN DO:
      ASSIGN xscale:SENSITIVE = yes
             yscale:SENSITIVE = yes
             xscale:SCREEN-VALUE = "2400"
             yscale:SCREEN-VALUE = "1800".
      APPLY "ENTRY" TO xscale.
  END.
  ELSE
      ASSIGN xscale:SENSITIVE = no
             yscale:SENSITIVE = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs_which_image
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs_which_image d_print
ON VALUE-CHANGED OF rs_which_image IN FRAME d_print
DO:
  DEFINE VARIABLE l AS LOGICAL NO-UNDO.
  
  IF SELF:SCREEN-VALUE = "2" THEN
    ASSIGN l = rs_print_opt:DISABLE("Best Fit")
           l = rs_print_opt:DISABLE("Stretch To Page")
           rs_print_opt:SCREEN-VALUE = "3".
  ELSE
    ASSIGN l = rs_print_opt:ENABLE("Best Fit")
           l = rs_print_opt:ENABLE("Stretch To Page") 
           rs_print_opt:SCREEN-VALUE = "1".
  APPLY "VALUE-CHANGED" TO rs_print_opt.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK d_print 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  IF NOT image_changed THEN 
    l = rs_which_image:DISABLE("Modified Image").
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI d_print _DEFAULT-DISABLE
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
  HIDE FRAME d_print.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI d_print _DEFAULT-ENABLE
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
  DISPLAY rs_which_image rs_print_opt xscale yscale 
      WITH FRAME d_print.
  ENABLE RECT-1 r_print_opt b_ok rs_which_image rs_print_opt b_cancel 
      WITH FRAME d_print.
  {&OPEN-BROWSERS-IN-QUERY-d_print}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


