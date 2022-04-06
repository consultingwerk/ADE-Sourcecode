/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _winrsz.p
    
    Purpose:    Resize the Frame and Editor widgets of the Procedure Editor.

    Syntax :    RUN adeedit/_winrsz.p.

    Parameters: NONE.  Keys off of the p_Window parameter or SELF handle.
    
    Description:
        Resize Algorithm:
            1. If Window W or H grew, grow the Frame's W and H accordingly.
            2. Size the field-level editor widgets to the window LESS the
               Frame Border Widths.
            3. If Window W or H shrank, shrink the Frame's W and H accordingly.
    
    Notes  : Adapted from adecomm/_pwresz.p.
    
    Authors: John Palazzo
    Date   : July, 1993
    Updated: June, 1994 John Palazzo
**************************************************************************/

DEFINE INPUT PARAMETER p_Window AS WIDGET-HANDLE.

DEFINE VARIABLE h         AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h_frame   AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h_Focus   AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE Ret_Value AS LOGICAL       NO-UNDO.

IF p_Window:TYPE <> "WINDOW" 
THEN MESSAGE "Resize can only work on a window!" VIEW-AS ALERT-BOX ERROR.
ELSE DO:

  /* Assign handle of Editor Frame. */
  ASSIGN h_frame = p_Window:FIRST-CHILD.
  DO WHILE VALID-HANDLE( h_frame ) AND h_frame:TYPE <> "FRAME":U :
     ASSIGN h_frame = h_frame:NEXT-SIBLING.
  END.

  /* If no change in window size, return now. */
  IF h_frame:WIDTH-P = p_Window:WIDTH-P AND
     h_frame:HEIGHT-P = p_Window:HEIGHT-P THEN
      RETURN.
  
  /* Motif Only: Hide frame to avoid scrollbar painting. Save focus to restor
    later.
  */
  IF SESSION:WINDOW-SYSTEM = "OSF/Motif" THEN
  DO:
    ASSIGN h_Focus       = FOCUS
         h_frame:VISIBLE = FALSE.
  END.

  /* 1. If Window W or H grew, grow the Frame's W and H accordingly. */
  IF h_frame:WIDTH-P < p_Window:WIDTH-P THEN
      ASSIGN h_frame:WIDTH-P  = p_Window:WIDTH-P.
  IF h_frame:HEIGHT-P < p_Window:HEIGHT-P THEN
      ASSIGN h_frame:HEIGHT-P = p_Window:HEIGHT-P.
  
  /* 2. Size the field-level editor widgets to the window LESS the Frame
     Border Widths.
  */
  ASSIGN h = h_frame:FIRST-CHILD /* field-group   */
         h = h:FIRST-CHILD       /* editor widget */
         . /* END ASSIGN */

    DO WHILE ( h <> ? ) :
        ASSIGN h:WIDTH  = p_Window:WIDTH
                                        - ( h_frame:BORDER-LEFT + 
                                            h_frame:BORDER-RIGHT )
               h:HEIGHT = p_Window:HEIGHT
                                        - ( h_frame:BORDER-TOP + 
                                            h_frame:BORDER-BOTTOM )
               h = h:NEXT-SIBLING
        . /* END ASSIGN */
    END.

  /* 3. If Window W or H shrank, shrink the Frame's W and H accordingly. */
  IF h_frame:WIDTH-P > p_Window:WIDTH-P THEN 
      ASSIGN h_frame:WIDTH-P  = p_Window:WIDTH-P.
  IF h_frame:HEIGHT-P > p_Window:HEIGHT-P THEN
      ASSIGN h_frame:HEIGHT-P = p_Window:HEIGHT-P.

  /* Motif Only: Display frame to avoid scrollbar painting. Restore focus.
     We also need the MOVE-TO-TOP to keep the focus editor in the front
     of the frame.  This must be done AFTER the frame is made visible.
  */
  IF SESSION:WINDOW-SYSTEM = "OSF/Motif" THEN
  DO:
    ASSIGN h_frame:VISIBLE = TRUE 
           Ret_Value = h_Focus:MOVE-TO-TOP()
           NO-ERROR.
    /* Ensure the current Editor widget still has focus. */
    IF VALID-HANDLE( h_Focus) THEN
        APPLY "ENTRY" TO h_Focus.
  END.

END.
