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
/*----------------------------------------------------------------------------

File: _winevnt.p

Description:
    This procedure exists as a catch-all for PERSISTENT Window Triggers that
    might be used in the ADE code.  Because you cannot disable such triggers
    as WINDOW-CLOSE, ENTRY, WINDOW-MINIMIZED on windows a procedure needs to
    be available to the trigger.  
    
    For example:
       You want your code to run an internal procedure "win-close".
       If you write the trigger:
          ON WINDOW-CLOSE PERSISTENT RUN win-close.
       Progress will not be able to find the procedure if you are in a
       dialog box and try to close the window.
       
       However, if you do the following:
         ON WINDOW-CLOSE PERSISTENT RUN _winevnt ("CLOSING").
       and if you write your own internal procedure:
         PROCEDURE _winevnt.
           DEFINE INPUT PARAMETER p_case AS CHAR.
           CASE p_case:
             WHEN "CLOSING" THEN RUN win-close.
           END CASE.
         END PROCEDURE.
         
       In this case, your local _winevnt will be found when it is available.
       Otherwise this procedure will be found (it will do nothing).
       
Input Parameters:
    p_char : A dummy character string -- this is ignored.
Output Parameters:
   <None>

Author: Wm.T.Wood

Date Created: April 29, 1993
----------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p_char AS CHARACTER NO-UNDO.

/* Do nothing -- just "eat" the procedure call and return */
