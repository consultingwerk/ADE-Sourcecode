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

/* a-zap.p - blow away files in filesystem */

{ aderes/s-system.i }

/* assumes all referenced files exist and are sufficiently */
/* qualified (e.g., no need to SEARCH() for them). */

DEFINE INPUT PARAMETER qbf-f AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-n AS CHARACTER NO-UNDO.

DO qbf-i = 1 TO NUM-ENTRIES(qbf-f):
  qbf-c = ENTRY(qbf-i,qbf-f).
  IF qbf-c = ? THEN NEXT.
  IF OPSYS = "VMS":u AND INDEX(qbf-c,"/":u) > 0 THEN
    RUN aderes/s-vms.p (INPUT-OUTPUT qbf-c).
  OS-DELETE VALUE(qbf-c).
END.

RETURN.

/* a-zap.p - end of file */

