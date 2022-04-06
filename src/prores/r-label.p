/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* r-label.p - how big is this thing, really? */

/*
qbf-b = column-label
qbf-f = format
qbf-t = datatype
qbf-l = actual width of field
qbf-h = height of label in lines
*/

DEFINE INPUT  PARAMETER qbf-b AS CHARACTER         NO-UNDO.
DEFINE INPUT  PARAMETER qbf-f AS CHARACTER         NO-UNDO.
DEFINE INPUT  PARAMETER qbf-t AS INTEGER           NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-l AS INTEGER INITIAL 1 NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-h AS INTEGER INITIAL 1 NO-UNDO.

DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.

ASSIGN
  qbf-c = qbf-b
  qbf-i = INDEX(qbf-b,"!!").
DO WHILE qbf-i > 0:
  ASSIGN
    SUBSTRING(qbf-c,qbf-i,2) = "/"
    qbf-i = INDEX(qbf-c,"!!").
END.
qbf-i = INDEX(qbf-c,"!").
IF qbf-i = 0 THEN qbf-l = LENGTH(qbf-c).
DO WHILE qbf-i > 0:
  ASSIGN
    qbf-h = qbf-h + 1
    qbf-l = MAXIMUM(qbf-l,qbf-i - 1)
    qbf-c = SUBSTRING(qbf-c,qbf-i + 1)
    qbf-i = INDEX(qbf-c,"!").
  IF qbf-i = 0 THEN qbf-l = MAXIMUM(qbf-l,LENGTH(qbf-c)).
END.

qbf-l = MAXIMUM(qbf-l,{ prores/s-size.i &type=qbf-t &format=qbf-f }).

RETURN.
