/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure :  _pwgetwh.p
    
    Purpose   : Returns the Window handle for any widget.
                
    Syntax    : RUN adecomm/_pwgetwh.p ( INPUT p_Widget , OUTPUT p_Window ).
    
    Parmameters :
    Description:
    Notes     : If the widget is an invalid widget or a pseudo-widget,
                routine returns Unknown (?) for p_Window.
                                
    Authors   : J. Palazzo
**************************************************************************/
              
DEFINE INPUT  PARAMETER p_Widget AS WIDGET-HANDLE NO-UNDO.
    /* Handle of widget whose window handle you want. */
DEFINE OUTPUT PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO.
    /* Handle of widget's window. */

DO:
    ASSIGN p_Window = ? .
    
    /* Handle exceptions... */
    IF NOT VALID-HANDLE( p_Widget ) OR ( p_Widget:TYPE = "PSEUDO-WIDGET" )
    THEN RETURN.
    
    /* Take care of menus, submenus, and menu items. */
    IF CAN-QUERY( p_Widget , "WINDOW" )
    THEN DO:
        ASSIGN p_Window = p_Widget:WINDOW .
        RETURN.
    END.
    
    CASE p_Widget:TYPE :
    
        WHEN "WINDOW"
            THEN ASSIGN p_Window = p_Widget.
            
        WHEN "FRAME"
            THEN ASSIGN p_Window = p_Widget:PARENT.
            
        WHEN "FIELD-GROUP"
            THEN DO:
                ASSIGN p_Window = p_Widget:PARENT   /* Frame  */
                       p_Window = p_Window:PARENT   /* Window */
                       NO-ERROR .
            END.
            
        OTHERWISE /* Field-level */
            DO:
                ASSIGN p_Window = p_Widget:FRAME
                       p_Window = p_Window:PARENT
                       NO-ERROR .
            END.
    END CASE.
    
END. /* */

