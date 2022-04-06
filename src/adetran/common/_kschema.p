/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*


Procedure:    adetran/common/_kschema.p
Author:       R. Ryan
Created:      1/95 
Updated:      9/95
Purpose:      Visual Translator uses this routine to evaluate
              whether the connected database is really a kit database.
Called By:    vt/_main.p
*/

define output parameter pSchemaOK as logical no-undo.  

if can-find(kit._file where kit._file._file-name = "xl_project":u) then do:      
  find kit._file where _file-name = "xl_project":u no-lock no-error.
  if available kit._file then do:
    find kit._field of kit._file where _field-name = "TranslationCount":u no-lock no-error.
    if available kit._field then pSchemaOK = true.
  end.
end.

