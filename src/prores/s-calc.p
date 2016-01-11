/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-calc.p - generate calculated field expressions */

{ prores/s-system.i }
{ prores/t-define.i }

DEFINE INPUT  PARAMETER qbf-f AS CHARACTER NO-UNDO. /* files */
DEFINE INPUT  PARAMETER qbf-g AS CHARACTER NO-UNDO. /* group */
DEFINE OUTPUT PARAMETER qbf-o AS CHARACTER NO-UNDO. /* output expr */

DEFINE VARIABLE qbf-a  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-b  AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-c  AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i  AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j  AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-k  AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-m  AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-p  AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-r  AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-t  AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-v  AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-v2 AS DECIMAL   NO-UNDO.
DEFINE VARIABLE qbf-v3 AS DATE      NO-UNDO.
DEFINE VARIABLE qbf-v4 AS LOGICAL   NO-UNDO.

DEFINE VARIABLE qbf-syntax AS CHARACTER EXTENT 32 NO-UNDO.

{ prores/c-field.i
  &new=NEW &down=13 &row="ROW 3" &column="COLUMN 36"
  &title="' ' + qbf-lang[14] + ' '"
}
/*title="Choose a Field"*/

/* grab appropriate syntax and explanations */
IF      qbf-g = "s" THEN DO: { prores/t-set.i &mod=s &set=5 } END.
ELSE IF qbf-g = "n" THEN DO: { prores/t-set.i &mod=s &set=6 } END.
ELSE IF qbf-g = "d" THEN DO: { prores/t-set.i &mod=s &set=7 } END.
ELSE IF qbf-g = "m" THEN DO: { prores/t-set.i &mod=s &set=8 } END.
DO qbf-i = 1 TO 32:
  qbf-syntax[qbf-i] = qbf-lang[qbf-i].
END.

/* load up real set */
{ prores/t-set.i &mod=s &set=3 }

/* set,label,types,expression */
/* semi-colon ";" represents comma "," */

FORM qbf-c FORMAT "x(78)" SKIP
  WITH OVERLAY FRAME qbf-build ROW 2 NO-LABELS WIDTH 80 NO-ATTR-SPACE 14 DOWN
  TITLE COLOR NORMAL " " + qbf-lang[27] + " ". /*Expression Builder*/

FORM qbf-t FORMAT "x(78)" SKIP qbf-v FORMAT "x(78)" SKIP
  WITH OVERLAY FRAME qbf-output ROW 18 NO-LABELS WIDTH 80 NO-ATTR-SPACE
  TITLE COLOR NORMAL " " + qbf-lang[28] + " ". /*Expression*/

FORM
  qbf-v FORMAT "x(40)" SKIP
  WITH FRAME qbf--str OVERLAY ATTR-SPACE NO-LABELS NO-BOX
  ROW FRAME-LINE(qbf-build) + 2 COLUMN 35.
FORM
  qbf-v2 FORMAT "->>>,>>>,>>9.9<<<<<<<<<" SKIP
  WITH FRAME qbf--num OVERLAY ATTR-SPACE NO-LABELS NO-BOX
  ROW FRAME-LINE(qbf-build) + 2 COLUMN 64.
FORM
  qbf-v3 SKIP /* use default format for dates */
  WITH FRAME qbf--dat OVERLAY ATTR-SPACE NO-LABELS NO-BOX
  ROW FRAME-LINE(qbf-build) + 2 COLUMN 65.
FORM
  qbf-v4 SKIP /* use default format for logicals */
  WITH FRAME qbf--log OVERLAY ATTR-SPACE NO-LABELS NO-BOX
  ROW FRAME-LINE(qbf-build) + 2 COLUMN 65.

VIEW FRAME qbf-build.
VIEW FRAME qbf-output.
HIDE FRAME qbf-pick NO-PAUSE.

ASSIGN
  qbf-a = ? /* ?=first time,true=continuing expression */
  qbf-k = 0
  qbf-r = "x=xxx".
/*message "here again". hide message.*/

DO qbf-i = INDEX(qbf-r,"=") + 1 TO LENGTH(qbf-r) BY 3: /*##*/

/*message "a" qbf-a qbf-i qbf-r.  hide message.*/
  qbf-c = SUBSTRING(qbf-r,qbf-i,3). /*##*/
  IF SUBSTRING(qbf-c,2) = ".." THEN DO:
    ASSIGN
      qbf-a = FALSE
      qbf-v = "(" + SUBSTRING(qbf-o,3) + ")".
    RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,"#29").
    /*Continue adding to this expression?*/
    IF NOT qbf-a THEN LEAVE.
    qbf-g = SUBSTRING(qbf-c,1,1).
  END.

  IF qbf-a OR qbf-a = ? THEN DO:
    /* extract and display menu */
    ASSIGN
      qbf-c = ""
      qbf-b = "".
    DO qbf-i = 1 TO 32 WHILE qbf-syntax[qbf-i] <> "":
      IF SUBSTRING(qbf-syntax[qbf-i],1,2) = qbf-g + "," THEN
        qbf-c = qbf-c + (IF qbf-c = "" THEN "" ELSE ",")
              + ENTRY(2,qbf-syntax[qbf-i]).
    END.
    RUN prores/c-entry.p
      (qbf-c,"r003c015b" + qbf-lang[30],OUTPUT qbf-p).
    /*qbf-lang[30]="Select Operation"*/
    IF qbf-p = 0 THEN DO:
      qbf-o = ?.
      LEAVE.
    END.
    /* change semi-colons ";" into commas "," */
    ASSIGN
      qbf-r = ENTRY(3,qbf-syntax[qbf-p])
      qbf-o = SUBSTRING(qbf-r,1,1) + "=" + ENTRY(4,qbf-syntax[qbf-p])
      qbf-j = INDEX(qbf-o,";")
      qbf-i = INDEX(qbf-r,"=") + 1 - 3. /*##*/
    DO WHILE qbf-j > 0:
      ASSIGN
        SUBSTRING(qbf-o,qbf-j,1) = ","
        qbf-j = INDEX(qbf-o,";").
    END.
/*message "b" qbf-a qbf-i qbf-r.  hide message.*/
  END.

  IF qbf-a = ? THEN DO:
    qbf-a = FALSE.
    NEXT.
  END.
  IF qbf-a THEN DO:
    ASSIGN /*insert "(" + qbf-o + ")" as {1}*/
      qbf-k = 1
      qbf-i = qbf-i + 3 /*##*/
      qbf-a = FALSE
      qbf-j = INDEX(qbf-o,"~{1~}").
    DO WHILE qbf-j > 0:
      ASSIGN
        SUBSTRING(qbf-o,qbf-j,LENGTH(STRING(qbf-k)) + 2) = qbf-v
        qbf-j = INDEX(qbf-o,"~{1~}").
    END.
    NEXT.  /*continue with above loop*/
  END.

  ASSIGN
    qbf-a = FALSE
    qbf-j = INTEGER(SUBSTRING(qbf-c,2)).

  IF qbf-j > 0 THEN DO:
    ASSIGN
      qbf-c = qbf-syntax[qbf-j]
      qbf-m = "".
    DO WHILE LENGTH(qbf-c) > 76:
      qbf-j = R-INDEX(SUBSTRING(qbf-c,1,76)," ").
      IF qbf-j = 0 THEN qbf-j = 76.
      DISPLAY SUBSTRING(qbf-c,1,qbf-j) @ qbf-c WITH FRAME qbf-build.
      qbf-m = STRING(SUBSTRING(qbf-c,1,qbf-j),"x(80)").
      DOWN 1 WITH FRAME qbf-build.
      qbf-c = SUBSTRING(qbf-c,qbf-j + 1).
    END.
    IF qbf-c <> "" THEN DO:
      DISPLAY qbf-c @ qbf-c WITH FRAME qbf-build.
      qbf-m = qbf-m + qbf-c.
      DOWN 1 WITH FRAME qbf-build.
    END.
  END.
  qbf-m = STRING(qbf-m,"x(160)").

  PUT SCREEN ROW SCREEN-LINES + 1 COLUMN 1 COLOR MESSAGES
    SUBSTRING(qbf-m, 1,78).
  PUT SCREEN ROW SCREEN-LINES + 2 COLUMN 1 COLOR MESSAGES
    SUBSTRING(qbf-m,81,78).
  ASSIGN
    qbf-c = SUBSTRING(ENTRY(3,qbf-syntax[qbf-p]),qbf-i,1)
    qbf-t = (IF qbf-c = "s" THEN "character"
        ELSE IF qbf-c = "n" THEN "decimal,integer"
        ELSE IF qbf-c = "d" THEN "date"
        ELSE                     "logical")
    qbf-v = "".
  /*31:"today's date"  32:"constant value"*/
  PAUSE 0.
  VIEW FRAME qbf-pick.
  RUN prores/s-field.p
    (qbf-f,qbf-lang[IF qbf-c = "d" THEN 31 ELSE 32],qbf-t,INPUT-OUTPUT qbf-v).
  IF qbf-v MATCHES "*~~.qbf-*" THEN
    qbf-v = SUBSTRING(qbf-v,INDEX(qbf-v,".qbf-") + 1).
  PUT SCREEN ROW SCREEN-LINES + 1 COLUMN 1 FILL(" ",78).
  PUT SCREEN ROW SCREEN-LINES + 2 COLUMN 1 FILL(" ",78).
  PAUSE 0.
  IF qbf-v = "" OR qbf-v = ? THEN qbf-v = ?.
  ELSE
  IF qbf-v MATCHES "*<<*>>*" THEN DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
    qbf-v = ?.
    HIDE FRAME qbf-pick.
    IF qbf-c BEGINS "s" THEN DO:
      DISPLAY "" @ qbf-v WITH FRAME qbf--str.
      SET qbf-v WITH FRAME qbf--str.
      IF qbf-v MATCHES '"*"' THEN qbf-v = SUBSTRING(qbf-v,2,LENGTH(qbf-v) - 2).
      RUN prores/s-quote.p (qbf-v,'"',OUTPUT qbf-v).
    END.
    ELSE
    IF qbf-c BEGINS "l" THEN DO:
      UPDATE qbf-v4 WITH FRAME qbf--log.
      qbf-v = STRING(qbf-v4,"TRUE/FALSE").
    END.
    ELSE
    IF qbf-c BEGINS "d" THEN DO:
      qbf-v = "TODAY".
      /*
      UPDATE qbf-v3 WITH FRAME qbf--dat.
      qbf-v = "DATE(" + STRING(MONTH(qbf-v3))
            + ","     + STRING(DAY(qbf-v3))
            + ","     + STRING(YEAR(qbf-v3)) + ")".
      */
    END.
    ELSE
    IF qbf-c BEGINS "n" THEN DO:
      UPDATE qbf-v2 WITH FRAME qbf--num.
      /* handle -E (-,) -999,9 or -999.9 */
      qbf-v = (IF qbf-v2 > -1 AND qbf-v2 < 0 THEN "-" ELSE "")
            + STRING(TRUNCATE(qbf-v2,0))
            + (IF qbf-v2 = TRUNCATE(qbf-v2,0) THEN "" ELSE ".")
            + SUBSTRING(STRING(qbf-v2 - TRUNCATE(qbf-v2,0)),
              IF qbf-v2 < 0 THEN 3 ELSE 2).
    END.
    IF qbf-v = ? THEN qbf-v = "?".
  END.
  HIDE FRAME qbf--dat NO-PAUSE.
  HIDE FRAME qbf--log NO-PAUSE.
  HIDE FRAME qbf--num NO-PAUSE.
  HIDE FRAME qbf--str NO-PAUSE.
  HIDE FRAME qbf-pick NO-PAUSE.

  IF qbf-v = ? THEN DO:
    qbf-o = ?.
    LEAVE.
  END.

  PAUSE 0.
  DISPLAY FILL(" ",77 - LENGTH(qbf-v)) + qbf-v @ qbf-c WITH FRAME qbf-build.
  DOWN 1 WITH FRAME qbf-build.
  DISPLAY FILL("-",78) @ qbf-c WITH FRAME qbf-build.
  DOWN 1 WITH FRAME qbf-build.
  ASSIGN
    qbf-k = qbf-k + 1
    qbf-j = INDEX(qbf-o,"~{" + STRING(qbf-k) + "~}").
  DO WHILE qbf-j > 0:
    ASSIGN
      SUBSTRING(qbf-o,qbf-j,LENGTH(STRING(qbf-k)) + 2) = qbf-v
      qbf-j = INDEX(qbf-o,"~{" + STRING(qbf-k) + "~}").
  END.
  DISPLAY SUBSTRING(qbf-o,3,78) @ qbf-t SUBSTRING(qbf-o,81) @ qbf-v
    WITH FRAME qbf-output.
END.

HIDE FRAME qbf-output NO-PAUSE.
HIDE FRAME qbf-build  NO-PAUSE.
HIDE FRAME qbf-pick   NO-PAUSE.
{ prores/t-reset.i }
RETURN.
