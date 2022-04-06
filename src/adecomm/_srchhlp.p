/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
