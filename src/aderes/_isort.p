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

