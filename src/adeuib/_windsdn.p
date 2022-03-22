/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _windsdn.p

Description:
    Trigger for MOUSE-SELECT-DOWN in the shadow frame of a window.

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter,  Wm.T.Wood

Date Created: 1992 

----------------------------------------------------------------------------*/
{adeuib/sharvars.i} 

DEFINE VAR ok                  AS LOGICAL                            NO-UNDO.

/* Cursors for beginning to draw an widget, and to end it */
&SCOPED-DEFINE end_draw_cursor   "SIZE-SE"

/* On "DOWN" set the upper left corner for the draw. */
IF _next_draw ne ? THEN DO:
  ASSIGN _frmx              = LAST-EVENT:X
         _frmy              = LAST-EVENT:Y
         _second_corner_x   = ?
         _second_corner_y   = ?
         .
  /* Change the pointer if we are drawing FRAMES, which can be resized.  Otherwise
     leave the cursor alone. */
  IF (_next_draw eq "FRAME":U) THEN ok = SELF:LOAD-MOUSE-POINTER({&end_draw_cursor}).
END.
