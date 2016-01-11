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
   Procedure _ora_md2.p
   
   History: 02/16/99 DLM Added assignment of ora_conparms
   
*/

   
{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/ora/oravar.i }

DEFINE VARIABLE c AS CHARACTER NO-UNDO.

FIND _Db WHERE _Db._Db-name = ora_dbname NO-LOCK NO-ERROR.

IF NOT AVAILABLE _Db THEN DO TRANSACTION:
  CREATE _Db.
  ASSIGN
    _Db._Db-name    = ora_dbname
    _Db._Db-comm    = ora_conparms
    _Db._Db-type    = "ORACLE"
    _Db._Db-slave   = TRUE
    _Db._Db-Misc1[3] = ora_version
    _Db._Db-xl-name = ora_codepage.
END.

ASSIGN
  user_dbname = _Db._Db-name
  user_dbtype = _Db._Db-type
  drec_db     = RECID(_Db)
  c           = "add".

RUN prodict/ora/_ora_sys.p (drec_db,INPUT-OUTPUT c).

RETURN.

