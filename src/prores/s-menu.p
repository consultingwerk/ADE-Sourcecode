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
/* s-menu.p - do strip menu on screen top */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }
{ prores/s-menu.i }

DEFINE INPUT-OUTPUT PARAMETER qbf#     AS INTEGER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER qbf-old  AS INTEGER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER qbf-draw AS LOGICAL NO-UNDO.

DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-k AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-r AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-x AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-s AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-y AS INTEGER   NO-UNDO.

IF qbf# < 0 THEN DO:
  qbf# = - qbf#.
  RETURN.
END.

IF qbf-m-now <> qbf-module + qbf-m-aok THEN DO:
  IF qbf-module = "q" THEN DO:
    { prores/t-set.i &mod=q &set=2 }
  END.
  ELSE DO:
    { prores/t-set.i &mod=a &set=3 }
  END.

  ASSIGN
    qbf-draw  = TRUE
    qbf-s     = 0
    qbf-m-dsc = ""
    qbf-m-lim = (IF qbf-module = "q" THEN 19 ELSE 12).
  DO qbf-i = 1 TO qbf-m-lim:
    IF qbf# = 0 AND SUBSTRING(qbf-m-aok,qbf-i,1) = "y" THEN qbf# = qbf-i.
    ASSIGN
      qbf-m-dsc[qbf-i] = qbf-lang[qbf-i]
      qbf-s            = qbf-s + LENGTH(ENTRY(1,qbf-m-dsc[qbf-i])) + 2
      qbf-j            = INDEX(qbf-m-dsc[qbf-i],"~{1~}").
    IF qbf-j > 0 THEN SUBSTRING(qbf-m-dsc[qbf-i],qbf-j,3)
      = ENTRY(INDEX("dlr",qbf-module),qbf-lang[14]). /*export,label,report*/
  END.

  ASSIGN
    qbf-m-now = qbf-module + qbf-m-aok
    qbf-m-cmd = ""
    qbf-m-tbl = ""
    qbf-s     = (IF qbf-s <= 80 THEN 2 ELSE 1)
    qbf-x     = qbf-s
    qbf-y     = 1.

  DO qbf-i = 1 TO qbf-m-lim:
    IF SUBSTRING(qbf-m-aok,qbf-i,1) = "y" THEN
      SUBSTRING(qbf-m-cmd,qbf-i,1) = SUBSTRING(qbf-m-dsc[qbf-i],1,1).

    ASSIGN
      qbf-m-tbl        = qbf-m-tbl + (IF qbf-i = 1 THEN "" ELSE ",")
                       + ENTRY(1,qbf-m-dsc[qbf-i])
      qbf-m-dsc[qbf-i] = SUBSTRING(qbf-m-dsc[qbf-i],
                         INDEX(qbf-m-dsc[qbf-i],",") + 1)
      qbf-m-col[qbf-i] = qbf-x
      qbf-m-row[qbf-i] = qbf-y
      qbf-x            = qbf-m-col[qbf-i]
                       + (IF SUBSTRING(qbf-m-aok,qbf-i,1) = "y"
                         THEN LENGTH(ENTRY(qbf-i,qbf-m-tbl)) + qbf-s ELSE 0)
      qbf-y            = qbf-m-row[qbf-i].

    IF SUBSTRING(qbf-m-aok,qbf-i,1) = "y"
      AND qbf-x + LENGTH(ENTRY(qbf-i,qbf-m-tbl)) > 64 + qbf-s * 8 THEN
      ASSIGN
        qbf-x = qbf-s * 2
        qbf-y = 2.
  END.

  { prores/t-reset.i }
END.

IF qbf# = ? OR qbf# > qbf-m-lim THEN qbf# = qbf-old.
IF qbf# = ? OR qbf# = 0 OR qbf# > qbf-m-lim THEN qbf# = 1.

IF qbf-draw THEN DO:
  ASSIGN
    qbf-draw = FALSE
    qbf-r    = FILL(" ",158)
    qbf-old  = qbf-m-lim - (IF qbf# = qbf-m-lim THEN 1 ELSE 0).
  DO qbf-j = 1 TO qbf-m-lim:
    IF SUBSTRING(qbf-m-aok,qbf-j,1) = "y" THEN
      OVERLAY(qbf-r,qbf-m-col[qbf-j]
        + (IF qbf-m-row[qbf-j] = 1 THEN 0 ELSE 79),
        LENGTH(ENTRY(qbf-j,qbf-m-tbl))) = ENTRY(qbf-j,qbf-m-tbl).
  END.
  PUT SCREEN ROW 1 COLUMN 1 COLOR VALUE(qbf-mlo) SUBSTRING(qbf-r,1,79).
  IF qbf-module = "q" THEN
    PUT SCREEN ROW 2 COLUMN 1 COLOR VALUE(qbf-mlo) SUBSTRING(qbf-r,80).
END.

IF qbf-old <> qbf# THEN DO:
  PUT SCREEN
    ROW qbf-m-row[qbf-old] COLUMN qbf-m-col[qbf-old] COLOR VALUE(qbf-mlo)
    ENTRY(qbf-old,qbf-m-tbl).
  PUT SCREEN
    ROW qbf-m-row[qbf#] COLUMN qbf-m-col[qbf#] COLOR VALUE(qbf-mhi)
    ENTRY(qbf#,qbf-m-tbl).
  STATUS DEFAULT qbf-m-dsc[qbf#].
  qbf-old = qbf#.
END.

DO WHILE TRUE:
  /* put-cursor/cursor-off stuff emulates cursor positioning of CHOOSE */
  PUT CURSOR ROW qbf-m-row[qbf#] COLUMN qbf-m-col[qbf#].

  READKEY.

  PUT CURSOR OFF.
  ASSIGN
    qbf-j = INDEX(qbf-m-cmd,CHR(LASTKEY))
    qbf-k = (IF qbf# < 0 THEN - qbf# ELSE qbf#).

  IF qbf# < 0 THEN qbf# = - qbf#. /* immediate action */
  ELSE
  IF CAN-DO("CURSOR-LEFT,BACK-TAB,BACKSPACE",KEYFUNCTION(LASTKEY)) THEN DO:
    qbf# = (IF qbf# = 1 THEN qbf-m-lim ELSE qbf# - 1).
    DO WHILE SUBSTRING(qbf-m-aok,qbf#,1) = "n":
      qbf# = (IF qbf# = 1 THEN qbf-m-lim ELSE qbf# - 1).
    END.
    qbf# = - qbf#.
  END.
  ELSE
  IF CAN-DO("CURSOR-RIGHT,TAB, ",KEYFUNCTION(LASTKEY)) THEN DO:
    qbf# = (IF qbf# = qbf-m-lim THEN 1 ELSE qbf# + 1).
    DO WHILE SUBSTRING(qbf-m-aok,qbf#,1) = "n":
      qbf# = (IF qbf# = qbf-m-lim THEN 1 ELSE qbf# + 1).
    END.
    qbf# = - qbf#.
  END.
  ELSE IF CAN-DO("GET,*-DOWN",KEYFUNCTION(LASTKEY)) THEN qbf# = 1.
  ELSE IF CAN-DO("PUT,*-UP",  KEYFUNCTION(LASTKEY)) THEN qbf# = 2.
  ELSE IF KEYFUNCTION(LASTKEY) = "CLEAR" THEN qbf# = 8.
  ELSE IF CAN-DO("MOVE,HOME",KEYFUNCTION(LASTKEY)) THEN qbf# = 3.
  ELSE IF KEYFUNCTION(LASTKEY) = "HELP" THEN DO:
    qbf-module = qbf-module + STRING(qbf#).
    RUN prores/applhelp.p.
    ASSIGN
      qbf-module = SUBSTRING(qbf-module,1,1)
      qbf# = - qbf#.
  END.
  ELSE IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN qbf# = - qbf-m-lim.
  ELSE IF qbf-j > 0 THEN qbf# = qbf-j.
  ELSE IF CAN-DO("RETURN,GO",KEYFUNCTION(LASTKEY)) THEN .
  ELSE IF CAN-DO("<,>",CHR(LASTKEY)) AND qbf-module = "r" THEN
       qbf# = 12 + INDEX("<>",CHR(LASTKEY)).
  ELSE qbf# = - qbf#.

  IF qbf# > qbf-m-lim THEN LEAVE.

  IF SUBSTRING(qbf-m-aok,IF qbf# < 0 THEN - qbf# ELSE qbf#,1) = "n"
    THEN qbf# = - qbf-k.

  qbf-j = (IF qbf# < 0 THEN - qbf# ELSE qbf#).
  IF qbf-old <> qbf-j THEN DO:
    PUT SCREEN ROW qbf-m-row[qbf-old] COLUMN qbf-m-col[qbf-old]
      COLOR VALUE(qbf-mlo) ENTRY(qbf-old,qbf-m-tbl).
    PUT SCREEN ROW qbf-m-row[qbf-j]  COLUMN qbf-m-col[qbf-j]
      COLOR VALUE(qbf-mhi) ENTRY(qbf-j,qbf-m-tbl).
    STATUS DEFAULT qbf-m-dsc[qbf-j].
    qbf-old = qbf-j.
  END.

  IF qbf# > 0 THEN
    LEAVE.
  ELSE
    qbf# = - qbf#.
END.

IF qbf-module <> "r" THEN HIDE MESSAGE NO-PAUSE.
IF qbf# = qbf-m-lim OR qbf-module <> "q" THEN STATUS DEFAULT.

RETURN.
