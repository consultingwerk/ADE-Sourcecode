1 "3-D" yes 1 "L" "3-D!_L._3-D" yes yes no yes no no no no no no no no no no no no no no yes "Three-Dimensional" 240 ? "  {adeuib/syncloch.i &Master_L   = ""_L""
                     &FLD1       = ""3-D""
                     &NEW-VALUE1 = ""SELF:CHECKED""}
  _L._3-D = SELF:CHECKED." no ""
2 "BGCOLOR" yes ? "I" "Background Color!_U._BGCOLOR" yes yes yes yes yes yes yes yes yes yes yes yes yes yes yes no yes no no "Background Color" 895 ? "" yes "_L._BGCOLOR = iValue."
3 "COL-MULT" yes ? "D" "" no no no no no no no no no no no no no no no no no no no "Internal fugde" 890 ? "" no ""
4 "COLUMN" yes 2 "D" "Column!_U._COL" yes yes yes yes yes yes yes yes yes yes yes yes yes yes yes no yes no yes "COLUMN" 195 ? "" no ""
5 "CONVERT-3D-COLORS" yes 1 "L" "Convert-3D-Colors!_L._CONVERT-3D-COLORS" no no no no yes no no no yes no no no no no no no no no no "" 300 ? "  {adeuib/syncloch.i &Master_L   = ""_L""
                     &FLD1       = ""CONVERT-3D-COLORS""
                     &NEW-VALUE1 = ""SELF:CHECKED""}
  _L._CONVERT-3D-COLORS = SELF:CHECKED.
  IF VALID-HANDLE(h_transparent) THEN
  DO:
    IF SELF:CHECKED AND h_transparent:CHECKED THEN
      ASSIGN _F._TRANSPARENT       = FALSE
           h_transparent:CHECKED = FALSE.
  END.  /* if transparent valid */" yes "_L._CONVERT-3D-COLORS = lValue."
6 "CUSTOM-POSITION" yes 2 "L" "Custom Position" no no no no no no no no no no no no no no no no no no no "Internal Fudge" 920 ? "" no ""
7 "CUSTOM-SIZE" yes 2 "L" "Custom Size" no no no no no no no no no no no no no no no no no no no "Internal Fudge" 925 ? "" no ""
8 "EDGE-PIXELS" yes 2 "I" "Edge-Pixels!_F._EDGE-PIXELS" no no no no no no no no no no yes no no no no no no no no "Rect" 45 ? "" yes "_L._EDGE-PIXELS = iValue."
9 "FGCOLOR" yes ? "I" "Foreground Color!_U._FGCOLOR" yes yes yes yes yes yes yes yes yes yes yes yes yes yes yes no yes no no "Foreground" 885 ? "" yes "_L._FGCOLOR = iValue."
10 "FILLED" yes 1 "L" "Filled!_L._FILLED" no no no no no no no no no no yes no no no no no no no no "Rect" 365 ? "  {adeuib/syncloch.i &Master_L   = ""_L""
                     &FLD1       = ""FILLED""
                     &NEW-VALUE1 = ""SELF:CHECKED""}
  _L._FILLED = SELF:CHECKED." yes "_L._FILLED = lValue."
11 "FONT" yes 5 "I" "Font!_U._FONT" yes yes yes yes yes yes yes yes no yes no yes yes yes yes no no no no "" 165 ? "" yes "_L._FONT = iValue."
12 "GRAPHIC-EDGE" yes 1 "L" "Graphic-Edge!_L._GRAPHIC-EDGE" no no no no no no no no no no yes no no no no no no no no "Rect" 370 ? "  {adeuib/syncloch.i &Master_L   = ""_L""
                     &FLD1       = ""GRAPHIC-EDGE""
                     &NEW-VALUE1 = ""SELF:CHECKED""}
  _L._GRAPHIC-EDGE = SELF:CHECKED.
  IF SELF:CHECKED AND 
    (_L._EDGE-PIXELS < 1 OR _L._EDGE-PIXELS > 7) THEN
    _L._EDGE-PIXELS = IF parent_L._3-D THEN 2 ELSE 1.
  IF NOT SELF:CHECKED THEN _L._EDGE-PIXELS = 8.
  IF VALID-HANDLE(h_EDGE-PIXELS) THEN /* Might be TTY alt-layout */
    h_EDGE-PIXELS:SCREEN-VALUE = STRING(_L._EDGE-PIXELS)." yes "_L._GRAPHIC-EDGE = lValue."
13 "GROUP-BOX" yes 1 "L" "Group-Box!_L._GROUP-BOX" no no no no no no no no no no yes no no no no no no no no "Rectangle group box" 375 ? "  {adeuib/syncloch.i &Master_L   = ""_L""
                     &FLD1       = ""GROUP-BOX""
                     &NEW-VALUE1 = ""SELF:CHECKED""}
  _L._GROUP-BOX = SELF:CHECKED." yes "_L._GROUP-BOX = lValue."
14 "HEIGHT" yes 2 "D" "Height-Characters!_U._HEIGHT" yes yes yes yes yes yes yes yes yes yes yes yes yes yes yes no yes no yes "" 210 ? "" yes "_L._HEIGHT = dValue.
"
15 "NO-BOX" yes 1 "L" "No-Box!_L._NO-BOX" no yes yes no no no yes no no no no no no no no no no no no "(NO-BOX)" 450 ? "  {adeuib/syncloch.i &Master_L   = ""_L""
                     &FLD1       = ""NO-BOX""
                     &NEW-VALUE1 = ""SELF:CHECKED""}
  _L._NO-BOX = SELF:CHECKED.
  IF SELF:CHECKED AND _U._TYPE NE ""EDITOR"" THEN
    ASSIGN _C._TITLE = FALSE
           h_title-bar:CHECKED = FALSE." yes "
  DO:
    _L._NO-BOX = lValue.
    IF _L._NO-BOX THEN IF AVAILABLE (_C) THEN _C._TITLE = NO.
  END."
16 "NO-FOCUS" yes 1 "L" "No-Focus!_L._NO-FOCUS" no no no no yes no no no no no no no no no no no no no no "" 460 ? "  {adeuib/syncloch.i &Master_L   = ""_L""
                     &FLD1       = ""NO-FOCUS""
                     &NEW-VALUE1 = ""SELF:CHECKED""}
  _L._NO-FOCUS = SELF:CHECKED.
  /* If user turns off NO-FOCUS, FLAT turns off too */
  IF NOT SELF:CHECKED AND h_FLAT:CHECKED THEN
    ASSIGN
      h_FLAT:CHECKED = FALSE
      _F._FLAT       = FALSE." yes "_L._NO-FOCUS = lValue."
17 "NO-LABELS" yes 1 "L" "No-Labels!_L._NO-LABELS" no yes yes yes no no no no no no no no no no no no no no no "NO-LABELS plural" 475 ? "  {adeuib/syncloch.i &Master_L   = ""_L""
                     &FLD1       = ""NO-LABELS""
                     &NEW-VALUE1 = ""SELF:CHECKED""}
  _L._NO-LABELS = SELF:CHECKED." yes "_L._NO-LABELS = lValue."
18 "NO-UNDERLINE" yes 1 "L" "No-Underline!_L._NO-UNDERLINE" no yes no no no no no no no no no no no no no no no no no "Frame" 490 ? "  {adeuib/syncloch.i &Master_L   = ""_L""
                     &FLD1       = ""NO-UNDERLINE""
                     &NEW-VALUE1 = ""SELF:CHECKED""}
  _L._NO-UNDERLINE = SELF:CHECKED." yes "_L._NO-UNDERLINE = lValue."
19 "REMOVE-FROM-LAYOUT" yes 1 "L" "Remove from Layout!_L._REMOVE-FROM-LAYOUT" no yes yes no yes yes yes yes yes yes yes yes yes no yes no yes no no "Psuedo Attr for Multi-lay" 525 ? "  _L._REMOVE-FROM-LAYOUT = SELF:CHECKED." no ""
20 "ROUNDED" yes 1 "L" "Rounded!_L._ROUNDED" no no no no no no no no no no yes no no no no no no no no "Rectangle rounded" 530 ? "  {adeuib/syncloch.i &Master_L   = ""_L""
                     &FLD1       = ""ROUNDED""
                     &NEW-VALUE1 = ""SELF:CHECKED""}
  _L._ROUNDED = SELF:CHECKED." yes "_L._ROUNDED = lValue."
21 "ROW" yes 2 "D" "Row!_U._ROW" yes yes yes yes yes yes yes yes yes yes yes yes yes yes yes no yes no yes "" 200 ? "" no ""
22 "ROW-MULT" yes ? "D" "" no no no no no no no no no no no no no no no no no no no "Internal Fudge" 875 ? "" no ""
23 "SEPARATOR-FGCOLOR" yes ? "I" "Separator FGColor!_U._SEPARATOR-FGCOLOR" no no yes no no no no no no no no no no no no no no no no "Separator Foreground Colo" 900 ? "" yes "_L._SEPARATOR-FGCOLOR = iValue."
24 "SEPARATORS" yes 1 "L" "Separators!_L._SEPARATORS" no no yes no no no no no no no no no no no no no no no no "Browse" 590 ? "  {adeuib/syncloch.i &Master_L   = ""_L""
                     &FLD1       = ""SEPARATORS""
                     &NEW-VALUE1 = ""SELF:CHECKED""}
  _L._SEPARATORS = SELF:CHECKED.
  IF NOT _L._SEPARATORS THEN
    ASSIGN _L._SEPARATOR-FGCOLOR = ?." yes "_L._SEPARATORS = lValue."
25 "TITLE-BGCOLOR" yes ? "I" "Title Background Color!_C._TITLE-BGCOLOR" no yes no no no no no no no no no no no no no no no no no "" 865 ? "" yes "_L._TITLE-BGCOLOR = iValue."
26 "TITLE-FGCOLOR" yes ? "I" "Title Foreground Color!_C._TITLE-FGCOLOR" no yes no no no no no no no no no no no no no no no no no "" 870 ? "" yes "_L._TITLE-FGCOLOR = iValue."
27 "VIRTUAL-HEIGHT" yes 2 "D" "Virtual-Height!_C._VIRTUAL-HEIGHT" yes yes no no no no no no no no no no no no no no no no yes "" 225 ? "" yes "_L._VIRTUAL-HEIGHT = dValue."
28 "VIRTUAL-WIDTH" yes 2 "D" "Virtual-Width!_C._VIRTUAL-WIDTH" yes yes no no no no no no no no no no no no no no no no yes "" 220 ? "" yes "_L._VIRTUAL-WIDTH = dValue."
29 "WIDTH" yes 2 "D" "Width!_U._WIDTH" yes yes yes yes yes yes yes yes yes yes yes yes yes yes yes no yes no yes "" 205 ? "" yes "_L._WIDTH = dValue."
30 "WIN-TYPE" yes ? "L" "" yes no no yes no no no no no no no no no no no no no yes no "Windows & dials" 840 ? "" no ""
31 "ALIGN" no 4 "C" "" no no yes no yes yes yes yes yes yes yes yes yes yes yes no no no yes "Widget can align" 230 ? "" no ""
32 "Always-On-Top" no 9 "L" "Always-On-Top!_C._ALWAYS-ON-TOP" yes no no no no no no no no no no no no no no no no yes no "" 770 ? "            _C._ALWAYS-ON-TOP = SELF:CHECKED.
            IF _C._ALWAYS-ON-TOP THEN 
              ASSIGN
                _C._TOP-ONLY       = FALSE
                h_top-only:CHECKED = FALSE." yes "_C._ALWAYS-ON-TOP = lValue."
33 "AUTO-COMPLETION" no 1 "L" "Auto-Completion!_F._AUTO-COMPLETION" no no no no no yes no no no no no no no no no no no no no "" 255 ? "  _F._AUTO-COMPLETION = SELF:CHECKED.
  IF SELF:CHECKED THEN
    ASSIGN h_UNIQUE-MATCH:SENSITIVE = TRUE.
  ELSE DO:
    ASSIGN h_UNIQUE-MATCH:SENSITIVE = FALSE
           h_UNIQUE-MATCH:CHECKED   = FALSE.
    APPLY ""VALUE-CHANGED"":U TO h_UNIQUE-MATCH.
  END.  /* else do - not checked */" yes "_F._AUTO-COMPLETION = lValue."
34 "AUTO-END-KEY" no 1 "L" "Auto-End-Key!_F._AUTO-ENDKEY" no no no no yes no no no no no no no no no no no no no no "" 260 ? "  _F._AUTO-ENDKEY = SELF:CHECKED.
  IF SELF:CHECKED THEN
    ASSIGN _F._AUTO-GO       = FALSE
           h_AUTO-GO:CHECKED = FALSE." yes "_F._AUTO-ENDKEY = lValue."
35 "AUTO-GO" no 1 "L" "Auto-Go!_F._AUTO-GO" no no no no yes no no no no no no no no no no no no no no "" 265 ? "  _F._AUTO-GO = SELF:CHECKED.
  IF SELF:CHECKED THEN
    ASSIGN _F._AUTO-ENDKEY        = FALSE
           h_AUTO-END-KEY:CHECKED = FALSE." yes "_F._AUTO-GO = lValue."
36 "AUTO-INDENT" no 1 "L" "Auto-Indent!_F._AUTO-INDENT" no no no no no no yes no no no no no no no no no no no no "" 270 ? "  _F._AUTO-INDENT = SELF:CHECKED." yes "_F._AUTO-INDENT = lValue."
37 "AUTO-RESIZE" no 1 "L" "Auto-Resize!_F._AUTO-RESIZE" no no no no yes no yes yes no no no yes yes no yes no no no no "Sizes according to text" 275 ? "  _F._AUTO-RESIZE = SELF:CHECKED." yes "_F._AUTO-RESIZE = lValue."
38 "AUTO-RETURN" no 1 "L" "Auto-Return!_F._AUTO-RETURN" no no no no no no no yes no no no no no no no no no no no "" 280 ? "  _F._AUTO-RETURN = SELF:CHECKED." yes "_F._AUTO-RETURN = lValue."
39 "BLANK" no 1 "L" "Blank!_F._BLANK" no no no no no no no yes no no no no no no no no no no no "" 285 ? "  _F._BLANK = SELF:CHECKED." yes "_F._BLANK = lValue."
40 "BOX-SELECTABLE" no 9 "L" "Box-Selectable!_C._BOX-SELECTABLE" no yes no yes no no no no no no no no no no no no no no no "" 715 ? "            _C._BOX-SELECTABLE = SELF:CHECKED." yes "_C._BOX-SELECTABLE = lValue."
41 "CANCEL-BTN" no 1 "L" "Cancel Button!(_C._cancel-btn-recid = RECID(_U))" no no no no yes no no no no no no no no no no no no no no "Is this btn the cancel bt" 290 ? "  _C._cancel-btn-recid = IF SELF:CHECKED THEN RECID(_U) ELSE ?." yes "parent_C._cancel-btn-recid = RECID(_U)."
42 "COLOR" no 5 "I" "" yes yes yes yes yes yes yes yes yes yes yes yes yes yes yes no yes no no "Psuedo Att for BGC & FGC" 160 ? "" no ""
43 "COLUMN-MOVABLE" no 9 "L" "Column Movable!_C._COLUMN-MOVABLE" no no yes no no no no no no no no no no no no no no no no "" 720 ? "            _C._COLUMN-MOVABLE = SELF:CHECKED." yes "_C._COLUMN-MOVABLE = lValue."
44 "COLUMN-RESIZABLE" no 9 "L" "Column Resizable!_C._COLUMN-RESIZABLE" no no yes no no no no no no no no no no no no no no no no "" 725 ? "            _C._COLUMN-RESIZABLE = SELF:CHECKED." yes "_C._COLUMN-RESIZABLE = lValue."
45 "COLUMN-SCROLLING" no 1 "L" "Column-Scrolling!_C._COLUMN-SCROLLING" no no yes no no no no no no no no no no no no no no no no "No-Column-Scroll" 295 ? "  _C._COLUMN-SCROLLING = SELF:CHECKED." yes "_C._COLUMN-SCROLLING = lValue."
46 "COLUMN-SEARCHING" no 9 "L" "Column Searching!_C._COLUMN-SEARCHING" no no yes no no no no no no no no no no no no no no no no "" 730 ? "            _C._COLUMN-SEARCHING = SELF:CHECKED." yes "_C._COLUMN-SEARCHING = lValue."
47 "CONTEXT-HELP" no 2 "L" "Context-Help!_C._CONTEXT-HELP" yes no no yes no no no no no no no no no no no no no no no "" 150 ? "" yes "_C._CONTEXT-HELP = lValue."
48 "CONTEXT-HELP-FILE" no 2 "C" "Context-Help-File!_C._CONTEXT-HELP-FILE" yes no no yes no no no no no no no no no no no no no no no "" 155 ? "" yes "_C._CONTEXT-HELP-FILE = cValue."
49 "CONTEXT-HELP-ID" no 2 "I" "Context-Help-ID!_U._CONTEXT-HELP-ID" no no yes no yes yes yes yes no yes no yes yes no yes no yes no no "Context-Help-OD" 120 ? "" yes "_U._CONTEXT-HELP-ID = iValue."
50 "Control-Box" no 1 "L" "Control-Box!_C._CONTROL-BOX" yes no no no no no no no no no no no no no no no no no no "" 245 ? "  _C._CONTROL-BOX = SELF:CHECKED.
  IF _U._TYPE = ""WINDOW"":U THEN 
    RUN set_window_controls. 
" yes "_C._CONTROL-BOX = lValue."
51 "CUSTOM-SUPER-PROC" no 2 "C" "CUSTOM-SUPER-PROC!_C._CUSTOM-SUPER-PROC" no yes yes no no no no no no no no no no no no no no no no "custom super procedure" 135 "" "" yes "_C._CUSTOM-SUPER-PROC = cValue."
52 "DATA-TYPE" no 3 "C" "" no no no no no yes yes yes no yes no no no no no no no no no "" 30 ? "" yes "
  DO: 
    IF CAN-DO(""Character,LongChar,Date,DateTime,DateTime-Tz,Decimal,Logical,Integer"":U, cValue) 
    THEN _F._DATA-TYPE = cValue.
    ELSE err_text = ""DATA-TYPE must be Character, LongChar, Date, Decimal, Logical, or Integer."".
  END."
53 "DB-FIELD" no 5 "L" "" no no no no no yes yes yes no yes no yes yes no yes no no no no "" 180 ? "" no ""
54 "DEBLANK" no 1 "L" "Deblank!_F._DEBLANK" no no no no no no no yes no no no no no no no no no no no "" 305 ? "  _F._DEBLANK = SELF:CHECKED." yes "_F._DEBLANK = lValue."
55 "DEFAULT-BTN" no 1 "L" "Default Button!(_C._default-btn-recid = RECID(_U))" no no no no yes no no no no no no no no no no no no no no "Is this btn the deflt btn" 310 ? "  _C._default-btn-recid = IF SELF:CHECKED THEN RECID(_U) ELSE ?.

  IF SELF:CHECKED THEN DO:
    IF _F._IMAGE-FILE NE """" AND _F._IMAGE-FILE NE ? THEN DO:
      MESSAGE ""Default buttons may not have images.""
             VIEW-AS ALERT-BOX WARNING BUTTONS OK-CANCEL UPDATE stupid.
      IF NOT stupid THEN DO:
        SELF:CHECKED = FALSE.
        RETURN NO-APPLY.
      END.
    END.

    ASSIGN _F._IMAGE-FILE = """"
           _F._IMAGE-DOWN-FILE = """"
           _F._IMAGE-INSENSITIVE-FILE = """".
    IF VALID-HANDLE(h_btn_UP) THEN  /* Won't be valid if tty window */
    ASSIGN h_btn_UP:SENSITIVE = FALSE
           h_fn_txt:SCREEN-VALUE = """"
           h_btn_down:SENSITIVE = FALSE
           h_fn_dwn_txt:SCREEN-VALUE = """"
           h_btn_insen:SENSITIVE = FALSE
           h_fn_ins_txt:SCREEN-VALUE = """"
           stupid = h_btn_up:LOAD-IMAGE("""")
           stupid = h_btn_down:LOAD-IMAGE("""")
           stupid = h_btn_insen:LOAD-IMAGE("""").

  END.
  ELSE DO:
    IF VALID-HANDLE(h_btn_UP) THEN  /* Won't be valid if tty window */
    ASSIGN h_btn_UP:SENSITIVE = TRUE
           h_btn_down:SENSITIVE = TRUE
           h_btn_insen:SENSITIVE = TRUE.
  END." yes "
  DO:
     IF lValue THEN parent_C._default-btn-recid = RECID(_U).
  END."
56 "DEFAULT-STYLE" no 1 "L" "Default Style!_F._DEFAULT" no no no no yes no no no no no no no no no no no no no no "" 315 ? "  _F._DEFAULT = SELF:CHECKED." yes "_F._DEFAULT = lValue."
57 "DELIMITER" no 2 "C" "DELIMITER!_F._DELIMITER" no no no no no yes no no no yes no yes no no no no no no no "Character List Delimiter" 140 "" "" yes "_F._DELIMITER = cValue."
58 "DISABLE-AUTO-ZAP" no 1 "L" "Disable-Auto-Zap!_F._DISABLE-AUTO-ZAP" no no no no no no no yes no no no no no no no no no no no "" 320 ? "  _F._DISABLE-AUTO-ZAP = SELF:CHECKED." yes "_F._DISABLE-AUTO-ZAP = lValue."
59 "DISPLAY" no 1 "L" "Display!_U._DISPLAY" no no no no no yes yes yes no yes no yes yes no yes no no no no "True is mv data to Scrn" 325 ? "  _U._DISPLAY = SELF:CHECKED." yes "_U._DISPLAY = lValue."
60 "DOWN" no 1 "L" "Down!_C._DOWN" no yes no no no no no no no no no no no no no no no no no "True if frame is a dwn fr" 330 ? "  _C._DOWN = SELF:CHECKED.
  IF _C._DOWN THEN
    ASSIGN _C._PAGE-BOTTOM       = FALSE
           _C._PAGE-TOP          = FALSE." yes "_C._DOWN = lValue."
61 "DRAG-ENABLED" no 1 "L" "Drag-Enabled!_F._DRAG-ENABLED" no no no no no no no no no no no yes no no no no no no no "" 335 ? "  _F._DRAG-ENABLED = SELF:CHECKED." yes "_F._DRAG-ENABLED = lValue."
62 "Drop-Target" no 1 "L" "Drop-Target!_U._DROP-TARGET" yes yes yes yes yes yes yes yes no yes no yes yes no yes no no no no "" 250 ? "  _U._DROP-TARGET = SELF:CHECKED." yes "_U._DROP-TARGET = lValue."
63 "ENABLE" no 1 "L" "Enable!_U._ENABLE" no no yes no yes yes yes yes yes yes yes yes yes no yes no no no no "For ENABLE_UI" 340 ? "  _U._ENABLE = SELF:CHECKED." yes "_U._ENABLE = lValue."
64 "EXPAND" no 1 "L" "Expand!_F._EXPAND" no no no no no no no no no yes no no no no no no no no no "" 355 ? "  _F._EXPAND = SELF:CHECKED." yes "_F._EXPAND = lValue."
65 "EXPLICIT-POSITION" no 1 "L" "Explicit Position!_C._EXPLICIT_POSITION" yes no no yes no no no no no no no no no no no no no no yes "Dialogs" 360 ? "  ASSIGN _C._EXPLICIT_POSITION = SELF:CHECKED
         h_col:SENSITIVE       = SELF:CHECKED
         h_col:SCREEN-VALUE    = IF SELF:CHECKED THEN
                                 STRING(_L._COL) ELSE ""?""
         h_row:SENSITIVE       = SELF:CHECKED
         h_row:SCREEN-VALUE    = IF SELF:CHECKED THEN
                                 STRING(_L._ROW) ELSE ""?"".
" no "_C._EXPLICIT_POSITION = lValue."
66 "FIT-LAST-COLUMN" no 1 "L" "Fit-Last-Column!_C._FIT-LAST-COLUMN" no no yes no no no no no no no no no no no no no no no no "Fit last col to browse" 345 "" "  _C._FIT-LAST-COLUMN = SELF:CHECKED.
  IF _C._FIT-LAST-COLUMN THEN
    ASSIGN _C._NO-EMPTY-SPACE = FALSE
           h_no-empty-space:CHECKED = FALSE." yes "
  DO:
   _C._FIT-LAST-COLUMN = lvalue.      
   IF _C._FIT-LAST-COLUMN  THEN _C._NO-EMPTY-SPACE= FALSE.
  END."
67 "FLAT" no 1 "L" "Flat!_F._FLAT" no no no no yes no no no no no no no no no no no no no no "" 350 ? "  _F._FLAT = SELF:CHECKED.
  /* FLAT button MUST be NO-FOCUS */
  IF SELF:CHECKED THEN DO:
    ASSIGN h_NO-FOCUS:CHECKED = TRUE.
    APPLY ""VALUE-CHANGED"" TO h_NO-FOCUS.
  END." yes "_F._FLAT = lValue."
68 "FOLDER-WIN-TO-LAUNCH" no 2 "C" "FOLDER-WINDOW-TO-LAUNCH!_C._FOLDER-WINDOW-TO-LAUNCH" no no yes no no no no no no no no no no no no no no no no "Folder window to launch" 125 "" "" yes " _C._FOLDER-WINDOW-TO-LAUNCH = cValue."
69 "FORMAT" no 2 "C" "Format!_F._FORMAT" no no no no no yes no yes no no no no no no no no no no no "" 35 ? "" yes "_F._FORMAT = cValue."
70 "FORMAT-ATTR" no ? "C" "" no no no no no no no no no no no no no no no no no no no "" 835 ? "" no ""
71 "FORMAT-SOURCE" no ? "L" "Explicit Format/Default Format" no no no no no yes no yes no no no no no no no no no no no "Local/Dict" 845 ? "" no ""
72 "FRAME-NAME" no ? "L" "&FRAME-NAME!(_P._frame-name-recid = RECID(_U))" no yes no no no no no no no no no no no no no no no yes no "Sets &FRAME-NAME" 790 ? "           _P._frame-name-recid = IF SELF:CHECKED THEN RECID(_U) ELSE ?." no "_P._frame-name-recid = RECID(_U)."
73 "FREQUENCY" no 2 "I" "Freq!_F._FREQUENCY" no no no no no no no no no no no no yes no no no no no no "" 80 ? "" yes "_F._FREQUENCY = iValue."
74 "HEIGHT-P" no 2 "I" "Height Pixels" yes yes yes yes yes yes yes yes yes yes yes yes yes yes yes no yes yes yes "" 905 ? "" yes "_L._HEIGHT = DECIMAL(iValue / SESSION:PIXELS-PER-ROW /
                    _L._ROW-MULT)."
75 "HELP" no 2 "C" "Help!_U._HELP" no no yes no yes yes yes yes no yes no yes yes no yes no yes yes no "" 650 ? "" yes "_U._HELP = cValue."
76 "HELP-ATTR" no ? "C" "" no no no no no no no no no no no no no no no no no no no "" 810 ? "" no ""
77 "HELP-SOURCE" no ? "L" "Explicit Help/Default Help" no no no no no yes yes yes no yes no yes yes no yes no no no no "Local/Dict" 805 ? "" no ""
78 "HIDDEN" no 1 "L" "Hidden!_U._HIDDEN" yes yes yes yes yes yes yes yes yes yes yes yes yes no yes no yes no yes "" 380 ? "  _U._HIDDEN = SELF:CHECKED." yes "_U._HIDDEN = lValue."
79 "HORIZONTAL" no 1 "L" "Horizontal!_F._HORIZONTAL" no no no no no no no no no yes no no yes no no no no no no "" 385 ? "  _F._HORIZONTAL = SELF:CHECKED.
  IF h_self:TYPE = ""RADIO-SET"" THEN
    ASSIGN _F._EXPAND         = FALSE
           h_expand:CHECKED   = FALSE
           h_expand:SENSITIVE = SELF:CHECKED." yes "_F._HORIZONTAL = lValue."
80 "ICON" no 6 "C" "" yes no no no no no no no no no no no no no no no no no no "" 85 ? "" no ""
81 "IMAGE-DOWN" no 6 "C" "Image-Down!_F._IMAGE-DOWN-FILE" no no no no yes no no no no no no no no no no no no no no "" 100 ? "" yes "_F._IMAGE-DOWN-FILE = cValue."
82 "IMAGE-FILE" no 6 "C" "Image-File!_F._IMAGE-FILE" no no no no yes no no no yes no no no no no no no no no no "" 95 ? "" yes "_F._IMAGE-FILE = cValue."
83 "IMAGE-INSENSITIVE" no 6 "C" "Image-Insensitive!_F._IMAGE-INSENSITIVE-FILE" no no no no yes no no no no no no no no no no no no no no "" 105 ? "" yes "_F._IMAGE-INSENSITIVE-FILE = cValue."
84 "INITIAL-VALUE" no 2 "C" "Initial-Value!_F._INITIAL-DATA" no no no no no yes yes yes no yes no yes yes no yes no no yes no "" 680 ? "" yes "_F._INITIAL-DATA = cValue."
85 "INNER-LINES" no 2 "I" "Inner-Lines!_F._INNER-LINES" no no no no no yes no no no no no no no no no no no no yes "" 25 ? "" yes "_F._INNER-LINES = iValue."
86 "KEEP-FRAME-Z-ORDER" no 1 "L" "Keep-Frame-Z-Order!_C._KEEP-FRAME-Z-ORDER" yes no no no no no no no no no no no no no no no no no no "" 390 ? "  _C._KEEP-FRAME-Z-ORDER = SELF:CHECKED." no "_C._KEEP-FRAME-Z-ORDER = lValue."
87 "KEEP-TAB-ORDER" no 1 "L" "Keep-Tab-Order!_C._KEEP-TAB-ORDER" no yes no yes no no no no no no no no no no no no no no no "" 400 ? "  _C._KEEP-TAB-ORDER = SELF:CHECKED." yes "_C._KEEP-TAB-ORDER = lValue."
88 "LABEL" no 2 "C" "Label!_U._LABEL" yes yes yes yes yes yes no yes no no no no no no yes no no no no "Label/Title" 10 ? "" yes "_U._LABEL = cValue."
89 "LABEL-ATTR" no ? "C" "" no no no no no no no no no no no no no no no no no no no "" 795 ? "" no ""
90 "LABEL-SOURCE" no ? "L" "Explicit Label/Default Label" no no no no no yes no yes no no no no no no yes no no no no "Local/DICT" 800 ? "" no ""
91 "LARGE" no 1 "L" "Large!_F._LARGE" no no no no no no yes no no no no no no no no no no no no "" 405 ? "  _F._LARGE = SELF:CHECKED." yes "_F._LARGE = lValue."
92 "LARGE-TO-SMALL" no 1 "L" "Large-To-Small!_F._LARGE-TO-SMALL" no no no no no no no no no no no no yes no no no no no no "" 410 ? "  _F._LARGE-TO-SMALL = SELF:CHECKED." yes "_F._LARGE-TO-SMALL = lValue."
93 "LAYOUT-UNIT" no 4 "L" "Characters/Pixels" yes yes yes yes yes yes yes yes yes yes yes yes yes yes yes no yes yes yes "PPU/PIXELS" 785 ? "" yes "
  DO: 
    IF CAN-DO(""C,Char,Character,P,Pixel"", cValue) 
    THEN _U._LAYOUT-UNIT = (SUBSTRING(cValue,1,1) eq ""C"":U).
    ELSE err_text = ""LAYOUT-UNIT must be C, Char, Character, P, or Pixel"".
  END."
94 "LIST-ITEMS" no 8 "C" "List-Items!_F._LIST-ITEMS" no no no no no yes no no no yes no yes no no no no no no no "Combos, radios and select" 20 ? "" yes "
  DO:
    /* For Combo-boxes and Selection-lists, we want a CHR(10) delimited list */
    IF CAN-DO(""COMBO-BOX,SELECTION-LIST"", _U._TYPE)
    THEN _F._LIST-ITEMS = REPLACE(cValue, "","":U, CHR(10)).
    ELSE _F._LIST-ITEMS = cValue.
  END."
95 "LOCK-COLUMNS" no 2 "I" "Lock-Columns!_C._NUM-LOCKED-COLUMNS" no no yes no no no no no no no no no no no no no no no no "" 65 ? "" yes "_C._NUM-LOCKED-COLUMNS = iValue."
96 "MANUAL-HIGHLIGHT" no 9 "L" "Manual-Highlight!_U._MANUAL-HIGHLIGHT" no yes no no yes yes yes yes yes yes yes yes yes no yes no no no no "" 735 ? "            _U._MANUAL-HIGHLIGHT = SELF:CHECKED." yes "_U._MANUAL-HIGHLIGHT = lValue."
97 "MAX-BUTTON" no 1 "L" "Max-Button!_C._MAX-BUTTON" yes no no no no no no no no no no no no no no no no no no "" 395 ? "  _C._MAX-BUTTON = SELF:CHECKED.
  IF _C._MAX-BUTTON AND _C._CONTEXT-HELP THEN DO:
    ASSIGN h_context-help:CHECKED = FALSE.
    APPLY ""VALUE-CHANGED"":U TO h_context-help.
  END.  " yes "_C._MAX-BUTTON = lValue."
98 "MAX-CHARS" no 2 "I" "Maximum-Characters!_F._MAX-CHARS" no no no no no yes yes no no no no no no no no no no no no "Editors & Editable combox" 55 ? "" yes "_F._MAX-CHARS = iValue."
99 "MAX-DATA-GUESS" no 2 "I" "Max-Data-Guess!_C._MAX-DATA-GUESS" no no yes no no no no no no no no no no no no no no no no "" 75 ? "" yes "_C._MAX-DATA-GUESS = iValue."
100 "MAX-VALUE" no 2 "I" "Maximum-Value!_F._MAX-VALUE" no no no no no no no no no no no no yes no no no no no no "Sliders" 60 ? "" yes "_F._MAX-VALUE = iValue."
101 "MENU-BAR" no 5 "R" "" yes no no no no no no no no no no no no no no no no no no "Menu-Bar Recid" 185 ? "" no ""
102 "MENU-KEY" no 2 "C" "" yes yes yes yes yes yes yes yes no yes no yes yes no yes no yes yes no "Acc Key for pop-up menus" 780 ? "" no ""
103 "MESSAGE-AREA" no 1 "L" "Message-Area!_C._MESSAGE-AREA" yes no no no no no no no no no no no no no no no no no no "Yes/No" 415 ? "  _C._MESSAGE-AREA = SELF:CHECKED." no ""
104 "MESSAGE-AREA-FONT" no 4 "I" "" yes no no no no no no no no no no no no no no no no yes no "" 880 ? "" no ""
105 "MIN-BUTTON" no 1 "L" "Min-Button!_C._MIN-BUTTON" yes no no no no no no no no no no no no no no no no no no "" 420 ? "  _C._MIN-BUTTON = SELF:CHECKED.
  IF _C._MIN-BUTTON AND _C._CONTEXT-HELP THEN DO:
    ASSIGN h_context-help:CHECKED = FALSE.
    APPLY ""VALUE-CHANGED"":U TO h_context-help.
  END.  " yes "_C._MIN-BUTTON = lValue."
106 "MIN-HEIGHT" no 2 "D" "" no no no no no no no no no no no no no no no no no no no "" 815 ? "" no ""
107 "MIN-HEIGHT-P" no 2 "I" "" no no no no no no no no no no no no no no no no no no no "" 820 ? "" no ""
108 "MIN-VALUE" no 2 "I" "Minimum-Value!_F._MIN-VALUE" no no no no no no no no no no no no yes no no no no no no "" 50 ? "" yes "_F._MIN-VALUE = iValue."
109 "MIN-WIDTH" no 2 "D" "" no no no no no no no no no no no no no no no no no no no "" 825 ? "" no ""
110 "MIN-WIDTH-P" no 2 "I" "" no no no no no no no no no no no no no no no no no no no "" 830 ? "" no ""
111 "MOUSE-POINTER" no 4 "I" "" yes yes yes yes yes yes yes yes no yes no yes yes no yes no yes yes no "Char string for load-m-p" 850 ? "" no ""
112 "MOVABLE" no 9 "L" "Movable!_U._MOVABLE" no yes yes no yes yes yes yes yes yes yes yes yes no yes no no no no "" 740 ? "            _U._MOVABLE = SELF:CHECKED." yes "_U._MOVABLE = lValue."
113 "MULTIPLE" no 1 "L" "Multiple-Selection!_C._MULTIPLE!_F._MULTIPLE" no no yes no no no no no no no no yes no no no no no no no "" 430 ? "  IF AVAILABLE _F THEN _F._MULTIPLE = SELF:CHECKED.
  ELSE _C._MULTIPLE = SELF:CHECKED." yes "
  DO:      
      IF AVAIL _C THEN 
         _C._MULTIPLE = lValue.
      ELSE IF AVAIL _F THEN 
         _F._MULTIPLE = lValue.
  END."
114 "NAME" no 2 "C" "" yes yes yes yes yes yes yes yes yes yes yes yes yes no yes no yes no no "" 5 ? "" yes "
  DO:     
    /* Make sure the name is valid. If so, get the best name. 
       [Pass the Type and _icount index as UNKNOWN because we won't ever 
       initialize the name to the stock defaults .
       (BUTTON-1, COMBO-BOX-2, etc)].  */
    RUN adecomm/_valname.p (INPUT cValue, FALSE, OUTPUT lValue).
    IF lValue THEN RUN adeshar/_bstname.p 
                           (INPUT  cValue, ?, ?, ?, parent_U._WINDOW-HANDLE, 
                            OUTPUT _U._NAME).
  END."
115 "NATIVE" no 1 "L" "Native!_F._NATIVE" no no no no no no no yes no no no no no no no no no no no "" 435 ? "  _F._NATIVE = SELF:CHECKED.
  IF SELF:CHECKED THEN ASSIGN h_VIEW-AS-TEXT:CHECKED = FALSE
                              _U._SUBTYPE = """":U." yes "_F._NATIVE = lValue."
116 "NO-ASSIGN" no 1 "L" "No-Assign!_C._NO-ASSIGN" no no yes no no no no no no no no no no no no no no no no "" 440 ? "  _C._NO-ASSIGN = SELF:CHECKED." yes "_C._NO-ASSIGN = lValue."
117 "NO-AUTO-VALIDATE" no 1 "L" "No-Auto-Validate!_C._NO-AUTO-VALIDATE" no yes yes yes no no no no no no no no no no no no no no no "" 445 ? "  _C._NO-AUTO-VALIDATE = SELF:CHECKED." yes "_C._NO-AUTO-VALIDATE = lValue."
118 "NO-CURRENT-VALUE" no 1 "L" "No-Current-Value!_F._NO-CURRENT-VALUE" no no no no no no no no no no no no yes no no no no no no "" 425 ? "  _F._NO-CURRENT-VALUE = SELF:CHECKED." yes "_F._NO-CURRENT-VALUE = lValue."
119 "NO-EMPTY-SPACE" no 1 "L" "No-Empty-Space!_C._NO-EMPTY-SPACE" no no yes no no no no no no no no no no no no no no no no "No empty space in browse" 455 "" "_C._NO-EMPTY-SPACE = SELF:CHECKED.
  IF _C._NO-EMPTY-SPACE THEN
    ASSIGN _C._FIT-LAST-COLUMN = FALSE
           h_fit-last-column:CHECKED = FALSE." yes "
  DO:
   _C._NO-EMPTY-SPACE = lvalue.      
   IF _C._NO-EMPTY-SPACE  THEN _C._FIT-LAST-COLUMN= FALSE.
  END."
120 "NO-HELP" no 1 "L" "No-Help!_C._NO-HELP" no yes no yes no no no no no no no no no no no no no no no "" 465 ? "  _C._NO-HELP = SELF:CHECKED." yes "_C._NO-HELP = lValue."
121 "NO-HIDE" no 1 "L" "No-Hide!NOT _C._HIDE" no yes no no no no no no no no no no no no no no no no no "(NO-HIDE)" 470 ? "  _C._HIDE = NOT SELF:CHECKED." yes "_C._HIDE = NOT lValue."
122 "NO-LABEL" no ? "L" "No-LABEL!_L._NO-LABEL" no no no no no yes no yes no no no no no no no no no no no "NO-LABEL on widget" 930 ? "" yes "_L._NO-LABEL = lValue."
123 "NO-ROW-MARKERS" no 1 "L" "No-Row-Markers!_C._NO-ROW-MARKERS" no no yes no no no no no no no no no no no no no no no no "" 480 ? "  _C._NO-ROW-MARKERS = SELF:CHECKED." yes "_C._NO-ROW-MARKERS = lValue."
124 "NO-TAB-STOP" no 1 "L" "No-Tab-Stop!_U._NO-TAB-STOP" no no yes no yes yes yes yes no yes no yes yes no yes no yes no no "" 485 ? "  _U._NO-TAB-STOP = SELF:CHECKED." yes "_U._NO-TAB-STOP = lValue."
125 "NO-UNDO" no 1 "L" "No-Undo!NOT _F._UNDO" no no no no no yes yes yes no yes no yes yes no yes no no no no "" 495 ? "  _F._UNDO = NOT SELF:CHECKED." yes "_F._UNDO = NOT lValue."
126 "NO-VALIDATE" no 1 "L" "No-Validate!NOT _C._VALIDATE" no yes yes yes no no no no no no no no no no no no no no no "" 500 ? "  _C._VALIDATE = NOT SELF:CHECKED." yes "_C._VALIDATE = NOT lValue."
127 "OPEN-QUERY" no 1 "L" "Open the Query!_Q._OpenQury" no yes yes yes no no no no no no no no no no no no no no no "" 505 ? "  _Q._OpenQury = SELF:CHECKED." yes "_Q._OpenQury = lValue."
128 "OVERLAY" no 1 "L" "Overlay!_C._OVERLAY" no yes no no no no no no no no no no no no no no no no no "" 510 ? "  _C._OVERLAY = SELF:CHECKED." yes "_C._OVERLAY = lValue."
129 "PAGE-BOTTOM" no 9 "L" "Page-Bottom!_C._PAGE-BOTTOM" no yes no no no no no no no no no no no no no no no no no "" 745 ? "            _C._PAGE-BOTTOM = SELF:CHECKED.
            IF _C._PAGE-BOTTOM THEN
              ASSIGN _C._DOWN           = FALSE
                     _C._PAGE-TOP       = FALSE
                     h_PAGE-TOP:CHECKED = FALSE." yes "_C._PAGE-BOTTOM = lValue."
130 "PAGE-TOP" no 9 "L" "Page-Top!_C._PAGE-TOP" no yes no no no no no no no no no no no no no no no no no "" 750 ? "            _C._PAGE-TOP = SELF:CHECKED.
            IF _C._PAGE-TOP THEN
              ASSIGN _C._PAGE-BOTTOM       = FALSE
                     h_PAGE-BOTTOM:CHECKED = FALSE
                     _C._DOWN              = FALSE." yes "_C._PAGE-TOP = lValue."
131 "PASSWORD-FIELD" no 1 "L" "Password-Field!_F._PASSWORD-FIELD" no no no no no no no yes no no no no no no no no no no no "" 515 ? "  _F._PASSWORD-FIELD = SELF:CHECKED." yes "_F._PASSWORD-FIELD = lValue."
132 "POP-UP" no 5 "L" "" yes yes yes yes yes yes yes yes no yes no yes yes no yes no no no no "" 170 ? "" no ""
133 "PRIVATE-DATA" no 7 "C" "Private-Data!_U._PRIVATE-DATA" yes yes yes yes yes yes yes yes yes yes yes yes yes no yes no yes yes no "" 685 ? "" yes "_U._PRIVATE-DATA = cValue."
134 "QUERY" no ? "C" "" no yes yes yes no no no no no no no no no no no no no no no "Query definition" 15 ? "" no ""
135 "READ-ONLY" no 1 "L" "Read-Only!_F._READ-ONLY" no no no no no no yes yes no no no no no no no no no no no "" 520 ? "  _F._READ-ONLY = SELF:CHECKED." yes "_F._READ-ONLY = lValue."
136 "RESIZABLE" no 9 "L" "Resizable!_U._RESIZABLE" no yes yes no yes yes yes yes yes yes yes yes yes no yes no no no no "" 755 ? "            _U._RESIZABLE = SELF:CHECKED." yes "_U._RESIZABLE = lValue."
137 "RESIZE" no 1 "L" "Resize!_U._RESIZABLE" yes no no no no no no no no no no no no no no no no no no "" 535 ? "  _U._RESIZABLE = SELF:CHECKED." no ""
138 "RETAIN" no 2 "I" "Retain!_C._RETAIN" no yes no no no no no no no no no no no no no no no no no "" 115 ? "" yes "_C._RETAIN = iValue."
139 "RETAIN-SHAPE" no 1 "L" "Retain-Shape!_F._RETAIN-SHAPE" no no no no no no no no yes no no no no no no no no no no "" 540 ? "  _F._RETAIN-SHAPE = SELF:CHECKED." yes "_F._RETAIN-SHAPE = lValue."
140 "RETURN-INSERTED" no 1 "L" "Return-Inserted!_F._RETURN-INSERTED" no no no no no no yes no no no no no no no no no no no no "" 545 ? "  _F._RETURN-INSERTED = SELF:CHECKED." yes "_F._RETURN-INSERTED = lValue."
141 "ROW-HEIGHT" no 2 "D" "Row Height!_C._ROW-HEIGHT" no no yes no no no no no no no no no no no no no no no no "" 215 ? "" yes "_C._ROW-HEIGHT = dValue."
142 "ROW-HEIGHT-P" no 2 "I" "Row Height Pixels" no no yes no no no no no no no no no no no no no no no no "" 910 ? "" yes "_C._ROW-HEIGHT = DECIMAL(iValue / SESSION:PIXELS-PER-ROW /
                    _cur_row_mult)."
143 "ROW-RESIZABLE" no 9 "L" "Row Resizable!_C._ROW-RESIZABLE" no no yes no no no no no no no no no no no no no no no no "" 760 ? "            _C._ROW-RESIZABLE = SELF:CHECKED." yes "_C._ROW-RESIZABLE = lValue."
144 "RUN-PERSISTENT" no 1 "L" "Run Persistent!_P._RUN-PERSISTENT" no no no no no no no no no no no no no no no yes no no no "" 550 ? "            _P._RUN-PERSISTENT = SELF:CHECKED." no ""
145 "SCREEN-LINES" no ? "D" "" no no no no no no no no no no no no no no no no no no no "Remove this" 860 ? "" no ""
146 "SCROLL-BARS" no 1 "L" "Scroll-Bars!_C._SCROLL-BARS" yes no no no no no no no no no no no no no no no no no no "" 555 ? "  _C._SCROLL-BARS = SELF:CHECKED." no ""
147 "SCROLLABLE" no 1 "L" "Scrollable!_C._SCROLLABLE" no yes no no no no no no no no no no no no no no no no no "" 560 ? "  ASSIGN _C._SCROLLABLE     = SELF:CHECKED
         h_v-wdth:SENSITIVE = SELF:CHECKED
         h_v-hgt:SENSITIVE  = SELF:CHECKED.
  IF NOT SELF:CHECKED THEN
    ASSIGN _L._VIRTUAL-WIDTH    = _L._WIDTH
           _L._VIRTUAL-HEIGHT   = _L._HEIGHT
           h_v-wdth:SCREEN-VALUE = STRING(_L._VIRTUAL-WIDTH,"">>9.99"")
           h_v-hgt:SCREEN-VALUE  = STRING(_L._VIRTUAL-HEIGHT,"">>9.99"")." yes "_C._SCROLLABLE = lValue."
148 "SCROLLBAR-H" no 1 "L" "Scrollbar-Horizontal!_F._SCROLLBAR-H" no no no no no no yes no no no no yes no no no no no no no "" 565 ? "  _F._SCROLLBAR-H = SELF:CHECKED.
  IF _U._TYPE = ""EDITOR"" THEN
    ASSIGN _F._WORD-WRAP         = NOT SELF:CHECKED
           h_WORD-WRAP:SENSITIVE = NOT SELF:CHECKED
           h_WORD-WRAP:CHECKED   = NOT SELF:CHECKED." yes "_F._SCROLLBAR-H = lValue."
149 "SCROLLBAR-V" no 1 "L" "Scrollbar-Vertical!_U._SCROLLBAR-V" no no yes no no no yes no no no no yes no no no no no no no "" 570 ? "  _U._SCROLLBAR-V = SELF:CHECKED." yes "_U._SCROLLBAR-V = lValue."
150 "SELECTABLE" no 9 "L" "Selectable!_U._SELECTABLE" no yes yes no yes yes yes yes yes yes yes yes yes no yes no no no no "" 765 ? "            _U._SELECTABLE = SELF:CHECKED." yes "_U._SELECTABLE = lValue."
151 "SENSITIVE" no 1 "L" "Sensitive!_U._SENSITIVE" yes yes no yes no no no no no no no no no no no no yes no no "" 575 ? "  _U._SENSITIVE = SELF:CHECKED." yes "_U._SENSITIVE = lValue."
152 "SHARED" no 1 "L" "Shared!_U._SHARED" no yes no no no yes yes yes no yes no yes yes no yes no no no no "" 595 ? "  _U._SHARED = SELF:CHECKED.
  IF _U._SHARED AND
     NOT CAN-DO(""BROWSE,FRAME"",_U._TYPE) THEN DO:
    IF ((CAN-DO(""CHARACTER,LONGCHAR"",_F._DATA-TYPE) AND _F._INITIAL-DATA NE """") OR
       (CAN-DO(""INTEGER,DECIMAL"",_F._DATA-TYPE)
             AND DECIMAL(_F._INITIAL-DATA) NE 0) OR
       (_F._DATA-TYPE = ""LOGICAL""
             AND NOT CAN-DO(""NO,FALSE"",_F._INITIAL-DATA)) OR 
       (CAN-DO(""DATE,DATETIME,DATETIME-TZ,RECID"",_F._DATA-TYPE) AND _F._INITIAL-DATA NE ""?""))
      THEN MESSAGE
        ""Shared variables will not retain initial values in the UIB.""
         VIEW-AS ALERT-BOX WARNING BUTTONS OK.
  END.
  ELSE IF _U._SHARED AND
    CAN-DO(""BROWSE,FRAME"",_U._TYPE) THEN DO:
    FIND x_U WHERE x_U._HANDLE = _U._WINDOW-HANDLE.
    FIND x_P WHERE x_P._u-recid = RECID(x_U).
    x_P._RUN-PERSISTENT = FALSE.
  END." no "_U._SHARED = lValue."
153 "SHOW-IN-TASKBAR" no 1 "L" "Show-in-Taskbar!_C._SHOW-IN-TASKBAR" yes no no no no no no no no no no no no no no no no no no "" 580 ? "  _C._SHOW-IN-TASKBAR = SELF:CHECKED.
" yes "_C._SHOW-IN-TASKBAR = lValue."
154 "SHOW-POPUP" no 1 "L" "Show-popup!_U._SHOW-POPUP" no yes no no no no no yes no no no no no no no no no no no "Display calendar or calc?" 600 "" "  _U._SHOW-POPUP = IF AVAILABLE _F AND CAN-DO(""DATE,DECIMAL,INTEGER"":u, _F._DATA-TYPE) AND isDynView 
      THEN SELF:CHECKED
      ELSE FALSE." yes " 
       _U._SHOW-POPUP =  IF ( AVAILABLE _F and  can-do(""DATE,DECIMAL,INTEGER"":u, _F._DATA-TYPE) and lparentIsDynview )
                              OR isDynview
                         THEN lvalue
                         ELSE false.
"
155 "SIDE-LABELS" no 1 "L" "Side-Labels!_C._SIDE-LABELS" no yes no no no no no no no no no no no no no no no no no "" 605 ? "  _C._SIDE-LABELS = SELF:CHECKED." yes "_C._SIDE-LABELS = lValue."
156 "SIZE-TO-FIT" no 1 "L" "Size to fit!_C._size-to-fit" no yes no no no no no no no no no no no no no no no no yes "" 610 ? "  _C._size-to-fit = SELF:CHECKED." yes "_C._size-to-fit = lValue."
157 "SMALL-ICON" no 6 "C" "" yes no no no no no no no no no no no no no no no no no no "" 90 ? "" no ""
158 "SMALL-TITLE" no 1 "L" "Small-Title!_C._SMALL-TITLE" yes no no no no no no no no no no no no no no no no no no "" 585 ? "  _C._SMALL-TITLE = SELF:CHECKED.
  IF _U._TYPE = ""WINDOW"":U THEN 
    RUN set_window_controls. 
" yes "_C._SMALL-TITLE = lValue."
159 "SORT" no 1 "L" "Sort!_F._SORT" no no no no no yes no no no no no yes no no no no no no no "" 615 ? "  _F._SORT = SELF:CHECKED." yes "_F._SORT = lValue."
160 "STATUS-AREA" no 1 "L" "Status-Area!_C._STATUS-AREA" yes no no no no no no no no no no no no no no no no no no "" 620 ? "  _C._STATUS-AREA = SELF:CHECKED." no ""
161 "STATUS-AREA-FONT" no 4 "I" "" yes no no no no no no no no no no no no no no no no yes no "" 855 ? "" no ""
162 "STRETCH-TO-FIT" no 1 "L" "Stretch-to-Fit!_F._STRETCH-TO-FIT" no no no no no no no no yes no no no no no no no no no no "" 625 ? "  _F._STRETCH-TO-FIT = SELF:CHECKED.
  IF NOT _F._STRETCH-TO-FIT THEN
    ASSIGN
      _F._RETAIN-SHAPE         = FALSE
      h_retain-shape:CHECKED   = FALSE
      h_retain-shape:SENSITIVE = FALSE.
  ELSE h_retain-shape:SENSITIVE = TRUE." yes "_F._STRETCH-TO-FIT = lValue."
163 "SUBTYPE" no ? "C" "Subtype!_U._SUBTYPE" no no no no no yes no no no no no no no no no no no no no "Combos" 40 ? "" yes "_U._SUBTYPE = cValue.
"
164 "SUPPRESS-WINDOW" no 1 "L" "Suppress Window!_C._SUPPRESS-WINDOW" yes no no no no no no no no no no no no no no no no no no "" 630 ? "  _C._SUPPRESS-WINDOW = SELF:CHECKED." no ""
165 "TIC-MARKS" no 4 "C" "Tic-Marks!_F._TIC-MARKS" no no no no no no no no no no no no yes no no no no no no "" 70 ? "" yes "_F._TIC-MARKS = cValue."
166 "TITLE" no 3 "C" "Title!_U._LABEL" yes yes yes yes no no no no no no no no no no no no no no no "Container Widget Title" 915 ? "" yes "_U._LABEL = cValue."
167 "TITLE-BAR" no 1 "L" "Title Bar!_C._TITLE" no yes yes no no no no no no no no no no no no no no no no "Yes or No" 635 ? "  _C._TITLE = SELF:CHECKED.
  IF _C._TITLE THEN
    ASSIGN _L._NO-BOX = FALSE
           h_no-box:CHECKED = FALSE." yes "
  DO:
    _C._TITLE = lValue.
    IF _C._TITLE THEN _L._NO-BOX = FALSE.
  END."
168 "TITLE-COLOR" no 5 "I" "" no yes no no no no no no no no no no no no no no no no no "Icon" 190 ? "" no ""
169 "TOGGLES" no 5 "L" "" yes yes yes yes yes yes yes yes yes yes yes yes yes no yes no yes yes yes "Psuedo Widget" 235 ? "" no ""
170 "TOOLTIP" no 2 "C" "Tooltip!_U._TOOLTIP" no no yes no yes yes yes yes yes yes yes yes yes yes yes no no no no "Tooltip" 110 ? "" yes "_U._TOOLTIP = cValue."
171 "TOP-ONLY" no 9 "L" "Top-Only!_C._TOP-ONLY" yes yes no no no no no no no no no no no no no no no yes no "" 775 ? "            _C._TOP-ONLY = SELF:CHECKED.
            IF _C._TOP-ONLY AND _U._TYPE = ""WINDOW"":U THEN
            ASSIGN
              _C._ALWAYS-ON-TOP       = FALSE
              h_always-on-top:CHECKED = FALSE.
" yes "_C._TOP-ONLY = lValue."
172 "TRANS-ATTRS" no 5 "L" "" yes yes yes yes yes yes yes yes yes yes yes yes yes yes yes no no no no "" 175 ? "" no ""
173 "TRANSPARENT" no 1 "L" "Transparent!_F._TRANSPARENT" no no no no no no no no yes no no no no no no no no no no "" 640 ? "  _F._TRANSPARENT = SELF:CHECKED.
  IF SELF:CHECKED AND h_convert-3d-colors:CHECKED THEN
    ASSIGN _L._CONVERT-3D-COLORS         = FALSE
           h_convert-3d-colors:CHECKED   = FALSE.
" yes "_F._TRANSPARENT = lValue."
174 "UNIQUE-MATCH" no 1 "L" "Unique-Match!_F._UNIQUE-MATCH" no no no no no yes no no no no no no no no no no no no no "" 645 ? "  _F._UNIQUE-MATCH = SELF:CHECKED.
" yes "_F._UNIQUE-MATCH = lValue."
175 "USE-DICT-EXPS" no 1 "L" "Use-Dict-Exps!_C._USE-DICT-EXPS" no yes no yes no no no no no no no no no no no no no no no "" 655 ? "  _C._USE-DICT-EXPS = SELF:CHECKED." yes "_C._USE-DICT-EXPS = lValue."
176 "VIEW" no 1 "L" "View!_U._DISPLAY" yes yes no yes no no no no no no no no no no no no no no no "" 660 ? "  _U._DISPLAY = SELF:CHECKED." yes "_U._DISPLAY = lValue."
177 "VIEW-AS-TEXT" no 1 "L" "View-As-Text!(_U._SUBTYPE = ""TEXT"":U)" no no no no no no no yes no no no no no no no no no no no "" 670 ? "  _U._SUBTYPE = (IF SELF:CHECKED THEN ""TEXT"":U ELSE """").
  IF SELF:CHECKED THEN
    ASSIGN h_NATIVE:CHECKED = FALSE
           _F._NATIVE       = FALSE
           _L._HEIGHT       =
            IF _L._FONT = ? THEN
            FONT-TABLE:GET-TEXT-HEIGHT-CHARS()
            ELSE
            FONT-TABLE:GET-TEXT-HEIGHT-CHARS(_L._FONT)
            h_hgt:SCREEN-VALUE = STRING(_L._HEIGHT,"">>9.99"").
   ELSE
     ASSIGN _L._HEIGHT        = 1
            h_hgt:SCREEN-VALUE = STRING(_L._HEIGHT,"">>9.99"").
" yes "  DO: 
    _U._SUBTYPE = (IF lValue THEN ""TEXT"":U ELSE """").
  END."
178 "VIRTUAL-HEIGHT-P" no 2 "I" "Virtual-Height-Pixels!_C._VIRTUAL-HEIGHT-P" yes yes no no no no no no no no no no no no no no no yes yes "" 705 ? "" yes "_L._VIRTUAL-HEIGHT = DECIMAL(iValue / SESSION:PIXELS-PER-ROW /
                    _L._ROW-MULT)."
179 "VIRTUAL-WIDTH-P" no 2 "I" "Virtual-Width-Pixels!_C._VIRTUAL-WIDTH-P" yes yes no no no no no no no no no no no no no no no yes yes "" 710 ? "" yes "_L._VIRTUAL-WIDTH = DECIMAL(iValue / SESSION:PIXELS-PER-COLUMN /
                    _L._COL-MULT)."
180 "VISIBLE" no 1 "L" "Visible!_U._DISPLAY" no no no no no no no no no no no no no no no no no no no "True is mv data to Scrn" 665 ? "  _U._DISPLAY = SELF:CHECKED." yes "_U._DISPLAY = lValue."
181 "WIDGET-ID" no 2 "I" "Widget-ID!_U._WIDGET-ID" no yes yes yes yes yes yes yes yes yes yes yes yes yes yes no yes no no "Widget ID" 145 ? "" yes "_U._WIDGET-ID = iValue."
182 "WIDTH-P" no 2 "I" "Width-Pixels!_U._WIDTH-P" yes yes yes yes yes yes yes yes yes yes yes yes yes yes yes no yes yes yes "" 700 ? "" yes "_L._WIDTH = DECIMAL(iValue / SESSION:PIXELS-PER-COLUMN /
                    _L._COL-MULT)."
183 "WINDOW-TITLE-FIELD" no 2 "C" "WINDOW-TITLE-FIELD!_C._WINDOW-TITLE-FIELD" no yes yes no no no no no no no no no no no no no no no no "Field to display in title" 130 "" "" yes "_C._WINDOW-TITLE-FIELD = cValue."
184 "WORD-WRAP" no 1 "L" "Word-Wrap!_F._WORD-WRAP" no no no no no no yes no no no no no no no no no no no no "" 675 ? "  _F._WORD-WRAP = SELF:CHECKED." yes "_F._WORD-WRAP = lValue."
185 "X" no 2 "I" "X!_U._X" yes yes yes yes yes yes yes yes yes yes yes yes yes yes yes no yes yes yes "" 690 ? "" no ""
186 "Y" no 2 "I" "Y!_U._Y" yes yes yes yes yes yes yes yes yes yes yes yes yes yes yes no yes yes yes "" 695 ? "" no ""
.
PSC
filename=abAttribute
records=0000000000186
ldbname=ab
timestamp=2005/07/27-16:02:45
numformat=44,46
dateformat=mdy-1950
map=NO-MAP
cpstream=ISO8859-1
.
0000043778
