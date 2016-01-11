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
/* q-add.p - fill in initial values for ADD when JOINed */

{ prores/s-system.i }
{ prores/s-define.i }

DEFINE INPUT  PARAMETER qbf-p AS INTEGER NO-UNDO. /* index into qbf-file[] */

IF qbf-p < 2 THEN RETURN.

DEFINE VARIABLE qbf-a AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-d AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-o AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-x AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-y AS CHARACTER NO-UNDO.

IF   LDBNAME("QBF$1") <> SDBNAME(qbf-db[qbf-p - 1])
  OR LDBNAME("QBF$2") <> SDBNAME(qbf-db[qbf-p]) THEN DO:
  CREATE ALIAS QBF$1 FOR DATABASE VALUE(SDBNAME(qbf-db[qbf-p - 1])).
  CREATE ALIAS QBF$2 FOR DATABASE VALUE(SDBNAME(qbf-db[qbf-p])).
  RUN prores/q-add.p (qbf-p).
  RETURN.
END.

FIND QBF$1._Db
  WHERE QBF$1._Db._Db-name =
    (IF DBTYPE(qbf-db[qbf-p - 1]) = "PROGRESS" THEN ?
    ELSE LDBNAME(qbf-db[qbf-p - 1])) NO-LOCK.
FIND QBF$2._Db
  WHERE QBF$2._Db._Db-name =
    (IF DBTYPE(qbf-db[qbf-p]) = "PROGRESS" THEN ?
    ELSE LDBNAME(qbf-db[qbf-p])) NO-LOCK.

/* filter out sql92 tables and views */
IF INTEGER(DBVERSION("QBF$1":U)) > 8 THEN
  FIND QBF$1._File OF QBF$1._Db
    WHERE QBF$1._File._File-name = qbf-file[qbf-p - 1] AND
   (QBF$1._File._Owner = "PUB":U OR QBF$1._File._Owner = "_FOREIGN":U)
    NO-LOCK.
ELSE 
  FIND QBF$1._File OF QBF$1._Db
    WHERE QBF$1._File._File-name = qbf-file[qbf-p - 1] NO-LOCK.
  
/* filter out sql92 tables and views */
IF INTEGER(DBVERSION("QBF$2":U)) > 8 THEN
  FIND QBF$2._File OF QBF$2._Db
    WHERE QBF$2._File._File-name = qbf-file[qbf-p] AND
   (QBF$2._File._Owner = "PUB":U OR QBF$2._File._Owner = "_FOREIGN":U)
    NO-LOCK.
ELSE 
  FIND QBF$2._File OF QBF$2._Db
    WHERE QBF$2._File._File-name = qbf-file[qbf-p] NO-LOCK.

qbf-o = "".

/* get matching field names from where-clause */
FOR EACH QBF$1._Field OF QBF$1._File
  WHERE QBF$1._Field._Extent = 0 NO-LOCK,
  EACH QBF$2._Field OF QBF$2._File
    WHERE QBF$1._Field._Field-name = QBF$2._Field._Field-name
      AND QBF$1._Field._Data-type  = QBF$2._Field._Data-type NO-LOCK:
  qbf-o = qbf-o + (IF qbf-o = "" THEN "" ELSE ",") + QBF$1._Field._Field-name.
END.

/* pull apart 'where' clause to get relation fields */
IF qbf-of[qbf-p] BEGINS "WHERE" THEN DO:
  ASSIGN
    qbf-c = TRIM(SUBSTRING(qbf-of[qbf-p],7)) + " AND"
    qbf-i = INDEX(qbf-c + " "," AND ").

  DO WHILE qbf-i > 0:
    ASSIGN
      qbf-d = SUBSTRING(qbf-c,1,qbf-i - 1)
      qbf-c = SUBSTRING(qbf-c,qbf-i + 5)
      qbf-i = INDEX(qbf-c + " "," AND ")
      qbf-j = INDEX(qbf-d,"=").
    IF qbf-j = 0 THEN NEXT.

    ASSIGN
      qbf-x = TRIM(SUBSTRING(qbf-d,1,qbf-j - 1))
      qbf-y = TRIM(SUBSTRING(qbf-d,qbf-j + 1))
      qbf-x = SUBSTRING(qbf-x,R-INDEX(qbf-x,".") + 1)
      qbf-y = SUBSTRING(qbf-y,R-INDEX(qbf-y,".") + 1).

    /* if names same, then already caught by for-each above */
    IF qbf-x = qbf-y THEN NEXT.

    qbf-a = FALSE.
    DO qbf-i = 1 TO 2 WHILE NOT qbf-a:
      IF qbf-i = 2 THEN
        ASSIGN /* maybe we got the files backwards.  swap and try again */
          qbf-d = qbf-x
          qbf-x = qbf-y
          qbf-y = qbf-d.
      /* attempt to find fields in schema */
      FIND QBF$1._Field OF QBF$1._File
        WHERE QBF$1._Field._Field-name = qbf-x NO-LOCK NO-ERROR.
      FIND QBF$2._Field OF QBF$2._File
        WHERE QBF$2._Field._Field-name = qbf-y NO-LOCK NO-ERROR.
      qbf-a = AVAILABLE QBF$1._Field
          AND AVAILABLE QBF$2._Field
          AND QBF$1._Field._Extent = 0
          AND QBF$2._Field._Extent = 0
          AND QBF$1._Field._dtype = QBF$2._Field._dtype.
    END.
    IF qbf-a THEN
      qbf-o = qbf-o + (IF qbf-o = "" THEN "" ELSE ",") + qbf-x + ":" + qbf-y.
  END.
END.

IF qbf-o <> "" THEN DO:
  OUTPUT TO VALUE(qbf-tempdir + ".p") NO-ECHO NO-MAP.
  PUT UNFORMATTED
    '/* ' qbf-o ' */' SKIP
    'DEFINE SHARED BUFFER ' qbf-file[qbf-p]
      ' FOR ' qbf-db[qbf-p] '.' qbf-file[qbf-p] '.' SKIP
    'DEFINE SHARED BUFFER ' qbf-file[qbf-p - 1]
      ' FOR ' qbf-db[qbf-p - 1] '.' qbf-file[qbf-p - 1] '.' SKIP.

  IF NUM-ENTRIES(qbf-o) > 1 THEN PUT UNFORMATTED 'ASSIGN' SKIP '  '.
  DO qbf-i = 1 TO NUM-ENTRIES(qbf-o):
    ASSIGN
      qbf-c = ENTRY(qbf-i,qbf-o)
      qbf-x = SUBSTRING(qbf-c,1,INDEX(qbf-c + ":",":") - 1)
      qbf-y = SUBSTRING(qbf-c,R-INDEX(qbf-c,":") + 1).
    PUT UNFORMATTED
      (IF qbf-i > 1 THEN '  ' ELSE '')
      qbf-db[qbf-p] '.' qbf-file[qbf-p] '.' qbf-y ' = '
      qbf-db[qbf-p - 1] '.' qbf-file[qbf-p - 1] '.' qbf-x
      (IF qbf-i = NUM-ENTRIES(qbf-o) THEN '.' ELSE '') SKIP.
  END.
  OUTPUT CLOSE.

  COMPILE VALUE(qbf-tempdir + ".p") NO-ATTR-SPACE.
  RUN VALUE(qbf-tempdir + ".p").
END.

RETURN.
