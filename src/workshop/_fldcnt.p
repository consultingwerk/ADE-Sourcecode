/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _fldcnt.p

Description:

Input Parameters:
   p_u_recid -- The RECID of the current _U record. 
   p_4glname -- Field name from the screen to map.  Could be table.name.
                This file does NOT support db.tbl.name.

Output Parameters:
   p_counter -- Count of occurances of this field.
   
Author:  D.M.Adams
  
Date Created: May 1997
---------------------------------------------------------------------------- */

DEFINE INPUT        PARAMETER p_u_recid    AS RECID     NO-UNDO.
DEFINE INPUT        PARAMETER p_4glname    AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_counter    AS INTEGER   NO-UNDO.

/* Include Definitions */
{ workshop/sharvars.i }
{ workshop/uniwidg.i }

DEFINE VARIABLE fld-name   AS CHARACTER NO-UNDO.
DEFINE VARIABLE table-name AS CHARACTER NO-UNDO.

/* ------------------- Internal Procedures -------------------- */

/* ------------------- Main Code Block  -------------------- */
FIND FIRST _U WHERE RECID(_U) eq p_u_recid NO-ERROR.
IF AVAILABLE (_U) THEN DO:
  IF NUM-ENTRIES(p_4glname, ".":U) = 2 THEN DO:
    /* Parse out Table and Field */
    ASSIGN
      table-name = ENTRY(1,p_4glname,".":U)
      fld-name   = ENTRY(2,p_4glname,".":U).
      
    FIND FIRST DICTDB._file WHERE DICTDB._file._file-name eq table-name NO-ERROR.
    IF AVAILABLE (DICTDB._file) THEN DO:
      IF CAN-FIND(FIRST DICTDB._field OF DICTDB._file WHERE DICTDB._field._field-name eq fld-name) THEN DO:
        p_counter = p_counter + 1.
        RETURN.
      END.
    END.
  END.  /* if num-entries = 2 */
  
  ELSE IF NUM-ENTRIES(p_4glname, ".":U) = 1 THEN DO:
    FOR EACH DICTDB._file:
      IF CAN-FIND(FIRST DICTDB._field OF DICTDB._file WHERE DICTDB._field._field-name eq p_4glname) THEN
        p_counter = p_counter + 1.
    END. 
  END.  /* if num-entries = 1 */
END.  /* If _U available */

/* _fldcnt.p - end of file */

