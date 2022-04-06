/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

