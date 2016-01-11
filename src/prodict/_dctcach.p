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
/*

  History: D. McMann 07/09/98 Added AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
                              to FOR EACH _File.
                              
*/

                              
{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userhdr.f }

/* LANGUAGE DEPENDENCIES START */ /*---------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 1 NO-UNDO INITIAL [
  /* 1*/ "Reading Schema..."
].
/* LANGUAGE DEPENDENCIES END */ /*-----------------------------------------*/

/* Include hidden tables in list? */
DEFINE INPUT PARAMETER p_hidden AS LOGICAL NO-UNDO.

DEFINE VARIABLE c AS CHARACTER NO-UNDO.

ASSIGN
  cache_dirty = FALSE
  cache_file# = 0
  cache_file  = ""
  c           = user_hdr.  /* save it */

PAUSE 0 BEFORE-HIDE.  /* Added BEFORE-HIDE to prevent prior messages from 
                         being cleared (e.g., from _usrsget.p) in tty mode
                         (Nordhougen 07/25/95) */

{prodict/user/userhdr.i new_lang[1]}

/* For gui only, schema tables may be included in the cache for
   the table get program.
   In tty, the user must type in a schema table name.
*/
IF p_hidden
 THEN FOR EACH DICTDB._File
    WHERE DICTDB._File._Db-recid = drec_db
      AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
    BY DICTDB._File._File-name:
    ASSIGN
      cache_file# = cache_file# + 1
      cache_file[cache_file#] = DICTDB._File._File-name.
    END.
 ELSE FOR EACH DICTDB._File
    WHERE DICTDB._File._Db-recid = drec_db
      AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
      AND NOT DICTDB._File._Hidden
      BY DICTDB._File._File-name:
    ASSIGN
      cache_file# = cache_file# + 1
      cache_file[cache_file#] = DICTDB._File._File-name.
  END.

{prodict/user/userhdr.i c}  /* restore header line */

/* to refresh the db/file status line */
DISPLAY (IF user_filename = "ALL"  THEN "ALL"
    ELSE IF user_filename = "SOME" THEN "SOME"
    ELSE IF drec_file     = ?      THEN ""
    ELSE                                user_filename) 
                           @ user_filename WITH FRAME user_ftr.

RETURN.

