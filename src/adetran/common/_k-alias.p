/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*


Procedure:    adetran/common/_k-alias.p
Author:       R. Ryan
Created:      1/95 
Updated:      9/95
		11/96 SLK Connect - use of basename
Purpose:      Reconnects and resets the alias for Visual Translator
Background:   Uses the shared variable, KitDB, to connect or
              reconnect to, then sets the 'kit' alias.
Called By:    vt/_main.p
*/

define output parameter ErrorStatus as logical init true no-undo.

define shared variable KitDB as char no-undo. 
define var BaseName as char.
define var DirName as char.
define var ThisDB as char.
define var ThisLDB as char. 
define var ThisMessage as char.
define var Result as logical.
define var extension as char.

run adecomm/_osprefx.p (KitDB, output DirName, output BaseName).
ASSIGN
  BaseName = TRIM(BaseName).
run adecomm/_osfext.p (input BaseName, output Extension).
assign
 ThisDB  = BaseName
 ThisLDB = SUBSTRING(BaseName,1,LENGTH(BaseName,"CHARACTER":U) - LENGTH(Extension,"CHARACTER":U),"CHARACTER":U).

RetryLoop:
do on error undo RetryLoop, leave RetryLoop. 
  if not connected(ThisLDB) then do:
    connect -db value(KitDB) -ld value(ThisLDB) -1 no-error.
    if error-status:error then do:
      ThisMessage = error-status:get-message(1).
      run adecomm/_s-alert.p (input-output Result, "w*":u, "ok":u, ThisMessage).
      RETURN.     
    end.
  end.
end.

delete alias Kit.
create alias Kit for database value(ThisLDB) no-error.  

if error-status:error then do:
  ThisMessage = error-status:get-message(1).
  run adecomm/_s-alert.p (input-output Result, "w*":u, "ok":u, ThisMessage).    
  ErrorStatus = error-status:error.
end.
else assign
  ErrorStatus = false
  KitDB       = ThisLDB.


