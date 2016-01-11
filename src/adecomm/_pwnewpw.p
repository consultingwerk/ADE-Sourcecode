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
    Procedure:  _pwnewpw.p
    
    Purpose:    Execute Procedure Window File->New Procedure Window command.

    Syntax :    RUN adecomm/_pwnewpw.p ( INPUT p_Window ).

    Parameters:
    Description:
    Notes  :
    Authors: John Palazzo
    Date   : February, 1994
**************************************************************************/

/* Procedure Window Global Defines. */
{ adecomm/_pwglob.i }

DEFINE INPUT PARAMETER p_Window AS WIDGET NO-UNDO.

DEFINE VARIABLE pw_Window AS WIDGET  NO-UNDO.
DEFINE VARIABLE pw_Editor AS WIDGET  NO-UNDO.
DEFINE VARIABLE Ed_Font   AS INTEGER NO-UNDO.

DEFINE VARIABLE OK_Close     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE Old_Name     AS CHARACTER NO-UNDO.
DEFINE VARIABLE New_Name     AS CHARACTER NO-UNDO.

DO ON STOP UNDO, LEAVE:
    /* Get widget handle of parent PW editor widget. */
    RUN adecomm/_pwgeteh.p ( INPUT p_Window , OUTPUT pw_Editor ).

    /* Store off the parent PW editor font. */
    ASSIGN Ed_Font = pw_Editor:FONT.
            
    /* Open New Procedure Window. */
    RUN adecomm/_pwmain.p (INPUT p_Window:PRIVATE-DATA
                                     /* PW Parent ID    */,
                           INPUT ""  /* Files to open   */,
                           INPUT ""  /* PW Command      */ ).
    /* Get handle of new PW. */
    ASSIGN pw_Window = SESSION:LAST-CHILD.
  
    /* Get handle of new PW editor widget. */
    RUN adecomm/_pwgeteh.p ( INPUT pw_Window , OUTPUT pw_Editor ).
  
    /* Inherit font of parent editor. */
    IF pw_Editor:FONT <> Ed_Font
    THEN ASSIGN pw_Editor:FONT = Ed_Font.

END.
