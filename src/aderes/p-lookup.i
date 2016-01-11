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
 p-lookup.i - sub-proc to lookup file reference in relation table
 
 requires: { aderes/j-define.i }

 input:    dbname.filename

 output:   table id, or -1 for not found

*/

PROCEDURE lookup_table:
  DEFINE INPUT  PARAMETER qbf_f AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER qbf_p AS INTEGER   NO-UNDO.

  qbf_f = (IF INDEX(qbf_f,".":u) = 0 THEN 
             LDBNAME(1) + ".":u + qbf_f
           ELSE IF NUM-ENTRIES(qbf_f, ".":u) = 3 THEN
             ENTRY(1, qbf_f, ".":u) + ".":u + ENTRY(2, qbf_f, ".":u)
           ELSE qbf_f).

  {&FIND_TABLE_BY_NAME} qbf_f NO-ERROR.
  qbf_p = IF AVAILABLE (qbf-rel-buf) THEN qbf-rel-buf.tid ELSE -1.
END.

/* p-lookup.i - end of file */

