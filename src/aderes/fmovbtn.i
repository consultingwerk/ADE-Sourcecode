/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* fmovbtn.i */

/*-------------------------------------------------------------------
   Move_Buttons
  
   Input Parameters:
      p_hdl - the handle of some widget in the frame - either the
      	      first button or some widget before the buttons.
      p_row - the row where the first set of buttons will go
--------------------------------------------------------------------*/
PROCEDURE Move_Buttons:
  DEFINE INPUT PARAMETER p_hdl AS HANDLE   NO-UNDO. 
  DEFINE INPUT PARAMETER p_row AS DECIMAL  NO-UNDO.

  DEFINE VAR row1     AS DECIMAL NO-UNDO INIT 0. 
  DEFINE VAR this_row AS DECIMAL NO-UNDO.

  DO WHILE p_hdl <> ?:
    IF p_hdl:TYPE = "BUTTON" THEN DO:
      this_row = p_hdl:ROW. 
      /* To handle multiple button rows: */
      IF row1 = 0 THEN
        row1 = this_row.
      ELSE IF this_row > row1 THEN
        /* update for next row of buttons */
      	p_row = p_row + p_hdl:HEIGHT + {&ROW_GAP}. 
      IF this_row <> p_row THEN 
        p_hdl:ROW = p_row.
    END.
    p_hdl = p_hdl:NEXT-SIBLING.
  END.
END.

/* fmovbtn.i - end of file */ 

