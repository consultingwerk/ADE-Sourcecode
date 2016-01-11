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
    Procedure:      _edithlp.p
    Purpose:        Help API for Procedure Editor Help.

    Run Syntax:     RUN adeedit/_edithlp.p ( INPUT p_Help_On ) .

    Parameters:

          INPUT p_Help_On
                The SYSTEM-HELP <context-string> for which you want help.

                For example, the context string of the Buffer List dialog
                box is Buffer_List_Dialog_Box.  This is converted to the
                appropriate SYSTEM-HELP <context-number>.

    Description:
    Notes:
***************************************************************************/

DEFINE INPUT PARAMETER p_Help_On      AS CHARACTER NO-UNDO .

{ adeedit/edithelp.i }

DEFINE VAR             vHelp_Context  AS INTEGER   NO-UNDO .

/* proc-main */
REPEAT ON STOP UNDO, LEAVE:

CASE p_Help_On :

    /*--------------- Search Help ---------------*/
    /* See adecomm/_srchhlp.p */

    /*--------------- Buffer Help ---------------*/
    WHEN "Buffer_List_Dialog_Box"
    	THEN vHelp_Context = {&Buffer_List_Dialog_Box} .
    
    WHEN "Buffer_Settings_Dialog_Box"
    	THEN vHelp_Context = {&Buffer_Settings_Dialog_Box} .

    /*--------------- Compile Help --------------*/
    WHEN "Compiler_Message_Dialog_Box"
        THEN vHelp_Context = {&Compiler_Message_Dialog_Box} .

    /*--------------- Options Help --------------*/
    WHEN "System_Options_Dialog_Box"
    	THEN vHelp_Context = {&System_Options_Dialog_Box} .

    /*-------------- Other Help    --------------*/
    WHEN "Save_Buffers_Dialog_Box"
        THEN vHelp_Context = {&Save_Buffers_Dialog_Box} .
   
END CASE .

RUN adecomm/_adehelp.p
    ( INPUT "edit" , INPUT "CONTEXT" , INPUT vHelp_Context , INPUT ? ) .

LEAVE.

END. /* proc-main */
