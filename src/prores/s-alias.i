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
/* s-alias.i - alias fixup for schema searching

  &dbname=  variable that holds logical dbname
  &prog=    name of calling .p
  &params=  parameter list
*/

/* if not pointing to correct db, fix situation and call self */
/* recursively.  this will also leave things set for the next */
/* time this guy is called. */
IF LDBNAME("QBF$0") <> SDBNAME({&dbname}) THEN DO:
  CREATE ALIAS "QBF$0" FOR DATABASE VALUE(SDBNAME({&dbname})).
  RUN "{&prog}" {&params}.
  RETURN.
END.

/* now point to correct _db record */
FIND QBF$0._Db
  WHERE QBF$0._Db._Db-name =
    (IF DBTYPE({&dbname}) = "PROGRESS" THEN ? ELSE LDBNAME({&dbname})) NO-LOCK.
