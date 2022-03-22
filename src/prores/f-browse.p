/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* f-browse.p - make best guess for browse fields */

{ prores/s-system.i }

DEFINE INPUT  PARAMETER qbf-d AS CHARACTER NO-UNDO. /* db name */
DEFINE INPUT  PARAMETER qbf-x AS CHARACTER NO-UNDO. /* file name */
DEFINE INPUT  PARAMETER qbf-f AS CHARACTER NO-UNDO. /* comma-sep fields */
DEFINE OUTPUT PARAMETER qbf-b AS CHARACTER NO-UNDO. /* comma-sep browse flds */

DEFINE VARIABLE qbf-j AS INTEGER NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER NO-UNDO.

DEFINE WORKFILE qbf-w NO-UNDO
  FIELD qbf-i AS LOGICAL   /* index component? */
  FIELD qbf-n AS CHARACTER /* like DICTDB._Field._Field-name */
  FIELD qbf-o AS INTEGER   /* like DICTDB._Field._Order */
  FIELD qbf-s AS INTEGER.  /* size */

{ prores/s-alias.i
  &prog=prores/f-browse.p
  &dbname=qbf-d
  &params="(qbf-d,qbf-x,qbf-f,OUTPUT qbf-b)"
}

/* filter out sql92 tables and views */
IF INTEGER(DBVERSION("QBF$0":U)) > 8 THEN
  FIND FIRST QBF$0._File OF QBF$0._Db
    WHERE QBF$0._File._File-name = qbf-x AND
   (QBF$0._File._Owner = "PUB":U OR QBF$0._File._Owner = "_FOREIGN":U)
    NO-LOCK NO-ERROR.
ELSE 
  FIND FIRST QBF$0._File OF QBF$0._Db
    WHERE QBF$0._File._File-name = qbf-x NO-LOCK NO-ERROR.

/* first strip off "dbname." and "filename." from fieldnames if present */
ASSIGN
  qbf-b = qbf-f
  qbf-f = "".
DO qbf-j = 1 TO NUM-ENTRIES(qbf-b):
  qbf-f = qbf-f + (IF qbf-j = 1 THEN "" ELSE ",")
        + SUBSTRING(ENTRY(qbf-j,qbf-b),R-INDEX(ENTRY(qbf-j,qbf-b),".") + 1).
END.

ASSIGN
  qbf-b = ""
  qbf-l = 0.
FOR EACH QBF$0._Field OF QBF$0._File
  WHERE CAN-DO(qbf-f,QBF$0._Field._Field-name)
    AND QBF$0._Field._Extent = 0
    AND QBF$0._Field._dtype < 6 NO-LOCK
  BY QBF$0._Field._Order:
  ASSIGN
    qbf-j = QBF$0._Field._dtype
    qbf-j = MAXIMUM(
            { prores/s-size.i &type=qbf-j &format=QBF$0._Field._Format },
            LENGTH(IF QBF$0._Field._Col-label <> ? THEN QBF$0._Field._Col-label
              ELSE IF QBF$0._Field._Label     <> ? THEN QBF$0._Field._Label
              ELSE QBF$0._Field._Field-name)
            ).
  IF qbf-j > 77 THEN NEXT.
  CREATE qbf-w.
  ASSIGN
    qbf-w.qbf-i = CAN-FIND(FIRST QBF$0._Index-field OF QBF$0._Field)
    qbf-w.qbf-n = QBF$0._Field._Field-name
    qbf-w.qbf-o = QBF$0._Field._Order
    qbf-w.qbf-s = qbf-j + 2 /* ATTR-SPACEs */
    qbf-l       = qbf-l + qbf-j + 2
    qbf-b       = qbf-b + (IF qbf-b = "" THEN "" ELSE ",") + qbf-w.qbf-n.
END.

/* if all fields can fit on one line, then entire record is BROWSEd */
IF qbf-l < 79 THEN RETURN.

ASSIGN
  qbf-b = ""
  qbf-l = 0.
FOR EACH qbf-w WHERE qbf-w.qbf-i: /* already in _Order order */
  IF qbf-l + qbf-w.qbf-s > 77 THEN LEAVE.
  ASSIGN
    qbf-l = qbf-l + qbf-w.qbf-s
    qbf-b = qbf-b + (IF qbf-b = "" THEN "" ELSE ",") + qbf-w.qbf-n.
END.

/* if any index components, then they are BROWSEd */
IF qbf-b <> "" AND qbf-l < 79 THEN RETURN.

ASSIGN
  qbf-b = ""
  qbf-l = 0.
FOR EACH qbf-w: /* already in _Order order */
  IF qbf-l + qbf-w.qbf-s > 77 THEN LEAVE.
  ASSIGN
    qbf-l = qbf-l + qbf-w.qbf-s
    qbf-b = qbf-b + (IF qbf-b = "" THEN "" ELSE ",") + qbf-w.qbf-n.
END.

RETURN.
