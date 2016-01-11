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

/* _gat_con.p - connect to Oracle, Rdb or Sybase using -U & -P */
/*
in:  user_env[1] = userid
     user_env[2] = password

out: no environment variables changed
*/


{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userhdr.f }

DEFINE VARIABLE phynam AS CHARACTER NO-UNDO.
DEFINE VARIABLE c      AS CHARACTER NO-UNDO.

phynam = user_dbname.
{ prodict/dictgate.i &action=query &dbtype=user_dbname &dbrec=? &output=c }
IF ENTRY(5,c) MATCHES "*p*" THEN DO: /* physical name applies */
  FIND _Db WHERE RECID(_Db) = drec_db.
  phynam = (IF _Db-addr = "" OR _Db-addr = ? THEN user_dbname ELSE _Db-addr).
  /* Connect w' physical dbname if avail, otherwise assume logical dbname */
END.

IF user_env[1] <> "" OR NOT CONNECTED(user_dbname)
  THEN DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    MESSAGE
      'Connecting to "' + user_dbname + '"'
      (IF user_env[1] = "" THEN "" ELSE 'as user "' + user_env[1] + '"').
    run adecomm/_setcurs.p ("WAIT").
    IF CONNECTED(user_dbname) THEN DISCONNECT VALUE(user_dbname).
    CONNECT
      VALUE(phynam)
      -ld VALUE(user_dbname)
      VALUE(IF user_env[1] = "" THEN "" ELSE "-U " + user_env[1])
      VALUE(IF user_env[2] = "" THEN "" ELSE "-P " + user_env[2])
      -dt VALUE(user_dbtype) NO-ERROR.
  END.

{ prodict/user/usercon.i }

PAUSE 1 NO-MESSAGE.  /* to avoid having the message flash to fast */
run adecomm/_setcurs.p ("").
HIDE MESSAGE NO-PAUSE.

IF NOT CONNECTED(user_dbname)
 THEN DO:
  MESSAGE
    'Could not connect to "' + user_dbname + '"' 
    (IF user_env[1] = "" THEN "" ELSE 'as user "' + user_env[1] + '"') SKIP
    ERROR-STATUS:GET-MESSAGE(1)
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path = "".
END.
ELSE
  CREATE ALIAS "DICTDBG" FOR DATABASE VALUE(user_dbname) NO-ERROR.

RETURN.




