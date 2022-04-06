/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*


Procedure:    adetran/common/_schema.p
Author:       R. Ryan
Created:      1/95 
Updated:      9/95
Purpose:      Project Manager uses this routine to evaluate
              whether the connected database is really a project database.
Called By:    pm/_pmmain.p
*/

define output parameter pSchemaOK as logical no-undo.

if can-find(xlatedb._file where _file-name = "xl_glossary":u) and
   can-find(xlatedb._file where _file-name = "xl_kit":u) then
  pSchemaOK = true.
else
  pSchemaOK = false.
