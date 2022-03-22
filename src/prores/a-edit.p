/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* a-edit.p - set control characters for output devices */

{ prores/s-system.i }
{ prores/s-print.i }
{ prores/t-define.i }
{ prores/t-set.i &mod=d &set=1 }

/*----------------------------------------------------------------------------
When entering codes, the following methods may be used:
  'x' - literal character enclosed in single quotes.
  ^x  - interpreted as control-character.
  ##h - one or two hex digits followed by the letter "h".
  ### - one, two or three digits, a decimal number.
  xxx - "xxx" is a symbol such as "lf" from the following table.
        | 0 nul | 4 eot |  8 bs | 12 ff | 16 dle | 20 dc4 | 24 can | 28 fs
        | 1 soh | 5 enq |  9 ht | 13 cr | 17 dc1 | 21 nak | 25 em  | 29 gs
        | 2 stx | 6 ack | 10 lf | 14 so | 18 dc2 | 22 syn | 26 sub | 30 rs
        | 3 etx | 7 bel | 11 vt | 15 si | 19 dc3 | 23 etb | 27 esc | 31 us

Initialization: ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___
                ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___
  Normal Print: ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___
    Compressed: ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___
      Bold  ON: ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___
      Bold OFF: ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___
|---------------: 123456789012345678901234567890123456789012345678901234567890 |
----------------------------------------------------------------------------*/

DEFINE SHARED VARIABLE qbf-t AS CHARACTER EXTENT 8 NO-UNDO.

DEFINE VARIABLE qbf-a AS LOGICAL   INITIAL FALSE           NO-UNDO.
DEFINE VARIABLE qbf-b AS INTEGER                           NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE qbf-h AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER                           NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER                           NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER FORMAT "x(3)" EXTENT  6 NO-UNDO.
DEFINE VARIABLE qbf-n AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE qbf-s AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE qbf-y AS CHARACTER FORMAT "x(3)" EXTENT 72 NO-UNDO.

{ prores/a-edit.i } /* needs qbf-m[1..6] and qbf-y[1..72] defined */

DEFINE VARIABLE qbf-x AS CHARACTER               EXTENT  6 NO-UNDO INITIAL [
  "| 0 nul | 4 eot |  8 bs | 12 ff | 16 dle | 20 dc4 | 24 can | 28 fs",
  "| 1 soh | 5 enq |  9 ht | 13 cr | 17 dc1 | 21 nak | 25 em  | 29 gs",
  "| 2 stx | 6 ack | 10 lf | 14 so | 18 dc2 | 22 syn | 26 sub | 30 rs",
  "| 3 etx | 7 bel | 11 vt | 15 si | 19 dc3 | 23 etb | 27 esc | 31 us",
  ?,
  ?
].

ASSIGN
  /*1:"is a symbol such as"  2:"from the following table."*/
  qbf-x[5] = '  xxx - "xxx" ' + qbf-lang[1] + ' "lf" ' + qbf-lang[2]
  /*3:"Press [GET] to toggle expert mode on and off."*/
  qbf-x[6] = qbf-lang[3]
  qbf-n = "0,1,2,3,4,5,6,7,8,9"
  qbf-h = qbf-n + ",A,B,C,D,E,F"
  qbf-s = "nul,soh,stx,etx,eot,enq,ack,bel,bs,ht,lf,vt,ff,cr,so,si,"
        + "dle,dc1,dc2,dc3,dc4,nak,syn,etb,can,em,sub,esc,fs,gs,rs,us,"
        + "' ','!','~"','#','$','%','&',''','(',')','*','+',44,'-','.','/',"
        + "'0','1','2','3','4','5','6','7','8','9',':','~;','<','=','>','?',"
        + "'@','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O',"
        + "'P','Q','R','S','T','U','V','W','X','Y','Z','[','~\',']','^','_',"
        + "'`','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o',"
        + "'p','q','r','s','t','u','v','w','x','y','z','~{','|','~}','~~',127"
        + "128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,"
        + "144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,"
        + "160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,"
        + "176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,"
        + "192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,"
        + "208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,"
        + "224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,"
        + "240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255".
/* note that loading the above array like this is a *lot* */
/* faster than using a loop to create the entries. */

/*"When entering codes, these methods may be used and mixed freely:"*/
/*"  'x' - literal character enclosed in single quotes."*/
/*"  ^x  - interpreted as control-character."*/
/*"  ##h - one or two hex digits followed by the letter ~"H~"."*/
/*"  ### - one, two or three digits, a decimal number."*/
FORM
  qbf-lang[ 4] FORMAT "x(70)" SKIP
  "  'x' -" qbf-lang[5] FORMAT "x(60)" SKIP
  "  ^x  -" qbf-lang[6] FORMAT "x(60)" SKIP
  "  ##h -" qbf-lang[7] FORMAT "x(60)" SKIP
  "  ### -" qbf-lang[8] FORMAT "x(60)" SKIP
  qbf-x[5] FORMAT "x(72)" NO-ATTR-SPACE SKIP
  SPACE(8) qbf-x[1] FORMAT "x(66)" NO-ATTR-SPACE SKIP
  SPACE(8) qbf-x[2] FORMAT "x(66)" NO-ATTR-SPACE SKIP
  SPACE(8) qbf-x[3] FORMAT "x(66)" NO-ATTR-SPACE SKIP
  SPACE(8) qbf-x[4] FORMAT "x(66)" NO-ATTR-SPACE SKIP
  qbf-t[7] FORMAT "x(17)" NO-ATTR-SPACE
    qbf-printer[qbf-device] FORMAT "x(32)" SKIP
  qbf-t[8] FORMAT "x(17)" NO-ATTR-SPACE
    qbf-pr-dev[qbf-device]  FORMAT "x(40)" SKIP
  WITH FRAME qbf-desc ROW 3 COLUMN 2 NO-BOX NO-LABELS ATTR-SPACE OVERLAY.
  /*qbf-t[7]:"Desc for listing:"  qbf-t[8]:"     Device name:"*/

ASSIGN
  qbf-m[1] = ""
  qbf-m[2] = ""
  qbf-m[3] = qbf-pr-norm[qbf-device]
  qbf-m[4] = qbf-pr-comp[qbf-device]
  qbf-m[5] = qbf-pr-bon[qbf-device]
  qbf-m[6] = qbf-pr-boff[qbf-device].
IF qbf-pr-init[qbf-device] <> "" THEN
  DO qbf-i = 1 TO 12:
    ASSIGN
      qbf-m[1] = qbf-m[1] + (IF qbf-i = 1 THEN "" ELSE ",")
               + ENTRY(qbf-i,qbf-pr-init[qbf-device])
      qbf-m[2] = qbf-m[2] + (IF qbf-i = 1 THEN "" ELSE ",")
               + ENTRY(qbf-i + 12,qbf-pr-init[qbf-device]).
  END.
DO qbf-i = 1 TO 6:
  IF qbf-m[qbf-i] = "" THEN qbf-m[qbf-i] = ",,,,,,,,,,,".
  IF qbf-m[qbf-i] = ",,,,,,,,,,," THEN NEXT.
  DO qbf-j = 1 TO 12:
    IF ENTRY(qbf-j,qbf-m[qbf-i]) <> "" THEN
    qbf-y[qbf-i * 12 + qbf-j - 12] =
      ENTRY(INTEGER(ENTRY(qbf-j,qbf-m[qbf-i])) + 1,qbf-s).
    IF qbf-y[qbf-i * 12 + qbf-j - 12] = "44" THEN
      qbf-y[qbf-i * 12 + qbf-j - 12] = "','".
  END.
END.

PAUSE 0.
DISPLAY
  qbf-lang[4 FOR 5]
  qbf-x[6]       @ qbf-x[5]
  qbf-t[7] + ":" @ qbf-t[7]
  qbf-t[8] + ":" @ qbf-t[8]
  qbf-printer[qbf-device] qbf-pr-dev[qbf-device]
  WITH FRAME qbf-desc.
COLOR DISPLAY INPUT
  qbf-m[1  FOR 6]
  qbf-y[ 2 FOR 11] qbf-y[14 FOR 11] qbf-y[26 FOR 11]
  qbf-y[38 FOR 11] qbf-y[50 FOR 11] qbf-y[62 FOR 11]
  WITH FRAME qbf-ctrl.
DISPLAY qbf-t[1 FOR 6] WITH FRAME qbf-ctrl.
ASSIGN
  qbf-m[1] = qbf-y[ 1]
  qbf-m[2] = qbf-y[13]
  qbf-m[3] = qbf-y[25]
  qbf-m[4] = qbf-y[37]
  qbf-m[5] = qbf-y[49]
  qbf-m[6] = qbf-y[61].
HIDE MESSAGE NO-PAUSE.

DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  UPDATE
    qbf-m[1] qbf-y[ 2 FOR 11]
    qbf-m[2] qbf-y[14 FOR 11]
    qbf-m[3] qbf-y[26 FOR 11]
    qbf-m[4] qbf-y[38 FOR 11]
    qbf-m[5] qbf-y[50 FOR 11]
    qbf-m[6] qbf-y[62 FOR 11]
    WITH FRAME qbf-ctrl EDITING:
      READKEY.
      IF KEYFUNCTION(LASTKEY) = "GET" THEN
        IF INPUT FRAME qbf-desc qbf-x[5] = qbf-x[5] THEN
          DISPLAY "" @ qbf-x[1] "" @ qbf-x[2] "" @ qbf-x[3] "" @ qbf-x[4]
            qbf-x[6] @ qbf-x[5] WITH FRAME qbf-desc.
        ELSE
          DISPLAY qbf-x[1 FOR 5] WITH FRAME qbf-desc.
      ELSE
        APPLY LASTKEY.
      IF KEYFUNCTION(LASTKEY) = "RETURN" THEN
        DO WHILE FRAME-FIELD <> "qbf-m" AND NOT GO-PENDING:
          APPLY LASTKEY.
        END.
    END. /*editing*/

  HIDE MESSAGE NO-PAUSE.
  MESSAGE qbf-lang[10].  /*"Processing printer control definitions..."*/

  ASSIGN
    qbf-y[ 1] = qbf-m[1]
    qbf-y[13] = qbf-m[2]
    qbf-y[25] = qbf-m[3]
    qbf-y[37] = qbf-m[4]
    qbf-y[49] = qbf-m[5]
    qbf-y[61] = qbf-m[6].

  DO qbf-i = 1 TO 72:
    ASSIGN
      qbf-b = -1
      qbf-c = qbf-y[qbf-i].
    IF qbf-c = "" THEN .
    ELSE
    IF qbf-c BEGINS "'" THEN qbf-b = ASC(SUBSTRING(qbf-c,2,1)).
    ELSE
    IF CAN-DO(qbf-s,qbf-c) THEN qbf-b = LOOKUP(qbf-c,qbf-s) - 1.
    ELSE
    IF qbf-c BEGINS "^"
      AND ASC(CAPS(SUBSTRING(qbf-c,2,1))) >= 64
      AND ASC(CAPS(SUBSTRING(qbf-c,2,1))) <= 95 THEN
      qbf-b = ASC(CAPS(SUBSTRING(qbf-c,2,1))) - 64.
    ELSE
    IF LENGTH(qbf-c) = 2
      AND SUBSTRING(qbf-c,2,1) = "h"
      AND CAN-DO(qbf-h,SUBSTRING(qbf-c,1,1)) THEN
      qbf-b = LOOKUP(SUBSTRING(qbf-c,1,1),qbf-h) - 1.
    ELSE
    IF LENGTH(qbf-c) = 3
      AND SUBSTRING(qbf-c,3,1) = "h"
      AND CAN-DO(qbf-h,SUBSTRING(qbf-c,1,1))
      AND CAN-DO(qbf-h,SUBSTRING(qbf-c,2,1)) THEN
      qbf-b = LOOKUP(SUBSTRING(qbf-c,1,1),qbf-h) * 16
            + LOOKUP(SUBSTRING(qbf-c,2,1),qbf-h) - 17.
    ELSE
    IF LENGTH(qbf-c) = 1
      AND CAN-DO(qbf-n,qbf-c) THEN qbf-b = INTEGER(qbf-c).
    ELSE
    IF LENGTH(qbf-c) = 2
      AND CAN-DO(qbf-n,SUBSTRING(qbf-c,1,1))
      AND CAN-DO(qbf-n,SUBSTRING(qbf-c,2,1)) THEN qbf-b = INTEGER(qbf-c).
    ELSE
    IF LENGTH(qbf-c) = 3
      AND CAN-DO(qbf-n,SUBSTRING(qbf-c,1,1))
      AND CAN-DO(qbf-n,SUBSTRING(qbf-c,2,1))
      AND CAN-DO(qbf-n,SUBSTRING(qbf-c,3,1)) THEN qbf-b = INTEGER(qbf-c).
    ELSE
      qbf-b = -2.
    IF qbf-b < -1 OR qbf-b > 255 THEN DO:
      HIDE MESSAGE NO-PAUSE.
      /*"is an unknown code.  Please correct."*/
      MESSAGE '"' + qbf-c + '"' qbf-lang[9].
      IF   qbf-i =  1 OR qbf-i = 13 OR qbf-i = 25
        OR qbf-i = 37 OR qbf-i = 49 OR qbf-i = 61 THEN
        NEXT-PROMPT qbf-m[INTEGER((qbf-i + 11) / 12)] WITH FRAME qbf-ctrl.
      ELSE
        NEXT-PROMPT qbf-y[qbf-i] WITH FRAME qbf-ctrl.
      UNDO,RETRY.
    END.

    qbf-y[qbf-i] = (IF qbf-b = -1 THEN "" ELSE IF qbf-b = 44 THEN "','"
                   ELSE ENTRY(qbf-b + 1,qbf-s)).
    IF   qbf-i =  1 OR qbf-i = 13 OR qbf-i = 25
      OR qbf-i = 37 OR qbf-i = 49 OR qbf-i = 61 THEN
      DISPLAY qbf-y[qbf-i] @ qbf-m[INTEGER((qbf-i + 11) / 12)]
        WITH FRAME qbf-ctrl.
    ELSE
      DISPLAY qbf-y[qbf-i] WITH FRAME qbf-ctrl.
  END.

  qbf-m = "".
  DO qbf-i = 0 TO 71:
    ASSIGN
      qbf-j        = TRUNCATE(qbf-i / 12,0) + 1
      qbf-m[qbf-j] = qbf-m[qbf-j]
                   + (IF qbf-i MODULO 12 = 0 THEN "" ELSE ",")
                   + (IF qbf-y[qbf-i + 1] = "" THEN "" ELSE
                     STRING(IF qbf-y[qbf-i + 1] BEGINS "'" THEN
                       ASC(SUBSTRING(qbf-y[qbf-i + 1],2,1))
                     ELSE
                       (LOOKUP(qbf-y[qbf-i + 1],qbf-s) - 1)
                     )).
  END.
  DO qbf-i = 3 TO 6:
    IF qbf-m[qbf-i] = ",,,,,,,,,,," THEN qbf-m[qbf-i] = "".
  END.
  ASSIGN
    qbf-pr-init[qbf-device] = qbf-m[1] + "," + qbf-m[2]
    qbf-pr-norm[qbf-device] = qbf-m[3]
    qbf-pr-comp[qbf-device] = qbf-m[4]
    qbf-pr-bon[qbf-device]  = qbf-m[5]
    qbf-pr-boff[qbf-device] = qbf-m[6].
  IF qbf-pr-init[qbf-device] = ",,,,,,,,,,,,,,,,,,,,,,,"
    THEN qbf-pr-init[qbf-device] = "".
END.

HIDE FRAME qbf-desc NO-PAUSE.
HIDE MESSAGE NO-PAUSE.
{ prores/t-reset.i }
RETURN.
