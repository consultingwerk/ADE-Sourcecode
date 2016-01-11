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
* _sbase.p - collect a list of all available _Db-names.  All databases
*  including non-Progress ones must be connected. The list will be sorted.
*/

{ aderes/s-system.i }
{ aderes/j-define.i }

DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.

DO qbf-i = 1 TO NUM-DBS:
  qbf-dbs = qbf-dbs + (IF qbf-dbs = "" THEN "" ELSE ",":u) + LDBNAME(qbf-i).
END.

/* Sort the list */
RUN aderes/s-vector.p(TRUE, ",":u, INPUT-OUTPUT qbf-dbs).

qbf-hidedb = (NUM-ENTRIES(qbf-dbs) = 1).

RETURN.

/* _sbase.p -  end of file */

