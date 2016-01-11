/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* b-join3.p - gets file information for b-join.p */

DEFINE INPUT  PARAMETER qbf-x AS RECID     NO-UNDO.
DEFINE INPUT  PARAMETER qbf-y AS RECID     NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-w AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-z AS CHARACTER NO-UNDO.

FIND QBF$1._File WHERE RECID(QBF$1._File) = qbf-x NO-LOCK.
FIND QBF$1._Db OF QBF$1._File NO-LOCK.
qbf-w = (IF QBF$1._Db._Db-name = ? THEN
          SDBNAME("QBF$1")
        ELSE
          QBF$1._Db._Db-name)
      + "." + QBF$1._File._File-name.

FIND QBF$2._File WHERE RECID(QBF$2._File) = qbf-y NO-LOCK.
FIND QBF$2._Db OF QBF$2._File NO-LOCK.
qbf-z = (IF QBF$2._Db._Db-name = ? THEN
          SDBNAME("QBF$2")
        ELSE
          QBF$2._Db._Db-name)
      + "." + QBF$2._File._File-name.

RETURN.

/* b-join3.p - end of file */

