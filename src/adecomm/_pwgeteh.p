/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure :  _pwgeteh.p
    
    Purpose   : Returns the handle for any Procedure Window editor widget.
                
    Syntax    : RUN adecomm/_pwgeteh.p ( INPUT p_Window , OUTPUT p_Editor ).
    
    Parmameters :
    Description:
    Notes     : If the widget is an invalid widget or a pseudo-widget,
                routine returns Unknown (?) for p_Editor.
                                
    Authors   : J. Palazzo
**************************************************************************/
              
DEFINE INPUT  PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO.
    /* Handle of editor widget's Procedure window. */
DEFINE OUTPUT PARAMETER p_Editor AS WIDGET-HANDLE NO-UNDO.
    /* Handle of Procedure Window editor widget. */

DEFINE VARIABLE hWidget AS WIDGET-HANDLE NO-UNDO.

DO:
    ASSIGN p_Editor = ?.
    /* Find the Procedure Window frame and editor widget. */
    IF p_Window:TYPE = "WINDOW"
    THEN DO:
        ASSIGN hWidget = p_Window
               hWidget = hWidget:FIRST-CHILD.  /* Editor Frame */
        IF VALID-HANDLE( hWidget ) 
        THEN ASSIGN hWidget  = hWidget:FIRST-CHILD  /*Field group. */
                    p_Editor = hWidget:FIRST-CHILD. /* The editor. */
    END.
END.
