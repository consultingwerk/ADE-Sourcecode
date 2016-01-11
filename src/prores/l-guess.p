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
/* l-guess.p - make educated guess at the address fields for mailing label */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }
{ prores/t-set.i &mod=l &set=1 }

/* listed in order for search, not for display */
DEFINE VARIABLE qbf-c AS CHARACTER           NO-UNDO.
DEFINE VARIABLE qbf-h AS INTEGER             NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER             NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER             NO-UNDO.
DEFINE VARIABLE qbf-k AS INTEGER             NO-UNDO.
DEFINE VARIABLE qbf-o AS INTEGER   INITIAL 0 NO-UNDO.
DEFINE VARIABLE qbf-s AS INTEGER             NO-UNDO. /* sequence searched */
DEFINE VARIABLE qbf-t AS CHARACTER EXTENT 10 NO-UNDO.
DEFINE VARIABLE qbf-x AS INTEGER   INITIAL 0 NO-UNDO.

HIDE MESSAGE NO-PAUSE.

qbf-l-text = "".

DO qbf-h = 1 TO 5 WHILE qbf-file[qbf-h] <> "":

  DO qbf-i = 1 TO 10:

    /* search out of sequence */
    /* search for zip+4 before zip */
    qbf-s = INTEGER(ENTRY(qbf-i,"1,2,3,4,5,6,8,7,9,10")).

    IF qbf-t[qbf-s] <> "" THEN NEXT.

    ASSIGN
      qbf-c = qbf-lang[1]
      SUBSTRING(qbf-c,INDEX(qbf-c,"~{1~}"),3) = qbf-db[qbf-h]
                                              + "." + qbf-file[qbf-h]
      SUBSTRING(qbf-c,INDEX(qbf-c,"~{2~}"),3) = ENTRY(qbf-s,qbf-lang[5]).
    /*
      1: 'Searching "{1}" for "{2}" field...'
      5: 'name,address #1,address #2,address #3,city,'
         + 'state,zip+4,zip,city-state-zip,country'
    */
    IF LENGTH(qbf-c) < qbf-o THEN
      PUT SCREEN ROW SCREEN-LINES + 1 COLUMN LENGTH(qbf-c) + 1 NO-ATTR-SPACE
        FILL(" ",qbf-o - LENGTH(qbf-c)).
    PUT SCREEN ROW SCREEN-LINES + 1 COLUMN 1 COLOR MESSAGES NO-ATTR-SPACE qbf-c.
    qbf-o = LENGTH(qbf-c).

    CREATE ALIAS "QBF$0" FOR DATABASE VALUE(SDBNAME(qbf-db[qbf-h])).
    RUN prores/l-match.p
      (qbf-db[qbf-h],qbf-file[qbf-h],qbf-l-auto[qbf-s],OUTPUT qbf-c).

    IF qbf-c = ""
      OR qbf-t[1] = qbf-c OR qbf-t[2] = qbf-c
      OR qbf-t[3] = qbf-c OR qbf-t[4] = qbf-c
      OR qbf-t[5] = qbf-c OR qbf-t[6] = qbf-c
      OR qbf-t[7] = qbf-c OR qbf-t[8] = qbf-c
      OR qbf-t[9] = qbf-c OR qbf-t[10] = qbf-c THEN NEXT.
    qbf-t[qbf-s] = qbf-c.
  END.

END. /* qbf-h/file loop */

HIDE MESSAGE NO-PAUSE.
MESSAGE qbf-lang[4] + "...". /* Setting up label fields */

IF qbf-t[1] <> "" THEN qbf-l-text[1] = qbf-left + qbf-t[1] + qbf-right.
IF qbf-t[2] <> "" THEN qbf-l-text[2] = qbf-left + qbf-t[2] + qbf-right.
IF qbf-t[3] <> "" THEN qbf-l-text[3] = qbf-left + qbf-t[3] + qbf-right.
IF qbf-t[4] <> "" THEN qbf-l-text[4] = qbf-left + qbf-t[4] + qbf-right.

IF qbf-t[9] <> "" THEN qbf-l-text[5] = qbf-left + qbf-t[9] + qbf-right.
ELSE DO:
  IF qbf-t[5] <> "" THEN qbf-l-text[5] = qbf-left + qbf-t[5] + qbf-right + ", ".
  IF qbf-t[6] <> "" THEN qbf-l-text[5] =
                         qbf-l-text[5] + qbf-left + qbf-t[6] + qbf-right + "  ".
  IF qbf-t[7] <> "" THEN qbf-l-text[5] =
                         qbf-l-text[5] + qbf-left + qbf-t[7] + qbf-right.
  IF qbf-t[8] <> "" THEN qbf-l-text[5] = qbf-l-text[5] + "-"
                                       + qbf-left + qbf-t[8] + qbf-right + " ".
END.

IF qbf-t[10] <> "" THEN qbf-l-text[6] = qbf-left + qbf-t[10] + qbf-right.

/* squash out blank lines */
qbf-j = 0.
DO qbf-i = 1 TO { prores/s-limlbl.i }:
  IF qbf-l-text[qbf-i] <> "" THEN
    ASSIGN qbf-j = qbf-j + 1  qbf-l-text[qbf-j] = qbf-l-text[qbf-i].
END.
DO qbf-i = qbf-j + 1 TO { prores/s-limlbl.i }:
  qbf-l-text[qbf-i] = "".
END.
DO qbf-i = 7 TO 1 BY -1:
  IF LENGTH(qbf-l-text[qbf-i]) <= 66 THEN NEXT.
  DO qbf-j = 7 TO qbf-i + 1 BY -1:
    qbf-l-text[qbf-j + 1] = qbf-l-text[qbf-j].
  END.
  qbf-j = R-INDEX(SUBSTRING(qbf-l-text[qbf-i],1,66),qbf-left).
  IF qbf-j = 0 THEN qbf-j = R-INDEX(qbf-l-text[qbf-i],qbf-left).
  ASSIGN
    qbf-l-text[qbf-i + 1] = SUBSTRING(qbf-l-text[qbf-i],qbf-j)
    qbf-l-text[qbf-i]     = SUBSTRING(qbf-l-text[qbf-i],1,qbf-j - 1) + "~~".
  qbf-i = qbf-i + 1. /* retry current line 'recursively' */
END.

HIDE MESSAGE NO-PAUSE.

IF qbf-l-text[1] = "" THEN MESSAGE qbf-lang[2].
/*No fields could be found using the automatic search.*/

{ prores/t-reset.i }
RETURN.
