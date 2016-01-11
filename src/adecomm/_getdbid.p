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
