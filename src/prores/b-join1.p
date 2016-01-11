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
/* b-join1.p - middle loop for b-join.p */

{ prores/s-system.i }
{ prores/t-define.i }
{ prores/b-join.i }

DEFINE            BUFFER qbf-1a-field FOR QBF$1._Field.       /*$1._Field*/
DEFINE NEW SHARED BUFFER qbf-1a-index FOR QBF$1._Index.       /*$1._Index*/
DEFINE NEW SHARED BUFFER qbf-1a-ixfld FOR QBF$1._Index-field. /*$1._Idx-field*/

DEFINE VARIABLE qbf-i AS INTEGER NO-UNDO.
qbf-i = { prores/s-etime.i }.

FOR EACH qbf-1a-index
  WHERE qbf-1a-index._Unique
    AND qbf-1a-index._Index-name < "_" NO-LOCK:
  FIND qbf-1a-ixfld OF qbf-1a-index
    WHERE qbf-1a-ixfld._Index-seq = 1 NO-LOCK NO-ERROR.
  IF NOT AVAILABLE qbf-1a-ixfld THEN NEXT.
  FIND qbf-1a-field OF qbf-1a-ixfld NO-LOCK.
  ASSIGN
    qbf-f = qbf-1a-field._Field-name
    qbf-t = qbf-1a-field._dtype.

  DO qbf-i = 1 TO NUM-ENTRIES(qbf-p):
    CREATE ALIAS "QBF$2" FOR DATABASE VALUE(ENTRY(qbf-i,qbf-p)).
    RUN prores/b-join2.p.
  END.

  /* display msg every 10 seconds */
  IF qbf-x# > 0 AND { prores/s-etime.i } - qbf-i > 10000 THEN DO:
    /* qbf-lang[11] = "Finding implied OF-relations." */
    STATUS DEFAULT qbf-lang[11] + " (" + STRING(qbf-x#) + ").".
    qbf-i = { prores/s-etime.i }.
  END.

END.

RETURN.
