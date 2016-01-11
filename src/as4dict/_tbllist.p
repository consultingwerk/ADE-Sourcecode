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

File: tbllist.p

Description:
   Fill a selection list with tables for a given database.  This database
   must be aliased to DICTDB before this routine is called.  If the database
   is a foreign database, the schema holder database must have this alias.

Input Parameters:
   p_List   - Handle of the selection list widget to add to.
   p_Hidden - Flag - set to yes if we want hidden tables in the list, or 
      	      no to hide hidden tables.
   p_DbId   - The recid of the _Db record which corresponds to the database
      	      that we want the tables from.
   p_Type   - This is what you want in the list.  Developers can add more
      	      types as they are needed.
              ""  = just add the name of the table
              "D" = add db.table  NOTE: This will cause p_DBID to be ignored
              and all databases in this physical database will be used.

Output Parameters:
   p_Stat   - Set to true if list is retrieved (even if there were no tables
      	      this is successful).  Set to false, if user doesn't have access
      	      to tables.

Author: Laura Stern

Date Created: 06/15/92 

     History:  04/16/99 Added stored procedure support
----------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p_List   as widget-handle   NO-UNDO.
DEFINE INPUT  PARAMETER p_Hidden as logical         NO-UNDO.
DEFINE INPUT  PARAMETER p_DbId   as recid	    NO-UNDO.
DEFINE INPUT  PARAMETER p_Type   as character       NO-UNDO.
DEFINE OUTPUT PARAMETER p_Stat 	 as logical    	    NO-UNDO.

DEFINE VARIABLE err        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE v_OutItem  AS CHARACTER NO-UNDO.
DEFINE VARIABLE v_DBName   AS CHARACTER NO-UNDO.
DEFINE VARIABLE widg       AS WIDGET    NO-UNDO.

FIND DICTDB._File "_File" NO-LOCK.
IF NOT CAN-DO(DICTDB._File._Can-read, USERID("DICTDB")) THEN DO:
  MESSAGE "You do not have permission to see any table information."
    VIEW-AS ALERT-BOX ERROR buttons OK.
  p_Stat = FALSE.
  RETURN.
END.

/* Find each file in this database.  Remember, if the progress Db is 
   acting as a schema holder, files for more than one database may 
   exist in this one physical database.  */

/* it is ok if they did not pass down an id.  We will use the default db */
IF p_DbID = ? THEN /* get the id of the database they picked */
  RUN adecomm/_getdbid.p (LDBNAME("DICTDB"), OUTPUT p_DBID).

widg = p_List:parent.  	/* gives me the group */
widg = widg:parent.  	/* gives me the frame */

run adecomm/_setcurs.p ("WAIT").
FOR EACH DICTDB._DB WHERE
    /* p_Type = "D" will look in all _DB records */
    RECID(DICTDB._DB) = p_DBID OR p_Type = "D" NO-LOCK:

  v_DBName = (IF DICTDB._DB._DB-Name = ? THEN
     LDBNAME("DICTDB") ELSE DICTDB._DB._DB-Name).

  For each as4dict.p__file USE-INDEX p__Filel0 no-lock:
    IF as4dict.p__File._For-Info = "PROCEDURE" THEN NEXT.
    /* make sure we only see hidden tables when requested */
    IF p_Hidden OR (as4dict.p__File._Hidden <> "Y") THEN DO:
      CASE p_Type:
        WHEN "D" THEN v_OutItem = v_DBName + "." + as4dict.p__File._File-name.
        OTHERWISE v_OutItem = as4dict.p__File._File-name.
      END.

      /* add it to the list */
      IF (p_List:Private-data = ? OR 
      	NOT CAN-DO (p_List:Private-data, TRIM(v_OutItem))) THEN 
        err = p_List:add-last(v_OutItem).
    END.  /* end of if p_Hidden */
  END. /* end of for each dictdb._file */
END.  /* for each dictdb._db */

RUN adecomm/_setcurs.p ("").
p_Stat = TRUE.

/* _tbllist.p - end of file */

