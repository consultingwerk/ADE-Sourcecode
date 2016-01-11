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
    Procedure:  _pwclosf.p
    
    Purpose:    Low-level routine to Close a Procedure Window file.

    Syntax :    RUN adecomm/_pwclosf.p ( INPUT p_Window , INPUT p_Editor ,
                                       INPUT p_Action ,
                                       OUTPUT p_OK_Close ) .

    Parameters:
        See DEFINE PARAMETER in code.
        
    Description:
        1. If unsaved changes, ask user to Save Changes: Yes-No-Cancel.
        2. If Untitled, open Save As dialog box.
        3. Finally, perform actual file save.

    Notes  :
    Authors: John Palazzo
    Date   : January, 1994
**************************************************************************/

/* Procedure Window Global Defines. */
{ adecomm/_pwglob.i }

DEFINE INPUT  PARAMETER p_Window   AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p_Editor   AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p_Action   AS CHARACTER     NO-UNDO.
DEFINE OUTPUT PARAMETER p_OK_Close AS LOGICAL       NO-UNDO.
    /* p_OK_Close = TRUE means its ok to continue operation.
                  = FALSE or ? means its not.
    */

DEFINE VARIABLE File_Name   AS CHARACTER NO-UNDO.
DEFINE VARIABLE l_OK        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE Save_As     AS LOGICAL   NO-UNDO.

REPEAT ON STOP UNDO, RETRY:
        IF RETRY
        THEN DO:
            ASSIGN p_OK_Close = ?.    /* Cancel */
            RETURN.
        END.
        
        /* Bring PW to top. */
        ASSIGN l_OK = p_Window:MOVE-TO-TOP().
        
        /* Ask user to Save Changes: Yes-No-Cancel. Returns NO if unsaved
           changes or if user answered NO. */
        RUN adecomm/_pwfchg.p ( INPUT p_Editor , INPUT p_Action ,
                                OUTPUT p_OK_Close ). 
        
        IF p_OK_Close = ? THEN RETURN.  /* Cancel */   
        IF p_OK_Close = NO              /* NO - Don't Save. */
        THEN DO:
            ASSIGN p_OK_Close = TRUE. /* Means ok to contine and close file. */
            RETURN.
        END.
        
        IF p_OK_Close = YES THEN 
        DO: /* Yes->Save. */
            RUN adecomm/_pwsave.p (INPUT p_Editor).
            IF RETURN-VALUE = "ERROR":U THEN
               ASSIGN p_OK_Close = ?.
        END.
        LEAVE.
END.
