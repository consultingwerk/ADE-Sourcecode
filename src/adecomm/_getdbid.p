/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _getdbid.p

Description:
   This will make sure your selected database is connected, then
   find the recid of an _db record.  If you pass the name of a 
   gateway database, it puts DICTDB on the schema holder database.

Input Parameters:
   p_DBName  - This is the name of the database you want to find.

Output Parameters:
   p_DBID   - The recid of the _DB record.  ? if the db was not found.

Author: Warren Bare

Date Created: 06/30/92 

----------------------------------------------------------------------------*/

Define INPUT  PARAMETER p_DBName    as char     NO-UNDO.
Define OUTPUT PARAMETER p_DBID      as recid    NO-UNDO.

Define Var v_DBCount as int no-undo. /* loop through connected dbs */

/* if this is a schema holder, then find it in the right progress db */
IF NOT CONNECTED(p_DBName) OR DBTYPE(p_DBName) NE "Progress" THEN
do:
  FindDB:
  do v_DBCount = 1 to num-dbs:
    IF DBTYPE(v_DBCount) = "PROGRESS" THEN
    DO:
      create alias dictdb for database VALUE(ldbname(v_DBCount)).
      RUN adecomm/_finddb.p (INPUT p_DBName, OUTPUT p_DBID).
      IF p_DBID NE ? THEN leave FindDB.
    END.
  end.
end.
else /* just put the alias on this db */
DO:
  IF LDBNAME("DICTDB") <> p_DBName THEN
    create alias DICTDB for database VALUE(p_DBName).
  RUN adecomm/_finddb.p (INPUT ?, OUTPUT p_DBID).
END.

RETURN.
