/**************************************************************************
* Copyright (C) 2000-2025 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions              *
* contributed by participants of Possenet.                                *
*                                                                         *
***************************************************************************/

/*
   History:  D. McMann 03/04/99 Added assignment of connect parameters
             D. McMann 06/18/01 Added assignment of _Db-Misc1[1]
             tmasood   12/18/25 Encrypt the clear-text password using ENCRYPT-AUDIT-MAC-KEY
   
*/   

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/mss/mssvar.i }
{ prodict/gate/odb_ctl.i }	

DEFINE VARIABLE c AS CHARACTER NO-UNDO.

FIND DICTDB._Db WHERE DICTDB._Db._Db-name = mss_pdbname NO-LOCK NO-ERROR.
 
IF NOT AVAILABLE DICTDB._Db THEN DO TRANSACTION:

  IF mss_username <> ? AND mss_username <> "" THEN
    ASSIGN c = "-U " + mss_username.
  IF mss_password <> ? AND mss_password <> "" THEN DO:
    /* Encrypt the clear-text password otherwise save it as is */
    IF INDEX(mss_password, "::") = 6 THEN
        ASSIGN c = c + " -P " + mss_password.
    ELSE
        ASSIGN c = c + " -P " + AUDIT-POLICY:ENCRYPT-AUDIT-MAC-KEY(mss_password, "ae2h1").
  END.
  ASSIGN c = c + " " + mss_conparms.
  
  CREATE DICTDB._Db.
  ASSIGN
    DICTDB._Db._Db-name    = mss_pdbname 
    DICTDB._Db._Db-addr    = mss_dbname
    DICTDB._Db._Db-comm    = c
    DICTDB._Db._Db-slave   = TRUE    
    DICTDB._Db._Db-type    = {adecomm/ds_type.i
                        &direction = "etoi"
                        &from-type = "user_env[22]"
                        }.
    { prodict/gate/gat_cp1a.i
              &incpname = "mss_codepage" }
              
  ASSIGN DICTDB._Db._Db-coll-name = (IF mss_collname <> ? AND mss_collname <> "" THEN mss_collname
                                     ELSE SESSION:CPCOLL)
         DICTDB._Db._Db-Misc1[1] = (IF mss_incasesen = TRUE THEN 1 
                                   ELSE 0).
 
END.

ASSIGN
  user_dbname = DICTDB._Db._Db-name
  user_dbtype = DICTDB._Db._Db-type
  drec_db     = RECID(DICTDB._Db)
  c           = "add".

RUN prodict/mss/_mss_sys.p (drec_db,INPUT-OUTPUT c).

RETURN.

