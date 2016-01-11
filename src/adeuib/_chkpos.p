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

File: _chkpos.p

Description:
   This procedure checks the position of a widget immeadiately after a
   move or resize of a field level widget when column-labels are in effect
   for the purpose of  proper resizing of the frame header and iteration.

Input Parameters:
   h_self  - The widget whose position is  to be checked.

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1993

----------------------------------------------------------------------------*/
{adeuib/sharvars.i}
{adeuib/uniwidg.i}
{adeuib/layout.i}

DEFINE INPUT PARAMETER h_self       AS WIDGET-HANDLE              NO-UNDO.
/* h_self is the handle of the widget that got moved or resized             */
  
DEFINE VARIABLE bar_move            AS INTEGER                    NO-UNDO.
DEFINE VARIABLE iter_expand         AS INTEGER                    NO-UNDO.
DEFINE VARIABLE f_bar_pos           AS INTEGER                    NO-UNDO.
DEFINE VARIABLE f_iter_pos          AS INTEGER                    NO-UNDO.
DEFINE VARIABLE lbl                 AS CHAR                       NO-UNDO.
DEFINE VARIABLE lbl_ext             AS INTEGER                    NO-UNDO.
DEFINE VARIABLE shrink              AS INTEGER                    NO-UNDO.
DEFINE VARIABLE tallest             AS INTEGER                    NO-UNDO.
DEFINE VARIABLE tmp_hdl             AS WIDGET-HANDLE              NO-UNDO.
DEFINE VARIABLE widg_pos            AS INTEGER                    NO-UNDO.
  
DEFINE BUFFER f_U FOR _U.
DEFINE BUFFER w_U FOR _U.
DEFINE BUFFER w_L FOR _L.

/* Find the widget record and the frame record.                            */
FIND w_U WHERE w_U._HANDLE = h_self.
FIND w_L WHERE RECID(w_L) = w_U._lo-recid.
FIND f_U WHERE f_U._HANDLE = h_self:FRAME.
FIND _C WHERE RECID(_C) = f_U._x-recid.

/* Get some frame information */
ASSIGN f_bar_pos  = _C._FRAME-BAR:Y
       f_iter_pos = _C._ITERATION-POS
       _h_frame   = f_U._HANDLE.
       
/* Make sure object is not in the header                                   */
IF h_self:Y < f_bar_pos + 2 THEN h_self:Y = f_bar_pos + 2.

/* Determine how much to expand iteration                                  */
iter_expand = 0.
IF h_self:Y + h_self:HEIGHT-P > f_iter_pos THEN
  iter_expand = h_self:Y + h_self:HEIGHT-P - f_iter_pos - 1.

IF iter_expand = 0 THEN DO:
  /* See if iter has shrunk */
  ASSIGN shrink  = -999999
         tmp_hdl = _h_frame:FIRST-CHILD
         tmp_hdl = tmp_hdl:FIRST-CHILD.
  DO WHILE tmp_hdl NE ?:
    ASSIGN shrink  = MAX(shrink, tmp_hdl:Y + tmp_hdl:HEIGHT-P - f_iter_pos)
           tmp_hdl = tmp_hdl:NEXT-SIBLING.
  END.
  IF shrink <> -999999 AND shrink < 0 THEN iter_expand = shrink.
END.

/* Determine how much to move the bar (increase header size)                        */
bar_move = 0.
IF CAN-DO("FILL-IN,COMBO-BOX",h_self:TYPE) THEN DO:  /* only necessary for fill-ins
                                                        or combo-boxes              */
  FIND _F WHERE RECID(_F) = w_U._x-recid.
  IF NOT w_L._NO-LABELS THEN DO:  
    /* Only fill-ins with labels effect header size - compute the label
       accounting for string attributes and source (ie. default label on
       variables is the name */
    IF (w_U._LABEL-SOURCE = "D") AND (w_U._TABLE EQ ?) THEN lbl = w_U._NAME.
    ELSE IF w_U._LABEL-ATTR EQ ""                      THEN lbl = w_U._LABEL.
    ELSE RUN adeuib/_strfmt.p 
               (w_U._LABEL,
                w_U._LABEL-ATTR,
                CAN-DO("INTEGER,DECIMAL",_F._DATA-TYPE),
                OUTPUT lbl).
    ASSIGN lbl_ext  = (NUM-ENTRIES(lbl,"!") - 1) *
                       SESSION:PIXELS-PER-ROW * w_L._ROW-MULT
           widg_pos = f_iter_pos + iter_expand - h_self:HEIGHT-P - 2.
    IF f_bar_pos - widg_pos - lbl_ext < 0 
      THEN bar_move = MIN(widg_pos + lbl_ext - f_bar_pos, iter_expand).
  END.  /* IF the label might be in the way */
END.  /* Only fill-ins effect the header */

IF iter_expand = 0 AND bar_move = 0 THEN  /* Everthing is fine               */
  RETURN " ".

/* See if frame is big enough                                                */
IF _h_frame:VIRTUAL-HEIGHT-P <= f_iter_pos + bar_move + iter_expand THEN DO:
  /* We have a problem                                                       */
  MESSAGE "Unable to fit the label of fill-in" w_U._NAME SKIP
          "into the frame header.  Resize the frame to be taller and" SKIP
          "try again." VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  ASSIGN h_self:COL = w_L._COL
         h_self:ROW = w_L._ROW.
  RETURN "NO-ROOM".
END.

/* Adjust the position of the iteration */
ASSIGN f_iter_pos            = f_iter_pos + bar_move + iter_expand
       _C._ITERATION-POS      = f_iter_pos.

RUN adeuib/_exphdr.p (INPUT bar_move).
  
/* Now iteration is fine, but may have excess space above the labels.  Therefore
   find the "tallest" label and move the bar up enough so that the label touches
   the ceiling.                                                                  */
ASSIGN tallest = f_bar_pos
       tmp_hdl = _h_frame:FIRST-CHILD
       tmp_hdl = tmp_hdl:FIRST-CHILD.
DO WHILE tmp_hdl NE ?:
  ASSIGN tallest = IF tmp_hdl:VISIBLE THEN MIN(tallest, tmp_hdl:Y) ELSE tallest
         tmp_hdl = tmp_hdl:NEXT-SIBLING.
END.

IF tallest > 0 THEN DO:
  /* There is some space between the tallest label and the top of the frame,     */
  /* If the tallest label is shorter than a standard iteration then adjust the   */
  /* tallest variable to be equal to an iteration height.                        */
  tallest = MIN(tallest,f_bar_pos - (f_iter_pos - f_bar_pos)).
  IF tallest > 0 THEN DO:
    /* Adjust the position of the iteration */
   _C._ITERATION-POS = f_iter_pos - tallest.
    RUN adeuib/_exphdr.p (INPUT 0 - tallest).
  END.
END.
  
RETURN " ".
