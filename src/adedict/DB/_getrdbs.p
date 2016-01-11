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

/*----------------------------------------------------------------------------

File: _getrdbs.p

Description:   
   Get the list of foreign databases for which the current database is a
   schema holder looking through the _Db file.

   Add each one to the cache of databases making sure that it is not
   already there.

Author: Laura Stern

Date Created: 01/28/92 

----------------------------------------------------------------------------*/


{adedict/dictvar.i shared}
{adedict/brwvar.i shared}


Define var lname as char    NO-UNDO.

lname = LDBNAME("DICTDB"). /* logical name for current database */

db_record:
for each _Db:
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

