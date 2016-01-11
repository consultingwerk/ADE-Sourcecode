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

File: _gttbldb.p

Description:
   This will look in all the databases to find the specified table, then
   leave with the specified alias on that database.

Input Parameters:
   p_TblName - This is the name of the table you want to get an id for.
   p_Alias   - The name of the alias to put on the target db. -- optional.

Output Parameters:
   p_DBID   - The recid of the _Db record for this _file.
   p_TblID  - The recid of the _File record.

Author: Warren Bare

Date Created: 06/30/92 

----------------------------------------------------------------------------*/


Define INPUT  PARAMETER p_TblName   as char     NO-UNDO.
Define OUTPUT PARAMETER p_DBName    as char     NO-UNDO.
Define OUTPUT PARAMETER p_DBID      as recid    NO-UNDO init ?.
Define OUTPUT PARAMETER p_TblID     as recid    NO-UNDO init ?.

Define var v_DbCnt     as int  no-undo.

do v_DbCnt = 1 to NUM-DBS:
  IF DBTYPE(v_DBCnt) NE "Progress" THEN NEXT.
  CREATE Alias DICTDB for database VALUE(LDBNAME(v_DbCnt)).
  run adecomm/_findtbl.p (p_TblName,
    OUTPUT p_DBName,
    OUTPUT p_DBID,
    OUTPUT p_TblID).

  IF p_TblID NE ? THEN
    RETURN.
END.
