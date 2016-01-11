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
/* -------------------------------------------------------------------

FILE: tog-proc.i

Description:
      Internal Procedures for toggle trigger code to be included in
      _prpobj.p.

Author: Tammy St.Pierre Hall 

Date Generated: 04/27/04

Note: This procedure is generated via the Property Sheet Generator and 
      the abAttribute table of the ab database. 
      DO NOT CHANGE THIS FILE WITHOUT UPDATING THE AB DATABASE AND 
      USING THE PROPERTY SHEET GENERATOR TO GENERATE THIS CODE 

------------------------------------------------------------------- */

PROCEDURE 3-D_proc:
  {adeuib/syncloch.i &Master_L   = "_L"
                     &FLD1       = "3-D"
                     &NEW-VALUE1 = "SELF:CHECKED"}
  _L._3-D = SELF:CHECKED.
END.

PROCEDURE AUTO-COMPLETION_proc:
  _F._AUTO-COMPLETION = SELF:CHECKED.
  IF SELF:CHECKED THEN
    ASSIGN h_UNIQUE-MATCH:SENSITIVE = TRUE.
  ELSE DO:
    ASSIGN h_UNIQUE-MATCH:SENSITIVE = FALSE
           h_UNIQUE-MATCH:CHECKED   = FALSE.
    APPLY "VALUE-CHANGED":U TO h_UNIQUE-MATCH.
  END.  /* else do - not checked */
END.

PROCEDURE AUTO-END-KEY_proc:
  _F._AUTO-ENDKEY = SELF:CHECKED.
  IF SELF:CHECKED THEN
    ASSIGN _F._AUTO-GO       = FALSE
           h_AUTO-GO:CHECKED = FALSE.
END.

PROCEDURE AUTO-GO_proc:
  _F._AUTO-GO = SELF:CHECKED.
  IF SELF:CHECKED THEN
    ASSIGN _F._AUTO-ENDKEY        = FALSE
           h_AUTO-END-KEY:CHECKED = FALSE.
END.

PROCEDURE AUTO-INDENT_proc:
  _F._AUTO-INDENT = SELF:CHECKED.
END.

PROCEDURE AUTO-RESIZE_proc:
  _F._AUTO-RESIZE = SELF:CHECKED.
END.

PROCEDURE AUTO-RETURN_proc:
  _F._AUTO-RETURN = SELF:CHECKED.
END.

PROCEDURE BLANK_proc:
  _F._BLANK = SELF:CHECKED.
END.

PROCEDURE CANCEL-BTN_proc:
  _C._cancel-btn-recid = IF SELF:CHECKED THEN RECID(_U) ELSE ?.
END.

PROCEDURE COLUMN-SCROLLING_proc:
  _C._COLUMN-SCROLLING = SELF:CHECKED.
END.

PROCEDURE Control-Box_proc:
  _C._CONTROL-BOX = SELF:CHECKED.
  IF _U._TYPE = "WINDOW":U THEN 
    RUN set_window_controls. 

END.

PROCEDURE CONVERT-3D-COLORS_proc:
  {adeuib/syncloch.i &Master_L   = "_L"
                     &FLD1       = "CONVERT-3D-COLORS"
                     &NEW-VALUE1 = "SELF:CHECKED"}
  _L._CONVERT-3D-COLORS = SELF:CHECKED.
  IF VALID-HANDLE(h_transparent) THEN
  DO:
    IF SELF:CHECKED AND h_transparent:CHECKED THEN
      ASSIGN _F._TRANSPARENT       = FALSE
           h_transparent:CHECKED = FALSE.
  END.  /* if transparent valid */
END.

PROCEDURE DEBLANK_proc:
  _F._DEBLANK = SELF:CHECKED.
END.

PROCEDURE DEFAULT-BTN_proc:
  _C._default-btn-recid = IF SELF:CHECKED THEN RECID(_U) ELSE ?.

  IF SELF:CHECKED THEN DO:
    IF _F._IMAGE-FILE NE "" AND _F._IMAGE-FILE NE ? THEN DO:
      MESSAGE "Default buttons may not have images."
             VIEW-AS ALERT-BOX WARNING BUTTONS OK-CANCEL UPDATE stupid.
      IF NOT stupid THEN DO:
        SELF:CHECKED = FALSE.
        RETURN NO-APPLY.
      END.
    END.

    ASSIGN _F._IMAGE-FILE = ""
           _F._IMAGE-DOWN-FILE = ""
           _F._IMAGE-INSENSITIVE-FILE = "".
    IF VALID-HANDLE(h_btn_UP) THEN  /* Won't be valid if tty window */
    ASSIGN h_btn_UP:SENSITIVE = FALSE
           h_fn_txt:SCREEN-VALUE = ""
           h_btn_down:SENSITIVE = FALSE
           h_fn_dwn_txt:SCREEN-VALUE = ""
           h_btn_insen:SENSITIVE = FALSE
           h_fn_ins_txt:SCREEN-VALUE = ""
           stupid = h_btn_up:LOAD-IMAGE("")
           stupid = h_btn_down:LOAD-IMAGE("")
           stupid = h_btn_insen:LOAD-IMAGE("").

  END.
  ELSE DO:
    IF VALID-HANDLE(h_btn_UP) THEN  /* Won't be valid if tty window */
    ASSIGN h_btn_UP:SENSITIVE = TRUE
           h_btn_down:SENSITIVE = TRUE
           h_btn_insen:SENSITIVE = TRUE.
  END.
END.

PROCEDURE DEFAULT-STYLE_proc:
  _F._DEFAULT = SELF:CHECKED.
END.

PROCEDURE DISABLE-AUTO-ZAP_proc:
  _F._DISABLE-AUTO-ZAP = SELF:CHECKED.
END.

PROCEDURE DISPLAY_proc:
  _U._DISPLAY = SELF:CHECKED.
END.

PROCEDURE DOWN_proc:
  _C._DOWN = SELF:CHECKED.
  IF _C._DOWN THEN
    ASSIGN _C._PAGE-BOTTOM       = FALSE
           _C._PAGE-TOP          = FALSE.
END.

PROCEDURE DRAG-ENABLED_proc:
  _F._DRAG-ENABLED = SELF:CHECKED.
END.

PROCEDURE Drop-Target_proc:
  _U._DROP-TARGET = SELF:CHECKED.
END.

PROCEDURE ENABLE_proc:
  _U._ENABLE = SELF:CHECKED.
END.

PROCEDURE EXPAND_proc:
  _F._EXPAND = SELF:CHECKED.
END.

PROCEDURE EXPLICIT-POSITION_proc:
  ASSIGN _C._EXPLICIT_POSITION = SELF:CHECKED
         h_col:SENSITIVE       = SELF:CHECKED
         h_col:SCREEN-VALUE    = IF SELF:CHECKED THEN
                                 STRING(_L._COL) ELSE "?"
         h_row:SENSITIVE       = SELF:CHECKED
         h_row:SCREEN-VALUE    = IF SELF:CHECKED THEN
                                 STRING(_L._ROW) ELSE "?".

END.

PROCEDURE FILLED_proc:
  {adeuib/syncloch.i &Master_L   = "_L"
                     &FLD1       = "FILLED"
                     &NEW-VALUE1 = "SELF:CHECKED"}
  _L._FILLED = SELF:CHECKED.
END.

PROCEDURE FIT-LAST-COLUMN_proc:
  _C._FIT-LAST-COLUMN = SELF:CHECKED.
  IF _C._FIT-LAST-COLUMN THEN
    ASSIGN _C._NO-EMPTY-SPACE = FALSE
           h_no-empty-space:CHECKED = FALSE.
END.

PROCEDURE FLAT_proc:
  _F._FLAT = SELF:CHECKED.
  /* FLAT button MUST be NO-FOCUS */
  IF SELF:CHECKED THEN DO:
    ASSIGN h_NO-FOCUS:CHECKED = TRUE.
    APPLY "VALUE-CHANGED" TO h_NO-FOCUS.
  END.
END.

PROCEDURE GRAPHIC-EDGE_proc:
  {adeuib/syncloch.i &Master_L   = "_L"
                     &FLD1       = "GRAPHIC-EDGE"
                     &NEW-VALUE1 = "SELF:CHECKED"}
  _L._GRAPHIC-EDGE = SELF:CHECKED.
  IF SELF:CHECKED AND 
    (_L._EDGE-PIXELS < 1 OR _L._EDGE-PIXELS > 7) THEN
    _L._EDGE-PIXELS = IF parent_L._3-D THEN 2 ELSE 1.
  IF NOT SELF:CHECKED THEN _L._EDGE-PIXELS = 8.
  IF VALID-HANDLE(h_EDGE-PIXELS) THEN /* Might be TTY alt-layout */
    h_EDGE-PIXELS:SCREEN-VALUE = STRING(_L._EDGE-PIXELS).
END.

PROCEDURE HIDDEN_proc:
  _U._HIDDEN = SELF:CHECKED.
END.

PROCEDURE HORIZONTAL_proc:
  _F._HORIZONTAL = SELF:CHECKED.
  IF h_self:TYPE = "RADIO-SET" THEN
    ASSIGN _F._EXPAND         = FALSE
           h_expand:CHECKED   = FALSE
           h_expand:SENSITIVE = SELF:CHECKED.
END.

PROCEDURE KEEP-FRAME-Z-ORDER_proc:
  _C._KEEP-FRAME-Z-ORDER = SELF:CHECKED.
END.

PROCEDURE KEEP-TAB-ORDER_proc:
  _C._KEEP-TAB-ORDER = SELF:CHECKED.
END.

PROCEDURE LARGE_proc:
  _F._LARGE = SELF:CHECKED.
END.

PROCEDURE LARGE-TO-SMALL_proc:
  _F._LARGE-TO-SMALL = SELF:CHECKED.
END.

PROCEDURE MAX-BUTTON_proc:
  _C._MAX-BUTTON = SELF:CHECKED.
  IF _C._MAX-BUTTON AND _C._CONTEXT-HELP THEN DO:
    ASSIGN h_context-help:CHECKED = FALSE.
    APPLY "VALUE-CHANGED":U TO h_context-help.
  END.  
END.

PROCEDURE MESSAGE-AREA_proc:
  _C._MESSAGE-AREA = SELF:CHECKED.
END.

PROCEDURE MIN-BUTTON_proc:
  _C._MIN-BUTTON = SELF:CHECKED.
  IF _C._MIN-BUTTON AND _C._CONTEXT-HELP THEN DO:
    ASSIGN h_context-help:CHECKED = FALSE.
    APPLY "VALUE-CHANGED":U TO h_context-help.
  END.  
END.

PROCEDURE MULTIPLE_proc:
  IF AVAILABLE _F THEN _F._MULTIPLE = SELF:CHECKED.
  ELSE _C._MULTIPLE = SELF:CHECKED.
END.

PROCEDURE NATIVE_proc:
  _F._NATIVE = SELF:CHECKED.
  IF SELF:CHECKED THEN ASSIGN h_VIEW-AS-TEXT:CHECKED = FALSE
                              _U._SUBTYPE = "":U.
END.

PROCEDURE NO-ASSIGN_proc:
  _C._NO-ASSIGN = SELF:CHECKED.
END.

PROCEDURE NO-AUTO-VALIDATE_proc:
  _C._NO-AUTO-VALIDATE = SELF:CHECKED.
END.

PROCEDURE NO-BOX_proc:
  {adeuib/syncloch.i &Master_L   = "_L"
                     &FLD1       = "NO-BOX"
                     &NEW-VALUE1 = "SELF:CHECKED"}
  _L._NO-BOX = SELF:CHECKED.
  IF SELF:CHECKED AND _U._TYPE NE "EDITOR" THEN
    ASSIGN _C._TITLE = FALSE
           h_title-bar:CHECKED = FALSE.
END.

PROCEDURE NO-CURRENT-VALUE_proc:
  _F._NO-CURRENT-VALUE = SELF:CHECKED.
END.

PROCEDURE NO-EMPTY-SPACE_proc:
_C._NO-EMPTY-SPACE = SELF:CHECKED.
  IF _C._NO-EMPTY-SPACE THEN
    ASSIGN _C._FIT-LAST-COLUMN = FALSE
           h_fit-last-column:CHECKED = FALSE.
END.

PROCEDURE NO-FOCUS_proc:
  {adeuib/syncloch.i &Master_L   = "_L"
                     &FLD1       = "NO-FOCUS"
                     &NEW-VALUE1 = "SELF:CHECKED"}
  _L._NO-FOCUS = SELF:CHECKED.
  /* If user turns off NO-FOCUS, FLAT turns off too */
  IF NOT SELF:CHECKED AND h_FLAT:CHECKED THEN
    ASSIGN
      h_FLAT:CHECKED = FALSE
      _F._FLAT       = FALSE.
END.

PROCEDURE NO-HELP_proc:
  _C._NO-HELP = SELF:CHECKED.
END.

PROCEDURE NO-HIDE_proc:
  _C._HIDE = NOT SELF:CHECKED.
END.

PROCEDURE NO-LABELS_proc:
  {adeuib/syncloch.i &Master_L   = "_L"
                     &FLD1       = "NO-LABELS"
                     &NEW-VALUE1 = "SELF:CHECKED"}
  _L._NO-LABELS = SELF:CHECKED.
END.

PROCEDURE NO-ROW-MARKERS_proc:
  _C._NO-ROW-MARKERS = SELF:CHECKED.
END.

PROCEDURE NO-TAB-STOP_proc:
  _U._NO-TAB-STOP = SELF:CHECKED.
END.

PROCEDURE NO-UNDERLINE_proc:
  {adeuib/syncloch.i &Master_L   = "_L"
                     &FLD1       = "NO-UNDERLINE"
                     &NEW-VALUE1 = "SELF:CHECKED"}
  _L._NO-UNDERLINE = SELF:CHECKED.
END.

PROCEDURE NO-UNDO_proc:
  _F._UNDO = NOT SELF:CHECKED.
END.

PROCEDURE NO-VALIDATE_proc:
  _C._VALIDATE = NOT SELF:CHECKED.
END.

PROCEDURE OPEN-QUERY_proc:
  _Q._OpenQury = SELF:CHECKED.
END.

PROCEDURE OVERLAY_proc:
  _C._OVERLAY = SELF:CHECKED.
END.

PROCEDURE PASSWORD-FIELD_proc:
  _F._PASSWORD-FIELD = SELF:CHECKED.
END.

PROCEDURE READ-ONLY_proc:
  _F._READ-ONLY = SELF:CHECKED.
END.

PROCEDURE REMOVE-FROM-LAYOUT_proc:
  _L._REMOVE-FROM-LAYOUT = SELF:CHECKED.
END.

PROCEDURE RESIZE_proc:
  _U._RESIZABLE = SELF:CHECKED.
END.

PROCEDURE RETAIN-SHAPE_proc:
  _F._RETAIN-SHAPE = SELF:CHECKED.
END.

PROCEDURE RETURN-INSERTED_proc:
  _F._RETURN-INSERTED = SELF:CHECKED.
END.

PROCEDURE SCROLL-BARS_proc:
  _C._SCROLL-BARS = SELF:CHECKED.
END.

PROCEDURE SCROLLABLE_proc:
  ASSIGN _C._SCROLLABLE     = SELF:CHECKED
         h_v-wdth:SENSITIVE = SELF:CHECKED
         h_v-hgt:SENSITIVE  = SELF:CHECKED.
  IF NOT SELF:CHECKED THEN
    ASSIGN _L._VIRTUAL-WIDTH    = _L._WIDTH
           _L._VIRTUAL-HEIGHT   = _L._HEIGHT
           h_v-wdth:SCREEN-VALUE = STRING(_L._VIRTUAL-WIDTH,">>9.99")
           h_v-hgt:SCREEN-VALUE  = STRING(_L._VIRTUAL-HEIGHT,">>9.99").
END.

PROCEDURE SCROLLBAR-H_proc:
  _F._SCROLLBAR-H = SELF:CHECKED.
  IF _U._TYPE = "EDITOR" THEN
    ASSIGN _F._WORD-WRAP         = NOT SELF:CHECKED
           h_WORD-WRAP:SENSITIVE = NOT SELF:CHECKED
           h_WORD-WRAP:CHECKED   = NOT SELF:CHECKED.
END.

PROCEDURE SCROLLBAR-V_proc:
  _U._SCROLLBAR-V = SELF:CHECKED.
END.

PROCEDURE SENSITIVE_proc:
  _U._SENSITIVE = SELF:CHECKED.
END.

PROCEDURE SEPARATORS_proc:
  {adeuib/syncloch.i &Master_L   = "_L"
                     &FLD1       = "SEPARATORS"
                     &NEW-VALUE1 = "SELF:CHECKED"}
  _L._SEPARATORS = SELF:CHECKED.
  IF NOT _L._SEPARATORS THEN
    ASSIGN _L._SEPARATOR-FGCOLOR = ?.
END.

PROCEDURE SHARED_proc:
  _U._SHARED = SELF:CHECKED.
  IF _U._SHARED AND
     NOT CAN-DO("BROWSE,FRAME",_U._TYPE) THEN DO:
    IF ((CAN-DO("CHARACTER,LONGCHAR",_F._DATA-TYPE) AND _F._INITIAL-DATA NE "") OR
       (CAN-DO("INTEGER,DECIMAL",_F._DATA-TYPE)
             AND DECIMAL(_F._INITIAL-DATA) NE 0) OR
       (_F._DATA-TYPE = "LOGICAL"
             AND NOT CAN-DO("NO,FALSE",_F._INITIAL-DATA)) OR 
       (CAN-DO("DATE,DATETIME,DATETIME-TZ,RECID",_F._DATA-TYPE) AND _F._INITIAL-DATA NE "?"))
      THEN MESSAGE
        "Shared variables will not retain initial values in the UIB."
         VIEW-AS ALERT-BOX WARNING BUTTONS OK.
  END.
  ELSE IF _U._SHARED AND
    CAN-DO("BROWSE,FRAME",_U._TYPE) THEN DO:
    FIND x_U WHERE x_U._HANDLE = _U._WINDOW-HANDLE.
    FIND x_P WHERE x_P._u-recid = RECID(x_U).
    x_P._RUN-PERSISTENT = FALSE.
  END.
END.

PROCEDURE SHOW-IN-TASKBAR_proc:
  _C._SHOW-IN-TASKBAR = SELF:CHECKED.

END.

PROCEDURE SHOW-POPUP_proc:
  _U._SHOW-POPUP = IF AVAILABLE _F AND CAN-DO("DATE,DECIMAL,INTEGER":u, _F._DATA-TYPE) AND isDynView 
      THEN SELF:CHECKED
      ELSE FALSE.
END.

PROCEDURE SIDE-LABELS_proc:
  _C._SIDE-LABELS = SELF:CHECKED.
END.

PROCEDURE SIZE-TO-FIT_proc:
  _C._size-to-fit = SELF:CHECKED.
END.

PROCEDURE SMALL-TITLE_proc:
  _C._SMALL-TITLE = SELF:CHECKED.
  IF _U._TYPE = "WINDOW":U THEN 
    RUN set_window_controls. 

END.

PROCEDURE SORT_proc:
  _F._SORT = SELF:CHECKED.
END.

PROCEDURE STATUS-AREA_proc:
  _C._STATUS-AREA = SELF:CHECKED.
END.

PROCEDURE STRETCH-TO-FIT_proc:
  _F._STRETCH-TO-FIT = SELF:CHECKED.
  IF NOT _F._STRETCH-TO-FIT THEN
    ASSIGN
      _F._RETAIN-SHAPE         = FALSE
      h_retain-shape:CHECKED   = FALSE
      h_retain-shape:SENSITIVE = FALSE.
  ELSE h_retain-shape:SENSITIVE = TRUE.
END.

PROCEDURE SUPPRESS-WINDOW_proc:
  _C._SUPPRESS-WINDOW = SELF:CHECKED.
END.

PROCEDURE TITLE-BAR_proc:
  _C._TITLE = SELF:CHECKED.
  IF _C._TITLE THEN
    ASSIGN _L._NO-BOX = FALSE
           h_no-box:CHECKED = FALSE.
END.

PROCEDURE TRANSPARENT_proc:
  _F._TRANSPARENT = SELF:CHECKED.
  IF SELF:CHECKED AND h_convert-3d-colors:CHECKED THEN
    ASSIGN _L._CONVERT-3D-COLORS         = FALSE
           h_convert-3d-colors:CHECKED   = FALSE.

END.

PROCEDURE UNIQUE-MATCH_proc:
  _F._UNIQUE-MATCH = SELF:CHECKED.

END.

PROCEDURE USE-DICT-EXPS_proc:
  _C._USE-DICT-EXPS = SELF:CHECKED.
END.

PROCEDURE VIEW_proc:
  _U._DISPLAY = SELF:CHECKED.
END.

PROCEDURE VIEW-AS-TEXT_proc:
  _U._SUBTYPE = (IF SELF:CHECKED THEN "TEXT":U ELSE "").
  IF SELF:CHECKED THEN
    ASSIGN h_NATIVE:CHECKED = FALSE
           _F._NATIVE       = FALSE
           _L._HEIGHT       =
            IF _L._FONT = ? THEN
            FONT-TABLE:GET-TEXT-HEIGHT-CHARS()
            ELSE
            FONT-TABLE:GET-TEXT-HEIGHT-CHARS(_L._FONT)
            h_hgt:SCREEN-VALUE = STRING(_L._HEIGHT,">>9.99").
   ELSE
     ASSIGN _L._HEIGHT        = 1
            h_hgt:SCREEN-VALUE = STRING(_L._HEIGHT,">>9.99").

END.

PROCEDURE VISIBLE_proc:
  _U._DISPLAY = SELF:CHECKED.
END.

PROCEDURE WORD-WRAP_proc:
  _F._WORD-WRAP = SELF:CHECKED.
END.

