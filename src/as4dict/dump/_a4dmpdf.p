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

/* _A4dmpdf - Controlling jacket program for dumping .df files  */
/*            from an AS/400 database.  This mirrors the dump   */
/*            process (in usermenu.i) which runs from the       */
/*            dataserver utilities menu.                        */
/*  Initial creation:  May 1, 1995 - NEH                        */
/*          Modified:  10/9/97 DLM Changed assignment to        */
/*                     user_dbname 97-10-08-016                 */

{as4dict/dictvar.i shared}
{as4dict/dump/dumpvar.i shared}

DEFINE VARIABLE save_db AS CHARACTER NO-UNDO.

/*  Find the correct database selected.  Preserve the one in user_dbname */
  ASSIGN 
   save_db = user_dbname  
   user_dbname = PDBNAME("as4dict").

/* If we're coming back in, make sure the list of tables is refreshed. */
cache_dirty = yes.
user_env[1] = "a". 
RUN "as4dict/dump/_guitget.p".

if not user_cancel THEN DO:
    user_env[9] = "d".
    RUN "as4dict/dump/_usrdump.p".
END.

if not user_cancel THEN 
    RUN "as4dict/dump/_dmpsddl.p".

/* reset user cancel so user can come back in within same process */       
ASSIGN
   user_cancel = no
   user_dbname = save_db.

RETURN.
