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
/* r-write.i - generate first-page-only or last-page-only frames */

/*
called by r-write.p
f:
  &base=1
  &first="SKIP '    SKIP(1)'"
  &name=qbf-first
  &disp="SKIP '  DISPLAY WITH FRAME qbf-first.'"

l:
  &base=4
  &last="SKIP '    SKIP(1)'"
  &name=qbf-last
*/

IF qbf-w[{&base}] + qbf-w[{&base} + 1] + qbf-w[{&base} + 2] > 0 THEN DO:
  PUT STREAM qbf-io UNFORMATTED '  FORM HEADER' {&last}.
  qbf-j = MAXIMUM(0,(qbf-s
        - { prores/s-max3.i qbf-w[{&base}] "qbf-w[{&base} + 1]" "qbf-w[{&base} + 2]" }
          ) / 2).
  DO qbf-i = {&base} TO {&base} + 2:
    IF qbf-w[qbf-i] = 0 THEN NEXT.
    PUT STREAM qbf-io UNFORMATTED SKIP
      '    SPACE(' STRING(qbf-j) ') ' qbf-m[qbf-i] ' SKIP'.
  END.
  PUT STREAM qbf-io UNFORMATTED {&first} SKIP
    '    WITH FRAME {&name} COLUMN ' qbf-r-attr[1]
    ' WIDTH ' qbf-r-size - 1 + qbf-r-attr[1]
    ' NO-ATTR-SPACE NO-LABELS NO-BOX.'
    {&disp} SKIP(1).
END.
