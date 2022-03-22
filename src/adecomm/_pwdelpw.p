/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _pwdelpw.p
    
    Purpose:    Delete Procedure Window widget, its menubar, and all
                frames.

    Syntax :    RUN adecomm/_pwdelpw.p (INPUT p_Window ).

    Parameters:
    Description:
    Notes  :
    Authors: John Palazzo
    Date   : January, 1994
    Updated: August, 1995
             Jep - Delete editor widget's dynamically created popup menu.
**************************************************************************/

DEFINE INPUT PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE h        AS WIDGET  NO-UNDO.
DEFINE VARIABLE h_next   AS WIDGET  NO-UNDO.
DEFINE VARIABLE h_Editor AS WIDGET  NO-UNDO.
DEFINE VARIABLE l_ok     AS LOGICAL NO-UNDO.

DO:
  ASSIGN p_Window:VISIBLE = FALSE.
  
  /* Delete the editor widget's dynamic popup menu. */
  RUN adecomm/_pwgeteh.p ( INPUT p_Window , OUTPUT h_Editor ).
  ASSIGN h = h_Editor:POPUP-MENU.
  IF VALID-HANDLE( h ) THEN DELETE WIDGET h.
  
  /* Delete contained frames. */
  h_next = p_Window:FIRST-CHILD.
  DO WHILE h_next <> ?:
    ASSIGN h = h_next 
           h_next = h_next:NEXT-SIBLING.
    DELETE WIDGET h.
  END.
  
  /* Delete the window's menubar. */
  ASSIGN h = p_Window:MENUBAR.
  IF VALID-HANDLE( h ) THEN DELETE WIDGET h.
  
  /* Delete the window. */
  DELETE WIDGET p_Window.
  
END.
