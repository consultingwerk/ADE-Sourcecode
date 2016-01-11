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
/* a-edit.i - edit control codes for output devices */

/*----------------------------------------------------------------------------
When entering codes, the following methods may be used:
  'x' - literal character enclosed in single quotes.
  ^x  - interpreted as control-character.
  ##h - one or two hex digits followed by the letter "H".
  ### - one, two or three digits, a decimal number.
  xxx - "xxx" is a symbol such as "lf" from the following table.
        | 0 nul | 4 eot |  8 bs | 12 ff | 16 dle | 20 dc4 | 24 can | 28 fs
        | 1 soh | 5 enq |  9 ht | 13 cr | 17 dc1 | 21 nak | 25 em  | 29 gs
        | 2 stx | 6 ack | 10 lf | 14 so | 18 dc2 | 22 syn | 26 sub | 30 rs
        | 3 etx | 7 bel | 11 vt | 15 si | 19 dc3 | 23 etb | 27 esc | 31 us

|  Initialization: ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___
|                  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___
|    Normal Print: ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___
|      Compressed: ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___
|        Bold  ON: ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___
|        Bold OFF: ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___  ___
| ---------------: 123456789012345678901234567890123456789012345678901234567890|
----------------------------------------------------------------------------*/

DEFINE {1} SHARED FRAME qbf-ctrl.

/*
  qbf-t[1] = '  Initialization'
  qbf-t[2] = '                '
  qbf-t[3] = '    Normal Print'
  qbf-t[4] = '      Compressed'
  qbf-t[5] = '        Bold  ON'
  qbf-t[6] = '        Bold OFF'
*/

FORM
  qbf-t[1] FORMAT "x(16)" NO-ATTR-SPACE SPACE(0) ":" /*  Initialization:*/
    qbf-m[ 1] qbf-y[ 2] qbf-y[ 3] qbf-y[ 4] qbf-y[ 5] qbf-y[ 6]
    qbf-y[ 7] qbf-y[ 8] qbf-y[ 9] qbf-y[10] qbf-y[11] qbf-y[12] SKIP
  qbf-t[2] FORMAT "x(16)" NO-ATTR-SPACE SPACE(0) ":" /*                 */
    qbf-m[ 2] qbf-y[14] qbf-y[15] qbf-y[16] qbf-y[17] qbf-y[18]
    qbf-y[19] qbf-y[20] qbf-y[21] qbf-y[22] qbf-y[23] qbf-y[24] SKIP
  qbf-t[3] FORMAT "x(16)" NO-ATTR-SPACE SPACE(0) ":" /*    Normal Print:*/
    qbf-m[ 3] qbf-y[26] qbf-y[27] qbf-y[28] qbf-y[29] qbf-y[30]
    qbf-y[31] qbf-y[32] qbf-y[33] qbf-y[34] qbf-y[35] qbf-y[36] SKIP
  qbf-t[4] FORMAT "x(16)" NO-ATTR-SPACE SPACE(0) ":" /*      Compressed:*/
    qbf-m[ 4] qbf-y[38] qbf-y[39] qbf-y[40] qbf-y[41] qbf-y[42]
    qbf-y[43] qbf-y[44] qbf-y[45] qbf-y[46] qbf-y[47] qbf-y[48] SKIP
  qbf-t[5] FORMAT "x(16)" NO-ATTR-SPACE SPACE(0) ":" /*        Bold  ON:*/
    qbf-m[ 5] qbf-y[50] qbf-y[51] qbf-y[52] qbf-y[53] qbf-y[54]
    qbf-y[55] qbf-y[56] qbf-y[57] qbf-y[58] qbf-y[59] qbf-y[60] SKIP
  qbf-t[6] FORMAT "x(16)" NO-ATTR-SPACE SPACE(0) ":" /*        Bold OFF:*/
    qbf-m[ 6] qbf-y[62] qbf-y[63] qbf-y[64] qbf-y[65] qbf-y[66]
    qbf-y[67] qbf-y[68] qbf-y[69] qbf-y[70] qbf-y[71] qbf-y[72] SKIP
  WITH FRAME qbf-ctrl ROW 15 COLUMN 2 NO-BOX NO-LABELS ATTR-SPACE OVERLAY.
