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

File: _rszdial.p

Description:
    Resize a "dialog-box" in the UIB.  Remember that this DIALOG-BOX is really
    a window with a contained frame.  We want to allow the user to resize the
    dialog-box up to the screen size and down to the size of all the contained
    widgets.  
    
Input Parameters:
    <None>

Output Parameters:
   <None>

Author:  Wm.T.Wood

Date Created: December 20, 1992 

Modified: 
  07/14/94 wood    UIB Dialog size is now Inner-size (no border)

----------------------------------------------------------------------------*/

/* ===================================================================== */
/*                    SHARED VARIABLES Definitions                       */
/* ===================================================================== */
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}

DEFINE VAR h_dlg_frame   AS WIDGET-HANDLE NO-UNDO.
DEFINE VAR h_dlg_win     AS WIDGET-HANDLE NO-UNDO.
DEFINE VAR h             AS WIDGET-HANDLE NO-UNDO.
DEFINE VAR min_width_p   AS INTEGER       NO-UNDO.
DEFINE VAR min_height_p  AS INTEGER       NO-UNDO.


/* Assign the handles for the UIB's simulation of a dialog-box (a frame in
   a window) based on SELF (which is the window) */
ASSIGN h_dlg_win   = SELF			/* The window   */
       h_dlg_frame = SELF:FIRST-CHILD		/* The frame    */
       .

/* Find the Universal widget record */
FIND _U WHERE _U._HANDLE eq h_dlg_frame.
FIND _L WHERE RECID(_L) eq _U._lo-recid.
FIND _C WHERE RECID(_C) eq _U._x-recid.

/* If the dialog-box is expanding, we don't have to check anything.  If it is
   shrinking, then we need to check contained widgets. */
IF h_dlg_win:WIDTH-P  < h_dlg_frame:WIDTH-P OR h_dlg_win:HEIGHT-P < h_dlg_frame:HEIGHT-P
THEN DO:
  /* Compute the minimum size of the dialog box, based on contained widgets.  The
     minimum size (in pixels) is the equivalent of 1 PPU. */
  ASSIGN h            = h_dlg_frame:FIRST-CHILD	   /* Field Group  */
         h            = h:FIRST-CHILD              /* First widget */    
         min_width_p  = SESSION:PIXELS-PER-COL * _L._COL-MULT 
         min_height_p = SESSION:PIXELS-PER-ROW * _L._ROW-MULT
         .
  /* Loop through widgets */
  DO WHILE VALID-HANDLE(h):
    IF h:HIDDEN = FALSE THEN
      ASSIGN min_width_p  = MAX(min_width_p,  h:X + h:WIDTH-P)
             min_height_p = MAX(min_height_p, h:Y + h:HEIGHT-P).
    ASSIGN h = h:NEXT-SIBLING.
  END.
  /* Add in any borders on the frame we are using to simulate the dialog-box.
     Note that I expect the borders to be 0 because the h_dlg_frame should be
     NO-BOX.  However, some platforms (i.e. Motif) have non-zero right & 
     bottom borders in this case. */
  ASSIGN min_width_p = min_width_p + h_dlg_frame:BORDER-LEFT-P + h_dlg_frame:BORDER-RIGHT-P
         min_height_p = min_height_p + h_dlg_frame:BORDER-TOP-P + h_dlg_frame:BORDER-BOTTOM-P
         .  
  /* Don't let the window get smaller than this minimum */
  IF h_dlg_win:WIDTH-P  < min_width_p  THEN h_dlg_win:WIDTH-P  = min_width_p.
  IF h_dlg_win:HEIGHT-P < min_height_p THEN h_dlg_win:HEIGHT-P = min_height_p.
END.
/* Set the frame size equal the visible window size.  Store the value in the universal
   widget record.  (Remember to account for the run-time border size). */
ASSIGN h_dlg_frame:WIDTH-P     = h_dlg_win:WIDTH-P
       h_dlg_frame:HEIGHT-P    = h_dlg_win:HEIGHT-P
       _L._WIDTH               = h_dlg_frame:WIDTH  / _L._COL-MULT
       _L._HEIGHT              = h_dlg_frame:HEIGHT / _L._ROW-MULT
       .

                 
