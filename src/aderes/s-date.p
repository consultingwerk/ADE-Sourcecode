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

/* s-date.p - returns -d <mdy> setting and -yy <nnnn> setting */

DEFINE OUTPUT PARAMETER qbf-m AS CHARACTER         NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-y AS INTEGER INITIAL ? NO-UNDO.

DEFINE VARIABLE qbf-i AS INTEGER NO-UNDO. /* scrap */

DO qbf-i = 1900 TO 2000 WHILE qbf-y = ?:
  IF LENGTH(STRING(DATE(1,1,qbf-i))) = 8
    AND LENGTH(STRING(DATE(1,1,qbf-i + 99))) = 8
    THEN qbf-y = qbf-i.
END.
DO qbf-i = 1000 TO 1900 WHILE qbf-y = ?:
  IF LENGTH(STRING(DATE(1,1,qbf-i))) = 8
    AND LENGTH(STRING(DATE(1,1,qbf-i + 99))) = 8
    THEN qbf-y = qbf-i.
END.
DO qbf-i = 2000 TO 9900 WHILE qbf-y = ?:
  IF LENGTH(STRING(DATE(1,1,qbf-i))) = 8
    AND LENGTH(STRING(DATE(1,1,qbf-i + 99))) = 8
    THEN qbf-y = qbf-i.
END.

qbf-m = ENTRY(LOOKUP(STRING(DATE(2,1,qbf-y + 3)),
      "01/02/03,01/03/02,02/01/03,02/03/01,03/01/02,03/02/01":u),
      "dmy,dym,mdy,myd,ydm,ymd":u).

RETURN.

/* s-date.p - end of file */
