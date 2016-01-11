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

/* f-motion.p - END-MOVE trigger code for moving things around in forms view.

      SELF is the handle of the widget in the main form frame which was
      	 just moved by the user.
*/

{ aderes/s-system.i }
{ aderes/y-define.i }
{ aderes/s-define.i }
{ aderes/fbdefine.i }

DEFINE VARIABLE hlbl	 AS HANDLE   NO-UNDO. /* side label handle */
DEFINE VARIABLE hlbl2	 AS HANDLE   NO-UNDO. 
DEFINE VARIABLE lblcol	 AS DECIMAL  NO-UNDO. /* label column */
DEFINE VARIABLE lblwid	 AS DECIMAL  NO-UNDO. /* label width */
DEFINE VARIABLE min_brow AS DECIMAL  NO-UNDO. /* minimum button row */
DEFINE VARIABLE max_brow AS DECIMAL  NO-UNDO. /* maximum button row */
DEFINE VARIABLE ix	 AS INTEGER  NO-UNDO. /* generic index */
DEFINE VARIABLE rowht	 AS DECIMAL  NO-UNDO.
DEFINE VARIABLE hframe	 AS HANDLE   NO-UNDO. /* frame handle */
DEFINE VARIABLE widg	 AS HANDLE   NO-UNDO. /* generic widget handle */
DEFINE VARIABLE stat  AS LOGICAL NO-UNDO. /* scrap logical */

/*=========================Internal Procedures=======================*/

/* PROCEDURE Move_Buttons */
{ aderes/fmovbtn.i } 

/*-----------------------------------------------------------------
   See if the buttons need to be moved up or down and 
   correspondingly if the frame needs to be enlarged or shrunk.

   Input Parameters: 
      p_hdl - handle of the widget just moved or the corresponding
      	      widget in one of the form dialog boxes.
-----------------------------------------------------------------*/
PROCEDURE Frame_Adjust:
   DEFINE INPUT PARAMETER p_hdl AS HANDLE NO-UNDO.

   DEFINE VARIABLE ht     AS DECIMAL       NO-UNDO. /* new frame height */
   DEFINE VARIABLE main   AS LOGICAL       NO-UNDO. /* main frame? */

   ASSIGN
     main   = (IF p_hdl = SELF THEN yes ELSE no) 
     hframe = p_hdl:FRAME
     widg   = p_hdl:NEXT-SIBLING.  /* we know the buttons come after any flds */

   DO WHILE widg <> ?:
      IF widg:TYPE = "BUTTON" THEN DO:
      	 IF widg:ROW < min_brow THEN DO: /* buttons need to be moved down */
   	     /* First we have to make the frame longer by the amount this
   	        button will move down.
   	     */
          ASSIGN
   	       ht = hframe:VIRTUAL-HEIGHT + (min_brow - widg:ROW)
   	       hframe:HEIGHT = 
   	         (IF main 
                 THEN {aderes/statchk.i &ht = ht &row = hframe:ROW}
         	      ELSE MINIMUM(ht,SESSION:HEIGHT))
   	       hframe:VIRTUAL-HEIGHT = ht.
   
          RUN Move_Buttons (widg, min_brow).
        END.
      	 ELSE IF widg:ROW > max_brow THEN DO: /* buttons need to be moved up */
      	   /* move the buttons first - then shrink the frame */
	       ht = hframe:VIRTUAL-HEIGHT - (widg:ROW - max_brow).

	       RUN Move_Buttons (widg, max_brow).
          ASSIGN	
            hframe:HEIGHT = 
              (IF main 
                THEN {aderes/statchk.i &ht = ht &row = hframe:ROW}
                ELSE MINIMUM(ht,SESSION:HEIGHT)).
	         hframe:VIRTUAL-HEIGHT = ht.
      	 END.
        LEAVE.	/* we've either moved all buttons or they don't need moving */
      END.
      widg = widg:NEXT-SIBLING.
   END.
END.

/*============================Mainline Code==========================*/

/* Enforce the row limit of MAX-FORM-ROW - see comment in fbdefine.i.
   Remember, we have to extrapolate back and forth between real row and
   what the user thinks the row is.
*/   
rowht = qbf-fillht + {&ROW_GAP}.
IF (INTEGER((SELF:ROW - 1) / rowht) * qbf-fillht) + 1 > {&MAX-FORM-ROW} 
THEN DO:
  RUN adecomm/_s-alert.p (INPUT-OUTPUT stat, "warning":u, "ok":u, 
    SUBSTITUTE("You cannot move a field below row &1.", {&MAX-FORM-ROW})).
  SELF:ROW = (INTEGER(({&MAX-FORM-ROW} - 1) / qbf-fillht) * rowht) + 1.
END.

/* Move the label to the left of the field. Make sure there's 
   enough room for it.
*/
hlbl = SELF:SIDE-LABEL-HANDLE NO-ERROR. /* there may be no label */
IF hlbl <> ? THEN DO:
  ASSIGN
    hlbl:ROW = SELF:ROW
    lblwid   = hlbl:WIDTH.  /* this includes the colon and space */
  lblcol = SELF:COL - lblwid.
  IF lblcol < 1 THEN 
    /* doesn't fit - position so label starts at column 1 */
    ASSIGN
      hlbl:COL = 1
      SELF:COL = lblwid + 1.
  ELSE
    hlbl:COL = lblcol.
END.

FIND qbf-fwid WHERE qbf-fwmain = SELF.

/* See if the buttons need to be moved up or down and the frame resized.
   If the widget moved is now at the highest row - the buttons may have
   to be moved down.  If the widget moved, leaves another widget at the
   highest row then that widget determines how far the buttons can be
   moved up.
   ***CAUTION - if we ever support view-as phrase, this needs adjustment 
   since widget height needs to be taken into account, not just the row
   and we can't assume SELF:HEIGHT is the same as the last widget's height.
*/
ASSIGN 
  min_brow = SELF:ROW + SELF:HEIGHT + .5 + {&ROW_GAP} /* min row for buttons */
  hframe   = SELF:FRAME
  widg     = hframe:FIRST-CHILD  /* group */
  widg     = widg:FIRST-CHILD.   /* field level widget */
  
DO WHILE widg <> ? AND widg:TYPE <> "BUTTON":
  ASSIGN 
    max_brow = MAXIMUM(max_brow, widg:ROW)
    widg     = widg:NEXT-SIBLING.
END.
max_brow = max_brow + SELF:HEIGHT + .5 + {&ROW_GAP}. /* max row for buttons */

RUN Frame_Adjust (SELF).
RUN Frame_Adjust (qbf-fwid.qbf-fwqbe).
IF qbf-fwid.qbf-fwdlg <> ? THEN
  RUN Frame_Adjust (qbf-fwid.qbf-fwdlg).

/* Change the row/col in the corresponding qbf-rcx arrays. Also, 
   update the row/col of the corresponding widget in the update and 
   qbe dialogs.
*/
ASSIGN
   ix = qbf-fwid.qbf-fwix
   /* The values stored are w/o extra row gap (Windows). So extrapolate 
      back to that from current position. This should work for Motif too.
   */
   ENTRY({&F_ROW}, qbf-rcp[ix]) = 
      (IF SELF:ROW = 1 
      	 THEN "1" 
      	 ELSE {aderes/numtoa.i 
      	       &num="(INTEGER((SELF:ROW - 1) / rowht) * qbf-fillht) + 1"}
      )
   ENTRY({&F_COL}, qbf-rcp[ix]) = 
      (IF hlbl = ? 
      	 THEN {aderes/numtoa.i &num="SELF:COL"}  
      	 ELSE {aderes/numtoa.i &num="hlbl:COL"})
   qbf-fwid.qbf-fwqbe:ROW = SELF:ROW
   qbf-fwid.qbf-fwqbe:COL = SELF:COL.

/* query-by-example dialog box */
hlbl2 = qbf-fwid.qbf-fwqbe:SIDE-LABEL-HANDLE NO-ERROR.
IF hlbl2 <> ? THEN DO:
  ASSIGN   
    hlbl2:ROW = hlbl:ROW
    hlbl2:COL = hlbl:COL.
  ASSIGN hlbl2:COL = hlbl:COL. /* keep for bug 95-02-13-047 */
END.

/* add-update-copy dialog box */
IF qbf-fwid.qbf-fwdlg <> ? THEN DO:
  ASSIGN
     qbf-fwid.qbf-fwdlg:ROW = SELF:ROW
     qbf-fwid.qbf-fwdlg:COL = SELF:COL	  
     hlbl2 = ?.

  hlbl2 = qbf-fwid.qbf-fwdlg:SIDE-LABEL-HANDLE NO-ERROR.
  IF hlbl2 <> ? THEN DO:
     ASSIGN
       hlbl2:ROW = hlbl:ROW
       hlbl2:COL = hlbl:COL.
     ASSIGN hlbl2:COL = hlbl:COL. /* keep for bug 95-02-13-047 */
  END.
END.

qbf-dirty = yes.

/* f-motion.p - end of file */

