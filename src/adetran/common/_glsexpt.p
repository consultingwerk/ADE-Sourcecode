/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*


Procedure:    adetran/common/_gslexpt.p
Author:       F. Chang
Created:      1/95 
Updated:      9/95
Purpose:      Visual Translator uses export to dump the glossary. 
Background:   The glossary is dumped n the codepage that is reflected
              in SESSION:CHARSET (or -CPINTERNAL).
Called By:    vt/_main.p
*/


define input parameter pExportFile as char no-undo.

output to value(pExportFile).
run adecomm/_setcurs.p ("wait":u).
for each kit.XL_GlossEntry no-lock:
  export kit.XL_GlossEntry.SourcePhrase kit.XL_GlossEntry.TargetPhrase. 
end.        
output close.
run adecomm/_setcurs.p ("").

