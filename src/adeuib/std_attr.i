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
