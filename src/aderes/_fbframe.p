/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* _fbframe.p - Routine to adjust frame row and height for form and browse
       	        so that the frames don't overlap the toolbar or status bar.
      	        This will only be called when running in results environment.
*/

/*
   Input Parameters:
      p_frst - Is this the first frame (i.e., the parent frame)
      p_fhdl - the frame handle
      p_ix   - appropriate index into the qbf-frame temp table (for form
      	       vs. browse info).
*/

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/y-define.i }
{ aderes/fbdefine.i }
{ aderes/_fdefs.i }
{ aderes/s-menu.i }

DEFINE INPUT PARAMETER p_frst AS LOGICAL  NO-UNDO.
DEFINE INPUT PARAMETER p_fhdl AS HANDLE   NO-UNDO.
DEFINE INPUT PARAMETER p_ix   AS INTEGER  NO-UNDO.

DEFINE VARIABLE ttrow AS DECIMAL NO-UNDO.  /* row from temp tbl */
DEFINE VARIABLE frow  AS DECIMAL NO-UNDO.  /* row for frame */
DEFINE VARIABLE room  AS DECIMAL NO-UNDO.  /* useable vert ht in window */
DEFINE VARIABLE stat  AS LOGICAL NO-UNDO.  /* for function status */

/* Get form entry corresponding to current section */
FIND FIRST qbf-section WHERE qbf-section.qbf-shdl = p_fhdl.
FIND FIRST qbf-frame WHERE qbf-frame.qbf-ftbl = qbf-section.qbf-stbl NO-ERROR.

ASSIGN
  ttrow = (IF AVAILABLE qbf-frame THEN qbf-frame.qbf-frow[p_ix] ELSE 0)
  /* minimum row is row below the toolbar or 1 */
  frow = {&FB_MINROW}
  room = qbf-win:HEIGHT - (IF lGlbStatus THEN wGlbStatus:HEIGHT ELSE 0)
  .
IF ttrow = 0 THEN DO:
  /* user hasn't specified a row for the frame yet */
  IF p_frst THEN
    /* positions frame below toolbar */
    p_fhdl:ROW = frow. 
  ELSE
    ASSIGN
      /* positions 2nd frame at bottom of window */
      p_fhdl:ROW = MAXIMUM(frow, room - p_fhdl:HEIGHT + 1)
      .
END.

/* Reset the height if it overlaps the status bar. If frame starts below
   the status bar, just leave it alone.
*/   
if p_fhdl:ROW < room THEN
   p_fhdl:HEIGHT = {aderes/statchk.i &ht = p_fhdl:HEIGHT &row = p_fhdl:ROW}.
stat = wGlbStatus:MOVE-TO-TOP().

/* _fbframe.p - end of file */

