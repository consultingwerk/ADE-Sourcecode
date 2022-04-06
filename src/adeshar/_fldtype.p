/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _fldtype.p

Description:
    Takes a database-table-field and returns the data-type for it.    
    
    This is a separate procedure because I was getting an error if I tried to
    run this code and a database was not connected (this was a run-time error;
    it happened even if it compiled properly).  Therefore, I could not reference
    DICTDB in any code that might run if no database were connected.

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
DEFINE INPUT   PARAMETER    p_db-tbl-fld    AS CHAR 		NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_type      AS CHAR 		NO-UNDO.

DEFINE VARIABLE    db_name       AS CHAR 		NO-UNDO.
DEFINE VARIABLE    tbl_name      AS CHAR 		NO-UNDO.
DEFINE VARIABLE    fld_name      AS CHAR 		NO-UNDO.

/* Parse field name. (tbl.fld or db.tbl.fld) */
IF NUM-ENTRIES (p_db-tbl-fld, ".":U) eq 3 
THEN ASSIGN db_name  = ENTRY(1, p_db-tbl-fld, ".":U)
            tbl_name = ENTRY(2, p_db-tbl-fld, ".":U)
            fld_name = ENTRY(3, p_db-tbl-fld, ".":U).
ELSE ASSIGN db_name  = ?
            tbl_name = ENTRY(1, p_db-tbl-fld, ".":U)
            fld_name = ENTRY(2, p_db-tbl-fld, ".":U).

/* Get the current database field */
FIND DICTDB._db WHERE DICTDB._db._db-name =
  (IF db_name = ldbname("DICTDB":U) THEN ? ELSE db_name)                 NO-LOCK NO-ERROR.
IF NOT AVAILABLE DICTDB._db THEN RETURN.

IF INTEGER(DBVERSION("DICTDB":U)) > 8 THEN
  FIND DICTDB._file OF DICTDB._db WHERE LOOKUP(DICTDB._FILE._OWNER,"PUB,_FOREIGN":U) > 0 AND
                                        DICTDB._file._file-name = tbl_name NO-LOCK NO-ERROR.
ELSE
  FIND DICTDB._file OF DICTDB._db WHERE DICTDB._file._file-name = tbl_name NO-LOCK NO-ERROR.

IF NOT AVAILABLE DICTDB._file THEN RETURN.

FIND DICTDB._field OF DICTDB._file WHERE DICTDB._field._field-name = fld_name NO-LOCK NO-ERROR.
IF NOT AVAILABLE DICTDB._field THEN RETURN.

ASSIGN p_fld_type      = DICTDB._field._data-type.
