/***********************************************************************
* Copyright (C) 2005-2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*----------------------------------------------------------------------------

File: _drwfill.p

Description:
    Draws a fill-in field.

Input Parameters:
   f_side_labels: TRUE if the parent frame uses side-labels. This is used
                  to decide the default alignment for the widget.

Output Parameters:
   <None>

Author: D. Ross Hunter,  Wm.T.Wood

Date Created: 1992 

----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER f_side_labels AS LOGICAL NO-UNDO.

{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}

/* -------------------------------------------------------------------- */
/*                          Local Variables                             */
/* -------------------------------------------------------------------- */
DEFINE VAR offset          AS INTEGER                           NO-UNDO.
DEFINE VAR cur-lo          AS CHARACTER                         NO-UNDO.

DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_L FOR _L.
DEFINE BUFFER x_U      FOR _U.

FIND _U WHERE _U._HANDLE = _h_win.
cur-lo = _U._LAYOUT-NAME.


/* Define the minimum size of a widget of this type.  If the user has asked  */
/* for a very-small space, use a default size of "FILL xx: ________"      */

&Scoped-define min-height-chars 0.2
&Scoped-define min-cols 0.4

/* Get the RECID of the parent frame */
FIND parent_U WHERE parent_U._HANDLE eq _h_frame.
FIND parent_L WHERE RECID(parent_L)  eq parent_U._lo-recid.

/* Create a Universal Widget Record and populate it as much as possible. */
CREATE _U.
CREATE _F.
CREATE _L.

ASSIGN /* TYPE-specific settings */
       _count[{&FILLN}]   = _count[{&FILLN}] + 1
       _U._NAME           = "FILL-IN-" + STRING(_COUNT[{&FILLN}])
       _U._TYPE           = "FILL-IN":U
       _F._DATA-TYPE	  = "Character":U
       _F._BLANK          = FALSE
       _F._DEBLANK        = FALSE
       /* Set the following as UNKNOWN -- If they are set in Custom Settings
          then we will know not to use our regular default values. */
       _F._FORMAT         = ?   
       _U._LABEL          = ?
       _L._NO-LABELS      = ?
       /* Standard Settings for Universal and Field records */
       { adeuib/std_uf.i &SECTION = "DRAW-SETUP" }
       .

/* If the user just clicked, then use default sizes.  Otherwise use the
   size drawn by the user.  NOTE: the Custom Section may override this. */
ASSIGN _L._WIDTH  = (_second_corner_x - _frmx + 1) /
                           SESSION:PIXELS-PER-COLUMN / _cur_col_mult
       _L._HEIGHT = (_second_corner_y - _frmy + 1) / 
                           SESSION:PIXELS-PER-ROW / _cur_row_mult.
/* Look out for minimum sizes */
IF (_L._WIDTH < {&min-cols}) 
THEN _L._WIDTH  = (IF _cur_win_type THEN 14 ELSE 10) * 
                  (IF parent_L._FONT = ? THEN 1 ELSE
                      (FONT-TABLE:GET-TEXT-WIDTH-CHARS("x",parent_L._FONT) /
                       FONT-TABLE:GET-TEXT-WIDTH-CHARS("x"))).
                       
/* If we are IN TTY MODE, then default to a one PPU height */
IF NOT _cur_win_type THEN _L._HEIGHT = 1.0.
ELSE DO:
  /* If the height is small, then default to the default height. */
  IF (_L._HEIGHT < {&min-height-chars}) THEN _L._HEIGHT = ?.
END.
 
/* Are there any custom widget overrides?                               */
IF _custom_draw ne ? THEN RUN adeuib/_usecust.p (_custom_draw, RECID(_U)).

/* Set the label (and the NO-LABELS attribute) */
IF _U._LABEL ne ? THEN DO:
  /* If the Custom Widget specified a LABEL, then assume they really want it. */
  IF _L._NO-LABELS eq ? THEN _L._NO-LABELS = NO.
END.
ELSE DO:
  /* Set Label based on default name.  Set NO-LABELS if this name is too
     long to fit. */
  _U._LABEL = "Fill " + STRING(_count[{&FILLN}]).
  IF _L._NO-LABELS eq ? THEN DO:
    ASSIGN offset = FONT-TABLE:GET-TEXT-WIDTH-P (_U._LABEL + ":", _h_frame:FONT) +
                    (2 * SESSION:PIXELS-PER-COLUMN)
           _L._NO-LABELS = (_frmx <= offset). /* Use NO-LABELS for a long name */
  END.
END.

/* Base the default format on the data-type, if it is still unknown. */
IF _F._FORMAT eq ? THEN DO: 
  /* Character is the only datatype we override -- other data-types get the
     default format from the fill-in. */
  IF _F._DATA-TYPE eq "Character":U THEN _F._FORMAT = "X(256)":U.
  IF NOT _L._WIN-TYPE THEN DO:
    CASE _F._DATA-TYPE:
      WHEN "DATE":U        THEN ASSIGN _F._FORMAT = "99/99/99".
      WHEN "DATETIME":U    THEN ASSIGN _F._FORMAT = "99/99/9999 HH:MM:SS.SSS".
      WHEN "DATETIME-TZ":U THEN ASSIGN _F._FORMAT = "99/99/9999 HH:MM:SS.SSS+HH:SS".
      WHEN "DECIMAL":U     THEN ASSIGN _F._FORMAT = "->>,>>9.99"
                                       _F._INITIAL-DATA = "0.00".
      WHEN "INTEGER":U OR WHEN "INT64":U
                           THEN ASSIGN _F._FORMAT = "->,>>>,>>9"
                                       _F._INITIAL-DATA = "0".
      WHEN "LOGICAL":U     THEN ASSIGN _F._FORMAT = "yes/no".
      WHEN "RECID":U       THEN ASSIGN _F._FORMAT = ">>>>>>>".
    END.
  END.
END.

/* For Logicals make sure that the INITIAL-DATA is either "no", "yes" or "?" */
IF _F._DATA-TYPE = "LOGICAL":U AND _F._INITIAL-DATA = "":U THEN
  _F._INITIAL-DATA = "no":U.

IF _widgetid_assign THEN
  _U._WIDGET-ID = DYNAMIC-FUNCTION("nextWidgetID":U IN _h_func_lib,
                                   INPUT RECID(PARENT_U),
                                   INPUT RECID(_U)).

/* Make a final check on the name */
IF CAN-FIND(FIRST x_U WHERE x_U._NAME = _U._NAME AND x_U._STATUS = "NORMAL":U)
  THEN RUN adeshar/_bstname.p (_U._NAME, ?, ?, ?, _h_win, OUTPUT _U._NAME).  

/* Create the widget based on the Universal widget record. */
RUN adeuib/_undfill.p (RECID(_U)).

/* FOR EACH layout other than the current layout, populate _L records for them */
{adeuib/multi_l.i}
