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
/*
** Procedure compodb.p
** Sets things up so that the odb dictionary parts can be compiled.
**
*/

{ prodict/dictvar.i NEW }

DEFINE VARIABLE system AS CHARACTER INITIAL "add".

FIND FIRST DICTDB._Db WHERE DICTDB._Db._Db-name = "DICTDBG" NO-ERROR.

IF AVAILABLE DICTDB._Db THEN DO:
    IF DICTDB._Db._Db-type  = "ODBC" THEN RETURN.
    DELETE DICTDB._Db.
END.

IF NOT AVAILABLE DICTDB._Db THEN DO:
    IF CAN-DO(GATEWAYS,"ODBC") THEN DO:
	CREATE DICTDB._Db.                         
	ASSIGN DICTDB._Db._Db-name     = "DICTDBG"  
	       DICTDB._Db._Db-type     = "ODBC"
	       DICTDB._Db._Db-slave    = TRUE
	       DICTDB._Db._Db-addr     = ""
	       DICTDB._Db._Db-comm     = ""
	       DICTDB._Db._Db-xl-name  = "ibm850".
	RUN prodict/odb/_odb_sys.p (RECID(DICTDB._Db), 
	               INPUT-OUTPUT system).
    END.
END.
RETURN.

