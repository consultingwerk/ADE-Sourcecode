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
