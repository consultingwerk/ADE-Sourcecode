/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _getrdbs.p

Description:   
   Get the list of foreign databases for which the current database is a
   schema holder looking through the _Db file.

   Add each one to the cache of databases making sure that it is not
   already there.

Author: Laura Stern

Date Created: 01/28/92 
     History: 10/17/03 DLM Add NO-LOCK statement to _Db find in support of on-line schema add

----------------------------------------------------------------------------*/


{adedict/dictvar.i shared}
{adedict/brwvar.i shared}


Define var lname as char    NO-UNDO.

lname = LDBNAME("DICTDB"). /* logical name for current database */

db_record:
for each _Db NO-LOCK:
   if s_lst_Dbs:LOOKUP(_Db._Db-name) in frame browse = 0 then 
   do:
      /* If foreign (a slave) the schema holder is the current database. 
         We know we can look at schema info so put it in the list even if
         gateway type is not supported by the current executable.  If it's
         not we won't allow user to try to connect to it. (los 12/27/94)
      */
      if _Db._Db-slave then
      do:
      	 s_Res = s_lst_Dbs:add-last(_Db._Db-name) in frame browse.

      	 /* Physical name will only be set if this database is connected.
      	    Otherwise, it will be ? */
      	 {adedict/DB/cachedb.i &Lname  = _Db._Db-name
      	       	     	       &Pname  = PDBNAME(_Db._Db-name)
      	       	     	       &Holder = lname
      	       	     	       &Type   = CAPS(_Db._Db-type)}
      end.
   end.
end.

return.

