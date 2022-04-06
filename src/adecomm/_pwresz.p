/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _pwresz.p
    
    Purpose:    Resize the Frame and Editor widgets of a Procedure Window.

    Syntax :    RUN adecomm/_pwresz.p.

    Parameters: NONE.  Keys off of the SELF handle.
    
    Description:
        Resize Algorithm:
            1. If Window W or H grew, grow the Frame's W and H accordingly.
            2. Size the field-level editor widget to the window LESS the
               Frame Border Widths.
            3. If Window W or H shrank, shrink the Frame's W and H accordingly.
    
    Notes  : This procedure must be run as a PERSISTENT TRIGGER RUN.  If you
             run it when not in a trigger, the SELF handle will be invalid
             and you will receive a PROGRESS error message.
    
    Authors: Wm.T.Wood
    Date   : July, 1993
    Updated: January, 1994 John Palazzo
**************************************************************************/

DEFINE VARIABLE h       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h_frame AS WIDGET-HANDLE NO-UNDO.

IF SELF:TYPE <> "WINDOW" 
THEN MESSAGE "Resize can only work on a window!" VIEW-AS ALERT-BOX ERROR.
ELSE DO:

  /* Assign handle of Editor Frame. */
  ASSIGN h_frame = SELF:FIRST-CHILD.
    
  /* 1. If Window W or H grew, grow the Frame's W and H accordingly. */
  IF h_frame:WIDTH-P < SELF:WIDTH-P   THEN h_frame:WIDTH-P  = SELF:WIDTH-P.
  IF h_frame:HEIGHT-P < SELF:HEIGHT-P THEN h_frame:HEIGHT-P = SELF:HEIGHT-P.
  
  /* 2. Size the field-level editor widget to the window LESS the Frame
     Border Widths.
  */
  ASSIGN h = h_frame:FIRST-CHILD /* field-group   */
         h = h:FIRST-CHILD       /* editor widget */
         h:WIDTH-P  = SELF:WIDTH-P - ( h_frame:BORDER-LEFT + 
                                       h_frame:BORDER-RIGHT )
         h:HEIGHT-P = SELF:HEIGHT-P - ( h_frame:BORDER-TOP + 
                                        h_frame:BORDER-BOTTOM )
         .
  
  /* 3. If Window W or H shrank, shrink the Frame's W and H accordingly. */
  IF h_frame:WIDTH-P > SELF:WIDTH-P   THEN h_frame:WIDTH-P  = SELF:WIDTH-P.
  IF h_frame:HEIGHT-P > SELF:HEIGHT-P THEN h_frame:HEIGHT-P = SELF:HEIGHT-P.

END.
