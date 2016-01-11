/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
