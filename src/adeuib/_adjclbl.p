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

File: _adjclbl.p

Description:
    Adjust Column Labels for a frame.

Input Parameters:
    h_self : contains the handle for the frame being adjusted
    abort  : True if procedure should abort on an error (as opposed to adjusting)
    
Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1993

----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h_self        AS WIDGET-HANDLE                 NO-UNDO.
DEFINE INPUT PARAMETER abort         AS LOGICAL                       NO-UNDO.

{adeuib/uniwidg.i}              /* Universal widget definition                */
{adeuib/layout.i}               /* Layout temp-table definitions              */

DEFINE            VAR f_iter_pos      AS INTEGER                      NO-UNDO.
DEFINE            VAR row_mult        AS DECIMAL                      NO-UNDO.
DEFINE            VAR fg_h            AS WIDGET-HANDLE                NO-UNDO.
/* fg_h           is the handle of the frames field group.  Note: in the UIB  */
/*                all frames are dynamic and therefore single frames with     */
/*                only 1 field group.                                         */

DEFINE            VAR h_iteration     AS WIDGET-HANDLE                NO-UNDO.
/* h_iteration    is the handle of the rectangle that indicates the first     */
/*                iteration of a down frame                                   */
DEFINE            VAR tmp_hdl         AS WIDGET                       NO-UNDO.
DEFINE            VAR y-move          AS INTEGER                      NO-UNDO.
/* y-move         is how many pixels a field must move in converting from     */
/*                side-labels to column-labels or vice-versa                  */

DEFINE            VAR old_bar_pos     AS INTEGER                      NO-UNDO.
DEFINE VARIABLE _HEIGHT-P             AS INTEGER INITIAL ?.
DEFINE VARIABLE _Y                    AS INTEGER INITIAL ?.

/* old_bar_pos    the existing bar position (that might have to change).      */
DEFINE BUFFER x_U FOR _U.
DEFINE BUFFER x_L FOR _L.

/* FIND the Universal Widget Records for this widget                          */
FIND _U WHERE _U._HANDLE = h_self.
FIND _L WHERE RECID(_L) = _U._lo-recid.
FIND _C WHERE RECID(_C) = _U._x-recid.
    
ASSIGN fg_h        = h_self:FIRST-CHILD     /* This is the FIELD-GROUP        */
       tmp_hdl     = fg_h:FIRST-CHILD       /* This is the Field level widget */
       y-move      = -1
       f_iter_pos  = 0
       row_mult    = _L._ROW-MULT
       old_bar_pos = _C._FRAME-BAR:Y.

/* We are going from side-labels to column labels                             */
/*    - Find out how much to move things down and hide fill-in labels         */
/*    - Place bar                                                             */
/*    - Move widgets and show labels                                          */

/* Walk the widget chain to get placement of bar                              */
DO WHILE tmp_hdl <> ?:
  IF tmp_hdl NE _C._FRAME-BAR THEN DO:
    FIND x_U WHERE x_U._HANDLE = tmp_hdl NO-ERROR.
    IF AVAILABLE x_U THEN DO:
      ASSIGN _HEIGHT-P = x_U._HANDLE:HEIGHT-PIXELS
             _Y        = x_U._HANDLE:Y.
      IF CAN-DO("FILL-IN,COMBO-BOX",x_U._TYPE)
      THEN y-move = MAX(y-move, _Y + _HEIGHT-P
                         - old_bar_pos + 1 + (NUM-ENTRIES(x_U._LABEL,"!") - 1) *
                                      SESSION:PIXELS-PER-ROW * row_mult).
      f_iter_pos = MAX(f_iter_pos, _Y +  _HEIGHT-P - old_bar_pos - 2).
    END. /* Available x_U */
  END.  /* not the FRAME-BAR */
  tmp_hdl = tmp_hdl:NEXT-SIBLING.
END.  /* Have found the displacement */

IF f_iter_pos + y-move > h_self:VIRTUAL-HEIGHT-P THEN DO:
  IF abort THEN RETURN "WONT-FIT".
  ELSE DO:
    ASSIGN tmp_hdl = fg_h:FIRST-CHILD
           y-move  = (h_self:VIRTUAL-HEIGHT-P / 2) - 1
           f_iter_pos = y-move - 3.
    DO WHILE tmp_hdl <> ?:
      IF tmp_hdl:Y + tmp_hdl:HEIGHT-PIXELS > f_iter_pos THEN
         tmp_hdl:Y = f_iter_pos - tmp_hdl:HEIGHT-PIXELS.
      tmp_hdl = tmp_hdl:NEXT-SIBLING.
    END.
  END.
END.

ASSIGN tmp_hdl = fg_h:FIRST-CHILD    /* Get ready to walk chain again         */
       _C._FRAME-BAR:Y        = MAX(y-move - 2,0)
       _C._FRAME-BAR:WIDTH-P  = h_self:WIDTH-P -
                                (h_self:BORDER-LEFT-P + h_self:BORDER-RIGHT-P)
       f_iter_pos            = f_iter_pos + y-move 
       _C._ITERATION-POS      = f_iter_pos
       _C._FRAME-BAR:HEIGHT-P = 1
       _C._FRAME-BAR:BGCOLOR  = 0
       _C._FRAME-BAR:FGCOLOR  = 0
       _C._FRAME-BAR:FILLED   = TRUE
       _C._FRAME-BAR:VISIBLE  = IF _C._FRAME-BAR:Y > 0 AND NOT _L._NO-UNDERLINE
                                                       THEN TRUE
                                                       ELSE FALSE.

/* Bar is in Place . Now move the widgets and show the labels
   (if we moved the bar at all).                                            */
y-move = _C._FRAME-BAR:Y - old_bar_pos.
IF y-move ne 0 THEN DO:
  DO WHILE tmp_hdl <> ?:
    IF tmp_hdl NE _C._FRAME-BAR THEN DO:
      FIND x_U WHERE x_U._HANDLE = tmp_hdl NO-ERROR.
      IF AVAILABLE x_U THEN DO:
        IF x_U._SUBTYPE = ? OR NOT CAN-DO("LABEL,POPUP-MENU",x_U._SUBTYPE) THEN DO:
          FIND x_L WHERE RECID(x_L) = x_U._lo-recid.
          ASSIGN tmp_hdl:Y  = MAX(tmp_hdl:Y + y-move + 3, 0)
                 x_L._ROW   = ((tmp_hdl:ROW - 1) / row_mult) + 1.
        END.
        IF CAN-DO("FILL-IN,COMBO-BOX,EDITOR,SELECTION-LIST,RADIO-SET,SLIDER",tmp_hdl:TYPE) THEN
          RUN adeuib/_showlbl.p (tmp_hdl).
      END. /* IF AVAILABLE x_U */
    END.  /* Not the bar */
    tmp_hdl = tmp_hdl:NEXT-SIBLING.
  END.  /* DO WHILE */
END. 
RETURN "OK".
