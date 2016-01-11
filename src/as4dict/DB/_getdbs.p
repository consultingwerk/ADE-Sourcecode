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

File: _getdbs.p

Description:   
   This procedure gets the list of databases as follows:

   This includes:
      all connected databases and foreign databases whose schema holders
      are connected.

Shared Output:
   s_CurrDb    	  - will have been set.

Author: Laura Stern

Date Created: 01/28/92 

----------------------------------------------------------------------------*/

{as4dict/dictvar.i shared}
{as4dict/brwvar.i shared}


/*----------------------------Mainline code---------------------------------*/

Define var dbcnt   as integer NO-UNDO.
Define var lname   as char    NO-UNDO.
Define var version as char    NO-UNDO.
Define var savedb  as char    NO-UNDO.


/* Save the name of the current DICTDB database - this is the
   preferred current database.
*/
savedb = LDBNAME("DICTDB").

/* In Progress NUM-DBS is the # of connected databases and DBTYPE gives the
   type for the nth connected database. 
*/

conn_db:
do dbcnt = 1 TO NUM-DBS:
   lname = LDBNAME(dbcnt).

   /* If already in the list, skip it. */
   if s_lst_Dbs:LOOKUP(lname) in frame browse <> 0 then
      next conn_db.

   /* We can't deal with v5 or v6 databases so don't bother putting them
      in the list. */
   version = DBVERSION(dbcnt).
   if version = "5" OR version = "6" then
   do:
      if NOT CAN-DO (s_OldDbs, lname) then
      do:
	 version = "V" + version.
	 message "Database" lname "is a" version "database." SKIP
		 "The V7 dictionary cannot be used with a PROGRESS V5" SKIP
		 "or V6 database.  Use the dictionary under PROGRESS" SKIP
      	       	 "V5 or V6 to access this database." SKIP(1)
		 "(Note: Database" lname "is still connected.)"
		 view-as ALERT-BOX INFORMATION buttons OK.

      	 /* Keep track of these old connected databases so we don't keep
      	    repeating this message to the user every time they connect
      	    to a new database.
      	 */
      	 s_OldDbs = s_OldDbs + (if s_OldDbs = "" then "" else ",") + 
      	       	    lname.
      end.
      next conn_db.
   end.

   /* If the database is not Progress, the schema holder must be connected
      in order for us to work with it - so skip it, and if the schema holder
      is indeed connected, we will find the foreign db name later from the 
      _Db record of the schema holder. */
   if DBTYPE(dbcnt) <> "PROGRESS" then
      next conn_db.

   /* Now pick up foreign databases for which this db is a schema holder.
      Set DICTDB as alias for this database so we can browse the _Db recs.
   */   
   create alias "DICTDB" for database VALUE (lname) NO-ERROR.        
   
 
   /* This has to be in a separate .p - instead of an internal procedure
      because it does database access, and when this "getdbs" runs we may not
      have any connected databases.  This bends Progress all out of shape.
   */                

   run as4dict/db/_getrdbs.p.
end.

/* Restore alias DICTDB to what it was when we came in here */
if savedb <> ? then
   create alias "DICTDB" for database VALUE(savedb) NO-ERROR.    
   

