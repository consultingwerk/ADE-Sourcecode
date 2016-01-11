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

