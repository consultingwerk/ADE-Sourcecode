/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* c-entry.p - scrolling list using comma-sep-list as argument */

{ prores/s-system.i }
{ prores/t-define.i }

DEFINE INPUT  PARAMETER qbf-e AS CHARACTER         NO-UNDO. /* entry list */
DEFINE INPUT  PARAMETER qbf-g AS CHARACTER         NO-UNDO. /* options */
DEFINE OUTPUT PARAMETER qbf-o AS INTEGER INITIAL 0 NO-UNDO. /* output number */

/*local:*/
DEFINE VARIABLE qbf-c AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-d AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-f AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-m AS INTEGER                NO-UNDO. /* ulimit */
DEFINE VARIABLE qbf-p AS INTEGER   INITIAL   ?  NO-UNDO.
DEFINE VARIABLE qbf-r AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-s AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER INITIAL   "" NO-UNDO.
DEFINE VARIABLE qbf-w AS LOGICAL   INITIAL TRUE NO-UNDO.
DEFINE VARIABLE qbf-x AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-y AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-z AS CHARACTER              NO-UNDO.

/*forms:*/
FORM
  qbf-t FORMAT "x(32)"
  WITH FRAME qbf-pick SCROLL 1 OVERLAY NO-LABELS ATTR-SPACE
  qbf-d DOWN ROW qbf-y COLUMN qbf-c
  COLOR DISPLAY VALUE(qbf-plo) PROMPT VALUE(qbf-phi)
  TITLE COLOR VALUE(qbf-plo) qbf-g.

FORM
  qbf-t FORMAT "x(32)"
  WITH FRAME qbf-type OVERLAY NO-LABELS ATTR-SPACE
  ROW qbf-y + qbf-d + 2 COLUMN qbf-c
  COLOR DISPLAY VALUE(qbf-plo) PROMPT VALUE(qbf-phi).

qbf-m = NUM-ENTRIES(qbf-e).

IF qbf-m <= 0 THEN RETURN.
{ prores/t-set.i &mod=c &set=0 }

ASSIGN
  qbf-f = 1
  qbf-r = 1
  qbf-d = SCREEN-LINES - 11.
IF qbf-f <> 0 AND qbf-f <> ? AND qbf-f <= qbf-m THEN
  ASSIGN
    qbf-p = MINIMUM(qbf-d,qbf-f)
    qbf-r = qbf-f.

DO WHILE qbf-g <> "":
  IF SUBSTRING(qbf-g,1,1) = "r" THEN ASSIGN
    qbf-y = INTEGER(SUBSTRING(qbf-g,2,3))
    qbf-g = SUBSTRING(qbf-g,5).
  ELSE
  IF SUBSTRING(qbf-g,1,1) = "c" THEN ASSIGN
    qbf-c = INTEGER(SUBSTRING(qbf-g,2,3))
    qbf-g = SUBSTRING(qbf-g,5).
  ELSE
  IF SUBSTRING(qbf-g,1,1) = "d" THEN ASSIGN
    qbf-d = INTEGER(SUBSTRING(qbf-g,2,3))
    qbf-g = SUBSTRING(qbf-g,5).
  ELSE
  IF SUBSTRING(qbf-g,1,1) = "b" THEN DO:
    qbf-g = " " + SUBSTRING(qbf-g,2) + " ".
    LEAVE.
  END.
END.

ASSIGN
  qbf-d = MINIMUM(qbf-m,qbf-d)
  qbf-f = 0.

PAUSE 0 BEFORE-HIDE.
VIEW FRAME qbf-pick.

ASSIGN
  qbf-z = FILL("Z",LENGTH(STRING(qbf-m)))
  qbf-x = qbf-c + 34 - LENGTH(qbf-z).
PUT SCREEN ROW qbf-y + qbf-d + 1 COLUMN qbf-x COLOR VALUE(qbf-plo)
  STRING(qbf-m).
qbf-x = qbf-x - LENGTH(qbf-xofy) - 1.
PUT SCREEN ROW qbf-y + qbf-d + 1 COLUMN qbf-x COLOR VALUE(qbf-plo) qbf-xofy.
qbf-x = qbf-x - LENGTH(qbf-z) - 1.

DO WHILE TRUE:

  qbf-r = MINIMUM(qbf-m,MAXIMUM(qbf-r,1)).
  IF qbf-r < FRAME-LINE(qbf-pick) THEN
    DOWN qbf-r - FRAME-LINE(qbf-pick) WITH FRAME qbf-pick.

  IF LENGTH(qbf-t) > 0 THEN
    DISPLAY qbf-t WITH FRAME qbf-type.
  ELSE
    HIDE FRAME qbf-type NO-PAUSE.

  IF qbf-w THEN DO:
    ASSIGN
      qbf-l = MAXIMUM(1,FRAME-LINE(qbf-pick))
      qbf-s = qbf-r - (IF qbf-p = ? THEN qbf-l ELSE qbf-p) + 1.
    UP qbf-l - 1 WITH FRAME qbf-pick.
    IF qbf-s < 1 THEN ASSIGN
      qbf-s = 1
      qbf-l = 1
      qbf-r = 1.
    DO qbf-i = qbf-s TO qbf-s + qbf-d - 1:
      IF qbf-i > qbf-m THEN
        CLEAR FRAME qbf-pick NO-PAUSE.
      ELSE
        DISPLAY ENTRY(qbf-i,qbf-e) @ qbf-t WITH FRAME qbf-pick.
      IF qbf-i < qbf-s + qbf-d - 1 THEN DOWN 1 WITH FRAME qbf-pick.
    END.
    qbf-l = (IF qbf-p = ? THEN qbf-l ELSE qbf-p).
    UP qbf-d - qbf-l WITH FRAME qbf-pick.
    ASSIGN
      qbf-p = ?
      qbf-w  = FALSE.
  END.

  DISPLAY ENTRY(qbf-r,qbf-e) @ qbf-t WITH FRAME qbf-pick.

  PUT SCREEN ROW qbf-y + qbf-d + 1 COLUMN qbf-x
    COLOR VALUE(qbf-plo) STRING(qbf-r,qbf-z).
  COLOR DISPLAY VALUE(qbf-phi) qbf-t WITH FRAME qbf-pick.
  READKEY.
  COLOR DISPLAY VALUE(qbf-plo) qbf-t WITH FRAME qbf-pick.

  IF (KEYFUNCTION(LASTKEY) = CHR(LASTKEY) AND LASTKEY >= 32)
    OR (KEYFUNCTION(LASTKEY) = "BACKSPACE" AND LENGTH(qbf-t) > 0) THEN DO:
    qbf-t = (IF KEYFUNCTION(LASTKEY) = "BACKSPACE"
            THEN SUBSTRING(qbf-t,1,LENGTH(qbf-t) - 1)
            ELSE qbf-t + CHR(LASTKEY)).
    IF qbf-t = "" OR ENTRY(qbf-r,qbf-e) BEGINS qbf-t THEN NEXT.
    DO qbf-l = qbf-r TO qbf-m:
      IF ENTRY(qbf-l,qbf-e) BEGINS qbf-t THEN LEAVE.
    END.
    IF qbf-l > qbf-m THEN DO:
      DO qbf-l = 1 TO qbf-r:
        IF ENTRY(qbf-l,qbf-e) BEGINS qbf-t THEN LEAVE.
      END.
      IF qbf-l > qbf-r THEN qbf-l = qbf-m + 1.
    END.
    IF qbf-l > qbf-m THEN DO:
      qbf-t = CHR(LASTKEY).
      DO qbf-l = 1 TO qbf-m:
        IF ENTRY(qbf-l,qbf-e) BEGINS qbf-t THEN LEAVE.
      END.
    END.
    ASSIGN
      qbf-l = (IF qbf-l <= qbf-m THEN qbf-l ELSE qbf-r)
      qbf-s = qbf-l - qbf-r + FRAME-LINE(qbf-pick)
      qbf-r = qbf-l.
    IF qbf-s < 1 OR qbf-s > qbf-d THEN
      qbf-w = TRUE.
    ELSE
      UP FRAME-LINE(qbf-pick) - qbf-s WITH FRAME qbf-pick.
    NEXT.
  END.

  qbf-t = "".
  IF CAN-DO("CURSOR-DOWN,TAB",KEYFUNCTION(LASTKEY))
    AND qbf-r < qbf-m THEN DO:
    qbf-r = qbf-r + 1.
    IF FRAME-LINE(qbf-pick) = FRAME-DOWN(qbf-pick) THEN
      SCROLL UP WITH FRAME qbf-pick.
    ELSE
      DOWN WITH FRAME qbf-pick.
  END.
  ELSE
  IF CAN-DO("CURSOR-UP,BACK-TAB",KEYFUNCTION(LASTKEY)) AND qbf-r > 1 THEN DO:
    qbf-r = qbf-r - 1.
    IF FRAME-LINE(qbf-pick) = 1 THEN
      SCROLL DOWN WITH FRAME qbf-pick.
    ELSE
      UP WITH FRAME qbf-pick.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "PAGE-DOWN" THEN DO:
    ASSIGN
      qbf-r = qbf-r + qbf-d
      qbf-w = TRUE.
    IF qbf-r + qbf-d - FRAME-LINE(qbf-pick) > qbf-m THEN DO:
      qbf-r = qbf-m.
      DOWN MINIMUM(qbf-m,qbf-d) - FRAME-LINE(qbf-pick)
        WITH FRAME qbf-pick.
    END.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "PAGE-UP" THEN ASSIGN
    qbf-r = qbf-r - qbf-d
    qbf-w = TRUE.
  ELSE
  IF CAN-DO("HOME,MOVE",KEYFUNCTION(LASTKEY)) THEN DO:
    ASSIGN
      qbf-r = (IF qbf-r > 1 THEN 1 ELSE qbf-m)
      qbf-w = TRUE.
    UP FRAME-LINE(qbf-pick) - (IF qbf-r = 1 THEN 1 ELSE qbf-d)
      WITH FRAME qbf-pick.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "HELP" AND LENGTH(qbf-module) > 2 THEN DO:
    RUN prores/applhelp.p.
    PUT SCREEN
      ROW qbf-y + qbf-d + 1 COLUMN qbf-x + LENGTH(qbf-z + qbf-xofy) + 2
      COLOR VALUE(qbf-plo) STRING(qbf-m).
    PUT SCREEN
      ROW qbf-y + qbf-d + 1 COLUMN qbf-x + LENGTH(qbf-z) + 1
      COLOR VALUE(qbf-plo) qbf-xofy.
  END.
  ELSE
  IF CAN-DO("GO,RETURN",KEYFUNCTION(LASTKEY)) THEN qbf-o = qbf-r.
  IF CAN-DO("GO,RETURN,END-ERROR",KEYFUNCTION(LASTKEY)) THEN LEAVE.

END.

HIDE FRAME qbf-pick NO-PAUSE.
HIDE FRAME qbf-type NO-PAUSE.
PAUSE BEFORE-HIDE.

{ prores/t-reset.i }
RETURN.
