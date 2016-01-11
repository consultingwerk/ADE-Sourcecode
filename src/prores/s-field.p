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
/* s-field.p - select a single field */

{ prores/s-system.i }
{ prores/t-define.i }
{ prores/c-cache.i NEW }
{ prores/reswidg.i }
{ prores/resfunc.i }

/*i/o:*/
DEFINE INPUT        PARAMETER qbf-f AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER qbf-g AS CHARACTER NO-UNDO. /* flags */
DEFINE INPUT        PARAMETER qbf-m AS CHARACTER NO-UNDO. /*datatype can-do*/
DEFINE INPUT-OUTPUT PARAMETER qbf-o AS CHARACTER NO-UNDO.
/* qbf-f can contain a file-name, comma-sep file-names, or "current",
   for current field settings ("current" always reloads cache) */

/*local:*/
DEFINE VARIABLE qbf-1 AS CHARACTER  NO-UNDO. /*used in s-field.i*/
DEFINE VARIABLE qbf-2 AS CHARACTER  NO-UNDO. /*used in s-field.i*/

DEFINE VARIABLE qbf-b AS INTEGER    NO-UNDO. /*p_base*/
DEFINE VARIABLE qbf-d AS INTEGER    NO-UNDO INITIAL 14.
DEFINE VARIABLE qbf-i AS INTEGER    NO-UNDO INITIAL ?.
DEFINE VARIABLE qbf-j AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-k AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-r AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-v AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-w AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE qbf-x AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-z AS CHARACTER  NO-UNDO.

/*forms:*/
{ prores/c-field.i &title="' '" }

FORM
  qbf-t FORMAT "x(40)"
  WITH FRAME qbf-type OVERLAY NO-LABELS ATTR-SPACE
  ROW qbf-d + 2 + FRAME-ROW(qbf-pick) COLUMN FRAME-COL(qbf-pick)
  COLOR DISPLAY VALUE(qbf-plo) PROMPT VALUE(qbf-phi).

/*message "[s-field.p]" view-as alert-box.*/

/* c-cache.i included NEW, so empty sister qbf-cfld temp-table */
EMPTY TEMP-TABLE qbf-cfld.

DO qbf-k = 1 TO 5: /* hack! */
  IF DBTYPE("QBF$" + STRING(qbf-k)) <> "PROGRESS" THEN
    CREATE ALIAS VALUE("QBF$" + STRING(qbf-k)) FOR DATABASE VALUE(SDBNAME(1)).
END.
RUN prores/c-cache.p (/*"*" +*/ qbf-f,qbf-m,"","",OUTPUT qbf-v).

{&FIND_QBF_CFLD} 1.
IF qbf-g = "" THEN
  ASSIGN
    qbf-cfld.cValue = ""
    qbf-b           = 2.
ELSE
  ASSIGN
    qbf-cfld.cValue = ",<<" + qbf-g + ">>,|<<" + qbf-g + ">>"
    qbf-b           = 1
    qbf-ctop        = qbf-ctop + 1.

IF qbf-ctop <= 0 THEN RETURN.

{ prores/t-set.i &mod=c &set=0 }

/*"Press [F1] to select, [F3] to toggle name/label, [F4] to exit"*/
STATUS DEFAULT qbf-lang[2].

PAUSE 0 BEFORE-HIDE.
VIEW FRAME qbf-pick.

ASSIGN
  qbf-d = FRAME-DOWN(qbf-pick)
  qbf-o = (IF qbf-o = ? THEN "" ELSE qbf-o)
  qbf-r = 1
/*qbf-d = MINIMUM(SCREEN-LINES - 7,qbf-d)*/
  qbf-k = 1.
IF qbf-o <> "" THEN
  DO qbf-j = 1 TO qbf-ctop WHILE qbf-i = ?:
    {&FIND_QBF_CFLD} qbf-j + qbf-b - 1.
    qbf-t = ENTRY(1,qbf-cfld.cValue) + ".":U
          + ENTRY(2,qbf-cfld.cValue).
    IF qbf-i = ? AND qbf-t = qbf-o THEN
      ASSIGN
        qbf-i = MINIMUM(qbf-d,qbf-j)
        qbf-r = qbf-j.
  END.
ASSIGN
  qbf-t = ""
/*qbf-d = MINIMUM(qbf-ctop,qbf-d)*/
  qbf-o = ""
  qbf-z = FILL("Z",LENGTH(STRING(qbf-ctop)))
  qbf-x = FRAME-COL(qbf-pick) + 42 - LENGTH(qbf-z).

PUT SCREEN ROW qbf-d + FRAME-ROW(qbf-pick) + 1 COLUMN qbf-x
  COLOR VALUE(qbf-plo) STRING(qbf-ctop).
qbf-x = qbf-x - LENGTH(qbf-xofy) - 1.
PUT SCREEN ROW qbf-d + FRAME-ROW(qbf-pick) + 1 COLUMN qbf-x
  COLOR VALUE(qbf-plo) qbf-xofy.
qbf-x = qbf-x - LENGTH(qbf-z) - 1.

DO WHILE TRUE:

  qbf-r = MINIMUM(qbf-ctop,MAXIMUM(qbf-r,1)).
  IF qbf-r < FRAME-LINE(qbf-pick) THEN
    DOWN qbf-r - FRAME-LINE(qbf-pick) WITH FRAME qbf-pick.

  IF LENGTH(qbf-t) > 0 THEN
    DISPLAY qbf-t WITH FRAME qbf-type.
  ELSE
    HIDE FRAME qbf-type NO-PAUSE.

  IF qbf-w THEN DO:
    ASSIGN
      qbf-l = MAXIMUM(1,FRAME-LINE(qbf-pick))
      qbf-k = qbf-r - (IF qbf-i = ? THEN qbf-l ELSE qbf-i) + 1.
    UP qbf-l - 1 WITH FRAME qbf-pick.
    IF qbf-k < 1 THEN ASSIGN
      qbf-k = 1
      qbf-l = 1
      qbf-r = 1.
    DO qbf-j = qbf-k TO qbf-k + qbf-d - 1:
      IF qbf-j > qbf-ctop THEN
        CLEAR FRAME qbf-pick NO-PAUSE.
      ELSE DO:
        {&FIND_QBF_CFLD} qbf-j + qbf-b - 1.
        { prores/s-field.i qbf-cfld.cValue }
        DISPLAY qbf-1 @ qbf-f WITH FRAME qbf-pick.
      END.
      IF qbf-j < qbf-k + qbf-d - 1 THEN
        DOWN 1 WITH FRAME qbf-pick.
    END.
    qbf-l = (IF qbf-i = ? THEN qbf-l ELSE qbf-i).
    UP qbf-d - qbf-l WITH FRAME qbf-pick.
    ASSIGN
      qbf-i = ?
      qbf-w = FALSE.
    PUT SCREEN COLOR VALUE(qbf-plo)
      ROW qbf-d + FRAME-ROW(qbf-pick) + 1 COLUMN FRAME-COL(qbf-pick) + 2
      STRING(qbf-toggle1,qbf-lang[5]). /*"Label/Name-"*/
  END.

  {&FIND_QBF_CFLD} qbf-r + qbf-b - 1.
  /*{ prores/s-field.i qbf-cfld[qbf-r + qbf-b - 1] }*/
  { prores/s-field.i qbf-cfld.cValue }
  DISPLAY qbf-1 @ qbf-f WITH FRAME qbf-pick.

  PUT SCREEN ROW qbf-d + 1 + FRAME-ROW(qbf-pick) COLUMN qbf-x
    COLOR VALUE(qbf-plo) STRING(qbf-r,qbf-z).
  COLOR DISPLAY VALUE(qbf-phi) qbf-f WITH FRAME qbf-pick.
  READKEY.
  COLOR DISPLAY VALUE(qbf-plo) qbf-f WITH FRAME qbf-pick.

  IF LENGTH(qbf-t) = 0 AND INDEX("1234567890",CHR(LASTKEY)) > 0 THEN .
  ELSE
  IF (KEYFUNCTION(LASTKEY) = CHR(LASTKEY) AND LASTKEY >= 32)
    OR (KEYFUNCTION(LASTKEY) = "BACKSPACE" AND LENGTH(qbf-t) > 0) THEN DO:
    ASSIGN
      qbf-t = (IF KEYFUNCTION(LASTKEY) = "BACKSPACE"
              THEN SUBSTRING(qbf-t,1,LENGTH(qbf-t) - 1)
              ELSE qbf-t + CHR(LASTKEY))
      qbf-v = qbf-cfld.cValue.
      IF qbf-t = ""
        OR (IF qbf-toggle1 THEN SUBSTRING(qbf-v,INDEX(qbf-v,"|") + 1)
        ELSE ENTRY(2,qbf-v)) BEGINS qbf-t THEN NEXT.
    DO qbf-l = qbf-r TO qbf-ctop:
      {&FIND_QBF_CFLD} qbf-l + qbf-b - 1.
      qbf-v = qbf-cfld.cValue.
      IF (IF qbf-toggle1 THEN SUBSTRING(qbf-v,INDEX(qbf-v,"|") + 1)
        ELSE ENTRY(2,qbf-v)) BEGINS qbf-t THEN LEAVE.
    END.
    IF qbf-l > qbf-ctop THEN DO:
      DO qbf-l = 1 TO qbf-r:
        {&FIND_QBF_CFLD} qbf-l + qbf-b - 1.
        qbf-v = qbf-cfld.cValue.
        IF (IF qbf-toggle1 THEN SUBSTRING(qbf-v,INDEX(qbf-v,"|") + 1)
          ELSE ENTRY(2,qbf-v)) BEGINS qbf-t THEN LEAVE.
      END.
      IF qbf-l > qbf-r THEN qbf-l = qbf-ctop + 1.
    END.
    IF qbf-l > qbf-ctop THEN DO:
      qbf-t = CHR(LASTKEY).
      DO qbf-l = 1 TO qbf-ctop:
        {&FIND_QBF_CFLD} qbf-l + qbf-b - 1.
        qbf-v = qbf-cfld.cValue.
        IF (IF qbf-toggle1 THEN SUBSTRING(qbf-v,INDEX(qbf-v,"|") + 1)
          ELSE ENTRY(2,qbf-v)) BEGINS qbf-t THEN LEAVE.
      END.
    END.
    ASSIGN
      qbf-l = (IF qbf-l <= qbf-ctop THEN qbf-l ELSE qbf-r)
      qbf-k = qbf-l - qbf-r + FRAME-LINE(qbf-pick)
      qbf-r = qbf-l.
    IF qbf-k < 1 OR qbf-k > MINIMUM(qbf-d,qbf-ctop) THEN
      qbf-w = TRUE.
    ELSE
      UP FRAME-LINE(qbf-pick) - qbf-k WITH FRAME qbf-pick.
    NEXT.
  END.

  IF KEYFUNCTION(LASTKEY) = "INSERT-MODE" THEN
    ASSIGN
      qbf-w       = TRUE
      qbf-toggle1 = NOT qbf-toggle1.
  IF CAN-DO("CURSOR-DOWN,TAB",KEYFUNCTION(LASTKEY))
    AND qbf-r < qbf-ctop THEN DO:
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
    IF qbf-r + qbf-d - FRAME-LINE(qbf-pick) > qbf-ctop THEN DO:
      qbf-r = qbf-ctop.
      DOWN MINIMUM(qbf-ctop,qbf-d) - FRAME-LINE(qbf-pick)
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
      qbf-r = (IF qbf-r > qbf-b THEN qbf-b ELSE qbf-ctop)
      qbf-w = TRUE.
    UP FRAME-LINE(qbf-pick) - (IF qbf-r = qbf-b THEN 1 ELSE qbf-d)
      WITH FRAME qbf-pick.
  END.
  ELSE
  IF CAN-DO("GO,RETURN",KEYFUNCTION(LASTKEY)) THEN DO:
    {&FIND_QBF_CFLD} qbf-r + qbf-b - 1.
    IF qbf-f <> "current"
      AND ENTRY(2,qbf-cfld.cValue) MATCHES "*[]" THEN
      RUN prores/c-vector.p (
        "e" + STRING(FRAME-ROW(qbf-pick) * 1000 + FRAME-ROW(qbf-pick),"999999")
        ,?,INPUT-OUTPUT qbf-cfld.cValue,OUTPUT qbf-v).
    IF KEYFUNCTION(LASTKEY) <> "END-ERROR" THEN DO:
      qbf-o = ENTRY(1,qbf-cfld.cValue) + "."
            + ENTRY(2,qbf-cfld.cValue).
      LEAVE.
    END.
    qbf-w = ?.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "HELP" AND LENGTH(qbf-module) > 2 THEN DO:
    RUN prores/applhelp.p.
    qbf-w = ?.
  END.
  ELSE
  IF CAN-DO("GET,END-ERROR",KEYFUNCTION(LASTKEY)) THEN LEAVE.

  IF qbf-w = ? THEN DO:
    qbf-w = FALSE.
    PUT SCREEN
      ROW qbf-d + FRAME-ROW(qbf-pick) + 1
      COLUMN qbf-x + LENGTH(qbf-z + qbf-xofy) + 2
      COLOR VALUE(qbf-plo) STRING(qbf-ctop).
    PUT SCREEN
      ROW qbf-d + FRAME-ROW(qbf-pick) + 1 COLUMN qbf-x + LENGTH(qbf-z) + 1
      COLOR VALUE(qbf-plo) qbf-xofy.
  END.

END.

/*HIDE FRAME qbf-pick NO-PAUSE.*/
HIDE FRAME qbf-type NO-PAUSE.

PAUSE BEFORE-HIDE.
STATUS DEFAULT.

{ prores/t-reset.i }
RETURN.
