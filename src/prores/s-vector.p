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
/* s-vector.p - Sort a comma-sep string into order (up to s-limcol.i) */

/*
qbf-o = input-output array
qbf-u = remove duplicate array elements
*/

DEFINE INPUT        PARAMETER qbf-u AS LOGICAL   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER qbf-o AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-e AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-g AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-s AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER EXTENT { prores/s-limcol.i } NO-UNDO.

DO qbf-e = 1 TO MINIMUM({ prores/s-limcol.i },NUM-ENTRIES(qbf-o)):
  qbf-t[qbf-e] = ENTRY(qbf-e,qbf-o).
END.
qbf-e = qbf-e - 1.
IF qbf-e < 2 THEN RETURN.

qbf-g = TRUNCATE(qbf-e / 2,0). /* shell sort array */
DO WHILE qbf-g > 0:
  DO qbf-i = qbf-g TO qbf-e:
    qbf-j = qbf-i - qbf-g.
    DO WHILE qbf-j > 0:
      IF qbf-t[qbf-j] < qbf-t[qbf-j + qbf-g] THEN LEAVE.
      ASSIGN
        qbf-s                = qbf-t[qbf-j]
        qbf-t[qbf-j]         = qbf-t[qbf-j + qbf-g]
        qbf-t[qbf-j + qbf-g] = qbf-s
        qbf-j                = qbf-j - qbf-g.
    END.
  END.
  qbf-g = TRUNCATE(qbf-g / 2,0).
END.

IF qbf-u THEN DO: /* unique-ify */
  ASSIGN
    qbf-i = qbf-e
    qbf-e = 1.
  DO qbf-j = 2 TO qbf-i:
    IF qbf-t[qbf-e] <> qbf-t[qbf-j] THEN
      ASSIGN
        qbf-e        = qbf-e + 1
        qbf-t[qbf-e] = qbf-t[qbf-j].
  END.
END.

qbf-o = qbf-t[1].
DO qbf-i = 2 TO qbf-e:
  qbf-o = qbf-o + "," + qbf-t[qbf-i].
END.

RETURN.
