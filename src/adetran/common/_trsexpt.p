/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*


Procedure:    adetran/common/_trsexpt.p
Author:       F. Chang
Created:      1/95 
Updated:      9/95
Purpose:      Visual Translator uses export to dump string/trans-
              lation data.
Background:   This procedure dumps the XL_Instance table in the
              current SESSION:CHARSET.
Called By:    pm/_pmmain.p
*/

define input parameter pExportFile as char no-undo.

output to value(pExportFile).
for each kit.XL_Instance no-lock :
  export kit.XL_Instance.  
end.        
output close.

