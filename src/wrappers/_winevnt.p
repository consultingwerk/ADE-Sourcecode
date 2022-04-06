/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
