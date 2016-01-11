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
