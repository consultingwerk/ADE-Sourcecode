/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
