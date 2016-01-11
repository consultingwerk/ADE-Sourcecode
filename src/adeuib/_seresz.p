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
/**************************************************************************
    Procedure:  _seresz.p
    
    Purpose:    Resize the Frame and Editor widgets of a Section Editor
                Window.

    Syntax :    RUN adeuib/_seresz.p ( INPUT p_Window ).

    Parameters: p_Window   Section Editor window handle.
                           If not valid, routine uses SELF handle.
    
    Description:
        Resize Algorithm:
            1. If Window W grew, grow the Frame's W same as Window W.
            2. If Window H grew, then size the Frame's H using this         
               calculation:
               
                 Frame:HEIGHT = Window:HEIGHT - #Unusable-Rows
                 
                 ( #Unusable-Rows = Frame:ROW - 1 )
                 
               The #Unsable-Rows are the number of rows occupied by
               the Sections Radio-set, etc.

            3. Size the field-level editor widget to the window LESS the
               Frame Border Widths.  Note that the HEIGHT must take into
               account the rows occupied by the Section Radio-Set, etc..
               just like #2 abovr.
            4. If Window W or H shrank, we leave the Frame's W and H alone.
               We do this to avoid getting scrollbars on the frame.
    
    Notes  : Caller must pass a valid window widget-handle or the routine
             must be called from a window widget trigger.
    
    Authors: John Palazzo
    Date   : February, 1994
    Last   : July, 1995  Find h_frame via FIRST-CHILD of type FRAME.
**************************************************************************/

DEFINE INPUT PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE h       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h_frame AS WIDGET-HANDLE NO-UNDO.

IF NOT VALID-HANDLE( p_Window ) THEN ASSIGN p_Window = SELF.

IF p_Window:TYPE = "WINDOW":U THEN
DO:
  /* Assign handle of Editor Frame. */
  ASSIGN h_frame = p_Window:FIRST-CHILD.
  DO WHILE VALID-HANDLE( h_frame ) AND h_frame:TYPE <> "FRAME":U :
     ASSIGN h_frame = h_frame:NEXT-SIBLING.
  END.

  /* 1. If Window W or H grew, size the Frame's W and H accordingly. */
  IF h_frame:WIDTH-PIXELS < p_Window:WIDTH-PIXELS
    THEN h_frame:WIDTH-PIXELS  = p_Window:WIDTH-PIXELS.
  IF h_frame:HEIGHT-PIXELS < p_Window:HEIGHT-PIXELS
    THEN h_frame:HEIGHT = p_Window:HEIGHT - (h_frame:ROW - 1).
  
  /* 2. Size the field-level editor widget to the window LESS the Frame
     Border Widths.  Note that the HEIGHT must take into account the
     rows occupied by the Section Radio-Set, etc..
  */
  ASSIGN h = h_frame:FIRST-CHILD /* field-group   */
         h = h:FIRST-CHILD       /* first field widget */
         . /* ASSIGN */
  
  DO WHILE VALID-HANDLE( h ) :
    IF h:TYPE <> "EDITOR" THEN ASSIGN h = h:NEXT-SIBLING.
    ELSE LEAVE.
  END.
  ASSIGN h:WIDTH-PIXELS = p_Window:WIDTH-PIXELS
                                - ( h_frame:BORDER-LEFT-PIXELS + 
                                    h_frame:BORDER-RIGHT-PIXELS ) NO-ERROR.
                                       
  ASSIGN h:HEIGHT = MAXIMUM( 1 , p_Window:HEIGHT - (h:ROW - 1) -
                                 (( h_frame:BORDER-TOP + 
                                    h_frame:BORDER-BOTTOM)) ) NO-ERROR.
END.
