/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* r-total.p - do report column totals */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }
{ prores/t-set.i &mod=r &set=1 }

DEFINE VARIABLE qbf-f AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-k AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER   NO-UNDO.

DEFINE NEW SHARED VARIABLE qbf-m AS CHARACTER EXTENT 5 NO-UNDO.
DEFINE NEW SHARED VARIABLE qbf-r AS LOGICAL            NO-UNDO.
DEFINE NEW SHARED VARIABLE qbf-s AS LOGICAL            NO-UNDO.
DEFINE NEW SHARED VARIABLE qbf-v AS CHARACTER NO-UNDO.

DEFINE NEW SHARED VARIABLE qbf-a AS LOGICAL   EXTENT 6 NO-UNDO. /*avg*/
DEFINE NEW SHARED VARIABLE qbf-c AS LOGICAL   EXTENT 6 NO-UNDO. /*cnt*/
DEFINE NEW SHARED VARIABLE qbf-n AS LOGICAL   EXTENT 6 NO-UNDO. /*min*/
DEFINE NEW SHARED VARIABLE qbf-t AS LOGICAL   EXTENT 6 NO-UNDO. /*tot*/
DEFINE NEW SHARED VARIABLE qbf-x AS LOGICAL   EXTENT 6 NO-UNDO. /*max*/

/*
Perform these actions:        When these fields change value:
----------------------------- ----------------------------------------------
Total Count  Min   Max   Avg
 ___   ___   ___   ___   ___  Summary Line
 ___   ___   ___   ___   ___  ________________________________________
 ___   ___   ___   ___   ___  ________________________________________
 ___   ___   ___   ___   ___  ________________________________________
 ___   ___   ___   ___   ___  ________________________________________
 ___   ___   ___   ___   ___  ________________________________________
----------------------------- ----------------------------------------------
*/

{ prores/c-field.i
  &new=NEW &down=10 &row="ROW 4" &column="COLUMN 5"
  &title="' ' + qbf-lang[17] + ' '"
}
/*title="Choose Field to Total"*/

DO WHILE TRUE:

  PAUSE 0.
  VIEW FRAME qbf-pick.
  RUN prores/s-field.p
    ("current","","integer,decimal",INPUT-OUTPUT qbf-v).
  HIDE FRAME qbf-pick NO-PAUSE.
  IF qbf-v = "" THEN LEAVE.

  IF qbf-v MATCHES "*~~.qbf-*" THEN
    qbf-v = SUBSTRING(qbf-v,INDEX(qbf-v,".qbf-") + 1).
  DO qbf-i = 1 TO qbf-rc#
    WHILE ENTRY(1,qbf-rcn[qbf-i]) <> qbf-v:
  END.

  ASSIGN
    qbf-m[1] = SUBSTRING(qbf-order[1],1,INDEX(qbf-order[1] + " "," ") - 1)
    qbf-m[2] = SUBSTRING(qbf-order[2],1,INDEX(qbf-order[2] + " "," ") - 1)
    qbf-m[3] = SUBSTRING(qbf-order[3],1,INDEX(qbf-order[3] + " "," ") - 1)
    qbf-m[4] = SUBSTRING(qbf-order[4],1,INDEX(qbf-order[4] + " "," ") - 1)
    qbf-m[5] = SUBSTRING(qbf-order[5],1,INDEX(qbf-order[5] + " "," ") - 1)
    qbf-s    = CAN-DO("1,2,4,5",STRING(qbf-rct[qbf-i]))
    qbf-r    = CAN-DO("4,5"    ,STRING(qbf-rct[qbf-i]))
    qbf-v    = qbf-lang[16] + " " + qbf-rcn[qbf-i].

  DO qbf-j = 1 TO 6:
    ASSIGN
      qbf-t[qbf-j] = qbf-rca[qbf-i] MATCHES "*t" + STRING(qbf-j) + "*"
      qbf-c[qbf-j] = qbf-rca[qbf-i] MATCHES "*c" + STRING(qbf-j) + "*"
      qbf-n[qbf-j] = qbf-rca[qbf-i] MATCHES "*n" + STRING(qbf-j) + "*"
      qbf-x[qbf-j] = qbf-rca[qbf-i] MATCHES "*x" + STRING(qbf-j) + "*"
      qbf-a[qbf-j] = qbf-rca[qbf-i] MATCHES "*a" + STRING(qbf-j) + "*".
  END.

  IF qbf-langset = "eng" THEN
    RUN prores/r-extra.p.
  ELSE
    RUN prores/r-extra.x
      VALUE("/*")
      VALUE('"' + LC(TRIM(ENTRY(1,qbf-boolean))
        + "/" + TRIM(ENTRY(2,qbf-boolean))) + '"').

  IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN LEAVE.

  ASSIGN
    qbf-r          = qbf-rca[qbf-i] MATCHES "*&*"
    qbf-s          = qbf-rca[qbf-i] MATCHES "*$*"
    qbf-rca[qbf-i] = "".
  DO qbf-j = 1 TO 6:
    qbf-rca[qbf-i] = qbf-rca[qbf-i]
                   + (IF qbf-t[qbf-j] THEN "t" + STRING(qbf-j) ELSE "")
                   + (IF qbf-c[qbf-j] THEN "c" + STRING(qbf-j) ELSE "")
                   + (IF qbf-n[qbf-j] THEN "n" + STRING(qbf-j) ELSE "")
                   + (IF qbf-x[qbf-j] THEN "x" + STRING(qbf-j) ELSE "")
                   + (IF qbf-a[qbf-j] THEN "a" + STRING(qbf-j) ELSE "").
  END.
  /* note 'totals' turns off 'hide-repeated-values' for field */
  /*IF qbf-r THEN qbf-rca[qbf-i] = qbf-rca[qbf-i] + "&".*/
  IF qbf-s THEN qbf-rca[qbf-i] = qbf-rca[qbf-i] + "$".

END.

{ prores/t-reset.i }
RETURN.
