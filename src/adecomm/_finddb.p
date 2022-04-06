/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _finddb.p

Description:
  Returns id of _db record if it exists in current database.

Input Parameters:
   p_DBName - Name of the _db record we are looking for.

Output Parameters:
   p_DBID   - Set to recid of _dbrecord

Author: Warren Bare

Date Created: 09/03/92

----------------------------------------------------------------------------*/


Define INPUT  PARAMETER p_DBName as character NO-UNDO.
Define OUTPUT PARAMETER p_DBID 	 as recid     NO-UNDO INIT ?.

FIND DICTDB._DB WHERE DICTDB._DB._DB-Name = p_DBName NO-LOCK NO-ERROR.

IF AVAILABLE DICTDB._DB THEN
  p_DBID = RECID(DICTDB._DB).

RETURN.
