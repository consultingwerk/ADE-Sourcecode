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
/* s-gen1.i - write out initialization stuff for calc fields */

PUT STREAM qbf-io UNFORMATTED
  'DEFINE SHARED VARIABLE qbf-total AS INTEGER NO-UNDO.' SKIP.
DO qbf-i = 1 TO qbf-rc#:
  IF qbf-rcc[qbf-i] = "" OR qbf-rcc[qbf-i] BEGINS "e" THEN NEXT.
  qbf-c = ENTRY(1,qbf-rcn[qbf-i]).
  IF qbf-rcc[qbf-i] BEGINS "c" THEN
    qbf-j = INTEGER(ENTRY(2,qbf-rcn[qbf-i])) - INTEGER(ENTRY(3,qbf-rcn[qbf-i])).
  IF qbf-rcc[qbf-i] BEGINS "p" THEN
    PUT STREAM qbf-io UNFORMATTED SKIP
      'DEFINE VARIABLE ' ENTRY(1,qbf-rcn[qbf-i]) '  AS DECIMAL NO-UNDO.' SKIP
      'DEFINE VARIABLE ' ENTRY(1,qbf-rcn[qbf-i]) '% AS DECIMAL NO-UNDO.'.
  ELSE
    PUT STREAM qbf-io UNFORMATTED SKIP
      'DEFINE VARIABLE ' ENTRY(1,qbf-rcn[qbf-i]) '  AS '
        CAPS(ENTRY(qbf-rct[qbf-i],qbf-dtype))
        (IF NOT qbf-rcc[qbf-i] BEGINS "c" THEN ''
          ELSE ' INITIAL ' + STRING(qbf-j))
        ' NO-UNDO.'.
END.
PUT STREAM qbf-io UNFORMATTED SKIP(1).
