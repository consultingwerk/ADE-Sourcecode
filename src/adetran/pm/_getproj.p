/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/pm/_getproj.p
Author:       R. Ryan/
Created:      1/95
Updated:      9/95
Purpose:      Returns character lists that correspond to glossary names
              and kit names.  This information is used to construct list-items
              for various calling procedures.  It is also use to sensitize
              buttons associated with certain tab folders.
Called By:    pm/_consol.w
              pm/_gloss.p
              pm/_newkit.w
Parameters:   GlossaryList (output/char) list of glossary names
              KitList (output/char)      list of kit names
              ErrorStatus (output/log)   success of the operation
               
*/


define output parameter GlossaryList as char no-undo.  
define output parameter KitList as char no-undo.
define output parameter ErrorStatus as logical no-undo.

for each xlatedb.XL_Glossary no-lock:  
  GlossaryList = if GlossaryList = ? or GlossaryList = "" then 
                   xlatedb.XL_Glossary.GlossaryName
                 else 
                   GlossaryList + "," + xlatedb.XL_Glossary.GlossaryName.
end.   

for each xlatedb.XL_Kit no-lock:  
  KitList = if KitList = ? then xlatedb.XL_Kit.KitName
                           else KitList + "," + xlatedb.XL_Kit.KitName.
end.
return.

