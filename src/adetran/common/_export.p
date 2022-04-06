/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*


Procedure:    adetran/common/_export.p
Author:       R. Ryan
Created:      1/95 
Purpose:      Project Manager uses export to dump glossary. 
Called By:    pm/_pmmain.p
*/

define input parameter pExportFile as char no-undo.
define shared variable s_Glossary as char no-undo. 

output to value(pExportFile).
run adecomm/_setcurs.p ("wait":u).    
for each xlatedb.XL_GlossDet no-lock where 
      xlatedb.XL_GlossDet.GlossaryName = s_Glossary:  
      export xlatedb.XL_GlossDet.SourcePhrase xlatedb.XL_GlossDet.TargetPhrase.
end.
output close.   
run adecomm/_setcurs.p ("").
