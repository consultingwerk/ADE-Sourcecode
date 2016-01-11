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
/* Progress Lex Converter 7.1A->7.1C Version 1.26 */

/* s-vector.p - Sort a comma-sep string into order */

/*
qbf-u = remove duplicate array elements
qbf-d = delimiter character
qbf-o = input-output array
*/

DEFINE INPUT        PARAMETER qbf-u AS LOGICAL   NO-UNDO.
DEFINE INPUT        PARAMETER qbf-d AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER qbf-o AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-g AS INTEGER   NO-UNDO. /* gap for shell sort */
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-s AS CHARACTER NO-UNDO. /* scrap */

IF NUM-ENTRIES(qbf-o,qbf-d) < 2 THEN RETURN.

qbf-g = TRUNCATE(NUM-ENTRIES(qbf-o,qbf-d) / 2,0). /* shell sort array */
DO WHILE qbf-g > 0:
  DO qbf-i = qbf-g TO NUM-ENTRIES(qbf-o,qbf-d):
    qbf-j = qbf-i - qbf-g.
    DO WHILE qbf-j > 0:
      IF ENTRY(qbf-j,qbf-o,qbf-d) < ENTRY(qbf-j + qbf-g,qbf-o,qbf-d) THEN LEAVE.
      ASSIGN
        qbf-s                            = ENTRY(qbf-j,qbf-o,qbf-d)
        ENTRY(qbf-j,qbf-o,qbf-d)         = ENTRY(qbf-j + qbf-g,qbf-o,qbf-d)
        ENTRY(qbf-j + qbf-g,qbf-o,qbf-d) = qbf-s
        qbf-j                            = qbf-j - qbf-g.
    END.
  END.
  qbf-g = TRUNCATE(qbf-g / 2,0).
END.

IF qbf-u THEN DO: /* unique-ify */
  ASSIGN
    qbf-s = qbf-o
    qbf-o = ENTRY(1,qbf-o,qbf-d).
  DO qbf-j = 2 TO NUM-ENTRIES(qbf-s,qbf-d):
    /* if the next entry in the copy is not same as last entry */
    /* added to qbf-o, then we want to keep this next entry.   */
    IF ENTRY(qbf-j,qbf-s,qbf-d) <> ENTRY(NUM-ENTRIES(qbf-o,qbf-d),qbf-o,qbf-d)
      THEN qbf-o = qbf-o + qbf-d + ENTRY(qbf-j,qbf-s,qbf-d).
  END.
END.

RETURN.

/* s-vector.p - end of file */

