/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* q-order.p - pick index for order in query */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/q-define.i }
{ prores/s-menu.i }

DEFINE OUTPUT PARAMETER qbf-e AS INTEGER   INITIAL  4 NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-o AS CHARACTER INITIAL "" NO-UNDO.

DEFINE        VARIABLE  qbf-a AS LOGICAL              NO-UNDO.
DEFINE        VARIABLE  qbf-c AS CHARACTER            NO-UNDO.
DEFINE        VARIABLE  qbf-i AS INTEGER              NO-UNDO.
DEFINE        VARIABLE  qbf-s AS CHARACTER INITIAL "" NO-UNDO.

{ prores/s-alias.i
  &prog=prores/q-order.p
  &dbname=qbf-db[qbf-level]
  &params="(OUTPUT qbf-e,OUTPUT qbf-o)"
}

/* filter out sql92 tables and views */
IF INTEGER(DBVERSION("QBF$0":U)) > 8 THEN
  FIND QBF$0._File
    WHERE QBF$0._File._File-name = qbf-file[qbf-level] AND
   (QBF$0._File._Owner = "PUB":U OR QBF$0._File._Owner = "_FOREIGN":U)
    NO-LOCK.
ELSE 
  FIND QBF$0._File
    WHERE QBF$0._File._File-name = qbf-file[qbf-level] NO-LOCK.

FOR EACH QBF$0._Index OF QBF$0._File WHERE
        QBF$0._Index._Wordidx <> 1 NO-LOCK
  BY QBF$0._Index._Index-name:
  /*BY (IF RECID(QBF$0._Index) = QBF$0._Index._Prime-Index
    THEN "" ELSE QBF$0._Index._Index-name):*/
  ASSIGN
    qbf-a = FALSE
    qbf-c = QBF$0._Index._Index-name + " (".
  FOR EACH QBF$0._Index-field OF QBF$0._Index,
    QBF$0._Field OF QBF$0._Index-field:
    ASSIGN
      qbf-a = TRUE
      qbf-c = qbf-c + QBF$0._Field._Field-name + " ".
  END.
  IF NOT qbf-a THEN qbf-c = qbf-c + "no index components)".
  IF LENGTH(qbf-c) > 32 THEN qbf-c = SUBSTRING(qbf-c,1,28) + "...)".
  ASSIGN
    SUBSTRING(qbf-c,LENGTH(qbf-c),1) = ")"
    qbf-s = qbf-s + (IF qbf-s = "" THEN "" ELSE ",") + qbf-c.
END.

IF qbf-s = "" OR (NOT qbf-a AND NUM-ENTRIES(qbf-s) = 1) THEN RETURN.

ASSIGN
  qbf-c      = qbf-module
  qbf-module = "q15s".
RUN prores/c-entry.p
  (qbf-s,"r004c032b" + ENTRY(15,qbf-m-tbl),OUTPUT qbf-i).
ASSIGN
  qbf-module = qbf-c
  qbf-e      = 0.
IF qbf-i = 0 THEN RETURN.

ASSIGN
  qbf-c     = ENTRY(qbf-i,qbf-s)
  qbf-o     = SUBSTRING(qbf-c,1,INDEX(qbf-c," ") - 1)
  qbf-order = "".

FIND QBF$0._Index OF _File
  WHERE QBF$0._Index._Index-name = qbf-o NO-LOCK NO-ERROR.
FOR EACH QBF$0._Index-field OF QBF$0._Index,
  QBF$0._Field OF QBF$0._Index-field
  WHILE QBF$0._Index-field._Index-Seq <= 5:
  qbf-order[QBF$0._Index-field._Index-Seq]
    = QBF$0._File._File-name + "." + QBF$0._Field._Field-name
    + (IF QBF$0._Index-field._Ascending THEN "" ELSE " DESC").
END.

RETURN.
