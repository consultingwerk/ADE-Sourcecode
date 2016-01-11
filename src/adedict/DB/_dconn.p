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

File: _dconn.p

Description:
   Disconnect the current database.  This has to be done in a separate
   .p file since the disconnect really only takes effect when the .p
   goes out of scope.

Author: Laura Stern

Date Created: 04/13/92 

----------------------------------------------------------------------------*/

{adedict/dictvar.i shared}
{adedict/brwvar.i shared}

Define var cnt       as integer NO-UNDO.   /* # of items in db list */
Define var ix  	     as integer NO-UNDO.   /* list index */
Define var lname     as char    NO-UNDO.   /* logical db name */


disconnect VALUE(s_CurrDb).

/* If this was a schema holder for foreign databases, these foreign dbs
   will be removed from the list as well - unless there connected themselves.
   We also have to reset the cache.  The easiest thing to do is is to clear 
   the list and the cache and re-get all dbs.  Remember the position of the 
   current db so we can reset the value of the select list at this position
   (or the next one above it that's left after the purge).
*/
ix = s_DbCache_ix.
assign
   s_lst_Dbs:LIST-ITEMS = ""
   s_DbCache_Cnt = 0
   s_DbCache_Pname = ""
   s_DbCache_Holder = ""
   s_DbCache_Type = "".

run adedict/DB/_getdbs.p.

/* Set the select list value to the database at the correct select list 
   position */
cnt = s_lst_Dbs:NUM-ITEMS in frame browse.
if ix > cnt then
   ix = cnt.

if ix > 0 then
do:
   lname = s_lst_Dbs:ENTRY(ix) in frame browse.
   s_lst_Dbs:screen-value in frame browse = lname.
   display lname @ s_DbFill with frame browse.
end.
else
   display "" @ s_DbFill with frame browse.

/* Switch to the new database.  This will reset s_CurrDb */
s_ask_gateconn = no.
run adedict/DB/_switch.p.



