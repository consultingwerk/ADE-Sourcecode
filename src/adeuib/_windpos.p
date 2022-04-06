/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-----------------------------------------------------------------------------

  File: _windpos.p

  Description: 
      Determines the next best location to position a window (or dialog-box)
      that isn't explicitly positioned.  We do this by starting at
       (_cur_win_x, _cur_win_y) and gradually changing the offset until
       we find a spot that is not occupied.
       
      We do not worry about positioning a window so that it runs off the
      bottom of the screen. [This is a constraint for people with small
      VGA screens.]
      
  Input Parameters:
     (none)
  
  Output Parameters:
     pi_X - The next X position
     pi_Y - The next Y position

  Author: Wm. T. Wood
  
  Created: July 1995
-----------------------------------------------------------------------------*/
/* Define Parameters. */
DEFINE OUTPUT PARAMETER  pi_X   AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER  pi_Y   AS INTEGER NO-UNDO.
  
/* Include Files */
{adeuib/uniwidg.i}        /* Definition of Universal Widget TEMP-TABLE  */
{adeuib/windvars.i}       /* Definition of Window shared variables      */
{adeuib/sharvars.i}       /* Standard shared variables                  */

DEFINE VAR x_offset AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VAR y_offset AS INTEGER INITIAL 0 NO-UNDO.

FOR EACH _U WHERE CAN-DO("WINDOW,DIALOG-BOX",_U._TYPE) BY
 IF _U._TYPE = "WINDOW" THEN _U._HANDLE:X ELSE _U._PARENT:X:
  IF (_U._TYPE = "WINDOW" AND
      _U._HANDLE:X = _cur_win_x + x_offset AND
      _U._HANDLE:Y = _cur_win_y + y_offset) OR
     (_U._TYPE = "DIALOG-BOX" AND
      _U._PARENT:X = _cur_win_x + x_offset AND
      _U._PARENT:Y = _cur_win_y + y_offset) THEN
    ASSIGN x_offset = x_offset + SESSION:PIXELS-PER-COLUMN
           y_offset = y_offset + SESSION:PIXELS-PER-ROW. 
END.

/* Stay on the screen */
if _cur_win_x + x_offset > (SESSION:WIDTH-PIXELS / 2) OR
   _cur_win_y + y_offset > (SESSION:HEIGHT-PIXELS / 2)
THEN ASSIGN y_offset = _h_menu_win:HEIGHT-PIXELS - _cur_win_y +
                        &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN 10
                        &ELSE (IF SESSION:HEIGHT-PIXELS /
                                          SESSION:HEIGHT-CHARS < 25
                              THEN 10 ELSE 10) &ENDIF
            x_offset = 0.

ASSIGN pi_X = _cur_win_x + x_offset
       pi_Y = _cur_win_y + y_offset
       pi_Y = _cur_win_y + y_offset
