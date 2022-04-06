/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*


Procedure:    adetran/common/_alias.p
Author:       R. Ryan
Created:      1/95 
Updated:      9/95
		11/96 SLK CONNECT - use of basename
		12/96 SLK added RETURN after connection failure
Purpose:      Reconnects and resets the alias for TM's Project Mgr
Background:   Uses the shared variable, ProjectDB, to connect or
              reconnect to, then sets the 'xlatedb' alias.
Called By:    pm/_pmmain.p, pm/_newproj.w
*/

define output parameter ErrorStatus as logical init true no-undo.
define shared variable ProjectDB as char no-undo. 

define var ThisMessage as char no-undo.
define var Result as logical no-undo.
define var BaseName as char.
define var DirName as char.
define var ThisDB as char.
define var ThisLDB as char.
define var Extension as char.

run adecomm/_osprefx.p (ProjectDB, output DirName, output BaseName).
BaseName = TRIM(BaseName).
run adecomm/_osfext.p (input BaseName, output Extension).

assign
 ThisDB  = BaseName
 ThisLDB = SUBSTRING(BaseName,1,LENGTH(BaseName,"CHARACTER":U) - LENGTH(Extension,"CHARACTER":U),"CHARACTER":U).

RetryLoop:
do on error undo RetryLoop, leave RetryLoop.  
  if not connected(ThisLDB) then do:
    connect -db value(ProjectDB) -ld value(ThisLDB) -1 no-error.
    if error-status:error then do:
      ThisMessage = error-status:get-message(1).
      run adecomm/_s-alert.p (input-output Result, "w*":u, "ok":u, ThisMessage).          
      RETURN.
    end.  
  end.
end.

delete alias xlatedb.
create alias xlatedb for database value(ThisLDB) no-error.

if not error-status:error then assign
  ProjectDB   = ThisLDB
  ErrorStatus = false.

