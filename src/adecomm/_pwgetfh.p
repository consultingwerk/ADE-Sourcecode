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
    Procedure :  _pwgetfh.p
    
    Purpose   : Returns the handle of the Procedure Window Editor Frame
                given a Procedure Window handle.                
    
    Syntax    : RUN adecomm/_pwgetfh.p ( INPUT p_Window , OUTPUT p_Frame ).

    
    Parmameters :
    Description:
    Notes     : If the widget is an invalid widget or a pseudo-widget,
                routine returns Unknown (?) for p_Editor.
                                
    Authors   : J. Palazzo
**************************************************************************/
              
DEFINE INPUT  PARAMETER p_Window       AS WIDGET-HANDLE NO-UNDO.
    /* Handle of Editor Frame's Procedure window. */
DEFINE OUTPUT PARAMETER p_Frame AS WIDGET-HANDLE NO-UNDO.
    /* Handle of Procedure Window Editor Frame widget. */

DO:
    ASSIGN p_Frame = ?.
    /* PW's first child is Editor Frame. */
    IF p_Window:TYPE = "WINDOW" THEN ASSIGN p_Frame = p_Window:FIRST-CHILD.
    
END.
