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
**********************************************************************

File: _fldtype.p

Description:
    Takes a database-table-field and returns the data-type for it.    
    
    DICTDB is assumed to be connected and pointing to the database
    specified in "db". (The wrapper file "_fldtype.p" actually does
    this.

Input Parameter:   
   p_db-tbl-fld - name as triple: "db.tbl.fld" (We do handle the case of
                  "tbl.fld" by assuming DICTDB as the db.)

Output Parameter:
   p_fld_type      - The field data type

Author:  Wm.T.Wood
Created: May 1996
----------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p_db-tbl-fld AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER p_fld_type   AS CHARACTER NO-UNDO.

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

ASSIGN p_fld_type = DICTDB._field._data-type.

/* _fldtyp1.p - end of file */

