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

