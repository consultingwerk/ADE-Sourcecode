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

File: _dblist.p

Description:
   Fill a selection list with all the databases in a given Progress database.
   Yes, this will usually only put one database in the list -- the actual
   Progress database -- but it will handle the case where the progress database
   is a schema holder and will add all the gateway dbs as well.

   IMPORTANT:  If all you are interested in schema, which is the usual
   case for this type of tool, you should only call this for PROGRESS
   databases.  You will then see all of the Progress schemas as well as 
   any gateway schema, but you will not see an additional entry
   when the gateway database is connected.  The call syntax should look
   something like this:

     /* Fill up the database selection list */
     do t_int = 1 to num-dbs:
       IF DBTYPE(t_int) = "PROGRESS" THEN
       DO:
         create alias dictdb for database VALUE(ldbname(t_int)).
         RUN adecomm/_dblist.p 
           (INPUT HANDLE(v_PickDb in frame schemapk),
           OUTPUT v_access).
       END.
     end.

Input Parameters:
  p_List    - Handle of the selection list to fill up.

Output Parameters:
   p_Stat   - Set to true if list is retrieved.

Author: Warren Bare

Date Created: 08/03/92
    Modified: 07/10/98 D. McMann Added DBVERSION and _Owner check.

----------------------------------------------------------------------------*/


DEFINE INPUT  PARAMETER p_List   AS WIDGET   NO-UNDO.
DEFINE OUTPUT PARAMETER p_Stat 	 AS LOGICAL  NO-UNDO.

DEFINE VARIABLE show_it AS LOGICAL   NO-UNDO.
DEFINE VARIABLE err     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE t_char  AS CHARACTER NO-UNDO.

/*****************  Inline code **************************/
IF INTEGER(DBVERSION("DICTDB")) > 8 THEN 
  FIND DICTDB._File WHERE DICTDB._File._File-name = "_DB"
                      AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
                      NO-LOCK.
ELSE FIND DICTDB._File "_DB" NO-LOCK.

IF NOT CAN-DO(DICTDB._File._Can-read, USERID("DICTDB")) THEN DO:
  RUN adecomm/_s-alert.p (INPUT-OUTPUT err, "i", "ok",
    "You do not have permission to see any database information.").
  p_Stat = FALSE.
  RETURN.
END.

/* Add the actual progress database */
err = p_List:add-last(LDBNAME("DICTDB")).

/* Find each gateway schema in this database. */
FOR EACH DICTDB._DB WHERE _db-type NE "PROGRESS" NO-LOCK:
  err = p_List:ADD-LAST(DICTDB._DB._db-name).
END.

p_Stat = TRUE.
RETURN.

/* _dblist.p - end of file */

