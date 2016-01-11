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
/* f-write.p - write out 'default' form */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/a-define.i }

/*
assumes:
  qbf-db[1]=     contains _db-name for _file-name in qbf-file[1]
  qbf-file[1]=   contains _file-name
  qbf-a-attr[1]= form-file.f
  qbf-a-attr[2]= 'form-name= "customer"'
*/

DEFINE INPUT PARAMETER qbf-c AS CHARACTER NO-UNDO. /* field lst */

DEFINE VARIABLE qbf-e AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-g AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO.

DEFINE STREAM qbf-io.

DEFINE WORKFILE qbf-w NO-UNDO
/*FIELD qbf-h AS CHARACTER*/        /* help */
  FIELD qbf-l AS CHARACTER          /* label */
  FIELD qbf-n AS CHARACTER          /* name */
  FIELD qbf-o AS DECIMAL DECIMALS 5 /* used for ranking arrays */
/*FIELD qbf-t AS CHARACTER*/        /* format */
  FIELD qbf-v AS CHARACTER          /* valmsg */
  FIELD qbf-x AS CHARACTER.         /* valexp */

{ prores/s-alias.i
  &dbname=qbf-db[1]
  &prog=prores/f-write.p
  &params=(qbf-c)
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

FOR EACH QBF$0._Field OF QBF$0._File
  WHERE CAN-DO(qbf-c,QBF$0._Field._Field-name)
    AND QBF$0._Field._dtype < 6
  NO-LOCK BY QBF$0._Field._Order:
  ASSIGN
    qbf-g = FALSE /* oversize flag */
    qbf-j = QBF$0._Field._dtype
    qbf-j = { prores/s-size.i &type=qbf-j &format=QBF$0._Field._Format }.
  DO qbf-i = (IF QBF$0._Field._Extent = 0 THEN 0 ELSE 1)
    TO QBF$0._Field._Extent:
    CREATE qbf-w.
    ASSIGN
      qbf-e       = (IF qbf-i = 0 THEN "" ELSE "[" + STRING(qbf-i) + "]")
      qbf-w.qbf-l = (IF qbf-g THEN "" ELSE
                      (IF QBF$0._Field._Label = ?
                      THEN QBF$0._Field._Field-name
                      ELSE QBF$0._Field._Label)
                  + qbf-e)
      qbf-w.qbf-n = QBF$0._Field._Field-name + qbf-e
      qbf-w.qbf-o = (IF qbf-c = "*" THEN QBF$0._Field._Order
                    ELSE LOOKUP(QBF$0._Field._Field-name,qbf-c) * 10)
                  + MAXIMUM(1,qbf-i) * .0001 + .00005
      qbf-w.qbf-v = (IF qbf-w.qbf-x = ? THEN ? ELSE QBF$0._Field._Valmsg)
      qbf-w.qbf-x = (IF QBF$0._Field._Valexp = "" THEN ?
                    ELSE "qbf-edit OR (" + QBF$0._Field._Valexp + ")").
    /*qbf-w.qbf-h = (IF QBF$0._Field._Help = "" THEN ?
                    ELSE QBF$0._Field._Help)*/
    /*qbf-w.qbf-t = QBF$0._Field._Format*/
    IF NOT qbf-g AND LENGTH(qbf-w.qbf-l + qbf-e) + 3 + qbf-j > 78 THEN DO:
      ASSIGN
        qbf-g       = TRUE
        qbf-w.qbf-l = "".
      CREATE qbf-w.
      ASSIGN
        qbf-w.qbf-l = (IF QBF$0._Field._Label = ?
                      THEN QBF$0._Field._Field-name
                      ELSE QBF$0._Field._Label)
        qbf-w.qbf-n = ?
        qbf-w.qbf-o = (IF qbf-c = "*" THEN QBF$0._Field._Order
                    ELSE LOOKUP(QBF$0._Field._Field-name,qbf-c) * 10)
                    + MAXIMUM(1,qbf-i) * .0001
        qbf-w.qbf-v = ?
        qbf-w.qbf-x = ?.
      /*qbf-w.qbf-h = ?*/
      /*qbf-w.qbf-t = ?*/
    END.
  END.
END.

qbf-i = 0.
FOR EACH qbf-w BY qbf-w.qbf-o:

  IF qbf-i = 0 THEN DO:
    ASSIGN
      qbf-e = SEARCH(qbf-a-attr[1])
      qbf-e = (IF qbf-e = ? THEN qbf-a-attr[1] ELSE qbf-e).
    OUTPUT STREAM qbf-io TO VALUE(qbf-e) NO-ECHO NO-MAP.
    PUT STREAM qbf-io UNFORMATTED
      '/*' SKIP
      'config= frame' SKIP
      'version= ' qbf-vers SKIP
      'file1= "' qbf-db[1] '.' qbf-file[1] '"' SKIP
      '*/' SKIP(1)
      'FORM'.
  END.

  IF qbf-w.qbf-n = ? AND qbf-w.qbf-l <> "" AND qbf-w.qbf-l <> ? THEN DO:
    IF qbf-w.qbf-l <> "" THEN
      RUN prores/s-quote.p (INPUT qbf-w.qbf-l,'"',OUTPUT qbf-w.qbf-l).
    PUT STREAM qbf-io UNFORMATTED SKIP '  ' qbf-w.qbf-l.
  END.

  IF qbf-w.qbf-n <> ? THEN DO:
    PUT STREAM qbf-io UNFORMATTED SKIP
        ' ' /*qbf-db[1] '.'*/ qbf-file[1] '.' qbf-w.qbf-n ' VIEW-AS FILL-IN'.

    IF qbf-w.qbf-l = "" THEN 
      PUT STREAM qbf-io UNFORMATTED ' NO-LABEL'.

    IF qbf-w.qbf-x <> ? THEN DO:
      IF qbf-w.qbf-v <> ? THEN
        RUN prores/s-quote.p (INPUT qbf-w.qbf-v,?,OUTPUT qbf-w.qbf-v).
      PUT STREAM qbf-io UNFORMATTED SKIP
        '    VALIDATE(' qbf-w.qbf-x ',' SKIP
        '            "' qbf-w.qbf-v '")'.
    END.
  END.

  qbf-i = qbf-i + 1.
  IF qbf-i MODULO 5 = 0 THEN
    PUT STREAM qbf-io UNFORMATTED
      SKIP '  WITH FRAME ' LC(qbf-a-attr[2]) '.' SKIP 'FORM'.
  DELETE qbf-w. /* save ram */
END.

IF qbf-i > 0 THEN DO:
  PUT STREAM qbf-io UNFORMATTED SKIP
    '  WITH FRAME ' LC(qbf-a-attr[2])
      ' ATTR-SPACE SIDE-LABELS TITLE qbf-title' SKIP
    '  COLUMN 1 '
      'ROW MINIMUM(qbf-level * 2 + 1,SCREEN-LINES - '
      INTEGER(qbf-a-attr[4]) + 1 ').' SKIP.
  OUTPUT STREAM qbf-io CLOSE.
END.

RETURN.
