/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
**********************************************************************

File: _fldinfo.p

Description:
    Takes a database-table-field are returns the data-type and extent for it.
    This is a separate procedure because I was getting an error if I tried to
    run this code and a database was not connected (this was a run-time error;
    it happened even if it compiled properly).  Therefore, I could not reference
    DICTDB in any code that might run if no database were connected.

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

Author: Wm.T.Wood

Date Created: January 29, 1993

Modified:
  10/25/93 wood  Deal with case that not all DICTDB._field fields are available
                 in all databases.
----------------------------------------------------------------------------*/

DEFINE INPUT   PARAMETER    p_db-tbl-fld    AS CHARACTER  NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_label     AS CHARACTER  NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_label_sa  AS CHARACTER  NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_format    AS CHARACTER  NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_format_sa AS CHARACTER  NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_type      AS CHARACTER  NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_help      AS CHARACTER  NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_help_sa   AS CHARACTER  NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_extent    AS INTEGER 	  NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_initial   AS CHARACTER  NO-UNDO.

DEFINE VARIABLE db_name  AS CHARACTER NO-UNDO.
DEFINE VARIABLE tbl_name AS CHARACTER NO-UNDO.
DEFINE VARIABLE fld_name AS CHARACTER NO-UNDO.

/* Parse field name. (tbl.fld or db.tbl.fld) */
IF NUM-ENTRIES (p_db-tbl-fld, ".":U) eq 3 THEN DO:
  ASSIGN 
    db_name  = ENTRY(1, p_db-tbl-fld, ".":U)
    tbl_name = ENTRY(2, p_db-tbl-fld, ".":U)
    fld_name = ENTRY(3, p_db-tbl-fld, ".":U).
END.
ELSE 
  ASSIGN 
    db_name  = ?
    tbl_name = ENTRY(1, p_db-tbl-fld, ".":U)
    fld_name = ENTRY(2, p_db-tbl-fld, ".":U).

/* Get the current database field */
FIND DICTDB._db WHERE DICTDB._db._db-name =
  (IF db_name = ldbname("DICTDB":U) THEN ? ELSE db_name) NO-LOCK NO-ERROR.
IF NOT AVAILABLE DICTDB._db THEN RETURN.

FIND DICTDB._file OF DICTDB._db WHERE DICTDB._file._file-name = 
  tbl_name NO-LOCK NO-ERROR.
IF NOT AVAILABLE DICTDB._file THEN RETURN.

FIND DICTDB._field OF DICTDB._file WHERE DICTDB._field._field-name = 
  fld_name NO-LOCK NO-ERROR.
IF NOT AVAILABLE DICTDB._field THEN RETURN.

/* First get the fields that should be in all databases */ 
ASSIGN p_fld_label     = DICTDB._field._label
       p_fld_format    = DICTDB._field._format
       p_fld_type      = DICTDB._field._data-type
       p_fld_help      = DICTDB._field._help
       p_fld_extent    = DICTDB._field._extent
       p_fld_initial    = DICTDB._field._initial.

/* Now look for fields that might not be defined in all cases.  For      */
/* example, string-attributes are only available in V7 or higher.        */
/* Use CAN-FIND to determine if a database contains these values.        */
IF CAN-FIND (DICTDB._field WHERE DICTDB._field._field-name eq "_Label-SA":U)
THEN p_fld_label_sa  = DICTDB._field._Label-SA .
IF CAN-FIND (DICTDB._field WHERE DICTDB._field._field-name eq "_Format-SA":U)
THEN p_fld_format_sa = DICTDB._field._Format-SA .   
IF CAN-FIND (DICTDB._field WHERE DICTDB._field._field-name eq "_Help-SA":U)
THEN p_fld_help_sa   = DICTDB._field._Help-SA .

/* Special cases -- If values are unknown, then "correct" them.          */
/*      1) If db label is ? use db field name                            */
/*      2) Use "" if help or string attribute (or label) is unknown.     */
/*         That is, don't import the string attribute if the value is ?  */
IF p_fld_label  eq ? OR p_fld_label_sa eq ?  THEN p_fld_label_sa  = "".
IF p_fld_label  eq ?                         THEN p_fld_label     = DICTDB._field._field-name.
IF p_fld_format eq ? OR p_fld_format_sa eq ? THEN p_fld_format_sa = "".
IF p_fld_help   eq ? OR p_fld_help_sa   eq ? THEN p_fld_help_sa   = "".
IF p_fld_help   eq ?                         THEN p_fld_help      = "".

/* _fldinf1.p - end of file */

