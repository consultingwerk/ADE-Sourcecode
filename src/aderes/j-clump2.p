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
 * j-clump2.p - general-purpose field acquisition program subroutine
 */

{ aderes/j-define.i }
{ aderes/j-clump.i }

DEFINE INPUT PARAMETER qbf-tbl AS INTEGER   NO-UNDO. /* table # */
DEFINE INPUT PARAMETER qbf-a   AS LOGICAL   NO-UNDO. /* array flag */
DEFINE INPUT PARAMETER qbf-typ AS CHARACTER NO-UNDO. /* _dtype list */
/*
  qbf-a = TRUE  - arrays only
        = FALSE - scalars only
        = ?     - both
*/
DEFINE VARIABLE dname AS CHARACTER NO-UNDO. /* database name */

{&FIND_TABLE_BY_ID} qbf-tbl.
dname = ENTRY(1, qbf-rel-buf.tname, ".":u).
FIND QBF$0._Db WHERE QBF$0._Db._Db-name = 
  (IF DBTYPE(dname) = "PROGRESS":u THEN ? ELSE dname) NO-LOCK.

/*
 * Time to fool everyone with the alias. Look for the table. If it isn't
 * there then it must be a table alias. Also if version 9 and above, filter out 
 * sql92 views and tables.
 */
IF INTEGER(DBVERSION("QBF$0":U)) > 8 THEN DO:
    FIND QBF$0._File OF QBF$0._Db WHERE QBF$0._File._File-name = 
        ENTRY(2, qbf-rel-buf.tname, ".":u) 
            AND (QBF$0._File._Owner = "PUB":U OR QBF$0._File._Owner = "_FOREIGN":U)
                NO-LOCK NO-ERROR.
END.
ELSE DO:
    FIND QBF$0._File OF QBF$0._Db WHERE QBF$0._File._File-name = 
        ENTRY(2, qbf-rel-buf.tname, ".":u) 
            NO-LOCK NO-ERROR.
END.

IF NOT AVAILABLE QBF$0._File THEN DO:
    {&FIND_TABLE2_BY_ID} qbf-rel-buf.sid.
    IF INTEGER(DBVERSION("QBF$0":U)) > 8 THEN DO:
        FIND QBF$0._File OF QBF$0._Db WHERE QBF$0._File._File-name = 
            ENTRY(2, qbf-rel-buf2.tname, ".":u) 
                AND (QBF$0._File._Owner = "PUB":U OR QBF$0._File._Owner = "_FOREIGN":U)
                    NO-LOCK NO-ERROR. 
    END.
    ELSE DO:
        FIND QBF$0._File OF QBF$0._Db WHERE QBF$0._File._File-name = 
            ENTRY(2, qbf-rel-buf2.tname, ".":u) NO-LOCK NO-ERROR. 
    END.
END.

FIND qbf-clump WHERE qbf-clump.qbf-cfil = qbf-tbl.

FOR EACH QBF$0._Field OF QBF$0._File NO-LOCK
  WHERE (qbf-a = ? OR qbf-a = (QBF$0._Field._Extent > 0))
    AND INDEX(qbf-typ,STRING(QBF$0._Field._dtype)) > 0
    AND CAN-DO(QBF$0._Field._Can-Read,USERID(dname))
  BY QBF$0._Field._Field-name
  WHILE qbf-clump.qbf-csiz < EXTENT(qbf-clump.qbf-cnam):

  ASSIGN
    qbf-clump.qbf-csiz                     = qbf-clump.qbf-csiz + 1
    qbf-clump.qbf-cnam[qbf-clump.qbf-csiz] = QBF$0._Field._Field-name
    qbf-clump.qbf-cext[qbf-clump.qbf-csiz] = QBF$0._Field._Extent
    qbf-clump.qbf-clbl[qbf-clump.qbf-csiz] = (IF QBF$0._Field._Label = ?
                                             OR  QBF$0._Field._Label = ""
                                             THEN QBF$0._Field._Field-name
                                             ELSE QBF$0._Field._Label).
END.

RETURN.

/* j-clump2.p - end of file */

