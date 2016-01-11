/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* f-read.p - read in form (as best we can) */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/a-define.i }

DEFINE OUTPUT PARAMETER qbf-f AS CHARACTER INITIAL "" NO-UNDO.

DEFINE         VARIABLE qbf-i AS INTEGER   INITIAL  0 NO-UNDO.
DEFINE         VARIABLE qbf-m AS CHARACTER EXTENT   5 NO-UNDO.

DEFINE STREAM qbf-io.

{ prores/s-alias.i
  &prog=prores/f-read.p
  &dbname=qbf-db[1]
  &params="(OUTPUT qbf-f)"
}

/* filter out sql92 tables and views */
IF INTEGER(DBVERSION("QBF$0":U)) > 8 THEN
  FIND FIRST QBF$0._File OF QBF$0._Db
    WHERE QBF$0._File._File-name = qbf-file[1] AND
   (QBF$0._File._Owner = "PUB":U OR QBF$0._File._Owner = "_FOREIGN":U)
    NO-LOCK.
ELSE 
  FIND FIRST QBF$0._File OF QBF$0._Db
    WHERE QBF$0._File._File-name = qbf-file[1] NO-LOCK.

INPUT STREAM qbf-io FROM VALUE(SEARCH(qbf-a-attr[1])) NO-ECHO.
REPEAT:
  qbf-m = "".
  IMPORT STREAM qbf-io qbf-m.

  /* look for frame-name */
  qbf-i = (IF qbf-m[1] = "FRAME" THEN 2
      ELSE IF qbf-m[2] = "FRAME" THEN 3
      ELSE IF qbf-m[3] = "FRAME" THEN 4
      ELSE IF qbf-m[4] = "FRAME" THEN 5 ELSE 0).
  IF qbf-i > 0 THEN DO:
    IF KEYWORD(qbf-m[qbf-i]) = ? THEN qbf-a-attr[2] = qbf-m[qbf-i].
    NEXT.
  END.

  /* look for field names */
  IF qbf-m[1] BEGINS QBF$0._Db._Db-name + "." THEN
    qbf-m[1] = SUBSTRING(qbf-m[1],LENGTH(QBF$0._Db._Db-name) + 2).
  IF qbf-m[1] BEGINS QBF$0._File._File-name + "." THEN
    qbf-m[1] = SUBSTRING(qbf-m[1],LENGTH(QBF$0._File._File-name) + 2).
  FIND FIRST QBF$0._Field OF QBF$0._File
    WHERE QBF$0._Field._Field-name = qbf-m[1] NO-LOCK NO-ERROR.
  IF AVAILABLE QBF$0._Field THEN
    qbf-f = qbf-f + (IF qbf-f = "" THEN "" ELSE ",")
          + QBF$0._Field._Field-name.

END.

INPUT STREAM qbf-io CLOSE.
RETURN.
