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
/*--------------------------------------------------------------------
File: _ttysx.p

Description:
    This routine is part of the UIB Character Run Window capability,
    which consists of the following procedures, scripts/batch files:

    * adeuib/_ttyss.p  PROGRESS
          Establishes the PROGRESS Winchar client session by calling
          _progres directly (Windows) or running script ttysx (Motif).
          Writes the RUN messages via the character message/command
          file (e.g., p12345m.tty) to the PROGRESS Character session.

    * adecomm/_ttysr.p  PROGRESS
          Startup procedure of the PROGRESS Character session which
          executes the UIB temp file in the Character Run Window
          (xterm under Motif; DOS Shell under Windows).

    * adeuib/_ttysx.p  PROGRESS
          Closes the Character Run Window by deleting the command .tty file.

    * $DLC/bin/ttysx     /dev/sh
          Executes the UIB Character Run Window as a UNIX character client
          in an xterm window.

    * <run_tty_name>  UNIX/DOS-file
          Used as message/command channel between UIB and its Character Run
          Window. Has the form "p12345m.tty".

Input-Parameters:
    p_Disp_Message  
        TRUE  : Display message if there is no Char Run window to close.
        FALSE : Do not display message if there is no Char Run window to close.

Shared Var
    s_tmp-file CHAR
          UNIX/DOS-file
          Used as message/command channel between UIB and its Character Run
          Window. Has the form "p12345m.tty".

Output-Parameters:

Author:  John Palazzo, adapted from 7.3A (Tom Hutegger).

History:
    jep         94/10/24    Updated for running under Unix and DOS.
    hutegger    94/02/04    Created.
--------------------------------------------------------------------*/

/*----------------------------  PREPROCESSOR ---------------------------*/
{ adecomm/adefext.i }
{ adeuib/sharvars.i }

DEFINE INPUT PARAMETER p_Disp_Message AS LOGICAL NO-UNDO.

DEFINE VARIABLE db_connects  AS CHARACTER                NO-UNDO.
DEFINE VARIABLE tty_command  AS CHARACTER                NO-UNDO.
DEFINE VARIABLE cmd_line     AS CHARACTER FORMAT "x(35)" NO-UNDO.

/*--------------------  LANGUAGE-DEPENDENCIES  ---------------------*/
DEFINE VARIABLE errmsg       AS CHARACTER FORMAT "x(60)" EXTENT 4
    INITIAL [ 
/*       ..../....1..../....2..../....3..../....4..../....5..../....6 */
/* 1 */ "There is no {&UIB_NAME} Character Run Window open.",
/* 2 */ "The {&UIB_NAME} character lock file does not exist anymore.",
/* 3 */ "Character window's answer was incorrect. Check p*.tty files",
/* 4 */ "Cannot shutdown {&UIB_NAME} character window."
            ].

DO:

    /* Initialize some variables. */
    ASSIGN tty_command  = s_tmp-file .

    /* Check if tmp-file-name exists or if message file is still there
       to determine if the UIB Character window is open or not. If not
       there, message the user there is no tty window to close. If its
       there, delete it.
    */
    IF ( tty_command = "" OR SEARCH( tty_command ) = ?) THEN
    DO:
        IF p_Disp_Message THEN MESSAGE errmsg[1] VIEW-AS ALERT-BOX INFORMATION.
    END.
    ELSE
        OS-DELETE VALUE( tty_command ).

END.
