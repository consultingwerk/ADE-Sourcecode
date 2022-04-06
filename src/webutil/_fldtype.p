/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
**********************************************************************

File: _fldtype.p

Description:
    Takes a database-table-field and returns the data-type for it.    
    
    This is a wrapper routing to _fldtyp1.p that actually does the work.  This
    file just makes sure that if a dbname is specified, that DICTDB points to
    it.  

Input Parameter:   
   p_db-tbl-fld - name as triple: "db.tbl.fld" (We do handle the case of
                  "tbl.fld" by assuming DICTDB as the db.)

Output Parameter:
   p_fld_type      - The field data type

NOTE:  How to hook to a V6 Database.
   1) Start a V6 Server.
        a) rdl 6
        b) proserve db-name -H host-name -S demosv
          (eg. proserve ~stern/v6 -H kodiak -S demosv)    
   2) Connect to this in your V7 Session
        connect ~stern/v6 -H kodiak -S demosv         

Author: Wm.T.Wood

Date Created: May 1996
----------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p_db-tbl-fld AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER p_fld_type   AS CHARACTER NO-UNDO.

DEFINE VARIABLE db_name  AS CHARACTER NO-UNDO.
DEFINE VARIABLE rID      AS RECID     NO-UNDO.

/* Parse field name. (tbl.fld or db.tbl.fld) */
IF NUM-ENTRIES (p_db-tbl-fld, ".":U) eq 3 THEN DO:
  ASSIGN db_name  = ENTRY(1, p_db-tbl-fld, ".":U).
  /* Make sure that DICTDB points to the right database. */
  IF SDBNAME('DICTDB':U) ne db_name THEN
    /* Get the id of the database they picked. This will set DICTDB correctly. */ 
    RUN adecomm/_getdbid.p (db_name, OUTPUT rID).
END.

/* Run the actual workhorse file. */
RUN webutil/_fldtyp1.p (p_db-tbl-fld, OUTPUT p_fld_type).

/* end of _fldtype.p */

