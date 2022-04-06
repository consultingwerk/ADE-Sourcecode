/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _pwchfnt.p
    
    Purpose:    Changes the font of all Procedure Windows with a specified
                font to a new specified font.

    Syntax :    RUN adecomm/_pwchfnt.p (INPUT p_Parent_ID ,
                                        INPUT p_Window    ,
                                        INPUT p_Old_Font  ,
                                        INPUT p_New_Font  ).

    Parameters:
        p_Parent_ID
            - String value indicating Parent of PW.  This can be any SESSION
              unique string, such as "UIB" or the string of the Parent window
              handle. It must be the same Parent Id used to open the PW.
        p_Window
            - Handle to a specific Procedure Window.  If passed, only its
              font is changed.  If not passed or invalid, all PW of the
              specified parent will have their font's changed.
              
    Description:
    Notes  :
    Authors: John Palazzo
    Date   : February, 1994
**************************************************************************/

/* Procedure Window Global Defines. */
{ adecomm/_pwglob.i }
  
DEFINE INPUT PARAMETER p_Parent_ID AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p_Window    AS WIDGET    NO-UNDO.
DEFINE INPUT PARAMETER p_Old_Font  AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER p_New_Font  AS INTEGER   NO-UNDO.

DEFINE VARIABLE pw_Window  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE pw_Editor  AS WIDGET-HANDLE NO-UNDO.

REPEAT ON STOP UNDO, LEAVE:
    /* Start with the session's first window. */
    ASSIGN pw_Window   = SESSION:FIRST-CHILD
           p_Parent_ID = ( IF p_Parent_ID = ? THEN "?" ELSE p_Parent_ID )
           .
    DO WHILE VALID-HANDLE( pw_Window ):
        /* Is this a Procedure Window and is it a "child window" of the
           Parent window passed? If Yes, change font.
        */
        IF pw_Window:NAME = {&PW_NAME}
           AND pw_WINDOW:PRIVATE-DATA = p_Parent_ID
        THEN DO:                                                           
            /* Get widget handle of Procedure Window editor widget. */
            RUN adecomm/_pwgeteh.p ( INPUT pw_Window , OUTPUT pw_Editor ).
            
            /* Change font if same as old font or if routine called
               for a specific window - then we always change the font.
            */
            IF    pw_Editor:FONT = p_Old_Font
               OR pw_Window = p_Window
            THEN ASSIGN pw_Editor:FONT = p_New_Font.
            /* Did we change the font of a specific PW? If yes, were are 
               done.
            */
            IF pw_Window = p_Window THEN LEAVE.
        END.
        ASSIGN pw_Window = pw_Window:NEXT-SIBLING.
    END.
    LEAVE.
END.
