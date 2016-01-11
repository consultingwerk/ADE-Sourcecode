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
/* c-form.p - scrolling list of query forms */

{ prores/s-system.i }
{ prores/t-define.i }
{ prores/c-form.i }
{ prores/reswidg.i }
{ prores/resfunc.i }

DEFINE INPUT        PARAMETER qbf-g AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER qbf-f AS CHARACTER NO-UNDO.

/* If qbf-f begins with a "*", then just find qbf-f as a matching 
   ENTRY(1,qbf-form) and return the qbf-form value in qbf-f.  IF qbf-f 
   begins with "#", do the same but compare with ENTRY(2,...).  
   Otherwise, lookup and return all of qbf-form for user selection.  
   For latter case, lookup for initial value is on ENTRY(2,...). */

/*local:*/
DEFINE VARIABLE qbf-b AS CHARACTER              NO-UNDO.
DEFINE VARIABLE qbf-c AS INTEGER   INITIAL   15 NO-UNDO.
DEFINE VARIABLE qbf-d AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-n AS CHARACTER              NO-UNDO.
DEFINE VARIABLE qbf-o AS INTEGER   INITIAL    ? NO-UNDO.
DEFINE VARIABLE qbf-q AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-r AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-s AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER              NO-UNDO.
DEFINE VARIABLE qbf-w AS LOGICAL   INITIAL TRUE NO-UNDO.
DEFINE VARIABLE qbf-x AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-y AS INTEGER   INITIAL    3 NO-UNDO.
DEFINE VARIABLE qbf-z AS CHARACTER              NO-UNDO.

/* descriptions from db */
DEFINE VARIABLE qbf-a AS CHARACTER EXTENT 100 INITIAL ? NO-UNDO.
/* qbf-a is a cache of db.file descriptions.  It is of the form
   "####description", where #### is the offset into qbf-form.cValue.  The
   subscript of the array is given by the formula "(qbf-r - 1) MODULO
   <extent> + 1"  Currently, <extent> = 100. */

/*forms:*/
FORM
  qbf-form.cValue FORMAT "x(48)"
  WITH FRAME qbf-pick SCROLL 1 OVERLAY NO-LABELS ATTR-SPACE
  qbf-d DOWN ROW qbf-y COLUMN qbf-c
  COLOR DISPLAY VALUE(qbf-plo) PROMPT VALUE(qbf-phi)
  TITLE COLOR VALUE(qbf-plo) " " + qbf-b + " ".

FORM
  qbf-t FORMAT "x(48)"
  WITH FRAME qbf-type OVERLAY NO-LABELS ATTR-SPACE
  ROW qbf-d + qbf-y + 2 COLUMN qbf-c
  COLOR DISPLAY VALUE(qbf-plo) PROMPT VALUE(qbf-phi).

/*message "[c-form.p]" view-as alert-box.*/

IF qbf-form# <= 0 THEN RETURN.

ASSIGN
  qbf-q = (IF qbf-f BEGINS "*" THEN 1 ELSE IF qbf-f BEGINS "#" THEN 2 ELSE 0)
  qbf-f = SUBSTRING(qbf-f,IF qbf-q = 0 THEN 1 ELSE 2)
  qbf-r = 1
  qbf-d = SCREEN-LINES - 11.
IF qbf-f <> "" AND qbf-f <> ? THEN DO:
  /* I wish I could do a binary search here */
  IF qbf-q = 1 THEN
  DO qbf-s = 1 TO qbf-form#:
    {&FIND_QBF_FORM} qbf-s.
    IF qbf-f = ENTRY(1,qbf-form.cValue) THEN LEAVE.
  END.
  ELSE
  DO qbf-s = 1 TO qbf-form#:
    {&FIND_QBF_FORM} qbf-s.
    IF qbf-f = ENTRY(2,qbf-form.cValue) OR 
      (ENTRY(2,qbf-form.cValue) = "" AND
        qbf-f = SUBSTRING(ENTRY(1,qbf-form.cValue),
                  INDEX(ENTRY(1,qbf-form.cValue),".") + 1,8))
      THEN LEAVE.
  END.

  IF qbf-s <= qbf-form# THEN 
    ASSIGN
      qbf-o = MINIMUM(qbf-d,qbf-s)
      qbf-r = qbf-s.
END.
ASSIGN
  qbf-d = MINIMUM(qbf-form#,qbf-d)
  qbf-f = ?.

IF qbf-q > 0 THEN DO:
  {&FIND_QBF_FORM} qbf-s.
  qbf-f = (IF qbf-s <= qbf-form# THEN qbf-form.cValue ELSE "").
  IF ENTRY(2,qbf-f) = "" THEN
    SUBSTRING(qbf-f,INDEX(qbf-f,",") + 1,0) =
      SUBSTRING(ENTRY(1,qbf-f),INDEX(ENTRY(1,qbf-f),".") + 1,8).
  RETURN.
END.

{ prores/t-set.i &mod=c &set=0 }

qbf-b = qbf-lang[12]. /*"Select Query Form"*/
DO WHILE qbf-g <> "":
  IF qbf-g BEGINS "b" THEN ASSIGN /* banner (title) */
    qbf-b = SUBSTRING(qbf-g,2)
    qbf-g = "".
  ELSE
  IF qbf-g BEGINS "c" THEN ASSIGN /* column */
    qbf-c = INTEGER(SUBSTRING(qbf-g,2,3))
    qbf-g = SUBSTRING(qbf-g,5).
  ELSE
  IF qbf-g BEGINS "r" THEN ASSIGN /* row */
    qbf-y = INTEGER(SUBSTRING(qbf-g,2,3))
    qbf-g = SUBSTRING(qbf-g,5).
END.

PAUSE 0 BEFORE-HIDE.
VIEW FRAME qbf-pick.

ASSIGN
  qbf-z = FILL("Z",LENGTH(STRING(qbf-form#)))
  qbf-x = 50 + qbf-c - LENGTH(qbf-z).
PUT SCREEN ROW qbf-d + qbf-y + 1 COLUMN qbf-x COLOR VALUE(qbf-plo)
  STRING(qbf-form#).
qbf-x = qbf-x - LENGTH(qbf-xofy) - 1.
PUT SCREEN ROW qbf-d + qbf-y + 1 COLUMN qbf-x COLOR VALUE(qbf-plo) qbf-xofy.
qbf-x = qbf-x - LENGTH(qbf-z) - 1.

/*"Press [GO] when done, [INSERT-MODE] to toggle descriptions/names/programs"*/
STATUS DEFAULT qbf-lang[4].

DO WHILE TRUE:
  qbf-r = MINIMUM(qbf-form#,MAXIMUM(qbf-r,1)).
  {&FIND_QBF_FORM} qbf-r.
  IF qbf-r < FRAME-LINE(qbf-pick) THEN
    DOWN qbf-r - FRAME-LINE(qbf-pick) WITH FRAME qbf-pick.

  IF LENGTH(qbf-t) > 0 THEN
    DISPLAY qbf-t WITH FRAME qbf-type.
  ELSE
    HIDE FRAME qbf-type NO-PAUSE.

  IF qbf-w THEN DO WITH FRAME qbf-pick:
    ASSIGN
      qbf-l = MAXIMUM(1,FRAME-LINE)
      qbf-s = qbf-r - (IF qbf-o = ? THEN qbf-l ELSE qbf-o) + 1.
    UP qbf-l - 1.
    IF qbf-s < 1 THEN ASSIGN
      qbf-s = 1
      qbf-l = 1
      qbf-r = 1.
    DO qbf-i = qbf-s TO qbf-s + qbf-d - 1:
      {&FIND_QBF_FORM} qbf-i.
        
      IF qbf-i <= qbf-form#
        AND qbf-toggle3 = 3
        AND qbf-form.cDesc = ""
        AND INTEGER(SUBSTRING(qbf-a[qbf-i MODULO 100 + 1],1,4)) <>
          qbf-i THEN DO:
        RUN prores/s-lookup.p (ENTRY(1,qbf-form.cValue),"","",
                               "FILE:DESC",OUTPUT qbf-n).
        qbf-a[qbf-i MODULO 100 + 1] = STRING(qbf-i,"9999")
                                    + SUBSTRING(qbf-n,1,48).
      END.
      IF qbf-i > qbf-form# THEN
        CLEAR NO-PAUSE.
      ELSE
        DISPLAY { prores/s-form.i qbf-i } @ qbf-form.cValue.

      IF qbf-i < qbf-s + qbf-d - 1 THEN DOWN 1.
    END.
    qbf-l = (IF qbf-o = ? THEN qbf-l ELSE qbf-o).
    UP qbf-d - qbf-l.
    ASSIGN
      qbf-o = ?
      qbf-w = FALSE.
    PUT SCREEN ROW qbf-d + qbf-y + 1 COLUMN qbf-c + 2 COLOR VALUE(qbf-plo)
      ENTRY(qbf-toggle3,qbf-lang[7]). /*"File,Prog,Desc"*/
  END.

  {&FIND_QBF_FORM} qbf-r.
  IF qbf-toggle3 = 3
    AND qbf-form.cDesc = ""
    AND INTEGER(SUBSTRING(qbf-a[qbf-r MODULO 100 + 1],1,4)) <> qbf-r THEN DO:
    RUN prores/s-lookup.p (ENTRY(1,qbf-form.cValue),"","","FILE:DESC",
                           OUTPUT qbf-n).
    qbf-a[qbf-r MODULO 100 + 1] = STRING(qbf-r,"9999") + SUBSTRING(qbf-n,1,48).
  END.

  DISPLAY { prores/s-form.i qbf-r } @ qbf-form.cValue WITH FRAME qbf-pick.

  PUT SCREEN ROW qbf-d + qbf-y + 1 COLUMN qbf-x COLOR VALUE(qbf-plo)
    STRING(qbf-r,qbf-z).
  COLOR DISPLAY VALUE(qbf-phi) qbf-form.cValue WITH FRAME qbf-pick.
  READKEY.
  COLOR DISPLAY VALUE(qbf-plo) qbf-form.cValue WITH FRAME qbf-pick.

  IF (KEYFUNCTION(LASTKEY) = CHR(LASTKEY) AND LASTKEY >= 32)
    OR (KEYFUNCTION(LASTKEY) = "BACKSPACE" AND LENGTH(qbf-t) > 0) THEN DO:
    qbf-t = (IF KEYFUNCTION(LASTKEY) = "BACKSPACE"
            THEN SUBSTRING(qbf-t,1,LENGTH(qbf-t) - 1)
            ELSE qbf-t + CHR(LASTKEY)).
    /*IF qbf-t = "" OR { prores/s-form.i qbf-r } BEGINS qbf-t THEN NEXT.*/
    IF qbf-t = "" OR { prores/s-form.i qbf-r } BEGINS qbf-t THEN NEXT.

    DO qbf-l = qbf-r TO qbf-form#:
      {&FIND_QBF_FORM} qbf-l.
      IF qbf-toggle3 = 3 AND
        INTEGER(SUBSTRING(qbf-a[qbf-l MODULO 100 + 1],1,4)) <> qbf-l THEN DO:
        RUN prores/s-lookup.p (ENTRY(1,qbf-form.cValue),"","","FILE:DESC",
                               OUTPUT qbf-n).
        qbf-a[qbf-l MODULO 100 + 1] = STRING(qbf-l,"9999")
                                    + SUBSTRING(qbf-n,1,48).
      END.
      IF { prores/s-form.i qbf-l } BEGINS qbf-t THEN LEAVE.
    END.
    IF qbf-l > qbf-form# THEN DO:
      DO qbf-l = 1 TO qbf-r:
        {&FIND_QBF_FORM} qbf-l.
        IF qbf-toggle3 = 3 AND
          INTEGER(SUBSTRING(qbf-a[qbf-l MODULO 100 + 1],1,4)) <> qbf-l THEN DO:
          RUN prores/s-lookup.p (ENTRY(1,qbf-form.cValue),"","","FILE:DESC",
                                 OUTPUT qbf-n).
          qbf-a[qbf-l MODULO 100 + 1] = STRING(qbf-l,"9999")
                                      + SUBSTRING(qbf-n,1,48).
        END.
        IF { prores/s-form.i qbf-l } BEGINS qbf-t THEN LEAVE.
      END.
      IF qbf-l > qbf-r THEN 
        qbf-l = qbf-form# + 1.
    END.
    IF qbf-l > qbf-form# THEN DO:
      qbf-t = CHR(LASTKEY).
      DO qbf-l = 1 TO qbf-form#:
        {&FIND_QBF_FORM} qbf-l.
        IF qbf-toggle3 = 3 AND
          INTEGER(SUBSTRING(qbf-a[qbf-l MODULO 100 + 1],1,4)) <> qbf-l THEN DO:
          RUN prores/s-lookup.p (ENTRY(1,qbf-form.cValue),"","","FILE:DESC",
                                 OUTPUT qbf-n).
          qbf-a[qbf-l MODULO 100 + 1] = STRING(qbf-l,"9999")
                                      + SUBSTRING(qbf-n,1,48).
        END.
        IF { prores/s-form.i qbf-l } BEGINS qbf-t THEN LEAVE.
      END.
    END.
    ASSIGN
      qbf-l = (IF qbf-l <= qbf-form# THEN qbf-l ELSE qbf-r)
      qbf-s = qbf-l - qbf-r + FRAME-LINE(qbf-pick)
      qbf-r = qbf-l.
    IF qbf-s < 1 OR qbf-s > qbf-d THEN
      qbf-w = TRUE.
    ELSE
      UP FRAME-LINE(qbf-pick) - qbf-s WITH FRAME qbf-pick.
    NEXT.
  END.

  qbf-t = "".
  IF KEYFUNCTION(LASTKEY) = "INSERT-MODE" THEN
    ASSIGN
      qbf-w       = TRUE
      qbf-toggle3 = (qbf-toggle3 MODULO 3) + 1.
  IF CAN-DO("CURSOR-DOWN,TAB",KEYFUNCTION(LASTKEY))
    AND qbf-r < qbf-form# THEN DO:
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
    IF qbf-r + qbf-d - FRAME-LINE(qbf-pick) > qbf-form# THEN DO:
      qbf-r = qbf-form#.
      DOWN MINIMUM(qbf-form#,qbf-d) - FRAME-LINE(qbf-pick)
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
      qbf-r = (IF qbf-r > 1 THEN 1 ELSE qbf-form#)
      qbf-w = TRUE.
    IF qbf-r = 1 THEN
      UP FRAME-LINE(qbf-pick) - 1 WITH FRAME qbf-pick.
    ELSE
      DOWN qbf-d - FRAME-LINE(qbf-pick) WITH FRAME qbf-pick.
  END.
  ELSE
  IF CAN-DO("GO,RETURN",KEYFUNCTION(LASTKEY)) THEN DO:
    {&FIND_QBF_FORM} qbf-r.
    qbf-f = qbf-form.cValue.
    IF ENTRY(2,qbf-f) = "" THEN
      SUBSTRING(qbf-f,INDEX(qbf-f,",") + 1,0) =
        SUBSTRING(ENTRY(1,qbf-f),INDEX(ENTRY(1,qbf-f),".") + 1,8).
    LEAVE.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN LEAVE.

END.

HIDE FRAME qbf-pick NO-PAUSE.
HIDE FRAME qbf-type NO-PAUSE.
PAUSE BEFORE-HIDE.
STATUS DEFAULT.
qbf-f = (IF qbf-f = ? THEN "" ELSE qbf-f).

{ prores/t-reset.i }
RETURN.
