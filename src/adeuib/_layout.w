&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME cust-layout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS cust-layout 
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

  File:   File: _layout.w

  Description:
     Ask the user to specify the layout type for a particular window.
     The user may select exisitng layouts from the combo-box or define
     a new type.
     
  Input Parameters:
      <none>

  Output Parameters:
      <none>
      
  Author: D. Ross Hunter

  Created: 5/12/93

  Modified:
    7/14/94 wood    UIB Dialog size is now Inner-size (no border)    
    6/23/96 wood    Change file to a .w file
    6/15/99 tsm     Added support for separator-fgcolor

-----------------------------------------------------------------------------*/
/* ===================================================================== */
/*                    SHARED VARIABLES Definitions                       */
/* ===================================================================== */
&GLOBAL-DEFINE WIN95-BTN YES
{adecomm/adestds.i}       /* Standard Include File for ADE tools         */
{adeuib/uibhlp.i}         /* Help String Definitions                     */
{adeuib/uniwidg.i}        /* Universal widget TEMP-TABLE definitions     */
{adeuib/triggers.i}       /* definitions for trigger code                */
{adeuib/layout.i}         /* Definitions of the layout records           */
{adeuib/sharvars.i}       /* UIB shared variables                        */

/* Local variables */
DEFINE VAR       stat        AS LOGICAL   NO-UNDO.
DEFINE VAR       StreamDiff  AS INTEGER   NO-UNDO.
DEFINE VAR       stupid      AS LOGICAL   NO-UNDO.
DEFINE VAR       isa-SmO     AS   LOGICAL NO-UNDO.
DEFINE VAR       chkstring   AS CHAR      NO-UNDO.
DEFINE VAR       def-layouts AS CHAR      NO-UNDO 
       INITIAL "{&Standard-Layouts}".
DEFINE VAR       loname      AS CHAR      NO-UNDO.
DEFINE VAR       origname    AS CHAR      NO-UNDO.
DEFINE VAR       origtype    AS LOGICAL   NO-UNDO.

DEF NEW SHARED STREAM P_4GL.

DEFINE BUFFER x_U FOR _U.
DEFINE BUFFER x_L FOR _L.
DEFINE BUFFER m_L FOR _L.
DEFINE BUFFER p_U FOR _U.
DEFINE BUFFER p_C FOR _C.
DEFINE BUFFER p_L FOR _L.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME cust-layout

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btn_new cb-layout l_gui-based rm-lo ~
c_expression c_comment 
&Scoped-Define DISPLAYED-OBJECTS cb-layout l_gui-based rm-lo c_expression ~
c_comment Layout-status 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn_chksyn 
     LABEL "Check &Syntax" 
     SIZE 15 BY 1.14.

DEFINE BUTTON btn_new 
     LABEL "&New..." 
     SIZE 15 BY 1.14.

DEFINE VARIABLE cb-layout AS CHARACTER FORMAT "X(35)" 
     LABEL "&Layout" 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEMS "","" 
     SIZE 42.6 BY 1 NO-UNDO.

DEFINE VARIABLE c_comment AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 66 BY 3.76
     FONT 4.

DEFINE VARIABLE c_expression AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 66 BY 3.38
     FONT 2.

DEFINE VARIABLE Layout-status AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 59 BY .62 NO-UNDO.

DEFINE VARIABLE l_gui-based AS LOGICAL INITIAL yes 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "&GUI Based", yes,
"&Character Based", no
     SIZE 37 BY 1.1.

DEFINE VARIABLE Activate AS LOGICAL INITIAL no 
     LABEL "&Activate Layout" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY 1.1 NO-UNDO.

DEFINE VARIABLE l_no-expression AS LOGICAL INITIAL no 
     LABEL "Don't use Run-time Expression" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY 1.1 NO-UNDO.

DEFINE VARIABLE rm-lo AS LOGICAL INITIAL no 
     LABEL "Dele&te Layout" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY 1.1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME cust-layout
     btn_new AT ROW 1.24 COL 54
     cb-layout AT ROW 1.29 COL 8.4 COLON-ALIGNED
     l_gui-based AT ROW 2.33 COL 10 NO-LABEL
     rm-lo AT ROW 2.33 COL 49
     Activate AT ROW 2.33 COL 49
     c_expression AT ROW 5.38 COL 3 NO-LABEL
     btn_chksyn AT ROW 8.81 COL 54
     l_no-expression AT ROW 8.86 COL 3
     c_comment AT ROW 11.29 COL 3 NO-LABEL
     Layout-status AT ROW 3.62 COL 8 COLON-ALIGNED NO-LABEL
     "Run-time Expression:" VIEW-AS TEXT
          SIZE 25 BY .81 AT ROW 4.57 COL 3
     "Comment:" VIEW-AS TEXT
          SIZE 13 BY .81 AT ROW 10.48 COL 3
     SPACE(54.19) SKIP(3.76)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Alternate Layout":U.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX cust-layout
   L-To-R                                                               */
ASSIGN 
       FRAME cust-layout:SCROLLABLE       = FALSE
       FRAME cust-layout:HIDDEN           = TRUE.

/* SETTINGS FOR TOGGLE-BOX Activate IN FRAME cust-layout
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       Activate:HIDDEN IN FRAME cust-layout           = TRUE.

/* SETTINGS FOR BUTTON btn_chksyn IN FRAME cust-layout
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Layout-status IN FRAME cust-layout
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l_no-expression IN FRAME cust-layout
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       l_no-expression:HIDDEN IN FRAME cust-layout           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME cust-layout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cust-layout cust-layout
ON GO OF FRAME cust-layout /* Alternate Layout */
DO:
  DEFINE VAR  ok-to-del      AS   LOGICAL     NO-UNDO.
  DEFINE VAR  del-u-rec      AS   RECID       NO-UNDO.
  DEFINE VAR  frm-shrink     AS   LOGICAL     NO-UNDO.
  DEFINE VAR  lbl            AS   CHARACTER   NO-UNDO.
  DEFINE VAR  old-label-col  AS   DECIMAL     NO-UNDO.
  
  ASSIGN loname = cb-layout:SCREEN-VALUE IN FRAME cust-layout.

  /* Starting in 8.1, we allow blank expressions. */  
  FIND _LAYOUT WHERE _LAYOUT._LO-NAME = loname.
  RUN save-screen-values.

  IF NOT _LAYOUT._ACTIVE THEN DO:  /* This layout has been marked inactive */
    IF CAN-DO(def-layouts,loname) THEN DO:
      /* A standard layout keep the def */
      MESSAGE loname "has been marked inactive for the current window." SKIP
              "The layout information will be lost." 
           VIEW-AS ALERT-BOX WARNING BUTTONS OK-CANCEL UPDATE ok-to-del.
      IF NOT ok-to-del THEN RETURN NO-APPLY.
      RUN adeuib/_winsave.p (_h_win, FALSE).
    END. /* IF loname is a default layout */
    ELSE DO:                               /* Non-standard, trash it */
      MESSAGE loname "has been marked inactive for the current window." SKIP
              "The layout information will be lost and if no other" SKIP
              "active window has this layout, the definition for" loname
              "will be removed from the layout list."
           VIEW-AS ALERT-BOX WARNING BUTTONS OK-CANCEL UPDATE ok-to-del.
      IF NOT ok-to-del THEN RETURN NO-APPLY.
    END.  /* Non-standard layout see if to be trashed */
         
    IF ok-to-del THEN DO:  /* We need to delete the _L's and potentially
                              a definition for the layout                */
      /* Delete entirely any widget that is used only in this layout. 
         This is not an undoable operation. */
      FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _U._HANDLE:
        FOR EACH _L WHERE _L._u-recid = RECID(x_U) AND
                          _L._LO-NAME = loname:
          IF NOT CAN-FIND(FIRST x_L WHERE x_L._u-recid = _L._u-recid AND
                                          NOT x_L._REMOVE-FROM-LAYOUT AND
                                          x_L._LO-NAME NE _L._LO-NAME) 
          THEN RUN adeuib/_delet_u.p (INPUT _L._u-recid, TRUE /* trash */ ).
          DELETE _L.  /* Delete this layout record */
        END.  /* FOR EACH _L of this loname */
      END.  /* FOR EACH x_U of window */
    END.  /* If we are deleting _L's */
    IF NOT CAN-FIND(FIRST _L WHERE _L._LO-NAME = loname) AND
       NOT CAN-DO(def-layouts,loname) THEN DO:  /* Delete the layout */
      FIND _LAYOUT WHERE _LAYOUT._LO-NAME = loname.
      DELETE _LAYOUT.
    END.  /* Delete the _LAYOUT Record for this non-standard layout */
    /* Make the master layout the current layout */
    FIND _LAYOUT WHERE _LAYOUT._LO-NAME = '{&Master-Layout}':U.
    loname = _LAYOUT._LO-NAME.
  END.  /* The layout has been marked inactive */

  IF AVAILABLE _U AND _U._LAYOUT-NAME NE loname THEN DO:
  /* User has indicated a different layout. 
     One of two possibilities exist:
     
    1) User has indicated an existing layout:
         - Must recreate window using both _U and _L records.
         - Must dis-able some of the property sheet fields.
         
    2) User has indicated a new layout:
         - Must generate a _L record for each widget in the window.
         - Must recreate window only if swtiched between TTY & GUI.
         - Must dis-able some of the property sheet fields.
                                                                                  */
    FIND _LAYOUT WHERE _LAYOUT._LO-NAME = loname.                                                                               
    /* IF New - generate _L records                                               */
    IF loname NE origname AND  /* This is different from layout currently showing */
       NOT CAN-FIND(FIRST _L WHERE _L._LO-NAME = loname AND _L._u-recid = RECID(_U))
    THEN DO:
      _LAYOUT._ACTIVE = TRUE.

      FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _U._HANDLE,
          EACH x_L WHERE RECID(x_L)         = x_U._lo-recid AND 
               x_L._LO-NAME                 = IF NOT ok-to-del THEN origname
                                              ELSE "Master Layout":U:
               
        /* Find the master record for reference */
        FIND m_L WHERE m_L._u-recid = RECID(x_U) AND
                       m_L._LO-NAME = '{&Master-Layout}':U.

        IF NOT _LAYOUT._GUI-BASED THEN DO:
          IF x_U._TYPE = "FRAME" AND (x_L._COL + x_L._WIDTH + (IF x_L._NO-BOX
                                       THEN 0 ELSE 2) > 83) THEN frm-shrink = true.
          IF x_U._TYPE = "DIALOG-BOX" AND (x_L._WIDTH + (IF x_L._NO-BOX THEN 0 ELSE 2)
                                    > 83) THEN frm-shrink = true.
        END. 

        /* There can be cases (usually our bugs) where a Layout record 
           can exist for some objects (even though the parent does not
           have a record. So check for a _L record before we create it. */
        FIND _L WHERE _L._LO-NAME eq loname
                  AND _L._u-recid eq RECID(x_U) NO-ERROR.
        IF NOT AVAILABLE _L THEN DO:                
          CREATE _L.
          ASSIGN _L._LO-NAME          = loname
                 _L._u-recid          = RECID(x_U).        
        END.
        /* Assign the rest of the information for this layout. */
        ASSIGN x_U._lo-recid          = RECID(_L)
               x_U._LAYOUT-NAME       = loname
               _L._BGCOLOR            = IF _LAYOUT._GUI-BASED THEN 
                                                 (IF x_L._WIN-TYPE THEN x_L._BGCOLOR
                                                                   ELSE
                                                 (IF m_L._WIN-TYPE THEN m_L._BGCOLOR
                                                                   ELSE ?))
                                                              ELSE m_L._BGCOLOR
               _L._COL                = IF _LAYOUT._GUI-BASED THEN x_L._COL
                                                              ELSE INTEGER(x_L._COL)
               _L._COL-MULT           = IF _LAYOUT._GUI-BASED THEN
                                                (IF m_L._WIN-TYPE THEN m_L._COL-MULT
                                                                  ELSE 1)
                                                              ELSE _tty_col_mult
               _L._CONVERT-3D-COLORS  = x_L._CONVERT-3D-COLORS
               _L._CUSTOM-POSITION    = x_L._CUSTOM-POSITION
               _L._CUSTOM-SIZE        = x_L._CUSTOM-SIZE
               _L._FGCOLOR            = IF _LAYOUT._GUI-BASED THEN
                                                 (IF x_L._WIN-TYPE THEN x_L._FGCOLOR
                                                                   ELSE
                                                 (IF m_L._WIN-TYPE THEN m_L._FGCOLOR
                                                                   ELSE ?))
                                                              ELSE m_L._FGCOLOR
               _L._FONT               = IF _LAYOUT._GUI-BASED THEN
                                                 (IF x_L._WIN-TYPE THEN x_L._FONT
                                                                   ELSE
                                                 (IF m_L._WIN-TYPE THEN m_L._FONT
                                                                   ELSE ?))
                                                              ELSE m_L._FONT
               _L._HEIGHT             = IF _LAYOUT._GUI-BASED THEN x_L._HEIGHT
                                        ELSE IF x_U._TYPE = "WINDOW" THEN
                                                  (IF x_U._SUBTYPE eq "Design-Window":U
                                                  THEN MIN(21,INTEGER(x_L._HEIGHT))
                                                  ELSE 21)
                                        ELSE IF x_U._TYPE = "FRAME" THEN
                                                  MIN(21,INTEGER(x_L._HEIGHT))
                                        ELSE IF CAN-DO("FILL-IN,TOGGLE,BUTTON,TEXT",
                                                       x_U._TYPE)  THEN 1
                                        ELSE INTEGER(x_L._HEIGHT)
               _L._NO-FOCUS           = IF _LAYOUT._GUI-BASED THEN x_L._NO-FOCUS
                                                              ELSE NO
               _L._NO-LABELS          = x_L._NO-LABELS
               _L._REMOVE-FROM-LAYOUT = x_L._REMOVE-FROM-LAYOUT
               _L._ROW                = IF _LAYOUT._GUI-BASED THEN x_L._ROW
                                                              ELSE INTEGER(x_L._ROW)
               _L._ROW-MULT           = IF _LAYOUT._GUI-BASED THEN
                                                (IF m_L._WIN-TYPE THEN m_L._ROW-MULT
                                                                  ELSE 1)
                                                              ELSE _tty_row_mult
               _L._WIDTH              = IF _LAYOUT._GUI-BASED THEN x_L._WIDTH
                                        ELSE IF x_U._TYPE = "WINDOW" THEN
                                                  (IF x_U._SUBTYPE eq "Design-Window":U
                                                   THEN MIN(80,x_L._WIDTH)
                                                   ELSE 80)
                                        ELSE IF x_U._TYPE = "FRAME" THEN 
                                                                    MIN(80,x_L._WIDTH)
                                        ELSE INTEGER(x_L._WIDTH)
               _L._WIN-TYPE           = _LAYOUT._GUI-BASED.

        /* If there is a side-label we need to make a column adjustment */
        IF CAN-DO("FILL-IN,COMBO-BOX",x_U._TYPE) AND x_U._ALIGN = "L":U AND
           _L._WIN-TYPE NE x_L._WIN-TYPE THEN DO:
          /* First find the frame to see if there are side-labels or not */
          FIND p_U WHERE RECID(p_U) = x_U._PARENT-RECID.
          FIND p_C WHERE RECID(p_C) = p_U._x-recid.
          FIND FIRST p_L WHERE p_L._u-recid = RECID(p_U) AND
                               p_L._LO-NAME = x_L._LO-NAME.
          IF x_U._LABEL-SOURCE = "D":U THEN DO:
            IF x_U._TABLE EQ ? THEN lbl = x_U._NAME.
            ELSE RUN adeuib/_strfmt.p (x_U._LABEL, x_U._LABEL-ATTR, no, OUTPUT lbl).
          END.
          ELSE lbl = x_U._LABEL.
          lbl = REPLACE(lbl, "&":U, "":U).
          IF p_C._SIDE-LABELS AND NOT x_L._NO-LABELS AND  NOT p_L._NO-LABELS AND
             lbl NE "" THEN DO:
            lbl = lbl + ":":U.
            IF NOT _L._WIN-TYPE THEN DO:  /* Going from GUI TO TTY */
              ASSIGN /* Find the correct column given it is left aligned */
                     old-label-col = x_L._COL - 1 - 
                              FONT-TABLE:GET-TEXT-WIDTH-CHARS(lbl, x_L._FONT)
                     /* Now calculate where tty col should be */
                     _L._COL = INTEGER(old-label-col + LENGTH(lbl,"CHARACTER":U) + 1).
            END.  /* Going from GUI TO TTY */
            ELSE DO: /* Going from TTY TO GUI */
              ASSIGN /* Find the correct column given it is left aligned */
                     old-label-col = x_L._COL - 1 - LENGTH(lbl,"CHARACTER":U)                        
                     /* Now calculate where tty col should be */
                     _L._COL = old-label-col +
                               FONT-TABLE:GET-TEXT-WIDTH-CHARS(lbl, _L._FONT) + 1.  
            END. /* Going from TTY TO GUI */
          END. /* If there are side-labels */
        END.

        IF x_U._TYPE = "RECTANGLE" THEN
          ASSIGN _L._EDGE-PIXELS      = x_L._EDGE-PIXELS
                 _L._FILLED           = x_L._FILLED
                 _L._GRAPHIC-EDGE     = x_L._GRAPHIC-EDGE.
        ELSE
          ASSIGN _L._3-D               = x_L._3-D
                 _L._NO-BOX            = x_L._NO-BOX
                 _L._NO-UNDERLINE      = x_L._NO-UNDERLINE
                 _L._SEPARATORS        = x_L._SEPARATORS
                 _L._SEPARATOR-FGCOLOR = IF _LAYOUT._GUI-BASED THEN
                                                (IF x_L._WIN-TYPE THEN x_L._SEPARATOR-FGCOLOR
                                                                  ELSE
                                                (IF m_L._WIN-TYPE THEN m_L._SEPARATOR-FGCOLOR
                                                                  ELSE ?))
                                                               ELSE m_L._SEPARATOR-FGCOLOR
                 _L._TITLE-BGCOLOR     = IF _LAYOUT._GUI-BASED THEN
                                                (IF x_L._WIN-TYPE THEN x_L._TITLE-BGCOLOR
                                                                  ELSE
                                                (IF m_L._WIN-TYPE THEN m_L._TITLE-BGCOLOR
                                                                  ELSE ?))
                                                               ELSE m_L._TITLE-BGCOLOR
                 _L._TITLE-FGCOLOR     = IF _LAYOUT._GUI-BASED THEN
                                                (IF x_L._WIN-TYPE THEN x_L._TITLE-FGCOLOR
                                                                  ELSE
                                                (IF m_L._WIN-TYPE THEN m_L._TITLE-FGCOLOR
                                                                  ELSE ?))
                                                               ELSE m_L._TITLE-FGCOLOR
                 _L._VIRTUAL-HEIGHT    = MAX((IF _LAYOUT._GUI-BASED
                                                 THEN x_L._VIRTUAL-HEIGHT
                                                 ELSE INTEGER(x_L._VIRTUAL-HEIGHT)),
                                                 _L._HEIGHT)
                 _L._VIRTUAL-WIDTH     = MAX((IF _LAYOUT._GUI-BASED
                                                 THEN x_L._VIRTUAL-WIDTH
                                                 ELSE INTEGER(x_L._VIRTUAL-WIDTH)),
                                                 _L._WIDTH).
      END.  /* FOR EACH x_U and x_L */
      IF frm-shrink THEN
        MESSAGE
          "At least one frame in this layout is wider than 80 characters." SKIP
          "It will be truncated to fit on a 80 BY 24 character screen."
           VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    END.  /* A new layout */
    ELSE DO:  /* An exisiting layout */
      FOR EACH x_L WHERE x_L._LO-NAME = loname,
          EACH x_U WHERE RECID(x_U) = x_L._u-recid AND
               x_U._WINDOW-HANDLE = _U._WINDOW-HANDLE:
         ASSIGN x_U._lo-recid    = RECID(x_L)
                x_U._LAYOUT-NAME = loname.
      END.
    END. /* If this was an exisiting layout */ 
    ASSIGN _LAYOUT._ACTIVE = YES.
  END.  /* If layout name has been changed from _U._LAYOUT-NAME to loname */

  FIND _L WHERE RECID(_L) = _U._lo-recid.
  ASSIGN _U._LAYOUT-NAME = loname
         _cur_win_type   = _LAYOUT._GUI-BASED
         _cur_col_mult   = IF _LAYOUT._GUI-BASED THEN 1 ELSE _tty_col_mult
         _cur_row_mult   = IF _LAYOUT._GUI-BASED THEN 1 ELSE _tty_row_mult.

  IF _U._WIN-TYPE NE _cur_win_type THEN DO:
    /* CHANGE all of the _L's, Will Morph the WINDOW in UIBMPROE.I */
    FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _U._HANDLE,
        EACH x_L WHERE RECID(x_L)         = x_U._lo-recid:
      ASSIGN x_L._WIN-TYPE = _LAYOUT._GUI-BASED
             x_L._COL-MULT = _cur_col_mult
             x_L._ROW-MULT = _cur_row_mult.
      IF x_U._HANDLE NE _U._HANDLE  /* Not the window itself */ THEN
        ASSIGN x_U._WIN-TYPE = _cur_win_type.
    END.
  END.
  
  /* Only Page 0 supports alternate layouts. */
  IF loname ne "{&Master-Layout}" AND _P._page-current NE 0
  THEN RUN adeuib/_showpag.p (RECID(_P), 0).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_chksyn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_chksyn cust-layout
ON CHOOSE OF btn_chksyn IN FRAME cust-layout /* Check Syntax */
DO:
  /* Only check edittable expressions. */
  IF c_expression:READ-ONLY eq no THEN DO: 
    chkstring = c_expression:SCREEN-VALUE.
    RUN chksyn.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_new
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_new cust-layout
ON CHOOSE OF btn_new IN FRAME cust-layout /* New... */
DO:
  RUN addlist.
  /* On windows, we can make sure the combo box is sized correctly. */
  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
    ASSIGN cb-layout:INNER-LINES = MIN (MAX(3, cb-layout:NUM-ITEMS + 1), 10).
  &ENDIF
  ASSIGN loname = cb-layout:SCREEN-VALUE.
  RUN set-screen-elements. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-layout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-layout cust-layout
ON VALUE-CHANGED OF cb-layout IN FRAME cust-layout /* Layout */
DO:
   IF loname NE SELF:SCREEN-VALUE THEN DO:
     /* Save the values for the OLD layout */
     FIND _LAYOUT WHERE _LAYOUT._LO-NAME = loname.
     RUN save-screen-values.
     /* Display the values for the NEW layout. */
     ASSIGN loname = SELF:SCREEN-VALUE.
     RUN set-screen-elements.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l_gui-based
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l_gui-based cust-layout
ON VALUE-CHANGED OF l_gui-based IN FRAME cust-layout
DO:
  IF CAN-DO(def-layouts, loname) THEN DO:
    BELL.
    RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l_no-expression
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l_no-expression cust-layout
ON VALUE-CHANGED OF l_no-expression IN FRAME cust-layout /* Don't use Run-time Expression */
DO:
  /* Change the Expression, if necessary. */
  ASSIGN {&SELF-NAME}.
  _LAYOUT._EXPRESSION = IF l_no-expression THEN "":U ELSE "FALSE":U.
  RUN set-screen-elements.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK cust-layout 


/* *************************  Standard Buttons ************************ */

{ adecomm/okbar.i &FRAME   = {&FRAME-NAME}
                  &TOOL    = "AB"
                  &CONTEXT = {&Custom_Layout_Dlg_Box}
                  }

/* ************************  Main Code Block  *************************** */

FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
FIND _U WHERE RECID(_U) eq _P._u-recid.
FIND _L WHERE RECID(_L) = _U._lo-recid.

ASSIGN loname     = _U._LAYOUT-NAME
       origname   = loname
       /* Update _L for size and position incase the user changed it */
       _L._ROW    = _h_win:ROW
       _L._COL    = _h_win:COLUMN
       _L._WIDTH  = _h_win:WIDTH  / _L._COL-MULT
       _L._HEIGHT = _h_win:HEIGHT / _L._ROW-MULT
       Layout-Status = "The " + loname + " is active in the current window."
       .

/* Is this procedure a SmartObject. */
RUN adeuib/_isa.p ( INTEGER(RECID(_P)), "SmartObject", OUTPUT isa-smo). 

DO WITH FRAME {&FRAME-NAME}:
  /* Populate the combo-box */
  FOR EACH _LAYOUT:
    stat = cb-layout:ADD-LAST(_LAYOUT._LO-NAME).
  END.
  /* On windows, we can make sure the combo box is sized correctly. */
  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
    ASSIGN cb-layout:INNER-LINES = MIN (MAX(3, cb-layout:NUM-ITEMS + 1), 10).
  &ENDIF

  ASSIGN btn_new:HEIGHT-P          = cb-layout:HEIGHT-P
         cb-layout:SCREEN-VALUE    = loname
         rm-lo:AUTO-RESIZE         = FALSE  
         l_no-expression:SENSITIVE = isa-SmO
         l_no-expression:HIDDEN    = NOT isa-SmO
         .
END.
   
dlg_question:
DO TRANSACTION ON ENDKEY UNDO, LEAVE dlg_question
               ON ERROR UNDO, LEAVE  dlg_question:
               
  FIND _U WHERE _U._HANDLE = _h_win.

  ASSIGN loname     = _U._LAYOUT-NAME
         origname   = loname.
         
  FIND _LAYOUT WHERE _LAYOUT._LO-NAME = loname.
  ASSIGN origtype = _LAYOUT._GUI-BASED.
  
  IF _U._WIN-TYPE = ? AND loname = "{&Master-Layout}":U THEN
    ASSIGN _cur_win_type      = _LAYOUT._GUI-BASED
           _U._WIN-TYPE       = _cur_win_type.
  
  RUN set-screen-elements.      
  RUN enable_UI.
  IF loname = "Master Layout" THEN
    ASSIGN Activate:VISIBLE = FALSE
           rm-lo:VISIBLE    = FALSE.
         
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.

END.
FIND _L WHERE RECID(_L) = _U._lo-recid.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addlist cust-layout 
PROCEDURE addlist :
/*------------------------------------------------------------------------------
  Purpose:     Ask the user for the name of a new layout and add it to the list.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Definitions of the field level widgets                                */
  &IF {&OKBOX} &THEN
    DEFINE RECTANGLE RECT-1 {&STDPH_OKBOX}.
  &ENDIF

  DEFINE BUTTON    b_ok        AUTO-GO      LABEL "OK"          {&STDPH_OKBTN}.
  DEFINE BUTTON    b_cancel    AUTO-ENDKEY  LABEL "Cancel"      {&STDPH_OKBTN}.
  DEFINE BUTTON    b_help                   LABEL "&Help"       {&STDPH_OKBTN}.
  
  DEF VAR new-lo LIKE _LAYOUT._LO-NAME NO-UNDO.
  
  DEF FRAME addlo SKIP (1)
      new-lo AT 4 LABEL "New Layout Name"
     {adecomm/okform.i
        &BOX    = RECT-1
        &STATUS = no
        &OK     = b_OK
        &CANCEL = b_Cancel
        &HELP   = b_Help}
    WITH VIEW-AS DIALOG-BOX TITLE "New Layout Name" WIDTH 60 SIDE-LABELS.

   {adecomm/okrun.i
       &FRAME  = "FRAME addlo"
       &BOX    = RECT-1
       &OK     = b_ok
       &CANCEL = b_cancel
       &HELP   = b_help }
       
   ON CHOOSE OF b_help IN FRAME addlo       OR HELP OF FRAME addlo DO:
      RUN  adecomm/_adehelp.p ("AB", "CONTEXT", {&New_Layout_Name_Dlg_Box}, ?).   
   END.
       
   UPDATE new-lo b_ok b_cancel b_help WITH FRAME addlo DEFAULT-BUTTON b_ok.
   
   IF new-lo NE "" THEN DO:
     IF cb-layout:LOOKUP(new-lo) IN FRAME cust-layout > 0 THEN
       FIND _LAYOUT WHERE _LAYOUT._LO-NAME = new-lo.
     ELSE DO: 
       CREATE _LAYOUT.
       ASSIGN stupid = cb-layout:ADD-LAST(new-lo) IN FRAME cust-layout
              cb-layout:SCREEN-VALUE IN FRAME cust-layout = new-lo
              _LAYOUT._EXPRESSION = (IF isa-smo THEN "":U ELSE "FALSE":U)
              _LAYOUT._LO-NAME = new-lo
              _LAYOUT._ACTIVE  = TRUE.
     END.
   END.
END PROCEDURE.  /* addlist */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE chksyn cust-layout 
PROCEDURE chksyn :
/*------------------------------------------------------------------------------
  Purpose:     Check Syntax of the layout expression.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR err-msg         AS CHAR    NO-UNDO.
    DEFINE VAR StreamLength    AS INTEGER NO-UNDO.
          
    RUN adecomm/_setcurs.p ("WAIT":U).                                
    IF _comp_temp_file = ? THEN
      RUN adecomm/_tmpfile.p ({&STD_TYP_UIB_COMPILE}, {&STD_EXT_UIB},OUTPUT _comp_temp_file).
    OUTPUT STREAM P_4GL TO VALUE(_comp_temp_file) NO-ECHO. 
    RUN adeuib/_writedf.p .
    PUT STREAM P_4GL UNFORMATTED "IF (".
        
    StreamLength = SEEK (P_4GL).
    PUT STREAM P_4GL UNFORMATTED chkstring ") THEN RETURN." SKIP.
    OUTPUT STREAM P_4GL CLOSE. 

    COMPILE VALUE(_comp_temp_file) NO-ERROR.
    IF NOT COMPILER:ERROR THEN DO:
       MESSAGE "Syntax is correct." VIEW-AS ALERT-BOX INFORMATION.
    END.
    ELSE DO:
       StreamDiff = StreamLength - INTEGER(COMPILER:FILE-OFFSET).
       IF INDEX(ERROR-STATUS:GET-MESSAGE(1),'"(". (247)') > 0 THEN
         err-msg = "~"" + c_EXPRESSION:SCREEN-VALUE IN FRAME cust-layout +
                   "~" is not a valid logical expression.".
       ELSE err-msg = error-status:get-message(1) + ".".
       MESSAGE err-msg VIEW-AS ALERT-BOX ERROR.
       ASSIGN c_EXPRESSION:CURSOR-OFFSET IN FRAME cust-layout = MAX(1,StreamDIFF)
              NO-ERROR.
    END.
  
    OS-DELETE VALUE(_comp_temp_file).  
    RUN adecomm/_setcurs.p ("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI cust-layout  _DEFAULT-DISABLE
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
  HIDE FRAME cust-layout.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI cust-layout  _DEFAULT-ENABLE
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
  DISPLAY cb-layout l_gui-based rm-lo c_expression c_comment Layout-status 
      WITH FRAME cust-layout.
  ENABLE btn_new cb-layout l_gui-based rm-lo c_expression c_comment 
      WITH FRAME cust-layout.
  VIEW FRAME cust-layout.
  {&OPEN-BROWSERS-IN-QUERY-cust-layout}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE save-screen-values cust-layout 
PROCEDURE save-screen-values :
/*------------------------------------------------------------------------------
  Purpose:     Copy the current values of the screen elements into the
               current _LAYOUT record.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN l_gui-based c_expression c_comment
           _LAYOUT._GUI-BASED   = l_gui-based    
           _LAYOUT._EXPRESSION  = c_expression WHEN c_expression:SENSITIVE
           _LAYOUT._COMMENT     = c_comment    WHEN c_comment:SENSITIVE
           .
    /* Check the "Delete Layout" toggle, which is not normally saved. */
    IF rm-lo:SENSITIVE THEN
      ASSIGN rm-lo
             _LAYOUT._ACTIVE = NOT rm-lo.
    ELSE IF Activate:SENSITIVE THEN
      ASSIGN Activate
             _LAYOUT._ACTIVE = Activate.
    ELSE  /* Neither was showing, must be Master Layout */
      ASSIGN rm-lo           = FALSE
             Activate        = TRUE
             _LAYOUT._ACTIVE = TRUE.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-screen-elements cust-layout 
PROCEDURE set-screen-elements :
/*------------------------------------------------------------------------------
  Purpose:     Set the properties of the screen elements based on the layout
               specified in loname.  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FIND _LAYOUT WHERE _LAYOUT._LO-NAME = loname.
  
  ASSIGN rm-lo           = FALSE
         l_gui-based     = _LAYOUT._GUI-BASED
         c_expression    = _LAYOUT._EXPRESSION
         c_comment       = _LAYOUT._COMMENT
         _LAYOUT._ACTIVE = CAN-FIND(FIRST _L
                               WHERE _L._LO-NAME = loname AND
                                     _L._u-recid = RECID(_U))
         Layout-Status   = (IF loname = "Master Layout" THEN "The " ELSE "") +
                           loname + 
                           (IF _LAYOUT._ACTIVE THEN " is " ELSE " is not ") +
                           "active in the current window.".
         
  DISPLAY l_gui-based Layout-Status c_expression c_comment
          WITH FRAME cust-layout.
          
  ASSIGN rm-lo:SENSITIVE IN FRAME cust-layout        = no
         rm-lo:HIDDEN IN FRAME cust-layout           = yes
         Activate:SENSITIVE IN FRAME cust-layout     = no
         Activate:HIDDEN IN FRAME cust-layout        = yes
         l_no-expression:HIDDEN IN FRAME cust-layout = yes.

  IF loname NE "Master Layout":U THEN DO:
    /* Don't let the user remove Master Layout */
    IF _LAYOUT._ACTIVE THEN DO:  /* Offer to opurtunity to deactivate */
      DISPLAY rm-lo l_no-expression WITH FRAME cust-layout.
      ASSIGN rm-lo:CHECKED             = FALSE
             rm-lo:SENSITIVE           = TRUE.
    END. /* If the layout is active */
    ELSE DO:  /* Assume that the user wants to activate this layout */
      DISPLAY Activate l_no-expression WITH FRAME cust-layout.
      ASSIGN Activate:CHECKED   = TRUE
             Activate:SENSITIVE = TRUE.
    END. /* Suggest that the user wants to activate this layout */  
    ASSIGN l_no-expression:HIDDEN    = FALSE
           l_no-expression:SENSITIVE = TRUE.
  END. /* if not the Master Layout */

  DO WITH FRAME {&FRAME-NAME}:
    IF CAN-DO(def-layouts, cb-layout:SCREEN-VALUE) THEN DO:
      ASSIGN l_GUI-BASED:SENSITIVE    = NO
             c_EXPRESSION:READ-ONLY   = YES
             c_COMMENT:READ-ONLY      = YES.
      IF isa-SmO THEN
        ASSIGN l_no-expression:CHECKED   = NO
               l_no-expression:SENSITIVE = NO.
    END.  /* If a default layout */
    ELSE DO:
      ASSIGN l_GUI-BASED:SENSITIVE  = TRUE
             c_comment:READ-ONLY    = FALSE.
      /* Are we allowed to have an expression for this Layout? 
         The default is NO for SmartObjects. */
      IF isa-SmO THEN
        ASSIGN l_no-expression:SENSITIVE = YES
               l_no-expression:CHECKED   = (c_expression eq "")
               c_expression:READ-ONLY    = l_no-expression:CHECKED.    
      ELSE ASSIGN c_EXPRESSION:READ-ONLY = FALSE.  
    END.
          
     /* Make read-only editors GREY.  Allow syntax checking only when the
        user can edit the layout expression. */
     IF c_comment:READ-ONLY eq NO
     THEN ASSIGN c_comment:BGCOLOR = ? WHEN c_comment:BGCOLOR ne ?.
     ELSE ASSIGN c_comment:BGCOLOR = 8 WHEN c_comment:BGCOLOR ne 8.
     IF c_expression:READ-ONLY eq NO
     THEN ASSIGN c_expression:BGCOLOR = ?    WHEN c_expression:BGCOLOR ne ?
                 btn_chksyn:SENSITIVE = YES  WHEN btn_chksyn:SENSITIVE eq NO.
     ELSE ASSIGN c_expression:BGCOLOR = 8    WHEN c_expression:BGCOLOR ne 8
                 btn_chksyn:SENSITIVE = NO   WHEN btn_chksyn:SENSITIVE.
   END.
  
END PROCEDURE.  /* sensitize */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

