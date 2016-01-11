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
/* s-lookup.p - extract schema information (see also a-lookup.p) */

/*
Keep this program small.  Move any big and clumsy information
extractions into a-lookup.p.
*/

{ prores/s-system.i }

DEFINE INPUT  PARAMETER qbf-d AS CHARACTER NO-UNDO. /* ldbname */
DEFINE INPUT  PARAMETER qbf-f AS CHARACTER NO-UNDO. /* filename */
DEFINE INPUT  PARAMETER qbf-n AS CHARACTER NO-UNDO. /* fieldname/indexname */
DEFINE INPUT  PARAMETER qbf-t AS CHARACTER NO-UNDO. /* information type */
DEFINE OUTPUT PARAMETER qbf-o AS CHARACTER NO-UNDO. /* response */

DEFINE VARIABLE qbf-h AS DECIMAL NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER NO-UNDO.
DEFINE VARIABLE qbf-k AS INTEGER NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER NO-UNDO.

/* ldbname,filename,fieldname can come in qbf-d+qbf-f+qbf-n, */
/* or as a combined entries in qbf-d or qbf-d+qbf-f */
ASSIGN
  qbf-o = qbf-d
        + (IF qbf-f = "" THEN "" ELSE "." + qbf-f)
        + (IF qbf-n = "" THEN "" ELSE "." + qbf-n)
  qbf-o = SUBSTRING(qbf-o,1,INDEX(qbf-o + "[","[") - 1) /*strip off subscript*/
  qbf-d = SUBSTRING(qbf-o,1,INDEX(qbf-o + ".",".") - 1)
  qbf-o = SUBSTRING(qbf-o,INDEX(qbf-o,".") + 1)
  qbf-f = SUBSTRING(qbf-o,1,INDEX(qbf-o + ".",".") - 1)
  qbf-n = SUBSTRING(qbf-o,INDEX(qbf-o,".") + 1)
  qbf-o = ?.

IF LDBNAME(qbf-d) = ? THEN RETURN.
{ prores/s-alias.i
  &prog=prores/s-lookup.p
  &dbname=qbf-d
  &params="(qbf-d,qbf-f,qbf-n,qbf-t,OUTPUT qbf-o)"
}

/* do relevant index cursor positions */
/* QBF$0._Db handled by s-alias.i */
IF CAN-DO("FILE:*,FIELD:*,INDEX:*",qbf-t) AND AVAILABLE QBF$0._Db THEN DO:
  /* filter out sql92 tables and views */
  IF INTEGER(DBVERSION("QBF$0":U)) > 8 THEN
    FIND QBF$0._File OF QBF$0._Db 
      WHERE QBF$0._File._File-name = qbf-f AND
        (QBF$0._File._Owner = "PUB":U OR QBF$0._File._Owner = "_FOREIGN":U)
      NO-LOCK NO-ERROR.
  ELSE 
    FIND QBF$0._File OF QBF$0._Db
      WHERE QBF$0._File._File-name = qbf-f NO-LOCK NO-ERROR.
END.

IF CAN-DO("FIELD:*",qbf-t) AND AVAILABLE QBF$0._File THEN
  FIND QBF$0._Field OF QBF$0._File
    WHERE QBF$0._Field._Field-name = qbf-n NO-LOCK NO-ERROR.
IF CAN-DO("INDEX:*",qbf-t) AND AVAILABLE QBF$0._File THEN
  FIND QBF$0._Index OF QBF$0._File
    WHERE QBF$0._Index._Index-name = qbf-n NO-LOCK.

/*--------------------------------------------------------------------------*/
IF qbf-t BEGINS "DB:" THEN DO:
  qbf-t = SUBSTRING(qbf-t,4).
  IF qbf-t = "RECID" THEN qbf-o = STRING(RECID(QBF$0._Db)).
  ELSE
  IF qbf-t = "CHECKSUM" THEN DO:
    qbf-h = 0.
    FOR EACH QBF$0._File OF QBF$0._Db
      WHERE QBF$0._File._File-num > 0:
      
      /* filter out sql92 tables and views */
      IF INTEGER(DBVERSION("QBF$0":U)) > 8 THEN
        IF (QBF$0._File._Owner <> "PUB":U AND QBF$0._File._Owner <> "_FOREIGN":U)
        THEN NEXT.
      
      qbf-h = qbf-h + QBF$0._File._Last-change.
    END.
    qbf-o = STRING(qbf-h).
  END.
  ELSE
  IF qbf-t = "ANY-FIELD" THEN
    qbf-o = STRING(
            CAN-FIND(QBF$0._Field
              WHERE QBF$0._Field._Field-name BEGINS qbf-n)
            ,"y/n")
          + STRING(
            CAN-FIND(FIRST QBF$0._Field
              WHERE QBF$0._Field._Field-name BEGINS qbf-n)
            ,"y/n").
END.

ELSE
/*--------------------------------------------------------------------------*/

IF qbf-t BEGINS "FILE:" THEN DO:
  qbf-t = SUBSTRING(qbf-t,6).
  IF qbf-t = "RECID" THEN 
    qbf-o = STRING(RECID(QBF$0._File)).
  ELSE
  IF qbf-t BEGINS "MISC2:" THEN
    qbf-o = QBF$0._File._Fil-misc2[INTEGER(SUBSTRING(qbf-t,7))].
  ELSE
  IF qbf-t = "DESC" THEN
    qbf-o = (IF NOT AVAILABLE QBF$0._File THEN ?
            ELSE IF QBF$0._File._Desc = ? THEN ""
            ELSE                               QBF$0._File._Desc).
  ELSE
  IF qbf-t = "STAMP" THEN 
    qbf-o = STRING(QBF$0._File._Last-change).
  ELSE
  IF qbf-t = "CRC" THEN 
    qbf-o = STRING(QBF$0._File._Crc).
  ELSE
  IF qbf-t = "CAN-READ" THEN
    qbf-o = (IF AVAILABLE QBF$0._File THEN QBF$0._File._Can-Read ELSE "!*").
  ELSE
  IF qbf-t = "CAN-WRITE" THEN
    qbf-o = (IF AVAILABLE QBF$0._File THEN QBF$0._File._Can-Write ELSE "!*").
  ELSE
  IF qbf-t = "CAN-CREATE" THEN
    qbf-o = (IF AVAILABLE QBF$0._File THEN QBF$0._File._Can-Create ELSE "!*").
  ELSE
  IF qbf-t = "CAN-DELETE" THEN
    qbf-o = (IF AVAILABLE QBF$0._File THEN QBF$0._File._Can-Delete ELSE "!*").
END.

ELSE
/*--------------------------------------------------------------------------*/

IF qbf-t BEGINS "FIELD:" THEN DO:
  qbf-t = SUBSTRING(qbf-t,7).
  IF qbf-t = "RECID" THEN qbf-o = STRING(RECID(QBF$0._Field)).
  ELSE
  IF qbf-t = "TYP&FMT" THEN
    qbf-o = (IF AVAILABLE QBF$0._Field THEN
              STRING(QBF$0._Field._dtype) + "," + QBF$0._Field._Format
            ELSE
              "0,").
  ELSE
  IF qbf-t = "CAN-READ" THEN
    qbf-o = (IF AVAILABLE QBF$0._Field THEN QBF$0._Field._Can-Read ELSE "!*").
  ELSE
  IF qbf-t BEGINS "MAND" THEN qbf-o = STRING(QBF$0._Field._Mandatory).
  ELSE
  IF qbf-t = "EXTENT" THEN qbf-o = STRING(QBF$0._Field._Extent).
  ELSE
  IF qbf-t = "COL-LABEL" THEN
    qbf-o = (IF QBF$0._Field._Col-label <> ? THEN
              QBF$0._Field._Col-label
            ELSE IF QBF$0._Field._Label <> ? THEN
              QBF$0._Field._Label
            ELSE
              QBF$0._Field._Field-name).
  ELSE
  IF qbf-t = "INDEX-FIELD" THEN
    qbf-o = STRING(CAN-FIND(FIRST QBF$0._Index-field OF QBF$0._Field),"y/n").
END.

ELSE
/*--------------------------------------------------------------------------*/

IF qbf-t BEGINS "INDEX:" THEN DO:
  qbf-t = SUBSTRING(qbf-t,7).
  IF qbf-t = "RECID" THEN qbf-o = STRING(RECID(QBF$0._Index)).
END.

/*--------------------------------------------------------------------------*/
RETURN.

/* s-lookup.p - end of file */

