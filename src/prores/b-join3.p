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

