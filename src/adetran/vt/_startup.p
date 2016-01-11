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

Procedure:    adetran/vt/_startup.p
Author:       R. Ryan 
Created:      4/95
Purpose:      wrapper to _main.p.           
*/


define new shared var hStartup as handle no-undo.  
define new shared var KitDB as char no-undo. 
define new shared var PlaceHolderDB as logical no-undo.
define new shared var hMain as handle no-undo.  
define new shared var MainWindow as widget-handle no-undo.  


define var hVT as handle no-undo. 
define var i as int no-undo.

define temp-table PersistProcs
  field hProcedure as handle.

create widget-pool.

on close of this-procedure do:
  delete procedure this-procedure.
end.

hStartup = this-procedure.   
     
main-block:
  do 
    on error   undo main-block, leave main-block
    on end-key undo main-block, leave main-block
    on stop    undo main-block, leave main-block: 

  run adetran/vt/_main.p persistent set hMain.
  wait-for close of this-procedure.  
end.


procedure DisconnectDB:  
  message "delete".
  do i = 1 to num-dbs:
    disconnect value(ldbname(i)) no-error. 
    delete alias "kit".
  end.   
end procedure. 

procedure ResetMain: 
  PlaceHolderDB  = false. 
  
  run Enable_UI in hMain.
  run SetSensitivity in hMain.    
end procedure.    

procedure disable_UI: 
  define var h as handle no-undo.
   
  h = session:first-procedure.
  do while h <> ?:
    create PersistProcs. 
    hProcedure = h.
    h          = h:next-sibling.
  end.   

  for each PersistProcs:  
    if valid-handle(hProcedure) then delete procedure hProcedure no-error. 
  end.   
  
  delete widget-pool.
  delete widget MainWindow.
end procedure.

