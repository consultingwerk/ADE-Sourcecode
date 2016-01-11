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
/* s-gen4.i - calc field code for main loop */

qbf-j = 0. /* 0=none, 1=one, 2=many */
DO qbf-i = 1 TO qbf-rc# WHILE qbf-j < 2:
  IF CAN-DO("r*,p*,c*,s*,d*,n*,l*",qbf-rcc[qbf-i]) THEN qbf-j = qbf-j + 1.
END.

IF qbf-j > 1 THEN PUT STREAM qbf-io UNFORMATTED '  ASSIGN'.

IF qbf-j > 0 THEN
  DO qbf-i = 1 TO qbf-rc#:
    qbf-c = (IF qbf-rcc[qbf-i] BEGINS "r" THEN
              ENTRY(1,qbf-rcn[qbf-i]) + ' + ' + ENTRY(2,qbf-rcn[qbf-i])
            ELSE IF qbf-rcc[qbf-i] BEGINS "p" THEN
              ENTRY(2,qbf-rcn[qbf-i]) + ' * 100 / '
                + ENTRY(1,qbf-rcn[qbf-i]) + '%'
            ELSE IF qbf-rcc[qbf-i] BEGINS "c" THEN
              ENTRY(1,qbf-rcn[qbf-i]) + ' + ' + ENTRY(3,qbf-rcn[qbf-i])
            ELSE IF CAN-DO("s*,d*,n*,l*",qbf-rcc[qbf-i]) THEN
              SUBSTRING(qbf-rcn[qbf-i],INDEX(qbf-rcn[qbf-i],",") + 1)
            ELSE
              ''
            ).
    IF qbf-c <> "" THEN
      PUT STREAM qbf-io UNFORMATTED SKIP
        '  ' (IF qbf-j = 1 THEN '' ELSE '  ')
        ENTRY(1,qbf-rcn[qbf-i]) ' = ' qbf-c.
  END.

IF qbf-j > 0 THEN PUT STREAM qbf-io UNFORMATTED '.' SKIP.
