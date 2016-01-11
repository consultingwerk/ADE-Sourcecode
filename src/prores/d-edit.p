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
/* d-edit.p - enter control codes for data export */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }

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

   Record start: ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___
     Record end: ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___
Field delimiter: ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___
Field separator: ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___
|---------------: 123456789012345678901234567890123456789012345678901234567890 |
----------------------------------------------------------------------------*/

DEFINE INPUT-OUTPUT PARAMETER qbf-o AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-a AS LOGICAL   INITIAL FALSE           NO-UNDO.
DEFINE VARIABLE qbf-b AS INTEGER                           NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE qbf-h AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER                           NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER                           NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER FORMAT "x(3)" EXTENT  4 NO-UNDO.
DEFINE VARIABLE qbf-n AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE qbf-y AS CHARACTER FORMAT "x(3)" EXTENT 48 NO-UNDO.

DEFINE VARIABLE qbf-x AS CHARACTER               EXTENT  6 NO-UNDO INITIAL [
  "| 0 nul | 4 eot |  8 bs | 12 ff | 16 dle | 20 dc4 | 24 can | 28 fs",
  "| 1 soh | 5 enq |  9 ht | 13 cr | 17 dc1 | 21 nak | 25 em  | 29 gs",
  "| 2 stx | 6 ack | 10 lf | 14 so | 18 dc2 | 22 syn | 26 sub | 30 rs",
  "| 3 etx | 7 bel | 11 vt | 15 si | 19 dc3 | 23 etb | 27 esc | 31 us",
  ?,
  ?
].

ASSIGN
  qbf-n = "0,1,2,3,4,5,6,7,8,9"
  qbf-h = qbf-n + ",A,B,C,D,E,F"
  qbf-t = "nul,soh,stx,etx,eot,enq,ack,bel,bs,ht,lf,vt,ff,cr,so,si,"
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

/*"When entering codes, these methods may be used and mixed freely:"*/
/*"  'x' - literal character enclosed in single quotes."*/
/*"  ^x  - interpreted as control-character."*/
/*"  ##h - one or two hex digits followed by the letter ~"h~"."*/
/*"  ### - one, two or three digits, a decimal number."*/
FORM
  qbf-lang[4] FORMAT "x(70)" SKIP
  "  'x' -" qbf-lang[5] FORMAT "x(60)" SKIP
  "  ^x  -" qbf-lang[6] FORMAT "x(60)" SKIP
  "  ##h -" qbf-lang[7] FORMAT "x(60)" SKIP
  "  ### -" qbf-lang[8] FORMAT "x(60)" SKIP
  qbf-x[5] FORMAT "x(72)" NO-ATTR-SPACE SKIP
  SPACE(8) qbf-x[1] FORMAT "x(66)" NO-ATTR-SPACE SKIP
  SPACE(8) qbf-x[2] FORMAT "x(66)" NO-ATTR-SPACE SKIP
  SPACE(8) qbf-x[3] FORMAT "x(66)" NO-ATTR-SPACE SKIP
  SPACE(8) qbf-x[4] FORMAT "x(66)" NO-ATTR-SPACE SKIP
  WITH FRAME d-desc ROW 5 COLUMN 1 NO-LABELS ATTR-SPACE OVERLAY WIDTH 80.
FORM
  /*   Record start:*/
    qbf-m[ 1] qbf-y[ 2] qbf-y[ 3] qbf-y[ 4] qbf-y[ 5] qbf-y[ 6]
    qbf-y[ 7] qbf-y[ 8] qbf-y[ 9] qbf-y[10] qbf-y[11] qbf-y[12] SKIP
  /*     Record end:*/
    qbf-m[ 2] qbf-y[14] qbf-y[15] qbf-y[16] qbf-y[17] qbf-y[18]
    qbf-y[19] qbf-y[20] qbf-y[21] qbf-y[22] qbf-y[23] qbf-y[24] SKIP
  /*Field delimiter:*/
    qbf-m[ 3] qbf-y[26] qbf-y[27] qbf-y[28] qbf-y[29] qbf-y[30]
    qbf-y[31] qbf-y[32] qbf-y[33] qbf-y[34] qbf-y[35] qbf-y[36] SKIP
  /*Field separator:*/
    qbf-m[ 4] qbf-y[38] qbf-y[39] qbf-y[40] qbf-y[41] qbf-y[42]
    qbf-y[43] qbf-y[44] qbf-y[45] qbf-y[46] qbf-y[47] qbf-y[48] SKIP
  WITH FRAME d-codes ROW 17 COLUMN 18 NO-BOX NO-LABELS ATTR-SPACE OVERLAY.

DO qbf-i = 1 TO 4:
  IF qbf-d-attr[qbf-i + 2] = ",,,,,,,,,,," THEN NEXT.
  DO qbf-j = 1 TO 12:
    IF ENTRY(qbf-j,qbf-d-attr[qbf-i + 2]) <> "" THEN
    qbf-y[qbf-i * 12 + qbf-j - 12] =
      ENTRY(INTEGER(ENTRY(qbf-j,qbf-d-attr[qbf-i + 2])) + 1,qbf-t).
    IF qbf-y[qbf-i * 12 + qbf-j - 12] = "44" THEN
      qbf-y[qbf-i * 12 + qbf-j - 12] = "','".
  END.
END.

IF qbf-o = ? THEN DO:
  qbf-o = STRING(qbf-y[ 1] + " " + qbf-y[ 2] + " " + qbf-y[ 3]
        +  " " + qbf-y[ 4] + " " + qbf-y[ 5] + " " + qbf-y[ 6]
        +  " " + qbf-y[ 7] + " " + qbf-y[ 8] + " " + qbf-y[ 9]
        +  " " + qbf-y[10] + " " + qbf-y[11] + " " + qbf-y[12],"x(48)")
        + STRING(qbf-y[13] + " " + qbf-y[14] + " " + qbf-y[15]
        +  " " + qbf-y[16] + " " + qbf-y[17] + " " + qbf-y[18]
        +  " " + qbf-y[19] + " " + qbf-y[20] + " " + qbf-y[21]
        +  " " + qbf-y[22] + " " + qbf-y[23] + " " + qbf-y[24],"x(48)")
        + STRING(qbf-y[25] + " " + qbf-y[26] + " " + qbf-y[27]
        +  " " + qbf-y[28] + " " + qbf-y[29] + " " + qbf-y[30]
        +  " " + qbf-y[31] + " " + qbf-y[32] + " " + qbf-y[33]
        +  " " + qbf-y[34] + " " + qbf-y[35] + " " + qbf-y[36],"x(48)")
        + STRING(qbf-y[37] + " " + qbf-y[38] + " " + qbf-y[39]
        +  " " + qbf-y[40] + " " + qbf-y[41] + " " + qbf-y[42]
        +  " " + qbf-y[43] + " " + qbf-y[44] + " " + qbf-y[45]
        +  " " + qbf-y[46] + " " + qbf-y[47] + " " + qbf-y[48],"x(48)").
  RETURN.
END.

{ prores/t-set.i &mod=d &set=1 }

/*1:"is a symbol such as"  2:"from the following table."*/
/*3:"Press [GET] to toggle expert mode on and off."*/
ASSIGN
  qbf-x[5] = 'xxx - "xxx" ' + qbf-lang[1] + ' "lf" ' + qbf-lang[2]
  qbf-x[6] = qbf-lang[3].

DISPLAY qbf-x[6] @ qbf-x[5] qbf-lang[4 FOR 5] WITH FRAME d-desc.
COLOR DISPLAY INPUT qbf-m[1 FOR 4]
  qbf-y[ 2 FOR 11] qbf-y[14 FOR 11] qbf-y[26 FOR 11] qbf-y[38 FOR 11]
  WITH FRAME d-codes.
ASSIGN
  qbf-m[1] = qbf-y[ 1]
  qbf-m[2] = qbf-y[13]
  qbf-m[3] = qbf-y[25]
  qbf-m[4] = qbf-y[37].
DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  UPDATE
    qbf-m[1] qbf-y[ 2 FOR 11]
    qbf-m[2] qbf-y[14 FOR 11]
    qbf-m[3] qbf-y[26 FOR 11]
    qbf-m[4] qbf-y[38 FOR 11]
    WITH FRAME d-codes EDITING:
      READKEY.
      IF KEYFUNCTION(LASTKEY) = "GET" THEN
        IF INPUT FRAME d-desc qbf-x[5] = qbf-x[5] THEN
          DISPLAY "" @ qbf-x[1] "" @ qbf-x[2] "" @ qbf-x[3] "" @ qbf-x[4]
            qbf-x[6] @ qbf-x[5] WITH FRAME d-desc.
        ELSE
          DISPLAY qbf-x[1 FOR 5] WITH FRAME d-desc.
      ELSE
        APPLY LASTKEY.
      IF KEYFUNCTION(LASTKEY) = "RETURN" THEN
        DO WHILE FRAME-FIELD <> "qbf-m" AND NOT GO-PENDING:
          APPLY LASTKEY.
        END.
    END. /*editing*/

  ASSIGN
    qbf-y[ 1] = qbf-m[1]
    qbf-y[13] = qbf-m[2]
    qbf-y[25] = qbf-m[3]
    qbf-y[37] = qbf-m[4].

  DO qbf-i = 1 TO 48:
    ASSIGN
      qbf-b = -1
      qbf-c = qbf-y[qbf-i].
    IF qbf-c = "" THEN .
    ELSE
    IF qbf-c = "','" THEN qbf-b = 44. /* special case for comma */
    ELSE
    IF qbf-c BEGINS "'" THEN qbf-b = ASC(SUBSTRING(qbf-c,2,1)).
    ELSE
    IF CAN-DO(qbf-t,qbf-c) THEN qbf-b = LOOKUP(qbf-c,qbf-t) - 1.
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
      /*"is an unknown code.  Please correct."*/
      MESSAGE '"' + qbf-c + '"' qbf-lang[9].
      IF qbf-i = 1 OR qbf-i = 13 OR qbf-i = 25 OR qbf-i = 37 THEN
        NEXT-PROMPT qbf-m[INTEGER((qbf-i + 11) / 12)] WITH FRAME d-codes.
      ELSE
        NEXT-PROMPT qbf-y[qbf-i] WITH FRAME d-codes.
      UNDO,RETRY.
    END.

    qbf-y[qbf-i] = (IF qbf-b = -1 THEN "" ELSE IF qbf-b = 44 THEN "','"
                   ELSE ENTRY(qbf-b + 1,qbf-t)).
    IF qbf-i = 1 OR qbf-i = 13 OR qbf-i = 25 OR qbf-i = 37 THEN
      DISPLAY qbf-y[qbf-i] @ qbf-m[INTEGER((qbf-i + 11) / 12)]
        WITH FRAME d-codes.
    ELSE
      DISPLAY qbf-y[qbf-i] WITH FRAME d-codes.
  END.

  ASSIGN
    qbf-d-attr[3] = ""
    qbf-d-attr[4] = ""
    qbf-d-attr[5] = ""
    qbf-d-attr[6] = "".
  DO qbf-i = 0 TO 47:
    ASSIGN
      qbf-j             = TRUNCATE(qbf-i / 12,0) + 3
      qbf-d-attr[qbf-j] = qbf-d-attr[qbf-j]
                        + (IF qbf-i MODULO 12 = 0 THEN "" ELSE ",")
                        + (IF qbf-y[qbf-i + 1] = "" THEN "" ELSE
                          STRING(IF qbf-y[qbf-i + 1] BEGINS "'" THEN
                            ASC(SUBSTRING(qbf-y[qbf-i + 1],2,1))
                          ELSE
                            (LOOKUP(qbf-y[qbf-i + 1],qbf-t) - 1)
                          )).
  END.
END.

HIDE FRAME d-desc  NO-PAUSE.
HIDE FRAME d-codes NO-PAUSE.
{ prores/t-reset.i }
RETURN.
