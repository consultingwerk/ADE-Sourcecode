/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* f-guess.p - makes judgement calls for which fields go on forms */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/a-define.i }

DEFINE INPUT        PARAMETER qbf-b AS LOGICAL   NO-UNDO. /* trim? */
DEFINE INPUT-OUTPUT PARAMETER qbf-c AS CHARACTER NO-UNDO. /* field lst */

DEFINE WORKFILE qbf-w NO-UNDO
  FIELD qbf-a AS CHARACTER /*array*/
  FIELD qbf-e AS INTEGER   /*extent*/
  FIELD qbf-l AS CHARACTER /*label*/
  FIELD qbf-n AS CHARACTER /*name*/
  FIELD qbf-o AS DECIMAL DECIMALS 5 /* used for ranking arrays */
  FIELD qbf-s AS INTEGER   /*size*/
  FIELD qbf-t AS INTEGER.  /*type*/

DEFINE VARIABLE qbf-g AS LOGICAL            NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-q AS INTEGER INITIAL  0 NO-UNDO.
DEFINE VARIABLE qbf-u AS INTEGER INITIAL 17 NO-UNDO.
DEFINE VARIABLE qbf-x AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-y AS INTEGER            NO-UNDO.

{ prores/s-alias.i
  &prog=prores/f-guess.p
  &dbname=qbf-db[1]
  &params="(qbf-b,INPUT-OUTPUT qbf-c)"
}

/*
24x80 -> 17 lines, because:
  screen-lines - status-lines - message-lines - box - menustrip
  24 - 1 - 2 - 2 - 2 = 17
*/

/* filter out sql92 tables and views */
IF INTEGER(DBVERSION("QBF$0":U)) > 8 THEN
  FIND QBF$0._File OF QBF$0._Db
    WHERE QBF$0._File._File-name = qbf-file[1] AND
   (QBF$0._File._Owner = "PUB":U OR QBF$0._File._Owner = "_FOREIGN":U)
    NO-LOCK.
ELSE 
  FIND QBF$0._File OF QBF$0._Db
    WHERE QBF$0._File._File-name = qbf-file[1] NO-LOCK.

FOR EACH QBF$0._Field OF QBF$0._File
  WHERE CAN-DO(qbf-c,QBF$0._Field._Field-name)
    AND QBF$0._Field._dtype < 6
  NO-LOCK BY QBF$0._Field._Order:
  ASSIGN
    qbf-q = MAXIMUM(qbf-q,QBF$0._Field._Order)
    qbf-g = FALSE /* oversize flag */
    qbf-j = QBF$0._Field._dtype
    qbf-j = { prores/s-size.i &type=qbf-j &format=QBF$0._Field._Format }.
  IF qbf-j > 76 THEN NEXT. /* too big to deal with */
  DO qbf-i = (IF QBF$0._Field._Extent = 0 THEN 0 ELSE 1)
    TO QBF$0._Field._Extent:
    CREATE qbf-w.
    ASSIGN
      qbf-w.qbf-a = (IF qbf-i = 0 THEN "" ELSE "[" + STRING(qbf-i) + "]")
      qbf-w.qbf-e = QBF$0._Field._Extent
      qbf-w.qbf-l = (IF qbf-g THEN "" ELSE
                      (IF QBF$0._Field._Label = ?
                      THEN QBF$0._Field._Field-name
                      ELSE QBF$0._Field._Label)
                  + qbf-w.qbf-a)
      qbf-w.qbf-n = QBF$0._Field._Field-name + qbf-w.qbf-a
      qbf-w.qbf-o = QBF$0._Field._Order + MAXIMUM(1,qbf-i) * .0001 + .00005
      qbf-w.qbf-s = qbf-j
      qbf-w.qbf-t = QBF$0._Field._dtype.
    IF NOT qbf-g AND LENGTH(qbf-w.qbf-l + qbf-w.qbf-a)
      + 3 + qbf-w.qbf-s > 78 THEN DO:
      ASSIGN
        qbf-g       = TRUE
        qbf-w.qbf-l = "".
      CREATE qbf-w.
      ASSIGN
        qbf-w.qbf-a = ""
        qbf-w.qbf-e = 0
        qbf-w.qbf-l = (IF QBF$0._Field._Label = ?
                      THEN QBF$0._Field._Field-name
                      ELSE QBF$0._Field._Label)
        qbf-w.qbf-n = ?
        qbf-w.qbf-o = QBF$0._Field._Order + MAXIMUM(1,qbf-i) * .0001
        qbf-w.qbf-s = 0
        qbf-w.qbf-t = ?.
    END.
  END.
END.

/* efficient way of blow'in away fields after s-limcol'th field */
IF qbf-b THEN DO:
  ASSIGN
    qbf-i = ?
    qbf-j = 0.
  /* qbf-s(ize)+qbf-l(abel)+qbf-e(xtent) is weight of deletion priority. */
  /* it has no "real world" significance other than that. */
  FOR EACH qbf-w BY qbf-w.qbf-s + LENGTH(qbf-w.qbf-l) + qbf-w.qbf-e:
    IF qbf-w.qbf-n <> ? THEN qbf-j = qbf-j + 1.
    IF qbf-j < { prores/s-limcol.i } THEN NEXT.
    IF qbf-i = ? THEN qbf-i = qbf-w.qbf-o.
    DELETE qbf-w.
  END.
  FOR EACH qbf-w WHERE TRUNCATE(qbf-w.qbf-o,0) = qbf-i:
    DELETE qbf-w. /* catch stragglers */
  END.
END.

/* measure screen real estate needed for this form */
ASSIGN
  qbf-i = qbf-q + 1
  qbf-c = ""
  qbf-x = 1
  qbf-y = 1.
FOR EACH qbf-w BY qbf-w.qbf-o:
  qbf-j = (IF qbf-w.qbf-s = 0 THEN 0 ELSE qbf-w.qbf-s + 2)
        + (IF qbf-w.qbf-l = "" THEN 0 ELSE LENGTH(qbf-w.qbf-l) + 2). /*?1*/
  IF qbf-x + qbf-j > 80 THEN ASSIGN qbf-x = 1 qbf-y = qbf-y + 1.
  /*DISPLAY qbf-x qbf-y qbf-j qbf-n FORMAT 'x(20)' qbf-l FORMAT 'x(20)'.*/
  qbf-x = qbf-x + qbf-j.
  IF qbf-b AND qbf-y > qbf-u THEN LEAVE. /* won't fit on 24x80 screen */
  IF qbf-w.qbf-n <> ? AND CAN-DO(",[1]",qbf-w.qbf-a) THEN
    qbf-c = qbf-c + (IF qbf-c = "" THEN "" ELSE ",")
          + (IF qbf-w.qbf-e = 0 THEN qbf-w.qbf-n ELSE
            SUBSTRING(qbf-w.qbf-n,1,LENGTH(qbf-w.qbf-n) - 3)).
END.

qbf-a-attr[4] = STRING(IF qbf-b THEN MINIMUM(qbf-u,qbf-y) ELSE qbf-y).

RETURN.
