/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

