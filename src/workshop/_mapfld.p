/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _mapfld.p

Description:
    Take a name (eg. "sports.customer.name") and see if it maps to a field.

    This is a wrapper routing to _fldtyp1.p that actually does the work.  This
    file just makes sure that if a dbname is specified, that DICTDB points to
    it.

Input Parameters:
   p_u_recid -- The Recid of the current _U record. 
   p_4glname -- Name from the screen to map.  Could have table name
		as well as field name.

Output Parameters:
   p_map -- indicate if db map was performed. 

Author: Wm.T.Wood 

Date Created: June 1997
---------------------------------------------------------------------------- */

DEFINE INPUT  PARAMETER p_u_recid       AS RECID     NO-UNDO.
DEFINE INPUT  PARAMETER p_4glname       AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER p_map           AS LOGICAL   NO-UNDO.

DEFINE VARIABLE db_name  AS CHARACTER NO-UNDO.
DEFINE VARIABLE rID      AS RECID     NO-UNDO.

/* Parse field name. (tbl.fld or db.tbl.fld) */
IF NUM-ENTRIES (p_4glname, ".":U) eq 3 THEN DO:
  /* Separate the DB name from the TBL.FIELD. */
  ASSIGN
    db_name   = ENTRY(1, p_4glname, ".":U)
    p_4glname = SUBSTRING(p_4glname, 1 + INDEX(p_4glname, ".":U), -1, "CHARACTER":U).
  /* Make sure that DICTDB points to the right database. */
  IF SDBNAME('DICTDB':U) ne db_name THEN DO:
    /* Is there a database with this name? */
    IF SDBNAME(db_name) eq ? THEN RETURN.

    /* Get the id of the database they picked */
    RUN adecomm/_getdbid.p (db_name, OUTPUT rID).
  END. /* IF...DICTDB...ne db_name... */
END.

/* Run the "workhorse" file. */
RUN workshop/_mapfld1.p (p_u_recid, p_4glname, OUTPUT p_map).
IF RETURN-VALUE = "Duplicate":U THEN RETURN "Duplicate":U.

RETURN.

/* _mapfld.p - end of file. */
