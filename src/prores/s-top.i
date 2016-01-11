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
