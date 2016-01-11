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

/* _A4lodd -  Controlling jacket program for loading .d files   */
/*            to an AS/400 database.  This is the same load     */
/*            process (in usermenu.i) which runs from the       */
/*            dataserver utilities menu.                        */
/*  Initial creation:  May 18, 1995 - NEH                       */

{as4dict/dictvar.i shared}  
{as4dict/dump/dumpvar.i shared}
     
DEFINE VARIABLE save_db AS CHARACTER NO-UNDO.

/*  Find the correct database selected.  Preserve the one in user_dbname */
/*  Set up the recid for the correct database. */

FIND _db WHERE _db._Db-name = LDBNAME("as4dict").
  ASSIGN 
     save_db = user_dbname
     user_dbname = _Db._Db-name
     drec_db = RECID(_db).

user_path = "*N".
/* Refresh list of tables, if coming back in */
cache_dirty = yes.
user_env[1] = "s". 
RUN "prodict/gui/_guitget.p".

if user_path <> "" THEN DO ON ERROR UNDO, RETURN:
   user_env[9] = "f".
   RUN "prodict/user/_usrload.p".
END.

if user_path <> "" THEN 
   RUN "prodict/dump/_loddata.p".            

ASSIGN user_dbname = save_db.

RETURN.
