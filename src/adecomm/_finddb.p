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
