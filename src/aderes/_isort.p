/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* _isort.p
*
*    Sorts the directory structure alphabetically.
*
*    This file exists because the directory stuff is implemented
*    by parallel arrays instead of temp table. There isn't enough
*    time, this late in the game, to rewrite all the directory
*    code to use temp tables.
*
*    How to sort? We'll use a temp table. Sigh.
*
*/

{ aderes/i-define.i }

DEFINE temp-table _queryFile
  FIELD _attachedDatabases AS CHARACTER
  FIELD _queryName         AS CHARACTER
  FIELD _queryFileNumber   AS INTEGER
  FIELD _queryFlag         AS LOGICAL

  INDEX _nameDex IS primary _queryName
  .

DEFINE VARIABLE qbf-i AS INTEGER NO-UNDO.

/*
* Loop through all of the directory stuff and build the temp table. Check
* all entries throwing out gaps.
*/
DO qbf-i = 1 TO EXTENT(qbf-dir-ent):
  IF TRIM(qbf-dir-ent[qbf-i]) = "" THEN NEXT.
  CREATE _queryFile.

  ASSIGN
    _queryFile._queryName         = qbf-dir-ent[qbf-i]
    _queryFile._attachedDatabases = qbf-dir-dbs[qbf-i]
    _queryFile._queryFileNumber   = qbf-dir-num[qbf-i]
    _queryFile._queryFlag         = qbf-dir-flg[qbf-i]
    .
END.

/* Reset the arrays, this function will compress the array.  */
ASSIGN
  qbf-dir-ent = ""
  qbf-dir-dbs = ""
  qbf-dir-num = 0
  qbf-dir-flg = ?
  qbf-i       = 0
  .

/*
* Now move through the temp table, using the index. THe names will come out
* sorted.
*/
FOR EACH _queryFile USE-INDEX _nameDex:

  ASSIGN
    qbf-i              = qbf-i + 1
    qbf-dir-ent[qbf-i] = _queryFile._queryName
    qbf-dir-dbs[qbf-i] = _queryFile._attachedDatabases
    qbf-dir-num[qbf-i] = _queryFile._queryFileNumber
    qbf-dir-flg[qbf-i] = _queryFile._queryFlag
    .

  DELETE _queryFile.
END.

/* _isort.p - end of file */

