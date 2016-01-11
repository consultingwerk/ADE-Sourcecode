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
