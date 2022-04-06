/*********************************************************************
* Copyright (C) 2000,2009 by Progress Software Corporation. All      *
* rights reserved. Prior versions of this work may contain portions  *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _gat_con.p - connect to Oracle, Rdb or Sybase using -U & -P */
/*
in:  user_env[1] = userid
     user_env[2] = password

out: no environment variables changed
D. McMann 10/17/03 Add NO-LOCK statement to _Db find in support of on-line schema add
Rohit     02/20/09 Call dictgate.i with user_dbtype instead of user_dbname- OE00128393
*/


{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userhdr.f }

DEFINE VARIABLE phynam AS CHARACTER NO-UNDO.
DEFINE VARIABLE c      AS CHARACTER NO-UNDO.

phynam = user_dbname.
{ prodict/dictgate.i &action=query &dbtype=user_dbtype &dbrec=? &output=c }
IF ENTRY(5,c) MATCHES "*p*" THEN DO: /* physical name applies */
  FIND _Db WHERE RECID(_Db) = drec_db NO-LOCK.
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




