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
/* a-lookup.p - extract schema information (see also s-lookup.p) */

{ prores/s-system.i }
{ prores/s-define.i }

DEFINE INPUT  PARAMETER qbf-d AS CHARACTER NO-UNDO. /* ldbname */
DEFINE INPUT  PARAMETER qbf-f AS CHARACTER NO-UNDO. /* filename */
DEFINE INPUT  PARAMETER qbf-n AS CHARACTER NO-UNDO. /* fieldname list */
DEFINE INPUT  PARAMETER qbf-t AS CHARACTER NO-UNDO. /* information type */
DEFINE OUTPUT PARAMETER qbf-o AS CHARACTER NO-UNDO. /* response */

/*
qbf-t = "u" - return elements of unique index, if available
qbf-t = "f" - load up qbf-rc*[] array with matching fields for a-form.p
qbf-t = "b" - similar to FILE:FORM, but set up for build time
qbf-t = "q" - returns "ROWID" if ROWID capable,
              "INDEX" if unique index available,
              or "NONE" if no unique way to identify record.
*/

DEFINE VARIABLE qbf-j AS INTEGER NO-UNDO.

IF LDBNAME(qbf-d) = ? THEN RETURN.
{ prores/s-alias.i
  &prog=prores/a-lookup.p
  &dbname=qbf-d
  &params="(qbf-d,qbf-f,qbf-n,qbf-t,OUTPUT qbf-o)"
}

/* do relevant index cursor positions */
/* QBF$0._Db handled by s-alias.i */

/* filter out sql92 tables and views */
IF INTEGER(DBVERSION("QBF$0":U)) > 8 THEN
  FIND QBF$0._File OF QBF$0._Db 
    WHERE QBF$0._File._File-name = qbf-f AND
      (QBF$0._File._Owner = "PUB":U OR QBF$0._File._Owner = "_FOREIGN":U)
    NO-LOCK NO-ERROR.
ELSE 
  FIND QBF$0._File OF QBF$0._Db
    WHERE QBF$0._File._File-name = qbf-f NO-LOCK NO-ERROR.

/*--------------------------------------------------------------------------*/

IF qbf-t = "u" THEN DO:
  /* return elements of unique index, if available */
  FIND QBF$0._Index
    WHERE RECID(QBF$0._Index) = QBF$0._File._Prime-Index
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE QBF$0._Index
    OR NOT QBF$0._Index._Unique THEN
    FIND FIRST QBF$0._Index OF QBF$0._File
      WHERE QBF$0._Index._Unique NO-LOCK NO-ERROR.
  IF AVAILABLE QBF$0._Index THEN DO:
    FOR EACH QBF$0._Index-Field OF QBF$0._Index NO-LOCK:
      FIND QBF$0._Field OF QBF$0._Index-Field NO-LOCK.
      qbf-o = (IF qbf-o = ? THEN "" ELSE qbf-o)
            + (IF LENGTH(qbf-o) > 0 THEN "," ELSE "")
          /*+ STRING(QBF$0._Field._dtype) + ":"*/
            + QBF$0._Field._Field-name.
    END.
  END.
END.

ELSE

IF qbf-t = "f" THEN DO:
  /* load up qbf-rc*[] array with matching fields for a-form.p */
  /* assumes s-zap'd */
  qbf-rc# = 0. /* but just in case... */
  FOR EACH QBF$0._Field OF QBF$0._File
    WHERE CAN-DO(qbf-n,QBF$0._Field._Field-name) NO-LOCK
    BY QBF$0._Field._Order:
    ASSIGN
      qbf-rc#          = qbf-rc# + 1
      qbf-rcn[qbf-rc#] = QBF$0._Field._Field-name /* name */
      qbf-rca[qbf-rc#] = "y"
                       + STRING(PROGRESS = "Full"       ,"y/n")
                       + STRING(QBF$0._Field._Extent > 0,"yny/nnn")
      qbf-rct[qbf-rc#] = QBF$0._Field._dtype
      qbf-rcw[qbf-rc#] = QBF$0._Field._Order.
  END.
  qbf-rc# = 0.
  FOR EACH QBF$0._Field OF QBF$0._File NO-LOCK:
    qbf-rc# = MAXIMUM(qbf-rc#,QBF$0._Field._field-rpos).
  END.
END.

ELSE

IF qbf-t = "b" THEN DO:
  /* similar to FILE:FORM, but set up for build time */
  DO qbf-j = 1 TO MINIMUM({ prores/s-limcol.i },NUM-ENTRIES(qbf-n)):
    FIND QBF$0._Field OF QBF$0._File
      WHERE QBF$0._Field._Field-name = ENTRY(qbf-j,qbf-n) NO-LOCK.
    ASSIGN
      qbf-rcn[qbf-j] = QBF$0._Field._Field-name
      qbf-rcw[qbf-j] = QBF$0._Field._Order
      qbf-rct[qbf-j] = QBF$0._Field._dtype
      qbf-rca[qbf-j] = "y"
                     + STRING(PROGRESS = "Full"       ,"y/n")
                     + STRING(QBF$0._Field._Extent = 0,"yny/nnn").
  END.
END.

ELSE

IF qbf-t = "q" THEN DO:
  /* find a unique way to identify a record */
  FIND FIRST QBF$0._Index OF QBF$0._File
    WHERE QBF$0._Index._Unique NO-LOCK NO-ERROR.
  qbf-o = (IF AVAILABLE QBF$0._Index THEN "INDEX" ELSE "NONE").
  IF NOT CAN-DO(DBRESTRICTIONS(qbf-d),"ROWID") THEN qbf-o = "ROWID".
  IF QBF$0._Db._Db-type = "RMS"
    AND CAN-DO("relative,sequential",QBF$0._File._Fil-misc2[8])
    THEN qbf-o = "ROWID".
END.

RETURN.
