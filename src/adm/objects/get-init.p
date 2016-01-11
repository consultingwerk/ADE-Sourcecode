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
/* get-init.p - This procedure is passed the name of a table and
   retrieves the value of the _template field for that table in
   the current DICTDB database, and returns that RECID value to
   the caller (adm-add-record in tableio.i). 
   Parameters: INPUT table-name
               OUTPUT RECIF of _template record for that table 
   Notes:      This needs to be a separate procedure because the 
               value of DICTDB may be changed at runtime.        
               The table-name may or may not have a db-name qualifier.
               
*/

  DEFINE INPUT PARAMETER p-table-name AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p-table-recid AS RECID NO-UNDO.
  
  FIND DICTDB._file WHERE _file._file-name =
    SUBSTR(p-table-name, INDEX(p-table-name, ".":U) + 1) NO-LOCK.
  p-table-recid = _file._template.

