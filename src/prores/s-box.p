/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-box.p - dialog box routine - gets a true/false value from user */

/*
Input text comes in 'qbf-q' parameter, and may be any length.
This program splits it up into 40-character chunks, breaking at
spaces.  Embedded '^' marks get translated into line-feeds (like
in column-labels).

A "#" followed by a number for any of the last three parameters means
take the text for that entry from qbf-lang[#].
*/

{ prores/s-system.i }
{ prores/t-define.i }

DEFINE INPUT-OUTPUT PARAMETER qbf-a AS LOGICAL   NO-UNDO.
DEFINE INPUT        PARAMETER qbf-t AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER qbf-f AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER qbf-q AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-d AS INTEGER             NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER             NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER             NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT 20 NO-UNDO.

IF qbf-t = ? OR qbf-f = ? THEN ASSIGN
  qbf-t = ENTRY(1,qbf-boolean)
  qbf-f = ENTRY(2,qbf-boolean).

IF qbf-t BEGINS "#" THEN qbf-t = qbf-lang[INTEGER(SUBSTRING(qbf-t,2))].
IF qbf-f BEGINS "#" THEN qbf-f = qbf-lang[INTEGER(SUBSTRING(qbf-f,2))].
IF qbf-q BEGINS "#" THEN qbf-q = qbf-lang[INTEGER(SUBSTRING(qbf-q,2))].

FORM
  SPACE(2) qbf-q FORMAT "x(40)" SPACE(2) SKIP
  WITH FRAME qbf-box-bot OVERLAY NO-LABELS NO-ATTR-SPACE
  qbf-d + 5 DOWN COLUMN 18 ROW MAXIMUM(3,(SCREEN-LINES - qbf-d) / 2 - 3)
  COLOR DISPLAY VALUE(qbf-dlo) PROMPT VALUE(qbf-dhi).

FORM
  qbf-t FORMAT "x(8)"
  WITH FRAME qbf-box-yes OVERLAY NO-LABELS ATTR-SPACE
  COLUMN 26
  ROW MAXIMUM(6,(SCREEN-LINES - qbf-d) / 2) + qbf-d
  COLOR DISPLAY VALUE(qbf-dlo) PROMPT VALUE(qbf-dhi).
FORM
  qbf-f FORMAT "x(8)"
  WITH FRAME qbf-box-no OVERLAY NO-LABELS ATTR-SPACE
  COLUMN 44
  ROW MAXIMUM(6,(SCREEN-LINES - qbf-d) / 2) + qbf-d
  COLOR DISPLAY VALUE(qbf-dlo) PROMPT VALUE(qbf-dhi).

ASSIGN
  qbf-d        = 1
  qbf-m[qbf-d] = qbf-q.
DO WHILE LENGTH(qbf-m[qbf-d]) > 40 OR INDEX(qbf-m[qbf-d],"^") > 0:
  ASSIGN
    qbf-i            = MAXIMUM(
                       R-INDEX(SUBSTRING(qbf-m[qbf-d],1,40),"^"),
                       R-INDEX(SUBSTRING(qbf-m[qbf-d],1,40)," ")
                       )
    qbf-i            = (IF qbf-i = 0 THEN 40 ELSE qbf-i)
    qbf-j            = INDEX(SUBSTRING(qbf-m[qbf-d],1,40),"^")
    qbf-j            = (IF qbf-j = 0 THEN 40 ELSE qbf-j)
    qbf-i            = MINIMUM(qbf-i,qbf-j)
    qbf-m[qbf-d + 1] = TRIM(SUBSTRING(qbf-m[qbf-d],qbf-i + 1))
    qbf-m[qbf-d]     = TRIM(SUBSTRING(qbf-m[qbf-d],1,qbf-i - 1))
    qbf-d            = qbf-d + 1.
END.

PAUSE 0.
DO qbf-i = 0 TO qbf-d WITH FRAME qbf-box-bot:
  DOWN.
  DISPLAY (IF qbf-i = 0 THEN "" ELSE qbf-m[qbf-i]) @ qbf-q.
END.

PAUSE 0.
COLOR DISPLAY VALUE(IF qbf-a THEN qbf-dhi ELSE qbf-dlo) qbf-t
  WITH FRAME qbf-box-yes.
COLOR DISPLAY VALUE(IF qbf-a THEN qbf-dlo ELSE qbf-dhi) qbf-f
  WITH FRAME qbf-box-no.
DISPLAY qbf-t WITH FRAME qbf-box-yes.
DISPLAY qbf-f WITH FRAME qbf-box-no.

ASSIGN
  qbf-t = SUBSTRING(TRIM(qbf-t),1,1)
  qbf-f = SUBSTRING(TRIM(qbf-f),1,1).

DO WHILE TRUE:
  PUT CURSOR
    COLUMN (IF qbf-a THEN FRAME-COL(qbf-box-yes) ELSE FRAME-COL(qbf-box-no)) + 9
    ROW MAXIMUM(6,(SCREEN-LINES - qbf-d) / 2) + qbf-d + 1.
  READKEY.
  IF CAN-DO("TAB,BACK-TAB,CURSOR-*, ",KEYFUNCTION(LASTKEY)) THEN
    qbf-a = NOT qbf-a.
  ELSE IF CAN-DO(qbf-t,KEYFUNCTION(LASTKEY)) THEN qbf-a = TRUE.
  ELSE IF CAN-DO("END-ERROR," + qbf-f,KEYFUNCTION(LASTKEY)) THEN qbf-a = FALSE.
  ELSE IF CAN-DO("RETURN,GO",KEYFUNCTION(LASTKEY)) THEN .
  ELSE BELL.
  COLOR DISPLAY VALUE(IF qbf-a THEN qbf-dhi ELSE qbf-dlo) qbf-t
    WITH FRAME qbf-box-yes.
  COLOR DISPLAY VALUE(IF qbf-a THEN qbf-dlo ELSE qbf-dhi) qbf-f
    WITH FRAME qbf-box-no.
  IF CAN-DO(qbf-f + "," + qbf-t + ",RETURN,GO,END-ERROR",KEYFUNCTION(LASTKEY))
    THEN LEAVE.
END.

PUT CURSOR OFF.
HIDE FRAME qbf-box-no  NO-PAUSE.
HIDE FRAME qbf-box-yes NO-PAUSE.
HIDE FRAME qbf-box-bot NO-PAUSE.

RETURN.
