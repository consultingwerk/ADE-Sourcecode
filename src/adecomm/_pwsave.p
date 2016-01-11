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
    Procedure:  _pwsave.p
    
    Purpose:    Execute Procedure Window File->Save command.

    Syntax :    RUN adecomm/_pwsave.p (INPUT pw_Editor).

    Parameters:
    Description:
	1.  Test if the file is "untitled".
	2.  If untitled, execute the Save As Dialog, allowing
	    user to enter a file name to save.
	3.  Write contents of editor to disk.

    Notes  :
    Authors: John Palazzo
    Date   : January, 1994
**************************************************************************/

/* Procedure Window Global Defines. */
{ adecomm/_pwglob.i }

DEFINE INPUT  PARAMETER pw_Editor   AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE pw_Window AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE File_Name  AS CHARACTER NO-UNDO.
DEFINE VARIABLE SAVE_OK    AS LOGICAL   NO-UNDO. 
DEFINE VARIABLE Dlg_Answer AS LOGICAL   NO-UNDO.

DO ON STOP UNDO, LEAVE:
    /* Need widget handle of Procedure Window for this editor widget. */
    pw_Window = pw_Editor:WINDOW.
           
    /* If Untitled, open Save As dialog box. */
    IF pw_Editor:NAME BEGINS {&PW_Untitled}
    THEN DO:
        /* Save As routine takes care of actually saving the file. */
        RUN adecomm/_pwsavas.p (INPUT pw_Editor).
        RETURN.
    END.
    RUN adecomm/_pwsavef.p ( INPUT pw_Editor , 
                           INPUT pw_Editor:NAME ,
                           FALSE /* Save */, OUTPUT SAVE_OK ).    
                           
    /* This is redundant, since it's already done in _pwsavef.p.
    ASSIGN pw_Window:TITLE = {&PW_Title_Leader} + pw_Editor:NAME. 
    */
END.
