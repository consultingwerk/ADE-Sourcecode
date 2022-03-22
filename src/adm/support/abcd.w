&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
/* Procedure Description
"The Dialog-Box for ""ABC"" SmartPanels

This dialog-box is used to set the ""ABC"" panel attributes during design time."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME SP-attr-dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS SP-attr-dialog 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: abcd.w

  Description: Dialog for getting setable attributes of a navigation
               SmartPanel.

  Input Parameters:
      ph_SMO - Procedure handle of the calling "ABC" panel SmartObject

  Output Parameters:
      <none>

  Authors: Wm.T.Wood and Rick Kuzyk 
  Created: March 15, 1996
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

&GLOBAL-DEFINE WIN95-BTN YES

DEFINE INPUT PARAMETER ph_SMO AS HANDLE NO-UNDO.

/* Number of Buttons in Sample. */
&Scoped-Define Sample-Count 6

/* Local Variable Definitions ---                                       */
DEFINE VAR attr-list       AS CHARACTER NO-UNDO.
DEFINE VAR h               AS HANDLE NO-UNDO.
DEFINE VAR h_b             AS HANDLE EXTENT {&Sample-Count} NO-UNDO.
DEFINE VAR i               AS INTEGER NO-UNDO.
DEFINE VAR i-Button-Font   AS INTEGER NO-UNDO.
DEFINE VAR i-Margin-Pixels AS INTEGER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME SP-attr-dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Box b-1 b-2 b-3 b-4 b-5 b-6 v-show ~
v-margin-pixels v-Button-Font btn_Font v-dispatch-open-query 
&Scoped-Define DISPLAYED-OBJECTS v-dispatch-open-query 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-1 
     LABEL "S" 
     SIZE 4 BY 1.1
     FONT 4.

DEFINE BUTTON b-2 
     LABEL "A" 
     SIZE 4 BY 1.1
     FONT 4.

DEFINE BUTTON b-3 
     LABEL "M" 
     SIZE 4 BY 1.1
     FONT 4.

DEFINE BUTTON b-4 
     LABEL "P" 
     SIZE 4 BY 1.1
     FONT 4.

DEFINE BUTTON b-5 
     LABEL "L" 
     SIZE 4 BY 1.1
     FONT 4.

DEFINE BUTTON b-6 
     LABEL "E" 
     SIZE 4 BY 1.1
     FONT 4.

DEFINE BUTTON btn_Font 
     LABEL "&Font..." 
     SIZE 15 BY 1.14.

DEFINE VARIABLE v-Button-Font AS INTEGER FORMAT ">>9":U INITIAL 4 
     LABEL "Button &Font" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE v-edge-pixels AS INTEGER FORMAT ">9":U INITIAL 2 
     LABEL "Box &Edge (in pixels)" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE v-margin-pixels AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "&Margin (in pixels)" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE RECTANGLE Box
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28 BY 2.14.

DEFINE VARIABLE v-dispatch-open-query AS LOGICAL INITIAL no 
     LABEL "Automatically Dispatch 'Open-Query'" 
     VIEW-AS TOGGLE-BOX
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE v-show AS LOGICAL INITIAL yes 
     LABEL "&Show Box" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME SP-attr-dialog
     b-1 AT ROW 1.76 COL 17
     b-2 AT ROW 1.76 COL 21
     b-3 AT ROW 1.76 COL 25
     b-4 AT ROW 1.76 COL 29
     b-5 AT ROW 1.76 COL 33
     b-6 AT ROW 1.76 COL 37
     v-edge-pixels AT ROW 4.52 COL 25 COLON-ALIGNED
     v-show AT ROW 4.52 COL 34
     v-margin-pixels AT ROW 5.57 COL 25 COLON-ALIGNED
     v-Button-Font AT ROW 6.67 COL 25 COLON-ALIGNED
     btn_Font AT ROW 6.67 COL 34
     v-dispatch-open-query AT ROW 8.81 COL 8
     Box AT ROW 1.24 COL 15
     " Visualization" VIEW-AS TEXT
          SIZE 52 BY .57 AT ROW 3.67 COL 2
          BGCOLOR 1 FGCOLOR 15 
     " Behavior" VIEW-AS TEXT
          SIZE 52 BY .57 AT ROW 8 COL 2
          BGCOLOR 1 FGCOLOR 15 
     SPACE(0.00) SKIP(1.04)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Alphabet Button Panel Attributes".

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX SP-attr-dialog
   Default                                                              */
ASSIGN 
       FRAME SP-attr-dialog:SCROLLABLE       = FALSE
       FRAME SP-attr-dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN v-Button-Font IN FRAME SP-attr-dialog
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN v-edge-pixels IN FRAME SP-attr-dialog
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN v-margin-pixels IN FRAME SP-attr-dialog
   NO-DISPLAY                                                           */
/* SETTINGS FOR TOGGLE-BOX v-show IN FRAME SP-attr-dialog
   NO-DISPLAY                                                           */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME SP-attr-dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SP-attr-dialog SP-attr-dialog
ON WINDOW-CLOSE OF FRAME SP-attr-dialog /* Alphabet Button Panel Attributes */
DO:
  /* Treat WINDOW-CLOSE like Cancel. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_Font
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_Font SP-attr-dialog
ON CHOOSE OF btn_Font IN FRAME SP-attr-dialog /* Font... */
DO:
  DEFINE VAR pressed_OK AS LOGICAL NO-UNDO.
  
  /* Edit the font used. */
  RUN adecomm/_chsfont.p 
       (INPUT 'Choose Button Font':U, /* Title */
        INPUT ?,                      /* Default Font */
        INPUT-OUTPUT v-Button-Font,   /* Font to Change */
        OUTPUT       pressed_OK).     /* User responce */
  IF pressed_OK THEN RUN show-button-font.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-Button-Font
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-Button-Font SP-attr-dialog
ON LEAVE OF v-Button-Font IN FRAME SP-attr-dialog /* Button Font */
DO:
  IF INPUT v-button-font > FONT-TABLE:NUM-ENTRIES THEN DO:
    MESSAGE "Font" v-button-font "does not exist." SKIP
            "Font number must be between 0 and" 
            TRIM(STRING(FONT-TABLE:NUM-ENTRIES,">>9.":U))
            VIEW-AS ALERT-BOX ERROR.
    DISPLAY v-button-font WITH FRAME {&FRAME-NAME}.
    RETURN NO-APPLY.
  END.
  ELSE DO:
    ASSIGN v-button-font.
    RUN show-button-font.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-edge-pixels
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-edge-pixels SP-attr-dialog
ON LEAVE OF v-edge-pixels IN FRAME SP-attr-dialog /* Box Edge (in pixels) */
DO:
  ASSIGN v-edge-pixels.         
  RUN show-edge-pixels.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-margin-pixels
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-margin-pixels SP-attr-dialog
ON LEAVE OF v-margin-pixels IN FRAME SP-attr-dialog /* Margin (in pixels) */
DO:
  ASSIGN {&SELF-NAME}.
  RUN show-margin-pixels.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-show
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-show SP-attr-dialog
ON VALUE-CHANGED OF v-show IN FRAME SP-attr-dialog /* Show Box */
DO:
  /* If there is a box, then set the edge-pixels to 2. */
  ASSIGN v-show.
         v-edge-pixels = IF v-show THEN 2 ELSE 0.
  RUN show-edge-pixels.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK SP-attr-dialog 


/* ****************** Standard Buttons and ADM Help ******************* */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Define Context ID's for HELP files */
{ src/adm/support/admhlp.i }    

/* Attach the standard OK/Cancel/Help button bar. */
{ adecomm/okbar.i  &TOOL = "AB"
                   &CONTEXT = {&AlphabetPanel_Attributes_Dlg_Box} }

/* ***************************  Main Block  *************************** */

/* Copy Sample Button handles into an array. */
ASSIGN h_b[1] = b-1:HANDLE
       h_b[2] = b-2:HANDLE
       h_b[3] = b-3:HANDLE
       h_b[4] = b-4:HANDLE
       h_b[5] = b-5:HANDLE
       h_b[6] = b-6:HANDLE
       .
       
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  RUN get-attribute IN ph_SMO ('Button-Font':U).
  v-button-font = INTEGER (RETURN-VALUE).
  RUN get-attribute IN ph_SMO ('Dispatch-Open-Query':U).
  v-dispatch-open-query = (RETURN-VALUE eq STRING(yes)).
  RUN get-attribute IN ph_SMO ('Edge-Pixels':U).
  IF RETURN-VALUE ne ? THEN v-edge-pixels = INTEGER (RETURN-VALUE).
  RUN get-attribute IN ph_SMO ('Margin-Pixels':U).
  IF RETURN-VALUE ne ? THEN v-Margin-pixels = INTEGER (RETURN-VALUE).
  /* Save some values for later comparison. */
  ASSIGN i-button-font   = v-button-font
         i-margin-pixels = v-margin-pixels
         .
 
  /* Set the state of the interface and wait-for user input. */
  RUN show-edge-pixels.
  RUN show-margin-pixels.
  RUN show-button-font.
  
  /* Enable the interface. */         
  RUN enable_UI.

  /* Set the cursor */
  RUN adecomm/_setcurs.p ("":U).
 
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
  
  ASSIGN v-margin-pixels
         v-edge-pixels
         v-button-font
         v-dispatch-open-query.
  
  /* Assign the new value. */
  attr-list = 
    "Edge-Pixels = ":U + STRING (v-edge-pixels) +
    ",Dispatch-Open-Query = ":U + STRING (v-dispatch-open-query).
        
  RUN set-attribute-list IN ph_SMO (INPUT attr-list).

  /* Process some attributes only if their value changed. */  
  IF i-button-font ne v-button-font THEN 
    RUN set-attribute-list IN ph_SMO
       ("Button-Font = ":U + (IF v-button-font eq ? THEN '?':U 
                              ELSE STRING (v-button-font))).
  IF i-Margin-Pixels ne v-Margin-Pixels THEN DO:
    RUN set-attribute-list IN ph_SMO
       ("Margin-Pixels = ":U + STRING (v-margin-pixels)).
    RUN get-attribute IN ph_SMO ('ADM-OBJECT-HANDLE':U).
    h = WIDGET-HANDLE(RETURN-VALUE).
    IF VALID-HANDLE(h) THEN RUN set-size IN ph_SMO (h:HEIGHT, h:WIDTH).
  END.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI SP-attr-dialog _DEFAULT-DISABLE
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
  HIDE FRAME SP-attr-dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI SP-attr-dialog _DEFAULT-ENABLE
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
  DISPLAY v-dispatch-open-query 
      WITH FRAME SP-attr-dialog.
  ENABLE Box b-1 b-2 b-3 b-4 b-5 b-6 v-show v-margin-pixels v-Button-Font 
         btn_Font v-dispatch-open-query 
      WITH FRAME SP-attr-dialog.
  VIEW FRAME SP-attr-dialog.
  {&OPEN-BROWSERS-IN-QUERY-SP-attr-dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE show-button-font SP-attr-dialog 
PROCEDURE show-button-font :
/*------------------------------------------------------------------------------
  Purpose:  Show the desired font in the fill-in and in the Sample buttons.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    DISPLAY v-Button-Font WITH FRAME {&FRAME-NAME}.
    DO i = 1 to {&Sample-Count}:
      h_b[i]:FONT = v-Button-Font.
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE show-edge-pixels SP-attr-dialog 
PROCEDURE show-edge-pixels :
/* -----------------------------------------------------------
  Purpose: Sets the state of related fields in the dialog-box .
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:   
    ASSIGN v-show                  = v-edge-pixels > 0
           v-edge-pixels:SENSITIVE = v-show
           Box:HIDDEN              = NOT v-show
           Box:EDGE-PIXELS         = v-edge-pixels .
    DISPLAY v-show v-edge-pixels WITH FRAME {&FRAME-NAME}.
  END.     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE show-margin-pixels SP-attr-dialog 
PROCEDURE show-margin-pixels :
/*------------------------------------------------------------------------------
  Purpose:  Show the desired margin in the fill-in and in the Sample.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR iMargin AS INTEGER NO-UNDO.
  DEFINE VAR iWidth-P AS INTEGER NO-UNDO.
  DEFINE VAR iHeight-P AS INTEGER NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    DISPLAY v-Margin-Pixels WITH FRAME {&FRAME-NAME}.
    
    /* Our sample can only show margins up to a certain size. */
    iMargin = MIN(v-Margin-Pixels, Box:HEIGHT-P / 2).
    /* Only change the margin if we need to. */
    IF iMargin ne (Box:X - b-1:X) THEN DO:
      /* Hide the buttons, resize them, then view them. */
      DO i = 1 to {&Sample-Count}:
        h_b[i]:HIDDEN = yes.
      END.  
      /* Size the buttons. */
      ASSIGN iWidth-P  = MAX (1,(Box:WIDTH-P - 2 * iMargin) / {&Sample-Count})
             iHeight-P = MAX (1, Box:HEIGHT-P - 2 * iMargin)
             .
      DO i = 1 to {&Sample-Count}:
        ASSIGN h_b[i]:WIDTH-P  = iWidth-P
               h_b[i]:HEIGHT-P = iHeight-P
               h_b[i]:Y        = Box:Y + iMargin
               h_b[i]:X        = Box:X + iMargin +                  
                                 ((Box:WIDTH-P - 2 * iMargin) * (i - 1) / 
                                  {&Sample-Count})
               h_b[i]:HIDDEN   = no
             NO-ERROR.
      END. /* DO i... */ 
    END. /* IF iMargin... */
  END. /* DO WITH FRAME... */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


