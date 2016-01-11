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

