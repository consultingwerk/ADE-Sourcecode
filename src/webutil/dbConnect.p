/*********************************************************************
* Copyright (C) 2001 by Progress Software Corporation ("PSC"),       *
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
/*--------------------------------------------------------------------

  File: webutil/dbcheck.p

  Description: 
    This program is an external procedure, because for some reason, 
    external procedures are more efficient at picking up on dropped 
    database connections. 
    This connects a database using parameters.

  Input Parameters:

  Output Parameters:
      <none>

--------------------------------------------------------------------*/
DEFINE INPUT PARAM cDB      AS CHAR    NO-UNDO.
DEFINE INPUT PARAM cConnect AS CHAR    NO-UNDO.
DEFINE VARIABLE c1          AS CHAR    NO-UNDO.

CONNECT VALUE(cConnect) NO-ERROR.
ASSIGN c1 = STRING(CONNECTED(cDB),"yes/no") NO-ERROR.
RETURN c1.
