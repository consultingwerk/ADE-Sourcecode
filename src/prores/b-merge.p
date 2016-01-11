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
/* b-merge.p - cache list of all available files in all available databases */

/* very similar to c-merge.p */

{ prores/s-system.i }
{ prores/a-define.i }
{ prores/c-form.i }
{ prores/reswidg.i }
{ prores/resfunc.i }

DEFINE INPUT  PARAMETER qbf-a AS LOGICAL NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-s AS LOGICAL NO-UNDO.

/*                          
qbf-a = true for initial caller (false means called itself recursively)
qbf-s = list is already sorted (used internally)
*/
DEFINE VARIABLE lReturn AS LOGICAL    NO-UNDO.
DEFINE VARIABLE qbf-b   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE qbf-c   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-g   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-i   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-j   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-t   AS CHARACTER  NO-UNDO.

/*message "[b-merge.p]" view-as alert-box.*/

IF qbf-a THEN DO:
  ASSIGN
    qbf-form# = 0.
  EMPTY TEMP-TABLE qbf-form.

  DO qbf-i = 1 TO NUM-DBS:
    IF DBTYPE(qbf-i) <> "PROGRESS" THEN NEXT.
    CREATE ALIAS "QBF$0" FOR DATABASE VALUE(LDBNAME(qbf-i)).
    RUN prores/b-merge.p (FALSE,OUTPUT qbf-s).
  END.
  
  RETURN.
END.

FOR EACH QBF$0._Db
  WHERE INDEX(IF QBF$0._Db._Db-name = ? THEN
         LDBNAME("QBF$0") ELSE QBF$0._Db._Db-name,"$") = 0 NO-LOCK,
  EACH QBF$0._File OF QBF$0._Db
    WHERE CAN-DO(QBF$0._File._Can-read,USERID("RESULTSDB"))
      AND NOT QBF$0._File._Hidden
      AND CAN-FIND(FIRST QBF$0._Field OF QBF$0._File) NO-LOCK
  BY QBF$0._Db._Db-name BY QBF$0._File._File-name:
  
  /* filter out sql92 tables and views */
  IF INTEGER(DBVERSION("QBF$0":U)) > 8
    THEN IF (QBF$0._File._Owner <> "PUB":U AND QBF$0._File._Owner <> "_FOREIGN":U)
    THEN NEXT.
  
  ASSIGN
    qbf-form#           = qbf-form# + 1
    lReturn             = getRecord("qbf-form":U, qbf-form#)
    qbf-form.cValue     = (IF QBF$0._Db._Db-name = ? THEN
                            LDBNAME("QBF$0")
                          ELSE QBF$0._Db._Db-name)
                        + "." + QBF$0._File._File-name
    qbf-form.cDesc      = ""
    qbf-form.xValue     = QBF$0._File._Can-read.
END.

IF qbf-form# >= 2 THEN DO: /* sort */
  REPEAT PRESELECT EACH qbf-form USE-INDEX iIndex:
    FIND NEXT qbf-form.
    qbf-form.iIndex = qbf-form.iIndex + 100000.
  END.
  qbf-i = 0.
  REPEAT PRESELECT EACH qbf-form USE-INDEX cValue:
    FIND NEXT qbf-form.
    ASSIGN
      qbf-i           = qbf-i + 1
      qbf-form.iIndex = qbf-i.
  END.
END.
qbf-s = TRUE. /* sorted */

RETURN.
