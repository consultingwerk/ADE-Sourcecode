/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* r-calc.p - report writer calculated fields */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }
{ prores/t-set.i &mod=r &set=1 }

DEFINE INPUT PARAMETER qbf-t AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-a AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-e AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-f AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-o AS INTEGER   NO-UNDO.

{ prores/c-field.i
  &new=NEW &down=13 &row="ROW 2" &column="COLUMN 2" &title=qbf-e
}

IF qbf-rc# = { prores/s-limcol.i } THEN DO:
  /*You already have the maximum number of columns defined.*/
  RUN prores/s-error.p ("#32").
  qbf-t = "".
END.

qbf-o = qbf-rc#.

IF qbf-t = "r" OR qbf-t = "p" THEN DO: /*--- RUNNING TOTAL/PERCENT OF TOTAL */
  ASSIGN
    qbf-c = ""      /*18:"Running Totals" 19:"Percent of Total"*/
    qbf-e = " " + qbf-lang[IF qbf-t = "r" THEN 18 ELSE 19] + " ".
  RUN prores/s-field.p
    ("field","","integer,decimal",INPUT-OUTPUT qbf-c).
  HIDE FRAME qbf-pick NO-PAUSE.
  IF qbf-c <> "" THEN DO:
    RUN prores/s-lookup.p
      (qbf-c,"","","FIELD:TYP&FMT",OUTPUT qbf-e).
    ASSIGN /*20:"Running Total" 21:"% Total"*/
      qbf-rc#          = qbf-rc# + 1
      qbf-rcn[qbf-rc#] = "qbf-000," + qbf-c
      qbf-rcl[qbf-rc#] = qbf-lang[IF qbf-t = "r" THEN 20 ELSE 21]
      qbf-rcf[qbf-rc#] = (IF qbf-t = "p" THEN "->>>9.9%"
                         ELSE SUBSTRING(qbf-e,INDEX(qbf-e,",") + 1))
      qbf-rca[qbf-rc#] = ""
      qbf-rcc[qbf-rc#] = qbf-t
      qbf-rct[qbf-rc#] = INTEGER(ENTRY(1,qbf-e)).
  END.
END.
ELSE IF qbf-t = "c" THEN DO: /*------------------------------------ COUNTER */
  ASSIGN
    qbf-c = ""
    qbf-l = 1
    qbf-i = 1.
  DISPLAY
    qbf-lang[28] + ":" FORMAT "x(32)" NO-ATTR-SPACE qbf-l FORMAT "->>>>>9" SKIP
    qbf-lang[29] + ":" FORMAT "x(32)" NO-ATTR-SPACE qbf-i FORMAT "->>>>>9" SKIP
    WITH FRAME r-count OVERLAY ROW 4 CENTERED NO-LABELS ATTR-SPACE
    TITLE COLOR NORMAL " " + qbf-lang[26] + " ". /*"Counters"*/
  DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    UPDATE qbf-l qbf-i WITH FRAME r-count
      EDITING:
        /* the following block pretends that "help" allows an expression */
        IF   (FRAME-FIELD = "qbf-l" AND qbf-c <> qbf-lang[24])
          OR (FRAME-FIELD = "qbf-i" AND qbf-c <> qbf-lang[25]) THEN DO:
          qbf-c = qbf-lang[IF FRAME-FIELD = "qbf-l" THEN 24 ELSE 25].
          STATUS INPUT qbf-c.
          /*"Enter starting number for counter"*/
          /*"Enter increment, or a negative number to subtract"*/
        END.
        READKEY.
        APPLY LASTKEY.
      END.
    ASSIGN
      qbf-rc#          = qbf-rc# + 1
      qbf-rcn[qbf-rc#] = "qbf-000," + STRING(qbf-l) + "," + STRING(qbf-i)
      qbf-rcl[qbf-rc#] = qbf-lang[27] /*"Counter"*/
      qbf-rcf[qbf-rc#] = (IF qbf-l < 0 OR qbf-i < 0 THEN "-" ELSE "") + ">>>>9"
      qbf-rca[qbf-rc#] = ""
      qbf-rcc[qbf-rc#] = "c"
      qbf-rct[qbf-rc#] = 4.
  END.
  HIDE FRAME r-count NO-PAUSE.
  STATUS INPUT.
END.
ELSE IF INDEX("s,n,d,l,m",qbf-t) > 0 THEN DO: /*---------------- EXPRESSION */
  RUN prores/s-calc.p ("field",qbf-t,OUTPUT qbf-c).
  IF qbf-c <> ? THEN
    ASSIGN
      qbf-rc#          = qbf-rc# + 1
      qbf-rct[qbf-rc#] = LOOKUP(SUBSTRING(qbf-c,1,1),"s,d,l,,n,,")
      qbf-rcn[qbf-rc#] = "qbf-000," + SUBSTRING(qbf-c,3)
      qbf-rcl[qbf-rc#] = ENTRY(IF qbf-t = "m" THEN 4 ELSE qbf-rct[qbf-rc#],
                         qbf-lang[22]) + " " + qbf-lang[23]
                       /*"String,Date,Logical,Math,Numeric") + " Value"*/
      qbf-rcf[qbf-rc#] = ENTRY(qbf-rct[qbf-rc#],
                         "x(15),99/99/99,"
                         + LC(TRIM(ENTRY(1,qbf-boolean)) + "/"
                         + TRIM(ENTRY(2,qbf-boolean)))
                         + ",,->>>>>>>9.99")
      qbf-rca[qbf-rc#] = ""
      qbf-rcc[qbf-rc#] = SUBSTRING(qbf-c,1,1).
END.

IF qbf-o <> qbf-rc# THEN DO:
  RUN prores/r-label.p
    (qbf-rcl[qbf-rc#],qbf-rcf[qbf-rc#],qbf-rct[qbf-rc#],
    OUTPUT qbf-rcw[qbf-rc#],OUTPUT qbf-i).
  DO qbf-i = 1 TO qbf-rc#:
    IF NOT qbf-rcc[qbf-i] BEGINS "e" AND qbf-rcc[qbf-i] <> "" THEN
      SUBSTRING(qbf-rcn[qbf-i],5,3) = STRING(qbf-i,"999").
  END.
  RUN prores/s-format.p (qbf-module,qbf-rc#).
  IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN qbf-rc# = qbf-rc# - 1.
END.

{ prores/t-reset.i }
RETURN.
