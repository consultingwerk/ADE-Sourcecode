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
    Procedure:  _pwfchg.p
    
    Purpose:    Executes File Changed Dialog, which asks user to save
		changes made to a modified file before continuing some
		operation.

    Syntax :    RUN adecomm/_pwfchg.p ( INPUT p_Editor , INPUT p_Title ,
                                      OUTPUT p_Save_Changes )

    Parameters:
	p_Save_Changes     YES - User wants changes.
	                   NO  - User does not want changes saved.
	                    ?  - User wants to Cancel the current operation.
    Description:
    Notes  :
    Authors: John Palazzo
    Date   : January, 1994
**************************************************************************/

DEFINE INPUT  PARAMETER p_Editor           AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p_Title            AS CHARACTER     NO-UNDO.
DEFINE OUTPUT PARAMETER p_Save_Changes     AS LOGICAL       NO-UNDO.

DEFINE VARIABLE pw_Window    AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE Buf_Modified AS LOGICAL       NO-UNDO.

DO:
  ASSIGN p_Save_Changes = ?. /* Default to Cancel. */
  RUN adecomm/_pwfmod.p ( INPUT p_Editor , OUTPUT Buf_Modified ).
  IF ( Buf_Modified = TRUE )
  THEN DO:
    /* Get widget handle of Procedure Window. */
    RUN adecomm/_pwgetwh.p ( INPUT p_Editor , OUTPUT pw_Window ).
    /* Restore window if its minimized so user can see the code. */
    ASSIGN pw_Window:WINDOW-STATE = WINDOW-NORMAL
			                  WHEN pw_Window:WINDOW-STATE = WINDOW-MINIMIZED.
    p_Save_Changes = YES.
    MESSAGE p_Editor:NAME SKIP
            "Procedure file has changes which have not been saved." SKIP(1)
 	     "Save changes before closing?"
 	    VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO-CANCEL 
  	            UPDATE p_Save_Changes
  	    IN WINDOW pw_Window. 
  END.
  ELSE
    p_Save_Changes = NO.  /* No changes, so skip the save. */
    
  RETURN.
  
END.
