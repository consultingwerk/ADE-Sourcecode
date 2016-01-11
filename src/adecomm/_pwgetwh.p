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

