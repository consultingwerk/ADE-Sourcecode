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
    Modified: 01/1995 Modified to run with PROGRESS/400 Data Dictionary
              06/19/96 D. McMann changed during update to support logical
                       database name and still display dictionary library
              06/25/97 D. McMann 97-06-06-029 Logical Name
              06/03/98 D. McMann 98-04-03-003 Changed how &Holder name is assigned

----------------------------------------------------------------------------*/


{as4dict/dictvar.i shared}
{as4dict/brwvar.i shared}


Define var lname as char    NO-UNDO.
Define var i as integer no-undo.
lname = LDBNAME("DICTDB"). /* logical name for current database */

db_record:
do i = 1 to num-dbs:
  if dbtype(i) = "AS400" THEN DO:
    IF CONNECTED(LDBNAME(i)) THEN DO:
        IF s_lst_Dbs:LOOKUP(PDBNAME(i)) in frame browse = 0 then do:
       	 s_Res = s_lst_Dbs:add-last(PDBNAME(i)) in frame browse.

       	 /* Physical name will only be set if this database is connected.
       	    Otherwise, it will be ? */
       	 {as4dict/DB/cachedb.i &Lname  = LDBNAME(i)
      	       	     	         &Pname  = PDBNAME(i)
      	       	     	         &Holder = SDBNAME(i)
      	       	     	         &Type   = CAPS(DBTYPE(i))}
     	  END.
     END.
  END.
end.

return.

