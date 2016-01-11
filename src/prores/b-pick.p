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
/* b-pick.p - select which forms to play with */

{ prores/s-system.i }
{ prores/c-form.i }
{ prores/t-define.i }
{ prores/a-define.i }
{ prores/reswidg.i }
{ prores/resfunc.i }

DEFINE VARIABLE qbf-d AS INTEGER    NO-UNDO.              /* down    */
DEFINE VARIABLE qbf-i AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-k AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-r AS INTEGER    NO-UNDO.              /* recid   */
DEFINE VARIABLE qbf-t AS CHARACTER  NO-UNDO.              /* typed   */
DEFINE VARIABLE qbf-w AS LOGICAL    NO-UNDO INITIAL TRUE. /* redraw  */
DEFINE VARIABLE qbf-x AS INTEGER    NO-UNDO.              /* column  */
DEFINE VARIABLE qbf-z AS CHARACTER  NO-UNDO.              /* max fmt */

DEFINE TEMP-TABLE qbf-f
  FIELD iIndex AS INTEGER LABEL "Index"
  FIELD lValue AS LOGICAL LABEL "Value"
  INDEX iIndex IS UNIQUE iIndex.
DEFINE BUFFER buf-f FOR qbf-f.
&GLOBAL-DEFINE FIND_QBF_F FIND qbf-f WHERE qbf-f.iIndex =
&GLOBAL-DEFINE FIND_BUF_F FIND buf-f WHERE buf-f.iIndex =

/*message "[b-pick.p]" view-as alert-box.*/

FORM
  buf-f.lValue    FORMAT "*/ "      ATTR-SPACE SPACE(0)
  buf-form.cValue FORMAT "x(67)" NO-ATTR-SPACE
  WITH FRAME qbf-pick ATTR-SPACE OVERLAY NO-LABELS WIDTH 80
    qbf-d DOWN ROW 7 COLUMN 1
    COLOR DISPLAY VALUE(qbf-plo) PROMPT VALUE(qbf-phi).

IF qbf-form# <= 0 THEN RETURN.
{ prores/t-set.i &mod=b &set=1 }

FOR EACH qbf-form:
  CREATE qbf-f.
  ASSIGN 
    qbf-f.iIndex = qbf-form.iIndex
    qbf-f.lValue = TRUE. /* lazy recompile assumes all forms up-to-date */
END.

ASSIGN
  /*qbf-f = TRUE /* default is keep 'em all */*/
  qbf-z = FILL("Z",LENGTH(STRING(qbf-form#)))
  qbf-x = 73 - LENGTH(qbf-z)
  qbf-d = SCREEN-LINES - 8
  qbf-r = 1
  qbf-t = "".

PAUSE 0 BEFORE-HIDE.
VIEW FRAME qbf-pick.
PUT SCREEN ROW 6 COLUMN 3 "* " + ENTRY(2,qbf-lang[1]).
PUT SCREEN ROW 7 COLUMN 2 " ".
PUT SCREEN ROW 7 COLUMN 4 " ".

/*"All marked forms will be built.  Use [RETURN] to mark/unmark."*/
/*"Press [GO] when done, or [END-ERROR] to quit."*/
MESSAGE STRING(qbf-lang[7],"x(78)").
MESSAGE STRING(qbf-lang[8],"x(78)").

PUT SCREEN ROW SCREEN-LINES COLUMN qbf-x COLOR VALUE(qbf-plo) STRING(qbf-form#).
qbf-x = qbf-x - LENGTH(qbf-xofy) - 1.
PUT SCREEN ROW SCREEN-LINES COLUMN qbf-x COLOR VALUE(qbf-plo) qbf-xofy.
qbf-x = qbf-x - LENGTH(qbf-z) - 1.

DO WHILE TRUE:
  qbf-r = MINIMUM(qbf-form#,MAXIMUM(qbf-r,1)).
  IF qbf-r < FRAME-LINE(qbf-pick) THEN
    DOWN qbf-r - FRAME-LINE(qbf-pick) WITH FRAME qbf-pick.

  IF qbf-w THEN DO WITH FRAME qbf-pick:
    ASSIGN
      qbf-w = FALSE
      qbf-j = MAXIMUM(1,FRAME-LINE)
      qbf-k = qbf-r - qbf-j + 1.
    UP qbf-j - 1.
    IF qbf-k < 1 THEN
      ASSIGN
        qbf-k = 1
        qbf-j = 1
        qbf-r = 1.
    DO qbf-i = qbf-k TO qbf-k + qbf-d - 1:
      IF qbf-i > qbf-form# THEN
        CLEAR NO-PAUSE.
      ELSE DO:
        {&FIND_QBF_FORM} qbf-i.
        {&FIND_BUF_FORM} qbf-r.
        {&FIND_QBF_F} qbf-i.
        {&FIND_BUF_F} qbf-r.
        DISPLAY
          qbf-f.lValue @ buf-f.lValue 
          { prores/b-pick.i } @ buf-form.cValue.
      END.
      IF qbf-i < qbf-k + qbf-d - 1 THEN DOWN 1.
    END.
    UP qbf-d - qbf-j.
  END.

  {&FIND_QBF_FORM} qbf-r.
  {&FIND_BUF_FORM} qbf-r.
  {&FIND_BUF_F} qbf-r.
  DISPLAY buf-f.lValue { prores/b-pick.i } @ buf-form.cValue
    WITH FRAME qbf-pick.

  PUT SCREEN ROW SCREEN-LINES COLUMN qbf-x COLOR VALUE(qbf-plo)
    STRING(qbf-r,qbf-z).
  COLOR DISPLAY VALUE(qbf-phi) buf-f.lValue buf-form.cValue
    WITH FRAME qbf-pick.
  READKEY.
  COLOR DISPLAY VALUE(qbf-plo) buf-f.lValue buf-form.cValue
    WITH FRAME qbf-pick.

  IF (KEYFUNCTION(LASTKEY) = CHR(LASTKEY) AND LASTKEY >= 32)
    OR (KEYFUNCTION(LASTKEY) = "BACKSPACE" AND LENGTH(qbf-t) > 0) THEN DO:
    qbf-t = (IF KEYFUNCTION(LASTKEY) = "BACKSPACE"
            THEN SUBSTRING(qbf-t,1,LENGTH(qbf-t) - 1)
            ELSE qbf-t + CHR(LASTKEY)).
    {&FIND_QBF_FORM} qbf-r.
    IF qbf-t = "" OR { prores/b-pick.i } BEGINS qbf-t THEN NEXT.

    DO qbf-j = qbf-r TO qbf-form#:
      {&FIND_QBF_FORM} qbf-j.
      IF { prores/b-pick.i } BEGINS qbf-t THEN LEAVE.
    END.
    IF qbf-j > qbf-form# THEN DO:
      DO qbf-j = 1 TO qbf-r:
        {&FIND_QBF_FORM} qbf-j.
        IF { prores/b-pick.i } BEGINS qbf-t THEN LEAVE.
      END.
      IF qbf-j > qbf-r THEN 
        qbf-j = qbf-form# + 1.
    END.
    IF qbf-j > qbf-form# THEN DO:
      qbf-t = CHR(LASTKEY).
      
      DO qbf-j = 1 TO qbf-form#:
        {&FIND_QBF_FORM} qbf-j. 
        IF { prores/b-pick.i } BEGINS qbf-t THEN LEAVE.
      END.
    END.
    ASSIGN
      qbf-j = (IF qbf-j <= qbf-form# THEN qbf-j ELSE qbf-r)
      qbf-k = qbf-j - qbf-r + FRAME-LINE(qbf-pick)
      qbf-r = qbf-j.
    IF qbf-k < 1 OR qbf-k > qbf-d THEN
      qbf-w = TRUE.
    ELSE
      UP FRAME-LINE(qbf-pick) - qbf-k WITH FRAME qbf-pick.
    NEXT.
  END.

  qbf-t = "".
  IF KEYFUNCTION(LASTKEY) = "RETURN" THEN DO:
    {&FIND_BUF_F} qbf-r.
    buf-f.lValue = NOT buf-f.lValue.
    DISPLAY buf-f.lValue WITH FRAME qbf-pick.
  END.
  IF CAN-DO("RETURN,CURSOR-DOWN,TAB",KEYFUNCTION(LASTKEY))
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
    UP FRAME-LINE(qbf-pick) - (IF qbf-r = 1 THEN 1 ELSE qbf-d)
      WITH FRAME qbf-pick.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN DO:
    /*Are you sure that you want to exit?*/
    RUN prores/s-box.p (INPUT-OUTPUT qbf-w,?,?,"#15").
    IF qbf-w THEN DO:
      qbf-form# = -1.
      LEAVE.
    END.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "GO" THEN LEAVE.
END.

/* remove deleted entries and pack the viewable file listing */
ASSIGN
  qbf-k     = qbf-form#
  qbf-form# = 0.
DO qbf-i = 1 TO qbf-k:
  {&FIND_QBF_FORM} qbf-i.
  {&FIND_QBF_F} qbf-i.
  IF NOT qbf-f.lValue OR qbf-form.cValue = "" THEN NEXT.
  ASSIGN
    qbf-form#           = qbf-form# + 1.
  
  {&FIND_BUF_FORM} qbf-form#.
  ASSIGN
    buf-form.cValue     = qbf-form.cValue
    buf-form.cDesc      = qbf-form.cDesc 
    buf-form.xValue     = qbf-form.xValue.
  IF qbf-i <> qbf-form# THEN
    ASSIGN
      qbf-form.cValue = ""
      qbf-form.cDesc  = ""
      qbf-form.xValue = "".
END.

HIDE FRAME qbf-pick NO-PAUSE.
HIDE MESSAGE NO-PAUSE.
PAUSE BEFORE-HIDE.

{ prores/t-reset.i }
RETURN.
