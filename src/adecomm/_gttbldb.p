/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
