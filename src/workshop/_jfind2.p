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
 * _jfind2.p - inner loop for _jfind1.p
 */

{ workshop/j-define.i }
{ workshop/j-find.i }

DEFINE BUFFER qbf-2a-field FOR QBF$2._Field.
DEFINE BUFFER qbf-2b-field FOR QBF$2._Field.

DEFINE VARIABLE qbf-1 AS INTEGER   NO-UNDO. /* 1st db index */
DEFINE VARIABLE qbf-2 AS INTEGER   NO-UNDO. /* 2nd db index */
DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO. /* more scrap */
DEFINE VARIABLE qbf-h AS INTEGER   NO-UNDO. /* bsearch hi bound */
DEFINE VARIABLE qbf-j AS CHARACTER NO-UNDO. /* relation type */
DEFINE VARIABLE qbf-l AS INTEGER   NO-UNDO. /* bsearch lo bound */
DEFINE VARIABLE qbf-p AS INTEGER   NO-UNDO. /* scrap loop */

ASSIGN
  qbf-1      = LOOKUP(SDBNAME("QBF$1":u),qbf-pro-dbs)
  qbf-2      = LOOKUP(SDBNAME("QBF$2":u),qbf-pro-dbs).
  
/* For each field in this database matching name of first component of 
   unique index selected above...
 */
FOR EACH qbf-2a-field
  WHERE qbf-2a-field._Field-name = ENTRY(1,qbf-nt)
    AND qbf-2a-field._dtype      = INTEGER(ENTRY(2,qbf-nt))
    AND (qbf-1 <> qbf-2 OR qbf-2a-field._File-recid <> qbf-same) NO-LOCK:

  /* match up rest of components */
  DO qbf-p = 2 TO NUM-ENTRIES(qbf-nt) / 2:
    FIND qbf-2b-field
      WHERE qbf-2b-field._File-recid = qbf-2a-field._File-recid
        AND qbf-2b-field._Field-name = ENTRY(qbf-p * 2 - 1,qbf-nt)
        AND qbf-2b-field._dtype = INTEGER(ENTRY(qbf-p * 2,qbf-nt))
      NO-LOCK NO-ERROR.
    IF NOT AVAILABLE qbf-2b-field THEN LEAVE.
  END.

  /* failed; cannot match on OF's */
  IF qbf-p <= NUM-ENTRIES(qbf-nt) / 2 THEN NEXT.
  
  qbf-j = "<":u.

  /* check for 1:1, 1:M, M:1 relationship */
  FOR EACH QBF$2._Index
    WHERE QBF$2._Index._Unique
      AND QBF$2._Index._num-comp = NUM-ENTRIES(qbf-nt) / 2
      AND (NOT CAN-FIND(_Field WHERE _Field._Field-name = "_Wordidx") 
           OR (QBF$2._Index._Wordidx = ? OR QBF$2._Index._Wordidx = 0))
      AND QBF$2._Index._File-recid = qbf-2a-field._File-recid NO-LOCK
    WHILE qbf-j = "<":u:

    /* match up _all_ field names */
    FOR EACH QBF$2._Index-field
      OF QBF$2._Index NO-LOCK
      BY QBF$2._Index-field._Index-seq:
      FIND QBF$2._Field OF QBF$2._Index-field
        WHERE QBF$2._Field._Field-name
            = ENTRY(QBF$2._Index-field._Index-seq * 2 - 1,qbf-nt)
          AND QBF$2._Field._dtype
            = INTEGER(ENTRY(QBF$2._Index-field._Index-seq * 2,qbf-nt))
        NO-LOCK NO-ERROR.
      IF NOT AVAILABLE QBF$2._Field THEN LEAVE.
      IF QBF$2._Index-field._Index-seq = QBF$2._Index._num-comp THEN
        qbf-j = "=":u.
    END.
  END.

  /* Something was found.  Look up second file in relation table
     using binary search to get position of filename and append
     to qbf-subset. */
  FIND QBF$2._File OF qbf-2a-field NO-LOCK.
  FIND QBF$2._Db OF QBF$2._File NO-LOCK.
  ASSIGN
    qbf-c = (IF QBF$2._Db._Db-name = ? THEN SDBNAME("QBF$2":u)
            ELSE QBF$2._Db._Db-name) + ".":u + QBF$2._File._File-name.
  {&FIND_TABLE_BY_NAME} qbf-c.

  /* add index field list to join fields variable */
  DO qbf-p = 1 TO NUM-ENTRIES(qbf-nt) BY 2:
    qbf-fields = qbf-fields + (IF qbf-fields = "" THEN "" ELSE 
                  (IF qbf-p = 1 THEN CHR(3) ELSE ",":U)) + ENTRY(qbf-p,qbf-nt).
  END.

  /* load 'em up and move 'em out */
  ASSIGN
    qbf-subset = qbf-subset + (IF qbf-subset = "" THEN "" ELSE ",":u)
                 + qbf-j + STRING(qbf-rel-buf.tid)
    qbf-est    = qbf-est + 1.

END.

/* _jfind2.p - end of file */
