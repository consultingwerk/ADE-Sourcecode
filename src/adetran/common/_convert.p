/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*


Procedure:    adetran/common/_convert.p
Author:       R. Ryan
Created:      9/95 
Updated:      9/95
Purpose:      Procedure for evaluating whether a codepage conversion 
              is available in convmap.dat.
Called By:    common/_import.w
              common/_glsimpt.w
              pm/_newglos.w
*/

define input parameter pTarget as char no-undo.
define input parameter pSource as char no-undo.
define output parameter pSuccess as logical no-undo. 
define var TestCP as char no-undo.
define var ThisMessage as char no-undo.
define var ErrorStatus as logical no-undo.

pSuccess = false. 

/*
** test with an assign statement to see if the codepage conversion exists
** if this codepage conversion fails, the statement blows up and returns to the
** calling program with pSuccess = false.  BTW, putting no-error on will keep
** two error messages to be displayed back-to-back.  This way, only the first
** error message is displayed.
*/
assign 
  TestCP = codepage-convert("a":u,pTarget,pSource) no-error.
                
if TestCP = ? then do:
  pSuccess = false.
  ThisMessage = error-status:get-message(1).  
  run adecomm/_s-alert.p (input-output ErrorStatus, "w*":u, "ok":u, ThisMessage).        
end.
else
  pSuccess = true.
