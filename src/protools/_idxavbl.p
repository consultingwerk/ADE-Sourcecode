/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*PROGRAM NAME: _idxavbl.p
 * AUTHOR      : Tammy Marshall
 * DATE        : 04/01/99
 * DESCRIPTION : Accepts a table name and an index name and returns a logical 
 *               indicating whether the index still exists in the table in the DB.
 * */
 
DEFINE INPUT PARAMETER pcDBType AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcDBName AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcTblName AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcIdxName AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER plExists AS LOGICAL NO-UNDO.

DEFINE VARIABLE rDB AS RECID NO-UNDO.

IF pcDBType = "PROGRESS" THEN
    FIND tinydict._db WHERE tinydict._db._db-name = ? AND 
        tinydict._db._db-type = "PROGRESS" NO-LOCK NO-ERROR. /*local */
ELSE
    FIND tinydict._db WHERE tinydict._db._db-name = pcDBName AND 
        tinydict._db._db-type = pcDBType NO-LOCK NO-ERROR. /* foreign */
rDB = RECID(tinydict._db).

FIND tinydict._File WHERE RECID(tinydict._db) = rDB AND
  tinydict._File._File-Name = pcTblName NO-LOCK NO-ERROR.
IF AVAILABLE _File THEN DO:
  FIND tinydict._Index WHERE _Index._File-Recid = RECID(_File) AND
    _Index._Index-Name = pcIdxName NO-LOCK NO-ERROR.
  IF AVAILABLE _Index THEN plExists = TRUE.
  ELSE plExists = FALSE.
END.  /* if avail _file */
ELSE plExists = FALSE.  

