/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
   Procedure _ora_md2.p
   
   History: 02/16/99 DLM Added assignment of ora_conparms
            06/04/02 DLM Added check for error creating hidden files.
   
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
    _Db._Db-Misc2[1] = user_env[41]
    _Db._Db-xl-name = ora_codepage
    _Db._Db-coll-name = (IF ora_collname <> ? AND ora_collname <> "" THEN ora_collname
                         ELSE SESSION:CPCOLL).
END.

ASSIGN
  user_dbname = _Db._Db-name
  user_dbtype = _Db._Db-type
  drec_db     = RECID(_Db)
  c           = "add".

RUN prodict/ora/_ora_sys.p (drec_db,INPUT-OUTPUT c).
IF RETURN-VALUE = "2" THEN
    RETURN "2".
ELSE
  RETURN.

