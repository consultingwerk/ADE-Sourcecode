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
/* c-merge.p - cache list of all available files in all available databases */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/c-merge.i }
{ prores/reswidg.i }
{ prores/resfunc.i }

DEFINE INPUT  PARAMETER qbf-f AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER qbf-a AS LOGICAL    NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-s AS LOGICAL    NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-p AS INTEGER    NO-UNDO.

/*
qbf-f = can-do list of file names
        special case: if qbf-f = "$*" then only files in databases not
                      containing a "$" in their logical name will be
                      used.
qbf-a = true for initial caller (false means called itself recursively)
qbf-s = list is already sorted (used internally)
qbf-p = position of qbf-file[1] in list

qbf-schema.cValue is filled with "filename,dbname,####|description" where
#### corresponds to qbf-schema.iIndex.
*/
DEFINE VARIABLE lReturn AS LOGICAL    NO-UNDO.
DEFINE VARIABLE qbf-b   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE qbf-c   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-d   AS LOGICAL    NO-UNDO. /* $* flag */
DEFINE VARIABLE qbf-g   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-i   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-j   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-t   AS CHARACTER  NO-UNDO.

/*message "[c-merge.p]" view-as alert-box.*/

IF qbf-a THEN DO:
  ASSIGN
    qbf-schema# = 0
    qbf-d       = qbf-f BEGINS "$"
    qbf-f       = SUBSTRING(qbf-f,IF qbf-d THEN 2 ELSE 1).
/* Comment out EMPTY TEMP-TABLE statement as it is causing errors later when
 * a find is done on a buffer of this table.
 * EMPTY temp-table is done on an already-empty table causes bug 266.
 * Use for each: delete instead to fix IZ 266 but a core bug
 * will be logged on the empty temp-table issue.
 *EMPTY TEMP-TABLE qbf-schema.
 */
 FOR EACH qbf-schema:
	DELETE qbf-schema.
 END.
  IF qbf-f BEGINS "!," THEN 
  DO qbf-i = 2 TO NUM-ENTRIES(qbf-f):
    qbf-c = ENTRY(qbf-i,qbf-f).
    RUN prores/s-lookup.p (qbf-c,"","","FILE:DESC",OUTPUT qbf-t).
    ASSIGN
      qbf-schema#             = qbf-schema# + 1
      lReturn                 = getRecord("qbf-schema":U, qbf-schema#)
      qbf-schema.cValue       = SUBSTRING(qbf-c,INDEX(qbf-c,".") + 1) + " "
                              + SUBSTRING(qbf-c,1,INDEX(qbf-c,".") - 1)
                              + ",0000|" + SUBSTRING(qbf-t,1,48)
      qbf-schema.cSort        = ENTRY(1, qbf-schema.cValue) + ",":U
      qbf-schema.cSort        = REPLACE(qbf-schema.cSort," ":U,",":U).
    IF qbf-schema# > 1 THEN DO: 
      {&FIND_BUF_SCHEMA} qbf-schema# - 1.
      IF qbf-schema.cValue < buf-schema.cValue THEN
      qbf-s = FALSE.
    END.
  END.
  ELSE
  DO qbf-i = 1 TO NUM-DBS:
    IF DBTYPE(qbf-i) <> "PROGRESS" THEN NEXT.
    CREATE ALIAS "QBF$0" FOR DATABASE VALUE(LDBNAME(qbf-i)).
    RUN prores/c-merge.p (qbf-f,FALSE,OUTPUT qbf-b,OUTPUT qbf-j).
    qbf-s = qbf-s AND qbf-b.
  END.

  ASSIGN
    qbf-j       = qbf-schema#
    qbf-schema# = 0
    qbf-t       = qbf-file[1] + ",":U + qbf-db[1] + ",":U.
  DO qbf-i = 1 TO qbf-j: /* make into an entry-list */
    {&FIND_QBF_SCHEMA} qbf-i.
    ASSIGN
      qbf-c                                   = qbf-schema.cValue
      SUBSTRING(qbf-c,INDEX(qbf-c,",") + 1,4) = STRING(qbf-schema# + 1,"9999")
      SUBSTRING(qbf-c,INDEX(qbf-c," ")    ,1) = ","
      qbf-schema.cValue                       = ""
      qbf-schema.cSort                        = "".
    IF qbf-d AND INDEX(ENTRY(2,qbf-c),"$") > 0 THEN NEXT.
    ASSIGN
      qbf-schema#       = qbf-schema# + 1
      lReturn           = getRecord("qbf-schema":U, qbf-schema#)     
      qbf-schema.cValue = qbf-c
      qbf-schema.cSort  = ENTRY(1, qbf-c) + ",":U +
                          ENTRY(2, qbf-c) + ",":U.
    IF qbf-schema.cValue BEGINS qbf-t THEN 
      qbf-p = qbf-i.
  END.
  RETURN.
END.

FOR EACH QBF$0._Db NO-LOCK,
  EACH QBF$0._File OF QBF$0._Db
    WHERE CAN-DO(QBF$0._File._Can-read,USERID("RESULTSDB"))
      AND CAN-DO(qbf-f,
        (IF QBF$0._Db._Db-name = ? THEN LDBNAME("QBF$0")
        ELSE QBF$0._Db._Db-name) + "." + QBF$0._File._File-name)
      AND NOT QBF$0._File._Hidden NO-LOCK
  BY QBF$0._Db._Db-name BY QBF$0._File._File-name:
  
  /* filter out sql92 tables and views */
  IF INTEGER(DBVERSION("QBF$0":U)) > 8
    THEN IF (QBF$0._File._Owner <> "PUB":U AND QBF$0._File._Owner <> "_FOREIGN":U)
    THEN NEXT.
  
  ASSIGN
    qbf-schema#             = qbf-schema# + 1
    lReturn                 = getRecord("qbf-schema":U, qbf-schema#)
    qbf-schema.cValue       = QBF$0._File._File-name + " ":U
                            + (IF QBF$0._Db._Db-name = ?
                              THEN LDBNAME("QBF$0")
                              ELSE QBF$0._Db._Db-name)
                            + ",0000|":U + SUBSTRING(
                              IF QBF$0._File._Desc = ? THEN "" ELSE
                              QBF$0._File._Desc,1,48)
    qbf-schema.cSort        = ENTRY(1, qbf-schema.cValue) + ",":U
    qbf-schema.cSort        = REPLACE(qbf-schema.cSort," ":U,",":U).
END.

IF qbf-schema# >= 2 THEN DO: /* sort */
  REPEAT PRESELECT EACH qbf-schema USE-INDEX iIndex:
    FIND NEXT qbf-schema.
    qbf-schema.iIndex = qbf-schema.iIndex + 100000.
  END.
  qbf-i = 0.
  REPEAT PRESELECT EACH qbf-schema USE-INDEX cSort:
    FIND NEXT qbf-schema.
    ASSIGN
      qbf-i             = qbf-i + 1
      qbf-schema.iIndex = qbf-i.
  END.
END.
qbf-s = TRUE.

RETURN.
