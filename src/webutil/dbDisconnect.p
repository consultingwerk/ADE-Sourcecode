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
    This disconnects the connected databases in failover situation.

  Input Parameters:

  Output Parameters:
      <none>

--------------------------------------------------------------------*/
DEFINE VARIABLE i1 AS INTEGER    NO-UNDO.
DO i1 = 1 TO NUM-DBS:
  DISCONNECT VALUE(LDBNAME(i1)) NO-ERROR.
END.
RETURN.

/* dbcheck.p - end of file */
