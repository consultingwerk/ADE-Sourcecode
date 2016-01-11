/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* b-store.p - Stores the handle of the browse frame for a certain section
      	       and do other fixup specific to running in results environment.

   Input Parameters:
      p_name  - name of browse frame
      p_hdl   - handle of the browse frame
      p_first - first browse frame? (parent)
*/

{ aderes/s-define.i }
{ aderes/fbdefine.i } 

DEFINE INPUT PARAMETER p_first AS LOGICAL   NO-UNDO.
DEFINE INPUT PARAMETER p_name  AS CHARACTER NO-UNDO. 
DEFINE INPUT PARAMETER p_hdl   AS HANDLE    NO-UNDO.

FIND FIRST qbf-section WHERE qbf-sfrm = p_name.
qbf-section.qbf-shdl = p_hdl.

/* Make the frame scrollable so we have the freedom to resize it
   larger than then window and to change its virtual height.
   The scrollbars will only come up if they're needed as long as we keep
   the height and the virtual height the same when the frame fits.
*/
p_hdl:SCROLLABLE = yes.

/* Make sure frame doesn't overlap toolbar or status bar. */
RUN aderes/_fbframe.p (p_first, p_hdl, {&B_IX}).

/* b-store.p - end of file */

