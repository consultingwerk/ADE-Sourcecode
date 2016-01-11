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
    {&tmp2} = 0
    {&tmp1} = "res0000":u.

  DO WHILE SEARCH({&tmp1} + "0.r":u) <> ? OR SEARCH({&tmp1} + "0.p":u) <> ?
    OR     SEARCH({&tmp1} + "1.r":u) <> ? OR SEARCH({&tmp1} + "1.p":u) <> ?
    OR     SEARCH({&tmp1} + "2.r":u) <> ? OR SEARCH({&tmp1} + "2.p":u) <> ?
    OR     SEARCH({&tmp1} + "3.r":u) <> ? OR SEARCH({&tmp1} + "3.p":u) <> ?
    OR     SEARCH({&tmp1} + "4.r":u) <> ? OR SEARCH({&tmp1} + "4.p":u) <> ?
    OR     SEARCH({&tmp1} + "5.r":u) <> ? OR SEARCH({&tmp1} + "5.p":u) <> ?
    OR     SEARCH({&tmp1} + "6.r":u) <> ? OR SEARCH({&tmp1} + "6.p":u) <> ?
    OR     SEARCH({&tmp1} + "7.r":u) <> ? OR SEARCH({&tmp1} + "7.p":u) <> ?
    OR     SEARCH({&tmp1} + "8.r":u) <> ? OR SEARCH({&tmp1} + "8.p":u) <> ?
    OR     SEARCH({&tmp1} + "9.r":u) <> ? OR SEARCH({&tmp1} + "9.p":u) <> ?:
    ASSIGN
      {&tmp2} = {&tmp2} + 10
      {&tmp1} = "res":u + STRING({&tmp2},"9999":u).
  END.
  qbf-fastload = "res":u + STRING({&tmp2},"9999":u) + "0.p":u.
END.

/* a-fast.i - end of file */

