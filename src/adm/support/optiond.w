&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
/* Procedure Description
"The Dialog-Box for the ""Options"" SmartPanel 

This dialog-box is used to set the Options panel attributes during design time."
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

  File: optiond.w

  Description: Dialog for getting setable attributes of a Option
               SmartPanel.

  Input Parameters:
      ph_SMO - Procedure handle of the calling Option Panel SmartObject

  Output Parameters:
      <none>

  Authors: Wm.T.Wood and Rick Kuzyk 
  Created: March 15, 1996
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&GLOBAL-DEFINE WIN95-BTN  YES

/* Parameters Definitions ---                                           */

DEFINE INPUT PARAMETER ph_SMO AS HANDLE NO-UNDO.

/* Number of Buttons in Sample. */
&Scoped-Define Sample-Count 6

/* Local Variable Definitions ---                                       */
DEFINE VAR attr-list        AS CHARACTER NO-UNDO.
DEFINE VAR h                AS HANDLE NO-UNDO.
DEFINE VAR h_sample         AS HANDLE NO-UNDO.
DEFINE VAR i                AS INTEGER NO-UNDO.
DEFINE VAR i-Font           AS INTEGER NO-UNDO.
DEFINE VAR i-label          AS CHARACTER NO-UNDO.
DEFINE VAR i-link-name     AS CHARACTER NO-UNDO.
DEFINE VAR i-Margin-Pixels  AS INTEGER NO-UNDO.
DEFINE VAR i-style          AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME SP-attr-dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Box v-style v-Label v-show v-margin-pixels ~
v-Font btn_Font v-Link-Name v-Options-Attribute v-Case-Attribute ~
v-Case-Changed-Event 
&Scoped-Define DISPLAYED-OBJECTS v-style v-Label v-Link-Name ~
v-Options-Attribute v-Case-Attribute v-Case-Changed-Event 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn_Font 
     LABEL "&Font..." 
     SIZE 15 BY 1.12.

DEFINE VARIABLE v-style AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Style" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Horizontal Radio-Set","Vertical Radio-Set","Combo-Box","Selection-List" 
     SIZE 26 BY 1 NO-UNDO.

DEFINE VARIABLE sample-label AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .62 NO-UNDO.

DEFINE VARIABLE v-Case-Attribute AS CHARACTER FORMAT "X(256)":U 
     LABEL "Set Option &Case in" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE v-Case-Changed-Event AS CHARACTER FORMAT "X(256)":U 
     LABEL "Additionally &Dispatch" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE v-edge-pixels AS INTEGER FORMAT ">9":U INITIAL 2 
     LABEL "Box &Edge (in pixels)" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE v-Font AS INTEGER FORMAT ">>9":U INITIAL 4 
     LABEL "&Font" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE v-Label AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Label" 
     VIEW-AS FILL-IN 
     SIZE 26 BY 1 NO-UNDO.

DEFINE VARIABLE v-Link-Name AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Link to" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE v-margin-pixels AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "&Margin (in pixels)" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE v-Options-Attribute AS CHARACTER FORMAT "X(256)":U 
     LABEL "Ask for Valid &Options in" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1 NO-UNDO.

DEFINE RECTANGLE Box
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28 BY 2.43.

DEFINE VARIABLE v-show AS LOGICAL INITIAL yes 
     LABEL "&Show Box" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME SP-attr-dialog
     sample-label AT ROW 2.43 COL 17 NO-LABEL
     v-style AT ROW 6 COL 29 COLON-ALIGNED
     v-Label AT ROW 7.05 COL 29 COLON-ALIGNED
     v-edge-pixels AT ROW 8.14 COL 29 COLON-ALIGNED
     v-show AT ROW 8.14 COL 38
     v-margin-pixels AT ROW 9.19 COL 29 COLON-ALIGNED
     v-Font AT ROW 10.29 COL 29 COLON-ALIGNED
     btn_Font AT ROW 10.29 COL 38
     v-Link-Name AT ROW 12.43 COL 30 COLON-ALIGNED
     v-Options-Attribute AT ROW 13.52 COL 30 COLON-ALIGNED
     v-Case-Attribute AT ROW 14.57 COL 30 COLON-ALIGNED
     v-Case-Changed-Event AT ROW 15.67 COL 30 COLON-ALIGNED
     " Sample" VIEW-AS TEXT
          SIZE 60 BY .57 AT ROW 1.52 COL 2
          BGCOLOR 1 FGCOLOR 15 
     Box AT ROW 2.71 COL 16
     " Visualization" VIEW-AS TEXT
          SIZE 60 BY .62 AT ROW 5.29 COL 2
          BGCOLOR 1 FGCOLOR 15 
     " Behavior" VIEW-AS TEXT
          SIZE 60 BY .57 AT ROW 11.76 COL 2
          BGCOLOR 1 FGCOLOR 15 
     SPACE(0.79) SKIP(4.47)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Option Panel Attributes".

 

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

/* SETTINGS FOR FILL-IN sample-label IN FRAME SP-attr-dialog
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN v-edge-pixels IN FRAME SP-attr-dialog
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN v-Font IN FRAME SP-attr-dialog
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN v-margin-pixels IN FRAME SP-attr-dialog
   NO-DISPLAY                                                           */
/* SETTINGS FOR TOGGLE-BOX v-show IN FRAME SP-attr-dialog
   NO-DISPLAY                                                           */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME SP-attr-dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SP-attr-dialog SP-attr-dialog
ON GO OF FRAME SP-attr-dialog /* Option Panel Attributes */
DO:
/* -----------------------------------------------------------------------------
  Purpose:    Set the attributes back in the SmartObject itself.
  Parameters:  <none>
  Notes:       
  ----------------------------------------------------------------------------*/
  DEF VAR i          AS INTEGER NO-UNDO.
  DEF VAR ch         AS CHAR NO-UNDO.
  DEF VAR context_ID AS INTEGER NO-UNDO.
  DEF VAR rdummy     AS RECID NO-UNDO.
  
  ASSIGN v-Case-Attribute
         v-Case-Changed-Event
         v-edge-pixels
         v-font
         v-label
         v-Link-Name
         v-margin-pixels
         v-Options-Attribute
         v-style.
  
  /* Strip SPACES out of attribute names. [Don't worry about reporting an
     error for these cases because this is a rare situation. (We have a trigger
     on these fields to prevent spaces from being added.) */
  ASSIGN v-Link-Name = REPLACE(v-Link-Name,' ':U,'':U)
         v-Case-Attribute = REPLACE(v-Case-Attribute,' ':U,'':U)
         v-Case-Changed-Event = REPLACE(v-Case-Changed-Event,' ':U,'':U)
         v-Options-Attribute = REPLACE(v-Options-Attribute,' ':U,'':U)
         .
  
  /* Assign the simple (no processing) attributes. */
  attr-list = 
    "Case-Attribute = ":U + v-case-attribute +
    ",Case-Changed-Event = ":U + STRING (v-Case-Changed-Event) +
    ",Edge-Pixels = ":U + STRING (v-edge-pixels) +
    ",Options-Attribute = ":U + v-options-attribute.
  RUN set-attribute-list IN ph_SMO (INPUT attr-list).
 
  /* Process some attributes (if their value changed). */
  IF i-font ne v-font THEN DO:
    RUN set-attribute-list IN ph_SmO 
        ("Font = ":U + (IF v-font eq ? THEN '?':U ELSE STRING (v-font))).
  END.
  v-label = TRIM(v-label).
  IF i-label ne v-label THEN DO:
    RUN set-attribute-list IN ph_SmO 
        ("Label = ":U + (IF v-label eq ? THEN '':U ELSE v-label)).
  END.
  IF i-Margin-Pixels ne v-Margin-Pixels THEN DO:
   RUN set-attribute-list IN ph_SmO 
       ("Margin-Pixels = ":U + STRING (v-margin-pixels)).
   RUN set-size IN ph_SMO (?,?).
  END.
  IF i-style ne v-style THEN DO:
    RUN set-attribute-list IN ph_SmO ("Style = ":U + v-style).
    RUN apply-style IN ph_SmO.
  END.
  
  /* The supported link is the OTHER end of the Link-Name. */
  IF v-Link-Name ne i-Link-Name THEN DO:
    ASSIGN i = NUM-ENTRIES (v-link-name,"-":U).
           ch = IF i < 2 THEN '':U ELSE ENTRY(i,v-link-name, "-":U)
           .
    IF NOT CAN-DO ('Source,Target':U, ch) THEN DO:
      MESSAGE 'The Link-Name of the SmartObject does not indicate direction.'
              '(It does not specify "-Target" or "-Source".)' 
              VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO v-Link-Name.
      RETURN NO-APPLY.
    END.
    /* Assign the value back in the object */
    RUN set-attribute-list IN ph_SmO ("Link-Name = ":U + v-Link-Name).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SP-attr-dialog SP-attr-dialog
ON WINDOW-CLOSE OF FRAME SP-attr-dialog /* Option Panel Attributes */
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
       (INPUT 'Choose Font':U,    /* Title */
        INPUT ?,                  /* Default Font */
        INPUT-OUTPUT v-font,      /* Font to Change */
        OUTPUT       pressed_OK). /* User responce */
  IF pressed_OK THEN RUN show-font.
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


&Scoped-define SELF-NAME v-Font
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-Font SP-attr-dialog
ON LEAVE OF v-Font IN FRAME SP-attr-dialog /* Font */
DO:
  IF INPUT v-font > FONT-TABLE:NUM-ENTRIES THEN DO:
    MESSAGE "Font" v-font "does not exist." SKIP
            "Font number must be between 0 and" 
            TRIM(STRING(FONT-TABLE:NUM-ENTRIES,">>9.":U))
            VIEW-AS ALERT-BOX ERROR.
    DISPLAY v-font WITH FRAME {&FRAME-NAME}.
    RETURN NO-APPLY.
  END.
  ELSE DO:
    ASSIGN v-font.
    RUN show-font.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-Label
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-Label SP-attr-dialog
ON LEAVE OF v-Label IN FRAME SP-attr-dialog /* Label */
DO:
  v-label = TRIM(SELF:SCREEN-VALUE).
  RUN show-label.
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


&Scoped-define SELF-NAME v-style
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-style SP-attr-dialog
ON VALUE-CHANGED OF v-style IN FRAME SP-attr-dialog /* Style */
DO:
  ASSIGN {&SELF-NAME}.
  RUN show-style.
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
                   &CONTEXT = {&OptionPanel_Attributes_Dlg_Box} }

/* ***************************  Main Block  *************************** */
       
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  /* Get the values of the attributes in the SmartObject that can be 
     changed in this dialog-box. */
  RUN get-SmO-attributes.
 
  /* Set the state of the interface and wait-for user input. */
  RUN show-edge-pixels.
  RUN show-margin-pixels.
  RUN show-label.
  RUN show-font.
  RUN show-style.  
   
  /* Enable the interface. */         
  RUN enable_UI.

  /* Set the cursor */
  RUN adecomm/_setcurs.p ("":U).
  
  /* Don't allow SPACES in some fields. */
  ON ' ':U OF v-Case-Attribute, v-Case-Changed-Event, 
              v-Link-Name, v-Options-Attribute 
    RETURN NO-APPLY.
 
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.

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
  DISPLAY v-style v-Label v-Link-Name v-Options-Attribute v-Case-Attribute 
          v-Case-Changed-Event 
      WITH FRAME SP-attr-dialog.
  ENABLE Box v-style v-Label v-show v-margin-pixels v-Font btn_Font v-Link-Name 
         v-Options-Attribute v-Case-Attribute v-Case-Changed-Event 
      WITH FRAME SP-attr-dialog.
  VIEW FRAME SP-attr-dialog.
  {&OPEN-BROWSERS-IN-QUERY-SP-attr-dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-SmO-attributes SP-attr-dialog 
PROCEDURE get-SmO-attributes :
/*------------------------------------------------------------------------------
  Purpose:     Ask the "parent" SmartObject for the attributes that can be 
               changed in this dialog.  Save some of the initial-values.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR i  AS INTEGER NO-UNDO.
  DEF VAR ch AS CHAR NO-UNDO.
  DEF VAR l  AS LOGICAL NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    
    RUN get-attribute IN ph_SMO ('Case-Attribute':U).
    v-Case-Attribute = RETURN-VALUE.
    RUN get-attribute IN ph_SMO ('Case-Changed-Event':U).
    v-Case-Changed-Event = IF RETURN-VALUE eq ? THEN '' ELSE RETURN-VALUE.
    RUN get-attribute IN ph_SMO ('Edge-Pixels':U).
    IF RETURN-VALUE ne ? THEN v-edge-pixels = INTEGER (RETURN-VALUE).
    RUN get-attribute IN ph_SMO ('Font':U).
    v-font= INTEGER (RETURN-VALUE).
    RUN get-attribute IN ph_SMO ('Label':U).
    v-label = RETURN-VALUE.
    RUN get-attribute IN ph_SMO ('Margin-Pixels':U).
    IF RETURN-VALUE ne ? THEN v-Margin-pixels = INTEGER (RETURN-VALUE).
    RUN get-attribute IN ph_SMO ('Options-Attribute':U).
    v-Options-Attribute = RETURN-VALUE.
    RUN get-attribute IN ph_SMO ('Style':U).
    v-Style = RETURN-VALUE.
    /* If the style is not recognized, then call it a "Custom Style". This
       needs to be added to the list. */
    IF v-style:LOOKUP(v-Style) eq 0 
    THEN l = v-style:ADD-FIRST (v-style).
  
    /* The supported link is the OTHER end of the Link-Name. */
    RUN get-attribute IN ph_SMO ('Link-Name':U).
    ASSIGN v-Link-Name = RETURN-VALUE
           i = NUM-ENTRIES (v-Link-Name,"-":U)
           ch = IF i < 2 THEN '':U ELSE ENTRY(i,v-Link-Name, "-":U)
           .
    IF NOT CAN-DO ('Source,Target':U, ch) THEN DO:
      v-Link-Name = IF ch ne '':U 
                    THEN v-Link-Name + '-Target':U
                    ELSE (IF v-Case-Attribute ne '':U THEN
                             v-Case-attribute ELSE 'Option':U) + '-Target':U.
                       
      /* Whoops! The Link-Type seems invalid...set it to something reasonable. */
      MESSAGE 'The Link-Name of the SmartObject does not indicate direction.'
              '(It does not specify "-Target" or "-Source".)' SKIP(1)
              'The Link Name to link to will be set to' v-Link-Name + '.':U
              VIEW-AS ALERT-BOX WARNING.
    END.
        
    /* Save some values for later comparison. */
    ASSIGN i-font           = v-font
           i-label          = v-label
           i-link-name      = v-link-Name
           i-margin-pixels  = v-margin-pixels
           i-style          = v-style
           .
  END. /* DO WITH FRAME... */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE show-font SP-attr-dialog 
PROCEDURE show-font :
/*------------------------------------------------------------------------------
  Purpose:    Show the desired font in the fill-in and in the Sample.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    DISPLAY v-font WITH FRAME {&FRAME-NAME}.
    IF VALID-HANDLE (h_sample) THEN h_sample:FONT = v-font.
    /* Also change the font of the label. */
    IF sample-label:FONT ne v-font THEN DO:
      sample-label:FONT = v-font.
      RUN show-label.
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE show-label SP-attr-dialog 
PROCEDURE show-label :
/*------------------------------------------------------------------------------
  Purpose:    Show the desired label in the Sample.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN sample-label:HIDDEN = yes.
    IF v-label ne '':U
    THEN ASSIGN 
           sample-label:SCREEN-VALUE = v-label 
           sample-label:HEIGHT-P     = FONT-TABLE:GET-TEXT-HEIGHT-P (v-font)
           sample-label:Y            =
               MAX (0, Box:Y - ((sample-label:HEIGHT-P - Box:EDGE-PIXELS) / 2))
           sample-label:WIDTH-P      =
               MIN (Box:WIDTH-P - 10, FONT-TABLE:GET-TEXT-WIDTH-P 
                                         (sample-label:SCREEN-VALUE,v-font))
           sample-label:HIDDEN       = no
           .
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
  
  DO WITH FRAME {&FRAME-NAME}:
    DISPLAY v-Margin-Pixels WITH FRAME {&FRAME-NAME}.
    
    /* Our sample can only show margins up to a certain size. */
    iMargin = MIN(v-Margin-Pixels, Box:HEIGHT-P / 2).
    /* Only change the margin if we need to. */
    IF VALID-HANDLE (h_sample) AND iMargin ne (Box:X - h_sample:X) THEN DO:
      /* Size the sample. */
      ASSIGN h_sample:HIDDEN = yes
             h_sample:WIDTH-P  = MAX (1, Box:WIDTH-P - 2 * iMargin)
             h_sample:HEIGHT-P = MAX (1, Box:HEIGHT-P - 2 * iMargin)
             h_sample:Y        = Box:Y + iMargin
             h_sample:X        = Box:X + iMargin 
             h_sample:HIDDEN   = no
           NO-ERROR.
    END. /* IF iMargin... */
  END. /* DO WITH FRAME... */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE show-style SP-attr-dialog 
PROCEDURE show-style :
/*------------------------------------------------------------------------------
  Purpose:     Show a Sample of the style.  This will be either a dynamic 
               radio-set, selection-list, or combo-box.
  Parameters:  <none>
  Notes:       This sets the variable, h_sample.
------------------------------------------------------------------------------*/
  DEFINE VAR i_margin AS INTEGER NO-UNDO.
  
  /* Delete the previous sample. */
  IF VALID-HANDLE(h_sample) THEN DELETE WIDGET h_sample.
  
  CASE v-style:
    WHEN "SELECTION-LIST":U THEN
      CREATE SELECTION-LIST h_sample ASSIGN
        LIST-ITEMS = "Option 1,Option 2,Option 3,Option 4"
        SCROLLBAR-VERTICAL = yes.

    WHEN "COMBO-BOX":U THEN 
      CREATE COMBO-BOX h_sample ASSIGN 
        LIST-ITEMS = "Option 1,Option 2,Option 3,Option 4".

    WHEN "HORIZONTAL RADIO-SET" OR WHEN "VERTICAL RADIO-SET":U THEN 
      CREATE RADIO-SET h_sample ASSIGN
        RADIO-BUTTONS = "Option 1,1,Option 2,2"
        HORIZONTAL    = (v-style BEGINS "H":U).

    OTHERWISE
      CREATE TEXT h_sample ASSIGN
        SCREEN-VALUE = "Sample not available.".
           
  END CASE.
  
  /* Size and Parent the sample. Size this inside the sample Box using the actual
     margin-pixels (v-margin-pixels), unless it is larger than 1/2 the box height.
   */
  IF VALID-HANDLE (h_sample) THEN DO WITH FRAME {&FRAME-NAME}:
    ASSIGN i_margin           = MIN(v-margin-pixels, (Box:HEIGHT-P + 1 / 2))
           h_sample:FRAME     = FRAME {&FRAME-NAME}:HANDLE
           h_sample:FONT      = v-Font
           h_sample:X         = Box:X + i_margin
           h_sample:WIDTH-P   = Box:WIDTH-P - 2 * i_margin
           h_sample:Y         = Box:Y + i_margin
           h_sample:HEIGHT-P  = Box:Height-P - 2 * i_margin WHEN v-style NE 'Combo-box':U
           h_sample:SENSITIVE = yes
           h_sample:HIDDEN    = no
           .
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


