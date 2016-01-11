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
