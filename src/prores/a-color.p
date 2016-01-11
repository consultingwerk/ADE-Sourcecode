/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* a-color.p - set colors */

{ prores/s-system.i }
{ prores/t-define.i }
{ prores/a-define.i }
{ prores/t-set.i &mod=a &set=6 }

DEFINE VARIABLE qbf-c AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-r AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-s AS CHARACTER EXTENT 6 NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER          NO-UNDO.

/*
  qbf-lang[11] = " Colors for which terminal type:"
  qbf-lang[12] = "Menu:             Normal:"
  qbf-lang[13] = "               Highlight:"
  qbf-lang[14] = "Dialog Box:       Normal:"
  qbf-lang[15] = "               Highlight:"
  qbf-lang[16] = "Scrolling List:   Normal:"
  qbf-lang[17] = "               Highlight:"
*/
FORM /*SKIP(7)*/
  qbf-lang[11] FORMAT "x(32)" NO-ATTR-SPACE SPACE(0) qbf-t   FORMAT "x(20)" SKIP
  qbf-lang[12] FORMAT "x(25)" NO-ATTR-SPACE SPACE(0) qbf-mlo FORMAT "x(20)"
    "(" SPACE(0) qbf-s[1] FORMAT "x(20)" SPACE(0) ")" SKIP
  qbf-lang[13] FORMAT "x(25)" NO-ATTR-SPACE SPACE(0) qbf-mhi FORMAT "x(20)"
    "(" SPACE(0) qbf-s[2] FORMAT "x(20)" SPACE(0) ")" SKIP
  qbf-lang[14] FORMAT "x(25)" NO-ATTR-SPACE SPACE(0) qbf-dlo FORMAT "x(20)"
    "(" SPACE(0) qbf-s[3] FORMAT "x(20)" SPACE(0) ")" SKIP
  qbf-lang[15] FORMAT "x(25)" NO-ATTR-SPACE SPACE(0) qbf-dhi FORMAT "x(20)"
    "(" SPACE(0) qbf-s[4] FORMAT "x(20)" SPACE(0) ")" SKIP
  qbf-lang[16] FORMAT "x(25)" NO-ATTR-SPACE SPACE(0) qbf-plo FORMAT "x(20)"
    "(" SPACE(0) qbf-s[5] FORMAT "x(20)" SPACE(0) ")" SKIP
  qbf-lang[17] FORMAT "x(25)" NO-ATTR-SPACE SPACE(0) qbf-phi FORMAT "x(20)"
    "(" SPACE(0) qbf-s[6] FORMAT "x(20)" SPACE(0) ")" SKIP
  WITH FRAME qbf-glossy ROW 4 COLUMN 2 ATTR-SPACE NO-LABELS OVERLAY NO-BOX.

PAUSE 0.

ASSIGN
  qbf-t    = TERMINAL  qbf-c    = ""
  qbf-s[1] = qbf-mlo   qbf-s[2] = qbf-mhi
  qbf-s[3] = qbf-dlo   qbf-s[4] = qbf-dhi
  qbf-s[5] = qbf-plo   qbf-s[6] = qbf-phi.

DISPLAY qbf-lang[11 FOR 7] WITH FRAME qbf-glossy.
DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE WITH FRAME qbf-glossy:
  UPDATE qbf-t.
END.
IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN DO:
  HIDE FRAME qbf-glossy NO-PAUSE.
  RETURN.
END.

DO qbf-r = 1 TO { prores/s-limtrm.i } WHILE qbf-t-name[qbf-r] <> qbf-t: END.
IF qbf-r > { prores/s-limtrm.i } THEN
  ASSIGN
    qbf-r             = { prores/s-limtrm.i } /* overwrite last one */
    qbf-t-name[qbf-r] = qbf-t
    qbf-t-hues[qbf-r] = "NORMAL,MESSAGES,NORMAL,MESSAGES,NORMAL,MESSAGES".
ASSIGN
  qbf-mlo = ENTRY(1,qbf-t-hues[qbf-r])  qbf-mhi = ENTRY(2,qbf-t-hues[qbf-r])
  qbf-dlo = ENTRY(3,qbf-t-hues[qbf-r])  qbf-dhi = ENTRY(4,qbf-t-hues[qbf-r])
  qbf-plo = ENTRY(5,qbf-t-hues[qbf-r])  qbf-phi = ENTRY(6,qbf-t-hues[qbf-r]).

COLOR DISPLAY VALUE(qbf-mlo) qbf-s[1] WITH FRAME qbf-glossy.
COLOR DISPLAY VALUE(qbf-mhi) qbf-s[2] WITH FRAME qbf-glossy.
COLOR DISPLAY VALUE(qbf-dlo) qbf-s[3] WITH FRAME qbf-glossy.
COLOR DISPLAY VALUE(qbf-dhi) qbf-s[4] WITH FRAME qbf-glossy.
COLOR DISPLAY VALUE(qbf-plo) qbf-s[5] WITH FRAME qbf-glossy.
COLOR DISPLAY VALUE(qbf-phi) qbf-s[6] WITH FRAME qbf-glossy.
DISPLAY
  qbf-mlo @ qbf-s[1]  qbf-mhi @ qbf-s[2]
  qbf-dlo @ qbf-s[3]  qbf-dhi @ qbf-s[4]
  qbf-plo @ qbf-s[5]  qbf-phi @ qbf-s[6]
  qbf-lang[11 FOR 7]
  WITH FRAME qbf-glossy.

DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE WITH FRAME qbf-glossy:
  COLOR DISPLAY VALUE(qbf-mlo) qbf-mlo.  COLOR PROMPT VALUE(qbf-mlo) qbf-mlo.
  COLOR DISPLAY VALUE(qbf-mhi) qbf-mhi.  COLOR PROMPT VALUE(qbf-mhi) qbf-mhi.
  COLOR DISPLAY VALUE(qbf-dlo) qbf-dlo.  COLOR PROMPT VALUE(qbf-dlo) qbf-dlo.
  COLOR DISPLAY VALUE(qbf-dhi) qbf-dhi.  COLOR PROMPT VALUE(qbf-dhi) qbf-dhi.
  COLOR DISPLAY VALUE(qbf-plo) qbf-plo.  COLOR PROMPT VALUE(qbf-plo) qbf-plo.
  COLOR DISPLAY VALUE(qbf-phi) qbf-phi.  COLOR PROMPT VALUE(qbf-phi) qbf-phi.
  UPDATE qbf-mlo qbf-mhi qbf-dlo qbf-dhi qbf-plo qbf-phi
    EDITING:
      READKEY.
      APPLY LASTKEY.
      IF qbf-c = FRAME-FIELD AND NOT GO-PENDING THEN NEXT.
      qbf-c = FRAME-FIELD.
      COLOR PROMPT  VALUE(INPUT qbf-mlo) qbf-mlo.
      COLOR PROMPT  VALUE(INPUT qbf-mhi) qbf-mhi.
      COLOR PROMPT  VALUE(INPUT qbf-dlo) qbf-dlo.
      COLOR PROMPT  VALUE(INPUT qbf-dhi) qbf-dhi.
      COLOR PROMPT  VALUE(INPUT qbf-plo) qbf-plo.
      COLOR PROMPT  VALUE(INPUT qbf-phi) qbf-phi.
      COLOR DISPLAY VALUE(INPUT qbf-mlo) qbf-mlo.
      COLOR DISPLAY VALUE(INPUT qbf-mhi) qbf-mhi.
      COLOR DISPLAY VALUE(INPUT qbf-dlo) qbf-dlo.
      COLOR DISPLAY VALUE(INPUT qbf-dhi) qbf-dhi.
      COLOR DISPLAY VALUE(INPUT qbf-plo) qbf-plo.
      COLOR DISPLAY VALUE(INPUT qbf-phi) qbf-phi.
    END.

  qbf-t-hues[qbf-r] = qbf-mlo + "," + qbf-mhi + "," + qbf-dlo + ","
                    + qbf-dhi + "," + qbf-plo + "," + qbf-phi.
  IF qbf-t = TERMINAL THEN
    ASSIGN
      qbf-s[1] = qbf-mlo  qbf-s[2] = qbf-mhi
      qbf-s[3] = qbf-dlo  qbf-s[4] = qbf-dhi
      qbf-s[5] = qbf-plo  qbf-s[6] = qbf-phi.
END.

IF qbf-t <> TERMINAL THEN
  ASSIGN
    qbf-mlo = qbf-s[1]  qbf-mhi = qbf-s[2]
    qbf-dlo = qbf-s[3]  qbf-dhi = qbf-s[4]
    qbf-plo = qbf-s[5]  qbf-phi = qbf-s[6].
HIDE FRAME qbf-glossy NO-PAUSE.
RETURN.
