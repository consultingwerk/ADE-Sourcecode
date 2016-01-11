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
/* r-ftask.i starts here */

DEFINE VARIABLE qbf-i AS INTEGER NO-UNDO.

qbf-i = (NUM-ENTRIES(_rlevel._misc1[1]) - 1) / 4.

IF qbf-i >= 1 THEN DO:
  DISPLAY ENTRY(4,_rlevel._misc1[1]) FORMAT "x(60)"
    WITH FRAME ask1 CENTERED ROW 5 NO-LABELS
    TITLE " " + ENTRY(2,_rlevel._misc1[1])
      +   " " + ENTRY(3,_rlevel._misc1[1]) + " ".
  UPDATE ask1 WITH FRAME ask1.
END.

IF qbf-i >= 2 THEN DO:
  DISPLAY ENTRY(8,_rlevel._misc1[1]) FORMAT "x(60)"
    WITH FRAME ask2 CENTERED ROW 5 NO-LABELS
    TITLE " " + ENTRY(6,_rlevel._misc1[1])
      +   " " + ENTRY(7,_rlevel._misc1[1]) + " ".
  UPDATE ask2 WITH FRAME ask2.
END.

IF qbf-i >= 3 THEN DO:
  DISPLAY ENTRY(12,_rlevel._misc1[1]) FORMAT "x(60)"
    WITH FRAME ask3 CENTERED ROW 5 NO-LABELS
    TITLE " " + ENTRY(10,_rlevel._misc1[1])
      +   " " + ENTRY(11,_rlevel._misc1[1]) + " ".
  UPDATE ask3 WITH FRAME ask3.
END.

IF qbf-i >= 4 THEN DO:
  DISPLAY ENTRY(16,_rlevel._misc1[1]) FORMAT "x(60)"
    WITH FRAME ask4 CENTERED ROW 5 NO-LABELS
    TITLE " " + ENTRY(14,_rlevel._misc1[1])
      +   " " + ENTRY(15,_rlevel._misc1[1]) + " ".
  UPDATE ask4 WITH FRAME ask4.
END.

IF qbf-i >= 5 THEN DO:
  DISPLAY ENTRY(20,_rlevel._misc1[1]) FORMAT "x(60)"
    WITH FRAME ask5 CENTERED ROW 5 NO-LABELS
    TITLE " " + ENTRY(18,_rlevel._misc1[1])
      +   " " + ENTRY(19,_rlevel._misc1[1]) + " ".
  UPDATE ask5 WITH FRAME ask5.
END.
PAGE.
