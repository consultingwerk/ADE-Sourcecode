/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* r-column.p - play with fields/calc fields */

{ prores/s-system.i }
{ prores/s-define.i }

DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-o AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-s AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-v AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-x AS INTEGER   NO-UNDO.

DEFINE VARIABLE qbf-a LIKE qbf-rca NO-UNDO.
DEFINE VARIABLE qbf-c LIKE qbf-rcc NO-UNDO.
DEFINE VARIABLE qbf-f LIKE qbf-rcf NO-UNDO.
DEFINE VARIABLE qbf-l LIKE qbf-rcl NO-UNDO.
DEFINE VARIABLE qbf-n LIKE qbf-rcn NO-UNDO.
DEFINE VARIABLE qbf-t LIKE qbf-rct NO-UNDO.

/*message "[r-column.p]" view-as alert-box.*/

ASSIGN
  qbf-j = 0
  qbf-o = ""
  qbf-x = qbf-rc#.
DO qbf-i = 1 TO qbf-rc#:
  ASSIGN
    qbf-a[qbf-i] = qbf-rca[qbf-i]
    qbf-c[qbf-i] = qbf-rcc[qbf-i]
    qbf-f[qbf-i] = qbf-rcf[qbf-i]
    qbf-l[qbf-i] = qbf-rcl[qbf-i]
    qbf-n[qbf-i] = qbf-rcn[qbf-i]
    qbf-t[qbf-i] = qbf-rct[qbf-i]
    qbf-j        = (IF qbf-rcc[qbf-i] = "" THEN 0 ELSE
                   INDEX("rpcsdnle",SUBSTRING(qbf-rcc[qbf-i],1,1)))
    qbf-s        = ENTRY(1,qbf-rcn[qbf-i]).
  IF qbf-j = 8 THEN qbf-s = qbf-s + "[]".
  ELSE
  IF qbf-j > 0 THEN qbf-s = ENTRY(qbf-j + 1,qbf-etype) + "." + qbf-s.
  qbf-o = qbf-o + (IF qbf-i = 1 THEN "" ELSE ",") + qbf-s.
END.

RUN prores/c-field.p ("all","r002c002d012",INPUT-OUTPUT qbf-o).
IF qbf-rc# > 0 AND KEYFUNCTION(LASTKEY) = "END-ERROR" THEN RETURN.
ASSIGN
  qbf-rca = ""
  qbf-rcc = ""
  qbf-rcf = ""
  qbf-rcl = ""
  qbf-rcn = ""
  qbf-rcw = ?
  qbf-rct = 0
  qbf-rc# = 0.
DO qbf-i = 1 TO NUM-ENTRIES(qbf-o) WHILE qbf-rc# < { prores/s-limcol.i }:
  qbf-v = ENTRY(qbf-i,qbf-o).
  DO qbf-j = 1 TO qbf-x:
    IF ENTRY(1,qbf-n[qbf-j]) = qbf-v THEN LEAVE.
  END.
  IF qbf-j <= qbf-x THEN
    ASSIGN
      qbf-rc#          = qbf-rc# + 1
      qbf-rca[qbf-rc#] = qbf-a[qbf-j]
      qbf-rcc[qbf-rc#] = qbf-c[qbf-j]
      qbf-rcf[qbf-rc#] = qbf-f[qbf-j]
      qbf-rcl[qbf-rc#] = qbf-l[qbf-j]
      qbf-rcn[qbf-rc#] = qbf-n[qbf-j]
      qbf-rct[qbf-rc#] = qbf-t[qbf-j].
  ELSE DO:
    ASSIGN
      qbf-j = INDEX(qbf-v,"[")
      qbf-j = (IF qbf-j = 0 THEN 0 ELSE INTEGER(
              SUBSTRING(qbf-v,qbf-j + 1,INDEX(qbf-v,"]") - qbf-j - 1)
              )).
    RUN prores/s-lookup.p (qbf-v,"","","FIELD:TYP&FMT",OUTPUT qbf-s).
    ASSIGN
      qbf-rc#          = qbf-rc# + 1
      qbf-rcn[qbf-rc#] = qbf-v
      qbf-rca[qbf-rc#] = ""
      qbf-rcf[qbf-rc#] = SUBSTRING(qbf-s,INDEX(qbf-s,",") + 1)
      qbf-rct[qbf-rc#] = INTEGER(ENTRY(1,qbf-s)).
    RUN prores/s-lookup.p (qbf-v,"","","FIELD:EXTENT",OUTPUT qbf-s).
    RUN prores/s-lookup.p (qbf-v,"","","FIELD:COL-LABEL",
                           OUTPUT qbf-rcl[qbf-rc#]).
    ASSIGN
      qbf-rcc[qbf-rc#] = (IF qbf-j > 0 OR INTEGER(qbf-s) = 0 THEN ""
                         ELSE "e" + qbf-s)
      qbf-rcl[qbf-rc#] = qbf-rcl[qbf-rc#]
                       + (IF qbf-j = 0 THEN "" ELSE "[" + STRING(qbf-j) + "]").
  END.
END.

DO qbf-i = 1 TO qbf-rc#:
  IF NOT qbf-rcc[qbf-i] BEGINS "e" AND qbf-rcc[qbf-i] <> "" THEN
    SUBSTRING(qbf-rcn[qbf-i],5,3) = STRING(qbf-i,"999").
END.

RETURN.
