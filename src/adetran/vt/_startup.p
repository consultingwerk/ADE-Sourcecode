/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

