/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _drwsele.p

Description:
    Draw a selection list in the current h_frame.

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter,  Wm.T.Wood

Date Created: 1992 

----------------------------------------------------------------------------*/
 
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}

DEFINE VAR cur-lo       AS CHARACTER                                  NO-UNDO.

DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_L FOR _L.
DEFINE BUFFER x_U      FOR _U.

FIND _U WHERE _U._HANDLE = _h_win.
cur-lo = _U._LAYOUT-NAME.


/* Define the minimum size of a widget of this type.  */
&Scoped-define min-height-chars 2
&Scoped-define min-cols 10

/* Get the RECID of the parent frame */
FIND parent_U WHERE parent_U._HANDLE = _h_frame.
FIND parent_L WHERE RECID(parent_L)  = parent_U._lo-recid.

/* Create a Universal Widget Record and populate it as much as possible. */
CREATE _U.
CREATE _L.
CREATE _F.

ASSIGN /* Type-specific settings */      
        _count[{&SELCT}] = _count[{&SELCT}] + 1
       _U._NAME             = "SELECT-" + STRING(_count[{&SELCT}])
       _U._TYPE             = "SELECTION-LIST":U
       _F._DATA-TYPE        = "Character":U
       _F._DRAG	            = TRUE
       _F._MULTIPLE	        = FALSE
       _L._NO-LABELS        = TRUE
       _F._SCROLLBAR-H      = FALSE  /* This is how we show editors...   */
       _U._SCROLLBAR-V      = TRUE   /* ...differently from select lists */
       /* Standard Settings for Universal and Field records */
       { adeuib/std_uf.i &SECTION = "DRAW-SETUP" }
       .

/* If the user just clicked, then use default sizes.  Otherwise use the
   size drawn by the user.  NOTE: the Custom Section may override this. */
IF (_second_corner_x eq _frmx) AND (_second_corner_y eq _frmy)
THEN ASSIGN _L._WIDTH  = {&min-cols} 
            _L._HEIGHT = {&min-height-chars}.
ELSE ASSIGN _L._WIDTH  = (_second_corner_x - _frmx + 1) /
                           SESSION:PIXELS-PER-COLUMN / _cur_col_mult
            _L._HEIGHT = (_second_corner_y - _frmy + 1) / 
                           SESSION:PIXELS-PER-ROW / _cur_row_mult.

/* Are there any custom widget overrides?                               */
IF _custom_draw ne ? THEN RUN adeuib/_usecust.p (_custom_draw, RECID(_U)).
/* Make a final check on the name */

IF _widgetid_assign THEN
  _U._WIDGET-ID = DYNAMIC-FUNCTION("nextWidgetID":U IN _h_func_lib,
                                   INPUT RECID(PARENT_U),
                                   INPUT RECID(_U)).

IF CAN-FIND(FIRST x_U WHERE x_U._NAME = _U._NAME AND x_U._STATUS = "NORMAL":U)
  THEN RUN adeshar/_bstname.p (_U._NAME, ?, ?, ?, _h_win, OUTPUT _U._NAME).  

/* Create the widget based on the Universal widget record. */
RUN adeuib/_undsele.p (RECID(_U)).

/* FOR EACH layout other than the current layout, populate _L records for them */
{adeuib/multi_l.i}
                           
