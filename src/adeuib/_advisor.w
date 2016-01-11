&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME f_dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS f_dlg 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _advisor.w

  Description: This dialog advises the user on some subject.  It is 
    really like a better version of the QUESTION ALERT-BOX.  It 
    first presents some text.  Then there is a series of Radio-Buttons
    describing options. 

  Input Parameters:
      pc_text - Descriptive Text.  This text is parsed into seperate
                rows which are dynamically created at the top of the
                dialog-box.  Use CHR(10) in the text to force a 
                line-feed.  The dialog will grow if more lines are
                required
      pc_options - User Options. This list of options is presented in
                a RADIO-SET.  The list should be of the form of a 
                character radio-set:RADIO-BUTTONS attribute 
                (i.e. "Option A,Value A,Option B,Value B')
                This list can be blank ("") in which case no radio-set
                will be created. [NOTE: this would just be like a 
                MESSAGE pc_text VIEW-AS ALERT-BOX INFORMATION.
      pl_never_toggle - If this is TRUE, then there is a toggle 
                presented on the dialog which lets the user select
                      "Don't show this message ever again."
      pc_help_tool - The tool name used in the ADE help file.  If
                this or pi_help_context is ? then the HELP button
                will not be displayed.
      pi_help_context - The Help Context ID number to use on the
                Help Button

  Input-Output Parameters:
      pc_choice - The Value of the User Choice (in pc_Options).  This
                is used to set the initial value of the Choice (when
                an input parameter is specified).  If pc_choice is ""
                then the first value will be used.
      
 Output Parameters:
      pl_never_again - The value of the "Never again" toggle box.  
                This is set to TRUE if pc_never_toggle was FALSE.

  Author: Wm.T.Wood

  Created: February 1995

  Modified: 06/20/97 gfs Added NO-BOX to editor.
            08/13/99 hd  Simplified and fixed sizing of editor.
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

&IF DEFINED(UIB_is_Running) eq 0  &THEN
  /* Variables normally passed as parameters */
  DEFINE INPUT        PARAMETER pc_text         AS CHAR NO-UNDO.
  DEFINE INPUT        PARAMETER pc_options      AS CHAR NO-UNDO.
  DEFINE INPUT        PARAMETER pl_never_toggle AS LOGICAL NO-UNDO.
  DEFINE INPUT        PARAMETER pc_help_tool    AS CHAR NO-UNDO.
  DEFINE INPUT        PARAMETER pc_help_context AS INTEGER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pc_choice       AS CHAR NO-UNDO.
  DEFINE       OUTPUT PARAMETER pl_never_again  AS LOGICAL NO-UNDO.
&ELSE
  /* When testing, create these as Variables. */
  DEFINE VARIABLE pc_text         AS CHAR NO-UNDO
         INITIAL "Boy, are you stupid. Only an idiot would do this.".
  DEFINE VARIABLE pc_options      AS CHAR NO-UNDO
         INITIAL "Continue. Do it anyway zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz,OK,Cancel. Sorry. I won't do it again.,Cancel".
  DEFINE VARIABLE pl_never_toggle AS LOGICAL NO-UNDO.
  DEFINE VARIABLE pc_help_tool    AS CHAR NO-UNDO    INITIAL "ab".
  DEFINE VARIABLE pc_help_context AS INTEGER NO-UNDO INITIAL 666.
  DEFINE VARIABLE pc_choice       AS CHAR NO-UNDO    INITIAL "Cancel".
  DEFINE VARIABLE pl_never_again  AS LOGICAL NO-UNDO.  
&ENDIF

/* ***************************  Definitions  ************************** */
&GLOBAL-DEFINE WIN95-BTN YES

/* ADE Standards Include */
{ adecomm/adestds.i }
IF NOT initialized_adestds
    THEN RUN adecomm/_adeload.p.

/* Help Context Definitions. */
{ adeuib/uibhlp.i }
{ adeuib/sharvars.i }

/* Pre-processor Definitions */
&GLOBAL-DEFINE  EOL     CHR(10)

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE adjust      AS INTEGER          NO-UNDO.
DEFINE VARIABLE h_options   AS WIDGET-HANDLE    NO-UNDO.
DEFINE VARIABLE h_parent    AS WIDGET-HANDLE    NO-UNDO.
DEFINE VARIABLE winTitle    AS CHARACTER        NO-UNDO INITIAL "PROGRESS Advisor".
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f_dlg

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS EDITOR-1 Btn_OK Btn_Help IMAGE-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR NO-BOX
     SIZE 49 BY 3.1 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "adeicon/advisor":U
     SIZE-PIXELS 153 BY 145.

DEFINE VARIABLE tg_never_again AS LOGICAL INITIAL no 
     LABEL "&Don't tell me this again." 
     VIEW-AS TOGGLE-BOX
     SIZE 32.6 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f_dlg
     EDITOR-1 AT ROW 1.24 COL 27 NO-LABEL
     Btn_OK AT ROW 7 COL 29.6
     Btn_Help AT ROW 7 COL 45.6
     tg_never_again AT ROW 8.19 COL 2
     IMAGE-1 AT Y 0 X 0
     SPACE(51.99) SKIP(2.75)
    WITH
    &if defined(IDE-IS-RUNNING) = 0 &then 
       VIEW-AS DIALOG-BOX TITLE winTitle
    &else
    no-box
    &endif 
    KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 8 
         
         DEFAULT-BUTTON Btn_OK.

{adeuib/ide/dialoginit.i "FRAME f_dlg:handle"}
&if DEFINED(IDE-IS-RUNNING) <> 0  &then
   dialogService:View(). 
&endif

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX f_dlg
                                                                        */
ASSIGN 
       FRAME f_dlg:SCROLLABLE       = FALSE
       FRAME f_dlg:HIDDEN           = TRUE.

/* SETTINGS FOR EDITOR EDITOR-1 IN FRAME f_dlg
   NO-DISPLAY                                                           */
ASSIGN 
       EDITOR-1:READ-ONLY IN FRAME f_dlg        = TRUE.

/* SETTINGS FOR TOGGLE-BOX tg_never_again IN FRAME f_dlg
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       tg_never_again:HIDDEN IN FRAME f_dlg           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help f_dlg
ON CHOOSE OF Btn_Help IN FRAME f_dlg /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: 
  /* Call Help for this instance of the Advisor. */
  RUN adecomm/_adehelp.p (pc_help_tool, "CONTEXT", pc_help_context, ""). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK f_dlg 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */

IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.
h_parent = FRAME {&FRAME-NAME}:PARENT.

/* The cursor of the parent may have been set to WAIT state. Make sure it
   is not. */
IF NOT h_parent:LOAD-MOUSE-POINTER ("") THEN RUN adecomm/_setcurs.p ("":U).

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  RUN setup-ui.

  DYNAMIC-FUNCTION("center-frame":U IN _h_func_lib, FRAME {&FRAME-NAME}:HANDLE).
  &if DEFINED(IDE-IS-RUNNING) <> 0  &then
   define variable cancelDialog as logical no-undo.
   dialogService:View().
   dialogService:SetOkButton(btn_ok:handle).
   dialogService:CancelEventNum=2.
   dialogService:Title= winTitle.
   on "u2" of frame {&FRAME-NAME} do:
       cancelDialog = true.
   end.    
  &ENDIF
  RUN show-toggle.
  RUN enable_UI.
  &if DEFINED(IDE-IS-RUNNING) = 0  &then
    WAIT-FOR GO OF FRAME {&FRAME-NAME} FOCUS btn_OK.
  &ELSE
     WAIT-FOR GO OF FRAME {&FRAME-NAME} or "u2" of this-procedure FOCUS btn_OK.   
     if cancelDialog THEN UNDO, LEAVE.  
  &endif 
  /* Return the value of the "never again" toggle if it was asked for. */
  pl_never_again = IF pl_never_toggle THEN tg_never_again:CHECKED ELSE TRUE.
  /* Get the value of the options radio-set, if it exists */
  IF VALID-HANDLE(h_options) THEN 
    pc_choice = h_options:SCREEN-VALUE.
  
  &IF DEFINED(UIB_is_Running) ne 0 &THEN
    /* If in test mode, then display the results. */
    MESSAGE "Choice: " pc_choice SKIP
            "Never again:" pl_never_again
          VIEW-AS ALERT-BOX. 
  &ENDIF

END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE create_options f_dlg 
PROCEDURE create_options :
/*------------------------------------------------------------------------------
  Purpose: Create a radio-set to show the list of options that this instance
           of the Advisor supports (see pc_options).  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR frm-brdr-p AS INTEGER NO-UNDO.
    DO WITH FRAME {&FRAME-NAME}:
        CREATE RADIO-SET h_options
          ASSIGN
            FRAME         = FRAME {&FRAME-NAME}:HANDLE
            COLUMN        = 1
            Y             = EDITOR-1:Y + EDITOR-1:HEIGHT-P + 6
            RADIO-BUTTONS = pc_options
            HIDDEN        = NO
            SENSITIVE     = YES
           . 
           
        /* If the radio-set fits starting at the same column as the editor,
           put it there. Otherwise, left-justify it.  If it is left-justified, 
           then make sure it does not overlap the Image of the "Advisor lightbulb".
        */
        DO ON STOP  UNDO, LEAVE
           ON ERROR UNDO, LEAVE :
          /* We are going to be using the frame border many times, so 
             compute it once. */ 
          frm-brdr-p = FRAME {&FRAME-NAME}:BORDER-LEFT-P +
                       FRAME {&FRAME-NAME}:BORDER-RIGHT-P.
          IF EDITOR-1:X + h_options:WIDTH-P < 
             FRAME {&FRAME-NAME}:WIDTH-P - frm-brdr-p
          THEN h_options:X = EDITOR-1:X.
          ELSE DO:
            ASSIGN
              h_options:X = 
                        MAX( 2 * SESSION:PIXELS-PER-COLUMN, 
                             (FRAME {&FRAME-NAME}:WIDTH-P - frm-brdr-p -
                             h_options:WIDTH-P) / 2)
              FRAME {&FRAME-NAME}:WIDTH-P = 
                        MAX (FRAME {&FRAME-NAME}:WIDTH-P,
                             h_options:X + h_options:WIDTH-P +
                             SESSION:PIXELS-PER-COLUMN + frm-brdr-p).
            IF h_options:Y < IMAGE-1:Y + IMAGE-1:HEIGHT-P
            THEN h_options:Y = IMAGE-1:Y + IMAGE-1:HEIGHT-P.
          END.
                                                         
        END.
        
        IF pc_choice <> "" THEN h_options:SCREEN-VALUE = pc_choice.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI f_dlg  _DEFAULT-DISABLE
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
  HIDE FRAME f_dlg.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI f_dlg  _DEFAULT-ENABLE
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
  ENABLE EDITOR-1 Btn_OK Btn_Help IMAGE-1 
      WITH FRAME f_dlg.
  VIEW FRAME f_dlg.
  {&OPEN-BROWSERS-IN-QUERY-f_dlg}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setup-ui f_dlg 
PROCEDURE setup-ui :
/*------------------------------------------------------------------------------
  Purpose:   Adjust the size of the frame based on what will be displayed in it.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE x-shift AS INTEGER                                   NO-UNDO.
  DEFINE VARIABLE x-xpand AS INTEGER                                   NO-UNDO.
  DEFINE VARIABLE x       AS INTEGER                                   NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
  
    /* Because we may be adding radio-buttons to the frame, make the frame
       vertically large now and size-to-fit after.
    */
    ASSIGN FRAME {&FRAME-NAME}:HEIGHT = SESSION:HEIGHT - 3
           . /* END ASSIGN */

    /* Size the editor to display the text with the right height. */
    RUN size-editor.
    
    /* Create the choices */
    IF pc_options <> "" THEN RUN create_options.
    
    IF NOT VALID-HANDLE( h_options ) THEN
        ASSIGN h_options = EDITOR-1:HANDLE.
        
    /* Adjust the size of the other controls as needed. */
    adjust = (h_options:Y + h_options:HEIGHT-P) - 
             (Btn_OK:Y - (SESSION:PIXELS-PER-ROW / 4)).
    IF adjust > 0 THEN
    ASSIGN Btn_OK:Y         = Btn_OK:Y + adjust
           Btn_Help:Y       = Btn_Help:Y + adjust
           tg_never_again:Y = tg_never_again:Y + adjust
           .

    /* Size-to-fit the frame. 
     * Added (SESSION:PIXELS-PER-ROW / 2) to eliminate vertical scrollbar 
     */
    ASSIGN FRAME {&FRAME-NAME}:HEIGHT-P =
        (tg_never_again:Y + tg_never_again:HEIGHT-P) +
        (FRAME {&FRAME-NAME}:BORDER-TOP-P
         + FRAME {&FRAME-NAME}:BORDER-BOTTOM-P + 1) 
         + (SESSION:PIXELS-PER-ROW / 2).

    /* Now adjust horizontally */
    /* We want to put text 2 pixels beyond the image
       - find out desired X                          */
    ASSIGN x       = IMAGE-1:x + IMAGE-1:WIDTH-PIXELS + 2
           x-shift = x - EDITOR-1:X.
    /* Before shifting - make sure frame is wide enough 
     * Checked against the editor AND the options and 
     *   added (2 * SESSION:PIXELS-PER-COLUMN) to eliminate horizontal scrollbar
     * 
     */
    x-xpand = MAX(EDITOR-1:WIDTH-PIXELS,h_options:WIDTH-PIXELS).
    IF FRAME {&FRAME-NAME}:WIDTH-PIXELS < 
         x + x-xpand + 2 + (2 * SESSION:PIXELS-PER-COLUMN) THEN
      FRAME {&FRAME-NAME}:WIDTH-PIXELS = 
         x + x-xpand + 2 + (2 * SESSION:PIXELS-PER-COLUMN).

    /* Now move stuff */
    ASSIGN EDITOR-1:x  = x
           h_options:x = x
           Btn_OK:x    = Btn_OK:x + x-shift
           Btn_Help:x  = Btn_Help:x + x-shift.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE show-toggle f_dlg 
PROCEDURE show-toggle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN tg_never_again:VISIBLE   = (pl_never_toggle = TRUE) 
           tg_never_again:SENSITIVE = (pl_never_toggle = TRUE) .
  END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE size-editor f_dlg 
PROCEDURE size-editor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN 
      EDITOR-1:SCREEN-VALUE = pc_text
      EDITOR-1:HEIGHT = MAX(EDITOR-1:HEIGHT,
             (EDITOR-1:NUM-LINES * FONT-TABLE:GET-TEXT-HEIGHT(editor-1:FONT))).
      
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

