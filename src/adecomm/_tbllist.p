/*********************************************************************
* Copyright (C) 2000,2008 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
   p_Filter - Comma delimited character string with with things (like Sybase
              Buffers) that should be filtered out.
             
Output Parameters:
   p_Stat   - Set to true if list is retrieved (even if there were no tables
      	      this is successful).  Set to false, if user doesn't have access
      	      to tables.

Author: Laura Stern

Date Created: 06/15/92 
    Modified: 04/20/98 Added logic to skip views created by SQL92 D. McMann
              05/20/98 Added logic to check DBVERSION so that code will run
                       against an 8 database. D. McMann
              07/10/98 Added logic to Check DBVERSION and _Owner on _File finds
                       D. McMann
              06/26/08 fernando Remove encryption tables from list         
----------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p_List    AS WIDGET-HANDLE   NO-UNDO.
DEFINE INPUT  PARAMETER p_Hidden  AS LOGICAL         NO-UNDO.
DEFINE INPUT  PARAMETER p_DbId    AS RECID           NO-UNDO.
DEFINE INPUT  PARAMETER p_Type    AS CHARACTER       NO-UNDO.
DEFINE INPUT  PARAMETER p_filters AS CHARACTER       NO-UNDO.
DEFINE OUTPUT PARAMETER p_Stat 	  AS LOGICAL         NO-UNDO.

DEFINE VARIABLE err        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE filtered   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE v_OutItem  AS CHARACTER NO-UNDO.
DEFINE VARIABLE v_DBName   AS CHARACTER NO-UNDO.
DEFINE VARIABLE widg       AS WIDGET    NO-UNDO.

&SCOPED-DEFINE  INVALID_SCHEMA_TABLES "_sec-db-policy,_sec-obj-policy,_sec-pwd-policy":U

IF INTEGER(DBVERSION("DICTDB":u)) > 8 THEN 
  FIND DICTDB._File WHERE DICTDB._File._File-name = "_File":u
                      AND DICTDB._File._Owner = "PUB":u
                      NO-LOCK.
ELSE                      
  FIND DICTDB._File "_File":u NO-LOCK.
  
IF NOT CAN-DO(DICTDB._File._Can-Read, USERID("DICTDB":u)) THEN DO:
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
  RUN adecomm/_getdbid.p (LDBNAME("DICTDB":u), OUTPUT p_DBID).

ASSIGN
  widg = p_List:parent 	/* gives me the group */
  widg = widg:parent.  	/* gives me the frame */

RUN adecomm/_setcurs.p ("WAIT":u).

FOR EACH DICTDB._DB WHERE
    /* p_Type = "D" will look in all _DB records */
    RECID(DICTDB._DB) = p_DBID OR p_Type = "D":u NO-LOCK:

  v_DBName = (IF DICTDB._DB._DB-Name = ? THEN
     LDBNAME("DICTDB":u) ELSE DICTDB._DB._DB-Name).

  FOR EACH DICTDB._File FIELDS(_File-num _File-name _Owner _Hidden _Tbl-type) OF DICTDB._DB
      WHERE CAN-DO(DICTDB._File._Can-Read, USERID("DICTDB":u)) NO-LOCK:
    IF INTEGER(DBVERSION("DICTDB":u)) > 8  AND DICTDB._File._Tbl-type = "V"
      THEN NEXT.
      
    IF INTEGER(DBVERSION("DICTDB":u)) > 8 AND (DICTDB._File._Owner <> "PUB":u AND DICTDB._File._Owner <> "_FOREIGN":u)
       THEN NEXT.
        
    /* make sure we only see hidden tables when requested */
    IF (p_Hidden OR (NOT DICTDB._File._Hidden)) THEN DO:

      /* Check filters - currently only the Sybase buffer filter is available */
      IF p_Filters = "":U THEN filtered = FALSE.
      ELSE DO:
        /* Since the file structure for V6 is different from V7 we must call */
        /* The correct version of _is_buffx.p                                */
        IF INTEGER(DBVERSION("DICTDB")) < 7 THEN
          RUN adecomm/_filter6.p (INPUT RECID(DICTDB._FILE),
                                  p_Filters,
                                  OUTPUT filtered).
        ELSE
          RUN adecomm/_filter7.p (INPUT RECID(DICTDB._FILE),
                                  p_Filters,
                                  OUTPUT filtered).
      END.

      /* filter these schema tables out (hidden) */
      IF DICTDB._File._Hidden AND CAN-DO({&INVALID_SCHEMA_TABLES},DICTDB._File._File-name) THEN
          filtered = TRUE.

      IF NOT filtered OR filtered = ? THEN DO:
        CASE p_Type:
          WHEN "D":u THEN v_OutItem = v_DBName + ".":u + DICTDB._File._File-name.
          OTHERWISE v_OutItem = DICTDB._File._File-name.
        END.

        /* add it to the list */
        IF (p_List:PRIVATE-DATA = ? OR 
        	NOT CAN-DO (p_List:PRIVATE-DATA, TRIM(v_OutItem))) THEN 
          err = p_List:ADD-LAST(v_OutItem).
      END.  /* Get this file name */
    END.  /* end of if p_Hidden */
  END. /* end of for each dictdb._file */
END.  /* for each dictdb._db */

RUN adecomm/_setcurs.p ("").
p_Stat = TRUE.

/* _tbllist.p - end of file */




