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
