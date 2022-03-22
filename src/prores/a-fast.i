/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* a-fast.i - code to find name of fastload file set */

/* I know this is ugly, but its pretty fast */
IF qbf-fastload = "" THEN DO:
  ASSIGN
    qbf-i = 0
    qbf-c = "res0000".
  DO WHILE SEARCH(qbf-c + "0.r") <> ? OR SEARCH(qbf-c + "0.p") <> ?
    OR     SEARCH(qbf-c + "1.r") <> ? OR SEARCH(qbf-c + "1.p") <> ?
    OR     SEARCH(qbf-c + "2.r") <> ? OR SEARCH(qbf-c + "2.p") <> ?
    OR     SEARCH(qbf-c + "3.r") <> ? OR SEARCH(qbf-c + "3.p") <> ?
    OR     SEARCH(qbf-c + "4.r") <> ? OR SEARCH(qbf-c + "4.p") <> ?
    OR     SEARCH(qbf-c + "5.r") <> ? OR SEARCH(qbf-c + "5.p") <> ?
    OR     SEARCH(qbf-c + "6.r") <> ? OR SEARCH(qbf-c + "6.p") <> ?
    OR     SEARCH(qbf-c + "7.r") <> ? OR SEARCH(qbf-c + "7.p") <> ?
    OR     SEARCH(qbf-c + "8.r") <> ? OR SEARCH(qbf-c + "8.p") <> ?
    OR     SEARCH(qbf-c + "9.r") <> ? OR SEARCH(qbf-c + "9.p") <> ?:
    ASSIGN
      qbf-i = qbf-i + 10
      qbf-c = "res" + STRING(qbf-i,"9999").
  END.
  qbf-fastload = "res" + STRING(qbf-i,"9999") + "0.p".
END.
