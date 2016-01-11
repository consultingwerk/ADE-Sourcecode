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
