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
/***************************************************************************
    Procedure:      _srchhlp.p
    Purpose:        ADE Help API for Common Editor Search Routines.

    Run Syntax:     RUN adecomm/_srchhlp.p ( INPUT p_Help_On ) .

    Parameters:

          INPUT p_Help_On
                The SYSTEM-HELP <context-string> for which you want help.

                For example, the context string of the Find dialog
                box is Find_Dialog_Box.  This is converted to the
                appropriate SYSTEM-HELP <context-number>.

    Description:
    Notes:
***************************************************************************/

/* adecomm/_srchhlp.p */

DEFINE INPUT PARAMETER p_Help_On      AS CHARACTER NO-UNDO .

{ adecomm/commeng.i }

DEFINE VAR             vHelp_Context  AS INTEGER   NO-UNDO .

REPEAT ON STOP UNDO, LEAVE: /* proc-main */

    CASE p_Help_On :

        /*--------------- Search Help ---------------*/
        WHEN "Find_Dialog_Box"
    	    THEN vHelp_Context = {&Find_Dialog_Box} .

        WHEN "Replace_Dialog_Box"
    	    THEN vHelp_Context = {&Replace_Dialog_Box} .

        WHEN "Goto_Line_Dialog_Box"
            THEN vHelp_Context = {&Goto_Line_Dialog_Box} .

    END CASE .

    RUN adecomm/_adehelp.p
        ( INPUT "comm" , INPUT "CONTEXT" , INPUT vHelp_Context , INPUT ? ) .
    LEAVE.

END. /* proc-main */
