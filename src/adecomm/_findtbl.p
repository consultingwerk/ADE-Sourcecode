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
/*----------------------------------------------------------------------------

File: _findtbl.p

Description:
  Returns id of _File record if it exists in current database, and the
  id of the _db record that the _file record belongs to.

Input Parameters:
   p_TblName - Name of the _File record we are looking for.

Output Parameters:
   p_DBID   - Set to recid of _db record
   p_TblID  - Set to recid of _File record

Author: Warren Bare

Date Created: 09/03/92

----------------------------------------------------------------------------*/


Define INPUT  PARAMETER p_TblName as character NO-UNDO.
Define OUTPUT PARAMETER p_DBName  as char      NO-UNDO.
Define OUTPUT PARAMETER p_DBID    as recid     NO-UNDO INIT ?.
Define OUTPUT PARAMETER p_TblID   as recid     NO-UNDO INIT ?.

FOR EACH DICTDB._DB NO-LOCK,
    EACH DICTDB._File of DICTDB._DB 
         WHERE DICTDB._File._File-Name = p_TblName NO-LOCK:
  IF INTEGER(DBVERSION("DICTDB":U)) > 8 THEN DO:
    IF LOOKUP(DICTDB._FILE._OWNER,"PUB,_FOREIGN":U) = 0 THEN NEXT.
  END.

  ASSIGN
    p_DBName = (IF DICTDB._DB._db-name = ? THEN
    LDBNAME("DICTDB") ELSE DICTDB._DB._DB-name)
    p_DBID = RECID(DICTDB._DB)
    p_TblID = RECID(DICTDB._File).
  RETURN.
END.
