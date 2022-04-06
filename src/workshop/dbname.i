/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
