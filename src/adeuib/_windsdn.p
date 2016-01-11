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
