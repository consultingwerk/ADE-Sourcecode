/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*PROGRAM NAME: _idxlist.p
 * AUTHOR      : Tammy Marshall
 * DATE        : 04/01/99
 * DESCRIPTION : Returns a list of index names to populate the selection list
 *               of indices in the DB Connections PRO*Tool Schema window.
 * */
 
DEFINE INPUT PARAMETER pcDBType AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcDBName AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcTableName AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER cIndxList AS CHARACTER NO-UNDO.

DEFINE VARIABLE rDB AS RECID NO-UNDO.  /* recid of _db */

IF pcDBType = "PROGRESS" THEN
    FIND tinydict._db WHERE tinydict._db._db-name = ? AND 
        tinydict._db._db-type = "PROGRESS" NO-LOCK NO-ERROR. /*local */
ELSE
    FIND tinydict._db WHERE tinydict._db._db-name = pcDBName AND 
        tinydict._db._db-type = pcDBType NO-LOCK NO-ERROR. /* foreign */
rDB = RECID(tinydict._db).

FIND tinydict._File WHERE tinydict._File._Db-Recid = rDB AND
  tinydict._File._File-Name = pcTableName NO-LOCK NO-ERROR.
IF AVAILABLE tinydict._File THEN 
  FOR EACH tinydict._Index OF tinydict._File NO-LOCK:
    IF cIndxList <> "" THEN cIndxList = cIndxList + ",".
    ASSIGN cIndxList = cIndxList + _Index._Index-Name.
  END.  /* for each _field */
 
