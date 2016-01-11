/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* std_attr.i -  standard widget attributes                                 */
/* Inputs:                                                                  */
/*  NO-FONT       : If NOT defined, then set font.                          */
/*  MODE          : If "", then assume we are drawing on the frame.         */
/*                  Otherwise rebuild from _U and _F. Other value: "READ".  */
/*  NO-FRAME      : If defined, don't set the frame.                        */
/*  SIZE-CHAR     : If defined then set WIDTH/HEIGHT.                       */
/*  CONTROL-FRAME : If defined, don't set DesignMode control-frame          */
/*                  attributes. See _undcont.p for details.                 */
/*                                                                          */
/* Note setting FONT/COLOR to unknown in all cases. Otherwise we will       */
/* inherit the explicit frame FONT/COLOR.                                   */
    &IF DEFINED(no-frame) = 0 &THEN 
      FRAME = _F._FRAME
    &ENDIF 
    &IF "{&MODE}" ne "READ" &THEN
      ROW    = ((_L._ROW - 1) * _cur_row_mult) + 1
      COL    = ((_L._COL - 1) * _cur_col_mult) + 1
    &ENDIF
    &IF DEFINED(size-char) &THEN
      HEIGHT = _L._HEIGHT * _cur_row_mult
      WIDTH  = _L._WIDTH  * _cur_col_mult
    &ENDIF
    /* Standard attributes */
    FGCOLOR  = IF NOT _L._WIN-TYPE THEN _tty_fgcolor
               ELSE _L._FGCOLOR
    BGCOLOR  = IF NOT _L._WIN-TYPE THEN _tty_bgcolor ELSE _L._BGCOLOR
    &IF DEFINED(no-font) = 0 &THEN FONT = IF NOT _L._WIN-TYPE THEN _tty_font
                                          ELSE _L._FONT &ENDIF
    HELP         = ""    /* This blanks out the status line at design time */
    &IF DEFINED(control-frame) = 0 &THEN 
      SELECTABLE   = TRUE
      MOVABLE      = TRUE
      RESIZABLE    = TRUE
    &ENDIF
    SENSITIVE    = TRUE
    PRIVATE-DATA = "{&UIB-Private}"
