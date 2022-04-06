/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* l-verify.p - look over current label fields for problems */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }
{ prores/t-set.i &mod=l &set=1 }

DEFINE OUTPUT PARAMETER qbf-b AS CHARACTER INITIAL "" NO-UNDO.

DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-e AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-h AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER   NO-UNDO. /* left curly-brace */
DEFINE VARIABLE qbf-r AS INTEGER   NO-UNDO. /* right curly-brace */
DEFINE VARIABLE qbf-s AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER NO-UNDO.

IF qbf-file[1] = "" THEN DO:
  ASSIGN
    qbf-l-text = ""
    qbf-where  = ""
    qbf-order  = "".
  RETURN.
END.

/* check for balanced brackets and available fields */
DO qbf-h = 1 TO { prores/s-limlbl.i }:
  ASSIGN
    qbf-t = qbf-l-text[qbf-h]
    qbf-l = INDEX(qbf-t,qbf-left)
    qbf-r = INDEX(qbf-t,qbf-right).
  IF qbf-t = "" THEN NEXT.

  DO WHILE qbf-l > 0 OR qbf-r > 0:

    IF qbf-l = 0 OR qbf-r = 0 OR qbf-l > qbf-r THEN DO:
      /*Line {1}: Unbalanced or missing brace.*/
      ASSIGN
        qbf-b = qbf-lang[6]
        SUBSTRING(qbf-b,INDEX(qbf-b,"~{1~}"),3) = STRING(qbf-h).
      RETURN.
    END.

    ASSIGN
      qbf-c = SUBSTRING(qbf-t,qbf-l + 1,qbf-r - qbf-l - 1)
      qbf-e = 0
      qbf-t = SUBSTRING(qbf-t,qbf-r + 1)
      qbf-l = INDEX(qbf-t,qbf-left)
      qbf-r = INDEX(qbf-t,qbf-right).

    IF qbf-c = "TODAY" THEN NEXT.

    IF qbf-c MATCHES "*[*]" THEN DO:
      DO qbf-i = INDEX(qbf-c,"[") + 1 TO LENGTH(qbf-c) - 1:
        qbf-s = SUBSTRING(qbf-s,qbf-i,1).
        IF INDEX("0123456789",qbf-s) > 0 THEN
          qbf-e = qbf-e * 10 + INTEGER(qbf-s).
      END.
      qbf-c = SUBSTRING(qbf-c,1,INDEX(qbf-c,"[") - 1).
    END.

    ASSIGN
      qbf-i = INDEX(qbf-c,".")
      qbf-j = R-INDEX(qbf-c,".").
    IF qbf-i = 0 THEN /* no file or db qualifier */
      DO qbf-i = 1 TO 5 WHILE qbf-file[qbf-i] <> "":
        RUN prores/s-lookup.p
          (qbf-db[qbf-i],qbf-file[qbf-i],qbf-c,"FIELD:RECID",OUTPUT qbf-s).
        IF qbf-s = ? THEN NEXT.
        qbf-c = qbf-db[qbf-i] + "." + qbf-file[qbf-i] + "." + qbf-c.
      END.
    ELSE
    IF qbf-i = qbf-j THEN /* no db qualifier */
      DO qbf-i = 1 TO 5 WHILE qbf-file[qbf-i] <> "":
        IF qbf-file[qbf-i] <> SUBSTRING(qbf-c,1,qbf-j - 1) THEN NEXT.
        qbf-c = qbf-db[qbf-i] + "." + qbf-c.
      END.

    IF R-INDEX (qbf-c, ".") > 0 THEN
      qbf-s = SUBSTRING(qbf-c,1,R-INDEX(qbf-c,".") - 1).

    IF qbf-s <> qbf-db[1] + "." + qbf-file[1]
      AND qbf-s <> qbf-db[2] + "." + qbf-file[2]
      AND qbf-s <> qbf-db[3] + "." + qbf-file[3]
      AND qbf-s <> qbf-db[4] + "." + qbf-file[4]
      AND qbf-s <> qbf-db[5] + "." + qbf-file[5] THEN DO:
      /*Line {2}: field "{1}", from unselected file.*/
      ASSIGN
        qbf-b = qbf-lang[10]
        SUBSTRING(qbf-b,INDEX(qbf-b,"~{1~}"),3) = qbf-c
        SUBSTRING(qbf-b,INDEX(qbf-b,"~{2~}"),3) = STRING(qbf-h).
      RETURN.
    END.

    RUN prores/s-lookup.p
      (qbf-c,"","","FIELD:RECID",OUTPUT qbf-s).

    IF qbf-s = ? THEN DO:
      /*Line {2}: Unable to find field "{1}".*/
      ASSIGN
        qbf-b = qbf-lang[7]
        SUBSTRING(qbf-b,INDEX(qbf-b,"~{1~}"),3) = qbf-c
        SUBSTRING(qbf-b,INDEX(qbf-b,"~{2~}"),3) = STRING(qbf-h).
      RETURN.
    END.

    qbf-s = "0".
    IF qbf-e > 0 THEN 
      RUN prores/s-lookup.p (qbf-c,"","","FIELD:EXTENT",OUTPUT qbf-s).
    IF INTEGER(qbf-s) < qbf-e THEN DO:
      /*Line {2}: Field "{1}", not an array field.*/
      /*Line {2}: Field "{1}", extent {3} out of range.*/
      ASSIGN
        qbf-b = qbf-lang[IF INTEGER(qbf-s) = 0 THEN 8 ELSE 9]
        SUBSTRING(qbf-b,INDEX(qbf-b,"~{1~}"),3) = qbf-c
        SUBSTRING(qbf-b,INDEX(qbf-b,"~{2~}"),3) = STRING(qbf-h).
      IF INDEX(qbf-b,"~{3~}") > 0 THEN
        SUBSTRING(qbf-b,INDEX(qbf-b,"~{3~}"),3) = qbf-s.
      RETURN.
    END.

  END. /* for each part of line */

END. /* for each line */

RETURN.
