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
    Procedure:  _pwfmod.p
    
    Purpose:    Returns TRUE if editor is a modified; FALSE if not.

    Syntax :    RUN adecomm/_pwfmod.p ( INPUT p_Editor , INPUT p_Title ,
                                      OUTPUT p_Modified ) .

    Parameters:
    Description:
    Notes  :
    Authors: John Palazzo
    Date   : January, 1994
**************************************************************************/

/* Procedure Window Global Defines. */
{ adecomm/_pwglob.i }

DEFINE INPUT  PARAMETER p_Editor   AS WIDGET-HANDLE      NO-UNDO.
DEFINE OUTPUT PARAMETER p_Modified AS LOGICAL INIT FALSE NO-UNDO.
    
DO:
    /* WebSpeed Report/Detail case where the Procedure Window is the 
       visualization of the Report/Detail Wizards output. The file has not
       been modified per se, yet it is still untitled and not empty. */
    IF ( p_Editor:MODIFIED = NO AND NOT p_Editor:EMPTY AND
         p_Editor:NAME BEGINS {&PW_Untitled})
    THEN p_Modified = TRUE.
    ELSE IF 
       ( p_Editor:MODIFIED = NO ) OR 
       ( p_Editor:NAME BEGINS {&PW_Untitled} AND
         p_Editor:EMPTY ) 
    THEN p_Modified = FALSE.
    ELSE p_Modified = TRUE.

END.
