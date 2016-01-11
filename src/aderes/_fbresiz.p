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
/*
 * _fbresiz.p - Code to vertically resize and possibly reposition a form or 
      	        browse frame because user changed the frame properties or 
      	        because user resized the Results window.

   Input Parameter:
      p_row   - the row we want the frame at
      p_frame - the frame's handle

   Returns:
      "in"  if frame row starts in visible window area
      "out" if frame row starts beyond visible window area
*/ 

{ aderes/s-system.i }
{ aderes/y-define.i }

DEFINE INPUT PARAMETER p_row   AS DECIMAL  NO-UNDO.
DEFINE INPUT PARAMETER p_frame AS HANDLE   NO-UNDO.

DEFINE VAR ht     AS DECIMAL NO-UNDO. /* frame height */
DEFINE VAR vht    AS DECIMAL NO-UNDO. /* frame virtual height */
DEFINE VAR room   AS DECIMAL NO-UNDO. /* vertical room for frame*/
DEFINE VAR beyond AS LOGICAL NO-UNDO. /* is frame beyond window boundary? */
DEFINE VAR stat   AS LOGICAL NO-UNDO.
DEFINE VAR btmrow AS DECIMAL NO-UNDO. /* bottom row in the window */

/* See if frame will start below visible area of window.  If it does
   we may still need to adjust it's height to fit within the virtual  
   height of the window.
*/
ASSIGN
  btmrow = qbf-win:HEIGHT - (IF lGlbStatus THEN wGlbStatus:HEIGHT ELSE 0)
  beyond = (p_row >= btmrow).

ASSIGN
  room = (IF beyond THEN qbf-win:VIRTUAL-HEIGHT - (p_row - 1)
     	      	     ELSE qbf-win:HEIGHT - (p_row - 1)) 
  ht = p_frame:HEIGHT
  vht = p_frame:VIRTUAL-HEIGHT.

IF vht > room THEN DO:
  /* Shrink the actual height to fit.  Order depends on if row is
     getting bigger or smaller.
  */
  IF p_row > p_frame:ROW THEN
    ASSIGN 
      p_frame:HEIGHT = (IF beyond THEN ht ELSE
               	     	{aderes/statchk.i &ht = room &row = p_row})
      p_frame:ROW = p_row.
  ELSE
    ASSIGN 
      p_frame:ROW = p_row
      p_frame:HEIGHT = (IF beyond THEN ht ELSE
               	     	{aderes/statchk.i &ht = room &row = p_row}).
END.
ELSE IF ht < room AND ht < vht THEN
  /* grow to fill the space up to desired size. Set row first */
  ASSIGN
    p_frame:ROW = p_row
    p_frame:HEIGHT = (IF beyond THEN MIN(room, vht) ELSE
       	       	      {aderes/statchk.i &ht = "MIN(room, vht)" &row = p_row}).
ELSE
  /* The height reset here is to insure frame doesn't overlap
     the status bar.  If it won't, the height will remain ht value.
  */
  ASSIGN
    p_frame:ROW = p_row
    p_frame:HEIGHT = (IF beyond THEN ht ELSE
      	       	      {aderes/statchk.i &ht = ht &row = p_row}).

stat = wGlbStatus:MOVE-TO-TOP().

IF beyond THEN 
  RETURN "out".
ELSE
  RETURN "in".

/* _fbresiz.p - end of file */

