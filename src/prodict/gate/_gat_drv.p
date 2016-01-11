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

/* This procedure will be used to connect to either an ODBC or MSS database to
   get driver information that is needed for the pull.
   
   prodict/gate/_gat_drv.p
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
  FIND _Db WHERE RECID(_Db) = drec_db NO-LOCK.
  phynam = (IF _Db-addr = "" OR _Db-addr = ? THEN user_dbname ELSE _Db-addr).
  /* Connect w' physical dbname if avail, otherwise assume logical dbname */
END.

IF user_env[1] <> "" THEN DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    run adecomm/_setcurs.p ("WAIT").
    CONNECT
      VALUE(phynam)
      -ld VALUE(user_dbname)
      VALUE(IF user_env[1] = "" THEN "" ELSE "-U " + user_env[1])
      VALUE(IF user_env[2] = "" THEN "" ELSE "-P " + user_env[2])
      VALUE(IF _Db._Db-comm = "" OR _Db._Db-comm = ? THEN "" ELSE _Db._Db-comm)
      -dt VALUE(user_dbtype) NO-ERROR.
END.
ELSE
  CONNECT 
    VALUE(phynam) -ld VALUE(user_dbname) -dt VALUE(user_dbtype) 
    VALUE(_Db._Db-comm) NO-ERROR.

run adecomm/_setcurs.p ("").
HIDE MESSAGE NO-PAUSE.
RELEASE _Db.

IF NOT CONNECTED(user_dbname) THEN DO:
  MESSAGE
    'Could not connect to "' + user_dbname + '"' 
    (IF user_env[1] = "" THEN "" ELSE 'as user "' + user_env[1] + '"') SKIP
    ERROR-STATUS:GET-MESSAGE(1)
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  
  /* "wrg-ver" being used not because it is the wrong version but because it is
      alreday implemented for _usrsdel so I am re-using here also */
  ASSIGN user_env[35] = "wrg-ver".

  IF user_dbtype = "MSS" THEN 
    ASSIGN user_path = "_usrsdel,*C,1=add,3=MSS,_usrschg,_gat_ini,*C,_gat_drv,*C,_gat_con,_mss_get,_mss_pul,_gat_cro".
 
  ELSE /* ODBC */
    ASSIGN user_path = "_usrsdel,*C,1=add,3=ODBC,_usrschg,_gat_ini,*C,_gat_drv,*C,_gat_con,_odb_get,_odb_pul,_gat_cro".
 
  RETURN.
END.
ELSE
  CREATE ALIAS "DICTDBG" FOR DATABASE VALUE(user_dbname) NO-ERROR.

IF user_dbtype = "MSS" THEN
  RUN prodict/mss/_mss_sdb.p.
ELSE
  RUN prodict/odb/_odb_sdb.p.

DISCONNECT VALUE(user_dbname).

RETURN.





