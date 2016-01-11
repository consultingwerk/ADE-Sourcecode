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
   History:  D. McMann 03/04/99 Added assignment of connect parameters
   
*/   

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/odb/odbvar.i }
{ prodict/gate/odb_ctl.i }	

DEFINE VARIABLE c AS CHARACTER NO-UNDO.

FIND DICTDB._Db WHERE DICTDB._Db._Db-name = odb_dbname NO-LOCK NO-ERROR.
 
IF NOT AVAILABLE DICTDB._Db THEN DO TRANSACTION:

  IF odb_username <> ? AND odb_username <> "" THEN
    ASSIGN c = "-U " + odb_username.
  IF odb_password <> ? AND odb_password <> "" THEN
    ASSIGN c = c + " -P " + odb_password.
  ASSIGN c = c + " " + odb_conparms.
  
  CREATE DICTDB._Db.
  ASSIGN
    DICTDB._Db._Db-name    = odb_dbname 
    DICTDB._Db._Db-addr    = odb_pdbname
    DICTDB._Db._Db-comm    = c
    DICTDB._Db._Db-slave   = TRUE
    DICTDB._Db._Db-type    = {adecomm/ds_type.i
                        &direction = "etoi"
                        &from-type = "user_env[22]"
                        }.
    { prodict/gate/gat_cp1a.i
              &incpname = "odb_codepage" }
  ASSIGN DICTDB._Db._Db-coll-name = (IF odb_collname <> ? AND odb_collname <> "" THEN odb_collname
                                     ELSE SESSION:CPCOLL).
END.

ASSIGN
  user_dbname = DICTDB._Db._Db-name
  user_dbtype = DICTDB._Db._Db-type
  drec_db     = RECID(DICTDB._Db)
  c           = "add".

RUN prodict/odb/_odb_sys.p (drec_db,INPUT-OUTPUT c).

RETURN.

