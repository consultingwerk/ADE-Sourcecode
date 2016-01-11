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

/* _A4dmpsv - Controlling jacket program for dumping sequence   */
/*            values from an AS/400 database.  This mirrors     */
/*            the dump process (in usermenu.i) which runs from  */
/*            the dataserver utilities menu.                    */
/*  Initial creation:  May 30, 1995 - Nhorn                     */

/*
    History:  01/11/00 D. McMann Added check to see if there are any
                                 sequences before going on
*/                                 

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

IF NOT CAN-FIND(First as4dict.p__seq) THEN DO:
  Message "There are no sequences to dump ".
  RETURN.
END.

user_env[9] = "k".
RUN "as4dict/dump/_usrdump.p".

if not user_cancel THEN
    RUN "as4dict/dump/_dmpseqs.p".

/* reset user cancel so user can come back in within same process */       
ASSIGN
   user_cancel = no
   user_dbname = save_db.

RETURN.
