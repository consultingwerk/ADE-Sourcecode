/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-top.i - form statement for qbf-top for d-main.p l-main.p and r-main.p */

DEFINE {1} SHARED FRAME qbf-top.

FORM /*1='Files:,     :,     :,     :,     :'  2='Order:'*/
  qbf-m[1] FORMAT "x(6)" qbf-file[1] FORMAT "x(70)" ATTR-SPACE SKIP
  qbf-m[2] FORMAT "x(6)" qbf-file[2] FORMAT "x(70)" ATTR-SPACE SKIP
  qbf-m[3] FORMAT "x(6)" qbf-file[3] FORMAT "x(70)" ATTR-SPACE SKIP
  qbf-m[4] FORMAT "x(6)" qbf-file[4] FORMAT "x(70)" ATTR-SPACE SKIP
  qbf-m[5] FORMAT "x(6)" qbf-file[5] FORMAT "x(70)" ATTR-SPACE SKIP
  qbf-m[6] FORMAT "x(6)" qbf-c       FORMAT "x(70)" SKIP
  WITH FRAME qbf-top ROW 2 COLUMN 1 WIDTH 80 NO-LABELS NO-ATTR-SPACE
  TITLE COLOR NORMAL " " + qbf-lang[3] + " ".
  /*Data Export Info*/ /*Label Info*/ /*Report Info*/
