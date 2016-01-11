/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* u-used.p - called by u-dump.p to check if a _file-name is already used */

/* part of a set comprised of u-dump.p u-load.p u-pick.p u-used.p */

DEFINE INPUT  PARAMETER qbf-f AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-a AS LOGICAL   NO-UNDO.

FIND RESULTSDB._Db WHERE RESULTSDB._Db._Db-name = ?.

/* filter out sql92 tables and views */
IF INTEGER(DBVERSION("RESULTSDB":U)) > 8 THEN
  FIND RESULTSDB._File OF RESULTSDB._Db 
    WHERE RESULTSDB._File._File-name = qbf-f AND
      (RESULTSDB._File._Owner = "PUB":U OR RESULTSDB._File._Owner = "_FOREIGN":U)
    NO-ERROR.
ELSE 
  FIND RESULTSDB._File OF RESULTSDB._Db
    WHERE RESULTSDB._File._File-name = qbf-f NO-ERROR.

qbf-a = AVAILABLE RESULTSDB._File.

RETURN.
