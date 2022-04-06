/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _exphdr.p

Description:
   This procedure expands the header of a down frame when necessary.

Input Parameters:
   bar_move - The amount (in pixels) that frame-bar needs to move.
              (can be negative)

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1993

----------------------------------------------------------------------------*/
{adeuib/sharvars.i}
{adeuib/layout.i}
{adeuib/uniwidg.i}

DEFINE INPUT PARAMETER bar_move AS INTEGER                           NO-UNDO.

DEFINE VARIABLE tmp_hdl             AS WIDGET-HANDLE                 NO-UNDO.
  
DEFINE BUFFER f_U FOR _U.
DEFINE BUFFER w_U FOR _U.
DEFINE BUFFER w_L FOR _L.

  
FIND f_U WHERE f_U._HANDLE = _h_frame.
FIND _C WHERE RECID(_C) = f_U._x-recid.
  
ASSIGN _C._FRAME-BAR:VISIBLE = FALSE
       _C._FRAME-BAR:Y       = MAX(_C._FRAME-BAR:Y + bar_move,0)
       tmp_hdl               = _h_frame:FIRST-CHILD
       tmp_hdl               = tmp_hdl:FIRST-CHILD.

IF _C._FRAME-BAR:Y > 1 AND _C._FRAME-BAR:Y < SESSION:PIXELS-PER-ROW - 2 THEN
  ASSIGN bar_move        = bar_move + SESSION:PIXELS-PER-ROW - 2 - _C._FRAME-BAR:Y
         _C._FRAME-BAR:Y = SESSION:PIXELS-PER-ROW - 2.

DO WHILE tmp_hdl NE ?:
  IF tmp_hdl <>_C._FRAME-BAR THEN DO:  /* Don't move the bar again */
    FIND w_U WHERE w_U._HANDLE = tmp_hdl NO-ERROR.
    IF AVAILABLE w_U THEN DO:
      IF w_U._SUBTYPE = ? OR NOT CAN-DO("LABEL,POPUP-MENU,LABEL",w_U._SUBTYPE) THEN
      DO:
        FIND w_L WHERE RECID(w_L) = w_U._lo-recid.
        ASSIGN tmp_hdl:Y = tmp_hdl:Y + bar_move
               w_L._ROW  = ((tmp_hdl:ROW - 1) / _cur_row_mult) + 1
               w_L._COL  = ((tmp_hdl:COL - 1) / _cur_col_mult) + 1.        
        IF CAN-DO("FILL-IN,COMBO-BOX,EDITOR,SELECTION-LIST,RADIO-SET,SLIDER",tmp_hdl:TYPE) THEN
          RUN adeuib/_showlbl.p (tmp_hdl).
      END.
    END. /* IF AVAILABLE w_U */
  END.
  tmp_hdl = tmp_hdl:NEXT-SIBLING.
END.  /* DO WHILE still siblings */
_C._FRAME-BAR:VISIBLE = TRUE.
