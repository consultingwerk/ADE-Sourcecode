/***********************************************************************
* Copyright (C) 2005-2006,2009-2014,2020 by Progress Software Corporation.  *
* All rights reserved.  Prior versions of this work may contain        *
* portions contributed by participants of Possenet.                    *
*                                                                      *
***********************************************************************/
/*----------------------------------------------------------------------------

File: _rdwind.p

Description:
    Readin and instantiate a Window from the QUICK SAVE code.

Input Parameters:
   pp-recid - RECID of procedure record (to parent the window to).

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1992

Modified by GFS on 3/11/96 - added support for small-icon
            DRH on 7/12/96 - Commented out small-icon
            GFS on 10/9/96 - put small-icon back in
            GFS on 1/27/98 - added new attrs. for v9
            JEP on 09/28/98 - Support restoring treeviews/design window sizes.
            TSM on 06/04/99 - added support for context-sensitive help
            RKUMAR on 11/12/14- display warning when opening .w in 64-bit AppBuilder
            TMASOOD on 08/05/2020 Remove warning message for Height-Pixels, Width-Pixels etc
            
---------------------------------------------------------------------------- */
DEFINE INPUT PARAMETER pp-recid AS RECID NO-UNDO.
{adecomm/oeideservice.i}
{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/layout.i}       /* Layout temp-table definitions                     */
{adeuib/triggers.i}     /* Trigger TEMP-TABLE definition                     */
{adeuib/name-rec.i}     /* Name indirection table                            */
{adeuib/sharvars.i}     /* Shared variables                                  */
{adeuib/uibhlp.i}       /* Help file Context string definitions              */

DEFINE SHARED  STREAM    _P_QS.
DEFINE SHARED  VARIABLE  _inp_line  AS  CHAR     EXTENT 100           NO-UNDO.
DEFINE         VARIABLE  asc-value  AS  INTEGER                       NO-UNDO.
DEFINE         VARIABLE  done       AS  LOGICAL  INITIAL FALSE        NO-UNDO.
DEFINE         VARIABLE  i-let      AS  INTEGER                       NO-UNDO.
DEFINE         VARIABLE  i          AS  INTEGER                       NO-UNDO.
DEFINE         VARIABLE  ok         AS  LOGICAL                       NO-UNDO.
DEFINE         VARIABLE  potntl-num AS  CHAR                          NO-UNDO.
DEFINE         VARIABLE  scan-pos   AS  INTEGER                       NO-UNDO.
DEFINE         VARIABLE  design-win AS  LOGICAL  INITIAL FALSE        NO-UNDO.
DEFINE         VARIABLE  code-only  AS  LOGICAL  INITIAL FALSE        NO-UNDO.
DEFINE         VARIABLE  set-code-win AS LOGICAL INITIAL FALSE        NO-UNDO.
DEFINE         VARIABLE  save_win_type LIKE _cur_win_type INITIAL TRUE.
DEFINE         VARIABLE  save_col_mult LIKE _cur_col_mult INITIAL 1.
DEFINE         VARIABLE  save_row_mult LIKE _cur_row_mult INITIAL 1.
DEFINE VARIABLE _HEIGHT-P           AS INTEGER INITIAL ?.
DEFINE VARIABLE _WIDTH-P            AS INTEGER INITIAL ?.
DEFINE VARIABLE _VIRTUAL-HEIGHT-P   AS INTEGER INITIAL ?.
DEFINE VARIABLE _VIRTUAL-WIDTH-P    AS INTEGER INITIAL ?.
DEFINE VARIABLE _X                  AS INTEGER INITIAL ?.
DEFINE VARIABLE _Y                  AS INTEGER INITIAL ?.
define variable IDEIntegrated       as logical no-undo.

DEFINE BUFFER  x_U FOR _U.

function createContextMenu returns handle 
    () in _h_uib.
    
if valid-handle(hOEIDEService) then    
       run getIsIDEIntegrated in hOEIDEService (output IDEIntegrated).    

FIND _P WHERE RECID(_P) eq pp-recid.

CREATE _U.
CREATE _L.
CREATE _C.
CREATE _NAME-REC.

FIND-CREATE:
REPEAT:
  IMPORT STREAM _P_QS _inp_line.
  IF _inp_line[2] eq "DESIGN" THEN 
     ASSIGN _C._SUPPRESS-WINDOW = TRUE
            _U._SUBTYPE = "Design-Window":U.
  ELSE IF _inp_line[2] eq "SUPPRESS" THEN  
    _C._SUPPRESS-WINDOW = TRUE.
  ELSE IF _inp_line[1] = "CREATE":U and _inp_line[2] = "WINDOW":U THEN 
    LEAVE FIND-CREATE.
END.  /* FIND-CREATE */
ASSIGN design-win = (_U._SUBTYPE = "Design-Window":U)
       code-only  = design-win AND _P._FILE-TYPE <> "w".

/* If the window is not just a Design Window, then make sure _P._Allow 
   contains window. (This is here for compatibility with old releases, 
   where _P._Allow was not specified in the file.). */
IF NOT design-win AND NOT CAN-DO (_P._Allow, "Window") 
THEN DO:
  IF _P._Allow eq "" 
  THEN _P._Allow = "Window".
  ELSE _P._Allow = _P._Allow + ",Window".
END.

/* For code-only design windows, force win type to GUI and
   save the current settings for restore before this proc ends.
   We do this so design/code-only windows always use GUI for
   sizing, positioning, etc. NEVER RETURN FROM THIS PROC
   WITHOUT RESTORING THESE SETTINGS. - jep */
ASSIGN set-code-win = (code-only AND (NOT _cur_win_type OR _cur_win_type = ?)).
IF set-code-win THEN
DO:
    ASSIGN save_win_type = _cur_win_type
           save_col_mult = _cur_col_mult
           save_row_mult = _cur_row_mult
           _cur_win_type = TRUE
           _cur_col_mult = 1
           _cur_row_mult = 1.
END.

/* Note: A window name will never conflict with an existing name because no
   other names will exist. */
ASSIGN _L._WIN-TYPE          = _cur_win_type
       _L._COL-MULT          = IF _cur_win_type THEN 1 ELSE _tty_col_mult
       _L._ROW-MULT          = IF _cur_win_type THEN 1 ELSE _tty_row_mult
       _P._u-recid           = RECID(_U)
       _U._x-recid           = RECID(_C)
       _U._lo-recid          = RECID(_L)
       _L._LO-NAME           = "Master Layout"
       _L._u-recid           = RECID(_U)
       _U._NAME              = _inp_line[3]    
       _cur_col_mult         = _L._COL-MULT
       _cur_row_mult         = _L._ROW-MULT
       _C._KEEP-FRAME-Z-ORDER = FALSE
       _NAME-REC._wNAME      = _U._NAME
       _NAME-REC._wTYPE      = "WINDOW"
       _NAME-REC._wRECID     = RECID(_U).          

/* Establish new _count[{&WINDW}] */
/* ksu 02/23/94 LENGTH use default mode */
if _U._NAME BEGINS "WINDOW-" THEN
NUMERIC-CHECK:
DO:
  potntl-num = SUBSTRING(_U._NAME,8,-1,"CHARACTER":U).
  IF LENGTH(potntl-num, "RAW":U) > 0 THEN
  DO i-let = 1 TO LENGTH(potntl-num,"CHARACTER":U):
    asc-value = ASC(SUBSTRING(potntl-num,i-let,1,"CHARACTER":U)).
    IF asc-value < 48 OR asc-value > 57 THEN LEAVE NUMERIC-CHECK.
  END.
  ELSE LEAVE NUMERIC-CHECK.
  _count[{&WINDW}] = MAX(_count[{&WINDW}],INTEGER(potntl-num)).
END.

REPEAT WHILE NOT DONE:

  /* Read the next line */
  IMPORT STREAM _P_QS _inp_line.

  /* CHECK FOR PERIOD AT THE END OF THE LINE INDICATING DONE IS TRUE. 
     i.e. Line is "  ATTRIBUTE = VALUE."  
     Watch out for case where _inp_line[3] is empty (eg. TITLE = "") */
  IF LENGTH(_inp_line[3],"CHARACTER":U) > 0 AND 
       SUBSTRING(_inp_line[3],LENGTH(_inp_line[3],"CHARACTER":U),1,
                                               "CHARACTER":U) = "." AND
       _inp_line[1] NE "TITLE":U AND _inp_line[1] NE "PRIVATE-DATA":U
  THEN ASSIGN DONE = TRUE
              _inp_line[3] = SUBSTRING(_inp_line[3],1,
                              LENGTH(_inp_line[3],"CHARACTER":U) - 1,"CHARACTER":U).
  CASE _inp_line[1]:
    WHEN "ALWAYS-ON-TOP"      THEN _C._ALWAYS-ON-TOP = _inp_line[3] begins "y".
    WHEN "BGCOLOR"            THEN _L._BGCOLOR  = INTEGER(_inp_line[3]).
    WHEN "COLUMN"             THEN _L._COL      = DECIMAL(_inp_line[3]).
    WHEN "CONTROL-BOX"        THEN _C._CONTROL-BOX = _inp_line[3] begins "y".
    WHEN "CONTEXT-HELP"       THEN _C._CONTEXT-HELP = _inp_line[3] begins "y".
    WHEN "CONTEXT-HELP-FILE"  THEN _C._CONTEXT-HELP-FILE = _inp_line[3].
    WHEN "DROP-TARGET"        THEN _U._DROP-TARGET = _inp_line[3] begins "y".
    WHEN "FGCOLOR"            THEN _L._FGCOLOR  = INTEGER(_inp_line[3]).
    WHEN "FONT"               THEN _L._FONT     = INTEGER(_inp_line[3]).
    WHEN "HEIGHT"             THEN _L._HEIGHT   = DECIMAL(_inp_line[3]).
    WHEN "HEIGHT-P"           THEN _HEIGHT-P    = INTEGER(_inp_line[3]).
    WHEN "HEIGHT-PIXELS"      THEN _HEIGHT-P    = INTEGER(_inp_line[3]).
    WHEN "HIDDEN"             THEN _U._HIDDEN           = _inp_line[3] BEGINS "y".
    WHEN "KEEP-FRAME-Z-ORDER" THEN _C._KEEP-FRAME-Z-ORDER = _inp_line[3] BEGINS "y".
    WHEN "MAX-BUTTON"         THEN _C._MAX-BUTTON           = _inp_line[3] BEGINS "y".
    WHEN "MAX-HEIGHT"         THEN _U._LAYOUT-UNIT      = TRUE.
    WHEN "MAX-HEIGHT-P"       THEN _U._LAYOUT-UNIT      = FALSE.
    WHEN "MAX-HEIGHT-PIXELS"  THEN _U._LAYOUT-UNIT      = FALSE.
    WHEN "MAX-WIDTH"          THEN DO:    END.
    WHEN "MAX-WIDTH-P"        THEN DO:    END.
    WHEN "MAX-WIDTH-PIXELS"   THEN DO:    END.
    /* We can ignore the MENUBAR attribute because we will attach the one
       and only MENUBAR in the .w file to the one and only window  */
    WHEN "MENUBAR"          THEN DO:    END.
    WHEN "MENU-KEY"         THEN _U._MENU-KEY         = _inp_line[3].
    WHEN "MENU-MOUSE"       THEN _U._MENU-MOUSE       = _inp_line[3].
    WHEN "MESSAGE-AREA"     THEN _C._MESSAGE-AREA     = _inp_line[3] BEGINS "y".
    WHEN "MESSAGE-AREA-FONT" THEN _C._MESSAGE-AREA-FONT
                                                      = INTEGER(_inp_line[3]).
    WHEN "MIN-BUTTON"       THEN _C._MIN-BUTTON       = _inp_line[3] begins "y". 
    WHEN "MIN-HEIGHT"       THEN _C._MIN-HEIGHT       = DECIMAL(_inp_line[3]).
    WHEN "MIN-WIDTH"        THEN _C._MIN-WIDTH        = DECIMAL(_inp_line[3]).
    WHEN "MOUSE-POINTER"    THEN _U._MOUSE-POINTER    = _inp_line[3].
    WHEN "POPUP-MENU"       THEN DO:
      CREATE x_U.
      CREATE _NAME-REC.
      /* Don't worry about an existing _U at this time (because this is only
         the second widget.  If the name exists already then it must be a
         compiler error). */
      ASSIGN x_U._TYPE          = "MENU"
             x_U._SUBTYPE       = "POPUP-MENU"
             _NAME-REC._wNAME   =  ENTRY(1,_inp_line[4],":")
             _NAME-REC._wTYPE   = x_U._TYPE
             _NAME-REC._wRECID  = RECID(x_U) 
             x_U._NAME          = _NAME-REC._wNAME
	     _U._POPUP-RECID    = RECID(x_U)  /* _U for window */
             x_U._PARENT-RECID  = RECID(_U).
    END.
    WHEN "PRIVATE-DATA"     THEN 
    DO:
      ASSIGN _U._PRIVATE-DATA      = _inp_line[3] NO-ERROR.
      IF ERROR-STATUS:ERROR 
      THEN RUN error-msg ("Could not parse PRIVATE-DATA for window.").
      ELSE
      DO:
        /* If there is are no string attributes defined then _inp_line[4]
           still contains "ASSIGN" from importing "CREATE WINDOW winname ASSIGN"
           so we need to check for ASSIGN to avoid writing out 
           PRIVATE-DATA = "test":ASSIGN */
        IF _inp_line[4] <> "" AND _inp_line[4] <> "ASSIGN" THEN
        ASSIGN _U._PRIVATE-DATA-ATTR = LEFT-TRIM(_inp_line[4],":":U).
      END.
    END.
    WHEN "RESIZE"                THEN _U._RESIZABLE        = _inp_line[3] BEGINS "y".
    WHEN "ROW"                   THEN _L._ROW              = DECIMAL(_inp_line[3]).
    WHEN "SCROLL-BARS"           THEN _C._SCROLL-BARS      = _inp_line[3] BEGINS "y".
    WHEN "SENSITIVE"             THEN _U._SENSITIVE        = _inp_line[3] BEGINS "y".
    WHEN "SHOW-IN-TASKBAR"       THEN _C._SHOW-IN-TASKBAR  = _inp_line[3] BEGINS "y".
    WHEN "SMALL-TITLE"           THEN _C._SMALL-TITLE      = _inp_line[3] BEGINS "y".
    WHEN "STATUS-AREA"           THEN _C._STATUS-AREA      = _inp_line[3] BEGINS "y".
    WHEN "STATUS-AREA-FONT"      THEN _C._STATUS-AREA-FONT = INTEGER(_inp_line[3]).
    WHEN "TITLE"                 THEN _U._LABEL            = _inp_line[3].
    WHEN "THREE-D"               THEN _L._3-D              = _inp_line[3] BEGINS "y".
    WHEN "TOP-ONLY"              THEN _C._TOP-ONLY         = _inp_line[3] BEGINS "y".
    WHEN "VIRTUAL-HEIGHT"        THEN _L._VIRTUAL-HEIGHT   = DECIMAL(_inp_line[3]).
    WHEN "VIRTUAL-HEIGHT-P"      THEN _VIRTUAL-HEIGHT-P    = INTEGER(_inp_line[3]).
    WHEN "VIRTUAL-HEIGHT-PIXELS" THEN _VIRTUAL-HEIGHT-P    = INTEGER(_inp_line[3]).
    WHEN "VIRTUAL-WIDTH"         THEN _L._VIRTUAL-WIDTH    = DECIMAL(_inp_line[3]).
    WHEN "VIRTUAL-WIDTH-P"       THEN _VIRTUAL-WIDTH-P     = INTEGER(_inp_line[3]).
    WHEN "VIRTUAL-WIDTH-PIXELS"  THEN _VIRTUAL-WIDTH-P     = INTEGER(_inp_line[3]).
    WHEN "VISIBLE"               THEN _U._DISPLAY          = _inp_line[3] BEGINS "y".
    WHEN "WIDTH"                 THEN _L._WIDTH            = DECIMAL(_inp_line[3]).
    WHEN "WIDTH-P"               THEN _WIDTH-P             = INTEGER(_inp_line[3]).
    WHEN "WIDTH-PIXELS"          THEN _WIDTH-P             = INTEGER(_inp_line[3]).
    WHEN "X"                     THEN _X                   = INTEGER(_inp_line[3]).
    WHEN "Y"                     THEN _Y                   = INTEGER(_inp_line[3]).
    
    OTHERWISE IF _inp_line[1] NE "" THEN
                MESSAGE _inp_line[1] _inp_line[2] _inp_line[3] SKIP
                        "not a valid window attribute." 
                        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  END CASE.
END.  /* REPEAT WHILE NOT DONE */

/* Was position explicitly set? NOTE: it must be set for both row and column. */
_C._EXPLICIT_POSITION = IF _U._LAYOUT-UNIT
                        THEN (_L._ROW ne ?) AND (_L._COL ne ?)
                        ELSE (_X ne ?) AND (_Y ne ?).

/* Now look for the icons of the window */
HANDLE-ICONS:
REPEAT i = 1 TO 7:  /* Don't look for more than 7 lines */
  IMPORT STREAM _P_QS _inp_line.
  /* Save file position because we need to backup to this position later */
  IF i = 1 THEN scan-pos = SEEK(_P_QS).
  IF _inp_line[1] = "/*":U AND _inp_line[2] = "END":U AND
     _inp_line[3] = "WINDOW":U AND _inp_line[4] = "DEFINITION":U THEN DO:
    scan-pos = -111.     /* This tells us we have a "normal" exit */
    LEAVE HANDLE-ICONS. 
  END.
  IF _inp_line[1] = "ASSIGN":U AND _inp_line[3] = "=":U AND
    _inp_line[4] = "MENU":U THEN i = i - 2.       /* Skip menubar assignment */
  IF _inp_line[1] = "IF" AND _inp_line[2] = "NOT" AND 
     INDEX(_inp_line[3],":LOAD-ICON":U) > 0 THEN DO:
    IMPORT STREAM _P_QS _inp_line.
    _C._ICON = SUBSTRING(_inp_line[2],22,-1,"CHARACTER":U).
  END.
  IF _inp_line[1] = "IF" AND _inp_line[2] = "NOT" AND 
     INDEX(_inp_line[3],":LOAD-SMALL-ICON":U) > 0 THEN DO:
    IMPORT STREAM _P_QS _inp_line.
    _C._SMALL-ICON = SUBSTRING(_inp_line[2],28,-1,"CHARACTER":U).
  END.
END.

/* Backup to end of window processing */
IF scan-pos NE -111 THEN SEEK STREAM _P_QS TO scan-pos.

/* Force the design window of a design-window object to have the following
   defaults. */
IF design-win THEN
  ASSIGN  _U._NAME               = _P._TYPE WHEN _P._FILE-TYPE <> "w":U
          _U._LABEL              = (if _P._Type eq 'SmartDataObject':u and not _P._Db-Aware then 
                                    'DataView':u else _P._TYPE)
          _U._HIDDEN             = YES
          _U._LAYOUT-UNIT        = YES /* CHARS */
          _U._RESIZABLE          = YES
          _U._SENSITIVE          = YES
          _C._KEEP-FRAME-Z-ORDER = YES
          _C._SUPPRESS-WINDOW    = YES
          _C._MESSAGE-AREA       = NO
          _C._SCROLL-BARS        = NO
          _C._STATUS-AREA        = NO
          _L._3-D                = YES
          /* END ASSIGN */ .

/* In the case of TTY windows (or Design-Windows) - use default color & font.
   Also set the virtual size of the window (which will in turn allow the
   user to resize the window to the size of the screen). */
IF (NOT _L._WIN-TYPE) OR (design-win)
THEN ASSIGN _L._BGCOLOR        = ?
  	    _L._FGCOLOR        = ?
  	    _L._VIRTUAL-HEIGHT = _L._HEIGHT
  	    _L._VIRTUAL-WIDTH  = _L._WIDTH
  	    _L._FONT           = ?.

/* The window should be resizable in the UIB to sizes up to the size of
   the screen (SESSION:WIDTH & HEIGHT).  So we will set the MAX- to the screen
   size independent of the runtime window's "true" size.  However, on
   Motif this would mean that the window always would have SCROLL-BARS
   (on Windows, SCROLL-BARS only appear when needed).  So turn off scrollbars
   on Motif. */
&IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN
  ASSIGN _C._SCROLL-BARS = NO.
&ENDIF

/* The TreeView OCX only exists on 32-bit Windows. On 64-bit we don't create
** the treeview. A window will be created for the object so the user can give
** this window focus and bring up the Section Editor to modify the procedure.
*/
IF (_P._type BEGINS "WEB":U OR CAN-DO("p,i":U, _P._file-type)) THEN DO:
    if (PROCESS-ARCHITECTURE = 64 and not OEIDEIsRunning)  THEN DO:
                 RUN adeuib/_c64tv.p. 
    end.
    else if (PROCESS-ARCHITECTURE = 32 or OEIDEIsRunning)  THEN
    DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
	  /* Create Treeview design window for code-only files. */
	  DEFINE VAR h_TreeProc AS HANDLE NO-UNDO.
	  
	  if OEIDEIsRunning then
	  do:
	      RUN adeuib/ide/_treeview.p PERSISTENT SET h_TreeProc.
	      /* we RUN createTree below after sizing */ 
	  end.    
	  else do:   
	      RUN adeuib/_tview.w PERSISTENT SET h_TreeProc. 
	  
	      RUN createTree IN h_TreeProc (RECID(_P)).
	  end.
	  ASSIGN _h_win = DYNAMIC-FUNCTION("getWinHandle" IN h_TreeProc).
	end.
END.

/* If not creating a Treeview window or something went wrong creating one, create
   simple style design window. */
IF NOT VALID-HANDLE(h_TreeProc) OR NOT VALID-HANDLE(_h_win) THEN
DO:    
  /* Instantiate the Window with attributes that can't conflict with each other */
  /* If you make changes here, you must review adeuib/_tview.w and see if you
     need to make the same changes there. jep */
  CREATE WINDOW _h_win
   ASSIGN PARENT            = _h_menu_win
          BGCOLOR           = IF _L._WIN-TYPE THEN _L._BGCOLOR ELSE _tty_bgcolor
          FGCOLOR           = IF _L._WIN-TYPE THEN _L._FGCOLOR ELSE _tty_fgcolor
          FONT              = IF _L._WIN-TYPE THEN _L._FONT    ELSE _tty_font
          MESSAGE-AREA      = _C._MESSAGE-AREA
          SCROLL-BARS       = _C._SCROLL-BARS
          STATUS-AREA-FONT  = _C._STATUS-AREA-FONT
          STATUS-AREA       = _C._STATUS-AREA
          THREE-D           = _L._3-D
          min-button = true /*not IDEIntegrated*/
          max-button = true /* not IDEIntegrated */
          SHOW-IN-TASKBAR   = FALSE
          KEEP-FRAME-Z-ORDER = TRUE
          TITLE             = _U._LABEL
        TRIGGERS:
            {adeuib/windtrig.i}
        END TRIGGERS.
   
END.

IF not OEIDEIsRunning THEN  
do:    
    {adeuib/grptrig.i &of-widget-list="OF _h_win"}  
end.
else
DO:
   /* TODO deal with temp windows from save super of gendyn - 
   set flag if no parent and don't call positionDesign below */   
   DEFINE VARIABLE hWindow AS HANDLE NO-UNDO.
   hWindow = _h_win. /* Temporary fix for 20051027-068 */
   RUN displayDesignWindow IN hOEIDEService (_save_file,   hWindow).
  _h_win = hWindow.
  _h_win:popup-menu = createContextMenu(). 
   on any-key of _h_win anywhere persistent run OnAnyKey in _h_uib.
END.

/* Carefully load attributes that may conflict with others.  Note: conflicts */
/* are resolved in favor of the attribute that comes last alphabetically     */
IF _U._MENU-KEY NE ?        THEN
  ASSIGN _h_win:MENU-KEY      = _U._MENU-KEY.
/* IF _U._MENU-MOUSE NE ?   THEN ASSIGN _h_win:MENU-MOUSE    = _U._MENU-MOUSE.*/
IF _U._MOUSE-POINTER NE ?   THEN
  ASSIGN ok = _h_win:LOAD-MOUSE-POINTER(_U._MOUSE-POINTER).
IF _C._ICON NE ? AND _C._ICON NE "" THEN
  ASSIGN ok = _h_win:LOAD-ICON(_C._ICON).
IF _C._SMALL-ICON NE ? AND _C._SMALL-ICON NE "" THEN
  ASSIGN ok = _h_win:LOAD-SMALL-ICON(_C._SMALL-ICON).

/* Size the window */
IF _HEIGHT-P > 0  THEN ASSIGN _h_win:HEIGHT-P      = _HEIGHT-P NO-ERROR.
IF _L._HEIGHT > 0 THEN ASSIGN _h_win:HEIGHT        = _L._HEIGHT * _cur_row_mult NO-ERROR.
IF _L._WIDTH > 0  THEN ASSIGN _h_win:WIDTH         = _L._WIDTH * _cur_col_mult NO-ERROR.
IF _WIDTH-P > 0   THEN ASSIGN _h_win:WIDTH-P       = _WIDTH-P NO-ERROR.

IF _C._MIN-WIDTH > 0        THEN
  ASSIGN _h_win:MIN-WIDTH           = _C._MIN-WIDTH * _cur_col_mult.
IF _C._MIN-HEIGHT > 0       THEN    
  ASSIGN _h_win:MIN-HEIGHT          = _C._MIN-HEIGHT * _cur_row_mult.

IF _L._VIRTUAL-WIDTH > 0    THEN
  ASSIGN _h_win:VIRTUAL-WIDTH    = _L._VIRTUAL-WIDTH * _cur_col_mult
         _h_win:MAX-WIDTH        = SESSION:WIDTH-CHARS NO-ERROR.
IF _L._VIRTUAL-HEIGHT > 0   THEN    
  ASSIGN _h_win:VIRTUAL-HEIGHT   = _L._VIRTUAL-HEIGHT * _cur_row_mult
         _h_win:MAX-HEIGHT       = SESSION:HEIGHT-CHARS NO-ERROR.
IF _VIRTUAL-HEIGHT-P > 0 THEN
  ASSIGN _h_win:VIRTUAL-HEIGHT-P = _VIRTUAL-HEIGHT-P
         _h_win:MAX-HEIGHT-P     = SESSION:HEIGHT-PIXELS NO-ERROR.
IF _VIRTUAL-WIDTH-P > 0  THEN
  ASSIGN _h_win:VIRTUAL-WIDTH-P  = _VIRTUAL-WIDTH-P
         _h_win:MAX-WIDTH-P      = SESSION:WIDTH-PIXELS NO-ERROR.

/* Position the window */  
IF _C._EXPLICIT_POSITION THEN DO:
  /* NOTE: Don't scale the row or column with _cur_row_mult - because position is 
     in GUI screen coordinates*/
  IF _L._COL > 0 THEN ASSIGN _h_win:COL  = _L._COL.
  IF _L._ROW > 0 THEN ASSIGN _h_win:ROW  = _L._ROW.
  IF _X NE ? THEN ASSIGN _h_win:X = _X.
  IF _Y NE ? THEN ASSIGN _h_win:Y = _Y.
END.
ELSE DO ON STOP UNDO, LEAVE:
  /* Get the next best position. */
  RUN adeuib/_windpos.p (OUTPUT _X, OUTPUT _Y).
  ASSIGN _h_win:X = _X
         _h_win:Y = _Y
         .
END.

/* position the design window based on IDE preferences */
IF OEIDEIsRunning THEN
DO: 
    if valid-handle( h_TreeProc)  then
        RUN createTree IN h_TreeProc (RECID(_P)).
    
    run positionDesignWindow in hOEIDEService (_h_win).
END.  /* oeide */  
ELSE DO:
  /* Test the case where the window is off the screen.  Perhaps this is
     because the user built it on a different monitor. Ask if she would like
     to move it back on the screen. */
  IF _h_win:X >= SESSION:WIDTH-P OR _h_win:Y >= SESSION:HEIGHT-P 
  OR _h_win:X < 0                OR _h_win:Y < 0 THEN 
  DO:
    MESSAGE "The specified position of the window is off the screen." {&SKP}
            "Would you like repositioned?"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK-CANCEL UPDATE ok.
    IF ok THEN
      ASSIGN
        _h_win:X = MAX(0, (SESSION:WIDTH-P - _h_win:WIDTH-P) / 2)
        _h_win:Y = MAX(0, (SESSION:HEIGHT-P - _h_win:HEIGHT-P) / 2).
  END. 
END. /* not ide */

/* Realize the window and synchronize remaining attributes                   */
ASSIGN _h_win:HIDDEN         = TRUE
       _h_win:SENSITIVE      = TRUE
       CURRENT-WINDOW        = _h_win
       _h_cur_widg           = _h_win
       _U._HANDLE            = _h_win
       _C._MIN-WIDTH         = _h_win:MIN-WIDTH / _cur_col_mult
       _C._MIN-HEIGHT        = _h_win:MIN-HEIGHT / _cur_row_mult
       _C._SCREEN-LINES      = _h_win:SCREEN-LINES
       _U._TYPE              = _h_win:TYPE
       _U._WINDOW-HANDLE     = _h_win
       _C._WINDOW-STATE      = STRING(_h_win:WINDOW-STATE)
       _L._COL               = ((_h_win:COL - 1) / _cur_col_mult) + 1
       _L._COL-MULT          = _cur_col_mult
       _L._HEIGHT            = _h_win:HEIGHT / _cur_row_mult
       _L._ROW               = ((_h_win:ROW - 1) / _cur_row_mult) + 1
       _L._ROW-MULT          = _cur_row_mult
       _L._VIRTUAL-HEIGHT    = _h_win:VIRTUAL-HEIGHT / _cur_row_mult
       _L._VIRTUAL-WIDTH     = _h_win:VIRTUAL-WIDTH / _cur_col_mult
       _L._WIDTH             = _h_win:WIDTH / _cur_col_mult
       /* Procedure Information */
       _P._FILE-SAVED        = TRUE
       _P._SAVE-AS-FILE      = _save_file
       _P._WINDOW-HANDLE     = _U._WINDOW-HANDLE
   NO-ERROR.      /* NO-ERROR to prevent warning if OEIDEIsRunning */

/* show warnings if not oeide */      
IF not OEIDEIsRunning THEN    
do i = 1 to error-status:num-messages:
    message error-status:get-message(i) view-as alert-box warning.
end.        

/* If we need to, restore current window settings. */
IF set-code-win THEN
DO:
    ASSIGN _cur_win_type = save_win_type
           _cur_col_mult = save_col_mult
           _cur_row_mult = save_row_mult.
END.

/* Now load the title and file-name */
RUN adeuib/_wintitl.p (_h_win, _U._LABEL, _U._LABEL-ATTR, _P._SAVE-AS-FILE).

/*The opened object in the AppBuilder is a DataView*/
IF _P._type = "SmartDataObject":U AND NOT _P._db-aware
    THEN RUN adeuib/_unddv.p (RECID(_U)).
