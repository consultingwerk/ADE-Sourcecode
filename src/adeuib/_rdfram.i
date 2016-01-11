/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _rdfram.i

Description:
   Include file that contains code that is common for assigning values to
   a newly created frame, browse, dialog-box widget based on the _U record
   information. Currently used to read in a .w file and by the undo mechanism.

Input Parameters: <None>

Output Parameters: <None>

Author: Ravi-Chandar Ramalingam

Date Created: 24 February 1993.

Modified: 
  07/14/94 wood  UIB Dialog size is now Inner-size (no border)

----------------------------------------------------------------------------*/

{adeuib/gridvars.i }  /* Current shared values for grids        */
{adeuib/uibhlp.i}     /* Help file Context string definitions   */

DEFINE VARIABLE frame-bar           AS WIDGET-HANDLE                   NO-UNDO.
DEFINE VARIABLE h_self              AS WIDGET-HANDLE                   NO-UNDO.
DEFINE VARIABLE h_dlg_win           AS WIDGET-HANDLE                   NO-UNDO.
DEFINE VARIABLE l_ok2move           AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE parent-hndl         AS WIDGET-HANDLE                   NO-UNDO.
DEFINE VARIABLE title_sa            AS CHAR                            NO-UNDO.

DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_L FOR _L.

/* Parent frames to the desired parent (or to the current procedure). */
IF _U._TYPE eq "FRAME" THEN DO:
  FIND parent_U WHERE RECID(parent_U) = _U._parent-recid NO-ERROR.
  IF AVAILABLE parent_U THEN parent-hndl = parent_U._HANDLE.
  ELSE DO:
    IF VALID-HANDLE(_h_frame) THEN parent-hndl = _h_frame.
    ELSE parent-hndl = _h_win.
    FIND parent_U WHERE parent_U._handle = parent-hndl.
    _U._parent-recid = RECID(parent_U).
  END.
    
  /* Size-to-Parent:  If this is the first frame in a procedure that has
     NO WINDOW, then set the frame to SIZE-TO-PARENT. We don't need to
     check this if we already know it is a SIZE-TO-PARENT. */
  IF NOT _U._size-to-parent
     AND parent_U._TYPE eq "WINDOW":U AND parent_U._SUBTYPE eq "Design-Window":U 
  THEN DO: 
    /* Does the procedure have only one frame? */
    FIND _P WHERE _P._WINDOW-HANDLE eq _h_win NO-ERROR.     
    IF AVAILABLE _P AND _P._max-frame-count eq 1
    THEN _U._size-to-parent = yes.
  END.
  
  /* Note that size-to-parent frames are always set to the size of their
     parent. */
  IF _U._size-to-parent THEN DO:
    FIND parent_L WHERE RECID(parent_L) eq parent_U._lo-recid.
    ASSIGN _L._ROW = 1
           _L._COL = 1
           _L._WIDTH = parent_L._WIDTH
           _L._HEIGHT = parent_L._HEIGHT
           . 
  END.
  /* Note that the true parent is the FRAMES current-iteration, not the frame. */
  IF parent-hndl:TYPE = "FRAME" THEN parent-hndl = parent-hndl:FIRST-CHILD.
 
  FIND _frame_owner_tt WHERE _frame_owner_tt._child = _U._NAME NO-ERROR.
  IF AVAILABLE _frame_owner_tt THEN DO:  /* Have a reparenting record set parent-hdl */
    FIND parent_U WHERE parent_U._NAME          =  _frame_owner_tt._parent AND
                   CAN-DO("DIALOG-BOX,FRAME":U, parent_U._TYPE)       AND
                   parent_U._WINDOW-HANDLE =  _h_win                  AND
                   parent_U._STATUS        NE "DELETED":U             NO-ERROR.
    IF AVAILABLE parent_U THEN
      ASSIGN parent-hndl      = parent_U._HANDLE:FIRST-CHILD
             _U._parent-recid = RECID(parent_U).
    ELSE IF import_mode = "IMPORT":U THEN DO: /* pasting into another frame */
      IF _h_frame NE ? THEN DO:
        FIND parent_U WHERE parent_U._HANDLE = _h_frame.
        ASSIGN parent-hndl      = _h_frame:FIRST-CHILD
               _U._parent-recid = RECID(parent_U).  
      END.
    END.  /* Pasting a frame into another frame */
  END.  /* Have a reparenting record */
  
  /* Now create the frame.  Size-to-Fit frames are not directly resizable. */
  CREATE FRAME h_self
    ASSIGN SCROLLABLE      = _C._SCROLLABLE
           SIDE-LABELS     = _C._SIDE-LABELS
           BOX             = IF _L._NO-BOX NE ? THEN NOT _L._NO-BOX ELSE FALSE
           PARENT          = parent-hndl
           BOX-SELECTABLE  = TRUE
           SELECTABLE      = TRUE
           SELECTED        = FALSE
           OVERLAY         = TRUE
           RESIZABLE       = NOT _U._size-to-parent
           THREE-D         = _L._3-D
           MOVABLE         = NOT _U._size-to-parent
           SENSITIVE       = TRUE
           VISIBLE         = FALSE
           PRIVATE-DATA    = "{&UIB-Private}"
        TRIGGERS:
             {adeuib/framtrig.i}
        END TRIGGERS.
     
  IF NOT _U._LAYOUT-UNIT AND _WIDTH-P NE ? /* UNdoing */ THEN
    ASSIGN h_self:WIDTH-P        = _WIDTH-P
           h_self:HEIGHT-P       = _HEIGHT-P
           h_self:X              = _X
           h_self:Y              = _Y
           _L._WIDTH             = h_self:WIDTH / _cur_col_mult
           _L._HEIGHT            = h_self:HEIGHT / _cur_row_mult
           _L._COL               = ((h_self:COLUMN - 1) / _cur_col_mult) + 1
           _L._ROW               = ((h_self:ROW - 1) / _cur_row_mult) + 1.
  ELSE
    ASSIGN h_self:WIDTH          = _L._WIDTH * _cur_col_mult
           h_self:HEIGHT         = _L._HEIGHT * _cur_row_mult
           h_self:COLUMN         = MAX(1,(_L._COL - 1) * _cur_col_mult + 1)
           h_self:ROW            = MAX(1,(_L._ROW - 1) * _cur_row_mult + 1).

  IF _C._SCROLLABLE THEN
    ASSIGN h_self:VIRTUAL-WIDTH  = MAX(_L._VIRTUAL-WIDTH, _L._WIDTH)   * _cur_col_mult
           h_self:VIRTUAL-HEIGHT = MAX(_L._VIRTUAL-HEIGHT, _L._HEIGHT) * _cur_row_mult.


  CREATE RECTANGLE frame-bar
         ASSIGN FRAME       = h_self
                X           = 0
                Y           = IF _C._SIDE-LABELS THEN 0 ELSE 1
                HEIGHT-P    = 1
                WIDTH       = _L._WIDTH - (h_self:BORDER-LEFT + h_self:BORDER-RIGHT)
                BGCOLOR     = 0
                FGCOLOR     = 0
                FILLED      = TRUE
                EDGE-PIXELS = 1
                VISIBLE     = FALSE.
              
  IF _C._TITLE AND NOT _L._NO-BOX THEN DO:
    /* Show the title (modified for the string attributes) */
    RUN adeuib/_strfmt.p (_U._LABEL, _U._LABEL-ATTR, no, OUTPUT title_sa).
    ASSIGN h_self:TITLE         = title_sa
           h_self:TITLE-BGCOLOR = IF _L._WIN-TYPE THEN _L._TITLE-BGCOLOR
                                                  ELSE _tty_fgcolor
           h_self:TITLE-FGCOLOR = IF _L._WIN-TYPE THEN _L._TITLE-FGCOLOR
                                                  ELSE _tty_bgcolor.
  END.

  /* In TTY mode, set the title color equal to the background color */
  IF NOT _cur_win_type THEN DO:
    ASSIGN _L._BGCOLOR = ?
           _L._FGCOLOR = ?
           _L._FONT    = ?.
    IF NOT _L._NO-BOX THEN
      ASSIGN h_self:TITLE          = IF _C._TITLE THEN title_sa ELSE ""
             h_self:TITLE-BGCOLOR  = _tty_fgcolor               
             h_self:TITLE-FGCOLOR  = IF _C._TITLE THEN _tty_bgcolor
                                                  ELSE _tty_fgcolor.
  END.

  {adeuib/onframe.i  
    &_whFrameHandle = "parent_U._HANDLE"
    &_whObjHandle   = "h_self"
    &_lvHidden      = FALSE}
  
  ASSIGN _U._HANDLE            = h_self
         _C._BACKGROUND        = ?
         _C._CURRENT-ITERATION = h_self:CURRENT-ITERATION
         _C._FRAME-BAR         = frame-bar
         _U._SELECTEDib        = h_self:SELECTED  
         _U._PARENT            = h_self:PARENT
         _C._RETAIN            = h_self:NUM-TO-RETAIN
         _L._VIRTUAL-HEIGHT    = h_self:VIRTUAL-HEIGHT / _cur_row_mult
         _L._VIRTUAL-WIDTH     = h_self:VIRTUAL-WIDTH / _cur_col_mult
         _U._WINDOW-HANDLE     = _h_win
         _h_cur_widg           = h_self
         _h_frame              = h_self
         _L._3-D               = h_self:THREE-D.
END.

ELSE IF _U._TYPE = "DIALOG-BOX" THEN DO:
  IF NOT _U._LAYOUT-UNIT AND _WIDTH-P NE ? THEN
    ASSIGN _L._WIDTH    = _WIDTH-P / SESSION:PIXELS-PER-COLUMN
           _L._HEIGHT   = _HEIGHT-P / SESSION:PIXELS-PER-ROW.

  /* Always position dialog-boxes at the next best spot. Dialog-box coordinates
     are always relative to the parent window, so they are meaningless as a 
     position on the screen. */
  RUN adeuib/_windpos.p (OUTPUT _X, OUTPUT _Y).
  
  /* Create a window for the dialog-box. */
  CREATE WINDOW h_dlg_win
         ASSIGN PARENT         = _h_menu_win
                X              = _X
                Y              = _Y
                SHOW-IN-TASKBAR = FALSE
                MESSAGE-AREA   = FALSE
                STATUS-AREA    = FALSE
                SCROLL-BARS    = FALSE
                RESIZE         = YES
                SENSITIVE      = TRUE
                HIDDEN         = TRUE
                THREE-D        = _L._3-D
                TITLE          = _U._LABEL
             TRIGGERS:
                {adeuib/dialtrig.i &SECTION = WINDOW}
             END TRIGGERS.

  IF OEIDEIsRunning THEN
  DO:
    RUN displayWindow IN hOEIDEService ("com.openedge.pdt.oestudio.views.OEAppBuilderView", "DesignView_" + getProjectName(), h_dlg_win).
  END.

  ASSIGN
    h_dlg_win:HEIGHT         = _L._HEIGHT * _cur_row_mult
    h_dlg_win:WIDTH          = _L._WIDTH * _cur_col_mult
    h_dlg_win:VIRTUAL-WIDTH  = SESSION:WIDTH
    h_dlg_win:VIRTUAL-HEIGHT = SESSION:HEIGHT
    h_dlg_win:MAX-WIDTH      = SESSION:WIDTH
    h_dlg_win:MAX-HEIGHT     = SESSION:HEIGHT
    NO-ERROR.

  CREATE FRAME h_self
         ASSIGN PARENT             = h_dlg_win
                X                  = 0
                Y                  = 0
                SIDE-LABELS        = TRUE
                BOX                = FALSE
                THREE-D            = _L._3-D
                VISIBLE            = TRUE
                BOX-SELECTABLE     = TRUE
                OVERLAY            = TRUE
                SENSITIVE          = TRUE
                /* Dialog boxes act more like windows - they are not enabled
                   for direct manipulation.  We do not select them except by
                   making them the current widget */
                RESIZABLE          = FALSE
                SELECTABLE         = FALSE
                MOVABLE            = FALSE
                SCROLLABLE         = FALSE
                PRIVATE-DATA       = "{&UIB-Private}"
              TRIGGERS:
                   {adeuib/dialtrig.i &SECTION = FRAME}
              END TRIGGERS.
     
  ASSIGN 
    h_self:HEIGHT = h_dlg_win:HEIGHT
    h_self:WIDTH  = h_dlg_win:WIDTH
    NO-ERROR.
     
  /* Test the case where the dialog is off the screen.  Perhaps this is
     because the user built it on a different monitor. Ask if she would
     like to move it back on the screen. */
  IF h_dlg_win:X >= SESSION:WIDTH-P OR h_dlg_win:Y >= SESSION:HEIGHT-P OR
     h_dlg_win:X < 0 OR h_dlg_win:Y < 0 THEN DO:
    MESSAGE "The specified position of the dialog-box is off the screen."
            {&SKP}
            "Would you like repositioned?"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK-CANCEL UPDATE l_ok2move.
    IF l_ok2move           
    THEN ASSIGN
          h_dlg_win:X = MAX(0, (SESSION:WIDTH-P - h_dlg_win:WIDTH-P) / 2)
          h_dlg_win:Y = MAX(0, (SESSION:HEIGHT-P - h_dlg_win:HEIGHT-P) / 2).
  END. 

  /* In TTY mode, set the title color equal to the background color */
  IF NOT _cur_win_type THEN DO:
    ASSIGN _L._BGCOLOR = ?
           _L._FGCOLOR = ?
           _L._FONT    = ?.
  END.

  /* For the assignments: usually use defaults from CREATE FRAME (in h_self)   */
  /* Force defaults to not SIZABLE, BOX-SELECTABLE, SELECTABLE, SELECTED or    */
  /* MOVABLE.  Also force  VISIBLE and SENSITIVE.                              */
  ASSIGN _U._HANDLE              = h_self
         _L._COL-MULT            = _cur_col_mult
         _L._ROW-MULT            = _cur_row_mult
         _C._BACKGROUND          = ?
         _C._BOX-SELECTABLE      = FALSE
         _U._PARENT              = h_self:PARENT
         _C._CURRENT-ITERATION   = h_self:CURRENT-ITERATION
         _U._SELECTEDib          = h_self:SELECTED   /* internal copy selected */
         _L._COL                 = 1
         _L._ROW                 = 1
         _L._3-D                 = h_self:THREE-D
         _U._WINDOW-HANDLE       = h_self
         _h_frame                = h_self
         _h_cur_widg             = h_self
         _h_win                  = h_self
          .
     
  /* Do a standard UIB window title */
  RUN adeuib/_wintitl.p (h_dlg_win, _U._LABEL, _U._LABEL-ATTR, _save_file).

END.


/* Adjust Frame for TTY simulation. */
{ adeuib/ttysnap.i &hSELF   = h_self    
                   &hPARENT = parent_U._HANDLE
                   &U_Type  = _U._TYPE
                   &Mode    = "READ" }

/* Assign FONT and COLOR here, after widget creation.  */
ASSIGN h_self:FONT    = IF _L._WIN-TYPE THEN _L._FONT    ELSE _tty_font
       h_self:BGCOLOR = IF _L._WIN-TYPE THEN _L._BGCOLOR ELSE _tty_bgcolor
       h_self:FGCOLOR = IF _L._WIN-TYPE THEN _L._FGCOLOR ELSE _tty_fgcolor.

/* Now draw the grid (NOTE make sure it is not displayed until the end 
  (to prevent lots of redrawing).                                             */
IF _U._TYPE NE "BROWSE":U THEN DO:
  h_self:GRID-VISIBLE     = FALSE.
  IF NOT _cur_win_type 
  THEN ASSIGN h_self:GRID-SNAP              = TRUE
   	      h_self:GRID-UNIT-HEIGHT-CHAR  = _cur_row_mult 
              h_self:GRID-UNIT-WIDTH-CHAR   = _cur_col_mult.
  ELSE DO:
  h_self:GRID-SNAP = _cur_grid_snap.  
    IF _cur_layout_unit 
    THEN ASSIGN h_self:GRID-UNIT-HEIGHT-CHAR   = _cur_grid_hgt
                h_self:GRID-UNIT-WIDTH-CHAR    = _cur_grid_wdth. 
    ELSE ASSIGN h_self:GRID-UNIT-WIDTH-PIXELS  = _cur_grid_wdth
                h_self:GRID-UNIT-HEIGHT-PIXELS = _cur_grid_hgt.
  END.

  ASSIGN h_self:GRID-FACTOR-V  = _cur_grid_factor_v
         h_self:GRID-FACTOR-H  = _cur_grid_factor_h
         h_self:GRID-VISIBLE   = _cur_grid_visible.
END.  /* Set grid for frames and dialogs */

IF _U._parent-recid EQ ? THEN DO:
  /* Get the RECID of the parent window */
  FIND parent_U WHERE parent_U._HANDLE = _h_win.
  ASSIGN _U._PARENT-RECID = RECID(parent_U).
END.
ASSIGN _U._STATUS = "NORMAL".
