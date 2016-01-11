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

Procedure:    adetran/vt/_reset
Author:       R. Ryan
Created:      1/95 
Updated:      9/95
Purpose:      Visual Translator's alias reset procedure
Background:   When a kit is being switched between one or more
              open kit databases, this procedure resets the
              alias.
Called By:    vt/_main.p
*/


define output parameter ErrorStatus as logical no-undo.

define shared variable KitDB as char no-undo. 
define var ThisLDB as char. 
define var ThisMessage as char no-undo.
define var Result as logical no-undo.

ThisLDB = KitDB.

delete alias Kit.
create alias Kit for database value(ThisLDB) no-error.

if error-status:error then do:
  ThisMessage = error-status:get-message(1).
  run adecomm/_s-alert.p (input-output Result, "e*":u, "ok":u, ThisMessage).    
end.

