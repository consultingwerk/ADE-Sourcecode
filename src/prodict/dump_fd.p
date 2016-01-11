/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

DEFINE INPUT PARAMETER file-name    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER fd-file-name AS CHARACTER NO-UNDO.

{ prodict/user/uservar.i NEW }
{ prodict/dictvar.i NEW }

FIND FIRST _Db WHERE _Db._Db-local NO-LOCK.

ASSIGN
  user_dbname   = LDBNAME("DICTDB")
  user_dbtype   = DBTYPE("DICTDB")
  drec_db       = RECID(_Db)
  user_filename = file-name
  user_env[1]   = file-name
  user_env[2]   = fd-file-name.
DO TRANSACTION ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  RUN "prodict/dump/_dmpbulk.p".
END.
RETURN.
