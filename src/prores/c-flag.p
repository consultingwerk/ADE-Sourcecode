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
/* c-flag.p - scrolling-list routine for a-form.p */

{ prores/s-system.i }
{ prores/t-define.i }
{ prores/c-merge.i }
{ prores/reswidg.i }
{ prores/resfunc.i }

DEFINE INPUT-OUTPUT PARAMETER qbf-r AS INTEGER NO-UNDO.

DEFINE VARIABLE qbf-b AS INTEGER   INITIAL   46 NO-UNDO. /*make s-file.i happy*/
DEFINE VARIABLE qbf-d AS INTEGER   INITIAL   10 NO-UNDO.
DEFINE VARIABLE qbf-g AS CHARACTER INITIAL  "q" NO-UNDO. /*make s-file.i happy*/
DEFINE VARIABLE qbf-i AS INTEGER   INITIAL    ? NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-k AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-m AS LOGICAL                NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER INITIAL   "" NO-UNDO.
DEFINE VARIABLE qbf-w AS LOGICAL   INITIAL TRUE NO-UNDO.
DEFINE VARIABLE qbf-x AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-z AS CHARACTER              NO-UNDO.

/*
qbf-r       is chosen array element index.  if on entry, qbf-r = ?,
            then allow multiple picks.
qbf-schema  is array of filenames
qbf-schema# is upper bound of array
qbf-schema% is scalar of flags to be appended to filenames ("*" or " ")
*/

FORM
  qbf-t FORMAT "x(50)"
  WITH FRAME qbf-pick SCROLL 1 OVERLAY NO-LABELS ATTR-SPACE
  qbf-d DOWN ROW 4 COLUMN 26
  TITLE COLOR VALUE(qbf-plo) " " + qbf-lang[10] + " ".  /*" Select File "*/

FORM
  qbf-t FORMAT "x(50)"
  WITH FRAME qbf-type ATTR-SPACE
  COLOR DISPLAY VALUE(qbf-plo) PROMPT VALUE(qbf-phi)
  OVERLAY NO-LABELS ROW qbf-d + 6 COLUMN 26.

/*message "[c-flag.p]" view-as alert-box.*/

ASSIGN
  qbf-m = (qbf-r = ?)
  qbf-r = 0.
IF qbf-schema# <= 0 THEN RETURN.

{ prores/t-set.i &mod=c &set=0 }

ASSIGN
  qbf-r = 1
  qbf-d = MINIMUM(qbf-schema#,IF qbf-d > 0 THEN qbf-d ELSE SCREEN-LINES - 9)
  qbf-z = FILL("Z",LENGTH(STRING(qbf-schema#)))
  qbf-x = 77 - LENGTH(qbf-z).

PAUSE 0 BEFORE-HIDE.
VIEW FRAME qbf-pick.

PUT SCREEN ROW qbf-d + 5 COLUMN qbf-x COLOR VALUE(qbf-plo) STRING(qbf-schema#).
qbf-x = qbf-x - LENGTH(qbf-xofy) - 1.
PUT SCREEN ROW qbf-d + 5 COLUMN qbf-x COLOR VALUE(qbf-plo) qbf-xofy.
qbf-x = qbf-x - LENGTH(qbf-z) - 1.

DO WHILE TRUE:

  qbf-r = MINIMUM(qbf-schema#,MAXIMUM(qbf-r,1)).
  IF qbf-r < FRAME-LINE(qbf-pick) THEN
    DOWN qbf-r - FRAME-LINE(qbf-pick) WITH FRAME qbf-pick.

  IF LENGTH(qbf-t) > 0 THEN
    DISPLAY qbf-t WITH FRAME qbf-type.
  ELSE
    HIDE FRAME qbf-type NO-PAUSE.

  IF qbf-w THEN DO WITH FRAME qbf-pick:
    ASSIGN
      qbf-l = MAXIMUM(1,FRAME-LINE)
      qbf-j = qbf-r - (IF qbf-i = ? THEN qbf-l ELSE qbf-i) + 1.
    UP qbf-l - 1.
    IF qbf-j < 1 THEN
      ASSIGN
        qbf-j = 1
        qbf-l = 1
        qbf-r = 1.
    DO qbf-k = qbf-j TO qbf-j + qbf-d - 1:
      IF qbf-k > qbf-schema# THEN
        CLEAR NO-PAUSE.
      ELSE DO:
        {&FIND_QBF_SCHEMA} qbf-k.
        DISPLAY SUBSTRING(qbf-schema%,qbf-k,1) + " " + { prores/s-file.i }
          @ qbf-t.
      END.
      IF qbf-k < qbf-j + qbf-d - 1 THEN DOWN 1.
    END.
    qbf-l = (IF qbf-i = ? THEN qbf-l ELSE qbf-i).
    UP qbf-d - qbf-l.
    ASSIGN
      qbf-i = ?
      qbf-w = FALSE.
    PUT SCREEN ROW qbf-d + 5 COLUMN 28 COLOR VALUE(qbf-plo)
      STRING(qbf-toggle2,qbf-lang[6]). /*"Desc/Name"*/
  END.

  {&FIND_QBF_SCHEMA} qbf-r.
  DISPLAY SUBSTRING(qbf-schema%,qbf-r,1) + " " + { prores/s-file.i } 
    @ qbf-t
    WITH FRAME qbf-pick.

  PUT SCREEN ROW qbf-d + 5 COLUMN qbf-x COLOR VALUE(qbf-plo)
    STRING(qbf-r,qbf-z).
  COLOR DISPLAY VALUE(qbf-phi) qbf-t WITH FRAME qbf-pick.
  READKEY.
  COLOR DISPLAY VALUE(qbf-plo) qbf-t WITH FRAME qbf-pick.

  IF (KEYFUNCTION(LASTKEY) = CHR(LASTKEY) AND LASTKEY >= 32)
    OR (KEYFUNCTION(LASTKEY) = "BACKSPACE" AND LENGTH(qbf-t) > 0) THEN DO:
    qbf-t = (IF KEYFUNCTION(LASTKEY) = "BACKSPACE"
            THEN SUBSTRING(qbf-t,1,LENGTH(qbf-t) - 1)
            ELSE qbf-t + CHR(LASTKEY)).

    {&FIND_QBF_SCHEMA} qbf-r.
    IF qbf-t = "" OR { prores/s-file.i } BEGINS qbf-t THEN NEXT.

    DO qbf-l = qbf-r TO qbf-schema#:
      {&FIND_QBF_SCHEMA} qbf-l.
      IF { prores/s-file.i } BEGINS qbf-t THEN LEAVE.
    END.
    IF qbf-l > qbf-schema# THEN DO:
      DO qbf-l = 1 TO qbf-r:
        {&FIND_QBF_SCHEMA} qbf-l.
        IF { prores/s-file.i } BEGINS qbf-t THEN LEAVE.
      END.
      IF qbf-l > qbf-r THEN 
        qbf-l = qbf-schema# + 1.
    END.
    IF qbf-l > qbf-schema# THEN DO:
      qbf-t = CHR(LASTKEY).
      DO qbf-l = 1 TO qbf-schema#:
        {&FIND_QBF_SCHEMA} qbf-l.
        IF { prores/s-file.i } BEGINS qbf-t THEN LEAVE.
      END.
    END.
    ASSIGN
      qbf-l = (IF qbf-l <= qbf-schema# THEN qbf-l ELSE qbf-r)
      qbf-j = qbf-l - qbf-r + FRAME-LINE(qbf-pick)
      qbf-r = qbf-l.
    IF qbf-j < 1 OR qbf-j > qbf-d THEN
      qbf-w = TRUE.
    ELSE
      UP FRAME-LINE(qbf-pick) - qbf-j WITH FRAME qbf-pick.
    NEXT.
  END.

  qbf-t = "".
  IF qbf-m AND KEYFUNCTION(LASTKEY) = "RETURN" THEN DO:
    SUBSTRING(qbf-schema%,qbf-r,1)
      = (IF SUBSTRING(qbf-schema%,qbf-r,1) = "*" THEN " " ELSE "*").
    {&FIND_QBF_SCHEMA} qbf-r.
    DISPLAY SUBSTRING(qbf-schema%,qbf-r,1) + " " + { prores/s-file.i } 
      @ qbf-t
      WITH FRAME qbf-pick.
  END.
  IF KEYFUNCTION(LASTKEY) = "INSERT-MODE" THEN
    ASSIGN
      qbf-w       = TRUE
      qbf-toggle2 = NOT qbf-toggle2.
  ELSE
  IF CAN-DO("CURSOR-DOWN,TAB",KEYFUNCTION(LASTKEY))
    OR (qbf-m AND KEYFUNCTION(LASTKEY) = "RETURN") THEN DO:
    IF qbf-r < qbf-schema# THEN DO:
      qbf-r = qbf-r + 1.
      IF FRAME-LINE(qbf-pick) = FRAME-DOWN(qbf-pick) THEN
        SCROLL UP WITH FRAME qbf-pick.
      ELSE
        DOWN WITH FRAME qbf-pick.
    END.
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
    IF qbf-r + qbf-d - FRAME-LINE(qbf-pick) > qbf-schema# THEN DO:
      qbf-r = qbf-schema#.
      DOWN MINIMUM(qbf-schema#,qbf-d) - FRAME-LINE(qbf-pick)
        WITH FRAME qbf-pick.
    END.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "PAGE-UP" THEN
    ASSIGN
      qbf-r = qbf-r - qbf-d
      qbf-w = TRUE.
  ELSE
  IF CAN-DO("HOME,MOVE",KEYFUNCTION(LASTKEY)) THEN DO:
    ASSIGN
      qbf-r = (IF qbf-r > 1 THEN 1 ELSE qbf-schema#)
      qbf-w = TRUE.
    UP FRAME-LINE(qbf-pick) - (IF qbf-r = 1 THEN 1 ELSE qbf-d)
      WITH FRAME qbf-pick.
  END.
  ELSE
  IF CAN-DO("GO,END-ERROR,RETURN",KEYFUNCTION(LASTKEY)) THEN LEAVE.

END.

UP FRAME-LINE(qbf-pick) - 1 WITH FRAME qbf-pick.
HIDE FRAME qbf-pick NO-PAUSE.
HIDE FRAME qbf-type NO-PAUSE.
PAUSE BEFORE-HIDE.

IF qbf-m THEN DO:
  qbf-r = 0.
  DO qbf-i = 1 TO qbf-schema#:
    IF SUBSTRING(qbf-schema%,qbf-i,1) = "*" THEN 
      qbf-r = qbf-r + 1.
  END.
END.
IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN qbf-r = 0.

{ prores/t-reset.i }
RETURN.
