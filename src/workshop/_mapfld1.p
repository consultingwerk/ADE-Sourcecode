/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _mapfld1.p

Description: Take a name (eg. "Phone" or "Customer.Phone") and try
  to map it to a database field in the current database.

Input Parameters:
   p_u_recid -- The Recid of the current _U record. 
   p_4glname -- Name from the screen to map.  Could have table name
		as well as field name. This cannot have a Database name
                (it must be set to DICTDB first).

Output Parameters:
   p_map -- indicate if db map was performed. 

Author:  Nancy E.Horn 
  
Modifications:
    Updated for foreign database handling  4/4/97  nhorn
    Added &DB=DICTDB to dbname.i           4/8/97  nhorn
    Broke file into mapfld and mapfld1.p   6/21/97 wood

Date Created: Feb. 1997
---------------------------------------------------------------------------- */

DEFINE INPUT  PARAMETER p_u_recid       AS RECID     NO-UNDO.
DEFINE INPUT  PARAMETER p_4glname       AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER p_map           AS LOGICAL   NO-UNDO.

/* Include Definitions */
{ workshop/uniwidg.i }

/* Included procedures and functions. */
{ workshop/dbname.i &DB = "DICTDB"}

DEFINE VARIABLE db-name    AS CHARACTER NO-UNDO.
DEFINE VARIABLE fld-name   AS CHARACTER NO-UNDO.
DEFINE VARIABLE table-name AS CHARACTER NO-UNDO.

DEFINE BUFFER buf_U FOR _U.

&SCOPED-DEFINE debug false
&IF {&debug} &THEN
define stream debug.
os-delete aa-mapfld.log.
&ENDIF

/* ------------------- Internal Procedures -------------------- */

/* ------------------- Main Code Block  -------------------- */
/* The _U record assignments are the same as what _chkfld.p does */
/* at submit time.  So, changes should be made in both places.   */

FIND FIRST _U WHERE RECID(_U) eq p_u_recid NO-ERROR.
IF AVAILABLE (_U) THEN DO:
  IF NUM-ENTRIES(p_4glname, ".":U) eq 2 THEN DO:
    /* Parse out Table and Field */
    ASSIGN
      table-name = ENTRY(1, p_4glname,".":U)
      fld-name   = ENTRY(2, p_4glname, ".":U).
    FIND FIRST DICTDB._file WHERE DICTDB._file._file-name eq table-name NO-ERROR.
    IF AVAILABLE DICTDB._file THEN
      FIND FIRST DICTDB._field of DICTDB._file 
        WHERE DICTDB._field._field-name eq fld-name NO-ERROR.
  END.
  ELSE IF NUM-ENTRIES(p_4glname, ".":U) = 1 THEN DO:
    Find-Loop:
    FOR EACH DICTDB._file:
      FIND FIRST DICTDB._field of DICTDB._file 
        WHERE DICTDB._field._field-name eq p_4glname NO-ERROR.
      IF AVAILABLE(DICTDB._field) THEN LEAVE Find-Loop.
    END. /* Find-Loop: FOR... */
  END. /* IF NUM-ENTRIES...2 */
  
  /* Was any field found that matches? */
  IF AVAILABLE(DICTDB._field) THEN DO:
    db-name = get-dbname(_file._db-recid).
    
    &IF {&debug} &THEN
    output stream debug to aa-mapfld.log append.
    put stream debug unformatted
      '_u._p-recid: ' _u._p-recid skip
      'recid(_u): ' recid(_u) skip
      'database: ' db-name skip
      'table: ' dictdb._file._file-name skip
      'field: ' dictdb._field._field-name skip.
       
    output stream debug close.
    &ENDIF
    
    /* Make sure we're not creating a duplicate _U record with same db.table.field. */
    FIND FIRST buf_U WHERE buf_U._P-recid eq _U._P-recid AND RECID(buf_U) ne RECID(_U) AND 
      buf_U._DBNAME eq db-name AND 
      buf_U._TABLE eq DICTDB._file._file-name AND 
      buf_U._NAME eq DICTDB._field._field-name NO-ERROR.
    IF AVAILABLE buf_U THEN RETURN "Duplicate".

    ASSIGN 
      p_map          = yes
      _U._DBNAME     = db-name
      _U._TABLE      = DICTDB._file._file-name
      _U._DEFINED-BY = "DB":U
      _U._NAME       = DICTDB._field._field-name
      _U._HELP       = DICTDB._field._help
      .
   FIND _F WHERE RECID(_F) eq _U._x-recid NO-ERROR.
   IF AVAILABLE (_F) THEN 
     ASSIGN 
       _F._DATA-TYPE     = CAPS(_field._data-type)
       _F._FORMAT        = DICTDB._field._format
       _F._FORMAT-ATTR   = DICTDB._field._format-SA
       _F._FORMAT-SOURCE = "D":U
       _F._INITIAL-DATA  = DICTDB._field._initial
       .
  END. /* if available _field */
END.  /* if _U available */

RETURN.

/* _mapfld1.p - end of file */
