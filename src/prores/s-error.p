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
/* s-error.p - error dialog box routine - displays a message, then returns */

/*
Input text comes in 'qbf-q' parameter, and may be any length.
This program splits it up into 40-character chunks, breaking at
spaces.  Embedded '^' marks get translated into line-feeds (like
in column-labels).

A "#" followed by a number for the message text means take the
text for that entry from qbf-lang[#].
*/

{ prores/s-system.i }
{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-q AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-d AS INTEGER             NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER             NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER             NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT 20 NO-UNDO.

IF qbf-q BEGINS "#" THEN qbf-q = qbf-lang[INTEGER(SUBSTRING(qbf-q,2))].

FORM
  SPACE(1) qbf-q FORMAT "x(47)" SPACE(2) SKIP
  WITH FRAME qbf-box-bot OVERLAY NO-LABELS NO-ATTR-SPACE
  qbf-d + 5 DOWN COLUMN 15 ROW MAXIMUM(3,(SCREEN-LINES - qbf-d) / 2 - 3)
  COLOR DISPLAY VALUE(qbf-dlo) PROMPT VALUE(qbf-dhi).

FORM
  qbf-continu FORMAT "x(12)"
  WITH FRAME qbf-box-cont OVERLAY NO-LABELS ATTR-SPACE
  COLUMN 49 ROW MAXIMUM(6,(SCREEN-LINES - qbf-d) / 2) + qbf-d
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
DO qbf-i = 0 TO qbf-d + 4 WITH FRAME qbf-box-bot:
  DOWN.
  DISPLAY
    (IF qbf-i = qbf-d + 3              THEN ""
    ELSE IF qbf-i = 0 OR qbf-i > qbf-d THEN " **"
    ELSE                                    "****   " + qbf-m[qbf-i])
    @ qbf-q.
END.

PAUSE 0.
COLOR DISPLAY VALUE(qbf-dhi) qbf-continu WITH FRAME qbf-box-cont.
DISPLAY qbf-continu WITH FRAME qbf-box-cont.

INPUT CLEAR. /* The only place in RESULTS this is allowed is here. */
READKEY.

HIDE FRAME qbf-box-bot  NO-PAUSE.
HIDE FRAME qbf-box-cont NO-PAUSE.

RETURN.
