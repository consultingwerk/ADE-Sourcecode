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
