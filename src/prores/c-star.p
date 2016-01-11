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
/* c-star.p - select multiple fields, in any order */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }

/*i/o:*/
DEFINE INPUT-OUTPUT PARAMETER qbf-o AS CHARACTER NO-UNDO.

/*local:*/
DEFINE VARIABLE lReturn AS LOGICAL    NO-UNDO.
DEFINE VARIABLE qbf-a   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE qbf-d   AS INTEGER    NO-UNDO INITIAL 14.
DEFINE VARIABLE qbf-e   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-j   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-k   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-l   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-r   AS INTEGER    NO-UNDO INITIAL 1.
DEFINE VARIABLE qbf-t   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-u   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-w   AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE qbf-x   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-z   AS CHARACTER  NO-UNDO.

/* field array */
DEFINE TEMP-TABLE qbf-f
  FIELD iIndex AS INTEGER   LABEL "Index"
  FIELD cValue AS CHARACTER LABEL "Value"
  INDEX iIndex IS UNIQUE iIndex.
DEFINE BUFFER buf-f FOR qbf-f.
&GLOBAL-DEFINE FIND_QBF_F FIND qbf-f WHERE qbf-f.iIndex =
&GLOBAL-DEFINE FIND_BUF_F FIND buf-f WHERE buf-f.iIndex =

/*message "[c-star.p]" view-as alert-box.*/

/*forms:*/
FORM
  qbf-a        FORMAT "*/ " NO-ATTR-SPACE SPACE(0)
  qbf-f.cValue FORMAT "x(40)"
  WITH FRAME qbf-pick SCROLL 1 OVERLAY NO-LABELS ATTR-SPACE
  qbf-d DOWN ROW 3 COLUMN 36
  COLOR DISPLAY VALUE(qbf-plo) PROMPT VALUE(qbf-phi)
  TITLE COLOR VALUE(qbf-plo) " " + qbf-lang[9] + " ". /*"Choose Fields"*/

FORM
  qbf-t FORMAT "x(41)"
  WITH FRAME qbf-type OVERLAY NO-LABELS ATTR-SPACE
  ROW qbf-d + 2 + FRAME-ROW(qbf-pick) COLUMN FRAME-COL(qbf-pick)
  COLOR DISPLAY VALUE(qbf-plo) PROMPT VALUE(qbf-phi).

ASSIGN
  qbf-e = qbf-o
  qbf-u = 0.
DO qbf-k = 1 TO qbf-rc#:
  IF qbf-rcc[qbf-k] BEGINS "e" THEN NEXT. /* skip stacked arrays */
  ASSIGN
    qbf-u        = qbf-u + 1.
    
  CREATE qbf-f.
  ASSIGN
    qbf-f.iIndex = qbf-u
    qbf-f.cValue = (IF INDEX(ENTRY(1,qbf-rcn[qbf-k]),".") > 0 THEN "" ELSE
                     ENTRY(INDEX("rpcsdnl",SUBSTRING(qbf-rcc[qbf-k],1,1)) + 1,
                     qbf-etype) + ".")
                 + ENTRY(1,qbf-rcn[qbf-k]) + "," + qbf-rcl[qbf-k].
END.

IF qbf-u <= 0 THEN RETURN.

{ prores/t-set.i &mod=c &set=0 }

/*"Press [F1] to select, [F3] to toggle name/label, [F4] to exit"*/
STATUS DEFAULT qbf-lang[2].

VIEW FRAME qbf-pick.

ASSIGN
  qbf-d = FRAME-DOWN(qbf-pick)
  qbf-z = FILL("Z",LENGTH(STRING(qbf-u)))
  qbf-x = FRAME-COL(qbf-pick) + 43 - LENGTH(qbf-z).

PUT SCREEN ROW qbf-d + FRAME-ROW(qbf-pick) + 1 COLUMN qbf-x
  COLOR VALUE(qbf-plo) STRING(qbf-u).
qbf-x = qbf-x - LENGTH(qbf-xofy) - 1.
PUT SCREEN ROW qbf-d + FRAME-ROW(qbf-pick) + 1 COLUMN qbf-x
  COLOR VALUE(qbf-plo) qbf-xofy.
qbf-x = qbf-x - LENGTH(qbf-z) - 1.

DO WHILE TRUE:

  qbf-r = MINIMUM(qbf-u,MAXIMUM(qbf-r,1)).
  IF qbf-r < FRAME-LINE(qbf-pick) THEN
    DOWN qbf-r - FRAME-LINE(qbf-pick) WITH FRAME qbf-pick.

  IF LENGTH(qbf-t) > 0 THEN
    DISPLAY qbf-t WITH FRAME qbf-type.
  ELSE
    HIDE FRAME qbf-type NO-PAUSE.

  IF qbf-w THEN DO:
    ASSIGN
      qbf-w = FALSE
      qbf-l = MAXIMUM(1,FRAME-LINE(qbf-pick))
      qbf-k = qbf-r - qbf-l + 1.
    UP qbf-l - 1 WITH FRAME qbf-pick.
    IF qbf-k < 1 THEN ASSIGN
      qbf-k = 1
      qbf-l = 1
      qbf-r = 1.
    DO qbf-j = qbf-k TO qbf-k + qbf-d - 1:
      IF qbf-j > qbf-u THEN
        CLEAR FRAME qbf-pick NO-PAUSE.
      ELSE DO:
        {&FIND_QBF_F} qbf-j.
        DISPLAY
          CAN-DO(qbf-o,ENTRY(1,qbf-f.cValue)) @ qbf-a
          /*{ prores/s-star.i qbf-f[qbf-j] } @ qbf-f[qbf-r]*/
          { prores/s-star.i qbf-f.cValue } @ qbf-f.cValue
          WITH FRAME qbf-pick.
      END.
      IF qbf-j < qbf-k + qbf-d - 1 THEN
        DOWN 1 WITH FRAME qbf-pick.
    END.
    UP qbf-d - qbf-l WITH FRAME qbf-pick.
    PUT SCREEN COLOR VALUE(qbf-plo)
      ROW qbf-d + FRAME-ROW(qbf-pick) + 1 COLUMN FRAME-COL(qbf-pick) + 2
      STRING(qbf-toggle1,qbf-lang[5]). /*"Label/Name-"*/
  END.

  {&FIND_QBF_F} qbf-r.
  DISPLAY
    /*
    CAN-DO(qbf-o,ENTRY(1,qbf-f[qbf-r])) @ qbf-a
    { prores/s-star.i qbf-f[qbf-r] } @ qbf-f[qbf-r]
    */
    CAN-DO(qbf-o,ENTRY(1,qbf-f.cValue)) @ qbf-a
    { prores/s-star.i qbf-f.cValue } @ qbf-f.cValue
    WITH FRAME qbf-pick.

  PUT SCREEN ROW qbf-d + 1 + FRAME-ROW(qbf-pick) COLUMN qbf-x
    COLOR VALUE(qbf-plo) STRING(qbf-r,qbf-z).
  COLOR DISPLAY VALUE(qbf-phi) qbf-f.cValue WITH FRAME qbf-pick.
  READKEY.
  COLOR DISPLAY VALUE(qbf-plo) qbf-f.cValue WITH FRAME qbf-pick.

  IF (KEYFUNCTION(LASTKEY) = CHR(LASTKEY) AND LASTKEY >= 32)
    OR (KEYFUNCTION(LASTKEY) = "BACKSPACE" AND LENGTH(qbf-t) > 0) THEN DO:
    qbf-t = (IF KEYFUNCTION(LASTKEY) = "BACKSPACE"
            THEN SUBSTRING(qbf-t,1,LENGTH(qbf-t) - 1)
            ELSE qbf-t + CHR(LASTKEY)).
    IF qbf-t = "" OR { prores/s-star.i qbf-f.cValue } BEGINS qbf-t THEN NEXT.
    DO qbf-l = qbf-r TO qbf-u:
      {&FIND_QBF_F} qbf-l.
      IF { prores/s-star.i qbf-f.cValue } BEGINS qbf-t THEN LEAVE.
    END.
    IF qbf-l > qbf-u THEN DO:
      DO qbf-l = 1 TO qbf-r:
        {&FIND_QBF_F} qbf-l.
        IF { prores/s-star.i qbf-f.cValue } BEGINS qbf-t THEN LEAVE.
      END.
      IF qbf-l > qbf-r THEN 
        qbf-l = qbf-u + 1.
    END.
    IF qbf-l > qbf-u THEN DO:
      qbf-t = CHR(LASTKEY).
      DO qbf-l = 1 TO qbf-u:
        {&FIND_QBF_F} qbf-l.
        IF { prores/s-star.i qbf-f.cValue } BEGINS qbf-t THEN LEAVE.
      END.
    END.
    ASSIGN
      qbf-l = (IF qbf-l <= qbf-u THEN qbf-l ELSE qbf-r)
      qbf-k = qbf-l - qbf-r + FRAME-LINE(qbf-pick)
      qbf-r = qbf-l.
    IF qbf-k < 1 OR qbf-k > MINIMUM(qbf-d,qbf-u) THEN
      qbf-w = TRUE.
    ELSE
      UP FRAME-LINE(qbf-pick) - qbf-k WITH FRAME qbf-pick.
    NEXT.
  END.

  qbf-t = "".
  IF KEYFUNCTION(LASTKEY) = "INSERT-MODE" THEN
    ASSIGN
      qbf-w       = TRUE
      qbf-toggle1 = NOT qbf-toggle1.
  IF KEYFUNCTION(LASTKEY) = "RETURN" THEN DO:
    {&FIND_QBF_F} qbf-r.
    qbf-t = ENTRY(1,qbf-f.cValue).
    IF qbf-o = qbf-t THEN
      qbf-o = "".
    ELSE
    IF CAN-DO(qbf-o,qbf-t) THEN
      ASSIGN
        qbf-k = MAXIMUM(INDEX("," + qbf-o + ",","," + qbf-t + ",") - 1,1)
        SUBSTRING(qbf-o,qbf-k,LENGTH(qbf-t) + 1) = "".
    ELSE
      qbf-o = qbf-o + (IF qbf-o = "" THEN "" ELSE ",") + qbf-t.
    DISPLAY CAN-DO(qbf-o,qbf-t) @ qbf-a WITH FRAME qbf-pick.
    qbf-t = "".
  END.
  IF CAN-DO("CURSOR-DOWN,TAB,RETURN",KEYFUNCTION(LASTKEY))
    AND qbf-r < qbf-u THEN DO:
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
    IF qbf-r + qbf-d - FRAME-LINE(qbf-pick) > qbf-u THEN DO:
      qbf-r = qbf-u.
      DOWN MINIMUM(qbf-u,qbf-d) - FRAME-LINE(qbf-pick)
        WITH FRAME qbf-pick.
    END.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "PAGE-UP" THEN DO:
    ASSIGN
      qbf-r = MAXIMUM(qbf-r - qbf-d,1)
      qbf-w = TRUE.
    IF qbf-r < 1 THEN UP FRAME-LINE(qbf-pick) - 1 WITH FRAME qbf-pick.
  END.
  ELSE
  IF CAN-DO("HOME,MOVE",KEYFUNCTION(LASTKEY)) THEN DO:
    ASSIGN
      qbf-r = (IF qbf-r > 1 THEN 1 ELSE qbf-u)
      qbf-w = TRUE.
    UP FRAME-LINE(qbf-pick) - (IF qbf-r = 1 THEN 1 ELSE qbf-d)
      WITH FRAME qbf-pick.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN qbf-o = qbf-e.
  IF CAN-DO("GO,END-ERROR",KEYFUNCTION(LASTKEY)) THEN LEAVE.

END.

/* strip off qbf-etype prefix in qbf-o output string */
ASSIGN
  qbf-t = qbf-o
  qbf-o = "".
DO qbf-j = 1 TO NUM-ENTRIES(qbf-t):
  ASSIGN
    qbf-z = ENTRY(qbf-j,qbf-t)
    qbf-o = qbf-o + (IF qbf-j = 1 THEN "" ELSE ",")
          + (IF qbf-z MATCHES "*~~.qbf-..." THEN
              SUBSTRING(qbf-z,INDEX(qbf-z,".") + 1)
            ELSE
              qbf-z).
END.

HIDE FRAME qbf-pick NO-PAUSE.
HIDE FRAME qbf-type NO-PAUSE.

STATUS DEFAULT.

{ prores/t-reset.i }
RETURN.
