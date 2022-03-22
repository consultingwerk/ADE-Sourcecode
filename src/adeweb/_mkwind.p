/*********************************************************************
* Copyright (C) 2000,2013 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _mkwind.p

Description:
    Create a design window for structured WebSpeed 2.x Web object, similar 
    to a structured procedure template (ade/template/procedur.p).    
    Patterned after adeuib/_rdwind.p.

Input Parameters:
   p_pRECID - RECID of procedure record (to parent the window to).

Output Parameters:
   <None>

Author:  D.M.Adams
Created: February 1998

---------------------------------------------------------------------------- */

DEFINE INPUT PARAMETER p_pRECID AS RECID NO-UNDO.

{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/layout.i}       /* Layout temp-table definitions                     */
{adeuib/triggers.i}     /* Trigger TEMP-TABLE definition                     */
{adeuib/name-rec.i}     /* Name indirection table                            */
{adeuib/sharvars.i}     /* Shared variables                                  */
{adeuib/uibhlp.i}       /* Help file Context string definitions              */

DEFINE VARIABLE lOk        AS LOGICAL              NO-UNDO.
DEFINE VARIABLE _X         AS INTEGER   INITIAL ?  NO-UNDO.
DEFINE VARIABLE _Y         AS INTEGER   INITIAL ?  NO-UNDO.

FIND _P WHERE RECID(_P) eq p_pRECID.

CREATE _U.
CREATE _L.
CREATE _C.
CREATE _NAME-REC.

/* Note: A window name will never conflict with an existing name because no
   other names will exist. */
ASSIGN _C._SUPPRESS-WINDOW    = TRUE
       _U._SUBTYPE            = "Design-Window":U
       _L._WIN-TYPE           = _cur_win_type
       _L._COL-MULT           = IF _cur_win_type THEN 1 ELSE _tty_col_mult
       _L._ROW-MULT           = IF _cur_win_type THEN 1 ELSE _tty_row_mult
       _P._u-recid            = RECID(_U)
       _U._x-recid            = RECID(_C)
       _U._lo-recid           = RECID(_L)
       _L._LO-NAME            = "Master Layout":U
       _L._u-recid            = RECID(_U)
       _U._NAME               = "w-html":U
       _cur_col_mult          = _L._COL-MULT
       _cur_row_mult          = _L._ROW-MULT
       _C._KEEP-FRAME-Z-ORDER = FALSE
       _NAME-REC._wNAME       = _U._NAME
       _NAME-REC._wTYPE       = "WINDOW":U
       _NAME-REC._wRECID      = RECID(_U)
       _L._HEIGHT             = 15
       _L._WIDTH              = 60
       _U._LABEL              = _P._TYPE
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
       _L._BGCOLOR            = ?
  	   _L._FGCOLOR            = ?
       _L._VIRTUAL-HEIGHT     = _L._HEIGHT
       _L._VIRTUAL-WIDTH      = _L._WIDTH
       _L._FONT               = ?.

/* The TreeView OCX only exists on 32-bit Windows. On 64-bit we don't create
** the treeview. A window will be created for the object so the user can give
** this window focus and bring up the Section Editor to modify the procedure.
*/
IF PROCESS-ARCHITECTURE = 32 THEN
DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
  /* Create Treeview design window for code-only files. */
  DEFINE VAR h_TreeProc AS HANDLE NO-UNDO.
  RUN adeuib/_tview.w PERSISTENT SET h_TreeProc.
  RUN createTree IN h_TreeProc (RECID(_P)).
  ASSIGN _h_win = DYNAMIC-FUNCTION("getWinHandle" IN h_TreeProc).
END.

/* If not creating a Treeview window or something went wrong creating one, create
   simple style design window. */
IF NOT VALID-HANDLE(h_TreeProc) OR NOT VALID-HANDLE(_h_win) THEN DO:    
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
           SHOW-IN-TASKBAR   = FALSE
           KEEP-FRAME-Z-ORDER = TRUE
           TITLE             = _U._LABEL
         TRIGGERS:
           {adeuib/windtrig.i}
         END TRIGGERS.
END.

/* Size the window */
ASSIGN 
  _h_win:HEIGHT = _L._HEIGHT * _cur_row_mult
  _h_win:WIDTH  = _L._WIDTH * _cur_col_mult.

IF _L._VIRTUAL-WIDTH > 0    THEN
  ASSIGN _h_win:VIRTUAL-WIDTH    = _L._VIRTUAL-WIDTH * _cur_col_mult
         _h_win:MAX-WIDTH        = SESSION:WIDTH-CHARS.
IF _L._VIRTUAL-HEIGHT > 0   THEN    
  ASSIGN _h_win:VIRTUAL-HEIGHT   = _L._VIRTUAL-HEIGHT * _cur_row_mult
         _h_win:MAX-HEIGHT       = SESSION:HEIGHT-CHARS.

/* Set the window position. */
RUN adeuib/_windpos.p (OUTPUT _X, OUTPUT _Y).
ASSIGN 
  _h_win:X = _X
  _h_win:Y = _Y
  .

/* Test the case where the window is off the screen.  Perhaps this is
   because the user built it on a different monitor. Ask if she would like
   to move it back on the screen. */
IF _h_win:X >= SESSION:WIDTH-P OR _h_win:Y >= SESSION:HEIGHT-P OR
   _h_win:X < 0 OR _h_win:Y < 0 THEN DO:
  MESSAGE "The specified position of the window is off the screen." {&SKP}
          "Would you like it repositioned?"
          VIEW-AS ALERT-BOX WARNING BUTTONS OK-CANCEL UPDATE lOk.
  IF lOk THEN
    ASSIGN
      _h_win:X = MAX(0, (SESSION:WIDTH-P - _h_win:WIDTH-P) / 2)
      _h_win:Y = MAX(0, (SESSION:HEIGHT-P - _h_win:HEIGHT-P) / 2).
END.

/* Realize the window and synchronize remaining attributes                   */
ASSIGN _h_win:HIDDEN         = TRUE
       _h_win:SENSITIVE      = TRUE
       CURRENT-WINDOW        = _h_win
       _h_cur_widg           = _h_win
       _U._HANDLE            = _h_win
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
       .

/* Now load the title and file-name */
RUN adeuib/_wintitl.p (_h_win, _U._LABEL, _U._LABEL-ATTR, _P._SAVE-AS-FILE).

/* _mkwind.p - end of file */
