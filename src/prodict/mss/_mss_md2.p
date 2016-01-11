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
             D. McMann 06/18/01 Added assignment of _Db-Misc1[1]
   
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
  IF mss_password <> ? AND mss_password <> "" THEN
    ASSIGN c = c + " -P " + mss_password.
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

