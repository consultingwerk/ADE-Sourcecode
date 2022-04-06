/*********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/


/* History:

   04/13/2007   fernando    Fixing case where the table name is passed 
   
*/

DEFINE INPUT PARAMETER file-name    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER fd-file-name AS CHARACTER NO-UNDO.

{ prodict/user/uservar.i NEW }
{ prodict/dictvar.i NEW }

FIND FIRST _Db WHERE _Db._Db-local NO-LOCK.

IF file-name NE "ALL":U THEN DO:

    /* need to also find the table based on the file name */
    FIND _File WHERE _Db-recid = RECID(_Db) AND _File-name = file-name
        AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN" ) NO-LOCK NO-ERROR.
    
    IF NOT AVAILABLE(_File) THEN DO:
        MESSAGE "Cannot find table" file-name.
        RETURN.
    END.
END.

ASSIGN
  user_dbname   = LDBNAME("DICTDB")
  user_dbtype   = DBTYPE("DICTDB")
  drec_db       = RECID(_Db)
  drec_file     = RECID(_File)
  user_filename = file-name
  user_env[1]   = file-name
  user_env[2]   = fd-file-name.
DO TRANSACTION ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  RUN "prodict/dump/_dmpbulk.p".
END.
RETURN.
