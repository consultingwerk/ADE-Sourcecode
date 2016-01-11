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
/*----------------------------------------------------------------------------

File:  dbname.i

Description:
     Include file for _chkfld.p and _mapfld.p which gets the appropriate
     db-name value for local and foreign databases.

Author:  Nancy E.Horn 

Date Created: Mar. 1997
---------------------------------------------------------------------------- */
 FUNCTION get-dbname RETURNS CHARACTER (dbrecid AS RECID):
    FIND FIRST DICTDB._db NO-LOCK WHERE RECID(DICTDB._db) eq dbrecid NO-ERROR.
    IF AVAILABLE(DICTDB._db) AND (DICTDB._db._db-name ne ?) THEN 
	RETURN DICTDB._db._db-name.
    ELSE
        RETURN LDBNAME("DICTDB").
 END FUNCTION.

/* End Function Definitions */
