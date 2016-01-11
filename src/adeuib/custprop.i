/************************************************************************
* Copyright (C) 2000-2006 by Progress Software Corporation.  All rights *
* reserved.  Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                              *
************************************************************************/
/* ***************************************************************************

   File: custprop.i
   Description:
         This is an automatically generated file. It creates an INCLUDE file
         that maps betweed Property Names (_PROP._NAME) and contents of the 
         Universal widget record (_U).  The following environment is assumed
         to exist:
          _U - the Universal Widget record to modify
          _F - the Field record (NOT AVAILABLE for container widgetts) 
          _C - a) the _C record associated with _U, for container widgets
               b) the _C record for the parent container, for field widgets
          parent_U - the record of the parent container, for field widgets
          cValue - the character value to assign 
          dValue - the decimal value of cValue (or ?) 
          iValue - the integer value of cValue (or ?) 
          lValue - the logical value of cValue (or ?) 

          err_text - is assumed to exist as a CHAR variable.  This can
                     be set internally to flag an invalid value for
                     an attribute.  A message of the following form
                     is created.: 
                        Invalid Attribute Value: cValue 
                        err_text  

   Author: Bill Wodd 

   Date Generated: 07/07/06

   Note: This procedure is generated via the Property Sheet Generator and 
         the abAttribute table of the ab database. 
         DO NOT CHANGE THIS FILE WITHOUT UPDATING THE AB DATABASE AND 
         USING THE PROPERTY SHEET GENERATOR TO GENERATE THIS CODE 

*************************************************************************** */
  WHEN "Always-On-Top":U THEN       _C._ALWAYS-ON-TOP = lValue.
  WHEN "AUTO-COMPLETION":U THEN     _F._AUTO-COMPLETION = lValue.
  WHEN "AUTO-END-KEY":U THEN        _F._AUTO-ENDKEY = lValue.
  WHEN "AUTO-GO":U THEN             _F._AUTO-GO = lValue.
  WHEN "AUTO-INDENT":U THEN         _F._AUTO-INDENT = lValue.
  WHEN "AUTO-RESIZE":U THEN         _F._AUTO-RESIZE = lValue.
  WHEN "AUTO-RETURN":U THEN         _F._AUTO-RETURN = lValue.
  WHEN "BGCOLOR":U THEN             _L._BGCOLOR = iValue.
  WHEN "BLANK":U THEN               _F._BLANK = lValue.
  WHEN "BOX-SELECTABLE":U THEN      _C._BOX-SELECTABLE = lValue.
  WHEN "CANCEL-BTN":U THEN          parent_C._cancel-btn-recid = RECID(_U).
  WHEN "COLUMN-MOVABLE":U THEN      _C._COLUMN-MOVABLE = lValue.
  WHEN "COLUMN-RESIZABLE":U THEN    _C._COLUMN-RESIZABLE = lValue.
  WHEN "COLUMN-SCROLLING":U THEN    _C._COLUMN-SCROLLING = lValue.
  WHEN "COLUMN-SEARCHING":U THEN    _C._COLUMN-SEARCHING = lValue.
  WHEN "CONTEXT-HELP":U THEN        _C._CONTEXT-HELP = lValue.
  WHEN "CONTEXT-HELP-FILE":U THEN   _C._CONTEXT-HELP-FILE = cValue.
  WHEN "CONTEXT-HELP-ID":U THEN     _U._CONTEXT-HELP-ID = iValue.
  WHEN "Control-Box":U THEN         _C._CONTROL-BOX = lValue.
  WHEN "CONVERT-3D-COLORS":U THEN   _L._CONVERT-3D-COLORS = lValue.
  WHEN "CUSTOM-SUPER-PROC":U THEN   _C._CUSTOM-SUPER-PROC = cValue.
  WHEN "DATA-TYPE":U THEN           
  DO: 
    IF CAN-DO("Character,LongChar,Date,DateTime,DateTime-Tz,Decimal,Logical,Integer,INT64":U, cValue) 
    THEN _F._DATA-TYPE = cValue.
    ELSE err_text = "DATA-TYPE must be Character, LongChar, Date, Decimal, Logical, Integer or INT64.".
  END.
  WHEN "DEBLANK":U THEN             _F._DEBLANK = lValue.
  WHEN "DEFAULT-BTN":U THEN         
  DO:
     IF lValue THEN parent_C._default-btn-recid = RECID(_U).
  END.
  WHEN "DEFAULT-STYLE":U THEN       _F._DEFAULT = lValue.
  WHEN "DELIMITER":U THEN           _F._DELIMITER = cValue.
  WHEN "DISABLE-AUTO-ZAP":U THEN    _F._DISABLE-AUTO-ZAP = lValue.
  WHEN "DISPLAY":U THEN             _U._DISPLAY = lValue.
  WHEN "DOWN":U THEN                _C._DOWN = lValue.
  WHEN "DRAG-ENABLED":U THEN        _F._DRAG-ENABLED = lValue.
  WHEN "Drop-Target":U THEN         _U._DROP-TARGET = lValue.
  WHEN "EDGE-PIXELS":U THEN         _L._EDGE-PIXELS = iValue.
  WHEN "ENABLE":U THEN              _U._ENABLE = lValue.
  WHEN "EXPAND":U THEN              _F._EXPAND = lValue.
  WHEN "FGCOLOR":U THEN             _L._FGCOLOR = iValue.
  WHEN "FILLED":U THEN              _L._FILLED = lValue.
  WHEN "FIT-LAST-COLUMN":U THEN     
  DO:
   _C._FIT-LAST-COLUMN = lvalue.      
   IF _C._FIT-LAST-COLUMN  THEN _C._NO-EMPTY-SPACE= FALSE.
  END.
  WHEN "FLAT":U THEN                _F._FLAT = lValue.
  WHEN "FOLDER-WIN-TO-LAUNCH":U THEN _C._FOLDER-WINDOW-TO-LAUNCH = cValue.
  WHEN "FONT":U THEN                _L._FONT = iValue.
  WHEN "FORMAT":U THEN              _F._FORMAT = cValue.
  WHEN "FREQUENCY":U THEN           _F._FREQUENCY = iValue.
  WHEN "GRAPHIC-EDGE":U THEN        _L._GRAPHIC-EDGE = lValue.
  WHEN "GROUP-BOX":U THEN           _L._GROUP-BOX = lValue.
  WHEN "HEIGHT":U THEN              _L._HEIGHT = dValue.

  WHEN "HEIGHT-P":U THEN            _L._HEIGHT = DECIMAL(iValue / SESSION:PIXELS-PER-ROW /
                    _L._ROW-MULT).
  WHEN "HELP":U THEN                _U._HELP = cValue.
  WHEN "HIDDEN":U THEN              _U._HIDDEN = lValue.
  WHEN "HORIZONTAL":U THEN          _F._HORIZONTAL = lValue.
  WHEN "IMAGE-DOWN":U THEN          _F._IMAGE-DOWN-FILE = cValue.
  WHEN "IMAGE-FILE":U THEN          _F._IMAGE-FILE = cValue.
  WHEN "IMAGE-INSENSITIVE":U THEN   _F._IMAGE-INSENSITIVE-FILE = cValue.
  WHEN "INITIAL-VALUE":U THEN       _F._INITIAL-DATA = cValue.
  WHEN "INNER-LINES":U THEN         _F._INNER-LINES = iValue.
  WHEN "KEEP-TAB-ORDER":U THEN      _C._KEEP-TAB-ORDER = lValue.
  WHEN "LABEL":U THEN               _U._LABEL = cValue.
  WHEN "LARGE":U THEN               _F._LARGE = lValue.
  WHEN "LARGE-TO-SMALL":U THEN      _F._LARGE-TO-SMALL = lValue.
  WHEN "LAYOUT-UNIT":U THEN         
  DO: 
    IF CAN-DO("C,Char,Character,P,Pixel", cValue) 
    THEN _U._LAYOUT-UNIT = (SUBSTRING(cValue,1,1) eq "C":U).
    ELSE err_text = "LAYOUT-UNIT must be C, Char, Character, P, or Pixel".
  END.
  WHEN "LIST-ITEMS":U THEN          
  DO:
    /* For Combo-boxes and Selection-lists, we want a CHR(10) delimited list */
    IF CAN-DO("COMBO-BOX,SELECTION-LIST", _U._TYPE)
    THEN _F._LIST-ITEMS = REPLACE(cValue, ",":U, CHR(10)).
    ELSE _F._LIST-ITEMS = cValue.
  END.
  WHEN "LOCK-COLUMNS":U THEN        _C._NUM-LOCKED-COLUMNS = iValue.
  WHEN "MANUAL-HIGHLIGHT":U THEN    _U._MANUAL-HIGHLIGHT = lValue.
  WHEN "MAX-BUTTON":U THEN          _C._MAX-BUTTON = lValue.
  WHEN "MAX-CHARS":U THEN           _F._MAX-CHARS = iValue.
  WHEN "MAX-DATA-GUESS":U THEN      _C._MAX-DATA-GUESS = iValue.
  WHEN "MAX-VALUE":U THEN           _F._MAX-VALUE = iValue.
  WHEN "MIN-BUTTON":U THEN          _C._MIN-BUTTON = lValue.
  WHEN "MIN-VALUE":U THEN           _F._MIN-VALUE = iValue.
  WHEN "MOVABLE":U THEN             _U._MOVABLE = lValue.
  WHEN "MULTIPLE":U THEN            
  DO:      
      IF AVAIL _C THEN 
         _C._MULTIPLE = lValue.
      ELSE IF AVAIL _F THEN 
         _F._MULTIPLE = lValue.
  END.
  WHEN "NAME":U THEN                
  DO:     
    /* Make sure the name is valid. If so, get the best name. 
       [Pass the Type and _icount index as UNKNOWN because we won't ever 
       initialize the name to the stock defaults .
       (BUTTON-1, COMBO-BOX-2, etc)].  */
    RUN adecomm/_valname.p (INPUT cValue, FALSE, OUTPUT lValue).
    IF lValue THEN RUN adeshar/_bstname.p 
                           (INPUT  cValue, ?, ?, ?, parent_U._WINDOW-HANDLE, 
                            OUTPUT _U._NAME).
  END.
  WHEN "NATIVE":U THEN              _F._NATIVE = lValue.
  WHEN "NO-ASSIGN":U THEN           _C._NO-ASSIGN = lValue.
  WHEN "NO-AUTO-VALIDATE":U THEN    _C._NO-AUTO-VALIDATE = lValue.
  WHEN "NO-BOX":U THEN              
  DO:
    _L._NO-BOX = lValue.
    IF _L._NO-BOX THEN IF AVAILABLE (_C) THEN _C._TITLE = NO.
  END.
  WHEN "NO-CURRENT-VALUE":U THEN    _F._NO-CURRENT-VALUE = lValue.
  WHEN "NO-EMPTY-SPACE":U THEN      
  DO:
   _C._NO-EMPTY-SPACE = lvalue.      
   IF _C._NO-EMPTY-SPACE  THEN _C._FIT-LAST-COLUMN= FALSE.
  END.
  WHEN "NO-FOCUS":U THEN            _L._NO-FOCUS = lValue.
  WHEN "NO-HELP":U THEN             _C._NO-HELP = lValue.
  WHEN "NO-HIDE":U THEN             _C._HIDE = NOT lValue.
  WHEN "NO-LABEL":U THEN            _L._NO-LABEL = lValue.
  WHEN "NO-LABELS":U THEN           _L._NO-LABELS = lValue.
  WHEN "NO-ROW-MARKERS":U THEN      _C._NO-ROW-MARKERS = lValue.
  WHEN "NO-TAB-STOP":U THEN         _U._NO-TAB-STOP = lValue.
  WHEN "NO-UNDERLINE":U THEN        _L._NO-UNDERLINE = lValue.
  WHEN "NO-UNDO":U THEN             _F._UNDO = NOT lValue.
  WHEN "NO-VALIDATE":U THEN         _C._VALIDATE = NOT lValue.
  WHEN "OPEN-QUERY":U THEN          _Q._OpenQury = lValue.
  WHEN "OVERLAY":U THEN             _C._OVERLAY = lValue.
  WHEN "PAGE-BOTTOM":U THEN         _C._PAGE-BOTTOM = lValue.
  WHEN "PAGE-TOP":U THEN            _C._PAGE-TOP = lValue.
  WHEN "PASSWORD-FIELD":U THEN      _F._PASSWORD-FIELD = lValue.
  WHEN "PRIVATE-DATA":U THEN        _U._PRIVATE-DATA = cValue.
  WHEN "READ-ONLY":U THEN           _F._READ-ONLY = lValue.
  WHEN "RESIZABLE":U THEN           _U._RESIZABLE = lValue.
  WHEN "RETAIN":U THEN              _C._RETAIN = iValue.
  WHEN "RETAIN-SHAPE":U THEN        _F._RETAIN-SHAPE = lValue.
  WHEN "RETURN-INSERTED":U THEN     _F._RETURN-INSERTED = lValue.
  WHEN "ROUNDED":U THEN             _L._ROUNDED = lValue.
  WHEN "ROW-HEIGHT":U THEN          _C._ROW-HEIGHT = dValue.
  WHEN "ROW-HEIGHT-P":U THEN        _C._ROW-HEIGHT = DECIMAL(iValue / SESSION:PIXELS-PER-ROW /
                    _cur_row_mult).
  WHEN "ROW-RESIZABLE":U THEN       _C._ROW-RESIZABLE = lValue.
  WHEN "SCROLLABLE":U THEN          _C._SCROLLABLE = lValue.
  WHEN "SCROLLBAR-H":U THEN         _F._SCROLLBAR-H = lValue.
  WHEN "SCROLLBAR-V":U THEN         _U._SCROLLBAR-V = lValue.
  WHEN "SELECTABLE":U THEN          _U._SELECTABLE = lValue.
  WHEN "SENSITIVE":U THEN           _U._SENSITIVE = lValue.
  WHEN "SEPARATOR-FGCOLOR":U THEN   _L._SEPARATOR-FGCOLOR = iValue.
  WHEN "SEPARATORS":U THEN          _L._SEPARATORS = lValue.
  WHEN "SHOW-IN-TASKBAR":U THEN     _C._SHOW-IN-TASKBAR = lValue.
  WHEN "SHOW-POPUP":U THEN           
       _U._SHOW-POPUP =  IF ( AVAILABLE _F and  can-do("DATE,DECIMAL,INTEGER,INT64":u, _F._DATA-TYPE) and lparentIsDynview )
                              OR isDynview
                         THEN lvalue
                         ELSE false.
  WHEN "SIDE-LABELS":U THEN         _C._SIDE-LABELS = lValue.
  WHEN "SIZE-TO-FIT":U THEN         _C._size-to-fit = lValue.
  WHEN "SMALL-TITLE":U THEN         _C._SMALL-TITLE = lValue.
  WHEN "SORT":U THEN                _F._SORT = lValue.
  WHEN "STRETCH-TO-FIT":U THEN      _F._STRETCH-TO-FIT = lValue.
  WHEN "SUBTYPE":U THEN             _U._SUBTYPE = cValue.

  WHEN "TIC-MARKS":U THEN           _F._TIC-MARKS = cValue.
  WHEN "TITLE":U THEN               _U._LABEL = cValue.
  WHEN "TITLE-BAR":U THEN           
  DO:
    _C._TITLE = lValue.
    IF _C._TITLE THEN _L._NO-BOX = FALSE.
  END.
  WHEN "TITLE-BGCOLOR":U THEN       _L._TITLE-BGCOLOR = iValue.
  WHEN "TITLE-FGCOLOR":U THEN       _L._TITLE-FGCOLOR = iValue.
  WHEN "TOOLTIP":U THEN             _U._TOOLTIP = cValue.
  WHEN "TOP-ONLY":U THEN            _C._TOP-ONLY = lValue.
  WHEN "TRANSPARENT":U THEN         _F._TRANSPARENT = lValue.
  WHEN "UNIQUE-MATCH":U THEN        _F._UNIQUE-MATCH = lValue.
  WHEN "USE-DICT-EXPS":U THEN       _C._USE-DICT-EXPS = lValue.
  WHEN "VIEW":U THEN                _U._DISPLAY = lValue.
  WHEN "VIEW-AS-TEXT":U THEN          DO: 
    _U._SUBTYPE = (IF lValue THEN "TEXT":U ELSE "").
  END.
  WHEN "VIRTUAL-HEIGHT":U THEN      _L._VIRTUAL-HEIGHT = dValue.
  WHEN "VIRTUAL-HEIGHT-P":U THEN    _L._VIRTUAL-HEIGHT = DECIMAL(iValue / SESSION:PIXELS-PER-ROW /
                    _L._ROW-MULT).
  WHEN "VIRTUAL-WIDTH":U THEN       _L._VIRTUAL-WIDTH = dValue.
  WHEN "VIRTUAL-WIDTH-P":U THEN     _L._VIRTUAL-WIDTH = DECIMAL(iValue / SESSION:PIXELS-PER-COLUMN /
                    _L._COL-MULT).
  WHEN "VISIBLE":U THEN             _U._DISPLAY = lValue.
  WHEN "WIDGET-ID":U THEN           _U._WIDGET-ID = iValue.
  WHEN "WIDTH":U THEN               _L._WIDTH = dValue.
  WHEN "WIDTH-P":U THEN             _L._WIDTH = DECIMAL(iValue / SESSION:PIXELS-PER-COLUMN /
                    _L._COL-MULT).
  WHEN "WINDOW-TITLE-FIELD":U THEN  _C._WINDOW-TITLE-FIELD = cValue.
  WHEN "WORD-WRAP":U THEN           _F._WORD-WRAP = lValue.
