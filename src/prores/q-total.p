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
/* q-total.p - generate counting program for query */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/q-define.i }

DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.

qbf-c = (IF qbf-where[qbf-level] = "" THEN
          qbf-of[qbf-level]
        ELSE IF qbf-of[qbf-level] = "" THEN
          "WHERE " + qbf-where[qbf-level]
        ELSE IF qbf-of[qbf-level] BEGINS "OF" THEN
          qbf-of[qbf-level] + " WHERE " + qbf-where[qbf-level]
        ELSE
          "(" + qbf-of[qbf-level] + ") AND (" + qbf-where[qbf-level] + ")"
        ).

IF qbf-level > 1 THEN DO:
  qbf-i = INDEX(qbf-c,qbf-db[qbf-level - 1] + "." + qbf-file[qbf-level - 1]).
  DO WHILE qbf-i > 0:
    ASSIGN
      SUBSTRING(qbf-c,qbf-i,LENGTH(qbf-db[qbf-level - 1]) + 1) = "".
      qbf-i = INDEX(qbf-c,qbf-db[qbf-level - 1]
              + "." + qbf-file[qbf-level - 1]).
  END.
END.

OUTPUT TO VALUE(qbf-tempdir + ".p") NO-ECHO NO-MAP.

IF qbf-level > 1 THEN PUT UNFORMATTED
  'DEFINE SHARED BUFFER ' qbf-file[qbf-level - 1] ' FOR '
    qbf-db[qbf-level - 1] '.' qbf-file[qbf-level - 1] '.' SKIP.

PUT UNFORMATTED
  'DEFINE SHARED VARIABLE qbf-total AS INTEGER NO-UNDO.' SKIP
  'qbf-total = 0.' SKIP
  'READKEY PAUSE 0.' SKIP
  'FOR EACH ' qbf-db[qbf-level] '.' qbf-file[qbf-level]
    ' ' qbf-c ' NO-LOCK' SKIP
    '  qbf-total = 1 TO qbf-total + 1:' SKIP
  '  IF qbf-total MODULO 10 = 0 THEN READKEY PAUSE 0.' SKIP
  '  IF qbf-total MODULO 10 = 0 AND LASTKEY <> -1 THEN LEAVE.' SKIP
  'END.' SKIP
  'RETURN.' SKIP.

OUTPUT CLOSE.
COMPILE VALUE(qbf-tempdir + ".p") ATTR-SPACE.
RETURN.
