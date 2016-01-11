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
/*
* Sort an individual join entry. An entry is a list, consisting of
*
*    "tableName, <relationship> ..."
*
*    <relationship> = "nTW"
*    n = table index of relationship
*    T = joinType ( =><*? )
*    W = indicates if the join uses a join-where
*/

DEFINE INPUT  PARAMETER joinList   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER sortedList AS CHARACTER NO-UNDO INITIAL "".

DEFINE VARIABLE sortPos    AS CHARACTER NO-UNDO.
DEFINE VARIABLE gap        AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-i      AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j      AS INTEGER   NO-UNDO.
DEFINE VARIABLE firstFile  AS CHARACTER NO-UNDO.
DEFINE VARIABLE secondFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE stuff      AS CHARACTER NO-UNDO.

/*
* If the list is empty, or if there is only 1 thing, that we don't
* have to sort. But if there is something in the joinList then
* return it.
*/
IF NUM-ENTRIES(joinList) = 1 THEN
  sortedList = joinList.
IF NUM-ENTRIES(joinList) < 2 THEN
  RETURN.

ASSIGN
  sortPos = joinList
  gap     = TRUNCATE(NUM-ENTRIES(sortPos) / 2,0) /* shell sort */
  .

DO WHILE gap > 0:
  DO qbf-i = gap TO NUM-ENTRIES(sortPos):
    qbf-j = qbf-i - gap.
    DO WHILE qbf-j > 0:
      ASSIGN
        firstFile = SUBSTRING(ENTRY(qbf-j,sortPos),2,-1,"CHARACTER":u)
        secondFile = SUBSTRING(ENTRY(qbf-j + gap,sortPos),2,-1,"CHARACTER":u)
        .
      IF INDEX(firstFile,":":u) > 0 THEN
        firstFile = SUBSTRING(firstFile,1,INDEX(firstFile,":":u) - 1,
                              "CHARACTER":u).
      IF INDEX(secondFile,":":u) > 0 THEN
        secondFile = SUBSTRING(secondFile,1,INDEX(secondFile,":":u) - 1,
                               "CHARACTER":u).
      IF INTEGER(firstFile) < INTEGER(secondFile) THEN LEAVE.

      ASSIGN
        stuff                       = ENTRY(qbf-j, sortPos)
        ENTRY(qbf-j, sortPos)       = ENTRY(qbf-j + gap, sortPos)
        ENTRY(qbf-j + gap, sortPos) = stuff
        qbf-j                       = qbf-j - gap
        .
    END.
  END.
  gap = TRUNCATE(gap / 2,0).
END.

sortedList = sortPos.

/* _jsort1.p - end of file */

