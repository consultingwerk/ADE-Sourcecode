/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _pwwinst.p
    
    Purpose:    Sets the Window State of all Procedure Windows which are
                children of a specified Parent.

    Syntax :    
                RUN adecomm/_pwwinst.p (INPUT p_Parent_ID    ,
                                        INPUT p_Window_State ).

    Parameters:
        p_Parent_ID
            - String value indicating Parent of PW.  This can be any SESSION
              unique string, such as "UIB" or the string of the Parent window
              handle. It must be the same Parent Id used to open the PW.
    Description:
    Notes  :
    Authors: John Palazzo
    Date   : February, 1994
**************************************************************************/

/* Procedure Window Global Defines. */
{ adecomm/_pwglob.i }
  
DEFINE INPUT PARAMETER p_Parent_ID    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p_Window_State AS INTEGER   NO-UNDO.

DEFINE VARIABLE nxt       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE pw_Window AS WIDGET-HANDLE NO-UNDO.

/* proc-main */
DO ON STOP UNDO , LEAVE :
  
      ASSIGN nxt = DEFAULT-WINDOW.
      REPEAT WHILE nxt:PREV-SIBLING <> ?: 
          ASSIGN nxt = nxt:PREV-SIBLING.
      END.
     
      REPEAT WHILE nxt <> ?: 
          ASSIGN pw_Window = nxt
                 nxt         = nxt:NEXT-SIBLING
          . /* END ASSIGN */
          /* Is this a Procedure Window and is it a "child window" of the
             Parent window passed? If Yes, change state.
          */
          IF pw_Window:NAME = {&PW_NAME}
             AND pw_Window:PRIVATE-DATA = p_Parent_ID
          THEN DO:                                                           
            CASE p_Window_State:
                WHEN WINDOW-MINIMIZED
                    THEN 
                        ASSIGN pw_Window:WINDOW-STATE = WINDOW-MINIMIZED .
                
                OTHERWISE
                    DO:
                        /* Restore state only if minimized. */
                        IF ( pw_Window:WINDOW-STATE = WINDOW-MINIMIZED )
                        THEN ASSIGN pw_Window:WINDOW-STATE = p_Window_State .
                    END.
            END CASE.
          END. /* IF */
      END. /* REPEAT */
      
END. /* DO ON STOP */
