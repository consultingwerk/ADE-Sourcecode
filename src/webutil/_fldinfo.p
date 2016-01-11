/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
**********************************************************************

File: _fldinfo.p

Description:
    Takes a database-table-field are returns the data-type and extent for it.
    
    This is a wrapper routing to _fldinf1.p that actually does the work.  This
    file just makes sure that if a dbname is specified, that DICTDB points to
    it.  

Input Parameters:
   p_db-tbl-fld - name as triple: "db.tbl.fld" (We do handle the case of
                  "tbl.fld" by assuming DICTDB as the db.)

Output Parameters:
   p_fld_label     - The field label
   p_fld_label_sa  - The field label string attributes
   p_fld_format    - The field format string
   p_fld_format_sa - The field format string attributes
   p_fld_type      - The field data type
   p_fld_help      - The field help_string
   p_fld_help_sa   - The field help string attributes
   p_fld_extent    - The field data extent

NOTE:  How to hook to a V6 Database.
   1) Start a V6 Server.
        a) rdl 6
        b) proserve db-name -H host-name -S demosv
          (eg. proserve ~stern/v6 -H kodiak -S demosv)    
   2) Connect to this in your V7 Session
        connect ~stern/v6 -H kodiak -S demosv         

Author:  M.P.Cavedon
Created: June 1997
----------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p_db-tbl-fld AS CHARACTER NO-UNDO.

DEFINE OUTPUT  PARAMETER    p_fld_label     AS CHAR 		NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_label_sa  AS CHAR 		NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_format    AS CHAR 		NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_format_sa AS CHAR 		NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_type      AS CHAR 		NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_help      AS CHAR 		NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_help_sa   AS CHAR 		NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_extent    AS INTEGER 		NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_initial   AS CHAR             NO-UNDO.

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
RUN webutil/_fldinf1.p (INPUT p_db-tbl-fld, 
                        OUTPUT p_fld_label,
                        OUTPUT p_fld_label_sa,
                        OUTPUT p_fld_format,
                        OUTPUT p_fld_format_sa,
                        OUTPUT p_fld_type,
                        OUTPUT p_fld_help,
                        OUTPUT p_fld_help_sa,
                        OUTPUT p_fld_extent,
                        OUTPUT p_fld_initial).

/* _fldinfo.p - end of file */

